//
//  RootView.swift
//  GymWorkout
//
//  Tab host. The design draws the tab bar per-screen rather than globally —
//  on Anatomy it is ruled into the muscle panel itself — so this switches
//  whole screens instead of using a `TabView`, and each root screen owns both
//  its navigation stack and its own copy of the bar.
//
//  On iPad it also resolves the window's `DSLayout` and chrome: a regular-
//  width window puts the tabs in `AppSidebar` beside the content column, and
//  the roots' own bars shrink to just the rest timer and the ad. iPhone takes
//  the original path untouched.
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
    @Environment(\.horizontalSizeClass) private var sizeClass
    /// The window, safe areas included; iPad only, nil until measured.
    @State private var windowSize: CGSize?
    /// The user's sidebar choice; nil follows the window's width.
    @SceneStorage("sidebar.expanded") private var prefersExpanded: Bool?

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

    /// The bottom bar wherever a sidebar doesn't fit or doesn't belong
    /// (onboarding stays full-bleed). Otherwise the rail, or the expanded
    /// card from 1300pt by default — never below 1000, where it would leave
    /// too little column.
    private var chrome: DSChrome {
        guard DS.isPad, store.profile != nil, sizeClass == .regular,
              let width = windowSize?.width, width >= DS.Layout.regularWindowMin else {
            return .bottomBar
        }
        let expanded = (prefersExpanded ?? (width >= 1300)) && width >= 1000
        return .sidebar(expanded ? .expanded : .rail)
    }

    private var layout: DSLayout {
        guard DS.isPad, let windowSize else { return .compact }
        return .window(windowSize: windowSize, chrome: chrome, sizeClass: sizeClass)
    }

    var body: some View {
        @Bindable var paywall = paywall
        Group {
            if !DS.isPad {
                ZStack {
                    DS.ink.ignoresSafeArea()

                    // Onboarding runs until its answers are saved, then hands over
                    // to the tabs.
                    if store.profile == nil {
                        OnboardingView()
                            .transition(.opacity)
                    } else {
                        tabSwitch
                    }
                }
            } else {
                padRoot
            }
        }
        .animation(.easeInOut(duration: 0.35), value: store.profile == nil)
        .environment(\.dsLayout, layout)
        .environment(\.dsChrome, chrome)
        .environment(store)
        .environment(restTimer)
        .environment(purchases)
        .environment(ads)
        .environment(paywall)
        // The sheet sits outside the `.environment` calls above, so it
        // doesn't inherit them; it gets the window's layout too, so it sizes
        // itself for the window it opens over (always compact on iPhone).
        .sheet(item: $paywall.reason) { reason in
            PremiumView(reason: reason)
                .environment(purchases)
                .environment(\.dsLayout, layout)
                .environment(\.dsChrome, chrome)
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

    @ViewBuilder
    private var tabSwitch: some View {
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

    /// The iPad host. Nothing but the ground is drawn until the window has
    /// been measured, so no screen is built for the wrong layout and then
    /// rebuilt. The tab content keeps one structural place in the HStack,
    /// so the sidebar coming and going never rebuilds it.
    private var padRoot: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            if windowSize != nil {
                if store.profile == nil {
                    OnboardingView()
                        .transition(.opacity)
                } else {
                    HStack(spacing: 0) {
                        if case .sidebar(let style) = chrome {
                            AppSidebar(selection: $tab, style: style, onToggle: toggleSidebar,
                                       canExpand: (windowSize?.width ?? 0) >= 1000)
                                .frame(width: chrome.width)
                                .transition(.move(edge: .leading).combined(with: .opacity))
                        }
                        Group { tabSwitch }
                            .transition(.opacity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .animation(.easeOut(duration: 0.18), value: tab)
                    .animation(.easeOut(duration: 0.25), value: chrome)
                }
            }
        }
        .onGeometryChange(for: CGSize.self) { geo in
            CGSize(width: geo.size.width + geo.safeAreaInsets.leading + geo.safeAreaInsets.trailing,
                   height: geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom)
        } action: { windowSize = $0 }
    }

    private func toggleSidebar() {
        prefersExpanded = chrome != .sidebar(.expanded)
    }
}

#Preview {
    RootView()
}
