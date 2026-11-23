//
//  HealthModels.swift
//  GymWorkout
//
//  The onboarding answers behind the calorie, macro and safety plan
//  (2026-11-21): how active the day is, how fast to move toward a target
//  weight, joint pain, health conditions, pregnancy and the months after a
//  birth, a short safety screen, and optional body measurements. All of it
//  only shapes suggestions and general guidance — it never diagnoses and
//  never locks an exercise away. Stored on `UserProfile` as optionals, so
//  profiles saved before these questions still load.
//

import Foundation

/// How active the day is outside workouts.
enum DailyActivity: String, Codable, CaseIterable, Identifiable {
    case sitting, onFeet, physical

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sitting: return String(localized: "Mostly sitting", comment: "Daily activity outside workouts")
        case .onFeet: return String(localized: "On my feet a lot", comment: "Daily activity outside workouts")
        case .physical: return String(localized: "Heavy physical work", comment: "Daily activity outside workouts")
        }
    }

    var detail: String {
        switch self {
        case .sitting: return String(localized: "Desk job, studying, driving. Few steps outside workouts.")
        case .onFeet: return String(localized: "Teaching, retail, nursing, waiting tables — standing and walking much of the day.")
        case .physical: return String(localized: "Construction, farm or warehouse work, carrying loads most of the day.")
        }
    }

    /// Activity levels this adds on top of the training days (see
    /// `NutritionPlan.activityLevel`).
    var extraLevels: Int {
        switch self {
        case .sitting: return 0
        case .onFeet: return 1
        case .physical: return 2
        }
    }
}

/// How fast to move toward the target weight. Losing: 0.5, 0.75 or 1% of
/// body weight a week; gaining: 0.25 or 0.5% (see `NutritionPlan`).
enum GoalPace: String, Codable, CaseIterable, Identifiable {
    case slow, steady, fast

    var id: String { rawValue }
}

/// Pain or an injury that changes which exercises are suggested.
enum JointIssue: String, Codable, CaseIterable, Identifiable {
    case knee, lowerBack, shoulder, wristElbow

    var id: String { rawValue }

    var title: String {
        switch self {
        case .knee: return String(localized: "Knee pain", comment: "Joint issue")
        case .lowerBack: return String(localized: "Lower back pain", comment: "Joint issue")
        case .shoulder: return String(localized: "Shoulder pain", comment: "Joint issue")
        case .wristElbow: return String(localized: "Wrist or elbow pain", comment: "Joint issue")
        }
    }

    var symbol: String {
        switch self {
        case .knee: return "figure.walk"
        case .lowerBack: return "figure.cooldown"
        case .shoulder: return "figure.arms.open"
        case .wristElbow: return "hand.raised"
        }
    }
}

/// Health conditions that change the plan. Pregnancy and the months after a
/// birth are asked on their own page, early, since they decide the goal.
enum HealthCondition: String, Codable, CaseIterable, Identifiable {
    case highBloodPressure, heartDisease, diabetes, kidneyDisease, osteoporosis, pregnancy, postpartum

    var id: String { rawValue }

    /// The conditions the health page lists.
    static let listed: [HealthCondition] = [.highBloodPressure, .heartDisease, .diabetes, .kidneyDisease, .osteoporosis]

    var title: String {
        switch self {
        case .highBloodPressure: return String(localized: "High blood pressure", comment: "Health condition")
        case .heartDisease: return String(localized: "Heart condition", comment: "Health condition")
        case .diabetes: return String(localized: "Diabetes", comment: "Health condition")
        case .kidneyDisease: return String(localized: "Kidney disease", comment: "Health condition")
        case .osteoporosis: return String(localized: "Osteoporosis or low bone density", comment: "Health condition")
        case .pregnancy: return String(localized: "Pregnant", comment: "Health condition")
        case .postpartum: return String(localized: "Gave birth in the last year", comment: "Health condition")
        }
    }

    var symbol: String {
        switch self {
        case .highBloodPressure: return "gauge.with.dots.needle.67percent"
        case .heartDisease: return "heart"
        case .diabetes: return "drop"
        case .kidneyDisease: return "cross.case"
        case .osteoporosis: return "figure.stand"
        case .pregnancy: return "figure.stand.dress"
        case .postpartum: return "figure.and.child.holdinghands"
        }
    }
}

/// A short safety screen, after the PAR-Q+ (2023). Any of these means
/// "talk to a doctor before you start".
enum ScreeningFlag: String, Codable, CaseIterable, Identifiable {
    case chestPain, dizziness, supervisedOnly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .chestPain:
            return String(localized: "I get chest pain at rest, in daily life or when I'm active")
        case .dizziness:
            return String(localized: "I've lost my balance from dizziness, or fainted, in the last 12 months")
        case .supervisedOnly:
            return String(localized: "A doctor said I should only exercise under medical supervision")
        }
    }
}

/// How long ago the birth was.
enum PostpartumStage: String, Codable, CaseIterable, Identifiable {
    case underSixWeeks, underThreeMonths, underSixMonths, underTwelveMonths

    var id: String { rawValue }

    var title: String {
        switch self {
        case .underSixWeeks: return String(localized: "Less than 6 weeks ago")
        case .underThreeMonths: return String(localized: "6 weeks to 3 months ago")
        case .underSixMonths: return String(localized: "3 to 6 months ago")
        case .underTwelveMonths: return String(localized: "6 to 12 months ago")
        }
    }

    /// Breastfeeding's extra energy: 330 kcal a day for the first six
    /// months, 400 after (IOM 2005).
    var breastfeedingCalories: Double {
        self == .underTwelveMonths ? 400 : 330
    }

    /// Running and jumping wait until at least 12 weeks after the birth
    /// (Goom, Donnelly & Brockwell 2019).
    var isBeforeImpact: Bool { self == .underSixWeeks || self == .underThreeMonths }
}

/// The health answers.
struct HealthAnswers: Codable, Hashable {
    var joints: [JointIssue] = []
    /// Including pregnancy and the months after a birth.
    var conditions: [HealthCondition] = []
    /// High blood pressure kept under 160/100. Nil when not asked or not
    /// sure — treated as not controlled.
    var bloodPressureControlled: Bool? = nil
    /// 1, 2 or 3 while pregnant.
    var trimester: Int? = nil
    var postpartumStage: PostpartumStage? = nil
    /// A doctor or midwife has cleared exercise after the birth.
    var postpartumCleared: Bool? = nil
    var breastfeeding: Bool? = nil
    var screening: [ScreeningFlag] = []

    func has(_ condition: HealthCondition) -> Bool { conditions.contains(condition) }
    func has(_ joint: JointIssue) -> Bool { joints.contains(joint) }

    var isPregnant: Bool { has(.pregnancy) }
    var isPostpartum: Bool { has(.postpartum) }
    var isBreastfeeding: Bool { isPostpartum && breastfeeding == true }
    /// After a birth and not yet cleared to exercise, or under six weeks.
    var isPostpartumUncleared: Bool {
        isPostpartum && (postpartumCleared != true || postpartumStage == .underSixWeeks)
    }

    /// Reasons to see a doctor before starting, in the order they are shown.
    var clearanceReasons: [ClearanceReason] {
        var reasons: [ClearanceReason] = screening.map { .screening($0) }
        if has(.heartDisease) { reasons.append(.heartDisease) }
        if has(.highBloodPressure) && bloodPressureControlled != true { reasons.append(.bloodPressure) }
        if isPregnant { reasons.append(.pregnancy) }
        if isPostpartumUncleared { reasons.append(.postpartum) }
        return reasons
    }
}

/// Why the plan opens with "check with your doctor first".
enum ClearanceReason: Hashable {
    case screening(ScreeningFlag)
    case heartDisease, bloodPressure, pregnancy, postpartum

    var text: String {
        switch self {
        case .screening(.chestPain): return String(localized: "You get chest pain.")
        case .screening(.dizziness): return String(localized: "You've had dizziness or fainting in the last year.")
        case .screening(.supervisedOnly): return String(localized: "A doctor asked you to exercise only under supervision.")
        case .heartDisease: return String(localized: "You have a heart condition.")
        case .bloodPressure: return String(localized: "Your blood pressure isn't under control yet, or you're not sure.")
        case .pregnancy: return String(localized: "You're pregnant: get your doctor's or midwife's OK.")
        case .postpartum: return String(localized: "You haven't had your after-birth check-up, or it's less than 6 weeks since the birth.")
        }
    }
}

/// Optional measurements for the body-fat estimate.
struct BodyMeasurements: Codable, Hashable {
    /// From a smart scale or a scan, as the user typed it.
    var bodyFatPercent: Double? = nil
    var waistCm: Double? = nil
    var neckCm: Double? = nil
    /// Only for women's Navy formula.
    var hipCm: Double? = nil
}
