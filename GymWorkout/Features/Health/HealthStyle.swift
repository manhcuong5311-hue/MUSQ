//
//  HealthStyle.swift
//  GymWorkout
//
//  Shared by every screen that shows Apple Health numbers (phase 2,
//  2026-11-22): the two identity colours, the number formats, and the copy
//  for asking to connect. The colours are the user's pick (three each).
//

import SwiftUI
import UIKit

/// The steps colour the user picked (Profile › Settings › Apple Health ›
/// Colors, 2026-11-22: the owner left the choice to users). None is blue
/// (water), violet/pink (weight), orange (workout, muscles) or the recovery
/// green/yellow/red.
enum StepsTone: String, CaseIterable, Identifiable {
    case teal, lime, aqua

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .teal: return Color(light: 0x0F9E94, dark: 0x34D1C4)
        case .lime: return Color(light: 0x5E9E12, dark: 0xB5E853)
        case .aqua: return Color(light: 0x0E9FB8, dark: 0x2FD5E8)
        }
    }

    var title: String {
        switch self {
        case .teal: return String(localized: "Teal", comment: "Steps colour option")
        case .lime: return String(localized: "Lime", comment: "Steps colour option")
        case .aqua: return String(localized: "Aqua", comment: "Steps colour option")
        }
    }
}

/// The sleep colour the user picked. Periwinkle sits near the weigh-in
/// violet; Moonlight and Indigo don't.
enum SleepTone: String, CaseIterable, Identifiable {
    case periwinkle, moonlight, indigo

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .periwinkle: return Color(light: 0x4C5FD5, dark: 0x8C9BFF)
        case .moonlight: return Color(light: 0x5E6E8C, dark: 0xA9B8D6)
        case .indigo: return Color(light: 0x3F48CC, dark: 0x5E6BFF)
        }
    }

    var title: String {
        switch self {
        case .periwinkle: return String(localized: "Periwinkle", comment: "Sleep colour option")
        case .moonlight: return String(localized: "Moonlight", comment: "Sleep colour option")
        case .indigo: return String(localized: "Indigo", comment: "Sleep colour option")
        }
    }
}

/// What the colour picker needs from either list.
protocol ToneOption {
    var color: Color { get }
    var title: String { get }
}

extension StepsTone: ToneOption {}
extension SleepTone: ToneOption {}

/// The two picks, saved with the settings. Observable, so every screen that
/// draws steps or sleep redraws the moment one changes.
@Observable
final class HealthPalette {
    static let shared = HealthPalette()

    static let stepsKey = "health.tone.steps"
    static let sleepKey = "health.tone.sleep"

    var steps: StepsTone {
        didSet { UserDefaults.standard.set(steps.rawValue, forKey: Self.stepsKey) }
    }
    var sleep: SleepTone {
        didSet { UserDefaults.standard.set(sleep.rawValue, forKey: Self.sleepKey) }
    }

    private init() {
        let defaults = UserDefaults.standard
        steps = defaults.string(forKey: Self.stepsKey).flatMap(StepsTone.init(rawValue:)) ?? .teal
        sleep = defaults.string(forKey: Self.sleepKey).flatMap(SleepTone.init(rawValue:)) ?? .periwinkle
    }
}

/// What the screens draw with: the user's picks.
enum HealthTone {
    static var steps: Color { HealthPalette.shared.steps.color }
    static var sleep: Color { HealthPalette.shared.sleep.color }
}

enum HealthFormat {
    /// "8,240".
    static func steps(_ value: Int) -> String { value.formatted() }

    /// "7 h 12", "45 min".
    static func sleep(minutes: Int) -> String {
        let h = minutes / 60, m = minutes % 60
        if h == 0 { return String(localized: "\(m) min", comment: "Sleep length under an hour") }
        return m == 0 ? String(localized: "\(h) h", comment: "Sleep length in whole hours")
                      : String(localized: "\(h) h \(String(format: "%02d", m))", comment: "Sleep length: 7 h 05")
    }

    /// Spoken form for VoiceOver: "7 hours 12 minutes".
    static func sleepSpoken(minutes: Int) -> String {
        let duration = Duration.seconds(minutes * 60)
        return duration.formatted(.units(allowed: [.hours, .minutes], width: .wide))
    }

    /// "5.2 km" or "3.2 mi" by the locale's measurement system; two decimals
    /// under 1 ("0.35 km"), as Health shows a short walk. Never feet, yards
    /// or metres, which `usage: .road` would pick for short distances.
    static func distance(km: Double) -> String {
        let unit: UnitLength = Locale.current.measurementSystem == .metric ? .kilometers : .miles
        let value = Measurement(value: km, unit: UnitLength.kilometers).converted(to: unit)
        let digits = value.value < 1 ? 2 : 1
        return value.formatted(.measurement(width: .abbreviated, usage: .asProvided,
                                            numberFormatStyle: .number.precision(.fractionLength(digits))))
    }
}

enum HealthCopy {
    static var connectTitle: String { String(localized: "Connect Apple Health", comment: "Button and card title") }
    static var connectDetail: String {
        String(localized: "See your steps and sleep here, and let your steps set how active your calorie plan assumes you are. Read only; it stays on this device unless you include your sleep in a question to the AI coach.",
               comment: "Why connect Apple Health")
    }
    /// HealthKit never says whether reading was turned off, so an empty
    /// card says where to look instead of "denied".
    static var noData: String {
        String(localized: "No data from Apple Health yet. If you turned access off, turn it back on in the Health app (tap your picture › Apps › MUSQ) or in Settings › Privacy & Security › Health › MUSQ.",
               comment: "Apple Health connected but nothing to show. The › paths are iOS menus: use iOS's own Vietnamese names")
    }

    /// Opens the Health app (its Sharing settings are where read access is changed).
    @MainActor static func openHealthApp() {
        if let url = URL(string: "x-apple-health://") { UIApplication.shared.open(url) }
    }
}
