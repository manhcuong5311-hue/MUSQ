//
//  Nudges.swift
//  GymWorkout
//
//  Trigger-timed local nudges (2026-11-27, owner's "Hooked" step 1): the
//  internal triggers — feeling behind, curious, proud — met by a local
//  notification at the moment they matter, worked out on the device from the
//  logs (workouts, meals, water, weigh-ins). Nothing leaves the phone;
//  friends/social pushes are a later round.
//
//  - Training time: on the profile's training days, about the user's usual
//    start (the median first-set time of recent sessions, 18:00 without
//    enough of them), unless that day already has sets.
//  - Behind: 21:00 today, what is still open (water short of the target,
//    dinner not logged, the planned workout), or protein short of the plan.
//  - Proud: the morning after a record set; and a streak milestone of days
//    with anything logged, kept alive in the evening.
//  - Curious: Sunday 17:00, the week's workouts and volume (the Goal
//    check-in keeps 19:00).
//  - Meal times: 12:15 and 19:15 while nothing was logged for that meal, for
//    members who log meals at all (no nagging people who never do).
//
//  Rules: at most three a day across types (those already delivered today
//  count), never in quiet hours (22:30-7:30), each type can be turned off in
//  Profile › Notifications. Laid for today and tomorrow and re-laid when the
//  app opens or goes to the background, under ids starting "nudge." so
//  DailyStore's ("water.", "weighin", "balance.") and the Goal's ("goal.")
//  are never touched. A nudge carries its route; tapping it sets
//  `NudgeRouter.shared.pending` for the root view. Sent and opened counts
//  per type stay in UserDefaults on the device (shown in DEBUG builds).
//

import Foundation
import Observation
import UIKit
import UserNotifications

// MARK: - Types

/// The nudge families the user can switch on and off.
nonisolated enum NudgeKind: String, CaseIterable, Identifiable, Sendable {
    case training, behind, proud, recap, meals

    var id: String { rawValue }

    var title: String {
        switch self {
        case .training: return String(localized: "Training time", comment: "Notification settings: nudge type")
        case .behind: return String(localized: "Left for today", comment: "Notification settings: nudge type, evening reminder of what's still open")
        case .proud: return String(localized: "Records and streaks", comment: "Notification settings: nudge type")
        case .recap: return String(localized: "Weekly recap", comment: "Notification settings: nudge type")
        case .meals: return String(localized: "Meal times", comment: "Notification settings: nudge type")
        }
    }

    var detail: String {
        switch self {
        case .training: return String(localized: "On training days, around the time you usually start.")
        case .behind: return String(localized: "At 9 pm, only if water, a meal or protein is still short.")
        case .proud: return String(localized: "The morning after a new record, and on streak days.")
        case .recap: return String(localized: "Sunday afternoon: your week in one line.")
        case .meals: return String(localized: "Lunch and dinner, only if you haven't logged them.")
        }
    }

    var symbol: String {
        switch self {
        case .training: return "dumbbell"
        case .behind: return "checklist"
        case .proud: return "trophy"
        case .recap: return "chart.bar"
        case .meals: return "fork.knife"
        }
    }

    /// `@AppStorage` key; every type is on until turned off.
    var storageKey: String { "nudge.on.\(rawValue)" }

    var isOn: Bool { UserDefaults.standard.object(forKey: storageKey) as? Bool ?? true }

    /// Nudges go out only after the user turned them on in Profile ›
    /// Notifications. A permission given for the rest timer or a water
    /// reminder before nudges existed is not a yes to them.
    static let optedInKey = "nudge.optedIn"
    static var optedIn: Bool { UserDefaults.standard.bool(forKey: optedInKey) }

    var sentKey: String { "nudge.sent.\(rawValue)" }
    var openedKey: String { "nudge.opened.\(rawValue)" }
}

/// Where a tapped notification sends the user. `food` is Today with the meal
/// logger in reach; `progress` is the Progress tab.
nonisolated enum NudgeRoute: String, Sendable {
    case today, train, food, progress
    /// A friend's nudge (FriendsInbox, ids "friends.nudge.").
    case friends
}

/// The one route waiting to be shown, set when a notification is tapped.
/// The root view observes `pending`, switches tab and calls `consume()`.
@Observable
final class NudgeRouter {
    static let shared = NudgeRouter()

    var pending: NudgeRoute?

    /// Takes the pending route, leaving none.
    func consume() -> NudgeRoute? {
        defer { pending = nil }
        return pending
    }

    /// A tapped notification: its route, and one more "opened" for a nudge.
    func open(identifier: String, route: String?, kind: String?) {
        if let kind = kind.flatMap(NudgeKind.init(rawValue:)) {
            let key = kind.openedKey
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: key) + 1, forKey: key)
        }
        pending = route.flatMap(NudgeRoute.init(rawValue:)) ?? Self.route(forIdentifier: identifier)
    }

    /// Routes for the app's other notifications. Any other one (the rest
    /// timer, water and weigh-in reminders) leaves the app where it is, so a
    /// "Rest over" tap never pulls the user out of their workout.
    private static func route(forIdentifier id: String) -> NudgeRoute? {
        if id.hasPrefix("friends.") { return .friends }
        if id.hasPrefix("nudge.") || id.hasPrefix("goal.") { return .today }
        if id.hasPrefix("balance.checkin") { return .food }
        return nil
    }
}

/// Foreground banners for nudges (the app's other reminders go quietly to
/// Notification Center, as before when nothing presented them), and taps
/// routed through `NudgeRouter`.
final class NudgeNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NudgeNotificationDelegate()

    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            willPresent notification: UNNotification,
                                            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let isNudge = notification.request.identifier.hasPrefix("nudge.")
        completionHandler(isNudge ? [.banner, .list, .sound] : [.list])
    }

    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            didReceive response: UNNotificationResponse,
                                            withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        let info = response.notification.request.content.userInfo
        let route = info["route"] as? String
        let kind = info["kind"] as? String
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            Task { @MainActor in
                NudgeRouter.shared.open(identifier: id, route: route, kind: kind)
            }
        }
        completionHandler()
    }
}

// MARK: - Inputs

/// What the planner reads: a copy of the logs, from the live stores when the
/// root view has attached them, else read from their files (read-only).
struct NudgeInputs {
    var sessions: [WorkoutSession]
    var profile: UserProfile?
    var experience: TrainingExperience
    var unit: WeightUnit
    var water: [WaterEntry]
    var meals: [MealEntry]
    var weights: [WeightEntry]
    var waterTarget: Int

    init(store: WorkoutStore, daily: DailyStore) {
        sessions = store.sessions
        profile = store.profile
        experience = store.experience
        unit = store.unit
        water = daily.water
        meals = daily.meals
        weights = daily.weights
        waterTarget = daily.waterTarget
    }

    /// The saved files, decoded without the stores (which would set an
    /// unreadable file aside). Nil before onboarding or when unreadable.
    static func fromDisk() -> NudgeInputs? {
        struct Workouts: Decodable {
            var experience: TrainingExperience
            var unit: WeightUnit?
            var profile: UserProfile?
            var sessions: [WorkoutSession]
            var recompGoal: Bool?
        }
        struct Daily: Decodable {
            var water: [WaterEntry]
            var weights: [WeightEntry]
            var meals: [MealEntry]?
            var waterTargetOverride: Int?
        }
        // The stores' own decoders are private; both save dates as ISO 8601.
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let data = try? Data(contentsOf: WorkoutStore.defaultFileURL),
              let workouts = try? decoder.decode(Workouts.self, from: data) else { return nil }
        var profile = workouts.profile
        if workouts.recompGoal == true { profile?.goal = .recomp }
        let daily = (try? Data(contentsOf: DailyStore.defaultFileURL))
            .flatMap { try? decoder.decode(Daily.self, from: $0) }
        return NudgeInputs(sessions: workouts.sessions, profile: profile, experience: workouts.experience,
                           unit: workouts.unit ?? .kg, water: daily?.water ?? [], meals: daily?.meals ?? [],
                           weights: daily?.weights ?? [],
                           waterTarget: daily?.waterTargetOverride ?? DailyStore.waterTarget(for: profile))
    }

    init(sessions: [WorkoutSession], profile: UserProfile?, experience: TrainingExperience, unit: WeightUnit,
         water: [WaterEntry], meals: [MealEntry], weights: [WeightEntry], waterTarget: Int) {
        self.sessions = sessions
        self.profile = profile
        self.experience = experience
        self.unit = unit
        self.water = water
        self.meals = meals
        self.weights = weights
        self.waterTarget = waterTarget
    }
}

// MARK: - Planner

struct PlannedNudge: Equatable {
    var kind: NudgeKind
    var fire: Date
    var title: String
    var body: String
    var route: NudgeRoute
    /// Lower goes first when the day's three are picked.
    var priority: Int
}

/// Works out the nudges for today and tomorrow. Pure: everything comes in.
enum NudgePlanner {
    static let dailyCap = 3
    static let streakMilestones: Set<Int> = [3, 7, 14, 21, 30, 50, 75, 100, 150, 200, 365]

    /// 22:30-7:30, in minutes of the day.
    static func isQuiet(_ date: Date, calendar: Calendar) -> Bool {
        let parts = calendar.dateComponents([.hour, .minute], from: date)
        let minutes = (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
        return minutes >= 22 * 60 + 30 || minutes < 7 * 60 + 30
    }

    static func plan(_ inputs: NudgeInputs, enabled: Set<NudgeKind>, firedToday: Int,
                     now: Date = Date(), calendar: Calendar = .current) -> [PlannedNudge] {
        guard inputs.profile != nil, !enabled.isEmpty else { return [] }
        let today = calendar.startOfDay(for: now)
        var result: [PlannedNudge] = []
        for offset in 0...1 {
            guard let day = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
            var candidates: [PlannedNudge] = []
            if enabled.contains(.training), let item = training(inputs, day: day, calendar: calendar) {
                candidates.append(item)
            }
            if enabled.contains(.behind), offset == 0, let item = behind(inputs, day: day, calendar: calendar) {
                candidates.append(item)
            }
            if enabled.contains(.proud) {
                if let item = record(inputs, day: day, calendar: calendar) { candidates.append(item) }
                if let item = streak(inputs, day: day, now: now, calendar: calendar) { candidates.append(item) }
            }
            if enabled.contains(.meals) { candidates += meals(inputs, day: day, calendar: calendar) }
            if enabled.contains(.recap), let item = recap(inputs, day: day, calendar: calendar) {
                candidates.append(item)
            }
            let room = dailyCap - (offset == 0 ? firedToday : 0)
            guard room > 0 else { continue }
            let picked = candidates
                .filter { $0.fire > now && !isQuiet($0.fire, calendar: calendar) }
                .sorted { ($0.priority, $0.fire) < ($1.priority, $1.fire) }
                .prefix(room)
            result += picked.sorted { $0.fire < $1.fire }
        }
        return result
    }

    // MARK: Training time

    /// The median start of recent sessions (first completed set), in minutes
    /// of the day; 18:00 with fewer than three.
    static func usualStartMinutes(_ sessions: [WorkoutSession], before day: Date, calendar: Calendar) -> Int {
        let from = calendar.date(byAdding: .day, value: -60, to: day) ?? day
        let starts = sessions.filter { $0.day >= from && $0.day < day }.compactMap { session -> Int? in
            guard let first = session.exercises.flatMap(\.completedSets).compactMap(\.completedAt).min() else {
                return nil
            }
            let parts = calendar.dateComponents([.hour, .minute], from: first)
            return (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
        }.sorted()
        guard starts.count >= 3 else { return 18 * 60 }
        return starts[starts.count / 2]
    }

    static func training(_ inputs: NudgeInputs, day: Date, calendar: Calendar) -> PlannedNudge? {
        guard let weekdays = inputs.profile?.weekdays, weekdays.contains(calendar.component(.weekday, from: day))
        else { return nil }
        let session = inputs.sessions.first { calendar.isDate($0.day, inSameDayAs: day) }
        if session?.hasCompletedSets == true { return nil }
        // A quarter of an hour ahead, on a five-minute mark.
        let start = usualStartMinutes(inputs.sessions, before: day, calendar: calendar) - 15
        let minutes = max(0, start / 5 * 5)
        guard let fire = calendar.date(bySettingHour: minutes / 60, minute: minutes % 60, second: 0, of: day) else {
            return nil
        }
        let title: String
        let body: String
        if let group = session?.groups.first {
            let records = RecoveryCalculator(settings: RecoverySettings(experience: inputs.experience))
                .records(from: inputs.sessions, now: fire)
            let recovered = records[group].map { $0.tiredParts.isEmpty } ?? true
            title = String(localized: "\(group.title) day is ready",
                           comment: "Nudge title on a training day; a muscle group, e.g. Chest day is ready")
            body = recovered
                ? String(localized: "Your \(group.title.lowercased()) is recovered 💪 Tap to start.",
                         comment: "Nudge body on a training day; a muscle group in lower case")
                : String(localized: "Your plan is set. Tap to start.", comment: "Nudge body on a training day")
        } else {
            title = String(localized: "Training day", comment: "Nudge title on a training day without a plan yet")
            body = String(localized: "Your workout is one tap away 💪", comment: "Nudge body on a training day without a plan yet")
        }
        return PlannedNudge(kind: .training, fire: fire, title: title, body: body, route: .train, priority: 0)
    }

    // MARK: Behind

    static func behind(_ inputs: NudgeInputs, day: Date, calendar: Calendar) -> PlannedNudge? {
        guard let fire = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: day),
              let weekAgo = calendar.date(byAdding: .day, value: -7, to: day) else { return nil }
        let todaysMeals = inputs.meals.filter { calendar.isDate($0.date, inSameDayAs: day) }

        // Protein first: one clear number beats a list.
        if !todaysMeals.isEmpty, let profile = inputs.profile, let plan = NutritionPlan(profile: profile, now: day) {
            let eaten = todaysMeals.reduce(0) { $0 + $1.proteinG }
            let short = Int(plan.protein) - eaten
            if short >= 20 {
                let food = short <= 22
                    ? String(localized: "a Greek yogurt covers it", comment: "Protein nudge: a food that covers about 20 g")
                    : short <= 40
                        ? String(localized: "a chicken breast covers it", comment: "Protein nudge: a food that covers about 35 g")
                        : String(localized: "a protein shake and a Greek yogurt cover it", comment: "Protein nudge: foods that cover about 45 g")
                return PlannedNudge(kind: .behind, fire: fire,
                                    title: String(localized: "Protein check", comment: "Nudge title: protein short of the plan"),
                                    body: String(localized: "You're \(short) g short on protein — \(food).",
                                                 comment: "Nudge body: grams of protein left, then a food that covers it"),
                                    route: .food, priority: 1)
            }
        }

        var items: [String] = []
        var onlyFood = true
        // Water, for members who log it.
        if inputs.water.contains(where: { $0.date >= weekAgo }) {
            let drunk = inputs.water.filter { calendar.isDate($0.date, inSameDayAs: day) }.reduce(0) { $0 + $1.ml }
            let left = inputs.waterTarget - drunk
            if left > 100 {
                let glasses = max(1, Int((Double(left) / 250).rounded(.up)))
                items.append(glasses == 1
                             ? String(localized: "1 glass of water", comment: "Nudge list item")
                             : String(localized: "\(glasses) glasses of water", comment: "Nudge list item; more than one"))
                onlyFood = false
            }
        }
        // Dinner, for members who log meals.
        if inputs.meals.contains(where: { $0.date >= weekAgo }) {
            let afternoon = calendar.date(bySettingHour: 15, minute: 0, second: 0, of: day) ?? day
            if !todaysMeals.contains(where: { $0.date >= afternoon }) {
                items.append(String(localized: "dinner", comment: "Nudge list item: log dinner"))
            }
        }
        // The planned workout.
        if let weekdays = inputs.profile?.weekdays, weekdays.contains(calendar.component(.weekday, from: day)),
           !(inputs.sessions.first { calendar.isDate($0.day, inSameDayAs: day) }?.hasCompletedSets ?? false) {
            items.append(String(localized: "your workout", comment: "Nudge list item: the day's planned workout"))
            onlyFood = false
        }
        guard !items.isEmpty else { return nil }
        let list = items.joined(separator: " + ")
        let body = items.count == 1
            ? String(localized: "Still 1 thing today: \(list). Tap to finish.", comment: "Evening nudge; one item")
            : String(localized: "Still \(items.count) things today: \(list). Tap to finish.",
                     comment: "Evening nudge; the number of items, then the items joined by +")
        return PlannedNudge(kind: .behind, fire: fire,
                            title: String(localized: "Almost there", comment: "Nudge title: things left today"),
                            body: body, route: onlyFood ? .food : .today, priority: 1)
    }

    // MARK: Proud

    /// The morning after a day with a record set: the heaviest record of it.
    static func record(_ inputs: NudgeInputs, day: Date, calendar: Calendar) -> PlannedNudge? {
        guard let previous = calendar.date(byAdding: .day, value: -1, to: day),
              let session = inputs.sessions.first(where: { calendar.isDate($0.day, inSameDayAs: previous) }),
              session.hasCompletedSets,
              let fire = calendar.date(bySettingHour: 8, minute: 30, second: 0, of: day) else { return nil }
        var best: (name: String, set: WorkoutSet, timed: Bool)?
        for exercise in session.exercises where !exercise.completedSets.isEmpty {
            let ids = PerformanceHistory.recordSetIDs(for: exercise.exerciseName, in: inputs.sessions)
            for set in exercise.completedSets where ids.contains(set.id) {
                let weight = set.weight ?? 0
                if best == nil || weight > (best?.set.weight ?? 0) {
                    best = (exercise.exerciseName, set, exercise.isTimed)
                }
            }
        }
        guard let best else { return nil }
        let figure: String
        if best.timed {
            figure = SetMeasure.clock(best.set.reps)
        } else if let weight = best.set.weight, weight > 0 {
            figure = inputs.unit.format(weight)
        } else {
            figure = String(localized: "\(best.set.reps) reps", comment: "Record nudge: reps without a load")
        }
        return PlannedNudge(kind: .proud, fire: fire,
                            title: String(localized: "New PR! \(best.name) \(figure) 🏆",
                                          comment: "Nudge title: exercise name (English), then the record weight, reps or time"),
                            body: String(localized: "Yesterday's best yet. See what changed →",
                                         comment: "Nudge body after a record set"),
                            route: .progress, priority: 2)
    }

    /// Days with anything logged: a set, a meal, water or a weigh-in.
    static func activeDays(_ inputs: NudgeInputs, calendar: Calendar) -> Set<Date> {
        var days = Set(inputs.sessions.filter(\.hasCompletedSets).map { calendar.startOfDay(for: $0.day) })
        days.formUnion(inputs.meals.map { calendar.startOfDay(for: $0.date) })
        days.formUnion(inputs.water.map { calendar.startOfDay(for: $0.date) })
        days.formUnion(inputs.weights.map { calendar.startOfDay(for: $0.date) })
        return days
    }

    /// The run of active days ending on `day`.
    static func streak(endingOn day: Date, in active: Set<Date>, calendar: Calendar) -> Int {
        var count = 0
        var cursor = calendar.startOfDay(for: day)
        while active.contains(cursor), count < 1_000 {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return count
    }

    /// Evening of a day whose run up to yesterday is a milestone and that
    /// has nothing logged yet: one log keeps it alive.
    static func streak(_ inputs: NudgeInputs, day: Date, now: Date, calendar: Calendar) -> PlannedNudge? {
        let active = activeDays(inputs, calendar: calendar)
        guard !active.contains(calendar.startOfDay(for: day)),
              let previous = calendar.date(byAdding: .day, value: -1, to: day),
              let fire = calendar.date(bySettingHour: 19, minute: 30, second: 0, of: day) else { return nil }
        // Tomorrow's run counts today only if today is logged.
        let run = streak(endingOn: previous, in: active, calendar: calendar)
        guard streakMilestones.contains(run) else { return nil }
        return PlannedNudge(kind: .proud, fire: fire,
                            title: String(localized: "\(run)-day streak 🔥", comment: "Nudge title: days in a row with something logged"),
                            body: String(localized: "Keep it alive tonight: a glass of water, a meal or a set counts.",
                                         comment: "Streak nudge body"),
                            route: .today, priority: 3)
    }

    // MARK: Meals

    static func meals(_ inputs: NudgeInputs, day: Date, calendar: Calendar) -> [PlannedNudge] {
        guard let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: day),
              inputs.meals.contains(where: { $0.date >= twoWeeksAgo }) else { return [] }
        let todays = inputs.meals.filter { calendar.isDate($0.date, inSameDayAs: day) }
        var result: [PlannedNudge] = []
        if todays.isEmpty, let fire = calendar.date(bySettingHour: 12, minute: 15, second: 0, of: day) {
            result.append(PlannedNudge(kind: .meals, fire: fire,
                                       title: String(localized: "Lunch?", comment: "Nudge title at lunch time"),
                                       body: String(localized: "Log it in one tap.", comment: "Meal-time nudge body"),
                                       route: .food, priority: 4))
        }
        if let afternoon = calendar.date(bySettingHour: 15, minute: 0, second: 0, of: day),
           !todays.contains(where: { $0.date >= afternoon }),
           let fire = calendar.date(bySettingHour: 19, minute: 15, second: 0, of: day) {
            result.append(PlannedNudge(kind: .meals, fire: fire,
                                       title: String(localized: "Dinner?", comment: "Nudge title at dinner time"),
                                       body: String(localized: "Log it in one tap.", comment: "Meal-time nudge body"),
                                       route: .food, priority: 5))
        }
        return result
    }

    // MARK: Curious

    /// Sunday afternoon: the Monday-to-Sunday week so far.
    static func recap(_ inputs: NudgeInputs, day: Date, calendar: Calendar) -> PlannedNudge? {
        guard calendar.component(.weekday, from: day) == 1,
              let monday = calendar.date(byAdding: .day, value: -6, to: day),
              let end = calendar.date(byAdding: .day, value: 1, to: day),
              let fire = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: day) else { return nil }
        let week = inputs.sessions.filter { $0.day >= monday && $0.day < end && $0.hasCompletedSets }
        guard !week.isEmpty else { return nil }
        let kg = week.reduce(0) { $0 + $1.volume }
        let volume: String
        switch inputs.unit {
        case .kg: volume = String(localized: "\((kg / 1_000).formatted(.number.precision(.fractionLength(1))))\u{00A0}t",
                                  comment: "Training volume in tonnes, e.g. 12.3 t")
        case .lb: volume = inputs.unit.total(kg)
        }
        let body = week.count == 1
            ? String(localized: "Your week: 1 workout, \(volume) volume. See what changed →",
                     comment: "Sunday recap nudge; the week's volume")
            : String(localized: "Your week: \(week.count) workouts, \(volume) volume. See what changed →",
                     comment: "Sunday recap nudge; workouts, then the week's volume")
        return PlannedNudge(kind: .recap, fire: fire,
                            title: String(localized: "Your week in MUSQ", comment: "Sunday recap nudge title"),
                            body: body, route: .progress, priority: 6)
    }
}

// MARK: - Scheduler

/// Lays the nudges. The root view attaches its live stores; until then (or
/// without them) the saved files are read.
final class NudgeScheduler {
    static let shared = NudgeScheduler()
    static let idPrefix = "nudge."

    private weak var store: WorkoutStore?
    private weak var daily: DailyStore?
    /// Each re-plan waits for the one before, so removals and additions
    /// never interleave.
    private var task: Task<Void, Never>?

    private static let lastPlanKey = "nudge.lastPlan"
    private static let firedDayKey = "nudge.fired.day"
    private static let firedCountKey = "nudge.fired.count"

    func attach(store: WorkoutStore, daily: DailyStore) {
        self.store = store
        self.daily = daily
    }

    /// Re-plans after the previous run, kept alive a moment in the background.
    func replanSoon() {
        let previous = task
        let background = UIApplication.shared.beginBackgroundTask(withName: "Nudges")
        task = Task {
            await previous?.value
            await replan()
            if background != .invalid { UIApplication.shared.endBackgroundTask(background) }
        }
    }

    /// Notifications are allowed for MUSQ.
    static func isAllowed() async -> Bool {
        let status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        return [.authorized, .provisional, .ephemeral].contains(status)
    }

    private func replan(now: Date = Date(), calendar: Calendar = .current) async {
        let center = UNUserNotificationCenter.current()
        let firedToday = recordFired(now: now, calendar: calendar)
        let pending = await center.pendingNotificationRequests()
        center.removePendingNotificationRequests(withIdentifiers: pending.map(\.identifier)
            .filter { $0.hasPrefix(Self.idPrefix) })
        UserDefaults.standard.removeObject(forKey: Self.lastPlanKey)

        // Never asks: the settings screen offers notifications.
        guard NudgeKind.optedIn, await Self.isAllowed() else { return }
        let inputs: NudgeInputs?
        if let store, let daily { inputs = NudgeInputs(store: store, daily: daily) } else { inputs = NudgeInputs.fromDisk() }
        guard let inputs else { return }
        let enabled = Set(NudgeKind.allCases.filter(\.isOn))
        let plan = NudgePlanner.plan(inputs, enabled: enabled, firedToday: firedToday, now: now, calendar: calendar)

        var stored: [[String: Any]] = []
        for item in plan {
            let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: item.fire)
            let time = String(format: "%02d%02d", parts.hour ?? 0, parts.minute ?? 0)
            let id = "\(Self.idPrefix)\(item.kind.rawValue).\(DayKey.make(item.fire, calendar: calendar))-\(time)"
            let content = UNMutableNotificationContent()
            content.title = item.title
            content.body = item.body
            content.sound = .default
            content.threadIdentifier = "nudge"
            content.userInfo = ["route": item.route.rawValue, "kind": item.kind.rawValue]
            let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
            try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
            stored.append(["kind": item.kind.rawValue, "fire": item.fire.timeIntervalSince1970])
        }
        UserDefaults.standard.set(stored, forKey: Self.lastPlanKey)
    }

    /// Counts the last plan's nudges whose time has passed as sent (per type,
    /// and toward today's cap) and returns how many went out today.
    private func recordFired(now: Date, calendar: Calendar) -> Int {
        let defaults = UserDefaults.standard
        let todayKey = DayKey.make(now, calendar: calendar)
        var count = defaults.string(forKey: Self.firedDayKey) == todayKey ? defaults.integer(forKey: Self.firedCountKey) : 0
        let last = defaults.array(forKey: Self.lastPlanKey) as? [[String: Any]] ?? []
        for entry in last {
            guard let raw = entry["kind"] as? String, let kind = NudgeKind(rawValue: raw),
                  let stamp = entry["fire"] as? Double else { continue }
            let fire = Date(timeIntervalSince1970: stamp)
            guard fire <= now else { continue }
            defaults.set(defaults.integer(forKey: kind.sentKey) + 1, forKey: kind.sentKey)
            if calendar.isDate(fire, inSameDayAs: now) { count += 1 }
        }
        defaults.set(todayKey, forKey: Self.firedDayKey)
        defaults.set(count, forKey: Self.firedCountKey)
        return count
    }
}
