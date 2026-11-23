//
//  BalanceProgressCard.swift
//  GymWorkout
//
//  Progress › Overview, "Balance & results" (owner-approved 2026-11-22):
//  twelve weeks of Balance over the weight trend, on one week axis, so the
//  user can see from their own weeks whether the goal moves better when
//  Train, Eat and Sleep are all good.
//
//  - Top lane: each week's Balance, the bar in the colour of that week's
//    lever (its weakest pillar); this week lighter, "so far"; paused weeks
//    a short grey bar.
//  - Bottom lane: the 7-day weight average at each week's end, in the
//    weigh-in violet, or a note when there are no weigh-ins.
//  - Your weeks: the better-balanced half of finished weeks against the
//    rest, each with the next week's weight change (weight lags habits),
//    from 8 such weeks; until then, how many are collected.
//
//  Worked out on each pass from the stores; nothing is saved.
//

import Charts
import SwiftUI

/// Builds the weeks from the stores and hands them to the card: the chart
/// shows the last 12, and "Your weeks" compares over 14, so its 12 finished
/// pairs (each week against the next finished one) can be reached.
struct BalanceProgressSection: View {
    @Environment(WorkoutStore.self) private var store
    @Environment(DailyStore.self) private var daily
    @Environment(AppleHealth.self) private var health

    var body: some View {
        let plan = BalanceBuilder.plan(store: store, health: health)
        let goal = BalanceBuilder.goal(store: store, plan: plan)
        let all = BalanceScore.history(BalanceBuilder.inputs(store: store, daily: daily, health: health, plan: plan),
                                       weeks: 14)
        BalanceProgressCard(weeks: Array(all.suffix(12)), comparison: BalanceScore.compare(all, goal: goal), goal: goal)
    }
}

struct BalanceProgressCard: View {
    let weeks: [BalanceWeek]
    let comparison: BalanceComparison?
    let goal: FitnessGoal?

    /// For the weight unit; kilograms where a preview leaves it out.
    @Environment(WorkoutStore.self) private var store: WorkoutStore?

    private var unit: WeightUnit { store?.unit ?? .kg }

    /// Both lanes' y-axis labels take this width, so their plot areas, and
    /// so their weeks, line up.
    private static let axisWidth: CGFloat = 30

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: String(localized: "BALANCE & RESULTS", comment: "Progress, Overview: section title"))
                Spacer()
                MetaLine(text: "\(weeks.count) WEEKS", em: 0.08)
            }
            if weeks.isEmpty {
                Text("Your weekly Balance shows here once you start logging.")
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                if !weeks.contains(where: { $0.balance.score != nil || $0.paused }) {
                    Text("Each week's Balance fills in here once two of Train, Eat and Sleep are tracked.")
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                lane(String(localized: "Balance", comment: "Balance & results: the top lane"))
                balanceChart
                lane(String(localized: "Weight · 7-day average", comment: "Balance & results: the bottom lane"))
                    .padding(.top, 2)
                weightLane
                legend
                Text("The bars rate what you did; the line is the result. Weight trails habits by a week or two, so read each point against the bars before it.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
            if goal?.hasTarget == true {
                Hairline(opacity: 0.08)
                    .padding(.top, 2)
                yourWeeks
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
        .accessibilityElement(children: .contain)
    }

    private func lane(_ title: String) -> some View {
        Text(title)
            .font(.mono(9.5, .semibold))
            .trackingEm(0.08, size: 9.5)
            .textCase(.uppercase)
            .foregroundStyle(DS.silver.opacity(0.45))
            .accessibilityHidden(true)
    }

    // MARK: Axis

    private var domain: ClosedRange<Date> {
        let calendar = Calendar.current
        let start = weeks.first?.start ?? Date()
        let last = weeks.last?.start ?? start
        let end = calendar.date(byAdding: .day, value: 7, to: last) ?? last
        return start...max(end, start.addingTimeInterval(1))
    }

    private func axisLabel(_ text: String) -> some View {
        Text(text)
            .font(.mono(9))
            .foregroundStyle(DS.silver.opacity(0.45))
            .frame(width: Self.axisWidth, alignment: .leading)
    }

    // MARK: Balance lane

    private func leverColor(_ week: BalanceWeek) -> Color {
        week.balance.lever.map { BalanceKit.color($0) } ?? DS.silver.opacity(0.45)
    }

    private var balanceChart: some View {
        Chart {
            ForEach(weeks) { week in
                if week.paused {
                    BarMark(x: .value("Week", week.start, unit: .weekOfYear),
                            yStart: .value("Balance", 0), yEnd: .value("Balance", 8))
                        .foregroundStyle(DS.silver.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
                        .annotation(position: .top, spacing: 3) {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 7, weight: .bold))
                                .foregroundStyle(DS.silver.opacity(0.45))
                        }
                } else if let score = week.balance.score {
                    BarMark(x: .value("Week", week.start, unit: .weekOfYear),
                            yStart: .value("Balance", 0), yEnd: .value("Balance", score))
                        .foregroundStyle(leverColor(week).opacity(week.isCurrent ? 0.45 : 1))
                        .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
                        // Just the number over each bar (a wider "so far" label
                        // ran into last week's); this week stacks "so far" under it.
                        .annotation(position: .top, spacing: 3) {
                            VStack(spacing: 0) {
                                Text(score.formatted())
                                if week.isCurrent {
                                    Text("so far", comment: "Balance & results: under this week's number, over a narrow bar; keep it short")
                                }
                            }
                            .font(.mono(8.5, .semibold))
                            .foregroundStyle(DS.silver.opacity(week.isCurrent ? 0.7 : 0.45))
                            .fixedSize()
                        }
                } else {
                    // Fewer than two pillars that week: no Balance.
                    BarMark(x: .value("Week", week.start, unit: .weekOfYear),
                            yStart: .value("Balance", 0), yEnd: .value("Balance", 2))
                        .foregroundStyle(DS.silver.opacity(0.12))
                }
            }
        }
        .chartXScale(domain: domain)
        .chartYScale(domain: 0...112)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .trailing, values: [0, 50, 100]) { value in
                AxisGridLine().foregroundStyle(DS.silver.opacity(0.06))
                AxisValueLabel {
                    if let v = value.as(Int.self) { axisLabel(v.formatted()) }
                }
            }
        }
        .frame(height: 120)
        .accessibilityElement()
        .accessibilityLabel(balanceSpoken)
    }

    private var balanceSpoken: String {
        let scored = weeks.filter { !$0.isCurrent && !$0.paused }.compactMap(\.balance.score)
        var parts: [String] = []
        if let current = weeks.last, current.isCurrent {
            if current.paused {
                parts.append(String(localized: "This week is paused.", comment: "Balance & results, VoiceOver"))
            } else if let score = current.balance.score {
                parts.append(String(localized: "Balance this week so far: \(score).", comment: "Balance & results, VoiceOver"))
            }
        }
        if !scored.isEmpty {
            let average = scored.reduce(0, +) / scored.count
            parts.append(String(localized: "Average of \(scored.count) earlier weeks: \(average).",
                                comment: "Balance & results, VoiceOver"))
        }
        if parts.isEmpty {
            return String(localized: "Weekly Balance: no weeks scored yet.", comment: "Balance & results, VoiceOver")
        }
        return parts.joined(separator: " ")
    }

    // MARK: Weight lane

    private struct WeightPoint: Identifiable {
        let start: Date
        let value: Double
        /// An unbroken stretch: a week without weigh-ins breaks the line.
        let run: Int
        var id: Date { start }
    }

    private var weightPoints: [WeightPoint] {
        var points: [WeightPoint] = []
        var run = 0
        var gap = false
        for week in weeks {
            if let kg = week.weightKg {
                if gap && !points.isEmpty { run += 1 }
                gap = false
                points.append(WeightPoint(start: week.start, value: unit.fromKilograms(kg), run: run))
            } else {
                gap = true
            }
        }
        return points
    }

    @ViewBuilder
    private var weightLane: some View {
        let points = weightPoints
        if points.isEmpty {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(systemName: "scalemass")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(TodayTone.violet)
                    .accessibilityHidden(true)
                Text("No weigh-ins in these weeks. Weigh in on Today to see your weight beside your Balance.")
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 6)
        } else {
            let values = points.map(\.value)
            let low = values.min() ?? 0, high = values.max() ?? 0
            let pad = max((high - low) * 0.2, unit == .kg ? 0.5 : 1)
            Chart {
                ForEach(points) { point in
                    LineMark(x: .value("Week", point.start, unit: .weekOfYear),
                             y: .value("Weight", point.value),
                             series: .value("Line", "weight-\(point.run)"))
                        .foregroundStyle(TodayTone.violet)
                        .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)
                    PointMark(x: .value("Week", point.start, unit: .weekOfYear),
                              y: .value("Weight", point.value))
                        .foregroundStyle(TodayTone.violet)
                        .symbolSize(point.id == points.last?.id ? 40 : 14)
                }
            }
            .chartXScale(domain: domain)
            .chartYScale(domain: (low - pad)...(high + pad))
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
                            axisLabel(v.formatted(.number.precision(.fractionLength(0...1))))
                        }
                    }
                }
            }
            .frame(height: 96)
            .accessibilityElement()
            .accessibilityLabel(weightSpoken(points))
        }
    }

    private func weightSpoken(_ points: [WeightPoint]) -> String {
        guard let first = points.first, let last = points.last else { return "" }
        let from = unit.bodyWeight(unit.toKilograms(first.value))
        let to = unit.bodyWeight(unit.toKilograms(last.value))
        return String(localized: "Weight, 7-day average: from \(from) to \(to).", comment: "Balance & results, VoiceOver")
    }

    // MARK: Legend

    private var legend: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) { legendItems }
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 12) {
                    Text("Bar = the week's lever:", comment: "Balance & results legend")
                        .font(.ui(11))
                        .foregroundStyle(DS.silver.opacity(0.5))
                    ForEach(BalancePillar.allCases) { pillar in
                        legendSwatch(BalanceKit.color(pillar), pillar.title)
                    }
                }
                HStack(spacing: 12) {
                    legendSwatch(DS.silver.opacity(0.2), String(localized: "Paused", comment: "Balance: the week is left out"))
                    legendLine
                }
            }
        }
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var legendItems: some View {
        Text("Bar = the week's lever:", comment: "Balance & results legend")
            .font(.ui(11))
            .foregroundStyle(DS.silver.opacity(0.5))
        ForEach(BalancePillar.allCases) { pillar in
            legendSwatch(BalanceKit.color(pillar), pillar.title)
        }
        legendSwatch(DS.silver.opacity(0.2), String(localized: "Paused", comment: "Balance: the week is left out"))
        legendLine
    }

    private func legendSwatch(_ color: Color, _ title: String) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 2).fill(color).frame(width: 9, height: 9)
            Text(title)
                .font(.ui(11))
                .foregroundStyle(DS.silver.opacity(0.5))
                .lineLimit(1)
                .fixedSize()
        }
    }

    private var legendLine: some View {
        HStack(spacing: 5) {
            Capsule().fill(TodayTone.violet).frame(width: 12, height: 2.5)
            Text("Weight", comment: "Balance & results legend")
                .font(.ui(11))
                .foregroundStyle(DS.silver.opacity(0.5))
                .lineLimit(1)
                .fixedSize()
        }
    }

    // MARK: Your weeks

    /// Finished weeks with a Balance and a weigh-in that week and the next
    /// finished one: what the comparison is built from. The week before
    /// this one doesn't count yet, since this week's weight is only so far.
    private var collectedWeeks: Int {
        weeks.indices.filter { index in
            let week = weeks[index]
            return !week.isCurrent && !week.paused && week.balance.score != nil && week.weightKg != nil
                && index + 1 < weeks.count && !weeks[index + 1].isCurrent && weeks[index + 1].weightKg != nil
        }.count
    }

    private func perWeek(_ kg: Double) -> String {
        let value = unit.fromKilograms(kg).formatted(.number.precision(.fractionLength(1...2)).sign(strategy: .always()))
        return String(localized: "\(value) \(unit.symbol) a week", comment: "Your weeks: weight change, -0.45 kg a week")
    }

    @ViewBuilder
    private var yourWeeks: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: String(localized: "YOUR WEEKS",
                                        comment: "Progress, Balance & results: better-balanced weeks set against the rest"))
            if let comparison {
                HStack(alignment: .top, spacing: 12) {
                    figure(String(localized: "Better-balanced weeks"), perWeek(comparison.betterResult))
                    figure(String(localized: "Other weeks"), perWeek(comparison.otherResult))
                }
                if !comparison.betterHad.isEmpty {
                    Text("The better weeks had: \(comparison.betterHad.joined(separator: " · ")).",
                         comment: "Your weeks: what the better-balanced weeks had")
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(verdict(comparison))
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
                Text(comparison.early
                     ? String(localized: "An early read from \(comparison.weeksUsed) weeks, each set against the next week's change; it firms up from 10.",
                              comment: "Your weeks: few weeks so far")
                     : String(localized: "From \(comparison.weeksUsed) weeks, each set against the next week's change, since weight lags habits.",
                              comment: "Your weeks: the weeks compared"))
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                let collected = min(8, collectedWeeks)
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("\(collected) of 8 weeks collected", comment: "Your weeks: progress toward the comparison")
                        .font(.ui(15, .semibold))
                        .monospacedDigit()
                        .foregroundStyle(DS.silver)
                    Spacer(minLength: 0)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(DS.silver.opacity(0.08))
                        Capsule().fill(DS.silver.opacity(0.55))
                            .frame(width: geo.size.width * CGFloat(collected) / 8)
                    }
                }
                .frame(height: 5)
                .accessibilityHidden(true)
                Text(collectedWeeks >= 8
                     ? String(localized: "Weeks are compared only with the same pillars tracked: keep tracking the same ones and this fills in.")
                     : String(localized: "Once 8 finished weeks have a Balance and weigh-ins, MUSQ sets your better-balanced weeks against the rest, so you can see what moves your weight."))
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func figure(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.ui(11.5))
                .foregroundStyle(DS.silver.opacity(0.5))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(value)
                .font(.ui(17, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    /// Whether the better-balanced weeks moved the weight more toward the
    /// goal, said plainly either way.
    private func verdict(_ comparison: BalanceComparison) -> String {
        guard comparison.clearDifference else {
            return String(localized: "No clear difference yet between the two: more weeks will tell.")
        }
        let toward = (goal == .loseWeight) ? (comparison.betterResult < comparison.otherResult)
                                           : (comparison.betterResult > comparison.otherResult)
        return toward
            ? String(localized: "Your better-balanced weeks moved your weight more toward your goal.")
            : String(localized: "So far your better-balanced weeks didn't move your weight more. Water and salt can hide a trend for a while.")
    }
}
