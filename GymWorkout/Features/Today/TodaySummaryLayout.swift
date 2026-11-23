//
//  TodaySummaryLayout.swift
//  GymWorkout
//
//  Candidate A for the Today tab (2026-11-21), after Apple Fitness's
//  Summary: three rings tell how the day is going in two seconds, then
//  each block takes the shape of its job — the session poster, two tiles
//  (a week of water, the plan's calories), two more from Apple Health
//  (steps, last night's sleep), the weight trend and the reminders on the
//  ground. Each habit owns one colour: blue water, orange workout, pink
//  weight, and Health's own for steps and sleep; values in the rings'
//  legend take it too. 2026-11-22: Balance's card under the session, the
//  quick log by the water tile, and the water legend and tile open the
//  water log.
//

import SwiftUI

struct TodaySummaryLayout: View {
    var metrics: TodayMetrics
    var plan: NutritionPlan?
    var actions: TodayActions
    /// Train · Eat · Sleep over 7 days; nil while its card is off Today.
    var balance: Balance? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                TodayEyebrow(text: metrics.now.formatted(.dateTime.weekday(.wide).day().month(.wide)), size: 11)
                Text("Today", comment: "The Today tab's large title")
                    .font(.ui(28, .semibold))
                    .tracking(-0.7)
                    .foregroundStyle(DS.silver)
                    .accessibilityAddTraits(.isHeader)
            }
            .padding(.bottom, 4)
            if CoachChat.isAvailable {
                AskCoachBar(action: actions.askCoach)
            }
            TodayNotices(metrics: metrics, actions: actions)
            SummaryRings(metrics: metrics, actions: actions)
            SessionPoster(metrics: metrics, style: metrics.state.isQuiet ? .compact : .full,
                          eyebrow: String(localized: "Today's workout"),
                          isPrimary: !metrics.state.isQuiet && !metrics.needsPlan, actions: actions)
            if let goal = metrics.goal, let photo = metrics.goalPhoto {
                GoalTodayCard(progress: goal, photo: photo, onOpen: actions.openGoal)
            }
            if let balance {
                BalanceCard(balance: balance, onAction: actions.balanceAction, onOpen: actions.openBalance)
            }
            HStack(alignment: .top, spacing: 10) {
                WaterWeekTile(metrics: metrics, actions: actions)
                NutritionTile(metrics: metrics, plan: plan, actions: actions)
            }
            .fixedSize(horizontal: false, vertical: true)
            // Water, a walk without the phone, or a meal: typed or spoken.
            TodayQuickLogRow(actions: actions)
            // Apple Health: whichever of the two it has, or where to look
            // when it sent nothing (until that note is closed).
            if metrics.showsSteps || metrics.showsSleep {
                HStack(alignment: .top, spacing: 10) {
                    if metrics.showsSteps {
                        StepsWeekTile(metrics: metrics, actions: actions)
                    }
                    if metrics.showsSleep {
                        SleepWeekTile(metrics: metrics, actions: actions)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            // Steps added by hand aren't Health's: with Health sending
            // nothing, the note still says where to look beside them.
            if metrics.healthEmpty {
                TodayHealthEmptyNote()
            }
            // For everyone: a meal added by hand is free (the scan is Pro's).
            TodayMealsBlock(metrics: metrics, actions: actions)
                .padding(.top, 12)
            Hairline(opacity: 0.08)
                .padding(.top, 24)
            WeightOpenSection(plan: plan, tone: TodayTone.pink, coachLine: false, actions: actions)
                .padding(.top, 16)
            Hairline(opacity: 0.08)
                .padding(.top, 24)
            TodayReminderList(metrics: metrics, actions: actions, carded: false)
                .padding(.top, 16)
            TodayFootnote()
        }
    }
}

// MARK: - Rings

/// Water outermost (a daily habit, so the largest ring is never an empty
/// track on a rest day), the workout, then the weigh-in; their values beside
/// them in each ring's colour, and the one-tap logs under them. A ring that
/// doesn't count today (the workout on a rest or recovery day, the weigh-in
/// without its reminder) is a dashed track, never an empty goal.
private struct SummaryRings: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    @Environment(WorkoutStore.self) private var store
    @Environment(DailyStore.self) private var daily
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let m = metrics
        let workoutOff = !m.workoutCounts && m.setsPlanned == 0
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 18) {
                ZStack {
                    SymbolRing(progress: m.waterProgress, color: TodayTone.water, size: 140, lineWidth: 15,
                               symbol: "drop.fill", dashedTrack: !m.waterCounts)
                    SymbolRing(progress: m.workoutProgress, color: TodayTone.workout, size: 104, lineWidth: 15,
                               symbol: m.state == .rest ? "moon.zzz.fill" : m.state == .recovering ? "hourglass" : "dumbbell.fill",
                               dashedTrack: workoutOff)
                    SymbolRing(progress: m.weighInProgress, color: TodayTone.pink, size: 68, lineWidth: 15,
                               symbol: "scalemass.fill", dashedTrack: !m.weighInCounts && !m.weighedIn)
                }
                .frame(width: 140, height: 140)
                .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 11) {
                    waterLegend
                    workoutLegend
                    weighInLegend
                }
                Spacer(minLength: 0)
            }
            HStack(spacing: 8) {
                ForEach(Array(m.waterPresets.prefix(2).enumerated()), id: \.offset) { index, ml in
                    QuickChip(title: String(localized: "+\(ml) ml", comment: "Adds a glass of water: +250 ml"),
                              symbol: index == 0 ? "drop.fill" : nil) { actions.addWater(ml) }
                }
                Spacer(minLength: 0)
                QuickChip(title: m.weighedIn ? String(localized: "Edit weight") : String(localized: "Log weight"),
                          action: actions.logWeight)
            }
            if m.limitsFluids {
                Text("Ask your doctor how much to drink.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(DS.surfaceRaised)
            .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.05), radius: 16, y: 6))
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous)
            .strokeBorder(DS.silver.opacity(scheme == .dark ? 0.07 : 0.04), lineWidth: 1))
    }

    /// Opens the water log: a custom amount, the presets, today's glasses.
    private var waterLegend: some View {
        let litres = Double(metrics.waterMl) / 1_000
        return Button { actions.quickLog(.water) } label: {
            legend(symbol: "drop.fill", label: String(localized: "Water", comment: "Today ring"), tone: TodayTone.water) {
                // With the amount left to the doctor, no target beside it.
                BigValue(value: litres.formatted(.number.precision(.fractionLength(0...2))),
                         unit: TodayWaterText.litresUnit(target: metrics.waterCounts ? metrics.waterTarget : nil),
                         size: 26, color: TodayTone.water)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(TodayWaterText.opensLog)
    }

    private var workoutLegend: some View {
        legend(symbol: "dumbbell.fill", label: String(localized: "Workout", comment: "Today ring"), tone: TodayTone.workoutText) {
            switch metrics.state {
            case .planned, .inProgress:
                BigValue(value: "\(metrics.setsDone)", unit: "/ \(TodayCount.sets(metrics.setsPlanned))",
                         size: 26, color: TodayTone.workoutText)
            case .done:
                BigValue(value: String(localized: "today.state.done", defaultValue: "Done",
                                       comment: "Today's workout state: finished (not the Done button)"),
                         unit: "· \(TodayCount.sets(metrics.setsDone))", size: 22, color: TodayTone.workoutText)
            case .recommended:
                BigValue(value: String(localized: "Not started"), size: 22, color: TodayTone.workoutText)
            case .rest:
                BigValue(value: String(localized: "Rest day"), size: 22, color: TodayTone.workoutText)
            case .recovering:
                BigValue(value: String(localized: "Recovering", comment: "Workout ring legend: nothing recovered to train today; large text in a narrow column"),
                         size: 22, color: TodayTone.workoutText)
            }
        }
    }

    private var weighInLegend: some View {
        let unit = store.unit
        return legend(symbol: "scalemass.fill", label: String(localized: "Weigh-in", comment: "Today ring"), tone: TodayTone.pink) {
            if metrics.weighedIn, let latest = daily.latestWeight {
                let value = (unit.fromKilograms(latest.kg) * 10).rounded() / 10
                BigValue(value: value.formatted(.number.precision(.fractionLength(1))), unit: unit.symbol,
                         size: 26, color: TodayTone.pink)
            } else {
                // Not a miss: quiet silver unless the reminder makes it today's goal.
                BigValue(value: metrics.weighInCounts ? String(localized: "Not yet", comment: "No weigh-in yet today")
                                                      : String(localized: "Not today", comment: "No weigh-in today"),
                         size: 22, color: metrics.weighInCounts ? TodayTone.pink : DS.silver.opacity(0.6))
            }
        }
    }

    private func legend<Value: View>(symbol: String, label: String, tone: Color,
                                     @ViewBuilder value: () -> Value) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(spacing: 5) {
                Image(systemName: symbol)
                    .font(.system(size: 10, weight: .bold))
                Text(label)
                    .font(.mono(10.5, .semibold))
                    .trackingEm(0.08, size: 10.5)
                    .textCase(.uppercase)
            }
            .foregroundStyle(tone)
            value()
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Tiles

/// A week of water as bars against the target. Today's amount is in the
/// rings above, so the tile carries the average of the last seven finished
/// days instead.
private struct WaterWeekTile: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    @Environment(DailyStore.self) private var daily

    var body: some View {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: metrics.now)
        // Finished days only: today's first glass mustn't pull the average down.
        let average = daily.averageWater(days: 7, endingOn: today.addingTimeInterval(-1))
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Label(String(localized: "Water", comment: "Today tile"), systemImage: "drop.fill")
                    .font(.mono(10.5, .semibold))
                    .textCase(.uppercase)
                    .foregroundStyle(TodayTone.water)
                Spacer(minLength: 4)
                Menu {
                    Button(TodayWaterText.custom, systemImage: "drop") { actions.quickLog(.water) }
                    Button(String(localized: "Remove last glass"), systemImage: "arrow.uturn.backward") { actions.undoWater() }
                    Button(String(localized: "Water target & reminders"), systemImage: "slider.horizontal.3") { actions.waterSettings() }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .padding(.vertical, -8)
                .padding(.trailing, -8)
                .accessibilityLabel(String(localized: "More water options"))
            }
            // The rest of the tile opens the water log (a custom amount,
            // the presets, today's glasses).
            Button { actions.quickLog(.water) } label: {
                VStack(alignment: .leading, spacing: 0) {
                    BigValue(value: (Double(average) / 1_000).formatted(.number.precision(.fractionLength(0...2))),
                             unit: TodayWaterText.litresUnit(), size: 24)
                        .padding(.top, 4)
                    Text(metrics.limitsFluids ? String(localized: "Ask your doctor how much to drink.")
                                              : String(localized: "a day, last 7 days", comment: "Water tile: the week's average"))
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 12)
                    bars(today: today)
                        .frame(height: 52)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint(TodayWaterText.opensLog)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
    }

    /// The last seven days, oldest first, at midnight so their identities
    /// hold all day and today's bar grows instead of cross-fading.
    private func bars(today: Date) -> some View {
        let calendar = Calendar.current
        let days: [Date] = (0..<7).reversed().compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
        let totals = dayTotals(from: days.first ?? today)
        let target = Double(max(metrics.waterTarget, 1))
        return GeometryReader { geo in
            let barHeight = geo.size.height - 14
            ZStack(alignment: .topLeading) {
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(days, id: \.self) { day in
                        let ml = Double(totals[day] ?? 0)
                        let isToday = day == today
                        VStack(spacing: 0) {
                            Spacer(minLength: 0)
                            if ml > 0 {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(TodayTone.water.opacity(isToday ? 1 : 0.4))
                                    .frame(width: 10, height: max(4, barHeight * min(ml / target, 1.15) / 1.15))
                            } else {
                                Circle().fill(DS.silver.opacity(0.18)).frame(width: 4, height: 4)
                            }
                            Text(calendar.veryShortStandaloneWeekdaySymbols[calendar.component(.weekday, from: day) - 1])
                                .font(.mono(8.5, isToday ? .bold : .semibold))
                                .foregroundStyle(DS.silver.opacity(isToday ? 0.9 : 0.45))
                                .frame(height: 11)
                                .padding(.top, 3)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                Path { path in
                    let y = barHeight - barHeight / 1.15
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                }
                .stroke(DS.silver.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
            }
        }
        .accessibilityHidden(true)
    }

    /// Millilitres per day from `start` on, in one pass over the log.
    private func dayTotals(from start: Date) -> [Date: Int] {
        let calendar = Calendar.current
        var totals: [Date: Int] = [:]
        for entry in daily.water where entry.date >= start {
            totals[calendar.startOfDay(for: entry.date), default: 0] += entry.ml
        }
        return totals
    }
}

/// The plan's calories and macros, in silver: orange stays the workout's.
private struct NutritionTile: View {
    var metrics: TodayMetrics
    var plan: NutritionPlan?
    var actions: TodayActions

    var body: some View {
        Button(action: plan == nil ? actions.editProfile : actions.showPlan) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Label(String(localized: "Nutrition", comment: "Today tile"), systemImage: "fork.knife")
                        .font(.mono(10.5, .semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(DS.silver.opacity(0.75))
                    Spacer(minLength: 4)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.4))
                }
                .frame(height: 30)
                if let plan {
                    BigValue(value: Int(plan.calories).formatted(),
                             unit: String(localized: "kcal", comment: "Unit after the day's calorie target: 2,020 kcal"), size: 24)
                        .padding(.top, 4)
                    Text("Daily target", comment: "Nutrition tile")
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.6))
                    if metrics.showsEnergyNote {
                        TodayEnergyNote(metrics: metrics, compact: true)
                            .padding(.top, 8)
                    }
                    Spacer(minLength: 12)
                    TodayMacroBar(protein: Int(plan.protein), fat: Int(plan.fat), carbs: Int(plan.carbs),
                                  colors: (DS.silver.opacity(0.9), DS.silver.opacity(0.5), DS.silver.opacity(0.22)),
                                  height: 7)
                    VStack(alignment: .leading, spacing: 3) {
                        macro(String(localized: "Protein", comment: "Macro"), Int(plan.protein))
                        macro(String(localized: "Fat", comment: "Macro"), Int(plan.fat))
                        macro(String(localized: "Carbs", comment: "Macro"), Int(plan.carbs))
                    }
                    .padding(.top, 8)
                } else {
                    Text("Finish your plan")
                        .font(.ui(16, .semibold))
                        .foregroundStyle(DS.silver)
                        .padding(.top, 6)
                    Text("Calories and macros appear here.")
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.6))
                    Spacer(minLength: 0)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func macro(_ name: String, _ grams: Int) -> some View {
        HStack {
            Text(name)
                .font(.ui(12.5, .medium))
                .foregroundStyle(DS.silver.opacity(0.65))
            Spacer(minLength: 4)
            Text("\(grams) g", comment: "Grams of a macro: 148 g")
                .font(.ui(13, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver)
        }
    }
}

/// Apple Health's tiles, built like the water week: label and chevron, the
/// number against its goal, a caption, and seven bars against the goal.
/// The whole tile opens the trends in Progress (steps all added by hand
/// open the walk log instead, with their own hint).
private struct HealthWeekTile<Value: View>: View {
    var symbol: String
    var label: String
    var tone: Color
    var caption: String
    var days: [TodayMetrics.HealthDay]
    var goal: Int
    var spoken: String
    var action: () -> Void
    /// VoiceOver's hint; nil is Progress's trends.
    var hint: String? = nil
    @ViewBuilder var value: () -> Value

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Label(label, systemImage: symbol)
                        .font(.mono(10.5, .semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(tone)
                        .lineLimit(1)
                    Spacer(minLength: 4)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.4))
                }
                .frame(height: 30)
                value()
                    .padding(.top, 4)
                Text(caption)
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 12)
                HealthWeekBars(days: days, goal: goal, tone: tone)
                    .frame(height: 52)
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(spoken)
        .accessibilityHint(hint ?? TodayHealthText.opensProgress)
    }
}

/// Today's steps against the goal, and the week's.
private struct StepsWeekTile: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    var body: some View {
        HealthWeekTile(symbol: "figure.walk", label: String(localized: "Steps", comment: "Today tile"),
                       tone: HealthTone.steps, caption: TodayHealthText.stepsCaption(metrics),
                       days: metrics.stepsWeek, goal: metrics.stepsGoal,
                       spoken: TodayHealthText.stepsSpoken(metrics), action: actions.openSteps(metrics),
                       hint: TodayHealthText.stepsHint(metrics)) {
            BigValue(value: HealthFormat.steps(metrics.stepsToday ?? 0),
                     unit: "/ \(HealthFormat.steps(metrics.stepsGoal))", size: 24)
        }
    }
}

/// Last night's sleep against the goal, and the week's nights.
private struct SleepWeekTile: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    var body: some View {
        HealthWeekTile(symbol: "bed.double.fill", label: String(localized: "Last night", comment: "Today tile: last night's sleep"),
                       tone: HealthTone.sleep, caption: TodayHealthText.sleepCaption(metrics),
                       days: metrics.sleepWeek, goal: metrics.sleepGoalMinutes,
                       spoken: TodayHealthText.sleepSpoken(metrics), action: actions.openProgress) {
            if let minutes = metrics.lastNightMinutes {
                BigValue(value: HealthFormat.sleep(minutes: minutes),
                         unit: "/ \(HealthFormat.sleep(minutes: metrics.sleepGoalMinutes))", size: 24)
            } else {
                Text("No sleep recorded", comment: "Sleep tile: nothing in Apple Health for last night")
                    .font(.ui(16, .semibold))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Reminders

/// Water and weigh-in reminders as two rows with their switches: open on
/// the ground (A) or in a card (B).
struct TodayReminderList: View {
    var metrics: TodayMetrics
    var actions: TodayActions
    var carded: Bool

    @Environment(DailyStore.self) private var daily

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Reminders", comment: "Today section")
                .font(.ui(carded ? 17 : 20, carded ? .semibold : .bold))
                .tracking(-0.3)
                .foregroundStyle(DS.silver)
                .accessibilityAddTraits(.isHeader)
            VStack(spacing: 0) {
                ReminderRow(title: String(localized: "Water"),
                            detail: detail(isOn: daily.waterReminder.isOn, schedule: waterSchedule),
                            isOn: Binding(get: { daily.waterReminder.isOn }, set: { actions.setWaterReminder($0) }),
                            editLabel: String(localized: "Water reminder settings"), onEdit: actions.waterSettings)
                    .padding(.vertical, 10)
                Hairline(opacity: 0.07)
                ReminderRow(title: String(localized: "Morning weigh-in"),
                            detail: detail(isOn: daily.weighInReminder.isOn,
                                           schedule: String(localized: "Daily at \(TodayView.time(daily.weighInReminder.hour, daily.weighInReminder.minute))",
                                                            comment: "Weigh-in reminder: Daily at 7:00")),
                            isOn: Binding(get: { daily.weighInReminder.isOn }, set: { actions.setWeighInReminder($0) }),
                            editLabel: String(localized: "Weigh-in reminder time"), onEdit: actions.weighInTime)
                    .padding(.vertical, 10)
            }
            .padding(.horizontal, carded ? 16 : 0)
            .background {
                if carded {
                    RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface)
                    RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1)
                }
            }
        }
    }

    private var waterSchedule: String {
        let reminder = daily.waterReminder
        return String(localized: "Every \(reminder.everyHours) h, \(TodayView.hour(reminder.startHour))–\(TodayView.hour(reminder.endHour))",
                      comment: "Water reminder window: Every 2 h, 8:00–20:00")
    }

    private func detail(isOn: Bool, schedule: String) -> String {
        guard isOn else { return String(localized: "Off", comment: "A reminder row's detail: the reminder is off") }
        return daily.notificationsDenied
            ? String(localized: "Notifications are off in iOS Settings", comment: "A reminder that is on but can't fire")
            : schedule
    }
}
