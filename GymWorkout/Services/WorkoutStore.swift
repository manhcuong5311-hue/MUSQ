//
//  WorkoutStore.swift
//  GymWorkout
//
//  The single owner of workout history. Every change goes through here and is
//  written to a JSON file in Application Support, so history survives a
//  relaunch. The file format is plain Codable, which keeps it easy to swap for
//  SwiftData or iCloud later without touching the views.
//

import Foundation
import Observation

@Observable
final class WorkoutStore {

    private(set) var sessions: [WorkoutSession] = []
    var experience: TrainingExperience = .beginner {
        didSet { if experience != oldValue && !isLoading { save() } }
    }
    var unit: WeightUnit = .kg {
        didSet { if unit != oldValue && !isLoading { save() } }
    }
    var rest: RestSetting = .auto {
        didSet { if rest != oldValue && !isLoading { save() } }
    }

    @ObservationIgnored private var isLoading = false
    @ObservationIgnored private let fileURL: URL
    @ObservationIgnored private let calendar = Calendar.current

    init(fileURL: URL = WorkoutStore.defaultFileURL) {
        self.fileURL = fileURL
        load()
    }

    // MARK: - Reading

    func session(on day: Date) -> WorkoutSession? {
        let start = calendar.startOfDay(for: day)
        return sessions.first { $0.day == start }
    }

    func exercises(for group: MuscleGroup, on day: Date) -> [WorkoutExercise] {
        session(on: day)?.exercises.filter { $0.group == group } ?? []
    }

    func level(for group: MuscleGroup, on day: Date) -> PresetLevel? {
        session(on: day)?.levels[group.rawValue]
    }

    func exercise(id: UUID) -> WorkoutExercise? {
        for session in sessions {
            if let match = session.exercises.first(where: { $0.id == id }) { return match }
        }
        return nil
    }

    func day(ofExercise id: UUID) -> Date? {
        sessions.first { $0.exercises.contains { $0.id == id } }?.day
    }

    /// The exercise's sets the last earlier day it was done — what this
    /// session is trying to beat.
    func previousPerformance(forExercise id: UUID) -> PreviousPerformance? {
        guard let item = exercise(id: id), let day = day(ofExercise: id) else { return nil }
        return PerformanceHistory.previous(of: item.exerciseName, before: day, in: sessions)
    }

    /// Days with at least one completed set — the calendar's markers.
    var trainedDays: Set<Date> {
        Set(sessions.filter(\.hasCompletedSets).map(\.day))
    }

    var recoverySettings: RecoverySettings { RecoverySettings(experience: experience) }

    func recoveryRecords(at date: Date = Date()) -> [MuscleGroup: MuscleTrainingRecord] {
        RecoveryCalculator(settings: recoverySettings).records(from: sessions, now: date)
    }

    // MARK: - Presets → plan

    /// The exercises a preset would add, not yet saved. Pass these back to a
    /// mutation to save them with the same ids.
    func preview(_ group: MuscleGroup, level: PresetLevel) -> [WorkoutExercise] {
        (PresetProvider.preset(for: group, level: level)?.items ?? []).compactMap { item in
            makeExercise(item.exerciseName, group: group, sets: item.sets, reps: item.reps)
        }
    }

    /// Saves `planned` (usually a preview) as the group's plan for the day if
    /// the day has none for that group yet.
    func ensurePlan(_ group: MuscleGroup, on day: Date, level: PresetLevel,
                    planned: [WorkoutExercise]) {
        mutateSession(on: day) { session in
            session.levels[group.rawValue] = level
            guard !session.exercises.contains(where: { $0.group == group }) else { return }
            session.exercises.append(contentsOf: planned)
            // New work reopens a finished workout so it can be completed again.
            if !planned.isEmpty { session.completedAt = nil }
        }
    }

    /// Switches Basic/Advanced. Exercises already started are kept; the rest
    /// are replaced by the other preset.
    func switchLevel(_ group: MuscleGroup, on day: Date, to level: PresetLevel) {
        mutateSession(on: day) { session in
            session.levels[group.rawValue] = level
            let started = session.exercises.filter { $0.group == group && !$0.completedSets.isEmpty }
            let names = Set(started.map(\.exerciseName))
            session.exercises.removeAll { $0.group == group && $0.completedSets.isEmpty }
            let fresh = preview(group, level: level).filter { !names.contains($0.exerciseName) }
            session.exercises.append(contentsOf: fresh)
        }
    }

    /// "Add to Today" from the Muscles tab: the Basic preset, unless the group
    /// is already planned today.
    func addToToday(_ group: MuscleGroup) {
        let level = self.level(for: group, on: Date()) ?? .basic
        ensurePlan(group, on: Date(), level: level, planned: preview(group, level: level))
    }

    func removeGroup(_ group: MuscleGroup, on day: Date) {
        mutateSession(on: day) { session in
            session.exercises.removeAll { $0.group == group }
            session.levels[group.rawValue] = nil
        }
    }

    // MARK: - Editing the plan

    func addExercise(named name: String, to group: MuscleGroup, on day: Date) {
        let target = ExerciseCatalog.measure(forExerciseNamed: name).defaultTarget
        guard let exercise = makeExercise(name, group: group, sets: 3, reps: target) else { return }
        mutateSession(on: day) { session in
            session.exercises.append(exercise)
            session.completedAt = nil
        }
    }

    func removeExercise(id: UUID) {
        mutateExercises { $0.removeAll { $0.id == id } }
    }

    /// Swaps in another exercise with the same sets and target. Swapping
    /// between reps and a timed hold takes the new kind's default target.
    func replaceExercise(id: UUID, with name: String) {
        mutateExercise(id: id) { exercise in
            let measure = ExerciseCatalog.measure(forExerciseNamed: name)
            let target = measure == exercise.setMeasure ? exercise.repRange : measure.defaultTarget
            guard let replacement = makeExercise(name, group: exercise.group,
                                                 sets: exercise.sets.count, reps: target) else { return }
            exercise.exerciseName = replacement.exerciseName
            exercise.contributions = replacement.contributions
            exercise.partContributions = replacement.partContributions
            exercise.measure = replacement.measure
            exercise.repRange = replacement.repRange
            exercise.sets = replacement.sets
            exercise.isCompleted = false
        }
    }

    /// Reorders within one group's block, leaving other groups in place.
    func moveExercises(in group: MuscleGroup, on day: Date, from source: IndexSet, to destination: Int) {
        mutateSession(on: day) { session in
            let slots = session.exercises.indices.filter { session.exercises[$0].group == group }
            let block = slots.map { session.exercises[$0] }
            // Same semantics as SwiftUI's `move(fromOffsets:toOffset:)`.
            let moving = source.map { block[$0] }
            var reordered = block.enumerated().filter { !source.contains($0.offset) }.map(\.element)
            let insertAt = destination - source.filter { $0 < destination }.count
            reordered.insert(contentsOf: moving, at: min(max(insertAt, 0), reordered.count))
            for (slot, exercise) in zip(slots, reordered) { session.exercises[slot] = exercise }
        }
    }

    /// Changes the set count and rep target. Completed sets are never removed;
    /// unfinished sets take the new target's lower bound.
    func updateTarget(id: UUID, sets count: Int, reps range: RepRange) {
        mutateExercise(id: id) { exercise in
            exercise.repRange = range
            for index in exercise.sets.indices where !exercise.sets[index].isCompleted {
                exercise.sets[index].reps = range.lower
            }
            while exercise.sets.count < count {
                exercise.sets.append(WorkoutSet(reps: range.lower))
            }
            while exercise.sets.count > max(count, exercise.completedSets.count),
                  let last = exercise.sets.lastIndex(where: { !$0.isCompleted }) {
                exercise.sets.remove(at: last)
            }
        }
    }

    // MARK: - Logging sets

    /// Marks a set done or not done. A set marked done with no weight entered
    /// takes the weight shown as its placeholder — the same set last time —
    /// so repeating last session's load is a single tap.
    func toggleSet(exerciseID: UUID, setID: UUID) {
        guard let day = day(ofExercise: exerciseID) else { return }
        let stamp = completionTime(on: day)
        let previous = previousPerformance(forExercise: exerciseID)
        mutateExercise(id: exerciseID) { exercise in
            guard let index = exercise.sets.firstIndex(where: { $0.id == setID }) else { return }
            exercise.sets[index].isCompleted.toggle()
            exercise.sets[index].completedAt = exercise.sets[index].isCompleted ? stamp : nil
            if exercise.sets[index].isCompleted, exercise.sets[index].weight == nil, !exercise.isTimed,
               previous?.measure == exercise.setMeasure {
                exercise.sets[index].weight = previous?.set(at: index)?.weight
            }
            if !exercise.sets[index].isCompleted { exercise.isCompleted = false }
        }
    }

    func setReps(_ reps: Int, exerciseID: UUID, setID: UUID) {
        mutateExercise(id: exerciseID) { exercise in
            guard let index = exercise.sets.firstIndex(where: { $0.id == setID }) else { return }
            exercise.sets[index].reps = max(1, reps)
        }
    }

    /// Sets a set's weight, in kilograms (nil clears it). Later sets not yet
    /// done and still blank take the same weight, so a working weight is
    /// typed once.
    func setWeight(_ kg: Double?, exerciseID: UUID, setID: UUID) {
        mutateExercise(id: exerciseID) { exercise in
            guard let index = exercise.sets.firstIndex(where: { $0.id == setID }),
                  exercise.sets[index].weight != kg else { return }
            exercise.sets[index].weight = kg
            guard kg != nil else { return }
            for later in exercise.sets.indices where later > index
                && !exercise.sets[later].isCompleted && exercise.sets[later].weight == nil {
                exercise.sets[later].weight = kg
            }
        }
    }

    /// Saves a timed hold's length and marks the set done.
    func completeHold(seconds: Int, exerciseID: UUID, setID: UUID) {
        setReps(seconds, exerciseID: exerciseID, setID: setID)
        if exercise(id: exerciseID)?.sets.first(where: { $0.id == setID })?.isCompleted == false {
            toggleSet(exerciseID: exerciseID, setID: setID)
        }
    }

    func addSet(exerciseID: UUID) {
        mutateExercise(id: exerciseID) { exercise in
            exercise.sets.append(WorkoutSet(reps: exercise.sets.last?.reps ?? exercise.repRange.lower))
            exercise.isCompleted = false
        }
    }

    func removeSet(exerciseID: UUID, setID: UUID) {
        mutateExercise(id: exerciseID) { $0.sets.removeAll { $0.id == setID } }
    }

    func completeExercise(id: UUID) {
        mutateExercise(id: id) { $0.isCompleted = true }
    }

    /// Marks the day's workout finished and saves the effective sets it
    /// produced. Only completed sets count.
    func completeWorkout(on day: Date) {
        mutateSession(on: day) { session in
            session.completedAt = Date()
        }
    }

    /// Effective completed sets per muscle for one session.
    private static func effectiveSets(of session: WorkoutSession) -> [String: Double] {
        var totals: [String: Double] = [:]
        for exercise in session.exercises {
            let done = Double(exercise.completedSets.count)
            for contribution in exercise.contributions where done > 0 {
                totals[contribution.muscle.rawValue, default: 0] += done * contribution.weight
            }
        }
        return totals
    }

    /// Future days can be planned but not logged.
    func canLog(on day: Date) -> Bool {
        calendar.startOfDay(for: day) <= calendar.startOfDay(for: Date())
    }

    // MARK: - Helpers

    private func makeExercise(_ name: String, group: MuscleGroup, sets: Int, reps: RepRange) -> WorkoutExercise? {
        guard ExerciseCatalog.exercise(named: name) != nil else { return nil }
        return WorkoutExercise(
            exerciseName: name,
            group: group,
            repRange: reps,
            sets: (0..<max(1, sets)).map { _ in WorkoutSet(reps: reps.lower) },
            contributions: ExerciseCatalog.contributions(forExerciseNamed: name),
            partContributions: ExerciseCatalog.partContributions(forExerciseNamed: name),
            measure: ExerciseCatalog.measure(forExerciseNamed: name)
        )
    }

    /// Now for today; early evening of the day itself when logging a past day,
    /// so recovery is measured from that day rather than from today.
    private func completionTime(on day: Date) -> Date {
        let start = calendar.startOfDay(for: day)
        if start == calendar.startOfDay(for: Date()) { return Date() }
        return calendar.date(byAdding: .hour, value: 18, to: start) ?? start
    }

    private func mutateSession(on day: Date, _ change: (inout WorkoutSession) -> Void) {
        let start = calendar.startOfDay(for: day)
        if let index = sessions.firstIndex(where: { $0.day == start }) {
            change(&sessions[index])
            refreshSnapshot(&sessions[index])
            if sessions[index].exercises.isEmpty && sessions[index].completedAt == nil {
                sessions.remove(at: index)
            }
        } else {
            var session = WorkoutSession(day: start)
            change(&session)
            guard !session.exercises.isEmpty else { return }
            sessions.append(session)
            sessions.sort { $0.day < $1.day }
        }
        save()
    }

    private func mutateExercises(_ change: (inout [WorkoutExercise]) -> Void) {
        for index in sessions.indices {
            change(&sessions[index].exercises)
            refreshSnapshot(&sessions[index])
        }
        sessions.removeAll { $0.exercises.isEmpty && $0.completedAt == nil }
        save()
    }

    private func mutateExercise(id: UUID, _ change: (inout WorkoutExercise) -> Void) {
        for s in sessions.indices {
            if let e = sessions[s].exercises.firstIndex(where: { $0.id == id }) {
                change(&sessions[s].exercises[e])
                refreshSnapshot(&sessions[s])
                save()
                return
            }
        }
    }

    /// A completed workout's saved effective sets follow any later edit.
    private func refreshSnapshot(_ session: inout WorkoutSession) {
        session.effectiveSets = session.completedAt == nil ? [:] : Self.effectiveSets(of: session)
    }

    // MARK: - Persistence

    private struct Snapshot: Codable {
        var version = 1
        var experience: TrainingExperience
        /// Nil in files saved before the setting existed.
        var unit: WeightUnit?
        var rest: RestSetting?
        var sessions: [WorkoutSession]
    }

    static var defaultFileURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("Workouts", isDirectory: true)
            .appendingPathComponent("workouts.json")
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let snapshot = try? JSONDecoder.workouts.decode(Snapshot.self, from: data) else { return }
        isLoading = true
        sessions = snapshot.sessions.sorted { $0.day < $1.day }
        experience = snapshot.experience
        unit = snapshot.unit ?? .kg
        rest = snapshot.rest ?? .auto
        isLoading = false
    }

    private func save() {
        let snapshot = Snapshot(experience: experience, unit: unit, rest: rest, sessions: sessions)
        do {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            try JSONEncoder.workouts.encode(snapshot).write(to: fileURL, options: .atomic)
        } catch {
            assertionFailure("Couldn't save workouts: \(error)")
        }
    }
}

private extension JSONEncoder {
    static var workouts: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}

private extension JSONDecoder {
    static var workouts: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
