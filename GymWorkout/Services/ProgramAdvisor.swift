//
//  ProgramAdvisor.swift
//  GymWorkout
//
//  Turns the onboarding answers into suggestions: which muscle groups the
//  rotation offers, which preset level a group opens on, and the walk after
//  a weight-loss workout. Everything here only suggests — any group, preset
//  or exercise stays one tap away.
//

import Foundation

enum ProgramAdvisor {

    // MARK: - Rotation

    /// Push / pull / legs.
    static let standardRotation: [[MuscleGroup]] = [
        [.chest, .shoulders, .triceps],
        [.back, .biceps],
        [.quads, .hamstrings, .glutes]
    ]

    /// Lower / upper / lower / upper: half the days train the legs, and the
    /// glutes come up on both lower days.
    static let lowerFocusRotation: [[MuscleGroup]] = [
        [.glutes, .hamstrings],
        [.back, .shoulders, .biceps],
        [.quads, .glutes],
        [.chest, .triceps, .abs]
    ]

    static func rotation(for profile: UserProfile?) -> [[MuscleGroup]] {
        profile?.sex == .female ? lowerFocusRotation : standardRotation
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
    static func suggestedLevel(for profile: UserProfile?, experience: TrainingExperience) -> PresetLevel {
        guard let profile, profile.goal != .loseWeight, experience != .beginner else { return .basic }
        return .advanced
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

    var kilometres: Double { Double(steps) * heightCm * 0.415 / 100_000 }
    var minutes: Int { Int((Double(steps) / 100).rounded()) }
    var kilocalories: Int { Int((kilometres * weightKg * 0.5).rounded()) }

    /// "≈ 2.8 km · 30 min · 100 kcal".
    var detail: String {
        let km = kilometres.formatted(.number.precision(.fractionLength(1)))
        return "≈ \(km) km · \(minutes) min · \(kilocalories) kcal"
    }
}
