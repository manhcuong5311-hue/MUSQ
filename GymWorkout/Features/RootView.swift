//
//  RootView.swift
//  GymWorkout
//
//  Tab host. The design draws the tab bar per-screen rather than globally —
//  on Anatomy it is ruled into the muscle panel itself — so this switches
//  whole screens instead of using a `TabView`, and each root screen owns both
//  its navigation stack and its own copy of the bar.
//

import SwiftUI

struct RootView: View {
    @State private var tab: AppTab = .home
    @State private var libraryFilter: MuscleGroupName = .all

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            switch tab {
            case .home:
                HomeView(tab: $tab, libraryFilter: $libraryFilter)
            case .exercises:
                ExerciseLibraryView(tab: $tab, initialFilter: libraryFilter)
            case .saved:
                UnbuiltTabView(
                    tab: $tab,
                    title: "Saved",
                    caption: "Exercises you bookmark will collect here."
                )
            case .profile:
                UnbuiltTabView(
                    tab: $tab,
                    title: "Profile",
                    caption: "Training history, units and render quality."
                )
            }
        }
    }
}

/// Saved and Profile are named in the tab bar but were never designed — the
/// design doc lists them under "try next". This is a holding screen in the
/// system's own language, not an invented design.
struct UnbuiltTabView: View {
    @Binding var tab: AppTab
    var title: String
    var caption: String

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.ui(28, .semibold))
                    .tracking(-0.7)
                    .foregroundStyle(DS.silver)
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 22)

                Spacer()

                VStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(
                            DS.silver.opacity(0.12),
                            style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                        )
                        .frame(width: 60, height: 60)

                    SectionEyebrow(text: "NOT BUILT YET")

                    Text(caption)
                        .font(.ui(13))
                        .cssLineHeight(13, 1.5)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(DS.silver.opacity(0.42))
                        .frame(maxWidth: 240)
                }
                .frame(maxWidth: .infinity)

                Spacer()
                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            TabBarView(selection: $tab)
        }
    }
}

#Preview {
    RootView()
}
