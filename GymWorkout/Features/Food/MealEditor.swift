//
//  MealEditor.swift
//  GymWorkout
//
//  A meal's foods, to check and change (2026-11-22): the rows the photo
//  scan's review has had since 2026-11-21, the food search that adds a food
//  from MUSQ's food table, and the meal's totals, as one view
//  (`MealItemsEditor`) that the scan's review, a logged meal being edited
//  (`MealEditSheet`) and the typed log share. Everything here works on the
//  device; nothing is sent.
//
//  - A food (`MealReviewFood`) comes from a scan (MealScan.swift), from the
//    food table at an amount (Add food, or a typed or spoken phrase), from a
//    food typed in by hand (its name and calories, its grams and macros if
//    known), or from a logged meal's item.
//  - Counted foods step by the piece, foods by amount slide by the gram
//    (and their grams can be typed), and a food with neither a weight nor a
//    piece steps as a multiple of what was logged, ×¼ to ×3. A food typed
//    in by hand can have its calories typed.
//  - A logged meal opens from Today with a tap (`MealEditSheet`): its name,
//    when it was eaten and its foods can change, or it can be deleted. The
//    scan's own numbers stay with it (`DailyStore.updateMeal`).
//

import SwiftUI

// MARK: - Editor

/// A meal's foods as rows to adjust, with "Add food" under them and the
/// meal's totals below.
///
/// - `foods`: the foods as they stand. A row changes its food in place, Add
///   food appends one, and a row's remove button takes it out.
/// - `locale`: the app's language, "vi" or "en" (`AIService.appLocale`):
///   the food table's names and amount words.
/// - `allowsManualFoods`: whether the food search also offers "Add … by
///   hand" (a name and calories, grams and macros if known). Off on the
///   scan's review.
/// - `showsTotals`: the kcal and macros of all the foods, under the rows.
/// - `style`: `.card` draws the rows on a surface card, as the scan's review
///   does; `.plain` leaves the ground and the side insets to the host (a
///   List row).
/// - `search`: the food search, for a host that opens it itself (with words
///   in it, or straight on "Add by hand"); without one, the editor keeps its
///   own.
struct MealItemsEditor: View {
    enum Style { case card, plain }

    @Binding var foods: [MealReviewFood]
    var locale: String
    var allowsManualFoods: Bool
    var showsTotals: Bool
    var style: Style
    private var search: Binding<MealFoodSearchRequest?>?

    /// The food search, when the host keeps none.
    @State private var ownSearch: MealFoodSearchRequest?

    init(foods: Binding<[MealReviewFood]>, locale: String, allowsManualFoods: Bool = true, showsTotals: Bool = true,
         style: Style = .card, search: Binding<MealFoodSearchRequest?>? = nil) {
        _foods = foods
        self.locale = locale
        self.allowsManualFoods = allowsManualFoods
        self.showsTotals = showsTotals
        self.style = style
        self.search = search
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            switch style {
            case .card:
                rows
                    .padding(.horizontal, 14)
                    .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface))
            case .plain:
                rows
            }
            if showsTotals { MealTotalsRow(foods: foods) }
        }
        .sheet(item: searchRequest) { request in
            MealFoodSearchSheet(locale: locale, request: request, allowsManualFoods: allowsManualFoods) { food in
                withAnimation { foods.append(food) }
            }
        }
    }

    private var searchRequest: Binding<MealFoodSearchRequest?> { search ?? $ownSearch }

    private var rows: some View {
        VStack(spacing: 0) {
            ForEach(foods) { food in
                MealItemRow(food: binding(for: food), locale: locale) {
                    withAnimation { foods.removeAll { $0.id == food.id } }
                }
                Hairline(opacity: 0.07)
            }
            // A food the scan missed, or one more, from MUSQ's food table.
            Button {
                searchRequest.wrappedValue = MealFoodSearchRequest()
            } label: {
                Label(String(localized: "Add food", comment: "Meal scan review: adds a food from MUSQ's food table"),
                      systemImage: "plus.circle")
                    .font(.ui(14, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.8))
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }

    /// A row's food by its id, so a row that's going away never reads past
    /// the end of the list.
    private func binding(for food: MealReviewFood) -> Binding<MealReviewFood> {
        Binding(get: { foods.first { $0.id == food.id } ?? food },
                set: { changed in
                    guard let index = foods.firstIndex(where: { $0.id == changed.id }) else { return }
                    foods[index] = changed
                })
    }
}

/// What the foods add up to: "737 kcal", and "P 44 g · F 19 g · C 99 g"
/// unless every food is one typed in by hand without macros.
struct MealTotalsRow: View {
    var foods: [MealReviewFood]

    var body: some View {
        let total = MealReviewFood.totals(foods)
        HStack(alignment: .firstTextBaseline) {
            BigValue(value: total.kcal.formatted(),
                     unit: String(localized: "kcal", comment: "Unit: kilocalories, beside a meal's energy"), size: 28)
            Spacer()
            if MealReviewFood.showsMacros(foods) {
                Text("P \(total.proteinG) g · F \(total.fatG) g · C \(total.carbsG) g",
                     comment: "A meal's macros, one letter each: P protein, F fat, C carbs (P 38 g · F 15 g · C 57 g)")
                    .font(.ui(13.5, .semibold))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver.opacity(0.7))
            }
        }
    }
}

/// The food search to open: with words in it, and straight on "Add by hand"
/// with them as the name when `opensByHand` (for a food the table hasn't
/// got).
struct MealFoodSearchRequest: Identifiable {
    let id = UUID()
    var query = ""
    var opensByHand = false
}

// MARK: - Rows

/// A food in the editor. A counted food steps by the piece, a food by
/// amount slides by the gram (its grams can be typed), and a food with no
/// weight or piece steps as a multiple; any can go, and a food typed in by
/// hand can have its calories typed. VoiceOver finds one element per food,
/// its stepper or slider, which reads the name, the amount, the energy and
/// what's hidden in it, and adjusts it; the texts that say the same are
/// hidden from it.
private struct MealItemRow: View {
    @Binding var food: MealReviewFood
    var locale: String
    var onDelete: () -> Void

    /// What's typed exactly, in the alert.
    private enum Typed {
        case grams, kcal
    }

    @State private var isTyping = false
    /// Kept after the alert closes, so its words don't change as it goes.
    @State private var typed = Typed.grams
    @State private var typedText = ""

    var body: some View {
        let logged = food.logged
        let caption = MealReviewFood.hiddenCaption(food.hidden)
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 10) {
                info(logged)
                Spacer(minLength: 6)
                if food.control != .amount { countStepper(logged, caption: caption) }
                Button(action: onDelete) {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 18))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .frame(width: 32, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(localized: "Remove \(food.name)",
                                           comment: "VoiceOver: the button that takes a food out of the meal; the food's name"))
                .accessibilitySortPriority(1)
            }
            if food.control == .amount { gramControl(logged, caption: caption) }
            if let caption {
                Text(caption)
                    .font(.ui(12))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, 8)
        // The food's own element first, then typing its grams or calories,
        // then removing it.
        .accessibilityElement(children: .contain)
        .alert(alertTitle, isPresented: $isTyping) {
            TextField(typed == .grams ? Int(food.grams.rounded()).formatted() : food.logged.kcal.formatted(),
                      text: $typedText)
                .keyboardType(.numberPad)
            Button(String(localized: "Cancel"), role: .cancel) {}
            Button(String(localized: "Done")) {
                switch typed {
                case .grams: food.setGrams(typed: typedText)
                case .kcal: food.setKcal(typed: typedText)
                }
            }
        } message: {
            switch typed {
            case .grams: Text("From 1 to 3,000 g.", comment: "Meal scan: the grams a food can be typed as")
            case .kcal: Text("From 0 to 10,000 kcal.", comment: "Meal editor: the calories a food typed in by hand can be typed as")
            }
        }
    }

    private var alertTitle: String {
        typed == .kcal
            ? String(localized: "Calories of \(food.name)", comment: "Meal editor: a food's calories, typed; the food's name")
            : String(localized: "Grams of \(food.name)", comment: "Meal scan: a food's exact grams, typed; the food's name")
    }

    private func startTyping(_ kind: Typed) {
        typedText = ""
        typed = kind
        isTyping = true
    }

    /// The name and "2 eggs · 100 g · 155 kcal". A food typed in by hand
    /// says "×1 · 320 kcal" with a pencil: a tap types its calories.
    @ViewBuilder
    private func info(_ logged: MealEntry.Item) -> some View {
        if food.isManual {
            Button {
                startTyping(.kcal)
            } label: {
                VStack(alignment: .leading, spacing: 3) {
                    name
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        detailText(logged)
                        Image(systemName: "pencil")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(DS.silver.opacity(0.5))
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            // The stepper or slider reads the amount; this types the calories.
            .accessibilityLabel(String(localized: "Calories of \(food.name)", comment: "Meal editor: a food's calories, typed; the food's name"))
            .accessibilityValue(String(localized: "\(logged.kcal) kcal", comment: "A food's energy: 459 kcal"))
            .accessibilityHint(String(localized: "Type an exact amount", comment: "VoiceOver hint on a food's grams in a meal scan"))
            .accessibilitySortPriority(2)
        } else {
            VStack(alignment: .leading, spacing: 3) {
                name
                detailText(logged)
            }
            .accessibilityHidden(true)
        }
    }

    private var name: some View {
        Text(food.name)
            .font(.ui(15, .semibold))
            .foregroundStyle(DS.silver)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func detailText(_ logged: MealEntry.Item) -> some View {
        Text(detail(logged))
            .font(.ui(12.5))
            .monospacedDigit()
            .foregroundStyle(DS.silver.opacity(0.6))
            .fixedSize(horizontal: false, vertical: true)
    }

    /// "2 eggs · 100 g · 155 kcal" for a counted food ("6 pieces · 250 kcal"
    /// with no weight known); "1 bowl · 459 kcal" for a food by amount,
    /// whose grams sit by its slider; "×1½ · 480 kcal" for a multiple.
    private func detail(_ logged: MealEntry.Item) -> String {
        let words = food.amountWords(locale: locale)
        switch food.control {
        case .count:
            guard logged.grams > 0 else {
                return String(localized: "\(words ?? "") · \(logged.kcal) kcal", comment: "A food by amount: 1 bowl · 459 kcal")
            }
            return String(localized: "\(words ?? "") · \(logged.grams) g · \(logged.kcal) kcal",
                          comment: "A scanned food: 1 bowl · 200 g · 260 kcal")
        case .amount:
            guard let words else { return String(localized: "\(logged.kcal) kcal", comment: "A food's energy: 459 kcal") }
            return String(localized: "\(words) · \(logged.kcal) kcal", comment: "A food by amount: 1 bowl · 459 kcal")
        case .multiplier:
            return String(localized: "\(words ?? "") · \(logged.kcal) kcal", comment: "A food by amount: 1 bowl · 459 kcal")
        }
    }

    /// What VoiceOver reads as the food's value: "0.125 pizza, 58 grams,
    /// 137 kcal, Includes about 1 g added fat", with the same caption as the
    /// row.
    private func spokenValue(_ logged: MealEntry.Item, caption: String?) -> String {
        var parts: [String] = []
        if let words = food.amountWords(locale: locale, spoken: true) { parts.append(words) }
        if logged.grams > 0 { parts.append(String(localized: "\(logged.grams) grams", comment: "VoiceOver: a food's grams")) }
        parts.append(String(localized: "\(logged.kcal) kcal", comment: "A food's energy: 459 kcal"))
        if let caption { parts.append(caption) }
        return parts.joined(separator: ", ")
    }

    /// Eighths below one piece of 200 g or more, quarters below one
    /// otherwise, halves to three, whole pieces above (`FoodAmount.Ladder`);
    /// a multiple steps the same way from ×¼ to ×3. A button goes grey at an
    /// end. The count shows in the words beside it ("2½ eggs", "⅛ pizza",
    /// "×1½"), so the stepper has no label of its own, and those words keep
    /// the room to stay on one line.
    private func countStepper(_ logged: MealEntry.Item, caption: String?) -> some View {
        Stepper(onIncrement: food.nextCount(up: true) == nil ? nil : { food.stepCount(up: true) },
                onDecrement: food.nextCount(up: false) == nil ? nil : { food.stepCount(up: false) }) {
            Text(verbatim: FoodAmount.count(food.count))
        }
        .labelsHidden()
        .fixedSize()
        // One adjustable element: "Boiled egg, 2 eggs, 100 grams, 155 kcal".
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(food.name)
        .accessibilityValue(spokenValue(logged, caption: caption))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: food.stepCount(up: true)
            case .decrement: food.stepCount(up: false)
            @unknown default: break
            }
        }
        .accessibilitySortPriority(3)
    }

    /// The gram slider, and the grams beside it, which a tap lets the member
    /// type exactly.
    private func gramControl(_ logged: MealEntry.Item, caption: String?) -> some View {
        HStack(spacing: 10) {
            Slider(value: Binding(get: { food.grams }, set: { food.setGrams(fromSlider: $0) }), in: food.gramBounds)
                .tint(DS.silver)
                // One adjustable element: "Beef pho with rare beef, 1 bowl, 674 grams, 477 kcal".
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(food.name)
                .accessibilityValue(spokenValue(logged, caption: caption))
                .accessibilityAdjustableAction { direction in
                    switch direction {
                    case .increment: food.nudgeGrams(up: true)
                    case .decrement: food.nudgeGrams(up: false)
                    @unknown default: break
                    }
                }
                .accessibilitySortPriority(3)
            Button {
                startTyping(.grams)
            } label: {
                HStack(spacing: 4) {
                    Text("\(logged.grams.formatted()) g",
                         comment: "A food's grams on the small button beside its slider, a tap types them: 674 g")
                        .font(.ui(13.5, .semibold))
                        .monospacedDigit()
                        .foregroundStyle(DS.silver)
                    Image(systemName: "pencil")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
                .lineLimit(1)
                .fixedSize()
                .padding(.horizontal, 10)
                .frame(minWidth: 84, minHeight: 32)
                .background(Capsule().fill(DS.silver.opacity(0.07)))
                .overlay(Capsule().strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            // The slider already reads the grams.
            .accessibilityLabel(String(localized: "Grams of \(food.name)", comment: "Meal scan: a food's exact grams, typed; the food's name"))
            .accessibilityHint(String(localized: "Type an exact amount", comment: "VoiceOver hint on a food's grams in a meal scan"))
            .accessibilitySortPriority(2)
        }
    }
}

// MARK: - Model

/// A food in the editor: what the scan, the food table or the member said
/// it was, and the amount set now. A table food whose entry this app has
/// with the numbers it came with (the scan's table version, a food added
/// from the table, a logged food whose numbers are the table's) works its
/// energy, macros and hidden fat, sugar and sauce out from the table at the
/// whole grams set, as Add food does; anything else follows the grams (or,
/// with no weight known, the count or the multiple) in proportion to the
/// numbers it came with.
struct MealReviewFood: Identifiable, Hashable {
    enum Control: Hashable {
        /// Stepped by the piece (an egg, a bánh mì), or by the portion the
        /// scan read when it gave no weight.
        case count
        /// Slid by the gram: a bowl of phở, rice.
        case amount
        /// Stepped as a multiple of what was logged, ×¼ to ×3: a food with
        /// neither a weight nor a piece, as most typed in by hand are.
        case multiplier
    }

    let id: UUID
    var name: String
    /// The scan's words for what it read ("1 glass"), for a food the table
    /// has no word for.
    var portion: String
    var ref: String?
    /// "table", "estimate" (the AI's own) or "manual" (typed in by the
    /// member, whose calories can be typed).
    var basis: String
    var control: Control
    /// The bundled table's entry when its numbers are the ones the food
    /// came with (the scan's table version and the same unit, or a logged
    /// food whose numbers are the table's), or the food was added from it:
    /// the energy, macros and hidden amounts come from it.
    var entry: FoodEntry?
    /// The table's piece or serving word in the member's language ("egg",
    /// "tô"), from the bundled entry.
    var sizeWord: String?
    /// Counted by the portion the scan read, which gave no weight: "2 servings".
    var countsPortions: Bool
    /// One piece's grams (a counted food), which the stepper steps by: the
    /// server's, so the count is the grams over it; 0 when no weight is
    /// known.
    var pieceGrams: Double
    /// One serving's grams (a food by amount from the table): what "1 bowl" is.
    var servingGrams: Double?
    /// The middle of the slider: a serving, or else what the AI read.
    var sliderBase: Double
    /// The slider's ends: set when the food is made, around the base with
    /// the starting grams inside, and widened only by typed grams, so they
    /// never move under a finger and the start stays in reach.
    var gramBounds: ClosedRange<Double>
    /// The stepper's ends: its smallest stop (⅛ or ¼) to the most stops 3 kg
    /// holds, the starting count always inside; ×¼ to ×3 for a multiple.
    var countBounds: ClosedRange<Double>
    /// The grams the starting numbers are for; 0 when no weight is known.
    var startGrams: Double
    var startCount: Double
    var start: FoodEntry.Values
    var startHidden: FoodEntry.Hidden
    /// What the scan sent, kept with the meal; nil for a food added from the table.
    var aiGrams: Int?
    var aiKcal: Int?
    /// The AI model's own grams and kcal for a table food, kept with the meal.
    var modelGrams: Int?
    var modelKcal: Int?
    /// 0 when no weight is known.
    var grams: Double
    /// Pieces, for a counted food; the multiple (1 to start), for a multiple.
    var count: Double

    /// The fewest and the most pieces a scan's count can be (the server's
    /// bounds too).
    static let countLimits = 0.001...100.0
    /// What an amount can be, typed or slid.
    static let gramLimits = 1.0...3_000.0
    /// What a multiple can be.
    static let multiplierLimits = 0.25...3.0
    /// What a food's calories can be typed as.
    static let kcalLimits = 0.0...10_000.0
    /// The basis of a food typed in by hand.
    static let manualBasis = "manual"
}

extension MealReviewFood {
    /// The amount starts as it came; the slider's and the stepper's ends
    /// are set around it.
    init(id: UUID, name: String, portion: String, ref: String?, basis: String, control: Control,
         entry: FoodEntry?, sizeWord: String?, countsPortions: Bool, pieceGrams: Double, servingGrams: Double?,
         sliderBase: Double, startGrams: Double, startCount: Double, start: FoodEntry.Values,
         startHidden: FoodEntry.Hidden, aiGrams: Int?, aiKcal: Int?, modelGrams: Int?, modelKcal: Int?) {
        self.id = id
        self.name = name
        self.portion = portion
        self.ref = ref
        self.basis = basis
        self.control = control
        self.entry = entry
        self.sizeWord = sizeWord
        self.countsPortions = countsPortions
        self.pieceGrams = pieceGrams
        self.servingGrams = servingGrams
        self.sliderBase = sliderBase
        self.startGrams = startGrams
        self.startCount = startCount
        self.start = start
        self.startHidden = startHidden
        self.aiGrams = aiGrams
        self.aiKcal = aiKcal
        self.modelGrams = modelGrams
        self.modelKcal = modelKcal
        grams = startGrams
        count = startCount
        gramBounds = Self.gramBounds(base: sliderBase, start: startGrams)
        countBounds = control == .multiplier
            ? min(Self.multiplierLimits.lowerBound, startCount)...max(Self.multiplierLimits.upperBound, startCount)
            : Self.countBounds(start: startCount, pieceGrams: pieceGrams)
    }

    // MARK: From the table

    /// A food added from the table, at its usual size: one piece, or one
    /// serving.
    init(entry: FoodEntry, locale: String) {
        self.init(table: entry, grams: nil, count: 1, locale: locale)
    }

    /// A table food at a weight ("200 g ức gà"): a food by amount slides
    /// from it; a counted one steps from the pieces it makes ("100 g of
    /// eggs" is 2 eggs). Within 1 to 3,000 g.
    init(entry: FoodEntry, grams: Double, locale: String) {
        self.init(table: entry, grams: grams, count: nil, locale: locale)
    }

    /// A table food by count ("2 eggs", "một tô phở"): pieces of a counted
    /// food, servings of a food by amount (2 bowls are twice its serving's
    /// grams).
    init(entry: FoodEntry, count: Double, locale: String) {
        self.init(table: entry, grams: nil, count: count, locale: locale)
    }

    /// A table food the member gave in grams ("200g ức gà", "100 g trứng"):
    /// it slides by the gram even when the table counts it by the piece,
    /// its words in pieces beside it ("≈ 2 eggs"). Within 1 to 3,000 g.
    init(entry: FoodEntry, weighed grams: Double, locale: String) {
        guard entry.unit == .piece else {
            self.init(table: entry, grams: grams, count: nil, locale: locale)
            return
        }
        let size = entry.size.g
        let weight = min(max(Self.positive(grams) ?? size, Self.gramLimits.lowerBound), Self.gramLimits.upperBound)
        self.init(id: UUID(), name: entry.name(locale), portion: "", ref: entry.id, basis: "table", control: .amount,
                  entry: entry, sizeWord: entry.sizeWord(locale), countsPortions: false, pieceGrams: size,
                  servingGrams: size, sliderBase: size, startGrams: weight, startCount: 1,
                  start: entry.values(grams: weight), startHidden: entry.hidden(grams: weight), aiGrams: nil, aiKcal: nil,
                  modelGrams: nil, modelKcal: nil)
    }

    /// The grams, if given, else the count; at most 3 kg either way.
    private init(table entry: FoodEntry, grams: Double?, count: Double?, locale: String) {
        let word = entry.sizeWord(locale)
        let size = entry.size.g
        if entry.unit == .piece {
            var pieces: Double
            if let grams = Self.positive(grams) {
                pieces = min(grams, Self.gramLimits.upperBound) / size
            } else {
                pieces = Self.positive(count) ?? 1
            }
            pieces = Self.withinCountLimits(min(pieces, Self.gramLimits.upperBound / size))
            let weight = pieces * size
            self.init(id: UUID(), name: entry.name(locale),
                      portion: FoodAmount.pieces(pieces, word: word, locale: locale) ?? (pieces == 1 ? word : ""),
                      ref: entry.id, basis: "table", control: .count, entry: entry, sizeWord: word,
                      countsPortions: false, pieceGrams: size, servingGrams: nil, sliderBase: size,
                      startGrams: weight, startCount: pieces, start: entry.values(grams: weight),
                      startHidden: entry.hidden(grams: weight), aiGrams: nil, aiKcal: nil, modelGrams: nil, modelKcal: nil)
        } else {
            let weight = min(max(Self.positive(grams) ?? (Self.positive(count) ?? 1) * size, Self.gramLimits.lowerBound),
                             Self.gramLimits.upperBound)
            self.init(id: UUID(), name: entry.name(locale), portion: weight == size ? FoodAmount.one(word, locale: locale) : "",
                      ref: entry.id, basis: "table", control: .amount, entry: entry, sizeWord: word,
                      countsPortions: false, pieceGrams: size, servingGrams: size, sliderBase: size,
                      startGrams: weight, startCount: 1, start: entry.values(grams: weight),
                      startHidden: entry.hidden(grams: weight), aiGrams: nil, aiKcal: nil, modelGrams: nil, modelKcal: nil)
        }
    }

    // MARK: Typed in by hand

    /// A food the table hasn't got, typed in by hand: its name and calories,
    /// with its grams and macros when known (none are 0). With grams it
    /// slides by the gram; without, it steps as a multiple, ×¼ to ×3. Its
    /// calories can be typed again in the editor.
    init(manualName name: String, kcal: Double, grams: Double? = nil, proteinG: Double? = nil, fatG: Double? = nil,
         carbsG: Double? = nil) {
        let weight = Self.positive(grams).map { min(max($0, Self.gramLimits.lowerBound), Self.gramLimits.upperBound) }
        let values = FoodEntry.Values(kcal: Self.atLeastZero(kcal), proteinG: Self.atLeastZero(proteinG),
                                      fatG: Self.atLeastZero(fatG), carbsG: Self.atLeastZero(carbsG))
        self.init(id: UUID(), name: name, portion: "", ref: nil, basis: Self.manualBasis,
                  control: weight == nil ? .multiplier : .amount, entry: nil, sizeWord: nil, countsPortions: false,
                  pieceGrams: 0, servingGrams: nil, sliderBase: weight ?? 1, startGrams: weight ?? 0, startCount: 1,
                  start: values, startHidden: FoodEntry.Hidden(), aiGrams: nil, aiKcal: nil, modelGrams: nil, modelKcal: nil)
    }

    // MARK: From a logged meal

    /// A food of a logged meal, to edit, keeping its id and what the scan
    /// sent. A counted food (unit "piece") steps from its count, by its
    /// piece when its grams are known; one with grams slides from them; one
    /// with neither steps as a multiple, ×¼ to ×3. A table food takes its
    /// numbers from the bundled table when they're what the table gives at
    /// the grams logged (the same table, and the same unit); a food logged
    /// under another version of the table, an AI estimate and a food typed
    /// in by hand scale the numbers logged. A food typed in by hand is one
    /// saved as such, or any food of a typed meal from before that had no
    /// table entry and no basis. The table is read only for a food with an
    /// entry.
    init(saved item: MealEntry.Item, mealSource: MealEntry.Source, locale: String,
         table: @autoclosure () -> FoodTable = FoodTable.shared) {
        let grams = Double(max(item.grams, 0))
        let isManual = item.basis == Self.manualBasis || (item.basis == nil && item.ref == nil && mealSource == .manual)
        let savedCount = item.unit == "piece" ? Self.positive(item.count) : nil
        let control: Control = savedCount != nil ? .count : grams > 0 ? .amount : .multiplier
        let count = savedCount.map { Self.withinCountLimits($0) } ?? 1
        // The entry a table food names, counted or by amount as it was
        // logged; a counted entry weighed in grams ("200 g of eggs") slides.
        var named: FoodEntry?
        if !isManual, control != .multiplier, item.basis != "estimate", let ref = item.ref,
           let entry = table().entry(id: ref), entry.unit == .piece || control == .amount {
            named = entry
        }
        var piece = control == .count && grams > 0 ? grams / count : 0
        // The entry's own piece when the grams logged are its pieces' to the
        // whole gram: ½ date (3.5 g) is logged as 4 g, and 4 g ÷ ½ isn't a
        // date's 7 g.
        if control == .count, grams > 0, let named, abs(count * named.size.g - grams) <= 0.5 { piece = named.size.g }
        // Its word ("egg", "bowl") while its piece or serving still says
        // what the amount is in: a counted food's piece about the entry's.
        var word: FoodEntry?
        if let named {
            switch control {
            case .count: word = piece == 0 || (0.67...1.5).contains(named.size.g / piece) ? named : nil
            case .amount: word = named
            case .multiplier: word = nil
            }
        }
        let serving = control == .amount ? word?.size.g : nil
        let entry = named.flatMap { grams > 0 && Self.isTable($0, item: item, grams: grams) ? $0 : nil }
        // Counted by the portion the scan read, with no weight: its words
        // (none when the count was changed).
        let portion = control == .count && grams == 0 ? item.portion : nil
        // A scaled food starts from its numbers before rounding, when it
        // has them and they're still what was logged, so edits never drift.
        var start = FoodEntry.Values(kcal: Double(max(item.kcal, 0)), proteinG: Double(max(item.proteinG, 0)),
                                     fatG: Double(max(item.fatG, 0)), carbsG: Double(max(item.carbsG, 0)))
        if entry == nil, let exact = item.exact, Self.rounds(exact, to: item) {
            start = FoodEntry.Values(kcal: exact.kcal, proteinG: exact.proteinG, fatG: exact.fatG, carbsG: exact.carbsG)
        }
        self.init(id: item.id, name: item.name, portion: portion ?? "", ref: item.ref,
                  basis: isManual ? Self.manualBasis : item.basis ?? (item.ref == nil ? "estimate" : "table"),
                  control: control, entry: entry, sizeWord: word?.sizeWord(locale), countsPortions: portion != nil,
                  pieceGrams: piece, servingGrams: serving, sliderBase: serving ?? max(grams, 1),
                  startGrams: grams, startCount: count,
                  start: start,
                  startHidden: FoodEntry.Hidden(oil: item.hidden?.oil ?? 0, sugar: item.hidden?.sugar ?? 0,
                                                sauce: item.hidden?.sauce ?? 0),
                  aiGrams: item.aiGrams, aiKcal: item.aiKcal, modelGrams: item.modelGrams, modelKcal: item.modelKcal)
    }

    /// Whether a food's numbers before rounding come to what was logged.
    private static func rounds(_ exact: MealEntry.Item.Exact, to item: MealEntry.Item) -> Bool {
        let pairs = [(exact.kcal, item.kcal), (exact.proteinG, item.proteinG), (exact.fatG, item.fatG), (exact.carbsG, item.carbsG)]
        return pairs.allSatisfy { value, logged in
            value.isFinite && value >= 0 && value < 1_000_000 && Int(value.rounded()) == logged
        }
    }

    /// Whether a logged food's numbers are the entry's at its grams, to the
    /// whole number, as the editor logs a table food: the table it was
    /// logged with is this one.
    private static func isTable(_ entry: FoodEntry, item: MealEntry.Item, grams: Double) -> Bool {
        let values = entry.values(grams: grams)
        return Int(values.kcal.rounded()) == item.kcal && Int(values.proteinG.rounded()) == item.proteinG
            && Int(values.fatG.rounded()) == item.fatG && Int(values.carbsG.rounded()) == item.carbsG
    }

    // MARK: Helpers

    nonisolated static func positive(_ value: Double?) -> Double? {
        guard let value, value > 0, value.isFinite else { return nil }
        return value
    }

    private nonisolated static func atLeastZero(_ value: Double?) -> Double {
        guard let value, value.isFinite else { return 0 }
        return max(value, 0)
    }

    static func withinCountLimits(_ count: Double) -> Double {
        min(max(count, countLimits.lowerBound), countLimits.upperBound)
    }

    /// A number the server sent, to the whole number, within reason.
    nonisolated static func whole(_ value: Double) -> Int? {
        guard value.isFinite else { return nil }
        return Int(min(max(value, 0), 1_000_000).rounded())
    }

    /// Typed in by hand: its calories can be typed.
    var isManual: Bool { basis == Self.manualBasis }

    /// Whether its protein, fat and carbs mean something: always for a scan
    /// or table food, and for one typed in by hand when any was given (as
    /// `MealEntry.detailLine` reads a typed meal).
    var carriesMacros: Bool {
        !isManual || start.proteinG + start.fatG + start.carbsG > 0
    }

    /// Each food's rounded numbers added up, so the totals are the sum of
    /// what's logged.
    static func totals(_ foods: [MealReviewFood]) -> (kcal: Int, proteinG: Int, fatG: Int, carbsG: Int) {
        foods.reduce((0, 0, 0, 0)) { total, food in
            let logged = food.logged
            return (total.0 + logged.kcal, total.1 + logged.proteinG, total.2 + logged.fatG, total.3 + logged.carbsG)
        }
    }

    /// The totals show the macros unless every food is typed in by hand
    /// without any: a meal of calories only isn't "P 0 g".
    static func showsMacros(_ foods: [MealReviewFood]) -> Bool {
        foods.isEmpty || foods.contains(where: \.carriesMacros)
    }

    private var factor: Double {
        if startGrams > 0 { return grams / startGrams }
        return startCount > 0 ? count / startCount : 1
    }

    /// Energy and macros of the amount now.
    var values: FoodEntry.Values {
        if let entry, grams > 0 { return entry.values(grams: grams.rounded()) }
        return start.scaled(by: factor)
    }

    /// The oil, sugar and sauce in the amount now.
    var hidden: FoodEntry.Hidden {
        if let entry, grams > 0 { return entry.hidden(grams: grams.rounded()) }
        return startHidden.scaled(by: factor)
    }

    /// As it's logged: whole grams (0 when unknown), kcal and macros, the
    /// hidden grams to a tenth, and what the scan sent. A multiple logs the
    /// numbers it comes to, with no unit or count.
    var logged: MealEntry.Item {
        let now = values
        let hiddenNow = hidden
        let tenth = { (grams: Double) -> Double? in
            let rounded = (grams * 10).rounded() / 10
            return rounded > 0 ? rounded : nil
        }
        let loggedHidden = MealEntry.Item.Hidden(oil: tenth(hiddenNow.oil), sugar: tenth(hiddenNow.sugar),
                                                 sauce: tenth(hiddenNow.sauce))
        let unit: String? = switch control {
        case .count: "piece"
        case .amount: "g"
        case .multiplier: nil
        }
        return MealEntry.Item(id: id, name: name, grams: Int(grams.rounded()), kcal: Int(now.kcal.rounded()),
                              proteinG: Int(now.proteinG.rounded()), fatG: Int(now.fatG.rounded()),
                              carbsG: Int(now.carbsG.rounded()),
                              ref: ref, basis: basis, unit: unit,
                              count: control == .count ? count : nil, aiGrams: aiGrams, aiKcal: aiKcal,
                              modelGrams: modelGrams, modelKcal: modelKcal,
                              hidden: loggedHidden == MealEntry.Item.Hidden() ? nil : loggedHidden,
                              portion: loggedPortion,
                              exact: entry == nil ? Self.exact(now) : nil)
    }

    /// A scaled food's numbers before rounding, when rounding changed any.
    private static func exact(_ values: FoodEntry.Values) -> MealEntry.Item.Exact? {
        let numbers = [values.kcal, values.proteinG, values.fatG, values.carbsG]
        guard numbers.allSatisfy(\.isFinite), numbers.contains(where: { abs($0 - $0.rounded()) > 1e-9 }) else { return nil }
        return MealEntry.Item.Exact(kcal: values.kcal, proteinG: values.proteinG, fatG: values.fatG, carbsG: values.carbsG)
    }

    /// For a food counted by the portion the scan read: its words while the
    /// count is as read, else none ("2 servings" is worked out again); nil
    /// for any other food.
    private var loggedPortion: String? {
        guard control == .count, countsPortions else { return nil }
        return count == startCount ? portion : ""
    }

    /// The amount in words: "2 eggs", "⅛ pizza", "1 bowl", "≈ ¾ tô" from
    /// the table's word; else the scan's own words while the amount is as
    /// it read them; else "3 pieces" (or "2 servings" by the portion) for a
    /// counted food, nothing for one by amount, and "×1½" for a multiple. A
    /// count between the stepper's stops reads as the nearest one after "≈"
    /// ("≈ ⅛ pizza"). `spoken` writes fractions as decimals, for VoiceOver.
    func amountWords(locale: String, spoken: Bool = false) -> String? {
        switch control {
        case .count:
            let (shown, mark) = FoodAmount.onLadder(count, ladder)
            if let sizeWord, !sizeWord.isEmpty,
               let words = FoodAmount.pieces(shown, word: sizeWord, locale: locale, spoken: spoken) {
                return mark + words
            }
            if count == startCount, !portion.isEmpty { return portion }
            let number = mark + FoodAmount.count(shown, spoken: spoken)
            if countsPortions {
                return shown > 1
                    ? String(localized: "\(number) servings", comment: "A food counted by the portion a meal scan read, with no weight: 2 servings")
                    : String(localized: "\(number) serving", comment: "A food counted by the portion a meal scan read, with no weight: 1 serving, ½ serving")
            }
            return shown > 1
                ? String(localized: "\(number) pieces", comment: "A counted food with no word of its own: 3 pieces")
                : String(localized: "\(number) piece", comment: "A counted food with no word of its own: 1 piece, ½ piece")
        case .amount:
            if let sizeWord, !sizeWord.isEmpty, let servingGrams, servingGrams > 0,
               let words = FoodAmount.servings(grams / servingGrams, word: sizeWord, locale: locale, spoken: spoken) {
                return words
            }
            return abs(grams - startGrams) < 0.5 && !portion.isEmpty ? portion : nil
        case .multiplier:
            let (shown, mark) = FoodAmount.onLadder(count, ladder)
            guard spoken else { return mark + "×" + FoodAmount.count(shown) }
            return String(localized: "\(mark + FoodAmount.count(shown, spoken: true)) times",
                          comment: "VoiceOver: a food typed in by hand, as a multiple of what was logged: 1.5 times")
        }
    }

    // MARK: Counted

    /// The stepper's stops: eighths below one piece of 200 g or more,
    /// quarters otherwise (and for a multiple), halves to three, whole
    /// pieces above.
    var ladder: FoodAmount.Ladder { FoodAmount.Ladder(pieceGrams: pieceGrams) }

    /// The stepper's ends: the smallest stop (⅛ or ¼) up to the highest
    /// stop 3 kg holds (100 pieces at most), the starting count always
    /// inside.
    static func countBounds(start: Double, pieceGrams: Double) -> ClosedRange<Double> {
        let ladder = FoodAmount.Ladder(pieceGrams: pieceGrams)
        var most = countLimits.upperBound
        if pieceGrams > 0 { most = min(most, gramLimits.upperBound / pieceGrams) }
        // A piece too heavy for even the smallest stop stays as read.
        let top = ladder.highest(atMost: most) ?? start
        return min(ladder.smallest, start)...max(top, start)
    }

    /// Where a step goes: the next stop up or down (from a count between
    /// stops, the stop on that side), or the count the scan read when that
    /// comes first; nil past an end.
    func nextCount(up: Bool) -> Double? {
        let slack = FoodAmount.Ladder.tolerance
        var next = ladder.next(after: count, up: up)
        if up {
            if startCount > count + slack { next = min(next, startCount) }
            return next <= countBounds.upperBound + slack ? next : nil
        }
        if startCount < count - slack { next = max(next, startCount) }
        return next >= countBounds.lowerBound - slack ? next : nil
    }

    /// A step up or down (see `nextCount`); nothing past an end. The grams
    /// follow the count when the piece's weight is known, and are the
    /// grams read again at the count read.
    mutating func stepCount(up: Bool) {
        guard let next = nextCount(up: up) else { return }
        count = next
        guard pieceGrams > 0 else { return }
        grams = count == startCount ? startGrams : count * pieceGrams
    }

    // MARK: By amount

    /// A quarter of the base (1 g at least under a 40 g base, else 10 g) to
    /// two and a half times it, with the starting grams inside, within 1 to
    /// 3,000 g.
    static func gramBounds(base: Double, start: Double) -> ClosedRange<Double> {
        var lower = max(base < 40 ? 1 : 10, snap(base * 0.25, base: base))
        var upper = max(snap(min(gramLimits.upperBound, base * 2.5), base: base), lower + 10)
        if start > 0 {
            lower = min(lower, start)
            upper = max(upper, start)
        }
        lower = max(lower, gramLimits.lowerBound)
        upper = min(upper, gramLimits.upperBound)
        if upper <= lower { lower = max(gramLimits.lowerBound, upper - 10) }
        return lower...upper
    }

    /// The slider's step: 1 g for a food whose base is under 40 g (a
    /// teaspoon of sugar), else 5 g, 10 g past 500 g.
    static func gramStep(at grams: Double, base: Double) -> Double {
        base < 40 ? 1 : grams > 500 ? 10 : 5
    }

    static func snap(_ grams: Double, base: Double) -> Double {
        let step = gramStep(at: grams, base: base)
        return (grams / step).rounded() * step
    }

    /// On the slider's steps, within its ends; the grams it started at stay
    /// a stop of their own.
    mutating func setGrams(fromSlider value: Double) {
        let step = Self.gramStep(at: value, base: sliderBase)
        let next = abs(value - startGrams) <= step / 2 ? startGrams : Self.snap(value, base: sliderBase)
        grams = min(max(next, gramBounds.lowerBound), gramBounds.upperBound)
    }

    /// VoiceOver's step: about a twentieth of the base, on the slider's steps.
    mutating func nudgeGrams(up: Bool) {
        let step = Self.gramStep(at: grams, base: sliderBase)
        let nudge = max(step, (sliderBase * 0.05 / step).rounded() * step)
        setGrams(fromSlider: grams + (up ? nudge : -nudge))
    }

    /// Grams typed, in the member's locale, to the whole gram within 1 to
    /// 3,000 g; the slider widens to take them in. Anything without a
    /// number leaves the amount alone.
    mutating func setGrams(typed text: String) {
        guard let value = Self.typedGrams(text) else { return }
        grams = value
        gramBounds = min(gramBounds.lowerBound, value)...max(gramBounds.upperBound, value)
    }

    /// The number in what was typed, read the way the locale writes numbers
    /// ("12,5" is 12.5 g in Vietnamese and "1.500" is 1,500 g; "12.5" is
    /// 12.5 g in English), so a decimal point never turns 12.5 g into 125 g.
    /// "120 g" is 120. Rounded to the gram and kept within 1 to 3,000 g.
    static func typedGrams(_ text: String, locale: Locale = .current) -> Double? {
        guard let value = typedNumber(text, locale: locale) else { return nil }
        return min(max(value.rounded(), gramLimits.lowerBound), gramLimits.upperBound)
    }

    // MARK: Typed calories

    /// Calories typed for a food typed in by hand, for the amount set now
    /// (at ×2, what two come to); its macros stay as given. Anything
    /// without a number, or a food from a scan or the table, is left alone.
    mutating func setKcal(typed text: String) {
        guard isManual, let value = Self.typedKcal(text), factor > 0 else { return }
        start.kcal = value / factor
    }

    /// Whole calories in what was typed (read as `typedGrams` reads grams),
    /// within 0 to 10,000 kcal.
    static func typedKcal(_ text: String, locale: Locale = .current) -> Double? {
        guard let value = typedNumber(text, locale: locale) else { return nil }
        return min(max(value.rounded(), kcalLimits.lowerBound), kcalLimits.upperBound)
    }

    /// The number in what was typed, in the locale's way of writing numbers;
    /// nil when there's none.
    private static func typedNumber(_ text: String, locale: Locale) -> Double? {
        let decimal = locale.decimalSeparator ?? ".", grouping = locale.groupingSeparator ?? ","
        // Points and commas stay for the locale to read, whatever it uses.
        let number = text.filter { $0.isNumber || $0 == "." || $0 == "," || String($0) == decimal || String($0) == grouping }
        guard !number.isEmpty, let value = try? Double(number, format: .number.locale(locale)), value.isFinite else {
            return nil
        }
        return value
    }

    /// "Includes about 12 g added fat · 30 g sauce · 8 g sugar": what's in
    /// it a photo can't show, each that rounds to a gram or more (the
    /// server's rule too); nil when there's none. Added fat is the table's
    /// "oil": oil, lard and ghee, frying oil, and the fat of butter, cream,
    /// coconut milk and pastry (Tools/food-table/SPEC.md). VoiceOver reads
    /// the same caption.
    static func hiddenCaption(_ hidden: FoodEntry.Hidden) -> String? {
        let fat = Int(hidden.oil.rounded()), sugar = Int(hidden.sugar.rounded()), sauce = Int(hidden.sauce.rounded())
        var parts: [String] = []
        if fat >= 1 {
            parts.append(String(localized: "\(fat) g added fat",
                                comment: "Hidden in a food's calories: 12 g added fat (oil, frying oil, butter, cream, lard)"))
        }
        if sauce >= 1 { parts.append(String(localized: "\(sauce) g sauce", comment: "Hidden in a food's calories: 30 g sauce")) }
        if sugar >= 1 { parts.append(String(localized: "\(sugar) g sugar", comment: "Hidden in a food's calories: 8 g sugar")) }
        guard !parts.isEmpty else { return nil }
        return String(localized: "Includes about \(parts.joined(separator: " · "))",
                      comment: "What a photo can't show, already in a food's calories: Includes about 12 g added fat · 30 g sauce · 8 g sugar")
    }
}

// MARK: - Add food

/// A food from MUSQ's food table, added to the meal at its usual size: one
/// piece, or one serving; or, where the host allows it, a food typed in by
/// hand. Searched on the device, off the main thread as the words change;
/// nothing is sent. The quick log's Food tab opens it too, to add a food or
/// to change one it read from a phrase (QuickLogSheet.swift).
struct MealFoodSearchSheet: View {
    var locale: String
    var request: MealFoodSearchRequest
    var allowsManualFoods: Bool
    var onPick: (MealReviewFood) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    /// The best matches for `resultsQuery`; the last ones stay up until the
    /// next are in.
    @State private var results: [FoodEntry] = []
    @State private var resultsQuery = ""
    @FocusState private var searchFocused: Bool
    /// "Add by hand", open, with the name it opened with.
    @State private var showsByHand: Bool
    @State private var byHandName: String

    init(locale: String, request: MealFoodSearchRequest, allowsManualFoods: Bool,
         onPick: @escaping (MealReviewFood) -> Void) {
        self.locale = locale
        self.request = request
        self.allowsManualFoods = allowsManualFoods
        self.onPick = onPick
        _showsByHand = State(initialValue: allowsManualFoods && request.opensByHand)
        _byHandName = State(initialValue: Self.trimmed(request.query))
    }

    var body: some View {
        let typed = Self.trimmed(query)
        NavigationStack {
            VStack(spacing: 0) {
                searchField
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if typed.isEmpty {
                            message(String(localized: "Search MUSQ's food table by name, in English or Vietnamese.",
                                           comment: "Meal scan: the food search before anything is typed"))
                        } else if results.isEmpty {
                            if resultsQuery == typed {
                                message(String(localized: "No foods match “\(typed)”.", comment: "Meal scan: the food search found nothing"))
                            }
                        } else {
                            VStack(spacing: 0) {
                                ForEach(results) { entry in
                                    row(entry)
                                    if entry.id != results.last?.id { Hairline(opacity: 0.07) }
                                }
                            }
                            .padding(.horizontal, 14)
                            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface))
                        }
                        if allowsManualFoods {
                            byHandRow(typed)
                                .padding(.top, 12)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 10)
                    .padding(.bottom, 24)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Add food", comment: "Meal scan review: adds a food from MUSQ's food table"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
            .navigationDestination(isPresented: $showsByHand) {
                MealManualFoodForm(initialName: byHandName) { food in
                    onPick(food)
                    dismiss()
                }
            }
        }
        .task {
            // Opened with words (the preview's, or a phrase's), it shows
            // what they find; else the keyboard comes up, once the sheet is up.
            guard request.query.isEmpty else {
                if query.isEmpty { query = request.query }
                return
            }
            guard !showsByHand else { return }
            try? await Task.sleep(for: .milliseconds(300))
            searchFocused = true
        }
        .task(id: query) {
            let typed = Self.trimmed(query)
            let locale = self.locale
            let found = await Task.detached(priority: .userInitiated) {
                FoodTable.shared.search(typed, locale: locale)
            }.value
            guard !Task.isCancelled else { return }
            results = found
            resultsQuery = typed
        }
    }

    private static func trimmed(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var searchField: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(DS.silver.opacity(0.4))
            TextField("", text: $query,
                      prompt: Text("Search foods", comment: "Meal scan: the food search's placeholder")
                        .foregroundStyle(DS.silver.opacity(0.35)))
                .focused($searchFocused)
                .font(.ui(15))
                .foregroundStyle(DS.silver)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(DS.silver.opacity(0.35))
                        .frame(width: 28, height: 28)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(localized: "Clear search"))
            }
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 9)
        .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(DS.surface))
        .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
            .strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
    }

    /// One food (`MealFoodResultLabel`); a tap adds it at one piece or serving.
    private func row(_ entry: FoodEntry) -> some View {
        Button {
            onPick(MealReviewFood(entry: entry, locale: locale))
            dismiss()
        } label: {
            MealFoodResultLabel(entry: entry, locale: locale)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(String(localized: "Adds it to the meal", comment: "VoiceOver hint on a food in the meal scan's food search"))
    }

    /// A food the table hasn't got: "Add “bánh xèo nhà làm” by hand".
    private func byHandRow(_ typed: String) -> some View {
        Button {
            byHandName = typed
            showsByHand = true
        } label: {
            Label(typed.isEmpty
                  ? String(localized: "Add a food by hand", comment: "Food search: type in a food the table hasn't got")
                  : String(localized: "Add “\(typed)” by hand", comment: "Food search: type in a food the table hasn't got; the words searched"),
                  systemImage: "square.and.pencil")
                .font(.ui(14, .semibold))
                .foregroundStyle(DS.silver.opacity(0.8))
                .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 14)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface))
        .accessibilityHint(String(localized: "Type its calories, and its grams and macros if you know them",
                                  comment: "VoiceOver hint on adding a food by hand"))
    }

    private func message(_ text: String) -> some View {
        Text(text)
            .font(.ui(14))
            .foregroundStyle(DS.silver.opacity(0.6))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 6)
    }
}

/// A food table entry as the food searches list it: the name in the
/// member's language, the other one under it when it differs, and one piece
/// or serving, "1 bowl · 674 g · 477 kcal", after a dish's country
/// ("Vietnam · …"), which tells two dishes of one name apart. The search
/// sheet and the quick log's live results share it.
struct MealFoodResultLabel: View {
    var entry: FoodEntry
    var locale: String

    var body: some View {
        let name = entry.name(locale)
        let otherName = entry.name(locale == "vi" ? "en" : "vi")
        let size = FoodAmount.one(entry.sizeWord(locale), locale: locale)
        let grams = Int(entry.size.g.rounded())
        // At the whole grams it's logged at (`MealReviewFood.values`).
        let kcal = Int(entry.values(grams: entry.size.g.rounded()).kcal.rounded())
        let amount = String(localized: "\(size) · \(grams) g · \(kcal) kcal", comment: "A scanned food: 1 bowl · 200 g · 260 kcal")
        let detail = entry.cuisineName(locale).map { "\($0) · \(amount)" } ?? amount
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                if otherName != name {
                    Text(otherName)
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
                Text(verbatim: detail)
                    .font(.ui(12.5))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver.opacity(0.6))
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "plus.circle")
                .font(.system(size: 18))
                .foregroundStyle(DS.silver.opacity(0.5))
                .accessibilityHidden(true)
        }
    }
}

// MARK: - Add by hand

/// A food the table hasn't got, typed in: its name and calories, and its
/// grams, protein, fat and carbs if known. Nothing is looked up or sent.
private struct MealManualFoodForm: View {
    var initialName: String
    var onAdd: (MealReviewFood) -> Void

    private enum Field: Hashable { case name, kcal, grams, protein, fat, carbs }

    @State private var name: String
    @State private var kcal: Int?
    @State private var grams: Int?
    @State private var protein: Int?
    @State private var fat: Int?
    @State private var carbs: Int?
    @State private var hasFocused = false
    @FocusState private var focus: Field?

    init(initialName: String, onAdd: @escaping (MealReviewFood) -> Void) {
        self.initialName = initialName
        self.onAdd = onAdd
        _name = State(initialValue: initialName)
    }

    var body: some View {
        // The units beside the numbers.
        let kcalUnit = String(localized: "kcal", comment: "Unit: kilocalories, beside a number field")
        let gramUnit = String(localized: "g", comment: "Unit: grams, beside a number field")
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 12) {
                    TextField(String(localized: "What you ate", comment: "Adding a food by hand: placeholder of the food's name"),
                              text: $name)
                        .font(.ui(20, .bold))
                        .foregroundStyle(DS.silver)
                        .textInputAutocapitalization(.sentences)
                        .focused($focus, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focus = .kcal }
                        .frame(minHeight: 44)
                    Hairline(opacity: 0.07)
                    numberRow(String(localized: "Calories", comment: "Adding a food by hand: its calories, the one number it needs"),
                              value: $kcal, unit: kcalUnit, maxDigits: 5, field: .kcal, required: true)
                    numberRow(String(localized: "Grams", comment: "Adding a food by hand: its weight in grams, optional"),
                              value: $grams, unit: gramUnit, maxDigits: 4, maxValue: Int(MealReviewFood.gramLimits.upperBound),
                              field: .grams)
                    numberRow(String(localized: "Protein", comment: "Macro"), value: $protein, unit: gramUnit, maxDigits: 4,
                              field: .protein)
                    numberRow(String(localized: "Fat", comment: "Macro"), value: $fat, unit: gramUnit, maxDigits: 4, field: .fat)
                    numberRow(String(localized: "Carbs", comment: "Macro"), value: $carbs, unit: gramUnit, maxDigits: 4,
                              field: .carbs)
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface))
                Text("Your own estimate is fine. It's logged just as you typed it, and a rough number beats a skipped meal.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
                WideButton(title: String(localized: "Add to meal", comment: "Adding a food by hand: adds it to the meal"),
                           prominent: true, fontSize: 16, verticalPadding: 14, cornerRadius: 14) { add() }
                    .disabled(!canAdd)
                    .opacity(canAdd ? 1 : 0.45)
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.top, 10)
            .padding(.bottom, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(DS.ink.ignoresSafeArea())
        .navigationTitle(String(localized: "Add by hand", comment: "Title: a food typed in by hand, with its calories"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
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
        .task {
            guard !hasFocused else { return }
            hasFocused = true
            // Once the screen has come in: the calories when the name came
            // with it, else the name.
            try? await Task.sleep(for: .milliseconds(450))
            focus = trimmedName.isEmpty ? .name : .kcal
        }
    }

    private var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    /// A name, and calories as a typed meal takes them (1 to 10,000 kcal).
    private var canAdd: Bool {
        guard !trimmedName.isEmpty, let kcal else { return false }
        return kcal > 0 && kcal <= 10_000
    }

    private func add() {
        guard canAdd, let kcal else { return }
        focus = nil
        onAdd(MealReviewFood(manualName: trimmedName, kcal: Double(kcal), grams: grams.map(Double.init),
                             proteinG: protein.map(Double.init), fatG: fat.map(Double.init), carbsG: carbs.map(Double.init)))
    }

    private func numberRow(_ title: String, value: Binding<Int?>, unit: String, maxDigits: Int, maxValue: Int? = nil,
                           field: Field, required: Bool = false) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                if !required {
                    Text("Optional", comment: "Adding a food by hand: small, under a number's name; it can be left empty")
                        .font(.ui(11.5))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
            }
            .accessibilityHidden(true)
            Spacer(minLength: 8)
            MealNumberField(placeholder: required ? "0" : "–", value: value, unit: unit, maxDigits: maxDigits,
                            maxValue: maxValue, focus: $focus, field: field,
                            accessibilityTitle: required
                                ? title
                                : String(localized: "\(title), optional",
                                         comment: "VoiceOver: a number field that can be left empty; its title (Grams, optional)"))
        }
    }
}

/// A whole number typed on the number pad, with its unit beside it (the
/// quick log's number field). Empty is nil; past `maxValue`, it shows and
/// keeps the most it can be ("3000 g": no more is logged).
private struct MealNumberField<Field: Hashable>: View {
    var placeholder: String
    @Binding var value: Int?
    var unit: String
    var maxDigits: Int
    var maxValue: Int? = nil
    var focus: FocusState<Field?>.Binding
    var field: Field
    var accessibilityTitle: String

    var body: some View {
        let isFocused = focus.wrappedValue == field
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            TextField(placeholder, text: Binding(
                get: { value.map { String($0) } ?? "" },
                set: { text in
                    let digits = String(text.filter { $0.isASCII && $0.isNumber }.prefix(maxDigits))
                    value = digits.isEmpty ? nil : Int(digits).map { number in maxValue.map { min(number, $0) } ?? number }
                }))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .font(.ui(18, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver)
                .focused(focus, equals: field)
                .frame(width: 68)
                .accessibilityLabel(accessibilityTitle)
                .accessibilityValue(value.map {
                    String(localized: "\($0) \(unit)",
                           comment: "VoiceOver value of a number field: the number typed and its unit (450 kcal, 250 g)")
                } ?? "")
            Text(unit)
                .font(.ui(13, .semibold))
                .foregroundStyle(DS.silver.opacity(0.55))
                .lineLimit(1)
                .fixedSize()
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 12)
        .frame(minHeight: 44)
        .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(DS.silver.opacity(0.06)))
        .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous)
            .strokeBorder(DS.silver.opacity(isFocused ? 0.4 : 0.10), lineWidth: 1))
    }
}

// MARK: - Editing a logged meal

/// A logged meal, opened from Today: its name, when it was eaten and its
/// foods, as the scan's review sets them, to save or delete. Saving keeps
/// the meal's id, where it came from and what the scan sent
/// (`DailyStore.updateMeal`); with every food removed, saving deletes the
/// meal, after asking. Works for scanned, typed and older meals alike.
struct MealEditSheet: View {
    /// The meal as it opened.
    let meal: MealEntry

    @Environment(DailyStore.self) private var daily
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var date: Date
    @State private var foods: [MealReviewFood]
    /// The foods as they opened, to tell whether anything has changed.
    @State private var openedFoods: [MealReviewFood]
    @State private var search: MealFoodSearchRequest?
    @State private var confirmsDelete = false

    init(meal: MealEntry) {
        self.meal = meal
        let locale = AIService.appLocale
        let foods = meal.items.map { MealReviewFood(saved: $0, mealSource: meal.source, locale: locale) }
        _title = State(initialValue: meal.title)
        _date = State(initialValue: meal.date)
        _foods = State(initialValue: foods)
        _openedFoods = State(initialValue: foods)
    }

    /// The member's language, for the food table's names and words.
    private var locale: String { AIService.appLocale }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    TextField(String(localized: "Meal name", comment: "A meal's name: the placeholder of its name field"), text: $title)
                        .font(.ui(22, .bold))
                        .foregroundStyle(DS.silver)
                        .submitLabel(.done)
                    origin
                    timeRow
                    MealItemsEditor(foods: $foods, locale: locale, search: $search)
                    if meal.source == .photo, keepsScannedFoods, let note = meal.aiNote, !note.isEmpty {
                        Text(note)
                            .font(.ui(13))
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if foods.isEmpty {
                        Text("Every food is removed: saving now deletes this meal.",
                             comment: "Meal editor: all the foods were taken out")
                            .font(.ui(13))
                            .foregroundStyle(DS.silver.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    WideButton(title: foods.isEmpty ? String(localized: "Delete meal") : String(localized: "Save"),
                               prominent: true, fontSize: 16, verticalPadding: 14, cornerRadius: 14) { save() }
                    if !foods.isEmpty {
                        Button {
                            confirmsDelete = true
                        } label: {
                            Label(String(localized: "Delete meal"), systemImage: "trash")
                                .font(.ui(14, .semibold))
                                .foregroundStyle(DS.silver.opacity(0.65))
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Edit meal", comment: "Title: a logged meal, to change or delete"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
            .confirmationDialog(String(localized: "Delete this meal?", comment: "Meal editor: confirms deleting the meal"),
                                isPresented: $confirmsDelete, titleVisibility: .visible) {
                Button(String(localized: "Delete meal"), role: .destructive) { delete() }
                Button(String(localized: "Cancel"), role: .cancel) {}
            } message: {
                Text("It comes off the day's calories and macros.", comment: "Meal editor: what deleting a meal does")
            }
        }
        // A swipe down doesn't drop changes: Cancel does.
        .interactiveDismissDisabled(hasChanges)
        .dsLayoutRoot()
        .dsSheetSizing(.form)
        #if DEBUG
        .onAppear(perform: applyPreview)
        #endif
    }

    /// A food the scan read is still in the meal: the scan's confidence and
    /// note still speak for it.
    private var keepsScannedFoods: Bool {
        foods.contains { $0.basis == "estimate" || $0.aiGrams != nil || $0.aiKcal != nil }
    }

    /// Where the meal came from: the scan's confidence, or "Typed".
    @ViewBuilder
    private var origin: some View {
        switch meal.source {
        case .photo:
            if let confidence = meal.confidence, keepsScannedFoods {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                    Text(MealScanSheet.confidenceText(confidence))
                }
                .font(.ui(12.5, .semibold))
                .foregroundStyle(DS.silver.opacity(0.65))
            }
        case .manual:
            MealSourceBadge(source: .manual)
        }
    }

    /// When it was eaten: a day and a time, up to now. Another day says so:
    /// saved, the meal leaves this day's list for that one.
    private var timeRow: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Text("Eaten", comment: "Meal editor: when the meal was eaten, before a date and time")
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                    .accessibilityHidden(true)
                Spacer(minLength: 8)
                DatePicker(String(localized: "Eaten", comment: "Meal editor: when the meal was eaten, before a date and time"),
                           selection: $date, in: ...max(Date(), meal.date), displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(DS.silver)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface))
            if !Calendar.current.isDate(date, inSameDayAs: meal.date) {
                Text(String(localized: "Moves to \(date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))) when saved.",
                            comment: "Meal editor: the meal's day was changed; the new day: Moves to Sat, 21 Nov when saved."))
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 4)
            }
        }
    }

    /// What would be saved differs from the meal: its foods as they'd be
    /// logged (not the slider's ends, which typed grams widen), its name or
    /// its time.
    private var hasChanges: Bool {
        foods.map(\.logged) != openedFoods.map(\.logged) || title != meal.title || date != meal.date
    }

    /// With foods left, the meal as it's set now replaces the one logged;
    /// with none, deleting it is asked first. Unchanged, it just closes.
    private func save() {
        guard !foods.isEmpty else {
            confirmsDelete = true
            return
        }
        guard hasChanges else {
            dismiss()
            return
        }
        var edited = meal
        // A name cleared: its foods', as the quick log names a meal.
        let typed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        edited.title = typed.isEmpty ? QuickLogText.mealTitle(foods) : typed
        edited.date = date
        edited.items = foods.map(\.logged)
        withAnimation { _ = daily.updateMeal(edited) }
        dismiss()
    }

    private func delete() {
        withAnimation { daily.deleteMeal(id: meal.id) }
        dismiss()
    }

    #if DEBUG
    /// `-mealscan.preview editChanged`: the phở slid to 450 g, the eggs two
    /// steps up (3) and the food typed in by hand ×1½, through the rows' own
    /// setters; `editAdd` the food search with the preview's words, and
    /// `editManual` straight on adding them by hand.
    private func applyPreview() {
        guard foods == openedFoods, let preview = MealScanPreview.takePending() else { return }
        switch preview {
        case .editChanged:
            if let index = foods.firstIndex(where: { $0.control == .amount }) { foods[index].setGrams(fromSlider: 450) }
            if let index = foods.firstIndex(where: { $0.control == .count }) {
                foods[index].stepCount(up: true)
                foods[index].stepCount(up: true)
            }
            if let index = foods.firstIndex(where: { $0.control == .multiplier }) { foods[index].stepCount(up: true) }
        case .editAdd, .editManual:
            Task {
                // After this sheet has finished coming up.
                try? await Task.sleep(for: .milliseconds(700))
                search = MealFoodSearchRequest(query: MealScanPreview.query, opensByHand: preview == .editManual)
            }
        default:
            break
        }
    }
    #endif
}

// MARK: - Self-test (DEBUG)

#if DEBUG
extension MealReviewFood {
    /// A logged food comes back from the editor exactly as it was logged
    /// until it's changed, and then changes as it should: a table food
    /// logged from this table by the table, one logged under another by its
    /// own numbers, an estimate by weight or by count, a food of the first
    /// scans, a typed meal's food as a multiple with typed calories; foods
    /// typed in by hand; a logged meal's edit keeping what it came with; and
    /// words heard joining the note. Returns what failed, nothing when all
    /// held. Run once a launch from Today (`MealScanPreview.checkSavedMeals`).
    static func selfTest() -> [String] {
        var failures: [String] = []
        func check(_ holds: Bool, _ what: @autoclosure () -> String) {
            if !holds { failures.append(what()) }
        }
        let table = FoodTable.shared

        // Table foods.
        let tea = MealEntry.Item(name: "Iced lemon tea", grams: 350, kcal: 105, proteinG: 0, fatG: 0, carbsG: 26,
                                 basis: "estimate", unit: "g", aiGrams: 350, aiKcal: 105)
        if let pho = table.entry(id: "vn.pho_bo_tai"), let egg = table.entry(id: "egg_boiled") {
            var phoItem = MealReviewFood(entry: pho, grams: 450, locale: "en").logged
            phoItem.aiGrams = 674
            phoItem.aiKcal = 477
            phoItem.modelGrams = 674
            phoItem.modelKcal = 450
            let phoBack = MealReviewFood(saved: phoItem, mealSource: .photo, locale: "en")
            check(phoBack.entry != nil && phoBack.control == .amount && phoBack.servingGrams == pho.size.g,
                  "a logged table food didn't take the table's numbers")
            check(phoBack.logged == phoItem, "a logged table food changed on its way through the editor")
            check(phoBack.amountWords(locale: "en") == "≈ ¾ bowl",
                  "a logged table food's words: \(phoBack.amountWords(locale: "en") ?? "none")")
            let eggs = MealReviewFood(entry: egg, count: 2, locale: "en")
            check(eggs.control == .count && eggs.grams == 100 && eggs.logged.kcal == 155, "2 eggs from the table read wrong")
            var eggsBack = MealReviewFood(saved: eggs.logged, mealSource: .photo, locale: "en")
            check(eggsBack.entry != nil && eggsBack.logged == eggs.logged, "logged eggs changed on their way through the editor")
            eggsBack.stepCount(up: true)
            check(eggsBack.count == 2.5 && eggsBack.logged.grams == 125,
                  "a step on logged eggs went to \(eggsBack.count), \(eggsBack.logged.grams) g")
            let byWeight = MealReviewFood(entry: egg, grams: 100, locale: "en")
            check(byWeight.control == .count && abs(byWeight.count - 2) < 0.001, "100 g of eggs isn't 2 eggs")
            let twoBowls = MealReviewFood(entry: pho, count: 2, locale: "en")
            check(twoBowls.control == .amount && twoBowls.grams == min(pho.size.g * 2, gramLimits.upperBound),
                  "2 bowls of phở read wrong")
            // Logged under another version of the table: its own numbers, scaled.
            var older = phoItem
            older.kcal += 25
            var olderBack = MealReviewFood(saved: older, mealSource: .photo, locale: "en")
            check(olderBack.entry == nil && olderBack.logged == older, "a food from another table took this table's numbers")
            olderBack.setGrams(typed: "900")
            check(olderBack.logged.kcal == Int((Double(older.kcal) * 2).rounded()), "a food from another table didn't scale")
        } else {
            failures.append("the food table lacks the self-test's foods")
        }

        // Estimates: by weight, and counted with no weight.
        var teaBack = MealReviewFood(saved: tea, mealSource: .photo, locale: "en")
        check(teaBack.control == .amount && teaBack.logged == tea, "a logged estimate changed on its way through the editor")
        teaBack.setGrams(typed: "700")
        check(teaBack.logged.kcal == 210 && teaBack.logged.carbsG == 52, "a logged estimate didn't scale with its grams")
        teaBack.setKcal(typed: "1")
        check(teaBack.logged.kcal == 210, "a scanned food's calories could be typed")
        let quay = MealEntry.Item(name: "Bánh quẩy", grams: 0, kcal: 345, proteinG: 6, fatG: 18, carbsG: 41,
                                  basis: "estimate", unit: "piece", count: 3, aiGrams: 0, aiKcal: 230)
        var quayBack = MealReviewFood(saved: quay, mealSource: .photo, locale: "en")
        check(quayBack.control == .count && quayBack.logged == quay, "a counted food with no weight changed on its way through the editor")
        quayBack.stepCount(up: true)
        check(quayBack.count == 4 && quayBack.logged.kcal == 460 && quayBack.logged.grams == 0,
              "a counted food with no weight stepped to \(quayBack.count), \(quayBack.logged.kcal) kcal")

        // Edited again and again, an estimate scales from its numbers before
        // rounding: 350 g → 20 g → 350 g is the 105 kcal and 26 g of carbs
        // it came with, even through 1 g (review 2026-11-23).
        var sipped = MealReviewFood(saved: tea, mealSource: .photo, locale: "en")
        for typed in ["20", "1", "350"] {
            sipped.setGrams(typed: typed)
            sipped = MealReviewFood(saved: sipped.logged, mealSource: .photo, locale: "en")
        }
        check(sipped.logged.kcal == 105 && sipped.logged.carbsG == 26,
              "an estimate drifted to \(sipped.logged.kcal) kcal, C \(sipped.logged.carbsG) g over edits")

        // A food of the first scans: no unit or basis.
        let first = MealEntry.Item(name: "Grilled chicken thigh", grams: 150, kcal: 290, proteinG: 38, fatG: 15, carbsG: 0)
        var firstBack = MealReviewFood(saved: first, mealSource: .photo, locale: "en")
        check(firstBack.control == .amount && firstBack.basis == "estimate" && !firstBack.isManual, "a first-scan food read wrong")
        firstBack.setGrams(typed: "300")
        check(firstBack.logged.kcal == 580 && firstBack.logged.proteinG == 76, "a first-scan food didn't scale")

        // A typed meal's food (QuickLogSheet's): a multiple, calories typed.
        let typed = MealEntry.Item(name: "Phở bò", grams: 0, kcal: 450, proteinG: 28, fatG: 12, carbsG: 58)
        var typedBack = MealReviewFood(saved: typed, mealSource: .manual, locale: "en")
        check(typedBack.control == .multiplier && typedBack.isManual, "a typed meal's food isn't a multiple typed in by hand")
        var typedLogged = typed
        typedLogged.basis = manualBasis
        check(typedBack.logged == typedLogged, "a typed meal's food changed on its way through the editor")
        typedBack.stepCount(up: true)
        check(typedBack.count == 1.5 && typedBack.logged.kcal == 675 && typedBack.logged.proteinG == 42, "×1½ of a typed food went wrong")
        typedBack.setKcal(typed: "600")
        check(typedBack.logged.kcal == 600 && typedBack.logged.proteinG == 42,
              "600 kcal typed at ×1½ came to \(typedBack.logged.kcal) kcal")
        for _ in 0..<10 { typedBack.stepCount(up: true) }
        check(typedBack.count == multiplierLimits.upperBound, "a multiple went to ×\(typedBack.count)")
        for _ in 0..<20 { typedBack.stepCount(up: false) }
        check(typedBack.count == multiplierLimits.lowerBound, "a multiple went down to ×\(typedBack.count)")
        check(typedBack.amountWords(locale: "en") == "×¼", "a multiple's words: \(typedBack.amountWords(locale: "en") ?? "none")")

        // A counted table food at a part of a piece comes back with the
        // entry's piece, not the whole grams over the count (½ date: 3.5 g
        // logged as 4 g); review 2026-11-23.
        if let dates = table.entry(id: "dates") {
            let half = MealReviewFood(entry: dates, count: 0.5, locale: "en").logged
            var back = MealReviewFood(saved: half, mealSource: .manual, locale: "en")
            check(back.pieceGrams == dates.size.g && back.entry != nil && back.logged == half,
                  "½ date came back with a \(back.pieceGrams) g piece")
            back.stepCount(up: true)
            check(abs(back.grams - back.count * dates.size.g) < 0.01, "a step on ½ date went to \(back.grams) g")
        }

        // A scan's food counted by the portion, with no weight, opens as it
        // was read ("1 glass"), and as servings once its count changed.
        let glass = MealScanItem(name: "Iced tea", portion: "1 glass", grams: 0, kcal: 90, proteinG: 0, fatG: 0, carbsG: 22,
                                 basis: "estimate")
        var poured = MealReviewFood(scanned: glass, table: table, tableVersion: nil, locale: "en")
        let pouredBack = MealReviewFood(saved: poured.logged, mealSource: .photo, locale: "en")
        check(poured.countsPortions && pouredBack.countsPortions && pouredBack.amountWords(locale: "en") == "1 glass"
              && pouredBack.logged == poured.logged,
              "a food counted by the portion came back as \(pouredBack.amountWords(locale: "en") ?? "nothing")")
        poured.stepCount(up: true)
        let refilled = MealReviewFood(saved: poured.logged, mealSource: .photo, locale: "en")
        check(refilled.countsPortions && refilled.logged == poured.logged
              && refilled.amountWords(locale: "en") == poured.amountWords(locale: "en"),
              "a food counted by the portion, stepped, came back as \(refilled.amountWords(locale: "en") ?? "nothing")")

        // A meal's macros mean something food by food: a scan edited down to
        // a food typed in by hand without any has none; a typed meal of
        // table foods has the table's; a typed meal from before has none,
        // the first scans' foods theirs.
        let typedOnly = MealEntry(date: Date(), title: "Lunch", items: [MealReviewFood(manualName: "Sticky rice", kcal: 320).logged])
        check(!typedOnly.carriesMacros, "a scanned meal left with a food typed in by hand claims macros")
        if let egg = table.entry(id: "egg_boiled") {
            let typedTable = MealEntry(date: Date(), title: "Eggs", items: [MealReviewFood(entry: egg, count: 2, locale: "en").logged],
                                       source: .manual)
            check(typedTable.carriesMacros, "a typed meal of table foods has no macros")
        }
        let olderTyped = MealEntry(date: Date(), title: "Phở", items: [MealEntry.Item(name: "Phở", grams: 0, kcal: 450, proteinG: 0,
                                                                                     fatG: 0, carbsG: 0)], source: .manual)
        let firstScanZero = MealEntry(date: Date(), title: "Tea", items: [MealEntry.Item(name: "Tea", grams: 300, kcal: 2, proteinG: 0,
                                                                                         fatG: 0, carbsG: 0)])
        check(!olderTyped.carriesMacros && firstScanZero.carriesMacros, "older meals' macros read wrong")

        // Typed in by hand, with grams and without.
        let byHand = MealReviewFood(manualName: "Grandma's stew", kcal: 400, grams: 250, proteinG: 30)
        check(byHand.control == .amount && byHand.isManual && byHand.carriesMacros && byHand.logged.grams == 250,
              "a food typed in with grams read wrong")
        let noMacros = MealReviewFood(manualName: "Sticky rice", kcal: 320)
        check(noMacros.control == .multiplier && !noMacros.carriesMacros && !showsMacros([noMacros])
              && showsMacros([noMacros, byHand]) && showsMacros([]), "the macros of foods typed in by hand show wrong")
        let noMacrosBack = MealReviewFood(saved: noMacros.logged, mealSource: .photo, locale: "en")
        check(noMacrosBack.isManual && noMacrosBack.logged == noMacros.logged, "a food typed in by hand changed when it came back")

        // A logged meal's edit keeps what the meal came with.
        let url = URL.temporaryDirectory.appending(path: "meal-editor-selftest-\(UUID().uuidString).json")
        let store = DailyStore(fileURL: url)
        let kept = MealEntry.Item(name: "Phở", grams: 674, kcal: 477, proteinG: 31, fatG: 8, carbsG: 72, ref: "vn.pho_bo_tai",
                                  basis: "table", unit: "g", aiGrams: 674, aiKcal: 477, modelGrams: 600, modelKcal: 450)
        let meal = MealEntry(date: Date(timeIntervalSince1970: 1_795_000_000), title: "Lunch", items: [kept, tea],
                             confidence: "high", aiNote: "Assumed a big bowl.")
        store.addMeal(meal)
        var edited = meal
        edited.title = "Late lunch"
        edited.date = meal.date.addingTimeInterval(3_600)
        var smaller = kept
        smaller.grams = 450
        smaller.kcal = 318
        smaller.aiKcal = nil
        smaller.modelKcal = nil
        edited.items = [smaller, MealReviewFood(manualName: "Bread", kcal: 150).logged]
        edited.source = .manual
        edited.confidence = nil
        edited.aiNote = nil
        check(store.updateMeal(edited), "a logged meal's edit wasn't saved")
        if let saved = store.meals.first(where: { $0.id == meal.id }) {
            check(saved.title == "Late lunch" && saved.date == edited.date && saved.items.count == 2 && saved.kcal == 468,
                  "a logged meal's edit read wrong")
            check(saved.source == .photo && saved.confidence == "high" && saved.aiNote == "Assumed a big bowl.",
                  "a logged meal's edit lost where it came from")
            check(saved.items[0].aiKcal == 477 && saved.items[0].modelKcal == 450 && saved.items[0].grams == 450,
                  "a logged meal's edit lost what the scan sent")
        } else {
            failures.append("a logged meal's edit lost the meal")
        }
        var emptied = edited
        emptied.items = []
        check(!store.updateMeal(emptied) && store.meals.count == 1, "a logged meal was emptied instead of deleted")
        var stranger = edited
        stranger.id = UUID()
        check(!store.updateMeal(stranger) && store.meals.count == 1, "an edit of a meal no longer logged added one")
        try? FileManager.default.removeItem(at: url)

        // Words heard go after the note's last part, within 200 characters.
        check(MealNote.appending("with fish sauce", to: "Stir-fried, Little oil") == "Stir-fried, Little oil, with fish sauce",
              "words heard joined the note wrong")
        check(MealNote.appending(" no onions ", to: "") == "no onions" && MealNote.appending("x", to: "Fried, ") == "Fried, x",
              "words heard joined an empty or open note wrong")
        check(MealNote.appending(String(repeating: "a", count: 300), to: "Fried").utf16.count == MealNote.maxLength,
              "words heard took the note past 200 characters")
        return failures
    }
}
#endif
