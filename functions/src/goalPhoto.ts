/**
 * goalPhoto: the member's own photo, edited to show them at the goal they
 * pick (more muscle, less body fat, or both) with the same face: same
 * person, fitter body. Adults only: with only a birth year known, the
 * member must turn at least 19 this year, which guarantees 18 (the app
 * uses the same rule). The member confirms the photo is of themselves;
 * their clothes stay as they are, and only underwear or swimwear becomes
 * modest athletic wear, never nudity. OpenAI's own safety checks refuse
 * anything else. The result goes back to the phone only; nothing is stored
 * here. Each edit costs about $0.06 (config.ts), so Premium makes 2 a year,
 * Pro 5 a year, and a member without a plan one ever per Apple ID
 * (access.ts requireGoalPhotoMember, which also reads `holdsPlan`).
 */
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { toFile } from "openai";
import { REGION, mockOpenAI } from "./config.js";
import { Reason, requireGoalPhotoMember } from "./access.js";
import { ONCE, giveBack, localYear, period, periodLabel, take } from "./quota.js";
import { image, imageSize, mimeType, number } from "./input.js";
import { OPENAI_API_KEY, callOptions, isSafetyRefusal, openai, safetyId } from "./openai.js";
import { failure, settle } from "./settle.js";

/** The levels the member picks from, and the body fat (percent, low to
 *  high) each fat level aims for, per sex. The app keeps its own copy of
 *  these for its time-to-goal estimate: keep the two the same. Unspecified
 *  sex gets no number in the prompt. */
export const GOAL_LEVELS = {
  muscle: ["same", "toned", "muscular", "strong"],
  fat: ["same", "fit", "athletic", "lean"],
  bodyFatPercent: {
    male: { fit: [15, 17], athletic: [12, 14], lean: [9, 11] },
    female: { fit: [22, 25], athletic: [19, 21], lean: [16, 18] },
  },
} as const;

export type Sex = "male" | "female" | "unspecified";
export type Muscle = (typeof GOAL_LEVELS.muscle)[number];
export type Fat = (typeof GOAL_LEVELS.fat)[number];
export interface Look { sex: Sex; muscle: Muscle; fat: Fat }

const WORDS: Record<Sex, { noun: string; his: string; him: string; holds: string }> = {
  male: { noun: "man", his: "his", him: "him", holds: "he holds" },
  female: { noun: "woman", his: "her", him: "her", holds: "she holds" },
  unspecified: { noun: "person", his: "their", him: "them", holds: "they hold" },
};

// Women's muscle never names the chest or breasts; unspecified leaves the
// chest out too.
const MUSCLE: Record<Sex, Record<Muscle, string>> = {
  male: {
    same: "about the same amount of muscle as now",
    toned: "a little more muscle: firmer, slightly rounder shoulders, arms, chest and legs",
    muscular: "noticeably more muscle: rounder, broader shoulders, a fuller upper chest, thicker upper arms, a wider upper back and more muscular legs",
    strong: "a lot more muscle, as after two to three years of serious training: broad, rounded shoulders, a full chest, thick arms, a wide back and strong, muscular legs",
  },
  female: {
    same: "about the same amount of muscle as now",
    toned: "a little more muscle tone: firmer arms, shoulders and legs and slightly rounder glutes",
    muscular: "noticeably more muscle: shapely, defined shoulders and arms, a stronger, more defined back, rounder, fuller glutes and more muscular legs",
    strong: "a lot more muscle, as after two to three years of serious training: well-defined shoulders and arms, a strong, athletic back, full, rounded glutes and powerful, muscular legs",
  },
  unspecified: {
    same: "about the same amount of muscle as now",
    toned: "a little more muscle: firmer, slightly rounder shoulders, arms, back and legs",
    muscular: "noticeably more muscle: rounder, broader shoulders, thicker upper arms, a wider upper back and more muscular legs",
    strong: "a lot more muscle, as after two to three years of serious training: broad, rounded shoulders, thick arms, a wide back and strong, muscular legs",
  },
};

/** How each fat level looks; the percentages come from GOAL_LEVELS. */
const FAT_SHAPE: Record<Sex, Record<Exclude<Fat, "same">, string>> = {
  male: {
    fit: "a flat stomach and a slightly trimmer waist",
    athletic: "a flat, firm stomach with the upper abs faintly outlined and a narrower waist",
    lean: "a clearly outlined six-pack and obliques and a narrow waist",
  },
  female: {
    fit: "a flatter stomach and a trimmer waist",
    athletic: "a flat, firm stomach with a faint line down the abs and a narrower waist",
    lean: "visible ab lines, a narrow waist and clearly toned arms and legs",
  },
  unspecified: {
    fit: "a flatter stomach and trimmer waist",
    athletic: "a flat, firm stomach and a narrower waist",
    lean: "visible ab definition and a narrow waist",
  },
};

/** Only for a photo in underwear or swimwear; other clothes stay. */
const CLOTHES: Record<Sex, string> = {
  male: "a fitted athletic t-shirt and athletic shorts",
  female: "a supportive sports top that fully covers the chest, and leggings or athletic shorts",
  unspecified: "a fitted athletic t-shirt and athletic shorts or leggings",
};

function fatText(sex: Sex, fat: Fat): string {
  if (fat === "same") return "about the same body fat as now";
  if (sex === "unspecified") return FAT_SHAPE.unspecified[fat];
  const [low, high] = GOAL_LEVELS.bodyFatPercent[sex][fat];
  return `about ${low}-${high}% body fat: ${FAT_SHAPE[sex][fat]}`;
}

/** The edit's prompt. The keep-list is what kept the face in the owner's
 *  test (2026-11-23): name every part of the head, and never let the body
 *  change reach the face. */
export function goalPrompt(look: Look): string {
  const w = WORDS[look.sex];
  return [
    `Edit this photo of a ${w.noun} to show the same ${w.noun} at their fitness goal, reached with consistent strength training and good nutrition.`,
    "",
    `Change only ${w.his} body below the neck:`,
    `- ${MUSCLE[look.sex][look.muscle]}`,
    `- ${fatText(look.sex, look.fat)}`,
    "- natural and achievable without drugs: athletic and healthy, not a bodybuilder or a fitness model, no extreme veins, no painted-on shadows.",
    "",
    "Keep exactly as in the photo:",
    `- ${w.his} whole head: face, facial features and their proportions, eyes, eyebrows, nose, mouth, teeth, cheeks, jawline, chin, ears, facial skin and its texture, facial hair, makeup, moles and scars, expression, hairstyle and hairline, and any cap, hat or glasses; the size, position and angle of the head;`,
    "- the neck and the collar area;",
    `- ${w.his} clothes: the same garments, colours and fabric, which simply fit closer to the new body. Only if the photo shows underwear or swimwear, dress ${w.him} in modest athletic wear instead: ${CLOTHES[look.sex]};`,
    `- ${w.his} hands and anything ${w.holds} (such as a phone), the pose, camera angle, framing, background (including any signs or writing in it), lighting, colours and image quality.`,
    "Do not retouch, smooth, slim or beautify the face.",
    "",
    "A real photograph with natural skin texture on the body. No nudity, nothing sexual or suggestive. Do not add any new text, logos or watermarks.",
  ].join("\n");
}

function readSex(value: unknown): Sex {
  return value === "male" || value === "female" ? value : "unspecified";
}

/** One level the member picked: missing is "same"; a value the server
 *  doesn't know is refused rather than guessed. */
function readLevel<T extends string>(value: unknown, levels: readonly T[], name: string): T {
  if (value === undefined || value === null) return levels[0];
  if (typeof value === "string" && (levels as readonly string[]).includes(value)) return value as T;
  throw new HttpsError("invalid-argument", `${name} must be one of: ${levels.join(", ")}`);
}

/** The look for an app from before the picker, which sent only its plan's
 *  goal (kept for one release). getFit, and anything unknown, never asks
 *  for less fat: the app sends it for a member who shouldn't lose weight. */
export function legacyLook(goal: unknown): { muscle: Muscle; fat: Fat } {
  switch (goal) {
    case "loseWeight": return { muscle: "toned", fat: "fit" };
    case "buildMuscle": return { muscle: "muscular", fat: "same" };
    case "recomp": return { muscle: "toned", fat: "athletic" };
    default: return { muscle: "toned", fat: "same" };
  }
}

/** The look the request asks for: `sex`, `muscle` and `fat`, or an older
 *  app's `goal` when it sends neither level. A look that changes nothing
 *  is refused before any allowance is taken. */
export function readLook(data: Record<string, unknown>): Look {
  const sex = readSex(data.sex);
  const legacy = data.muscle == null && data.fat == null && data.goal != null;
  const { muscle, fat } = legacy
    ? legacyLook(data.goal)
    : { muscle: readLevel(data.muscle, GOAL_LEVELS.muscle, "muscle"), fat: readLevel(data.fat, GOAL_LEVELS.fat, "fat") };
  if (muscle === "same" && fat === "same") {
    throw new HttpsError("invalid-argument", "nothing to change: muscle and fat are both \"same\"");
  }
  return { sex, muscle, fat };
}

/** The edit's `size`: the photo's own, so the result lines up pixel for
 *  pixel with it and the app can paste the original face back. "auto"
 *  re-frames the photo (the owner's 1040x1536 came back 1032x1524), so it's
 *  only the fallback for a size OpenAI won't take: both sides multiples of
 *  16, an aspect ratio from 1:3 to 3:1, 655,360 to 8,294,400 pixels, and no
 *  side over 3840 (OpenAI's largest, 3840x2160). */
export function editSize(width: number, height: number): string {
  const fits = Number.isInteger(width) && Number.isInteger(height) && width > 0 && height > 0
    && width % 16 === 0 && height % 16 === 0
    && Math.max(width, height) <= 3 * Math.min(width, height)
    && width * height >= 655_360 && width * height <= 8_294_400
    && Math.max(width, height) <= 3840;
  return fits ? `${width}x${height}` : "auto";
}

/** Certainly 18 or older, knowing only the birth year: someone who turns
 *  18 this year may still be 17, so they must turn at least 19. */
export function isAdult(birthYear: number | undefined, year: number): boolean {
  return birthYear !== undefined && year - birthYear >= 19;
}

export const goalPhoto = onCall(
  { region: REGION, secrets: [OPENAI_API_KEY], timeoutSeconds: 240, memory: "1GiB", maxInstances: 10, concurrency: 8 },
  async (request, response) => {
    const member = await requireGoalPhotoMember(request);
    const data = (request.data ?? {}) as Record<string, unknown>;
    if (data.confirmsOwnPhoto !== true) {
      throw new HttpsError("failed-precondition", Reason.notAllowed);
    }
    const birthYear = number(data.birthYear, 1900, 2100);
    if (!isAdult(birthYear, localYear(data.timeZone))) throw new HttpsError("failed-precondition", Reason.age);
    const photo = image(data.image, 8 * 1024 * 1024);
    const prompt = goalPrompt(readLook(data));
    const pixels = imageSize(photo);
    const size = pixels ? editSize(pixels.width, pixels.height) : "auto";
    // Paid plans renew each year in the member's time zone; a free
    // account's one goal photo never does.
    const periodKey = member.limits.goalPhotoPeriod === "once" ? ONCE : period("year", data.timeZone);
    const remaining = await take(member.usageKey, "goalPhoto", periodKey, member.limits.goalPhoto, member.tier);
    // `remainingThisMonth` repeats `remaining` for app builds from before
    // the yearly allowance (one release).
    const left = { remaining, period: periodLabel(periodKey), tier: member.tier, remainingThisMonth: remaining };

    let editing = false;
    let answered = false;
    try {
      if (mockOpenAI()) return { image: photo.toString("base64"), ...left };
      // OpenAI's free moderation model screens the photo first: nothing
      // sexual, violent or about self-harm goes on to be edited.
      const screen = await openai().moderations.create({
        model: "omni-moderation-latest",
        input: [{ type: "image_url", image_url: { url: `data:${mimeType(photo)};base64,${photo.toString("base64")}` } }],
      }, callOptions(15_000, response?.signal));
      if (screen.results.some((r) => r.flagged)) {
        throw new HttpsError("failed-precondition", Reason.notAllowed);
      }
      const model = member.config.imageModel;
      editing = true;
      // 200 s with no retry, so moderation and the edit end inside the
      // function's 240 s and a slow edit is never made (and billed) twice.
      const result = await openai().images.edit({
        model,
        image: await toFile(photo, mimeType(photo) === "image/png" ? "photo.png" : "photo.jpg", { type: mimeType(photo) }),
        prompt,
        size,
        quality: member.config.imageQuality,
        output_format: "jpeg",
        output_compression: 88,
        n: 1,
        safety_identifier: safetyId(member.uid),
        // Face matching is a parameter only on gpt-image-1.5; the newer
        // models keep it by default and reject the parameter. On 2.5 and
        // 2.6, less planning keeps an edit focused (OpenAI's guidance).
        ...(model.startsWith("gpt-image-1.5") ? { input_fidelity: "high" as const } : {}),
        ...(/^gpt-image-2\.[56]/.test(model) ? { complexity: member.config.imageComplexity } : {}),
      }, callOptions(200_000, response?.signal));
      answered = true;
      logger.info("goalPhoto usage", { uid: member.uid, tier: member.tier, model, size, usage: result.usage });
      const b64 = result.data?.[0]?.b64_json;
      if (!b64) throw new Error("no image returned");
      return { image: b64, ...left };
    } catch (error) {
      // Before the edit only the free moderation screen ran.
      const gaveBack = editing
        ? await settle(member, "goalPhoto", periodKey, error, answered)
        : await giveBack(member.usageKey, "goalPhoto", periodKey);
      const remainingNow = remaining + (gaveBack ? 1 : 0);
      if (isSafetyRefusal(error)) throw failure(new HttpsError("failed-precondition", Reason.notAllowed), remainingNow);
      if (!(error instanceof HttpsError)) logger.error("goalPhoto failed", { uid: member.uid, error: String(error) });
      throw failure(error, remainingNow);
    }
  },
);
