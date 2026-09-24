//
//  MusclePresetView.swift
//  GymWorkout
//
//  One muscle group's exercises for a day. Opens on the Basic or Advanced
//  preset; the preset is only written into the day once the user does
//  something with it (adds it, edits it, or opens an exercise), so looking
//  never changes the workout.
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
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .onAppear(perform: load)
        .sheet(item: $picker) { mode in
            ExercisePickerView(
                group: group,
                title: { if case .replace = mode { return "Replace Exercise" } else { return "Add Exercise" } }(),
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
                options: PresetLevel.allCases.map { ($0, $0.title) },
                selection: Binding(get: { level }, set: select),
                fontSize: 10,
                itemPaddingV: 8,
                fillsWidth: true
            )

            Text(level == .basic
                 ? "Machines and supported positions — a good place to start."
                 : "Free-weight compounds that need more balance and bracing.")
                .font(.ui(12.5))
                .foregroundStyle(DS.silver.opacity(0.5))
        }
    }

    // MARK: - Rows

    private func row(_ exercise: WorkoutExercise) -> some View {
        HStack(spacing: 8) {
            Button {
                open(exercise)
            } label: {
                PresetExerciseRow(exercise: exercise, caution: caution(for: exercise))
            }
            .buttonStyle(.borderless)
            .disabled(editMode.isEditing)

            if !editMode.isEditing {
                Menu {
                    Button("Edit Sets & Reps", systemImage: "slider.horizontal.3") {
                        editingTarget = exercise
                    }
                    Button("Replace", systemImage: "arrow.left.arrow.right") {
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
                        .frame(width: 34, height: 44)
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
        level = store.level(for: group, on: day) ?? .basic
        preview = store.preview(group, level: level)
    }

    private func select(_ newLevel: PresetLevel) {
        guard newLevel != level else { return }
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
                    Text("\(exercise.sets.count) × \(exercise.repRange.label)")
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
        .accessibilityLabel("\(exercise.exerciseName), \(exercise.sets.count) sets of \(exercise.repRange.label) reps, \(done) done"
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
            Text("Sets & Reps")
                .font(.ui(22, .semibold))
                .tracking(-0.45)
                .foregroundStyle(DS.silver)
                .padding(.top, 5)

            VStack(spacing: 4) {
                stepper("Sets", value: $sets, range: max(1, exercise.completedSets.count)...10)
                stepper("Reps from", value: $lower, range: 1...50)
                stepper("Reps up to", value: $upper, range: lower...50)
            }
            .padding(.top, 18)

            Text("Target: \(sets) × \(RepRange(lower, upper).label)")
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

    private func stepper(_ title: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        Stepper(value: value, in: range) {
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
