//
//  GreetingHeader.swift
//  GymWorkout
//
//  The Train tab's title line. On today it says hello for a moment, then
//  rolls on to a line about the day: what to train when nothing's done yet,
//  praise for yesterday's session, a cheer mid-workout, congratulations once
//  today's is complete, a welcome back after a break. Pick another day on
//  the calendar and it talks about that one instead: what's planned, what
//  was trained, or what to train. The lines change from day to day so they
//  don't wear thin. Today's play once per launch, so switching tabs doesn't
//  greet you again; another day's play each time it's picked.
//

import SwiftUI

struct GreetingHeader: View {
    /// What the picked day calls for (see `Greeting`).
    var greeting: Greeting

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var text: String

    /// Days already greeted, and today's lines already played, this launch.
    private static var greetedDays: Set<Date> = []
    private static var playedKeys: Set<String> = []

    init(greeting: Greeting) {
        self.greeting = greeting
        _text = State(initialValue: Self.hasPlayed(greeting)
                      ? greeting.lines.last ?? ""
                      : Self.sequence(for: greeting).first ?? "")
    }

    private static func hasPlayed(_ greeting: Greeting) -> Bool {
        !greeting.replays && playedKeys.contains(greeting.key)
    }

    /// The hello only comes first the first time a day is greeted; new lines
    /// later the same day (the workout completed) go straight to themselves.
    private static func sequence(for greeting: Greeting) -> [String] {
        guard let hello = greeting.hello, !greetedDays.contains(greeting.day) else { return greeting.lines }
        return [hello] + greeting.lines
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Text(text)
                .font(.ui(28, .semibold))
                .tracking(-0.7)
                .foregroundStyle(DS.silver)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .id(text)
                .transition(reduceMotion
                    ? .opacity
                    : .asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                  removal: .move(edge: .top).combined(with: .opacity)))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(greeting.lines.last ?? "")
        .accessibilityAddTraits(.isHeader)
        .task(id: greeting.key) { await play() }
    }

    private var animation: Animation {
        reduceMotion ? .easeInOut(duration: 0.25) : .spring(response: 0.55, dampingFraction: 0.85)
    }

    private func play() async {
        if Self.hasPlayed(greeting) {
            withAnimation(animation) { text = greeting.lines.last ?? text }
            return
        }
        let lines = Self.sequence(for: greeting)
        if !greeting.replays { Self.playedKeys.insert(greeting.key) }
        if greeting.hello != nil { Self.greetedDays.insert(greeting.day) }
        for (index, line) in lines.enumerated() {
            if index > 0 {
                try? await Task.sleep(for: .seconds(index == 1 ? 2.4 : 2.8))
                guard !Task.isCancelled else { return }
            }
            withAnimation(animation) { text = line }
        }
    }
}

/// The header's lines for one day.
struct Greeting: Equatable {
    /// "Good morning, Sam"; only today says hello.
    let hello: String?
    /// What follows the hello, the last one staying.
    let lines: [String]
    /// The day picked, at midnight.
    let day: Date
    /// Changes whenever the lines do, so they play again.
    let key: String
    /// Plays every time it's shown, rather than once per launch: another
    /// day, picked on purpose.
    let replays: Bool

    /// Where the lifter stands today.
    enum Moment: Equatable {
        /// Nothing logged, ever.
        case firstWorkout
        /// Today's workout is complete.
        case doneToday(sets: Int)
        /// Sets done today, not completed yet.
        case inProgress(sets: Int)
        /// Groups planned today, no sets yet.
        case planned([MuscleGroup])
        /// Trained yesterday, nothing yet today.
        case yesterday([MuscleGroup])
        /// Two or three days since the last workout.
        case rested(days: Int)
        /// Four days or more.
        case comeback(days: Int)

        var name: String {
            switch self {
            case .firstWorkout: return "first"
            case .doneToday: return "done"
            case .inProgress: return "progress"
            case .planned: return "planned"
            case .yesterday: return "yesterday"
            case .rested: return "rested"
            case .comeback: return "comeback"
            }
        }
    }

    /// - Parameters:
    ///   - selected: the day picked on the calendar.
    ///   - next: the split day the planner suggests for it, e.g. "Lower".
    init(name: String?, sessions: [WorkoutSession], selected: Date, next: String?,
         now: Date = Date(), calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: now)
        let day = calendar.startOfDay(for: selected)
        let you = name.map { ", \($0)" } ?? ""
        // Lines longer than a hello only take the name when it's short, so
        // they still fit the header's one line.
        let shortYou = (name?.count ?? 0) <= 10 ? you : ""
        // Changes daily, so the lines do; steady through the day, so a
        // redraw never swaps them.
        let ordinal = calendar.ordinality(of: .day, in: .era, for: day) ?? 0

        if day == today {
            let moment = Self.moment(sessions: sessions, today: today, calendar: calendar)
            let seed = ordinal &+ moment.name.count
            hello = Self.pick(Self.hellos(hour: calendar.component(.hour, from: now), you: you), seed)
            lines = Self.lines(for: moment, you: shortYou, next: next, seed: seed)
            replays = false
        } else {
            let session = sessions.first { calendar.isDate($0.day, inSameDayAs: day) }
            let when = When(day, today: today, calendar: calendar)
            hello = nil
            lines = day < today
                ? Self.pastLines(session, when: when, seed: ordinal)
                : Self.futureLines(session, when: when, next: next, seed: ordinal)
            replays = true
        }
        self.day = day
        // Anything that changes the lines plays them again: a new day, the
        // workout moving on, another set done, a new name.
        key = "\(day.timeIntervalSinceReferenceDate)|\(hello ?? "")|\(lines.joined(separator: "|"))"
    }

    static func moment(sessions: [WorkoutSession], today: Date, calendar: Calendar) -> Moment {
        let logged = sessions.filter(\.hasCompletedSets)
        if let session = sessions.first(where: { calendar.isDate($0.day, inSameDayAs: today) }) {
            if session.completedAt != nil, session.hasCompletedSets {
                return .doneToday(sets: session.completedSetCount)
            }
            if session.hasCompletedSets { return .inProgress(sets: session.completedSetCount) }
            if !session.groups.isEmpty { return .planned(session.groups) }
        }
        guard let last = logged.filter({ $0.day < today }).max(by: { $0.day < $1.day }) else {
            return .firstWorkout
        }
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: last.day), to: today).day ?? 0
        switch days {
        case ...1: return .yesterday(trained(last))
        case 2...3: return .rested(days: days)
        default: return .comeback(days: days)
        }
    }

    // MARK: - Today

    private static func hellos(hour: Int, you: String) -> [String] {
        switch hour {
        case 5..<12: return ["Good morning\(you)", "Morning\(you)", "Hello\(you)"]
        case 12..<17: return ["Good afternoon\(you)", "Hey\(you)", "Hello\(you)"]
        case 17..<22: return ["Good evening\(you)", "Evening\(you)", "Hello\(you)"]
        default: return ["Hello\(you)", "Hi\(you)", "Still up\(you)?"]
        }
    }

    private static func lines(for moment: Moment, you: String, next: String?, seed: Int) -> [String] {
        let day = next.map(sessionName)
        let ask = day.map { ["\($0) today?", "Ready for \($0)?", "\($0) is up next."] }
            ?? ["What are we training today?", "What's on today?", "Pick a group to start."]
        // The first line follows a hello that already said the name.
        func first(_ options: [String]) -> String { pick(options, seed, 1) }
        func last(_ options: [String]) -> String { pick(options, seed, 2) }
        switch moment {
        case .firstWorkout:
            return [first(["Welcome to MUSQ.", "Let's log your first workout.", "Every routine starts here."]),
                    last(["Pick a group below to start.", "Your first set starts here.", "Tap a group to begin."])]
        case .doneToday(let sets):
            // Usually plays without a hello (the workout is completed later
            // in the day), so it can take the name.
            return [first(["Workout done. Nice work\(you)!", "That's a wrap for today.", "\(count(sets, "set")) today. Strong work.",
                           "Another one in the books.", "Done and dusted!"]),
                    last(["Rest up. You earned it.", "Recovery starts now.", "See you next session.",
                          "Eat well, sleep well."])]
        case .inProgress(let sets):
            return [first(["\(count(sets, "set")) in. Keep going!", "Nice pace. Keep it up.", "You're in the zone."]),
                    last(["Finish strong.", "One set at a time.", "Keep it rolling."])]
        case .planned(let groups):
            return [first(["\(phrase(groups, capitalized: true)) on the plan today.", "Your workout's ready.",
                           "\(phrase(groups, capitalized: true)) today. Let's go."]),
                    last(["Ready when you are.", "The first set's the hardest.", "Time to move."])]
        case .yesterday(let groups):
            let named = (1...2).contains(groups.count)
                ? ["Yesterday: \(phrase(groups)). Nice!", "Yesterday's \(phrase(groups))? Solid."]
                : ["Big session yesterday. Solid."]
            return [first(["Great session yesterday.", "Strong one yesterday!"] + named), last(ask)]
        case .rested(let days):
            return [first(["\(days) days of rest. Feeling fresh?", "Feeling recharged?", "Good to see you again."]),
                    last(ask)]
        case .comeback(let days):
            return [first(["Welcome back!", "It's been \(days) days. Missed you!", "Every comeback starts with one set."]),
                    last(day.map { ["Ease in with \($0)?", "Start light with \($0)?"] }
                         ?? ["Let's start light today.", "One workout at a time."])]
        }
    }

    // MARK: - Another day

    /// A picked day, in the forms a sentence needs.
    private struct When {
        /// "Tomorrow", "Wednesday", "Wed 14 Oct" — to open a sentence.
        let title: String
        /// "tomorrow", "Wednesday", "Wed 14 Oct" — inside one.
        let plain: String
        /// "tomorrow", "on Wednesday", "on Wed 14 Oct" — to end one.
        let on: String

        init(_ day: Date, today: Date, calendar: Calendar) {
            let offset = calendar.dateComponents([.day], from: today, to: day).day ?? 0
            switch offset {
            case -1: title = "Yesterday"; plain = "yesterday"; on = "yesterday"
            case 1: title = "Tomorrow"; plain = "tomorrow"; on = "tomorrow"
            case -6...6:
                title = day.formatted(.dateTime.weekday(.wide)); plain = title; on = "on \(title)"
            default:
                title = day.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
                plain = title; on = "on \(title)"
            }
        }
    }

    private static func pastLines(_ session: WorkoutSession?, when: When, seed: Int) -> [String] {
        if let session, session.hasCompletedSets {
            let groups = trained(session)
            return [pick(["Trained \(phrase(groups)) \(when.on).", "\(when.title): \(phrase(groups)).",
                          "\(phrase(groups, capitalized: true)) \(when.on). Nice!"], seed, 1),
                    pick(["\(count(session.completedSetCount, "set")) logged. Nice work!", "Solid session.",
                          "Every set counts.", "That one paid off."], seed, 2)]
        }
        if let session, !session.groups.isEmpty {
            return [pick(["\(when.title)'s plan: \(phrase(session.groups)).",
                          "\(when.title): \(phrase(session.groups)) planned."], seed, 1),
                    pick(["Trained it? Log your sets below.", "Did you train? Log it below."], seed, 2)]
        }
        return [pick(["Nothing logged \(when.on).", "\(when.title) was a rest day.", "A quiet day \(when.on)."], seed, 1),
                pick(["Trained that day? Log it below.", "Rest days count too.", "Recovery is training too."], seed, 2)]
    }

    private static func futureLines(_ session: WorkoutSession?, when: When, next: String?, seed: Int) -> [String] {
        if let session, !session.groups.isEmpty {
            return [pick(["\(phrase(session.groups, capitalized: true)) planned for \(when.plain).",
                          "\(when.title): \(phrase(session.groups))."], seed, 1),
                    pick(["Looking good.", "Future you says thanks.", "Plan ahead, show up ready."], seed, 2)]
        }
        return [pick(["What's the plan for \(when.plain)?", "Planning \(when.plain)?", "Looking ahead to \(when.plain)?"], seed, 1),
                pick(next.map(sessionName).map { ["How about \($0)?", "\($0) fits \(when.plain).", "\($0) looks right."] }
                     ?? ["What will you train?", "Pick a group to plan it."], seed, 2)]
    }

    // MARK: - Words

    /// The groups a day actually trained, in plan order: planned groups
    /// with no sets done don't get the praise.
    private static func trained(_ session: WorkoutSession) -> [MuscleGroup] {
        var seen: [MuscleGroup] = []
        for exercise in session.exercises where !exercise.completedSets.isEmpty && !seen.contains(exercise.group) {
            seen.append(exercise.group)
        }
        return seen
    }

    /// "Lower day", "Leg day", "Leg A day": a split's day inside a sentence,
    /// so "Back" can't read as the word. Nonisolated: it only builds a
    /// string, and `Optional.map` takes it from outside the main actor.
    nonisolated private static func sessionName(_ split: String) -> String {
        split.hasPrefix("Legs") ? "Leg\(split.dropFirst(4)) day" : "\(split) day"
    }

    /// "biceps", "chest & abs", "3 groups". In a pair, Abs & Core is just
    /// "abs", so the ampersands don't stack.
    private static func phrase(_ groups: [MuscleGroup], capitalized: Bool = false) -> String {
        let text: String
        switch groups.count {
        case 0: text = "your workout"
        case 1: text = groups[0].title.lowercased()
        case 2: text = groups.map { $0 == .abs ? "abs" : $0.title.lowercased() }.joined(separator: " & ")
        default: text = "\(groups.count) groups"
        }
        return capitalized ? text.prefix(1).uppercased() + text.dropFirst() : text
    }

    /// "1 set", "6 sets".
    private static func count(_ value: Int, _ noun: String) -> String {
        "\(value) \(value == 1 ? noun : noun + "s")"
    }

    /// One of `options` for the day's seed. Each line of a sequence passes
    /// its own `slot`, so lines don't move in step and repeat each other.
    private static func pick(_ options: [String], _ seed: Int, _ slot: Int = 0) -> String {
        var mixed = UInt64(truncatingIfNeeded: seed &* 3 &+ slot) &* 0x9E37_79B9_7F4A_7C15
        mixed ^= mixed >> 29
        return options[Int(mixed % UInt64(options.count))]
    }
}
