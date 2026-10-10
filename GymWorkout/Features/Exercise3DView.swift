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
//  A free account gets the model, the setup and every key tip; the common
//  mistakes are Premium's, shown behind a lock that opens the paywall.
//
//  On iPad (regular width) nothing is laid over the model: the viewport keeps
//  the phone's stage and sits beside an inspector (wide) or above it
//  (regular) that holds the cues, the setup and the muscles worked. The same
//  `sheet` / `cueID` / `cueMode` drive both, so a window resized mid-use
//  turns a selected cue card into the cue sheet and back.
//

import SwiftUI

struct Exercise3DView: View {
    var exercise: Exercise
    /// Holds the clip at this many seconds in, for reviewing a moment of the
    /// rep (the fault review stills); nil plays it.
    var still: TimeInterval? = nil

    @Environment(\.dismiss) private var dismiss
    @Environment(Ads.self) private var ads
    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall

    @State private var sheet: SheetKind?
    @State private var cueID: String
    @State private var cueMode: FormMode = .correct
    @Environment(WorkoutStore.self) private var store
    /// A short confirmation after adding to today, e.g. "Added to today · Chest".
    @State private var toast: String?
    /// The dashed "replaceable viewport" marker — a build-time aid, off
    /// for users and only offered in the menu of debug builds.
    @State private var showsGuides = false
    @State private var setupExpanded = false
    /// Which stance the trainer shows, for exercises that come in several.
    @State private var stance = 0
    /// Off shows the lift with nothing over it. Remembered across exercises,
    /// so someone who prefers the clean view doesn't have to ask every time.
    @AppStorage("trainer.showsKeyTips") private var showsKeyTips = true
    /// Screen points of the joints the cue callouts point at.
    @State private var tracker: JointTracker

    @Environment(\.dsLayout) private var layout
    /// Which section the stacked iPad inspector shows.
    @State private var inspectorTab: InspectorTab = .cues
    /// The iPad viewport pane, for the stage the callouts are scaled to.
    @State private var paneSize: CGSize = .zero
    /// What the inspector brings to its top next. The request count lets the
    /// same target be asked for twice in a row.
    @State private var inspectorTarget: String?
    @State private var inspectorRequests = 0

    private enum SheetKind { case muscles, cue }
    private enum InspectorTab: Hashable { case cues, setup, muscles }

    /// `cue` and `showingMistake` open straight onto one cue's common mistake.
    init(exercise: Exercise, cue: String? = nil, showingMistake: Bool = false, still: TimeInterval? = nil) {
        self.exercise = exercise
        self.still = still
        let content = SampleData.content(for: exercise)
        _cueID = State(initialValue: cue ?? content?.cues.first?.id ?? "")
        if showingMistake {
            _sheet = State(initialValue: .cue)
            _cueMode = State(initialValue: .mistake)
        }
        // The cue dots, plus whatever the exercise's fault ghosts pose. A dot
        // on the leading or trailing (or bent or straight) leg needs both
        // legs, and the joints that decide which one it is.
        let cueJoints = (content?.annotations.compactMap(\.joint) ?? []).flatMap { joint -> [String] in
            guard let suffix = FaultPose.roleSuffixes.first(where: joint.hasSuffix) else { return [joint] }
            let stem = joint.dropLast(suffix.count)
            return ["\(stem)_L", "\(stem)_R", "thigh_L", "thigh_R", "shin_L", "shin_R", "foot_L", "foot_R"] + BodyFrameJoints.all
        }
        let joints = cueJoints + FaultPoses.joints(for: exercise.name)
        _tracker = State(initialValue: JointTracker(joints: Array(Set(joints)).sorted()))
    }

    private var content: ExerciseContent? {
        guard var content = SampleData.content(for: exercise) else { return nil }
        if let shown = currentStance?.activation { content.activation = shown }
        return content
    }
    private var stances: [SampleData.ExerciseStance] { SampleData.stances(for: exercise) }
    private var currentStance: SampleData.ExerciseStance? {
        stances.isEmpty ? nil : stances[min(stance, stances.count - 1)]
    }
    /// The model on stage: the picked stance's, or the exercise's own.
    private var liveModel: SampleData.ExerciseModel? {
        currentStance?.model ?? SampleData.model(for: exercise)
    }
    /// Never true without Premium, so no ghost, ring or bar slips through.
    private var showingMistake: Bool { sheet == .cue && cueMode == .mistake && purchases.isPremium }

    /// The selected cue's mistake as limbs to draw, when one is authored.
    private var fault: FaultPose? { FaultPoses.fault(exercise: exercise.name, cue: cueID) }

    var body: some View {
        Group {
            if layout.isRegular {
                regularBody
            } else {
                compactBody
            }
        }
        .animation(.easeOut(duration: 0.22), value: toast)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .onAppear {
            // Opened straight onto a mistake (`showingMistake: true`).
            if sheet == .cue && cueMode == .mistake && !purchases.isPremium {
                paywall.show(.mistake)
            }
            applyFreeLimits()
        }
        .onChange(of: purchases.isPremium) { applyFreeLimits() }
    }

    // MARK: - Compact

    private var compactBody: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if stances.count > 1 {
                    // Kept in the layout but hidden under a mistake, whose
                    // banner sits over it.
                    stancePicker
                        .padding(.horizontal, DS.Metric.viewportInset)
                        .padding(.bottom, 10)
                        .opacity(showingMistake ? 0 : 1)
                        .allowsHitTesting(!showingMistake)
                }

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
                    MistakeBanner(text: "COMMON MISTAKE · \(content.cue(cueID).title.uppercased())")
                        .padding(.top, 72)
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
                    toastLabel(toast)
                        .padding(.top, 62)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .allowsHitTesting(false)
                .accessibilityElement(children: .combine)
            }
        }
        // ⌘[ and Esc on an iPad window narrow enough for this layout; with a
        // panel up, Esc is its Done instead.
        .background {
            if DS.isPad && sheet == nil {
                Color.clear.dsBackShortcuts(back)
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

    private func toastLabel(_ text: String) -> some View {
        HStack(spacing: 7) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 13, weight: .semibold))
            Text(text)
                .font(.ui(13, .semibold))
        }
        .foregroundStyle(DS.ink)
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(Capsule().fill(DS.silver))
    }

    private func back() {
        dismiss()
        ads.moment(.exerciseClosed)
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

            let isSaved = store.isSaved(exercise.name)
            CircleIconButton(action: { store.toggleSaved(exercise.name) }) {
                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(DS.silver)
                    .contentTransition(.symbolEffect(.replace))
            }
            .sensoryFeedback(.selection, trigger: isSaved)
            .accessibilityLabel(isSaved ? "Remove from saved" : "Save exercise")

            // Its only item is a build-time aid, so release builds have no menu.
            #if DEBUG
            if content != nil {
                Menu {
                    Toggle("Viewport Guides", isOn: $showsGuides)
                } label: {
                    ZStack {
                        Circle().fill(DS.silver.opacity(0.08))
                        MoreDotsIcon()
                    }
                    .frame(width: 34, height: 34)
                }
                .accessibilityLabel("More options")
            }
            #endif
        }
        .padding(.horizontal, 16)
        .padding(.top, 11)
        .padding(.bottom, 10)
    }

    // MARK: - Viewport

    private func viewport(_ content: ExerciseContent) -> some View {
        Viewport(
            slot: "ex3d-viewport",
            model: liveModel?.resource,
            framing: liveModel?.framing ?? .standing,
            speed: liveModel?.speed ?? 1,
            still: still,
            // A mistake is turned to the side it shows best from.
            turn: showingMistake ? (fault?.view ?? 0) : 0,
            // Clear of the mistake bar, which covers the feet otherwise.
            roomBelow: showingMistake ? 0.26 : 0,
            // The glow stands in for activation on a flat render. A live model
            // carries activation in its own materials, and a screen-space glow
            // would stay put while the lifter is turned out from under it.
            glows: liveModel == nil ? content.glows : [],
            pulses: true,
            // The clean view drops the embed guides along with the tips.
            showsGuides: showsGuides && showsKeyTips,
            tracker: liveModel == nil ? nil : tracker
        ) {
            annotationLayer(content)

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
                .padding(8)
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, DS.Metric.viewportInset)
    }

    /// The stances an exercise comes in, over the viewport, with a line on
    /// the one picked.
    private var stancePicker: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Five segments share the width: a smaller face and tighter
            // padding keep STANDARD on one line.
            MonoSegmentedControl(
                options: stances.indices.map { (value: $0, title: stances[$0].label.uppercased()) },
                selection: $stance,
                fontSize: 8.5,
                em: 0.04,
                itemPaddingH: 4,
                fillsWidth: true
            )
            .accessibilityLabel("Stance")
            if let note = currentStance?.note {
                Text(note)
                    .font(.ui(12, .regular))
                    .foregroundStyle(DS.silver.opacity(0.62))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 2)
            }
        }
    }

    /// The key tips and the mistake, in the viewport's (or the iPad stage's)
    /// own coordinates — the space the label points and tracked joints are in.
    private func annotationLayer(_ content: ExerciseContent) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color.clear

                if showsKeyTips {
                    callouts(content, in: geo.size)
                        .transition(.opacity)
                }

                if showingMistake {
                    if let fault {
                        // The mistake drawn over the lifter as yellow limbs.
                        FaultGhost(fault: fault, tracker: tracker)
                            .transition(.opacity)
                    } else {
                        // On the fault itself when the cue tracks a joint.
                        let spot = content.annotations
                            .first { $0.cueID == cueID }
                            .flatMap { $0.joint }
                            .flatMap(trackedPoint)
                        FaultRing(diameter: 100)
                            .position(spot ?? CGPoint(x: geo.size.width * 0.56,
                                                      y: geo.size.height * 0.44))
                            .allowsHitTesting(false)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    /// The key tips: one tappable label per cue, its leader running to the
    /// joint it describes.
    private func callouts(_ content: ExerciseContent, in size: CGSize) -> some View {
        // While a mistake is shown, only its own cue stays labelled.
        ForEach(content.annotations.filter { !showingMistake || $0.cueID == cueID }) { annotation in
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
                // On iPad the cue opens as its card in the inspector.
                if layout.isRegular { revealCue(annotation.cueID) }
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
        if let joint = annotation.joint, let point = trackedPoint(joint) {
            return point
        }
        let out = annotation.labelSide == .leading ? annotation.leaderLength : -annotation.leaderLength
        return CGPoint(x: label.x + out, y: label.y)
    }

    /// A joint's point on the live model. `_front` and `_back` name the
    /// leading and trailing leg of a lift that alternates legs, `_bent` and
    /// `_straight` the working and straight leg of one that shifts from side
    /// to side, decided afresh every frame like the fault ghosts do.
    private func trackedPoint(_ joint: String) -> CGPoint? {
        // (suffix, names the side itself, decided by the leading foot rather
        // than the bent knee)
        let roles = [
            ("_front", true, true), ("_back", false, true),
            ("_bent", true, false), ("_straight", false, false),
        ]
        for (suffix, isSide, byLead) in roles where joint.hasSuffix(suffix) {
            let decided = byLead ? BodyFrame.leadingSide(tracker.transforms) : BodyFrame.bentSide(tracker.transforms)
            guard let side = decided else { return nil }
            let resolved = isSide ? side : (side == "L" ? "R" : "L")
            return tracker.points[String(joint.dropLast(suffix.count)) + "_" + resolved]
        }
        return tracker.points[joint]
    }

    /// Derived from the activation data rather than hard-coded, so the legend
    /// always agrees with the muscle panel.
    /// `size` is the mono point size: 9.5 on the phone, 10.5 on an iPad pane.
    private func legend(_ content: ExerciseContent, size: CGFloat = 9.5) -> some View {
        VStack(alignment: .leading, spacing: size == 9.5 ? 7 : 8) {
            if !content.primaryMuscles.isEmpty {
                legendRow(
                    dot: DS.activation,
                    name: content.primaryMuscles.map { $0.name.uppercased() }
                        .joined(separator: " · "),
                    rank: "PRIMARY",
                    nameOpacity: 0.85,
                    rankOpacity: 0.45,
                    size: size
                )
            }
            if !content.secondaryMuscles.isEmpty {
                legendRow(
                    dot: DS.activationSoft.opacity(0.5),
                    name: content.secondaryMuscles.map { $0.name.uppercased() }
                        .joined(separator: " · "),
                    rank: "SECONDARY",
                    nameOpacity: 0.55,
                    rankOpacity: 0.6,
                    size: size
                )
            }
        }
        // A glass backing, as on the viewport's buttons, so the legend reads
        // where it sits over dark equipment (a machine's base, a rack).
        .padding(.horizontal, 9)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(DS.glass(0.72))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(DS.silver.opacity(0.10), lineWidth: 1)
                )
        )
        .allowsHitTesting(false)
    }

    private func legendRow(
        dot: Color, name: String, rank: String,
        nameOpacity: Double, rankOpacity: Double,
        size: CGFloat
    ) -> some View {
        HStack(spacing: 7) {
            Circle().fill(dot).frame(width: size == 9.5 ? 8 : 9, height: size == 9.5 ? 8 : 9)
            Text(name)
                .font(.mono(size, .medium))
                .trackingEm(0.07, size: size)
                .foregroundStyle(DS.silver.opacity(nameOpacity))
                .lineLimit(1)
            Text(rank)
                .font(.mono(size, .medium))
                .trackingEm(0.07, size: size)
                .foregroundStyle(DS.silver.opacity(nameOpacity * rankOpacity))
        }
    }

    // MARK: - Sheets

    @ViewBuilder
    private func sheetLayer(_ content: ExerciseContent) -> some View {
        // A mistake needs the whole lifter in view, so it gets no scrim.
        if sheet != nil && !showingMistake {
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
            case .cue where showingMistake:
                MistakeBar(
                    cue: content.cue(cueID),
                    drawsGhost: fault != nil,
                    onShowCorrect: {
                        withAnimation(.easeOut(duration: 0.2)) { cueMode = .correct }
                    },
                    onDone: closeSheet
                )
                .transition(.move(edge: .bottom))
            case .cue:
                CueSheet(
                    cue: content.cue(cueID),
                    number: content.cueNumber(cueID),
                    mode: cueMode,
                    mistakeLocked: !purchases.isPremium,
                    onSelectMode: selectMode,
                    onDone: closeSheet
                )
                .transition(.move(edge: .bottom))
            case .none:
                EmptyView()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    /// A common mistake is Premium's: without it the paywall opens and the
    /// sheet stays on the correct form.
    private func selectMode(_ mode: FormMode) {
        guard mode == .correct || purchases.isPremium else {
            paywall.show(.mistake)
            return
        }
        withAnimation(.easeOut(duration: 0.2)) { cueMode = mode }
    }

    /// Back to what a free account sees: every key tip, but in its correct
    /// form. For a screen that opens on a mistake, or Premium lapsing with
    /// one open.
    private func applyFreeLimits() {
        guard !purchases.isPremium else { return }
        if sheet == .cue { cueMode = .correct }
    }

    private func closeSheet() {
        withAnimation(.easeOut(duration: 0.2)) {
            sheet = nil
            cueMode = .correct
        }
    }

    // MARK: - Regular (iPad)

    /// The viewport and the inspector share one `AnyLayout`, side by side
    /// when wide and stacked when not, so the viewport keeps its place in the
    /// tree and the live model never reloads when the window is resized
    /// across the two.
    private var regularBody: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                regularHeader

                if stances.count > 1 {
                    stancePicker
                        .frame(maxWidth: 560)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                }

                if let content {
                    let shell = layout.isWide
                        ? AnyLayout(HStackLayout(alignment: .top, spacing: 16))
                        : AnyLayout(VStackLayout(spacing: 14))
                    shell {
                        regularViewport(content)
                            .frame(maxWidth: .infinity, maxHeight: layout.isWide ? .infinity : nil)
                            .frame(height: layout.isWide ? nil : stackedViewportHeight)

                        inspector(content)
                            .frame(width: layout.isWide ? inspectorWidth : nil)
                            .frame(maxWidth: layout.isWide ? nil : .infinity, maxHeight: .infinity)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                } else {
                    TrainerUnavailableView(exercise: exercise)
                }
            }
        }
        .background { regularShortcuts }
    }

    private var inspectorWidth: CGFloat {
        layout.paneWidth(0.34, min: DS.Layout.inspectorMin, max: DS.Layout.inspectorMax)
    }

    /// 56% of the window, kept between 440 and 680 — eased below 440 on a
    /// short Stage Manager window, so the inspector still gets some room.
    private var stackedViewportHeight: CGFloat {
        let h = layout.containerHeight
        return max(min(0.56 * h, 680), min(440, 0.5 * h))
    }

    /// The phone-shaped stage `Viewport` centres in the pane.
    private var stageSize: CGSize {
        let aspect = DS.Metric.designStageAspect
        guard paneSize.width > 0, paneSize.height > 0 else { return paneSize }
        return paneSize.width / paneSize.height > aspect
            ? CGSize(width: paneSize.height * aspect, height: paneSize.height)
            : CGSize(width: paneSize.width, height: paneSize.width / aspect)
    }

    /// The callouts, ghost and fault ring grow with the stage — up to half
    /// as large again — so they keep their proportion to the lifter.
    private var annotationScale: CGFloat {
        guard stageSize.height > 0 else { return 1 }
        return min(max(stageSize.height / 567, 1), 1.5)
    }

    /// The phone's studio pool (`Viewport`'s 1.2 × 0.72 at 0.5 / 0.8)
    /// measured on the stage instead of the pane, so in a pane much taller
    /// than the stage the floor's glow still sits under the lifter's feet
    /// rather than below them.
    private var ground: (rx: CGFloat, ry: CGFloat, cy: CGFloat) {
        let stage = stageSize
        guard paneSize.width > 0, paneSize.height > 0 else { return (1.20, 0.72, 0.80) }
        let top = (paneSize.height - stage.height) / 2
        return (1.20 * stage.width / paneSize.width,
                0.72 * stage.height / paneSize.height,
                (top + 0.80 * stage.height) / paneSize.height)
    }

    // MARK: Header

    private var regularHeader: some View {
        HStack(spacing: 12) {
            CircleIconButton(action: back) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel("Back")

            VStack(alignment: .leading, spacing: 0) {
                Text(exercise.name)
                    .font(.ui(layout.text(.screenTitle), .semibold))
                    .tracking(-0.35)
                    .foregroundStyle(DS.silver)
                    .lineLimit(1)
                MetaLine(text: exercise.trainerMeta)
                    .lineLimit(1)
                    .padding(.top, 4)
            }

            Spacer(minLength: 12)

            let isSaved = store.isSaved(exercise.name)
            CircleIconButton(action: { store.toggleSaved(exercise.name) }) {
                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(DS.silver)
                    .contentTransition(.symbolEffect(.replace))
            }
            .sensoryFeedback(.selection, trigger: isSaved)
            .accessibilityLabel(isSaved ? "Remove from saved" : "Save exercise")

            if content != nil {
                regularAddToTodayButton
            }

            #if DEBUG
            if content != nil {
                Menu {
                    Toggle("Viewport Guides", isOn: $showsGuides)
                } label: {
                    ZStack {
                        Circle().fill(DS.silver.opacity(0.08))
                        MoreDotsIcon()
                    }
                    .frame(width: 40, height: 40)
                }
                .dsHover(.highlight)
                .accessibilityLabel("More options")
            }
            #endif
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 16)
    }

    /// "Add to Today" from the phone's setup bar, which iPad doesn't have:
    /// a capsule the height of the header's circles.
    private var regularAddToTodayButton: some View {
        let inToday = store.isInToday(exercise.name)
        return Button(action: addToToday) {
            HStack(spacing: 6) {
                Image(systemName: inToday ? "checkmark" : "plus")
                    .font(.system(size: 11, weight: .bold))
                Text(inToday ? "In Today" : "Add to Today")
                    .font(.ui(14, .semibold))
            }
            .foregroundStyle(inToday ? DS.silver : DS.ink)
            .padding(.horizontal, 16)
            .frame(height: 40)
            .background(Capsule().fill(inToday ? DS.silver.opacity(0.08) : DS.silver))
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight)
        .accessibilityLabel(inToday ? "In today's workout" : "Add to today's workout")
    }

    // MARK: Viewport

    /// The phone's 382×567 stage, centred in the pane, so the authored
    /// framing and label points land as they do on the phone. Buttons, the
    /// legend and the banners hold the pane's corners instead.
    private func regularViewport(_ content: ExerciseContent) -> some View {
        let model = liveModel
        let ground = self.ground
        return Viewport(
            slot: "ex3d-viewport",
            model: model?.resource,
            framing: model?.framing ?? .standing,
            speed: model?.speed ?? 1,
            still: still,
            turn: showingMistake ? (fault?.view ?? 0) : 0,
            // Nothing covers the pane on iPad, so the model never makes room.
            roomBelow: 0,
            rx: ground.rx,
            ry: ground.ry,
            cy: ground.cy,
            glows: model == nil ? content.glows : [],
            pulses: true,
            showsGuides: showsGuides && showsKeyTips,
            tracker: model == nil ? nil : tracker,
            cornerRadius: DS.Metric.viewportRadiusRegular,
            stageAspect: DS.Metric.designStageAspect,
            dragReferenceWidth: 560
        ) {
            annotationLayer(content)
        } chrome: {
            paneChrome(content)
        }
        .environment(\.dsAnnotationScale, annotationScale)
        .onGeometryChange(for: CGSize.self) { $0.size } action: { paneSize = $0 }
    }

    @ViewBuilder
    private func paneChrome(_ content: ExerciseContent) -> some View {
        VStack(spacing: 10) {
            // The muscles are always in the inspector; this brings them up.
            GlassSquareButton(side: 40, action: { reveal(.muscles, id: InspectorID.muscles) }) {
                MuscleTargetIcon(size: 15)
            }
            .accessibilityLabel("Muscles worked")

            GlassSquareButton(side: 40, action: {
                withAnimation(.easeOut(duration: 0.2)) { showsKeyTips.toggle() }
            }) {
                Image(systemName: showsKeyTips ? "eye" : "eye.slash")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(DS.silver.opacity(showsKeyTips ? 1 : 0.55))
                    .contentTransition(.symbolEffect(.replace))
            }
            .accessibilityLabel("Key tips")
            .accessibilityValue(showsKeyTips ? "Shown" : "Hidden")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(16)

        legend(content, size: 10.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(14)

        // Centred on the pane, clear of the button column on the right.
        VStack(spacing: 8) {
            if showingMistake {
                MistakeBanner(text: "COMMON MISTAKE · \(content.cue(cueID).title.uppercased())")
                    .transition(.opacity)
            }
            if let toast {
                toastLabel(toast)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .accessibilityElement(children: .combine)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 16)
        .padding(.horizontal, 72)
        .allowsHitTesting(false)
    }

    // MARK: Inspector

    private enum InspectorID {
        static let cues = "inspector.cues"
        static let setup = "inspector.setup"
        static let muscles = "inspector.muscles"
        static func cue(_ id: String) -> String { "inspector.cue.\(id)" }
    }

    /// Cues, setup and muscles on one pane: one scroll when wide, one section
    /// at a time behind a segmented control when stacked under the viewport.
    private func inspector(_ content: ExerciseContent) -> some View {
        VStack(spacing: 0) {
            if !layout.isWide {
                MonoSegmentedControl(
                    options: [(InspectorTab.cues, "CUES"), (.setup, "SETUP"), (.muscles, "MUSCLES")],
                    selection: $inspectorTab.animation(.easeOut(duration: 0.18)),
                    fontSize: 10,
                    itemPaddingV: 8,
                    fillsWidth: true
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }

            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: layout.sectionSpacing) {
                        if layout.isWide || inspectorTab == .cues {
                            cuesSection(content)
                                .id(InspectorID.cues)
                        }
                        if layout.isWide || inspectorTab == .setup {
                            setupSection(content)
                                .id(InspectorID.setup)
                        }
                        if layout.isWide || inspectorTab == .muscles {
                            MuscleActivationContent(muscles: content.activation,
                                                    stabilisers: content.stabilisers,
                                                    inline: true)
                                .id(InspectorID.muscles)
                        }
                    }
                    .padding(20)
                    .dsReadable(720)
                }
                .onChange(of: inspectorRequests) {
                    guard let target = inspectorTarget else { return }
                    // After the update that may have switched the segment,
                    // so the target is laid out before it is scrolled to.
                    DispatchQueue.main.async {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(target, anchor: .top)
                        }
                    }
                }
                .onAppear {
                    // Grown from compact with a panel up: show what it showed.
                    switch sheet {
                    case .cue: revealCue(cueID)
                    case .muscles: reveal(.muscles, id: InspectorID.muscles)
                    case .none: break
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: DS.Layout.paneRadius, style: .continuous))
        .dsPane(radius: DS.Layout.paneRadius)
    }

    private func cuesSection(_ content: ExerciseContent) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: "TECHNIQUE CUES · \(content.cues.count)")

            VStack(spacing: 10) {
                ForEach(Array(content.cues.enumerated()), id: \.element.id) { index, cue in
                    cueCard(cue, number: index + 1)
                        .id(InspectorID.cue(cue.id))
                }
            }
            .padding(.top, 12)
        }
    }

    /// A cue folded to its title and intro, or — selected — opened in place
    /// to the whole cue: the inline form of the cue sheet. A tap on a callout
    /// selects it here too.
    private func cueCard(_ cue: TechniqueCue, number: Int) -> some View {
        let isOpen = isSelected(cue.id)
        let card = RoundedRectangle(cornerRadius: 16, style: .continuous)
        return Group {
            if isOpen {
                CueDetailContent(
                    cue: cue,
                    number: number,
                    mode: cueMode,
                    mistakeLocked: !purchases.isPremium,
                    showsMistake: showingMistake,
                    drawsGhost: fault != nil,
                    onSelectMode: selectMode,
                    onClose: closeSheet
                )
                .padding(16)
                .dsSelected(true, radius: 16)
            } else {
                Button {
                    selectCue(cue.id)
                } label: {
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text(String(format: "%02d", number))
                            .font(.mono(10.5, .semibold))
                            .trackingEm(0.06, size: 10.5)
                            .foregroundStyle(DS.silver.opacity(0.4))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(cue.title)
                                .font(.ui(15, .semibold))
                                .tracking(-0.15)
                                .foregroundStyle(DS.silver)
                                .multilineTextAlignment(.leading)
                            Text(cue.intro)
                                .font(.ui(13.5))
                                .cssLineHeight(13.5, 1.4)
                                .foregroundStyle(DS.silver.opacity(0.6))
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                        }
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(DS.silver.opacity(0.3))
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(card)
                }
                .buttonStyle(.plain)
                .dsHover(.highlight, radius: 16)
                .accessibilityLabel("Technique cue \(number): \(cue.title)")
                .accessibilityHint(cue.intro)
            }
        }
        .background(card.fill(DS.surfaceDim).overlay(card.fill(Self.cardWash)))
        .overlay(card.strokeBorder(DS.silver.opacity(0.06), lineWidth: 1))
    }

    /// Over `surfaceDim`, so a card still reads on the inspector's `surface`
    /// in Dark Mode, where the two are a shade apart.
    static let cardWash = DS.silver.opacity(0.03)

    private func setupSection(_ content: ExerciseContent) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: content.setup.count == 1 ? "SETUP · 1 STEP" : "SETUP · \(content.setup.count) STEPS")
            SetupStepList(steps: content.setup)
                .padding(.top, 14)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Selection & keyboard

    private func selectCue(_ id: String) {
        withAnimation(.easeOut(duration: 0.2)) {
            cueID = id
            cueMode = .correct
            sheet = .cue
        }
        revealCue(id)
    }

    private func revealCue(_ id: String) {
        reveal(.cues, id: InspectorID.cue(id))
    }

    /// Brings part of the inspector into view: switches the stacked layout's
    /// segment to it, then scrolls it to the top.
    private func reveal(_ tab: InspectorTab, id: String) {
        if !layout.isWide && inspectorTab != tab {
            withAnimation(.easeOut(duration: 0.18)) { inspectorTab = tab }
        }
        inspectorTarget = id
        inspectorRequests += 1
    }

    /// ←/→ step through the cues (from the first or last when none is open).
    private func stepCue(_ delta: Int, in content: ExerciseContent) {
        guard !content.cues.isEmpty else { return }
        let last = content.cues.count - 1
        let current = sheet == .cue ? content.cues.firstIndex { $0.id == cueID } : nil
        let next = current.map { min(max($0 + delta, 0), last) } ?? (delta > 0 ? 0 : last)
        guard next != current else { return }
        selectCue(content.cues[next].id)
    }

    /// ⌘[ goes back. Esc closes the open cue first, then goes back.
    @ViewBuilder
    private var regularShortcuts: some View {
        if DS.isPad {
            if sheet == nil {
                Color.clear.dsBackShortcuts(back)
            } else {
                ZStack {
                    Button("Back", action: back)
                        .keyboardShortcut("[", modifiers: .command)
                    Button("Close Cue", action: closeSheet)
                        .keyboardShortcut(.cancelAction)
                }
                .hiddenShortcuts()
            }

            if let content {
                ZStack {
                    Button("Previous Cue") { stepCue(-1, in: content) }
                        .keyboardShortcut(.leftArrow, modifiers: [])
                    Button("Next Cue") { stepCue(1, in: content) }
                        .keyboardShortcut(.rightArrow, modifiers: [])
                }
                .hiddenShortcuts()
            }
        }
    }
}

private extension View {
    /// Live but unseen: keyboard shortcuts with no button on screen.
    func hiddenShortcuts() -> some View {
        frame(width: 0, height: 0)
            .opacity(0)
            .accessibilityHidden(true)
            .allowsHitTesting(false)
    }
}
