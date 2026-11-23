//
//  BalanceSettingsView.swift
//  GymWorkout
//
//  Profile › Settings › Balance (2026-11-22, owner-approved), pushed like
//  Apple Health: the card's look (bars, triangle or ring — the owner left
//  it to users) and whether it shows on Today, which parts are scored, the
//  training volume target, the Eat colour, the two Balance reminders (both
//  off until turned on), pausing this week, and how the score is worked
//  out, in plain words with its sources.
//
//  Everything here is a choice saved with the settings (`BalanceSettings`,
//  `DailyStore`); the score itself is worked out on the device each time
//  and never saved.
//
//  On iPad the sections sit in two columns once the content column reaches
//  700pt, as on Apple Health's screen: the look and what counts on the
//  left, reminders, this week and how it works on the right.
//

import SwiftUI

struct BalanceSettingsView: View {
    @Environment(DailyStore.self) private var daily
    @Environment(WorkoutStore.self) private var store
    @Environment(AppleHealth.self) private var health
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout
    @State private var showsDenied = false

    var body: some View {
        let columns = layout.containerWidth >= 700 ? 2 : 1
        let width: CGFloat = columns == 2 ? 1120 : 620
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                HistoryHeader(title: String(localized: "Balance"), meta: headerMeta,
                              maxWidth: width, onBack: { dismiss() })
                ScrollView(showsIndicators: false) {
                    // Source order is the one-column order.
                    DSColumns(columns: columns, spacing: 24, rowSpacing: 28) {
                        styleSection
                            .dsColumn(0)
                        countsSection
                            .dsColumn(0)
                        volumeSection
                            .dsColumn(0)
                        colorSection
                            .dsColumn(0)
                        remindersSection
                            .dsColumn(1)
                        weekSection
                            .dsColumn(1)
                        howSection
                            .dsColumn(1)
                    }
                    .dsReadable(width)
                    .dsGutter()
                    .padding(.top, 6)
                    .padding(.bottom, 32)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        // ⌘[ and Esc on an iPad keyboard.
        .dsBackShortcuts { dismiss() }
        .alert(String(localized: "Notifications are off"), isPresented: $showsDenied) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Turn on notifications for MUSQ in iOS Settings to get reminders.")
        }
    }

    /// "BARS · ON TODAY"
    private var headerMeta: String {
        let settings = BalanceSettings.shared
        return "\(settings.style.title) · \(Self.placement(settings.showsOnToday))".uppercased()
    }

    /// "On Today" or "Hidden", shared with Profile's row.
    static func placement(_ showsOnToday: Bool) -> String {
        showsOnToday ? String(localized: "On Today", comment: "Balance card: shown on Today")
                     : String(localized: "Hidden", comment: "Balance card: not shown on Today")
    }

    // MARK: - Card style

    /// The three looks side by side, each drawn small; a tap picks one and
    /// every Balance card follows at once. Showing it on Today sits under them.
    private var styleSection: some View {
        @Bindable var balance = BalanceSettings.shared
        return section("CARD STYLE") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: layout.value(12, 14)) {
                        rowText(String(localized: "Look", comment: "Balance settings: the card style row"),
                                detail: balance.style.detail)
                        HStack(spacing: 6) {
                            ForEach(BalanceStyle.allCases) { style in
                                styleSwatch(style, selected: balance.style == style) {
                                    withAnimation(.easeOut(duration: 0.2)) { balance.style = style }
                                }
                            }
                        }
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel(String(localized: "Card style"))
                    }
                    .padding(.vertical, layout.value(13, 16))

                    Hairline(opacity: 0.06)

                    Toggle(isOn: $balance.showsOnToday) {
                        rowText(String(localized: "Show on Today"),
                                detail: String(localized: "Your last 7 days of Train, Eat and Sleep as one card on Today."))
                    }
                    .tint(DS.silver)
                    .padding(.vertical, layout.value(13, 16))
                }
                .settingsCard(layout)

                // The card falls back to bars until all three are scored.
                footnote(String(localized: "Triangle and Ring show once Train, Eat and Sleep are all scored; until then the card uses bars."))
            }
        }
    }

    private func styleSwatch(_ style: BalanceStyle, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 7) {
                BalanceStyleSwatchGlyph(style: style)
                    .frame(height: 40)
                Text(style.title)
                    .font(.ui(layout.value(11, 12), .semibold))
                    .foregroundStyle(DS.silver.opacity(selected ? 1 : 0.55))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(DS.silver.opacity(selected ? 0.07 : 0)))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(DS.silver.opacity(selected ? 0.5 : 0.10), lineWidth: selected ? 1.5 : 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .dsHover()
        .accessibilityLabel(style.title)
        .accessibilityHint(style.detail)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    // MARK: - What counts

    private var countsSection: some View {
        @Bindable var balance = BalanceSettings.shared
        return section("WHAT COUNTS") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(spacing: 0) {
                    Toggle(isOn: $balance.scoresEat) {
                        rowText(String(localized: "Score eating"),
                                detail: String(localized: "Protein, eating against your plan and water, from your meal log or a two-tap evening check-in. Turn it off if you'd rather not track eating: Balance then uses Train and Sleep."))
                    }
                    .tint(DS.silver)
                    .padding(.vertical, layout.value(13, 16))

                    Hairline(opacity: 0.06)

                    Toggle(isOn: $balance.hidesCalories) {
                        rowText(String(localized: "Hide calorie numbers"),
                                detail: String(localized: "Eat scores protein and water only, and Balance shows no calorie numbers."))
                    }
                    .tint(DS.silver)
                    .padding(.vertical, layout.value(13, 16))
                    .disabled(!balance.scoresEat)
                    .opacity(balance.scoresEat ? 1 : 0.45)

                    Hairline(opacity: 0.06)

                    Toggle(isOn: $balance.scoresSleep) {
                        rowText(String(localized: "Score sleep"),
                                detail: String(localized: "Time asleep against your sleep goal, and how regular your sleep is. Turn it off if you work shifts or have a new baby: day sleep and broken nights can't be scored fairly."))
                    }
                    .tint(DS.silver)
                    .padding(.vertical, layout.value(13, 16))

                    Hairline(opacity: 0.06)

                    Toggle(isOn: $balance.estimatesSleep) {
                        rowText(String(localized: "Ask how I slept when there's no sleep data"),
                                detail: String(localized: "When Apple Health has no sleep for a night, a one-tap “Slept about…” asks instead. Estimates count a little less than measured nights."))
                    }
                    .tint(DS.silver)
                    .padding(.vertical, layout.value(13, 16))
                    .disabled(!balance.scoresSleep)
                    .opacity(balance.scoresSleep ? 1 : 0.45)
                }
                .settingsCard(layout)

                footnote(String(localized: "Balance shows a number once two parts are scored. A part that's off or not tracked yet is left out, never counted as zero."))
            }
        }
    }

    // MARK: - Training volume

    private var volumeSection: some View {
        section("TRAINING VOLUME") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(spacing: 0) {
                    volumeRow(.auto, detail: autoDetail)
                    Hairline(opacity: 0.06)
                    volumeRow(.maintain,
                              detail: String(localized: "6 sets a muscle a week: enough to keep muscle while you're busy or deep in a cut."))
                }
                .settingsCard(layout)

                footnote(String(localized: "The weekly sets each muscle group in your split aims for in Train's coverage. Each group counts only up to its target, so extra sets for one can't cover for another. Sources: Schoenfeld, Ogborn & Krieger 2017; Baz-Valle et al. 2022; Pelland et al. 2024; for maintenance, Bickel et al. 2011 and Spiering et al. 2021."))
            }
        }
    }

    /// "By your training experience: 6 … Yours: Intermediate, 10 sets."
    private var autoDetail: String {
        let base = String(localized: "By your training experience: 6 sets a muscle a week as a beginner, 10 intermediate, 12 advanced.")
        let experience = store.experience
        return base + " " + String(localized: "Yours: \(experience.title), \(Self.autoSets(experience)) sets.",
                                   comment: "Balance volume: the user's experience and its weekly set target, e.g. Yours: Intermediate, 10 sets.")
    }

    /// The same targets as `BalanceScore.volumeTarget` on Auto.
    private static func autoSets(_ experience: TrainingExperience) -> Int {
        switch experience {
        case .beginner: return 6
        case .intermediate: return 10
        case .advanced: return 12
        }
    }

    private func volumeRow(_ option: VolumeTarget, detail: String) -> some View {
        let selected = BalanceSettings.shared.volume == option
        return Button {
            withAnimation(.easeOut(duration: 0.2)) { BalanceSettings.shared.volume = option }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                rowText(option.title, detail: detail)
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: layout.value(19, 21), weight: .regular))
                    .foregroundStyle(DS.silver.opacity(selected ? 1 : 0.3))
                    .accessibilityHidden(true)
            }
            .padding(.vertical, layout.value(13, 16))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    // MARK: - Eat colour

    /// The Eat part's colour, a pick like steps and sleep on Apple Health's
    /// screen. Train stays the workout orange and Sleep follows the sleep colour.
    private var colorSection: some View {
        @Bindable var balance = BalanceSettings.shared
        return section("EAT COLOR") {
            toneRow(title: BalancePillar.eat.title,
                    detail: String(localized: "Eat in Balance, wherever it shows. Sleep uses your sleep colour from Apple Health's settings."),
                    symbol: "fork.knife", options: EatTone.allCases, selection: $balance.eatTone)
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

    // MARK: - Reminders

    /// Both off by default; turning one on asks for notifications the first
    /// time, as the water and weigh-in reminders do. The check-in one reads
    /// off, greyed with a note, while Score eating is off, as `DailyStore`
    /// then lays none; the user's choice and time are kept for when it's on.
    private var remindersSection: some View {
        let checkInAvailable = BalanceSettings.shared.scoresEat
        let checkInOn = daily.checkInReminder.isOn && checkInAvailable
        let anyOn = checkInOn || daily.bedtimeReminder.isOn
        let checkInDetail = checkInAvailable
            ? String(localized: "A nudge to answer two taps on how you ate: protein, and eating against your plan.")
            : String(localized: "Off while Score eating is off, since there's no check-in to answer. Turn Score eating on to use it.")
        return section("REMINDERS") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(spacing: 0) {
                    Toggle(isOn: Binding(get: { checkInOn }, set: { setCheckIn($0) })) {
                        rowText(String(localized: "Evening check-in"), detail: checkInDetail)
                    }
                    .tint(DS.silver)
                    .padding(.vertical, layout.value(13, 16))
                    .disabled(!checkInAvailable)
                    .opacity(checkInAvailable ? 1 : 0.45)
                    if checkInOn {
                        timeRow(selection: checkInTime, spoken: String(localized: "Check-in time"))
                    }

                    Hairline(opacity: 0.06)

                    Toggle(isOn: Binding(get: { daily.bedtimeReminder.isOn }, set: { setBedtime($0) })) {
                        rowText(String(localized: "Wind-down before bed"),
                                detail: String(localized: "A nudge to put the screen down and get to bed on time."))
                    }
                    .tint(DS.silver)
                    .padding(.vertical, layout.value(13, 16))
                    if daily.bedtimeReminder.isOn {
                        timeRow(selection: bedtimeTime, spoken: String(localized: "Wind-down time"))
                        bedtimeSuggestion
                    }
                }
                .settingsCard(layout)
                .animation(.easeOut(duration: 0.2), value: checkInOn)
                .animation(.easeOut(duration: 0.2), value: daily.bedtimeReminder.isOn)
                // Re-lays the reminders, so the check-in follows Eat at once.
                .onChange(of: checkInAvailable) { daily.refreshRemindersSoon() }

                if daily.notificationsDenied && anyOn {
                    footnote(String(localized: "Notifications are off for MUSQ in iOS Settings, so no reminders can arrive. Turn them on there."))
                } else {
                    footnote(String(localized: "Both are off until you turn them on, and each comes at most once a day, at the time you pick."))
                }
            }
        }
    }

    private func timeRow(selection: Binding<Date>, spoken: String) -> some View {
        DatePicker(selection: selection, displayedComponents: .hourAndMinute) {
            Text("Time", comment: "A reminder's time")
                .font(.ui(layout.value(13.5, 15)))
                .foregroundStyle(DS.silver.opacity(0.75))
        }
        .padding(.bottom, layout.value(12, 14))
        .accessibilityLabel(spoken)
        .transition(.opacity)
    }

    /// "Suggested 22:45: 7 h 45 before your usual 6:30 wake-up." and, when
    /// it differs from the time set, a way to take it.
    @ViewBuilder
    private var bedtimeSuggestion: some View {
        let suggestion = suggestedBedtime
        let bed = TodayView.time(suggestion.hour, suggestion.minute)
        let wake = TodayView.time(suggestion.wake / 60, suggestion.wake % 60)
        let length = HealthFormat.sleep(minutes: suggestion.sleep)
        let text = suggestion.measured
            ? String(localized: "Suggested \(bed): \(length) before your usual \(wake) wake-up.",
                     comment: "Wind-down reminder: Suggested 22:45: 7 h 45 before your usual 6:30 wake-up.")
            : String(localized: "Suggested \(bed): \(length) before a \(wake) wake-up.",
                     comment: "Wind-down reminder without sleep data: Suggested 22:45: 7 h 45 before a 6:30 wake-up.")
        let isSet = daily.bedtimeReminder.hour == suggestion.hour && daily.bedtimeReminder.minute == suggestion.minute
        HStack(alignment: .center, spacing: 10) {
            Text(text)
                .font(.ui(layout.value(12, 13.5)))
                .cssLineHeight(layout.value(12, 13.5), 1.4)
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            if !isSet {
                QuickChip(title: String(localized: "Use \(bed)", comment: "Sets the wind-down reminder to the suggested time")) {
                    var reminder = daily.bedtimeReminder
                    reminder.hour = suggestion.hour
                    reminder.minute = suggestion.minute
                    daily.bedtimeReminder = reminder
                }
                .dsHover()
            }
        }
        .padding(.bottom, layout.value(12, 14))
        .transition(.opacity)
    }

    /// The usual wake-up (the median of the last 7 measured nights, else
    /// 6:30) less the sleep goal (at least 7 h), rounded down to the quarter
    /// hour: the same rule as `BalanceScore.bedtime`, so the reminder and
    /// Balance's "Lights out by…" agree.
    private var suggestedBedtime: (hour: Int, minute: Int, wake: Int, sleep: Int, measured: Bool) {
        let calendar = Calendar.current
        let wakes = health.nights.suffix(7)
            .map { calendar.component(.hour, from: $0.end) * 60 + calendar.component(.minute, from: $0.end) }
            .sorted()
        let wake = wakes.isEmpty ? 6 * 60 + 30 : wakes[wakes.count / 2]
        let sleep = max(health.sleepGoalMinutes, 420)
        var bed = wake - sleep
        if bed < 0 { bed += 24 * 60 }
        bed = bed / 15 * 15
        return (bed / 60, bed % 60, wake, sleep, !wakes.isEmpty)
    }

    private var checkInTime: Binding<Date> {
        Binding(get: { Self.date(daily.checkInReminder.hour, daily.checkInReminder.minute) },
                set: { date in
                    let parts = Calendar.current.dateComponents([.hour, .minute], from: date)
                    var reminder = daily.checkInReminder
                    reminder.hour = parts.hour ?? reminder.hour
                    reminder.minute = parts.minute ?? reminder.minute
                    daily.checkInReminder = reminder
                })
    }

    private var bedtimeTime: Binding<Date> {
        Binding(get: { Self.date(daily.bedtimeReminder.hour, daily.bedtimeReminder.minute) },
                set: { date in
                    let parts = Calendar.current.dateComponents([.hour, .minute], from: date)
                    var reminder = daily.bedtimeReminder
                    reminder.hour = parts.hour ?? reminder.hour
                    reminder.minute = parts.minute ?? reminder.minute
                    daily.bedtimeReminder = reminder
                })
    }

    private static func date(_ hour: Int, _ minute: Int) -> Date {
        var parts = DateComponents()
        parts.hour = hour
        parts.minute = minute
        return Calendar.current.date(from: parts) ?? Date()
    }

    private func setCheckIn(_ isOn: Bool) {
        guard isOn else { daily.checkInReminder.isOn = false; return }
        Task {
            if await daily.requestNotifications() { daily.checkInReminder.isOn = true } else { showsDenied = true }
        }
    }

    /// The first time on (still at the default time), it starts at the
    /// suggested time; a time the user set is kept.
    private func setBedtime(_ isOn: Bool) {
        guard isOn else { daily.bedtimeReminder.isOn = false; return }
        Task {
            guard await daily.requestNotifications() else { showsDenied = true; return }
            var reminder = daily.bedtimeReminder
            let untouched = BedtimeReminder()
            if reminder.hour == untouched.hour && reminder.minute == untouched.minute {
                let suggestion = suggestedBedtime
                reminder.hour = suggestion.hour
                reminder.minute = suggestion.minute
            }
            reminder.isOn = true
            daily.bedtimeReminder = reminder
        }
    }

    // MARK: - This week

    /// The calendar week Balance's score and history use.
    private var thisWeek: DateInterval? {
        Calendar.current.dateInterval(of: .weekOfYear, for: Date())
    }

    private var weekSection: some View {
        let week = thisWeek
        let start = week?.start ?? Calendar.current.startOfDay(for: Date())
        return section("THIS WEEK") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(spacing: 0) {
                    Toggle(isOn: Binding(get: { daily.isPaused(week: start) },
                                         set: { daily.setPaused($0, week: start) })) {
                        rowText(String(localized: "Pause this week"), detail: weekRange(start))
                    }
                    .tint(DS.silver)
                    .padding(.vertical, layout.value(13, 16))
                }
                .settingsCard(layout)

                footnote(String(localized: "Sick, travelling or on a deload week? A paused week is left out of your score and out of the comparison of your weeks, and the card shows “Paused”. It ends with the week."))
            }
        }
    }

    /// "Nov 16 – 22"
    private func weekRange(_ start: Date) -> String {
        let last = Calendar.current.date(byAdding: .day, value: 6, to: start) ?? start
        return (start..<last).formatted(.interval.month(.abbreviated).day())
    }

    // MARK: - How it works

    private var howSection: some View {
        let full = max(health.sleepGoalMinutes - 60, 420)
        let fullText = HealthFormat.sleep(minutes: full)
        return section("HOW IT WORKS") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: layout.value(14, 16)) {
                    explainRow(BalancePillar.train.symbol, tone: BalanceTone.train,
                               title: BalancePillar.train.title,
                               text: String(localized: "Showing up counts 60%: the days you trained against your weekly goal. More sessions than planned earn nothing extra, since recovery counts too. Coverage counts 40%: each muscle group in your split toward its weekly sets (Training volume, above), and past 20 sets a week adds nothing."))
                    explainRow(BalancePillar.eat.symbol, tone: BalanceTone.eat,
                               title: BalancePillar.eat.title,
                               text: String(localized: "The average of the last 7 days with a meal log or a check-in: protein 45% (full at 90% of your plan's), calories 40% (full within 10% of your plan, nothing at 30% off or under a safe minimum) and water 15%; with calorie numbers hidden, calories are left out. A check-in counts hit 1, close 0.6 and missed 0.3 for protein, and about right 1, a bit off 0.6 and way off 0.2 for eating. Needs 4 days."))
                    explainRow(BalancePillar.sleep.symbol, tone: BalanceTone.sleep,
                               title: BalancePillar.sleep.title,
                               text: String(localized: "Nights count 80%: full from 7 h or your goal less an hour, whichever is more (for you, \(fullText)), falling to nothing 2½ h under it. Regularity counts 20%: how much the middle of your sleep moves, full at 30 minutes or less, nothing at 90 (from 5 measured nights). “Slept about…” estimates count a little less than measured nights. Needs 4 nights.",
                                            comment: "How Balance scores sleep. The interpolation is the full-credit length, e.g. 7 h"))
                    explainRow("sum", tone: DS.silver.opacity(0.8),
                               title: String(localized: "Balance"),
                               text: String(localized: "Half the average of the scored parts plus half the weakest, so lifting the weakest moves it most. It shows once two parts are scored: 80 and up is Strong, 65 On track, 45 Building, and under that Getting going. It rates what you do, never your results: your weight or key lifts sit beside it. Worked out on your \(DS.deviceNoun) each time and never saved. The weights and cut-offs are MUSQ's own."))
                }
                .padding(.vertical, layout.value(14, 18))
                .settingsCard(layout)

                footnote(String(localized: "Sources: Schoenfeld, Ogborn & Krieger 2017; Baz-Valle et al. 2022; Pelland et al. 2024 (training volume); Bickel et al. 2011 (keeping muscle); Nedeltcheva et al. 2010; Lamon et al. 2021 (sleep in a calorie deficit); Lauderdale et al. 2008 (estimated sleep)."))
            }
        }
    }

    private func explainRow(_ symbol: String, tone: Color, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: layout.value(14, 16), weight: .semibold))
                .foregroundStyle(tone)
                .frame(width: layout.value(22, 26))
                .padding(.top, 1)
                .accessibilityHidden(true)
            rowText(title, detail: text)
        }
        .accessibilityElement(children: .combine)
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

    private func footnote(_ text: String) -> some View {
        Text(text)
            .font(.ui(layout.value(11.5, 13)))
            .cssLineHeight(layout.value(11.5, 13), 1.45)
            .foregroundStyle(DS.silver.opacity(0.5))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 4)
    }
}

// MARK: - Style swatches

/// A small drawing of each Balance look, with sample values: the pillar
/// colours on the pillar marks only, the number silver.
private struct BalanceStyleSwatchGlyph: View {
    var style: BalanceStyle

    private static let values: [CGFloat] = [0.85, 0.55, 0.7]
    private var tones: [Color] { [BalanceTone.train, BalanceTone.eat, BalanceTone.sleep] }

    var body: some View {
        Group {
            switch style {
            case .bars:
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(0..<3, id: \.self) { index in
                        ZStack(alignment: .leading) {
                            Capsule().fill(DS.silver.opacity(0.12))
                            Capsule().fill(tones[index])
                                .frame(width: 40 * Self.values[index])
                        }
                        .frame(width: 40, height: 5)
                    }
                }
                .frame(width: 40, height: 40)
            case .triangle:
                ZStack {
                    BalanceSwatchTriangle(values: [1, 1, 1])
                        .stroke(DS.silver.opacity(0.22), lineWidth: 1)
                    BalanceSwatchTriangle(values: Self.values)
                        .fill(DS.silver.opacity(0.12))
                    BalanceSwatchTriangle(values: Self.values)
                        .stroke(DS.silver.opacity(0.6), style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
                    GeometryReader { proxy in
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(tones[index])
                                .frame(width: 6, height: 6)
                                .position(BalanceSwatchTriangle.corner(index, value: Self.values[index],
                                                                       in: CGRect(origin: .zero, size: proxy.size)))
                        }
                    }
                }
                .frame(width: 40, height: 34)
                .frame(height: 40)
            case .ring:
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        let start = (Double(index) * 120 + 8) / 360
                        let span = 104.0 / 360
                        Circle()
                            .trim(from: start, to: start + span)
                            .stroke(tones[index].opacity(0.22), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        Circle()
                            .trim(from: start, to: start + span * Double(Self.values[index]))
                            .stroke(tones[index], style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                    }
                    Text(verbatim: "68")
                        .font(.ui(11, .bold))
                        .monospacedDigit()
                        .foregroundStyle(DS.silver)
                }
                .frame(width: 34, height: 34)
                .frame(width: 40, height: 40)
            }
        }
        .accessibilityHidden(true)
    }
}

/// One corner per pillar — Train at the top, Eat lower right, Sleep lower
/// left — each pulled toward the middle by its value. Nonisolated, since
/// SwiftUI asks a shape for its path off the main actor.
nonisolated private struct BalanceSwatchTriangle: Shape {
    var values: [CGFloat]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for index in 0..<3 {
            let point = Self.corner(index, value: index < values.count ? values[index] : 1, in: rect)
            if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }

    /// The equilateral triangle that fits `rect`, its centre a radius below
    /// the top edge.
    static func corner(_ index: Int, value: CGFloat, in rect: CGRect) -> CGPoint {
        let radius: CGFloat = min(rect.width / CGFloat(3).squareRoot(), rect.height / 1.5)
        let angle: CGFloat = CGFloat(-90 + 120 * index) * .pi / 180
        let reach: CGFloat = radius * value
        return CGPoint(x: rect.midX + cos(angle) * reach,
                       y: rect.minY + radius + sin(angle) * reach)
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

#Preview("Balance · iPhone") {
    NavigationStack {
        BalanceSettingsView()
    }
    .environment(DailyStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("preview-daily.json")))
    .environment(WorkoutStore())
    .environment(AppleHealth())
    .dsPreview(.phone)
}

#Preview("Balance · 13-inch landscape") {
    NavigationStack {
        BalanceSettingsView()
    }
    .environment(DailyStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("preview-daily.json")))
    .environment(WorkoutStore())
    .environment(AppleHealth())
    .dsPreview(.pad13Landscape1110)
}
