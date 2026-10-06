//
//  FAQView.swift
//  GymWorkout
//
//  Help & FAQ, pushed from Profile: the questions people ask about Premium,
//  billing, recovery, the card colours, their data and ads, each opening in
//  place, and a way to write to support. Prices and trial length are read
//  from the App Store products, so the answers can't drift from them.
//

import SwiftUI

struct FAQView: View {
    @Environment(Purchases.self) private var purchases
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var open: Set<String> = []

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                HistoryHeader(title: "Help & FAQ", meta: "MUSQ", onBack: { dismiss() })
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        ForEach(sections, id: \.title) { section in
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
                                .padding(.horizontal, 14)
                                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
                            }
                        }
                        contact
                    }
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 6)
                    .padding(.bottom, 32)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
    }

    // MARK: - Rows

    private func row(_ item: FAQItem) -> some View {
        let isOpen = open.contains(item.question)
        return VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    if isOpen { open.remove(item.question) } else { open.insert(item.question) }
                }
            } label: {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(item.question)
                        .font(.ui(14.5, .semibold))
                        .foregroundStyle(DS.silver)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.4))
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint(isOpen ? "Hides the answer" : "Shows the answer")

            if isOpen {
                Text(item.answer)
                    .font(.ui(13))
                    .cssLineHeight(13, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
            }
        }
        .padding(.vertical, 13)
    }

    private var contact: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "STILL STUCK?")
            VStack(alignment: .leading, spacing: 12) {
                Text("Write to us and we'll get back to you, usually within two working days.")
                    .font(.ui(13))
                    .cssLineHeight(13, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                Button {
                    openURL(AppLinks.supportMail)
                } label: {
                    Label(AppLinks.supportEmail, systemImage: "envelope")
                        .font(.ui(14, .semibold))
                        .foregroundStyle(DS.silver)
                }
                .buttonStyle(.plain)
                Link("Support website", destination: AppLinks.support)
                    .font(.ui(12, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.55))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
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
                        answer: "Open the Settings app on your iPhone, tap your name, then Subscriptions, choose MUSQ and tap Cancel Subscription. Cancel at least 24 hours before the renewal date to avoid being charged; Premium stays on until the end of the period you've paid for. Cancelling during a free trial ends it without charge."),
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
                        answer: "On your iPhone only. MUSQ has no account and doesn't upload your workouts. Deleting the app deletes them, so keep it installed (or back up your iPhone) to keep your history."),
                FAQItem(question: "Why do I see ads, and how do I change my ad choices?",
                        answer: "Ads keep the free version free; no full-screen ad appears mid-workout. Premium removes them. Where the law requires a choice, you can change it any time from Profile › Privacy Choices, and tracking follows your answer to Apple's tracking prompt (Settings › Privacy & Security › Tracking)."),
            ]),
        ]
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
