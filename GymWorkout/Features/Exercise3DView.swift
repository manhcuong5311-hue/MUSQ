//
//  Exercise3DView.swift
//  GymWorkout
//
//  Screen 1c — the primary Exercise 3D View, plus the two states the design
//  models on top of it: the muscle activation panel (1d) and the technique-cue
//  sheet with its "common mistake" overlay (1e). Beyond the design: a toggle
//  that hides the key tips to watch the bare movement, and the swipe-up
//  setup drawer under the viewport.
//
//  The heart saves the exercise, and "Add to Today" on the setup bar puts it
//  in today's workout, so the library is a way into training, not only
//  reading.
//
//  Everything on this screen is driven by the exercise's `ExerciseContent`.
//  An exercise without one is gated (see `TrainerUnavailableView`) rather than
//  borrowing another lift's cues and activation.
//

import SwiftUI

struct Exercise3DView: View {
    var exercise: Exercise

    @Environment(\.dismiss) private var dismiss

    @State private var sheet: SheetKind?
    @State private var cueID: String
    @State private var cueMode: FormMode = .correct
    @Environment(WorkoutStore.self) private var store
    /// A short confirmation after adding to today, e.g. "Added to today · Chest".
    @State private var toast: String?
    /// The dashed "replaceable viewport" marker — a build-time aid, off
    /// for users and only offered in the menu of debug builds.
    @State private var showsGuides = false
    @State private var showsComparison = false
    @State private var setupExpanded = false
    /// Off shows the lift with nothing over it. Remembered across exercises,
    /// so someone who prefers the clean view doesn't have to ask every time.
    @AppStorage("trainer.showsKeyTips") private var showsKeyTips = true
    /// Screen points of the joints the cue callouts point at.
    @State private var tracker: JointTracker

    private enum SheetKind { case muscles, cue }

    init(exercise: Exercise) {
        self.exercise = exercise
        let content = SampleData.content(for: exercise)
        _cueID = State(initialValue: content?.cues.first?.id ?? "")
        _tracker = State(initialValue: JointTracker(
            joints: content?.annotations.compactMap(\.joint) ?? []
        ))
    }

    private var content: ExerciseContent? { SampleData.content(for: exercise) }
    private var showingMistake: Bool { sheet == .cue && cueMode == .mistake }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if let content {
                    viewport(content)
                        .padding(.bottom, SetupDrawer.peekHeight + 8)
                } else {
                    TrainerUnavailableView(exercise: exercise)
                }
            }

            if let content {
                SetupDrawer(steps: content.setup, isExpanded: $setupExpanded,
                            accessory: AnyView(addToTodayButton))
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }

            if showingMistake, let content {
                VStack {
                    MistakeBanner(text: "SHOWING COMMON MISTAKE · \(content.comparison.mistakeBadge)")
                        .padding(.top, 46)
                    Spacer()
                }
                .transition(.opacity)
                .allowsHitTesting(false)
            }

            if let content {
                sheetLayer(content)
            }

            if let toast {
                VStack {
                    HStack(spacing: 7) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13, weight: .semibold))
                        Text(toast)
                            .font(.ui(13, .semibold))
                    }
                    .foregroundStyle(DS.ink)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(Capsule().fill(DS.silver))
                    .padding(.top, 62)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .allowsHitTesting(false)
                .accessibilityElement(children: .combine)
            }
        }
        .animation(.easeOut(duration: 0.22), value: toast)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $showsComparison) {
            if let content {
                FormComparisonView(exercise: exercise, copy: content.comparison,
                                   glows: content.glows)
            }
        }
    }

    // MARK: - Actions

    private var addToTodayButton: some View {
        let inToday = store.isInToday(exercise.name)
        return Button(action: addToToday) {
            HStack(spacing: 5) {
                Image(systemName: inToday ? "checkmark" : "plus")
                    .font(.system(size: 10, weight: .bold))
                Text(inToday ? "In Today" : "Add to Today")
                    .font(.ui(12.5, .semibold))
            }
            .foregroundStyle(inToday ? DS.silver : DS.ink)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Capsule().fill(inToday ? DS.silver.opacity(0.08) : DS.silver))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(inToday ? "In today's workout" : "Add to today's workout")
    }

    private func addToToday() {
        let alreadyThere = store.isInToday(exercise.name)
        guard let group = store.addToToday(exerciseNamed: exercise.name) else { return }
        showToast(alreadyThere ? "Already in today's \(group.title) workout" : "Added to today · \(group.title)")
    }

    private func showToast(_ text: String) {
        toast = text
        Task {
            try? await Task.sleep(for: .seconds(2.2))
            if toast == text { toast = nil }
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
                Text(exercise.name)
                    .font(.ui(16, .semibold))
                    .tracking(-0.25)
                    .foregroundStyle(DS.silver)
                    .lineLimit(1)
                MetaLine(text: exercise.trainerMeta)
                    .padding(.top, 3)
            }

            Spacer(minLength: 0)

            let isSaved = store.isSaved(exercise.name)
            CircleIconButton(action: { store.toggleSaved(exercise.name) }) {
                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(DS.silver)
                    .contentTransition(.symbolEffect(.replace))
            }
            .sensoryFeedback(.selection, trigger: isSaved)
            .accessibilityLabel(isSaved ? "Remove from saved" : "Save exercise")

            if content != nil {
                Menu {
                    Button("Form Comparison") { showsComparison = true }
                    #if DEBUG
                    Toggle("Viewport Guides", isOn: $showsGuides)
                    #endif
                } label: {
                    ZStack {
                        Circle().fill(DS.silver.opacity(0.08))
                        MoreDotsIcon()
                    }
                    .frame(width: 34, height: 34)
                }
                .accessibilityLabel("More options")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 11)
        .padding(.bottom, 10)
    }

    // MARK: - Viewport

    private func viewport(_ content: ExerciseContent) -> some View {
        Viewport(
            slot: "ex3d-viewport",
            model: SampleData.modelName(for: exercise),
            framing: SampleData.model(for: exercise)?.framing ?? .standing,
            speed: SampleData.model(for: exercise)?.speed ?? 1,
            // The glow stands in for activation on a flat render. A live model
            // carries activation in its own materials, and a screen-space glow
            // would stay put while the lifter is turned out from under it.
            glows: SampleData.model(for: exercise) == nil ? content.glows : [],
            pulses: true,
            // The clean view drops the embed guides along with the tips.
            showsGuides: showsGuides && showsKeyTips,
            tracker: SampleData.model(for: exercise) == nil ? nil : tracker
        ) {
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    Color.clear

                    if showsKeyTips {
                        callouts(content, in: geo.size)
                            .transition(.opacity)
                    }

                    if showingMistake {
                        // On the fault itself when the cue tracks a joint.
                        let fault = content.annotations
                            .first { $0.cueID == cueID }
                            .flatMap { $0.joint }
                            .flatMap { tracker.points[$0] }
                        FaultRing(diameter: 100)
                            .position(fault ?? CGPoint(x: geo.size.width * 0.56,
                                                       y: geo.size.height * 0.44))
                            .allowsHitTesting(false)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }

            VStack(spacing: 8) {
                GlassSquareButton(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        sheet = sheet == .muscles ? nil : .muscles
                    }
                }) {
                    MuscleTargetIcon()
                }
                .accessibilityLabel("Muscles worked")

                GlassSquareButton(action: {
                    withAnimation(.easeOut(duration: 0.2)) { showsKeyTips.toggle() }
                }) {
                    Image(systemName: showsKeyTips ? "eye" : "eye.slash")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(DS.silver.opacity(showsKeyTips ? 1 : 0.55))
                        .contentTransition(.symbolEffect(.replace))
                }
                .accessibilityLabel("Key tips")
                .accessibilityValue(showsKeyTips ? "Shown" : "Hidden")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(12)

            legend(content)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(14)
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, DS.Metric.viewportInset)
    }

    /// The key tips: one tappable label per cue, its leader running to the
    /// joint it describes.
    private func callouts(_ content: ExerciseContent, in size: CGSize) -> some View {
        ForEach(content.annotations) { annotation in
            let label = CGPoint(
                x: annotation.labelPoint.x * size.width,
                y: annotation.labelPoint.y * size.height
            )
            TrackedCallout(
                text: annotation.label,
                labelPoint: label,
                labelSide: annotation.labelSide,
                dot: dotPoint(annotation, label: label),
                borderColor: isSelected(annotation.cueID)
                    ? DS.silver.opacity(0.5)
                    : DS.silver.opacity(0.16)
            ) {
                withAnimation(.easeOut(duration: 0.2)) {
                    cueID = annotation.cueID
                    cueMode = .correct
                    sheet = .cue
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Technique cue: \(annotation.label)")
        }
    }

    private func isSelected(_ id: String) -> Bool {
        cueID == id && sheet == .cue
    }

    /// The tracked joint's point on the live model; without one, level with
    /// the label, `leaderLength` out from it.
    private func dotPoint(_ annotation: CueAnnotation, label: CGPoint) -> CGPoint {
        if let joint = annotation.joint, let point = tracker.points[joint] {
            return point
        }
        let out = annotation.labelSide == .leading ? annotation.leaderLength : -annotation.leaderLength
        return CGPoint(x: label.x + out, y: label.y)
    }

    /// Derived from the activation data rather than hard-coded, so the legend
    /// always agrees with the muscle panel.
    private func legend(_ content: ExerciseContent) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            if !content.primaryMuscles.isEmpty {
                legendRow(
                    dot: DS.activation,
                    name: content.primaryMuscles.map { $0.name.uppercased() }
                        .joined(separator: " · "),
                    rank: "PRIMARY",
                    nameOpacity: 0.85,
                    rankOpacity: 0.45
                )
            }
            if !content.secondaryMuscles.isEmpty {
                legendRow(
                    dot: DS.activationSoft.opacity(0.5),
                    name: content.secondaryMuscles.map { $0.name.uppercased() }
                        .joined(separator: " · "),
                    rank: "SECONDARY",
                    nameOpacity: 0.55,
                    rankOpacity: 0.6
                )
            }
        }
        .allowsHitTesting(false)
    }

    private func legendRow(
        dot: Color, name: String, rank: String,
        nameOpacity: Double, rankOpacity: Double
    ) -> some View {
        HStack(spacing: 7) {
            Circle().fill(dot).frame(width: 8, height: 8)
            Text(name)
                .font(.mono(9.5, .medium))
                .trackingEm(0.07, size: 9.5)
                .foregroundStyle(DS.silver.opacity(nameOpacity))
                .lineLimit(1)
            Text(rank)
                .font(.mono(9.5, .medium))
                .trackingEm(0.07, size: 9.5)
                .foregroundStyle(DS.silver.opacity(nameOpacity * rankOpacity))
        }
    }

    // MARK: - Sheets

    @ViewBuilder
    private func sheetLayer(_ content: ExerciseContent) -> some View {
        if sheet != nil {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { closeSheet() }
                .transition(.opacity)
        }

        VStack {
            Spacer(minLength: 0)
            switch sheet {
            case .muscles:
                MusclePanelSheet(
                    exerciseName: exercise.name.uppercased(),
                    muscles: content.activation,
                    stabilisers: content.stabilisers,
                    onDone: closeSheet
                )
                .transition(.move(edge: .bottom))
            case .cue:
                CueSheet(
                    cue: content.cue(cueID),
                    number: content.cueNumber(cueID),
                    mode: cueMode,
                    onSelectMode: { mode in
                        withAnimation(.easeOut(duration: 0.2)) { cueMode = mode }
                    },
                    onDone: closeSheet
                )
                .transition(.move(edge: .bottom))
            case .none:
                EmptyView()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private func closeSheet() {
        withAnimation(.easeOut(duration: 0.2)) {
            sheet = nil
            cueMode = .correct
        }
    }
}
