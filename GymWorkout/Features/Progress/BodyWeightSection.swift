//
//  BodyWeightSection.swift
//  GymWorkout
//
//  Progress tab (2026-11-21): the weigh-ins of the last 90 days, the 7-day
//  average the plan follows, the target weight from onboarding, and the
//  week's water. Weigh-ins and water are logged on Today.
//

import Charts
import SwiftUI

struct BodyWeightSection: View {
    @Environment(WorkoutStore.self) private var store
    @Environment(DailyStore.self) private var daily
    @Environment(\.dsLayout) private var layout

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionEyebrow(text: String(localized: "BODY WEIGHT",
                                        comment: "Progress › Body: header of the weigh-in chart, the 7-day average and the week's water"))
            VStack(alignment: .leading, spacing: 12) {
                if daily.weights.isEmpty {
                    Text("No weigh-ins yet. Log one on Today and your trend shows here.")
                        .font(.ui(layout.value(13.5, 14.5)))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    summary
                    chart
                        .frame(height: layout.value(150, 190))
                }
                Hairline(opacity: 0.08)
                waterLine
            }
            .padding(layout.value(16, 18))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: layout.value(18, 20), style: .continuous).fill(DS.surfaceAlt))
        }
    }

    private var summary: some View {
        let unit = store.unit
        // With no weigh-in this week there is no average: show the last one.
        let trend = daily.trendWeight()
        return HStack(alignment: .firstTextBaseline) {
            if let value = trend ?? daily.latestWeight?.kg {
                Text(unit.bodyWeight(value))
                    .font(.ui(layout.value(22, 26), .semibold))
                    .foregroundStyle(DS.silver)
                    .monospacedDigit()
                Text(trend != nil ? String(localized: "7-day average", comment: "Under the weight trend")
                                  : String(localized: "last weigh-in", comment: "Under the weight when no weigh-in is recent"))
                    .font(.ui(layout.value(12.5, 13.5)))
                    .foregroundStyle(DS.silver.opacity(0.55))
            }
            Spacer(minLength: 8)
            if let change = daily.trendChange(days: 30) {
                let sign = change < 0 ? "−" : "+"
                Text("\(sign)\(unit.bodyWeight(abs(change))) in 30 days",
                     comment: "Weight trend change: −0.8 kg in 30 days")
                    .font(.ui(layout.value(12.5, 13.5), .semibold))
                    .foregroundStyle(DS.silver.opacity(0.75))
            }
        }
    }

    private var chart: some View {
        let unit = store.unit
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .day, value: -90, to: Date()) ?? Date()
        let entries = daily.weights.filter { $0.date >= start }
        let days = Array(Set(entries.map { calendar.startOfDay(for: $0.date) })).sorted()
        let trend = days.compactMap { day -> (Date, Double)? in
            let end = calendar.date(byAdding: .day, value: 1, to: day)?.addingTimeInterval(-1) ?? day
            return daily.trendWeight(at: end).map { (day, unit.fromKilograms($0)) }
        }
        let target = store.profile?.targetWeightKg.map { unit.fromKilograms($0) }
        let values = entries.map { unit.fromKilograms($0.kg) } + (target.map { [$0] } ?? [])
        let low = (values.min() ?? 0) - 1, high = (values.max() ?? 0) + 1
        // At least two weeks across, so a first weigh-in isn't a lone dot
        // on an axis of one day.
        let today = calendar.startOfDay(for: Date())
        let firstDay = min(entries.first.map { calendar.startOfDay(for: $0.date) } ?? today,
                           calendar.date(byAdding: .day, value: -13, to: today) ?? today)
        let lastDay = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        return Chart {
            ForEach(entries) { entry in
                PointMark(x: .value("Day", entry.date), y: .value("Weight", unit.fromKilograms(entry.kg)))
                    .foregroundStyle(DS.silver.opacity(0.35))
                    .symbolSize(18)
            }
            ForEach(Array(trend.enumerated()), id: \.offset) { _, point in
                LineMark(x: .value("Day", point.0), y: .value("Trend", point.1))
                    .foregroundStyle(DS.activation)
                    .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .interpolationMethod(.monotone)
            }
            if let target {
                RuleMark(y: .value("Target", target))
                    .foregroundStyle(DS.silver.opacity(0.4))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Target \(Int(target.rounded()))\u{00A0}\(unit.symbol)", comment: "Chart label: Target 71 kg")
                            .font(.mono(9.5, .semibold))
                            .foregroundStyle(DS.silver.opacity(0.6))
                    }
            }
        }
        .chartYScale(domain: low...high)
        .chartXScale(domain: firstDay...lastDay)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                AxisValueLabel(format: .dateTime.day().month(.abbreviated))
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) { _ in
                AxisGridLine().foregroundStyle(DS.silver.opacity(0.08))
                AxisValueLabel()
            }
        }
        .accessibilityLabel(String(localized: "Weight over the last 90 days"))
    }

    /// "Water: 1.9 L a day this week · target 2.5 L".
    private var waterLine: some View {
        HStack(spacing: 8) {
            Image(systemName: "drop")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(TodayPalette.water)
            Text("Water: \(DailyStore.litres(daily.averageWater(days: 7))) a day on the days you logged this week · target \(DailyStore.litres(daily.waterTarget))",
                 comment: "The week's average water over logged days, and the daily target")
                .fixedSize(horizontal: false, vertical: true)
                .font(.ui(layout.value(12.5, 13.5)))
                .foregroundStyle(DS.silver.opacity(0.7))
        }
    }
}
