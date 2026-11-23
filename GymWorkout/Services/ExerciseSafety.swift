//
//  ExerciseSafety.swift
//  GymWorkout
//
//  Which exercises suit someone's onboarding health answers (2026-11-21).
//  An exercise that tends to aggravate a joint or a condition is "not
//  advised": the built-in presets swap it for a kinder one of the same
//  movement, swaps never offer it, and the library and the day's list mark
//  it — but it can always still be opened and done. The rules read the
//  exercise's name, movement pattern and equipment, like `MovementPattern`,
//  so new library entries sort themselves. General guidance, not a
//  diagnosis; the plan's health notes say when to see a doctor.
//
//  Sources: knee — the 2016 patellofemoral pain consensus (Crossley et al.,
//  BJSM) and OARSI 2019; lower back — NICE NG59 and McGill's Low Back
//  Disorders; shoulder — Kolber et al. 2010 and 2011 (J Strength Cond Res);
//  blood pressure and heart — Pescatello et al. 2019, AHA 2023, ACSM
//  screening (Riebe et al. 2015); bones — Too Fit To Fracture (Giangregorio
//  et al. 2014); pregnancy — ACOG Committee Opinion 804 (2020) and the 2019
//  Canadian guideline; after a birth — ACOG 804 and Goom, Donnelly &
//  Brockwell 2019. Wrist and elbow follow common rehab practice.
//

import Foundation

struct ExerciseSafety: Hashable {

    enum Concern: String, CaseIterable, Hashable {
        case knee, lowerBack, shoulder, wristElbow, bloodPressure, heart, osteoporosis
        /// Any time in pregnancy; `pregnancyLate` adds the second and third
        /// trimesters' rules.
        case pregnancy, pregnancyLate
        /// After a birth, before the check-up; `postpartumImpact` keeps only
        /// "no jumping" until 12 weeks once cleared.
        case postpartum, postpartumImpact

        /// "Not advised with knee pain".
        var notAdvised: String {
            switch self {
            case .knee: return String(localized: "Not advised with knee pain")
            case .lowerBack: return String(localized: "Not advised with lower back pain")
            case .shoulder: return String(localized: "Not advised with shoulder pain")
            case .wristElbow: return String(localized: "Not advised with wrist or elbow pain")
            case .bloodPressure: return String(localized: "Not advised with high blood pressure")
            case .heart: return String(localized: "Not advised with a heart condition")
            case .osteoporosis: return String(localized: "Not advised with osteoporosis")
            case .pregnancy, .pregnancyLate: return String(localized: "Not advised during pregnancy")
            case .postpartum, .postpartumImpact: return String(localized: "Not advised yet after the birth")
            }
        }

        /// The short form for a tag: "KNEE".
        var tag: String {
            switch self {
            case .knee: return String(localized: "KNEE", comment: "Tag: not advised with knee pain")
            case .lowerBack: return String(localized: "LOWER BACK", comment: "Tag: not advised with lower back pain")
            case .shoulder: return String(localized: "SHOULDER", comment: "Tag: not advised with shoulder pain")
            case .wristElbow: return String(localized: "WRIST", comment: "Tag: not advised with wrist or elbow pain")
            case .bloodPressure: return String(localized: "BLOOD PRESSURE", comment: "Tag: not advised with high blood pressure")
            case .heart: return String(localized: "HEART", comment: "Tag: not advised with a heart condition")
            case .osteoporosis: return String(localized: "BONES", comment: "Tag: not advised with osteoporosis")
            case .pregnancy, .pregnancyLate: return String(localized: "PREGNANCY", comment: "Tag: not advised during pregnancy")
            case .postpartum, .postpartumImpact: return String(localized: "AFTER BIRTH", comment: "Tag: not advised yet after a birth")
            }
        }
    }

    /// In the order the answers were given.
    let concerns: [Concern]

    init(health: HealthAnswers?) {
        var concerns: [Concern] = []
        guard let health else { self.concerns = []; return }
        for joint in health.joints {
            switch joint {
            case .knee: concerns.append(.knee)
            case .lowerBack: concerns.append(.lowerBack)
            case .shoulder: concerns.append(.shoulder)
            case .wristElbow: concerns.append(.wristElbow)
            }
        }
        if health.has(.highBloodPressure) { concerns.append(.bloodPressure) }
        if health.has(.heartDisease) { concerns.append(.heart) }
        if health.has(.osteoporosis) { concerns.append(.osteoporosis) }
        if health.isPregnant {
            concerns.append(.pregnancy)
            // An unknown trimester takes the stricter rules.
            if (health.trimester ?? 2) >= 2 { concerns.append(.pregnancyLate) }
        } else if health.isPostpartum {
            if health.isPostpartumUncleared {
                concerns.append(.postpartum)
            } else if health.postpartumStage?.isBeforeImpact ?? true {
                concerns.append(.postpartumImpact)
            }
        }
        self.concerns = concerns
    }

    init(profile: UserProfile?) {
        self.init(health: profile?.health)
    }

    static let none = ExerciseSafety(health: nil)

    var isEmpty: Bool { concerns.isEmpty }

    /// No sets under 10 reps with high blood pressure, a heart condition or
    /// in pregnancy: no maximal efforts, no breath-holding.
    var minimumReps: Int? {
        concerns.contains { [.bloodPressure, .heart, .pregnancy].contains($0) } ? 10 : nil
    }

    // MARK: - Reading

    /// The concerns an exercise isn't advised for; empty when it suits.
    func concerns(for name: String) -> [Concern] {
        guard !concerns.isEmpty else { return [] }
        let exercise = ExerciseCatalog.exercise(named: name)
        let resolved = exercise?.name ?? name
        let equipment = exercise?.equipment ?? ""
        let pattern = MovementPattern(exerciseNamed: resolved)
        var hits: [Concern] = []
        for concern in concerns where Self.excludes(concern, resolved, equipment, pattern) {
            // One tag for pregnancy, one for after the birth.
            if concern == .pregnancyLate && hits.contains(.pregnancy) { continue }
            hits.append(concern == .pregnancyLate ? .pregnancy : concern == .postpartumImpact ? .postpartum : concern)
        }
        return hits
    }

    func isAdvised(_ name: String) -> Bool { concerns(for: name).isEmpty }

    /// One of the kinder exercises the plan leans on for these concerns.
    func isPreferred(_ name: String) -> Bool {
        let resolved = ExerciseCatalog.exercise(named: name)?.name ?? name
        return concerns.contains { Self.preferred[$0]?.contains(resolved) == true }
    }

    /// "NOT ADVISED · KNEE", with "+1" for more, for a library row.
    func tag(for name: String) -> String? {
        let hits = concerns(for: name)
        guard let first = hits.first else { return nil }
        let more = hits.count > 1 ? " +\(hits.count - 1)" : ""
        return String(localized: "NOT ADVISED · \(first.tag)\(more)",
                      comment: "Library tag: an exercise not advised for the user's answers, e.g. NOT ADVISED · KNEE")
    }

    /// The target with the rep floor applied: 6-10 becomes 10-12.
    func adjusted(_ range: RepRange, measure: SetMeasure) -> RepRange {
        guard let floor = minimumReps, measure == .reps, range.lower < floor else { return range }
        return RepRange(floor, max(range.upper, floor + 2))
    }

    // MARK: - Presets

    /// A built-in preset with every exercise that isn't advised swapped for
    /// one of the same movement that is (or dropped when there is none), and
    /// the rep floor applied. The swap is seeded by the preset, so a list
    /// comes out the same each time it is opened.
    func adapted(_ items: [PresetItem], group: MuscleGroup, level: PresetLevel) -> [PresetItem] {
        adaptation(of: items, group: group, level: level).items
    }

    /// `adapted` with what it swapped: (taken out, put in or nil if dropped).
    func adaptation(of items: [PresetItem], group: MuscleGroup,
                    level: PresetLevel) -> (items: [PresetItem], swaps: [(removed: String, added: String?)]) {
        guard !concerns.isEmpty else { return (items, []) }
        var result: [PresetItem] = []
        var swaps: [(removed: String, added: String?)] = []
        let original = Set(items.map(\.exerciseName))
        for item in items {
            let measure = ExerciseCatalog.measure(forExerciseNamed: item.exerciseName)
            if isAdvised(item.exerciseName) {
                result.append(PresetItem(exerciseName: item.exerciseName, sets: item.sets,
                                         reps: adjusted(item.reps, measure: measure)))
                continue
            }
            guard let swap = replacement(for: item.exerciseName, group: group, level: level,
                                         avoid: original.union(result.map(\.exerciseName))) else {
                swaps.append((item.exerciseName, nil))
                continue
            }
            let samePattern = MovementPattern(exerciseNamed: swap) == MovementPattern(exerciseNamed: item.exerciseName)
            let swapMeasure = ExerciseCatalog.measure(forExerciseNamed: swap)
            let reps = samePattern && swapMeasure == measure ? item.reps : ExerciseRotation.target(for: swap)
            result.append(PresetItem(exerciseName: swap, sets: item.sets, reps: adjusted(reps, measure: swapMeasure)))
            swaps.append((item.exerciseName, swap))
        }
        return (result, swaps)
    }

    /// What the preset swaps in for `name`, seeded by the names involved.
    func replacement(for name: String, group: MuscleGroup, level: PresetLevel, avoid: Set<String>) -> String? {
        var generator = SeededGenerator(seed: "\(group.rawValue)|\(level.rawValue)|\(name)")
        let context = ExerciseRotation.Context(group: group, level: level, lastDone: [:], safety: self)
        return ExerciseRotation.replacement(for: name, context: context, avoid: avoid, thenAvoid: avoid,
                                            using: &generator)
    }

    /// Each built-in preset's swaps for these answers, for the plan page:
    /// (taken out, put in), one per exercise, in group order.
    func presetSwaps(levels: [PresetLevel], groups: [MuscleGroup] = PresetProvider.trainableGroups)
        -> [(removed: String, added: String?)] {
        var swaps: [(removed: String, added: String?)] = []
        var seen: Set<String> = []
        for group in groups {
            for level in levels {
                guard let items = PresetProvider.preset(for: group, level: level)?.items else { continue }
                for swap in adaptation(of: items, group: group, level: level).swaps
                where seen.insert(swap.removed).inserted {
                    swaps.append(swap)
                }
            }
        }
        return swaps
    }

    /// How many library exercises each concern leaves out.
    func excludedCount(for concern: Concern) -> Int {
        let single = ExerciseSafety(concerns: concern == .pregnancy && concerns.contains(.pregnancyLate)
                                    ? [.pregnancy, .pregnancyLate] : [concern])
        return SampleData.exercises.filter { !single.isAdvised($0.name) }.count
    }

    private init(concerns: [Concern]) {
        self.concerns = concerns
    }

    // MARK: - Rules

    private static func excludes(_ concern: Concern, _ name: String, _ equipment: String,
                                 _ pattern: MovementPattern) -> Bool {
        let n = name.lowercased()
        func has(_ words: String...) -> Bool { words.contains { n.contains($0) } }
        let olympic = pattern == .olympicLift || has("push press", "overhead squat")
        let impact = has("jump", "burpee", "plyometric", "medicine ball slam", "chest pass", "medicine ball push-up")
        let maximalPull = has("deficit deadlift", "snatch-grip deadlift", "rack pull", "block pull")
        let weightedBodyweight = has("weighted pull-up", "weighted chin-up", "weighted chest dip")

        switch concern {
        case .knee:
            // Landings, Olympic catches, deep single-leg squats, twisting
            // lunges, and lunges that brake on the front knee.
            return has("jump", "burpee") || olympic
                || has("pistol", "sissy", "cossack", "cyclist squat", "curtsy", "front-foot-elevated")
                || has("walking lunge", "forward lunge") || name == "Lunge"

        case .lowerBack:
            if olympic || has("jump", "burpee", "medicine ball slam") || maximalPull { return true }
            // Barbell hinges, good mornings and swings.
            if pattern == .hinge && (["BARBELL", "TRAP BAR"].contains(equipment) || has("good morning", "kettlebell swing")) {
                return true
            }
            // Rows bent over without the chest supported.
            if pattern == .horizontalPull
                && (["BARBELL", "LANDMINE"].contains(equipment)
                    || has("dumbbell bent-over row", "gorilla row", "renegade row") || name == "Dumbbell Row")
                && !has("single-arm landmine row", "meadows row", "inverted row", "seal row") {
                return true
            }
            // A bar on the back or the shoulders, or pressed overhead standing.
            if [.squat, .lunge].contains(pattern)
                && (["BARBELL", "SAFETY BAR"].contains(equipment) || has("smith machine"))
                && !has("box squat", "landmine squat") {
                return true
            }
            // Pressed overhead standing (seated presses stay).
            if has("zercher", "overhead carry")
                || (pattern == .verticalPress && equipment == "BARBELL" && !has("seated", "z press")) {
                return true
            }
            // Loaded bending and twisting, and hip-flexor pulls on the spine.
            return has("sit-up", "v-up", "toe touch crunch", "russian twist", "landmine 180", "windmill",
                       "hanging leg raise", "toe-to-bar", "lying leg raise", "flutter kick", "scissor kick",
                       "ab wheel", "stability ball rollout", "body saw", "side bend")

        case .shoulder:
            if olympic { return true }
            if pattern == .verticalPress && !has("landmine") { return true }
            if pattern == .uprightRow || pattern == .dip { return true }
            if has("pullover", "behind-the-neck", "lu raise", "overhead carry", "overhead cable curl") { return true }
            if pattern == .tricepsExtension && has("overhead") { return true }
            return has("wide-grip chest press", "archer", "plyometric push-up", "medicine ball push-up",
                       "weighted pull-up", "weighted chin-up", "toe-to-bar", "battle rope slams", "medicine ball slam")

        case .wristElbow:
            if olympic || has("front squat", "zercher") { return true }
            return has("wrist curl", "wrist roller", "finger curl", "plate pinch", "towel grip", "zottman",
                       "reverse curl", "reverse preacher", "skull crusher",
                       "diamond push-up", "archer push-up", "plyometric push-up", "bench dip", "renegade row",
                       "plank shoulder tap", "bear crawl", "body saw")

        case .bloodPressure, .heart:
            if olympic || maximalPull || weightedBodyweight { return true }
            // Head below the heart.
            return has("decline")
                && (pattern == .horizontalPress || pattern == .crunch || pattern == .fly || has("push-up", "sit-up"))
                && !has("decline chest press machine")

        case .osteoporosis:
            if impact || olympic { return true }
            if (pattern == .crunch || pattern == .trunkRotation) && !has("pallof") { return true }
            if pattern == .legRaise && has("toe-to-bar", "hanging") { return true }
            return has("good morning", "windmill", "rollout", "body saw")

        case .pregnancy:
            return impact || olympic || maximalPull || weightedBodyweight

        case .pregnancyLate:
            // Crunches, leg raises, rollouts, twists and climbers: pressure on
            // the stretched belly wall.
            if [.crunch, .legRaise, .rollout].contains(pattern)
                || has("hollow body", "v-up", "russian twist", "landmine 180", "windmill", "wood chop",
                       "cable rotation", "landmine rotation", "mountain climber") {
                return true
            }
            if has("pistol", "cossack", "single-leg romanian deadlift", "archer") { return true }
            // Lying face down.
            if has("lying leg curl", "single-leg curl", "seal row", "chest-supported dumbbell row", "reverse hyperextension",
                   "spider curl", "incline lateral raise", "chest-supported lateral raise", "y-raise", "kneeling leg curl",
                   "incline bench cable kickback") {
                return true
            }
            // Lying flat on the back.
            if has("bench press", "floor press", "dumbbell fly", "skull crusher", "lying cable curl", "dead bug",
                   "glute bridge", "frog pump", "pullover", "close-grip bench", "squeeze press", "lying leg raise",
                   "flutter kick", "scissor kick", "hollow body", "crunch", "sit-up", "v-up", "swiss ball leg curl",
                   "sliding leg curl", "sliding curl", "larsen press", "neutral-grip dumbbell press", "vertical leg press")
                && !has("incline", "reverse dumbbell fly") {
                return true
            }
            return has("decline") && !has("decline chest press machine")

        case .postpartum:
            if impact || olympic || maximalPull { return true }
            return [.crunch, .legRaise, .rollout].contains(pattern)
                || has("hollow body", "v-up", "russian twist", "landmine 180", "weighted plank", "rkc plank",
                       "wood chop", "cable rotation", "landmine rotation", "mountain climber")

        case .postpartumImpact:
            return has("jump", "burpee")
        }
    }

    /// The kinder exercises each concern leans on, by library name.
    private static let preferred: [Concern: Set<String>] = [
        .knee: ["Glute Bridge", "Barbell Hip Thrust", "Dumbbell Hip Thrust", "Machine Hip Thrust", "Romanian Deadlift",
                "Dumbbell Romanian Deadlift", "Seated Leg Curl", "Lying Leg Curl", "Hip Abduction Machine", "Clamshell",
                "Box Squat", "Reverse Lunge", "Split Squat"],
        .lowerBack: ["Crunch", "Side Plank", "Bird Dog", "Dead Bug", "Pallof Press", "Seal Row",
                     "Chest-Supported Row Machine", "Chest-Supported Dumbbell Row", "Machine Seated Row", "Belt Squat",
                     "Barbell Hip Thrust", "Glute Bridge", "Lat Pulldown", "Seated Cable Row"],
        .shoulder: ["Landmine Shoulder Press", "Half-Kneeling Landmine Press", "Single-Arm Landmine Press",
                    "Landmine Chest Press", "Neutral-Grip Dumbbell Press", "Dumbbell Floor Press", "Barbell Floor Press",
                    "Cable External Rotation", "Face Pull", "Reverse Pec Deck", "Seated Cable Row",
                    "Chest-Supported Row Machine"],
        .wristElbow: ["Cable Hammer Curl", "Rope Hammer Curl", "Alternating Hammer Curl", "Machine Biceps Curl",
                      "Rope Pushdown", "Neutral-Grip Dumbbell Press", "Chest Press Machine", "Neutral-Grip Lat Pulldown"],
        .bloodPressure: ["Plank", "Side Plank", "Chest Press Machine", "Leg Press", "Seated Cable Row"],
        .heart: ["Plank", "Side Plank", "Chest Press Machine", "Leg Press", "Seated Cable Row"],
        .osteoporosis: ["Back Extension", "Bird Dog", "Plank", "Side Plank", "Pallof Press", "Farmer's Carry",
                        "Goblet Squat"],
        .pregnancy: ["Incline Dumbbell Press", "Chest Press Machine", "Seated Cable Row", "Lat Pulldown", "Goblet Squat",
                     "Barbell Hip Thrust", "Side-Lying Hip Abduction", "Clamshell", "Bird Dog", "Pallof Press",
                     "Side Plank"],
        .postpartum: ["Dead Bug", "Bird Dog", "Glute Bridge", "Side-Lying Hip Abduction", "Pallof Press", "Clamshell"],
    ]
}

/// A repeatable random sequence (SplitMix64) seeded from a string by FNV-1a,
/// so a preset's swaps come out the same on every open.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: String) {
        var hash: UInt64 = 0xcbf2_9ce4_8422_2325
        for byte in seed.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 0x0000_0100_0000_01B3
        }
        state = hash
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}
