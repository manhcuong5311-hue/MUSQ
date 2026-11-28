//
//  FriendsPhotoFeed.swift
//  GymWorkout
//
//  The Friends feed with photo check-ins (2026-11-28): the stories row,
//  then photo cards and the activity cards (FeedCard) mixed newest first.
//  Photos arrive live from FriendsPhotoService's listener; activity
//  events still page in 30 at a time from FriendsService.
//

import SwiftUI

struct FriendsPhotoFeed: View {
    var myEmoji: String
    var onPost: () -> Void
    var onOpenStory: ([FriendPhotoStory], Int) -> Void
    var onOpenPost: (FriendPhotoPost) -> Void
    var onToast: (String) -> Void

    private var service: FriendsService { .shared }
    private var photos: FriendsPhotoService { .shared }

    private enum Entry: Identifiable {
        case photo(FriendPhotoPost)
        case event(FriendFeedItem)

        var id: String {
            switch self {
            case .photo(let p): return "p-" + p.id
            case .event(let e): return "e-" + e.id
            }
        }

        var date: Date {
            switch self {
            case .photo(let p): return p.createdDate ?? .distantPast
            case .event(let e): return e.createdDate ?? .distantPast
            }
        }
    }

    /// Photos and events by time. While older events are still to page in,
    /// photos older than the last loaded event wait, so they don't sit at
    /// the bottom above events that come later.
    private var entries: [Entry] {
        let now = Date.now
        // The member's own post hidden after reports stays, marked.
        var posts = photos.posts.filter { (!$0.hidden || $0.isMine) && !$0.isExpired(now: now) }
        if service.feedHasMore, let oldest = service.feed.compactMap(\.createdDate).min() {
            posts = posts.filter { ($0.createdDate ?? .distantPast) >= oldest }
        }
        let all = posts.map(Entry.photo) + service.feed.map(Entry.event)
        return all.sorted { $0.date > $1.date }
    }

    var body: some View {
        let entries = entries
        LazyVStack(spacing: 12) {
            FriendsPhotoStories(myEmoji: myEmoji, onPost: onPost, onOpen: onOpenStory)
                .padding(.bottom, 2)

            if entries.isEmpty && !service.feedLoaded {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 48)
            } else if entries.isEmpty {
                emptyState
            }
            ForEach(entries) { entry in
                switch entry {
                case .photo(let post):
                    FriendsPhotoCard(post: post,
                                     onOpen: { onOpenPost(post) },
                                     onToast: onToast)
                case .event(let item):
                    FeedCard(item: item)
                        .onAppear {
                            if item.id == service.feed.last?.id, service.feedHasMore {
                                Task { await service.loadFeed(reset: false) }
                            }
                        }
                }
            }
            if service.feedHasMore && !service.feed.isEmpty {
                ProgressView().padding(.vertical, 14)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Text("📸").font(.system(size: 40))
            Text("Nothing here yet")
                .font(.ui(17, .semibold))
                .foregroundStyle(DS.silver)
            Text("Share a gym photo. Your friends' photos and workouts show up here.")
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
    }
}

/// A photo check-in in the feed: big photo with the name over it, the
/// caption and tag under it, reactions and the comment count.
struct FriendsPhotoCard: View {
    var post: FriendPhotoPost
    var onOpen: () -> Void
    var onToast: (String) -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: onOpen) {
                Color.clear
                    .aspectRatio(4 / 5, contentMode: .fit)
                    .overlay { FriendPhotoAsyncImage(post: post) }
                    .clipped()
                    .overlay(alignment: .top) { header }
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityHint(String(localized: "Opens the photo and its comments"))

            if post.caption?.isEmpty == false || post.tag?.isEmpty == false {
                VStack(alignment: .leading, spacing: 8) {
                    if let caption = post.caption, !caption.isEmpty {
                        Text(caption)
                            .font(.ui(15.5, .medium))
                            .foregroundStyle(DS.silver)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if let tag = post.tag, !tag.isEmpty {
                        FriendsPhotoTagChip(text: tag)
                    }
                }
                .padding(.horizontal, 4)
            }

            if post.hidden {
                Label(String(localized: "Hidden after reports. Only you can see it."), systemImage: "eye.slash.fill")
                    .font(.ui(13, .semibold))
                    .foregroundStyle(DS.rhythmWaiting)
                    .padding(.horizontal, 4)
            } else {
                HStack(spacing: 8) {
                    FriendsPhotoReactionBar(post: post, compact: true, onError: onToast)
                    Spacer(minLength: 0)
                    FriendsPhotoCommentButton(count: post.commentCount, action: onOpen)
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(DS.surface)
            .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.05), radius: 10, y: 3))
    }

    private var header: some View {
        HStack(spacing: 10) {
            FriendAvatar(emoji: post.emoji, size: 34, highlighted: post.isMine)
            VStack(alignment: .leading, spacing: 0) {
                Text(post.isMine ? String(localized: "You") : post.displayName)
                    .font(.ui(15, .bold))
                    .lineLimit(1)
                Text(post.createdDate ?? .now, format: .relative(presentation: .named))
                    .font(.ui(12, .medium))
                    .opacity(0.8)
            }
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.35), radius: 4)
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(LinearGradient(colors: [.black.opacity(0.45), .clear], startPoint: .top, endPoint: .bottom))
    }
}
