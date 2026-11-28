//
//  MealScanQuota.swift
//  GymWorkout
//
//  What the server last said about today's meal scans (2026-11-27): the
//  scans left, kept with the day they were counted on (the local calendar),
//  so the app can say "used up" before a photo is taken, and a new day
//  starts fresh. Only the server counts: this is a remembered answer, never
//  a limit of its own. Nothing here leaves the device.
//

import Foundation

enum MealScanQuota {
    static let dayKey = "mealScanQuota.day"
    static let remainingKey = "mealScanQuota.remaining"

    /// The scans left today, as the server last said (a scan's answer, a
    /// failure's details, or 0 on the limit).
    static func record(remaining: Int) {
        let defaults = UserDefaults.standard
        defaults.set(today, forKey: dayKey)
        defaults.set(max(remaining, 0), forKey: remainingKey)
    }

    /// The scans left today, when the server has said so today; nil on a
    /// new day or before the first scan.
    static var remainingToday: Int? {
        let defaults = UserDefaults.standard
        guard defaults.string(forKey: dayKey) == today, defaults.object(forKey: remainingKey) != nil else { return nil }
        return defaults.integer(forKey: remainingKey)
    }

    /// Today's scans are used up, as far as the server last said.
    static var exhaustedToday: Bool { remainingToday == 0 }

    /// "2026-11-27" in the local calendar, so the count resets at local
    /// midnight.
    private static var today: String {
        let parts = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return String(format: "%04d-%02d-%02d", parts.year ?? 0, parts.month ?? 0, parts.day ?? 0)
    }
}
