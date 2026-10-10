//
//  ExerciseRotation.swift
//  GymWorkout
//
//  Fresh exercises for a group's list without changing its shape. Every row
//  is swapped for another exercise of the same movement pattern — a press
//  for a press, a row for a row, a hold for a hold — that the group trains
//  as a primary mover and that is counted the same way (reps or seconds).
//  Among those it prefers one the user hasn't done lately, that suits the
//  list's level, and that spares muscles still recovering. Only when a
//  pattern has nothing left does a row fall back to any exercise for the
//  same part of the group, and never across the holds, carries, shrugs and
//  rotator-cuff work, which don't stand in for anything else.
//

import Foundation

/// What an exercise does, read off its name like `MusclePart` reads muscle
/// names, so new library entries sort themselves.
enum MovementPattern: String {
    case carry, hold, shrug, cuffRotation, uprightRow, rearDelt, lateralRaise, frontRaise
    case pullover, verticalPull, horizontalPull, verticalPress, horizontalPress, fly, dip
    case armCurl, tricepsExtension, legCurl, quadIsolation, squat, lunge, hinge, bridge
    case gluteIsolation, hipAdduction, calfRaise, tibialisRaise, crunch, legRaise, trunkRotation, rollout
    case coreStability, olympicLift, other

    init(exerciseNamed name: String) {
        let n = name.lowercased()
        func has(_ words: String...) -> Bool { words.contains { n.contains($0) } }
        // Order matters: "rear delt row" before "row", "leg press" before
        // "press", "split squat" and "sissy squat" before "squat", and calf
        // raises before all of those, so the leg-press, hack-squat and Smith
        // calf raises and the calf press stay calf work.
        if has("carry", "walk on toes", "bear crawl") { self = .carry }
        // Planks that move are drills, not holds (445-474, 2026-10-05).
        else if has("plank shoulder tap", "plank knee to elbow", "side plank hip lift") { self = .coreStability }
        else if has("plank hip dip") { self = .trunkRotation }
        else if has("plank", "hollow body hold") { self = .hold }
        else if has("shrug") { self = .shrug }
        else if has("external rotation", "internal rotation") { self = .cuffRotation }
        else if has("calf raise", "calf press", "plantar flexion") { self = .calfRaise }
        else if has("tibialis raise", "dorsiflexion") { self = .tibialisRaise }
        else if has("upright row") { self = .uprightRow }
        else if has("rear delt", "reverse pec deck", "reverse dumbbell fly", "face pull") { self = .rearDelt }
        else if has("lateral raise", "y-raise", "lu raise", "powell raise") { self = .lateralRaise }
        else if has("front raise") { self = .frontRaise }
        else if has("pullover", "straight-arm pulldown") { self = .pullover }
        else if has("pull-up", "chin-up", "pulldown") { self = .verticalPull }
        else if has("row") { self = .horizontalPull }
        else if has("leg curl", "nordic", "sliding curl", "glute-ham raise") { self = .legCurl }
        else if has("curl", "21s", "wrist roller") { self = .armCurl }
        else if has("pushdown", "triceps extension", "skull crusher") { self = .tricepsExtension }
        else if has("dip") { self = .dip }
        else if has("leg extension", "sissy squat") { self = .quadIsolation }
        else if has("lunge", "split squat", "step-up") { self = .lunge }
        else if has("squat", "leg press") { self = .squat }
        else if has("deadlift", "rack pull", "block pull", "back extension", "good morning") { self = .hinge }
        else if has("bridge", "hip thrust", "frog pump") { self = .bridge }
        else if has("kickback", "abduction", "side kick", "clamshell") { self = .gluteIsolation }
        // The adduction machine and cable (2026-10-10): single-joint inner-thigh
        // work, isolation like the abductions, matched first with each other.
        else if has("adduction") { self = .hipAdduction }
        else if has("crunch", "sit-up", "v-up") { self = .crunch }
        else if has("leg raise", "knee raise", "toe-to-bar", "flutter kick", "scissor kick") { self = .legRaise }
        // Side bends file with the twists and chops: oblique work either way.
        else if has("twist", "wood chop", "cable rotation", "landmine rotation", "landmine 180", "side bend") {
            self = .trunkRotation
        }
        else if has("rollout", "body saw") { self = .rollout }
        else if has("thruster", "clean and press", "clean and jerk", "power clean", "hang clean", "snatch") {
            self = .olympicLift
        }
        else if has("dead bug", "bird dog", "hollow body", "mountain climber") { self = .coreStability }
        else if has("fly", "crossover") { self = .fly }
        else if has("overhead press", "shoulder press", "push press", "z press", "viking press", "arnold press",
                    "behind-the-neck press", "half-kneeling landmine press", "standing dumbbell press",
                    "seated dumbbell press") { self = .verticalPress }
        else if has("press", "push-up") { self = .horizontalPress }
        else { self = .other }
    }

    /// Patterns that only ever swap among themselves.
    var isOwnKind: Bool { [.carry, .hold, .shrug, .cuffRotation].contains(self) }

    /// Single-joint work, which takes lighter loads for more reps.
    var isIsolation: Bool {
        [.shrug, .cuffRotation, .rearDelt, .lateralRaise, .frontRaise, .pullover, .fly, .armCurl,
         .tricepsExtension, .legCurl, .quadIsolation, .gluteIsolation, .hipAdduction, .calfRaise, .tibialisRaise,
         .crunch, .legRaise, .trunkRotation]
            .contains(self)
    }
}

enum ExerciseRotation {

    /// What a pick is judged against.
    struct Context {
        var group: MuscleGroup
        var level: PresetLevel
        /// The last day each exercise had a completed set.
        var lastDone: [String: Date]
        /// Parts still recovering, in any group.
        var tired: Set<MusclePart> = []
        /// Exercises the user saved with the heart.
        var saved: Set<String> = []
        /// The hardest a pick for a saved preset may be: the hardest exercise
        /// the user saved in it, so swaps don't climb a level at a time.
        var ceiling: Difficulty = .intermediate
        var now = Date()
    }

    /// The part of `group` an exercise works hardest as a primary mover, by
    /// its activation data; else the first part of the group it works.
    static func mainPart(of name: String, in group: MuscleGroup) -> MusclePart? {
        if let exercise = ExerciseCatalog.exercise(named: name), let content = SampleData.content(for: exercise) {
            let parts = content.activation.compactMap { muscle -> (part: MusclePart, primary: Bool, share: Double)? in
                guard let part = MusclePart(muscleName: muscle.name), part.group == group else { return nil }
                return (part, muscle.rank == .primary, muscle.fraction)
            }
            if let best = parts.max(by: { ($0.primary ? 1 : 0, $0.share) < ($1.primary ? 1 : 0, $1.share) }) {
                return best.part
            }
        }
        return ExerciseCatalog.partContributions(forExerciseNamed: name).first { $0.part.group == group }?.part
    }

    /// Another exercise for `name`'s row, or nil when there is none.
    ///
    /// Tried in order: the same movement pattern at the list's level, first
    /// keeping out `avoid` (the list, what this visit has shown, the rest of
    /// the day), then only `fallback` (the list and the rest of the day), so
    /// a long run of swaps comes back round rather than running dry; the
    /// same pattern at any level for Advanced; then any exercise for the
    /// same part of the group at the list's level. Basic never hands out an
    /// advanced lift, and a saved preset keeps under its ceiling.
    static func replacement(for name: String, context: Context, avoid: Set<String>,
                            thenAvoid fallback: Set<String>) -> String? {
        var generator = SystemRandomNumberGenerator()
        return replacement(for: name, context: context, avoid: avoid, thenAvoid: fallback, using: &generator)
    }

    static func replacement(for name: String, context: Context, avoid: Set<String>, thenAvoid fallback: Set<String>,
                            using generator: inout some RandomNumberGenerator) -> String? {
        let measure = ExerciseCatalog.measure(forExerciseNamed: name)
        let pattern = MovementPattern(exerciseNamed: name)
        let part = mainPart(of: name, in: context.group)
        let candidates = SampleData.trainableExercises.filter { exercise in
            exercise.name != name
                && ExerciseCatalog.measure(forExerciseNamed: exercise.name) == measure
                && ExerciseCatalog.role(of: context.group, in: exercise) == .primary
        }
        let samePattern = candidates.filter { MovementPattern(exerciseNamed: $0.name) == pattern }
        let samePart = pattern.isOwnKind ? [] : candidates.filter { exercise in
            !MovementPattern(exerciseNamed: exercise.name).isOwnKind
                && (part == nil || ExerciseCatalog.partContributions(forExerciseNamed: exercise.name)
                        .contains { $0.part == part && $0.role == .primary })
        }
        let fitting = { (list: [Exercise]) in list.filter { fits($0, context) } }
        let open = { (list: [Exercise], kept: Set<String>) in list.filter { !kept.contains($0.name) } }

        var tiers = [open(fitting(samePattern), avoid), open(fitting(samePattern), fallback)]
        if context.level == .advanced {
            tiers += [open(samePattern, avoid), open(samePattern, fallback)]
        }
        tiers += [open(fitting(samePart), avoid), open(fitting(samePart), fallback)]
        guard let pool = tiers.first(where: { !$0.isEmpty }) else { return nil }

        // Shuffled first, so equal scores don't fall back to library order.
        let ranked = pool.shuffled(using: &generator)
            .map { (name: $0.name, score: score($0, context, slot: part)) }
            .sorted { $0.score > $1.score }
        guard let best = ranked.first else { return nil }
        // Anything within 10 of the best can come up, the better the likelier.
        let band = ranked.filter { $0.score >= best.score - 10 }
        let weights = band.map { $0.score - (best.score - 10) + 1 }
        var roll = Double.random(in: 0..<weights.reduce(0, +), using: &generator)
        for (entry, weight) in zip(band, weights) {
            if roll < weight { return entry.name }
            roll -= weight
        }
        return band.last?.name
    }

    /// Basic: beginner exercises, intermediate ones on machines and cables,
    /// and intermediate dumbbell isolation work — what "machines and
    /// supported positions" means. Advanced: any. A saved preset: up to its
    /// ceiling.
    static func fits(_ exercise: Exercise, _ context: Context) -> Bool {
        switch context.level {
        case .basic:
            switch exercise.difficulty {
            case .beginner: return true
            case .advanced: return false
            case .intermediate:
                return ["MACHINE", "CABLE"].contains(exercise.equipment)
                    || (exercise.equipment == "DUMBBELL" && MovementPattern(exerciseNamed: exercise.name).isIsolation)
            }
        case .advanced:
            return true
        case .mine, .mine2, .mine3:
            return rank(exercise.difficulty) <= rank(context.ceiling)
        }
    }

    static func rank(_ difficulty: Difficulty) -> Int {
        switch difficulty {
        case .beginner: return 0
        case .intermediate: return 1
        case .advanced: return 2
        }
    }

    /// How fresh the exercise is for the user (never done, or not for four
    /// weeks, counts as 28; anything done this week sinks to the bottom),
    /// plus 10 for a saved one and 8 toward the harder lifts on Advanced,
    /// less 30 when it leans on a muscle still recovering other than the
    /// part the row is for — every candidate shares that one.
    static func score(_ exercise: Exercise, _ context: Context, slot: MusclePart?) -> Double {
        var score: Double
        if let last = context.lastDone[exercise.name] {
            let days = context.now.timeIntervalSince(last) / 86_400
            score = days < 7 ? days - 20 : min(days, 28)
        } else {
            score = 28
        }
        if context.saved.contains(exercise.name) { score += 10 }
        if context.level == .advanced && exercise.difficulty != .beginner { score += 8 }
        let others = ExerciseCatalog.partContributions(for: exercise)
            .filter { $0.role == .primary && $0.part != slot }.map(\.part)
        if others.contains(where: context.tired.contains) { score -= 30 }
        return score
    }

    /// The target for `name` when it replaces an exercise of another
    /// pattern: its own preset target if a preset lists it, else 8-12 for
    /// compound lifts, 12-15 for isolation work, the default hold for a
    /// timed exercise.
    static func target(for name: String) -> RepRange {
        if let preset = PresetProvider.target(forExerciseNamed: name) { return preset }
        let measure = ExerciseCatalog.measure(forExerciseNamed: name)
        guard measure == .reps else { return measure.defaultTarget }
        return MovementPattern(exerciseNamed: name).isIsolation ? RepRange(12, 15) : RepRange(8, 12)
    }
}
