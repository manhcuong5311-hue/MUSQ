//
//  TodaySnapshot.swift
//  Shared
//
//  What the widgets and the Today Live Activity show, written by the app
//  (on launch, on water/meal changes, on plan changes) into the App Group and
//  read by MUSQWidgets. Plain values only: the extension has none of the
//  app's stores.
//

import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

nonisolated struct TodaySnapshot: Codable, Hashable, Sendable {
    /// Start of the local day the numbers belong to.
    var day: Date
    var waterML: Int
    var waterTargetML: Int
    var kcalEaten: Int
    var kcalTarget: Int
    var proteinG: Int
    var proteinTargetG: Int
    var mealsCount: Int
    /// Today is a scheduled training day (ProgramAdvisor), not a rest day.
    var isTrainingDay: Bool
    /// Today's workout is done.
    var trainedToday: Bool
    /// Short label of the next training day: "Push", "Legs"… nil = none planned.
    var nextTrainingLabel: String?
    /// Day of the next training (today when isTrainingDay and not trained yet).
    var nextTrainingDay: Date?
    /// Usual workout time today/next day, if known (for "Push · 18:00").
    var nextTrainingTime: Date?
    var updatedAt: Date
    /// The training days of the coming week (today included, done or not),
    /// so a snapshot read on a later day can still tell training from rest
    /// and name the next workout. nil in snapshots from before 11-28.
    var upcoming: [Training]? = nil

    nonisolated struct Training: Codable, Hashable, Sendable {
        var day: Date
        var label: String?
        var time: Date?
    }

    var waterProgress: Double { waterTargetML > 0 ? min(1, Double(waterML) / Double(waterTargetML)) : 0 }
    var kcalProgress: Double { kcalTarget > 0 ? min(1, Double(kcalEaten) / Double(kcalTarget)) : 0 }
    var kcalLeft: Int { max(0, kcalTarget - kcalEaten) }

    /// The snapshot as it should read on `date`: a snapshot from an earlier
    /// day keeps its targets and plan but shows zero logged (a new day).
    func normalized(for date: Date = Date(), calendar: Calendar = .current) -> TodaySnapshot {
        let today = calendar.startOfDay(for: date)
        guard calendar.startOfDay(for: day) != today else { return self }
        var s = self
        s.day = today
        s.waterML = 0; s.kcalEaten = 0; s.proteinG = 0; s.mealsCount = 0
        s.trainedToday = false
        // The plan as of the new day: the first training day from today on.
        // Yesterday's "today is a training day" and a past next-training
        // day must not carry over.
        if let upcoming {
            let next = upcoming.filter { calendar.startOfDay(for: $0.day) >= today }
                .min { $0.day < $1.day }
            s.isTrainingDay = next.map { calendar.isDate($0.day, inSameDayAs: today) } ?? false
            s.nextTrainingLabel = next?.label
            s.nextTrainingDay = next?.day
            s.nextTrainingTime = next?.time
        } else if let nextDay = nextTrainingDay, calendar.startOfDay(for: nextDay) >= today {
            s.isTrainingDay = calendar.isDate(nextDay, inSameDayAs: today)
        } else {
            s.isTrainingDay = false
            s.nextTrainingLabel = nil
            s.nextTrainingDay = nil
            s.nextTrainingTime = nil
        }
        return s
    }

    // MARK: - App Group storage

    static func load(from defaults: UserDefaults = AppGroup.defaults) -> TodaySnapshot? {
        guard let data = defaults.data(forKey: AppGroup.Key.todaySnapshot) else { return nil }
        return try? JSONDecoder().decode(TodaySnapshot.self, from: data)
    }

    /// App only: stores the snapshot and asks WidgetKit to redraw the widgets
    /// when anything changed. Returns true when it was new.
    @discardableResult
    func save(to defaults: UserDefaults = AppGroup.defaults, reloadWidgets: Bool = true) -> Bool {
        var a = self, b = TodaySnapshot.load(from: defaults)
        a.updatedAt = .distantPast; b?.updatedAt = .distantPast
        guard a != b, let data = try? JSONEncoder().encode(self) else { return false }
        defaults.set(data, forKey: AppGroup.Key.todaySnapshot)
        #if canImport(WidgetKit)
        if reloadWidgets { WidgetCenter.shared.reloadAllTimelines() }
        #endif
        return true
    }

    /// Water a widget button queued while the app couldn't run it: added to
    /// the stored snapshot (today's) so the widgets show it at once.
    static func addQueuedWater(_ ml: Int, now: Date = Date()) {
        guard var snap = load()?.normalized(for: now) else { return }
        snap.waterML += max(1, ml)
        snap.updatedAt = now
        snap.save()
    }

    // MARK: - Samples (previews, -widget.sample, placeholders)

    static let sample = TodaySnapshot(
        day: Calendar.current.startOfDay(for: Date()),
        waterML: 1500, waterTargetML: 2500,
        kcalEaten: 1420, kcalTarget: 2300,
        proteinG: 96, proteinTargetG: 150,
        mealsCount: 2,
        isTrainingDay: true, trainedToday: false,
        nextTrainingLabel: "Push",
        nextTrainingDay: Calendar.current.startOfDay(for: Date()),
        nextTrainingTime: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()),
        updatedAt: Date())

    static let empty = TodaySnapshot(
        day: Calendar.current.startOfDay(for: Date()),
        waterML: 0, waterTargetML: 2500, kcalEaten: 0, kcalTarget: 2200,
        proteinG: 0, proteinTargetG: 0, mealsCount: 0,
        isTrainingDay: false, trainedToday: false,
        nextTrainingLabel: nil, nextTrainingDay: nil, nextTrainingTime: nil,
        updatedAt: Date())
}
