//
//  AppleHealth.swift
//  GymWorkout
//
//  Phase 2 of the all-in-one plan (2026-11-22, owner-approved list): steps,
//  walking distance, active energy, sleep and Watch workouts, read from Apple
//  Health. Read-only. Nothing is written to disk here: every number is
//  queried again when the app opens or the day changes, so no health data
//  sits in a file that iCloud Backup could copy (App Review 5.1.3). None of
//  it goes to the ads SDK, and none to the AI coach unless the user turns on
//  "Include my sleep" for a Balance question (sent as text they read first).
//
//  - Steps and distance: HealthKit's statistics queries, which merge an
//    iPhone and a Watch counting the same walk.
//  - Sleep: "asleep" samples only (not in bed, not awake), from one source
//    a night; a night is the one you wake from, and anything that starts
//    before 6 pm counts toward that day. Its start and end (so the midpoint
//    and the wake time) are the main sleep's: asleep stretches joined
//    across gaps of an hour or less, the one with the most sleep — a nap
//    adds to the total but doesn't move them.
//  - The plan: the average steps of the last 14 complete days (days under
//    1,000 steps in Health's own count, a phone left at home, don't count;
//    at least 7 days needed) stand in for the onboarding's daily-activity
//    answer — see `MeasuredActivity`. Steps added by hand count only on
//    days Health already counts, so a walk logged on a phone-at-home day
//    doesn't turn that unmeasured day into a low one.
//

import Foundation
import HealthKit
import Observation

@MainActor
@Observable
final class AppleHealth {

    enum Access: Equatable {
        /// No Health on this device (some iPads, Mac).
        case unavailable
        case notAsked
        /// The sheet was shown. HealthKit never says whether reading was
        /// allowed: a "no" looks like no data.
        case asked
    }

    struct Day: Identifiable, Hashable {
        /// Start of the calendar day.
        let day: Date
        let value: Double
        var id: Date { day }
    }

    struct SleepNight: Identifiable, Hashable {
        /// Start of the day you woke up.
        let day: Date
        /// All of the night's asleep time, naps that day included.
        let asleepMinutes: Int
        /// Watch stages, minutes each; empty when the source has none.
        let coreMinutes: Int
        let deepMinutes: Int
        let remMinutes: Int
        /// The main sleep's first and last asleep moments (see
        /// `mainSleep`), not a nap's.
        let start: Date
        let end: Date
        var id: Date { day }
        var hasStages: Bool { coreMinutes + deepMinutes + remMinutes > 0 }
    }

    // MARK: State

    /// A Watch (or other app's) workout matched to a MUSQ session: its
    /// active energy and its own length, shown together.
    struct SessionEnergy: Hashable {
        let kcal: Double
        let minutes: Int
    }

    private(set) var access: Access = .notAsked
    /// The last 30 days with any steps, today included, oldest first.
    private(set) var dailySteps: [Day] = []
    /// The last 12 weeks of nights with sleep, up to last night, oldest
    /// first (Balance's 12-week history; Today and Progress use the recent ones).
    private(set) var nights: [SleepNight] = []
    private(set) var lastRefresh: Date?
    /// The day the numbers were read for; today's figures show only while
    /// it is still that day, so last night's totals never pass for today's.
    private(set) var loadedDay: Date?
    /// Matched workouts, by the MUSQ session's window.
    private(set) var sessionEnergy: [DateInterval: SessionEnergy] = [:]
    /// Steps taken inside logged MUSQ sessions, by day: left out of the
    /// plan's average, since the training days already count the workouts.
    private(set) var gymSteps: [Date: Double] = [:]
    /// The plan input worked out at the last read (in memory only).
    private var measured: MeasuredActivity?
    private var todaySteps: Double?
    private var todayKm: Double?
    private var todayKcal: Double?

    var stepsToday: Int? { isCurrent ? todaySteps.map { Int($0.rounded()) } : nil }
    var distanceTodayKm: Double? { isCurrent ? todayKm : nil }
    var activeKcalToday: Double? { isCurrent ? todayKcal : nil }

    /// MUSQ's logged sessions as time windows (first set − 2 min to the last
    /// set), set by the root view, so their steps can be left out of the plan.
    @ObservationIgnored var sessionWindows: () -> [DateInterval] = { [] }
    /// Steps the user added by hand (a walk without the phone), by day, set
    /// by the root view from `DailyStore`. They count with Health's steps in
    /// totals and trends; in the plan only on days Health already counts.
    @ObservationIgnored var manualSteps: () -> [Date: Double] = { [:] }

    var stepsGoal: Int {
        didSet { defaults.set(stepsGoal, forKey: Keys.stepsGoal) }
    }
    var sleepGoalMinutes: Int {
        didSet { defaults.set(sleepGoalMinutes, forKey: Keys.sleepGoal) }
    }
    /// The user's switch for letting steps set the plan's daily activity.
    var usesStepsForPlan: Bool {
        didSet {
            defaults.set(usesStepsForPlan, forKey: Keys.usesSteps)
            // Nothing Health-derived is kept while steps don't set the plan.
            updateMeasured()
        }
    }
    /// The step band in use, kept so the plan moves only once the average is
    /// clearly past a threshold (`MeasuredActivity.hysteresis`) and so a cold
    /// launch starts from it rather than from the answer. Saved only while
    /// steps set the plan; cleared otherwise.
    private var stepsBand: DailyActivity? {
        didSet {
            if let stepsBand { defaults.set(stepsBand.rawValue, forKey: Keys.band) }
            else { defaults.removeObject(forKey: Keys.band) }
        }
    }

    static let stepsGoalRange = 2_000...30_000
    static let sleepGoalRange = 300...660

    @ObservationIgnored private let store = HKHealthStore()
    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private var refreshTask: Task<Void, Never>?
    private var calendar: Calendar { .current }

    private enum Keys {
        static let stepsGoal = "health.stepsGoal"
        static let sleepGoal = "health.sleepGoalMinutes"
        static let usesSteps = "health.usesStepsForPlan"
        static let band = "health.stepsBand"
        static let asked = "health.asked"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let goal = defaults.integer(forKey: Keys.stepsGoal)
        stepsGoal = goal > 0 ? goal : 8_000
        let sleep = defaults.integer(forKey: Keys.sleepGoal)
        sleepGoalMinutes = sleep > 0 ? sleep : 480
        usesStepsForPlan = defaults.object(forKey: Keys.usesSteps) as? Bool ?? true
        stepsBand = defaults.string(forKey: Keys.band).flatMap(DailyActivity.init(rawValue:))
        if !HKHealthStore.isHealthDataAvailable() {
            access = .unavailable
        } else if defaults.bool(forKey: Keys.asked) {
            access = .asked
        }
    }

    // MARK: Types

    static let readTypes: Set<HKObjectType> = [
        HKQuantityType(.stepCount),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.activeEnergyBurned),
        HKCategoryType(.sleepAnalysis),
        HKObjectType.workoutType(),
    ]

    // MARK: Connecting

    /// Shows Apple's Health sheet (once; later calls return at once), then
    /// reads.
    func connect() async {
        guard access != .unavailable else { return }
        do {
            try await store.requestAuthorization(toShare: [], read: Self.readTypes)
            defaults.set(true, forKey: Keys.asked)
            access = .asked
        } catch {
            // The sheet couldn't show (no entitlement, no Health): leave the
            // row as it was.
            return
        }
        await refresh()
    }

    /// Whether the sheet was already shown on this device — a reinstall or
    /// a reset in Settings makes it ask again.
    func syncAccess() async {
        guard access != .unavailable else { return }
        guard let status = try? await store.statusForAuthorizationRequest(toShare: [], read: Self.readTypes) else { return }
        let asked = status == .unnecessary
        defaults.set(asked, forKey: Keys.asked)
        access = asked ? .asked : .notAsked
        if !asked { forget() }
    }

    /// Drops every reading and the saved band (Health reset or reinstalled).
    private func forget() {
        dailySteps = []
        nights = []
        todaySteps = nil
        todayKm = nil
        todayKcal = nil
        gymSteps = [:]
        sessionEnergy = [:]
        measured = nil
        loadedDay = nil
        lastRefresh = nil
        stepsBand = nil
    }

    // MARK: Reading

    /// Reads everything again; one refresh at a time. A read still running
    /// from before midnight is followed by a fresh one.
    func refresh() async {
        guard access == .asked else { return }
        if let running = refreshTask {
            await running.value
            if isCurrent { return }
            if let again = refreshTask { await again.value; return }
        }
        let task = Task { await load() }
        refreshTask = task
        await task.value
        refreshTask = nil
    }

    private var isCurrent: Bool { loadedDay == calendar.startOfDay(for: Date()) }

    private func load() async {
        let today = calendar.startOfDay(for: Date())
        guard let from = calendar.date(byAdding: .day, value: -29, to: today),
              let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else { return }
        async let steps = dailySums(.stepCount, unit: .count(), from: from, to: tomorrow)
        async let distance = dailySums(.distanceWalkingRunning, unit: .meterUnit(with: .kilo), from: today, to: tomorrow)
        async let energy = dailySums(.activeEnergyBurned, unit: .kilocalorie(), from: today, to: tomorrow)
        async let sleep = sleepNights(from: calendar.date(byAdding: .day, value: -83, to: today) ?? from, to: tomorrow)
        async let gym = stepsInSessions(since: calendar.date(byAdding: .day, value: -(MeasuredActivity.windowDays + 1), to: today) ?? from)
        let (stepDays, distanceDays, energyDays, sleepNights, gymDays) = await (steps, distance, energy, sleep, gym)

        dailySteps = stepDays.filter { $0.value > 0 }
        todaySteps = stepDays.first { $0.day == today }?.value
        todayKm = distanceDays.first { $0.day == today }?.value
        todayKcal = energyDays.first { $0.day == today }?.value
        // Sleep that starts this evening belongs to tomorrow's night.
        nights = sleepNights.filter { $0.day <= today }
        gymSteps = gymDays
        loadedDay = today
        lastRefresh = Date()
        updateMeasured()
    }

    /// Steps inside each logged MUSQ session since `start`, summed by day.
    private func stepsInSessions(since start: Date) async -> [Date: Double] {
        var byDay: [Date: Double] = [:]
        for window in sessionWindows() where window.start >= start
            && window.duration > 0 && window.duration < 4 * 3600 {
            let predicate = HKQuery.predicateForSamples(withStart: window.start, end: window.end)
            let descriptor = HKStatisticsQueryDescriptor(
                predicate: .quantitySample(type: HKQuantityType(.stepCount), predicate: predicate),
                options: .cumulativeSum)
            guard let steps = try? await descriptor.result(for: store)?.sumQuantity()?.doubleValue(for: .count()),
                  steps > 0 else { continue }
            byDay[calendar.startOfDay(for: window.start), default: 0] += steps
        }
        return byDay
    }

    /// One sum per calendar day, through HealthKit's statistics so overlapping
    /// sources count once.
    private func dailySums(_ id: HKQuantityTypeIdentifier, unit: HKUnit, from: Date, to: Date) async -> [Day] {
        let type = HKQuantityType(id)
        let predicate = HKQuery.predicateForSamples(withStart: from, end: to)
        let descriptor = HKStatisticsCollectionQueryDescriptor(
            predicate: .quantitySample(type: type, predicate: predicate),
            options: .cumulativeSum,
            anchorDate: from,
            intervalComponents: DateComponents(day: 1))
        guard let collection = try? await descriptor.result(for: store) else { return [] }
        var days: [Day] = []
        collection.enumerateStatistics(from: from, to: to) { statistics, _ in
            if let sum = statistics.sumQuantity() {
                days.append(Day(day: statistics.startDate, value: sum.doubleValue(for: unit)))
            }
        }
        return days
    }

    private func sleepNights(from: Date, to: Date) async -> [SleepNight] {
        // A night that ends on `from` started the evening before.
        let start = from.addingTimeInterval(-12 * 3600)
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.categorySample(type: HKCategoryType(.sleepAnalysis),
                                         predicate: HKQuery.predicateForSamples(withStart: start, end: to))],
            sortDescriptors: [SortDescriptor(\.startDate)])
        guard let samples = try? await descriptor.result(for: store) else { return [] }
        return Self.nights(from: samples.map {
            SleepSample(value: $0.value, start: $0.startDate, end: $0.endDate,
                        source: $0.sourceRevision.source.bundleIdentifier,
                        isWatch: $0.sourceRevision.productType?.hasPrefix("Watch") ?? false)
        }, calendar: calendar, from: from)
    }

    struct SleepSample {
        let value: Int
        let start: Date
        let end: Date
        let source: String
        let isWatch: Bool
    }

    /// Asleep time per night from ONE source, as Health itself does when two
    /// apps record the same night (a Watch and a ring, say): the one with
    /// stages — a Watch first — else the one with the most asleep time.
    /// Mixing them would fill each other's awake gaps and double the stages.
    static func nights(from samples: [SleepSample], calendar: Calendar, from: Date) -> [SleepNight] {
        let asleep = Set(HKCategoryValueSleepAnalysis.allAsleepValues.map(\.rawValue))
        let stageValues: Set<Int> = [HKCategoryValueSleepAnalysis.asleepCore.rawValue,
                                     HKCategoryValueSleepAnalysis.asleepDeep.rawValue,
                                     HKCategoryValueSleepAnalysis.asleepREM.rawValue]
        var byNight: [Date: [SleepSample]] = [:]
        for sample in samples where asleep.contains(sample.value) && sample.end > sample.start {
            // 6 pm on is the coming night; earlier counts toward that day.
            let key = calendar.startOfDay(for: sample.start.addingTimeInterval(6 * 3600))
            guard key >= from else { continue }
            byNight[key, default: []].append(sample)
        }
        func minutes(_ items: [SleepSample]) -> Int {
            Int((union(items.map { ($0.start, $0.end) }) / 60).rounded())
        }
        var result: [SleepNight] = []
        for day in byNight.keys.sorted() {
            let bySource = Dictionary(grouping: byNight[day] ?? [], by: \.source)
            let ranked = bySource.values.map { items -> (items: [SleepSample], staged: Bool, watch: Bool, total: Int) in
                (items, items.contains { stageValues.contains($0.value) }, items.contains(where: \.isWatch), minutes(items))
            }.sorted { ($0.staged ? 1 : 0, $0.watch ? 1 : 0, $0.total) > ($1.staged ? 1 : 0, $1.watch ? 1 : 0, $1.total) }
            guard let pick = ranked.first else { continue }
            let items = pick.items
            let total = pick.total
            guard total > 0 else { continue }
            let core = minutes(items.filter { $0.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue })
            let deep = minutes(items.filter { $0.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue })
            let rem = minutes(items.filter { $0.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue })
            let main = mainSleep(items.map { ($0.start, $0.end) })
            result.append(SleepNight(day: day, asleepMinutes: total, coreMinutes: core, deepMinutes: deep,
                                     remMinutes: rem, start: main?.start ?? items.map(\.start).min() ?? day,
                                     end: main?.end ?? items.map(\.end).max() ?? day))
        }
        return result
    }

    /// The night's main sleep: the asleep intervals (overlaps merged) joined
    /// into stretches across gaps of an hour or less — the awake spells a
    /// Watch leaves out of "asleep" — and the stretch with the most asleep
    /// time. A nap or an evening doze elsewhere in the day stays apart.
    static func mainSleep(_ intervals: [(Date, Date)]) -> (start: Date, end: Date)? {
        var merged: [(start: Date, end: Date)] = []
        for interval in intervals.sorted(by: { $0.0 < $1.0 }) where interval.1 > interval.0 {
            if let last = merged.last, interval.0 <= last.end {
                merged[merged.count - 1].end = max(last.end, interval.1)
            } else {
                merged.append((start: interval.0, end: interval.1))
            }
        }
        var stretches: [(start: Date, end: Date, asleep: TimeInterval)] = []
        for interval in merged {
            let asleep = interval.end.timeIntervalSince(interval.start)
            if let last = stretches.last, interval.start.timeIntervalSince(last.end) <= 3600 {
                stretches[stretches.count - 1].end = interval.end
                stretches[stretches.count - 1].asleep += asleep
            } else {
                stretches.append((start: interval.start, end: interval.end, asleep: asleep))
            }
        }
        guard let main = stretches.max(by: { $0.asleep < $1.asleep }) else { return nil }
        return (main.start, main.end)
    }

    /// Seconds covered by the intervals, overlaps counted once.
    static func union(_ intervals: [(Date, Date)]) -> TimeInterval {
        var total: TimeInterval = 0
        var current: (Date, Date)?
        for interval in intervals.sorted(by: { $0.0 < $1.0 }) {
            if let open = current, interval.0 <= open.1 {
                current = (open.0, max(open.1, interval.1))
            } else {
                if let open = current { total += open.1.timeIntervalSince(open.0) }
                current = interval
            }
        }
        if let open = current { total += open.1.timeIntervalSince(open.0) }
        return total
    }

    // MARK: Workouts

    /// Looks for a workout (a Watch's, usually) that matches a MUSQ session —
    /// each covering at least half of the other, so a forgotten three-hour
    /// workout doesn't stand in for a 45-minute session — and keeps its
    /// active energy and length. Checked again on every read, so a deleted
    /// workout or access turned off drops it; a failed query keeps the last.
    func loadSessionEnergy(for window: DateInterval) async {
        guard access == .asked, window.duration > 0 else { return }
        let predicate = HKQuery.predicateForSamples(withStart: window.start.addingTimeInterval(-3 * 3600),
                                                    end: window.end.addingTimeInterval(3 * 3600))
        let descriptor = HKSampleQueryDescriptor(predicates: [.workout(predicate)], sortDescriptors: [])
        guard let workouts = try? await descriptor.result(for: store) else { return }
        let energy = HKQuantityType(.activeEnergyBurned)
        let best = workouts.compactMap { workout -> (overlap: Double, value: SessionEnergy)? in
            let span = DateInterval(start: workout.startDate, end: max(workout.startDate, workout.endDate))
            let overlap = span.intersection(with: window)?.duration ?? 0
            guard overlap >= window.duration / 2, overlap >= span.duration / 2,
                  let kcal = workout.statistics(for: energy)?.sumQuantity()?.doubleValue(for: .kilocalorie()),
                  kcal > 0 else { return nil }
            return (overlap, SessionEnergy(kcal: kcal, minutes: max(1, Int((span.duration / 60).rounded()))))
        }.max { $0.overlap < $1.overlap }
        sessionEnergy[window] = best?.value
    }

    /// The matched workout's active energy for a MUSQ session.
    func sessionKcal(for window: DateInterval) -> Double? { sessionEnergy[window]?.kcal }

    /// The matched workout's own length, to show with its energy.
    func sessionMinutes(for window: DateInterval) -> Int? { sessionEnergy[window]?.minutes }

    // MARK: Derived

    /// The night you woke from today, if any.
    var lastNight: SleepNight? {
        guard isCurrent else { return nil }
        let today = calendar.startOfDay(for: Date())
        return nights.last { $0.day == today }
    }

    /// Health's steps plus the ones added by hand, by day, last 30 days.
    var allDailySteps: [Day] {
        let extra = manualSteps()
        guard !extra.isEmpty else { return dailySteps }
        let today = calendar.startOfDay(for: Date())
        let start = calendar.date(byAdding: .day, value: -29, to: today) ?? today
        var byDay = Dictionary(uniqueKeysWithValues: dailySteps.map { ($0.day, $0.value) })
        for (day, steps) in extra where day >= start && day <= today { byDay[day, default: 0] += steps }
        return byDay.keys.sorted().map { Day(day: $0, value: byDay[$0] ?? 0) }
    }

    /// Today's steps with the ones added by hand; nil when there are none.
    var stepsTodayTotal: Int? {
        let added = Int(manualSteps()[calendar.startOfDay(for: Date())] ?? 0)
        guard let counted = stepsToday else { return added > 0 ? added : nil }
        return counted + added
    }

    /// Steps added by hand today.
    var manualStepsToday: Int { Int(manualSteps()[calendar.startOfDay(for: Date())] ?? 0) }

    /// Hand-added steps changed: the plan's average follows at once.
    func manualStepsChanged() { updateMeasured() }

    /// Complete days only (today is still running).
    private var completeSteps: [Day] {
        let today = calendar.startOfDay(for: Date())
        return allDailySteps.filter { $0.day < today }
    }

    /// The plan's days: Health's own complete days that pass the
    /// phone-left-at-home check, with the steps added by hand on them. A day
    /// Health skipped stays skipped, whatever was added by hand.
    private var planSteps: [Day] {
        let today = calendar.startOfDay(for: Date())
        let extra = manualSteps()
        return dailySteps.filter { $0.day < today && $0.value >= MeasuredActivity.minimumSteps }
            .map { Day(day: $0.day, value: $0.value + (extra[$0.day] ?? 0)) }
    }

    /// What the plan uses in place of the onboarding's daily-activity answer,
    /// or nil (switch off, not connected, or too few days). Before today's
    /// first read it carries the band in use (`days` 0), so the calories
    /// don't open on the answer and jump a moment later.
    var measuredActivity: MeasuredActivity? {
        guard usesStepsForPlan, access == .asked else { return nil }
        if isCurrent { return measured }
        return stepsBand.map { MeasuredActivity(activity: $0, averageSteps: 0, days: 0) }
    }

    private func updateMeasured() {
        guard usesStepsForPlan, access == .asked else {
            measured = nil
            stepsBand = nil
            return
        }
        guard loadedDay != nil else { return }
        measured = MeasuredActivity(days: planSteps, excluding: gymSteps, previous: stepsBand)
        stepsBand = measured?.activity
    }

    /// Steps a day over complete days in the last `days`.
    func averageSteps(days: Int) -> Int? {
        let today = calendar.startOfDay(for: Date())
        guard let start = calendar.date(byAdding: .day, value: -days, to: today) else { return nil }
        let values = completeSteps.filter { $0.day >= start }.map(\.value)
        return values.isEmpty ? nil : Int((values.reduce(0, +) / Double(values.count)).rounded())
    }

    /// Asleep minutes a night over the last `days` nights with data.
    func averageSleep(days: Int) -> Int? {
        let today = calendar.startOfDay(for: Date())
        guard let start = calendar.date(byAdding: .day, value: -(days - 1), to: today) else { return nil }
        let values = nights.filter { $0.day >= start && $0.day <= today }.map(\.asleepMinutes)
        return values.isEmpty ? nil : values.reduce(0, +) / values.count
    }
}

// MARK: - Plan input

/// Daily activity measured from steps, for `NutritionPlan` (owner-approved
/// 2026-11-22: steps stand in for the onboarding answer; the training days
/// and every other formula stay).
///
/// Bands follow Tudor-Locke & Bassett, "How many steps/day are enough?"
/// (Sports Med 2004): under 7,500 a day is sedentary to low active — the
/// "mostly sitting" answer; 7,500-12,499 "somewhat active" to "active" — on
/// your feet; 12,500 and up "highly active" — physical work. Days under
/// 1,000 steps (the phone left behind) are skipped; it takes 7 of the last
/// 14 complete days. Steps taken inside logged MUSQ sessions are taken off
/// each day first: the answer it replaces is about the day outside
/// workouts, and the training days already count those. Once a band is in
/// use the average has to pass the next threshold by 500 steps either way,
/// so one long walk doesn't swing the calories by a level (about 0.175 × BMR).
/// `days` 0 means the band carried over until today's first read.
struct MeasuredActivity: Hashable {
    let activity: DailyActivity
    let averageSteps: Int
    let days: Int

    static let windowDays = 14
    static let minimumDays = 7
    static let minimumSteps = 1_000.0
    static let onFeetFrom = 7_500.0
    static let physicalFrom = 12_500.0
    static let hysteresis = 500.0

    /// `excluding`: steps inside logged workouts, by day.
    init?(days: [AppleHealth.Day], excluding: [Date: Double] = [:], previous: DailyActivity?,
          calendar: Calendar = .current, now: Date = Date()) {
        let today = calendar.startOfDay(for: now)
        guard let start = calendar.date(byAdding: .day, value: -Self.windowDays, to: today) else { return nil }
        // The phone-left-at-home check uses the whole day's count.
        let counted = days.filter { $0.day >= start && $0.day < today && $0.value >= Self.minimumSteps }
        guard counted.count >= Self.minimumDays else { return nil }
        let outside = counted.map { max(0, $0.value - (excluding[$0.day] ?? 0)) }
        let average = outside.reduce(0, +) / Double(counted.count)
        self.averageSteps = Int(average.rounded())
        self.days = counted.count
        self.activity = Self.band(average, previous: previous)
    }

    init(activity: DailyActivity, averageSteps: Int, days: Int) {
        self.activity = activity
        self.averageSteps = averageSteps
        self.days = days
    }

    static func band(_ average: Double, previous: DailyActivity?) -> DailyActivity {
        func plain(_ steps: Double) -> DailyActivity {
            steps >= physicalFrom ? .physical : steps >= onFeetFrom ? .onFeet : .sitting
        }
        guard let previous else { return plain(average) }
        // Stay unless the average is clearly into another band.
        let up = plain(average - hysteresis)
        let down = plain(average + hysteresis)
        let rank: (DailyActivity) -> Int = { $0.extraLevels }
        if rank(up) > rank(previous) { return up }
        if rank(down) < rank(previous) { return down }
        return previous
    }
}
