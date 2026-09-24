//
//  OnboardingView.swift
//  GymWorkout
//
//  First launch: four questions — experience, sex, goal, height and weight
//  — then the plan they add up to. The same screens edit the answers later
//  from Profile. Answers only shape suggestions (see `ProgramAdvisor`).
//

import SwiftUI

struct OnboardingView: View {
    /// Opened from Profile: starts on the first question with the saved
    /// answers, can be closed, and ends on Save.
    var isEditing = false
    var onClose: () -> Void = {}

    @Environment(WorkoutStore.self) private var store

    @State private var step: Step = .welcome
    @State private var movingForward = true
    @State private var experience: TrainingExperience?
    @State private var sex: Sex?
    @State private var goal: FitnessGoal?
    @State private var unit: WeightUnit = .kg
    @State private var heightCm: Double = 170
    @State private var weightKg: Double = 70
    /// Height and weight were set by hand, so picking a sex no longer
    /// changes their starting values.
    @State private var bodyTouched = false
    @State private var didLoad = false

    enum Step: Int, CaseIterable {
        case welcome, experience, sex, goal, body, plan

        static let questions: [Step] = [.experience, .sex, .goal, .body]
    }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                if step != .welcome {
                    topBar
                }
                ZStack {
                    page
                        .id(step)
                        .transition(.asymmetric(
                            insertion: .move(edge: movingForward ? .trailing : .leading).combined(with: .opacity),
                            removal: .move(edge: movingForward ? .leading : .trailing).combined(with: .opacity)
                        ))
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .clipped()

                footer
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.bottom, 12)
            }
        }
        .onAppear(perform: load)
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
                        .frame(height: 4)
                }
            }
            .accessibilityElement()
            .accessibilityLabel(questionNumber.map { "Question \($0) of \(Step.questions.count)" } ?? "Your plan")
        }
        .padding(.horizontal, 16)
        .padding(.top, 11)
        .padding(.bottom, 6)
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
                Text("Four quick questions · under a minute")
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.45))
            }
        case .plan:
            WideButton(title: isEditing ? "Save Changes" : "Start Training", prominent: true,
                       fontSize: 15, verticalPadding: 15, action: finish)
        default:
            WideButton(title: "Continue", prominent: canContinue, fontSize: 15, verticalPadding: 15) { advance() }
                .disabled(!canContinue)
                .opacity(canContinue ? 1 : 0.5)
        }
    }

    private var canContinue: Bool {
        switch step {
        case .experience: return experience != nil
        case .sex: return sex != nil
        case .goal: return goal != nil
        default: return true
        }
    }

    // MARK: - Pages

    @ViewBuilder
    private var page: some View {
        switch step {
        case .welcome: welcome
        case .experience: experiencePage
        case .sex: sexPage
        case .goal: goalPage
        case .body: bodyPage
        case .plan: planPage
        }
    }

    private var welcome: some View {
        VStack(alignment: .leading, spacing: 0) {
            BodyMapCanvas(side: .front, fills: Self.heroFills)
                .frame(height: 330)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    ViewportGround(inner: DS.viewportInner, outer: DS.viewportOuter,
                                   rx: 0.9, ry: 0.7, cx: 0.5, cy: 0.45)
                        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                )
                .accessibilityHidden(true)

            SectionEyebrow(text: "MUSQ")
                .padding(.top, 28)
            Text("Training that fits you")
                .font(.ui(30, .semibold))
                .tracking(-0.8)
                .foregroundStyle(DS.silver)
                .padding(.top, 8)
            Text("Tell us about your experience, goal and body, and we'll shape the muscle groups, presets and recovery estimates around you.")
                .font(.ui(15))
                .cssLineHeight(15, 1.45)
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 16)
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
            caption: "Female plans bring more lower-body days — glutes, hamstrings and quads — into the rotation. Any muscle can still be trained any day."
        ) {
            option(.female, in: $sex, symbol: "figure.stand.dress", title: "Female",
                   detail: "Lower-body focus: legs and glutes twice in each rotation.")
            option(.male, in: $sex, symbol: "figure.stand", title: "Male",
                   detail: "Push, pull and legs in turn.")
            option(.unspecified, in: $sex, symbol: "person.fill.questionmark", title: "Prefer not to say",
                   detail: "Push, pull and legs in turn.")
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

    private var bodyPage: some View {
        QuestionPage(
            eyebrow: "BODY",
            title: "Your height and weight",
            caption: "Used for estimates such as the distance and calories of a walk. Kept only on this phone."
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
            .padding(.top, 6)
        }
    }

    private var planPage: some View {
        let profile = draftProfile
        let rotation = ProgramAdvisor.rotation(for: profile)
            .map { $0.filter(PresetProvider.trainableGroups.contains) }
            .filter { !$0.isEmpty }
        let level = ProgramAdvisor.suggestedLevel(for: profile, experience: experience ?? .beginner)
        return ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                SectionEyebrow(text: "YOUR PLAN")
                Text(isEditing ? "Your updated plan" : "Here's where you start")
                    .font(.ui(26, .semibold))
                    .tracking(-0.6)
                    .foregroundStyle(DS.silver)
                    .padding(.top, 8)

                VStack(spacing: 10) {
                    PlanCard(symbol: "arrow.triangle.2.circlepath", title: "Rotation",
                             detail: ProgramAdvisor.isLowerFocused(profile)
                                ? "Lower-body focus. Train suggests the most recovered day."
                                : "Train suggests the most recovered day.") {
                        VStack(alignment: .leading, spacing: 7) {
                            ForEach(Array(rotation.enumerated()), id: \.offset) { index, day in
                                HStack(alignment: .firstTextBaseline, spacing: 10) {
                                    Text("DAY \(index + 1)")
                                        .font(.mono(9, .semibold))
                                        .trackingEm(0.08, size: 9)
                                        .foregroundStyle(DS.silver.opacity(0.4))
                                        .frame(width: 44, alignment: .leading)
                                    Text(day.map(\.title).joined(separator: " · "))
                                        .font(.ui(13.5, .semibold))
                                        .foregroundStyle(DS.silver)
                                }
                            }
                        }
                        .padding(.top, 4)
                    }

                    PlanCard(symbol: "slider.horizontal.3", title: "\(level.title.capitalized) presets",
                             detail: level == .basic
                                ? "Machines and supported positions to start. Switch to Advanced on any muscle group."
                                : "Free-weight compounds to start. Switch to Basic on any muscle group.")

                    if let profile, profile.goal == .loseWeight {
                        let walk = ProgramAdvisor.walk(for: profile, experience: experience ?? .beginner)
                        PlanCard(symbol: "figure.walk", title: "Walk \(walk.steps.formatted()) steps after each workout",
                                 detail: "\(walk.detail). Aim for \(WalkSuggestion.dailySteps.formatted())+ steps across the day.")
                    }

                    PlanCard(symbol: "clock.arrow.circlepath", title: "Recovery",
                             detail: "Estimates tuned for \((experience ?? .beginner).title.lowercased()) lifters.")
                }
                .padding(.top, 20)

                Text("Change any of this later in Profile.")
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.4))
                    .padding(.top, 14)
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
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
            SectionEyebrow(text: label, size: 9.5)
            content()
                .pickerStyle(.wheel)
                .frame(height: 170)
                .clipped()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
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
        return UserProfile(sex: sex, goal: goal, heightCm: heightCm, weightKg: weightKg)
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

    private func finish() {
        guard let experience, let profile = draftProfile else { return }
        store.experience = experience
        store.unit = unit
        store.profile = profile
        onClose()
    }
}

// MARK: - Components

/// A question: its eyebrow, title and why it's asked, then the answers.
private struct QuestionPage<Content: View>: View {
    var eyebrow: String
    var title: String
    var caption: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                SectionEyebrow(text: eyebrow)
                Text(title)
                    .font(.ui(26, .semibold))
                    .tracking(-0.6)
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
                Text(caption)
                    .font(.ui(14))
                    .cssLineHeight(14, 1.45)
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)

                VStack(spacing: 10) {
                    content()
                }
                .padding(.top, 22)
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
    }
}

/// One answer: icon, title and what choosing it does.
struct OptionCard: View {
    var symbol: String
    var title: String
    var detail: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: symbol)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(isSelected ? DS.ink : DS.silver)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(isSelected ? DS.silver : DS.silver.opacity(0.07))
                    )
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.ui(15.5, .semibold))
                        .foregroundStyle(DS.silver)
                    Text(detail)
                        .font(.ui(12.5))
                        .cssLineHeight(12.5, 1.4)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 4)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(DS.silver.opacity(isSelected ? 1 : 0.25))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(DS.surfaceAlt)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(DS.silver.opacity(isSelected ? 0.9 : 0.08), lineWidth: isSelected ? 1.5 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// One line of the plan, with optional detail below.
private struct PlanCard<Extra: View>: View {
    var symbol: String
    var title: String
    var detail: String
    @ViewBuilder var extra: () -> Extra

    init(symbol: String, title: String, detail: String,
         @ViewBuilder extra: @escaping () -> Extra = { EmptyView() }) {
        self.symbol = symbol
        self.title = title
        self.detail = detail
        self.extra = extra
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(DS.silver)
                .frame(width: 36, height: 36)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(DS.silver.opacity(0.07)))
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                Text(detail)
                    .font(.ui(12.5))
                    .cssLineHeight(12.5, 1.4)
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                extra()
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surfaceAlt))
        .accessibilityElement(children: .combine)
    }
}
