//
//  TabBar.swift
//  GymWorkout
//
//  The design draws the tab bar per-screen rather than globally: on Home and
//  Exercises it is chrome sitting on the screen ground, while on Anatomy it is
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

    /// The design ships a placeholder square for every tab. Fill these in to
    /// switch the whole bar over to SF Symbols.
    var symbol: String? { nil }
}

struct TabBarView: View {
    enum Style {
        /// Blurred chrome with its own ground — Home, Exercises.
        case chrome
        /// Ruled into the surface it sits on — Anatomy's muscle panel.
        case inline
    }

    @Binding var selection: AppTab
    var style: Style = .chrome

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                let isOn = tab == selection
                Button {
                    selection = tab
                } label: {
                    VStack(spacing: 5) {
                        TabGlyph(
                            color: isOn ? DS.silver : DS.silver.opacity(0.4),
                            symbol: tab.symbol
                        )
                        Text(tab.rawValue)
                            .font(.ui(10, .medium))
                            .foregroundStyle(isOn ? DS.silver : DS.silver.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 10)
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
    }
}
