//
//  AIService.swift
//  GymWorkout
//
//  The app's side of MUSQ's AI features (2026-11-21), all Premium: the Ask
//  MUSQ coach, photo meal logging and the goal photo. Every call goes to
//  MUSQ's own Firebase functions (project musq-app, Singapore), which hold
//  the OpenAI key, check Premium from signed App Store transactions and
//  count usage. Nothing here talks to OpenAI directly, and each feature
//  asks for its own consent before anything leaves the device (App Store
//  5.1.2(i)).
//

import FirebaseAppCheck
import FirebaseAuth
import FirebaseCore
import FirebaseFunctions
import Foundation
import Observation
import StoreKit
import UIKit

// MARK: - Chat contract (agreed with the Ask MUSQ chat, 2026-11-21)

// Every type sent to or read from the server is nonisolated and Sendable:
// Firebase encodes and decodes it off the main actor.

nonisolated struct AIChatMessage: Codable, Hashable, Sendable {
    enum Role: String, Codable, Sendable { case user, assistant }
    var role: Role
    var content: String
}

nonisolated struct AIChatContext: Codable, Hashable, Sendable {
    nonisolated struct Plan: Codable, Hashable, Sendable {
        var kcal: Int
        var proteinG: Int
        var fatG: Int
        var carbsG: Int
    }

    nonisolated struct Exercise: Codable, Hashable, Sendable {
        var name: String
        var sets: Int
        var reps: Int?
        var weightKg: Double?
        /// For timed sets (plank, wall sit), whose reps are seconds.
        var seconds: Int?
    }

    nonisolated struct Workout: Codable, Hashable, Sendable {
        /// "yyyy-MM-dd".
        var date: String
        var groups: [String]
        var exercises: [Exercise]
    }

    nonisolated struct Health: Codable, Hashable, Sendable {
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
    /// Only when the member turned it on.
    var health: Health?
}

nonisolated struct AIChatReply: Codable, Hashable, Sendable {
    var reply: String
    var remainingToday: Int
}

nonisolated enum AIServiceError: Error, Equatable, Sendable {
    case notSignedIn
    case notPremium
    case consentNeeded
    case limitReached
    case unavailable
    /// The photo was refused: not the member's own, or the AI's safety
    /// checks wouldn't edit it.
    case photoNotAllowed
    /// The goal photo is for adults only.
    case adultsOnly
    /// The owner switched this feature off on the server for now.
    case featureOff
    /// The server requires App Check and this device couldn't prove it's
    /// running the real MUSQ app.
    case deviceNotVerified
    case server(String)
}

/// A goal photo from the server, with the photo it was made from: the app
/// puts the member's own face back from `upload` (FaceRestore) before it
/// keeps or shows the result.
struct GoalPhotoResult {
    /// The JPEG the server sent.
    var jpeg: Data
    /// The JPEG that was sent: upright, at most 1536 px, sides in multiples
    /// of 16, so the edit comes back at the same size.
    var upload: Data
    /// What's left: this year on a plan, or of the one free photo.
    var remaining: Int
    /// "year" (Premium, Pro) or "once" (the free photo).
    var period: String
    /// "free", "premium" or "pro", as the server counted it.
    var tier: String?
}

// MARK: - Meal scan

/// A food the scan found. Since the food table (2026-11-22) the server
/// matches what it can to a table entry (`ref`, basis "table") and works out
/// its kcal and macros from the table; anything else keeps the AI's own
/// estimate (basis "estimate"). Every field the table brought is optional,
/// so an older server's answer still reads, and the numbers are read as
/// decimals whether or not the server rounds them.
nonisolated struct MealScanItem: Codable, Hashable, Identifiable, Sendable {
    /// What a photo can't show, already in the item's kcal: grams of added
    /// fat, added sugar, and sauces or dips, in the item's `grams`.
    nonisolated struct Hidden: Codable, Hashable, Sendable {
        var oil: Double?
        var sugar: Double?
        var sauce: Double?
    }

    var id = UUID()
    /// In the member's language.
    var name: String
    /// The amount in words: "1 bowl", "2 eggs".
    var portion: String
    /// Edible grams; 0 when unknown (an estimate the AI gave no weight for).
    var grams: Double
    var kcal: Double
    var proteinG: Double
    var fatG: Double
    var carbsG: Double
    /// The food table entry it was matched to ("vn.pho_bo_tai").
    var ref: String? = nil
    /// "table" (numbers from the food table) or "estimate" (the AI's own).
    var basis: String? = nil
    /// "piece" for a counted food, "g" for a food by amount.
    var unit: String? = nil
    /// How many pieces, for a counted food, to 3 decimals: a table food's in
    /// its entry's own piece (⅛ of a whole-pizza entry for one slice). The
    /// app words it; an older server rounded it to the quarter.
    var count: Double? = nil
    /// One piece's edible grams, for a counted food: count × pieceGrams is
    /// the grams, and the review steps by it. The scan's own piece when its
    /// count and grams agree (two big eggs at 55 g each), else the table
    /// entry's; 0 when the scan gave a count but no grams.
    var pieceGrams: Double? = nil
    /// One typical serving's grams, for a table food by amount.
    var servingGrams: Double? = nil
    var hidden: Hidden? = nil
    /// For a table food, the AI model's own grams and kcal, beside the
    /// table's numbers above; nil for an estimate (whose numbers are the
    /// model's) and from an older server.
    var modelGrams: Double? = nil
    var modelKcal: Double? = nil

    private enum CodingKeys: String, CodingKey {
        case name, portion, grams, kcal, proteinG, fatG, carbsG, ref, basis, unit, count, pieceGrams, servingGrams, hidden,
             modelGrams, modelKcal
    }
}

nonisolated struct MealScan: Codable, Hashable, Sendable {
    nonisolated struct Totals: Codable, Hashable, Sendable {
        var kcal: Double
        var proteinG: Double
        var fatG: Double
        var carbsG: Double
    }

    var isFood: Bool
    var title: String
    var items: [MealScanItem]
    /// The server's sum of the items. The review adds up the amounts the
    /// member sets instead, so it isn't needed.
    var total: Totals?
    /// "high", "medium" or "low".
    var confidence: String
    var note: String
    var remainingToday: Int
    /// The version of the food table the server matched the items to
    /// (`FoodTable.version`); nil when it used none, and from an older
    /// server. The review takes a table food's numbers from this app's own
    /// copy of the entry only when this is that copy's version; otherwise
    /// it scales the numbers sent.
    var tableVersion: Int? = nil

    private enum CodingKeys: String, CodingKey {
        case isFood, title, items, total, confidence, note, remainingToday, tableVersion
    }
}

nonisolated extension MealScan {
    /// Written out so that a `tableVersion` of another type reads as none
    /// (the scan's own numbers then stand) instead of failing the scan; in
    /// an extension, so the memberwise initializer stays.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isFood = try container.decode(Bool.self, forKey: .isFood)
        title = try container.decode(String.self, forKey: .title)
        items = try container.decode([MealScanItem].self, forKey: .items)
        total = try container.decodeIfPresent(Totals.self, forKey: .total)
        confidence = try container.decode(String.self, forKey: .confidence)
        note = try container.decode(String.self, forKey: .note)
        remainingToday = try container.decode(Int.self, forKey: .remainingToday)
        tableVersion = (try? container.decodeIfPresent(Int.self, forKey: .tableVersion)) ?? nil
    }
}

// MARK: - Service

@MainActor
@Observable
final class AIService {
    static let shared = AIService()

    /// Whether the AI features show in this build: every build since 1.4,
    /// the privacy go-live (2026-11-23), which ships with the wording that
    /// names MUSQ's server and OpenAI (the FAQ, onboarding, Health and
    /// consent copy, PrivacyInfo.xcprivacy, musq.app/privacy.html and the
    /// App Store privacy answers). Each feature can still be paused on the
    /// server (config/ai chatEnabled, mealEnabled, goalPhotoEnabled), which
    /// the app shows as "paused for now". The TestFlight-only compile flag
    /// (2026-11-22) is gone: it unlocked Pro for any sandbox receipt, App
    /// Review's included, and hid the AI from App Store installs.
    static var isLive: Bool { true }

    /// One consent per feature, each naming what it sends to OpenAI. The
    /// chat's key is the one the Ask MUSQ sheet already writes.
    enum Consent: String, CaseIterable {
        case chat = "ai.consent.v1"
        case meal = "ai.consent.meal.v1"
        /// v2 (2026-11-23): the look is picked (sex, muscle, body fat), the
    /// clothes are kept and the face is put back on the phone, so the
    /// member is asked again.
    case goalPhoto = "ai.consent.goalPhoto.v2"

        var isGiven: Bool { UserDefaults.standard.bool(forKey: rawValue) }
        func give() { UserDefaults.standard.set(true, forKey: rawValue) }

        /// Every feature asks again before it sends anything.
        static func withdrawAll() {
            for consent in allCases { UserDefaults.standard.set(false, forKey: consent.rawValue) }
        }
    }

    /// Firebase is set up (the config file is in the app).
    private(set) var isConfigured = false
    /// What the server last said about Premium; nil until it was asked.
    private(set) var serverPremium: Bool?
    /// The plan the server last recorded for this member (it sets the AI
    /// allowances); nil until it was asked.
    private(set) var serverTier: Purchases.Tier?
    /// What the server said is left after the last failed call of each
    /// function ("aiChat", "scanMeal", "goalPhoto"); nil while a call runs,
    /// after a success, or when the failure didn't come from the server. A failure can keep the unit (see
    /// functions/src/settle.ts), so a count shown from the last answer may
    /// be one too high.
    private(set) var remainingAfterFailure: [String: Int] = [:]
    /// The plan and period a limit error named, per function: a "premium"
    /// limit seen by a member who holds Pro means the server hasn't caught
    /// up with the upgrade yet.
    private(set) var limitAfterFailure: [String: ServerLimit] = [:]
    /// Goal photos the member's plan has left this year, as the server last
    /// said (sync, a goal photo, or its limit); nil when unknown, without a
    /// plan, or said in an earlier year (a new year's allowance must never be
    /// blocked by last year's 0, review GP-3). 0 means "New photo" should
    /// offer Pro (on Premium) or wait for next year (on Pro).
    var goalPhotosLeft: Int? {
        goalPhotosLeftYear == Calendar.current.component(.year, from: Date()) ? goalPhotosLeftValue : nil
    }
    private var goalPhotosLeftValue: Int?
    private var goalPhotosLeftYear: Int?

    private func setGoalPhotosLeft(_ value: Int?) {
        goalPhotosLeftValue = value
        goalPhotosLeftYear = Calendar.current.component(.year, from: Date())
    }
    /// Whether the one free goal photo (members without a plan) is used, as
    /// the server last said; kept across launches. Nil when never asked.
    private(set) var freeGoalPhotoUsed: Bool? = UserDefaults.standard.object(forKey: AIService.freeGoalPhotoKey) as? Bool {
        didSet { UserDefaults.standard.set(freeGoalPhotoUsed, forKey: Self.freeGoalPhotoKey) }
    }
    private static let freeGoalPhotoKey = "ai.goalPhoto.freeUsed"
    /// The sync in flight, so callers join it instead of racing it.
    @ObservationIgnored private var syncTask: Task<Bool, Never>?

    @ObservationIgnored private var functions: Functions?

    private init() {}

    /// Called once at launch, before any view uses Firebase. Builds where
    /// the AI isn't live never start Firebase: no App Check, no sign-in
    /// state, nothing sent anywhere.
    static func configure() { shared.configure() }

    private func configure() {
        guard Self.isLive, !isConfigured,
              Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else { return }
        AppCheck.setAppCheckProviderFactory(MUSQAppCheckProviderFactory())
        FirebaseApp.configure()
        let functions = Functions.functions(region: "asia-southeast1")
        #if DEBUG
        // `-ai.emulator YES`: the local Firebase emulators, for testing the
        // screens without touching the live project.
        if Self.usesEmulator {
            Auth.auth().useEmulator(withHost: "127.0.0.1", port: 9099)
            functions.useEmulator(withHost: "127.0.0.1", port: 5001)
        }
        #endif
        self.functions = functions
        isConfigured = true
        AccountService.shared.start()
    }

    #if DEBUG
    static var usesEmulator: Bool { UserDefaults.standard.bool(forKey: "ai.emulator") }
    #endif

    // MARK: Features

    // Each wait is longer than its function's own limit (90 s for the chat
    // and meal scans, 240 s for goal photos), so the app always gets the
    // server's answer or its error rather than giving up on an answer that's
    // already been counted.

    func chat(messages: [AIChatMessage], context: AIChatContext?, locale: String) async throws -> AIChatReply {
        remainingAfterFailure["aiChat"] = nil
        guard Consent.chat.isGiven else { throw AIServiceError.consentNeeded }
        return try await premiumCall("aiChat",
                                     ChatRequest(messages: Array(messages.suffix(20)), context: context,
                                             locale: locale, timeZone: TimeZone.current.identifier),
                                     as: AIChatReply.self, timeout: 100)
    }

    func scanMeal(_ photo: UIImage, note: String?, locale: String = AIService.appLocale) async throws -> MealScan {
        remainingAfterFailure["scanMeal"] = nil
        guard Consent.meal.isGiven else { throw AIServiceError.consentNeeded }
        guard let image = await Self.upload(photo, maxSide: 1280, quality: 0.8) else { throw AIServiceError.server("photo") }
        return try await premiumCall("scanMeal",
                                     MealRequest(image: image, note: note, locale: locale, timeZone: TimeZone.current.identifier),
                                     as: MealScan.self, timeout: 100)
    }

    /// A birth year from the profile, which keeps it in the phone's calendar
    /// (2539 on a Buddhist-calendar iPhone for 1996), as the Gregorian year
    /// the server checks.
    nonisolated static func gregorianYear(_ year: Int, from calendar: Calendar = .current) -> Int {
        guard calendar.identifier != .gregorian,
              let date = calendar.date(from: DateComponents(year: year, month: 7, day: 1)) else { return year }
        return Calendar(identifier: .gregorian).component(.year, from: date)
    }

    /// The member's own photo, edited to the look they picked. Open to
    /// members without a plan too: the server gives each account one free
    /// goal photo. `confirmsOwnPhoto` is the member's answer for this photo;
    /// the server refuses without it.
    func goalPhoto(_ photo: UIImage, look: GoalLook, birthYear: Int,
                   confirmsOwnPhoto: Bool) async throws -> GoalPhotoResult {
        remainingAfterFailure["goalPhoto"] = nil
        guard Consent.goalPhoto.isGiven else { throw AIServiceError.consentNeeded }
        guard let upload = await Task.detached(priority: .userInitiated, operation: { Self.goalUpload(photo) }).value else {
            throw AIServiceError.server("photo")
        }
        let holdsPlan = await Self.holdsPlan()
        let request = GoalPhotoRequest(image: upload.base64EncodedString(), sex: look.sex.rawValue,
                                       muscle: look.muscle.rawValue, fat: look.fat.rawValue,
                                       birthYear: Self.gregorianYear(birthYear), confirmsOwnPhoto: confirmsOwnPhoto,
                                       timeZone: TimeZone.current.identifier, holdsPlan: holdsPlan)
        let response = try await goalPhotoCall(request, holdsPlan: holdsPlan)
        guard let data = Data(base64Encoded: response.image), UIImage(data: data) != nil else {
            throw AIServiceError.unavailable
        }
        let remaining = response.remaining ?? response.remainingThisMonth ?? 0
        let period = response.period ?? "year"
        if period == "once" { freeGoalPhotoUsed = remaining == 0 } else { setGoalPhotosLeft(remaining) }
        return GoalPhotoResult(jpeg: data, upload: upload, remaining: remaining, period: period, tier: response.tier)
    }

    /// A goal photo call. The server counts a member it holds no plan for as
    /// free, so a plan this device has that the server hasn't recorded yet
    /// (its sync failed, or it was bought on another device) is synced first:
    /// otherwise the photo would use the free one. If the free one is used
    /// anyway, sync once and retry.
    /// `holdsPlan` also goes to the server, which then refuses rather than
    /// spend the free photo when its record of the plan is out of date (a
    /// renewal it never heard of, review GP-2), so the sync-and-retry runs.
    private func goalPhotoCall(_ request: GoalPhotoRequest, holdsPlan: Bool) async throws -> GoalPhotoResponse {
        if serverTier != .premium, serverTier != .pro, holdsPlan {
            await syncEntitlements()
        }
        do {
            return try await premiumCall("goalPhoto", request, as: GoalPhotoResponse.self, timeout: 250)
        } catch AIServiceError.limitReached where limitAfterFailure["goalPhoto"]?.tier == "free" {
            guard holdsPlan else { throw AIServiceError.limitReached }
            await syncEntitlements()
            guard serverTier == .premium || serverTier == .pro else { throw AIServiceError.limitReached }
            return try await call("goalPhoto", request, as: GoalPhotoResponse.self, timeout: 250)
        }
    }

    // MARK: Premium

    /// Sends the App Store's signed transactions to the server, which
    /// verifies them and records the member's plan. Returns whether any paid
    /// plan counts. Only one runs at a time; a second caller waits for it.
    @discardableResult
    func syncEntitlements() async -> Bool {
        if let syncTask { return await syncTask.value }
        let task = Task { await self.runSync() }
        syncTask = task
        let result = await task.value
        syncTask = nil
        return result
    }

    /// Syncs when the server's plan differs from the one the App Store
    /// gives this device (an upgrade whose sync failed, say). Call it when
    /// the app comes back to the foreground.
    func syncIfBehind(localTier: Purchases.Tier) async {
        guard isConfigured, Auth.auth().currentUser != nil, serverTier != localTier else { return }
        await syncEntitlements()
    }

    private func runSync() async -> Bool {
        guard functions != nil, Auth.auth().currentUser != nil else { return false }
        var signed: [String] = []
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result,
                  Purchases.ProductID.premium.contains(transaction.productID),
                  transaction.revocationDate == nil else { continue }
            signed.append(result.jwsRepresentation)
        }
        do {
            let response = try await call("syncEntitlement",
                                          EntitlementRequest(transactions: Array(signed.prefix(10)),
                                                             timeZone: TimeZone.current.identifier),
                                          as: EntitlementResponse.self, timeout: 30)
            serverPremium = response.premium
            serverTier = !response.premium ? .free : response.tier == "pro" ? .pro : .premium
            setGoalPhotosLeft(response.premium ? response.goalPhotosLeft : nil)
            if let used = response.freeGoalPhotoUsed { freeGoalPhotoUsed = used }
            return response.premium
        } catch {
            return false
        }
    }

    // MARK: Account

    /// Deletes everything the server holds for the member and the account.
    /// `appleRevocation` ("done", "failed" or "skipped") is logged there, so
    /// a Sign in with Apple token that wasn't revoked shows up.
    func deleteAccountOnServer(appleRevocation: String) async throws {
        _ = try await call("deleteAccount", DeleteRequest(appleRevocation: appleRevocation),
                           as: DeleteResponse.self, timeout: 30)
        serverPremium = nil
        serverTier = nil
        setGoalPhotosLeft(nil)
        freeGoalPhotoUsed = nil
    }

    func signedOut() {
        serverPremium = nil
        serverTier = nil
        setGoalPhotosLeft(nil)
        freeGoalPhotoUsed = nil
        remainingAfterFailure = [:]
        limitAfterFailure = [:]
    }

    // MARK: Calls

    /// A paid call. A sync still running (a purchase a moment ago) goes
    /// first. When the server doesn't know about a purchase yet (bought on
    /// another device, or its sync failed), or still counts Premium's
    /// allowance for a member who now holds Pro, sync once and retry: a
    /// refused call costs nothing.
    private func premiumCall<Request: Encodable & Sendable, Response: Decodable & Sendable>(
        _ name: String, _ request: Request, as: Response.Type, timeout: TimeInterval
    ) async throws -> Response {
        if let syncTask { _ = await syncTask.value }
        do {
            return try await call(name, request, as: Response.self, timeout: timeout)
        } catch AIServiceError.notPremium {
            guard await syncEntitlements() else { throw AIServiceError.notPremium }
            return try await call(name, request, as: Response.self, timeout: timeout)
        } catch AIServiceError.limitReached where limitAfterFailure[name]?.tier == "premium" {
            guard await Self.holdsPro() else { throw AIServiceError.limitReached }
            await syncEntitlements()
            guard serverTier == .pro else { throw AIServiceError.limitReached }
            return try await call(name, request, as: Response.self, timeout: timeout)
        }
    }

    /// Whether the App Store gives this device any plan (DEBUG_PRO and
    /// DEBUG_PREMIUM count too).
    private static func holdsPlan() async -> Bool {
        #if DEBUG
        let env = ProcessInfo.processInfo.environment
        if env["DEBUG_PRO"] == "1" || env["DEBUG_PREMIUM"] == "1" { return true }
        #endif
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.revocationDate == nil,
               Purchases.ProductID.premium.contains(transaction.productID) { return true }
        }
        return false
    }

    /// Whether the App Store gives this device Pro (DEBUG_PRO counts too).
    private static func holdsPro() async -> Bool {
        #if DEBUG
        if ProcessInfo.processInfo.environment["DEBUG_PRO"] == "1" { return true }
        #endif
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.revocationDate == nil,
               Purchases.ProductID.pro.contains(transaction.productID) { return true }
        }
        return false
    }

    private func call<Request: Encodable & Sendable, Response: Decodable & Sendable>(
        _ name: String, _ request: Request, as: Response.Type, timeout: TimeInterval
    ) async throws -> Response {
        remainingAfterFailure[name] = nil
        limitAfterFailure[name] = nil
        guard let functions else { throw AIServiceError.unavailable }
        guard Auth.auth().currentUser != nil else { throw AIServiceError.notSignedIn }
        var callable = functions.httpsCallable(name, requestAs: Request.self, responseAs: Response.self)
        callable.timeoutInterval = timeout
        do {
            return try await callable.call(request)
        } catch {
            let details = Self.details(of: error)
            remainingAfterFailure[name] = (details["remaining"] as? NSNumber)?.intValue
            let mapped = Self.map(error)
            if mapped == .limitReached {
                let limit = ServerLimit(tier: details["tier"] as? String, period: details["period"] as? String)
                limitAfterFailure[name] = limit
                if name == "goalPhoto" {
                    if limit.tier == "free" || limit.period == "once" { freeGoalPhotoUsed = true } else { setGoalPhotosLeft(0) }
                }
            } else if name == "goalPhoto", let remaining = remainingAfterFailure[name], serverTier == .premium || serverTier == .pro {
                // A failure that kept the unit (review GP-9).
                setGoalPhotosLeft(remaining)
            }
            throw mapped
        }
    }

    /// The `details` of a server error: what's left after the call, and for
    /// a limit, the plan and period it counted.
    nonisolated static func details(of error: Error) -> [String: Any] {
        let ns = error as NSError
        guard ns.domain == FunctionsErrorDomain else { return [:] }
        return ns.userInfo[FunctionsErrorDetailsKey] as? [String: Any] ?? [:]
    }

    /// The server's errors (see functions/src/access.ts) as the app's own.
    static func map(_ error: Error) -> AIServiceError {
        if let known = error as? AIServiceError { return known }
        let ns = error as NSError
        guard ns.domain == FunctionsErrorDomain, let code = FunctionsErrorCode(rawValue: ns.code) else {
            return .unavailable
        }
        let message = ns.localizedDescription
        switch code {
        case .unauthenticated: return message == "app-check-required" ? .deviceNotVerified : .notSignedIn
        // Only the server's own "no plan" answer (Reason.premium in
        // functions/src/reasons.ts, the one permission-denied it sends); a
        // bare 403 from the platform (billing, IAM) isn't the member's plan.
        case .permissionDenied: return message == "premium-required" ? .notPremium : .unavailable
        // Only the server's own limit; a bare 429 (every instance busy)
        // is a moment's wait, not the day's allowance.
        case .resourceExhausted: return message == "limit-reached" ? .limitReached : .unavailable
        case .failedPrecondition: return message == "age-required" ? .adultsOnly : .photoNotAllowed
        case .unavailable: return message == "feature-off" ? .featureOff : .unavailable
        case .deadlineExceeded, .internal, .unknown, .cancelled: return .unavailable
        default: return .server(message)
        }
    }

    // MARK: Helpers

    /// "vi" when the app runs in Vietnamese, else "en".
    nonisolated static var appLocale: String {
        Bundle.main.preferredLocalizations.first?.hasPrefix("vi") == true ? "vi" : "en"
    }

    /// The goal photo's upload: upright, scaled to fit 1536 px, then trimmed
    /// (centred) to sides in multiples of 16, so the server can ask for the
    /// edit at the photo's own size and the frame doesn't move: the face is
    /// put back pixel for pixel. Plain sRGB, no metadata (no location or
    /// camera details leave the device).
    nonisolated static func goalUpload(_ image: UIImage) -> Data? {
        let longest = max(image.size.width, image.size.height)
        guard longest > 0 else { return nil }
        let scale = min(1, 1536 / longest)
        let fitted = CGSize(width: (image.size.width * scale).rounded(), height: (image.size.height * scale).rounded())
        let size = CGSize(width: (fitted.width / 16).rounded(.down) * 16, height: (fitted.height / 16).rounded(.down) * 16)
        guard size.width >= 64, size.height >= 64 else { return nil }
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        format.preferredRange = .standard
        let trimmed = UIGraphicsImageRenderer(size: size, format: format).image { _ in
            image.draw(in: CGRect(x: (size.width - fitted.width) / 2, y: (size.height - fitted.height) / 2,
                                  width: fitted.width, height: fitted.height))
        }
        return trimmed.jpegData(compressionQuality: 0.9)
    }

    /// `jpegBase64`, off the main thread.
    private static func upload(_ image: UIImage, maxSide: CGFloat, quality: CGFloat) async -> String? {
        await Task.detached(priority: .userInitiated) {
            jpegBase64(image, maxSide: maxSide, quality: quality)
        }.value
    }

    /// The photo scaled to fit `maxSide` (upright, whatever its EXIF
    /// orientation) as base64 JPEG. Scaling also drops the location and
    /// camera metadata, so none of it leaves the device.
    nonisolated static func jpegBase64(_ image: UIImage, maxSide: CGFloat, quality: CGFloat) -> String? {
        let longest = max(image.size.width, image.size.height)
        guard longest > 0 else { return nil }
        let scale = min(1, maxSide / longest)
        let size = CGSize(width: (image.size.width * scale).rounded(), height: (image.size.height * scale).rounded())
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        let resized = UIGraphicsImageRenderer(size: size, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return resized.jpegData(compressionQuality: quality)?.base64EncodedString()
    }
}

// MARK: - Wire types

private nonisolated struct ChatRequest: Encodable, Sendable {
    var messages: [AIChatMessage]
    var context: AIChatContext?
    var locale: String
    var timeZone: String
}

private nonisolated struct MealRequest: Encodable, Sendable {
    var image: String
    var note: String?
    var locale: String
    var timeZone: String
}

/// The look's wire values are GoalSex / MuscleTarget / FatTarget raw values
/// (functions/src/goalPhoto.ts reads the same).
private nonisolated struct GoalPhotoRequest: Encodable, Sendable {
    var image: String
    var sex: String
    var muscle: String
    var fat: String
    var birthYear: Int
    var confirmsOwnPhoto: Bool
    var timeZone: String
    /// The App Store gives this device a plan (see goalPhotoCall).
    var holdsPlan: Bool
}

private nonisolated struct GoalPhotoResponse: Decodable, Sendable {
    var image: String
    var remaining: Int?
    /// The older name of `remaining`, sent for one release.
    var remainingThisMonth: Int?
    /// "year" (Premium, Pro) or "once" (the free photo).
    var period: String?
    /// "free", "premium" or "pro".
    var tier: String?
}

private nonisolated struct EntitlementRequest: Encodable, Sendable {
    var transactions: [String]
    /// The year the goal photos left are counted in is the member's own.
    var timeZone: String
}

private nonisolated struct EntitlementResponse: Decodable, Sendable {
    /// Any paid plan.
    var premium: Bool
    /// "premium" or "pro"; nil without a plan.
    var tier: String?
    /// The plan's goal photos left this year.
    var goalPhotosLeft: Int?
    /// Whether this account's one free goal photo is used.
    var freeGoalPhotoUsed: Bool?
}

/// What a limit error said it counted.
nonisolated struct ServerLimit: Equatable, Sendable {
    /// "free", "premium" or "pro".
    var tier: String?
    /// "day", "year" or "once".
    var period: String?
}

private nonisolated struct DeleteRequest: Encodable, Sendable {
    var appleRevocation: String
}

private nonisolated struct DeleteResponse: Decodable, Sendable {
    var deleted: Bool
}

/// App Attest on devices; the debug provider in the simulator and in
/// Debug builds (its token is registered in the Firebase console). The
/// server only requires App Check once `config/ai.enforceAppCheck` is on.
nonisolated final class MUSQAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> (any AppCheckProvider)? {
        #if targetEnvironment(simulator) || DEBUG
        return AppCheckDebugProvider(app: app)
        #else
        return AppAttestProvider(app: app)
        #endif
    }
}
