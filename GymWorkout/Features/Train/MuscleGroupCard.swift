//
//  MuscleGroupCard.swift
//  GymWorkout
//
//  A muscle group on the Train tab: name, recovery state, one line of detail,
//  and a small body-map figure with the group lit. Recovering groups fade a
//  little but stay fully tappable — nothing here ever locks a workout.
//

import SwiftUI

enum MuscleCardState: Hashable {
    case ready, partlyReady, almostReady, recovering, completedToday, completed, inProgress, planned

    init(_ status: RecoveryStatus?) {
        switch status {
        case .none, .ready: self = .ready
        case .partlyReady: self = .partlyReady
        case .almostReady: self = .almostReady
        case .recovering: self = .recovering
        }
    }

    var label: String {
        switch self {
        case .ready: return "READY"
        case .partlyReady: return "PARTLY READY"
        case .almostReady: return "ALMOST READY"
        case .recovering: return "RECOVERING"
        case .completedToday: return "COMPLETED TODAY"
        case .completed: return "COMPLETED"
        case .inProgress: return "IN PROGRESS"
        case .planned: return "PLANNED"
        }
    }

    var symbol: String {
        switch self {
        case .ready: return "circle.fill"
        case .partlyReady: return "circle.bottomhalf.filled"
        case .almostReady: return "circle.lefthalf.filled"
        case .recovering: return "circle"
        case .completedToday, .completed: return "checkmark.circle.fill"
        case .inProgress: return "circle.dotted"
        case .planned: return "circle.dashed"
        }
    }
}

struct MuscleGroupCard<Accessory: View>: View {
    typealias Size = MuscleCardSize

    var group: MuscleGroup
    var state: MuscleCardState
    var detail: String
    var secondaryDetail: String? = nil
    /// Where the group stands this round, for VoiceOver.
    var tone: MuscleCardTone? = nil
    /// The edge colour; none keeps the plain hairline (a past day's log, a
    /// tone the user's card colours leave out, or card colours off).
    var edgeColor: Color? = nil
    /// The phone's metrics unless an iPad grid asks for more.
    var size: Size = .standard
    var action: () -> Void
    /// A control in the bottom-right corner, kept out of the card's own
    /// button: the presets menu on the Train tab.
    @ViewBuilder var accessory: () -> Accessory

    private var hasAccessory: Bool { Accessory.self != EmptyView.self }

    var body: some View {
        let m = size.metrics
        Button(action: action) {
            HStack(alignment: .top, spacing: m.spacing) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(group.title)
                        .font(.ui(m.title, .semibold))
                        .tracking(m.titleTracking)
                        .foregroundStyle(DS.silver)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    MuscleStateLabel(state: state, size: m.state)
                        .padding(.top, m.stateGap)

                    Spacer(minLength: 8)

                    // iPad cards keep each detail on one line, shrinking a
                    // little rather than breaking "Trained 4 days ago" in two.
                    Text(detail)
                        .font(.ui(m.detail))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .lineLimit(size == .standard ? 2 : 1)
                        .minimumScaleFactor(size == .standard ? 1 : 0.85)
                        .fixedSize(horizontal: false, vertical: true)
                    if let secondaryDetail {
                        Text(secondaryDetail)
                            .font(.ui(m.detail))
                            .foregroundStyle(DS.silver.opacity(0.4))
                            .lineLimit(size == .standard ? nil : 1)
                            .minimumScaleFactor(size == .standard ? 1 : 0.85)
                            .padding(.top, 2)
                    }
                }
                Spacer(minLength: 0)
                // Shorter with an accessory, so the figure clears it.
                MiniBodyMap(group: group, lineWidth: m.lineWidth)
                    .frame(width: m.figureWidth,
                           height: hasAccessory ? m.figureHeightWithAccessory : m.figureHeight)
            }
            .padding(m.padding)
            .frame(maxWidth: .infinity, minHeight: m.minHeight, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: m.radius, style: .continuous)
                    .fill(DS.surfaceAlt)
                    // A soft halo in the edge colour, so it reads from across
                    // the grid.
                    .shadow(color: edgeColor?.opacity(0.28) ?? .clear, radius: m.halo)
            )
            .overlay(
                RoundedRectangle(cornerRadius: m.radius, style: .continuous)
                    .strokeBorder(DS.silver.opacity(state == .ready ? 0.12 : 0.06), lineWidth: 1)
                    .opacity(edgeColor == nil ? 1 : 0)
            )
            .opacity(state == .recovering ? 0.6 : 1)
            // After the fade, so a recovering card's red edge stays clear.
            .overlay {
                if let edgeColor {
                    RoundedRectangle(cornerRadius: m.radius, style: .continuous)
                        .strokeBorder(edgeColor.opacity(tone == .recent ? 0.7 : 0.85), lineWidth: 1.5)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(group.title), \(state.label.lowercased()), \(detail)"
                            + (secondaryDetail.map { ", \($0)" } ?? "")
                            + (tone == .due ? ", due" : ""))
        .overlay(alignment: .bottomTrailing) {
            // Centred under the figure: the 44pt control's middle on the
            // figure's, whatever the figure's width.
            accessory()
                .padding(.trailing, m.padding + m.figureWidth / 2 - 22)
                .padding(.bottom, m.accessoryBottom)
        }
        // Last, so the lift carries the ⋯ with the card instead of leaving
        // it behind.
        .dsHover(.lift, radius: m.radius)
    }
}

extension MuscleGroupCard where Accessory == EmptyView {
    init(group: MuscleGroup, state: MuscleCardState, detail: String, secondaryDetail: String? = nil,
         tone: MuscleCardTone? = nil, edgeColor: Color? = nil, size: Size = .standard,
         action: @escaping () -> Void) {
        self.init(group: group, state: state, detail: detail, secondaryDetail: secondaryDetail,
                  tone: tone, edgeColor: edgeColor, size: size, action: action, accessory: { EmptyView() })
    }
}

/// How big a group card (or a planned group's row) draws. Kept outside the
/// generic card so the Train tab can pass one around.
enum MuscleCardSize: Hashable {
    /// The phone's two-column grid; today's metrics, used on every iPhone.
    case standard
    /// The iPad grids: RECENTLY TRAINED, MORE MUSCLE GROUPS, a past day's log.
    case regular
    /// The iPad's RECOMMENDED row: a taller card with a figure big enough to
    /// read the lit muscles from a stand.
    case hero

    struct Metrics {
        var padding: CGFloat
        var minHeight: CGFloat
        var spacing: CGFloat
        var title: CGFloat
        var titleTracking: CGFloat
        var state: CGFloat
        var stateGap: CGFloat
        var detail: CGFloat
        var figureWidth: CGFloat
        var figureHeight: CGFloat
        /// The figure is aspect-fit and width-bound, so this only moves it
        /// up within its frame, clear of the ⋯ below.
        var figureHeightWithAccessory: CGFloat
        var lineWidth: CGFloat
        var radius: CGFloat
        var halo: CGFloat
        var accessoryBottom: CGFloat
    }

    var metrics: Metrics {
        switch self {
        case .standard:
            return Metrics(padding: 12, minHeight: 112, spacing: 8, title: 15, titleTracking: -0.2,
                           state: 8.5, stateGap: 6, detail: 11.5,
                           figureWidth: 30, figureHeight: 74, figureHeightWithAccessory: 60,
                           lineWidth: 0.5, radius: 16, halo: 6, accessoryBottom: 2)
        case .regular:
            return Metrics(padding: 16, minHeight: 136, spacing: 8, title: 17, titleTracking: -0.25,
                           state: 9.5, stateGap: 7, detail: 13,
                           figureWidth: 40, figureHeight: 96, figureHeightWithAccessory: 80,
                           lineWidth: 0.5, radius: 20, halo: 10, accessoryBottom: 4)
        case .hero:
            return Metrics(padding: 18, minHeight: 176, spacing: 12, title: 20, titleTracking: -0.4,
                           state: 10, stateGap: 8, detail: 13.5,
                           figureWidth: 56, figureHeight: 132, figureHeightWithAccessory: 116,
                           lineWidth: 0.75, radius: 20, halo: 10, accessoryBottom: 5)
        }
    }
}

struct MuscleStateLabel: View {
    var state: MuscleCardState
    /// The phone's 8.5; iPad cards pass a larger one.
    var size: CGFloat = 8.5

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: state.symbol)
                .font(.system(size: size - 0.5, weight: .semibold))
            Text(state.label)
                .font(.mono(size, .semibold))
                .trackingEm(0.08, size: size)
                // The larger sizes sit in iPad columns that can run narrow
                // (a Split View); the phone's never needs to shrink.
                .lineLimit(size == 8.5 ? nil : 1)
                .minimumScaleFactor(size == 8.5 ? 1 : 0.8)
        }
        .foregroundStyle(DS.silver.opacity([.ready, .partlyReady, .completedToday, .completed].contains(state) ? 0.85 : 0.5))
    }
}

/// The group lit on the existing body map, from the side it's best seen.
struct MiniBodyMap: View {
    var group: MuscleGroup
    var color: Color = DS.activation
    /// Hairline at phone sizes; a larger figure can take a firmer outline.
    var lineWidth: CGFloat = 0.5

    var body: some View {
        BodyMapCanvas(
            side: group.preferredSide,
            fills: Dictionary(group.bodyRegions.map { ($0, color) }, uniquingKeysWith: { a, _ in a }),
            lineWidth: lineWidth
        )
        .accessibilityHidden(true)
    }
}
