//
//  QuickLogSheet.swift
//  GymWorkout
//
//  Logging water, a walk or a meal by voice or by typing (2026-11-22). One
//  sheet, three tabs. At the top, a mic (iOS 26: heard on the device by
//  `VoiceInput`, nothing recorded or sent) and a text field that reads the
//  same phrases, so on older iOS the keyboard's own mic does the listening.
//  What was heard only fills in the form below: nothing is logged until the
//  user taps Add.
//
//  - Water: any amount on a slider (50 ml to 1.5 L, in 50s), the water
//    buttons (a tap logs one; the amount on the slider can be saved as a
//    button, up to four; press and hold one to remove it), and today's
//    glasses, swipe to delete.
//  - Walk: for walks without the phone or a Watch, in minutes (100 steps a
//    minute) or steps. Kept in MUSQ's own log, never written to Apple
//    Health. Its energy is an estimate (`WalkSuggestion`), shown only and
//    never added to the calorie target; the day's walking energy shows only
//    when Apple Health has no active energy for today.
//  - Food (2026-11-23, owner-approved, free for everyone, no AI): say or
//    type what was eaten ("một tô phở bò tái và hai quả trứng luộc", "2
//    eggs and a bowl of rice", "200g ức gà"). A food's name alone lists the
//    food table's matches as it's typed (a tap adds one at its usual size);
//    words with amounts, calories or several foods list each food read
//    (`FoodPhraseParser`), each changeable to another table food, found in
//    the food search or typed in by hand. A food the table hasn't got is
//    typed in by hand (its name and calories, its grams if known), and a
//    food said with its calories ("phở 450 kcal") is logged with them. The
//    foods go into the meal (`MealItemsEditor`, the rows the photo scan's
//    review has), with its totals, a name (its foods' by default) and when
//    it was eaten (now by default), then "Log meal": a typed meal
//    (`MealEntry.Source.manual`) whose table foods carry the table's
//    numbers. Today's meals open in the meal editor with a tap.
//
//  Every add can be undone from the toast for about five seconds. The mic
//  listens in the app's language (`VoiceInput.appLocale`).
//

import SwiftUI
import UIKit

/// The quick log, opening on `kind`.
struct QuickLogSheet: View {
    @State private var kind: QuickLogKind
    /// The presenting window's tier: the sheet's own is resolved inside.
    @Environment(\.dsLayout) private var layout

    init(kind: QuickLogKind) {
        _kind = State(initialValue: kind)
    }

    var body: some View {
        QuickLogContent(kind: $kind)
            .dsLayoutRoot()
            .background(DS.ink.ignoresSafeArea())
            // Outside the layout root: sized by the window it opens over.
            .dsSheetSizing(.form)
            // A form sheet on iPad isn't dragged down; the phone's still is.
            .presentationDragIndicator(layout.isRegular ? .hidden : .visible)
            .presentationBackground(DS.ink)
            .presentationCornerRadius(DS.Metric.sheetRadius)
    }
}

// MARK: - Content

private struct QuickLogContent: View {
    @Binding var kind: QuickLogKind

    @Environment(DailyStore.self) private var daily
    @Environment(WorkoutStore.self) private var store
    @Environment(AppleHealth.self) private var health
    @Environment(\.dsLayout) private var layout
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOver

    // Voice and typing
    @State private var voice = VoiceInput()
    @State private var phrase = ""
    @State private var note: ReadNote?
    /// Whether the mic should be on. False once it is let go or tapped off,
    /// so a mic that only becomes ready after that stops at once.
    @State private var wantsListening = false
    /// When the finger went down on the mic, while it is down.
    @State private var pressBegan: Date?
    /// The touch began while listening: letting go stops it.
    @State private var stopsOnRelease = false
    @FocusState private var focus: QuickLogField?

    // Water
    @State private var waterMl = 250
    // Walk
    @State private var walkMode: WalkMode = .minutes
    @State private var walkMinutes: Int? = 30
    @State private var walkSteps: Int? = 3_000
    // Food
    /// What the field's words read as on the Food tab (`QuickFoodReading`).
    @State private var foodReading = QuickFoodReading.none
    /// Water or a walk said on the Food tab ("2 ly nước", "đi bộ 30
    /// phút"): it goes on its own tab, never into a meal.
    @State private var otherReading: QuickLog?
    /// Plain water read beside foods ("1 ly nước lọc và 1 tô phở"): logged
    /// as water, not as a 0 kcal food.
    @State private var waterRead: (foods: [ParsedFood], ml: Int)?
    /// What VoiceOver was last told the words read as.
    @State private var lastAnnounced: String?
    /// The foods those words hold, as the member has them now.
    @State private var drafts: [QuickFoodDraft] = []
    /// Drafts the member changed, kept while the words are typed around
    /// them (`QuickFoodDraft.merge`), until the words are cleared.
    @State private var changedDrafts: [QuickFoodDraft] = []
    /// Foods read and then left out, while the words up to them stay as
    /// they were.
    @State private var leftOut: [LeftOutFood] = []
    /// The words as they were when Return or the mic said they're done: a
    /// number alone then reads as calories.
    @State private var submittedWords: String?
    /// The words the last full reading was for (not one in the middle of a
    /// word).
    @State private var settledWords: String?
    /// Log meal with foods found that still need their calories.
    @State private var confirmsLogWithout = false
    /// The meal being put together, its name (empty: its foods') and when
    /// it was eaten (nil: now). Kept across the tabs until it's logged.
    @State private var mealFoods: [MealReviewFood] = []
    @State private var mealTitle = ""
    @State private var eatenAt: Date?
    /// The food search, open to add a food or to change one read.
    @State private var foodSearch: QuickFoodSearch?
    /// One of today's meals, open in the meal editor.
    @State private var editingMeal: MealEntry?
    /// Done with a meal not logged yet: log it, or let it go.
    @State private var confirmsClose = false
    /// The Food tab's words came from the mic: what they read as is said
    /// to VoiceOver once read.
    @State private var heardFood = false
    /// Bumped as foods go into the meal, for the haptic.
    @State private var foodsAdded = 0

    @State private var lastAdd: LastAdd?
    /// Bumped on every add, for the haptic.
    @State private var addCount = 0

    private static let maxPresets = 4
    /// A press on the mic this long is a hold: letting go stops it.
    private static let holdSeconds: TimeInterval = 0.5

    var body: some View {
        NavigationStack {
            List {
                kindPicker
                voiceSection
                // Why a swipe down stays: the meal on the Food tab.
                if kind != .food, hasUnloggedFood { unloggedMealRow }
                switch kind {
                case .water: waterSections
                case .steps: walkSections
                case .food: foodSections
                }
            }
            .listStyle(.insetGrouped)
            .listSectionSpacing(16)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .dsReadable(DS.Layout.columnWidth)
            .background(DS.ink.ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 0) { toast }
            .navigationTitle(String(localized: "Quick log", comment: "Sheet title: log water, a walk or a meal"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { close() }
                        // On the button, so on iPad it points at it.
                        .confirmationDialog(String(localized: "This meal isn't logged yet",
                                                   comment: "Quick log: closing with foods in a meal that hasn't been logged"),
                                            isPresented: $confirmsClose, titleVisibility: .visible) {
                            if pendingDraftsReady {
                                // The foods found go in with the rest.
                                Button(String(localized: "Add the foods found and log",
                                              comment: "Quick log: closing with foods read but not added; adds them to the meal and logs it")) {
                                    addDrafts()
                                    logMeal()
                                    dismiss()
                                }
                            } else if !mealFoods.isEmpty {
                                Button(String(localized: "Log meal")) {
                                    logMeal(withDrafts: false)
                                    dismiss()
                                }
                            }
                            Button(String(localized: "Discard meal", comment: "Quick log: closes without logging the meal put together"),
                                   role: .destructive) { dismiss() }
                            Button(String(localized: "Cancel"), role: .cancel) {}
                        }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        focus = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    .accessibilityLabel(String(localized: "Hide keyboard"))
                }
            }
            .sheet(item: $editingMeal) { meal in
                MealEditSheet(meal: meal)
                    .environment(daily)
            }
        }
        .sheet(item: $foodSearch) { search in
            MealFoodSearchSheet(locale: foodLocale, request: search.request, allowsManualFoods: true) { food in
                picked(food, for: search.draftID)
            }
        }
        // A swipe down doesn't drop a meal that isn't logged, or foods
        // found and not added: Done asks.
        .interactiveDismissDisabled(hasUnloggedFood)
        .task(id: lastAdd?.id) {
            guard lastAdd != nil else { return }
            // A newer add (or the Undo itself) cancels this wait; a cancelled
            // wait must not clear the newer toast.
            do { try await Task.sleep(for: .seconds(voiceOver ? 12 : 5)) } catch { return }
            withAnimation(.easeOut(duration: 0.2)) { lastAdd = nil }
        }
        // The food table and the phrase reader's index, read off the main
        // thread before the first food (a meal said on another tab too).
        .task { await Task.detached(priority: .userInitiated) { FoodPhraseParser.prepare() }.value }
        // The Food tab's words, read again a moment after each change, and
        // at once when they're done (Return, the mic).
        .task(id: kind == .food ? FoodWords(text: phrase, submitted: isSubmitted) : nil) { await readFood() }
        .onChange(of: phrase) { _, words in
            guard kind == .food else { return }
            // Return in the growing field is done, not a new line; lines
            // pasted in stay apart as foods.
            if words.contains(where: \.isNewline) {
                let pressedReturn = words.last?.isNewline == true
                phrase = words.split(whereSeparator: \.isNewline)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                    .joined(separator: ", ")
                if pressedReturn { readPhrase() }
                return
            }
            // A word on the last foods added belongs to the words before.
            if !words.isEmpty { note = nil }
        }
        // A meal emptied by its rows' remove buttons starts over: its name
        // and time go with its foods.
        .onChange(of: mealFoods.isEmpty) { _, isEmpty in
            if isEmpty {
                mealTitle = ""
                eatenAt = nil
            }
        }
        .onDisappear {
            wantsListening = false
            Task { await voice.stop() }
        }
        #if DEBUG
        .onAppear(perform: applyLaunchPreview)
        #endif
        .sensoryFeedback(.success, trigger: addCount)
        .sensoryFeedback(.selection, trigger: foodsAdded)
    }

    // MARK: Tabs

    private var kindPicker: some View {
        let options: [(value: QuickLogKind, title: String)] = [
            (.water, String(localized: "WATER", comment: "Quick log tab: one of three segments side by side, keep it short")),
            (.steps, String(localized: "WALK", comment: "Quick log tab: one of three segments side by side, keep it short")),
            (.food, String(localized: "FOOD", comment: "Quick log tab: one of three segments side by side, keep it short")),
        ]
        return Section {
            MonoSegmentedControl(options: options,
                                 selection: Binding(get: { kind }, set: { pick($0) }),
                                 fontSize: 11, itemPaddingV: 9, fillsWidth: true)
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
        }
    }

    private func pick(_ new: QuickLogKind) {
        guard new != kind else { return }
        focus = nil
        // A reading belongs to the tab it filled in, and so does its phrase:
        // a new tab starts with an empty box, and a mic that's on lets go
        // of what it heard there instead of reading it on this one.
        note = nil
        phrase = ""
        clearFoodReading()
        wantsListening = false
        if voice.state == .listening || voice.state == .preparing || voice.isStopping {
            Task {
                await voice.stop()
                voice.reset()
            }
        } else {
            voice.reset()
        }
        withAnimation(.easeOut(duration: 0.15)) { kind = new }
    }

    /// On Water or Walk, with a meal on the Food tab not logged yet.
    private var unloggedMealRow: some View {
        Section {
            Button {
                pick(.food)
            } label: {
                Label {
                    Text(String(localized: "A meal on the Food tab isn't logged yet.",
                                comment: "Quick log, Water or Walk tab: foods put together on the Food tab wait to be logged"))
                        .fixedSize(horizontal: false, vertical: true)
                } icon: {
                    Image(systemName: "fork.knife")
                        .accessibilityHidden(true)
                }
                .font(.ui(13.5, .semibold))
                .foregroundStyle(DS.silver.opacity(0.8))
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint(String(localized: "Opens the Food tab", comment: "VoiceOver hint: goes to the quick log's Food tab"))
            .listRowBackground(DS.surface)
        }
    }

    // MARK: Voice and typing

    private var voiceSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    phraseField
                    if showsMic {
                        QuickLogMicButton(state: voice.state, onPress: micDown, onRelease: micUp,
                                          onToggle: toggleListening)
                    }
                }
                voiceStatus
            }
            .padding(.vertical, 6)
            .listRowBackground(DS.surface)
        }
    }

    /// No in-app mic before iOS 26, or for a language without on-device
    /// dictation: the keyboard's mic fills the field instead.
    private var showsMic: Bool {
        VoiceInput.isSupported && voice.state != .unavailable
    }

    private var isListening: Bool {
        voice.state == .listening || voice.state == .preparing
    }

    private var phraseField: some View {
        let hasText = !phrase.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return HStack(spacing: 4) {
            // On Food the field grows to show a long meal said in full (a
            // Return there is read as done, in `onChange(of: phrase)`).
            TextField(examplePrompt, text: $phrase, axis: kind == .food ? .vertical : .horizontal)
                .lineLimit(1...4)
                // A new field when the axis changes.
                .id(kind == .food)
                .font(.ui(16))
                .foregroundStyle(DS.silver)
                .focused($focus, equals: .phrase)
                // Food names, with or without their diacritics, as typed.
                .autocorrectionDisabled(kind == .food)
                .submitLabel(.done)
                .onSubmit { readPhrase() }
            if hasText {
                if kind == .food {
                    // The Food tab reads the words as they're typed: this
                    // clears them for the next food.
                    Button {
                        clearFoodWords()
                        note = nil
                        focus = .phrase
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(DS.silver.opacity(0.35))
                            .frame(width: 40, height: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(String(localized: "Clear", comment: "Quick log food: clears the words typed"))
                } else {
                    Button {
                        readPhrase()
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(DS.silver)
                            .frame(width: 40, height: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(String(localized: "Fill in from this", comment: "Reads the typed phrase into the form"))
                }
            }
        }
        .padding(.leading, 12)
        .padding(.trailing, hasText ? 2 : 12)
        .frame(minHeight: 48)
        .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(DS.silver.opacity(0.06)))
        .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
            .strokeBorder(DS.silver.opacity(focus == .phrase ? 0.4 : 0.10), lineWidth: 1))
    }

    private var examplePrompt: String {
        switch kind {
        case .water: return String(localized: "Say or type “2 glasses”",
                                   comment: "Quick log field example, water. The quoted words are an example to say or type; the app reads them in Vietnamese too")
        case .steps: return String(localized: "Say or type “walked 30 minutes”",
                                   comment: "Quick log field example, walk. The quoted words are an example to say or type; the app reads them in Vietnamese too")
        case .food: return String(localized: "What did you eat?", comment: "Quick log Food tab: the field for what was eaten")
        }
    }

    @ViewBuilder
    private var voiceStatus: some View {
        if isListening {
            VStack(alignment: .leading, spacing: 4) {
                Text(voice.transcript.isEmpty
                     ? (voice.state == .preparing ? String(localized: "Getting the mic ready…") : String(localized: "Listening…"))
                     : voice.transcript)
                    .font(.ui(17, .semibold))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.updatesFrequently)
                Text(pressBegan != nil && !stopsOnRelease
                     ? String(localized: "Let go when you're done.")
                     : String(localized: "Tap the mic when you're done."))
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.6))
            }
        } else if let note {
            statusLine(note.text, symbol: note.filled ? "checkmark.circle" : "questionmark.circle")
        } else if kind == .food, hasFoodWords {
            // Words in: what they read as shows below, or a word on why
            // nothing does (a mic that failed before is old news).
            foodWordsStatus
        } else {
            switch voice.state {
            case .denied:
                VStack(alignment: .leading, spacing: 2) {
                    statusLine(String(localized: "Microphone access is off for MUSQ. Turn it on in Settings › MUSQ, or use the mic on your keyboard."),
                               symbol: "mic.slash")
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
                    } label: {
                        Text("Open Settings")
                            .font(.ui(13.5, .semibold))
                            .foregroundStyle(DS.silver)
                            .frame(minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            case .unavailable:
                statusLine(String(localized: "Use the mic on your keyboard."), symbol: "keyboard")
            case .failed:
                statusLine(String(localized: "MUSQ couldn't listen just now. Try again, or type it."), symbol: "exclamationmark.circle")
            default:
                if kind == .food {
                    foodHint
                } else {
                    statusLine(showsMic
                               ? String(localized: "Hold the mic and say it, or type it. It's heard on your \(DS.deviceNoun), never recorded or sent, and you check it before it's logged.")
                               : String(localized: "Type it, or tap the mic on your keyboard to say it. You check it before it's logged."),
                               symbol: showsMic ? "mic" : "keyboard")
                }
            }
        }
    }

    /// Words on the Food tab that read as nothing yet: a number alone waits
    /// for Return (it may be on its way to "200g ức gà"); anything else
    /// says what works.
    @ViewBuilder
    private var foodWordsStatus: some View {
        if foodReading == .none, otherReading == nil {
            let words = phrase.trimmingCharacters(in: .whitespacesAndNewlines)
            if !words.isEmpty, words.count <= 5, words.allSatisfy({ $0.isASCII && $0.isNumber }) {
                statusLine(String(localized: "Press Return to log “\(words)” as calories, or keep typing.",
                                  comment: "Quick log Food tab: a number alone typed; Return reads it as a food's calories"),
                           symbol: "keyboard")
            } else if settledWords == words {
                // Only once these words are read in full, never mid-word.
                statusLine(String(localized: "No food found in that yet. Name one, like “phở bò” or “2 eggs”, or give its calories: “phở 450 kcal”.",
                                  comment: "Quick log Food tab: the words typed read as no food. The quoted words are examples to say or type; the app reads them in Vietnamese too"),
                           symbol: "questionmark.circle")
            }
        }
    }

    /// Under the empty Food field: what it takes. Once words are in, what
    /// they read as shows below instead.
    @ViewBuilder
    private var foodHint: some View {
        if phrase.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if !mealFoods.isEmpty {
                statusLine(String(localized: "Say or type another food, or log the meal below.",
                                  comment: "Quick log Food tab: under the empty field, with foods already in the meal"),
                           symbol: showsMic ? "mic" : "keyboard")
            } else if showsMic {
                statusLine(String(localized: "Hold the mic and say what you ate, or type it, like “2 eggs and a bowl of rice”. MUSQ finds each food and works out its calories and macros. It's heard on your \(DS.deviceNoun), never recorded or sent.",
                                  comment: "Quick log Food tab: under the empty field, with the in-app mic. The quoted words are an example to say or type; the app reads them in Vietnamese too"),
                           symbol: "mic")
            } else {
                statusLine(String(localized: "Type what you ate, or tap the mic on your keyboard to say it, like “2 eggs and a bowl of rice”. MUSQ finds each food and works out its calories and macros.",
                                  comment: "Quick log Food tab: under the empty field, without the in-app mic. The quoted words are an example to say or type; the app reads them in Vietnamese too"),
                           symbol: "keyboard")
            }
        }
    }

    private func statusLine(_ text: String, symbol: String) -> some View {
        Label {
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        } icon: {
            Image(systemName: symbol)
                .accessibilityHidden(true)
        }
        .font(.ui(13))
        .foregroundStyle(DS.silver.opacity(0.65))
    }

    // MARK: Mic

    private func micDown() {
        pressBegan = Date()
        if isListening {
            // A tap while listening stops it.
            stopsOnRelease = true
        } else {
            stopsOnRelease = false
            startListening()
        }
    }

    private func micUp() {
        let held = pressBegan.map { Date().timeIntervalSince($0) } ?? 0
        pressBegan = nil
        // Held: talk while pressing, read on letting go. A quick tap keeps
        // listening until the next tap.
        if stopsOnRelease || held >= Self.holdSeconds { stopListening() }
    }

    private func toggleListening() {
        if isListening { stopListening() } else { startListening() }
    }

    /// Asks for the microphone the first time (in `VoiceInput.start`), and
    /// listens in the app's language: Vietnamese words in a Vietnamese app,
    /// whatever the device's region.
    private func startListening() {
        focus = nil
        note = nil
        wantsListening = true
        Task {
            await voice.start(locale: VoiceInput.appLocale)
            // Let go, or tapped off, while the mic was getting ready.
            if !wantsListening && voice.state == .listening { await finishListening() }
        }
    }

    private func stopListening() {
        wantsListening = false
        // Still getting ready: it never comes on.
        if voice.state == .preparing {
            Task { await voice.stop() }
            return
        }
        guard voice.state == .listening else { return }
        Task { await finishListening() }
    }

    /// Stops the mic, whatever it's doing, and reads what it heard: before
    /// a sheet opens over the quick log.
    private func stopListeningNow() async {
        wantsListening = false
        if voice.state == .listening || voice.isStopping {
            await finishListening()
        } else if voice.state == .preparing {
            await voice.stop()
        }
    }

    /// Opens a sheet once the mic has let go of what it heard, so it never
    /// listens on under the sheet.
    private func open(_ present: @escaping () -> Void) {
        guard wantsListening || isListening || voice.isStopping else {
            present()
            return
        }
        Task {
            await stopListeningNow()
            present()
        }
    }

    /// What was heard fills the field, after any words typed on the Food
    /// tab ("2 quả trứng" typed, "và một tô phở" said), and reads as done.
    private func finishListening() async {
        guard !voice.isStopping else {
            // Another stop is reading what was heard.
            await voice.stop()
            return
        }
        await voice.stop()
        let heard = voice.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        voice.reset()
        guard !heard.isEmpty else {
            setNote(ReadNote(text: String(localized: "Nothing heard. Hold the mic while you speak, or type it."), filled: false))
            return
        }
        let typed = phrase.trimmingCharacters(in: .whitespacesAndNewlines)
        let words = kind == .food && !typed.isEmpty ? typed + ", " + heard : heard
        phrase = words
        if kind == .food { submittedWords = words }
        heardFood = kind == .food
        read(words)
    }

    // MARK: Reading

    private func readPhrase() {
        let text = phrase.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        focus = nil
        if kind == .food { submittedWords = text }
        read(text)
    }

    /// Whether the Food tab's words are done (Return, the mic) as they are.
    private var isSubmitted: Bool {
        submittedWords != nil && submittedWords == phrase.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Fills in the form from the words; never logs. The Food tab reads its
    /// words as they come (`readFood`), water and walks among them. A meal
    /// said on the Water or Walk tab moves to the Food tab, which reads it;
    /// whether it is one is read off the main thread.
    private func read(_ text: String) {
        guard kind != .food else {
            // Water or a walk, done: on its own tab, as it always went.
            if let other = waterOrWalk(text) {
                withAnimation(.easeOut(duration: 0.15)) { fill(other) }
                setNote(ReadNote(text: filledText(other), filled: true))
            }
            return
        }
        let locale = foodLocale
        let normalized = QuickLogParser.normalize(text)
        let walk = QuickLogParser.detect(normalized) == .steps
        let plainWater = QuickLogParser.isPlainWater(normalized)
        let from = kind
        Task {
            let meal = !walk && !plainWater
                ? await Task.detached(priority: .userInitiated) { Self.namesMeal(text, locale: locale) }.value
                : false
            // Another tab, or other words, since.
            guard kind == from else { return }
            if meal {
                withAnimation(.easeOut(duration: 0.15)) { kind = .food }
                submittedWords = text.trimmingCharacters(in: .whitespacesAndNewlines)
                setNote(ReadNote(text: readAsFood, filled: true))
                return
            }
            guard let log = QuickLogReading.read(text, preferring: kind, walkInMinutes: walkMode == .minutes,
                                                 heightCm: heightCm) else {
                setNote(ReadNote(text: notUnderstood, filled: false))
                return
            }
            if case .food = log {
                withAnimation(.easeOut(duration: 0.15)) { kind = .food }
                submittedWords = text.trimmingCharacters(in: .whitespacesAndNewlines)
                setNote(ReadNote(text: readAsFood, filled: true))
                return
            }
            withAnimation(.easeOut(duration: 0.15)) { fill(log) }
            setNote(ReadNote(text: filledText(log), filled: true))
        }
    }

    /// Words on the Food tab that are plain water or a walk, not food: "2
    /// ly nước", "uống 1 lít nước", "500 ml", "đi bộ 30 phút".
    private func waterOrWalk(_ text: String) -> QuickLog? {
        let normalized = QuickLogParser.normalize(text)
        switch QuickLogParser.detect(normalized) {
        case .water:
            guard QuickLogParser.isPlainWater(normalized) else { return nil }
            return QuickLogParser.parse(text, as: .water, heightCm: heightCm)
        case .steps:
            return QuickLogParser.parse(text, as: .steps, heightCm: heightCm)
        case .food:
            return nil
        }
    }

    /// Words that name a meal rather than water or a walk: not plain water
    /// (drinks are food: "1 ly trà sữa", "a glass of orange juice"), and a
    /// food the table has other than water, or calories ("1 tô phở",
    /// "chicken rice 650 kcal"). Off the main thread: the reader's index is
    /// built when the sheet opens, but may not be ready yet.
    nonisolated private static func namesMeal(_ text: String, locale: String) -> Bool {
        FoodPhraseParser.parse(text, language: locale).contains {
            ($0.match != nil && $0.match?.id != FoodPhraseParser.waterID) || $0.kcal != nil
        }
    }

    private var readAsFood: String {
        String(localized: "Read as food. Check the foods below, then add them to the meal.",
               comment: "Quick log: words said on the Water or Walk tab named a meal, now on the Food tab")
    }

    private func setNote(_ new: ReadNote) {
        note = new
        AccessibilityNotification.Announcement(new.text).post()
    }

    private func fill(_ log: QuickLog) {
        switch log {
        case .water(let ml):
            kind = .water
            waterMl = ml
        case .steps(let count, let minutes):
            kind = .steps
            if let minutes, count == minutes * QuickLogReading.stepsPerMinute {
                walkMode = .minutes
                walkMinutes = minutes
            } else {
                walkMode = .steps
                walkSteps = count
            }
        case .food:
            // The Food tab reads the words in the field itself.
            kind = .food
        }
    }

    private func filledText(_ log: QuickLog) -> String {
        switch log {
        case .water(let ml):
            return String(localized: "Read as \(DailyStore.litres(ml)) of water. Check it, then tap Add.",
                          comment: "Quick log: the words said or typed filled in the water amount; “Add” is the button under it (Add 750 ml)")
        case .steps(let count, let minutes):
            if let minutes, count == minutes * QuickLogReading.stepsPerMinute {
                return String(localized: "Read as a \(minutes)-minute walk. Check it, then tap Add walk.",
                              comment: "Quick log: the words filled in a walk in minutes; “Add walk” is the button under it")
            }
            return String(localized: "Read as \(count.formatted()) steps. Check it, then tap Add walk.",
                          comment: "Quick log: the words filled in a walk in steps; “Add walk” is the button under it")
        case .food:
            return readAsFood
        }
    }

    /// Water and a walk only: the Food tab shows what its words read as.
    private var notUnderstood: String {
        switch kind {
        case .water:
            return String(localized: "MUSQ couldn't find an amount in that. Try “500 ml” or “2 glasses”.",
                          comment: "Quick log Water tab: the words held no amount. The quoted words are examples to say or type; the app reads them in Vietnamese too")
        case .steps, .food:
            return String(localized: "MUSQ couldn't find a walk in that. Try “30 minutes” or “4,000 steps”.",
                          comment: "Quick log Walk tab: the words held no walk. The quoted words are examples to say or type; the app reads them in Vietnamese too")
        }
    }

    // MARK: Water

    @ViewBuilder
    private var waterSections: some View {
        Section {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(TodayTone.water)
                        .accessibilityHidden(true)
                    let parts = Self.waterParts(waterMl)
                    BigValue(value: parts.value, unit: parts.unit, size: 34)
                }
                waterSlider
                presetGrid
                savePresetRow
                WideButton(title: QuickLogText.addWater(waterMl), prominent: true, fontSize: 16, verticalPadding: 14,
                           cornerRadius: 14) { addWater(waterMl) }
            }
            .padding(.vertical, 8)
            .listRowBackground(DS.surface)
        } footer: {
            // Past two buttons, which of them Today shows (the first two).
            Text(daily.waterPresets.count > 2
                 ? String(localized: "A tap on a button logs it at once. Press and hold one to remove it. The first two are also on Today.",
                          comment: "Quick log water footer with three or four buttons: Today shows only the first two")
                 : daily.waterPresets.count > 1
                 ? String(localized: "A tap on a button logs it at once. Press and hold one to remove it.")
                 : String(localized: "A tap on a button logs it at once."))
                .font(.ui(12.5))
                .foregroundStyle(DS.silver.opacity(0.55))
        }
        todayWaterSection
    }

    private var waterSlider: some View {
        let range = DailyStore.waterAmountRange
        return Slider(value: Binding(get: { Double(min(max(waterMl, range.lowerBound), range.upperBound)) },
                                     set: { waterMl = Int(($0 / 50).rounded()) * 50 }),
                      in: Double(range.lowerBound)...Double(range.upperBound), step: 50) {
            Text("Amount")
        } minimumValueLabel: {
            Text(DailyStore.litres(range.lowerBound))
                .font(.ui(12, .medium))
                .foregroundStyle(DS.silver.opacity(0.55))
        } maximumValueLabel: {
            Text(DailyStore.litres(range.upperBound))
                .font(.ui(12, .medium))
                .foregroundStyle(DS.silver.opacity(0.55))
        }
        .tint(DS.silver)
        .accessibilityLabel(String(localized: "Water amount"))
        .accessibilityValue(DailyStore.litres(waterMl))
    }

    /// One row of buttons; four go two by two on the phone.
    private var presetGrid: some View {
        let presets = daily.waterPresets
        let rows = presets.count == 4 && !layout.isRegular ? [Array(presets[0..<2]), Array(presets[2..<4])] : [presets]
        return VStack(spacing: 8) {
            ForEach(rows.indices, id: \.self) { index in
                HStack(spacing: 8) {
                    ForEach(rows[index], id: \.self) { ml in
                        QuickLogPresetChip(ml: ml, canRemove: presets.count > 1,
                                           onTap: { addWater(ml) }, onRemove: { removePreset(ml) })
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var savePresetRow: some View {
        let presets = daily.waterPresets
        if !presets.contains(waterMl) && DailyStore.waterAmountRange.contains(waterMl) {
            if presets.count < Self.maxPresets {
                Button {
                    savePreset(waterMl)
                } label: {
                    Label(String(localized: "Save \(DailyStore.litres(waterMl)) as a button",
                                 comment: "Adds the slider's water amount to the water buttons"),
                          systemImage: "plus.circle")
                        .font(.ui(13.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.8))
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                Text("Up to \(Self.maxPresets) buttons. Press and hold one to remove it, then save this one.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var todayWaterSection: some View {
        let entries = Array(daily.entries(on: Date()).reversed())
        let drunk = daily.waterDrunk(on: Date())
        return Section {
            if entries.isEmpty {
                emptyRow(String(localized: "No water logged yet today."))
            } else {
                ForEach(entries) { entry in
                    entryRow(DailyStore.litres(entry.ml), detail: time(entry.date), symbol: "drop.fill", tint: TodayTone.water)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            deleteButton { deleteWater(entry.id) }
                        }
                }
            }
        } header: {
            sectionHeader(String(localized: "TODAY", comment: "Quick log: today's entries"),
                          trailing: drunk > 0 || showsWaterTarget ? waterTotal(drunk) : nil)
        }
    }

    /// With a heart or kidney condition the amount is the doctor's: no
    /// target unless the user set one (as Today does).
    private var showsWaterTarget: Bool {
        let limitsFluids = store.profile?.health.map { $0.has(.heartDisease) || $0.has(.kidneyDisease) } ?? false
        return !limitsFluids || daily.waterTargetOverride != nil
    }

    private func waterTotal(_ drunk: Int) -> String {
        guard showsWaterTarget else { return DailyStore.litres(drunk) }
        return String(localized: "\(DailyStore.litres(drunk)) of \(DailyStore.litres(daily.waterTarget))",
                      comment: "Water drunk today of the target: 1.25 L of 2.5 L")
    }

    /// "750" "ml", "1.25" "L".
    private static func waterParts(_ ml: Int) -> (value: String, unit: String) {
        if ml < 1_000 {
            return (ml.formatted(), String(localized: "ml", comment: "Unit: millilitres, beside a water amount (750 ml)"))
        }
        return ((Double(ml) / 1_000).formatted(.number.precision(.fractionLength(0...2))),
                String(localized: "L", comment: "Unit: litres, beside a water amount (1.25 L)"))
    }

    private func addWater(_ ml: Int, clearsPhrase: Bool = true) {
        guard ml > 0 else { return }
        let now = Date()
        let before = Set(daily.entries(on: now).map(\.id))
        withAnimation { daily.addWater(ml, at: now) }
        guard let added = daily.entries(on: now).first(where: { !before.contains($0.id) }) else { return }
        showAdded(LastAdd(target: .water(added.id),
                          text: String(localized: "Added \(DailyStore.litres(ml)) of water", comment: "Quick log toast")),
                  clearsPhrase: clearsPhrase)
    }

    private func deleteWater(_ id: UUID) {
        withAnimation { daily.deleteWater(id: id) }
        if lastAdd?.target == .water(id) { lastAdd = nil }
    }

    /// A new button goes last, in the user's order: Today shows the first
    /// two, so they never change under the user's thumb.
    private func savePreset(_ ml: Int) {
        guard !daily.waterPresets.contains(ml), daily.waterPresets.count < Self.maxPresets else { return }
        withAnimation(.easeOut(duration: 0.2)) { daily.waterPresets.append(ml) }
        AccessibilityNotification.Announcement(String(localized: "Saved \(DailyStore.litres(ml)) as a button")).post()
    }

    private func removePreset(_ ml: Int) {
        // At least one button stays.
        guard daily.waterPresets.count > 1 else { return }
        withAnimation(.easeOut(duration: 0.2)) { daily.waterPresets.removeAll { $0 == ml } }
    }

    // MARK: Walk

    @ViewBuilder
    private var walkSections: some View {
        Section {
            VStack(alignment: .leading, spacing: 14) {
                Text("For walks without your phone or Watch. Kept in MUSQ, not written to Apple Health.")
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
                MonoSegmentedControl(options: walkOptions,
                                     selection: Binding(get: { walkMode }, set: { switchWalkMode($0) }),
                                     fontSize: 10.5, itemPaddingV: 8, fillsWidth: true)
                walkValueRow
                Text(walkPreview)
                    .font(.ui(13.5, .semibold))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
                WideButton(title: String(localized: "Add walk"), prominent: true, fontSize: 16, verticalPadding: 14,
                           cornerRadius: 14) { addWalk() }
                    .disabled(walkToAdd == nil)
                    .opacity(walkToAdd == nil ? 0.45 : 1)
            }
            .padding(.vertical, 8)
            .listRowBackground(DS.surface)
        }
        todayWalkSection
    }

    /// Switching keeps the same walk: 30 minutes becomes 3,000 steps and back.
    private func switchWalkMode(_ mode: WalkMode) {
        guard mode != walkMode else { return }
        let pace = QuickLogReading.stepsPerMinute
        switch mode {
        case .minutes:
            if let steps = walkSteps, steps > 0 { walkMinutes = min(600, max(1, Int((Double(steps) / Double(pace)).rounded()))) }
        case .steps:
            if let minutes = walkMinutes, minutes > 0 { walkSteps = minutes * pace }
        }
        walkMode = mode
    }

    private var walkOptions: [(value: WalkMode, title: String)] {
        [(.minutes, String(localized: "MINUTES", comment: "Quick log walk: entered in minutes; one of two segments, keep it short")),
         (.steps, String(localized: "STEPS", comment: "Quick log walk: entered in steps; one of two segments, keep it short"))]
    }

    @ViewBuilder
    private var walkValueRow: some View {
        HStack(spacing: 12) {
            switch walkMode {
            case .minutes:
                QuickNumberField(placeholder: "30", value: $walkMinutes, unit: String(localized: "min", comment: "Minutes, short"),
                                 maxDigits: 3, fieldWidth: 64, focus: $focus, field: .walk,
                                 accessibilityTitle: String(localized: "Minutes walked"))
                Spacer(minLength: 8)
                Stepper(String(localized: "Minutes walked"),
                        value: Binding(get: { walkMinutes ?? 0 }, set: { walkMinutes = $0 }),
                        in: 0...600, step: 5)
                    .labelsHidden()
            case .steps:
                QuickNumberField(placeholder: "3000", value: $walkSteps, unit: String(localized: "steps", comment: "Unit after a step count"),
                                 maxDigits: 6, fieldWidth: 84, focus: $focus, field: .walk,
                                 accessibilityTitle: String(localized: "Steps walked"))
                Spacer(minLength: 8)
                Stepper(String(localized: "Steps walked"),
                        value: Binding(get: { walkSteps ?? 0 }, set: { walkSteps = $0 }),
                        in: 0...100_000, step: 500)
                    .labelsHidden()
            }
        }
    }

    /// The walk the Add button would log: its steps, and its minutes when it
    /// was given in minutes.
    private var walkToAdd: (steps: Int, minutes: Int?)? {
        switch walkMode {
        case .minutes:
            guard let minutes = walkMinutes, minutes > 0, minutes <= 600 else { return nil }
            return (steps: minutes * QuickLogReading.stepsPerMinute, minutes: Optional(minutes))
        case .steps:
            guard let steps = walkSteps, steps > 0, steps <= 100_000 else { return nil }
            return (steps: steps, minutes: nil)
        }
    }

    private var walkPreview: String {
        guard let walk = walkToAdd else {
            return walkMode == .minutes ? String(localized: "Enter the minutes you walked.")
                                        : String(localized: "Enter the steps you walked.")
        }
        let kcal = weightKg.map { WalkSuggestion.walkingKcal(steps: walk.steps, heightCm: heightCm, weightKg: $0) }
        switch walkMode {
        case .minutes:
            if let kcal {
                return String(localized: "≈ \(walk.steps.formatted()) steps · ≈ \(kcal) kcal (estimate)",
                              comment: "Quick log walk preview: ≈ 3,000 steps · ≈ 105 kcal (estimate)")
            }
            return String(localized: "≈ \(walk.steps.formatted()) steps", comment: "Quick log walk preview without a weight")
        case .steps:
            let minutes = max(1, Int((Double(walk.steps) / Double(QuickLogReading.stepsPerMinute)).rounded()))
            if let kcal {
                return String(localized: "≈ \(minutes) min · ≈ \(kcal) kcal (estimate)",
                              comment: "Quick log walk preview: ≈ 30 min · ≈ 105 kcal (estimate)")
            }
            return String(localized: "≈ \(minutes) min of walking", comment: "Quick log walk preview without a weight")
        }
    }

    private var todayWalkSection: some View {
        let entries = Array(daily.stepEntries(on: Date()).reversed())
        let total = stepsToday
        return Section {
            if entries.isEmpty {
                emptyRow(String(localized: "No walks added today."))
            } else {
                ForEach(entries) { entry in
                    entryRow(walkTitle(entry), detail: time(entry.date), symbol: "figure.walk", tint: DS.silver)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            deleteButton { deleteWalk(entry.id) }
                        }
                }
            }
        } header: {
            sectionHeader(String(localized: "TODAY", comment: "Quick log: today's entries"),
                          trailing: total > 0 ? String(localized: "\(total.formatted()) steps", comment: "Steps today: 6,240 steps") : nil)
        } footer: {
            VStack(alignment: .leading, spacing: 6) {
                if let kcal = walkingKcalToday {
                    Text("About \(kcal) kcal from today's walking, an estimate from your steps, height and weight.",
                         comment: "Shown only without Apple Health's active energy")
                        .font(.ui(12.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                }
                Text("Walking energy is never added to your calorie target: your plan's daily activity already counts everyday walking.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    /// Apple Health's steps today plus the ones added by hand.
    private var stepsToday: Int {
        (health.stepsToday ?? 0) + daily.manualSteps(on: Date())
    }

    /// The day's walking energy, only when Apple Health has no active energy
    /// for today (a Watch's own number is better), and only with a weight.
    private var walkingKcalToday: Int? {
        guard health.activeKcalToday == nil, let weightKg, stepsToday > 0 else { return nil }
        let kcal = WalkSuggestion.walkingKcal(steps: stepsToday, heightCm: heightCm, weightKg: weightKg)
        return kcal > 0 ? kcal : nil
    }

    private func walkTitle(_ entry: StepsEntry) -> String {
        if let minutes = entry.minutes {
            return String(localized: "\(entry.steps.formatted()) steps · \(minutes) min", comment: "A walk added by hand: 3,000 steps · 30 min")
        }
        return String(localized: "\(entry.steps.formatted()) steps", comment: "Steps today: 6,240 steps")
    }

    private func addWalk() {
        guard let walk = walkToAdd else { return }
        focus = nil
        let now = Date()
        let before = Set(daily.stepEntries(on: now).map(\.id))
        withAnimation { daily.addSteps(walk.steps, minutes: walk.minutes, at: now) }
        guard let added = daily.stepEntries(on: now).first(where: { !before.contains($0.id) }) else { return }
        showAdded(LastAdd(target: .walk(added.id),
                          text: String(localized: "Added \(walk.steps.formatted()) steps", comment: "Quick log toast")))
    }

    private func deleteWalk(_ id: UUID) {
        withAnimation { daily.deleteSteps(id: id) }
        if lastAdd?.target == .walk(id) { lastAdd = nil }
    }

    // MARK: Food

    /// The app's language ("vi" or "en"), for the food table's names and
    /// words.
    private var foodLocale: String { AIService.appLocale }

    private var hasFoodWords: Bool {
        !phrase.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Foods found on the Food tab, all with their numbers, not in the meal
    /// yet.
    private var pendingDraftsReady: Bool {
        kind == .food && hasFoodWords && !drafts.isEmpty && drafts.allSatisfy(\.isReady)
    }

    /// A meal put together and not logged, or foods found and not added:
    /// closing asks first.
    private var hasUnloggedFood: Bool {
        !mealFoods.isEmpty || (kind == .food && hasFoodWords && !drafts.isEmpty)
    }

    @ViewBuilder
    private var foodSections: some View {
        if hasFoodWords {
            if let otherReading {
                otherReadingSection(otherReading)
            } else {
                switch foodReading {
                case .none:
                    EmptyView()
                case .search(let query, let results, let hasMore):
                    foodMatchesSection(query: query, results: results, hasMore: hasMore)
                case .foods:
                    if !drafts.isEmpty || waterRead != nil { foodsReadSection }
                }
            }
        }
        if !mealFoods.isEmpty { mealSection }
        todayMealsSection
    }

    // MARK: Food: water or a walk

    /// Water or a walk said on the Food tab: a tap adds the water at once
    /// (Undo is in the toast), or fills in the walk on its tab.
    private func otherReadingSection(_ log: QuickLog) -> some View {
        Section {
            switch log {
            case .water(let ml):
                waterRow(ml) { addWater(ml) }
                    .listRowBackground(DS.surface)
            case .steps(let count, let minutes):
                foodLinkRow(minutes.map { String(localized: "Fill in a \($0)-minute walk",
                                                 comment: "Quick log Food tab: walk words typed; moves them to the Walk tab") }
                                ?? String(localized: "Fill in \(count.formatted()) steps",
                                          comment: "Quick log Food tab: steps typed; moves them to the Walk tab"),
                            symbol: "figure.walk") {
                    withAnimation(.easeOut(duration: 0.15)) { fill(log) }
                    setNote(ReadNote(text: filledText(log), filled: true))
                }
            case .food:
                EmptyView()
            }
        } footer: {
            Text("Water and walks have tabs of their own; they don't go in a meal.",
                 comment: "Quick log Food tab: under water or walk words typed there")
                .font(.ui(12.5))
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Food: a name's matches

    /// The table's best matches for a food's name, as it's typed: a tap adds
    /// one at its usual size (one piece, or one serving). More are in the
    /// food search, and a food the table hasn't got can be typed in by hand.
    private func foodMatchesSection(query: String, results: [FoodEntry], hasMore: Bool) -> some View {
        Section {
            if results.isEmpty {
                emptyRow(String(localized: "No foods match “\(query)”.", comment: "Meal scan: the food search found nothing"))
            }
            ForEach(results) { entry in
                Button {
                    // Once: a second tap on the row as it goes adds nothing.
                    guard case .search = foodReading else { return }
                    add(MealReviewFood(entry: entry, locale: foodLocale))
                } label: {
                    MealFoodResultLabel(entry: entry, locale: foodLocale)
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityHint(String(localized: "Adds it to the meal", comment: "VoiceOver hint on a food in the meal scan's food search"))
                .listRowBackground(DS.surface)
            }
            if hasMore {
                foodLinkRow(String(localized: "More foods", comment: "Quick log food: opens the food search with the words typed"),
                            symbol: "magnifyingglass") {
                    open { foodSearch = QuickFoodSearch(request: MealFoodSearchRequest(query: query)) }
                }
            }
            foodLinkRow(String(localized: "Add “\(query)” by hand", comment: "Food search: type in a food the table hasn't got; the words searched"),
                        symbol: "square.and.pencil") {
                open {
                    foodSearch = QuickFoodSearch(request: MealFoodSearchRequest(query: QuickFoodDraft.sentenceCased(query),
                                                                                opensByHand: true))
                }
            }
            .accessibilityHint(String(localized: "Type its calories, and its grams and macros if you know them",
                                      comment: "VoiceOver hint on adding a food by hand"))
        } header: {
            sectionHeader(String(localized: "MATCHING FOODS", comment: "Quick log food: the food table's matches for the name typed"))
        }
    }

    /// Water said on the Food tab: a tap logs it at once, as a water button
    /// does (Undo is in the toast).
    private func waterRow(_ ml: Int, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label {
                Text(QuickLogText.addWaterSaid(ml))
                    .foregroundStyle(DS.silver.opacity(0.85))
            } icon: {
                Image(systemName: "drop.fill")
                    .foregroundStyle(TodayTone.water)
                    .accessibilityHidden(true)
            }
            .font(.ui(14, .semibold))
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    /// A row that opens something: More foods, Add by hand.
    private func foodLinkRow(_ title: String, symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: symbol)
                .font(.ui(14, .semibold))
                .foregroundStyle(DS.silver.opacity(0.8))
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(DS.surface)
    }

    // MARK: Food: the foods read

    /// Each food the words hold, as it would go into the meal, and the
    /// button that adds them all; plain water read with them is water.
    private var foodsReadSection: some View {
        let ready = !drafts.isEmpty && drafts.allSatisfy(\.isReady)
        let kcal = drafts.compactMap { $0.food(locale: foodLocale)?.logged.kcal }.reduce(0, +)
        return Section {
            // By id, so a row that's going away never writes past the end.
            ForEach(drafts) { draft in
                draftRow(binding(for: draft))
                    .listRowBackground(DS.surface)
            }
            if let waterRead {
                VStack(alignment: .leading, spacing: 2) {
                    waterRow(waterRead.ml) { addWaterRead() }
                    Text(String(localized: "Water is logged as water, not in the meal.",
                                comment: "Quick log food: plain water read with foods is logged as water"))
                        .font(.ui(12))
                        .foregroundStyle(DS.silver.opacity(0.45))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 6)
                }
                .listRowBackground(DS.surface)
            }
            if !drafts.isEmpty {
                WideButton(title: QuickLogText.addFoods(drafts.count), prominent: true, fontSize: 16, verticalPadding: 14,
                           cornerRadius: 14) { addDrafts() }
                    .disabled(!ready)
                    .opacity(ready ? 1 : 0.45)
                    .padding(.vertical, 4)
                    .listRowBackground(DS.surface)
            }
        } header: {
            // Their energy once every food has its calories.
            sectionHeader(String(localized: "FOODS FOUND", comment: "Quick log food: the foods read from the words typed or said"),
                          trailing: ready ? String(localized: "\(kcal.formatted()) kcal", comment: "Energy eaten today: 1,240 kcal") : nil)
        } footer: {
            Text(drafts.isEmpty
                 ? String(localized: "Water and walks have tabs of their own; they don't go in a meal.",
                          comment: "Quick log Food tab: under water or walk words typed there")
                 : drafts.contains(where: \.kcalOutOfRange)
                 ? String(localized: "A food's calories go up to 10,000 kcal.",
                          comment: "Quick log food: calories typed by hand past what a food can be")
                 : !ready
                 ? String(localized: "Type the calories of a food MUSQ didn't find, or tap its arrows to pick one from the food table.",
                          comment: "Quick log food: under the foods read, one typed in by hand still needs its calories")
                 : drafts.contains(where: { $0.entry != nil })
                 ? String(localized: "Worked out from MUSQ's food table at the amounts you said. Tap a food to change it; you can adjust the amounts next.",
                          comment: "Quick log food: under the foods read, all ready to add")
                 : String(localized: "Logged with the numbers you gave. Tap the arrows to pick a food from MUSQ's food table instead.",
                          comment: "Quick log food: under foods typed in by hand or said with their calories, all ready to add"))
                .font(.ui(12.5))
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    /// A table food: the whole row opens what it could be instead. A food
    /// typed in by hand: its name, calories and grams to type, with the same
    /// choices on its arrows.
    @ViewBuilder
    private func draftRow(_ draft: Binding<QuickFoodDraft>) -> some View {
        let value = draft.wrappedValue
        if value.entry != nil, let food = value.food(locale: foodLocale) {
            Menu {
                draftMenu(value)
            } label: {
                QuickFoodTableLabel(food: food, caption: value.caption, locale: foodLocale,
                                    withWords: value.parsed.grams == nil)
                    .accessibilityElement(children: .combine)
            }
            .menuOrder(.fixed)
            .buttonStyle(.plain)
            .accessibilityHint(String(localized: "Shows other foods it could be",
                                      comment: "VoiceOver hint on a food read from the words, quick log"))
        } else {
            manualDraftRow(draft)
        }
    }

    private func manualDraftRow(_ draft: Binding<QuickFoodDraft>) -> some View {
        let value = draft.wrappedValue
        let name = value.displayName(locale: foodLocale)
        let isFocused = focus == .draftName(value.id)
        return VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 6) {
                TextField(String(localized: "Food name", comment: "Quick log food: the name of a food typed in by hand"),
                          text: draft.name)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                    .textInputAutocapitalization(.sentences)
                    .focused($focus, equals: .draftName(value.id))
                    .submitLabel(.next)
                    .onSubmit { focus = .draftKcal(value.id) }
                    .padding(.horizontal, 12)
                    .frame(minHeight: 44)
                    .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(DS.silver.opacity(0.06)))
                    .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .strokeBorder(DS.silver.opacity(isFocused ? 0.4 : 0.10), lineWidth: 1))
                Menu {
                    draftMenu(value)
                } label: {
                    QuickFoodChangeGlyph()
                }
                .menuOrder(.fixed)
                .accessibilityLabel(String(localized: "Change \(name)",
                                           comment: "VoiceOver: the choices for a food read from the words, quick log; the food's name"))
            }
            Text(verbatim: value.caption)
                .font(.ui(12))
                .foregroundStyle(DS.silver.opacity(0.45))
                .fixedSize(horizontal: false, vertical: true)
            QuickNumberRow(title: String(localized: "Calories"), value: draft.kcal,
                           unit: String(localized: "kcal", comment: "Unit: kilocalories, beside a number field"),
                           maxDigits: 5, required: true,
                           focus: $focus, field: .draftKcal(value.id),
                           accessibilityTitle: String(localized: "Calories of \(name)",
                                                      comment: "Meal editor: a food's calories, typed; the food's name"))
            QuickNumberRow(title: String(localized: "Grams", comment: "Adding a food by hand: its weight in grams, optional"),
                           value: draft.grams, unit: String(localized: "g", comment: "Unit: grams, beside a number field"),
                           maxDigits: 4, maxValue: Int(MealReviewFood.gramLimits.upperBound),
                           focus: $focus, field: .draftGrams(value.id),
                           accessibilityTitle: String(localized: "Grams of \(name)",
                                                      comment: "Meal scan: a food's exact grams, typed; the food's name"))
        }
        .padding(.vertical, 6)
    }

    /// What a food read could be instead: the parser's match and its next
    /// best from the table (with the amount each comes to), any food from the
    /// search, or one typed in by hand; or it's left out.
    @ViewBuilder
    private func draftMenu(_ draft: QuickFoodDraft) -> some View {
        let candidates = draft.candidates
        if !candidates.isEmpty {
            Section(String(localized: "From MUSQ's food table", comment: "Quick log food: the table foods a food read could be")) {
                ForEach(candidates) { entry in
                    Toggle(isOn: Binding(get: { draft.entry?.id == entry.id },
                                         set: { isOn in if isOn { choose(entry, for: draft.id) } })) {
                        Text(entry.name(foodLocale))
                        Text(verbatim: QuickLogText.amount(QuickFoodDraft.tableFood(entry, read: draft.parsed, locale: foodLocale),
                                                           locale: foodLocale, withWords: draft.parsed.grams == nil))
                    }
                }
            }
        }
        Button(String(localized: "Search foods…", comment: "Quick log food: finds another table food for a food read"),
               systemImage: "magnifyingglass") {
            open { foodSearch = QuickFoodSearch(request: MealFoodSearchRequest(query: draft.parsed.name), draftID: draft.id) }
        }
        if draft.entry != nil {
            Button(String(localized: "Type it in by hand", comment: "Quick log food: a food read, typed in with its own calories"),
                   systemImage: "square.and.pencil") {
                open {
                    foodSearch = QuickFoodSearch(request: MealFoodSearchRequest(query: QuickFoodDraft.sentenceCased(draft.parsed.name),
                                                                                opensByHand: true),
                                                 draftID: draft.id)
                }
            }
        }
        Button(String(localized: "Leave it out", comment: "Quick log food: drops a food read from the words"),
               systemImage: "minus.circle", role: .destructive) {
            leaveOut(draft)
        }
    }

    // MARK: Food: the meal

    /// The meal being put together: its name, its foods (the rows the scan's
    /// review has, Add food under them, the totals), when it was eaten, and
    /// Log meal.
    private var mealSection: some View {
        let now = Date()
        let defaultTitle = QuickLogText.mealTitle(mealFoods)
        return Section {
            VStack(alignment: .leading, spacing: 12) {
                // Empty, the name it takes from its foods shows in full, dim
                // (a placeholder wouldn't wrap); the field grows to show a
                // long name, and Return is done, not a new line.
                ZStack(alignment: .topLeading) {
                    if mealTitle.isEmpty {
                        Text(defaultTitle)
                            .font(.ui(20, .bold))
                            .foregroundStyle(DS.silver.opacity(0.45))
                            .fixedSize(horizontal: false, vertical: true)
                            .allowsHitTesting(false)
                            .accessibilityHidden(true)
                    }
                    TextField("", text: $mealTitle, axis: .vertical)
                        .lineLimit(1...3)
                        .font(.ui(20, .bold))
                        .foregroundStyle(DS.silver)
                        .textInputAutocapitalization(.sentences)
                        .focused($focus, equals: .mealTitle)
                        .submitLabel(.done)
                        .onChange(of: mealTitle) { _, title in
                            guard title.contains(where: \.isNewline) else { return }
                            mealTitle = title.filter { !$0.isNewline }
                            focus = nil
                        }
                        .accessibilityLabel(String(localized: "Meal name"))
                        .accessibilityHint(String(localized: "Left empty, it's named “\(defaultTitle)”",
                                                  comment: "VoiceOver hint on the name of a meal put together in the quick log; the name it takes from its foods"))
                }
                .frame(minHeight: 44)
                Hairline(opacity: 0.07)
                MealItemsEditor(foods: $mealFoods, locale: foodLocale, style: .plain)
                Hairline(opacity: 0.07)
                HStack(spacing: 10) {
                    Text("Eaten", comment: "Meal editor: when the meal was eaten, before a date and time")
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                        .accessibilityHidden(true)
                    Spacer(minLength: 8)
                    DatePicker(String(localized: "Eaten", comment: "Meal editor: when the meal was eaten, before a date and time"),
                               selection: Binding(get: { min(eatenAt ?? now, now) }, set: { eatenAt = $0 }),
                               in: ...now, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(DS.silver)
                }
                // Another day: the meal won't be in today's list.
                if let eatenAt, !Calendar.current.isDate(eatenAt, inSameDayAs: now) {
                    Text(String(localized: "Logs on \(eatenAt.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))), not today.",
                                comment: "Quick log: the meal put together was eaten on another day; the day: Logs on Sat, 21 Nov, not today."))
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
                WideButton(title: String(localized: "Log meal"), prominent: true, fontSize: 16, verticalPadding: 14,
                           cornerRadius: 14) { logMeal() }
                    .confirmationDialog(String(localized: "Some foods found still need their calories",
                                               comment: "Quick log: Log meal tapped while foods read from the words wait for calories typed by hand"),
                                        isPresented: $confirmsLogWithout, titleVisibility: .visible) {
                        Button(String(localized: "Log meal without them",
                                      comment: "Quick log: logs the meal, leaving the foods that still need calories as words")) {
                            logMeal(withDrafts: false)
                        }
                        Button(String(localized: "Cancel"), role: .cancel) {}
                    }
            }
            .padding(.vertical, 8)
            .listRowBackground(DS.surface)
        } header: {
            sectionHeader(String(localized: "THIS MEAL", comment: "Quick log food: the meal being put together, not logged yet"))
        }
    }

    // MARK: Food: today

    private var todayMealsSection: some View {
        let meals = Array(daily.meals(on: Date()).reversed())
        let eaten = daily.eaten(on: Date())
        return Section {
            if meals.isEmpty {
                emptyRow(String(localized: "No meals logged yet today."))
            } else {
                ForEach(meals) { meal in
                    // A tap opens it to change or delete; a swipe shows
                    // Delete (a meal never goes in one long swipe).
                    Button {
                        focus = nil
                        open { editingMeal = meal }
                    } label: {
                        QuickLogMealRow(meal: meal)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint(String(localized: "Opens it to change or delete", comment: "VoiceOver hint on a logged meal on Today"))
                    .listRowBackground(DS.surface)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        deleteButton { deleteMeal(meal.id) }
                    }
                }
            }
        } header: {
            sectionHeader(String(localized: "TODAY", comment: "Quick log: today's entries"),
                          trailing: meals.isEmpty ? nil : String(localized: "\(eaten.kcal.formatted()) kcal",
                                                                  comment: "Energy eaten today: 1,240 kcal"))
        }
    }

    // MARK: Food: actions

    /// Reads the Food tab's words a moment after the last change (at once
    /// when they're done), off the main thread; what the member changed on
    /// a food read just as before stays. Water and walks read as such. A
    /// food at the end the table hasn't got, while its word is typed, waits
    /// for a longer pause.
    private func readFood() async {
        let typed = phrase
        let words = typed.trimmingCharacters(in: .whitespacesAndNewlines)
        guard kind == .food else { return }
        guard !words.isEmpty else {
            clearFoodReading()
            return
        }
        let submitted = isSubmitted
        if !submitted {
            do { try await Task.sleep(for: .milliseconds(300)) } catch { return }
        }
        if let other = waterOrWalk(words) {
            withAnimation(.easeOut(duration: 0.15)) {
                otherReading = other
                foodReading = .none
                drafts = []
                waterRead = nil
            }
            settledWords = words
            announce(filledText(other))
            return
        }
        let locale = foodLocale
        let typing = !submitted && (typed.last?.isLetter ?? false)
        let reading = await Task.detached(priority: .userInitiated) {
            QuickFoodReading.read(words, locale: locale, submitted: submitted, typing: typing)
        }.value
        guard !Task.isCancelled else { return }
        apply(reading, words: words)
        guard typing else {
            settledWords = words
            return
        }
        do { try await Task.sleep(for: .milliseconds(900)) } catch { return }
        let whole = await Task.detached(priority: .userInitiated) {
            QuickFoodReading.read(words, locale: locale, submitted: false, typing: false)
        }.value
        guard !Task.isCancelled else { return }
        if whole != reading { apply(whole, words: words) }
        settledWords = words
    }

    private func apply(_ reading: QuickFoodReading, words: String) {
        // What the member changed waits for its food to read again.
        for draft in drafts where draft.isChanged {
            if let index = changedDrafts.firstIndex(where: { $0.id == draft.id }) {
                changedDrafts[index] = draft
            } else {
                changedDrafts.append(draft)
            }
        }
        // Foods left out stay out while the words up to them do.
        leftOut.removeAll { !words.hasPrefix($0.wordsUpToIt) }
        withAnimation(.easeOut(duration: 0.15)) {
            otherReading = nil
            foodReading = reading
            guard case .foods(let foods) = reading else {
                drafts = []
                waterRead = nil
                return
            }
            var out = leftOut.map(\.food)
            var kept = foods.filter { food in
                guard let index = out.firstIndex(of: food) else { return true }
                out.remove(at: index)
                return false
            }
            // Plain water with the foods is water, never a 0 kcal food.
            let water = kept.filter(Self.isPlainWater)
            kept.removeAll(where: Self.isPlainWater)
            let ml = water.reduce(0) { $0 + Int(($1.amountGrams ?? 250).rounded()) }
            waterRead = water.isEmpty ? nil : (water, min(max(ml, 1), 5_000))
            drafts = QuickFoodDraft.merge(kept, into: drafts, changed: changedDrafts)
        }
        // A field of a row that went away lets go of the keyboard.
        switch focus {
        case .draftName(let id), .draftKcal(let id), .draftGrams(let id):
            if !drafts.contains(where: { $0.id == id }) { focus = nil }
        default:
            break
        }
        announce(readingSummary)
    }

    /// The table's plain water, said without calories.
    nonisolated private static func isPlainWater(_ food: ParsedFood) -> Bool {
        food.match?.id == FoodPhraseParser.waterID && food.kcal == nil && food.proteinG == nil
    }

    /// What the words read as, for VoiceOver: "2 foods found, 155 kcal", "6
    /// matching foods".
    private var readingSummary: String? {
        switch foodReading {
        case .none:
            return nil
        case .search(_, let results, _):
            return results.isEmpty
                ? String(localized: "No matching foods", comment: "VoiceOver: the food table has nothing for the name typed")
                : String(localized: "\(results.count) matching foods", comment: "VoiceOver: the food table's matches for the name typed: 6 matching foods")
        case .foods:
            guard !drafts.isEmpty else { return waterRead.map { QuickLogText.addWaterSaid($0.ml) } }
            let kcal = drafts.compactMap { $0.food(locale: foodLocale)?.logged.kcal }.reduce(0, +)
            let found = drafts.count == 1
                ? String(localized: "1 food found", comment: "VoiceOver: one food read from the words")
                : String(localized: "\(drafts.count) foods found", comment: "VoiceOver: the foods read from the words: 2 foods found")
            guard drafts.allSatisfy(\.isReady) else { return found }
            return String(localized: "\(found), \(kcal.formatted()) kcal", comment: "VoiceOver: 2 foods found, 155 kcal")
        }
    }

    /// Says a reading to VoiceOver when it changes, or once after the mic.
    private func announce(_ text: String?) {
        guard let text, heardFood || voiceOver else { return }
        guard heardFood || text != lastAnnounced else { return }
        heardFood = false
        lastAnnounced = text
        AccessibilityNotification.Announcement(text).post()
    }

    private func clearFoodReading() {
        foodReading = .none
        otherReading = nil
        waterRead = nil
        drafts = []
        changedDrafts = []
        leftOut = []
        submittedWords = nil
        settledWords = nil
    }

    /// A row's draft by its id, so a row that's going away never reads or
    /// writes past the end of the list; a change marks it the member's.
    private func binding(for draft: QuickFoodDraft) -> Binding<QuickFoodDraft> {
        Binding(get: { drafts.first { $0.id == draft.id } ?? draft },
                set: { changed in
                    guard let index = drafts.firstIndex(where: { $0.id == changed.id }) else { return }
                    var changed = changed
                    if changed != drafts[index] { changed.isChanged = true }
                    drafts[index] = changed
                })
    }

    /// The words up to a food's, as typed now.
    private func wordsUpTo(_ food: ParsedFood) -> String {
        let words = phrase.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !food.phrase.isEmpty, let range = words.range(of: food.phrase) else { return words }
        return String(words[..<range.upperBound])
    }

    /// The plain water read with the foods, logged as water at once (Undo is
    /// in the toast); the foods' words stay.
    private func addWaterRead() {
        guard let waterRead else { return }
        leftOut += waterRead.foods.map { LeftOutFood(food: $0, wordsUpToIt: wordsUpTo($0)) }
        self.waterRead = nil
        addWater(waterRead.ml, clearsPhrase: drafts.isEmpty)
    }

    /// The words, and what they read as, cleared for the next food.
    private func clearFoodWords() {
        phrase = ""
        clearFoodReading()
    }

    /// A food into the meal: a match tapped, or one from the food search.
    private func add(_ food: MealReviewFood) {
        focus = nil
        withAnimation(.easeOut(duration: 0.2)) {
            mealFoods.append(food)
            clearFoodWords()
        }
        foodsAdded += 1
        setNote(ReadNote(text: String(localized: "Added \(food.name) to the meal. Add more, or log it.",
                                      comment: "Quick log food: a food went into the meal; its name"),
                         filled: true))
    }

    /// Every food read into the meal, once each has its numbers.
    private func addDrafts() {
        let foods = drafts.compactMap { $0.food(locale: foodLocale) }
        guard let first = foods.first, foods.count == drafts.count else { return }
        focus = nil
        withAnimation(.easeOut(duration: 0.2)) {
            mealFoods += foods
            clearFoodWords()
        }
        foodsAdded += 1
        setNote(ReadNote(text: foods.count == 1
                         ? String(localized: "Added \(first.name) to the meal. Add more, or log it.",
                                  comment: "Quick log food: a food went into the meal; its name")
                         : String(localized: "Added \(foods.count) foods to the meal. Add more, or log it.",
                                  comment: "Quick log food: the foods read went into the meal: Added 2 foods to the meal"),
                         filled: true))
    }

    /// A food read is this table food instead, at the amount said.
    private func choose(_ entry: FoodEntry, for draftID: UUID) {
        guard let index = drafts.firstIndex(where: { $0.id == draftID }) else { return }
        withAnimation(.easeOut(duration: 0.15)) {
            drafts[index].entry = entry
            drafts[index].isChanged = true
        }
    }

    /// From the food search: into the meal, or in place of a food read (a
    /// table food at the amount said, or one typed in by hand).
    private func picked(_ food: MealReviewFood, for draftID: UUID?) {
        guard let draftID else {
            add(food)
            return
        }
        guard let index = drafts.firstIndex(where: { $0.id == draftID }) else { return }
        if let entry = food.entry {
            drafts[index].entry = entry
            drafts[index].isChanged = true
        } else {
            drafts[index].typeIn(food)
        }
    }

    private func leaveOut(_ draft: QuickFoodDraft) {
        // A field of the row going away lets go of the keyboard first.
        switch focus {
        case .draftName(draft.id), .draftKcal(draft.id), .draftGrams(draft.id): focus = nil
        default: break
        }
        withAnimation(.easeOut(duration: 0.15)) { drafts.removeAll { $0.id == draft.id } }
        changedDrafts.removeAll { $0.id == draft.id }
        leftOut.append(LeftOutFood(food: draft.parsed, wordsUpToIt: wordsUpTo(draft.parsed)))
    }

    /// The meal as it's set: its foods with the table's numbers (or the ones
    /// typed), its name (its foods' when none is typed) and its time. Foods
    /// found and not added yet go in too (`withDrafts`); with some still
    /// needing calories, it asks first.
    private func logMeal(withDrafts: Bool = true) {
        if withDrafts, kind == .food, hasFoodWords, !drafts.isEmpty {
            guard drafts.allSatisfy(\.isReady) else {
                focus = nil
                confirmsLogWithout = true
                return
            }
            addDrafts()
        }
        guard !mealFoods.isEmpty else { return }
        focus = nil
        let typed = mealTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let title = typed.isEmpty ? QuickLogText.mealTitle(mealFoods) : typed
        let meal = MealEntry(date: min(eatenAt ?? Date(), Date()), title: title, items: mealFoods.map(\.logged),
                             source: .manual)
        withAnimation {
            daily.addMeal(meal)
            mealFoods = []
            mealTitle = ""
            eatenAt = nil
        }
        note = nil
        // Words typed for the next meal stay in the field.
        showAdded(LastAdd(target: .meal(meal.id), text: String(localized: "Logged \(title)", comment: "Quick log toast: Logged Chicken rice")),
                  clearsPhrase: false)
    }

    /// Done: with a meal not logged yet, or foods found and not added, asks
    /// first.
    private func close() {
        guard hasUnloggedFood else {
            dismiss()
            return
        }
        focus = nil
        confirmsClose = true
    }

    private func deleteMeal(_ id: UUID) {
        withAnimation { daily.deleteMeal(id: id) }
        if lastAdd?.target == .meal(id) { lastAdd = nil }
    }

    // MARK: Shared pieces

    private var heightCm: Double { store.profile?.heightCm ?? 170 }

    /// The 7-day average weigh-in, else the profile's weight; nil without
    /// either, and then no energy estimate is shown.
    private var weightKg: Double? { daily.trendWeight() ?? store.profile?.weightKg }

    private func time(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }

    private func sectionHeader(_ title: String, trailing: String? = nil) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.mono(10.5, .semibold))
                .trackingEm(0.10, size: 10.5)
                .foregroundStyle(DS.silver.opacity(0.6))
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 8)
            if let trailing {
                Text(trailing)
                    .font(.ui(13, .semibold))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver.opacity(0.7))
            }
        }
        .textCase(nil)
    }

    private func emptyRow(_ text: String) -> some View {
        Text(text)
            .font(.ui(14))
            .foregroundStyle(DS.silver.opacity(0.6))
            .padding(.vertical, 4)
            .listRowBackground(DS.surface)
    }

    private func entryRow(_ title: String, detail: String, symbol: String, tint: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 28, height: 28)
                .background(Circle().fill(tint.opacity(0.14)))
                .accessibilityHidden(true)
            Text(title)
                .font(.ui(15.5, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver)
            Spacer(minLength: 8)
            Text(detail)
                .font(.ui(13))
                .monospacedDigit()
                .foregroundStyle(DS.silver.opacity(0.6))
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
        .listRowBackground(DS.surface)
    }

    private func deleteButton(_ action: @escaping () -> Void) -> some View {
        Button(role: .destructive, action: action) {
            Label(String(localized: "Delete"), systemImage: "trash")
        }
    }

    // MARK: Toast

    @ViewBuilder
    private var toast: some View {
        if let lastAdd {
            HStack(spacing: 8) {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .accessibilityHidden(true)
                Text(lastAdd.text)
                    .font(.ui(13.5, .semibold))
                    .lineLimit(2)
                Button {
                    undo(lastAdd)
                } label: {
                    Text("Undo")
                        .font(.ui(13.5, .bold))
                        .foregroundStyle(DS.ink)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(localized: "Undo: \(lastAdd.text)", comment: "VoiceOver: undo the last quick log"))
            }
            .foregroundStyle(DS.ink)
            .padding(.leading, 16)
            .padding(.trailing, 4)
            .background(Capsule().fill(DS.silver))
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.bottom, 12)
            .accessibilityElement(children: .contain)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private func showAdded(_ add: LastAdd, clearsPhrase: Bool = true) {
        withAnimation(.easeOut(duration: 0.2)) { lastAdd = add }
        addCount += 1
        // What filled the form has been logged.
        if clearsPhrase {
            note = nil
            phrase = ""
        }
        AccessibilityNotification.Announcement(add.text).post()
    }

    private func undo(_ add: LastAdd) {
        withAnimation(.easeOut(duration: 0.2)) {
            switch add.target {
            case .water(let id): daily.deleteWater(id: id)
            case .walk(let id): daily.deleteSteps(id: id)
            case .meal(let id):
                let meal = daily.meals.first { $0.id == id }
                daily.deleteMeal(id: id)
                // Logged too soon: its foods, name and time come back to the
                // meal being put together, to add to and log again.
                if let meal, mealFoods.isEmpty {
                    let foods = meal.items.map { MealReviewFood(saved: $0, mealSource: meal.source, locale: foodLocale) }
                    mealFoods = foods
                    mealTitle = meal.title == QuickLogText.mealTitle(foods) ? "" : meal.title
                    eatenAt = abs(meal.date.timeIntervalSince(add.at)) < 60 ? nil : meal.date
                }
            }
            lastAdd = nil
        }
    }
}

// MARK: - State types

private enum WalkMode: Hashable {
    case minutes, steps
}

/// What the last reading of a phrase came to.
private struct ReadNote: Equatable {
    var text: String
    /// Filled in the form (true), or not understood.
    var filled: Bool
}

/// The last thing added, for the toast's Undo.
private struct LastAdd: Identifiable, Equatable {
    enum Target: Equatable {
        case water(UUID), walk(UUID), meal(UUID)
    }

    let id = UUID()
    var target: Target
    var text: String
    /// When it was added.
    var at = Date()
}

/// The food search, open: to add a food to the meal, or in place of a food
/// read from the words (`draftID`).
private struct QuickFoodSearch: Identifiable {
    let id = UUID()
    var request: MealFoodSearchRequest
    var draftID: UUID? = nil
}

/// A food read and left out, and the words up to it as they were then: it
/// stays out while they do, and comes back when they're deleted or replaced.
private struct LeftOutFood: Equatable {
    var food: ParsedFood
    var wordsUpToIt: String
}

/// The Food tab's words, and whether they're done (Return, the mic).
private struct FoodWords: Hashable {
    var text: String
    var submitted: Bool
}

// MARK: - Launch preview (DEBUG)

#if DEBUG
/// `-quicklog.preview <mode> ["<words>"]` opens the quick log's Food tab from
/// Today's Meals, for screenshots, with no microphone: `food` with the words
/// typed and read (default "một tô phở bò tái và hai quả trứng luộc");
/// `food-search` the same for a food's name, whose matches list live
/// (default "com tam"); `food-added` with the foods read already in the meal;
/// `food-listening` the mic hearing the words. `meals` instead scrolls Today
/// to its Meals section and its ways in. Compiled out of Release.
enum QuickLogLaunchPreview: String {
    case food, foodSearch = "food-search", foodAdded = "food-added", foodListening = "food-listening", meals

    static let requested: QuickLogLaunchPreview? = {
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: "-quicklog.preview") else { return nil }
        let next = index + 1 < arguments.count ? arguments[index + 1] : ""
        return QuickLogLaunchPreview(rawValue: next) ?? .food
    }()

    /// The words after the mode ("" for the empty tab), else the mode's own.
    static let words: String = {
        let arguments = ProcessInfo.processInfo.arguments
        if let index = arguments.firstIndex(of: "-quicklog.preview"), index + 2 < arguments.count,
           !arguments[index + 2].hasPrefix("-") {
            return arguments[index + 2]
        }
        return requested == .foodSearch ? "com tam" : "một tô phở bò tái và hai quả trứng luộc"
    }()

    /// Opened once a launch, not again whenever Today comes back.
    static var hasOpened = false
    private static var isTaken = false

    /// The requested preview for the first quick log of the launch; nil for
    /// every later one.
    static func takePending() -> QuickLogLaunchPreview? {
        guard !isTaken else { return nil }
        isTaken = true
        return requested
    }

    /// Scrolls the screen's tallest scroll view (Today's) so a view whose
    /// top is at `top`, in window points, sits just under the status bar.
    static func scroll(toTop top: CGFloat) {
        let windows = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap(\.windows)
        guard let window = windows.first(where: \.isKeyWindow) ?? windows.first else { return }
        var tallest: UIScrollView?
        func visit(_ view: UIView) {
            if let scroll = view as? UIScrollView, scroll.contentSize.height > scroll.bounds.height,
               scroll.contentSize.height > (tallest?.contentSize.height ?? 0) {
                tallest = scroll
            }
            view.subviews.forEach(visit)
        }
        visit(window)
        guard let scroll = tallest else { return }
        let lowest = -scroll.adjustedContentInset.top
        let highest = max(lowest, scroll.contentSize.height + scroll.adjustedContentInset.bottom - scroll.bounds.height)
        let target = scroll.contentOffset.y + top - window.safeAreaInsets.top - 12
        scroll.setContentOffset(CGPoint(x: scroll.contentOffset.x, y: min(max(target, lowest), highest)), animated: false)
    }
}

extension QuickLogContent {
    /// The launch preview's words on the Food tab, through the same paths as
    /// typing (`readFood`) and the Add button (`addDrafts`).
    fileprivate func applyLaunchPreview() {
        guard kind == .food, phrase.isEmpty, mealFoods.isEmpty, let preview = QuickLogLaunchPreview.takePending() else { return }
        let words = QuickLogLaunchPreview.words
        switch preview {
        case .food, .foodSearch:
            phrase = words
        case .foodAdded:
            apply(QuickFoodReading.read(words, locale: foodLocale), words: words)
            addDrafts()
        case .foodListening:
            if showsMic {
                wantsListening = true
                voice.previewListening(heard: words)
            }
        case .meals:
            break
        }
    }
}
#endif

// MARK: - Previews

private struct QuickLogPreview: View {
    var kind: QuickLogKind
    var device: DSPreviewDevice = .phone

    @State private var daily = DailyStore(fileURL: URL.temporaryDirectory.appending(path: "quicklog-preview-daily.json"))
    @State private var store = WorkoutStore(fileURL: URL.temporaryDirectory.appending(path: "quicklog-preview-store.json"))
    @State private var health = AppleHealth()

    var body: some View {
        QuickLogSheet(kind: kind)
            .environment(daily)
            .environment(store)
            .environment(health)
            .dsPreview(device)
    }
}

#Preview("Quick log · water") {
    QuickLogPreview(kind: .water)
}

#Preview("Quick log · walk · dark") {
    QuickLogPreview(kind: .steps)
        .preferredColorScheme(.dark)
}

#Preview("Quick log · food · iPad") {
    QuickLogPreview(kind: .food, device: .pad11Portrait750)
}
