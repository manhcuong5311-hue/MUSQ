/**
 * appStoreNotifications: App Store Server Notifications V2. Apple posts a
 * signed notification when a paid plan is refunded or revoked (a
 * Family Sharing member losing access), and the server takes Premium off the
 * accounts holding it right away rather than at their next sync. It also
 * records the transaction in `revoked/{transactionId}`, which
 * syncEntitlement checks, so a signed transaction saved from before the
 * refund can't turn Premium back on. A later subscription renewal is a new
 * transaction, so it works again. A reversed refund marks the record
 * reversed (it isn't deleted): Apple retries a failed delivery for days, so
 * notifications can arrive out of order, and one older than the record
 * (by Apple's signedDate) is ignored.
 *
 * The URL goes into App Store Connect › App Information › App Store Server
 * Notifications, for both Production and Sandbox, Version 2:
 * https://asia-southeast1-musq-app.cloudfunctions.net/appStoreNotifications
 */
import { FieldValue, Timestamp, getFirestore } from "firebase-admin/firestore";
import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { NotificationTypeV2, type JWSTransactionDecodedPayload } from "@apple/app-store-server-library";
import { BUNDLE_ID, PRODUCT_TIERS, REGION } from "./config.js";
import { verify, verifyNotification } from "./entitlements.js";

type Revocable = JWSTransactionDecodedPayload & { transactionId: string; originalTransactionId: string };

/** Records a refund, revoke or reversal for `tx`, unless a newer
 *  notification about it was already recorded. Returns whether it did. */
async function record(tx: Revocable, type: string, signedDate: number): Promise<boolean> {
  const db = getFirestore();
  const ref = db.doc(`revoked/${tx.transactionId}`);
  return db.runTransaction(async (t) => {
    const snap = await t.get(ref);
    if (snap.exists && Number(snap.get("signedDate") ?? 0) > signedDate) return false;
    t.set(ref, {
      state: type === NotificationTypeV2.REFUND_REVERSED ? "reversed" : "revoked",
      type,
      signedDate,
      productId: tx.productId ?? null,
      originalTransactionId: tx.originalTransactionId,
      revokedAt: tx.revocationDate ? Timestamp.fromMillis(tx.revocationDate) : null,
      environment: String(tx.environment ?? "unknown"),
      updatedAt: FieldValue.serverTimestamp(),
    });
    return true;
  });
}

/** Takes Premium off everyone holding it from this purchase; a member with a
 *  newer, valid renewal gets it back at the app's next sync. */
async function deactivate(originalTransactionId: string): Promise<number> {
  const holders = await getFirestore().collection("entitlements").where("originalTransactionId", "==", originalTransactionId).get();
  await Promise.all(holders.docs.map((doc) =>
    doc.ref.set({ active: false, revoked: true, updatedAt: FieldValue.serverTimestamp() }, { merge: true })));
  return holders.size;
}

export const appStoreNotifications = onRequest(
  { region: REGION, invoker: "public", timeoutSeconds: 30, memory: "256MiB", maxInstances: 5 },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).end();
      return;
    }
    const signedPayload = (req.body as { signedPayload?: unknown } | undefined)?.signedPayload;
    if (typeof signedPayload !== "string" || signedPayload.length > 200_000) {
      res.status(400).end();
      return;
    }
    // Only Apple can sign one. When Apple's certificate check can't be
    // reached, answer 503 so Apple sends it again later.
    const notification = await verifyNotification(signedPayload);
    if (notification === "retry") {
      res.status(503).end();
      return;
    }
    if (!notification) {
      logger.warn("appStoreNotifications: a payload that doesn't verify");
      res.status(400).end();
      return;
    }
    const type = String(notification.notificationType ?? "");
    const signedDate = typeof notification.signedDate === "number" ? notification.signedDate : Date.now();
    let applied: boolean | undefined;
    let accounts: number | undefined;
    if (type === NotificationTypeV2.REFUND || type === NotificationTypeV2.REVOKE || type === NotificationTypeV2.REFUND_REVERSED) {
      const signed = notification.data?.signedTransactionInfo;
      const tx = signed ? await verify(signed) : undefined;
      if (tx === "retry") {
        res.status(503).end();
        return;
      }
      const transactionId = tx?.transactionId;
      const originalTransactionId = tx?.originalTransactionId ?? transactionId;
      if (tx && transactionId && originalTransactionId && tx.bundleId === BUNDLE_ID && tx.productId && PRODUCT_TIERS.has(tx.productId)) {
        applied = await record({ ...tx, transactionId, originalTransactionId }, type, signedDate);
        if (applied && type !== NotificationTypeV2.REFUND_REVERSED) accounts = await deactivate(originalTransactionId);
      }
    }
    logger.info("appStoreNotifications", {
      type,
      subtype: notification.subtype,
      environment: notification.data?.environment,
      applied,
      accounts,
    });
    res.status(200).end();
  },
);
