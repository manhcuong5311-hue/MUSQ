/**
 * Daily, monthly and yearly allowances, counted in Firestore
 * `usage/{usageKey}/{feature}/{period}`. A call takes one unit before
 * OpenAI is asked. A failed call gives it back (see settle.ts): always when
 * OpenAI billed nothing, and a few times a period when it may have. Each
 * daily, monthly or yearly counter deletes itself two days after its period
 * (Firestore TTL on `expireAt`, set up in firestore.indexes.json); a
 * one-time allowance's counter (period "once": the free goal photo, counted
 * per Apple ID) never expires.
 */
import { FieldValue, Timestamp, getFirestore } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import { Reason } from "./reasons.js";

export type Feature = "chat" | "meal" | "goalPhoto";

/** Time zone names as iOS sends them ("Asia/Ho_Chi_Minh", "UTC"). Raw
 *  offsets like "+23:59" are refused: they'd keep a day's key current for
 *  up to 72 hours instead of 50. */
const ZONE_NAME = /^(UTC|[A-Za-z]+(\/[A-Za-z0-9_+-]+)+)$/;

/** "2026-11-21", "2026-11" or "2026" in the member's own time zone (UTC
 *  when the zone is missing or unknown), so the day resets at their
 *  midnight. */
export function period(kind: "day" | "month" | "year", timeZone: unknown, now = new Date()): string {
  let zone = "UTC";
  if (typeof timeZone === "string" && timeZone.length <= 64 && ZONE_NAME.test(timeZone)) {
    try {
      new Intl.DateTimeFormat("en-CA", { timeZone });
      zone = timeZone;
    } catch {
      // Unknown zone: count in UTC.
    }
  }
  const parts = new Intl.DateTimeFormat("en-CA", { timeZone: zone, year: "numeric", month: "2-digit", day: "2-digit" })
    .formatToParts(now);
  const get = (type: string) => parts.find((p) => p.type === type)?.value ?? "00";
  if (kind === "year") return get("year");
  return kind === "day" ? `${get("year")}-${get("month")}-${get("day")}` : `${get("year")}-${get("month")}`;
}

/** The calendar year in the member's time zone (UTC when unknown). */
export function localYear(timeZone: unknown, now = new Date()): number {
  return Number(period("year", timeZone, now));
}

function counter(usageKey: string, feature: Feature, periodKey: string) {
  return getFirestore().doc(`usage/${usageKey}/${feature}/${periodKey}`);
}

const DAY_MS = 24 * 60 * 60 * 1000;

/** The period key of an allowance that never renews (the one free goal
 *  photo): its counter never expires. */
export const ONCE = "once";

/** What a period key counts, as the app reads it: "day" (2026-11-21),
 *  "month" (2026-11), "year" (2026), or "once" for an allowance that never
 *  renews. */
export function periodLabel(periodKey: string): "day" | "month" | "year" | "once" {
  if (periodKey === ONCE) return "once";
  const parts = periodKey.split("-").length;
  return parts === 1 ? "year" : parts === 2 ? "month" : "day";
}

/** When a counter may be deleted: two days after its period ends in UTC.
 *  A key stays current somewhere until 12 hours after that (UTC−12), so a
 *  counter is never deleted while its allowance can still be used. Never,
 *  for a one-time allowance. */
export function expiry(periodKey: string): Timestamp | undefined {
  if (periodKey === ONCE) return undefined;
  const [year, month, day] = periodKey.split("-").map(Number);
  const end = day ? Date.UTC(year, month - 1, day + 1) : month ? Date.UTC(year, month, 1) : Date.UTC(year + 1, 0, 1);
  return Timestamp.fromMillis(end + 2 * DAY_MS);
}

/** Takes one unit, or throws resource-exhausted with the member's plan and
 *  the kind of period, so the app can word it and offer a plan (or Pro to a
 *  Premium member). Returns what's left. */
export async function take(usageKey: string, feature: Feature, periodKey: string, limit: number, tier?: string): Promise<number> {
  const ref = counter(usageKey, feature, periodKey);
  return getFirestore().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const used = Number(snap.get("count") ?? 0);
    if (used >= limit) {
      const period = periodLabel(periodKey);
      throw new HttpsError("resource-exhausted", Reason.limit, { remaining: 0, period, ...(tier ? { tier } : {}) });
    }
    const expireAt = expiry(periodKey);
    tx.set(ref, { count: used + 1, updatedAt: FieldValue.serverTimestamp(), ...(expireAt ? { expireAt } : {}) }, { merge: true });
    return Math.max(0, limit - used - 1);
  });
}

/** Gives back a unit taken by `take` when OpenAI billed nothing for the
 *  failed call. Best effort; returns whether it did. */
export async function giveBack(usageKey: string, feature: Feature, periodKey: string): Promise<boolean> {
  const ref = counter(usageKey, feature, periodKey);
  try {
    return await getFirestore().runTransaction(async (tx) => {
      const snap = await tx.get(ref);
      const used = Number(snap.get("count") ?? 0);
      if (used <= 0) return false;
      tx.set(ref, { count: used - 1, updatedAt: FieldValue.serverTimestamp() }, { merge: true });
      return true;
    });
  } catch {
    // Losing one unit is better than failing the error path.
    return false;
  }
}

/** Gives back a unit whose OpenAI call may have been billed (a timeout, an
 *  empty or cut-off answer), at most `cap` times in the period, so failures
 *  provoked on purpose can't make calls free. Returns whether it did. */
export async function refund(usageKey: string, feature: Feature, periodKey: string, cap: number): Promise<boolean> {
  const ref = counter(usageKey, feature, periodKey);
  try {
    return await getFirestore().runTransaction(async (tx) => {
      const snap = await tx.get(ref);
      const used = Number(snap.get("count") ?? 0);
      const refunds = Number(snap.get("refunds") ?? 0);
      if (used <= 0 || refunds >= cap) return false;
      tx.set(ref, { count: used - 1, refunds: refunds + 1, updatedAt: FieldValue.serverTimestamp() }, { merge: true });
      return true;
    });
  } catch {
    return false;
  }
}
