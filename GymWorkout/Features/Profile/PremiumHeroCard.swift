//
//  PremiumHeroCard.swift
//  GymWorkout
//
//  The Premium offer at the top of Profile, for anyone without it: the two
//  lifters from head to knee, everything Premium adds, and a button that
//  starts the yearly plan right from the card — with its free trial when the
//  Apple Account can still take one — instead of opening the Premium sheet.
//  Since the card is a purchase screen of its own, it carries what Apple asks
//  of one: the billed price, what happens when the trial ends, the terms and
//  a way to restore. Lifetime stays in the Premium sheet.
//
//  Dark in both appearances: the photo is shot on charcoal, and the card is
//  drawn as the photo's own ground.
//

import StoreKit
import SwiftUI

struct PremiumHeroCard: View {
    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall
    @State private var hasLoaded = false
    /// Whether this Apple Account can still take the yearly free trial. Nil
    /// until asked: no price or trial shows before the card knows which.
    @State private var isEligibleForTrial: Bool?
    @State private var isWorking = false
    @State private var alert: String?

    /// The photo's backdrop, so photo and card read as one surface.
    private static let ground = Color(hex: 0x1B1B1C)
    private static let radius: CGFloat = 22
    /// The part of the photo that shows, width over height: all of it across,
    /// down to just under the knees (1,160 of its 1,536 rows).
    private static let photoAspect: CGFloat = 1024 / 1160

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            photo
            VStack(alignment: .leading, spacing: 0) {
                pitch
                benefits
                    .padding(.top, 22)
                Hairline(opacity: 0.08)
                    .padding(.top, 22)
                checkout
                    .padding(.top, 18)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 18)
        }
        .background(Self.ground)
        .clipShape(RoundedRectangle(cornerRadius: Self.radius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Self.radius, style: .continuous)
                .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1)
        )
        // Every DS colour inside resolves to its dark value, whatever the
        // system appearance.
        .environment(\.colorScheme, .dark)
        .task {
            await purchases.loadProducts()
            hasLoaded = true
        }
        .task(id: purchases.yearly?.id) {
            isEligibleForTrial = purchases.yearly == nil ? nil : await purchases.isEligibleForTrial()
        }
        .alert("MUSQ Premium", isPresented: Binding(get: { alert != nil }, set: { if !$0 { alert = nil } })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alert ?? "")
        }
    }

    // MARK: - Photo

    private var photo: some View {
        Color.clear
            .aspectRatio(Self.photoAspect, contentMode: .fit)
            .overlay(alignment: .top) {
                // Fills the width, so it runs past the bottom and is cut there.
                Image("Heropremium")
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
            // A soft edge just under the knees, into the card.
            .overlay {
                LinearGradient(stops: [
                    .init(color: Self.ground.opacity(0), location: 0.9),
                    .init(color: Self.ground, location: 1),
                ], startPoint: .top, endPoint: .bottom)
            }
            .overlay(alignment: .top) {
                badges.padding(14)
            }
            .accessibilityHidden(true)
    }

    private var badges: some View {
        HStack {
            Text("MUSQ PREMIUM")
                .font(.mono(9.5, .semibold))
                .trackingEm(0.1, size: 9.5)
                .foregroundStyle(DS.silver)
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(Capsule().fill(DS.glass(0.6)))
                .overlay(Capsule().strokeBorder(DS.silver.opacity(0.14), lineWidth: 1))
            Spacer(minLength: 8)
            if case .yearly(_, trial: true) = offer {
                Text("\(purchases.trialLength.uppercased()) FREE")
                    .font(.mono(9.5, .semibold))
                    .trackingEm(0.1, size: 9.5)
                    .foregroundStyle(DS.ink)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(DS.silver))
            }
        }
    }

    // MARK: - Pitch

    private var pitch: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Train like a coach is watching.")
                .font(.ui(27, .semibold))
                .tracking(-0.7)
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
            Text("Premium shows you what bad form looks like before it sneaks into your sets. Plus room to save more of your own sessions, and not a single ad.")
                .font(.ui(14))
                .cssLineHeight(14, 1.5)
                .foregroundStyle(DS.silver.opacity(0.62))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var benefits: some View {
        VStack(alignment: .leading, spacing: 16) {
            BenefitRow(symbol: "exclamationmark.triangle", title: "See the common mistakes",
                       detail: "The form faults most lifters make, shown right on the 3D lifter as it moves.")
            BenefitRow(symbol: "square.stack.3d.up", title: "Save 3 presets per muscle",
                       detail: "Keep Preset 2 and 3 of your own for each group, so a different session is one tap away.")
            BenefitRow(symbol: "nosign", title: "Zero ads",
                       detail: "No banners, no full-screen breaks. Just you and the bar.")
            BenefitRow(symbol: "heart", title: "Keep MUSQ growing",
                       detail: "Your plan funds the new exercises and features still to come.")
        }
    }

    // MARK: - Checkout

    private enum Offer {
        case loading
        case unavailable
        case yearly(Product, trial: Bool)
    }

    private var offer: Offer {
        if let yearly = purchases.yearly {
            guard let isEligibleForTrial else { return .loading }
            return .yearly(yearly, trial: isEligibleForTrial && purchases.yearlyOffersFreeTrial)
        }
        return !hasLoaded || purchases.isLoadingProducts ? .loading : .unavailable
    }

    @ViewBuilder
    private var checkout: some View {
        switch offer {
        case .loading:
            ProgressView()
                .tint(DS.silver.opacity(0.5))
                .frame(maxWidth: .infinity, minHeight: 130)
                .accessibilityLabel("Loading price")
        case .unavailable:
            VStack(alignment: .leading, spacing: 12) {
                Text(purchases.products.isEmpty
                     ? "Prices couldn't be loaded from the App Store. Check your connection and try again."
                     : "The yearly plan couldn't be loaded right now. The other plans are in Premium.")
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                WideButton(title: purchases.products.isEmpty ? "Try Again" : "See Plans", prominent: false) {
                    if purchases.products.isEmpty {
                        Task { await purchases.loadProducts() }
                    } else {
                        paywall.show(.profile)
                    }
                }
            }
        case .yearly(let yearly, let trial):
            yearlyCheckout(yearly, trial: trial)
        }
    }

    private func yearlyCheckout(_ yearly: Product, trial: Bool) -> some View {
        let price = yearly.displayPrice
        let monthly = (yearly.price / 12).formatted(yearly.priceFormatStyle)
        let trialLength = purchases.trialLength
        return VStack(alignment: .leading, spacing: 0) {
            // The billed price is the biggest number on the card.
            Text(trial ? "\(trialLength) free, then \(price)/year" : "\(price)/year")
                .font(.ui(18, .semibold))
                .tracking(-0.3)
                .foregroundStyle(DS.silver)
            Text(trial
                 ? "That's just \(monthly) a month, billed yearly after the trial."
                 : "That's just \(monthly) a month, billed yearly. Cancel anytime.")
                .font(.ui(12.5))
                .cssLineHeight(12.5, 1.45)
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)

            WideButton(title: trial ? "Try \(trialLength.capitalized) Free" : "Get Premium · \(price)/year",
                       prominent: true, fontSize: 16, verticalPadding: 16, cornerRadius: 14) {
                buy(yearly)
            }
            .disabled(isWorking)
            .opacity(isWorking ? 0.6 : 1)
            .overlay { if isWorking { ProgressView().tint(DS.ink) } }
            .padding(.top, 16)

            Text(trial
                 ? "Free for \(trialLength), then \(price) a year, renewing until cancelled. Cancel at least 24 hours before the trial ends and you won't be charged. Manage it in Settings › Apple Account › Subscriptions."
                 : "Renews at \(price) a year until cancelled. Cancel at least 24 hours before a renewal to stop it, in Settings › Apple Account › Subscriptions.")
                .font(.ui(11))
                .cssLineHeight(11, 1.45)
                .foregroundStyle(DS.silver.opacity(0.42))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 12)

            HStack(spacing: 14) {
                Link("Terms of Use", destination: AppLinks.terms)
                Link("Privacy Policy", destination: AppLinks.privacy)
                Spacer(minLength: 0)
                Button("Restore") { restore() }
                    .buttonStyle(.plain)
                    .disabled(isWorking)
            }
            .font(.ui(12, .semibold))
            .foregroundStyle(DS.silver.opacity(0.7))
            .padding(.top, 12)
        }
    }

    // MARK: - Actions

    /// Straight to the App Store's own purchase sheet. Once it goes through,
    /// Premium turns on and Profile drops this card.
    private func buy(_ product: Product) {
        isWorking = true
        Task {
            defer { isWorking = false }
            do {
                if try await purchases.purchase(product) == .pending {
                    alert = "Your purchase is waiting for approval. Premium turns on as soon as it goes through."
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
                if !purchases.isPremium {
                    alert = "No MUSQ Premium purchase was found for this Apple Account."
                }
            } catch {
                alert = error.localizedDescription
            }
        }
    }
}
