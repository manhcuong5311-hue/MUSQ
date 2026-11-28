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
    /// The app opens on Today, the first tab (2026-11-21).
    @State private var tab: AppTab = .today
    /// Workout history, shared by Train, Muscles and Profile and saved on
    /// every change.
    @State private var store: WorkoutStore
    /// Water, weigh-ins and their reminders (the Today tab), in a file of
    /// their own.
    @State private var daily: DailyStore
    /// One rest timer for the app, so a rest keeps running across tabs.
    @State private var restTimer: RestTimer
    /// Premium, and the ads it removes.
    @State private var purchases: Purchases
    @State private var ads: Ads
    @State private var paywall = Paywall()
    /// The tab bar's big Scan/Log button (2026-11-27): presented from here,
    /// so it opens the same on every tab.
    @State private var primaryAction = TabPrimaryAction()
    /// Steps, sleep and active energy from Apple Health (phase 2), read again
    /// whenever the app opens or the day changes.
    @State private var health: AppleHealth
    /// Where Progress opens scrolled to when another tab sends the user
    /// there (Today's steps and sleep). One-shot, in memory only.
    @State private var progressFocus = ProgressFocus()
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
        // Steps inside logged sessions are left out of the plan's activity.
        let health = AppleHealth()
        health.sessionWindows = {
            store.sessions.compactMap { session in
                let times = session.exercises.flatMap(\.completedSets).compactMap(\.completedAt)
                guard let first = times.min(), let last = times.max() else { return nil }
                return DateInterval(start: first.addingTimeInterval(-120), end: last)
            }
        }
        let daily = DailyStore()
        daily.profileWaterTarget = DailyStore.waterTarget(for: store.profile)
        _daily = State(initialValue: daily)
        // Nudges plan from the live stores rather than the saved files.
        NudgeScheduler.shared.attach(store: store, daily: daily)
        // Friends posts its activity summaries from the same live stores.
        FriendsActivity.shared.attach(store: store, daily: daily)
        // Walks added by hand count with Health's steps.
        health.manualSteps = { daily.manualStepsByDay }
        _health = State(initialValue: health)
        _restTimer = State(initialValue: restTimer)
        _purchases = State(initialValue: purchases)
        _ads = State(initialValue: ads)
    }

    /// Onboarding saves the profile only once its Premium sheet has closed,
    /// so the consent form and the tracking prompt never stack on it.
    /// What the goal's estimate and Sunday check-in depend on.
    private var goalInputs: GoalInputs {
        GoalInputs(trained: store.trainedDays.count, weightKg: store.profile?.weightKg,
                   bodyFat: store.profile?.measurements?.bodyFatPercent, weekdays: store.profile?.weekdays,
                   daysPerWeek: store.profile?.daysPerWeek, hasGoal: GoalStore.shared.hasGoal)
    }

    /// Moves the goal's anchor to a newly entered body-fat %, then re-lays the
    /// Sunday check-ins (or clears them when there's nothing to check in on).
    private func relayGoal() {
        GoalStore.shared.refresh(profile: store.profile, experience: store.experience, trainedDays: store.trainedDays)
        Task {
            await GoalReminder.relay(profile: store.profile, experience: store.experience, trainedDays: store.trainedDays)
        }
    }

    /// Switches to the tab a tapped notification points at.
    private func followNudge() {
        guard store.profile != nil, let route = NudgeRouter.shared.consume() else { return }
        switch route {
        case .today, .food: tab = .today
        case .train: tab = .train
        case .progress: tab = .muscles
        case .friends: tab = .friends
        }
    }

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
        @Bindable var primaryAction = primaryAction
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
        .environment(daily)
        .environment(health)
        .environment(progressFocus)
        .environment(restTimer)
        .environment(purchases)
        .environment(ads)
        .environment(paywall)
        .environment(primaryAction)
        .environment(FriendsService.shared)
        .environment(FriendsInbox.shared)
        // A friend's nudge fetched on any other tab shows as a banner on top;
        // the Friends tab shows its own.
        .overlay(alignment: .top) { friendNudgeBanner }
        .animation(.spring(duration: 0.35), value: FriendsInbox.shared.banner?.id)
        // The sheet sits outside the `.environment` calls above, so it
        // doesn't inherit them; it gets the window's layout too, so it sizes
        // itself for the window it opens over (always compact on iPhone).
        .sheet(item: $paywall.reason) { reason in
            PremiumView(reason: reason, profile: store.profile)
                .environment(purchases)
                .environment(\.dsLayout, layout)
                .environment(\.dsChrome, chrome)
        }
        // The tab bar's big button: the meal scan (with its sign-in and
        // consent first), or the typed or spoken food log. Outside the
        // `.environment` calls too, so it gets them here.
        .sheet(item: $primaryAction.request, onDismiss: { primaryAction.resume(purchases) }) { request in
            Group {
                switch request {
                case .scan: MealScanSheet()
                case .log: QuickLogSheet(kind: .food)
                case .signIn: AISignInPrompt { primaryAction.resumesScan = true }
                case .consent: AIConsentSheet(feature: .meal) { primaryAction.resumesScan = true }
                }
            }
            .environment(store)
            .environment(daily)
            .environment(health)
            .environment(purchases)
            .environment(ads)
            .environment(paywall)
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
            if phase == .active {
                Task { await purchases.refreshEntitlements() }
                // Water reminders run a day ahead: lay the next ones.
                daily.refreshRemindersSoon()
                relayGoal()
                Task {
                    await health.syncAccess()
                    await health.refresh()
                }
                // Friends: nudges waiting on the server, the board, the feed,
                // and this member's new activity posted.
                if AccountService.shared.isSignedIn {
                    Task { await FriendsService.shared.refresh() }
                }
            } else if phase == .background {
                FriendsActivity.shared.postSoon()
            }
        }
        .onChange(of: daily.stepEntries) { _, _ in health.manualStepsChanged() }
        .onChange(of: tab == .friends && FriendsInbox.shared.banner != nil) { _, onFriendsWithBanner in
            if onFriendsWithBanner { FriendsInbox.shared.clearDelivered() }
        }
        // A tapped notification picks the tab; one tapped before launch
        // is waiting when the view first appears.
        .onChange(of: NudgeRouter.shared.pending) { _, _ in followNudge() }
        .task { followNudge() }
        // The goal's estimate and its Sunday check-in follow a session logged
        // on any tab, a new weight, a body-fat % entered, a schedule change, or
        // the goal made or deleted (reviews: check-in not re-laid, GOAL-9).
        .onChange(of: goalInputs) { _, _ in relayGoal() }
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
            Task { await health.refresh() }
        }
        #if DEBUG
        // `-health.seed`: fills the Simulator's Health with 30 days of
        // sample steps, sleep and a workout for screenshots and checks.
        .task {
            if ProcessInfo.processInfo.arguments.contains("-health.seed") {
                await HealthSeed.run()
                await health.connect()
            }
        }
        #endif
        // The water target follows sex, pregnancy and breastfeeding.
        .onChange(of: store.profile) { _, profile in
            daily.profileWaterTarget = DailyStore.waterTarget(for: profile)
        }
        // Ads start as soon as onboarding is done, and again if a
        // subscription lapses.
        .task(id: adsMayStart) {
            guard adsMayStart else { return }
            await ads.start()
        }
    }

    /// The friend nudge banner over the other tabs: a tap opens Friends,
    /// it goes by itself after a few seconds. On Friends itself the queue
    /// is cleared, since that tab shows the nudge in place.
    @ViewBuilder
    private var friendNudgeBanner: some View {
        let inbox = FriendsInbox.shared
        if store.profile != nil, tab != .friends, let nudge = inbox.banner {
            NudgeBanner(nudge: nudge, onNudgeBack: nil, nudgedBack: false,
                        onDismiss: { inbox.dismissBanner() })
                .contentShape(Rectangle())
                .onTapGesture {
                    inbox.clearDelivered()
                    tab = .friends
                }
                .accessibilityAction(named: Text("Open Friends")) {
                    inbox.clearDelivered()
                    tab = .friends
                }
                .padding(.horizontal, DS.Metric.gutter)
            .padding(.top, 6)
            .frame(maxWidth: 560)
            .id(nudge.id)
            .task(id: nudge.id) {
                try? await Task.sleep(for: .seconds(5))
                if inbox.banner?.id == nudge.id { inbox.dismissBanner() }
            }
        }
    }

    @ViewBuilder
    private var tabSwitch: some View {
        switch tab {
        case .today:
            TodayView(tab: $tab)
        case .train:
            TrainView(tab: $tab)
        case .exercises:
            ExerciseLibraryView(tab: $tab)
        case .muscles:
            MuscleProgressView(tab: $tab)
        case .friends:
            FriendsView(tab: $tab)
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

/// The goal's inputs RootView watches (see `RootView.relayGoal`).
private struct GoalInputs: Equatable {
    var trained: Int
    var weightKg: Double?
    var bodyFat: Double?
    var weekdays: [Int]?
    var daysPerWeek: Int?
    var hasGoal: Bool
}
