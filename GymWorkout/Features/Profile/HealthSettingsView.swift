//
//  HealthSettingsView.swift
//  GymWorkout
//
//  Profile › Settings › Apple Health (phase 2, 2026-11-22, owner-approved
//  list), pushed like Help & FAQ: connecting, what MUSQ reads and where its
//  access is changed, the step and sleep goals, the switch that lets the
//  last 14 days' steps stand in for the daily-activity answer, and what
//  happens to the data. Nothing here is passed on: the ads never see an
//  Apple Health value, and the AI coach (where it's live) gets sleep
//  numbers only in a Balance question the user chooses to include them in.
//
//  HealthKit never says whether reading was turned off — a "no" looks like
//  no data — so "Connected" means the Health sheet was shown, and the screen
//  points to the Health app rather than claiming access it can't check.
//
//  On iPad the sections sit in two columns once the content column reaches
//  700pt, as on Profile: connecting and what's read on the left, the goals,
//  the plan and privacy on the right.
//

import SwiftUI

struct HealthSettingsView: View {
    @Environment(AppleHealth.self) private var health
    @Environment(WorkoutStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout
    @State private var isConnecting = false

    var body: some View {
        let columns = layout.containerWidth >= 700 ? 2 : 1
        let width: CGFloat = columns == 2 ? 1120 : 620
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                HistoryHeader(title: String(localized: "Apple Health"), meta: headerMeta,
                              maxWidth: width, onBack: { dismiss() })
                ScrollView(showsIndicators: false) {
                    // Source order is the one-column order.
                    DSColumns(columns: columns, spacing: 24, rowSpacing: 28) {
                        statusSection
                            .dsColumn(0)
                        if health.access == .asked {
                            goalsSection
                                .dsColumn(1)
                            colorsSection
                                .dsColumn(1)
                            planSection
                                .dsColumn(1)
                        }
                        if health.access != .unavailable {
                            readsSection
                                .dsColumn(0)
                        }
                        privacySection
                            .dsColumn(1)
                    }
                    .dsReadable(width)
                    .dsGutter()
                    .padding(.top, 6)
                    .padding(.bottom, 32)
                    .animation(.easeOut(duration: 0.3), value: health.access)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        // ⌘[ and Esc on an iPad keyboard.
        .dsBackShortcuts { dismiss() }
        // Fresh numbers for the status card; a no-op until connected.
        .task { await health.refresh() }
    }

    /// "CONNECTED · READ ONLY"
    private var headerMeta: String {
        switch health.access {
        case .asked: return String(localized: "CONNECTED · READ ONLY", comment: "Apple Health settings header")
        case .notAsked: return String(localized: "NOT CONNECTED", comment: "Apple Health settings header")
        case .unavailable: return String(localized: "NOT AVAILABLE", comment: "Apple Health settings header")
        }
    }

    // MARK: - Status

    @ViewBuilder
    private var statusSection: some View {
        switch health.access {
        case .notAsked:
            section("CONNECT") { connectCard }
        case .asked:
            section("STATUS") { connectedCard }
        case .unavailable:
            // Profile hides its row on such devices; this only keeps the
            // screen whole if it's reached anyway.
            section("STATUS") {
                Text("Apple Health isn't available on this \(DS.deviceNoun).")
                    .font(.ui(layout.value(13, 14.5)))
                    .cssLineHeight(layout.value(13, 14.5), 1.5)
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, layout.value(13, 16))
                    .settingsCard(layout)
            }
        }
    }

    /// The invitation: why, then Apple's sheet.
    private var connectCard: some View {
        VStack(alignment: .leading, spacing: layout.value(12, 14)) {
            HStack(alignment: .top, spacing: 12) {
                iconWell("heart.text.square", tone: DS.silver.opacity(0.8))
                rowText(HealthCopy.connectTitle, detail: HealthCopy.connectDetail)
            }
            .accessibilityElement(children: .combine)
            WideButton(title: isConnecting ? String(localized: "Connecting…", comment: "Apple Health: the sheet is opening")
                                           : HealthCopy.connectTitle,
                       prominent: true, action: { connect() })
                .disabled(isConnecting)
                .dsCTA(alignment: .leading)
            Text("Apple's Health sheet opens next. Turn on what you want MUSQ to read; you can change it later in the Health app.")
                .font(.ui(layout.value(12, 13)))
                .cssLineHeight(layout.value(12, 13), 1.4)
                .foregroundStyle(DS.silver.opacity(0.5))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, layout.value(14, 18))
        .settingsCard(layout)
    }

    /// Connected, when it last read, and today's numbers. Without them: still
    /// reading, nothing in Health at all (where to look), or just nothing yet
    /// today — an early morning isn't a sign that access is off.
    private var connectedCard: some View {
        VStack(alignment: .leading, spacing: layout.value(12, 14)) {
            HStack(alignment: .top, spacing: 12) {
                iconWell("checkmark", tone: DS.silver)
                rowText(String(localized: "Connected", comment: "Apple Health status"), detail: readDetail)
            }
            .accessibilityElement(children: .combine)
            Hairline(opacity: 0.06)
            if health.lastRefresh == nil {
                HStack(spacing: 8) {
                    ProgressView()
                        .controlSize(.small)
                        .tint(DS.silver)
                    statusNote(String(localized: "Reading Apple Health…", comment: "Apple Health settings: the first read is running"))
                }
                .accessibilityElement(children: .combine)
            } else if !todayFacts.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12, alignment: .topLeading),
                                         count: 2),
                          alignment: .leading, spacing: 14) {
                    ForEach(todayFacts) { fact in
                        factView(fact)
                    }
                }
            } else if health.dailySteps.isEmpty && health.nights.isEmpty {
                statusNote(HealthCopy.noData)
            } else {
                statusNote(String(localized: "Nothing recorded today yet.",
                                  comment: "Apple Health settings: Health has earlier days but nothing for today"))
            }
        }
        .padding(.vertical, layout.value(14, 18))
        .settingsCard(layout)
    }

    private func statusNote(_ text: String) -> some View {
        Text(text)
            .font(.ui(layout.value(12.5, 14)))
            .cssLineHeight(layout.value(12.5, 14), 1.45)
            .foregroundStyle(DS.silver.opacity(0.6))
            .fixedSize(horizontal: false, vertical: true)
    }

    /// "Read only. Last read at 10:42."
    private var readDetail: String {
        guard let time = health.lastRefresh?.formatted(date: .omitted, time: .shortened) else {
            return String(localized: "Read only. MUSQ never writes to Apple Health.")
        }
        return String(localized: "Read only. Last read at \(time).", comment: "Apple Health status: Last read at 10:42.")
    }

    private struct Fact: Identifiable {
        var id: String { label }
        let label: String
        let value: String
        let spoken: String
        var tone: Color?
    }

    /// Whatever Health has for today; a phone without a Watch usually has
    /// no active energy, and no one has sleep before the first night.
    private var todayFacts: [Fact] {
        var facts: [Fact] = []
        if let steps = health.stepsTodayTotal {
            facts.append(Fact(label: String(localized: "STEPS TODAY", comment: "Apple Health settings: small label over today's figure, two to a row"),
                              value: HealthFormat.steps(steps),
                              spoken: String(localized: "\(HealthFormat.steps(steps)) steps today", comment: "VoiceOver"),
                              tone: HealthTone.steps))
        }
        if let km = health.distanceTodayKm, km > 0 {
            facts.append(Fact(label: String(localized: "DISTANCE", comment: "Apple Health settings: small label over today's figure, two to a row"),
                              value: HealthFormat.distance(km: km),
                              spoken: String(localized: "Walked \(HealthFormat.distance(km: km)) today", comment: "VoiceOver"),
                              tone: HealthTone.steps))
        }
        if let night = health.lastNight {
            facts.append(Fact(label: String(localized: "LAST NIGHT", comment: "Apple Health settings: small label over last night's sleep, two to a row"),
                              value: HealthFormat.sleep(minutes: night.asleepMinutes),
                              spoken: String(localized: "Slept \(HealthFormat.sleepSpoken(minutes: night.asleepMinutes)) last night",
                                             comment: "VoiceOver: Slept 7 hours 12 minutes last night"),
                              tone: HealthTone.sleep))
        }
        if let kcal = health.activeKcalToday, kcal > 0 {
            let value = String(localized: "\(Int(kcal.rounded()).formatted()) kcal", comment: "Active energy: 320 kcal")
            facts.append(Fact(label: String(localized: "ACTIVE ENERGY", comment: "Apple Health settings: small label over today's figure, two to a row"),
                              value: value,
                              spoken: String(localized: "\(value) of active energy today", comment: "VoiceOver"),
                              tone: nil))
        }
        return facts
    }

    private func factView(_ fact: Fact) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                if let tone = fact.tone {
                    Circle().fill(tone).frame(width: 6, height: 6)
                }
                MetaLine(text: fact.label, size: layout.value(8.5, 10))
            }
            Text(fact.value)
                .font(.ui(layout.value(15, 17), .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(fact.spoken)
    }

    private func connect() {
        guard !isConnecting else { return }
        isConnecting = true
        Task {
            await health.connect()
            isConnecting = false
        }
    }

    // MARK: - What MUSQ reads

    /// The five types, what each is for, and — once asked — where access is
    /// changed, since MUSQ can't see it.
    private var readsSection: some View {
        section("WHAT MUSQ READS") {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: layout.value(12, 14)) {
                    readRow("figure.walk", tone: HealthTone.steps,
                            title: String(localized: "Steps"),
                            detail: String(localized: "Today's count, your goal and trend, and how active your calorie plan assumes you are."))
                    readRow("map", tone: HealthTone.steps,
                            title: String(localized: "Walking distance"),
                            detail: String(localized: "Shown beside today's steps."))
                    readRow("flame", tone: DS.silver.opacity(0.7),
                            title: String(localized: "Active energy"),
                            detail: String(localized: "Shown beside your calorie target, never added to it."))
                    readRow("bed.double", tone: HealthTone.sleep,
                            title: String(localized: "Sleep"),
                            detail: String(localized: "Time asleep each night, with your Watch's sleep stages when it records them."))
                    readRow("applewatch", tone: DS.silver.opacity(0.7),
                            title: String(localized: "Workouts"),
                            detail: String(localized: "A Watch workout that matches a MUSQ session, for the energy and time it measured."))
                }
                .padding(.vertical, layout.value(14, 18))

                Hairline(opacity: 0.06)

                VStack(alignment: .leading, spacing: layout.value(12, 14)) {
                    Text(accessNote)
                        .font(.ui(layout.value(12, 13.5)))
                        .cssLineHeight(layout.value(12, 13.5), 1.45)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                    if health.access == .asked {
                        WideButton(title: String(localized: "Open the Health app",
                                                 comment: "Button: opens the Health app, where MUSQ's access is changed"),
                                   prominent: false) {
                            HealthCopy.openHealthApp()
                        }
                        .dsCTA(alignment: .leading)
                        .accessibilityHint("Opens the Health app, where MUSQ's access is changed")
                    }
                }
                .padding(.vertical, layout.value(14, 18))
            }
            .settingsCard(layout)
        }
    }

    private var accessNote: String {
        health.access == .asked
            ? String(localized: "Apple Health doesn't tell apps when reading is turned off, so MUSQ just sees no data. To change what MUSQ can read, go to Settings › Privacy & Security › Health › MUSQ (or in the Health app, tap your picture › Apps › MUSQ).",
                     comment: "Apple Health settings, under what MUSQ reads. The › paths are iOS menus: use iOS's own Vietnamese names")
            : String(localized: "You choose each one on Apple's sheet when you connect, and can change it later in the Health app.")
    }

    private func readRow(_ symbol: String, tone: Color, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: layout.value(14, 16), weight: .semibold))
                .foregroundStyle(tone)
                .frame(width: layout.value(22, 26))
                .padding(.top, 1)
                .accessibilityHidden(true)
            rowText(title, detail: detail)
        }
        .accessibilityElement(children: .combine)
    }

    // MARK: - Goals

    private var goalsSection: some View {
        @Bindable var health = health
        return section("GOALS") {
            VStack(spacing: 0) {
                goalStepper(title: String(localized: "Steps goal"), detail: stepsGoalDetail,
                            value: $health.stepsGoal, range: AppleHealth.stepsGoalRange, step: 500,
                            shown: HealthFormat.steps(health.stepsGoal),
                            spoken: String(localized: "\(HealthFormat.steps(health.stepsGoal)) steps a day",
                                           comment: "VoiceOver: the steps goal"))
                Hairline(opacity: 0.06)
                goalStepper(title: String(localized: "Sleep goal"), detail: sleepGoalDetail,
                            value: $health.sleepGoalMinutes, range: AppleHealth.sleepGoalRange, step: 15,
                            shown: HealthFormat.sleep(minutes: health.sleepGoalMinutes),
                            spoken: String(localized: "\(HealthFormat.sleepSpoken(minutes: health.sleepGoalMinutes)) a night",
                                           comment: "VoiceOver: the sleep goal, e.g. 8 hours a night"))
            }
            .settingsCard(layout)
        }
    }

    /// "Steps a day. Your average over the last 30 days: 7,900."
    private var stepsGoalDetail: String {
        let base = String(localized: "Steps a day.", comment: "Steps goal detail")
        guard let average = health.averageSteps(days: 30) else { return base }
        return base + " " + String(localized: "Your average over the last 30 days: \(HealthFormat.steps(average)).",
                                   comment: "Steps goal detail: Your average over the last 30 days: 7,900.")
    }

    private var sleepGoalDetail: String {
        let base = String(localized: "Time asleep a night. Most adults do best on 7 to 9 hours.")
        guard let average = health.averageSleep(days: 30) else { return base }
        return base + " " + String(localized: "Your average over the last 30 nights: \(HealthFormat.sleep(minutes: average)).",
                                   comment: "Sleep goal detail: Your average over the last 30 nights: 7 h 05.")
    }

    private func goalStepper(title: String, detail: String, value: Binding<Int>, range: ClosedRange<Int>,
                             step: Int, shown: String, spoken: String) -> some View {
        Stepper(value: value, in: range, step: step) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                rowText(title, detail: detail)
                Spacer(minLength: 8)
                Text(shown)
                    .font(.mono(layout.value(14, 16), .semibold))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver)
                    .lineLimit(1)
                    .fixedSize()
            }
        }
        .padding(.vertical, layout.value(13, 16))
        .accessibilityLabel(title)
        .accessibilityValue(spoken)
        .accessibilityHint(detail)
    }

    // MARK: - Colors

    /// Three colours each for steps and sleep, the user's pick (the owner left
    /// it to users, 2026-11-22). Every ring, bar and chart follows at once.
    private var colorsSection: some View {
        @Bindable var palette = HealthPalette.shared
        return section("COLORS") {
            VStack(spacing: 0) {
                toneRow(title: String(localized: "Steps", comment: "Colour setting row"),
                        detail: String(localized: "Steps on Today and in Progress."),
                        symbol: "figure.walk", options: StepsTone.allCases, selection: $palette.steps)
                Hairline(opacity: 0.06)
                toneRow(title: String(localized: "Sleep", comment: "Colour setting row"),
                        detail: String(localized: "Sleep on Today and in Progress."),
                        symbol: "bed.double.fill", options: SleepTone.allCases, selection: $palette.sleep)
            }
            .settingsCard(layout)
        }
    }

    private func toneRow<Tone: Identifiable & Hashable>(title: String, detail: String, symbol: String,
                                                       options: [Tone], selection: Binding<Tone>) -> some View
        where Tone: ToneOption {
        VStack(alignment: .leading, spacing: layout.value(10, 12)) {
            rowText(title, detail: detail)
            HStack(spacing: 6) {
                ForEach(options) { tone in
                    toneSwatch(tone, symbol: symbol, selected: selection.wrappedValue == tone) {
                        withAnimation(.easeOut(duration: 0.2)) { selection.wrappedValue = tone }
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(title)
        }
        .padding(.vertical, layout.value(13, 16))
    }

    /// A ring in the colour, as the Today glyphs draw it, with its name.
    private func toneSwatch(_ tone: some ToneOption, symbol: String, selected: Bool,
                            action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 7) {
                ZStack {
                    Circle().stroke(tone.color.opacity(0.22), lineWidth: 4)
                    Circle().trim(from: 0, to: 0.7)
                        .stroke(tone.color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Image(systemName: symbol)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(tone.color)
                }
                .frame(width: 30, height: 30)
                .padding(5)
                .overlay(Circle().strokeBorder(DS.silver.opacity(selected ? 1 : 0.12),
                                               lineWidth: selected ? 2 : 1))
                Text(tone.title)
                    .font(.ui(layout.value(11, 12), .semibold))
                    .foregroundStyle(DS.silver.opacity(selected ? 1 : 0.55))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(DS.silver.opacity(selected ? 0.07 : 0)))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .dsHover()
        .accessibilityLabel(tone.title)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    // MARK: - Calorie plan

    private var planSection: some View {
        @Bindable var health = health
        let status = planStatus
        return section("CALORIE PLAN") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(spacing: 0) {
                    Toggle(isOn: $health.usesStepsForPlan) {
                        rowText(String(localized: "Use my steps for my calorie plan"),
                                detail: String(localized: "Your average steps set how active your days are, in place of your answer to the daily-activity question."))
                    }
                    .tint(DS.silver)
                    .padding(.vertical, layout.value(13, 16))

                    Hairline(opacity: 0.06)

                    VStack(alignment: .leading, spacing: 4) {
                        MetaLine(text: health.usesStepsForPlan ? "NOW" : "OFF", size: layout.value(8.5, 10))
                        Text(status.text)
                            .font(.ui(layout.value(13, 14.5), .semibold))
                            .cssLineHeight(layout.value(13, 14.5), 1.4)
                            .foregroundStyle(DS.silver)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, layout.value(13, 16))
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(status.spoken)
                }
                .settingsCard(layout)

                footnote(planRule)
            }
        }
    }

    /// What the plan uses right now, shown and spoken (the arrow isn't read
    /// well).
    private var planStatus: (text: String, spoken: String) {
        // Profiles saved before the plan questions have no plan for the
        // steps to set; Today's "Finish your plan" asks the rest.
        guard let profile = store.profile, NutritionPlan(profile: profile) != nil else {
            let text = health.usesStepsForPlan
                ? String(localized: "You don't have a calorie plan yet. Finish it on Today; your steps will then set its daily activity.",
                         comment: "Apple Health settings: the profile predates the plan questions")
                : String(localized: "You don't have a calorie plan yet. Finish it on Today.",
                         comment: "Apple Health settings: the profile predates the plan questions; steps switch off")
            return (text, text)
        }
        let answer = profile.activity.map {
            String(localized: "Your plan uses your answer: \($0.title).",
                   comment: "Apple Health settings: the daily-activity answer the plan uses, e.g. Mostly sitting")
        } ?? String(localized: "Your plan uses your answer to the daily-activity question.")
        guard health.usesStepsForPlan else { return (answer, answer) }

        let window = MeasuredActivity.windowDays.formatted()
        if let measured = health.measuredActivity {
            let level = measured.activity.title
            // The level carried over from the last read, until today's first
            // one: no average or days to show yet.
            guard measured.days > 0 else {
                let text = String(localized: "Updating from Apple Health… Until then, your plan uses your recent steps: \(level).",
                                  comment: "Apple Health settings: before today's first read. The end is the daily activity, e.g. On my feet a lot")
                return (text, text)
            }
            let steps = HealthFormat.steps(measured.averageSteps)
            var text = String(localized: "Last \(window) days: \(steps) steps a day → \(level)",
                              comment: "Apple Health settings: Last 14 days: 9,240 steps a day → On my feet a lot")
            var spoken = String(localized: "Last \(window) days: \(steps) steps a day, so your plan uses \(level).",
                                comment: "VoiceOver: the steps average and the daily activity it sets")
            if measured.days < MeasuredActivity.windowDays {
                let counted = String(localized: "Based on \(measured.days.formatted()) of those days.",
                                     comment: "Days with enough steps to count, e.g. Based on 11 of those days.")
                text += "\n" + counted
                spoken += " " + counted
            }
            return (text, spoken)
        }
        // The first read is still running: no "0 of the last 14" yet.
        if health.lastRefresh == nil {
            let text = String(localized: "Reading Apple Health…", comment: "Apple Health settings: the first read is running")
                + " " + answer
            return (text, text)
        }
        let needs = String(localized: "Needs \(MeasuredActivity.minimumDays.formatted()) days with steps; Apple Health has \(countedDays.formatted()) of the last \(window) so far.",
                           comment: "Apple Health settings: Needs 7 days with steps; Apple Health has 3 of the last 14 so far.")
        let text = needs + " " + answer
        return (text, text)
    }

    /// Days in the plan's window that count (`MeasuredActivity`'s rule), for
    /// "3 so far".
    private var countedDays: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let start = calendar.date(byAdding: .day, value: -MeasuredActivity.windowDays, to: today) else { return 0 }
        return health.allDailySteps.filter {
            $0.day >= start && $0.day < today && $0.value >= MeasuredActivity.minimumSteps
        }.count
    }

    /// The rule in plain words, from `MeasuredActivity`'s own numbers so the
    /// copy can't drift from them.
    private var planRule: String {
        let window = MeasuredActivity.windowDays.formatted()
        let skipped = Int(MeasuredActivity.minimumSteps).formatted()
        let days = MeasuredActivity.minimumDays.formatted()
        let onFeet = Int(MeasuredActivity.onFeetFrom).formatted()
        let onFeetTop = (Int(MeasuredActivity.physicalFrom) - 1).formatted()
        let physical = Int(MeasuredActivity.physicalFrom).formatted()
        let margin = Int(MeasuredActivity.hysteresis).formatted()
        return String(localized: "MUSQ averages your steps over the last \(window) full days, skipping days under \(skipped) steps (a phone left at home), and needs at least \(days) of them. Steps during your logged MUSQ workouts don't count, since your training days already do. Under \(onFeet) steps a day counts as “\(DailyActivity.sitting.title)”, \(onFeet) to \(onFeetTop) as “\(DailyActivity.onFeet.title)”, and \(physical) or more as “\(DailyActivity.physical.title)”, in place of your answer to the daily-activity question. So that one long walk doesn't move your calories, the level changes only once your average is \(margin) steps past the line.",
                      comment: "How Apple Health steps set the calorie plan's daily activity. The quoted names are the daily-activity answers.")
    }

    // MARK: - Privacy

    private var privacySection: some View {
        section("PRIVACY") {
            HStack(alignment: .top, spacing: 12) {
                iconWell("lock", tone: DS.silver.opacity(0.8))
                Text(privacyText)
                    .font(.ui(layout.value(12.5, 14)))
                    .cssLineHeight(layout.value(12.5, 14), 1.5)
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, layout.value(14, 18))
            .settingsCard(layout)
            .accessibilityElement(children: .combine)
        }
    }

    /// The AI coach is named only in builds that have it, with the one way
    /// sleep reaches it: a Balance question the user includes it in, which
    /// then stays in the chat (kept out of backups) until cleared. What's
    /// saved follows `AppleHealth`: the goals and the switch always, the
    /// step band only while the switch is on.
    private var privacyText: String {
        AIService.isLive
            ? String(localized: "MUSQ only reads from Apple Health and never writes to it. What it reads stays on this \(DS.deviceNoun): the readings aren't saved in MUSQ's files or your backups, and they're never sent to MUSQ or advertisers. The one exception is yours to make: if you include your sleep in a question about your Balance, those sleep numbers go to the AI coach, through MUSQ's server and OpenAI, with that question and the next ones in the chat, and stay in the chat on this \(DS.deviceNoun), never in backups, until you clear it. Your step and sleep goals and the calorie-plan switch are kept with your other settings, and, only while your steps set the plan, the activity level they last set.")
            : String(localized: "MUSQ only reads from Apple Health and never writes to it. What it reads stays on this \(DS.deviceNoun): the readings are never saved in MUSQ's files, so they aren't in your backups, and they're never sent to MUSQ or advertisers. Your step and sleep goals and the calorie-plan switch are kept with your other settings, and, only while your steps set the plan, the activity level they last set.")
    }

    // MARK: - Pieces

    private func section<Content: View>(_ title: String.LocalizationValue,
                                        @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: title)
                .accessibilityAddTraits(.isHeader)
            content()
        }
    }

    /// A setting's title and what it does, as on Profile's settings card.
    private func rowText(_ title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.ui(layout.value(14.5, 16), .semibold))
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
            Text(detail)
                .font(.ui(layout.value(12, 13.5)))
                .cssLineHeight(layout.value(12, 13.5), 1.4)
                .foregroundStyle(DS.silver.opacity(0.5))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func iconWell(_ symbol: String, tone: Color) -> some View {
        let side: CGFloat = layout.value(34, 40)
        return Image(systemName: symbol)
            .font(.system(size: layout.value(14, 16), weight: .semibold))
            .foregroundStyle(tone)
            .frame(width: side, height: side)
            .background(Circle().fill(DS.surfaceRaised))
            .overlay(Circle().strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
            .accessibilityHidden(true)
    }

    private func footnote(_ text: String) -> some View {
        Text(text)
            .font(.ui(layout.value(11.5, 13)))
            .cssLineHeight(layout.value(11.5, 13), 1.45)
            .foregroundStyle(DS.silver.opacity(0.5))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 4)
    }
}

private extension View {
    /// Profile's settings card: 16pt corners and 14pt sides on iPhone, the
    /// tier's 20 and 18 on iPad.
    func settingsCard(_ layout: DSLayout) -> some View {
        padding(.horizontal, layout.value(14, 18))
            .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
    }
}

#Preview("Apple Health · iPhone") {
    NavigationStack {
        HealthSettingsView()
    }
    .environment(AppleHealth())
    .environment(WorkoutStore())
    .dsPreview(.phone)
}

#Preview("Apple Health · 13-inch landscape") {
    NavigationStack {
        HealthSettingsView()
    }
    .environment(AppleHealth())
    .environment(WorkoutStore())
    .dsPreview(.pad13Landscape1110)
}
