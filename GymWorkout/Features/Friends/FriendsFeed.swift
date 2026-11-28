//
//  FriendsFeed.swift
//  GymWorkout
//
//  The Friends feed (2026-11-28): one card per summarised event, newest
//  first, with the fixed reaction bar. Pages of 30 from the server.
//

import SwiftUI

struct FriendsFeed: View {
    private var service: FriendsService { .shared }

    var body: some View {
        LazyVStack(spacing: 10) {
            if service.feed.isEmpty && !service.feedLoaded {
                // The first page (and the post before it) is on its way.
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 48)
            } else if service.feed.isEmpty {
                VStack(spacing: 8) {
                    Text("📭").font(.system(size: 40))
                    Text("Nothing here yet")
                        .font(.ui(17, .semibold))
                        .foregroundStyle(DS.silver)
                    Text("Workouts, water and streaks from you and your friends show up here.")
                        .font(.ui(14))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 36)
            }
            ForEach(service.feed, id: \.id) { item in
                FeedCard(item: item)
                    .onAppear {
                        if item.id == service.feed.last?.id, service.feedHasMore {
                            Task { await service.loadFeed(reset: false) }
                        }
                    }
            }
            if service.feedHasMore && !service.feed.isEmpty {
                ProgressView().padding(.vertical, 14)
            }
        }
    }
}

struct FeedCard: View {
    var item: FriendFeedItem

    private var service: FriendsService { .shared }
    @Environment(\.colorScheme) private var scheme
    static let reactions = FriendsCatalog.reactions

    private var isMe: Bool { item.friendId == "me" }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                FriendAvatar(emoji: item.emoji, size: 42, highlighted: isMe)
                VStack(alignment: .leading, spacing: 4) {
                    Text(headline)
                        .font(.ui(16, .semibold))
                        .foregroundStyle(DS.silver)
                        .fixedSize(horizontal: false, vertical: true)
                    if let detail {
                        Text(detail)
                            .font(.ui(14, .medium))
                            .foregroundStyle(DS.silver.opacity(0.6))
                    }
                    if let date = item.createdDate {
                        Text(date, format: .relative(presentation: .named))
                            .font(.ui(12.5))
                            .foregroundStyle(DS.silver.opacity(0.45))
                    }
                }
                Spacer(minLength: 0)
                Text(badge).font(.system(size: 22)).accessibilityHidden(true)
            }
            HStack(spacing: 8) {
                ForEach(Self.reactions, id: \.self) { e in
                    reactionButton(e)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface)
            .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.05), radius: 10, y: 3))
    }

    private func reactionButton(_ e: String) -> some View {
        let count = item.reactions[e] ?? 0
        let mine = item.myReaction == e
        return Button {
            Task { try? await service.react(item, emoji: mine ? nil : e) }
        } label: {
            HStack(spacing: 4) {
                Text(e).font(.system(size: 16))
                if count > 0 {
                    Text("\(count)")
                        .font(.ui(13, .bold))
                        .monospacedDigit()
                        .foregroundStyle(mine ? DS.activationText : DS.silver.opacity(0.7))
                }
            }
            .padding(.horizontal, 10)
            .frame(height: 34)
            .background(Capsule().fill(mine ? DS.activation.opacity(0.16) : DS.silver.opacity(0.06)))
            .overlay(Capsule().strokeBorder(mine ? DS.activation.opacity(0.7) : .clear, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: mine)
        .accessibilityLabel(String(localized: "React \(e), \(count)", comment: "VoiceOver, a reaction button and its count"))
        .accessibilityAddTraits(mine ? .isSelected : [])
    }

    private var name: String { isMe ? String(localized: "You") : item.displayName }

    private var headline: String {
        let d = item.data
        switch item.eventKind {
        case .workout:
            if let title = workoutTitle {
                return String(localized: "\(name) finished \(title)", comment: "Feed: Minh finished Push Day")
            }
            return String(localized: "\(name) finished a workout", comment: "Feed, workout with no title")
        case .water:
            return String(localized: "\(name) hit the water goal", comment: "Feed")
        case .meals:
            let n = d.count ?? 0
            return n == 1 ? String(localized: "\(name) logged 1 meal", comment: "Feed")
                : String(localized: "\(name) logged \(n) meals", comment: "Feed")
        case .streak:
            let n = d.days ?? 0
            return String(localized: "\(name) is on a \(n)-day streak", comment: "Feed")
        case .pr:
            let ex = d.exercise ?? String(localized: "a lift")
            return String(localized: "\(name) set a PR on \(ex)", comment: "Feed: Lan set a PR on Bench Press")
        case nil:
            return name
        }
    }

    /// The groups in this reader's language when the keys came along,
    /// else the poster's English title.
    private var workoutTitle: String? {
        let groups = (item.data.groups ?? []).compactMap { MuscleGroup(rawValue: $0)?.title }
        if !groups.isEmpty { return groups.formatted(.list(type: .and)) }
        if let title = item.data.title, !title.isEmpty { return title }
        return nil
    }

    private var detail: String? {
        let d = item.data
        switch item.eventKind {
        case .workout:
            var parts: [String] = []
            if let m = d.minutes { parts.append(String(localized: "\(m) min", comment: "Feed, workout length")) }
            if let s = d.sets { parts.append(s == 1 ? String(localized: "1 set") : String(localized: "\(s) sets", comment: "Feed, sets in a workout")) }
            return parts.isEmpty ? nil : parts.joined(separator: " · ")
        case .pr:
            guard let kg = d.kg else { return nil }
            return String(localized: "\(kg.formatted(.number.precision(.fractionLength(0...1)))) kg", comment: "Feed, a PR weight")
        default:
            return nil
        }
    }

    private var badge: String {
        switch item.eventKind {
        case .workout: return "🏋️"
        case .water: return "💧"
        case .meals: return "🍽️"
        case .streak: return "🔥"
        case .pr: return "🏆"
        case nil: return "✨"
        }
    }
}

/// Grey cards while the first load runs.
struct FriendsLoadingPlaceholder: View {
    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { _ in
                HStack(spacing: 12) {
                    Circle().fill(DS.silver.opacity(0.1)).frame(width: 42, height: 42)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Someone finished a workout").font(.ui(16, .semibold))
                        Text("52 min · 18 sets").font(.ui(14))
                    }
                    Spacer()
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface))
            }
        }
        .redacted(reason: .placeholder)
        .accessibilityLabel(String(localized: "Loading"))
    }
}
