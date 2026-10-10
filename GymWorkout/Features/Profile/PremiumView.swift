//
//  PremiumView.swift
//  GymWorkout
//
//  The Premium sheet: what it unlocks, the plans the App Store returned at
//  the prices it returned — yearly first, with a free trial only when the
//  Apple Account can still take one — and the subscription terms Apple asks
//  for under the button. The headline speaks to whatever was tapped to open it.
//
//  On iPad the offer is a page sheet with a centred column and the plans side
//  by side; the active state is a small sheet fitted to its content.
//

import StoreKit
import SwiftUI
import UIKit

struct PremiumView: View {
    var reason: Paywall.Reason

    @Environment(Purchases.self) private var purchases
    @Environment(\.dismiss) private var dismiss
    /// The presenting window's layout. RootView's paywall sheet is attached
    /// outside its environment calls, so on iPad this can arrive compact
    /// over a regular window; the sheet's own measured size decides then.
    @Environment(\.dsLayout) private var presenterLayout
    /// The plan tapped; until then Yearly, or the first plan that loaded.
    @State private var selection = Purchases.ProductID.yearly
    @State private var hasLoaded = false
    @State private var isEligibleForTrial = false
    @State private var isWorking = false
    @State private var alert: String?
    @State private var managesSubscription = false
    /// The sheet's size on iPad; nil until measured, and always on iPhone.
    @State private var sheetSize: CGSize?

    /// The active state's sheet width on iPad.
    private static let activeWidth: CGFloat = 520

    var body: some View {
        sheet
            .task { await load() }
            .task(id: purchases.products.map(\.id)) { await productsArrived() }
            .alert("MUSQ Premium", isPresented: Binding(get: { alert != nil }, set: { if !$0 { alert = nil } })) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alert ?? "")
            }
            .modifier(PadManageSubscriptions(isPresented: $managesSubscription) {
                // A cancellation or plan change made in the sheet shows up here.
                Task { await purchases.refreshEntitlements() }
            })
            .modifier(PremiumSheetSizing(fitted: purchases.isPremium, width: Self.activeWidth))
    }

    /// On iPad the sheet measures itself and lays out for that size; the
    /// offer draws nothing until then, so it's only ever built once.
    @ViewBuilder
    private var sheet: some View {
        if DS.isPad {
            ZStack {
                if sheetSize != nil || purchases.isPremium {
                    page
                        .environment(\.dsLayout, layout)
                } else {
                    DS.ink.ignoresSafeArea()
                }
            }
            // Measures the space offered, not the content, so the column
            // can't feed back into its own tier.
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onGeometryChange(for: CGSize.self) { $0.size } action: { sheetSize = $0 }
        } else {
            page
        }
    }

    private var page: some View {
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
                        .modifier(PadShortcut(shortcut: .cancelAction))
                    }

                    if purchases.isPremium {
                        active
                            .dsReadable(480)
                    } else {
                        offer
                            .dsReadable(600)
                    }
                }
                .padding(.horizontal, gutter)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        // The buy button and the way out stay on screen however far the
        // plans and terms scroll.
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if !purchases.isPremium { footer }
        }
    }

    // MARK: - Layout

    /// The layout inside the sheet: the presenter's on iPhone (always
    /// compact), the measured sheet's on iPad.
    private var layout: DSLayout {
        guard DS.isPad else { return presenterLayout }
        if purchases.isPremium {
            // Fitted to its content at a fixed width, so its width says
            // little about the window: keep the window's tier when known.
            if presenterLayout.isRegular { return presenterLayout.with(containerWidth: Self.activeWidth) }
            guard let size = sheetSize else {
                return DSLayout(tier: .regular, containerWidth: Self.activeWidth, containerHeight: 0)
            }
            // A compact window shows every sheet at its own full width.
            return size.width >= Self.activeWidth - 20
                ? DSLayout(tier: .regular, containerWidth: size.width, containerHeight: size.height)
                : .sheet(size: size)
        }
        return sheetSize.map { DSLayout.sheet(size: $0) } ?? presenterLayout
    }

    /// The sheet's width; the window's column before the first measurement.
    private var sheetWidth: CGFloat { sheetSize?.width ?? layout.containerWidth }

    /// 32 around the centred column of a regular sheet; the phone's gutter,
    /// and the small fitted sheet's tier gutter, otherwise.
    private var gutter: CGFloat {
        guard layout.isRegular else { return DS.Metric.gutter }
        return purchases.isPremium ? layout.gutter : 32
    }

    /// Three plans in a row once the column can give each about 190pt.
    private var usesPlanTiles: Bool {
        let count = [purchases.yearly, purchases.monthly, purchases.lifetime].compactMap { $0 }.count
        return layout.isRegular && sheetWidth >= 600 && (2...3).contains(count)
    }

    // MARK: - Offer

    private var offer: some View {
        let titleSize: CGFloat = layout.value(28, 34)
        let messageSize: CGFloat = layout.value(14, 16)
        return VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: "MUSQ PREMIUM")
            Text(headline.title)
                .font(.ui(titleSize, .semibold))
                .tracking(layout.value(-0.7, -0.9))
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: layout.isRegular ? 520 : nil, alignment: .leading)
                .padding(.top, layout.value(6, 8))
            Text(headline.message)
                .font(.ui(messageSize))
                .cssLineHeight(messageSize, 1.5)
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: layout.isRegular ? 520 : nil, alignment: .leading)
                .padding(.top, layout.value(10, 12))

            PremiumHero()
                .padding(.top, layout.value(20, 26))

            SectionEyebrow(text: "WHAT YOU GET")
                .padding(.top, layout.value(26, 32))
            FeatureTable(rows: features)
                .padding(.top, layout.value(10, 12))

            plans
                .padding(.top, layout.value(24, 28))

            Button("Restore Purchases") { restore() }
                .font(.ui(layout.value(13.5, 14.5), .semibold))
                .foregroundStyle(DS.silver.opacity(0.75))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .buttonStyle(.plain)
                .disabled(isWorking)
                .dsCTA(240)
                .dsHover(.highlight, radius: 12)
                .padding(.top, 8)

            terms
                .padding(.top, 6)
        }
    }

    private var headline: (title: String, message: String) {
        switch reason {
        case .mistake:
            return ("See the mistakes before you make them",
                    "Premium draws each exercise's common mistakes over the lifter, so you know what bad form looks like before it creeps in.")
        case .preset:
            return ("Three presets for every muscle",
                    "Preset 1 is free. Premium adds Preset 2 and 3 for every muscle group, so a different session for each one is a tap away.")
        case .onboarding, .profile:
            return ("Train with MUSQ Premium",
                    "Everything in MUSQ stays free to train with. Premium adds the common mistakes, more presets and no ads.")
        }
    }

    /// Free and Premium side by side: what everyone has, then what Premium
    /// adds, so it's plain that training itself is never behind the paywall.
    private var features: [FeatureTable.Row] {
        [
            .init(symbol: "cube", title: "\(SampleData.exercises.count) exercises in 3D", free: true),
            .init(symbol: "lightbulb", title: "Every key tip and setup step", free: true),
            .init(symbol: "list.bullet.clipboard", title: "Workout log, history and recovery", free: true),
            .init(symbol: "square.stack", title: "Basic, Advanced and Preset 1", free: true),
            .init(symbol: "exclamationmark.triangle", title: "Common mistakes over the lifter", free: false),
            .init(symbol: "square.stack.3d.up", title: "Preset 2 and 3 for every group", free: false),
            .init(symbol: "nosign", title: "No ads", free: false),
        ]
    }

    /// What Premium itself unlocks, for the active state.
    private var benefits: some View {
        VStack(alignment: .leading, spacing: 14) {
            BenefitRow(symbol: "exclamationmark.triangle", title: "The common mistakes",
                       detail: "Drawn over the lifter for every key tip.")
            BenefitRow(symbol: "square.stack.3d.up", title: "Preset 2 and 3",
                       detail: "For every muscle group.")
            BenefitRow(symbol: "nosign", title: "No ads",
                       detail: "No banner, no full-screen ads.")
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
    }

    /// The same three on iPad, as tiles in a row: icon over title.
    private var benefitTiles: some View {
        HStack(alignment: .top, spacing: 10) {
            BenefitTile(symbol: "exclamationmark.triangle", title: "The common mistakes",
                        detail: "Drawn over the lifter for every key tip.")
            BenefitTile(symbol: "square.stack.3d.up", title: "Preset 2 and 3",
                        detail: "For every muscle group.")
            BenefitTile(symbol: "nosign", title: "No ads",
                        detail: "No banner, no full-screen ads.")
        }
        // Equal heights: each tile fills the tallest one's.
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private var plans: some View {
        if storeUnavailable {
            VStack(alignment: .leading, spacing: 12) {
                Text("Prices couldn't be loaded from the App Store. Check your connection and try again.")
                    .font(.ui(layout.value(13, 14)))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                WideButton(title: "Try Again", prominent: false) {
                    Task { await load() }
                }
                .dsCTA(300, alignment: .leading)
            }
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        } else if purchases.products.isEmpty {
            // Still asking the App Store. No stand-in prices: a plan shows
            // only once the store has priced it for this storefront.
            ProgressView()
                .tint(DS.silver.opacity(0.4))
                .frame(maxWidth: .infinity, minHeight: layout.isRegular && sheetWidth >= 600 ? 168 : 150)
                .accessibilityLabel("Loading plans")
        } else if usesPlanTiles {
            HStack(alignment: .top, spacing: 12) {
                if let yearly = purchases.yearly {
                    PlanTile(title: "Yearly", price: yearly.displayPrice, period: "per year",
                             detail: yearlyDetail(yearly), badge: savingsBadge,
                             isSelected: selection == Purchases.ProductID.yearly) {
                        selection = Purchases.ProductID.yearly
                    }
                }
                if let monthly = purchases.monthly {
                    PlanTile(title: "Monthly", price: monthly.displayPrice, period: "per month",
                             detail: "Billed monthly, cancel anytime", badge: nil,
                             isSelected: selection == Purchases.ProductID.monthly) {
                        selection = Purchases.ProductID.monthly
                    }
                }
                if let lifetime = purchases.lifetime {
                    PlanTile(title: "Lifetime", price: lifetime.displayPrice, period: "once",
                             detail: "One payment, Premium for good", badge: nil,
                             isSelected: selection == Purchases.ProductID.lifetime) {
                        selection = Purchases.ProductID.lifetime
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        } else {
            // Only the plans the App Store returned, at its prices.
            VStack(spacing: 10) {
                if let yearly = purchases.yearly {
                    PlanCard(title: "Yearly", price: yearly.displayPrice, period: "per year",
                             detail: yearlyDetail(yearly), badge: savingsBadge,
                             isSelected: selection == Purchases.ProductID.yearly) {
                        selection = Purchases.ProductID.yearly
                    }
                }
                if let monthly = purchases.monthly {
                    PlanCard(title: "Monthly", price: monthly.displayPrice, period: "per month",
                             detail: "Billed monthly, cancel anytime", badge: nil,
                             isSelected: selection == Purchases.ProductID.monthly) {
                        selection = Purchases.ProductID.monthly
                    }
                }
                if let lifetime = purchases.lifetime {
                    PlanCard(title: "Lifetime", price: lifetime.displayPrice, period: "once",
                             detail: "One payment, Premium for good", badge: nil,
                             isSelected: selection == Purchases.ProductID.lifetime) {
                        selection = Purchases.ProductID.lifetime
                    }
                }
            }
        }
    }

    private var footer: some View {
        VStack(spacing: 8) {
            WideButton(title: buttonTitle, prominent: true, fontSize: 15, verticalPadding: 15) {
                buy()
            }
            .disabled(selectedProduct == nil || isWorking)
            .opacity(selectedProduct == nil || isWorking ? 0.5 : 1)
            .overlay { if isWorking { ProgressView().tint(DS.ink) } }
            .modifier(PadShortcut(shortcut: .defaultAction))
            .dsCTA(420)

            if let buttonCaption {
                Text(buttonCaption)
                    .font(.ui(layout.value(11.5, 12.5)))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: layout.isRegular ? 460 : nil)
            }

            Button(reason == .onboarding ? "Continue Free" : "Not Now") { dismiss() }
                .font(.ui(layout.value(14, 15), .semibold))
                .foregroundStyle(DS.silver.opacity(0.8))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
                .buttonStyle(.plain)
                .dsCTA(240)
                .dsHover(.highlight, radius: 12)
        }
        .padding(.horizontal, gutter)
        .padding(.top, layout.value(12, 16))
        .padding(.bottom, layout.isRegular ? 8 : 0)
        .background(DS.ink.ignoresSafeArea(edges: .bottom))
        .overlay(alignment: .top) { Hairline(opacity: 0.06) }
    }

    private var terms: some View {
        let size: CGFloat = layout.value(11.5, 12)
        return VStack(alignment: .leading, spacing: 10) {
            // Empty until the App Store returns a plan to describe.
            if !termsText.isEmpty {
                Text(termsText)
                    .font(.ui(size))
                    .cssLineHeight(size, 1.45)
                    .foregroundStyle(DS.silver.opacity(0.42))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: layout.isRegular ? 560 : nil, alignment: .leading)
            }
            HStack(spacing: 14) {
                Link("Terms of Use", destination: AppLinks.terms)
                Link("Privacy Policy", destination: AppLinks.privacy)
            }
            .font(.ui(layout.value(12, 13), .semibold))
            .foregroundStyle(DS.silver.opacity(0.7))
        }
    }

    /// Names only the plans the cards offer, at the prices they show.
    private var termsText: String {
        var plans: [String] = []
        if let monthly = purchases.monthly { plans.append("Monthly (\(monthly.displayPrice) a month)") }
        if let yearly = purchases.yearly { plans.append("Yearly (\(yearly.displayPrice) a year)") }
        var parts: [String] = []
        if !plans.isEmpty {
            let charged = showsTrial
                ? "when you confirm, or, with the Yearly free trial, when the trial ends unless you cancel at least 24 hours before"
                : "when you confirm"
            parts.append("\(plans.joined(separator: " and ")) \(plans.count == 1 ? "is an auto-renewing subscription" : "are auto-renewing subscriptions"). Payment is charged to your Apple Account \(charged). A subscription renews automatically until cancelled: cancel at least 24 hours before the end of the current period to stop the next renewal, which is charged within 24 hours before that. Manage or cancel it in Settings › Apple Account › Subscriptions.")
        }
        if purchases.lifetime != nil { parts.append("Lifetime is a one-time purchase.") }
        return parts.joined(separator: " ")
    }

    // MARK: - Active

    private var active: some View {
        let titleSize: CGFloat = layout.value(28, 34)
        let messageSize: CGFloat = layout.value(14, 16)
        return VStack(alignment: .leading, spacing: 0) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: layout.value(34, 40)))
                .foregroundStyle(DS.silver)
            SectionEyebrow(text: activePlanName.map { "MUSQ PREMIUM · \($0.uppercased())" } ?? "MUSQ PREMIUM")
                .padding(.top, 14)
            Text("Premium is on")
                .font(.ui(titleSize, .semibold))
                .tracking(layout.value(-0.7, -0.9))
                .foregroundStyle(DS.silver)
                .padding(.top, 6)
            Text(activeMessage)
                .font(.ui(messageSize))
                .cssLineHeight(messageSize, 1.5)
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)

            if layout.isRegular {
                benefitTiles
                    .padding(.top, 24)
                // Side by side under the tiles; Done alone when there's no
                // subscription to manage.
                HStack(spacing: 10) {
                    if isSubscription {
                        WideButton(title: "Manage Subscription", prominent: false) { manageSubscription() }
                    }
                    WideButton(title: "Done", prominent: true) { dismiss() }
                        .modifier(PadShortcut(shortcut: .defaultAction))
                }
                .padding(.top, 26)
            } else {
                benefits
                    .padding(.top, 22)

                if isSubscription {
                    WideButton(title: "Manage Subscription", prominent: false) { manageSubscription() }
                        .padding(.top, 24)
                }
                WideButton(title: "Done", prominent: true) { dismiss() }
                    .padding(.top, isSubscription ? 10 : 24)
            }
        }
        .padding(.top, 12)
    }

    private var activePlanName: String? {
        switch purchases.activePlan {
        case Purchases.ProductID.yearly: return "Yearly"
        case Purchases.ProductID.monthly: return "Monthly"
        case Purchases.ProductID.lifetime: return "Lifetime"
        default: return nil
        }
    }

    private var activeMessage: String {
        switch purchases.activePlan {
        case Purchases.ProductID.yearly:
            return "Thank you for supporting MUSQ. Everything below stays unlocked while your yearly plan renews."
        case Purchases.ProductID.monthly:
            return "Thank you for supporting MUSQ. Everything below stays unlocked while your monthly plan renews."
        case Purchases.ProductID.lifetime:
            return "Thank you for supporting MUSQ. Everything below is yours for good."
        default:
            return "Thank you for supporting MUSQ."
        }
    }

    private var isSubscription: Bool {
        purchases.activePlan == Purchases.ProductID.yearly || purchases.activePlan == Purchases.ProductID.monthly
    }

    // MARK: - Prices

    // Every price on this sheet is a returned Product's displayPrice: the
    // plans, terms and button copy unwrap the product itself, so nothing can
    // show for a plan the App Store didn't return, or in the wrong currency.

    /// The App Store answered with nothing: no connection, or no products.
    private var storeUnavailable: Bool {
        hasLoaded && purchases.products.isEmpty && !purchases.isLoadingProducts
    }

    /// Trial wording appears only when this Apple Account can still take the
    /// yearly plan's free trial.
    private var showsTrial: Bool {
        isEligibleForTrial && purchases.yearlyOffersFreeTrial
    }

    private var trialLength: String { purchases.trialLength }

    /// The billed price stays the card's big number; this line only explains it.
    private func yearlyDetail(_ yearly: Product) -> String {
        if showsTrial { return "\(trialLength) free, then \(yearly.displayPrice)/year" }
        return "\((yearly.price / 12).formatted(yearly.priceFormatStyle)) a month, billed yearly"
    }

    /// "SAVE 66%": a year of Yearly against twelve months of Monthly. Only
    /// when the App Store returned both, so the two prices are real and in
    /// the same currency; with no Monthly plan there's nothing to save against.
    private var savingsBadge: String? {
        guard let yearly = purchases.yearly, let monthly = purchases.monthly,
              monthly.price > 0 else { return nil }
        let percent = NSDecimalNumber(decimal: (1 - yearly.price / (monthly.price * 12)) * 100).intValue
        return percent >= 10 ? "SAVE \(percent)%" : nil
    }

    // MARK: - Actions

    private var selectedProduct: Product? {
        purchases.products.first { $0.id == selection }
    }

    /// No price until a returned plan is selected; the button is disabled
    /// until then anyway.
    private var buttonTitle: String {
        guard let product = selectedProduct else { return "Get Premium" }
        switch product.id {
        case Purchases.ProductID.yearly:
            return showsTrial ? "Start Free Trial" : "Subscribe · \(product.displayPrice) a year"
        case Purchases.ProductID.monthly:
            return "Subscribe · \(product.displayPrice) a month"
        default:
            return "Get Lifetime · \(product.displayPrice)"
        }
    }

    private var buttonCaption: String? {
        guard let product = selectedProduct else { return nil }
        switch product.id {
        case Purchases.ProductID.yearly:
            return showsTrial
                ? "\(trialLength) free, then \(product.displayPrice) a year until cancelled. Cancel anytime in Settings."
                : "Renews at \(product.displayPrice) a year until cancelled. Cancel anytime in Settings."
        case Purchases.ProductID.monthly:
            return "Renews at \(product.displayPrice) a month until cancelled. Cancel anytime in Settings."
        default:
            return "One payment. No subscription."
        }
    }

    private func load() async {
        await purchases.loadProducts()
        hasLoaded = true
    }

    /// Runs again whenever the products change: they can land after load()
    /// returns, when another sheet's request was still running.
    private func productsArrived() async {
        // Yearly may not have come back; select a plan that did.
        if selectedProduct == nil, let first = purchases.products.first {
            selection = first.id
        }
        isEligibleForTrial = await purchases.isEligibleForTrial()
    }

    private func buy() {
        guard let product = selectedProduct else { return }
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

    /// iPad presents the sheet from this view, so it opens over the window
    /// the paywall is in. The phone has one window and keeps its lookup.
    private func manageSubscription() {
        guard !DS.isPad else {
            managesSubscription = true
            return
        }
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        guard let scene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first else { return }
        Task {
            do {
                try await AppStore.showManageSubscriptions(in: scene)
            } catch {
                alert = error.localizedDescription
            }
            // A cancellation or plan change made in the sheet shows up here.
            await purchases.refreshEntitlements()
        }
    }
}

/// The manage-subscriptions sheet, presented by SwiftUI on iPad only;
/// `onDismiss` runs as it closes.
private struct PadManageSubscriptions: ViewModifier {
    @Binding var isPresented: Bool
    var onDismiss: () -> Void

    func body(content: Content) -> some View {
        if DS.isPad {
            content
                .manageSubscriptionsSheet(isPresented: $isPresented)
                .onChange(of: isPresented) { _, showing in
                    if !showing { onDismiss() }
                }
        } else {
            content
        }
    }
}

// MARK: - Sheet sizing

/// A page sheet for the offer, a small fitted one once Premium is on.
private struct PremiumSheetSizing: ViewModifier {
    var fitted: Bool
    var width: CGFloat
    @Environment(\.dsLayout) private var layout

    func body(content: Content) -> some View {
        if layout.isRegular {
            content
                .dsSheetSizing(fitted ? .fitted(width: width) : .page)
                .presentationBackground(DS.ink)
        } else if DS.isPad {
            // RootView's paywall sheet doesn't carry the window's layout, so
            // the tier is unknown here. The system ignores a sheet's sizing
            // in a compact window, so asking is safe either way; the fitted
            // width comes from the content's ideal size rather than a fixed
            // frame, which a full-width compact sheet would overflow.
            if fitted {
                content
                    .frame(idealWidth: width, maxWidth: .infinity)
                    .presentationSizing(.fitted)
                    .presentationBackground(DS.ink)
            } else {
                content
                    .presentationSizing(.page)
                    .presentationBackground(DS.ink)
            }
        } else {
            content
        }
    }
}

/// Return and Esc for a hardware keyboard, on iPad only.
private struct PadShortcut: ViewModifier {
    var shortcut: KeyboardShortcut

    func body(content: Content) -> some View {
        if DS.isPad {
            content.keyboardShortcut(shortcut)
        } else {
            content
        }
    }
}

// MARK: - Pieces

/// A real lifter from the library with the mistake marker the trainer uses,
/// so the sheet shows what Premium looks like rather than describing it.
private struct PremiumHero: View {
    @Environment(\.dsLayout) private var layout

    var body: some View {
        // The still is 400px square: it stays at 190pt or less on iPad,
        // where the card only grows taller by its margin.
        let imageInset: CGFloat = layout.value(10, 15)
        ZStack(alignment: .topLeading) {
            // White in both themes: the library stills are shot on white.
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
            Image("lib-back-squat")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, imageInset)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .accessibilityHidden(true)
            MistakeBanner(text: "COMMON MISTAKE · KNEE TRACKING")
                .padding(layout.value(12, 14))
        }
        .frame(height: layout.value(210, 220))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1)
        )
    }
}

/// The Free and Premium columns: a tick where a row is included, a dash
/// where it isn't. Premium's column is the lit one.
private struct FeatureTable: View {
    struct Row: Identifiable {
        let symbol: String
        let title: String
        /// Also in the free version; every row is in Premium.
        let free: Bool
        var id: String { title }
    }

    var rows: [Row]

    @Environment(\.dsLayout) private var layout

    private var column: CGFloat { layout.value(62, 80) }

    var body: some View {
        let headerSize: CGFloat = layout.value(9, 10)
        let rowSize: CGFloat = layout.value(13.5, 15)
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                MetaLine(text: "FREE", size: headerSize)
                    .frame(width: column)
                Text("PREMIUM")
                    .font(.mono(headerSize, .semibold))
                    .trackingEm(0.08, size: headerSize)
                    .foregroundStyle(DS.ink)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(DS.silver))
                    .frame(width: column + 14)
            }
            .padding(.bottom, 8)

            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                if index > 0 { Hairline(opacity: 0.06) }
                HStack(spacing: layout.value(10, 12)) {
                    Image(systemName: row.symbol)
                        .font(.system(size: layout.value(13, 14.5), weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(row.free ? 0.55 : 1))
                        .frame(width: layout.value(22, 26))
                    Text(row.title)
                        .font(.ui(rowSize, row.free ? .regular : .semibold))
                        .foregroundStyle(DS.silver.opacity(row.free ? 0.75 : 1))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 6)
                    mark(row.free)
                        .frame(width: column)
                    mark(true, lit: true)
                        .frame(width: column + 14)
                }
                .padding(.vertical, layout.value(11, 13))
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(row.free ? "\(row.title), free and Premium" : "\(row.title), Premium only")
            }
        }
        .padding(.horizontal, layout.value(14, 18))
        .padding(.vertical, layout.value(12, 14))
        .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
    }

    @ViewBuilder
    private func mark(_ included: Bool, lit: Bool = false) -> some View {
        if included {
            Image(systemName: lit ? "checkmark.circle.fill" : "checkmark")
                .font(.system(size: lit ? layout.value(15, 17) : layout.value(12, 13.5), weight: .semibold))
                .foregroundStyle(DS.silver.opacity(lit ? 1 : 0.5))
        } else {
            Image(systemName: "minus")
                .font(.system(size: layout.value(12, 13.5), weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.22))
        }
    }
}

/// One thing Premium unlocks: its symbol, name and a line on what it means.
struct BenefitRow: View {
    var symbol: String
    var title: String
    var detail: String

    @Environment(\.dsLayout) private var layout

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: layout.value(15, 16), weight: .semibold))
                .foregroundStyle(DS.silver)
                .frame(width: 22)
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: layout.value(3, 4)) {
                Text(title)
                    .font(.ui(layout.value(14.5, 15.5), .semibold))
                    .foregroundStyle(DS.silver)
                Text(detail)
                    .font(.ui(layout.value(12.5, 13.5)))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

/// A Premium benefit as a small tile, for the active state's row on iPad.
private struct BenefitTile: View {
    var symbol: String
    var title: String
    var detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: symbol)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(DS.silver)
                .frame(height: 22)
            Text(title)
                .font(.ui(14, .semibold))
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 12)
            Text(detail)
                .font(.ui(12))
                .cssLineHeight(12, 1.4)
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surfaceAlt))
        .accessibilityElement(children: .combine)
    }
}

/// One plan: the name and what it means on the left, the billed price — the
/// biggest price on the card — on the right.
private struct PlanCard: View {
    var title: String
    var price: String
    var period: String
    var detail: String
    var badge: String?
    var isSelected: Bool
    var action: () -> Void

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let radius: CGFloat = layout.value(16, 18)
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: layout.value(20, 22)))
                    .foregroundStyle(isSelected ? DS.silver : DS.silver.opacity(0.3))
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.ui(layout.value(16, 17), .semibold))
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
                        .font(.ui(layout.value(12.5, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                VStack(alignment: .trailing, spacing: 2) {
                    Text(price)
                        .font(.ui(layout.value(17, 20), .semibold))
                        .foregroundStyle(DS.silver)
                    MetaLine(text: period.uppercased(), size: 8.5)
                }
            }
            .padding(layout.value(16, 18))
            .background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(DS.surfaceAlt))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(isSelected ? DS.silver.opacity(0.8) : DS.silver.opacity(0.08),
                                  lineWidth: isSelected ? 1.5 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: radius)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// A plan as one of two or three tiles in a row, for a wide sheet: the name,
/// any saving, then the billed price large at the foot, so the prices line
/// up across the row.
private struct PlanTile: View {
    var title: String
    var price: String
    var period: String
    var detail: String
    var badge: String?
    var isSelected: Bool
    var action: () -> Void

    private static let radius: CGFloat = 18

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundStyle(isSelected ? DS.silver : DS.silver.opacity(0.3))
                    Text(title)
                        .font(.ui(16, .semibold))
                        .foregroundStyle(DS.silver)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
                if let badge {
                    Text(badge)
                        .font(.mono(9, .semibold))
                        .trackingEm(0.08, size: 9)
                        .foregroundStyle(DS.ink)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(DS.silver))
                        .padding(.top, 10)
                }
                Spacer(minLength: 18)
                Text(price)
                    .font(.ui(26, .semibold))
                    .tracking(-0.5)
                    .foregroundStyle(DS.silver)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                MetaLine(text: period.uppercased(), size: 9)
                    .padding(.top, 3)
                Text(detail)
                    .font(.ui(12.5))
                    .cssLineHeight(12.5, 1.35)
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .lineLimit(2, reservesSpace: true)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 10)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .frame(minHeight: 168)
            .background(
                RoundedRectangle(cornerRadius: Self.radius, style: .continuous)
                    .fill(DS.surfaceAlt)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Self.radius, style: .continuous)
                    .strokeBorder(isSelected ? DS.silver.opacity(0.8) : DS.silver.opacity(0.08),
                                  lineWidth: isSelected ? 1.5 : 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: Self.radius, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.lift, radius: Self.radius)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview("Premium · page sheet") {
    PremiumView(reason: .profile)
        .environment(Purchases())
        .dsPreview(.pad11Portrait750)
}
