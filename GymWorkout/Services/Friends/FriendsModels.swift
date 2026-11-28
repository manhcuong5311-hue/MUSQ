//
//  FriendsModels.swift
//  GymWorkout
//
//  MUSQ Friends v1 (2026-11-28): the wire types of the friends callables
//  (functions/src, region asia-southeast1) and the small fixed sets the
//  feature allows (avatar emojis, reactions, nudge kinds, report reasons).
//  Every type here is nonisolated and Sendable: Firebase encodes and decodes
//  it off the main actor. Times are ISO 8601 strings as the server sends
//  them; `date` helpers read them.
//
//  Only summaries of what the member logged in MUSQ go to the server, never
//  Apple Health data, calories, meal photos or body weight.
//

import Foundation

// MARK: - Fixed sets

nonisolated enum FriendsCatalog {
    /// The avatars a member can pick (no photos in v1): exactly the
    /// server's AVATAR_EMOJIS (functions/src/friendsRules.ts), spelled as it
    /// stores them, so a saved avatar matches its cell again.
    static let emojis: [String] = [
        "💪", "🔥", "🏋️", "🏃", "🚴", "🧘", "🥊", "⚡",
        "🦁", "🐯", "🐻", "🦊", "🐼", "🐨", "🦅", "🐺",
        "🦈", "🐉", "🌟", "🚀", "🎯", "🏆", "😎", "🤖",
    ]
    static let defaultEmoji = "💪"

    /// The catalog's spelling of `emoji`, with or without the variation
    /// selector (U+FE0F); nil when it isn't one of the avatars.
    static func avatar(_ emoji: String) -> String? {
        func bare(_ text: String) -> [UInt32] { text.unicodeScalars.map(\.value).filter { $0 != 0xFE0F } }
        let wanted = bare(emoji)
        return emojis.first { bare($0) == wanted }
    }

    /// The reactions a feed item takes, one per member, toggled.
    static let reactions: [String] = ["🔥", "💪", "👏", "❤️"]

    /// A friend code: 6 of A–Z and 2–9 without the look-alikes (0 O 1 I L).
    static let codeAlphabet = Set("ABCDEFGHJKMNPQRSTUVWXYZ23456789")
    static let codeLength = 6

    static let maxFriends = 50
    static let maxPendingOutgoing = 20
    static let nameLimit = 24

    /// "abc-123", " abc123 " or a pasted invite link, as the code it holds;
    /// nil when it can't be one.
    static func normalizedCode(_ raw: String) -> String? {
        var text = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = text.range(of: "/f/", options: .backwards) {
            text = String(text[range.upperBound...])
        }
        let code = String(text.uppercased().filter { $0.isLetter || $0.isNumber })
        guard code.count == codeLength, code.allSatisfy(codeAlphabet.contains) else { return nil }
        return code
    }
}

/// What a member shares with friends. Workouts and water on, meals and the
/// goal off, until they choose.
nonisolated struct FriendShare: Codable, Hashable, Sendable {
    var workouts = true
    var water = true
    var meals = false
    var goal = false
}

nonisolated enum FriendNudgeKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case train, water, meal, cheer

    var id: String { rawValue }

    /// The templated message; nothing else can be sent.
    var message: String {
        switch self {
        case .train: return String(localized: "Time to train! 💪", comment: "Friends nudge message")
        case .water: return String(localized: "Drink some water 💧", comment: "Friends nudge message")
        case .meal: return String(localized: "Log your meal 🍽️", comment: "Friends nudge message")
        case .cheer: return String(localized: "You've got this 🔥", comment: "Friends nudge message")
        }
    }

    /// The button's short label.
    var label: String {
        switch self {
        case .train: return String(localized: "Train", comment: "Friends nudge button")
        case .water: return String(localized: "Water", comment: "Friends nudge button")
        case .meal: return String(localized: "Meal", comment: "Friends nudge button")
        case .cheer: return String(localized: "Cheer", comment: "Friends nudge button")
        }
    }

    var emoji: String {
        switch self {
        case .train: return "💪"
        case .water: return "💧"
        case .meal: return "🍽️"
        case .cheer: return "🔥"
        }
    }
}

nonisolated enum FriendReportReason: String, Codable, CaseIterable, Identifiable, Sendable {
    case spam
    case abusiveName = "abusive-name"
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .spam: return String(localized: "Spam", comment: "Friends report reason")
        case .abusiveName: return String(localized: "Abusive name", comment: "Friends report reason")
        case .other: return String(localized: "Something else", comment: "Friends report reason")
        }
    }
}

nonisolated enum FriendEventKind: String, Codable, CaseIterable, Sendable {
    case workout, water, meals, streak, pr
}

// MARK: - Read from the server

/// The member's own friends profile.
nonisolated struct FriendMe: Codable, Hashable, Sendable {
    var displayName: String
    var emoji: String
    var code: String
    var share: FriendShare
}

nonisolated struct FriendWeek: Codable, Hashable, Sendable {
    var workouts: Int
    var streak: Int
    /// 0–100; nil when the friend doesn't share their goal.
    var goalPct: Int?
}

nonisolated struct Friend: Codable, Hashable, Identifiable, Sendable {
    var id: String
    var displayName: String
    var emoji: String
    var since: String
    var muted: Bool
    var week: FriendWeek
    var lastActive: String?

    var sinceDate: Date? { FriendsTime.date(since) }
    var lastActiveDate: Date? { lastActive.flatMap(FriendsTime.date) }
}

/// A friend request, incoming or outgoing: the other person.
nonisolated struct FriendRequest: Codable, Hashable, Identifiable, Sendable {
    var id: String
    var displayName: String
    var emoji: String
    var createdAt: String

    var createdDate: Date? { FriendsTime.date(createdAt) }
}

nonisolated struct FriendNudge: Codable, Hashable, Identifiable, Sendable {
    var id: String
    var fromId: String
    var fromName: String
    var fromEmoji: String
    var kind: FriendNudgeKind
    var createdAt: String

    var createdDate: Date? { FriendsTime.date(createdAt) }
}

/// A feed event's small payload. Which fields are set depends on the kind:
/// workout {title, minutes, sets, groups}, water {} (the day's goal hit),
/// meals {count}, streak {days}, pr {exercise, kg}.
nonisolated struct FriendEventData: Codable, Hashable, Sendable {
    /// Workout: the muscle groups in English ("Chest · Triceps").
    var title: String?
    var minutes: Int?
    var sets: Int?
    /// Workout: the groups' keys (`MuscleGroup.rawValue`), so each reader's
    /// app shows them in its own language.
    var groups: [String]?
    /// PR: the exercise's English name (the catalog key).
    var exercise: String?
    var kg: Double?
    /// Meals logged that day.
    var count: Int?
    /// Streak: days in a row.
    var days: Int?

    init(title: String? = nil, minutes: Int? = nil, sets: Int? = nil, groups: [String]? = nil,
         exercise: String? = nil, kg: Double? = nil, count: Int? = nil, days: Int? = nil) {
        self.title = title
        self.minutes = minutes
        self.sets = sets
        self.groups = groups
        self.exercise = exercise
        self.kg = kg
        self.count = count
        self.days = days
    }
}

nonisolated struct FriendFeedItem: Codable, Hashable, Identifiable, Sendable {
    var id: String
    /// A friend's id, or "me".
    var friendId: String
    var displayName: String
    var emoji: String
    /// Kept as text, so an event of a kind this build doesn't know still reads.
    var kind: String
    /// "yyyy-MM-dd", the poster's own day.
    var day: String
    var createdAt: String
    var data: FriendEventData
    /// Count per reaction emoji.
    var reactions: [String: Int]
    var myReaction: String?

    var isMine: Bool { friendId == "me" }
    var eventKind: FriendEventKind? { FriendEventKind(rawValue: kind) }
    var createdDate: Date? { FriendsTime.date(createdAt) }

    init(id: String, friendId: String, displayName: String, emoji: String, kind: String, day: String,
         createdAt: String, data: FriendEventData, reactions: [String: Int] = [:], myReaction: String? = nil) {
        self.id = id
        self.friendId = friendId
        self.displayName = displayName
        self.emoji = emoji
        self.kind = kind
        self.day = day
        self.createdAt = createdAt
        self.data = data
        self.reactions = reactions
        self.myReaction = myReaction
    }

    /// Lenient: a missing `data` or `reactions` reads as empty.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        friendId = try c.decode(String.self, forKey: .friendId)
        displayName = try c.decode(String.self, forKey: .displayName)
        emoji = try c.decode(String.self, forKey: .emoji)
        kind = try c.decode(String.self, forKey: .kind)
        day = try c.decode(String.self, forKey: .day)
        createdAt = try c.decode(String.self, forKey: .createdAt)
        data = (try? c.decodeIfPresent(FriendEventData.self, forKey: .data)) ?? FriendEventData()
        reactions = (try? c.decodeIfPresent([String: Int].self, forKey: .reactions)) ?? [:]
        myReaction = try? c.decodeIfPresent(String.self, forKey: .myReaction)
    }

    private enum CodingKeys: String, CodingKey {
        case id, friendId, displayName, emoji, kind, day, createdAt, data, reactions, myReaction
    }
}

// MARK: - Wire: requests and responses

nonisolated struct FriendsEmpty: Codable, Sendable {
    init() {}
    /// Whatever the server sends back (`{}` or nothing) reads.
    init(from decoder: Decoder) throws {}
    func encode(to encoder: Encoder) throws {
        _ = encoder.container(keyedBy: AnyKey.self)
    }

    private struct AnyKey: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }
        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { nil }
    }
}

nonisolated struct FriendsProfileSetRequest: Encodable, Sendable {
    var displayName: String
    var emoji: String
    var share: FriendShare
    var regenerateCode: Bool?
}

nonisolated struct FriendsProfileSetResponse: Decodable, Sendable {
    var me: FriendMe
}

nonisolated struct FriendsSyncResponse: Decodable, Sendable {
    var me: FriendMe?
    var friends: [Friend]
    var incoming: [FriendRequest]
    var outgoing: [FriendRequest]
    var inbox: [FriendNudge]

    init(me: FriendMe?, friends: [Friend], incoming: [FriendRequest], outgoing: [FriendRequest], inbox: [FriendNudge]) {
        self.me = me
        self.friends = friends
        self.incoming = incoming
        self.outgoing = outgoing
        self.inbox = inbox
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        me = try c.decodeIfPresent(FriendMe.self, forKey: .me)
        friends = try c.decodeIfPresent([Friend].self, forKey: .friends) ?? []
        incoming = try c.decodeIfPresent([FriendRequest].self, forKey: .incoming) ?? []
        outgoing = try c.decodeIfPresent([FriendRequest].self, forKey: .outgoing) ?? []
        inbox = try c.decodeIfPresent([FriendNudge].self, forKey: .inbox) ?? []
    }

    private enum CodingKeys: String, CodingKey { case me, friends, incoming, outgoing, inbox }
}

nonisolated struct FriendsCodeRequest: Encodable, Sendable {
    var code: String
}

nonisolated enum FriendRequestStatus: String, Codable, Sendable {
    /// The request went out.
    case sent
    /// They had asked first: now friends.
    case accepted
    /// Already friends, or already asked.
    case already
}

nonisolated struct FriendsRequestResponse: Decodable, Sendable {
    var status: FriendRequestStatus
}

nonisolated struct FriendsRespondRequest: Encodable, Sendable {
    var requestId: String
    var accept: Bool
}

nonisolated struct FriendsIdRequest: Encodable, Sendable {
    var friendId: String
}

nonisolated struct FriendsReportRequest: Encodable, Sendable {
    var friendId: String
    var reason: FriendReportReason
}

nonisolated struct FriendsMuteRequest: Encodable, Sendable {
    var friendId: String
    var muted: Bool
}

nonisolated struct FriendPostEvent: Codable, Hashable, Sendable {
    var kind: FriendEventKind
    /// "yyyy-MM-dd" in the member's time zone.
    var day: String
    var data: FriendEventData
}

nonisolated struct FriendPostWeek: Codable, Hashable, Sendable {
    /// The Monday of the member's own week, "yyyy-MM-dd".
    var weekStart: String
    var workouts: Int
    var streak: Int
    var goalPct: Int?
}

nonisolated struct FriendsPostRequest: Encodable, Sendable {
    var events: [FriendPostEvent]
    var week: FriendPostWeek

    /// `goalPct` goes as null (not absent) so the server clears an old one.
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(events, forKey: .events)
        var w = c.nestedContainer(keyedBy: WeekKeys.self, forKey: .week)
        try w.encode(week.weekStart, forKey: .weekStart)
        try w.encode(week.workouts, forKey: .workouts)
        try w.encode(week.streak, forKey: .streak)
        try w.encode(week.goalPct, forKey: .goalPct)
    }

    private enum CodingKeys: String, CodingKey { case events, week }
    private enum WeekKeys: String, CodingKey { case weekStart, workouts, streak, goalPct }
}

nonisolated struct FriendsFeedRequest: Encodable, Sendable {
    var before: String?
}

nonisolated struct FriendsFeedResponse: Decodable, Sendable {
    var items: [FriendFeedItem]
    var next: String?
}

nonisolated struct FriendsReactRequest: Encodable, Sendable {
    var eventId: String
    /// Null takes the member's reaction away.
    var emoji: String?

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(eventId, forKey: .eventId)
        try c.encode(emoji, forKey: .emoji)
    }

    private enum CodingKeys: String, CodingKey { case eventId, emoji }
}

nonisolated struct FriendsNudgeRequest: Encodable, Sendable {
    var friendId: String
    var kind: FriendNudgeKind
}

// MARK: - Time

nonisolated enum FriendsTime {
    /// An ISO 8601 time from the server, with or without fractions.
    static func date(_ text: String) -> Date? {
        let plain = ISO8601DateFormatter()
        if let date = plain.date(from: text) { return date }
        let fractional = ISO8601DateFormatter()
        fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return fractional.date(from: text)
    }

    static func string(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
}
