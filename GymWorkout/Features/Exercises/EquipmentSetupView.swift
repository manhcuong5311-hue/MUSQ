//
//  EquipmentSetupView.swift
//  GymWorkout
//
//  "What equipment do you have?" — shown the first time the Exercises tab
//  opens, and again from the library's filter menu (My equipment). Big
//  preset cards first, then every item as a picture card to tick. Done sits
//  at the bottom, under the thumb. Nothing leaves the device.
//

import SwiftUI
import UIKit

struct EquipmentSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout

    private let store = EquipmentStore.shared
    @State private var draft: Set<GearID>
    @State private var mode: EquipmentStore.Mode

    init() {
        _draft = State(initialValue: EquipmentStore.shared.owned)
        _mode = State(initialValue: EquipmentStore.shared.mode)
    }

    private var allOn: Bool { draft.isSuperset(of: GearID.allCases) }
    private var preset: GearPreset? { GearPreset.allCases.first { $0.gear == draft } }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    header

                    presetGrid.padding(.top, 20)

                    machinesHeader.padding(.top, 30)

                    ForEach(GearGroup.allCases) { group in
                        groupSection(group).padding(.top, 18)
                    }

                    modePicker.padding(.top, 30)
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.top, 24)
                .padding(.bottom, 24)
                .frame(maxWidth: 760)
                .frame(maxWidth: .infinity)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { doneBar }
        .presentationBackground(DS.ink)
        .presentationDragIndicator(.visible)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What equipment do you have?")
                .font(.ui(26, .semibold))
                .tracking(-0.6)
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
            Text("Lifts you can't do move to the bottom. Change it anytime in Exercises.")
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }

    // MARK: - Presets

    private var presetGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 10)], spacing: 10) {
            ForEach(GearPreset.allCases) { option in
                presetCard(option)
            }
        }
    }

    private func presetCard(_ option: GearPreset) -> some View {
        let isOn = preset == option
        return Button {
            withAnimation(.easeOut(duration: 0.18)) { draft = option.gear }
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: option.symbol)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(isOn ? DS.ink : DS.silver)
                    Spacer()
                    if isOn {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(DS.ink)
                    }
                }
                Text(option.title)
                    .font(.ui(16, .semibold))
                    .foregroundStyle(isOn ? DS.ink : DS.silver)
                Text(option.detail)
                    .font(.ui(12))
                    .foregroundStyle(isOn ? DS.ink.opacity(0.7) : DS.silver.opacity(0.5))
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.leading)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isOn ? DS.silver : DS.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(DS.silver.opacity(isOn ? 0 : 0.08), lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: 18)
        .accessibilityLabel("\(option.title), \(option.detail)")
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }

    // MARK: - Machine by machine

    private var machinesHeader: some View {
        HStack(alignment: .center) {
            SectionEyebrow(text: "OR CHOOSE MACHINE BY MACHINE")
            Spacer(minLength: 8)
            Toggle(isOn: Binding(
                get: { allOn },
                set: { on in withAnimation(.easeOut(duration: 0.18)) { draft = on ? Set(GearID.allCases) : [] } }
            )) {
                Text("All equipment")
                    .font(.ui(13, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.75))
            }
            .toggleStyle(.switch)
            .fixedSize()
            .tint(DS.silver)
        }
    }

    private func groupSection(_ group: GearGroup) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(group.title)
                .font(.ui(15, .semibold))
                .foregroundStyle(DS.silver)
                .accessibilityAddTraits(.isHeader)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: layout.isRegular ? 130 : 100), spacing: 10)],
                      spacing: 10) {
                ForEach(GearID.allCases.filter { $0.group == group }) { item in
                    gearCard(item)
                }
            }
        }
    }

    private func gearCard(_ item: GearID) -> some View {
        let isOn = draft.contains(item)
        return Button {
            withAnimation(.easeOut(duration: 0.15)) {
                if isOn { draft.remove(item) } else { draft.insert(item) }
            }
        } label: {
            VStack(alignment: .leading, spacing: 7) {
                EquipmentPicture(item: item)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(isOn ? DS.silver : DS.silver.opacity(0.35))
                            .background(Circle().fill(DS.glass(0.72)).padding(1))
                            .padding(7)
                    }
                Text(item.title)
                    .font(.ui(12.5, .semibold))
                    .foregroundStyle(DS.silver.opacity(isOn ? 1 : 0.55))
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.leading)
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isOn ? DS.selectionFill : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isOn ? DS.selectionStroke : DS.silver.opacity(0.06), lineWidth: 1)
            )
            .opacity(isOn ? 1 : 0.7)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: 16)
        .accessibilityLabel(item.title)
        .accessibilityAddTraits(isOn ? .isSelected : [])
        .accessibilityHint(isOn ? String(localized: "Double-tap to remove") : String(localized: "Double-tap to add"))
    }

    // MARK: - Dim or hide

    private var modePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "LIFTS YOU CAN'T DO")
            HStack(spacing: 8) {
                ForEach(EquipmentStore.Mode.allCases) { option in
                    QuickChip(title: option.title,
                              symbol: option == .dim ? "circle.lefthalf.filled" : "eye.slash",
                              filled: mode == option) {
                        withAnimation(.easeOut(duration: 0.18)) { mode = option }
                    }
                    .accessibilityAddTraits(mode == option ? .isSelected : [])
                }
            }
        }
    }

    // MARK: - Done

    private var doneBar: some View {
        VStack(spacing: 8) {
            Text(draft.isEmpty
                 ? String(localized: "Bodyweight lifts only")
                 : (allOn ? String(localized: "All equipment")
                          : String(localized: "\(draft.count) items selected")))
                .font(.mono(10, .semibold))
                .trackingEm(0.08, size: 10)
                .foregroundStyle(DS.silver.opacity(0.45))
            WideButton(title: "Done", prominent: true, fontSize: 16, verticalPadding: 16, cornerRadius: 16) {
                store.setOwned(draft)
                store.mode = mode
                store.hasChosen = true
                dismiss()
            }
            .dsCTA()
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(DS.ink.opacity(0.96).ignoresSafeArea(edges: .bottom))
    }
}

// MARK: - Picture

/// An item's rendered picture when the app has one, else its SF Symbol in a
/// tinted tile.
struct EquipmentPicture: View {
    var item: GearID

    var body: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(DS.surfaceDim)
            .overlay {
                if UIImage(named: item.imageName) != nil {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                } else {
                    Image(systemName: item.symbol)
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(DS.silver.opacity(0.55))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .accessibilityHidden(true)
    }
}
