//
//  Purchases.swift
//  GymWorkout
//
//  MUSQ Premium, the app's only purchase: the common mistakes and Form
//  Comparison in the trainer, Preset 2 and 3 for every group, and no ads.
//  Every exercise, every key tip, logging, history and recovery stay free. Two ways to pay — yearly
//  in the MUSQ Premium subscription group, or a one-time lifetime unlock —
//  and either counts the same. (A monthly plan for the same group is wired up
//  below but waits on App Store Connect.) StoreKit 2 keeps the receipts, so
//  "is premium" is simply "holds a current entitlement to any of them".
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

    enum ProductID {
        static let yearly = "com.SamCorp.GymWorkout.removeads.yearly"
        /// Not in App Store Connect yet, so it's left out of `all`: the app
        /// never asks for it or shows it. Add it back to `all` once the
        /// product exists there, and the paywall offers it as it is.
        static let monthly = "com.SamCorp.GymWorkout.premium.monthly"
        static let lifetime = "com.SamCorp.GymWorkout.removeads.lifetime"
        static let all = [yearly, lifetime]
    }

    /// The plans as the App Store prices them, yearly first; empty until
    /// loaded, or if the store can't be reached.
    private(set) var products: [Product] = []
    /// True once the entitlements have been checked this launch.
    private(set) var hasCheckedEntitlements = false
    /// Which plan is active, if any.
    private(set) var activePlan: String? {
        didSet { UserDefaults.standard.set(activePlan, forKey: Self.cacheKey) }
    }
    private(set) var isLoadingProducts = false

    var isPremium: Bool {
        #if DEBUG
        // `DEBUG_PREMIUM=1` in the launch environment, to look at the
        // premium side without a purchase (simctl can't use the StoreKit
        // configuration file).
        if ProcessInfo.processInfo.environment["DEBUG_PREMIUM"] == "1" { return true }
        #endif
        return activePlan != nil
    }

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
    var lifetime: Product? { products.first { $0.id == ProductID.lifetime } }

    /// Whether this Apple Account can still take the yearly plan's free
    /// trial. Only then may the paywall mention one.
    func isEligibleForTrial() async -> Bool {
        guard let yearly, yearly.subscription?.introductoryOffer != nil else { return false }
        return await yearly.subscription?.isEligibleForIntroOffer ?? false
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
        var plan: String?
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result,
                  ProductID.all.contains(transaction.productID),
                  transaction.revocationDate == nil else { continue }
            // Lifetime wins if more than one is held.
            if plan != ProductID.lifetime { plan = transaction.productID }
        }
        activePlan = plan
        hasCheckedEntitlements = true
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
            "The App Store couldn't verify this purchase. Try again, or use Restore Purchases."
        }
    }
}

/// Where the app's legal pages live.
enum AppLinks {
    static let privacy = URL(string: "https://manhcuong5311-hue.github.io/musq/privacy.html")!
    static let terms = URL(string: "https://manhcuong5311-hue.github.io/musq/terms.html")!
    static let support = URL(string: "https://manhcuong5311-hue.github.io/musq/")!
}
