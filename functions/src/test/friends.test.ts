import { test } from "node:test";
import assert from "node:assert/strict";
import { HttpsError } from "firebase-functions/v2/https";
import {
  AVATAR_EMOJIS, CODE_ALPHABET, DEFAULT_SHARE, NUDGES_PER_DAY, afterCursor, boardWeek, decodeCursor, encodeCursor,
  eventId, feedOrder, isObjectionable, newCode, nudgeCheck, pairId, parseDay, readAvatar, readCode, readDisplayName,
  readEvent, readEvents, readId, readNudgeKind, readReaction, readReportReason, readShare, readWeek, requestId,
} from "../friendsRules.js";

const NOW = Date.parse("2026-11-28T10:00:00Z");
const DAY = 24 * 60 * 60 * 1000;
const code = (fn: () => unknown) => {
  try { fn(); } catch (e) { return e instanceof HttpsError ? `${e.code}:${e.message}` : String(e); }
  return "ok";
};

test("friend codes: 6 unambiguous characters, typed or pasted any way", () => {
  for (let i = 0; i < 200; i++) {
    const c = newCode();
    assert.match(c, /^[A-Z2-9]{6}$/);
    assert.ok(![...c].some((ch) => "ILO01".includes(ch)));
  }
  assert.equal(CODE_ALPHABET.length, 31);
  assert.equal(readCode("ab2c-d3"), "AB2CD3");
  assert.equal(readCode(" AB2 CD3 "), "AB2CD3");
  assert.equal(readCode("Add me on MUSQ: https://musq.app/f/AB2CD3"), "AB2CD3");
  assert.equal(code(() => readCode("ABCDE")), "not-found:friends-not-found");
  assert.equal(code(() => readCode("ABCDEI")), "not-found:friends-not-found");
  assert.equal(code(() => readCode(42)), "invalid-argument:code invalid");
});

test("ids are opaque, symmetric for a pair and directional for requests", () => {
  assert.equal(pairId("a", "b"), pairId("b", "a"));
  assert.notEqual(requestId("a", "b"), requestId("b", "a"));
  assert.match(pairId("uidA", "uidB"), /^[0-9a-f]{32}$/);
  assert.ok(!pairId("uidA", "uidB").includes("uidA"));
  assert.equal(eventId("u", "workout", "2026-11-28", "Push Day"), eventId("u", "workout", "2026-11-28", "push day"));
  assert.equal(code(() => readId("me")), "invalid-argument:id invalid");
  assert.equal(readId(pairId("a", "b")), pairId("a", "b"));
});

test("display names: trimmed, 1–24 characters, no links, contacts or banned words", () => {
  assert.equal(readDisplayName("  Sam   Nguyen \n"), "Sam Nguyen");
  assert.equal(readDisplayName("Trần Văn Lớn"), "Trần Văn Lớn");
  assert.equal(readDisplayName("Lon ton"), "Lon ton");
  assert.equal(readDisplayName("💪".repeat(24)), "💪".repeat(24));
  for (const bad of ["", "   ", "x".repeat(25), "visit musq.com", "www.x", "a@b.co", "call 0912 345 678", "F.u.c.k you", "sh1t", "b1tch", "shit", "thằng lồn", "Đm mày", "​"]) {
    assert.equal(code(() => readDisplayName(bad)), "invalid-argument:friends-name-invalid", bad);
  }
  assert.equal(code(() => readDisplayName(7)), "invalid-argument:friends-name-invalid");
  assert.equal(isObjectionable("Dickson"), false);
  assert.equal(isObjectionable("Essex lifter"), false);
});

test("avatars and reactions come from fixed lists, with or without the variation selector", () => {
  assert.equal(AVATAR_EMOJIS.length, 24);
  assert.equal(readAvatar("🏋"), "🏋️");
  assert.equal(readAvatar("🦁"), "🦁");
  assert.equal(code(() => readAvatar("🍆")), "invalid-argument:emoji invalid");
  assert.equal(readReaction("❤"), "❤️");
  assert.equal(readReaction(null), null);
  assert.equal(code(() => readReaction("😀")), "invalid-argument:emoji invalid");
  assert.equal(readNudgeKind("cheer"), "cheer");
  assert.equal(code(() => readNudgeKind("hey")), "invalid-argument:kind invalid");
  assert.equal(readReportReason("abusive name"), "abusive name");
  assert.equal(readReportReason("abusive-name"), "abusive name");
  assert.equal(code(() => readReportReason("bad")), "invalid-argument:reason invalid");
});

test("share toggles default to workouts and water on, meals and goal off", () => {
  assert.deepEqual(readShare(undefined), { workouts: true, water: true, meals: false, goal: false });
  assert.deepEqual(readShare({ meals: true, water: "yes" }), { workouts: true, water: true, meals: true, goal: false });
  assert.deepEqual(readShare({ workouts: false }, { ...DEFAULT_SHARE, goal: true }), { workouts: false, water: true, meals: false, goal: true });
});

test("days are real yyyy-MM-dd dates", () => {
  assert.equal(parseDay("2026-11-28"), Date.parse("2026-11-28T00:00:00Z"));
  assert.equal(parseDay("2026-02-30"), undefined);
  assert.equal(parseDay("2026-1-5"), undefined);
  assert.equal(parseDay(20261128), undefined);
});

test("events keep only each kind's small fields", () => {
  assert.deepEqual(readEvent({ kind: "workout", day: "2026-11-28", data: { title: " Push  Day ", minutes: 52.4, sets: 18, kcal: 400, photo: "x" } }, NOW),
    { kind: "workout", day: "2026-11-28", key: "", data: { title: "Push Day", minutes: 52, sets: 18 } });
  assert.deepEqual(readEvent({ kind: "workout", day: "2026-11-28", data: { title: "go to evil.com" } }, NOW)?.data, { title: "Workout", sets: 0 });
  assert.deepEqual(readEvent({ kind: "workout", day: "2026-11-28", data: { title: "Push", minutes: 0, sets: 3 } }, NOW)?.data,
    { title: "Push", sets: 3 }, "no minutes rather than 0 min");
  assert.deepEqual(readEvent({ kind: "workout", day: "2026-11-28", data: { title: "Push", groups: ["chest", "chest", "triceps", "evil.com", 3] } }, NOW)?.data,
    { title: "Push", sets: 0, groups: ["chest", "triceps"] });
  assert.deepEqual(readEvent({ kind: "water", day: "2026-11-28", data: { ml: 3000 } }, NOW)?.data, {});
  assert.deepEqual(readEvent({ kind: "meals", day: "2026-11-28", data: { count: 3, kcal: 2000 } }, NOW)?.data, { count: 3 });
  assert.equal(readEvent({ kind: "meals", day: "2026-11-28", data: { count: 0 } }, NOW), undefined);
  assert.deepEqual(readEvent({ kind: "pr", day: "2026-11-28", data: { exercise: "Bench Press", kg: 82.53 } }, NOW)?.data, { exercise: "Bench Press", kg: 82.5 });
  assert.equal(readEvent({ kind: "pr", day: "2026-11-28", data: { exercise: "Bench", kg: 5000 } }, NOW), undefined);
  assert.deepEqual(readEvent({ kind: "streak", day: "2026-11-28", data: { days: 7 } }, NOW)?.data, { days: 7 });
  assert.equal(readEvent({ kind: "steps", day: "2026-11-28", data: {} }, NOW), undefined);
  assert.equal(readEvent({ kind: "water", day: "2026-11-01", data: {} }, NOW), undefined, "too old");
  assert.equal(readEvent({ kind: "water", day: "2026-11-30", data: {} }, NOW), undefined, "future");
});

test("events the share toggles don't allow are dropped, repeats collapse", () => {
  const events = [
    { kind: "workout", day: "2026-11-28", data: { title: "Legs", minutes: 40, sets: 12 } },
    { kind: "workout", day: "2026-11-28", data: { title: "Legs · Back", minutes: 45, sets: 14 } },
    { kind: "meals", day: "2026-11-28", data: { count: 2 } },
    { kind: "water", day: "2026-11-28" },
    { kind: "pr", day: "2026-11-28", data: { exercise: "Squat", kg: 100 } },
  ];
  const all = readEvents(events, DEFAULT_SHARE, NOW);
  assert.deepEqual(all.map((e) => e.kind), ["workout", "water", "pr"]);
  assert.equal(all[0].data.minutes, 45);
  assert.deepEqual(readEvents(events, { workouts: false, water: false, meals: true, goal: false }, NOW).map((e) => e.kind), ["meals"]);
  assert.equal(code(() => readEvents(new Array(21).fill(events[3]), DEFAULT_SHARE, NOW)), "invalid-argument:too many events");
  assert.deepEqual(readEvents(undefined, DEFAULT_SHARE, NOW), []);
});

test("the week keeps goal % only with goal sharing and is bounded", () => {
  const week = { weekStart: "2026-11-23", workouts: 3, streak: 5, goalPct: 42 };
  assert.deepEqual(readWeek(week, DEFAULT_SHARE, NOW), { ...week, goalPct: null });
  assert.deepEqual(readWeek(week, { ...DEFAULT_SHARE, goal: true }, NOW), week);
  assert.equal(code(() => readWeek({ ...week, goalPct: 140 }, { ...DEFAULT_SHARE, goal: true }, NOW)), "invalid-argument:week invalid");
  assert.equal(code(() => readWeek({ ...week, weekStart: "2026-10-01" }, DEFAULT_SHARE, NOW)), "invalid-argument:week invalid");
  assert.equal(code(() => readWeek({ ...week, workouts: -1 }, DEFAULT_SHARE, NOW)), "invalid-argument:week invalid");
});

test("the board hides old weeks, stale streaks and what sharing hides", () => {
  const week = { weekStart: "2026-11-23", workouts: 3, streak: 5, goalPct: 42 };
  const share = { ...DEFAULT_SHARE, goal: true };
  assert.deepEqual(boardWeek(week, NOW - DAY, share, NOW), { workouts: 3, streak: 5, goalPct: 42 });
  assert.deepEqual(boardWeek(week, NOW - 4 * DAY, share, NOW), { workouts: 3, streak: 0, goalPct: 42 });
  assert.deepEqual(boardWeek(week, NOW, share, NOW + 9 * DAY), { workouts: 0, streak: 0, goalPct: null });
  assert.deepEqual(boardWeek(week, NOW, { ...share, workouts: false, goal: false }, NOW), { workouts: 0, streak: 0, goalPct: null });
  assert.deepEqual(boardWeek(undefined, undefined, share, NOW), { workouts: 0, streak: 0, goalPct: null });
});

test("nudges: one per friend a day, 20 a day in all, reset each day", () => {
  assert.equal(nudgeCheck(undefined, "p", "2026-11-28"), "ok");
  assert.equal(nudgeCheck({ day: "2026-11-28", total: 1, pairs: ["p"] }, "p", "2026-11-28"), "pair");
  assert.equal(nudgeCheck({ day: "2026-11-28", total: 1, pairs: ["p"] }, "q", "2026-11-28"), "ok");
  assert.equal(nudgeCheck({ day: "2026-11-28", total: NUDGES_PER_DAY, pairs: [] }, "q", "2026-11-28"), "total");
  assert.equal(nudgeCheck({ day: "2026-11-27", total: NUDGES_PER_DAY, pairs: ["p"] }, "p", "2026-11-28"), "ok");
});

test("feed cursor round-trips and pages without skipping ties", () => {
  const id = pairId("a", "b");
  assert.deepEqual(decodeCursor(encodeCursor(NOW, id)), { ms: NOW, id });
  assert.equal(decodeCursor(undefined), undefined);
  assert.equal(code(() => decodeCursor("nope")), "invalid-argument:before invalid");
  const items = [{ ms: 5, id: "b" }, { ms: 5, id: "a" }, { ms: 6, id: "c" }, { ms: 4, id: "d" }].sort(feedOrder);
  assert.deepEqual(items.map((i) => i.id), ["c", "b", "a", "d"]);
  const cursor = items[1];
  assert.deepEqual(items.filter((i) => afterCursor(i, cursor)).map((i) => i.id), ["a", "d"]);
});
