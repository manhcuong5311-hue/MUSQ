//
//  AppStores.swift
//  GymWorkout
//
//  The app's live stores, made once outside the view tree (2026-11-28).
//  RootView takes them from here; so can a Live Activity or widget button
//  that launches the app in the background, where no scene (and so no
//  RootView) is ever created — without this, "Done set" on the Lock Screen
//  of a terminated app did nothing.
//

import Foundation

final class AppStores {
    static let shared = AppStores()

    let store: WorkoutStore
    let restTimer: RestTimer
    let daily: DailyStore
    let health: AppleHealth

    private init() {
        let store = WorkoutStore()
        let restTimer = RestTimer()
        // Steps inside logged sessions are left out of the plan's activity.
        let health = AppleHealth()
        health.sessionWindows = {
            store.sessions.compactMap { session in
                let times = session.exercises.flatMap(\.completedSets).compactMap(\.completedAt)
                guard let first = times.min(), let last = times.max() else { return nil }
                return DateInterval(start: first.addingTimeInterval(-120), end: last)
            }
        }
        let daily = DailyStore()
        daily.profileWaterTarget = DailyStore.waterTarget(for: store.profile)
        // Walks added by hand count with Health's steps.
        health.manualSteps = { daily.manualStepsByDay }
        self.store = store
        self.restTimer = restTimer
        self.daily = daily
        self.health = health

        // Nudges plan from the live stores rather than the saved files.
        NudgeScheduler.shared.attach(store: store, daily: daily)
        // Friends posts its activity summaries from the same live stores.
        FriendsActivity.shared.attach(store: store, daily: daily)
        // Dynamic Island, Lock Screen and widgets follow the same live stores
        // (LiveActivityManager); their buttons act on them (LiveActivityHandler).
        LiveActivityHandler.shared.attach(store: store, daily: daily, restTimer: restTimer)
        LiveActivityManager.shared.attach(store: store, daily: daily, restTimer: restTimer, health: health)
    }
}
