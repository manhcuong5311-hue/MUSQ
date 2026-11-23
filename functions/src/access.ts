/**
 * Who may use the AI features: a signed-in member (Firebase Auth) whose
 * paid plan the server has verified from a signed App Store transaction
 * (see entitlements.ts), or a tester the owner listed in Firestore
 * `testers/{uid}` (Pro, or Premium when the doc says `tier: "premium"`).
 * The plan sets the allowances. Usage limits count per purchase, not per
 * account, so one purchase signed in on many accounts still shares one
 * allowance. The goal photo alone also opens to a signed-in member without
 * a plan, or whose plan lapsed: one goal photo ever per Apple ID (owner,
 * 2026-11-23). Chat and meal scans stay paid-only.
 */
import { createHash } from "node:crypto";
import { getFirestore } from "firebase-admin/firestore";
import { HttpsError, type CallableRequest } from "firebase-functions/v2/https";
import { PRODUCT_TIERS, aiConfig, inEmulator, limitsFor, type AIConfig, type Limits, type Plan, type Tier } from "./config.js";
import type { Feature } from "./quota.js";
import { Reason } from "./reasons.js";

export { Reason };

/** Who's calling. `requireMember` gives paid members only (P = Tier);
 *  `requireGoalPhotoMember` may also give a free account (P = Plan). */
export interface Member<P extends Plan = Tier> {
  uid: string;
  /** What usage is counted against: the purchase, the tester, or (a free
   *  goal photo) the Apple ID, or the account in the emulator. */
  usageKey: string;
  tier: P;
  limits: Limits;
  config: AIConfig;
}

function readTier(value: unknown): Tier | undefined {
  return value === "pro" || value === "premium" ? value : undefined;
}

/** The paid plan the member's Firestore records give, and what its usage
 *  counts against: a tester's (Pro unless the doc says `tier: "premium"`),
 *  else a verified purchase that's active and unexpired. Undefined without
 *  one, which is also what a lapsed or refunded plan gives. */
export function paidPlan(
  uid: string,
  tester: Record<string, unknown> | undefined,
  entitlement: Record<string, unknown> | undefined,
  now: number,
): { tier: Tier; usageKey: string } | undefined {
  if (tester) return { tier: readTier(tester.tier) ?? "pro", usageKey: `uid_${uid}` };
  if (!entitlement || entitlement.active !== true) return undefined;
  const expiresAt = (entitlement.expiresAt as { toMillis?: () => number } | null | undefined)?.toMillis?.();
  if (expiresAt !== undefined && expiresAt < now) return undefined;
  const purchase = typeof entitlement.originalTransactionId === "string" ? entitlement.originalTransactionId : uid;
  const tier = readTier(entitlement.tier) ?? PRODUCT_TIERS.get(String(entitlement.productId)) ?? "premium";
  return { tier, usageKey: `tx_${purchase}` };
}

/** The member's Sign in with Apple user id (Apple's `sub`) from their ID
 *  token: the same for every Firebase account that Apple ID signs in to,
 *  so it outlives a deleted account. Undefined for other accounts. */
export function appleSubject(token: unknown): string | undefined {
  const ids = (token as { firebase?: { identities?: Record<string, unknown> } } | null | undefined)?.firebase?.identities?.["apple.com"];
  const sub = Array.isArray(ids) ? ids[0] : undefined;
  return typeof sub === "string" && sub.length > 0 ? sub : undefined;
}

/** Where an Apple ID's free goal photo is counted: a salted hash of its
 *  Apple user id, which names no one and holds no uid, so deleteAccount
 *  keeps it and signing in again (a new uid) doesn't bring the photo back. */
export function freeUsageKey(appleSub: string): string {
  return `apple_${createHash("sha256").update(`musq-free:${appleSub}`).digest("hex").slice(0, 32)}`;
}

/** The free goal photo of a member without a plan: counted per Apple ID in
 *  the "once" period, so it never renews and a lapsed subscriber who used
 *  theirs gets no more. Sign in with Apple is the one sign-in the app
 *  offers, and an account without it (anonymous or email, which a script
 *  could make in a loop) gets none, except in the emulator, where it's
 *  counted on the uid for testing. Undefined when free goal photos are off
 *  (goalPhotoOnceLimitFree 0) or the account can't have one. */
export function freePlan(uid: string, config: AIConfig, appleSub: string | undefined, emulator: boolean): { tier: "free"; usageKey: string } | undefined {
  if (config.goalPhotoOnceLimitFree <= 0) return undefined;
  if (appleSub) return { tier: "free", usageKey: freeUsageKey(appleSub) };
  return emulator ? { tier: "free", usageKey: `uid_${uid}` } : undefined;
}

/** What a goal photo counts against: the paid plan on record, else the free
 *  photo. But when the app says this device holds a plan (`holdsPlan`) and
 *  the record shows none, it's a stale record (renewals never reach the
 *  server), not a free member: undefined, so the caller is refused with
 *  premium-required and the app syncs and retries instead of spending the
 *  free photo. */
export function goalPhotoPlan(
  paid: { tier: Tier; usageKey: string } | undefined,
  holdsPlan: boolean,
  free: { tier: "free"; usageKey: string } | undefined,
): { tier: Plan; usageKey: string } | undefined {
  if (paid) return paid;
  return holdsPlan ? undefined : free;
}

/** The checks every AI feature shares (sign-in, App Check, the feature's
 *  switch), then the caller's paid plan, if any. */
async function lookUp(request: CallableRequest<unknown>, feature: Feature) {
  if (!request.auth) throw new HttpsError("unauthenticated", Reason.signIn);
  const config = await aiConfig();
  if (config.enforceAppCheck && !request.app) {
    throw new HttpsError("unauthenticated", Reason.appCheck);
  }
  const enabled = feature === "chat" ? config.chatEnabled : feature === "meal" ? config.mealEnabled : config.goalPhotoEnabled;
  if (!enabled) throw new HttpsError("unavailable", Reason.off);

  const uid = request.auth.uid;
  const db = getFirestore();
  const [entitlement, tester] = await Promise.all([
    db.doc(`entitlements/${uid}`).get(),
    db.doc(`testers/${uid}`).get(),
  ]);
  const plan = paidPlan(uid, tester.data(), entitlement.data(), Date.now());
  return { uid, config, plan, appleSub: appleSubject(request.auth.token) };
}

/** A paid member (or tester); anyone else is refused (premium-required). */
export async function requireMember(request: CallableRequest<unknown>, feature: Feature): Promise<Member> {
  const { uid, config, plan } = await lookUp(request, feature);
  if (!plan) throw new HttpsError("permission-denied", Reason.premium);
  return { uid, ...plan, limits: limitsFor(config, plan.tier), config };
}

/** The goal photo's caller: a paid member as `requireMember` finds them, or
 *  else the member's one free goal photo (`freePlan`), unless the request
 *  says the device holds a plan (`holdsPlan: true`; see `goalPhotoPlan`).
 *  Anyone else is refused (premium-required) as before. */
export async function requireGoalPhotoMember(request: CallableRequest<unknown>): Promise<Member<Plan>> {
  const { uid, config, plan, appleSub } = await lookUp(request, "goalPhoto");
  const holdsPlan = (request.data as { holdsPlan?: unknown } | null | undefined)?.holdsPlan === true;
  const found = goalPhotoPlan(plan, holdsPlan, freePlan(uid, config, appleSub, inEmulator()));
  if (!found) throw new HttpsError("permission-denied", Reason.premium);
  return { uid, ...found, limits: limitsFor(config, found.tier), config };
}
