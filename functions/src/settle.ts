/**
 * What a failed AI call costs the member. The unit `take` reserved goes back
 * in full when OpenAI billed nothing: our own check stopped the call first
 * (the free moderation screen, say), OpenAI couldn't be reached, or it
 * answered with an error. When OpenAI may have billed the call (a timeout,
 * a member who left mid-call, an empty, cut-off or unreadable answer, an
 * image blocked after it was made), the unit goes back only a few times a
 * period (REFUND_CAP), so failures provoked on purpose can't make calls
 * free, while an honest member rarely notices.
 */
import { HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { APIConnectionError, APIConnectionTimeoutError, APIError, APIUserAbortError } from "openai";
import type { Member } from "./access.js";
import type { Plan } from "./config.js";
import { giveBack, refund, type Feature } from "./quota.js";
import { isSafetyRefusal, moderationStage } from "./openai.js";
import { Reason } from "./reasons.js";

/** Possibly billed failures given back per period: per day for chat and
 *  meal scans, per year for goal photos on a paid plan (2 a year at about
 *  $0.06 each caps what provoked failures can cost). */
export const REFUND_CAP: Record<Feature, number> = { chat: 3, meal: 3, goalPhoto: 2 };

/** A free account's one goal photo is given back once in all, so a failure
 *  provoked on purpose can't make it free again and again. */
export function refundCap(feature: Feature, tier: Plan): number {
  return tier === "free" ? 1 : REFUND_CAP[feature];
}

/** Whether the connection to OpenAI itself timed out, so the request never
 *  reached it: Node's fetch reports undici's UND_ERR_CONNECT_TIMEOUT in the
 *  cause chain of the SDK's timeout error. */
function neverConnected(error: unknown): boolean {
  let cause = (error as { cause?: unknown } | null)?.cause;
  for (let depth = 0; cause && depth < 5; depth++) {
    if ((cause as { code?: unknown }).code === "UND_ERR_CONNECT_TIMEOUT") return true;
    cause = (cause as { cause?: unknown }).cause;
  }
  return false;
}

/** Whether OpenAI could have billed the call that ended in `error`.
 *  `answered` is true once OpenAI returned a response, usable or not. */
export function mayHaveBilled(error: unknown, answered: boolean): boolean {
  if (answered) return true;
  if (error instanceof HttpsError) return false;
  if (error instanceof APIConnectionTimeoutError && neverConnected(error)) return false;
  // Gave up while OpenAI may have been working on it.
  if (error instanceof APIConnectionTimeoutError || error instanceof APIUserAbortError) return true;
  // Never reached OpenAI.
  if (error instanceof APIConnectionError) return false;
  // OpenAI refused or failed the request; an image blocked after it was
  // generated may still be billed.
  if (error instanceof APIError && typeof error.status === "number") {
    return isSafetyRefusal(error) && moderationStage(error) !== "input";
  }
  // Anything unexpected: assume it was billed.
  return true;
}

/** Gives the member's unit back, or not, after a failed call. Returns
 *  whether it went back. */
export async function settle(member: Member<Plan>, feature: Feature, periodKey: string, error: unknown, answered: boolean): Promise<boolean> {
  if (!mayHaveBilled(error, answered)) return giveBack(member.usageKey, feature, periodKey);
  const refunded = await refund(member.usageKey, feature, periodKey, refundCap(feature, member.tier));
  logger.warn(`${feature}: possibly billed call failed`, { uid: member.uid, refunded, answered, error: String(error) });
  return refunded;
}

/** The error the app gets for a failed call: ours as it was, anything else
 *  as "ai-unavailable", with `details.remaining`, what's left after this
 *  call, so the app's count stays right when a failure kept the unit. */
export function failure(error: unknown, remaining: number): HttpsError {
  if (error instanceof HttpsError) {
    const details = error.details && typeof error.details === "object" ? error.details : {};
    return new HttpsError(error.code, error.message, { ...details, remaining });
  }
  return new HttpsError("unavailable", Reason.ai, { remaining });
}
