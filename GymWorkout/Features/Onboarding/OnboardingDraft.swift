//
//  OnboardingDraft.swift
//  GymWorkout
//
//  The answers while onboarding runs (2026-11-21): what each page edits,
//  which pages the answers call for, and the profile and plan they add up
//  to. Nothing is saved until the last page.
//

import Foundation
import Observation

@Observable
final class OnboardingDraft {

    enum Maternity: Hashable { case no, pregnant, postpartum }
    enum BodyFatMode: Hashable { case skip, known, tape }

    var sex: Sex?
    /// Asked unless the answer to sex is Male.
    var maternity: Maternity?
    var trimester: Int?
    var postpartumStage: PostpartumStage?
    var postpartumCleared: Bool?
    var breastfeeding: Bool?

    var birthYear: Int = OnboardingDraft.currentYear - 30
    var unit: WeightUnit = .kg
    var heightCm: Double = 170
    var weightKg: Double = 70
    /// Height and weight were set by hand, so picking a sex no longer
    /// changes their starting values.
    var bodyTouched = false

    var goal: FitnessGoal?
    var targetWeightKg: Double?
    var pace: GoalPace?

    var activity: DailyActivity?
    var experience: TrainingExperience?
    var daysPerWeek: Int?
    var weekdays: Set<Int> = []
    var split: TrainingSplit?
    /// A Custom split's days (2026-11-27), edited in `ScheduleEditorView`.
    var customDays: [ScheduleDay] = []
    /// The schedule of the profile being edited, so re-running onboarding
    /// keeps its By-date picks and its rotation's start.
    var savedSchedule: TrainingSchedule?

    var joints: Set<JointIssue> = []
    var jointsNone = false
    /// The listed conditions; pregnancy and the months after a birth come
    /// from `maternity`.
    var conditions: Set<HealthCondition> = []
    var conditionsNone = false
    var bloodPressureControlled: Bool?
    var screening: Set<ScreeningFlag> = []
    var screeningNone = false

    var bodyFatMode: BodyFatMode = .skip
    var bodyFatPercent: Double = 20
    var waistCm: Double = 84
    var neckCm: Double = 37
    var hipCm: Double = 98

    /// Onboarding doesn't ask for a name; editing keeps the one from Profile.
    var name: String?

    /// Editing a saved plan with Apple Health's steps setting the daily
    /// activity (`AppleHealth.measuredActivity`): the numbers here are
    /// then the ones Today shows after Save. Display only — never part of
    /// `profile`, never saved; nil for a new user, whose answer counts.
    var measured: MeasuredActivity?

    static var currentYear: Int { Calendar.current.component(.year, from: Date()) }

    // MARK: - Derived

    var age: Int { Self.currentYear - birthYear }

    /// To one decimal, as the plan reads it.
    var bmi: Double { NutritionPlan.bmi(weightKg: weightKg, heightCm: heightCm) }

    var asksMaternity: Bool { sex != nil && sex != .male }
    var isPregnant: Bool { asksMaternity && maternity == .pregnant }
    var isPostpartum: Bool { asksMaternity && maternity == .postpartum }

    var health: HealthAnswers {
        var answers = HealthAnswers()
        answers.joints = jointsNone ? [] : JointIssue.allCases.filter(joints.contains)
        var conditions = conditionsNone ? [] : HealthCondition.listed.filter(self.conditions.contains)
        if isPregnant { conditions.append(.pregnancy) }
        if isPostpartum { conditions.append(.postpartum) }
        answers.conditions = conditions
        if conditions.contains(.highBloodPressure) { answers.bloodPressureControlled = bloodPressureControlled }
        if isPregnant { answers.trimester = trimester }
        if isPostpartum {
            answers.postpartumStage = postpartumStage
            answers.postpartumCleared = postpartumCleared
            answers.breastfeeding = breastfeeding
        }
        answers.screening = screeningNone ? [] : ScreeningFlag.allCases.filter(screening.contains)
        return answers
    }

    var measurements: BodyMeasurements? {
        switch bodyFatMode {
        case .skip: return nil
        case .known: return BodyMeasurements(bodyFatPercent: bodyFatPercent)
        case .tape:
            return BodyMeasurements(waistCm: waistCm, neckCm: neckCm, hipCm: sex == .female ? hipCm : nil)
        }
    }

    /// The goals the answers allow (see `NutritionPlan.goals`).
    var goalOptions: [FitnessGoal] {
        NutritionPlan.goals(age: age, weightKg: weightKg, heightCm: heightCm, health: health, unit: unit)
    }

    /// The goal the plan follows: Stay fit while pregnant, or a picked goal
    /// the answers no longer allow.
    var effectiveGoal: FitnessGoal? {
        if isPregnant { return .getFit }
        guard let goal, goalOptions.contains(goal) else { return nil }
        return goal
    }

    var paceOptions: [GoalPace] {
        guard let goal = effectiveGoal else { return [] }
        return NutritionPlan.paces(goal: goal, bmi: bmi, health: health)
    }

    /// The target wheel's values, in whole units of the chosen unit.
    var targetBounds: ClosedRange<Int>? {
        effectiveGoal.flatMap {
            NutritionPlan.targetBounds(goal: $0, weightKg: weightKg, heightCm: heightCm, unit: unit)
        }
    }

    /// The suggestion, in whole units of the chosen unit, on the wheel.
    var suggestedTargetValue: Int? {
        effectiveGoal.flatMap {
            NutritionPlan.suggestedTarget(goal: $0, weightKg: weightKg, heightCm: heightCm, unit: unit)
        }
    }

    /// The target the wheel shows, in whole units: the one picked while it
    /// still fits the goal and weight, else the suggestion.
    var currentTargetValue: Int? {
        guard let bounds = targetBounds else { return nil }
        if let targetWeightKg {
            let value = Int(unit.fromKilograms(targetWeightKg).rounded())
            if bounds.contains(value) { return value }
        }
        return suggestedTargetValue
    }

    /// The same target in kilograms — what the plan uses and what's saved —
    /// so the wheel, the text, the results and the profile always agree.
    var currentTarget: Double? {
        guard let goal = effectiveGoal, goal.hasTarget, let value = currentTargetValue else { return nil }
        return unit.toKilograms(Double(value))
    }

    var currentPace: GoalPace? {
        guard let goal = effectiveGoal, goal.hasTarget else { return nil }
        if let pace, paceOptions.contains(pace) { return pace }
        return NutritionPlan.recommendedPace(goal: goal, experience: experience)
    }

    /// The profile the answers make; nil until the required ones are in.
    var profile: UserProfile? {
        guard let sex, let goal = effectiveGoal else { return nil }
        // `split` only takes a split older builds know; the schedule below
        // holds the real one (see `TrainingSplit.legacy`).
        var profile = UserProfile(sex: sex, goal: goal, heightCm: heightCm, weightKg: weightKg,
                                  daysPerWeek: daysPerWeek, split: split?.legacy, name: name)
        profile.birthYear = birthYear
        profile.activity = activity
        profile.targetWeightKg = currentTarget
        profile.pace = currentPace
        if let days = daysPerWeek {
            if weekdays.isEmpty, keepsDatesOnly {
                // A By-date plan of single dates stays that way.
                profile.weekdays = []
            } else {
                profile.weekdays = weekdays.count == days ? weekdays.sorted()
                                                          : ProgramAdvisor.suggestedWeekdays(daysPerWeek: days)
            }
        }
        profile.health = health
        profile.measurements = measurements
        if let split { profile.apply(schedule(split: split, weekdays: profile.weekdays ?? [])) }
        return profile
    }

    /// The saved schedule has no training weekdays (By-date single dates, or
    /// the flexible plan): editing the profile keeps it that way instead of
    /// adding suggested weekdays.
    private var keepsDatesOnly: Bool {
        guard let savedSchedule else { return false }
        return savedSchedule.weekdays.isEmpty
    }

    /// The answers as a weekly schedule, on top of the saved one. A changed
    /// rotation counts from this week, so this week reads as the plan page
    /// shows it.
    private func schedule(split: TrainingSplit, weekdays: [Int]) -> TrainingSchedule {
        var schedule = savedSchedule ?? TrainingSchedule()
        let changed = savedSchedule == nil || schedule.split != split
            || Set(schedule.weekdays) != Set(weekdays) || schedule.customDays != customDays
        schedule.split = split
        schedule.weekdays = weekdays
        schedule.customDays = customDays
        if changed || schedule.anchor == nil {
            let calendar = Calendar.current
            schedule.anchor = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? calendar.startOfDay(for: Date())
        }
        return schedule
    }

    /// With `measured`, as Today works it out; the pace page's numbers
    /// (`withPace`) carry it too.
    var plan: NutritionPlan? {
        profile.flatMap { NutritionPlan(profile: $0, measured: measured) }
    }

    // MARK: - Editing

    /// A closer starting point for the height and weight wheels once a sex
    /// is picked; still just a start.
    func applySexDefaults() {
        guard !bodyTouched else { return }
        heightCm = sex == .female ? 162 : sex == .male ? 176 : 170
        weightKg = sex == .female ? 60 : sex == .male ? 75 : 68
    }

    /// A new number of days brings its own spread of weekdays and split.
    func setDays(_ days: Int) {
        guard daysPerWeek != days else { return }
        daysPerWeek = days
        weekdays = Set(ProgramAdvisor.suggestedWeekdays(daysPerWeek: days))
        // Custom stays Custom: the user built those days themselves.
        if split != .custom { split = ProgramAdvisor.recommendedSplit(daysPerWeek: days, experience: experience) }
    }

    func toggle(_ joint: JointIssue) {
        jointsNone = false
        if joints.contains(joint) { joints.remove(joint) } else { joints.insert(joint) }
    }

    func toggle(_ condition: HealthCondition) {
        conditionsNone = false
        if conditions.contains(condition) { conditions.remove(condition) } else { conditions.insert(condition) }
    }

    func toggle(_ flag: ScreeningFlag) {
        screeningNone = false
        if screening.contains(flag) { screening.remove(flag) } else { screening.insert(flag) }
    }

    /// Fills the draft from a saved profile, to edit it.
    func load(_ profile: UserProfile, experience: TrainingExperience, unit: WeightUnit) {
        self.unit = unit
        self.experience = experience
        sex = profile.sex
        goal = profile.goal
        heightCm = profile.heightCm
        weightKg = profile.weightKg
        bodyTouched = true
        // Nil for profiles from before these questions, which then have to
        // be answered.
        daysPerWeek = profile.daysPerWeek
        split = profile.schedule?.split ?? profile.split
        savedSchedule = profile.schedule
        customDays = profile.schedule?.customDays ?? []
        if let days = profile.daysPerWeek {
            // A By-date schedule with no weekly days has none to fill in.
            weekdays = Set(profile.weekdays ?? (keepsDatesOnly ? [] : ProgramAdvisor.suggestedWeekdays(daysPerWeek: days)))
        }
        name = profile.name
        if let year = profile.birthYear { birthYear = year }
        activity = profile.activity
        targetWeightKg = profile.targetWeightKg
        pace = profile.pace
        if let health = profile.health {
            joints = Set(health.joints)
            jointsNone = health.joints.isEmpty
            conditions = Set(health.conditions.filter(HealthCondition.listed.contains))
            conditionsNone = conditions.isEmpty
            bloodPressureControlled = health.bloodPressureControlled
            screening = Set(health.screening)
            screeningNone = health.screening.isEmpty
            if profile.sex != .male {
                maternity = health.isPregnant ? .pregnant : health.isPostpartum ? .postpartum : .no
            }
            trimester = health.trimester
            postpartumStage = health.postpartumStage
            postpartumCleared = health.postpartumCleared
            breastfeeding = health.breastfeeding
        }
        if let measurements = profile.measurements {
            if let percent = measurements.bodyFatPercent {
                bodyFatMode = .known
                bodyFatPercent = percent
            } else if let waist = measurements.waistCm, let neck = measurements.neckCm {
                bodyFatMode = .tape
                waistCm = waist
                neckCm = neck
                if let hip = measurements.hipCm { hipCm = hip }
            }
        }
    }
}
