/**
 * syncEntitlement: the app sends the signed App Store transactions it holds
 * (StoreKit 2 `Transaction.currentEntitlements`, each as its
 * `jwsRepresentation`) and the server verifies them against Apple's root
 * certificates before it records Premium for the signed-in member. Nothing
 * the app merely says about itself unlocks the AI features.
 *
 * Xcode's StoreKit testing signs transactions locally, and Apple's library
 * skips verification for them, so they are accepted only inside the
 * emulator, never in production. A transaction Apple reported refunded or
 * revoked (appStore.ts records it in `revoked/{transactionId}`) doesn't
 * count unless the refund was reversed, so a signed transaction saved from
 * before a refund can't bring Premium back.
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";
import {
  Environment,
  SignedDataVerifier,
  VerificationException,
  VerificationStatus,
  type JWSTransactionDecodedPayload,
  type ResponseBodyV2DecodedPayload,
} from "@apple/app-store-server-library";
import { FieldValue, Timestamp, getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { APP_APPLE_ID, BUNDLE_ID, PRODUCT_TIERS, REGION, aiConfig, inEmulator, limitsFor, type Tier } from "./config.js";
import { ONCE, period } from "./quota.js";
import { Reason, appleSubject, freePlan } from "./access.js";

const certsDir = join(__dirname, "..", "certs");
let roots: Buffer[] | undefined;
function rootCertificates(): Buffer[] {
  roots ??= ["AppleRootCA-G3.cer", "AppleRootCA-G2.cer", "AppleIncRootCertificate.cer"]
    .map((name) => readFileSync(join(certsDir, name)));
  return roots;
}

let verifiers: SignedDataVerifier[] | undefined;
function allVerifiers(): SignedDataVerifier[] {
  if (!verifiers) {
    verifiers = [
      new SignedDataVerifier(rootCertificates(), true, Environment.PRODUCTION, BUNDLE_ID, APP_APPLE_ID),
      new SignedDataVerifier(rootCertificates(), true, Environment.SANDBOX, BUNDLE_ID),
    ];
    if (inEmulator()) {
      verifiers.push(new SignedDataVerifier(rootCertificates(), false, Environment.XCODE, BUNDLE_ID));
    }
  }
  return verifiers;
}

/** The first environment that verifies `jws`: its payload, undefined when
 *  none accepts it, or "retry" when Apple's certificate check (OCSP)
 *  couldn't be reached. */
async function firstVerified<T>(decode: (verifier: SignedDataVerifier) => Promise<T>): Promise<T | undefined | "retry"> {
  let retry = false;
  for (const verifier of allVerifiers()) {
    try {
      return await decode(verifier);
    } catch (error) {
      if (error instanceof VerificationException && error.status === VerificationStatus.RETRYABLE_VERIFICATION_FAILURE) {
        retry = true;
      }
      // Otherwise try the next environment.
    }
  }
  return retry ? "retry" : undefined;
}

/** A signed transaction, verified. */
export function verify(jws: string): Promise<JWSTransactionDecodedPayload | undefined | "retry"> {
  return firstVerified((verifier) => verifier.verifyAndDecodeTransaction(jws));
}

/** A signed App Store Server Notification, verified. */
export function verifyNotification(signedPayload: string): Promise<ResponseBodyV2DecodedPayload | undefined | "retry"> {
  return firstVerified((verifier) => verifier.verifyAndDecodeNotification(signedPayload));
}

interface Best {
  transactionId: string;
  productId: string;
  tier: Tier;
  originalTransactionId: string;
  expiresAt: number | null;
  environment: string;
}

/** The strongest current plan among the verified transactions: Pro over
 *  Premium, then a lifetime purchase, then the subscription that runs
 *  longest. */
export function pick<T extends { tier: Tier; expiresAt: number | null }>(current: T | undefined, next: T): T {
  if (!current) return next;
  if (current.tier !== next.tier) return next.tier === "pro" ? next : current;
  if (current.expiresAt === null) return current;
  if (next.expiresAt === null) return next;
  return next.expiresAt > current.expiresAt ? next : current;
}

export const syncEntitlement = onCall({ region: REGION, timeoutSeconds: 30, memory: "256MiB", maxInstances: 10 }, async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", Reason.signIn);
  const raw = (request.data as { transactions?: unknown } | undefined)?.transactions;
  // Optional: which year the goal photos count in (UTC's without it, which
  // differs from the member's only for hours around New Year).
  const timeZone = (request.data as { timeZone?: unknown } | undefined)?.timeZone;
  if (!Array.isArray(raw) || raw.length > 10 || raw.some((t) => typeof t !== "string" || t.length > 20_000)) {
    throw new HttpsError("invalid-argument", "transactions must be up to 10 signed transactions");
  }

  const now = Date.now();
  const candidates: Best[] = [];
  let couldNotCheck = false;
  for (const jws of raw as string[]) {
    const tx = await verify(jws);
    if (tx === "retry") { couldNotCheck = true; continue; }
    const tier = tx?.productId ? PRODUCT_TIERS.get(tx.productId) : undefined;
    if (!tx || tx.bundleId !== BUNDLE_ID || !tx.productId || !tier) continue;
    if (tx.revocationDate) continue;
    if (tx.expiresDate !== undefined && tx.expiresDate <= now) continue;
    if (inEmulator() === false && (tx.environment === Environment.XCODE || tx.environment === Environment.LOCAL_TESTING)) continue;
    const transactionId = tx.transactionId ?? tx.originalTransactionId;
    if (!transactionId) continue;
    candidates.push({
      transactionId,
      productId: tx.productId,
      tier,
      originalTransactionId: tx.originalTransactionId ?? transactionId,
      expiresAt: tx.expiresDate ?? null,
      environment: String(tx.environment ?? "unknown"),
    });
  }
  // Refunded or revoked since it was signed, and not reversed (appStore.ts).
  const db = getFirestore();
  const records = candidates.length > 0
    ? await db.getAll(...candidates.map((c) => db.doc(`revoked/${c.transactionId}`)))
    : [];
  let best: Best | undefined;
  for (const [i, candidate] of candidates.entries()) {
    const record = records[i];
    if (!record?.exists || record.get("state") === "reversed") best = pick(best, candidate);
  }

  // Apple's certificate check was unreachable for some transaction: keep
  // what's on record rather than take a plan away (or Pro down to Premium)
  // over a network hiccup, and let the app retry.
  const ref = db.doc(`entitlements/${request.auth.uid}`);
  if (couldNotCheck) {
    if (!best) throw new HttpsError("unavailable", Reason.ai);
    const onFile = (await ref.get()).data();
    const onFileExpiry = onFile?.expiresAt?.toMillis?.() as number | undefined;
    const onFileActive = onFile?.active === true && (onFileExpiry === undefined || onFileExpiry > now);
    if (onFileActive && onFile?.tier === "pro" && best.tier !== "pro") throw new HttpsError("unavailable", Reason.ai);
  }

  if (best) {
    await ref.set({
      active: true,
      productId: best.productId,
      tier: best.tier,
      transactionId: best.transactionId,
      originalTransactionId: best.originalTransactionId,
      expiresAt: best.expiresAt === null ? null : Timestamp.fromMillis(best.expiresAt),
      environment: best.environment,
      updatedAt: FieldValue.serverTimestamp(),
    });
  } else {
    await ref.set({ active: false, updatedAt: FieldValue.serverTimestamp() }, { merge: true });
  }
  // The goal photos the member can still make, so the app can say so before
  // they pick a photo, with one counter read at most: a paid plan's left
  // this year (goalPhotosLeft), or, without one, freeGoalPhotoUsed: true
  // when there is no free photo to make (used, or not offered: free goal
  // photos off, or no Apple identity; see access.ts freePlan), so the app
  // shows the plans. Both stay null when the read fails; freeGoalPhotoUsed
  // is null for paid members too. Testers aren't seen here: their
  // allowance shows in goalPhoto's answers.
  let goalPhotosLeft: number | null = null;
  let freeGoalPhotoUsed: boolean | null = null;
  try {
    const config = await aiConfig();
    const used = async (path: string) => Number((await db.doc(path).get()).get("count") ?? 0);
    if (best) {
      const year = period("year", timeZone);
      goalPhotosLeft = Math.max(0, limitsFor(config, best.tier).goalPhoto - await used(`usage/tx_${best.originalTransactionId}/goalPhoto/${year}`));
    } else {
      const free = freePlan(request.auth.uid, config, appleSubject(request.auth.token), inEmulator());
      freeGoalPhotoUsed = free ? await used(`usage/${free.usageKey}/goalPhoto/${ONCE}`) >= limitsFor(config, "free").goalPhoto : true;
    }
  } catch {
    // Unknown: the app lets the member try, and the server decides.
  }
  logger.info("syncEntitlement", { uid: request.auth.uid, tier: best?.tier ?? null, product: best?.productId, env: best?.environment });
  // `premium` is true for any paid plan; `tier` says which.
  return { premium: !!best, tier: best?.tier ?? null, expiresAt: best?.expiresAt ?? null, goalPhotosLeft, freeGoalPhotoUsed };
});
