//
//  Purchases.swift
//  GymWorkout
//
//  What MUSQ sells (tiers 2026-11-22, owner: "thêm 2 gói tháng năm là pro",
//  priced "như cal ai"):
//  - Premium: the common mistakes in the trainer, Preset 2 and 3 for every
//    group, no ads, and the AI features at a starter allowance. Yearly in
//    the MUSQ Premium subscription group. The one-time lifetime unlock was
//    taken off sale on 2026-11-23 (owner: "bỏ gói lifetime"); everyone who
//    bought it keeps Premium.
//  - Pro: everything in Premium with the full AI allowance. Monthly or
//    yearly, in the same group at a higher level, so a yearly Premium
//    member upgrades in place (Apple prorates) and nobody pays for both.
//  Every exercise, every key tip, logging, history and recovery stay free.
//  StoreKit 2 keeps the receipts, so the tier is simply the best current
//  entitlement held.
//
//  The yearly and lifetime products keep their Remove Ads ids (an App Store
//  product id can never be made again), so anyone who bought Remove Ads has
//  Premium.
//

import Foundation
import Observation
import StoreKit

@Observable
final class Purchases {

    /// What a member has: nothing, Premium, or Pro (Premium with more AI).
    nonisolated enum Tier: Int, Comparable, Sendable {
        case free, premium, pro

        static func < (lhs: Tier, rhs: Tier) -> Bool { lhs.rawValue < rhs.rawValue }

        /// The AI allowance at this tier; nil for free, which has no AI
        /// beyond its one goal photo (`AILimits.freeGoalPhotos`).
        /// The server enforces it (per-tier limits in
        /// functions/src/config.ts); these mirror its defaults for the
        /// paywall, the FAQ and the chat, so change both together.
        var ai: AILimits? {
            switch self {
            case .free: return nil
            // Owner 2026-11-22: "premium k đc meal scan", so Premium never
            // costs more than it earns. Goal photos, owner 2026-11-23: one
            // ever without a plan (`AILimits.freeGoalPhotos`), Premium 2 a
            // year, Pro 5 a year. These mirror functions/src/config.ts
            // goalPhotoOnceLimitFree, goalPhotoYearlyLimitPremium and
            // goalPhotoYearlyLimitPro.
            case .premium: return AILimits(chatPerDay: 10, mealScansPerDay: 0, goalPhotos: .perYear(2))
            case .pro: return AILimits(chatPerDay: 30, mealScansPerDay: 20, goalPhotos: .perYear(5))
            }
        }
    }

    nonisolated struct AILimits: Equatable, Sendable {
        let chatPerDay: Int
        /// 0 when the tier has no meal scans.
        let mealScansPerDay: Int
        let goalPhotos: GoalPhotos

        nonisolated enum GoalPhotos: Equatable, Sendable {
            /// A fresh allowance each calendar year, in the member's time
            /// zone, as the server counts it.
            case perYear(Int)
        }

        /// Goal photos a year (`GoalPhotos.perYear`).
        var goalPhotosPerYear: Int? {
            switch goalPhotos {
            case .perYear(let count): return count
            }
        }

        /// One goal photo for a member without a plan, ever, per account:
        /// the server's goalPhotoOnceLimitFree.
        static let freeGoalPhotos = 1
    }

    /// Plain constants and pure lookups, usable from any isolation.
    nonisolated enum ProductID {
        static let yearly = "com.SamCorp.GymWorkout.removeads.yearly"
        /// Never created in App Store Connect (Pro has the monthly plan), and
        /// the server doesn't count it: not in `premium`, so it's never a
        /// tier here either.
        static let monthly = "com.SamCorp.GymWorkout.premium.monthly"
        /// Off sale since 2026-11-23: no longer loaded or offered, but a
        /// purchase made before still counts (`premium`, `rank`), so its
        /// buyers keep Premium for good.
        static let lifetime = "com.SamCorp.GymWorkout.removeads.lifetime"
        /// Pro, priced like Cal AI: 14.99 a month, 39.99 a year.
        static let proMonthly = "com.SamCorp.GymWorkout.pro.monthly"
        static let proYearly = "com.SamCorp.GymWorkout.pro.yearly"
        /// What the app asks the App Store for, so the only plans it can
        /// offer. A product that isn't on sale yet doesn't come back either.
        static let all = [proYearly, proMonthly, yearly]
        static let pro: Set<String> = [proMonthly, proYearly]
        /// Every paid product, Pro included: what counts as an entitlement,
        /// and what the server's check of the AI features is sent (see
        /// `AIService.syncEntitlements`).
        static let premium: Set<String> = [yearly, lifetime, proMonthly, proYearly]

        static func tier(of id: String) -> Tier {
            pro.contains(id) ? .pro : premium.contains(id) ? .premium : .free
        }

        /// Which of two held plans counts as the active one: Pro over the
        /// lifetime unlock over the Premium subscription.
        static func rank(_ id: String) -> Int {
            switch id {
            case proYearly, proMonthly: return 3
            case lifetime: return 2
            case yearly, monthly: return 1
            default: return 0
            }
        }
    }

    /// The plans as the App Store prices them, Pro first; empty until
    /// loaded, or if the store can't be reached.
    private(set) var products: [Product] = []
    /// True once the entitlements have been checked this launch.
    private(set) var hasCheckedEntitlements = false
    /// The best plan held, if any (see `ProductID.rank`).
    private(set) var activePlan: String? {
        didSet { UserDefaults.standard.set(activePlan, forKey: Self.cacheKey) }
    }
    private(set) var isLoadingProducts = false

    var tier: Tier {
        #if DEBUG
        // `DEBUG_PRO=1` or `DEBUG_PREMIUM=1` in the launch environment, to
        // look at a paid tier without a purchase (simctl can't use the
        // StoreKit configuration file).
        let environment = ProcessInfo.processInfo.environment
        if environment["DEBUG_PRO"] == "1" { return .pro }
        if environment["DEBUG_PREMIUM"] == "1" { return .premium }
        #endif
        return activePlan.map(ProductID.tier(of:)) ?? .free
    }

    /// Any paid plan, Premium or Pro: what unlocks the Premium features.
    var isPremium: Bool { tier >= .premium }
    var isPro: Bool { tier == .pro }

    /// Whether Pro can be offered: false only once the App Store has
    /// answered without its plans (not on sale). While prices load, or when
    /// the store can't be reached, it's still offered, and the paywall shows
    /// Try Again.
    var sellsPro: Bool {
        #if DEBUG
        if Self.usesSamplePlans { return true }
        #endif
        return products.isEmpty || proYearly != nil || proMonthly != nil
    }

    #if DEBUG
    /// `-paywall.samplePlans YES`: the paywall shows the StoreKit file's
    /// plans and prices (the simulator can't load the StoreKit configuration).
    static var usesSamplePlans: Bool { UserDefaults.standard.bool(forKey: "paywall.samplePlans") }
    #endif

    @ObservationIgnored private var updates: Task<Void, Never>?

    /// The last known answer, so a relaunch doesn't flash an ad before
    /// StoreKit has been asked again. Named for Remove Ads, which it was;
    /// renaming it would show ads to buyers until StoreKit answers.
    private static let cacheKey = "removeAds.activePlan"

    init() {
        activePlan = UserDefaults.standard.string(forKey: Self.cacheKey)
        // Renewals, refunds, Ask to Buy approvals and purchases made on
        // another device all arrive here.
        updates = Task { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                }
                await self?.refreshEntitlements()
            }
        }
    }

    deinit { updates?.cancel() }

    var yearly: Product? { products.first { $0.id == ProductID.yearly } }
    var monthly: Product? { products.first { $0.id == ProductID.monthly } }
    var proYearly: Product? { products.first { $0.id == ProductID.proYearly } }
    var proMonthly: Product? { products.first { $0.id == ProductID.proMonthly } }

    /// Whether this Apple Account can still take `product`'s introductory
    /// offer. Offers are one per subscription group, so a trial of Premium
    /// yearly uses up Pro's too.
    func isEligibleForTrial(_ product: Product) async -> Bool {
        guard product.subscription?.introductoryOffer != nil else { return false }
        return await product.subscription?.isEligibleForIntroOffer ?? false
    }

    /// "3 days" when `product`'s introductory offer is a free trial, read
    /// from App Store Connect; nil when it has none, or one that isn't free.
    nonisolated static func freeTrialLength(of product: Product) -> String? {
        guard let offer = product.subscription?.introductoryOffer, offer.paymentMode == .freeTrial else { return nil }
        return trialLength(of: offer.period)
    }

    nonisolated static func trialLength(of period: Product.SubscriptionPeriod) -> String {
        switch period.unit {
        case .day: return period.value == 1 ? String(localized: "1 day") : String(localized: "\(period.value) days")
        case .week: return String(localized: "\(period.value * 7) days")
        case .month: return period.value == 1 ? String(localized: "1 month") : String(localized: "\(period.value) months")
        case .year: return period.value == 1 ? String(localized: "1 year") : String(localized: "\(period.value) years")
        @unknown default: return String(localized: "7 days", comment: "Free trial length")
        }
    }

    /// Whether this Apple Account can still take the yearly plan's free
    /// trial. Only then may the paywall mention one.
    func isEligibleForTrial() async -> Bool {
        guard let yearly, yearly.subscription?.introductoryOffer != nil else { return false }
        return await yearly.subscription?.isEligibleForIntroOffer ?? false
    }

    /// Whether the yearly plan's introductory offer is a free trial (rather
    /// than a discount), which is what "free" copy needs.
    var yearlyOffersFreeTrial: Bool {
        yearly?.subscription?.introductoryOffer?.paymentMode == .freeTrial
    }

    /// "7 days", read from the yearly plan's offer so the copy can't drift
    /// from App Store Connect.
    var trialLength: String {
        guard let period = yearly?.subscription?.introductoryOffer?.period else {
            return String(localized: "7 days", comment: "Free trial length")
        }
        switch period.unit {
        case .day: return period.value == 1 ? String(localized: "1 day") : String(localized: "\(period.value) days")
        case .week: return String(localized: "\(period.value * 7) days")
        case .month: return period.value == 1 ? String(localized: "1 month") : String(localized: "\(period.value) months")
        case .year: return period.value == 1 ? String(localized: "1 year") : String(localized: "\(period.value) years")
        @unknown default: return String(localized: "7 days", comment: "Free trial length")
        }
    }

    // MARK: - Loading

    func loadProducts() async {
        guard products.isEmpty, !isLoadingProducts else { return }
        isLoadingProducts = true
        defer { isLoadingProducts = false }
        do {
            let loaded = try await Product.products(for: ProductID.all)
            products = ProductID.all.compactMap { id in loaded.first { $0.id == id } }
        } catch {
            products = []
        }
    }

    func refreshEntitlements() async {
        var best: String?
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result,
                  ProductID.premium.contains(transaction.productID),
                  transaction.revocationDate == nil else { continue }
            if best.map({ ProductID.rank(transaction.productID) > ProductID.rank($0) }) ?? true {
                best = transaction.productID
            }
        }
        let changed = best != activePlan
        activePlan = best
        hasCheckedEntitlements = true
        // The server keeps its own record of the tier for the AI limits:
        // tell it now, so an upgrade counts from the next question; on the
        // other checks (launch, back to the app), catch it up only if an
        // earlier sync didn't land.
        if changed {
            Task { await AIService.shared.syncEntitlements() }
        } else {
            let tier = self.tier
            Task { await AIService.shared.syncIfBehind(localTier: tier) }
        }
    }

    // MARK: - Buying

    enum Outcome {
        case purchased
        /// Waiting on Ask to Buy or a payment check; it lands via `updates`.
        case pending
        case cancelled
    }

    func purchase(_ product: Product) async throws -> Outcome {
        switch try await product.purchase() {
        case .success(let result):
            guard case .verified(let transaction) = result else {
                throw PurchaseError.unverified
            }
            await transaction.finish()
            await refreshEntitlements()
            return .purchased
        case .pending:
            return .pending
        case .userCancelled:
            return .cancelled
        @unknown default:
            return .cancelled
        }
    }

    /// Asks the App Store to resend this Apple Account's purchases.
    func restore() async throws {
        try await AppStore.sync()
        await refreshEntitlements()
    }

    enum PurchaseError: LocalizedError {
        case unverified

        var errorDescription: String? {
            String(localized: "The App Store couldn't verify this purchase. Try again, or use Restore Purchases.")
        }
    }
}

/// Where the app's legal pages live.
enum AppLinks {
    static let privacy = URL(string: "https://musq.app/privacy.html")!
    static let terms = URL(string: "https://musq.app/terms.html")!
    static let support = URL(string: "https://musq.app/support/")!
    static let supportEmail = "manhcuong531@gmail.com"
    static let supportMail = URL(string: "mailto:\(supportEmail)?subject=MUSQ%20Support")!

    /// A mail to `supportEmail` with this subject and body, encoded for a
    /// mailto link (RFC 6068: only unreserved ASCII as it is, line breaks as
    /// CRLF). The body is cut to `limit` characters, so the link stays a
    /// length any mail app opens: a Vietnamese letter takes up to nine
    /// characters once encoded.
    static func mail(subject: String, body: String, limit: Int = 1_500) -> URL? {
        let unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
        func encoded(_ text: String) -> String { text.addingPercentEncoding(withAllowedCharacters: unreserved) ?? "" }
        let cut = body.count > limit ? String(body.prefix(limit)) + "…" : body
        let text = cut.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\n", with: "\r\n")
        return URL(string: "mailto:\(supportEmail)?subject=\(encoded(subject))&body=\(encoded(text))")
    }
}
