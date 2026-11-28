//
//  FriendsPhotoStories.swift
//  GymWorkout
//
//  The stories row at the top of the Friends feed (2026-11-28): me first
//  with a + to post, then each friend with a photo in the last 24 h,
//  a gradient ring until seen, grey after. Tap = full-screen viewer.
//

import SwiftUI

struct FriendsPhotoStories: View {
    var myEmoji: String
    var onPost: () -> Void
    var onOpen: ([FriendPhotoStory], Int) -> Void

    private var photos: FriendsPhotoService { .shared }

    var body: some View {
        let stories = FriendsPhotoRing.ordered()
        let mine = stories.first(where: \.isMine)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 14) {
                meTile(mine, all: stories)
                ForEach(Array(stories.enumerated()), id: \.element.authorId) { index, story in
                    if !story.isMine {
                        tile(story) { onOpen(stories, index) }
                    }
                }
            }
            .padding(.vertical, 2)
            .padding(.horizontal, DS.Metric.gutter)
        }
        .padding(.horizontal, -DS.Metric.gutter)
        .scrollClipDisabled()
    }

    private func meTile(_ mine: FriendPhotoStory?, all: [FriendPhotoStory]) -> some View {
        VStack(spacing: 6) {
            Button {
                if let mine, let i = all.firstIndex(where: { $0.authorId == mine.authorId && $0.isMine }) {
                    onOpen(all, i)
                } else {
                    onPost()
                }
            } label: {
                FriendPhotoStoryAvatar(emoji: myEmoji, size: 64, story: mine, highlighted: mine == nil)
            }
            .buttonStyle(.plain)
            .overlay(alignment: .bottomTrailing) {
                Button(action: onPost) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(Circle().fill(DS.activation))
                        .overlay(Circle().strokeBorder(DS.ink, lineWidth: 2.5))
                }
                .buttonStyle(.plain)
                .offset(x: 2, y: 2)
                .accessibilityLabel(String(localized: "Share a photo"))
            }
            .accessibilityLabel(mine == nil ? String(localized: "Share a photo")
                                : String(localized: "Your photo", comment: "VoiceOver, my story in the stories row"))
            Text("You")
                .font(.ui(12, .semibold))
                .foregroundStyle(DS.silver.opacity(0.7))
        }
        .frame(width: 70)
    }

    private func tile(_ story: FriendPhotoStory, open: @escaping () -> Void) -> some View {
        Button(action: open) {
            VStack(spacing: 6) {
                FriendPhotoStoryAvatar(emoji: story.emoji, size: 64, story: story)
                Text(story.displayName)
                    .font(.ui(12, story.hasUnseen ? .bold : .medium))
                    .foregroundStyle(DS.silver.opacity(story.hasUnseen ? 0.95 : 0.55))
                    .lineLimit(1)
            }
            .frame(width: 70)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(story.hasUnseen
            ? String(localized: "New photo from \(story.displayName)", comment: "VoiceOver, a story not seen yet")
            : String(localized: "Photo from \(story.displayName)", comment: "VoiceOver, a friend's photo"))
    }
}
