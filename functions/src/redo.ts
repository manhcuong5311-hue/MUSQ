/**
 * Goal photo redos (owner, 2026-11-27: "Cả 2"): a member who doesn't like a
 * goal photo may make it again, with the same photo and the same look, up
 * to REDOS_PER_PHOTO more times without using another goal photo of their
 * allowance, on every plan (the free one included). Each generation that
 * used the allowance gets one redo budget, kept in
 * `usage/{usageKey}/goalPhoto/redo` (one per member: a new goal photo
 * replaces it), with a hash of what was sent so a redo can't edit another
 * photo or ask for another look. The doc deletes itself a week on
 * (Firestore TTL on the goalPhoto group's `expireAt`). A redo still goes
 * through the moderation screen and OpenAI's own checks, and a failed one
 * gives its try back like a failed goal photo gives back its unit
 * (settle.ts): always when OpenAI billed nothing, once per goal photo when
 * it may have. Each redo costs about $0.04-0.06 (config.ts).
 */
import { createHash, randomUUID } from "node:crypto";
import { FieldValue, Timestamp, getFirestore } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import { Reason } from "./reasons.js";

/** Free redos of each goal photo. The app says the same (GoalPhoto.swift
 *  `GoalPhotoRedo.perPhoto`): change both. */
export const REDOS_PER_PHOTO = 2;
/** How long a goal photo's redos stay open. */
export const REDO_DAYS = 7;
const DAY_MS = 24 * 60 * 60 * 1000;

export interface Redo {
  id: string;
  left: number;
}

/** What a redo must match: the photo's bytes and the look asked for. */
export function redoInput(photo: Buffer, look: { sex: string; muscle: string; fat: string }): string {
  return createHash("sha256").update(photo).update(`|${look.sex}|${look.muscle}|${look.fat}`).digest("hex");
}

/** The `redoOf` the request names, if it's a redo: an id this server gave
 *  out (a UUID). Anything else is a normal goal photo. */
export function readRedoOf(value: unknown): string | undefined {
  return typeof value === "string" && /^[0-9a-f-]{36}$/i.test(value) ? value.toLowerCase() : undefined;
}

/** Whether a stored budget lets this request redo: same id, same input,
 *  tries left and not expired. */
export function canRedo(stored: Record<string, unknown> | undefined, id: string, input: string, now: number): boolean {
  if (!stored || stored.id !== id || stored.input !== input) return false;
  const left = Number(stored.left ?? 0);
  const until = (stored.expireAt as { toMillis?: () => number } | undefined)?.toMillis?.();
  return Number.isFinite(left) && left > 0 && (until === undefined || until > now);
}

function redoDoc(usageKey: string) {
  return getFirestore().doc(`usage/${usageKey}/goalPhoto/redo`);
}

/** Opens a fresh budget for a goal photo that used the allowance. Best
 *  effort: undefined when it couldn't be saved (the photo still goes back,
 *  just without a free redo). */
export async function openRedo(usageKey: string, input: string): Promise<Redo | undefined> {
  const id = randomUUID();
  try {
    await redoDoc(usageKey).set({
      id,
      left: REDOS_PER_PHOTO,
      input,
      refunded: false,
      updatedAt: FieldValue.serverTimestamp(),
      expireAt: Timestamp.fromMillis(Date.now() + REDO_DAYS * DAY_MS),
    });
    return { id, left: REDOS_PER_PHOTO };
  } catch {
    return undefined;
  }
}

/** Takes one try of the budget `id`, or throws failed-precondition
 *  (Reason.redo, `redoLeft: 0`) when it can't be redone: then nothing was
 *  counted, and the app offers a normal goal photo. Returns the tries left. */
export async function takeRedo(usageKey: string, id: string, input: string): Promise<number> {
  const ref = redoDoc(usageKey);
  return getFirestore().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!canRedo(snap.data(), id, input, Date.now())) {
      throw new HttpsError("failed-precondition", Reason.redo, { redoLeft: 0 });
    }
    const left = Number(snap.get("left")) - 1;
    tx.set(ref, { left, updatedAt: FieldValue.serverTimestamp() }, { merge: true });
    return left;
  });
}

/** Gives a failed redo's try back: always when OpenAI billed nothing
 *  (`billed` false), once per goal photo when it may have. Best effort;
 *  returns whether it did. */
export async function giveBackRedo(usageKey: string, id: string, billed: boolean): Promise<boolean> {
  const ref = redoDoc(usageKey);
  try {
    return await getFirestore().runTransaction(async (tx) => {
      const snap = await tx.get(ref);
      if (!snap.exists || snap.get("id") !== id) return false;
      if (billed && snap.get("refunded") === true) return false;
      const left = Number(snap.get("left") ?? 0);
      if (left >= REDOS_PER_PHOTO) return false;
      tx.set(ref, { left: left + 1, ...(billed ? { refunded: true } : {}), updatedAt: FieldValue.serverTimestamp() }, { merge: true });
      return true;
    });
  } catch {
    return false;
  }
}
