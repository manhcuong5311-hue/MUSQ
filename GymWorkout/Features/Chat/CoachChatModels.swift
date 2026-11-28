//
//  CoachChatModels.swift
//  GymWorkout
//
//  "Ask MUSQ" (2026-11-21, owner: "Thêm cả AI chat… nếu user premium có hỏi
//  gì thì ask về vấn đề tập luyện"): the coach chat's messages, the context
//  it sends, and the client it talks to.
//
//  The server side (the Firebase callable `aiChat`, holding the OpenAI key,
//  checking the member's tier and its daily limit) and its Swift client
//  `AIService` belong to the Firebase work. The chat talks to
//  `CoachChatClient`; `AIServiceCoachClient` connects it, mapping the
//  agreed contract 1:1. The chat shows in every build since 1.4, the
//  privacy go-live (`AIService.isLive`).
//

import Foundation
import Observation

// MARK: - Messages

struct CoachChatMessage: Codable, Hashable, Identifiable {
    enum Role: String, Codable { case user, assistant }

    var id = UUID()
    var role: Role
    var content: String
    var date = Date()
}

/// What the server answers: the reply and how many questions are left today.
struct CoachChatReply: Hashable {
    var reply: String
    var remainingToday: Int
}

enum CoachChatError: Error, Equatable {
    case notSignedIn
    case notPremium
    case consentNeeded
    case limitReached
    /// The owner paused the coach on the server (`config/ai` chatEnabled).
    case featureOff
    /// The server requires App Check and this device couldn't pass it.
    case deviceNotVerified
    /// Pro on this device, but the server counted the question against
    /// Premium's limit: it hasn't recorded an upgrade yet, even after
    /// AIService's own sync and retry. Not the member's limit.
    case proNotSynced
    /// The server can't answer right now.
    case unavailable
    case server(String)
}

/// A failed answer and what the server said is left today. A failure can
/// use up its question (see functions/src/settle.ts); errors from before a
/// question is counted carry no count.
struct CoachChatFailure: Error {
    var error: CoachChatError
    var remainingToday: Int?
    /// For a limit: the tier the server counted it on ("premium", "pro").
    var limitTier: String? = nil
}

// MARK: - Client

/// Who answers the coach chat. Throws `CoachChatError`, or
/// `CoachChatFailure` when the server also said how many questions are left.
protocol CoachChatClient {
    func send(_ messages: [CoachChatMessage], context: CoachChatContext?, locale: String) async throws -> CoachChatReply
}

/// The real coach: MUSQ's `aiChat` function through `AIService`, which
/// checks the chat's consent, sends the last 20 messages and the time zone,
/// and maps the server's errors.
struct AIServiceCoachClient: CoachChatClient {
    func send(_ messages: [CoachChatMessage], context: CoachChatContext?, locale: String) async throws -> CoachChatReply {
        do {
            let reply = try await AIService.shared.chat(
                messages: messages.map { AIChatMessage(role: $0.role == .user ? .user : .assistant, content: $0.content) },
                context: context.map(Self.contract), locale: locale)
            return CoachChatReply(reply: reply.reply, remainingToday: reply.remainingToday)
        } catch let error as AIServiceError {
            let mapped = Self.map(error)
            throw CoachChatFailure(error: mapped,
                                   remainingToday: Self.carriesCount(mapped) ? AIService.shared.remainingAfterFailure["aiChat"] : nil,
                                   limitTier: mapped == .limitReached ? AIService.shared.limitAfterFailure["aiChat"]?.tier : nil)
        }
    }

    /// Only errors the server can send after counting the question carry its
    /// count. Sign-in and consent stop the call before the server, while
    /// AIService still holds an earlier call's count (a 0 there would turn
    /// "sign in" into the day's limit).
    static func carriesCount(_ error: CoachChatError) -> Bool {
        switch error {
        case .unavailable, .server, .limitReached: return true
        default: return false
        }
    }

    /// Every case is named, so a new `AIServiceError` stops the build here
    /// instead of reaching the member as "try again".
    static func map(_ error: AIServiceError) -> CoachChatError {
        switch error {
        case .notSignedIn: return .notSignedIn
        case .notPremium: return .notPremium
        case .consentNeeded: return .consentNeeded
        case .limitReached: return .limitReached
        case .featureOff: return .featureOff
        case .deviceNotVerified: return .deviceNotVerified
        case .unavailable: return .unavailable
        case .server(let message): return .server(message)
        // Photo-only answers; the chat never gets them.
        case .photoNotAllowed, .adultsOnly: return .unavailable
        }
    }

    static func contract(_ context: CoachChatContext) -> AIChatContext {
        AIChatContext(
            goal: context.goal, sex: context.sex, experience: context.experience, split: context.split,
            age: context.age, daysPerWeek: context.daysPerWeek, heightCm: context.heightCm, weightKg: context.weightKg,
            plan: context.plan.map { AIChatContext.Plan(kcal: $0.kcal, proteinG: $0.proteinG, fatG: $0.fatG, carbsG: $0.carbsG) },
            recentWorkouts: context.recentWorkouts.map { workout in
                AIChatContext.Workout(date: workout.date, groups: workout.groups, exercises: workout.exercises.map {
                    AIChatContext.Exercise(name: $0.name, sets: $0.sets, reps: $0.reps, weightKg: $0.weightKg, seconds: $0.seconds)
                })
            },
            health: context.health.map { AIChatContext.Health(joints: $0.joints, conditions: $0.conditions) })
    }
}

enum CoachChat {
    static let client: any CoachChatClient = AIServiceCoachClient()

    /// The Today bar shows while the AI features are live: every build since
    /// 1.4, the privacy go-live (see `AIService.isLive`), which also changed
    /// the app's "nothing leaves your phone" wording.
    static var isAvailable: Bool { AIService.isLive }

    /// The chat's own consent (`AIService.Consent.chat`); the meal scan and
    /// the goal photo each ask for theirs.
    static let consentKey = "ai.consent.v1"
    /// Whether the health answers (joints, conditions) go with the context.
    static let includeHealthKey = "ai.chat.includeHealth"
    // The daily limit depends on the tier, free included: `Purchases.Tier.chatPerDay`.
    /// What the server reads of the history.
    static let historyLimit = 20
    static let messageLimit = 2_000

    /// "en" or "vi": the language the app itself runs in.
    static var locale: String { AIService.appLocale }
}

// MARK: - Context

/// What the coach is told about the user, so its answers fit their plan:
/// the profile, the plan's calories and macros, and the last two weeks of
/// workouts. Health answers only when the user turns them on. Mirrors the
/// agreed `AIChatContext`.
struct CoachChatContext: Codable, Hashable {
    struct Plan: Codable, Hashable {
        var kcal: Int
        var proteinG: Int
        var fatG: Int
        var carbsG: Int
    }

    struct Exercise: Codable, Hashable {
        var name: String
        var sets: Int
        var reps: Int?
        var weightKg: Double?
        /// Seconds held, for timed exercises (plank, wall sit); reps stay nil.
        var seconds: Int?
    }

    struct Workout: Codable, Hashable {
        /// "yyyy-MM-dd".
        var date: String
        var groups: [String]
        var exercises: [Exercise]
    }

    struct Health: Codable, Hashable {
        var joints: [String]
        var conditions: [String]
    }

    var goal: String?
    var sex: String?
    var experience: String?
    var split: String?
    var age: Int?
    var daysPerWeek: Int?
    var heightCm: Double?
    var weightKg: Double?
    var plan: Plan?
    var recentWorkouts: [Workout] = []
    var health: Health?

    init(store: WorkoutStore, includeHealth: Bool, now: Date = Date()) {
        let profile = store.profile
        goal = profile?.goal.rawValue
        sex = profile?.sex.rawValue
        experience = store.experience.rawValue
        // The real choice (Full Body, bro split, custom), not the nearest
        // one older builds know.
        split = profile.map { ProgramAdvisor.split(for: $0).rawValue }
        age = profile?.age(at: now)
        daysPerWeek = profile?.weekdays?.count ?? profile?.daysPerWeek
        heightCm = profile?.heightCm
        weightKg = profile?.weightKg
        if let profile, let plan = NutritionPlan(profile: profile) {
            self.plan = Plan(kcal: Int(plan.calories), proteinG: Int(plan.protein),
                             fatG: Int(plan.fat), carbsG: Int(plan.carbs))
        }
        // Today and the 13 days before it: the "last two weeks" the consent
        // sheet and the privacy copy name. The start of that first day is
        // taken after stepping back, so it counts whole even when today
        // starts at 01:00 (time zones whose DST change is at midnight).
        let calendar = Calendar.current
        let firstDay = calendar.date(byAdding: .day, value: -13, to: calendar.startOfDay(for: now)) ?? now
        let since = calendar.startOfDay(for: firstDay)
        let day = DateFormatter()
        day.calendar = Calendar(identifier: .gregorian)
        day.locale = Locale(identifier: "en_US_POSIX")
        day.dateFormat = "yyyy-MM-dd"
        recentWorkouts = store.sessions
            .filter { $0.day >= since && $0.hasCompletedSets }
            .sorted { $0.day > $1.day }
            .map { session in
                // Only what was logged: the exercises with completed sets and
                // their groups, not every group the day planned (a skipped one
                // would read as trained).
                var done = session
                done.exercises.removeAll { $0.completedSets.isEmpty }
                return Workout(date: day.string(from: session.day),
                               groups: done.groups.map(\.rawValue),
                               exercises: done.exercises.map { exercise in
                                   // Reps and weight from one set, the heaviest (the longest
                                   // hold for a timed one, whose "reps" are seconds).
                                   let top = exercise.completedSets.max { ($0.weight ?? 0, $0.reps) < ($1.weight ?? 0, $1.reps) }
                                   return Exercise(name: exercise.exerciseName, sets: exercise.completedSets.count,
                                                   reps: exercise.isTimed ? nil : top?.reps, weightKg: top?.weight,
                                                   seconds: exercise.isTimed ? top?.reps : nil)
                               })
            }
        if includeHealth, let answers = profile?.health {
            health = Health(joints: answers.joints.map(\.rawValue).sorted(),
                            conditions: answers.conditions.map(\.rawValue).sorted())
        }
    }
}

// MARK: - History

/// The conversation, kept on the device only (Application Support/Chat,
/// out of iCloud and device backups: a Balance question can carry Apple
/// Health sleep numbers), and the request in flight. One for the app, so closing the sheet while
/// MUSQ is thinking doesn't lose the answer or split the history.
@Observable
final class CoachChatStore {
    static let shared = CoachChatStore()

    private(set) var messages: [CoachChatMessage] = []
    private(set) var sending = false
    var problem: CoachChatError?
    /// Questions left today, from the last answer, and the day it was for.
    private(set) var remainingToday: Int?
    private(set) var remainingDay: Date?

    @ObservationIgnored private let fileURL: URL
    @ObservationIgnored private var task: Task<Void, Never>?
    /// Bumped by Clear, so an answer to a cleared question is dropped.
    @ObservationIgnored private var generation = 0
    /// The tier the count is for (see `noteTier`).
    @ObservationIgnored private var countTier: Purchases.Tier?
    /// The most kept; older ones drop off.
    private let keep = 80

    init(fileURL: URL = CoachChatStore.defaultURL) {
        self.fileURL = fileURL
        if let data = try? Data(contentsOf: fileURL),
           let saved = try? JSONDecoder.chat.decode([CoachChatMessage].self, from: data) {
            messages = saved
            // A chat saved before the folder was marked.
            Self.excludeFromBackup(fileURL.deletingLastPathComponent())
        }
    }

    static var defaultURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("Chat", isDirectory: true).appendingPathComponent("coach.json")
    }

    /// Today's questions are used up; the server would refuse more.
    var isOutOfQuestions: Bool {
        remainingToday == 0 && remainingDay.map { Calendar.current.isDateInToday($0) } == true
    }

    /// The last question has no answer: it failed, or the sheet was closed
    /// before one came.
    var hasUnanswered: Bool { !sending && messages.last?.role == .user }

    func append(_ message: CoachChatMessage) {
        messages.append(message)
        if messages.count > keep { messages.removeFirst(messages.count - keep) }
        save()
    }

    /// Asks the client with the conversation as it is. The caller has
    /// checked consent.
    func ask(context: CoachChatContext, client: any CoachChatClient, locale: String) {
        guard !sending, messages.last?.role == .user else { return }
        sending = true
        problem = nil
        let history = Array(messages.suffix(CoachChat.historyLimit))
        let ticket = generation
        // The server counts the question on the day it sets out, so the count
        // is stamped with that moment, not when the reply lands (a reply after
        // midnight would otherwise carry yesterday's 0 into the new day).
        let askedAt = Date()
        task = Task { [weak self] in
            let result: Result<CoachChatReply, Error>
            do {
                result = .success(try await client.send(history, context: context, locale: locale))
            } catch {
                result = .failure(error)
            }
            guard let self, self.generation == ticket else { return }
            self.sending = false
            switch result {
            case .success(let answer):
                self.append(CoachChatMessage(role: .assistant, content: answer.reply))
                self.remainingToday = answer.remainingToday
                self.remainingDay = askedAt
            case .failure(let failure as CoachChatFailure):
                self.fail(failure.error, remaining: failure.remainingToday, limitTier: failure.limitTier, askedAt: askedAt)
            case .failure(let error as CoachChatError):
                self.fail(error, remaining: nil, askedAt: askedAt)
            case .failure(let error):
                self.problem = .server(error.localizedDescription)
            }
        }
    }

    /// A failed answer: the count the server gave with it, if any, and the
    /// problem to show. With nothing left today the limit is what matters,
    /// so it shows instead of a Try again that can't work; a count for a day
    /// that has already ended stops nothing.
    private func fail(_ error: CoachChatError, remaining: Int?, limitTier: String? = nil, askedAt: Date) {
        // Premium's limit for a member who holds Pro: the server is behind,
        // so nothing locks and asking again works once it catches up.
        if error == .limitReached, limitTier == "premium", countTier == .pro {
            problem = .proNotSynced
            return
        }
        let left = error == .limitReached ? 0 : remaining
        if let left {
            remainingToday = left
            remainingDay = askedAt
        }
        problem = left == 0 && Calendar.current.isDateInToday(askedAt) ? .limitReached : error
    }

    /// The member's tier, from the chat as it opens and when it changes. A
    /// new tier (an upgrade to Pro, a lapse) has a new allowance, so the
    /// count is dropped until the next answer brings the server's, and a
    /// limit that no longer holds stops blocking.
    func noteTier(_ tier: Purchases.Tier) {
        defer { countTier = tier }
        guard let countTier, countTier != tier else { return }
        remainingToday = nil
        remainingDay = nil
        if problem == .limitReached { problem = nil }
    }

    func clear() {
        generation += 1
        task?.cancel()
        task = nil
        sending = false
        problem = nil
        messages = []
        save()
    }

    private func save() {
        do {
            let folder = fileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            Self.excludeFromBackup(folder)
            try JSONEncoder.chat.encode(messages).write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            // The chat still works this session; it just won't be there next launch.
        }
    }

    /// Keeps the chat out of iCloud and device backups, as GoalPhoto does
    /// its picture. Set on the folder, the flag holds when the file is
    /// replaced; a folder that isn't there yet is marked on the first save.
    private static func excludeFromBackup(_ folder: URL) {
        var folder = folder
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try? folder.setResourceValues(values)
    }
}

private extension JSONEncoder {
    static var chat: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

private extension JSONDecoder {
    static var chat: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
