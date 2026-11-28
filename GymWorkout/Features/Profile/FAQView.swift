//
//  FAQView.swift
//  GymWorkout
//
//  Help & FAQ, pushed from Profile: the questions people ask about Premium,
//  billing, recovery, the card colours, Balance and the quick logs, their
//  data, Apple Health and ads, each opening in place, and a way to write to
//  support. Prices and trial length are read
//  from the App Store products, so the answers can't drift from them.
//
//  On a wide iPad the sections get a rail of their own beside the answers:
//  the title, a jump to each section with the one in view lit, and the
//  contact card held at the foot.
//

import HealthKit
import SwiftUI

struct FAQView: View {
    @Environment(Purchases.self) private var purchases
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(\.dsLayout) private var layout
    @State private var open: Set<String> = []
    /// Wide only: the section lit in the rail — the one tapped, or the one
    /// reading at the top of the answers as they're scrolled.
    @State private var currentSection: String?
    /// Wide only: each section's top in the answers pane, for the rail.
    @State private var sectionTops: [String: CGFloat] = [:]
    @State private var paneHeight: CGFloat = 0
    @State private var isScrolledToEnd = false
    /// A drag or fling is moving the answers, as opposed to a jump from the
    /// rail; only then does the scroll position choose the lit section.
    @State private var isUserScrolling = false

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            if layout.isWide {
                widePage
            } else {
                VStack(spacing: 0) {
                    HistoryHeader(title: String(localized: "Help & FAQ"), meta: "MUSQ", onBack: { dismiss() })
                        // Shares the column below, so the back button sits on
                        // the content's leading edge. Nil bounds on iPhone.
                        .frame(maxWidth: layout.isRegular ? columnWidth : nil)
                        .frame(maxWidth: layout.isRegular ? .infinity : nil)
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 28) {
                            ForEach(sections, id: \.title) { section in
                                sectionCard(section)
                            }
                            contact
                        }
                        .padding(.horizontal, layout.gutter)
                        .frame(maxWidth: layout.isRegular ? columnWidth : nil)
                        .frame(maxWidth: layout.isRegular ? .infinity : nil)
                        .padding(.top, 6)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        // ⌘[ and Esc on an iPad keyboard, at every width.
        .dsBackShortcuts { dismiss() }
    }

    /// The readable column with its gutters.
    private var columnWidth: CGFloat { DS.Layout.columnWidth + 2 * layout.gutter }

    // MARK: - Wide

    private static let pane = "faq.answers"

    private var widePage: some View {
        VStack(alignment: .leading, spacing: 0) {
            CircleIconButton(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel("Back")
            .padding(.top, 11)
            .padding(.bottom, 14)

            ScrollViewReader { proxy in
                HStack(alignment: .top, spacing: 40) {
                    // Scrolls only when a short window can't hold it.
                    ViewThatFits(in: .vertical) {
                        rail(proxy)
                        ScrollView(showsIndicators: false) { rail(proxy) }
                    }
                    .frame(width: 300)

                    answers
                }
            }
        }
        .frame(maxWidth: 1020)
        .padding(.horizontal, layout.gutter)
        .frame(maxWidth: .infinity)
    }

    private func rail(_ proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Help & FAQ")
                .font(.ui(layout.text(.largeTitle), .semibold))
                .tracking(layout.largeTitleTracking)
                .foregroundStyle(DS.silver)
            MetaLine(text: "MUSQ")
                .padding(.top, 6)
            Text("Premium and billing, how recovery is estimated, and what happens to your data. Tap a question to open its answer.")
                .font(.ui(15))
                .cssLineHeight(15, 1.5)
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 14)

            VStack(spacing: 4) {
                ForEach(sections, id: \.title) { section in
                    jumpRow(section, proxy: proxy)
                }
            }
            .padding(.top, 26)

            Spacer(minLength: 28)

            contact
                .padding(.bottom, 24)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private func jumpRow(_ section: FAQSection, proxy: ScrollViewProxy) -> some View {
        let isCurrent = (currentSection ?? sections.first?.title) == section.title
        return Button {
            currentSection = section.title
            withAnimation(.easeInOut(duration: 0.35)) {
                proxy.scrollTo(section.title, anchor: .top)
            }
        } label: {
            Text("\(section.title) · \(section.items.count)")
                .font(.mono(11, .semibold))
                .trackingEm(0.08, size: 11)
                .foregroundStyle(DS.silver.opacity(isCurrent ? 1 : 0.5))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 13)
                .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsSelected(isCurrent, radius: 12)
        .dsHover(.highlight, radius: 12)
        .accessibilityAddTraits(isCurrent ? .isSelected : [])
        .animation(.easeOut(duration: 0.2), value: isCurrent)
    }

    /// The answers, scrolling on their own beside the rail.
    private var answers: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                ForEach(sections, id: \.title) { section in
                    sectionCard(section)
                        .id(section.title)
                        .onGeometryChange(for: CGFloat.self) {
                            $0.frame(in: .named(Self.pane)).minY
                        } action: { top in
                            sectionTops[section.title] = top
                            followScroll()
                        }
                }
            }
            .frame(maxWidth: 680, alignment: .leading)
            // Lines the first eyebrow up with the rail's title.
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .coordinateSpace(.named(Self.pane))
        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { paneHeight = $0 }
        .onScrollGeometryChange(for: Bool.self) { geo in
            geo.contentSize.height > geo.containerSize.height + 1
                && geo.visibleRect.maxY >= geo.contentSize.height - 2
        } action: { _, atEnd in
            isScrolledToEnd = atEnd
            followScroll()
        }
        .onScrollPhaseChange { _, phase in
            isUserScrolling = phase == .interacting || phase == .decelerating
        }
    }

    /// Lights the section reading at the top third of the pane — or the last
    /// one, once the pane can't scroll any further to bring it up there.
    private func followScroll() {
        guard isUserScrolling else { return }
        if isScrolledToEnd {
            currentSection = sections.last?.title
            return
        }
        let line = paneHeight * 0.3
        var current = sections.first?.title
        for section in sections where (sectionTops[section.title] ?? .infinity) <= line {
            current = section.title
        }
        currentSection = current
    }

    // MARK: - Rows

    private func sectionCard(_ section: FAQSection) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: section.title)
            VStack(spacing: 0) {
                ForEach(section.items, id: \.question) { item in
                    row(item)
                    if item.question != section.items.last?.question {
                        Hairline(opacity: 0.06)
                    }
                }
            }
            .padding(.horizontal, layout.value(14, 18))
            .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
        }
    }

    private func row(_ item: FAQItem) -> some View {
        let isOpen = open.contains(item.question)
        let answerSize: CGFloat = layout.value(13, 15)
        return VStack(alignment: .leading, spacing: layout.value(8, 10)) {
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    if isOpen { open.remove(item.question) } else { open.insert(item.question) }
                }
            } label: {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(item.question)
                        .font(.ui(layout.value(14.5, 16), .semibold))
                        .foregroundStyle(DS.silver)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.down")
                        .font(.system(size: layout.value(11, 12), weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.4))
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .modifier(QuestionHover())
            .accessibilityHint(isOpen ? "Hides the answer" : "Shows the answer")

            if isOpen {
                Text(item.answer)
                    .font(.ui(answerSize))
                    .cssLineHeight(answerSize, layout.value(1.5, 1.55))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
            }
        }
        .padding(.vertical, layout.value(13, 16))
    }

    private var contact: some View {
        let textSize: CGFloat = layout.value(13, 14.5)
        return VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: String(localized: "STILL STUCK?"))
            VStack(alignment: .leading, spacing: 12) {
                Text("Write to us and we'll get back to you, usually within two working days.")
                    .font(.ui(textSize))
                    .cssLineHeight(textSize, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                Button {
                    openURL(AppLinks.supportMail)
                } label: {
                    Label(AppLinks.supportEmail, systemImage: "envelope")
                        .font(.ui(layout.value(14, 15), .semibold))
                        .foregroundStyle(DS.silver)
                }
                .buttonStyle(.plain)
                .dsHover()
                Link("Support website", destination: AppLinks.support)
                    .font(.ui(layout.value(12, 13), .semibold))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .dsHover()
                // Solar icons are CC BY 4.0: the credit has to ship with them.
                Link("Icons: Solar by 480 Design (CC BY 4.0)",
                     destination: URL(string: "https://github.com/480-Design/Solar-Icon-Set")!)
                    .font(.ui(layout.value(11, 12)))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
            .padding(layout.value(14, 18))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
        }
    }

    // MARK: - Content

    /// The plans answer's first sentence while there's a trial to offer. A
    /// whole sentence of its own for translation; the space after it isn't.
    private var trial: String {
        // Builds with Pro have two yearly plans, each with its own trial
        // (read from App Store Connect), and one trial per Apple Account
        // across the group.
        if AIService.isLive {
            let premium = purchases.yearly.flatMap(Purchases.freeTrialLength(of:))
            let pro = purchases.proYearly.flatMap(Purchases.freeTrialLength(of:))
            switch (premium, pro) {
            case let (premium?, pro?):
                return String(localized: "Premium Yearly starts with a \(premium) free trial and Pro Yearly with a \(pro) one. Each Apple Account can have one of them.") + " "
            case let (premium?, nil):
                return String(localized: "Premium Yearly starts with a \(premium) free trial for Apple Accounts that haven't had one.") + " "
            case let (nil, pro?):
                return String(localized: "Pro Yearly starts with a \(pro) free trial for Apple Accounts that haven't had one.") + " "
            case (nil, nil):
                return ""
            }
        }
        return purchases.yearlyOffersFreeTrial
            ? String(localized: "The yearly plan starts with a \(purchases.trialLength) free trial for Apple Accounts that haven't had one.") + " "
            : ""
    }

    /// What's free and what Premium adds, in builds without the AI features.
    private var freeAndPremium: String {
        String(localized: "Every exercise, its 3D model, setup and key tips, the workout log, history, recovery and Preset 1 are free. MUSQ Premium adds the common mistakes drawn over the lifter, Preset 2 and 3 for every muscle group, and removes ads.")
    }

    /// What's free, Premium and Pro, in builds with the AI features: the
    /// allowances come from `Purchases.Tier.ai`, which mirrors the server,
    /// and Free's one goal photo is `AILimits.freeGoalPhotos`. Without the
    /// allowances it falls back to the answer above rather than none.
    private var aiTiers: String {
        guard let premium = Purchases.Tier.premium.ai, let pro = Purchases.Tier.pro.ai,
              let premiumPhotos = premium.goalPhotosPerYear, let proPhotos = pro.goalPhotosPerYear else { return freeAndPremium }
        // Free's chat questions: `AILimits.freeChatPerDay` (2026-11-27). Every
        // goal photo can be made again twice free (`GoalPhotoRedo.perPhoto`).
        return String(localized: "Every exercise, its 3D model, setup and key tips, the workout log, history, recovery and Preset 1 are free, and so are \(Purchases.AILimits.freeChatPerDay) questions a day to Ask MUSQ, the AI coach, and your first goal photo (for adults). MUSQ Premium adds the common mistakes drawn over the lifter, Preset 2 and 3 for every muscle group and no ads, plus up to \(premium.chatPerDay) questions a day and \(premiumPhotos) goal photos a year. MUSQ Pro has everything in Premium, with up to \(pro.chatPerDay) questions a day, meal scans that log a meal's calories from a photo (up to \(pro.mealScansPerDay) a day) and \(proPhotos) goal photos a year. If you don't like a goal photo, you can make it again \(GoalPhotoRedo.perPhoto) times without using another one.",
                      comment: "Help & FAQ, what's free: free questions a day, Premium's questions a day and goal photos a year, then Pro's questions a day, meal scans a day and goal photos a year, then the free redos of a goal photo")
    }

    /// Apple Health (phase 2, 2026-11-22): what's read, how it moves the
    /// calories, and how to stop it. Left out where there's no Health, like
    /// Profile's row; the numbers come from `MeasuredActivity`.
    private var appleHealthItems: [FAQItem] {
        guard HKHealthStore.isHealthDataAvailable() else { return [] }
        let window = MeasuredActivity.windowDays.formatted()
        let days = MeasuredActivity.minimumDays.formatted()
        return [
            FAQItem(question: String(localized: "What does MUSQ read from Apple Health, and how do I turn it off?"),
                    // The AI coach is named only in builds that have it,
                    // with the one way sleep reaches it (a Balance question
                    // the user includes it in, kept in the chat until
                    // cleared). What's saved follows `AppleHealth`: the goals
                    // and the switch always, the step band only while the
                    // switch is on.
                    answer: AIService.isLive
                        ? String(localized: "Once you connect it in Profile › Settings › Apple Health, MUSQ reads your steps, walking distance, active energy, sleep and workouts, and never writes to Health. Steps and last night's sleep show on Today, with their trends in Progress. Your average steps over the last \(window) full days (at least \(days) needed) set how active your days are in the calorie plan, in place of your answer to the daily-activity question; steps during your logged MUSQ workouts don't count, since your training days already do. You can stop steps setting the plan on the same screen. Active energy is shown beside your calorie target but never added to it. What MUSQ reads stays on your \(DS.deviceNoun): the readings are never saved, and never sent to MUSQ or advertisers. The one exception is yours to make: sleep is never sent to the AI coach unless you choose to include it in a question about your Balance; it then goes, through MUSQ's server and OpenAI, with that question and the next ones in the chat, and stays in the chat on your \(DS.deviceNoun), never in backups, until you clear it. Only your step and sleep goals and the calorie-plan switch are kept with your settings, plus, while your steps set the plan, the activity level they last set. To stop MUSQ reading Apple Health, go to Settings › Privacy & Security › Health › MUSQ (or in the Health app, tap your picture › Apps › MUSQ).")
                        : String(localized: "Once you connect it in Profile › Settings › Apple Health, MUSQ reads your steps, walking distance, active energy, sleep and workouts, and never writes to Health. Steps and last night's sleep show on Today, with their trends in Progress. Your average steps over the last \(window) full days (at least \(days) needed) set how active your days are in the calorie plan, in place of your answer to the daily-activity question; steps during your logged MUSQ workouts don't count, since your training days already do. You can stop steps setting the plan on the same screen. Active energy is shown beside your calorie target but never added to it. What MUSQ reads stays on your \(DS.deviceNoun): the readings are never saved, and never sent to MUSQ or advertisers. Only your step and sleep goals and the calorie-plan switch are kept with your settings, plus, while your steps set the plan, the activity level they last set. To stop MUSQ reading Apple Health, go to Settings › Privacy & Security › Health › MUSQ (or in the Health app, tap your picture › Apps › MUSQ).")),
        ]
    }

    private var sections: [FAQSection] {
        // Apple Health's answer joins the data section where there's Health.
        let data: [FAQItem] = [
            FAQItem(question: String(localized: "Where is my workout data kept?"),
                    // The AI features send what they need, with consent,
                    // so the answer changes in builds where they're live.
                    answer: AIService.isLive
                        ? String(localized: "On your \(DS.deviceNoun). MUSQ doesn't upload your workouts or keep them on a server. The optional AI features (the goal photo, the coach and meal scans) are the exception: when you use one, what it needs goes to MUSQ's server and OpenAI, and you're asked first. Signing in with Apple is needed only for them. Deleting the app deletes your workouts, so keep it installed (or back up your \(DS.deviceNoun)) to keep your history.")
                        : String(localized: "On your \(DS.deviceNoun) only. MUSQ has no account and doesn't upload your workouts. Deleting the app deletes them, so keep it installed (or back up your \(DS.deviceNoun)) to keep your history.")),
        ] + appleHealthItems + [
            FAQItem(question: String(localized: "Why do I see ads, and how do I change my ad choices?"),
                    answer: String(localized: "Ads keep the free version free; no full-screen ad appears mid-workout. Premium removes them. Where the law requires a choice, you can change it any time from Profile › Privacy Choices, and tracking follows your answer to Apple's tracking prompt (Settings › Privacy & Security › Tracking).")),
        ]
        return [
            FAQSection(title: String(localized: "PREMIUM & BILLING"), items: [
                FAQItem(question: String(localized: "What's free, and what does Premium add?"),
                        // Builds with the AI features name them, with what Premium includes.
                        answer: AIService.isLive ? aiTiers : freeAndPremium),
                FAQItem(question: String(localized: "What plans are there?"),
                        answer: trial + (AIService.isLive
                            ? String(localized: "Premium comes as a yearly subscription. Pro, with more of the AI features, comes as a monthly or yearly subscription. Prices are shown in your local currency on the Premium screen before you pay.")
                            : String(localized: "Premium comes as a yearly subscription. Prices are shown in your local currency on the Premium screen before you pay."))),
                FAQItem(question: String(localized: "How do I cancel my subscription?"),
                        answer: String(localized: "Open the Settings app on your \(DS.deviceNoun), tap your name, then Subscriptions, choose MUSQ and tap Cancel Subscription. Cancel at least 24 hours before the renewal date to avoid being charged; your plan stays on until the end of the period you've paid for. Cancelling during a free trial ends it without charge.")),
                FAQItem(question: String(localized: "How do I get a refund?"),
                        answer: String(localized: "Payments are handled by Apple. Request a refund at reportaproblem.apple.com, signed in with the Apple Account you paid with.")),
                FAQItem(question: String(localized: "I paid, but my plan isn't on. What do I do?"),
                        answer: String(localized: "Open the Premium screen from Profile and tap Restore Purchases, signed in with the Apple Account you paid with. This also brings your plan to a new iPhone or iPad. If it still doesn't show, write to us below.")),
            ]),
            FAQSection(title: String(localized: "TRAINING", comment: "Help & FAQ section"), items: [
                FAQItem(question: String(localized: "How is recovery estimated?"),
                        answer: String(localized: "Each completed set loads the muscles the exercise works, directly or as a helper. How long a muscle needs depends on how many sets it took and your training experience (Profile › Settings). The estimates are a guide, not medical advice: if you're still sore or something hurts, rest longer.")),
                FAQItem(question: String(localized: "What do the red, yellow and green card edges mean?"),
                        answer: String(localized: "Red: the group is still recovering. Yellow: trained this round and recovered. Green: not trained yet this round, so it's due. In Profile › Train Card Colors you can choose when green starts over (after your full split or each week), change the colours, or turn the edges off.")),
                FAQItem(question: String(localized: "Which sets count?"),
                        answer: String(localized: "Only sets you mark done. Planned but unfinished sets never count toward recovery, records or history.")),
                FAQItem(question: String(localized: "Can I change my split or goal?"),
                        answer: String(localized: "Yes. Tap Edit next to About You in Profile to change your goal, days a week and split. Your workout history stays as it is.")),
            ]),
            FAQSection(title: String(localized: "BALANCE & LOGGING", comment: "Help & FAQ section"), items: balanceItems),
            FAQSection(title: String(localized: "DATA, ADS & PRIVACY"), items: data),
        ]
    }

    /// Balance and the quick logs (2026-11-22): what the score is, voice
    /// logging, and walks added by hand. The coach is named only in builds
    /// that have it.
    private var balanceItems: [FAQItem] {
        let balance = String(localized: "One picture of your last 7 days in three parts. Train: showing up on your training days, and enough weekly sets for each muscle in your split. Eat: protein, eating against your plan and water, from your meal log or a two-tap evening check-in. Sleep: time asleep against your goal and how regular it is, from Apple Health or your own “Slept about…”. Balance is half the average of the parts it can score plus half the weakest, so lifting the weakest moves it most. It shows once two parts are scored, and a part with no data shows as not tracked, never as zero. The weakest part is your lever, with one thing to do today. It rates what you do, not your results: your weight or key lifts sit beside it. In Profile › Settings › Balance you can pick its look, stop scoring eating or sleep, hide calorie numbers, turn on its reminders, and pause a week of illness, travel or a deload. The score is worked out on your \(DS.deviceNoun) and never saved.")
        let askCoach = String(localized: "If you ask MUSQ's coach how to improve it, the question and your numbers are put in the chat box for you to read and edit before you send. Your sleep numbers go only if you choose to include them, and then stay in the chat on your \(DS.deviceNoun), never in backups, until you clear it.")
        return [
            FAQItem(question: String(localized: "What is Balance?"),
                    answer: AIService.isLive ? balance + " " + askCoach : balance),
            FAQItem(question: String(localized: "How does logging by voice work?"),
                    answer: String(localized: "In a quick log on Today (water, a walk or food), say what you had, like “500 ml water”, “walked 30 minutes” or “chicken rice 650 kcal”. On iOS 26 and later, tap the microphone: your \(DS.deviceNoun) turns your words into text on the device. On earlier versions, use the microphone on the keyboard to dictate, or type. You see what MUSQ read before anything is logged. MUSQ never records, keeps or sends the audio; keyboard dictation is Apple's own and follows your dictation settings.")),
            FAQItem(question: String(localized: "Can I add a walk by hand?"),
                    answer: String(localized: "Yes, for a walk without your phone or Watch: in a quick log on Today, add it under Walk, in minutes or steps (a minute counts as about 100 steps). It's kept in MUSQ with your other logs and never written to Apple Health. It counts with your steps on Today and in Progress, and in the step average for your calorie plan when your steps set it.")),
        ]
    }
}

/// Pointer hover on a question, drawn a little past its text so it reads as
/// the row rather than a box hugging the words. Nothing on iPhone.
private struct QuestionHover: ViewModifier {
    func body(content: Content) -> some View {
        if DS.isPad {
            content
                .contentShape(.hoverEffect, RoundedRectangle(cornerRadius: 12, style: .continuous).inset(by: -10))
                .hoverEffect(.highlight)
        } else {
            content
        }
    }
}

private struct FAQSection {
    var title: String
    var items: [FAQItem]
}

private struct FAQItem {
    var question: String
    var answer: String
}

#Preview("FAQ · 11-inch portrait") {
    FAQView()
        .environment(Purchases())
        .dsPreview(.pad11Portrait750)
}

#Preview("FAQ · 13-inch landscape") {
    FAQView()
        .environment(Purchases())
        .dsPreview(.pad13Landscape1110)
}
