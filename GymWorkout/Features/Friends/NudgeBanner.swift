//
//  NudgeBanner.swift
//  GymWorkout
//
//  The banner at the top of Friends when a nudge came in (2026-11-28):
//  "🔥 Lan: Time to train!" with Nudge back. The server marks nudges
//  delivered when the app fetches them; this only shows them.
//

import SwiftUI

struct NudgeBanner: View {
    var nudge: FriendNudge
    /// Nil when the sender isn't a friend any more (no Nudge back then).
    var onNudgeBack: (() -> Void)?
    var nudgedBack: Bool
    var onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            FriendAvatar(emoji: nudge.fromEmoji, size: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(nudge.fromName)
                    .font(.ui(14, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .lineLimit(1)
                Text(nudge.kind.message)
                    .font(.ui(16, .bold))
                    .foregroundStyle(DS.silver)
                    .lineLimit(2)
            }
            Spacer(minLength: 4)
            if let onNudgeBack {
                Button(action: onNudgeBack) {
                    Text(nudgedBack ? LocalizedStringKey("Sent") : LocalizedStringKey("Nudge back"))
                        .font(.ui(14, .bold))
                        .foregroundStyle(nudgedBack ? DS.silver.opacity(0.5) : DS.ink)
                        .padding(.horizontal, 14)
                        .frame(height: 38)
                        .background(Capsule().fill(nudgedBack ? DS.silver.opacity(0.08) : DS.silver))
                }
                .buttonStyle(.plain)
                .disabled(nudgedBack)
            }
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(String(localized: "Dismiss"))
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(LinearGradient(colors: [DS.activation.opacity(0.22), DS.activationSoft.opacity(0.10)],
                                 startPoint: .leading, endPoint: .trailing))
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface)))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .strokeBorder(DS.activation.opacity(0.35), lineWidth: 1))
        .transition(.move(edge: .top).combined(with: .opacity))
        .accessibilityElement(children: .contain)
    }
}
