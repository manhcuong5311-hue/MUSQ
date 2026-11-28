/**
 * MUSQ Friends v1 (owner approved 2026-11-28): friend codes, requests, a
 * small feed of summarized events, a weekly board, templated nudges and
 * reactions. Every call needs a signed-in member (Sign in with Apple, as
 * the app's only sign-in; any account in the emulator) and, when
 * `config/ai.enforceAppCheck` is on, App Check, like the AI calls.
 * Firestore stays closed to the app (firestore.rules): only these
 * functions read and write it, with the Admin SDK.
 *
 * Nothing here holds health data: the app sends only summaries of what it
 * logs (a workout's title, minutes and sets; that the water goal was hit;
 * how many meals; a streak; a PR's exercise and kg), and only the kinds the
 * member's share toggles allow. No ids the app sees carry a uid (see
 * friendsRules.ts). Blocks look like a missing code from both sides.
 *
 * Firestore layout (all server-only):
 * - friendProfiles/{uid}: displayName, emoji, code, share, week, lastActive
 * - friendCodes/{CODE}: uid
 * - friendships/{pairId}: uids [a, b] sorted, since, mutedBy [uid]
 * - friendRequests/{requestId}: from, to, createdAt, expireAt (+30 days)
 * - friendEvents/{eventId}: uid, kind, day, data, createdAt, expireAt
 *   (+30 days), reactions {uid: emoji}
 * - nudges/{auto}: from, to, pair, kind, createdAt, delivered, expireAt (+7 days)
 * - nudgeCounters/{uid}: day (UTC), total, pairs, expireAt (+2 days)
 * - requestCounters/{uid}: day (UTC), lookups (friend codes tried, found
 *   or not), expireAt (+2 days)
 * - friendDeclines/{requestId}: from, to, createdAt, expireAt (+30 days): a
 *   declined request (or an unfriend) that keeps `from` from asking `to`
 *   again for a while; their new request is quietly not delivered
 * - friendBlocks/{blockId}: by, uid, createdAt
 * - photo check-ins: friendPhotos, friendPhotoComments, photoCounters and
 *   the app-readable friendInbox/{uid}/posts (see friendsPhotos.ts)
 * - friendReports/{reportId}: reporter, subject, reason, subjectName,
 *   subjectEmoji, createdAt, status "new" (for the owner, in the console;
 *   each new one also logs "friends report" at warning level, for a
 *   log-based alert, see Tools/friends/README.md)
 */
import { FieldPath, FieldValue, Timestamp, getFirestore, type DocumentData, type DocumentReference, type DocumentSnapshot, type Firestore, type Transaction } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { HttpsError, onCall, type CallableRequest } from "firebase-functions/v2/https";
import { REGION, aiConfig, inEmulator } from "./config.js";
import { appleSubject } from "./access.js";
import { Reason } from "./reasons.js";
import { INLINE_CLEANUP_MS, cleanupJob, cleanupRef, commentAuthor, firebaseStore, settleCleanup } from "./friendsPhotos.js";
import {
  DEFAULT_SHARE, EVENTS_PER_DAY, EVENT_SHARE, MAX_FRIENDS, MAX_OUTGOING, REACTIONS, afterCursor, blockId, boardWeek,
  decodeCursor, encodeCursor, eventId, feedOrder, newCode, nudgeCheck, pairId, readAvatar, readCode, readDisplayName,
  readEvents, readId, readNudgeKind, readReaction, readReportReason, readShare, readWeek, reportId, requestId, utcDay,
  type EventKind, type Share, type Week,
} from "./friendsRules.js";

const DAY_MS = 24 * 60 * 60 * 1000;
const FEED_DAYS = 14;
const FEED_PAGE = 30;
const EVENT_TTL_DAYS = 30;
const REQUEST_TTL_DAYS = 30;
const NUDGE_TTL_DAYS = 7;
const DECLINE_DAYS = 30;
/** Friend codes one member may try a day (found or not), so codes can't be
 *  harvested by guessing. */
export const CODE_LOOKUPS_PER_DAY = 30;

export const COL = {
  profiles: "friendProfiles",
  codes: "friendCodes",
  friendships: "friendships",
  requests: "friendRequests",
  events: "friendEvents",
  nudges: "nudges",
  nudgeCounters: "nudgeCounters",
  requestCounters: "requestCounters",
  declines: "friendDeclines",
  blocks: "friendBlocks",
  reports: "friendReports",
} as const;

// MARK: - Shared helpers

interface Profile {
  displayName: string;
  emoji: string;
  code: string;
  share: Share;
  week?: Week;
  lastActive?: Timestamp;
}

function readProfile(snap: DocumentSnapshot): Profile | undefined {
  if (!snap.exists) return undefined;
  const d = snap.data() as DocumentData;
  return {
    displayName: String(d.displayName ?? ""),
    emoji: String(d.emoji ?? ""),
    code: String(d.code ?? ""),
    share: readShare(d.share),
    week: d.week as Week | undefined,
    lastActive: d.lastActive instanceof Timestamp ? d.lastActive : undefined,
  };
}

const iso = (t: unknown): string | null => (t instanceof Timestamp ? t.toDate().toISOString() : null);
const ms = (t: unknown): number => (t instanceof Timestamp ? t.toMillis() : 0);
const obj = (data: unknown) => (data && typeof data === "object" ? data : {}) as Record<string, unknown>;
const notFound = () => new HttpsError("not-found", Reason.friendNotFound);

function meOf(p: Profile) {
  return { displayName: p.displayName, emoji: p.emoji, code: p.code, share: p.share };
}

/** Sign-in, Sign in with Apple (except in the emulator) and App Check. */
export async function requireFriendsUser(request: CallableRequest<unknown>): Promise<string> {
  if (!request.auth) throw new HttpsError("unauthenticated", Reason.signIn);
  const config = await aiConfig();
  if (config.enforceAppCheck && !request.app) throw new HttpsError("unauthenticated", Reason.appCheck);
  if (!inEmulator() && !appleSubject(request.auth.token)) throw new HttpsError("unauthenticated", Reason.signIn);
  return request.auth.uid;
}

async function requireProfile(db: Firestore, uid: string, tx?: Transaction): Promise<Profile> {
  const ref = db.doc(`${COL.profiles}/${uid}`);
  const profile = readProfile(tx ? await tx.get(ref) : await ref.get());
  if (!profile) throw new HttpsError("failed-precondition", Reason.friendProfile);
  return profile;
}

function friendsQuery(db: Firestore, uid: string) {
  return db.collection(COL.friendships).where("uids", "array-contains", uid);
}

/** Pending outgoing requests (unexpired) of `uid`, read in the transaction. */
async function outgoingCount(db: Firestore, tx: Transaction, uid: string, now: number): Promise<number> {
  const snap = await tx.get(db.collection(COL.requests).where("from", "==", uid).select("expireAt").limit(MAX_OUTGOING + 30));
  return snap.docs.filter((d) => ms(d.get("expireAt")) > now).length;
}

async function friendCount(db: Firestore, tx: Transaction, uid: string): Promise<number> {
  return (await tx.get(friendsQuery(db, uid).select().limit(MAX_FRIENDS + 1))).size;
}

async function isBlocked(db: Firestore, tx: Transaction, a: string, b: string): Promise<boolean> {
  const [x, y] = await Promise.all([tx.get(db.doc(`${COL.blocks}/${blockId(a, b)}`)), tx.get(db.doc(`${COL.blocks}/${blockId(b, a)}`))]);
  return x.exists || y.exists;
}

/** The other person behind an id the app sent: a friend (friendship id),
 *  or someone with a pending request either way (request id). */
async function resolveOther(db: Firestore, uid: string, id: string, tx?: Transaction): Promise<{ other: string; kind: "friend" | "incoming" | "outgoing" }> {
  const get = (path: string) => (tx ? tx.get(db.doc(path)) : db.doc(path).get());
  const [friendship, request] = await Promise.all([get(`${COL.friendships}/${id}`), get(`${COL.requests}/${id}`)]);
  const uids = friendship.get("uids");
  if (friendship.exists && Array.isArray(uids) && uids.includes(uid)) {
    const other = uids.find((u: unknown) => u !== uid);
    if (typeof other === "string") return { other, kind: "friend" };
  }
  if (request.exists) {
    if (request.get("to") === uid) return { other: String(request.get("from")), kind: "incoming" };
    if (request.get("from") === uid) return { other: String(request.get("to")), kind: "outgoing" };
  }
  throw notFound();
}

function newFriendship(tx: Transaction, db: Firestore, a: string, b: string, now: number) {
  tx.set(db.doc(`${COL.friendships}/${pairId(a, b)}`), {
    uids: [a, b].sort(), since: Timestamp.fromMillis(now), mutedBy: [],
  });
  tx.delete(db.doc(`${COL.requests}/${requestId(a, b)}`));
  tx.delete(db.doc(`${COL.requests}/${requestId(b, a)}`));
}

async function profilesOf(db: Firestore, uids: string[]): Promise<Map<string, Profile>> {
  const map = new Map<string, Profile>();
  if (uids.length === 0) return map;
  const snaps = await db.getAll(...uids.map((u) => db.doc(`${COL.profiles}/${u}`)));
  for (const snap of snaps) {
    const p = readProfile(snap);
    if (p) map.set(snap.id, p);
  }
  return map;
}

// MARK: - Handlers (db, uid, data) → result; the callables below wrap them.

export async function profileSet(db: Firestore, uid: string, data: unknown, now = Date.now()) {
  const d = obj(data);
  const displayName = readDisplayName(d.displayName);
  const emoji = readAvatar(d.emoji);
  const regenerate = d.regenerateCode === true;
  let turnedOff: (keyof Share)[] = [];
  const result = await db.runTransaction(async (tx) => {
    const ref = db.doc(`${COL.profiles}/${uid}`);
    const current = readProfile(await tx.get(ref));
    const share = readShare(d.share, current?.share ?? DEFAULT_SHARE);
    turnedOff = current ? (Object.keys(share) as (keyof Share)[]).filter((k) => current.share[k] && !share[k]) : [];
    let code = current?.code ?? "";
    if (!code || regenerate) {
      let found: string | undefined;
      for (let i = 0; i < 8 && !found; i++) {
        const candidate = newCode();
        if (!(await tx.get(db.doc(`${COL.codes}/${candidate}`))).exists) found = candidate;
      }
      if (!found) throw new HttpsError("aborted", "try again");
      if (code) tx.delete(db.doc(`${COL.codes}/${code}`));
      tx.set(db.doc(`${COL.codes}/${found}`), { uid, createdAt: Timestamp.fromMillis(now) });
      code = found;
    }
    const goalOff = current?.week && !share.goal ? { week: { ...current.week, goalPct: null } } : {};
    tx.set(ref, {
      displayName, emoji, code, share, updatedAt: Timestamp.fromMillis(now),
      ...(current ? goalOff : { createdAt: Timestamp.fromMillis(now) }),
    }, { merge: true });
    return { me: { displayName, emoji, code, share } };
  });
  // A switch turned off takes back what was already shared of that kind,
  // so turning it on again later doesn't bring old items back.
  if (turnedOff.length > 0) await deleteEventsOf(db, uid, turnedOff);
  return result;
}

async function deleteEventsOf(db: Firestore, uid: string, toggles: (keyof Share)[]) {
  const snap = await db.collection(COL.events).where("uid", "==", uid).select("kind").get();
  const writer = db.bulkWriter();
  for (const doc of snap.docs) {
    const kind = doc.get("kind") as EventKind;
    if (kind in EVENT_SHARE && toggles.includes(EVENT_SHARE[kind])) void writer.delete(doc.ref).catch(() => undefined);
  }
  await writer.close();
}

export async function sync(db: Firestore, uid: string, _data: unknown, now = Date.now()) {
  const me = readProfile(await db.doc(`${COL.profiles}/${uid}`).get());
  if (!me) return { me: null, friends: [], incoming: [], outgoing: [], inbox: [] };
  const [friendships, incoming, outgoing, nudges] = await Promise.all([
    friendsQuery(db, uid).limit(MAX_FRIENDS + 10).get(),
    db.collection(COL.requests).where("to", "==", uid).limit(100).get(),
    db.collection(COL.requests).where("from", "==", uid).limit(MAX_OUTGOING + 30).get(),
    db.collection(COL.nudges).where("to", "==", uid).where("delivered", "==", false).limit(50).get(),
  ]);
  const friendOf = new Map<string, { id: string; since: unknown; muted: boolean }>();
  for (const doc of friendships.docs) {
    const other = (doc.get("uids") as string[]).find((u) => u !== uid);
    const mutedBy = doc.get("mutedBy");
    if (other) friendOf.set(other, { id: doc.id, since: doc.get("since"), muted: Array.isArray(mutedBy) && mutedBy.includes(uid) });
  }
  const live = (d: DocumentSnapshot) => ms(d.get("expireAt")) > now;
  const incomingDocs = incoming.docs.filter(live);
  const outgoingDocs = outgoing.docs.filter(live);
  const people = new Set<string>([...friendOf.keys(), ...incomingDocs.map((d) => String(d.get("from"))), ...outgoingDocs.map((d) => String(d.get("to")))]);
  const profiles = await profilesOf(db, [...people]);

  const friends = [...friendOf.entries()].flatMap(([other, f]) => {
    const p = profiles.get(other);
    if (!p) return [];
    return [{
      id: f.id, displayName: p.displayName, emoji: p.emoji, since: iso(f.since), muted: f.muted,
      week: boardWeek(p.week, p.lastActive?.toMillis(), p.share, now),
      lastActive: iso(p.lastActive),
    }];
  }).sort((a, b) => b.week.workouts - a.week.workouts || b.week.streak - a.week.streak || a.displayName.localeCompare(b.displayName));

  const req = (doc: DocumentSnapshot, other: string) => {
    const p = profiles.get(other);
    return p ? [{ id: doc.id, displayName: p.displayName, emoji: p.emoji, createdAt: iso(doc.get("createdAt")) }] : [];
  };
  const byNewest = (a: { createdAt: string | null }, b: { createdAt: string | null }) => String(b.createdAt).localeCompare(String(a.createdAt));

  // Undelivered nudges, delivered now (once). One from someone no longer a
  // friend, muted since, or older than a week is dropped quietly.
  const inbox = nudges.docs.flatMap((doc) => {
    const from = String(doc.get("from"));
    const f = friendOf.get(from);
    const p = profiles.get(from);
    if (!f || !p || f.muted || !live(doc)) return [];
    return [{ id: doc.id, fromId: f.id, fromName: p.displayName, fromEmoji: p.emoji, kind: String(doc.get("kind")), createdAt: iso(doc.get("createdAt")) }];
  }).sort(byNewest);
  if (nudges.size > 0) {
    const batch = db.batch();
    for (const doc of nudges.docs) batch.update(doc.ref, { delivered: true, deliveredAt: Timestamp.fromMillis(now) });
    await batch.commit();
  }

  return {
    me: meOf(me),
    friends,
    incoming: incomingDocs.flatMap((d) => req(d, String(d.get("from")))).sort(byNewest),
    outgoing: outgoingDocs.flatMap((d) => req(d, String(d.get("to")))).sort(byNewest),
    inbox,
  };
}

/** Counts one friend-code lookup (committed on its own, so a miss counts
 *  too); refuses once today's are used up. */
async function countLookup(db: Firestore, uid: string, now: number) {
  const today = utcDay(now);
  await db.runTransaction(async (tx) => {
    const ref = db.doc(`${COL.requestCounters}/${uid}`);
    const snap = await tx.get(ref);
    const lookups = snap.get("day") === today && typeof snap.get("lookups") === "number" ? (snap.get("lookups") as number) : 0;
    if (lookups >= CODE_LOOKUPS_PER_DAY) throw new HttpsError("resource-exhausted", Reason.friendTries);
    tx.set(ref, { day: today, lookups: lookups + 1, expireAt: Timestamp.fromMillis(now + 2 * DAY_MS) });
  });
}

/** Keeps `from` from asking `to` again for DECLINE_DAYS (a decline or an
 *  unfriend by `to`): the doc to set. */
function decline(db: Firestore, from: string, to: string, now: number): [DocumentReference, DocumentData] {
  return [db.doc(`${COL.declines}/${requestId(from, to)}`), {
    from, to, createdAt: Timestamp.fromMillis(now), expireAt: Timestamp.fromMillis(now + DECLINE_DAYS * DAY_MS),
  }];
}

export async function request(db: Firestore, uid: string, data: unknown, now = Date.now()): Promise<{ status: "sent" | "accepted" | "already" }> {
  const code = readCode(obj(data).code);
  await requireProfile(db, uid);
  await countLookup(db, uid, now);
  return db.runTransaction(async (tx) => {
    await requireProfile(db, uid, tx);
    const codeSnap = await tx.get(db.doc(`${COL.codes}/${code}`));
    const target = codeSnap.get("uid");
    if (!codeSnap.exists || typeof target !== "string") throw notFound();
    if (target === uid) throw new HttpsError("invalid-argument", Reason.friendSelf);
    const [targetProfile, blocked, friendship, theirs, mine, declined] = await Promise.all([
      tx.get(db.doc(`${COL.profiles}/${target}`)),
      isBlocked(db, tx, uid, target),
      tx.get(db.doc(`${COL.friendships}/${pairId(uid, target)}`)),
      tx.get(db.doc(`${COL.requests}/${requestId(target, uid)}`)),
      tx.get(db.doc(`${COL.requests}/${requestId(uid, target)}`)),
      tx.get(db.doc(`${COL.declines}/${requestId(uid, target)}`)),
    ]);
    // A block either way reads as a code that doesn't exist.
    if (blocked || !targetProfile.exists) throw notFound();
    if (friendship.exists) return { status: "already" as const };
    const [myFriends, theirFriends, myOutgoing] = await Promise.all([
      friendCount(db, tx, uid), friendCount(db, tx, target), outgoingCount(db, tx, uid, now),
    ]);
    if (theirs.exists && ms(theirs.get("expireAt")) > now) {
      if (myFriends >= MAX_FRIENDS || theirFriends >= MAX_FRIENDS) throw new HttpsError("resource-exhausted", Reason.friendLimit);
      newFriendship(tx, db, uid, target, now);
      return { status: "accepted" as const };
    }
    const mineLive = mine.exists && ms(mine.get("expireAt")) > now;
    if (mineLive) return { status: "sent" as const };
    // They declined (or unfriended) me lately: it reads as sent, and
    // nothing reaches them, so declining stops repeat requests quietly.
    if (declined.exists && ms(declined.get("expireAt")) > now) return { status: "sent" as const };
    if (myFriends >= MAX_FRIENDS || myOutgoing >= MAX_OUTGOING) throw new HttpsError("resource-exhausted", Reason.friendLimit);
    tx.set(db.doc(`${COL.requests}/${requestId(uid, target)}`), {
      from: uid, to: target, createdAt: Timestamp.fromMillis(now), expireAt: Timestamp.fromMillis(now + REQUEST_TTL_DAYS * DAY_MS),
    });
    // Asking them myself lifts my own decline of them.
    tx.delete(db.doc(`${COL.declines}/${requestId(target, uid)}`));
    return { status: "sent" as const };
  });
}

export async function respond(db: Firestore, uid: string, data: unknown, now = Date.now()) {
  const d = obj(data);
  const id = readId(d.requestId, "requestId");
  if (typeof d.accept !== "boolean") throw new HttpsError("invalid-argument", "accept invalid");
  const accept = d.accept;
  await db.runTransaction(async (tx) => {
    const ref = db.doc(`${COL.requests}/${id}`);
    const req = await tx.get(ref);
    if (!req.exists || req.get("to") !== uid || ms(req.get("expireAt")) <= now) throw notFound();
    const from = String(req.get("from"));
    if (!accept) {
      tx.delete(ref);
      tx.set(...decline(db, from, uid, now));
      return;
    }
    const [blocked, friendship, fromProfile] = await Promise.all([
      isBlocked(db, tx, uid, from), tx.get(db.doc(`${COL.friendships}/${pairId(uid, from)}`)), tx.get(db.doc(`${COL.profiles}/${from}`)),
    ]);
    if (blocked || !fromProfile.exists) throw notFound();
    if (friendship.exists) {
      tx.delete(ref);
      return;
    }
    const [mine, theirs] = await Promise.all([friendCount(db, tx, uid), friendCount(db, tx, from)]);
    if (mine >= MAX_FRIENDS || theirs >= MAX_FRIENDS) throw new HttpsError("resource-exhausted", Reason.friendLimit);
    await requireProfile(db, uid, tx);
    newFriendship(tx, db, uid, from, now);
  });
  return {};
}

/** Unfriend; with a request id it declines (incoming) or cancels (outgoing). */
export async function remove(db: Firestore, uid: string, data: unknown, now = Date.now()) {
  const id = readId(obj(data).friendId, "friendId");
  const { other, kind } = await resolveOther(db, uid, id);
  const batch = db.batch();
  if (kind === "friend") batch.delete(db.doc(`${COL.friendships}/${id}`));
  else batch.delete(db.doc(`${COL.requests}/${kind === "incoming" ? requestId(other, uid) : requestId(uid, other)}`));
  // Unfriending or declining keeps them from asking again at once (I can
  // still ask them, which lifts it).
  if (kind !== "outgoing") batch.set(...decline(db, other, uid, now));
  // Photo check-ins: each stops reading the other's posts. The job is
  // committed with the unfriend, so what this call can't finish in time is
  // finished by friendsPhotoSweep (friendsPhotos.ts).
  const job = cleanupJob("unlink", uid, other, now);
  const jobRef = cleanupRef(db, "unlink", uid, other);
  if (kind === "friend") batch.set(jobRef, job);
  await batch.commit();
  if (kind === "friend") await settleCleanup(db, jobRef, job, firebaseStore(), Date.now() + INLINE_CLEANUP_MS);
  return {};
}

/** Block a friend or someone with a request either way (`friendId`), or
 *  the author of a comment the member can see on a photo post ({postId,
 *  commentId}: a friend of the poster who isn't theirs): unfriends, drops
 *  requests both ways and their undelivered nudges, hides posts and
 *  comments both ways, and from then on each finds the other's code "not
 *  found". */
export async function block(db: Firestore, uid: string, data: unknown, now = Date.now()) {
  const d = obj(data);
  const other = d.friendId === undefined && d.commentId !== undefined
    ? await commentAuthor(db, uid, d)
    : (await resolveOther(db, uid, readId(d.friendId, "friendId"))).other;
  const nudges = await db.collection(COL.nudges).where("from", "==", other).where("to", "==", uid).get();
  const batch = db.batch();
  batch.set(db.doc(`${COL.blocks}/${blockId(uid, other)}`), { by: uid, uid: other, createdAt: Timestamp.fromMillis(now) });
  batch.delete(db.doc(`${COL.friendships}/${pairId(uid, other)}`));
  batch.delete(db.doc(`${COL.requests}/${requestId(uid, other)}`));
  batch.delete(db.doc(`${COL.requests}/${requestId(other, uid)}`));
  for (const doc of nudges.docs) batch.delete(doc.ref);
  // Photo check-ins: posts and comments hidden both ways; the job commits
  // with the block, so friendsPhotoSweep finishes what this call can't.
  const job = cleanupJob("block", uid, other, now);
  const jobRef = cleanupRef(db, "block", uid, other);
  batch.set(jobRef, job);
  await batch.commit();
  await settleCleanup(db, jobRef, job, firebaseStore(), Date.now() + INLINE_CLEANUP_MS);
  return {};
}

/** A report for the owner to review (Firestore console, friendReports):
 *  the reason and a snapshot of the name and avatar as reported. One per
 *  reporter and person; a new one replaces it. Call it before block, which
 *  makes the id unknown. */
export async function report(db: Firestore, uid: string, data: unknown, now = Date.now()) {
  const d = obj(data);
  const id = readId(d.friendId, "friendId");
  const reason = readReportReason(d.reason);
  const { other } = await resolveOther(db, uid, id);
  const subject = readProfile(await db.doc(`${COL.profiles}/${other}`).get());
  const ref = db.doc(`${COL.reports}/${reportId(uid, other)}`);
  await ref.set({
    reporter: uid, subject: other, reason, subjectName: subject?.displayName ?? null, subjectEmoji: subject?.emoji ?? null,
    createdAt: Timestamp.fromMillis(now), status: "new",
  });
  // For the owner's log-based alert (Tools/friends/README.md): reports are
  // acted on within 24 hours. No uid or name in the log, only the doc id.
  logger.warn("friends report", { reportId: ref.id, reason });
  return {};
}

export async function mute(db: Firestore, uid: string, data: unknown) {
  const d = obj(data);
  const id = readId(d.friendId, "friendId");
  if (typeof d.muted !== "boolean") throw new HttpsError("invalid-argument", "muted invalid");
  const { kind } = await resolveOther(db, uid, id);
  if (kind !== "friend") throw notFound();
  await db.doc(`${COL.friendships}/${id}`).update({ mutedBy: d.muted ? FieldValue.arrayUnion(uid) : FieldValue.arrayRemove(uid) });
  return {};
}

export async function post(db: Firestore, uid: string, data: unknown, now = Date.now()) {
  const d = obj(data);
  return db.runTransaction(async (tx) => {
    const profile = await requireProfile(db, uid, tx);
    const events = readEvents(d.events, profile.share, now);
    const week = readWeek(d.week, profile.share, now);
    const days = [...new Set(events.map((e) => e.day))];
    const existing = new Map<string, Set<string>>();
    await Promise.all(days.map(async (day) => {
      const snap = await tx.get(db.collection(COL.events).where("uid", "==", uid).where("day", "==", day).select());
      existing.set(day, new Set(snap.docs.map((doc) => doc.id)));
    }));
    events.forEach((event, index) => {
      const id = eventId(uid, event.kind, event.day, event.key);
      const ref = db.doc(`${COL.events}/${id}`);
      const ids = existing.get(event.day)!;
      if (ids.has(id)) {
        tx.update(ref, { data: event.data });
      } else if (ids.size < EVENTS_PER_DAY) {
        ids.add(id);
        // Apart by a millisecond each, so the feed's order is stable.
        const createdAt = now - index;
        tx.set(ref, {
          uid, kind: event.kind, day: event.day, data: event.data, reactions: {},
          createdAt: Timestamp.fromMillis(createdAt), expireAt: Timestamp.fromMillis(createdAt + EVENT_TTL_DAYS * DAY_MS),
        });
      }
    });
    tx.update(db.doc(`${COL.profiles}/${uid}`), { ...(week ? { week } : {}), lastActive: Timestamp.fromMillis(now) });
    return {};
  });
}

function reactionCounts(reactions: unknown) {
  const counts: Record<string, number> = Object.fromEntries(REACTIONS.map((r) => [r, 0]));
  for (const value of Object.values(obj(reactions))) if (typeof value === "string" && value in counts) counts[value]++;
  return counts;
}

export async function feed(db: Firestore, uid: string, data: unknown, now = Date.now()) {
  const cursor = decodeCursor(obj(data).before);
  const me = readProfile(await db.doc(`${COL.profiles}/${uid}`).get());
  if (!me) return { items: [], next: null };
  const friendships = await friendsQuery(db, uid).limit(MAX_FRIENDS + 10).get();
  const friendIdOf = new Map<string, string>([[uid, "me"]]);
  for (const doc of friendships.docs) {
    const other = (doc.get("uids") as string[]).find((u) => u !== uid);
    if (other) friendIdOf.set(other, doc.id);
  }
  const authors = [...friendIdOf.keys()];
  const profiles = await profilesOf(db, authors);
  profiles.set(uid, me);

  const since = Timestamp.fromMillis(now - FEED_DAYS * DAY_MS);
  const perChunk = FEED_PAGE * 2;
  const chunks: string[][] = [];
  for (let i = 0; i < authors.length; i += 30) chunks.push(authors.slice(i, i + 30));
  const results = await Promise.all(chunks.map((chunk) => {
    let q = db.collection(COL.events).where("uid", "in", chunk).where("createdAt", ">=", since);
    if (cursor) q = q.where("createdAt", "<=", Timestamp.fromMillis(cursor.ms));
    return q.orderBy("createdAt", "desc").limit(perChunk).get();
  }));

  type Candidate = { ms: number; id: string; doc: DocumentSnapshot };
  // A full chunk may hold more items older than its oldest one: nothing
  // older than that may be shown yet, or a page could skip some.
  let floor: Candidate | undefined;
  const candidates: Candidate[] = [];
  for (const snap of results) {
    const docs = snap.docs.map((doc) => ({ ms: ms(doc.get("createdAt")), id: doc.id, doc }));
    candidates.push(...docs);
    if (snap.size >= perChunk) {
      const oldest = docs.sort(feedOrder)[docs.length - 1];
      if (!floor || feedOrder(oldest, floor) < 0) floor = oldest;
    }
  }
  const ordered = candidates
    .filter((c) => afterCursor(c, cursor) && (!floor || feedOrder(c, floor) <= 0))
    .sort(feedOrder);
  const visible = ordered.filter((c) => {
    const p = profiles.get(String(c.doc.get("uid")));
    const kind = c.doc.get("kind") as EventKind;
    return p && kind in EVENT_SHARE && p.share[EVENT_SHARE[kind]];
  });
  const page = visible.slice(0, FEED_PAGE);
  const last = visible.length > FEED_PAGE ? page[page.length - 1] : floor;
  const items = page.map(({ doc }) => {
    const author = String(doc.get("uid"));
    const p = profiles.get(author)!;
    const reactions = obj(doc.get("reactions"));
    const mine = reactions[uid];
    return {
      id: doc.id, friendId: friendIdOf.get(author)!, displayName: p.displayName, emoji: p.emoji,
      kind: doc.get("kind"), day: doc.get("day"), createdAt: iso(doc.get("createdAt")), data: obj(doc.get("data")),
      reactions: reactionCounts(reactions), myReaction: typeof mine === "string" ? mine : null,
    };
  });
  return { items, next: last ? encodeCursor(last.ms, last.id) : null };
}

export async function react(db: Firestore, uid: string, data: unknown, now = Date.now()) {
  const d = obj(data);
  const id = readId(d.eventId, "eventId");
  const emoji = readReaction(d.emoji);
  await db.runTransaction(async (tx) => {
    const ref = db.doc(`${COL.events}/${id}`);
    const event = await tx.get(ref);
    if (!event.exists || ms(event.get("expireAt")) <= now) throw notFound();
    const author = String(event.get("uid"));
    const [friendship, authorProfile] = await Promise.all([
      author === uid ? Promise.resolve(undefined) : tx.get(db.doc(`${COL.friendships}/${pairId(uid, author)}`)),
      tx.get(db.doc(`${COL.profiles}/${author}`)),
    ]);
    if (friendship && !friendship.exists) throw notFound();
    const p = readProfile(authorProfile);
    const kind = event.get("kind") as EventKind;
    if (!p || !(kind in EVENT_SHARE) || !p.share[EVENT_SHARE[kind]]) throw notFound();
    tx.update(ref, new FieldPath("reactions", uid), emoji ?? FieldValue.delete());
  });
  return {};
}

export async function nudge(db: Firestore, uid: string, data: unknown, now = Date.now()) {
  const d = obj(data);
  const id = readId(d.friendId, "friendId");
  const kind = readNudgeKind(d.kind);
  const today = utcDay(now);
  await db.runTransaction(async (tx) => {
    const [friendship, counterSnap] = await Promise.all([
      tx.get(db.doc(`${COL.friendships}/${id}`)), tx.get(db.doc(`${COL.nudgeCounters}/${uid}`)),
    ]);
    const uids = friendship.get("uids");
    if (!friendship.exists || !Array.isArray(uids) || !uids.includes(uid)) throw notFound();
    const other = String(uids.find((u: unknown) => u !== uid));
    // Gone (deleting their account): nothing may name them any more.
    if (!(await tx.get(db.doc(`${COL.profiles}/${other}`))).exists) throw notFound();
    const counter = counterSnap.data();
    const check = nudgeCheck(counter, id, today);
    if (check === "pair") throw new HttpsError("resource-exhausted", Reason.nudgedToday);
    if (check === "total") throw new HttpsError("resource-exhausted", Reason.nudgeLimit);
    const sameDay = counter?.day === today;
    tx.set(counterSnap.ref, {
      day: today,
      total: (sameDay && typeof counter?.total === "number" ? counter.total : 0) + 1,
      pairs: [...(sameDay && Array.isArray(counter?.pairs) ? counter.pairs : []), id],
      expireAt: Timestamp.fromMillis(now + 2 * DAY_MS),
    });
    // Muted: counted and accepted, never delivered, so muting never shows.
    const mutedBy = friendship.get("mutedBy");
    if (Array.isArray(mutedBy) && mutedBy.includes(other)) return;
    tx.set(db.collection(COL.nudges).doc(), {
      from: uid, to: other, pair: id, kind, delivered: false,
      createdAt: Timestamp.fromMillis(now), expireAt: Timestamp.fromMillis(now + NUDGE_TTL_DAYS * DAY_MS),
    });
  });
  return {};
}

// MARK: - Callables

type Handler = (db: Firestore, uid: string, data: unknown) => Promise<unknown>;

function callable(handler: Handler) {
  return onCall({ region: REGION, timeoutSeconds: 20, memory: "256MiB", maxInstances: 10, concurrency: 40 }, async (req) => {
    const uid = await requireFriendsUser(req);
    return handler(getFirestore(), uid, req.data);
  });
}

export const friendsProfileSet = callable(profileSet);
export const friendsSync = callable(sync);
export const friendsRequest = callable(request);
export const friendsRespond = callable(respond);
export const friendsRemove = callable(remove);
export const friendsBlock = callable(block);
export const friendsReport = callable(report);
export const friendsMute = callable(mute);
export const friendsPost = callable(post);
export const friendsFeed = callable(feed);
export const friendsReact = callable(react);
export const friendsNudge = callable(nudge);
