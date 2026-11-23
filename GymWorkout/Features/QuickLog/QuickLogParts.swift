//
//  QuickLogParts.swift
//  GymWorkout
//
//  The pieces of the quick log (2026-11-22): reading a phrase into the open
//  tab, the hold-or-tap mic, the number fields, the water buttons, and the
//  meal row with its "Typed" badge that Today's meals list shares.
//
//  Food by words (2026-11-23, owner-approved): what the Food tab makes of
//  the words in its field (`QuickFoodReading`: the food table's matches for
//  a food's name, or each food a phrase holds, read by `FoodPhraseParser`)
//  and a food read before it goes into the meal (`QuickFoodDraft`).
//

import SwiftUI

/// Which field of the quick log has the keyboard.
enum QuickLogField: Hashable {
    case phrase, walk, mealTitle
    /// A food typed in by hand on the Food tab, by its draft's id.
    case draftName(UUID), draftKcal(UUID), draftGrams(UUID)
}

// MARK: - Reading a phrase

/// Reads what was said or typed for the open tab. The open tab decides,
/// unless the words clearly name another kind ("walked 30 minutes" on the
/// Water tab) and the open tab's own reading found nothing definite. A bare
/// number reads in the open tab's unit: minutes or steps for a walk,
/// calories for food (the parser already reads one as water).
///
/// Only plain water moves a phrase to the Water tab: juice, coffee, milk tea
/// or beer said without calories stays on Food with its name ("1 ly nước
/// cam"). Calories or protein make a phrase food on the Water tab too ("a
/// glass of milk 150 kcal").
enum QuickLogReading {
    /// A walk's pace, as `WalkSuggestion` counts it.
    static let stepsPerMinute = 100

    static func read(_ text: String, preferring kind: QuickLogKind, walkInMinutes: Bool,
                     heightCm: Double) -> QuickLog? {
        if kind == .water, let meal = QuickLogParser.parse(text, as: .food, heightCm: heightCm), isDefinite(meal) {
            return meal
        }
        let own = QuickLogParser.parse(text, as: kind, heightCm: heightCm)
        if let own, isDefinite(own) { return own }
        let normalized = QuickLogParser.normalize(text)
        let detected = QuickLogParser.detect(normalized)
        let mayMove = detected != .water || QuickLogParser.isPlainWater(normalized)
        if detected != kind, mayMove, let other = QuickLogParser.parse(text, as: detected, heightCm: heightCm),
           isDefinite(other) {
            return other
        }
        if let own { return own }
        // A plain number under a million, so it always fits an Int.
        guard let value = QuickLogParser.amount(normalized), value >= 0.5 else { return nil }
        let number = Int(value.rounded())
        switch kind {
        case .water:
            return nil
        case .steps:
            if walkInMinutes {
                return number <= 600 ? .steps(count: number * stepsPerMinute, minutes: number) : nil
            }
            return number <= 100_000 ? .steps(count: number, minutes: nil) : nil
        case .food:
            return number <= 10_000 ? .food(name: "", kcal: number, proteinG: nil, fatG: nil, carbsG: nil) : nil
        }
    }

    /// Water and walks are only read with an amount; a meal needs its
    /// calories or protein to be more than a name.
    private static func isDefinite(_ log: QuickLog) -> Bool {
        if case .food(_, let kcal, let protein, _, _) = log { return kcal != nil || protein != nil }
        return true
    }
}

// MARK: - Mic

/// The quick log's mic: hold to talk and let go to read it, or tap to start
/// and tap again to stop. VoiceOver's double-tap starts and stops it.
struct QuickLogMicButton: View {
    var state: VoiceInput.State
    var onPress: () -> Void
    var onRelease: () -> Void
    var onToggle: () -> Void

    @GestureState private var isPressed = false

    var body: some View {
        let isOn = state == .listening
        ZStack {
            Circle().fill(isOn ? DS.silver : DS.silver.opacity(0.08))
            if state == .preparing {
                ProgressView()
                    .tint(DS.silver)
            } else {
                Image(systemName: isOn ? "waveform" : "mic.fill")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(isOn ? DS.ink : DS.silver)
                    .symbolEffect(.variableColor.iterative, isActive: isOn)
            }
        }
        .frame(width: 48, height: 48)
        .overlay(Circle().strokeBorder(DS.silver.opacity(isOn ? 0 : 0.12), lineWidth: 1))
        .scaleEffect(isPressed ? 0.92 : 1)
        .animation(.easeOut(duration: 0.12), value: isPressed)
        .animation(.easeOut(duration: 0.2), value: isOn)
        .contentShape(Circle())
        // Down and up as they happen (a cancelled touch counts as up), so
        // the sheet can tell a hold from a tap.
        .gesture(DragGesture(minimumDistance: 0).updating($isPressed) { _, pressed, _ in pressed = true })
        .onChange(of: isPressed) { _, down in
            if down { onPress() } else { onRelease() }
        }
        .dsHover(.highlight)
        .accessibilityElement()
        .accessibilityLabel(isOn || state == .preparing
                            ? String(localized: "Stop listening", comment: "Quick log mic, VoiceOver")
                            : String(localized: "Speak", comment: "Quick log mic, VoiceOver"))
        .accessibilityHint(isOn || state == .preparing
                           ? String(localized: "Fills in what you said. Nothing is logged until you confirm.")
                           : String(localized: "Listens until you double-tap again."))
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { onToggle() }
    }
}

// MARK: - Fields

/// A whole number typed on the number pad, with its unit beside it. Empty
/// is nil; past `maxValue`, it shows and keeps the most it can be.
struct QuickNumberField: View {
    var placeholder: String
    @Binding var value: Int?
    var unit: String
    var maxDigits = 6
    var maxValue: Int? = nil
    var fieldWidth: CGFloat = 76
    var focus: FocusState<QuickLogField?>.Binding
    var field: QuickLogField
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
                .frame(width: fieldWidth)
                .accessibilityLabel(accessibilityTitle)
                .accessibilityValue(value.map { "\($0) \(unit)" } ?? "")
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

/// A number field with its title on the left, and "Optional" under the
/// title unless the number is needed.
struct QuickNumberRow: View {
    var title: String
    @Binding var value: Int?
    var unit: String
    var maxDigits: Int
    var maxValue: Int? = nil
    var required = false
    var focus: FocusState<QuickLogField?>.Binding
    var field: QuickLogField
    /// What VoiceOver calls the field ("Calories of Big Mac"); the title
    /// when nil.
    var accessibilityTitle: String?

    var body: some View {
        let spoken = accessibilityTitle ?? title
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                if !required {
                    Text("Optional")
                        .font(.ui(11.5))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
            }
            .accessibilityHidden(true)
            Spacer(minLength: 8)
            QuickNumberField(placeholder: required ? "0" : "–", value: $value, unit: unit, maxDigits: maxDigits,
                             maxValue: maxValue, fieldWidth: 68, focus: focus, field: field,
                             accessibilityTitle: required ? spoken : String(localized: "\(spoken), optional"))
        }
    }
}

// MARK: - Water buttons

/// A saved water amount: tap logs it at once; press and hold (or VoiceOver's
/// actions) removes it, while more than one is left.
struct QuickLogPresetChip: View {
    var ml: Int
    var canRemove: Bool
    var onTap: () -> Void
    var onRemove: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                Image(systemName: "plus")
                    .font(.system(size: 11, weight: .bold))
                Text(DailyStore.litres(ml))
                    .font(.ui(15, .semibold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(DS.silver)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Capsule().fill(DS.silver.opacity(0.07)))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight)
        .contextMenu {
            if canRemove {
                Button(String(localized: "Remove this button"), systemImage: "minus.circle", role: .destructive,
                       action: onRemove)
            }
        }
        .accessibilityLabel(QuickLogText.addWater(ml))
        .accessibilityActions {
            if canRemove {
                Button(String(localized: "Remove this button"), action: onRemove)
            }
        }
    }
}

// MARK: - Meals

extension MealEntry {
    /// "12:30 PM · P 38 g · F 15 g · C 57 g": the time, and the macros when
    /// they mean something (`carriesMacros`) — a food typed in by hand often
    /// has calories only.
    var detailLine: String {
        let time = date.formatted(date: .omitted, time: .shortened)
        guard carriesMacros else { return time }
        return time + " · " + String(localized: "P \(proteinG) g · F \(fatG) g · C \(carbsG) g",
                                     comment: "A meal's macros: P 38 g · F 15 g · C 57 g")
    }
}

/// "TYPED" beside a meal the user typed in; a scanned meal has no badge.
struct MealSourceBadge: View {
    var source: MealEntry.Source

    var body: some View {
        if source == .manual {
            Text(String(localized: "TYPED", comment: "Badge on a meal the user typed in rather than scanned"))
                .font(.mono(9, .semibold))
                .trackingEm(0.08, size: 9)
                .foregroundStyle(DS.silver.opacity(0.65))
                .lineLimit(1)
                .fixedSize()
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Capsule().fill(DS.silver.opacity(0.08)))
                .accessibilityLabel(String(localized: "Typed in", comment: "VoiceOver: a meal the user typed in"))
        }
    }
}

/// One of today's meals in the quick log: name, time, macros and energy.
struct QuickLogMealRow: View {
    var meal: MealEntry

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(meal.title.isEmpty ? String(localized: "Meal") : meal.title)
                        .font(.ui(15.5, .semibold))
                        .foregroundStyle(DS.silver)
                        .lineLimit(2)
                    MealSourceBadge(source: meal.source)
                }
                Text(meal.detailLine)
                    .font(.ui(12.5))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver.opacity(0.6))
            }
            Spacer(minLength: 8)
            BigValue(value: meal.kcal.formatted(), unit: "kcal", size: 18)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Food by words

/// What the Food tab makes of the words in its field: nothing yet; while
/// they're a food's name alone ("com tam", "ức gà"), the food table's best
/// matches, live; once they hold an amount, calories or more than one food
/// ("một tô phở bò tái và hai quả trứng luộc", "2 eggs and a bowl of rice",
/// "200g ức gà, 1 bát cơm", "phở 450 kcal"), each food read
/// (`FoodPhraseParser`). Safe off the main thread; on the device, no
/// network, no AI.
nonisolated enum QuickFoodReading: Equatable, Sendable {
    case none
    /// A food's name alone: the table's matches, best first, and whether
    /// the full search has more.
    case search(query: String, results: [FoodEntry], hasMore: Bool)
    /// The foods read, in the order said.
    case foods([ParsedFood])

    /// Matches listed under the field; the food search has the rest.
    static let shownResults = 6

    /// `submitted`: the words are done (Return, or the mic): a number alone
    /// is then its calories; while it's typed it may be on its way to "200g
    /// ức gà", and reads as nothing. `typing`: a word is being typed at the
    /// end: a food there the table hasn't got ("2 t", "2 tr") is likely one
    /// not finished, and is left out until a pause.
    static func read(_ text: String, locale: String, submitted: Bool = true, typing: Bool = false,
                     table: FoodTable = .shared) -> QuickFoodReading {
        let words = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !words.isEmpty else { return .none }
        var foods = FoodPhraseParser.parse(words, language: locale, table: table)
        guard let first = foods.first else {
            // A number alone is its calories, as the quick log has always
            // read one on Food, once it's done.
            guard submitted, let kcal = bareCalories(words) else { return .none }
            return .foods([ParsedFood(phrase: words, name: "", quantity: nil, unitWord: nil, grams: nil, kcal: kcal,
                                      match: nil, alternatives: [], amountGrams: nil, count: nil)])
        }
        let nameAlone = foods.count == 1 && first.quantity == nil && first.grams == nil && first.kcal == nil
            && first.unitWord == nil && first.proteinG == nil && first.fatG == nil && first.carbsG == nil
        guard nameAlone else {
            if typing, !submitted, let last = foods.last, last.match == nil, last.kcal == nil { foods.removeLast() }
            return foods.isEmpty ? .none : .foods(foods)
        }
        // A name: the parser's own match first, with its next best (it reads
        // the words with their diacritics, "cá" isn't "cà", and leaves "tôi
        // ăn" out), then the table's search for those words; for a match
        // that names only some of them ("trà sữa không đường"), or none,
        // the search first. The words as typed only when nothing else finds
        // anything.
        let query = first.phrase.isEmpty ? words : first.phrase
        let limit = shownResults + 1
        var results: [FoodEntry] = []
        var seen = Set<String>()
        func add(_ entries: [FoodEntry]) {
            for entry in entries where seen.insert(entry.id).inserted { results.append(entry) }
        }
        if let match = first.match, !first.isPartialMatch {
            add([match] + first.alternatives)
            add(table.search(query, locale: locale, limit: limit))
        } else {
            add(table.search(query, locale: locale, limit: limit))
            add([first.match].compactMap { $0 } + first.alternatives)
            if results.isEmpty, query != words { add(table.search(words, locale: locale, limit: limit)) }
        }
        return .search(query: query, results: Array(results.prefix(shownResults)), hasMore: results.count > shownResults)
    }

    /// Whole calories in digits alone ("450"), 1 to 10,000.
    private static func bareCalories(_ text: String) -> Int? {
        guard text.count <= 5, text.allSatisfy({ $0.isASCII && $0.isNumber }), let value = Int(text),
              (1...10_000).contains(value) else { return nil }
        return value
    }
}

/// A food the Food tab read from a phrase, before it goes into the meal:
/// a table food (the parser's match, or another the member picked) at the
/// amount said, its numbers from the table; or a food typed in by hand —
/// its name and calories, its grams and macros if known — which is what a
/// food the table hasn't got becomes, and a food said with its calories
/// ("phở 450 kcal": logged with the numbers given, as the quick log always
/// has).
struct QuickFoodDraft: Identifiable, Equatable {
    let id = UUID()
    /// What was read.
    var parsed: ParsedFood
    /// The table food it is; nil when typed in by hand.
    var entry: FoodEntry?
    /// Typed in by hand: the name, the calories (1 to 10,000) and, if
    /// known, the grams, protein, fat and carbs.
    var name: String
    var kcal: Int?
    var grams: Int?
    var proteinG: Double?
    var fatG: Double?
    var carbsG: Double?
    /// The member changed it (picked another food, typed its numbers or
    /// name): kept while its words are typed around (`merge`).
    var isChanged = false

    /// What calories typed by hand can be.
    static let kcalRange = 0...10_000

    init(_ parsed: ParsedFood) {
        self.parsed = parsed
        name = Self.sentenceCased(parsed.name)
        grams = parsed.grams.map { Self.wholeGrams($0) }
        proteinG = parsed.proteinG
        fatG = parsed.fatG
        carbsG = parsed.carbsG
        // Said with its calories: logged with them, the table aside.
        if let said = parsed.kcal {
            kcal = said
        } else {
            entry = parsed.match
        }
    }

    /// Ready for the meal: a table food, or one typed in by hand with its
    /// calories (0 to 10,000: "coke zero 0 kcal").
    var isReady: Bool {
        entry != nil || kcal.map { Self.kcalRange.contains($0) } == true
    }

    /// Calories typed by hand past what a food can be.
    var kcalOutOfRange: Bool {
        entry == nil && kcal.map { !Self.kcalRange.contains($0) } == true
    }

    /// The name it goes by: the table's, or the one typed; with the name
    /// cleared, the words read ("Meal" for calories alone).
    func displayName(locale: String) -> String {
        if let entry { return entry.name(locale) }
        let typed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !typed.isEmpty { return typed }
        let read = Self.sentenceCased(parsed.name.trimmingCharacters(in: .whitespacesAndNewlines))
        return read.isEmpty ? String(localized: "Meal") : read
    }

    /// As it goes into the meal; nil while a food typed in by hand has no
    /// calories.
    func food(locale: String) -> MealReviewFood? {
        if let entry { return Self.tableFood(entry, read: parsed, locale: locale) }
        guard isReady, let kcal else { return nil }
        return MealReviewFood(manualName: displayName(locale: locale), kcal: Double(kcal), grams: grams.map(Double.init),
                              proteinG: proteinG, fatG: fatG, carbsG: carbsG)
    }

    /// The table foods it could be: the parser's match, then its next best.
    var candidates: [FoodEntry] {
        var seen = Set<String>()
        return ([parsed.match].compactMap { $0 } + parsed.alternatives).filter { seen.insert($0.id).inserted }
    }

    /// Typed in by hand now: a food from the by-hand form, with what it
    /// was given.
    mutating func typeIn(_ food: MealReviewFood) {
        let logged = food.logged
        isChanged = true
        entry = nil
        name = logged.name
        kcal = logged.kcal
        grams = logged.grams > 0 ? logged.grams : nil
        proteinG = logged.proteinG > 0 ? Double(logged.proteinG) : nil
        fatG = logged.fatG > 0 ? Double(logged.fatG) : nil
        carbsG = logged.carbsG > 0 ? Double(logged.carbsG) : nil
    }

    /// Under the food: its words as said, and how they were read.
    var caption: String {
        let said = "“\(parsed.phrase)”"
        guard let entry else {
            if parsed.kcal != nil {
                return String(localized: "\(said) · your numbers",
                              comment: "Quick log food: a food said with its calories, logged with them; the words said in quotes")
            }
            if parsed.match == nil {
                return String(localized: "\(said) · not in MUSQ's food table",
                              comment: "Quick log food: a food the food table hasn't got; the words said in quotes")
            }
            return String(localized: "\(said) · typed in by hand",
                          comment: "Quick log food: a food the member typed in by hand; the words said in quotes")
        }
        if entry.id == parsed.match?.id, parsed.isPartialMatch {
            return String(localized: "\(said) · closest match",
                          comment: "Quick log food: the food table's nearest food for words it only partly knows; the words said in quotes")
        }
        if entry.id == parsed.match?.id, parsed.amountIsGuess {
            return String(localized: "\(said) · check the amount",
                          comment: "Quick log food: pieces of a food served by amount, whose weight MUSQ guessed as one serving; the words said in quotes")
        }
        return said
    }

    /// A table food at the amount read: the parser's own grams and count for
    /// its match. Another entry takes the grams said; else a container's or
    /// spoon's grams the parser worked out for the match (a glass holds as
    /// much whatever is in it); else as many pieces or servings as were
    /// said (one when none).
    static func tableFood(_ entry: FoodEntry, read: ParsedFood, locale: String) -> MealReviewFood {
        // Grams said: by the gram, whatever the table counts it in.
        if let grams = read.grams {
            let amount = entry.id == read.match?.id ? read.amountGrams ?? grams : grams
            return MealReviewFood(entry: entry, weighed: amount, locale: locale)
        }
        if entry.id == read.match?.id, let amount = read.amountGrams {
            if entry.unit == .piece {
                return MealReviewFood(entry: entry, count: read.count ?? amount / entry.size.g, locale: locale)
            }
            return MealReviewFood(entry: entry, grams: amount, locale: locale)
        }
        if let match = read.match, let amount = read.amountGrams, match.unit == .g, entry.unit == .g,
           abs(amount - (read.quantity ?? 1) * match.size.g) > amount * 0.01 {
            return MealReviewFood(entry: entry, grams: amount, locale: locale)
        }
        return MealReviewFood(entry: entry, count: read.quantity ?? 1, locale: locale)
    }

    /// The foods read now, keeping what the member changed (a food picked,
    /// calories typed) on any food read just as before, so reading again as
    /// more is typed never undoes it: from the drafts shown, or from those
    /// the member changed (`changed`), which a reading in the middle of
    /// typing ("2 bát cơm v") may have read otherwise for a moment.
    static func merge(_ foods: [ParsedFood], into old: [QuickFoodDraft], changed: [QuickFoodDraft] = []) -> [QuickFoodDraft] {
        var unused = old
        var kept = changed.filter { draft in !old.contains { $0.id == draft.id } }
        return foods.map { food in
            if let index = unused.firstIndex(where: { $0.parsed == food }) { return unused.remove(at: index) }
            if let index = kept.firstIndex(where: { $0.parsed == food }) { return kept.remove(at: index) }
            return QuickFoodDraft(food)
        }
    }

    /// "Phở" from "phở": the first letter up, the rest as typed.
    static func sentenceCased(_ text: String) -> String {
        guard let first = text.first else { return text }
        return first.uppercased() + text.dropFirst()
    }

    /// Whole grams, 1 to 3,000, as a food typed in by hand takes them.
    private static func wholeGrams(_ grams: Double) -> Int {
        Int(min(max(grams, MealReviewFood.gramLimits.lowerBound), MealReviewFood.gramLimits.upperBound).rounded())
    }
}

/// A table food read from a phrase, as the Food tab lists it before it goes
/// into the meal: its name, its amount, grams and energy, and the words it
/// came from, with the arrows that say a tap changes it.
struct QuickFoodTableLabel: View {
    var food: MealReviewFood
    var caption: String
    var locale: String
    /// The amount in pieces or servings before the grams; not when grams
    /// were said ("200 g · 302 kcal", not "≈ 1¾ pieces · 200 g").
    var withWords = true

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(food.name)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                Text(verbatim: QuickLogText.amount(food, locale: locale, withWords: withWords))
                    .font(.ui(12.5))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver.opacity(0.6))
                Text(verbatim: caption)
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.45))
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            QuickFoodChangeGlyph()
                .accessibilityHidden(true)
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
    }
}

/// The arrows beside a food read from a phrase: a tap shows the foods it
/// could be.
struct QuickFoodChangeGlyph: View {
    var body: some View {
        Image(systemName: "chevron.up.chevron.down")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(DS.silver.opacity(0.45))
            .frame(width: 28, height: 44)
            .contentShape(Rectangle())
    }
}

// MARK: - Copy

/// Strings more than one piece of the quick log uses.
enum QuickLogText {
    /// "Add 750 ml", for a water button and the Add button.
    static func addWater(_ ml: Int) -> String {
        String(localized: "Add \(DailyStore.litres(ml))", comment: "Adds water: Add 750 ml")
    }

    /// "Add 500 ml of water": water said on the Food tab, logged as water.
    static func addWaterSaid(_ ml: Int) -> String {
        String(localized: "Add \(DailyStore.litres(ml)) of water",
               comment: "Quick log Food tab: logs the water said there as water: Add 500 ml of water")
    }

    /// "Add 2 foods": the foods read from a phrase, into the meal.
    static func addFoods(_ count: Int) -> String {
        count == 1
            ? String(localized: "Add 1 food", comment: "Quick log food: adds the one food read from the words to the meal")
            : String(localized: "Add \(count) foods", comment: "Quick log food: adds the foods read from the words to the meal: Add 2 foods")
    }

    /// "2 eggs · 100 g · 155 kcal", "1 bowl · 674 g · 477 kcal": a food's
    /// amount as it would go into the meal; "200 g · 302 kcal" without the
    /// words.
    static func amount(_ food: MealReviewFood, locale: String, withWords: Bool = true) -> String {
        let logged = food.logged
        let words = withWords || logged.grams == 0 ? food.amountWords(locale: locale) : nil
        switch (words, logged.grams > 0) {
        case (let words?, true):
            return String(localized: "\(words) · \(logged.grams) g · \(logged.kcal) kcal", comment: "A scanned food: 1 bowl · 200 g · 260 kcal")
        case (let words?, false):
            return String(localized: "\(words) · \(logged.kcal) kcal", comment: "A food by amount: 1 bowl · 459 kcal")
        case (nil, true):
            return String(localized: "\(logged.grams) g · \(logged.kcal) kcal", comment: "Quick log food: a food's grams and energy: 200 g · 330 kcal")
        case (nil, false):
            return String(localized: "\(logged.kcal) kcal", comment: "A food's energy: 459 kcal")
        }
    }

    /// The name a meal takes when none is typed: its food; "Beef pho +
    /// Boiled egg" for two; "Beef pho + 2 more" past that.
    static func mealTitle(_ foods: [MealReviewFood]) -> String {
        var seen = Set<String>()
        let names = foods.map { $0.name.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty && seen.insert($0).inserted }
        guard let first = names.first else { return String(localized: "Meal") }
        switch names.count {
        case 1: return first
        case 2: return String(localized: "\(first) + \(names[1])", comment: "A typed meal's name from its two foods: Beef pho + Boiled egg")
        default:
            return String(localized: "\(first) + \(names.count - 1) more",
                          comment: "A typed meal's name from its first food and how many others: Beef pho + 2 more")
        }
    }
}

// MARK: - Self-test (DEBUG)

#if DEBUG
extension QuickFoodDraft {
    /// What the Food tab reads from words and logs: the owner's examples
    /// come to the table's foods at the amounts said, with the table's
    /// numbers and hidden fat; a food's name lists matches instead; a food
    /// said with its calories, a food the table hasn't got and a number
    /// alone are typed in by hand; another table food takes the amount
    /// said; a food picked survives reading again; the meal's default name;
    /// and a meal logged this way comes back from the meal editor exactly as
    /// logged. Returns what failed, nothing when all held. Run once a launch
    /// from Today (`MealScanPreview.checkSavedMeals`).
    static func selfTest() -> [String] {
        var failures: [String] = []
        func check(_ holds: Bool, _ what: @autoclosure () -> String) {
            if !holds { failures.append(what()) }
        }
        func drafts(_ text: String) -> [QuickFoodDraft] {
            guard case .foods(let foods) = QuickFoodReading.read(text, locale: "en") else { return [] }
            return foods.map { QuickFoodDraft($0) }
        }
        func items(_ text: String) -> [MealEntry.Item] {
            drafts(text).compactMap { $0.food(locale: "en")?.logged }
        }
        let table = FoodTable.shared

        // "một tô phở bò tái và hai quả trứng luộc": a bowl of phở bò tái
        // (674 g by amount, its broth's added fat and sugar) and two boiled
        // eggs (counted, 100 g).
        let breakfast = items("một tô phở bò tái và hai quả trứng luộc")
        check(breakfast.map(\.ref) == ["vn.pho_bo_tai", "egg_boiled"], "the phở and eggs read as \(breakfast.map(\.ref))")
        if breakfast.count == 2, let pho = table.entry(id: "vn.pho_bo_tai") {
            let bowl = breakfast[0], eggs = breakfast[1]
            let values = pho.values(grams: 674)
            check(bowl.unit == "g" && bowl.count == nil && bowl.basis == "table" && bowl.grams == 674
                  && bowl.kcal == Int(values.kcal.rounded()) && bowl.proteinG == Int(values.proteinG.rounded())
                  && bowl.fatG == Int(values.fatG.rounded()) && bowl.carbsG == Int(values.carbsG.rounded()),
                  "a bowl of phở logged as \(bowl.grams) g, \(bowl.kcal) kcal")
            check(bowl.hidden?.oil == 3.4 && bowl.hidden?.sugar == 2.0, "the phở's hidden fat and sugar: \(String(describing: bowl.hidden))")
            check(eggs.unit == "piece" && eggs.count == 2 && eggs.grams == 100 && eggs.kcal == 155 && eggs.proteinG == 13,
                  "two eggs logged as \(eggs.count ?? 0), \(eggs.grams) g, \(eggs.kcal) kcal")
        }

        // "2 eggs and a bowl of rice", "200g ức gà, 1 bát cơm".
        let english = items("2 eggs and a bowl of rice")
        check(english.map(\.ref) == ["egg_boiled", "vn.com_trang"] && english.map(\.kcal) == [155, 195],
              "2 eggs and a bowl of rice: \(english.map(\.ref)) \(english.map(\.kcal))")
        let weighed = items("200g ức gà, 1 bát cơm")
        check(weighed.map(\.ref) == ["chicken_breast_grilled", "vn.com_trang"] && weighed.map(\.grams) == [200, 150]
              && weighed.map(\.kcal) == [302, 195], "200 g chicken and a bowl of rice: \(weighed.map(\.ref)) \(weighed.map(\.grams))")

        // A food's name alone lists its matches.
        if case .search(_, let results, _) = QuickFoodReading.read("com tam", locale: "en") {
            check(results.first?.id == "vn.com_tam_suon", "com tam's first match: \(results.first?.id ?? "none")")
        } else {
            failures.append("com tam didn't list matches")
        }
        check(QuickFoodReading.read("   ", locale: "en") == .none, "blank words read as something")

        // Said with calories: typed in by hand, with those numbers.
        let said = drafts("phở 450 kcal 20g protein")
        check(said.count == 1 && said.first?.entry == nil && said.first?.kcal == 450 && said.first?.name == "Phở",
              "phở 450 kcal read as \(said.map { "\($0.name) \($0.kcal ?? -1)" })")
        if let food = said.first?.food(locale: "en")?.logged {
            check(food.kcal == 450 && food.proteinG == 20 && food.basis == MealReviewFood.manualBasis && food.ref == nil,
                  "phở 450 kcal logged as \(food.kcal) kcal, P \(food.proteinG)")
        }

        // Not in the table: typed in by hand, calories needed; the rest from the table.
        var mixed = drafts("1 big mac và 1 ly trà đá")
        check(mixed.count == 2 && mixed.first?.entry == nil && mixed.first?.isReady == false && mixed.last?.entry?.id == "vn.tra_da",
              "a big mac and an iced tea read as \(mixed.map { $0.entry?.id ?? "by hand" })")
        if mixed.count == 2 {
            mixed[0].kcal = 563
            mixed[0].grams = 215
            let food = mixed[0].food(locale: "en")?.logged
            check(food?.name == "Big mac" && food?.kcal == 563 && food?.grams == 215 && food?.unit == "g",
                  "a big mac typed in logged as \(food?.name ?? "nothing"), \(food?.kcal ?? 0) kcal")
        }

        // A number alone is its calories.
        let bare = drafts("450")
        check(bare.count == 1 && bare.first?.kcal == 450 && bare.first?.displayName(locale: "en") == String(localized: "Meal"),
              "450 alone read as \(bare.map { $0.kcal ?? -1 })")

        // Another table food takes the amount said: two bowls of brown rice.
        if var rice = drafts("2 bát cơm").first, let brown = table.entry(id: "rice_brown_cooked") {
            rice.entry = brown
            let food = rice.food(locale: "en")?.logged
            check(food?.ref == "rice_brown_cooked" && food?.grams == 300, "2 bowls changed to brown rice: \(food?.grams ?? 0) g")
        }

        // Typed in by hand in place of a table food (the by-hand form).
        if var bowl = drafts("1 tô phở").first {
            bowl.typeIn(MealReviewFood(manualName: "Phở nhà làm", kcal: 520, grams: 600, proteinG: 30))
            let food = bowl.food(locale: "en")?.logged
            check(bowl.entry == nil && food?.name == "Phở nhà làm" && food?.kcal == 520 && food?.grams == 600
                  && food?.proteinG == 30 && food?.fatG == 0 && food?.ref == nil,
                  "a food typed in by hand in place of the phở logged as \(food?.name ?? "nothing"), \(food?.kcal ?? 0) kcal")
            check(bowl.caption.contains("“1 tô phở”"), "a food typed in by hand lost its words: \(bowl.caption)")
        }

        // A pick survives the words being read again, as more is typed, and
        // a reading in the middle of a word ("2 bát cơm v") that reads the
        // food otherwise for a moment (review 2026-11-23).
        if var first = drafts("2 bát cơm").first, let brown = table.entry(id: "rice_brown_cooked"),
           case .foods(let again) = QuickFoodReading.read("2 bát cơm, 1 quả trứng", locale: "en"),
           case .foods(let midway) = QuickFoodReading.read("2 bát cơm v", locale: "en"),
           case .foods(let after) = QuickFoodReading.read("2 bát cơm và 1 quả trứng", locale: "en") {
            first.entry = brown
            first.isChanged = true
            let merged = merge(again, into: [first])
            check(merged.count == 2 && merged[0].id == first.id && merged[0].entry?.id == "rice_brown_cooked",
                  "a pick was lost reading the words again")
            let between = merge(midway, into: [first], changed: [first])
            let back = merge(after, into: between, changed: [first])
            check(back.count == 2 && back[0].id == first.id && back[0].entry?.id == "rice_brown_cooked",
                  "a pick was lost typing “và …” after it")
        }

        // A number alone is calories only once it's done; a word being typed
        // at the end isn't a food yet (review 2026-11-23).
        check(QuickFoodReading.read("450", locale: "en", submitted: false) == .none, "a number typed alone read as food before Return")
        if case .foods(let typing) = QuickFoodReading.read("2 bát cơm và 1 q", locale: "vi", submitted: false, typing: true) {
            check(typing.count == 1, "a word being typed read as \(typing.count) foods")
        } else {
            failures.append("2 bát cơm with a word being typed read as no food")
        }

        // A name with a verb before it lists the parser's own food first,
        // diacritics as said; the search is for the food's words.
        if case .search(let query, let results, _) = QuickFoodReading.read("ăn trứng", locale: "vi") {
            check(query == "trứng" && results.first?.id == "egg_boiled",
                  "“ăn trứng” listed \(results.first?.id ?? "nothing") first for “\(query)”")
        } else {
            failures.append("“ăn trứng” didn't list matches")
        }

        // Grams said: by the gram, a food the table counts too.
        if let eggs = drafts("100g trứng").first?.food(locale: "en") {
            check(eggs.control == .amount && eggs.logged.grams == 100 && eggs.logged.unit == "g" && eggs.logged.ref == "egg_boiled",
                  "100 g of eggs: \(eggs.logged.grams) g by \(eggs.logged.unit ?? "nothing")")
            let back = MealReviewFood(saved: eggs.logged, mealSource: .manual, locale: "en")
            check(back.entry != nil && back.control == .amount && back.logged == eggs.logged,
                  "100 g of eggs changed on their way through the meal editor")
        } else {
            failures.append("100 g of eggs read as no food")
        }

        // Calories typed as 0 are a food's ("coke zero 0 kcal").
        var zero = drafts("cola zero 0 kcal").first
        zero?.kcal = 0
        check(zero?.isReady == true && zero?.food(locale: "en")?.logged.kcal == 0, "0 kcal typed isn't ready")

        // The meal's name when none is typed.
        let foods = drafts("một tô phở bò tái và hai quả trứng luộc").compactMap { $0.food(locale: "en") }
        check(QuickLogText.mealTitle(foods) == "\(foods.first?.name ?? "") + \(foods.last?.name ?? "")",
              "the meal's name: \(QuickLogText.mealTitle(foods))")
        check(QuickLogText.mealTitle([]) == String(localized: "Meal"), "an empty meal's name")

        // Logged as a typed meal, it opens in the meal editor as logged.
        var all = foods
        if let bigMac = mixed.first?.food(locale: "en") { all.append(bigMac) }
        let meal = MealEntry(date: Date(), title: QuickLogText.mealTitle(all), items: all.map(\.logged), source: .manual)
        for item in meal.items {
            let back = MealReviewFood(saved: item, mealSource: meal.source, locale: "en")
            check(back.logged == item && (item.ref == nil || back.entry != nil),
                  "\(item.name) changed on its way through the meal editor")
        }
        return failures
    }
}
#endif
