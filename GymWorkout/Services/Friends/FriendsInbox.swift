//
//  FriendsInbox.swift
//  GymWorkout
//
//  Nudges from friends (2026-11-28). v1 has no remote push: the nudges a
//  friend sent wait on the server until this app syncs (open, foreground,
//  the Friends tab), and FriendsService hands the new ones here. Each then
//  shows once as an in-app banner (`banner`, queued) and as a local
//  notification, so it's in Notification Center too. Local notifications go
//  out only when MUSQ already may notify and "Friend nudges" is on in
//  Profile › Notifications; nothing here asks.
//
//  Identifiers start "friends.nudge.", which NudgeScheduler's re-plans
//  (prefix "nudge.") never remove. In the foreground NudgeNotificationDelegate
//  lists them quietly (only "nudge." ids get a system banner), so the in-app
//  banner is the one seen.
//

import Foundation
import Observation
import UserNotifications

@MainActor
@Observable
final class FriendsInbox {
    static let shared = FriendsInbox()
    static let idPrefix = "friends.nudge."
    /// Profile › Notifications › "Friend nudges" (on unless turned off).
    static let notifyKey = "friends.nudge.notify"
    static var notifies: Bool { UserDefaults.standard.object(forKey: notifyKey) as? Bool ?? true }

    /// The nudge to show as a banner now; the root view shows it and calls
    /// `dismissBanner()` when it's gone (tapped, swiped or timed out).
    private(set) var banner: FriendNudge?
    @ObservationIgnored private var queue: [FriendNudge] = []
    /// Ids already shown, so a nudge a retried sync sends again shows once.
    @ObservationIgnored private var seen: [String] = UserDefaults.standard.stringArray(forKey: FriendsInbox.seenKey) ?? []
    private static let seenKey = "friends.inbox.seen"

    private init() {}

    /// New nudges from a sync: a banner each (oldest first) and a local
    /// notification each when allowed.
    func deliver(_ nudges: [FriendNudge]) async {
        let fresh = nudges.filter { !seen.contains($0.id) }.sorted { $0.createdAt < $1.createdAt }
        guard !fresh.isEmpty else { return }
        seen.append(contentsOf: fresh.map(\.id))
        if seen.count > 200 { seen.removeFirst(seen.count - 200) }
        UserDefaults.standard.set(seen, forKey: Self.seenKey)

        queue.append(contentsOf: fresh)
        if banner == nil { banner = queue.isEmpty ? nil : queue.removeFirst() }

        // Only while "Friend nudges" is on (Profile › Notifications; its own
        // switch, apart from MUSQ's reminders) and iOS allows MUSQ to
        // notify. Off, the in-app banner still shows.
        guard Self.notifies, await NudgeScheduler.isAllowed() else { return }
        let center = UNUserNotificationCenter.current()
        for nudge in fresh {
            let content = UNMutableNotificationContent()
            content.title = "\(nudge.fromEmoji) \(nudge.fromName)"
            content.body = nudge.kind.message
            content.sound = .default
            content.threadIdentifier = "friends"
            content.userInfo = ["route": "friends", "friendId": nudge.fromId]
            // Delivered now (nil trigger).
            try? await center.add(UNNotificationRequest(identifier: Self.idPrefix + nudge.id, content: content, trigger: nil))
        }
    }

    /// The banner was shown: the next one, if any.
    func dismissBanner() {
        banner = queue.isEmpty ? nil : queue.removeFirst()
    }

    /// Clears the banners and the delivered notifications (signed out, the
    /// Friends tab opened).
    func clearDelivered() {
        queue = []
        banner = nil
        Task {
            let center = UNUserNotificationCenter.current()
            let ids = await center.deliveredNotifications().map(\.request.identifier)
                .filter { $0.hasPrefix(Self.idPrefix) }
            center.removeDeliveredNotifications(withIdentifiers: ids)
        }
    }

    #if DEBUG
    /// Shows a sample banner (`-friends.sample`), for screenshots.
    func showSample(_ nudge: FriendNudge) {
        banner = nudge
    }
    #endif
}
