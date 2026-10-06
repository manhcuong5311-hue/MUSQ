//
//  RecoveryCalculator.swift
//  GymWorkout
//
//  A deterministic recovery ESTIMATE, derived only from completed sets. It is
//  guidance, not a physiological measurement — the UI says "estimated" and
//  never blocks training.
//
//  Recovery is worked out per `MusclePart`, then rolled up to groups:
//  • A part is trained when it was a primary mover for enough sets.
//  • A part that only helped (a secondary mover) is noted, but it doesn't
//    count as trained unless it helped in a lot of sets — a chest day tires
//    the front delts a little, it doesn't "train shoulders".
//  • A group is judged by the parts its own sessions work. Some of them tired
//    and the rest fresh reads as "partly ready", and the group can still be
//    trained.
//

import Foundation

/// Every tunable number in one place.
struct RecoverySettings {
    var experience: TrainingExperience

    /// Hours a muscle is given after a normal session, by experience.
    var baseHours: [TrainingExperience: Double] = [
        .beginner: 72,
        .intermediate: 60,
        .advanced: 48
    ]
    /// Per-group adjustment, e.g. `[.calves: 0.75]`. Empty means every group
    /// uses the base.
    var muscleMultipliers: [MuscleGroup: Double] = [:]
    /// Effective sets as a primary mover in a day before a part counts as
    /// trained.
    var meaningfulSets: Double = 2
    /// Below this many effective sets the session is light and the target is
    /// shortened by `lightSessionFactor`.
    var lightSessionSets: Double = 4
    var lightSessionFactor: Double = 0.75
    /// Effective sets as a helper (secondary sets count half) before helping
    /// is noted at all — 4 is eight sets that leaned on the part. Less than
    /// that is ignored.
    var indirectNoticeSets: Double = 4
    /// Effective helper sets that count as having trained the part — 8 is
    /// sixteen sets that leaned on it.
    var indirectHeavySets: Double = 8
    /// Helper work recovers faster than training the part directly.
    var indirectFactor: Double = 0.5
    /// "Almost ready" once no more than this fraction of the target remains.
    var almostReadyFraction: Double = 0.25

    func targetHours(for part: MusclePart, effectiveSets: Double, kind: LoadKind) -> Double {
        let base = baseHours[experience] ?? 60
        let multiplier = muscleMultipliers[part.group] ?? 1
        switch kind {
        case .direct:
            let volume = effectiveSets < lightSessionSets ? lightSessionFactor : 1
            return base * multiplier * volume
        case .heavyIndirect, .indirect:
            return base * multiplier * indirectFactor
        }
    }

    /// How a day's load on one part counts, or nil when it doesn't register.
    func kind(directSets: Double, indirectSets: Double) -> LoadKind? {
        if directSets >= meaningfulSets { return .direct }
        if indirectSets >= indirectHeavySets { return .heavyIndirect }
        if indirectSets >= indirectNoticeSets { return .indirect }
        return nil
    }
}

struct RecoveryCalculator {
    var settings: RecoverySettings

    /// Recovery per group, judged at `now` (sets completed after `now` are
    /// ignored). A group appears once any of its parts has a recent load.
    func records(from sessions: [WorkoutSession], now: Date = Date()) -> [MuscleGroup: MuscleTrainingRecord] {
        let parts = partRecords(from: sessions, now: now)
        var result: [MuscleGroup: MuscleTrainingRecord] = [:]
        for group in MuscleGroup.allCases {
            let loaded = group.parts.compactMap { parts[$0] }.sorted { Self.moreFatigued($0, $1) }
            guard !loaded.isEmpty else { continue }
            let main = ExerciseCatalog.mainParts(of: group)
            let tired = loaded.filter { $0.isTired && main.contains($0.part) }

            let status: RecoveryStatus
            if tired.isEmpty {
                status = .ready
            } else if tired.count < main.count {
                status = .partlyReady
            } else {
                status = tired.map(\.status).max { $0.severity < $1.severity } ?? .recovering
            }
            // The part that best explains the status: the most tired one, or
            // else the latest real training, or else the latest helping.
            let lead = tired.first
                ?? loaded.filter(\.kind.counts).max { $0.lastTrainedAt < $1.lastTrainedAt }
                ?? loaded.max { $0.lastTrainedAt < $1.lastTrainedAt }
                ?? loaded[0]
            result[group] = MuscleTrainingRecord(
                muscle: group,
                lastTrainedAt: lead.lastTrainedAt,
                effectiveSets: lead.effectiveSets,
                recoveryTargetHours: lead.recoveryTargetHours,
                status: status,
                hoursRemaining: tired.map(\.hoursRemaining).max() ?? 0,
                parts: loaded,
                mainParts: main
            )
        }
        return result
    }

    /// For every part with a load that registers, the day that matters most
    /// right now: the one leaving it most fatigued, or — once everything has
    /// recovered — the latest. It also carries the latest day that counted
    /// as training the part, which can be an earlier one.
    func partRecords(from sessions: [WorkoutSession], now: Date = Date()) -> [MusclePart: MusclePartRecord] {
        let perDay = dayLoads(from: sessions, now: now)
        var result: [MusclePart: MusclePartRecord] = [:]
        for (part, days) in perDay {
            let candidates = days.values.compactMap { load -> MusclePartRecord? in
                guard let kind = settings.kind(directSets: load.direct, indirectSets: load.indirect) else { return nil }
                let sets = load.direct + load.indirect
                let target = settings.targetHours(for: part, effectiveSets: sets, kind: kind)
                let remaining = max(target - now.timeIntervalSince(load.last) / 3600, 0)
                let status: RecoveryStatus
                if remaining <= 0 {
                    status = .ready
                } else if kind == .indirect || remaining <= target * settings.almostReadyFraction {
                    status = .almostReady
                } else {
                    status = .recovering
                }
                return MusclePartRecord(part: part, kind: kind, lastTrainedAt: load.last,
                                        effectiveSets: sets, recoveryTargetHours: target,
                                        status: status, hoursRemaining: remaining,
                                        exercises: load.exercises)
            }
            var record = candidates.max { Self.moreFatigued($1, $0) }
            // Once everything has recovered, the latest day is picked even if
            // it only helped; keep the real training date alongside it so the
            // part doesn't read as never trained.
            record?.lastCountedAt = candidates.filter(\.kind.counts).map(\.lastTrainedAt).max()
            result[part] = record
        }
        return result
    }

    /// The days each group had a session of its own: a load that counts on
    /// one of the parts its sessions mainly work, from exercises logged under
    /// the group. Rows on a back day load the rear delts, but that isn't a
    /// shoulder session. Oldest first.
    func trainingDays(from sessions: [WorkoutSession], now: Date = Date()) -> [(day: Date, groups: Set<MuscleGroup>)] {
        var byDay: [Date: Set<MuscleGroup>] = [:]
        for (part, days) in dayLoads(from: sessions, now: now, ownGroupOnly: true)
        where ExerciseCatalog.mainParts(of: part.group).contains(part) {
            for (day, load) in days
            where settings.kind(directSets: load.direct, indirectSets: load.indirect)?.counts == true {
                byDay[day, default: []].insert(part.group)
            }
        }
        return byDay.sorted { $0.key < $1.key }.map { (day: $0.key, groups: $0.value) }
    }

    /// One day's load on one part: effective sets as a primary mover and as
    /// a helper, the last set, and the exercises that loaded it.
    private struct DayLoad {
        var direct: Double = 0
        var indirect: Double = 0
        var last: Date
        var exercises: [String] = []
    }

    /// Every completed set up to `now`, added up per part and day. With
    /// `ownGroupOnly`, an exercise only counts toward the parts of the group
    /// it was logged under.
    private func dayLoads(from sessions: [WorkoutSession], now: Date,
                          ownGroupOnly: Bool = false) -> [MusclePart: [Date: DayLoad]] {
        let calendar = Calendar.current
        var perDay: [MusclePart: [Date: DayLoad]] = [:]
        for session in sessions {
            for exercise in session.exercises {
                let contributions = Self.partContributions(of: exercise)
                    .filter { !ownGroupOnly || $0.part.group == exercise.group }
                for set in exercise.sets where set.isCompleted {
                    let at = set.completedAt ?? session.day
                    guard at <= now else { continue }
                    let day = calendar.startOfDay(for: at)
                    for contribution in contributions {
                        var load = perDay[contribution.part, default: [:]][day] ?? DayLoad(last: at)
                        if contribution.role == .primary { load.direct += contribution.weight }
                        else { load.indirect += contribution.weight }
                        load.last = max(load.last, at)
                        if !load.exercises.contains(exercise.exerciseName) {
                            load.exercises.append(exercise.exerciseName)
                        }
                        perDay[contribution.part, default: [:]][day] = load
                    }
                }
            }
        }
        return perDay
    }

    /// Orders by what holds a part back most: real training over helping,
    /// then status, then time left, then recency.
    private static func moreFatigued(_ a: MusclePartRecord, _ b: MusclePartRecord) -> Bool {
        let ka = (a.isTired ? 1 : 0, a.status.severity, a.hoursRemaining, a.lastTrainedAt)
        let kb = (b.isTired ? 1 : 0, b.status.severity, b.hoursRemaining, b.lastTrainedAt)
        return ka > kb
    }

    /// The exercise's logged part snapshot; for history saved before parts
    /// existed, the exercise looked up again; for an exercise no longer in
    /// the library, every part of each logged group (the old behaviour).
    static func partContributions(of exercise: WorkoutExercise) -> [MusclePartContribution] {
        if let saved = exercise.partContributions, !saved.isEmpty { return saved }
        let looked = ExerciseCatalog.partContributions(forExerciseNamed: exercise.exerciseName)
        if !looked.isEmpty { return looked }
        return exercise.contributions.flatMap { contribution in
            contribution.muscle.parts.map {
                MusclePartContribution(part: $0, role: contribution.role, weight: contribution.weight)
            }
        }
    }
}
