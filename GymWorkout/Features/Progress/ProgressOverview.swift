//
//  ProgressOverview.swift
//  GymWorkout
//
//  Progress tab, layout B (2026-11-22): the page split into Overview · Body ·
//  Strength. Overview holds the week recap, the weekly volume chart and the
//  consistency grid, then Apple Health's steps and sleep (phase 2,
//  2026-11-22: Features/Health/HealthTrendCards.swift); Strength opens with
//  the key lifts' estimated maxes.
//

import SwiftUI
import Charts

enum ProgressSection: String, CaseIterable, Hashable {
    case overview, body, strength

    var title: String {
        switch self {
        case .overview: return String(localized: "OVERVIEW", comment: "Progress tab section picker")
        case .body: return String(localized: "BODY", comment: "Progress tab section picker")
        case .strength: return String(localized: "STRENGTH", comment: "Progress tab section picker")
        }
    }
}

// MARK: - Numbers

/// The Progress numbers, worked out once per pass: sessions are bucketed by
/// week up front, so the weekly figures, the chart and the streak are lookups.
struct ProgressInsights {
    struct Week: Identifiable {
        let start: Date
        let workouts: Int
        let sets: Int
        /// Kilograms.
        let volume: Double
        var id: Date { start }
    }

    struct KeyLift: Identifiable {
        let name: String
        /// Best estimated max per day inside the window, oldest first, in kilograms.
        let points: [(day: Date, value: Double)]
        var current: Double { points.last?.value ?? 0 }
        /// Latest against the first day inside the window, in kilograms.
        var change: Double { (points.last?.value ?? 0) - (points.first?.value ?? 0) }
        let newRecord: Bool
        var id: String { name }
    }

    /// Weeks the key lifts look back over.
    static let liftWindowWeeks = 8

    /// Lifts whose logged weight is the machine's counterweight, so less is
    /// stronger: an estimated max or a "record" on them reads backwards.
    /// (Assisted Pistol Squat and Assisted Nordic Curl are bodyweight/band,
    /// logged without a load.)
    static let counterweightLifts: Set<String> = ["Assisted Dip", "Machine Pull-Up"]

    let sessions: [WorkoutSession]
    /// Workouts a week from the plan — the training days picked, else the
    /// days per week — the number Today counts against. Nil when the profile
    /// sets neither; a streak then counts weeks with any workout.
    let goal: Int?
    let now: Date
    private let calendar: Calendar
    private let byWeek: [Date: Week]

    init(sessions: [WorkoutSession], profile: UserProfile?, now: Date = Date(), calendar: Calendar = .current) {
        let logged = sessions.filter(\.hasCompletedSets)
        self.sessions = logged
        self.now = now
        self.calendar = calendar
        let planned = profile?.weekdays?.count ?? profile?.daysPerWeek ?? 0
        goal = planned > 0 ? planned : nil
        var buckets: [Date: Week] = [:]
        for session in logged {
            guard let start = calendar.dateInterval(of: .weekOfYear, for: session.day)?.start else { continue }
            let week = buckets[start]
            buckets[start] = Week(start: start, workouts: (week?.workouts ?? 0) + 1,
                                  sets: (week?.sets ?? 0) + session.completedSetCount,
                                  volume: (week?.volume ?? 0) + session.volume)
        }
        byWeek = buckets
    }

    /// What a week needs to count toward the streak.
    var weeklyTarget: Int { goal ?? 1 }

    var today: Date { calendar.startOfDay(for: now) }

    func weekInterval(_ offset: Int) -> DateInterval {
        let date = calendar.date(byAdding: .weekOfYear, value: offset, to: now) ?? now
        return calendar.dateInterval(of: .weekOfYear, for: date) ?? DateInterval(start: date, duration: 0)
    }

    /// Half-open: a week's `end` is the next week's first day at 00:00 — the
    /// very `day` of a workout on that day — which `DateInterval.contains`
    /// would count in both weeks.
    static func contains(_ interval: DateInterval, _ day: Date) -> Bool {
        day >= interval.start && day < interval.end
    }

    func week(_ offset: Int) -> Week {
        let start = weekInterval(offset).start
        return byWeek[start] ?? Week(start: start, workouts: 0, sets: 0, volume: 0)
    }

    /// The last `count` weeks, oldest first, this week last.
    func weeks(_ count: Int) -> [Week] {
        (0..<count).reversed().map { week(-$0) }
    }

    /// Last week up to the same weekday as today, so a week in progress is
    /// set against the same days rather than a whole week.
    var lastWeekToDate: Week {
        let interval = weekInterval(-1)
        let cutoff = calendar.date(byAdding: .day, value: -6, to: today) ?? today
        let days = sessions.filter { $0.day >= interval.start && $0.day < cutoff }
        return Week(start: interval.start, workouts: days.count,
                    sets: days.reduce(0) { $0 + $1.completedSetCount },
                    volume: days.reduce(0) { $0 + $1.volume })
    }

    var trainedDays: Set<Date> {
        Set(sessions.map { calendar.startOfDay(for: $0.day) })
    }

    /// Weeks in a row that met the goal. This week counts once it is met;
    /// until then the run is counted up to last week, so it isn't broken mid-week.
    var streak: Int {
        let target = weeklyTarget
        var offset = week(0).workouts >= target ? 0 : -1
        var run = 0
        while week(offset).workouts >= target, run < 520 {
            run += 1
            offset -= 1
        }
        return run
    }

    /// Exercises with a record set this week, by name.
    var newRecordsThisWeek: [String] {
        let interval = weekInterval(0)
        let thisWeek = sessions.filter { Self.contains(interval, $0.day) }
        let names = Set(thisWeek.flatMap { $0.exercises.filter { !$0.completedSets.isEmpty }.map(\.exerciseName) })
            .subtracting(Self.counterweightLifts)
        return names.filter { name in
            let ids = PerformanceHistory.recordSetIDs(for: name, in: sessions)
            return thisWeek.contains { session in
                session.exercises.contains {
                    $0.exerciseName == name && $0.completedSets.contains { ids.contains($0.id) }
                }
            }
        }.sorted()
    }

    /// The loaded lifts trained on the most days in the last eight weeks
    /// (at least two, so each has a trend), up to `limit`; ties go to the
    /// heavier lift. Timed holds and counterweight machines are left out.
    func keyLifts(limit: Int = 4) -> [KeyLift] {
        let windowStart = calendar.date(byAdding: .weekOfYear, value: -Self.liftWindowWeeks, to: today) ?? today
        var best: [String: [Date: Double]] = [:]
        for session in sessions where session.day >= windowStart {
            for exercise in session.exercises where !exercise.isTimed
                && !Self.counterweightLifts.contains(exercise.exerciseName) {
                for set in exercise.completedSets {
                    guard let estimate = PerformanceHistory.estimatedMax(weight: set.weight, reps: set.reps) else { continue }
                    best[exercise.exerciseName, default: [:]][session.day] =
                        max(best[exercise.exerciseName]?[session.day] ?? 0, estimate)
                }
            }
        }
        let ranked = best.filter { $0.value.count >= 2 }
            .map { name, days in
                (name: name, points: days.sorted { $0.key < $1.key }.map { (day: $0.key, value: $0.value) })
            }
            .sorted { ($0.points.count, $0.points.last?.value ?? 0, $1.name) > ($1.points.count, $1.points.last?.value ?? 0, $0.name) }
            .prefix(limit)
        let thisWeek = weekInterval(0)
        return ranked.map { lift in
            let ids = PerformanceHistory.recordSetIDs(for: lift.name, in: sessions)
            let newRecord = sessions.contains { session in
                Self.contains(thisWeek, session.day) && session.exercises.contains {
                    $0.exerciseName == lift.name && $0.completedSets.contains { ids.contains($0.id) }
                }
            }
            return KeyLift(name: lift.name, points: lift.points, newRecord: newRecord)
        }
    }
}

// MARK: - Week recap

struct WeekRecapCard: View {
    let insights: ProgressInsights
    let attention: [MuscleGroup]
    let unit: WeightUnit

    var body: some View {
        let now = insights.week(0)
        let last = insights.lastWeekToDate
        let records = insights.newRecordsThisWeek
        // Before the week's first workout every group is "behind"; the
        // headline already says nothing is in yet.
        let behind = now.workouts > 0 ? attention : []
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "THIS WEEK")
                Spacer(minLength: 8)
                MetaLine(text: "VS LAST WEEK, SAME DAYS", em: 0.08)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            Text(headline(now: now, last: last))
                .font(.ui(19, .semibold))
                .tracking(-0.3)
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            HStack(alignment: .top, spacing: 8) {
                // Out of the goal, or of what was done once it is passed — Today's "5/5".
                let outOf = insights.goal.map { max($0, now.workouts) }
                figure(String(localized: "Workouts"), value: now.workouts.formatted(),
                       unit: outOf.map { "/\($0)" },
                       spoken: outOf.map { String(localized: "\(now.workouts) of \($0)", comment: "Week recap, VoiceOver: workouts done of the goal") }
                           ?? now.workouts.formatted(),
                       delta: delta(Double(now.workouts), Double(last.workouts)))
                figure(String(localized: "Sets"), value: now.sets.formatted(), unit: nil,
                       spoken: now.sets.formatted(),
                       delta: delta(Double(now.sets), Double(last.sets)))
                let volume = StatTile.compact(unit.fromKilograms(now.volume))
                figure(String(localized: "Volume"), value: volume, unit: unit.symbol,
                       spoken: "\(volume) \(unit.symbol)",
                       delta: delta(now.volume, last.volume))
            }

            if !records.isEmpty || !behind.isEmpty {
                Hairline(opacity: 0.08)
                VStack(alignment: .leading, spacing: 10) {
                    if !records.isEmpty {
                        let shown = records.prefix(3).formatted(.list(type: .and, width: .narrow))
                        line(icon: "trophy.fill", color: DS.activation,
                             title: records.count == 1
                                ? String(localized: "1 new record")
                                : String(localized: "\(records.count) new records"),
                             detail: records.count > 3
                                ? String(localized: "\(shown) and \(records.count - 3) more", comment: "Week recap: new records list, cut after three")
                                : shown)
                    }
                    if !behind.isEmpty {
                        line(icon: "exclamationmark.circle", color: DS.rhythmRecent,
                             title: String(localized: "Behind this week"),
                             detail: behind.prefix(4).map(\.title).formatted(.list(type: .and, width: .narrow)))
                    }
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
        .accessibilityElement(children: .contain)
    }

    private func headline(now: ProgressInsights.Week, last: ProgressInsights.Week) -> String {
        if now.workouts == 0 { return String(localized: "No workouts yet this week.") }
        if let goal = insights.goal, now.workouts >= goal {
            return String(localized: "Weekly goal reached. Strong week.")
        }
        if last.sets > 0, now.sets > last.sets { return String(localized: "Ahead of last week so far.") }
        guard let goal = insights.goal else {
            return now.workouts == 1
                ? String(localized: "1 workout so far this week.")
                : String(localized: "\(now.workouts) workouts so far this week.")
        }
        let left = goal - now.workouts
        return left == 1
            ? String(localized: "1 workout left to hit your goal.")
            : String(localized: "\(left) workouts left to hit your goal.")
    }

    private func delta(_ now: Double, _ last: Double) -> Double? {
        last > 0 ? (now - last) / last : nil
    }

    private func figure(_ label: String, value: String, unit: String?, spoken: String, delta: Double?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.ui(11.5))
                .foregroundStyle(DS.silver.opacity(0.5))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.ui(21, .semibold))
                    .tracking(-0.4)
                    .foregroundStyle(DS.silver)
                if let unit {
                    Text(unit)
                        .font(.ui(11.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.45))
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            deltaText(delta)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label), \(spoken)")
        .accessibilityValue(spokenDelta(delta))
    }

    @ViewBuilder
    private func deltaText(_ delta: Double?) -> some View {
        if let delta, abs(delta) < 0.005 {
            Text("SAME", comment: "Week recap: no change against last week")
                .font(.mono(10, .semibold))
                .foregroundStyle(DS.silver.opacity(0.4))
        } else if let delta {
            let up = delta >= 0
            Text(verbatim: "\(up ? "▲" : "▼") \(abs(delta).formatted(.percent.precision(.fractionLength(0))))")
                .font(.mono(10, .semibold))
                .foregroundStyle(up ? DS.rhythmDue : DS.rhythmWaiting)
        } else {
            Text(verbatim: "—")
                .font(.mono(10, .semibold))
                .foregroundStyle(DS.silver.opacity(0.3))
        }
    }

    private func spokenDelta(_ delta: Double?) -> String {
        guard let delta else { return String(localized: "Nothing last week to compare") }
        if abs(delta) < 0.005 { return String(localized: "Same as last week") }
        let percent = abs(delta).formatted(.percent.precision(.fractionLength(0)))
        return delta > 0 ? String(localized: "Up \(percent) on last week")
                         : String(localized: "Down \(percent) on last week")
    }

    private func line(icon: String, color: Color, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 18)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.ui(13.5, .semibold))
                    .foregroundStyle(DS.silver)
                Text(detail)
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .lineLimit(2)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Weekly volume

struct WeeklyVolumeChart: View {
    let weeks: [ProgressInsights.Week]
    let unit: WeightUnit
    /// Beside the consistency grid on iPad the chart grows to the row's height.
    var fillsHeight = false

    var body: some View {
        let earlier = weeks.dropLast().map(\.volume).filter { $0 > 0 }
        let avg = earlier.isEmpty ? 0 : earlier.reduce(0, +) / Double(earlier.count)
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "WEEKLY VOLUME")
                Spacer()
                MetaLine(text: "\(weeks.count) WEEKS · \(unit.symbol.uppercased())", em: 0.08)
            }
            Chart {
                ForEach(weeks) { week in
                    BarMark(x: .value("Week", week.start, unit: .weekOfYear),
                            y: .value("Volume", unit.fromKilograms(week.volume)))
                        .foregroundStyle(week.id == weeks.last?.id ? DS.activation : DS.silver.opacity(0.28))
                        .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
                }
                if avg > 0 {
                    RuleMark(y: .value("Average", unit.fromKilograms(avg)))
                        .foregroundStyle(DS.silver.opacity(0.45))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [3, 3]))
                        .annotation(position: .top, alignment: .leading) {
                            Text("avg \(StatTile.compact(unit.fromKilograms(avg)))",
                                 comment: "Weekly volume chart: the average line's label")
                                .font(.mono(9, .semibold))
                                .foregroundStyle(DS.silver.opacity(0.5))
                        }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .weekOfYear, count: 3)) { _ in
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                        .font(.mono(9))
                        .foregroundStyle(DS.silver.opacity(0.45))
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) { value in
                    AxisGridLine().foregroundStyle(DS.silver.opacity(0.06))
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text(StatTile.compact(v)).font(.mono(9)).foregroundStyle(DS.silver.opacity(0.45))
                        }
                    }
                }
            }
            .frame(minHeight: 150, idealHeight: 150, maxHeight: fillsHeight ? .infinity : 150)
            .accessibilityElement()
            .accessibilityLabel(spoken(avg: avg))
        }
        .frame(maxWidth: .infinity, maxHeight: fillsHeight ? .infinity : nil, alignment: .topLeading)
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt))
    }

    private func spoken(avg: Double) -> String {
        let now = "\(StatTile.compact(unit.fromKilograms(weeks.last?.volume ?? 0))) \(unit.symbol)"
        guard avg > 0 else { return String(localized: "Weekly volume: \(now) this week.") }
        let average = "\(StatTile.compact(unit.fromKilograms(avg))) \(unit.symbol)"
        return String(localized: "Weekly volume: \(now) this week, against an average of \(average) a week before it.",
                      comment: "VoiceOver summary of the weekly volume chart")
    }
}

// MARK: - Consistency

struct ConsistencyGrid: View {
    let insights: ProgressInsights
    /// The weeks shown, oldest first (`ProgressInsights.weeks`), one column each.
    let weeks: [ProgressInsights.Week]
    var fillsHeight = false

    private let gap: CGFloat = 4
    private let labelWidth: CGFloat = 12

    /// Weeks that keep the squares near the phone's size in a card `width`
    /// wide (12 to 26).
    static func weekCount(forWidth width: CGFloat) -> Int {
        let inner = width - 32 - 12
        return min(26, max(12, Int((inner + 4) / 26)))
    }

    var body: some View {
        let days = insights.trainedDays
        let calendar = Calendar.current
        let today = insights.today
        let streak = insights.streak
        let target = insights.weeklyTarget
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "CONSISTENCY")
                Spacer()
                if let goal = insights.goal {
                    MetaLine(text: "GOAL \(goal)× / WEEK", em: 0.08)
                }
            }
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(streak.formatted())
                    .font(.ui(30, .semibold))
                    .tracking(-0.6)
                    .foregroundStyle(DS.silver)
                Text(streakCaption(streak))
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 4)
                Image(systemName: "flame.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(streak > 0 ? DS.activation : DS.silver.opacity(0.2))
                    .accessibilityHidden(true)
            }
            .accessibilityElement(children: .combine)
            GeometryReader { proxy in
                let count = CGFloat(max(weeks.count, 1))
                // The frame's ratio is close, not exact (the gaps), so the
                // squares take the smaller of the two fits and never spill.
                let side = max(0, min((proxy.size.width - labelWidth - gap * count) / count,
                                      (proxy.size.height - gap * 6) / 7))
                HStack(alignment: .top, spacing: gap) {
                    VStack(spacing: gap) {
                        ForEach(Array(weekdayInitials(calendar).enumerated()), id: \.offset) { _, initial in
                            Text(initial)
                                .font(.mono(8.5, .semibold))
                                .foregroundStyle(DS.silver.opacity(0.35))
                                .frame(width: labelWidth, height: side)
                        }
                    }
                    ForEach(weeks) { week in
                        let met = week.workouts >= target
                        VStack(spacing: gap) {
                            ForEach(0..<7, id: \.self) { index in
                                let day = calendar.date(byAdding: .day, value: index, to: week.start) ?? week.start
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(fill(trained: days.contains(day), future: day > today, met: met))
                                    .overlay {
                                        if day == today {
                                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                                .strokeBorder(DS.silver.opacity(0.7), lineWidth: 1)
                                        }
                                    }
                                    .frame(width: side, height: side)
                            }
                        }
                    }
                }
            }
            .aspectRatio((CGFloat(weeks.count) + labelWidth / 22) / 7, contentMode: .fit)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(gridSummary(days: days, today: today))
            HStack(spacing: 14) {
                legend(DS.activation, insights.goal == nil ? String(localized: "Trained")
                                                           : String(localized: "Trained, goal met"))
                if insights.goal != nil {
                    legend(DS.activation.opacity(0.45), String(localized: "Trained"))
                }
                legend(DS.silver.opacity(0.08), String(localized: "Rest"))
            }
            .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity, maxHeight: fillsHeight ? .infinity : nil, alignment: .topLeading)
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt))
    }

    private func streakCaption(_ streak: Int) -> String {
        if insights.goal == nil {
            return streak == 1 ? String(localized: "week in a row with a workout")
                               : String(localized: "weeks in a row with a workout")
        }
        return streak == 1 ? String(localized: "week in a row on goal")
                           : String(localized: "weeks in a row on goal")
    }

    /// One letter per row, from the locale's first weekday (M…S or S…S).
    private func weekdayInitials(_ calendar: Calendar) -> [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let first = calendar.firstWeekday - 1
        return (0..<7).map { symbols[(first + $0) % 7] }
    }

    private func gridSummary(days: Set<Date>, today: Date) -> String {
        let start = weeks.first?.start ?? today
        let trained = days.filter { $0 >= start && $0 <= today }.count
        let span = weeks.count
        let trainedText = trained == 1
            ? String(localized: "Trained on 1 day in the last \(span) weeks.")
            : String(localized: "Trained on \(trained) days in the last \(span) weeks.")
        guard insights.goal != nil else { return trainedText }
        let met = weeks.filter { $0.workouts >= insights.weeklyTarget }.count
        let metText = met == 1
            ? String(localized: "Goal met in 1 week.")
            : String(localized: "Goal met in \(met) weeks.")
        return "\(trainedText) \(metText)"
    }

    private func fill(trained: Bool, future: Bool, met: Bool) -> Color {
        if future { return DS.silver.opacity(0.03) }
        if trained { return met || insights.goal == nil ? DS.activation : DS.activation.opacity(0.45) }
        return DS.silver.opacity(0.08)
    }

    private func legend(_ color: Color, _ title: String) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 2).fill(color).frame(width: 9, height: 9)
            Text(title).font(.ui(11)).foregroundStyle(DS.silver.opacity(0.5))
        }
    }
}

// MARK: - Key lifts

struct KeyLiftsCard: View {
    let lifts: [ProgressInsights.KeyLift]
    let unit: WeightUnit
    var open: (String) -> Void

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let regular = layout.isRegular
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "KEY LIFTS")
                Spacer()
                MetaLine(text: "EST. 1RM · \(ProgressInsights.liftWindowWeeks) WEEKS", em: 0.08)
            }
            if lifts.isEmpty {
                Text("Lifts you log with a weight on two or more days in the last \(ProgressInsights.liftWindowWeeks) weeks show their estimated max here.")
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                VStack(spacing: 0) {
                    ForEach(lifts) { lift in
                        Button { open(lift.name) } label: { row(lift) }
                            .buttonStyle(.plain)
                            .dsHover(.highlight, radius: 14)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(spoken(lift))
                            .accessibilityAddTraits(.isButton)
                        if lift.id != lifts.last?.id {
                            Hairline(opacity: 0.06)
                                .padding(.horizontal, regular ? 12 : 0)
                        }
                    }
                }
                // The Personal Records card's grouping on iPad, so the two
                // cards line up and hover alike.
                .padding(regular ? 6 : 0)
                .padding(.horizontal, regular ? 0 : 14)
                .background {
                    if regular {
                        Color.clear.dsPane(radius: 20, fill: DS.surfaceAlt)
                    } else {
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt)
                    }
                }
            }
        }
    }

    private func row(_ lift: ProgressInsights.KeyLift) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                // The PR tag rides on the number line, leaving the name
                // the row's full text width.
                Text(lift.name)
                    .font(.ui(14, .semibold))
                    .foregroundStyle(DS.silver)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text(number(lift.current))
                        .font(.ui(20, .semibold))
                        .tracking(-0.4)
                        .foregroundStyle(DS.silver)
                    Text(unit.symbol)
                        .font(.ui(11.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.45))
                    if let change = shownChange(lift) {
                        Text(verbatim: "\(change > 0 ? "+" : "−")\(number(abs(change)))")
                            .font(.mono(10.5, .semibold))
                            .foregroundStyle(change > 0 ? DS.rhythmDue : DS.rhythmWaiting)
                            .padding(.leading, 4)
                    }
                    if lift.newRecord {
                        recordTag
                            .padding(.leading, 6)
                    }
                }
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            }
            Spacer(minLength: 8)
            sparkline(lift)
                .frame(width: layout.value(76, 96), height: 34)
                .accessibilityHidden(true)
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.3))
                .accessibilityHidden(true)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, layout.isRegular ? 12 : 0)
        .contentShape(Rectangle())
    }

    /// The app's PR tag (Train's set rows, the exercise page).
    private var recordTag: some View {
        let size: CGFloat = layout.isRegular ? 10 : 9
        return Text("PR", comment: "Personal-record tag on a logged set")
            .font(.mono(size, .bold))
            .trackingEm(0.08, size: size)
            .foregroundStyle(DS.silver)
            .padding(.horizontal, 6)
            .padding(.vertical, layout.isRegular ? 4 : 3)
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.5), lineWidth: 1))
            .fixedSize()
    }

    private func sparkline(_ lift: ProgressInsights.KeyLift) -> some View {
        let values = lift.points.map(\.value)
        let low = (values.min() ?? 0) * 0.97
        let high = max((values.max() ?? 1) * 1.01, low + 1)
        return Chart {
            ForEach(lift.points, id: \.day) { point in
                LineMark(x: .value("Day", point.day), y: .value("Max", point.value))
                    .interpolationMethod(.monotone)
                    .foregroundStyle(DS.activation)
                    .lineStyle(StrokeStyle(lineWidth: 1.8, lineCap: .round))
            }
            if let last = lift.points.last {
                PointMark(x: .value("Day", last.day), y: .value("Max", last.value))
                    .symbolSize(22)
                    .foregroundStyle(DS.activation)
            }
        }
        .chartYScale(domain: low...high)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }

    /// Whole units, as the exercise page shows its estimated max.
    private func number(_ kg: Double) -> String {
        Int(unit.fromKilograms(kg).rounded()).formatted()
    }

    /// The change, once it rounds to at least one whole unit.
    private func shownChange(_ lift: ProgressInsights.KeyLift) -> Double? {
        unit.fromKilograms(abs(lift.change)).rounded() >= 1 ? lift.change : nil
    }

    private func spoken(_ lift: ProgressInsights.KeyLift) -> String {
        let value = unit.total(lift.current)
        var parts = [lift.name, String(localized: "estimated max \(value)", comment: "Key lifts, VoiceOver")]
        if let change = shownChange(lift) {
            let amount = unit.total(abs(change))
            parts.append(change > 0
                ? String(localized: "up \(amount) in \(ProgressInsights.liftWindowWeeks) weeks")
                : String(localized: "down \(amount) in \(ProgressInsights.liftWindowWeeks) weeks"))
        }
        if lift.newRecord { parts.append(String(localized: "new record this week")) }
        return parts.joined(separator: ", ")
    }
}
