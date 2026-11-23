// End-to-end check of the callables against the Firebase emulators
// (auth, firestore, functions) with MOCK_OPENAI=1 in functions/.env.local.
// Run: npm run emulators -- --project musq-app  (then)  node scripts/smoke.mjs
// Against emulators on other ports or another project id (another set
// already running, say), set SMOKE_PROJECT, FIREBASE_AUTH_EMULATOR_HOST,
// FIRESTORE_EMULATOR_HOST and FUNCTIONS_EMULATOR_HOST ("127.0.0.1:9199").
import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";

const PROJECT = process.env.SMOKE_PROJECT ?? "musq-app";
const REGION = "asia-southeast1";
const AUTH = `http://${process.env.FIREBASE_AUTH_EMULATOR_HOST ?? "127.0.0.1:9099"}`;
const FS = `http://${process.env.FIRESTORE_EMULATOR_HOST ?? "127.0.0.1:8080"}/v1/projects/${PROJECT}/databases/(default)/documents`;
const FN = `http://${process.env.FUNCTIONS_EMULATOR_HOST ?? "127.0.0.1:5001"}/${PROJECT}/${REGION}`;

let failures = 0;
const check = (name, ok, detail = "") => {
  console.log(`${ok ? "PASS" : "FAIL"}  ${name}${detail ? `  (${detail})` : ""}`);
  if (!ok) failures++;
};
/** A call's error, or its result without the (long) image. */
const summary = (r) => JSON.stringify(r.error ?? { ...r.result, image: undefined }).slice(0, 200);

async function signUp(email) {
  const r = await fetch(`${AUTH}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=fake`, {
    method: "POST", headers: { "content-type": "application/json" },
    body: JSON.stringify({ email, password: "pass1234", returnSecureToken: true }),
  });
  const j = await r.json();
  return { token: j.idToken, uid: j.localId };
}

/** Sign in with Apple, as the emulator fakes it: the ID token carries the
 *  Apple user id (`sub`) in firebase.identities["apple.com"]. */
async function signInWithApple(sub) {
  const r = await fetch(`${AUTH}/identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=fake`, {
    method: "POST", headers: { "content-type": "application/json" },
    body: JSON.stringify({
      postBody: `id_token=${encodeURIComponent(JSON.stringify({ sub, email: `${sub}@privaterelay.appleid.com` }))}&providerId=apple.com`,
      requestUri: "http://localhost", returnIdpCredential: true, returnSecureToken: true,
    }),
  });
  const j = await r.json();
  return { token: j.idToken, uid: j.localId };
}

async function call(name, data, token) {
  const r = await fetch(`${FN}/${name}`, {
    method: "POST",
    headers: { "content-type": "application/json", ...(token ? { authorization: `Bearer ${token}` } : {}) },
    body: JSON.stringify({ data }),
  });
  const j = await r.json();
  return j.error ? { error: j.error } : { result: j.result };
}

async function setDoc(path, fields) {
  const toValue = (v) => typeof v === "number" ? { integerValue: String(v) } : typeof v === "boolean" ? { booleanValue: v } : { stringValue: String(v) };
  const body = { fields: Object.fromEntries(Object.entries(fields).map(([k, v]) => [k, toValue(v)])) };
  const r = await fetch(`${FS}/${path}`, { method: "PATCH", headers: { "content-type": "application/json", authorization: "Bearer owner" }, body: JSON.stringify(body) });
  if (!r.ok) throw new Error(`setDoc ${path}: ${r.status} ${await r.text()}`);
}

async function deleteDoc(path) {
  await fetch(`${FS}/${path}`, { method: "DELETE", headers: { authorization: "Bearer owner" } });
}

async function getDoc(path) {
  const r = await fetch(`${FS}/${path}`, { headers: { authorization: "Bearer owner" } });
  return r.ok ? (await r.json()).fields ?? {} : undefined;
}

// Xcode-environment JWS: Apple's library skips the signature for these, and
// the server accepts them only inside the emulator.
const b64url = (o) => Buffer.from(JSON.stringify(o)).toString("base64url");
const jws = (payload) => `${b64url({ alg: "ES256", typ: "JWT" })}.${b64url(payload)}.c2ln`;
const BUNDLE = "com.SamCorp.GymWorkout";
const lifetimeTx = (id, extra = {}) => jws({
  transactionId: id, originalTransactionId: id, bundleId: BUNDLE, productId: `${BUNDLE}.removeads.lifetime`,
  purchaseDate: Date.now() - 60_000, originalPurchaseDate: Date.now() - 60_000, quantity: 1, type: "Non-Consumable",
  inAppOwnershipType: "PURCHASED", signedDate: Date.now(), environment: "Xcode", storefront: "VNM", storefrontId: "143471", ...extra,
});
const notification = (type, signedTransactionInfo, signedDate = Date.now()) => jws({
  notificationType: type, notificationUUID: `smoke-${type}-${signedDate}`, version: "2.0", signedDate,
  data: { bundleId: BUNDLE, environment: "Xcode", signedTransactionInfo },
});
async function notify(body, method = "POST") {
  const r = await fetch(`${FN}/appStoreNotifications`, method === "POST"
    ? { method, headers: { "content-type": "application/json" }, body: JSON.stringify(body) }
    : { method });
  return r.status;
}

const png = readFileSync(new URL("../../GymWorkout/Assets.xcassets/AppIcon.appiconset/1024.png", import.meta.url), { encoding: "base64" });

// The food table the server grounds meal scans in, as the build put it in
// lib/ for the emulator. The checks follow whatever it holds; the mock
// answer (meal.ts MOCK_MEAL) needs vn.pho_bo_tai and egg_boiled in it.
const foodTable = JSON.parse(readFileSync(new URL("../lib/data/foodTable.json", import.meta.url), "utf8"));
const entries = new Map(foodTable.items.map((e) => [e.id, e]));
// Same rule as meal.ts and the app's caption: a class shows when its
// rounded grams are 1 or more.
const hiddenFor = (entry, grams) => {
  const hidden = {};
  for (const key of ["oil", "sugar", "sauce"]) {
    const amount = Math.round(((entry.hidden100?.[key] ?? 0) * grams) / 100);
    if (amount >= 1) hidden[key] = amount;
  }
  return Object.keys(hidden).length ? hidden : null;
};

// Limits low enough to reach in a test, set before any call caches the
// config. Premium's 2 goal photos a year and a free account's one are the
// defaults.
const LIMITS = { chatDailyLimitPro: 2, mealDailyLimitPro: 3, goalPhotoYearlyLimitPro: 1, chatDailyLimitPremium: 1 };
await setDoc("config/ai", LIMITS);

// Goal photos count by the member's calendar year (Asia/Ho_Chi_Minh here).
const yearVN = Number(new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Ho_Chi_Minh", year: "numeric" }).format(new Date()));
const goalAsk = { image: png, sex: "male", muscle: "muscular", fat: "athletic", birthYear: 1996, confirmsOwnPhoto: true, timeZone: "Asia/Ho_Chi_Minh" };
// What an app from before the look picker sends: its plan's goal only.
const legacyAsk = { image: png, goal: "buildMuscle", sex: "male", birthYear: 1996, confirmsOwnPhoto: true, timeZone: "Asia/Ho_Chi_Minh" };
const yearEndsPlus2 = Date.UTC(yearVN + 1, 0, 3);

const nobody = await call("aiChat", { messages: [{ role: "user", content: "hi" }] });
check("aiChat refuses without sign-in", nobody.error?.status === "UNAUTHENTICATED", nobody.error?.message);
const nobodyPhoto = await call("goalPhoto", goalAsk);
check("goalPhoto refuses without sign-in", nobodyPhoto.error?.status === "UNAUTHENTICATED", nobodyPhoto.error?.message);

const free = await signUp(`free${Date.now()}@test.dev`);
const freeChat = await call("aiChat", { messages: [{ role: "user", content: "How many sets for chest?" }] }, free.token);
check("aiChat refuses a non-Premium member", freeChat.error?.status === "PERMISSION_DENIED" && freeChat.error?.message === "premium-required", freeChat.error?.message);
const freeMeal = await call("scanMeal", { image: png, locale: "en", timeZone: "Asia/Ho_Chi_Minh" }, free.token);
check("scanMeal refuses a non-Premium member", freeMeal.error?.status === "PERMISSION_DENIED" && freeMeal.error?.message === "premium-required", freeMeal.error?.message);

const junk = await call("syncEntitlement", { transactions: ["not.a.jws"] }, free.token);
check("syncEntitlement rejects an unsigned transaction", junk.result?.premium === false, JSON.stringify(junk.result ?? junk.error));
check("sync says a new account's free goal photo is still there", junk.result?.freeGoalPhotoUsed === false && junk.result?.goalPhotosLeft === null, JSON.stringify(junk.result));

// A signed-in account without a plan: one goal photo, ever (counted on the
// uid here: an emulator account without an Apple identity).
const freeSame = await call("goalPhoto", { ...goalAsk, muscle: "same", fat: "same" }, free.token);
check("goalPhoto refuses a look that changes nothing", freeSame.error?.status === "INVALID_ARGUMENT", JSON.stringify(freeSame.error ?? freeSame.result).slice(0, 160));
const freeHolds = await call("goalPhoto", { ...goalAsk, holdsPlan: true }, free.token);
check("a device that holds a plan the server hasn't seen is refused (premium-required), not given the free photo",
  freeHolds.error?.status === "PERMISSION_DENIED" && freeHolds.error?.message === "premium-required", summary(freeHolds));
const freePhoto = await call("goalPhoto", { ...goalAsk, holdsPlan: false }, free.token);
check("an account without a plan gets its free goal photo (the refused calls took nothing)",
  typeof freePhoto.result?.image === "string" && freePhoto.result.image.length > 1000 && freePhoto.result.tier === "free"
    && freePhoto.result.period === "once" && freePhoto.result.remaining === 0 && freePhoto.result.remainingThisMonth === 0,
  JSON.stringify(freePhoto.error ?? { ...freePhoto.result, image: undefined }));
const freePhoto2 = await call("goalPhoto", goalAsk, free.token);
check("the free goal photo is once ever: the limit error names the free plan and the period",
  freePhoto2.error?.status === "RESOURCE_EXHAUSTED" && freePhoto2.error?.message === "limit-reached" && freePhoto2.error?.details?.tier === "free"
    && freePhoto2.error?.details?.period === "once" && freePhoto2.error?.details?.remaining === 0,
  JSON.stringify(freePhoto2.error ?? freePhoto2.result).slice(0, 200));
const onceCounter = await getDoc(`usage/uid_${free.uid}/goalPhoto/once`);
check("the free goal photo is counted on the account, with no expiry", onceCounter?.count?.integerValue === "1" && !onceCounter?.expireAt, JSON.stringify(onceCounter ?? null).slice(0, 160));
const freeSynced = await call("syncEntitlement", { transactions: [] }, free.token);
check("sync says the free goal photo is used", freeSynced.result?.premium === false && freeSynced.result?.freeGoalPhotoUsed === true, JSON.stringify(freeSynced.result ?? freeSynced.error));

// With Sign in with Apple, the free goal photo is counted per Apple ID (a
// salted hash of its user id): deleting the account and signing in again
// with the same Apple ID, which gives a new uid, doesn't bring it back.
const appleSub = `smoke-${Date.now()}.0a1b2c3d.0123`;
const appleKey = `apple_${createHash("sha256").update(`musq-free:${appleSub}`).digest("hex").slice(0, 32)}`;
const apple1 = await signInWithApple(appleSub);
const apple1Sync = await call("syncEntitlement", { transactions: [] }, apple1.token);
check("sync says a new Apple ID's free goal photo is there", apple1Sync.result?.freeGoalPhotoUsed === false, JSON.stringify(apple1Sync.result ?? apple1Sync.error));
const apple1Photo = await call("goalPhoto", goalAsk, apple1.token);
check("a Sign in with Apple member without a plan gets the free goal photo",
  apple1Photo.result?.tier === "free" && apple1Photo.result?.period === "once" && apple1Photo.result?.remaining === 0, summary(apple1Photo));
const appleCounter = await getDoc(`usage/${appleKey}/goalPhoto/once`);
check("it's counted on the Apple ID's hashed key, with no expiry, not on the uid",
  appleCounter?.count?.integerValue === "1" && !appleCounter?.expireAt && (await getDoc(`usage/uid_${apple1.uid}/goalPhoto/once`)) === undefined,
  JSON.stringify(appleCounter ?? null).slice(0, 160));
const apple1Deleted = await call("deleteAccount", { appleRevocation: "skipped" }, apple1.token);
const keptCounter = await getDoc(`usage/${appleKey}/goalPhoto/once`);
check("deleteAccount keeps the Apple ID's free goal photo counter", apple1Deleted.result?.deleted === true && keptCounter?.count?.integerValue === "1", JSON.stringify({ deleted: apple1Deleted.result ?? apple1Deleted.error, counter: keptCounter ?? null }).slice(0, 200));
const apple2 = await signInWithApple(appleSub);
const apple2Photo = await call("goalPhoto", goalAsk, apple2.token);
check("signing in again with the same Apple ID (a new uid) brings no second free photo",
  !!apple2.uid && apple2.uid !== apple1.uid && apple2Photo.error?.message === "limit-reached" && apple2Photo.error?.details?.tier === "free" && apple2Photo.error?.details?.period === "once",
  `${apple1.uid} -> ${apple2.uid} ${summary(apple2Photo)}`);
const apple2Sync = await call("syncEntitlement", { transactions: [] }, apple2.token);
check("sync tells the re-created account its free goal photo is used", apple2Sync.result?.freeGoalPhotoUsed === true, JSON.stringify(apple2Sync.result ?? apple2Sync.error));
await call("deleteAccount", { appleRevocation: "skipped" }, apple2.token);

const tester = await signUp(`tester${Date.now()}@test.dev`);
await setDoc(`testers/${tester.uid}`, { note: "smoke test" });

const ask = { messages: [{ role: "user", content: "How many sets for chest?" }], locale: "en", timeZone: "Asia/Ho_Chi_Minh",
  context: { goal: "buildMuscle", weightKg: 74, recentWorkouts: [{ date: "2026-11-20", groups: ["chest"], exercises: [{ name: "Bench Press", sets: 3, reps: 8, weightKg: 60 }] }] } };
const chat1 = await call("aiChat", ask, tester.token);
check("aiChat answers a tester", typeof chat1.result?.reply === "string" && chat1.result.remainingToday === 1, JSON.stringify(chat1.result ?? chat1.error));
const chat2 = await call("aiChat", ask, tester.token);
check("aiChat counts down", chat2.result?.remainingToday === 0, JSON.stringify(chat2.result ?? chat2.error));
const chat3 = await call("aiChat", ask, tester.token);
check("aiChat stops at the daily limit", chat3.error?.status === "RESOURCE_EXHAUSTED" && chat3.error?.message === "limit-reached", chat3.error?.message);

// A tester set to Premium gets Premium's allowance, and the limit error
// says which plan it was, so the app can offer Pro.
const premiumTester = await signUp(`premiumtester${Date.now()}@test.dev`);
await setDoc(`testers/${premiumTester.uid}`, { note: "smoke test", tier: "premium" });
const premium1 = await call("aiChat", ask, premiumTester.token);
check("a Premium member gets Premium's chat allowance", premium1.result?.remainingToday === 0, JSON.stringify(premium1.result ?? premium1.error).slice(0, 120));
const premium2 = await call("aiChat", ask, premiumTester.token);
check("Premium's limit error names the plan", premium2.error?.message === "limit-reached" && premium2.error?.details?.tier === "premium", JSON.stringify(premium2.error));
const premiumMeal = await call("scanMeal", { image: png, locale: "en", timeZone: "Asia/Ho_Chi_Minh" }, premiumTester.token);
check("Premium has no meal scans", premiumMeal.error?.message === "limit-reached" && premiumMeal.error?.details?.tier === "premium", JSON.stringify(premiumMeal.error ?? premiumMeal.result).slice(0, 160));
const premiumPhoto = await call("goalPhoto", legacyAsk, premiumTester.token);
check("Premium's first goal photo of the year (an older app's goal-only request still works)",
  premiumPhoto.result?.period === "year" && premiumPhoto.result?.tier === "premium" && premiumPhoto.result?.remaining === 1 && premiumPhoto.result?.remainingThisMonth === 1,
  summary(premiumPhoto));
const premiumPhoto2 = await call("goalPhoto", goalAsk, premiumTester.token);
check("Premium's second goal photo of the year", premiumPhoto2.result?.remaining === 0 && premiumPhoto2.result?.period === "year", summary(premiumPhoto2));
const premiumPhoto3 = await call("goalPhoto", goalAsk, premiumTester.token);
check("Premium's third waits for next year: the limit error names the plan and the year",
  premiumPhoto3.error?.message === "limit-reached" && premiumPhoto3.error?.details?.tier === "premium" && premiumPhoto3.error?.details?.period === "year",
  summary(premiumPhoto3));
const yearCounter = await getDoc(`usage/uid_${premiumTester.uid}/goalPhoto/${yearVN}`);
check("the yearly counter deletes itself two days after the year ends",
  yearCounter?.count?.integerValue === "2" && Date.parse(yearCounter?.expireAt?.timestampValue ?? "") === yearEndsPlus2,
  JSON.stringify(yearCounter ?? null).slice(0, 200));

const badChat = await call("aiChat", { messages: [{ role: "assistant", content: "x" }] }, tester.token);
check("aiChat rejects a request without a question", badChat.error?.status === "INVALID_ARGUMENT", badChat.error?.message);

const meal = await call("scanMeal", { image: png, locale: "en", timeZone: "Asia/Ho_Chi_Minh" }, tester.token);
const items = meal.result?.items ?? [];
const sum = (key) => items.reduce((total, i) => total + i[key], 0);
check("scanMeal returns items and totals", meal.result?.isFood === true && items.length === 4 && ["kcal", "proteinG", "fatG", "carbsG"].every((k) => meal.result.total[k] === sum(k)), JSON.stringify(meal.result ?? meal.error).slice(0, 160));
check("scanMeal names the table version it grounded in", meal.result?.tableVersion === (foodTable.version > 0 ? foodTable.version : null), `${meal.result?.tableVersion} vs ${foodTable.version}`);
// Counts go with 3 decimals (the app words them), and count × pieceGrams
// is the grams (pieceGrams 0 when the grams aren't known), which the app
// steps by.
const thousandths = (n) => Math.round(n * 1000) / 1000;
const sentCount = (i) => i.count >= 0.001 && i.count <= 100 && i.count === thousandths(i.count);
const pieceAdds = (i) => (i.grams === 0 ? i.pieceGrams === 0 : Math.abs(i.count * i.pieceGrams - i.grams) < 0.5);
const fromTable = items.filter((i) => i.basis === "table");
check("scanMeal takes table foods' names, kcal, macros and hidden fat from the table",
  fromTable.length === 2 && fromTable.every((i) => {
    const e = entries.get(i.ref);
    const per = (value) => Math.round((value * i.grams) / 100);
    // One piece: the scan's own (grams / count) or, when the count came from the grams, the entry's.
    const piece = i.pieceGrams === thousandths(i.grams / i.count) || i.pieceGrams === e?.size.g;
    return e && i.name === e.en && i.kcal === per(e.per100.kcal) && i.proteinG === per(e.per100.p) && i.fatG === per(e.per100.f) && i.carbsG === per(e.per100.c)
      && i.unit === e.unit && JSON.stringify(i.hidden) === JSON.stringify(hiddenFor(e, i.grams))
      && (e.unit === "piece" ? sentCount(i) && pieceAdds(i) && piece && i.servingGrams === null : i.count === null && i.pieceGrams === null && i.servingGrams === e.size.g);
  }), JSON.stringify(fromTable).slice(0, 300));
check("scanMeal keeps the model's own grams and kcal for table foods (whole numbers), none for estimates",
  fromTable.length === 2 && fromTable.every((i) => Number.isInteger(i.modelGrams) && i.modelGrams > 0 && Number.isInteger(i.modelKcal))
    && items.filter((i) => i.basis === "estimate").every((i) => i.modelGrams === null && i.modelKcal === null),
  JSON.stringify(items.map((i) => [i.basis, i.modelGrams, i.modelKcal])));
const estimates = items.filter((i) => i.basis === "estimate");
check("scanMeal keeps the model's estimate for foods outside the table, counted ones by the piece",
  estimates.length === 2 && estimates.every((i) => i.ref === null && i.hidden === null && i.servingGrams === null
    && (i.unit === "piece" ? sentCount(i) && pieceAdds(i) && i.pieceGrams === thousandths(i.grams / i.count) : i.count === null && i.pieceGrams === null))
    && estimates.some((i) => i.unit === "piece") && estimates.some((i) => i.unit === "g"), JSON.stringify(estimates).slice(0, 300));
const mealVi = await call("scanMeal", { image: png, locale: "vi", timeZone: "Asia/Ho_Chi_Minh" }, tester.token);
const viTable = (mealVi.result?.items ?? []).filter((i) => i.basis === "table");
check("table foods are named in the member's language", viTable.length === 2 && viTable.every((i) => i.name === entries.get(i.ref)?.vi), JSON.stringify(mealVi.result?.items?.map((i) => i.name) ?? mealVi.error));
const badMeal = await call("scanMeal", { image: "abc" }, tester.token);
check("scanMeal rejects a non-image", badMeal.error?.status === "INVALID_ARGUMENT", badMeal.error?.message);

const noConsent = await call("goalPhoto", { ...goalAsk, confirmsOwnPhoto: undefined }, tester.token);
check("goalPhoto needs the own-photo confirmation", noConsent.error?.status === "FAILED_PRECONDITION" && noConsent.error?.message === "photo-not-allowed", noConsent.error?.message);
const teen = await call("goalPhoto", { ...goalAsk, birthYear: 2011 }, tester.token);
check("goalPhoto refuses under 18", teen.error?.status === "FAILED_PRECONDITION" && teen.error?.message === "age-required", teen.error?.message);
const turning18 = await call("goalPhoto", { ...goalAsk, birthYear: yearVN - 18 }, tester.token);
check("goalPhoto refuses someone turning 18 this year (may still be 17)", turning18.error?.message === "age-required", turning18.error?.message);
const badLevel = await call("goalPhoto", { ...goalAsk, muscle: "huge" }, tester.token);
check("goalPhoto refuses a level it doesn't know", badLevel.error?.status === "INVALID_ARGUMENT", badLevel.error?.message);
const photo = await call("goalPhoto", { ...goalAsk, sex: "female", muscle: "toned", fat: "lean" }, tester.token);
check("goalPhoto returns an image (Pro: yearly)",
  typeof photo.result?.image === "string" && photo.result.image.length > 1000 && photo.result.remaining === 0 && photo.result.remainingThisMonth === 0
    && photo.result.period === "year" && photo.result.tier === "pro",
  summary(photo));
const photo2 = await call("goalPhoto", goalAsk, tester.token);
check("goalPhoto stops at the yearly limit", photo2.error?.status === "RESOURCE_EXHAUSTED" && photo2.error?.details?.period === "year" && photo2.error?.details?.tier === "pro", summary(photo2));

// A switch-off typed in the console as a string still switches off.
await setDoc("config/ai", { ...LIMITS, mealEnabled: "false" });
const paused = await call("scanMeal", { image: png, locale: "en" }, tester.token);
check("config/ai mealEnabled \"false\" pauses meal scans", paused.error?.status === "UNAVAILABLE" && paused.error?.message === "feature-off", JSON.stringify(paused.error ?? paused.result).slice(0, 120));
await setDoc("config/ai", { ...LIMITS, mealTable: "false" });
const untabled = await call("scanMeal", { image: png, locale: "en", timeZone: "Asia/Ho_Chi_Minh" }, tester.token);
check("config/ai mealTable \"false\" keeps every food as the model's estimate, with no table version", untabled.result?.items?.length === 4 && untabled.result.items.every((i) => i.basis === "estimate" && i.ref === null && i.modelGrams === null) && untabled.result.tableVersion === null, JSON.stringify(untabled.result?.items?.map((i) => [i.name, i.basis]) ?? untabled.error));
// Free goal photos switched off: an account without a plan is refused as before.
await setDoc("config/ai", { ...LIMITS, goalPhotoOnceLimitFree: "0" });
const freeOff = await signUp(`freeoff${Date.now()}@test.dev`);
const freeOffPhoto = await call("goalPhoto", goalAsk, freeOff.token);
check("config/ai goalPhotoOnceLimitFree 0 closes the goal photo to accounts without a plan", freeOffPhoto.error?.status === "PERMISSION_DENIED" && freeOffPhoto.error?.message === "premium-required", summary(freeOffPhoto));
const freeOffSync = await call("syncEntitlement", { transactions: [] }, freeOff.token);
check("with free goal photos off, sync says there's no free photo to make (used: true)", freeOffSync.result?.freeGoalPhotoUsed === true, JSON.stringify(freeOffSync.result ?? freeOffSync.error));
await call("deleteAccount", { appleRevocation: "skipped" }, freeOff.token);
await setDoc("config/ai", LIMITS);

const counter = await getDoc(`usage/uid_${tester.uid}/meal/${new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Ho_Chi_Minh", year: "numeric", month: "2-digit", day: "2-digit" }).format(new Date())}`);
check("usage counters carry expireAt for the TTL policy", !!counter?.expireAt?.timestampValue, JSON.stringify(counter ?? null).slice(0, 160));

// Purchases: a refund notification takes Premium away, and the saved
// pre-refund transaction can't bring it back.
const buyer = await signUp(`buyer${Date.now()}@test.dev`);
const txId = `smoke-${Date.now()}`;
const bought = lifetimeTx(txId);
// Bought, but the server hasn't seen it yet (a stale record): the app says
// the device holds a plan, gets premium-required, syncs and retries, and
// the free photo stays unspent.
const unsynced = await call("goalPhoto", { ...goalAsk, holdsPlan: true }, buyer.token);
check("a buyer the server hasn't synced is refused (premium-required) rather than spend the free photo",
  unsynced.error?.status === "PERMISSION_DENIED" && unsynced.error?.message === "premium-required" && (await getDoc(`usage/uid_${buyer.uid}/goalPhoto/once`)) === undefined,
  summary(unsynced));
const synced = await call("syncEntitlement", { transactions: [bought], timeZone: "Asia/Ho_Chi_Minh" }, buyer.token);
check("syncEntitlement records a lifetime purchase as Premium", synced.result?.premium === true && synced.result?.tier === "premium", JSON.stringify(synced.result ?? synced.error));
check("sync says the Premium purchase has its 2 goal photos this year", synced.result?.goalPhotosLeft === 2 && synced.result?.freeGoalPhotoUsed === null, JSON.stringify(synced.result));
const buyerPhoto = await call("goalPhoto", { ...goalAsk, holdsPlan: true }, buyer.token);
const resynced = await call("syncEntitlement", { transactions: [bought], timeZone: "Asia/Ho_Chi_Minh" }, buyer.token);
check("after the sync the retry counts on Premium, and sync says one is left this year", buyerPhoto.result?.period === "year" && buyerPhoto.result?.tier === "premium" && resynced.result?.goalPhotosLeft === 1, JSON.stringify({ photo: buyerPhoto.error ?? buyerPhoto.result?.period, sync: resynced.result }));
const buyerCounter = await getDoc(`usage/tx_${txId}/goalPhoto/${yearVN}`);
check("a purchase's goal photos count on the purchase, by year", buyerCounter?.count?.integerValue === "1" && !!buyerCounter?.expireAt, JSON.stringify(buyerCounter ?? null).slice(0, 160));
const proTx = jws({
  transactionId: `smoke-pro-${Date.now()}`, originalTransactionId: `smoke-pro-${Date.now()}`, bundleId: BUNDLE, productId: `${BUNDLE}.pro.yearly`,
  purchaseDate: Date.now() - 60_000, originalPurchaseDate: Date.now() - 60_000, expiresDate: Date.now() + 365 * 86_400_000, quantity: 1,
  type: "Auto-Renewable Subscription", inAppOwnershipType: "PURCHASED", signedDate: Date.now(), environment: "Xcode", storefront: "VNM", storefrontId: "143471",
});
const both = await call("syncEntitlement", { transactions: [bought, proTx], timeZone: "Asia/Ho_Chi_Minh" }, buyer.token);
check("Pro wins over a lifetime Premium", both.result?.tier === "pro" && typeof both.result?.expiresAt === "number", JSON.stringify(both.result ?? both.error));
check("sync gives Pro's own goal photos left this year", both.result?.goalPhotosLeft === LIMITS.goalPhotoYearlyLimitPro, JSON.stringify(both.result));
const back = await call("syncEntitlement", { transactions: [bought] }, buyer.token);
check("without Pro it's Premium again", back.result?.tier === "premium", JSON.stringify(back.result ?? back.error));
const buyerChat = await call("aiChat", ask, buyer.token);
check("a buyer can ask the coach", typeof buyerChat.result?.reply === "string", JSON.stringify(buyerChat.error ?? "").slice(0, 120));
check("appStoreNotifications refuses GET", (await notify(undefined, "GET")) === 405);
check("appStoreNotifications refuses an unsigned payload", (await notify({ signedPayload: "not.a.jws" })) === 400);
check("appStoreNotifications accepts a TEST notification", (await notify({ signedPayload: notification("TEST") })) === 200);
const refundSigned = Date.now();
const refundNote = notification("REFUND", lifetimeTx(txId, { revocationDate: Date.now(), revocationReason: 0 }), refundSigned);
const refunded = await notify({ signedPayload: refundNote });
check("appStoreNotifications takes a refund", refunded === 200, String(refunded));
const afterRefund = await call("aiChat", ask, buyer.token);
check("a refunded buyer loses Premium at once", afterRefund.error?.message === "premium-required", JSON.stringify(afterRefund.error ?? afterRefund.result).slice(0, 120));
const refundedPhoto = await call("goalPhoto", goalAsk, buyer.token);
check("a refunded buyer falls back to the account's free goal photo", refundedPhoto.result?.tier === "free" && refundedPhoto.result?.period === "once" && refundedPhoto.result?.remaining === 0, summary(refundedPhoto));
const replay = await call("syncEntitlement", { transactions: [bought] }, buyer.token);
check("the pre-refund transaction can't bring Premium back", replay.result?.premium === false, JSON.stringify(replay.result ?? replay.error));
check("sync tells the lapsed buyer the free goal photo is used", replay.result?.freeGoalPhotoUsed === true && replay.result?.goalPhotosLeft === null, JSON.stringify(replay.result));
await notify({ signedPayload: notification("REFUND_REVERSED", lifetimeTx(txId), refundSigned + 60_000) });
const reversed = await call("syncEntitlement", { transactions: [bought] }, buyer.token);
check("a reversed refund lets it count again", reversed.result?.premium === true, JSON.stringify(reversed.result ?? reversed.error));
// Apple retries failed deliveries for days: the old REFUND arriving again
// after the reversal must not take Premium away for good.
const late = await notify({ signedPayload: refundNote });
const afterLate = await call("syncEntitlement", { transactions: [bought] }, buyer.token);
check("a late retry of the refund doesn't undo the reversal", late === 200 && afterLate.result?.premium === true, JSON.stringify(afterLate.result ?? afterLate.error));

const deleted = await call("deleteAccount", { appleRevocation: "skipped" }, free.token);
check("deleteAccount removes the member", deleted.result?.deleted === true, JSON.stringify(deleted.result ?? deleted.error));
check("deleteAccount removes the account's free goal photo counter", (await getDoc(`usage/uid_${free.uid}/goalPhoto/once`)) === undefined);
const deletedBuyer = await call("deleteAccount", { appleRevocation: "failed" }, buyer.token);
check("deleteAccount goes ahead when Apple revocation failed", deletedBuyer.result?.deleted === true, JSON.stringify(deletedBuyer.result ?? deletedBuyer.error));
check("deleteAccount removes the Premium record", (await getDoc(`entitlements/${buyer.uid}`)) === undefined);

// Leave the emulator on the default limits for manual testing.
await deleteDoc("config/ai");

console.log(failures ? `\n${failures} failed` : "\nall passed");
process.exit(failures ? 1 : 0);
