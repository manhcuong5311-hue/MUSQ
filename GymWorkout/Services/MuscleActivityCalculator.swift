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

    var title: String { rawValue.uppercased() }
    var phrase: String { self == .week ? "this week" : "this month" }

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
        case .notTrained: return "Not trained"
        case .low: return "Low activity"
        case .trained: return "Trained"
        case .high: return "High activity"
        }
    }

    static func < (a: ActivityLevel, b: ActivityLevel) -> Bool { a.rawValue < b.rawValue }
}

struct MuscleActivity: Identifiable, Hashable {
    let muscle: MuscleGroup
    let effectiveSets: Double
    let level: ActivityLevel

    var id: MuscleGroup { muscle }

    /// "14", "3.5" — effective sets can be halves.
    var setsValue: String {
        effectiveSets.rounded() == effectiveSets
            ? String(Int(effectiveSets)) : String(format: "%.1f", effectiveSets)
    }

    /// "14 sets", "1 set".
    var setsLabel: String { "\(setsValue) \(effectiveSets == 1 ? "set" : "sets")" }
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

    /// Groups worth a look, least trained first. Only groups in `candidates`
    /// are considered, so the list never points at something the app can't
    /// offer exercises for.
    func needsAttention(_ activity: [MuscleActivity], period: ActivityPeriod,
                        candidates: [MuscleGroup], limit: Int = 4) -> [AttentionItem] {
        let byMuscle = Dictionary(uniqueKeysWithValues: activity.map { ($0.muscle, $0) })
        var items: [AttentionItem] = []
        for muscle in candidates {
            guard let entry = byMuscle[muscle] else { continue }
            switch entry.level {
            case .notTrained:
                items.append(AttentionItem(activity: entry, reason: "Not trained \(period.phrase)"))
            case .low:
                items.append(AttentionItem(activity: entry,
                                           reason: "\(entry.setsValue) effective \(entry.effectiveSets == 1 ? "set" : "sets") \(period.phrase)"))
            case .trained, .high:
                // Clearly behind the other trained groups in the same area.
                let peers = candidates
                    .filter { $0 != muscle && $0.area == muscle.area }
                    .compactMap { byMuscle[$0]?.effectiveSets }
                    .filter { $0 > 0 }
                guard !peers.isEmpty else { continue }
                let average = peers.reduce(0, +) / Double(peers.count)
                if entry.effectiveSets < average * 0.5 {
                    let area = muscle.area == .upper ? "upper-body" : muscle.area == .lower ? "lower-body" : "core"
                    items.append(AttentionItem(activity: entry,
                                               reason: "Less training than your other \(area) muscle groups"))
                }
            }
        }
        return Array(items
            .sorted { ($0.activity.level, $0.activity.effectiveSets) < ($1.activity.level, $1.activity.effectiveSets) }
            .prefix(limit))
    }
}
