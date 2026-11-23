//
//  HealthTrendCards.swift
//  GymWorkout
//
//  Progress › Overview, phase 2 (2026-11-22, owner-approved list): steps
//  and sleep from Apple Health over the last 7 or 30 days, between the
//  consistency grid and the totals, side by side on iPad like the volume and
//  consistency pair above them. Everything is read from `AppleHealth` on
//  each pass and nothing here is kept; none of it goes to the AI coach or
//  the ads SDK. The colours are `HealthTone`'s, provisional until the owner
//  picks.
//
//  - Health unavailable (some iPads): nothing at all.
//  - Not asked yet: one compact card asking to connect.
//  - Asked and nothing read: one card saying where access is changed —
//    HealthKit never says whether reading was refused.
//  - Otherwise both cards. One with nothing in it (no Watch, no sleep
//    tracking, one type turned off in Health) says so in its own place.
//

import Charts
import SwiftUI

/// The days the health cards look back over; the last one picked is kept
/// (`progress.healthRange`).
enum HealthTrendRange: Int, CaseIterable, Hashable {
    case week = 7
    case month = 30

    var days: Int { rawValue }

    /// The picker's title and the cards' meta line.
    var title: String {
        switch self {
        case .week: return String(localized: "7 DAYS", comment: "Progress, Apple Health cards: range picker and meta line")
        case .month: return String(localized: "30 DAYS", comment: "Progress, Apple Health cards: range picker and meta line")
        }
    }

    /// The range's days, today last: `end` is tomorrow at 00:00, so today's
    /// bar has its whole slot.
    func window(calendar: Calendar = .current, now: Date = Date()) -> (start: Date, end: Date) {
        let today = calendar.startOfDay(for: now)
        let start = calendar.date(byAdding: .day, value: -(days - 1), to: today) ?? today
        let end = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        return (start, end)
    }

    /// Where the x-axis is labelled: every day over a week, every seventh
    /// day back from today over a month. At midday, so a label sits under
    /// the middle of its day's bar.
    func ticks(calendar: Calendar = .current, now: Date = Date()) -> [Date] {
        let today = calendar.startOfDay(for: now)
        let step = self == .week ? 1 : 7
        return stride(from: days - 1, through: 0, by: -1)
            .filter { $0 % step == 0 }
            .compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
            .compactMap { calendar.date(byAdding: .hour, value: 12, to: $0) }
    }

    /// "Mon" under each of a week's bars, "15 Nov" under a month's.
    var axisFormat: Date.FormatStyle {
        self == .week ? .dateTime.weekday(.abbreviated) : .dateTime.day().month(.abbreviated)
    }
}

// MARK: - Section

/// The Overview's Apple Health block: whichever of connect, nothing yet, or
/// the two cards under a shared 7 / 30 day picker fits the access state.
struct HealthTrendSection: View {
    /// The section's id in Progress's scroll view, where Today's steps and
    /// sleep land (`ProgressFocus`).
    static let scrollID = "progress.healthTrends"

    /// Side by side, as the volume chart and the consistency grid are on an
    /// iPad column of 680 and up.
    var paired = false
    /// The Overview's gap between cards.
    var spacing: CGFloat = 14

    @Environment(AppleHealth.self) private var health
    @AppStorage("progress.healthRange") private var range: HealthTrendRange = .week

    var body: some View {
        switch health.access {
        case .unavailable:
            EmptyView()
        case .notAsked:
            HealthTrendConnect()
        case .asked:
            if health.lastRefresh != nil, health.allDailySteps.isEmpty, health.nights.isEmpty {
                HealthTrendNoData()
            } else {
                cards
            }
        }
    }

    private var cards: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                SectionEyebrow(text: String(localized: "APPLE HEALTH",
                                            comment: "Progress, Overview: title over the steps and sleep cards"))
                Spacer(minLength: 8)
                MonoSegmentedControl(
                    options: HealthTrendRange.allCases.map { ($0, $0.title) },
                    selection: $range,
                    fontSize: 10
                )
            }
            if paired {
                HStack(alignment: .top, spacing: spacing) {
                    stepsCard(fillsHeight: true)
                    sleepCard(fillsHeight: true)
                }
                .fixedSize(horizontal: false, vertical: true)
            } else {
                VStack(alignment: .leading, spacing: spacing) {
                    stepsCard(fillsHeight: false)
                    sleepCard(fillsHeight: false)
                }
            }
        }
        .animation(.easeOut(duration: 0.2), value: range)
        // Opened before the first read is back (a launch straight onto
        // Progress): ask for it here rather than wait for the next return
        // to the app. One read runs at a time, so this never doubles up.
        .task {
            if health.lastRefresh == nil { await health.refresh() }
        }
    }

    private func stepsCard(fillsHeight: Bool) -> some View {
        // The complete days on the chart: today is still running, so a
        // week's average is over the six days before it.
        // Health's steps with the walks added by hand, as Today counts them.
        StepsTrendCard(days: health.allDailySteps, goal: health.stepsGoal,
                       average: health.averageSteps(days: range.days - 1),
                       today: health.stepsTodayTotal, range: range,
                       loading: health.lastRefresh == nil, fillsHeight: fillsHeight)
    }

    private func sleepCard(fillsHeight: Bool) -> some View {
        // Nights are counted by the day you woke, so last night is in.
        SleepTrendCard(nights: health.nights, goalMinutes: health.sleepGoalMinutes,
                       average: health.averageSleep(days: range.days),
                       lastNight: health.lastNight, range: range,
                       loading: health.lastRefresh == nil, fillsHeight: fillsHeight)
    }
}

// MARK: - Steps

/// Steps a day as bars, the goal as a dashed line, today's bar in full
/// colour. A day with no steps has no entry and draws no bar, rather than a
/// zero that would read as a day spent sitting.
struct StepsTrendCard: View {
    /// Days with steps, oldest first (`AppleHealth.dailySteps`).
    let days: [AppleHealth.Day]
    let goal: Int
    /// Steps a day over the complete days on the chart; nil before one is in.
    let average: Int?
    let today: Int?
    let range: HealthTrendRange
    var loading = false
    /// Beside the sleep card on iPad the chart grows to the row's height.
    var fillsHeight = false

    var body: some View {
        let calendar = Calendar.current
        let window = range.window(calendar: calendar)
        let todayStart = calendar.startOfDay(for: Date())
        let shown = days.filter { $0.day >= window.start && $0.day < window.end }
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: String(localized: "STEPS", comment: "Progress, steps card title"))
                Spacer()
                MetaLine(text: range.title, em: 0.08)
            }
            if loading {
                HealthTrendLoading(fillsHeight: fillsHeight)
            } else if days.isEmpty {
                HealthTrendEmpty(text: HealthCopy.noData, opensHealth: true)
            } else if shown.isEmpty {
                HealthTrendEmpty(text: String(localized: "No steps in the last \(range.days) days.",
                                              comment: "Progress, steps card: nothing inside the range picked"))
            } else {
                headline
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(spoken(shown, todayStart: todayStart))
                chart(shown, window: window, todayStart: todayStart)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: fillsHeight ? .infinity : nil, alignment: .topLeading)
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt))
    }

    @ViewBuilder
    private var headline: some View {
        let todayKey = today.flatMap { $0 > 0 ? $0 : nil }
        if let average {
            HealthTrendHeadline(
                value: HealthFormat.steps(average),
                caption: String(localized: "steps a day", comment: "Progress, steps card: under the average"),
                keyColor: HealthTone.steps,
                key: todayKey.map { String(localized: "Today \(HealthFormat.steps($0))",
                                           comment: "Progress, steps card: key to today's highlighted bar") })
        } else if let todayKey {
            // Only today so far (connected today): today's count stands in.
            HealthTrendHeadline(
                value: HealthFormat.steps(todayKey),
                caption: String(localized: "steps today", comment: "Progress, steps card: under today's count"),
                keyColor: HealthTone.steps, key: nil)
        }
    }

    private func chart(_ shown: [AppleHealth.Day], window: (start: Date, end: Date), todayStart: Date) -> some View {
        // Headroom over the tallest bar or the goal, for the goal's label.
        let top = max(shown.map(\.value).max() ?? 0, Double(goal)) * 1.15
        return Chart {
            ForEach(shown) { day in
                BarMark(x: .value("Day", day.day, unit: .day),
                        y: .value("Steps", day.value))
                    .foregroundStyle(day.day == todayStart ? HealthTone.steps : HealthTone.steps.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: range == .week ? 4 : 2, style: .continuous))
            }
            RuleMark(y: .value("Goal", Double(goal)))
                .foregroundStyle(DS.silver.opacity(0.45))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [3, 3]))
                .annotation(position: .top, alignment: .leading) {
                    Text("goal \(HealthFormat.steps(goal))", comment: "Progress, steps chart: the goal line's label")
                        .font(.mono(9, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
        }
        .chartXScale(domain: window.start...window.end)
        .chartYScale(domain: 0...top)
        .chartXAxis {
            AxisMarks(values: range.ticks()) { _ in
                AxisValueLabel(format: range.axisFormat, anchor: .top)
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
    }

    /// The chart in sentences, read on the headline; the chart itself is
    /// hidden from VoiceOver.
    private func spoken(_ shown: [AppleHealth.Day], todayStart: Date) -> String {
        var parts: [String] = []
        if let average {
            parts.append(String(localized: "Steps over the last \(range.days) days: \(HealthFormat.steps(average)) a day on average.",
                                comment: "VoiceOver, Progress steps card"))
        } else {
            parts.append(String(localized: "Steps over the last \(range.days) days.", comment: "VoiceOver, Progress steps card"))
        }
        if let today, today > 0 {
            parts.append(String(localized: "Today \(HealthFormat.steps(today)).", comment: "VoiceOver, Progress steps card"))
        }
        parts.append(String(localized: "Goal \(HealthFormat.steps(goal)) a day.", comment: "VoiceOver, Progress steps card"))
        let met = shown.filter { $0.day < todayStart && $0.value >= Double(goal) }.count
        if average != nil {
            parts.append(met == 1
                ? String(localized: "Goal reached on 1 day.", comment: "VoiceOver, Progress steps card")
                : String(localized: "Goal reached on \(met) days.", comment: "VoiceOver, Progress steps card"))
        }
        return parts.joined(separator: " ")
    }
}

// MARK: - Sleep

/// Hours asleep a night as bars over a shaded band an hour either side of
/// the goal (7–9 h at the default 8), the goal dashed through it, last
/// night in full colour; under it last night's Watch stages, when the
/// source had them.
struct SleepTrendCard: View {
    /// Nights with sleep, oldest first (`AppleHealth.nights`), each on the
    /// day it was woken from.
    let nights: [AppleHealth.SleepNight]
    let goalMinutes: Int
    /// Asleep minutes a night over the nights on the chart.
    let average: Int?
    let lastNight: AppleHealth.SleepNight?
    let range: HealthTrendRange
    var loading = false
    /// Beside the steps card on iPad the chart grows to the row's height.
    var fillsHeight = false

    var body: some View {
        let calendar = Calendar.current
        let window = range.window(calendar: calendar)
        let todayStart = calendar.startOfDay(for: Date())
        let shown = nights.filter { $0.day >= window.start && $0.day < window.end }
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: String(localized: "SLEEP", comment: "Progress, sleep card title"))
                Spacer()
                MetaLine(text: range.title, em: 0.08)
            }
            if loading {
                HealthTrendLoading(fillsHeight: fillsHeight)
            } else if nights.isEmpty {
                HealthTrendEmpty(text: HealthCopy.noData, opensHealth: true)
            } else if shown.isEmpty {
                HealthTrendEmpty(text: String(localized: "No sleep in the last \(range.days) days.",
                                              comment: "Progress, sleep card: nothing inside the range picked"))
            } else {
                if let average {
                    HealthTrendHeadline(
                        value: HealthFormat.sleep(minutes: average),
                        caption: String(localized: "a night", comment: "Progress, sleep card: under the average, e.g. 7 h 12 a night"),
                        keyColor: HealthTone.sleep,
                        key: lastNight.map { String(localized: "Last night \(HealthFormat.sleep(minutes: $0.asleepMinutes))",
                                                    comment: "Progress, sleep card: key to last night's highlighted bar") })
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(spoken(shown))
                }
                chart(shown, window: window, todayStart: todayStart)
                    .accessibilityHidden(true)
                if let lastNight, lastNight.hasStages {
                    stages(lastNight)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: fillsHeight ? .infinity : nil, alignment: .topLeading)
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt))
    }

    private func chart(_ shown: [AppleHealth.SleepNight], window: (start: Date, end: Date), todayStart: Date) -> some View {
        let goal = Double(goalMinutes) / 60
        let longest = Double(shown.map(\.asleepMinutes).max() ?? 0) / 60
        // Whole hours, with room over the band (or a long night) for the
        // goal's label.
        let top = (max(longest, goal + 1) + 0.75).rounded(.up)
        let hours = stride(from: 0.0, through: top, by: top > 10 ? 4 : 3).map { $0 }
        return Chart {
            RectangleMark(xStart: .value("Start", window.start), xEnd: .value("End", window.end),
                          yStart: .value("Low", goal - 1), yEnd: .value("High", goal + 1))
                .foregroundStyle(HealthTone.sleep.opacity(0.1))
            ForEach(shown) { night in
                BarMark(x: .value("Night", night.day, unit: .day),
                        y: .value("Asleep", Double(night.asleepMinutes) / 60))
                    .foregroundStyle(night.day == todayStart ? HealthTone.sleep : HealthTone.sleep.opacity(0.45))
                    .clipShape(RoundedRectangle(cornerRadius: range == .week ? 4 : 2, style: .continuous))
            }
            RuleMark(y: .value("Goal", goal))
                .foregroundStyle(DS.silver.opacity(0.45))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [3, 3]))
                .annotation(position: .top, alignment: .leading) {
                    Text("goal \(HealthFormat.sleep(minutes: goalMinutes))", comment: "Progress, sleep chart: the goal line's label")
                        .font(.mono(9, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
        }
        .chartXScale(domain: window.start...window.end)
        .chartYScale(domain: 0...top)
        .chartXAxis {
            AxisMarks(values: range.ticks()) { _ in
                AxisValueLabel(format: range.axisFormat, anchor: .top)
                    .font(.mono(9))
                    .foregroundStyle(DS.silver.opacity(0.45))
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: hours) { value in
                AxisGridLine().foregroundStyle(DS.silver.opacity(0.06))
                AxisValueLabel {
                    // The floor goes unlabelled: "0 min" says nothing.
                    if let v = value.as(Double.self), v > 0 {
                        Text(HealthFormat.sleep(minutes: Int((v * 60).rounded())))
                            .font(.mono(9))
                            .foregroundStyle(DS.silver.opacity(0.45))
                    }
                }
            }
        }
        .frame(minHeight: 150, idealHeight: 150, maxHeight: fillsHeight ? .infinity : 150)
    }

    // MARK: Stages

    /// Last night's Watch stages: one bar split by share, and each stage's
    /// time. Deep darkest, then core, then REM.
    private func stages(_ night: AppleHealth.SleepNight) -> some View {
        let parts: [TrendSleepStage] = [
            TrendSleepStage(title: String(localized: "Deep", comment: "Sleep stage"),
                            minutes: night.deepMinutes, color: HealthTone.sleep),
            // Its own key: "Core" alone is the muscle group.
            TrendSleepStage(title: String(localized: "health.sleepStage.core", defaultValue: "Core",
                                          comment: "Sleep stage, Apple Health's Core sleep (not the core muscles)"),
                            minutes: night.coreMinutes, color: HealthTone.sleep.opacity(0.55)),
            TrendSleepStage(title: String(localized: "REM", comment: "Sleep stage"),
                            minutes: night.remMinutes, color: HealthTone.sleep.opacity(0.28)),
        ].filter { $0.minutes > 0 }
        let total = CGFloat(max(parts.reduce(0) { $0 + $1.minutes }, 1))
        let gap: CGFloat = 2
        let list = parts.map { "\($0.title) \(HealthFormat.sleepSpoken(minutes: $0.minutes))" }
            .joined(separator: ", ")
        return VStack(alignment: .leading, spacing: 10) {
            Hairline(opacity: 0.08)
            MetaLine(text: "LAST NIGHT", em: 0.08)
            GeometryReader { proxy in
                let room = max(0, proxy.size.width - gap * CGFloat(max(parts.count - 1, 0)))
                HStack(spacing: gap) {
                    ForEach(parts) { stage in
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(stage.color)
                            .frame(width: room * CGFloat(stage.minutes) / total)
                    }
                }
            }
            .frame(height: 8)
            .clipShape(Capsule())
            // Three across, or one under another where they don't fit.
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 14) {
                    ForEach(parts) { stageKey($0) }
                }
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(parts) { stageKey($0) }
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(String(localized: "Last night's sleep stages: \(list).",
                                   comment: "VoiceOver, Progress sleep card: e.g. Deep 1 hour 5 minutes, Core 4 hours, REM 1 hour 30 minutes"))
    }

    private func stageKey(_ stage: TrendSleepStage) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(stage.color)
                .frame(width: 9, height: 9)
            Text(stage.title)
                .font(.ui(11))
                .foregroundStyle(DS.silver.opacity(0.5))
            Text(HealthFormat.sleep(minutes: stage.minutes))
                .font(.ui(11, .semibold))
                .foregroundStyle(DS.silver.opacity(0.75))
        }
        .lineLimit(1)
        .fixedSize()
    }

    /// The chart in sentences, read on the headline; the chart itself is
    /// hidden from VoiceOver.
    private func spoken(_ shown: [AppleHealth.SleepNight]) -> String {
        var parts: [String] = []
        if let average {
            parts.append(String(localized: "Sleep over the last \(range.days) days: \(HealthFormat.sleepSpoken(minutes: average)) a night on average.",
                                comment: "VoiceOver, Progress sleep card"))
        }
        if let lastNight {
            parts.append(String(localized: "Last night \(HealthFormat.sleepSpoken(minutes: lastNight.asleepMinutes)).",
                                comment: "VoiceOver, Progress sleep card"))
        }
        parts.append(String(localized: "Goal \(HealthFormat.sleepSpoken(minutes: goalMinutes)).",
                            comment: "VoiceOver, Progress sleep card"))
        let near = shown.filter { abs($0.asleepMinutes - goalMinutes) <= 60 }.count
        parts.append(near == 1
            ? String(localized: "Within an hour of the goal on 1 night.", comment: "VoiceOver, Progress sleep card")
            : String(localized: "Within an hour of the goal on \(near) nights.", comment: "VoiceOver, Progress sleep card"))
        return parts.joined(separator: " ")
    }
}

private struct TrendSleepStage: Identifiable {
    let title: String
    let minutes: Int
    let color: Color
    var id: String { title }
}

// MARK: - Pieces

/// A card's figure, as the consistency grid's streak: the number, what it
/// counts, and on the right the key to the highlighted bar.
private struct HealthTrendHeadline: View {
    let value: String
    let caption: String
    let keyColor: Color
    let key: String?

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(value)
                    .font(.ui(30, .semibold))
                    .tracking(-0.6)
                    .foregroundStyle(DS.silver)
                Text(caption)
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.55))
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            Spacer(minLength: 8)
            if let key {
                HStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(keyColor)
                        .frame(width: 9, height: 9)
                    Text(key)
                        .font(.ui(11.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
    }
}

/// In a card's chart space while the first read is out.
private struct HealthTrendLoading: View {
    var fillsHeight: Bool

    var body: some View {
        ProgressView()
            .tint(DS.silver)
            .frame(maxWidth: .infinity, minHeight: 190, maxHeight: fillsHeight ? .infinity : 190)
            .accessibilityLabel(String(localized: "Reading Apple Health", comment: "VoiceOver: a Progress health card while it loads"))
    }
}

/// A card with nothing to draw: why, and where access is changed when
/// nothing came at all.
private struct HealthTrendEmpty: View {
    let text: String
    var opensHealth = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(text)
                .font(.ui(13))
                .cssLineHeight(13, 1.5)
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
            if opensHealth {
                WideButton(title: String(localized: "Open Health", comment: "Button: opens the Health app, where read access is changed"),
                           prominent: false, fontSize: 12.5, verticalPadding: 9, cornerRadius: 11) {
                    HealthCopy.openHealthApp()
                }
                .dsCTA(240, alignment: .leading)
            }
        }
    }
}

/// Not asked yet: what connecting shows, and the button that brings up
/// Apple's sheet. Gone once it has been shown, whatever was answered.
private struct HealthTrendConnect: View {
    @Environment(AppleHealth.self) private var health
    @State private var connecting = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                // The two cards' identity colours, so the invitation reads
                // as what it adds. Decorative.
                VStack(spacing: 6) {
                    symbol("figure.walk", HealthTone.steps)
                    symbol("bed.double.fill", HealthTone.sleep)
                }
                .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(HealthCopy.connectTitle)
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                        .accessibilityAddTraits(.isHeader)
                    Text(HealthCopy.connectDetail)
                        .font(.ui(12.5))
                        .cssLineHeight(12.5, 1.4)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            WideButton(title: String(localized: "Connect", comment: "Progress: shows Apple Health's access sheet"),
                       prominent: true, fontSize: 12.5, verticalPadding: 9, cornerRadius: 11) {
                guard !connecting else { return }
                connecting = true
                Task {
                    await health.connect()
                    connecting = false
                }
            }
            .disabled(connecting)
            .dsCTA(240, alignment: .leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt))
        .accessibilityElement(children: .contain)
    }

    private func symbol(_ name: String, _ color: Color) -> some View {
        Image(systemName: name)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: 30, height: 30)
            .background(RoundedRectangle(cornerRadius: 9, style: .continuous).fill(color.opacity(0.14)))
    }
}

/// Asked, and not one step or night came back.
private struct HealthTrendNoData: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionEyebrow(text: String(localized: "APPLE HEALTH",
                                        comment: "Progress, Overview: title over the steps and sleep cards"))
            HealthTrendEmpty(text: HealthCopy.noData, opensHealth: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt))
    }
}

// MARK: - Previews

/// A desk worker's month: 5–12k steps, 5½–8 h nights with stages, a few
/// days missing.
private enum HealthTrendPreviewData {
    static var today: Date { Calendar.current.startOfDay(for: Date()) }

    static func day(_ offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -offset, to: today) ?? today
    }

    static let steps: [AppleHealth.Day] = (0...29).reversed().compactMap { (offset: Int) -> AppleHealth.Day? in
        guard offset % 9 != 4 else { return nil }
        let value = offset == 0 ? 3_120 : 5_200 + (offset * 2_731) % 7_200
        return AppleHealth.Day(day: day(offset), value: Double(value))
    }

    static let nights: [AppleHealth.SleepNight] = (0...29).reversed().compactMap { (offset: Int) -> AppleHealth.SleepNight? in
        guard offset % 11 != 6 else { return nil }
        let asleep = 330 + (offset * 37) % 150
        let deep = asleep / 7, rem = asleep / 5
        let end = Calendar.current.date(byAdding: .minute, value: 400, to: day(offset)) ?? day(offset)
        return AppleHealth.SleepNight(day: day(offset), asleepMinutes: asleep, coreMinutes: asleep - deep - rem,
                                      deepMinutes: deep, remMinutes: rem,
                                      start: end.addingTimeInterval(-Double(asleep) * 60), end: end)
    }

    static func average(_ values: [Double]) -> Int? {
        values.isEmpty ? nil : Int((values.reduce(0, +) / Double(values.count)).rounded())
    }

    /// The cards as `HealthTrendSection` builds them, from the data above.
    static func stepsCard(_ range: HealthTrendRange, fillsHeight: Bool = false) -> StepsTrendCard {
        let complete = steps.filter { $0.day >= day(range.days - 1) && $0.day < today }.map(\.value)
        return StepsTrendCard(days: steps, goal: 8_000, average: average(complete), today: 3_120,
                              range: range, fillsHeight: fillsHeight)
    }

    static func sleepCard(_ range: HealthTrendRange, fillsHeight: Bool = false) -> SleepTrendCard {
        let shown = nights.filter { $0.day >= day(range.days - 1) }.map { Double($0.asleepMinutes) }
        return SleepTrendCard(nights: nights, goalMinutes: 480, average: average(shown),
                              lastNight: nights.last { $0.day == today }, range: range, fillsHeight: fillsHeight)
    }
}

#Preview("Health trends · phone") {
    ScrollView {
        VStack(alignment: .leading, spacing: 14) {
            // Whatever this device's Health says: the connect card in a
            // fresh preview.
            HealthTrendSection()
            HealthTrendPreviewData.stepsCard(.week)
            HealthTrendPreviewData.sleepCard(.week)
            StepsTrendCard(days: [], goal: 8_000, average: nil, today: nil, range: .week)
        }
        .padding(20)
    }
    .environment(AppleHealth())
    .background(DS.ink)
}

#Preview("Health trends · iPad pair, 30 days") {
    HStack(alignment: .top, spacing: 16) {
        HealthTrendPreviewData.stepsCard(.month, fillsHeight: true)
        HealthTrendPreviewData.sleepCard(.month, fillsHeight: true)
    }
    .fixedSize(horizontal: false, vertical: true)
    .padding(28)
    .environment(AppleHealth())
    .dsPreview(.pad11Portrait750)
}
