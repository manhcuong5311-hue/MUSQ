//
//  BalanceBuilder.swift
//  GymWorkout
//
//  Gathers what `BalanceScore` reads (2026-11-22) from the app's stores, so
//  Today, the Balance sheet and Progress all score the same week the same
//  way. Nothing here is saved: Apple Health's nights are passed straight
//  from `AppleHealth`'s memory into the score and dropped after.
//

import Foundation

enum BalanceBuilder {

    /// The inputs for `BalanceScore.current` and `.history`.
    ///
    /// - Water counts toward Eat as Today's water card does: not with a
    ///   heart or kidney condition (some limit fluids), unless the user set
    ///   their own target.
    /// - `keyLiftChange`: the key lifts' average change in estimated max
    ///   over Progress's 8-week window (0.05 = 5% stronger), nil without
    ///   key lifts. Used for the result chip on Recomp and Stay fit goals;
    ///   `keyLifts: false` skips that work where the chip isn't drawn.
    @MainActor
    static func inputs(store: WorkoutStore, daily: DailyStore, health: AppleHealth, plan: NutritionPlan?,
                       keyLifts: Bool = true, now: Date = Date()) -> BalanceInputs {
        let conditions = store.profile?.health
        let limitsFluids = conditions.map { $0.has(.heartDisease) || $0.has(.kidneyDisease) } ?? false
        return BalanceInputs(sessions: store.sessions,
                             profile: store.profile,
                             plan: plan,
                             experience: store.experience,
                             splitGroups: store.roundSplit,
                             daily: daily,
                             nights: health.nights,
                             sleepGoalMinutes: health.sleepGoalMinutes,
                             healthConnected: health.access == .asked,
                             healthAvailable: health.access != .unavailable,
                             waterCounts: !limitsFluids || daily.waterTargetOverride != nil,
                             settings: BalanceSettings.shared,
                             keyLiftChange: keyLifts ? keyLiftChange(store: store, now: now) : nil,
                             now: now)
    }

    /// What `BalanceScore.todayInvitation` reads, for the chips on the
    /// Balance card and sheet: the same inputs without the key-lift work.
    /// Nil where a preview leaves the stores out.
    @MainActor
    static func todayInputs(store: WorkoutStore?, daily: DailyStore?, health: AppleHealth?,
                            now: Date = Date()) -> BalanceInputs? {
        guard let store, let daily, let health else { return nil }
        return inputs(store: store, daily: daily, health: health,
                      plan: plan(store: store, health: health, now: now), keyLifts: false, now: now)
    }

    /// The average relative change of the key lifts' estimated max, first
    /// day against the latest inside the window; nil with none.
    @MainActor
    static func keyLiftChange(store: WorkoutStore, now: Date = Date()) -> Double? {
        let lifts = ProgressInsights(sessions: store.sessions, profile: store.profile, now: now).keyLifts()
        let changes: [Double] = lifts.compactMap { lift in
            guard let first = lift.points.first?.value, first > 0 else { return nil }
            return lift.change / first
        }
        guard !changes.isEmpty else { return nil }
        return changes.reduce(0, +) / Double(changes.count)
    }

    /// The plan Balance scores Eat against: the same one Today shows, with
    /// Apple Health's steps setting the daily activity when connected.
    @MainActor
    static func plan(store: WorkoutStore, health: AppleHealth, now: Date = Date()) -> NutritionPlan? {
        store.profile.flatMap { NutritionPlan(profile: $0, now: now, measured: health.measuredActivity) }
    }

    /// The goal the result chip and "Your weeks" follow: the plan's
    /// effective goal (a reached target switches to maintenance), else the
    /// profile's.
    @MainActor
    static func goal(store: WorkoutStore, plan: NutritionPlan?) -> FitnessGoal? {
        plan?.effectiveGoal ?? store.profile?.goal
    }
}
