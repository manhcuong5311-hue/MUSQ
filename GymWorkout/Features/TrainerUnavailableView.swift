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

import SwiftUI

struct TrainerUnavailableView: View {
    var exercise: Exercise

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
}
