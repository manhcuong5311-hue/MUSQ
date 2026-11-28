//
//  LiveActivityManager.swift
//  GymWorkout
//
//  Dynamic Island, Lock Screen and widgets (2026-11-28, owner: "làm hết").
//  The app side of MUSQWidgets: it starts, updates and ends the two Live
//  Activities and writes the Today snapshot the widgets read.
//
//  - Workout: up once today's session has a set done (or `beginWorkout()`),
//    updated on every set, rest start/end and exercise change, ended with
//    its final state on Complete Workout. Stale after 30 idle minutes, ended
//    3 h after the first set. A workout the user swiped away stays away for
//    that session.
//  - Today (opt-in, Profile › Preferences): water, kcal, meals, the next
//    training. Started when the app is active, ended at the day's end (the
//    system ends it after 8 h anyway), never beside a running workout: the
//    workout ends it and Today comes back afterwards.
//
//  No hooks in the stores: the manager watches them with Observation
//  (`withObservationTracking`) and coalesces changes to at most one push a
//  second. Buttons on the activities run in the app (LiveActivityHandler)
//  and push their result straight away through `syncNow()`.
//
//  DEBUG: `-liveactivity.demo workout|today` starts a sample activity on
//  launch; `-widget.sample` writes the sample snapshot for the widgets;
//  `-island.style bold|glass|minimal` (GymWorkoutApp) picks the look.
//

import ActivityKit
import Foundation
import Observation
import UIKit
import WidgetKit

// MARK: - Settings (app only)

enum LiveActivitySettings {
    /// Profile › Preferences "Today on Lock Screen & Dynamic Island" (off by default).
    static let todayKey = "liveActivity.today.enabled"
    /// Today's one-time suggestion card was closed or acted on.
    static let suggestionDismissedKey = "liveActivity.today.suggestionDismissed"

    static var todayEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: todayKey) }
        set { UserDefaults.standard.set(newValue, forKey: todayKey) }
    }

    /// Live Activities are on for MUSQ (Settings › MUSQ › Live Activities).
    static var areActivitiesEnabled: Bool { ActivityAuthorizationInfo().areActivitiesEnabled }

    /// Live Activities are an iPhone thing (the Lock Screen and the island).
    static var isSupportedDevice: Bool { UIDevice.current.userInterfaceIdiom == .phone }
}

// MARK: - Manager

@Observable
final class LiveActivityManager {
    static let shared = LiveActivityManager()

    @ObservationIgnored private weak var store: WorkoutStore?
    @ObservationIgnored private weak var daily: DailyStore?
    @ObservationIgnored private weak var restTimer: RestTimer?
    @ObservationIgnored private weak var health: AppleHealth?

    /// Coalescing: one sync pending at a time, at most one a second.
    @ObservationIgnored private var syncScheduled = false
    @ObservationIgnored private var lastSync = Date.distantPast
    /// Syncs run one after another, so requests and ends never interleave.
    @ObservationIgnored private var chain: Task<Void, Never>?

    /// Last content pushed, by activity id: identical updates are skipped.
    @ObservationIgnored private var pushedWorkout: [String: WorkoutActivityAttributes.ContentState] = [:]
    @ObservationIgnored private var pushedToday: [String: TodayActivityAttributes.ContentState] = [:]
    /// When the workout's content last changed (staleness counts from it).
    @ObservationIgnored private var lastWorkoutChange = Date()
    /// Activities this app ended, so a later `.dismissed` isn't read as
    /// the user swiping them away.
    @ObservationIgnored private var endedByApp: Set<String> = []
    @ObservationIgnored private var watched: Set<String> = []
    /// The Start action: the session's day and when it was tapped (a
    /// workout begun before any set is done).
    @ObservationIgnored private var manualStart: (day: Date, at: Date)?

    #if DEBUG
    @ObservationIgnored private var demo: String?
    @ObservationIgnored private var widgetSample = false
    #endif

    private static let closedWorkoutKey = "liveActivity.workout.closedDay"
    private static let closedTodayKey = "liveActivity.today.closedDay"
    private static let staleAfter: TimeInterval = 30 * 60
    private static let workoutMaxAge: TimeInterval = 3 * 3600
    /// The finished workout stays on the Lock Screen this long.
    private static let finishedLinger: TimeInterval = 10 * 60

    private let calendar = Calendar.current

    // MARK: Wiring

    /// RootView, once its stores exist. Starts watching them.
    func attach(store: WorkoutStore, daily: DailyStore, restTimer: RestTimer, health: AppleHealth?) {
        self.store = store
        self.daily = daily
        self.restTimer = restTimer
        self.health = health
        #if DEBUG
        let defaults = UserDefaults.standard
        demo = defaults.string(forKey: "liveactivity.demo")
        widgetSample = ProcessInfo.processInfo.arguments.contains("-widget.sample")
        #endif
        observe()
        applyPendingActions()
        for activity in Activity<WorkoutActivityAttributes>.activities { watch(activity) }
        for activity in Activity<TodayActivityAttributes>.activities { watch(activity) }
        #if DEBUG
        if demo != nil {
            Task { await self.startDemo() }
            return
        }
        #endif
        requestSync()
    }

    /// The app came to the foreground: actions queued without the app,
    /// then everything brought up to date (Today starts here when enabled).
    func appBecameActive() {
        applyPendingActions()
        requestSync()
    }

    /// The Today setting was switched, or the suggestion card turned it on.
    func todaySettingChanged() {
        if LiveActivitySettings.todayEnabled {
            UserDefaults.standard.removeObject(forKey: Self.closedTodayKey)
        }
        requestSync()
    }

    /// The look changed in Preferences: widgets and activities redraw.
    func styleChanged() {
        WidgetCenter.shared.reloadAllTimelines()
        Task { await self.sync(force: true) }
    }

    /// A Start action (Train): the workout activity comes up before the
    /// first set is done. Called by Today's "Start …" session button.
    func beginWorkout(on day: Date = Date()) {
        manualStart = (calendar.startOfDay(for: day), Date())
        UserDefaults.standard.removeObject(forKey: Self.closedWorkoutKey)
        requestSync()
    }

    /// Asks for a sync soon, coalesced: several changes in a burst make one
    /// push, and pushes are at least a second apart.
    func requestSync() {
        guard !syncScheduled else { return }
        syncScheduled = true
        let wait = max(0.25, 1 - Date().timeIntervalSince(lastSync))
        Task {
            try? await Task.sleep(for: .seconds(wait))
            self.syncScheduled = false
            await self.sync(force: false)
        }
    }

    /// Pushes now (buttons on the activity: the system shows the result as
    /// soon as the intent returns).
    func syncNow() async {
        await sync(force: false)
    }

    // MARK: Observation

    /// Re-arms after every change: the read set below is what the
    /// activities and the snapshot show.
    private func observe() {
        guard let store, let daily, let restTimer else { return }
        withObservationTracking {
            _ = store.sessions
            _ = store.profile
            _ = store.unit
            _ = restTimer.endsAt
            _ = daily.water
            _ = daily.meals
            _ = daily.waterTargetOverride
            _ = daily.profileWaterTarget
            _ = self.health?.measuredActivity
        } onChange: { [weak self] in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.observe()
                self.requestSync()
            }
        }
    }

    // MARK: Sync

    private func sync(force: Bool) async {
        let previous = chain
        let task = Task {
            await previous?.value
            self.lastSync = Date()
            self.writeSnapshot()
            await self.syncWorkout(force: force)
            await self.syncToday(force: force)
        }
        chain = task
        await task.value
    }

    // MARK: Snapshot (widgets)

    private func writeSnapshot() {
        #if DEBUG
        if widgetSample {
            var sample = TodaySnapshot.sample
            sample.updatedAt = Date()
            sample.save()
            return
        }
        #endif
        guard let snapshot = makeSnapshot() else { return }
        snapshot.save()
    }

    func makeSnapshot(now: Date = Date()) -> TodaySnapshot? {
        guard let store, let daily else { return nil }
        let profile = store.profile
        let plan = profile.flatMap { NutritionPlan(profile: $0, now: now, measured: health?.measuredActivity) }
        let eaten = daily.eaten(on: now)
        let today = calendar.startOfDay(for: now)
        let session = store.session(on: now)
        let trained = session.map { $0.completedAt != nil && $0.hasCompletedSets } ?? false
        let upcoming = upcomingTraining(from: now, store: store)
        let isTrainingDay = upcoming.contains { calendar.isDate($0.day, inSameDayAs: today) }
        let next = upcoming.first { !trained || !calendar.isDate($0.day, inSameDayAs: today) }
        return TodaySnapshot(
            day: today,
            waterML: daily.waterDrunk(on: now),
            waterTargetML: daily.waterTargetOverride ?? DailyStore.waterTarget(for: profile),
            kcalEaten: eaten.kcal,
            kcalTarget: plan.map { Int($0.calories) } ?? 0,
            proteinG: eaten.proteinG,
            proteinTargetG: plan.map { Int($0.protein) } ?? 0,
            mealsCount: daily.meals(on: now).count,
            isTrainingDay: isTrainingDay,
            trainedToday: trained,
            nextTrainingLabel: next?.label,
            nextTrainingDay: next?.day,
            nextTrainingTime: next?.time,
            updatedAt: now,
            upcoming: upcoming)
    }

    /// Whether `day` is a training day: the saved schedule's, else (no
    /// schedule: every day `.open`) the profile's training weekdays — the
    /// same rule NudgePlanner.training uses. Label nil for `.open`.
    private func training(on day: Date, profile: UserProfile?) -> (isTraining: Bool, label: String?) {
        switch ProgramAdvisor.plan(on: day, profile: profile, calendar: calendar) {
        case .rest:
            return (false, nil)
        case .train(let splitDay):
            return (true, splitDay.name.isEmpty ? nil : splitDay.name)
        case .open:
            guard let weekdays = profile?.weekdays else { return (false, nil) }
            return (weekdays.contains(calendar.component(.weekday, from: day)), nil)
        }
    }

    /// The training days of the next week, today included (done or not),
    /// each at the user's usual start.
    private func upcomingTraining(from now: Date, store: WorkoutStore) -> [TodaySnapshot.Training] {
        let today = calendar.startOfDay(for: now)
        let profile = store.profile
        return (0...7).compactMap { offset -> TodaySnapshot.Training? in
            guard let day = calendar.date(byAdding: .day, value: offset, to: today) else { return nil }
            let plan = training(on: day, profile: profile)
            guard plan.isTraining else { return nil }
            let minutes = NudgePlanner.usualStartMinutes(store.sessions, before: day, calendar: calendar)
            let time = calendar.date(bySettingHour: minutes / 60, minute: minutes % 60, second: 0, of: day)
            return TodaySnapshot.Training(day: day, label: plan.label, time: time)
        }
    }

    // MARK: Workout activity

    /// Today's session while it runs: a set done (or Start tapped) and not
    /// completed. Six hours back too, so a workout past midnight still counts.
    func liveSession(now: Date = Date()) -> WorkoutSession? {
        guard let store else { return nil }
        for time in [now, now.addingTimeInterval(-6 * 3600)] {
            guard let session = store.session(on: time), session.completedAt == nil,
                  !session.exercises.isEmpty else { continue }
            if session.hasCompletedSets || manualStart?.day == session.day { return session }
        }
        return nil
    }

    /// The exercise being worked: the one with the latest set done while it
    /// still has sets open, else the first one with sets open.
    static func currentExercise(in session: WorkoutSession) -> WorkoutExercise? {
        let open = session.exercises.filter { !$0.isCompleted && $0.completedSets.count < $0.sets.count }
        let latest = open.max { a, b in
            (a.completedSets.compactMap(\.completedAt).max() ?? .distantPast)
                < (b.completedSets.compactMap(\.completedAt).max() ?? .distantPast)
        }
        if let latest, !latest.completedSets.isEmpty { return latest }
        return open.first
    }

    /// Sets more than this apart belong to separate runs: a quick set in
    /// the morning doesn't start the evening's workout clock.
    private static let runGap: TimeInterval = 90 * 60

    /// When the workout now running began: the first set of the latest run
    /// of sets (no gap over 90 min), or the Start tap shortly before it.
    /// The 3 h cap and the "swiped away" key count from this, not from the
    /// day's first set.
    private func startedAt(_ session: WorkoutSession, now: Date) -> Date {
        let manual = manualStart.flatMap { calendar.isDate($0.day, inSameDayAs: session.day) ? $0.at : nil }
        let times = session.exercises.flatMap(\.completedSets).compactMap(\.completedAt).sorted()
        guard var start = times.last else { return manual ?? now }
        for time in times.reversed() {
            guard start.timeIntervalSince(time) <= Self.runGap else { break }
            start = time
        }
        if let manual {
            // Start tapped a little before the first set of this run, or
            // after the run went quiet (a new workout begun by hand).
            if manual <= start, start.timeIntervalSince(manual) <= Self.runGap { return manual }
            if let last = times.last, manual > last { return manual }
        }
        return start
    }

    /// The key a closed (swiped away / capped) workout is remembered by:
    /// its day and the start of its run, so a later workout the same day
    /// can still have its activity.
    private func workoutKey(day: Date, started: Date) -> String {
        "\(DayKey.make(day, calendar: calendar))@\(Int(started.timeIntervalSince1970))"
    }

    private func workoutName(_ session: WorkoutSession) -> String {
        let groups = session.groups
        if case .train(let day) = ProgramAdvisor.plan(on: session.day, profile: store?.profile, calendar: calendar),
           !day.name.isEmpty, Set(groups).isSubset(of: Set(day.groups)) {
            return TodayMetrics.dayTitle(day.name)
        }
        if groups.isEmpty || groups.count > 2 {
            return String(localized: "Workout", comment: "Live Activity: the workout's name when it has no split day")
        }
        return groups.map(\.title).formatted(.list(type: .and))
    }

    func workoutState(for session: WorkoutSession, finished: Bool = false,
                      now: Date = Date()) -> WorkoutActivityAttributes.ContentState {
        let exercises = session.exercises
        let allSets = exercises.flatMap(\.sets)
        let working = Self.currentExercise(in: session)
        let current = working ?? exercises.last { !$0.completedSets.isEmpty } ?? exercises.last
        let index = current.flatMap { c in exercises.firstIndex { $0.id == c.id } } ?? 0
        let unit = store?.unit ?? .kg

        var setNumber = current?.sets.count ?? 0
        var weight: Double?
        var reps: Int?
        var hold: Int?
        var target: String?
        if let current = working, let open = SetLogging.nextOpenSet(of: current) {
            setNumber = open.number
            if current.isTimed {
                hold = open.set.reps
                target = String(localized: "Hold \(open.set.reps) s", comment: "Live Activity: next set target for a timed hold")
            } else {
                let previous = store?.previousPerformance(forExercise: current.id)
                weight = open.set.weight
                    ?? (previous?.measure == current.setMeasure ? previous?.set(at: open.number - 1)?.weight : nil)
                reps = open.set.reps
                if let weight, weight > 0 {
                    target = "\(unit.format(weight)) × \(open.set.reps)"
                } else {
                    target = String(localized: "\(open.set.reps) reps", comment: "Live Activity: next set target without weight")
                }
            }
        }

        var restStart: Date?
        var restEnd: Date?
        if !finished, let timer = restTimer, let end = timer.endsAt, end > now {
            restEnd = end
            restStart = end.addingTimeInterval(-max(1, timer.duration))
        }

        var state = WorkoutActivityAttributes.ContentState(
            exerciseName: current?.exerciseName ?? "",
            muscleGroup: current?.group.title ?? "",
            exerciseIndex: exercises.isEmpty ? 0 : index + 1,
            exerciseCount: exercises.count,
            setNumber: max(1, setNumber),
            setsInExercise: current?.sets.count ?? 0,
            setsDone: allSets.filter(\.isCompleted).count,
            setsTotal: allSets.count,
            nextWeightKg: weight,
            nextReps: reps,
            nextHoldSeconds: hold,
            weightUnit: unit.symbol,
            nextTargetText: target,
            restStartedAt: restStart,
            restEndsAt: restEnd,
            isFinished: finished)
        // Every set ticked but Complete not tapped yet: no next set, no Done
        // set button — the views ask to finish in the app.
        state.allSetsDone = !finished && working == nil && !exercises.isEmpty
        return state
    }

    private var canShowActivities: Bool {
        LiveActivitySettings.isSupportedDevice && LiveActivitySettings.areActivitiesEnabled
    }

    private func syncWorkout(force: Bool) async {
        #if DEBUG
        if demo == "workout" { return }
        #endif
        guard let store else { return }
        let now = Date()
        let all = Activity<WorkoutActivityAttributes>.activities
        let running = all.filter { $0.activityState == .active || $0.activityState == .stale }

        guard let session = liveSession(now: now) else {
            // No workout running: end what's up — with its final state when
            // the session was completed, else at once (sets unticked).
            for activity in running {
                let completed = store.session(on: activity.attributes.day)
                if let completed, completed.completedAt != nil {
                    let final = workoutState(for: completed, finished: true, now: now)
                    await end(activity, state: final,
                              policy: .after(now.addingTimeInterval(Self.finishedLinger)))
                } else {
                    await end(activity, state: nil, policy: .immediate)
                }
            }
            return
        }

        let day = session.day
        let started = startedAt(session, now: now)
        let closedKey = workoutKey(day: day, started: started)

        // Three hours after this workout's first set it's over, whatever the
        // app saw.
        if now.timeIntervalSince(started) > Self.workoutMaxAge {
            UserDefaults.standard.set(closedKey, forKey: Self.closedWorkoutKey)
            for activity in running { await end(activity, state: nil, policy: .default) }
            return
        }

        let state = workoutState(for: session, now: now)
        if let activity = running.first(where: {
            calendar.isDate($0.attributes.day, inSameDayAs: day)
                && abs($0.attributes.startedAt.timeIntervalSince(started)) < 1
        }) {
            for other in running where other.id != activity.id { await end(other, state: nil, policy: .immediate) }
            await update(activity, state: state, force: force, now: now)
            return
        }
        for other in running { await end(other, state: nil, policy: .immediate) }

        // Start: not when swiped away for this session, not when disabled.
        guard canShowActivities,
              UserDefaults.standard.string(forKey: Self.closedWorkoutKey) != closedKey else { return }
        // A card the system (or an earlier end) left on the Lock Screen
        // goes now, so the new one never sits beside a frozen copy.
        for old in all where old.activityState == .ended { await end(old, state: nil, policy: .immediate) }
        // The workout takes the island: Today steps aside.
        for today in Activity<TodayActivityAttributes>.activities { await end(today, state: nil, policy: .immediate) }
        let attributes = WorkoutActivityAttributes(workoutName: workoutName(session), startedAt: started, day: day)
        lastWorkoutChange = now
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: ActivityContent(state: state, staleDate: staleDate(for: state, now: now), relevanceScore: 100),
                pushType: nil)
            pushedWorkout[activity.id] = state
            watch(activity)
        } catch {
            // Not allowed now (backgrounded, too many activities, turned off).
        }
    }

    /// While resting: the rest's end, so the system redraws the activity
    /// then (as stale) even with the app suspended — the views show "Rest
    /// over" for a stale context whose rest has ended. Otherwise 30 idle
    /// minutes after the last change.
    private func staleDate(for state: WorkoutActivityAttributes.ContentState, now: Date) -> Date {
        if let end = state.restEndsAt, end > now { return end }
        return lastWorkoutChange.addingTimeInterval(Self.staleAfter)
    }

    private func update(_ activity: Activity<WorkoutActivityAttributes>,
                        state: WorkoutActivityAttributes.ContentState, force: Bool, now: Date) async {
        if !force, pushedWorkout[activity.id] == state { return }
        if pushedWorkout[activity.id] != state { lastWorkoutChange = now }
        pushedWorkout[activity.id] = state
        await activity.update(ActivityContent(state: state, staleDate: staleDate(for: state, now: now),
                                              relevanceScore: 100))
    }

    // MARK: Today activity

    // App Review: Live Activities are meant for tasks with a start and an
    // end. Today is framed as the day's tracking session — opt-in (default
    // OFF), it starts on the user's open, ends at midnight (or the system's
    // 8 h), and steps aside for a workout. Say so in the review notes.

    private func syncToday(force: Bool) async {
        let now = Date()
        let today = calendar.startOfDay(for: now)
        let all = Activity<TodayActivityAttributes>.activities
        let running = all.filter { $0.activityState == .active || $0.activityState == .stale }

        #if DEBUG
        if demo == "today" {
            if let activity = running.first, force {
                await activity.update(ActivityContent(state: .sample, staleDate: nil, relevanceScore: 10))
            }
            return
        }
        if demo == "workout" {
            for activity in running { await end(activity, state: nil, policy: .immediate) }
            return
        }
        #endif

        // A running workout takes the island; so does the finished workout's
        // card while it lingers on the Lock Screen (Today comes back when it
        // is dismissed — `watch` asks for a sync then).
        let workoutUp = Activity<WorkoutActivityAttributes>.activities.contains {
            $0.activityState == .active || $0.activityState == .stale
                || ($0.activityState == .ended && $0.content.state.isFinished)
        }
        guard LiveActivitySettings.todayEnabled, canShowActivities, store?.profile != nil, !workoutUp,
              let snapshot = makeSnapshot(now: now) else {
            for activity in running { await end(activity, state: nil, policy: .immediate) }
            return
        }
        let state = TodayActivityAttributes.ContentState(snapshot)
        let staleDate = calendar.date(byAdding: .day, value: 1, to: today)
        let foreground = UIApplication.shared.applicationState == .active

        // Today's activity is updated. One from an earlier day is replaced
        // in the foreground; in the background (a +250 ml tap after
        // midnight) a new one can't be requested, so the old card carries
        // today's numbers instead (the state's `day` says which day they are).
        let current = running.first { calendar.isDate($0.attributes.day, inSameDayAs: today) }
            ?? (foreground ? nil : running.first)
        for activity in running where activity.id != current?.id {
            await end(activity, state: nil, policy: .immediate)
        }
        if let activity = current {
            if force || pushedToday[activity.id] != state {
                pushedToday[activity.id] = state
                await activity.update(ActivityContent(state: state, staleDate: staleDate, relevanceScore: 10))
            }
            return
        }
        // Start only in the foreground (ActivityKit refuses otherwise), and
        // not again on a day the user swiped it away.
        guard foreground,
              UserDefaults.standard.string(forKey: Self.closedTodayKey) != DayKey.make(today, calendar: calendar)
        else { return }
        // The system ends a Today activity after 8 h and leaves its frozen
        // card on the Lock Screen for hours: clear it before asking for a
        // new one, so two Today cards never sit side by side.
        for old in all where old.activityState == .ended { await end(old, state: nil, policy: .immediate) }
        do {
            let activity = try Activity.request(
                attributes: TodayActivityAttributes(day: today),
                content: ActivityContent(state: state, staleDate: staleDate, relevanceScore: 10),
                pushType: nil)
            pushedToday[activity.id] = state
            watch(activity)
        } catch {
            // Turned off, or too many activities.
        }
    }

    // MARK: Ending and dismissal

    private func end(_ activity: Activity<WorkoutActivityAttributes>, state: WorkoutActivityAttributes.ContentState?,
                     policy: ActivityUIDismissalPolicy) async {
        forget(activity.id)
        await activity.end(state.map { ActivityContent(state: $0, staleDate: nil) }, dismissalPolicy: policy)
    }

    private func end(_ activity: Activity<TodayActivityAttributes>, state: TodayActivityAttributes.ContentState?,
                     policy: ActivityUIDismissalPolicy) async {
        forget(activity.id)
        await activity.end(state.map { ActivityContent(state: $0, staleDate: nil) }, dismissalPolicy: policy)
    }

    private func forget(_ id: String) {
        endedByApp.insert(id)
        pushedWorkout[id] = nil
        pushedToday[id] = nil
    }

    /// A swipe on the Lock Screen ends an activity without the app: the
    /// workout one stays away for that session, Today for that day. (An
    /// activity the system ends — 8 h — goes .ended first, so it doesn't count.)
    private func watch(_ activity: Activity<WorkoutActivityAttributes>) {
        watch(activity, closedKey: Self.closedWorkoutKey,
              value: workoutKey(day: activity.attributes.day, started: activity.attributes.startedAt), isWorkout: true)
    }

    private func watch(_ activity: Activity<TodayActivityAttributes>) {
        watch(activity, closedKey: Self.closedTodayKey,
              value: DayKey.make(activity.attributes.day, calendar: calendar), isWorkout: false)
    }

    private func watch<A: ActivityAttributes & SendableMetatype>(_ activity: Activity<A>, closedKey: String, value dayKey: String, isWorkout: Bool) {
        guard watched.insert(activity.id).inserted else { return }
        let id = activity.id
        Task { [weak self] in
            var sawEnded = false
            for await state in activity.activityStateUpdates {
                guard let self else { return }
                if state == .ended { sawEnded = true }
                guard state == .dismissed else { continue }
                if !sawEnded, !self.endedByApp.contains(id) {
                    UserDefaults.standard.set(dayKey, forKey: closedKey)
                }
                self.watched.remove(id)
                self.pushedWorkout[id] = nil
                self.pushedToday[id] = nil
                // Today may come back now the workout is gone.
                if isWorkout { self.requestSync() }
                return
            }
        }
    }

    // MARK: Pending actions

    /// Actions a widget button queued while the app had no handler. Water
    /// is applied with its own time; set and rest taps are stale by now and
    /// dropped (doing a set the user may have redone in the app is worse).
    private func applyPendingActions() {
        guard let daily else { return }
        for action in PendingActions.drain() {
            if case .addWater(let ml, let at) = action {
                daily.addWater(ml, at: at)
            }
        }
    }

    // MARK: DEBUG demo

    #if DEBUG
    /// `-liveactivity.demo workout|today`: a sample activity for screenshots.
    private func startDemo() async {
        try? await Task.sleep(for: .seconds(1))
        writeSnapshot()
        for activity in Activity<WorkoutActivityAttributes>.activities { await end(activity, state: nil, policy: .immediate) }
        for activity in Activity<TodayActivityAttributes>.activities { await end(activity, state: nil, policy: .immediate) }
        do {
            switch demo {
            case "workout":
                let state = WorkoutActivityAttributes.ContentState.sampleResting
                let resting = WorkoutActivityAttributes.ContentState(
                    exerciseName: state.exerciseName, muscleGroup: state.muscleGroup,
                    exerciseIndex: state.exerciseIndex, exerciseCount: state.exerciseCount,
                    setNumber: state.setNumber, setsInExercise: state.setsInExercise,
                    setsDone: state.setsDone, setsTotal: state.setsTotal,
                    nextWeightKg: state.nextWeightKg, nextReps: state.nextReps, nextHoldSeconds: nil,
                    weightUnit: state.weightUnit, nextTargetText: state.nextTargetText,
                    restStartedAt: Date(), restEndsAt: Date().addingTimeInterval(90), isFinished: false)
                let activity = try Activity.request(
                    attributes: WorkoutActivityAttributes(workoutName: "Push day",
                                                          startedAt: Date().addingTimeInterval(-20 * 60),
                                                          day: calendar.startOfDay(for: Date())),
                    content: ActivityContent(state: resting, staleDate: nil, relevanceScore: 100),
                    pushType: nil)
                endedByApp.insert(activity.id) // a swipe on the demo never closes the real day
            case "today":
                let activity = try Activity.request(
                    attributes: TodayActivityAttributes(day: calendar.startOfDay(for: Date())),
                    content: ActivityContent(state: .sample, staleDate: nil, relevanceScore: 10),
                    pushType: nil)
                endedByApp.insert(activity.id)
            default:
                break
            }
        } catch {
            print("Live Activity demo failed: \(error)")
        }
    }
    #endif
}
