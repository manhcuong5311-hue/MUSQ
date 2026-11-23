//
//  TodayDialLayout.swift
//  GymWorkout
//
//  Candidate B for the Today tab (2026-11-21), after WHOOP and Bevel: one
//  dial on a dark stage counts the day's goals and says what to do next,
//  with a one-tap fix. Under it the session poster, two tiles (water,
//  weight) built the same way — label top-left, state top-right, number,
//  one graphic, one action — two more from Apple Health (steps, last
//  night's sleep; outside the dial's goals), and one goal card with the
//  trend and the plan's calories. 2026-11-22: the quick log by the water
//  tile, Balance's card after the tiles, and the water tile's amount opens
//  the water log.
//

import SwiftUI

struct TodayDialLayout: View {
    var metrics: TodayMetrics
    var plan: NutritionPlan?
    var actions: TodayActions
    /// Train · Eat · Sleep over 7 days; nil while its card is off Today.
    var balance: Balance? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("Today", comment: "The Today tab's large title")
                    .font(.ui(28, .semibold))
                    .tracking(-0.7)
                    .foregroundStyle(DS.silver)
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 8)
                TodayEyebrow(text: metrics.now.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated)),
                             size: 11)
            }
            .padding(.bottom, 2)
            if CoachChat.isAvailable {
                AskCoachBar(action: actions.askCoach)
            }
            TodayNotices(metrics: metrics, actions: actions)
            DayDial(metrics: metrics, actions: actions)
            SessionPoster(metrics: metrics, style: metrics.state.isQuiet ? .compact : .full,
                          eyebrow: [.recommended, .planned].contains(metrics.state)
                              ? String(localized: "Next up") : String(localized: "Today's session"),
                          isPrimary: !metrics.state.isQuiet && !metrics.needsPlan, actions: actions)
            if let goal = metrics.goal, let photo = metrics.goalPhoto {
                GoalTodayCard(progress: goal, photo: photo, onOpen: actions.openGoal)
            }
            HStack(alignment: .top, spacing: 10) {
                DialWaterTile(metrics: metrics, actions: actions)
                DialWeightTile(metrics: metrics, actions: actions)
            }
            .fixedSize(horizontal: false, vertical: true)
            // Water, a walk without the phone, or a meal: typed or spoken.
            TodayQuickLogRow(actions: actions)
            if let balance {
                BalanceCard(balance: balance, onAction: actions.balanceAction, onOpen: actions.openBalance)
            }
            // Apple Health: whichever of the two it has, or where to look
            // when it sent nothing (until that note is closed).
            if metrics.showsSteps || metrics.showsSleep {
                HStack(alignment: .top, spacing: 10) {
                    if metrics.showsSteps {
                        DialStepsTile(metrics: metrics, actions: actions)
                    }
                    if metrics.showsSleep {
                        DialSleepTile(metrics: metrics, actions: actions)
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
            if let plan {
                GoalCard(metrics: metrics, plan: plan, actions: actions)
            }
            TodayReminderList(metrics: metrics, actions: actions, carded: true)
                .padding(.top, 8)
            TodayFootnote()
        }
    }
}

// MARK: - Dial

/// The day's goals in three slots — workout, water, weigh-in — on a stage
/// that stays dark in both appearances. Silver only: green and yellow mean
/// recovery on Train. The workout counts on a training day with something
/// recovered (or once sets are planned), the weigh-in only while its
/// morning reminder is on and its window hasn't passed.
private struct DayDial: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    @State private var showsInfo = false

    private struct Goal {
        var symbol: String
        var progress: Double
        var counted: Bool
        var closed: Bool
    }

    private var goals: [Goal] {
        let m = metrics
        return [
            Goal(symbol: m.state == .rest ? "moon.zzz.fill" : m.state == .recovering ? "hourglass" : "dumbbell.fill",
                 progress: m.workoutProgress, counted: m.workoutCounts, closed: m.workoutDone),
            Goal(symbol: "drop.fill", progress: m.waterProgress, counted: m.waterCounts, closed: m.waterReached),
            Goal(symbol: "scalemass.fill", progress: m.weighInProgress, counted: m.weighInCounts, closed: m.weighedIn),
        ]
    }

    var body: some View {
        let goals = goals
        let counted = goals.filter(\.counted).count
        let closed = goals.filter { $0.counted && $0.closed }.count
        let verdict = verdict(closed: closed, counted: counted)
        HStack(alignment: .center, spacing: 18) {
            dial(goals, closed: closed, counted: counted)
                .frame(width: 136, height: 136)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 5) {
                    Image(systemName: stateSymbol(closed: closed, counted: counted))
                        .font(.system(size: 10, weight: .bold))
                    TodayEyebrow(text: stateWord(closed: closed, counted: counted), size: 10.5, opacity: 0.85)
                }
                .foregroundStyle(DS.silver.opacity(0.85))
                Text(verdict.headline)
                    .font(.ui(21, .bold))
                    .tracking(-0.3)
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
                Text(verdict.detail)
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
                if let fix = verdict.fix {
                    QuickChip(title: fix.title, symbol: fix.symbol, action: fix.action)
                        .padding(.top, 6)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.leading, 18)
        .padding(.trailing, 16)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(stage)
        .overlay(alignment: .topTrailing) {
            Button { showsInfo = true } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(String(localized: "How the daily goals work"))
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).strokeBorder(Color.white.opacity(0.07), lineWidth: 1))
        .environment(\.colorScheme, .dark)
        .alert(String(localized: "Daily goals"), isPresented: $showsInfo) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Water counts every day, unless a heart or kidney condition makes the amount your doctor's. The workout counts on your training days once something has recovered. The weigh-in counts in the mornings while its reminder is on: a few weigh-ins a week is enough, so a skipped morning is never a miss.")
        }
    }

    private var stage: some View {
        ZStack {
            RadialGradient(colors: [Color(hex: 0x1D2025), Color(hex: 0x0B0C0E)],
                           center: UnitPoint(x: 0.25, y: 0.45), startRadius: 0, endRadius: 300)
            RadialGlow(color: Color.white.opacity(0.06), rx: 0.35, ry: 0.6, cx: 0.22, cy: 0.5)
        }
    }

    private func dial(_ goals: [Goal], closed: Int, counted: Int) -> some View {
        let size: CGFloat = 136, line: CGFloat = 12
        let radius = (size - line) / 2
        return ZStack {
            ForEach(0..<3, id: \.self) { index in
                let goal = goals[index]
                let start = (Double(index) * 120 + 8) / 360
                let span = 104.0 / 360
                Circle()
                    .trim(from: start, to: start + span)
                    .stroke(DS.silver.opacity(goal.counted ? 0.12 : 0.3),
                            style: goal.counted ? StrokeStyle(lineWidth: line, lineCap: .round)
                                                : StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 5]))
                    .rotationEffect(.degrees(-90))
                    .padding(line / 2)
                // A goal that doesn't count today stays dotted even when
                // done, so the count and the ring always agree.
                if goal.progress > 0 && goal.counted {
                    Circle()
                        .trim(from: start, to: start + span * min(1, goal.progress))
                        .stroke(DS.silver.opacity(goal.closed ? 0.95 : 0.6), style: StrokeStyle(lineWidth: line, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .padding(line / 2)
                        .shadow(color: .white.opacity(goal.closed ? 0.35 : 0), radius: 6)
                }
                // The symbol sits at the slot's middle: dark once the filled
                // arc reaches it, silver on the bare track.
                let covered = goal.counted && (goal.closed || goal.progress >= 0.5)
                let mid = (Double(index) * 120 + 60) * .pi / 180
                Image(systemName: goal.symbol)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(covered ? Color.black.opacity(0.8) : DS.silver.opacity(goal.closed ? 0.9 : 0.6))
                    .offset(x: radius * sin(mid), y: -radius * cos(mid))
            }
            VStack(spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 1) {
                    Text(verbatim: "\(closed)")
                        .font(.ui(46, .bold))
                        .monospacedDigit()
                        .foregroundStyle(DS.silver)
                        .contentTransition(.numericText())
                    Text(verbatim: "/\(counted)")
                        .font(.ui(20, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.42))
                }
                TodayEyebrow(text: String(localized: "Goals"), size: 9.5)
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement()
        .accessibilityLabel(String(localized: "\(closed) of \(counted) daily goals done", comment: "Daily goals dial"))
    }

    private func stateWord(closed: Int, counted: Int) -> String {
        if closed == counted { return String(localized: "Day closed", comment: "Daily goals state") }
        if metrics.state == .rest { return String(localized: "Rest day", comment: "Daily goals state") }
        if metrics.state == .recovering { return String(localized: "Recovery day", comment: "Daily goals state") }
        return String(localized: "\(counted - closed) to go", comment: "Daily goals state: 2 to go")
    }

    private func stateSymbol(closed: Int, counted: Int) -> String {
        if closed == counted { return "checkmark.circle.fill" }
        if metrics.state == .rest { return "moon.zzz.fill" }
        return metrics.state == .recovering ? "hourglass" : "circle.dashed"
    }

    // MARK: Verdict

    private struct Verdict {
        var headline: String
        var detail: String
        var fix: (title: String, symbol: String?, action: () -> Void)?
    }

    /// The next open goal, in the order a day runs: the workout under way or
    /// planned (the poster below carries its button), then water, then the
    /// weigh-in in its morning window. "All done" only when the count says so.
    private func verdict(closed: Int, counted: Int) -> Verdict {
        let m = metrics
        let glass = m.waterPresets.first ?? DailyStore.defaultWaterPresets[0]
        let waterFix: (title: String, symbol: String?, action: () -> Void) = ("+\(glass) ml", "drop.fill", { actions.addWater(glass) })
        if m.state == .inProgress {
            if m.allSetsIn {
                return Verdict(headline: String(localized: "Every exercise is done."),
                               detail: String(localized: "Complete the workout in Train to log it."), fix: nil)
            }
            let headline = m.setsLeft == 1 ? String(localized: "Keep going: 1 set left.")
                : String(localized: "Keep going: \(m.setsLeft) sets left.", comment: "Dial mid-workout")
            let detail = m.nextExercise.map { String(localized: "Next: \($0).", comment: "Dial: the next exercise") }
                ?? String(localized: "Open Train to log the rest.")
            return Verdict(headline: headline, detail: detail, fix: nil)
        }
        if m.state == .recommended || m.state == .planned {
            let sets = m.posterExercises.reduce(0) { $0 + $1.sets.count }
            return Verdict(headline: String(localized: "Up next: \(m.posterTitle).", comment: "Dial: Up next: Push day."),
                           detail: String(localized: "\(TodayCount.session(exercises: m.posterExercises.count, sets: sets)), ready below.",
                                          comment: "Dial; the value is “6 exercises · 18 sets”"),
                           fix: m.waterReached ? nil : waterFix)
        }
        if m.waterCounts && !m.waterReached {
            let left = max(0, m.waterTarget - m.waterMl)
            let detail: String
            if m.limitsFluids {
                detail = String(localized: "Ask your doctor how much to drink.")
            } else if let pace = m.waterPaceMl {
                detail = String(localized: "Pace mark: \(DailyStore.litres(pace)) by now", comment: "Water: the pace tick's meaning")
            } else {
                detail = String(localized: "Target \(DailyStore.litres(m.waterTarget)) today.", comment: "Dial: Target 2.5 L today.")
            }
            return Verdict(headline: String(localized: "Water: \(DailyStore.litres(left)) to go.", comment: "Dial: Water: 1.75 L to go."),
                           detail: detail, fix: waterFix)
        }
        if m.weighInDue {
            return Verdict(headline: String(localized: "Step on the scale."),
                           detail: String(localized: "Your plan follows the 7-day average."),
                           fix: (String(localized: "Log weight"), "scalemass.fill", actions.logWeight))
        }
        if m.state == .recovering {
            let detail = m.soonestReady.map {
                String(localized: "\($0.group.title) will be ready in about \($0.hours) h.",
                       comment: "Nothing recovered yet: Back will be ready in about 14 h.")
            } ?? String(localized: "A walk still counts.")
            return Verdict(headline: String(localized: "Recovery day."), detail: detail, fix: nil)
        }
        if closed < counted && m.weighInCounts && !m.weighedIn {
            // Counted, but its morning window hasn't opened yet.
            let time = TodayView.time(m.weighInReminderHour, m.weighInReminderMinute)
            return Verdict(headline: String(localized: "Weigh-in at \(time).", comment: "Dial: Weigh-in at 7:00."),
                           detail: String(localized: "Your plan follows the 7-day average."), fix: nil)
        }
        return Verdict(headline: m.state == .rest ? String(localized: "Rest and recover.") : String(localized: "All done for today."),
                       detail: String(localized: "Every goal is in. A walk still counts."), fix: nil)
    }
}

// MARK: - Tiles

/// Label top-left, state top-right, the number, one graphic, one action.
private struct DialTile<Content: View>: View {
    var symbol: String
    var label: String
    var tone: Color
    var state: String?
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Image(systemName: symbol)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(tone)
                TodayEyebrow(text: label, size: 10.5)
                Spacer(minLength: 4)
                if let state {
                    Text(state)
                        .font(.mono(9.5, .semibold))
                        .trackingEm(0.08, size: 9.5)
                        .textCase(.uppercase)
                        .foregroundStyle(DS.silver.opacity(0.8))
                }
            }
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
    }
}

private struct DialWaterTile: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    var body: some View {
        let litres = Double(metrics.waterMl) / 1_000, target = Double(metrics.waterTarget) / 1_000
        let presets = metrics.waterPresets
        let first = presets.first ?? DailyStore.defaultWaterPresets[0]
        DialTile(symbol: "drop.fill", label: String(localized: "Water", comment: "Today tile"), tone: TodayTone.water,
                 state: metrics.waterCounts && metrics.waterReached ? String(localized: "✓ Done") : nil) {
            // The amount, its level and caption open the water log (a custom
            // amount, the presets, today's glasses).
            Button { actions.quickLog(.water) } label: {
                VStack(alignment: .leading, spacing: 0) {
                    // With the amount left to the doctor, the tile logs without a target.
                    BigValue(value: litres.formatted(.number.precision(.fractionLength(0...2))),
                             unit: metrics.waterCounts ? "/ \(target.formatted(.number.precision(.fractionLength(0...2)))) L" : "L",
                             size: 28)
                        .padding(.top, 12)
                    if metrics.waterCounts {
                        level
                            .padding(.top, 10)
                    }
                    Text(caption)
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.62))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 6)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint(TodayWaterText.opensLog)
            Spacer(minLength: 12)
            HStack(spacing: 4) {
                QuickChip(title: "+\(first) ml") { actions.addWater(first) }
                Menu {
                    ForEach(Array(presets.dropFirst().enumerated()), id: \.offset) { _, ml in
                        Button(String(localized: "Add \(ml) ml", comment: "Adds water: Add 250 ml"), systemImage: "plus") {
                            actions.addWater(ml)
                        }
                    }
                    Button(TodayWaterText.custom, systemImage: "drop") { actions.quickLog(.water) }
                    Button(String(localized: "Remove last glass"), systemImage: "arrow.uturn.backward") { actions.undoWater() }
                    Button(String(localized: "Water target & reminders"), systemImage: "slider.horizontal.3") { actions.waterSettings() }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(DS.silver)
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(DS.silver.opacity(0.07)))
                        .overlay(Circle().strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel(String(localized: "More water options"))
            }
        }
    }

    private var level: some View {
        GeometryReader { geo in
            let share = min(1, Double(metrics.waterMl) / Double(max(metrics.waterTarget, 1)))
            ZStack(alignment: .leading) {
                Capsule().fill(TodayTone.water.opacity(0.16))
                Capsule().fill(TodayTone.water)
                    .frame(width: geo.size.width * share)
                    .opacity(share > 0 ? 1 : 0)
                if let pace = metrics.waterPaceMl {
                    let x = geo.size.width * min(1, Double(pace) / Double(max(metrics.waterTarget, 1)))
                    Capsule().fill(DS.silver.opacity(0.9))
                        .frame(width: 2, height: 14)
                        .offset(x: x - 1)
                }
            }
        }
        .frame(height: 8)
        .accessibilityHidden(true)
    }

    private var caption: String {
        if metrics.limitsFluids { return String(localized: "Ask your doctor how much to drink.") }
        if metrics.waterReached { return String(localized: "Target reached") }
        if let pace = metrics.waterPaceMl {
            return String(localized: "Pace mark: \(DailyStore.litres(pace)) by now", comment: "Water: the pace tick's meaning")
        }
        return String(localized: "\(DailyStore.litres(max(0, metrics.waterTarget - metrics.waterMl))) to go",
                      comment: "Water tile: 1.75 L to go")
    }
}

private struct DialWeightTile: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    @Environment(WorkoutStore.self) private var store
    @Environment(DailyStore.self) private var daily

    var body: some View {
        let unit = store.unit
        let shown = metrics.trend ?? daily.latestWeight?.kg
        DialTile(symbol: "scalemass.fill", label: String(localized: "Weight", comment: "Today tile"), tone: TodayTone.violet,
                 state: metrics.weighedIn ? String(localized: "✓ Today") : nil) {
            if let shown {
                let value = (unit.fromKilograms(shown) * 10).rounded() / 10
                BigValue(value: value.formatted(.number.precision(.fractionLength(1))), unit: unit.symbol, size: 28)
                    .padding(.top, 12)
                let values = daily.weights.suffix(14).map { unit.fromKilograms($0.kg) }
                if values.count >= 2 {
                    TrendSpark(values: values, tone: TodayTone.violet)
                        .frame(height: 26)
                        .padding(.top, 8)
                }
                Text(metrics.trend != nil ? String(localized: "7-day average") : String(localized: "Last weigh-in"))
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.62))
                    .padding(.top, 6)
                Button(action: actions.weightHistory) {
                    HStack(spacing: 3) {
                        Text("History")
                        Image(systemName: "chevron.right").font(.system(size: 10, weight: .semibold))
                    }
                    .font(.ui(12.5, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.vertical, -10)
            } else {
                Text("No weigh-ins yet", comment: "Weight tile")
                    .font(.ui(17, .semibold))
                    .foregroundStyle(DS.silver)
                    .padding(.top, 12)
                Text("A few mornings a week is enough.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.62))
                    .padding(.top, 4)
            }
            Spacer(minLength: 12)
            QuickChip(title: metrics.weighedIn ? String(localized: "Edit today's") : String(localized: "Log weight"),
                      action: actions.logWeight)
        }
    }
}

/// "Trends ›": what a Health tile does when tapped, drawn like the weight
/// tile's History link (the whole tile is the button). "Walks ›" on the
/// steps tile when every step today was added by hand: it opens the walk log.
private struct DialTrendsLink: View {
    var walks = false

    var body: some View {
        HStack(spacing: 3) {
            if walks {
                Text(String(localized: "Walks", comment: "Today steps tile: opens today's walks added by hand"))
            } else {
                Text("Trends", comment: "Today tile: opens the steps or sleep trends in Progress")
            }
            Image(systemName: "chevron.right").font(.system(size: 10, weight: .semibold))
        }
        .font(.ui(12.5, .semibold))
        .foregroundStyle(DS.silver.opacity(0.75))
        .frame(minHeight: 24)
    }
}

/// Today's steps against the goal, with the week's bars; opens Progress,
/// or the walk log when every step today was added by hand.
private struct DialStepsTile: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    var body: some View {
        Button(action: actions.openSteps(metrics)) {
            DialTile(symbol: "figure.walk", label: String(localized: "Steps", comment: "Today tile"), tone: HealthTone.steps,
                     state: metrics.stepsReached ? String(localized: "✓ Goal", comment: "Today tile state: the day's goal is reached") : nil) {
                BigValue(value: HealthFormat.steps(metrics.stepsToday ?? 0),
                         unit: "/ \(HealthFormat.steps(metrics.stepsGoal))", size: 28)
                    .padding(.top, 12)
                HealthWeekBars(days: metrics.stepsWeek, goal: metrics.stepsGoal, tone: HealthTone.steps)
                    .frame(height: 44)
                    .padding(.top, 10)
                Text(TodayHealthText.stepsCaption(metrics))
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.62))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 6)
                Spacer(minLength: 12)
                DialTrendsLink(walks: metrics.stepsAllManual)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(TodayHealthText.stepsSpoken(metrics))
        .accessibilityHint(TodayHealthText.stepsHint(metrics))
    }
}

/// Last night's sleep against the goal, with the week's nights; opens
/// Progress. Labelled "Sleep": "Last night" beside "✓ Goal" overflows a
/// half-width tile on a 375-pt phone. VoiceOver still says last night.
private struct DialSleepTile: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    var body: some View {
        Button(action: actions.openProgress) {
            DialTile(symbol: "bed.double.fill", label: String(localized: "Sleep", comment: "Today tile: last night's sleep"),
                     tone: HealthTone.sleep,
                     state: metrics.sleepReached ? String(localized: "✓ Goal", comment: "Today tile state: the day's goal is reached") : nil) {
                if let minutes = metrics.lastNightMinutes {
                    BigValue(value: HealthFormat.sleep(minutes: minutes),
                             unit: "/ \(HealthFormat.sleep(minutes: metrics.sleepGoalMinutes))", size: 28)
                        .padding(.top, 12)
                } else {
                    Text("No sleep recorded", comment: "Sleep tile: nothing in Apple Health for last night")
                        .font(.ui(17, .semibold))
                        .foregroundStyle(DS.silver)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 12)
                }
                HealthWeekBars(days: metrics.sleepWeek, goal: metrics.sleepGoalMinutes, tone: HealthTone.sleep)
                    .frame(height: 44)
                    .padding(.top, 10)
                Text(TodayHealthText.sleepCaption(metrics))
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.62))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 6)
                Spacer(minLength: 12)
                DialTrendsLink()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(TodayHealthText.sleepSpoken(metrics))
        .accessibilityHint(TodayHealthText.opensProgress)
    }
}

// MARK: - Goal

/// The goal in words, the trend with the plan's pace and the target, and
/// the calories that get there.
private struct GoalCard: View {
    var metrics: TodayMetrics
    var plan: NutritionPlan
    var actions: TodayActions

    @Environment(WorkoutStore.self) private var store
    @Environment(DailyStore.self) private var daily

    var body: some View {
        let unit = store.unit
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Image(systemName: "flag.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(DS.silver.opacity(0.7))
                TodayEyebrow(text: String(localized: "Your goal"), size: 10.5)
                Spacer(minLength: 4)
                Button(action: actions.showPlan) {
                    HStack(spacing: 3) {
                        Text("How it's calculated")
                        Image(systemName: "chevron.right").font(.system(size: 10, weight: .semibold))
                    }
                    .font(.ui(13, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.vertical, -8)
            }
            Text(headline(unit))
                .font(.ui(26, .bold))
                .tracking(-0.4)
                .foregroundStyle(DS.silver)
                .padding(.top, 8)
            Text(subline(unit))
                .font(.ui(13))
                .foregroundStyle(DS.silver.opacity(0.62))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
            if let trend = WeightTrend(daily: daily, plan: plan, unit: unit, now: metrics.now) {
                WeightTrendChart(trend: trend, tone: TodayTone.violet, unit: unit)
                    .frame(height: 124)
                    .padding(.top, 14)
                    .contentShape(Rectangle())
                    .onTapGesture { actions.weightHistory() }
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(String(localized: "Opens your weigh-ins"))
            }
            Hairline(opacity: 0.08)
                .padding(.vertical, 14)
            BigValue(value: Int(plan.calories).formatted(), unit: String(localized: "kcal a day"), size: 24)
            if metrics.showsEnergyNote {
                TodayEnergyNote(metrics: metrics)
                    .padding(.top, 6)
            }
            TodayMacroBar(protein: Int(plan.protein), fat: Int(plan.fat), carbs: Int(plan.carbs), height: 8)
                .padding(.top, 10)
            MacroLine(protein: Int(plan.protein), fat: Int(plan.fat), carbs: Int(plan.carbs))
                .padding(.top, 8)
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(DS.surface))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
    }

    private func headline(_ unit: WeightUnit) -> String {
        guard let target = plan.targetWeightKg, plan.effectiveGoal.hasTarget else { return plan.effectiveGoal.title }
        let amount = Int(abs(unit.fromKilograms(target) - unit.fromKilograms(plan.weightKg)).rounded())
        guard amount > 0 else { return String(localized: "Almost there") }
        let change = "\(amount)\u{00A0}\(unit.symbol)"
        return plan.effectiveGoal == .loseWeight ? String(localized: "Lose \(change)", comment: "Goal card: Lose 3 kg")
            : String(localized: "Gain \(change)", comment: "Goal card: Gain 3 kg")
    }

    private func subline(_ unit: WeightUnit) -> String {
        if metrics.belowFloor {
            return String(localized: "No deficit for now: what you burn is already under the floor. Talk to a doctor or dietitian before eating less.")
        }
        if let date = plan.targetDate(), plan.weeklyRate != 0 {
            let day = date.formatted(.dateTime.day().month(.abbreviated).year())
            // Rounded first, so a tiny deficit never reads "−0.0 kg a week".
            let weekly = (unit.fromKilograms(abs(plan.weeklyChangeKg)) * 10).rounded() / 10
            guard weekly > 0 else { return String(localized: "Around \(day)", comment: "Goal card: Around 2 Jan 2027") }
            let sign = plan.weeklyRate < 0 ? "−" : "+"
            return String(localized: "Around \(day) · \(sign)\(weekly.formatted(.number.precision(.fractionLength(1)))) \(unit.symbol) a week",
                          comment: "Goal card: Around 2 Jan 2027 · −0.4 kg a week")
        }
        switch plan.effectiveGoal {
        case .getFit: return String(localized: "Eat what you burn, built around your training.")
        case .recomp: return String(localized: "A small deficit while you train hard.")
        default: return String(localized: "Calories and protein built around your training.")
        }
    }
}
