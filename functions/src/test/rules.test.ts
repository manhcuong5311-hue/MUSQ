/**
 * firestore.rules and storage.rules with @firebase/rules-unit-testing: the
 * app may read only its own friendInbox (posts and their comments) and a
 * photo only while its inbox holds that post; nothing else, and no writes.
 * Skipped unless both emulators run; run with
 *   firebase emulators:exec --project demo-musq --only firestore,storage "node --test lib/test/rules.test.js"
 */
import { test, before, after } from "node:test";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import {
  assertFails, assertSucceeds, initializeTestEnvironment, type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { collection, deleteDoc, doc, getDoc, getDocs, setDoc, updateDoc } from "firebase/firestore";
import { getBytes, ref, uploadBytes, deleteObject } from "firebase/storage";

const FS = process.env.FIRESTORE_EMULATOR_HOST;
const ST = process.env.FIREBASE_STORAGE_EMULATOR_HOST;
const ON = !!FS && !!ST;
const ROOT = resolve(__dirname, "../../..");
const POST = "0123456789abcdef0123456789abcdef";
const OTHER = "fedcba9876543210fedcba9876543210";
let env: RulesTestEnvironment;

const hostPort = (v: string) => { const [host, port] = v.replace(/^https?:\/\//, "").split(":"); return { host, port: Number(port) }; };

before(async () => {
  if (!ON) return;
  env = await initializeTestEnvironment({
    projectId: "demo-musq",
    firestore: { rules: readFileSync(resolve(ROOT, "firestore.rules"), "utf8"), ...hostPort(FS!) },
    storage: { rules: readFileSync(resolve(ROOT, "storage.rules"), "utf8"), ...hostPort(ST!) },
  });
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, `friendInbox/alice/posts/${POST}`), { id: POST, authorId: "me", isMine: true });
    await setDoc(doc(db, `friendInbox/alice/posts/${POST}/comments/c1`), { text: "hi" });
    await setDoc(doc(db, `friendInbox/bob/posts/${OTHER}`), { id: OTHER });
    await setDoc(doc(db, `friendPhotos/${POST}`), { uid: "alice" });
    await setDoc(doc(db, "friendProfiles/alice"), { displayName: "A" });
    const storage = ctx.storage();
    await uploadBytes(ref(storage, `friendPhotos/${POST}.jpg`), new Uint8Array([0xff, 0xd8, 0xff, 0xd9]), { contentType: "image/jpeg" });
    await uploadBytes(ref(storage, `friendPhotos/${OTHER}.jpg`), new Uint8Array([0xff, 0xd8, 0xff, 0xd9]), { contentType: "image/jpeg" });
    await uploadBytes(ref(storage, "other/file.jpg"), new Uint8Array([1]));
  });
});

after(async () => { if (ON) await env.cleanup(); });

test("Firestore: a member reads only their own inbox posts and comments", { skip: !ON }, async () => {
  const alice = env.authenticatedContext("alice").firestore();
  await assertSucceeds(getDoc(doc(alice, `friendInbox/alice/posts/${POST}`)));
  await assertSucceeds(getDocs(collection(alice, "friendInbox/alice/posts")));
  await assertSucceeds(getDoc(doc(alice, `friendInbox/alice/posts/${POST}/comments/c1`)));
  await assertSucceeds(getDocs(collection(alice, `friendInbox/alice/posts/${POST}/comments`)));
  // Someone else's inbox, the server's own collections, unauthenticated.
  await assertFails(getDoc(doc(alice, `friendInbox/bob/posts/${OTHER}`)));
  await assertFails(getDocs(collection(alice, "friendInbox/bob/posts")));
  await assertFails(getDoc(doc(alice, `friendPhotos/${POST}`)));
  await assertFails(getDoc(doc(alice, "friendProfiles/alice")));
  await assertFails(getDoc(doc(alice, "friendInbox/alice")));
  const anon = env.unauthenticatedContext().firestore();
  await assertFails(getDoc(doc(anon, `friendInbox/alice/posts/${POST}`)));
});

test("Firestore: no client writes, even to their own inbox", { skip: !ON }, async () => {
  const alice = env.authenticatedContext("alice").firestore();
  await assertFails(setDoc(doc(alice, "friendInbox/alice/posts/new"), { id: "new" }));
  await assertFails(updateDoc(doc(alice, `friendInbox/alice/posts/${POST}`), { commentCount: 99 }));
  await assertFails(deleteDoc(doc(alice, `friendInbox/alice/posts/${POST}`)));
  await assertFails(setDoc(doc(alice, `friendInbox/alice/posts/${POST}/comments/c2`), { text: "x" }));
  await assertFails(setDoc(doc(alice, "friendInbox/bob/posts/x"), { id: "x" }));
  await assertFails(setDoc(doc(alice, "friendProfiles/alice"), { displayName: "B" }));
});

test("Storage: a photo is readable only while the reader's inbox holds the post", { skip: !ON }, async () => {
  const alice = env.authenticatedContext("alice").storage();
  const bob = env.authenticatedContext("bob").storage();
  await assertSucceeds(getBytes(ref(alice, `friendPhotos/${POST}.jpg`)));
  await assertFails(getBytes(ref(bob, `friendPhotos/${POST}.jpg`)));
  await assertSucceeds(getBytes(ref(bob, `friendPhotos/${OTHER}.jpg`)));
  await assertFails(getBytes(ref(alice, `friendPhotos/${OTHER}.jpg`)));
  await assertFails(getBytes(ref(env.unauthenticatedContext().storage(), `friendPhotos/${POST}.jpg`)));
  await assertFails(getBytes(ref(alice, "other/file.jpg")));
  // No uploads, overwrites or deletes.
  await assertFails(uploadBytes(ref(alice, `friendPhotos/${POST}.jpg`), new Uint8Array([1])));
  await assertFails(uploadBytes(ref(alice, "friendPhotos/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.jpg"), new Uint8Array([1])));
  await assertFails(deleteObject(ref(alice, `friendPhotos/${POST}.jpg`)));
  // The inbox copy goes (unfriend, block, report, delete): access ends.
  await env.withSecurityRulesDisabled(async (ctx) => { await deleteDoc(doc(ctx.firestore(), `friendInbox/alice/posts/${POST}`)); });
  await assertFails(getBytes(ref(alice, `friendPhotos/${POST}.jpg`)));
});
