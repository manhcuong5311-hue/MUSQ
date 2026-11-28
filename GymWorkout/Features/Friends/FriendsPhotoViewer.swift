//
//  FriendsPhotoViewer.swift
//  GymWorkout
//
//  Full-screen photo viewer from the stories row or a ringed avatar
//  (2026-11-28): each person's photos of the last 24 h, story after
//  story; tap right for the next, left for the one before, swipe down to
//  close. A photo counts as seen once it's shown. Reactions and the
//  comments open from the bottom.
//

import SwiftUI

struct FriendsPhotoViewer: View {
    /// Every photo of every story, in play order.
    private let slides: [Slide]
    private let storyCount: Int
    @State private var index: Int

    private struct Slide {
        var story: FriendPhotoStory
        var storyIndex: Int
        var postId: String
        var fallback: FriendPhotoPost
    }

    init(stories: [FriendPhotoStory], start: Int) {
        var slides: [Slide] = []
        var startSlide = 0
        for (i, story) in stories.enumerated() {
            let posts = story.posts.filter { $0.isStory() && !$0.hidden }
            if i == start { startSlide = slides.count }
            for post in posts {
                slides.append(Slide(story: story, storyIndex: i, postId: post.id, fallback: post))
            }
        }
        self.slides = slides
        self.storyCount = stories.count
        _index = State(initialValue: min(startSlide, max(0, slides.count - 1)))
    }

    private var photos: FriendsPhotoService { .shared }
    @Environment(\.dismiss) private var dismiss

    @State private var detail: FriendsPhotoDetailRequest?
    @State private var dragY: CGFloat = 0
    @State private var toast: String?

    private var slide: Slide? { slides.indices.contains(index) ? slides[index] : nil }
    private var story: FriendPhotoStory? { slide?.story }
    /// The live post (reactions, comment count). The story's copy only
    /// until the feed has loaded; after that a post missing from it is gone
    /// (deleted, hidden after reports, unfriended or blocked).
    private var post: FriendPhotoPost? {
        guard let slide else { return nil }
        if let live = photos.posts.first(where: { $0.id == slide.postId }) { return live.hidden ? nil : live }
        return photos.loaded ? nil : slide.fallback
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if let post {
                FriendsPhotoFullImage(post: post)
                    .id(post.id)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("This photo is gone")
                    .font(.ui(16, .semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }
            tapZones
            VStack(spacing: 0) {
                topBar
                Spacer()
                if let post { bottomBar(post) }
            }
            if let toast {
                VStack {
                    Spacer()
                    FriendsToast(text: toast).padding(.bottom, 140)
                }
                .allowsHitTesting(false)
            }
        }
        .offset(y: max(0, dragY))
        .opacity(1 - Double(max(0, dragY)) / 600)
        .gesture(DragGesture(minimumDistance: 20)
            .onChanged { dragY = $0.translation.height }
            .onEnded { value in
                if value.translation.height > 120 { dismiss() }
                else { withAnimation(.spring(duration: 0.3)) { dragY = 0 } }
            })
        .statusBarHidden()
        .animation(.spring(duration: 0.3), value: toast)
        .task(id: toast) {
            guard toast != nil else { return }
            try? await Task.sleep(for: .seconds(2))
            toast = nil
        }
        .onAppear { markSeen() }
        .onChange(of: index) { _, _ in markSeen() }
        .sheet(item: $detail) { FriendsPhotoDetail(initial: $0.post) }
    }

    private var tapZones: some View {
        HStack(spacing: 0) {
            Color.clear.contentShape(Rectangle())
                .onTapGesture { step(-1) }
                .accessibilityLabel(String(localized: "Previous photo"))
                .accessibilityAddTraits(.isButton)
            Color.clear.contentShape(Rectangle())
                .onTapGesture { step(1) }
                .accessibilityLabel(String(localized: "Next photo"))
                .accessibilityAddTraits(.isButton)
        }
    }

    private var topBar: some View {
        VStack(spacing: 12) {
            if let slide, storySlides(slide.storyIndex).count > 1 || storyCount > 1 {
                let mine = storySlides(slide.storyIndex)
                HStack(spacing: 4) {
                    ForEach(mine, id: \.self) { i in
                        Capsule()
                            .fill(.white.opacity(i <= index ? 0.95 : 0.3))
                            .frame(height: 3)
                    }
                }
            }
            HStack(spacing: 10) {
                if let story {
                    FriendAvatar(emoji: story.emoji, size: 36)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(story.isMine ? String(localized: "You") : story.displayName)
                            .font(.ui(15, .bold))
                        Text(post?.createdDate ?? .now, format: .relative(presentation: .named))
                            .font(.ui(12, .medium))
                            .opacity(0.75)
                    }
                    .foregroundStyle(.white)
                }
                Spacer(minLength: 0)
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel(String(localized: "Close"))
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
        .padding(.bottom, 24)
        .background(LinearGradient(colors: [.black.opacity(0.55), .clear], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea())
    }

    private func bottomBar(_ post: FriendPhotoPost) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let caption = post.caption, !caption.isEmpty {
                Text(caption)
                    .font(.ui(16, .semibold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let tag = post.tag, !tag.isEmpty {
                Text("🏋️ \(tag)")
                    .font(.ui(13, .semibold))
                    .foregroundStyle(.white.opacity(0.85))
            }
            HStack(spacing: 8) {
                FriendsPhotoReactionBar(post: post, compact: true, onError: { toast = $0 })
                    .environment(\.colorScheme, .dark)
                Spacer(minLength: 0)
                FriendsPhotoCommentButton(count: post.commentCount) {
                    detail = FriendsPhotoDetailRequest(post: post)
                }
                .environment(\.colorScheme, .dark)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 40)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea())
    }

    private func step(_ delta: Int) {
        let next = index + delta
        if slides.indices.contains(next) {
            index = next
        } else if delta > 0 {
            dismiss()
        }
    }

    /// The slide indexes of one story: the progress bars on top.
    private func storySlides(_ storyIndex: Int) -> [Int] {
        slides.indices.filter { slides[$0].storyIndex == storyIndex }
    }

    private func markSeen() {
        guard let post, !post.isMine else { return }
        photos.markSeen(post)
    }
}

/// The photo fitted on black, with no grey box around it.
private struct FriendsPhotoFullImage: View {
    var post: FriendPhotoPost
    @State private var image: UIImage?
    @State private var failed = false

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image).resizable().scaledToFit()
            } else if failed {
                StyledSymbol(name: "photo", size: 28).foregroundStyle(.white.opacity(0.4))
            } else {
                ProgressView().tint(.white)
            }
        }
        .task(id: post.id) {
            let service = FriendsPhotoService.shared
            if let cached = service.cachedImage(for: post) { image = cached; return }
            let loaded = await service.image(for: post)
            image = loaded
            failed = loaded == nil
        }
        .accessibilityLabel(Text(post.caption ?? String(localized: "Photo", comment: "Friends photo accessibility label")))
    }
}
