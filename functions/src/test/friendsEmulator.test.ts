/**
 * MUSQ Friends against the Firestore emulator: requests, limits, blocks,
 * the feed, nudges, reactions and deleteAccount's cleanup. Skipped unless
 * FIRESTORE_EMULATOR_HOST is set; run with
 *   firebase emulators:exec --only firestore "node --test lib/test/friendsEmulator.test.js"
 */
import { test, before } from "node:test";
import assert from "node:assert/strict";
import { initializeApp, getApps } from "firebase-admin/app";
import { getFirestore, type Firestore } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import * as F from "../friends.js";
import { deleteFriendsData } from "../friendsAccount.js";
import { MAX_OUTGOING } from "../friendsRules.js";

const ON = !!process.env.FIRESTORE_EMULATOR_HOST;
let db: Firestore;
const NOW = Date.parse("2026-11-28T10:00:00Z");
const run = Math.random().toString(36).slice(2, 8);
const u = (name: string) => `${name}_${run}`;

async function reason(p: Promise<unknown>): Promise<string> {
  try { await p; } catch (e) { return e instanceof HttpsError ? `${e.code}:${e.message}` : String(e); }
  return "ok";
}

async function profile(uid: string, share: Record<string, boolean> = {}) {
  return (await F.profileSet(db, uid, { displayName: `Lifter ${uid.split("_")[0]}`, emoji: "💪", share }, NOW)).me;
}

async function befriend(a: string, b: string) {
  const bCode = (await F.sync(db, b, {}, NOW)).me!.code;
  assert.equal((await F.request(db, a, { code: bCode }, NOW)).status, "sent");
  const incoming = (await F.sync(db, b, {}, NOW)).incoming;
  await F.respond(db, b, { requestId: incoming[0].id, accept: true }, NOW);
}

before(() => {
  if (!ON) return;
  if (getApps().length === 0) initializeApp({ projectId: "demo-musq" });
  db = getFirestore();
});

test("requests, accept, already, self and the mutual auto-accept", { skip: !ON }, async () => {
  const [a, b, c] = [u("a"), u("b"), u("c")];
  const meA = await profile(a);
  const meB = await profile(b);
  await profile(c);
  assert.equal(await reason(F.request(db, a, { code: meA.code }, NOW)), "invalid-argument:friends-self");
  assert.equal(await reason(F.request(db, a, { code: "ZZZZZZ" }, NOW)), "not-found:friends-not-found");
  await befriend(a, b);
  assert.equal((await F.request(db, a, { code: meB.code }, NOW)).status, "already");
  const syncA = await F.sync(db, a, {}, NOW);
  assert.equal(syncA.friends.length, 1);
  assert.equal(syncA.friends[0].displayName, "Lifter b");
  assert.ok(!JSON.stringify(syncA).includes(b), "no uid leaks");
  // c → a and a → c: the second accepts.
  const codeA = meA.code;
  const codeC = (await F.sync(db, c, {}, NOW)).me!.code;
  assert.equal((await F.request(db, c, { code: codeA }, NOW)).status, "sent");
  assert.equal((await F.request(db, a, { code: codeC }, NOW)).status, "accepted");
  assert.equal((await F.sync(db, c, {}, NOW)).friends.length, 1);
  // Regenerated code: the old one stops working.
  const regenerated = await F.profileSet(db, b, { displayName: "B", emoji: "🦁", regenerateCode: true }, NOW);
  assert.notEqual(regenerated.me.code, meB.code);
  assert.equal(await reason(F.request(db, c, { code: meB.code }, NOW)), "not-found:friends-not-found");
});

test("outgoing request limit", { skip: !ON }, async () => {
  const me = u("lim");
  await profile(me);
  for (let i = 0; i < MAX_OUTGOING; i++) {
    const other = u(`t${i}`);
    const p = await profile(other);
    assert.equal((await F.request(db, me, { code: p.code }, NOW)).status, "sent");
  }
  const extra = await profile(u("t_extra"));
  assert.equal(await reason(F.request(db, me, { code: extra.code }, NOW)), "resource-exhausted:friends-limit");
});

test("code lookups are capped a day, found or not", { skip: !ON }, async () => {
  const me = u("look");
  await profile(me);
  for (let i = 0; i < F.CODE_LOOKUPS_PER_DAY; i++) {
    assert.equal(await reason(F.request(db, me, { code: "ZZZZZZ" }, NOW)), "not-found:friends-not-found");
  }
  const real = await profile(u("look_t"));
  assert.equal(await reason(F.request(db, me, { code: real.code }, NOW)), "resource-exhausted:friends-tries-limit");
  // A new UTC day starts over.
  assert.equal((await F.request(db, me, { code: real.code }, NOW + 86400000)).status, "sent");
});

test("a declined request can't be sent again at once", { skip: !ON }, async () => {
  const [a, b] = [u("dca"), u("dcb")];
  const meA = await profile(a);
  const meB = await profile(b);
  assert.equal((await F.request(db, a, { code: meB.code }, NOW)).status, "sent");
  const req = (await F.sync(db, b, {}, NOW)).incoming[0];
  await F.respond(db, b, { requestId: req.id, accept: false }, NOW);
  // Reads as sent, and nothing reaches b.
  assert.equal((await F.request(db, a, { code: meB.code }, NOW)).status, "sent");
  assert.equal((await F.sync(db, b, {}, NOW)).incoming.length, 0);
  assert.equal((await F.sync(db, a, {}, NOW)).outgoing.length, 0);
  // b asking a lifts it.
  assert.equal((await F.request(db, b, { code: meA.code }, NOW)).status, "sent");
  assert.equal((await F.sync(db, a, {}, NOW)).incoming.length, 1);
});

test("block hides both ways and looks like not-found", { skip: !ON }, async () => {
  const [a, b] = [u("ba"), u("bb")];
  const meA = await profile(a);
  const meB = await profile(b);
  await befriend(a, b);
  const id = (await F.sync(db, a, {}, NOW)).friends[0].id;
  await F.report(db, a, { friendId: id, reason: "spam" }, NOW);
  await F.block(db, a, { friendId: id }, NOW);
  assert.equal((await F.sync(db, a, {}, NOW)).friends.length, 0);
  assert.equal((await F.sync(db, b, {}, NOW)).friends.length, 0);
  assert.equal(await reason(F.request(db, b, { code: meA.code }, NOW)), "not-found:friends-not-found");
  assert.equal(await reason(F.request(db, a, { code: meB.code }, NOW)), "not-found:friends-not-found");
});

test("feed, sharing, reactions and nudges", { skip: !ON }, async () => {
  const [a, b] = [u("fa"), u("fb")];
  await profile(a);
  await profile(b, { meals: false });
  await befriend(a, b);
  await F.post(db, b, {
    events: [
      { kind: "workout", day: "2026-11-28", data: { title: "Push", minutes: 50, sets: 16 } },
      { kind: "meals", day: "2026-11-28", data: { count: 3 } },
      { kind: "water", day: "2026-11-28" },
    ],
    week: { weekStart: "2026-11-23", workouts: 2, streak: 4, goalPct: 70 },
  }, NOW);
  // Posting again dedups.
  await F.post(db, b, { events: [{ kind: "workout", day: "2026-11-28", data: { title: "push", minutes: 55, sets: 18 } }] }, NOW + 1000);
  const feedA = await F.feed(db, a, {}, NOW + 2000);
  assert.deepEqual(feedA.items.map((i) => i.kind).sort(), ["water", "workout"]);
  const workout = feedA.items.find((i) => i.kind === "workout")!;
  assert.deepEqual(workout.data, { title: "push", minutes: 55, sets: 18 });
  // A later session that day updates the same card.
  await F.post(db, b, { events: [{ kind: "workout", day: "2026-11-28", data: { title: "Push · Back", minutes: 80, sets: 24 } }] }, NOW + 1500);
  const updated = (await F.feed(db, a, {}, NOW + 2000)).items.filter((i) => i.kind === "workout");
  assert.equal(updated.length, 1);
  assert.equal(updated[0].id, workout.id);
  assert.equal(updated[0].data.title, "Push · Back");
  assert.notEqual(workout.friendId, "me");
  await F.react(db, a, { eventId: workout.id, emoji: "🔥" }, NOW);
  await F.react(db, a, { eventId: workout.id, emoji: "💪" }, NOW);
  const after = (await F.feed(db, a, {}, NOW + 2000)).items.find((i) => i.id === workout.id)!;
  assert.equal(after.myReaction, "💪");
  assert.equal(after.reactions["💪"], 1);
  assert.equal(after.reactions["🔥"], 0);
  const board = (await F.sync(db, a, {}, NOW + 2000)).friends[0];
  assert.deepEqual(board.week, { workouts: 2, streak: 4, goalPct: null });
  // Nudges: one a day per friend, delivered once.
  await F.nudge(db, a, { friendId: board.id, kind: "train" }, NOW);
  assert.equal(await reason(F.nudge(db, a, { friendId: board.id, kind: "cheer" }, NOW)), "resource-exhausted:friends-nudged-today");
  const inbox = (await F.sync(db, b, {}, NOW)).inbox;
  assert.equal(inbox.length, 1);
  assert.equal(inbox[0].kind, "train");
  assert.equal((await F.sync(db, b, {}, NOW)).inbox.length, 0);
  // Muted: accepted, never delivered.
  await F.mute(db, b, { friendId: board.id, muted: true });
  await F.nudge(db, a, { friendId: board.id, kind: "water" }, NOW + 2 * 86400000);
  assert.equal((await F.sync(db, b, {}, NOW + 2 * 86400000)).inbox.length, 0);
  // Water sharing off takes the water item back for good.
  await F.profileSet(db, b, { displayName: "Lifter fb", emoji: "💪", share: { water: false } }, NOW + 3000);
  await F.profileSet(db, b, { displayName: "Lifter fb", emoji: "💪", share: { water: true } }, NOW + 4000);
  assert.deepEqual((await F.feed(db, a, {}, NOW + 5000)).items.map((i) => i.kind), ["workout"]);
});

test("deleteFriendsData leaves nothing that names the member", { skip: !ON }, async () => {
  const [a, b] = [u("da"), u("db")];
  await profile(a);
  await profile(b);
  await befriend(a, b);
  const id = (await F.sync(db, a, {}, NOW)).friends[0].id;
  await F.post(db, a, { events: [{ kind: "water", day: "2026-11-28" }] }, NOW);
  await F.post(db, b, { events: [{ kind: "water", day: "2026-11-28" }] }, NOW);
  const bEvent = (await F.feed(db, a, {}, NOW)).items.find((i) => i.friendId !== "me")!;
  await F.react(db, a, { eventId: bEvent.id, emoji: "👏" }, NOW);
  await F.nudge(db, a, { friendId: id, kind: "cheer" }, NOW);
  await F.report(db, a, { friendId: id, reason: "other" }, NOW);
  await F.report(db, b, { friendId: id, reason: "spam" }, NOW);
  const reportAboutA = (await db.collection("friendReports").where("subject", "==", a).get()).docs[0].ref;
  await deleteFriendsData(db, a);

  const checks = await Promise.all([
    db.doc(`friendProfiles/${a}`).get(),
    db.collection("friendCodes").where("uid", "==", a).get(),
    db.collection("friendships").where("uids", "array-contains", a).get(),
    db.collection("friendEvents").where("uid", "==", a).get(),
    db.collection("nudges").where("from", "==", a).get(),
    db.collection("friendReports").where("reporter", "==", a).get(),
    db.collection("friendReports").where("subject", "==", a).get(),
  ]);
  assert.equal(checks[0].exists, false);
  for (const snap of checks.slice(1)) assert.equal((snap as FirebaseFirestore.QuerySnapshot).size, 0);
  const event = await db.doc(`friendEvents/${bEvent.id}`).get();
  assert.deepEqual(event.get("reactions"), {});
  const about = await reportAboutA.get();
  assert.equal(about.get("reason"), "spam");
  for (const field of ["subject", "subjectName", "subjectEmoji"]) assert.equal(about.get(field), undefined, field);
  assert.equal((await F.sync(db, b, {}, NOW)).friends.length, 0);
  assert.equal((await F.feed(db, b, {}, NOW)).items.length, 1);
});
