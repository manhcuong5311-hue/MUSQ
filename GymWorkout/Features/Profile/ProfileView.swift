//
//  ProfileView.swift
//  GymWorkout
//
//  Tab 4. The Premium offer up top for anyone without it, the name the app
//  greets you by, the onboarding answers and the plan they add up to, the
//  settings that shape every other tab (units, experience for recovery
//  estimates, rest timer, card colours), Premium and ad privacy, and Help &
//  FAQ. The totals, personal records and history live on the Muscles tab.
//
//  On iPad the same sections sit under a header that carries the name, goal
//  and plan, in two columns once the content column reaches 700pt.
//

import SwiftUI

struct ProfileView: View {
    @Binding var tab: AppTab

    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases
    @Environment(Ads.self) private var ads
    @Environment(Paywall.self) private var paywall
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dsLayout) private var layout
    @State private var editsProfile = false
    /// The name as it's typed; saved when the field is left.
    @State private var nameDraft = ""
    @FocusState private var editsName: Bool
    /// The About You card's width on iPad, which decides whether its facts
    /// sit four across or two by two.
    @State private var aboutWidth: CGFloat = 0
    private let cardColors = CardColorPrefs()

    var body: some View {
        NavigationStack {
            ZStack {
                DS.ink.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    if layout.isRegular {
                        regularPage
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Profile")
                                .font(.ui(28, .semibold))
                                .tracking(-0.7)
                                .foregroundStyle(DS.silver)

                            if !purchases.isPremium {
                                PremiumHeroCard()
                                    .padding(.top, 18)
                                    .transition(.opacity)
                            }
                            aboutYou
                                .padding(.top, purchases.isPremium ? 18 : 28)
                            settings
                                .padding(.top, 28)
                            cardColorSettings
                                .padding(.top, 28)
                            premiumAndPrivacy
                                .padding(.top, 28)
                        }
                        .padding(.horizontal, DS.Metric.gutter)
                        .padding(.top, 22)
                        .padding(.bottom, 24)
                        .animation(.easeOut(duration: 0.3), value: purchases.isPremium)
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            .statusBarScrim()
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(DS.silver)
        // A full-screen cover on iPhone; a page sheet on iPad that a stray
        // swipe can't close with the answers half changed.
        .dsCover(isPresented: $editsProfile) {
            OnboardingView(isEditing: true, onClose: { editsProfile = false })
                .environment(store)
                .environment(purchases)
                .dsLayoutRoot()
        }
    }

    // MARK: - iPad

    /// Two columns from a 700pt content column, one readable column below
    /// it. `DSColumns` only moves the sections between the two, so the name
    /// field keeps its focus and the hero its loaded price through a rotation
    /// or a Split View drag.
    private var regularPage: some View {
        let columns = layout.containerWidth >= 700 ? 2 : 1
        return VStack(alignment: .leading, spacing: 0) {
            header

            if !purchases.isPremium {
                PremiumHeroCard(layout: layout.isWide ? .wide : .stacked)
                    .padding(.top, 24)
                    .transition(.opacity)
            }

            DSColumns(columns: columns, spacing: 24, rowSpacing: 28) {
                // Source order is the one-column order; in two columns the
                // left takes you and your settings, the right the Train
                // colours and Premium, which keeps the two about level.
                aboutYouRegular
                    .dsColumn(0)
                settings
                    .dsColumn(0)
                cardColorSettings
                    .dsColumn(1)
                premiumSection
                    .dsColumn(1)
                supportSection
                    .dsColumn(0)
                legalLinks
                    // The links belong to the card above them, not a section
                    // of their own: pulled up from the column's 28 to 12.
                    .padding(.top, -16)
                    .dsColumn(1)
            }
            .padding(.top, purchases.isPremium ? 28 : layout.sectionSpacing)
        }
        .dsReadable(columns == 2 ? 1120 : 620)
        .dsGutter()
        .padding(.top, 28)
        .padding(.bottom, 32)
        .animation(.easeOut(duration: 0.3), value: purchases.isPremium)
    }

    /// The tab title with who this is underneath, and the way into the
    /// answers beside it, where the About You eyebrow keeps it on iPhone.
    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Profile")
                    .font(.ui(layout.text(.largeTitle), .semibold))
                    .tracking(layout.largeTitleTracking)
                    .foregroundStyle(DS.silver)
                MetaLine(text: headerMeta)
                    .lineLimit(1)
            }
            Spacer(minLength: 16)
            if store.profile != nil {
                Button { editsProfile = true } label: {
                    HStack(spacing: 7) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Edit Profile")
                            .font(.ui(14, .semibold))
                    }
                    .foregroundStyle(DS.silver)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(DS.silver.opacity(0.07)))
                    .overlay(Capsule().strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
                    .contentShape(Capsule())
                }
                .buttonStyle(.plain)
                .dsHover()
            }
        }
    }

    /// "SAM · BUILD MUSCLE · FREE"
    private var headerMeta: String {
        var parts: [String] = []
        if let name = store.profile?.name, !name.isEmpty { parts.append(name.uppercased()) }
        if let goal = store.profile?.goal { parts.append(goal.title.uppercased()) }
        parts.append(purchases.isPremium ? "PREMIUM" : "FREE")
        return parts.joined(separator: " · ")
    }

    @ViewBuilder
    private var aboutYouRegular: some View {
        if let profile = store.profile {
            let factColumns = aboutWidth >= 500 ? 4 : 2
            VStack(alignment: .leading, spacing: 10) {
                SectionEyebrow(text: "ABOUT YOU")
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 14) {
                        avatar
                        nameField
                    }
                    Hairline(opacity: 0.06)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12, alignment: .topLeading),
                                             count: factColumns),
                              alignment: .leading, spacing: 14) {
                        fact("GOAL", profile.goal.title)
                        fact("SEX", profile.sex == .unspecified ? "–" : profile.sex.title)
                        fact("HEIGHT", store.unit.height(profile.heightCm))
                        fact("WEIGHT", store.unit.total(profile.weightKg))
                    }
                    Hairline(opacity: 0.06)
                    Text(planSummary(profile))
                        .font(.ui(14))
                        .cssLineHeight(14, 1.5)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(18)
                .background(card)
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { aboutWidth = $0 }
            }
        }
    }

    /// The name's first letter in the avatar well, live as it's typed.
    private var avatar: some View {
        let initial = nameDraft.trimmingCharacters(in: .whitespacesAndNewlines).first.map { String($0).uppercased() }
        return ZStack {
            Circle().fill(DS.surfaceRaised)
            Circle().strokeBorder(DS.silver.opacity(0.08), lineWidth: 1)
            if let initial {
                Text(initial)
                    .font(.ui(22, .semibold))
                    .foregroundStyle(DS.silver)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(DS.silver.opacity(0.45))
            }
        }
        .frame(width: 56, height: 56)
        .accessibilityHidden(true)
    }

    /// Premium and ad privacy without the FAQ row and links, which take
    /// their own places in the columns.
    private var premiumSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "PREMIUM & PRIVACY")
            premiumRows
        }
    }

    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "SUPPORT")
            faqLink
        }
    }

    // MARK: - About you

    @ViewBuilder
    private var aboutYou: some View {
        if let profile = store.profile {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    SectionEyebrow(text: "ABOUT YOU")
                    Spacer()
                    Button("Edit") { editsProfile = true }
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver)
                        .buttonStyle(.plain)
                }
                VStack(alignment: .leading, spacing: 12) {
                    nameField
                    Hairline(opacity: 0.06)
                    HStack(spacing: 8) {
                        fact("GOAL", profile.goal.title)
                        fact("SEX", profile.sex == .unspecified ? "–" : profile.sex.title)
                    }
                    HStack(spacing: 8) {
                        fact("HEIGHT", store.unit.height(profile.heightCm))
                        fact("WEIGHT", store.unit.total(profile.weightKg))
                    }
                    Hairline(opacity: 0.06)
                    Text(planSummary(profile))
                        .font(.ui(12.5))
                        .cssLineHeight(12.5, 1.45)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
            }
        }
    }

    /// What Train greets the lifter by. Saved, trimmed, when the field is
    /// left or Return is pressed; cleared, it takes the name away.
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 3) {
            MetaLine(text: "NAME", size: layout.value(8.5, 10))
                .accessibilityHidden(true)
            TextField("Add your name", text: $nameDraft)
                .accessibilityLabel("Name")
                .font(.ui(layout.value(15, 20), .semibold))
                .foregroundStyle(DS.silver)
                .textContentType(.givenName)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .focused($editsName)
                .onSubmit(saveName)
        }
        .onAppear { nameDraft = store.profile?.name ?? "" }
        .onChange(of: nameDraft) { _, name in
            if name.count > Self.nameLimit { nameDraft = String(name.prefix(Self.nameLimit)) }
        }
        .onChange(of: editsName) { _, editing in if !editing { saveName() } }
        .onDisappear(perform: saveName)
        // Leaving the app keeps the field focused, so nothing above runs;
        // save before it can be closed.
        .onChange(of: scenePhase) { _, phase in if phase != .active { saveName() } }
    }

    /// Enough for a first name or a nickname. The Train header greets with
    /// it on one line, and longer greeting lines leave a long name out.
    private static let nameLimit = 24

    private func saveName() {
        let name = nameDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        nameDraft = name
        guard store.profile != nil, (store.profile?.name ?? "") != name else { return }
        store.profile?.name = name.isEmpty ? nil : name
    }

    private func fact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            MetaLine(text: label, size: layout.value(8.5, 10))
            Text(value)
                .font(.ui(layout.value(15, 17), .semibold))
                .foregroundStyle(DS.silver)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    /// "Front / Back, 3 days a week · Lower-body focus · Basic presets · walk
    /// 3,000 steps after workouts."
    private func planSummary(_ profile: UserProfile) -> String {
        let split = ProgramAdvisor.split(for: profile).title
        var parts = [profile.daysPerWeek.map { "\(split), \($0) days a week" } ?? split]
        if ProgramAdvisor.isLowerFocused(profile) { parts.append("Lower-body focus") }
        parts.append("\(store.suggestedLevel.title.capitalized) presets")
        if let walk = store.walkSuggestion {
            parts.append("walk \(walk.steps.formatted()) steps after workouts")
        }
        return parts.joined(separator: " · ") + "."
    }

    // MARK: - Settings

    private var settings: some View {
        @Bindable var store = store
        return VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "SETTINGS")
            VStack(spacing: 0) {
                settingRow("Units", detail: "Switching only changes how weights are shown.") {
                    MonoSegmentedControl(
                        options: WeightUnit.allCases.map { ($0, $0.symbol.uppercased()) },
                        selection: $store.unit,
                        fontSize: 10,
                        itemPaddingH: layout.value(13, 15),
                        itemPaddingV: 7
                    )
                }
                Hairline(opacity: 0.06)
                settingRow("Training experience", detail: "Sets how long recovery estimates run.") {
                    menu(selection: $store.experience, options: TrainingExperience.allCases, title: \.title)
                }
                Hairline(opacity: 0.06)
                settingRow("Rest timer", detail: store.rest == .auto
                           ? "Auto: 3 min for 6 reps or fewer, 2 min up to 9, 90 s above, 1 min after holds."
                           : store.rest == .off ? "No timer after sets."
                           : "Starts when a set is marked done.") {
                    menu(selection: $store.rest, options: RestSetting.allCases, title: \.title)
                }
            }
            .padding(.horizontal, cardPadding)
            .background(card)
        }
    }

    // MARK: - Card colors

    /// The Train tab's card edges: which show, when green starts over, and
    /// the colours themselves.
    private var cardColorSettings: some View {
        let reset = cardColors.reset
        return VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "TRAIN CARD COLORS")
            VStack(spacing: 0) {
                settingRow("Card colors", detail: cardColorDetail) {
                    menu(selection: cardColors.$mode, options: CardColorMode.allCases, title: \.title)
                }
                if cardColors.mode != .off {
                    Hairline(opacity: 0.06)
                    settingRow("Green starts over", detail: reset == .weekly
                               ? "Each new week, every group not trained yet that week turns green."
                               : "Once every group in your split has been trained, a new round starts and each turns green again as it recovers.") {
                        menu(selection: cardColors.$reset, options: TrainingRound.Reset.allCases, title: \.title)
                    }
                    ForEach(cardColors.mode.tones, id: \.self) { tone in
                        Hairline(opacity: 0.06)
                        settingRow(tone.title(reset: reset), detail: toneDetail(tone, reset: reset)) {
                            ColorPicker(tone.title(reset: reset), selection: cardColors.binding(for: tone),
                                        supportsOpacity: false)
                                .labelsHidden()
                        }
                    }
                    if cardColors.hasCustomColors {
                        Hairline(opacity: 0.06)
                        moreButton("Reset to default colors") { cardColors.resetColors() }
                    }
                }
            }
            .padding(.horizontal, cardPadding)
            .background(card)
        }
    }

    private var cardColorDetail: String {
        let done = cardColors.reset == .weekly ? "done this week" : "done this round"
        switch cardColors.mode {
        case .all: return "Red while a group recovers, yellow once it's \(done), green while it's still due."
        case .redGreen: return "Red while a group recovers, green while it's still due."
        case .off: return "No colored edges on the Train tab."
        }
    }

    private func toneDetail(_ tone: MuscleCardTone, reset: TrainingRound.Reset) -> String {
        switch tone {
        case .waiting: return "Trained and still recovering."
        case .recent: return reset == .weekly
            ? "Trained this week and recovered."
            : "Trained this round and recovered; it waits for the rest of the round."
        case .due: return reset == .weekly ? "Not trained yet this week." : "Not trained yet this round."
        }
    }

    // MARK: - Premium & privacy

    private var premiumAndPrivacy: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "PREMIUM & PRIVACY")
            premiumRows
            faqLink
            legalLinks
        }
    }

    private var premiumRows: some View {
        VStack(spacing: 0) {
            settingRow("MUSQ Premium", detail: premiumDetail) {
                pillButton(purchases.isPremium ? "ACTIVE" : "UPGRADE", prominent: !purchases.isPremium) {
                    paywall.show(.profile)
                }
            }
            if ads.privacyOptionsRequired {
                Hairline(opacity: 0.06)
                settingRow("Privacy choices", detail: "Change what you agreed to for ads.") {
                    pillButton("OPEN") { Task { await ads.presentPrivacyOptions() } }
                }
            }
        }
        .padding(.horizontal, cardPadding)
        .background(card)
    }

    private var faqLink: some View {
        NavigationLink {
            FAQView()
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Help & FAQ")
                        .font(.ui(layout.value(14.5, 16), .semibold))
                        .foregroundStyle(DS.silver)
                    Text("Premium, billing, recovery, your data, and contact.")
                        .font(.ui(layout.value(12, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.system(size: layout.value(11, 12), weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.28))
            }
            .padding(.horizontal, cardPadding)
            .padding(.vertical, layout.value(13, 16))
            .background(card)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: layout.cardRadius)
    }

    private var legalLinks: some View {
        HStack(spacing: layout.value(14, 18)) {
            Link("Privacy Policy", destination: AppLinks.privacy)
            Link("Terms of Use", destination: AppLinks.terms)
            Link("Support", destination: AppLinks.support)
        }
        .font(.ui(layout.value(12, 13), .semibold))
        .foregroundStyle(DS.silver.opacity(0.55))
        .padding(.horizontal, 4)
        .padding(.top, 2)
    }

    private var premiumDetail: String {
        switch purchases.activePlan {
        case Purchases.ProductID.yearly: return "Your yearly plan is active."
        case Purchases.ProductID.monthly: return "Your monthly plan is active."
        case Purchases.ProductID.lifetime: return "Lifetime. Premium is yours for good."
        default:
            return purchases.isPremium
                ? "Premium is on."
                : "Common mistakes, Preset 2 and 3, no ads."
        }
    }

    // MARK: - Pieces

    /// Every settings card: 16pt corners and 14pt sides on iPhone, the
    /// tier's 20 and 18 on iPad.
    private var card: some View {
        RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt)
    }

    private var cardPadding: CGFloat { layout.value(14, 18) }

    /// A small capsule action; prominent (silver) when it's an offer.
    private func pillButton(_ title: String, prominent: Bool = false,
                            action: @escaping () -> Void) -> some View {
        let size: CGFloat = layout.value(10, 11)
        return Button(action: action) {
            Text(title)
                .font(.mono(size, .semibold))
                .trackingEm(0.08, size: size)
                .foregroundStyle(prominent ? DS.ink : DS.silver.opacity(0.8))
                .padding(.horizontal, layout.value(11, 14))
                .padding(.vertical, layout.value(8, 9))
                .background(Capsule().fill(prominent ? DS.silver : DS.silver.opacity(0.07)))
        }
        .buttonStyle(.plain)
        .dsHover()
    }

    /// Title and what it does, then the control. On iPad the text stops at
    /// 380pt, so in a wide column the control stays near the words it sets
    /// instead of drifting to the far edge.
    private func settingRow<Control: View>(_ title: String, detail: String,
                                           @ViewBuilder control: () -> Control) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.ui(layout.value(14.5, 16), .semibold))
                    .foregroundStyle(DS.silver)
                Text(detail)
                    .font(.ui(layout.value(12, 13.5)))
                    .cssLineHeight(layout.value(12, 13.5), 1.4)
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            }
            // Bounds are nil in compact, which leaves the phone's layout as
            // it was.
            .frame(maxWidth: layout.isRegular ? 380 : nil, alignment: .leading)
            Spacer(minLength: 8)
            control()
        }
        .padding(.vertical, layout.value(13, 16))
    }

    private func menu<Value: Hashable & Identifiable>(selection: Binding<Value>, options: [Value],
                                                      title: KeyPath<Value, String>) -> some View {
        let size: CGFloat = layout.value(10, 11)
        return Menu {
            Picker(selection: selection) {
                ForEach(options) { Text($0[keyPath: title]).tag($0) }
            } label: { EmptyView() }
        } label: {
            HStack(spacing: 5) {
                Text(selection.wrappedValue[keyPath: title].uppercased())
                    .font(.mono(size, .semibold))
                    .trackingEm(0.08, size: size)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: layout.value(8, 9), weight: .bold))
            }
            .foregroundStyle(DS.silver.opacity(0.8))
            .padding(.horizontal, layout.value(11, 14))
            .padding(.vertical, layout.value(8, 9))
            .background(Capsule().fill(DS.silver.opacity(0.07)))
        }
        .dsHover()
    }

    private func moreButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.ui(layout.value(13, 14), .semibold))
                .foregroundStyle(DS.silver.opacity(0.7))
                .frame(maxWidth: .infinity)
                .padding(.vertical, layout.value(10, 13))
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview("Profile · iPad mini portrait") {
    let purchases = Purchases()
    return ProfileView(tab: .constant(.profile))
        .environment(WorkoutStore())
        .environment(RestTimer())
        .environment(purchases)
        .environment(Ads(purchases: purchases))
        .environment(Paywall())
        .dsPreview(.mini660)
}

#Preview("Profile · 13-inch landscape") {
    let purchases = Purchases()
    return ProfileView(tab: .constant(.profile))
        .environment(WorkoutStore())
        .environment(RestTimer())
        .environment(purchases)
        .environment(Ads(purchases: purchases))
        .environment(Paywall())
        .dsPreview(.pad13Landscape1110)
}
