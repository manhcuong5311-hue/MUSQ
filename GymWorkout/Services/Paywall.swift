//
//  Paywall.swift
//  GymWorkout
//
//  Opens the Premium sheet from anywhere: a common mistake, Form
//  Comparison, Preset 2 or 3, the Profile card. One sheet,
//  presented by RootView, so no screen has to host it. Onboarding presents
//  its own (it has to finish onboarding when the sheet closes).
//

import Observation

@Observable
final class Paywall {
    /// What the person tapped, which the sheet's headline speaks to.
    enum Reason: String, Identifiable {
        case onboarding, mistake, comparison, preset, profile
        var id: String { rawValue }
    }

    var reason: Reason?

    func show(_ reason: Reason) { self.reason = reason }
}

/// What Premium unlocks, in one place.
enum Premium {
    /// Saved presets a free account can save per group: Preset 1.
    static let freePresets = 1
}
