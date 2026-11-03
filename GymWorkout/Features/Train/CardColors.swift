//
//  CardColors.swift
//  GymWorkout
//
//  The coloured edges on the Train tab's group cards and the settings
//  behind them: red while a group recovers, yellow once it's done this
//  round, green while it's still due. Which of them show, the colours, and
//  when the round starts over are chosen in Profile › Settings and kept in
//  UserDefaults, so both screens read the same values.
//

import SwiftUI

/// Where a group stands this round, drawn as its card's edge.
enum MuscleCardTone: Hashable, CaseIterable {
    /// Trained and still waiting on recovery.
    case waiting
    /// Trained this round and recovered: it waits for the others to have
    /// their turn.
    case recent
    /// Not trained yet this round, or never.
    case due

    /// The colour when the user hasn't picked one.
    var defaultColor: Color {
        switch self {
        case .waiting: return DS.rhythmWaiting
        case .recent: return DS.rhythmRecent
        case .due: return DS.rhythmDue
        }
    }

    func title(reset: TrainingRound.Reset) -> String {
        switch self {
        case .waiting: return String(localized: "Recovering", comment: "Train card edge: the group is still recovering")
        case .recent:
            return reset == .weekly
                ? String(localized: "Done this week", comment: "Train card edge: trained this week and recovered")
                : String(localized: "Done this round", comment: "Train card edge: trained this round and recovered")
        case .due: return String(localized: "Due", comment: "Train card edge: not trained yet this round, its turn")
        }
    }
}

/// Which edges the cards draw.
enum CardColorMode: String, CaseIterable, Identifiable {
    case all
    case redGreen
    case off

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return String(localized: "All", comment: "Card colors setting: every edge colour shows")
        case .redGreen: return String(localized: "Red & green", comment: "Card colors setting: only the red and green edges")
        case .off: return String(localized: "Off", comment: "Card colors setting: no coloured edges")
        }
    }

    var tones: [MuscleCardTone] {
        switch self {
        case .all: return [.waiting, .recent, .due]
        case .redGreen: return [.waiting, .due]
        case .off: return []
        }
    }
}

/// The card-colour settings. A colour is stored as Display P3 "RRGGBB";
/// empty means the default, which follows Light and Dark Mode where a picked
/// one can't.
struct CardColorPrefs: DynamicProperty {
    @AppStorage("train.cardColors.mode") var mode: CardColorMode = .all
    @AppStorage("train.cardColors.reset") var reset: TrainingRound.Reset = .fullRound
    @AppStorage("train.cardColors.waiting") private var waitingHex = ""
    @AppStorage("train.cardColors.recent") private var recentHex = ""
    @AppStorage("train.cardColors.due") private var dueHex = ""

    func color(for tone: MuscleCardTone) -> Color {
        Color(hexString: hex(tone).wrappedValue) ?? tone.defaultColor
    }

    /// The edge to draw, or nil when the mode leaves the tone out.
    func edge(for tone: MuscleCardTone?) -> Color? {
        guard let tone, mode.tones.contains(tone) else { return nil }
        return color(for: tone)
    }

    /// For a colour picker: reads the colour in use, stores the one picked.
    func binding(for tone: MuscleCardTone) -> Binding<Color> {
        let stored = hex(tone)
        return Binding(get: { color(for: tone) },
                       set: { if let hex = $0.hexString { stored.wrappedValue = hex } })
    }

    var hasCustomColors: Bool { MuscleCardTone.allCases.contains { !hex($0).wrappedValue.isEmpty } }

    func resetColors() {
        for tone in MuscleCardTone.allCases { hex(tone).wrappedValue = "" }
    }

    private func hex(_ tone: MuscleCardTone) -> Binding<String> {
        switch tone {
        case .waiting: return $waitingHex
        case .recent: return $recentHex
        case .due: return $dueHex
        }
    }
}
