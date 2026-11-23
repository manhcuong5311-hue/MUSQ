//
//  TodayCoachLayout.swift
//  GymWorkout
//
//  Candidate C for the Today tab (2026-11-21), the owner's default: the
//  coach says one thing in its own voice, today's session is drawn on the
//  body right under it, one raised "Your day" panel ticks off water, the
//  weigh-in and the workout (with steps and last night's sleep from Apple
//  Health under them, outside the tally), and the plan and the weight trend
//  sit quietly on the ground below, each led by one number. Three tiers:
//  studio poster, raised panel, open sections. 2026-11-22: Balance's card
//  under the panel, the quick log's "Log" in the panel's header, and the
//  water row opens the water log (custom amount, today's glasses).
//

import SwiftUI

struct TodayCoachLayout: View {
    var metrics: TodayMetrics
    var plan: NutritionPlan?
    var actions: TodayActions
    /// Train · Eat · Sleep over 7 days; nil while its card is off Today.
    var balance: Balance? = nil

    @AppStorage(TodayNotices.healthInviteKey) private var healthInviteDismissed = false
    @AppStorage(TodayNotices.goalInviteKey) private var goalInviteDismissed = false

    var body: some View {
        let hasNotices = metrics.needsPlan || !metrics.clearanceReasons.isEmpty
            || TodayNotices.showsHealthInvite(metrics, dismissed: healthInviteDismissed)
            || TodayNotices.showsGoalInvite(metrics, dismissed: goalInviteDismissed)
        VStack(alignment: .leading, spacing: 0) {
            if CoachChat.isAvailable {
                AskCoachBar(action: actions.askCoach)
                    .padding(.bottom, 18)
            }
            CoachHeader(metrics: metrics)
            if hasNotices {
                VStack(spacing: 12) {
                    TodayNotices(metrics: metrics, actions: actions, showsTargetReached: false)
                }
                .padding(.top, 16)
            }
            SessionPoster(metrics: metrics, style: metrics.state.isQuiet ? .compact : .full,
                          isPrimary: !metrics.state.isQuiet && !metrics.needsPlan, actions: actions)
                .padding(.top, 16)
            if let goal = metrics.goal, let photo = metrics.goalPhoto {
                GoalTodayCard(progress: goal, photo: photo, onOpen: actions.openGoal)
                    .padding(.top, 16)
            }
            DayPanel(metrics: metrics, actions: actions)
                .padding(.top, 28)
            if let balance {
                BalanceCard(balance: balance, onAction: actions.balanceAction, onOpen: actions.openBalance)
                    .padding(.top, 16)
            }
            // For everyone: a meal added by hand is free (the scan is Pro's).
            TodayMealsBlock(metrics: metrics, actions: actions)
                .padding(.top, 28)
            if let plan {
                Hairline(opacity: 0.08)
                    .padding(.top, 36)
                PlanOpenSection(metrics: metrics, plan: plan, actions: actions)
                    .padding(.top, 28)
            }
            Hairline(opacity: 0.08)
                .padding(.top, 36)
            WeightOpenSection(plan: plan, tone: TodayTone.violet, coachLine: true, actions: actions)
                .padding(.top, 28)
            TodayFootnote()
                .padding(.top, 28)
        }
    }
}

// MARK: - Coach

/// The coach's line for the day: a short verdict and one sentence of why,
/// from the same records Train uses. Group names stay as the app titles
/// them (no case changes in code), listed in the language's own way, and
/// no verb has to agree with a group's name.
struct CoachLine {
    var verdict: String
    var why: String

    init(metrics m: TodayMetrics) {
        let groups = m.posterGroups.map(\.title).formatted(.list(type: .and))
        switch m.state {
        case .inProgress:
            if m.allSetsIn {
                verdict = String(localized: "Every exercise is done.")
                why = String(localized: "Complete the workout in Train to log it.")
            } else {
                verdict = m.setsDone == 1 ? String(localized: "1 set in. Keep going.")
                    : String(localized: "\(m.setsDone) sets in. Keep going.", comment: "Coach, a workout under way")
                why = Self.setsLeftLine(m.setsLeft, next: m.nextExercise)
            }
        case .done:
            verdict = String(localized: "Workout done. Nice work.")
            let sets = TodayCount.sets(m.setsDone)
            // A workout in Apple Health covering the session replaces the
            // estimate with its own length and energy, and says where
            // they're from.
            if let minutes = m.sessionMinutesMeasured, let kcal = m.sessionKcalMeasured {
                why = String(localized: "\(sets) in \(minutes) min — \(kcal) kcal above rest, from Apple Health.",
                             comment: "Coach after a workout with a workout in Apple Health (its length and energy); the first value is a count of sets: 18 sets in 48 min — 210 kcal above rest, from Apple Health.")
            } else if let minutes = m.trainingMinutes, let kcal = m.trainingKcal {
                why = String(localized: "\(sets) in about \(minutes) min — \(kcal) kcal above rest (estimate).",
                             comment: "Coach after a workout; the first value is a count of sets: 18 sets in about 52 min — 140 kcal above rest (estimate).")
            } else {
                why = String(localized: "\(sets) today. Recovery starts now: water, protein and sleep.",
                             comment: "Coach after a workout; the value is a count of sets: 18 sets today.")
            }
        case .planned:
            verdict = String(localized: "Your workout's ready.")
            if let first = m.posterExercises.first?.exerciseName {
                why = String(localized: "\(TodayCount.exercises(m.posterExercises.count)), starting with \(first).",
                             comment: "Coach; the first value is a count of exercises: 6 exercises, starting with Barbell Bench Press.")
            } else {
                why = String(localized: "Open it in Train when you're ready.")
            }
        case .recommended:
            switch m.moment {
            case .firstWorkout:
                verdict = String(localized: "Let's log your first workout.")
                why = m.posterDayName.map {
                    String(localized: "Start with \($0): \(groups).", comment: "Coach: Start with Push day: Chest, Shoulders and Triceps.")
                } ?? String(localized: "Start with \(groups).", comment: "Coach: Start with Chest and Triceps.")
            case .comeback(let days):
                verdict = String(localized: "Welcome back.")
                why = String(localized: "It's been \(days) days. Ease in with \(m.posterDayName ?? groups).",
                             comment: "Coach after a break: It's been 6 days. Ease in with Push day.")
            default:
                // The planner also suggests groups that are only almost
                // recovered; say so rather than calling them ready.
                verdict = m.posterAllReady ? String(localized: "Ready to train.") : String(localized: "Good to train.")
                let state = m.posterAllReady
                    ? String(localized: "Recovered: \(groups).", comment: "Coach: Recovered: Chest, Shoulders and Triceps.")
                    : String(localized: "Mostly recovered: \(groups).", comment: "Coach: Mostly recovered: Chest, Back and Biceps.")
                why = [state, Self.lastTrainedLine(m.daysSinceTrained)].compactMap { $0 }.joined(separator: " ")
            }
        case .recovering:
            verdict = String(localized: "Recovery day.")
            // With Apple Health, the walk line carries today's steps.
            if let soonest = m.soonestReady {
                why = m.stepsSoFar.map {
                    String(localized: "\(soonest.group.title) will be ready in about \(soonest.hours) h. A walk still counts — \(HealthFormat.steps($0)) steps so far.",
                           comment: "Coach: Back will be ready in about 14 h. A walk still counts — 3,100 steps so far.")
                } ?? String(localized: "\(soonest.group.title) will be ready in about \(soonest.hours) h. A walk still counts.",
                            comment: "Coach: Back will be ready in about 14 h. A walk still counts.")
            } else {
                why = Self.walkLine(m.stepsSoFar) ?? String(localized: "A walk still counts.")
            }
        case .rest:
            verdict = String(localized: "Rest day.")
            if let next = m.recommendedDay {
                let nextGroups = next.groups.map(\.title).formatted(.list(type: .and))
                let day = TodayMetrics.dayName(next.name)
                why = m.stepsSoFar.map {
                    String(localized: "Next up: \(day) — \(nextGroups). A walk still counts — \(HealthFormat.steps($0)) steps so far.",
                           comment: "Coach on a rest day: Next up: Push day — Chest, Shoulders and Triceps. A walk still counts — 3,100 steps so far.")
                } ?? String(localized: "Next up: \(day) — \(nextGroups). A walk still counts.",
                            comment: "Coach on a rest day: Next up: Push day — Chest, Shoulders and Triceps. A walk still counts.")
            } else {
                why = Self.walkLine(m.stepsSoFar).map {
                    $0 + " " + String(localized: "You can train any day.", comment: "Coach on a rest day, after the steps")
                } ?? String(localized: "A walk still counts, and you can train any day.")
            }
        }
        if m.needsPlan {
            verdict = String(localized: "Let's finish your plan.")
            why = String(localized: "A few new questions turn your answers into calories, macros and safer exercise picks.")
        }
    }

    /// "6 sets left — Cable Fly is next.", with the singular for one.
    private static func setsLeftLine(_ left: Int, next: String?) -> String {
        if let next {
            return left == 1
                ? String(localized: "1 set left — \(next) is next.", comment: "Coach: 1 set left — Cable Fly is next.")
                : String(localized: "\(left) sets left — \(next) is next.", comment: "Coach: 6 sets left — Cable Fly is next.")
        }
        return left == 1 ? String(localized: "1 set left.") : String(localized: "\(left) sets left.", comment: "Coach: 6 sets left.")
    }

    /// "A walk still counts — 3,100 steps so far." once Apple Health has
    /// counted some today.
    private static func walkLine(_ steps: Int?) -> String? {
        steps.map {
            String(localized: "A walk still counts — \(HealthFormat.steps($0)) steps so far.",
                   comment: "Coach with today's steps from Apple Health: A walk still counts — 3,100 steps so far.")
        }
    }

    /// "Last trained 3 days ago." when one day covers every group.
    private static func lastTrainedLine(_ days: Int?) -> String? {
        guard let days, days > 0 else { return nil }
        return days == 1 ? String(localized: "Last trained yesterday.")
            : String(localized: "Last trained \(days) days ago.", comment: "Coach: Last trained 3 days ago.")
    }

    /// "Good afternoon, Sam"; Train's greetings, so the translations are shared.
    static func hello(hour: Int, name: String?) -> String {
        switch hour {
        case 5..<12:
            return name.map { String(localized: "Good morning, \($0)", comment: "Train greeting with the user's name") }
                ?? String(localized: "Good morning", comment: "Train greeting")
        case 12..<17:
            return name.map { String(localized: "Good afternoon, \($0)", comment: "Train greeting with the user's name") }
                ?? String(localized: "Good afternoon", comment: "Train greeting")
        case 17..<22:
            return name.map { String(localized: "Good evening, \($0)", comment: "Train greeting with the user's name") }
                ?? String(localized: "Good evening", comment: "Train greeting")
        default:
            return name.map { String(localized: "Still up, \($0)?", comment: "Train greeting late at night, with the user's name") }
                ?? String(localized: "Still up?", comment: "Train greeting late at night")
        }
    }
}

/// The hello and the date, the verdict in the coach's serif voice, and why.
private struct CoachHeader: View {
    var metrics: TodayMetrics

    /// `-TodayCoachSerif NO` shows the verdict in SF instead, for comparing.
    /// `bool(forKey:)` reads the launch argument's "NO"/"YES" strings.
    private var serif: Bool {
        UserDefaults.standard.object(forKey: "TodayCoachSerif") == nil || UserDefaults.standard.bool(forKey: "TodayCoachSerif")
    }

    var body: some View {
        let line = CoachLine(metrics: metrics)
        let hour = Calendar.current.component(.hour, from: metrics.now)
        // A long name doesn't fit beside the date; the hello then goes without it.
        let name = (metrics.name?.count ?? 0) <= 12 ? metrics.name : nil
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text(CoachLine.hello(hour: hour, name: name))
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Spacer(minLength: 8)
                TodayEyebrow(text: metrics.now.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated)),
                              size: 11)
            }
            Text(line.verdict)
                .font(serif ? .system(size: 32, weight: .semibold, design: .serif) : .ui(30, .bold))
                .tracking(-0.6)
                .lineSpacing(2)
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 6)
                .accessibilityAddTraits(.isHeader)
            Text(line.why)
                .font(.ui(15))
                .lineSpacing(3)
                .foregroundStyle(DS.silver.opacity(0.68))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
        }
    }
}

// MARK: - Your day

/// Water, the weigh-in and the workout as one raised checklist, each with
/// its ring and its one-tap chips, then steps and last night's sleep from
/// Apple Health (shown, not counted: the tally stays water, weigh-in and
/// workout), and the water target and reminders folded into one row.
private struct DayPanel: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    @Environment(WorkoutStore.self) private var store
    @Environment(DailyStore.self) private var daily
    @Environment(\.colorScheme) private var scheme
    /// "No data from Apple Health" closed for good.
    @AppStorage(TodayNotices.healthEmptyKey) private var healthEmptyDismissed = false

    private enum Habit { case water, weighIn }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Text("Your day", comment: "Today: the day's habits")
                    .font(.ui(20, .bold))
                    .tracking(-0.3)
                    .foregroundStyle(DS.silver)
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 8)
                tally
                // Water, a walk without the phone, or a meal: typed or spoken.
                TodayQuickLogMenu(action: actions.quickLog)
            }
            VStack(spacing: 0) {
                waterRow
                divider
                weighInRow
                divider
                workoutRow
                if metrics.showsSteps {
                    divider
                    stepsRow
                }
                if metrics.showsSleep {
                    divider
                    sleepRow
                }
                if metrics.healthEmpty && !healthEmptyDismissed {
                    divider
                    healthEmptyRow
                }
                divider
                remindersRow
            }
            .padding(.horizontal, 16)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface)
                .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.05), radius: 16, y: 6))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(DS.silver.opacity(scheme == .dark ? 0.08 : 0.04), lineWidth: 1))
        }
    }

    private var divider: some View {
        Hairline(opacity: 0.07)
            .padding(.leading, 56)
    }

    // MARK: Tally

    /// What counts today: water; the workout on a training day with
    /// something recovered, or once sets are planned; and the weigh-in only
    /// while its reminder is on (the app says a few mornings a week, so a
    /// skipped one is never a miss).
    private var counted: [Bool] {
        var items: [Bool] = []
        if metrics.waterCounts { items.append(metrics.waterReached) }
        if metrics.workoutCounts { items.append(metrics.workoutDone) }
        if metrics.weighInCounts { items.append(metrics.weighedIn) }
        return items
    }

    private var tally: some View {
        let done = counted.filter { $0 }.count
        return Group {
            if counted.isEmpty {
                EmptyView()
            } else if done == counted.count {
                Label(String(localized: "All done"), systemImage: "checkmark")
            } else {
                Text("\(done) of \(counted.count) done", comment: "Today's habits: 1 of 3 done")
            }
        }
        .font(.ui(13.5, .semibold))
        .monospacedDigit()
        .foregroundStyle(DS.silver.opacity(0.65))
    }

    /// The next habit gets a NEXT tag; on a quiet day its chip is the page's
    /// one filled control.
    private var nextHabit: Habit? {
        if metrics.weighInDue { return .weighIn }
        // Never nudge water when the amount is the doctor's.
        if metrics.waterReached || !metrics.waterCounts { return nil }
        if let pace = metrics.waterPaceMl, Double(metrics.waterMl) < Double(pace) * 0.85 { return .water }
        return metrics.state.isQuiet ? .water : nil
    }

    private func fills(_ habit: Habit) -> Bool {
        nextHabit == habit && metrics.state.isQuiet && !metrics.needsPlan
    }

    // MARK: Rows

    /// The ring, name and amount open the water log (a custom amount, the
    /// preset buttons, today's glasses); the chips add the user's presets.
    /// Each add's Undo is the tab's toast, the same on every layout.
    private var waterRow: some View {
        let litres = Double(metrics.waterMl) / 1_000
        let target = Double(metrics.waterTarget) / 1_000
        return row(ring: RingGlyph(progress: Double(metrics.waterMl) / Double(max(metrics.waterTarget, 1)),
                                   color: TodayTone.water, symbol: "drop.fill",
                                   done: metrics.waterCounts && metrics.waterReached, dashed: !metrics.waterCounts),
                   title: String(localized: "Water", comment: "Today row"), isNext: nextHabit == .water,
                   open: { actions.quickLog(.water) }, openHint: TodayWaterText.opensLog) {
            BigValue(value: litres.formatted(.number.precision(.fractionLength(0...2))),
                     unit: metrics.waterCounts ? "/ \(target.formatted(.number.precision(.fractionLength(0...2)))) L" : "L",
                     size: 20)
            if metrics.limitsFluids {
                Text("Ask your doctor how much to drink.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.65))
            }
        } trailing: {
            HStack(spacing: 6) {
                ForEach(Array(metrics.waterPresets.prefix(2).enumerated()), id: \.offset) { index, ml in
                    QuickChip(title: "+\(ml)", filled: index == 0 && fills(.water)) { actions.addWater(ml) }
                        .accessibilityLabel(String(localized: "Add \(ml) ml", comment: "Adds water: Add 250 ml"))
                }
            }
        }
        .contextMenu {
            Button(TodayWaterText.custom, systemImage: "drop") { actions.quickLog(.water) }
            Button(String(localized: "Remove last glass"), systemImage: "arrow.uturn.backward") { actions.undoWater() }
            Button(String(localized: "Water target & reminders"), systemImage: "slider.horizontal.3") { actions.reminders() }
        }
    }

    private var weighInRow: some View {
        let unit = store.unit
        let latest = daily.latestWeight
        return row(ring: RingGlyph(progress: metrics.weighedIn ? 1 : 0, color: TodayTone.violet,
                                   symbol: "scalemass.fill", done: metrics.weighedIn),
                   title: String(localized: "Weigh-in", comment: "Today row"), isNext: nextHabit == .weighIn) {
            if metrics.weighedIn, let latest {
                let value = (unit.fromKilograms(latest.kg) * 10).rounded() / 10
                BigValue(value: value.formatted(.number.precision(.fractionLength(1))),
                         unit: "\(unit.symbol) · \(latest.date.formatted(date: .omitted, time: .shortened))", size: 20)
            } else {
                Text(weighInDetail)
                    .font(.ui(14, .medium))
                    .foregroundStyle(DS.silver.opacity(0.65))
            }
        } trailing: {
            QuickChip(title: metrics.weighedIn ? String(localized: "Edit") : String(localized: "Log"),
                      filled: fills(.weighIn), action: actions.logWeight)
        }
    }

    /// "Not today", with the reminder's time only while it is on and iOS
    /// lets it arrive.
    private var weighInDetail: String {
        guard metrics.weighInReminderOn else { return String(localized: "Not today", comment: "No weigh-in today") }
        guard !daily.notificationsDenied else { return String(localized: "Not yet", comment: "No weigh-in yet today") }
        let time = TodayView.time(daily.weighInReminder.hour, daily.weighInReminder.minute)
        return String(localized: "Not yet · reminder \(time)", comment: "Weigh-in row: Not yet · reminder 7:00")
    }

    private var workoutRow: some View {
        let rest = metrics.state == .rest
        let resting = rest || metrics.state == .recovering
        return Button(action: actions.openTrain) {
            row(ring: RingGlyph(progress: metrics.workoutProgress, color: TodayTone.workout,
                                symbol: rest ? "moon.zzz.fill" : metrics.state == .recovering ? "hourglass" : "dumbbell.fill",
                                done: metrics.workoutDone, dashed: resting && metrics.setsPlanned == 0),
                title: String(localized: "Workout", comment: "Today row"), isNext: false) {
                workoutValue
            } trailing: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var workoutValue: some View {
        switch metrics.state {
        case .rest:
            Text("Rest day", comment: "Workout row on a rest day")
                .font(.ui(14, .medium))
                .foregroundStyle(DS.silver.opacity(0.65))
        case .done:
            BigValue(value: String(localized: "today.state.done", defaultValue: "Done",
                                   comment: "Today's workout state: finished (not the Done button)"),
                     unit: "· \(TodayCount.sets(metrics.setsDone))", size: 20)
        case .planned, .inProgress:
            BigValue(value: "\(metrics.setsDone)", unit: "/ \(TodayCount.sets(metrics.setsPlanned))", size: 20)
        case .recommended, .recovering:
            Text(weekLine)
                .font(.ui(14, .medium))
                .monospacedDigit()
                .foregroundStyle(DS.silver.opacity(0.65))
        }
    }

    /// "2 of 4 this week", or the count alone without a schedule.
    private var weekLine: String {
        if metrics.weekPlanned == 0 { return TodayWeekStrip.summary(metrics) }
        return String(localized: "\(metrics.weekDone) of \(metrics.weekGoal) this week", comment: "Workout row: 2 of 4 this week")
    }

    // MARK: Apple Health

    /// Today's steps against the goal (Health's and any added by hand, which
    /// the line under says); opens the trends in Progress, or the walk log
    /// when every step today was added by hand.
    private var stepsRow: some View {
        Button(action: actions.openSteps(metrics)) {
            row(ring: RingGlyph(progress: metrics.stepsProgress, color: HealthTone.steps, symbol: "figure.walk",
                                done: metrics.stepsReached),
                title: String(localized: "Steps", comment: "Today row"), isNext: false) {
                BigValue(value: HealthFormat.steps(metrics.stepsToday ?? 0),
                         unit: "/ \(HealthFormat.steps(metrics.stepsGoal))", size: 20)
                if metrics.manualStepsToday > 0 {
                    Text(TodayHealthText.stepsCaption(metrics))
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
            } trailing: {
                chevron
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(TodayHealthText.stepsSpoken(metrics))
        .accessibilityHint(TodayHealthText.stepsHint(metrics))
    }

    /// Last night's sleep against the goal; ticked once it reaches the band
    /// (an hour under the goal or more).
    private var sleepRow: some View {
        Button(action: actions.openProgress) {
            row(ring: RingGlyph(progress: metrics.sleepProgress, color: HealthTone.sleep, symbol: "bed.double.fill",
                                done: metrics.sleepReached, dashed: metrics.lastNightMinutes == nil),
                title: String(localized: "Last night", comment: "Today row: last night's sleep"), isNext: false) {
                if let minutes = metrics.lastNightMinutes {
                    BigValue(value: HealthFormat.sleep(minutes: minutes),
                             unit: "/ \(HealthFormat.sleep(minutes: metrics.sleepGoalMinutes))", size: 20)
                } else {
                    Text("No sleep recorded", comment: "Sleep row: nothing in Apple Health for last night")
                        .font(.ui(14, .medium))
                        .foregroundStyle(DS.silver.opacity(0.65))
                }
            } trailing: {
                chevron
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(TodayHealthText.sleepSpoken(metrics))
        .accessibilityHint(TodayHealthText.opensProgress)
    }

    /// Connected, but Health sent nothing: where to look, and the way there.
    /// Built like the other rows, but top-aligned with a close button at the
    /// top right, as the notes have: it puts the row away for good.
    private var healthEmptyRow: some View {
        HStack(alignment: .top, spacing: 14) {
            RingGlyph(progress: 0, color: HealthTone.steps, symbol: "heart.text.square", done: false, dashed: true)
            VStack(alignment: .leading, spacing: 3) {
                Text("Apple Health", comment: "Today row")
                    .font(.ui(16, .semibold))
                    .foregroundStyle(DS.silver)
                Text(HealthCopy.noData)
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                QuickChip(title: String(localized: "Open the Health app")) { HealthCopy.openHealthApp() }
            }
            Spacer(minLength: 6)
            Button {
                withAnimation(.easeOut(duration: 0.2)) { healthEmptyDismissed = true }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            // The 44-pt target reaches into the row's padding, not the text.
            .padding(.top, -10)
            .padding(.trailing, -10)
            .accessibilityLabel(String(localized: "Don't show again", comment: "Closes a Today note for good"))
        }
        .padding(.vertical, 12)
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(DS.silver.opacity(0.4))
    }

    private var remindersRow: some View {
        Button(action: actions.reminders) {
            HStack(spacing: 14) {
                Image(systemName: metrics.waterReminderOn || metrics.weighInReminderOn ? "bell.fill" : "bell")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .frame(width: 42)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Water & reminders", comment: "Today row: the water target and the reminders")
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                    Text(remindersSummary)
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    /// "Target 2.5 L · every 2 h · weigh-in 7:00", reminders off, or iOS has
    /// them off.
    private var remindersSummary: String {
        let target = String(localized: "Target \(DailyStore.litres(metrics.waterTarget))", comment: "Water target: Target 2.5 L")
        var parts = [target]
        if daily.notificationsDenied && (metrics.waterReminderOn || metrics.weighInReminderOn) {
            parts.append(String(localized: "Off in iOS Settings"))
            return parts.joined(separator: " · ")
        }
        if metrics.waterReminderOn {
            parts.append(String(localized: "Water every \(daily.waterReminder.everyHours) h", comment: "Reminders summary"))
        }
        if metrics.weighInReminderOn {
            parts.append(String(localized: "Weigh-in \(TodayView.time(daily.weighInReminder.hour, daily.weighInReminder.minute))",
                                comment: "Reminders summary: Weigh-in 7:00"))
        }
        if parts.count == 1 { parts.append(String(localized: "Reminders off")) }
        return parts.joined(separator: " · ")
    }

    /// `open`: the ring, name and value become one button (the trailing
    /// controls stay their own), with `openHint` for VoiceOver.
    private func row<Ring: View, Value: View, Trailing: View>(
        ring: Ring, title: String, isNext: Bool, open: (() -> Void)? = nil, openHint: String = "",
        @ViewBuilder value: () -> Value, @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        let leading = HStack(spacing: 14) {
            ring
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.ui(16, .semibold))
                        .foregroundStyle(DS.silver)
                    if isNext {
                        Text("Next", comment: "Tag on the habit to do next")
                            .font(.mono(9.5, .semibold))
                            .trackingEm(0.08, size: 9.5)
                            .textCase(.uppercase)
                            .foregroundStyle(DS.silver.opacity(0.85))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.35), lineWidth: 1))
                    }
                }
                value()
            }
            Spacer(minLength: 6)
        }
        return HStack(spacing: 14) {
            if let open {
                Button(action: open) {
                    leading.contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityHint(openHint)
            } else {
                leading
            }
            trailing()
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Open sections

/// The plan's daily target, led by one number, with its macro split.
struct PlanOpenSection: View {
    var metrics: TodayMetrics
    var plan: NutritionPlan
    var actions: TodayActions
    var macroColors: (Color, Color, Color) = (DS.activation, DS.activationSoft, DS.silver.opacity(0.35))

    @Environment(WorkoutStore.self) private var store

    var body: some View {
        let protein = Int(plan.protein), fat = Int(plan.fat), carbs = Int(plan.carbs)
        let shares = TodayMacroBar.shares(protein: protein, fat: fat, carbs: carbs)
        VStack(alignment: .leading, spacing: 0) {
            TodaySectionHead(title: String(localized: "Your plan", comment: "Today section"),
                             link: String(localized: "How it's calculated"), action: actions.showPlan)
            if metrics.targetReached {
                reachedNote
                    .padding(.top, 8)
                    .padding(.bottom, 16)
            }
            TodayEyebrow(text: String(localized: "Daily target"), size: 11)
                .padding(.top, 6)
            HStack(alignment: .firstTextBaseline) {
                BigValue(value: Int(plan.calories).formatted(), unit: "kcal", size: 28, weight: .semibold)
                Spacer(minLength: 8)
                Text(plan.effectiveGoal.title)
                    .font(.mono(10, .semibold))
                    .trackingEm(0.08, size: 10)
                    .textCase(.uppercase)
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(Capsule().strokeBorder(DS.silver.opacity(0.2), lineWidth: 1))
            }
            .padding(.top, 4)
            if metrics.belowFloor {
                Text("No deficit for now: what you burn is already under the floor. Talk to a doctor or dietitian before eating less.")
                    .font(.ui(14, .medium))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
            } else if let goal = TodayView.goalLine(plan, unit: store.unit) {
                Text(goal)
                    .font(.ui(14, .medium))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .padding(.top, 4)
            }
            if metrics.showsEnergyNote {
                TodayEnergyNote(metrics: metrics)
                    .padding(.top, 10)
            }
            TodayMacroBar(protein: protein, fat: fat, carbs: carbs, colors: macroColors)
                .padding(.top, 16)
            HStack(alignment: .top, spacing: 12) {
                column(String(localized: "Protein", comment: "Macro"), protein, shares[0], macroColors.0)
                column(String(localized: "Fat", comment: "Macro"), fat, shares[1], macroColors.1)
                column(String(localized: "Carbs", comment: "Macro"), carbs, shares[2], macroColors.2)
            }
            .padding(.top, 14)
        }
    }

    private func column(_ name: String, _ grams: Int, _ share: Int, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2, style: .continuous).fill(color).frame(width: 8, height: 8)
                TodayEyebrow(text: name, size: 10.5)
            }
            BigValue(value: "\(grams)", unit: "g", size: 20, weight: .semibold)
            Text("\(share)% of kcal", comment: "A macro's share of calories: 29% of kcal")
                .font(.ui(12, .medium))
                .foregroundStyle(DS.silver.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private var reachedNote: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "flag.checkered")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.85))
            VStack(alignment: .leading, spacing: 6) {
                Text("You reached your target.")
                    .font(.system(size: 17, weight: .medium, design: .serif))
                    .foregroundStyle(DS.silver)
                Text("Your plan now eats what you burn. Set a new goal when you're ready.")
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
                QuickChip(title: String(localized: "Set a new goal"), action: actions.editProfile)
            }
        }
    }
}

/// The 7-day average, led by one number, its 30-day change and the trend.
struct WeightOpenSection: View {
    var plan: NutritionPlan?
    var tone: Color
    /// C adds a serif line about the direction.
    var coachLine: Bool
    var actions: TodayActions

    @Environment(WorkoutStore.self) private var store
    @Environment(DailyStore.self) private var daily

    var body: some View {
        let unit = store.unit
        let now = Date()
        VStack(alignment: .leading, spacing: 0) {
            TodaySectionHead(title: String(localized: "Weight", comment: "Today section"),
                             link: daily.weights.isEmpty ? nil : String(localized: "History"),
                             action: actions.weightHistory)
            if let latest = daily.latestWeight {
                let average = daily.trendWeight(at: now)
                TodayEyebrow(text: average != nil ? String(localized: "7-day average") : String(localized: "Last weigh-in"),
                             size: 11)
                    .padding(.top, 6)
                HStack(alignment: .firstTextBaseline) {
                    let shown = (unit.fromKilograms(average ?? latest.kg) * 10).rounded() / 10
                    BigValue(value: shown.formatted(.number.precision(.fractionLength(1))), unit: unit.symbol,
                             size: 28, weight: .semibold)
                    Spacer(minLength: 8)
                    if let change = daily.trendChange(days: 30) {
                        delta(change, unit: unit)
                    }
                }
                .padding(.top, 4)
                Text(lastLine(latest, unit: unit))
                    .font(.ui(13.5, .medium))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .padding(.top, 4)
                if coachLine, let line = directionLine {
                    Text(line)
                        .font(.system(size: 17, weight: .medium, design: .serif))
                        .foregroundStyle(DS.silver.opacity(0.9))
                        .padding(.top, 10)
                }
                if let trend = WeightTrend(daily: daily, plan: plan, unit: unit, now: now) {
                    WeightTrendChart(trend: trend, tone: tone, unit: unit)
                        .frame(height: 128)
                        .padding(.top, 14)
                        .contentShape(Rectangle())
                        .onTapGesture { actions.weightHistory() }
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint(String(localized: "Opens your weigh-ins"))
                    if let target = trend.target, !trend.targetInRange {
                        // Off the chart: the arrow points to the side of the data it's on.
                        Text("Target \(unit.bodyWeight(unit.toKilograms(target))) \(target < trend.dataLow ? "↓" : "↑")",
                             comment: "A target off the chart: Target 64 kg ↓")
                            .font(.mono(9.5, .medium))
                            .textCase(.uppercase)
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top, 4)
                    }
                } else {
                    Text("A few more weigh-ins start your trend line.")
                        .font(.ui(13.5))
                        .foregroundStyle(DS.silver.opacity(0.65))
                        .padding(.top, 10)
                }
                QuickChip(title: String(localized: "Log weight"), action: actions.logWeight)
                    .padding(.top, 8)
            } else {
                Text("Your trend starts with a weigh-in.")
                    .font(.system(size: 17, weight: .medium, design: .serif))
                    .foregroundStyle(DS.silver.opacity(0.9))
                    .padding(.top, 8)
                Text("Weigh in a few mornings a week. Your plan follows the 7-day average, so one salty dinner doesn't move your calories.")
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 6)
                QuickChip(title: String(localized: "Log weight"), action: actions.logWeight)
                    .padding(.top, 6)
            }
        }
    }

    /// "↘ 0.8 kg · 30 days"; a change that rounds to nothing gets a flat arrow.
    private func delta(_ change: Double, unit: WeightUnit) -> some View {
        let shown = (unit.fromKilograms(abs(change)) * 10).rounded() / 10
        let symbol = shown == 0 ? "arrow.right" : change < 0 ? "arrow.down.right" : "arrow.up.right"
        return HStack(spacing: 4) {
            Image(systemName: symbol)
                .font(.system(size: 11, weight: .bold))
            Text("\(unit.bodyWeight(abs(change))) · 30 days", comment: "Weight change: 0.8 kg · 30 days")
                .font(.ui(13, .semibold))
                .monospacedDigit()
        }
        .foregroundStyle(DS.silver.opacity(0.85))
        .padding(.horizontal, 10)
        .frame(height: 26)
        .background(Capsule().fill(DS.silver.opacity(0.07)))
        .accessibilityElement(children: .combine)
    }

    private func lastLine(_ latest: WeightEntry, unit: WeightUnit) -> String {
        let when = Calendar.current.isDateInToday(latest.date)
            ? String(localized: "today", comment: "When the last weigh-in was: today")
            : latest.date.formatted(.relative(presentation: .named))
        return String(localized: "Last \(unit.bodyWeight(latest.kg)), \(when)", comment: "Last weigh-in: Last 74.2 kg, today")
    }

    /// "Trending down." for a loss goal going down, and so on, scaled to the
    /// size of the change; nothing for Stay fit, or without a month of data.
    private var directionLine: String? {
        guard let change = daily.trendChange(days: 30), let goal = plan?.effectiveGoal else { return nil }
        if abs(change) < 0.2 { return goal == .getFit ? nil : String(localized: "Holding steady.") }
        let small = abs(change) < 1
        switch goal {
        case .loseWeight:
            if change < 0 { return String(localized: "Trending down.") }
            return small ? String(localized: "Up a little this month.") : String(localized: "Up this month.")
        case .buildMuscle:
            if change > 0 { return String(localized: "Trending up.") }
            return small ? String(localized: "Down a little this month.") : String(localized: "Down this month.")
        default:
            return nil
        }
    }
}
