//
//  PerformanceHistory.swift
//  GymWorkout
//
//  What the user did before: the last time an exercise was done, personal
//  records, and which sets set one. Only completed sets count, the same rule
//  recovery and progress follow.
//

import Foundation

/// One completed set and the day it was done.
struct LoggedSet: Hashable {
    let weight: Double?
    let reps: Int
    let day: Date

    /// Epley's estimated one-rep max, for sets with a load.
    var estimatedMax: Double? { PerformanceHistory.estimatedMax(weight: weight, reps: reps) }
}

/// An exercise's sets on its most recent earlier day.
struct PreviousPerformance: Hashable {
    let day: Date
    let measure: SetMeasure
    let sets: [WorkoutSet]

    /// The set done in the same position last time, or the last one when this
    /// session has more sets.
    func set(at index: Int) -> WorkoutSet? {
        sets.isEmpty ? nil : sets[min(index, sets.count - 1)]
    }
}

/// An exercise's bests across all history.
struct ExerciseRecord: Identifiable, Hashable {
    let exerciseName: String
    let measure: SetMeasure
    /// Heaviest loaded set; the one with more reps when two tie on weight.
    let heaviest: LoggedSet?
    /// Loaded set with the highest estimated one-rep max.
    let bestSet: LoggedSet?
    /// Most reps without a load, or the longest hold.
    let bestUnloaded: LoggedSet?
    let lastDone: Date
    /// Days the exercise was done.
    let dayCount: Int

    var id: String { exerciseName }
}

/// An exercise's completed sets on one day, with the ones that set a record.
struct ExerciseDay: Identifiable, Hashable {
    let day: Date
    let measure: SetMeasure
    let sets: [WorkoutSet]
    let recordSetIDs: Set<UUID>

    var id: Date { day }
}

enum PerformanceHistory {

    static func estimatedMax(weight: Double?, reps: Int) -> Double? {
        guard let weight, weight > 0, reps > 0 else { return nil }
        return reps == 1 ? weight : weight * (1 + Double(reps) / 30)
    }

    /// The last day before `day` with completed sets of the exercise.
    static func previous(of name: String, before day: Date,
                         in sessions: [WorkoutSession]) -> PreviousPerformance? {
        let start = Calendar.current.startOfDay(for: day)
        for session in sessions.sorted(by: { $0.day > $1.day }) where session.day < start {
            let entries = session.exercises.filter { $0.exerciseName == name && !$0.completedSets.isEmpty }
            guard let first = entries.first else { continue }
            return PreviousPerformance(day: session.day, measure: first.setMeasure,
                                       sets: entries.flatMap(\.completedSets))
        }
        return nil
    }

    /// Completed sets that beat every earlier set of the same kind: a higher
    /// estimated max for loaded sets, more reps for unloaded ones, a longer
    /// hold for timed ones. An exercise's first set of a kind is a baseline,
    /// not a record, so a first workout isn't covered in badges.
    static func recordSetIDs(for name: String, in sessions: [WorkoutSession]) -> Set<UUID> {
        var best: [Kind: Double] = [:]
        var ids: Set<UUID> = []
        for (entry, set) in completedSets(of: name, in: sessions) {
            let (kind, score) = score(set, measure: entry.setMeasure)
            if let previous = best[kind] {
                if score > previous { ids.insert(set.id); best[kind] = score }
            } else {
                best[kind] = score
            }
        }
        return ids
    }

    /// Every exercise with completed sets, most recently done first.
    static func records(in sessions: [WorkoutSession]) -> [ExerciseRecord] {
        let names = Set(sessions.flatMap { $0.exercises.filter { !$0.completedSets.isEmpty }.map(\.exerciseName) })
        return names.compactMap { record(for: $0, in: sessions) }
            .sorted { ($0.lastDone, $1.exerciseName) > ($1.lastDone, $0.exerciseName) }
    }

    static func record(for name: String, in sessions: [WorkoutSession]) -> ExerciseRecord? {
        let logged = completedSets(of: name, in: sessions)
        guard let last = logged.last else { return nil }
        var heaviest: LoggedSet?
        var bestSet: LoggedSet?
        var bestUnloaded: LoggedSet?
        var days: Set<Date> = []
        for (entry, set) in logged {
            let item = LoggedSet(weight: set.weight, reps: set.reps, day: entry.day)
            days.insert(entry.day)
            if let weight = set.weight, weight > 0, !entry.exercise.isTimed {
                if heaviest.map({ (weight, set.reps) > ($0.weight ?? 0, $0.reps) }) ?? true { heaviest = item }
                if let estimate = item.estimatedMax, estimate > (bestSet?.estimatedMax ?? 0) { bestSet = item }
            } else if set.reps > (bestUnloaded?.reps ?? 0) {
                bestUnloaded = item
            }
        }
        return ExerciseRecord(
            exerciseName: name,
            measure: last.entry.exercise.setMeasure,
            heaviest: heaviest,
            bestSet: bestSet,
            bestUnloaded: bestUnloaded,
            lastDone: last.entry.day,
            dayCount: days.count
        )
    }

    /// The exercise's completed sets per day, newest first.
    static func days(of name: String, in sessions: [WorkoutSession]) -> [ExerciseDay] {
        let records = recordSetIDs(for: name, in: sessions)
        return sessions.sorted { $0.day > $1.day }.compactMap { session in
            let entries = session.exercises.filter { $0.exerciseName == name && !$0.completedSets.isEmpty }
            guard let first = entries.first else { return nil }
            let sets = entries.flatMap(\.completedSets)
            return ExerciseDay(day: session.day, measure: first.setMeasure, sets: sets,
                               recordSetIDs: records.intersection(sets.map(\.id)))
        }
    }

    /// Sessions with completed sets whose day falls in `interval`.
    static func sessions(in interval: DateInterval, from sessions: [WorkoutSession]) -> [WorkoutSession] {
        sessions.filter { $0.hasCompletedSets && interval.contains($0.day) }
    }

    // MARK: - Helpers

    private enum Kind: Hashable { case loaded, unloaded, hold }

    private struct Entry {
        let day: Date
        let exercise: WorkoutExercise
        var setMeasure: SetMeasure { exercise.setMeasure }
    }

    /// Oldest first, in the order the sets were logged.
    private static func completedSets(of name: String,
                                      in sessions: [WorkoutSession]) -> [(entry: Entry, set: WorkoutSet)] {
        sessions.sorted { $0.day < $1.day }.flatMap { session in
            session.exercises.filter { $0.exerciseName == name }.flatMap { exercise in
                exercise.completedSets.map { (Entry(day: session.day, exercise: exercise), $0) }
            }
        }
    }

    private static func score(_ set: WorkoutSet, measure: SetMeasure) -> (Kind, Double) {
        if measure == .time { return (.hold, Double(set.reps)) }
        if let max = estimatedMax(weight: set.weight, reps: set.reps) { return (.loaded, max) }
        return (.unloaded, Double(set.reps))
    }
}
