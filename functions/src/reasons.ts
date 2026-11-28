/** Error messages the app maps to its own errors (AIServiceError). */
export const Reason = {
  signIn: "sign-in-required",
  premium: "premium-required",
  appCheck: "app-check-required",
  limit: "limit-reached",
  off: "feature-off",
  notAllowed: "photo-not-allowed",
  age: "age-required",
  ai: "ai-unavailable",
  /** A goal photo redo whose free tries are used, expired or for another
   *  photo or look (redo.ts). Nothing was counted. */
  redo: "redo-unavailable",
  // MUSQ Friends (friends.ts). The HttpsError code is in brackets.
  /** No friends profile yet: call friendsProfileSet first (failed-precondition). */
  friendProfile: "friends-profile-required",
  /** No such code, request, friend or feed item; also what a block looks
   *  like from either side, so a block never shows (not-found). */
  friendNotFound: "friends-not-found",
  /** 50 friends, or 20 pending outgoing requests (resource-exhausted). */
  friendLimit: "friends-limit",
  /** Your own code (invalid-argument). */
  friendSelf: "friends-self",
  /** The display name is empty, too long or not allowed (invalid-argument). */
  friendName: "friends-name-invalid",
  /** Already nudged this friend today (resource-exhausted). */
  nudgedToday: "friends-nudged-today",
  /** 20 nudges sent today (resource-exhausted). */
  nudgeLimit: "friends-nudge-limit",
  /** 30 friend-code lookups today, found or not (resource-exhausted): codes
   *  can't be guessed by trying them all. */
  friendTries: "friends-tries-limit",
  // Photo check-ins (friendsPhotos.ts).
  /** The photo didn't pass moderation (failed-precondition). */
  friendPhotoRejected: "friends-photo-not-allowed",
  /** A caption or comment with a link, contact details, a banned word, or
   *  that didn't pass moderation (failed-precondition). */
  friendTextRejected: "friends-text-not-allowed",
  /** 10 photos posted today (resource-exhausted). */
  photoLimit: "friends-photo-limit",
  /** 100 comments today (resource-exhausted). */
  commentLimit: "friends-comment-limit",
  /** 300 reaction changes today (resource-exhausted). */
  reactionLimit: "friends-reaction-limit",
} as const;
