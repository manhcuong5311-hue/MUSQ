//
//  DailyStore.swift
//  GymWorkout
//
//  The Today tab's log (2026-11-21): water, weigh-ins and their reminders,
//  saved to their own JSON file in Application Support so the workout
//  history is never touched. Also the targets and estimates the tab shows:
//  the day's water, the weight trend, and a workout's energy.
//
//  - Water: about 2.0 L a day for women, 2.5 L for men (EFSA's adequate
//    total water intakes, 2010, food included), 2.25 L otherwise; +300 ml in
//    pregnancy, +700 ml while breastfeeding (EFSA). Training and heat raise
//    the need, so MUSQ sets that much as the drinks target; the user can set
//    their own. With a heart or kidney condition the card says to ask a
//    doctor, since some of them limit fluids.
//  - Weight: the plan follows the 7-day average of the weigh-ins, not the
//    last one, so a salty dinner doesn't move the calories. One weigh-in a
//    day: logging again replaces it, and any can be deleted.
//  - Reminders: water every few hours inside the user's window, for today
//    and tomorrow, refreshed whenever the app opens and dropped for the rest
//    of the day once the target is reached; a daily weigh-in. Balance's
//    eating check-in the same way, today and tomorrow, while eating is
//    scored, and none today once it is checked in or a meal is logged.
//  - Check-ins, sleep estimates and paused weeks belong to calendar days,
//    so they are kept by day key ("2026-11-22"), not by instant: a
//    time-zone change doesn't move them a day.
//

import Foundation
import Observation
import UserNotifications

@Observable
final class DailyStore {

    private(set) var water: [WaterEntry] = []
    private(set) var weights: [WeightEntry] = []
    /// Logged meals, oldest first (see `MealEntry`).
    private(set) var meals: [MealEntry] = []
    /// Balance's evening eating check-ins, one a day.
    private(set) var checkIns: [EatCheckIn] = []
    /// "Slept about…" estimates, one a day.
    private(set) var sleepEstimates: [SleepEstimate] = []
    /// Walks the user added themselves.
    private(set) var stepEntries: [StepsEntry] = []
    /// Weeks left out of Balance (sick, travel, deload), by the day key of
    /// the week's first day.
    private(set) var pausedWeeks: Set<String> = []
    /// The water buttons, in ml (two by default; the user can change them).
    var waterPresets: [Int] = DailyStore.defaultWaterPresets {
        didSet { if waterPresets != oldValue && !isLoading { save() } }
    }
    var checkInReminder = CheckInReminder() {
        didSet { if checkInReminder != oldValue && !isLoading { save(); refreshRemindersSoon() } }
    }
    var bedtimeReminder = BedtimeReminder() {
        didSet { if bedtimeReminder != oldValue && !isLoading { save(); refreshRemindersSoon() } }
    }

    static let defaultWaterPresets = [250, 500]
    /// What a custom water amount can be, in ml.
    static let waterAmountRange = 50...1_500
    /// The user's own target in millilitres; nil follows the profile.
    var waterTargetOverride: Int? {
        didSet { if waterTargetOverride != oldValue && !isLoading { save(); refreshRemindersSoon() } }
    }
    var waterReminder = WaterReminder() {
        didSet { if waterReminder != oldValue && !isLoading { save(); refreshRemindersSoon() } }
    }
    var weighInReminder = WeighInReminder() {
        didSet { if weighInReminder != oldValue && !isLoading { save(); refreshRemindersSoon() } }
    }
    /// Notifications are off for MUSQ in Settings: the reminder rows say so.
    private(set) var notificationsDenied = false

    /// The day's water target as the profile sets it, kept current by the
    /// root view so reminders know when the day is done.
    var profileWaterTarget = 2_250 {
        didSet { if profileWaterTarget != oldValue { refreshRemindersSoon() } }
    }

    @ObservationIgnored private var isLoading = false
    @ObservationIgnored private let fileURL: URL
    /// The current calendar each time, so a time-zone change moves "today".
    private var calendar: Calendar { .current }
    /// The last reminder refresh; each new one waits for it, so two never
    /// interleave their removals and additions.
    @ObservationIgnored private var refreshTask: Task<Void, Never>?

    init(fileURL: URL = DailyStore.defaultFileURL) {
        self.fileURL = fileURL
        load()
    }

    // MARK: - Water

    /// About 2.0 L for women, 2.5 L for men, 2.25 L otherwise; more in
    /// pregnancy and while breastfeeding (EFSA 2010).
    static func waterTarget(for profile: UserProfile?) -> Int {
        var ml: Int
        switch profile?.sex {
        case .female: ml = 2_000
        case .male: ml = 2_500
        default: ml = 2_250
        }
        if let health = profile?.health {
            if health.isPregnant { ml += 300 } else if health.isBreastfeeding { ml += 700 }
        }
        return ml
    }

    var waterTarget: Int { waterTargetOverride ?? profileWaterTarget }

    func waterDrunk(on day: Date) -> Int {
        water.filter { calendar.isDate($0.date, inSameDayAs: day) }.reduce(0) { $0 + $1.ml }
    }

    func entries(on day: Date) -> [WaterEntry] {
        water.filter { calendar.isDate($0.date, inSameDayAs: day) }.sorted { $0.date < $1.date }
    }

    func addWater(_ ml: Int, at date: Date = Date()) {
        guard ml > 0 else { return }
        water.append(WaterEntry(date: date, ml: ml))
        save()
        refreshRemindersSoon()
    }

    func deleteWater(id: UUID) {
        water.removeAll { $0.id == id }
        save()
        refreshRemindersSoon()
    }

    /// Takes back the day's last glass.
    func undoWater(on day: Date = Date()) {
        guard let last = entries(on: day).last else { return }
        water.removeAll { $0.id == last.id }
        save()
        refreshRemindersSoon()
    }

    /// The average a day over the days with water logged among the last
    /// `days`, today included: a day nothing was logged isn't a day of zero.
    func averageWater(days: Int, endingOn day: Date = Date()) -> Int {
        let start = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -(days - 1), to: day) ?? day)
        let window = water.filter { $0.date >= start && $0.date <= day }
        let loggedDays = Set(window.map { calendar.startOfDay(for: $0.date) }).count
        guard loggedDays > 0 else { return 0 }
        return window.reduce(0) { $0 + $1.ml } / loggedDays
    }

    // MARK: - Weight

    /// One weigh-in a day: logging again replaces that day's.
    func logWeight(_ kg: Double, at date: Date = Date()) {
        guard kg > 20, kg < 400 else { return }
        weights.removeAll { calendar.isDate($0.date, inSameDayAs: date) }
        weights.append(WeightEntry(date: date, kg: kg))
        weights.sort { $0.date < $1.date }
        save()
    }

    func deleteWeight(id: UUID) {
        weights.removeAll { $0.id == id }
        save()
    }

    var latestWeight: WeightEntry? { weights.last }

    func weighedIn(on day: Date) -> Bool {
        weights.contains { calendar.isDate($0.date, inSameDayAs: day) }
    }

    /// The average of the weigh-ins in the 7 days up to the end of `date`'s
    /// day; nil when that week has none — an old weigh-in is no average.
    func trendWeight(at date: Date = Date()) -> Double? {
        let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date)) ?? date
        let start = calendar.date(byAdding: .day, value: -7, to: end) ?? date
        let week = weights.filter { $0.date >= start && $0.date < end }
        guard !week.isEmpty else { return nil }
        return week.reduce(0) { $0 + $1.kg } / Double(week.count)
    }

    /// The 7-day average now against the one `days` ago; nil unless both
    /// weeks have weigh-ins.
    func trendChange(days: Int, at date: Date = Date()) -> Double? {
        guard let then = calendar.date(byAdding: .day, value: -days, to: date),
              let now = trendWeight(at: date), let before = trendWeight(at: then) else { return nil }
        return now - before
    }

    // MARK: - Reminders

    /// Asks for notifications the first time a reminder is turned on.
    /// False when the user has turned them off for MUSQ.
    func requestNotifications() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            notificationsDenied = false
            return true
        case .denied:
            notificationsDenied = true
            return false
        default:
            let granted = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
            notificationsDenied = !granted
            return granted
        }
    }

    /// Re-lays the reminders after any change, once the previous refresh is
    /// done. The root view calls it when the app becomes active, so the
    /// water reminders always reach a day ahead.
    func refreshRemindersSoon() {
        let previous = refreshTask
        refreshTask = Task {
            await previous?.value
            await refreshReminders()
        }
    }

    /// Re-lays the pending reminders: water for the rest of today (none once
    /// the target is reached) and tomorrow, the daily weigh-in, Balance's
    /// eating check-in (today unless done, and tomorrow) and the wind-down.
    private func refreshReminders(now: Date = Date()) async {
        let center = UNUserNotificationCenter.current()
        let pending = await center.pendingNotificationRequests()
        let ours = pending.map(\.identifier).filter {
            $0.hasPrefix(Self.waterPrefix) || $0 == Self.weighInID || $0.hasPrefix(Self.checkInID) || $0 == Self.bedtimeID
        }
        center.removePendingNotificationRequests(withIdentifiers: ours)
        // The check-in leads nowhere while eating isn't scored.
        let checksIn = checkInReminder.isOn && BalanceSettings.shared.scoresEat
        guard waterReminder.isOn || weighInReminder.isOn || checksIn || bedtimeReminder.isOn else { return }

        // A reminder that is on but was never allowed (permission reset)
        // asks again rather than staying silent.
        var status = await center.notificationSettings().authorizationStatus
        if status == .notDetermined {
            _ = await requestNotifications()
            status = await center.notificationSettings().authorizationStatus
        }
        let allowed = [.authorized, .provisional, .ephemeral].contains(status)
        notificationsDenied = status == .denied
        guard allowed else { return }

        if waterReminder.isOn {
            let target = waterTarget
            let content = UNMutableNotificationContent()
            content.title = String(localized: "Time for water")
            content.body = String(localized: "A glass now keeps you on track for \(Self.litres(target)) today.",
                                  comment: "Water reminder; the day's target, e.g. 2.5 L")
            content.sound = .default
            let today = calendar.startOfDay(for: now)
            for offset in 0...1 {
                guard let day = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
                if offset == 0 && waterDrunk(on: now) >= target { continue }
                for hour in waterReminder.hours {
                    guard let fire = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day), fire > now else {
                        continue
                    }
                    let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fire)
                    let id = "\(Self.waterPrefix)\(parts.year ?? 0)-\(parts.month ?? 0)-\(parts.day ?? 0)-\(hour)"
                    let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
                    try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
                }
            }
        }

        if weighInReminder.isOn {
            let content = UNMutableNotificationContent()
            content.title = String(localized: "Time to weigh in")
            content.body = String(localized: "Before breakfast, after the bathroom: the same time each day keeps the trend honest.")
            content.sound = .default
            var parts = DateComponents()
            parts.hour = weighInReminder.hour
            parts.minute = weighInReminder.minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: true)
            try? await center.add(UNNotificationRequest(identifier: Self.weighInID, content: content, trigger: trigger))
        }

        // Balance: one a day each, off by default. The check-in is laid a
        // day at a time like the water, so today's is dropped once it is
        // done (a check-in or a logged meal).
        if checksIn {
            let content = UNMutableNotificationContent()
            content.title = String(localized: "How did you eat today?")
            content.body = String(localized: "Two taps on Today keep your Balance honest: protein, and eating against your plan.")
            content.sound = .default
            let today = calendar.startOfDay(for: now)
            let doneToday = checkIn(on: now) != nil || !meals(on: now).isEmpty
            for offset in 0...1 {
                if offset == 0 && doneToday { continue }
                guard let day = calendar.date(byAdding: .day, value: offset, to: today),
                      let fire = calendar.date(bySettingHour: checkInReminder.hour, minute: checkInReminder.minute,
                                               second: 0, of: day),
                      fire > now else { continue }
                let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fire)
                let id = "\(Self.checkInID).\(DayKey.make(day, calendar: calendar))"
                let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
                try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
            }
        }
        if bedtimeReminder.isOn {
            let content = UNMutableNotificationContent()
            content.title = String(localized: "Time to wind down")
            content.body = String(localized: "Screens down and lights low: sleep is when the training turns into muscle.")
            content.sound = .default
            var parts = DateComponents()
            parts.hour = bedtimeReminder.hour
            parts.minute = bedtimeReminder.minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: true)
            try? await center.add(UNNotificationRequest(identifier: Self.bedtimeID, content: content, trigger: trigger))
        }
    }

    private static let waterPrefix = "water."
    private static let weighInID = "weighin"
    private static let checkInID = "balance.checkin"
    private static let bedtimeID = "balance.bedtime"

    /// "2.5 L", "750 ml". The units are in the localized strings, joined to
    /// the number by a no-break space.
    static func litres(_ ml: Int) -> String {
        if ml < 1_000 {
            return String(localized: "\(ml)\u{00A0}ml",
                          comment: "An amount of water under a litre: 750 ml (keep the no-break space)")
        }
        let litres = (Double(ml) / 1_000).formatted(.number.precision(.fractionLength(0...2)))
        return String(localized: "\(litres)\u{00A0}L",
                      comment: "An amount of water in litres: 2.5 L (keep the no-break space)")
    }

    // MARK: - Meals

    func addMeal(_ meal: MealEntry) {
        meals.append(meal)
        meals.sort { $0.date < $1.date }
        save()
        // A meal logged today stands in for the evening check-in reminder.
        if checkInReminder.isOn { refreshRemindersSoon() }
    }

    func deleteMeal(id: UUID) {
        meals.removeAll { $0.id == id }
        save()
        if checkInReminder.isOn { refreshRemindersSoon() }
    }

    /// Replaces a logged meal with the member's edit of it (2026-11-22): its
    /// name, time and foods. What the meal came with stays as logged: its
    /// id, where it came from, the scan's confidence and note, and, for each
    /// food still in it (by the item's id), what the scan sent and the AI
    /// model's own grams and kcal. A meal moved to another day moves with
    /// its time. False, and nothing saved, when the meal is no longer in the
    /// log or has no foods left (that's `deleteMeal`).
    @discardableResult
    func updateMeal(_ edited: MealEntry) -> Bool {
        guard !edited.items.isEmpty, let index = meals.firstIndex(where: { $0.id == edited.id }) else { return false }
        let logged = meals[index]
        let loggedItems = Dictionary(logged.items.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        var meal = edited
        meal.source = logged.source
        meal.confidence = logged.confidence
        meal.aiNote = logged.aiNote
        meal.items = edited.items.map { item in
            guard let before = loggedItems[item.id] else { return item }
            var item = item
            item.aiGrams = before.aiGrams
            item.aiKcal = before.aiKcal
            item.modelGrams = before.modelGrams
            item.modelKcal = before.modelKcal
            return item
        }
        meals[index] = meal
        meals.sort { $0.date < $1.date }
        save()
        // A meal moved into or out of today stands in for the check-in, or no longer does.
        if checkInReminder.isOn { refreshRemindersSoon() }
        return true
    }

    func meals(on day: Date) -> [MealEntry] {
        meals.filter { calendar.isDate($0.date, inSameDayAs: day) }
    }

    /// What the day's logged meals add up to.
    func eaten(on day: Date) -> (kcal: Int, proteinG: Int, fatG: Int, carbsG: Int) {
        meals(on: day).reduce((0, 0, 0, 0)) { ($0.0 + $1.kcal, $0.1 + $1.proteinG, $0.2 + $1.fatG, $0.3 + $1.carbsG) }
    }

    // MARK: - Balance check-ins

    /// One check-in a day: checking in again replaces it. Nil for a
    /// question that wasn't asked; with neither answered there is nothing
    /// to keep, so the day's check-in is cleared.
    func setCheckIn(_ protein: EatCheckIn.Protein?, _ plan: EatCheckIn.Plan?, on day: Date = Date()) {
        guard protein != nil || plan != nil else {
            clearCheckIn(on: day)
            return
        }
        let key = DayKey.make(day, calendar: calendar)
        checkIns.removeAll { $0.day == key }
        checkIns.append(EatCheckIn(day: key, protein: protein, plan: plan))
        checkIns.sort { $0.day < $1.day }
        save()
        refreshRemindersSoon()
    }

    func clearCheckIn(on day: Date) {
        let key = DayKey.make(day, calendar: calendar)
        checkIns.removeAll { $0.day == key }
        save()
        refreshRemindersSoon()
    }

    func checkIn(on day: Date) -> EatCheckIn? {
        let key = DayKey.make(day, calendar: calendar)
        return checkIns.last { $0.day == key }
    }

    func setSleepEstimate(_ band: SleepEstimate.Band, on day: Date = Date()) {
        let key = DayKey.make(day, calendar: calendar)
        sleepEstimates.removeAll { $0.day == key }
        sleepEstimates.append(SleepEstimate(day: key, band: band))
        sleepEstimates.sort { $0.day < $1.day }
        save()
    }

    func clearSleepEstimate(on day: Date) {
        let key = DayKey.make(day, calendar: calendar)
        sleepEstimates.removeAll { $0.day == key }
        save()
    }

    func sleepEstimate(on day: Date) -> SleepEstimate? {
        let key = DayKey.make(day, calendar: calendar)
        return sleepEstimates.last { $0.day == key }
    }

    // MARK: - Steps added by hand

    func addSteps(_ steps: Int, minutes: Int? = nil, at date: Date = Date()) {
        guard steps > 0, steps <= 100_000 else { return }
        stepEntries.append(StepsEntry(date: date, steps: steps, minutes: minutes))
        stepEntries.sort { $0.date < $1.date }
        save()
    }

    func deleteSteps(id: UUID) {
        stepEntries.removeAll { $0.id == id }
        save()
    }

    func stepEntries(on day: Date) -> [StepsEntry] {
        stepEntries.filter { calendar.isDate($0.date, inSameDayAs: day) }
    }

    /// Steps added by hand on a day.
    func manualSteps(on day: Date) -> Int {
        stepEntries(on: day).reduce(0) { $0 + $1.steps }
    }

    /// Hand-added steps by day (start of day), for Apple Health's daily totals.
    var manualStepsByDay: [Date: Double] {
        stepEntries.reduce(into: [:]) { $0[calendar.startOfDay(for: $1.date), default: 0] += Double($1.steps) }
    }

    // MARK: - Paused weeks

    /// Pauses (or resumes) the calendar week that holds `start`.
    func setPaused(_ paused: Bool, week start: Date) {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: start) else { return }
        pausedWeeks = pausedWeeks.filter { !Self.key($0, isIn: week, calendar: calendar) }
        if paused { pausedWeeks.insert(DayKey.make(week.start, calendar: calendar)) }
        save()
    }

    /// Whether the calendar week that holds `start` (any day of it) is
    /// paused.
    func isPaused(week start: Date) -> Bool {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: start) else { return false }
        return pausedWeeks.contains { Self.key($0, isIn: week, calendar: calendar) }
    }

    /// A week's interval includes its end, the next week's first moment.
    private static func key(_ key: String, isIn week: DateInterval, calendar: Calendar) -> Bool {
        guard let day = DayKey.date(key, calendar: calendar) else { return false }
        return day >= week.start && day < week.end
    }

    // MARK: - Persistence

    private struct Snapshot: Codable {
        var version = 1
        var water: [WaterEntry]
        var weights: [WeightEntry]
        /// Absent in files saved before meal logging (2026-11-21).
        var meals: [MealEntry]?
        var waterTargetOverride: Int?
        var waterReminder: WaterReminder?
        var weighInReminder: WeighInReminder?
        /// Balance and quick logs (2026-11-22); absent in older files.
        var checkIns: [EatCheckIn]?
        var sleepEstimates: [SleepEstimate]?
        var stepEntries: [StepsEntry]?
        /// Day keys; the first builds of 2026-11-22 saved instants, which
        /// decode as ISO 8601 strings and are turned into keys on load.
        var pausedWeeks: [String]?
        var waterPresets: [Int]?
        var checkInReminder: CheckInReminder?
        var bedtimeReminder: BedtimeReminder?
    }

    static var defaultFileURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("Daily", isDirectory: true).appendingPathComponent("daily.json")
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let snapshot = try? JSONDecoder.daily.decode(Snapshot.self, from: data) else {
            // Keep an unreadable file for recovery rather than save over it.
            let stamp = Int(Date().timeIntervalSince1970)
            let aside = fileURL.deletingPathExtension().appendingPathExtension("corrupt-\(stamp).json")
            try? FileManager.default.moveItem(at: fileURL, to: aside)
            return
        }
        isLoading = true
        water = snapshot.water.sorted { $0.date < $1.date }
        weights = snapshot.weights.sorted { $0.date < $1.date }
        meals = (snapshot.meals ?? []).sorted { $0.date < $1.date }
        waterTargetOverride = snapshot.waterTargetOverride
        waterReminder = snapshot.waterReminder ?? WaterReminder()
        weighInReminder = snapshot.weighInReminder ?? WeighInReminder()
        checkIns = (snapshot.checkIns ?? []).map { item in
            var item = item
            item.day = DayKey.normalized(item.day, calendar: calendar)
            return item
        }.sorted { $0.day < $1.day }
        sleepEstimates = (snapshot.sleepEstimates ?? []).map { item in
            var item = item
            item.day = DayKey.normalized(item.day, calendar: calendar)
            return item
        }.sorted { $0.day < $1.day }
        stepEntries = (snapshot.stepEntries ?? []).sorted { $0.date < $1.date }
        pausedWeeks = Set((snapshot.pausedWeeks ?? []).map { DayKey.normalized($0, calendar: calendar) })
        if let presets = snapshot.waterPresets, !presets.isEmpty { waterPresets = presets }
        checkInReminder = snapshot.checkInReminder ?? CheckInReminder()
        bedtimeReminder = snapshot.bedtimeReminder ?? BedtimeReminder()
        isLoading = false
    }

    private func save() {
        let snapshot = Snapshot(water: water, weights: weights, meals: meals, waterTargetOverride: waterTargetOverride,
                                waterReminder: waterReminder, weighInReminder: weighInReminder,
                                checkIns: checkIns, sleepEstimates: sleepEstimates, stepEntries: stepEntries,
                                pausedWeeks: pausedWeeks.sorted(), waterPresets: waterPresets,
                                checkInReminder: checkInReminder, bedtimeReminder: bedtimeReminder)
        do {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            try JSONEncoder.daily.encode(snapshot).write(to: fileURL, options: .atomic)
        } catch {
            assertionFailure("Couldn't save the daily log: \(error)")
        }
    }
}

/// The energy a logged workout burned above rest: (MET − 1) × kg × hours at
/// MET 3.5, resistance training with several exercises at 8-15 reps
/// (Compendium of Physical Activities, 2024). The time is the gaps between
/// completed sets, each counted up to 10 minutes (a set ticked hours later,
/// or a second session that day, adds no idle time), plus two minutes for
/// the first set itself.
enum TrainingEnergy {
    static let met = 3.5
    static let longestGap: TimeInterval = 10 * 60

    static func estimate(_ session: WorkoutSession, weightKg: Double) -> (minutes: Int, kcal: Int)? {
        let times = session.exercises.flatMap(\.sets).filter(\.isCompleted).compactMap(\.completedAt).sorted()
        guard !times.isEmpty else { return nil }
        let active = zip(times, times.dropFirst()).reduce(0.0) { $0 + min($1.1.timeIntervalSince($1.0), longestGap) }
        let minutes = max(5, Int((active / 60).rounded()) + 2)
        let kcal = (met - 1) * weightKg * Double(minutes) / 60
        return (minutes, Int(kcal.rounded()))
    }
}

private extension JSONEncoder {
    static var daily: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}

private extension JSONDecoder {
    static var daily: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
