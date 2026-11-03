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
    /// 28 on the phone; the iPad's wider header takes a larger line.
    var fontSize: CGFloat = 28

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var text: String

    /// Days already greeted, and today's lines already played, this launch.
    private static var greetedDays: Set<Date> = []
    private static var playedKeys: Set<String> = []

    init(greeting: Greeting, fontSize: CGFloat = 28) {
        self.greeting = greeting
        self.fontSize = fontSize
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
                .font(.ui(fontSize, .semibold))
                // -0.7 at the phone's 28, in proportion above it.
                .tracking(-0.7 * (fontSize / 28))
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
    ///   - roomy: the header has an iPad's width, so a longer name still fits
    ///     the line.
    init(name: String?, sessions: [WorkoutSession], selected: Date, next: String?,
         roomy: Bool = false, now: Date = Date(), calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: now)
        let day = calendar.startOfDay(for: selected)
        // Lines longer than a hello only take the name when it's short, so
        // they still fit the header's one line.
        let shortName = (name?.count ?? 0) <= (roomy ? 18 : 10) ? name : nil
        // Changes daily, so the lines do; steady through the day, so a
        // redraw never swaps them.
        let ordinal = calendar.ordinality(of: .day, in: .era, for: day) ?? 0

        if day == today {
            let moment = Self.moment(sessions: sessions, today: today, calendar: calendar)
            let seed = ordinal &+ moment.name.count
            hello = Self.pick(Self.hellos(hour: calendar.component(.hour, from: now), name: name), seed)
            lines = Self.lines(for: moment, name: shortName, next: next, seed: seed)
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

    /// Each with the name and without it, so a language can put the name
    /// where it reads naturally.
    private static func hellos(hour: Int, name: String?) -> [String] {
        switch hour {
        case 5..<12:
            return name.map {
                [String(localized: "Good morning, \($0)", comment: "Train greeting with the user's name"),
                 String(localized: "Morning, \($0)", comment: "Train greeting with the user's name"),
                 String(localized: "Hello, \($0)", comment: "Train greeting with the user's name")]
            } ?? [String(localized: "Good morning", comment: "Train greeting"),
                  String(localized: "Morning", comment: "Train greeting"),
                  String(localized: "Hello", comment: "Train greeting")]
        case 12..<17:
            return name.map {
                [String(localized: "Good afternoon, \($0)", comment: "Train greeting with the user's name"),
                 String(localized: "Hey, \($0)", comment: "Train greeting with the user's name"),
                 String(localized: "Hello, \($0)", comment: "Train greeting with the user's name")]
            } ?? [String(localized: "Good afternoon", comment: "Train greeting"),
                  String(localized: "Hey", comment: "Train greeting"),
                  String(localized: "Hello", comment: "Train greeting")]
        case 17..<22:
            return name.map {
                [String(localized: "Good evening, \($0)", comment: "Train greeting with the user's name"),
                 String(localized: "Evening, \($0)", comment: "Train greeting with the user's name"),
                 String(localized: "Hello, \($0)", comment: "Train greeting with the user's name")]
            } ?? [String(localized: "Good evening", comment: "Train greeting"),
                  String(localized: "Evening", comment: "Train greeting"),
                  String(localized: "Hello", comment: "Train greeting")]
        default:
            return name.map {
                [String(localized: "Hello, \($0)", comment: "Train greeting with the user's name"),
                 String(localized: "Hi, \($0)", comment: "Train greeting with the user's name"),
                 String(localized: "Still up, \($0)?", comment: "Train greeting late at night, with the user's name")]
            } ?? [String(localized: "Hello", comment: "Train greeting"),
                  String(localized: "Hi", comment: "Train greeting"),
                  String(localized: "Still up?", comment: "Train greeting late at night")]
        }
    }

    private static func lines(for moment: Moment, name: String?, next: String?, seed: Int) -> [String] {
        let day = next.map(sessionName)
        let ask = day.map {
            [String(localized: "\($0) today?", comment: "A split's day: “Push day today?”"),
             String(localized: "Ready for \($0)?", comment: "A split's day: “Ready for Push day?”"),
             String(localized: "\($0) is up next.", comment: "A split's day: “Push day is up next.”")]
        } ?? [String(localized: "What are we training today?"), String(localized: "What's on today?"),
              String(localized: "Pick a group to start.")]
        // The first line follows a hello that already said the name.
        func first(_ options: [String]) -> String { pick(options, seed, 1) }
        func last(_ options: [String]) -> String { pick(options, seed, 2) }
        switch moment {
        case .firstWorkout:
            return [first([String(localized: "Welcome to MUSQ."), String(localized: "Let's log your first workout."),
                           String(localized: "Every routine starts here.")]),
                    last([String(localized: "Pick a group below to start."), String(localized: "Your first set starts here."),
                          String(localized: "Tap a group to begin.")])]
        case .doneToday(let sets):
            // Usually plays without a hello (the workout is completed later
            // in the day), so it can take the name.
            let done = name.map { String(localized: "Workout done. Nice work, \($0)!", comment: "With the user's name") }
                ?? String(localized: "Workout done. Nice work!")
            let count = sets == 1 ? String(localized: "1 set today. Strong work.")
                : String(localized: "\(sets) sets today. Strong work.")
            return [first([done, String(localized: "That's a wrap for today."), count,
                           String(localized: "Another one in the books."), String(localized: "Done and dusted!")]),
                    last([String(localized: "Rest up. You earned it."), String(localized: "Recovery starts now."),
                          String(localized: "See you next session."), String(localized: "Eat well, sleep well.")])]
        case .inProgress(let sets):
            let count = sets == 1 ? String(localized: "1 set in. Keep going!")
                : String(localized: "\(sets) sets in. Keep going!")
            return [first([count, String(localized: "Nice pace. Keep it up."), String(localized: "You're in the zone.")]),
                    last([String(localized: "Finish strong."), String(localized: "One set at a time."),
                          String(localized: "Keep it rolling.")])]
        case .planned(let groups):
            return [first([String(localized: "\(phrase(groups, capitalized: true)) on the plan today.",
                                  comment: "The muscle groups planned: “Chest & abs on the plan today.”"),
                           String(localized: "Your workout's ready."),
                           String(localized: "\(phrase(groups, capitalized: true)) today. Let's go.",
                                  comment: "The muscle groups planned: “Chest & abs today. Let's go.”")]),
                    last([String(localized: "Ready when you are."), String(localized: "The first set's the hardest."),
                          String(localized: "Time to move.")])]
        case .yesterday(let groups):
            let named = (1...2).contains(groups.count)
                ? [String(localized: "Yesterday: \(phrase(groups)). Nice!",
                          comment: "The muscle groups trained: “Yesterday: chest & abs. Nice!”"),
                   String(localized: "Yesterday's \(phrase(groups))? Solid.",
                          comment: "The muscle groups trained: “Yesterday's chest & abs? Solid.”")]
                : [String(localized: "Big session yesterday. Solid.")]
            return [first([String(localized: "Great session yesterday."), String(localized: "Strong one yesterday!")] + named),
                    last(ask)]
        case .rested(let days):
            return [first([String(localized: "\(days) days of rest. Feeling fresh?"), String(localized: "Feeling recharged?"),
                           String(localized: "Good to see you again.")]),
                    last(ask)]
        case .comeback(let days):
            return [first([String(localized: "Welcome back!"), String(localized: "It's been \(days) days. Missed you!"),
                           String(localized: "Every comeback starts with one set.")]),
                    last(day.map {
                        [String(localized: "Ease in with \($0)?", comment: "A split's day: “Ease in with Leg day?”"),
                         String(localized: "Start light with \($0)?", comment: "A split's day: “Start light with Leg day?”")]
                    } ?? [String(localized: "Let's start light today."), String(localized: "One workout at a time.")])]
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
            case -1:
                title = String(localized: "Yesterday")
                plain = String(localized: "yesterday", comment: "A day inside a sentence: “Trained yesterday”")
                on = plain
            case 1:
                title = String(localized: "Tomorrow", comment: "A day opening a sentence")
                plain = String(localized: "tomorrow", comment: "A day inside a sentence: “Planning tomorrow?”")
                on = plain
            case -6...6:
                title = day.formatted(.dateTime.weekday(.wide)); plain = title
                on = String(localized: "on \(title)", comment: "A day inside a sentence: “on Wednesday”, “on Mon 21 Sep”")
            default:
                title = day.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
                plain = title
                on = String(localized: "on \(title)", comment: "A day inside a sentence: “on Wednesday”, “on Mon 21 Sep”")
            }
        }
    }

    private static func pastLines(_ session: WorkoutSession?, when: When, seed: Int) -> [String] {
        if let session, session.hasCompletedSets {
            let groups = trained(session)
            let sets = session.completedSetCount
            return [pick([String(localized: "Trained \(phrase(groups)) \(when.on).",
                                 comment: "Muscle groups, then the day: “Trained chest & abs on Wednesday.”"),
                          String(localized: "\(when.title): \(phrase(groups)).",
                                 comment: "A day, then its muscle groups: “Wednesday: chest & abs.”"),
                          String(localized: "\(phrase(groups, capitalized: true)) \(when.on). Nice!",
                                 comment: "Muscle groups, then the day: “Chest & abs on Wednesday. Nice!”")], seed, 1),
                    pick([sets == 1 ? String(localized: "1 set logged. Nice work!")
                            : String(localized: "\(sets) sets logged. Nice work!"),
                          String(localized: "Solid session."), String(localized: "Every set counts."),
                          String(localized: "That one paid off.")], seed, 2)]
        }
        if let session, !session.groups.isEmpty {
            return [pick([String(localized: "\(when.title)'s plan: \(phrase(session.groups)).",
                                 comment: "A day, then the muscle groups planned: “Wednesday's plan: chest & abs.”"),
                          String(localized: "\(when.title): \(phrase(session.groups)) planned.",
                                 comment: "A day, then the muscle groups planned: “Wednesday: chest & abs planned.”")],
                         seed, 1),
                    pick([String(localized: "Trained it? Log your sets below."),
                          String(localized: "Did you train? Log it below.")], seed, 2)]
        }
        return [pick([String(localized: "Nothing logged \(when.on).", comment: "A day: “Nothing logged on Wednesday.”"),
                      String(localized: "\(when.title) was a rest day.", comment: "A day: “Wednesday was a rest day.”"),
                      String(localized: "A quiet day \(when.on).", comment: "A day: “A quiet day on Wednesday.”")], seed, 1),
                pick([String(localized: "Trained that day? Log it below."), String(localized: "Rest days count too."),
                      String(localized: "Recovery is training too.")], seed, 2)]
    }

    private static func futureLines(_ session: WorkoutSession?, when: When, next: String?, seed: Int) -> [String] {
        if let session, !session.groups.isEmpty {
            return [pick([String(localized: "\(phrase(session.groups, capitalized: true)) planned for \(when.plain).",
                                 comment: "Muscle groups, then the day: “Chest & abs planned for Wednesday.”"),
                          String(localized: "\(when.title): \(phrase(session.groups)).",
                                 comment: "A day, then its muscle groups: “Wednesday: chest & abs.”")], seed, 1),
                    pick([String(localized: "Looking good."), String(localized: "Future you says thanks."),
                          String(localized: "Plan ahead, show up ready.")], seed, 2)]
        }
        return [pick([String(localized: "What's the plan for \(when.plain)?", comment: "A day: “What's the plan for Wednesday?”"),
                      String(localized: "Planning \(when.plain)?", comment: "A day: “Planning Wednesday?”"),
                      String(localized: "Looking ahead to \(when.plain)?", comment: "A day: “Looking ahead to Wednesday?”")],
                     seed, 1),
                pick(next.map(sessionName).map {
                    [String(localized: "How about \($0)?", comment: "A split's day: “How about Push day?”"),
                     String(localized: "\($0) fits \(when.plain).", comment: "A split's day, then a day: “Push day fits Wednesday.”"),
                     String(localized: "\($0) looks right.", comment: "A split's day: “Push day looks right.”")]
                } ?? [String(localized: "What will you train?"), String(localized: "Pick a group to plan it.")], seed, 2)]
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
        // The split's name is already in the current language; only the
        // English "Legs" turns into "Leg" here.
        let name = split.hasPrefix("Legs") ? "Leg\(split.dropFirst(4))" : split
        return String(localized: "\(name) day", comment: "A split's day inside a sentence: “Push day”, “Leg A day”")
    }

    /// "biceps", "chest & abs", "3 groups". In a pair, Abs & Core is just
    /// "abs", so the ampersands don't stack.
    private static func phrase(_ groups: [MuscleGroup], capitalized: Bool = false) -> String {
        let text: String
        switch groups.count {
        case 0: text = String(localized: "your workout", comment: "Stands in for the muscle groups inside a sentence")
        case 1: text = groups[0].title.lowercased()
        case 2:
            let names = groups.map {
                $0 == .abs ? String(localized: "abs", comment: "Abs & Core in a pair of groups: “chest & abs”")
                    : $0.title.lowercased()
            }
            text = String(localized: "\(names[0]) & \(names[1])",
                          comment: "Adds the last muscle to a list: “chest & abs”, “Lats, upper back & lower back”")
        default: text = String(localized: "\(groups.count) groups", comment: "Three or more muscle groups inside a sentence")
        }
        return capitalized ? text.prefix(1).uppercased() + text.dropFirst() : text
    }

    /// One of `options` for the day's seed. Each line of a sequence passes
    /// its own `slot`, so lines don't move in step and repeat each other.
    private static func pick(_ options: [String], _ seed: Int, _ slot: Int = 0) -> String {
        var mixed = UInt64(truncatingIfNeeded: seed &* 3 &+ slot) &* 0x9E37_79B9_7F4A_7C15
        mixed ^= mixed >> 29
        return options[Int(mixed % UInt64(options.count))]
    }
}
