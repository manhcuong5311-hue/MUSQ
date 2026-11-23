//
//  BalanceSheet.swift
//  GymWorkout
//
//  What's behind the Balance number (owner-approved 2026-11-22): the week
//  at a glance, the lever and its one action, the 3 × 7 habit grid, each
//  pillar's parts, the evidence notes, "Ask MUSQ how to improve", pausing
//  the week, and how Balance is worked out. Opened from the Balance card.
//
//  - Nothing here is saved but the pause and the check-ins the user makes.
//  - The question for MUSQ is shown in full before it goes anywhere, and
//    it carries sleep numbers (Apple Health) only while "Include my sleep"
//    is on — off each time the sheet opens. The chat opens with it filled
//    in; nothing is sent until the user taps Send there. A sent question
//    stays in the chat on the device (out of backups), and goes along as
//    context with the next questions in it, until the chat is cleared: the
//    toggle says so.
//  - The Eat and Sleep cards offer today's check-in or "Slept about…" at
//    any hour while today has none, scored or not, unless the lever card
//    above already offers it.
//  - Muted marks, never red, yellow or green: those mean recovery on Train.
//

import SwiftUI

struct BalanceSheet: View {
    let balance: Balance
    let goal: FitnessGoal?
    let onAction: (BalanceAction) -> Void
    /// Gets the final question text; nil hides the Ask MUSQ section.
    let onAskAI: ((String) -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout
    /// Optional, so the sheet still draws where a caller leaves them out:
    /// the pause and the in-sheet check-ins need the log.
    @Environment(DailyStore.self) private var daily: DailyStore?
    @Environment(AppleHealth.self) private var health: AppleHealth?
    @Environment(WorkoutStore.self) private var store: WorkoutStore?

    /// Off each time the sheet opens: sleep leaves the phone only in a
    /// question it was turned on for.
    @State private var includesSleep = false
    @State private var showsCheckIn = false
    @State private var showsSleepEstimate = false
    @State private var showsHowItWorks = false

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        summary(proxy)
                        lever
                        BalanceSheetCard {
                            TodayEyebrow(text: String(localized: "Last 7 days", comment: "Balance sheet: the habit grid's title"))
                            BalanceHabitGrid(balance: balance)
                                .padding(.top, 12)
                        }
                        ForEach(balance.pillars, id: \.pillar) { score in
                            pillarCard(score)
                        }
                        notes
                        if onAskAI != nil {
                            askCard
                                .id(Self.askID)
                        }
                        pauseCard
                        howItWorks
                        TodayFootnote()
                    }
                    .padding(.horizontal, layout.gutter)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                    .frame(maxWidth: 680)
                    .frame(maxWidth: .infinity)
                }
            }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Balance", comment: "Balance sheet title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
        }
        .tint(DS.silver)
        .sheet(isPresented: $showsCheckIn) {
            EatCheckInSheet()
                .environment(daily)
                .environment(store)
                .environment(health)
        }
        .sheet(isPresented: $showsSleepEstimate) {
            SleepEstimateSheet()
                .environment(daily)
        }
    }

    // MARK: Summary

    private var dates: String {
        let calendar = Calendar.current
        let last = calendar.date(byAdding: .day, value: -1, to: balance.window.end) ?? balance.window.end
        let format = Date.FormatStyle.dateTime.day().month(.abbreviated)
        return "\(balance.window.start.formatted(format)) – \(last.formatted(format))"
    }

    /// The Ask MUSQ section's id, for the shortcut in the summary.
    private static let askID = "balance.ask"

    private func summary(_ proxy: ScrollViewProxy) -> some View {
        BalanceSheetCard {
            HStack(alignment: .firstTextBaseline) {
                TodayEyebrow(text: dates)
                Spacer(minLength: 8)
                TodayEyebrow(text: balance.paused ? String(localized: "Paused", comment: "Balance: the week is left out")
                                                  : String(localized: "\(balance.coverage) tracked", comment: "Balance sheet: 2 of 3 tracked"),
                             size: 9.5, opacity: 0.45)
            }
            Group {
                if balance.paused {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Image(systemName: "pause.circle.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(DS.silver.opacity(0.6))
                                .accessibilityHidden(true)
                            Text("Paused", comment: "Balance: the week is left out")
                                .font(.ui(30, .bold))
                                .tracking(-0.6)
                                .foregroundStyle(DS.silver)
                        }
                        // The window is also paused when last week's pause
                        // still covers most of these 7 days (Mon–Wed after it).
                        Text(daily?.isPaused(week: Date()) == false
                             ? String(localized: "Last week's pause still covers most of these 7 days. Balance comes back in a day or two.")
                             : String(localized: "This week is left out of your Balance and of Your weeks in Progress. Turn the pause off below to count it again."))
                            .font(.ui(13.5))
                            .foregroundStyle(DS.silver.opacity(0.65))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } else if let score = balance.score, let word = balance.word {
                    HStack(alignment: .center, spacing: 14) {
                        BigValue(value: score.formatted(), size: layout.value(54, 60))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(word)
                                .font(.ui(19, .semibold))
                                .foregroundStyle(DS.silver)
                            Text("Half your average, half your weakest.")
                                .font(.ui(12.5))
                                .foregroundStyle(DS.silver.opacity(0.55))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(BalanceKit.spokenHeadline(balance))
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Track one more to see your Balance")
                            .font(.ui(20, .semibold))
                            .foregroundStyle(DS.silver)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Balance needs two of Train, Eat and Sleep scored. Each pillar below says what it still needs.")
                            .font(.ui(13.5))
                            .foregroundStyle(DS.silver.opacity(0.65))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
            .padding(.top, 10)
            if let result = balance.result {
                BalanceResultChip(result: result)
                    .padding(.top, 12)
            }
            if let goal, balance.result != nil {
                Text("Your goal: \(goal.title). The result sits beside Balance and never counts in it.",
                     comment: "Balance sheet: the goal under the result chip")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
            }
            if onAskAI != nil {
                QuickChip(title: String(localized: "Ask MUSQ how to improve", comment: "Balance sheet: jumps to the AI section"),
                          symbol: "sparkles") {
                    withAnimation(.easeInOut(duration: 0.3)) { proxy.scrollTo(Self.askID, anchor: .top) }
                }
                .padding(.top, 10)
                .accessibilityHint(String(localized: "Shows the question MUSQ would get, before anything is sent",
                                          comment: "Balance sheet, VoiceOver hint"))
            }
        }
    }

    // MARK: Lever

    /// The lowest pillar's one action; before there's a number, the step
    /// toward one.
    @ViewBuilder
    private var lever: some View {
        if !balance.paused, let action = balance.action {
            BalanceSheetCard {
                HStack(spacing: 6) {
                    Image(systemName: action.pillar.symbol)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(BalanceKit.color(action.pillar))
                        .accessibilityHidden(true)
                    TodayEyebrow(text: balance.lever != nil
                                 ? String(localized: "Your lever · \(action.pillar.title)", comment: "Balance sheet: Your lever · Sleep")
                                 : String(localized: "Next step", comment: "Balance sheet: the step toward a Balance"))
                }
                Text(action.text)
                    .font(.ui(17, .semibold))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
                if balance.lever != nil {
                    Text("Balance weighs your weakest pillar most, so lifting it moves your Balance the most.")
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 4)
                }
                if let title = action.buttonTitle {
                    WideButton(title: title, prominent: true, fontSize: 15, verticalPadding: 12, cornerRadius: 12) {
                        perform(action)
                    }
                    .dsCTA(alignment: .leading)
                    .padding(.top, 12)
                }
            }
        }
    }

    // MARK: Pillars

    /// A pillar's chip (`BalanceKit.invitation`, at any hour here), left out
    /// when the lever card already offers the same.
    private func offer(for score: PillarScore) -> BalanceAction? {
        let input = BalanceBuilder.todayInputs(store: store, daily: daily, health: health)
        guard let offer = BalanceKit.invitation(for: score, today: input, health: health) else { return nil }
        if !balance.paused, let action = balance.action, action.pillar == offer.pillar, action.kind == offer.kind {
            return nil
        }
        return offer
    }

    private func pillarCard(_ score: PillarScore) -> some View {
        let isLever = balance.lever == score.pillar
        let tone = BalanceKit.color(score.pillar)
        let invitation = offer(for: score)
        return BalanceSheetCard {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(systemName: score.pillar.symbol)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(score.isScored ? tone : DS.silver.opacity(0.5))
                    .accessibilityHidden(true)
                Text(score.pillar.title)
                    .font(.ui(18, .bold))
                    .foregroundStyle(DS.silver)
                    .accessibilityAddTraits(.isHeader)
                if isLever { BalanceLeverCapsule() }
                Spacer(minLength: 8)
                if let value = score.score {
                    BigValue(value: value.formatted(), unit: "/100", size: 22)
                }
            }
            BalanceTrack(score: score, height: 7)
                .padding(.top, 10)
            Text(BalanceKit.caption(score, paused: balance.paused))
                .font(.ui(13))
                .foregroundStyle(DS.silver.opacity(0.65))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)

            if let status = statusNote(score) {
                Text(status)
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 6)
            }

            if !score.parts.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(score.parts.enumerated()), id: \.offset) { _, part in
                        partRow(part)
                    }
                }
                .padding(.top, 12)
            }

            if let invitation, let title = invitation.buttonTitle {
                Hairline(opacity: 0.08)
                    .padding(.top, 12)
                HStack(alignment: .center, spacing: 10) {
                    Text(invitation.text)
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 6)
                    QuickChip(title: title) { perform(invitation) }
                }
                .padding(.top, 8)
            }
        }
    }

    /// Why a pillar has no score yet, in a line.
    private func statusNote(_ score: PillarScore) -> String? {
        if BalanceKit.isPausedTrain(score, paused: balance.paused) { return nil }
        switch score.status {
        case .scored:
            return nil
        case .off:
            // Eat still on in Settings but with nothing it may score: its
            // Note part says why; this says how to get it back.
            if score.pillar == .eat && BalanceSettings.shared.scoresEat {
                return String(localized: "Show calorie numbers again in Settings › Balance to score eating.")
            }
            return String(localized: "You turned this off in Settings › Balance, so it doesn't count.")
        case .needsMore(let have, let need):
            switch score.pillar {
            case .sleep:
                return String(localized: "Scores from \(need) nights in the 7 days; \(have) so far.",
                              comment: "Balance sheet: Sleep needs more nights")
            default:
                return String(localized: "Scores from \(need) days in the 7; \(have) so far.",
                              comment: "Balance sheet: Eat needs more days")
            }
        case .notTracked:
            switch score.pillar {
            case .eat:
                return String(localized: "Nothing to score yet: no meals logged and no evening check-ins in these 7 days.")
            case .sleep:
                return String(localized: "No sleep in these 7 days: Apple Health had none, and there are no estimates.")
            case .train:
                return nil
            }
        }
    }

    private func partRow(_ part: BalancePart) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(part.label)
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.6))
                Spacer(minLength: 8)
                Text(part.value)
                    .font(.ui(13.5, .semibold))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver)
                    .multilineTextAlignment(.trailing)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let detail = part.detail {
                Text(detail)
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }

    // MARK: Notes

    @ViewBuilder
    private var notes: some View {
        if !balance.notes.isEmpty {
            BalanceSheetCard {
                TodayEyebrow(text: String(localized: "Worth knowing", comment: "Balance sheet: evidence notes"))
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(balance.notes, id: \.self) { note in
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Image(systemName: "lightbulb")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(DS.silver.opacity(0.6))
                                .accessibilityHidden(true)
                            Text(note)
                                .font(.ui(13.5))
                                .foregroundStyle(DS.silver.opacity(0.85))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
    }

    // MARK: Ask MUSQ

    /// Sleep has something to share: Apple Health nights or estimates.
    private var hasSleep: Bool {
        switch balance.sleep.status {
        case .scored, .needsMore: return true
        case .notTracked, .off: return false
        }
    }

    private var question: String {
        BalanceScore.aiQuestion(balance, goal: goal, includeSleep: includesSleep && hasSleep)
    }

    private var askCard: some View {
        let question = self.question
        return BalanceSheetCard {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .accessibilityHidden(true)
                TodayEyebrow(text: String(localized: "Ask MUSQ how to improve", comment: "Balance sheet: AI section title"))
            }
            Text("MUSQ reads your three pillars and says what's missing in each, and how exactly to lift the weakest first.")
                .font(.ui(13.5))
                .foregroundStyle(DS.silver.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)

            if hasSleep {
                Toggle(isOn: $includesSleep) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Include my sleep (Apple Health)")
                            .font(.ui(15, .semibold))
                            .foregroundStyle(DS.silver)
                        Text(String(localized: "Off unless you turn it on. When it's on, your sleep numbers go with this question, and with your next ones in the chat, and stay in the chat on this \(DS.deviceNoun) until you clear it. Without it, the question says sleep isn't shared.",
                                    comment: "Balance sheet: under Include my sleep. The interpolation is iPhone or iPad"))
                            .font(.ui(12.5))
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .tint(DS.silver)
                .padding(.top, 12)
            }

            TodayEyebrow(text: String(localized: "What will be sent", comment: "Balance sheet: the full AI question"),
                         size: 9.5, opacity: 0.5)
                .padding(.top, 14)
            Text(question)
                .font(.ui(13))
                .foregroundStyle(DS.silver.opacity(0.85))
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(DS.surfaceDim))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
                .padding(.top, 6)
                .accessibilityLabel(String(localized: "The question: \(question)", comment: "Balance sheet, VoiceOver: the AI question"))

            WideButton(title: String(localized: "Ask MUSQ", comment: "Balance sheet: opens the chat with the question"),
                       prominent: false, fontSize: 15, verticalPadding: 12, cornerRadius: 12,
                       border: DS.silver.opacity(0.3)) {
                let text = question
                afterDismiss { onAskAI?(text) }
            }
            .dsCTA(alignment: .leading)
            .padding(.top, 12)
            Text("Opens the chat with this question filled in. Nothing is sent until you tap Send there.")
                .font(.ui(12))
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 6)
        }
    }

    // MARK: Pause

    @ViewBuilder
    private var pauseCard: some View {
        if let daily {
            let calendar = Calendar.current
            let week = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? calendar.startOfDay(for: Date())
            BalanceSheetCard {
                Toggle(isOn: Binding(get: { daily.isPaused(week: week) },
                                     set: { daily.setPaused($0, week: week) })) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pause this week")
                            .font(.ui(15, .semibold))
                            .foregroundStyle(DS.silver)
                        Text("Ill, travelling or on a deload? A paused week is left out of Balance and of Your weeks in Progress.")
                            .font(.ui(12.5))
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .tint(DS.silver)
            }
        }
    }

    // MARK: How it works

    private var howItWorks: some View {
        BalanceSheetCard {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { showsHowItWorks.toggle() }
            } label: {
                HStack {
                    TodayEyebrow(text: String(localized: "How Balance works", comment: "Balance sheet: explainer title"))
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .rotationEffect(.degrees(showsHowItWorks ? 180 : 0))
                }
                .frame(minHeight: 32)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityValue(showsHowItWorks ? String(localized: "Expanded") : String(localized: "Collapsed"))

            if showsHowItWorks {
                VStack(alignment: .leading, spacing: 12) {
                    explainer(nil, String(localized: "Balance is half the average of your scored pillars and half the weakest. Results need all three, so lifting the weakest moves it most. It shows once two of the three are scored, and it rates what you do, never the scale."))
                    explainer(.train, String(localized: "Showing up (60%): days trained against your weekly goal; more sessions never beat recovering. Coverage (40%): each muscle in your split, up to 6 effective sets a week for beginners, 10 intermediate, 12 advanced, or 6 on Maintain. Past about 20 sets earns nothing more."))
                    explainer(.eat, BalanceSettings.shared.hidesCalories
                              ? String(localized: "Protein against 90% of your plan's, and water, from your meal log or the evening check-in. Calories are hidden in your settings, so they don't count. Scores from 4 days.")
                              : String(localized: "Protein (45%) against 90% of your plan's, eating against your plan's calories (40%) and water (15%), from your meal log or the evening check-in. Scores from 4 days."))
                    explainer(.sleep, String(localized: "Nights long enough (80%), full from 7 h or an hour under your goal, and a steady sleep time (20%). From Apple Health, or your own estimates, which count a little less. Scores from 4 nights."))
                    explainer(nil, String(localized: "Strong 80+ · On track 65–79 · Building 45–64 · Getting going under 45. The weights and cut-offs are MUSQ's own, set from the research below; this is not a medical score."))
                    explainer(nil, String(localized: "Sources: Schoenfeld, Ogborn & Krieger 2017; Baz-Valle et al. 2022; Pelland et al. 2024; Bickel 2011 (training volume). Helms 2014 (protein in a cut). Nedeltcheva 2010; Lamon 2021; Spiegel 2004; Lauderdale 2008 (sleep)."))
                    // The Ask MUSQ clause only where that section is shown.
                    explainer(nil, onAskAI != nil
                              ? String(localized: "Worked out on this device each time and never saved. Sleep is read from Apple Health and stays on the device unless you include it in a question to MUSQ.")
                              : String(localized: "Worked out on this device each time and never saved. Sleep is read from Apple Health and stays on the device."))
                }
                .padding(.top, 8)
                .transition(.opacity)
            }
        }
    }

    private func explainer(_ pillar: BalancePillar?, _ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            if let pillar {
                Image(systemName: pillar.symbol)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(BalanceKit.color(pillar))
                    .frame(width: 16)
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 2) {
                if let pillar {
                    Text(pillar.title)
                        .font(.ui(13.5, .semibold))
                        .foregroundStyle(DS.silver)
                }
                Text(text)
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }

    // MARK: Actions

    /// Check-ins open on top of this sheet, which then shows the new
    /// numbers; starting a workout and asking MUSQ close it, and the caller
    /// switches tabs or opens the chat once it's gone; the rest (water, the
    /// bedtime reminder, connecting Health) go to the caller with the sheet
    /// still up.
    private func perform(_ action: BalanceAction) {
        switch action.kind {
        case .checkIn where daily != nil:
            showsCheckIn = true
        case .sleepEstimate where daily != nil:
            showsSleepEstimate = true
        case .startWorkout:
            afterDismiss { onAction(action) }
        case .none:
            break
        default:
            onAction(action)
        }
    }

    /// Closes the sheet and hands `work` to the caller, which runs what it
    /// presents once the sheet is gone (Today's `afterBalanceSheet`).
    private func afterDismiss(_ work: () -> Void) {
        dismiss()
        work()
    }
}

// MARK: - Pieces

/// A card on the sheet's ground.
struct BalanceSheetCard<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
    }
}

/// Seven days by three pillars, like the consistency grid: done in the
/// pillar's colour, part-way lighter, not done a muted grey, a planned rest
/// ringed (it counts as good), no data dashed. Never red.
struct BalanceHabitGrid: View {
    let balance: Balance

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let calendar = Calendar.current
        let days = BalanceScore.dayStarts(balance.window, calendar)
        let today = calendar.startOfDay(for: Date())
        let labelWidth = layout.value(CGFloat(66), 78)
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Color.clear.frame(width: labelWidth, height: 1)
                ForEach(days, id: \.self) { day in
                    Text(calendar.veryShortStandaloneWeekdaySymbols[calendar.component(.weekday, from: day) - 1])
                        .font(.mono(9, day == today ? .bold : .semibold))
                        .foregroundStyle(DS.silver.opacity(day == today ? 0.9 : 0.45))
                        .frame(maxWidth: .infinity)
                }
            }
            .accessibilityHidden(true)

            ForEach(balance.pillars, id: \.pillar) { score in
                let tone = BalanceKit.color(score.pillar)
                HStack(spacing: 6) {
                    HStack(spacing: 5) {
                        Image(systemName: score.pillar.symbol)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(tone)
                        Text(score.pillar.title)
                            .font(.ui(12.5, .semibold))
                            .foregroundStyle(DS.silver.opacity(0.85))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(width: labelWidth, alignment: .leading)
                    ForEach(Array(days.enumerated()), id: \.offset) { index, _ in
                        cell(index < score.marks.count ? score.marks[index] : .noData, tone: tone)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(spoken(score, days: days))
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) { legendItems(0..<Self.legendMarks.count) }
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 12) { legendItems(0..<3) }
                    HStack(spacing: 12) { legendItems(3..<5) }
                }
            }
            .padding(.top, 4)
            .accessibilityHidden(true)
        }
    }

    private func cell(_ mark: BalanceMark, tone: Color) -> some View {
        let shape = RoundedRectangle(cornerRadius: 4, style: .continuous)
        return ZStack {
            switch mark {
            case .full:
                shape.fill(tone)
            case .half:
                shape.fill(tone.opacity(0.42))
            case .empty:
                shape.fill(DS.silver.opacity(0.08))
            case .rest:
                shape.fill(DS.silver.opacity(0.03))
                shape.strokeBorder(tone.opacity(0.55), lineWidth: 1.5)
            case .noData:
                shape.strokeBorder(DS.silver.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: 34)
        .frame(maxWidth: .infinity)
    }

    // MARK: Legend

    private static let legendMarks: [BalanceMark] = [.full, .half, .empty, .rest, .noData]

    private func legendItems(_ range: Range<Int>) -> some View {
        ForEach(Array(Self.legendMarks[range].enumerated()), id: \.offset) { _, mark in
            HStack(spacing: 5) {
                cellSample(mark)
                Text(Self.word(mark))
                    .font(.ui(11))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .lineLimit(1)
                    .fixedSize()
            }
        }
    }

    private func cellSample(_ mark: BalanceMark) -> some View {
        let shape = RoundedRectangle(cornerRadius: 2, style: .continuous)
        return ZStack {
            switch mark {
            case .full: shape.fill(DS.silver.opacity(0.85))
            case .half: shape.fill(DS.silver.opacity(0.4))
            case .empty: shape.fill(DS.silver.opacity(0.08))
            case .rest: shape.strokeBorder(DS.silver.opacity(0.55), lineWidth: 1.2)
            case .noData: shape.strokeBorder(DS.silver.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [1.5, 1.5]))
            }
        }
        .frame(width: 9, height: 9)
    }

    static func word(_ mark: BalanceMark) -> String {
        switch mark {
        case .full: return String(localized: "Done", comment: "Balance habit grid: a day the habit was done")
        case .half: return String(localized: "Partly", comment: "Balance habit grid: a day part-way")
        case .empty: return String(localized: "Not done", comment: "Balance habit grid")
        case .rest: return String(localized: "Rest day", comment: "Balance habit grid: a planned rest day")
        case .noData: return String(localized: "No data", comment: "Balance habit grid")
        }
    }

    /// "Train: Monday done, Tuesday rest day, …"
    private func spoken(_ score: PillarScore, days: [Date]) -> String {
        let items = days.enumerated().map { index, day in
            let mark = index < score.marks.count ? score.marks[index] : .noData
            return "\(day.formatted(.dateTime.weekday(.wide))) \(Self.word(mark).lowercased())"
        }
        return "\(score.pillar.title): \(items.joined(separator: ", "))"
    }
}
