//
//  FriendsPhotoDetail.swift
//  GymWorkout
//
//  One photo check-in with its comments (2026-11-28): the photo, who and
//  when, caption and tag, reactions, then the comments, live while the
//  sheet is open. The input bar sits at the bottom (300 characters).
//  Touch and hold a comment: delete it (mine, or any on my post), report
//  it, or block its author (also someone who isn't the member's friend: a
//  friend of the poster). ⋯ on the post: delete (mine) or report. The
//  member's own post hidden after reports shows marked, can't take new
//  reactions or comments, and can still be deleted.
//

import SwiftUI

struct FriendsPhotoDetail: View {
    /// The post as it was when opened; the live one from the service wins.
    var initial: FriendPhotoPost

    static let commentLimit = 300

    private var photos: FriendsPhotoService { .shared }
    @Environment(\.dismiss) private var dismiss

    @State private var text = ""
    @State private var sending = false
    @State private var toast: String?
    @State private var confirmDelete = false
    @State private var reportingPost = false
    @State private var reportingComment: FriendPhotoComment?
    @State private var blockingComment: FriendPhotoComment?
    @FocusState private var inputFocused: Bool

    private var live: FriendPhotoPost? { photos.posts.first { $0.id == initial.id } }
    /// Gone from the live feed (deleted, expired, reported, unfriended).
    private var isGone: Bool { live == nil && (photos.loaded || photos.wasReported(initial.id)) }
    private var post: FriendPhotoPost { live ?? initial }
    private var comments: [FriendPhotoComment] {
        photos.comments(for: initial.id).filter { !$0.hidden }.sorted { ($0.createdDate ?? .distantPast) < ($1.createdDate ?? .distantPast) }
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        if isGone {
                            gone
                        } else {
                            if post.hidden { hiddenNotice }
                            photo
                            meta
                            Divider().overlay(DS.silver.opacity(0.08))
                            commentList
                        }
                    }
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 4)
                    .padding(.bottom, 16)
                    .friendsColumn()
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: comments.count) { old, new in
                    guard new > old, let last = comments.last else { return }
                    withAnimation(.easeOut(duration: 0.25)) { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
            .background(DS.ink.ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if !isGone && !post.hidden { inputBar }
            }
            .overlay(alignment: .bottom) {
                if let toast {
                    FriendsToast(text: toast)
                        .padding(.bottom, 90)
                        .allowsHitTesting(false)
                }
            }
            .animation(.spring(duration: 0.3), value: toast)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").font(.system(size: 14, weight: .bold))
                    }
                    .accessibilityLabel(String(localized: "Close"))
                }
                ToolbarItem(placement: .primaryAction) { postMenu }
            }
        }
        .presentationBackground(DS.ink)
        .presentationDragIndicator(.visible)
        .onAppear { photos.listenComments(initial.id) }
        .onDisappear { photos.stopComments(initial.id) }
        .task(id: toast) {
            guard toast != nil else { return }
            try? await Task.sleep(for: .seconds(2.2))
            toast = nil
        }
        .onChange(of: text) { _, new in
            if new.count > Self.commentLimit { text = String(new.prefix(Self.commentLimit)) }
        }
        .confirmationDialog(String(localized: "Delete this photo?"), isPresented: $confirmDelete,
                            titleVisibility: .visible) {
            Button(String(localized: "Delete"), role: .destructive) { deletePost() }
        } message: {
            Text("It's removed for your friends too, with its comments.")
        }
        .confirmationDialog(String(localized: "Report this photo?"), isPresented: $reportingPost,
                            titleVisibility: .visible) {
            ForEach(FriendPhotoReportReason.allCases) { reason in
                Button(reason.title) { reportPost(reason) }
            }
        } message: {
            Text("MUSQ reviews every report within 24 hours.")
        }
        .confirmationDialog(String(localized: "Report this comment?"),
                            isPresented: Binding(get: { reportingComment != nil },
                                                 set: { if !$0 { reportingComment = nil } }),
                            titleVisibility: .visible, presenting: reportingComment) { c in
            ForEach(FriendPhotoReportReason.allCases) { reason in
                Button(reason.title) { reportComment(c, reason) }
            }
        } message: { _ in
            Text("MUSQ reviews every report within 24 hours.")
        }
        .confirmationDialog(String(localized: "Block \(blockingComment?.displayName ?? "")?"),
                            isPresented: Binding(get: { blockingComment != nil },
                                                 set: { if !$0 { blockingComment = nil } }),
                            titleVisibility: .visible, presenting: blockingComment) { c in
            Button(String(localized: "Block"), role: .destructive) { blockAuthor(c) }
        } message: { _ in
            Text("You won't see each other's photos or comments, and they can't send you requests. They aren't told.")
        }
    }

    // MARK: - Parts

    private var photo: some View {
        // Capped at about 45% of the screen so the comments start on the
        // first screen (owner check 2026-11-28); tap opens it full size.
        Color.clear
            .aspectRatio(4 / 5, contentMode: .fit)
            .frame(maxHeight: 360)
            .frame(maxWidth: .infinity)
            .overlay { FriendPhotoAsyncImage(post: post) }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var meta: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                FriendAvatar(emoji: post.emoji, size: 40, highlighted: post.isMine)
                VStack(alignment: .leading, spacing: 1) {
                    Text(post.isMine ? String(localized: "You") : post.displayName)
                        .font(.ui(16, .bold))
                        .foregroundStyle(DS.silver)
                    Text(post.createdDate ?? .now, format: .relative(presentation: .named))
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
                Spacer(minLength: 0)
            }
            if let caption = post.caption, !caption.isEmpty {
                Text(caption)
                    .font(.ui(16, .medium))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let tag = post.tag, !tag.isEmpty {
                FriendsPhotoTagChip(text: tag)
            }
            if !post.hidden {
                FriendsPhotoReactionBar(post: post, onError: { toast = $0 })
            }
        }
    }

    private var hiddenNotice: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "eye.slash.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(DS.rhythmWaiting)
            Text("Hidden after reports. Your friends can't see it while MUSQ reviews it. You can still delete it.")
                .font(.ui(13.5, .medium))
                .foregroundStyle(DS.silver.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(DS.surface))
    }

    @ViewBuilder private var commentList: some View {
        let comments = comments
        if comments.isEmpty {
            Text(post.isMine ? String(localized: "No comments yet.")
                 : String(localized: "Be the first to comment.", comment: "Empty comments on a friend's photo"))
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.45))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        } else {
            LazyVStack(alignment: .leading, spacing: 14) {
                ForEach(comments, id: \.id) { c in
                    commentRow(c).id(c.id)
                }
            }
        }
    }

    private func commentRow(_ c: FriendPhotoComment) -> some View {
        HStack(alignment: .top, spacing: 10) {
            FriendAvatar(emoji: c.emoji, size: 32, highlighted: c.isMine)
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(c.isMine ? String(localized: "You") : c.displayName)
                        .font(.ui(13.5, .bold))
                        .foregroundStyle(DS.silver)
                    Text(c.createdDate ?? .now, format: .relative(presentation: .named))
                        .font(.ui(12))
                        .foregroundStyle(DS.silver.opacity(0.4))
                }
                Text(c.text)
                    .font(.ui(15))
                    .foregroundStyle(DS.silver.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)
            }
            Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
        .contextMenu {
            if photos.canDelete(c, on: post) {
                Button(role: .destructive) { deleteComment(c) } label: {
                    Label(String(localized: "Delete comment"), systemImage: "trash")
                }
            }
            if !c.isMine {
                Button { reportingComment = c } label: {
                    Label(String(localized: "Report comment"), systemImage: "exclamationmark.bubble")
                }
                Button(role: .destructive) { blockingComment = c } label: {
                    Label(String(localized: "Block \(c.displayName)"), systemImage: "hand.raised")
                }
            }
        }
    }

    @ViewBuilder private var gone: some View {
        let reported = photos.wasReported(initial.id)
        VStack(spacing: 10) {
            Text(reported ? "🚩" : "🫥").font(.system(size: 40))
            Text(reported ? String(localized: "Thanks for reporting") : String(localized: "This photo is gone"))
                .font(.ui(17, .semibold))
                .foregroundStyle(DS.silver)
            Text(reported
                 ? String(localized: "You won't see this photo any more. MUSQ reviews every report within 24 hours.")
                 : String(localized: "It was deleted, it expired, or it's no longer shared with you."))
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    private var postMenu: some View {
        Menu {
            if isGone {
                EmptyView()
            } else if post.isMine {
                Button(role: .destructive) { confirmDelete = true } label: {
                    Label(String(localized: "Delete photo"), systemImage: "trash")
                }
            } else {
                Button { reportingPost = true } label: {
                    Label(String(localized: "Report photo"), systemImage: "exclamationmark.bubble")
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 15, weight: .bold))
                .frame(width: 34, height: 34)
        }
        .accessibilityLabel(String(localized: "More"))
    }

    private var inputBar: some View {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return VStack(alignment: .trailing, spacing: 4) {
            HStack(alignment: .bottom, spacing: 10) {
                TextField(String(localized: "Add a comment"), text: $text, axis: .vertical)
                    .font(.ui(15.5))
                    .lineLimit(1...4)
                    .focused($inputFocused)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface))
                Button(action: send) {
                    Group {
                        if sending {
                            ProgressView().tint(.white)
                        } else {
                            StyledSymbol(name: "arrow.up", size: 16, weight: .bold)
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(trimmed.isEmpty ? DS.silver.opacity(0.18) : DS.activation))
                }
                .buttonStyle(.plain)
                .disabled(trimmed.isEmpty || sending)
                .accessibilityLabel(String(localized: "Send"))
            }
            if text.count > Self.commentLimit - 50 {
                Text("\(text.count)/\(Self.commentLimit)")
                    .font(.ui(11.5, .medium))
                    .monospacedDigit()
                    .foregroundStyle(text.count >= Self.commentLimit ? DS.rhythmWaiting : DS.silver.opacity(0.4))
                    .padding(.trailing, 52)
            }
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .frame(maxWidth: 640)
        .frame(maxWidth: .infinity)
        // Down through the home-indicator strip too, so comments never
        // show under the bar.
        .background(DS.ink.opacity(0.96).ignoresSafeArea(edges: .bottom))
    }

    // MARK: - Actions

    private func send() {
        let body = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !body.isEmpty, !sending else { return }
        sending = true
        Task {
            defer { sending = false }
            do {
                _ = try await photos.addComment(post, text: body)
                text = ""
            } catch {
                toast = friendsPhotoMessage(error)
            }
        }
    }

    private func deleteComment(_ c: FriendPhotoComment) {
        Task {
            do { try await photos.deleteComment(post, c) }
            catch { toast = friendsPhotoMessage(error) }
        }
    }

    private func deletePost() {
        Task {
            do {
                try await photos.delete(post)
                dismiss()
            } catch {
                toast = friendsPhotoMessage(error)
            }
        }
    }

    private func reportPost(_ reason: FriendPhotoReportReason) {
        Task {
            do {
                try await photos.report(post, reason: reason)
                toast = String(localized: "Thanks — we'll take a look.")
            } catch {
                toast = friendsPhotoMessage(error)
            }
        }
    }

    private func blockAuthor(_ c: FriendPhotoComment) {
        Task {
            do {
                try await FriendsService.shared.block(commentAuthor: c, on: post)
                toast = String(localized: "Blocked \(c.displayName)")
            } catch {
                toast = friendsPhotoMessage(error)
            }
        }
    }

    private func reportComment(_ c: FriendPhotoComment, _ reason: FriendPhotoReportReason) {
        Task {
            do {
                try await photos.report(c, on: post, reason: reason)
                toast = String(localized: "Thanks — we'll take a look.")
            } catch {
                toast = friendsPhotoMessage(error)
            }
        }
    }
}
