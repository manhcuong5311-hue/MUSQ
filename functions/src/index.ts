/**
 * MUSQ's server (Firebase project musq-app, Singapore): the Premium AI
 * features and the account plumbing they need. Every callable requires a
 * signed-in member; the AI ones count usage per plan (server-verified
 * Premium or Pro, or a free account's 5 chat questions a day and one goal
 * photo). appStoreNotifications is Apple's (signed) refund feed. The
 * OpenAI key is a Secret Manager secret, never in the app. friends*.ts is
 * MUSQ Friends (codes, requests, a summarized feed, nudges, reactions).
 */
import { initializeApp } from "firebase-admin/app";
import { setGlobalOptions } from "firebase-functions/v2";
import { REGION } from "./config.js";

initializeApp();
setGlobalOptions({ region: REGION, maxInstances: 10 });

export { aiChat } from "./chat.js";
export { scanMeal } from "./meal.js";
export { goalPhoto } from "./goalPhoto.js";
export { syncEntitlement } from "./entitlements.js";
export { deleteAccount } from "./account.js";
export { appStoreNotifications } from "./appStore.js";
export {
  friendsProfileSet, friendsSync, friendsRequest, friendsRespond, friendsRemove, friendsBlock,
  friendsReport, friendsMute, friendsPost, friendsFeed, friendsReact, friendsNudge,
} from "./friends.js";
