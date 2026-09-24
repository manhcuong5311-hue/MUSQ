//
//  SetupDrawer.swift
//  GymWorkout
//
//  How to get into position for the exercise. Rests as a slim bar at the
//  bottom of the trainer; swipe it up (or tap it) to read the steps, swipe it
//  back down to put it away. It sits outside the viewport, so while it rests
//  the model and its cues are never covered.
//

import SwiftUI

struct SetupDrawer: View {
    var steps: [String]
    @Binding var isExpanded: Bool
    /// A control on the right of the bar, e.g. "Add to Today". Sits over the
    /// bar rather than inside its button, so its taps stay its own.
    var accessory: AnyView? = nil

    /// Height of the bar the drawer rests as. The viewport leaves exactly
    /// this much room below itself.
    static let peekHeight: CGFloat = 60

    @State private var dragOffset: CGFloat = 0
    @State private var fullHeight: CGFloat = 0

    /// How far the drawer drops when put away: everything but the bar.
    private var travel: CGFloat { max(fullHeight - Self.peekHeight, 0) }

    private var offset: CGFloat {
        let base = isExpanded ? 0 : travel
        return min(max(base + dragOffset, 0), travel)
    }

    /// 0 at rest, 1 fully open — drives the steps' fade and the chevron.
    private var progress: CGFloat {
        travel > 0 ? 1 - offset / travel : (isExpanded ? 1 : 0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            bar
            stepList
                .opacity(progress)
        }
        .padding(.horizontal, DS.Metric.gutter)
        .frame(maxWidth: .infinity)
        .background(alignment: .top) {
            PanelGround(radius: DS.Metric.sheetRadius, border: DS.silver.opacity(0.11))
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { fullHeight = $0 }
        .offset(y: offset)
        .gesture(drag)
        .accessibilityElement(children: .contain)
    }

    // MARK: - Bar

    private var bar: some View {
        Button(action: toggle) {
            VStack(spacing: 0) {
                Capsule()
                    .fill(DS.silver.opacity(0.22))
                    .frame(width: 38, height: 4)
                    .padding(.top, 10)

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("Setup")
                        .font(.ui(15, .semibold))
                        .tracking(-0.2)
                        .foregroundStyle(DS.silver)
                    MetaLine(text: steps.count == 1 ? "1 STEP" : "\(steps.count) STEPS")
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.up")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .rotationEffect(.degrees(180 * progress))
                }
                .padding(.top, 12)
                .overlay(alignment: .trailing) {
                    if let accessory {
                        accessory.padding(.trailing, 26)
                    }
                }

                Spacer(minLength: 0)
            }
            .frame(height: Self.peekHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Setup, \(steps.count) steps")
        .accessibilityHint(isExpanded ? "Hides the setup steps" : "Shows the setup steps")
    }

    // MARK: - Steps

    private var stepList: some View {
        VStack(alignment: .leading, spacing: 13) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(String(format: "%02d", index + 1))
                        .font(.mono(10, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.4))
                    Text(step)
                        .font(.ui(14))
                        .cssLineHeight(14, 1.45)
                        .foregroundStyle(DS.silver.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .combine)
            }
        }
        .padding(.top, 2)
        .padding(.bottom, 22)
        .accessibilityHidden(!isExpanded)
    }

    // MARK: - Interaction

    private var drag: some Gesture {
        DragGesture(minimumDistance: 6)
            .onChanged { dragOffset = $0.translation.height }
            .onEnded { value in
                let base = isExpanded ? 0 : travel
                let landing = base + value.predictedEndTranslation.height
                withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                    isExpanded = landing < travel / 2
                    dragOffset = 0
                }
            }
    }

    private func toggle() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
            isExpanded.toggle()
        }
    }
}
