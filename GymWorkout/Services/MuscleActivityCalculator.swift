//
//  MuscleActivityCalculator.swift
//  GymWorkout
//
//  How much each muscle group was actually trained in a period, from
//  completed sets only. Planned-but-unfinished sets never count.
//

import Foundation

enum ActivityPeriod: String, CaseIterable, Hashable {
    case week, month

    var title: String { self == .week ? String(localized: "WEEK") : String(localized: "MONTH") }

    func interval(containing date: Date, calendar: Calendar = .current) -> DateInterval {
        let component: Calendar.Component = self == .week ? .weekOfYear : .month
        return calendar.dateInterval(of: component, for: date)
            ?? DateInterval(start: calendar.startOfDay(for: date), duration: 86_400)
    }

    /// Effective-set cut-offs between low / trained / high activity. They
    /// describe how much happened, not how much is "enough".
    var thresholds: (trained: Double, high: Double) {
        self == .week ? (4, 10) : (12, 30)
    }
}

enum ActivityLevel: Int, Comparable {
    case notTrained, low, trained, high

    var title: String {
        switch self {
        case .notTrained: return String(localized: "Not trained", comment: "Activity level of a muscle group")
        case .low: return String(localized: "Low activity", comment: "Activity level of a muscle group")
        case .trained: return String(localized: "Trained", comment: "Activity level of a muscle group")
        case .high: return String(localized: "High activity", comment: "Activity level of a muscle group")
        }
    }

    static func < (a: ActivityLevel, b: ActivityLevel) -> Bool { a.rawValue < b.rawValue }
}

struct MuscleActivity: Identifiable, Hashable {
    let muscle: MuscleGroup
    let effectiveSets: Double
    let level: ActivityLevel

    var id: MuscleGroup { muscle }

    /// "14", "3.5" — effective sets can be halves. In the locale's format
    /// ("3,5" in Vietnamese).
    var setsValue: String {
        effectiveSets.rounded() == effectiveSets
            ? String(Int(effectiveSets)) : effectiveSets.formatted(.number.precision(.fractionLength(1)))
    }

    /// "14 sets", "1 set".
    var setsLabel: String {
        effectiveSets == 1 ? String(localized: "1 set", comment: "Effective sets of a muscle group")
            : String(localized: "\(setsValue) sets", comment: "Effective sets of a muscle group; can be a half (3.5)")
    }
}

/// The chest's three heads in a period, for the muscle map's chest bands:
/// each completed set of a lift that works the chest counts in full for a
/// head its model paints bright and half for a dim one, the same weights a
/// primary and a secondary row give the Chest group.
struct ChestActivity: Hashable {
    var upper: ActivityLevel = .notTrained
    var middle: ActivityLevel = .notTrained
    var lower: ActivityLevel = .notTrained

    /// Upper, middle and lower, as `BodyRegion.chestHeads` lists them.
    var levels: [ActivityLevel] { [upper, middle, lower] }
}

/// A group that is trained noticeably less than the rest, with the reason.
struct AttentionItem: Identifiable, Hashable {
    let activity: MuscleActivity
    let reason: String

    var id: MuscleGroup { activity.muscle }
}

struct MuscleActivityCalculator {

    /// Effective completed sets per group inside `period` (around `now`).
    func activity(from sessions: [WorkoutSession], period: ActivityPeriod,
                  now: Date = Date()) -> [MuscleActivity] {
        let interval = period.interval(containing: now)
        var totals: [MuscleGroup: Double] = [:]
        for session in sessions {
            for exercise in session.exercises {
                for set in exercise.sets where set.isCompleted {
                    let at = set.completedAt ?? session.day
                    guard interval.contains(at), at <= now else { continue }
                    for contribution in exercise.contributions {
                        totals[contribution.muscle, default: 0] += contribution.weight
                    }
                }
            }
        }
        let (trained, high) = period.thresholds
        return MuscleGroup.allCases.map { muscle in
            let sets = totals[muscle] ?? 0
            let level: ActivityLevel =
                sets <= 0 ? .notTrained : sets < trained ? .low : sets < high ? .trained : .high
            return MuscleActivity(muscle: muscle, effectiveSets: sets, level: level)
        }
    }

    /// Effective completed sets per chest head inside `period`, levelled on
    /// the period's group cut-offs. The heads come from the logged snapshot,
    /// else the exercise's model, else its chest rows (`ChestPaint`); a lift
    /// with a chest weight but no head to show spreads it over all three.
    func chest(from sessions: [WorkoutSession], period: ActivityPeriod,
               now: Date = Date()) -> ChestActivity {
        let interval = period.interval(containing: now)
        var sets: [Double] = [0, 0, 0]
        for session in sessions {
            for exercise in session.exercises {
                guard let weight = exercise.contributions.first(where: { $0.muscle == .chest })?.weight else { continue }
                let heads = exercise.chestHeads ?? ChestPaint.heads(forExerciseNamed: exercise.exerciseName)
                let shares = heads.map { [$0.upper, $0.middle, $0.lower].map { Self.share($0) } } ?? [weight, weight, weight]
                for set in exercise.sets where set.isCompleted {
                    let at = set.completedAt ?? session.day
                    guard interval.contains(at), at <= now else { continue }
                    for i in 0..<3 { sets[i] += shares[i] }
                }
            }
        }
        let (trained, high) = period.thresholds
        let levels = sets.map { s -> ActivityLevel in
            s <= 0 ? .notTrained : s < trained ? .low : s < high ? .trained : .high
        }
        return ChestActivity(upper: levels[0], middle: levels[1], lower: levels[2])
    }

    private static func share(_ rank: ActivationRank?) -> Double {
        switch rank {
        case .primary: return ContributionRole.primary.defaultWeight
        case .secondary: return ContributionRole.secondary.defaultWeight
        case nil: return 0
        }
    }

    /// Groups worth a look, least trained first. Only groups in `candidates`
    /// are considered, so the list never points at something the app can't
    /// offer exercises for.
    func needsAttention(_ activity: [MuscleActivity], period: ActivityPeriod,
                        candidates: [MuscleGroup], limit: Int = 4) -> [AttentionItem] {
        let byMuscle = Dictionary(uniqueKeysWithValues: activity.map { ($0.muscle, $0) })
        var items: [AttentionItem] = []
        for muscle in candidates {
            guard let entry = byMuscle[muscle] else { continue }
            // Whole sentences for each period and count, so translations
            // can order the words their own way.
            switch entry.level {
            case .notTrained:
                let reason = period == .week ? String(localized: "Not trained this week")
                    : String(localized: "Not trained this month")
                items.append(AttentionItem(activity: entry, reason: reason))
            case .low:
                let one = entry.effectiveSets == 1, sets = entry.setsValue
                let reason = period == .week
                    ? (one ? String(localized: "1 effective set this week")
                        : String(localized: "\(sets) effective sets this week"))
                    : (one ? String(localized: "1 effective set this month")
                        : String(localized: "\(sets) effective sets this month"))
                items.append(AttentionItem(activity: entry, reason: reason))
            case .trained, .high:
                // Clearly behind the other trained groups in the same area.
                let peers = candidates
                    .filter { $0 != muscle && $0.area == muscle.area }
                    .compactMap { byMuscle[$0]?.effectiveSets }
                    .filter { $0 > 0 }
                guard !peers.isEmpty else { continue }
                let average = peers.reduce(0, +) / Double(peers.count)
                if entry.effectiveSets < average * 0.5 {
                    let reason = muscle.area == .upper
                        ? String(localized: "Less training than your other upper-body muscle groups")
                        : muscle.area == .lower
                        ? String(localized: "Less training than your other lower-body muscle groups")
                        : String(localized: "Less training than your other core muscle groups")
                    items.append(AttentionItem(activity: entry, reason: reason))
                }
            }
        }
        return Array(items
            .sorted { ($0.activity.level, $0.activity.effectiveSets) < ($1.activity.level, $1.activity.effectiveSets) }
            .prefix(limit))
    }
}
