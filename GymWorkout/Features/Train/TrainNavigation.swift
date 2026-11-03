//
//  TrainNavigation.swift
//  GymWorkout
//
//  Navigation shared by the Train and Muscles tabs: both can open a muscle
//  group's preset, an exercise's sets, and the full 3D trainer; the Muscles
//  tab also opens the workout history.
//

import SwiftUI
import Observation

enum TrainRoute: Hashable {
    /// `level` opens an unplanned group on that preset instead of the one
    /// it would open on.
    case preset(MuscleGroup, day: Date, level: PresetLevel? = nil)
    case exercise(UUID)
    case trainer(exerciseName: String)
    /// A logged day, read-only.
    case session(UUID)
    /// One exercise across every day it was done, read-only.
    case exerciseHistory(String)
}

/// Owns a tab's navigation path so screens deep in the stack can push after
/// doing some work first (e.g. saving a preview before opening its sets).
@Observable
final class TrainRouter {
    var path: [TrainRoute] = []

    func push(_ route: TrainRoute) { path.append(route) }
    func pop() { if !path.isEmpty { path.removeLast() } }
}

extension View {
    func trainDestinations() -> some View {
        navigationDestination(for: TrainRoute.self) { route in
            switch route {
            case .preset(let group, let day, let level):
                MusclePresetView(group: group, day: day, initialLevel: level)
            case .exercise(let id):
                // Pushed on every device; only the iPad preset screen embeds
                // it as a pane instead, without a route.
                ExerciseDetailView(workoutExerciseID: id, presentation: .pushed)
            case .trainer(let name):
                if let exercise = ExerciseCatalog.exercise(named: name) {
                    Exercise3DView(exercise: exercise)
                }
            case .session(let id):
                SessionHistoryView(sessionID: id)
            case .exerciseHistory(let name):
                ExerciseHistoryView(exerciseName: name)
            }
        }
    }
}

// MARK: - Wording

/// Recovery wording in one place. Always phrased as an estimate.
enum RecoveryText {
    static func trainedAgo(_ date: Date, now: Date = Date()) -> String {
        let hours = now.timeIntervalSince(date) / 3600
        if hours < 1 { return String(localized: "Trained less than an hour ago") }
        if hours < 24 {
            let h = Int(hours)
            return h == 1 ? String(localized: "Trained 1 hour ago") : String(localized: "Trained \(h) hours ago")
        }
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: date),
                                           to: calendar.startOfDay(for: now)).day ?? 0
        return days <= 1 ? String(localized: "Trained yesterday") : String(localized: "Trained \(days) days ago")
    }

    /// "Today", "Yesterday", "Mon 21 Sep".
    static func day(_ date: Date, now: Date = Date()) -> String {
        let calendar = Calendar.current
        if calendar.isDate(date, inSameDayAs: now) { return String(localized: "Today") }
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.isDate(date, inSameDayAs: yesterday) { return String(localized: "Yesterday") }
        return date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
    }

    static func hours(_ value: Double) -> String {
        let h = Int(value.rounded(.up))
        return h == 1 ? String(localized: "1 hour") : String(localized: "\(h) hours")
    }

    static func remaining(_ hours: Double) -> String {
        String(localized: "~\(Int(hours.rounded(.up)))h remaining", comment: "Estimated recovery time left, in hours")
    }

    // MARK: Parts

    /// "Front delts", "Side delts & rear delts", "Lats, upper back & lower back".
    static func list(_ parts: [MusclePart]) -> String {
        let titles = parts.enumerated().map { $0.offset == 0 ? $0.element.title : $0.element.title.lowercased() }
        guard let last = titles.last else { return "" }
        return titles.count == 1 ? last
            : String(localized: "\(titles.dropLast().joined(separator: ", ")) & \(last)",
                     comment: "Adds the last muscle to a list: “chest & abs”, “Lats, upper back & lower back”")
    }

    /// "Front delts recovering" / "Side delts & rear delts recovering".
    static func recovering(_ parts: [MusclePart]) -> String {
        String(localized: "\(list(parts)) recovering", comment: "Muscles still recovering: “Front delts recovering”")
    }

    /// "Side delts & rear delts ready".
    static func ready(_ parts: [MusclePart]) -> String {
        String(localized: "\(list(parts)) ready", comment: "Muscles recovered: “Side delts & rear delts ready”")
    }

    /// "today", "yesterday", "on Mon 21 Sep" — for the middle of a sentence.
    /// Decided on the dates, as `day`'s words are in the current language.
    static func dayPhrase(_ date: Date, now: Date = Date()) -> String {
        let calendar = Calendar.current
        if calendar.isDate(date, inSameDayAs: now) {
            return String(localized: "today", comment: "A day inside a sentence: “Trained today”")
        }
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.isDate(date, inSameDayAs: yesterday) {
            return String(localized: "yesterday", comment: "A day inside a sentence: “Trained yesterday”")
        }
        return String(localized: "on \(day(date, now: now))",
                      comment: "A day inside a sentence: “on Wednesday”, “on Mon 21 Sep”")
    }

    /// Recent load that doesn't hold the group back, in a few words:
    /// "Front delts helped yesterday", "Lower back trained yesterday".
    static func sideNote(_ record: MusclePartRecord, now: Date = Date()) -> String {
        let when = dayPhrase(record.lastTrainedAt, now: now)
        return record.kind == .indirect
            ? String(localized: "\(record.part.title) helped \(when)",
                     comment: "A muscle worked by another group's exercises, then when: “Front delts helped yesterday”")
            : String(localized: "\(record.part.title) trained \(when)",
                     comment: "A muscle, then when it was trained: “Lower back trained yesterday”")
    }

    /// How the part was worked that day: "Trained yesterday", "Helped
    /// yesterday", "Helped a lot yesterday".
    static func load(_ record: MusclePartRecord, now: Date = Date()) -> String {
        let when = dayPhrase(record.lastTrainedAt, now: now)
        switch record.kind {
        case .direct: return String(localized: "Trained \(when)", comment: "How a muscle was worked, then when: “Trained yesterday”")
        case .heavyIndirect:
            return String(localized: "Helped a lot \(when)", comment: "How a muscle was worked, then when: “Helped a lot yesterday”")
        case .indirect: return String(localized: "Helped \(when)", comment: "How a muscle was worked, then when: “Helped yesterday”")
        }
    }
}

/// A logged set in a few characters, the same everywhere it is listed.
enum SetText {
    /// "60 kg × 10", "12 reps" without a load, "45s" for a hold.
    static func short(_ set: WorkoutSet, measure: SetMeasure, unit: WeightUnit) -> String {
        if measure == .time { return SetMeasure.clock(set.reps) }
        guard let weight = set.weight, weight > 0 else { return measure.value(set.reps) }
        return String(localized: "\(unit.format(weight)) × \(set.reps)", comment: "A logged set, load × reps: “60 kg × 10”")
    }
}
