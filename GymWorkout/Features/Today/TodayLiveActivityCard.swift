//
//  TodayLiveActivityCard.swift
//  GymWorkout
//
//  A one-time suggestion on Today (2026-11-28): put the day on the Lock
//  Screen and in the Dynamic Island. "Turn on" switches the Today Live
//  Activity on (Profile › Preferences keeps the switch); the cross closes the
//  card for good. iPhone only, and only while Live Activities are allowed.
//

import SwiftUI

struct TodayLiveActivityCard: View {
    @AppStorage(LiveActivitySettings.todayKey) private var todayActivityOn = false
    @AppStorage(LiveActivitySettings.suggestionDismissedKey) private var dismissed = false
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        if !todayActivityOn && !dismissed && LiveActivitySettings.isSupportedDevice
            && LiveActivitySettings.areActivitiesEnabled {
            card
                .padding(.top, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }

    private var card: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Capsule().fill(Color.black)
                    .frame(width: 38, height: 16)
                Circle().trim(from: 0, to: 0.62)
                    .stroke(TodayTone.workout, style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 10, height: 10)
                    .offset(x: 10)
            }
            .frame(width: 40, height: 40)
            .background(Circle().fill(TodayTone.workout.opacity(0.14)))
            .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("Your day on the Lock Screen", comment: "Today: suggestion card title for the Today Live Activity")
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                Text("Water, calories and your next workout in the Dynamic Island, with a +250 ml button.",
                     comment: "Today: suggestion card text for the Today Live Activity")
                    .font(.ui(12.5, .medium))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 4)
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    todayActivityOn = true
                    dismissed = true
                }
                LiveActivityManager.shared.todaySettingChanged()
            } label: {
                Text("Turn on", comment: "Today: turns on the Today Live Activity")
                    .font(.ui(13, .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(TodayTone.workout))
            }
            .buttonStyle(.plain)
            Button {
                withAnimation(.easeOut(duration: 0.2)) { dismissed = true }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .frame(width: 32, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(String(localized: "Don't show again", comment: "Closes a Today note for good"))
        }
        .padding(.leading, 12)
        .padding(.trailing, 4)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
            .strokeBorder(DS.silver.opacity(scheme == .dark ? 0.08 : 0.04), lineWidth: 1))
    }
}
