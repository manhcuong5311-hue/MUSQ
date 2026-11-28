//
//  ExerciseDetailView.swift
//  GymWorkout
//
//  One exercise inside a workout, for watching and reading: the existing 3D
//  model, the muscles it trains, and how to perform it (from the trainer
//  content). Since 2026-11-27 sets are logged on the muscle group's list
//  (`SetLogger`), so this screen ends in one big "Log sets" button that goes
//  back there, and How to Perform shows each step on one line until tapped.
//  The model pauses while it is scrolled out of view, and when the host says
//  the user is logging (`modelPlaybackActive`), to save battery.
//
//  On iPad the arrangement follows the view's own width, so the same screen
//  works pushed full screen and embedded as the preset screen's detail pane:
//  under 900pt one centred column, from 900pt a sticky model on the left and
//  the instructions scrolling on the right. iPhone keeps its single
//  scrolling column.
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
        /// workout); `onCompleted` follows the exercise's last set.
        case embedded(onClose: () -> Void, onCompleted: () -> Void)
    }

    @Environment(WorkoutStore.self) private var store
    @Environment(TrainRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    @Environment(Ads.self) private var ads
    @Environment(\.dsLayout) private var layout
    /// Set by a host that already shows the rest timer.
    @Environment(\.restTimerInsetSuppressed) private var hostShowsRest
    /// False while the host has the user logging sets.
    @Environment(\.modelPlaybackActive) private var hostAllowsPlayback
    /// The model is at least partly on screen in its scroll view.
    @State private var modelInView = true
    /// How to Perform's rows opened to their full text: step indexes, and
    /// form cues from 1000.
    @State private var openRows: Set<Int> = []

    private var isEmbedded: Bool {
        if case .embedded = presentation { return true }
        return false
    }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()
            screen
        }
        .environment(\.modelPlaybackActive, hostAllowsPlayback && modelInView)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .restTimerInset()
        // An embedded pane leaves the rest to its host's one timer.
        .environment(\.restTimerInsetSuppressed, hostShowsRest || isEmbedded)
        // Under the rest, in the thumb's reach.
        .safeAreaInset(edge: .bottom, spacing: 0) { logSetsBar }
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

    /// Back to the list, where the sets are logged. Pushed only: embedded,
    /// the list is already beside the pane.
    @ViewBuilder
    private var logSetsBar: some View {
        if !isEmbedded, let item = store.exercise(id: workoutExerciseID) {
            SetLoggingBar(title: String(localized: "Log Sets", comment: "Button: back to the list to log this exercise's sets"),
                          symbol: "list.bullet",
                          done: item.completedSets.count, total: item.sets.count) {
                // Mid-workout: no ad moment on the way back to the sets.
                dismiss()
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
                        .onScrollVisibilityChange(threshold: 0.15) { modelInView = $0 }
                    targets(item)
                        .padding(.top, 22)
                    instructions(exercise)
                        .padding(.top, 26)
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.bottom, 32)
            }
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
    /// pane sized to the window rather than the phone's fixed 340pt.
    private func column(_ item: WorkoutExercise, _ exercise: Exercise, width: CGFloat) -> some View {
        let gutter: CGFloat = 24
        let content = max(0, min(width - 2 * gutter, 720))
        let windowHeight = layout.containerHeight > 0 ? layout.containerHeight : 1000
        let modelHeight = min(0.6 * width, 0.42 * windowHeight, 480)

        return VStack(spacing: 0) {
            header(exercise)
                .frame(width: content)
                .frame(maxWidth: .infinity)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    padModel(exercise, radius: layout.cardRadius * 1.3)
                        .frame(height: SampleData.model(for: exercise) == nil ? min(modelHeight, 260) : modelHeight)
                        .onScrollVisibilityChange(threshold: 0.15) { modelInView = $0 }
                    targets(item)
                        .padding(.top, 24)
                    instructions(exercise)
                        .frame(maxWidth: DS.Layout.readableWidth, alignment: .leading)
                        .padding(.top, 30)
                }
                .frame(width: content)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 40)
            }
        }
    }

    /// 900pt and up: the model stays put on the left, as tall as the window
    /// allows, while the instructions scroll on the right.
    private func split(_ item: WorkoutExercise, _ exercise: Exercise, size: CGSize) -> some View {
        let gutter = layout.gutter
        let spacing: CGFloat = 24
        let stageWidth = min(max(size.width * 0.46, 420), 620)
        let readerWidth = max(0, min(560, size.width - 2 * gutter - spacing - stageWidth))
        let total = stageWidth + spacing + readerWidth
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

                ScrollView(showsIndicators: false) {
                    instructions(exercise)
                        .padding(.top, 2)
                        .padding(.bottom, 40)
                }
                .frame(width: readerWidth)
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
            if !primary.isEmpty { muscleLine(String(localized: "PRIMARY", comment: "Muscle role: a main mover"), primary, lit: true) }
            if !secondary.isEmpty { muscleLine(String(localized: "SECONDARY", comment: "Muscle role: a helper"), secondary, lit: false) }
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

    /// Each step on one line and each form cue by its title; a tap opens
    /// the full text, so the screen stays short.
    @ViewBuilder
    private func instructions(_ exercise: Exercise) -> some View {
        let steps = ExerciseCatalog.setupSteps(for: exercise)
        let cues = ExerciseCatalog.formCues(for: exercise)
        let regular = layout.isRegular
        VStack(alignment: .leading, spacing: 8) {
            SectionEyebrow(text: "HOW TO PERFORM")
                .padding(.bottom, 4)
            if steps.isEmpty && cues.isEmpty {
                Text("No step-by-step guide for this exercise yet.")
                    .font(.ui(regular ? 14.5 : 13.5))
                    .foregroundStyle(DS.silver.opacity(0.5))
            }
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                foldRow(id: index, label: String(localized: "STEP \(index + 1)"), title: step, text: nil)
            }
            if !cues.isEmpty {
                Text("FORM CUES")
                    .font(.mono(regular ? 10 : 9, .semibold))
                    .trackingEm(0.10, size: regular ? 10 : 9)
                    .foregroundStyle(DS.silver.opacity(0.4))
                    .padding(.top, 10)
                    .padding(.bottom, 2)
                ForEach(Array(cues.enumerated()), id: \.offset) { index, cue in
                    foldRow(id: 1000 + index, label: nil, title: cue.title, text: cue.text)
                }
            }
        }
    }

    /// A step or cue folded to one line. A step's text is its own title,
    /// cut to one line until opened; a cue shows its title and opens to its
    /// text.
    private func foldRow(id: Int, label: String?, title: String, text: String?) -> some View {
        let regular = layout.isRegular
        let size: CGFloat = regular ? 15 : 14
        let isOpen = openRows.contains(id)
        return Button {
            withAnimation(.easeOut(duration: 0.18)) {
                if isOpen { openRows.remove(id) } else { openRows.insert(id) }
            }
        } label: {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                if let label {
                    Text(label)
                        .font(.mono(regular ? 10 : 9, .semibold))
                        .trackingEm(0.06, size: regular ? 10 : 9)
                        .foregroundStyle(DS.silver.opacity(0.4))
                        .frame(width: regular ? 56 : 48, alignment: .leading)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ui(size, text == nil ? .regular : .semibold))
                        .cssLineHeight(size, 1.45)
                        .foregroundStyle(DS.silver.opacity(text == nil ? 0.85 : 1))
                        .lineLimit(isOpen || text != nil ? nil : 1)
                        .fixedSize(horizontal: false, vertical: isOpen)
                    if isOpen, let text {
                        Text(text)
                            .font(.ui(size))
                            .cssLineHeight(size, 1.45)
                            .foregroundStyle(DS.silver.opacity(0.65))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.35))
                    .rotationEffect(.degrees(isOpen ? 180 : 0))
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .frame(minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(DS.silver.opacity(isOpen ? 0.06 : 0.035))
            )
            .contentShape(Rectangle())
            .dsHover(.highlight, radius: 14)
        }
        .buttonStyle(.plain)
        .accessibilityValue(isOpen ? String(localized: "Expanded") : String(localized: "Collapsed"))
        .accessibilityHint(isOpen ? String(localized: "Folds it to one line.") : String(localized: "Shows the full text."))
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
