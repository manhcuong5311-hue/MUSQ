//
//  FriendsPhotosService.swift
//  GymWorkout
//
//  Friends photo check-ins (2026-11-28, owner: casual photos, Locket-like):
//  post a photo with a short caption and today's workout as a tag; it rings
//  the poster's avatar for 24 h and sits in friends' feeds for 30 days;
//  friends react and comment, live.
//
//  Reads are live Firestore snapshot listeners on the member's own inbox
//  (friendInbox/{uid}/posts and a post's comments), the only paths
//  firestore.rules opens, and only to their owner. Every write goes through
//  a callable (functions/src, friendsPhoto*/friendsComment*), which checks
//  friendship, moderates photo and text (OpenAI moderation) and limits
//  (10 photos, 100 comments a day), then fans the copies out.
//  Document shapes: FriendsPhotosModels.swift.
//
//  The Friends UI calls `startListening()` when the tab appears and the app
//  is active, `stopListening()` when it goes away or the app goes to the
//  background; a post's detail calls `listenComments(_:)` and
//  `stopComments(_:)`.
//
//  DEBUG: `-friends.sample` (FriendsService.usesSample) fills posts,
//  stories and comments with generated photos and makes actions succeed on
//  the device.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFunctions
import Foundation
import Observation
import UIKit

@MainActor
@Observable
final class FriendsPhotoService {
    static let shared = FriendsPhotoService()

    /// The feed's photo posts, newest first (expired ones out; hidden ones
    /// out too, except the member's own, which they still see, marked).
    private(set) var posts: [FriendPhotoPost] = []
    /// Friends and the member with a photo in the last 24 h, newest first
    /// (the member's own first when they have one).
    private(set) var stories: [FriendPhotoStory] = []
    /// The first snapshot has come back since listening started.
    private(set) var loaded = false
    /// The listeners are attached.
    private(set) var isListening = false
    /// A short reason the live feed isn't coming through (nil when fine).
    private(set) var listenError: String?
    /// A post is being sent.
    private(set) var isPosting = false
    /// Live comments per post id, oldest first.
    private(set) var commentsByPost: [String: [FriendPhotoComment]] = [:]

    @ObservationIgnored private var db: Firestore?
    @ObservationIgnored private var functions: Functions?
    @ObservationIgnored private var postsListener: ListenerRegistration?
    @ObservationIgnored private var commentListeners: [String: ListenerRegistration] = [:]
    /// Posts whose detail is open (their comments re-attach on start).
    @ObservationIgnored private var wantedComments: Set<String> = []
    @ObservationIgnored private var listeningUID: String?
    @ObservationIgnored private var authHandle: AuthStateDidChangeListenerHandle?
    /// The snapshot as it came, before local changes are laid over it.
    @ObservationIgnored private var serverPosts: [FriendPhotoPost] = []
    /// Reactions tapped and not settled yet (post id → emoji or nil): the
    /// latest tap wins, and a post's calls go one at a time.
    @ObservationIgnored private var pendingReactions: [String: String?] = [:]
    /// Posts with a reaction call on its way (later taps wait for it).
    @ObservationIgnored private var reactionInFlight: Set<String> = []
    /// Posts the member reported here: hidden for them (the server takes
    /// their copy away), and the detail says why it went.
    @ObservationIgnored private var reportedPosts: Set<String> = []
    /// Posts and comments deleted here, kept out until the server agrees.
    @ObservationIgnored private var removedPosts: Set<String> = []
    @ObservationIgnored private var removedComments: Set<String> = []
    /// Friends removed or blocked on this device (FriendsService), whose
    /// posts stay out until the server's copies are gone.
    @ObservationIgnored private var droppedAuthors: Set<String> = []
    @ObservationIgnored private var seen: [String: String]
    /// Decoded photos, bounded by bytes (a 1080×1350 photo is ≈ 5.8 MB).
    @ObservationIgnored private let memory = NSCache<NSString, UIImage>()
    @ObservationIgnored private var loading: [String: Task<UIImage?, Never>] = [:]
    @ObservationIgnored private var diskCleaned = false

    private static let seenKey = "friends.photos.seen"
    /// The account the seen rings and the photo cache belong to.
    private static let uidKey = "friends.photos.uid"

    private init() {
        seen = UserDefaults.standard.dictionary(forKey: Self.seenKey) as? [String: String] ?? [:]
        memory.countLimit = 24
        memory.totalCostLimit = 48 * 1024 * 1024
        #if DEBUG
        if FriendsService.usesSample { loadSample() }
        #endif
    }

    var usesSampleData: Bool { FriendsService.shared.usesSampleData }

    // MARK: Derived

    /// The member's story ring for a friend id ("me" for the member).
    func story(for authorId: String) -> FriendPhotoStory? { stories.first { $0.authorId == authorId } }

    /// A photo in the last 24 h: ring the avatar.
    func hasStory(_ authorId: String) -> Bool { story(for: authorId) != nil }

    /// A ring not opened yet (bright ring).
    func hasUnseen(_ authorId: String) -> Bool { story(for: authorId)?.hasUnseen ?? false }

    func post(id: String) -> FriendPhotoPost? { posts.first { $0.id == id } }

    /// The member reported this post here (so it went for that reason).
    func wasReported(_ postId: String) -> Bool { reportedPosts.contains(postId) }

    /// A post's live comments, oldest first.
    func comments(for postId: String) -> [FriendPhotoComment] { commentsByPost[postId] ?? [] }

    /// The member may delete the comment: theirs, or on their own post.
    func canDelete(_ comment: FriendPhotoComment, on post: FriendPhotoPost) -> Bool {
        comment.isMine || post.isMine
    }

    // MARK: Listening

    /// Attaches the feed listener (signed in only); safe to call again.
    func startListening() {
        observeAuth()
        cleanDiskOnce()
        #if DEBUG
        if usesSampleData { isListening = true; loaded = true; return }
        #endif
        guard let uid = currentUID(), let db = firestore() else {
            if listeningUID != nil { clear() }
            return
        }
        if let previous = listeningUID ?? UserDefaults.standard.string(forKey: Self.uidKey), previous != uid { clear() }
        UserDefaults.standard.set(uid, forKey: Self.uidKey)
        guard postsListener == nil else { return }
        listeningUID = uid
        isListening = true
        listenError = nil
        let query = db.collection("friendInbox").document(uid).collection("posts")
            .order(by: "createdAt", descending: true)
            .limit(to: FriendsPhotoLimits.feedPageSize)
        postsListener = query.addSnapshotListener { [weak self] snapshot, error in
            MainActor.assumeIsolated {
                guard let self, self.listeningUID == uid else { return }
                if let error {
                    self.listenError = Self.listenMessage(error)
                    self.loaded = true
                    return
                }
                guard let snapshot else { return }
                self.listenError = nil
                let before = Set(self.serverPosts.map(\.id))
                self.serverPosts = snapshot.documents.compactMap {
                    FriendPhotoPost(documentId: $0.documentID, data: $0.data())
                }
                let ids = Set(self.serverPosts.map(\.id))
                // Under a full page, a post that left the snapshot is gone for
                // this member (deleted, unfriended, blocked, hidden): its
                // photo leaves the device too. (A full page also drops its
                // oldest post when a new one comes; that one stays cached.)
                if snapshot.documents.count < FriendsPhotoLimits.feedPageSize {
                    self.forgetImages(before.subtracting(ids))
                }
                self.removedPosts.formIntersection(ids)
                self.loaded = true
                self.rebuild()
            }
        }
        // Comment listeners a detail still shows (stopped with the feed).
        for postId in wantedComments { listenComments(postId) }
    }

    /// Detaches every listener; what's shown stays.
    func stopListening() {
        postsListener?.remove()
        postsListener = nil
        for registration in commentListeners.values { registration.remove() }
        commentListeners = [:]
        isListening = false
    }

    /// Live comments for a post's detail.
    func listenComments(_ postId: String) {
        #if DEBUG
        if usesSampleData { return }
        #endif
        wantedComments.insert(postId)
        guard commentListeners[postId] == nil, let uid = currentUID(), let db = firestore() else { return }
        let query = db.collection("friendInbox").document(uid).collection("posts").document(postId)
            .collection("comments")
            .order(by: "createdAt", descending: false)
            .limit(toLast: FriendsPhotoLimits.commentsPageSize)
        commentListeners[postId] = query.addSnapshotListener { [weak self] snapshot, error in
            MainActor.assumeIsolated {
                guard let self, self.currentUID() == uid else { return }
                if error != nil { return }
                guard let snapshot else { return }
                let comments = snapshot.documents.compactMap {
                    FriendPhotoComment(documentId: $0.documentID, postId: postId, data: $0.data())
                }
                self.removedComments.formIntersection(Set(comments.map(\.id)))
                self.commentsByPost[postId] = comments.filter { !$0.hidden && !self.removedComments.contains($0.id) }
            }
        }
    }

    func stopComments(_ postId: String) {
        wantedComments.remove(postId)
        commentListeners.removeValue(forKey: postId)?.remove()
    }

    /// Clears everything (signed out, another account, account deleted).
    func clear() {
        stopListening()
        listeningUID = nil
        serverPosts = []
        posts = []
        stories = []
        commentsByPost = [:]
        pendingReactions = [:]
        removedPosts = []
        removedComments = []
        droppedAuthors = []
        loaded = false
        listenError = nil
        memory.removeAllObjects()
        loading.values.forEach { $0.cancel() }
        loading = [:]
        reactionInFlight = []
        reportedPosts = []
        seen = [:]
        UserDefaults.standard.removeObject(forKey: Self.seenKey)
        UserDefaults.standard.removeObject(forKey: Self.uidKey)
        Task.detached(priority: .utility) { FriendsPhotoImage.cleanDisk(all: true) }
    }

    /// Hides a friend's posts and comments at once after they were removed
    /// or blocked here (the server removes its copies on its own).
    func forget(authorId: String) {
        droppedAuthors.insert(authorId)
        for (postId, list) in commentsByPost { commentsByPost[postId] = list.filter { $0.authorId != authorId } }
        forgetImages(Set(serverPosts.filter { $0.authorId == authorId && !$0.isMine }.map(\.id)))
        rebuild()
    }

    /// Drops posts' photos from memory and from the disk cache.
    private func forgetImages(_ ids: Set<String>) {
        guard !ids.isEmpty else { return }
        for id in ids {
            memory.removeObject(forKey: id as NSString)
            loading.removeValue(forKey: id)?.cancel()
        }
        Task.detached(priority: .utility) { for id in ids { FriendsPhotoImage.removeDisk(id) } }
    }

    private func observeAuth() {
        guard authHandle == nil, FirebaseApp.app() != nil, AIService.shared.isConfigured else { return }
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            MainActor.assumeIsolated {
                guard let self else { return }
                if user == nil || (self.listeningUID != nil && user?.uid != self.listeningUID) {
                    if !self.usesSampleData { self.clear() }
                }
            }
        }
    }

    // MARK: Building what's shown

    private func rebuild(now: Date = Date()) {
        // A post hidden after reports stays for its poster (marked, so they
        // can still see and delete it); for everyone else the server has
        // already taken it away.
        var list = serverPosts.filter {
            (!$0.hidden || $0.isMine) && !$0.isExpired(now: now) && !removedPosts.contains($0.id)
                && !droppedAuthors.contains($0.authorId)
        }
        for (postId, emoji) in pendingReactions {
            guard let index = list.firstIndex(where: { $0.id == postId }) else { continue }
            list[index] = Self.applying(emoji, to: list[index])
        }
        list.sort { ($0.createdDate ?? .distantPast) > ($1.createdDate ?? .distantPast) }
        posts = list
        stories = Self.stories(from: list, seen: seen, now: now)
    }

    nonisolated static func stories(from posts: [FriendPhotoPost], seen: [String: String],
                                    now: Date = Date()) -> [FriendPhotoStory] {
        var byAuthor: [String: [FriendPhotoPost]] = [:]
        for post in posts where post.isStory(now: now) && !post.hidden {
            byAuthor[post.isMine ? "me" : post.authorId, default: []].append(post)
        }
        let result = byAuthor.map { authorId, list -> FriendPhotoStory in
            let ordered = list.sorted { ($0.createdDate ?? .distantPast) < ($1.createdDate ?? .distantPast) }
            let latest = ordered.last!
            let seenDate = seen[authorId].flatMap(FriendsTime.date) ?? .distantPast
            let unseen = !latest.isMine && (latest.createdDate ?? .distantPast) > seenDate
            return FriendPhotoStory(authorId: authorId, isMine: latest.isMine, displayName: latest.displayName,
                                    emoji: latest.emoji, posts: ordered, hasUnseen: unseen)
        }
        return result.sorted {
            if $0.isMine != $1.isMine { return $0.isMine }
            if $0.hasUnseen != $1.hasUnseen { return $0.hasUnseen }
            return ($0.latest?.createdDate ?? .distantPast) > ($1.latest?.createdDate ?? .distantPast)
        }
    }

    /// The member opened a story (or one photo of it): its ring goes quiet.
    func markSeen(_ story: FriendPhotoStory) {
        guard let latest = story.latest else { return }
        markSeen(latest)
    }

    func markSeen(_ post: FriendPhotoPost) {
        let key = post.isMine ? "me" : post.authorId
        if let old = seen[key].flatMap(FriendsTime.date), let new = post.createdDate, old >= new { return }
        seen[key] = post.createdAt
        // Forget rings older than a week.
        let cutoff = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        seen = seen.filter { (FriendsTime.date($0.value) ?? .distantPast) > cutoff }
        UserDefaults.standard.set(seen, forKey: Self.seenKey)
        stories = Self.stories(from: posts, seen: seen)
    }

    nonisolated private static func applying(_ emoji: String?, to post: FriendPhotoPost) -> FriendPhotoPost {
        var after = post
        if let old = post.myReaction { after.reactions[old] = max(0, (after.reactions[old] ?? 0) - 1) }
        if let emoji { after.reactions[emoji, default: 0] += 1 }
        after.reactions = after.reactions.filter { $0.value > 0 }
        after.myReaction = emoji
        return after
    }

    // MARK: Actions

    /// Sends a photo; the server moderates it before any friend sees it.
    @discardableResult
    func post(image: UIImage, caption: String?, tag: String?) async throws -> FriendPhotoPost {
        let caption = try Self.cleaned(caption, limit: FriendsPhotoLimits.captionLimit, required: false)
        let tag = (try? Self.cleaned(tag, limit: .max, required: false))?.map { String($0.prefix(FriendsPhotoLimits.tagLimit)) }
        isPosting = true
        defer { isPosting = false }
        let prepared = try await Task.detached(priority: .userInitiated) {
            try FriendsPhotoImage.prepare(image)
        }.value
        #if DEBUG
        if usesSampleData {
            let me = FriendsService.shared.me
            let post = FriendPhotoPost(id: "s-local-\(UUID().uuidString)", authorId: "me", isMine: true,
                                       displayName: me?.displayName ?? "Me", emoji: me?.emoji ?? FriendsCatalog.defaultEmoji,
                                       caption: caption, tag: tag, width: prepared.width, height: prepared.height,
                                       createdAt: FriendsTime.string(Date()))
            if let shown = FriendsPhotoImage.decoded(prepared.data) {
                memory.setObject(shown, forKey: post.id as NSString, cost: Self.cost(of: shown))
            }
            serverPosts.insert(post, at: 0)
            rebuild()
            return post
        }
        #endif
        let request = FriendsPhotoPostRequest(imageBase64: prepared.data.base64EncodedString(), caption: caption,
                                              tag: tag, width: prepared.width, height: prepared.height)
        let response = try await call("friendsPhotoPost", request, as: FriendsPhotoPostResponse.self, context: .photo)
        var post = response.post
        post.isMine = true
        // The member's own photo shows at once, from what was sent.
        if let shown = FriendsPhotoImage.decoded(prepared.data) {
            memory.setObject(shown, forKey: post.id as NSString, cost: Self.cost(of: shown))
            let data = prepared.data
            let key = post.id
            Task.detached(priority: .utility) { FriendsPhotoImage.writeDisk(key, data: data) }
        }
        if !serverPosts.contains(where: { $0.id == post.id }) {
            serverPosts.insert(post, at: 0)
            rebuild()
        }
        return post
    }

    /// Deletes the member's own post (every friend's copy and the photo).
    func delete(_ post: FriendPhotoPost) async throws {
        guard post.isMine else { throw FriendsPhotoError.notFriends }
        removedPosts.insert(post.id)
        rebuild()
        if !usesSampleData {
            do {
                _ = try await call("friendsPhotoDelete", FriendsPhotoIdRequest(postId: post.id), as: FriendsEmpty.self)
            } catch {
                let mapped = Self.map(error)
                if mapped != .gone {
                    removedPosts.remove(post.id)
                    rebuild()
                    throw mapped
                }
            }
        } else {
            serverPosts.removeAll { $0.id == post.id }
        }
        memory.removeObject(forKey: post.id as NSString)
        commentsByPost[post.id] = nil
        let key = post.id
        Task.detached(priority: .utility) { FriendsPhotoImage.removeDisk(key) }
    }

    /// Sets the member's reaction (nil takes it away): shown at once, put
    /// back if the server refuses. Quick taps on one post: the last one wins;
    /// calls go one at a time, and a tap made while one is on its way is
    /// sent when it comes back (so the server ends on the last tap too).
    func react(_ post: FriendPhotoPost, emoji: String?) async throws {
        if let emoji, !FriendsCatalog.reactions.contains(emoji) { return }
        #if DEBUG
        if usesSampleData {
            if let index = serverPosts.firstIndex(where: { $0.id == post.id }) {
                serverPosts[index] = Self.applying(emoji, to: serverPosts[index])
            }
            rebuild()
            return
        }
        #endif
        pendingReactions[post.id] = .some(emoji)
        rebuild()
        // The call on its way sends this tap after it.
        guard !reactionInFlight.contains(post.id) else { return }
        reactionInFlight.insert(post.id)
        defer { reactionInFlight.remove(post.id) }
        var sent: String?? = nil
        while let wanted = pendingReactions[post.id], Optional(wanted) != sent {
            sent = .some(wanted)
            do {
                _ = try await call("friendsPhotoReact", FriendsPhotoReactRequest(postId: post.id, emoji: wanted),
                                   as: FriendsEmpty.self)
            } catch {
                pendingReactions[post.id] = nil
                rebuild()
                throw Self.map(error)
            }
        }
        // Settled. Until the snapshot carries it, keep it as sent.
        if case .some(let final) = sent, let index = serverPosts.firstIndex(where: { $0.id == post.id }),
           serverPosts[index].myReaction != final {
            serverPosts[index] = Self.applying(final, to: serverPosts[index])
        }
        pendingReactions[post.id] = nil
        rebuild()
    }

    /// Taps a reaction: sets it, or takes it away when it's already the member's.
    func toggle(_ post: FriendPhotoPost, emoji: String) async throws {
        try await react(post, emoji: post.myReaction == emoji ? nil : emoji)
    }

    @discardableResult
    func addComment(_ post: FriendPhotoPost, text raw: String) async throws -> FriendPhotoComment {
        let text = try Self.cleaned(raw, limit: FriendsPhotoLimits.commentLimit, required: true) ?? ""
        #if DEBUG
        if usesSampleData {
            let me = FriendsService.shared.me
            let comment = FriendPhotoComment(id: "s-c-\(UUID().uuidString)", postId: post.id, authorId: "me", isMine: true,
                                             displayName: me?.displayName ?? "Me",
                                             emoji: me?.emoji ?? FriendsCatalog.defaultEmoji,
                                             text: text, createdAt: FriendsTime.string(Date()))
            commentsByPost[post.id, default: []].append(comment)
            bumpCount(post.id, by: 1)
            return comment
        }
        #endif
        let response = try await call("friendsCommentAdd", FriendsCommentAddRequest(postId: post.id, text: text),
                                      as: FriendsCommentAddResponse.self, context: .comment)
        var comment = response.comment
        comment.isMine = true
        if comment.postId.isEmpty { comment.postId = post.id }
        var list = commentsByPost[post.id] ?? []
        if !list.contains(where: { $0.id == comment.id }) {
            list.append(comment)
            commentsByPost[post.id] = list
        }
        return comment
    }

    func deleteComment(_ post: FriendPhotoPost, _ comment: FriendPhotoComment) async throws {
        guard canDelete(comment, on: post) else { throw FriendsPhotoError.notFriends }
        removedComments.insert(comment.id)
        let before = commentsByPost[post.id]
        commentsByPost[post.id]?.removeAll { $0.id == comment.id }
        if usesSampleData { bumpCount(post.id, by: -1); return }
        do {
            _ = try await call("friendsCommentDelete",
                               FriendsCommentDeleteRequest(postId: post.id, commentId: comment.id), as: FriendsEmpty.self)
        } catch {
            let mapped = Self.map(error)
            if mapped != .gone {
                removedComments.remove(comment.id)
                commentsByPost[post.id] = before
                throw mapped
            }
        }
    }

    /// Reports a post; it leaves the member's feed at once (the server
    /// takes their copy away), photo cache included.
    func report(_ post: FriendPhotoPost, reason: FriendPhotoReportReason) async throws {
        if !usesSampleData {
            _ = try await call("friendsPhotoReport",
                               FriendsPhotoReportRequest(postId: post.id, commentId: nil, reason: reason),
                               as: FriendsEmpty.self)
        }
        reportedPosts.insert(post.id)
        removedPosts.insert(post.id)
        commentsByPost[post.id] = nil
        forgetImages([post.id])
        rebuild()
    }

    func report(_ comment: FriendPhotoComment, on post: FriendPhotoPost, reason: FriendPhotoReportReason) async throws {
        if usesSampleData { return }
        _ = try await call("friendsPhotoReport",
                           FriendsPhotoReportRequest(postId: post.id, commentId: comment.id, reason: reason),
                           as: FriendsEmpty.self)
    }

    private func bumpCount(_ postId: String, by delta: Int) {
        guard let index = serverPosts.firstIndex(where: { $0.id == postId }) else { return }
        serverPosts[index].commentCount = max(0, serverPosts[index].commentCount + delta)
        rebuild()
    }

    /// Trimmed text within the limit; nil when empty and not required.
    nonisolated static func cleaned(_ raw: String?, limit: Int, required: Bool) throws -> String? {
        let text = (raw ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            if required { throw FriendsPhotoError.empty }
            return nil
        }
        if text.count > limit { throw FriendsPhotoError.tooLong }
        return text
    }

    // MARK: Auto tag

    /// Today's workout as a tag ("Chest · Triceps · 25 min"), when one is in
    /// progress or done; nil otherwise. Read-only: the live store when the
    /// caller has it, else the saved file.
    func autoTag(store: WorkoutStore? = nil, now: Date = Date(), calendar: Calendar = .current) -> String? {
        let sessions = store?.sessions ?? NudgeInputs.fromDisk()?.sessions ?? []
        return Self.autoTag(sessions: sessions, now: now, calendar: calendar)
    }

    static func autoTag(sessions: [WorkoutSession], now: Date = Date(), calendar: Calendar = .current) -> String? {
        let today = sessions.filter { calendar.isDate($0.day, inSameDayAs: now) && $0.hasCompletedSets }
        guard !today.isEmpty else { return nil }
        let summary = FriendsActivity.workout(today)
        let names = (summary.groups ?? []).compactMap(MuscleGroup.init(rawValue:)).prefix(2).map(\.title)
        let title = names.isEmpty ? String(localized: "Workout", comment: "Friends photo tag without muscle groups")
            : names.joined(separator: " · ")
        let tag: String
        if let minutes = summary.minutes, minutes > 0 {
            tag = String(localized: "\(title) · \(minutes) min", comment: "Friends photo tag: today's muscle groups, then minutes")
        } else {
            tag = title
        }
        return String(tag.prefix(FriendsPhotoLimits.tagLimit))
    }

    // MARK: Images

    /// The photo if it's already in memory (for a first frame without a flash).
    func cachedImage(for post: FriendPhotoPost) -> UIImage? {
        memory.object(forKey: post.id as NSString)
    }

    /// The post's photo: memory, then disk, then the network; nil when it
    /// can't be had (gone, offline). Decoded off the main thread; asked
    /// twice at once, it loads once.
    func image(for post: FriendPhotoPost) async -> UIImage? {
        if let hit = cachedImage(for: post) { return hit }
        if let running = loading[post.id] { return await running.value }
        let key = post.id
        let sample = usesSampleData ? Self.sampleSymbol(for: post.id) : nil
        // In `loading` before anything awaits, so a second caller waits for
        // this one instead of fetching a token and the photo again.
        let task = Task<UIImage?, Never> { [weak self] in
            let origin = await self?.source(for: post)
            let result: (UIImage?, Data?) = await Task.detached(priority: .userInitiated) {
                if let image = FriendsPhotoImage.readDisk(key) { return (image, nil) }
                if let sample { return (FriendsPhotoImage.placeholder(seed: key, symbol: sample), nil) }
                guard let origin, let data = try? await FriendsPhotoImage.download(origin),
                      let image = FriendsPhotoImage.decoded(data) else { return (nil, nil) }
                return (image, data)
            }.value
            if let data = result.1, !Task.isCancelled {
                Task.detached(priority: .utility) { FriendsPhotoImage.writeDisk(key, data: data) }
            }
            return result.0
        }
        loading[key] = task
        let image = await task.value
        // Only if it's still this load (forget/clear may have cancelled it).
        guard loading[key] == task else { return task.isCancelled ? nil : image }
        loading[key] = nil
        if let image { memory.setObject(image, forKey: key as NSString, cost: Self.cost(of: image)) }
        return image
    }

    /// Bytes a decoded image holds (the cache's cost).
    nonisolated private static func cost(of image: UIImage) -> Int {
        guard let cg = image.cgImage else {
            return Int(image.size.width * image.scale * image.size.height * image.scale * 4)
        }
        return cg.bytesPerRow * cg.height
    }

    private func source(for post: FriendPhotoPost) async -> FriendsPhotoImage.Source? {
        if usesSampleData { return nil }
        if let text = post.url, let url = URL(string: text), url.scheme == "https" || url.scheme == "http" {
            return FriendsPhotoImage.Source(url: url, bearer: nil)
        }
        guard let path = post.imagePath, FirebaseApp.app() != nil,
              let bucket = FirebaseApp.app()?.options.storageBucket, !bucket.isEmpty,
              let user = Auth.auth().currentUser,
              let token = try? await user.getIDToken() else { return nil }
        var emulator = false
        #if DEBUG
        emulator = AIService.usesEmulator
        #endif
        guard let url = FriendsPhotoImage.storageURL(bucket: bucket, path: path, emulator: emulator) else { return nil }
        return FriendsPhotoImage.Source(url: url, bearer: token)
    }

    private func cleanDiskOnce() {
        guard !diskCleaned else { return }
        diskCleaned = true
        Task.detached(priority: .background) { FriendsPhotoImage.cleanDisk() }
    }

    // MARK: Firebase

    private func currentUID() -> String? {
        guard AIService.shared.isConfigured, FirebaseApp.app() != nil, AccountService.shared.isSignedIn else { return nil }
        return Auth.auth().currentUser?.uid
    }

    /// Firestore for the live reads only (no offline cache: friends' posts
    /// aren't kept on the device beyond the photo cache).
    private func firestore() -> Firestore? {
        if let db { return db }
        guard AIService.shared.isConfigured, FirebaseApp.app() != nil else { return nil }
        let made = Firestore.firestore()
        let settings = made.settings
        settings.cacheSettings = MemoryCacheSettings()
        #if DEBUG
        if AIService.usesEmulator {
            settings.host = "127.0.0.1:8080"
            settings.isSSLEnabled = false
        }
        #endif
        made.settings = settings
        db = made
        return made
    }

    nonisolated enum CallContext: Sendable { case plain, photo, comment }

    private func call<Request: Encodable & Sendable, Response: Decodable & Sendable>(
        _ name: String, _ request: Request, as: Response.Type, context: CallContext = .plain
    ) async throws -> Response {
        guard let functions = functionsInstance() else { throw FriendsPhotoError.friends(.unavailable) }
        guard Auth.auth().currentUser != nil else { throw FriendsPhotoError.friends(.notSignedIn) }
        var callable = functions.httpsCallable(name, requestAs: Request.self, responseAs: Response.self)
        callable.timeoutInterval = context == .photo ? 60 : 30
        do {
            return try await callable.call(request)
        } catch {
            throw Self.map(error, context: context)
        }
    }

    private func functionsInstance() -> Functions? {
        if let functions { return functions }
        guard AIService.shared.isConfigured, FirebaseApp.app() != nil else { return nil }
        let made = Functions.functions(region: "asia-southeast1")
        #if DEBUG
        if AIService.usesEmulator { made.useEmulator(withHost: "127.0.0.1", port: 5001) }
        #endif
        functions = made
        return made
    }

    /// The server's errors as short reasons (functions/src/reasons.ts):
    /// friends-photo-not-allowed, friends-text-not-allowed,
    /// friends-photo-limit, friends-comment-limit, friends-reaction-limit,
    /// friends-not-found, "caption/text too long";
    /// anything else falls back on FriendsService's mapping.
    nonisolated static func map(_ error: Error, context: CallContext = .plain) -> FriendsPhotoError {
        if let known = error as? FriendsPhotoError { return known }
        let ns = error as NSError
        if ns.domain == FunctionsErrorDomain, let code = FunctionsErrorCode(rawValue: ns.code) {
            let message = ns.localizedDescription.lowercased()
            if message.contains("photo-not-allowed") || message.contains("photo-rejected") { return .photoRejected }
            if message.contains("text-not-allowed") || message.contains("text-rejected") || message.contains("moderat") {
                return context == .photo && !message.contains("text") ? .photoRejected : .textRejected
            }
            if message.contains("too-large") { return .tooLarge }
            if message.contains("not-friends") { return .notFriends }
            if message.contains("comment-limit") { return .commentLimit }
            if message.contains("photo-limit") { return .postLimit }
            if message.contains("reaction-limit") { return .reactionLimit }
            if message.contains("too long") { return .tooLong }
            switch code {
            case .resourceExhausted:
                if context == .comment { return .commentLimit }
                if context == .photo { return .postLimit }
            case .notFound: return .gone
            case .permissionDenied: return .notFriends
            default: break
            }
        }
        let inner = FriendsService.map(error)
        if inner == .gone { return .gone }
        return .friends(inner)
    }

    nonisolated private static func listenMessage(_ error: Error) -> String {
        let ns = error as NSError
        if ns.domain == FirestoreErrorDomain, let code = FirestoreErrorCode.Code(rawValue: ns.code) {
            switch code {
            case .unavailable, .deadlineExceeded: return FriendsError.offline.message
            case .unauthenticated: return FriendsError.notSignedIn.message
            default: break
            }
        }
        return FriendsError.unavailable.message
    }

    // MARK: - Sample (DEBUG)

    private static func sampleSymbol(for id: String) -> String {
        switch id {
        case "s-p-minh": return "figure.strengthtraining.traditional"
        case "s-p-me": return "dumbbell.fill"
        case "s-p-linh": return "cup.and.saucer.fill"
        case "s-p-alex": return "figure.run"
        case "s-p-huy": return "flame.fill"
        case "s-p-sarah": return "figure.yoga"
        default: return "camera.fill"
        }
    }

    #if DEBUG
    private func loadSample() {
        let now = Date()
        func ago(_ minutes: Double) -> String { FriendsTime.string(now.addingTimeInterval(-minutes * 60)) }
        func expire(_ minutes: Double) -> String {
            FriendsTime.string(now.addingTimeInterval(-minutes * 60 + FriendsPhotoLimits.retention))
        }
        serverPosts = [
            FriendPhotoPost(id: "s-p-minh", authorId: "s-minh", isMine: false, displayName: "Minh Trần", emoji: "🐯",
                            caption: "Leg day done. Can't feel my legs 🦵", tag: "Quads · Glutes · 48 min",
                            width: 1080, height: 1350, createdAt: ago(25), expireAt: expire(25),
                            reactions: ["🔥": 3, "💪": 1], myReaction: "🔥", commentCount: 2),
            FriendPhotoPost(id: "s-p-linh", authorId: "s-linh", isMine: false, displayName: "Linh Nguyễn", emoji: "🦊",
                            caption: "Post-run smoothie", width: 1080, height: 1350, createdAt: ago(60 * 2),
                            expireAt: expire(60 * 2), reactions: ["❤️": 2], commentCount: 1),
            FriendPhotoPost(id: "s-p-me", authorId: "me", isMine: true, displayName: "Cường", emoji: "🔥",
                            caption: "Morning pump", tag: "Back · Biceps · 47 min", width: 1080, height: 1350,
                            createdAt: ago(60 * 3), expireAt: expire(60 * 3), reactions: ["💪": 2, "👏": 1],
                            commentCount: 1),
            FriendPhotoPost(id: "s-p-huy", authorId: "s-huy", isMine: false, displayName: "Huy Phạm", emoji: "🏋️",
                            caption: nil, tag: "Shoulders · 35 min", width: 1080, height: 1080, createdAt: ago(60 * 9),
                            expireAt: expire(60 * 9)),
            FriendPhotoPost(id: "s-p-alex", authorId: "s-alex", isMine: false, displayName: "Alex Carter", emoji: "🦁",
                            caption: "New squat PR 🎉", tag: "Quads · Hamstrings · 61 min", width: 1080, height: 1350,
                            createdAt: ago(60 * 30), expireAt: expire(60 * 30), reactions: ["👏": 4, "🔥": 2],
                            commentCount: 0),
            FriendPhotoPost(id: "s-p-sarah", authorId: "s-sarah", isMine: false, displayName: "Sarah Kim", emoji: "🧘",
                            caption: "Sunday stretch", width: 1080, height: 1350, createdAt: ago(60 * 24 * 3),
                            expireAt: expire(60 * 24 * 3), reactions: ["❤️": 1]),
        ]
        commentsByPost = [
            "s-p-minh": [
                FriendPhotoComment(id: "s-c1", postId: "s-p-minh", authorId: "s-linh", isMine: false,
                                   displayName: "Linh Nguyễn", emoji: "🦊", text: "Beast mode 🔥", createdAt: ago(20)),
                FriendPhotoComment(id: "s-c2", postId: "s-p-minh", authorId: "me", isMine: true,
                                   displayName: "Cường", emoji: "🔥", text: "Stairs tomorrow will be fun 😅",
                                   createdAt: ago(12)),
            ],
            "s-p-linh": [
                FriendPhotoComment(id: "s-c3", postId: "s-p-linh", authorId: "s-minh", isMine: false,
                                   displayName: "Minh Trần", emoji: "🐯", text: "Recipe please!", createdAt: ago(90)),
            ],
            "s-p-me": [
                FriendPhotoComment(id: "s-c4", postId: "s-p-me", authorId: "s-alex", isMine: false,
                                   displayName: "Alex Carter", emoji: "🦁", text: "💪💪", createdAt: ago(60 * 2)),
            ],
        ]
        // Linh's ring already opened, to show both ring states.
        seen = ["s-linh": ago(60 * 2)]
        loaded = true
        rebuild(now: now)
    }
    #endif
}
