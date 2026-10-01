//
//  Components.swift
//  GymWorkout
//
//  Shared primitives from the Anatomy Trainer design system.
//

import SwiftUI

// MARK: - Labels

/// Section eyebrow: `CONTINUE TRAINING`, `MUSCLE GROUPS`, …
struct SectionEyebrow: View {
    var text: String
    var size: CGFloat = 11
    var em: CGFloat = 0.10
    var color: Color = DS.silver.opacity(0.45)

    var body: some View {
        Text(text)
            .font(.mono(size, .semibold))
            .trackingEm(em, size: size)
            .foregroundStyle(color)
    }
}

/// Monospaced meta line under a title: `CHEST · BARBELL · INTERMEDIATE`.
struct MetaLine: View {
    var text: String
    var size: CGFloat = 9.5
    var em: CGFloat = 0.08
    var color: Color = DS.silver.opacity(0.4)

    var body: some View {
        Text(text)
            .font(.mono(size, .medium))
            .trackingEm(em, size: size)
            .foregroundStyle(color)
    }
}

// MARK: - Buttons

/// The 34pt circular header control (back, favourite, overflow).
struct CircleIconButton<Content: View>: View {
    var diameter: CGFloat = 34
    var background: Color = DS.silver.opacity(0.08)
    var border: Color? = nil
    var action: () -> Void
    @ViewBuilder var content: () -> Content

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(background)
                if let border {
                    Circle().strokeBorder(border, lineWidth: 1)
                }
                content()
            }
            .frame(width: diameter, height: diameter)
        }
        .buttonStyle(.plain)
    }
}

/// Squared glass control that sits inside a viewport (muscles worked, key tips).
struct GlassSquareButton<Content: View>: View {
    var side: CGFloat = 32
    var action: () -> Void
    @ViewBuilder var content: () -> Content

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(DS.glass(0.72))
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.10), lineWidth: 1)
                content()
            }
            .frame(width: side, height: side)
            .background(.ultraThinMaterial.opacity(0.001))
        }
        .buttonStyle(.plain)
    }
}

/// Full-width action button. Silver when prominent, glass otherwise.
struct WideButton: View {
    var title: String
    var prominent: Bool
    var fontSize: CGFloat = 13.5
    var verticalPadding: CGFloat = 13
    var cornerRadius: CGFloat = 13
    var border: Color? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ui(fontSize, .semibold))
                .foregroundStyle(prominent ? DS.ink : DS.silver)
                .frame(maxWidth: .infinity)
                .padding(.vertical, verticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(prominent ? DS.silver : DS.silver.opacity(0.07))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(border ?? (prominent ? DS.silver : DS.silver.opacity(0.10)),
                                      lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Filter chip

struct FilterChip: View {
    var title: String
    var selected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ui(12.5, .semibold))
                .foregroundStyle(selected ? DS.ink : DS.silver.opacity(0.6))
                .padding(.horizontal, 13)
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(selected ? DS.silver : DS.silver.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .strokeBorder(selected ? DS.silver : DS.silver.opacity(0.08), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Monospaced segmented control

struct MonoSegmentedControl<Value: Hashable>: View {
    var options: [(value: Value, title: String)]
    @Binding var selection: Value

    var fontSize: CGFloat = 9.5
    var em: CGFloat = 0.08
    var itemPaddingH: CGFloat = 11
    var itemPaddingV: CGFloat = 6
    var itemRadius: CGFloat = 8
    var trackRadius: CGFloat = 10
    var trackPadding: CGFloat = 3
    var trackColor: Color = DS.silver.opacity(0.06)
    var inactiveBackground: Color = .clear
    var fillsWidth: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                let isOn = option.value == selection
                Button {
                    selection = option.value
                } label: {
                    Text(option.title)
                        .font(.mono(fontSize, .semibold))
                        .trackingEm(em, size: fontSize)
                        .foregroundStyle(isOn ? DS.ink : DS.silver.opacity(0.5))
                        .frame(maxWidth: fillsWidth ? .infinity : nil)
                        .padding(.horizontal, itemPaddingH)
                        .padding(.vertical, itemPaddingV)
                        .background(
                            RoundedRectangle(cornerRadius: itemRadius, style: .continuous)
                                .fill(isOn ? DS.silver : inactiveBackground)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(trackPadding)
        .background(
            RoundedRectangle(cornerRadius: trackRadius, style: .continuous)
                .fill(trackColor)
        )
    }
}

// MARK: - Viewport annotations

/// The label-plus-leader-plus-dot callout anchored to a point on the model.
struct AnnotationCallout: View {
    enum Direction { case pointsRight, pointsLeft }

    var text: String
    var direction: Direction = .pointsRight
    var borderColor: Color = DS.silver.opacity(0.16)
    var leaderLength: CGFloat = 46
    var lineTint: Color = DS.silver
    var dotColor: Color = DS.silver
    var ringColor: Color = DS.silver.opacity(0.14)
    var fontSize: CGFloat = 12
    var paddingH: CGFloat = 12
    var paddingV: CGFloat = 7
    var cornerRadius: CGFloat = 13
    var shadowed: Bool = true
    var ringed: Bool = true

    private var pill: some View {
        CalloutPill(text: text, borderColor: borderColor, fontSize: fontSize,
                    paddingH: paddingH, paddingV: paddingV,
                    cornerRadius: cornerRadius, shadowed: shadowed)
    }

    private var leader: some View {
        LinearGradient(
            colors: [lineTint.opacity(0.65), lineTint.opacity(0.2)],
            startPoint: direction == .pointsRight ? .leading : .trailing,
            endPoint: direction == .pointsRight ? .trailing : .leading
        )
        .frame(width: leaderLength, height: 1)
    }

    private var dot: some View {
        CalloutDot(color: dotColor, ringColor: ringed ? ringColor : .clear)
    }

    var body: some View {
        HStack(spacing: 0) {
            if direction == .pointsRight {
                pill
                leader
                dot.padding(.leading, -3)
            } else {
                dot.padding(.trailing, -3)
                leader
                pill
            }
        }
    }
}

/// The glass label of a callout.
struct CalloutPill: View {
    var text: String
    var borderColor: Color = DS.silver.opacity(0.16)
    var fontSize: CGFloat = 12
    var paddingH: CGFloat = 12
    var paddingV: CGFloat = 7
    var cornerRadius: CGFloat = 13
    var shadowed: Bool = true

    var body: some View {
        Text(text)
            .font(.ui(fontSize, .semibold))
            .foregroundStyle(DS.silver)
            .lineLimit(1)
            .fixedSize()
            .padding(.horizontal, paddingH)
            .padding(.vertical, paddingV)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(DS.glass(0.66))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
            .shadow(color: .black.opacity(shadowed ? 0.4 : 0), radius: 8, y: 4)
    }
}

/// The dot a callout's leader ends on, with its soft ring.
struct CalloutDot: View {
    var color: Color = DS.silver
    var ringColor: Color = DS.silver.opacity(0.14)

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 7, height: 7)
            .background(
                Circle()
                    .fill(ringColor)
                    .frame(width: 15, height: 15)
            )
    }
}

/// A callout whose label stays put while its dot follows a moving point.
///
/// `AnnotationCallout` can only draw a level leader; this one runs the leader
/// at whatever angle the dot needs. Lay it over the whole viewport: every
/// point is in the viewport's own coordinates.
struct TrackedCallout: View {
    var text: String
    /// Middle of the label's edge the leader leaves from.
    var labelPoint: CGPoint
    /// Which side of `labelPoint` the label sits on.
    var labelSide: HorizontalEdge
    var dot: CGPoint
    var borderColor: Color = DS.silver.opacity(0.16)
    var action: () -> Void

    /// Clear space kept between the label and the viewport's edges.
    static let edgeMargin: CGFloat = 8

    @State private var pillSize: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            let anchor = anchor(in: geo.size)
            ZStack(alignment: .topLeading) {
                Path { path in
                    path.move(to: anchor)
                    path.addLine(to: dot)
                }
                .stroke(
                    LinearGradient(
                        colors: [DS.silver.opacity(0.65), DS.silver.opacity(0.2)],
                        startPoint: unit(anchor, in: geo.size),
                        endPoint: unit(dot, in: geo.size)
                    ),
                    lineWidth: 1
                )
                .allowsHitTesting(false)

                CalloutDot()
                    .position(dot)
                    .allowsHitTesting(false)

                Button(action: action) {
                    CalloutPill(text: text, borderColor: borderColor)
                }
                .buttonStyle(.plain)
                .onGeometryChange(for: CGSize.self) { $0.size } action: { pillSize = $0 }
                // Pin the label's edge-middle to the anchor.
                .alignmentGuide(.leading) { d in
                    labelSide == .leading ? d.width - anchor.x : -anchor.x
                }
                .alignmentGuide(.top) { d in d.height / 2 - anchor.y }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
        }
    }

    /// `labelPoint`, moved just far enough that the whole label stays inside
    /// the viewport. Label points are unit fractions laid out on one device
    /// width while the label keeps its own size, so on a narrower screen a
    /// label near an edge would otherwise be cut off by the viewport's clip.
    private func anchor(in size: CGSize) -> CGPoint {
        let m = Self.edgeMargin
        let w = pillSize.width, h = pillSize.height
        let minX = labelSide == .leading ? m + w : m
        let maxX = labelSide == .leading ? size.width - m : size.width - m - w
        let minY = m + h / 2
        let maxY = size.height - m - h / 2
        return CGPoint(
            x: minX <= maxX ? min(max(labelPoint.x, minX), maxX) : labelPoint.x,
            y: minY <= maxY ? min(max(labelPoint.y, minY), maxY) : labelPoint.y
        )
    }

    private func unit(_ p: CGPoint, in size: CGSize) -> UnitPoint {
        UnitPoint(x: p.x / max(size.width, 1), y: p.y / max(size.height, 1))
    }
}

// MARK: - Muscle activation row

struct MuscleActivationRow: View {
    var muscle: MuscleActivation
    var nameSize: CGFloat = 14.5
    var barHeight: CGFloat = 7
    var showsPercent: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text(muscle.name)
                    .font(.ui(nameSize, .semibold))
                    .foregroundStyle(DS.silver)
                Spacer(minLength: 8)
                Text(muscle.rank.rawValue)
                    .font(.mono(8.5, .semibold))
                    .trackingEm(0.10, size: 8.5)
                    .foregroundStyle(muscle.rank.tagForeground)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(muscle.rank.tagBackground)
                    )
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(DS.silver.opacity(0.08))
                    Capsule()
                        .fill(muscle.rank.barColor)
                        .frame(width: geo.size.width * muscle.fraction)
                }
            }
            .frame(height: barHeight)
            .padding(.top, 9)

            HStack {
                Text(muscle.activation)
                    .font(.mono(9.5, .medium))
                    .trackingEm(0.06, size: 9.5)
                    .foregroundStyle(DS.silver.opacity(0.42))
                if showsPercent {
                    Spacer(minLength: 8)
                    Text(muscle.percentLabel)
                        .font(.mono(9.5, .medium))
                        .foregroundStyle(DS.silver.opacity(0.3))
                }
            }
            .padding(.top, 6)
        }
    }
}

// MARK: - Sheets

/// The ground under a bottom panel: rounded shoulders and a top hairline only
/// (CSS `border-top` + `border-radius: r r 0 0`). The body deliberately runs
/// past the bottom of the screen so the stroke's bottom edge never shows as a
/// stray line above the home indicator.
struct PanelGround: View {
    var radius: CGFloat
    var fill: Color = DS.surface
    var border: Color

    private var shape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: radius,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: radius,
            style: .continuous
        )
    }

    var body: some View {
        shape
            .fill(fill)
            .overlay(shape.strokeBorder(border, lineWidth: 1))
            .padding(.bottom, -80)
            .ignoresSafeArea(edges: .bottom)
    }
}

/// Grabber + surface used by every bottom panel in the design.
struct SheetScaffold<Content: View>: View {
    var bottomPadding: CGFloat = 34
    var grabberBottomSpacing: CGFloat = 16
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(DS.silver.opacity(0.22))
                .frame(width: 38, height: 4)
                .padding(.top, 12)
                .padding(.bottom, grabberBottomSpacing)

            content()
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.bottom, bottomPadding)
        .frame(maxWidth: .infinity)
        .background(alignment: .top) {
            PanelGround(radius: DS.Metric.sheetRadius, border: DS.silver.opacity(0.11))
        }
    }
}

/// A labelled block inside the cue sheet (`WHY IT MATTERS`, …).
struct CueSection: View {
    var label: String
    var text: String
    var labelColor: Color = DS.silver.opacity(0.4)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.mono(9.5, .semibold))
                .trackingEm(0.11, size: 9.5)
                .foregroundStyle(labelColor)
            Text(text)
                .font(.ui(13.5))
                .cssLineHeight(13.5, 1.5)
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// The `SHOWING COMMON MISTAKE · …` banner.
struct MistakeBanner: View {
    var text: String

    var body: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(DS.activation)
                .frame(width: 6, height: 6)
            Text(text)
                .font(.mono(9.5, .semibold))
                .trackingEm(0.11, size: 9.5)
                .foregroundStyle(DS.activationTint)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(DS.activation.opacity(0.16))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .strokeBorder(DS.activation.opacity(0.5), lineWidth: 1)
        )
    }
}

/// The soft ring that marks *where* a fault shows up on the model.
struct FaultRing: View {
    var diameter: CGFloat = 112

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: DS.activation.opacity(0.26), location: 0),
                            .init(color: DS.activation.opacity(0), location: 0.68)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: diameter / 2
                    )
                )
            Circle()
                .strokeBorder(DS.activation.opacity(0.7), lineWidth: 1.5)
        }
        .frame(width: diameter, height: diameter)
        .allowsHitTesting(false)
    }
}

// MARK: - Divider

struct Hairline: View {
    var opacity: Double = 0.07
    var body: some View {
        Rectangle()
            .fill(DS.silver.opacity(opacity))
            .frame(height: 1)
    }
}

extension View {
    /// Paints the screen ground behind the status bar, so a page that
    /// scrolls under it doesn't run its text into the clock.
    func statusBarScrim() -> some View {
        overlay(alignment: .top) {
            // A zero-height strip at the top whose background reaches up
            // through the safe area, i.e. exactly the status bar's height.
            Color.clear
                .frame(height: 0)
                .background(DS.ink.ignoresSafeArea(edges: .top))
                .allowsHitTesting(false)
        }
    }
}
