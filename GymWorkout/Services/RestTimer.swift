//
//  RestTimer.swift
//  GymWorkout
//
//  The rest between sets. Starts when a set is marked done, counts down on
//  whichever screen is open, and ends with a haptic — or, with the app in the
//  background, a notification. One timer for the whole app: a new set
//  restarts it.
//

import Foundation
import Observation
import UIKit
import UserNotifications

@Observable
final class RestTimer {

    /// When the running rest ends; nil when no rest is running.
    private(set) var endsAt: Date?
    /// Length of the running rest, including any time added.
    private(set) var duration: TimeInterval = 0
    /// Set for a few seconds after a rest runs out, so the bar can say so.
    private(set) var finishedAt: Date?

    @ObservationIgnored private var waiter: Task<Void, Never>?
    @ObservationIgnored private var askedForNotifications = false

    private static let notificationID = "rest-timer"
    private static let finishedNoteSeconds: Double = 4

    var isRunning: Bool { endsAt != nil }
    var isVisible: Bool { endsAt != nil || finishedAt != nil }

    func start(seconds: Int) {
        requestNotificationsOnce()
        duration = TimeInterval(seconds)
        endsAt = Date().addingTimeInterval(duration)
        finishedAt = nil
        schedule()
    }

    /// Adds (or with a negative value, takes off) time from the running rest.
    func add(_ seconds: Int) {
        guard let endsAt else { return }
        let end = endsAt.addingTimeInterval(TimeInterval(seconds))
        guard end > Date() else { finish(); return }
        self.endsAt = end
        duration = max(1, duration + TimeInterval(seconds))
        schedule()
    }

    func skip() {
        waiter?.cancel()
        removeNotification()
        endsAt = nil
        finishedAt = nil
    }

    // MARK: - Ending

    private func schedule() {
        waiter?.cancel()
        guard let endsAt else { return }
        waiter = Task { [weak self] in
            try? await Task.sleep(for: .seconds(max(0, endsAt.timeIntervalSinceNow)))
            guard !Task.isCancelled else { return }
            self?.finish()
        }
        notify(at: endsAt)
    }

    private func finish() {
        endsAt = nil
        finishedAt = Date()
        removeNotification()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        waiter = Task { [weak self] in
            try? await Task.sleep(for: .seconds(Self.finishedNoteSeconds))
            guard !Task.isCancelled else { return }
            self?.finishedAt = nil
        }
    }

    // MARK: - Notification

    /// Asked the first time a rest starts, when the reason is obvious.
    private func requestNotificationsOnce() {
        guard !askedForNotifications else { return }
        askedForNotifications = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    /// Only shown while the app is in the background; in the foreground the
    /// bar and the haptic carry it.
    private func notify(at date: Date) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Self.notificationID])
        let interval = date.timeIntervalSinceNow
        guard interval >= 1 else { return }
        let content = UNMutableNotificationContent()
        content.title = "Rest over"
        content.body = "Time for your next set."
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        center.add(UNNotificationRequest(identifier: Self.notificationID, content: content, trigger: trigger))
    }

    private func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Self.notificationID])
    }
}
