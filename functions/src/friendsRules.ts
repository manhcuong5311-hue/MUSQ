/**
 * MUSQ Friends v1: the pure rules (no Firestore) that every friends callable
 * applies to what the app sends: display names, avatars, friend codes, feed
 * events and the weekly board, plus the opaque ids the app sees.
 *
 * Ids the app sees never carry a uid or an Apple identifier:
 * - a friend id is the friendship's id, a salted SHA-256 of the two sorted
 *   uids (`pairId`), the same for both friends; it can't be turned back into
 *   a uid, and both friends already know each other;
 * - a request id is a salted hash of (from, to), so asking twice is one
 *   request;
 * - a feed item id is a salted hash of (uid, kind, day[, exercise]) (one
 *   workout, water, meals and streak item per day; one PR per exercise a
 *   day), which is also how the server dedups re-posted events.
 */
import { createHash, randomInt } from "node:crypto";
import { HttpsError } from "firebase-functions/v2/https";
import { Reason } from "./reasons.js";

// MARK: - Ids

function hashId(...parts: string[]): string {
  return createHash("sha256").update(`musq-friends:${parts.join("\u0000")}`).digest("hex").slice(0, 32);
}

/** The friendship's id (and the friend id both friends see). */
export function pairId(a: string, b: string): string {
  const [x, y] = a < b ? [a, b] : [b, a];
  return hashId("pair", x, y);
}

/** A friend request from `from` to `to`. */
export function requestId(from: string, to: string): string {
  return hashId("request", from, to);
}

/** A block of `blocked` by `by`. */
export function blockId(by: string, blocked: string): string {
  return hashId("block", by, blocked);
}

/** A report of `subject` by `reporter` (one per pair: a new one replaces it). */
export function reportId(reporter: string, subject: string): string {
  return hashId("report", reporter, subject);
}

/** A feed event: the day's workout, a PR (by exercise) or a daily event
 *  posted again on the same day is the same item. */
export function eventId(uid: string, kind: EventKind, day: string, key: string): string {
  return hashId("event", uid, kind, day, key.toLowerCase());
}

/** Ids the app sends back: our 32-hex ids only. */
export function readId(value: unknown, field = "id"): string {
  if (typeof value !== "string" || !/^[0-9a-f]{32}$/.test(value)) throw new HttpsError("invalid-argument", `${field} invalid`);
  return value;
}

// MARK: - Friend codes

/** A–Z and 2–9 without the look-alikes I, L and O (0 and 1 aren't used). */
export const CODE_ALPHABET = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";
export const CODE_LENGTH = 6;

export function newCode(): string {
  let code = "";
  for (let i = 0; i < CODE_LENGTH; i++) code += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
  return code;
}

/** A code as typed or pasted: case, spaces and dashes don't matter, and an
 *  invite link (https://musq.app/f/CODE) or share text carrying it works. */
export function readCode(value: unknown): string {
  if (typeof value !== "string" || value.length > 200) throw new HttpsError("invalid-argument", "code invalid");
  const link = value.match(/\/f\/([A-Za-z0-9-]{6,8})/);
  const raw = (link ? link[1] : value).toUpperCase().replace(/[\s-]/g, "");
  const ok = raw.length === CODE_LENGTH && [...raw].every((c) => CODE_ALPHABET.includes(c));
  if (!ok) throw new HttpsError("not-found", Reason.friendNotFound);
  return raw;
}

// MARK: - Profile

/** The avatars the app offers (owner's fixed list). Sent and stored with
 *  the variation selector stripped, so "🏋️" and "🏋" are the same one. */
export const AVATAR_EMOJIS = [
  "💪", "🔥", "🏋️", "🏃", "🚴", "🧘", "🥊", "⚡",
  "🦁", "🐯", "🐻", "🦊", "🐼", "🐨", "🦅", "🐺",
  "🦈", "🐉", "🌟", "🚀", "🎯", "🏆", "😎", "🤖",
] as const;

export const REACTIONS = ["🔥", "💪", "👏", "❤️"] as const;
export type Reaction = (typeof REACTIONS)[number];

const stripVS = (s: string) => s.replace(/️/g, "");

/** The canonical form (as listed above) of `value` if it's one of `list`. */
function pickEmoji<T extends string>(value: unknown, list: readonly T[]): T | undefined {
  if (typeof value !== "string" || value.length > 16) return undefined;
  const bare = stripVS(value.trim());
  return list.find((e) => stripVS(e) === bare);
}

export function readAvatar(value: unknown): string {
  const emoji = pickEmoji(value, AVATAR_EMOJIS);
  if (!emoji) throw new HttpsError("invalid-argument", "emoji invalid");
  return emoji;
}

/** A reaction, or null to take mine back. */
export function readReaction(value: unknown): Reaction | null {
  if (value === null || value === undefined) return null;
  const emoji = pickEmoji(value, REACTIONS);
  if (!emoji) throw new HttpsError("invalid-argument", "emoji invalid");
  return emoji;
}

export interface Share { workouts: boolean; water: boolean; meals: boolean; goal: boolean }
export const DEFAULT_SHARE: Share = { workouts: true, water: true, meals: false, goal: false };

export function readShare(value: unknown, current: Share = DEFAULT_SHARE): Share {
  const v = (value && typeof value === "object" ? value : {}) as Record<string, unknown>;
  const flag = (key: keyof Share) => (typeof v[key] === "boolean" ? (v[key] as boolean) : current[key]);
  return { workouts: flag("workouts"), water: flag("water"), meals: flag("meals"), goal: flag("goal") };
}

/** Words a display name (or a shared workout title) may not contain.
 *  English ones are matched after folding look-alike digits (f4ck); the
 *  Vietnamese ones with their tones, as whole words, since without tones
 *  they collide with everyday words (lồn / lớn). Kept short on purpose:
 *  reports catch the rest. */
const BANNED_EN_ANYWHERE = ["fuck", "cunt", "nigger", "nigga", "faggot", "porn", "rapist", "hitler", "pedo"];
const BANNED_EN_WORDS = ["shit", "bitch", "dick", "pussy", "whore", "slut", "rape", "nazi", "cock", "fag", "sex", "xxx", "kys"];
const BANNED_VI_WORDS = ["địt", "đụ", "lồn", "cặc", "buồi", "đéo", "đĩ", "dcm", "đcm", "đm", "dmm", "đmm", "vcl", "vkl", "vl", "clgt", "cmm", "óc chó", "mẹ mày", "con chó", "thằng chó"];

function fold(text: string): string {
  return text.toLowerCase()
    .replace(/[0]/g, "o").replace(/[1!|]/g, "i").replace(/[3]/g, "e").replace(/[4@]/g, "a").replace(/[5$]/g, "s").replace(/[7]/g, "t");
}

/** True when `text` holds a link, an email, a phone number or a banned word. */
export function isObjectionable(text: string): boolean {
  const lower = text.normalize("NFC").toLowerCase();
  if (/https?:|www\.|[a-z0-9-]\.(com|net|org|io|app|me|vn|co|ly|gg|xyz|link|info|biz|tk)\b/i.test(lower)) return true;
  if (/\S@\S/.test(lower)) return true;
  if ((lower.match(/\d/g) ?? []).length >= 7) return true;
  const folded = fold(lower);
  const lettersOnly = folded.replace(/[^a-z]/g, "");
  if (BANNED_EN_ANYWHERE.some((w) => lettersOnly.includes(w))) return true;
  const words = folded.split(/[^a-z]+/).filter(Boolean);
  if (BANNED_EN_WORDS.some((w) => words.includes(w))) return true;
  const viText = ` ${lower.replace(/[^\p{L}\p{N}]+/gu, " ").trim()} `;
  return BANNED_VI_WORDS.some((w) => viText.includes(` ${w} `));
}

/** A display name: trimmed, inner whitespace collapsed, 1–24 characters,
 *  no control or invisible characters, nothing objectionable. */
export function readDisplayName(value: unknown): string {
  if (typeof value !== "string" || value.length > 200) throw new HttpsError("invalid-argument", Reason.friendName);
  const name = value.normalize("NFC").replace(/[\u0000-\u001F\u007F-\u009F​-‏‪-‮⁠-⁯﻿]/g, "")
    .replace(/\s+/g, " ").trim();
  const length = [...name].length;
  if (length < 1 || length > 24 || isObjectionable(name)) throw new HttpsError("invalid-argument", Reason.friendName);
  return name;
}

// MARK: - Days

const DAY_MS = 24 * 60 * 60 * 1000;

/** "yyyy-MM-dd" that is a real date, or undefined. */
export function parseDay(value: unknown): number | undefined {
  if (typeof value !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(value)) return undefined;
  const ms = Date.parse(`${value}T00:00:00Z`);
  if (!Number.isFinite(ms) || new Date(ms).toISOString().slice(0, 10) !== value) return undefined;
  return ms;
}

export function utcDay(now: number): string {
  return new Date(now).toISOString().slice(0, 10);
}

// MARK: - Feed events

export const EVENT_KINDS = ["workout", "water", "meals", "streak", "pr"] as const;
export type EventKind = (typeof EVENT_KINDS)[number];

/** Which share toggle lets each kind through. */
export const EVENT_SHARE: Record<EventKind, keyof Share> = {
  workout: "workouts", streak: "workouts", pr: "workouts", water: "water", meals: "meals",
};

export interface PostedEvent { kind: EventKind; day: string; key: string; data: Record<string, string | number | string[]> }

/** Events per day per member, and per call. */
export const EVENTS_PER_DAY = 20;
export const EVENTS_PER_CALL = 20;
/** How far back (and ahead, for time zones) a posted day may be. */
const POST_DAYS_BACK = 14;

function int(value: unknown, min: number, max: number): number | undefined {
  return typeof value === "number" && Number.isFinite(value) && value >= min && value <= max ? Math.round(value) : undefined;
}

function shortText(value: unknown, max: number): string | undefined {
  if (typeof value !== "string") return undefined;
  const t = value.normalize("NFC").replace(/[\u0000-\u001F\u007F-\u009F​-‏‪-‮⁠-⁯﻿]/g, "").replace(/\s+/g, " ").trim();
  if (!t) return undefined;
  return [...t].slice(0, max).join("");
}

/** One event as the app sends it, cut down to the fields that kind shares,
 *  or undefined when it's malformed (dropped, not an error, so one bad
 *  event doesn't lose the rest). Never calories, weights, photos or health
 *  data: only titles, counts, minutes and a PR's kg. */
/** MuscleGroup raw values in the app (Models/TrainingModels.swift). */
const MUSCLE_GROUPS = new Set([
  "chest", "back", "shoulders", "biceps", "triceps", "forearms",
  "abs", "glutes", "quads", "hamstrings", "calves", "adductors",
]);

export function readEvent(value: unknown, now: number): PostedEvent | undefined {
  if (!value || typeof value !== "object") return undefined;
  const v = value as Record<string, unknown>;
  const kind = EVENT_KINDS.find((k) => k === v.kind);
  const dayMs = parseDay(v.day);
  if (!kind || dayMs === undefined) return undefined;
  if (dayMs > now + DAY_MS || dayMs < now - (POST_DAYS_BACK + 1) * DAY_MS) return undefined;
  const day = v.day as string;
  const d = (v.data && typeof v.data === "object" ? v.data : {}) as Record<string, unknown>;
  switch (kind) {
    case "workout": {
      let title = shortText(d.title, 60) ?? "Workout";
      if (isObjectionable(title)) title = "Workout";
      // No minutes when the app couldn't time the sets (no "0 min" card).
      const minutes = int(d.minutes, 1, 600);
      const sets = int(d.sets, 0, 300) ?? 0;
      // The muscle-group keys (the app's MuscleGroup raw values), so each
      // reader's app names them in its own language. Known keys only.
      const groups = Array.isArray(d.groups)
        ? [...new Set(d.groups.filter((g): g is string => typeof g === "string" && MUSCLE_GROUPS.has(g)))].slice(0, 8)
        : [];
      // One workout card per day: later posts that day (another session,
      // more sets) update it instead of adding a card per title.
      return {
        kind, day, key: "",
        data: { title, ...(minutes === undefined ? {} : { minutes }), sets, ...(groups.length ? { groups } : {}) },
      };
    }
    case "water":
      return { kind, day, key: "", data: {} };
    case "meals": {
      const count = int(d.count, 1, 20);
      return count === undefined ? undefined : { kind, day, key: "", data: { count } };
    }
    case "streak": {
      const days = int(d.days, 1, 3650);
      return days === undefined ? undefined : { kind, day, key: "", data: { days } };
    }
    case "pr": {
      const exercise = shortText(d.exercise, 60);
      const kg = typeof d.kg === "number" && Number.isFinite(d.kg) && d.kg > 0 && d.kg <= 1000 ? Math.round(d.kg * 10) / 10 : undefined;
      if (!exercise || kg === undefined || isObjectionable(exercise)) return undefined;
      return { kind, day, key: exercise, data: { exercise, kg } };
    }
  }
}

/** The events of a friendsPost call the member's share toggles allow,
 *  malformed ones dropped and repeats (same kind, day and, for a PR,
 *  exercise) collapsed to the last. */
export function readEvents(value: unknown, share: Share, now: number): PostedEvent[] {
  if (value === undefined || value === null) return [];
  if (!Array.isArray(value)) throw new HttpsError("invalid-argument", "events invalid");
  if (value.length > EVENTS_PER_CALL) throw new HttpsError("invalid-argument", "too many events");
  const byKey = new Map<string, PostedEvent>();
  for (const raw of value) {
    const event = readEvent(raw, now);
    if (!event || !share[EVENT_SHARE[event.kind]]) continue;
    byKey.set(`${event.kind}\u0000${event.day}\u0000${event.key.toLowerCase()}`, event);
  }
  return [...byKey.values()];
}

// MARK: - Weekly board

export interface Week { weekStart: string; workouts: number; streak: number; goalPct: number | null }

/** The week the app sends with a post: its own local week (Monday start).
 *  The goal % is kept only while goal sharing is on, and never a weight. */
export function readWeek(value: unknown, share: Share, now: number): Week | undefined {
  if (value === undefined || value === null) return undefined;
  if (typeof value !== "object") throw new HttpsError("invalid-argument", "week invalid");
  const v = value as Record<string, unknown>;
  const startMs = parseDay(v.weekStart);
  const workouts = int(v.workouts, 0, 50);
  const streak = int(v.streak, 0, 3650);
  if (startMs === undefined || workouts === undefined || streak === undefined) throw new HttpsError("invalid-argument", "week invalid");
  if (startMs > now + 2 * DAY_MS || startMs < now - 15 * DAY_MS) throw new HttpsError("invalid-argument", "week invalid");
  const pct = v.goalPct === null || v.goalPct === undefined ? null : int(v.goalPct, 0, 100);
  if (pct === undefined) throw new HttpsError("invalid-argument", "week invalid");
  return { weekStart: v.weekStart as string, workouts, streak, goalPct: share.goal ? pct : null };
}

/** A friend's row on the board as of `now`: a week that has ended counts
 *  0 workouts, a streak not refreshed for 3 days is 0, and what their
 *  toggles hide is hidden (workouts off hides workouts and streak). */
export function boardWeek(week: Week | undefined, lastActiveMs: number | undefined, share: Share, now: number): { workouts: number; streak: number; goalPct: number | null } {
  if (!week) return { workouts: 0, streak: 0, goalPct: null };
  const startMs = parseDay(week.weekStart) ?? 0;
  // The client's local Monday; allow a day either side for time zones.
  const current = now - startMs < 8 * DAY_MS;
  const fresh = lastActiveMs !== undefined && now - lastActiveMs < 3 * DAY_MS;
  return {
    workouts: share.workouts && current ? week.workouts : 0,
    streak: share.workouts && fresh ? week.streak : 0,
    goalPct: share.goal && current ? week.goalPct : null,
  };
}

// MARK: - Nudges

export const NUDGE_KINDS = ["train", "water", "meal", "cheer"] as const;
export type NudgeKind = (typeof NUDGE_KINDS)[number];
export const NUDGES_PER_DAY = 20;

export function readNudgeKind(value: unknown): NudgeKind {
  const kind = NUDGE_KINDS.find((k) => k === value);
  if (!kind) throw new HttpsError("invalid-argument", "kind invalid");
  return kind;
}

/** Whether a sender may nudge `pair` today given their counter doc (one per
 *  sender, reset each UTC day): "ok", or which limit is hit. */
export function nudgeCheck(counter: { day?: unknown; total?: unknown; pairs?: unknown } | undefined, pair: string, today: string): "ok" | "pair" | "total" {
  if (!counter || counter.day !== today) return "ok";
  const pairs = Array.isArray(counter.pairs) ? counter.pairs : [];
  if (pairs.includes(pair)) return "pair";
  return typeof counter.total === "number" && counter.total >= NUDGES_PER_DAY ? "total" : "ok";
}

// MARK: - Limits and safety

export const MAX_FRIENDS = 50;
export const MAX_OUTGOING = 20;

export const REPORT_REASONS = ["spam", "abusive name", "other"] as const;
export type ReportReason = (typeof REPORT_REASONS)[number];

export function readReportReason(value: unknown): ReportReason {
  // The app sends "abusive-name" (its enum's raw value); both spellings count.
  const reason = REPORT_REASONS.find((r) => r === value || r.replace(" ", "-") === value);
  if (!reason) throw new HttpsError("invalid-argument", "reason invalid");
  return reason;
}

// MARK: - Feed cursor

/** The feed's page cursor: the last item's time and id, opaque to the app. */
export function encodeCursor(ms: number, id: string): string {
  return `${ms.toString(36)}.${id}`;
}

export function decodeCursor(value: unknown): { ms: number; id: string } | undefined {
  if (value === undefined || value === null || value === "") return undefined;
  if (typeof value !== "string" || value.length > 60) throw new HttpsError("invalid-argument", "before invalid");
  const m = value.match(/^([0-9a-z]{1,12})\.([0-9a-f]{32})$/);
  if (!m) throw new HttpsError("invalid-argument", "before invalid");
  return { ms: parseInt(m[1], 36), id: m[2] };
}

/** Newest first; ties by id, so paging never skips or repeats an item. */
export function feedOrder(a: { ms: number; id: string }, b: { ms: number; id: string }): number {
  return b.ms - a.ms || (a.id < b.id ? 1 : a.id > b.id ? -1 : 0);
}

/** Whether an item comes after the cursor in feed order. */
export function afterCursor(item: { ms: number; id: string }, cursor: { ms: number; id: string } | undefined): boolean {
  return !cursor || feedOrder(cursor, item) < 0;
}
