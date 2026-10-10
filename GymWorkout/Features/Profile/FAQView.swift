//
//  FAQView.swift
//  GymWorkout
//
//  Help & FAQ, pushed from Profile: the questions people ask about Premium,
//  billing, recovery, the card colours, their data and ads, each opening in
//  place, and a way to write to support. Prices and trial length are read
//  from the App Store products, so the answers can't drift from them.
//
//  On a wide iPad the sections get a rail of their own beside the answers:
//  the title, a jump to each section with the one in view lit, and the
//  contact card held at the foot.
//

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
                    HistoryHeader(title: "Help & FAQ", meta: "MUSQ", onBack: { dismiss() })
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
            SectionEyebrow(text: "STILL STUCK?")
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
            }
            .padding(layout.value(14, 18))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: layout.cardRadius, style: .continuous).fill(DS.surfaceAlt))
        }
    }

    // MARK: - Content

    private var trial: String {
        purchases.yearlyOffersFreeTrial
            ? "The yearly plan starts with a \(purchases.trialLength) free trial for Apple Accounts that haven't had one. "
            : ""
    }

    private var sections: [FAQSection] {
        [
            FAQSection(title: "PREMIUM & BILLING", items: [
                FAQItem(question: "What's free, and what does Premium add?",
                        answer: "Every exercise, its 3D model, setup and key tips, the workout log, history, recovery and Preset 1 are free. MUSQ Premium adds the common mistakes drawn over the lifter, Preset 2 and 3 for every muscle group, and removes ads."),
                FAQItem(question: "What plans are there?",
                        answer: "\(trial)Premium comes as a yearly subscription or a one-time lifetime purchase. Prices are shown in your local currency on the Premium screen before you pay."),
                FAQItem(question: "How do I cancel my subscription?",
                        answer: "Open the Settings app on your \(DS.deviceNoun), tap your name, then Subscriptions, choose MUSQ and tap Cancel Subscription. Cancel at least 24 hours before the renewal date to avoid being charged; Premium stays on until the end of the period you've paid for. Cancelling during a free trial ends it without charge."),
                FAQItem(question: "How do I get a refund?",
                        answer: "Payments are handled by Apple. Request a refund at reportaproblem.apple.com, signed in with the Apple Account you paid with."),
                FAQItem(question: "I paid, but Premium isn't on. What do I do?",
                        answer: "Open the Premium screen from Profile and tap Restore Purchases, signed in with the Apple Account you paid with. This also brings Premium to a new iPhone or iPad. If it still doesn't show, write to us below."),
            ]),
            FAQSection(title: "TRAINING", items: [
                FAQItem(question: "How is recovery estimated?",
                        answer: "Each completed set loads the muscles the exercise works, directly or as a helper. How long a muscle needs depends on how many sets it took and your training experience (Profile › Settings). The estimates are a guide, not medical advice: if you're still sore or something hurts, rest longer."),
                FAQItem(question: "What do the red, yellow and green card edges mean?",
                        answer: "Red: the group is still recovering. Yellow: trained this round and recovered. Green: not trained yet this round, so it's due. In Profile › Train Card Colors you can choose when green starts over (after your full split or each week), change the colours, or turn the edges off."),
                FAQItem(question: "Which sets count?",
                        answer: "Only sets you mark done. Planned but unfinished sets never count toward recovery, records or history."),
                FAQItem(question: "Can I change my split or goal?",
                        answer: "Yes. Tap Edit next to About You in Profile to change your goal, days a week and split. Your workout history stays as it is."),
            ]),
            FAQSection(title: "DATA, ADS & PRIVACY", items: [
                FAQItem(question: "Where is my workout data kept?",
                        answer: "On your \(DS.deviceNoun) only. MUSQ has no account and doesn't upload your workouts. Deleting the app deletes them, so keep it installed (or back up your \(DS.deviceNoun)) to keep your history."),
                FAQItem(question: "Why do I see ads, and how do I change my ad choices?",
                        answer: "Ads keep the free version free; no full-screen ad appears mid-workout. Premium removes them. Where the law requires a choice, you can change it any time from Profile › Privacy Choices, and tracking follows your answer to Apple's tracking prompt (Settings › Privacy & Security › Tracking)."),
            ]),
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
