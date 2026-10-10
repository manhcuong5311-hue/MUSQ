//
//  TrainerUnavailableView.swift
//  GymWorkout
//
//  The gate. Shown in place of the 3D trainer for an exercise that has no
//  authored `ExerciseContent`.
//
//  The alternative — reusing another lift's cues, muscle activation and steps
//  under this exercise's name — would present wrong coaching as fact, so the
//  screen says plainly that the breakdown does not exist yet.
//
//  NOTE: not in the design doc, which only ever specified Barbell Bench Press.
//  Kept to the system's own vocabulary (marked embed region, mono eyebrow,
//  silver as the only accent) so it reads as part of the set.
//
//  On iPad (regular width) it takes the trainer's own shape — the viewport
//  pane beside, or above, an inspector-style column — so opening a gated
//  exercise doesn't change the screen's geometry under the user.
//

import SwiftUI

struct TrainerUnavailableView: View {
    var exercise: Exercise

    @Environment(\.dsLayout) private var layout
    /// The iPad viewport pane, for the stage its ground is measured on.
    @State private var paneSize: CGSize = .zero

    private var trainable: [Exercise] { SampleData.trainableExercises }

    private var model: String? { SampleData.modelName(for: exercise) }

    private var caption: some View {
        VStack(spacing: 10) {
            SectionEyebrow(text: model == nil
                           ? "NO 3D BREAKDOWN YET"
                           : "MODEL ONLY · NO COACHING YET",
                           size: 9.5, em: 0.12)

            Text(model == nil
                 ? "\(exercise.name) doesn't have its cues, muscle activation or step-by-step authored."
                 : "The \(exercise.name.lowercased()) model is loaded and playing. Its cues, muscle activation and step-by-step aren't authored yet.")
                .font(.ui(13.5))
                .cssLineHeight(13.5, 1.5)
                .multilineTextAlignment(.center)
                .foregroundStyle(DS.silver.opacity(0.5))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 300)
        }
        .frame(maxWidth: .infinity)
        .allowsHitTesting(false)
    }

    var body: some View {
        if layout.isRegular {
            regularBody
        } else {
            compactBody
        }
    }

    // NOTE: the list below is every trainable exercise in a plain VStack,
    // with no ScrollView, so on a phone it runs off the bottom and squeezes
    // the viewport. Left as it is so the phone layout doesn't move; the iPad
    // layout below scrolls and lists a dozen.
    private var compactBody: some View {
        VStack(spacing: 0) {
            ZStack {
                ViewportGround(
                    inner: DS.viewportInner, outer: DS.viewportOuter,
                    rx: 1.10, ry: 0.70, cx: 0.5, cy: 0.5
                )

                // A model can ship before its coaching does. Show it — the gate
                // withholds cues and activation numbers, not the anatomy.
                if let model = SampleData.model(for: exercise) {
                    USDZViewport(resource: model.resource, framing: model.framing,
                                 speed: model.speed)
                }

                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        DS.silver.opacity(0.13),
                        style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                    )
                    .padding(10)
                    .allowsHitTesting(false)

                if model == nil {
                    caption.padding(28)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: DS.Metric.viewportRadius,
                                        style: .continuous))
            .frame(maxHeight: .infinity)
            .padding(.horizontal, DS.Metric.viewportInset)

            // With a model loaded the figure fills the frame, so the note sits
            // under the viewport rather than over the lifter's legs.
            if model != nil {
                caption
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 16)
            }

            if let first = trainable.first {
                VStack(spacing: 0) {
                    SectionEyebrow(text: "AVAILABLE NOW", size: 9, em: 0.11)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(trainable) { item in
                        NavigationLink(value: item) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(item.name)
                                        .font(.ui(15, .semibold))
                                        .foregroundStyle(DS.silver)
                                    MetaLine(text: item.meta, em: 0.06)
                                        .padding(.top, 4)
                                }
                                Spacer(minLength: 8)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(DS.silver.opacity(0.3))
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 13)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(DS.surface)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 10)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 20)
                .accessibilityHint("Opens an exercise that has a full 3D breakdown")
                .id(first.id)
            }
        }
        .padding(.bottom, 30)
    }

    // MARK: - Regular (iPad)

    /// The trainer's shell: side by side when wide, stacked when not, in an
    /// `AnyLayout` so the live model survives a resize across the two.
    private var regularBody: some View {
        let shell = layout.isWide
            ? AnyLayout(HStackLayout(alignment: .top, spacing: 16))
            : AnyLayout(VStackLayout(spacing: 14))
        return shell {
            stagePane
                .frame(maxWidth: .infinity, maxHeight: layout.isWide ? .infinity : nil)
                .frame(height: layout.isWide ? nil : stackedViewportHeight)

            sideColumn
                .frame(width: layout.isWide ? inspectorWidth : nil)
                .frame(maxWidth: layout.isWide ? nil : .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    private var inspectorWidth: CGFloat {
        layout.paneWidth(0.34, min: DS.Layout.inspectorMin, max: DS.Layout.inspectorMax)
    }

    /// 56% of the window, kept between 440 and 680 — eased below 440 on a
    /// short Stage Manager window, so the list still gets some room.
    private var stackedViewportHeight: CGFloat {
        let h = layout.containerHeight
        return max(min(0.56 * h, 680), min(440, 0.5 * h))
    }

    /// The model, when there is one, on the phone-shaped stage its framing
    /// was authored for, with the embed region marked around that stage
    /// rather than around the whole pane.
    private var stagePane: some View {
        let live = SampleData.model(for: exercise)
        let stage = stageSize
        // The phone's pool (1.10 × 0.70, centred) measured on the stage, as
        // the trainer does, so a tall pane doesn't stretch it into a band.
        let rx = paneSize.width > 0 ? 1.10 * stage.width / paneSize.width : 1.10
        let ry = paneSize.height > 0 ? 0.70 * stage.height / paneSize.height : 0.70
        return Viewport(
            slot: "trainer-unavailable",
            model: live?.resource,
            framing: live?.framing ?? .standing,
            speed: live?.speed ?? 1,
            rx: rx, ry: ry, cx: 0.5, cy: 0.5,
            cornerRadius: DS.Metric.viewportRadiusRegular,
            stageAspect: DS.Metric.designStageAspect,
            dragReferenceWidth: 560
        ) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        DS.silver.opacity(0.13),
                        style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                    )
                    .padding(10)

                if live == nil {
                    VStack(spacing: 12) {
                        Image(systemName: "cube.transparent")
                            .font(.system(size: 28, weight: .light))
                            .foregroundStyle(DS.silver.opacity(0.28))
                        Text("NO MODEL YET")
                            .font(.mono(9.5, .semibold))
                            .trackingEm(0.12, size: 9.5)
                            .foregroundStyle(DS.silver.opacity(0.35))
                    }
                    .accessibilityHidden(true)
                }
            }
            .allowsHitTesting(false)
        }
        .onGeometryChange(for: CGSize.self) { $0.size } action: { paneSize = $0 }
    }

    /// The phone-shaped stage `Viewport` centres in the pane.
    private var stageSize: CGSize {
        let aspect = DS.Metric.designStageAspect
        guard paneSize.width > 0, paneSize.height > 0 else { return paneSize }
        return paneSize.width / paneSize.height > aspect
            ? CGSize(width: paneSize.height * aspect, height: paneSize.height)
            : CGSize(width: paneSize.width, height: paneSize.width / aspect)
    }

    /// What's missing, then a short way out: a dozen exercises that do have
    /// a breakdown, this one's own group first.
    private var sideColumn: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    SectionEyebrow(text: model == nil
                                   ? "NO 3D BREAKDOWN YET"
                                   : "MODEL ONLY · NO COACHING YET",
                                   size: 10, em: 0.12)
                    Text(model == nil
                         ? "\(exercise.name) doesn't have its cues, muscle activation or step-by-step authored."
                         : "The \(exercise.name.lowercased()) model is loaded and playing. Its cues, muscle activation and step-by-step aren't authored yet.")
                        .font(.ui(15))
                        .cssLineHeight(15, 1.5)
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }

                if !suggestions.isEmpty {
                    SectionEyebrow(text: "AVAILABLE NOW")
                        .padding(.top, 32)

                    // Two across in the stacked layout, so a card never
                    // stretches its chevron away from its name.
                    LazyVGrid(columns: DS.flexibleColumns(layout.isWide ? 1 : 2, spacing: 10),
                              spacing: 10) {
                        ForEach(suggestions) { item in
                            suggestionCard(item)
                        }
                    }
                    .padding(.top, 12)
                    .accessibilityHint("Opens an exercise that has a full 3D breakdown")
                }
            }
            .padding(20)
            .dsReadable(720)
        }
        .clipShape(RoundedRectangle(cornerRadius: DS.Layout.paneRadius, style: .continuous))
        .dsPane()
    }

    private var suggestions: [Exercise] {
        let others = trainable.filter { $0.name != exercise.name }
        let sameGroup = others.filter { $0.category == exercise.category }
        let rest = others.filter { $0.category != exercise.category }
        return Array((sameGroup + rest).prefix(12))
    }

    private func suggestionCard(_ item: Exercise) -> some View {
        NavigationLink(value: item) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(item.name)
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                        .lineLimit(1)
                    MetaLine(text: item.meta, em: 0.06)
                        .lineLimit(1)
                        .padding(.top, 4)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.3))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(DS.surfaceDim)
                    // A shade lifted, to read on the pane in Dark Mode too.
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(DS.silver.opacity(0.03)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.06), lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: 16)
    }
}
