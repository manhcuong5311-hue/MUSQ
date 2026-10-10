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
//  On iPad the photo never follows the card's width — the asset is a single
//  1024px still, soft past about 460pt — so the card either puts it in a
//  side pane (`.wide`) or in a fixed-height band (`.stacked`).
//

import StoreKit
import SwiftUI

struct PremiumHeroCard: View {
    /// `.stacked` is the phone's card, photo over pitch; in regular it keeps
    /// the photo to a 400pt band. `.wide` puts the photo in a pane beside the
    /// pitch, for a card that spans a wide iPad column.
    enum Layout { case stacked, wide }

    var layout: Layout = .stacked

    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall
    @Environment(\.dsLayout) private var dsLayout
    @State private var hasLoaded = false
    /// Whether this Apple Account can still take the yearly free trial. Nil
    /// until asked: no price or trial shows before the card knows which.
    @State private var isEligibleForTrial: Bool?
    @State private var isWorking = false
    @State private var alert: String?
    /// The card's width on iPad, which sizes the photo pane and decides
    /// whether the price and its button share a row.
    @State private var cardWidth: CGFloat = 0

    /// The photo's backdrop, so photo and card read as one surface.
    private static let ground = Color(hex: 0x1B1B1C)
    /// The part of the photo that shows, width over height: all of it across,
    /// down to just under the knees (1,160 of its 1,536 rows).
    private static let photoAspect: CGFloat = 1024 / 1160

    private var radius: CGFloat { dsLayout.value(22, 26) }

    var body: some View {
        // One container for every arrangement, so switching between them on
        // a resize keeps the loaded price and never re-runs the tasks below.
        VStack(alignment: .leading, spacing: 0) {
            if usesWideCard {
                wideCard
            } else if dsLayout.isRegular {
                stackedRegularCard
            } else {
                photo
                VStack(alignment: .leading, spacing: 0) {
                    pitch
                    benefits
                        .padding(.top, 22)
                    Hairline(opacity: 0.08)
                        .padding(.top, 22)
                    checkout()
                        .padding(.top, 18)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
            }
        }
        .background(Self.ground)
        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
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

    // MARK: - iPad arrangements

    /// The measured width, or a guess from the column before the first
    /// measurement lands.
    private var width: CGFloat {
        cardWidth > 0 ? cardWidth : max(0, dsLayout.containerWidth - 2 * dsLayout.gutter)
    }

    /// The side pane only once the pitch beside it keeps about 500pt; a
    /// narrower wide card (a 13-inch in portrait) reads better as the band.
    /// The parent sets the width either way, so switching can't feed back.
    private var usesWideCard: Bool {
        layout == .wide && dsLayout.isRegular && width >= 940
    }

    /// Photo pane on the leading side, as tall as the pitch beside it and
    /// at least 540: the lifters head to knee at the card's full height.
    private var wideCard: some View {
        let pane = min(max(width * 0.40, 380), 460)
        let content = width - pane - 64
        return VStack(alignment: .leading, spacing: 0) {
            pitch
            benefitGrid(columns: content >= 480 ? 2 : 1)
                .padding(.top, 28)
            Hairline(opacity: 0.08)
                .padding(.top, 28)
            checkout(ctaWidth: content >= 560 ? 300 : nil)
                .padding(.top, 22)
        }
        .padding(.horizontal, 32)
        .padding(.top, 30)
        .padding(.bottom, 32)
        .padding(.leading, pane)
        .frame(maxWidth: .infinity, minHeight: 540, alignment: .topLeading)
        // A background takes the card's height, however tall the pitch runs.
        .background(alignment: .leading) {
            widePhoto
                .frame(width: pane)
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { cardWidth = $0 }
    }

    private var stackedRegularCard: some View {
        let content = width - 48
        return VStack(alignment: .leading, spacing: 0) {
            bandPhoto
            VStack(alignment: .leading, spacing: 0) {
                pitch
                benefitGrid(columns: 2)
                    .padding(.top, 26)
                Hairline(opacity: 0.08)
                    .padding(.top, 26)
                checkout(ctaWidth: content >= 560 ? 280 : nil)
                    .padding(.top, 20)
            }
            .padding(24)
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { cardWidth = $0 }
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

    /// The side pane: height-driven and top-anchored, so the crop is the
    /// phone's head-to-knee whatever the card's height, feathered into the
    /// pitch on its trailing edge.
    private var widePhoto: some View {
        Color.clear
            .overlay(alignment: .top) {
                Image("Heropremium")
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
            .overlay {
                LinearGradient(stops: [
                    .init(color: Self.ground.opacity(0), location: 0.8),
                    .init(color: Self.ground, location: 1),
                ], startPoint: .leading, endPoint: .trailing)
            }
            .overlay(alignment: .top) {
                badges.padding(16)
            }
            .accessibilityHidden(true)
    }

    /// A 400pt band across the card: the photo at its phone crop, centred,
    /// with its sides feathered into the charcoal so the band reads as one
    /// backdrop rather than a picture in a box.
    private var bandPhoto: some View {
        Color.clear
            .aspectRatio(Self.photoAspect, contentMode: .fit)
            .overlay(alignment: .top) {
                Image("Heropremium")
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
            .overlay {
                LinearGradient(stops: [
                    .init(color: Self.ground.opacity(0), location: 0.88),
                    .init(color: Self.ground, location: 1),
                ], startPoint: .top, endPoint: .bottom)
            }
            .overlay {
                HStack(spacing: 0) {
                    LinearGradient(colors: [Self.ground, Self.ground.opacity(0)],
                                   startPoint: .leading, endPoint: .trailing)
                        .frame(width: 48)
                    Spacer(minLength: 0)
                    LinearGradient(colors: [Self.ground.opacity(0), Self.ground],
                                   startPoint: .leading, endPoint: .trailing)
                        .frame(width: 48)
                }
            }
            .frame(height: 400)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .top) {
                badges.padding(16)
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
        let isWide = usesWideCard
        let titleSize: CGFloat = isWide ? 34 : dsLayout.value(27, 32)
        let bodySize: CGFloat = isWide ? 16 : dsLayout.value(14, 15.5)
        return VStack(alignment: .leading, spacing: dsLayout.value(10, 12)) {
            Text("Train like a coach is watching.")
                .font(.ui(titleSize, .semibold))
                .tracking(isWide ? -0.9 : dsLayout.value(-0.7, -0.85))
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
            Text("Premium shows you what bad form looks like before it sneaks into your sets. Plus room to save more of your own sessions, and not a single ad.")
                .font(.ui(bodySize))
                .cssLineHeight(bodySize, 1.5)
                .foregroundStyle(DS.silver.opacity(0.62))
                .fixedSize(horizontal: false, vertical: true)
        }
        // A measure, not a stretch, across a wide card; nil on iPhone.
        .frame(maxWidth: dsLayout.isRegular ? 520 : nil, alignment: .leading)
    }

    private var benefits: some View {
        VStack(alignment: .leading, spacing: 16) {
            benefitRows
        }
    }

    private func benefitGrid(columns: Int) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 24, alignment: .topLeading),
                                 count: max(1, columns)),
                  alignment: .leading, spacing: 18) {
            benefitRows
        }
    }

    @ViewBuilder
    private var benefitRows: some View {
        BenefitRow(symbol: "exclamationmark.triangle", title: "See the common mistakes",
                   detail: "The form faults most lifters make, shown right on the 3D lifter as it moves.")
        BenefitRow(symbol: "square.stack.3d.up", title: "Save 3 presets per muscle",
                   detail: "Keep Preset 2 and 3 of your own for each group, so a different session is one tap away.")
        BenefitRow(symbol: "nosign", title: "Zero ads",
                   detail: "No banners, no full-screen breaks. Just you and the bar.")
        BenefitRow(symbol: "heart", title: "Keep MUSQ growing",
                   detail: "Your plan funds the new exercises and features still to come.")
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

    /// `ctaWidth` puts the price and its button side by side, the button at
    /// that width; nil stacks them, as on iPhone.
    @ViewBuilder
    private func checkout(ctaWidth: CGFloat? = nil) -> some View {
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
                    .font(.ui(dsLayout.value(13, 14)))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                WideButton(title: purchases.products.isEmpty ? "Try Again" : "See Plans", prominent: false) {
                    if purchases.products.isEmpty {
                        Task { await purchases.loadProducts() }
                    } else {
                        paywall.show(.profile)
                    }
                }
                .dsCTA(300, alignment: .leading)
            }
            // The same room as the price block it stands in for, so the card
            // doesn't jump when prices arrive.
            .frame(minHeight: dsLayout.isRegular ? 130 : nil, alignment: .top)
        case .yearly(let yearly, let trial):
            yearlyCheckout(yearly, trial: trial, ctaWidth: ctaWidth)
        }
    }

    private func yearlyCheckout(_ yearly: Product, trial: Bool, ctaWidth: CGFloat?) -> some View {
        let price = yearly.displayPrice
        let monthly = (yearly.price / 12).formatted(yearly.priceFormatStyle)
        let trialLength = purchases.trialLength
        let detailSize: CGFloat = dsLayout.value(12.5, 13.5)
        let termsSize: CGFloat = dsLayout.value(11, 12)

        // The billed price is the biggest number on the card.
        let priceLine = Text(trial ? "\(trialLength) free, then \(price)/year" : "\(price)/year")
            .font(.ui(dsLayout.value(18, 22), .semibold))
            .tracking(-0.3)
            .foregroundStyle(DS.silver)
        let monthlyLine = Text(trial
                               ? "That's just \(monthly) a month, billed yearly after the trial."
                               : "That's just \(monthly) a month, billed yearly. Cancel anytime.")
            .font(.ui(detailSize))
            .cssLineHeight(detailSize, 1.45)
            .foregroundStyle(DS.silver.opacity(0.6))
            .fixedSize(horizontal: false, vertical: true)
        let cta = WideButton(title: trial ? "Try \(trialLength.capitalized) Free" : "Get Premium · \(price)/year",
                             prominent: true, fontSize: 16, verticalPadding: 16, cornerRadius: 14) {
            buy(yearly)
        }
        .disabled(isWorking)
        .opacity(isWorking ? 0.6 : 1)
        .overlay { if isWorking { ProgressView().tint(DS.ink) } }

        return VStack(alignment: .leading, spacing: 0) {
            if let ctaWidth {
                HStack(alignment: .center, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        priceLine
                            .fixedSize(horizontal: false, vertical: true)
                        monthlyLine
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    cta
                        .frame(width: ctaWidth)
                }
            } else {
                priceLine
                monthlyLine
                    .padding(.top, 4)
                cta
                    // Capped on iPad, where the card can run 600pt wide;
                    // nil bounds on iPhone.
                    .dsCTA(DS.Layout.ctaMaxWidth, alignment: .leading)
                    .padding(.top, 16)
            }

            Text(trial
                 ? "Free for \(trialLength), then \(price) a year, renewing until cancelled. Cancel at least 24 hours before the trial ends and you won't be charged. Manage it in Settings › Apple Account › Subscriptions."
                 : "Renews at \(price) a year until cancelled. Cancel at least 24 hours before a renewal to stop it, in Settings › Apple Account › Subscriptions.")
                .font(.ui(termsSize))
                .cssLineHeight(termsSize, 1.45)
                .foregroundStyle(DS.silver.opacity(0.42))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: dsLayout.isRegular ? 560 : nil, alignment: .leading)
                .padding(.top, dsLayout.value(12, 16))

            HStack(spacing: 14) {
                Link("Terms of Use", destination: AppLinks.terms)
                Link("Privacy Policy", destination: AppLinks.privacy)
                Spacer(minLength: 0)
                Button("Restore") { restore() }
                    .buttonStyle(.plain)
                    .disabled(isWorking)
            }
            .font(.ui(dsLayout.value(12, 13), .semibold))
            .foregroundStyle(DS.silver.opacity(0.7))
            .padding(.top, dsLayout.value(12, 14))
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
