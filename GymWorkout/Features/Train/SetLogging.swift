//
//  SetLogging.swift
//  GymWorkout
//
//  Logging sets, shared by the muscle group's list and anywhere else a set
//  is ticked off (2026-11-27): the owner wants sets and rest out on the
//  list, under each exercise, with big controls near the thumb, and the
//  exercise screen kept for watching the model and reading how to do it.
//
//  `SetLogger` is one exercise's sets; `RestChip` picks the rest after its
//  sets; `SetLoggingBar` is the list's pinned "Done set" bar. The set rows
//  themselves (`SetRow`, `SetColumns`, `WeightField`) moved here from
//  `ExerciseDetailView`, with a `thumb` size for the list.
//

import SwiftUI

// MARK: - Rest per exercise

/// The rest after each set of one exercise, picked on the list. Stored by
/// raw value in `WorkoutStore.restOverrides`; an exercise without one
/// follows the Settings rest (`RestSetting`).
enum ExerciseRest: Int, CaseIterable, Identifiable {
    case auto = -1
    case off = 0
    case s45 = 45
    case s60 = 60
    case s90 = 90
    case s120 = 120
    case s180 = 180

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .auto: return String(localized: "Auto", comment: "Rest timer setting")
        case .off: return String(localized: "Off", comment: "Rest timer setting")
        default: return SetLogging.clock(rawValue)
        }
    }

    /// Seconds of rest after a set of `exercise`; nil when off. Auto rests
    /// as the Settings' Auto does.
    func seconds(after exercise: WorkoutExercise) -> Int? {
        switch self {
        case .auto: return RestSetting.auto.seconds(after: exercise)
        case .off: return nil
        default: return rawValue
        }
    }
}

// MARK: - Actions

enum SetLogging {
    /// After a set was ticked or unticked: starts the rest after one marked
    /// done today, and completes the exercise once every set is done.
    /// True when that just completed it.
    @discardableResult
    static func afterToggle(exerciseID: UUID, setID: UUID, store: WorkoutStore, restTimer: RestTimer) -> Bool {
        restTimer.startIfDone(exerciseID: exerciseID, setID: setID, store: store)
        guard let exercise = store.exercise(id: exerciseID), !exercise.isCompleted,
              !exercise.sets.isEmpty, exercise.sets.allSatisfy(\.isCompleted) else { return false }
        store.completeExercise(id: exerciseID)
        return true
    }

    /// After a set was deleted: the exercise is complete once what's left
    /// is all done (and something is).
    @discardableResult
    static func afterRemove(exerciseID: UUID, store: WorkoutStore) -> Bool {
        guard let exercise = store.exercise(id: exerciseID), !exercise.isCompleted,
              !exercise.sets.isEmpty, exercise.sets.allSatisfy(\.isCompleted) else { return false }
        store.completeExercise(id: exerciseID)
        return true
    }

    /// The first set not done yet.
    static func nextOpenSet(of exercise: WorkoutExercise) -> (number: Int, set: WorkoutSet)? {
        guard let index = exercise.sets.firstIndex(where: { !$0.isCompleted }) else { return nil }
        return (index + 1, exercise.sets[index])
    }

    /// "0:45", "1:30".
    static func clock(_ seconds: Int) -> String {
        String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    /// "40 kg × 10 · 40 kg × 9": last time's sets on one line.
    static func lastTimeLine(_ previous: PreviousPerformance, unit: WeightUnit) -> String {
        previous.sets.map { SetText.short($0, measure: previous.measure, unit: unit) }.joined(separator: " · ")
    }
}

// MARK: - Set logger

/// One exercise's sets on the list: last time on one line, a big row per
/// set and "+ Set". Works on a list not yet added to the day: `prepare`
/// writes it in (keeping its ids) before the first change.
struct SetLogger: View {
    var item: WorkoutExercise
    var day: Date
    var focus: FocusState<UUID?>.Binding
    var metrics: SetRow.Metrics = .thumb
    var prepare: () -> Void = {}
    /// Every set is done: the exercise has just been completed.
    var onFinished: () -> Void = {}

    @Environment(WorkoutStore.self) private var store
    @Environment(RestTimer.self) private var restTimer
    @Environment(\.dsLayout) private var layout

    var body: some View {
        let canLog = store.canLog(on: day)
        let previous = PerformanceHistory.previous(of: item.exerciseName, before: day, in: store.sessions)
            .flatMap { $0.measure == item.setMeasure ? $0 : nil }
        let records = PerformanceHistory.recordSetIDs(for: item.exerciseName, in: store.sessions)
        let bodyweight = ExerciseCatalog.isBodyweight(item.exerciseName)
        VStack(alignment: .leading, spacing: 8) {
            if let previous {
                HStack(spacing: 8) {
                    Text("LAST", comment: "Before last session's sets on the set list")
                        .font(.mono(9.5, .semibold))
                        .trackingEm(0.08, size: 9.5)
                        .foregroundStyle(DS.silver.opacity(0.4))
                    Text(SetLogging.lastTimeLine(previous, unit: store.unit))
                        .font(.mono(12, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.horizontal, metrics.inset)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(String(localized: "Last time, \(RecoveryText.day(previous.day)): \(SetLogging.lastTimeLine(previous, unit: store.unit))",
                                           comment: "VoiceOver: a day, then last session's sets"))
            }

            SetColumns(measure: item.setMeasure, unit: store.unit, metrics: metrics)

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
                    focus: focus,
                    nextSetID: index + 1 < item.sets.count ? item.sets[index + 1].id : nil,
                    onToggle: { toggle(set.id) },
                    onReps: { reps in
                        prepare()
                        store.setReps(reps, exerciseID: item.id, setID: set.id)
                    },
                    onWeight: { kg in
                        // An empty field losing focus isn't a change.
                        guard kg != set.weight else { return }
                        prepare()
                        store.setWeight(kg, exerciseID: item.id, setID: set.id)
                    },
                    onHold: { seconds in
                        prepare()
                        withAnimation(.easeOut(duration: 0.15)) {
                            store.completeHold(seconds: seconds, exerciseID: item.id, setID: set.id)
                        }
                        if SetLogging.afterToggle(exerciseID: item.id, setID: set.id, store: store, restTimer: restTimer) {
                            onFinished()
                        }
                    },
                    onDelete: item.sets.count > 1 ? {
                        prepare()
                        store.removeSet(exerciseID: item.id, setID: set.id)
                        if SetLogging.afterRemove(exerciseID: item.id, store: store) { onFinished() }
                    } : nil,
                    metrics: metrics
                )
            }

            Button {
                prepare()
                withAnimation { store.addSet(exerciseID: item.id) }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 13, weight: .bold))
                    Text("Set", comment: "Button: adds one more set to the exercise")
                        .font(.ui(15, .semibold))
                }
                .foregroundStyle(DS.silver.opacity(0.8))
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(
                    RoundedRectangle(cornerRadius: metrics.radius, style: .continuous)
                        .strokeBorder(DS.silver.opacity(0.16), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                )
                .contentShape(Rectangle())
                .dsHover(.highlight, radius: metrics.radius)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Add Set")

            // Moving on with sets left: the exercise ends here, and the
            // sets not done stay undone (they don't count).
            if canLog, !item.isCompleted, !item.completedSets.isEmpty,
               item.completedSets.count < item.sets.count {
                Button {
                    focus.wrappedValue = nil
                    prepare()
                    withAnimation { store.completeExercise(id: item.id) }
                    onFinished()
                } label: {
                    Text("Finish exercise", comment: "Button: ends an exercise with sets still undone")
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.8))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .contentShape(Rectangle())
                        .dsHover(.highlight, radius: metrics.radius)
                }
                .buttonStyle(.borderless)
                .accessibilityHint(String(localized: "Moves on; the sets not done don't count",
                                          comment: "VoiceOver hint on Finish exercise"))
            }

            if !canLog {
                Text("Sets can be marked done on the day.")
                    .font(.ui(layout.isRegular ? 12.5 : 11.5))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
        }
    }

    private func toggle(_ setID: UUID) {
        focus.wrappedValue = nil
        prepare()
        withAnimation(.easeOut(duration: 0.15)) {
            store.toggleSet(exerciseID: item.id, setID: setID)
        }
        if SetLogging.afterToggle(exerciseID: item.id, setID: setID, store: store, restTimer: restTimer) {
            onFinished()
        }
    }
}

// MARK: - Rest chip

/// "Rest 1:30": the rest after each set of this exercise. Opens a short
/// list of choices; one picked here wins over the Settings rest for this
/// exercise on every day.
struct RestChip: View {
    var exercise: WorkoutExercise

    @Environment(WorkoutStore.self) private var store

    var body: some View {
        let name = exercise.exerciseName
        let choice = store.restChoice(forExerciseNamed: name)
        let seconds = store.restSeconds(after: exercise)
        let title = seconds.map { String(localized: "Rest \(SetLogging.clock($0))", comment: "Chip: the rest after each set, e.g. Rest 1:30") }
            ?? String(localized: "Rest off", comment: "Chip: no rest timer after this exercise's sets")
        Menu {
            Picker(selection: Binding(get: { choice },
                                      set: { store.setRestChoice($0, forExerciseNamed: name) })) {
                ForEach(ExerciseRest.allCases) { option in
                    Text(option == .auto
                         ? String(localized: "Auto · \(SetLogging.clock(RestSetting.auto.seconds(after: exercise) ?? 0))",
                                  comment: "Rest choice: Auto, then the rest it gives this exercise")
                         : option.title)
                        .tag(Optional(option))
                }
            } label: {
                Text("Rest after each set")
            }
            .pickerStyle(.inline)

            if choice != nil {
                Button(String(localized: "Same as Settings (\(store.rest.title))",
                              comment: "Rest choice: follow the rest set in Settings, e.g. Auto or 1:30"),
                       systemImage: "arrow.uturn.backward") {
                    store.setRestChoice(nil, forExerciseNamed: name)
                }
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: seconds == nil ? "timer.slash" : "timer")
                    .font(.system(size: 12, weight: .semibold))
                Text(title)
                    .font(.ui(13, .semibold))
                    .monospacedDigit()
                    .lineLimit(1)
            }
            .fixedSize()
            .foregroundStyle(DS.silver.opacity(0.85))
            .padding(.horizontal, 12)
            .frame(height: 34)
            .background(Capsule().fill(DS.silver.opacity(0.07)))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(choice == nil ? 0.08 : 0.3), lineWidth: 1))
            .padding(.vertical, 5)
            .contentShape(Rectangle())
            .dsHover(.highlight)
        }
        .buttonStyle(.borderless)
        .accessibilityLabel(title)
        .accessibilityHint("Choose the rest after each set of \(name).")
    }
}

// MARK: - Bottom bar

/// The list's pinned bar, in the thumb's reach while a workout is going:
/// the sets done so far and one big button.
struct SetLoggingBar: View {
    var title: String
    var symbol: String = "checkmark"
    /// What the button acts on, e.g. "Glute Bridge · Set 2".
    var caption: String? = nil
    var done: Int = 0
    var total: Int = 0
    var enabled: Bool = true
    var action: () -> Void

    @Environment(\.dsLayout) private var layout

    var body: some View {
        VStack(spacing: 10) {
            if total > 0 {
                HStack(spacing: 10) {
                    if let caption {
                        Text(caption)
                            .font(.ui(13, .semibold))
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .lineLimit(1)
                    }
                    Spacer(minLength: 8)
                    Text("\(done) of \(total) sets")
                        .font(.mono(12, .semibold))
                        .monospacedDigit()
                        .foregroundStyle(DS.silver.opacity(0.75))
                }
                .accessibilityElement(children: .combine)
                ProgressBar(value: Double(done) / Double(max(total, 1)), color: DS.silver)
            }

            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: symbol)
                        .font(.system(size: 17, weight: .bold))
                    Text(title)
                        .font(.ui(18, .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundStyle(enabled ? DS.ink : DS.silver.opacity(0.45))
                .frame(maxWidth: .infinity, minHeight: 58)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(enabled ? DS.silver : DS.silver.opacity(0.08))
                )
                .contentShape(Rectangle())
                .dsHover(.highlight, radius: 18)
            }
            .buttonStyle(.plain)
            .disabled(!enabled)
            .sensoryFeedback(.success, trigger: done) { old, new in new > old }
        }
        .padding(.horizontal, layout.isRegular ? 20 : DS.Metric.gutter)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .frame(maxWidth: layout.isRegular ? 560 : nil)
        .frame(maxWidth: .infinity)
        .background {
            DS.ink
                .overlay(alignment: .top) {
                    Rectangle().fill(DS.silver.opacity(0.08)).frame(height: 1)
                }
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Set row

/// Column labels over the set rows, on the rows' own grid.
struct SetColumns: View {
    var measure: SetMeasure
    var unit: WeightUnit
    /// The rows' grid; nil takes the screen's (compact or regular).
    var metrics: SetRow.Metrics? = nil

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let m = metrics ?? SetRow.Metrics.of(layout)
        HStack(spacing: m.spacing) {
            label(String(localized: "SET", comment: "Set logger column: the set's number"),
                  width: m.numberWidth, max: nil, alignment: .leading)
            if measure == .reps {
                label(unit.symbol.uppercased(), width: m.weightWidth, max: m.weightMax)
                label(String(localized: "REPS", comment: "Set logger column"), width: m.countWidth, max: m.countMax)
            } else {
                label(String(localized: "TIME", comment: "Set logger column: a timed set's seconds"),
                      width: m.holdWidth + m.spacing + m.countWidth,
                      max: m.countMax.map { m.holdWidth + m.spacing + $0 }, alignment: .leading)
            }
            Spacer(minLength: 0)
            if m.recordSlot > 0 {
                // The rows' record and done slots, so the columns line up.
                Color.clear.frame(width: m.recordSlot, height: 0)
                Color.clear.frame(width: m.doneSize, height: 0)
            }
        }
        .padding(.horizontal, m.inset)
        .padding(.bottom, -4)
        .accessibilityHidden(true)
    }

    /// `alignment` is passed in rather than read from the text, which is
    /// localized: SET and TIME start their columns, the rest are centred.
    private func label(_ text: String, width: CGFloat, max: CGFloat?, alignment: Alignment = .center) -> some View {
        let size: CGFloat = layout.isRegular ? 9.5 : 8.5
        return Text(text)
            .font(.mono(size, .semibold))
            .trackingEm(0.08, size: size)
            .foregroundStyle(DS.silver.opacity(0.35))
            .modifier(SetColumnWidth(width: width, max: max, alignment: alignment))
    }
}

/// A column of the set grid: fixed on the phone. In regular it grows from
/// `width` to `max` as the row widens, ahead of the gap before the done
/// button — identically in the header and in every row, so they align.
struct SetColumnWidth: ViewModifier {
    var width: CGFloat
    var max: CGFloat?
    var alignment: Alignment = .center

    func body(content: Content) -> some View {
        if let max {
            content
                .frame(minWidth: width, maxWidth: max, alignment: alignment)
                .layoutPriority(1)
        } else {
            content.frame(width: width, alignment: alignment)
        }
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
    /// The set below, whose weight Return moves on to (iPad).
    var nextSetID: UUID? = nil
    var onToggle: () -> Void
    var onReps: (Int) -> Void
    var onWeight: (Double?) -> Void
    /// A timed hold stopped after this many seconds.
    var onHold: (Int) -> Void
    var onDelete: (() -> Void)?
    /// The row's grid and control sizes; nil takes the screen's.
    var metrics: Metrics? = nil

    static let spacing: CGFloat = 10
    static let inset: CGFloat = 10
    static let numberWidth: CGFloat = 26
    static let weightWidth: CGFloat = 66
    static let countWidth: CGFloat = 96
    static let holdWidth: CGFloat = 34

    /// The row's grid and control sizes, shared with `SetColumns`. Regular
    /// rows are sized for an iPad propped on a bench: 44pt targets and 16pt
    /// figures, still narrow enough (with a PR tag) for a 360pt column.
    struct Metrics {
        var spacing: CGFloat
        var inset: CGFloat
        var numberWidth: CGFloat
        var weightWidth: CGFloat
        var countWidth: CGFloat
        var holdWidth: CGFloat
        var controlHeight: CGFloat
        var stepWidth: CGFloat
        var doneSize: CGFloat
        var figure: CGFloat
        var rowPadding: CGFloat
        var radius: CGFloat
        /// How far the weight and count columns may grow; nil keeps them
        /// fixed.
        var weightMax: CGFloat? = nil
        var countMax: CGFloat? = nil
        /// Kept for the PR tag on every row, so a record doesn't shift the
        /// columns; 0 on the phone, where the tag just takes its room.
        var recordSlot: CGFloat = 0

        static let compact = Metrics(spacing: SetRow.spacing, inset: SetRow.inset,
                                     numberWidth: SetRow.numberWidth, weightWidth: SetRow.weightWidth,
                                     countWidth: SetRow.countWidth, holdWidth: SetRow.holdWidth,
                                     controlHeight: 34, stepWidth: 30, doneSize: 36, figure: 14,
                                     rowPadding: 8, radius: 14)
        // 372pt at the minimum widths: the narrowest logger column.
        static let regular = Metrics(spacing: 8, inset: 10, numberWidth: 30, weightWidth: 88,
                                     countWidth: 120, holdWidth: 44, controlHeight: 44, stepWidth: 40,
                                     doneSize: 44, figure: 16, rowPadding: 6, radius: 16,
                                     weightMax: 132, countMax: 176, recordSlot: 30)

        /// The set list's rows (2026-11-27, "lazy thumb"): 44pt steps and
        /// a 48pt done button, on a phone too. The PR tag takes the set
        /// number's place rather than room of its own.
        static let thumb = Metrics(spacing: 8, inset: 8, numberWidth: 26, weightWidth: 72,
                                   countWidth: 124, holdWidth: 44, controlHeight: 44, stepWidth: 44,
                                   doneSize: 48, figure: 17, rowPadding: 6, radius: 16,
                                   weightMax: 110, countMax: 170, recordOnNumber: true)

        /// Puts the PR tag where the set's number goes.
        var recordOnNumber = false

        static func of(_ layout: DSLayout) -> Metrics { layout.isRegular ? .regular : .compact }
    }

    @Environment(\.dsLayout) private var layout

    /// When a timed hold started; nil when none is running.
    @State private var holdStart: Date?

    private var m: Metrics { metrics ?? .of(layout) }

    var body: some View {
        HStack(spacing: m.spacing) {
            Group {
                if m.recordOnNumber && isRecord {
                    recordTag
                } else {
                    Text("\(number)")
                        .font(.mono(m.figure, .semibold))
                        .foregroundStyle(DS.silver.opacity(set.isCompleted ? 0.45 : 0.9))
                        .accessibilityLabel("Set \(number)")
                }
            }
            .frame(width: m.numberWidth, alignment: .leading)

            if measure == .reps {
                WeightField(weight: set.weight, unit: unit, placeholder: placeholder,
                            setID: set.id, focus: focus, nextSetID: nextSetID,
                            height: m.controlHeight, fontSize: m.figure, onCommit: onWeight)
                    .modifier(SetColumnWidth(width: m.weightWidth, max: m.weightMax))
                    .accessibilityLabel(unit == .kg ? "Set \(number) weight in kilograms"
                                                    : "Set \(number) weight in pounds")
                counter
            } else if let holdStart {
                runningHold(since: holdStart)
            } else {
                holdButton
                counter
            }

            Spacer(minLength: 0)

            if m.recordOnNumber {
                // The tag is on the number.
            } else if m.recordSlot > 0 {
                // Beside the done button, in a slot every row keeps.
                ZStack {
                    if isRecord { recordTag }
                }
                .frame(width: m.recordSlot)
            } else if isRecord {
                recordTag
            }

            doneButton
        }
        .padding(.horizontal, m.inset)
        .padding(.vertical, m.rowPadding)
        .background(
            RoundedRectangle(cornerRadius: m.radius, style: .continuous)
                .fill(DS.surfaceAlt)
        )
        .contextMenu {
            if let onDelete {
                Button("Delete Set", systemImage: "trash", role: .destructive, action: onDelete)
            }
        }
    }

    private var recordTag: some View {
        Text("PR")
            .font(.mono(layout.isRegular ? 10 : 9, .bold))
            .trackingEm(0.08, size: layout.isRegular ? 10 : 9)
            .foregroundStyle(DS.silver)
            .padding(.horizontal, 6)
            .padding(.vertical, layout.isRegular ? 4 : 3)
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.5), lineWidth: 1))
            .accessibilityLabel(m.recordOnNumber ? String(localized: "Set \(number), personal record")
                                                 : String(localized: "Personal record"))
    }

    private var placeholder: String {
        if let placeholderWeight { return unit.number(placeholderWeight) }
        return isBodyweight ? String(localized: "BW", comment: "Weight field placeholder: short for bodyweight") : "–"
    }

    // MARK: Reps or seconds

    private var counter: some View {
        HStack(spacing: 0) {
            stepButton("minus") { onReps(set.reps - measure.step) }
                .disabled(set.reps <= measure.step)
            Text(measure == .time ? SetMeasure.clock(set.reps) : "\(set.reps)")
                .font(.mono(m.figure, .semibold))
                .foregroundStyle(DS.silver)
                .frame(maxWidth: .infinity)
            stepButton("plus") { onReps(set.reps + measure.step) }
        }
        .modifier(SetColumnWidth(width: m.countWidth, max: m.countMax))
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
                .font(.system(size: m.stepWidth > 40 ? 14 : (layout.isRegular ? 12 : 11), weight: .bold))
                .foregroundStyle(DS.silver.opacity(0.75))
                .frame(width: m.stepWidth, height: m.controlHeight)
                .contentShape(Rectangle())
                .dsHover(.highlight)
        }
        .buttonStyle(.plain)
    }

    // MARK: Timed hold

    private var holdButton: some View {
        Button {
            holdStart = Date()
        } label: {
            Image(systemName: "play.fill")
                .font(.system(size: layout.isRegular ? 13 : 11, weight: .bold))
                .foregroundStyle(DS.silver)
                .frame(width: m.holdWidth, height: m.controlHeight)
                .background(Circle().fill(DS.silver.opacity(0.08)))
                .dsHover(.highlight)
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
            HStack(spacing: m.spacing) {
                Button {
                    holdStart = nil
                    onHold(max(1, Int(Date().timeIntervalSince(start))))
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.system(size: layout.isRegular ? 13 : 11, weight: .bold))
                        .foregroundStyle(DS.ink)
                        .frame(width: m.holdWidth, height: m.controlHeight)
                        .background(Circle().fill(DS.silver))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Stop timing set \(number)")

                HStack(spacing: 4) {
                    Text(SetMeasure.clock(elapsed))
                        .font(.mono(m.figure, .semibold))
                        .foregroundStyle(DS.silver)
                        .contentTransition(.numericText())
                    Text("/ \(SetMeasure.clock(set.reps))")
                        .font(.mono(layout.isRegular ? 12.5 : 11, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.4))
                }
                .modifier(SetColumnWidth(width: m.countWidth, max: m.countMax))
                .accessibilityElement(children: .combine)
            }
            .layoutPriority(m.countMax == nil ? 0 : 1)
            // One tap on the wrist when the target time is reached.
            .sensoryFeedback(.success, trigger: elapsed >= set.reps) { old, new in !old && new }
        }
    }

    // MARK: Done

    private var doneButton: some View {
        Button(action: onToggle) {
            Image(systemName: "checkmark")
                .font(.system(size: m.doneSize > 44 ? 17 : (layout.isRegular ? 15 : 13), weight: .bold))
                .foregroundStyle(set.isCompleted ? DS.ink : DS.silver.opacity(0.55))
                .frame(width: m.doneSize, height: m.doneSize)
                .background(Circle().fill(set.isCompleted ? DS.silver : DS.silver.opacity(0.07)))
                .overlay(Circle().strokeBorder(DS.silver.opacity(set.isCompleted ? 0 : 0.14), lineWidth: 1))
                .dsHover(.highlight)
        }
        .buttonStyle(.plain)
        .disabled(!canLog || holdStart != nil)
        .opacity(canLog ? 1 : 0.4)
        .accessibilityLabel("Set \(number) done")
        // Its own key: the set's state, not the keyboard's Done button.
        .accessibilityValue(set.isCompleted
                            ? String(localized: "set.done", defaultValue: "Done",
                                     comment: "VoiceOver value: the set is marked done")
                            : String(localized: "Not done"))
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
    /// Where Return moves on to on iPad; nil there ends the typing.
    var nextSetID: UUID? = nil
    /// The field's height and figure size; nil takes the screen's.
    var height: CGFloat? = nil
    var fontSize: CGFloat? = nil
    var onCommit: (Double?) -> Void

    @Environment(\.dsLayout) private var layout
    @State private var text = ""

    private var isFocused: Bool { focus.wrappedValue == setID }

    var body: some View {
        let regular = layout.isRegular
        let radius: CGFloat = regular ? 12 : 10
        TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(DS.silver.opacity(0.3)))
            .keyboardType(.decimalPad)
            .focused(focus, equals: setID)
            .multilineTextAlignment(.center)
            .font(.mono(fontSize ?? (regular ? 16 : 14), .semibold))
            .foregroundStyle(DS.silver)
            .frame(height: height ?? (regular ? 44 : 34))
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(DS.silver.opacity(isFocused ? 0.13 : 0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(DS.silver.opacity(isFocused ? 0.35 : 0), lineWidth: 1)
            )
            .onAppear(perform: show)
            .onChange(of: weight) { if !isFocused { show() } }
            .onChange(of: unit) { show() }
            .onChange(of: focus.wrappedValue) { old, new in
                if old == setID && new != setID { commit() }
            }
            .onSubmit(commit)
            .modifier(PadWeightEntry(text: $text, focus: focus, nextSetID: nextSetID))
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

/// iPad has no decimal pad: the full keyboard (or a hardware one) can type
/// anything. Keep the field to digits and one decimal separator as it's
/// typed, and let Return walk down the sets. The phone's decimal pad needs
/// none of this.
private struct PadWeightEntry: ViewModifier {
    @Binding var text: String
    var focus: FocusState<UUID?>.Binding
    var nextSetID: UUID?

    func body(content: Content) -> some View {
        if DS.isPad {
            content
                .submitLabel(nextSetID == nil ? .done : .next)
                .onChange(of: text) { _, new in
                    let clean = Self.sanitized(new)
                    if clean != new { text = clean }
                }
                // The field saves itself as focus leaves it.
                .onSubmit { focus.wrappedValue = nextSetID }
        } else {
            content
        }
    }

    /// Digits and the first decimal separator, as the locale writes it
    /// (`WeightUnit.parse` reads either "." or ",").
    static func sanitized(_ value: String) -> String {
        let separator: Character = Locale.current.decimalSeparator == "," ? "," : "."
        var result = ""
        var hasSeparator = false
        for character in value {
            if ("0"..."9").contains(character) {
                result.append(character)
            } else if character == "." || character == ",", !hasSeparator {
                // A whole-number weight never needs a leading separator.
                if result.isEmpty { result.append("0") }
                result.append(separator)
                hasSeparator = true
            }
        }
        return String(result.prefix(7))
    }
}
