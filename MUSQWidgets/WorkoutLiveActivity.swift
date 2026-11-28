//
//  WorkoutLiveActivity.swift
//  MUSQWidgets
//
//  The workout Live Activity: a Lock Screen / banner card and the Dynamic
//  Island (compact, minimal, expanded), drawn in the style picked in the App
//  Group (IslandStyle.current). Rest counts down live from restEndsAt with
//  Text(timerInterval:) / ProgressView(timerInterval:) — no app updates needed
//  while it runs. Buttons are LiveActivityIntents run in the app's process.
//

import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

struct WorkoutLiveActivity: Widget {
    /// Previews pin a style; the real widget reads the shared setting.
    var style: IslandStyle? = nil

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkoutActivityAttributes.self) { context in
            let theme = WidgetTheme(style ?? context.state.style ?? .current)
            WorkoutLockScreenView(attributes: context.attributes, state: context.state, theme: theme)
                .activityBackgroundTint(theme.activityBackground)
                .activitySystemActionForegroundColor(theme.systemActionTint)
                .widgetURL(MUSQLink.workout)
        } dynamicIsland: { context in
            let theme = WidgetTheme(style ?? context.state.style ?? .current)
            let state = context.state
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    WorkoutIslandLeading(state: state, theme: theme)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    WorkoutIslandTrailing(attributes: context.attributes, state: state, theme: theme)
                }
                DynamicIslandExpandedRegion(.center) {
                    WorkoutIslandCenter(state: state, theme: theme)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    WorkoutIslandBottom(state: state, theme: theme)
                }
            } compactLeading: {
                Image(systemName: state.isFinished ? "checkmark" : "dumbbell.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(theme.islandWorkout)
                    .padding(.leading, 2)
            } compactTrailing: {
                WorkoutCompactTrailing(state: state, theme: theme)
            } minimal: {
                WorkoutMinimal(state: state, theme: theme)
            }
            .keylineTint(theme.islandWorkout)
            .contentMargins(.horizontal, 18, for: .expanded)
            .widgetURL(MUSQLink.workout)
        }
    }
}

// MARK: - Compact & minimal

private struct WorkoutCompactTrailing: View {
    var state: WorkoutActivityAttributes.ContentState
    var theme: WidgetTheme

    var body: some View {
        Group {
            if let rest = state.liveRest {
                Text(timerInterval: rest, countsDown: true)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 42)
                    .foregroundStyle(theme.islandWorkout)
            } else {
                Text(state.setsFraction)
                    .foregroundStyle(theme.style == .bold ? .white : theme.islandWorkout)
            }
        }
        .musqNumber(15, theme.style == .minimal ? .medium : .bold)
        .padding(.trailing, 2)
    }
}

private struct WorkoutMinimal: View {
    var state: WorkoutActivityAttributes.ContentState
    var theme: WidgetTheme

    var body: some View {
        if let rest = state.liveRest {
            CountdownRing(interval: rest, color: theme.islandWorkout)
                .overlay {
                    Image(systemName: "timer")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(theme.islandWorkout)
                }
        } else {
            MetricRing(progress: state.isFinished ? 1 : state.setsProgress,
                       color: theme.islandWorkout, theme: theme,
                       lineWidth: theme.style == .minimal ? 1.5 : 3)
                .overlay {
                    if state.isFinished {
                        Image(systemName: "checkmark").font(.system(size: 9, weight: .heavy))
                    } else {
                        Text("\(state.setsDone)").musqNumber(11, .bold)
                    }
                }
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Expanded

private struct WorkoutIslandLeading: View {
    var state: WorkoutActivityAttributes.ContentState
    var theme: WidgetTheme

    var body: some View {
        HStack(spacing: 8) {
            WorkoutGlyph(theme: theme, onDark: true, size: 30, finished: state.isFinished)
            VStack(alignment: .leading, spacing: 0) {
                TrackedLabel(text: L("Set"), theme: theme, size: 10, color: .white.opacity(0.55))
                Text(state.isFinished ? "—" : "\(state.setNumber)/\(state.setsInExercise)")
                    .musqNumber(17, theme.numberWeight == .light ? .regular : .bold)
                    .foregroundStyle(.white)
            }
        }
        .padding(.top, 4)
    }
}

private struct WorkoutIslandTrailing: View {
    var attributes: WorkoutActivityAttributes
    var state: WorkoutActivityAttributes.ContentState
    var theme: WidgetTheme

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            TrackedLabel(text: L("Sets"), theme: theme, size: 10, color: .white.opacity(0.55))
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text("\(state.setsDone)")
                    .foregroundStyle(theme.islandAccent)
                Text("/\(state.setsTotal)")
                    .foregroundStyle(.white.opacity(0.6))
            }
            .musqNumber(17, theme.numberWeight == .light ? .regular : .bold)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 4)
    }
}

private struct WorkoutIslandCenter: View {
    var state: WorkoutActivityAttributes.ContentState
    var theme: WidgetTheme

    var body: some View {
        VStack(spacing: 1) {
            Text(state.isFinished ? L("Workout complete") : state.exerciseName)
                .font(.system(size: 15, weight: theme.style == .minimal ? .medium : .semibold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(state.isFinished ? L("\(state.setsDone) sets done")
                 : L("\(state.muscleGroup) · \(state.exerciseIndex) of \(state.exerciseCount)"))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white.opacity(0.55))
                .lineLimit(1)
        }
        .padding(.top, 4)
    }
}

private struct WorkoutIslandBottom: View {
    var state: WorkoutActivityAttributes.ContentState
    var theme: WidgetTheme

    // The expanded island tops out near 160 pt: the ring sits beside the
    // target and the buttons (one row) so the buttons are never clipped.
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 1) {
                    TrackedLabel(text: state.islandLabel,
                                 theme: theme, size: 10, color: theme.islandAccent.opacity(0.9))
                    Text(state.isFinished ? L("All done") : state.targetText)
                        .musqNumber(21, theme.numberWeight)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                if !state.isFinished {
                    WorkoutButtons(state: state, theme: theme, onDark: true, height: 30)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            WorkoutBigRing(state: state, theme: theme, onDark: true, size: 54)
        }
        .padding(.top, 2)
    }
}

// MARK: - Shared pieces

struct WorkoutGlyph: View {
    var theme: WidgetTheme
    var onDark: Bool
    var size: CGFloat
    var finished = false

    var body: some View {
        let accent = onDark ? theme.islandWorkout : theme.cardWorkout
        Image(systemName: finished ? "checkmark" : "dumbbell.fill")
            .font(.system(size: size * 0.44, weight: .bold))
            .rotationEffect(.degrees(finished ? 0 : -30))
            .foregroundStyle(glyphForeground(accent))
            .frame(width: size, height: size)
            .background(glyphBackground(accent), in: Circle())
            .overlay {
                if theme.style == .minimal {
                    Circle().strokeBorder(accent.opacity(0.5), lineWidth: 1)
                }
            }
    }

    private func glyphForeground(_ accent: Color) -> Color {
        switch theme.style {
        case .bold: .black
        case .glass: accent
        case .minimal: accent
        }
    }

    private func glyphBackground(_ accent: Color) -> AnyShapeStyle {
        switch theme.style {
        case .bold: AnyShapeStyle(accent)
        case .glass: AnyShapeStyle(accent.opacity(0.22))
        case .minimal: AnyShapeStyle(Color.clear)
        }
    }
}

/// Rest countdown ring while resting, sets ring otherwise.
struct WorkoutBigRing: View {
    var state: WorkoutActivityAttributes.ContentState
    var theme: WidgetTheme
    var onDark: Bool
    var size: CGFloat

    var body: some View {
        let accent = onDark ? theme.islandWorkout : theme.cardWorkout
        let primary: Color = onDark ? .white : theme.cardPrimary
        ZStack {
            if let rest = state.liveRest {
                CountdownRing(interval: rest, color: accent)
                    .frame(width: size, height: size)
                Text(timerInterval: rest, countsDown: true)
                    .musqNumber(size * 0.27, theme.style == .minimal ? .regular : .bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(primary)
                    .frame(width: size * 0.78)
            } else {
                MetricRing(progress: state.isFinished ? 1 : state.setsProgress, color: accent, theme: theme)
                    .frame(width: size, height: size)
                if state.isFinished {
                    Image(systemName: "checkmark")
                        .font(.system(size: size * 0.32, weight: .heavy))
                        .foregroundStyle(accent)
                } else {
                    VStack(spacing: -2) {
                        Text("\(state.setsDone)")
                            .musqNumber(size * 0.32, theme.numberWeight)
                            .foregroundStyle(primary)
                        Text(L("of \(state.setsTotal)"))
                            .musqNumber(size * 0.16, .medium)
                            .foregroundStyle(primary.opacity(0.55))
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}

/// Resting: −15 s · +15 s · Skip. Lifting: Done set.
struct WorkoutButtons: View {
    var state: WorkoutActivityAttributes.ContentState
    var theme: WidgetTheme
    var onDark: Bool
    var height: CGFloat

    var body: some View {
        let accent = onDark ? theme.islandWorkout : theme.cardWorkout
        HStack(spacing: 8) {
            if state.isAllDone {
                // Nothing left to tick: Complete Workout is in the app.
                Link(destination: MUSQLink.workout) {
                    primary(L("Finish workout"), "flag.checkered", accent)
                }
            } else if state.liveRest != nil {
                Button(intent: RestAdjustIntent(seconds: -15)) {
                    secondary("−15 s")
                }
                Button(intent: RestAdjustIntent(seconds: 15)) {
                    secondary("+15 s")
                }
                Button(intent: SkipRestIntent()) {
                    primary(L("Skip"), "forward.end.fill", accent)
                }
            } else {
                Button(intent: DoneSetIntent()) {
                    primary(L("Done set"), "checkmark", accent)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func primary(_ t: String, _ icon: String, _ accent: Color) -> PillLabel {
        onDark ? theme.darkPrimaryPill(t, icon, accent: accent, height: height)
               : theme.cardPrimaryPill(t, icon, accent: accent, height: height)
    }

    private func secondary(_ t: String) -> PillLabel {
        onDark ? theme.darkSecondaryPill(t, height: height) : theme.cardSecondaryPill(t, height: height)
    }
}

/// One capsule per set of the whole workout (capped), done ones filled.
struct SetsTrack: View {
    var done: Int
    var total: Int
    var color: Color
    var theme: WidgetTheme

    var body: some View {
        let count = max(1, min(total, 24))
        let filled = total > 24 ? Int((Double(done) / Double(max(total, 1)) * 24).rounded()) : done
        HStack(spacing: count > 14 ? 2 : 3) {
            ForEach(0..<count, id: \.self) { i in
                Capsule()
                    .fill(i < filled ? color : color.opacity(theme.trackOpacity))
                    .frame(height: theme.style == .minimal ? 2 : 4)
            }
        }
    }
}

// MARK: - Lock Screen / banner

struct WorkoutLockScreenView: View {
    var attributes: WorkoutActivityAttributes
    var state: WorkoutActivityAttributes.ContentState
    var theme: WidgetTheme

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center, spacing: 10) {
                WorkoutGlyph(theme: theme, onDark: false, size: 28, finished: state.isFinished)
                VStack(alignment: .leading, spacing: 0) {
                    TrackedLabel(text: "\(attributes.workoutName) · \(state.muscleGroup)",
                                 theme: theme, size: 11, color: theme.cardSecondary)
                    Text(state.isFinished ? L("Workout complete") : state.exerciseName)
                        .font(.system(size: 17, weight: theme.style == .minimal ? .medium : .semibold,
                                      design: .rounded))
                        .foregroundStyle(theme.cardPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                Spacer(minLength: 6)
                VStack(alignment: .trailing, spacing: 0) {
                    TrackedLabel(text: L("Time"), theme: theme, size: 10, color: theme.cardSecondary)
                    Text(attributes.startedAt, style: .timer)
                        .musqNumber(15, theme.style == .minimal ? .regular : .semibold)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(theme.cardPrimary)
                        .frame(maxWidth: 64, alignment: .trailing)
                }
            }

            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        TrackedLabel(text: label, theme: theme, size: 10,
                                     color: theme.style == .minimal ? theme.cardSecondary : theme.cardWorkout)
                        Spacer(minLength: 4)
                        Text(state.isFinished ? L("Session saved")
                             : (state.isAllDone ? state.setsFraction
                                : L("Set \(state.setNumber)/\(state.setsInExercise) · \(state.setsFraction)")))
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(theme.cardSecondary)
                            .lineLimit(1)
                    }
                    Text(state.isFinished ? L("\(state.setsDone) sets") : state.targetText)
                        .musqNumber(24, theme.numberWeight)
                        .foregroundStyle(theme.cardPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    SetsTrack(done: state.setsDone, total: state.setsTotal,
                              color: theme.cardWorkout, theme: theme)
                }
                WorkoutBigRing(state: state, theme: theme, onDark: false, size: 52)
            }

            if !state.isFinished {
                WorkoutButtons(state: state, theme: theme, onDark: false, height: 30)
            }
        }
        // The Lock Screen card is capped at 160 pt tall: tight insets keep the
        // header, target, ring and buttons inside it.
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var label: String {
        if state.isFinished { return L("Great session") }
        if state.isAllDone { return L("All sets done") }
        if state.liveRest != nil { return L("Rest · next set") }
        return state.restOver ? L("Rest over · next set") : L("Next set")
    }
}

// MARK: - Previews

#Preview("Lock · Bold · Rest", as: .content, using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .bold)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

#Preview("Lock · Glass", as: .content, using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .glass)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

#Preview("Lock · Minimal", as: .content, using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .minimal)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
    WorkoutActivityAttributes.ContentState.previewAllDone
    WorkoutActivityAttributes.ContentState.previewFinished
}

#Preview("Island expanded · Bold", as: .dynamicIsland(.expanded), using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .bold)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

#Preview("Island expanded · Glass", as: .dynamicIsland(.expanded), using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .glass)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

#Preview("Island expanded · Minimal", as: .dynamicIsland(.expanded), using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .minimal)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
    WorkoutActivityAttributes.ContentState.previewFinished
}

#Preview("Island compact · Bold", as: .dynamicIsland(.compact), using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .bold)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

#Preview("Island compact · Glass", as: .dynamicIsland(.compact), using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .glass)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

#Preview("Island compact · Minimal", as: .dynamicIsland(.compact), using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .minimal)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

#Preview("Island minimal · Bold", as: .dynamicIsland(.minimal), using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .bold)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

#Preview("Island minimal · Glass", as: .dynamicIsland(.minimal), using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .glass)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

#Preview("Island minimal · Minimal", as: .dynamicIsland(.minimal), using: WorkoutActivityAttributes.sample) {
    WorkoutLiveActivity(style: .minimal)
} contentStates: {
    WorkoutActivityAttributes.ContentState.sampleResting
    WorkoutActivityAttributes.ContentState.sampleLifting
}

extension WorkoutActivityAttributes.ContentState {
    /// The label over the target in the expanded island.
    var islandLabel: String {
        if isFinished { return L("Great session") }
        if isAllDone { return L("All sets done") }
        if liveRest != nil { return L("Rest · then") }
        return restOver ? L("Rest over · next set") : L("Next set")
    }

    /// Preview-only: every set ticked, Complete not tapped.
    static var previewAllDone: Self {
        var s = sampleLifting
        s.setsDone = s.setsTotal
        s.allSetsDone = true
        s.nextTargetText = nil
        return s
    }

    /// Preview-only: the final state after Complete Workout.
    static var previewFinished: Self {
        var s = sampleLifting
        s.setsDone = s.setsTotal
        s.isFinished = true
        return s
    }
}
