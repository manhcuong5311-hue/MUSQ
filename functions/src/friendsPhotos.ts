/**
 * MUSQ Friends photo check-ins (owner request 2026-11-28, Locket-like): a
 * member snaps a casual photo (never the AI goal photo), with an optional
 * caption and a workout tag; their friends see it in the feed (and a ring on
 * the poster's avatar for 24 hours, worked out by the app from createdAt),
 * react and comment, live. Posts last 30 days, like feed events.
 *
 * Every write goes through these callables (same sign-in, Sign in with Apple
 * and App Check checks as friends.ts): validation, OpenAI moderation of the
 * photo and of every caption and comment BEFORE anyone else can see it, and
 * daily limits (10 photos, 100 comments, 300 reaction changes). The app READS live with Firestore
 * snapshot listeners, but only documents under its own uid: the server fans
 * out a copy of each post and comment to every reader (the poster and the
 * friends they had when posting, at most 51) and keeps those copies in step
 * on react, comment, delete, report, unfriend, block and account deletion.
 * firestore.rules lets a member read friendInbox/{their uid}/** and nothing
 * else. Readable copies carry no uid: authors are the opaque friend id the
 * reader already knows (friendsRules.ts pairId; another friend of the poster
 * the reader isn't friends with gets the same kind of hash, which they can't
 * use), or "me" with isMine true.
 *
 * Photos: Cloud Storage, one private object per post, friendPhotos/{postId}.jpg,
 * written only by the server (metadata stripped again, friendsPhotosRules.ts).
 * storage.rules lets a signed-in member read it only while their own inbox
 * holds that post (firestore.exists on friendInbox/{uid}/posts/{postId}), so
 * unfriending, a block, a report or a delete cuts access at once. The app
 * reads it with the Storage SDK's getData or the REST endpoint with its ID
 * token; never getDownloadURL, which would mint a token that skips the rules.
 *
 * Nothing here holds Apple Health data. Photos are seen only by friends.
 *
 * Firestore layout (server-only unless marked readable):
 * - friendPhotos/{postId}: uid, displayName, emoji, caption, tag, imagePath,
 *   width, height, createdAt, expireAt (+30 days), reactions {uid: emoji},
 *   commentCount, recipients [uid] (who holds a copy now), reporters [uid],
 *   hidden (reported by 2+ friends: only the poster still sees it, marked)
 * - friendPhotoComments/{commentId}: postId, postUid, uid, displayName, emoji,
 *   text, createdAt, expireAt (the post's), recipients [uid] (who got a copy:
 *   the post's readers at the time, minus blocks either way)
 * - photoCounters/{uid}: day (UTC), posts, comments, reactions, expireAt (+2 days)
 * - photoCleanups/{kind-id}: kind "unlink" | "block" | "account", a, b (uids),
 *   createdAt: the copies still to take away after an unfriend, a block or
 *   an account deletion. Written in the same commit as the friendship
 *   delete, the block or the profile delete; the call then does the work
 *   (in parallel, against a deadline) and deletes the job when done. What a
 *   call couldn't finish in time (or a crash) is finished by
 *   friendsPhotoSweep, every 10 minutes, so a retry that can no longer find
 *   the friendship is never needed.
 * - friendReports/{reportId}: as in friends.ts, plus type "post" | "comment",
 *   postId, commentId, subjectText (caption or comment), imagePath
 * READABLE by request.auth.uid == {uid} (Swift mirrors: Services/Friends/FriendsPhotosModels.swift):
 * - friendInbox/{uid}/posts/{postId}: PostCopy below
 * - friendInbox/{uid}/posts/{postId}/comments/{commentId}: CommentCopy below
 *
 * PostCopy {
 *   id: string (postId, 32 hex), authorId: string ("me" | opaque friend id),
 *   isMine: bool, displayName: string, emoji: string,
 *   caption: string | null (≤ 120), tag: string | null (≤ 60),
 *   imagePath: string ("friendPhotos/{id}.jpg"), width: int, height: int,
 *   createdAt: Timestamp, expireAt: Timestamp,
 *   reactions: {"🔥": n, "💪": n, "👏": n, "❤️": n}, myReaction: string | null,
 *   commentCount: int (comments this reader can see), hidden: bool
 * }
 * CommentCopy {
 *   id: string (32 hex), postId: string, authorId: string ("me" | opaque),
 *   isMine: bool, displayName: string, emoji: string, text: string (≤ 300),
 *   createdAt: Timestamp, expireAt: Timestamp
 * }
 * Callables return the same shapes with createdAt/expireAt as ISO 8601
 * strings: friendsPhotoPost → {post}, friendsCommentAdd → {comment}, the
 * rest → {}. The app should drop items whose expireAt has passed (TTL
 * deletes them within a day or so after).
 *
 * friendsPhotoSweep (scheduled, every 10 minutes) also deletes posts older
 * than 30 days with deletePost, the photo file included, and any
 * friendPhotos/ file older than 31 days whose post TTL removed first, so no
 * photo outlives the retention the privacy policy states (TTL alone only
 * removes documents).
 *
 * Blocking from a comment: a commenter who isn't the reader's friend (a
 * friend of the poster) can be blocked with friendsBlock {postId,
 * commentId} (friends.ts block, commentAuthor below): the server finds the
 * author from the comment the reader holds (or reported).
 *
 * Known limits (v1): a friend added after a post doesn't get it; a renamed
 * profile shows the old name on posts and comments made before. After an
 * unfriend, comments already written stay where they are, and each still
 * sees the other's comments on a friend they share's posts (as for any two
 * friends of the poster); Block hides those too.
 */
import { FieldPath, FieldValue, Timestamp, getFirestore, type DocumentData, type DocumentReference, type DocumentSnapshot, type Firestore, type QueryDocumentSnapshot, type Transaction } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { logger } from "firebase-functions/v2";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { REGION, mockOpenAI } from "./config.js";
import { OPENAI_API_KEY, moderationFlagged } from "./openai.js";
import { Reason } from "./reasons.js";
import { REACTIONS, pairId, readId, readReaction, reportId, utcDay } from "./friendsRules.js";
import {
  DAILY_LIMIT, HIDE_AFTER_REPORTS, MAX_RECIPIENTS, POST_TTL_DAYS, counted, counterAfter, newId, photoPath, readCaption,
  readComment, readPhoto, readPhotoReportReason, readTag, type CounterKind,
} from "./friendsPhotosRules.js";
// Only used inside handlers (friends.ts imports this module for its hooks).
import { requireFriendsUser } from "./friends.js";

const DAY_MS = 24 * 60 * 60 * 1000;

/** Collection names (friends.ts COL for the ones it owns; repeated here so
 *  this module needs nothing from friends.ts while it loads). */
export const PCOL = {
  posts: "friendPhotos",
  comments: "friendPhotoComments",
  counters: "photoCounters",
  inbox: "friendInbox",
  profiles: "friendProfiles",
  friendships: "friendships",
  blocks: "friendBlocks",
  reports: "friendReports",
  cleanups: "photoCleanups",
} as const;

/** How many posts or comments a cleanup works on at once. */
const PARALLEL = 12;
/** How long friendsRemove/friendsBlock (20 s callables) spend on the photo
 *  copies before leaving the rest to friendsPhotoSweep. */
export const INLINE_CLEANUP_MS = 12_000;

// MARK: - Dependencies (real ones in the callables, fakes in tests)

export interface PhotoStore {
  save(path: string, jpeg: Buffer): Promise<void>;
  remove(path: string): Promise<void>;
  /** Deletes files under `prefix` created before `cutoff` (ms); how many. */
  removeOlderThan?(prefix: string, cutoff: number): Promise<number>;
}

/** True when the texts or the photo are flagged. Throws when it can't tell. */
export type Moderator = (texts: string[], jpeg?: Buffer) => Promise<boolean>;

export interface Deps { store: PhotoStore; moderate: Moderator }

/** The project's default bucket. No download token is ever set, so only
 *  storage.rules decide who reads. */
export function firebaseStore(): PhotoStore {
  return {
    async save(path, jpeg) {
      await getStorage().bucket().file(path).save(jpeg, {
        resumable: false,
        contentType: "image/jpeg",
        // Not kept by HTTP caches: the app keeps its own copy and drops it
        // when access ends (FriendsPhotoService).
        metadata: { cacheControl: "private, no-store" },
      });
    },
    async remove(path) {
      await getStorage().bucket().file(path).delete({ ignoreNotFound: true });
    },
    async removeOlderThan(prefix, cutoff) {
      const bucket = getStorage().bucket();
      let removed = 0;
      let pageToken: string | undefined;
      do {
        const [files, next] = await bucket.getFiles({ prefix, autoPaginate: false, maxResults: 500, pageToken });
        const old = files.filter((f) => {
          const created = Date.parse(String(f.metadata.timeCreated ?? ""));
          return Number.isFinite(created) && created < cutoff;
        });
        await Promise.all(old.map((f) => f.delete({ ignoreNotFound: true })));
        removed += old.length;
        pageToken = (next as { pageToken?: string } | null | undefined)?.pageToken;
      } while (pageToken);
      return removed;
    },
  };
}

/** OpenAI moderation; in the emulator with MOCK_OPENAI=1, anything with
 *  "[flag]" in a text is flagged and the rest passes. */
export const openAIModerator: Moderator = async (texts, jpeg) => {
  if (mockOpenAI()) return texts.some((t) => t.includes("[flag]"));
  try {
    return await moderationFlagged(texts, jpeg);
  } catch (error) {
    logger.error("friends moderation unavailable", { error: String(error) });
    throw new HttpsError("unavailable", Reason.ai);
  }
};

// MARK: - Helpers

const obj = (data: unknown) => (data && typeof data === "object" ? data : {}) as Record<string, unknown>;
const ms = (t: unknown): number => (t instanceof Timestamp ? t.toMillis() : 0);
const strings = (v: unknown): string[] => (Array.isArray(v) ? v.filter((x): x is string => typeof x === "string") : []);
const notFound = () => new HttpsError("not-found", Reason.friendNotFound);

const postRef = (db: Firestore, id: string) => db.doc(`${PCOL.posts}/${id}`);
const commentRef = (db: Firestore, id: string) => db.doc(`${PCOL.comments}/${id}`);
export const inboxPostRef = (db: Firestore, uid: string, postId: string) => db.doc(`${PCOL.inbox}/${uid}/posts/${postId}`);
export const inboxCommentRef = (db: Firestore, uid: string, postId: string, commentId: string) =>
  db.doc(`${PCOL.inbox}/${uid}/posts/${postId}/comments/${commentId}`);

/** The author as `reader` sees them. */
function authorFor(reader: string, author: string) {
  return reader === author ? { authorId: "me", isMine: true } : { authorId: pairId(reader, author), isMine: false };
}

function reactionCounts(reactions: unknown): Record<string, number> {
  const counts: Record<string, number> = Object.fromEntries(REACTIONS.map((r) => [r, 0]));
  for (const value of Object.values(obj(reactions))) if (typeof value === "string" && value in counts) counts[value]++;
  return counts;
}

/** A post as stored (friendPhotos), read. */
interface Post {
  id: string; uid: string; displayName: string; emoji: string; caption: string | null; tag: string | null;
  imagePath: string; width: number; height: number; createdAt: Timestamp; expireAt: Timestamp;
  reactions: Record<string, unknown>; recipients: string[]; reporters: string[]; hidden: boolean;
}

function readPost(snap: DocumentSnapshot): Post | undefined {
  if (!snap.exists) return undefined;
  const d = snap.data() as DocumentData;
  return {
    id: snap.id, uid: String(d.uid), displayName: String(d.displayName ?? ""), emoji: String(d.emoji ?? ""),
    caption: typeof d.caption === "string" ? d.caption : null, tag: typeof d.tag === "string" ? d.tag : null,
    imagePath: String(d.imagePath ?? photoPath(snap.id)), width: Number(d.width ?? 0), height: Number(d.height ?? 0),
    createdAt: d.createdAt as Timestamp, expireAt: d.expireAt as Timestamp,
    reactions: obj(d.reactions), recipients: strings(d.recipients), reporters: strings(d.reporters), hidden: d.hidden === true,
  };
}

/** A post `uid` may see and act on now: live, not hidden, and theirs to read. */
function visiblePost(post: Post | undefined, uid: string, now: number): Post {
  if (!post || post.hidden || ms(post.expireAt) <= now || !post.recipients.includes(uid)) throw notFound();
  return post;
}

function postCopy(post: Post, reader: string, commentCount: number): DocumentData {
  const mine = post.reactions[reader];
  return {
    id: post.id, ...authorFor(reader, post.uid), displayName: post.displayName, emoji: post.emoji,
    caption: post.caption, tag: post.tag, imagePath: post.imagePath, width: post.width, height: post.height,
    createdAt: post.createdAt, expireAt: post.expireAt, reactions: reactionCounts(post.reactions),
    myReaction: typeof mine === "string" ? mine : null, commentCount, hidden: post.hidden && reader === post.uid,
  };
}

interface Comment {
  id: string; postId: string; postUid: string; uid: string; displayName: string; emoji: string; text: string;
  createdAt: Timestamp; expireAt: Timestamp; recipients: string[];
}

function readCommentDoc(snap: DocumentSnapshot): Comment | undefined {
  if (!snap.exists) return undefined;
  const d = snap.data() as DocumentData;
  return {
    id: snap.id, postId: String(d.postId), postUid: String(d.postUid ?? ""), uid: String(d.uid),
    displayName: String(d.displayName ?? ""), emoji: String(d.emoji ?? ""), text: String(d.text ?? ""),
    createdAt: d.createdAt as Timestamp, expireAt: d.expireAt as Timestamp, recipients: strings(d.recipients),
  };
}

function commentCopy(c: Comment, reader: string): DocumentData {
  return {
    id: c.id, postId: c.postId, ...authorFor(reader, c.uid), displayName: c.displayName, emoji: c.emoji, text: c.text,
    createdAt: c.createdAt, expireAt: c.expireAt,
  };
}

/** A copy as a callable returns it: times as ISO strings. */
function forApp(copy: DocumentData): DocumentData {
  const out: DocumentData = { ...copy };
  for (const key of ["createdAt", "expireAt"]) if (out[key] instanceof Timestamp) out[key] = (out[key] as Timestamp).toDate().toISOString();
  return out;
}

async function profileOf(db: Firestore, uid: string, tx?: Transaction) {
  const ref = db.doc(`${PCOL.profiles}/${uid}`);
  const snap = tx ? await tx.get(ref) : await ref.get();
  if (!snap.exists) throw new HttpsError("failed-precondition", Reason.friendProfile);
  return { displayName: String(snap.get("displayName") ?? ""), emoji: String(snap.get("emoji") ?? "") };
}

/** Takes one of today's posts or comments (committed on its own, so a
 *  rejected photo or comment still counts and the moderator can't be
 *  spammed); refuses once today's are used. */
async function takeUnit(db: Firestore, uid: string, kind: CounterKind, now: number) {
  const today = utcDay(now);
  await db.runTransaction(async (tx) => {
    const ref = db.doc(`${PCOL.counters}/${uid}`);
    const data = (await tx.get(ref)).data();
    const n = counted(data, kind, today);
    if (n >= DAILY_LIMIT[kind]) throw new HttpsError("resource-exhausted", LIMIT_REASON[kind]);
    tx.set(ref, { ...counterAfter(data, kind, today), expireAt: Timestamp.fromMillis(now + 2 * DAY_MS) });
  });
}

const LIMIT_REASON: Record<CounterKind, string> = {
  posts: Reason.photoLimit, comments: Reason.commentLimit, reactions: Reason.reactionLimit,
};

/** Gives a unit back when the server failed (not when moderation said no). */
async function giveBack(db: Firestore, uid: string, kind: CounterKind, now: number) {
  const today = utcDay(now);
  await db.runTransaction(async (tx) => {
    const ref = db.doc(`${PCOL.counters}/${uid}`);
    const n = counted((await tx.get(ref)).data(), kind, today);
    if (n > 0) tx.update(ref, { [kind]: n - 1 });
  }).catch(() => undefined);
}

/** Deletes inbox post copies' comment subcollections (and the copies, if a
 *  transaction left them), after the transaction took them off the post. */
async function cleanupCopies(db: Firestore, copies: DocumentReference[]) {
  await Promise.all(copies.map((ref) => db.recursiveDelete(ref)));
}

// MARK: - Handlers (db, uid, data, deps, now) → result

export async function photoPost(db: Firestore, uid: string, data: unknown, deps: Deps, now = Date.now()) {
  const d = obj(data);
  const photo = readPhoto(d.imageBase64);
  const caption = readCaption(d.caption);
  const tag = readTag(d.tag);
  await profileOf(db, uid);
  await takeUnit(db, uid, "posts", now);
  let flagged: boolean;
  try {
    flagged = await deps.moderate([caption ?? "", tag ?? ""], photo.jpeg);
  } catch (error) {
    await giveBack(db, uid, "posts", now);
    throw error;
  }
  if (flagged) {
    // Say which: a flagged caption (or tag) asks for other words, not
    // another photo. Only on this rare path does the text go alone.
    const texts = [caption, tag].filter((t): t is string => !!t);
    const textFlagged = texts.length > 0 && await deps.moderate(texts).catch(() => false);
    logger.info("friends photo rejected by moderation", { text: textFlagged });
    throw new HttpsError("failed-precondition", textFlagged ? Reason.friendTextRejected : Reason.friendPhotoRejected);
  }
  const id = newId();
  const imagePath = photoPath(id);
  await deps.store.save(imagePath, photo.jpeg);
  try {
    const post = await db.runTransaction(async (tx) => {
      const me = await profileOf(db, uid, tx);
      const friendships = await tx.get(db.collection(PCOL.friendships).where("uids", "array-contains", uid).limit(MAX_RECIPIENTS + 10));
      const others = friendships.docs.flatMap((doc) => strings(doc.get("uids")).filter((u) => u !== uid));
      // Friends deleting their account (profile gone) don't get it.
      const profiles = others.length ? await tx.getAll(...others.map((o) => db.doc(`${PCOL.profiles}/${o}`))) : [];
      const live = profiles.filter((p) => p.exists).map((p) => p.id);
      const recipients = [uid, ...live].slice(0, MAX_RECIPIENTS);
      const createdAt = Timestamp.fromMillis(now);
      const expireAt = Timestamp.fromMillis(now + POST_TTL_DAYS * DAY_MS);
      const stored = {
        uid, displayName: me.displayName, emoji: me.emoji, caption, tag, imagePath, width: photo.width, height: photo.height,
        createdAt, expireAt, reactions: {}, commentCount: 0, recipients, reporters: [], hidden: false,
      };
      tx.set(postRef(db, id), stored);
      const p: Post = { id, ...stored };
      for (const r of recipients) tx.set(inboxPostRef(db, r, id), postCopy(p, r, 0));
      return p;
    });
    logger.info("friends photo posted", { postId: id, recipients: post.recipients.length });
    return { post: forApp(postCopy(post, uid, 0)) };
  } catch (error) {
    await deps.store.remove(imagePath).catch(() => undefined);
    if (!(error instanceof HttpsError)) await giveBack(db, uid, "posts", now);
    throw error;
  }
}

/** Removes a post everywhere: every copy (with its comments), its comments,
 *  its photo and the post. Used by delete and by account deletion. */
export async function deletePost(db: Firestore, store: PhotoStore, postId: string) {
  const removed = await db.runTransaction(async (tx) => {
    const post = readPost(await tx.get(postRef(db, postId)));
    if (!post) return undefined;
    const copies = post.recipients.map((r) => inboxPostRef(db, r, postId));
    for (const ref of copies) tx.delete(ref);
    tx.delete(postRef(db, postId));
    return { post, copies };
  });
  if (!removed) return;
  const comments = async () => {
    const snap = await db.collection(PCOL.comments).where("postId", "==", postId).select().get();
    const writer = db.bulkWriter();
    for (const doc of snap.docs) void writer.delete(doc.ref).catch(() => undefined);
    await writer.close();
  };
  await Promise.all([cleanupCopies(db, removed.copies), comments(), store.remove(removed.post.imagePath)]);
}

export async function photoDelete(db: Firestore, uid: string, data: unknown, deps: Deps) {
  const postId = readId(obj(data).postId, "postId");
  const post = readPost(await postRef(db, postId).get());
  if (!post || post.uid !== uid) throw notFound();
  await deletePost(db, deps.store, postId);
  return {};
}

/** Sets the copies' counts after a reaction changed (in the transaction). */
function writeReactions(db: Firestore, tx: Transaction, post: Post, changed: string[]) {
  const counts = reactionCounts(post.reactions);
  for (const r of post.recipients) {
    const mine = post.reactions[r];
    tx.update(inboxPostRef(db, r, post.id), {
      reactions: counts, ...(changed.includes(r) ? { myReaction: typeof mine === "string" ? mine : null } : {}),
    });
  }
}

/** Sets or clears the member's reaction. Each change rewrites every
 *  reader's copy, so changes count against a daily limit (300); sending the
 *  reaction the member already has changes and counts nothing. */
export async function photoReact(db: Firestore, uid: string, data: unknown, _deps?: Deps, now = Date.now()) {
  const d = obj(data);
  const postId = readId(d.postId, "postId");
  const emoji = readReaction(d.emoji);
  const today = utcDay(now);
  await db.runTransaction(async (tx) => {
    const counterRef = db.doc(`${PCOL.counters}/${uid}`);
    const [snap, counter] = await Promise.all([tx.get(postRef(db, postId)), tx.get(counterRef)]);
    const post = visiblePost(readPost(snap), uid, now);
    await profileOf(db, uid, tx);
    const before = post.reactions[uid];
    if ((before ?? null) === (emoji ?? null)) return;
    const used = counted(counter.data(), "reactions", today);
    if (used >= DAILY_LIMIT.reactions) throw new HttpsError("resource-exhausted", Reason.reactionLimit);
    tx.set(counterRef, { ...counterAfter(counter.data(), "reactions", today), expireAt: Timestamp.fromMillis(now + 2 * DAY_MS) });
    if (emoji) post.reactions[uid] = emoji;
    else delete post.reactions[uid];
    tx.update(snap.ref, new FieldPath("reactions", uid), emoji ?? FieldValue.delete());
    writeReactions(db, tx, post, [uid]);
  });
  return {};
}

export async function commentAdd(db: Firestore, uid: string, data: unknown, deps: Deps, now = Date.now()) {
  const d = obj(data);
  const postId = readId(d.postId, "postId");
  const text = readComment(d.text);
  visiblePost(readPost(await postRef(db, postId).get()), uid, now);
  await profileOf(db, uid);
  await takeUnit(db, uid, "comments", now);
  let flagged: boolean;
  try {
    flagged = await deps.moderate([text]);
  } catch (error) {
    await giveBack(db, uid, "comments", now);
    throw error;
  }
  if (flagged) {
    logger.info("friends comment rejected by moderation");
    throw new HttpsError("failed-precondition", Reason.friendTextRejected);
  }
  const id = newId();
  const comment = await db.runTransaction(async (tx) => {
    const snap = await tx.get(postRef(db, postId));
    const post = visiblePost(readPost(snap), uid, now);
    const me = await profileOf(db, uid, tx);
    // Blocks either way: the comment never reaches those readers.
    const [by, of] = await Promise.all([
      tx.get(db.collection(PCOL.blocks).where("by", "==", uid).select("uid")),
      tx.get(db.collection(PCOL.blocks).where("uid", "==", uid).select("by")),
    ]);
    const blocked = new Set([...by.docs.map((b) => String(b.get("uid"))), ...of.docs.map((b) => String(b.get("by")))]);
    const recipients = post.recipients.filter((r) => r === uid || !blocked.has(r));
    const c: Comment = {
      id, postId, postUid: post.uid, uid, displayName: me.displayName, emoji: me.emoji, text,
      createdAt: Timestamp.fromMillis(now), expireAt: post.expireAt, recipients,
    };
    const { id: _id, ...stored } = c;
    tx.set(commentRef(db, id), stored);
    tx.update(snap.ref, { commentCount: FieldValue.increment(1) });
    for (const r of recipients) {
      tx.set(inboxCommentRef(db, r, postId, id), commentCopy(c, r));
      tx.update(inboxPostRef(db, r, postId), { commentCount: FieldValue.increment(1) });
    }
    return c;
  });
  return { comment: forApp(commentCopy(comment, uid)) };
}

/** Takes a comment away from `readers` (all of its readers when undefined,
 *  and then the comment itself): their copies go and their counts drop. */
async function retractComment(db: Firestore, commentId: string, readers?: string[], allowed?: (c: Comment, post: Post | undefined) => boolean) {
  await db.runTransaction(async (tx) => {
    const cSnap = await tx.get(commentRef(db, commentId));
    const c = readCommentDoc(cSnap);
    if (!c) { if (allowed) throw notFound(); return; }
    const pSnap = await tx.get(postRef(db, c.postId));
    const post = readPost(pSnap);
    if (allowed && !allowed(c, post)) throw notFound();
    const from = readers ? c.recipients.filter((r) => readers.includes(r)) : c.recipients;
    const holders = new Set(post?.recipients ?? []);
    for (const r of from) {
      tx.delete(inboxCommentRef(db, r, c.postId, c.id));
      if (holders.has(r)) tx.update(inboxPostRef(db, r, c.postId), { commentCount: FieldValue.increment(-1) });
    }
    if (readers) {
      tx.update(cSnap.ref, { recipients: c.recipients.filter((r) => !from.includes(r)) });
    } else {
      tx.delete(cSnap.ref);
      if (post) tx.update(pSnap.ref, { commentCount: FieldValue.increment(-1) });
    }
  });
}

export async function commentDelete(db: Firestore, uid: string, data: unknown) {
  const d = obj(data);
  const postId = readId(d.postId, "postId");
  const commentId = readId(d.commentId, "commentId");
  // Mine, or any comment on my post.
  await retractComment(db, commentId, undefined, (c, post) => c.postId === postId && (c.uid === uid || post?.uid === uid));
  return {};
}

/** Takes post copies away from `readers` (not the poster): off the post's
 *  recipients and out of their inboxes. */
async function retractPost(db: Firestore, postId: string, readers: (post: Post) => string[]) {
  const copies = await db.runTransaction(async (tx) => {
    const snap = await tx.get(postRef(db, postId));
    const post = readPost(snap);
    if (!post) return [];
    const gone = readers(post).filter((r) => r !== post.uid && post.recipients.includes(r));
    if (gone.length === 0) return [];
    tx.update(snap.ref, { recipients: post.recipients.filter((r) => !gone.includes(r)) });
    const refs = gone.map((r) => inboxPostRef(db, r, postId));
    for (const ref of refs) tx.delete(ref);
    return refs;
  });
  await cleanupCopies(db, copies);
}

export async function photoReport(db: Firestore, uid: string, data: unknown, _deps?: Deps, now = Date.now()) {
  const d = obj(data);
  const postId = readId(d.postId, "postId");
  const commentId = d.commentId === undefined || d.commentId === null ? undefined : readId(d.commentId, "commentId");
  const reason = readPhotoReportReason(d.reason);
  if (commentId) {
    const ref = await db.runTransaction(async (tx) => {
      const c = readCommentDoc(await tx.get(commentRef(db, commentId)));
      if (!c || c.postId !== postId || c.uid === uid || !c.recipients.includes(uid)) throw notFound();
      const r = db.doc(`${PCOL.reports}/${reportId(uid, `comment:${commentId}`)}`);
      tx.set(r, {
        type: "comment", reporter: uid, subject: c.uid, postId, commentId, reason, subjectText: c.text,
        subjectName: c.displayName, subjectEmoji: c.emoji, createdAt: Timestamp.fromMillis(now), status: "new",
      });
      return r;
    });
    // The reporter stops seeing it at once.
    await retractComment(db, commentId, [uid]);
    logger.warn("friends report", { reportId: ref.id, reason, type: "comment" });
    return {};
  }
  let hide = false;
  const ref = await db.runTransaction(async (tx) => {
    const snap = await tx.get(postRef(db, postId));
    const post = readPost(snap);
    if (!post || post.uid === uid || !post.recipients.includes(uid)) throw notFound();
    const r = db.doc(`${PCOL.reports}/${reportId(uid, `post:${postId}`)}`);
    tx.set(r, {
      type: "post", reporter: uid, subject: post.uid, postId, reason, subjectText: post.caption, imagePath: post.imagePath,
      subjectName: post.displayName, subjectEmoji: post.emoji, createdAt: Timestamp.fromMillis(now), status: "new",
    });
    const reporters = [...new Set([...post.reporters, uid])];
    hide = !post.hidden && reporters.length >= HIDE_AFTER_REPORTS;
    tx.update(snap.ref, { reporters, ...(hide ? { hidden: true } : {}) });
    if (hide && post.recipients.includes(post.uid)) tx.update(inboxPostRef(db, post.uid, postId), { hidden: true });
    return r;
  });
  // The reporter stops seeing it; hidden, every friend does (pending review
  // in the console: friendReports with this postId; the photo is kept).
  await retractPost(db, postId, (post) => (hide || post.hidden ? post.recipients : [uid]));
  logger.warn("friends report", { reportId: ref.id, reason, type: "post", hidden: hide });
  return {};
}

// MARK: - Bounded work

/** Runs `fn` over `items`, `limit` at a time, starting none once `deadline`
 *  (ms since 1970) has passed. True when every item ran; throws the first
 *  error once the running ones are done. */
export async function forEachLimited<T>(items: readonly T[], limit: number, fn: (item: T) => Promise<unknown>, deadline = Infinity): Promise<boolean> {
  let next = 0;
  let failure: { error: unknown } | undefined;
  const worker = async () => {
    while (!failure && next < items.length && Date.now() < deadline) {
      const item = items[next++];
      try {
        await fn(item);
      } catch (error) {
        failure ??= { error };
      }
    }
  };
  await Promise.all(Array.from({ length: Math.max(0, Math.min(limit, items.length)) }, worker));
  if (failure) throw failure.error;
  return next >= items.length;
}

/** Comments by post: a post's comments one after another (their
 *  transactions touch the same copies), posts side by side. */
async function forEachByPost(docs: QueryDocumentSnapshot[], fn: (doc: QueryDocumentSnapshot) => Promise<unknown>, deadline: number): Promise<boolean> {
  const groups = new Map<string, QueryDocumentSnapshot[]>();
  for (const doc of docs) {
    const key = String(doc.get("postId") ?? "");
    groups.set(key, [...(groups.get(key) ?? []), doc]);
  }
  let complete = true;
  const ran = await forEachLimited([...groups.values()], PARALLEL, async (group) => {
    for (const doc of group) {
      if (Date.now() >= deadline) { complete = false; return; }
      await fn(doc);
    }
  }, deadline);
  return ran && complete;
}

// MARK: - Hooks (friends.ts, friendsAccount.ts)

export interface CleanupOptions {
  /** Stop starting new work after this (ms since 1970). */
  deadline?: number;
  /** Only posts made up to this time (ms): an unfriend's job run later
   *  leaves posts made after the two became friends again. */
  before?: number;
}

/** Unfriend (or block): each stops reading the other's posts. Comments stay
 *  (they're friends of the posters they commented for; see the known limits
 *  above). True when every post was done before the deadline. */
export async function unlinkPhotos(db: Firestore, a: string, b: string, options: CleanupOptions = {}): Promise<boolean> {
  const deadline = options.deadline ?? Infinity;
  let complete = true;
  for (const [author, reader] of [[a, b], [b, a]]) {
    const posts = await db.collection(PCOL.posts).where("uid", "==", author).where("recipients", "array-contains", reader).select("createdAt").get();
    const ids = posts.docs
      .filter((doc) => options.before === undefined || ms(doc.get("createdAt")) <= options.before)
      .map((doc) => doc.id);
    complete = (await forEachLimited(ids, PARALLEL, (id) => retractPost(db, id, () => [reader]), deadline)) && complete;
  }
  return complete;
}

/** Block: on top of unlinking, each stops seeing the other's comments on
 *  anyone's posts. True when everything was done before the deadline. */
export async function blockPhotos(db: Firestore, a: string, b: string, options: CleanupOptions = {}): Promise<boolean> {
  const deadline = options.deadline ?? Infinity;
  let complete = await unlinkPhotos(db, a, b, options);
  for (const [author, reader] of [[a, b], [b, a]]) {
    const comments = await db.collection(PCOL.comments).where("uid", "==", author).where("recipients", "array-contains", reader).select("postId").get();
    complete = (await forEachByPost(comments.docs, (doc) => retractComment(db, doc.id, [reader]), deadline)) && complete;
  }
  return complete;
}

/** The author of a comment the member holds (or reported), for blocking a
 *  commenter who isn't their friend (friends.ts block). */
export async function commentAuthor(db: Firestore, uid: string, data: unknown): Promise<string> {
  const d = obj(data);
  const postId = readId(d.postId, "postId");
  const commentId = readId(d.commentId, "commentId");
  const [snap, report] = await Promise.all([
    commentRef(db, commentId).get(),
    db.doc(`${PCOL.reports}/${reportId(uid, `comment:${commentId}`)}`).get(),
  ]);
  const c = readCommentDoc(snap);
  if (!c || c.postId !== postId || c.uid === uid || !(c.recipients.includes(uid) || report.exists)) throw notFound();
  return c.uid;
}

/** Account deletion: the member's posts (every copy and photo), their
 *  comments everywhere, their reactions, their uid off every post and
 *  comment they could read or reported, their inbox and counter. Reports
 *  by them and about them are handled with the other reports
 *  (friendsAccount.ts). Call after the friends profile is gone, so nothing
 *  new can name them. `count`: docs removed or changed; `complete`: false
 *  when the deadline stopped it (run it again: every step can be repeated). */
export async function deletePhotoData(db: Firestore, uid: string, store: PhotoStore, deadline = Infinity): Promise<{ count: number; complete: boolean }> {
  let count = 0;
  let complete = true;
  const posts = await db.collection(PCOL.posts).where("uid", "==", uid).select().get();
  complete = (await forEachLimited(posts.docs, PARALLEL, async (doc) => { await deletePost(db, store, doc.id); count++; }, deadline)) && complete;
  const comments = await db.collection(PCOL.comments).where("uid", "==", uid).select("postId").get();
  complete = (await forEachByPost(comments.docs, async (doc) => { await retractComment(db, doc.id); count++; }, deadline)) && complete;
  const reacted = await db.collection(PCOL.posts).where(new FieldPath("reactions", uid), "in", [...REACTIONS]).select().get();
  complete = (await forEachLimited(reacted.docs, PARALLEL, async (doc) => {
    await db.runTransaction(async (tx) => {
      const post = readPost(await tx.get(doc.ref));
      if (!post || !(uid in post.reactions)) return;
      delete post.reactions[uid];
      tx.update(doc.ref, new FieldPath("reactions", uid), FieldValue.delete());
      writeReactions(db, tx, post, []);
    });
    count++;
  }, deadline)) && complete;
  // Their uid off every post they could read or reported and every comment
  // they got (array removes: safe to repeat, no transaction needed).
  const [received, reported, got] = await Promise.all([
    db.collection(PCOL.posts).where("recipients", "array-contains", uid).select().get(),
    db.collection(PCOL.posts).where("reporters", "array-contains", uid).select().get(),
    db.collection(PCOL.comments).where("recipients", "array-contains", uid).select().get(),
  ]);
  const writer = db.bulkWriter();
  const failures: unknown[] = [];
  const track = (write: Promise<unknown>) => void write.catch((error: { code?: number }) => {
    if (error?.code !== 5) failures.push(error); // NOT_FOUND: deleted meanwhile
  });
  const postRefs = new Map([...received.docs, ...reported.docs].map((doc) => [doc.ref.path, doc.ref]));
  for (const ref of postRefs.values()) {
    track(writer.update(ref, { recipients: FieldValue.arrayRemove(uid), reporters: FieldValue.arrayRemove(uid) }));
  }
  for (const doc of got.docs) track(writer.update(doc.ref, { recipients: FieldValue.arrayRemove(uid) }));
  await writer.close();
  if (failures.length > 0) throw failures[0];
  await db.recursiveDelete(db.doc(`${PCOL.inbox}/${uid}`));
  await db.doc(`${PCOL.counters}/${uid}`).delete();
  return { count, complete };
}

// MARK: - Cleanup jobs (photoCleanups)

export type CleanupKind = "unlink" | "block" | "account";

export interface CleanupJob {
  kind: CleanupKind;
  a: string;
  b: string | null;
  createdAt: Timestamp;
}

/** The job doc: one per pair and kind (one per member for an account). */
export function cleanupRef(db: Firestore, kind: CleanupKind, a: string, b?: string): DocumentReference {
  const id = kind === "account" || !b ? `${kind}-${a}` : `${kind}-${pairId(a, b)}`;
  return db.doc(`${PCOL.cleanups}/${id}`);
}

export function cleanupJob(kind: CleanupKind, a: string, b: string | null, now: number): CleanupJob {
  return { kind, a, b, createdAt: Timestamp.fromMillis(now) };
}

function readJob(snap: DocumentSnapshot): CleanupJob | undefined {
  const d = snap.data();
  if (!d || typeof d.a !== "string" || !(d.createdAt instanceof Timestamp)) return undefined;
  const kind = d.kind === "unlink" || d.kind === "block" || d.kind === "account" ? d.kind : undefined;
  if (!kind || (kind !== "account" && typeof d.b !== "string")) return undefined;
  return { kind, a: d.a, b: typeof d.b === "string" ? d.b : null, createdAt: d.createdAt };
}

async function runCleanup(db: Firestore, job: CleanupJob, store: PhotoStore, deadline: number): Promise<boolean> {
  const options = { deadline, before: job.createdAt.toMillis() };
  switch (job.kind) {
    case "unlink": return unlinkPhotos(db, job.a, String(job.b), options);
    case "block": return blockPhotos(db, job.a, String(job.b), options);
    case "account": return (await deletePhotoData(db, job.a, store, deadline)).complete;
  }
}

/** Does a job now, within `deadline`, and deletes it once done; what isn't
 *  done (time ran out, an error) stays for friendsPhotoSweep. Never throws:
 *  the unfriend, block or deletion it follows has already happened. */
export async function settleCleanup(db: Firestore, ref: DocumentReference, job: CleanupJob, store: PhotoStore, deadline: number): Promise<boolean> {
  let done = false;
  try {
    done = await runCleanup(db, job, store, deadline);
  } catch (error) {
    logger.warn("friends photo cleanup unfinished", { kind: job.kind, error: String(error) });
  }
  if (done) await ref.delete().catch(() => undefined);
  else logger.info("friends photo cleanup left for the sweep", { kind: job.kind });
  return done;
}

/** friendsPhotoSweep's work: cleanup jobs older than 2 minutes (so not one
 *  a call is still doing), posts past 30 days (deletePost: copies, comments
 *  and the photo file) and photo files older than 31 days whose post TTL
 *  removed first. */
export async function sweepPhotos(db: Firestore, store: PhotoStore, now = Date.now(), deadline = now + 8 * 60_000) {
  const result = { jobs: 0, unfinished: 0, expired: 0, files: 0 };
  const jobs = await db.collection(PCOL.cleanups)
    .where("createdAt", "<=", Timestamp.fromMillis(now - 2 * 60_000)).orderBy("createdAt").limit(50).get();
  for (const doc of jobs.docs) {
    if (Date.now() >= deadline) break;
    const job = readJob(doc);
    if (!job) { await doc.ref.delete(); continue; }
    result.jobs++;
    if (!(await settleCleanup(db, doc.ref, job, store, deadline))) result.unfinished++;
  }
  const expired = await db.collection(PCOL.posts)
    .where("createdAt", "<=", Timestamp.fromMillis(now - POST_TTL_DAYS * DAY_MS)).select().limit(500).get();
  await forEachLimited(expired.docs, PARALLEL, async (doc) => { await deletePost(db, store, doc.id); result.expired++; }, deadline);
  if (store.removeOlderThan && Date.now() < deadline) {
    result.files = await store.removeOlderThan("friendPhotos/", now - (POST_TTL_DAYS + 1) * DAY_MS);
  }
  return result;
}

// MARK: - Callables

type Handler = (db: Firestore, uid: string, data: unknown, deps: Deps) => Promise<unknown>;

function callable(handler: Handler, options: { secrets?: boolean; memory?: "256MiB" | "512MiB"; timeoutSeconds?: number } = {}) {
  return onCall({
    region: REGION, timeoutSeconds: options.timeoutSeconds ?? 30, memory: options.memory ?? "256MiB", maxInstances: 10, concurrency: 40,
    ...(options.secrets ? { secrets: [OPENAI_API_KEY] } : {}),
  }, async (req) => {
    const uid = await requireFriendsUser(req);
    return handler(getFirestore(), uid, req.data, { store: firebaseStore(), moderate: openAIModerator });
  });
}

export const friendsPhotoPost = callable((db, uid, data, deps) => photoPost(db, uid, data, deps), { secrets: true, memory: "512MiB", timeoutSeconds: 60 });
export const friendsPhotoDelete = callable((db, uid, data, deps) => photoDelete(db, uid, data, deps), { timeoutSeconds: 60 });
export const friendsPhotoReact = callable((db, uid, data) => photoReact(db, uid, data));
export const friendsCommentAdd = callable((db, uid, data, deps) => commentAdd(db, uid, data, deps), { secrets: true });
export const friendsCommentDelete = callable((db, uid, data) => commentDelete(db, uid, data));
export const friendsPhotoReport = callable((db, uid, data) => photoReport(db, uid, data), { timeoutSeconds: 60 });

/** Finishes unfriend/block/account cleanups a call couldn't, and deletes
 *  expired posts with their photo files (see the top of this file). */
export const friendsPhotoSweep = onSchedule({
  schedule: "every 10 minutes", region: REGION, timeoutSeconds: 540, memory: "512MiB", maxInstances: 1, retryCount: 0,
}, async () => {
  const result = await sweepPhotos(getFirestore(), firebaseStore());
  if (result.jobs || result.expired || result.files) logger.info("friends photo sweep", result);
});
