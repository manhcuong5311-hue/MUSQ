//
//  EquipmentCatalog.swift
//  GymWorkout
//
//  The gear a user can say they have, and what each exercise needs. The
//  library dims (or hides) lifts that need gear the user doesn't have.
//
//  `Exercise.equipment` stays as the 26 upper-case strings other services
//  compare; this maps them — plus the exercise name for MACHINE lifts and
//  for lifts that need a bench, a bar or a dip station — onto user-facing
//  gear. An equipment string this file doesn't know needs no gear, so a new
//  lift is never hidden by mistake.
//

import Foundation
import Observation

// MARK: - Gear

enum GearGroup: String, CaseIterable, Identifiable {
    case freeWeights, benches, machines, smallGear

    var id: String { rawValue }

    var title: String {
        switch self {
        case .freeWeights: String(localized: "Free weights")
        case .benches: String(localized: "Benches & bars")
        case .machines: String(localized: "Machines")
        case .smallGear: String(localized: "Small gear & cardio")
        }
    }
}

/// One thing a user can tick. The raw value names its picture,
/// `equip-<rawValue>` in Assets.xcassets/Equipment, when it has one.
enum GearID: String, CaseIterable, Codable, Identifiable {
    // Free weights
    case dumbbells
    case barbell
    case ezBar = "ez-bar"
    case trapBar = "trap-bar"
    case safetyBar = "safety-bar"
    case kettlebell
    case landmine
    // Benches & bars
    case bench
    case pullUpBar = "pull-up-bar"
    case dipStation = "dip-station"
    case preacher
    case backExtension = "back-extension"
    case dipBelt = "dip-belt"
    // Machines
    case cable
    case smith
    case legPress = "leg-press"
    case hackSquat = "hack-squat"
    case pendulumSquat = "pendulum-squat"
    case legExtension = "leg-extension"
    case legCurl = "leg-curl"
    case latPulldown = "lat-pulldown"
    case rowMachine = "row-machine"
    case chestPress = "chest-press"
    case pecDeck = "pec-deck"
    case shoulderPress = "shoulder-press"
    case hipAbAd = "hip-ab-ad"
    case calfMachine = "calf-machine"
    case gluteMachine = "glute-machine"
    case assisted
    case otherMachines = "other-machines"
    // Small gear & cardio
    case smallGear = "small-gear"
    case conditioning

    var id: String { rawValue }

    var group: GearGroup {
        switch self {
        case .dumbbells, .barbell, .ezBar, .trapBar, .safetyBar, .kettlebell, .landmine: .freeWeights
        case .bench, .pullUpBar, .dipStation, .preacher, .backExtension, .dipBelt: .benches
        case .smallGear, .conditioning: .smallGear
        default: .machines
        }
    }

    var title: String {
        switch self {
        case .dumbbells: String(localized: "Dumbbells")
        case .barbell: String(localized: "Barbell & plates")
        case .ezBar: String(localized: "EZ bar")
        case .trapBar: String(localized: "Trap bar")
        case .safetyBar: String(localized: "Safety squat bar")
        case .kettlebell: String(localized: "Kettlebell")
        case .landmine: String(localized: "Landmine")
        case .bench: String(localized: "Bench")
        case .pullUpBar: String(localized: "Pull-up bar")
        case .dipStation: String(localized: "Dip station")
        case .preacher: String(localized: "Preacher bench")
        case .backExtension: String(localized: "Back extension / GHD")
        case .dipBelt: String(localized: "Dip belt")
        case .cable: String(localized: "Cable station")
        case .smith: String(localized: "Smith machine")
        case .legPress: String(localized: "Leg press")
        case .hackSquat: String(localized: "Hack squat")
        case .pendulumSquat: String(localized: "Pendulum squat")
        case .legExtension: String(localized: "Leg extension")
        case .legCurl: String(localized: "Leg curl")
        case .latPulldown: String(localized: "Lat pulldown machine")
        case .rowMachine: String(localized: "Row machine")
        case .chestPress: String(localized: "Chest press")
        case .pecDeck: String(localized: "Pec deck")
        case .shoulderPress: String(localized: "Shoulder press")
        case .hipAbAd: String(localized: "Hip abduction / adduction")
        case .calfMachine: String(localized: "Calf machine")
        case .gluteMachine: String(localized: "Glute machine")
        case .assisted: String(localized: "Assisted pull-up / dip")
        case .otherMachines: String(localized: "Other machines")
        case .smallGear: String(localized: "Bands & small gear")
        case .conditioning: String(localized: "Sled, rower, box & ropes")
        }
    }

    /// Shown when the item has no rendered picture.
    var symbol: String {
        switch self {
        case .dumbbells: "dumbbell.fill"
        case .barbell, .ezBar, .trapBar, .safetyBar: "figure.strengthtraining.traditional"
        case .kettlebell, .landmine: "figure.strengthtraining.functional"
        case .bench, .preacher, .dipBelt: "figure.strengthtraining.traditional"
        case .pullUpBar, .dipStation, .assisted: "figure.climbing"
        case .backExtension, .gluteMachine: "figure.core.training"
        case .cable, .latPulldown, .rowMachine: "figure.rower"
        case .legPress, .hackSquat, .pendulumSquat, .legExtension, .legCurl, .calfMachine, .hipAbAd:
            "figure.step.training"
        case .smith, .chestPress, .pecDeck, .shoulderPress, .otherMachines: "gearshape.2.fill"
        case .smallGear: "figure.flexibility"
        case .conditioning: "figure.mixed.cardio"
        }
    }

    var imageName: String { "equip-\(rawValue)" }
}

// MARK: - Presets

enum GearPreset: String, CaseIterable, Identifiable {
    case fullGym, smallGym, home, bodyweight

    var id: String { rawValue }

    var title: String {
        switch self {
        case .fullGym: String(localized: "Full gym")
        case .smallGym: String(localized: "Small gym")
        case .home: String(localized: "Home")
        case .bodyweight: String(localized: "Bodyweight only")
        }
    }

    var detail: String {
        switch self {
        case .fullGym: String(localized: "All equipment")
        case .smallGym: String(localized: "Free weights, cables, a few machines")
        case .home: String(localized: "Dumbbells, bench, bands")
        case .bodyweight: String(localized: "No equipment")
        }
    }

    var symbol: String {
        switch self {
        case .fullGym: "building.2.fill"
        case .smallGym: "dumbbell.fill"
        case .home: "house.fill"
        case .bodyweight: "figure.walk"
        }
    }

    var gear: Set<GearID> {
        switch self {
        case .fullGym:
            Set(GearID.allCases)
        case .smallGym:
            [.dumbbells, .barbell, .ezBar, .kettlebell, .bench, .pullUpBar, .dipStation, .cable,
             .smith, .legPress, .legExtension, .legCurl, .latPulldown, .smallGear]
        case .home:
            // A doorway pull-up bar is common at home, so it is in.
            [.dumbbells, .kettlebell, .bench, .pullUpBar, .smallGear]
        case .bodyweight:
            []
        }
    }
}

// MARK: - What each exercise needs

enum EquipmentCatalog {
    /// Gear `exercise` needs; empty when it needs nothing (bodyweight).
    static func requiredGear(for exercise: Exercise) -> Set<GearID> {
        if let cached = cache[exercise.name] { return cached }
        return compute(exercise)
    }

    /// Built once for the whole library, so a filter pass is set work only.
    private static let cache: [String: Set<GearID>] = {
        var map: [String: Set<GearID>] = [:]
        for exercise in SampleData.exercises where map[exercise.name] == nil {
            map[exercise.name] = compute(exercise)
        }
        return map
    }()

    static func compute(_ exercise: Exercise) -> Set<GearID> {
        let name = exercise.name.lowercased()
        func has(_ words: String...) -> Bool { words.contains { name.contains($0) } }

        switch exercise.equipment {
        case "MACHINE":
            let gear = machine(for: name)
            // A Smith press or hip thrust is done on a bench under the bar.
            if gear == .smith, has("bench", "incline", "decline", "hip thrust") { return [.smith, .bench] }
            return [gear]
        case "BELT":
            return [.otherMachines] // belt squat machine
        default:
            break
        }

        var gear: Set<GearID> = []
        switch exercise.equipment {
        case "BARBELL", "PLATE": gear.insert(.barbell)
        case "EZ BAR": gear.insert(.ezBar)
        case "TRAP BAR": gear.insert(.trapBar)
        case "SAFETY BAR": gear.insert(.safetyBar)
        case "DUMBBELL": gear.insert(.dumbbells)
        case "KETTLEBELL": gear.insert(.kettlebell)
        case "LANDMINE": gear.insert(.landmine)
        case "CABLE":
            // A lat pulldown station, or the high pulley of a cable station
            // (`isMet` accepts either).
            gear.insert(has("lat pulldown") ? .latPulldown : .cable)
        case "BENCH": gear.insert(.bench)
        case "DIP BELT": gear.insert(.dipBelt)
        case "BAND", "MEDICINE BALL", "SWISS BALL", "SLIDERS", "AB WHEEL", "TOWEL", "WRIST ROLLER":
            gear.insert(.smallGear)
        case "SLED", "ROWER", "BATTLE ROPE", "PLYO BOX", "JUMP ROPE":
            gear.insert(.conditioning)
        default:
            break // BODYWEIGHT, or a string this file doesn't know
        }

        if has("medicine ball") { gear.insert(.smallGear) }

        // What the lift is done on, read from its name.
        if has("pull-up", "chin-up", "hanging", "toe-to-bar", "inverted row") {
            gear.insert(.pullUpBar)
        }
        if has("chest dip", "captain's chair") {
            gear.insert(.dipStation)
        }
        if has("preacher") {
            gear.insert(.preacher)
        } else if has("bench", "incline", "decline", "hip thrust", "spider", "seal row",
                       "chest-supported", "skull crusher", "larsen", "pullover", "bulgarian",
                       "rear-foot-elevated", "concentration curl", "dumbbell lying")
                    || (has("dumbbell fly") && !has("reverse")) {
            gear.insert(.bench)
        }
        if has("back extension", "hip extension") {
            gear.insert(.backExtension)
        }
        return gear
    }

    /// Whether `owned` covers `gear` for this lift. Some needs have a stand-in:
    /// a cable lat pulldown works on a cable station's high pulley, and a
    /// plate lift (PLATE) on a dumbbell or kettlebell instead of a plate.
    static func isMet(_ gear: GearID, for exercise: Exercise, owned: Set<GearID>) -> Bool {
        if owned.contains(gear) { return true }
        switch (gear, exercise.equipment) {
        case (.latPulldown, "CABLE"): return owned.contains(.cable)
        case (.barbell, "PLATE"): return !owned.isDisjoint(with: [.dumbbells, .kettlebell])
        default: return false
        }
    }

    /// MACHINE has no subtype, so the machine comes from the name. Order
    /// matters: "Smith Machine Calf Raise" is a Smith lift, "Leg Press Calf
    /// Raise" a leg-press one.
    private static func machine(for name: String) -> GearID {
        func has(_ words: String...) -> Bool { words.contains { name.contains($0) } }
        if has("smith") { return .smith }
        if has("pendulum") { return .pendulumSquat }
        if has("hack squat", "v-squat") { return .hackSquat }
        if has("leg press", "single-leg press") { return .legPress }
        if has("leg extension", "single-leg extension") { return .legExtension }
        if has("leg curl", "single-leg curl") { return .legCurl }
        if has("calf", "tibialis") { return .calfMachine }
        if has("abduction", "adduction") { return .hipAbAd }
        if has("hip thrust", "glute press", "glute kickback") { return .gluteMachine }
        if has("assisted dip", "machine pull-up") { return .assisted }
        if has("glute-ham", "reverse hyper") { return .backExtension }
        if has("preacher", "biceps curl", "machine curl") { return .preacher }
        if has("pec deck") { return .pecDeck }
        if has("chest press") { return .chestPress }
        if has("lat pulldown", "pullover") { return .latPulldown }
        if has("row") { return .rowMachine }
        if has("shoulder press", "lateral raise") { return .shoulderPress }
        return .otherMachines
    }
}

// MARK: - The user's gear

/// What the user has, and whether lifts they can't do are dimmed or hidden.
/// Kept on the device only (UserDefaults); never uploaded.
@Observable
final class EquipmentStore {
    static let shared = EquipmentStore()

    enum Mode: String, CaseIterable, Identifiable {
        case dim, hide
        var id: String { rawValue }
        var title: String {
            switch self {
            case .dim: String(localized: "Dim and move to bottom")
            case .hide: String(localized: "Hide")
            }
        }
    }

    private enum Key {
        static let owned = "equipment.owned"
        static let allGear = "equipment.allGear"
        static let mode = "equipment.mode"
        static let hasChosen = "equipment.hasChosen"
    }

    private(set) var owned: Set<GearID>
    var mode: Mode {
        didSet { UserDefaults.standard.set(mode.rawValue, forKey: Key.mode) }
    }
    /// False until the first-open sheet has been answered.
    var hasChosen: Bool {
        didSet { UserDefaults.standard.set(hasChosen, forKey: Key.hasChosen) }
    }

    private init() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: Key.allGear) == nil || defaults.bool(forKey: Key.allGear) {
            owned = Set(GearID.allCases)
        } else if let data = defaults.data(forKey: Key.owned),
                  let raw = try? JSONDecoder().decode([String].self, from: data) {
            owned = Set(raw.compactMap(GearID.init(rawValue:)))
        } else {
            owned = Set(GearID.allCases)
        }
        mode = Mode(rawValue: defaults.string(forKey: Key.mode) ?? "") ?? .dim
        hasChosen = defaults.bool(forKey: Key.hasChosen)
    }

    var hasEverything: Bool { owned.isSuperset(of: GearID.allCases) }

    func setOwned(_ gear: Set<GearID>) {
        owned = gear
        let defaults = UserDefaults.standard
        // Full gym is kept as a flag, so gear added in a later version is on
        // for it too.
        defaults.set(hasEverything, forKey: Key.allGear)
        if let data = try? JSONEncoder().encode(gear.map(\.rawValue).sorted()) {
            defaults.set(data, forKey: Key.owned)
        }
    }

    /// Gear the lift needs that the user doesn't have, in catalog order.
    func missing(for exercise: Exercise) -> [GearID] {
        let need = EquipmentCatalog.requiredGear(for: exercise)
        guard !need.isEmpty else { return [] }
        return GearID.allCases.filter {
            need.contains($0) && !EquipmentCatalog.isMet($0, for: exercise, owned: owned)
        }
    }

    func canDo(_ exercise: Exercise) -> Bool {
        let owned = owned
        return EquipmentCatalog.requiredGear(for: exercise)
            .allSatisfy { EquipmentCatalog.isMet($0, for: exercise, owned: owned) }
    }

    /// The preset that matches the current gear exactly, if any.
    var matchingPreset: GearPreset? {
        GearPreset.allCases.first { $0.gear == owned }
    }
}
