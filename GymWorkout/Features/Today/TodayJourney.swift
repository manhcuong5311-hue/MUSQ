//
//  TodayJourney.swift
//  GymWorkout
//
//  The journey line at the top of Today (2026-11-27, the owner's UX
//  overhaul): a path of days from where the member started toward the goal.
//  Each day is a node — filled once that day's actions were all done, a
//  partial ring otherwise, today lifted and lit. A tap on a day opens a
//  small panel under the line: today's undone actions as big rows that do
//  them (a glass of water, a meal, the workout, the weigh-in, a walk); a
//  past day's misses, read only. Without a weight goal it shows the last
//  14 days and the next 7.
//
//  Worked out on the phone from what Today already reads; nothing is sent.
//

import SwiftUI

// MARK: - Model

/// One action a day can ask for.
enum JourneyItem: Hashable, CaseIterable {
    case water, meals, workout, weighIn, steps

    var symbol: String {
        switch self {
        case .water: return "drop.fill"
        case .meals: return "fork.knife"
        case .workout: return "dumbbell.fill"
        case .weighIn: return "scalemass.fill"
        case .steps: return "figure.walk"
        }
    }

    var tint: Color {
        switch self {
        case .water: return TodayTone.water
        case .meals: return JourneyPalette.meals
        case .workout: return TodayTone.workout
        case .weighIn: return TodayTone.violet
        case .steps: return JourneyPalette.walk
        }
    }

    /// What the row says when it's still to do today.
    var todo: String {
        switch self {
        case .water: return String(localized: "Drink water", comment: "Journey: today's undone action")
        case .meals: return String(localized: "Log a meal", comment: "Journey: today's undone action")
        case .workout: return String(localized: "Train", comment: "Journey: today's undone action, the workout")
        case .weighIn: return String(localized: "Weigh in", comment: "Journey: today's undone action")
        case .steps: return String(localized: "Walk", comment: "Journey: today's undone action, steps")
        }
    }

    /// Its name in a list of what was done or missed.
    var name: String {
        switch self {
        case .water: return String(localized: "Water", comment: "Journey: an action's name")
        case .meals: return String(localized: "Meals", comment: "Journey: an action's name")
        case .workout: return String(localized: "Workout", comment: "Journey: an action's name")
        case .weighIn: return String(localized: "Weigh-in", comment: "Journey: an action's name")
        case .steps: return String(localized: "Steps", comment: "Journey: an action's name")
        }
    }
}

enum JourneyPalette {
    /// The line and the filled nodes: violet into pink, apart from Train's
    /// recovery colours and the muscles' orange.
    static let start = TodayTone.violet
    static let end = TodayTone.pink
    static let meals = Color(light: 0xD97706, dark: 0xFBBF24)
    static let walk = Color(light: 0x16A34A, dark: 0x4ADE80)
    static var gradient: LinearGradient {
        LinearGradient(colors: [start, end], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct JourneyDay: Identifiable, Equatable {
    let date: Date
    let isToday: Bool
    let isFuture: Bool
    /// Before anything was logged here: neither done nor missed.
    let beforeStart: Bool
    /// A training day on the member's schedule.
    let scheduled: Bool
    var done: [JourneyItem] = []
    var missed: [JourneyItem] = []
    var id: Date { date }

    var total: Int { done.count + missed.count }
    var progress: Double { total == 0 ? 0 : Double(done.count) / Double(total) }
    var allDone: Bool { total > 0 && missed.isEmpty }
}

/// The days on the line and where it's heading.
struct Journey {
    let days: [JourneyDay]
    /// "Lose 4 kg · around 16 Jan 2027", when the plan has a weight goal.
    let goalLine: String?
    let goalDate: Date?

    init(store: WorkoutStore, daily: DailyStore, health: AppleHealth, metrics m: TodayMetrics, plan: NutritionPlan?) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: m.now)
        let firstSession = store.sessions.filter(\.hasCompletedSets).map { calendar.startOfDay(for: $0.day) }.min()
        let first = [daily.firstLogDay, firstSession].compactMap { $0 }.min()
        let goalLine = plan.flatMap { TodayView.goalLine($0, unit: store.unit) }
        let goalDate = goalLine == nil ? nil : plan?.targetDate(from: m.now)
        // From the start (up to 45 days back) toward the goal; without one,
        // the last two weeks.
        let past: Int
        if goalLine != nil, let first {
            let since = calendar.dateComponents([.day], from: first, to: today).day ?? 0
            past = min(45, max(6, since))
        } else {
            past = 14
        }
        let future = 7
        let profile = store.profile
        let trained = Set(store.trainedDays.map { calendar.startOfDay(for: $0) })
        var steps: [Date: Int] = [:]
        if m.showsHealth {
            for day in health.allDailySteps { steps[calendar.startOfDay(for: day.day)] = Int(day.value.rounded()) }
        }

        var days: [JourneyDay] = []
        for offset in -past...future {
            guard let date = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
            // The schedule decides, dates set by hand included.
            let isScheduled: Bool
            if case .train = ProgramAdvisor.plan(on: date, profile: profile, calendar: calendar) { isScheduled = true } else { isScheduled = false }
            var day = JourneyDay(date: date, isToday: offset == 0, isFuture: offset > 0,
                                 beforeStart: offset < 0 && (first.map { date < $0 } ?? true),
                                 scheduled: isScheduled)
            if offset == 0 {
                func add(_ item: JourneyItem, counts: Bool, done: Bool) {
                    guard counts else { return }
                    if done { day.done.append(item) } else { day.missed.append(item) }
                }
                add(.water, counts: m.waterCounts, done: m.waterReached)
                // Meals count when logged, never as a miss: the dock's "your
                // day" (water, workout, weigh-in) doesn't ask for them, and a
                // member who doesn't log food still fills the day.
                let ate = !daily.meals(on: m.now).isEmpty || daily.checkIn(on: m.now) != nil
                add(.meals, counts: ate, done: ate)
                add(.workout, counts: m.workoutCounts || m.workoutDone, done: m.workoutDone)
                add(.weighIn, counts: m.weighInCounts || m.weighedIn, done: m.weighedIn)
                add(.steps, counts: m.showsHealth && m.stepsToday != nil, done: m.stepsReached)
            } else if offset < 0 && !day.beforeStart {
                let noon = date.addingTimeInterval(12 * 3600)
                if m.waterCounts {
                    if daily.waterDrunk(on: noon) >= m.waterTarget { day.done.append(.water) } else { day.missed.append(.water) }
                }
                if !daily.meals(on: noon).isEmpty || daily.checkIn(on: noon) != nil {
                    day.done.append(.meals)
                }
                if trained.contains(date) {
                    day.done.append(.workout)
                } else if isScheduled {
                    day.missed.append(.workout)
                }
                // A skipped weigh-in is never a miss (a few mornings a week).
                if daily.weighedIn(on: noon) { day.done.append(.weighIn) }
                if let count = steps[date] {
                    if count >= m.stepsGoal { day.done.append(.steps) } else { day.missed.append(.steps) }
                }
            }
            days.append(day)
        }
        self.days = days
        self.goalLine = goalLine
        self.goalDate = goalDate
    }

    var today: JourneyDay? { days.first(where: \.isToday) }

    /// Days in a row, ending yesterday or today, with every action done.
    var streak: Int {
        var count = 0
        for day in days.reversed() where !day.isFuture {
            if day.isToday && !day.allDone { continue }
            guard day.allDone else { break }
            count += 1
        }
        return count
    }
}

// MARK: - The line

struct JourneyLine: View {
    var journey: Journey
    var metrics: TodayMetrics
    var actions: TodayActions

    @State private var selected: Date?
    @Environment(\.colorScheme) private var scheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .body) private var node: CGFloat = 30

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(Array(journey.days.enumerated()), id: \.element.id) { index, day in
                            if index > 0 {
                                connector(from: journey.days[index - 1], to: day)
                            }
                            dayNode(day)
                                .id(day.id)
                        }
                        if journey.goalLine != nil {
                            connector(from: journey.days.last, to: nil, dashed: true)
                            goalNode
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 6)
                }
                .onAppear {
                    if let today = journey.today?.id { proxy.scrollTo(today, anchor: .center) }
                }
            }
            if let selected, let day = journey.days.first(where: { $0.id == selected }) {
                JourneyDayPanel(day: day, metrics: metrics, actions: actions) {
                    withAnimation(.snappy) { self.selected = nil }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(DS.surface)
            .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.05), radius: 16, y: 6))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous)
            .strokeBorder(DS.silver.opacity(scheme == .dark ? 0.08 : 0.04), lineWidth: 1))
        .animation(reduceMotion ? nil : .snappy, value: selected)
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text("Your journey", comment: "Today: the line of days toward the goal")
                .font(.ui(17, .bold))
                .foregroundStyle(DS.silver)
                .accessibilityAddTraits(.isHeader)
            if journey.streak >= 2 {
                Label {
                    Text("\(journey.streak) days", comment: "Journey: days in a row with everything done")
                } icon: {
                    Image(systemName: "flame.fill")
                }
                .font(.ui(12.5, .semibold))
                .foregroundStyle(JourneyPalette.end)
                .accessibilityLabel(String(localized: "\(journey.streak) days in a row, all done",
                                           comment: "Journey streak for VoiceOver"))
            }
            Spacer(minLength: 8)
            Text(journey.goalLine ?? String(localized: "Last 2 weeks", comment: "Journey without a goal: the span shown"))
                .font(.ui(12.5, .semibold))
                .foregroundStyle(DS.silver.opacity(0.6))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }

    // MARK: Pieces

    private func connector(from: JourneyDay?, to: JourneyDay?, dashed: Bool = false) -> some View {
        let lit = (from?.allDone ?? false) && (to?.allDone ?? false)
        return ZStack {
            if dashed || to?.isFuture == true {
                JourneyDashLine()
                    .stroke(DS.silver.opacity(0.22), style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 4]))
            } else {
                Capsule()
                    .fill(lit ? AnyShapeStyle(JourneyPalette.gradient) : AnyShapeStyle(DS.silver.opacity(0.14)))
                    .frame(height: 3)
            }
        }
        .frame(width: 12, height: 3)
        .padding(.top, node / 2 + 5 - 1.5)
        .accessibilityHidden(true)
    }

    private func dayNode(_ day: JourneyDay) -> some View {
        let size = day.isToday ? node + 10 : node
        let isSelected = selected == day.id
        return Button {
            withAnimation(.snappy) { selected = isSelected ? nil : day.id }
        } label: {
            VStack(spacing: 5) {
                ZStack {
                    nodeFace(day, size: size)
                }
                .frame(width: node + 10, height: node + 10)
                .overlay {
                    if isSelected {
                        Circle().strokeBorder(DS.silver.opacity(0.7), lineWidth: 1.5)
                            .frame(width: size + 8, height: size + 8)
                    }
                }
                Text(day.isToday ? String(localized: "Today") : day.date.formatted(.dateTime.weekday(.narrow)))
                    .font(.mono(9.5, day.isToday ? .bold : .semibold))
                    .textCase(.uppercase)
                    .foregroundStyle(DS.silver.opacity(day.isToday ? 1 : 0.5))
                    .lineLimit(1)
                    .fixedSize()
            }
            .frame(minWidth: node + 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(spoken(day))
        .accessibilityHint(day.isFuture ? "" : String(localized: "Shows what's left that day", comment: "Journey day hint"))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private func nodeFace(_ day: JourneyDay, size: CGFloat) -> some View {
        let number = day.date.formatted(.dateTime.day())
        if day.isFuture {
            Circle()
                .strokeBorder(DS.silver.opacity(0.18), style: StrokeStyle(lineWidth: 1.5, dash: [2, 3]))
                .frame(width: size * 0.8, height: size * 0.8)
                .overlay {
                    if day.scheduled {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: size * 0.28, weight: .bold))
                            .foregroundStyle(DS.silver.opacity(0.35))
                    } else {
                        Text(number).font(.ui(size * 0.34, .semibold)).foregroundStyle(DS.silver.opacity(0.35))
                    }
                }
        } else if day.allDone {
            Circle()
                .fill(JourneyPalette.gradient)
                .frame(width: size, height: size)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.system(size: size * 0.4, weight: .heavy))
                        .foregroundStyle(.white)
                }
                .shadow(color: JourneyPalette.end.opacity(day.isToday ? 0.45 : 0.2), radius: day.isToday ? 10 : 4)
        } else if day.beforeStart || day.total == 0 {
            Circle()
                .fill(DS.silver.opacity(0.06))
                .frame(width: size * 0.8, height: size * 0.8)
                .overlay { Text(number).font(.ui(size * 0.34, .semibold)).foregroundStyle(DS.silver.opacity(0.35)) }
        } else {
            ZStack {
                Circle().fill(day.isToday ? JourneyPalette.start.opacity(0.14) : Color.clear)
                Ring(progress: day.progress, color: day.isToday ? JourneyPalette.end : JourneyPalette.start,
                     lineWidth: day.isToday ? 4 : 3)
                Text(number)
                    .font(.ui(size * 0.36, .bold))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver.opacity(day.isToday ? 1 : 0.7))
            }
            .frame(width: size, height: size)
            .shadow(color: day.isToday ? JourneyPalette.end.opacity(0.35) : .clear, radius: 8)
        }
    }

    private var goalNode: some View {
        VStack(spacing: 5) {
            Image(systemName: "flag.checkered")
                .font(.system(size: node * 0.42, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: node + 6, height: node + 6)
                .background(Circle().fill(JourneyPalette.gradient))
                .frame(width: node + 10, height: node + 10)
            Text(journey.goalDate.map { $0.formatted(.dateTime.day().month(.abbreviated)) }
                 ?? String(localized: "Goal", comment: "Journey: the goal at the end of the line"))
                .font(.mono(9.5, .bold))
                .textCase(.uppercase)
                .foregroundStyle(DS.silver)
                .lineLimit(1)
                .fixedSize()
        }
        .padding(.leading, 2)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(journey.goalLine ?? String(localized: "Goal"))
    }

    private func spoken(_ day: JourneyDay) -> String {
        let date = day.isToday ? String(localized: "Today") : day.date.formatted(.dateTime.weekday(.wide).day().month(.wide))
        if day.isFuture || day.beforeStart || day.total == 0 { return date }
        return String(localized: "\(date): \(day.done.count) of \(day.total) done",
                      comment: "Journey day for VoiceOver: Tuesday 24 November: 2 of 3 done")
    }
}

private struct JourneyDashLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

// MARK: - A day's panel

/// Under the line, for the day tapped: today's undone actions as big rows
/// that do them, what's done as small ticks; a past day's misses, read only.
struct JourneyDayPanel: View {
    var day: JourneyDay
    var metrics: TodayMetrics
    var actions: TodayActions
    var onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(day.isToday ? String(localized: "Left today", comment: "Journey panel title: today's undone actions")
                     : day.date.formatted(.dateTime.weekday(.wide).day().month(.abbreviated)))
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                Spacer(minLength: 8)
                if day.total > 0 {
                    Text("\(day.done.count) of \(day.total) done", comment: "Today's habits: 1 of 3 done")
                        .font(.ui(12.5, .semibold))
                        .monospacedDigit()
                        .foregroundStyle(DS.silver.opacity(0.6))
                }
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(localized: "Close"))
            }
            if day.isFuture {
                Text(day.scheduled ? String(localized: "A training day on your schedule.")
                                   : String(localized: "Rest day on your schedule. A walk still counts, and you can train any day."))
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
            } else if day.beforeStart || day.total == 0 {
                Text("Nothing logged this day.", comment: "Journey panel: a day with nothing to show")
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.65))
            } else if day.isToday {
                if day.missed.isEmpty {
                    Label(String(localized: "All done today. Nice work.", comment: "Journey panel: everything done today"),
                          systemImage: "checkmark.seal.fill")
                        .font(.ui(14.5, .semibold))
                        .foregroundStyle(JourneyPalette.end)
                }
                ForEach(day.missed, id: \.self) { item in
                    actionRow(item)
                }
                if !day.done.isEmpty { doneLine(day.done) }
            } else {
                ForEach(day.missed, id: \.self) { item in
                    HStack(spacing: 10) {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(DS.silver.opacity(0.45))
                        Image(systemName: item.symbol)
                            .foregroundStyle(item.tint.opacity(0.7))
                            .frame(width: 20)
                        Text(item.name)
                            .foregroundStyle(DS.silver.opacity(0.75))
                        Spacer(minLength: 0)
                        Text("Missed", comment: "Journey panel: an action not done on a past day")
                            .font(.ui(12.5, .medium))
                            .foregroundStyle(DS.silver.opacity(0.45))
                    }
                    .font(.ui(14.5, .medium))
                    .frame(minHeight: 32)
                    .accessibilityElement(children: .combine)
                }
                if !day.done.isEmpty { doneLine(day.done) }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.silver.opacity(0.05)))
    }

    private func doneLine(_ items: [JourneyItem]) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(JourneyPalette.end)
            Text(items.map(\.name).formatted(.list(type: .and)))
                .foregroundStyle(DS.silver.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
        }
        .font(.ui(13, .medium))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(localized: "Done: \(items.map(\.name).formatted(.list(type: .and)))",
                                   comment: "Journey panel: what's done, for VoiceOver"))
    }

    /// A big row that does the action at once (water) or opens where it's done.
    private func actionRow(_ item: JourneyItem) -> some View {
        let glass = metrics.waterPresets.first ?? 250
        return Button {
            switch item {
            case .water: actions.addWater(glass)
            case .meals: actions.openFood()
            case .workout: actions.openTrain()
            case .weighIn: actions.logWeight()
            case .steps: actions.quickLog(.steps)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.symbol)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(item.tint))
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.todo)
                        .font(.ui(16, .semibold))
                        .foregroundStyle(DS.silver)
                    if let detail = detail(item) {
                        Text(detail)
                            .font(.ui(12.5, .medium))
                            .monospacedDigit()
                            .foregroundStyle(DS.silver.opacity(0.6))
                    }
                }
                Spacer(minLength: 8)
                Text(trailing(item, glass: glass))
                    .font(.ui(14, .semibold))
                    .monospacedDigit()
                    .foregroundStyle(item.tint)
                    .padding(.horizontal, 12)
                    .frame(height: 34)
                    .background(Capsule().fill(item.tint.opacity(0.14)))
            }
            .padding(.vertical, 6)
            .frame(minHeight: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func detail(_ item: JourneyItem) -> String? {
        switch item {
        case .water:
            return "\(DailyStore.litres(metrics.waterMl)) / \(DailyStore.litres(metrics.waterTarget))"
        case .meals:
            return metrics.calories.map { String(localized: "Plan \($0.formatted()) kcal", comment: "Journey: the day's calorie target") }
        case .workout:
            return metrics.setsPlanned > 0
                ? String(localized: "\(metrics.setsDone) of \(metrics.setsPlanned) sets", comment: "Sets done today: 12 of 30 sets")
                : nil
        case .weighIn:
            return nil
        case .steps:
            return "\(HealthFormat.steps(metrics.stepsToday ?? 0)) / \(HealthFormat.steps(metrics.stepsGoal))"
        }
    }

    private func trailing(_ item: JourneyItem, glass: Int) -> String {
        switch item {
        case .water: return String(localized: "+\(glass) ml", comment: "Adds a glass of water: +250 ml")
        case .meals: return String(localized: "Log", comment: "Journey row button: log a meal")
        case .workout: return String(localized: "Go", comment: "Journey row button: open Train")
        case .weighIn: return String(localized: "Log", comment: "Weigh-in row chip: logs today's weight")
        case .steps: return String(localized: "Add", comment: "Journey row button: add a walk")
        }
    }
}
