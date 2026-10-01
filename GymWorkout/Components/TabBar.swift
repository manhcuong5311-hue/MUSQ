//
//  TabBar.swift
//  GymWorkout
//
//  The design draws the tab bar per-screen rather than globally: on the tab
//  roots it is chrome sitting on the screen ground, while on Anatomy it is
//  ruled into the bottom of the muscle panel itself. `Style` covers both, and
//  screens pushed on top of a tab (the 3D view, step mode, comparison) simply
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

    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            AdBanner()
            // Every tab root carries the bar, so the running rest rides on it
            // and stays visible whichever tab is open.
            RestTimerBar()
            bar
        }
    }

    private var bar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                let isOn = tab == selection
                Button {
                    selection = tab
                } label: {
                    VStack(spacing: 4) {
                        TabGlyph(
                            color: isOn ? DS.silver : DS.silver.opacity(0.45),
                            symbol: tab.symbol(selected: isOn)
                        )
                        // Each tab root draws its own bar, so the new tab's
                        // icon bounces as its bar appears.
                        .symbolEffect(.bounce, value: isOn && appeared)
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
