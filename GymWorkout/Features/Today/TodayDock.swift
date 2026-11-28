//
//  TodayDock.swift
//  GymWorkout
//
//  Today's quick-log dock (2026-11-27, the owner's "lazy thumb"): big round
//  buttons pinned just above the tab bar, where the thumb already is. Water
//  adds a glass on a tap (press and hold for an amount), Walk and Sleep open
//  their logs, the mic opens the quick log already listening, and "Your
//  day" opens the full day panel. Vivid colours, one per habit.
//

import SwiftUI

struct TodayDock: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    @Environment(\.dsChrome) private var windowChrome
    /// Bumped on each glass, for the haptic.
    @State private var glasses = 0

    static let mic = DS.activation

    var body: some View {
        let glass = metrics.waterPresets.first ?? 250
        HStack(alignment: .top, spacing: 0) {
            DockButton(symbol: "drop.fill", title: String(localized: "+\(glass) ml", comment: "Adds a glass of water: +250 ml"),
                       tint: TodayTone.water,
                       progress: metrics.waterCounts ? metrics.waterProgress : nil) {
                glasses += 1
                actions.addWater(glass)
            } onHold: {
                actions.quickLog(.water)
            }
            .accessibilityLabel(String(localized: "Add \(glass) ml", comment: "Adds water: Add 250 ml"))
            .accessibilityValue("\(DailyStore.litres(metrics.waterMl)) / \(DailyStore.litres(metrics.waterTarget))")
            .accessibilityHint(String(localized: "Press and hold for another amount", comment: "Dock water button hint"))
            .accessibilityAction(named: TodayWaterText.custom) { actions.quickLog(.water) }

            DockButton(symbol: "figure.walk", title: String(localized: "Walk", comment: "Dock: log a walk"),
                       tint: JourneyPalette.walk,
                       progress: metrics.showsSteps ? metrics.stepsProgress : nil) {
                actions.quickLog(.steps)
            }
            .accessibilityLabel(String(localized: "Log a walk", comment: "Dock walk button"))

            DockButton(symbol: "bed.double.fill", title: String(localized: "Sleep", comment: "Dock: log last night's sleep"),
                       tint: SleepLogSheet.tint,
                       progress: sleepProgress) {
                actions.logSleep()
            }
            .accessibilityLabel(String(localized: "Log last night's sleep", comment: "Dock sleep button"))

            DockButton(symbol: "mic.fill", title: String(localized: "Say it", comment: "Dock: the quick log's mic"),
                       tint: Self.mic, filled: true) {
                actions.voiceLog()
            }
            .accessibilityLabel(String(localized: "Log water, a walk or a meal"))
            .accessibilityHint(String(localized: "Type it or say it"))

            DockButton(symbol: "checklist", title: String(localized: "Your day", comment: "Today: the day's habits"),
                       tint: DS.silver, badge: tally) {
                actions.openYourDay()
            }
            .accessibilityLabel(String(localized: "Your day", comment: "Today: the day's habits"))
            .accessibilityValue(tally ?? "")
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 6)
        .frame(maxWidth: 560)
        .frame(maxWidth: .infinity)
        .background {
            DS.chrome
                .background(.ultraThinMaterial)
                .overlay(alignment: .top) {
                    Rectangle().fill(DS.silver.opacity(0.08)).frame(height: 1)
                }
                // Below the tab bar's own ground on the phone: none between them.
                .ignoresSafeArea(edges: windowChrome.isSidebar ? .bottom : [])
        }
        .sensoryFeedback(.increase, trigger: glasses)
    }

    /// Last night against the goal: Apple Health's night, else the one
    /// logged here by hand; no ring when neither has one.
    private var sleepProgress: Double? {
        guard let minutes = metrics.lastNightMinutes ?? metrics.manualSleepMinutes else { return nil }
        return min(1, Double(minutes) / Double(max(metrics.sleepGoalMinutes, 1)))
    }

    /// "2/3": what counts today and how much of it is done.
    private var tally: String? {
        var items: [Bool] = []
        if metrics.waterCounts { items.append(metrics.waterReached) }
        if metrics.workoutCounts { items.append(metrics.workoutDone) }
        if metrics.weighInCounts { items.append(metrics.weighedIn) }
        guard !items.isEmpty else { return nil }
        return "\(items.filter { $0 }.count)/\(items.count)"
    }
}

/// One round dock button: a tinted disc with its glyph (a progress ring
/// around it where there's a goal), a short name under it.
private struct DockButton: View {
    var symbol: String
    var title: String
    var tint: Color
    var progress: Double? = nil
    var filled = false
    var badge: String? = nil
    var action: () -> Void
    var onHold: (() -> Void)? = nil

    @ScaledMetric(relativeTo: .body) private var disc: CGFloat = 52
    @State private var pressed = false

    var body: some View {
        let face = VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(filled ? AnyShapeStyle(tint) : AnyShapeStyle(tint.opacity(0.16)))
                if let progress {
                    Ring(progress: progress, color: tint, lineWidth: 3)
                        .padding(1.5)
                }
                StyledSymbol(name: symbol, size: disc * 0.38)
                    .foregroundStyle(filled ? Color.white : tint)
            }
            .frame(width: min(disc, 64), height: min(disc, 64))
            .overlay(alignment: .topTrailing) {
                if let badge {
                    Text(badge)
                        .font(.ui(10.5, .bold))
                        .monospacedDigit()
                        .foregroundStyle(DS.ink)
                        .padding(.horizontal, 5)
                        .frame(height: 18)
                        .background(Capsule().fill(DS.silver))
                        .offset(x: 6, y: -4)
                }
            }
            .scaleEffect(pressed ? 0.92 : 1)
            Text(title)
                .font(.ui(11, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver.opacity(0.75))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())

        Group {
            if let onHold {
                face
                    .onTapGesture { action() }
                    .onLongPressGesture(minimumDuration: 0.45, pressing: { isDown in
                        withAnimation(.easeOut(duration: 0.12)) { pressed = isDown }
                    }, perform: onHold)
                    .accessibilityElement(children: .ignore)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAction { action() }
            } else {
                Button(action: action) { face }
                    .buttonStyle(DockPressStyle())
                    .accessibilityElement(children: .ignore)
            }
        }
    }
}

private struct DockPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
