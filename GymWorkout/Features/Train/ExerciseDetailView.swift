//
//  ExerciseDetailView.swift
//  GymWorkout
//
//  One exercise inside a workout: the existing 3D model, the muscles it
//  trains, how to perform it (from the trainer content), and its sets. Only
//  sets marked Done count toward history and recovery.
//

import SwiftUI

struct ExerciseDetailView: View {
    var workoutExerciseID: UUID

    @Environment(WorkoutStore.self) private var store
    @Environment(TrainRouter.self) private var router
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            if let item = store.exercise(id: workoutExerciseID),
               let exercise = ExerciseCatalog.exercise(named: item.exerciseName) {
                VStack(spacing: 0) {
                    header(exercise)
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            model(exercise)
                            targets(item)
                                .padding(.top, 22)
                            instructions(exercise)
                                .padding(.top, 26)
                            sets(item)
                                .padding(.top, 28)
                            completion(item)
                                .padding(.top, 18)
                        }
                        .padding(.horizontal, DS.Metric.gutter)
                        .padding(.bottom, 32)
                    }
                }
            } else {
                VStack(spacing: 14) {
                    Text("This exercise is no longer in the workout.")
                        .font(.ui(14))
                        .foregroundStyle(DS.silver.opacity(0.6))
                    WideButton(title: "Back", prominent: false) { dismiss() }
                        .frame(width: 160)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
    }

    // MARK: - Header

    private func header(_ exercise: Exercise) -> some View {
        HStack(spacing: 12) {
            CircleIconButton(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel("Back")

            VStack(alignment: .leading, spacing: 0) {
                Text(exercise.name)
                    .font(.ui(16, .semibold))
                    .tracking(-0.25)
                    .foregroundStyle(DS.silver)
                    .lineLimit(1)
                MetaLine(text: exercise.trainerMeta)
                    .padding(.top, 3)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 11)
        .padding(.bottom, 10)
    }

    // MARK: - Model

    @ViewBuilder
    private func model(_ exercise: Exercise) -> some View {
        if let model = SampleData.model(for: exercise) {
            Viewport(slot: exercise.slotID, model: model.resource, framing: model.framing,
                     speed: model.speed, cornerRadius: 22)
                .frame(height: 340)
                .overlay(alignment: .bottomTrailing) {
                    if SampleData.hasTrainer(exercise) {
                        Button {
                            router.push(.trainer(exerciseName: exercise.name))
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "cube.transparent")
                                Text("3D Trainer & Key Tips")
                            }
                            .font(.ui(12, .semibold))
                            .foregroundStyle(DS.silver)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(DS.glass(0.72)))
                            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.12), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                        .padding(12)
                    }
                }
        } else {
            Viewport(slot: exercise.slotID, cornerRadius: 22)
                .frame(height: 200)
                .overlay {
                    Text("No 3D model for this exercise yet")
                        .font(.mono(9.5, .semibold))
                        .trackingEm(0.08, size: 9.5)
                        .foregroundStyle(DS.silver.opacity(0.4))
                }
        }
    }

    // MARK: - Muscles

    private func targets(_ item: WorkoutExercise) -> some View {
        // By part, so a bench press shows "Front delts", not all of Shoulders.
        let parts = RecoveryCalculator.partContributions(of: item)
        let primary = parts.filter { $0.role == .primary }.map(\.part)
        let secondary = parts.filter { $0.role == .secondary }.map(\.part)
        return VStack(alignment: .leading, spacing: 12) {
            SectionEyebrow(text: "TARGET MUSCLES")
            if !primary.isEmpty { muscleLine("PRIMARY", primary, lit: true) }
            if !secondary.isEmpty { muscleLine("SECONDARY", secondary, lit: false) }
        }
    }

    private func muscleLine(_ title: String, _ muscles: [MusclePart], lit: Bool) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(title)
                .font(.mono(9, .semibold))
                .trackingEm(0.08, size: 9)
                .foregroundStyle(DS.silver.opacity(0.4))
                .frame(width: 78, alignment: .leading)
            FlowRow(spacing: 6) {
                ForEach(muscles) { muscle in
                    HStack(spacing: 5) {
                        Circle()
                            .fill(lit ? DS.activation : ActivationRank.secondary.barColor)
                            .frame(width: 6, height: 6)
                        Text(muscle.title)
                            .font(.ui(12.5, .semibold))
                            .foregroundStyle(DS.silver)
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(DS.silver.opacity(0.07)))
                }
            }
        }
    }

    // MARK: - How to perform

    @ViewBuilder
    private func instructions(_ exercise: Exercise) -> some View {
        let steps = ExerciseCatalog.setupSteps(for: exercise)
        let cues = ExerciseCatalog.formCues(for: exercise)
        VStack(alignment: .leading, spacing: 14) {
            SectionEyebrow(text: "HOW TO PERFORM")
            if steps.isEmpty && cues.isEmpty {
                Text("No step-by-step guide for this exercise yet.")
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.5))
            }
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                stepRow("STEP \(index + 1)", step)
            }
            if !cues.isEmpty {
                Text("FORM CUES")
                    .font(.mono(9, .semibold))
                    .trackingEm(0.10, size: 9)
                    .foregroundStyle(DS.silver.opacity(0.4))
                    .padding(.top, 6)
                ForEach(Array(cues.enumerated()), id: \.offset) { _, cue in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(cue.title)
                            .font(.ui(13.5, .semibold))
                            .foregroundStyle(DS.silver)
                        Text(cue.text)
                            .font(.ui(13.5))
                            .cssLineHeight(13.5, 1.45)
                            .foregroundStyle(DS.silver.opacity(0.65))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private func stepRow(_ label: String, _ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(label)
                .font(.mono(9, .semibold))
                .trackingEm(0.06, size: 9)
                .foregroundStyle(DS.silver.opacity(0.4))
                .frame(width: 48, alignment: .leading)
            Text(text)
                .font(.ui(14))
                .cssLineHeight(14, 1.45)
                .foregroundStyle(DS.silver.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Sets

    private func sets(_ item: WorkoutExercise) -> some View {
        let canLog = store.canLog(on: store.day(ofExercise: item.id) ?? Date())
        return VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "SETS")
                Spacer()
                MetaLine(text: "TARGET \(item.sets.count) × \(item.repRange.label) REPS", em: 0.06)
            }

            ForEach(Array(item.sets.enumerated()), id: \.element.id) { index, set in
                SetRow(
                    number: index + 1,
                    set: set,
                    canLog: canLog,
                    onToggle: { withAnimation(.easeOut(duration: 0.15)) {
                        store.toggleSet(exerciseID: item.id, setID: set.id)
                    } },
                    onReps: { store.setReps($0, exerciseID: item.id, setID: set.id) },
                    onDelete: item.sets.count > 1 ? { store.removeSet(exerciseID: item.id, setID: set.id) } : nil
                )
            }

            Button {
                withAnimation { store.addSet(exerciseID: item.id) }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .semibold))
                    Text("Add Set")
                        .font(.ui(13.5, .semibold))
                }
                .foregroundStyle(DS.silver)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .strokeBorder(DS.silver.opacity(0.18), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                )
            }
            .buttonStyle(.plain)

            if !canLog {
                Text("This day hasn't happened yet — sets can be marked done on the day.")
                    .font(.ui(11.5))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
        }
    }

    @ViewBuilder
    private func completion(_ item: WorkoutExercise) -> some View {
        let done = item.completedSets.count
        if item.isCompleted {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                Text("Exercise completed · \(done) of \(item.sets.count) sets")
            }
            .font(.ui(13, .semibold))
            .foregroundStyle(DS.silver.opacity(0.7))
            .frame(maxWidth: .infinity)
        } else {
            VStack(spacing: 8) {
                WideButton(title: "Complete Exercise", prominent: done > 0) {
                    store.completeExercise(id: item.id)
                    dismiss()
                }
                .disabled(done == 0)
                .opacity(done > 0 ? 1 : 0.5)
                Text(done == 0
                     ? "Mark sets Done as you finish them."
                     : "Only sets marked Done count toward your muscle history.")
                    .font(.ui(11.5))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
        }
    }
}

// MARK: - Set row

struct SetRow: View {
    var number: Int
    var set: WorkoutSet
    var canLog: Bool
    var onToggle: () -> Void
    var onReps: (Int) -> Void
    var onDelete: (() -> Void)?

    var body: some View {
        HStack(spacing: 10) {
            Text("Set \(number)")
                .font(.ui(14.5, .semibold))
                .foregroundStyle(DS.silver.opacity(set.isCompleted ? 0.55 : 1))
                .frame(width: 50, alignment: .leading)

            HStack(spacing: 0) {
                stepButton("minus") { onReps(set.reps - 1) }
                    .disabled(set.reps <= 1)
                Text("\(set.reps) reps")
                    .font(.mono(12.5, .semibold))
                    .foregroundStyle(DS.silver)
                    .frame(minWidth: 64)
                stepButton("plus") { onReps(set.reps + 1) }
            }
            .background(Capsule().fill(DS.silver.opacity(0.06)))

            Spacer(minLength: 4)

            Button(action: onToggle) {
                HStack(spacing: 5) {
                    Image(systemName: set.isCompleted ? "checkmark" : "circle")
                        .font(.system(size: 11, weight: .bold))
                    Text("Done")
                        .font(.ui(13, .semibold))
                }
                .foregroundStyle(set.isCompleted ? DS.ink : DS.silver)
                .padding(.horizontal, 13)
                .padding(.vertical, 8)
                .background(Capsule().fill(set.isCompleted ? DS.silver : DS.silver.opacity(0.07)))
                .overlay(Capsule().strokeBorder(DS.silver.opacity(set.isCompleted ? 0 : 0.14), lineWidth: 1))
            }
            .buttonStyle(.plain)
            .disabled(!canLog)
            .opacity(canLog ? 1 : 0.4)
            .accessibilityLabel("Set \(number) done")
            .accessibilityValue(set.isCompleted ? "Done" : "Not done")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(DS.surfaceAlt)
        )
        .contextMenu {
            if let onDelete {
                Button("Delete Set", systemImage: "trash", role: .destructive, action: onDelete)
            }
        }
    }

    private func stepButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(DS.silver.opacity(0.75))
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Flow row

/// Lays chips out left to right, wrapping onto new lines.
struct FlowRow: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, lineHeight: CGFloat = 0, maxX: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x > 0 && x + size.width > width { x = 0; y += lineHeight + spacing; lineHeight = 0 }
            x += size.width + spacing
            maxX = max(maxX, x - spacing)
            lineHeight = max(lineHeight, size.height)
        }
        return CGSize(width: maxX, height: y + lineHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, lineHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x > bounds.minX && x + size.width > bounds.maxX { x = bounds.minX; y += lineHeight + spacing; lineHeight = 0 }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}
