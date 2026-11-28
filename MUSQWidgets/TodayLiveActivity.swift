//
//  TodayLiveActivity.swift
//  MUSQWidgets
//
//  The opt-in Today Live Activity: water ring, kcal eaten / target, meals and
//  the next training day, with +250 ml (AddWaterIntent, run in the app) and
//  Log meal (opens musq://quicklog/food). Drawn in IslandStyle.current.
//

import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

struct TodayLiveActivity: Widget {
    /// Previews pin a style; the real widget reads the shared setting.
    var style: IslandStyle? = nil

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TodayActivityAttributes.self) { context in
            let theme = WidgetTheme(style ?? context.state.style ?? .current)
            let isOld = context.state.isOld(attributesDay: context.attributes.day, isStale: context.isStale)
            TodayLockScreenView(state: isOld ? context.state.newDay : context.state, theme: theme, isNewDay: isOld)
                .activityBackgroundTint(theme.activityBackground)
                .activitySystemActionForegroundColor(theme.systemActionTint)
                .widgetURL(MUSQLink.today)
        } dynamicIsland: { context in
            let theme = WidgetTheme(style ?? context.state.style ?? .current)
            // Past midnight without an update (the app suspended): yesterday's
            // numbers must not read as today's — zeros and "New day".
            let isOld = context.state.isOld(attributesDay: context.attributes.day, isStale: context.isStale)
            let state = isOld ? context.state.newDay : context.state
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    TodayIslandMetric(title: L("Water"), value: WidgetFormat.litres(state.waterML), unit: "L",
                                      progress: state.waterProgress, color: theme.islandWater,
                                      icon: "drop.fill", theme: theme)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    TodayIslandMetric(title: L("Kcal"), value: WidgetFormat.number(state.kcalEaten), unit: nil,
                                      progress: state.kcalProgress, color: theme.islandKcal,
                                      icon: "flame.fill", theme: theme, trailing: true, sensitive: true)
                }
                DynamicIslandExpandedRegion(.center) {
                    TodayIslandCenter(state: state, theme: theme, isNewDay: isOld)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    TodayActions(theme: theme, onDark: true, height: 34)
                        .padding(.top, 6)
                }
            } compactLeading: {
                // The glyph alone, at the workout glyph's size: a ring
                // around an 8 pt drop read as a blob at arm's length.
                Image(systemName: "drop.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(theme.islandWater)
                    .padding(.leading, 2)
            } compactTrailing: {
                // Compact form ("1.4K"): the full number widened the island
                // into the status bar.
                Text(WidgetFormat.compact(state.kcalEaten))
                    .musqNumber(15, theme.style == .minimal ? .medium : .bold)
                    .foregroundStyle(theme.islandKcal)
                    .lineLimit(1)
                    .frame(maxWidth: 44, alignment: .trailing)
                    .privacySensitive()
                    .padding(.trailing, 2)
            } minimal: {
                // The water ring alone: the progress is the information.
                MetricRing(progress: state.waterProgress, color: theme.islandWater, theme: theme,
                           lineWidth: theme.style == .minimal ? 2 : 3.5)
            }
            .keylineTint(theme.islandWater)
            .contentMargins(.horizontal, 18, for: .expanded)
            .widgetURL(MUSQLink.today)
        }
    }
}

// MARK: - Island pieces

private struct TodayIslandMetric: View {
    var title: String
    var value: String
    var unit: String?
    var progress: Double
    var color: Color
    var icon: String
    var theme: WidgetTheme
    var trailing = false
    var sensitive = false

    var body: some View {
        HStack(spacing: 8) {
            if trailing { numbers }
            MetricRing(progress: progress, color: color, theme: theme)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(color)
                }
                .frame(width: 38, height: 38)
            if !trailing { numbers }
        }
        .frame(maxWidth: .infinity, alignment: trailing ? .trailing : .leading)
        .padding(.top, 4)
    }

    private var numbers: some View {
        VStack(alignment: trailing ? .trailing : .leading, spacing: 0) {
            TrackedLabel(text: title, theme: theme, size: 10, color: .white.opacity(0.55))
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text(value).musqNumber(18, theme.numberWeight == .light ? .regular : .bold)
                if let unit {
                    Text(unit).musqNumber(11, .semibold).foregroundStyle(.white.opacity(0.6))
                }
            }
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .privacySensitive(sensitive)
        }
    }
}

private struct TodayIslandCenter: View {
    var state: TodayActivityAttributes.ContentState
    var theme: WidgetTheme
    var isNewDay = false

    var body: some View {
        let next = state.nextLine(isNewDay: isNewDay)
        VStack(spacing: 1) {
            HStack(spacing: 4) {
                Image(systemName: state.lineIcon(isNewDay: isNewDay))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(theme.islandAccent)
                Text(next.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
            }
            Text(next.detail)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white.opacity(0.55))
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .padding(.top, 4)
    }
}

/// +250 ml (intent, runs in the app) and Log meal (opens the app).
struct TodayActions: View {
    var theme: WidgetTheme
    var onDark: Bool
    var height: CGFloat

    var body: some View {
        HStack(spacing: 8) {
            Button(intent: AddWaterIntent(ml: 250)) {
                if onDark {
                    theme.darkPrimaryPill("+250 ml", "drop.fill", accent: theme.islandWater, height: height)
                } else {
                    theme.cardPrimaryPill("+250 ml", "drop.fill", accent: theme.cardWater, height: height)
                }
            }
            .buttonStyle(.plain)
            Link(destination: MUSQLink.quickLogFood) {
                if onDark {
                    theme.darkSecondaryPill(L("Log meal"), "fork.knife", height: height)
                } else {
                    theme.cardSecondaryPill(L("Log meal"), "fork.knife", height: height)
                }
            }
        }
    }
}

// MARK: - Lock Screen / banner

struct TodayLockScreenView: View {
    var state: TodayActivityAttributes.ContentState
    var theme: WidgetTheme
    var isNewDay = false

    var body: some View {
        let next = state.nextLine(isNewDay: isNewDay)
        VStack(spacing: 14) {
            HStack(alignment: .center, spacing: 14) {
                // Water ring with kcal ring nested inside (glass/minimal) or
                // a single bold ring with the litres in it (bold).
                ZStack {
                    MetricRing(progress: state.waterProgress, color: theme.cardWater, theme: theme)
                        .frame(width: 64, height: 64)
                    if theme.style == .bold {
                        VStack(spacing: -2) {
                            Text(WidgetFormat.litres(state.waterML))
                                .musqNumber(19, theme.numberWeight)
                                .foregroundStyle(theme.cardPrimary)
                            Text("L").musqNumber(10, .bold).foregroundStyle(theme.cardSecondary)
                        }
                    } else {
                        MetricRing(progress: state.kcalProgress, color: theme.cardKcal, theme: theme)
                            .frame(width: 44, height: 44)
                        Image(systemName: "drop.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(theme.cardWater)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 0) {
                        stat(title: L("Water"), value: WidgetFormat.water(state.waterML),
                             detail: L("of \(WidgetFormat.water(state.waterTargetML))"), color: theme.cardWater,
                             emphasized: theme.style == .bold)
                        stat(title: L("Kcal"), value: WidgetFormat.number(state.kcalEaten),
                             detail: L("of \(WidgetFormat.number(state.kcalTarget))"), color: theme.cardKcal,
                             sensitive: true)
                        stat(title: L("Meals"), value: "\(state.mealsCount)",
                             detail: state.mealsCount == 1 ? L("meal") : L("meals"), color: theme.cardPrimary)
                    }
                    HStack(spacing: 5) {
                        Image(systemName: state.lineIcon(isNewDay: isNewDay))
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(theme.style == .minimal ? theme.cardPrimary : theme.cardWorkout)
                        Text(next.title)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(theme.cardPrimary)
                        Text(next.detail)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(theme.cardSecondary)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            TodayActions(theme: theme, onDark: false, height: 36)
        }
        .padding(16)
    }

    private func stat(title: String, value: String, detail: String, color: Color,
                      emphasized: Bool = false, sensitive: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            TrackedLabel(text: title, theme: theme, size: 10, color: theme.cardSecondary)
            Text(value)
                .musqNumber(18, theme.numberWeight == .light ? .regular : .bold)
                .foregroundStyle(emphasized ? theme.cardPrimary : color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .privacySensitive(sensitive)
            Text(detail)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(theme.cardSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .privacySensitive(sensitive)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - New day

extension TodayActivityAttributes.ContentState {
    /// What a card from an earlier day shows after midnight: nothing logged
    /// yet (the app brings the real numbers on its next run).
    var newDay: Self {
        var s = self
        s.waterML = 0; s.kcalEaten = 0; s.mealsCount = 0
        s.trainedToday = false
        return s
    }

    /// The training line, or "New day · Open MUSQ" on a card from an
    /// earlier day (its plan is yesterday's).
    func nextLine(isNewDay: Bool) -> (title: String, detail: String) {
        if isNewDay { return (L("New day"), L("Open MUSQ")) }
        return WidgetFormat.nextTraining(label: nextTrainingLabel, day: nextTrainingDay,
                                         time: nextTrainingTime, isTrainingDay: isTrainingDay,
                                         trainedToday: trainedToday)
    }

    func lineIcon(isNewDay: Bool) -> String {
        if isNewDay { return "sunrise.fill" }
        if trainedToday { return "checkmark.circle.fill" }
        return isTrainingDay ? "dumbbell.fill" : "moon.zzz.fill"
    }
}

// MARK: - Previews

private let todayPreviewAttributes = TodayActivityAttributes(day: Calendar.current.startOfDay(for: Date()))

extension TodayActivityAttributes.ContentState {
    /// Preview-only: workout done, next one tomorrow.
    static var previewTrained: Self {
        var s = sample
        s.waterML = 2750; s.kcalEaten = 2380; s.mealsCount = 4
        s.trainedToday = true
        s.nextTrainingLabel = "Legs"
        s.nextTrainingDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        return s
    }
}

#Preview("Today lock · Bold", as: .content, using: todayPreviewAttributes) {
    TodayLiveActivity(style: .bold)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
    TodayActivityAttributes.ContentState.previewTrained
}

#Preview("Today lock · Glass", as: .content, using: todayPreviewAttributes) {
    TodayLiveActivity(style: .glass)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
    TodayActivityAttributes.ContentState.previewTrained
}

#Preview("Today lock · Minimal", as: .content, using: todayPreviewAttributes) {
    TodayLiveActivity(style: .minimal)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
    TodayActivityAttributes.ContentState.previewTrained
}

#Preview("Today expanded · Bold", as: .dynamicIsland(.expanded), using: todayPreviewAttributes) {
    TodayLiveActivity(style: .bold)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
}

#Preview("Today expanded · Glass", as: .dynamicIsland(.expanded), using: todayPreviewAttributes) {
    TodayLiveActivity(style: .glass)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
}

#Preview("Today expanded · Minimal", as: .dynamicIsland(.expanded), using: todayPreviewAttributes) {
    TodayLiveActivity(style: .minimal)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
    TodayActivityAttributes.ContentState.previewTrained
}

#Preview("Today compact · Bold", as: .dynamicIsland(.compact), using: todayPreviewAttributes) {
    TodayLiveActivity(style: .bold)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
}

#Preview("Today compact · Glass", as: .dynamicIsland(.compact), using: todayPreviewAttributes) {
    TodayLiveActivity(style: .glass)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
}

#Preview("Today compact · Minimal", as: .dynamicIsland(.compact), using: todayPreviewAttributes) {
    TodayLiveActivity(style: .minimal)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
}

#Preview("Today minimal · Bold", as: .dynamicIsland(.minimal), using: todayPreviewAttributes) {
    TodayLiveActivity(style: .bold)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
}

#Preview("Today minimal · Glass", as: .dynamicIsland(.minimal), using: todayPreviewAttributes) {
    TodayLiveActivity(style: .glass)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
}

#Preview("Today minimal · Minimal", as: .dynamicIsland(.minimal), using: todayPreviewAttributes) {
    TodayLiveActivity(style: .minimal)
} contentStates: {
    TodayActivityAttributes.ContentState.sample
}
