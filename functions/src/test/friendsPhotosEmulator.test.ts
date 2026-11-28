/**
 * Photo check-ins against the Firestore emulator: fan-out, moderation,
 * limits, reactions, comments, reports, unfriend/block hooks, delete and
 * deleteAccount's cleanup. Photos go to an in-memory store and moderation
 * is faked. Skipped unless FIRESTORE_EMULATOR_HOST is set; run with
 *   firebase emulators:exec --project demo-musq --only firestore "node --test lib/test/friendsPhotosEmulator.test.js"
 */
import { test, before } from "node:test";
import assert from "node:assert/strict";
import { initializeApp, getApps } from "firebase-admin/app";
import { getFirestore, type Firestore } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import * as F from "../friends.js";
import * as P from "../friendsPhotos.js";
import { deleteFriendsData } from "../friendsAccount.js";
import { PHOTOS_PER_DAY, REACTIONS_PER_DAY } from "../friendsPhotosRules.js";
import { fakeJpeg } from "./jpegFixture.js";

const ON = !!process.env.FIRESTORE_EMULATOR_HOST;
let db: Firestore;
const NOW = Date.parse("2026-11-28T10:00:00Z");
const run = Math.random().toString(36).slice(2, 8);
const u = (name: string) => `${name}_${run}`;

const objects = new Map<string, Buffer>();
const moderated: string[][] = [];
const deps: P.Deps = {
  store: {
    async save(path, jpeg) { objects.set(path, jpeg); },
    async remove(path) { objects.delete(path); },
  },
  async moderate(texts, jpeg) {
    moderated.push(texts);
    assert.ok(!jpeg || !jpeg.toString("latin1").includes("GPS"), "moderation sees the stripped photo");
    return texts.some((t) => t.includes("[flag]"));
  },
};
const IMAGE = fakeJpeg().toString("base64");

async function reason(p: Promise<unknown>): Promise<string> {
  try { await p; } catch (e) { return e instanceof HttpsError ? `${e.code}:${e.message}` : String(e); }
  return "ok";
}

async function profile(uid: string) {
  return (await F.profileSet(db, uid, { displayName: `Lifter ${uid.split("_")[0]}`, emoji: "💪" }, NOW)).me;
}

async function befriend(a: string, b: string) {
  const bCode = (await F.sync(db, b, {}, NOW)).me!.code;
  await F.request(db, a, { code: bCode }, NOW);
  const incoming = (await F.sync(db, b, {}, NOW)).incoming;
  await F.respond(db, b, { requestId: incoming.find(() => true)!.id, accept: true }, NOW);
}

/** The friend id `uid` has for the friend named `name`. */
async function friendId(uid: string, name: string) {
  return (await F.sync(db, uid, {}, NOW)).friends.find((f) => f.displayName === `Lifter ${name}`)!.id;
}

const copy = (uid: string, postId: string) => db.doc(`friendInbox/${uid}/posts/${postId}`).get();
const comments = async (uid: string, postId: string) => (await db.collection(`friendInbox/${uid}/posts/${postId}/comments`).get()).docs.map((d) => d.data());

async function post(uid: string, extra: Record<string, unknown> = {}, now = NOW) {
  return (await P.photoPost(db, uid, { imageBase64: IMAGE, caption: "Leg day", tag: "Legs · 40 min", ...extra }, deps, now)).post as Record<string, unknown> & { id: string };
}

before(() => {
  if (!ON) return;
  if (getApps().length === 0) initializeApp({ projectId: "demo-musq" });
  db = getFirestore();
});

test("a post fans out to the poster and friends only, with no uid and no metadata", { skip: !ON }, async () => {
  const [a, b, c, d] = [u("pa"), u("pb"), u("pc"), u("pd")];
  for (const x of [a, b, c, d]) await profile(x);
  await befriend(a, b);
  await befriend(a, c);
  const p = await post(a);
  assert.equal(p.authorId, "me");
  assert.equal(p.isMine, true);
  assert.equal(typeof p.createdAt, "string");
  assert.equal(p.caption, "Leg day");
  assert.equal(p.tag, "Legs · 40 min");
  assert.deepEqual(moderated.at(-1), ["Leg day", "Legs · 40 min"]);
  const [ca, cb, cc, cd] = await Promise.all([copy(a, p.id), copy(b, p.id), copy(c, p.id), copy(d, p.id)]);
  assert.ok(ca.exists && cb.exists && cc.exists);
  assert.equal(cd.exists, false);
  assert.equal(cb.get("authorId"), await friendId(b, "pa"));
  assert.equal(cb.get("isMine"), false);
  assert.equal(cb.get("imagePath"), `friendPhotos/${p.id}.jpg`);
  assert.equal(cb.get("width"), 1080);
  assert.deepEqual(cb.get("reactions"), { "🔥": 0, "💪": 0, "👏": 0, "❤️": 0 });
  assert.equal(cb.get("expireAt").toMillis() - cb.get("createdAt").toMillis(), 30 * 86400000);
  for (const snap of [ca, cb, cc]) for (const x of [a, b, c]) assert.ok(!JSON.stringify(snap.data()).includes(x), "no uid in readable docs");
  const stored = objects.get(`friendPhotos/${p.id}.jpg`)!;
  assert.ok(stored && !stored.toString("latin1").includes("GPS") && !stored.toString("latin1").includes("APPENDED"));
});

test("moderation, text rules and the daily photo limit", { skip: !ON }, async () => {
  const a = u("ma");
  await profile(a);
  // A flagged caption asks for other words; a flagged photo for another photo.
  assert.equal(await reason(post(a, { caption: "[flag] nope" })), "failed-precondition:friends-text-not-allowed");
  const photoFlagged: P.Deps = { ...deps, moderate: async (texts, jpeg) => !!jpeg || texts.some((t) => t.includes("[flag]")) };
  assert.equal(await reason(P.photoPost(db, a, { imageBase64: IMAGE, caption: "fine" }, photoFlagged, NOW)), "failed-precondition:friends-photo-not-allowed");
  assert.equal(await reason(post(a, { caption: "see www.spam.com" })), "failed-precondition:friends-text-not-allowed");
  assert.equal(await reason(P.photoPost(db, u("noprofile"), { imageBase64: IMAGE }, deps, NOW)), "failed-precondition:friends-profile-required");
  // The flagged tries counted (2); 8 more fit today.
  for (let i = 2; i < PHOTOS_PER_DAY; i++) await post(a, { caption: null, tag: null });
  assert.equal(await reason(post(a)), "resource-exhausted:friends-photo-limit");
  // Moderation down: refused, and the unit is given back.
  const down: P.Deps = { ...deps, moderate: async () => { throw new HttpsError("unavailable", "ai-unavailable"); } };
  const b = u("mb");
  await profile(b);
  assert.equal(await reason(P.photoPost(db, b, { imageBase64: IMAGE }, down, NOW)), "unavailable:ai-unavailable");
  assert.equal((await db.doc(`photoCounters/${b}`).get()).get("posts"), 0);
  // A new UTC day starts over.
  assert.ok((await post(a, {}, NOW + 86400000)).id);
});

test("reactions and comments reach every copy; only friends of the poster comment", { skip: !ON }, async () => {
  const [a, b, c, d] = [u("ra"), u("rb"), u("rc"), u("rd")];
  for (const x of [a, b, c, d]) await profile(x);
  await befriend(a, b);
  await befriend(a, c);
  await befriend(b, d);
  const p = await post(a);
  await P.photoReact(db, b, { postId: p.id, emoji: "🔥" }, undefined, NOW);
  await P.photoReact(db, c, { postId: p.id, emoji: "❤️" }, undefined, NOW);
  await P.photoReact(db, c, { postId: p.id, emoji: "🔥" }, undefined, NOW);
  for (const x of [a, b, c]) assert.deepEqual((await copy(x, p.id)).get("reactions"), { "🔥": 2, "💪": 0, "👏": 0, "❤️": 0 });
  assert.equal((await copy(b, p.id)).get("myReaction"), "🔥");
  assert.equal((await copy(a, p.id)).get("myReaction"), null);
  await P.photoReact(db, b, { postId: p.id, emoji: null }, undefined, NOW);
  assert.equal((await copy(b, p.id)).get("myReaction"), null);
  assert.equal((await copy(a, p.id)).get("reactions")["🔥"], 1);
  // d is b's friend, not a's: can't see, react or comment.
  assert.equal(await reason(P.photoReact(db, d, { postId: p.id, emoji: "🔥" }, undefined, NOW)), "not-found:friends-not-found");
  assert.equal(await reason(P.commentAdd(db, d, { postId: p.id, text: "hi" }, deps, NOW)), "not-found:friends-not-found");

  const cb = (await P.commentAdd(db, b, { postId: p.id, text: "Strong!" }, deps, NOW)).comment as Record<string, unknown> & { id: string };
  assert.equal(cb.authorId, "me");
  assert.equal(cb.text, "Strong!");
  const seenByC = await comments(c, p.id);
  assert.equal(seenByC.length, 1);
  assert.equal(seenByC[0].isMine, false);
  assert.equal(seenByC[0].displayName, "Lifter rb");
  assert.ok(!JSON.stringify(seenByC).includes(b));
  for (const x of [a, b, c]) assert.equal((await copy(x, p.id)).get("commentCount"), 1);
  assert.equal(await reason(P.commentAdd(db, c, { postId: p.id, text: "[flag] rude" }, deps, NOW)), "failed-precondition:friends-text-not-allowed");
  assert.equal(await reason(P.commentAdd(db, c, { postId: p.id, text: "x".repeat(301) }, deps, NOW)), "invalid-argument:text too long");
  // c can't delete b's comment; a (the poster) can.
  assert.equal(await reason(P.commentDelete(db, c, { postId: p.id, commentId: cb.id })), "not-found:friends-not-found");
  const cc = (await P.commentAdd(db, c, { postId: p.id, text: "Nice" }, deps, NOW)).comment as { id: string };
  await P.commentDelete(db, a, { postId: p.id, commentId: cb.id });
  await P.commentDelete(db, c, { postId: p.id, commentId: cc.id });
  for (const x of [a, b, c]) {
    assert.equal((await copy(x, p.id)).get("commentCount"), 0);
    assert.equal((await comments(x, p.id)).length, 0);
  }
  assert.equal((await db.doc(`friendPhotos/${p.id}`).get()).get("commentCount"), 0);
});

test("reports: the reporter stops seeing it; two friends hide the post", { skip: !ON }, async () => {
  const [a, b, c, e] = [u("ta"), u("tb"), u("tc"), u("te")];
  for (const x of [a, b, c, e]) await profile(x);
  for (const x of [b, c, e]) await befriend(a, x);
  const p = await post(a);
  const cm = (await P.commentAdd(db, b, { postId: p.id, text: "spam spam" }, deps, NOW)).comment as { id: string };
  await P.photoReport(db, c, { postId: p.id, commentId: cm.id, reason: "spam" }, undefined, NOW);
  assert.equal((await comments(c, p.id)).length, 0);
  assert.equal((await copy(c, p.id)).get("commentCount"), 0);
  assert.equal((await comments(e, p.id)).length, 1);
  assert.equal(await reason(P.photoReport(db, a, { postId: p.id, reason: "spam" }, undefined, NOW)), "not-found:friends-not-found");
  await P.photoReport(db, b, { postId: p.id, reason: "inappropriate" }, undefined, NOW);
  assert.equal((await copy(b, p.id)).exists, false);
  assert.equal((await comments(b, p.id)).length, 0, "the copy's comments go too");
  assert.equal((await copy(c, p.id)).exists, true);
  await P.photoReport(db, c, { postId: p.id, reason: "abusive" }, undefined, NOW);
  assert.equal((await copy(c, p.id)).exists, false);
  assert.equal((await copy(e, p.id)).exists, false);
  assert.equal((await copy(a, p.id)).get("hidden"), true);
  assert.equal(await reason(P.photoReact(db, e, { postId: p.id, emoji: "🔥" }, undefined, NOW)), "not-found:friends-not-found");
  const reports = await db.collection("friendReports").where("postId", "==", p.id).get();
  assert.deepEqual(reports.docs.map((d) => d.get("type")).sort(), ["comment", "post", "post"]);
  assert.ok(objects.has(`friendPhotos/${p.id}.jpg`), "the photo is kept for review");
});

test("unfriend and block take posts and comments away", { skip: !ON }, async () => {
  const [a, b, c] = [u("ua"), u("ub"), u("uc")];
  for (const x of [a, b, c]) await profile(x);
  await befriend(a, b);
  await befriend(a, c);
  await befriend(b, c);
  const pa = await post(a);
  const pb = await post(b);
  await P.commentAdd(db, c, { postId: pa.id, text: "first" }, deps, NOW);
  // c blocks b: c's comment on a's post leaves b's inbox; b's leave c's.
  await P.commentAdd(db, b, { postId: pa.id, text: "second" }, deps, NOW);
  await F.block(db, c, { friendId: await friendId(c, "ub") }, NOW);
  const bSees = await comments(b, pa.id);
  assert.deepEqual(bSees.map((x) => x.text), ["second"]);
  assert.equal((await copy(b, pa.id)).get("commentCount"), 1);
  assert.deepEqual((await comments(c, pa.id)).map((x) => x.text), ["first"]);
  assert.equal((await copy(c, pb.id)).exists, false, "b's post leaves c");
  // New comments skip blocked readers.
  await P.commentAdd(db, b, { postId: pa.id, text: "third" }, deps, NOW);
  assert.deepEqual((await comments(c, pa.id)).map((x) => x.text), ["first"]);
  assert.equal((await comments(a, pa.id)).length, 3);
  // Unfriend a and b: each loses the other's post (with its comments).
  await F.remove(db, a, { friendId: await friendId(a, "ub") }, NOW);
  assert.equal((await copy(b, pa.id)).exists, false);
  assert.equal((await comments(b, pa.id)).length, 0);
  assert.equal((await copy(a, pb.id)).exists, false);
  assert.ok(!(await db.doc(`friendPhotos/${pa.id}`).get()).get("recipients").includes(b));
  // And a reaction still updates the copies that are left.
  await P.photoReact(db, c, { postId: pa.id, emoji: "👏" }, undefined, NOW);
  assert.equal((await copy(a, pa.id)).get("reactions")["👏"], 1);
});

test("delete a post removes every copy, its comments and its photo", { skip: !ON }, async () => {
  const [a, b] = [u("xa"), u("xb")];
  await profile(a);
  await profile(b);
  await befriend(a, b);
  const p = await post(a);
  await P.commentAdd(db, b, { postId: p.id, text: "yo" }, deps, NOW);
  assert.equal(await reason(P.photoDelete(db, b, { postId: p.id }, deps)), "not-found:friends-not-found");
  await P.photoDelete(db, a, { postId: p.id }, deps);
  for (const x of [a, b]) {
    assert.equal((await copy(x, p.id)).exists, false);
    assert.equal((await comments(x, p.id)).length, 0);
  }
  assert.equal((await db.collection("friendPhotoComments").where("postId", "==", p.id).get()).size, 0);
  assert.equal((await db.doc(`friendPhotos/${p.id}`).get()).exists, false);
  assert.equal(objects.has(`friendPhotos/${p.id}.jpg`), false);
});

test("deleteFriendsData removes the member's photos, comments, reactions and inbox", { skip: !ON }, async () => {
  const [a, b, c] = [u("za"), u("zb"), u("zc")];
  for (const x of [a, b, c]) await profile(x);
  await befriend(a, b);
  await befriend(b, c);
  const pa = await post(a);
  const pb = await post(b);
  await P.commentAdd(db, a, { postId: pb.id, text: "from a" }, deps, NOW);
  await P.commentAdd(db, c, { postId: pb.id, text: "from c" }, deps, NOW);
  await P.photoReact(db, a, { postId: pb.id, emoji: "💪" }, undefined, NOW);
  await P.photoReport(db, c, { postId: pb.id, commentId: (await comments(c, pb.id)).find((x) => x.text === "from a")!.id, reason: "spam" }, undefined, NOW);
  await deleteFriendsData(db, a, deps.store);
  assert.equal((await db.doc(`friendPhotos/${pa.id}`).get()).exists, false);
  assert.equal(objects.has(`friendPhotos/${pa.id}.jpg`), false);
  assert.equal((await copy(b, pa.id)).exists, false);
  assert.deepEqual((await comments(b, pb.id)).map((x) => x.text), ["from c"]);
  assert.equal((await copy(b, pb.id)).get("commentCount"), 1);
  assert.equal((await copy(c, pb.id)).get("reactions")["💪"], 0);
  const stored = await db.doc(`friendPhotos/${pb.id}`).get();
  assert.ok(!stored.get("recipients").includes(a));
  assert.equal(stored.get("reactions")[a], undefined);
  assert.equal((await db.collection(`friendInbox/${a}/posts`).get()).size, 0);
  assert.equal((await db.collection("friendPhotoComments").where("uid", "==", a).get()).size, 0);
  const about = await db.collection("friendReports").where("commentId", "!=", null).get();
  for (const r of about.docs) if (r.get("type") === "comment" && r.get("reporter") === c && r.get("postId") === pb.id) {
    assert.equal(r.get("subject"), undefined);
    assert.equal(r.get("subjectText"), undefined);
  }
  assert.equal((await db.doc(`photoCounters/${a}`).get()).exists, false);
  // b and c carry on.
  await P.photoReact(db, c, { postId: pb.id, emoji: "🔥" }, undefined, NOW);
  assert.equal((await copy(b, pb.id)).get("reactions")["🔥"], 1);
});

test("reactions: no-op changes count nothing; changes stop at the daily limit", { skip: !ON }, async () => {
  const [a, b] = [u("la"), u("lb")];
  for (const x of [a, b]) await profile(x);
  await befriend(a, b);
  const p = await post(a);
  await P.photoReact(db, b, { postId: p.id, emoji: "🔥" }, undefined, NOW);
  await P.photoReact(db, b, { postId: p.id, emoji: "🔥" }, undefined, NOW);
  await P.photoReact(db, b, { postId: p.id, emoji: null }, undefined, NOW);
  await P.photoReact(db, b, { postId: p.id, emoji: null }, undefined, NOW);
  assert.equal((await db.doc(`photoCounters/${b}`).get()).get("reactions"), 2);
  await db.doc(`photoCounters/${b}`).set({ day: "2026-11-28", posts: 0, comments: 0, reactions: REACTIONS_PER_DAY });
  assert.equal(await reason(P.photoReact(db, b, { postId: p.id, emoji: "💪" }, undefined, NOW)), "resource-exhausted:friends-reaction-limit");
  assert.equal((await copy(a, p.id)).get("reactions")["💪"], 0);
  // A new UTC day starts over.
  await P.photoReact(db, b, { postId: p.id, emoji: "💪" }, undefined, NOW + 86400000);
  assert.equal((await copy(a, p.id)).get("reactions")["💪"], 1);
});

test("block a commenter who isn't a friend, from their comment", { skip: !ON }, async () => {
  // c is friends with a and b; a and b aren't friends.
  const [a, b, c] = [u("ka"), u("kb"), u("kc")];
  for (const x of [a, b, c]) await profile(x);
  await befriend(c, a);
  await befriend(c, b);
  const p1 = await post(c);
  await P.commentAdd(db, b, { postId: p1.id, text: "mean" }, deps, NOW);
  const held = (await comments(a, p1.id)).find((x) => x.text === "mean")!;
  assert.equal(held.isMine, false);
  // Not a friend id: friendsBlock with it is refused; with the comment it works.
  assert.equal(await reason(F.block(db, a, { friendId: held.authorId }, NOW)), "not-found:friends-not-found");
  assert.equal(await reason(F.block(db, a, { postId: p1.id, commentId: "0".repeat(32) }, NOW)), "not-found:friends-not-found");
  await F.block(db, a, { postId: p1.id, commentId: held.id }, NOW);
  assert.equal((await comments(a, p1.id)).length, 0);
  assert.equal((await copy(a, p1.id)).get("commentCount"), 0);
  // b's next comment on c's posts doesn't reach a, nor a's reach b.
  await P.commentAdd(db, b, { postId: p1.id, text: "again" }, deps, NOW);
  await P.commentAdd(db, a, { postId: p1.id, text: "hi c" }, deps, NOW);
  assert.deepEqual((await comments(a, p1.id)).map((x) => x.text), ["hi c"]);
  assert.deepEqual((await comments(b, p1.id)).map((x) => x.text).sort(), ["again", "mean"]);
  assert.equal((await db.collection("photoCleanups").where("a", "==", a).get()).size, 0, "the job is done and gone");
});

test("cleanups a call couldn't finish are finished by the sweep", { skip: !ON }, async () => {
  const [a, b] = [u("wa"), u("wb")];
  for (const x of [a, b]) await profile(x);
  await befriend(a, b);
  const posts = [await post(a), await post(a), await post(b)];
  await P.commentAdd(db, b, { postId: posts[0].id, text: "hey" }, deps, NOW);
  // As if friendsBlock had timed out right after its commit: the friendship
  // is gone and the job is there, the copies not touched yet.
  await db.doc(`friendships/${await friendId(a, "wb")}`).delete();
  const jobRef = P.cleanupRef(db, "block", a, b);
  await jobRef.set(P.cleanupJob("block", a, b, NOW));
  // A deadline already past does nothing and keeps the job.
  assert.equal(await P.settleCleanup(db, jobRef, P.cleanupJob("block", a, b, NOW), deps.store, Date.now() - 1), false);
  assert.equal((await jobRef.get()).exists, true);
  assert.equal((await copy(b, posts[0].id)).exists, true);
  // Jobs younger than 2 minutes are left to the call doing them.
  await P.sweepPhotos(db, deps.store, NOW + 60_000);
  assert.equal((await jobRef.get()).exists, true);
  const result = await P.sweepPhotos(db, deps.store, NOW + 3 * 60_000);
  assert.ok(result.jobs >= 1);
  assert.equal((await jobRef.get()).exists, false);
  assert.equal((await copy(b, posts[0].id)).exists, false);
  assert.equal((await copy(b, posts[1].id)).exists, false);
  assert.equal((await copy(a, posts[2].id)).exists, false);
  assert.equal((await comments(a, posts[0].id)).length, 0, "b's comment leaves a's copy");
});

test("the sweep deletes posts past 30 days with their photo files", { skip: !ON }, async () => {
  const [a, b] = [u("ea"), u("eb")];
  for (const x of [a, b]) await profile(x);
  await befriend(a, b);
  const old = await post(a, {}, NOW - 31 * 86400000);
  const fresh = await post(a);
  await P.sweepPhotos(db, deps.store, NOW);
  assert.equal((await db.doc(`friendPhotos/${old.id}`).get()).exists, false);
  assert.equal((await copy(b, old.id)).exists, false);
  assert.equal(objects.has(`friendPhotos/${old.id}.jpg`), false);
  assert.equal((await db.doc(`friendPhotos/${fresh.id}`).get()).exists, true);
  assert.ok(objects.has(`friendPhotos/${fresh.id}.jpg`));
});

test("account deletion takes the uid off posts it reported and comments it got; a past deadline leaves a job", { skip: !ON }, async () => {
  const [a, b, c] = [u("da"), u("db"), u("dc")];
  for (const x of [a, b, c]) await profile(x);
  await befriend(a, b);
  await befriend(b, c);
  const pb = await post(b);
  await P.commentAdd(db, c, { postId: pb.id, text: "from c" }, deps, NOW);
  await P.photoReport(db, a, { postId: pb.id, reason: "spam" }, undefined, NOW);
  const pa = await post(a);
  // Stopped at once: a's post isn't touched, the job stays for the sweep.
  await deleteFriendsData(db, a, deps.store, Date.now() - 1);
  assert.equal((await db.doc(`photoCleanups/account-${a}`).get()).exists, true);
  assert.equal((await copy(b, pa.id)).exists, true);
  await P.sweepPhotos(db, deps.store, Date.now() + 3 * 60_000);
  assert.equal((await db.doc(`photoCleanups/account-${a}`).get()).exists, false);
  assert.equal((await copy(b, pa.id)).exists, false);
  assert.equal(objects.has(`friendPhotos/${pa.id}.jpg`), false);
  const stored = await db.doc(`friendPhotos/${pb.id}`).get();
  assert.ok(!stored.get("reporters").includes(a));
  const comment = await db.collection("friendPhotoComments").where("postId", "==", pb.id).get();
  for (const doc of comment.docs) assert.ok(!doc.get("recipients").includes(a));
});
