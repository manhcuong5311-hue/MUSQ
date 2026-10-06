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

import SwiftUI

struct ProfileView: View {
    @Binding var tab: AppTab

    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases
    @Environment(Ads.self) private var ads
    @Environment(Paywall.self) private var paywall
    @Environment(\.scenePhase) private var scenePhase
    @State private var editsProfile = false
    /// The name as it's typed; saved when the field is left.
    @State private var nameDraft = ""
    @FocusState private var editsName: Bool
    private let cardColors = CardColorPrefs()

    var body: some View {
        NavigationStack {
            ZStack {
                DS.ink.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
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
                .scrollDismissesKeyboard(.interactively)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            .statusBarScrim()
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(DS.silver)
        .fullScreenCover(isPresented: $editsProfile) {
            OnboardingView(isEditing: true, onClose: { editsProfile = false })
                .environment(store)
                .environment(purchases)
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
            MetaLine(text: "NAME", size: 8.5)
                .accessibilityHidden(true)
            TextField("Add your name", text: $nameDraft)
                .accessibilityLabel("Name")
                .font(.ui(15, .semibold))
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
            MetaLine(text: label, size: 8.5)
            Text(value)
                .font(.ui(15, .semibold))
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
                        itemPaddingH: 13,
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
            .padding(.horizontal, 14)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
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
            .padding(.horizontal, 14)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
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
            .padding(.horizontal, 14)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))

            NavigationLink {
                FAQView()
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Help & FAQ")
                            .font(.ui(14.5, .semibold))
                            .foregroundStyle(DS.silver)
                        Text("Premium, billing, recovery, your data, and contact.")
                            .font(.ui(12))
                            .foregroundStyle(DS.silver.opacity(0.5))
                    }
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.28))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 13)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            HStack(spacing: 14) {
                Link("Privacy Policy", destination: AppLinks.privacy)
                Link("Terms of Use", destination: AppLinks.terms)
                Link("Support", destination: AppLinks.support)
            }
            .font(.ui(12, .semibold))
            .foregroundStyle(DS.silver.opacity(0.55))
            .padding(.horizontal, 4)
            .padding(.top, 2)
        }
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

    /// A small capsule action; prominent (silver) when it's an offer.
    private func pillButton(_ title: String, prominent: Bool = false,
                            action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.mono(10, .semibold))
                .trackingEm(0.08, size: 10)
                .foregroundStyle(prominent ? DS.ink : DS.silver.opacity(0.8))
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(Capsule().fill(prominent ? DS.silver : DS.silver.opacity(0.07)))
        }
        .buttonStyle(.plain)
    }

    private func settingRow<Control: View>(_ title: String, detail: String,
                                           @ViewBuilder control: () -> Control) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.ui(14.5, .semibold))
                    .foregroundStyle(DS.silver)
                Text(detail)
                    .font(.ui(12))
                    .cssLineHeight(12, 1.4)
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
            control()
        }
        .padding(.vertical, 13)
    }

    private func menu<Value: Hashable & Identifiable>(selection: Binding<Value>, options: [Value],
                                                      title: KeyPath<Value, String>) -> some View {
        Menu {
            Picker(selection: selection) {
                ForEach(options) { Text($0[keyPath: title]).tag($0) }
            } label: { EmptyView() }
        } label: {
            HStack(spacing: 5) {
                Text(selection.wrappedValue[keyPath: title].uppercased())
                    .font(.mono(10, .semibold))
                    .trackingEm(0.08, size: 10)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 8, weight: .bold))
            }
            .foregroundStyle(DS.silver.opacity(0.8))
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .background(Capsule().fill(DS.silver.opacity(0.07)))
        }
    }

    private func moreButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.ui(13, .semibold))
                .foregroundStyle(DS.silver.opacity(0.7))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
