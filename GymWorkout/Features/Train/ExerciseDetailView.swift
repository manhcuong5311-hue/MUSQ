//
//  ExerciseDetailView.swift
//  GymWorkout
//
//  One exercise inside a workout: the existing 3D model, the muscles it
//  trains, how to perform it (from the trainer content), and its sets. Only
//  sets marked Done count toward history and recovery.
//
//  On iPad the arrangement follows the view's own width, so the same screen
//  works pushed full screen and embedded as the preset screen's detail pane:
//  under 900pt one centred column (sets beside the instructions once the
//  column is 700pt), from 900pt a sticky model on the left and the set
//  logger scrolling on the right. iPhone keeps its single scrolling column.
//

import SwiftUI

struct ExerciseDetailView: View {
    var workoutExerciseID: UUID
    /// Pushed onto a tab's stack, or embedded as the detail pane of the iPad
    /// preset screen, which then owns closing it and moving on.
    var presentation: Presentation = .pushed

    enum Presentation {
        case pushed
        /// `onClose` takes the pane away (its ✕, or the exercise leaving the
        /// workout); `onCompleted` follows Complete Exercise.
        case embedded(onClose: () -> Void, onCompleted: () -> Void)
    }

    @Environment(WorkoutStore.self) private var store
    @Environment(TrainRouter.self) private var router
    @Environment(RestTimer.self) private var restTimer
    @Environment(\.dismiss) private var dismiss
    @Environment(Ads.self) private var ads
    @Environment(\.dsLayout) private var layout
    /// Set by a host that already shows the rest timer.
    @Environment(\.restTimerInsetSuppressed) private var hostShowsRest
    /// The set whose weight is being typed.
    @FocusState private var focusedSet: UUID?

    private var isEmbedded: Bool {
        if case .embedded = presentation { return true }
        return false
    }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()
            screen
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
        // Regular arrangements place the rest themselves (see `RestInset`),
        // and an embedded pane leaves it to its host's one timer.
        .environment(\.restTimerInsetSuppressed, hostShowsRest || isEmbedded || layout.isRegular)
        .modifier(PushedBackShortcuts(action: backShortcut))
    }

    @ViewBuilder
    private var screen: some View {
        if let item = store.exercise(id: workoutExerciseID),
           let exercise = ExerciseCatalog.exercise(named: item.exerciseName) {
            if layout.isRegular {
                regular(item, exercise)
            } else {
                compact(item, exercise)
            }
        } else {
            VStack(spacing: 14) {
                Text("This exercise is no longer in the workout.")
                    .font(.ui(14))
                    .foregroundStyle(DS.silver.opacity(0.6))
                WideButton(title: isEmbedded ? "Close" : "Back", prominent: false) { close() }
                    .frame(width: 160)
            }
        }
    }

    /// The phone's screen: one scrolling column under the header.
    private func compact(_ item: WorkoutExercise, _ exercise: Exercise) -> some View {
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
    }

    /// ⌘[ and Esc on a pushed screen, only while it is the top of the
    /// stack: the preset screen under it keeps its own shortcuts live.
    private var backShortcut: (() -> Void)? {
        guard !isEmbedded else { return nil }
        let id = workoutExerciseID
        return {
            if router.path.last == .exercise(id) { back() }
        }
    }

    /// The header's back: pops, and is the moment an ad may follow.
    private func back() {
        dismiss()
        ads.moment(.exerciseClosed)
    }

    /// Leaves the screen without the ad moment: the "no longer in the
    /// workout" fallback.
    private func close() {
        switch presentation {
        case .pushed: dismiss()
        case .embedded(let onClose, _): onClose()
        }
    }

    // MARK: - Header

    private func header(_ exercise: Exercise) -> some View {
        HStack(spacing: 12) {
            if !isEmbedded {
                CircleIconButton(action: back) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: layout.isRegular ? 15 : 14, weight: .semibold))
                        .foregroundStyle(DS.silver)
                }
                .accessibilityLabel("Back")
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(exercise.name)
                    .font(.ui(layout.text(.screenTitle), .semibold))
                    .tracking(layout.isRegular ? -0.35 : -0.25)
                    .foregroundStyle(DS.silver)
                    .lineLimit(1)
                    .minimumScaleFactor(layout.isRegular ? 0.85 : 1)
                MetaLine(text: exercise.trainerMeta)
                    .padding(.top, 3)
            }
            Spacer(minLength: 0)

            if case .embedded(let onClose, _) = presentation {
                CircleIconButton(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(DS.silver)
                }
                .accessibilityLabel("Close \(exercise.name)")
            }
        }
        // Regular callers frame the header to their content column, so the
        // back control lines up with the model's edge.
        .padding(.horizontal, layout.isRegular ? 0 : 16)
        .padding(.top, layout.isRegular ? 14 : 11)
        .padding(.bottom, layout.isRegular ? 14 : 10)
    }

    // MARK: - Regular (iPad)

    @ViewBuilder
    private func regular(_ item: WorkoutExercise, _ exercise: Exercise) -> some View {
        GeometryReader { geo in
            if geo.size.width >= DS.Layout.wideMin {
                split(item, exercise, size: geo.size)
            } else {
                column(item, exercise, width: geo.size.width)
            }
        }
    }

    /// Under 900pt: one centred column of at most 720pt. The model gets a
    /// pane sized to the window rather than the phone's fixed 340pt, and
    /// from 700pt the sets sit beside the instructions, so logging doesn't
    /// start below the fold.
    private func column(_ item: WorkoutExercise, _ exercise: Exercise, width: CGFloat) -> some View {
        let gutter: CGFloat = 24
        let content = max(0, min(width - 2 * gutter, 720))
        let windowHeight = layout.containerHeight > 0 ? layout.containerHeight : 1000
        let modelHeight = min(0.6 * width, 0.42 * windowHeight, 480)
        let paired = content >= 700
        // The logger needs ~360pt for a row with a PR tag; the prose takes
        // the rest.
        let setsWidth = max(372, ((content - 28) * 0.54).rounded())

        return VStack(spacing: 0) {
            header(exercise)
                .frame(width: content)
                .frame(maxWidth: .infinity)

            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        padModel(exercise, radius: layout.cardRadius * 1.3)
                            .frame(height: SampleData.model(for: exercise) == nil ? min(modelHeight, 260) : modelHeight)
                        targets(item)
                            .padding(.top, 24)

                        if paired {
                            HStack(alignment: .top, spacing: 28) {
                                instructions(exercise, stacked: true)
                                    .frame(width: max(0, content - 28 - setsWidth), alignment: .leading)
                                VStack(alignment: .leading, spacing: 0) {
                                    sets(item)
                                    completion(item)
                                        .padding(.top, 20)
                                }
                                .frame(width: setsWidth)
                            }
                            .padding(.top, layout.sectionSpacing)
                        } else {
                            instructions(exercise)
                                .frame(maxWidth: DS.Layout.readableWidth, alignment: .leading)
                                .padding(.top, 30)
                            sets(item)
                                .padding(.top, layout.sectionSpacing)
                            completion(item)
                                .padding(.top, 20)
                        }
                    }
                    .frame(width: content)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 40)
                }
                .scrollDismissesKeyboard(.interactively)
                .modifier(FollowsNewSet(count: item.sets.count, proxy: proxy) {
                    store.exercise(id: workoutExerciseID)?.sets.last?.id
                })
            }
        }
        .modifier(RestInset(enabled: !hostShowsRest && !isEmbedded))
    }

    /// 900pt and up: the model stays put on the left, as tall as the window
    /// allows, while the sets scroll on the right, nearest the hand. The
    /// rest rides under the sets, so the stage never resizes as it comes
    /// and goes.
    private func split(_ item: WorkoutExercise, _ exercise: Exercise, size: CGSize) -> some View {
        let gutter = layout.gutter
        let spacing: CGFloat = 24
        let stageWidth = min(max(size.width * 0.46, 420), 620)
        let loggerWidth = max(0, min(560, size.width - 2 * gutter - spacing - stageWidth))
        let total = stageWidth + spacing + loggerWidth
        let hasModel = SampleData.model(for: exercise) != nil
        // Past the stage's own aspect a taller pane only adds empty ground.
        let tallest = stageWidth / DS.Metric.designStageAspect
        let shortest: CGFloat = size.height >= 640 ? 480 : 300

        return VStack(spacing: 0) {
            header(exercise)
                .frame(width: total)

            HStack(alignment: .top, spacing: spacing) {
                VStack(alignment: .leading, spacing: 22) {
                    padModel(exercise, radius: DS.Layout.paneRadius)
                        .frame(minHeight: hasModel ? shortest : 320,
                               maxHeight: hasModel ? max(shortest, tallest) : 360)
                    targets(item)
                }
                .frame(width: stageWidth)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.bottom, 24)
                // The keyboard rises over the stage rather than squashing it.
                .ignoresSafeArea(.keyboard, edges: .bottom)

                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            sets(item)
                            completion(item)
                                .padding(.top, 20)
                            instructions(exercise)
                                .padding(.top, layout.sectionSpacing)
                        }
                        .padding(.top, 2)
                        .padding(.bottom, 40)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .modifier(FollowsNewSet(count: item.sets.count, proxy: proxy) {
                        store.exercise(id: workoutExerciseID)?.sets.last?.id
                    })
                }
                .frame(width: loggerWidth)
                .modifier(RestInset(enabled: !hostShowsRest && !isEmbedded))
            }
            .frame(width: total)
            .frame(maxWidth: .infinity)
        }
    }

    /// The live model in a pane of any shape: the phone's stage aspect sits
    /// centred inside, so the lifter keeps its proportions and the studio
    /// ground fills the rest. A drag anywhere on the pane turns it.
    @ViewBuilder
    private func padModel(_ exercise: Exercise, radius: CGFloat) -> some View {
        if let model = SampleData.model(for: exercise) {
            Viewport(slot: exercise.slotID, model: model.resource, framing: model.framing,
                     speed: model.speed, cornerRadius: radius,
                     stageAspect: DS.Metric.designStageAspect, dragReferenceWidth: 560,
                     overlay: { EmptyView() },
                     chrome: {
                         if SampleData.hasTrainer(exercise) {
                             trainerButton(exercise)
                                 .padding(14)
                                 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                         }
                     })
        } else {
            Viewport(slot: exercise.slotID, cornerRadius: radius, stageAspect: DS.Metric.designStageAspect)
                .overlay {
                    Text("No 3D model for this exercise yet")
                        .font(.mono(10.5, .semibold))
                        .trackingEm(0.08, size: 10.5)
                        .foregroundStyle(DS.silver.opacity(0.4))
                }
        }
    }

    private func trainerButton(_ exercise: Exercise) -> some View {
        Button {
            router.push(.trainer(exerciseName: exercise.name))
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "cube.transparent")
                Text("3D Trainer & Key Tips")
            }
            .font(.ui(13.5, .semibold))
            .foregroundStyle(DS.silver)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Capsule().fill(DS.glass(0.72)))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.12), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .dsHover(.highlight)
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
        let regular = layout.isRegular
        return HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(title)
                .font(.mono(regular ? 10 : 9, .semibold))
                .trackingEm(0.08, size: regular ? 10 : 9)
                .foregroundStyle(DS.silver.opacity(0.4))
                .frame(width: regular ? 88 : 78, alignment: .leading)
            FlowRow(spacing: regular ? 7 : 6) {
                ForEach(muscles) { muscle in
                    HStack(spacing: regular ? 6 : 5) {
                        Circle()
                            .fill(lit ? DS.activation : ActivationRank.secondary.barColor)
                            .frame(width: regular ? 7 : 6, height: regular ? 7 : 6)
                        Text(muscle.title)
                            .font(.ui(regular ? 13.5 : 12.5, .semibold))
                            .foregroundStyle(DS.silver)
                    }
                    .padding(.horizontal, regular ? 11 : 9)
                    .padding(.vertical, regular ? 6 : 5)
                    .background(Capsule().fill(DS.silver.opacity(0.07)))
                }
            }
        }
    }

    // MARK: - How to perform

    /// `stacked` puts each step's label over its text, for a column too
    /// narrow to spare the label its own gutter.
    @ViewBuilder
    private func instructions(_ exercise: Exercise, stacked: Bool = false) -> some View {
        let steps = ExerciseCatalog.setupSteps(for: exercise)
        let cues = ExerciseCatalog.formCues(for: exercise)
        let regular = layout.isRegular
        let prose: CGFloat = regular ? 15 : 13.5
        VStack(alignment: .leading, spacing: regular ? 16 : 14) {
            SectionEyebrow(text: "HOW TO PERFORM")
            if steps.isEmpty && cues.isEmpty {
                Text("No step-by-step guide for this exercise yet.")
                    .font(.ui(regular ? 14.5 : 13.5))
                    .foregroundStyle(DS.silver.opacity(0.5))
            }
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                stepRow("STEP \(index + 1)", step, stacked: stacked)
            }
            if !cues.isEmpty {
                Text("FORM CUES")
                    .font(.mono(regular ? 10 : 9, .semibold))
                    .trackingEm(0.10, size: regular ? 10 : 9)
                    .foregroundStyle(DS.silver.opacity(0.4))
                    .padding(.top, 6)
                ForEach(Array(cues.enumerated()), id: \.offset) { _, cue in
                    VStack(alignment: .leading, spacing: regular ? 4 : 3) {
                        Text(cue.title)
                            .font(.ui(prose, .semibold))
                            .foregroundStyle(DS.silver)
                        Text(cue.text)
                            .font(.ui(prose))
                            .cssLineHeight(prose, regular ? 1.5 : 1.45)
                            .foregroundStyle(DS.silver.opacity(0.65))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func stepRow(_ label: String, _ text: String, stacked: Bool = false) -> some View {
        let regular = layout.isRegular
        let size: CGFloat = regular ? 15 : 14
        if stacked {
            VStack(alignment: .leading, spacing: 5) {
                Text(label)
                    .font(.mono(10, .semibold))
                    .trackingEm(0.06, size: 10)
                    .foregroundStyle(DS.silver.opacity(0.4))
                Text(text)
                    .font(.ui(size))
                    .cssLineHeight(size, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
        } else {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(label)
                    .font(.mono(regular ? 10 : 9, .semibold))
                    .trackingEm(0.06, size: regular ? 10 : 9)
                    .foregroundStyle(DS.silver.opacity(0.4))
                    .frame(width: regular ? 56 : 48, alignment: .leading)
                Text(text)
                    .font(.ui(size))
                    .cssLineHeight(size, regular ? 1.5 : 1.45)
                    .foregroundStyle(DS.silver.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
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
        let regular = layout.isRegular
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
                    nextSetID: index + 1 < item.sets.count ? item.sets[index + 1].id : nil,
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
                // The same identity the ForEach gives it, named so the
                // regular screens can scroll a new set into view.
                .id(set.id)
            }

            Button {
                withAnimation { store.addSet(exerciseID: item.id) }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: regular ? 12 : 11, weight: .semibold))
                    Text("Add Set")
                        .font(.ui(regular ? 15 : 13.5, .semibold))
                }
                .foregroundStyle(DS.silver)
                .frame(maxWidth: .infinity)
                .padding(.vertical, regular ? 14 : 11)
                .background(
                    RoundedRectangle(cornerRadius: regular ? 16 : 13, style: .continuous)
                        .strokeBorder(DS.silver.opacity(0.18), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                )
                .dsHover(.highlight, radius: regular ? 16 : 13)
            }
            .buttonStyle(.plain)

            if !canLog {
                Text("This day hasn't happened yet — sets can be marked done on the day.")
                    .font(.ui(regular ? 12.5 : 11.5))
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
        .padding(layout.isRegular ? 14 : 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: layout.isRegular ? 16 : 14, style: .continuous)
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
            .font(.ui(layout.isRegular ? 14 : 13, .semibold))
            .foregroundStyle(DS.silver.opacity(0.7))
            .frame(maxWidth: .infinity)
        } else {
            VStack(spacing: 8) {
                WideButton(title: "Complete Exercise", prominent: done > 0) {
                    store.completeExercise(id: item.id)
                    switch presentation {
                    case .pushed: dismiss()
                    case .embedded(_, let onCompleted): onCompleted()
                    }
                }
                .disabled(done == 0)
                .opacity(done > 0 ? 1 : 0.5)
                Text(done == 0
                     ? "Mark sets Done as you finish them."
                     : "Only sets marked Done count toward your muscle history.")
                    .font(.ui(layout.isRegular ? 12.5 : 11.5))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
        }
    }
}

// MARK: - iPad helpers

/// ⌘[ and Esc go back on a pushed screen. An embedded pane has none of its
/// own: its host's shortcuts close it.
private struct PushedBackShortcuts: ViewModifier {
    var action: (() -> Void)?

    func body(content: Content) -> some View {
        if let action {
            content.dsBackShortcuts(action)
        } else {
            content
        }
    }
}

/// The rest timer under the part of a regular screen it belongs to.
/// Restores the host's setting first, which `ExerciseDetailView` overrides
/// for its whole tree.
private struct RestInset: ViewModifier {
    var enabled: Bool

    func body(content: Content) -> some View {
        content
            .restTimerInset()
            .environment(\.restTimerInsetSuppressed, !enabled)
    }
}

/// Brings a new set into view as it's added. Regular screens use this in
/// place of the phone's bottom scroll anchor, which would also jump to the
/// bottom on every rotation or Split View resize.
private struct FollowsNewSet: ViewModifier {
    var count: Int
    var proxy: ScrollViewProxy
    /// Read when the count grows, so it sees the new set.
    var lastID: () -> UUID?

    func body(content: Content) -> some View {
        content.onChange(of: count) { old, new in
            guard new > old, let id = lastID() else { return }
            // Low in the view, with Add Set still showing beneath it.
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(id, anchor: UnitPoint(x: 0.5, y: 0.75))
            }
        }
    }
}

// MARK: - Set row

/// Column labels over the set rows, on the rows' own grid.
struct SetColumns: View {
    var measure: SetMeasure
    var unit: WeightUnit

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let m = SetRow.Metrics.of(layout)
        HStack(spacing: m.spacing) {
            label("SET", width: m.numberWidth, max: nil)
            if measure == .reps {
                label(unit.symbol.uppercased(), width: m.weightWidth, max: m.weightMax)
                label("REPS", width: m.countWidth, max: m.countMax)
            } else {
                label("TIME", width: m.holdWidth + m.spacing + m.countWidth,
                      max: m.countMax.map { m.holdWidth + m.spacing + $0 })
            }
            Spacer(minLength: 0)
            if layout.isRegular {
                // The rows' record and done slots, so the columns line up.
                Color.clear.frame(width: m.recordSlot, height: 0)
                Color.clear.frame(width: m.doneSize, height: 0)
            }
        }
        .padding(.horizontal, m.inset)
        .padding(.bottom, -4)
        .accessibilityHidden(true)
    }

    private func label(_ text: String, width: CGFloat, max: CGFloat?) -> some View {
        let size: CGFloat = layout.isRegular ? 9.5 : 8.5
        return Text(text)
            .font(.mono(size, .semibold))
            .trackingEm(0.08, size: size)
            .foregroundStyle(DS.silver.opacity(0.35))
            .modifier(SetColumnWidth(width: width, max: max,
                                     alignment: text == "SET" || text == "TIME" ? .leading : .center))
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

        static func of(_ layout: DSLayout) -> Metrics { layout.isRegular ? .regular : .compact }
    }

    @Environment(\.dsLayout) private var layout

    /// When a timed hold started; nil when none is running.
    @State private var holdStart: Date?

    private var m: Metrics { .of(layout) }

    var body: some View {
        HStack(spacing: m.spacing) {
            Text("\(number)")
                .font(.mono(m.figure, .semibold))
                .foregroundStyle(DS.silver.opacity(set.isCompleted ? 0.45 : 0.9))
                .frame(width: m.numberWidth, alignment: .leading)
                .accessibilityLabel("Set \(number)")

            if measure == .reps {
                WeightField(weight: set.weight, unit: unit, placeholder: placeholder,
                            setID: set.id, focus: focus, nextSetID: nextSetID, onCommit: onWeight)
                    .modifier(SetColumnWidth(width: m.weightWidth, max: m.weightMax))
                    .accessibilityLabel("Set \(number) weight in \(unit == .kg ? "kilograms" : "pounds")")
                counter
            } else if let holdStart {
                runningHold(since: holdStart)
            } else {
                holdButton
                counter
            }

            Spacer(minLength: 0)

            if layout.isRegular {
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
            .accessibilityLabel("Personal record")
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
                .font(.system(size: layout.isRegular ? 12 : 11, weight: .bold))
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
                .font(.system(size: layout.isRegular ? 15 : 13, weight: .bold))
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
    /// Where Return moves on to on iPad; nil there ends the typing.
    var nextSetID: UUID? = nil
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
            .font(.mono(regular ? 16 : 14, .semibold))
            .foregroundStyle(DS.silver)
            .frame(height: regular ? 44 : 34)
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
