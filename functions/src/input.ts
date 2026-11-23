/**
 * Checks and trims what the app sends, so a request can never carry more
 * than the prompts expect (or anything the server didn't ask for).
 */
import { HttpsError } from "firebase-functions/v2/https";

export type Locale = "en" | "vi";

export function locale(value: unknown): Locale {
  return value === "vi" ? "vi" : "en";
}

export function text(value: unknown, max: number): string | undefined {
  if (typeof value !== "string") return undefined;
  const trimmed = value.trim();
  return trimmed ? trimmed.slice(0, max) : undefined;
}

export function number(value: unknown, min: number, max: number): number | undefined {
  return typeof value === "number" && Number.isFinite(value) && value >= min && value <= max ? value : undefined;
}

function strings(value: unknown, maxItems: number, maxLength: number): string[] {
  return Array.isArray(value)
    ? value.filter((v): v is string => typeof v === "string").slice(0, maxItems).map((v) => v.slice(0, maxLength))
    : [];
}

/** A base64 JPEG (or PNG/HEIC turned JPEG by the app) up to `maxBytes`. */
export function image(value: unknown, maxBytes: number): Buffer {
  if (typeof value !== "string" || value.length < 100) throw new HttpsError("invalid-argument", "image missing");
  const base64 = value.replace(/^data:image\/\w+;base64,/, "");
  if (base64.length > Math.ceil(maxBytes / 3) * 4 + 4) throw new HttpsError("invalid-argument", "image too large");
  const buffer = Buffer.from(base64, "base64");
  const isJPEG = buffer[0] === 0xff && buffer[1] === 0xd8;
  const isPNG = buffer[0] === 0x89 && buffer[1] === 0x50;
  if (!isJPEG && !isPNG) throw new HttpsError("invalid-argument", "image must be JPEG or PNG");
  return buffer;
}

export function mimeType(buffer: Buffer): "image/jpeg" | "image/png" {
  return buffer[0] === 0x89 ? "image/png" : "image/jpeg";
}

const PNG_SIGNATURE = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);

/** A JPEG's or PNG's width and height in pixels, read from its header (the
 *  JPEG's start-of-frame segment, the PNG's IHDR), so the goal photo can
 *  ask for an edit of exactly its own size. Undefined for anything else. */
export function imageSize(buffer: Buffer): { width: number; height: number } | undefined {
  const size = (width: number, height: number) => (width > 0 && height > 0 ? { width, height } : undefined);
  if (buffer.length >= 24 && buffer.subarray(0, 8).equals(PNG_SIGNATURE)) {
    if (buffer.toString("latin1", 12, 16) !== "IHDR") return undefined;
    return size(buffer.readUInt32BE(16), buffer.readUInt32BE(20));
  }
  if (buffer.length < 4 || buffer[0] !== 0xff || buffer[1] !== 0xd8) return undefined;
  let i = 2;
  while (i < buffer.length) {
    if (buffer[i] !== 0xff) return undefined;
    while (buffer[i] === 0xff) i++; // fill bytes before the marker code
    const marker = buffer[i++];
    if (marker === undefined) return undefined;
    // Standalone markers, with no length: TEM, RST0-7, SOI.
    if (marker === 0x01 || (marker >= 0xd0 && marker <= 0xd8)) continue;
    // End of image, or the scan data: no frame header came first.
    if (marker === 0xd9 || marker === 0xda) return undefined;
    if (i + 2 > buffer.length) return undefined;
    const length = buffer.readUInt16BE(i);
    if (length < 2) return undefined;
    // SOF0-SOF15, except DHT (C4), JPG (C8) and DAC (CC): length, precision,
    // then height and width.
    if (marker >= 0xc0 && marker <= 0xcf && marker !== 0xc4 && marker !== 0xc8 && marker !== 0xcc) {
      if (i + 7 > buffer.length) return undefined;
      return size(buffer.readUInt16BE(i + 5), buffer.readUInt16BE(i + 3));
    }
    i += length;
  }
  return undefined;
}

// MARK: - Chat

export interface ChatMessage { role: "user" | "assistant"; content: string }

export function chatMessages(value: unknown): ChatMessage[] {
  if (!Array.isArray(value)) throw new HttpsError("invalid-argument", "messages missing");
  const messages = value
    .map((m): ChatMessage | undefined => {
      const role = (m as { role?: unknown })?.role;
      const content = text((m as { content?: unknown })?.content, 2000);
      return (role === "user" || role === "assistant") && content ? { role, content } : undefined;
    })
    .filter((m): m is ChatMessage => !!m)
    .slice(-20);
  if (messages.length === 0 || messages[messages.length - 1].role !== "user") {
    throw new HttpsError("invalid-argument", "the last message must be the member's question");
  }
  return messages;
}

/** The agreed AIChatContext, keeping only known fields within sane bounds. */
export function chatContext(value: unknown): Record<string, unknown> | undefined {
  if (!value || typeof value !== "object") return undefined;
  const c = value as Record<string, unknown>;
  const plan = c.plan as Record<string, unknown> | undefined;
  const health = c.health as Record<string, unknown> | undefined;
  // The 14 newest (dates are yyyy-MM-dd, so text order is date order),
  // newest first, so the 40-exercise budget goes to the latest sessions.
  const dateOf = (w: unknown) => String((w as { date?: unknown } | null)?.date ?? "");
  const workouts = Array.isArray(c.recentWorkouts)
    ? [...c.recentWorkouts].sort((a, b) => dateOf(b).localeCompare(dateOf(a))).slice(0, 14)
    : [];
  // 40 exercises in all, newest sessions first, and whole sessions only, so
  // none reads as a shorter workout than it was; a session that no longer
  // fits keeps its date and groups. Only the newest may be cut, if it alone
  // has more than 40.
  let exercisesLeft = 40;
  const recentWorkouts = workouts.map((w, index) => {
    const workout = w as Record<string, unknown>;
    const all = Array.isArray(workout.exercises) ? workout.exercises : [];
    const exercises = all.length <= exercisesLeft ? all : index === 0 ? all.slice(0, exercisesLeft) : [];
    exercisesLeft -= exercises.length;
    return {
      date: text(workout.date, 10),
      groups: strings(workout.groups, 12, 40),
      exercises: exercises.map((e) => {
        const ex = e as Record<string, unknown>;
        return {
          name: text(ex.name, 80),
          sets: number(ex.sets, 0, 50),
          reps: number(ex.reps, 0, 500),
          weightKg: number(ex.weightKg, 0, 1000),
          seconds: number(ex.seconds, 0, 3600),
        };
      }),
    };
  });
  return {
    goal: text(c.goal, 40),
    sex: text(c.sex, 20),
    experience: text(c.experience, 40),
    split: text(c.split, 60),
    age: number(c.age, 10, 110),
    daysPerWeek: number(c.daysPerWeek, 0, 7),
    heightCm: number(c.heightCm, 80, 260),
    weightKg: number(c.weightKg, 25, 400),
    plan: plan ? {
      kcal: number(plan.kcal, 500, 10000),
      proteinG: number(plan.proteinG, 0, 600),
      fatG: number(plan.fatG, 0, 600),
      carbsG: number(plan.carbsG, 0, 1500),
    } : undefined,
    recentWorkouts,
    health: health ? { joints: strings(health.joints, 10, 40), conditions: strings(health.conditions, 12, 40) } : undefined,
  };
}
