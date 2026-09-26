//
//  MusclePresetView.swift
//  GymWorkout
//
//  One muscle group's exercises for a day. Opens on the user's own list
//  when they saved one, else the Basic or Advanced preset; the list is only
//  written into the day once the user does something with it (adds it,
//  edits it, or opens an exercise), so looking never changes the workout.
//
//  Swap All swaps every exercise not started yet, and each row's swap button
//  one of them, for another that trains the same part the same way — one
//  the user hasn't done lately (`ExerciseRotation`). Swaps, saving over My
//  List and deleting it can all be undone from the toast.
//

import SwiftUI

struct MusclePresetView: View {
    var group: MuscleGroup
    var day: Date

    @Environment(WorkoutStore.self) private var store
    @Environment(TrainRouter.self) private var router
    @Environment(\.dismiss) private var dismiss

    @State private var level: PresetLevel = .basic
    @State private var preview: [WorkoutExercise] = []
    @State private var didLoad = false
    @State private var picker: PickerMode?
    @State private var editingTarget: WorkoutExercise?
    @State private var editMode: EditMode = .inactive
    @State private var confirmsRemoval = false
    @State private var confirmsDeletingMine = false
    /// Every exercise the list has shown on this visit, so Shuffle and the
    /// swap buttons keep bringing ones not seen yet.
    @State private var shown: Set<String> = []
    @State private var toast: Toast?
    /// Rows just swapped, outlined for a moment so the change is visible.
    @State private var flashed: Set<UUID> = []
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOver

    /// A short note over the list, with an undo when it follows a change.
    struct Toast: Identifiable, Equatable {
        let id = UUID()
        var text: String
        /// The names swapped out, by row, to put back.
        var undo: [UUID: String] = [:]
        /// The unsaved list as it was, when the swap was made before the list
        /// was added to the day.
        var previewBefore: [WorkoutExercise]? = nil
        /// My List as it was before it was saved over or deleted (nil: there
        /// was none), and the level the screen was on.
        var restoresMine = false
        var mineBefore: [PresetItem]? = nil
        var levelBefore: PresetLevel? = nil

        var canUndo: Bool { !undo.isEmpty || restoresMine }
    }

    enum PickerMode: Identifiable {
        case add
        case replace(UUID)

        var id: String {
            switch self {
            case .add: return "add"
            case .replace(let id): return id.uuidString
            }
        }
    }

    private var planned: [WorkoutExercise] { store.exercises(for: group, on: day) }
    private var isPlanned: Bool { !planned.isEmpty }
    private var rows: [WorkoutExercise] { isPlanned ? planned : preview }
    private var isToday: Bool { Calendar.current.isDateInToday(day) }
    private var dayName: String { isToday ? "Today's" : RecoveryText.day(day) + "'s" }
    private var isPast: Bool { Calendar.current.startOfDay(for: day) < Calendar.current.startOfDay(for: Date()) }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                List {
                    intro
                        .modifier(PlainRow(top: 4, bottom: 14))

                    listHeader
                        .modifier(PlainRow(top: 0, bottom: 2))

                    ForEach(rows) { exercise in
                        row(exercise)
                            .modifier(PlainRow(top: 5, bottom: 5))
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)

                    addButton
                        .modifier(PlainRow(top: 10, bottom: 6))

                    footer
                        .modifier(PlainRow(top: 14, bottom: 30))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .environment(\.editMode, $editMode)
                // Room to scroll the footer clear of the toast.
                .contentMargins(.bottom, toast == nil ? 0 : 72, for: .scrollContent)
            }

            if let toast {
                toastView(toast)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 18)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .task(id: toast?.id) {
            guard let current = toast else { return }
            // A newer toast cancels this wait; it must not dismiss that one.
            let seconds: Double = voiceOver ? 12 : current.canUndo ? 6 : 3
            do { try await Task.sleep(for: .seconds(seconds)) } catch { return }
            withAnimation(.easeOut(duration: 0.2)) { toast = nil }
        }
        .onDisappear { toast = nil }
        .onChange(of: store.hasCustomPreset(for: group)) { _, has in
            // My List deleted or restored from another screen.
            guard !has, level == .mine else { return }
            level = store.suggestedLevel
            if !isPlanned { preview = store.preview(group, level: level) }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .restTimerInset()
        .onAppear(perform: load)
        .sheet(item: $picker) { mode in
            ExercisePickerView(
                group: group,
                title: { if case .replace = mode { return "Choose Another" } else { return "Add Exercise" } }(),
                alreadyAdded: Set(rows.map(\.exerciseName))
            ) { name in
                ensurePlanned()
                switch mode {
                case .add: store.addExercise(named: name, to: group, on: day)
                case .replace(let id): store.replaceExercise(id: id, with: name)
                }
            }
        }
        .sheet(item: $editingTarget) { exercise in
            TargetEditorSheet(exercise: exercise) { sets, reps in
                ensurePlanned()
                store.updateTarget(id: exercise.id, sets: sets, reps: reps)
            }
        }
        .confirmationDialog("Remove \(group.title) from \(dayName.lowercased()) workout?",
                            isPresented: $confirmsRemoval, titleVisibility: .visible) {
            Button("Remove", role: .destructive) {
                store.removeGroup(group, on: day)
                dismiss()
            }
        } message: {
            Text("Sets you've already marked done are removed too.")
        }
        .confirmationDialog("Delete My List for \(group.title)?",
                            isPresented: $confirmsDeletingMine, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: deleteMine)
        } message: {
            Text("Days you've already planned keep their exercises.")
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            CircleIconButton(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel("Back")

            VStack(alignment: .leading, spacing: 0) {
                Text(group.title)
                    .font(.ui(16, .semibold))
                    .tracking(-0.25)
                    .foregroundStyle(DS.silver)
                MetaLine(text: "\(dayName.uppercased()) WORKOUT · \(rows.count) EXERCISES")
                    .padding(.top, 3)
            }

            Spacer(minLength: 0)

            if rows.count > 1 {
                Button(editMode.isEditing ? "Done" : "Reorder") {
                    withAnimation { editMode = editMode.isEditing ? .inactive : .active }
                }
                .font(.ui(13, .semibold))
                .foregroundStyle(DS.silver)
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 11)
        .padding(.bottom, 10)
    }

    // MARK: - Intro

    private var intro: some View {
        let record = store.recoveryRecords()[group]
        return VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    SectionEyebrow(text: "RECOVERY", size: 9.5)
                    MuscleStateLabel(state: MuscleCardState(record?.status))
                    if let record, record.status == .partlyReady {
                        Text("\(RecoveryText.recovering(record.tiredParts.map(\.part))) · \(RecoveryText.ready(record.readyParts).lowercased())")
                            .font(.ui(12))
                            .foregroundStyle(DS.silver.opacity(0.5))
                            .fixedSize(horizontal: false, vertical: true)
                    } else if let record, record.status != .ready {
                        Text("\(RecoveryText.trainedAgo(record.lastTrainedAt)) · est. \(RecoveryText.remaining(record.hoursRemaining))")
                            .font(.ui(12))
                            .foregroundStyle(DS.silver.opacity(0.5))
                    } else if let record {
                        // Helping on another group's day isn't "trained".
                        if let note = record.sideNotes.first {
                            Text(RecoveryText.sideNote(note))
                                .font(.ui(12))
                                .foregroundStyle(DS.silver.opacity(0.5))
                        } else if let last = record.lastCountedAt {
                            Text(RecoveryText.trainedAgo(last))
                                .font(.ui(12))
                                .foregroundStyle(DS.silver.opacity(0.5))
                        }
                    }
                }
                Spacer()
                MiniBodyMap(group: group)
                    .frame(width: 30, height: 70)
            }

            MonoSegmentedControl(
                options: levels.map { ($0, $0.title) },
                selection: Binding(get: { level }, set: select),
                fontSize: 10,
                itemPaddingV: 8,
                fillsWidth: true
            )

            Text(levelCaption)
                .font(.ui(12.5))
                .foregroundStyle(DS.silver.opacity(0.5))
        }
    }

    /// Basic and Advanced always; Mine once the user saved a list.
    private var levels: [PresetLevel] {
        [.basic, .advanced] + (store.hasCustomPreset(for: group) ? [.mine] : [])
    }

    private var levelCaption: String {
        let suggested = store.profile != nil && level == store.suggestedLevel ? " Suggested for you." : ""
        switch level {
        case .basic: return "Machines and supported positions — a good place to start." + suggested
        case .advanced: return "Free-weight compounds that need more balance and bracing." + suggested
        case .mine: return "Your saved list for \(group.title)."
        }
    }

    // MARK: - Shuffle

    private var listHeader: some View {
        HStack {
            SectionEyebrow(text: "EXERCISES", size: 9.5)
            Spacer()
            if canSwapAll {
                Button(action: shuffleAll) {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 11, weight: .semibold))
                        Text("Swap All")
                            .font(.ui(12.5, .semibold))
                    }
                    .foregroundStyle(DS.silver)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(Capsule().fill(DS.silver.opacity(0.08)))
                    .contentShape(Capsule())
                }
                .buttonStyle(.borderless)
                .accessibilityHint("Swaps the exercises not started yet for ones you haven't done lately, keeping the sets and the muscles worked.")
            }
        }
        .frame(minHeight: 32)
    }

    /// Swapping is for planning: not on a past day's log, not while
    /// reordering, and only for rows with no sets done.
    private func canSwap(_ exercise: WorkoutExercise) -> Bool {
        !isPast && !editMode.isEditing && exercise.completedSets.isEmpty
    }

    private var canSwapAll: Bool { rows.contains(where: canSwap) }

    // MARK: - Rows

    private func row(_ exercise: WorkoutExercise) -> some View {
        HStack(spacing: 8) {
            Button {
                open(exercise)
            } label: {
                PresetExerciseRow(exercise: exercise, caution: caution(for: exercise))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(DS.silver.opacity(flashed.contains(exercise.id) ? 0.5 : 0), lineWidth: 1.5)
                    )
            }
            .buttonStyle(.borderless)
            .disabled(editMode.isEditing)

            if canSwap(exercise) {
                Button {
                    swap(exercise)
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .frame(width: 28, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Swap \(exercise.exerciseName)")
                .accessibilityHint("Replaces it with a similar exercise you haven't done lately.")
            }

            if !editMode.isEditing {

                Menu {
                    Button(exercise.isTimed ? "Edit Sets & Time" : "Edit Sets & Reps", systemImage: "slider.horizontal.3") {
                        editingTarget = exercise
                    }
                    Button("Choose Another", systemImage: "list.bullet") {
                        picker = .replace(exercise.id)
                    }
                    .disabled(!exercise.completedSets.isEmpty)
                    Button("Remove", systemImage: "trash", role: .destructive) {
                        ensurePlanned()
                        store.removeExercise(id: exercise.id)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .frame(width: 30, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Options for \(exercise.exerciseName)")
            }
        }
    }

    private var addButton: some View {
        Button {
            picker = .add
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "plus")
                    .font(.system(size: 12, weight: .semibold))
                Text("Add Exercise")
                    .font(.ui(14, .semibold))
            }
            .foregroundStyle(DS.silver)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.18), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            )
        }
        .buttonStyle(.borderless)
    }

    @ViewBuilder
    private var footer: some View {
        VStack(spacing: 22) {
            dayFooter
            mineFooter
        }
    }

    @ViewBuilder
    private var dayFooter: some View {
        if !isPlanned {
            VStack(spacing: 8) {
                WideButton(title: "Add to \(dayName) Workout", prominent: true) {
                    withAnimation { ensurePlanned() }
                }
                Text("Or tap an exercise to start logging sets.")
                    .font(.ui(11.5))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
        } else {
            let done = planned.reduce(0) { $0 + $1.completedSets.count }
            let total = planned.reduce(0) { $0 + $1.sets.count }
            VStack(spacing: 12) {
                Text("\(done) of \(total) sets done")
                    .font(.ui(13, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.6))
                Button("Remove \(group.title) from this workout") { confirmsRemoval = true }
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.45))
                    .buttonStyle(.borderless)
            }
            .frame(maxWidth: .infinity)
        }
    }

    /// Saves the list as the group's own, updates it, or says this is it.
    /// Update only shows once the list has been changed from what the screen
    /// opened on, so just looking at Basic or Advanced never offers to write
    /// over a saved list.
    @ViewBuilder
    private var mineFooter: some View {
        if !rows.isEmpty {
            if store.matchesCustomPreset(rows, for: group) {
                HStack(spacing: 6) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 10, weight: .semibold))
                    Text("Saved as My List")
                    Text("·")
                    Button { confirmsDeletingMine = true } label: {
                        Text("Delete")
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .accessibilityLabel("Delete My List")
                }
                .font(.ui(12))
                .foregroundStyle(DS.silver.opacity(0.45))
                .frame(maxWidth: .infinity)
            } else if !store.hasCustomPreset(for: group) || level == .mine || isEdited {
                Button(action: saveAsMine) {
                    Label(store.hasCustomPreset(for: group) ? "Update My List" : "Save as My List", systemImage: "bookmark")
                        .font(.ui(12.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.75))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.borderless)
                .frame(maxWidth: .infinity)
                .accessibilityHint("\(group.title) opens on this list next time.")
            }
        }
    }

    /// The list differs from the preset its level would give.
    private var isEdited: Bool {
        rows.map(\.exerciseName) != store.preview(group, level: level).map(\.exerciseName)
    }

    private func toastView(_ toast: Toast) -> some View {
        HStack(spacing: 10) {
            Text(toast.text)
                .font(.ui(13, .semibold))
                .lineLimit(2)
            if toast.canUndo {
                Button { undo(toast) } label: {
                    Text("Undo")
                        .font(.ui(13, .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.borderless)
            }
        }
        .foregroundStyle(DS.ink)
        .padding(.leading, 16)
        .padding(.trailing, toast.canUndo ? 8 : 16)
        .padding(.vertical, toast.canUndo ? 3 : 11)
        .background(Capsule().fill(DS.silver))
        .padding(.horizontal, DS.Metric.gutter)
        .accessibilityElement(children: .contain)
    }

    /// "FRONT DELTS RECOVERING" when the exercise works a part of this group
    /// that is still recovering as a primary mover. Only for today or later —
    /// a past day's log is just a record.
    private func caution(for exercise: WorkoutExercise) -> String? {
        guard !isPast, let record = store.recoveryRecords()[group] else { return nil }
        let tired = Set(record.tiredParts.map(\.part))
        let hit = RecoveryCalculator.partContributions(of: exercise)
            .filter { $0.role == .primary && tired.contains($0.part) }
            .map(\.part)
        return hit.isEmpty ? nil : RecoveryText.recovering(hit).uppercased()
    }

    // MARK: - Actions

    private func load() {
        guard !didLoad else { return }
        didLoad = true
        // A group already on the day without a level (added from the library)
        // isn't the saved list, whatever the group opens on otherwise.
        level = store.level(for: group, on: day) ?? (isPlanned ? store.suggestedLevel : store.defaultLevel(for: group))
        if level == .mine && !store.hasCustomPreset(for: group) { level = store.suggestedLevel }
        preview = store.preview(group, level: level)
        shown = Set(rows.map(\.exerciseName))
    }

    private func select(_ newLevel: PresetLevel) {
        guard newLevel != level else { return }
        toast = nil
        withAnimation(.easeOut(duration: 0.18)) {
            level = newLevel
            if isPlanned {
                store.switchLevel(group, on: day, to: newLevel)
            } else {
                preview = store.preview(group, level: newLevel)
            }
        }
    }

    /// Writes the previewed preset into the day, keeping its ids.
    private func ensurePlanned() {
        if !isPlanned {
            store.ensurePlan(group, on: day, level: level, planned: preview)
        }
    }

    private var rotationContext: ExerciseRotation.Context {
        // Recovery as of the day being planned, in every group: a quads pick
        // shouldn't lean on glutes trained yesterday.
        let when = max(day, Date())
        let tired = store.recoveryRecords(at: when).values.flatMap { $0.parts.filter(\.isTired).map(\.part) }
        let ceiling = (store.customPreset(for: group) ?? [])
            .compactMap { ExerciseCatalog.exercise(named: $0.exerciseName)?.difficulty }
            .max { ExerciseRotation.rank($0) < ExerciseRotation.rank($1) } ?? .intermediate
        return ExerciseRotation.Context(group: group, level: level, lastDone: store.lastDoneDates,
                                        tired: Set(tired), saved: store.saved, ceiling: ceiling, now: when)
    }

    /// The day's exercises in other groups, which a swap here mustn't repeat.
    private var elsewhereToday: Set<String> {
        Set((store.session(on: day)?.exercises ?? []).filter { $0.group != group }.map(\.exerciseName))
    }

    /// Another exercise for the row: first one not shown on this visit, then
    /// any not in the list (or `alsoAvoid`); never one already on the day.
    private func replacement(for exercise: WorkoutExercise, in list: [String],
                             alsoAvoid: Set<String> = [], context: ExerciseRotation.Context) -> String? {
        let taken = Set(list).union(elsewhereToday).union(alsoAvoid)
        return ExerciseRotation.replacement(for: exercise.exerciseName, context: context,
                                            avoid: taken.union(shown), thenAvoid: taken)
    }

    private func shuffleAll() {
        let context = rotationContext
        shown.formUnion(rows.map(\.exerciseName))
        // What the list held before, so rows don't just trade places.
        let original = Set(rows.map(\.exerciseName))
        var list = rows.map(\.exerciseName)
        var changes: [(WorkoutExercise, String)] = []
        for (index, exercise) in rows.enumerated() where canSwap(exercise) {
            guard let name = replacement(for: exercise, in: list, alsoAvoid: original, context: context) else { continue }
            list[index] = name
            changes.append((exercise, name))
        }
        guard !changes.isEmpty else {
            show(Toast(text: "No other exercises to swap in yet."))
            return
        }
        let before = isPlanned ? nil : preview
        apply(changes)
        show(Toast(text: changes.count == 1 ? "1 exercise swapped" : "\(changes.count) exercises swapped",
                   undo: Dictionary(uniqueKeysWithValues: changes.map { ($0.0.id, $0.0.exerciseName) }),
                   previewBefore: before))
    }

    private func swap(_ exercise: WorkoutExercise) {
        shown.formUnion(rows.map(\.exerciseName))
        guard let name = replacement(for: exercise, in: rows.map(\.exerciseName), context: rotationContext) else {
            show(Toast(text: "No other exercise like this to swap in yet."))
            return
        }
        let before = isPlanned ? nil : preview
        apply([(exercise, name)])
        show(Toast(text: "Swapped for \(name)", undo: [exercise.id: exercise.exerciseName], previewBefore: before))
    }

    /// Puts each new exercise in its row: in the day's plan when there is
    /// one, else in the unsaved list.
    private func apply(_ changes: [(WorkoutExercise, String)]) {
        withAnimation(.easeOut(duration: 0.2)) {
            for (exercise, name) in changes {
                shown.insert(name)
                if isPlanned {
                    store.replaceExercise(id: exercise.id, with: name)
                } else if let index = preview.firstIndex(where: { $0.id == exercise.id }),
                          let swapped = store.swapped(exercise, to: name) {
                    preview[index] = swapped
                }
            }
        }
        flash(Set(changes.map(\.0.id)))
    }

    private func flash(_ ids: Set<UUID>) {
        withAnimation(.easeOut(duration: 0.15)) { flashed = ids }
        Task {
            try? await Task.sleep(for: .seconds(1.2))
            withAnimation(.easeOut(duration: 0.4)) { if flashed == ids { flashed = [] } }
        }
    }

    private func undo(_ toast: Toast) {
        withAnimation(.easeOut(duration: 0.2)) {
            if toast.restoresMine {
                store.restoreCustomPreset(toast.mineBefore, for: group)
                let before = toast.levelBefore ?? level
                let restored = before == .mine && toast.mineBefore == nil ? store.suggestedLevel : before
                if restored != level {
                    level = restored
                    if isPlanned {
                        store.markLevel(restored, for: group, on: day)
                    } else if restored == .mine {
                        // Undoing a delete: the list it showed comes back.
                        preview = store.preview(group, level: .mine)
                    }
                }
            } else if let before = toast.previewBefore, !isPlanned {
                preview = before
            } else {
                // Rows started since keep what was logged on them, and a name
                // now in another row isn't brought back as a duplicate.
                for (id, name) in toast.undo where store.exercise(id: id)?.completedSets.isEmpty == true
                    && !rows.contains(where: { $0.exerciseName == name && $0.id != id }) {
                    store.replaceExercise(id: id, with: name)
                }
            }
            self.toast = nil
        }
    }

    private func show(_ newToast: Toast) {
        withAnimation(.easeOut(duration: 0.2)) { toast = newToast }
        AccessibilityNotification.Announcement(newToast.text + (newToast.canUndo ? ". Undo available." : "")).post()
    }

    private func saveAsMine() {
        let before = store.customPreset(for: group)
        let levelBefore = level
        store.saveCustomPreset(rows, for: group)
        if isPlanned { store.markLevel(.mine, for: group, on: day) }
        withAnimation(.easeOut(duration: 0.18)) { level = .mine }
        show(before == nil
             ? Toast(text: "Saved as My List. \(group.title) opens on it next time.")
             : Toast(text: "My List updated", restoresMine: true, mineBefore: before, levelBefore: levelBefore))
    }

    private func deleteMine() {
        let before = store.customPreset(for: group)
        store.deleteCustomPreset(for: group)
        show(Toast(text: "My List deleted", restoresMine: true, mineBefore: before, levelBefore: level))
        guard level == .mine else { return }
        withAnimation(.easeOut(duration: 0.18)) {
            level = store.suggestedLevel
            if !isPlanned { preview = store.preview(group, level: level) }
        }
    }

    private func open(_ exercise: WorkoutExercise) {
        ensurePlanned()
        router.push(.exercise(exercise.id))
    }

    private func delete(_ offsets: IndexSet) {
        let ids = offsets.map { rows[$0].id }
        ensurePlanned()
        ids.forEach { store.removeExercise(id: $0) }
    }

    private func move(_ source: IndexSet, _ destination: Int) {
        ensurePlanned()
        store.moveExercises(in: group, on: day, from: source, to: destination)
    }
}

// MARK: - Row

struct PresetExerciseRow: View {
    var exercise: WorkoutExercise
    /// A recovery heads-up for this exercise, e.g. "FRONT DELTS RECOVERING".
    var caution: String? = nil

    private var libraryExercise: Exercise? { ExerciseCatalog.exercise(named: exercise.exerciseName) }
    private var done: Int { exercise.completedSets.count }

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(DS.surfaceDim)
                .frame(width: 54, height: 54)
                .overlay(
                    RenderSlot(id: libraryExercise?.slotID ?? "")
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                )

            VStack(alignment: .leading, spacing: 5) {
                Text(exercise.exerciseName)
                    .font(.ui(14.5, .semibold))
                    .foregroundStyle(DS.silver)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 8) {
                    Text(exercise.targetLabel)
                        .font(.mono(11, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                    if exercise.isCompleted || (done > 0 && done == exercise.sets.count) {
                        HStack(spacing: 3) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .bold))
                            Text("\(done)/\(exercise.sets.count) DONE")
                                .font(.mono(9, .semibold))
                                .trackingEm(0.06, size: 9)
                        }
                        .foregroundStyle(DS.silver.opacity(0.7))
                    } else if done > 0 {
                        Text("\(done)/\(exercise.sets.count) DONE")
                            .font(.mono(9, .semibold))
                            .trackingEm(0.06, size: 9)
                            .foregroundStyle(DS.silver.opacity(0.5))
                    }
                }
                if let caution {
                    HStack(spacing: 4) {
                        Image(systemName: MuscleCardState.recovering.symbol)
                            .font(.system(size: 7, weight: .semibold))
                        Text(caution)
                            .font(.mono(8.5, .semibold))
                            .trackingEm(0.06, size: 8.5)
                    }
                    .foregroundStyle(DS.silver.opacity(0.5))
                }
            }

            Spacer(minLength: 4)

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.28))
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(DS.surfaceAlt)
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(exercise.exerciseName), \(exercise.sets.count) sets of \(exercise.repRange.label) \(exercise.isTimed ? "seconds" : "reps"), \(done) done"
                            + (caution.map { ", \($0.lowercased())" } ?? ""))
    }
}

/// A list row with no chrome, so rows sit on the screen ground like the rest
/// of the app.
struct PlainRow: ViewModifier {
    var top: CGFloat
    var bottom: CGFloat

    func body(content: Content) -> some View {
        content
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: top, leading: DS.Metric.gutter, bottom: bottom, trailing: DS.Metric.gutter))
    }
}

// MARK: - Target editor

struct TargetEditorSheet: View {
    var exercise: WorkoutExercise
    var onSave: (Int, RepRange) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var sets: Int
    @State private var lower: Int
    @State private var upper: Int

    init(exercise: WorkoutExercise, onSave: @escaping (Int, RepRange) -> Void) {
        self.exercise = exercise
        self.onSave = onSave
        _sets = State(initialValue: exercise.sets.count)
        _lower = State(initialValue: exercise.repRange.lower)
        _upper = State(initialValue: exercise.repRange.upper)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MetaLine(text: exercise.exerciseName.uppercased(), em: 0.10)
            Text(exercise.isTimed ? "Sets & Time" : "Sets & Reps")
                .font(.ui(22, .semibold))
                .tracking(-0.45)
                .foregroundStyle(DS.silver)
                .padding(.top, 5)

            VStack(spacing: 4) {
                stepper("Sets", value: $sets, range: max(1, exercise.completedSets.count)...10)
                if exercise.isTimed {
                    stepper("Seconds from", value: $lower, range: 5...300, step: 5)
                    stepper("Seconds up to", value: $upper, range: lower...300, step: 5)
                } else {
                    stepper("Reps from", value: $lower, range: 1...50)
                    stepper("Reps up to", value: $upper, range: lower...50)
                }
            }
            .padding(.top, 18)

            Text("Target: \(sets) × \(exercise.setMeasure.label(RepRange(lower, upper)))")
                .font(.mono(11, .semibold))
                .foregroundStyle(DS.silver.opacity(0.5))
                .padding(.top, 12)

            WideButton(title: "Save", prominent: true) {
                onSave(sets, RepRange(lower, upper))
                dismiss()
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 26)
        .onChange(of: lower) { _, new in if upper < new { upper = new } }
        .presentationDetents([.height(380)])
        .presentationDragIndicator(.visible)
        .presentationBackground(DS.surface)
        .presentationCornerRadius(DS.Metric.sheetRadius)
    }

    private func stepper(_ title: String, value: Binding<Int>, range: ClosedRange<Int>,
                         step: Int = 1) -> some View {
        Stepper(value: value, in: range, step: step) {
            HStack {
                Text(title)
                    .font(.ui(15))
                    .foregroundStyle(DS.silver.opacity(0.8))
                Spacer()
                Text("\(value.wrappedValue)")
                    .font(.mono(15, .semibold))
                    .foregroundStyle(DS.silver)
                    .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 6)
    }
}
