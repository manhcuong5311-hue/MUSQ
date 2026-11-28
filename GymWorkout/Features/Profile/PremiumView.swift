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
    /// The member's profile, when known: the goal photo is offered only to
    /// those who can make one (see `GoalPhotoCard.canCreate`).
    var profile: UserProfile? = nil

    @Environment(Purchases.self) private var purchases
    @Environment(\.dismiss) private var dismiss
    /// The presenting window's layout. RootView's paywall sheet is attached
    /// outside its environment calls, so on iPad this can arrive compact
    /// over a regular window; the sheet's own measured size decides then.
    @Environment(\.dsLayout) private var presenterLayout
    /// The plan tapped; until then Yearly, or the first plan that loaded.
    @State private var selection = Purchases.ProductID.yearly
    /// Set once a plan is tapped, so products landing later don't move it.
    @State private var hasChosen = false
    @State private var hasLoaded = false
    @State private var isEligibleForTrial = false
    /// Subscriptions whose free trial this Apple Account can still take
    /// (one per subscription group, so Premium's trial uses up Pro's).
    @State private var trialEligible: Set<String> = []
    /// A plan was bought or restored in this sheet: it says so ("Premium is
    /// on") rather than turning straight into the Pro offer.
    @State private var gotPlanHere = false
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
            // Again after a purchase or restore: the plans on offer and the
            // free trials this Apple Account can take change with the tier.
            .task(id: purchases.products.map(\.id) + ["\(purchases.tier)"]) { await productsArrived() }
            .alert(showsPro ? "MUSQ" : "MUSQ Premium", isPresented: Binding(get: { alert != nil }, set: { if !$0 { alert = nil } })) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alert ?? "")
            }
            .modifier(PadManageSubscriptions(isPresented: $managesSubscription) {
                // A cancellation or plan change made in the sheet shows up here.
                Task { await purchases.refreshEntitlements() }
            })
            .modifier(PremiumSheetSizing(fitted: showsActive, width: Self.activeWidth))
    }

    // MARK: - Tiers

    /// Pro is sold with the AI, live in every build since 1.4, so the sheet
    /// shows both tiers (the comparison layout the owner picked,
    /// 2026-11-22); the Premium-only sheet is left for when the App Store
    /// has no Pro to sell (`proUnavailable`).
    private var showsPro: Bool { AIService.isLive && !proUnavailable }

    /// The App Store answered without Pro's plans (not in App Store Connect
    /// yet, or off sale): the sheet offers Premium alone rather than a tier
    /// nobody can buy. No answer yet, or a failed one, keeps the tiers, with
    /// Try Again where the plans go.
    private var proUnavailable: Bool { !purchases.sellsPro }

    /// A Premium member, shown Pro.
    private var upgrading: Bool { showsPro && purchases.tier == .premium }

    /// "Is on" rather than an offer: Pro; Premium where there's no Pro; or
    /// Premium just bought or restored here.
    private var showsActive: Bool {
        purchases.isPro || (purchases.isPremium && (!showsPro || gotPlanHere))
    }

    /// On iPad the sheet measures itself and lays out for that size; the
    /// offer draws nothing until then, so it's only ever built once.
    @ViewBuilder
    private var sheet: some View {
        if DS.isPad {
            ZStack {
                if sheetSize != nil || showsActive {
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

                    if showsActive {
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
            if !showsActive { footer }
        }
    }

    // MARK: - Layout

    /// The layout inside the sheet: the presenter's on iPhone (always
    /// compact), the measured sheet's on iPad.
    private var layout: DSLayout {
        guard DS.isPad else { return presenterLayout }
        if showsActive {
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
        return showsActive ? layout.gutter : 32
    }

    /// Two plans side by side once the column can give each about 190pt.
    private var usesPlanTiles: Bool {
        let count = [purchases.yearly, purchases.monthly].compactMap { $0 }.count
        return layout.isRegular && sheetWidth >= 600 && count == 2
    }

    // MARK: - Offer

    @ViewBuilder
    private var offer: some View {
        if showsPro { tierOffer } else { premiumOffer }
    }

    /// The Premium-only sheet, as it shipped before Pro.
    private var premiumOffer: some View {
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

            SectionEyebrow(text: String(localized: "WHAT YOU GET"))
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
            return (String(localized: "See the mistakes before you make them"),
                    String(localized: "Premium draws each exercise's common mistakes over the lifter, so you know what bad form looks like before it creeps in."))
        case .preset:
            return (String(localized: "Three presets for every muscle"),
                    String(localized: "Preset 1 is free. Premium adds Preset 2 and 3 for every muscle group, so a different session for each one is a tap away."))
        // The AI features open the sheet for these, and it shows the tiers;
        // this headline is for when Pro isn't on sale.
        case .coach:
            return (String(localized: "Ask MUSQ about your training"),
                    String(localized: "Ask MUSQ is free for \(Purchases.AILimits.freeChatPerDay) questions a day. Premium gives you up to \(Purchases.Tier.premium.chatPerDay) a day, plus the common mistakes, more presets and no ads.",
                           comment: "Premium sheet, opened from Ask MUSQ: free questions a day, then Premium's"))
        case .mealScan:
            return (String(localized: "Log a meal with a photo"),
                    String(localized: "Meal scans come with MUSQ Pro, which isn't on sale right now. Premium adds the coach, the common mistakes, more presets and no ads."))
        case .goalPhoto:
            return (String(localized: "See your goal"),
                    String(localized: "Premium includes \(Purchases.Tier.premium.ai?.goalPhotosPerYear ?? 0) goal photos a year, plus the coach, the common mistakes, more presets and no ads.",
                           comment: "Premium sheet, opened from the goal photo: Premium's goal photos a year"))
        case .onboarding, .profile:
            return (String(localized: "Train with MUSQ Premium"),
                    String(localized: "Everything in MUSQ stays free to train with. Premium adds the common mistakes, more presets and no ads."))
        }
    }

    /// Free and Premium side by side: what everyone has, then what Premium
    /// adds, so it's plain that training itself is never behind the paywall.
    private var features: [FeatureTable.Row] {
        var rows: [FeatureTable.Row] = [
            .init(symbol: "cube", title: "\(SampleData.exercises.count) exercises in 3D", free: true),
            .init(symbol: "lightbulb", title: "Every key tip and setup step", free: true),
            .init(symbol: "list.bullet.clipboard", title: "Workout log, history and recovery", free: true),
            .init(symbol: "square.stack", title: "Basic, Advanced and Preset 1", free: true),
            .init(symbol: "exclamationmark.triangle", title: "Common mistakes over the lifter", free: false),
            .init(symbol: "square.stack.3d.up", title: "Preset 2 and 3 for every group", free: false),
            .init(symbol: "nosign", title: "No ads", free: false),
        ]
        // Builds with the AI show the tier table (`tierRows`), unless Pro
        // isn't on sale: then Premium's own allowance goes here (App Store
        // 3.1.2: say how much a plan includes).
        if AIService.isLive, let ai = Purchases.Tier.premium.ai {
            // Free members ask a few a day too; the row names Premium's.
            rows.insert(.init(symbol: "sparkles", title: "Ask MUSQ: \(ai.chatPerDay) questions a day (\(Purchases.AILimits.freeChatPerDay) free)", free: false), at: 4)
            if GoalPhotoCard.canCreate(for: profile), let photos = ai.goalPhotosPerYear {
                rows.insert(.init(symbol: "figure.strengthtraining.traditional", title: "Goal photos: \(photos) a year", free: false), at: 5)
            }
        }
        return rows
    }

    /// What the member's plan unlocks, for the active state: the AI at their
    /// tier's allowance, in builds where it's live.
    private var benefits: some View {
        let ai = purchases.tier.ai
        return VStack(alignment: .leading, spacing: 14) {
            BenefitRow(symbol: "exclamationmark.triangle", title: "The common mistakes",
                       detail: "Drawn over the lifter for every key tip.")
            BenefitRow(symbol: "square.stack.3d.up", title: "Preset 2 and 3",
                       detail: "For every muscle group.")
            BenefitRow(symbol: "nosign", title: "No ads",
                       detail: "No banner, no full-screen ads.")
            if AIService.isLive, let ai {
                BenefitRow(symbol: "sparkles", title: "Ask MUSQ",
                           detail: "Your training questions, answered with your plan in mind. Up to \(ai.chatPerDay) a day.")
                if ai.mealScansPerDay > 0 {
                    BenefitRow(symbol: "camera.viewfinder", title: "Meal scans",
                               detail: "Calories and macros from a photo, for you to check. Up to \(ai.mealScansPerDay) a day.")
                }
                if GoalPhotoCard.canCreate(for: profile), let photos = ai.goalPhotosPerYear {
                    BenefitRow(symbol: "figure.strengthtraining.traditional", title: "Your goal photo",
                               detail: "A photo of you at the goal you pick, with your own face. \(photos) a year.")
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
    }

    /// The same three on iPad, as tiles in a row: icon over title. Builds
    /// with the AI show the list instead (`benefits`), which has room for
    /// each tier's allowance.
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
                WideButton(title: String(localized: "Try Again"), prominent: false) {
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
                             detail: String(localized: "Billed monthly, cancel anytime"), badge: nil,
                             isSelected: selection == Purchases.ProductID.monthly) {
                        selection = Purchases.ProductID.monthly
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
                             detail: String(localized: "Billed monthly, cancel anytime"), badge: nil,
                             isSelected: selection == Purchases.ProductID.monthly) {
                        selection = Purchases.ProductID.monthly
                    }
                }
            }
        }
    }

    private var footer: some View {
        let nothingChosen = showsPro ? selectedOption == nil : selectedProduct == nil
        let caption = showsPro ? tierButtonCaption : buttonCaption
        return VStack(spacing: 8) {
            WideButton(title: showsPro ? tierButtonTitle : buttonTitle, prominent: true, fontSize: 15, verticalPadding: 15) {
                buy()
            }
            .disabled(nothingChosen || isWorking)
            .opacity(nothingChosen || isWorking ? 0.5 : 1)
            .overlay { if isWorking { ProgressView().tint(DS.ink) } }
            .modifier(PadShortcut(shortcut: .defaultAction))
            .dsCTA(420)

            if let caption {
                Text(caption)
                    .font(.ui(layout.value(11.5, 12.5)))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: layout.isRegular ? 460 : nil)
            }

            Button(reason == .onboarding && !purchases.isPremium ? "Continue Free" : "Not Now") { dismiss() }
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
        let text = showsPro ? tierTermsText : termsText
        return VStack(alignment: .leading, spacing: 10) {
            // Empty until the App Store returns a plan to describe.
            if !text.isEmpty {
                Text(text)
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

    /// Names only the plans the cards offer, at the prices they show. Each
    /// sentence is a whole string for translation, and the plans are listed
    /// the way the language lists two things.
    private var termsText: String {
        var plans: [String] = []
        if let monthly = purchases.monthly {
            plans.append(String(localized: "Monthly (\(monthly.displayPrice) a month)", comment: "Subscription terms: a plan and its price"))
        }
        if let yearly = purchases.yearly {
            plans.append(String(localized: "Yearly (\(yearly.displayPrice) a year)", comment: "Subscription terms: a plan and its price"))
        }
        var parts: [String] = []
        if !plans.isEmpty {
            let names = plans.formatted(.list(type: .and))
            parts.append(plans.count == 1
                         ? String(localized: "\(names) is an auto-renewing subscription.",
                                  comment: "Subscription terms: one plan and its price, e.g. Yearly ($29.99 a year)")
                         : String(localized: "\(names) are auto-renewing subscriptions.",
                                  comment: "Subscription terms: two plans and their prices, e.g. Monthly ($4.99 a month) and Yearly ($29.99 a year)"))
            parts.append(showsTrial
                         ? String(localized: "Payment is charged to your Apple Account when you confirm, or, with the Yearly free trial, when the trial ends unless you cancel at least 24 hours before.")
                         : String(localized: "Payment is charged to your Apple Account when you confirm."))
            parts.append(String(localized: "A subscription renews automatically until cancelled: cancel at least 24 hours before the end of the current period to stop the next renewal, which is charged within 24 hours before that. Manage or cancel it in Settings › Apple Account › Subscriptions."))
        }
        return parts.joined(separator: " ")
    }

    // MARK: - Premium and Pro

    /// Both tiers in one table, then the plans grouped by tier, Pro first.
    /// A Premium member sees their plan marked and Pro's plans only.
    private var tierOffer: some View {
        let titleSize: CGFloat = layout.value(28, 34)
        let messageSize: CGFloat = layout.value(14, 16)
        let copy = tierHeadline
        return VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: upgrading ? "MUSQ PRO" : "MUSQ PREMIUM · PRO")
            Text(copy.title)
                .font(.ui(titleSize, .semibold))
                .tracking(layout.value(-0.7, -0.9))
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: layout.isRegular ? 520 : nil, alignment: .leading)
                .padding(.top, layout.value(6, 8))
            Text(copy.message)
                .font(.ui(messageSize))
                .cssLineHeight(messageSize, 1.5)
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: layout.isRegular ? 520 : nil, alignment: .leading)
                .padding(.top, layout.value(10, 12))

            TierTable(rows: tierRows, yourPlan: upgrading)
                .padding(.top, layout.value(22, 28))

            tierPlans
                .padding(.top, layout.value(24, 28))

            // A Premium subscriber can still manage the plan they have.
            if upgrading && isSubscription {
                Button("Manage Subscription") { manageSubscription() }
                    .font(.ui(layout.value(13.5, 14.5), .semibold))
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .buttonStyle(.plain)
                    .dsCTA(240)
                    .dsHover(.highlight, radius: 12)
                    .padding(.top, 8)
            }
            Button("Restore Purchases") { restore() }
                .font(.ui(layout.value(13.5, 14.5), .semibold))
                .foregroundStyle(DS.silver.opacity(0.75))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .buttonStyle(.plain)
                .disabled(isWorking)
                .dsCTA(240)
                .dsHover(.highlight, radius: 12)
                .padding(.top, upgrading && isSubscription ? 0 : 8)

            terms
                .padding(.top, 6)
        }
    }

    /// The headline for what was tapped, with each tier's allowances from
    /// `Purchases.Tier.ai` (which mirrors the server).
    private var tierHeadline: (title: String, message: String) {
        let freeChats = Purchases.AILimits.freeChatPerDay
        let premiumChats = Purchases.Tier.premium.ai?.chatPerDay ?? 0
        let premiumPhotos = Purchases.Tier.premium.ai?.goalPhotosPerYear ?? 0
        let pro = Purchases.Tier.pro.ai
        let proChats = pro?.chatPerDay ?? 0
        let proScans = pro?.mealScansPerDay ?? 0
        let proPhotos = pro?.goalPhotosPerYear ?? 0
        // Goal photos are named only to members who can make one (the
        // table leaves that row out for the others too).
        let photos = GoalPhotoCard.canCreate(for: profile)
        if upgrading {
            switch reason {
            case .coach:
                return (String(localized: "Keep asking with Pro"),
                        String(localized: "That's today's \(premiumChats) questions on Premium. Pro keeps everything in your plan and gives you \(proChats) questions a day."))
            case .mealScan:
                return (String(localized: "Log meals with Pro"),
                        String(localized: "Meal scans are part of Pro: snap a meal and MUSQ logs its foods, calories and macros for you to check, up to \(proScans) a day."))
            case .goalPhoto:
                return (String(localized: "More goal photos with Pro"),
                        String(localized: "Premium includes \(premiumPhotos) goal photos a year. Pro keeps everything in your plan and makes up to \(proPhotos) a year.",
                               comment: "Pro upgrade, opened from the goal photo: Premium's goal photos a year, then Pro's"))
            case .onboarding, .profile, .mistake, .preset:
                return (String(localized: "Get more with Pro"),
                        photos
                        ? String(localized: "Pro keeps everything in your plan and gives you \(proChats) questions a day, meal scans and \(proPhotos) goal photos a year.",
                                 comment: "Pro upgrade: Pro's questions a day, then its goal photos a year")
                        : String(localized: "Pro keeps everything in your plan and gives you \(proChats) questions a day and meal scans."))
            }
        }
        switch reason {
        case .mistake, .preset:
            // The Premium feature they tapped; the table shows Pro beside it.
            return headline
        case .coach:
            return (String(localized: "Ask MUSQ about your training"),
                    photos
                    ? String(localized: "Free has \(freeChats) questions a day. Premium gives you \(premiumChats) a day, Pro \(proChats), plus meal scans and \(proPhotos) goal photos a year.",
                             comment: "Paywall, opened from Ask MUSQ: free questions a day, Premium's, Pro's, then Pro's goal photos a year")
                    : String(localized: "Free has \(freeChats) questions a day. Premium gives you \(premiumChats) a day, Pro \(proChats), plus meal scans.",
                             comment: "Paywall, opened from Ask MUSQ: free questions a day, Premium's, then Pro's"))
        case .mealScan:
            return (String(localized: "Log a meal with a photo"),
                    String(localized: "Meal scans are part of Pro: snap a meal and MUSQ logs its foods, calories and macros for you to check, up to \(proScans) a day."))
        case .goalPhoto:
            // A member without a plan: the goal photo opens the paywall once
            // their one free photo (`AILimits.freeGoalPhotos`) is used, as the
            // server said (`AIService.freeGoalPhotoUsed`).
            return (String(localized: "See your goal"),
                    AIService.shared.freeGoalPhotoUsed == true
                    ? String(localized: "Your free goal photo is used. Premium makes \(premiumPhotos) a year; Pro up to \(proPhotos) a year.",
                             comment: "Paywall, opened from the goal photo once the free one is used: Premium's goal photos a year, then Pro's")
                    : String(localized: "Your first goal photo is free. Premium makes \(premiumPhotos) a year; Pro up to \(proPhotos) a year.",
                             comment: "Paywall, opened from the goal photo without a plan: Premium's goal photos a year, then Pro's"))
        case .onboarding, .profile:
            return (String(localized: "Train with Premium or Pro"),
                    String(localized: "Everything in MUSQ stays free to train with, with a few Ask MUSQ questions a day. Premium adds the common mistakes, more presets, no ads and more questions. Pro adds meal scans and more of the AI."))
        }
    }

    /// Free, Premium and Pro: the rows Free has, what Premium adds, then the
    /// AI at each tier's allowance (App Store 3.1.2: say how much a plan
    /// includes).
    private var tierRows: [TierTable.Row] {
        let premium = Purchases.Tier.premium.ai
        let pro = Purchases.Tier.pro.ai
        var rows: [TierTable.Row] = [
            .init(symbol: "cube", title: "\(SampleData.exercises.count) exercises in 3D", free: .check, premium: .check, pro: .check),
            .init(symbol: "lightbulb", title: "Every key tip and setup step", free: .check, premium: .check, pro: .check),
            .init(symbol: "list.bullet.clipboard", title: "Workout log, history and recovery", free: .check, premium: .check, pro: .check),
            .init(symbol: "square.stack", title: "Basic, Advanced and Preset 1", free: .check, premium: .check, pro: .check),
            .init(symbol: "exclamationmark.triangle", title: "Common mistakes over the lifter", free: .none, premium: .check, pro: .check),
            .init(symbol: "square.stack.3d.up", title: "Preset 2 and 3 for every group", free: .none, premium: .check, pro: .check),
            .init(symbol: "nosign", title: "No ads", free: .none, premium: .check, pro: .check),
            .init(symbol: "sparkles", title: "Ask MUSQ coach", detail: "Your training questions",
                  free: .perDay(Purchases.AILimits.freeChatPerDay), premium: .perDay(premium?.chatPerDay), pro: .perDay(pro?.chatPerDay)),
            .init(symbol: "camera.viewfinder", title: "Meal scans", detail: "Calories from a photo",
                  free: .none, premium: .perDay(premium?.mealScansPerDay), pro: .perDay(pro?.mealScansPerDay)),
        ]
        // Only for members who can make one (see `GoalPhotoCard.canCreate`).
        // Free has one, ever; the plans renew theirs each year.
        if GoalPhotoCard.canCreate(for: profile) {
            rows.append(.init(symbol: "figure.strengthtraining.traditional", title: "Goal photo", detail: "For adults",
                              free: .oneTime(Purchases.AILimits.freeGoalPhotos),
                              premium: .photos(premium?.goalPhotos), pro: .photos(pro?.goalPhotos)))
        }
        return rows
    }

    @ViewBuilder
    private var tierPlans: some View {
        let options = planOptions
        if options.isEmpty {
            storeState
        } else {
            VStack(alignment: .leading, spacing: 10) {
                let pro = options.filter { $0.tier == .pro }
                let premium = options.filter { $0.tier != .pro }
                // The tier names stay as they are in every language; the
                // notes are localized.
                if !pro.isEmpty {
                    PlanGroupHeader(title: "PRO", note: upgrading
                                    ? String(localized: "UPGRADE FROM PREMIUM", comment: "Paywall: small upper-case note at the right of the PRO plans' header, for a Premium member; keep short")
                                    : String(localized: "FULL AI ALLOWANCE", comment: "Paywall: small upper-case note at the right of the PRO plans' header (Pro has the most AI uses); keep short"))
                    planRow(pro)
                }
                if !premium.isEmpty {
                    PlanGroupHeader(title: "PREMIUM", note: String(localized: "STARTER AI ALLOWANCE", comment: "Paywall: small upper-case note at the right of the PREMIUM plans' header (Premium has fewer AI uses than Pro); keep short"))
                        .padding(.top, pro.isEmpty ? 0 : 10)
                    planRow(premium)
                }
            }
        }
    }

    /// One tier's plans: tiles side by side on a wide sheet, cards otherwise.
    @ViewBuilder
    private func planRow(_ options: [PlanOption]) -> some View {
        if layout.isRegular && sheetWidth >= 600 {
            HStack(alignment: .top, spacing: 12) {
                ForEach(options) { option in
                    PlanTile(title: option.title, price: option.price, period: option.period,
                             detail: planDetail(option), badge: savings(for: option),
                             isSelected: selection == option.id) { choose(option) }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        } else {
            ForEach(options) { option in
                PlanCard(title: option.title, price: option.price, period: option.period,
                         detail: planDetail(option), badge: savings(for: option),
                         isSelected: selection == option.id) { choose(option) }
            }
        }
    }

    private func choose(_ option: PlanOption) {
        selection = option.id
        hasChosen = true
    }

    /// The line under a plan's name: the trial, or what a yearly price comes
    /// to a month.
    private func planDetail(_ option: PlanOption) -> String {
        switch option.kind {
        case .yearly:
            if let trial = option.trial { return String(localized: "\(trial) free, then \(option.price)/year") }
            return option.perMonth.map { String(localized: "\($0) a month, billed yearly") } ?? ""
        case .monthly:
            if let trial = option.trial { return String(localized: "\(trial) free, then \(option.price)/month") }
            return String(localized: "Billed monthly, cancel anytime")
        }
    }

    /// "SAVE 78%": a tier's yearly plan against twelve of its monthly ones,
    /// when the App Store returned both (so both prices are real and in the
    /// same currency).
    private func savings(for option: PlanOption) -> String? {
        guard option.kind == .yearly,
              let monthly = planOptions.first(where: { $0.tier == option.tier && $0.kind == .monthly }),
              monthly.priceValue > 0 else { return nil }
        // Through Double: NSDecimalNumber's intValue gives 0 for a decimal with
        // this many digits (77.768…), which hid the badge.
        let percent = Int(NSDecimalNumber(decimal: (1 - option.priceValue / (monthly.priceValue * 12)) * 100).doubleValue)
        return percent >= 10 ? String(localized: "SAVE \(percent.formatted(.percent))") : nil
    }

    /// Prices didn't load, or are still loading: the same as the Premium sheet.
    @ViewBuilder
    private var storeState: some View {
        if storeUnavailable {
            VStack(alignment: .leading, spacing: 12) {
                Text("Prices couldn't be loaded from the App Store. Check your connection and try again.")
                    .font(.ui(layout.value(13, 14)))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                WideButton(title: String(localized: "Try Again"), prominent: false) {
                    Task { await load() }
                }
                .dsCTA(300, alignment: .leading)
            }
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        } else {
            ProgressView()
                .tint(DS.silver.opacity(0.4))
                .frame(maxWidth: .infinity, minHeight: 150)
                .accessibilityLabel("Loading plans")
        }
    }

    /// The plans on offer, as the App Store priced them: Pro's then
    /// Premium's, or Pro's alone for a Premium member.
    private var planOptions: [PlanOption] {
        typealias ID = Purchases.ProductID
        let ids = upgrading ? [ID.proYearly, ID.proMonthly] : [ID.proYearly, ID.proMonthly, ID.yearly]
        return ids.compactMap { id -> PlanOption? in
            if let product = purchases.products.first(where: { $0.id == id }) {
                return PlanOption(product, trial: trialEligible.contains(id))
            }
            #if DEBUG
            // A sample stands in for each plan the store didn't return.
            if PlanOption.usesSamples { return PlanOption.samples(trials: !upgrading).first { $0.id == id } }
            #endif
            return nil
        }
    }

    private var selectedOption: PlanOption? {
        planOptions.first { $0.id == selection }
    }

    private var tierButtonTitle: String {
        guard let option = selectedOption else {
            return upgrading ? String(localized: "Upgrade to Pro") : String(localized: "Get Pro")
        }
        if option.trial != nil { return String(localized: "Start Free Trial") }
        switch (upgrading, option.tier, option.kind) {
        case (true, _, .yearly): return String(localized: "Upgrade to Pro · \(option.price) a year")
        case (true, _, _): return String(localized: "Upgrade to Pro · \(option.price) a month")
        case (false, .pro, .yearly): return String(localized: "Get Pro · \(option.price) a year")
        case (false, .pro, _): return String(localized: "Get Pro · \(option.price) a month")
        case (false, _, .yearly): return String(localized: "Get Premium · \(option.price) a year")
        case (false, _, .monthly): return String(localized: "Get Premium · \(option.price) a month")
        }
    }

    private var tierButtonCaption: String? {
        guard let option = selectedOption else { return nil }
        let renews: String
        switch option.kind {
        case .yearly:
            renews = option.trial.map { String(localized: "\($0) free, then \(option.price) a year until cancelled. Cancel anytime in Settings.") }
                ?? String(localized: "Renews at \(option.price) a year until cancelled. Cancel anytime in Settings.")
        case .monthly:
            renews = option.trial.map { String(localized: "\($0) free, then \(option.price) a month until cancelled. Cancel anytime in Settings.") }
                ?? String(localized: "Renews at \(option.price) a month until cancelled. Cancel anytime in Settings.")
        }
        guard upgrading else { return renews }
        // An upgrade in the same subscription group replaces the plan at
        // once and Apple refunds the rest; lifetime is a separate purchase.
        let now = isSubscription
            ? String(localized: "Pro starts now, and Apple refunds the unused part of your Premium plan.")
            : String(localized: "Pro starts now. Your lifetime Premium stays yours.")
        return now + " " + renews
    }

    /// Names only the plans on offer, at the prices they show, as the
    /// Premium sheet's terms do.
    private var tierTermsText: String {
        let options = planOptions
        let plans: [String] = options.compactMap { option in
            switch (option.tier, option.kind) {
            case (.pro, .monthly):
                return String(localized: "Pro Monthly (\(option.price) a month)", comment: "Subscription terms: a plan and its price")
            case (.pro, .yearly):
                return String(localized: "Pro Yearly (\(option.price) a year)", comment: "Subscription terms: a plan and its price")
            case (_, .yearly):
                return String(localized: "Premium Yearly (\(option.price) a year)", comment: "Subscription terms: a plan and its price")
            case (_, .monthly):
                return String(localized: "Premium Monthly (\(option.price) a month)", comment: "Subscription terms: a plan and its price")
            }
        }
        var parts: [String] = []
        if !plans.isEmpty {
            let names = plans.formatted(.list(type: .and))
            parts.append(plans.count == 1
                         ? String(localized: "\(names) is an auto-renewing subscription.",
                                  comment: "Subscription terms: one plan and its price, e.g. Yearly ($29.99 a year)")
                         : String(localized: "\(names) are auto-renewing subscriptions.",
                                  comment: "Subscription terms: two plans and their prices, e.g. Monthly ($4.99 a month) and Yearly ($29.99 a year)"))
            parts.append(options.contains { $0.trial != nil }
                         ? String(localized: "Payment is charged to your Apple Account when you confirm, or, with a free trial, when the trial ends unless you cancel at least 24 hours before.")
                         : String(localized: "Payment is charged to your Apple Account when you confirm."))
            if upgrading && isSubscription {
                parts.append(String(localized: "Upgrading replaces your Premium subscription right away, and Apple refunds its unused part."))
            }
            parts.append(String(localized: "A subscription renews automatically until cancelled: cancel at least 24 hours before the end of the current period to stop the next renewal, which is charged within 24 hours before that. Manage or cancel it in Settings › Apple Account › Subscriptions."))
        }
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
            SectionEyebrow(text: activePlanName.map { "\(activeTierName) · \($0.uppercased())" } ?? activeTierName)
                .padding(.top, 14)
            (purchases.isPro ? Text("Pro is on") : Text("Premium is on"))
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
                Group {
                    if AIService.isLive { benefits } else { benefitTiles }
                }
                .padding(.top, 24)
                // Side by side under the tiles; Done alone when there's no
                // subscription to manage.
                HStack(spacing: 10) {
                    if isSubscription {
                        WideButton(title: String(localized: "Manage Subscription"), prominent: false) { manageSubscription() }
                    }
                    WideButton(title: String(localized: "Done"), prominent: true) { dismiss() }
                        .modifier(PadShortcut(shortcut: .defaultAction))
                }
                .padding(.top, 26)
            } else {
                benefits
                    .padding(.top, 22)

                if isSubscription {
                    WideButton(title: String(localized: "Manage Subscription"), prominent: false) { manageSubscription() }
                        .padding(.top, 24)
                }
                WideButton(title: String(localized: "Done"), prominent: true) { dismiss() }
                    .padding(.top, isSubscription ? 10 : 24)
            }
        }
        .padding(.top, 12)
    }

    private var activeTierName: String { purchases.isPro ? "MUSQ PRO" : "MUSQ PREMIUM" }

    private var activePlanName: String? {
        switch purchases.activePlan {
        case Purchases.ProductID.yearly, Purchases.ProductID.proYearly: return String(localized: "Yearly")
        case Purchases.ProductID.monthly, Purchases.ProductID.proMonthly: return String(localized: "Monthly")
        case Purchases.ProductID.lifetime: return String(localized: "Lifetime")
        default: return nil
        }
    }

    private var activeMessage: String {
        switch purchases.activePlan {
        case Purchases.ProductID.yearly, Purchases.ProductID.proYearly:
            return String(localized: "Thank you for supporting MUSQ. Everything below stays unlocked while your yearly plan renews.")
        case Purchases.ProductID.monthly, Purchases.ProductID.proMonthly:
            return String(localized: "Thank you for supporting MUSQ. Everything below stays unlocked while your monthly plan renews.")
        case Purchases.ProductID.lifetime:
            return String(localized: "Thank you for supporting MUSQ. Everything below is yours for good.")
        default:
            return String(localized: "Thank you for supporting MUSQ.")
        }
    }

    /// A plan that renews (and so can be managed or replaced), not lifetime.
    private var isSubscription: Bool {
        [Purchases.ProductID.yearly, Purchases.ProductID.monthly,
         Purchases.ProductID.proYearly, Purchases.ProductID.proMonthly].contains(purchases.activePlan ?? "")
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
        if showsTrial { return String(localized: "\(trialLength) free, then \(yearly.displayPrice)/year") }
        return String(localized: "\((yearly.price / 12).formatted(yearly.priceFormatStyle)) a month, billed yearly")
    }

    /// "SAVE 66%": a year of Yearly against twelve months of Monthly. Only
    /// when the App Store returned both, so the two prices are real and in
    /// the same currency; with no Monthly plan there's nothing to save against.
    private var savingsBadge: String? {
        guard let yearly = purchases.yearly, let monthly = purchases.monthly,
              monthly.price > 0 else { return nil }
        let percent = Int(NSDecimalNumber(decimal: (1 - yearly.price / (monthly.price * 12)) * 100).doubleValue)
        // An Int's percent style shows 66 as "66%", in the language's own form.
        return percent >= 10 ? String(localized: "SAVE \(percent.formatted(.percent))") : nil
    }

    // MARK: - Actions

    private var selectedProduct: Product? {
        purchases.products.first { $0.id == selection }
    }

    /// No price until a returned plan is selected; the button is disabled
    /// until then anyway.
    private var buttonTitle: String {
        guard let product = selectedProduct else { return String(localized: "Get Premium") }
        switch product.id {
        case Purchases.ProductID.yearly:
            return showsTrial
                ? String(localized: "Start Free Trial")
                : String(localized: "Subscribe · \(product.displayPrice) a year")
        default:
            return String(localized: "Subscribe · \(product.displayPrice) a month")
        }
    }

    private var buttonCaption: String? {
        guard let product = selectedProduct else { return nil }
        switch product.id {
        case Purchases.ProductID.yearly:
            return showsTrial
                ? String(localized: "\(trialLength) free, then \(product.displayPrice) a year until cancelled. Cancel anytime in Settings.")
                : String(localized: "Renews at \(product.displayPrice) a year until cancelled. Cancel anytime in Settings.")
        default:
            return String(localized: "Renews at \(product.displayPrice) a month until cancelled. Cancel anytime in Settings.")
        }
    }

    private func load() async {
        await purchases.loadProducts()
        hasLoaded = true
    }

    /// Runs again whenever the products change: they can land after load()
    /// returns, when another sheet's request was still running.
    private func productsArrived() async {
        if showsPro {
            // No trial is claimed until this account's eligibility is known
            // again (a purchase here can have used the group's one trial).
            trialEligible = []
            // Pro yearly first, unless a plan was tapped that's still offered.
            let options = planOptions
            if !hasChosen || !options.contains(where: { $0.id == selection }), let first = options.first {
                selection = first.id
            }
            var eligible: Set<String> = []
            for product in purchases.products where product.subscription?.introductoryOffer != nil {
                if await purchases.isEligibleForTrial(product) { eligible.insert(product.id) }
            }
            trialEligible = eligible
            return
        }
        // Yearly may not have come back; select a Premium plan that did (the
        // store also returns Pro's, which this sheet doesn't sell).
        if selectedProduct == nil || Purchases.ProductID.tier(of: selection) != .premium,
           let first = purchases.products.first(where: { Purchases.ProductID.tier(of: $0.id) == .premium }) {
            selection = first.id
        }
        isEligibleForTrial = await purchases.isEligibleForTrial()
    }

    private func buy() {
        #if DEBUG
        if showsPro, let option = selectedOption, option.product == nil {
            alert = "Sample plans (-paywall.samplePlans): nothing to buy in this build."
            return
        }
        #endif
        guard let product = showsPro ? selectedOption?.product : selectedProduct else { return }
        isWorking = true
        Task {
            defer { isWorking = false }
            do {
                switch try await purchases.purchase(product) {
                case .purchased:
                    gotPlanHere = true
                case .pending:
                    alert = Purchases.ProductID.tier(of: product.id) == .pro
                        ? String(localized: "Your purchase is waiting for approval. Pro turns on as soon as it goes through.")
                        : String(localized: "Your purchase is waiting for approval. Premium turns on as soon as it goes through.")
                case .cancelled:
                    break
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
                let before = purchases.tier
                try await purchases.restore()
                if !purchases.isPremium {
                    alert = String(localized: "No MUSQ Premium or Pro purchase was found for this Apple Account.")
                } else if purchases.tier > before {
                    gotPlanHere = true
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
            // The Back Squat's own cue title, so the banner reads as the
            // trainer's does in every language.
            MistakeBanner(text: String(localized: "COMMON MISTAKE · \(L10n.content("Knee Tracking").uppercased())",
                                       comment: "Banner over the lifter: a common mistake's cue title, in upper case"))
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

        /// The title is literal copy, localized here.
        init(symbol: String, title: String.LocalizationValue, free: Bool) {
            self.symbol = symbol
            self.title = String(localized: title)
            self.free = free
        }
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

/// A plan as the tier sheet shows it: a returned Product at its App Store
/// price, or, in Debug builds launched with `-paywall.samplePlans YES`, a
/// sample (the simulator can't load the StoreKit configuration file).
private struct PlanOption: Identifiable {
    /// Only plans on sale: Lifetime went off sale on 2026-11-23 (its buyers
    /// keep Premium, see `Purchases.ProductID.lifetime`).
    enum Kind { case monthly, yearly }

    let id: String
    let tier: Purchases.Tier
    let kind: Kind
    /// The price as the App Store wrote it.
    let price: String
    let priceValue: Decimal
    /// What a yearly price comes to a month, in the store's format.
    let perMonth: String?
    /// The free trial's length, when this Apple Account can take it.
    let trial: String?
    /// Nil for a sample.
    let product: Product?

    var title: String.LocalizationValue {
        switch kind {
        case .monthly: "Monthly"
        case .yearly: "Yearly"
        }
    }

    var period: String.LocalizationValue {
        switch kind {
        case .monthly: "per month"
        case .yearly: "per year"
        }
    }

    init(_ product: Product, trial eligible: Bool) {
        typealias ID = Purchases.ProductID
        id = product.id
        tier = ID.tier(of: product.id)
        kind = [ID.proYearly, ID.yearly].contains(product.id) ? .yearly : .monthly
        price = product.displayPrice
        priceValue = product.price
        perMonth = kind == .yearly ? (product.price / 12).formatted(product.priceFormatStyle) : nil
        trial = eligible ? Purchases.freeTrialLength(of: product) : nil
        self.product = product
    }

    #if DEBUG
    static var usesSamples: Bool { Purchases.usesSamplePlans }

    /// The StoreKit configuration's plans and prices. A Premium member has
    /// had the group's trial, so upgrades show none. Trial lengths use the
    /// same key as a real one ("%lld days"), so screenshots are translated.
    static func samples(trials: Bool) -> [PlanOption] {
        typealias ID = Purchases.ProductID
        return [
            PlanOption(sample: ID.proYearly, tier: .pro, kind: .yearly, price: "$39.99", value: 39.99, perMonth: "$3.33",
                       trial: trials ? String(localized: "\(3) days") : nil),
            PlanOption(sample: ID.proMonthly, tier: .pro, kind: .monthly, price: "$14.99", value: 14.99, perMonth: nil, trial: nil),
            PlanOption(sample: ID.yearly, tier: .premium, kind: .yearly, price: "$19.99", value: 19.99, perMonth: "$1.67",
                       trial: trials ? String(localized: "\(7) days") : nil),
        ]
    }

    private init(sample id: String, tier: Purchases.Tier, kind: Kind, price: String, value: Decimal,
                 perMonth: String?, trial: String?) {
        self.id = id
        self.tier = tier
        self.kind = kind
        self.price = price
        self.priceValue = value
        self.perMonth = perMonth
        self.trial = trial
        self.product = nil
    }
    #endif
}

/// A tier's eyebrow over its plans, with a note on the right.
private struct PlanGroupHeader: View {
    var title: String
    var note: String

    @Environment(\.dsLayout) private var layout

    var body: some View {
        HStack(spacing: 8) {
            MetaLine(text: title, size: layout.value(9.5, 10.5))
            Spacer(minLength: 8)
            MetaLine(text: note, size: layout.value(8.5, 9.5))
        }
        .padding(.horizontal, 2)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

/// Free, Premium and Pro side by side: ticks and dashes for the features,
/// the allowance for the AI. Pro's column is outlined; a Premium member's
/// own column is shaded and marked YOUR PLAN.
private struct TierTable: View {
    enum Cell: Equatable {
        case check
        case none
        /// The number, the word under it, and the two as VoiceOver says
        /// them: one phrase, so a language can order it its own way.
        case amount(Int, unit: String, spoken: String)

        static func perDay(_ count: Int?) -> Cell {
            guard let count, count > 0 else { return .none }
            return .amount(count, unit: String(localized: "A DAY", comment: "Paywall table: an allowance per day, under its number"),
                           spoken: String(localized: "\(count) a day", comment: "VoiceOver, paywall table: an AI allowance per day, e.g. 10 a day"))
        }

        static func photos(_ photos: Purchases.AILimits.GoalPhotos?) -> Cell {
            switch photos {
            case .perYear(let count)? where count > 0:
                return .amount(count, unit: String(localized: "A YEAR", comment: "Paywall table: an allowance per year, under its number"),
                               spoken: String(localized: "\(count) a year", comment: "VoiceOver, paywall table: goal photos per year, e.g. 2 a year"))
            default:
                return .none
            }
        }

        /// An allowance that never renews: Free's goal photo.
        static func oneTime(_ count: Int) -> Cell {
            guard count > 0 else { return .none }
            return .amount(count, unit: String(localized: "TO TRY", comment: "Paywall table: a one-time allowance, under its number"),
                           spoken: String(localized: "\(count) to try", comment: "VoiceOver, paywall table: a one-time allowance to try the feature, e.g. 1 to try"))
        }
    }

    struct Row: Identifiable {
        let symbol: String
        let title: String
        let detail: String?
        let free: Cell
        let premium: Cell
        let pro: Cell
        var id: String { title }

        /// Everyone's rows read quieter. A row Free has only a taste of
        /// (one goal photo) stays lit with the plans' rows.
        var isFree: Bool { free == .check }

        /// The title and detail are literal copy, localized here.
        init(symbol: String, title: String.LocalizationValue, detail: String.LocalizationValue? = nil,
             free: Cell, premium: Cell, pro: Cell) {
            self.symbol = symbol
            self.title = String(localized: title)
            self.detail = detail.map { String(localized: $0) }
            self.free = free
            self.premium = premium
            self.pro = pro
        }
    }

    var rows: [Row]
    /// Marks Premium as the member's plan.
    var yourPlan: Bool

    @Environment(\.dsLayout) private var layout

    // Free's column holds only ticks and dashes; Premium's header is the
    // widest word.
    private var freeColumn: CGFloat { layout.value(38, 64) }
    private var premiumColumn: CGFloat { layout.value(56, 76) }
    private var proColumn: CGFloat { layout.value(56, 82) }
    private var inset: CGFloat { layout.value(14, 18) }

    var body: some View {
        let headerSize: CGFloat = layout.value(9, 10)
        let rowSize: CGFloat = layout.value(13.5, 15)
        VStack(spacing: 0) {
            // On the labels' baselines: PRO's capsule pads its text, and
            // YOUR PLAN sits over PREMIUM.
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Spacer(minLength: 0)
                MetaLine(text: "FREE", size: headerSize)
                    .frame(width: freeColumn)
                VStack(spacing: 3) {
                    if yourPlan {
                        // The subscription the member has, so a key of its
                        // own: Onboarding's "YOUR PLAN" is the training plan.
                        MetaLine(text: String(localized: "paywall.yourPlan", defaultValue: "YOUR PLAN",
                                              comment: "Paywall table: over the PREMIUM column when Premium is the member's current subscription; upper case, narrow column"),
                                 size: headerSize - 1.5)
                    }
                    MetaLine(text: "PREMIUM", size: headerSize)
                }
                .frame(width: premiumColumn)
                Text("PRO")
                    .font(.mono(headerSize, .semibold))
                    .trackingEm(0.08, size: headerSize)
                    .foregroundStyle(DS.ink)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(DS.silver))
                    .frame(width: proColumn)
            }
            .padding(.top, 4)
            .padding(.bottom, 8)
            .accessibilityHidden(true)

            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                if index > 0 { Hairline(opacity: 0.06) }
                HStack(spacing: layout.value(8, 12)) {
                    Image(systemName: row.symbol)
                        .font(.system(size: layout.value(13, 14.5), weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(row.isFree ? 0.55 : 1))
                        .frame(width: layout.value(20, 26))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(row.title)
                            .font(.ui(rowSize, row.isFree ? .regular : .semibold))
                            .foregroundStyle(DS.silver.opacity(row.isFree ? 0.75 : 1))
                            .fixedSize(horizontal: false, vertical: true)
                        if let detail = row.detail {
                            Text(detail)
                                .font(.ui(layout.value(11, 12)))
                                .foregroundStyle(DS.silver.opacity(0.5))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    Spacer(minLength: 4)
                    // Flush, so the columns line up with the header and the
                    // outline behind Pro's.
                    HStack(spacing: 0) {
                        cell(row.free, lit: false)
                            .frame(width: freeColumn)
                        cell(row.premium, lit: false)
                            .frame(width: premiumColumn)
                        cell(row.pro, lit: true)
                            .frame(width: proColumn)
                    }
                }
                .padding(.vertical, layout.value(11, 13))
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(label(for: row))
            }
        }
        .padding(.horizontal, inset)
        .padding(.vertical, layout.value(12, 14))
        // Pro's column, outlined from its header to the last row. Each
        // background sits behind the ones before it.
        .background(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(DS.silver.opacity(0.55), lineWidth: 1.5)
                .frame(width: proColumn + 6)
                .padding(.trailing, inset - 3)
                .padding(.vertical, 6)
        }
        .background(alignment: .trailing) {
            if yourPlan {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(DS.silver.opacity(0.06))
                    .frame(width: premiumColumn + 4)
                    .padding(.trailing, inset + proColumn - 2)
                    .padding(.vertical, 6)
            }
        }
        .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
    }

    @ViewBuilder
    private func cell(_ cell: Cell, lit: Bool) -> some View {
        switch cell {
        case .check:
            Image(systemName: lit ? "checkmark.circle.fill" : "checkmark")
                .font(.system(size: lit ? layout.value(15, 17) : layout.value(12, 13.5), weight: .semibold))
                .foregroundStyle(DS.silver.opacity(lit ? 1 : 0.5))
        case .none:
            Image(systemName: "minus")
                .font(.system(size: layout.value(12, 13.5), weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.22))
        case .amount(let count, let unit, _):
            VStack(spacing: 1) {
                Text(count.formatted())
                    .font(.ui(lit ? layout.value(17, 19) : layout.value(15, 17), .semibold))
                    .foregroundStyle(DS.silver.opacity(lit ? 1 : 0.75))
                Text(unit)
                    .font(.mono(layout.value(7, 8), .semibold))
                    .trackingEm(0.06, size: layout.value(7, 8))
                    .foregroundStyle(DS.silver.opacity(0.45))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }

    private func label(for row: Row) -> String {
        func say(_ cell: Cell) -> String {
            switch cell {
            case .check: return String(localized: "included", comment: "VoiceOver, paywall table: a feature a plan has")
            case .none: return String(localized: "not included", comment: "VoiceOver, paywall table: a feature a plan lacks")
            case .amount(_, _, let spoken): return spoken
            }
        }
        let title = row.detail.map { "\(row.title), \($0)" } ?? row.title
        return String(localized: "\(title). Free: \(say(row.free)). Premium: \(say(row.premium)). Pro: \(say(row.pro)).",
                      comment: "VoiceOver, paywall table row")
    }
}

/// One thing Premium unlocks: its symbol, name and a line on what it means.
struct BenefitRow: View {
    var symbol: String
    var title: String
    var detail: String

    @Environment(\.dsLayout) private var layout

    /// The title and detail are literal copy, localized here.
    init(symbol: String, title: String.LocalizationValue, detail: String.LocalizationValue) {
        self.symbol = symbol
        self.title = String(localized: title)
        self.detail = String(localized: detail)
    }

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

    /// The title and detail are literal copy, localized here.
    init(symbol: String, title: String.LocalizationValue, detail: String.LocalizationValue) {
        self.symbol = symbol
        self.title = String(localized: title)
        self.detail = String(localized: detail)
    }

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

    /// The plan's name and period are literal and localized here; the
    /// detail and badge come localized, the price as the App Store wrote it.
    init(title: String.LocalizationValue, price: String, period: String.LocalizationValue, detail: String,
         badge: String?, isSelected: Bool, action: @escaping () -> Void) {
        self.title = String(localized: title)
        self.price = price
        self.period = String(localized: period)
        self.detail = detail
        self.badge = badge
        self.isSelected = isSelected
        self.action = action
    }

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

    /// Localized as PlanCard's are.
    init(title: String.LocalizationValue, price: String, period: String.LocalizationValue, detail: String,
         badge: String?, isSelected: Bool, action: @escaping () -> Void) {
        self.title = String(localized: title)
        self.price = price
        self.period = String(localized: period)
        self.detail = detail
        self.badge = badge
        self.isSelected = isSelected
        self.action = action
    }

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
