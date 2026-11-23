//
//  OnboardingView.swift
//  GymWorkout
//
//  First launch, rebuilt as a plan (2026-11-21): about you (sex, pregnancy
//  or a recent birth, age, height and weight), your week (daily activity,
//  experience, days, which days, split), your goal (goal, target weight,
//  pace), your health (pain, conditions, a safety screen) and optional body
//  fat; then a short "building your plan" pause and four result pages —
//  body, calories, macros and the week — each showing its formulas with the
//  user's own numbers (see `NutritionPlan`, `ExerciseSafety`). The same
//  pages edit the answers later from Profile. One question per page, with a
//  progress bar; pages appear only when the answers call for them.
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
    /// Editing a saved plan: its steps set the daily activity, as on Today.
    @Environment(AppleHealth.self) private var health
    /// The window on first run, or the edit sheet's own measured size.
    @Environment(\.dsLayout) private var layout

    @State private var draft = OnboardingDraft()
    @State private var step: Step = .welcome
    @State private var movingForward = true
    @State private var didLoad = false
    @State private var showsPremium = false

    enum Step: Hashable {
        case welcome
        case sex, maternity, trimester, postpartum, age, body
        case activity, experience, days, weekdays, split
        case goal, target, pace
        case joints, conditions, bloodPressure, screening, bodyFat
        case calculating
        case resultBody, resultEnergy, resultMacros, resultWeek

        static let results: [Step] = [.resultBody, .resultEnergy, .resultMacros, .resultWeek]

        var isResult: Bool { Self.results.contains(self) }
        var isQuestion: Bool { self != .welcome && self != .calculating && !isResult }
    }

    /// The pages the answers so far call for, in order.
    private var flow: [Step] {
        var steps: [Step] = isEditing ? [] : [.welcome]
        steps.append(.sex)
        if draft.asksMaternity { steps.append(.maternity) }
        if draft.isPregnant { steps.append(.trimester) }
        if draft.isPostpartum { steps.append(.postpartum) }
        steps += [.age, .body, .activity, .experience, .days, .weekdays, .split]
        if !draft.isPregnant { steps.append(.goal) }
        if draft.effectiveGoal?.hasTarget == true { steps += [.target, .pace] }
        steps += [.joints, .conditions]
        if !draft.conditionsNone && draft.conditions.contains(.highBloodPressure) { steps.append(.bloodPressure) }
        steps += [.screening, .bodyFat, .calculating]
        steps += Step.results
        return steps
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
        // A Health read that lands while the editor is open moves its
        // numbers with Today's.
        .onChange(of: health.measuredActivity) { _, measured in
            if usesMeasuredActivity { draft.measured = measured }
        }
        // ⌘[ and Esc step back, or close the editor from its first question.
        .dsBackShortcuts(back)
        // Presented here rather than through `Paywall`: closing it, bought or
        // not, is what finishes onboarding.
        .sheet(isPresented: $showsPremium, onDismiss: finish) {
            PremiumView(reason: .onboarding, profile: draft.profile)
                .environment(purchases)
        }
    }

    /// The bar, the page and the button. Full width on iPhone; a centred
    /// column on iPad, or the form pane beside the stage.
    private var form: some View {
        VStack(spacing: 0) {
            if step != .welcome && step != .calculating {
                topBar
            }
            ZStack {
                page
                    .id(step)
                    .transition(pageTransition)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .clipped()

            if step != .calculating {
                footer
                    .modifier(OnboardingColumn(compactPadding: DS.Metric.gutter))
                    .padding(.bottom, layout.value(12, 20, wide: 24))
            }
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

    private var isFirstPage: Bool { flow.first == step }

    private var topBar: some View {
        HStack(spacing: 14) {
            CircleIconButton(action: back) {
                Image(systemName: isEditing && isFirstPage ? "xmark" : "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel(isEditing && isFirstPage ? "Close" : "Back")

            if step.isResult {
                // The result pages as dots: where you are among the four.
                HStack(spacing: 5) {
                    ForEach(Step.results, id: \.self) { page in
                        Capsule()
                            .fill(DS.silver.opacity(page == step ? 0.85 : 0.15))
                            .frame(height: layout.value(4, 5))
                    }
                }
                .accessibilityElement()
                .accessibilityLabel(resultNumber.map { "Your plan, page \($0) of \(Step.results.count)" } ?? "Your plan")
            } else {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(DS.silver.opacity(0.12))
                        Capsule().fill(DS.silver.opacity(0.85))
                            .frame(width: geo.size.width * progress)
                    }
                }
                .frame(height: layout.value(4, 5))
                .accessibilityElement()
                .accessibilityLabel(questionNumber.map { "Question \($0.0) of \($0.1)" } ?? "")
            }
        }
        .modifier(OnboardingColumn(compactPadding: 16))
        .padding(.top, layout.value(11, 14))
        .padding(.bottom, layout.value(6, 10))
        .animation(.easeOut(duration: 0.25), value: step)
    }

    /// (number, of how many) among the questions the answers call for.
    private var questionNumber: (Int, Int)? {
        let questions = flow.filter(\.isQuestion)
        return questions.firstIndex(of: step).map { ($0 + 1, questions.count) }
    }

    private var resultNumber: Int? {
        Step.results.firstIndex(of: step).map { $0 + 1 }
    }

    private var progress: CGFloat {
        guard let number = questionNumber, number.1 > 0 else { return 0 }
        return CGFloat(number.0) / CGFloat(number.1)
    }

    @ViewBuilder
    private var footer: some View {
        switch step {
        case .welcome:
            VStack(spacing: 10) {
                WideButton(title: "Get Started", prominent: true, fontSize: 15, verticalPadding: 15) { advance() }
                    .modifier(OnboardingReturnKey())
                Text("Quick questions · about two minutes")
                    .font(.ui(layout.value(12, 13)))
                    .foregroundStyle(DS.silver.opacity(0.45))
            }
        case .resultWeek:
            WideButton(title: isEditing ? "Save Changes" : "Start Training", prominent: true,
                       fontSize: 15, verticalPadding: 15, action: complete)
                .modifier(OnboardingReturnKey())
        default:
            WideButton(title: "Continue", prominent: canContinue, fontSize: 15, verticalPadding: 15) { advance() }
                .disabled(!canContinue)
                .opacity(canContinue ? 1 : 0.5)
                .modifier(OnboardingReturnKey())
        }
    }

    private var canContinue: Bool {
        switch step {
        case .sex: return draft.sex != nil
        case .maternity: return draft.maternity != nil
        case .trimester: return draft.trimester != nil
        case .postpartum:
            return draft.postpartumStage != nil && draft.postpartumCleared != nil && draft.breastfeeding != nil
        case .activity: return draft.activity != nil
        case .experience: return draft.experience != nil
        case .days: return draft.daysPerWeek != nil
        case .weekdays: return draft.weekdays.count == draft.daysPerWeek
        case .split: return draft.split != nil
        case .goal: return draft.effectiveGoal != nil
        case .target: return draft.currentTarget != nil
        case .pace: return draft.currentPace != nil
        case .joints: return draft.jointsNone || !draft.joints.isEmpty
        case .conditions: return draft.conditionsNone || !draft.conditions.isEmpty
        case .bloodPressure: return draft.bloodPressureControlled != nil
        case .screening: return draft.screeningNone || !draft.screening.isEmpty
        case .resultBody, .resultEnergy, .resultMacros: return draft.plan != nil
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
    private var stageLight: OnboardingStageLight {
        if step == .split || step.isResult, let day = firstSplitDay {
            return .day(name: day.name, groups: day.groups)
        }
        return draft.sex == .female ? .lowerBody : .sampler
    }

    /// Day one of the rotation the plan page shows.
    private var firstSplitDay: ProgramAdvisor.SplitDay? {
        let days = draft.profile.map { ProgramAdvisor.days(for: $0) }
            ?? ProgramAdvisor.days(of: draft.split ?? .pushPullLegs, lowerFocus: draft.sex == .female)
        return days
            .map { ProgramAdvisor.SplitDay(name: $0.name, groups: $0.groups.filter(PresetProvider.trainableGroups.contains)) }
            .first { !$0.groups.isEmpty }
    }

    // MARK: - Pages

    @ViewBuilder
    private var page: some View {
        switch step {
        case .welcome:
            OnboardingWelcome()
        case .calculating:
            OnboardingCalculating(safetyChecked: !draft.health.joints.isEmpty || !draft.health.conditions.isEmpty) {
                // Ignored once the user has stepped back off the pause.
                if step == .calculating { advance() }
            }
        case .resultBody, .resultEnergy, .resultMacros, .resultWeek:
            if let plan = draft.plan, let profile = draft.profile {
                OnboardingResult(step: step, plan: plan, profile: profile, draft: draft, isEditing: isEditing,
                                 builtInPresetGroups: PresetProvider.trainableGroups.filter { store.savedLevels(for: $0).isEmpty })
            }
        default:
            OnboardingQuestion(step: step, draft: draft)
        }
    }

    // MARK: - Actions

    /// Editing a saved profile: the numbers follow Apple Health's steps,
    /// as Today's do, so Save shows nothing new there. A new user's own
    /// answer sets the first plan.
    private var usesMeasuredActivity: Bool { isEditing && store.profile != nil }

    private func load() {
        guard !didLoad else { return }
        didLoad = true
        draft.unit = store.unit
        if let profile = store.profile {
            draft.load(profile, experience: store.experience, unit: store.unit)
        }
        if usesMeasuredActivity { draft.measured = health.measuredActivity }
        if isEditing { step = .sex }
    }

    private func advance() {
        guard canContinue else { return }
        let steps = flow
        guard let index = steps.firstIndex(of: step), index + 1 < steps.count else { return }
        if step == .sex { draft.applySexDefaults() }
        movingForward = true
        withAnimation(.easeInOut(duration: 0.3)) { step = steps[index + 1] }
    }

    private func back() {
        if isEditing && isFirstPage { onClose(); return }
        let steps = flow
        guard let index = steps.firstIndex(of: step), index > 0 else { return }
        // The "building your plan" pause is only ever passed going forward.
        var previous = index - 1
        if steps[previous] == .calculating && previous > 0 { previous -= 1 }
        movingForward = false
        withAnimation(.easeInOut(duration: 0.3)) { step = steps[previous] }
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
        guard let experience = draft.experience, var profile = draft.profile else { return }
        // A name typed in Profile is saved there when the editor opens over
        // it: keep the one the store has now.
        profile.name = store.profile?.name
        store.experience = experience
        store.unit = draft.unit
        store.profile = profile
        onClose()
    }
}

// MARK: - Welcome

private struct OnboardingWelcome: View {
    @Environment(\.dsLayout) private var layout

    var body: some View {
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
                Text(Self.caption)
                    .font(.ui(17))
                    .cssLineHeight(17, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 480, alignment: .leading)
                    .padding(.top, 14)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .modifier(OnboardingColumn(compactPadding: DS.Metric.gutter))
        } else {
            VStack(alignment: .leading, spacing: 0) {
                BodyMapCanvas(side: .front, fills: Self.heroFills)
                    .frame(height: figureHeight)
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
                Text(Self.caption)
                    .font(.ui(layout.value(15, 16)))
                    .cssLineHeight(layout.value(15, 16), 1.45)
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 10)
            }
            .modifier(OnboardingColumn(compactPadding: DS.Metric.gutter))
            .padding(.top, layout.value(16, 24))
        }
    }

    private static let caption = String(localized: "Answer a few questions about you, your week, your goal and your health. We'll work out your calories, macros and training week, and explain every number.")

    /// 330 on iPhone; up to 440 on iPad, less in a short window, where the
    /// welcome page doesn't scroll.
    private var figureHeight: CGFloat {
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
}

// MARK: - Building the plan

/// A short pause that ticks off what the plan works out, then moves on.
private struct OnboardingCalculating: View {
    var safetyChecked: Bool
    var onDone: () -> Void

    @Environment(\.dsLayout) private var layout
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var done = 0

    private var items: [String] {
        var items = [String(localized: "Working out your metabolism (BMR)"),
                     String(localized: "Adding your daily activity (TDEE)"),
                     String(localized: "Setting your calorie target"),
                     String(localized: "Splitting protein, fat and carbs"),
                     String(localized: "Laying out your week")]
        if safetyChecked { items.append(String(localized: "Checking exercises against your health answers")) }
        return items
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProgressView()
                .controlSize(.large)
                .tint(DS.silver)
                .padding(.bottom, 24)
            SectionEyebrow(text: String(localized: "YOUR PLAN"))
            Text("Building your plan")
                .font(.ui(layout.pt(26, 32, wide: 34), .semibold))
                .tracking(layout.value(-0.6, -0.85))
                .foregroundStyle(DS.silver)
                .padding(.top, layout.value(8, 10))
            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 12) {
                        Image(systemName: index < done ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 18))
                            .foregroundStyle(DS.silver.opacity(index < done ? 1 : 0.25))
                        Text(item)
                            .font(.ui(layout.value(15, 16)))
                            .foregroundStyle(DS.silver.opacity(index < done ? 0.9 : 0.4))
                    }
                }
            }
            .padding(.top, 26)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .modifier(OnboardingColumn(compactPadding: DS.Metric.gutter))
        .task {
            let tick: UInt64 = reduceMotion ? 150_000_000 : 420_000_000
            for index in items.indices {
                try? await Task.sleep(nanoseconds: tick)
                withAnimation(.easeOut(duration: 0.2)) { done = index + 1 }
            }
            try? await Task.sleep(nanoseconds: tick)
            guard !Task.isCancelled else { return }
            onDone()
        }
    }
}

// MARK: - Stage light

/// What the wide stage's figure shows.
enum OnboardingStageLight: Hashable {
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
        case .lowerBody: return String(localized: "LOWER-BODY FOCUS")
        case .day(let name, _): return String(localized: "DAY 1 · \(name.uppercased())", comment: "The split's first day: DAY 1 · PUSH")
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

#Preview("Onboarding · 11-inch portrait") {
    OnboardingView()
        .environment(WorkoutStore())
        .environment(Purchases())
        .environment(AppleHealth())
        .dsPreview(.pad11Portrait750)
}

#Preview("Onboarding · 13-inch landscape") {
    OnboardingView()
        .environment(WorkoutStore())
        .environment(Purchases())
        .environment(AppleHealth())
        .dsPreview(.pad13Landscape1292)
}
