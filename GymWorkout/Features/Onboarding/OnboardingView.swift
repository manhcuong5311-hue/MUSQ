//
//  OnboardingView.swift
//  GymWorkout
//
//  First launch: six questions — experience, sex, goal, days a week, how to
//  split them, height and weight — then the plan they add up to. The same
//  screens edit the answers later from Profile. Answers only shape
//  suggestions (see `ProgramAdvisor`).
//
//  On iPad the questions sit in one centred column, or, on a wide window, in
//  a form pane beside a studio stage whose body map stays put and lights up
//  with the answers while only the form moves from step to step.
//

import SwiftUI

struct OnboardingView: View {
    /// Opened from Profile: starts on the first question with the saved
    /// answers, can be closed, and ends on Save.
    var isEditing = false
    var onClose: () -> Void = {}

    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases
    /// The window on first run, or the edit sheet's own measured size.
    @Environment(\.dsLayout) private var layout

    @State private var step: Step = .welcome
    @State private var movingForward = true
    @State private var experience: TrainingExperience?
    @State private var sex: Sex?
    @State private var goal: FitnessGoal?
    @State private var daysPerWeek: Int?
    @State private var split: TrainingSplit?
    @State private var unit: WeightUnit = .kg
    @State private var heightCm: Double = 170
    @State private var weightKg: Double = 70
    /// Height and weight were set by hand, so picking a sex no longer
    /// changes their starting values.
    @State private var bodyTouched = false
    @State private var didLoad = false
    @State private var showsPremium = false

    enum Step: Int, CaseIterable {
        case welcome, experience, sex, goal, days, split, body, plan

        static let questions: [Step] = [.experience, .sex, .goal, .days, .split, .body]
    }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            if layout.isWide {
                HStack(spacing: 0) {
                    stage
                        .frame(width: layout.paneWidth(0.44, min: 420, max: 600))
                    form
                }
            } else {
                form
            }
        }
        .onAppear(perform: load)
        // ⌘[ and Esc step back, or close the editor from its first question.
        .dsBackShortcuts(back)
        // Presented here rather than through `Paywall`: closing it, bought or
        // not, is what finishes onboarding.
        .sheet(isPresented: $showsPremium, onDismiss: finish) {
            PremiumView(reason: .onboarding)
                .environment(purchases)
        }
    }

    /// The bar, the page and the button. Full width on iPhone; a centred
    /// column on iPad, or the form pane beside the stage.
    private var form: some View {
        VStack(spacing: 0) {
            if step != .welcome {
                topBar
            }
            ZStack {
                page
                    .id(step)
                    .transition(pageTransition)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .clipped()

            footer
                .modifier(FormColumn(compactPadding: DS.Metric.gutter))
                .padding(.bottom, layout.value(12, 20, wide: 24))
        }
    }

    /// A whole screen's width is a long way to slide on iPad: there the page
    /// drifts 48pt and fades instead.
    private var pageTransition: AnyTransition {
        if layout.isRegular {
            return .asymmetric(
                insertion: .offset(x: movingForward ? 48 : -48).combined(with: .opacity),
                removal: .offset(x: movingForward ? -48 : 48).combined(with: .opacity)
            )
        }
        return .asymmetric(
            insertion: .move(edge: movingForward ? .trailing : .leading).combined(with: .opacity),
            removal: .move(edge: movingForward ? .leading : .trailing).combined(with: .opacity)
        )
    }

    // MARK: - Chrome

    private var topBar: some View {
        HStack(spacing: 14) {
            CircleIconButton(action: back) {
                Image(systemName: isEditing && step == .experience ? "xmark" : "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel(isEditing && step == .experience ? "Close" : "Back")

            HStack(spacing: 5) {
                ForEach(Step.questions, id: \.self) { question in
                    Capsule()
                        .fill(DS.silver.opacity(question.rawValue <= step.rawValue ? 0.85 : 0.12))
                        .frame(height: layout.value(4, 5))
                }
            }
            .accessibilityElement()
            .accessibilityLabel(questionNumber.map { "Question \($0) of \(Step.questions.count)" } ?? "Your plan")
        }
        .modifier(FormColumn(compactPadding: 16))
        .padding(.top, layout.value(11, 14))
        .padding(.bottom, layout.value(6, 10))
        .animation(.easeOut(duration: 0.25), value: step)
    }

    private var questionNumber: Int? {
        Step.questions.firstIndex(of: step).map { $0 + 1 }
    }

    @ViewBuilder
    private var footer: some View {
        switch step {
        case .welcome:
            VStack(spacing: 10) {
                WideButton(title: "Get Started", prominent: true, fontSize: 15, verticalPadding: 15) { advance() }
                    .modifier(ReturnKey())
                Text("Six quick questions · about a minute")
                    .font(.ui(layout.value(12, 13)))
                    .foregroundStyle(DS.silver.opacity(0.45))
            }
        case .plan:
            WideButton(title: isEditing ? "Save Changes" : "Start Training", prominent: true,
                       fontSize: 15, verticalPadding: 15, action: complete)
                .modifier(ReturnKey())
        default:
            WideButton(title: "Continue", prominent: canContinue, fontSize: 15, verticalPadding: 15) { advance() }
                .disabled(!canContinue)
                .opacity(canContinue ? 1 : 0.5)
                .modifier(ReturnKey())
        }
    }

    private var canContinue: Bool {
        switch step {
        case .experience: return experience != nil
        case .sex: return sex != nil
        case .goal: return goal != nil
        case .days: return daysPerWeek != nil
        case .split: return split != nil
        default: return true
        }
    }

    // MARK: - Stage

    /// Wide only: the studio card on the leading side. It isn't part of the
    /// page, so it stays where it is from step to step; the figure turns and
    /// re-lights with a crossfade as the answers come in.
    private var stage: some View {
        let light = stageLight
        return GeometryReader { geo in
            let figureHeight = min(geo.size.height * 0.72, 640)
            ZStack {
                ViewportGround(inner: DS.viewportInner, outer: DS.viewportOuter,
                               rx: 0.9, ry: 0.7, cx: 0.5, cy: 0.45, aspectLocked: true)
                BodyMapCanvas(side: light.side, fills: light.fills,
                              lineWidth: figureHeight > 450 ? 1.0 : 0.75)
                    .frame(width: figureHeight * BodyMapCanvas.aspect, height: figureHeight)
                    .id(light)
                    .transition(.opacity)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .overlay(alignment: .bottom) {
                if let caption = light.caption {
                    MetaLine(text: caption)
                        .padding(.bottom, 24)
                        .id(caption)
                        .transition(.opacity)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: DS.Metric.viewportRadius, style: .continuous))
        .padding([.top, .leading, .bottom], DS.Metric.viewportInset)
        .animation(.easeInOut(duration: 0.4), value: light)
        .accessibilityHidden(true)
    }

    /// The stage follows the answers: lower body once Female is picked, and
    /// the first day of the split from the split question on.
    private var stageLight: StageLight {
        if step == .split || step == .plan, let day = firstSplitDay {
            return .day(name: day.name, groups: day.groups)
        }
        return sex == .female ? .lowerBody : .sampler
    }

    /// Day one of the rotation the plan page shows.
    private var firstSplitDay: ProgramAdvisor.SplitDay? {
        let days = draftProfile.map { ProgramAdvisor.days(for: $0) }
            ?? ProgramAdvisor.days(of: split ?? .pushPullLegs, lowerFocus: sex == .female)
        return days
            .map { ProgramAdvisor.SplitDay(name: $0.name, groups: $0.groups.filter(PresetProvider.trainableGroups.contains)) }
            .first { !$0.groups.isEmpty }
    }

    // MARK: - Pages

    @ViewBuilder
    private var page: some View {
        switch step {
        case .welcome: welcome
        case .experience: experiencePage
        case .sex: sexPage
        case .goal: goalPage
        case .days: daysPage
        case .split: splitPage
        case .body: bodyPage
        case .plan: planPage
        }
    }

    @ViewBuilder
    private var welcome: some View {
        if layout.isWide {
            // The stage already shows the body; the pane is all words,
            // centred in the height above the button.
            VStack(alignment: .leading, spacing: 0) {
                SectionEyebrow(text: "MUSQ")
                Text("Training that fits you")
                    .font(.ui(40, .semibold))
                    .tracking(-1.1)
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 10)
                Text(Self.welcomeCaption)
                    .font(.ui(17))
                    .cssLineHeight(17, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 480, alignment: .leading)
                    .padding(.top, 14)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .modifier(FormColumn(compactPadding: DS.Metric.gutter))
        } else {
            VStack(alignment: .leading, spacing: 0) {
                BodyMapCanvas(side: .front, fills: Self.heroFills)
                    .frame(height: welcomeFigureHeight)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, layout.value(18, 24))
                    .background(
                        ViewportGround(inner: DS.viewportInner, outer: DS.viewportOuter,
                                       rx: 0.9, ry: 0.7, cx: 0.5, cy: 0.45, aspectLocked: layout.isRegular)
                            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    )
                    .accessibilityHidden(true)

                SectionEyebrow(text: "MUSQ")
                    .padding(.top, layout.value(28, 32))
                Text("Training that fits you")
                    .font(.ui(layout.value(30, 36), .semibold))
                    .tracking(layout.value(-0.8, -1))
                    .foregroundStyle(DS.silver)
                    .padding(.top, 8)
                Text(Self.welcomeCaption)
                    .font(.ui(layout.value(15, 16)))
                    .cssLineHeight(layout.value(15, 16), 1.45)
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 10)
            }
            .modifier(FormColumn(compactPadding: DS.Metric.gutter))
            .padding(.top, layout.value(16, 24))
        }
    }

    private static let welcomeCaption = "Tell us about your experience, goal, week and body, and we'll shape your split, presets and recovery estimates around you."

    /// 330 on iPhone; up to 440 on iPad, less in a short window, where the
    /// welcome page doesn't scroll.
    private var welcomeFigureHeight: CGFloat {
        guard layout.isRegular, layout.containerHeight > 0 else { return 330 }
        return min(440, max(260, layout.containerHeight * 0.42))
    }

    private static var heroFills: [BodyRegion: Color] {
        var fills: [BodyRegion: Color] = [:]
        for group in [MuscleGroup.chest, .quads] {
            for region in group.bodyRegions { fills[region] = DS.activation }
        }
        for group in [MuscleGroup.shoulders, .abs, .biceps] {
            for region in group.bodyRegions { fills[region] = DS.activationSoft.opacity(0.6) }
        }
        return fills
    }

    private var experiencePage: some View {
        QuestionPage(
            eyebrow: "EXPERIENCE",
            title: "How long have you been training?",
            caption: "Sets how long recovery estimates run and which presets you start on."
        ) {
            option(.beginner, in: $experience, symbol: "leaf",
                   title: "Just starting", detail: "New to the gym, or back after a long break.")
            option(.intermediate, in: $experience, symbol: "figure.walk",
                   title: "Less than a year", detail: "I know the basics and train now and then.")
            option(.advanced, in: $experience, symbol: "flame",
                   title: "A year or more", detail: "I train regularly and know the main lifts.")
        }
    }

    private var sexPage: some View {
        QuestionPage(
            eyebrow: "ABOUT YOU",
            title: "What's your sex?",
            caption: "Female plans bring more lower-body work — glutes, hamstrings and quads — into your split. Any muscle can still be trained any day."
        ) {
            option(.female, in: $sex, symbol: "figure.stand.dress", title: "Female",
                   detail: "Lower-body focus: legs and glutes twice in each rotation.")
            option(.male, in: $sex, symbol: "figure.stand", title: "Male",
                   detail: "An even split of upper and lower body.")
            option(.unspecified, in: $sex, symbol: "person.fill.questionmark", title: "Prefer not to say",
                   detail: "An even split of upper and lower body.")
        }
    }

    private var goalPage: some View {
        QuestionPage(
            eyebrow: "GOAL",
            title: "What's your main goal?",
            caption: "Shapes which preset each muscle group opens on. You can switch at any time."
        ) {
            option(.loseWeight, in: $goal, symbol: "figure.walk.motion", title: "Lose weight",
                   detail: "Easier presets, plus a walking target after each workout.")
            option(.buildMuscle, in: $goal, symbol: "dumbbell", title: "Build muscle",
                   detail: "Harder free-weight presets once you have some experience.")
            option(.getFit, in: $goal, symbol: "heart", title: "Get fit",
                   detail: "A balanced mix to feel stronger day to day.")
        }
    }

    private var daysPage: some View {
        QuestionPage(
            eyebrow: "SCHEDULE",
            title: "How many days a week can you train?",
            caption: "Sets how your week is split. Train suggests the most recovered day each time, so a missed day never breaks the plan."
        ) {
            ForEach(ProgramAdvisor.daysPerWeekOptions, id: \.self) { days in
                let suggested = ProgramAdvisor.recommendedSplit(daysPerWeek: days)
                OptionCard(symbol: "calendar", title: "\(days) days a week",
                           detail: "\(suggested.title) · every muscle \(frequency(suggested, days)).",
                           isSelected: daysPerWeek == days) {
                    withAnimation(.easeOut(duration: 0.15)) {
                        // A new schedule brings its own split; the next
                        // question can still change it.
                        if daysPerWeek != days { split = suggested }
                        daysPerWeek = days
                    }
                }
            }
        }
    }

    private var splitPage: some View {
        let days = daysPerWeek ?? 3
        let suggested = ProgramAdvisor.recommendedSplit(daysPerWeek: days)
        return QuestionPage(
            eyebrow: "SPLIT",
            title: "How do you want to split your week?",
            caption: "\(suggested.title) suits \(days) days a week best: \(ProgramAdvisor.recommendationReason(daysPerWeek: days))"
        ) {
            ForEach(TrainingSplit.allCases) { option in
                OptionCard(symbol: Self.symbol(option), title: option.title,
                           detail: "\(Self.summary(option)) Every muscle \(frequency(option, days)).",
                           badge: option == suggested ? "BEST FIT" : nil,
                           isSelected: split == option) {
                    withAnimation(.easeOut(duration: 0.15)) { split = option }
                }
            }
        }
    }

    private static func symbol(_ split: TrainingSplit) -> String {
        switch split {
        case .upperLower: return "arrow.up.arrow.down"
        case .frontBack: return "arrow.left.arrow.right"
        case .pushPullLegs: return "arrow.triangle.2.circlepath"
        }
    }

    private static func summary(_ split: TrainingSplit) -> String {
        switch split {
        case .upperLower: return "Upper body one day, lower body the next."
        case .frontBack: return "Chest, shoulders, quads and biceps one day; back, hamstrings, glutes and triceps the next."
        case .pushPullLegs: return "Chest, shoulders and triceps; then back and biceps; then legs."
        }
    }

    private func frequency(_ split: TrainingSplit, _ days: Int) -> String {
        ProgramAdvisor.frequencyText(ProgramAdvisor.timesPerWeek(split, lowerFocus: sex == .female, daysPerWeek: days))
    }

    private var bodyPage: some View {
        QuestionPage(
            eyebrow: "BODY",
            title: "Your height and weight",
            caption: "Used for estimates such as the distance and calories of a walk. "
                + (DS.isPad ? "Kept only on this iPad." : "Kept only on this phone.")
        ) {
            MonoSegmentedControl(
                options: [(WeightUnit.kg, "KG · CM"), (.lb, "LB · FT")],
                selection: $unit,
                fontSize: 10,
                itemPaddingV: 8,
                fillsWidth: true
            )

            HStack(spacing: 10) {
                wheel("HEIGHT") {
                    if unit == .kg {
                        Picker("Height", selection: heightInCentimetres) {
                            ForEach(130...220, id: \.self) { Text("\($0) cm").tag($0) }
                        }
                    } else {
                        Picker("Height", selection: heightInInches) {
                            ForEach(51...87, id: \.self) { Text("\($0 / 12)′ \($0 % 12)″").tag($0) }
                        }
                    }
                }
                wheel("WEIGHT") {
                    Picker("Weight", selection: weightInUnit) {
                        ForEach(unit == .kg ? Array(30...200) : Array(66...440), id: \.self) {
                            Text("\($0) \(unit.symbol)").tag($0)
                        }
                    }
                }
            }
            // Two wheels a column wide would be long low strips; on iPad they
            // match the unit control's width above them. Nil on iPhone.
            .frame(maxWidth: layout.isRegular ? 440 : nil)
            .padding(.top, 6)
        }
    }

    private var planPage: some View {
        let profile = draftProfile
        let rotation = ProgramAdvisor.days(for: profile)
            .map { ProgramAdvisor.SplitDay(name: $0.name, groups: $0.groups.filter(PresetProvider.trainableGroups.contains)) }
            .filter { !$0.groups.isEmpty }
        let chosen = ProgramAdvisor.split(for: profile)
        let days = daysPerWeek ?? 3
        let level = ProgramAdvisor.suggestedLevel(for: profile, experience: experience ?? .beginner)
        // The single iPad column has room for the smaller cards in pairs; the
        // narrower wide-window pane keeps them stacked.
        let pairs = layout.tier == .regular
        let dayLabelSize: CGFloat = layout.value(9, 10)

        let rotationCard = PlanCard(symbol: Self.symbol(chosen), title: "\(chosen.title), \(days) days a week",
                                    detail: (ProgramAdvisor.isLowerFocused(profile) ? "Lower-body focus. " : "")
                                        + "Every muscle \(frequency(chosen, days)). Train suggests the most recovered day.") {
            VStack(alignment: .leading, spacing: layout.value(7, 9)) {
                ForEach(Array(rotation.enumerated()), id: \.offset) { index, day in
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Text(day.name.uppercased())
                            .font(.mono(dayLabelSize, .semibold))
                            .trackingEm(0.08, size: dayLabelSize)
                            .foregroundStyle(DS.silver.opacity(0.4))
                            .frame(width: layout.value(52, 64), alignment: .leading)
                        Text(day.groups.map(\.title).joined(separator: " · "))
                            .font(.ui(layout.value(13.5, 15), .semibold))
                            .foregroundStyle(DS.silver)
                    }
                }
            }
            .padding(.top, 4)
        }
        let presetsCard = PlanCard(symbol: "slider.horizontal.3", title: "\(level.title.capitalized) presets",
                                   detail: level == .basic
                                    ? "Machines and supported positions to start. Switch to Advanced on any muscle group."
                                    : "Free-weight compounds to start. Switch to Basic on any muscle group.",
                                   fillsHeight: pairs)
        let walkCard = profile.flatMap { profile -> PlanCard<EmptyView>? in
            guard profile.goal == .loseWeight else { return nil }
            let walk = ProgramAdvisor.walk(for: profile, experience: experience ?? .beginner)
            return PlanCard(symbol: "figure.walk", title: "Walk \(walk.steps.formatted()) steps after each workout",
                            detail: "\(walk.detail). Aim for \(WalkSuggestion.dailySteps.formatted())+ steps across the day.",
                            fillsHeight: pairs)
        }
        let recoveryCard = PlanCard(symbol: "clock.arrow.circlepath", title: "Recovery",
                                    detail: "Estimates tuned for \((experience ?? .beginner).title.lowercased()) lifters.",
                                    fillsHeight: pairs)

        return ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                SectionEyebrow(text: "YOUR PLAN")
                Text(isEditing ? "Your updated plan" : "Here's where you start")
                    .font(.ui(layout.pt(26, 32, wide: 34), .semibold))
                    .tracking(layout.value(-0.6, -0.85))
                    .foregroundStyle(DS.silver)
                    .padding(.top, layout.value(8, 10))

                VStack(spacing: layout.value(10, 12)) {
                    rotationCard

                    if pairs {
                        // With a walk, three cards: a pair and one across.
                        if let walkCard {
                            pairRow(presetsCard, walkCard)
                            recoveryCard
                        } else {
                            pairRow(presetsCard, recoveryCard)
                        }
                    } else {
                        presetsCard
                        if let walkCard {
                            walkCard
                        }
                        recoveryCard
                    }
                }
                .padding(.top, layout.value(20, 26))

                Text("Change any of this later in Profile.")
                    .font(.ui(layout.value(12, 13)))
                    .foregroundStyle(DS.silver.opacity(0.4))
                    .padding(.top, 14)
            }
            .modifier(FormColumn(compactPadding: DS.Metric.gutter))
            .padding(.top, layout.value(16, 24))
            .padding(.bottom, 16)
        }
    }

    /// Two cards side by side at the taller one's height.
    private func pairRow<A: View, B: View>(_ leading: A, _ trailing: B) -> some View {
        HStack(alignment: .top, spacing: 12) {
            leading
            trailing
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Pieces

    private func option<Value: Hashable>(_ value: Value, in selection: Binding<Value?>, symbol: String,
                                         title: String, detail: String) -> some View {
        OptionCard(symbol: symbol, title: title, detail: detail, isSelected: selection.wrappedValue == value) {
            withAnimation(.easeOut(duration: 0.15)) { selection.wrappedValue = value }
        }
    }

    private func wheel<Content: View>(_ label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 4) {
            SectionEyebrow(text: label, size: layout.value(9.5, 10.5))
            content()
                .pickerStyle(.wheel)
                .frame(height: layout.value(170, 200))
                .clipped()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, layout.value(12, 14))
        .background(RoundedRectangle(cornerRadius: layout.value(16, 18), style: .continuous).fill(DS.surfaceAlt))
    }

    // MARK: - Bindings

    private var heightInCentimetres: Binding<Int> {
        Binding(get: { Int(heightCm.rounded()) },
                set: { heightCm = Double($0); bodyTouched = true })
    }

    private var heightInInches: Binding<Int> {
        Binding(get: { Int((heightCm / 2.54).rounded()) },
                set: { heightCm = Double($0) * 2.54; bodyTouched = true })
    }

    private var weightInUnit: Binding<Int> {
        Binding(get: { Int(unit.fromKilograms(weightKg).rounded()) },
                set: { weightKg = unit.toKilograms(Double($0)); bodyTouched = true })
    }

    private var draftProfile: UserProfile? {
        guard let sex, let goal else { return nil }
        // Onboarding doesn't ask for a name; editing keeps the one from Profile.
        return UserProfile(sex: sex, goal: goal, heightCm: heightCm, weightKg: weightKg,
                           daysPerWeek: daysPerWeek, split: split, name: store.profile?.name)
    }

    // MARK: - Actions

    private func load() {
        guard !didLoad else { return }
        didLoad = true
        unit = store.unit
        if let profile = store.profile {
            experience = store.experience
            sex = profile.sex
            goal = profile.goal
            // Nil for profiles from before the schedule question, which then
            // have to answer it; picking the days suggests the split.
            daysPerWeek = profile.daysPerWeek
            split = profile.split
            heightCm = profile.heightCm
            weightKg = profile.weightKg
            bodyTouched = true
        }
        if isEditing { step = .experience }
    }

    private func advance() {
        guard canContinue, let next = Step(rawValue: step.rawValue + 1) else { return }
        if step == .sex && !bodyTouched {
            // A closer starting point for the wheels; still just a start.
            heightCm = sex == .female ? 162 : sex == .male ? 176 : 170
            weightKg = sex == .female ? 60 : sex == .male ? 75 : 68
        }
        movingForward = true
        withAnimation(.easeInOut(duration: 0.3)) { step = next }
    }

    private func back() {
        if isEditing && step == .experience { onClose(); return }
        guard let previous = Step(rawValue: step.rawValue - 1) else { return }
        movingForward = false
        withAnimation(.easeInOut(duration: 0.3)) { step = previous }
    }

    /// A new user sees Premium once, on the way in. Saving edits from
    /// Profile, or already being premium, skips it.
    private func complete() {
        if isEditing || purchases.isPremium {
            finish()
        } else {
            showsPremium = true
        }
    }

    private func finish() {
        guard let experience, let profile = draftProfile else { return }
        store.experience = experience
        store.unit = unit
        store.profile = profile
        onClose()
    }
}

// MARK: - Layout

/// Where onboarding's content sits across the width: the phone's gutter; one
/// centred 600pt column in regular; a 540pt column in the wide form pane,
/// 56pt clear of the stage and the edge.
private struct FormColumn: ViewModifier {
    var compactPadding: CGFloat

    @Environment(\.dsLayout) private var layout

    func body(content: Content) -> some View {
        switch layout.tier {
        case .compact:
            content
                .padding(.horizontal, compactPadding)
        case .regular:
            content
                .frame(maxWidth: 600, alignment: .leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, layout.gutter)
        case .wide:
            content
                .frame(maxWidth: 540, alignment: .leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 56)
        }
    }
}

/// Return confirms the step on an iPad's hardware keyboard.
private struct ReturnKey: ViewModifier {
    func body(content: Content) -> some View {
        if DS.isPad {
            content.keyboardShortcut(.defaultAction)
        } else {
            content
        }
    }
}

/// What the wide stage's figure shows.
private enum StageLight: Hashable {
    /// The welcome's sampler: chest and quads, with the muscles around them.
    case sampler
    /// Glutes, hamstrings and quads, once Female is picked.
    case lowerBody
    /// Day one of the chosen split.
    case day(name: String, groups: [MuscleGroup])

    /// Whichever view shows more of what's lit; the front on a tie.
    var side: BodySide {
        let groups = litGroups
        let back = groups.filter { $0.preferredSide == .back }.count
        return back > groups.count - back ? .back : .front
    }

    var fills: [BodyRegion: Color] {
        var fills: [BodyRegion: Color] = [:]
        if self == .sampler {
            for group in [MuscleGroup.shoulders, .abs, .biceps] {
                for region in group.bodyRegions { fills[region] = DS.activationSoft.opacity(0.6) }
            }
        }
        for group in litGroups {
            for region in group.bodyRegions { fills[region] = DS.activation }
        }
        return fills
    }

    var caption: String? {
        switch self {
        case .sampler: return nil
        case .lowerBody: return "LOWER-BODY FOCUS"
        case .day(let name, _): return "DAY 1 · \(name.uppercased())"
        }
    }

    private var litGroups: [MuscleGroup] {
        switch self {
        case .sampler: return [.chest, .quads]
        case .lowerBody: return [.glutes, .hamstrings, .quads]
        case .day(_, let groups): return groups
        }
    }
}

// MARK: - Components

/// A question: its eyebrow, title and why it's asked, then the answers.
private struct QuestionPage<Content: View>: View {
    var eyebrow: String
    var title: String
    var caption: String
    @ViewBuilder var content: () -> Content

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let captionSize: CGFloat = layout.value(14, 16)
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                SectionEyebrow(text: eyebrow)
                Text(title)
                    .font(.ui(layout.pt(26, 32, wide: 34), .semibold))
                    .tracking(layout.value(-0.6, -0.85))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, layout.value(8, 10))
                Text(caption)
                    .font(.ui(captionSize))
                    .cssLineHeight(captionSize, layout.value(1.45, 1.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                    // A reading measure under the title; nil on iPhone.
                    .frame(maxWidth: layout.isRegular ? 480 : nil, alignment: .leading)
                    .padding(.top, layout.value(8, 12))

                VStack(spacing: layout.value(10, 12)) {
                    content()
                }
                .padding(.top, layout.value(22, 28))
            }
            .modifier(FormColumn(compactPadding: DS.Metric.gutter))
            .padding(.top, layout.value(16, 24))
            .padding(.bottom, 16)
        }
    }
}

/// One answer: icon, title and what choosing it does.
struct OptionCard: View {
    var symbol: String
    var title: String
    var detail: String
    /// A short tag beside the title, e.g. "BEST FIT".
    var badge: String? = nil
    var isSelected: Bool
    var action: () -> Void

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let well: CGFloat = layout.value(44, 52)
        let radius: CGFloat = layout.value(18, 20)
        let detailSize: CGFloat = layout.value(12.5, 13.5)
        let badgeSize: CGFloat = layout.value(8.5, 9.5)
        Button(action: action) {
            HStack(spacing: layout.value(14, 16)) {
                Image(systemName: symbol)
                    .font(.system(size: layout.value(18, 21), weight: .medium))
                    .foregroundStyle(isSelected ? DS.ink : DS.silver)
                    .frame(width: well, height: well)
                    .background(
                        RoundedRectangle(cornerRadius: layout.value(12, 14), style: .continuous)
                            .fill(isSelected ? DS.silver : DS.silver.opacity(0.07))
                    )
                VStack(alignment: .leading, spacing: layout.value(3, 4)) {
                    HStack(spacing: 7) {
                        Text(title)
                            .font(.ui(layout.value(15.5, 17), .semibold))
                            .foregroundStyle(DS.silver)
                        if let badge {
                            Text(badge)
                                .font(.mono(badgeSize, .semibold))
                                .trackingEm(0.08, size: badgeSize)
                                .foregroundStyle(DS.silver.opacity(0.75))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(DS.silver.opacity(0.08)))
                        }
                    }
                    Text(detail)
                        .font(.ui(detailSize))
                        .cssLineHeight(detailSize, 1.4)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 4)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: layout.value(20, 22)))
                    .foregroundStyle(DS.silver.opacity(isSelected ? 1 : 0.25))
            }
            .padding(layout.value(14, 16))
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(DS.surfaceAlt)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(DS.silver.opacity(isSelected ? 0.9 : 0.08), lineWidth: isSelected ? 1.5 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: radius)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// One line of the plan, with optional detail below.
private struct PlanCard<Extra: View>: View {
    var symbol: String
    var title: String
    var detail: String
    /// Grows to the row's height when it sits beside another card.
    var fillsHeight: Bool
    @ViewBuilder var extra: () -> Extra

    @Environment(\.dsLayout) private var layout

    init(symbol: String, title: String, detail: String, fillsHeight: Bool = false,
         @ViewBuilder extra: @escaping () -> Extra = { EmptyView() }) {
        self.symbol = symbol
        self.title = title
        self.detail = detail
        self.fillsHeight = fillsHeight
        self.extra = extra
    }

    var body: some View {
        let detailSize: CGFloat = layout.value(12.5, 13.5)
        HStack(alignment: .top, spacing: layout.value(14, 16)) {
            Image(systemName: symbol)
                .font(.system(size: layout.value(15, 18), weight: .medium))
                .foregroundStyle(DS.silver)
                .frame(width: layout.value(36, 44), height: layout.value(36, 44))
                .background(RoundedRectangle(cornerRadius: layout.value(10, 12), style: .continuous).fill(DS.silver.opacity(0.07)))
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ui(layout.value(15, 17), .semibold))
                    .foregroundStyle(DS.silver)
                Text(detail)
                    .font(.ui(detailSize))
                    .cssLineHeight(detailSize, 1.4)
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                extra()
            }
            Spacer(minLength: 0)
        }
        .padding(layout.value(14, 18))
        // Nil bounds unless paired, which leaves the stacked card as it was.
        .frame(maxHeight: fillsHeight ? .infinity : nil, alignment: .top)
        .background(RoundedRectangle(cornerRadius: layout.value(18, 20), style: .continuous).fill(DS.surfaceAlt))
        .accessibilityElement(children: .combine)
    }
}

#Preview("Onboarding · 11-inch portrait") {
    OnboardingView()
        .environment(WorkoutStore())
        .environment(Purchases())
        .dsPreview(.pad11Portrait750)
}

#Preview("Onboarding · 13-inch landscape") {
    OnboardingView()
        .environment(WorkoutStore())
        .environment(Purchases())
        .dsPreview(.pad13Landscape1292)
}
