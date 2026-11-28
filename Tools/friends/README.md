# MUSQ Friends v1: store, review and deploy notes

Owner checklist for shipping Friends v1 (spec approved 2026-11-28). No remote push in v1.
Privacy policy: `~/Developer/musq-site/privacy.html` section 4 "Friends (optional)" was edited
locally on 2026-11-28 (sections after it renumbered 5–13). Not pushed: publish it with the app release.

**Photo check-ins (added 2026-11-28 evening, Locket-like):** optional photo posts + captions + comments, visible
only to friends, moderated by OpenAI (omni-moderation-latest) before anyone sees them, ring 24 h, posts/comments
~30 days, real-time reads via Firestore listeners on per-user fan-out copies (`friendInbox/{uid}/posts/...`).
Privacy section 4 gained "Photo posts and comments" (`#friends-photos`); terms community rules gained "Photos and comments".
Everything in this file marked **[photos]** is new for that round.

## 1. App Store Connect: App Privacy label

App Store Connect › MUSQ › App Privacy › Edit. For every type below: **Linked to the user = Yes**,
**Used for tracking = No**, purpose **App Functionality** only.

| Category › Type | Already declared? | Change for Friends |
|---|---|---|
| Contact Info › Name | No | **Not added (checked in ASC 2026-11-28).** Apple's "Name" means first/last name; a user-chosen screen name is listed under Identifiers › User ID ("screen name, handle"), which the label already declares (App Functionality, linked). |
| Identifiers › **User ID** | Yes (AI account) | Keep. Now also Friends: account ID, friend code. |
| Health & Fitness › **Fitness** | Yes | Keep. Workout summaries (title, minutes, sets), PRs (exercise + kg), streak, weekly workout count, water-goal hit, meals-logged count, goal %. |
| User Content › **Photos or Videos** | **[photos]** Expected Yes (meal scan + goal photo; `PrivacyInfo.xcprivacy` declares it). **Owner: confirm in ASC.** | Keep; purpose App Functionality, linked, no tracking. Now also Friends photo posts (stored on the server ~30 days, shown to friends). If ASC does NOT list it yet, add it. |
| User Content › **Other User Content** | Yes | Keep. Reactions, nudges (templated), reports, emoji avatar; **[photos]** captions (≤120), workout tag, comments (≤300). |
| Health & Fitness › Health | Yes | No change. Apple Health data is NEVER sent by Friends. |
| Usage Data › Product Interaction | Yes | Keep (last-active time, nudge counts). |

Do NOT add: Contacts (no address-book access; friends are added by code), Location (photo metadata incl. GPS is
stripped on the phone by re-encoding), Messages: **[photos]** comments are public-to-the-post replies under a photo,
not private messages between users (Apple's "Emails or text messages" = in-app messages). If you read Apple's wording
differently, adding Other User Content already covers comments; do not add Messages unless DMs are built.
`GymWorkout/PrivacyInfo.xcprivacy` matches the label (checked 2026-11-28 [photos]): Photos or Videos, Other User Content,
User ID, Fitness all declared, linked, App Functionality, no tracking; no change needed; no Name entry (see above).

## 2. App Review notes (paste into "Notes" for the version with Friends)

> **Friends (new, optional).** Profile › Friends. Needs Sign in with Apple; the rest of the app works without an account.
> **How to test with two accounts:** 1) Device A: sign in with Apple, create a Friends profile (name + emoji), tap Share code / copy the 6-character code. 2) Device B (or a second Apple Account): sign in, create a profile, Add friend › enter A's code › Send. 3) Device A: Friends › Requests › Accept. 4) On either device, finish a short workout (or log water to the goal), then open Friends: the item appears in the other person's feed; react with an emoji; open the weekly board; send a nudge (it appears on the other device next time the app is opened/foregrounded, as an in-app banner + local notification).
> If you can only use one account, use our demo friend code **<DEMO_CODE>** (a test account we keep active; it accepts requests automatically: <confirm with server agent or remove>).
> **Photo check-ins [photos]:** Friends tab › big camera button › take or pick a photo › optional caption › Post. With the two accounts above (already friends): post on device A; it appears live (no refresh) at the top of B's Friends feed, and A's emoji gets a coloured ring for 24 h. On B, tap the post › react and write a comment; it appears live on A. On A, delete B's comment (poster can delete any comment), or report it. On B, tap ⋯ › Report post. Block from a friend's page hides that person's posts and comments.
> **Moderation of photos and text [photos]:** every photo, caption and comment is checked server-side by OpenAI's moderation model (omni-moderation-latest) BEFORE it is stored for or shown to anyone else; flagged content is rejected with an error and never posted. Photos are visible only to the poster's friends, never public; location/EXIF metadata is removed on the device. Limits: 10 photos and 100 comments per user per day. A post reported by 2 different users is hidden automatically until we review it; every report alerts the developer, who acts within 24 hours. Users agree to the photo/comment rules (no nudity, violence, harassment, people without consent, minors) in the Terms of Use community rules.
> **Safety / moderation (names, nudges):** apart from captions and comments (moderated as above), there is no free text between users. Display names are 1–24 chars, filtered for links, emails, phone numbers and a banned-word list (English + Vietnamese); avatars are a fixed list of emojis (no photos); nudges are 4 fixed templates and reactions 4 fixed emojis; max 1 nudge per friend per day. Users agree to the community rules (Terms of Use, "Friends: community rules", zero tolerance for objectionable content and abusive users) when they create a Friends profile. Users can mute, remove, **block** (removes + prevents future requests) and **report** (spam / abusive name / other) from a friend's page, and block or report straight from an incoming friend request (Report and Block buttons on the request). Declining a request stops that person from re-sending for 30 days. Every report alerts the developer, who acts on it within 24 hours (removes the name or the account). Contact: Manhcuong5311@gmail.com. Users can delete their account and all Friends data in Profile › Account › Delete account. No Apple Health data, weight or calories are shared; the AI goal photo and meal photos are never shared (only photos the user posts in Friends).

Fill in `<DEMO_CODE>` only if a reviewer demo account exists; otherwise delete that line.

### Report alert (owner, once, before release)

Every report writes `friendReports/{id}` and logs `friends report` (severity WARNING, fields `reportId`, `reason`;
no uid or name). Set an alert so a report never waits unseen (24-hour promise in the app, the terms and the review notes):

1. Google Cloud console (project musq-app) › Logging › Logs Explorer, query
   `resource.type="cloud_run_revision" AND jsonPayload.message="friends report"` (or `textPayload:"friends report"`),
   then **Create alert** (log-based alert), notification channel = your email (or the Firebase app on your phone),
   minimum interval 5 min.
2. To act: Firestore console › `friendReports` › the doc (`reportId`): `subject` = their uid, `subjectName`/`subjectEmoji`
   as reported. Remove an abusive name by editing `friendProfiles/{subject}.displayName`, or delete the account
   (Firebase Authentication + `deleteAccount` path), then set `status` to `"done"`.

## 3. Age rating questionnaire

App Store Connect › App Information › Age Rating › Edit:
- **User-Generated Content**: answer **Yes** (display names, emoji reactions, templated nudges, **[photos]** photos, captions and comments are visible to other users). Apple requires the moderation features above (filter, report, block, contact), which v1 + photos have (automated moderation of every photo/caption/comment, report post/comment, block, 24 h review).
- **Messaging and Chat**: **[photos]** comments are free text but only under a friend's photo, friends-only, moderated; there are no private messages. If the questionnaire's wording covers "users can communicate" broadly, answer Yes (conservative; it doesn't change 13+ by itself in current ASC rules, re-check). Before photos: templated nudges only. If the form only offers Yes/No, answer conservatively per Apple's current wording; templated nudges are not chat. Keep the AI coach answer as it is now.
- Expect the rating to stay **13+** (set 11-23). Re-check that nothing else changed in the questionnaire.

## 4. Privacy policy

- Publish the edited `musq-site/privacy.html` (section 4 + cross-references, updated date "November 28, 2026") at the same time as the app release.
- Open points to confirm against the server implementation before publishing:
  - weekly workouts/streak shown only when Workouts sharing is ON (page says so);
  - report retention ("until reviewed") and what happens to reports ABOUT a deleted user (page: reason + date kept, account link removed);
  - Firestore TTL policies actually enabled (page says ~30 days events, ~7 days nudges).
  - **[photos]** confirm against `friendsPhotos` server code before publishing:
    - posts, reactions and comments expire ~30 days (TTL on the inbox copies AND the canonical docs) and the Storage object is deleted with them (TTL does not delete Storage files: `friendsPhotoSweep` deletes expired posts with their files, and any `friendPhotos/` file older than 31 days);
    - who sees a post = poster + their friends *while it is up* (page wording); unfriend/block removes copies both ways;
    - block hides the blocked person's comments also on posts of shared friends (page says so); if the server can't, soften the page;
    - moderation call sends no uid/email (page: "without your name or email"); if a hashed `user` field is sent, that's fine (no name/email) but keep it hashed;
    - post hidden after reports by 2+ different users (page says "people", spec says friends: same thing in practice);
    - daily post/comment counters expire after a few days (page says so);
    - **Storage location**: page says Firestore = Singapore and photos = "Google Cloud Storage" (no region). If the bucket is created in asia-southeast1, you may change the sentence to "both in Google's Singapore region".
  - **[photos]** `NSCameraUsageDescription` (project.pbxproj, owned by the iOS agent) still says meal + goal photo only; add "or take a photo to share with your friends" (+ Vietnamese in InfoPlist strings if localized). Photo picker (PHPicker) needs no library permission.

## 5. Deploy steps (placeholder: the server agent's report fills in exact commands)

1. Firestore rules: unchanged (deny all client access). `firebase deploy --only firestore:rules` only if the file changed.
2. Indexes: `firebase deploy --only firestore:indexes` if `firestore.indexes.json` changed. <server agent: list>
3. Functions (asia-southeast1): `firebase deploy --only functions:friendsProfileSet,functions:friendsSync,functions:friendsRequest,functions:friendsRespond,functions:friendsRemove,functions:friendsBlock,functions:friendsReport,functions:friendsMute,functions:friendsPost,functions:friendsFeed,functions:friendsReact,functions:friendsNudge` plus the updated account-deletion function. <server agent: confirm names>
4. TTL policies (Google Cloud console › Firestore › Time-to-live, or gcloud):
   `gcloud firestore fields ttls update expireAt --collection-group=friendEvents --enable-ttl --project=musq-app`
   `gcloud firestore fields ttls update expireAt --collection-group=nudges --enable-ttl --project=musq-app`
   `gcloud firestore fields ttls update expireAt --collection-group=friendRequests --enable-ttl --project=musq-app`
   `gcloud firestore fields ttls update expireAt --collection-group=friendDeclines --enable-ttl --project=musq-app`
   `gcloud firestore fields ttls update expireAt --collection-group=nudgeCounters --enable-ttl --project=musq-app`
   `gcloud firestore fields ttls update expireAt --collection-group=requestCounters --enable-ttl --project=musq-app`
   <server agent: confirm collection names>
5. Smoke test with two accounts (section 2 steps), then Delete account on one and check that its profile, code, friendships, requests, events, reactions and nudges are gone.
   **[photos]** also: its posts gone from every friend's `friendInbox/*/posts`, its `friendPhotos/*.jpg` objects gone, its comments gone from friends' posts (and `commentCount` lowered), its reactions and reports gone.

### [photos] Extra console / deploy steps (placeholders: the server agent fills in exact names)

1. **Cloud Storage**: Firebase console › musq-app › Storage › Get started (Blaze plan already on). Pick location **asia-southeast1** to match Firestore (it can't be changed later). Then add `"storage": { "rules": "storage.rules" }` to `firebase.json` if the server agent hasn't, and `firebase deploy --only storage`. <server agent: signed URLs or rules with `firestore.exists(friendInbox/{uid}/posts/{postId})`?>
2. **Firestore rules**: now allow READ of `friendInbox/{uid}/posts/**` only when `request.auth.uid == uid`; deny all else. `firebase deploy --only firestore:rules`.
3. **Indexes**: `firebase deploy --only firestore:indexes` if changed. <server agent: list>
4. **Functions**: `firebase deploy --only functions:friendsPhotoPost,functions:friendsPhotoDelete,functions:friendsPhotoReact,functions:friendsCommentAdd,functions:friendsCommentDelete,functions:friendsPhotoReport,functions:friendsPhotoSweep` + redeploy `friendsRemove`, `friendsBlock`, `deleteAccount` (fan-out cleanup). Needs the `OPENAI_API_KEY` secret (already set). `friendsPhotoSweep` is a scheduled function (every 10 minutes): the first deploy turns on Cloud Scheduler for the project (say yes if the CLI asks). It finishes unfriend/block/account cleanups a call couldn't finish in time (`photoCleanups` jobs) and deletes posts past 30 days with their photo files.
5. **TTL**: `gcloud firestore fields ttls update expireAt --collection-group=posts --enable-ttl --project=musq-app` and the same for `comments` and the photo counters. <server agent: confirm collection-group names; `posts` must not clash with another collection group>
6. **Storage cleanup**: done in code by `friendsPhotoSweep` (expired posts via deletePost, plus any `friendPhotos/` file older than 31 days). An Object Lifecycle rule (Cloud Storage › bucket › Lifecycle › Delete object, prefix `friendPhotos/`, age 32 days) is an optional second backstop, not required.
7. **Report alert**: the existing log-based alert should also match photo/comment reports. <server agent: log message name, e.g. `friends report` with `type`>
6. Push the site with the release: `privacy.html`, `terms.html` (Friends community rules, `#friends`) and the new
   `404.html`, which turns an invite link `https://musq.app/f/<CODE>` into a page with the code and the App Store link
   (GitHub Pages serves it for any missing path).
