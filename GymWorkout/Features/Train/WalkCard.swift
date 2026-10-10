//
//  WalkCard.swift
//  GymWorkout
//
//  After a weight-loss workout is completed: how far to walk today, and a
//  way to tick it off.
//

import SwiftUI

struct WalkCard: View {
    var walk: WalkSuggestion
    var isDone: Bool
    var onDone: (Bool) -> Void

    @Environment(\.dsLayout) private var layout

    /// An iPad column wide enough that a full-width button would only
    /// stretch; inside the narrow Today pane the phone's layout fits.
    private var isRoomy: Bool { layout.isRegular && layout.containerWidth >= DS.Layout.formWidth }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isDone ? "checkmark" : "figure.walk")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(isDone ? DS.ink : DS.silver)
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(isDone ? DS.silver : DS.silver.opacity(0.08))
                    )
                VStack(alignment: .leading, spacing: 4) {
                    SectionEyebrow(text: isDone ? "WALK DONE" : "NEXT · WALK", size: 9.5)
                    Text("\(walk.steps.formatted()) steps")
                        .font(.ui(20, .semibold))
                        .tracking(-0.4)
                        .foregroundStyle(DS.silver)
                    Text(walk.detail)
                        .font(.mono(11, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                }
                Spacer(minLength: 0)
            }

            if !isDone {
                let size: CGFloat = layout.isRegular ? 13.5 : 12.5
                Text("An easy-paced walk today keeps your weight-loss progress moving. Aim for \(WalkSuggestion.dailySteps.formatted())+ steps across the whole day.")
                    .font(.ui(size))
                    .cssLineHeight(size, 1.45)
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                    .dsReadable(480, alignment: .leading)
            }

            WideButton(title: isDone ? "Undo" : "I've Done My Walk", prominent: !isDone,
                       fontSize: 13, verticalPadding: 10, cornerRadius: 11) {
                onDone(!isDone)
            }
            .frame(width: isRoomy ? 220 : nil)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surfaceAlt))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1)
        )
    }
}
