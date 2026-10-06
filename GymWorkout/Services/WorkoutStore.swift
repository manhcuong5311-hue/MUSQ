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
    /// The onboarding answers; nil until onboarding is finished.
    var profile: UserProfile? {
        didSet { if profile != oldValue && !isLoading { save() } }
    }
    /// Exercises saved with the heart, by name.
    private(set) var saved: Set<String> = []
    /// The user's own presets, keyed by `presetKey`: `MuscleGroup.rawValue`
    /// for Preset 1 (the one list earlier builds saved), "chest#2" and
    /// "chest#3" for the others.
    private(set) var customPresets: [String: [PresetItem]] = [:]

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
        guard let session = session(on: day) else { return nil }
        if let mine = session.mineGroups,
           let saved = PresetLevel.saved.first(where: { mine.contains(Self.presetKey(group, $0)) }) {
            return saved
        }
        return session.levels[group.rawValue]
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

    /// Workouts finished with Complete Workout. Ads wait for the first ones.
    var completedWorkoutCount: Int {
        sessions.reduce(0) { $0 + ($1.completedAt == nil ? 0 : 1) }
    }

    /// Days with at least one completed set — the calendar's markers.
    var trainedDays: Set<Date> {
        Set(sessions.filter(\.hasCompletedSets).map(\.day))
    }

    var recoverySettings: RecoverySettings { RecoverySettings(experience: experience) }

    /// The preset level a group opens on when the day doesn't have one yet.
    var suggestedLevel: PresetLevel {
        ProgramAdvisor.suggestedLevel(for: profile, experience: experience)
    }

    /// The list a group starts from: the user's first saved preset, else
    /// the suggested one.
    func defaultLevel(for group: MuscleGroup) -> PresetLevel {
        savedLevels(for: group).first ?? suggestedLevel
    }

    /// The last day each exercise had a completed set.
    var lastDoneDates: [String: Date] {
        var dates: [String: Date] = [:]
        for session in sessions {
            for exercise in session.exercises where !exercise.completedSets.isEmpty {
                dates[exercise.exerciseName] = max(dates[exercise.exerciseName] ?? .distantPast, session.day)
            }
        }
        return dates
    }

    /// The walk to suggest after a workout, for a weight-loss goal only.
    var walkSuggestion: WalkSuggestion? {
        guard let profile, profile.goal == .loseWeight else { return nil }
        return ProgramAdvisor.walk(for: profile, experience: experience)
    }

    func recoveryRecords(at date: Date = Date()) -> [MuscleGroup: MuscleTrainingRecord] {
        RecoveryCalculator(settings: recoverySettings).records(from: sessions, now: date)
    }

    /// The groups a full round of the Train tab's card edges has to cover:
    /// every group the split trains.
    var roundSplit: Set<MuscleGroup> {
        Set(ProgramAdvisor.rotation(for: profile).joined()).intersection(PresetProvider.trainableGroups)
    }

    /// The groups trained in the current round of the Train tab's card
    /// edges (see `TrainingRound`).
    func trainedThisRound(at date: Date = Date(), reset: TrainingRound.Reset) -> Set<MuscleGroup> {
        let days = RecoveryCalculator(settings: recoverySettings).trainingDays(from: sessions, now: date)
        return TrainingRound.trained(days: days, split: roundSplit, reset: reset, at: date)
    }

    // MARK: - Presets → plan

    /// The exercises a preset would add, not yet saved. Pass these back to a
    /// mutation to save them with the same ids.
    func preview(_ group: MuscleGroup, level: PresetLevel) -> [WorkoutExercise] {
        let items = level.isSaved
            ? customPresets[Self.presetKey(group, level)] ?? []
            : PresetProvider.preset(for: group, level: level)?.items ?? []
        return items.compactMap { item in
            makeExercise(item.exerciseName, group: group, sets: item.sets, reps: item.reps)
        }
    }

    /// Saves `planned` (usually a preview) as the group's plan for the day if
    /// the day has none for that group yet.
    func ensurePlan(_ group: MuscleGroup, on day: Date, level: PresetLevel,
                    planned: [WorkoutExercise]) {
        mutateSession(on: day) { session in
            // A group already on the day keeps its level: exercises added
            // from the library aren't the user's saved list, say.
            guard !session.exercises.contains(where: { $0.group == group }) else { return }
            setLevel(level, for: group, in: &session)
            session.exercises.append(contentsOf: planned)
            // New work reopens a finished workout so it can be completed again.
            if !planned.isEmpty { session.completedAt = nil }
        }
    }

    /// Switches Basic/Advanced. Exercises already started are kept; the rest
    /// are replaced by the other preset.
    func switchLevel(_ group: MuscleGroup, on day: Date, to level: PresetLevel) {
        mutateSession(on: day) { session in
            setLevel(level, for: group, in: &session)
            let started = session.exercises.filter { $0.group == group && !$0.completedSets.isEmpty }
            let names = Set(started.map(\.exerciseName))
            session.exercises.removeAll { $0.group == group && $0.completedSets.isEmpty }
            let fresh = preview(group, level: level).filter { !names.contains($0.exerciseName) }
            session.exercises.append(contentsOf: fresh)
        }
    }

    /// "Add to Today" from the Muscles tab: the user's first preset or the
    /// suggested one, unless the group is already planned today.
    func addToToday(_ group: MuscleGroup) {
        let level = self.level(for: group, on: Date()) ?? defaultLevel(for: group)
        ensurePlan(group, on: Date(), level: level, planned: preview(group, level: level))
    }

    /// Records which list a day's plan follows without touching its exercises
    /// — after saving the plan as the user's own list, say.
    func markLevel(_ level: PresetLevel, for group: MuscleGroup, on day: Date) {
        mutateSession(on: day) { setLevel(level, for: group, in: &$0) }
    }

    func removeGroup(_ group: MuscleGroup, on day: Date) {
        mutateSession(on: day) { session in
            session.exercises.removeAll { $0.group == group }
            session.levels[group.rawValue] = nil
            let keys = Self.presetKeys(group)
            session.mineGroups?.removeAll { keys.contains($0) }
            if session.mineGroups?.isEmpty == true { session.mineGroups = nil }
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
            if let replacement = swapped(exercise, to: name) { exercise = replacement }
        }
    }

    /// `exercise` with `name` in its place: the same id, group and set
    /// count, no sets done. The target stays when the new exercise moves the
    /// same way; otherwise it takes its own (a fly swapped in for a bench
    /// press doesn't keep 6-10 reps). For lists not saved to a day yet.
    func swapped(_ exercise: WorkoutExercise, to name: String) -> WorkoutExercise? {
        let measure = ExerciseCatalog.measure(forExerciseNamed: name)
        let samePattern = MovementPattern(exerciseNamed: name) == MovementPattern(exerciseNamed: exercise.exerciseName)
        let target = measure == exercise.setMeasure && samePattern ? exercise.repRange : ExerciseRotation.target(for: name)
        guard var replacement = makeExercise(name, group: exercise.group,
                                             sets: exercise.sets.count, reps: target) else { return nil }
        replacement.id = exercise.id
        return replacement
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

    func setWalkDone(_ done: Bool, on day: Date) {
        mutateSession(on: day) { $0.walkDone = done ? true : nil }
    }

    // MARK: - The user's own presets

    /// Where a saved preset lives in `customPresets` and `mineGroups`.
    static func presetKey(_ group: MuscleGroup, _ level: PresetLevel) -> String {
        guard let slot = level.slot, slot > 1 else { return group.rawValue }
        return "\(group.rawValue)#\(slot)"
    }

    private static func presetKeys(_ group: MuscleGroup) -> Set<String> {
        Set(PresetLevel.saved.map { presetKey(group, $0) })
    }

    /// The group's saved presets, Preset 1 first.
    func savedLevels(for group: MuscleGroup) -> [PresetLevel] {
        PresetLevel.saved.filter { customPresets[Self.presetKey(group, $0)] != nil }
    }

    /// The saved preset `exercises` are, if any: the same exercises, in any
    /// order, with the same sets and targets. Saved exercises no longer in
    /// the library are left out of the comparison.
    func matchingPreset(_ exercises: [WorkoutExercise], for group: MuscleGroup) -> PresetLevel? {
        let byName = { (a: PresetItem, b: PresetItem) in a.exerciseName < b.exerciseName }
        let items = exercises.map { Self.presetItem($0) }.sorted(by: byName)
        return savedLevels(for: group).first { level in
            let saved = (customPresets[Self.presetKey(group, level)] ?? [])
                .filter { ExerciseCatalog.exercise(named: $0.exerciseName) != nil }
            return !saved.isEmpty && saved.sorted(by: byName) == items
        }
    }

    /// A saved preset as it is now, to hand back to `restoreCustomPreset`
    /// for an undo. Nil when the slot is empty.
    func customPreset(for group: MuscleGroup, _ level: PresetLevel) -> [PresetItem]? {
        guard level.isSaved else { return nil }
        return customPresets[Self.presetKey(group, level)]
    }

    /// Puts back a saved preset (or its absence) captured before a change.
    func restoreCustomPreset(_ items: [PresetItem]?, for group: MuscleGroup, _ level: PresetLevel) {
        guard level.isSaved else { return }
        customPresets[Self.presetKey(group, level)] = items
        if items == nil { forgetPreset(group, level) }
        save()
    }

    /// Saves `exercises` as one of the group's presets. The group opens on
    /// its first saved preset.
    func saveCustomPreset(_ exercises: [WorkoutExercise], for group: MuscleGroup, as level: PresetLevel) {
        guard level.isSaved, !exercises.isEmpty else { return }
        customPresets[Self.presetKey(group, level)] = exercises.map { Self.presetItem($0) }
        save()
    }

    /// Deletes one of the group's presets. Days planned from it keep their
    /// exercises and read as the suggested preset from then on.
    func deleteCustomPreset(for group: MuscleGroup, _ level: PresetLevel) {
        guard level.isSaved else { return }
        customPresets[Self.presetKey(group, level)] = nil
        forgetPreset(group, level)
        save()
    }

    /// Days planned from a deleted preset read as the preset they fell back
    /// to (`levels`) once it is gone.
    private func forgetPreset(_ group: MuscleGroup, _ level: PresetLevel) {
        let key = Self.presetKey(group, level)
        for index in sessions.indices {
            sessions[index].mineGroups?.removeAll { $0 == key }
            if sessions[index].mineGroups?.isEmpty == true { sessions[index].mineGroups = nil }
        }
    }

    /// Records a group's level: Basic and Advanced in `levels`; a saved
    /// preset as its key in `mineGroups`, with the suggested preset in
    /// `levels` for builds that don't know it.
    private func setLevel(_ level: PresetLevel, for group: MuscleGroup, in session: inout WorkoutSession) {
        var mine = session.mineGroups ?? []
        let keys = Self.presetKeys(group)
        mine.removeAll { keys.contains($0) }
        if level.isSaved {
            mine.append(Self.presetKey(group, level))
            session.levels[group.rawValue] = suggestedLevel.isSaved ? .basic : suggestedLevel
        } else {
            session.levels[group.rawValue] = level
        }
        session.mineGroups = mine.isEmpty ? nil : mine
    }

    private static func presetItem(_ exercise: WorkoutExercise) -> PresetItem {
        PresetItem(exerciseName: exercise.exerciseName, sets: exercise.sets.count, reps: exercise.repRange)
    }

    // MARK: - Saved exercises

    func isSaved(_ name: String) -> Bool { saved.contains(name) }

    func toggleSaved(_ name: String) {
        if saved.contains(name) { saved.remove(name) } else { saved.insert(name) }
        save()
    }

    // MARK: - From the library

    /// The group an exercise is planned under when added from the library:
    /// the group of its library label (a deadlift's "posterior chain" is back
    /// work), else its first primary muscle.
    static func planningGroup(forExerciseNamed name: String) -> MuscleGroup? {
        if let exercise = ExerciseCatalog.exercise(named: name),
           let part = MusclePart(muscleName: exercise.primaryMuscle) {
            return part.group
        }
        return ExerciseCatalog.contributions(forExerciseNamed: name).first { $0.role == .primary }?.muscle
    }

    func isInToday(_ name: String) -> Bool {
        session(on: Date())?.exercises.contains { $0.exerciseName == name } ?? false
    }

    /// Adds the exercise to today's workout under its planning group, unless
    /// it is already there. Returns the group it lives under today.
    @discardableResult
    func addToToday(exerciseNamed name: String) -> MuscleGroup? {
        if let existing = session(on: Date())?.exercises.first(where: { $0.exerciseName == name }) {
            return existing.group
        }
        guard let group = Self.planningGroup(forExerciseNamed: name) else { return nil }
        addExercise(named: name, to: group, on: Date())
        return group
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
        var profile: UserProfile?
        var saved: [String]?
        /// Nil in files saved before the user's own presets existed.
        var customPresets: [String: [PresetItem]]?
        var sessions: [WorkoutSession]
    }

    static var defaultFileURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("Workouts", isDirectory: true)
            .appendingPathComponent("workouts.json")
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let snapshot = try? JSONDecoder.workouts.decode(Snapshot.self, from: data) else {
            // Set the history aside rather than let the next save write an
            // empty one over it.
            moveAsideUnreadableFile()
            return
        }
        isLoading = true
        sessions = snapshot.sessions.sorted { $0.day < $1.day }
        experience = snapshot.experience
        unit = snapshot.unit ?? .kg
        rest = snapshot.rest ?? .auto
        profile = snapshot.profile
        saved = Set(snapshot.saved ?? [])
        customPresets = snapshot.customPresets ?? [:]
        isLoading = false
    }

    /// Renames a file that no longer decodes to workouts.corrupt-<unix
    /// time>.json beside it, so the history can still be recovered.
    private func moveAsideUnreadableFile() {
        let stamp = Int(Date().timeIntervalSince1970)
        let name = "\(fileURL.deletingPathExtension().lastPathComponent).corrupt-\(stamp).\(fileURL.pathExtension)"
        let destination = fileURL.deletingLastPathComponent().appendingPathComponent(name)
        do {
            try FileManager.default.moveItem(at: fileURL, to: destination)
        } catch {
            assertionFailure("Couldn't set aside unreadable workouts: \(error)")
        }
    }

    private func save() {
        let snapshot = Snapshot(experience: experience, unit: unit, rest: rest, profile: profile,
                                saved: saved.sorted(), customPresets: customPresets, sessions: sessions)
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
