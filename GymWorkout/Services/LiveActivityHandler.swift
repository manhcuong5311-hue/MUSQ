//
//  LiveActivityHandler.swift
//  GymWorkout
//
//  The buttons on the Live Activities and widgets, run in the app's process
//  (LiveActivityIntent / AppIntent in Shared/LiveActivityIntents.swift call
//  `LiveActivityActions.handler`, set in GymWorkoutApp.init). Each action goes
//  through the stores' existing APIs — the same calls the Train list and
//  Today make — then pushes the result to the activity at once.
//
//  `DeepLinkRouter` carries musq:// links (widget taps, "Log meal") to the
//  root view, like NudgeRouter does for notifications.
//

import Foundation
import Observation

// MARK: - Deep links

/// The one musq:// link waiting to be shown. RootView observes `pending`.
@Observable
final class DeepLinkRouter {
    static let shared = DeepLinkRouter()

    var pending: URL?

    func open(_ url: URL) {
        guard url.scheme == MUSQLink.scheme else { return }
        pending = url
    }

    func consume() -> URL? {
        defer { pending = nil }
        return pending
    }

    /// Where a link goes.
    enum Destination: Equatable {
        case today, train, quickLogFood, quickLogWater
    }

    static func destination(of url: URL) -> Destination? {
        guard url.scheme == MUSQLink.scheme else { return nil }
        switch url.host() {
        case "today": return .today
        case "train", "workout": return .train
        case "quicklog":
            return url.pathComponents.contains("water") ? .quickLogWater : .quickLogFood
        default: return nil
        }
    }
}

// MARK: - Actions

final class LiveActivityHandler: LiveActivityActionHandling {
    static let shared = LiveActivityHandler()

    private weak var store: WorkoutStore?
    private weak var daily: DailyStore?
    private weak var restTimer: RestTimer?

    func attach(store: WorkoutStore, daily: DailyStore, restTimer: RestTimer) {
        self.store = store
        self.daily = daily
        self.restTimer = restTimer
    }

    /// An intent can wake the app in the background, where no scene (and
    /// so no RootView) is made: the shared stores are built here then, and
    /// attach themselves to this handler and the manager.
    private func ready() async -> Bool {
        if store == nil || daily == nil || restTimer == nil { _ = AppStores.shared }
        return store != nil && daily != nil && restTimer != nil
    }

    /// Done set: the next open set of the exercise being worked, ticked the
    /// way the list's Done set bar does (placeholder weight, rest, the
    /// exercise completed after its last set).
    func doneSet() async {
        guard await ready(), let store, let restTimer,
              let session = LiveActivityManager.shared.liveSession(),
              let exercise = LiveActivityManager.currentExercise(in: session),
              let open = SetLogging.nextOpenSet(of: exercise) else { return }
        store.toggleSet(exerciseID: exercise.id, setID: open.set.id)
        SetLogging.afterToggle(exerciseID: exercise.id, setID: open.set.id, store: store, restTimer: restTimer)
        await LiveActivityManager.shared.syncNow()
    }

    func adjustRest(seconds: Int) async {
        guard await ready(), let restTimer, restTimer.isRunning else { return }
        restTimer.add(seconds)
        await LiveActivityManager.shared.syncNow()
    }

    func skipRest() async {
        guard await ready(), let restTimer else { return }
        restTimer.skip()
        await LiveActivityManager.shared.syncNow()
    }

    func addWater(ml: Int) async {
        guard await ready(), let daily else {
            PendingActions.enqueue(.addWater(ml: ml, at: Date()))
            return
        }
        daily.addWater(max(1, ml))
        await LiveActivityManager.shared.syncNow()
    }

    func open(_ url: URL) async {
        DeepLinkRouter.shared.open(url)
    }
}
