//
//  TrainNavigation.swift
//  GymWorkout
//
//  Navigation shared by the Train and Muscles tabs: both can open a muscle
//  group's preset, an exercise's sets, and the full 3D trainer.
//

import SwiftUI
import Observation

enum TrainRoute: Hashable {
    case preset(MuscleGroup, day: Date)
    case exercise(UUID)
    case trainer(exerciseName: String)
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
            case .preset(let group, let day):
                MusclePresetView(group: group, day: day)
            case .exercise(let id):
                ExerciseDetailView(workoutExerciseID: id)
            case .trainer(let name):
                if let exercise = ExerciseCatalog.exercise(named: name) {
                    Exercise3DView(exercise: exercise)
                }
            }
        }
    }
}

// MARK: - Wording

/// Recovery wording in one place. Always phrased as an estimate.
enum RecoveryText {
    static func trainedAgo(_ date: Date, now: Date = Date()) -> String {
        let hours = now.timeIntervalSince(date) / 3600
        if hours < 1 { return "Trained less than an hour ago" }
        if hours < 24 {
            let h = Int(hours)
            return "Trained \(h) \(h == 1 ? "hour" : "hours") ago"
        }
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: date),
                                           to: calendar.startOfDay(for: now)).day ?? 0
        return days <= 1 ? "Trained yesterday" : "Trained \(days) days ago"
    }

    /// "Today", "Yesterday", "Mon 21 Sep".
    static func day(_ date: Date, now: Date = Date()) -> String {
        let calendar = Calendar.current
        if calendar.isDate(date, inSameDayAs: now) { return "Today" }
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.isDate(date, inSameDayAs: yesterday) { return "Yesterday" }
        return date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
    }

    static func hours(_ value: Double) -> String {
        let h = Int(value.rounded(.up))
        return "\(h) \(h == 1 ? "hour" : "hours")"
    }

    static func remaining(_ hours: Double) -> String {
        "~\(Int(hours.rounded(.up)))h remaining"
    }

    // MARK: Parts

    /// "Front delts", "Side delts & rear delts", "Lats, upper back & lower back".
    static func list(_ parts: [MusclePart]) -> String {
        let titles = parts.enumerated().map { $0.offset == 0 ? $0.element.title : $0.element.title.lowercased() }
        guard let last = titles.last else { return "" }
        return titles.count == 1 ? last : titles.dropLast().joined(separator: ", ") + " & " + last
    }

    /// "Front delts recovering" / "Side delts & rear delts recovering".
    static func recovering(_ parts: [MusclePart]) -> String {
        "\(list(parts)) recovering"
    }

    /// "Side delts & rear delts ready".
    static func ready(_ parts: [MusclePart]) -> String {
        "\(list(parts)) ready"
    }

    /// "today", "yesterday", "on Mon 21 Sep" — for the middle of a sentence.
    static func dayPhrase(_ date: Date, now: Date = Date()) -> String {
        let name = day(date, now: now)
        return name == "Today" || name == "Yesterday" ? name.lowercased() : "on \(name)"
    }

    /// Recent load that doesn't hold the group back, in a few words:
    /// "Front delts helped yesterday", "Lower back trained yesterday".
    static func sideNote(_ record: MusclePartRecord, now: Date = Date()) -> String {
        let verb = record.kind == .indirect ? "helped" : "trained"
        return "\(record.part.title) \(verb) \(dayPhrase(record.lastTrainedAt, now: now))"
    }

    /// How the part was worked that day: "Trained yesterday", "Helped
    /// yesterday", "Helped a lot yesterday".
    static func load(_ record: MusclePartRecord, now: Date = Date()) -> String {
        let when = dayPhrase(record.lastTrainedAt, now: now)
        switch record.kind {
        case .direct: return "Trained \(when)"
        case .heavyIndirect: return "Helped a lot \(when)"
        case .indirect: return "Helped \(when)"
        }
    }
}

/// A logged set in a few characters, the same everywhere it is listed.
enum SetText {
    /// "60 kg × 10", "12 reps" without a load, "45s" for a hold.
    static func short(_ set: WorkoutSet, measure: SetMeasure, unit: WeightUnit) -> String {
        if measure == .time { return SetMeasure.clock(set.reps) }
        guard let weight = set.weight, weight > 0 else { return measure.value(set.reps) }
        return "\(unit.format(weight)) × \(set.reps)"
    }
}
