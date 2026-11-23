//
//  NutritionPlan.swift
//  GymWorkout
//
//  The numbers the plan onboarding works out from the answers (2026-11-21),
//  each from a published formula — the result pages show every step with
//  the user's own numbers. All of them are estimates for healthy adults,
//  shown as such; none is medical advice.
//
//  - BMR: Mifflin-St Jeor (Mifflin et al., Am J Clin Nutr 1990), the most
//    accurate of the common equations in Frankenfield et al.'s review (J Am
//    Diet Assoc 2005). "Prefer not to say" takes the average of the men's
//    (+5) and women's (−161) constants: −78.
//  - TDEE: BMR × the standard activity factors 1.2 / 1.375 / 1.55 / 1.725 /
//    1.9. Training 2-3 days is "lightly active", 4-5 "moderately", 6 "very";
//    a day on your feet adds a level, heavy physical work two, up to 1.9.
//    With Apple Health connected (2026-11-22), the last 14 days' average
//    steps pick that daily level instead of the answer (`MeasuredActivity`).
//  - Losing: a deficit of (% of body weight a week) × 7,700 kcal per kg ÷ 7,
//    at 0.5, 0.75 or 1% a week (Helms et al. 2014; Garthe et al. 2011); at
//    most 25% of TDEE (the app's own cap) and never under 1,200 kcal for women,
//    1,500 for men, 1,350 otherwise (NHLBI 1998's low-calorie ranges). No
//    1% option under a BMI of 22 or while breastfeeding, and no more than
//    0.5 kg a week while breastfeeding (Lovelady et al. 2000).
//  - Gaining: a surplus the same way at 0.25 or 0.5% a week, at most 20% of
//    TDEE (Iraki et al. 2019).
//  - Recomp: TDEE − 10% (after Barakat et al. 2020; the 10% is the app's).
//  - Pregnancy: no deficit; +340 kcal in the second trimester, +452 in the
//    third. Breastfeeding: +330 kcal for six months, +400 after (IOM 2005).
//    Under 18: no deficit (AAP 2016).
//  - Protein per kg: 2.0 losing, 2.2 recomp, 1.8 gaining, 1.6 otherwise
//    (ISSN 2017; Morton et al. 2018; Helms et al. 2014), at least 1.2 from 65
//    (PROT-AGE 2013); 1.1 in pregnancy (IOM RDA); 0.8 with kidney disease
//    (KDOQI 2020: ask the doctor). From a BMI of 30, per kg of the weight at
//    BMI 25 (the app's rule, so the number stays sensible).
//  - Fat: 25% of calories, at least 0.6 g per kg, always within 20-35%
//    (IOM AMDR). Carbs: the rest. Fibre: 14 g per 1,000 kcal (IOM).
//  - BMI: WHO classes; for Asian adults the WHO's 2004 consultation (Lancet)
//    puts the action points at 23 and 27.5, which the page notes.
//  - Body fat: entered; or the US Navy tape formula (Hodgdon & Beckett 1984);
//    else Deurenberg et al. 1991 from BMI, age and sex. Waist-to-height
//    ratio from NICE (2022): under 0.5 healthy, 0.5-0.59 raised, 0.6+ high.
//  - Time to target: week by week at the plan's rate, which slows as the
//    weight falls — an estimate that follows the 7-day average of the
//    weigh-ins. Once the average reaches the target, the plan eats what you
//    burn until a new goal is set.
//

import Foundation

struct NutritionPlan: Hashable {

    // MARK: - Inputs

    let sex: Sex
    let age: Int
    let heightCm: Double
    let weightKg: Double
    /// What the user picked.
    let goal: FitnessGoal
    /// What the numbers follow: Stay fit during pregnancy, or for someone
    /// under 18 or underweight who picked a deficit.
    let effectiveGoal: FitnessGoal
    let health: HealthAnswers
    let daysPerWeek: Int
    /// The daily activity the numbers use: measured from steps when
    /// `measured` is set, else the user's answer.
    let activity: DailyActivity
    /// Apple Health's steps, when they set `activity`.
    let measured: MeasuredActivity?

    // MARK: - Energy

    let bmr: Double
    /// 0-4: sedentary, lightly, moderately, very, extra active.
    let activityLevel: Int
    let activityFactor: Double
    let tdee: Double
    /// Pregnancy or breastfeeding energy on top of TDEE.
    let extraCalories: Double
    /// Against maintenance (TDEE + extra): negative is a deficit.
    let adjustment: Double
    /// The daily target, rounded to 10 kcal.
    let calories: Double
    let limits: [Limit]

    // MARK: - Weight

    let pace: GoalPace?
    /// The rate picked, as a fraction of body weight a week (positive).
    let chosenRate: Double?
    /// The rate the calories give, signed: negative while losing.
    let weeklyRate: Double
    let targetWeightKg: Double?
    /// Nil without a target, or when the floor leaves no deficit.
    let weeksToTarget: Int?
    /// The weight at the start of each week, now to the target.
    let trajectory: [Double]

    // MARK: - Macros

    let proteinRule: ProteinRule
    let proteinPerKg: Double
    /// The weight protein is counted on: the body weight, or the weight at
    /// BMI 25 from a BMI of 30.
    let proteinBasisKg: Double
    let protein: Double
    let fat: Double
    let carbs: Double
    let fiber: Double

    // MARK: - Body

    let bmi: Double
    /// Nil under 18, where BMI is read against age percentiles instead.
    let bmiClass: BMIClass?
    let healthyRange: ClosedRange<Double>
    let bodyFat: BodyFat?
    let waistToHeight: Double?

    // MARK: - Types

    enum Limit: Hashable {
        /// The calorie floor held the target up.
        case floor(Double)
        /// What the body burns is already under the floor: no deficit, and
        /// a doctor or dietitian should guide any cut.
        case belowFloor(Double)
        case deficitCap, surplusCap, breastfeedingCap
        /// The goal was set aside: pregnant, under 18, or underweight.
        case pregnancy, teen, underweight
        /// The weigh-ins reached the target: the plan eats what you burn
        /// until a new goal is set.
        case targetReached
    }

    enum ProteinRule: Hashable { case goal, olderAdult, pregnancy, kidney }

    enum BMIClass: Hashable {
        case under, healthy, over, obese

        init(_ bmi: Double) {
            switch bmi {
            case ..<18.5: self = .under
            case ..<25: self = .healthy
            case ..<30: self = .over
            default: self = .obese
            }
        }
    }

    struct BodyFat: Hashable {
        let percent: Double
        let method: Method

        enum Method: Hashable { case entered, navy, deurenberg }
    }

    // MARK: - Constants

    static let activityFactors: [Double] = [1.2, 1.375, 1.55, 1.725, 1.9]
    /// Energy in a kilogram of body weight change (Wishnofsky's 3,500 kcal
    /// a pound).
    static let kcalPerKg = 7_700.0

    // MARK: - Building

    /// Nil for a profile missing the plan's answers (saved before them).
    /// `measured`: Apple Health's steps, which replace the daily-activity
    /// answer. Today, its plan sheet and the profile editor's pages pass it
    /// (on screen only; the editor saves the answers, never this); the AI
    /// coach and the goal photo keep to the answers, so no Health data leaves
    /// the phone through them.
    init?(profile: UserProfile, now: Date = Date(), measured: MeasuredActivity? = nil) {
        guard let age = profile.age(at: now), let activity = profile.activity,
              let days = profile.daysPerWeek else { return nil }
        let health = profile.health ?? HealthAnswers()
        self.init(sex: profile.sex, age: age, heightCm: profile.heightCm, weightKg: profile.weightKg,
                  goal: profile.goal, health: health, daysPerWeek: days, activity: activity,
                  pace: profile.pace, targetWeightKg: profile.targetWeightKg,
                  measurements: profile.measurements, measured: measured)
    }

    init(sex: Sex, age: Int, heightCm: Double, weightKg: Double, goal: FitnessGoal, health: HealthAnswers,
         daysPerWeek: Int, activity: DailyActivity, pace: GoalPace?, targetWeightKg: Double?,
         measurements: BodyMeasurements?, measured: MeasuredActivity? = nil) {
        self.sex = sex
        self.age = age
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.goal = goal
        self.health = health
        self.daysPerWeek = daysPerWeek
        let activity = measured?.activity ?? activity
        self.activity = activity
        self.measured = measured

        let metres = heightCm / 100
        let bmi = Self.bmi(weightKg: weightKg, heightCm: heightCm)
        self.bmi = bmi
        bmiClass = age < 18 ? nil : BMIClass(bmi)
        healthyRange = (18.5 * metres * metres)...(24.9 * metres * metres)

        // Energy.
        bmr = Self.bmr(sex: sex, weightKg: weightKg, heightCm: heightCm, age: age)
        activityLevel = Self.activityLevel(daysPerWeek: daysPerWeek, activity: activity)
        activityFactor = Self.activityFactors[activityLevel]
        tdee = bmr * activityFactor

        var extra = 0.0
        if health.isPregnant {
            extra = (health.trimester ?? 1) >= 3 ? 452 : (health.trimester ?? 1) == 2 ? 340 : 0
        } else if health.isBreastfeeding {
            extra = (health.postpartumStage ?? .underSixWeeks).breastfeedingCalories
        }
        extraCalories = extra

        var limits: [Limit] = []
        var effective = goal
        if health.isPregnant {
            effective = .getFit
            if goal != .getFit { limits.append(.pregnancy) }
        } else if goal == .loseWeight || goal == .recomp {
            if age < 18 { effective = .getFit; limits.append(.teen) }
            else if bmi < 18.5 { effective = .getFit; limits.append(.underweight) }
        }
        if effective.hasTarget, let reachedTarget = targetWeightKg,
           effective == .loseWeight ? weightKg <= reachedTarget : weightKg >= reachedTarget {
            effective = .getFit
            limits.append(.targetReached)
        }
        effectiveGoal = effective

        let maintenance = tdee + extra
        let floor = Self.calorieFloor(sex)
        let rate = goal.hasTarget ? Self.rate(goal: goal, pace: pace ?? .steady) : nil
        var adjustment = 0.0
        /// The cap or floor that set the deficit last; only that one is
        /// reported, since an earlier cap no longer binds once a later one
        /// lowers the deficit further.
        var binding: Limit?
        /// Holds the deficit up at the calorie floor. When what the body
        /// burns is already under the floor, there is no deficit at all.
        func applyFloor(_ deficit: inout Double) {
            guard maintenance - deficit < floor else { return }
            if maintenance > floor {
                deficit = maintenance - floor
                binding = .floor(floor)
            } else {
                deficit = 0
                binding = .belowFloor(floor)
            }
        }
        switch effective {
        case .loseWeight:
            var deficit = (rate ?? 0) * weightKg * Self.kcalPerKg / 7
            if deficit > 0.25 * tdee { deficit = 0.25 * tdee; binding = .deficitCap }
            if health.isBreastfeeding, deficit > 0.5 * Self.kcalPerKg / 7 {
                deficit = 0.5 * Self.kcalPerKg / 7
                binding = .breastfeedingCap
            }
            applyFloor(&deficit)
            adjustment = -deficit
        case .buildMuscle:
            var surplus = (rate ?? 0) * weightKg * Self.kcalPerKg / 7
            if surplus > 0.20 * tdee { surplus = 0.20 * tdee; binding = .surplusCap }
            adjustment = surplus
        case .recomp:
            var deficit = 0.10 * tdee
            applyFloor(&deficit)
            adjustment = -deficit
        case .getFit:
            adjustment = 0
        }
        if let binding { limits.append(binding) }
        self.adjustment = adjustment
        self.limits = limits
        let calories = ((maintenance + adjustment) / 10).rounded() * 10
        self.calories = calories

        // Weight change.
        self.pace = goal.hasTarget ? (pace ?? .steady) : nil
        chosenRate = rate
        let weekly = effective.hasTarget ? adjustment * 7 / Self.kcalPerKg / weightKg : 0
        weeklyRate = weekly
        let target = effective.hasTarget ? targetWeightKg : nil
        self.targetWeightKg = target
        var trajectory = [weightKg]
        var weeks: Int? = nil
        if let target, weekly != 0, (weekly < 0) == (target < weightKg) {
            var weight = weightKg
            var count = 0
            while (weekly < 0 ? weight > target : weight < target) && count < 520 {
                weight *= 1 + weekly
                count += 1
                trajectory.append(weekly < 0 ? max(weight, target) : min(weight, target))
            }
            // Ten years without reaching it is no date to promise.
            let reached = weekly < 0 ? weight <= target : weight >= target
            weeks = reached ? count : nil
            if !reached { trajectory = [weightKg] }
        }
        weeksToTarget = weeks
        self.trajectory = trajectory

        // Protein, fat, carbs.
        let basis = bmi >= 30 ? 25 * metres * metres : weightKg
        proteinBasisKg = basis
        var perKg: Double
        var rule = ProteinRule.goal
        switch effective {
        case .loseWeight: perKg = 2.0
        case .recomp: perKg = 2.2
        case .buildMuscle: perKg = 1.8
        case .getFit: perKg = 1.6
        }
        if age >= 65 && perKg < 1.2 { perKg = 1.2; rule = .olderAdult }
        if health.isPregnant { perKg = 1.1; rule = .pregnancy }
        if health.has(.kidneyDisease) { perKg = 0.8; rule = .kidney }
        proteinRule = rule
        proteinPerKg = perKg
        let protein = (perKg * basis).rounded()
        self.protein = protein
        var fat = max(0.25 * calories / 9, 0.6 * basis)
        fat = min(max(fat, 0.20 * calories / 9), 0.35 * calories / 9)
        fat = fat.rounded()
        self.fat = fat
        carbs = max(0, ((calories - protein * 4 - fat * 9) / 4).rounded())
        fiber = (14 * calories / 1000).rounded()

        // Body fat.
        bodyFat = Self.bodyFat(sex: sex, age: age, bmi: bmi, heightCm: heightCm, measurements: measurements)
        waistToHeight = measurements?.waistCm.map { $0 / heightCm }
    }

    // MARK: - Formulas

    /// Mifflin-St Jeor.
    static func bmr(sex: Sex, weightKg: Double, heightCm: Double, age: Int) -> Double {
        10 * weightKg + 6.25 * heightCm - 5 * Double(age) + sexConstant(sex)
    }

    static func sexConstant(_ sex: Sex) -> Double {
        switch sex {
        case .male: return 5
        case .female: return -161
        case .unspecified: return -78
        }
    }

    /// Training 2-3 days a week is level 1, 4-5 level 2, 6 level 3; the day
    /// outside the gym adds its own levels, up to 4.
    static func activityLevel(daysPerWeek: Int, activity: DailyActivity) -> Int {
        let training = daysPerWeek >= 6 ? 3 : daysPerWeek >= 4 ? 2 : daysPerWeek >= 1 ? 1 : 0
        return min(4, training + activity.extraLevels)
    }

    static func calorieFloor(_ sex: Sex) -> Double {
        switch sex {
        case .female: return 1_200
        case .male: return 1_500
        case .unspecified: return 1_350
        }
    }

    /// A fraction of body weight a week.
    static func rate(goal: FitnessGoal, pace: GoalPace) -> Double {
        switch (goal, pace) {
        case (.loseWeight, .slow): return 0.005
        case (.loseWeight, .steady): return 0.0075
        case (.loseWeight, .fast): return 0.01
        case (.buildMuscle, .slow): return 0.0025
        case (.buildMuscle, _): return 0.005
        default: return 0
        }
    }

    /// The paces on offer: no 1% a week below a BMI of 22 or while
    /// breastfeeding; gaining has two.
    static func paces(goal: FitnessGoal, bmi: Double, health: HealthAnswers) -> [GoalPace] {
        switch goal {
        case .loseWeight: return bmi < 22 || health.isBreastfeeding ? [.slow, .steady] : [.slow, .steady, .fast]
        case .buildMuscle: return [.slow, .steady]
        default: return []
        }
    }

    /// Steady for losing; for gaining, 0.5% for beginners and 0.25% once
    /// trained (Iraki et al. 2019: advanced lifters gain slower).
    static func recommendedPace(goal: FitnessGoal, experience: TrainingExperience?) -> GoalPace {
        goal == .buildMuscle && experience != .beginner ? .slow : .steady
    }

    /// BMI to one decimal, the precision the WHO bands are written in, so the
    /// class always matches the number shown (64 kg at 1.60 m is 25.0, not
    /// 24.999…).
    static func bmi(weightKg: Double, heightCm: Double) -> Double {
        let metres = heightCm / 100
        guard metres > 0 else { return 0 }
        return (weightKg / (metres * metres) * 10).rounded() / 10
    }

    /// The goals on offer: Stay fit only while pregnant; no deficit under 18
    /// or below a BMI of 18.5; and no Lose fat unless there's a whole-unit
    /// target below the current weight that keeps the BMI at 18.5 or more.
    static func goals(age: Int, weightKg: Double, heightCm: Double, health: HealthAnswers,
                      unit: WeightUnit) -> [FitnessGoal] {
        if health.isPregnant { return [.getFit] }
        let bmi = bmi(weightKg: weightKg, heightCm: heightCm)
        guard age >= 18, bmi >= 18.5 else { return [.buildMuscle, .getFit] }
        guard targetBounds(goal: .loseWeight, weightKg: weightKg, heightCm: heightCm, unit: unit) != nil else {
            return [.buildMuscle, .recomp, .getFit]
        }
        return [.loseWeight, .buildMuscle, .recomp, .getFit]
    }

    /// The targets the wheel offers, in whole units of `unit`: losing, at
    /// least 1 kg below now and never under a BMI of 18.5; gaining, 1 to
    /// 30 kg above now. Nil when no whole value fits.
    static func targetBounds(goal: FitnessGoal, weightKg: Double, heightCm: Double,
                             unit: WeightUnit) -> ClosedRange<Int>? {
        let squared = pow(heightCm / 100, 2)
        let low: Int, high: Int
        switch goal {
        case .loseWeight:
            low = Int(unit.fromKilograms(18.5 * squared).rounded(.up))
            high = Int(unit.fromKilograms(weightKg - 1).rounded(.down))
        case .buildMuscle:
            low = Int(unit.fromKilograms(weightKg + 1).rounded(.up))
            high = Int(unit.fromKilograms(weightKg + 30).rounded(.down))
        default:
            return nil
        }
        return low <= high ? low...high : nil
    }

    /// The target weight onboarding suggests, in whole units of `unit` and
    /// inside `targetBounds`. Losing from a BMI of 25: the top of the healthy
    /// range, or 10% off if that's closer (NHLBI 1998's first milestone);
    /// below 25: 5% off, not under BMI 20. Gaining: 5% on.
    static func suggestedTarget(goal: FitnessGoal, weightKg: Double, heightCm: Double,
                                unit: WeightUnit) -> Int? {
        guard let bounds = targetBounds(goal: goal, weightKg: weightKg, heightCm: heightCm, unit: unit) else {
            return nil
        }
        let squared = pow(heightCm / 100, 2)
        let kg: Double
        switch goal {
        case .loseWeight:
            kg = bmi(weightKg: weightKg, heightCm: heightCm) >= 25
                ? max(24.9 * squared, 0.9 * weightKg)
                : max(0.95 * weightKg, 20 * squared)
        case .buildMuscle:
            kg = weightKg * 1.05
        default:
            return nil
        }
        let value = Int(unit.fromKilograms(kg).rounded())
        return min(max(value, bounds.lowerBound), bounds.upperBound)
    }

    static func bodyFat(sex: Sex, age: Int, bmi: Double, heightCm: Double,
                        measurements: BodyMeasurements?) -> BodyFat? {
        if let entered = measurements?.bodyFatPercent {
            return BodyFat(percent: entered, method: .entered)
        }
        if let waist = measurements?.waistCm, let neck = measurements?.neckCm, waist > neck {
            var percent: Double?
            switch sex {
            case .male:
                percent = 495 / (1.0324 - 0.19077 * log10(waist - neck) + 0.15456 * log10(heightCm)) - 450
            case .female:
                if let hip = measurements?.hipCm, waist + hip > neck {
                    percent = 495 / (1.29579 - 0.35004 * log10(waist + hip - neck) + 0.22100 * log10(heightCm)) - 450
                }
            case .unspecified:
                percent = nil
            }
            if let percent, percent.isFinite {
                return BodyFat(percent: min(max(percent, 3), 60), method: .navy)
            }
        }
        // Deurenberg's adult formula; none for under-18s.
        guard age >= 18 else { return nil }
        let sexTerm: Double = sex == .male ? 1 : sex == .female ? 0 : 0.5
        let percent = 1.2 * bmi + 0.23 * Double(age) - 10.8 * sexTerm - 5.4
        return BodyFat(percent: min(max(percent, 3), 60), method: .deurenberg)
    }

    // MARK: - Reading

    /// Kilograms a week the calories move the weight, signed.
    var weeklyChangeKg: Double { weeklyRate * weightKg }

    func targetDate(from now: Date = Date(), calendar: Calendar = .current) -> Date? {
        weeksToTarget.flatMap { calendar.date(byAdding: .day, value: $0 * 7, to: now) }
    }

    /// Calories that a pace would give, for the pace question's live numbers.
    func withPace(_ pace: GoalPace) -> NutritionPlan {
        NutritionPlan(sex: sex, age: age, heightCm: heightCm, weightKg: weightKg, goal: goal, health: health,
                      daysPerWeek: daysPerWeek, activity: activity, pace: pace, targetWeightKg: targetWeightKg,
                      measurements: nil, measured: measured)
    }
}
