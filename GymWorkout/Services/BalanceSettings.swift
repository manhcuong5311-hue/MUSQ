//
//  BalanceSettings.swift
//  GymWorkout
//
//  The user's Balance choices (2026-11-22, owner: "put all three in
//  Settings for the user to pick"): the card's style (bars, triangle or
//  three-part ring), whether it shows on Today, which pillars are scored,
//  the training volume target and the Eat colour. Saved with the settings;
//  observed, so every screen follows a change at once.
//

import SwiftUI

enum BalanceStyle: String, CaseIterable, Identifiable {
    case bars, triangle, ring

    var id: String { rawValue }

    var title: String {
        switch self {
        case .bars: return String(localized: "Bars", comment: "Balance card style")
        case .triangle: return String(localized: "Triangle", comment: "Balance card style")
        case .ring: return String(localized: "Ring", comment: "Balance card style")
        }
    }

    var detail: String {
        switch self {
        case .bars: return String(localized: "Three bars with what's behind each — the easiest to read.")
        case .triangle: return String(localized: "One corner per pillar: a weak one pulls its corner in.")
        case .ring: return String(localized: "One ring in three parts, your Balance in the middle.")
        }
    }
}

/// How many effective sets a week each muscle aims for.
enum VolumeTarget: String, CaseIterable, Identifiable {
    /// By training experience: 6 beginner, 10 intermediate, 12 advanced.
    case auto
    /// 6 a week, enough to keep muscle while busy or deep in a cut
    /// (Bickel 2011; Spiering 2021).
    case maintain

    var id: String { rawValue }

    var title: String {
        switch self {
        case .auto: return String(localized: "Auto", comment: "Balance volume target")
        case .maintain: return String(localized: "Maintain", comment: "Balance volume target")
        }
    }
}

/// The Eat pillar's colour, the user's pick like steps and sleep.
enum EatTone: String, CaseIterable, Identifiable, ToneOption {
    case wheat, orchid, mint

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .wheat: return Color(light: 0xA9782E, dark: 0xE8C48F)
        case .orchid: return Color(light: 0x9B3FC9, dark: 0xD58CFF)
        case .mint: return Color(light: 0x1E9466, dark: 0x7EE0B5)
        }
    }

    var title: String {
        switch self {
        case .wheat: return String(localized: "Wheat", comment: "Eat colour option")
        case .orchid: return String(localized: "Orchid", comment: "Eat colour option")
        case .mint: return String(localized: "Mint", comment: "Eat colour option")
        }
    }
}

@Observable
final class BalanceSettings {
    static let shared = BalanceSettings()

    private enum Keys {
        static let style = "balance.style"
        static let showsOnToday = "balance.showsOnToday"
        static let scoresEat = "balance.scoresEat"
        static let scoresSleep = "balance.scoresSleep"
        static let hidesCalories = "balance.hidesCalories"
        static let volume = "balance.volume"
        static let eatTone = "balance.eatTone"
        static let estimatesSleep = "balance.estimatesSleep"
    }

    var style: BalanceStyle { didSet { save(style.rawValue, Keys.style) } }
    var showsOnToday: Bool { didSet { save(showsOnToday, Keys.showsOnToday) } }
    /// Off for anyone who'd rather not have eating scored (for example a
    /// history of disordered eating).
    var scoresEat: Bool { didSet { save(scoresEat, Keys.scoresEat) } }
    /// Off for shift workers (the 6 pm split misfiles day sleep) or new parents.
    var scoresSleep: Bool { didSet { save(scoresSleep, Keys.scoresSleep) } }
    /// Eat then scores protein only, and no calorie numbers show.
    var hidesCalories: Bool { didSet { save(hidesCalories, Keys.hidesCalories) } }
    var volume: VolumeTarget { didSet { save(volume.rawValue, Keys.volume) } }
    var eatTone: EatTone { didSet { save(eatTone.rawValue, Keys.eatTone) } }
    /// Offers the morning "Slept about…" tap when there's no sleep data.
    var estimatesSleep: Bool { didSet { save(estimatesSleep, Keys.estimatesSleep) } }

    private init() {
        let d = UserDefaults.standard
        style = d.string(forKey: Keys.style).flatMap(BalanceStyle.init(rawValue:)) ?? .bars
        showsOnToday = d.object(forKey: Keys.showsOnToday) as? Bool ?? true
        scoresEat = d.object(forKey: Keys.scoresEat) as? Bool ?? true
        scoresSleep = d.object(forKey: Keys.scoresSleep) as? Bool ?? true
        hidesCalories = d.object(forKey: Keys.hidesCalories) as? Bool ?? false
        volume = d.string(forKey: Keys.volume).flatMap(VolumeTarget.init(rawValue:)) ?? .auto
        eatTone = d.string(forKey: Keys.eatTone).flatMap(EatTone.init(rawValue:)) ?? .wheat
        estimatesSleep = d.object(forKey: Keys.estimatesSleep) as? Bool ?? true
    }

    private func save(_ value: Any, _ key: String) { UserDefaults.standard.set(value, forKey: key) }
}

/// Balance's pillar colours: Train is the workout orange, Sleep the user's
/// sleep colour, Eat the user's Eat colour.
enum BalanceTone {
    static var train: Color { TodayTone.workout }
    static var eat: Color { BalanceSettings.shared.eatTone.color }
    static var sleep: Color { HealthTone.sleep }
}
