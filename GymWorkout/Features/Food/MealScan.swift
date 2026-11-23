//
//  MealScan.swift
//  GymWorkout
//
//  Premium meal logging from a photo (2026-11-21), Cal AI-style: take or
//  pick a photo, MUSQ's server asks the AI for the foods, grams, calories
//  and macros, and the member checks and adjusts each item before it's
//  logged. Every number is an estimate and says so. The meals live in
//  DailyStore on this device; the photo is never kept.
//
//  Typed meals (2026-11-22): anyone can type a meal in from the quick log
//  (`QuickLogSheet`, "Log food" here), free. They carry a TYPED badge, and
//  show their macros only when some were given. Since 2026-11-23 the quick
//  log finds each food said or typed in MUSQ's food table and works out its
//  calories and macros on the device, so "Log food" is the way in for every
//  member, and Pro members have "Scan a meal" beside it.
//
//  The food table (2026-11-22, owner-approved rules): the server matches the
//  foods it recognizes to MUSQ's food table (`FoodTable`) and works out their
//  energy and macros from it; anything else keeps the AI's own estimate.
//  Counted foods (an egg, a bánh mì) step by the piece the server sent:
//  eighths below one piece of 200 g or more (a slice of a whole pizza),
//  quarters below one otherwise, halves to three, whole pieces above; foods
//  by amount (phở, rice) get a gram slider, and their grams can be typed. A
//  table food works its energy, macros and hidden fat and sugar out from the
//  table at the amount set, as "Add food" does, when this app's table is the
//  version the server used; an estimate, or a table food from another
//  version, follows the grams (or, with no weight, the count) in proportion.
//  "Add food" adds one from the table, and cooking words before the scan go
//  in the note. The meal is logged with what the scan sent (and the AI
//  model's own grams and kcal for a table food) beside the member's edits.
//
//  Editing and speaking (2026-11-22, owner-approved): the review's rows,
//  food search and totals are `MealItemsEditor` (MealEditor.swift), which a
//  logged meal opened from Today with a tap (`MealEditSheet`) and the typed
//  log share. The note before a scan can be spoken (iOS 26, heard on the
//  device in the app's language by `VoiceInput`): a tap on the mic starts
//  and another stops, and what was heard is added to the note.
//

import ImageIO
import PhotosUI
import SwiftUI
import UIKit

/// Whether an AI feature can start now, and what to show if not.
enum AIGate {
    case ready, paywall, signIn, consent

    @MainActor
    static func check(isPremium: Bool, consent: AIService.Consent) -> AIGate {
        if !isPremium { return .paywall }
        if !AccountService.shared.isSignedIn { return .signIn }
        if !consent.isGiven { return .consent }
        return .ready
    }
}

// MARK: - Today block

/// Today's meals and what they add up to against the plan, with the ways in
/// to logging one by words (free, on the device) and to a scan (Pro's).
struct TodayMealsSection: View {
    var metrics: TodayMetrics

    @Environment(DailyStore.self) private var daily
    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall
    @Environment(\.colorScheme) private var scheme
    @State private var showsScan = false
    /// The quick log's Food tab: what was eaten, said or typed, found in
    /// MUSQ's food table.
    @State private var showsFoodLog = false
    #if DEBUG
    /// Where the section starts on screen, for `-quicklog.preview meals`.
    @State private var previewTop: CGFloat = 0
    #endif
    @State private var gate: AIGate?
    /// Signed in or agreed in a gate sheet: carry on once it has closed,
    /// since a new sheet can't open while one is still closing.
    @State private var resumesAfterGate = false
    /// The meal a tap opened, to change or delete.
    @State private var editingMeal: MealEntry?

    var body: some View {
        let meals = daily.meals(on: metrics.now)
        let eaten = daily.eaten(on: metrics.now)
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("Meals", comment: "Today: the day's logged meals")
                    .font(.ui(20, .bold))
                    .tracking(-0.3)
                    .foregroundStyle(DS.silver)
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 8)
                if let target = metrics.calories {
                    Text("\(eaten.kcal.formatted()) / \(target.formatted()) kcal", comment: "Meals eaten against the plan: 1,240 / 2,020 kcal")
                        .font(.ui(13.5, .semibold))
                        .monospacedDigit()
                        .foregroundStyle(DS.silver.opacity(0.65))
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                if meals.isEmpty {
                    Text(!AIService.isLive
                         ? String(localized: "Say or type what you ate: MUSQ finds each food and works out its calories and macros. It counts toward your Balance.",
                                  comment: "Today's meals, none yet: logging by words, the only way in")
                         : canScan
                         ? String(localized: "Photograph a meal, or say or type what you ate: MUSQ works out the calories and macros for you to check.",
                                  comment: "Today's meals, none yet, for a member with meal scans")
                         : String(localized: "Say or type what you ate, and MUSQ works out the calories and macros. Reading a meal from a photo is part of MUSQ Pro.",
                                  comment: "Today's meals, none yet, for a member without meal scans"))
                        .font(.ui(14))
                        .foregroundStyle(DS.silver.opacity(0.65))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 14)
                } else {
                    ForEach(meals) { meal in
                        // A tap opens it to change or delete.
                        Button {
                            editingMeal = meal
                        } label: {
                            MealRow(meal: meal)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .dsHover(.highlight, radius: 10)
                        .accessibilityHint(String(localized: "Opens it to change or delete",
                                                  comment: "VoiceOver hint on a logged meal on Today"))
                        .contextMenu {
                            Button(String(localized: "Delete meal"), systemImage: "trash", role: .destructive) {
                                withAnimation { daily.deleteMeal(id: meal.id) }
                            }
                        }
                        if meal.id != meals.last?.id { Hairline(opacity: 0.07) }
                    }
                    if let target = metrics.calories {
                        Hairline(opacity: 0.07)
                        // A typed meal often has calories only: its zero
                        // grams aren't "no protein" (MealRow's rule).
                        MacroSummary(eaten: eaten, targetKcal: target, protein: metrics.protein, fat: metrics.fat, carbs: metrics.carbs,
                                     macroMeals: meals.filter { MacroSummary.carriesMacros($0) }.count, mealCount: meals.count)
                            .padding(.vertical, 12)
                    }
                }
                // Logging by words is free for everyone; the scan is Pro's.
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) { mealChips }
                    VStack(alignment: .leading, spacing: 0) { mealChips }
                }
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface)
                .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.05), radius: 16, y: 6))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(DS.silver.opacity(scheme == .dark ? 0.08 : 0.04), lineWidth: 1))
        }
        .sheet(isPresented: $showsScan) {
            MealScanSheet()
                .environment(daily)
        }
        .sheet(isPresented: $showsFoodLog) {
            QuickLogSheet(kind: .food)
                .environment(daily)
        }
        .sheet(item: $gate, onDismiss: resume) { gate in
            switch gate {
            case .signIn: AISignInPrompt { resumesAfterGate = true }
            case .consent: AIConsentSheet(feature: .meal) { resumesAfterGate = true }
            case .paywall, .ready: EmptyView()
            }
        }
        .sheet(item: $editingMeal) { meal in
            MealEditSheet(meal: meal)
                .environment(daily)
        }
        // The food table, then the phrase reader's index, read off the main
        // thread as Today opens: a meal opened in the editor reads the
        // table on the main thread, and the quick log reads phrases.
        .task {
            await Task.detached(priority: .userInitiated) { _ = FoodTable.shared.version }.value
            await Task.detached(priority: .utility) { FoodPhraseParser.prepare() }.value
        }
        #if DEBUG
        .onGeometryChange(for: CGFloat.self) { $0.frame(in: .global).minY } action: { previewTop = $0 }
        // `-mealscan.preview`: the scan sheet, or the editor on a logged
        // meal (`edit…`), opens on fixtures, which it takes itself
        // (`MealScanPreview.takePending`). `-quicklog.preview`: the quick
        // log's Food tab on words (`QuickLogLaunchPreview`), or Today
        // scrolled to this section (`meals`). The self-tests run once the
        // table and the index are read off the main thread, as in Release.
        .task {
            await Task.detached(priority: .userInitiated) { FoodPhraseParser.prepare() }.value
            MealScanPreview.checkSavedMeals()
            if let preview = QuickLogLaunchPreview.requested, !QuickLogLaunchPreview.hasOpened {
                QuickLogLaunchPreview.hasOpened = true
                if preview == .meals {
                    // Once Today has laid out.
                    try? await Task.sleep(for: .milliseconds(900))
                    QuickLogLaunchPreview.scroll(toTop: previewTop)
                } else {
                    showsFoodLog = true
                }
                return
            }
            guard let preview = MealScanPreview.requested, !MealScanPreview.hasOpened else { return }
            MealScanPreview.hasOpened = true
            if preview.opensEditor {
                editingMeal = MealScanPreview.savedMeal(locale: AIService.appLocale)
            } else {
                showsScan = true
            }
        }
        #endif
    }

    /// "Log food" for everyone: said or typed, found in the food table on
    /// the device. The scan needs the AI service, live only in Debug until
    /// the privacy go-live: a Pro member's comes first, beside "Log food";
    /// anyone else's comes after it and opens the paywall.
    @ViewBuilder
    private var mealChips: some View {
        if AIService.isLive && canScan { scanChip }
        QuickChip(title: String(localized: "Log food", comment: "Today: log a meal by saying or typing what was eaten"),
                  symbol: "fork.knife") { showsFoodLog = true }
            .accessibilityHint(String(localized: "Say or type what you ate", comment: "VoiceOver hint on Today's Log food"))
        if AIService.isLive && !canScan { scanChip }
    }

    private var scanChip: some View {
        QuickChip(title: String(localized: "Scan a meal"), symbol: "camera.viewfinder") { start() }
    }

    private func resume() {
        guard resumesAfterGate else { return }
        resumesAfterGate = false
        start()
    }

    /// Meal scans come with Pro only (Premium has none, since each scan
    /// costs money); the paywall offers Pro to everyone else.
    private var canScan: Bool { (purchases.tier.ai?.mealScansPerDay ?? 0) > 0 }

    private func start() {
        switch AIGate.check(isPremium: canScan, consent: .meal) {
        case .ready: showsScan = true
        case .paywall: paywall.show(.mealScan)
        case .signIn: gate = .signIn
        case .consent: gate = .consent
        }
    }
}

extension AIGate: Identifiable {
    var id: Self { self }
}

/// One logged meal: what, when, and its energy.
private struct MealRow: View {
    var meal: MealEntry

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(meal.title.isEmpty ? String(localized: "Meal") : meal.title)
                        .font(.ui(15.5, .semibold))
                        .foregroundStyle(DS.silver)
                        .lineLimit(2)
                    // A meal typed in by hand says so (see QuickLogSheet).
                    MealSourceBadge(source: meal.source)
                }
                // A typed meal without macros shows its time only, not "P 0 g".
                Text(meal.detailLine)
                    .font(.ui(12.5))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver.opacity(0.6))
            }
            Spacer(minLength: 8)
            BigValue(value: meal.kcal.formatted(), unit: "kcal", size: 18)
        }
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
    }
}

/// Eaten against the plan, with what's left. The macros only from meals
/// that carry them: none says so instead of "Protein 0 g", and some marks
/// the totals as partial.
private struct MacroSummary: View {
    var eaten: (kcal: Int, proteinG: Int, fatG: Int, carbsG: Int)
    var targetKcal: Int
    var protein: Int?
    var fat: Int?
    var carbs: Int?
    /// Today's meals with macros (`carriesMacros`), of `mealCount`.
    var macroMeals: Int
    var mealCount: Int

    /// Whether a meal's macros mean something, food by food
    /// (`MealEntry.carriesMacros`, the rule `MealEntry.detailLine` uses).
    static func carriesMacros(_ meal: MealEntry) -> Bool {
        meal.carriesMacros
    }

    var body: some View {
        let left = targetKcal - eaten.kcal
        VStack(alignment: .leading, spacing: 8) {
            ProgressBar(value: Double(eaten.kcal) / Double(max(targetKcal, 1)), color: DS.silver.opacity(0.85))
            Text(left >= 0
                 ? String(localized: "\(left.formatted()) kcal left today", comment: "Meals: 780 kcal left today")
                 : String(localized: "\((-left).formatted()) kcal over today's plan", comment: "Meals: 120 kcal over today's plan"))
                .font(.ui(13, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver.opacity(0.75))
            if macroMeals == 0 {
                Text(String(localized: "Macros not logged", comment: "Today's meals: none of them has protein, fat or carbs, only calories"))
                    .font(.ui(12.5, .medium))
                    .foregroundStyle(DS.silver.opacity(0.55))
            } else {
                HStack(spacing: 14) {
                    macro(String(localized: "Protein", comment: "Macro"), eaten.proteinG, protein)
                    macro(String(localized: "Fat", comment: "Macro"), eaten.fatG, fat)
                    macro(String(localized: "Carbs", comment: "Macro"), eaten.carbsG, carbs)
                }
                if macroMeals < mealCount {
                    Text(String(localized: "Macros from \(macroMeals) of \(mealCount) meals",
                                comment: "Today's macro totals are partial: only some meals have protein, fat and carbs; Macros from 2 of 3 meals"))
                        .font(.ui(12))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private func macro(_ name: String, _ grams: Int, _ target: Int?) -> some View {
        Text(target.map { String(localized: "\(name) \(grams)/\($0) g", comment: "Macro eaten of target: Protein 90/148 g") }
             ?? String(localized: "\(name) \(grams) g", comment: "A macro and its grams: Protein 150 g"))
            .font(.ui(12.5, .medium))
            .monospacedDigit()
            .foregroundStyle(DS.silver.opacity(0.65))
    }
}

// MARK: - Scan sheet

/// Pick or take a photo, wait for the read, check and adjust, log.
struct MealScanSheet: View {
    @Environment(DailyStore.self) private var daily
    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases
    @Environment(\.dismiss) private var dismiss

    private enum Phase: Equatable {
        case choose
        case reading
        case review
        /// The AI found no food in the photo.
        case notFood
        /// Today's scans are used up.
        case limit
        case failed(String, canRetry: Bool)
    }

    @State private var phase: Phase = .choose
    @State private var photo: UIImage?
    @State private var note = ""
    @State private var pickerItem: PhotosPickerItem?
    /// The newest pick still loading from the library; older ones are dropped.
    @State private var loadID: UUID?
    @State private var loadFailed = false
    @State private var showsCamera = false
    @State private var title = ""
    /// The foods as the member has them now (see `MealReviewFood`).
    @State private var foods: [MealReviewFood] = []
    @State private var confidence = "medium"
    @State private var aiNote = ""
    @State private var remaining: Int?
    @State private var showsSignIn = false
    @State private var showsPro = false
    /// The food search, open; with what it opens with (the preview's "pho").
    @State private var addFood: MealFoodSearchRequest?
    /// The note's mic (iOS 26), heard on the device in the app's language.
    @State private var voice = VoiceInput()
    /// Whether the mic should be on. False once it's tapped off, so a mic
    /// that only becomes ready after that stops at once.
    @State private var wantsListening = false
    /// What the last listen came to, when it added nothing to the note.
    @State private var micMessage: String?
    /// The mic being stopped and its words going into the note: one at a
    /// time, and every other stop waits for it.
    @State private var finishing: Task<Void, Never>?
    /// Read this meal, waiting for the mic to stop first; closing the sheet
    /// cancels it.
    @State private var pendingRead: Task<Void, Never>?
    @Environment(\.openURL) private var openURL

    /// The member's language, for the food table's names and words.
    private var locale: String { AIService.appLocale }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let photo {
                        // A minimum width too, so a wide photo is cropped to
                        // the column instead of widening the sheet.
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay {
                                if phase == .reading {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.black.opacity(0.45))
                                    VStack(spacing: 10) {
                                        ProgressView().tint(.white)
                                        Text("Reading your meal…")
                                            .font(.ui(15, .semibold))
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .accessibilityLabel(String(localized: "Meal photo"))
                    }
                    switch phase {
                    case .choose: chooser
                    case .reading: EmptyView()
                    case .review: review
                    case .notFood: notFood
                    case .limit: limit
                    case .failed(let message, let canRetry): failure(message, canRetry: canRetry)
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.bottom, 24)
            }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Scan a meal"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
        }
        .onChange(of: pickerItem) { _, item in load(item) }
        // The server keeps 200 characters of a note; the field keeps no more,
        // so what's sent is what's shown.
        .onChange(of: note) { _, text in
            if text.utf16.count > MealNote.maxLength { note = MealNote.capped(text) }
            // Typed, picked or heard since: a word on the last listen is old.
            micMessage = nil
        }
        // The screen stays on while the meal is read, so the answer isn't lost
        // to a locked phone. A word on the last listen belongs to the photo
        // step.
        .onChange(of: phase) { _, phase in
            UIApplication.shared.isIdleTimerDisabled = phase == .reading
            if phase != .choose { micMessage = nil }
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            // Closed while listening: the mic lets go, and a read waiting for
            // it never starts.
            wantsListening = false
            pendingRead?.cancel()
            Task { await voice.stop() }
        }
        // Read off the main thread before the review needs it.
        .task { await Task.detached(priority: .utility) { _ = FoodTable.shared.version }.value }
        #if DEBUG
        .onAppear(perform: applyPreview)
        #endif
        .fullScreenCover(isPresented: $showsCamera) {
            CameraPicker { image in photo = image; loadFailed = false }
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showsSignIn) { AISignInPrompt { read() } }
        // From the limit: upgraded to Pro, the same photo can be read now.
        .sheet(isPresented: $showsPro, onDismiss: { if purchases.isPro { phase = .choose } }) {
            PremiumView(reason: .mealScan, profile: store.profile)
                .environment(purchases)
        }
    }

    // MARK: Phases

    private var chooser: some View {
        VStack(alignment: .leading, spacing: 14) {
            if photo == nil {
                Text("Photograph the whole plate from above, in good light. Everything on it counts, sauces included.")
                    .font(.ui(14.5))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            if loadID != nil {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Loading the photo…")
                }
                .font(.ui(13.5))
                .foregroundStyle(DS.silver.opacity(0.65))
            } else if loadFailed {
                Text("That photo couldn't be loaded. Try another one.")
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
            HStack(spacing: 10) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    WideButton(title: String(localized: "Take photo"), prominent: photo == nil, fontSize: 15, verticalPadding: 13) {
                        // The camera never opens over a live mic: what was
                        // heard goes in the note first.
                        Task {
                            await stopListeningNow()
                            showsCamera = true
                        }
                    }
                }
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Text(photo == nil ? String(localized: "Choose photo") : String(localized: "Another photo"))
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(DS.silver.opacity(0.07)))
                }
                .buttonStyle(.plain)
            }
            if photo != nil {
                HStack(alignment: .top, spacing: 10) {
                    TextField(String(localized: "Add a note (optional), e.g. “fried in butter”"), text: $note, axis: .vertical)
                        .font(.ui(15))
                        .lineLimit(1...3)
                        .padding(12)
                        .frame(minHeight: showsMic ? 44 : nil)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(DS.surface))
                    if showsMic {
                        let canTap = finishing == nil && pendingRead == nil && (isListening || noteHasRoom)
                        MealNoteMicButton(state: voice.state, action: toggleListening)
                            .disabled(!canTap)
                            .opacity(canTap ? 1 : 0.4)
                    }
                }
                noteVoiceStatus
                cookingChips
                let canRead = loadID == nil && pendingRead == nil
                WideButton(title: String(localized: "Read this meal"), prominent: true, fontSize: 16, verticalPadding: 14,
                           cornerRadius: 14) { read() }
                    .disabled(!canRead)
                    .opacity(canRead ? 1 : 0.5)
            }
        }
    }

    private var review: some View {
        VStack(alignment: .leading, spacing: 14) {
            TextField(String(localized: "Meal name"), text: $title)
                .font(.ui(22, .bold))
                .foregroundStyle(DS.silver)
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                Text(confidenceText)
            }
            .font(.ui(12.5, .semibold))
            .foregroundStyle(DS.silver.opacity(0.65))
            // The foods, Add food (from the table only) and the totals.
            MealItemsEditor(foods: $foods, locale: locale, allowsManualFoods: false, search: $addFood)
            if !aiNote.isEmpty {
                Text(aiNote)
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Text("Estimates from a photo can be off by 20% or more. Adjust the portions to match what you ate.")
                .font(.ui(12.5))
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
            WideButton(title: String(localized: "Log meal"), prominent: true, fontSize: 16, verticalPadding: 14, cornerRadius: 14) {
                log()
            }
            .disabled(foods.isEmpty)
            .opacity(foods.isEmpty ? 0.5 : 1)
            if let remaining {
                Text(remaining == 1 ? String(localized: "1 scan left today") : String(localized: "\(remaining) scans left today"))
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    /// The member holds Pro but the server still counted Premium's
    /// allowance: its record hasn't caught up with the upgrade yet.
    private var serverBehindPro: Bool {
        purchases.isPro && AIService.shared.limitAfterFailure["scanMeal"]?.tier == "premium"
    }

    /// Today's scans are used up. A Premium member is offered Pro, which
    /// reads more meals a day.
    private var limit: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(serverBehindPro
                 ? String(localized: "Pro is on, but MUSQ's server hasn't caught up yet. Try again in a moment.")
                 : purchases.isPro
                 ? String(localized: "That's today's meal scans. More tomorrow.")
                 : (purchases.tier.ai?.mealScansPerDay ?? 0) == 0
                    ? String(localized: "Meal scans come with MUSQ Pro, up to \(Purchases.Tier.pro.ai?.mealScansPerDay ?? 20) meals a day.")
                    : String(localized: "You've used today's meal scans on Premium. Pro reads up to \(Purchases.Tier.pro.ai?.mealScansPerDay ?? 20) meals a day."))
                .font(.ui(15))
                .foregroundStyle(DS.silver.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
            if serverBehindPro {
                WideButton(title: String(localized: "Try again"), prominent: true, fontSize: 15, verticalPadding: 13) {
                    phase = .choose
                }
            } else if !purchases.isPro {
                WideButton(title: String(localized: "See Pro"), prominent: true, fontSize: 15, verticalPadding: 13) {
                    showsPro = true
                }
            }
        }
    }

    private func failure(_ message: String, canRetry: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(message)
                .font(.ui(15))
                .foregroundStyle(DS.silver.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
            if canRetry {
                WideButton(title: String(localized: "Try again"), prominent: true, fontSize: 15, verticalPadding: 13) {
                    phase = .choose
                }
            }
        }
    }

    /// No food found: the scan still counted, so it says how many are left,
    /// and the next try starts from a new photo.
    private var notFood: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("No food found in that photo. Try one that shows the whole plate.")
                .font(.ui(15))
                .foregroundStyle(DS.silver.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
            if let remaining {
                Text(remaining == 1 ? String(localized: "1 scan left today") : String(localized: "\(remaining) scans left today"))
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.5))
            }
            WideButton(title: String(localized: "Try another photo"), prominent: true, fontSize: 15, verticalPadding: 13) {
                photo = nil
                loadFailed = false
                phase = .choose
            }
        }
    }

    // MARK: Actions

    /// Loads a pick from the library. Only the newest pick counts, and only
    /// while the photo can still be changed.
    private func load(_ item: PhotosPickerItem?) {
        guard let item else { return }
        pickerItem = nil
        let id = UUID()
        loadID = id
        loadFailed = false
        Task {
            let image = await PickedPhoto.load(item)
            guard loadID == id else { return }
            loadID = nil
            guard phase == .choose else { return }
            if let image { photo = image } else { loadFailed = true }
        }
    }

    /// Reads the photo, with the note; a mic that's on stops first, and what
    /// it heard goes in the note. Closing the sheet meanwhile cancels it.
    private func read() {
        guard photo != nil, loadID == nil, phase == .choose, pendingRead == nil else { return }
        guard wantsListening || isListening || finishing != nil else {
            startReading()
            return
        }
        pendingRead = Task {
            await stopListeningNow()
            guard !Task.isCancelled else { return }
            pendingRead = nil
            startReading()
        }
    }

    private func startReading() {
        guard let photo, loadID == nil, phase == .choose else { return }
        phase = .reading
        Task {
            do {
                let scan = try await AIService.shared.scanMeal(photo, note: note.isEmpty ? nil : note)
                show(scan)
            } catch let error as AIServiceError {
                if error == .notSignedIn { phase = .choose; showsSignIn = true; return }
                if error == .limitReached { phase = .limit; return }
                phase = .failed(Self.message(for: error), canRetry: Self.canRetry(error))
            } catch {
                phase = .failed(Self.message(for: .unavailable), canRetry: true)
            }
        }
    }

    /// The read meal, ready to check; or no food in it.
    private func show(_ scan: MealScan) {
        remaining = scan.remainingToday
        guard scan.isFood, !scan.items.isEmpty else {
            phase = .notFood
            return
        }
        title = scan.title
        foods = scan.items.map { MealReviewFood(scanned: $0, table: .shared, tableVersion: scan.tableVersion, locale: locale) }
        confidence = scan.confidence
        aiNote = scan.note
        phase = .review
    }

    // MARK: Mic

    /// No in-app mic before iOS 26, or for a language without on-device
    /// dictation: the keyboard's own mic fills the note instead.
    private var showsMic: Bool {
        VoiceInput.isSupported && voice.state != .unavailable
    }

    private var isListening: Bool {
        voice.state == .listening || voice.state == .preparing
    }

    /// Room in the note for ", " and a word or two more.
    private var noteHasRoom: Bool {
        note.utf16.count <= MealNote.maxLength - 4
    }

    private func toggleListening() {
        guard finishing == nil else { return }
        if isListening { stopListening() } else { startListening() }
    }

    /// Asks for the microphone the first time (in `VoiceInput.start`), and
    /// listens in the app's language, the one the note is read in.
    private func startListening() {
        micMessage = nil
        wantsListening = true
        Task {
            await voice.start(locale: VoiceInput.appLocale)
            // Tapped off (or the photo read) as the mic came on.
            if !wantsListening && voice.state == .listening { await finishListening(saysNothingHeard: false) }
        }
    }

    /// The member tapped the mic off: what it heard goes in the note. Still
    /// getting ready, it never comes on.
    private func stopListening() {
        wantsListening = false
        if voice.state == .preparing {
            Task { await voice.stop() }
            return
        }
        guard voice.state == .listening else { return }
        Task { await finishListening(saysNothingHeard: true) }
    }

    /// Stops the mic now, whatever it's doing, with what it heard in the
    /// note: before the photo is read and before the camera opens.
    private func stopListeningNow() async {
        wantsListening = false
        if voice.state == .listening || finishing != nil {
            await finishListening(saysNothingHeard: false)
        } else if voice.state == .preparing {
            await voice.stop()
        }
    }

    /// What was heard goes at the end of the note, after ", ", within the
    /// note's 200 characters, once: a stop while another is running waits
    /// for it. "Nothing heard" only when the member stopped the mic.
    private func finishListening(saysNothingHeard: Bool) async {
        if let finishing {
            await finishing.value
            return
        }
        let finish = Task {
            await voice.stop()
            let heard = voice.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
            voice.reset()
            guard !heard.isEmpty else {
                if saysNothingHeard, phase == .choose {
                    micMessage = String(localized: "Nothing heard. Tap the mic and speak, or type it.",
                                        comment: "Meal scan note: the mic was stopped and heard nothing")
                    if let micMessage { AccessibilityNotification.Announcement(micMessage).post() }
                }
                return
            }
            note = MealNote.appending(heard, to: note)
        }
        finishing = finish
        await finish.value
        finishing = nil
    }

    /// While listening, the words so far; after, a word on a mic that
    /// couldn't listen.
    @ViewBuilder
    private var noteVoiceStatus: some View {
        if isListening {
            VStack(alignment: .leading, spacing: 4) {
                Text(voice.transcript.isEmpty
                     ? (voice.state == .preparing ? String(localized: "Getting the mic ready…") : String(localized: "Listening…"))
                     : voice.transcript)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.updatesFrequently)
                Text("Tap the mic when you're done.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.6))
            }
        } else if let micMessage {
            micStatus(micMessage, symbol: "questionmark.circle")
        } else {
            switch voice.state {
            case .denied:
                VStack(alignment: .leading, spacing: 2) {
                    micStatus(String(localized: "Microphone access is off for MUSQ. Turn it on in Settings › MUSQ, or use the mic on your keyboard."),
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
                micStatus(String(localized: "Use the mic on your keyboard."), symbol: "keyboard")
            case .failed:
                micStatus(String(localized: "MUSQ couldn't listen just now. Try again, or type it."), symbol: "exclamationmark.circle")
            default:
                EmptyView()
            }
        }
    }

    private func micStatus(_ text: String, symbol: String) -> some View {
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

    // MARK: Note

    private func toggle(_ word: CookingWord) {
        note = MealNote.toggling(word, in: note)
    }

    /// Cooking words the photo can't show, a tap each into the note (or out
    /// of it).
    private var cookingChips: some View {
        FlowLayout(spacing: 8) {
            ForEach(CookingWord.allCases) { word in
                let isOn = MealNote.contains(word.text, in: note)
                let canToggle = isOn || MealNote.toggling(word, in: note) != note
                FilterChip(title: word.text, selected: isOn) { toggle(word) }
                    .disabled(!canToggle)
                    .opacity(canToggle ? 1 : 0.4)
                    .accessibilityAddTraits(isOn ? .isSelected : [])
                    .accessibilityHint(isOn
                                       ? String(localized: "Takes it out of the note", comment: "VoiceOver hint on a picked cooking word before a meal scan")
                                       : String(localized: "Adds it to the note", comment: "VoiceOver hint on a cooking word before a meal scan"))
            }
        }
    }

    private var confidenceText: String { Self.confidenceText(confidence) }

    /// "AI estimate · medium confidence", for the scan's "high", "medium"
    /// or "low"; the meal editor says the same of a scanned meal.
    static func confidenceText(_ confidence: String) -> String {
        switch confidence {
        case "high": return String(localized: "AI estimate · high confidence")
        case "low": return String(localized: "AI estimate · low confidence, check the portions")
        default: return String(localized: "AI estimate · medium confidence")
        }
    }

    /// Saves the meal as the member set it, with what the AI first read and
    /// the notes beside it. Only on this device.
    private func log() {
        let memberNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let readNote = aiNote.trimmingCharacters(in: .whitespacesAndNewlines)
        daily.addMeal(MealEntry(date: Date(), title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                items: foods.map(\.logged), confidence: confidence,
                                aiNote: readNote.isEmpty ? nil : readNote, memberNote: memberNote.isEmpty ? nil : memberNote))
        dismiss()
    }

    #if DEBUG
    /// The `-mealscan.preview` fixtures, through the same paths as a real
    /// scan (`show`) and real taps (`toggle`, the rows' own setters). Only
    /// the first sheet of a launch takes them.
    private func applyPreview() {
        guard phase == .choose, photo == nil, foods.isEmpty, let preview = MealScanPreview.takePending() else { return }
        switch preview {
        case .photo, .listening:
            photo = MealScanPreview.standInPhoto()
            toggle(.stirFried)
            toggle(.littleOil)
            // The mic as it shows while it hears, with no microphone.
            if preview == .listening, showsMic {
                wantsListening = true
                voice.previewListening(heard: locale == "vi" ? "thêm nước mắm, ít hành" : "with fish sauce, no onions")
            }
        case .edit, .editChanged, .editAdd, .editManual:
            break
        case .review, .slider, .stepper, .search, .pizza, .pizzaStep:
            show(MealScanPreview.scan(preview, locale: locale))
            if preview == .slider, let index = foods.firstIndex(where: { $0.control == .amount }) {
                foods[index].setGrams(fromSlider: 450)
            }
            if preview == .stepper || preview == .pizzaStep, let index = foods.firstIndex(where: { $0.control == .count }) {
                foods[index].stepCount(up: true)
            }
            if preview == .search {
                Task {
                    // After this sheet has finished coming up.
                    try? await Task.sleep(for: .milliseconds(700))
                    addFood = MealFoodSearchRequest(query: MealScanPreview.query)
                }
            }
        }
    }
    #endif

    private static func canRetry(_ error: AIServiceError) -> Bool {
        switch error {
        case .featureOff, .deviceNotVerified, .limitReached, .consentNeeded: return false
        default: return true
        }
    }

    static func message(for error: AIServiceError) -> String {
        switch error {
        case .limitReached: return String(localized: "That's today's meal scans. More tomorrow.")
        case .notPremium: return String(localized: "Meal scans are part of MUSQ Pro. If you've just upgraded, try again in a moment.")
        case .consentNeeded: return String(localized: "Meal scans need your OK first.")
        case .notSignedIn: return String(localized: "Sign in with Apple to scan meals.")
        case .featureOff: return String(localized: "Meal scans are paused for now. Try again later.")
        case .deviceNotVerified: return String(localized: "MUSQ couldn't verify this device. Update MUSQ and try again.")
        default: return String(localized: "MUSQ couldn't read the meal right now. Check your connection and try again.")
        }
    }
}

// MARK: - Note mic

/// The note's mic: a tap starts listening and the next stops it, with what
/// was heard going in the note. Looks like the quick log's mic.
private struct MealNoteMicButton: View {
    var state: VoiceInput.State
    var action: () -> Void

    var body: some View {
        let isOn = state == .listening
        Button(action: action) {
            ZStack {
                Circle().fill(isOn ? DS.silver : DS.silver.opacity(0.08))
                if state == .preparing {
                    ProgressView()
                        .tint(DS.silver)
                } else {
                    Image(systemName: isOn ? "waveform" : "mic.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(isOn ? DS.ink : DS.silver)
                        .symbolEffect(.variableColor.iterative, isActive: isOn)
                }
            }
            .frame(width: 44, height: 44)
            .overlay(Circle().strokeBorder(DS.silver.opacity(isOn ? 0 : 0.12), lineWidth: 1))
            .animation(.easeOut(duration: 0.2), value: isOn)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight)
        .accessibilityLabel(isOn || state == .preparing
                            ? String(localized: "Stop listening", comment: "Quick log mic, VoiceOver")
                            : String(localized: "Say the note", comment: "Meal scan: the mic beside the note, VoiceOver"))
        .accessibilityHint(isOn
                           ? String(localized: "Adds what you said to the note", comment: "Meal scan: the note's mic while it listens, VoiceOver")
                           : String(localized: "Listens until you double-tap again."))
    }
}

// MARK: - From a scan

extension MealReviewFood {
    /// A food from the scan. The server's unit picks the control ("piece"
    /// steps, "g" slides); an older server sends none, and then a count
    /// steps and anything else slides. A counted food steps by the piece
    /// the server sent, and its count is the grams in that piece (count ×
    /// pieceGrams = grams): one slice of a whole 464 g pizza starts at ⅛ of
    /// it, two big eggs at 2 × 55 g. With no weight, a food is stepped by
    /// the count or portion read and its grams stay unknown (0), never made
    /// up. `tableVersion` is the scan's (`MealScan.tableVersion`).
    init(scanned item: MealScanItem, table: FoodTable, tableVersion: Int?, locale: String) {
        let readGrams = Self.positive(item.grams) ?? 0
        let hasWeight = readGrams > 0
        let readCount = Self.positive(item.count)
        let byPiece = item.unit == "piece" || (item.unit != "g" && readCount != nil)
        let counted = byPiece || !hasWeight
        let entry = hasWeight ? Self.matchingEntry(for: item, byPiece: byPiece, tableVersion: tableVersion, in: table) : nil
        // One piece: the server's; from an older server without one, the
        // grams over its count, or the entry's piece. The amount starts
        // exactly as read either way.
        var piece = 0.0
        var count = 1.0
        if counted && hasWeight {
            piece = Self.positive(item.pieceGrams) ?? readCount.map { readGrams / $0 } ?? entry?.size.g ?? readGrams
            var pieces = readGrams / piece
            // The count sent, when that's what the grams give but for the
            // rounding of its piece (3 eggs at 100 g: 33.333 g each).
            if let readCount, abs(pieces - readCount) <= FoodAmount.Ladder.tolerance * max(1, readCount) { pieces = readCount }
            count = Self.withinCountLimits(pieces)
            // Past the count's bounds, one piece is what the grams give.
            if count != pieces { piece = readGrams / count }
        } else if counted, let readCount {
            count = Self.withinCountLimits(readCount)
        }
        let serving = counted ? nil : (Self.positive(item.servingGrams) ?? entry?.size.g)
        let wordEntry = entry ?? Self.wordEntry(for: item, byPiece: byPiece, size: counted ? piece : serving ?? 0, in: table)
        self.init(id: item.id, name: item.name, portion: item.portion, ref: item.ref,
                  basis: item.basis ?? (item.ref == nil ? "estimate" : "table"),
                  control: counted ? .count : .amount, entry: entry, sizeWord: wordEntry?.sizeWord(locale),
                  countsPortions: counted && !byPiece, pieceGrams: piece, servingGrams: serving,
                  sliderBase: serving ?? max(readGrams, 1), startGrams: readGrams, startCount: count,
                  start: FoodEntry.Values(kcal: max(item.kcal, 0), proteinG: max(item.proteinG, 0),
                                          fatG: max(item.fatG, 0), carbsG: max(item.carbsG, 0)),
                  startHidden: FoodEntry.Hidden(oil: item.hidden?.oil ?? 0, sugar: item.hidden?.sugar ?? 0,
                                                sauce: item.hidden?.sauce ?? 0),
                  aiGrams: Self.whole(item.grams), aiKcal: Self.whole(item.kcal),
                  modelGrams: item.modelGrams.flatMap(Self.whole), modelKcal: item.modelKcal.flatMap(Self.whole))
    }

    /// The bundled entry for a table food, when its numbers are the ones
    /// the server used: the scan names this app's table version, and the
    /// entry is counted or by amount as the scan is. Otherwise the scan's
    /// numbers stand, scaled to the amount set.
    private static func matchingEntry(for item: MealScanItem, byPiece: Bool, tableVersion: Int?,
                                      in table: FoodTable) -> FoodEntry? {
        guard let tableVersion, tableVersion == table.version else { return nil }
        return sameUnitEntry(for: item, byPiece: byPiece, in: table)
    }

    /// The bundled entry a table food names, counted or by amount as the
    /// scan is.
    private static func sameUnitEntry(for item: MealScanItem, byPiece: Bool, in table: FoodTable) -> FoodEntry? {
        guard let ref = item.ref, item.basis != "estimate", let entry = table.entry(id: ref),
              (entry.unit == .piece) == byPiece else { return nil }
        return entry
    }

    /// The bundled entry whose word ("egg", "bowl") still says what a table
    /// food from another table version is counted or served in: its piece
    /// or serving is about the server's (two-thirds to one and a half times
    /// it), so eggs stay eggs a step later while a whole pizza that became
    /// a slice on the server doesn't word slices as pizzas.
    private static func wordEntry(for item: MealScanItem, byPiece: Bool, size: Double, in table: FoodTable) -> FoodEntry? {
        guard size > 0, let entry = sameUnitEntry(for: item, byPiece: byPiece, in: table),
              (0.67...1.5).contains(entry.size.g / size) else { return nil }
        return entry
    }
}

// MARK: - Cooking words

/// How a meal was cooked, which a photo doesn't always show: a tap puts the
/// word in the scan's note, or takes it out.
enum CookingWord: CaseIterable, Identifiable {
    case fried, stirFried, grilled, boiledOrSteamed, littleOil, lotsOfOil

    var id: Self { self }

    var text: String {
        switch self {
        case .fried: return String(localized: "Fried", comment: "Cooking word for a meal scan's note")
        case .stirFried: return String(localized: "Stir-fried", comment: "Cooking word for a meal scan's note")
        case .grilled: return String(localized: "Grilled", comment: "Cooking word for a meal scan's note")
        case .boiledOrSteamed: return String(localized: "Boiled or steamed", comment: "Cooking word for a meal scan's note")
        case .littleOil: return String(localized: "Little oil", comment: "Cooking word for a meal scan's note: cooked with little oil")
        case .lotsOfOil: return String(localized: "Lots of oil", comment: "Cooking word for a meal scan's note: cooked with lots of oil")
        }
    }

    /// The other oil word: a meal has one or the other.
    var opposite: CookingWord? {
        switch self {
        case .littleOil: return .lotsOfOil
        case .lotsOfOil: return .littleOil
        default: return nil
        }
    }
}

/// The scan's note as comma-separated parts: cooking words go in and out
/// as parts of their own, leaving what the member typed alone.
enum MealNote {
    /// The server keeps 200 characters, counted as its JavaScript does
    /// (UTF-16 units).
    static let maxLength = 200

    private static let separators = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: ","))

    /// Whether a part of the note is the word (case and accents aside).
    static func contains(_ word: String, in note: String) -> Bool {
        let target = FoodTable.fold(word)
        return note.split(separator: ",").contains { FoodTable.fold(String($0)) == target }
    }

    /// The note with the word taken out when it's in; else put in at the end,
    /// in place of its opposite. Unchanged when it wouldn't fit.
    static func toggling(_ word: CookingWord, in note: String) -> String {
        if contains(word.text, in: note) { return removing(word.text, from: note) }
        var rest = note
        if let opposite = word.opposite, contains(opposite.text, in: rest) { rest = removing(opposite.text, from: rest) }
        let kept = rest.trimmingCharacters(in: separators)
        let added = kept.isEmpty ? word.text : kept + ", " + word.text
        return added.utf16.count <= maxLength ? added : note
    }

    /// What was said, at the end of the note after ", " (alone in an empty
    /// one), cut to `maxLength`.
    static func appending(_ heard: String, to note: String) -> String {
        let heard = heard.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !heard.isEmpty else { return note }
        let kept = note.trimmingCharacters(in: separators)
        return capped(kept.isEmpty ? heard : kept + ", " + heard)
    }

    private static func removing(_ word: String, from note: String) -> String {
        let target = FoodTable.fold(word)
        return note.split(separator: ",", omittingEmptySubsequences: false)
            .filter { FoodTable.fold(String($0)) != target }
            .joined(separator: ",")
            .trimmingCharacters(in: separators)
    }

    /// At most `maxLength` UTF-16 units, cut between characters.
    static func capped(_ note: String) -> String {
        var used = 0
        var end = note.startIndex
        for index in note.indices {
            let units = note[index].utf16.count
            guard used + units <= maxLength else { break }
            used += units
            end = note.index(after: index)
        }
        return String(note[..<end])
    }
}

// MARK: - Preview (DEBUG)

#if DEBUG
/// `-mealscan.preview [review|slider|stepper|pizza|pizzaStep|search|photo|
/// listening|edit|editChanged|editAdd|editManual]` opens the scan sheet, or
/// the editor of a logged meal, from Today on fixtures, for screenshots,
/// with no camera, microphone, network or sign-in: `review` (the default)
/// the read meal; `slider` the phở slid to 450 g; `stepper` the eggs a step
/// up (2½); `pizza` one slice of a whole pizza, ⅛ on the eighth stepper, and
/// a can of cola; `pizzaStep` the slice a step up (¼); `search` the food
/// search with "pho" typed, or the words after `-mealscan.query`; `photo`
/// the photo step with a stand-in photo and two cooking words picked;
/// `listening` the same with the note's mic hearing words. `edit` opens the
/// editor on a logged breakfast (`savedMeal`: phở, two eggs and a food
/// typed in by hand), not in the day's log; `editChanged` the same after
/// changes (`MealEditSheet`); `editAdd` with its food search open on the
/// `-mealscan.query` words; `editManual` straight on adding them by hand.
/// The table foods are what the server sends for the bundled entries
/// (functions/src/meal.ts), with this app's table version. Compiled out of
/// Release.
enum MealScanPreview: String {
    case review, slider, stepper, pizza, pizzaStep, search, photo, listening, edit, editChanged, editAdd, editManual

    /// Opens the editor of a logged meal, not the scan.
    var opensEditor: Bool {
        switch self {
        case .edit, .editChanged, .editAdd, .editManual: return true
        default: return false
        }
    }

    static let requested: MealScanPreview? = {
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: "-mealscan.preview") else { return nil }
        let next = index + 1 < arguments.count ? arguments[index + 1] : ""
        return MealScanPreview(rawValue: next) ?? .review
    }()

    /// What `search` opens with.
    static let query: String = {
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: "-mealscan.query"), index + 1 < arguments.count else { return "pho" }
        return arguments[index + 1]
    }()

    /// Opened once a launch, not again whenever Today comes back.
    static var hasOpened = false
    private static var isTaken = false
    private static var checkedSavedMeals = false

    /// The requested preview for the first scan sheet of the launch; nil
    /// for every later one, so a real scan in the same run isn't taken over.
    static func takePending() -> MealScanPreview? {
        guard !isTaken else { return nil }
        isTaken = true
        return requested
    }

    /// Meals saved by older builds still read (`MealEntry.selfTest`); once
    /// a launch.
    static func checkSavedMeals() {
        guard !checkedSavedMeals else { return }
        checkedSavedMeals = true
        let failures = MealEntry.selfTest()
        if failures.isEmpty {
            if requested != nil { print("MealEntry self-test passed") }
        } else {
            print("MealEntry self-test failed: \(failures.joined(separator: "; "))")
            assertionFailure("MealEntry self-test failed")
        }
        // The editor's foods from logged meals, typed in by hand and from
        // the table, and a logged meal's edit (MealEditor.swift).
        let editorFailures = MealReviewFood.selfTest()
        if editorFailures.isEmpty {
            if requested != nil { print("Meal editor self-test passed") }
        } else {
            print("Meal editor self-test failed: \(editorFailures.joined(separator: "; "))")
            assertionFailure("Meal editor self-test failed")
        }
        // The quick log's Food tab: words read into the table's foods, and
        // what it logs (QuickLogParts.swift).
        let foodFailures = QuickFoodDraft.selfTest()
        if foodFailures.isEmpty {
            if requested != nil || QuickLogLaunchPreview.requested != nil { print("Quick food self-test passed") }
        } else {
            print("Quick food self-test failed: \(foodFailures.joined(separator: "; "))")
            assertionFailure("Quick food self-test failed")
        }
    }

    static func scan(_ preview: MealScanPreview, locale: String) -> MealScan {
        preview == .pizza || preview == .pizzaStep ? pizzaLunch(locale: locale) : phoBreakfast(locale: locale)
    }

    /// A breakfast as the scan logs one and the editor saves it, at 8:30
    /// today: a bowl of phở bò tái (the table's serving, with what the scan
    /// sent), two boiled eggs, and sticky rice the table hasn't got, typed
    /// in by hand (320 kcal, no weight or macros).
    static func savedMeal(locale: String) -> MealEntry {
        let table = FoodTable.shared
        let vi = locale == "vi"
        var items: [MealEntry.Item] = []
        if let pho = table.entry(id: "vn.pho_bo_tai") {
            var item = MealReviewFood(entry: pho, grams: pho.size.g, locale: locale).logged
            item.aiGrams = item.grams
            item.aiKcal = item.kcal
            item.modelGrams = item.grams
            item.modelKcal = 450
            items.append(item)
        }
        if let egg = table.entry(id: "egg_boiled") {
            var item = MealReviewFood(entry: egg, count: 2, locale: locale).logged
            item.aiGrams = item.grams
            item.aiKcal = item.kcal
            item.modelGrams = 110
            item.modelKcal = 170
            items.append(item)
        }
        items.append(MealReviewFood(manualName: vi ? "Xôi nhà làm" : "Homemade sticky rice", kcal: 320).logged)
        let date = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date()) ?? Date()
        return MealEntry(date: date, title: vi ? "Bữa sáng phở bò" : "Beef pho breakfast", items: items, source: .photo,
                         confidence: "medium",
                         aiNote: vi ? "Giả định một tô cỡ thường, có cả nước dùng." : "Assumed a standard bowl, broth included.")
    }

    /// A bowl of phở bò tái at its serving (from the table, by amount, with
    /// its broth's added fat and sugar), two boiled eggs (from the table,
    /// counted) and an iced lemon tea the table doesn't have (the AI's own
    /// estimate).
    private static func phoBreakfast(locale: String) -> MealScan {
        let table = FoodTable.shared
        let vi = locale == "vi"
        var items: [MealScanItem] = []
        if let pho = table.entry(id: "vn.pho_bo_tai") {
            items.append(tableItem(pho, grams: pho.size.g, count: nil, portion: vi ? "1 tô" : "1 bowl",
                                   modelKcal: 450, locale: locale))
        }
        if let egg = table.entry(id: "egg_boiled") {
            items.append(tableItem(egg, grams: egg.size.g * 2, count: 2, portion: vi ? "2 quả" : "2 eggs",
                                   modelKcal: 150, locale: locale))
        }
        items.append(MealScanItem(name: vi ? "Trà chanh" : "Iced lemon tea", portion: vi ? "1 ly" : "1 glass",
                                  grams: 350, kcal: 105, proteinG: 0, fatG: 0, carbsG: 26, basis: "estimate", unit: "g"))
        return MealScan(isFood: true, title: vi ? "Bữa sáng phở bò" : "Beef pho breakfast", items: items, total: nil,
                        confidence: "medium",
                        note: vi ? "Giả định một tô cỡ thường, có cả nước dùng." : "Assumed a standard bowl, broth included.",
                        remainingToday: 18, tableVersion: table.version)
    }

    /// One slice of an eight-slice Margherita, which the table has as a
    /// whole pizza (count ⅛, its 58 g), and a can of cola.
    private static func pizzaLunch(locale: String) -> MealScan {
        let table = FoodTable.shared
        let vi = locale == "vi"
        var items: [MealScanItem] = []
        if let pizza = table.entry(id: "it.pizza_margherita") {
            items.append(tableItem(pizza, grams: pizza.size.g / 8, count: 0.125, portion: vi ? "1 miếng" : "1 slice",
                                   modelKcal: 150, locale: locale))
        }
        if let cola = table.entry(id: "cola") {
            items.append(tableItem(cola, grams: cola.size.g, count: 1, portion: vi ? "1 lon" : "1 can",
                                   modelKcal: 140, locale: locale))
        }
        return MealScan(isFood: true, title: vi ? "Bữa trưa pizza" : "Pizza lunch", items: items, total: nil,
                        confidence: "high",
                        note: vi ? "Giả định một miếng của một chiếc pizza tám miếng." : "Assumed one slice of an eight-slice pizza.",
                        remainingToday: 17, tableVersion: table.version)
    }

    /// A table food as the server sends it (functions/src/meal.ts,
    /// fromTable): the entry's name, kcal and macros at the whole grams;
    /// for a counted entry, the model's count with one piece its grams over
    /// it when the two agree (the grams within 0.67-1.5 of the count's in
    /// the entry's pieces), else the grams in the entry's pieces with the
    /// entry's piece, both to 3 decimals (count × pieceGrams = grams); a
    /// serving's grams by amount; each hidden amount that rounds to 1 g or
    /// more; and the AI model's own grams and kcal.
    private static func tableItem(_ entry: FoodEntry, grams: Double, count: Double?, portion: String,
                                  modelKcal: Double, locale: String) -> MealScanItem {
        let grams = grams.rounded()
        let values = entry.values(grams: grams)
        let hidden = entry.hidden(grams: grams)
        let shown = { (amount: Double) -> Double? in amount.rounded() >= 1 ? amount.rounded() : nil }
        let sentHidden = MealScanItem.Hidden(oil: shown(hidden.oil), sugar: shown(hidden.sugar), sauce: shown(hidden.sauce))
        let thousandths = { (value: Double) -> Double in (value * 1000).rounded() / 1000 }
        let byPiece = entry.unit == .piece
        var sentCount: Double?
        var pieceGrams: Double?
        if byPiece {
            if let count, count > 0, (0.67...1.5).contains(grams / (count * entry.size.g)) {
                sentCount = count
                pieceGrams = thousandths(grams / count)
            } else {
                sentCount = thousandths(grams / entry.size.g)
                pieceGrams = entry.size.g
            }
        }
        return MealScanItem(name: String(entry.name(locale).prefix(80)), portion: portion, grams: grams,
                            kcal: values.kcal.rounded(), proteinG: values.proteinG.rounded(), fatG: values.fatG.rounded(),
                            carbsG: values.carbsG.rounded(), ref: entry.id, basis: "table", unit: byPiece ? "piece" : "g",
                            count: sentCount, pieceGrams: pieceGrams, servingGrams: byPiece ? nil : entry.size.g,
                            hidden: sentHidden == MealScanItem.Hidden() ? nil : sentHidden,
                            modelGrams: grams, modelKcal: modelKcal)
    }

    /// A drawn stand-in, so the photo step shows without a camera or a
    /// photo library.
    static func standInPhoto() -> UIImage {
        let size = CGSize(width: 1200, height: 900)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            let colors = [UIColor(red: 0.80, green: 0.52, blue: 0.30, alpha: 1).cgColor,
                          UIColor(red: 0.36, green: 0.20, blue: 0.12, alpha: 1).cgColor]
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: [0, 1]) {
                context.cgContext.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: size.width, y: size.height), options: [])
            }
            let symbol = UIImage(systemName: "fork.knife.circle",
                                 withConfiguration: UIImage.SymbolConfiguration(pointSize: 260, weight: .light))?
                .withTintColor(UIColor.white.withAlphaComponent(0.85), renderingMode: .alwaysOriginal)
            if let symbol {
                symbol.draw(at: CGPoint(x: (size.width - symbol.size.width) / 2, y: (size.height - symbol.size.height) / 2 - 40))
            }
            let caption = NSAttributedString(string: "DEBUG stand-in photo", attributes: [
                .font: UIFont.systemFont(ofSize: 44, weight: .semibold),
                .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            ])
            let captionSize = caption.size()
            caption.draw(at: CGPoint(x: (size.width - captionSize.width) / 2, y: size.height - captionSize.height - 150))
        }
    }
}
#endif

// MARK: - Photo loading

/// A photo from the library, decoded no larger than the AI features need:
/// a 48 MP photo is never decoded in full, and the work stays off the main
/// thread.
enum PickedPhoto {
    static func load(_ item: PhotosPickerItem) async -> UIImage? {
        guard let data = try? await item.loadTransferable(type: Data.self) else { return nil }
        return await Task.detached(priority: .userInitiated) {
            downsample(data, maxPixel: 2048)
        }.value
    }

    /// Upright (EXIF orientation applied), at most `maxPixel` on its longer
    /// side.
    nonisolated static func downsample(_ data: Data, maxPixel: Int) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, [kCGImageSourceShouldCache: false] as CFDictionary) else {
            return nil
        }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel,
        ]
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: image)
    }
}

// MARK: - Camera

/// The camera, for a photo of the meal or of yourself.
struct CameraPicker: UIViewControllerRepresentable {
    var onPick: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage { parent.onPick(image) }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
