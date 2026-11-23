//
//  OnboardingQuestions.swift
//  GymWorkout
//
//  Onboarding's question pages (2026-11-21). Each page edits the draft;
//  `OnboardingView` decides which pages the answers call for and when the
//  Continue button is ready.
//

import SwiftUI

struct OnboardingQuestion: View {
    var step: OnboardingView.Step
    @Bindable var draft: OnboardingDraft

    @Environment(\.dsLayout) private var layout

    var body: some View {
        switch step {
        case .sex: sexPage
        case .maternity: maternityPage
        case .trimester: trimesterPage
        case .postpartum: postpartumPage
        case .age: agePage
        case .body: bodyPage
        case .activity: activityPage
        case .experience: experiencePage
        case .days: daysPage
        case .weekdays: weekdaysPage
        case .split: splitPage
        case .goal: goalPage
        case .target: targetPage
        case .pace: pacePage
        case .joints: jointsPage
        case .conditions: conditionsPage
        case .bloodPressure: bloodPressurePage
        case .screening: screeningPage
        case .bodyFat: bodyFatPage
        default: EmptyView()
        }
    }

    // MARK: - About you

    private var sexPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "ABOUT YOU"),
            title: String(localized: "What's your sex?"),
            caption: String(localized: "The calorie formula differs for men and women. Female plans also bring more lower-body work — glutes, hamstrings and quads — into your split.")
        ) {
            option(.female, in: $draft.sex, symbol: "figure.stand.dress", title: "Female",
                   detail: "Lower-body focus: legs and glutes twice in each rotation.")
            option(.male, in: $draft.sex, symbol: "figure.stand", title: "Male",
                   detail: "An even split of upper and lower body.")
            option(.unspecified, in: $draft.sex, symbol: "person.fill.questionmark", title: "Prefer not to say",
                   detail: "An even split. Calories use the average of the men's and women's formulas.")
        }
    }

    private var maternityPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "ABOUT YOU"),
            title: String(localized: "Are you pregnant, or did you give birth in the last year?"),
            caption: AIService.isLive
                ? String(localized: "Both change how much to eat and which exercises suit you. Your answers are kept on this \(DS.deviceNoun), and sent only if you turn them on for the AI coach.")
                : DS.isPad
                ? String(localized: "Both change how much to eat and which exercises suit you. Your answers stay on this iPad.")
                : String(localized: "Both change how much to eat and which exercises suit you. Your answers stay on this phone.")
        ) {
            option(.no, in: $draft.maternity, symbol: "person", title: "No", detail: nil)
            option(.pregnant, in: $draft.maternity, symbol: "figure.stand.dress", title: "I'm pregnant",
                   detail: "No calorie deficit, safer exercises, and a reminder to get your doctor's or midwife's OK.")
            option(.postpartum, in: $draft.maternity, symbol: "figure.and.child.holdinghands",
                   title: "I gave birth in the last 12 months",
                   detail: "A gentler restart that allows for breastfeeding.")
        }
    }

    private var trimesterPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "PREGNANCY"),
            title: String(localized: "How far along are you?"),
            caption: String(localized: "From the second trimester, exercises lying flat on your back or front are swapped for seated and inclined ones, and your calories go up.")
        ) {
            option(1, in: $draft.trimester, symbol: "1.circle", title: "First trimester",
                   detail: "Weeks 1–13. Calories as before.")
            option(2, in: $draft.trimester, symbol: "2.circle", title: "Second trimester",
                   detail: "Weeks 14–27. About 340 kcal more a day.")
            option(3, in: $draft.trimester, symbol: "3.circle", title: "Third trimester",
                   detail: "Week 28 on. About 450 kcal more a day.")
        }
    }

    private var postpartumPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "AFTER THE BIRTH"),
            title: String(localized: "Tell us about the birth"),
            caption: String(localized: "Your body needs time to recover, especially your deep core and pelvic floor. These answers set how gently the plan starts.")
        ) {
            VStack(alignment: .leading, spacing: layout.value(20, 24)) {
                ChoiceRow(label: String(localized: "HOW LONG AGO?"),
                          options: PostpartumStage.allCases.map { ($0, $0.title) },
                          selection: $draft.postpartumStage)
                ChoiceRow(label: String(localized: "HAS A DOCTOR OR MIDWIFE CLEARED YOU TO EXERCISE?"),
                          options: [(true, String(localized: "Yes")), (false, String(localized: "Not yet"))],
                          selection: $draft.postpartumCleared)
                ChoiceRow(label: String(localized: "ARE YOU BREASTFEEDING?"),
                          options: [(true, String(localized: "Yes")), (false, String(localized: "No"))],
                          selection: $draft.breastfeeding)
            }
        }
    }

    private var agePage: some View {
        let years = Array((OnboardingDraft.currentYear - 90)...(OnboardingDraft.currentYear - 14))
        return OnboardingQuestionPage(
            eyebrow: String(localized: "ABOUT YOU"),
            title: String(localized: "What year were you born?"),
            caption: String(localized: "Metabolism slows a little with each decade, so age goes into your calorie estimate.")
        ) {
            WheelBox(label: String(localized: "YEAR")) {
                Picker("Year", selection: $draft.birthYear) {
                    ForEach(years, id: \.self) { Text(verbatim: "\($0)").tag($0) }
                }
            }
            .frame(maxWidth: layout.isRegular ? 440 : nil)
            Text("You're \(draft.age).", comment: "Age from the birth year: You're 30.")
                .font(.ui(layout.value(14, 15), .semibold))
                .foregroundStyle(DS.silver.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
        }
    }

    private var bodyPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "BODY", comment: "Height and weight"),
            title: String(localized: "Your height and weight"),
            caption: AIService.isLive
                ? String(localized: "Used for your calories, protein and BMI. Kept on this \(DS.deviceNoun), and shared only with the AI coach if you ask it something.")
                : DS.isPad
                ? String(localized: "Used for your calories, protein and BMI. Kept only on this iPad.")
                : String(localized: "Used for your calories, protein and BMI. Kept only on this phone.")
        ) {
            MonoSegmentedControl(
                options: [(WeightUnit.kg, "KG · CM"), (.lb, "LB · FT")],
                selection: $draft.unit,
                fontSize: 10,
                itemPaddingV: 8,
                fillsWidth: true
            )

            HStack(spacing: 10) {
                WheelBox(label: String(localized: "HEIGHT")) {
                    if draft.unit == .kg {
                        Picker("Height", selection: heightInCentimetres) {
                            ForEach(130...220, id: \.self) { Text("\($0) cm").tag($0) }
                        }
                    } else {
                        Picker("Height", selection: heightInInches) {
                            ForEach(51...87, id: \.self) { Text("\($0 / 12)′ \($0 % 12)″").tag($0) }
                        }
                    }
                }
                WheelBox(label: String(localized: "WEIGHT")) {
                    Picker("Weight", selection: weightInUnit) {
                        ForEach(draft.unit == .kg ? Array(30...200) : Array(66...440), id: \.self) {
                            Text("\($0) \(draft.unit.symbol)").tag($0)
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

    // MARK: - Your week

    private var activityPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "LIFESTYLE"),
            title: String(localized: "Outside workouts, how active is your day?"),
            caption: String(localized: "With your training days, this sets the activity factor in your calorie estimate.")
        ) {
            ForEach(DailyActivity.allCases) { activity in
                OptionCard(symbol: Self.symbol(activity), title: activity.title, detail: activity.detail,
                           isSelected: draft.activity == activity) {
                    withAnimation(.easeOut(duration: 0.15)) { draft.activity = activity }
                }
            }
        }
    }

    private static func symbol(_ activity: DailyActivity) -> String {
        switch activity {
        case .sitting: return "chair"
        case .onFeet: return "figure.walk"
        case .physical: return "hammer"
        }
    }

    private var experiencePage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "EXPERIENCE", comment: "Training experience"),
            title: String(localized: "How long have you been training?"),
            caption: String(localized: "Sets how long recovery estimates run, which presets you start on, and how fast muscle can come.")
        ) {
            option(.beginner, in: $draft.experience, symbol: "leaf",
                   title: "Just starting", detail: "New to the gym, or back after a long break.")
            option(.intermediate, in: $draft.experience, symbol: "figure.walk",
                   title: "Less than a year", detail: "I know the basics and train now and then.")
            option(.advanced, in: $draft.experience, symbol: "flame",
                   title: "A year or more", detail: "I train regularly and know the main lifts.")
        }
    }

    private var daysPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "SCHEDULE", comment: "Training days a week"),
            title: String(localized: "How many days a week can you train?"),
            caption: draft.experience == .beginner
                ? String(localized: "Three or four days are plenty to start: each muscle still trains about twice a week.")
                : String(localized: "Sets how your week is split. Train suggests the most recovered day each time, so a missed day never breaks the plan.",
                         comment: "Train is the tab")
        ) {
            ForEach(ProgramAdvisor.daysPerWeekOptions, id: \.self) { days in
                let suggested = ProgramAdvisor.recommendedSplit(daysPerWeek: days)
                OptionCard(symbol: "calendar",
                           title: String(localized: "\(days) days a week", comment: "Training days a week, 2 to 6"),
                           detail: String(localized: "\(suggested.title) · every muscle \(frequency(suggested, days)).",
                                          comment: "The split that suits the days (Front / Back), then how often each muscle comes round: about 2× a week"),
                           isSelected: draft.daysPerWeek == days) {
                    withAnimation(.easeOut(duration: 0.15)) { draft.setDays(days) }
                }
            }
        }
    }

    private var weekdaysPage: some View {
        let days = draft.daysPerWeek ?? 3
        let calendar = Calendar.current
        let order = (0..<7).map { (calendar.firstWeekday - 1 + $0) % 7 + 1 }
        let symbols = calendar.shortWeekdaySymbols
        let picked = draft.weekdays.count
        let split = draft.split ?? ProgramAdvisor.recommendedSplit(daysPerWeek: days)
        let rotation = ProgramAdvisor.days(of: split, lowerFocus: draft.sex == .female)
            .map { ProgramAdvisor.SplitDay(name: $0.name, groups: $0.groups.filter(PresetProvider.trainableGroups.contains)) }
            .filter { !$0.groups.isEmpty }
        let week = ProgramAdvisor.week(weekdays: Array(draft.weekdays), days: rotation)
        return OnboardingQuestionPage(
            eyebrow: String(localized: "SCHEDULE", comment: "Training days a week"),
            title: String(localized: "Which days suit you?"),
            caption: String(localized: "Pick \(days) days. Spacing them out gives each muscle time to recover; Train still suggests the most recovered day whenever you come in.",
                            comment: "The days to pick, 2 to 6. Train is the tab")
        ) {
            HStack(spacing: layout.value(6, 10)) {
                ForEach(order, id: \.self) { weekday in
                    let isOn = draft.weekdays.contains(weekday)
                    Button {
                        withAnimation(.easeOut(duration: 0.15)) {
                            if isOn { draft.weekdays.remove(weekday) } else if picked < days { draft.weekdays.insert(weekday) }
                        }
                    } label: {
                        Text(symbols[weekday - 1])
                            .font(.ui(layout.value(12.5, 14), .semibold))
                            .foregroundStyle(isOn ? DS.ink : DS.silver)
                            .frame(maxWidth: .infinity)
                            .frame(height: layout.value(46, 54))
                            .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(isOn ? DS.silver : DS.surfaceAlt))
                            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(DS.silver.opacity(isOn ? 0 : 0.08), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(calendar.weekdaySymbols[weekday - 1])
                    .accessibilityAddTraits(isOn ? .isSelected : [])
                }
            }
            Text(picked == days
                 ? String(localized: "\(days) days picked.", comment: "All the training days are picked: 3 days picked.")
                 : String(localized: "\(picked) of \(days) picked.", comment: "Training days picked so far: 2 of 3 picked."))
                .font(.ui(layout.value(12.5, 13.5)))
                .foregroundStyle(DS.silver.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)

            if picked == days {
                ResultCard(symbol: "calendar", title: String(localized: "Your week")) {
                    VStack(alignment: .leading, spacing: layout.value(7, 9)) {
                        ForEach(Array(week.filter { $0.day != nil }.enumerated()), id: \.offset) { _, entry in
                            HStack(alignment: .firstTextBaseline, spacing: 10) {
                                Text(symbols[entry.weekday - 1].uppercased())
                                    .font(.mono(layout.value(9, 10), .semibold))
                                    .trackingEm(0.08, size: layout.value(9, 10))
                                    .foregroundStyle(DS.silver.opacity(0.4))
                                    .frame(width: layout.value(40, 48), alignment: .leading)
                                Text(entry.day?.name ?? "")
                                    .font(.ui(layout.value(13.5, 15), .semibold))
                                    .foregroundStyle(DS.silver)
                            }
                        }
                    }
                    .padding(.top, 4)
                }
            }
        }
    }

    private var splitPage: some View {
        let days = draft.daysPerWeek ?? 3
        let suggested = ProgramAdvisor.recommendedSplit(daysPerWeek: days)
        return OnboardingQuestionPage(
            eyebrow: String(localized: "SPLIT", comment: "The training split: how the week's sessions divide the body"),
            title: String(localized: "How do you want to split your week?"),
            caption: String(localized: "\(suggested.title) suits \(days) days a week best: \(ProgramAdvisor.recommendationReason(daysPerWeek: days))",
                            comment: "The split (Front / Back), the days a week, then why it fits")
        ) {
            ForEach(TrainingSplit.allCases) { option in
                OptionCard(symbol: Self.symbol(option), title: option.title,
                           detail: String(localized: "\(Self.summary(option)) Every muscle \(frequency(option, days)).",
                                          comment: "The split's days in a sentence, then how often each muscle comes round: about 2× a week"),
                           badge: option == suggested ? String(localized: "BEST FIT", comment: "Tag on the split that suits the days a week best") : nil,
                           isSelected: draft.split == option) {
                    withAnimation(.easeOut(duration: 0.15)) { draft.split = option }
                }
            }
        }
    }

    static func symbol(_ split: TrainingSplit) -> String {
        switch split {
        case .upperLower: return "arrow.up.arrow.down"
        case .frontBack: return "arrow.left.arrow.right"
        case .pushPullLegs: return "arrow.triangle.2.circlepath"
        }
    }

    private static func summary(_ split: TrainingSplit) -> String {
        switch split {
        case .upperLower: return String(localized: "Upper body one day, lower body the next.")
        case .frontBack: return String(localized: "Chest, shoulders, quads and biceps one day; back, hamstrings, glutes and triceps the next.")
        case .pushPullLegs: return String(localized: "Chest, shoulders and triceps; then back and biceps; then legs.")
        }
    }

    private func frequency(_ split: TrainingSplit, _ days: Int) -> String {
        ProgramAdvisor.frequencyText(ProgramAdvisor.timesPerWeek(split, lowerFocus: draft.sex == .female, daysPerWeek: days))
    }

    // MARK: - Goal

    private var goalPage: some View {
        let options = draft.goalOptions
        let limited = !options.contains(.loseWeight)
        return OnboardingQuestionPage(
            eyebrow: String(localized: "GOAL", comment: "The fitness goal"),
            title: String(localized: "What's your main goal?"),
            caption: limited
                ? String(localized: "Under 18, or with a BMI under 18.5, the plan doesn't cut calories: build muscle, or eat what you burn.")
                : String(localized: "Sets your calories: a deficit to lose fat, a small surplus to build muscle, or what you burn to stay where you are.")
        ) {
            ForEach(options) { goal in
                OptionCard(symbol: Self.symbol(goal), title: goal.title, detail: Self.detail(goal),
                           isSelected: draft.goal == goal) {
                    withAnimation(.easeOut(duration: 0.15)) { draft.goal = goal }
                }
            }
        }
    }

    static func symbol(_ goal: FitnessGoal) -> String {
        switch goal {
        case .loseWeight: return "flame"
        case .buildMuscle: return "dumbbell"
        case .recomp: return "arrow.triangle.2.circlepath"
        case .getFit: return "heart"
        }
    }

    private static func detail(_ goal: FitnessGoal) -> String {
        switch goal {
        case .loseWeight: return String(localized: "Eat a little less than you burn, with high protein to keep your muscle.")
        case .buildMuscle: return String(localized: "A small calorie surplus, so most of what you gain is muscle.")
        case .recomp: return String(localized: "Lose fat and build muscle at about the same weight. Best for beginners, or after a break.")
        case .getFit: return String(localized: "Eat what you burn and train for strength and health.")
        }
    }

    private var targetPage: some View {
        let goal = draft.effectiveGoal ?? .loseWeight
        let unit = draft.unit
        // The wheel's values come from the draft, so the wheel, the line
        // under it, the plan and the saved target are one number.
        let bounds = draft.targetBounds ?? 0...0
        let suggested = draft.suggestedTargetValue
        let current = draft.currentTargetValue
        let metres = draft.heightCm / 100
        let healthyLow = Int(unit.fromKilograms(18.5 * metres * metres).rounded())
        let healthyHigh = Int(unit.fromKilograms(24.9 * metres * metres).rounded())
        let healthy = "\(healthyLow)–\(healthyHigh)\u{00A0}\(unit.symbol)"
        return OnboardingQuestionPage(
            eyebrow: String(localized: "GOAL", comment: "The fitness goal"),
            title: String(localized: "What's your target weight?"),
            caption: goal == .buildMuscle
                ? String(localized: "We suggest about 5% more than now: a realistic first block of muscle. You can always go on from there.")
                : draft.bmi >= 25
                    ? String(localized: "We suggest the top of the healthy range for your height, or 10% less than now if that's closer: a good first milestone.")
                    : String(localized: "We suggest about 5% less than now. The target can't go under a BMI of 18.5.")
        ) {
            WheelBox(label: String(localized: "TARGET")) {
                Picker("Target weight", selection: targetInUnit(clampedTo: bounds)) {
                    ForEach(bounds, id: \.self) { Text("\($0) \(unit.symbol)").tag($0) }
                }
            }
            .frame(maxWidth: layout.isRegular ? 440 : nil)

            VStack(alignment: .leading, spacing: 6) {
                if let target = draft.currentTarget {
                    let change = target - draft.weightKg
                    Text(change < 0
                         ? String(localized: "That's \(weightText(-change)) to lose.", comment: "The weight to lose: 8 kg")
                         : String(localized: "That's \(weightText(change)) to gain.", comment: "The weight to gain: 4 kg"))
                        .font(.ui(layout.value(14, 15), .semibold))
                        .foregroundStyle(DS.silver.opacity(0.8))
                }
                // Adult BMI bands don't apply under 18.
                if draft.age >= 18 {
                    Text("Healthy weight for your height: \(healthy) (BMI 18.5–24.9).",
                         comment: "The weight range at BMI 18.5-24.9 for the user's height: 57–76 kg")
                        .font(.ui(layout.value(12.5, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .fixedSize(horizontal: false, vertical: true)
                }
                if let suggested, let current, suggested != current {
                    Button {
                        withAnimation(.easeOut(duration: 0.15)) { draft.targetWeightKg = nil }
                    } label: {
                        Text("Use the suggestion: \(suggested)\u{00A0}\(unit.symbol)",
                             comment: "Button: go back to the suggested target, 76 kg")
                            .font(.ui(layout.value(13, 14), .semibold))
                            .foregroundStyle(DS.silver)
                            .underline()
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
        }
    }

    private var pacePage: some View {
        let goal = draft.effectiveGoal ?? .loseWeight
        let recommended = NutritionPlan.recommendedPace(goal: goal, experience: draft.experience)
        let plan = draft.plan
        return OnboardingQuestionPage(
            eyebrow: String(localized: "PACE"),
            title: String(localized: "How fast do you want to go?"),
            caption: goal == .buildMuscle
                ? String(localized: "Gaining 0.25–0.5% of your weight a week keeps the extra fat small. The longer you've trained, the slower muscle comes.")
                : String(localized: "Losing 0.5–1% of your weight a week keeps most of your muscle. Slower is easier to stick with.")
        ) {
            ForEach(draft.paceOptions) { pace in
                OptionCard(symbol: Self.symbol(pace, goal: goal), title: Self.title(pace, goal: goal),
                           detail: plan.map { paceDetail($0.withPace(pace)) },
                           badge: pace == recommended ? String(localized: "RECOMMENDED", comment: "Tag on the pace the plan suggests") : nil,
                           isSelected: draft.currentPace == pace) {
                    withAnimation(.easeOut(duration: 0.15)) { draft.pace = pace }
                }
            }
        }
    }

    private static func symbol(_ pace: GoalPace, goal: FitnessGoal) -> String {
        switch pace {
        case .slow: return "tortoise"
        case .steady: return "figure.walk"
        case .fast: return "hare"
        }
    }

    static func title(_ pace: GoalPace, goal: FitnessGoal) -> String {
        switch (goal, pace) {
        case (.buildMuscle, .slow): return String(localized: "Lean · 0.25% a week", comment: "Pace for gaining weight")
        case (.buildMuscle, _): return String(localized: "Standard · 0.5% a week", comment: "Pace for gaining weight")
        case (_, .slow): return String(localized: "Gentle · 0.5% a week", comment: "Pace for losing weight")
        case (_, .steady): return String(localized: "Steady · 0.75% a week", comment: "Pace for losing weight")
        case (_, .fast): return String(localized: "Faster · 1% a week", comment: "Pace for losing weight")
        }
    }

    /// "−0.6 kg a week · 2,050 kcal a day · 72 kg by 28 Feb 2027".
    private func paceDetail(_ plan: NutritionPlan) -> String {
        let calories = Int(plan.calories).formatted()
        let perWeek = draft.unit.fromKilograms(abs(plan.weeklyChangeKg))
            .formatted(.number.precision(.fractionLength(1)))
        let sign = plan.weeklyChangeKg < 0 ? "−" : "+"
        guard let date = plan.targetDate(), let target = plan.targetWeightKg else {
            return String(localized: "\(calories) kcal a day", comment: "A pace's calories when no date can be given")
        }
        let detail = String(localized: "\(sign)\(perWeek) \(draft.unit.symbol) a week · \(calories) kcal a day · \(weightText(target)) by \(date.formatted(.dateTime.day().month(.abbreviated).year()))",
                            comment: "A pace: the weekly change (−0.6 kg), the day's calories, the target and the date it's reached")
        // Say why a faster pace doesn't go faster: the one cap that binds.
        for limit in plan.limits {
            switch limit {
            case .floor:
                return detail + "\n" + String(localized: "Held at the lowest calories we suggest.")
            case .deficitCap:
                return detail + "\n" + String(localized: "Capped at 25% under what you burn.")
            case .breastfeedingCap:
                let cap = draft.unit.format(0.5)
                return detail + "\n" + String(localized: "Capped at \(cap) a week while breastfeeding.",
                                                comment: "The breastfeeding cap: 0.5 kg (1.1 lb) a week")
            default:
                continue
            }
        }
        return detail
    }

    // MARK: - Health

    private var jointsPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "HEALTH"),
            title: String(localized: "Any pain or injuries?"),
            caption: String(localized: "We'll leave out exercises that tend to aggravate them and lean on kinder ones. This isn't a diagnosis: see a doctor about pain that's severe, new or getting worse.")
        ) {
            ForEach(JointIssue.allCases) { joint in
                OptionCard(symbol: joint.symbol, title: joint.title, detail: Self.detail(joint),
                           isSelected: draft.joints.contains(joint) && !draft.jointsNone, multi: true) {
                    withAnimation(.easeOut(duration: 0.15)) { draft.toggle(joint) }
                }
            }
            noneCard(String(localized: "No pain or injuries"), isSelected: draft.jointsNone) {
                draft.jointsNone = true
                draft.joints = []
            }
        }
    }

    private static func detail(_ joint: JointIssue) -> String {
        switch joint {
        case .knee: return String(localized: "No jumping, deep single-leg squats or forward lunges.")
        case .lowerBack: return String(localized: "No heavy barbell hinges, bent-over rows or sit-ups.")
        case .shoulder: return String(localized: "No overhead pressing, dips or upright rows.")
        case .wristElbow: return String(localized: "No wrist curls, skull crushers, or diamond, archer or clap push-ups.")
        }
    }

    private var conditionsPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "HEALTH"),
            title: String(localized: "Any of these health conditions?"),
            caption: String(localized: "They change your calories, protein or exercise choices — never which muscles you can train.")
        ) {
            ForEach(HealthCondition.listed) { condition in
                OptionCard(symbol: condition.symbol, title: condition.title, detail: Self.detail(condition),
                           isSelected: draft.conditions.contains(condition) && !draft.conditionsNone, multi: true) {
                    withAnimation(.easeOut(duration: 0.15)) { draft.toggle(condition) }
                }
            }
            noneCard(String(localized: "None of these"), isSelected: draft.conditionsNone) {
                draft.conditionsNone = true
                draft.conditions = []
            }
        }
    }

    private static func detail(_ condition: HealthCondition) -> String? {
        switch condition {
        case .highBloodPressure: return String(localized: "No breath-holding or maximal lifts; every set 10 reps or more.")
        case .heartDisease: return String(localized: "We'll ask you to check with your doctor first, and keep the effort moderate.")
        case .diabetes: return String(localized: "Exercises stay the same, with tips for training safely with your blood sugar.")
        case .kidneyDisease: return String(localized: "Protein stays at the general 0.8 g per kg; ask your doctor what suits you.")
        case .osteoporosis: return String(localized: "No loaded bending or twisting of the spine, and no jumping.")
        case .pregnancy, .postpartum: return nil
        }
    }

    private var bloodPressurePage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "HEALTH"),
            title: String(localized: "Is your blood pressure under control?"),
            caption: String(localized: "With or without medicine. If it's 160/100 or higher, or you're not sure, see a doctor before lifting weights.")
        ) {
            option(true, in: $draft.bloodPressureControlled, symbol: "checkmark.circle",
                   title: "Yes, it stays below 160/100", detail: nil)
            option(false, in: $draft.bloodPressureControlled, symbol: "questionmark.circle",
                   title: "No, or I'm not sure", detail: nil)
        }
    }

    private var screeningPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "SAFETY"),
            title: String(localized: "Before you start"),
            caption: String(localized: "Three quick safety questions, after the PAR-Q+. Tick any that apply to you.")
        ) {
            ForEach(ScreeningFlag.allCases) { flag in
                OptionCard(symbol: nil, title: flag.title, detail: nil,
                           isSelected: draft.screening.contains(flag) && !draft.screeningNone, multi: true) {
                    withAnimation(.easeOut(duration: 0.15)) { draft.toggle(flag) }
                }
            }
            noneCard(String(localized: "None of these apply to me"), isSelected: draft.screeningNone) {
                draft.screeningNone = true
                draft.screening = []
            }
        }
    }

    // MARK: - Body fat

    private var bodyFatPage: some View {
        OnboardingQuestionPage(
            eyebrow: String(localized: "BODY FAT"),
            title: String(localized: "Do you know your body fat?"),
            caption: String(localized: "Optional. Without it we estimate it from your BMI — roughly (±4–5%), and on the high side if you're muscular.")
        ) {
            OptionCard(symbol: "wand.and.stars", title: String(localized: "Skip — estimate it for me"), detail: nil,
                       isSelected: draft.bodyFatMode == .skip) {
                withAnimation(.easeOut(duration: 0.15)) { draft.bodyFatMode = .skip }
            }
            OptionCard(symbol: "percent", title: String(localized: "I know my body fat %"),
                       detail: String(localized: "From a smart scale or a body scan."),
                       isSelected: draft.bodyFatMode == .known) {
                withAnimation(.easeOut(duration: 0.15)) { draft.bodyFatMode = .known }
            }
            if draft.bodyFatMode == .known {
                WheelBox(label: String(localized: "BODY FAT")) {
                    Picker("Body fat", selection: bodyFatBinding) {
                        ForEach(4...50, id: \.self) { Text(verbatim: "\($0)%").tag($0) }
                    }
                }
                .frame(maxWidth: layout.isRegular ? 440 : nil)
            }
            OptionCard(symbol: "ruler", title: String(localized: "Measure with a tape"),
                       detail: draft.sex == .female
                        ? String(localized: "Waist at the navel, neck just below the voice box, hips at the widest.")
                        : String(localized: "Waist at the navel, neck just below the voice box."),
                       isSelected: draft.bodyFatMode == .tape) {
                withAnimation(.easeOut(duration: 0.15)) { draft.bodyFatMode = .tape }
            }
            if draft.bodyFatMode == .tape {
                HStack(spacing: 10) {
                    WheelBox(label: String(localized: "WAIST")) {
                        tapePicker("Waist", value: $draft.waistCm, centimetres: 50...160)
                    }
                    WheelBox(label: String(localized: "NECK")) {
                        tapePicker("Neck", value: $draft.neckCm, centimetres: 25...60)
                    }
                    if draft.sex == .female {
                        WheelBox(label: String(localized: "HIPS")) {
                            tapePicker("Hips", value: $draft.hipCm, centimetres: 60...170)
                        }
                    }
                }
                if draft.sex == .unspecified {
                    Text("The tape formula needs men's or women's measurements, so we'll keep the BMI estimate and use your waist for the waist-to-height ratio.")
                        .font(.ui(layout.value(12.5, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private func tapePicker(_ label: LocalizedStringKey, value: Binding<Double>, centimetres: ClosedRange<Int>) -> some View {
        let inches = draft.unit == .lb
        let range = inches ? Int((Double(centimetres.lowerBound) / 2.54).rounded(.up))...Int((Double(centimetres.upperBound) / 2.54).rounded(.down))
                           : centimetres
        let binding = Binding<Int>(
            get: { Int((inches ? value.wrappedValue / 2.54 : value.wrappedValue).rounded()) },
            set: { value.wrappedValue = inches ? Double($0) * 2.54 : Double($0) }
        )
        return Picker(label, selection: binding) {
            ForEach(range, id: \.self) { Text(verbatim: inches ? "\($0) in" : "\($0) cm").tag($0) }
        }
    }

    // MARK: - Pieces

    private func option<Value: Hashable>(_ value: Value, in selection: Binding<Value?>, symbol: String,
                                         title: String.LocalizationValue, detail: String.LocalizationValue?) -> some View {
        OptionCard(symbol: symbol, title: String(localized: title), detail: detail.map { String(localized: $0) },
                   isSelected: selection.wrappedValue == value) {
            withAnimation(.easeOut(duration: 0.15)) { selection.wrappedValue = value }
        }
    }

    /// The "none of these" answer that clears a multi-choice page.
    private func noneCard(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        OptionCard(symbol: "checkmark.seal", title: title, detail: nil, isSelected: isSelected, multi: true) {
            withAnimation(.easeOut(duration: 0.15)) { action() }
        }
    }

    /// "71 kg", the space unbreakable.
    private func weightText(_ kg: Double) -> String {
        "\(Int(draft.unit.fromKilograms(kg).rounded()))\u{00A0}\(draft.unit.symbol)"
    }

    // MARK: - Bindings

    private var heightInCentimetres: Binding<Int> {
        Binding(get: { Int(draft.heightCm.rounded()) },
                set: { draft.heightCm = Double($0); draft.bodyTouched = true })
    }

    private var heightInInches: Binding<Int> {
        Binding(get: { Int((draft.heightCm / 2.54).rounded()) },
                set: { draft.heightCm = Double($0) * 2.54; draft.bodyTouched = true })
    }

    private var weightInUnit: Binding<Int> {
        Binding(get: { Int(draft.unit.fromKilograms(draft.weightKg).rounded()) },
                set: { draft.weightKg = draft.unit.toKilograms(Double($0)); draft.bodyTouched = true })
    }

    /// The wheel shows the draft's current target; picking a row writes it
    /// back in kilograms.
    private func targetInUnit(clampedTo range: ClosedRange<Int>) -> Binding<Int> {
        Binding(get: { min(max(draft.currentTargetValue ?? range.lowerBound, range.lowerBound), range.upperBound) },
                set: { draft.targetWeightKg = draft.unit.toKilograms(Double($0)) })
    }

    private var bodyFatBinding: Binding<Int> {
        Binding(get: { Int(draft.bodyFatPercent.rounded()) },
                set: { draft.bodyFatPercent = Double($0) })
    }
}
