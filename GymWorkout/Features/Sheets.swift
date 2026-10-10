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
//  Their content lives apart from the panels (`MuscleActivationContent`,
//  `CueDetailContent`, `MistakeContent`): on iPad the trainer has room to show
//  it beside the model, in its inspector, instead of over it. The panels only
//  wrap that content in a `SheetScaffold`, so the phone draws exactly what it
//  always has.
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
            MuscleActivationContent(exerciseName: exerciseName, muscles: muscles,
                                    stabilisers: stabilisers, onDone: onDone)
        }
    }
}

/// Which muscles the lift works and how hard: front and back on the studio
/// ground, the activation bars, and the stabilisers left out.
struct MuscleActivationContent: View {
    /// Upper-cased, for the sheet's eyebrow.
    var exerciseName: String = ""
    var muscles: [MuscleActivation]
    var stabilisers: [String]
    /// Drawn in the iPad trainer's inspector rather than in a sheet: an
    /// eyebrow for a header, both figures at one height, a size up
    /// throughout.
    var inline: Bool = false
    /// The sheet's Done; nil draws none.
    var onDone: (() -> Void)? = nil

    /// The inspector column, which the figures are sized to.
    @State private var columnWidth: CGFloat = 0

    var body: some View {
        if inline {
            inlineBody
        } else {
            sheetBody
        }
    }

    // MARK: Sheet

    private var sheetBody: some View {
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
                if let onDone {
                    Button("Done", action: onDone)
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver)
                        .buttonStyle(.plain)
                        .padCancelShortcut()
                }
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

            legend(size: 9)
        }
    }

    private func legend(size: CGFloat) -> some View {
        HStack(spacing: 16) {
            legendItem(DS.activation, ActivationRank.primary.rawValue, size: size)
            legendItem(ActivationRank.secondary.barColor, ActivationRank.secondary.rawValue, size: size)
        }
        .frame(maxWidth: .infinity)
    }

    private func legendItem(_ color: Color, _ title: String, size: CGFloat) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(title)
                .font(.mono(size, .medium))
                .trackingEm(0.08, size: size)
                .foregroundStyle(DS.silver.opacity(0.5))
        }
    }

    // MARK: Inline (iPad inspector)

    private var inlineBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: "MUSCLES WORKED")

            // A fixed figure height rather than the sheet's share of the
            // screen: inside a scroll view that share would be measured
            // against the scroll view, not the window.
            BodyMapPair(source: .muscles(muscles), figureHeight: inlineFigureHeight)
                .padding(.top, 22)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
                .background(
                    ViewportGround(inner: DS.viewportInner, outer: DS.viewportOuter,
                                   rx: 0.90, ry: 0.70, cx: 0.5, cy: 0.45, aspectLocked: true)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                )
                .padding(.top, 14)

            legend(size: 10)
                .padding(.top, 14)

            VStack(alignment: .leading, spacing: 18) {
                ForEach(muscles) { muscle in
                    MuscleActivationRow(muscle: muscle)
                }
            }
            .padding(.top, 22)

            if !stabilisers.isEmpty {
                Hairline(opacity: 0.07).padding(.top, 22)

                Text(stabiliserNote)
                    .font(.ui(12))
                    .cssLineHeight(12, 1.55)
                    .foregroundStyle(DS.silver.opacity(0.45))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 14)
            }
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { columnWidth = $0 }
    }

    /// 280pt figures, shrunk only as far as a 360pt inspector needs to keep
    /// the pair clear of the tile's rounded edges.
    private var inlineFigureHeight: CGFloat {
        guard columnWidth > 0 else { return 260 }
        let fit = (columnWidth - 40) / (2 * BodyMapCanvas.aspect + 0.10)
        return min(280, max(160, fit))
    }
}

// MARK: - Technique cue (1e)

struct CueSheet: View {
    var cue: TechniqueCue
    var number: Int
    var mode: FormMode
    /// The mistake view is Premium's: the button wears a lock, and selecting
    /// it is the caller's cue to open the paywall.
    var mistakeLocked: Bool = false
    var onSelectMode: (FormMode) -> Void
    var onDone: () -> Void

    var body: some View {
        SheetScaffold {
            CueDetailContent(cue: cue, number: number, mode: mode,
                             mistakeLocked: mistakeLocked,
                             onSelectMode: onSelectMode, onClose: onDone)
        }
    }
}

/// One cue in full: what to do, why, the mistake it prevents, and the
/// correct-form / common-mistake switch for the model.
///
/// Compact is the cue sheet's body. Regular is the expanded card in the iPad
/// trainer's inspector: larger type for the longer reading distance, and the
/// two buttons folded into one segmented switch that stays put while the
/// mistake plays, so the way back is always where it was.
struct CueDetailContent: View {
    var cue: TechniqueCue
    var number: Int
    var mode: FormMode
    var mistakeLocked: Bool = false
    /// Regular only: the mistake is playing on the model, so the card reads
    /// the mistake's own copy (`MistakeContent`) instead of the three
    /// sections.
    var showsMistake: Bool = false
    /// Whether that mistake has a yellow ghost over the model to key.
    var drawsGhost: Bool = false
    var onSelectMode: (FormMode) -> Void
    /// The sheet's Done, or the card's collapse; nil draws neither.
    var onClose: (() -> Void)? = nil

    @Environment(\.dsLayout) private var layout

    var body: some View {
        if layout.isRegular {
            regularBody
        } else {
            compactBody
        }
    }

    // MARK: Compact

    private var compactBody: some View {
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
                if let onClose {
                    Button("Done", action: onClose)
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver)
                        .buttonStyle(.plain)
                        .padCancelShortcut()
                }
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
                if mistakeLocked {
                    lockedMistakeButton
                } else {
                    WideButton(title: "Show Common Mistake",
                               prominent: mode == .mistake) { onSelectMode(.mistake) }
                }
            }
            .padding(.top, 22)
        }
    }

    /// The glass `WideButton`, with a lock ahead of its title.
    private var lockedMistakeButton: some View {
        Button { onSelectMode(.mistake) } label: {
            HStack(spacing: 5) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 10, weight: .semibold))
                Text("Show Common Mistake")
                    .font(.ui(13.5, .semibold))
            }
            .foregroundStyle(DS.silver)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(DS.silver.opacity(0.07))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.10), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityHint("Comes with Premium")
    }

    // MARK: Regular

    private var regularBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    MetaLine(text: String(format: "TECHNIQUE CUE %02d", number), em: 0.10)
                    Text(cue.title)
                        .font(.ui(20, .semibold))
                        .tracking(-0.4)
                        .foregroundStyle(DS.silver)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 6)
                }
                Spacer(minLength: 0)
                if let onClose {
                    Button(action: onClose) {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(DS.silver.opacity(0.07)))
                    }
                    .buttonStyle(.plain)
                    .dsHover(.highlight)
                    .accessibilityLabel("Close cue")
                }
            }

            if showsMistake {
                MistakeContent(cue: cue, drawsGhost: drawsGhost)
                    .padding(.top, 16)
                    .transition(.opacity)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    Text(cue.intro)
                        .font(.ui(14.5))
                        .cssLineHeight(14.5, 1.55)
                        .foregroundStyle(DS.silver.opacity(0.68))
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 16) {
                        regularSection("WHY IT MATTERS", cue.why)
                        Hairline()
                        regularSection("COMMON MISTAKE", cue.mistake, labelColor: DS.activationText)
                        Hairline()
                        regularSection("CORRECT FORM", cue.correct)
                    }
                    .padding(.top, 18)
                }
                .padding(.top, 12)
                .transition(.opacity)
            }

            FormModeToggle(mode: mode, mistakeLocked: mistakeLocked, onSelect: onSelectMode)
                .padding(.top, 20)
        }
    }

    /// `CueSection` a size up: mono 10 label, 14pt body.
    private func regularSection(_ label: String, _ text: String,
                                labelColor: Color = DS.silver.opacity(0.4)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.mono(10, .semibold))
                .trackingEm(0.11, size: 10)
                .foregroundStyle(labelColor)
            Text(text)
                .font(.ui(14))
                .cssLineHeight(14, 1.5)
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Correct form or common mistake, as one 44pt two-segment switch in the
/// `MonoSegmentedControl` style — with a lock on the mistake for a free
/// account, which that control can't draw. A tap only asks: the caller
/// decides (and opens the paywall instead), so the switch shows `mode`, not
/// the tap.
private struct FormModeToggle: View {
    var mode: FormMode
    var mistakeLocked: Bool
    var onSelect: (FormMode) -> Void

    var body: some View {
        HStack(spacing: 4) {
            segment(.correct, title: "CORRECT FORM", locked: false)
            segment(.mistake, title: "COMMON MISTAKE", locked: mistakeLocked)
        }
        .padding(3)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(DS.silver.opacity(0.06))
        )
        // The cap `MonoSegmentedControl` puts on a full-width track, so the
        // switch doesn't run the width of a card in the stacked inspector.
        .frame(maxWidth: 440, alignment: .leading)
    }

    private func segment(_ value: FormMode, title: String, locked: Bool) -> some View {
        let isOn = mode == value
        return Button { onSelect(value) } label: {
            HStack(spacing: 5) {
                if locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 9, weight: .semibold))
                }
                Text(title)
                    .font(.mono(10.5, .semibold))
                    .trackingEm(0.08, size: 10.5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(isOn ? DS.ink : DS.silver.opacity(0.55))
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isOn ? DS.silver : .clear)
            )
            .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: 8)
        .accessibilityLabel(value == .correct ? "Show correct form" : "Show common mistake")
        .accessibilityAddTraits(isOn ? .isSelected : [])
        .accessibilityHint(locked ? "Comes with Premium" : "")
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
            MistakeContent(cue: cue, drawsGhost: drawsGhost,
                           onShowCorrect: onShowCorrect, onDone: onDone)
        }
    }
}

/// What the playing mistake is, and the key to its yellow ghost.
struct MistakeContent: View {
    var cue: TechniqueCue
    /// A yellow ghost is drawn over the model; the key says what it is.
    var drawsGhost: Bool
    /// The way back to the correct form; nil where a switch beside it
    /// already offers one (the iPad cue card).
    var onShowCorrect: (() -> Void)? = nil
    /// The bar's Done; nil draws none.
    var onDone: (() -> Void)? = nil

    @Environment(\.dsLayout) private var layout

    var body: some View {
        if layout.isRegular {
            regularBody
        } else {
            compactBody
        }
    }

    private var compactBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text("COMMON MISTAKE")
                    .font(.mono(9.5, .semibold))
                    .trackingEm(0.11, size: 9.5)
                    .foregroundStyle(DS.activationText)
                Spacer(minLength: 8)
                if let onDone {
                    Button("Done", action: onDone)
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver)
                        .buttonStyle(.plain)
                        .padCancelShortcut()
                }
            }

            Text(cue.mistake)
                .font(.ui(14))
                .cssLineHeight(14, 1.5)
                .foregroundStyle(DS.silver.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)

            if drawsGhost {
                HStack(spacing: 8) {
                    ghostKey
                    Text("Yellow shows the mistake · the model shows correct form")
                        .font(.ui(12))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
                .padding(.top, 10)
                .accessibilityElement(children: .combine)
            }

            if let onShowCorrect {
                WideButton(title: "Show Correct Form", prominent: true, action: onShowCorrect)
                    .padding(.top, 14)
            }
        }
    }

    /// A size up, and the key wraps in a narrow inspector column.
    private var regularBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("COMMON MISTAKE")
                .font(.mono(10, .semibold))
                .trackingEm(0.11, size: 10)
                .foregroundStyle(DS.activationText)

            Text(cue.mistake)
                .font(.ui(14.5))
                .cssLineHeight(14.5, 1.5)
                .foregroundStyle(DS.silver.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 9)

            if drawsGhost {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    // Level with the first line's x-height, not its baseline.
                    ghostKey
                        .alignmentGuide(.firstTextBaseline) { d in d.height + 2 }
                    Text("Yellow shows the mistake · the model shows correct form")
                        .font(.ui(13))
                        .cssLineHeight(13, 1.4)
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 12)
                .accessibilityElement(children: .combine)
            }

            if let onShowCorrect {
                WideButton(title: "Show Correct Form", prominent: true, action: onShowCorrect)
                    .padding(.top, 16)
            }
        }
    }

    private var ghostKey: some View {
        Capsule()
            .fill(DS.fault)
            .overlay(Capsule().strokeBorder(DS.faultShade, lineWidth: 0.5))
            .frame(width: 18, height: 4)
    }
}

private extension View {
    /// Esc closes an in-canvas panel on iPad; nothing changes on iPhone.
    @ViewBuilder
    func padCancelShortcut() -> some View {
        if DS.isPad {
            keyboardShortcut(.cancelAction)
        } else {
            self
        }
    }
}
