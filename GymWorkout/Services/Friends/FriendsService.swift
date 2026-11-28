//
//  FriendsService.swift
//  GymWorkout
//
//  MUSQ Friends v1 (2026-11-28): the app's side of the friends callables
//  (functions/src, Firebase project musq-app, asia-southeast1). Every read
//  and write goes through a callable (Firestore stays closed to the app),
//  each needs Sign in with Apple and App Check, like the AI calls. The rest
//  of the app never needs an account.
//
//  `refresh()` runs `friendsSync`: the profile, friends, requests and the
//  nudges not yet delivered, which FriendsInbox shows. After it, what the
//  member logged since the last post goes out (FriendsActivity). Call it when
//  the app becomes active and when the Friends tab appears.
//
//  DEBUG: the launch argument `-friends.sample` (or `-friends.sample YES`)
//  fills everything with sample people and makes every action succeed on
//  the device, so the screens can be shot without a server.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFunctions
import Foundation
import Observation

nonisolated enum FriendsError: Error, Equatable, Sendable {
    case notSignedIn
    /// A friend code nobody has (or a block, which reads the same).
    case notFound
    /// The friend, request or feed item isn't there any more (removed,
    /// declined or expired since the last refresh).
    case gone
    /// Too many friend codes tried today.
    case tooManyTries
    case alreadyNudged
    case nudgeLimit
    case limit
    case isSelf
    case invalidName
    case offline
    case deviceNotVerified
    case unavailable
    case server(String)

    /// A short message for the screen.
    var message: String {
        switch self {
        case .notSignedIn: return String(localized: "Sign in to use Friends.", comment: "Friends error")
        case .notFound: return String(localized: "No one has that code.", comment: "Friends error: unknown friend code")
        case .gone: return String(localized: "That's no longer there. Pull to refresh.", comment: "Friends error: the friend or request was removed meanwhile")
        case .tooManyTries: return String(localized: "Too many codes tried today. Try again tomorrow.", comment: "Friends error: daily cap on friend-code lookups")
        case .alreadyNudged: return String(localized: "Already nudged today.", comment: "Friends error: one nudge a day per friend")
        case .nudgeLimit: return String(localized: "That's all the nudges for today.", comment: "Friends error: daily nudge cap")
        case .limit: return String(localized: "You've reached the limit.", comment: "Friends error: too many friends or requests")
        case .isSelf: return String(localized: "That's your own code.", comment: "Friends error")
        case .invalidName: return String(localized: "Pick another name.", comment: "Friends error: name refused")
        case .offline: return String(localized: "You're offline.", comment: "Friends error")
        case .deviceNotVerified: return String(localized: "This device couldn't be verified.", comment: "Friends error: App Check")
        case .unavailable, .server: return String(localized: "Friends can't be reached right now.", comment: "Friends error")
        }
    }
}

@MainActor
@Observable
final class FriendsService {
    static let shared = FriendsService()

    enum State: Equatable {
        /// No MUSQ account (or Firebase isn't set up in this build).
        case signedOut
        /// Signed in, no friends profile yet: show the name + emoji setup.
        case needsProfile
        case ready
        /// The first sync is running; later syncs keep the last state.
        case loading
        case failed(String)
    }

    private(set) var state: State = .signedOut
    private(set) var me: FriendMe?
    private(set) var friends: [Friend] = []
    private(set) var incoming: [FriendRequest] = []
    private(set) var outgoing: [FriendRequest] = []
    /// Newest first.
    private(set) var feed: [FriendFeedItem] = []
    private(set) var feedHasMore = false
    private(set) var feedLoading = false
    /// The nudges the last syncs delivered, newest first (this session).
    private(set) var inbox: [FriendNudge] = []
    /// Nudge banners dismissed on the Friends tab, and nudges answered with
    /// Nudge back (this session; kept here, not in the view, so a tab switch
    /// doesn't bring them back).
    private(set) var dismissedNudges: Set<String> = []
    private(set) var nudgedBack: Set<String> = []
    /// The first feed page has come back (or failed) since the profile
    /// loaded: until then an empty feed is still loading, not empty.
    private(set) var feedLoaded = false
    /// A refresh is running.
    private(set) var isRefreshing = false

    @ObservationIgnored private var feedCursor: String?
    @ObservationIgnored private var refreshTask: Task<Void, Never>?
    @ObservationIgnored private var functions: Functions?
    @ObservationIgnored private var feedGeneration = 0

    private init() {
        #if DEBUG
        if Self.usesSample { loadSample() }
        #endif
    }

    // MARK: Derived

    var hasProfile: Bool { me != nil }
    var isSignedIn: Bool { AccountService.shared.isSignedIn || usesSampleData }

    /// "Add me on MUSQ 💪 Code: ABC123 https://musq.app/f/ABC123"
    var inviteText: String? {
        guard let code = me?.code, let url = inviteURL else { return nil }
        return String(localized: "Add me on MUSQ 💪 Code: \(code) \(url.absoluteString)",
                      comment: "Friends invite share text: the friend code, then the invite link")
    }

    var inviteURL: URL? {
        me.map { URL(string: "https://musq.app/f/\($0.code)")! }
    }

    /// The weekly board: friends and the member, most workouts first, then
    /// the longest streak, then name.
    var board: [(id: String, displayName: String, emoji: String, week: FriendWeek, isMe: Bool)] {
        var rows = friends.map { (id: $0.id, displayName: $0.displayName, emoji: $0.emoji, week: $0.week, isMe: false) }
        if let me, let week = FriendsActivity.shared.currentWeek(share: me.share) {
            rows.append((id: "me", displayName: me.displayName, emoji: me.emoji,
                         week: FriendWeek(workouts: week.workouts, streak: week.streak, goalPct: week.goalPct), isMe: true))
        }
        return rows.sorted {
            if $0.week.workouts != $1.week.workouts { return $0.week.workouts > $1.week.workouts }
            if $0.week.streak != $1.week.streak { return $0.week.streak > $1.week.streak }
            return $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
        }
    }

    func friend(_ id: String) -> Friend? { friends.first { $0.id == id } }

    /// The newest nudge not dismissed yet, for the Friends tab's banner.
    var currentNudge: FriendNudge? { inbox.first { !dismissedNudges.contains($0.id) } }

    func dismissNudge(_ id: String) { dismissedNudges.insert(id) }
    func markNudgedBack(_ id: String) { nudgedBack.insert(id) }

    // MARK: Sync

    /// Syncs everything; joins a sync already running. Delivered nudges go
    /// to FriendsInbox, then the member's new activity is posted.
    func refresh() async {
        if let refreshTask { return await refreshTask.value }
        let task = Task { await self.runRefresh() }
        refreshTask = task
        await task.value
        refreshTask = nil
    }

    private func runRefresh() async {
        #if DEBUG
        if usesSampleData {
            state = .ready
            if !sampleBannerShown, let first = inbox.first {
                sampleBannerShown = true
                FriendsInbox.shared.showSample(first)
            }
            return
        }
        #endif
        guard isSignedIn else { signedOut(); return }
        if me == nil, state != .needsProfile { state = .loading }
        isRefreshing = true
        defer { isRefreshing = false }
        do {
            let response = try await call("friendsSync", FriendsEmpty(), as: FriendsSyncResponse.self)
            apply(response)
            if !response.inbox.isEmpty {
                let fresh = response.inbox.filter { nudge in !(friend(nudge.fromId)?.muted ?? false) }
                inbox.insert(contentsOf: fresh.sorted { $0.createdAt > $1.createdAt }, at: 0)
                if inbox.count > 50 { inbox.removeLast(inbox.count - 50) }
                await FriendsInbox.shared.deliver(fresh)
            }
            if me != nil {
                await FriendsActivity.shared.postIfNeeded()
                await loadFeed(reset: true)
            }
        } catch {
            let mapped = Self.map(error)
            if mapped == .notSignedIn { signedOut(); return }
            // Keep what's on screen after a failed later sync.
            if me == nil, state != .needsProfile { state = .failed(mapped.message) }
        }
    }

    private func apply(_ response: FriendsSyncResponse) {
        me = response.me
        friends = response.friends
        incoming = response.incoming
        outgoing = response.outgoing
        state = response.me == nil ? .needsProfile : .ready
    }

    /// Clears everything (signed out, or the account deleted). Call it from
    /// AccountService when the member signs out.
    func signedOut() {
        me = nil
        friends = []
        incoming = []
        outgoing = []
        feed = []
        feedCursor = nil
        feedHasMore = false
        inbox = []
        dismissedNudges = []
        nudgedBack = []
        feedLoaded = false
        feedGeneration += 1
        state = .signedOut
        FriendsActivity.shared.forget()
        FriendsInbox.shared.clearDelivered()
        // Friends' photos (memory and Caches/friend-photos) go with the
        // account, whether or not the tab was opened in this launch.
        if !usesSampleData { FriendsPhotoService.shared.clear() }
    }

    // MARK: Profile

    /// A name the server would refuse, as the reason; nil when it looks fine.
    /// The server checks again.
    static func nameProblem(_ raw: String) -> String? {
        let name = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty { return String(localized: "Enter a name.", comment: "Friends name check") }
        if name.count > FriendsCatalog.nameLimit {
            return String(localized: "Use \(FriendsCatalog.nameLimit) characters or fewer.", comment: "Friends name check")
        }
        let lower = name.lowercased()
        let link = lower.contains("http") || lower.contains("www.") || lower.contains("@")
            || lower.range(of: #"[a-z0-9-]+\.(com|net|org|vn|io|app|me|co)\b"#, options: .regularExpression) != nil
        let digits = name.filter(\.isNumber).count
        if link || digits >= 7 {
            return String(localized: "No links, emails or phone numbers.", comment: "Friends name check")
        }
        // English words after folding accents; Vietnamese ones with their
        // tones, as whole words, as the server matches them (toneless, they
        // collide with ordinary names: "Bưởi", "Anh Lớn").
        let folded = lower.folding(options: [.diacriticInsensitive], locale: nil)
        let words = Set(folded.split { !$0.isLetter && !$0.isNumber }.map(String.init))
        let squashed = folded.filter { $0.isLetter }
        let viText = " " + lower.precomposedStringWithCanonicalMapping
            .split { !$0.isLetter && !$0.isNumber }.joined(separator: " ") + " "
        if englishBanned.contains(where: { words.contains($0) || ($0.count >= 5 && squashed.contains($0)) })
            || vietnameseBanned.contains(where: { viText.contains(" \($0) ") }) {
            return String(localized: "Pick another name.", comment: "Friends name check")
        }
        return nil
    }

    /// Short lists; the server keeps the full ones (functions/src/friendsRules.ts).
    private static let englishBanned: Set<String> = [
        "fuck", "fucker", "shit", "bitch", "cunt", "dick", "pussy", "nigger", "nigga", "faggot", "whore", "slut",
        "rape", "nazi", "porn", "sex",
    ]
    private static let vietnameseBanned: [String] = [
        "địt", "đụ", "lồn", "cặc", "buồi", "đéo", "đĩ", "dcm", "đcm", "đm", "dmm", "đmm", "vcl", "vkl", "vl",
        "clgt", "cmm", "óc chó", "mẹ mày", "con chó", "thằng chó",
    ].map(\.precomposedStringWithCanonicalMapping)

    @discardableResult
    func saveProfile(name: String, emoji: String, share: FriendShare, regenerateCode: Bool = false) async throws -> FriendMe {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if Self.nameProblem(trimmed) != nil { throw FriendsError.invalidName }
        // Unchanged when it isn't a catalog avatar the server would take
        // (never a silent swap to the default after the member's pick).
        let pick = FriendsCatalog.avatar(emoji) ?? me.flatMap { FriendsCatalog.avatar($0.emoji) } ?? FriendsCatalog.defaultEmoji
        #if DEBUG
        if usesSampleData {
            let code = regenerateCode || me == nil ? Self.sampleCode() : me!.code
            let saved = FriendMe(displayName: trimmed, emoji: pick, code: code, share: share)
            me = saved
            state = .ready
            return saved
        }
        #endif
        let response = try await call("friendsProfileSet",
                                      FriendsProfileSetRequest(displayName: trimmed, emoji: pick, share: share,
                                                               regenerateCode: regenerateCode ? true : nil),
                                      as: FriendsProfileSetResponse.self)
        let first = me == nil
        let shareChanged = me?.share != response.me.share
        me = response.me
        state = .ready
        if first { await refresh() } else if shareChanged { await FriendsActivity.shared.postIfNeeded(force: true) }
        return response.me
    }

    // MARK: Friends

    /// Sends a request to the code's owner (a code or a pasted invite link).
    @discardableResult
    func add(code raw: String) async throws -> FriendRequestStatus {
        guard let code = FriendsCatalog.normalizedCode(raw) else { throw FriendsError.notFound }
        if code == me?.code { throw FriendsError.isSelf }
        #if DEBUG
        if usesSampleData {
            outgoing.insert(FriendRequest(id: "out-\(code)", displayName: "Friend \(code.prefix(3))", emoji: "🙂",
                                          createdAt: FriendsTime.string(Date())), at: 0)
            return .sent
        }
        #endif
        guard outgoing.count < FriendsCatalog.maxPendingOutgoing else { throw FriendsError.limit }
        let response = try await call("friendsRequest", FriendsCodeRequest(code: code), as: FriendsRequestResponse.self,
                                      context: .code)
        await refresh()
        return response.status
    }

    func respond(_ request: FriendRequest, accept: Bool) async throws {
        #if DEBUG
        if usesSampleData {
            incoming.removeAll { $0.id == request.id }
            if accept {
                friends.append(Friend(id: "f-\(request.id)", displayName: request.displayName, emoji: request.emoji,
                                      since: FriendsTime.string(Date()), muted: false,
                                      week: FriendWeek(workouts: 0, streak: 0, goalPct: nil), lastActive: nil))
            }
            return
        }
        #endif
        _ = try await call("friendsRespond", FriendsRespondRequest(requestId: request.id, accept: accept),
                           as: FriendsEmpty.self)
        incoming.removeAll { $0.id == request.id }
        if accept { await refresh(); await loadFeed(reset: true) }
    }

    func remove(_ friend: Friend) async throws {
        if !usesSampleData {
            _ = try await call("friendsRemove", FriendsIdRequest(friendId: friend.id), as: FriendsEmpty.self)
        }
        dropLocally(friend.id)
        FriendsPhotoService.shared.forget(authorId: friend.id)
    }

    /// Removes them, hides them and refuses their future requests.
    func block(_ friend: Friend) async throws {
        if !usesSampleData {
            _ = try await call("friendsBlock", FriendsIdRequest(friendId: friend.id), as: FriendsEmpty.self)
        }
        dropLocally(friend.id)
        FriendsPhotoService.shared.forget(authorId: friend.id)
    }

    /// Blocks the author of a comment on a photo post: a friend, or a friend
    /// of the poster the member isn't friends with (whose `authorId` is an
    /// opaque id only the server can resolve, from the comment).
    func block(commentAuthor comment: FriendPhotoComment, on post: FriendPhotoPost) async throws {
        guard !comment.isMine else { return }
        if !usesSampleData {
            _ = try await call("friendsBlock", FriendsCommentBlockRequest(postId: post.id, commentId: comment.id),
                               as: FriendsEmpty.self)
        }
        // A friend's author id is their friend id; anyone else's matches nothing here.
        dropLocally(comment.authorId)
        FriendsPhotoService.shared.forget(authorId: comment.authorId)
    }

    /// Blocks a person who sent a request, without accepting it.
    func block(request: FriendRequest) async throws {
        if !usesSampleData {
            // A request's sender is blocked by the request id's owner on the
            // server: friendsBlock accepts a request id as friendId too.
            _ = try await call("friendsBlock", FriendsIdRequest(friendId: request.id), as: FriendsEmpty.self)
        }
        incoming.removeAll { $0.id == request.id }
    }

    func report(_ friend: Friend, reason: FriendReportReason) async throws {
        if usesSampleData { return }
        _ = try await call("friendsReport", FriendsReportRequest(friendId: friend.id, reason: reason), as: FriendsEmpty.self)
    }

    /// Reports the person behind an incoming request (the server takes a
    /// request id as friendId too), without accepting it.
    func report(request: FriendRequest, reason: FriendReportReason) async throws {
        if usesSampleData { return }
        _ = try await call("friendsReport", FriendsReportRequest(friendId: request.id, reason: reason), as: FriendsEmpty.self)
    }

    /// Mutes or unmutes their nudges.
    func setMuted(_ friend: Friend, _ muted: Bool) async throws {
        if !usesSampleData {
            _ = try await call("friendsMute", FriendsMuteRequest(friendId: friend.id, muted: muted), as: FriendsEmpty.self)
        }
        if let index = friends.firstIndex(where: { $0.id == friend.id }) { friends[index].muted = muted }
    }

    private func dropLocally(_ id: String) {
        friends.removeAll { $0.id == id }
        feed.removeAll { $0.friendId == id }
        inbox.removeAll { $0.fromId == id }
    }

    // MARK: Nudges

    @ObservationIgnored private var sampleNudged: Set<String> = []
    @ObservationIgnored private var sampleBannerShown = false

    func nudge(_ friend: Friend, kind: FriendNudgeKind) async throws {
        #if DEBUG
        if usesSampleData {
            guard sampleNudged.insert(friend.id).inserted else { throw FriendsError.alreadyNudged }
            return
        }
        #endif
        _ = try await call("friendsNudge", FriendsNudgeRequest(friendId: friend.id, kind: kind), as: FriendsEmpty.self,
                           context: .nudge)
    }

    // MARK: Feed

    /// The first page (`reset`), or the next one after what's shown.
    func loadFeed(reset: Bool = false) async {
        #if DEBUG
        if usesSampleData { return }
        #endif
        guard isSignedIn, me != nil else { return }
        if !reset { guard feedHasMore, !feedLoading else { return } }
        let generation = reset ? feedGeneration + 1 : feedGeneration
        if reset { feedGeneration = generation }
        feedLoading = true
        defer { if generation == feedGeneration { feedLoading = false } }
        do {
            let response = try await call("friendsFeed", FriendsFeedRequest(before: reset ? nil : feedCursor),
                                          as: FriendsFeedResponse.self)
            guard generation == feedGeneration else { return }
            if reset {
                feed = response.items
            } else {
                let known = Set(feed.map(\.id))
                feed.append(contentsOf: response.items.filter { !known.contains($0.id) })
            }
            feedCursor = response.next
            feedHasMore = response.next != nil
            feedLoaded = true
        } catch {
            if Self.map(error) == .notSignedIn { signedOut(); return }
            if generation == feedGeneration { feedLoaded = true }
        }
    }

    func loadMore() async { await loadFeed(reset: false) }

    /// Sets the member's reaction (nil takes it away); shown at once and
    /// put back if the server refuses.
    func react(_ item: FriendFeedItem, emoji: String?) async throws {
        guard let index = feed.firstIndex(where: { $0.id == item.id }) else { return }
        if let emoji, !FriendsCatalog.reactions.contains(emoji) { return }
        let before = feed[index]
        var after = before
        if let old = before.myReaction { after.reactions[old] = max(0, (after.reactions[old] ?? 0) - 1) }
        if let emoji { after.reactions[emoji, default: 0] += 1 }
        after.reactions = after.reactions.filter { $0.value > 0 }
        after.myReaction = emoji
        feed[index] = after
        if usesSampleData { return }
        do {
            _ = try await call("friendsReact", FriendsReactRequest(eventId: item.id, emoji: emoji), as: FriendsEmpty.self)
        } catch {
            if let i = feed.firstIndex(where: { $0.id == item.id }) { feed[i] = before }
            throw Self.map(error)
        }
    }

    /// Taps a reaction: sets it, or takes it away when it's already the
    /// member's.
    func toggle(_ item: FriendFeedItem, emoji: String) async throws {
        try await react(item, emoji: item.myReaction == emoji ? nil : emoji)
    }

    // MARK: Posting (FriendsActivity)

    func post(_ request: FriendsPostRequest) async throws {
        if usesSampleData { return }
        _ = try await call("friendsPost", request, as: FriendsEmpty.self)
    }

    // MARK: Calls

    /// What a bare not-found or resource-exhausted means: a friend code
    /// (`code`), a nudge (`nudge`), or a friend/request/item gone (`plain`).
    nonisolated enum CallContext: Sendable { case plain, nudge, code }

    private func call<Request: Encodable & Sendable, Response: Decodable & Sendable>(
        _ name: String, _ request: Request, as: Response.Type, context: CallContext = .plain
    ) async throws -> Response {
        guard let functions = functionsInstance() else { throw FriendsError.unavailable }
        guard Auth.auth().currentUser != nil else { throw FriendsError.notSignedIn }
        var callable = functions.httpsCallable(name, requestAs: Request.self, responseAs: Response.self)
        callable.timeoutInterval = 30
        do {
            return try await callable.call(request)
        } catch {
            throw Self.map(error, context: context)
        }
    }

    /// The same Functions instance AIService set up (Firebase keeps one per
    /// app and region), once Firebase is configured.
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

    /// The server's errors as short reasons. The server's `message` names
    /// the reason where a code alone can't ("self", "limit", "already-nudged",
    /// "nudge-limit", "name"); a bare code falls back on the call's context.
    nonisolated static func map(_ error: Error, context: CallContext = .plain) -> FriendsError {
        if let known = error as? FriendsError { return known }
        let ns = error as NSError
        if ns.domain == NSURLErrorDomain { return .offline }
        if let underlying = ns.userInfo[NSUnderlyingErrorKey] as? NSError, underlying.domain == NSURLErrorDomain {
            return .offline
        }
        guard ns.domain == FunctionsErrorDomain, let code = FunctionsErrorCode(rawValue: ns.code) else {
            return .unavailable
        }
        let message = ns.localizedDescription.lowercased()
        switch code {
        case .unauthenticated: return message == "app-check-required" ? .deviceNotVerified : .notSignedIn
        case .notFound: return context == .code ? .notFound : .gone
        case .resourceExhausted:
            // Server reasons: friends-nudged-today, friends-nudge-limit,
            // friends-tries-limit, friends-limit (functions/src/reasons.ts).
            if message.contains("tries-limit") { return .tooManyTries }
            if message.contains("already") || message.contains("nudged-today") { return .alreadyNudged }
            if message.contains("nudge-limit") { return .nudgeLimit }
            if message.contains("limit") { return context == .nudge ? .nudgeLimit : .limit }
            return context == .nudge ? .alreadyNudged : .limit
        case .invalidArgument, .failedPrecondition, .alreadyExists, .permissionDenied:
            if message.contains("self") { return .isSelf }
            if message.contains("limit") { return .limit }
            if message.contains("name") { return .invalidName }
            if message.contains("blocked") { return .notFound }
            return .server(message)
        case .deadlineExceeded, .unavailable: return .offline
        default: return .unavailable
        }
    }

    // MARK: - Sample data (DEBUG)

    var usesSampleData: Bool {
        #if DEBUG
        return Self.usesSample
        #else
        return false
        #endif
    }

    #if DEBUG
    static var usesSample: Bool {
        ProcessInfo.processInfo.arguments.contains("-friends.sample")
            || UserDefaults.standard.bool(forKey: "friends.sample")
    }

    private static func sampleCode() -> String {
        String((0..<FriendsCatalog.codeLength).map { _ in FriendsCatalog.codeAlphabet.randomElement()! })
    }

    private func loadSample() {
        let now = Date()
        func ago(_ minutes: Double) -> String { FriendsTime.string(now.addingTimeInterval(-minutes * 60)) }
        func day(_ back: Int) -> String {
            DayKey.make(Calendar.current.date(byAdding: .day, value: -back, to: now) ?? now)
        }
        me = FriendMe(displayName: "Cường", emoji: "🔥", code: "MUSQ27", share: FriendShare())
        friends = [
            Friend(id: "s-linh", displayName: "Linh Nguyễn", emoji: "🦊", since: ago(60 * 24 * 40), muted: false,
                   week: FriendWeek(workouts: 4, streak: 3, goalPct: 62), lastActive: ago(35)),
            Friend(id: "s-alex", displayName: "Alex Carter", emoji: "🦁", since: ago(60 * 24 * 21), muted: false,
                   week: FriendWeek(workouts: 3, streak: 2, goalPct: nil), lastActive: ago(60 * 5)),
            Friend(id: "s-minh", displayName: "Minh Trần", emoji: "🐯", since: ago(60 * 24 * 12), muted: false,
                   week: FriendWeek(workouts: 5, streak: 5, goalPct: 81), lastActive: ago(12)),
            Friend(id: "s-sarah", displayName: "Sarah Kim", emoji: "🧘", since: ago(60 * 24 * 9), muted: true,
                   week: FriendWeek(workouts: 1, streak: 0, goalPct: nil), lastActive: ago(60 * 30)),
            Friend(id: "s-huy", displayName: "Huy Phạm", emoji: "🏋️", since: ago(60 * 24 * 3), muted: false,
                   week: FriendWeek(workouts: 2, streak: 1, goalPct: 34), lastActive: ago(60 * 26)),
        ]
        incoming = [
            FriendRequest(id: "s-req-thao", displayName: "Thảo Vy", emoji: "🍀", createdAt: ago(90)),
            FriendRequest(id: "s-req-jake", displayName: "Jake Miller", emoji: "🚀", createdAt: ago(60 * 20)),
        ]
        outgoing = [FriendRequest(id: "s-out-an", displayName: "An Lê", emoji: "🐼", createdAt: ago(60 * 8))]
        feed = [
            FriendFeedItem(id: "s-e1", friendId: "s-minh", displayName: "Minh Trần", emoji: "🐯", kind: "workout",
                           day: day(0), createdAt: ago(14),
                           data: FriendEventData(title: "Chest · Triceps", minutes: 52, sets: 18, groups: ["chest", "triceps"]),
                           reactions: ["🔥": 3, "💪": 1], myReaction: "🔥"),
            FriendFeedItem(id: "s-e2", friendId: "s-minh", displayName: "Minh Trần", emoji: "🐯", kind: "pr",
                           day: day(0), createdAt: ago(15),
                           data: FriendEventData(exercise: "Barbell Bench Press", kg: 85), reactions: ["👏": 2]),
            FriendFeedItem(id: "s-e3", friendId: "s-linh", displayName: "Linh Nguyễn", emoji: "🦊", kind: "water",
                           day: day(0), createdAt: ago(40), data: FriendEventData(), reactions: ["❤️": 1]),
            FriendFeedItem(id: "s-e4", friendId: "me", displayName: "Cường", emoji: "🔥", kind: "workout",
                           day: day(0), createdAt: ago(95),
                           data: FriendEventData(title: "Back · Biceps", minutes: 47, sets: 16, groups: ["back", "biceps"]),
                           reactions: ["💪": 2, "🔥": 1]),
            FriendFeedItem(id: "s-e5", friendId: "s-linh", displayName: "Linh Nguyễn", emoji: "🦊", kind: "streak",
                           day: day(1), createdAt: ago(60 * 22), data: FriendEventData(days: 7), reactions: ["🔥": 4]),
            FriendFeedItem(id: "s-e6", friendId: "s-huy", displayName: "Huy Phạm", emoji: "🏋️", kind: "meals",
                           day: day(1), createdAt: ago(60 * 25), data: FriendEventData(count: 3)),
            FriendFeedItem(id: "s-e7", friendId: "s-alex", displayName: "Alex Carter", emoji: "🦁", kind: "workout",
                           day: day(1), createdAt: ago(60 * 28),
                           data: FriendEventData(title: "Quads · Glutes · Hamstrings", minutes: 61, sets: 21,
                                                 groups: ["quads", "glutes", "hamstrings"]),
                           reactions: ["💪": 2]),
            FriendFeedItem(id: "s-e8", friendId: "s-alex", displayName: "Alex Carter", emoji: "🦁", kind: "pr",
                           day: day(1), createdAt: ago(60 * 28 + 1),
                           data: FriendEventData(exercise: "Barbell Back Squat", kg: 120)),
            FriendFeedItem(id: "s-e9", friendId: "s-sarah", displayName: "Sarah Kim", emoji: "🧘", kind: "workout",
                           day: day(3), createdAt: ago(60 * 24 * 3),
                           data: FriendEventData(title: "Shoulders · Abs & Core", minutes: 38, sets: 12,
                                                 groups: ["shoulders", "abs"])),
        ]
        inbox = [
            FriendNudge(id: "s-n1", fromId: "s-minh", fromName: "Minh Trần", fromEmoji: "🐯", kind: .train, createdAt: ago(20)),
            FriendNudge(id: "s-n2", fromId: "s-linh", fromName: "Linh Nguyễn", fromEmoji: "🦊", kind: .water, createdAt: ago(70)),
        ]
        feedLoaded = true
        state = .ready
    }
    #endif
}
