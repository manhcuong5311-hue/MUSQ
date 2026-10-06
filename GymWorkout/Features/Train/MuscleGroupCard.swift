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
    var group: MuscleGroup
    var state: MuscleCardState
    var detail: String
    var secondaryDetail: String? = nil
    /// Where the group stands this round, for VoiceOver.
    var tone: MuscleCardTone? = nil
    /// The edge colour; none keeps the plain hairline (a past day's log, a
    /// tone the user's card colours leave out, or card colours off).
    var edgeColor: Color? = nil
    var action: () -> Void
    /// A control in the bottom-right corner, kept out of the card's own
    /// button: the presets menu on the Train tab.
    @ViewBuilder var accessory: () -> Accessory

    private var hasAccessory: Bool { Accessory.self != EmptyView.self }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(group.title)
                        .font(.ui(15, .semibold))
                        .tracking(-0.2)
                        .foregroundStyle(DS.silver)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    MuscleStateLabel(state: state)
                        .padding(.top, 6)

                    Spacer(minLength: 8)

                    Text(detail)
                        .font(.ui(11.5))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    if let secondaryDetail {
                        Text(secondaryDetail)
                            .font(.ui(11.5))
                            .foregroundStyle(DS.silver.opacity(0.4))
                            .padding(.top, 2)
                    }
                }
                Spacer(minLength: 0)
                // Shorter with an accessory, so the figure clears it.
                MiniBodyMap(group: group)
                    .frame(width: 30, height: hasAccessory ? 60 : 74)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(DS.surfaceAlt)
                    // A soft halo in the edge colour, so it reads from across
                    // the grid.
                    .shadow(color: edgeColor?.opacity(0.28) ?? .clear, radius: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(DS.silver.opacity(state == .ready ? 0.12 : 0.06), lineWidth: 1)
                    .opacity(edgeColor == nil ? 1 : 0)
            )
            .opacity(state == .recovering ? 0.6 : 1)
            // After the fade, so a recovering card's red edge stays clear.
            .overlay {
                if let edgeColor {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
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
            // Centred under the figure.
            accessory()
                .padding(.trailing, 5)
                .padding(.bottom, 2)
        }
    }
}

extension MuscleGroupCard where Accessory == EmptyView {
    init(group: MuscleGroup, state: MuscleCardState, detail: String, secondaryDetail: String? = nil,
         tone: MuscleCardTone? = nil, edgeColor: Color? = nil, action: @escaping () -> Void) {
        self.init(group: group, state: state, detail: detail, secondaryDetail: secondaryDetail,
                  tone: tone, edgeColor: edgeColor, action: action, accessory: { EmptyView() })
    }
}

struct MuscleStateLabel: View {
    var state: MuscleCardState

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: state.symbol)
                .font(.system(size: 8, weight: .semibold))
            Text(state.label)
                .font(.mono(8.5, .semibold))
                .trackingEm(0.08, size: 8.5)
        }
        .foregroundStyle(DS.silver.opacity([.ready, .partlyReady, .completedToday, .completed].contains(state) ? 0.85 : 0.5))
    }
}

/// The group lit on the existing body map, from the side it's best seen.
struct MiniBodyMap: View {
    var group: MuscleGroup
    var color: Color = DS.activation

    var body: some View {
        BodyMapCanvas(
            side: group.preferredSide,
            fills: Dictionary(group.bodyRegions.map { ($0, color) }, uniquingKeysWith: { a, _ in a }),
            lineWidth: 0.5
        )
        .accessibilityHidden(true)
    }
}
