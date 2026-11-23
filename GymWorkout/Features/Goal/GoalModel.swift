//
//  GoalModel.swift
//  GymWorkout
//
//  The member's goal (2026-11-23): the look they picked for their goal
//  photo, where they started, and an estimate of where they are now, how
//  long is left and whether their training keeps them on course. The owner
//  picked the measure: the weigh-ins plus the body-fat estimate, with
//  muscle read as estimated lean mass, and the time left at realistic rates
//  scaled by how regularly they train. Everything here stays on the phone.
//

import Foundation
import Observation
import UIKit
import UserNotifications

// MARK: - The look the member picks

/// Who the goal photo shows, as the member picks it. The raw values are
/// what the server reads (functions/src/goalPhoto.ts).
enum GoalSex: String, Codable, CaseIterable, Identifiable, Sendable {
    case male, female

    var id: String { rawValue }

    var title: String {
        switch self {
        case .male: return String(localized: "Male")
        case .female: return String(localized: "Female")
        }
    }

    /// The profile's answer, when it is one of the two.
    init?(_ sex: Sex?) {
        switch sex {
        case .male: self = .male
        case .female: self = .female
        default: return nil
        }
    }
}

/// How much muscle the goal shows. The server words each level per sex
/// (goalPhoto.ts); `leanGainKg` is the middle of what those words show, for
/// the time-to-goal estimate. Change both together.
enum MuscleTarget: String, Codable, CaseIterable, Identifiable, Sendable {
    case same, toned, muscular, strong

    var id: String { rawValue }

    /// A segment of the setup's picker, so the words stay short. `strong`
    /// has a key of its own: "Strong" is also a Balance word.
    var title: String {
        switch self {
        case .same:
            return String(localized: "Same",
                          comment: "Goal photo muscle level: keep the muscle you have. A segment of a picker of 4: keep it short")
        case .toned:
            return String(localized: "Toned",
                          comment: "Goal photo muscle level: a little more muscle. A segment of a picker of 4: keep it short")
        case .muscular:
            return String(localized: "Muscular",
                          comment: "Goal photo muscle level: noticeably more muscle. A segment of a picker of 4: keep it short")
        case .strong:
            return String(localized: "goal.muscle.strong", defaultValue: "Strong",
                          comment: "Goal photo muscle level: a lot more muscle (not the Balance word Strong). A segment of a picker of 4: keep it short")
        }
    }

    func detail(for sex: GoalSex) -> String {
        switch (self, sex) {
        case (.same, _):
            return String(localized: "The muscle you have now.")
        case (.toned, .male):
            return String(localized: "A little more muscle: firmer shoulders, arms, chest and legs.")
        case (.toned, .female):
            return String(localized: "A little more tone: firmer arms, shoulders and legs, rounder glutes.")
        case (.muscular, .male):
            return String(localized: "Noticeably more muscle: broader shoulders, a fuller chest, thicker arms.")
        case (.muscular, .female):
            return String(localized: "Noticeably more muscle: defined shoulders and arms, fuller glutes, stronger legs.")
        case (.strong, .male):
            return String(localized: "A lot more muscle, as after two to three years of serious training.")
        case (.strong, .female):
            return String(localized: "A lot more muscle, as after two to three years of serious training.")
        }
    }

    /// Lean mass the look adds, in kilograms.
    func leanGainKg(for sex: GoalSex) -> Double {
        switch (self, sex) {
        case (.same, _): return 0
        case (.toned, .male): return 2
        case (.toned, .female): return 1.25
        case (.muscular, .male): return 4.5
        case (.muscular, .female): return 2.5
        case (.strong, .male): return 8
        case (.strong, .female): return 4.5
        }
    }
}

/// How lean the goal shows, as body-fat bands per sex. The server words the
/// same bands (goalPhoto.ts). Change both together.
enum FatTarget: String, Codable, CaseIterable, Identifiable, Sendable {
    case same, fit, athletic, lean

    var id: String { rawValue }

    /// A segment of the setup's picker, like MuscleTarget's.
    var title: String {
        switch self {
        case .same:
            return String(localized: "Same",
                          comment: "Goal photo body-fat level: keep it as it is. A segment of a picker of up to 4: keep it short")
        case .fit:
            return String(localized: "Fit",
                          comment: "Goal photo body-fat level: a flatter stomach. A segment of a picker of up to 4: keep it short")
        case .athletic:
            return String(localized: "Athletic",
                          comment: "Goal photo body-fat level: abs faintly showing. A segment of a picker of up to 4: keep it short")
        case .lean:
            return String(localized: "Lean",
                          comment: "Goal photo body-fat level: abs clearly showing. A segment of a picker of up to 4: keep it short")
        }
    }

    /// The body-fat band, in percent; nil for `same`.
    func range(for sex: GoalSex) -> ClosedRange<Double>? {
        switch (self, sex) {
        case (.same, _): return nil
        case (.fit, .male): return 15...17
        case (.fit, .female): return 22...25
        case (.athletic, .male): return 12...14
        case (.athletic, .female): return 19...21
        case (.lean, .male): return 9...11
        case (.lean, .female): return 16...18
        }
    }

    /// The middle of the band.
    func percent(for sex: GoalSex) -> Double? {
        range(for: sex).map { ($0.lowerBound + $0.upperBound) / 2 }
    }

    /// The band and what it shows, as one sentence each so the words can go
    /// in any order: "About 12–14% body fat: upper abs faintly showing, …".
    func detail(for sex: GoalSex) -> String {
        guard let range = range(for: sex) else { return String(localized: "The body fat you have now.") }
        let low = Int(range.lowerBound), high = Int(range.upperBound)
        switch (self, sex) {
        case (.fit, _):
            return String(localized: "About \(low)–\(high)% body fat: a flatter stomach, a trimmer waist.",
                          comment: "Goal photo body-fat level Fit and its band, e.g. About 15–17% body fat: …")
        case (.athletic, .male):
            return String(localized: "About \(low)–\(high)% body fat: upper abs faintly showing, a narrower waist.",
                          comment: "Goal photo body-fat level Athletic (men) and its band, e.g. About 12–14% body fat: …")
        case (.athletic, .female):
            return String(localized: "About \(low)–\(high)% body fat: a firm stomach, a faint line down the abs.",
                          comment: "Goal photo body-fat level Athletic (women) and its band, e.g. About 19–21% body fat: …")
        case (.lean, .male):
            return String(localized: "About \(low)–\(high)% body fat: a clear six-pack, a narrow waist.",
                          comment: "Goal photo body-fat level Lean (men) and its band, e.g. About 9–11% body fat: …")
        case (.lean, .female):
            return String(localized: "About \(low)–\(high)% body fat: visible ab lines, toned arms and legs.",
                          comment: "Goal photo body-fat level Lean (women) and its band, e.g. About 16–18% body fat: …")
        default:
            return String(localized: "About \(low)–\(high)% body fat.",
                          comment: "Goal photo body-fat band, e.g. About 12–14% body fat.")
        }
    }
}

/// The member's pick for a goal photo.
struct GoalLook: Codable, Hashable, Sendable {
    var sex: GoalSex
    var muscle: MuscleTarget
    var fat: FatTarget

    /// The server refuses a look that changes nothing.
    var changesSomething: Bool { muscle != .same || fat != .same }

    /// "Muscular · Athletic"
    var summary: String {
        [muscle == .same ? nil : muscle.title, fat == .same ? nil : fat.title].compactMap { $0 }.joined(separator: " · ")
    }

    /// The body-fat levels that make sense from where the member is: a band
    /// at or above their estimate would mean gaining fat; a band whose goal
    /// weight (today's lean mass plus the muscle the look adds, over one less
    /// the band) would fall under BMI 18.5 isn't offered (review F2); and
    /// someone underweight keeps their body fat.
    static func fatChoices(sex: GoalSex, currentPercent: Double?, weightKg: Double, heightCm: Double,
                           muscleGainKg: Double, underweight: Bool) -> [FatTarget] {
        guard !underweight else { return [.same] }
        let metres = heightCm / 100
        return FatTarget.allCases.filter { target in
            guard let range = target.range(for: sex), let current = currentPercent else { return true }
            guard range.upperBound < current else { return false }
            guard metres > 0, weightKg > 0, let middle = target.percent(for: sex) else { return true }
            let lean = weightKg * (1 - current / 100) + muscleGainKg
            let goalWeight = lean / (1 - middle / 100)
            return goalWeight / (metres * metres) >= 18.5
        }
    }

    /// The member's body-fat estimate for the sex the photo shows: an entered
    /// % as typed, else the tape or BMI formula worked out for that sex, so
    /// the start, the offered bands and the targets share one number (review
    /// GOAL-4). Nil under 18 or without a birth year.
    static func bodyFatEstimate(profile: UserProfile, sex: GoalSex, now: Date = Date()) -> Double? {
        guard let age = profile.age(at: now) else { return nil }
        return NutritionPlan.bodyFat(sex: sex == .male ? .male : .female, age: age, bmi: profile.bmi,
                                     heightCm: profile.heightCm, measurements: profile.measurements)?.percent
    }
}

// MARK: - The record

/// The goal, kept on this device next to its photo.
struct GoalRecord: Codable, Hashable, Sendable {
    var createdAt: Date
    var look: GoalLook
    /// Where the member started: their weight and body-fat estimate when the
    /// photo was made.
    var start: BodyPoint
    /// The point the estimate runs from: the start, or the last body-fat %
    /// the member entered since.
    var anchor: BodyPoint

    struct BodyPoint: Codable, Hashable, Sendable {
        var date: Date
        var weightKg: Double
        var bodyFatPercent: Double?
        /// The body-fat % the member typed (a smart scale or a scan), when the
        /// point came from one; a new entry moves the anchor. On the start, set
        /// once the start has been lined up with the member's first entry.
        var entered: Double?

        var leanKg: Double? { bodyFatPercent.map { weightKg * (1 - $0 / 100) } }
        var fatKg: Double? { bodyFatPercent.map { weightKg * $0 / 100 } }
    }

    init(look: GoalLook, profile: UserProfile, now: Date = Date()) {
        createdAt = now
        self.look = look
        let point = BodyPoint(date: now, weightKg: profile.weightKg,
                              bodyFatPercent: GoalLook.bodyFatEstimate(profile: profile, sex: look.sex, now: now),
                              entered: profile.measurements?.bodyFatPercent)
        start = point
        anchor = point
    }

    /// The record with its anchor moved to a body-fat % entered since, at
    /// today's weight; nil when nothing new was entered. `estimate` is the
    /// model's body-fat % just before the entry. A start that came from a
    /// formula is shifted by the gap between the two methods on the first
    /// entry, so switching to a scale's reading never counts as progress;
    /// only changes after it do (review GOAL-2).
    func reanchored(to profile: UserProfile, estimate: Double?, now: Date = Date()) -> GoalRecord? {
        guard let entered = profile.measurements?.bodyFatPercent, entered != anchor.entered else { return nil }
        var record = self
        if record.start.entered == nil {
            if let startPercent = record.start.bodyFatPercent {
                if let estimate { record.start.bodyFatPercent = min(60, max(3, startPercent + entered - estimate)) }
            } else {
                // No estimate at the start (the plan's answers were missing):
                // the first entry stands in for it.
                record.start.bodyFatPercent = entered
            }
            record.start.entered = entered
        }
        record.anchor = BodyPoint(date: now, weightKg: profile.weightKg, bodyFatPercent: entered, entered: entered)
        return record
    }
}

// MARK: - Schedule

/// The training days the plan sets: the weekdays picked, or only a number a
/// week in profiles saved before the weekdays question.
private struct GoalSchedule {
    let weekdays: Set<Int>
    let perWeek: Int

    init(profile: UserProfile) {
        let days = Set(profile.weekdays ?? [])
        weekdays = days
        perWeek = days.isEmpty ? (profile.daysPerWeek ?? 0) : days.count
    }

    /// Sessions due from `from` through `through` (start-of-day dates): the
    /// scheduled days themselves where the weekdays are known (review GOAL-6),
    /// else pro rata. Today counts only once it has a session.
    func planned(from: Date, through: Date, today: Date, trainedToday: Bool, calendar: Calendar) -> Double {
        guard perWeek > 0, from <= through else { return 0 }
        let days = (calendar.dateComponents([.day], from: from, to: through).day ?? 0) + 1
        if weekdays.isEmpty {
            let counted = through >= today && !trainedToday ? days - 1 : days
            return Double(perWeek) * Double(max(0, counted)) / 7
        }
        var count = 0.0
        var day = from
        while day <= through {
            let isToday = calendar.isDate(day, inSameDayAs: today)
            if weekdays.contains(calendar.component(.weekday, from: day)) && (!isToday || trainedToday) { count += 1 }
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        return count
    }

    /// Sessions done over sessions due, 0...1; 1 when nothing was due yet.
    func share(trainedDays: Set<Date>, from: Date, through: Date, today: Date, calendar: Calendar) -> Double {
        guard perWeek > 0 else { return 0 }
        let done = trainedDays.filter { $0 >= from && $0 <= through }.count
        let due = planned(from: from, through: through, today: today, trainedToday: trainedDays.contains(today),
                          calendar: calendar)
        return due > 0 ? min(1, Double(done) / due) : 1
    }
}

// MARK: - Progress

/// Where the member stands against their goal, worked out from the record,
/// the profile and the days they trained.
struct GoalProgress: Hashable, Sendable {
    enum Course: Hashable, Sendable {
        /// The first week: the estimate assumes the planned days.
        case starting
        case onTrack
        case behind
        /// So few sessions that the goal is hard to reach.
        case offTrack
        /// No training days set.
        case noSchedule
        /// The estimate has reached the goal.
        case reached
        /// Pregnant, before the after-birth check-up, under 19 or underweight:
        /// no targets, no countdown and no check-ins (review F1).
        case paused
    }

    struct Week: Hashable, Sendable {
        let start: Date
        let done: Int
        let planned: Int
        /// The week ended before the goal was made: not counted as missed.
        let beforeGoal: Bool

        /// What "x of y" counts to: never fewer than the sessions done.
        var goal: Int { max(planned, done) }
    }

    let look: GoalLook
    let weightKg: Double
    /// The current estimates; nil without a body-fat estimate.
    let bodyFatPercent: Double?
    let leanKg: Double?
    let startBodyFatPercent: Double?
    let startLeanKg: Double?
    /// Nil when the look keeps body fat, the member is already there, or the
    /// goal is paused.
    let targetBodyFatPercent: Double?
    /// Nil when the look keeps the muscle, or the goal is paused.
    let targetLeanKg: Double?
    let fatFraction: Double?
    let muscleFraction: Double?
    /// 0...1 across the parts the look changes.
    let fraction: Double
    /// Nil when it can't be said: no training days, too few sessions, paused.
    let weeksLeft: Int?
    let targetDate: Date?
    /// This week and the four before it, oldest first.
    let weeks: [Week]
    /// Sessions done against due over the last four weeks (since the goal,
    /// if newer), 0...1.
    let consistency: Double
    let course: Course

    var thisWeek: Week? { weeks.last }

    /// Whether the goal is set aside for now, from the same answers that
    /// keep a new goal photo from being made (GoalPhotoCard.canCreate) and
    /// the plan's underweight rule.
    static func isPaused(profile: UserProfile, plan: NutritionPlan?, now: Date = Date()) -> Bool {
        if let health = profile.health, health.isPregnant || health.isPostpartumUncleared { return true }
        if let age = profile.age(at: now), age < 19 { return true }
        if let plan { return plan.bmiClass == .under }
        return profile.bmi > 0 && profile.bmi < 18.5
    }

    // Rates. Fat in body-fat points a week from the deficit the plan's
    // calories give (review GOAL-7): losing a share r of body weight a week,
    // about 85% of it fat with training, lowers body fat by r × (0.85 − fat
    // share) points; without a deficit (maintenance, the calorie floor,
    // building) only training's slow change. Muscle in lean kilograms a week
    // by experience, for men (women about half), from the usual natural-gain
    // models (roughly 1, 0.5 and 0.25 kg a month).
    static func fatRate(plan: NutritionPlan?, goal: FitnessGoal, pace: GoalPace?, bodyFatPercent: Double) -> Double {
        let loss: Double
        if let plan {
            loss = -plan.weeklyRate
        } else if goal == .loseWeight {
            switch pace ?? .steady {
            case .slow: loss = 0.005
            case .steady: loss = 0.0075
            case .fast: loss = 0.01
            }
        } else {
            loss = 0
        }
        if loss > 0.0005 { return max(0.05, loss * (0.85 - bodyFatPercent / 100) * 100) }
        switch goal {
        case .recomp: return 0.15
        case .getFit, .loseWeight: return 0.08
        case .buildMuscle: return 0.03
        }
    }

    static func muscleRate(goal: FitnessGoal, experience: TrainingExperience, sex: GoalSex) -> Double {
        let base: Double
        switch experience {
        case .beginner: base = 0.23
        case .intermediate: base = 0.115
        case .advanced: base = 0.06
        }
        let byGoal: Double
        switch goal {
        case .buildMuscle: byGoal = 1
        case .recomp: byGoal = 0.75
        case .getFit: byGoal = 0.6
        case .loseWeight: byGoal = 0.5
        }
        return base * byGoal * (sex == .female ? 0.5 : 1)
    }

    init(record: GoalRecord, profile: UserProfile, experience: TrainingExperience, trainedDays: Set<Date>,
         now: Date = Date(), calendar: Calendar = .current) {
        look = record.look
        let sex = record.look.sex
        weightKg = profile.weightKg
        let today = calendar.startOfDay(for: now)
        let goalDay = calendar.startOfDay(for: record.createdAt)
        let plan = NutritionPlan(profile: profile, now: now)
        let goal = plan?.effectiveGoal ?? profile.goal
        let paused = Self.isPaused(profile: profile, plan: plan, now: now)
        let schedule = GoalSchedule(profile: profile)

        // Training: sessions done against the days the plan sets.
        var weeks: [Week] = []
        if let thisWeek = calendar.dateInterval(of: .weekOfYear, for: today) {
            for back in stride(from: 4, through: 0, by: -1) {
                guard let start = calendar.date(byAdding: .weekOfYear, value: -back, to: thisWeek.start),
                      let end = calendar.date(byAdding: .day, value: 7, to: start),
                      let last = calendar.date(byAdding: .day, value: 6, to: start) else { continue }
                let done = trainedDays.filter { $0 >= start && $0 < end }.count
                let planned = Int(schedule.planned(from: start, through: last, today: last.addingTimeInterval(86_400),
                                                   trainedToday: true, calendar: calendar).rounded())
                weeks.append(Week(start: start, done: done, planned: planned, beforeGoal: end <= goalDay))
            }
        }
        self.weeks = weeks
        let goalAge = max(0, calendar.dateComponents([.day], from: goalDay, to: today).day ?? 0)
        let windowDays = min(28, max(7, goalAge + 1))
        let windowStart = calendar.date(byAdding: .day, value: -(windowDays - 1), to: today) ?? today
        let measured = schedule.share(trainedDays: trainedDays, from: windowStart, through: today, today: today,
                                      calendar: calendar)
        consistency = measured
        let starting = goalAge < 7
        // In the first week the estimate assumes the plan is kept.
        let rateShare = starting ? 1 : measured

        // Body (reviews GOAL-1, GOAL-5): from the anchor, lean mass grows with
        // the weeks of training since, at the plan's rate scaled by how
        // regularly the member trained since then, up to what the look adds.
        // A cut takes lean only when training lapses; a gain counts the larger
        // of the trained gain and the usual lean share of the extra weight.
        // Fat is the rest of the weight.
        let muscleRate = Self.muscleRate(goal: goal, experience: experience, sex: sex)
        let gainTarget = record.look.muscle.leanGainKg(for: sex)
        startBodyFatPercent = record.start.bodyFatPercent
        startLeanKg = record.start.leanKg
        if let leanA = record.anchor.leanKg {
            let anchorDay = calendar.startOfDay(for: record.anchor.date)
            let sinceAnchor = schedule.share(trainedDays: trainedDays, from: anchorDay, through: today, today: today,
                                             calendar: calendar)
            let weeksSince = max(0, now.timeIntervalSince(record.anchor.date) / (7 * 86_400))
            let room = max(0, (record.start.leanKg ?? leanA) + gainTarget - leanA)
            let trained = min(room, muscleRate * sinceAnchor * weeksSince)
            let change = profile.weightKg - record.anchor.weightKg
            var lean = leanA
            if change < 0 {
                lean += trained + (sinceAnchor >= 0.5 ? 0 : 0.25 * change)
            } else {
                let byExperience: Double = experience == .beginner ? 0.5 : experience == .intermediate ? 0.35 : 0.25
                lean += max(trained, byExperience * (sinceAnchor >= 0.5 ? 1 : 0.5) * change)
            }
            lean = min(max(lean, 0), profile.weightKg)
            leanKg = lean
            bodyFatPercent = profile.weightKg > 0 ? (profile.weightKg - lean) / profile.weightKg * 100 : nil
        } else {
            leanKg = nil
            bodyFatPercent = nil
        }

        // Targets.
        if !paused, let target = record.look.fat.percent(for: sex), let start = record.start.bodyFatPercent, target < start {
            targetBodyFatPercent = target
        } else {
            targetBodyFatPercent = nil
        }
        targetLeanKg = !paused && gainTarget > 0 ? record.start.leanKg.map { $0 + gainTarget } : nil

        func clamp(_ value: Double) -> Double { min(1, max(0, value)) }
        if let target = targetBodyFatPercent, let start = startBodyFatPercent, let now = bodyFatPercent, start > target {
            fatFraction = clamp((start - now) / (start - target))
        } else {
            fatFraction = nil
        }
        if let target = targetLeanKg, let start = startLeanKg, let now = leanKg, target > start {
            muscleFraction = clamp((now - start) / (target - start))
        } else {
            muscleFraction = nil
        }
        let parts = [fatFraction, muscleFraction].compactMap { $0 }
        fraction = parts.isEmpty ? 0 : parts.reduce(0, +) / Double(parts.count)

        // Time left, at the plan's rates scaled by how regularly they train.
        let fatLeft = max(0, (bodyFatPercent ?? 0) - (targetBodyFatPercent ?? .infinity))
        let leanLeft = max(0, (targetLeanKg ?? 0) - (leanKg ?? targetLeanKg ?? 0))
        let fatRate = Self.fatRate(plan: plan, goal: goal, pace: profile.pace, bodyFatPercent: bodyFatPercent ?? 20)
            * (0.6 + 0.4 * rateShare)
        let muscleWeekly = muscleRate * rateShare
        let fatWeeks = fatLeft > 0 ? fatLeft / fatRate : 0
        let muscleWeeks = leanLeft > 0 ? (muscleWeekly > 0 ? leanLeft / muscleWeekly : .infinity) : 0
        let needed = max(fatWeeks, muscleWeeks)

        if paused {
            course = .paused
            weeksLeft = nil
        } else if !parts.isEmpty, fraction >= 0.98 || (fatLeft == 0 && leanLeft == 0 && bodyFatPercent != nil) {
            course = .reached
            weeksLeft = 0
        } else if schedule.perWeek == 0 {
            course = .noSchedule
            weeksLeft = nil
        } else if starting {
            course = .starting
            weeksLeft = needed.isFinite ? Int(needed.rounded(.up)) : nil
        } else if measured < 0.4 {
            course = .offTrack
            weeksLeft = nil
        } else {
            course = measured >= 0.75 ? .onTrack : .behind
            weeksLeft = needed.isFinite ? Int(needed.rounded(.up)) : nil
        }
        targetDate = weeksLeft.flatMap { $0 > 0 ? calendar.date(byAdding: .day, value: $0 * 7, to: today) : nil }
    }
}

// MARK: - Time words

extension GoalProgress {
    /// "about 6 weeks", "about 5 months", "over 2 years": put inside other
    /// sentences ("… to go", the Sunday check-in), so lower case.
    static func timeLeft(weeks: Int) -> String {
        if weeks <= 1 {
            return String(localized: "about a week",
                          comment: "Time left to the goal, put inside a sentence such as “… to go”: keep it lower case")
        }
        if weeks < 10 {
            return String(localized: "about \(weeks) weeks",
                          comment: "Time left to the goal, put inside a sentence such as “… to go”: keep it lower case")
        }
        let months = Int((Double(weeks) / 4.345).rounded())
        if months < 24 {
            return String(localized: "about \(months) months",
                          comment: "Time left to the goal, put inside a sentence such as “… to go”: keep it lower case")
        }
        return String(localized: "over 2 years",
                      comment: "Time left to the goal, put inside a sentence such as “… to go”: keep it lower case")
    }
}

// MARK: - Store

/// The goal record, the goal photo and the photo it was made from, on this
/// device only, read once and kept in memory for Today and the Goal page.
@Observable
final class GoalStore {
    static let shared = GoalStore()

    private(set) var record: GoalRecord?
    /// The goal photo (the edit with the member's own face put back).
    private(set) var photo: UIImage?
    /// The photo the member sent, as uploaded: the "now" side of the compare.
    private(set) var before: UIImage?

    private init() { reload() }

    var hasGoal: Bool { record != nil && photo != nil }

    /// A photo kept from before goals (v1, no record) isn't a goal: it stays
    /// on disk but isn't shown.
    func reload() {
        record = Self.readRecord()
        photo = record == nil ? nil : GoalPhotoStore.latest()
        before = record == nil ? nil : GoalPhotoStore.before()
    }

    /// Saves a new goal: its record, the photo the member sent and the result.
    /// False when any of them couldn't be written (review GOAL-11); the
    /// caller keeps the result to try again.
    @discardableResult
    func set(_ record: GoalRecord, photoJPEG: Data, beforeJPEG: Data?) -> Bool {
        guard GoalPhotoStore.save(photoJPEG) else { return false }
        let beforeSaved: Bool
        if let beforeJPEG { beforeSaved = GoalPhotoStore.saveBefore(beforeJPEG) } else { GoalPhotoStore.deleteBefore(); beforeSaved = true }
        let recordSaved = Self.writeRecord(record)
        self.record = record
        photo = UIImage(data: photoJPEG)
        before = beforeJPEG.flatMap(UIImage.init(data:))
        return beforeSaved && recordSaved
    }

    /// Moves the estimate's anchor when the member entered a new body-fat %,
    /// lining a formula-based start up with it on the first entry.
    func refresh(profile: UserProfile?, experience: TrainingExperience, trainedDays: Set<Date>) {
        guard let profile, let record else { return }
        let estimate = GoalProgress(record: record, profile: profile, experience: experience,
                                    trainedDays: trainedDays).bodyFatPercent
        guard let moved = record.reanchored(to: profile, estimate: estimate) else { return }
        Self.writeRecord(moved)
        self.record = moved
    }

    /// The same, where the training history isn't at hand (the Goal page's
    /// own refresh); the app's root has usually moved the anchor already.
    func refresh(profile: UserProfile?) {
        refresh(profile: profile, experience: .intermediate, trainedDays: [])
    }

    func delete() {
        GoalPhotoStore.delete()
        GoalPhotoStore.deleteBefore()
        try? FileManager.default.removeItem(at: Self.recordURL)
        record = nil
        photo = nil
        before = nil
    }

    func progress(profile: UserProfile?, experience: TrainingExperience, trainedDays: Set<Date>,
                  now: Date = Date(), calendar: Calendar = .current) -> GoalProgress? {
        guard let record, let profile else { return nil }
        return GoalProgress(record: record, profile: profile, experience: experience, trainedDays: trainedDays,
                            now: now, calendar: calendar)
    }

    private static var recordURL: URL { GoalPhotoStore.folder.appendingPathComponent("goal.json") }

    private static func readRecord() -> GoalRecord? {
        guard let data = try? Data(contentsOf: recordURL) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(GoalRecord.self, from: data)
    }

    @discardableResult
    private static func writeRecord(_ record: GoalRecord) -> Bool {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(record) else { return false }
        do {
            try FileManager.default.createDirectory(at: GoalPhotoStore.folder, withIntermediateDirectories: true)
            var url = recordURL
            try data.write(to: url, options: [.atomic, .completeFileProtectionUnlessOpen])
            var values = URLResourceValues()
            values.isExcludedFromBackup = true
            try? url.setResourceValues(values)
            return true
        } catch {
            return false
        }
    }
}

// MARK: - Weekly reminder

/// One check-in a week, Sunday evening (the owner's pick): on course, how
/// long is left; behind, without training days or without sessions, that
/// the goal gets hard to reach. Local notifications are fixed once laid, so
/// the next two Sundays are re-laid whenever the app is opened, a session is
/// logged or the profile changes: the next with the numbers as they will
/// stand that Sunday (the Monday-to-Sunday week ending then, with the
/// sessions logged so far, review GOAL-3), the one after for a member who
/// doesn't open the app in between.
enum GoalReminder {
    static let storageKey = "goal.reminder.on"
    private static let ids = ["goal.week.1", "goal.week.2"]
    private static let hour = 19

    /// On unless the member turned it off on the Goal page.
    static var isOn: Bool {
        UserDefaults.standard.object(forKey: storageKey) as? Bool ?? true
    }

    /// Re-lays the check-ins, or clears them: without a goal, while it's
    /// paused, in builds where the goal can't be seen (review GOAL-10), or
    /// when they're turned off. Asks for nothing: when notifications aren't
    /// allowed yet, the Goal page offers to turn them on.
    static func relay(profile: UserProfile?, experience: TrainingExperience, trainedDays: Set<Date>,
                      now: Date = Date(), calendar: Calendar = .current) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ids)
        guard isOn, AIService.isLive, let profile, GoalStore.shared.hasGoal else { return }
        let status = await center.notificationSettings().authorizationStatus
        guard [.authorized, .provisional, .ephemeral].contains(status) else { return }

        var sunday = DateComponents()
        sunday.weekday = 1
        sunday.hour = hour
        guard let first = calendar.nextDate(after: now, matching: sunday, matchingPolicy: .nextTime),
              let second = calendar.date(byAdding: .day, value: 7, to: first) else { return }
        var mondayFirst = calendar
        mondayFirst.firstWeekday = 2
        guard let progress = GoalStore.shared.progress(profile: profile, experience: experience, trainedDays: trainedDays,
                                                       now: first, calendar: mondayFirst),
              progress.course != .paused else { return }
        let secondContent = UNMutableNotificationContent()
        secondContent.title = String(localized: "Your goal is waiting",
                                     comment: "Notification title: the Sunday goal check-in for a member who hasn't opened MUSQ for a week")
        secondContent.body = String(localized: "No sessions logged lately. Plan your next workout to get back on course.",
                                    comment: "Notification body: the Sunday goal check-in for a member who hasn't opened MUSQ for a week")
        secondContent.sound = .default
        for (id, (date, content)) in zip(ids, [(first, content(for: progress)), (second, secondContent)]) {
            let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
            try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        }
    }

    static func cancel() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }

    static func content(for progress: GoalProgress) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = String(localized: "Goal check-in", comment: "Notification title: the weekly goal check-in, Sunday evening")
        let done = progress.thisWeek?.done ?? 0
        let goal = progress.thisWeek?.goal ?? 0
        switch progress.course {
        case .reached:
            content.title = String(localized: "You've reached your goal",
                                   comment: "Notification title, and the Goal page's heading, once the estimate reaches the goal")
            content.body = String(localized: "By the estimate, you're there. Take a new photo to see how far you've come.",
                                  comment: "Notification body: the Sunday goal check-in once the estimate reaches the goal")
        case .noSchedule:
            content.title = String(localized: "Your goal needs a plan",
                                   comment: "Notification title when no training days are set: the plan is the training days, not a subscription")
            content.body = String(localized: "Set your training days, and MUSQ keeps you on course to your goal.",
                                  comment: "Notification body when no training days are set")
        case .paused:
            content.body = ""
        case .starting:
            content.body = done == 0
                ? String(localized: "Your goal's first week: no sessions logged yet. Plan your next workout to get going.",
                         comment: "Weekly goal reminder in the first week, before any session")
                : String(localized: "\(done) of \(goal) sessions in your goal's first week. Keep it going.",
                         comment: "Weekly goal reminder in the first week; sessions done of planned")
        case .offTrack:
            content.body = String(localized: "\(done) of \(goal) sessions this week. At this rate your goal will be hard to reach: plan your next workout now.",
                                  comment: "Weekly goal reminder when training is irregular; sessions done of planned")
        case .behind:
            if let weeks = progress.weeksLeft {
                content.body = String(localized: "\(done) of \(goal) sessions this week: \(GoalProgress.timeLeft(weeks: weeks)) to your goal at this pace. Every session brings it closer.",
                                      comment: "Weekly goal reminder; sessions done of planned, then time left, e.g. about 5 months")
            } else {
                content.body = String(localized: "\(done) of \(goal) sessions this week. Every session brings your goal closer.",
                                      comment: "Weekly goal reminder when behind and no date can be said; sessions done of planned")
            }
        case .onTrack:
            if let weeks = progress.weeksLeft {
                content.body = String(localized: "\(done) of \(goal) sessions this week. You're on course: \(GoalProgress.timeLeft(weeks: weeks)) to your goal.",
                                      comment: "Weekly goal reminder; sessions done of planned, then time left, e.g. about 14 weeks")
            } else {
                content.body = String(localized: "\(done) of \(goal) sessions this week. You're on course to your goal.",
                                      comment: "Weekly goal reminder when on course and no date can be said; sessions done of planned")
            }
        }
        return content
    }
}
