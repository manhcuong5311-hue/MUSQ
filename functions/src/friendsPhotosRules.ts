/**
 * MUSQ Friends photo check-ins: the pure rules (no Firestore) for what the
 * app sends: the photo, its caption and tag, comments and report reasons,
 * plus the limits. See friendsPhotos.ts for the layout and the callables.
 */
import { randomBytes } from "node:crypto";
import { HttpsError } from "firebase-functions/v2/https";
import { image, imageSize } from "./input.js";
import { isObjectionable } from "./friendsRules.js";
import { Reason } from "./reasons.js";

export const POST_TTL_DAYS = 30;
export const CAPTION_MAX = 120;
export const TAG_MAX = 60;
export const COMMENT_MAX = 300;
export const PHOTOS_PER_DAY = 10;
export const COMMENTS_PER_DAY = 100;
/** Reaction changes a day (each one rewrites every reader's copy, so it's
 *  capped like posts and comments; far above what tapping ever needs). */
export const REACTIONS_PER_DAY = 300;
/** The poster and up to 50 friends (friends.ts MAX_FRIENDS). */
export const MAX_RECIPIENTS = 51;
/** A post reported by this many different friends is hidden for review. */
export const HIDE_AFTER_REPORTS = 2;
/** The app sends ≤ 1080 px at JPEG 0.75 (a few hundred KB); this leaves room. */
export const MAX_PHOTO_BYTES = 1_500_000;
const MAX_SIDE = 4096;
const MIN_SIDE = 64;

/** A new post or comment id: 128 random bits as 32 hex (friendsRules readId). */
export function newId(): string {
  return randomBytes(16).toString("hex");
}

/** The object of a post's photo in Cloud Storage. */
export function photoPath(postId: string): string {
  return `friendPhotos/${postId}.jpg`;
}

// MARK: - Photo

/**
 * A JPEG with every metadata segment taken out: EXIF/GPS and XMP (APP1),
 * MPF (APP2 that isn't an ICC profile), IPTC (APP13), other APPn and
 * comments, and anything after the end of the image (iPhone gain maps and
 * other appended pictures). Kept: JFIF (APP0), the ICC colour profile
 * (APP2 "ICC_PROFILE") and Adobe (APP14, needed to read the colours right),
 * and the image itself. The app already re-encodes from pixels; this is the
 * server's own guarantee. Undefined when the JPEG can't be parsed.
 */
export function stripJpegMetadata(buffer: Buffer): Buffer | undefined {
  if (buffer.length < 4 || buffer[0] !== 0xff || buffer[1] !== 0xd8) return undefined;
  const out: Buffer[] = [buffer.subarray(0, 2)];
  let i = 2;
  while (i < buffer.length) {
    if (buffer[i] !== 0xff) return undefined;
    let j = i;
    while (buffer[j] === 0xff) j++;
    const marker = buffer[j];
    if (marker === undefined) return undefined;
    const start = j - 1;
    j++;
    if (marker === 0xd9) { out.push(Buffer.from([0xff, 0xd9])); return Buffer.concat(out); }
    if (marker === 0x01 || (marker >= 0xd0 && marker <= 0xd7)) { out.push(buffer.subarray(start, j)); i = j; continue; }
    if (j + 2 > buffer.length) return undefined;
    const length = buffer.readUInt16BE(j);
    if (length < 2 || j + length > buffer.length) return undefined;
    const end = j + length;
    if (marker === 0xda) {
      // Start of scan: the entropy-coded data runs to the first marker that
      // isn't a stuffed 0xFF00 or a restart marker; the scan ends at EOI.
      let k = end;
      while (k + 1 < buffer.length) {
        if (buffer[k] === 0xff) {
          const next = buffer[k + 1];
          if (next === 0x00 || (next >= 0xd0 && next <= 0xd7) || next === 0xff) { k += next === 0xff ? 1 : 2; continue; }
          break;
        }
        k++;
      }
      out.push(buffer.subarray(start, k));
      i = k;
      continue;
    }
    const isApp = marker >= 0xe0 && marker <= 0xef;
    const keep = !isApp && marker !== 0xfe
      ? true
      : marker === 0xe0 || marker === 0xee
        || (marker === 0xe2 && buffer.toString("latin1", j + 2, j + 14) === "ICC_PROFILE\u0000");
    if (keep) out.push(buffer.subarray(start, end));
    i = end;
  }
  return undefined;
}

export interface Photo { jpeg: Buffer; width: number; height: number }

/** The posted photo: base64 JPEG ≤ 1.5 MB, a sane size, metadata stripped. */
export function readPhoto(value: unknown): Photo {
  const raw = image(value, MAX_PHOTO_BYTES);
  if (raw[0] !== 0xff) throw new HttpsError("invalid-argument", "image must be JPEG");
  const jpeg = stripJpegMetadata(raw);
  const size = jpeg ? imageSize(jpeg) : undefined;
  if (!jpeg || !size) throw new HttpsError("invalid-argument", "image invalid");
  const { width, height } = size;
  if (Math.max(width, height) > MAX_SIDE || Math.min(width, height) < MIN_SIDE) throw new HttpsError("invalid-argument", "image size invalid");
  return { jpeg, width, height };
}

// MARK: - Text

/** Control and invisible characters (zero-width, bidi overrides, word
 *  joiners, BOM). The zero-width joiner U+200D is handled apart: kept inside
 *  emoji (🏋️‍♂️, ❤️‍🔥, 👩‍👩‍👧), dropped anywhere else (it could split a banned
 *  word). */
const INVISIBLE = /[\u0000-\u0009\u000B-\u001F\u007F-\u009F\u200B\u200C\u200E\u200F\u202A-\u202E\u2060-\u206F\uFEFF]/g;
const STRAY_JOINER = /(?<!\p{Extended_Pictographic}[\uFE0F\u{1F3FB}-\u{1F3FF}]?)\u200D|\u200D(?!\p{Extended_Pictographic})/gu;

const segmenter = new Intl.Segmenter("en", { granularity: "grapheme" });

/** The characters as a person (and the app's Swift String.count) counts
 *  them: grapheme clusters, so 💪🏽 or 🇻🇳 is one. */
export function graphemes(text: string): string[] {
  return Array.from(segmenter.segment(text), (s) => s.segment);
}

/** Text with control and invisible characters taken out (see INVISIBLE). */
export function stripInvisible(text: string): string {
  return text.replace(INVISIBLE, "").replace(STRAY_JOINER, "");
}

/** Trimmed text with control and invisible characters taken out, spaces
 *  collapsed and at most one blank line in a row (newlines kept only when
 *  `lines`). Undefined when empty; refused when longer than `max`
 *  characters (grapheme clusters, as the app counts) or holding a link,
 *  contact details or a banned word. */
function readText(value: unknown, max: number, lines: boolean, field: string): string | undefined {
  if (value === undefined || value === null) return undefined;
  if (typeof value !== "string" || value.length > max * 16) throw new HttpsError("invalid-argument", `${field} invalid`);
  let t = stripInvisible(value.normalize("NFC").replace(/\r\n?/g, "\n"));
  t = lines
    ? t.split("\n").map((l) => l.replace(/\s+/g, " ").trim()).join("\n").replace(/\n{3,}/g, "\n\n").trim()
    : t.replace(/\s+/g, " ").trim();
  if (!t) return undefined;
  if (graphemes(t).length > max) throw new HttpsError("invalid-argument", `${field} too long`);
  if (isObjectionable(t)) throw new HttpsError("failed-precondition", Reason.friendTextRejected);
  return t;
}

export function readCaption(value: unknown): string | null {
  return readText(value, CAPTION_MAX, true, "caption") ?? null;
}

/** The workout tag ("Chest day · 25 min"); one that isn't allowed is
 *  dropped rather than failing the post. */
export function readTag(value: unknown): string | null {
  if (typeof value !== "string") return null;
  try {
    const t = readText(graphemes(value.slice(0, TAG_MAX * 16)).slice(0, TAG_MAX * 2).join(""), TAG_MAX * 2, false, "tag");
    return t ? graphemes(t).slice(0, TAG_MAX).join("") : null;
  } catch {
    return null;
  }
}

export function readComment(value: unknown): string {
  const t = readText(value, COMMENT_MAX, true, "text");
  if (!t) throw new HttpsError("invalid-argument", "text missing");
  return t;
}

// MARK: - Reports

export const PHOTO_REPORT_REASONS = ["spam", "inappropriate", "abusive", "other"] as const;
export type PhotoReportReason = (typeof PHOTO_REPORT_REASONS)[number];

export function readPhotoReportReason(value: unknown): PhotoReportReason {
  const reason = PHOTO_REPORT_REASONS.find((r) => r === value);
  if (!reason) throw new HttpsError("invalid-argument", "reason invalid");
  return reason;
}

// MARK: - Daily limits

export type CounterKind = "posts" | "comments" | "reactions";
export const COUNTER_KINDS: readonly CounterKind[] = ["posts", "comments", "reactions"];
export const DAILY_LIMIT: Record<CounterKind, number> = {
  posts: PHOTOS_PER_DAY, comments: COMMENTS_PER_DAY, reactions: REACTIONS_PER_DAY,
};

/** How many of `kind` the counter doc (one per member, reset each UTC day)
 *  holds for `today`. */
export function counted(counter: Record<string, unknown> | undefined, kind: CounterKind, today: string): number {
  if (!counter || counter.day !== today) return 0;
  const n = counter[kind];
  return typeof n === "number" && n > 0 ? n : 0;
}

/** The counter doc with one more of `kind` for `today` (the other kinds
 *  kept for today, or reset on a new day). */
export function counterAfter(counter: Record<string, unknown> | undefined, kind: CounterKind, today: string): Record<string, unknown> {
  const next: Record<string, unknown> = { day: today };
  for (const k of COUNTER_KINDS) next[k] = counted(counter, k, today) + (k === kind ? 1 : 0);
  return next;
}
