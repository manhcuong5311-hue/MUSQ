//
//  ExerciseCatalog.swift
//  GymWorkout
//
//  Read-only lookups over the existing exercise database (`SampleData`):
//  which muscles an exercise loads, which exercises train a group, and how to
//  perform one. Nothing here duplicates exercise data.
//

import Foundation

enum ExerciseCatalog {

    static func exercise(named name: String) -> Exercise? {
        byName[name]
    }

    /// How an exercise loads each muscle part.
    ///
    /// Taken from the exercise's authored activation data (primary/secondary
    /// ranks); an exercise without trainer content falls back to its library
    /// label as the single primary muscle. When two anatomical muscles land on
    /// the same part, the stronger role wins.
    static func partContributions(for exercise: Exercise) -> [MusclePartContribution] {
        if let cached = partCache[exercise.name] { return cached }
        var roles: [MusclePart: ContributionRole] = [:]
        if let content = SampleData.content(for: exercise) {
            for muscle in content.activation {
                guard let part = MusclePart(muscleName: muscle.name) else { continue }
                let role: ContributionRole = muscle.rank == .primary ? .primary : .secondary
                if roles[part] != .primary { roles[part] = role }
            }
        }
        if roles.isEmpty, let part = MusclePart(muscleName: exercise.primaryMuscle) {
            roles[part] = .primary
        }
        let result = roles
            .map { MusclePartContribution(part: $0.key, role: $0.value) }
            .sorted { (rank($0.role), order($0.part)) < (rank($1.role), order($1.part)) }
        partCache[exercise.name] = result
        return result
    }

    static func partContributions(forExerciseNamed name: String) -> [MusclePartContribution] {
        exercise(named: name).map { partContributions(for: $0) } ?? []
    }

    /// How an exercise loads each muscle group: its parts rolled up, the
    /// stronger role winning when two parts share a group.
    static func contributions(for exercise: Exercise) -> [ExerciseMuscleContribution] {
        if let cached = contributionCache[exercise.name] { return cached }
        var roles: [MuscleGroup: ContributionRole] = [:]
        for contribution in partContributions(for: exercise) where roles[contribution.part.group] != .primary {
            roles[contribution.part.group] = contribution.role
        }
        let result = roles
            .map { ExerciseMuscleContribution(muscle: $0.key, role: $0.value) }
            .sorted { (rank($0.role), $0.muscle.rawValue) < (rank($1.role), $1.muscle.rawValue) }
        contributionCache[exercise.name] = result
        return result
    }

    static func contributions(forExerciseNamed name: String) -> [ExerciseMuscleContribution] {
        exercise(named: name).map { contributions(for: $0) } ?? []
    }

    /// The parts a session for `group` mainly works: the group's own parts
    /// that its preset exercises train as a primary mover. Shoulders → front,
    /// side and rear delts; Back → lats and upper back (the lower back is
    /// trained by the hinge presets, not by back day). A group without
    /// presets falls back to all of its parts.
    static func mainParts(of group: MuscleGroup) -> [MusclePart] {
        if let cached = mainPartCache[group] { return cached }
        let names = PresetLevel.allCases
            .flatMap { PresetProvider.preset(for: group, level: $0)?.items ?? [] }
            .map(\.exerciseName)
        let primary = Set(names.flatMap { name in
            partContributions(forExerciseNamed: name)
                .filter { $0.role == .primary && $0.part.group == group }
                .map(\.part)
        })
        let result = primary.isEmpty ? group.parts : group.parts.filter(primary.contains)
        mainPartCache[group] = result
        return result
    }

    /// Exercises that train a group: primary movers first, then those that
    /// work it as a secondary muscle, each in library order.
    static func exercises(for group: MuscleGroup) -> [Exercise] {
        let primary = SampleData.exercises.filter { role(of: group, in: $0) == .primary }
        let secondary = SampleData.exercises.filter { role(of: group, in: $0) == .secondary }
        return primary + secondary
    }

    static func role(of group: MuscleGroup, in exercise: Exercise) -> ContributionRole? {
        contributions(for: exercise).first { $0.muscle == group }?.role
    }

    /// Whether sets of the exercise count reps or seconds held.
    static func measure(forExerciseNamed name: String) -> SetMeasure {
        timedExercises.contains(name) ? .time : .reps
    }

    /// No external load unless the user adds some (a vest, a plate). The
    /// towel hang is a hang from a bar, so it counts too, as do the ball,
    /// slider and band lifts of the 351-400 set (nothing to log in kilos).
    static func isBodyweight(_ name: String) -> Bool {
        guard let exercise = exercise(named: name) else { return false }
        return ["BODYWEIGHT", "BENCH", "TOWEL", "SWISS BALL", "SLIDERS", "BAND"].contains(exercise.equipment)
    }

    /// Step-by-step setup, from the exercise's trainer content.
    static func setupSteps(for exercise: Exercise) -> [String] {
        SampleData.content(for: exercise)?.setup ?? []
    }

    /// The form cues from the trainer content, as (title, what to do).
    static func formCues(for exercise: Exercise) -> [(title: String, text: String)] {
        SampleData.content(for: exercise)?.cues.map { ($0.title, $0.correct) } ?? []
    }

    // MARK: - Storage

    /// Holds and loaded carries, logged in seconds rather than reps (the
    /// 401-500 folder adds a calf raise hold, a walk on the toes, the hollow
    /// body hold, three held planks, two carry marches and the bear crawl).
    private static let timedExercises: Set<String> = ["Plank", "Side Plank",
                                                      "Farmer's Carry", "Suitcase Carry", "Overhead Carry",
                                                      "Plate Pinch Hold", "Dumbbell Static Hold",
                                                      "Barbell Static Hold", "Towel Grip Hold",
                                                      "Calf Raise Hold", "Farmer's Walk on Toes", "Hollow Body Hold",
                                                      "RKC Plank", "Weighted Plank", "Copenhagen Plank",
                                                      "Farmer Carry March", "Suitcase Carry March", "Bear Crawl"]

    private static let byName: [String: Exercise] =
        Dictionary(SampleData.exercises.map { ($0.name, $0) }, uniquingKeysWith: { first, _ in first })

    private static var contributionCache: [String: [ExerciseMuscleContribution]] = [:]
    private static var partCache: [String: [MusclePartContribution]] = [:]
    private static var mainPartCache: [MuscleGroup: [MusclePart]] = [:]

    private static func rank(_ role: ContributionRole) -> Int { role == .primary ? 0 : 1 }
    private static func order(_ part: MusclePart) -> Int { MusclePart.allCases.firstIndex(of: part) ?? 0 }
}
