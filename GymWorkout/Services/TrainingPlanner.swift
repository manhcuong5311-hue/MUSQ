//
//  TrainingPlanner.swift
//  GymWorkout
//
//  Picks today's suggested muscle groups from a rotation — the days of the
//  profile's split (upper / lower, front / back or push / pull / legs; see
//  `ProgramAdvisor`). The planner suggests whichever day of it is most
//  recovered, breaking ties by what was trained longest ago. It only
//  suggests — any group can be trained at any time.
//

import Foundation

struct TrainingPlanner {

    var records: [MuscleGroup: MuscleTrainingRecord]
    /// The moment being planned for — today, or a day picked on the calendar.
    var now: Date = Date()
    var rotation: [[MuscleGroup]] = ProgramAdvisor.standardRotation

    /// The suggested groups, leaving out any that are still recovering.
    ///
    /// Once the day already has groups planned, the suggestion stays on the
    /// rotation day those groups belong to (start chest, and shoulders and
    /// triceps are what's left to suggest) instead of jumping to another day
    /// just because the planned group is now recovering.
    func recommended(planned: [MuscleGroup] = []) -> [MuscleGroup] {
        let trainable = Set(PresetProvider.trainableGroups)
        let days = rotation.map { $0.filter(trainable.contains) }.filter { !$0.isEmpty }
        guard var best = days.first else { return [] }
        if !planned.isEmpty {
            let overlap = { (day: [MuscleGroup]) in day.filter(planned.contains).count }
            for day in days.dropFirst() where overlap(day) > overlap(best) { best = day }
            if overlap(best) > 0 {
                return best.filter { !planned.contains($0) && records[$0]?.status != .recovering }
            }
        }
        // Earliest day in the rotation wins a tie, so a new user starts on push.
        for day in days.dropFirst() where score(day) > score(best) { best = day }
        return best.filter { records[$0]?.status != .recovering }
    }

    /// Readiness first (ready 1, partly or almost ready 0.5, recovering 0,
    /// averaged), then hours since the group was last really trained (never =
    /// very long ago; only helping another group's exercises doesn't count).
    private func score(_ day: [MuscleGroup]) -> (Double, Double) {
        let readiness = day.map { group -> Double in
            switch records[group]?.status {
            case .none, .ready: return 1
            case .almostReady, .partlyReady: return 0.5
            case .recovering: return 0
            }
        }.reduce(0, +) / Double(day.count)
        let staleness = day.map { group -> Double in
            guard let last = records[group]?.lastCountedAt else { return 1_000_000 }
            return now.timeIntervalSince(last) / 3600
        }.min() ?? 0
        return (readiness, staleness)
    }
}
