//
//  TrainingModels.swift
//  GymWorkout
//
//  Domain types behind the Train and Muscles tabs: training muscle groups,
//  how an exercise loads them, presets, and the logged workout history.
//
//  Exercises themselves are NOT redefined here — `SampleData.exercises` is the
//  database, and workouts refer to an exercise by its (unique, stable) name.
//

import Foundation

// MARK: - Muscle groups

/// The groups the app plans and tracks training by. Coarser than the
/// anatomical names in `MuscleActivation` (e.g. "Anterior Deltoid" and
/// "Posterior Deltoid" are both Shoulders).
enum MuscleGroup: String, CaseIterable, Codable, Identifiable, Hashable {
    case chest, back, shoulders, biceps, triceps, forearms
    case abs, glutes, quads, hamstrings, calves, adductors

    var id: String { rawValue }

    var title: String {
        switch self {
        case .abs: return "Abs & Core"
        default: return rawValue.capitalized
        }
    }

    enum Area { case upper, lower, core }

    /// Used to compare a group against its neighbours ("less trained than
    /// your other upper-body muscle groups").
    var area: Area {
        switch self {
        case .chest, .back, .shoulders, .biceps, .triceps, .forearms: return .upper
        case .glutes, .quads, .hamstrings, .calves, .adductors: return .lower
        case .abs: return .core
        }
    }

    /// The group an anatomical muscle name belongs to — the group of its
    /// `MusclePart`, so the two can never disagree.
    init?(muscleName name: String) {
        guard let part = MusclePart(muscleName: name) else { return nil }
        self = part.group
    }

    /// The parts recovery tracks inside this group.
    var parts: [MusclePart] { MusclePart.allCases.filter { $0.group == self } }
}

/// The finer muscles recovery is tracked by. A group is only as tired as the
/// parts a session for it actually needs: a chest day works the front delts
/// as a helper, not the side or rear delts, so it must not rule out a
/// shoulder session the next day.
enum MusclePart: String, CaseIterable, Codable, Identifiable, Hashable {
    case chest
    case frontDelts, sideDelts, rearDelts
    case lats, upperBack, lowerBack
    case biceps, triceps, forearms, abs
    case glutes, quads, hamstrings, calves, adductors

    var id: String { rawValue }

    var group: MuscleGroup {
        switch self {
        case .chest: return .chest
        case .frontDelts, .sideDelts, .rearDelts: return .shoulders
        case .lats, .upperBack, .lowerBack: return .back
        case .biceps: return .biceps
        case .triceps: return .triceps
        case .forearms: return .forearms
        case .abs: return .abs
        case .glutes: return .glutes
        case .quads: return .quads
        case .hamstrings: return .hamstrings
        case .calves: return .calves
        case .adductors: return .adductors
        }
    }

    var title: String {
        switch self {
        case .frontDelts: return "Front delts"
        case .sideDelts: return "Side delts"
        case .rearDelts: return "Rear delts"
        case .lats: return "Lats"
        case .upperBack: return "Upper back"
        case .lowerBack: return "Lower back"
        default: return group.title
        }
    }

    /// Keyword-matched so the names already used across `SampleData` (and
    /// library meta labels such as `MID-BACK` or `POSTERIOR CHAIN`) all
    /// resolve without a lookup table per exercise. Order matters: the
    /// specific deltoid heads are tested before plain "deltoid".
    init?(muscleName name: String) {
        let n = name.lowercased()
        func has(_ words: String...) -> Bool { words.contains { n.contains($0) } }

        if has("biceps femoris", "hamstring", "semitendinosus", "semimembranosus") { self = .hamstrings }
        else if has("pector", "chest") { self = .chest }
        else if has("anterior deltoid", "front delt") { self = .frontDelts }
        else if has("posterior deltoid", "rear delt", "rotator cuff", "infraspinatus", "teres minor") { self = .rearDelts }
        else if has("deltoid", "delt") { self = .sideDelts }
        else if has("latissimus", "lats", "teres") { self = .lats }
        else if has("erector", "spinae", "lower back", "posterior chain") { self = .lowerBack }
        else if has("trapez", "rhomboid", "back") { self = .upperBack }
        else if has("glute") { self = .glutes }
        else if has("quad", "rectus femoris", "vastus") { self = .quads }
        else if has("adductor") { self = .adductors }
        else if has("abdomin", "oblique", "core", "abs") { self = .abs }
        else if has("brachioradialis", "forearm", "wrist", "grip") { self = .forearms }
        else if has("biceps", "brachialis") { self = .biceps }
        else if has("triceps") { self = .triceps }
        else if has("gastrocnemius", "soleus", "calf", "calves") { self = .calves }
        else { return nil }
    }
}

// MARK: - Exercise → muscle contribution

enum ContributionRole: String, Codable, Hashable {
    case primary, secondary

    /// Effective sets one completed set adds to a muscle in this role. The one
    /// place these weights live — change them here and every calculation,
    /// including newly logged history, follows.
    var defaultWeight: Double {
        switch self {
        case .primary: return 1.0
        case .secondary: return 0.5
        }
    }
}

struct ExerciseMuscleContribution: Codable, Hashable {
    let muscle: MuscleGroup
    let role: ContributionRole
    /// Effective sets per completed set.
    let weight: Double

    init(muscle: MuscleGroup, role: ContributionRole, weight: Double? = nil) {
        self.muscle = muscle
        self.role = role
        self.weight = weight ?? role.defaultWeight
    }
}

/// The same load at the finer level recovery uses: a bench press works the
/// chest as a primary mover and only the front delts (not all of Shoulders)
/// as a helper.
struct MusclePartContribution: Codable, Hashable {
    let part: MusclePart
    let role: ContributionRole
    /// Effective sets per completed set.
    let weight: Double

    init(part: MusclePart, role: ContributionRole, weight: Double? = nil) {
        self.part = part
        self.role = role
        self.weight = weight ?? role.defaultWeight
    }
}

// MARK: - Presets

enum PresetLevel: String, Codable, CaseIterable, Hashable {
    case basic, advanced

    var title: String { rawValue.uppercased() }
}

struct RepRange: Codable, Hashable {
    var lower: Int
    var upper: Int

    init(_ lower: Int, _ upper: Int) {
        self.lower = lower
        self.upper = max(lower, upper)
    }

    var label: String { lower == upper ? "\(lower)" : "\(lower)–\(upper)" }
}

struct PresetItem: Hashable {
    let exerciseName: String
    let sets: Int
    let reps: RepRange
}

struct ExercisePreset: Hashable {
    let group: MuscleGroup
    let level: PresetLevel
    let items: [PresetItem]
}

// MARK: - Workout history

struct WorkoutSet: Identifiable, Codable, Hashable {
    var id = UUID()
    var reps: Int
    var weight: Double? = nil
    var isCompleted = false
    /// When the set was marked done — what recovery times are measured from.
    var completedAt: Date? = nil
}

struct WorkoutExercise: Identifiable, Codable, Hashable {
    var id = UUID()
    /// Key into `SampleData.exercises`.
    var exerciseName: String
    /// The muscle group this exercise was planned under.
    var group: MuscleGroup
    var repRange: RepRange
    var sets: [WorkoutSet]
    /// Snapshot of how the exercise loads each muscle when it was logged, so
    /// history stays stable if the exercise data is edited later.
    var contributions: [ExerciseMuscleContribution]
    /// The same snapshot per `MusclePart`, for recovery. Nil in history saved
    /// before parts existed; recovery then looks the exercise up again.
    var partContributions: [MusclePartContribution]? = nil
    var isCompleted = false

    var completedSets: [WorkoutSet] { sets.filter(\.isCompleted) }
}

struct WorkoutSession: Identifiable, Codable, Hashable {
    var id = UUID()
    /// Start of the calendar day the session belongs to.
    var day: Date
    var exercises: [WorkoutExercise] = []
    /// Basic/Advanced per muscle group, keyed by `MuscleGroup.rawValue`.
    var levels: [String: PresetLevel] = [:]
    var completedAt: Date? = nil
    /// Effective completed sets per muscle, keyed by `MuscleGroup.rawValue`,
    /// saved when the workout is completed.
    var effectiveSets: [String: Double] = [:]

    var groups: [MuscleGroup] {
        var seen: [MuscleGroup] = []
        for exercise in exercises where !seen.contains(exercise.group) { seen.append(exercise.group) }
        return seen
    }

    var hasCompletedSets: Bool { exercises.contains { !$0.completedSets.isEmpty } }
}

// MARK: - Recovery

enum TrainingExperience: String, Codable, CaseIterable, Identifiable {
    case beginner, intermediate, advanced

    var id: String { rawValue }
    var title: String { rawValue.capitalized }
}

enum RecoveryStatus: Hashable {
    /// `partlyReady` is a group-level state: some of the parts a session for
    /// the group needs are still recovering, the rest are ready, so the group
    /// can be trained around them.
    case ready, partlyReady, almostReady, recovering

    var title: String {
        switch self {
        case .ready: return "Ready"
        case .partlyReady: return "Partly ready"
        case .almostReady: return "Almost ready"
        case .recovering: return "Recovering"
        }
    }

    var severity: Int {
        switch self {
        case .ready: return 0
        case .partlyReady: return 1
        case .almostReady: return 2
        case .recovering: return 3
        }
    }
}

/// How a part was worked on the day that counts for its recovery.
enum LoadKind: Hashable {
    /// Trained as a primary mover.
    case direct
    /// Only helped (a secondary mover), but in so many sets that it counts
    /// as training it.
    case heavyIndirect
    /// Only helped, in a moderate amount. Noted, never blocks training.
    case indirect

    /// Whether the load starts a full recovery window.
    var counts: Bool { self != .indirect }
}

/// One part's most relevant recent load and the estimate that follows.
struct MusclePartRecord: Identifiable, Hashable {
    let part: MusclePart
    let kind: LoadKind
    let lastTrainedAt: Date
    /// Effective sets on that day.
    let effectiveSets: Double
    let recoveryTargetHours: Double
    /// Indirect load tops out at `almostReady`.
    let status: RecoveryStatus
    let hoursRemaining: Double
    /// Exercises that loaded the part that day, in the order they were done.
    let exercises: [String]

    var id: MusclePart { part }
    /// Still recovering from load that counts as training it.
    var isTired: Bool { kind.counts && status != .ready }
}

/// A muscle group's recovery, built from its parts. The group is judged only
/// by `mainParts` — the parts a session for it actually trains — so leftover
/// fatigue in a helper part never locks the group.
struct MuscleTrainingRecord: Hashable {
    let muscle: MuscleGroup
    let lastTrainedAt: Date
    /// Effective sets on that day.
    let effectiveSets: Double
    let recoveryTargetHours: Double
    let status: RecoveryStatus
    /// Hours left until the estimate says "ready"; 0 once ready.
    let hoursRemaining: Double
    /// Every part of the group with a recent load, most fatigued first.
    var parts: [MusclePartRecord] = []
    /// The parts a session for this group mainly works.
    var mainParts: [MusclePart] = []

    /// Main parts still recovering from real training.
    var tiredParts: [MusclePartRecord] { parts.filter { $0.isTired && mainParts.contains($0.part) } }
    /// Main parts free to train.
    var readyParts: [MusclePart] {
        let tired = Set(tiredParts.map(\.part))
        return mainParts.filter { !tired.contains($0) }
    }
    /// Recent load that doesn't hold the group back: helper-only work, or
    /// training of a part the group's sessions don't target.
    var sideNotes: [MusclePartRecord] {
        parts.filter { $0.status != .ready && !($0.isTired && mainParts.contains($0.part)) }
    }
    /// Nothing in the group was trained directly — it only helped.
    var isIndirectOnly: Bool { parts.allSatisfy { $0.kind == .indirect } }
    /// The latest load that counted as training any part of the group.
    var lastCountedAt: Date? { parts.filter(\.kind.counts).map(\.lastTrainedAt).max() }
}
