//
//  TabBar.swift
//  GymWorkout
//
//  The design draws the tab bar per-screen rather than globally: on the tab
//  roots it is chrome sitting on the screen ground, while on Anatomy it is
//  ruled into the bottom of the muscle panel itself. `Style` covers both, and
//  screens pushed on top of a tab (the 3D view, step mode) simply
//  don't render one.
//

import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case train = "Train"
    case exercises = "Exercises"
    case muscles = "Muscles"
    case profile = "Profile"

    var id: String { rawValue }

    /// Outline when idle, filled when selected — the same silhouette, so the
    /// bar reads by shape and the selection by weight.
    func symbol(selected: Bool) -> String {
        switch self {
        case .train: return selected ? "dumbbell.fill" : "dumbbell"
        case .exercises: return selected ? "list.bullet.rectangle.portrait.fill" : "list.bullet.rectangle.portrait"
        case .muscles: return "figure.arms.open"
        case .profile: return selected ? "person.crop.circle.fill" : "person.crop.circle"
        }
    }
}

struct TabBarView: View {
    enum Style {
        /// Blurred chrome with its own ground — the tab roots.
        case chrome
        /// Ruled into the surface it sits on — Anatomy's muscle panel.
        case inline
    }

    @Binding var selection: AppTab
    var style: Style = .chrome

    @Environment(\.dsChrome) private var windowChrome
    @State private var appeared = false

    var body: some View {
        if windowChrome.isSidebar {
            // The sidebar does the navigating; the rest and the ad still
            // ride at the foot of the content column, and take no space
            // while neither is showing.
            VStack(spacing: 0) {
                RestTimerBar()
                AdBanner()
            }
        } else {
            VStack(spacing: 0) {
                // Every tab root carries the bar, so the running rest rides on it
                // and stays visible whichever tab is open.
                RestTimerBar()
                // Pinned to the tab bar, below the rest: the rest coming and
                // going never slides the ad under a finger reaching for Skip.
                AdBanner()
                bar
            }
        }
    }

    private var bar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                let isOn = tab == selection
                Button {
                    selection = tab
                } label: {
                    // Each tab root draws its own bar, so the new tab's icon
                    // bounces as its bar appears.
                    TabItemLabel(tab: tab, isOn: isOn, layout: .bar,
                                 bounce: isOn && appeared ? 1 : 0)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.rawValue)
                .accessibilityAddTraits(isOn ? .isSelected : [])
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(alignment: .top) {
            Rectangle()
                .fill(DS.silver.opacity(0.08))
                .frame(height: 1)
        }
        .background {
            if style == .chrome {
                DS.chrome
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .onAppear { appeared = true }
    }
}

/// One tab's glyph and name, as the bottom bar, the sidebar rail or the
/// expanded sidebar draws it. Same symbols and the same silver weights
/// everywhere, so a tab reads the same whichever chrome is showing.
struct TabItemLabel: View {
    enum Placement {
        /// The bottom bar: glyph in a 54×30 capsule over a 10pt name.
        case bar
        /// The sidebar rail: glyph in a 48×40 capsule over a 10pt name.
        case rail
        /// The expanded sidebar: a 46pt row, glyph beside a 15pt name.
        case row
    }

    var tab: AppTab
    var isOn: Bool
    var layout: Placement
    /// The glyph bounces whenever this changes.
    var bounce: Int = 0

    var body: some View {
        switch layout {
        case .bar:
            VStack(spacing: 4) {
                TabGlyph(color: isOn ? DS.silver : DS.silver.opacity(0.45),
                         symbol: tab.symbol(selected: isOn))
                    .symbolEffect(.bounce, value: bounce)
                    .frame(width: 54, height: 30)
                    .background {
                        if isOn {
                            Capsule().fill(DS.silver.opacity(0.09))
                        }
                    }
                Text(tab.rawValue)
                    .font(.ui(10, isOn ? .semibold : .medium))
                    .foregroundStyle(isOn ? DS.silver : DS.silver.opacity(0.45))
            }
        case .rail:
            VStack(spacing: 4) {
                TabGlyph(color: isOn ? DS.silver : DS.silver.opacity(0.45),
                         symbol: tab.symbol(selected: isOn), size: 24)
                    .symbolEffect(.bounce, value: bounce)
                    .frame(width: 48, height: 40)
                    .background {
                        if isOn {
                            Capsule().fill(DS.silver.opacity(0.09))
                        }
                    }
                Text(tab.rawValue)
                    .font(.ui(10, isOn ? .semibold : .medium))
                    .foregroundStyle(isOn ? DS.silver : DS.silver.opacity(0.45))
                    .lineLimit(1)
                    .fixedSize()
            }
        case .row:
            HStack(spacing: 12) {
                TabGlyph(color: isOn ? DS.silver : DS.silver.opacity(0.55),
                         symbol: tab.symbol(selected: isOn), size: 20)
                    .symbolEffect(.bounce, value: bounce)
                Text(tab.rawValue)
                    .font(.ui(15, isOn ? .semibold : .medium))
                    .foregroundStyle(isOn ? DS.silver : DS.silver.opacity(0.55))
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background {
                if isOn {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(DS.silver.opacity(0.09))
                }
            }
        }
    }
}

#Preview("Tab bar · bottom") {
    @Previewable @State var tab: AppTab = .train
    VStack {
        Spacer()
        TabBarView(selection: $tab)
    }
    .environment(RestTimer())
    .environment(Ads(purchases: Purchases()))
    .dsPreview(.phone)
}

#Preview("Tab bar · sidebar") {
    @Previewable @State var tab: AppTab = .train
    VStack {
        Spacer()
        Text("With the sidebar the bar draws only the rest and the ad.")
            .font(.ui(13))
            .foregroundStyle(DS.silver.opacity(0.5))
        Spacer()
        TabBarView(selection: $tab)
    }
    .environment(RestTimer())
    .environment(Ads(purchases: Purchases()))
    .dsPreview(.pad13Portrait940)
}
