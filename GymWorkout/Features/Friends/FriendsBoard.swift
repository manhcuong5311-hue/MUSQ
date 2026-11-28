//
//  FriendsBoard.swift
//  GymWorkout
//
//  This week's board (2026-11-28): me and my friends ranked by workouts
//  this week, then streak. Each friend row carries the one-tap nudge.
//

import SwiftUI

struct FriendsBoard: View {
    var nudged: Set<String>
    var onNudge: (Friend, FriendNudgeKind) -> Void
    var onOpen: (Friend) -> Void
    /// Opens the viewer on a friend's (or my) photo of the last 24 h.
    var onStory: ((FriendPhotoStory) -> Void)? = nil

    private var service: FriendsService { .shared }

    var body: some View {
        VStack(spacing: 8) {
            ForEach(Array(service.board.enumerated()), id: \.element.id) { index, row in
                if row.isMe {
                    FriendRow(rank: index + 1, emoji: row.emoji, name: String(localized: "You"),
                              week: row.week, isMe: true,
                              story: FriendsPhotoRing.story(friendId: nil, isMe: true),
                              onStory: onStory)
                } else if let f = service.friend(row.id) {
                    FriendRow(rank: index + 1, emoji: f.emoji, name: f.displayName, week: f.week, isMe: false,
                              nudgedToday: nudged.contains(f.id),
                              onNudge: { kind in onNudge(f, kind) },
                              onOpen: { onOpen(f) },
                              story: FriendsPhotoRing.story(friendId: f.id, isMe: false),
                              onStory: onStory)
                }
            }
            Text("Week runs Monday to Sunday.")
                .font(.ui(12.5))
                .foregroundStyle(DS.silver.opacity(0.4))
                .padding(.top, 6)
        }
    }
}

struct FriendRow: View {
    var rank: Int
    var emoji: String
    var name: String
    var week: FriendWeek
    var isMe: Bool
    var nudgedToday = false
    var onNudge: ((FriendNudgeKind) -> Void)? = nil
    var onOpen: (() -> Void)? = nil
    /// A photo from the last 24 h: the avatar gets its ring and opens it.
    var story: FriendPhotoStory? = nil
    var onStory: ((FriendPhotoStory) -> Void)? = nil

    static let kinds = FriendNudgeKind.allCases

    var body: some View {
        HStack(spacing: 12) {
            Text(rank <= 3 ? ["🥇", "🥈", "🥉"][rank - 1] : "\(rank)")
                .font(rank <= 3 ? .system(size: 20) : .ui(15, .bold))
                .foregroundStyle(DS.silver.opacity(0.5))
                .frame(width: 28)
            avatar
            Button {
                onOpen?()
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(name)
                            .font(.ui(16, .semibold))
                            .foregroundStyle(DS.silver)
                            .lineLimit(1)
                        HStack(spacing: 10) {
                            Text(week.workouts == 1 ? String(localized: "1 workout")
                                 : String(localized: "\(week.workouts) workouts", comment: "Weekly board, workouts this week"))
                            if week.streak > 0 {
                                Text("🔥 \(week.streak)")
                                    .accessibilityLabel(String(localized: "\(week.streak)-day streak"))
                            }
                        }
                        .font(.ui(13.5, .medium))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .monospacedDigit()
                    }
                    Spacer(minLength: 4)
                    if let pct = week.goalPct {
                        FriendGoalRing(pct: pct)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(onOpen == nil)

            if let onNudge {
                nudgeButton(onNudge)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(isMe ? DS.activation.opacity(0.08) : DS.surface))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .strokeBorder(isMe ? DS.activation.opacity(0.35) : .clear, lineWidth: 1.5))
    }

    /// The avatar, ringed and tappable while there's a fresh photo.
    @ViewBuilder private var avatar: some View {
        if let story, let onStory {
            Button { onStory(story) } label: {
                FriendPhotoStoryAvatar(emoji: emoji, size: 44, story: story, highlighted: isMe)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isMe ? String(localized: "Your photo", comment: "VoiceOver, my story in the stories row")
                                : String(localized: "Photo from \(name)", comment: "VoiceOver, a friend's photo"))
        } else {
            FriendAvatar(emoji: emoji, size: 44, highlighted: isMe)
        }
    }

    /// Tap = "Time to train!"; hold = the four templates.
    private func nudgeButton(_ send: @escaping (FriendNudgeKind) -> Void) -> some View {
        Menu {
            ForEach(Self.kinds, id: \.self) { kind in
                Button(kind.message) { send(kind) }
            }
        } label: {
            VStack(spacing: 2) {
                Text(nudgedToday ? "✅" : "👋").font(.system(size: 22))
                if nudgedToday {
                    Text("Nudged today")
                        .font(.ui(10, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            .frame(width: 64, height: 52)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(nudgedToday ? DS.silver.opacity(0.05) : DS.activation.opacity(0.14)))
        } primaryAction: {
            send(.train)
        }
        .disabled(nudgedToday)
        .accessibilityLabel(nudgedToday ? String(localized: "Nudged today")
                            : String(localized: "Nudge \(name)", comment: "VoiceOver, the nudge button on a friend's row"))
        .accessibilityHint(String(localized: "Sends \"Time to train!\". Touch and hold for more."))
    }
}
