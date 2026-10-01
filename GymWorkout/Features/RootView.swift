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
    @State private var store: WorkoutStore
    /// One rest timer for the app, so a rest keeps running across tabs.
    @State private var restTimer: RestTimer
    /// Premium, and the ads it removes.
    @State private var purchases: Purchases
    @State private var ads: Ads
    @State private var paywall = Paywall()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        let store = WorkoutStore()
        let restTimer = RestTimer()
        let purchases = Purchases()
        let ads = Ads(purchases: purchases)
        // Read at the moment an ad is offered, so the workout just completed
        // already counts.
        ads.completedWorkouts = { store.completedWorkoutCount }
        // Mid-workout: a rest is counting down, or today has sets logged and
        // isn't finished yet. Closing an exercise then is no break.
        ads.workoutInProgress = {
            if restTimer.isRunning { return true }
            // Six hours back too, so a workout that runs past midnight still
            // counts as the one in progress.
            return [Date(), Date().addingTimeInterval(-6 * 3600)].contains { time in
                guard let session = store.session(on: time) else { return false }
                return session.hasCompletedSets && session.completedAt == nil
            }
        }
        _store = State(initialValue: store)
        _restTimer = State(initialValue: restTimer)
        _purchases = State(initialValue: purchases)
        _ads = State(initialValue: ads)
    }

    /// Onboarding saves the profile only once its Premium sheet has closed,
    /// so the consent form and the tracking prompt never stack on it.
    private var adsMayStart: Bool {
        store.profile != nil && !purchases.isPremium
    }

    var body: some View {
        @Bindable var paywall = paywall
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
        .environment(paywall)
        // The sheet sits outside the `.environment` calls above, so it
        // doesn't inherit them.
        .sheet(item: $paywall.reason) { reason in
            PremiumView(reason: reason)
                .environment(purchases)
        }
        // Asked on every launch and every return to the app, not only when
        // ads start: a lapsed subscription has to be noticed even by someone
        // who never sees ads. Prices load right after, so a paywall opens
        // with them.
        .task {
            await purchases.refreshEntitlements()
            await purchases.loadProducts()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { Task { await purchases.refreshEntitlements() } }
        }
        // Ads start as soon as onboarding is done, and again if a
        // subscription lapses.
        .task(id: adsMayStart) {
            guard adsMayStart else { return }
            await ads.start()
        }
    }
}

#Preview {
    RootView()
}
