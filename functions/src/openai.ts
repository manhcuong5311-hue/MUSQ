/**
 * The OpenAI client. The key lives only in Secret Manager
 * (`firebase functions:secrets:set OPENAI_API_KEY`), bound to the functions
 * that need it; the app never sees it. Responses are created with
 * `store: false`, and each call carries a hashed member id
 * (`safety_identifier`) so OpenAI can spot abuse without knowing who it is.
 */
import { createHash } from "node:crypto";
import OpenAI from "openai";
import { defineSecret } from "firebase-functions/params";

export const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

let client: OpenAI | undefined;
/** No retries: each call passes a timeout that ends it inside its
 *  function's own time limit (see `callOptions`), so a failure always
 *  reaches the code that settles the member's unit, and a slow call is never
 *  sent (and billed) twice. */
export function openai(): OpenAI {
  client ??= new OpenAI({ apiKey: OPENAI_API_KEY.value(), timeout: 60_000, maxRetries: 0 });
  return client;
}

/** Per-call options: a timeout under the function's limit, no retries, and
 *  the callable's abort signal, so a member who leaves stops the call. */
export function callOptions(timeoutMs: number, signal: AbortSignal | undefined) {
  return { timeout: timeoutMs, maxRetries: 0, ...(signal ? { signal } : {}) };
}

/** OpenAI's free moderation model (omni-moderation-latest) over texts and
 *  an optional JPEG, in one request: true when anything is flagged. Throws
 *  when OpenAI can't be reached (callers refuse then: nothing unscreened is
 *  shown to anyone). */
export async function moderationFlagged(texts: string[], jpeg?: Buffer, signal?: AbortSignal): Promise<boolean> {
  const input = [
    ...texts.filter((t) => t.trim()).map((text) => ({ type: "text" as const, text })),
    ...(jpeg ? [{ type: "image_url" as const, image_url: { url: `data:image/jpeg;base64,${jpeg.toString("base64")}` } }] : []),
  ];
  if (input.length === 0) return false;
  const screen = await openai().moderations.create({ model: "omni-moderation-latest", input }, callOptions(15_000, signal));
  return screen.results.some((r) => r.flagged);
}

/** A stable, anonymous id for a member, for OpenAI's abuse monitoring. */
export function safetyId(uid: string): string {
  return createHash("sha256").update(`musq:${uid}`).digest("hex").slice(0, 32);
}

/** True for OpenAI's reasoning models, which take `reasoning.effort`. */
export function isReasoningModel(model: string): boolean {
  return /^(gpt-5|gpt-6|o\d)/.test(model) && !model.includes("chat-latest");
}

/** True for models that take explicit prompt-cache breakpoints and
 *  `prompt_cache_options` (gpt-5.6 and later, per the API reference), so
 *  an older model set in config/ai gets a request it accepts. */
export function supportsCacheBreakpoints(model: string): boolean {
  const version = /^gpt-(\d+)(?:\.(\d+))?/.exec(model);
  if (!version) return false;
  const major = Number(version[1]);
  return major > 5 || (major === 5 && Number(version[2] ?? 0) >= 6);
}

/** Whether an OpenAI error means the request itself was refused by its
 *  safety system (an image it won't edit, say), not that something broke.
 *  `moderation_blocked` is the documented code; the rest is a fallback. */
export function isSafetyRefusal(error: unknown): boolean {
  const e = error as { status?: number; code?: string | null; error?: { code?: string }; message?: string };
  const code = e.code ?? e.error?.code ?? "";
  if (code === "moderation_blocked") return true;
  return e.status === 400 && /moderation|safety|content_policy|blocked/i.test(`${code} ${e.message ?? ""}`);
}

/** Where an image request was blocked: "input" (before anything was
 *  generated), "output" (after), or undefined when OpenAI didn't say. */
export function moderationStage(error: unknown): string | undefined {
  const details = (error as { error?: { moderation_details?: { moderation_stage?: unknown } } }).error?.moderation_details;
  return typeof details?.moderation_stage === "string" ? details.moderation_stage : undefined;
}

/** The model's refusal, if its answer was one: structured outputs put a
 *  refusal in its own content part, and `output_text` is then empty. */
export function refusalText(response: { output?: unknown[] }): string | undefined {
  for (const item of response.output ?? []) {
    const message = item as { type?: string; content?: { type?: string; refusal?: string }[] };
    if (message.type !== "message") continue;
    const part = message.content?.find((c) => c.type === "refusal");
    if (part?.refusal) return part.refusal;
  }
  return undefined;
}
