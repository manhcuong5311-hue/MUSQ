//
//  FoodTable.swift
//  GymWorkout
//
//  MUSQ's food reference table (2026-11-22), compiled by
//  Tools/food-table/build.py into Resources/FoodTable.json, the same file the
//  server reads (functions/src/data/foodTable.json). The meal scan matches
//  the foods in a photo to its entries; the review screen adds foods from it
//  and words their amounts: counted foods (an egg, a bánh mì) by the piece,
//  foods by amount (a bowl of phở, rice) by the gram. Values are per 100 g
//  as eaten (Tools/food-table/SPEC.md). Read once, on first use, and never
//  sent anywhere. Entries come and go with the table: nothing here assumes
//  a particular id.
//

import Foundation

/// One food or dish in the table.
nonisolated struct FoodEntry: Hashable, Identifiable, Sendable {
    /// Counted by the piece, or by amount in grams.
    nonisolated enum Unit: String, Hashable, Sendable { case piece, g }

    /// One piece (`.piece`: its edible grams and the piece word, "egg" /
    /// "quả"), or one typical serving (`.g`: "bowl" / "tô").
    nonisolated struct Size: Hashable, Sendable {
        var g: Double
        var en: String
        var vi: String
    }

    /// Energy and macros per 100 g as eaten.
    nonisolated struct Per100: Hashable, Sendable {
        var kcal: Double
        var p: Double
        var f: Double
        var c: Double
    }

    /// Grams of what a photo can't show, already counted in `per100`: added
    /// fat, added sugar, and sauces or dips.
    nonisolated struct Hidden: Hashable, Sendable {
        var oil: Double = 0
        var sugar: Double = 0
        var sauce: Double = 0

        func scaled(by factor: Double) -> Hidden {
            Hidden(oil: oil * factor, sugar: sugar * factor, sauce: sauce * factor)
        }
    }

    /// Energy and macros of an amount.
    nonisolated struct Values: Hashable, Sendable {
        var kcal: Double
        var proteinG: Double
        var fatG: Double
        var carbsG: Double

        func scaled(by factor: Double) -> Values {
            Values(kcal: kcal * factor, proteinG: proteinG * factor, fatG: fatG * factor, carbsG: carbsG * factor)
        }
    }

    var id: String
    /// "dish" or "food".
    var kind: String
    /// ISO country code of a dish's cuisine ("vn"), or "intl".
    var cuisine: String?
    var category: String?
    var en: String
    var vi: String
    /// Other names and spellings ("pho tai").
    var aka: [String]
    var unit: Unit
    var size: Size
    var per100: Per100
    /// Per 100 g, like `per100`.
    var hidden100: Hidden?

    /// The name in the member's language ("vi" or "en").
    func name(_ locale: String) -> String { locale == "vi" ? vi : en }

    /// "egg" / "quả" for a counted food, "bowl" / "tô" for a serving.
    func sizeWord(_ locale: String) -> String { locale == "vi" ? size.vi : size.en }

    /// per100 × grams / 100.
    func values(grams: Double) -> Values {
        let factor = grams / 100
        return Values(kcal: per100.kcal * factor, proteinG: per100.p * factor,
                      fatG: per100.f * factor, carbsG: per100.c * factor)
    }

    /// The hidden oil, sugar and sauce in an amount.
    func hidden(grams: Double) -> Hidden {
        (hidden100 ?? Hidden()).scaled(by: grams / 100)
    }

    /// The country a dish comes from, in the member's language ("Japan",
    /// "Nhật Bản"), so two dishes of one name can be told apart; nil for a
    /// plain food and an international dish.
    func cuisineName(_ locale: String) -> String? {
        // Two letters: "intl" isn't a country.
        guard kind == "dish", let code = cuisine, code.count == 2 else { return nil }
        let region = code.uppercased()
        // The system says "China mainland"; a cuisine is just Chinese.
        if region == "CN" { return locale == "vi" ? "Trung Quốc" : "China" }
        guard var name = Locale(identifier: locale).localizedString(forRegionCode: region), !name.isEmpty else { return nil }
        // "Myanmar (Burma)" as "Myanmar".
        if let qualifier = name.range(of: " (") { name = String(name[..<qualifier.lowerBound]) }
        return name
    }
}

/// The table: its entries by id, and search by name.
nonisolated final class FoodTable: Sendable {
    /// The table bundled with the app, read the first time anything asks.
    static let shared = FoodTable.bundled()

    /// The table's version: a hash of its content since 2026-11-22 (0 for
    /// the fixture the app shipped with first).
    let version: Int
    let entries: [FoodEntry]
    private let positions: [String: Int]
    /// Each entry's names, folded for search, in the order of `entries`.
    private let keys: [[SearchKey]]

    /// An id the table repeats keeps its first entry.
    init(version: Int, entries: [FoodEntry]) {
        var unique: [FoodEntry] = []
        var positions: [String: Int] = [:]
        for entry in entries where positions[entry.id] == nil {
            positions[entry.id] = unique.count
            unique.append(entry)
        }
        self.version = version
        self.entries = unique
        self.positions = positions
        keys = unique.map(SearchKey.keys(for:))
    }

    /// Reads a compiled table; entries it can't read are left out rather
    /// than losing the rest.
    convenience init(data: Data) throws {
        let file = try JSONDecoder().decode(TableFile.self, from: data)
        let entries = file.items.compactMap(\.value)
        #if DEBUG
        if entries.count < file.items.count {
            print("FoodTable: left out \(file.items.count - entries.count) unreadable entries")
        }
        #endif
        self.init(version: file.version ?? 0, entries: entries)
    }

    private static func bundled() -> FoodTable {
        guard let url = Bundle.main.url(forResource: "FoodTable", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let table = try? FoodTable(data: data) else {
            assertionFailure("FoodTable.json is missing from the app or unreadable")
            return FoodTable(version: 0, entries: [])
        }
        return table
    }

    func entry(id: String) -> FoodEntry? {
        positions[id].map { entries[$0] }
    }

    // MARK: Search

    /// Entries whose English or Vietnamese name, another name or category
    /// matches, best first. A whole name beats a whole word (or the words
    /// typed, together), which beats a name's start, a word's start, every
    /// word typed, anywhere in a name, then the letters run together. The
    /// name in the member's language counts for more than the other
    /// language's, so "pho" in English finds the phở before "Phô mai";
    /// only outside parentheses, so "rice" in Vietnamese finds Cơm trắng
    /// before "Bánh gạo lứt (rice cake)". Among equals, in turn: the word a
    /// name is about ("rice" in "Steamed white rice", not in "Rice
    /// noodles"); another name exactly as typed ("cơm" for Cơm trắng); the
    /// word in both languages' names and the other names (the phở's "pho",
    /// not Phô mai's); a plain food before a dish; more names with the
    /// word; the shorter name. Ignores case, diacritics and "đ" ("pho"
    /// finds "Phở bò tái", "dau" finds "Đậu"), an English plural ("egg"
    /// finds "Scrambled eggs") and, from a word's start, spaces ("banhmi"
    /// finds "Bánh mì", while "ranch" doesn't find "trà sữa trân châu").
    func search(_ query: String, locale: String, limit: Int = 60) -> [FoodEntry] {
        let folded = Self.fold(query)
        guard !folded.isEmpty else { return [] }
        let query = SearchQuery(text: folded)
        var hits: [SearchHit] = []
        for (index, entryKeys) in keys.enumerated() {
            var hit = SearchHit(index: index, isFood: entries[index].kind != "dish")
            var kinds = Set<SearchKey.Source>()
            for key in entryKeys {
                let match = key.match(query, locale: locale)
                if match > hit.match { hit.match = match }
                if match.isExact { hit.exact = true }
                if match.isWholeWord { kinds.insert(key.source) }
                if match.isWhole { hit.strong += 1 }
            }
            // The two names and the other names, however many of those.
            hit.kinds = kinds.count
            if hit.match.score > 0 { hits.append(hit) }
        }
        hits.sort { a, b in
            if a.match != b.match { return a.match > b.match }
            if a.exact != b.exact { return a.exact }
            if a.kinds != b.kinds { return a.kinds > b.kinds }
            if a.isFood != b.isFood { return a.isFood }
            if a.strong != b.strong { return a.strong > b.strong }
            let nameA = entries[a.index].name(locale), nameB = entries[b.index].name(locale)
            if nameA.count != nameB.count { return nameA.count < nameB.count }
            return nameA.localizedStandardCompare(nameB) == .orderedAscending
        }
        return hits.prefix(limit).map { entries[$0.index] }
    }

    /// Lowercase, no diacritics, "đ" as "d", anything but letters and
    /// digits as single spaces.
    static func fold(_ text: String) -> String {
        let plain = text.folding(options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive], locale: nil)
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "d")
        var result = ""
        var pendingSpace = false
        for scalar in plain.unicodeScalars {
            if CharacterSet.alphanumerics.contains(scalar) {
                if pendingSpace && !result.isEmpty { result.append(" ") }
                pendingSpace = false
                result.unicodeScalars.append(scalar)
            } else {
                pendingSpace = true
            }
        }
        return result
    }
}

// MARK: - Amount words

/// How the review screen and the food search word an amount: "2 eggs",
/// "½ egg", "⅛ pizza", "≈ ¾ bowl", "1½ tô". English puts the word a size is
/// about in the plural past one ("2 cans (330 ml)", "2 slices of pizza");
/// Vietnamese has no plural. A word that already carries an amount ("2
/// tablespoons", "about 10 berries", "nửa chén") never gets a count in
/// front of it.
nonisolated enum FoodAmount {
    /// "2", "½", "⅛", "1½"; other fractions to a tenth ("1.3"). `spoken`
    /// writes decimals ("1.5", "0.125"), which VoiceOver reads better than
    /// "1½".
    static func count(_ value: Double, spoken: Bool = false) -> String {
        if spoken { return value.formatted(.number.precision(.fractionLength(0...3))) }
        let whole = value.rounded(.down)
        let fraction = value - whole
        let wholeText = whole > 0 ? Int(whole).formatted() : ""
        if fraction < 0.01 { return Int(whole).formatted() }
        if fraction > 0.99 { return Int(whole + 1).formatted() }
        for (part, glyph) in eighths where abs(fraction - part) < 0.01 {
            return wholeText + glyph
        }
        return value.formatted(.number.precision(.fractionLength(0...1)))
    }

    private static let eighths: [(Double, String)] = [
        (0.125, "⅛"), (0.25, "¼"), (0.375, "⅜"), (0.5, "½"), (0.625, "⅝"), (0.75, "¾"), (0.875, "⅞"),
    ]

    /// The stops a counted food steps through on the review screen:
    /// eighths below one piece of 200 g or more (a whole pizza, a cake, a
    /// kimbap roll), quarters below one otherwise (or with no weight known),
    /// halves from one to three, whole pieces above.
    nonisolated struct Ladder: Hashable, Sendable {
        /// The first stop, and the step below one piece: ⅛ or ¼.
        var smallest: Double

        init(pieceGrams: Double) {
            smallest = pieceGrams >= 200 ? 0.125 : 0.25
        }

        /// How near a stop a count is on it. Counts come as grams over one
        /// piece's grams, both rounded, so a stop is rarely hit exactly.
        static let tolerance = 0.002

        /// The stop nearest a count: never under the smallest.
        func nearest(_ count: Double) -> Double {
            let stop: Double
            if count < 1 {
                stop = (count / smallest).rounded() * smallest
            } else if count < 3 {
                stop = (count * 2).rounded() / 2
            } else {
                stop = count.rounded()
            }
            return max(stop, smallest)
        }

        func isOn(_ count: Double) -> Bool {
            abs(count - nearest(count)) <= Self.tolerance
        }

        /// The next stop up or down from a count; from a count between
        /// stops, the one on that side.
        func next(after count: Double, up: Bool) -> Double {
            let slack = Self.tolerance
            if up {
                if count < 1 - slack { return ((count + slack) / smallest).rounded(.down) * smallest + smallest }
                if count < 3 - slack { return ((count + slack) * 2).rounded(.down) / 2 + 0.5 }
                return (count + slack).rounded(.down) + 1
            }
            if count <= 1 + slack { return ((count - slack) / smallest).rounded(.up) * smallest - smallest }
            if count <= 3 + slack { return ((count - slack) * 2).rounded(.up) / 2 - 0.5 }
            return (count - slack).rounded(.up) - 1
        }

        /// The highest stop at or under a count; nil under the smallest.
        func highest(atMost limit: Double) -> Double? {
            // Only float noise: a stop past the limit would pass 3 kg.
            let limit = limit + 1e-9
            guard limit >= smallest else { return nil }
            if limit < 1 { return (limit / smallest).rounded(.down) * smallest }
            if limit < 3 { return (limit * 2).rounded(.down) / 2 }
            return limit.rounded(.down)
        }
    }

    /// A count as the review words it: the stop it's on ("⅛", "2½"), else
    /// the nearest stop after "≈ ", or the smallest after "< " when the
    /// count is under half of it.
    static func onLadder(_ count: Double, _ ladder: Ladder) -> (count: Double, mark: String) {
        if count < ladder.smallest / 2 - Ladder.tolerance { return (ladder.smallest, "< ") }
        return (ladder.nearest(count), ladder.isOn(count) ? "" : "≈ ")
    }

    /// The count and the piece word: "2 eggs", "½ egg", "1 ổ"; just the
    /// count without a word. Nil when the word can't take a count in front
    /// (`takesCount`): the caller says it another way.
    static func pieces(_ count: Double, word: String, locale: String, spoken: Bool = false) -> String? {
        let number = Self.count(count, spoken: spoken)
        guard !word.isEmpty else { return number }
        guard takesCount(word) else { return nil }
        return "\(number) \(locale == "en" && count > 1 ? plural(word) : word)"
    }

    /// One piece or serving: "1 bowl", "1 ổ"; the word alone when it carries
    /// an amount of its own ("2 tablespoons").
    static func one(_ word: String, locale: String) -> String {
        pieces(1, word: word, locale: locale) ?? word
    }

    /// An amount as servings to the nearest quarter, "≈" when it isn't on
    /// one: "1 bowl", "≈ ¾ bowl", "1½ tô"; "< ¼ bowl" under an eighth of
    /// one. Nil when the word can't take a count in front.
    static func servings(_ servings: Double, word: String, locale: String, spoken: Bool = false) -> String? {
        if servings < 0.125 {
            return pieces(0.25, word: word, locale: locale, spoken: spoken).map { "< " + $0 }
        }
        let quarters = max(0.25, (servings * 4).rounded() / 4)
        let isOnQuarter = abs(servings - quarters) <= 0.03
        return pieces(quarters, word: word, locale: locale, spoken: spoken).map { (isOnQuarter ? "" : "≈ ") + $0 }
    }

    /// Whether a count can go in front of a size word: not when it starts
    /// with a number or a quantity word ("2 tablespoons", "½ cup", "about
    /// 10 berries", "half cup", "nửa chén", "khoảng 10 quả").
    static func takesCount(_ word: String) -> Bool {
        let trimmed = word.trimmingCharacters(in: .whitespaces)
        guard let first = trimmed.unicodeScalars.first else { return true }
        if CharacterSet.decimalDigits.contains(first) || "¼½¾⅓⅔⅛⅜⅝⅞".unicodeScalars.contains(first) { return false }
        let firstWord = trimmed.split(separator: " ").first.map { $0.lowercased() } ?? ""
        return !quantityWords.contains(firstWord)
    }

    private static let quantityWords: Set<String> = [
        "a", "an", "about", "around", "approx", "approximately", "half", "quarter", "one", "two", "three", "four",
        "five", "six", "seven", "eight", "nine", "ten", "dozen", "couple", "few", "several", "some",
        "nửa", "khoảng", "chừng", "tầm", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín", "mười",
        "vài", "mấy",
    ]

    /// An English size word in the plural: the noun it is about, the last
    /// word before a qualifier (" (", ",", " of ", " with ", " in "):
    /// "cans (330 ml)", "slices of pizza", "small bowls", "glasses, without
    /// ice".
    static func plural(_ word: String) -> String {
        var headEnd = word.endIndex
        for marker in [" (", ",", " of ", " with ", " in "] {
            if let range = word.range(of: marker), range.lowerBound < headEnd { headEnd = range.lowerBound }
        }
        let head = word[..<headEnd]
        let nounStart = head.lastIndex(of: " ").map { head.index(after: $0) } ?? head.startIndex
        let noun = String(head[nounStart...])
        guard !noun.isEmpty else { return word }
        return String(head[..<nounStart]) + pluralNoun(noun) + word[headEnd...]
    }

    /// One English noun in the plural: "eggs", "boxes", "patties",
    /// "potatoes", "loaves", "fish".
    private static func pluralNoun(_ noun: String) -> String {
        let lower = noun.lowercased()
        let irregular = ["leaf": "leaves", "loaf": "loaves", "half": "halves", "knife": "knives",
                         "potato": "potatoes", "tomato": "tomatoes", "mango": "mangoes",
                         "fish": "fish", "sushi": "sushi", "mochi": "mochi", "tofu": "tofu"]
        if let plural = irregular[lower] {
            return noun.first?.isUppercase == true ? plural.prefix(1).uppercased() + plural.dropFirst() : plural
        }
        if ["s", "x", "z", "ch", "sh"].contains(where: lower.hasSuffix) { return noun + "es" }
        if lower.hasSuffix("y"), let before = lower.dropLast().last, !"aeiou".contains(before) {
            return String(noun.dropLast()) + "ies"
        }
        return noun + "s"
    }
}

// MARK: - Reading the file

private nonisolated struct TableFile: Decodable {
    var version: Int?
    var items: [Lossy<FoodEntry>]
}

/// One array element that may fail on its own.
private nonisolated struct Lossy<Value: Decodable>: Decodable {
    var value: Value?

    init(from decoder: Decoder) throws {
        value = try? Value(from: decoder)
    }
}

nonisolated extension FoodEntry: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, kind, cuisine, cat, en, vi, aka, unit, size, per100, hidden100
    }

    private enum SizeKeys: String, CodingKey { case g, en, vi }
    private enum Per100Keys: String, CodingKey { case kcal, p, f, c }
    private enum HiddenKeys: String, CodingKey { case oil, sugar, sauce }

    /// Strict about what the numbers need (an id, a name, a size, per100),
    /// lenient about the rest: a unit other than "piece" is by amount, and a
    /// missing Vietnamese name or size word falls back to the English one.
    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        en = try container.decode(String.self, forKey: .en)
        let vi = try container.decodeIfPresent(String.self, forKey: .vi) ?? ""
        self.vi = vi.isEmpty ? en : vi
        kind = try container.decodeIfPresent(String.self, forKey: .kind) ?? "food"
        cuisine = try container.decodeIfPresent(String.self, forKey: .cuisine)
        category = try container.decodeIfPresent(String.self, forKey: .cat)
        aka = (try? container.decodeIfPresent([String].self, forKey: .aka)) ?? []
        unit = (try container.decodeIfPresent(String.self, forKey: .unit)) == "piece" ? .piece : .g

        let size = try container.nestedContainer(keyedBy: SizeKeys.self, forKey: .size)
        let grams = try size.decode(Double.self, forKey: .g)
        guard grams > 0 else {
            throw DecodingError.dataCorruptedError(forKey: .g, in: size, debugDescription: "A size needs grams")
        }
        let sizeEn = try size.decodeIfPresent(String.self, forKey: .en) ?? ""
        let sizeVi = try size.decodeIfPresent(String.self, forKey: .vi) ?? ""
        self.size = Size(g: grams, en: sizeEn, vi: sizeVi.isEmpty ? sizeEn : sizeVi)

        let per100 = try container.nestedContainer(keyedBy: Per100Keys.self, forKey: .per100)
        self.per100 = Per100(kcal: try per100.decode(Double.self, forKey: .kcal),
                             p: try per100.decodeIfPresent(Double.self, forKey: .p) ?? 0,
                             f: try per100.decodeIfPresent(Double.self, forKey: .f) ?? 0,
                             c: try per100.decodeIfPresent(Double.self, forKey: .c) ?? 0)

        if container.contains(.hidden100), let hidden = try? container.nestedContainer(keyedBy: HiddenKeys.self, forKey: .hidden100) {
            hidden100 = Hidden(oil: (try? hidden.decodeIfPresent(Double.self, forKey: .oil)) ?? 0,
                               sugar: (try? hidden.decodeIfPresent(Double.self, forKey: .sugar)) ?? 0,
                               sauce: (try? hidden.decodeIfPresent(Double.self, forKey: .sauce)) ?? 0)
        } else {
            hidden100 = nil
        }
    }
}

// MARK: - Search keys

/// What was typed, folded.
private nonisolated struct SearchQuery {
    var text: String
    var words: [String]
    var compact: String

    init(text: String) {
        self.text = text
        words = text.split(separator: " ").map(String.init)
        compact = words.joined()
    }
}

/// How well one name matches: its score (with the member's language's
/// boost) and whether the match is on the word the name is about. Compared
/// by those two only.
private nonisolated struct SearchMatch: Comparable {
    var score: Int
    var onHead = false
    /// The whole name, or the words typed as whole words, in any number
    /// ("eggs" for "egg").
    var isWholeWord = false
    /// The same, exactly as typed.
    var isWhole = false
    /// The whole name is what was typed.
    var isExact = false

    static let none = SearchMatch(score: 0)

    static func < (a: SearchMatch, b: SearchMatch) -> Bool {
        a.score != b.score ? a.score < b.score : (!a.onHead && b.onHead)
    }

    static func == (a: SearchMatch, b: SearchMatch) -> Bool {
        a.score == b.score && a.onHead == b.onHead
    }
}

/// An entry's best match, and what breaks a tie (see `FoodTable.search`).
private nonisolated struct SearchHit {
    var index: Int
    var isFood: Bool
    var match = SearchMatch.none
    /// Another name is exactly what was typed.
    var exact = false
    /// Which of the English name, the Vietnamese name and the other names
    /// have the word (0-3).
    var kinds = 0
    /// How many of its names have the word exactly.
    var strong = 0
}

/// One folded name of an entry.
private nonisolated struct SearchKey: Sendable {
    enum Source: Hashable, Sendable {
        /// The English or Vietnamese name ("en", "vi").
        case name(String)
        case otherName
        case category
    }

    /// A name, or a part of one, folded for search.
    nonisolated struct Folded: Sendable {
        var text: String
        var words: [String]
        var compact: String
        /// Where each word starts in `compact`, in UTF-8 bytes.
        var wordStarts: [Int]
        /// The word the name is about: in English the last one before a
        /// qualifier ("rice" in "Brown rice, cooked", "pho" in "Beef pho
        /// with rare beef"), in Vietnamese the first ("phở" in "Phở bò
        /// tái"); nil for other names, whose language isn't known.
        var head: Int?

        init?(_ raw: String, source: Source) {
            let text = FoodTable.fold(raw)
            guard !text.isEmpty else { return nil }
            self.text = text
            words = text.split(separator: " ").map(String.init)
            compact = words.joined()
            var offset = 0
            wordStarts = words.map { word in
                defer { offset += word.utf8.count }
                return offset
            }
            switch source {
            case .name("vi"): head = 0
            case .name: head = Self.englishHead(raw)
            case .otherName, .category: head = nil
            }
        }

        /// The last word before the first qualifier: " (", ",", ":", " with ",
        /// " in ", " on ", " of ".
        private static func englishHead(_ raw: String) -> Int? {
            var end = raw.endIndex
            for marker in ["(", ",", ":", " with ", " in ", " on ", " of "] {
                if let range = raw.range(of: marker, options: .caseInsensitive), range.lowerBound < end { end = range.lowerBound }
            }
            let count = FoodTable.fold(String(raw[..<end])).split(separator: " ").count
            return count > 0 ? count - 1 : nil
        }

        /// How well the words typed match, `boost` added to the score; an
        /// exact match scores `exactScore`.
        func match(_ query: SearchQuery, exactScore: Int, boost: Int) -> SearchMatch {
            if text == query.text {
                return SearchMatch(score: exactScore + boost, onHead: true, isWholeWord: true, isWhole: true, isExact: true)
            }
            if let (start, exactly) = wholeWords(query) {
                let onHead = head.map { start <= $0 && $0 < start + query.words.count } ?? false
                return SearchMatch(score: 90 + boost, onHead: onHead, isWholeWord: true, isWhole: exactly)
            }
            if text.hasPrefix(query.text) { return SearchMatch(score: 80 + boost) }
            if words.contains(where: { $0.hasPrefix(query.text) }) { return SearchMatch(score: 60 + boost) }
            if query.words.count > 1,
               query.words.allSatisfy({ typed in words.contains { $0.hasPrefix(typed) } }) { return SearchMatch(score: 50 + boost) }
            if text.contains(query.text) { return SearchMatch(score: 30 + boost) }
            if query.compact.count >= 3, runTogether(query.compact) { return SearchMatch(score: 20 + boost) }
            return .none
        }

        /// Where the words typed stand together as whole words, the last one
        /// also in an English plural or singular ("egg" in "Scrambled eggs"),
        /// and whether exactly as typed; an exact place first.
        private func wholeWords(_ query: SearchQuery) -> (start: Int, exactly: Bool)? {
            let count = query.words.count
            guard count > 0, count <= words.count else { return nil }
            var other: Int?
            for start in 0...(words.count - count) {
                var matches = true
                var exactly = true
                for offset in 0..<count {
                    let word = words[start + offset], typed = query.words[offset]
                    if word == typed { continue }
                    if offset == count - 1, Self.isPlural(word, of: typed) || Self.isPlural(typed, of: word) {
                        exactly = false
                        continue
                    }
                    matches = false
                    break
                }
                if matches && exactly { return (start, true) }
                if matches && other == nil { other = start }
            }
            return other.map { ($0, false) }
        }

        private static func isPlural(_ word: String, of singular: String) -> Bool {
            guard singular.count >= 3, word.hasPrefix(singular) else { return false }
            let ending = word.dropFirst(singular.count)
            return ending == "s" || ending == "es"
        }

        /// The letters typed, spaces aside, inside the name's letters run
        /// together from a word's start ("banhmi" finds "Bánh mì"), never
        /// from inside a word, so "ranch" doesn't find "trà sữa trân châu"
        /// (…tranchau) in either language.
        private func runTogether(_ letters: String) -> Bool {
            let name = Array(compact.utf8), typed = Array(letters.utf8)
            for start in wordStarts where start + typed.count <= name.count {
                if name[start..<start + typed.count].elementsEqual(typed) { return true }
            }
            return false
        }
    }

    var source: Source
    /// The whole name.
    var whole: Folded
    /// The part of a name the member's language's boost counts on: the name
    /// outside parentheses ("Bánh gạo lứt" of "Bánh gạo lứt (rice cake)"),
    /// the whole name when it has none; nil when nothing is outside them,
    /// and for other names and categories.
    var boosted: Folded?

    init?(_ raw: String, source: Source) {
        guard let whole = Folded(raw, source: source) else { return nil }
        self.source = source
        self.whole = whole
        guard case .name = source else { boosted = nil; return }
        let outside = Self.outsideParentheses(raw)
        boosted = outside == raw ? whole : Folded(outside, source: source)
    }

    /// The name without what's in parentheses: "Feijoada (đậu đen hầm
    /// thịt) kèm cơm" is "Feijoada  kèm cơm"; an unclosed "(" runs to the
    /// end.
    private static func outsideParentheses(_ raw: String) -> String {
        guard raw.contains("(") else { return raw }
        var outside = ""
        var depth = 0
        for character in raw {
            switch character {
            case "(":
                depth += 1
                outside.append(" ")
            case ")":
                depth = max(depth - 1, 0)
                outside.append(" ")
            default:
                if depth == 0 { outside.append(character) }
            }
        }
        return outside
    }

    static func keys(for entry: FoodEntry) -> [SearchKey] {
        var keys = [SearchKey(entry.vi, source: .name("vi")), SearchKey(entry.en, source: .name("en"))]
        keys += entry.aka.map { SearchKey($0, source: .otherName) }
        keys.append(entry.category.flatMap { SearchKey($0, source: .category) })
        return keys.compactMap { $0 }
    }

    func match(_ query: SearchQuery, locale: String) -> SearchMatch {
        // A category only ever tops up a weak match ("soup" finds the phở).
        if source == .category {
            return SearchMatch(score: whole.words.contains(where: { $0.hasPrefix(query.text) }) || whole.text.contains(query.text) ? 10 : 0)
        }
        // Another name exactly as typed counts as a whole word.
        let exactScore = source == .otherName ? 90 : 100
        // The name in the member's language counts for more, but only
        // outside parentheses: in "Bánh gạo lứt (rice cake)" the English
        // gloss is no more Vietnamese than the English name. The whole name
        // typed exactly still counts as theirs.
        let boost = 15
        guard source == .name(locale), let boosted else { return whole.match(query, exactScore: exactScore, boost: 0) }
        if boosted.text == whole.text || whole.text == query.text {
            return whole.match(query, exactScore: exactScore, boost: boost)
        }
        return max(whole.match(query, exactScore: exactScore, boost: 0), boosted.match(query, exactScore: exactScore, boost: boost))
    }
}
