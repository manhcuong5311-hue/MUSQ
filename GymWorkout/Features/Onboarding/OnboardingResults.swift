//
//  OnboardingResults.swift
//  GymWorkout
//
//  Onboarding's four result pages (2026-11-21): the body (goal, BMI, body
//  fat), the calories (BMR → TDEE → target, and the road to the target
//  weight), the macros, and the week (calendar, split, presets, cardio and
//  what the health answers changed). Each page ends with "How it's
//  calculated": every formula with the user's own numbers, and its sources
//  (see `NutritionPlan` and `ExerciseSafety`).
//

import Charts
import SwiftUI

struct OnboardingResult: View {
    var step: OnboardingView.Step
    var plan: NutritionPlan
    var profile: UserProfile
    var draft: OnboardingDraft
    var isEditing: Bool
    /// The body page's title when the pages are reopened from Today.
    var bodyTitle: String? = nil
    /// Groups that open on a built-in preset; the user's own presets are
    /// never swapped, so their groups aren't listed among the swaps.
    var builtInPresetGroups: [MuscleGroup] = PresetProvider.trainableGroups

    @Environment(\.dsLayout) private var layout

    var body: some View {
        switch step {
        case .resultBody: bodyPage
        case .resultEnergy: energyPage
        case .resultMacros: macrosPage
        default: weekPage
        }
    }

    private var unit: WeightUnit { draft.unit }

    // MARK: - Body

    private var bodyPage: some View {
        OnboardingResultPage(
            eyebrow: String(localized: "YOUR PLAN · BODY"),
            title: bodyTitle ?? (isEditing ? String(localized: "Your updated plan") : String(localized: "Here's where you start"))
        ) {
            let reasons = plan.health.clearanceReasons
            if !reasons.isEmpty {
                NoticeCard(title: String(localized: "Check with your doctor before you start"),
                           lines: reasons.map(\.text)
                            + [String(localized: "The plan below starts gently. It's general guidance, not medical advice.")])
            }
            if plan.limits.contains(.pregnancy) {
                NoticeCard(symbol: "info.circle", title: String(localized: "Your goal waits until after the birth"),
                           lines: [String(localized: "During pregnancy the plan doesn't cut calories: it follows Stay fit and adds energy for your trimester.")])
            }

            goalCard

            ResultCard(symbol: "figure.stand",
                       title: bmiTitle,
                       detail: bmiDetail) {
                if plan.bmiClass != nil {
                    BMIScale(bmi: plan.bmi)
                        .padding(.top, 10)
                }
            }

            if let bodyFat = plan.bodyFat {
                ResultCard(symbol: "percent",
                           title: String(localized: "Body fat about \(Int(bodyFat.percent.rounded()))%",
                                         comment: "Estimated body fat: about 22%"),
                           detail: bodyFatDetail(bodyFat))
            }

            if let ratio = plan.waistToHeight {
                ResultCard(symbol: "ruler",
                           title: String(localized: "Waist-to-height \(ratio.formatted(.number.precision(.fractionLength(2))))",
                                         comment: "Waist ÷ height: 0.51"),
                           detail: ratio < 0.5 ? String(localized: "Under 0.5: a healthy waist for your height.")
                                : ratio < 0.6 ? String(localized: "0.5–0.59: raised health risk. Keeping your waist under half your height is a good aim.")
                                : String(localized: "0.6 or more: high health risk. Bringing the waist down matters more than the scale."))
            }

            FormulaCard(lines: bodyFormulas,
                        sources: String(localized: "Sources: WHO (2000) BMI classes; WHO Expert Consultation, Lancet 2004 (Asian cut-offs); Deurenberg et al., Br J Nutr 1991; Hodgdon & Beckett, US Navy 1984; NICE 2022 (waist-to-height)."))
        }
    }

    @ViewBuilder
    private var goalCard: some View {
        let weight = plan.weightKg
        switch plan.effectiveGoal {
        case .loseWeight, .buildMuscle:
            let target = plan.targetWeightKg ?? weight
            let change = abs(target - weight)
            let losing = plan.effectiveGoal == .loseWeight
            ResultCard(symbol: OnboardingQuestion.symbol(plan.effectiveGoal),
                       title: losing
                        ? String(localized: "Lose \(kg(change)): \(kg(weight)) → \(kg(target))",
                                 comment: "The goal: Lose 8 kg: 80 kg → 72 kg")
                        : String(localized: "Gain \(kg(change)): \(kg(weight)) → \(kg(target))",
                                 comment: "The goal: Gain 4 kg: 70 kg → 74 kg"),
                       detail: timelineText)
        case .recomp:
            ResultCard(symbol: OnboardingQuestion.symbol(.recomp),
                       title: String(localized: "Recomp at \(kg(weight))", comment: "The goal: Recomp at 70 kg"),
                       detail: String(localized: "Keep your weight about the same while you lose fat and build muscle. Check your waist and photos again in 8–12 weeks; the scale won't show it."))
        case .getFit:
            ResultCard(symbol: OnboardingQuestion.symbol(.getFit),
                       title: plan.health.isPregnant ? String(localized: "A healthy, active pregnancy")
                                                     : String(localized: "Stay fit at \(kg(weight))", comment: "The goal: Stay fit at 70 kg"),
                       detail: plan.health.isPregnant
                        ? String(localized: "Stay active with your doctor's or midwife's OK; how much weight to gain is theirs to follow.")
                        : String(localized: "Eat what you burn and train for strength and health."))
        }
    }

    /// "About 0.6 kg a week, by 28 Feb 2027 (14 weeks)."
    private var timelineText: String {
        let perWeek = unit.fromKilograms(abs(plan.weeklyChangeKg)).formatted(.number.precision(.fractionLength(1)))
        guard let weeks = plan.weeksToTarget, let date = plan.targetDate() else {
            let floored = plan.limits.contains {
                switch $0 {
                case .floor, .belowFloor: return true
                default: return false
                }
            }
            return floored
                ? String(localized: "Your calories sit at the lowest we suggest, which leaves little room for a deficit: more daily activity is the lever.")
                : String(localized: "These calories won't reach that target in a sensible time; we'll show a date once they can.")
        }
        return String(localized: "About \(perWeek) \(unit.symbol) a week, so around \(date.formatted(.dateTime.day().month(.abbreviated).year())) (\(weeks) weeks).",
                      comment: "The pace and the date: About 0.6 kg a week, so around 28 Feb 2027 (14 weeks).")
    }

    private var bmiTitle: String {
        let bmi = plan.bmi.formatted(.number.precision(.fractionLength(1)))
        guard let bmiClass = plan.bmiClass else { return String(localized: "BMI \(bmi)", comment: "BMI: 22.4") }
        return String(localized: "BMI \(bmi) · \(Self.title(bmiClass))", comment: "BMI and its class: BMI 26.1 · Overweight")
    }

    private var bmiDetail: String {
        let range = weightRange(plan.healthyRange)
        guard plan.bmiClass != nil else {
            return String(localized: "Under 18, BMI is read against growth charts for your age: ask your doctor how yours looks.")
        }
        return String(localized: "Healthy weight for your height: \(range). For Asian adults, the WHO suggests taking care from a BMI of 23.",
                      comment: "The healthy weight range: 57–76 kg")
    }

    private static func title(_ bmiClass: NutritionPlan.BMIClass) -> String {
        switch bmiClass {
        case .under: return String(localized: "Underweight", comment: "BMI class")
        case .healthy: return String(localized: "Healthy weight", comment: "BMI class")
        case .over: return String(localized: "Overweight", comment: "BMI class")
        case .obese: return String(localized: "Obese", comment: "BMI class")
        }
    }

    private func bodyFatDetail(_ bodyFat: NutritionPlan.BodyFat) -> String {
        switch bodyFat.method {
        case .entered: return String(localized: "As you entered it.")
        case .navy:
            return plan.sex == .female
                ? String(localized: "From your waist, neck, hips and height (the US Navy tape formula), usually within 3–4%.")
                : String(localized: "From your waist, neck and height (the US Navy tape formula), usually within 3–4%.")
        case .deurenberg:
            return String(localized: "Estimated from your BMI, age and sex: rough (±4–5%), and on the high side if you're muscular. A tape measure makes it closer.")
        }
    }

    private var bodyFormulas: [FormulaCard.Line] {
        let metres = plan.heightCm / 100
        let m = metres.formatted(.number.precision(.fractionLength(2)))
        let w = number(plan.weightKg, 1)
        // Formula lines with a unit in them are localized like any text;
        // the pure arithmetic ones stay as they are.
        var lines = [
            FormulaCard.Line(label: String(localized: "BMI"),
                             math: String(localized: "\(w) kg ÷ (\(m) m)² = \(number(plan.bmi, 1))",
                                          comment: "BMI formula with the user's numbers: 70 kg ÷ (1.75 m)² = 22.9")),
        ]
        // Adult BMI bands don't apply under 18.
        if plan.bmiClass != nil {
            lines.append(FormulaCard.Line(label: String(localized: "Healthy range (BMI 18.5–24.9)"),
                             math: String(localized: "\(number(18.5, 1)) × \(m)² = \(number(plan.healthyRange.lowerBound, 1)) kg · \(number(24.9, 1)) × \(m)² = \(number(plan.healthyRange.upperBound, 1)) kg",
                                          comment: "Healthy weight range formula: 18.5 × 1.75² = 56.7 kg · 24.9 × 1.75² = 76.3 kg")))
        }
        if let bodyFat = plan.bodyFat {
            let p = number(bodyFat.percent, 1)
            let h = number(plan.heightCm, 0)
            let math: String
            switch bodyFat.method {
            case .entered:
                math = String(localized: "Entered: \(p)%", comment: "Body fat as typed: Entered: 18%")
            case .navy:
                let waist = number(draft.waistCm, 0), neck = number(draft.neckCm, 0)
                if plan.sex == .female {
                    let hip = number(draft.hipCm, 0)
                    math = "495 ÷ (\(number(1.29579, 5)) − \(number(0.35004, 5)) × log₁₀(\(waist) + \(hip) − \(neck)) + \(number(0.221, 3)) × log₁₀(\(h))) − 450 = \(p)%"
                } else {
                    math = "495 ÷ (\(number(1.0324, 4)) − \(number(0.19077, 5)) × log₁₀(\(waist) − \(neck)) + \(number(0.15456, 5)) × log₁₀(\(h))) − 450 = \(p)%"
                }
            case .deurenberg:
                let sexTerm = number(plan.sex == .male ? 1 : plan.sex == .female ? 0 : 0.5, 1)
                math = "\(number(1.2, 1)) × \(number(plan.bmi, 1)) + \(number(0.23, 2)) × \(plan.age) − \(number(10.8, 1)) × \(sexTerm) − \(number(5.4, 1)) = \(p)%"
            }
            lines.append(FormulaCard.Line(label: String(localized: "Body fat"), math: math))
        }
        if let ratio = plan.waistToHeight {
            lines.append(FormulaCard.Line(label: String(localized: "Waist-to-height"),
                                          math: String(localized: "\(number(draft.waistCm, 0)) cm ÷ \(number(plan.heightCm, 0)) cm = \(number(ratio, 2))",
                                                       comment: "Waist-to-height formula: 84 cm ÷ 175 cm = 0.48")))
        }
        return lines
    }

    // MARK: - Energy

    private var energyPage: some View {
        OnboardingResultPage(
            eyebrow: String(localized: "YOUR PLAN · CALORIES"),
            title: String(localized: "Your daily calories")
        ) {
            ResultStat(value: Int(plan.calories).formatted(),
                       unit: String(localized: "kcal", comment: "Unit beside the day's calorie target in large type: 2,050 kcal"),
                       label: dailyChangeText)
                .padding(.bottom, 6)

            ResultCard(symbol: "flame", title: String(localized: "From rest to your target")) {
                VStack(spacing: layout.value(8, 10)) {
                    energyRow(String(localized: "At rest (BMR)"), kcal(plan.bmr))
                    energyRow(String(localized: "With your activity (TDEE, × \(factorText))", comment: "TDEE with its factor: × 1.55"),
                              kcal(plan.tdee))
                    if plan.extraCalories > 0 {
                        energyRow(extraLabel, "+" + kcal(plan.extraCalories))
                    }
                    if abs(plan.adjustment) >= 1 {
                        energyRow(adjustmentLabel, (plan.adjustment < 0 ? "−" : "+") + kcal(abs(plan.adjustment)))
                    }
                    Hairline(opacity: 0.08)
                    energyRow(String(localized: "Your target", comment: "Last row of the calories card: the day's calorie target"),
                              kcal(plan.calories), bold: true)
                }
                .padding(.top, 8)
            }

            // With Apple Health connected (reopened from Today, or the
            // answers edited later): the steps set the daily activity
            // instead of the answer.
            if let measured = plan.measured {
                ResultCard(symbol: "figure.walk",
                           title: String(localized: "Daily activity from your steps"),
                           detail: measuredActivityText(measured))
            }

            if let target = plan.targetWeightKg, plan.trajectory.count > 1, let date = plan.targetDate() {
                ResultCard(symbol: "chart.line.downtrend.xyaxis",
                           title: String(localized: "\(kg(target)) in about \(plan.weeksToTarget ?? 0) weeks",
                                         comment: "The target weight and the weeks to it: 72 kg in about 14 weeks"),
                           detail: String(localized: "Around \(date.formatted(.dateTime.day().month(.wide).year())). Weight swings day to day; weigh in a few mornings a week and the plan follows your 7-day average.",
                                          comment: "The date the target is reached")) {
                    WeightChart(trajectory: plan.trajectory.map { unit.fromKilograms($0) },
                                unitSymbol: unit.symbol)
                        .frame(height: layout.value(130, 160))
                        .padding(.top, 10)
                }
            }

            ForEach(limitNotes, id: \.self) { note in
                NoticeCard(symbol: "info.circle", title: note.title, lines: [note.text])
            }

            FormulaCard(lines: energyFormulas,
                        sources: String(localized: "Sources: Mifflin et al., Am J Clin Nutr 1990; Frankenfield et al., J Am Diet Assoc 2005; Helms et al., JISSN 2014; Iraki et al., Sports 2019; NHLBI 1998; IOM 2005; Hall et al., Lancet 2011.")
                            + (plan.measured == nil ? ""
                               : " " + String(localized: "Steps: Tudor-Locke & Bassett, Sports Med 2004.",
                                              comment: "The source for the step bands, after the energy page's sources")))
        }
    }

    /// "On my feet a lot — from your steps: 9,240 a day over 14 days (Apple
    /// Health)." — or, before today's first read (`days` 0, the band carried
    /// over), "from your recent steps" without numbers — then that steps in
    /// logged workouts are left out, and where to turn it off.
    private func measuredActivityText(_ measured: MeasuredActivity) -> String {
        let source = measured.days > 0
            ? String(localized: "\(measured.activity.title) — from your steps: \(measured.averageSteps.formatted()) a day over \(measured.days) days (Apple Health).",
                     comment: "The plan's daily activity from Apple Health steps: On my feet a lot — from your steps: 9,240 a day over 14 days (Apple Health).")
            : String(localized: "\(measured.activity.title) — from your recent steps, updating from Apple Health.",
                     comment: "The plan's daily activity from Apple Health steps, before today's steps are read: On my feet a lot — from your recent steps, updating from Apple Health.")
        let rule = String(localized: "Steps during your logged MUSQ workouts don't count, since your training days already do.",
                          comment: "Why steps inside logged workouts are left out of the plan's step average")
        let answer = String(localized: "This stands in for your answer to the daily-activity question. To use your answer again, turn it off in Profile › Settings › Apple Health.",
                            comment: "After the plan's daily activity from Apple Health steps")
        return [source, rule, answer].joined(separator: " ")
    }

    /// The step bands, as the plan reads them: "under 7,500", "7,500–12,499",
    /// "12,500 and up".
    private static func stepBand(_ activity: DailyActivity) -> String {
        let onFeet = Int(MeasuredActivity.onFeetFrom), physical = Int(MeasuredActivity.physicalFrom)
        // Keyed: the bare ranges would share keys with unrelated strings.
        switch activity {
        case .sitting:
            return String(localized: "plan.stepBand.sitting", defaultValue: "under \(onFeet.formatted())",
                          comment: "Step band for mostly sitting: under 7,500 (steps a day)")
        case .onFeet:
            return String(localized: "plan.stepBand.onFeet", defaultValue: "\(onFeet.formatted())–\((physical - 1).formatted())",
                          comment: "Step band for on your feet: 7,500–12,499 (steps a day)")
        case .physical:
            return String(localized: "plan.stepBand.physical", defaultValue: "\(physical.formatted()) and up",
                          comment: "Step band for physical work: 12,500 and up (steps a day)")
        }
    }

    private func energyRow(_ label: String, _ value: String, bold: Bool = false) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.ui(layout.value(13, 14), bold ? .semibold : .regular))
                .foregroundStyle(DS.silver.opacity(bold ? 1 : 0.7))
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 8)
            Text(value)
                .font(.mono(layout.value(12.5, 13.5), .semibold))
                .foregroundStyle(DS.silver.opacity(bold ? 1 : 0.85))
        }
    }

    private var factorText: String { number(plan.activityFactor, 3) }

    private var dailyChangeText: String {
        let change = Int(abs(plan.adjustment).rounded()).formatted()
        if plan.adjustment <= -1 {
            return String(localized: "a day · \(change) kcal under what you burn", comment: "Under the stat: a day · 660 kcal under what you burn")
        }
        if plan.adjustment >= 1 {
            return String(localized: "a day · \(change) kcal over what you burn", comment: "Under the stat: a day · 190 kcal over what you burn")
        }
        return String(localized: "a day · what you burn", comment: "Under the stat: maintenance")
    }

    private var extraLabel: String {
        if plan.health.isPregnant {
            return plan.health.trimester == 3 ? String(localized: "Third trimester")
                                              : String(localized: "Second trimester")
        }
        return String(localized: "Breastfeeding")
    }

    private var adjustmentLabel: String {
        let perWeek = unit.fromKilograms(abs(plan.weeklyChangeKg)).formatted(.number.precision(.fractionLength(1)))
        switch plan.effectiveGoal {
        case .loseWeight:
            return String(localized: "To lose \(perWeek) \(unit.symbol) a week", comment: "The deficit's row: To lose 0.6 kg a week")
        case .buildMuscle:
            return String(localized: "To gain \(perWeek) \(unit.symbol) a week", comment: "The surplus's row: To gain 0.3 kg a week")
        case .recomp:
            return plan.limits.contains { if case .floor = $0 { return true }; return false }
                ? String(localized: "Recomp, held at the floor")
                : String(localized: "Recomp: 10% under")
        case .getFit:
            return String(localized: "Adjustment")
        }
    }

    private struct LimitNote: Hashable {
        var title: String
        var text: String
    }

    private var limitNotes: [LimitNote] {
        plan.limits.compactMap { limit in
            switch limit {
            case .floor(let floor):
                return LimitNote(title: String(localized: "Held at \(Int(floor).formatted()) kcal",
                                               comment: "The calorie floor: Held at 1,200 kcal"),
                                 text: plan.effectiveGoal == .recomp
                                    ? String(localized: "That's the lowest we suggest without a doctor's supervision, so the deficit is smaller than 10%.")
                                    : String(localized: "That's the lowest we suggest without a doctor's supervision, so progress is slower than the pace you picked."))
            case .belowFloor(let floor):
                return LimitNote(title: String(localized: "No deficit for now"),
                                 text: String(localized: "What you burn is already under \(Int(floor).formatted()) kcal, the lowest we usually suggest, so the plan doesn't cut calories. Talk to a doctor or dietitian before eating less; more daily activity is the safer lever.",
                                              comment: "The calorie floor when maintenance is already under it: 1,200 kcal"))
            case .deficitCap:
                return LimitNote(title: String(localized: "Deficit capped at 25%"),
                                 text: String(localized: "A deficit larger than a quarter of what you burn costs energy and muscle, so the pace is a little slower."))
            case .surplusCap:
                return LimitNote(title: String(localized: "Surplus capped at 20%"),
                                 text: String(localized: "More than that mostly adds fat, so the pace is a little slower."))
            case .breastfeedingCap:
                return LimitNote(title: String(localized: "\(unit.format(0.5)) a week at most",
                                               comment: "The breastfeeding cap: 0.5 kg (or 1.1 lb) a week at most"),
                                 text: String(localized: "While breastfeeding, losing faster than that can affect your milk."))
            case .targetReached:
                return LimitNote(title: String(localized: "Target reached"),
                                 text: String(localized: "Your 7-day average is at your target, so the plan now eats what you burn. Set a new goal when you're ready."))
            case .pregnancy, .teen, .underweight:
                return nil
            }
        }
    }

    private var energyFormulas: [FormulaCard.Line] {
        let w = number(plan.weightKg, 1), h = number(plan.heightCm, 0)
        let constant = NutritionPlan.sexConstant(plan.sex)
        let constantText = constant >= 0 ? "+ \(number(constant, 0))" : "− \(number(-constant, 0))"
        var lines = [
            FormulaCard.Line(label: String(localized: "BMR · Mifflin-St Jeor"),
                             math: "10 × \(w) + \(number(6.25, 2)) × \(h) − 5 × \(plan.age) \(constantText) = \(kcal(plan.bmr))"),
        ]
        if let measured = plan.measured {
            // The steps pick the band; once in a band the average has to
            // pass the next line by 500 steps to move it. Before today's
            // first read (`days` 0) the band in use carries over, with no
            // average to show.
            let band = "\(Self.stepBand(measured.activity)): \(measured.activity.title.lowercased())"
            let math: String
            if measured.days > 0 {
                let held = MeasuredActivity.band(Double(measured.averageSteps), previous: nil) != measured.activity
                let average = String(localized: "\(measured.averageSteps.formatted()) a day over \(measured.days) days → \(band)",
                                     comment: "Steps to daily activity; the last value is the band and its level: 9,240 a day over 14 days → 7,500–12,499: on my feet a lot")
                math = held ? average + " " + String(localized: "(within 500 steps of the line, so it holds)",
                                                     comment: "A step average near a band's edge keeps the band it had")
                            : average
            } else {
                math = String(localized: "Recent steps → \(band) (updating from Apple Health)",
                              comment: "Steps to daily activity before today's steps are read; the value is the band and its level: Recent steps → 7,500–12,499: on my feet a lot (updating from Apple Health)")
            }
            lines.append(FormulaCard.Line(
                label: String(localized: "Daily activity · steps outside logged workouts (Apple Health)",
                              comment: "Formula label: the plan's step average leaves out steps taken during logged MUSQ workouts"),
                math: math))
            lines.append(FormulaCard.Line(
                label: String(localized: "TDEE · \(Self.levelName(plan.activityLevel)): \(plan.daysPerWeek) training days, \(plan.activity.title.lowercased()) from your steps",
                              comment: "The activity level, the training days and the day outside the gym, measured from Apple Health steps"),
                math: "\(kcal(plan.bmr)) × \(factorText) = \(kcal(plan.tdee))"))
        } else {
            lines.append(FormulaCard.Line(
                label: String(localized: "TDEE · \(Self.levelName(plan.activityLevel)): \(plan.daysPerWeek) training days, \(plan.activity.title.lowercased())",
                              comment: "The activity level, the training days and the day outside the gym"),
                math: "\(kcal(plan.bmr)) × \(factorText) = \(kcal(plan.tdee))"))
        }
        if plan.extraCalories > 0 {
            lines.append(FormulaCard.Line(label: extraLabel,
                                          math: "+\(kcal(plan.extraCalories)) (IOM 2005)"))
        }
        switch plan.effectiveGoal {
        case .loseWeight, .buildMuscle:
            if let rate = plan.chosenRate {
                let raw = rate * plan.weightKg * NutritionPlan.kcalPerKg / 7
                lines.append(FormulaCard.Line(
                    label: plan.effectiveGoal == .loseWeight ? String(localized: "Deficit") : String(localized: "Surplus"),
                    math: String(localized: "\(percent(rate)) × \(w) kg × \(kcal(NutritionPlan.kcalPerKg)) ÷ 7 = \(kcal(raw))",
                                 comment: "Deficit or surplus formula: 0.75% × 80 kg × 7,700 kcal ÷ 7 = 660 kcal")))
                if let cap = capLine {
                    lines.append(cap)
                }
            }
        case .recomp:
            lines.append(FormulaCard.Line(label: String(localized: "Recomp deficit"),
                                          math: "10% × \(kcal(plan.tdee)) = \(kcal(plan.tdee * 0.1))"))
            if let cap = capLine {
                lines.append(cap)
            }
        case .getFit:
            break
        }
        let maintenance = plan.tdee + plan.extraCalories
        let sign = plan.adjustment < 0 ? "−" : "+"
        let unrounded = maintenance + plan.adjustment
        lines.append(FormulaCard.Line(
            label: String(localized: "Target, rounded to 10",
                          comment: "Formula row label: the day's calorie target, rounded to the nearest 10 kcal"),
            math: abs(plan.adjustment) >= 1
                ? "\(kcal(maintenance)) \(sign) \(kcal(abs(plan.adjustment))) = \(kcal(unrounded)) → \(kcal(plan.calories))"
                : "\(kcal(maintenance)) → \(kcal(plan.calories))"))
        if let weeks = plan.weeksToTarget, let target = plan.targetWeightKg {
            let rate = percent(abs(plan.weeklyRate))
            let direction = plan.weeklyRate < 0 ? "−" : "+"
            let goal = number(target, 1)
            lines.append(FormulaCard.Line(
                label: String(localized: "Time to target"),
                math: String(localized: "\(w) kg × (1 \(direction) \(rate)) each week → \(goal) kg in \(weeks) weeks",
                             comment: "Week-by-week change: 80 kg × (1 − 0.75%) each week → 72 kg in 14 weeks")))
        }
        return lines
    }

    /// What a cap or the floor did to the raw deficit or surplus.
    private var capLine: FormulaCard.Line? {
        let label = String(localized: "Capped", comment: "Formula row label: the deficit or surplus a cap held back")
        for limit in plan.limits.reversed() {
            switch limit {
            case .floor(let floor):
                return FormulaCard.Line(label: String(localized: "Held at the floor"),
                                        math: "\(kcal(plan.tdee + plan.extraCalories)) − \(kcal(floor)) = \(kcal(abs(plan.adjustment)))")
            case .belowFloor(let floor):
                return FormulaCard.Line(label: String(localized: "Already under the floor"),
                                        math: String(localized: "\(kcal(plan.tdee + plan.extraCalories)) < \(kcal(floor)) → 0 kcal",
                                                     comment: "What the user burns is under the calorie floor, so no deficit: 1,150 kcal < 1,200 kcal → 0 kcal"))
            case .breastfeedingCap:
                return FormulaCard.Line(label: label,
                                        math: String(localized: "\(number(0.5, 1)) kg × \(kcal(NutritionPlan.kcalPerKg)) ÷ 7 = \(kcal(abs(plan.adjustment)))",
                                                     comment: "The breastfeeding cap's formula: 0.5 kg × 7,700 kcal ÷ 7 = 550 kcal"))
            case .deficitCap:
                return FormulaCard.Line(label: label, math: "25% × \(kcal(plan.tdee)) = \(kcal(abs(plan.adjustment)))")
            case .surplusCap:
                return FormulaCard.Line(label: label, math: "20% × \(kcal(plan.tdee)) = \(kcal(abs(plan.adjustment)))")
            case .pregnancy, .teen, .underweight, .targetReached:
                continue
            }
        }
        return nil
    }

    static func levelName(_ level: Int) -> String {
        switch level {
        case 0: return String(localized: "Sedentary", comment: "Activity level")
        case 1: return String(localized: "Lightly active", comment: "Activity level")
        case 2: return String(localized: "Moderately active", comment: "Activity level")
        case 3: return String(localized: "Very active", comment: "Activity level")
        default: return String(localized: "Extra active", comment: "Activity level")
        }
    }

    // MARK: - Macros

    private var macrosPage: some View {
        let proteinKcal = plan.protein * 4, fatKcal = plan.fat * 9, carbKcal = plan.carbs * 4
        let total = max(proteinKcal + fatKcal + carbKcal, 1)
        return OnboardingResultPage(
            eyebrow: String(localized: "YOUR PLAN · MACROS"),
            title: String(localized: "Protein, fat and carbs"),
            caption: String(localized: "Your \(Int(plan.calories).formatted()) kcal a day, split three ways.",
                            comment: "The day's calories: Your 2,050 kcal a day, split three ways.")
        ) {
            MacroBar(parts: [(proteinKcal / total, DS.activation), (fatKcal / total, DS.activationSoft),
                             (carbKcal / total, DS.silver.opacity(0.35))])
                .frame(height: 14)
                .padding(.bottom, 4)

            ResultCard(symbol: "fork.knife",
                       title: String(localized: "\(Int(plan.protein)) g protein", comment: "160 g protein"),
                       detail: proteinDetail(share: proteinKcal / total)) {
                legendDot(DS.activation)
            }
            ResultCard(symbol: "drop",
                       title: String(localized: "\(Int(plan.fat)) g fat", comment: "57 g fat"),
                       detail: String(localized: "\(share(fatKcal / total)) of your calories · \(Int(fatKcal).formatted()) kcal. Olive oil, nuts, eggs, fish.",
                                      comment: "Fat's share and calories: 25% of your calories · 513 kcal")) {
                legendDot(DS.activationSoft)
            }
            ResultCard(symbol: "leaf",
                       title: String(localized: "\(Int(plan.carbs)) g carbs", comment: "224 g carbs"),
                       detail: String(localized: "The rest: \(share(carbKcal / total)) · \(Int(carbKcal).formatted()) kcal. Rice, oats, potatoes, fruit — more around training.",
                                      comment: "Carbs' share and calories: The rest: 44% · 898 kcal")) {
                legendDot(DS.silver.opacity(0.35))
            }
            ResultCard(symbol: "carrot",
                       title: String(localized: "\(Int(plan.fiber)) g fibre", comment: "29 g fibre"),
                       detail: String(localized: "Vegetables, fruit, whole grains and beans."))

            FormulaCard(lines: macroFormulas(proteinKcal: proteinKcal, fatKcal: fatKcal),
                        sources: String(localized: "Sources: ISSN position stand on protein (Jäger et al. 2017); Morton et al., Br J Sports Med 2018; Helms et al., JISSN 2014; PROT-AGE 2013; KDOQI 2020; IOM 2005 (fat range, fibre)."))
        }
    }

    private func proteinDetail(share: Double) -> String {
        let perKg = plan.proteinPerKg.formatted(.number.precision(.fractionLength(1)))
        let basis = unit == .kg ? kg(plan.proteinBasisKg)
                                : String(localized: "\(Int(plan.proteinBasisKg.rounded()))\u{00A0}kg (\(kg(plan.proteinBasisKg)))",
                                         comment: "The weight protein is counted on, in kilograms then in pounds: 72 kg (159 lb)")
        switch plan.proteinRule {
        case .kidney:
            return String(localized: "\(perKg) g per kg, the general amount, because of kidney disease: ask your doctor or dietitian what suits your kidneys.",
                          comment: "Protein with kidney disease: 0.8 g per kg")
        case .pregnancy:
            return String(localized: "\(perKg) g per kg, the pregnancy recommendation. Spread it over your meals.",
                          comment: "Protein in pregnancy: 1.1 g per kg")
        case .goal, .olderAdult:
            if plan.proteinBasisKg < plan.weightKg - 0.5 {
                return String(localized: "\(perKg) g per kg of \(basis), the weight at a BMI of 25 for your height. 20–40 g a meal, over 3–5 meals.",
                              comment: "Protein counted on a reference weight: 2.0 g per kg of 72 kg")
            }
            return String(localized: "\(perKg) g per kg of body weight · \(self.share(share)) of your calories. 20–40 g a meal, over 3–5 meals.",
                          comment: "Protein per kg and its share: 2.0 g per kg of body weight · 31% of your calories")
        }
    }

    private func macroFormulas(proteinKcal: Double, fatKcal: Double) -> [FormulaCard.Line] {
        let calories = kcal(plan.calories)
        let fatLine: String
        if plan.fat > 0.25 * plan.calories / 9 + 0.5 {
            fatLine = String(localized: "\(number(0.6, 1)) g × \(number(plan.proteinBasisKg, 1)) kg = \(Int(plan.fat)) g",
                             comment: "Fat at its floor of 0.6 g per kg: 0.6 g × 72 kg = 43 g")
        } else {
            fatLine = String(localized: "25% × \(calories) ÷ 9 = \(Int(plan.fat)) g",
                             comment: "Fat as a quarter of the calories: 25% × 2,050 kcal ÷ 9 = 57 g")
        }
        return [
            FormulaCard.Line(label: String(localized: "Protein"),
                             math: String(localized: "\(plan.proteinPerKg.formatted(.number.precision(.fractionLength(1)))) g × \(number(plan.proteinBasisKg, 1)) kg = \(Int(plan.protein)) g · × 4 = \(kcal(proteinKcal))",
                                          comment: "Protein formula: 2.0 g × 80 kg = 160 g · × 4 = 640 kcal")),
            FormulaCard.Line(label: String(localized: "Fat"), math: fatLine + " · × 9 = \(kcal(fatKcal))"),
            FormulaCard.Line(label: String(localized: "Carbs"),
                             math: String(localized: "(\(calories) − \(kcal(proteinKcal)) − \(kcal(fatKcal))) ÷ 4 = \(Int(plan.carbs)) g",
                                          comment: "Carbs formula: (2,050 kcal − 640 kcal − 513 kcal) ÷ 4 = 224 g")),
            FormulaCard.Line(label: String(localized: "Fibre"),
                             math: String(localized: "14 g × \(Int(plan.calories).formatted()) ÷ \(1_000.formatted()) = \(Int(plan.fiber)) g",
                                          comment: "Fibre formula, 14 g per 1,000 kcal: 14 g × 2,050 ÷ 1,000 = 29 g")),
        ]
    }

    private func legendDot(_ color: Color) -> some View {
        Capsule().fill(color).frame(width: 28, height: 4).padding(.top, 6)
    }

    // MARK: - Week

    private var weekPage: some View {
        let experience = draft.experience ?? .beginner
        let split = ProgramAdvisor.split(for: profile)
        let days = plan.daysPerWeek
        let rotation = ProgramAdvisor.days(for: profile)
            .map { ProgramAdvisor.SplitDay(name: $0.name, groups: $0.groups.filter(PresetProvider.trainableGroups.contains)) }
            .filter { !$0.groups.isEmpty }
        let weekdays = profile.weekdays ?? ProgramAdvisor.suggestedWeekdays(daysPerWeek: days)
        let level = ProgramAdvisor.suggestedLevel(for: profile, experience: experience)
        let safety = ExerciseSafety(profile: profile)
        let frequency = ProgramAdvisor.frequencyText(
            ProgramAdvisor.timesPerWeek(days: ProgramAdvisor.days(for: profile), daysPerWeek: days))
        return OnboardingResultPage(
            eyebrow: String(localized: "YOUR PLAN · WEEK"),
            title: String(localized: "Your training week")
        ) {
            WeekStrip(week: ProgramAdvisor.week(weekdays: weekdays, days: rotation))

            ResultCard(symbol: OnboardingQuestion.symbol(split),
                       title: String(localized: "\(split.title), \(days) days a week",
                                     comment: "Plan summary: the split, e.g. Front / Back, 3 days a week"),
                       detail: String(localized: "Every muscle \(frequency). Change days, rest days or the split any time from the calendar in Train.",
                                      comment: "How often each muscle comes round: about 2× a week. Train is the tab")) {
                VStack(alignment: .leading, spacing: layout.value(7, 9)) {
                    ForEach(Array(rotation.enumerated()), id: \.offset) { _, day in
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text(day.name.uppercased())
                                .font(.mono(layout.value(9, 10), .semibold))
                                .trackingEm(0.08, size: layout.value(9, 10))
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

            ResultCard(symbol: "slider.horizontal.3",
                       title: String(localized: "\(level.name) presets", comment: "Plan summary, e.g. Basic presets"),
                       detail: level == .basic
                        ? String(localized: "Machines and supported positions to start. Switch to Advanced on any muscle group.",
                                 comment: "Advanced is the preset level")
                        : String(localized: "Free-weight compounds to start. Switch to Basic on any muscle group.",
                                 comment: "Basic is the preset level"))

            if profile.goal == .loseWeight {
                let walk = ProgramAdvisor.walk(for: profile, experience: experience)
                ResultCard(symbol: "figure.walk",
                           title: String(localized: "Walk \(walk.steps.formatted()) steps after each workout",
                                         comment: "The steps: 3,000"),
                           detail: String(localized: "\(walk.detail). Aim for \(WalkSuggestion.dailySteps.formatted())+ steps across the day.",
                                          comment: "The walk's estimate (≈ 2.8 km · 30 min · 100 kcal), then a day's steps: 8,000"))
            }

            ResultCard(symbol: "heart.circle",
                       title: plan.health.isPregnant
                        ? String(localized: "150 minutes of moderate activity a week")
                        : String(localized: "150–300 minutes of cardio a week"),
                       detail: plan.health.isPregnant
                        ? String(localized: "Walking, swimming or cycling, at a pace where you can still talk.")
                        : String(localized: "Brisk walking, cycling or swimming on top of your workouts — the WHO's weekly guide for adults."))

            if !safety.isEmpty {
                swapsCard(safety: safety, level: level)
            }

            ForEach(healthNotes(safety: safety), id: \.title) { note in
                ResultCard(symbol: note.symbol, title: note.title, detail: note.changed) {
                    VStack(alignment: .leading, spacing: 6) {
                        if let count = note.excluded, count > 0 {
                            Text("\(count) exercises are marked not advised in the library; you can still open them.",
                                 comment: "How many library exercises a health answer marks")
                                .font(.ui(layout.value(12.5, 13.5)))
                                .foregroundStyle(DS.silver.opacity(0.55))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Text(note.doctor)
                            .font(.ui(layout.value(12.5, 13.5), .medium))
                            .foregroundStyle(DS.silver.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                        Text(note.source)
                            .font(.ui(layout.value(11, 12)))
                            .italic()
                            .foregroundStyle(DS.silver.opacity(0.4))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 6)
                }
            }

            Text("Change any of this later in Profile. This plan is general guidance, not medical advice.")
                .font(.ui(layout.value(12, 13)))
                .foregroundStyle(DS.silver.opacity(0.4))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
    }

    private func swapsCard(safety: ExerciseSafety, level: PresetLevel) -> some View {
        let swaps = safety.presetSwaps(levels: [level], groups: builtInPresetGroups)
        let ownPresets = builtInPresetGroups.count < PresetProvider.trainableGroups.count
        return ResultCard(symbol: "arrow.left.arrow.right",
                          title: swaps.isEmpty ? String(localized: "Your presets already suit your answers")
                                               : String(localized: "Swapped in your presets"),
                          detail: safety.minimumReps.map {
                              String(localized: "Every set is \($0) reps or more: no maximal efforts.",
                                     comment: "The rep floor: Every set is 10 reps or more")
                          }) {
            if !swaps.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(swaps.enumerated()), id: \.offset) { _, swap in
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text(swap.removed)
                                .strikethrough()
                                .foregroundStyle(DS.silver.opacity(0.45))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(DS.silver.opacity(0.4))
                            Text(swap.added ?? String(localized: "left out",
                                                      comment: "After an exercise's arrow in the swaps list: dropped, with nothing in its place"))
                                .foregroundStyle(DS.silver)
                        }
                        .font(.ui(layout.value(13, 14), .semibold))
                    }
                }
                .padding(.top, 6)
            }
            if ownPresets {
                Text("Your own presets stay as you saved them; anything in them that isn't advised is marked.")
                    .font(.ui(layout.value(12.5, 13.5)))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 6)
            }
        }
    }

    // MARK: - Health notes

    private struct HealthNote {
        var symbol: String
        var title: String
        var changed: String
        var doctor: String
        var source: String
        var excluded: Int?
    }

    private func healthNotes(safety: ExerciseSafety) -> [HealthNote] {
        let health = plan.health
        var notes: [HealthNote] = []
        func count(_ concern: ExerciseSafety.Concern) -> Int? {
            safety.concerns.contains(concern) ? safety.excludedCount(for: concern) : nil
        }
        if health.has(.knee) {
            notes.append(HealthNote(
                symbol: JointIssue.knee.symbol, title: String(localized: "Knee pain"),
                changed: String(localized: "No jumping, Olympic lifts, deep single-leg squats, twisting lunges or forward lunges. Squats and leg presses stay: go only as deep as is pain-free, and lean on bridges, hip thrusts, curls and hip abduction."),
                doctor: String(localized: "See a doctor if your knee swells, locks or gives way, you can't put weight on it after an injury, it's hot and red with a fever, or it isn't better after 2–3 weeks."),
                source: String(localized: "Crossley et al., Br J Sports Med 2016; OARSI guidelines 2019."),
                excluded: count(.knee)))
        }
        if health.has(.lowerBack) {
            notes.append(HealthNote(
                symbol: JointIssue.lowerBack.symbol, title: String(localized: "Lower back pain"),
                changed: String(localized: "No barbell hinges or good mornings, rows bent over without chest support, bar-on-back squats, standing barbell presses, sit-ups, Russian twists or side bends. Core work leans on curl-ups, side planks and bird dogs; keep moving every day."),
                doctor: String(localized: "Get urgent care for numbness around your groin or buttocks, new bladder or bowel problems, or leg weakness or numbness that's getting worse. See a doctor after a fall, with a fever or unexplained weight loss, if you've had cancer, or if it isn't easing after 4–6 weeks."),
                source: String(localized: "NICE guideline NG59; McGill, Low Back Disorders."),
                excluded: count(.lowerBack)))
        }
        if health.has(.shoulder) {
            notes.append(HealthNote(
                symbol: JointIssue.shoulder.symbol, title: String(localized: "Shoulder pain"),
                changed: String(localized: "No overhead pressing (the landmine press stays), dips, upright rows, pullovers or behind-the-neck work. Raise to shoulder height, and lean on rows, face pulls and rotator-cuff work."),
                doctor: String(localized: "See a doctor if you can't lift your arm, it went weak suddenly after a fall, numbness runs down your arm, or pain wakes you at night. Left shoulder or arm pain with chest tightness or breathlessness is an emergency."),
                source: String(localized: "Kolber et al., J Strength Cond Res 2010 and 2011."),
                excluded: count(.shoulder)))
        }
        if health.has(.wristElbow) {
            notes.append(HealthNote(
                symbol: JointIssue.wristElbow.symbol, title: String(localized: "Wrist or elbow pain"),
                changed: String(localized: "No wrist curls, reverse or Zottman curls, skull crushers, front squats, or diamond, archer or clap push-ups. Neutral grips, machines and cables first."),
                doctor: String(localized: "See a doctor if it's swollen or out of shape after a fall, your fingers go numb, your grip is weak, or it isn't better after a few weeks."),
                source: String(localized: "Common rehabilitation practice."),
                excluded: count(.wristElbow)))
        }
        if health.has(.highBloodPressure) {
            notes.append(HealthNote(
                symbol: HealthCondition.highBloodPressure.symbol, title: String(localized: "High blood pressure"),
                changed: String(localized: "No Olympic or maximal lifts, weighted pull-ups or dips, or head-down positions; every set 10 reps or more. Planks and wall sits stay: steady holds help lower blood pressure."),
                doctor: String(localized: "Breathe out as you push and never hold your breath. Stop if you get chest pain, a severe headache, dizziness or blurred vision. A reading of 180/120 or more with symptoms is an emergency."),
                source: String(localized: "Pescatello et al., Med Sci Sports Exerc 2019; AHA scientific statement 2023; Edwards et al., Br J Sports Med 2023."),
                excluded: count(.bloodPressure)))
        }
        if health.has(.heartDisease) {
            notes.append(HealthNote(
                symbol: HealthCondition.heartDisease.symbol, title: String(localized: "Heart condition"),
                changed: String(localized: "The same limits as for high blood pressure, Basic presets, and moderate effort: you should be able to talk in short sentences."),
                doctor: String(localized: "Get your doctor's OK before you start, and ask which effort or heart-rate limits suit you. Stop and get help for chest pain, unusual breathlessness, dizziness or a racing heartbeat."),
                source: String(localized: "ACSM pre-participation screening, Riebe et al. 2015."),
                excluded: count(.heart)))
        }
        if health.has(.diabetes) {
            notes.append(HealthNote(
                symbol: HealthCondition.diabetes.symbol, title: String(localized: "Diabetes"),
                changed: String(localized: "Exercises stay the same: training helps your body use blood sugar."),
                doctor: String(localized: "If you use insulin or medicines that lower blood sugar, check it before and after training and keep fast sugar with you. Check your feet for blisters or sores. With eye or nerve complications, ask your doctor before heavy lifting."),
                source: String(localized: "American Diabetes Association position statement, Colberg et al. 2016."),
                excluded: nil))
        }
        if health.has(.kidneyDisease) {
            notes.append(HealthNote(
                symbol: HealthCondition.kidneyDisease.symbol, title: String(localized: "Kidney disease"),
                changed: String(localized: "Protein is set at 0.8 g per kg, the general amount, instead of the higher training targets."),
                doctor: String(localized: "Ask your doctor or dietitian how much protein suits your kidneys."),
                source: String(localized: "KDOQI nutrition guideline for kidney disease, 2020."),
                excluded: nil))
        }
        if health.has(.osteoporosis) {
            notes.append(HealthNote(
                symbol: HealthCondition.osteoporosis.symbol, title: String(localized: "Osteoporosis"),
                changed: String(localized: "No crunches, sit-ups, twists, side bends, good mornings or jumping. Back extensions, bird dogs and planks build the spine's support; strength work twice a week helps your bones."),
                doctor: String(localized: "See a doctor about sudden back pain, which can be a fracture, or after any fall."),
                source: String(localized: "Too Fit To Fracture, Giangregorio et al., Osteoporos Int 2014."),
                excluded: count(.osteoporosis)))
        }
        if health.isPregnant {
            notes.append(HealthNote(
                symbol: HealthCondition.pregnancy.symbol, title: String(localized: "Pregnancy"),
                changed: String(localized: "No jumping, Olympic or maximal lifts; every set 10 reps or more. From the second trimester, nothing lying flat on your back or front, no crunches or twists, and no balance-heavy single-leg moves."),
                doctor: String(localized: "Get your doctor's or midwife's OK first. Stop and call them for bleeding, belly pain, regular painful contractions, leaking fluid, breathlessness before effort, dizziness, headache, chest pain, calf pain or swelling, or weakness that affects your balance."),
                source: String(localized: "ACOG Committee Opinion 804 (2020); Canadian guideline for physical activity in pregnancy 2019."),
                excluded: count(.pregnancy)))
        } else if health.isPostpartum {
            notes.append(HealthNote(
                symbol: HealthCondition.postpartum.symbol, title: String(localized: "After the birth"),
                changed: health.isPostpartumUncleared
                    ? String(localized: "Until your check-up: no jumping, Olympic or maximal lifts, crunches, leg raises, rollouts, heavy planks or twists. Dead bugs, bird dogs, bridges and walks rebuild your core.")
                    : String(localized: "You're cleared, so everything is open except jumping and running, which wait until at least 12 weeks after the birth."),
                doctor: String(localized: "See your doctor for heavy bleeding, pain, leaking urine, or a bulge along the middle of your belly that doesn't settle."),
                source: String(localized: "ACOG Committee Opinion 804 (2020); Goom, Donnelly & Brockwell, returning to running postnatal, 2019."),
                excluded: safety.concerns.contains(.postpartum) ? safety.excludedCount(for: .postpartum)
                        : safety.concerns.contains(.postpartumImpact) ? safety.excludedCount(for: .postpartumImpact) : nil))
        }
        return notes
    }

    // MARK: - Formatting

    /// A weight in the user's unit, whole: "72 kg".
    /// The space before the unit doesn't break: "71 kg" stays on one line.
    private func kg(_ kilograms: Double) -> String {
        "\(Int(unit.fromKilograms(kilograms).rounded()).formatted())\u{00A0}\(unit.symbol)"
    }

    /// "57–77 kg".
    private func weightRange(_ range: ClosedRange<Double>) -> String {
        let low = Int(unit.fromKilograms(range.lowerBound).rounded()).formatted()
        let high = Int(unit.fromKilograms(range.upperBound).rounded()).formatted()
        return "\(low)–\(high)\u{00A0}\(unit.symbol)"
    }

    /// "2,050 kcal", the space unbreakable.
    private func kcal(_ value: Double) -> String {
        String(localized: "\(Int(value.rounded()).formatted())\u{00A0}kcal",
               comment: "Calories in the plan's rows and formulas: 2,050 kcal")
    }

    private func number(_ value: Double, _ digits: Int) -> String {
        value.formatted(.number.precision(.fractionLength(0...digits)))
    }

    private func percent(_ fraction: Double) -> String {
        (fraction * 100).formatted(.number.precision(.fractionLength(0...2))) + "%"
    }

    private func share(_ fraction: Double) -> String {
        "\(Int((fraction * 100).rounded()))%"
    }
}

// MARK: - Pieces

/// A BMI bar from 15 to 40: under, healthy, over and obese, with a marker.
private struct BMIScale: View {
    var bmi: Double

    private static let range: ClosedRange<Double> = 15...40
    private static let bands: [(upper: Double, color: Color)] = [
        (18.5, DS.silver.opacity(0.25)), (25, DS.rhythmDue), (30, DS.rhythmRecent), (40, DS.rhythmWaiting),
    ]

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geo in
                let width = geo.size.width
                let x = { (value: Double) -> CGFloat in
                    CGFloat((min(max(value, Self.range.lowerBound), Self.range.upperBound) - Self.range.lowerBound)
                            / (Self.range.upperBound - Self.range.lowerBound)) * width
                }
                ZStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        ForEach(Array(Self.bands.enumerated()), id: \.offset) { index, band in
                            let lower = index == 0 ? Self.range.lowerBound : Self.bands[index - 1].upper
                            Capsule().fill(band.color)
                                .frame(width: max(0, x(band.upper) - x(lower) - 2))
                        }
                    }
                    .frame(height: 6)
                    Circle()
                        .fill(DS.silver)
                        .overlay(Circle().strokeBorder(DS.ink, lineWidth: 2))
                        .frame(width: 14, height: 14)
                        .offset(x: x(bmi) - 7)
                }
                .frame(height: 14)
            }
            .frame(height: 14)
            GeometryReader { geo in
                ForEach([18.5, 25.0, 30.0], id: \.self) { mark in
                    Text(mark.formatted(.number.precision(.fractionLength(0...1))))
                        .font(.mono(9, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.4))
                        .position(x: CGFloat((mark - Self.range.lowerBound) / (Self.range.upperBound - Self.range.lowerBound)) * geo.size.width,
                                  y: 6)
                }
            }
            .frame(height: 12)
        }
        .accessibilityHidden(true)
    }
}

/// Protein, fat and carbs as one bar.
private struct MacroBar: View {
    var parts: [(share: Double, color: Color)]

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 3) {
                ForEach(Array(parts.enumerated()), id: \.offset) { _, part in
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(part.color)
                        .frame(width: max(0, geo.size.width * part.share - 3))
                }
            }
        }
        .accessibilityHidden(true)
    }
}

/// The weight week by week to the target.
private struct WeightChart: View {
    var trajectory: [Double]
    var unitSymbol: String

    var body: some View {
        let low = (trajectory.min() ?? 0), high = (trajectory.max() ?? 0)
        let pad = max((high - low) * 0.15, 0.5)
        Chart {
            ForEach(Array(trajectory.enumerated()), id: \.offset) { week, weight in
                AreaMark(x: .value("Week", week), yStart: .value("Floor", low - pad), yEnd: .value("Weight", weight))
                    .foregroundStyle(DS.activation.opacity(0.12))
                    .interpolationMethod(.monotone)
                LineMark(x: .value("Week", week), y: .value("Weight", weight))
                    .foregroundStyle(DS.activation)
                    .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .interpolationMethod(.monotone)
            }
            if let last = trajectory.last {
                PointMark(x: .value("Week", trajectory.count - 1), y: .value("Weight", last))
                    .foregroundStyle(DS.activation)
                    .symbolSize(60)
                    .annotation(position: .top, alignment: .trailing) {
                        Text(verbatim: "\(Int(last.rounded())) \(unitSymbol)")
                            .font(.mono(10, .semibold))
                            .foregroundStyle(DS.silver.opacity(0.8))
                    }
            }
            if let first = trajectory.first {
                PointMark(x: .value("Week", 0), y: .value("Weight", first))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .symbolSize(40)
                    .annotation(position: .top, alignment: .leading) {
                        Text(verbatim: "\(Int(first.rounded())) \(unitSymbol)")
                            .font(.mono(10, .semibold))
                            .foregroundStyle(DS.silver.opacity(0.6))
                    }
            }
        }
        .chartYScale(domain: (low - pad)...(high + pad))
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .accessibilityHidden(true)
    }
}

/// The seven days, the split's days on the training ones.
private struct WeekStrip: View {
    var week: [(weekday: Int, day: ProgramAdvisor.SplitDay?)]

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let symbols = Calendar.current.shortWeekdaySymbols
        HStack(spacing: layout.value(4, 8)) {
            ForEach(Array(week.enumerated()), id: \.offset) { _, entry in
                VStack(spacing: 6) {
                    Text(symbols[entry.weekday - 1].uppercased())
                        .font(.mono(layout.value(8.5, 9.5), .semibold))
                        .trackingEm(0.06, size: layout.value(8.5, 9.5))
                        .foregroundStyle(DS.silver.opacity(0.45))
                    Text(entry.day?.name ?? String(localized: "Rest", comment: "A day without training in the week strip"))
                        .font(.ui(layout.value(10.5, 12), .semibold))
                        .foregroundStyle(entry.day == nil ? DS.silver.opacity(0.35) : DS.ink)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity, minHeight: layout.value(44, 52))
                        .padding(.horizontal, 2)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(entry.day == nil ? DS.surfaceAlt : DS.silver))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
