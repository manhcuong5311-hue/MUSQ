//
//  TodayWidget.swift
//  MUSQWidgets
//
//  The Today widget: Home Screen small/medium (water + kcal rings, next
//  training, +250 ml / Log meal) and Lock Screen accessories (circular water
//  ring, rectangular kcal + next workout), fed by the App Group TodaySnapshot
//  and drawn in IslandStyle.current.
//

import AppIntents
import SwiftUI
import WidgetKit

struct TodayEntry: TimelineEntry {
    let date: Date
    let snapshot: TodaySnapshot
    let style: IslandStyle
}

struct TodayProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayEntry {
        TodayEntry(date: Date(), snapshot: .sample, style: .current)
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> Void) {
        let snap = context.isPreview ? .sample : (TodaySnapshot.load() ?? .sample)
        completion(TodayEntry(date: Date(), snapshot: snap.normalized(), style: .current))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayEntry>) -> Void) {
        let now = Date()
        let cal = Calendar.current
        let stored = TodaySnapshot.load() ?? .empty
        // A second entry at midnight shows the new day (zero logged, the
        // plan as of that day) even when WidgetKit doesn't reload on time.
        let midnight = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: now))
            ?? now.addingTimeInterval(24 * 3600)
        let entries = [
            TodayEntry(date: now, snapshot: stored.normalized(for: now), style: .current),
            TodayEntry(date: midnight, snapshot: stored.normalized(for: midnight), style: .current),
        ]
        completion(Timeline(entries: entries, policy: .after(midnight.addingTimeInterval(60))))
    }
}

struct TodayWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "MUSQToday", provider: TodayProvider()) { entry in
            TodayWidgetView(entry: entry)
        }
        .configurationDisplayName(L("Today"))
        .description(L("Water, calories and your next workout."))
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular])
    }
}

struct TodayWidgetView: View {
    var entry: TodayEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        let theme = WidgetTheme(entry.style)
        Group {
            switch family {
            case .systemMedium:
                TodayMediumView(s: entry.snapshot, theme: theme, now: entry.date)
            case .accessoryCircular:
                TodayCircularAccessory(s: entry.snapshot, theme: theme)
            case .accessoryRectangular:
                TodayRectangularAccessory(s: entry.snapshot, theme: theme, now: entry.date)
            default:
                TodaySmallView(s: entry.snapshot, theme: theme, now: entry.date)
            }
        }
        .containerBackground(for: .widget) {
            if family == .accessoryCircular || family == .accessoryRectangular {
                Color.clear
            } else {
                theme.widgetBackground
            }
        }
        .widgetURL(MUSQLink.today)
    }
}

// MARK: - Shared Home Screen pieces

/// Water ring with the kcal ring nested inside.
private struct TodayRings: View {
    var s: TodaySnapshot
    var theme: WidgetTheme
    var size: CGFloat
    var showLitres: Bool

    var body: some View {
        let inner = size * (theme.style == .minimal ? 0.78 : 0.70)
        ZStack {
            MetricRing(progress: s.waterProgress, color: theme.widgetWater, theme: theme)
                .frame(width: size, height: size)
            MetricRing(progress: s.kcalProgress, color: theme.widgetKcal, theme: theme,
                       lineWidth: max(1.5, size * theme.ringWidthRatio * 0.85))
                .frame(width: inner, height: inner)
                .opacity(theme.style == .minimal ? 0.55 : 1)
            if showLitres {
                VStack(spacing: -3) {
                    Text(WidgetFormat.litres(s.waterML))
                        .musqNumber(size * 0.2, theme.numberWeight)
                        .foregroundStyle(theme.widgetPrimary)
                    Text("L").musqNumber(size * 0.1, .bold)
                        .foregroundStyle(theme.widgetSecondary)
                }
            } else {
                Image(systemName: "drop.fill")
                    .font(.system(size: size * 0.18, weight: .bold))
                    .foregroundStyle(theme.widgetWater)
                    .widgetAccentable()
            }
        }
    }
}

private struct TodayValue: View {
    var title: String
    var value: String
    var unit: String?
    var color: Color
    var theme: WidgetTheme
    var size: CGFloat = 19
    var labelSize: CGFloat = 10
    /// Hidden when the phone is locked and redaction is on (kcal: its
    /// target comes from Apple Health).
    var sensitive = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TrackedLabel(text: title, theme: theme, size: labelSize, color: theme.widgetSecondary)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .musqNumber(size, theme.numberWeight == .light ? .regular : .bold)
                    .foregroundStyle(color)
                if let unit {
                    Text(unit)
                        .musqNumber(size * 0.55, .semibold)
                        .foregroundStyle(theme.widgetSecondary)
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .privacySensitive(sensitive)
        }
    }
}

private struct NextTrainingLine: View {
    var s: TodaySnapshot
    var theme: WidgetTheme
    var now: Date
    var size: CGFloat = 12

    var body: some View {
        let next = WidgetFormat.nextTraining(label: s.nextTrainingLabel, day: s.nextTrainingDay,
                                             time: s.nextTrainingTime, isTrainingDay: s.isTrainingDay,
                                             trainedToday: s.trainedToday, now: now)
        HStack(spacing: 4) {
            Image(systemName: s.trainedToday ? "checkmark.circle.fill"
                  : (s.isTrainingDay ? "dumbbell.fill" : "moon.zzz.fill"))
                .font(.system(size: size - 1, weight: .bold))
                .foregroundStyle(theme.style == .minimal ? theme.widgetPrimary : Color.musqOrange)
                .widgetAccentable()
            Text(next.title)
                .font(.system(size: size, weight: .semibold, design: .rounded))
                .foregroundStyle(theme.widgetPrimary)
            Text(next.detail)
                .font(.system(size: size, weight: .medium, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(theme.widgetSecondary)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.75)
    }
}

/// +250 ml (interactive) and Log meal (opens the app).
private struct WidgetActions: View {
    var theme: WidgetTheme
    var height: CGFloat
    var showMeal: Bool

    var body: some View {
        HStack(spacing: 8) {
            Button(intent: AddWaterIntent(ml: 250)) {
                primary
            }
            .buttonStyle(.plain)
            if showMeal {
                Link(destination: MUSQLink.quickLogFood) {
                    secondary
                }
            }
        }
    }

    private var primary: PillLabel {
        switch theme.style {
        case .bold:
            PillLabel(title: "+250 ml", systemImage: "drop.fill", foreground: .black,
                      background: AnyShapeStyle(Color.musqOrange), height: height)
        case .glass:
            // Dark ink: white on the water blue was under 3:1.
            PillLabel(title: "+250 ml", systemImage: "drop.fill", foreground: .musqInk,
                      background: AnyShapeStyle(Color.musqWater.gradient), height: height)
        case .minimal:
            PillLabel(title: "+250 ml", systemImage: "drop.fill",
                      foreground: Color(uiColor: .systemBackground),
                      background: AnyShapeStyle(Color.primary), height: height)
        }
    }

    private var secondary: PillLabel {
        switch theme.style {
        case .bold:
            PillLabel(title: L("Log meal"), systemImage: "fork.knife", foreground: .white,
                      background: AnyShapeStyle(Color.white.opacity(0.14)), height: height)
        case .glass:
            PillLabel(title: L("Log meal"), systemImage: "fork.knife", foreground: .primary,
                      background: AnyShapeStyle(Color.primary.opacity(0.08)), height: height,
                      stroke: Color.primary.opacity(0.10))
        case .minimal:
            PillLabel(title: L("Log meal"), systemImage: "fork.knife", foreground: .primary,
                      background: AnyShapeStyle(Color.clear), height: height,
                      stroke: Color.primary.opacity(0.35))
        }
    }
}

// MARK: - Small

private struct TodaySmallView: View {
    var s: TodaySnapshot
    var theme: WidgetTheme
    var now: Date

    // Sized for the smallest small widget (141 pt on 4.7" phones, 16 pt
    // margins): ring + two values ≈ 54 pt, line 13, pill 28, gaps ≥ 4 —
    // about 105 pt of the ~109 available, with room to shrink.
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 9) {
                TodayRings(s: s, theme: theme, size: 52, showLitres: false)
                VStack(alignment: .leading, spacing: 2) {
                    TodayValue(title: L("Water"), value: WidgetFormat.litres(s.waterML), unit: "L",
                               color: theme.widgetPrimary, theme: theme, size: 16, labelSize: 9)
                    TodayValue(title: L("Kcal"), value: WidgetFormat.number(s.kcalEaten), unit: nil,
                               color: theme.style == .glass ? theme.widgetKcal : theme.widgetPrimary,
                               theme: theme, size: 16, labelSize: 9, sensitive: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer(minLength: 4)
            NextTrainingLine(s: s, theme: theme, now: now, size: 11)
            Spacer(minLength: 4)
            WidgetActions(theme: theme, height: 28, showMeal: false)
        }
        .modifier(OptionalColorScheme(scheme: theme.widgetColorScheme))
    }
}

// MARK: - Medium

private struct TodayMediumView: View {
    var s: TodaySnapshot
    var theme: WidgetTheme
    var now: Date

    var body: some View {
        HStack(spacing: 16) {
            TodayRings(s: s, theme: theme, size: 112, showLitres: true)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    TodayValue(title: L("Water"), value: WidgetFormat.litres(s.waterML),
                               unit: "/ \(WidgetFormat.litres(s.waterTargetML)) L",
                               color: theme.style == .glass ? theme.widgetWater : theme.widgetPrimary,
                               theme: theme, size: 19)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TodayValue(title: L("Kcal"), value: WidgetFormat.number(s.kcalEaten),
                               unit: "/ \(WidgetFormat.number(s.kcalTarget))",
                               color: theme.style == .glass ? theme.widgetKcal : theme.widgetPrimary,
                               theme: theme, size: 19, sensitive: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer(minLength: 4)
                HStack(spacing: 6) {
                    NextTrainingLine(s: s, theme: theme, now: now, size: 12)
                    Spacer(minLength: 0)
                    Text(WidgetFormat.meals(s.mealsCount))
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(theme.widgetSecondary)
                        .lineLimit(1)
                }
                Spacer(minLength: 6)
                WidgetActions(theme: theme, height: 32, showMeal: true)
            }
        }
        .modifier(OptionalColorScheme(scheme: theme.widgetColorScheme))
    }
}

/// Bold is a dark design: force dark so `.primary` text stays white.
private struct OptionalColorScheme: ViewModifier {
    var scheme: ColorScheme?

    func body(content: Content) -> some View {
        if let scheme { content.environment(\.colorScheme, scheme) } else { content }
    }
}

// MARK: - Lock Screen accessories

private struct TodayCircularAccessory: View {
    var s: TodaySnapshot
    var theme: WidgetTheme

    var body: some View {
        switch theme.style {
        case .bold:
            Gauge(value: s.waterProgress) {
                Image(systemName: "drop.fill")
            } currentValueLabel: {
                Text(WidgetFormat.litres(s.waterML))
                    .musqNumber(18, .heavy)
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .widgetAccentable()
        case .glass:
            Gauge(value: s.waterProgress) {
                Image(systemName: "drop.fill")
            } currentValueLabel: {
                Text(WidgetFormat.litres(s.waterML))
                    .musqNumber(15, .bold)
            } minimumValueLabel: {
                Text("0").musqNumber(9, .medium)
            } maximumValueLabel: {
                Text(WidgetFormat.litres(s.waterTargetML)).musqNumber(9, .medium)
            }
            .gaugeStyle(.accessoryCircular)
            .widgetAccentable()
        case .minimal:
            ZStack {
                AccessoryWidgetBackground().opacity(0.6)
                MetricRing(progress: s.waterProgress, color: .primary, theme: theme, lineWidth: 2)
                    .padding(3)
                VStack(spacing: -2) {
                    Text(WidgetFormat.litres(s.waterML)).musqNumber(16, .regular)
                    Text("L").musqNumber(8, .medium).opacity(0.7)
                }
            }
        }
    }
}

private struct TodayRectangularAccessory: View {
    var s: TodaySnapshot
    var theme: WidgetTheme
    var now: Date

    var body: some View {
        let next = WidgetFormat.nextTraining(label: s.nextTrainingLabel, day: s.nextTrainingDay,
                                             time: s.nextTrainingTime, isTrainingDay: s.isTrainingDay,
                                             trainedToday: s.trainedToday, now: now)
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 12, weight: .bold))
                    .widgetAccentable()
                Text(WidgetFormat.number(s.kcalEaten))
                    .musqNumber(17, theme.style == .minimal ? .regular : .bold)
                    .privacySensitive()
                Text("/ \(WidgetFormat.number(s.kcalTarget)) kcal")
                    .musqNumber(12, .medium)
                    .opacity(0.7)
                    .privacySensitive()
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)

            if theme.style == .minimal {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(.primary.opacity(0.2))
                        Capsule().fill(.primary)
                            .frame(width: max(2, geo.size.width * s.kcalProgress))
                    }
                }
                .frame(height: 2)
                .padding(.vertical, 2)
            } else {
                Gauge(value: s.kcalProgress) { EmptyView() }
                    .gaugeStyle(.accessoryLinearCapacity)
                    .tint(theme.style == .bold ? .white : nil)
                    .widgetAccentable()
            }

            HStack(spacing: 3) {
                Image(systemName: s.trainedToday ? "checkmark.circle.fill" : "dumbbell.fill")
                    .font(.system(size: 11, weight: .bold))
                Text("\(next.title) · \(next.detail)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .monospacedDigit()
            }
            .lineLimit(1)
            .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Previews

private extension TodaySnapshot {
    static var previewRestDay: TodaySnapshot {
        var s = TodaySnapshot.sample
        s.isTrainingDay = false
        s.waterML = 2600; s.kcalEaten = 2050; s.mealsCount = 3
        s.nextTrainingLabel = "Legs"
        s.nextTrainingDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        s.nextTrainingTime = nil
        return s
    }
}

#Preview("Small", as: .systemSmall) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, snapshot: .sample, style: .bold)
    TodayEntry(date: .now, snapshot: .sample, style: .glass)
    TodayEntry(date: .now, snapshot: .sample, style: .minimal)
    TodayEntry(date: .now, snapshot: .previewRestDay, style: .bold)
    TodayEntry(date: .now, snapshot: .empty, style: .glass)
}

#Preview("Medium", as: .systemMedium) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, snapshot: .sample, style: .bold)
    TodayEntry(date: .now, snapshot: .sample, style: .glass)
    TodayEntry(date: .now, snapshot: .sample, style: .minimal)
    TodayEntry(date: .now, snapshot: .previewRestDay, style: .glass)
}

#Preview("Lock circular", as: .accessoryCircular) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, snapshot: .sample, style: .bold)
    TodayEntry(date: .now, snapshot: .sample, style: .glass)
    TodayEntry(date: .now, snapshot: .sample, style: .minimal)
}

#Preview("Lock rectangular", as: .accessoryRectangular) {
    TodayWidget()
} timeline: {
    TodayEntry(date: .now, snapshot: .sample, style: .bold)
    TodayEntry(date: .now, snapshot: .sample, style: .glass)
    TodayEntry(date: .now, snapshot: .previewRestDay, style: .minimal)
}
