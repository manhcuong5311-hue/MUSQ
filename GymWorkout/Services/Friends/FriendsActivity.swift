//
//  FriendsActivity.swift
//  GymWorkout
//
//  What the member's friends see (2026-11-28): summaries worked out from the
//  workout and daily logs on this device, read-only, and posted with
//  `friendsPost` only when they changed. Never Apple Health data, never
//  calories, meal photos or body weight; the goal only as a 0–100 share and
//  only when the member shares it.
//
//  Posted: a finished workout {title, minutes, sets, groups}, a record
//  {exercise, kg}, the day's water target hit, the day's meal count, a
//  streak milestone {days} (days in a row with a completed workout), and the
//  week's line for the board. What went out is remembered per day and kind
//  (UserDefaults), so a sync never posts the same thing twice.
//
//  Runs after each friends sync, when the app comes to the foreground and
//  when it goes to the background (`postSoon()`).
//

import Foundation
import UIKit

@MainActor
final class FriendsActivity {
    static let shared = FriendsActivity()

    /// The live stores, once the root view attached them; else the saved
    /// files are read (NudgeInputs.fromDisk).
    private weak var store: WorkoutStore?
    private weak var daily: DailyStore?
    private var task: Task<Void, Never>?

    /// Days back (today included) whose events are posted.
    static let window = 3
    static let maxEventsPerPost = 20
    static let maxRecordsPerDay = 3

    private static let postedKey = "friends.posted"
    private static let postedWeekKey = "friends.posted.week"
    private static let postedUIDKey = "friends.posted.uid"

    private init() {}

    func attach(store: WorkoutStore, daily: DailyStore) {
        self.store = store
        self.daily = daily
    }

    /// Posts what changed after the previous run, kept alive a moment in the
    /// background (the app going to the background calls this).
    func postSoon() {
        let previous = task
        // Ended once, whichever comes first: the post finishing, or iOS
        // saying the background time is up (the post is then cancelled and
        // goes out on the next run).
        let assertion = BackgroundAssertion()
        assertion.id = UIApplication.shared.beginBackgroundTask(withName: "Friends") {
            MainActor.assumeIsolated {
                assertion.work?.cancel()
                assertion.end()
            }
        }
        let posting = Task {
            await previous?.value
            if !Task.isCancelled { await self.postIfNeeded() }
            assertion.end()
        }
        assertion.work = posting
        task = posting
    }

    /// Posts the events and the week line that differ from what was posted
    /// (all of them with `force`, after the share settings changed). Only
    /// with an account and a friends profile.
    func postIfNeeded(force: Bool = false, now: Date = Date(), calendar: Calendar = .current) async {
        let service = FriendsService.shared
        guard !service.usesSampleData, AccountService.shared.isSignedIn,
              let uid = AccountService.shared.member?.uid, let me = service.me,
              let inputs = inputs() else { return }
        let defaults = UserDefaults.standard
        if defaults.string(forKey: Self.postedUIDKey) != uid {
            forget()
            defaults.set(uid, forKey: Self.postedUIDKey)
        }
        var posted = defaults.dictionary(forKey: Self.postedKey) as? [String: String] ?? [:]
        let candidates = Self.events(inputs, share: me.share, now: now, calendar: calendar)
        let fresh = candidates.filter { force || posted[$0.key] != $0.signature }
        let week = Self.week(inputs, share: me.share, now: now, calendar: calendar)
        let weekSignature = Self.signature(week)
        let weekChanged = force || defaults.string(forKey: Self.postedWeekKey) != weekSignature
        guard !fresh.isEmpty || weekChanged else { return }
        let sending = Array(fresh.prefix(Self.maxEventsPerPost))
        do {
            try await service.post(FriendsPostRequest(events: sending.map(\.event), week: week))
        } catch {
            return
        }
        for item in sending { posted[item.key] = item.signature }
        // Forget days that left the window.
        let oldest = DayKey.make(calendar.date(byAdding: .day, value: -14, to: now) ?? now, calendar: calendar)
        posted = posted.filter { String($0.key.prefix(10)) >= oldest }
        defaults.set(posted, forKey: Self.postedKey)
        defaults.set(weekSignature, forKey: Self.postedWeekKey)
    }

    /// Forgets what was posted (signed out, another account, a new profile).
    func forget() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Self.postedKey)
        defaults.removeObject(forKey: Self.postedWeekKey)
        defaults.removeObject(forKey: Self.postedUIDKey)
    }

    /// This week's line for the board, worked out on the device.
    func currentWeek(share: FriendShare, now: Date = Date(), calendar: Calendar = .current) -> FriendPostWeek? {
        inputs().map { Self.week($0, share: share, now: now, calendar: calendar) }
    }

    private func inputs() -> NudgeInputs? {
        if let store, let daily { return NudgeInputs(store: store, daily: daily) }
        return NudgeInputs.fromDisk()
    }

    // MARK: - Working out (pure)

    struct Candidate {
        /// "yyyy-MM-dd|kind[|exercise or days]".
        var key: String
        var event: FriendPostEvent
        var signature: String
    }

    static func events(_ inputs: NudgeInputs, share: FriendShare, now: Date, calendar: Calendar) -> [Candidate] {
        var result: [Candidate] = []
        let today = calendar.startOfDay(for: now)
        let days = (0..<window).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
        func add(_ kind: FriendEventKind, _ day: Date, _ data: FriendEventData, extra: String? = nil) {
            let dayKey = DayKey.make(day, calendar: calendar)
            let key = [dayKey, kind.rawValue, extra].compactMap { $0 }.joined(separator: "|")
            let event = FriendPostEvent(kind: kind, day: dayKey, data: data)
            result.append(Candidate(key: key, event: event, signature: signature(data)))
        }

        if share.workouts {
            for day in days {
                let started = inputs.sessions.filter {
                    calendar.isDate($0.day, inSameDayAs: day) && $0.hasCompletedSets
                }
                // Finished: Complete Workout was tapped, or the day is over.
                // A session still going today waits until it's completed (the
                // server keeps one workout card a day and updates it).
                let sessions = day < today ? started : started.filter { $0.completedAt != nil }
                guard !sessions.isEmpty else { continue }
                add(.workout, day, workout(sessions))
                for record in records(in: sessions, all: inputs.sessions, day: day, calendar: calendar).prefix(maxRecordsPerDay) {
                    add(.pr, day, FriendEventData(exercise: record.name, kg: record.kg), extra: record.name)
                }
            }
            let run = streak(inputs.sessions, now: now, calendar: calendar)
            if NudgePlanner.streakMilestones.contains(run.days), let end = run.end {
                add(.streak, end, FriendEventData(days: run.days), extra: String(run.days))
            }
        }

        if share.water, inputs.waterTarget > 0 {
            for day in days {
                let drunk = inputs.water.filter { calendar.isDate($0.date, inSameDayAs: day) }.reduce(0) { $0 + $1.ml }
                if drunk >= inputs.waterTarget { add(.water, day, FriendEventData()) }
            }
        }

        if share.meals {
            for day in days {
                let count = inputs.meals.filter { calendar.isDate($0.date, inSameDayAs: day) }.count
                if count > 0 { add(.meals, day, FriendEventData(count: min(count, 20))) }
            }
        }
        return result
    }

    /// The day's workouts as one: the groups actually trained (exercises
    /// with a completed set), completed sets, minutes from the first set done
    /// to the last (or to Complete Workout).
    static func workout(_ sessions: [WorkoutSession]) -> FriendEventData {
        var groups: [MuscleGroup] = []
        for session in sessions {
            for exercise in session.exercises where !exercise.completedSets.isEmpty && !groups.contains(exercise.group) {
                groups.append(exercise.group)
            }
        }
        let sets = sessions.reduce(0) { $0 + $1.completedSetCount }
        var minutes = 0
        for session in sessions {
            let stamps = session.exercises.flatMap { $0.completedSets.compactMap(\.completedAt) }
            guard let first = stamps.min() else { continue }
            let last = max(stamps.max() ?? first, session.completedAt ?? first)
            // The first set's own time counts too.
            minutes += Int((last.timeIntervalSince(first) / 60).rounded()) + 2
        }
        let names = groups.map(englishName)
        return FriendEventData(title: String(names.prefix(4).joined(separator: " · ").prefix(60)),
                               minutes: minutes > 0 ? min(minutes, 300) : nil,
                               sets: min(sets, 200),
                               groups: groups.prefix(6).map(\.rawValue))
    }

    /// Weight PRs of the day: each exercise whose heaviest completed set
    /// that day beats every set logged on earlier days (a first time isn't a
    /// PR, nor a lighter set with more reps), heaviest first. The feed says
    /// "PR · 85 kg", so only the load counts.
    static func records(in sessions: [WorkoutSession], all: [WorkoutSession],
                        day: Date, calendar: Calendar) -> [(name: String, kg: Double)] {
        let dayStart = calendar.startOfDay(for: day)
        func heaviest(_ name: String, in list: [WorkoutSession]) -> Double? {
            list.flatMap { $0.exercises }
                .filter { $0.exerciseName == name && !$0.isTimed }
                .flatMap { $0.completedSets.compactMap(\.weight) }
                .filter { $0 > 0 }
                .max()
        }
        let earlier = all.filter { calendar.startOfDay(for: $0.day) < dayStart }
        var best: [String: Double] = [:]
        let names = Set(sessions.flatMap { $0.exercises.filter { !$0.isTimed && !$0.completedSets.isEmpty }.map(\.exerciseName) })
        for name in names {
            guard let today = heaviest(name, in: sessions), let before = heaviest(name, in: earlier),
                  today > before else { continue }
            best[name] = today
        }
        return best.map { (name: $0.key, kg: ($0.value * 10).rounded() / 10) }.sorted { $0.kg > $1.kg }
    }

    /// Days in a row with a completed workout, ending today, or yesterday
    /// while today has none yet; 0 (and no end) when yesterday had none.
    static func streak(_ sessions: [WorkoutSession], now: Date, calendar: Calendar) -> (days: Int, end: Date?) {
        let active = Set(sessions.filter(\.hasCompletedSets).map { calendar.startOfDay(for: $0.day) })
        let today = calendar.startOfDay(for: now)
        let end = active.contains(today) ? today : calendar.date(byAdding: .day, value: -1, to: today)
        guard let end, active.contains(end) else { return (0, nil) }
        return (NudgePlanner.streak(endingOn: end, in: active, calendar: calendar), end)
    }

    /// The member's week (Monday to Sunday, in their own time zone).
    static func week(_ inputs: NudgeInputs, share: FriendShare, now: Date, calendar: Calendar) -> FriendPostWeek {
        var monday = calendar
        monday.firstWeekday = 2
        let start = monday.dateInterval(of: .weekOfYear, for: now)?.start ?? calendar.startOfDay(for: now)
        let end = calendar.date(byAdding: .day, value: 7, to: start) ?? now
        let trained = Set(inputs.sessions.filter(\.hasCompletedSets).map { calendar.startOfDay(for: $0.day) })
        let workouts = share.workouts ? trained.filter { $0 >= start && $0 < end }.count : 0
        let run = share.workouts ? streak(inputs.sessions, now: now, calendar: calendar).days : 0
        return FriendPostWeek(weekStart: DayKey.make(start, calendar: calendar), workouts: workouts, streak: run,
                              goalPct: share.goal ? goalPercent(inputs, trained: trained) : nil)
    }

    /// The goal's share reached, 0–100, as the Goal page shows it; nil
    /// without a goal, while it's paused or not measured yet.
    static func goalPercent(_ inputs: NudgeInputs, trained: Set<Date>) -> Int? {
        guard GoalStore.shared.hasGoal,
              let progress = GoalStore.shared.progress(profile: inputs.profile, experience: inputs.experience,
                                                       trainedDays: trained),
              GoalWords.isMeasured(progress) else { return nil }
        return GoalWords.wholePercent(GoalWords.shownFraction(progress))
    }

    static func signature<T: Encodable>(_ value: T) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return (try? encoder.encode(value)).flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }

    /// The group's name in English, whatever the app's language: the feed's
    /// fallback title (each reader's app names `groups` in its own).
    static func englishName(_ group: MuscleGroup) -> String {
        switch group {
        case .abs: return "Abs & Core"
        default: return group.rawValue.capitalized
        }
    }
}

/// A background-time assertion ended exactly once (see `postSoon`).
@MainActor
private final class BackgroundAssertion {
    var id = UIBackgroundTaskIdentifier.invalid
    var work: Task<Void, Never>?

    func end() {
        guard id != .invalid else { return }
        UIApplication.shared.endBackgroundTask(id)
        id = .invalid
    }
}

extension FriendFeedItem {
    /// The workout's groups in this app's language, else the title as sent.
    var localizedWorkoutTitle: String? {
        if let keys = data.groups, !keys.isEmpty {
            let names = keys.compactMap(MuscleGroup.init(rawValue:)).map(\.title)
            if !names.isEmpty { return names.joined(separator: " · ") }
        }
        return data.title
    }
}
