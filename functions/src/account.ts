/**
 * deleteAccount: App Store guideline 5.1.1(v). Removes what the server
 * holds for the member (their Premium record and the usage counted on the
 * account: a tester's) and the Auth account itself. The app first revokes
 * the Sign in with Apple token, which only the device can do (it needs a
 * fresh authorization code), and says how that went: a failure is logged,
 * since it usually means the Apple key is missing from Firebase
 * Authentication's Apple provider. Usage counters keyed by purchase hold no
 * personal data and stay with the purchase: daily, monthly and yearly ones
 * delete themselves within weeks of their period (Firestore TTL, see
 * quota.ts). The free goal photo's counter (`usage/apple_…`, see access.ts
 * freeUsageKey) stays too: it holds only a salted hash of the Apple user id
 * and a count, no uid and nothing that names the member, and it keeps a
 * deleted and re-created account from getting another free photo. Photos
 * and chats are never stored on the server; Cloud Logging keeps request
 * logs (with the uid) for 30 days.
 */
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { REGION } from "./config.js";
import { Reason } from "./access.js";

/** The Firestore records deleteAccount removes: the Premium record and
 *  everything counted on the account's uid. Never the Apple ID's free goal
 *  photo counter (`usage/apple_…`). */
export function accountRecords(uid: string): { entitlement: string; usage: string } {
  return { entitlement: `entitlements/${uid}`, usage: `usage/uid_${uid}` };
}

export const deleteAccount = onCall({ region: REGION, timeoutSeconds: 30, memory: "256MiB", maxInstances: 10 }, async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", Reason.signIn);
  const uid = request.auth.uid;
  const revocation = (request.data as { appleRevocation?: unknown } | undefined)?.appleRevocation;
  const appleRevocation = revocation === "done" || revocation === "failed" || revocation === "skipped" ? revocation : "unknown";
  if (appleRevocation === "failed") {
    logger.warn("deleteAccount: the app couldn't revoke the Sign in with Apple token; check the Apple provider's key in Firebase Authentication", { uid });
  }
  const db = getFirestore();
  const records = accountRecords(uid);
  await db.doc(records.entitlement).delete();
  await db.recursiveDelete(db.doc(records.usage));
  try {
    await getAuth().deleteUser(uid);
  } catch (error) {
    if ((error as { code?: string }).code !== "auth/user-not-found") throw error;
  }
  logger.info("deleteAccount", { uid, appleRevocation });
  return { deleted: true };
});
