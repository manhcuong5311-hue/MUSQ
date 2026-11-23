//
//  TodayView.swift
//  GymWorkout
//
//  Tab 1, "Today" (2026-11-21, layout A of the all-in-one plan): the day at
//  a glance — the plan's calories and macros from onboarding, today's
//  workout and its energy, water with reminders, and weigh-ins whose 7-day
//  average keeps the plan's numbers current. Phase 2 (2026-11-22) adds Apple
//  Health: steps and last night's sleep, today's active energy beside the
//  target (display only), and a Watch workout's energy for the session.
//  Supplements join in a later phase; the AI coach lives here too.
//  2026-11-22 later: Balance (Train · Eat · Sleep over 7 days) with its one
//  action and its sheet (Ask MUSQ prefills the chat, never sends), a quick
//  log for water, a walk and meals (typed or spoken), water's Undo toast on
//  every layout, hand-added steps and a walking estimate from steps.
//

import Combine
import SwiftUI

struct TodayView: View {
    @Binding var tab: AppTab

    @Environment(WorkoutStore.self) private var store
    @Environment(DailyStore.self) private var daily
    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall
    @Environment(\.dsLayout) private var layout

    @State private var showsWeightLog = false
    @State private var showsWaterSettings = false
    @State private var showsPlan = false
    @State private var editsProfile = false
    @State private var showsDeniedNote = false
    @State private var showsWeightHistory = false
    @State private var showsWeighInTime = false
    @State private var showsReminders = false
    /// The open chat, with the question to put in its field (Balance's
    /// "Ask MUSQ how to improve"); an item, so the sheet gets the question
    /// it was opened with, never a stale one.
    @State private var chat: ChatRequest?
    /// Balance's question for Ask MUSQ, put in the chat's field (never sent
    /// until the user taps Send there).
    @State private var showsBalance = false
    /// From opening Balance's sheet until it has fully closed (its onDismiss),
    /// so nothing tries to present while it's still on screen.
    @State private var balanceSheetUp = false
    /// What to do once Balance's sheet has closed: a sheet can't open while
    /// another is still closing.
    @State private var afterBalance: AfterBalance?
    @State private var showsCheckIn = false
    @State private var showsSleepEstimate = false
    @State private var quickLogRequest: QuickLogRequest?
    /// The glass just added, for a few seconds' Undo on every layout.
    @State private var waterUndo: WaterUndo?
    /// A few seconds' confirmation above the tab bar (Balance's bedtime
    /// reminder being set), on every layout.
    @State private var confirmation: Confirmation?
    /// The Goal page and the goal photo setup, from the goal card or the
    /// new-member invite.
    @State private var goalLauncher = GoalLauncher()
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOver
    /// The layout the user picked in Settings (see `TodayDesign`).
    @AppStorage(TodayDesign.storageKey) private var design: TodayDesign = .coach
    /// Bumped at midnight and whenever the app comes back, so the tab moves
    /// to the new day even if nothing else changed.
    @State private var clock = 0
    @Environment(\.scenePhase) private var scenePhase

    @Environment(AppleHealth.self) private var health
    /// With Apple Health connected, the last 14 days' steps set the daily
    /// activity (see `MeasuredActivity`).
    private var plan: NutritionPlan? {
        store.profile.flatMap { NutritionPlan(profile: $0, measured: health.measuredActivity) }
    }
    /// Progress's section picker: a tap on steps or sleep lands on Overview,
    /// where their trends are.
    @AppStorage("progress.section") private var progressSection: ProgressSection = .overview
    /// And scrolls it to them, once (in memory only).
    @Environment(ProgressFocus.self) private var progressFocus: ProgressFocus?

    var body: some View {
        let _ = clock
        let now = Date()
        let metrics = TodayMetrics(store: store, daily: daily, plan: plan, now: now, health: health)
        // Balance (2026-11-22): worked out on each render, on the device, and
        // only while its card is on Today (Settings › Balance).
        let balance = BalanceSettings.shared.showsOnToday ? currentBalance(now: now) : nil
        NavigationStack {
            ZStack {
                DS.ink.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    Group {
                        switch design {
                        case .classic:
                            currentPage(metrics, now: now)
                        case .rings:
                            TodaySummaryLayout(metrics: metrics, plan: plan, actions: actions, balance: balance)
                        case .dial:
                            TodayDialLayout(metrics: metrics, plan: plan, actions: actions, balance: balance)
                        case .coach:
                            TodayCoachLayout(metrics: metrics, plan: plan, actions: actions, balance: balance)
                        }
                    }
                    .dsReadable(720)
                    .dsGutter()
                    .padding(.top, design == .classic ? layout.value(22, 28) : layout.value(12, 20))
                    .padding(.bottom, 24)
                }
                // Water's Undo, for a few seconds after any glass, whichever
                // layout (or Balance's button) added it; just above the tab
                // bar, under a confirmation when one shows too. The empty
                // space above them lets touches through.
                VStack(spacing: 8) {
                    Spacer(minLength: 0)
                    if let confirmation {
                        TodayConfirmToast(symbol: confirmation.symbol, tint: confirmation.tint, text: confirmation.text)
                            .padding(.horizontal, 16)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    if let undo = waterUndo {
                        WaterUndoToast(ml: undo.ml, onUndo: undoLastAdd)
                            .padding(.horizontal, 16)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.bottom, 12)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            .statusBarScrim()
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(DS.silver)
        // "Set training days" on the Goal page opens the same profile editor.
        .goalLauncher(goalLauncher, onEditSchedule: { editsProfile = true })
        .sheet(isPresented: $showsWeightLog) {
            WeightLogSheet(unit: store.unit,
                           startKg: daily.latestWeight?.kg ?? store.profile?.weightKg ?? 70) { kg in
                logWeight(kg)
            }
        }
        .sheet(isPresented: $showsWaterSettings) {
            WaterSettingsSheet(recommended: DailyStore.waterTarget(for: store.profile))
                .environment(daily)
        }
        .sheet(isPresented: $showsPlan) {
            if let plan, let profile = store.profile {
                PlanSheet(plan: plan, profile: profile, experience: store.experience, unit: store.unit,
                          builtInPresetGroups: PresetProvider.trainableGroups.filter { store.savedLevels(for: $0).isEmpty })
            }
        }
        // The same editor Profile opens: a full-screen cover on iPhone.
        .dsCover(isPresented: $editsProfile) {
            OnboardingView(isEditing: true, onClose: { editsProfile = false })
                .environment(store)
                .environment(purchases)
                .environment(health)
                .dsLayoutRoot()
        }
        .sheet(isPresented: $showsWeightHistory) {
            WeightHistorySheet(unit: store.unit) { syncPlanWeight() }
                .environment(daily)
        }
        .sheet(isPresented: $showsWeighInTime) {
            WeighInTimeSheet()
                .environment(daily)
        }
        .sheet(item: $chat) { request in
            CoachChatView(initialQuestion: request.question)
                .environment(store)
                .environment(purchases)
        }
        .sheet(isPresented: $showsBalance, onDismiss: runAfterBalance) {
            // Worked out again here, so the sheet follows what changes under it.
            BalanceSheet(balance: currentBalance(now: Date()),
                         goal: plan?.effectiveGoal ?? store.profile?.goal,
                         onAction: { balanceSheetAction($0) },
                         onAskAI: balanceAskAI)
                .environment(store)
                .environment(daily)
                .environment(health)
                .environment(purchases)
        }
        .sheet(isPresented: $showsCheckIn) {
            EatCheckInSheet()
                .environment(daily)
                .environment(store)
                .environment(health)
        }
        .sheet(isPresented: $showsSleepEstimate) {
            SleepEstimateSheet()
                .environment(daily)
        }
        .sheet(item: $quickLogRequest) { request in
            QuickLogSheet(kind: request.kind)
                .environment(daily)
                .environment(store)
                .environment(health)
        }
        .sheet(isPresented: $showsReminders) {
            RemindersSheet(recommended: DailyStore.waterTarget(for: store.profile))
                .environment(daily)
        }
        .alert(String(localized: "Notifications are off"), isPresented: $showsDeniedNote) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Turn on notifications for MUSQ in iOS Settings to get reminders.")
        }
        // Posted on whatever thread noticed the new day: the state change and
        // the store's save run on the main thread.
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged).receive(on: RunLoop.main)) { _ in
            clock += 1
            syncPlanWeight()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { clock += 1; syncPlanWeight() }
        }
        .onAppear { syncPlanWeight() }
        // A workout in Apple Health (a Watch workout, say) that covers today's
        // session: looked up again after each Health read, since the Watch
        // saves a workout only once it ends.
        .task(id: SessionEnergyKey(window: metrics.sessionWindow, refreshed: health.lastRefresh)) {
            guard let window = metrics.sessionWindow else { return }
            await health.loadSessionEnergy(for: window)
        }
        // The Undo stays about 5 s (longer with VoiceOver, to reach it). A
        // newer glass restarts the wait; a cancelled wait must not clear it.
        .task(id: waterUndo) {
            guard waterUndo != nil else { return }
            do { try await Task.sleep(for: .seconds(voiceOver ? 12 : 5)) } catch { return }
            withAnimation(.easeOut(duration: 0.25)) { waterUndo = nil }
        }
        // A confirmation has nothing to reach (VoiceOver hears it at once):
        // a few seconds, restarted by a newer one.
        .task(id: confirmation) {
            guard confirmation != nil else { return }
            do { try await Task.sleep(for: .seconds(4)) } catch { return }
            withAnimation(.easeOut(duration: 0.25)) { confirmation = nil }
        }
    }

    /// What the session-energy lookup reruns on.
    private struct SessionEnergyKey: Equatable {
        var window: DateInterval?
        var refreshed: Date?
    }

    /// A glass that can still be taken back: that entry, not just the day's last.
    private struct WaterUndo: Equatable {
        let entryID: UUID
        let ml: Int
    }

    /// What the confirmation toast says; a new one each time, so the same
    /// words twice still restart its few seconds.
    private struct Confirmation: Equatable {
        let symbol: String
        let tint: Color
        let text: String
        let id = UUID()
    }

    /// Which quick log to open; a new one each time, so the same kind twice
    /// in a row still opens.
    private struct QuickLogRequest: Identifiable {
        let kind: QuickLogKind
        let id = UUID()
    }

    private enum AfterBalance {
        case action(BalanceAction)
        case ask(String)
        /// Notifications are off: the alert can't show over the sheet.
        case deniedNote
    }

    /// What the candidate layouts can ask for; the sheets stay here.
    private var actions: TodayActions {
        TodayActions(addWater: { addWater($0) },
                     undoWater: {
                         withAnimation(.easeOut(duration: 0.2)) {
                             daily.undoWater()
                             // The toast's glass may be the one just removed.
                             waterUndo = nil
                         }
                     },
                     logWeight: { showsWeightLog = true },
                     weightHistory: { showsWeightHistory = true },
                     waterSettings: { showsWaterSettings = true },
                     weighInTime: { showsWeighInTime = true },
                     reminders: { showsReminders = true },
                     setWaterReminder: { setWaterReminder($0) },
                     setWeighInReminder: { setWeighInReminder($0) },
                     showPlan: { showsPlan = true },
                     editProfile: { editsProfile = true },
                     openTrain: { tab = .train },
                     startDay: { groups in
                         // What Train's "Add to Today" does, for each group
                         // the poster shows, then on to Train to begin.
                         for group in groups { store.addToToday(group) }
                         tab = .train
                     },
                     askCoach: {
                         if purchases.isPremium { chat = ChatRequest(question: nil) } else { paywall.show(.coach) }
                     },
                     openProgress: {
                         progressSection = .overview
                         progressFocus?.target = .health
                         tab = .muscles
                     },
                     quickLog: { quickLogRequest = QuickLogRequest(kind: $0) },
                     balanceAction: { perform($0) },
                     openBalance: {
                         balanceSheetUp = true
                         showsBalance = true
                     },
                     openGoal: { goalLauncher.open(profile: store.profile, purchases: purchases, paywall: paywall) })
    }

    // MARK: - Balance

    /// The rolling last 7 days of Train, Eat and Sleep.
    private func currentBalance(now: Date) -> Balance {
        BalanceScore.current(BalanceBuilder.inputs(store: store, daily: daily, health: health, plan: plan, now: now))
    }

    /// Balance's one action, from the card or (once closed) its sheet.
    private func perform(_ action: BalanceAction) {
        switch action.kind {
        case .startWorkout:
            tab = .train
        case .checkIn:
            showsCheckIn = true
        case .sleepEstimate:
            showsSleepEstimate = true
        case .addWater(let ml):
            addWater(ml)
        case .bedtime(hour: let hour, minute: let minute):
            Task {
                if await daily.requestNotifications() {
                    // A reminder already on keeps the user's own time (Settings
                    // › Balance changes it); Balance then shows it instead of
                    // this button, so this only meets a stale tap.
                    let wasOn = daily.bedtimeReminder.isOn
                    if !wasOn {
                        daily.bedtimeReminder = BedtimeReminder(isOn: true, hour: hour, minute: minute)
                    }
                    confirmBedtime(alreadyOn: wasOn)
                } else if balanceSheetUp {
                    // The alert waits for Balance's sheet to close.
                    afterBalance = .deniedNote
                    showsBalance = false
                } else {
                    showsDeniedNote = true
                }
            }
        case .connectHealth:
            Task { await health.connect() }
        case .none:
            break
        }
    }

    /// Says the wind-down reminder is on, at its time in the locale's style:
    /// a toast on Today and a VoiceOver announcement. Over Balance's sheet
    /// the toast would hide under it, so the sheet's own line (the reminder
    /// in place of the button) shows it there, and VoiceOver hears it.
    private func confirmBedtime(alreadyOn: Bool) {
        let reminder = daily.bedtimeReminder
        let time = Self.time(reminder.hour, reminder.minute)
        let text = alreadyOn
            ? String(localized: "Wind-down reminder already on at \(time)",
                     comment: "Confirmation when Balance's Set reminder finds the bedtime reminder already on; the user's time is kept: Wind-down reminder already on at 9:30 PM")
            : String(localized: "Wind-down reminder set for \(time)",
                     comment: "Confirmation after Balance's Set reminder: Wind-down reminder set for 10:15 PM")
        if !balanceSheetUp {
            withAnimation(.easeOut(duration: 0.2)) {
                confirmation = Confirmation(symbol: "bell.fill", tint: HealthTone.sleep, text: text)
            }
        }
        AccessibilityNotification.Announcement(text).post()
    }

    /// An action from Balance's sheet. Water, the bedtime reminder and
    /// connecting Health happen with the sheet still up, so it shows the new
    /// numbers; starting a workout or a check-in waits for the sheet to
    /// close (the sheet may already have closed itself, and then they run
    /// at once).
    private func balanceSheetAction(_ action: BalanceAction) {
        switch action.kind {
        case .addWater, .bedtime, .connectHealth, .none:
            perform(action)
        case .startWorkout, .checkIn, .sleepEstimate:
            afterBalanceSheet(.action(action))
        }
    }

    /// Balance's Ask MUSQ, only where the AI features are live (nil hides
    /// it). Once the sheet has closed, the question goes into the chat's field.
    private var balanceAskAI: ((String) -> Void)? {
        guard AIService.isLive else { return nil }
        return { question in afterBalanceSheet(.ask(question)) }
    }

    /// Runs `next` now if Balance's sheet is gone, else once it has closed.
    private func afterBalanceSheet(_ next: AfterBalance) {
        if balanceSheetUp {
            afterBalance = next
            showsBalance = false
        } else {
            run(next)
        }
    }

    /// Balance's sheet has closed: what it left to do.
    private func runAfterBalance() {
        balanceSheetUp = false
        guard let next = afterBalance else { return }
        afterBalance = nil
        run(next)
    }

    private func run(_ next: AfterBalance) {
        switch next {
        case .action(let action):
            perform(action)
        case .ask(let question):
            // In the chat's field: the user reads it there and taps Send;
            // nothing goes before.
            if purchases.isPremium {
                chat = ChatRequest(question: question)
            } else {
                paywall.show(.coach)
            }
        case .deniedNote:
            showsDeniedNote = true
        }
    }

    /// The shipped page (rings, then a card per habit).
    @ViewBuilder
    private func currentPage(_ metrics: TodayMetrics, now: Date) -> some View {
        VStack(alignment: .leading, spacing: layout.value(12, 16)) {
            header(now)
                .padding(.bottom, 4)
            if store.profile != nil && plan == nil {
                finishPlanCard
            }
            if let reasons = store.profile?.health?.clearanceReasons, !reasons.isEmpty {
                NoticeCard(title: String(localized: "Check with your doctor before you start"),
                           lines: reasons.map(\.text))
            }
            if plan?.limits.contains(.targetReached) == true {
                targetReachedCard
            }
            TodayHero(metrics: metrics)
            workoutCard(metrics, now: now)
            waterCard(metrics)
            weightCard(metrics)
            if let plan {
                planCard(plan, metrics: metrics)
            }
            Text("Estimates for general guidance, not medical advice.")
                .font(.ui(layout.value(11.5, 12.5)))
                .foregroundStyle(DS.silver.opacity(0.35))
                .padding(.top, 4)
        }
    }

    // MARK: - Header

    private func header(_ now: Date) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            SectionEyebrow(text: now.formatted(.dateTime.weekday(.wide).day().month(.wide)).uppercased())
            Text("Today", comment: "The Today tab's large title")
                .font(.ui(layout.text(.largeTitle), .semibold))
                .tracking(layout.largeTitleTracking)
                .foregroundStyle(DS.silver)
                .accessibilityAddTraits(.isHeader)
        }
    }

    /// Profiles from before the plan onboarding have no age, activity or
    /// health answers: the plan can't be worked out until they're given.
    private var finishPlanCard: some View {
        TodayCard {
            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text("Finish your plan")
                        .font(.ui(layout.value(16, 17), .semibold))
                } icon: {
                    Image(systemName: "sparkles")
                }
                .foregroundStyle(DS.silver)
                Text("A few new questions — age, daily activity, goal and health — turn your answers into calories, macros and safer exercise picks.")
                    .font(.ui(layout.value(13, 14)))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                PillButton(title: String(localized: "Answer the new questions"), prominent: true) {
                    editsProfile = true
                }
            }
        }
    }

    // MARK: - Workout

    private func workoutCard(_ metrics: TodayMetrics, now: Date) -> some View {
        TodayCard {
            VStack(alignment: .leading, spacing: 10) {
                CardTitle(symbol: "dumbbell", title: String(localized: "Workout", comment: "Today card title"),
                          trailing: metrics.setsPlanned > 0
                            ? String(localized: "\(metrics.setsDone) of \(metrics.setsPlanned) sets",
                                     comment: "Sets done today: 12 of 30 sets")
                            : nil)
                if metrics.setsPlanned > 0 {
                    ProgressBar(value: Double(metrics.setsDone) / Double(max(metrics.setsPlanned, 1)),
                                color: TodayPalette.workout)
                    Text(metrics.groupsToday.map(\.title).joined(separator: " · "))
                        .font(.ui(layout.value(13.5, 14.5), .semibold))
                        .foregroundStyle(DS.silver)
                    // Apple Health's figure for the session replaces the
                    // estimate, with that workout's own length; the two are
                    // never shown together or added.
                    if let kcal = metrics.workoutKcal, let minutes = metrics.workoutMinutes {
                        Group {
                            if metrics.sessionKcalMeasured != nil {
                                Text("\(minutes) min · \(kcal) kcal above rest, from Apple Health.",
                                     comment: "A workout's length and energy from a workout in Apple Health (a Watch workout): 48 min · 210 kcal above rest")
                            } else {
                                Text("About \(minutes) min · \(kcal) kcal above rest (estimate).",
                                     comment: "A workout's energy: About 45 min · 140 kcal above rest")
                            }
                        }
                        .font(.ui(layout.value(12.5, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                    }
                } else if metrics.isTrainingDay {
                    Text(metrics.recommendedDay.map {
                        String(localized: "Recommended: \($0.name) — \($0.groups.map(\.title).joined(separator: " · "))",
                               comment: "The suggested split day and its groups")
                    } ?? String(localized: "A training day on your schedule."))
                        .font(.ui(layout.value(13.5, 14.5), .semibold))
                        .foregroundStyle(DS.silver)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Train picks the most recovered muscles.", comment: "Train is the tab")
                        .font(.ui(layout.value(12.5, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.55))
                } else {
                    Text("Rest day on your schedule. A walk still counts, and you can train any day.")
                        .font(.ui(layout.value(13.5, 14.5)))
                        .foregroundStyle(DS.silver.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }
                PillButton(title: metrics.setsPlanned > 0 ? String(localized: "Open today's workout")
                                                          : String(localized: "Go to Train")) {
                    tab = .train
                }
            }
        }
    }

    // MARK: - Water

    private func waterCard(_ metrics: TodayMetrics) -> some View {
        TodayCard {
            VStack(alignment: .leading, spacing: 10) {
                CardTitle(symbol: "drop", title: String(localized: "Water", comment: "Today card title"),
                          trailing: "\(DailyStore.litres(metrics.waterMl)) / \(DailyStore.litres(metrics.waterTarget))")
                ProgressBar(value: Double(metrics.waterMl) / Double(max(metrics.waterTarget, 1)),
                            color: TodayPalette.water)
                HStack(spacing: 8) {
                    ForEach(Array(metrics.waterPresets.prefix(2).enumerated()), id: \.offset) { index, ml in
                        PillButton(title: String(localized: "+\(ml) ml", comment: "Adds a glass of water: +250 ml"),
                                   prominent: index == 0) { addWater(ml) }
                    }
                    if metrics.waterMl > 0 {
                        PillButton(title: String(localized: "Undo")) { actions.undoWater() }
                    }
                    Spacer(minLength: 0)
                }
                if limitsFluids {
                    Text("With a heart or kidney condition, ask your doctor how much to drink: some need to limit fluids.")
                        .font(.ui(layout.value(12.5, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Hairline(opacity: 0.08)
                ReminderRow(title: String(localized: "Reminders"),
                            detail: reminderDetail(isOn: daily.waterReminder.isOn, schedule: waterReminderText),
                            isOn: Binding(get: { daily.waterReminder.isOn },
                                          set: { setWaterReminder($0) }),
                            editLabel: String(localized: "Water reminder settings"),
                            onEdit: { showsWaterSettings = true })
            }
        }
    }

    /// A declared heart or kidney condition: fluid needs are the doctor's.
    private var limitsFluids: Bool {
        guard let health = store.profile?.health else { return false }
        return health.has(.heartDisease) || health.has(.kidneyDisease)
    }

    /// The schedule, "Off", or that iOS has notifications off for MUSQ.
    private func reminderDetail(isOn: Bool, schedule: String) -> String {
        guard isOn else { return String(localized: "Off", comment: "A reminder row's detail: the reminder is off") }
        return daily.notificationsDenied
            ? String(localized: "Notifications are off in iOS Settings", comment: "A reminder that is on but can't fire")
            : schedule
    }

    /// "Every 2 h, 8:00–20:00".
    private var waterReminderText: String {
        let reminder = daily.waterReminder
        return String(localized: "Every \(reminder.everyHours) h, \(Self.hour(reminder.startHour))–\(Self.hour(reminder.endHour))",
                      comment: "Water reminder window: Every 2 h, 8:00–20:00")
    }

    /// Adds a glass and offers its Undo for a few seconds, on every layout.
    private func addWater(_ ml: Int) {
        withAnimation(.easeOut(duration: 0.25)) { daily.addWater(ml) }
        guard let entry = daily.entries(on: Date()).last, entry.ml == ml else { return }
        withAnimation(.easeOut(duration: 0.2)) { waterUndo = WaterUndo(entryID: entry.id, ml: ml) }
        // From Balance's sheet the toast is hidden under it: no pointing there.
        AccessibilityNotification.Announcement(balanceSheetUp
            ? String(localized: "Added \(DailyStore.litres(ml)).", comment: "VoiceOver after logging water")
            : String(localized: "Added \(DailyStore.litres(ml)). Undo is at the bottom of the screen.",
                     comment: "VoiceOver after logging water")).post()
    }

    /// Takes back exactly the glass the toast names.
    private func undoLastAdd() {
        guard let undo = waterUndo else { return }
        withAnimation(.easeOut(duration: 0.2)) {
            daily.deleteWater(id: undo.entryID)
            waterUndo = nil
        }
    }

    private func setWaterReminder(_ isOn: Bool) {
        guard isOn else { daily.waterReminder.isOn = false; return }
        Task {
            if await daily.requestNotifications() {
                daily.waterReminder.isOn = true
            } else {
                showsDeniedNote = true
            }
        }
    }

    // MARK: - Weight

    private func weightCard(_ metrics: TodayMetrics) -> some View {
        let unit = store.unit
        return TodayCard {
            VStack(alignment: .leading, spacing: 10) {
                CardTitle(symbol: "scalemass", title: String(localized: "Weight", comment: "Today card title"),
                          trailing: (metrics.trend ?? daily.latestWeight?.kg).map { unit.bodyWeight($0) })
                if let latest = daily.latestWeight {
                    Text(weightSummary(latest))
                        .font(.ui(layout.value(12.5, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                    if daily.weights.count >= 2 {
                        WeightSparkline(entries: daily.weights.suffix(30).map { ($0.date, unit.fromKilograms($0.kg)) })
                            .frame(height: 44)
                    }
                } else {
                    Text("Weigh in a few mornings a week. Your plan follows the 7-day average, so one salty dinner doesn't move your calories.")
                        .font(.ui(layout.value(12.5, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
                HStack(spacing: 8) {
                    // One weigh-in a day: logging again replaces today's.
                    PillButton(title: metrics.weighedIn ? String(localized: "Change today's") : String(localized: "Log weight"),
                               prominent: !metrics.weighedIn) {
                        showsWeightLog = true
                    }
                    if !daily.weights.isEmpty {
                        PillButton(title: String(localized: "History")) { showsWeightHistory = true }
                    }
                    Spacer(minLength: 0)
                }
                Hairline(opacity: 0.08)
                ReminderRow(title: String(localized: "Morning weigh-in"),
                            detail: reminderDetail(
                                isOn: daily.weighInReminder.isOn,
                                schedule: String(localized: "Daily at \(Self.time(daily.weighInReminder.hour, daily.weighInReminder.minute))",
                                                 comment: "Weigh-in reminder: Daily at 7:00")),
                            isOn: Binding(get: { daily.weighInReminder.isOn },
                                          set: { setWeighInReminder($0) }),
                            editLabel: String(localized: "Weigh-in reminder time"),
                            onEdit: { showsWeighInTime = true })
            }
        }
    }

    /// "7-day average. Last 75.0 kg, 2 days ago. −0.8 kg in 30 days." — or,
    /// with no weigh-in this week, just the last one and when.
    private func weightSummary(_ latest: WeightEntry) -> String {
        let unit = store.unit
        let when = Calendar.current.isDateInToday(latest.date)
            ? String(localized: "today", comment: "When the last weigh-in was: today")
            : latest.date.formatted(.relative(presentation: .named))
        guard daily.trendWeight() != nil else {
            return String(localized: "Last weigh-in \(unit.bodyWeight(latest.kg)), \(when). Weigh in this week to update your plan.",
                          comment: "Weight card when no weigh-in is recent: the last one and when")
        }
        var text = String(localized: "7-day average. Last \(unit.bodyWeight(latest.kg)), \(when).",
                          comment: "Weight card: the last weigh-in and when")
        if let change = daily.trendChange(days: 30) {
            // No sign on a change that rounds to nothing.
            let shown = (unit.fromKilograms(abs(change)) * 10).rounded() / 10
            let sign = shown == 0 ? "" : change < 0 ? "−" : "+"
            text += " " + String(localized: "\(sign)\(unit.bodyWeight(abs(change))) in 30 days.",
                                 comment: "Trend change: −0.8 kg in 30 days")
        }
        return text
    }

    private func setWeighInReminder(_ isOn: Bool) {
        guard isOn else { daily.weighInReminder.isOn = false; return }
        Task {
            if await daily.requestNotifications() {
                daily.weighInReminder.isOn = true
            } else {
                showsDeniedNote = true
            }
        }
    }

    /// Logs a weigh-in and moves the plan to the new 7-day average.
    private func logWeight(_ kg: Double) {
        daily.logWeight(kg)
        syncPlanWeight()
    }

    /// The plan's weight follows the 7-day average: after a weigh-in is
    /// logged or deleted, and as the window moves on to a new day. With no
    /// weigh-in this week it stays as it was.
    private func syncPlanWeight() {
        guard let trend = daily.trendWeight(), let profile = store.profile else { return }
        let average = (trend * 10).rounded() / 10
        if profile.weightKg != average { store.profile?.weightKg = average }
    }

    /// The weigh-ins reached the target: the plan eats what you burn until
    /// a new goal is set.
    private var targetReachedCard: some View {
        TodayCard {
            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text("You reached your target")
                        .font(.ui(layout.value(16, 17), .semibold))
                } icon: {
                    Image(systemName: "flag.checkered")
                }
                .foregroundStyle(DS.silver)
                Text("Your plan now eats what you burn. Set a new goal when you're ready.")
                    .font(.ui(layout.value(13, 14)))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                PillButton(title: String(localized: "Set a new goal"), prominent: true) { editsProfile = true }
            }
        }
    }

    // MARK: - Plan

    private func planCard(_ plan: NutritionPlan, metrics: TodayMetrics) -> some View {
        TodayCard {
            VStack(alignment: .leading, spacing: 10) {
                CardTitle(symbol: "flame", title: String(localized: "Your plan", comment: "Today card title"),
                          trailing: String(localized: "\(Int(plan.calories).formatted()) kcal",
                                           comment: "The day's calorie target: 2,020 kcal"))
                MacroLine(protein: Int(plan.protein), fat: Int(plan.fat), carbs: Int(plan.carbs))
                if let goal = goalLine(plan) {
                    Text(goal)
                        .font(.ui(layout.value(12.5, 13.5)))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
                if metrics.showsEnergyNote {
                    TodayEnergyNote(metrics: metrics)
                }
                PillButton(title: String(localized: "How it's calculated")) { showsPlan = true }
            }
        }
    }

    /// "Lose 4 kg · around 16 Jan 2027".
    private func goalLine(_ plan: NutritionPlan) -> String? {
        Self.goalLine(plan, unit: store.unit)
    }

    static func goalLine(_ plan: NutritionPlan, unit: WeightUnit) -> String? {
        guard let target = plan.targetWeightKg, let date = plan.targetDate() else { return nil }
        let day = date.formatted(.dateTime.day().month(.abbreviated).year())
        let amount = Int(abs(unit.fromKilograms(target) - unit.fromKilograms(plan.weightKg)).rounded())
        guard amount > 0 else {
            return String(localized: "Almost at your target · around \(day)", comment: "Plan goal within one unit of the target")
        }
        // "4 kg", the unit inside its localized string (a whole amount reads
        // without decimals).
        let change = unit.bodyWeight(unit.toKilograms(Double(amount)))
        return plan.effectiveGoal == .loseWeight
            ? String(localized: "Lose \(change) · around \(day)", comment: "Plan goal: Lose 4 kg · around 16 Jan 2027")
            : String(localized: "Gain \(change) · around \(day)", comment: "Plan goal: Gain 4 kg · around 16 Jan 2027")
    }

    // MARK: - Formatting

    /// "8:00" in the locale's style.
    static func hour(_ hour: Int) -> String {
        time(hour, 0)
    }

    static func time(_ hour: Int, _ minute: Int) -> String {
        var parts = DateComponents()
        parts.hour = hour
        parts.minute = minute
        let date = Calendar.current.date(from: parts) ?? Date()
        return date.formatted(date: .omitted, time: .shortened)
    }
}

// MARK: - Today's numbers

/// What the Today tab shows, worked out once per render.
struct TodayMetrics {
    /// Where today's workout stands.
    enum SessionState: Equatable {
        /// Nothing planned yet; the planner has groups ready.
        case recommended
        case planned
        case inProgress
        case done
        /// A rest day on the user's schedule, nothing planned.
        case rest
        /// A training day with nothing recovered yet.
        case recovering

        /// Nothing to start right now: the session block can shrink.
        var isQuiet: Bool { self == .done || self == .rest || self == .recovering }
    }

    /// A day of this week, for the week strip.
    struct WeekDay: Identifiable {
        let date: Date
        let letter: String
        let trained: Bool
        let scheduled: Bool
        let isToday: Bool
        let isPast: Bool
        var id: Date { date }
    }

    var now: Date
    var name: String?
    var calories: Int?
    var protein: Int?
    var fat: Int?
    var carbs: Int?
    var waterMl: Int
    var waterTarget: Int
    /// The water buttons, in ml (`DailyStore.waterPresets`, the user's to change).
    var waterPresets: [Int]
    /// What an even pace across the reminder window would have reached by
    /// now; only while water reminders are on (the window is the user's
    /// own), and never with a heart or kidney condition (the amount is the
    /// doctor's).
    var waterPaceMl: Int?
    var setsDone: Int
    var setsPlanned: Int
    /// Sets still to do, leaving out exercises finished early with
    /// Complete Exercise.
    var setsLeft: Int
    var groupsToday: [MuscleGroup]
    var trainingKcal: Int?
    var trainingMinutes: Int?
    var weighedIn: Bool
    var trend: Double?
    var isTrainingDay: Bool
    var recommendedDay: ProgramAdvisor.SplitDay?

    var state: SessionState
    var moment: Greeting.Moment
    /// The groups the session block lights: today's, else the suggestion.
    var posterGroups: [MuscleGroup]
    /// Today's exercises, else exactly what adding the suggestion would add.
    var posterExercises: [WorkoutExercise]
    /// The session block's heading: "Push day", the groups when they match
    /// no split day, or "Today's workout".
    var posterTitle: String
    /// The split's day inside a sentence ("Push day"), when the poster is one.
    var posterDayName: String?
    /// Every poster group is fully recovered, not just almost.
    var posterAllReady: Bool
    /// The next exercise with sets left today.
    var nextExercise: String?
    /// The rotation group the planner can suggest soonest on a day with
    /// nothing recovered, and in about how many hours.
    var soonestReady: (group: MuscleGroup, hours: Int)?
    /// Days since the poster's groups were last trained, when they were all
    /// trained on the same day.
    var daysSinceTrained: Int?
    var week: [WeekDay]
    var weekDone: Int
    var weekPlanned: Int
    var waterReminderOn: Bool
    var weighInReminderOn: Bool
    var weighInReminderHour: Int
    var weighInReminderMinute: Int
    /// The morning weigh-in is due now: its reminder is on, nobody has
    /// weighed in, and it's within an hour before to four hours after the
    /// reminder's time.
    var weighInDue: Bool
    /// The weigh-in counts toward the day: only while its reminder is on,
    /// and not once its window has passed without one (never a miss).
    var weighInCounts: Bool
    /// A declared heart or kidney condition: fluid needs are the doctor's.
    var limitsFluids: Bool
    /// Water counts toward the day, unless the amount is the doctor's (a
    /// heart or kidney condition) and the user hasn't set a target of their own.
    var waterCounts: Bool
    /// The calorie floor leaves no deficit: what the user burns is already
    /// under it, so a cut needs a doctor's or dietitian's guidance.
    var belowFloor: Bool
    /// A profile from before the plan questions: no plan until they're answered.
    var needsPlan: Bool
    var clearanceReasons: [String]
    var targetReached: Bool

    // The goal (2026-11-23): the goal photo, where the member stands
    // against it, and whether one can be made yet (the new-member invite).
    var goal: GoalProgress?
    var goalPhoto: UIImage?
    var offersGoal: Bool

    // Apple Health (phase 2, 2026-11-22). Shown on this phone only: none of
    // it goes to the AI coach or the ads.

    /// A day's steps, or the asleep minutes of the night that ended that day.
    struct HealthDay: Identifiable {
        /// Start of the calendar day (for sleep, the day you woke up).
        let day: Date
        /// Nil where Health has nothing.
        let value: Int?
        var id: Date { day }
    }

    /// `.unavailable` hides every Health piece; `.notAsked` shows the
    /// invitation instead.
    var healthAccess: AppleHealth.Access
    /// The first read since launch is in, so a Health still loading never
    /// reads as "no data".
    var healthLoaded: Bool
    /// Nil without any steps in the last 30 days; 0 on a day that hasn't
    /// counted any yet. Health's steps plus the ones added by hand
    /// (`AppleHealth.stepsTodayTotal`); without Health, those alone.
    var stepsToday: Int?
    /// Steps added by hand today (a walk without the phone or a Watch):
    /// MUSQ's own log, never written to Apple Health.
    var manualStepsToday: Int
    /// Apple Health's own steps today, without the hand-added ones, so
    /// "No data from Apple Health" still shows when Health sends nothing.
    var healthStepsToday: Int?
    /// About what today's steps cost (`WalkSuggestion.walkingKcal`, from
    /// height and weight), only when Apple Health has no active energy.
    /// Display only, like the active energy: never added to the target.
    var walkingKcalEstimate: Int?
    var distanceTodayKm: Double?
    var stepsGoal: Int
    /// The last seven days, oldest first, today last.
    var stepsWeek: [HealthDay]
    /// Asleep minutes of the night you woke from today.
    var lastNightMinutes: Int?
    /// Any night in the last 30: without one (no Watch, no sleep tracking)
    /// sleep stays off the page rather than reading "no data" every day.
    var hasSleep: Bool
    var sleepGoalMinutes: Int
    /// The last seven nights by the day you woke, oldest first, last night last.
    var sleepWeek: [HealthDay]
    /// Today's active energy. Display only: the plan already counts daily
    /// activity (the steps or the onboarding answer), so it is never added
    /// to the target.
    var activeKcalToday: Int?
    /// Today's session from two minutes before its first completed set to
    /// its last, for matching a workout in Apple Health.
    var sessionWindow: DateInterval?
    /// Active energy of a workout in Apple Health (a Watch workout, say)
    /// that covers today's session.
    var sessionKcalMeasured: Int?
    /// That workout's own length, shown with its energy in place of MUSQ's
    /// estimated minutes.
    var sessionMinutesMeasured: Int?

    /// `health`: Apple Health's numbers; nil leaves every Health piece off.
    init(store: WorkoutStore, daily: DailyStore, plan: NutritionPlan?, now: Date, health appleHealth: AppleHealth? = nil) {
        let calendar = Calendar.current
        let health = store.profile?.health
        self.now = now
        name = store.profile?.name
        calories = plan.map { Int($0.calories) }
        protein = plan.map { Int($0.protein) }
        fat = plan.map { Int($0.fat) }
        carbs = plan.map { Int($0.carbs) }
        limitsFluids = health.map { $0.has(.heartDisease) || $0.has(.kidneyDisease) } ?? false
        waterCounts = !limitsFluids || daily.waterTargetOverride != nil
        belowFloor = plan?.limits.contains { if case .belowFloor = $0 { return true } else { return false } } ?? false
        needsPlan = store.profile != nil && plan == nil
        let goals = GoalStore.shared
        // Not while the goal is paused (pregnancy, after birth, underweight):
        // a "fitter you" isn't the picture to show then (review F1).
        if AIService.isLive, goals.hasGoal,
           let progress = goals.progress(profile: store.profile, experience: store.experience,
                                         trainedDays: store.trainedDays, now: now),
           progress.course != .paused {
            goal = progress
            goalPhoto = goals.photo
        } else {
            goal = nil
            goalPhoto = nil
        }
        offersGoal = !goals.hasGoal && GoalPhotoCard.canCreate(for: store.profile)
        clearanceReasons = health?.clearanceReasons.map(\.text) ?? []
        targetReached = plan?.limits.contains(.targetReached) == true

        waterMl = daily.waterDrunk(on: now)
        // From the profile directly, so a new profile shows its own target
        // on the first render.
        waterTarget = daily.waterTargetOverride ?? DailyStore.waterTarget(for: store.profile)
        let presets = daily.waterPresets.filter { $0 > 0 }
        waterPresets = presets.isEmpty ? DailyStore.defaultWaterPresets : presets
        waterReminderOn = daily.waterReminder.isOn
        weighInReminderOn = daily.weighInReminder.isOn
        let minutesNow = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
        if daily.waterReminder.isOn && !limitsFluids {
            let reminder = daily.waterReminder
            let share = (Double(minutesNow) / 60 - Double(reminder.startHour))
                / Double(max(1, reminder.endHour - reminder.startHour))
            waterPaceMl = Int(Double(waterTarget) * min(1, max(0, share)))
        }
        weighedIn = daily.weighedIn(on: now)
        let weighIn = daily.weighInReminder
        weighInReminderHour = weighIn.hour
        weighInReminderMinute = weighIn.minute
        let reminderMinutes = weighIn.hour * 60 + weighIn.minute
        weighInDue = weighIn.isOn && !weighedIn
            && minutesNow >= reminderMinutes - 60 && minutesNow < reminderMinutes + 240
        weighInCounts = weighIn.isOn && (weighedIn || minutesNow < reminderMinutes + 240)
        trend = daily.trendWeight(at: now)

        let session = store.session(on: now)
        let sets = session?.exercises.flatMap(\.sets) ?? []
        setsDone = sets.filter(\.isCompleted).count
        setsPlanned = sets.count
        let open = session?.exercises.filter { !$0.isCompleted } ?? []
        setsLeft = open.reduce(0) { $0 + max(0, $1.sets.count - $1.completedSets.count) }
        nextExercise = open.first { $0.completedSets.count < $0.sets.count }?.exerciseName
        groupsToday = session?.groups ?? []
        let energy = session.flatMap { TrainingEnergy.estimate($0, weightKg: store.profile?.weightKg ?? 70) }
        trainingKcal = energy?.kcal
        trainingMinutes = energy?.minutes
        let setTimes = sets.filter(\.isCompleted).compactMap(\.completedAt).sorted()
        if let first = setTimes.first, let last = setTimes.last {
            sessionWindow = DateInterval(start: first.addingTimeInterval(-120), end: last)
        }
        let weekday = calendar.component(.weekday, from: now)
        isTrainingDay = store.profile?.weekdays?.contains(weekday) ?? true

        // The suggestion, named the way Train names it: the split day that
        // shares the most groups.
        let records = store.recoveryRecords(at: now)
        let rotation = ProgramAdvisor.rotation(for: store.profile)
        let suggested = TrainingPlanner(records: records, now: now, rotation: rotation).recommended(planned: groupsToday)
        let days = ProgramAdvisor.days(for: store.profile)
        func splitDay(_ groups: [MuscleGroup]) -> ProgramAdvisor.SplitDay? {
            guard !groups.isEmpty else { return nil }
            return days.max { $0.groups.filter(groups.contains).count < $1.groups.filter(groups.contains).count }
        }
        recommendedDay = splitDay(suggested).map { ProgramAdvisor.SplitDay(name: $0.name, groups: suggested) }

        if let session, !session.exercises.isEmpty {
            state = session.completedAt != nil && session.hasCompletedSets ? .done
                : session.hasCompletedSets ? .inProgress : .planned
            posterGroups = session.groups
            posterExercises = session.exercises
        } else {
            posterGroups = suggested
            posterExercises = suggested.flatMap { group in
                store.preview(group, level: store.level(for: group, on: now) ?? store.defaultLevel(for: group))
            }
            state = !isTrainingDay ? .rest : suggested.isEmpty ? .recovering : .recommended
        }
        if let day = splitDay(posterGroups), Set(posterGroups).isSubset(of: Set(day.groups)) {
            posterTitle = Self.dayTitle(day.name)
            posterDayName = Self.dayName(day.name)
        } else if posterGroups.isEmpty || posterGroups.count > 2 {
            posterTitle = String(localized: "Today's workout")
        } else {
            posterTitle = posterGroups.map(\.title).formatted(.list(type: .and))
        }
        if state == .rest { posterTitle = String(localized: "Rest day"); posterDayName = nil }
        if state == .recovering { posterTitle = String(localized: "Recovery day"); posterDayName = nil }
        posterAllReady = posterGroups.allSatisfy { records[$0].map { $0.status == .ready } ?? true }

        // The planner suggests a group again once it is only almost
        // recovered, so the wait is until then, among the split's own groups.
        let splitGroups = Set(rotation.joined())
        let almost = store.recoverySettings.almostReadyFraction
        soonestReady = records.values
            .filter { splitGroups.contains($0.muscle) && $0.status == .recovering }
            .map { ($0.muscle, $0.hoursRemaining - almost * $0.recoveryTargetHours) }
            .min { $0.1 < $1.1 }
            .map { ($0.0, max(1, Int($0.1.rounded(.up)))) }
        // Only training that counted for the group (helping on another
        // group's day isn't training it), and only when one day covers all.
        let counted = posterGroups.map { records[$0]?.lastCountedAt }
        if !counted.isEmpty, counted.allSatisfy({ $0 != nil }) {
            let trainedOn = Set(counted.compactMap { $0.map { calendar.startOfDay(for: $0) } })
            if trainedOn.count == 1, let day = trainedOn.first {
                daysSinceTrained = calendar.dateComponents([.day], from: day, to: calendar.startOfDay(for: now)).day
            }
        }
        moment = Greeting.moment(sessions: store.sessions, today: calendar.startOfDay(for: now), calendar: calendar)

        // This week, in the locale's order.
        let trained = store.trainedDays
        let scheduled = Set(store.profile?.weekdays ?? [])
        let start = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? calendar.startOfDay(for: now)
        let today = calendar.startOfDay(for: now)
        week = (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: start) else { return nil }
            let day = calendar.component(.weekday, from: date)
            return WeekDay(date: date, letter: calendar.veryShortStandaloneWeekdaySymbols[day - 1],
                           trained: trained.contains { calendar.isDate($0, inSameDayAs: date) },
                           scheduled: scheduled.contains(day),
                           isToday: calendar.isDate(date, inSameDayAs: today),
                           isPast: date < today)
        }
        weekDone = week.filter(\.trained).count
        weekPlanned = store.profile?.weekdays?.count ?? store.profile?.daysPerWeek ?? 0

        // Apple Health: the last seven days of steps and nights of sleep.
        healthAccess = appleHealth?.access ?? .unavailable
        healthLoaded = appleHealth?.lastRefresh != nil
        stepsGoal = appleHealth?.stepsGoal ?? 8_000
        sleepGoalMinutes = appleHealth?.sleepGoalMinutes ?? 480
        let lastSeven: [Date] = (0..<7).reversed().compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
        // Steps added by hand count with Health's, and show without it.
        let manual = daily.manualSteps(on: now)
        manualStepsToday = manual
        if let appleHealth, appleHealth.access == .asked {
            var steps: [Date: Int] = [:]
            for day in appleHealth.allDailySteps { steps[calendar.startOfDay(for: day.day)] = Int(day.value.rounded()) }
            var asleep: [Date: Int] = [:]
            for night in appleHealth.nights { asleep[calendar.startOfDay(for: night.day)] = night.asleepMinutes }
            healthStepsToday = appleHealth.stepsToday ?? (appleHealth.dailySteps.isEmpty ? nil : 0)
            stepsToday = appleHealth.stepsTodayTotal ?? (steps.isEmpty ? nil : 0)
            distanceTodayKm = appleHealth.distanceTodayKm.flatMap { $0 >= 0.05 ? $0 : nil }
            stepsWeek = lastSeven.map { HealthDay(day: $0, value: steps[$0]) }
            lastNightMinutes = appleHealth.lastNight?.asleepMinutes
            hasSleep = !appleHealth.nights.isEmpty
            sleepWeek = lastSeven.map { HealthDay(day: $0, value: asleep[$0]) }
            activeKcalToday = appleHealth.activeKcalToday.map { Int($0.rounded()) }.flatMap { $0 > 0 ? $0 : nil }
            let window = sessionWindow
            sessionKcalMeasured = window.flatMap { appleHealth.sessionKcal(for: $0) }.map { Int($0.rounded()) }
            sessionMinutesMeasured = window.flatMap { appleHealth.sessionMinutes(for: $0) }
        } else {
            // Without Health, the week's hand-added steps only.
            if manual > 0 {
                let byDay = daily.manualStepsByDay
                stepsToday = manual
                stepsWeek = lastSeven.map { day in HealthDay(day: day, value: byDay[day].map { Int($0.rounded()) }) }
            } else {
                stepsWeek = []
            }
            hasSleep = false
            sleepWeek = []
        }
        // A rough walking figure only where Health has no active energy.
        if activeKcalToday == nil, let steps = stepsToday, steps > 0, let profile = store.profile {
            let kcal = WalkSuggestion.walkingKcal(steps: steps, heightCm: profile.heightCm, weightKg: profile.weightKg)
            walkingKcalEstimate = kcal > 0 ? kcal : nil
        }
    }

    /// "Push day", "Leg day": a split's day inside a sentence, as Train's
    /// greeting says it.
    static func dayName(_ split: String) -> String {
        let name = split.hasPrefix("Legs") ? "Leg\(split.dropFirst(4))" : split
        return String(localized: "\(name) day", comment: "A split's day inside a sentence: “Push day”, “Leg A day”")
    }

    /// "Push day" as a heading, apart from the in-sentence form so each
    /// language can capitalise it.
    static func dayTitle(_ split: String) -> String {
        let name = split.hasPrefix("Legs") ? "Leg\(split.dropFirst(4))" : split
        return String(localized: "today.splitDay.title", defaultValue: "\(name) day",
                      comment: "A split's day as a heading on Today: “Push day”, “Leg A day”")
    }

    /// Water, the workout and the weigh-in as done or not, for tallies.
    var waterReached: Bool { waterMl >= waterTarget }
    var workoutDone: Bool { state == .done || (setsPlanned > 0 && setsLeft == 0) }
    /// Every planned set or exercise is in, but the workout isn't completed.
    var allSetsIn: Bool { state == .inProgress && setsLeft == 0 }
    /// The workout counts toward the day: planned sets, or a training day
    /// with something recovered to train.
    var workoutCounts: Bool { setsPlanned > 0 || (isTrainingDay && state != .recovering) }
    /// The week's goal for "2 of 4": never less than what's been done.
    var weekGoal: Int { max(weekPlanned, weekDone) }

    /// Water, workout and weigh-in, 0…1 each, for the hero.
    var waterProgress: Double { min(1, Double(waterMl) / Double(max(waterTarget, 1))) }
    var workoutProgress: Double {
        workoutDone ? 1 : setsPlanned > 0 ? min(1, Double(setsDone) / Double(setsPlanned)) : 0
    }
    var weighInProgress: Double { weighedIn ? 1 : 0 }

    /// The workout's energy above rest: Apple Health's when a workout there
    /// covers today's session (see `sessionKcalMeasured`), else the estimate.
    /// Never both, never added together.
    var workoutKcal: Int? { sessionKcalMeasured ?? trainingKcal }
    /// The length shown with `workoutKcal`: the matched workout's own with
    /// Apple Health's energy, MUSQ's estimate with the estimate's.
    var workoutMinutes: Int? { sessionKcalMeasured != nil ? sessionMinutesMeasured : trainingMinutes }

    // MARK: Apple Health

    /// Connected and read at least once: the steps and sleep pieces show.
    var showsHealth: Bool { healthAccess == .asked && healthLoaded }
    /// Health's steps once read, or steps added by hand today (with or
    /// without Health).
    var showsSteps: Bool { (showsHealth && stepsToday != nil) || manualStepsToday > 0 }
    /// Every step today was added by hand: Health isn't connected (or not
    /// read yet), or it sent none today. The steps pieces then say so and
    /// open the walk log, where those walks are listed and can be deleted,
    /// rather than Progress's Health trends.
    var stepsAllManual: Bool {
        manualStepsToday > 0 && (!showsHealth || (healthStepsToday ?? 0) == 0)
    }
    var showsSleep: Bool { showsHealth && hasSleep }
    /// Connected and read, but nothing came back: access may be off in the
    /// Health app (HealthKit never says), so the page says where to look.
    /// Today's active energy alone is something (it shows by the plan);
    /// steps added by hand aren't Health's.
    var healthEmpty: Bool { showsHealth && healthStepsToday == nil && !hasSleep && activeKcalToday == nil }
    /// Today's active energy while Health is connected, for the plan's area.
    var shownActiveKcal: Int? { showsHealth ? activeKcalToday : nil }
    /// The walking estimate from today's steps, where no active energy shows.
    var shownWalkingKcal: Int? { shownActiveKcal == nil && showsSteps ? walkingKcalEstimate : nil }
    /// Active energy or the walking estimate goes beside the calorie target.
    var showsEnergyNote: Bool { shownActiveKcal != nil || shownWalkingKcal != nil }

    var stepsProgress: Double { min(1, Double(stepsToday ?? 0) / Double(max(stepsGoal, 1))) }
    var stepsReached: Bool { (stepsToday ?? 0) >= stepsGoal }
    var sleepProgress: Double { min(1, Double(lastNightMinutes ?? 0) / Double(max(sleepGoalMinutes, 1))) }
    /// An hour either side of the sleep goal is the band (7-9 h for 8 h).
    static let sleepBandMinutes = 60
    /// Last night reached the band (or went past it).
    var sleepReached: Bool {
        guard let minutes = lastNightMinutes else { return false }
        return minutes >= sleepGoalMinutes - Self.sleepBandMinutes
    }
    /// Steps today greater than zero, for the coach's "a walk still counts".
    var stepsSoFar: Int? {
        guard showsSteps, let steps = stepsToday, steps > 0 else { return nil }
        return steps
    }
}

/// A chat to open, with the question for its field.
private struct ChatRequest: Identifiable {
    let id = UUID()
    let question: String?
}
