//
//  AppGroup.swift
//  Shared (compiled into GymWorkout and MUSQWidgets)
//
//  The App Group both targets share: one UserDefaults suite for the Today
//  snapshot, the island style and actions the widget queued for the app.
//  The group "group.com.SamCorp.GymWorkout" must be enabled for both bundle
//  ids in the Apple Developer portal before a signed build can share it.
//

import Foundation

nonisolated enum AppGroup {
    static let id = "group.com.SamCorp.GymWorkout"

    /// The shared suite; falls back to the process's own defaults when the
    /// group is missing (unsigned lab builds), so nothing crashes.
    static var defaults: UserDefaults {
        UserDefaults(suiteName: id) ?? .standard
    }

    /// Keys in the shared suite. Keep them here so both targets agree.
    enum Key {
        static let islandStyle = "island.style"
        static let todaySnapshot = "today.snapshot"
        static let pendingActions = "pending.actions"
    }
}

/// Deep links into the app (scheme "musq" is registered in GymWorkout/Info.plist).
/// The app routes them in `.onOpenURL`.
nonisolated enum MUSQLink {
    static let scheme = "musq"
    static let today = URL(string: "musq://today")!
    static let train = URL(string: "musq://train")!
    static let workout = URL(string: "musq://workout")!
    static let quickLogFood = URL(string: "musq://quicklog/food")!
    static let quickLogWater = URL(string: "musq://quicklog/water")!
}
