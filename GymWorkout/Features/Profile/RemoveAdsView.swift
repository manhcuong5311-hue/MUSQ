//
//  RemoveAdsView.swift
//  GymWorkout
//
//  The Remove Ads sheet: a one-time lifetime unlock or a yearly
//  subscription, with the subscription terms Apple asks for spelled out
//  under the button. Nothing else in the app changes when either is bought.
//

import StoreKit
import SwiftUI

struct RemoveAdsView: View {
    @Environment(Purchases.self) private var purchases
    @Environment(\.dismiss) private var dismiss
    /// The plan tapped; until then Lifetime, or whichever plan loaded.
    @State private var selection: String?
    @State private var isWorking = false
    @State private var alert: String?
    @State private var managesSubscription = false

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        CircleIconButton(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(DS.silver)
                        }
                        .accessibilityLabel("Close")
                    }

                    if purchases.hasRemovedAds {
                        thanks
                    } else {
                        offer
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .task { await purchases.loadProducts() }
        .manageSubscriptionsSheet(isPresented: $managesSubscription)
        .alert("Remove Ads", isPresented: Binding(get: { alert != nil }, set: { if !$0 { alert = nil } })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alert ?? "")
        }
    }

    // MARK: - Offer

    private var offer: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: "MUSQ")
            Text("Remove ads")
                .font(.ui(28, .semibold))
                .tracking(-0.7)
                .foregroundStyle(DS.silver)
                .padding(.top, 6)
            Text("Every feature in MUSQ is free and stays free. Removing ads only clears the banner and the full-screen ads — and helps pay for new exercises.")
                .font(.ui(14))
                .cssLineHeight(14, 1.5)
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)

            plans
                .padding(.top, 26)

            WideButton(title: buttonTitle, prominent: true, fontSize: 15, verticalPadding: 15) {
                buy()
            }
            .disabled(selectedProduct == nil || isWorking)
            .opacity(selectedProduct == nil || isWorking ? 0.5 : 1)
            .overlay { if isWorking { ProgressView().tint(DS.ink) } }
            .padding(.top, 22)

            Button("Restore Purchases") { restore() }
                .font(.ui(13.5, .semibold))
                .foregroundStyle(DS.silver.opacity(0.75))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .buttonStyle(.plain)
                .disabled(isWorking)

            terms
                .padding(.top, 10)
        }
    }

    @ViewBuilder
    private var plans: some View {
        if purchases.products.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                if purchases.isLoadingProducts {
                    ProgressView().tint(DS.silver)
                } else {
                    Text("Prices couldn't be loaded from the App Store. Check your connection and try again.")
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                    WideButton(title: "Try Again", prominent: false) {
                        Task { await purchases.loadProducts() }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        } else {
            VStack(spacing: 10) {
                if let lifetime = purchases.lifetime {
                    PlanCard(title: "Lifetime", price: lifetime.displayPrice, period: "once",
                             detail: "One payment. No ads, for good.", badge: "BEST VALUE",
                             isSelected: selectedID == lifetime.id) { selection = lifetime.id }
                }
                if let yearly = purchases.yearly {
                    PlanCard(title: "Yearly", price: yearly.displayPrice, period: "per year",
                             detail: "Renews every year. Cancel anytime.", badge: nil,
                             isSelected: selectedID == yearly.id) { selection = yearly.id }
                }
            }
        }
    }

    private var terms: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(termsText)
                .font(.ui(11.5))
                .cssLineHeight(11.5, 1.45)
                .foregroundStyle(DS.silver.opacity(0.42))
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 14) {
                Link("Terms of Use", destination: AppLinks.terms)
                Link("Privacy Policy", destination: AppLinks.privacy)
            }
            .font(.ui(12, .semibold))
            .foregroundStyle(DS.silver.opacity(0.7))
        }
    }

    private var termsText: String {
        let yearly = purchases.yearly?.displayPrice ?? "the price shown"
        return "Yearly is an auto-renewing subscription: \(yearly) for 1 year of no ads. Payment is charged to your Apple Account when you confirm. It renews automatically unless cancelled at least 24 hours before the end of the current year, and the renewal is charged within 24 hours before that. Manage or cancel it in Settings › Apple Account › Subscriptions. Lifetime is a one-time purchase."
    }

    // MARK: - Thanks

    private var thanks: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 34))
                .foregroundStyle(DS.silver)
            Text("Ads removed")
                .font(.ui(28, .semibold))
                .tracking(-0.7)
                .foregroundStyle(DS.silver)
                .padding(.top, 14)
            Text(purchases.activePlan == Purchases.ProductID.yearly
                 ? "Thank you for supporting MUSQ. Your yearly plan keeps the ads away while it's active."
                 : "Thank you for supporting MUSQ. The ads are gone for good.")
                .font(.ui(14))
                .cssLineHeight(14, 1.5)
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)

            if purchases.activePlan == Purchases.ProductID.yearly {
                WideButton(title: "Manage Subscription", prominent: false) { managesSubscription = true }
                    .padding(.top, 24)
            }
            WideButton(title: "Done", prominent: true) { dismiss() }
                .padding(.top, 10)
        }
        .padding(.top, 12)
    }

    // MARK: - Actions

    private var selectedID: String? {
        selection ?? purchases.lifetime?.id ?? purchases.yearly?.id
    }

    private var selectedProduct: Product? {
        purchases.products.first { $0.id == selectedID }
    }

    private var buttonTitle: String {
        guard let product = selectedProduct else { return "Remove Ads" }
        return product.id == Purchases.ProductID.yearly
            ? "Subscribe · \(product.displayPrice) a year"
            : "Remove Ads · \(product.displayPrice)"
    }

    private func buy() {
        guard let product = selectedProduct else { return }
        isWorking = true
        Task {
            defer { isWorking = false }
            do {
                if try await purchases.purchase(product) == .pending {
                    alert = "Your purchase is waiting for approval. The ads go away as soon as it goes through."
                }
            } catch {
                alert = error.localizedDescription
            }
        }
    }

    private func restore() {
        isWorking = true
        Task {
            defer { isWorking = false }
            do {
                try await purchases.restore()
                if !purchases.hasRemovedAds {
                    alert = "No Remove Ads purchase was found for this Apple Account."
                }
            } catch {
                alert = error.localizedDescription
            }
        }
    }
}

/// One plan: the name and what it means on the left, the price on the right.
private struct PlanCard: View {
    var title: String
    var price: String
    var period: String
    var detail: String
    var badge: String?
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? DS.silver : DS.silver.opacity(0.3))
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.ui(16, .semibold))
                            .foregroundStyle(DS.silver)
                        if let badge {
                            Text(badge)
                                .font(.mono(8.5, .semibold))
                                .trackingEm(0.08, size: 8.5)
                                .foregroundStyle(DS.ink)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(DS.silver))
                        }
                    }
                    Text(detail)
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.55))
                }
                Spacer(minLength: 8)
                VStack(alignment: .trailing, spacing: 2) {
                    Text(price)
                        .font(.ui(17, .semibold))
                        .foregroundStyle(DS.silver)
                    MetaLine(text: period.uppercased(), size: 8.5)
                }
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? DS.silver.opacity(0.8) : DS.silver.opacity(0.08),
                                  lineWidth: isSelected ? 1.5 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
