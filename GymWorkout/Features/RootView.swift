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
    @State private var tab: AppTab = .train
    /// Workout history, shared by Train, Muscles and Profile and saved on
    /// every change.
    @State private var store = WorkoutStore()
    /// One rest timer for the app, so a rest keeps running across tabs.
    @State private var restTimer = RestTimer()
    /// Remove Ads, and the ads it removes.
    @State private var purchases: Purchases
    @State private var ads: Ads

    init() {
        let purchases = Purchases()
        _purchases = State(initialValue: purchases)
        _ads = State(initialValue: Ads(purchases: purchases))
    }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            // Onboarding runs until its answers are saved, then hands over
            // to the tabs.
            if store.profile == nil {
                OnboardingView()
                    .transition(.opacity)
            } else {
                switch tab {
                case .train:
                    TrainView(tab: $tab)
                case .exercises:
                    ExerciseLibraryView(tab: $tab)
                case .muscles:
                    MuscleProgressView(tab: $tab)
                case .profile:
                    ProfileView(tab: $tab)
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: store.profile == nil)
        .environment(store)
        .environment(restTimer)
        .environment(purchases)
        .environment(ads)
        // Ads wait until onboarding is done, and start again if a
        // subscription lapses.
        .task(id: store.profile == nil || purchases.hasRemovedAds) {
            guard store.profile != nil, !purchases.hasRemovedAds else { return }
            await ads.start()
        }
    }
}

#Preview {
    RootView()
}
