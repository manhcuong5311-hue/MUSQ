//
//  ProgramAdvisor.swift
//  GymWorkout
//
//  Turns the onboarding answers into suggestions: the split that suits the
//  days a week (upper / lower, front / back or push / pull / legs) and the
//  rotation of muscle groups it gives, which preset level a group opens on,
//  and the walk after a weight-loss workout. Everything here only suggests — any group, preset
//  or exercise stays one tap away.
//

import Foundation

enum ProgramAdvisor {

    // MARK: - Split

    /// Weekly schedules onboarding offers.
    static let daysPerWeekOptions = [2, 3, 4, 5, 6]

    /// The split that suits a number of sessions a week.
    ///
    /// - Two days: full body (2026-11-27; was upper / lower). Each session
    ///   covers everything, so every muscle still trains twice a week, where
    ///   upper / lower reached each one only once.
    /// - Three days: full body for a beginner, whose sessions are short and
    ///   whose muscles recover quickly from the lighter load; otherwise front
    ///   / back, where every session still works both the upper and the
    ///   lower body but each muscle gets more sets on its day. Unknown
    ///   experience keeps front / back, what three days always suggested.
    /// - Four days split upper from lower body, so everything trains twice.
    /// - Five or six days have room for push, pull and legs; six trains
    ///   everything twice.
    ///
    /// The bro split and Custom are never suggested: one muscle a week is
    /// too little for most goals, and Custom is the user's own.
    static func recommendedSplit(daysPerWeek: Int, experience: TrainingExperience? = nil) -> TrainingSplit {
        switch daysPerWeek {
        case ...2: return .fullBody
        case 3: return experience == .beginner ? .fullBody : .frontBack
        case 4: return .upperLower
        default: return .pushPullLegs
        }
    }

    /// Why the recommended split fits, finishing "… suits N days a week
    /// best: …". No numbers: the split's card shows how often each muscle
    /// comes round, which depends on the lower-body focus.
    static func recommendationReason(daysPerWeek: Int, experience: TrainingExperience? = nil) -> String {
        switch daysPerWeek {
        case ...2: return String(localized: "every session trains the whole body, so each muscle still comes round twice a week.",
                                 comment: "Finishes “<split> suits N days a week best: …”")
        case 3 where experience == .beginner:
            return String(localized: "short sessions that train the whole body, three times a week.",
                          comment: "Finishes “<split> suits N days a week best: …”")
        case 3: return String(localized: "every session trains both the upper and the lower body, so no muscle waits a whole week.",
                              comment: "Finishes “<split> suits N days a week best: …”")
        case 4: return String(localized: "the upper and lower body take turns training and resting.",
                              comment: "Finishes “<split> suits N days a week best: …”")
        default: return String(localized: "shorter, focused sessions, and each muscle rests while the others work.",
                               comment: "Finishes “<split> suits N days a week best: …”")
        }
    }

    /// The profile's split. Profiles saved before the question existed keep
    /// what they had: push, pull and legs, or the lower-body rotation for
    /// women.
    static func split(for profile: UserProfile?) -> TrainingSplit {
        // The schedule holds the real choice; `split` only the nearest one
        // older builds know.
        if let split = profile?.schedule?.split { return split }
        if let split = profile?.split { return split }
        return isLowerFocused(profile) ? .upperLower : .pushPullLegs
    }

    // MARK: - Rotation

    /// One day of a split: what it's called and the groups it trains.
    struct SplitDay: Hashable {
        let name: String
        let groups: [MuscleGroup]
    }

    /// The days' names in the current language. They are only ever shown
    /// (the plan page, the Train heading, the greeting), never matched.
    private enum DayName {
        static var upper: String { String(localized: "Upper", comment: "Split day: the upper body") }
        static var lower: String { String(localized: "Lower", comment: "Split day: the lower body") }
        static var lowerA: String { String(localized: "Lower A", comment: "Split day: the first of two lower-body days") }
        static var lowerB: String { String(localized: "Lower B", comment: "Split day: the second of two lower-body days") }
        static var front: String { String(localized: "Front", comment: "Split day: the front of the body") }
        static var back: String {
            String(localized: "splitDay.back", defaultValue: "Back", comment: "Split day: the back of the body")
        }
        static var push: String { String(localized: "Push", comment: "Split day: the pressing muscles") }
        static var pull: String { String(localized: "Pull", comment: "Split day: the pulling muscles") }
        static var legs: String { String(localized: "Legs", comment: "Split day: the legs") }
        static var legsA: String { String(localized: "Legs A", comment: "Split day: the first of two leg days") }
        static var legsB: String { String(localized: "Legs B", comment: "Split day: the second of two leg days") }
        static var fullA: String { String(localized: "Full Body A", comment: "Split day: the first of two full-body days") }
        static var fullB: String { String(localized: "Full Body B", comment: "Split day: the second of two full-body days") }
        static var chest: String { String(localized: "splitDay.chest", defaultValue: "Chest", comment: "Split day: chest") }
        static var backDay: String { String(localized: "splitDay.backDay", defaultValue: "Back", comment: "Split day of the bro split: the back muscles") }
        static var shoulders: String { String(localized: "splitDay.shoulders", defaultValue: "Shoulders", comment: "Split day: shoulders") }
        static var arms: String { String(localized: "Arms", comment: "Split day: biceps and triceps") }
    }

    /// A split's days in order. A lower-body focus puts the lower groups
    /// first and, where the split has room, adds a second lower day, so legs
    /// and glutes come up twice in each rotation.
    static func days(of split: TrainingSplit, lowerFocus: Bool) -> [SplitDay] {
        switch (split, lowerFocus) {
        case (.upperLower, false):
            return [SplitDay(name: DayName.upper, groups: [.chest, .back, .shoulders, .biceps, .triceps]),
                    SplitDay(name: DayName.lower, groups: [.quads, .hamstrings, .glutes, .abs])]
        case (.upperLower, true):
            return [SplitDay(name: DayName.lowerA, groups: [.glutes, .hamstrings, .abs]),
                    SplitDay(name: DayName.upper, groups: [.back, .chest, .shoulders, .biceps, .triceps]),
                    SplitDay(name: DayName.lowerB, groups: [.quads, .glutes])]
        case (.frontBack, false):
            return [SplitDay(name: DayName.front, groups: [.chest, .shoulders, .quads, .biceps, .abs]),
                    SplitDay(name: DayName.back, groups: [.back, .hamstrings, .glutes, .triceps])]
        case (.frontBack, true):
            return [SplitDay(name: DayName.front, groups: [.quads, .chest, .shoulders, .biceps, .abs]),
                    SplitDay(name: DayName.back, groups: [.glutes, .hamstrings, .back, .triceps])]
        case (.pushPullLegs, false):
            return [SplitDay(name: DayName.push, groups: [.chest, .shoulders, .triceps]),
                    SplitDay(name: DayName.pull, groups: [.back, .biceps]),
                    SplitDay(name: DayName.legs, groups: [.quads, .hamstrings, .glutes])]
        case (.pushPullLegs, true):
            return [SplitDay(name: DayName.legsA, groups: [.glutes, .hamstrings]),
                    SplitDay(name: DayName.push, groups: [.chest, .shoulders, .triceps]),
                    SplitDay(name: DayName.legsB, groups: [.quads, .glutes, .abs]),
                    SplitDay(name: DayName.pull, groups: [.back, .biceps])]
        // Two alternating full-body days, so the big groups come every
        // session and the smaller ones every other: few groups a day keeps a
        // session short enough for two or three days a week.
        case (.fullBody, false):
            return [SplitDay(name: DayName.fullA, groups: [.chest, .back, .quads, .shoulders, .abs]),
                    SplitDay(name: DayName.fullB, groups: [.back, .chest, .hamstrings, .glutes, .biceps, .triceps])]
        case (.fullBody, true):
            return [SplitDay(name: DayName.fullA, groups: [.glutes, .quads, .back, .chest, .abs]),
                    SplitDay(name: DayName.fullB, groups: [.hamstrings, .glutes, .back, .shoulders, .triceps])]
        // One muscle area a day; a lower-body focus starts the week on legs.
        case (.bro, false):
            return [SplitDay(name: DayName.chest, groups: [.chest]),
                    SplitDay(name: DayName.backDay, groups: [.back]),
                    SplitDay(name: DayName.legs, groups: [.quads, .hamstrings, .glutes, .calves]),
                    SplitDay(name: DayName.shoulders, groups: [.shoulders, .abs]),
                    SplitDay(name: DayName.arms, groups: [.biceps, .triceps, .forearms])]
        case (.bro, true):
            return [SplitDay(name: DayName.legs, groups: [.glutes, .quads, .hamstrings, .calves]),
                    SplitDay(name: DayName.chest, groups: [.chest]),
                    SplitDay(name: DayName.backDay, groups: [.back]),
                    SplitDay(name: DayName.shoulders, groups: [.shoulders, .abs]),
                    SplitDay(name: DayName.arms, groups: [.biceps, .triceps, .forearms])]
        // The user's own days live on the schedule (see `days(for:)`).
        case (.custom, _):
            return []
        }
    }

    /// A split's days, a Custom one's from `customDays` (those with groups;
    /// push / pull / legs while none has any, so the planner always has a
    /// rotation).
    static func days(of split: TrainingSplit, lowerFocus: Bool, customDays: [ScheduleDay]) -> [SplitDay] {
        guard split == .custom else { return days(of: split, lowerFocus: lowerFocus) }
        let own = customDays.filter { !$0.groups.isEmpty }.map { day in
            SplitDay(name: day.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? String(localized: "Day \((customDays.firstIndex(of: day) ?? 0) + 1)",
                                 comment: "A custom split day with no name: Day 2")
                        : day.name,
                     groups: day.groups)
        }
        return own.isEmpty ? days(of: .pushPullLegs, lowerFocus: lowerFocus) : own
    }

    /// Push / pull / legs — the planner's default.
    static let standardRotation: [[MuscleGroup]] = days(of: .pushPullLegs, lowerFocus: false).map(\.groups)

    static func days(for profile: UserProfile?) -> [SplitDay] {
        days(of: split(for: profile), lowerFocus: isLowerFocused(profile),
             customDays: profile?.schedule?.customDays ?? [])
    }

    static func rotation(for profile: UserProfile?) -> [[MuscleGroup]] {
        days(for: profile).map(\.groups)
    }

    /// How often each muscle group comes round in a week, at most and at
    /// least: sessions a week over the rotation's length, times the days that
    /// train the group. The planner follows recovery rather than a calendar,
    /// so this is what the schedule allows, not a promise.
    static func timesPerWeek(_ split: TrainingSplit, lowerFocus: Bool, daysPerWeek: Int) -> ClosedRange<Double> {
        timesPerWeek(days: days(of: split, lowerFocus: lowerFocus), daysPerWeek: daysPerWeek)
    }

    /// The same for any list of days, a Custom split's included.
    static func timesPerWeek(days: [SplitDay], daysPerWeek: Int) -> ClosedRange<Double> {
        guard !days.isEmpty else { return 0...0 }
        let perRotation = Dictionary(days.flatMap(\.groups).map { ($0, 1) }, uniquingKeysWith: +)
        let counts = perRotation.values.map { Double($0) * Double(daysPerWeek) / Double(days.count) }
        return (counts.min() ?? 0)...(counts.max() ?? 0)
    }

    /// "about 2× a week", "1–2× a week", "less than once a week", finishing
    /// "Every muscle …". The × is in the localized strings, not the numbers.
    static func frequencyText(_ range: ClosedRange<Double>) -> String {
        func times(_ value: Double) -> String {
            let half = (value * 2).rounded() / 2
            return half.formatted(.number.precision(.fractionLength(0...1)))
        }
        if range.upperBound < 0.9 {
            return String(localized: "less than once a week", comment: "Finishes “Every muscle …”")
        }
        let low = times(range.lowerBound), high = times(range.upperBound)
        if low == high { return String(localized: "about \(low)× a week", comment: "Finishes “Every muscle …”") }
        return String(localized: "\(low)–\(high)× a week", comment: "Finishes “Every muscle …”: a range of times a week")
    }

    /// Whether suggestions lean towards the lower body.
    static func isLowerFocused(_ profile: UserProfile?) -> Bool {
        profile?.sex == .female
    }

    /// Groups in the order to offer them: lower body first for a lower-body
    /// focus, otherwise unchanged.
    static func ordered(_ groups: [MuscleGroup], for profile: UserProfile?) -> [MuscleGroup] {
        guard isLowerFocused(profile) else { return groups }
        let lower = groups.filter { $0.area == .lower }
        return lower + groups.filter { $0.area != .lower }
    }

    // MARK: - Presets

    /// The level a group opens on. Weight loss and beginners start on Basic —
    /// machines and supported positions, easier to recover from next to
    /// daily walking; experienced lifters building muscle or fitness start
    /// on Advanced.
    /// Basic too while a doctor's OK is pending, in pregnancy and in the
    /// year after a birth (2026-11-21).
    static func suggestedLevel(for profile: UserProfile?, experience: TrainingExperience) -> PresetLevel {
        guard let profile, profile.goal != .loseWeight, experience != .beginner else { return .basic }
        if let health = profile.health,
           !health.clearanceReasons.isEmpty || health.isPregnant || health.isPostpartum {
            return .basic
        }
        return .advanced
    }

    // MARK: - Week

    /// Training days spread across the week, as `Calendar` weekday numbers
    /// (1 = Sunday): Mon/Thu, Mon/Wed/Fri, Mon/Tue/Thu/Fri, Mon-Fri, Mon-Sat.
    static func suggestedWeekdays(daysPerWeek: Int) -> [Int] {
        switch daysPerWeek {
        case ...2: return [2, 5]
        case 3: return [2, 4, 6]
        case 4: return [2, 3, 5, 6]
        case 5: return [2, 3, 4, 5, 6]
        default: return [2, 3, 4, 5, 6, 7]
        }
    }

    /// The split's days laid on the training weekdays in the order of the
    /// week, the rotation running on from one to the next.
    static func week(weekdays: [Int], days: [SplitDay], calendar: Calendar = .current) -> [(weekday: Int, day: SplitDay?)] {
        let order = (0..<7).map { (calendar.firstWeekday - 1 + $0) % 7 + 1 }
        var next = 0
        return order.map { weekday in
            guard weekdays.contains(weekday), !days.isEmpty else { return (weekday, nil) }
            defer { next += 1 }
            return (weekday, days[next % days.count])
        }
    }

    // MARK: - Schedule

    /// What a day of the schedule holds.
    enum DayPlan: Hashable {
        /// A training day: the split's day that falls on it, or the one set
        /// by hand.
        case train(SplitDay)
        /// A rest day the user picked: a weekday off, or a date set to rest.
        case rest
        /// Nothing set: Train suggests by recovery, as it always did.
        case open
    }

    /// The schedule the user saved (in the schedule editor or onboarding).
    /// A profile without one has no fixed schedule: every day is open and
    /// Train suggests by recovery, so a missed day never breaks the plan.
    /// Its answers only seed the editor (`editableSchedule`).
    static func schedule(for profile: UserProfile?) -> TrainingSchedule? {
        profile?.schedule
    }

    /// A schedule to open the editor on: the profile's, else one made from
    /// its answers, else the suggestion for three days a week.
    static func editableSchedule(for profile: UserProfile?, experience: TrainingExperience? = nil) -> TrainingSchedule {
        if let schedule = schedule(for: profile) { return schedule }
        let days = profile?.daysPerWeek ?? 3
        return TrainingSchedule(mode: .weekly,
                                split: profile?.split ?? recommendedSplit(daysPerWeek: days, experience: experience),
                                weekdays: suggestedWeekdays(daysPerWeek: days))
    }

    static func plan(on date: Date, profile: UserProfile?, calendar: Calendar = .current) -> DayPlan {
        guard let schedule = schedule(for: profile) else { return .open }
        return plan(on: date, schedule: schedule, days: days(for: profile), calendar: calendar)
    }

    /// A date set by hand wins (By-date mode only); otherwise a weekday off
    /// is rest, and a training weekday gets the rotation's next day.
    /// `days` are the split's days; groups without a preset are left out,
    /// and a day left with none is skipped.
    static func plan(on date: Date, schedule: TrainingSchedule, days: [SplitDay],
                     calendar: Calendar = .current) -> DayPlan {
        if schedule.mode == .byDate, let set = schedule.dated[TrainingSchedule.key(for: date, calendar: calendar)] {
            if set.isRest { return .rest }
            if !set.groups.isEmpty { return .train(SplitDay(name: set.name ?? "", groups: set.groups)) }
        }
        let weekdays = Set(schedule.weekdays)
        guard !weekdays.isEmpty else { return .open }
        guard weekdays.contains(calendar.component(.weekday, from: date)) else { return .rest }
        let trainable = Set(PresetProvider.trainableGroups)
        let rotation = days.map { SplitDay(name: $0.name, groups: $0.groups.filter(trainable.contains)) }
            .filter { !$0.groups.isEmpty }
        guard !rotation.isEmpty,
              let index = rotationIndex(of: date, weekdays: weekdays, anchor: schedule.anchor, calendar: calendar)
        else { return .open }
        return .train(rotation[((index % rotation.count) + rotation.count) % rotation.count])
    }

    /// Monday 5 January 2026, the rotation's start when a schedule has no
    /// anchor of its own.
    private static let referenceAnchor = Date(timeIntervalSince1970: 1_767_571_200)

    /// How many training days come before `date`, counted from the start of
    /// the anchor's week. Within a week the order matches `week(weekdays:)`,
    /// what onboarding showed, and when the split's days divide the week's
    /// training days evenly every week reads the same.
    private static func rotationIndex(of date: Date, weekdays: Set<Int>, anchor: Date?,
                                      calendar: Calendar) -> Int? {
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: date)?.start,
              let anchorStart = calendar.dateInterval(of: .weekOfYear, for: anchor ?? referenceAnchor)?.start
        else { return nil }
        let daysApart = calendar.dateComponents([.day], from: anchorStart, to: weekStart).day ?? 0
        let weeks = Int((Double(daysApart) / 7).rounded())
        let order = (0..<7).map { (calendar.firstWeekday - 1 + $0) % 7 + 1 }
        let weekday = calendar.component(.weekday, from: date)
        let before = order.prefix { $0 != weekday }.filter(weekdays.contains).count
        return weeks * weekdays.count + before
    }

    // MARK: - Walking

    /// Steps suggested after a weight-loss workout: 3,000 for beginners,
    /// 4,000 with some experience, 5,000 when experienced. A BMI of 30 or
    /// more starts at 3,000, easier on the joints.
    static func walk(for profile: UserProfile, experience: TrainingExperience) -> WalkSuggestion {
        var steps: Int
        switch experience {
        case .beginner: steps = 3_000
        case .intermediate: steps = 4_000
        case .advanced: steps = 5_000
        }
        if profile.bmi >= 30 { steps = 3_000 }
        return WalkSuggestion(steps: steps, heightCm: profile.heightCm, weightKg: profile.weightKg)
    }
}

/// A walk and what it roughly adds up to. Stride is 41.5% of height, pace
/// about 100 steps a minute, and walking costs about 0.5 kcal per kilogram
/// of body weight per kilometre — estimates, and always shown as such.
struct WalkSuggestion: Hashable {
    let steps: Int
    let heightCm: Double
    let weightKg: Double

    /// A day's total to aim for alongside the walk.
    static let dailySteps = 8_000

    /// The energy of a day's steps the same way (2026-11-22), for people
    /// without a Watch's active energy: an estimate shown beside the plan,
    /// never added to it — the plan's activity already counts the walking.
    static func walkingKcal(steps: Int, heightCm: Double, weightKg: Double) -> Int {
        WalkSuggestion(steps: steps, heightCm: heightCm, weightKg: weightKg).kilocalories
    }

    var kilometres: Double { Double(steps) * heightCm * 0.415 / 100_000 }
    var minutes: Int { Int((Double(steps) / 100).rounded()) }
    var kilocalories: Int { Int((kilometres * weightKg * 0.5).rounded()) }

    /// "≈ 2.8 km · 30 min · 100 kcal".
    var detail: String {
        let km = kilometres.formatted(.number.precision(.fractionLength(1)))
        return String(localized: "≈ \(km) km · \(minutes) min · \(kilocalories) kcal",
                      comment: "A walk's estimated distance, time and energy")
    }
}
