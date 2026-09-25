//
//  Sheets.swift
//  GymWorkout
//
//  The two bottom panels the 3D view raises:
//   • `MusclePanelSheet` — screen 1d, Muscle Activation.
//   • `CueSheet`         — screen 1e, a tapped technique cue.
//
//  Both are drawn in-canvas rather than as system sheets: the design specifies
//  its own 26pt shoulder, hairline and grabber, and a system sheet would bring
//  chrome that fights it.
//

import SwiftUI

// MARK: - Muscle activation (1d)

struct MusclePanelSheet: View {
    var exerciseName: String
    var muscles: [MuscleActivation]
    var stabilisers: [String]
    var onDone: () -> Void

    var body: some View {
        SheetScaffold(grabberBottomSpacing: 18) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 0) {
                        MetaLine(text: exerciseName, em: 0.10)
                        Text("Muscles Worked")
                            .font(.ui(22, .semibold))
                            .tracking(-0.45)
                            .foregroundStyle(DS.silver)
                            .padding(.top, 5)
                    }
                    Spacer(minLength: 8)
                    Button("Done", action: onDone)
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver)
                        .buttonStyle(.plain)
                }

                bodyMap
                    .padding(.top, 18)

                VStack(alignment: .leading, spacing: 17) {
                    ForEach(muscles) { muscle in
                        MuscleActivationRow(muscle: muscle)
                    }
                }
                .padding(.top, 20)

                if !stabilisers.isEmpty {
                    Hairline(opacity: 0.07).padding(.top, 22)

                    Text(stabiliserNote)
                        .font(.ui(11.5))
                        .cssLineHeight(11.5, 1.55)
                        .foregroundStyle(DS.silver.opacity(0.42))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 16)
                }
            }
        }
    }

    /// Names this lift's own stabilisers — the muscles under the 20% cut.
    private var stabiliserNote: String {
        let names = stabilisers.joined(separator: ", ")
        return stabilisers.count == 1
            ? "Stabiliser — \(names) — contributes below 20% and is hidden."
            : "Stabilisers — \(names) — contribute below 20% and are hidden."
    }

    /// Front and back side by side on the studio ground, both always shown so
    /// back-of-body work (lats, triceps, glutes) is never a tap away.
    private var bodyMap: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                ForEach(BodySide.allCases, id: \.self) { side in
                    VStack(spacing: 8) {
                        BodyMapFigure(side: side, muscles: muscles)
                        Text(side.title)
                            .font(.mono(9, .semibold))
                            .trackingEm(0.10, size: 9)
                            .foregroundStyle(DS.silver.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 16)
            .padding(.bottom, 12)
            // Tall enough to read a single muscle at a glance, but capped by
            // the screen so the panel still fits on a small phone.
            .containerRelativeFrame(.vertical) { height, _ in min(370, height * 0.46) }
            .background(
                ViewportGround(inner: DS.viewportInner, outer: DS.viewportOuter,
                               rx: 0.90, ry: 0.70, cx: 0.5, cy: 0.45)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            )

            HStack(spacing: 16) {
                legendItem(DS.activation, ActivationRank.primary.rawValue)
                legendItem(ActivationRank.secondary.barColor, ActivationRank.secondary.rawValue)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func legendItem(_ color: Color, _ title: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(title)
                .font(.mono(9, .medium))
                .trackingEm(0.08, size: 9)
                .foregroundStyle(DS.silver.opacity(0.5))
        }
    }
}

// MARK: - Technique cue (1e)

struct CueSheet: View {
    var cue: TechniqueCue
    var number: Int
    var mode: FormMode
    var onSelectMode: (FormMode) -> Void
    var onDone: () -> Void

    var body: some View {
        SheetScaffold {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 0) {
                        MetaLine(text: String(format: "TECHNIQUE CUE %02d", number), em: 0.10)
                        Text(cue.title)
                            .font(.ui(22, .semibold))
                            .tracking(-0.45)
                            .foregroundStyle(DS.silver)
                            .padding(.top, 5)
                    }
                    Spacer(minLength: 8)
                    Button("Done", action: onDone)
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver)
                        .buttonStyle(.plain)
                }

                Text(cue.intro)
                    .font(.ui(14))
                    .cssLineHeight(14, 1.55)
                    .foregroundStyle(DS.silver.opacity(0.68))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 12)

                VStack(alignment: .leading, spacing: 15) {
                    CueSection(label: "WHY IT MATTERS", text: cue.why)
                    Hairline()
                    CueSection(label: "COMMON MISTAKE", text: cue.mistake,
                               labelColor: DS.activationText)
                    Hairline()
                    CueSection(label: "CORRECT FORM", text: cue.correct)
                }
                .padding(.top, 20)

                HStack(spacing: 9) {
                    WideButton(title: "Show Correct Form",
                               prominent: mode == .correct) { onSelectMode(.correct) }
                    WideButton(title: "Show Common Mistake",
                               prominent: mode == .mistake) { onSelectMode(.mistake) }
                }
                .padding(.top, 22)
            }
        }
    }
}

// MARK: - Common mistake (compact)

/// The cue sheet folded down while its mistake plays, so the whole lifter —
/// and the yellow ghost of the mistake — stays in view.
struct MistakeBar: View {
    var cue: TechniqueCue
    /// A yellow ghost is drawn over the model; the key says what it is.
    var drawsGhost: Bool
    var onShowCorrect: () -> Void
    var onDone: () -> Void

    var body: some View {
        SheetScaffold(bottomPadding: 26, grabberBottomSpacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .firstTextBaseline) {
                    Text("COMMON MISTAKE")
                        .font(.mono(9.5, .semibold))
                        .trackingEm(0.11, size: 9.5)
                        .foregroundStyle(DS.activationText)
                    Spacer(minLength: 8)
                    Button("Done", action: onDone)
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver)
                        .buttonStyle(.plain)
                }

                Text(cue.mistake)
                    .font(.ui(14))
                    .cssLineHeight(14, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)

                if drawsGhost {
                    HStack(spacing: 8) {
                        Capsule()
                            .fill(DS.fault)
                            .overlay(Capsule().strokeBorder(DS.faultShade, lineWidth: 0.5))
                            .frame(width: 18, height: 4)
                        Text("Yellow shows the mistake · the model shows correct form")
                            .font(.ui(12))
                            .foregroundStyle(DS.silver.opacity(0.5))
                    }
                    .padding(.top, 10)
                    .accessibilityElement(children: .combine)
                }

                WideButton(title: "Show Correct Form", prominent: true, action: onShowCorrect)
                    .padding(.top, 14)
            }
        }
    }
}
