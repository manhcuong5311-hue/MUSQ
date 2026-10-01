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
    @Environment(RestTimer.self) private var restTimer
    @Environment(\.dismiss) private var dismiss
    @Environment(Ads.self) private var ads
    /// The set whose weight is being typed.
    @FocusState private var focusedSet: UUID?

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
                    .scrollDismissesKeyboard(.interactively)
                    // The rest bar slides in under the sets when one is marked
                    // done; keep what was at the bottom (Complete Exercise) in
                    // view instead of letting the bar cover it.
                    .defaultScrollAnchor(.bottom, for: .sizeChanges)
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
        .toolbar {
            // Once, here: the decimal pad has no return key, and a keyboard
            // toolbar declared per row would repeat per row.
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedSet = nil }
                    .font(.ui(15, .semibold))
            }
        }
        .restTimerInset()
    }

    // MARK: - Header

    private func header(_ exercise: Exercise) -> some View {
        HStack(spacing: 12) {
            CircleIconButton(action: { dismiss(); ads.moment(.exerciseClosed) }) {
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
        let day = store.day(ofExercise: item.id) ?? Date()
        let canLog = store.canLog(on: day)
        let previous = store.previousPerformance(forExercise: item.id)
            .flatMap { $0.measure == item.setMeasure ? $0 : nil }
        let records = PerformanceHistory.recordSetIDs(for: item.exerciseName, in: store.sessions)
        let bodyweight = ExerciseCatalog.isBodyweight(item.exerciseName)
        return VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "SETS")
                Spacer()
                MetaLine(text: "TARGET \(item.sets.count) × \(item.repRange.label) \(item.isTimed ? "SEC" : "REPS")",
                         em: 0.06)
            }

            if let previous {
                lastTime(previous)
            }

            SetColumns(measure: item.setMeasure, unit: store.unit)

            ForEach(Array(item.sets.enumerated()), id: \.element.id) { index, set in
                SetRow(
                    number: index + 1,
                    set: set,
                    measure: item.setMeasure,
                    unit: store.unit,
                    placeholderWeight: previous?.set(at: index)?.weight,
                    isBodyweight: bodyweight,
                    isRecord: records.contains(set.id),
                    canLog: canLog,
                    focus: $focusedSet,
                    onToggle: {
                        focusedSet = nil
                        withAnimation(.easeOut(duration: 0.15)) {
                            store.toggleSet(exerciseID: item.id, setID: set.id)
                        }
                        startRestIfDone(item, setID: set.id, day: day)
                    },
                    onReps: { store.setReps($0, exerciseID: item.id, setID: set.id) },
                    onWeight: { store.setWeight($0, exerciseID: item.id, setID: set.id) },
                    onHold: { seconds in
                        withAnimation(.easeOut(duration: 0.15)) {
                            store.completeHold(seconds: seconds, exerciseID: item.id, setID: set.id)
                        }
                        startRestIfDone(item, setID: set.id, day: day)
                    },
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

    /// "LAST TIME · MON 21 SEP" and last session's sets, the numbers to beat.
    private func lastTime(_ previous: PreviousPerformance) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            MetaLine(text: "LAST TIME · \(RecoveryText.day(previous.day).uppercased())", em: 0.08)
            SetChips(sets: previous.sets, measure: previous.measure, unit: store.unit)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(DS.silver.opacity(0.10), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }

    /// Rest follows a set marked done today; a past day's log is just a record.
    private func startRestIfDone(_ item: WorkoutExercise, setID: UUID, day: Date) {
        guard Calendar.current.isDateInToday(day),
              let updated = store.exercise(id: item.id),
              updated.sets.first(where: { $0.id == setID })?.isCompleted == true else { return }
        if let seconds = store.rest.seconds(after: updated) {
            restTimer.start(seconds: seconds)
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

/// Column labels over the set rows, on the rows' own grid.
struct SetColumns: View {
    var measure: SetMeasure
    var unit: WeightUnit

    var body: some View {
        HStack(spacing: SetRow.spacing) {
            label("SET", width: SetRow.numberWidth)
            if measure == .reps {
                label(unit.symbol.uppercased(), width: SetRow.weightWidth)
                label("REPS", width: SetRow.countWidth)
            } else {
                label("TIME", width: SetRow.holdWidth + SetRow.spacing + SetRow.countWidth)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, SetRow.inset)
        .padding(.bottom, -4)
        .accessibilityHidden(true)
    }

    private func label(_ text: String, width: CGFloat) -> some View {
        Text(text)
            .font(.mono(8.5, .semibold))
            .trackingEm(0.08, size: 8.5)
            .foregroundStyle(DS.silver.opacity(0.35))
            .frame(width: width, alignment: text == "SET" || text == "TIME" ? .leading : .center)
    }
}

struct SetRow: View {
    var number: Int
    var set: WorkoutSet
    var measure: SetMeasure
    var unit: WeightUnit
    /// The same set last time — shown greyed in an empty weight field.
    var placeholderWeight: Double?
    var isBodyweight: Bool
    /// Beat every earlier set of the exercise.
    var isRecord: Bool
    var canLog: Bool
    var focus: FocusState<UUID?>.Binding
    var onToggle: () -> Void
    var onReps: (Int) -> Void
    var onWeight: (Double?) -> Void
    /// A timed hold stopped after this many seconds.
    var onHold: (Int) -> Void
    var onDelete: (() -> Void)?

    static let spacing: CGFloat = 10
    static let inset: CGFloat = 10
    static let numberWidth: CGFloat = 26
    static let weightWidth: CGFloat = 66
    static let countWidth: CGFloat = 96
    static let holdWidth: CGFloat = 34

    /// When a timed hold started; nil when none is running.
    @State private var holdStart: Date?

    var body: some View {
        HStack(spacing: Self.spacing) {
            Text("\(number)")
                .font(.mono(14, .semibold))
                .foregroundStyle(DS.silver.opacity(set.isCompleted ? 0.45 : 0.9))
                .frame(width: Self.numberWidth, alignment: .leading)
                .accessibilityLabel("Set \(number)")

            if measure == .reps {
                WeightField(weight: set.weight, unit: unit, placeholder: placeholder,
                            setID: set.id, focus: focus, onCommit: onWeight)
                    .frame(width: Self.weightWidth)
                    .accessibilityLabel("Set \(number) weight in \(unit == .kg ? "kilograms" : "pounds")")
                counter
            } else if let holdStart {
                runningHold(since: holdStart)
            } else {
                holdButton
                counter
            }

            Spacer(minLength: 0)

            if isRecord {
                Text("PR")
                    .font(.mono(9, .bold))
                    .trackingEm(0.08, size: 9)
                    .foregroundStyle(DS.silver)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .overlay(Capsule().strokeBorder(DS.silver.opacity(0.5), lineWidth: 1))
                    .accessibilityLabel("Personal record")
            }

            doneButton
        }
        .padding(.horizontal, Self.inset)
        .padding(.vertical, 8)
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

    private var placeholder: String {
        if let placeholderWeight { return unit.number(placeholderWeight) }
        return isBodyweight ? "BW" : "–"
    }

    // MARK: Reps or seconds

    private var counter: some View {
        HStack(spacing: 0) {
            stepButton("minus") { onReps(set.reps - measure.step) }
                .disabled(set.reps <= measure.step)
            Text(measure == .time ? SetMeasure.clock(set.reps) : "\(set.reps)")
                .font(.mono(14, .semibold))
                .foregroundStyle(DS.silver)
                .frame(maxWidth: .infinity)
            stepButton("plus") { onReps(set.reps + measure.step) }
        }
        .frame(width: Self.countWidth)
        .background(Capsule().fill(DS.silver.opacity(0.06)))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(measure == .time ? "Set \(number) time" : "Set \(number) reps")
        .accessibilityValue(measure.value(set.reps))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: onReps(set.reps + measure.step)
            case .decrement: if set.reps > measure.step { onReps(set.reps - measure.step) }
            @unknown default: break
            }
        }
    }

    private func stepButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(DS.silver.opacity(0.75))
                .frame(width: 30, height: 34)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: Timed hold

    private var holdButton: some View {
        Button {
            holdStart = Date()
        } label: {
            Image(systemName: "play.fill")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(DS.silver)
                .frame(width: Self.holdWidth, height: 34)
                .background(Circle().fill(DS.silver.opacity(0.08)))
        }
        .buttonStyle(.plain)
        .disabled(!canLog || set.isCompleted)
        .opacity(canLog && !set.isCompleted ? 1 : 0.35)
        .accessibilityLabel("Start timing set \(number)")
    }

    /// Counts up from the start; Stop saves the time and marks the set done.
    private func runningHold(since start: Date) -> some View {
        TimelineView(.periodic(from: start, by: 1)) { context in
            let elapsed = max(0, Int(context.date.timeIntervalSince(start)))
            HStack(spacing: Self.spacing) {
                Button {
                    holdStart = nil
                    onHold(max(1, Int(Date().timeIntervalSince(start))))
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(DS.ink)
                        .frame(width: Self.holdWidth, height: 34)
                        .background(Circle().fill(DS.silver))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Stop timing set \(number)")

                HStack(spacing: 4) {
                    Text(SetMeasure.clock(elapsed))
                        .font(.mono(14, .semibold))
                        .foregroundStyle(DS.silver)
                        .contentTransition(.numericText())
                    Text("/ \(SetMeasure.clock(set.reps))")
                        .font(.mono(11, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.4))
                }
                .frame(width: Self.countWidth)
                .accessibilityElement(children: .combine)
            }
            // One tap on the wrist when the target time is reached.
            .sensoryFeedback(.success, trigger: elapsed >= set.reps) { old, new in !old && new }
        }
    }

    // MARK: Done

    private var doneButton: some View {
        Button(action: onToggle) {
            Image(systemName: "checkmark")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(set.isCompleted ? DS.ink : DS.silver.opacity(0.55))
                .frame(width: 36, height: 36)
                .background(Circle().fill(set.isCompleted ? DS.silver : DS.silver.opacity(0.07)))
                .overlay(Circle().strokeBorder(DS.silver.opacity(set.isCompleted ? 0 : 0.14), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .disabled(!canLog || holdStart != nil)
        .opacity(canLog ? 1 : 0.4)
        .accessibilityLabel("Set \(number) done")
        .accessibilityValue(set.isCompleted ? "Done" : "Not done")
    }
}

/// A set's weight, typed in the user's unit and saved in kilograms when the
/// field loses focus. Empty shows the placeholder (last time's weight).
struct WeightField: View {
    var weight: Double?
    var unit: WeightUnit
    var placeholder: String
    var setID: UUID
    var focus: FocusState<UUID?>.Binding
    var onCommit: (Double?) -> Void

    @State private var text = ""

    private var isFocused: Bool { focus.wrappedValue == setID }

    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(DS.silver.opacity(0.3)))
            .keyboardType(.decimalPad)
            .focused(focus, equals: setID)
            .multilineTextAlignment(.center)
            .font(.mono(14, .semibold))
            .foregroundStyle(DS.silver)
            .frame(height: 34)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(DS.silver.opacity(isFocused ? 0.13 : 0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(DS.silver.opacity(isFocused ? 0.35 : 0), lineWidth: 1)
            )
            .onAppear(perform: show)
            .onChange(of: weight) { if !isFocused { show() } }
            .onChange(of: unit) { show() }
            .onChange(of: focus.wrappedValue) { old, new in
                if old == setID && new != setID { commit() }
            }
            .onSubmit(commit)
    }

    private func show() {
        text = weight.map(unit.number) ?? ""
    }

    private func commit() {
        let typed = text.trimmingCharacters(in: .whitespaces)
        if typed.isEmpty {
            onCommit(nil)
        } else if let kg = unit.parse(typed) {
            onCommit(kg)
            text = unit.number(kg)
        } else {
            show()
        }
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
