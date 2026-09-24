//
//  FormComparisonView.swift
//  GymWorkout
//
//  Screen 1h — Correct vs Common Mistake. The switch drives the render, the
//  activation signature, the callout and the note beneath in one move.
//

import SwiftUI

struct FormComparisonView: View {
    var exercise: Exercise
    /// Supplied by the exercise's `ExerciseContent` — never global.
    var copy: FormComparisonCopy
    /// The exercise's correct-form activation signature.
    var glows: [ActivationGlowLayer.Glow]

    @Environment(\.dismiss) private var dismiss
    @State private var mode: FormMode = .correct

    private var isMistake: Bool { mode == .mistake }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                modeSwitch.padding(.top, 16)
                viewport.padding(.top, 14)
                note.padding(.top, 16)
            }
            .padding(.bottom, 30)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            CircleIconButton(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Form Comparison")
                    .font(.ui(15.5, .semibold))
                    .tracking(-0.2)
                    .foregroundStyle(DS.silver)
                MetaLine(text: exercise.name.uppercased())
                    .padding(.top, 3)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 11)
    }

    private var modeSwitch: some View {
        HStack(spacing: 4) {
            switchButton("CORRECT", .correct)
            switchButton("COMMON MISTAKE", .mistake)
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(DS.silver.opacity(0.06))
        )
        .padding(.horizontal, 18)
    }

    private func switchButton(_ title: String, _ value: FormMode) -> some View {
        let isOn = mode == value
        return Button {
            withAnimation(.easeOut(duration: 0.2)) { mode = value }
        } label: {
            Text(title)
                .font(.mono(10, .semibold))
                .trackingEm(0.10, size: 10)
                .foregroundStyle(isOn ? DS.ink : DS.silver.opacity(0.5))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isOn ? DS.silver : .clear)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Viewport

    /// A fault splits the activation into two shoulder lobes; correct form
    /// keeps the exercise's own signature.
    private var activeGlows: [ActivationGlowLayer.Glow] {
        isMistake
            ? [
                .init(DS.activation.opacity(0.5), rx: 0.15, ry: 0.09, cx: 0.32, cy: 0.31),
                .init(DS.activation.opacity(0.5), rx: 0.15, ry: 0.09, cx: 0.68, cy: 0.31)
              ]
            : glows
    }

    private var viewport: some View {
        Viewport(
            slot: "cmp-viewport",
            cy: 0.78,
            glows: activeGlows
        ) {
            badge
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(14)

            if isMistake {
                GeometryReader { geo in
                    FaultRing(diameter: 112)
                        .position(x: geo.size.width * 0.56, y: geo.size.height * 0.40)
                }
            }

            AnnotationCallout(
                text: isMistake ? copy.mistakeCue : copy.correctCue,
                borderColor: isMistake ? DS.activation.opacity(0.55) : DS.silver.opacity(0.16),
                leaderLength: 36,
                lineTint: isMistake ? DS.activation : DS.silver,
                dotColor: isMistake ? DS.activation : DS.silver,
                paddingH: 12,
                paddingV: 7,
                cornerRadius: 12,
                ringed: false
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.leading, 20)
            .padding(.bottom, 70)

            HStack(spacing: 8) {
                ZStack(alignment: .leading) {
                    Capsule().fill(DS.silver.opacity(0.14))
                    GeometryReader { geo in
                        Capsule().fill(DS.silver).frame(width: geo.size.width * 0.64)
                    }
                }
                .frame(height: 3)

                Text("BOTTOM")
                    .font(.mono(9, .medium))
                    .foregroundStyle(DS.silver.opacity(0.45))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, DS.Metric.viewportInset)
    }

    private var badge: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(isMistake ? DS.activation : DS.silver)
                .frame(width: 6, height: 6)
            Text(isMistake ? copy.mistakeBadge : copy.correctBadge)
                .font(.mono(9.5, .semibold))
                .trackingEm(0.10, size: 9.5)
                .foregroundStyle(isMistake ? DS.activationTint : DS.silver.opacity(0.75))
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isMistake ? DS.activation.opacity(0.16)
                                : DS.glass(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(isMistake ? DS.activation.opacity(0.5)
                                        : DS.silver.opacity(0.14), lineWidth: 1)
        )
    }

    // MARK: - Note

    private var note: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(
                text: isMistake ? "WHAT CHANGED" : "WHY THIS WORKS",
                size: 9.5, em: 0.11,
                color: isMistake ? DS.activationText : DS.silver.opacity(0.4)
            )
            Text(isMistake ? copy.mistakeNote : copy.correctNote)
                .font(.ui(13.5))
                .cssLineHeight(13.5, 1.5)
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(isMistake ? DS.activation.opacity(0.3)
                                        : DS.silver.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 18)
    }
}
