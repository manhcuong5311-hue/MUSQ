//
//  FriendsPhotoComponents.swift
//  GymWorkout
//
//  Pieces the Friends photo check-ins share (2026-11-28): the avatar with
//  a 24 h story ring, the reaction bar of a photo, the bottom camera buttons, the requests
//  that open the viewer and the post detail, and the error line.
//  Photos are only ever shown to friends; nothing here reads Apple Health.
//

import SwiftUI

// MARK: - Story ring

/// The 24 h ring: who has a fresh photo, and the row's order.
enum FriendsPhotoRing {
    static func isFresh(_ story: FriendPhotoStory?) -> Bool {
        story?.posts.contains { $0.isStory() && !$0.hidden } ?? false
    }

    /// The fresh story of a friend (opaque friend id), or mine.
    @MainActor static func story(friendId: String?, isMe: Bool) -> FriendPhotoStory? {
        let s = FriendsPhotoService.shared.stories.first {
            isMe ? $0.isMine : (!$0.isMine && $0.authorId == friendId)
        }
        return isFresh(s) ? s : nil
    }

    /// The row's order: mine first, then friends not seen yet, newest first.
    @MainActor static func ordered() -> [FriendPhotoStory] {
        let fresh = FriendsPhotoService.shared.stories.filter { isFresh($0) }
        let mine = fresh.filter(\.isMine)
        let others = fresh.filter { !$0.isMine }.sorted {
            if $0.hasUnseen != $1.hasUnseen { return $0.hasUnseen }
            return ($0.latest?.createdDate ?? .distantPast) > ($1.latest?.createdDate ?? .distantPast)
        }
        return mine + others
    }

    static let gradient = AngularGradient(
        colors: [DS.activation, DS.activationSoft, Color(hex: 0xFFC61A), Color(hex: 0xFF3D7F), DS.activation],
        center: .center)
}

/// The emoji avatar, with a gradient ring while its owner has a photo not
/// seen yet and a grey one once seen (24 h after the photo, no ring).
struct FriendPhotoStoryAvatar: View {
    var emoji: String
    var size: CGFloat = 44
    var story: FriendPhotoStory?
    var highlighted = false

    private var ringWidth: CGFloat { max(2, size * 0.06) }

    var body: some View {
        if let story, FriendsPhotoRing.isFresh(story) {
            FriendAvatar(emoji: emoji, size: size - ringWidth * 2 - 4, highlighted: highlighted)
                .padding(ringWidth + 2)
                .overlay {
                    if story.hasUnseen && !story.isMine {
                        Circle().strokeBorder(FriendsPhotoRing.gradient, lineWidth: ringWidth)
                    } else if story.isMine {
                        Circle().strokeBorder(FriendsPhotoRing.gradient.opacity(0.85), lineWidth: ringWidth)
                    } else {
                        Circle().strokeBorder(DS.silver.opacity(0.22), lineWidth: ringWidth)
                    }
                }
                .frame(width: size, height: size)
        } else {
            FriendAvatar(emoji: emoji, size: size, highlighted: highlighted)
        }
    }
}

// MARK: - Reactions

/// 🔥 💪 👏 ❤️ under a photo, one per person, toggled.
struct FriendsPhotoReactionBar: View {
    var post: FriendPhotoPost
    var compact = false
    var onError: (String) -> Void = { _ in }

    var body: some View {
        HStack(spacing: compact ? 6 : 8) {
            ForEach(FriendsCatalog.reactions, id: \.self) { e in
                button(e)
            }
        }
    }

    private func button(_ e: String) -> some View {
        let count = post.reactions[e] ?? 0
        let mine = post.myReaction == e
        return Button {
            Task {
                do { try await FriendsPhotoService.shared.react(post, emoji: mine ? nil : e) }
                catch { onError(friendsPhotoMessage(error)) }
            }
        } label: {
            HStack(spacing: 4) {
                Text(e).font(.system(size: compact ? 15 : 16))
                if count > 0 {
                    Text("\(count)")
                        .font(.ui(13, .bold))
                        .monospacedDigit()
                        .foregroundStyle(mine ? DS.activationText : DS.silver.opacity(0.7))
                }
            }
            .padding(.horizontal, compact ? 8 : 10)
            .frame(height: compact ? 30 : 34)
            .background(Capsule().fill(mine ? DS.activation.opacity(0.16) : DS.silver.opacity(0.06)))
            .overlay(Capsule().strokeBorder(mine ? DS.activation.opacity(0.7) : .clear, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: mine)
        .accessibilityLabel(String(localized: "React \(e), \(count)", comment: "VoiceOver, a reaction button and its count"))
        .accessibilityAddTraits(mine ? .isSelected : [])
    }
}

/// "💬 3": opens the post with its comments.
struct FriendsPhotoCommentButton: View {
    var count: Int
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                StyledSymbol(name: "bubble.left.fill", size: 14)
                if count > 0 {
                    Text("\(count)").font(.ui(13.5, .bold)).monospacedDigit()
                }
            }
            .foregroundStyle(DS.silver.opacity(0.75))
            .padding(.horizontal, 12)
            .frame(height: 34)
            .background(Capsule().fill(DS.silver.opacity(0.06)))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(count == 1 ? String(localized: "1 comment")
                            : String(localized: "\(count) comments", comment: "VoiceOver, comments on a friend's photo"))
    }
}

/// The workout tag on a photo: "Chest day · 25 min".
struct FriendsPhotoTagChip: View {
    var text: String
    var onRemove: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 6) {
            Text("🏋️").font(.system(size: 13))
            Text(text)
                .font(.ui(13, .semibold))
                .foregroundStyle(DS.silver.opacity(0.8))
                .lineLimit(1)
            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .frame(width: 22, height: 22)
                        .background(Circle().fill(DS.silver.opacity(0.1)))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(localized: "Remove workout tag"))
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, onRemove == nil ? 10 : 4)
        .frame(height: 30)
        .background(Capsule().fill(DS.silver.opacity(0.07)))
    }
}

// MARK: - Camera button

/// The vivid thumb-height "Share a photo" button.
struct FriendsCameraButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ui(17, .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .foregroundStyle(.white)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(LinearGradient(colors: [DS.activationSoft, DS.activation],
                                     startPoint: .topLeading, endPoint: .bottomTrailing)))
            .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1) : 0.4)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Camera (big) and library (small square), side by side.
struct FriendsPhotoBottomButtons: View {
    var onCamera: () -> Void
    var onLibrary: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onCamera) {
                HStack(spacing: 8) {
                    StyledSymbol(name: "camera.fill", size: 17)
                    Text("Share a photo")
                }
            }
            .buttonStyle(FriendsCameraButtonStyle())
            Button(action: onLibrary) {
                StyledSymbol(name: "photo.on.rectangle", size: 18)
                    .foregroundStyle(DS.silver)
                    .frame(width: 54, height: 54)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.silver.opacity(0.08)))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(String(localized: "Choose from library"))
        }
    }
}

// MARK: - Requests

/// What the full-screen viewer walks through: each person's photos of the
/// last 24 h, story after story, starting at one of them.
struct FriendsPhotoViewerRequest: Identifiable {
    let id = UUID()
    var stories: [FriendPhotoStory]
    var start: Int
}

/// A post opened with its comments. Holds a copy so the sheet still has
/// something to show if the post goes away while it's open.
struct FriendsPhotoDetailRequest: Identifiable {
    var id: String { post.id }
    var post: FriendPhotoPost
}

/// Where a new photo comes from.
enum FriendsPhotoSource: Identifiable {
    case camera, library
    var id: Self { self }
}

/// The screen's line for a failed photo call.
@MainActor func friendsPhotoMessage(_ error: Error) -> String {
    if let e = error as? FriendsPhotoError { return e.message }
    if let e = error as? FriendsError { return e.message }
    return String(localized: "Friends can't be reached right now.", comment: "Friends error")
}
