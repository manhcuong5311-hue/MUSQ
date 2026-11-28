//
//  FriendsComponents.swift
//  GymWorkout
//
//  Small pieces the Friends screens share (2026-11-28): the emoji avatar,
//  the big bottom button, the toast, the goal ring and the on-device
//  "nudged today" list that greys a friend's nudge button until tomorrow.
//

import SwiftUI

/// A friend's emoji on a soft round well.
struct FriendAvatar: View {
    var emoji: String
    var size: CGFloat = 44
    var highlighted = false

    var body: some View {
        Text(emoji)
            .font(.system(size: size * 0.52))
            .frame(width: size, height: size)
            .background(Circle().fill(highlighted ? DS.activation.opacity(0.18) : DS.surfaceRaised))
            .overlay(Circle().strokeBorder(highlighted ? DS.activation.opacity(0.6) : DS.silver.opacity(0.08),
                                           lineWidth: highlighted ? 2 : 1))
            .accessibilityHidden(true)
    }
}

/// The big thumb-height action at the bottom of a Friends screen.
struct FriendsPrimaryButtonStyle: ButtonStyle {
    var filled = true
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ui(17, .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .foregroundStyle(filled ? DS.ink : DS.silver)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(filled ? DS.silver : DS.silver.opacity(0.08)))
            .opacity(isEnabled ? (configuration.isPressed ? 0.8 : 1) : 0.4)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// A thin ring for a goal percentage (0–100).
struct FriendGoalRing: View {
    var pct: Int
    var size: CGFloat = 30

    var body: some View {
        ZStack {
            Circle().stroke(DS.silver.opacity(0.12), lineWidth: 3.5)
            Circle()
                .trim(from: 0, to: CGFloat(min(max(pct, 0), 100)) / 100)
                .stroke(DS.rhythmDue, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(pct)")
                .font(.ui(size * 0.32, .bold))
                .foregroundStyle(DS.silver)
                .monospacedDigit()
        }
        .frame(width: size, height: size)
        .accessibilityElement()
        .accessibilityLabel(String(localized: "Goal \(pct) percent", comment: "VoiceOver, a friend's goal progress"))
    }
}

/// A short message that floats over the bottom bar and goes by itself.
struct FriendsToast: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.ui(15, .semibold))
            .foregroundStyle(DS.ink)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(Capsule().fill(DS.silver))
            .shadow(color: .black.opacity(0.18), radius: 12, y: 4)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

/// A friend picked for the detail sheet; the sheet reads the live friend
/// from the service by id, so it follows a mute or a refresh.
struct FriendRef: Identifiable, Hashable {
    let id: String
}

/// The friends nudged today, kept on this device so a button can say
/// "Nudged today" before the server has to refuse it (one a day per friend).
/// "Today" is the server's day, in UTC (nudgeCheck resets at UTC midnight,
/// 07:00 in Vietnam), so the button frees up exactly when the server does.
enum NudgedToday {
    private static let key = "friends.nudgedToday"

    private static var today: String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.timeZone = TimeZone(identifier: "UTC")
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: .now)
    }

    static func ids() -> Set<String> {
        guard let stored = UserDefaults.standard.dictionary(forKey: key),
              stored["day"] as? String == today,
              let ids = stored["ids"] as? [String] else { return [] }
        return Set(ids)
    }

    static func add(_ id: String) {
        var set = ids()
        set.insert(id)
        UserDefaults.standard.set(["day": today, "ids": Array(set)], forKey: key)
    }
}

extension View {
    /// Centres a Friends page and keeps it to a readable width on iPad.
    func friendsColumn() -> some View {
        frame(maxWidth: 640).frame(maxWidth: .infinity)
    }
}

/// The screen's line for a failed Friends call.
func friendsMessage(_ error: Error) -> String {
    (error as? FriendsError)?.message ?? String(localized: "Friends can't be reached right now.", comment: "Friends error")
}
