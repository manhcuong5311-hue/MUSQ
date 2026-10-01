//
//  PresetMenu.swift
//  GymWorkout
//
//  The ⋯ on a muscle group's card and on a planned group's row: the user's
//  Preset 1 to 3 for the group, then Basic and Advanced. Picking one opens
//  the group on it. Empty slots are listed too, so it's clear there are
//  three to fill from the group's screen. Without Premium an empty Preset 2
//  or 3 is locked and opens the paywall; a filled one (saved before a
//  subscription lapsed) is still picked as usual. Groups the presets don't
//  cover (Calves, say) get no Basic or Advanced.
//

import SwiftUI

struct PresetMenu: View {
    var group: MuscleGroup
    /// The preset the day's plan follows, ticked in the menu. Nil when the
    /// group isn't planned.
    var current: PresetLevel? = nil
    var onPick: (PresetLevel) -> Void

    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall

    var body: some View {
        Menu {
            Section("Your presets") {
                ForEach(PresetLevel.saved, id: \.self) { level in
                    if let items = store.customPreset(for: group, level) {
                        Button { onPick(level) } label: {
                            Label(level.name, systemImage: level == current ? "checkmark" : "bookmark")
                            Text(summary(items))
                        }
                    } else if !purchases.isPremium && (level.slot ?? 0) > Premium.freePresets {
                        Button { paywall.show(.preset) } label: {
                            Label(level.name, systemImage: "lock.fill")
                            Text("Premium")
                        }
                    } else {
                        Button {} label: {
                            Text(level.name)
                            Text("Empty")
                        }
                        .disabled(true)
                    }
                }
            }
            let builtIn = [PresetLevel.basic, .advanced].filter { PresetProvider.preset(for: group, level: $0) != nil }
            if !builtIn.isEmpty {
                Section("Built in") {
                    ForEach(builtIn, id: \.self) { level in
                        Button { onPick(level) } label: {
                            Label(level.name, systemImage: level == current ? "checkmark" : "list.bullet")
                            Text(level == .basic ? "Machines and cables" : "Free-weight compounds")
                        }
                    }
                }
            }
            if store.savedLevels(for: group).isEmpty {
                Section {
                    Text("Open \(group.title), then Save as Preset")
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.75))
                .frame(width: 28, height: 28)
                .background(Circle().fill(DS.silver.opacity(0.08)))
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .menuOrder(.fixed)
        .accessibilityLabel("\(group.title) presets")
    }

    /// "4 exercises · Barbell Bench Press, Cable Fly, …", cut short by the
    /// menu.
    private func summary(_ items: [PresetItem]) -> String {
        "\(items.count) \(items.count == 1 ? "exercise" : "exercises") · "
            + items.map(\.exerciseName).joined(separator: ", ")
    }
}
