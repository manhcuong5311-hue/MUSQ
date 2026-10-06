//
//  TrainingRound.swift
//  GymWorkout
//
//  The round the Train tab's card edges count in. A group trained this round
//  stays "done" (yellow) even once it has recovered, so the groups still
//  waiting for their turn (green) stand out until they've had it. Then the
//  round starts over: when every group in the split has been trained, or
//  with each new week, whichever the user picked in Settings.
//

import Foundation

enum TrainingRound {

    /// When the green "due" edges start over.
    enum Reset: String, CaseIterable, Identifiable {
        /// Once every group in the split has been trained.
        case fullRound
        /// With each new calendar week.
        case weekly

        var id: String { rawValue }

        var title: String {
            switch self {
            case .fullRound: return "Full round"
            case .weekly: return "Weekly"
            }
        }
    }

    /// The groups trained in the round `date` falls in. `days` is every day
    /// that counted as training a group, oldest first (see
    /// `RecoveryCalculator.trainingDays`); `split` is the groups a full round
    /// has to cover. Groups outside the split count once trained, but never
    /// hold a round open.
    static func trained(days: [(day: Date, groups: Set<MuscleGroup>)], split: Set<MuscleGroup>,
                        reset: Reset, at date: Date, calendar: Calendar = .current) -> Set<MuscleGroup> {
        let past = days.filter { $0.day <= date }
        switch reset {
        case .weekly:
            guard let week = calendar.dateInterval(of: .weekOfYear, for: date) else { return [] }
            return past.filter { week.contains($0.day) }.reduce(into: []) { $0.formUnion($1.groups) }
        case .fullRound:
            var trained = Set<MuscleGroup>()
            for entry in past {
                trained.formUnion(entry.groups)
                // The round closes on the day the last group of the split has
                // its turn; the next one starts empty.
                if !split.isEmpty, split.isSubset(of: trained) { trained = [] }
            }
            return trained
        }
    }
}
