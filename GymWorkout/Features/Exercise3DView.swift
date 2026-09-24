//
//  Exercise3DView.swift
//  GymWorkout
//
//  Screen 1c — the primary Exercise 3D View, plus the two states the design
//  models on top of it: the muscle activation panel (1d) and the technique-cue
//  sheet with its "common mistake" overlay (1e).
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
    @State private var favourite = false
    @State private var showsGuides = true
    @State private var showsComparison = false
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
                        .padding(.bottom, 18)
                } else {
                    TrainerUnavailableView(exercise: exercise)
                }
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
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $showsComparison) {
            if let content {
                FormComparisonView(exercise: exercise, copy: content.comparison,
                                   glows: content.glows)
            }
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

            CircleIconButton(action: { favourite.toggle() }) {
                Image(systemName: favourite ? "heart.fill" : "heart")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel(favourite ? "Remove from saved" : "Save exercise")

            if content != nil {
                Menu {
                    Button("Form Comparison") { showsComparison = true }
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
            showsGuides: showsGuides,
            tracker: SampleData.model(for: exercise) == nil ? nil : tracker
        ) {
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    Color.clear

                    ForEach(content.annotations) { annotation in
                        let label = CGPoint(
                            x: annotation.labelPoint.x * geo.size.width,
                            y: annotation.labelPoint.y * geo.size.height
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

            GlassSquareButton(action: {
                withAnimation(.easeOut(duration: 0.2)) {
                    sheet = sheet == .muscles ? nil : .muscles
                }
            }) {
                MuscleTargetIcon()
            }
            .accessibilityLabel("Muscles worked")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(12)

            legend(content)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(14)
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, DS.Metric.viewportInset)
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
