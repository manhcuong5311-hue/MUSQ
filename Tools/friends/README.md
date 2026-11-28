# MUSQ Friends v1: store, review and deploy notes

Owner checklist for shipping Friends v1 (spec approved 2026-11-28). No remote push in v1.
Privacy policy: `~/Developer/musq-site/privacy.html` section 4 "Friends (optional)" was edited
locally on 2026-11-28 (sections after it renumbered 5–13). Not pushed: publish it with the app release.

## 1. App Store Connect: App Privacy label

App Store Connect › MUSQ › App Privacy › Edit. For every type below: **Linked to the user = Yes**,
**Used for tracking = No**, purpose **App Functionality** only.

| Category › Type | Already declared? | Change for Friends |
|---|---|---|
| Contact Info › Name | No | **Not added (checked in ASC 2026-11-28).** Apple's "Name" means first/last name; a user-chosen screen name is listed under Identifiers › User ID ("screen name, handle"), which the label already declares (App Functionality, linked). |
| Identifiers › **User ID** | Yes (AI account) | Keep. Now also Friends: account ID, friend code. |
| Health & Fitness › **Fitness** | Yes | Keep. Workout summaries (title, minutes, sets), PRs (exercise + kg), streak, weekly workout count, water-goal hit, meals-logged count, goal %. |
| User Content › **Other User Content** | Yes | Keep. Reactions, nudges (templated), reports, emoji avatar. |
| Health & Fitness › Health | Yes | No change. Apple Health data is NEVER sent by Friends. |
| Usage Data › Product Interaction | Yes | Keep (last-active time, nudge counts). |

Do NOT add: Contacts (no address-book access; friends are added by code), Photos (no profile photos),
Location, Messages (nudges are fixed templates, not user-written messages).
`GymWorkout/PrivacyInfo.xcprivacy` matches the label: User ID, Fitness and Other User Content were already there; no Name entry (see above).

## 2. App Review notes (paste into "Notes" for the version with Friends)

> **Friends (new, optional).** Profile › Friends. Needs Sign in with Apple; the rest of the app works without an account.
> **How to test with two accounts:** 1) Device A: sign in with Apple, create a Friends profile (name + emoji), tap Share code / copy the 6-character code. 2) Device B (or a second Apple Account): sign in, create a profile, Add friend › enter A's code › Send. 3) Device A: Friends › Requests › Accept. 4) On either device, finish a short workout (or log water to the goal), then open Friends: the item appears in the other person's feed; react with an emoji; open the weekly board; send a nudge (it appears on the other device next time the app is opened/foregrounded, as an in-app banner + local notification).
> If you can only use one account, use our demo friend code **<DEMO_CODE>** (a test account we keep active; it accepts requests automatically: <confirm with server agent or remove>).
> **Safety / moderation:** no free text between users. Display names are 1–24 chars, filtered for links, emails, phone numbers and a banned-word list (English + Vietnamese); avatars are a fixed list of emojis (no photos); nudges are 4 fixed templates and reactions 4 fixed emojis; max 1 nudge per friend per day. Users agree to the community rules (Terms of Use, "Friends: community rules", zero tolerance for objectionable content and abusive users) when they create a Friends profile. Users can mute, remove, **block** (removes + prevents future requests) and **report** (spam / abusive name / other) from a friend's page, and block or report straight from an incoming friend request (Report and Block buttons on the request). Declining a request stops that person from re-sending for 30 days. Every report alerts the developer, who acts on it within 24 hours (removes the name or the account). Contact: Manhcuong5311@gmail.com. Users can delete their account and all Friends data in Profile › Account › Delete account. No Apple Health data, weight, calories or photos are shared.

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
- **User-Generated Content**: answer **Yes** (display names, emoji reactions, templated nudges are visible to other users). Apple requires the moderation features above (filter, report, block, contact), which v1 has.
- **Messaging and Chat**: Friends has no free-text messaging (templated nudges only). If the form only offers Yes/No, answer conservatively per Apple's current wording; templated nudges are not chat. Keep the AI coach answer as it is now.
- Expect the rating to stay **13+** (set 11-23). Re-check that nothing else changed in the questionnaire.

## 4. Privacy policy

- Publish the edited `musq-site/privacy.html` (section 4 + cross-references, updated date "November 28, 2026") at the same time as the app release.
- Open points to confirm against the server implementation before publishing:
  - weekly workouts/streak shown only when Workouts sharing is ON (page says so);
  - report retention ("until reviewed") and what happens to reports ABOUT a deleted user (page: reason + date kept, account link removed);
  - Firestore TTL policies actually enabled (page says ~30 days events, ~7 days nudges).

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
6. Push the site with the release: `privacy.html`, `terms.html` (Friends community rules, `#friends`) and the new
   `404.html`, which turns an invite link `https://musq.app/f/<CODE>` into a page with the code and the App Store link
   (GitHub Pages serves it for any missing path).
