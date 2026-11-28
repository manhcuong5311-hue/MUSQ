//
//  ActivityAttributes.swift
//  Shared
//
//  The two Live Activities. The app starts/updates/ends them (ActivityKit);
//  MUSQWidgets draws them (ActivityConfiguration). Only one should be up at a
//  time: a running workout ends/hides the Today activity.
//

import Foundation
#if canImport(ActivityKit)
import ActivityKit
#endif

// MARK: - Workout

nonisolated struct WorkoutActivityAttributes: Sendable {
    /// "Push day", "Legs"… fixed for the activity's life.
    var workoutName: String
    /// When the first set was marked done (or Start was tapped).
    var startedAt: Date
    /// Start of the day the session belongs to (WorkoutStore session key).
    var day: Date

    nonisolated struct ContentState: Codable, Hashable, Sendable {
        var exerciseName: String
        /// Display name of the muscle group, e.g. "Chest".
        var muscleGroup: String
        /// 1-based position of the current exercise, and how many there are.
        var exerciseIndex: Int
        var exerciseCount: Int
        /// Set number within the current exercise (1-based, the next one to do)
        /// and the exercise's set count.
        var setNumber: Int
        var setsInExercise: Int
        /// Whole workout: sets done / total sets ("4/9").
        var setsDone: Int
        var setsTotal: Int
        /// Next set target; nil weight = bodyweight, holdSeconds for timed holds.
        var nextWeightKg: Double?
        var nextReps: Int?
        var nextHoldSeconds: Int?
        /// "kg" or "lb" — the app formats weights in the user's unit.
        var weightUnit: String
        /// Ready-made "60 kg × 8" (app formats it; views fall back to raw fields).
        var nextTargetText: String?
        /// Running rest: start and end, for Text(timerInterval:) and
        /// ProgressView(timerInterval:). nil when not resting.
        var restStartedAt: Date?
        var restEndsAt: Date?
        /// Complete Workout was tapped: the final state shown before dismissal.
        var isFinished: Bool
        /// The look, stamped by the app when it builds the state. The views
        /// prefer it over the App Group setting, so a style change reaches the
        /// activity with its next update, and unsigned lab builds (no shared
        /// App Group) still draw the picked style.
        var style: IslandStyle? = IslandStyle.current
        /// Every set is ticked but Complete Workout wasn't tapped: there is
        /// no next set, the views ask to finish in the app.
        var allSetsDone: Bool? = nil

        /// No next set left to do (and not finished yet).
        var isAllDone: Bool {
            !isFinished && (allSetsDone == true || (setsTotal > 0 && setsDone >= setsTotal))
        }
        var isResting: Bool { restEndsAt.map { $0 > Date() } ?? false }
        var setsProgress: Double { setsTotal > 0 ? min(1, Double(setsDone) / Double(setsTotal)) : 0 }
        var restInterval: ClosedRange<Date>? {
            guard let start = restStartedAt, let end = restEndsAt, end > start else { return nil }
            return start...end
        }
    }
}

// MARK: - Today

nonisolated struct TodayActivityAttributes: Sendable {
    /// Start of the local day this activity covers (ended at midnight).
    var day: Date

    nonisolated struct ContentState: Codable, Hashable, Sendable {
        var waterML: Int
        var waterTargetML: Int
        var kcalEaten: Int
        var kcalTarget: Int
        var mealsCount: Int
        var isTrainingDay: Bool
        var trainedToday: Bool
        var nextTrainingLabel: String?
        var nextTrainingDay: Date?
        var nextTrainingTime: Date?
        /// The look, stamped by the app (see the workout state's `style`).
        var style: IslandStyle? = IslandStyle.current
        /// The day these numbers belong to. Usually the attributes' day; an
        /// activity from an earlier day updated in the background (no new
        /// one can be started there) carries today's numbers with today's day.
        var day: Date? = nil

        /// The numbers are an earlier day's: past midnight with no update,
        /// or the system marked the activity stale (staleDate = midnight).
        func isOld(attributesDay: Date, isStale: Bool, now: Date = Date()) -> Bool {
            isStale || !Calendar.current.isDate(day ?? attributesDay, inSameDayAs: now)
        }

        var waterProgress: Double { waterTargetML > 0 ? min(1, Double(waterML) / Double(waterTargetML)) : 0 }
        var kcalProgress: Double { kcalTarget > 0 ? min(1, Double(kcalEaten) / Double(kcalTarget)) : 0 }

        init(waterML: Int, waterTargetML: Int, kcalEaten: Int, kcalTarget: Int, mealsCount: Int,
             isTrainingDay: Bool, trainedToday: Bool, nextTrainingLabel: String?,
             nextTrainingDay: Date?, nextTrainingTime: Date?) {
            self.waterML = waterML; self.waterTargetML = waterTargetML
            self.kcalEaten = kcalEaten; self.kcalTarget = kcalTarget
            self.mealsCount = mealsCount
            self.isTrainingDay = isTrainingDay; self.trainedToday = trainedToday
            self.nextTrainingLabel = nextTrainingLabel
            self.nextTrainingDay = nextTrainingDay; self.nextTrainingTime = nextTrainingTime
        }

        init(_ s: TodaySnapshot) {
            self.init(waterML: s.waterML, waterTargetML: s.waterTargetML,
                      kcalEaten: s.kcalEaten, kcalTarget: s.kcalTarget, mealsCount: s.mealsCount,
                      isTrainingDay: s.isTrainingDay, trainedToday: s.trainedToday,
                      nextTrainingLabel: s.nextTrainingLabel, nextTrainingDay: s.nextTrainingDay,
                      nextTrainingTime: s.nextTrainingTime)
            day = s.day
        }
    }
}

#if canImport(ActivityKit)
extension WorkoutActivityAttributes: ActivityAttributes {}
extension TodayActivityAttributes: ActivityAttributes {}
#endif

// MARK: - Samples (DEBUG demo, previews)

extension WorkoutActivityAttributes {
    static let sample = WorkoutActivityAttributes(
        workoutName: "Push day", startedAt: Date().addingTimeInterval(-20 * 60),
        day: Calendar.current.startOfDay(for: Date()))
}

extension WorkoutActivityAttributes.ContentState {
    static let sampleResting = WorkoutActivityAttributes.ContentState(
        exerciseName: "Barbell Bench Press", muscleGroup: "Chest",
        exerciseIndex: 1, exerciseCount: 4, setNumber: 3, setsInExercise: 4,
        setsDone: 4, setsTotal: 9, nextWeightKg: 60, nextReps: 8, nextHoldSeconds: nil,
        weightUnit: "kg", nextTargetText: "60 kg × 8",
        restStartedAt: Date(), restEndsAt: Date().addingTimeInterval(90), isFinished: false)

    static let sampleLifting = WorkoutActivityAttributes.ContentState(
        exerciseName: "Incline Dumbbell Press", muscleGroup: "Chest",
        exerciseIndex: 2, exerciseCount: 4, setNumber: 1, setsInExercise: 3,
        setsDone: 5, setsTotal: 9, nextWeightKg: 22.5, nextReps: 10, nextHoldSeconds: nil,
        weightUnit: "kg", nextTargetText: "22.5 kg × 10",
        restStartedAt: nil, restEndsAt: nil, isFinished: false)
}

extension TodayActivityAttributes.ContentState {
    static let sample = TodayActivityAttributes.ContentState(TodaySnapshot.sample)
}
