/**
 * What the AI features run on and how much each member may use, read from
 * Firestore `config/ai` so models and limits can change without an app
 * update (OpenAI retires models every few months). Anything missing from
 * that document falls back to the defaults here.
 */
import { getFirestore } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { Reason } from "./reasons.js";

export const REGION = "asia-southeast1";
export const BUNDLE_ID = "com.SamCorp.GymWorkout";
/** The app's App Store id, required to verify production transactions. */
export const APP_APPLE_ID = 6816021196;
/** The paid plans: Premium (the first plans, lifetime included, which
 *  keeps Premium for good after it's taken off sale) and Pro above it, with
 *  higher AI allowances. */
export type Tier = "premium" | "pro";
/** Who a goal photo is counted for: a paid plan, or "free", a signed-in
 *  account without one, which gets one goal photo ever (owner,
 *  2026-11-23). Chat and meal scans stay paid-only. */
export type Plan = Tier | "free";

/** Which plan each App Store product gives (see the app's Purchases). */
export const PRODUCT_TIERS: ReadonlyMap<string, Tier> = new Map<string, Tier>([
  ["com.SamCorp.GymWorkout.removeads.yearly", "premium"],
  ["com.SamCorp.GymWorkout.removeads.lifetime", "premium"],
  ["com.SamCorp.GymWorkout.pro.monthly", "pro"],
  ["com.SamCorp.GymWorkout.pro.yearly", "pro"],
]);

export type ImageQuality = "low" | "medium" | "high";
/** GPT-6 reasoning efforts ("minimal" is gone: OpenAI says use "low"). */
export type Effort = "none" | "low" | "medium" | "high" | "xhigh" | "max";

export interface AIConfig {
  /** Short training answers. */
  chatModel: string;
  /** Food photos to items, grams and macros, as strict JSON. */
  mealModel: string;
  /** The goal photo: an edit of the member's own photo. */
  imageModel: string;
  imageQuality: ImageQuality;
  /** How much a GPT Image 2.5/2.6 edit plans; lower keeps an edit focused. */
  imageComplexity: "low" | "medium" | "high";
  /** Reasoning effort for reasoning models; ignored by others. "none" (or
   *  "off" in the console) turns reasoning off where the model allows it;
   *  null sends no effort, so the model's own default applies (medium on
   *  gpt-6.1-terra). */
  chatReasoning: Effort | null;
  mealReasoning: Effort | null;
  /** Allowances per plan; 0 switches a feature off for that plan. The
   *  app's paywall states the defaults (Purchases.Tier.ai): change both.
   *  Paid goal photos renew each calendar year in the member's time zone. */
  chatDailyLimitPremium: number;
  chatDailyLimitPro: number;
  mealDailyLimitPremium: number;
  mealDailyLimitPro: number;
  goalPhotoYearlyLimitPremium: number;
  goalPhotoYearlyLimitPro: number;
  /** Goal photos for a signed-in account without a paid plan, in all: they
   *  never renew and count on the account. 0 closes the goal photo to free
   *  accounts again (premium-required, as before 2026-11-23). */
  goalPhotoOnceLimitFree: number;
  /** Refuse calls without a valid App Check token. Turn on once the
   *  App Attest provider is registered and released builds send tokens. */
  enforceAppCheck: boolean;
  /** Switches a feature off server-side, e.g. while its model is retired. */
  chatEnabled: boolean;
  mealEnabled: boolean;
  goalPhotoEnabled: boolean;
  /** Meal scans ground kcal and macros in the food table (foodTable.ts):
   *  false sends neither the table nor its rules, and every food keeps the
   *  model's own estimate, as before the table. */
  mealTable: boolean;
}

// Models as of 2026-11-21 (developers.openai.com): gpt-6.1-terra is OpenAI's
// named replacement for gpt-5-mini (shut down 2026-12-11) and its pick for
// reading images; gpt-image-2.6-sunburst is its pick for accurate edits, and
// kept the face best in the owner's test on their own photos (2026-11-23)
// with goalPrompt's keep-list, high quality and low complexity.
// gpt-6.1-terra costs $1/M input tokens, $0.05/M cached input and $5/M
// output; writing the cache costs $1.25/M (30m) or $2.50/M (12h). A meal
// scan's prompt starts with the food table, about 65k characters (~22k
// tokens: a live call cached 22,323) kept as a 12h cached prefix: one cache
// write ≈ $0.056 (on the first scan after the cache expires, and after any
// change to the table version, model or reasoning effort); a scan that
// hits the cache ≈ $0.003-0.005; one that misses it ≈ $0.021 more. After a
// deploy, check usage.input_tokens_details.cached_tokens in the "scanMeal
// usage" log: from the second scan on it should be about the prefix size.
// Under $0.004 a chat answer. A goal photo at high quality (the owner's
// test, a 1040x1536 edit): ~1,500 input image tokens ($8/M) and ~200 text
// ($5/M) in, ~1,380-1,630 image tokens ($30/M) out ≈ $0.055-0.062; it was
// ~$0.047 at medium.
export const DEFAULTS: AIConfig = {
  chatModel: "gpt-6.1-terra",
  mealModel: "gpt-6.1-terra",
  imageModel: "gpt-image-2.6-sunburst",
  imageQuality: "high",
  imageComplexity: "low",
  chatReasoning: "low",
  mealReasoning: "low",
  // Owner, 2026-11-22: Premium has no meal scans. 2026-11-23: goal photos
  // 2 a year on Premium and 5 a year on Pro, and one ever for a free
  // account, so the AI costs stay inside each price.
  chatDailyLimitPremium: 10,
  chatDailyLimitPro: 30,
  mealDailyLimitPremium: 0,
  mealDailyLimitPro: 20,
  goalPhotoYearlyLimitPremium: 2,
  goalPhotoYearlyLimitPro: 5,
  goalPhotoOnceLimitFree: 1,
  enforceAppCheck: false,
  chatEnabled: true,
  mealEnabled: true,
  goalPhotoEnabled: true,
  mealTable: true,
};

const QUALITIES = ["low", "medium", "high"] as const;
const EFFORTS: readonly Effort[] = ["none", "low", "medium", "high", "xhigh", "max"];

/** One field of `config/ai` as the type its default has, or undefined when
 *  it can't be read as one. The Firebase console saves new fields as
 *  strings by default, so "true", "false" and "20" count too. */
function coerce(key: keyof AIConfig, raw: unknown): unknown {
  const fallback = DEFAULTS[key];
  const text = typeof raw === "string" ? raw.trim() : undefined;
  if (key === "chatReasoning" || key === "mealReasoning") {
    const word = text?.toLowerCase();
    if (raw === null || word === "null" || word === "default") return null;
    const effort = word === "off" ? "none" : word;
    return EFFORTS.includes(effort as Effort) ? effort : undefined;
  }
  if (key === "imageQuality" || key === "imageComplexity") {
    return QUALITIES.includes(text as (typeof QUALITIES)[number]) ? text : undefined;
  }
  switch (typeof fallback) {
    case "boolean":
      if (typeof raw === "boolean") return raw;
      if (text?.toLowerCase() === "true") return true;
      if (text?.toLowerCase() === "false") return false;
      return undefined;
    case "number": {
      const n = typeof raw === "number" ? raw : text ? Number(text) : NaN;
      return Number.isFinite(n) && n >= 0 ? Math.floor(n) : undefined;
    }
    case "string":
      return text ? text : undefined;
    default:
      return undefined;
  }
}

/** The defaults with every readable field of `config/ai` applied. Fields
 *  that can't be read are logged and left at their defaults. */
export function parseConfig(data: Record<string, unknown>): { value: AIConfig; ignored: string[] } {
  const value: AIConfig = { ...DEFAULTS };
  const ignored: string[] = [];
  for (const [key, raw] of Object.entries(data)) {
    const parsed = key in DEFAULTS ? coerce(key as keyof AIConfig, raw) : undefined;
    if (parsed === undefined) ignored.push(key);
    else (value as unknown as Record<string, unknown>)[key] = parsed;
  }
  return { value, ignored };
}

let lastGood: { value: AIConfig; at: number } | undefined;
/** Cached per instance; read every time in the emulator, for testing. */
const cacheMs = () => (inEmulator() ? 0 : 5 * 60 * 1000);

/** The current config, cached for five minutes per instance. If Firestore
 *  can't be read, the last config read stays in force (and the next call
 *  asks again); with none yet, the call fails rather than run on the
 *  defaults, which could undo a switch-off. */
export async function aiConfig(): Promise<AIConfig> {
  if (lastGood && Date.now() - lastGood.at < cacheMs()) return lastGood.value;
  let data: Record<string, unknown>;
  try {
    data = (await getFirestore().doc("config/ai").get()).data() ?? {};
  } catch (error) {
    if (lastGood) {
      logger.warn("config/ai unreadable: keeping the last one read", { error: String(error) });
      return lastGood.value;
    }
    logger.error("config/ai unreadable", { error: String(error) });
    throw new HttpsError("unavailable", Reason.ai);
  }
  const { value, ignored } = parseConfig(data);
  if (ignored.length > 0) logger.warn("config/ai: fields ignored", { ignored });
  lastGood = { value, at: Date.now() };
  return value;
}

export interface Limits {
  /** Per day. */
  chat: number;
  /** Per day. */
  meal: number;
  goalPhoto: number;
  /** "year" on the paid plans; "once" for a free account, whose goal
   *  photo never renews. */
  goalPhotoPeriod: "year" | "once";
}

/** A plan's allowances. A free account never reaches chat or meal scans
 *  (access.ts refuses it), so those are 0. */
export function limitsFor(config: AIConfig, plan: Plan): Limits {
  switch (plan) {
    case "pro":
      return { chat: config.chatDailyLimitPro, meal: config.mealDailyLimitPro, goalPhoto: config.goalPhotoYearlyLimitPro, goalPhotoPeriod: "year" };
    case "premium":
      return { chat: config.chatDailyLimitPremium, meal: config.mealDailyLimitPremium, goalPhoto: config.goalPhotoYearlyLimitPremium, goalPhotoPeriod: "year" };
    case "free":
      return { chat: 0, meal: 0, goalPhoto: config.goalPhotoOnceLimitFree, goalPhotoPeriod: "once" };
  }
}

/** True inside the Firebase emulator. */
export const inEmulator = () => process.env.FUNCTIONS_EMULATOR === "true";

/** Canned AI answers instead of OpenAI calls: emulator only, for testing the
 *  app's screens without a key. */
export const mockOpenAI = () => inEmulator() && process.env.MOCK_OPENAI === "1";
