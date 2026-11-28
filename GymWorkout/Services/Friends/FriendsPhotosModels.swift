//
//  FriendsPhotosModels.swift
//  GymWorkout
//
//  MUSQ Friends photo check-ins (2026-11-28, owner: "Locket-like" casual
//  photos, not the AI goal photo): the wire types of the photo callables
//  and the documents the app reads live from Firestore.
//
//  Readable documents (firestore.rules: only request.auth.uid == {uid}).
//  The server fans out one copy per reader (the poster + their friends,
//  ≤ 51) and removes copies on delete, unfriend, block, account deletion
//  and when a post is hidden after reports. No uid of anyone else is in
//  them: `authorId` is the opaque friend id this reader already knows
//  (friendships/{pairId} id, the same as `Friend.id`), "me" for the
//  reader's own, and for a commenter who isn't the reader's friend an
//  opaque per-reader hash.
//
//  friendInbox/{uid}/posts/{postId}
//    id: String (= postId)          authorId: String ("me" for own)
//    isMine: Bool                   displayName: String   emoji: String
//    caption: String?  (≤ 120)      tag: String? (≤ 60, "Chest · 25 min")
//    imagePath: String ("friendPhotos/{postId}.jpg", Cloud Storage)
//    url: String?  (optional https URL; used instead of imagePath if set)
//    width: Int?, height: Int?      (pixels, optional: the card's aspect)
//    createdAt: Timestamp | ISO 8601 string
//    expireAt:  Timestamp | ISO 8601 string (createdAt + 30 days, TTL)
//    reactions: {emoji: count}      myReaction: String? (this reader's)
//    commentCount: Int              hidden: Bool? (true: hidden after
//                                   reports; only the poster's copy keeps
//                                   it, shown to them marked)
//
//  friendInbox/{uid}/posts/{postId}/comments/{commentId}
//    id, postId, authorId, isMine, displayName, emoji,
//    text (≤ 300), createdAt, hidden?
//
//  Callables return the same shapes as JSON with ISO 8601 times.
//  Photos: the image is read with the reader's Firebase ID token from
//  Cloud Storage (storage.rules allow a read of friendPhotos/{postId}.jpg
//  when friendInbox/{uid}/posts/{postId} exists), or from `url`.
//  Never Apple Health data, never public, never to ads.
//

import FirebaseFirestore
import Foundation

nonisolated enum FriendsPhotoLimits {
    static let captionLimit = 120
    static let commentLimit = 300
    static let tagLimit = 60
    static let maxPixelSide: CGFloat = 1080
    static let jpegQuality: CGFloat = 0.75
    /// The JPEG's bytes, before base64 (≈ 2 MB on the wire).
    static let maxBytes = 1_500_000
    static let postsPerDay = 10
    static let commentsPerDay = 100
    static let reactionsPerDay = 300
    /// A photo rings its poster's avatar this long.
    static let storyWindow: TimeInterval = 24 * 60 * 60
    /// Posts leave the feed after this (the server's TTL; the app hides
    /// them too, since TTL deletes can lag a day).
    static let retention: TimeInterval = 30 * 24 * 60 * 60
    static let feedPageSize = 50
    static let commentsPageSize = 200
}

nonisolated enum FriendPhotoReportReason: String, Codable, CaseIterable, Identifiable, Sendable {
    case inappropriate
    /// The server calls it "abusive" (friendsPhotosRules.ts PHOTO_REPORT_REASONS).
    case harassment = "abusive"
    case spam
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .inappropriate: return String(localized: "Inappropriate", comment: "Friends photo report reason")
        case .harassment: return String(localized: "Bullying or harassment", comment: "Friends photo report reason")
        case .spam: return String(localized: "Spam", comment: "Friends photo report reason")
        case .other: return String(localized: "Something else", comment: "Friends photo report reason")
        }
    }
}

// MARK: - Read

nonisolated struct FriendPhotoPost: Codable, Hashable, Identifiable, Sendable {
    var id: String
    /// The friend's id (`Friend.id`), or "me".
    var authorId: String
    var isMine: Bool
    var displayName: String
    var emoji: String
    var caption: String?
    var tag: String?
    var imagePath: String?
    var url: String?
    var width: Int?
    var height: Int?
    var createdAt: String
    var expireAt: String?
    var reactions: [String: Int]
    var myReaction: String?
    var commentCount: Int
    var hidden: Bool

    var createdDate: Date? { FriendsTime.date(createdAt) }
    var expireDate: Date? { expireAt.flatMap(FriendsTime.date) }
    /// width / height, when the server sent both.
    var aspectRatio: CGFloat? {
        guard let width, let height, width > 0, height > 0 else { return nil }
        return CGFloat(width) / CGFloat(height)
    }

    /// Posted in the last 24 h: rings the poster's avatar.
    func isStory(now: Date = Date()) -> Bool {
        guard let date = createdDate else { return false }
        return now.timeIntervalSince(date) < FriendsPhotoLimits.storyWindow
    }

    func isExpired(now: Date = Date()) -> Bool {
        if let expireDate { return expireDate <= now }
        guard let date = createdDate else { return false }
        return now.timeIntervalSince(date) >= FriendsPhotoLimits.retention
    }

    init(id: String, authorId: String, isMine: Bool, displayName: String, emoji: String, caption: String? = nil,
         tag: String? = nil, imagePath: String? = nil, url: String? = nil, width: Int? = nil, height: Int? = nil,
         createdAt: String, expireAt: String? = nil, reactions: [String: Int] = [:], myReaction: String? = nil,
         commentCount: Int = 0, hidden: Bool = false) {
        self.id = id
        self.authorId = authorId
        self.isMine = isMine
        self.displayName = displayName
        self.emoji = emoji
        self.caption = caption
        self.tag = tag
        self.imagePath = imagePath
        self.url = url
        self.width = width
        self.height = height
        self.createdAt = createdAt
        self.expireAt = expireAt
        self.reactions = reactions
        self.myReaction = myReaction
        self.commentCount = commentCount
        self.hidden = hidden
    }

    /// Lenient: missing optional fields read as empty.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        authorId = (try? c.decodeIfPresent(String.self, forKey: .authorId)) ?? "me"
        isMine = (try? c.decodeIfPresent(Bool.self, forKey: .isMine)) ?? (authorId == "me")
        displayName = (try? c.decodeIfPresent(String.self, forKey: .displayName)) ?? ""
        emoji = (try? c.decodeIfPresent(String.self, forKey: .emoji)) ?? FriendsCatalog.defaultEmoji
        caption = try? c.decodeIfPresent(String.self, forKey: .caption)
        tag = try? c.decodeIfPresent(String.self, forKey: .tag)
        imagePath = try? c.decodeIfPresent(String.self, forKey: .imagePath)
        url = try? c.decodeIfPresent(String.self, forKey: .url)
        width = try? c.decodeIfPresent(Int.self, forKey: .width)
        height = try? c.decodeIfPresent(Int.self, forKey: .height)
        createdAt = (try? c.decodeIfPresent(String.self, forKey: .createdAt)) ?? FriendsTime.string(Date())
        expireAt = try? c.decodeIfPresent(String.self, forKey: .expireAt)
        reactions = (try? c.decodeIfPresent([String: Int].self, forKey: .reactions)) ?? [:]
        myReaction = try? c.decodeIfPresent(String.self, forKey: .myReaction)
        commentCount = (try? c.decodeIfPresent(Int.self, forKey: .commentCount)) ?? 0
        hidden = (try? c.decodeIfPresent(Bool.self, forKey: .hidden)) ?? false
    }

    /// A live Firestore document; nil when it lacks what a card needs.
    init?(documentId: String, data: [String: Any]) {
        guard let created = FriendsPhotoFields.time(data["createdAt"]) else { return nil }
        let author = data["authorId"] as? String ?? "me"
        self.init(id: data["id"] as? String ?? documentId,
                  authorId: author,
                  isMine: data["isMine"] as? Bool ?? (author == "me"),
                  displayName: data["displayName"] as? String ?? "",
                  emoji: data["emoji"] as? String ?? FriendsCatalog.defaultEmoji,
                  caption: FriendsPhotoFields.text(data["caption"]),
                  tag: FriendsPhotoFields.text(data["tag"]),
                  imagePath: FriendsPhotoFields.text(data["imagePath"]),
                  url: FriendsPhotoFields.text(data["url"]),
                  width: FriendsPhotoFields.int(data["width"]),
                  height: FriendsPhotoFields.int(data["height"]),
                  createdAt: created,
                  expireAt: FriendsPhotoFields.time(data["expireAt"]),
                  reactions: FriendsPhotoFields.counts(data["reactions"]),
                  myReaction: FriendsPhotoFields.text(data["myReaction"]),
                  commentCount: FriendsPhotoFields.int(data["commentCount"]) ?? 0,
                  hidden: data["hidden"] as? Bool ?? false)
    }

    private enum CodingKeys: String, CodingKey {
        case id, authorId, isMine, displayName, emoji, caption, tag, imagePath, url, width, height, createdAt,
             expireAt, reactions, myReaction, commentCount, hidden
    }
}

nonisolated struct FriendPhotoComment: Codable, Hashable, Identifiable, Sendable {
    var id: String
    var postId: String
    var authorId: String
    var isMine: Bool
    var displayName: String
    var emoji: String
    var text: String
    var createdAt: String
    var hidden: Bool

    var createdDate: Date? { FriendsTime.date(createdAt) }

    init(id: String, postId: String, authorId: String, isMine: Bool, displayName: String, emoji: String,
         text: String, createdAt: String, hidden: Bool = false) {
        self.id = id
        self.postId = postId
        self.authorId = authorId
        self.isMine = isMine
        self.displayName = displayName
        self.emoji = emoji
        self.text = text
        self.createdAt = createdAt
        self.hidden = hidden
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        postId = (try? c.decodeIfPresent(String.self, forKey: .postId)) ?? ""
        authorId = (try? c.decodeIfPresent(String.self, forKey: .authorId)) ?? "me"
        isMine = (try? c.decodeIfPresent(Bool.self, forKey: .isMine)) ?? (authorId == "me")
        displayName = (try? c.decodeIfPresent(String.self, forKey: .displayName)) ?? ""
        emoji = (try? c.decodeIfPresent(String.self, forKey: .emoji)) ?? FriendsCatalog.defaultEmoji
        text = (try? c.decodeIfPresent(String.self, forKey: .text)) ?? ""
        createdAt = (try? c.decodeIfPresent(String.self, forKey: .createdAt)) ?? FriendsTime.string(Date())
        hidden = (try? c.decodeIfPresent(Bool.self, forKey: .hidden)) ?? false
    }

    init?(documentId: String, postId: String, data: [String: Any]) {
        guard let created = FriendsPhotoFields.time(data["createdAt"]),
              let text = data["text"] as? String else { return nil }
        let author = data["authorId"] as? String ?? "me"
        self.init(id: data["id"] as? String ?? documentId,
                  postId: data["postId"] as? String ?? postId,
                  authorId: author,
                  isMine: data["isMine"] as? Bool ?? (author == "me"),
                  displayName: data["displayName"] as? String ?? "",
                  emoji: data["emoji"] as? String ?? FriendsCatalog.defaultEmoji,
                  text: text,
                  createdAt: created,
                  hidden: data["hidden"] as? Bool ?? false)
    }

    private enum CodingKeys: String, CodingKey {
        case id, postId, authorId, isMine, displayName, emoji, text, createdAt, hidden
    }
}

/// A poster with a photo in the last 24 h: the ring on their avatar and the
/// row at the top of the feed.
nonisolated struct FriendPhotoStory: Identifiable, Hashable, Sendable {
    /// The friend's id, or "me".
    var authorId: String
    var isMine: Bool
    var displayName: String
    var emoji: String
    /// Their last-24-h photos, oldest first (the order they play in).
    var posts: [FriendPhotoPost]
    /// A photo newer than the last one this member opened (never for the
    /// member's own).
    var hasUnseen: Bool

    var id: String { authorId }
    var latest: FriendPhotoPost? { posts.last }
}

// MARK: - Wire

nonisolated struct FriendsPhotoPostRequest: Encodable, Sendable {
    /// JPEG, ≤ 1080 px on the long side, no metadata.
    var imageBase64: String
    var caption: String?
    var tag: String?
    var width: Int
    var height: Int
}

nonisolated struct FriendsPhotoPostResponse: Decodable, Sendable {
    var post: FriendPhotoPost
}

nonisolated struct FriendsPhotoIdRequest: Encodable, Sendable {
    var postId: String
}

nonisolated struct FriendsPhotoReactRequest: Encodable, Sendable {
    var postId: String
    /// Null takes the member's reaction away.
    var emoji: String?

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(postId, forKey: .postId)
        try c.encode(emoji, forKey: .emoji)
    }

    private enum CodingKeys: String, CodingKey { case postId, emoji }
}

nonisolated struct FriendsCommentAddRequest: Encodable, Sendable {
    var postId: String
    var text: String
}

nonisolated struct FriendsCommentAddResponse: Decodable, Sendable {
    var comment: FriendPhotoComment
}

nonisolated struct FriendsCommentDeleteRequest: Encodable, Sendable {
    var postId: String
    var commentId: String
}

/// friendsBlock for a comment's author (friends.ts block: {postId, commentId}
/// instead of friendId).
nonisolated struct FriendsCommentBlockRequest: Encodable, Sendable {
    var postId: String
    var commentId: String
}

nonisolated struct FriendsPhotoReportRequest: Encodable, Sendable {
    var postId: String
    var commentId: String?
    var reason: FriendPhotoReportReason
}

// MARK: - Errors

nonisolated enum FriendsPhotoError: Error, Equatable, Sendable {
    /// Moderation refused the photo.
    case photoRejected
    /// Moderation refused the caption or comment.
    case textRejected
    case postLimit
    case commentLimit
    /// 300 reaction changes today (the server's limit).
    case reactionLimit
    /// Not friends with the poster (any more).
    case notFriends
    /// The post or comment was deleted or expired.
    case gone
    case tooLarge
    case unreadableImage
    case empty
    case tooLong
    case friends(FriendsError)

    var message: String {
        switch self {
        case .photoRejected: return String(localized: "This photo can't be shared.", comment: "Friends photo error: moderation")
        case .textRejected: return String(localized: "That can't be posted. Try other words.", comment: "Friends photo error: caption or comment refused")
        case .postLimit: return String(localized: "That's \(FriendsPhotoLimits.postsPerDay) photos today. More tomorrow.", comment: "Friends photo error: daily photo cap")
        case .commentLimit: return String(localized: "That's all the comments for today.", comment: "Friends photo error: daily comment cap")
        case .reactionLimit: return String(localized: "That's a lot of reactions today. Try again tomorrow.", comment: "Friends photo error: daily reaction cap")
        case .notFriends: return String(localized: "Only friends can do that.", comment: "Friends photo error")
        case .gone: return String(localized: "This post is gone.", comment: "Friends photo error: deleted or expired")
        case .tooLarge: return String(localized: "This photo is too big.", comment: "Friends photo error")
        case .unreadableImage: return String(localized: "This photo can't be read.", comment: "Friends photo error")
        case .empty: return String(localized: "Write something first.", comment: "Friends photo error: empty comment")
        case .tooLong: return String(localized: "That's too long.", comment: "Friends photo error: caption or comment too long")
        case .friends(let inner): return inner.message
        }
    }
}

// MARK: - Field reading (Firestore documents)

nonisolated enum FriendsPhotoFields {
    /// A Timestamp, Date or ISO 8601 string, as an ISO 8601 string.
    static func time(_ value: Any?) -> String? {
        if let stamp = value as? Timestamp { return FriendsTime.string(stamp.dateValue()) }
        if let date = value as? Date { return FriendsTime.string(date) }
        if let text = value as? String, FriendsTime.date(text) != nil { return text }
        return nil
    }

    static func text(_ value: Any?) -> String? {
        guard let text = value as? String else { return nil }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    static func int(_ value: Any?) -> Int? {
        if let int = value as? Int { return int }
        if let number = value as? NSNumber { return number.intValue }
        if let double = value as? Double { return Int(double) }
        return nil
    }

    static func counts(_ value: Any?) -> [String: Int] {
        guard let raw = value as? [String: Any] else { return [:] }
        var result: [String: Int] = [:]
        for (key, count) in raw { if let n = int(count), n > 0 { result[key] = n } }
        return result
    }
}
