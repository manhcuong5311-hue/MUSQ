//
//  BalanceScore.swift
//  GymWorkout
//
//  Balance (owner-approved 2026-11-22): one picture of Train, Eat and Sleep
//  over the last 7 days. It rates only what the user does — never the
//  results — and puts the results beside it, so the user can see from their
//  own weeks that the goal moves better when all three are good. Worked out
//  on the device each time; nothing here is saved, and the Sleep part comes
//  from Apple Health readings held in memory.
//
//  - Train = 100 × (0.6 × showing up + 0.4 × coverage). Showing up: days
//    trained ÷ the weekly goal, at most 1 (more sessions never beat
//    recovering). Coverage: the split's muscle groups, each at most 1 of
//    its weekly set target — 6 effective sets for beginners, 10
//    intermediate, 12 advanced, or 6 on "Maintain" — so 30 chest sets can't
//    hide 0 for hamstrings (Schoenfeld, Ogborn & Krieger 2017; Baz-Valle et
//    al. 2022; Bickel 2011 for maintenance). Past 20 sets earns nothing more
//    (Pelland et al. 2024).
//    Train starts at the first logged workout: a finished week before it
//    isn't a 0 but "not tracked".
//  - Eat = the average day of the last 7 that has protein or calorie data:
//    0.45 protein + 0.40 calories + 0.15 water, reweighted when a part is
//    missing. From a meal log: protein ÷ 90% of the plan's, known only when
//    a meal was scanned or has protein typed in; calories full within ±10%
//    of the plan, falling to 0 at ±30%, and 0 under the calorie floor (or
//    under 90% of the plan when the plan sits near or under the floor, so
//    eating the plan never scores 0). Meals count for the day's calories
//    once they reach half the plan, or on a finished day without a
//    check-in. From the evening check-in: Hit 1 / Close 0.6 / Missed 0.3
//    and About right 1 / A bit off 0.6 / Way off 0.2, for whatever the log
//    doesn't cover. Today's log is still running, so it counts only when it
//    doesn't pull the score down (or once today is checked in). Needs 4
//    such days. Off when neither protein nor calories can be scored
//    (kidney disease with calorie numbers hidden).
//  - Sleep = 100 × (0.8 × nights + 0.2 × regularity). A night is full from
//    max(goal − 1 h, 7 h), falling to 0 two and a half hours under it (short
//    sleep in a deficit shifts loss from fat to muscle: Nedeltcheva 2010;
//    Lamon 2021). Regularity: the spread of sleep midpoints, full at 30 min
//    or less, 0 at 90 (needs 5 nights). "Slept about…" estimates count 90%
//    of a measured night of the band's length (people over-report:
//    Lauderdale 2008). Needs 4 nights.
//  - Balance = half the average of the scored pillars + half the weakest:
//    results need all three, so lifting the weakest moves it most. Shown
//    from two scored pillars. The weights and cut-offs are the app's own.
//  - A paused week's days are left out of every pillar of the rolling 7
//    days, and the weekly goals shrink to the days left; with fewer than 4
//    left, or this week paused, the whole window shows as paused.
//

import Foundation

enum BalancePillar: String, CaseIterable, Identifiable, Hashable {
    case train, eat, sleep

    var id: String { rawValue }

    var title: String {
        switch self {
        case .train: return String(localized: "Train", comment: "Balance pillar")
        case .eat: return String(localized: "Eat", comment: "Balance pillar")
        case .sleep: return String(localized: "Sleep", comment: "Balance pillar")
        }
    }

    var symbol: String {
        switch self {
        case .train: return "dumbbell.fill"
        case .eat: return "fork.knife"
        case .sleep: return "moon.fill"
        }
    }

    /// On a tie, the cheaper change wins: sleep or eating before a session.
    fileprivate var tieOrder: Int {
        switch self {
        case .sleep: return 0
        case .eat: return 1
        case .train: return 2
        }
    }
}

/// One day on the 3 × 7 habit grid.
enum BalanceMark: Hashable {
    case full, half, empty
    /// A planned rest day: counts as good.
    case rest
    case noData
}

struct BalancePart: Hashable, Identifiable {
    let label: String
    let value: String
    var detail: String? = nil
    var id: String { label }
}

struct PillarScore: Hashable {
    enum Status: Hashable {
        case scored
        /// Nothing to score with (no sleep data, no eating log or check-in).
        case notTracked
        /// Some, not enough yet.
        case needsMore(have: Int, need: Int)
        /// The user turned this pillar's score off.
        case off
    }

    let pillar: BalancePillar
    let score: Int?
    let status: Status
    /// "3 of 4 workouts", "Protein 5 of 6 days", "6 h 12 a night".
    let summary: String
    let parts: [BalancePart]
    /// Oldest first, the last 7 days (today last).
    let marks: [BalanceMark]

    var isScored: Bool { score != nil }
}

struct BalanceAction: Hashable {
    enum Kind: Hashable {
        case startWorkout
        case checkIn
        case addWater(Int)
        case bedtime(hour: Int, minute: Int)
        case sleepEstimate
        case connectHealth
        case none
    }

    let pillar: BalancePillar
    let text: String
    let kind: Kind

    var buttonTitle: String? {
        switch kind {
        case .startWorkout: return String(localized: "Start", comment: "Balance action button")
        case .checkIn: return String(localized: "Check in", comment: "Balance action button")
        case .addWater(let ml): return String(localized: "+\(ml) ml", comment: "Balance action button: adds water, e.g. +250 ml")
        case .bedtime: return String(localized: "Set reminder", comment: "Balance action button")
        case .sleepEstimate: return String(localized: "Log sleep", comment: "Balance action button")
        case .connectHealth: return String(localized: "Connect", comment: "Balance action button")
        case .none: return nil
        }
    }
}

/// Where the goal stands, beside the score (never part of it).
struct BalanceResult: Hashable {
    enum Pace: Hashable { case onPace, slower, faster, holding }
    let text: String
    let pace: Pace?
}

struct Balance: Hashable {
    let window: DateInterval
    let train: PillarScore
    let eat: PillarScore
    let sleep: PillarScore
    /// Nil with fewer than two scored pillars.
    let score: Int?
    let lever: BalancePillar?
    let action: BalanceAction?
    /// Short evidence notes when two pillars interact (a cut on short sleep…).
    let notes: [String]
    let result: BalanceResult?
    let paused: Bool

    var pillars: [PillarScore] { [train, eat, sleep] }
    var scored: [PillarScore] { pillars.filter(\.isScored) }

    /// "3 of 3", "2 of 3".
    var coverage: String {
        String(localized: "\(scored.count) of 3", comment: "Balance: pillars scored")
    }

    var word: String? { score.map(Self.word(for:)) }

    static func word(for score: Int) -> String {
        switch score {
        // Its own key: "Strong" alone is a goal-photo muscle level.
        case 80...: return String(localized: "balance.word.strong", defaultValue: "Strong",
                                  comment: "Balance word for a score of 80 and up; also inside a small ring, keep it short")
        case 65..<80: return String(localized: "On track",
                                    comment: "Balance word for a score of 65 to 79; also inside a small ring, keep it short")
        case 45..<65: return String(localized: "Building",
                                    comment: "Balance word for a score of 45 to 64; also inside a small ring, keep it short")
        default: return String(localized: "Getting going",
                               comment: "Balance word for a score under 45; also inside a small ring, keep it short")
        }
    }

    func pillar(_ p: BalancePillar) -> PillarScore {
        switch p {
        case .train: return train
        case .eat: return eat
        case .sleep: return sleep
        }
    }
}

/// A finished (or current) calendar week for the 12-week chart.
struct BalanceWeek: Hashable, Identifiable {
    let start: Date
    let balance: Balance
    let isCurrent: Bool
    /// The 7-day weight average at the week's end, kg.
    let weightKg: Double?
    var id: Date { start }
    var paused: Bool { balance.paused }
}

/// "Your weeks": the better-balanced half against the other.
struct BalanceComparison: Hashable {
    let weeksUsed: Int
    let betterResult: Double
    let otherResult: Double
    /// kg a week (weight goals).
    let unit: String
    let clearDifference: Bool
    let early: Bool
    /// What the better weeks had: "7 h 20 sleep", "protein 5 of 7 days", "4 sessions".
    let betterHad: [String]
}

// MARK: - Inputs

struct BalanceInputs {
    var sessions: [WorkoutSession]
    var profile: UserProfile?
    var plan: NutritionPlan?
    var experience: TrainingExperience
    var splitGroups: Set<MuscleGroup>
    var daily: DailyStore
    var nights: [AppleHealth.SleepNight]
    var sleepGoalMinutes: Int
    /// Apple Health connected (sleep can come from it).
    var healthConnected: Bool
    var healthAvailable: Bool
    var waterCounts: Bool
    var settings: BalanceSettings
    var keyLiftChange: Double?
    var now: Date = Date()
    var calendar: Calendar = .current
}

// MARK: - Scoring

enum BalanceScore {

    /// The rolling last 7 days, today included. Days that fall in a paused
    /// calendar week are left out of every pillar; the window shows as
    /// paused while this week is paused (the toggle acts at once) or once
    /// fewer than 4 days are left — the days Eat and Sleep need.
    static func current(_ input: BalanceInputs) -> Balance {
        let cal = input.calendar
        let end = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: input.now)) ?? input.now
        let start = cal.date(byAdding: .day, value: -7, to: end) ?? input.now
        let window = DateInterval(start: start, end: end)
        let days = dayStarts(window, cal)
        let pausedDays = Set(days.filter { input.daily.isPaused(week: $0) })
        let paused = input.daily.isPaused(week: input.now) || days.count - pausedDays.count < 4
        // A paused window keeps its pillars as they were (only the number
        // and Train's score are held back), as a paused week always has.
        return compute(input, window: window, paused: paused, live: true,
                       pausedDays: paused ? [] : pausedDays)
    }

    /// The last `count` calendar weeks, oldest first, the current one last
    /// ("so far"). Progress charts 12; "Your weeks" compares 14.
    static func history(_ input: BalanceInputs, weeks count: Int = 12) -> [BalanceWeek] {
        let cal = input.calendar
        guard let thisWeek = cal.dateInterval(of: .weekOfYear, for: input.now) else { return [] }
        return (0..<count).reversed().compactMap { offset in
            guard let start = cal.date(byAdding: .weekOfYear, value: -offset, to: thisWeek.start),
                  let end = cal.date(byAdding: .day, value: 7, to: start) else { return nil }
            let balance = compute(input, window: DateInterval(start: start, end: end),
                                  paused: input.daily.isPaused(week: start), live: offset == 0)
            let lastDay = min(cal.date(byAdding: .day, value: -1, to: end) ?? end, input.now)
            return BalanceWeek(start: start, balance: balance, isCurrent: offset == 0,
                               weightKg: input.daily.trendWeight(at: lastDay))
        }
    }

    /// `pausedDays`: days of the window left out of every pillar (paused
    /// weeks inside a rolling window that isn't paused as a whole).
    static func compute(_ input: BalanceInputs, window: DateInterval, paused: Bool, live: Bool,
                        pausedDays: Set<Date> = []) -> Balance {
        let train = trainTracked(input, window: window, live: live)
            ? trainScore(input, window: window, paused: paused, pausedDays: pausedDays)
            : notTracked(.train, window: window, input: input)
        let week = eatWeek(input, window: window, pausedDays: pausedDays)
        let eat = eatScorable(input) ? eatScore(input, window: window, week: week) : eatOff(input, window: window)
        let sleep = sleepScore(input, window: window, pausedDays: pausedDays)
        let scored = [train, eat, sleep].filter(\.isScored)
        var score: Int?
        var lever: BalancePillar?
        if !paused, let combined = combine(scored.compactMap(\.score)) {
            score = combined
            lever = scored.min { a, b in
                (a.score ?? 0, a.pillar.tieOrder) < (b.score ?? 0, b.pillar.tieOrder)
            }?.pillar
        }
        let action = live
            ? Self.action(input, lever: lever, train: train, eat: eat, sleep: sleep,
                          eatParts: eatParts(week), unpaused: unpausedShare(window, pausedDays, input.calendar))
            : nil
        return Balance(window: window, train: train, eat: eat, sleep: sleep, score: score, lever: lever,
                       action: action,
                       notes: live ? notes(input, window: window, eat: eat, pausedDays: pausedDays) : [],
                       result: live ? result(input) : nil, paused: paused)
    }

    /// Half the average of the scores plus half the weakest; nil under two.
    static func combine(_ scores: [Int]) -> Int? {
        guard scores.count >= 2 else { return nil }
        let values = scores.map(Double.init)
        let average = values.reduce(0, +) / Double(values.count)
        let weakest = values.min() ?? average
        return Int((0.5 * average + 0.5 * weakest).rounded())
    }

    /// The share of the window's days that aren't paused (1 with none).
    static func unpausedShare(_ window: DateInterval, _ pausedDays: Set<Date>, _ cal: Calendar) -> Double {
        let days = dayStarts(window, cal)
        guard !days.isEmpty, !pausedDays.isEmpty else { return 1 }
        return Double(days.filter { !pausedDays.contains($0) }.count) / Double(days.count)
    }

    // MARK: Train

    static func weeklyGoal(_ input: BalanceInputs) -> Int? {
        let planned = input.profile?.weekdays?.count ?? input.profile?.daysPerWeek ?? 0
        return planned > 0 ? planned : nil
    }

    static func volumeTarget(_ input: BalanceInputs) -> Double {
        if input.settings.volume == .maintain { return 6 }
        switch input.experience {
        case .beginner: return 6
        case .intermediate: return 10
        case .advanced: return 12
        }
    }

    /// The weekly goal, cut to the share of the window that isn't paused.
    static func trainGoal(_ input: BalanceInputs, unpaused share: Double = 1) -> Int {
        let goal = weeklyGoal(input) ?? 3
        guard share < 1 else { return goal }
        return max(1, Int((Double(goal) * share).rounded()))
    }

    /// Train is tracked from the week of the first logged workout. The live
    /// window always is, so a new user is still invited to start.
    private static func trainTracked(_ input: BalanceInputs, window: DateInterval, live: Bool) -> Bool {
        if live { return true }
        let cal = input.calendar
        guard let first = input.sessions.filter({ $0.hasCompletedSets }).map({ cal.startOfDay(for: $0.day) }).min() else {
            return false
        }
        return window.end > first
    }

    static func trainScore(_ input: BalanceInputs, window: DateInterval, paused: Bool,
                           pausedDays: Set<Date> = []) -> PillarScore {
        let cal = input.calendar
        let days = dayStarts(window, cal)
        let share = unpausedShare(window, pausedDays, cal)
        // Paused days lead a rolling window (the week before this one), so
        // the sets count from the first day left.
        let setsStart = days.first { !pausedDays.contains($0) } ?? window.start
        let trainedDays = Set(input.sessions.filter { $0.hasCompletedSets && $0.day >= window.start && $0.day < window.end }
            .map { cal.startOfDay(for: $0.day) }).subtracting(pausedDays)
        let goal = trainGoal(input, unpaused: share)
        let showingUp = min(1, Double(trainedDays.count) / Double(goal))
        let sets = MuscleActivityCalculator().effectiveSets(from: input.sessions, start: setsStart, end: window.end)
        let groups = input.splitGroups.sorted { $0.rawValue < $1.rawValue }
        let target = share < 1 ? max(1, (volumeTarget(input) * share).rounded()) : volumeTarget(input)
        var parts: [BalancePart] = [
            BalancePart(label: String(localized: "Showing up", comment: "Balance part"),
                        value: trainedDays.count > goal
                            ? String(localized: "\(trainedDays.count) days · goal \(goal)", comment: "Balance: days trained, past the weekly goal")
                            : String(localized: "\(trainedDays.count) of \(goal) days", comment: "Balance: days trained of the weekly goal"),
                        detail: weeklyGoal(input) == nil ? String(localized: "Set your training days in your plan.") : nil)
        ]
        var coverage: Double?
        if !groups.isEmpty {
            let shares = groups.map { min(1, (sets[$0] ?? 0) / target) }
            coverage = shares.reduce(0, +) / Double(shares.count)
            let reached = groups.filter { (sets[$0] ?? 0) >= target }.count
            parts.append(BalancePart(label: String(localized: "Coverage", comment: "Balance part"),
                                     value: String(localized: "\(reached) of \(groups.count) muscles at \(Int(target))+ sets",
                                                   comment: "Balance: muscle groups that reached the weekly set target")))
            if let lagging = groups.min(by: { (sets[$0] ?? 0) < (sets[$1] ?? 0) }), (sets[lagging] ?? 0) < target {
                parts.append(BalancePart(label: String(localized: "Furthest behind", comment: "Balance part"),
                                         value: String(localized: "\(lagging.title): \(setsText(sets[lagging] ?? 0)) of \(Int(target))",
                                                       comment: "Balance: the muscle group furthest behind its weekly sets")))
            }
            if let heavy = groups.first(where: { (sets[$0] ?? 0) > 25 }) {
                parts.append(BalancePart(label: String(localized: "Note", comment: "Balance part"),
                                         value: String(localized: "\(heavy.title) past 25 sets: more isn't better past about 20.")))
            }
        }
        let value = 0.6 * showingUp + 0.4 * (coverage ?? showingUp)
        let planned = Set(input.profile?.weekdays ?? [])
        let today = cal.startOfDay(for: input.now)
        let marks: [BalanceMark] = days.map { day in
            if pausedDays.contains(day) { return .noData }
            if trainedDays.contains(day) { return .full }
            if day > today { return .noData }
            let weekday = cal.component(.weekday, from: day)
            if !planned.isEmpty, !planned.contains(weekday) { return .rest }
            return day == today ? .noData : .empty
        }
        let summary = trainedDays.count > goal
            ? String(localized: "\(trainedDays.count) workouts · goal \(goal)", comment: "Balance: Train summary past the goal")
            : String(localized: "\(trainedDays.count) of \(goal) workouts", comment: "Balance: Train summary")
        return PillarScore(pillar: .train, score: paused ? nil : Int((value * 100).rounded()),
                           status: .scored, summary: summary, parts: parts, marks: marks)
    }

    private static func setsText(_ value: Double) -> String {
        value.rounded() == value ? Int(value).formatted() : value.formatted(.number.precision(.fractionLength(1)))
    }

    // MARK: Eat

    fileprivate struct EatDay {
        var protein: Double?
        var calories: Double?
        var water: Double?
        var value: Double? {
            var total = 0.0, weight = 0.0
            if let protein { total += 0.45 * protein; weight += 0.45 }
            if let calories { total += 0.40 * calories; weight += 0.40 }
            guard weight > 0 else { return nil }
            if let water { total += 0.15 * water; weight += 0.15 }
            return total / weight
        }
    }

    /// The window's Eat days, worked out once for the score and the action.
    fileprivate struct EatWeek {
        var days: [Date: EatDay] = [:]
        /// Days a check-in answered at least one part.
        var checkInDays = 0
    }

    /// Eat's parts, for the action to start from the weakest.
    enum EatPart: Hashable { case protein, calories, water }

    /// Eat has something to score: on in Settings, and protein or calories
    /// left (kidney disease takes protein out, hidden calorie numbers take
    /// calories out).
    static func eatScorable(_ input: BalanceInputs) -> Bool {
        let kidney = input.profile?.health?.has(.kidneyDisease) ?? false
        return input.settings.scoresEat && !(kidney && input.settings.hidesCalories)
    }

    static func eatScore(_ input: BalanceInputs, window: DateInterval, pausedDays: Set<Date> = []) -> PillarScore {
        eatScore(input, window: window, week: eatWeek(input, window: window, pausedDays: pausedDays))
    }

    private static func eatWeek(_ input: BalanceInputs, window: DateInterval, pausedDays: Set<Date>) -> EatWeek {
        let cal = input.calendar
        let today = cal.startOfDay(for: input.now)
        let kidney = input.profile?.health?.has(.kidneyDisease) ?? false
        let hideCalories = input.settings.hidesCalories
        func water(on day: Date, hasFood: Bool) -> Double? {
            guard input.waterCounts else { return nil }
            let drunk = input.daily.waterDrunk(on: day)
            guard drunk > 0 || hasFood else { return nil }
            return min(1, Double(drunk) / Double(max(1, input.daily.waterTarget)))
        }
        var week = EatWeek()
        // Today's log is still running: held to the bar below unless today
        // is checked in.
        var todayFromLog = false
        for day in dayStarts(window, cal) where day <= today && !pausedDays.contains(day) {
            var entry = EatDay()
            let meals = input.daily.meals(on: day)
            let check = input.daily.checkIn(on: day)
            let finished = day < today
            if !meals.isEmpty, let plan = input.plan {
                let eaten = input.daily.eaten(on: day)
                // Half the plan's calories or more: plausibly the whole day.
                let covers = Double(eaten.kcal) >= 0.5 * plan.calories
                // A food typed in by hand saves a blank protein as 0 g, so
                // the log tells protein only for a meal whose foods carry
                // macros (a scan's or the food table's) or one with protein.
                let proteinKnown = meals.contains { $0.carriesMacros || $0.proteinG > 0 }
                if !kidney, proteinKnown, covers || check == nil {
                    entry.protein = min(1, Double(eaten.proteinG) / max(1, 0.9 * plan.protein))
                }
                if !hideCalories, covers || (finished && check == nil) {
                    // Never above 90% of the plan, so eating a plan that sits
                    // at or under the floor can't score 0.
                    let floor = min(NutritionPlan.calorieFloor(plan.sex), 0.9 * plan.calories)
                    if Double(eaten.kcal) < floor, finished {
                        entry.calories = 0
                    } else {
                        let off = abs(Double(eaten.kcal) / max(1, plan.calories) - 1)
                        entry.calories = off <= 0.1 ? 1 : max(0, 1 - (off - 0.1) / 0.2)
                    }
                }
                if !finished, check == nil, entry.protein != nil || entry.calories != nil { todayFromLog = true }
            }
            // The check-in answers whatever the log doesn't cover; a
            // question it didn't ask is nil and stays out.
            if let check {
                var answered = false
                if !kidney, entry.protein == nil, let protein = check.protein {
                    switch protein {
                    case .hit: entry.protein = 1
                    case .close: entry.protein = 0.6
                    case .missed: entry.protein = 0.3
                    }
                    answered = true
                }
                if !hideCalories, entry.calories == nil, let plan = check.plan {
                    switch plan {
                    case .aboutRight: entry.calories = 1
                    case .bitOff: entry.calories = 0.6
                    case .wayOff: entry.calories = 0.2
                    }
                    answered = true
                }
                if answered { week.checkInDays += 1 }
            }
            entry.water = water(on: day, hasFood: entry.protein != nil || entry.calories != nil)
            week.days[day] = entry
        }
        // Today from a log so far counts only when it doesn't lower the
        // score: at least the finished days' average, or 0.85 without one.
        if todayFromLog, let value = week.days[today]?.value {
            let finished = week.days.filter { $0.key != today }.compactMap { $0.value.value }
            let bar = finished.isEmpty ? 0.85 : finished.reduce(0, +) / Double(finished.count)
            if value < bar {
                week.days[today] = EatDay(water: water(on: today, hasFood: false))
            }
        }
        return week
    }

    /// The parts by weighted shortfall, (1 − the part's average) × its
    /// weight, largest first; only parts that were scored.
    private static func eatParts(_ week: EatWeek) -> [EatPart] {
        let scored = week.days.values.filter { $0.value != nil }
        func shortfall(_ values: [Double], weight: Double) -> Double? {
            values.isEmpty ? nil : (1 - values.reduce(0, +) / Double(values.count)) * weight
        }
        var ranked: [(part: EatPart, shortfall: Double)] = []
        if let value = shortfall(scored.compactMap { $0.protein }, weight: 0.45) { ranked.append((part: .protein, shortfall: value)) }
        if let value = shortfall(scored.compactMap { $0.calories }, weight: 0.40) { ranked.append((part: .calories, shortfall: value)) }
        if let value = shortfall(scored.compactMap { $0.water }, weight: 0.15) { ranked.append((part: .water, shortfall: value)) }
        // On a tie the order above stands (protein, then calories, then water).
        var result: [EatPart] = []
        while let best = ranked.indices.max(by: { a, b in
            ranked[a].shortfall < ranked[b].shortfall || (ranked[a].shortfall == ranked[b].shortfall && a > b)
        }) {
            result.append(ranked[best].part)
            ranked.remove(at: best)
        }
        return result
    }

    private static func eatScore(_ input: BalanceInputs, window: DateInterval, week: EatWeek) -> PillarScore {
        let cal = input.calendar
        let kidney = input.profile?.health?.has(.kidneyDisease) ?? false
        var proteinHits = 0, proteinDays = 0, calorieGood = 0, calorieDays = 0, waterGood = 0, waterDays = 0
        for entry in week.days.values {
            if let p = entry.protein { proteinDays += 1; if p >= 0.9 { proteinHits += 1 } }
            if let c = entry.calories { calorieDays += 1; if c >= 0.9 { calorieGood += 1 } }
            if let w = entry.water { waterDays += 1; if w >= 1 { waterGood += 1 } }
        }
        let scoredDays = week.days.values.compactMap(\.value)
        var parts: [BalancePart] = []
        if proteinDays > 0, let plan = input.plan {
            parts.append(BalancePart(label: String(localized: "Protein", comment: "Balance part"),
                                     value: String(localized: "Hit \(proteinHits) of \(proteinDays) days", comment: "Balance: protein days"),
                                     detail: String(localized: "Target about \(Int(plan.protein)) g a day.")))
        }
        if kidney {
            parts.append(BalancePart(label: String(localized: "Protein", comment: "Balance part"),
                                     value: String(localized: "Not scored"),
                                     detail: String(localized: "With kidney disease your protein is your doctor's call.")))
        }
        if calorieDays > 0 {
            parts.append(BalancePart(label: String(localized: "Eating vs plan", comment: "Balance part"),
                                     value: String(localized: "About right \(calorieGood) of \(calorieDays) days", comment: "Balance: calorie days")))
        }
        if waterDays > 0 {
            parts.append(BalancePart(label: String(localized: "Water", comment: "Balance part"),
                                     value: String(localized: "Target \(waterGood) of \(waterDays) days", comment: "Balance: water days")))
        }
        if week.checkInDays > 0 {
            parts.append(BalancePart(label: String(localized: "Source", comment: "Balance part"),
                                     value: String(localized: "Your check-ins, \(week.checkInDays) days", comment: "Balance: check-in days")))
        }
        let marks: [BalanceMark] = dayStarts(window, cal).map { day in
            guard let value = week.days[day]?.value else { return .noData }
            return value >= 0.85 ? .full : value >= 0.5 ? .half : .empty
        }
        let summary = proteinDays > 0
            ? String(localized: "Protein \(proteinHits) of \(proteinDays) days", comment: "Balance: Eat summary")
            : String(localized: "About right \(calorieGood) of \(calorieDays) days", comment: "Balance: Eat summary without protein")
        guard !scoredDays.isEmpty else {
            return PillarScore(pillar: .eat, score: nil, status: .notTracked,
                               summary: String(localized: "Not tracked"), parts: parts, marks: marks)
        }
        guard scoredDays.count >= 4 else {
            return PillarScore(pillar: .eat, score: nil, status: .needsMore(have: scoredDays.count, need: 4),
                               summary: String(localized: "\(scoredDays.count) of 4 days", comment: "Balance: days logged of the 4 needed"),
                               parts: parts, marks: marks)
        }
        let value = scoredDays.reduce(0, +) / Double(scoredDays.count)
        return PillarScore(pillar: .eat, score: Int((value * 100).rounded()), status: .scored,
                           summary: summary, parts: parts, marks: marks)
    }

    /// Eat off: by Settings, or with nothing left to score.
    private static func eatOff(_ input: BalanceInputs, window: DateInterval) -> PillarScore {
        let base = off(.eat, window: window, input: input)
        guard input.settings.scoresEat else { return base }
        return PillarScore(pillar: .eat, score: nil, status: .off, summary: base.summary,
                           parts: [BalancePart(label: String(localized: "Note", comment: "Balance part"),
                                               value: String(localized: "Not scored"),
                                               detail: String(localized: "With kidney disease protein is your doctor's call, and calorie numbers are hidden, so Eat has nothing to score."))],
                           marks: base.marks)
    }

    // MARK: Sleep

    static func sleepScore(_ input: BalanceInputs, window: DateInterval, pausedDays: Set<Date> = []) -> PillarScore {
        let cal = input.calendar
        guard input.settings.scoresSleep else { return off(.sleep, window: window, input: input) }
        let today = cal.startOfDay(for: input.now)
        let full = Double(max(input.sleepGoalMinutes - 60, 420))
        func credit(_ minutes: Double) -> Double {
            minutes >= full ? 1 : max(0, 1 - (full - minutes) / 150)
        }
        var perNight: [Date: (credit: Double, minutes: Int, estimate: Bool)] = [:]
        var measured: [AppleHealth.SleepNight] = []
        for night in input.nights where night.day >= window.start && night.day < window.end && night.day <= today
            && !pausedDays.contains(night.day) {
            perNight[night.day] = (credit(Double(night.asleepMinutes)), night.asleepMinutes, false)
            measured.append(night)
        }
        var estimates = 0
        if input.settings.estimatesSleep {
            for day in dayStarts(window, cal) where day <= today && perNight[day] == nil && !pausedDays.contains(day) {
                guard let estimate = input.daily.sleepEstimate(on: day) else { continue }
                // 90% of a measured night of the band's middle, whatever
                // the goal: people over-report sleep (Lauderdale 2008).
                perNight[day] = (0.9 * credit(Double(estimate.band.minutes)), estimate.band.minutes, true)
                estimates += 1
            }
        }
        // "Long enough" is by length, measured or estimated alike; the
        // estimate's discount stays in the score.
        let marks: [BalanceMark] = dayStarts(window, cal).map { day in
            guard let night = perNight[day] else { return .noData }
            return Double(night.minutes) >= full ? .full : night.credit >= 0.5 ? .half : .empty
        }
        guard !perNight.isEmpty else {
            return PillarScore(pillar: .sleep, score: nil, status: .notTracked,
                               summary: String(localized: "Not tracked"), parts: [], marks: marks)
        }
        let minutes = perNight.values.map(\.minutes)
        let average = minutes.reduce(0, +) / minutes.count
        let reached = perNight.values.filter { Double($0.minutes) >= full }.count
        var parts = [
            BalancePart(label: String(localized: "Average", comment: "Balance part"),
                        value: String(localized: "\(HealthFormat.sleep(minutes: average)) a night", comment: "Balance: average sleep")),
            BalancePart(label: String(localized: "Long enough", comment: "Balance part"),
                        value: String(localized: "\(reached) of \(perNight.count) nights \(HealthFormat.sleep(minutes: Int(full)))+",
                                      comment: "Balance: nights that reached the full-credit length"))
        ]
        var regularity: Double?
        if let spread = midpointSpread(measured, calendar: cal) {
            regularity = spread <= 30 ? 1 : max(0, 1 - (spread - 30) / 60)
            parts.append(BalancePart(label: String(localized: "Bedtime spread", comment: "Balance part"),
                                     value: String(localized: "\(Int(spread.rounded())) min", comment: "Balance: spread of sleep midpoints"),
                                     detail: String(localized: "How much the middle of your sleep moves night to night. 30 min or less is steady.")))
        }
        if estimates > 0 {
            parts.append(BalancePart(label: String(localized: "Source", comment: "Balance part"),
                                     value: String(localized: "Your estimates, \(estimates) nights", comment: "Balance: estimated nights")))
        }
        let summary = String(localized: "\(HealthFormat.sleep(minutes: average)) a night", comment: "Balance: Sleep summary")
        guard perNight.count >= 4 else {
            return PillarScore(pillar: .sleep, score: nil, status: .needsMore(have: perNight.count, need: 4),
                               summary: String(localized: "\(perNight.count) of 4 nights", comment: "Balance: nights of the 4 needed"),
                               parts: parts, marks: marks)
        }
        let nightsValue = perNight.values.map(\.credit).reduce(0, +) / Double(perNight.count)
        let value = regularity.map { 0.8 * nightsValue + 0.2 * $0 } ?? nightsValue
        return PillarScore(pillar: .sleep, score: Int((value * 100).rounded()), status: .scored,
                           summary: summary, parts: parts, marks: marks)
    }

    /// Standard deviation of the sleep midpoints in minutes (5+ nights).
    static func midpointSpread(_ nights: [AppleHealth.SleepNight], calendar: Calendar) -> Double? {
        guard nights.count >= 5 else { return nil }
        // Minutes after the noon before the wake day, so midnight doesn't wrap.
        let values: [Double] = nights.compactMap { night in
            guard let noon = calendar.date(byAdding: .hour, value: -12, to: night.day) else { return nil }
            let mid = night.start.addingTimeInterval(night.end.timeIntervalSince(night.start) / 2)
            return mid.timeIntervalSince(noon) / 60
        }
        guard values.count >= 5 else { return nil }
        let mean = values.reduce(0, +) / Double(values.count)
        let variance = values.map { ($0 - mean) * ($0 - mean) }.reduce(0, +) / Double(values.count)
        return variance.squareRoot()
    }

    private static func off(_ pillar: BalancePillar, window: DateInterval, input: BalanceInputs) -> PillarScore {
        PillarScore(pillar: pillar, score: nil, status: .off, summary: String(localized: "Not scored"),
                    parts: [], marks: dayStarts(window, input.calendar).map { _ in .noData })
    }

    private static func notTracked(_ pillar: BalancePillar, window: DateInterval, input: BalanceInputs) -> PillarScore {
        PillarScore(pillar: pillar, score: nil, status: .notTracked, summary: String(localized: "Not tracked"),
                    parts: [], marks: dayStarts(window, input.calendar).map { _ in .noData })
    }

    // MARK: Action, notes, result

    /// Today's own entry for a pillar while today's is missing, whatever
    /// the pillar's score: the eating check-in (nothing checked in or
    /// logged today, and Eat has something to score), or "Slept about…"
    /// (estimates on, sleep scored, no night from Apple Health for today
    /// and no estimate yet). Nil for Train and once today's is in.
    static func todayInvitation(_ input: BalanceInputs, pillar: BalancePillar) -> BalanceAction? {
        let cal = input.calendar
        let today = cal.startOfDay(for: input.now)
        switch pillar {
        case .train:
            return nil
        case .eat:
            guard eatScorable(input), input.daily.checkIn(on: today) == nil,
                  input.daily.meals(on: today).isEmpty else { return nil }
            return BalanceAction(pillar: .eat, text: String(localized: "How did you eat today? Two taps."), kind: .checkIn)
        case .sleep:
            guard input.settings.scoresSleep, input.settings.estimatesSleep,
                  !input.nights.contains(where: { cal.isDate($0.day, inSameDayAs: today) }),
                  input.daily.sleepEstimate(on: today) == nil else { return nil }
            return BalanceAction(pillar: .sleep, text: String(localized: "How long did you sleep last night?"),
                                 kind: .sleepEstimate)
        }
    }

    /// `eatParts`: Eat's parts, weakest first. `unpaused`: the share of the
    /// window that isn't paused, which the workout goal shrinks to.
    static func action(_ input: BalanceInputs, lever: BalancePillar?, train: PillarScore,
                       eat: PillarScore, sleep: PillarScore, eatParts: [EatPart] = [],
                       unpaused: Double = 1) -> BalanceAction? {
        let cal = input.calendar
        let hour = cal.component(.hour, from: input.now)
        let today = cal.startOfDay(for: input.now)
        // No Balance yet: invite the missing pillar first.
        let target = lever ?? (sleep.status == .notTracked && input.settings.scoresSleep ? .sleep
                               : eat.status == .notTracked ? .eat : .train)
        switch target {
        case .train:
            let goal = trainGoal(input, unpaused: unpaused)
            let done = train.marks.filter { $0 == .full }.count
            if done < goal {
                let left = goal - done
                return BalanceAction(pillar: .train,
                                     text: left == 1 ? String(localized: "1 workout left for your \(goal) this week.")
                                                     : String(localized: "\(left) workouts left for your \(goal) this week."),
                                     kind: .startWorkout)
            }
            if let behind = train.parts.first(where: { $0.label == String(localized: "Furthest behind", comment: "Balance part") }) {
                return BalanceAction(pillar: .train,
                                     text: String(localized: "\(behind.value) sets this week: add a few next session."),
                                     kind: .startWorkout)
            }
            return BalanceAction(pillar: .train, text: String(localized: "Training is on track. Rest counts too."), kind: .none)
        case .eat:
            if hour >= 17, let invitation = todayInvitation(input, pillar: .eat) { return invitation }
            if eat.status == .notTracked {
                return BalanceAction(pillar: .eat, text: String(localized: "Check in on eating each evening to score it."),
                                     kind: .checkIn)
            }
            let checkInKind: BalanceAction.Kind = input.daily.checkIn(on: today) == nil ? .checkIn : .none
            let kidney = input.profile?.health?.has(.kidneyDisease) ?? false
            // The weakest part first: no protein line for a user who hits it.
            for part in eatParts {
                switch part {
                case .protein:
                    guard let plan = input.plan, !kidney else { continue }
                    let grams = Int(plan.protein)
                    return BalanceAction(pillar: .eat,
                                         text: String(localized: "About \(grams) g protein today: about \(Int((plan.protein / 4).rounded())) g at each of 4 meals."),
                                         kind: checkInKind)
                case .calories:
                    guard !input.settings.hidesCalories else { continue }
                    guard let plan = input.plan else {
                        return BalanceAction(pillar: .eat, text: String(localized: "Eat close to your plan today."),
                                             kind: checkInKind)
                    }
                    let kcal = Int(plan.calories).formatted()
                    return BalanceAction(pillar: .eat,
                                         text: String(localized: "Eat close to your plan today: about \(kcal) kcal.",
                                                      comment: "Balance action: the plan's daily calories"),
                                         kind: checkInKind)
                case .water:
                    let left = input.daily.waterTarget - input.daily.waterDrunk(on: input.now)
                    guard input.waterCounts, left > 0 else { continue }
                    return BalanceAction(pillar: .eat, text: String(localized: "\(DailyStore.litres(left)) of water to go today."),
                                         kind: .addWater(input.daily.waterPresets.first ?? 250))
                }
            }
            return BalanceAction(pillar: .eat, text: String(localized: "Check in this evening."), kind: .checkIn)
        case .sleep:
            if let invitation = todayInvitation(input, pillar: .sleep) { return invitation }
            if sleep.status == .notTracked, input.healthAvailable && !input.healthConnected {
                return BalanceAction(pillar: .sleep, text: String(localized: "Connect Apple Health to score sleep from your Watch."),
                                     kind: .connectHealth)
            }
            // Already set: say so, with no button to set it again.
            let reminder = input.daily.bedtimeReminder
            if reminder.isOn {
                let time = clock(reminder.hour, reminder.minute, input)
                return BalanceAction(pillar: .sleep,
                                     text: String(localized: "Wind-down reminder at \(time)",
                                                  comment: "Balance action: the wind-down reminder is on; a time"),
                                     kind: .none)
            }
            let (bedHour, bedMinute) = bedtime(input)
            let time = clock(bedHour, bedMinute, input)
            return BalanceAction(pillar: .sleep,
                                 text: String(localized: "Lights out by \(time) for \(HealthFormat.sleep(minutes: max(input.sleepGoalMinutes, 420))) of sleep.",
                                              comment: "Balance action: bedtime"),
                                 kind: .bedtime(hour: bedHour, minute: bedMinute))
        }
    }

    /// A time of day as the locale writes it ("22:15", "10:15 PM").
    static func clock(_ hour: Int, _ minute: Int, _ input: BalanceInputs) -> String {
        let date = input.calendar.date(bySettingHour: hour, minute: minute, second: 0, of: input.now) ?? input.now
        return date.formatted(date: .omitted, time: .shortened)
    }

    /// Usual wake time (median of the last 7 measured wake-ups, else 6:30)
    /// minus the sleep goal.
    static func bedtime(_ input: BalanceInputs) -> (hour: Int, minute: Int) {
        let cal = input.calendar
        let wakes = input.nights.suffix(7).map { cal.component(.hour, from: $0.end) * 60 + cal.component(.minute, from: $0.end) }
            .sorted()
        let wake = wakes.isEmpty ? 6 * 60 + 30 : wakes[wakes.count / 2]
        var bed = wake - max(input.sleepGoalMinutes, 420)
        if bed < 0 { bed += 24 * 60 }
        // Round to the quarter hour before.
        bed = bed / 15 * 15
        return (bed / 60, bed % 60)
    }

    /// Sleep notes only while sleep is scored, from the window's own nights
    /// (paused days left out); no protein note with kidney disease, where
    /// protein is the doctor's call.
    static func notes(_ input: BalanceInputs, window: DateInterval, eat: PillarScore,
                      pausedDays: Set<Date> = []) -> [String] {
        var notes: [String] = []
        let today = input.calendar.startOfDay(for: input.now)
        let cutting = input.plan?.effectiveGoal == .loseWeight
        let kidney = input.profile?.health?.has(.kidneyDisease) ?? false
        let scoresSleep = input.settings.scoresSleep
        let recent = input.nights.filter {
            $0.day >= window.start && $0.day < window.end && $0.day <= today && !pausedDays.contains($0.day)
        }.map(\.asleepMinutes)
        if scoresSleep, cutting, recent.count >= 4, recent.reduce(0, +) / recent.count < 390 {
            notes.append(String(localized: "In a cut, short sleep shifts the loss from fat to muscle (Nedeltcheva 2010)."))
        }
        if cutting, !kidney, let score = eat.score, score < 65 {
            notes.append(String(localized: "Protein protects muscle in a cut (Helms 2014)."))
        }
        if scoresSleep, let last = input.nights.last, last.asleepMinutes < 360, last.day == today {
            notes.append(String(localized: "Short sleep raises hunger the next day (Spiegel 2004): plan your meals today."))
        }
        return notes
    }

    static func result(_ input: BalanceInputs) -> BalanceResult? {
        guard let plan = input.plan else { return nil }
        switch plan.effectiveGoal {
        case .loseWeight, .buildMuscle:
            guard let change = input.daily.trendChange(days: 14, at: input.now) else { return nil }
            let perWeek = change / 2
            let target = plan.weeklyChangeKg
            let kg = perWeek.formatted(.number.precision(.fractionLength(1)).sign(strategy: .always()))
            let planText = target.formatted(.number.precision(.fractionLength(1)).sign(strategy: .always()))
            var pace: BalanceResult.Pace = .holding
            if target != 0 {
                let ratio = perWeek / target
                pace = ratio >= 0.5 && ratio <= 1.5 ? .onPace : ratio < 0.5 ? .slower : .faster
            }
            let paceText: String
            switch pace {
            case .onPace: paceText = String(localized: "On pace", comment: "Balance result")
            case .slower: paceText = String(localized: "Slower than plan", comment: "Balance result")
            case .faster: paceText = String(localized: "Faster than plan", comment: "Balance result")
            case .holding: paceText = String(localized: "Holding", comment: "Balance result")
            }
            return BalanceResult(text: String(localized: "Weight \(kg) kg/wk · plan \(planText) · \(paceText)",
                                              comment: "Balance result: weekly weight change against the plan"),
                                 pace: pace)
        case .recomp, .getFit:
            guard let change = input.keyLiftChange else { return nil }
            let percent = change.formatted(.percent.precision(.fractionLength(0)).sign(strategy: .always()))
            return BalanceResult(text: String(localized: "Key lifts \(percent) in 8 weeks", comment: "Balance result"),
                                 pace: change >= 0 ? .onPace : .slower)
        }
    }

    // MARK: Your weeks

    /// The better-balanced half of finished weeks against the rest, once
    /// there are 8 such weeks with a weight result and the same pillars
    /// (weight goals only; weeks are paired with the next week's change,
    /// since weight lags habits). Takes `history(weeks: 14)`: 13 finished
    /// weeks give up to 12 pairs of finished weeks — the current week,
    /// still running and overlapping the last one, is never a "next" week.
    /// An early read under 10.
    static func compare(_ weeks: [BalanceWeek], goal: FitnessGoal?) -> BalanceComparison? {
        guard goal == .loseWeight || goal == .buildMuscle else { return nil }
        var pairs: [(week: BalanceWeek, change: Double)] = []
        for (index, week) in weeks.enumerated() where !week.isCurrent && !week.paused && week.balance.score != nil {
            guard index + 1 < weeks.count, !weeks[index + 1].isCurrent,
                  let now = week.weightKg, let next = weeks[index + 1].weightKg else { continue }
            pairs.append((week, next - now))
        }
        // Same pillar set only.
        let signature: (BalanceWeek) -> [Bool] = { w in w.balance.pillars.map(\.isScored) }
        guard let common = pairs.map({ signature($0.week) }).mostCommon else { return nil }
        let usable = pairs.filter { signature($0.week) == common }
        guard usable.count >= 8 else { return nil }
        let sorted = usable.sorted { ($0.week.balance.score ?? 0) > ($1.week.balance.score ?? 0) }
        let half = sorted.count / 2
        let better = Array(sorted.prefix(half)), other = Array(sorted.suffix(sorted.count - half))
        guard better.count >= 3, other.count >= 3 else { return nil }
        func mean(_ items: [(week: BalanceWeek, change: Double)]) -> Double {
            items.map(\.change).reduce(0, +) / Double(items.count)
        }
        let betterResult = mean(better), otherResult = mean(other)
        var had: [String] = []
        let sessions = better.map { Double($0.week.balance.train.marks.filter { $0 == .full }.count) }
        if !sessions.isEmpty {
            had.append(String(localized: "\(Int((sessions.reduce(0, +) / Double(sessions.count)).rounded())) sessions a week",
                              comment: "Your weeks: what the better weeks had"))
        }
        let sleepScores = better.compactMap(\.week.balance.sleep.score)
        if !sleepScores.isEmpty {
            had.append(String(localized: "Sleep score \(sleepScores.reduce(0, +) / sleepScores.count)", comment: "Your weeks"))
        }
        let eatScores = better.compactMap(\.week.balance.eat.score)
        if !eatScores.isEmpty {
            had.append(String(localized: "Eat score \(eatScores.reduce(0, +) / eatScores.count)", comment: "Your weeks"))
        }
        return BalanceComparison(weeksUsed: usable.count, betterResult: betterResult, otherResult: otherResult,
                                 unit: String(localized: "kg a week"),
                                 clearDifference: abs(betterResult - otherResult) >= 0.1,
                                 early: usable.count < 10, betterHad: had)
    }

    // MARK: AI question

    /// The question "Ask MUSQ" gets, with the week's numbers in it, so the
    /// user sees everything that is sent before sending. Sleep numbers (from
    /// Apple Health) only when `includeSleep`. Without them, a Balance that
    /// scored sleep isn't sent either — the sleep score could be worked back
    /// out of it — but Train and Eat's own Balance, as if sleep were off.
    static func aiQuestion(_ balance: Balance, goal: FitnessGoal?, includeSleep: Bool) -> String {
        var lines: [String] = []
        lines.append(String(localized: "My MUSQ Balance for the last 7 days (eating, sleep, training):"))
        if !includeSleep && balance.sleep.isScored {
            if !balance.paused, let score = combine([balance.train.score, balance.eat.score].compactMap { $0 }) {
                lines.append(String(localized: "Balance without sleep: \(score) (\(Balance.word(for: score))).",
                                    comment: "AI question line: Balance from Train and Eat only"))
            }
        } else if let score = balance.score, let word = balance.word {
            lines.append(String(localized: "Balance \(score) (\(word)).", comment: "AI question line"))
        }
        if let goal { lines.append(String(localized: "Goal: \(goal.title).", comment: "AI question line")) }
        for pillar in balance.pillars {
            if pillar.pillar == .sleep && !includeSleep {
                lines.append(String(localized: "Sleep: not shared.", comment: "AI question line"))
                continue
            }
            var line = "\(pillar.pillar.title): " + (pillar.score.map { "\($0)/100" } ?? pillar.summary)
            let details = pillar.parts.map { "\($0.label) \($0.value)" }
            if !details.isEmpty { line += " — " + details.joined(separator: "; ") }
            lines.append(line)
        }
        if let result = balance.result { lines.append(result.text) }
        lines.append(String(localized: "What am I missing in each of the three, and how exactly do I improve the weakest first?"))
        let text = lines.joined(separator: "\n")
        return String(text.prefix(1_900))
    }

    // MARK: Helpers

    static func dayStarts(_ window: DateInterval, _ cal: Calendar) -> [Date] {
        var days: [Date] = []
        var day = cal.startOfDay(for: window.start)
        while day < window.end && days.count < 8 {
            days.append(day)
            day = cal.date(byAdding: .day, value: 1, to: day) ?? window.end
        }
        return days
    }
}

private extension Array where Element: Hashable {
    var mostCommon: Element? {
        var counts: [Element: Int] = [:]
        for item in self { counts[item, default: 0] += 1 }
        return counts.max { $0.value < $1.value }?.key
    }
}
