/**
 * What deleteAccount removes of MUSQ Friends (see friends.ts for the
 * layout): the profile and its code, every friendship (both sides, as one
 * doc), requests and declines either way, the member's feed events, their
 * reactions on others' events, nudges to and from them, their nudge and
 * code-lookup counters, blocks either way and the reports they filed, and
 * their photo check-ins (posts, photos, comments, reactions, inbox).
 * Reports about them lose the subject uid and the reported name and avatar,
 * keeping only the reason, date and status (anonymous, for the owner).
 *
 * The profile goes first, on its own: every call that creates a friendship,
 * a request or a feed event checks the profile in its transaction, so none
 * can name the member once it's gone. A second sweep then catches anything
 * a call that had already read the profile wrote meanwhile.
 *
 * Photo check-ins can be many (hundreds of posts and received copies), so
 * they run in parallel against `deadline`: a photoCleanups "account" job is
 * committed with the profile delete, and whatever isn't done by then (or
 * fails) is finished by friendsPhotoSweep within minutes, while
 * deleteAccount goes on to delete the Auth account.
 */
import { FieldPath, FieldValue, type Firestore, type Query } from "firebase-admin/firestore";
import { COL } from "./friends.js";
import { REACTIONS } from "./friendsRules.js";
import { logger } from "firebase-functions/v2";
import { cleanupJob, cleanupRef, deletePhotoData, firebaseStore, type PhotoStore } from "./friendsPhotos.js";

/** Every query whose matches are deleted outright (exported for tests). */
export function friendsDeleteQueries(db: Firestore, uid: string): Query[] {
  return [
    db.collection(COL.codes).where("uid", "==", uid),
    db.collection(COL.friendships).where("uids", "array-contains", uid),
    db.collection(COL.requests).where("from", "==", uid),
    db.collection(COL.requests).where("to", "==", uid),
    db.collection(COL.declines).where("from", "==", uid),
    db.collection(COL.declines).where("to", "==", uid),
    db.collection(COL.events).where("uid", "==", uid),
    db.collection(COL.nudges).where("from", "==", uid),
    db.collection(COL.nudges).where("to", "==", uid),
    db.collection(COL.blocks).where("by", "==", uid),
    db.collection(COL.blocks).where("uid", "==", uid),
    db.collection(COL.reports).where("reporter", "==", uid),
  ];
}

export async function deleteFriendsData(db: Firestore, uid: string, store: PhotoStore = firebaseStore(), deadline = Infinity): Promise<number> {
  // The profile and its code first, committed, so no new friendship,
  // request or event can name the member (they all need the profile).
  const profileRef = db.doc(`${COL.profiles}/${uid}`);
  const profile = await profileRef.get();
  const code = profile.get("code");
  const first = db.batch();
  if (typeof code === "string" && code) {
    const codeDoc = await db.doc(`${COL.codes}/${code}`).get();
    if (codeDoc.get("uid") === uid) first.delete(codeDoc.ref);
  }
  first.delete(profileRef);
  first.delete(db.doc(`${COL.nudgeCounters}/${uid}`));
  first.delete(db.doc(`${COL.requestCounters}/${uid}`));
  const jobRef = cleanupRef(db, "account", uid);
  first.set(jobRef, cleanupJob("account", uid, null, Date.now()));
  await first.commit();

  const count = await sweep(db, uid);
  // A transaction that read the profile just before it went may have
  // written after the sweep's queries ran: once more for those.
  await sweep(db, uid);
  // Photo check-ins: their posts (copies and photos), comments, reactions,
  // inbox and counter (friendsPhotos.ts). Reports go with the sweep above.
  try {
    const photos = await deletePhotoData(db, uid, store, deadline);
    if (photos.complete) await jobRef.delete();
    else logger.info("deleteAccount: photo cleanup left for the sweep");
    return count + photos.count;
  } catch (error) {
    logger.warn("deleteAccount: photo cleanup unfinished, left for the sweep", { error: String(error) });
    return count;
  }
}

async function sweep(db: Firestore, uid: string): Promise<number> {
  const writer = db.bulkWriter();
  const failures: unknown[] = [];
  const track = (write: Promise<unknown>) => void write.catch((error: unknown) => failures.push(error));
  let count = 0;
  const [deletions, reacted, reportedOn] = await Promise.all([
    Promise.all(friendsDeleteQueries(db, uid).map((q) => q.select().get())),
    db.collection(COL.events).where(new FieldPath("reactions", uid), "in", [...REACTIONS]).select().get(),
    db.collection(COL.reports).where("subject", "==", uid).select().get(),
  ]);
  const deleted = new Set<string>();
  for (const snap of deletions) {
    for (const doc of snap.docs) {
      if (deleted.has(doc.ref.path)) continue;
      deleted.add(doc.ref.path);
      track(writer.delete(doc.ref));
      count++;
    }
  }
  for (const doc of reacted.docs) {
    if (!deleted.has(doc.ref.path)) track(writer.update(doc.ref, new FieldPath("reactions", uid), FieldValue.delete()));
  }
  for (const doc of reportedOn.docs) {
    if (deleted.has(doc.ref.path)) continue;
    track(writer.update(doc.ref, {
      subject: FieldValue.delete(), subjectName: FieldValue.delete(), subjectEmoji: FieldValue.delete(),
      // Photo reports: the reported caption or comment and the photo's path.
      subjectText: FieldValue.delete(), imagePath: FieldValue.delete(),
    }));
  }
  await writer.close();
  if (failures.length > 0) throw failures[0];
  return count;
}
