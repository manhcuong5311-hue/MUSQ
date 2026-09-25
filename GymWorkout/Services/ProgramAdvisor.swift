//
//  ProgramAdvisor.swift
//  GymWorkout
//
//  Turns the onboarding answers into suggestions: the split that suits the
//  days a week (upper / lower, front / back or push / pull / legs) and the
//  rotation of muscle groups it gives, which preset level a group opens on,
//  and the walk after a weight-loss workout. Everything here only suggests — any group, preset
//  or exercise stays one tap away.
//

import Foundation

enum ProgramAdvisor {

    // MARK: - Split

    /// Weekly schedules onboarding offers.
    static let daysPerWeekOptions = [2, 3, 4, 5, 6]

    /// The split that suits a number of sessions a week. Two or four days
    /// split upper from lower body, so four days train everything twice.
    /// Three days alternate front and back, and every session still works
    /// both the upper and the lower body. Five or six days have room for push,
    /// pull and legs, and six trains everything twice.
    static func recommendedSplit(daysPerWeek: Int) -> TrainingSplit {
        switch daysPerWeek {
        case 3: return .frontBack
        case ...4: return .upperLower
        default: return .pushPullLegs
        }
    }

    /// Why the recommended split fits, finishing "… suits N days a week
    /// best: …". No numbers: the split's card shows how often each muscle
    /// comes round, which depends on the lower-body focus.
    static func recommendationReason(daysPerWeek: Int) -> String {
        switch daysPerWeek {
        case 3: return "every session trains both the upper and the lower body, so no muscle waits a whole week."
        case ...2: return "each session covers half the body, so two days reach every muscle."
        case 4: return "the upper and lower body take turns training and resting."
        default: return "shorter, focused sessions, and each muscle rests while the others work."
        }
    }

    /// The profile's split. Profiles saved before the question existed keep
    /// what they had: push, pull and legs, or the lower-body rotation for
    /// women.
    static func split(for profile: UserProfile?) -> TrainingSplit {
        if let split = profile?.split { return split }
        return isLowerFocused(profile) ? .upperLower : .pushPullLegs
    }

    // MARK: - Rotation

    /// One day of a split: what it's called and the groups it trains.
    struct SplitDay: Hashable {
        let name: String
        let groups: [MuscleGroup]
    }

    /// A split's days in order. A lower-body focus puts the lower groups
    /// first and, where the split has room, adds a second lower day, so legs
    /// and glutes come up twice in each rotation.
    static func days(of split: TrainingSplit, lowerFocus: Bool) -> [SplitDay] {
        switch (split, lowerFocus) {
        case (.upperLower, false):
            return [SplitDay(name: "Upper", groups: [.chest, .back, .shoulders, .biceps, .triceps]),
                    SplitDay(name: "Lower", groups: [.quads, .hamstrings, .glutes, .abs])]
        case (.upperLower, true):
            return [SplitDay(name: "Lower A", groups: [.glutes, .hamstrings, .abs]),
                    SplitDay(name: "Upper", groups: [.back, .chest, .shoulders, .biceps, .triceps]),
                    SplitDay(name: "Lower B", groups: [.quads, .glutes])]
        case (.frontBack, false):
            return [SplitDay(name: "Front", groups: [.chest, .shoulders, .quads, .biceps, .abs]),
                    SplitDay(name: "Back", groups: [.back, .hamstrings, .glutes, .triceps])]
        case (.frontBack, true):
            return [SplitDay(name: "Front", groups: [.quads, .chest, .shoulders, .biceps, .abs]),
                    SplitDay(name: "Back", groups: [.glutes, .hamstrings, .back, .triceps])]
        case (.pushPullLegs, false):
            return [SplitDay(name: "Push", groups: [.chest, .shoulders, .triceps]),
                    SplitDay(name: "Pull", groups: [.back, .biceps]),
                    SplitDay(name: "Legs", groups: [.quads, .hamstrings, .glutes])]
        case (.pushPullLegs, true):
            return [SplitDay(name: "Legs A", groups: [.glutes, .hamstrings]),
                    SplitDay(name: "Push", groups: [.chest, .shoulders, .triceps]),
                    SplitDay(name: "Legs B", groups: [.quads, .glutes, .abs]),
                    SplitDay(name: "Pull", groups: [.back, .biceps])]
        }
    }

    /// Push / pull / legs — the planner's default.
    static let standardRotation: [[MuscleGroup]] = days(of: .pushPullLegs, lowerFocus: false).map(\.groups)

    static func days(for profile: UserProfile?) -> [SplitDay] {
        days(of: split(for: profile), lowerFocus: isLowerFocused(profile))
    }

    static func rotation(for profile: UserProfile?) -> [[MuscleGroup]] {
        days(for: profile).map(\.groups)
    }

    /// How often each muscle group comes round in a week, at most and at
    /// least: sessions a week over the rotation's length, times the days that
    /// train the group. The planner follows recovery rather than a calendar,
    /// so this is what the schedule allows, not a promise.
    static func timesPerWeek(_ split: TrainingSplit, lowerFocus: Bool, daysPerWeek: Int) -> ClosedRange<Double> {
        let days = days(of: split, lowerFocus: lowerFocus)
        let perRotation = Dictionary(days.flatMap(\.groups).map { ($0, 1) }, uniquingKeysWith: +)
        let counts = perRotation.values.map { Double($0) * Double(daysPerWeek) / Double(days.count) }
        return (counts.min() ?? 0)...(counts.max() ?? 0)
    }

    /// "about 2× a week", "1–2× a week", "less than once a week".
    static func frequencyText(_ range: ClosedRange<Double>) -> String {
        func times(_ value: Double) -> String {
            let half = (value * 2).rounded() / 2
            return half.formatted(.number.precision(.fractionLength(0...1))) + "×"
        }
        if range.upperBound < 0.9 { return "less than once a week" }
        let low = times(range.lowerBound), high = times(range.upperBound)
        if low == high { return "about \(low) a week" }
        return "\(low.dropLast())–\(high) a week"
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
