import { test } from "node:test";
import assert from "node:assert/strict";
import { HttpsError } from "firebase-functions/v2/https";
import {
  COMMENT_MAX, CAPTION_MAX, counted, counterAfter, graphemes, newId, photoPath, readCaption, readComment, readPhoto, readPhotoReportReason, readTag,
  stripJpegMetadata,
} from "../friendsPhotosRules.js";
import { fakeJpeg } from "./jpegFixture.js";

const code = (fn: () => unknown) => {
  try { fn(); } catch (e) { return e instanceof HttpsError ? `${e.code}:${e.message}` : String(e); }
  return "ok";
};

test("stripJpegMetadata drops EXIF/GPS, MPF, IPTC, comments and appended data, keeps JFIF, ICC and the image", () => {
  const raw = fakeJpeg();
  const out = stripJpegMetadata(raw)!;
  const s = out.toString("latin1");
  for (const gone of ["Exif", "GPS", "MPF", "IPTC", "a comment", "APPENDED"]) assert.ok(!s.includes(gone), gone);
  for (const kept of ["JFIF", "ICC_PROFILE"]) assert.ok(s.includes(kept), kept);
  assert.deepEqual([...out.subarray(-2)], [0xff, 0xd9]);
  // Without metadata nothing changes; stripping twice is stable.
  const clean = fakeJpeg(1080, 1440, false);
  assert.ok(stripJpegMetadata(clean)!.equals(clean));
  assert.ok(stripJpegMetadata(out)!.equals(out));
  assert.equal(stripJpegMetadata(Buffer.from("not a jpeg at all")), undefined);
  assert.equal(stripJpegMetadata(raw.subarray(0, 30)), undefined);
});

test("readPhoto: JPEG only, size limits, returns the stripped bytes and dimensions", () => {
  const photo = readPhoto(fakeJpeg(1080, 1350).toString("base64"));
  assert.equal(photo.width, 1080);
  assert.equal(photo.height, 1350);
  assert.ok(!photo.jpeg.toString("latin1").includes("GPS"));
  assert.ok(readPhoto(`data:image/jpeg;base64,${fakeJpeg().toString("base64")}`).jpeg.length > 0);
  assert.equal(code(() => readPhoto(undefined)), "invalid-argument:image missing");
  const png = Buffer.concat([Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]), Buffer.alloc(200)]);
  assert.equal(code(() => readPhoto(png.toString("base64"))), "invalid-argument:image must be JPEG");
  assert.equal(code(() => readPhoto(fakeJpeg(5000, 100).toString("base64"))), "invalid-argument:image size invalid");
  assert.equal(code(() => readPhoto(fakeJpeg(32, 32).toString("base64"))), "invalid-argument:image size invalid");
  assert.equal(code(() => readPhoto(Buffer.alloc(1_600_000, 0xff).toString("base64"))), "invalid-argument:image too large");
});

test("captions, tags and comments", () => {
  assert.equal(readCaption(undefined), null);
  assert.equal(readCaption("   "), null);
  assert.equal(readCaption("  Leg   day​ done \n\n\n\n  🔥 "), "Leg day done\n\n🔥");
  assert.equal(readCaption("x".repeat(CAPTION_MAX))?.length, CAPTION_MAX);
  assert.equal(code(() => readCaption("x".repeat(CAPTION_MAX + 1))), "invalid-argument:caption too long");
  assert.equal(code(() => readCaption("dm me on www.spam.com")), "failed-precondition:friends-text-not-allowed");
  assert.equal(code(() => readCaption(42)), "invalid-argument:caption invalid");
  assert.equal(readTag("Chest day · 25 min"), "Chest day · 25 min");
  assert.equal(readTag("fuck day"), null);
  assert.equal(readTag(7), null);
  assert.equal(readTag("y".repeat(200))!.length, 60);
  assert.equal(readComment(" Nice  form! "), "Nice form!");
  assert.equal(code(() => readComment("")), "invalid-argument:text missing");
  assert.equal(code(() => readComment("z".repeat(COMMENT_MAX + 1))), "invalid-argument:text too long");
  assert.equal(code(() => readComment("call 0901234567")), "failed-precondition:friends-text-not-allowed");
});

test("text counts grapheme clusters, as the app does, and keeps emoji joiners", () => {
  // 💪🏽 is 2 code points, 🇻🇳 is 2, 👨‍👩‍👧 is 5: each one character.
  assert.equal(graphemes("💪🏽🇻🇳👨‍👩‍👧").length, 3);
  assert.equal(readCaption("💪🏽".repeat(CAPTION_MAX)), "💪🏽".repeat(CAPTION_MAX));
  assert.equal(code(() => readCaption("💪🏽".repeat(CAPTION_MAX + 1))), "invalid-argument:caption too long");
  assert.equal(readComment("👨‍👩‍👧‍👦".repeat(COMMENT_MAX)).length, "👨‍👩‍👧‍👦".length * COMMENT_MAX);
  // Joiners inside emoji stay; a stray one (splitting a word) goes.
  assert.equal(readCaption("Leg day 🏋️‍♂️❤️‍🔥 🧑🏽‍💻 🏳️‍🌈"), "Leg day 🏋️‍♂️❤️‍🔥 🧑🏽‍💻 🏳️‍🌈");
  assert.equal(readCaption("go\u200Dod\u200B job\u202E"), "good job");
  assert.equal(code(() => readComment("f\u200Duck")), "failed-precondition:friends-text-not-allowed");
  assert.equal(readTag("Chest · 💪🏽".padEnd(80, "x"))!.length <= 61 + 2, true);
  assert.equal(graphemes(readTag("💪🏽".repeat(100))!).length, 60);
});

test("report reasons, ids, paths and daily counters", () => {
  assert.equal(readPhotoReportReason("inappropriate"), "inappropriate");
  assert.equal(code(() => readPhotoReportReason("meh")), "invalid-argument:reason invalid");
  const id = newId();
  assert.match(id, /^[0-9a-f]{32}$/);
  assert.notEqual(newId(), id);
  assert.equal(photoPath(id), `friendPhotos/${id}.jpg`);
  assert.equal(counted(undefined, "posts", "2026-11-28"), 0);
  assert.equal(counted({ day: "2026-11-27", posts: 9 }, "posts", "2026-11-28"), 0);
  assert.equal(counted({ day: "2026-11-28", posts: 9, comments: 3 }, "comments", "2026-11-28"), 3);
  assert.deepEqual(counterAfter({ day: "2026-11-28", posts: 2, comments: 3 }, "reactions", "2026-11-28"),
    { day: "2026-11-28", posts: 2, comments: 3, reactions: 1 });
  assert.deepEqual(counterAfter({ day: "2026-11-27", posts: 2, reactions: 300 }, "posts", "2026-11-28"),
    { day: "2026-11-28", posts: 1, comments: 0, reactions: 0 });
});
