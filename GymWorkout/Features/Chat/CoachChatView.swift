//
//  CoachChatView.swift
//  GymWorkout
//
//  The "Ask MUSQ" chat, Premium: questions about training (technique,
//  programming, recovery, eating for training) answered with the user's
//  plan and recent workouts in mind. The bar that opens it sits at the top
//  of the Today tab. Asks once, naming OpenAI, before anything leaves the
//  phone; health answers only go when the user turns them on.
//
//  Balance's "Ask MUSQ" (2026-11-22) opens it with a written question
//  (`initialQuestion`): it waits in the field, with a note that it holds
//  the user's Balance numbers, until the user edits or sends it themselves.
//

import SwiftUI

// MARK: - The Today bar

/// The coach's entry at the top of Today: a field-like bar, outlined so it
/// never competes with the page's one filled button. Free users see a lock
/// and get the Premium sheet.
struct AskCoachBar: View {
    var action: () -> Void

    @Environment(Purchases.self) private var purchases

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.85))
                Text("Ask MUSQ about your training", comment: "The coach chat's bar on Today")
                    .font(.ui(15))
                    .foregroundStyle(DS.silver.opacity(0.62))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Spacer(minLength: 8)
                if purchases.isPremium {
                    Image(systemName: "arrow.up.circle")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(DS.silver.opacity(0.5))
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 9, weight: .bold))
                        Text("Premium", comment: "Tag on a Premium feature")
                            .font(.mono(9.5, .semibold))
                            .trackingEm(0.08, size: 9.5)
                            .textCase(.uppercase)
                    }
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(Capsule().strokeBorder(DS.silver.opacity(0.25), lineWidth: 1))
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(Capsule().fill(DS.surface))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(String(localized: "Ask MUSQ about your training"))
        .accessibilityHint(purchases.isPremium ? String(localized: "Opens the coach chat")
                                               : String(localized: "A Premium feature. Opens MUSQ Premium."))
    }
}

// MARK: - The chat

struct CoachChatView: View {
    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @AppStorage(CoachChat.consentKey) private var consented = false
    @AppStorage(CoachChat.includeHealthKey) private var includeHealth = false

    /// "Report this answer" couldn't open a mail app: show the address instead.
    @State private var showsReportAddress = false
    /// One store for the app: a reply that lands after the sheet closes is
    /// still there when it opens again.
    @State private var chat = CoachChatStore.shared
    @State private var draft = ""
    @State private var consentMode: CoachConsentSheet.Mode?
    /// A new question waiting for the consent sheet's answer.
    @State private var pending: String?
    /// An unanswered question to ask again once consent is given.
    @State private var resumeAfterConsent = false
    @State private var confirmsClear = false
    /// MUSQ's server needs an account (Sign in with Apple) for the AI.
    @State private var showsSignIn = false
    @State private var showsUpgrade = false
    @FocusState private var typing: Bool
    /// A question another screen wrote for the user (Balance's "Ask MUSQ"),
    /// put in the field on first appear for them to read, edit and send
    /// themselves. Never sent on its own.
    private let initialQuestion: String?
    /// The text as it was put in the field, while it's still there unedited:
    /// the note under the field shows only then.
    @State private var prefilled: String?
    @State private var didPrefill = false

    init(initialQuestion: String? = nil) {
        self.initialQuestion = initialQuestion
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        if chat.messages.isEmpty {
                            intro
                        }
                        ForEach(chat.messages) { message in
                            bubble(message)
                                .id(message.id)
                        }
                        if chat.sending {
                            thinking
                                .id("thinking")
                        } else if let notice {
                            // One row for every notice: two rows sharing the "problem" id
                            // left the lazy stack showing the old one ("No answer to this
                            // one yet." and Try again after the answer had failed).
                            problemRow(notice.text, canRetry: notice.canRetry, signIn: notice.signIn,
                                       upgrade: notice.upgrade)
                                .id("problem")
                        }
                    }
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.vertical, 16)
                }
                // Keeps the latest line in view as the keyboard and input grow.
                .defaultScrollAnchor(.bottom, for: .sizeChanges)
                .scrollDismissesKeyboard(.interactively)
                // Keyed on the last message, not the count: once 80 are kept the
                // count stops changing, and answers would go unannounced.
                .onChange(of: chat.messages.last?.id) {
                    scrollToEnd(proxy)
                    if chat.messages.last?.role == .assistant {
                        AccessibilityNotification.Announcement(String(localized: "MUSQ answered")).post()
                    }
                }
                .onChange(of: chat.sending) { scrollToEnd(proxy) }
                .onChange(of: chat.problem) { _, problem in
                    scrollToEnd(proxy)
                    guard let problem else { return }
                    if problem == .consentNeeded {
                        // The server asks again: take the OK again, then re-ask.
                        consented = false
                        resumeAfterConsent = true
                        consentMode = .ask
                    }
                    if problem == .notSignedIn { showsSignIn = true }
                    AccessibilityNotification.Announcement(text(for: problem)).post()
                }
                .onAppear {
                    chat.noteTier(purchases.tier)
                    scrollToEnd(proxy, animated: false)
                    prefillIfNeeded()
                }
                // An upgrade (or a lapse) brings a new allowance.
                .onChange(of: purchases.tier) { _, tier in chat.noteTier(tier) }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) { inputBar }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Ask MUSQ", comment: "The coach chat's title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button(String(localized: "What MUSQ shares"), systemImage: "hand.raised") { consentMode = .review }
                        Button(String(localized: "Clear chat"), systemImage: "trash", role: .destructive) { confirmsClear = true }
                            .disabled(chat.messages.isEmpty || chat.sending)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .accessibilityLabel(String(localized: "Chat options"))
                }
            }
            .confirmationDialog(String(localized: "Clear this chat?"), isPresented: $confirmsClear, titleVisibility: .visible) {
                Button(String(localized: "Clear chat"), role: .destructive) { chat.clear() }
            } message: {
                Text(DS.isPad ? String(localized: "The conversation is only on this iPad, so it can't be brought back.")
                              : String(localized: "The conversation is only on this iPhone, so it can't be brought back."))
            }
            .sheet(isPresented: $showsSignIn) {
                // Signed in: ask the question that was waiting.
                AISignInPrompt(onSignedIn: { retry() })
            }
            // Over the chat, not from Today's paywall: a sheet can't open
            // from below one that's already showing.
            .sheet(isPresented: $showsUpgrade) {
                PremiumView(reason: .coach, profile: store.profile)
                    .environment(purchases)
            }
            .sheet(item: $consentMode) { mode in
                CoachConsentSheet(mode: mode, consented: $consented, includeHealth: $includeHealth) { agreed in
                    consentMode = nil
                    if agreed, let question = pending {
                        pending = nil
                        send(question)
                    } else if agreed, resumeAfterConsent {
                        resumeAfterConsent = false
                        retry()
                    } else if !agreed {
                        pending = nil
                        resumeAfterConsent = false
                    }
                }
            }
            .reportByEmailFallback(isPresented: $showsReportAddress)
        }
        .tint(DS.silver)
    }

    // MARK: Pieces

    private var intro: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "sparkles")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.85))
                .accessibilityHidden(true)
            Text("Ask about your training")
                .font(.system(size: 26, weight: .semibold, design: .serif))
                .foregroundStyle(DS.silver)
                .accessibilityAddTraits(.isHeader)
            Text("Technique, programming, recovery and eating for training. MUSQ answers with your plan and your last two weeks of workouts in mind.")
                .font(.ui(15))
                .foregroundStyle(DS.silver.opacity(0.65))
                .fixedSize(horizontal: false, vertical: true)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button { send(suggestion) } label: {
                        Text(suggestion)
                            .font(.ui(14, .medium))
                            .foregroundStyle(DS.silver)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .frame(minHeight: 44)
                            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(DS.silver.opacity(0.07)))
                            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .disabled(chat.sending || chat.isOutOfQuestions)
                }
            }
            .padding(.top, 6)
        }
        .padding(.top, 8)
        .padding(.bottom, 12)
    }

    private var suggestions: [String] {
        [String(localized: "How many sets a week should I do for chest?"),
         String(localized: "How should I warm up before squats?", comment: "A suggestion for the coach chat"),
         String(localized: "What should I eat before training?"),
         String(localized: "Am I recovering enough between sessions?")]
    }

    @ViewBuilder
    private func bubble(_ message: CoachChatMessage) -> some View {
        switch message.role {
        case .user:
            HStack {
                Spacer(minLength: 48)
                Text(message.content)
                    .font(.ui(15))
                    .foregroundStyle(DS.silver)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.silver.opacity(0.12)))
                    .textSelection(.enabled)
                    .accessibilityLabel(String(localized: "You: \(message.content)", comment: "VoiceOver: the user's message"))
            }
        case .assistant:
            let text = Self.rendered(message.content)
            Text(text)
                .font(.ui(15))
                .lineSpacing(3)
                .foregroundStyle(DS.silver)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
                // A long press opens Copy and Report this answer (App Store
                // 1.2: AI-made content can be reported), in place of text
                // selection, whose own long press would take the same touch.
                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 18, style: .continuous))
                .contextMenu {
                    Button(String(localized: "Copy", comment: "Menu on a coach answer: copies its text"), systemImage: "doc.on.doc") {
                        UIPasteboard.general.string = String(text.characters)
                    }
                    Button(String(localized: "Report this answer"), systemImage: "flag") { report(message) }
                }
                .padding(.trailing, 24)
                .accessibilityLabel(String(localized: "MUSQ: \(String(text.characters))", comment: "VoiceOver: the coach's answer"))
                .accessibilityAction(named: String(localized: "Report this answer")) { report(message) }
        }
    }

    /// Reports an answer by email to MUSQ, with its text below room for the
    /// member's own words; without a mail app, an alert gives the address.
    private func report(_ message: CoachChatMessage) {
        guard let url = AppLinks.mail(subject: "MUSQ coach answer report", body: "\n\n" + message.content) else {
            showsReportAddress = true
            return
        }
        openURL(url) { accepted in
            if !accepted { showsReportAddress = true }
        }
    }

    /// Replies may carry light Markdown. Bold, italics and "- " lists read
    /// fine inline; headings become bold lines and code fences are dropped,
    /// so no stray #s or backticks show. Anything that won't parse shows as
    /// plain text.
    private static func rendered(_ text: String) -> AttributedString {
        let lines = text.components(separatedBy: "\n").compactMap { line -> String? in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("```") { return nil }
            if let range = trimmed.range(of: "^#{1,6}\\s+", options: .regularExpression) {
                return "**\(trimmed[range.upperBound...])**"
            }
            return line
        }
        let cleaned = lines.joined(separator: "\n")
        return (try? AttributedString(markdown: cleaned, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            ?? AttributedString(cleaned)
    }

    private var thinking: some View {
        HStack(spacing: 8) {
            ProgressView()
                .controlSize(.small)
            Text("Thinking…", comment: "The coach is writing an answer")
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.6))
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }

    /// What the row under the conversation says, if anything: the last
    /// problem, or a question still without an answer (after a relaunch, or
    /// when the sheet was closed before it came).
    private var notice: (text: String, canRetry: Bool, signIn: Bool, upgrade: Bool)? {
        // A limit from a day that has ended falls through to the unanswered
        // row, so the question can be asked again.
        if let problem = chat.problem, problem != .limitReached || chat.isOutOfQuestions {
            return (text(for: problem), Self.canRetry(problem) && chat.hasUnanswered && !chat.isOutOfQuestions,
                    problem == .notSignedIn, problem == .limitReached && offersPro)
        }
        if chat.hasUnanswered {
            return (String(localized: "No answer to this one yet."), !chat.isOutOfQuestions, false, false)
        }
        return nil
    }

    /// Premium members can move up to Pro for more questions a day, once
    /// Pro is on sale with the AI.
    private var offersPro: Bool { purchases.tier == .premium && AIService.isLive && purchases.sellsPro }

    private func problemRow(_ text: String, canRetry: Bool, signIn: Bool = false, upgrade: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(text)
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
            if signIn {
                QuickChip(title: String(localized: "Sign in"), symbol: "person.crop.circle") { showsSignIn = true }
            } else if upgrade {
                QuickChip(title: String(localized: "Get Pro"), symbol: "sparkles") { showsUpgrade = true }
            } else if canRetry {
                QuickChip(title: String(localized: "Try again"), symbol: "arrow.clockwise") { retry() }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(DS.silver.opacity(0.12), lineWidth: 1))
    }

    private func text(for problem: CoachChatError) -> String {
        switch problem {
        case .notSignedIn: return String(localized: "Sign in to ask the coach.")
        // The chat only opens with Premium on this device, so this is mostly
        // the server not knowing yet (bought a moment ago, or its check of the
        // purchase failed): say so and let them ask again, like the meal scan.
        case .notPremium: return String(localized: "The coach is part of MUSQ Premium. If you've just bought it, try again in a moment.")
        case .consentNeeded: return String(localized: "MUSQ needs your OK before it sends anything to OpenAI.")
        case .limitReached:
            let limit = purchases.tier.ai?.chatPerDay ?? 0
            if offersPro, let pro = Purchases.Tier.pro.ai?.chatPerDay {
                return String(localized: "That's today's \(limit) questions. Pro gives you \(pro) a day, or ask again tomorrow.",
                              comment: "The coach's daily limit on Premium: That's today's 10 questions. Pro gives you 30 a day…")
            }
            return String(localized: "That's today's \(limit) questions. Ask again tomorrow.",
                          comment: "The coach's daily limit: That's today's 30 questions.")
        // Same wording as the meal scan and goal photo; neither gets Try again.
        case .featureOff: return String(localized: "The coach is paused for now. Try again later.")
        case .deviceNotVerified: return String(localized: "MUSQ couldn't verify this device. Update MUSQ and try again.")
        // Same wording as the meal scan and goal photo.
        case .proNotSynced: return String(localized: "Pro is on, but MUSQ's server hasn't caught up yet. Try again in a moment.")
        case .unavailable: return String(localized: "The coach can't answer right now. Try again in a moment.")
        case .server: return String(localized: "Something went wrong. Try again.")
        }
    }

    private static func canRetry(_ problem: CoachChatError) -> Bool {
        switch problem {
        // A refused call costs no question, so asking again is free.
        case .unavailable, .server, .notPremium, .proNotSynced: return true
        default: return false
        }
    }

    private var inputBar: some View {
        let length = draft.trimmingCharacters(in: .whitespacesAndNewlines).utf16.count
        return VStack(spacing: 6) {
            HStack(alignment: .bottom, spacing: 8) {
                // Multi-line: Return adds a line, the arrow sends.
                TextField(String(localized: "Ask about training"), text: $draft, axis: .vertical)
                    .font(.ui(15))
                    .lineLimit(1...5)
                    .focused($typing)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface))
                    .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
                    .disabled(chat.isOutOfQuestions)
                Button { send(draft) } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(canSend ? DS.silver : DS.silver.opacity(0.25))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(!canSend)
                .accessibilityLabel(String(localized: "Send"))
            }
            if let prefilled, draft == prefilled {
                // The question carries the week's numbers (sleep only when
                // the user chose to include it); the coach's consent already
                // names OpenAI, so this just says what's in the text.
                Text("Includes your Balance numbers. Edit anything before you send.",
                     comment: "Under the coach's field when Balance wrote the question")
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                    .transition(.opacity)
            }
            if length > CoachChat.messageLimit - 200 {
                Text("\(length.formatted()) / \(CoachChat.messageLimit.formatted())", comment: "Characters typed of the limit: 1,950 / 2,000")
                    .font(.mono(10.5, .semibold))
                    .foregroundStyle(DS.silver.opacity(length > CoachChat.messageLimit ? 0.95 : 0.6))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Text(footnote)
                .font(.ui(11.5))
                .foregroundStyle(DS.silver.opacity(0.5))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(DS.ink.opacity(0.96))
    }

    private var footnote: String {
        let caution = String(localized: "MUSQ can be wrong. For pain or a health condition, see a doctor.")
        guard let left = chat.remainingToday, chat.remainingDay.map({ Calendar.current.isDateInToday($0) }) == true else {
            return caution
        }
        let count = left == 1 ? String(localized: "1 question left today")
            : String(localized: "\(left) questions left today", comment: "The coach's daily limit: 28 questions left today")
        return "\(count) · \(caution)"
    }

    /// Something typed, within the server's 2,000 characters, nothing in
    /// flight, and questions left today.
    private var canSend: Bool {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        return !chat.sending && !text.isEmpty && text.utf16.count <= CoachChat.messageLimit && !chat.isOutOfQuestions
    }

    // MARK: Sending

    private func send(_ text: String) {
        let question = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty, question.utf16.count <= CoachChat.messageLimit,
              !chat.sending, !chat.isOutOfQuestions else { return }
        // Nothing leaves the phone before the user has said yes, naming OpenAI.
        guard consented else {
            pending = question
            consentMode = .ask
            return
        }
        // A suggestion tapped while something is typed leaves the typing alone.
        let typed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        if typed.isEmpty || typed == question {
            draft = ""
            prefilled = nil
        }
        chat.problem = nil
        chat.append(CoachChatMessage(role: .user, content: question))
        ask()
    }

    /// Puts `initialQuestion` in the field once, the first time the chat
    /// shows, when nothing is typed or on its way; the user reads it, edits
    /// it if they like and taps Send. Never sends it.
    private func prefillIfNeeded() {
        guard !didPrefill else { return }
        didPrefill = true
        guard let question = initialQuestion?.trimmingCharacters(in: .whitespacesAndNewlines), !question.isEmpty,
              draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !chat.sending else { return }
        draft = question
        prefilled = question
        guard !chat.isOutOfQuestions else { return }
        // Once the sheet has settled, or the keyboard doesn't come up.
        Task {
            try? await Task.sleep(for: .milliseconds(450))
            typing = true
        }
    }

    /// Asks again with the conversation as it is: after a failed answer, or
    /// a question left unanswered when the sheet was closed.
    private func retry() {
        guard chat.hasUnanswered, !chat.isOutOfQuestions else { return }
        guard consented else {
            resumeAfterConsent = true
            consentMode = .ask
            return
        }
        ask()
    }

    private func ask() {
        guard consented else { return }
        chat.ask(context: CoachChatContext(store: store, includeHealth: includeHealth),
                 client: CoachChat.client, locale: CoachChat.locale)
    }

    private func scrollToEnd(_ proxy: ScrollViewProxy, animated: Bool = true) {
        let target: AnyHashable?
        if chat.sending {
            target = "thinking"
        } else if notice != nil {
            target = "problem"
        } else {
            target = chat.messages.last.map { AnyHashable($0.id) }
        }
        guard let target else { return }
        if animated {
            withAnimation(.easeOut(duration: 0.25)) { proxy.scrollTo(target, anchor: .bottom) }
        } else {
            proxy.scrollTo(target, anchor: .bottom)
        }
    }
}

// MARK: - Consent

/// Asks once, naming OpenAI and listing what goes, before the first
/// question; from the chat's menu it shows the same and lets the user
/// change it. The meal scan and the goal photo ask for their own consent
/// (`AIService.Consent`).
struct CoachConsentSheet: View {
    enum Mode: String, Identifiable {
        /// Before the first question.
        case ask
        /// From the menu: what's shared, and a way to stop.
        case review

        var id: String { rawValue }
    }

    var mode: Mode
    @Binding var consented: Bool
    @Binding var includeHealth: Bool
    /// True when the user agreed (or kept agreeing).
    var onDecision: (Bool) -> Void

    /// When asking, the health choice only counts once the user agrees:
    /// it starts off, and "Not now" leaves the setting as it was.
    @State private var healthChoice = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.85))
                        .accessibilityHidden(true)
                    Text(mode == .ask ? String(localized: "Before you ask") : String(localized: "What MUSQ shares"))
                        .font(.system(size: 26, weight: .semibold, design: .serif))
                        .foregroundStyle(DS.silver)
                        .accessibilityAddTraits(.isHeader)
                    Text("MUSQ's coach is powered by OpenAI. Your questions, and the details below, go through MUSQ's server to OpenAI to write each answer.")
                        .font(.ui(15))
                        .foregroundStyle(DS.silver.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading, spacing: 8) {
                        item(String(localized: "Your goal, age, sex, height and weight"))
                        item(String(localized: "Your training experience, split and days a week"))
                        // `CoachChatContext` sends the plan from the answers
                        // alone (no Health value), so Today's steps-adjusted
                        // target can differ. The same words for everyone.
                        item(DS.isPad
                             ? String(localized: "Your plan's calories and macros, worked out from your answers. Apple Health steps stay on this iPad, so the target on Today can differ.")
                             : String(localized: "Your plan's calories and macros, worked out from your answers. Apple Health steps stay on this iPhone, so the target on Today can differ."))
                        // Every field of `CoachChatContext.Workout`, timed sets' seconds included.
                        item(String(localized: "Your workouts from the last two weeks: dates, muscle groups, exercises, sets, reps, weights and hold times"))
                        // `CoachChatStore.ask` sends the conversation, not just the new question.
                        item(String(localized: "Earlier messages in this chat and the coach's replies, up to the last \(CoachChat.historyLimit) messages",
                                    comment: "Ask MUSQ consent: what's sent with each question; the number is how many messages at most"))
                        // OpenAI's safety_identifier: a hash of the account's uid
                        // (functions/src/openai.ts), which MUSQ could work out again.
                        item(String(localized: "A coded ID made from your account, so OpenAI can spot abuse: not your name or email"))
                    }
                    .padding(.top, 2)
                    Toggle(isOn: mode == .ask ? $healthChoice : $includeHealth) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Also send my health answers")
                                .font(.ui(15, .semibold))
                                .foregroundStyle(DS.silver)
                            Text("Sore joints, health conditions, and pregnancy or a recent birth, so the coach can steer around them.")
                                .font(.ui(13))
                                .foregroundStyle(DS.silver.opacity(0.6))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .tint(DS.silver)
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface))
                    Text(DS.isPad
                         ? String(localized: "The chat itself stays on this iPad. Answers are general guidance, not medical advice: for pain or a health condition, see a doctor.")
                         : String(localized: "The chat itself stays on this iPhone. Answers are general guidance, not medical advice: for pain or a health condition, see a doctor."))
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                    // The meal scan and goal photo sheets say the same.
                    VStack(alignment: .leading, spacing: 0) {
                        Text("OpenAI may keep what it receives for up to 30 days to check for abuse, and doesn't use it to train its models.")
                            .font(.ui(13))
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .fixedSize(horizontal: false, vertical: true)
                        // The frame inside the label, so all 44 pt take the tap.
                        Link(destination: AppLinks.privacy) {
                            Text("Privacy Policy")
                                .font(.ui(13, .semibold))
                                .foregroundStyle(DS.silver.opacity(0.75))
                                .frame(minHeight: 44, alignment: .leading)
                                .contentShape(Rectangle())
                        }
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.vertical, 20)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack(spacing: 4) {
                    if mode == .ask || !consented {
                        WideButton(title: String(localized: "Agree and continue"), prominent: true, fontSize: 16,
                                   verticalPadding: 14, cornerRadius: 14) {
                            if mode == .ask { includeHealth = healthChoice }
                            consented = true
                            onDecision(true)
                        }
                        Button(String(localized: "Not now")) { onDecision(false) }
                            .font(.ui(15, .semibold))
                            .frame(minHeight: 44)
                    } else {
                        WideButton(title: String(localized: "Done"), prominent: true, fontSize: 16,
                                   verticalPadding: 14, cornerRadius: 14) {
                            onDecision(true)
                        }
                        Button(String(localized: "Stop sharing"), role: .destructive) {
                            consented = false
                            includeHealth = false
                            onDecision(false)
                        }
                        .font(.ui(15, .semibold))
                        .frame(minHeight: 44)
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(DS.ink)
            }
            .background(DS.ink.ignoresSafeArea())
        }
        .tint(DS.silver)
        .interactiveDismissDisabled(mode == .ask)
    }

    private func item(_ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Image(systemName: "checkmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(DS.silver.opacity(0.7))
                .accessibilityHidden(true)
            Text(text)
                .font(.ui(15))
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
