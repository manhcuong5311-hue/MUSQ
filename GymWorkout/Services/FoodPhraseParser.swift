//
//  FoodPhraseParser.swift
//  GymWorkout
//
//  Reads a typed or spoken meal into foods (2026-11-22), so members without
//  the AI meal scan can log by hand: "một tô phở bò tái và hai quả trứng
//  luộc", "2 eggs and a bowl of rice", "200g ức gà", "phở 450 kcal". Each
//  food gets its words, its amount (a count, a container or grams) and the
//  food table entry it names, with its grams worked out, so the app computes
//  kcal and macros from the table. Vietnamese with or without diacritics and
//  English, whatever the app's language; on the device, no network, no AI.
//  Pure logic: the screens decide what to do with a food the table doesn't
//  have (the member enters it by hand).
//
//  How a phrase is read:
//  - Foods split at commas, semicolons, "+", "và"/"and"/"cộng"/"thêm"/"plus"
//    (unless the words together name one dish: "fish and chips"), at a verb
//    mid-phrase ("phở rồi uống trà đá") and where a second amount starts
//    ("một tô phở hai quả trứng", "ức gà 200g cơm 150g"). "với"/"with"/"kèm"
//    join a dish ("pasta with cream sauce", "bánh mì với trứng") unless its
//    parts match the table clearly better ("cơm với trứng": rice, an egg).
//  - Amounts: digits ("2", "2.5", "2,5", "1/2", "½", "x2", "2x") or words
//    (một … mười hai, hai mươi, trăm, nửa, rưỡi, vài, chục; a/an, one …
//    twelve, half, a quarter, a couple, a dozen), then a unit: counted (quả,
//    cái, lon, ổ, slice, can…), by amount (tô, bát, ly, muỗng, bowl, cup,
//    tbsp…) or a weight (g, kg, ml, l, lạng, oz, lb; ml counts as grams).
//  - Food words match the table by whole words, the diacritics counting when
//    they were typed ("cá" isn't "cà", "nấm" isn't "năm"): the whole name
//    first, then the words together at the name's head ("phở bò" in "Phở bò
//    tái"), together elsewhere, in order, in any order. A unit that fits an
//    entry ("1 lon bia" is a can, "1 chai bia" a bottle), a plain name
//    ("egg" is boiled, "milk" whole) and the tie-breaks of FoodTable.search
//    decide between equals. A food is matched only when it clearly is that
//    food; words the table doesn't have ("không đường", "nhiều hành") are
//    left out only when the rest is a name it has, and the food says so
//    (`isPartialMatch`).
//  - Grams: explicit grams win; a counted entry takes the count (one when
//    none is said), a serving entry its servings, a spoon a spoon's grams,
//    a drink a cup's, can's or bottle's; always 1 g to 3 kg.
//
//  FoodTable.search takes about 3 ms a query, too slow for the many word
//  groupings a phrase needs, so the parser keeps its own word index of the
//  table, built on first use (`prepare()` builds it ahead).
//

import Foundation

// MARK: - A food read

/// One food read from a typed or spoken meal.
nonisolated struct ParsedFood: Equatable, Sendable {
    /// This food's words as typed or heard: "một tô phở bò tái".
    var phrase: String
    /// The food words without quantity and unit: "phở bò tái".
    var name: String
    /// How many: 2 in "2 quả trứng", 0.5 in "nửa bát cơm", 1.5 in "một bát
    /// rưỡi"; nil when the phrase says none.
    var quantity: Double?
    /// The unit, container or weight word as typed: "quả", "bát", "bowl", "g".
    var unitWord: String?
    /// An explicit weight or volume in grams (ml as grams): "200g cơm", "150
    /// gram ức gà", "330 ml", "1 kg".
    var grams: Double?
    /// Explicit energy: "phở 450 kcal". The caller logs such a food by hand,
    /// with these numbers, even when it has a match.
    var kcal: Int?
    /// The table entry the words name; nil when none clearly fits.
    var match: FoodEntry?
    /// Up to 5 next-best entries, for "change food".
    var alternatives: [FoodEntry]
    /// The grams of `match` the phrase comes to (1-3,000); nil without one.
    var amountGrams: Double?
    /// How many pieces, when `match` is counted (unit "piece").
    var count: Double?
    /// Grams of protein, fat and carbs said with the energy: "phở 450 kcal 20
    /// g protein".
    var proteinG: Double? = nil
    var fatG: Double? = nil
    var carbsG: Double? = nil
    /// The match names only some of the food words: "trà sữa" of "trà sữa
    /// không đường".
    var isPartialMatch = false
    /// `amountGrams` is one serving because what the pieces said come to
    /// isn't known ("3 múi bưởi", "10 con ốc"): worth a check.
    var amountIsGuess = false
}

// MARK: - Parser

nonisolated enum FoodPhraseParser {
    /// The longest phrase read; the rest is left out.
    static let maxCharacters = 600
    /// The most foods one phrase gives.
    static let maxFoods = 30
    /// The grams one food comes to, at least and at most.
    static let gramsRange: ClosedRange<Double> = 1...3_000
    /// The table's plain water: drunk, not eaten (the quick log logs it as
    /// water).
    static let waterID = "water"

    /// The foods in a typed or spoken phrase, in the order said. `language`
    /// is the app's ("vi" or "en"): only a hint for ranking, both languages
    /// are read whatever it is. Deterministic, on the device, safe off the
    /// main thread. `table`: another table (tests, previews) gets its own
    /// index each call.
    static func parse(_ text: String, language: String, table: FoodTable = .shared) -> [ParsedFood] {
        let text = PhraseLexer.plainDigits(String(text.prefix(maxCharacters)))
        var tokens = PhraseLexer.tokens(of: text)
        guard tokens.contains(where: { $0.kind == .word }) else { return [] }
        // Typed with diacritics: a word without any is meant so ("sau" is
        // "after", not "sáu"; "qua" isn't "quả"; "Nam" a name, not "năm").
        if tokens.contains(where: { $0.marked != nil }) {
            for i in tokens.indices where tokens[i].kind == .word && tokens[i].marked == nil { tokens[i].bareOnly = true }
        }
        let index = table === FoodTable.shared ? PhraseIndex.shared : PhraseIndex(table: table)
        let reader = PhraseReader(text: text, tokens: tokens, index: index, language: language == "vi" ? "vi" : "en")
        return Array(reader.foods().prefix(maxFoods))
    }

    /// Reads the table and builds the word index ahead of the first parse,
    /// off the main thread when called from a background task.
    static func prepare() {
        _ = PhraseIndex.shared
    }
}

// MARK: - Tokens

private nonisolated struct PhraseToken {
    enum Kind { case word, number, hard, and }

    var kind: Kind
    var range: Range<String.Index>
    var text: Substring
    /// Lowercase, no diacritics, "đ" as "d" (`FoodTable.fold`); a number's
    /// digits as typed.
    var folded = ""
    /// Lowercase with its diacritics, the tone last; nil without any.
    var marked: String?
    /// A number's value; nil for one too long to read.
    var value: Double?
    /// A number in plain digits ("3"), not "2.5", "1/2" or "½".
    var isPlainDigits = false
    /// A time or a date, never an amount: "12:30", "20/11", "15/10/2026".
    var isTime = false
    /// A price after a currency sign: "$5".
    var isPrice = false
    /// A word without diacritics in a phrase typed with them: it is only a
    /// word written without any ("sau", "qua"), never one that has them
    /// ("sáu", "quả").
    var bareOnly = false
}

private nonisolated enum PhraseLexer {
    /// Ends a food: , ; . ! ? : and line breaks, "+", "/" and "|" (a comma or
    /// a point between digits is part of the number).
    static let hard: Set<Character> = [",", ";", ".", "!", "?", ":", "\n", "\r", "\r\n", "|", "+", "/", "\\", "•", "·", "…"]
    static let glyphs: [Character: Double] = [
        "½": 0.5, "¼": 0.25, "¾": 0.75, "⅓": 1.0 / 3, "⅔": 2.0 / 3, "⅛": 0.125, "⅜": 0.375, "⅝": 0.625, "⅞": 0.875,
    ]

    static func isDigit(_ c: Character) -> Bool { ("0"..."9").contains(c) }

    /// Signs a price follows: "$5".
    static let currencySigns: Set<Character> = ["$", "€", "£", "₫", "¥"]
    static let apostrophes: Set<Character> = ["'", "’", "ʼ"]

    /// Digits of any script and full-width letters as plain ones: "２ quả
    /// trứng", "٣", "ＰＨỞ".
    static func plainDigits(_ text: String) -> String {
        guard text.unicodeScalars.contains(where: { !$0.isASCII }) else { return text }
        var scalars = String.UnicodeScalarView()
        for scalar in text.unicodeScalars {
            if (0xFF01...0xFF5E).contains(scalar.value), let ascii = Unicode.Scalar(scalar.value - 0xFEE0) {
                scalars.append(ascii)
            } else if !scalar.isASCII, scalar.properties.numericType == .decimal,
                      let value = scalar.properties.numericValue, value >= 0, value <= 9,
                      let ascii = Unicode.Scalar(48 + UInt32(value)) {
                scalars.append(ascii)
            } else {
                scalars.append(scalar)
            }
        }
        return String(scalars)
    }

    static func tokens(of text: String) -> [PhraseToken] {
        var tokens: [PhraseToken] = []
        /// Numbers right before "." or ")" and a space: "1. phở 2. trà đá".
        var listNumbers: [Int] = []
        var i = text.startIndex
        while i < text.endIndex {
            let c = text[i]
            if isDigit(c) || glyphs[c] != nil {
                var (token, next) = number(in: text, from: i)
                if i > text.startIndex, currencySigns.contains(text[text.index(before: i)]) { token.isPrice = true }
                if token.isPlainDigits, token.text.count <= 2, next < text.endIndex, text[next] == "." || text[next] == ")" {
                    let after = text.index(after: next)
                    if after == text.endIndex || text[after].isWhitespace { listNumbers.append(tokens.count) }
                }
                tokens.append(token)
                i = next
            } else if c.isLetter {
                // A word, an apostrophe inside it kept ("didn't", "McDonald's").
                var j = text.index(after: i)
                while j < text.endIndex {
                    if text[j].isLetter {
                        j = text.index(after: j)
                    } else if apostrophes.contains(text[j]), text.index(after: j) < text.endIndex, text[text.index(after: j)].isLetter {
                        j = text.index(after: j)
                    } else {
                        break
                    }
                }
                tokens.append(word(text[i..<j], range: i..<j))
                i = j
            } else {
                let next = text.index(after: i)
                if hard.contains(c) {
                    tokens.append(PhraseToken(kind: .hard, range: i..<next, text: text[i..<next]))
                } else if c == "&" {
                    tokens.append(PhraseToken(kind: .and, range: i..<next, text: text[i..<next], folded: "&"))
                } else if c == "×" || c == "*" {
                    tokens.append(PhraseToken(kind: .word, range: i..<next, text: text[i..<next], folded: "x"))
                }
                i = next
            }
        }
        // A numbered list's numbers (1, 2, 3… in order) end a food, never
        // count one.
        let values = listNumbers.map { tokens[$0].value ?? 0 }
        if values.count >= 2, values == (1...values.count).map(Double.init) {
            for n in listNumbers { tokens[n].kind = .hard }
        }
        return tokens
    }

    static func word(_ text: Substring, range: Range<String.Index>) -> PhraseToken {
        var lower = text.lowercased()
        if lower.contains(where: apostrophes.contains) { lower.removeAll(where: apostrophes.contains) }
        lower = PhraseLexicon.spellings[lower] ?? lower
        return PhraseToken(kind: .word, range: range, text: text, folded: FoodTable.fold(lower), marked: PhraseMarks.marked(lower))
    }

    /// "2", "2.5", "2,5", "1.000" (a thousand), "1/2", "½", "1½"; more than
    /// seven digits reads as no number.
    private static func number(in text: String, from start: String.Index) -> (PhraseToken, String.Index) {
        var i = start
        var digits = ""
        while i < text.endIndex, isDigit(text[i]) {
            digits.append(text[i])
            i = text.index(after: i)
        }
        guard !digits.isEmpty else {
            let next = text.index(after: i)
            let token = PhraseToken(kind: .number, range: start..<next, text: text[start..<next],
                                    folded: String(text[start..<next]), value: glyphs[text[i]])
            return (token, next)
        }
        var value: Double? = digits.count <= 7 ? Double(digits) : nil
        var plain = true
        // "12:30": a time, no amount.
        if digits.count <= 2, i < text.endIndex, text[i] == ":" {
            var j = text.index(after: i)
            var minutes = ""
            while j < text.endIndex, isDigit(text[j]) {
                minutes.append(text[j])
                j = text.index(after: j)
            }
            if minutes.count == 2 {
                return (PhraseToken(kind: .number, range: start..<j, text: text[start..<j], folded: String(text[start..<j]),
                                    isTime: true), j)
            }
        }
        if i < text.endIndex, text[i] == "." || text[i] == "," {
            var j = text.index(after: i)
            var fraction = ""
            while j < text.endIndex, isDigit(text[j]) {
                fraction.append(text[j])
                j = text.index(after: j)
            }
            if !fraction.isEmpty {
                plain = false
                if fraction.count == 3, digits.count <= 3, digits.first != "0" {
                    // 1.000 / 1,000: thousands, as QuickLogParser reads them.
                    value = Double(digits + fraction)
                } else if digits.count <= 7 {
                    value = Double(digits + "." + fraction.prefix(6))
                }
                i = j
            }
        } else if i < text.endIndex, text[i] == "/" {
            var j = text.index(after: i)
            var bottom = ""
            while j < text.endIndex, isDigit(text[j]) {
                bottom.append(text[j])
                j = text.index(after: j)
            }
            if let top = value, digits.count <= 2, bottom.count <= 2, let under = Double(bottom) {
                if top >= 1, top < under, under <= 8 {
                    // A fraction: "1/2", "3/4", "2/3".
                    value = top / under
                    plain = false
                    i = j
                } else if (1...31).contains(top), (1...12).contains(under) {
                    // A date, never an amount: "20/11", "1/12", "15/10/2026".
                    var end = j
                    if end < text.endIndex, text[end] == "/" {
                        var k = text.index(after: end)
                        var year = ""
                        while k < text.endIndex, isDigit(text[k]) {
                            year.append(text[k])
                            k = text.index(after: k)
                        }
                        if year.count == 2 || year.count == 4 { end = k }
                    }
                    return (PhraseToken(kind: .number, range: start..<end, text: text[start..<end], folded: String(text[start..<end]),
                                        isTime: true), end)
                }
            }
        }
        if i < text.endIndex, let glyph = glyphs[text[i]] {
            value = value.map { $0 + glyph }
            plain = false
            i = text.index(after: i)
        }
        let token = PhraseToken(kind: .number, range: start..<i, text: text[start..<i], folded: String(text[start..<i]),
                                value: value, isPlainDigits: plain)
        return (token, i)
    }
}

/// A word's diacritics, compared so that only the same marks match: "phở"
/// isn't "phô", "cá" isn't "cà". The tone goes last, so "hoà" and "hòa" are
/// one spelling.
private nonisolated enum PhraseMarks {
    static func marked(_ lower: String) -> String? {
        var tone: Unicode.Scalar?
        var hasMarks = false
        var scalars = String.UnicodeScalarView()
        for scalar in lower.decomposedStringWithCanonicalMapping.unicodeScalars {
            switch scalar.value {
            case 0x0300, 0x0301, 0x0303, 0x0309, 0x0323:
                tone = scalar
                hasMarks = true
            case 0x0111, 0x0300...0x036F:
                hasMarks = true
                scalars.append(scalar)
            default:
                scalars.append(scalar)
            }
        }
        guard hasMarks else { return nil }
        if let tone { scalars.append(tone) }
        return String(scalars)
    }
}

// MARK: - Words the parser knows

/// Phrases of one or more words, each compared the way a typed word is: one
/// typed with diacritics only to a Vietnamese word with the same ones, one
/// typed without any by its letters ("nam" can be "năm" or "nắm").
private nonisolated struct PhraseList<Value: Sendable>: Sendable {
    private struct Item: Sendable {
        var folded: [String]
        /// Vietnamese words' marked spelling (their letters when they have
        /// none); nil for English phrases.
        var marked: [String]?
        /// Typed words must have the diacritics too.
        var marksOnly: Bool
        var value: Value

        func accepts(_ token: PhraseToken, at w: Int) -> Bool {
            guard token.kind == .word, token.folded == folded[w] else { return false }
            if let marked = token.marked { return self.marked?[w] == marked }
            // Typed without diacritics: an English word, or a Vietnamese one
            // written without any; one that has them only when the phrase
            // has none at all ("sau" is "sáu" in "sau qua trung", not in
            // "sau đó").
            if let marks = self.marked, marks[w] != folded[w] { return !marksOnly && !token.bareOnly }
            return true
        }
    }

    private let byFirst: [String: [Item]]

    /// `viMarked`: Vietnamese phrases only read as typed with their
    /// diacritics, where the bare letters are another word ("kèm" but not
    /// "kem", ice cream; "rồi" but not "roi", a fruit).
    init(vi: [(String, Value)] = [], viMarked: [(String, Value)] = [], en: [(String, Value)] = []) {
        var byFirst: [String: [Item]] = [:]
        func add(_ phrase: String, _ value: Value, vietnamese: Bool, marksOnly: Bool = false) {
            let words = phrase.lowercased().split(separator: " ").map(String.init)
            let folded = words.map { FoodTable.fold($0) }
            let marked = vietnamese ? words.map { PhraseMarks.marked($0) ?? FoodTable.fold($0) } : nil
            byFirst[folded[0], default: []].append(Item(folded: folded, marked: marked, marksOnly: marksOnly, value: value))
        }
        // English first, so among equals "can" is a can, not "cân" (a kilo).
        for (phrase, value) in en { add(phrase, value, vietnamese: false) }
        for (phrase, value) in vi { add(phrase, value, vietnamese: true) }
        for (phrase, value) in viMarked { add(phrase, value, vietnamese: true, marksOnly: true) }
        // Longest first; equals keep their order.
        self.byFirst = byFirst.mapValues { items in
            items.enumerated().sorted { a, b in
                a.element.folded.count != b.element.folded.count ? a.element.folded.count > b.element.folded.count : a.offset < b.offset
            }.map(\.element)
        }
    }

    /// The longest phrase starting at word `k` of `seg`, and its length.
    func match(_ tokens: [PhraseToken], _ seg: [Int], _ k: Int) -> (value: Value, length: Int)? {
        guard k < seg.count, tokens[seg[k]].kind == .word, let items = byFirst[tokens[seg[k]].folded] else { return nil }
        for item in items where k + item.folded.count <= seg.count {
            if item.folded.indices.allSatisfy({ item.accepts(tokens[seg[k + $0]], at: $0) }) {
                return (item.value, item.folded.count)
            }
        }
        return nil
    }

    /// One word alone.
    func value(of token: PhraseToken) -> Value? {
        guard token.kind == .word else { return nil }
        for item in byFirst[token.folded] ?? [] where item.folded.count == 1 && item.accepts(token, at: 0) {
            return item.value
        }
        return nil
    }
}

/// The families a unit or a size word belongs to: "bát" and "tô" are bowls,
/// "ly" and "cup" glasses. A unit fits an entry whose size word shares one.
private nonisolated enum UnitFamily {
    static let names = [
        "bowl", "plate", "serving", "glass", "handful", "tbsp", "tsp", "spoon", "pot", "pan", "basket",
        "fruit", "piece", "slice", "roll", "skewer", "stick", "can", "bottle", "box", "pack", "bar", "ball", "loaf",
        "tuber", "ear", "whole", "chunk", "jar", "shaker", "segment", "pair", "bunch", "block", "scoop", "shot",
        "fillet", "wedge",
    ]

    static func bit(_ name: String) -> UInt64 {
        guard let index = names.firstIndex(of: name) else { return 0 }
        return 1 << UInt64(index)
    }

    static let glass = bit("glass")
    static let spoons = bit("tbsp") | bit("tsp") | bit("spoon")
    /// Containers with a size of their own: "2 chai bia 450ml", "2 hộp sữa
    /// 180ml", "3 gói mì 75g".
    static let containers = bit("can") | bit("bottle") | bit("glass") | bit("shaker") | bit("box") | bit("pack") | bit("jar")
    /// Size words of one piece: a food served as one ("Chicken breast" by
    /// the piece) is counted, whatever its unit.
    static let pieces = ["fruit", "piece", "slice", "roll", "skewer", "stick", "can", "bottle", "box", "pack", "bar",
                         "ball", "loaf", "tuber", "ear", "whole", "chunk", "jar", "shaker", "segment", "block", "scoop",
                         "shot", "fillet", "wedge"].reduce(UInt64(0)) { $0 | bit($1) }
}

private nonisolated struct PhraseUnit: Sendable {
    enum Kind: Sendable { case counted, amount, weight }

    var kind: Kind
    var families: UInt64 = 0
    /// A weight's grams, or a spoon's (15 for a tablespoon).
    var grams: Double?

    static func counted(_ family: String) -> PhraseUnit { PhraseUnit(kind: .counted, families: UnitFamily.bit(family)) }
    static func amount(_ family: String) -> PhraseUnit { PhraseUnit(kind: .amount, families: UnitFamily.bit(family)) }
    static func spoon(_ family: String, _ grams: Double) -> PhraseUnit { PhraseUnit(kind: .amount, families: UnitFamily.bit(family), grams: grams) }
    static func weight(_ grams: Double) -> PhraseUnit { PhraseUnit(kind: .weight, grams: grams) }
}

private nonisolated enum PhraseMacro: Sendable { case protein, fat, carbs }

private nonisolated enum PhraseJoin: Sendable { case and, with }

/// How a negation leaves a food out: before a verb ("không ăn cơm"), alone
/// ("skipped lunch"), or before a meal ("no breakfast").
private nonisolated enum PhraseNegation: Sendable { case verb, alone, meal }

/// A Vietnamese number word.
private nonisolated enum VietnameseNumber: Sendable {
    case digit(Double)
    /// "lăm" (5), "mốt" (1): only after "mười"/"mươi".
    case after(Double)
    case ten, tens, hundred, thousand, zero, half, halfWord, few, dozen
}

private nonisolated enum PhraseLexicon {
    static let units = PhraseList<PhraseUnit>(
        vi: [
            ("tô", .amount("bowl")), ("bát", .amount("bowl")), ("chén", .amount("bowl")), ("thố", .amount("bowl")),
            ("đĩa", .amount("plate")), ("dĩa", .amount("plate")),
            ("phần", .amount("serving")), ("suất", .amount("serving")), ("xuất", .amount("serving")),
            ("ly", .amount("glass")), ("cốc", .amount("glass")), ("tách", .amount("glass")),
            ("nắm", .amount("handful")), ("niêu", .amount("pot")), ("nồi", .amount("pot")), ("chảo", .amount("pan")),
            ("giỏ", .amount("basket")),
            ("muỗng canh", .spoon("tbsp", 15)), ("thìa canh", .spoon("tbsp", 15)), ("muỗng to", .spoon("tbsp", 15)),
            ("thìa to", .spoon("tbsp", 15)), ("muỗng lớn", .spoon("tbsp", 15)), ("thìa lớn", .spoon("tbsp", 15)),
            ("muỗng cà phê", .spoon("tsp", 5)), ("thìa cà phê", .spoon("tsp", 5)), ("muỗng cafe", .spoon("tsp", 5)),
            ("thìa cafe", .spoon("tsp", 5)), ("muỗng nhỏ", .spoon("tsp", 5)), ("thìa nhỏ", .spoon("tsp", 5)),
            ("muỗng", .spoon("spoon", 15)), ("thìa", .spoon("spoon", 15)),
            ("quả", .counted("fruit")), ("trái", .counted("fruit")), ("cái", .counted("piece")), ("chiếc", .counted("piece")),
            ("miếng", .counted("piece")), ("lát", .counted("slice")), ("khoanh", .counted("slice")), ("cuốn", .counted("roll")),
            ("xiên", .counted("skewer")), ("que", .counted("stick")), ("cây", .counted("stick")), ("lon", .counted("can")),
            ("chai", .counted("bottle")), ("hộp", .counted("box")), ("gói", .counted("pack")), ("bịch", .counted("pack")),
            ("túi", .counted("pack")), ("thanh", .counted("bar")), ("viên", .counted("ball")), ("vắt", .counted("ball")),
            ("ổ", .counted("loaf")), ("củ", .counted("tuber")), ("bắp", .counted("ear")), ("con", .counted("whole")),
            ("khúc", .counted("chunk")), ("hũ", .counted("jar")), ("bình", .counted("shaker")), ("bình lắc", .counted("shaker")),
            ("múi", .counted("segment")), ("cặp", .counted("pair")), ("chùm", .counted("bunch")),
            ("gam", .weight(1)), ("gờ ram", .weight(1)), ("ký", .weight(1_000)), ("kí", .weight(1_000)),
            ("ki lô", .weight(1_000)), ("ki lô gam", .weight(1_000)), ("kilô", .weight(1_000)), ("kilôgam", .weight(1_000)),
            ("cân", .weight(1_000)), ("lạng", .weight(100)), ("lít", .weight(1_000)), ("mililít", .weight(1)),
            ("mi li lít", .weight(1)),
        ],
        // "bia" is beer.
        viMarked: [("bìa", .counted("block"))],
        en: [
            ("bowl", .amount("bowl")), ("bowls", .amount("bowl")), ("plate", .amount("plate")), ("plates", .amount("plate")),
            ("plateful", .amount("plate")), ("serving", .amount("serving")), ("servings", .amount("serving")),
            ("portion", .amount("serving")), ("portions", .amount("serving")), ("helping", .amount("serving")),
            ("helpings", .amount("serving")), ("order", .amount("serving")), ("orders", .amount("serving")),
            ("cup", .amount("glass")), ("cups", .amount("glass")), ("glass", .amount("glass")), ("glasses", .amount("glass")),
            ("mug", .amount("glass")), ("mugs", .amount("glass")), ("handful", .amount("handful")), ("handfuls", .amount("handful")),
            ("tablespoon", .spoon("tbsp", 15)), ("tablespoons", .spoon("tbsp", 15)), ("tbsp", .spoon("tbsp", 15)),
            ("tbsps", .spoon("tbsp", 15)), ("tbs", .spoon("tbsp", 15)), ("teaspoon", .spoon("tsp", 5)),
            ("teaspoons", .spoon("tsp", 5)), ("tsp", .spoon("tsp", 5)), ("tsps", .spoon("tsp", 5)),
            ("spoon", .spoon("spoon", 15)), ("spoons", .spoon("spoon", 15)), ("spoonful", .spoon("spoon", 15)),
            ("spoonfuls", .spoon("spoon", 15)),
            ("piece", .counted("piece")), ("pieces", .counted("piece")), ("pc", .counted("piece")), ("pcs", .counted("piece")),
            ("slice", .counted("slice")), ("slices", .counted("slice")), ("roll", .counted("roll")), ("rolls", .counted("roll")),
            ("skewer", .counted("skewer")), ("skewers", .counted("skewer")), ("stick", .counted("stick")),
            ("sticks", .counted("stick")), ("can", .counted("can")), ("cans", .counted("can")), ("tin", .counted("can")),
            ("tins", .counted("can")), ("bottle", .counted("bottle")), ("bottles", .counted("bottle")), ("box", .counted("box")),
            ("boxes", .counted("box")), ("carton", .counted("box")), ("cartons", .counted("box")), ("pack", .counted("pack")),
            ("packs", .counted("pack")), ("packet", .counted("pack")), ("packets", .counted("pack")), ("sachet", .counted("pack")),
            ("sachets", .counted("pack")), ("bag", .counted("pack")), ("bags", .counted("pack")), ("bar", .counted("bar")),
            ("bars", .counted("bar")), ("scoop", .counted("scoop")), ("scoops", .counted("scoop")), ("jar", .counted("jar")),
            ("jars", .counted("jar")), ("tub", .counted("jar")), ("tubs", .counted("jar")), ("shot", .counted("shot")),
            ("shots", .counted("shot")), ("ear", .counted("ear")), ("ears", .counted("ear")), ("fillet", .counted("fillet")),
            ("fillets", .counted("fillet")), ("loaf", .counted("loaf")), ("loaves", .counted("loaf")), ("wedge", .counted("wedge")),
            ("wedges", .counted("wedge")), ("block", .counted("block")), ("blocks", .counted("block")),
            ("g", .weight(1)), ("gr", .weight(1)), ("grs", .weight(1)), ("gm", .weight(1)), ("gram", .weight(1)),
            ("grams", .weight(1)), ("gramme", .weight(1)), ("grammes", .weight(1)), ("kg", .weight(1_000)),
            ("kgs", .weight(1_000)), ("kilo", .weight(1_000)), ("kilos", .weight(1_000)), ("kilogram", .weight(1_000)),
            ("kilograms", .weight(1_000)), ("ml", .weight(1)), ("mls", .weight(1)), ("milliliter", .weight(1)),
            ("milliliters", .weight(1)), ("millilitre", .weight(1)), ("millilitres", .weight(1)), ("mililit", .weight(1)),
            ("cc", .weight(1)), ("l", .weight(1_000)), ("lit", .weight(1_000)), ("liter", .weight(1_000)),
            ("liters", .weight(1_000)), ("litre", .weight(1_000)), ("litres", .weight(1_000)), ("oz", .weight(28.35)),
            ("ounce", .weight(28.35)), ("ounces", .weight(28.35)), ("lb", .weight(453.6)), ("lbs", .weight(453.6)),
            ("pound", .weight(453.6)), ("pounds", .weight(453.6)), ("pint", .weight(473)), ("pints", .weight(473)),
        ])

    static let viNumbers = PhraseList<VietnameseNumber>(vi: [
        ("một", .digit(1)), ("hai", .digit(2)), ("ba", .digit(3)), ("bốn", .digit(4)), ("tư", .digit(4)),
        ("năm", .digit(5)), ("sáu", .digit(6)), ("bảy", .digit(7)), ("bẩy", .digit(7)), ("tám", .digit(8)),
        ("chín", .digit(9)), ("lăm", .after(5)), ("nhăm", .after(5)), ("mốt", .after(1)), ("mười", .ten), ("mươi", .tens),
        ("trăm", .hundred), ("nghìn", .thousand), ("ngàn", .thousand), ("linh", .zero), ("lẻ", .zero),
        ("rưỡi", .half), ("nửa", .halfWord), ("vài", .few), ("chục", .dozen),
    ])

    static let enNumbers: [String: Double] = [
        "one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9, "ten": 10,
        "eleven": 11, "twelve": 12, "thirteen": 13, "fourteen": 14, "fifteen": 15, "sixteen": 16, "seventeen": 17,
        "eighteen": 18, "nineteen": 19, "twenty": 20, "thirty": 30, "forty": 40, "fifty": 50, "sixty": 60,
        "seventy": 70, "eighty": 80, "ninety": 90,
    ]

    /// Words that multiply a number before them: "2 trăm", "5 chục", "2 dozen".
    static let multipliers = PhraseList<Double>(
        vi: [("trăm", 100), ("nghìn", 1_000), ("ngàn", 1_000), ("chục", 10)],
        en: [("hundred", 100), ("thousand", 1_000), ("dozen", 12)])

    static let kcal = PhraseList<Bool>(
        vi: [("calo", true), ("ca lo", true), ("ca lô", true), ("kalo", true), ("kcalo", true)],
        en: [("kcal", true), ("kcals", true), ("cal", true), ("cals", true), ("calorie", true), ("calories", true),
             ("kilocalorie", true), ("kilocalories", true), ("k cal", true)])

    static let macros = PhraseList<PhraseMacro>(
        vi: [("đạm", .protein), ("chất đạm", .protein), ("béo", .fat), ("chất béo", .fat), ("tinh bột", .carbs),
             ("chất bột đường", .carbs), ("bột đường", .carbs)],
        en: [("protein", .protein), ("proteins", .protein), ("fat", .fat), ("fats", .fat), ("carb", .carbs),
             ("carbs", .carbs), ("carbohydrate", .carbs), ("carbohydrates", .carbs)])

    static let joiners = PhraseList<PhraseJoin>(
        vi: [("và", .and), ("cộng", .and), ("thêm", .and), ("hoặc", .and), ("sau đó", .and), ("với lại", .and),
             ("với", .with)],
        viMarked: [("rồi", .and), ("kèm", .with), ("ăn kèm", .with), ("kèm theo", .with)],
        en: [("and", .and), ("plus", .and), ("or", .and), ("then", .and), ("and then", .and), ("after that", .and),
             ("with", .with), ("alongside", .with), ("on", .with), ("over", .with)])

    /// Eating and drinking: mid-phrase, the start of another food ("phở rồi
    /// uống trà đá"), unless a name has them ("mì ăn liền").
    static let verbs = PhraseList<Bool>(
        vi: [("ăn", true), ("uống", true), ("nhậu", true)],
        en: [("ate", true), ("eat", true), ("had", true), ("drank", true), ("drink", true), ("eaten", true)])

    /// What wasn't eaten: "không ăn cơm", "chưa ăn gì", "I didn't eat rice",
    /// "skipped lunch", "no breakfast". "không" inside a name ("bánh mì
    /// không", "trà không đường") has no verb after it.
    static let negations = PhraseList<PhraseNegation>(
        vi: [("không", .verb), ("không có", .verb), ("chưa", .verb), ("chưa có", .verb), ("chẳng", .verb),
             ("chẳng có", .verb), ("chả", .verb), ("đâu có", .verb), ("ko", .verb), ("hông", .verb)],
        en: [("didnt", .verb), ("did not", .verb), ("dont", .verb), ("do not", .verb), ("never", .verb),
             ("havent", .verb), ("have not", .verb), ("hasnt", .verb), ("not", .verb), ("skipped", .alone),
             ("skip", .alone), ("skipping", .alone), ("no", .meal)])

    /// The verbs a negation takes: "không ăn", "didn't have".
    static let negatedVerbs = PhraseList<Bool>(
        vi: [("ăn", true), ("uống", true), ("nhậu", true), ("dùng", true)],
        en: [("eat", true), ("ate", true), ("eaten", true), ("eating", true), ("have", true), ("had", true),
             ("drink", true), ("drank", true), ("drinking", true), ("even", true), ("really", true)])

    /// The meals "no" and "skipped" leave out.
    static let meals = PhraseList<Bool>(
        en: [("breakfast", true), ("lunch", true), ("dinner", true), ("brunch", true), ("supper", true),
             ("snack", true), ("snacks", true), ("meal", true), ("meals", true)])

    /// Where what wasn't eaten ends: "không ăn cơm mà ăn bún bò".
    static let contrasts = PhraseList<Bool>(
        vi: [("mà", true), ("nhưng", true), ("chỉ", true)],
        en: [("but", true), ("instead", true), ("only", true)])

    /// Words that start a food's words only as fillers: "sau đó" between
    /// foods joins them, at the start it's just "then".
    static let leadJoiners = PhraseList<Bool>(
        vi: [("sau đó", true), ("rồi sau đó", true), ("xong rồi", true)],
        en: [("after that", true), ("and then", true)])

    /// Words a name may not have that only change it ("phở không hành",
    /// "trà sữa ít đường", "coffee no sugar"): a part of the words before
    /// them is enough of a match.
    static let modifiers = PhraseList<Bool>(
        vi: [("không", true), ("ít", true), ("nhiều", true), ("thêm", true), ("bớt", true), ("ko", true)],
        en: [("no", true), ("without", true), ("extra", true), ("less", true)])

    /// After these, a number is a date: "thứ 2", "ngày 5", "tháng 11".
    static let dateWords = PhraseList<Bool>(
        vi: [("ngày", true), ("thứ", true), ("tháng", true), ("mùng", true), ("mồng", true)])

    /// After a number said at a time ("at seven pm"), the part of the day.
    static let dayParts = PhraseList<Bool>(
        vi: [("sáng", true), ("trưa", true), ("chiều", true), ("tối", true), ("đêm", true)],
        en: [("am", true), ("pm", true), ("morning", true), ("evening", true), ("tonight", true)])

    /// After a number, money: "30k", "25 nghìn đồng", "40.000đ", "3 dollars".
    static let currencies = PhraseList<Bool>(
        vi: [("đồng", true), ("đ", true), ("vnđ", true)],
        en: [("k", true), ("vnd", true), ("usd", true), ("dollar", true), ("dollars", true), ("buck", true),
             ("bucks", true), ("cent", true), ("cents", true), ("euro", true), ("euros", true), ("baht", true)])

    /// Spellings read as the table writes them: "mỳ" is "mì".
    static let spellings: [String: String] = ["mỳ": "mì"]

    /// Words around the food that aren't it: who ate, when, about how much.
    /// Left out of a name only when the food matches better without them
    /// ("bữa sáng kiểu Anh" keeps its "bữa sáng").
    static let fillers = PhraseList<Bool>(
        vi: [
            ("tôi", true), ("mình", true), ("em", true), ("anh", true), ("chị", true), ("tớ", true), ("tao", true),
            ("bọn", true), ("chúng", true), ("đã", true), ("vừa", true), ("mới", true), ("có", true), ("cũng", true),
            ("lại", true), ("thì", true), ("là", true), ("được", true), ("ăn", true), ("uống", true), ("nhậu", true),
            ("sáng", true), ("trưa", true), ("chiều", true), ("tối", true), ("đêm", true), ("khuya", true), ("nay", true),
            ("qua", true), ("hôm", true), ("bữa", true), ("lúc", true), ("giờ", true), ("khoảng", true), ("tầm", true),
            ("chừng", true), ("cỡ", true), ("độ", true), ("chắc", true), ("ít", true), ("chút", true), ("nữa", true),
            ("thôi", true), ("nhé", true), ("nha", true), ("nhá", true), ("ạ", true), ("à", true), ("ha", true),
            ("đó", true), ("rồi", true), ("xong", true), ("luôn", true), ("thêm", true), ("hết", true), ("một ít", true),
            ("ờ", true), ("ừ", true), ("ừm", true), ("ơi", true), ("mà", true), ("nhỉ", true), ("món", true),
            ("trong", true),
            ("một chút", true), ("một xíu", true), ("xíu", true),
            // When: "hôm qua", "sau bữa trưa", "chủ nhật".
            ("hôm qua", true), ("tối qua", true), ("đêm qua", true), ("trưa qua", true), ("sáng qua", true),
            ("chiều qua", true), ("hôm kia", true), ("sau khi", true), ("sau bữa", true), ("chủ nhật", true),
            ("cuối tuần", true), ("nhưng", true), ("tập", true), ("gym", true), ("sau", true),
            // Sizes: "size L", "cỡ lớn".
            ("size s", true), ("size m", true), ("size l", true), ("size xl", true), ("size xxl", true),
            ("size nhỏ", true), ("size vừa", true), ("size lớn", true), ("cỡ nhỏ", true), ("cỡ vừa", true),
            ("cỡ lớn", true), ("size", true),
        ],
        // Only as typed with their diacritics: "nhỏ" is small, "nho" grapes;
        // "lớn" large, "lon" a can; "đến" to, "đen" black.
        viMarked: [
            ("trước", true), ("đến", true), ("tới", true), ("gì", true), ("ở", true), ("ở nhà", true), ("đi", true),
            ("còn", true), ("ngày", true), ("tháng", true), ("thứ", true), ("lớn", true), ("nhỏ", true), ("bự", true),
            ("chỉ", true),
        ],
        en: [
            ("i", true), ("we", true), ("ate", true), ("eat", true), ("eating", true), ("eaten", true), ("had", true),
            ("have", true), ("has", true), ("having", true), ("drank", true), ("drink", true), ("drinking", true),
            ("just", true), ("also", true), ("then", true), ("for", true), ("at", true), ("today", true), ("tonight", true),
            ("yesterday", true), ("this", true), ("morning", true), ("afternoon", true), ("evening", true), ("night", true),
            ("breakfast", true), ("lunch", true), ("dinner", true), ("supper", true), ("brunch", true), ("about", true),
            ("around", true), ("approx", true), ("approximately", true), ("roughly", true), ("some", true), ("little", true),
            ("bit", true), ("of", true), ("the", true), ("my", true), ("too", true), ("please", true), ("again", true),
            ("more", true), ("another", true), ("extra", true), ("a little", true), ("a bit", true), ("a bit of", true),
            ("um", true), ("uh", true), ("uhm", true), ("erm", true), ("hmm", true), ("like", true),
            ("so", true), ("okay", true), ("ok", true), ("well", true), ("yeah", true), ("yes", true), ("me", true),
            ("snack", true), ("snacks", true), ("meal", true), ("meals", true), ("pre", true), ("post", true),
            ("workout", true), ("gym", true), ("ago", true), ("before", true), ("after", true), ("home", true),
            ("at home", true), ("log", true), ("logged", true), ("large", true), ("small", true), ("medium", true),
            ("size", true), ("monday", true), ("tuesday", true), ("wednesday", true), ("thursday", true),
            ("friday", true), ("saturday", true), ("sunday", true), ("weekend", true), ("nothing", true),
            ("anything", true), ("only", true), ("maybe", true), ("probably", true), ("cost", true), ("costs", true),
            ("paid", true),
        ])

    /// Left out of the words compared: "of", "with", "và", "với"…, in names
    /// and in what's typed alike (the Vietnamese ones only with their
    /// diacritics: "cua" is a crab, "kem" ice cream).
    static let stopwords = PhraseList<Bool>(
        viMarked: [("với", true), ("và", true), ("kèm", true), ("của", true)],
        en: [("with", true), ("and", true), ("of", true), ("in", true), ("on", true), ("the", true), ("a", true),
             ("an", true), ("or", true)])

    /// After a number, a time of day or a duration: "7 giờ", "7h", "7 am",
    /// "2 tiếng", "30 phút".
    static let timeUnits = PhraseList<Bool>(
        vi: [("giờ", true), ("tiếng", true), ("phút", true)],
        en: [("h", true), ("am", true), ("pm", true), ("hr", true), ("hrs", true), ("hour", true), ("hours", true),
             ("min", true), ("mins", true), ("minute", true), ("minutes", true), ("oclock", true)])

    /// The hour of a time, minutes may follow: "7 giờ 30", "7h30".
    static let hourUnits = PhraseList<Bool>(vi: [("giờ", true)], en: [("h", true), ("hr", true), ("hour", true)])

    /// Before a number, a time of day: "lúc 7", "at 7".
    static let timeBefore = PhraseList<Bool>(vi: [("lúc", true), ("vào lúc", true)], en: [("at", true), ("around", true)])

    /// Everyday names the table words another way.
    static let synonyms: [String: String] = ["coca": "cola", "coke": "cola", "pepsi": "cola", "cocacola": "cola"]

    /// Words that say a food is the plain kind ("Boiled egg", "Whole milk",
    /// "Nước lọc"): among equal matches, the entry with the fewest other
    /// words besides them is the one meant by the bare name ("egg", "milk").
    static let plainWords: Set<String> = [
        "plain", "whole", "boiled", "steamed", "cooked", "regular", "unsweetened", "lean", "no", "sugar",
        "luoc", "hap", "trang", "nguyen", "thuong", "loc", "khong", "duong", "nac",
    ]
}

// MARK: - Reading a phrase

/// An amount said around a food: a quantity, a unit, grams, energy.
private nonisolated struct PhraseAmount {
    var quantity: Double?
    var unit: PhraseUnit?
    var unitTokens: [Int] = []
    var grams: Double?
    var gramsTokens: [Int] = []
    var kcal: Double?
    var macros: [PhraseMacro: Double] = [:]
    var multiplier: Double?
    var tokens: [Int] = []

    /// A quantity, a unit or grams: what says how much of a food.
    var isQuantity: Bool { quantity != nil || unit != nil || grams != nil }
    var isBareCount: Bool { quantity != nil && unit == nil && grams == nil }
}

private nonisolated enum PhraseElement {
    case words([Int])
    case amount(PhraseAmount)
    case joiner(PhraseJoin, [Int])
}

/// The words and amounts of one food, or of a part of one around "với"/"and".
private nonisolated struct PhrasePart {
    var words: [Int] = []
    var amounts: [PhraseAmount] = []
    var tokens: [Int] = []
}

private nonisolated struct PhraseReader {
    let text: String
    let tokens: [PhraseToken]
    let index: PhraseIndex
    let language: String
    /// Words already matched in this phrase: deciding whether "với"/"and"
    /// joins a dish matches the same words again.
    private let memo = Memo()
    /// Tokens of times, durations, dates and prices ("lúc 7 giờ", "7h30",
    /// "12:30", "7 am", "30 phút", "thứ 2", "20/11", "30k"): fillers, never
    /// an amount.
    private let times: Set<Int>
    /// Tokens of filler phrases ("một ít", "a little", "hôm qua", "chủ
    /// nhật", "size L", and "sau đó" where a part starts): fillers, never a
    /// number, a unit or a food.
    private let phraseFillers: Set<Int>

    init(text: String, tokens: [PhraseToken], index: PhraseIndex, language: String) {
        self.text = text
        self.tokens = tokens
        self.index = index
        self.language = language
        let times = Self.times(in: tokens)
        self.times = times
        phraseFillers = Self.phraseFillers(in: tokens, times: times)
    }

    private static func phraseFillers(in tokens: [PhraseToken], times: Set<Int>) -> Set<Int> {
        let all = Array(tokens.indices)
        var fillers = Set<Int>()
        // Nothing but fillers since the part began.
        var onlyFillers = true
        var k = 0
        while k < tokens.count {
            if tokens[k].kind == .hard {
                onlyFillers = true
                k += 1
            } else if onlyFillers, let (_, length) = PhraseLexicon.leadJoiners.match(tokens, all, k) {
                for t in k..<(k + length) { fillers.insert(t) }
                k += length
            } else if let (_, length) = PhraseLexicon.fillers.match(tokens, all, k), length > 1 {
                for t in k..<(k + length) { fillers.insert(t) }
                k += length
            } else {
                if !times.contains(k), PhraseLexicon.fillers.value(of: tokens[k]) == nil { onlyFillers = false }
                k += 1
            }
        }
        return fillers
    }

    /// Times, durations, dates and prices: "lúc 7 giờ", "7h30", "7 giờ 15",
    /// "7 giờ rưỡi", "sáu giờ", "12:30", "at 12 30", "7 am", "30 phút",
    /// "thứ 2", "ngày 5 tháng 11", "20/11", "30k", "25 nghìn đồng",
    /// "40.000đ", "$5", "3 dollars".
    private static func times(in tokens: [PhraseToken]) -> Set<Int> {
        let all = Array(tokens.indices)
        func isWord(_ i: Int, _ words: PhraseList<Bool>) -> Bool {
            i >= 0 && i < tokens.count && words.value(of: tokens[i]) != nil
        }
        func folded(_ i: Int) -> String {
            i >= 0 && i < tokens.count && tokens[i].kind == .word ? tokens[i].folded : ""
        }
        func isUnit(_ i: Int) -> Bool {
            i < tokens.count && PhraseLexicon.units.match(tokens, all, i) != nil
        }
        /// A number from `i`: its tokens, digits or words ("sáu", "mười
        /// lăm", "seven", "hai mươi lăm nghìn"); 0 when none.
        func number(_ i: Int) -> Int {
            guard i < tokens.count else { return 0 }
            if tokens[i].kind == .number { return tokens[i].value == nil && !tokens[i].isTime ? 0 : 1 }
            var j = i
            while j < tokens.count, j - i < 6, tokens[j].kind == .word,
                  PhraseLexicon.viNumbers.value(of: tokens[j]) != nil || PhraseLexicon.enNumbers[tokens[j].folded] != nil {
                j += 1
            }
            return j - i
        }
        /// A number said as minutes after an hour: digits under 60 glued to
        /// it ("7h30") or of two digits with no unit after ("7 giờ 15 phở");
        /// any before a time unit or at the end ("7 giờ 30 phút", "7 giờ 30").
        func minutes(_ j: Int, glued: Bool) -> Int {
            guard j < tokens.count else { return 0 }
            if tokens[j].kind == .number {
                guard tokens[j].isPlainDigits, let value = tokens[j].value, value < 60 else { return 0 }
                let next = j + 1
                if glued || next >= tokens.count || tokens[next].kind != .word || isWord(next, PhraseLexicon.timeUnits)
                    || isWord(next, PhraseLexicon.fillers) || (tokens[j].text.count == 2 && !isUnit(next)) {
                    return 1
                }
                return 0
            }
            // "rưỡi"; "mười lăm phút"
            if let half = PhraseLexicon.viNumbers.value(of: tokens[j]), case .half = half { return 1 }
            let words = number(j)
            return words > 0 && isWord(j + words, PhraseLexicon.timeUnits) ? words : 0
        }
        var times = Set<Int>()
        var i = 0
        while i < tokens.count {
            let token = tokens[i]
            if token.kind == .number, token.isTime || token.isPrice {
                times.insert(i)
                i += 1
                continue
            }
            let count = number(i)
            guard count > 0 else {
                i += 1
                continue
            }
            var j = i + count
            let isDigits = token.kind == .number
            // A price: "30k", "25 nghìn (đồng)", "40.000đ", "3 dollars".
            if let (_, length) = PhraseLexicon.currencies.match(tokens, all, j), !(folded(j) == "k" && folded(j + 1).hasPrefix("cal")) {
                var end = j + length
                if let (_, more) = PhraseLexicon.currencies.match(tokens, all, end) { end += more }
                let small = isDigits && folded(j) == "d" && (token.value ?? 0) < 1_000
                if !small {
                    for t in i..<end { times.insert(t) }
                    i = end
                    continue
                }
            }
            if !isDigits, ["nghin", "ngan"].contains(folded(j - 1)), !isUnit(j) {
                // "hai mươi lăm nghìn": a price.
                for t in i..<j { times.insert(t) }
                i = j
                continue
            }
            if isDigits, ["nghin", "ngan"].contains(folded(j)), !isUnit(j + 1) {
                // "30 nghìn", "25 ngàn đồng"
                var end = j + 1
                if let (_, length) = PhraseLexicon.currencies.match(tokens, all, end) { end += length }
                for t in i..<end { times.insert(t) }
                i = end
                continue
            }
            // A date: "thứ 2", "thứ bảy", "ngày 5", "tháng 11".
            if i > 0, isWord(i - 1, PhraseLexicon.dateWords) {
                for t in i..<j { times.insert(t) }
                i = j
                continue
            }
            if isWord(j, PhraseLexicon.timeUnits) || (folded(j) == "o" && folded(j + 1) == "clock") {
                // "7 giờ", "7h", "7 am", "sáu giờ", "seven o'clock", "30 phút"
                let hour = isWord(j, PhraseLexicon.hourUnits)
                let wordCount = folded(j) == "o" ? 2 : 1
                for t in i..<(j + wordCount) { times.insert(t) }
                j += wordCount
                if hour {
                    let glued = j < tokens.count && tokens[j - 1].range.upperBound == tokens[j].range.lowerBound
                    let length = minutes(j, glued: glued)
                    for t in j..<(j + length) { times.insert(t) }
                    j += length
                    if length > 0, isWord(j, PhraseLexicon.timeUnits) {
                        times.insert(j)
                        j += 1
                    }
                }
            } else if i > 0, isWord(i - 1, PhraseLexicon.timeBefore), isDigits || isWord(j, PhraseLexicon.dayParts) {
                // "lúc 7", "at 7", "at 12 30"
                for t in i..<j { times.insert(t) }
                if j < tokens.count, tokens[j].kind == .number, tokens[j].text.count == 2, minutes(j, glued: false) == 1 {
                    times.insert(j)
                    j += 1
                }
            }
            i = j
        }
        return times
    }

    private final class Memo {
        var outcomes: [MemoKey: Outcome] = [:]
    }

    private struct MemoKey: Hashable {
        var words: [Int]
        var unitTokens: [Int]
        var bareCount: Bool
    }

    func foods() -> [ParsedFood] {
        // The parts between hard separators, what wasn't eaten left out.
        var segments: [[Int]] = []
        var segment: [Int] = []
        for i in tokens.indices {
            if tokens[i].kind == .hard {
                segments.append(segment)
                segment = []
            } else {
                segment.append(i)
            }
        }
        segments.append(segment)
        // An amount alone after a food said without one is that food's:
        // "cơm: 1 chén", "trứng, 2 quả".
        var parts: [[Int]] = []
        for seg in segments.map(withoutNegated) where !seg.isEmpty {
            if let last = parts.last, isAmountOnly(seg), wantsAmount(last) {
                parts[parts.count - 1] = last + seg
            } else {
                parts.append(seg)
            }
        }
        var foods: [ParsedFood] = []
        for seg in parts where foods.count < FoodPhraseParser.maxFoods {
            foods += read(seg, limit: FoodPhraseParser.maxFoods - foods.count)
        }
        return foods
    }

    private func read(_ seg: [Int], limit: Int) -> [ParsedFood] {
        guard !seg.isEmpty, limit > 0 else { return [] }
        var foods: [ParsedFood] = []
        for chunk in chunks(elements(seg)) where foods.count < limit { foods += resolve(chunk) }
        return Array(foods.prefix(limit))
    }

    /// The part without what it says wasn't eaten: "không ăn cơm" (but
    /// "mà ăn bún bò" stays), "chưa ăn gì", "I didn't eat rice", "skipped
    /// lunch", "no breakfast". "không" in a name ("bánh mì không", "không
    /// đường", "phở không hành") has no verb after it and stays.
    private func withoutNegated(_ seg: [Int]) -> [Int] {
        var dropped = Set<Int>()
        var k = 0
        while k < seg.count {
            // "chả" in "bún chả" is food.
            guard let (kind, length) = PhraseLexicon.negations.match(tokens, seg, k),
                  !(tokens[seg[k]].folded == "cha" && index.isNamePair(tokens, seg, k)) else {
                k += 1
                continue
            }
            var j = k + length
            switch kind {
            case .verb:
                // "không ăn", "didn't even eat"
                let before = j
                while let (_, verb) = PhraseLexicon.negatedVerbs.match(tokens, seg, j) { j += verb }
                guard j > before else {
                    k += 1
                    continue
                }
            case .alone:
                break
            case .meal:
                guard PhraseLexicon.meals.match(tokens, seg, j) != nil else {
                    k += 1
                    continue
                }
            }
            // What wasn't eaten runs to "mà"/"but", or to another verb.
            while j < seg.count, PhraseLexicon.contrasts.match(tokens, seg, j) == nil,
                  PhraseLexicon.verbs.match(tokens, seg, j) == nil || index.isNamePair(tokens, seg, j) {
                j += 1
            }
            for t in k..<j { dropped.insert(seg[t]) }
            k = j
        }
        return dropped.isEmpty ? seg : seg.filter { !dropped.contains($0) }
    }

    /// An amount and nothing to eat: "1 chén", "2 quả".
    private func isAmountOnly(_ seg: [Int]) -> Bool {
        var amount = false
        for element in elements(seg) {
            switch element {
            case .amount(let value): if value.isQuantity { amount = true }
            case .words(let words): if words.contains(where: isFoodWord) { return false }
            case .joiner: return false
            }
        }
        return amount
    }

    /// Whether the last food of a part was said with no amount: "cơm".
    private func wantsAmount(_ seg: [Int]) -> Bool {
        var food = false
        var amount = false
        for element in elements(seg) {
            switch element {
            case .joiner:
                food = false
                amount = false
            case .words(let words):
                if words.contains(where: isFoodWord) { food = true }
            case .amount(let value):
                if value.isQuantity || value.kcal != nil { amount = true }
            }
        }
        return food && !amount
    }

    // MARK: Elements

    /// Whether a token is a filler ("tôi", "ăn", "nhé", "for lunch", a time).
    func isFiller(_ i: Int) -> Bool {
        times.contains(i) || phraseFillers.contains(i) || PhraseLexicon.fillers.value(of: tokens[i]) != nil
    }

    /// Whether a token can name a food: a word, not a filler or a
    /// stopword ("and", "of").
    func isFoodWord(_ i: Int) -> Bool {
        tokens[i].kind == .word && !isFiller(i) && PhraseLexicon.stopwords.value(of: tokens[i]) == nil
    }

    private func isWord(_ seg: [Int], _ k: Int) -> Bool {
        k >= 0 && k < seg.count && tokens[seg[k]].kind == .word
    }

    private func folded(_ seg: [Int], _ k: Int) -> String {
        isWord(seg, k) ? (tokens[seg[k]].marked == nil ? tokens[seg[k]].folded : "") : ""
    }

    /// Words, amounts and joiners, in order.
    private func elements(_ seg: [Int]) -> [PhraseElement] {
        var elements: [PhraseElement] = []
        var words: [Int] = []
        // Tokens of filler phrases: words, never a number or a unit.
        let fillerPhrase = phraseFillers
        var k = 0
        // Food words (not fillers) since the last element.
        var afterFood = false
        func flush() {
            if !words.isEmpty { elements.append(.words(words)) }
            words = []
            afterFood = false
        }
        func append(_ i: Int) {
            words.append(i)
            if !isFiller(i) { afterFood = true }
        }
        while k < seg.count {
            let token = tokens[seg[k]]
            if token.kind == .and {
                flush()
                elements.append(.joiner(.and, [seg[k]]))
                k += 1
                continue
            }
            if fillerPhrase.contains(seg[k]) || times.contains(seg[k]) {
                append(seg[k])
                k += 1
                continue
            }
            if let (join, length) = joiner(seg, k, afterFood: afterFood, afterAnything: afterFood || !elements.isEmpty) {
                flush()
                elements.append(.joiner(join, Array(seg[k..<(k + length)])))
                k += length
                continue
            }
            let afterUnit: Bool
            if words.isEmpty, case .amount(let last) = elements.last { afterUnit = last.unit != nil } else { afterUnit = false }
            if let (amount, length) = amount(seg, k, afterFood: afterFood, afterUnit: afterUnit, fillers: fillerPhrase) {
                flush()
                elements.append(.amount(amount))
                k += length
                continue
            }
            append(seg[k])
            k += 1
        }
        flush()
        return elements
    }

    /// A joiner at `k`: "và", "with", "&"…, or a verb after a food ("phở rồi
    /// ăn thêm…"). Never at the very end, and "thêm"/"plus" at the start is
    /// just a word.
    private func joiner(_ seg: [Int], _ k: Int, afterFood: Bool, afterAnything: Bool) -> (PhraseJoin, Int)? {
        if let (join, length) = PhraseLexicon.joiners.match(tokens, seg, k) {
            guard k + length < seg.count else { return nil }
            // Whether "with"/"and" inside a name ("fish and chips") is one
            // dish is decided when matching.
            if afterAnything || join == .with { return (join, length) }
            // "thêm 2 trứng" at the start: a filler.
            return nil
        }
        if afterFood, PhraseLexicon.verbs.match(tokens, seg, k) != nil, k + 1 < seg.count, !index.isNamePair(tokens, seg, k) {
            return (.and, 1)
        }
        return nil
    }

    // MARK: Amounts

    /// An amount starting at `k`, and how many tokens it takes. `afterFood`:
    /// food words come right before, where a number word needs a unit after
    /// it to be one ("thịt ba chỉ", "phở bò chín" stay food).
    private func amount(_ seg: [Int], _ k: Int, afterFood: Bool, afterUnit: Bool, fillers: Set<Int>) -> (PhraseAmount, Int)? {
        var amount = PhraseAmount()
        // "x2", "x 2", "×2"
        if folded(seg, k) == "x", k + 1 < seg.count, let value = tokens[seg[k + 1]].value, tokens[seg[k + 1]].kind == .number {
            amount.multiplier = value
            amount.tokens = [seg[k], seg[k + 1]]
            return (amount, 2)
        }
        // "kcal 450", "calo: 450"
        if let (_, length) = PhraseLexicon.kcal.match(tokens, seg, k), let number = number(seg, k + length, fillers: fillers),
           unit(seg, k + length + number.length) == nil {
            amount.kcal = number.value
            amount.tokens = Array(seg[k..<(k + length + number.length)])
            return (amount, length + number.length)
        }
        // "protein 40g", "đạm 30": not after food words ("whey protein 30g").
        if !afterFood, let (macro, length) = PhraseLexicon.macros.match(tokens, seg, k),
           let number = number(seg, k + length, fillers: fillers) {
            var end = k + length + number.length
            if let (unit, unitLength) = unit(seg, end), unit.kind == .weight, unit.grams == 1 { end += unitLength }
            amount.macros[macro] = number.value
            amount.tokens = Array(seg[k..<end])
            return (amount, end - k)
        }
        guard let number = number(seg, k, fillers: fillers) else {
            // Not right after another unit: "3 ly bia hơi" is beer.
            return afterUnit ? nil : containerAtStart(seg, k, afterFood: afterFood)
        }
        var end = k + number.length
        var value = number.value
        // "2x trứng", "2 x trứng"
        if folded(seg, end) == "x" {
            amount.multiplier = value
            amount.tokens = Array(seg[k...end])
            return (amount, end + 1 - k)
        }
        // "450 kcal"
        if let (_, length) = PhraseLexicon.kcal.match(tokens, seg, end) {
            amount.kcal = value
            end += length
            amount.tokens = Array(seg[k..<end])
            return (amount, end - k)
        }
        // "40 g protein", "40 protein" (the macro not before more food words:
        // "1 protein bar").
        var macroAt = end
        if let (unit, unitLength) = unit(seg, end), unit.kind == .weight, unit.grams == 1 { macroAt += unitLength }
        if let (macro, length) = PhraseLexicon.macros.match(tokens, seg, macroAt),
           !foodWord(seg, macroAt + length) {
            amount.macros[macro] = value
            end = macroAt + length
            amount.tokens = Array(seg[k..<end])
            return (amount, end - k)
        }
        if let (unit, length) = unit(seg, end) {
            let unitTokens = Array(seg[end..<(end + length)])
            end += length
            // "một bát rưỡi", "a bowl and a half"
            if let half = halfAfter(seg, end) {
                value += 0.5
                end += half
            }
            if unit.kind == .weight {
                amount.grams = value * (unit.grams ?? 1)
                amount.gramsTokens = unitTokens
            } else {
                amount.quantity = value
                amount.unit = unit
                amount.unitTokens = unitTokens
            }
            if folded(seg, end) == "of" { end += 1 }
            amount.tokens = Array(seg[k..<end])
            return (amount, end - k)
        }
        // A bare number: only before a food. A number word right after food
        // words needs a unit ("thịt ba chỉ"); "a"/"an" needs a word after it.
        if number.isWords && afterFood { return nil }
        guard isWord(seg, end) else {
            // Digits at the end count ("trứng 2"); words at the end don't
            // ("phở bò chín").
            guard !number.isWords else { return nil }
            amount.quantity = value
            amount.tokens = Array(seg[k..<end])
            return (amount, end - k)
        }
        if folded(seg, end) == "of" { end += 1 }
        amount.quantity = value
        amount.tokens = Array(seg[k..<end])
        return (amount, end - k)
    }

    /// A container with no number before it, where a food starts: "bát cơm",
    /// "cup of coffee", "bát rưỡi cơm" (1.5).
    private func containerAtStart(_ seg: [Int], _ k: Int, afterFood: Bool) -> (PhraseAmount, Int)? {
        guard !afterFood, let (unit, length) = unit(seg, k), unit.kind != .weight else { return nil }
        var end = k + length
        var amount = PhraseAmount(unit: unit, unitTokens: Array(seg[k..<end]))
        if let half = halfAfter(seg, end) {
            amount.quantity = 1.5
            end += half
        }
        if folded(seg, end) == "of" { end += 1 }
        // Only before food words: "chai" alone is a food (masala chai).
        guard isWord(seg, end) else { return nil }
        amount.tokens = Array(seg[k..<end])
        return (amount, end - k)
    }

    /// Whether a food word (not energy or a macro) is at `k` of `seg`.
    private func foodWord(_ seg: [Int], _ k: Int) -> Bool {
        k < seg.count && isFoodWord(seg[k]) && PhraseLexicon.kcal.match(tokens, seg, k) == nil && PhraseLexicon.macros.match(tokens, seg, k) == nil
    }

    /// "rưỡi" or "and a half" right after a unit: its token count.
    private func halfAfter(_ seg: [Int], _ k: Int) -> Int? {
        if let (word, _) = PhraseLexicon.viNumbers.match(tokens, seg, k), case .half = word { return 1 }
        if folded(seg, k) == "and", ["a", "an"].contains(folded(seg, k + 1)), folded(seg, k + 2) == "half" { return 3 }
        return nil
    }

    private func unit(_ seg: [Int], _ k: Int) -> (value: PhraseUnit, length: Int)? {
        PhraseLexicon.units.match(tokens, seg, k)
    }

    // MARK: Numbers

    private struct Number {
        var value: Double
        var length: Int
        /// Said in words ("hai", "a", "half"), not digits.
        var isWords: Bool
    }

    /// A number at `k`, in digits or words, Vietnamese or English.
    private func number(_ seg: [Int], _ k: Int, fillers: Set<Int>) -> Number? {
        guard k < seg.count, !fillers.contains(seg[k]) else { return nil }
        let token = tokens[seg[k]]
        if token.kind == .number {
            // Too many digits to read: an amount, but none (it reads as nothing).
            var value = token.value ?? .infinity
            guard value >= 0 else { return nil }
            // "3 in 1", "3 trong 1": a name ("cà phê 3 trong 1").
            if token.isPlainDigits, ["in", "trong"].contains(folded(seg, k + 1)), k + 2 < seg.count, tokens[seg[k + 2]].kind == .number {
                return nil
            }
            if k > 1, tokens[seg[k - 2]].kind == .number, ["in", "trong"].contains(folded(seg, k - 1)) { return nil }
            var length = 1
            // "1 1/2"
            if k + 1 < seg.count, tokens[seg[k + 1]].kind == .number, let fraction = tokens[seg[k + 1]].value, fraction < 1,
               value == value.rounded(), !tokens[seg[k + 1]].isPlainDigits {
                value += fraction
                length += 1
            }
            // "2 trăm", "5 chục", "2 dozen", "1 nghìn rưỡi"
            if let (multiplier, used) = PhraseLexicon.multipliers.match(tokens, seg, k + length) {
                value *= multiplier
                length += used
                if let (word, _) = PhraseLexicon.viNumbers.match(tokens, seg, k + length), case .half = word, multiplier >= 100 {
                    value += multiplier / 2
                    length += 1
                }
            }
            // "1 rưỡi" (1.5)
            if let (word, _) = PhraseLexicon.viNumbers.match(tokens, seg, k + length), case .half = word {
                value += 0.5
                length += 1
            }
            // "1 and a half"
            if folded(seg, k + length) == "and", ["a", "an"].contains(folded(seg, k + length + 1)), folded(seg, k + length + 2) == "half" {
                value += 0.5
                length += 3
            }
            // "1 và 1/2", "1 and 1/2"
            if isWord(seg, k + length), ["va", "and"].contains(tokens[seg[k + length]].folded), k + length + 1 < seg.count,
               tokens[seg[k + length + 1]].kind == .number, let fraction = tokens[seg[k + length + 1]].value, fraction < 1,
               !tokens[seg[k + length + 1]].isPlainDigits, value == value.rounded() {
                value += fraction
                length += 2
            }
            return Number(value: value, length: length, isWords: false)
        }
        guard token.kind == .word, !index.isNamePair(tokens, seg, k) else { return nil }
        if let number = viNumber(seg, k) { return number }
        return enNumber(seg, k)
    }

    private static let phanMarked = PhraseMarks.marked("phần")

    /// "hai", "mười hai", "hai mươi lăm", "một trăm rưỡi", "nửa", "một nửa",
    /// "vài", "một chục", "một phần tư".
    private func viNumber(_ seg: [Int], _ k: Int) -> Number? {
        var j = k
        var total = 0.0
        var current = 0.0
        var order = 0.0
        var digitPending = false
        var afterTen = false
        var any = false
        loop: while let (word, _) = PhraseLexicon.viNumbers.match(tokens, seg, j) {
            switch word {
            case .digit(let d):
                if afterTen {
                    current += d
                    afterTen = false
                } else if digitPending || current != 0 {
                    break loop
                } else {
                    current = d
                    digitPending = true
                }
            case .after(let d):
                guard afterTen else { break loop }
                current += d
                afterTen = false
            case .ten:
                guard current == 0 else { break loop }
                current = 10
                afterTen = true
            case .tens:
                guard digitPending else { break loop }
                current *= 10
                digitPending = false
                afterTen = true
            case .hundred:
                total += (current == 0 ? 1 : current) * 100
                current = 0
                order = 100
                digitPending = false
                afterTen = false
            case .thousand:
                total = (total + current == 0 ? 1 : total + current) * 1_000
                current = 0
                order = 1_000
                digitPending = false
                afterTen = false
            case .zero:
                guard order >= 100, current == 0 else { break loop }
            case .half:
                guard any else { break loop }
                if order > 0, current == 0 { total += order / 2 } else { current += 0.5 }
                j += 1
                break loop
            case .halfWord:
                // "nửa", "một nửa"
                if !any {
                    current = 0.5
                } else if current == 1, total == 0, digitPending {
                    current = 0.5
                } else {
                    break loop
                }
                j += 1
                any = true
                break loop
            case .few:
                guard !any else { break loop }
                current = 2
                j += 1
                any = true
                break loop
            case .dozen:
                current = (current == 0 ? 1 : current) * 10
                digitPending = false
            }
            any = true
            j += 1
        }
        guard any else { return nil }
        var value = total + current
        // "một phần tư" (¼), "ba phần tư" (¾), "hai phần ba" (⅔)
        if isWord(seg, j), tokens[seg[j]].folded == "phan", tokens[seg[j]].marked == nil || tokens[seg[j]].marked == Self.phanMarked,
           let (word, _) = PhraseLexicon.viNumbers.match(tokens, seg, j + 1), case .digit(let under) = word, under >= 2, value < under {
            value /= under
            j += 2
        }
        guard value > 0 else { return nil }
        return Number(value: value, length: j - k, isWords: true)
    }

    /// "a", "an", "one" … "ninety-nine", "a hundred", "half", "half a",
    /// "a quarter", "three quarters", "a couple of", "a dozen", "a few",
    /// "and a half" after any of them.
    private func enNumber(_ seg: [Int], _ k: Int) -> Number? {
        let first = folded(seg, k)
        guard !first.isEmpty else { return nil }
        var j = k
        var value: Double
        func skipOf() { if folded(seg, j) == "of" { j += 1 } }
        switch first {
        case "a", "an":
            let next = folded(seg, k + 1)
            switch next {
            case "couple", "pair":
                value = 2
                j = k + 2
                skipOf()
            case "dozen":
                value = 12
                j = k + 2
                skipOf()
            case "few":
                value = 3
                j = k + 2
                skipOf()
            case "half":
                value = 0.5
                j = k + 2
                if folded(seg, j) == "dozen" {
                    value = 6
                    j += 1
                }
                skipOf()
            case "quarter":
                value = 0.25
                j = k + 2
                skipOf()
            case "third":
                value = 1.0 / 3
                j = k + 2
                skipOf()
            case "hundred":
                value = 100
                j = k + 2
            case "little", "bit", "lot", "lots":
                return nil
            default:
                value = 1
                j = k + 1
            }
        case "half":
            value = 0.5
            j = k + 1
            skipOf()
            if ["a", "an", "the"].contains(folded(seg, j)) { j += 1 }
            if folded(seg, j) == "dozen" {
                value = 6
                j += 1
                skipOf()
            }
        case "quarter":
            value = 0.25
            j = k + 1
            skipOf()
            if ["a", "an", "the"].contains(folded(seg, j)) { j += 1 }
        case "couple", "pair":
            value = 2
            j = k + 1
            skipOf()
        case "dozen":
            value = 12
            j = k + 1
            skipOf()
        case "few", "several":
            value = 3
            j = k + 1
            skipOf()
        default:
            guard let cardinal = enCardinal(seg, k) else { return nil }
            value = cardinal.value
            j = k + cardinal.length
            // "three quarters", "two thirds"
            switch folded(seg, j) {
            case "quarter", "quarters":
                value /= 4
                j += 1
                skipOf()
                if ["a", "an", "the"].contains(folded(seg, j)) { j += 1 }
            case "third", "thirds":
                value /= 3
                j += 1
                skipOf()
                if ["a", "an", "the"].contains(folded(seg, j)) { j += 1 }
            case "half", "halves":
                value /= 2
                j += 1
                skipOf()
            default:
                break
            }
        }
        // "one and a half"
        if folded(seg, j) == "and", ["a", "an"].contains(folded(seg, j + 1)), folded(seg, j + 2) == "half" {
            value += 0.5
            j += 3
        }
        guard value > 0 else { return nil }
        return Number(value: value, length: j - k, isWords: true)
    }

    /// "two", "twenty one", "a hundred", "two hundred and fifty", "two
    /// thousand".
    private func enCardinal(_ seg: [Int], _ k: Int) -> (value: Double, length: Int)? {
        var j = k
        var total = 0.0
        var current = 0.0
        var any = false
        while j < seg.count {
            let word = folded(seg, j)
            if let value = PhraseLexicon.enNumbers[word] {
                // "twenty one", "two hundred fifty"; not "one two".
                let lastTwo = current.truncatingRemainder(dividingBy: 100)
                let fits = current == 0 || (lastTwo == 0 && value < 100)
                    || (lastTwo >= 20 && lastTwo.truncatingRemainder(dividingBy: 10) == 0 && value < 10)
                guard fits else { break }
                current += value
            } else if word == "hundred", any {
                current = (current == 0 ? 1 : current) * 100
            } else if word == "thousand", any {
                total += (current == 0 ? 1 : current) * 1_000
                current = 0
            } else if word == "and", any, current >= 100 || total >= 1_000, PhraseLexicon.enNumbers[folded(seg, j + 1)] != nil {
                // "two hundred and fifty"
            } else {
                break
            }
            any = true
            j += 1
        }
        guard any, total + current > 0 else { return nil }
        return (total + current, j - k)
    }

    // MARK: Foods from elements

    /// Elements split where a second amount starts: "một tô phở | hai quả
    /// trứng", "ức gà 200g | cơm 150g", "phở bò | 2 trứng". Joiners stay in;
    /// a chunk splits at them later.
    private func chunks(_ elements: [PhraseElement]) -> [[PhraseElement]] {
        var chunks: [[PhraseElement]] = []
        var current: [PhraseElement] = []
        // The part since the last joiner.
        var hasFood = false
        var hasQuantity = false
        var trailing = false
        var partWords: [Int] = []
        func start() {
            if !current.isEmpty { chunks.append(current) }
            current = []
            hasFood = false
            hasQuantity = false
            trailing = false
            partWords = []
        }
        /// Food words come next: the amount may be theirs.
        func foodNext(_ n: Int) -> Bool {
            guard n + 1 < elements.count, case .words(let next) = elements[n + 1] else { return false }
            return next.contains(where: isFoodWord)
        }
        /// Words the table has a food for.
        func named(_ words: [Int]) -> Bool {
            words.contains(where: isFoodWord) && evaluate(words, unit: nil, bareCount: false).match != nil
        }
        for (n, element) in elements.enumerated() {
            switch element {
            case .joiner:
                current.append(element)
                hasFood = false
                hasQuantity = false
                trailing = false
                partWords = []
            case .words(let words):
                let food = words.contains(where: isFoodWord)
                if food, hasFood, trailing { start() }
                current.append(element)
                partWords += words
                if food { hasFood = true }
            case .amount(let amount):
                if !amount.isQuantity {
                    // Energy, macros and "x2" stay with the food they follow.
                    current.append(element)
                    if hasFood { trailing = true }
                } else if !hasFood {
                    current.append(element)
                    hasQuantity = true
                } else if hasQuantity, foodNext(n) {
                    start()
                    current.append(element)
                    hasQuantity = true
                } else if hasQuantity {
                    // A second amount with no food after it is this food's:
                    // "1 lon bia 330ml".
                    current.append(element)
                    trailing = true
                } else if amount.isBareCount, foodNext(n) {
                    // "phở bò 2 trứng": the number starts the next food.
                    start()
                    current.append(element)
                    hasQuantity = true
                } else if foodNext(n), case .words(let next) = elements[n + 1], !named(partWords), named(next) {
                    // "Highlands 2 ly cà phê", "KFC 2 miếng gà rán": words
                    // the table hasn't got before the amount, a food after.
                    // A shop or a brand the table has nothing like is no food.
                    let words = partWords
                    let onlyWords = current.allSatisfy { if case .words = $0 { return true } else { return false } }
                    if onlyWords, evaluate(words, unit: nil, bareCount: false).ranked.isEmpty {
                        current = []
                    }
                    start()
                    current.append(element)
                    hasQuantity = true
                } else {
                    // "trứng 2 quả", "ức gà 200g": after its food.
                    current.append(element)
                    hasQuantity = true
                    trailing = true
                }
            }
        }
        start()
        return chunks
    }

    /// The foods of one chunk: its parts around joiners, joined back into
    /// one food where the words name one dish.
    private func resolve(_ chunk: [PhraseElement]) -> [ParsedFood] {
        var parts: [PhrasePart] = [PhrasePart()]
        var joins: [(PhraseJoin, [Int])] = []
        for element in chunk {
            switch element {
            case .words(let words):
                parts[parts.count - 1].words += words
                parts[parts.count - 1].tokens += words
            case .amount(let amount):
                parts[parts.count - 1].amounts.append(amount)
                parts[parts.count - 1].tokens += amount.tokens
            case .joiner(let join, let joinTokens):
                // No more parts than foods are kept.
                guard parts.count <= FoodPhraseParser.maxFoods else { break }
                joins.append((join, joinTokens))
                parts.append(PhrasePart())
            }
        }
        // A part with nothing to eat in it (no food word, no unit that could
        // be one, no energy) gives its amounts to the next part, or the last:
        // "1 tô | và | …".
        var kept: [PhrasePart] = []
        var keptJoins: [(PhraseJoin, [Int])] = []
        var carried: [PhraseAmount] = []
        for (n, part) in parts.enumerated() {
            var part = part
            let hasFood = part.words.contains(where: isFoodWord) || part.amounts.contains { !$0.unitTokens.isEmpty || $0.kcal != nil }
            guard hasFood else {
                carried += part.amounts
                continue
            }
            part.amounts = carried + part.amounts
            part.tokens = carried.flatMap(\.tokens) + part.tokens
            carried = []
            if !kept.isEmpty { keptJoins.append(joins[n - 1]) }
            kept.append(part)
        }
        if !carried.isEmpty, !kept.isEmpty {
            kept[kept.count - 1].amounts += carried
            kept[kept.count - 1].tokens += carried.flatMap(\.tokens)
        }
        guard !kept.isEmpty else { return [] }

        // "với"/"with" runs: one dish unless the parts match clearly better.
        var groups: [[PhrasePart]] = [[kept[0]]]
        var groupJoins: [[Int]] = [[]]
        var andJoins: [[Int]] = []
        for n in kept.indices.dropFirst() {
            let (join, joinTokens) = keptJoins[n - 1]
            if join == .with {
                groups[groups.count - 1].append(kept[n])
                groupJoins[groups.count - 1] += joinTokens
            } else {
                groups.append([kept[n]])
                groupJoins.append([])
                andJoins.append(joinTokens)
            }
        }
        var foods: [(parts: [PhrasePart], joinTokens: [Int])] = []
        var foodAnd: [[Int]] = []
        for (g, group) in groups.enumerated() {
            if g > 0 { foodAnd.append(andJoins[g - 1]) }
            if group.count == 1 || keepsWhole(group) {
                foods.append((group, groupJoins[g]))
            } else {
                for (p, part) in group.enumerated() {
                    if p > 0 { foodAnd.append([]) }
                    foods.append(([part], []))
                }
            }
        }
        // "and" between foods: one dish only when the words together are a
        // name exactly ("fish and chips", "mac and cheese").
        var merged: [(parts: [PhrasePart], joinTokens: [Int])] = []
        for (n, food) in foods.enumerated() {
            if n > 0, let last = merged.last, !foodAnd[n - 1].isEmpty,
               joinsExactly(last.parts, food.parts) {
                merged[merged.count - 1] = (last.parts + food.parts, last.joinTokens + foodAnd[n - 1] + food.joinTokens)
            } else {
                merged.append(food)
            }
        }
        return merged.compactMap { food($0.parts, joinTokens: $0.joinTokens) }
    }

    /// Whether parts joined by "với"/"with" are one dish: the whole names a
    /// table entry, and no part names one clearly better.
    private func keepsWhole(_ parts: [PhrasePart]) -> Bool {
        let whole = evaluate(parts.flatMap(\.words), unit: nil, bareCount: false)
        guard let wholeMatch = whole.match else {
            // Nothing for the whole: split, so what's known is matched.
            return !parts.contains { evaluate($0.words, unit: nil, bareCount: false).match != nil }
        }
        // A unit said for the first part that fits it better than the dish:
        // "2 chén cơm với thịt kho trứng" is two bowls of rice, not two
        // plates of "Cơm thịt kho trứng".
        if let first = parts.first, let amount = first.amounts.first(where: { $0.unit != nil }), let unit = amount.unit {
            let own = evaluate(first.words, unit: nil, bareCount: false)
            if let ownMatch = own.match, !own.partial,
               index.unitFit(ownMatch, unit: unit, bareCount: false) > index.unitFit(wholeMatch, unit: unit, bareCount: false) {
                return false
            }
        }
        if whole.level == 5, !whole.partial { return true }
        let each = parts.map { evaluate($0.words, unit: nil, bareCount: false) }
        // A part the table doesn't have: keep the dish ("grilled chicken
        // breast with lemon").
        if each.contains(where: { $0.match == nil }) { return true }
        if whole.partial { return false }
        // A part that names the same dish: it is the dish ("pasta with cream
        // sauce", "cream sauce" naming the Alfredo too).
        if each.contains(where: { $0.match == wholeMatch }) { return true }
        // Otherwise the dish only when it matches better than every part:
        // "cơm với trứng" is rice and an egg, not "Cơm trứng omurice".
        let weakest = each.map { $0.partial ? 0 : $0.level }.min() ?? 0
        return whole.level > weakest
    }

    /// Whether two foods joined by "and" are one dish: the words together
    /// are exactly a name, nothing is said after "and", and the first isn't
    /// a counted food with its count ("2 eggs and bacon").
    private func joinsExactly(_ left: [PhrasePart], _ right: [PhrasePart]) -> Bool {
        guard right.allSatisfy({ $0.amounts.isEmpty }) else { return false }
        let whole = evaluate(left.flatMap(\.words) + right.flatMap(\.words), unit: nil, bareCount: false)
        guard whole.match != nil, whole.level == 5, !whole.partial else { return false }
        if left.flatMap(\.amounts).contains(where: \.isBareCount) {
            let first = evaluate(left.flatMap(\.words), unit: nil, bareCount: true)
            if let entry = first.match, index.entries[entry].unit == .piece { return false }
        }
        return true
    }

    // MARK: One food

    private func food(_ parts: [PhrasePart], joinTokens: [Int]) -> ParsedFood? {
        let amounts = parts.flatMap(\.amounts)
        let words = parts.flatMap(\.words)
        var quantity: Double?
        var unit: PhraseUnit?
        var unitTokens: [Int] = []
        var grams: Double?
        var gramsTokens: [Int] = []
        var kcal: Double?
        var macros: [PhraseMacro: Double] = [:]
        var multiplier = 1.0
        var hasMultiplier = false
        // The count said with a unit wins over a bare number before it
        // ("11 ăn 1 tô phở"); a number out of range is none, and the next
        // one counts.
        let inRange = { (value: Double) in value > 0 && value <= 1_000 }
        if let counted = amounts.first(where: { $0.unit != nil }) {
            unit = counted.unit
            unitTokens = counted.unitTokens
            quantity = counted.quantity.flatMap { inRange($0) ? $0 : nil }
        }
        if quantity == nil { quantity = amounts.lazy.compactMap(\.quantity).first(where: inRange) }
        for amount in amounts {
            if grams == nil, let value = amount.grams {
                grams = value
                gramsTokens = amount.gramsTokens
            }
            if kcal == nil, let value = amount.kcal { kcal = value }
            for (macro, value) in amount.macros where macros[macro] == nil { macros[macro] = value }
            if let value = amount.multiplier {
                multiplier *= value
                hasMultiplier = true
            }
        }
        if hasMultiplier { quantity = (quantity ?? 1) * multiplier }
        if let value = quantity, !inRange(value) { quantity = nil }
        // A container's size after it is each one's: "2 chai bia 450ml" is
        // 900 ml, as QuickLogParser reads water; "2 hộp sữa 180ml" 360 ml,
        // "3 gói mì 75g" 225 g.
        if let each = grams, each <= 1_000, let count = quantity, count > 1, let unit, unit.families & UnitFamily.containers != 0,
           let unitAt = unitTokens.first, let gramsAt = gramsTokens.first, gramsAt > unitAt {
            grams = each * count
        }
        if let value = grams, !(value > 0 && value <= 100_000) { grams = nil }
        let energy = kcal.flatMap { $0 >= 0 && $0 <= 10_000 ? Int($0.rounded()) : nil }
        let hasFood = words.contains(where: isFoodWord) || !unitTokens.isEmpty
        guard hasFood || energy != nil else { return nil }

        let outcome = evaluate(words, unit: unit.map { ($0, unitTokens) }, bareCount: quantity != nil && unit == nil && grams == nil)
        let usedUnit = outcome.consumedUnit ? nil : unit
        // A unit that is also part of the name ("1 chai bia": "Bia chai")
        // still says what was counted when it fits the food; one that
        // doesn't ("1 hu tieu": hủ tiếu, not a jar) is a food word.
        let unitCounts = !unitTokens.isEmpty && unit.map { unit in
            unit.kind != .weight && (usedUnit != nil || outcome.match.map { index.unitFit($0, unit: unit, bareCount: false) > 0 } == true)
        } == true
        var nameTokens = outcome.nameTokens
        if outcome.consumedUnit, !unitCounts || nameTokens.isEmpty { nameTokens = (nameTokens + unitTokens).sorted() }
        // "fish and chips", "pasta with cream sauce": the joining word is part
        // of the name.
        if let first = nameTokens.first, let last = nameTokens.last {
            nameTokens = (nameTokens + joinTokens.filter { $0 > first && $0 < last }).sorted()
        }
        var unitWord: String?
        if unitCounts {
            unitWord = text(of: unitTokens).lowercased()
        } else if !gramsTokens.isEmpty {
            unitWord = text(of: gramsTokens).lowercased()
        }

        // The words the food was read from stay in its phrase even when they
        // can be fillers too ("2 qua tao": "táo", not "tao"; "nua qua bo":
        // "nửa", not "nữa").
        let keep = Set(nameTokens + amounts.flatMap(\.tokens))
        var result = ParsedFood(phrase: phrase(parts, joinTokens: joinTokens, keeping: keep), name: text(of: nameTokens),
                                quantity: quantity, unitWord: unitWord, grams: grams, kcal: energy, match: nil,
                                alternatives: [], amountGrams: nil, count: nil)
        result.proteinG = macros[.protein].flatMap { $0 <= 1_000 ? $0 : nil }
        result.fatG = macros[.fat].flatMap { $0 <= 1_000 ? $0 : nil }
        result.carbsG = macros[.carbs].flatMap { $0 <= 1_000 ? $0 : nil }
        result.alternatives = outcome.ranked.filter { $0 != outcome.match }.prefix(5).map { index.entries[$0] }
        if let entry = outcome.match {
            let food = index.entries[entry]
            result.match = food
            result.isPartialMatch = outcome.partial
            let resolved = resolveAmount(food, entry: entry, quantity: quantity, unit: usedUnit, grams: grams)
            result.amountGrams = resolved.amount
            result.count = resolved.count
            result.amountIsGuess = resolved.guess
        }
        return result
    }

    /// The grams of an entry the amount comes to, its count when it's
    /// counted, and whether the amount is a guess. Explicit grams win. A
    /// counted entry takes the count; a container said for one ("1 đĩa bánh
    /// xèo") counts one piece, since how many make a plate isn't known. A
    /// serving entry takes its servings, or a spoon's grams for a spoon
    /// unlike its own, a cup's grams for a cup of a food served otherwise
    /// ("a cup of almonds"), or for a drink served otherwise a cup's 240 g, a
    /// can's 330 or a bottle's 500. Counted pieces of a serving entry ("15
    /// quả nho", "10 almonds", "two scrambled eggs") take a piece's grams;
    /// with none known, pieces a serving holds many of ("3 múi bưởi", "10
    /// con ốc") come to one serving, a guess.
    private func resolveAmount(_ food: FoodEntry, entry: Int, quantity: Double?, unit: PhraseUnit?, grams: Double?)
        -> (amount: Double, count: Double?, guess: Bool) {
        let range = FoodPhraseParser.gramsRange
        func clamped(_ grams: Double) -> Double { min(max(grams, range.lowerBound), range.upperBound) }
        if let grams {
            let amount = clamped(grams)
            return (amount, food.unit == .piece ? amount / food.size.g : nil, false)
        }
        let servings = quantity ?? 1
        if food.unit == .piece {
            let amount = servings * food.size.g
            if range.contains(amount) { return (amount, servings, false) }
            let limited = clamped(amount)
            return (limited, limited / food.size.g, false)
        }
        // Counted by the piece, not by the entry's own size word: a bare
        // count, or "quả", "con", "múi".
        let ownUnit = unit.map { $0.families & index.families[entry] != 0 } ?? false
        let byPiece = !ownUnit && (unit.map { $0.kind == .counted } ?? (quantity != nil))
        if byPiece {
            if let piece = index.pieceGrams[entry] { return (clamped(servings * piece), nil, false) }
            let segments = unit.map { $0.families & UnitFamily.bit("segment") != 0 } ?? false
            let handfuls = index.families[entry] & (UnitFamily.bit("handful") | UnitFamily.bit("bunch")) != 0
            if segments || handfuls || (unit != nil && servings >= 5) { return (clamped(food.size.g), nil, true) }
        }
        var each = food.size.g
        if let unit, unit.kind != .weight, !ownUnit {
            let drink = ["drink", "alcohol", "dairy", "soup"].contains(food.category ?? "")
            if unit.kind == .amount, let spoon = unit.grams {
                each = spoon
            } else if unit.families & UnitFamily.glass != 0, let cup = index.cupGrams[entry] {
                each = cup
            } else if drink, unit.families & UnitFamily.glass != 0 {
                each = 240
            } else if drink, unit.families & UnitFamily.bit("can") != 0 {
                each = 330
            } else if drink, unit.families & UnitFamily.bit("bottle") != 0 {
                each = 500
            }
        }
        return (clamped(servings * each), nil, false)
    }

    /// The food's text from its first token to its last, fillers at either
    /// end left out ("tôi ăn 2 quả trứng nhé" is "2 quả trứng") unless the
    /// food was read from them (`keeping`).
    private func phrase(_ parts: [PhrasePart], joinTokens: [Int], keeping: Set<Int> = []) -> String {
        let all = (parts.flatMap(\.tokens) + joinTokens).sorted()
        let dropped = { (i: Int) in isFiller(i) && !keeping.contains(i) }
        let kept = all.drop(while: dropped).reversed().drop(while: dropped).reversed()
        guard let first = kept.first ?? all.first, let last = kept.last ?? all.last else { return "" }
        return String(text[tokens[first].range.lowerBound..<tokens[last].range.upperBound])
    }

    /// Tokens as typed: the text between the first and the last when they
    /// follow each other, else the words joined by spaces.
    private func text(of indices: [Int]) -> String {
        guard let first = indices.first, let last = indices.last else { return "" }
        if first <= last, indices == Array(first...last) {
            return String(text[tokens[first].range.lowerBound..<tokens[last].range.upperBound])
        }
        return indices.map { String(tokens[$0].text) }.joined(separator: " ")
    }

    // MARK: Matching

    struct Outcome {
        var match: Int?
        var level = 0
        var partial = false
        var consumedUnit = false
        /// The words the match is for (fillers left out when they don't belong).
        var nameTokens: [Int] = []
        /// Entries best first, the match among them.
        var ranked: [Int] = []
    }

    /// The best entry for food words, with the unit said for them (a unit
    /// can be part of the name: "1 gói mì" is "Mì gói", "2 bắp luộc" corn).
    func evaluate(_ words: [Int], unit: (PhraseUnit, [Int])?, bareCount: Bool) -> Outcome {
        let key = MemoKey(words: words, unitTokens: unit?.1 ?? [], bareCount: bareCount)
        if let known = memo.outcomes[key] { return known }
        let outcome = evaluateOnce(words, unit: unit, bareCount: bareCount)
        memo.outcomes[key] = outcome
        return outcome
    }

    /// The most words compared: no name is longer; the rest of a long
    /// phrase (the end in Vietnamese, the start in English) is left out.
    private static let maxWords = 12

    private func evaluateOnce(_ words: [Int], unit: (PhraseUnit, [Int])?, bareCount: Bool) -> Outcome {
        // Fillers off both ends: "tôi ăn phở nhé" is "phở".
        var stripped = words
        while let first = stripped.first, isFiller(first) { stripped.removeFirst() }
        while let last = stripped.last, isFiller(last) { stripped.removeLast() }
        var content = contentWords(stripped)
        if content.count > Self.maxWords {
            content = index.isVietnamese(content.map { tokens[$0] }, language: language)
                ? Array(content.prefix(Self.maxWords)) : Array(content.suffix(Self.maxWords))
        }
        let unitWords = unit.map { contentWords($0.1) } ?? []

        var tries: [(query: [Int], tokens: [Int], consumed: Bool)] = []
        if !content.isEmpty { tries.append((content, stripped, false)) }
        if let unit, unit.0.kind != .weight, !unitWords.isEmpty {
            tries.append((unitWords + content, stripped, true))
            if !content.isEmpty { tries.append((content + unitWords, stripped, true)) }
        }
        var all = contentWords(words)
        if all.count > Self.maxWords { all = content }
        if all != content, !all.isEmpty { tries.append((all, words, false)) }
        guard !tries.isEmpty else { return Outcome(nameTokens: stripped) }

        let unitInfo = unit?.0
        // Fried, battered or crispy said: a fried food may take the count.
        let friedSaid = words.contains { PhraseIndex.friedWords.contains(tokens[$0].folded) }
        // The diacritics as typed, then without them (a wrong tone), then a
        // part of the words.
        var unmatched: [Int] = []
        var weak: Outcome?
        // A wrong tone only in two words or more: alone, "ờ" would be any
        // "o".
        for strict in [true, false] where strict || content.count >= 2 {
            var best: [Int: PhraseIndex.Ranked] = [:]
            var bestTry: [Int: Int] = [:]
            for (t, attempt) in tries.enumerated() {
                let query = attempt.query.map { index.queryWord(tokens[$0]) }
                for var ranked in index.rank(query, strict: strict, language: language) {
                    // A unit read as part of the name still counts when it
                    // fits ("1 hộp sữa": "sữa hộp", a box). A count or unit
                    // never makes a food fried that wasn't said so ("a
                    // chicken breast" isn't fried chicken, "5 con tôm" isn't
                    // tempura).
                    var fit = index.unitFit(ranked.entry, unit: unitInfo, bareCount: bareCount)
                    if fit > 0, !friedSaid, index.fried[ranked.entry] { fit = 0 }
                    ranked.score = 4 * ranked.level + (attempt.consumed ? 2 + max(fit, 0) : fit)
                        + (ranked.isUsual ? PhraseIndex.usualBonus : 0)
                    ranked.accepted = PhraseIndex.accepts(level: ranked.level, words: query.count)
                    // The food's own words used, its unit aside.
                    ranked.words = query.count - (attempt.consumed ? unitWords.count : 0)
                    if let old = best[ranked.entry], let oldTry = bestTry[ranked.entry] {
                        // As good: the reading with more of the words ("kim
                        // chi", not "kim" without the "chi" that can be a
                        // filler).
                        let better = PhraseIndex.precedes(ranked, old)
                            || (!PhraseIndex.precedes(old, ranked) && attempt.query.count > tries[oldTry].query.count)
                        guard better else { continue }
                    }
                    best[ranked.entry] = ranked
                    bestTry[ranked.entry] = t
                }
            }
            let ranked = best.values.sorted(by: PhraseIndex.precedes)
            if let top = ranked.first, top.accepted {
                let attempt = tries[bestTry[top.entry] ?? 0]
                // The next best to change to: those that read all the words
                // typed first ("com tam": the other cơm tấm, then Cơm trắng
                // with "tam" left out as "tầm").
                let others = ranked.dropFirst().enumerated().sorted { a, b in
                    if a.element.accepted != b.element.accepted { return a.element.accepted }
                    if a.element.words != b.element.words { return a.element.words > b.element.words }
                    return a.offset < b.offset
                }.map(\.element.entry)
                let outcome = Outcome(match: top.entry, level: top.level, consumedUnit: attempt.consumed,
                                      nameTokens: attempt.tokens, ranked: [top.entry] + others)
                // Words far apart in a name ("banh mi … thit nuong" in "Bánh mì
                // pita gyros (thịt heo nướng xoay)") count less than most of
                // them being a name ("bánh mì thịt"); one word between is
                // close enough ("cơm sườn trứng", "Cơm tấm sườn trứng").
                guard top.level <= 2, top.gaps > 1 else { return outcome }
                weak = outcome
                break
            }
            if unmatched.isEmpty { unmatched = ranked.map(\.entry) }
        }
        // Only as typed: without diacritics one word too many is a name
        // ("bánh bò" would be "Bơ").
        let partial = partialMatch(stripped, content: content, unit: unitInfo, unitWords: unitWords, bareCount: bareCount)
        if partial.match != nil { return partial }
        if let weak { return weak }
        // Nothing fits: what comes closest, then what the main word finds
        // ("rau sống": the "rau" dishes).
        var alternatives = unmatched
        for entry in partial.ranked where !alternatives.contains(entry) { alternatives.append(entry) }
        return Outcome(nameTokens: stripped, ranked: alternatives)
    }

    /// Words a name might not have, left out from the end ("trà sữa | không
    /// đường") in Vietnamese order, from the start ("spicy | chicken wings")
    /// in English, so the word the food is about stays: the longest part, at
    /// least half the words, that is a name or begins one; in Vietnamese, of
    /// as many words, also the words with one in the middle left out ("bánh
    /// mì [kẹp] trứng"), and the words with their unit ("gói mì [Hảo Hảo]").
    /// Before a word that only changes the dish ("phở | không hành", "trà
    /// sữa | ít đường") any part will do. One word only in English, and only
    /// a whole name ("grilled | salmon"); in Vietnamese only the dish a bare
    /// word usually means ("phở | trứng") or one before such a change: the
    /// words after the first make the dish ("cơm chay", a vegetarian meal,
    /// isn't rice). With no such part, `ranked` holds what the word the food
    /// is about finds alone, for "change food".
    private func partialMatch(_ stripped: [Int], content: [Int], unit: PhraseUnit?, unitWords: [Int], bareCount: Bool) -> Outcome {
        let n = content.count
        guard n >= 2 else { return Outcome(nameTokens: stripped) }
        let vietnameseOrder = index.isVietnamese(content.map { tokens[$0] }, language: language)
        // Where a word that only changes the dish starts ("không hành").
        let change = vietnameseOrder ? (1..<n).first { PhraseLexicon.modifiers.value(of: tokens[content[$0]]) != nil } : nil
        // "bánh pizza", "bánh donut": "bánh" (cake, bread), typed with its
        // diacritics, before words borrowed as they are.
        if tokens[content[0]].folded == "banh", tokens[content[0]].marked != nil,
           content.dropFirst().allSatisfy({ tokens[$0].marked == nil }) {
            let query = content.dropFirst().map { index.queryWord(tokens[$0]) }
            var ranked = index.rank(query, strict: true, language: language)
            for i in ranked.indices {
                ranked[i].score = 4 * ranked[i].level + index.unitFit(ranked[i].entry, unit: unit, bareCount: bareCount)
                ranked[i].accepted = ranked[i].level >= 4
            }
            ranked.sort(by: PhraseIndex.precedes)
            if let top = ranked.first, top.accepted {
                return Outcome(match: top.entry, level: top.level, partial: true, nameTokens: stripped,
                               ranked: ranked.map(\.entry))
            }
        }
        var headAlone: [Int] = []
        for length in stride(from: n - 1, through: 1, by: -1) {
            let start = vietnameseOrder ? 0 : n - length
            let head = Array(content[start..<(start + length)])
            // The words tried at this length, and whether the unit is in them.
            var attempts: [(words: [Int], withUnit: Bool)] = [(head, false)]
            if vietnameseOrder {
                if length == n - 1, n >= 3 {
                    for skip in 1..<(n - 1) {
                        var words = content
                        words.remove(at: skip)
                        attempts.append((words, false))
                    }
                }
                if !unitWords.isEmpty { attempts.append((head + unitWords, true)) }
            }
            let enough = length * 2 >= n || change == length
            // English words left out that only say it's the plain kind:
            // "whole | egg", "plain | yogurt".
            let plainLeft = !vietnameseOrder && content[..<start].allSatisfy { PhraseLexicon.plainWords.contains(tokens[$0].folded) }
            var best: PhraseIndex.Ranked?
            var bestUnit = false
            var all: [Int] = []
            for attempt in attempts {
                let query = attempt.words.map { index.queryWord(tokens[$0]) }
                var ranked = index.rank(query, strict: true, language: language)
                for i in ranked.indices {
                    ranked[i].score = 4 * ranked[i].level + index.unitFit(ranked[i].entry, unit: unit, bareCount: bareCount)
                        + (ranked[i].isUsual ? PhraseIndex.usualBonus : 0)
                    let level = ranked[i].level
                    if attempt.withUnit {
                        ranked[i].accepted = enough && level >= 4
                    } else if length >= 2 {
                        ranked[i].accepted = enough && level >= 4
                    } else if vietnameseOrder {
                        // "phở | trứng", "phở | không hành"; never "cơm | chay".
                        ranked[i].accepted = enough && level >= 4 && (ranked[i].isUsual || change == 1)
                    } else {
                        ranked[i].accepted = enough && (level == 5 || (plainLeft && level >= 4))
                    }
                }
                ranked.sort(by: PhraseIndex.precedes)
                if let top = ranked.first, top.accepted, best.map({ PhraseIndex.precedes(top, $0) }) ?? true {
                    best = top
                    bestUnit = attempt.withUnit
                    all = ranked.map(\.entry)
                }
                if length == 1, !attempt.withUnit {
                    headAlone = ranked.filter { PhraseIndex.accepts(level: $0.level, words: 1) }.map(\.entry)
                }
            }
            if let best {
                return Outcome(match: best.entry, level: best.level, partial: true, consumedUnit: bestUnit, nameTokens: stripped,
                               ranked: all)
            }
        }
        return Outcome(nameTokens: stripped, ranked: headAlone)
    }

    /// The word tokens compared with names: no "of", "with", "và"…, and a
    /// word said twice in a row once ("trứng trứng").
    private func contentWords(_ words: [Int]) -> [Int] {
        var content: [Int] = []
        for word in words where tokens[word].kind == .word && PhraseLexicon.stopwords.value(of: tokens[word]) == nil {
            if let last = content.last, tokens[last].folded == tokens[word].folded { continue }
            content.append(word)
        }
        return content
    }
}

// MARK: - Index

/// The table's names by word, for matching food words: each entry's
/// Vietnamese and English names (whole, and outside parentheses) and other
/// names, as folded word ids with their diacritics.
private nonisolated final class PhraseIndex: Sendable {
    static let shared = PhraseIndex(table: .shared)

    /// Where the word a name is about sits: first in Vietnamese ("phở" in
    /// "Phở bò tái"), last before a qualifier in English ("rice" in "Brown
    /// rice, cooked"), either end in a name of unknown language.
    enum Head: Sendable {
        case start
        case at(Int)
        case either

        func holds(start: Int, count: Int, of total: Int) -> Bool {
            switch self {
            case .start: return start == 0
            case .at(let head): return start <= head && head < start + count
            case .either: return start == 0 || start + count == total
            }
        }
    }

    struct Key: Sendable {
        var entry: Int32
        /// 0 Vietnamese name, 1 English name, 2 another name.
        var source: UInt8
        /// A whole name, not a part of one.
        var original: Bool
        /// Its words without "of", "with", "và"…: folded ids and marked ids
        /// (-1 without diacritics).
        var words: [Int32]
        var marks: [Int32]
        var head: Head
        /// Bit p: word p is inside parentheses ("large pizza" of
        /// "Pepperoni pizza slice (large pizza)"): a description, not the name.
        var inParentheses: UInt64
        /// The name's length in characters, for ties.
        var length: Int
    }

    struct QueryWord {
        var folded: String
        /// The word and its other number ("egg"/"eggs") as folded ids.
        var ids: [Int32]
        /// The word exactly, in the singular when the table has that.
        var id: Int32
        var mark: Int32
        /// Typed without diacritics in a phrase typed with them.
        var bareOnly = false
    }

    struct Ranked {
        var entry: Int
        var level: Int
        /// Matched at that level in its name in the member's language.
        var language: Bool
        /// Of its Vietnamese and English names, how many have the words.
        var kinds: Int
        var isFood: Bool
        /// Its names with the words exactly, two at most.
        var strong: Int
        /// A name of it has nothing besides the words but plain ones
        /// ("Boiled egg", "Whole milk", "Nước lọc").
        var isPlain: Bool
        /// The dish a bare word usually means (`PhraseIndex.usual`).
        var isUsual: Bool
        var nameLength: Int
        /// Words between those matched, at level 2 or less.
        var gaps: Int
        var score = 0
        var accepted = false
        /// How many of the typed words the reading used: as good otherwise,
        /// "com tam" (Cơm tấm sườn) beats "com" (Cơm trắng) with "tam" left
        /// out as "tầm".
        var words = 0
    }

    /// How query words sit in one name (`level`, 1-5), together and exactly
    /// as typed, and the name's other words that aren't plain ones.
    struct Found {
        var level: Int
        var together: Bool
        var exactly: Bool
        var nonPlain: Int
        /// Other words between the first and the last matched (level 2).
        var gaps = 0
    }

    let entries: [FoodEntry]
    let keys: [Key]
    /// Folded ids of `PhraseLexicon.plainWords`.
    let plain: Set<Int32>
    /// `usualIds` by folded words, as entry indices.
    let usual: [String: Int]
    /// Keys by folded word id.
    let postings: [[Int32]]
    let wordIds: [String: Int32]
    let markIds: [String: Int32]
    /// Folded words that follow each other in a name outside parentheses.
    let pairs: Set<Int64>
    /// Per word id: 1 in a Vietnamese name, 2 in an English one.
    let languages: [UInt8]
    /// Per word id: written without diacritics in a Vietnamese name ("chay"
    /// in "bánh bao chay", "canh"), so typed so it means that word, not
    /// "cháy". "pho" never is: typed so, it's "phở" without its marks.
    let plainVietnamese: [Bool]
    /// Per entry: the families of its size words.
    let families: [UInt64]
    /// Per entry: counted by its size word or by the piece (a bare count
    /// fits it).
    let countable: [Bool]
    /// Per entry: fried, battered or crispy by its name.
    let fried: [Bool]
    /// Per entry: one piece's grams of a food by amount (`pieceGramsById`),
    /// and a cup's (`cupGramsById`).
    let pieceGrams: [Double?]
    let cupGrams: [Double?]

    init(table: FoodTable) {
        let entries = table.entries
        var wordIds: [String: Int32] = [:]
        var markIds: [String: Int32] = [:]
        var cache: [Substring: (id: Int32, mark: Int32, stop: Bool)] = [:]
        /// A name's words, and whether each is a stopword ("of", "với").
        func words(_ name: String) -> [(id: Int32, mark: Int32, stop: Bool)] {
            PhraseIndex.split(name).map { raw in
                if let known = cache[raw] { return known }
                let token = PhraseLexer.word(raw, range: raw.startIndex..<raw.endIndex)
                let id: Int32
                if let known = wordIds[token.folded] {
                    id = known
                } else {
                    id = Int32(wordIds.count)
                    wordIds[token.folded] = id
                }
                var mark: Int32 = -1
                if let marked = token.marked {
                    if let known = markIds[marked] {
                        mark = known
                    } else {
                        mark = Int32(markIds.count)
                        markIds[marked] = mark
                    }
                }
                let word = (id: id, mark: mark, stop: PhraseLexicon.stopwords.value(of: token) != nil)
                cache[raw] = word
                return word
            }
        }

        // Pass 1: which language each word is in.
        var languageBits: [Int32: UInt8] = [:]
        for entry in entries {
            for word in words(entry.vi) { languageBits[word.id, default: 0] |= 1 }
            for word in words(entry.en) { languageBits[word.id, default: 0] |= 2 }
        }
        /// Another name's head: first when it reads as Vietnamese (any
        /// diacritics, or more words only Vietnamese names have), the
        /// English head when it reads as English ("lemon tea"), else either
        /// end.
        func head(ofOther name: String) -> Head {
            let list = words(name)
            if list.contains(where: { $0.mark >= 0 }) { return .start }
            var vi = 0
            var en = 0
            for word in list {
                switch languageBits[word.id] ?? 0 {
                case 1: vi += 1
                case 2: en += 1
                default: break
                }
            }
            return vi > en ? .start : en > vi ? .at(PhraseIndex.englishHead(name)) : .either
        }

        // Pass 2: the keys, entry by entry.
        var keys: [Key] = []
        var pairs = Set<Int64>()
        var seen: [[Int32]: Int] = [:]
        func addPairs(_ name: String) {
            let list = words(name)
            for (a, b) in zip(list, list.dropFirst()) { pairs.insert(Int64(a.id) << 32 | Int64(b.id)) }
        }
        func add(_ name: String, entry: Int, source: UInt8, original: Bool, head: Head) {
            let list = words(name)
            let inside = PhraseIndex.insideParentheses(name)
            var content: [Int32] = []
            var marks: [Int32] = []
            var inParentheses: UInt64 = 0
            var headIndex: Int?
            var englishHead = -1
            if case .at(let h) = head { englishHead = h }
            for (p, word) in list.enumerated() {
                if word.stop { continue }
                if p <= englishHead { headIndex = content.count }
                if p < inside.count, inside[p], content.count < 64 { inParentheses |= UInt64(1) << UInt64(content.count) }
                content.append(word.id)
                marks.append(word.mark)
            }
            guard !content.isEmpty, content.count <= 64 else { return }
            // A name another of the entry's repeats ("pho bo tai" for "Phở
            // bò tái") adds nothing, and would count twice in ties; its
            // diacritics, when the first had none, make it match as typed.
            if let other = seen[content] {
                for (p, mark) in marks.enumerated() where keys[other].marks[p] < 0 { keys[other].marks[p] = mark }
                if original { keys[other].original = true }
                return
            }
            seen[content] = keys.count
            var keyHead = head
            if case .at = head { keyHead = .at(headIndex ?? content.count - 1) }
            keys.append(Key(entry: Int32(entry), source: source, original: original, words: content, marks: marks,
                            head: keyHead, inParentheses: inParentheses, length: name.count))
        }
        // A name, and its part outside parentheses ("Bia chai" of "Bia chai
        // (450 ml)"). What's inside them is often a list of what's in the
        // dish ("Katsu curry (rice, curry, pork cutlet)"), never a name of its
        // own: the other names the parentheses give are in `aka`.
        for (e, entry) in entries.enumerated() {
            seen = [:]
            let vi = PhraseIndex.outsideParentheses(entry.vi)
            add(entry.vi, entry: e, source: 0, original: true, head: .start)
            if vi != entry.vi { add(vi, entry: e, source: 0, original: false, head: .start) }
            addPairs(vi)

            let en = PhraseIndex.outsideParentheses(entry.en)
            add(entry.en, entry: e, source: 1, original: true, head: .at(PhraseIndex.englishHead(entry.en)))
            if en != entry.en { add(en, entry: e, source: 1, original: false, head: .at(PhraseIndex.englishHead(en))) }
            addPairs(en)

            for aka in entry.aka {
                add(aka, entry: e, source: 2, original: true, head: head(ofOther: aka))
                addPairs(aka)
            }
            // "cafe", the everyday spelling of "cà phê": "1 ly cafe".
            for name in [vi] + entry.aka {
                let cafe = PhraseIndex.cafeSpelling(name)
                if cafe != name { add(cafe, entry: e, source: 2, original: false, head: .start) }
            }
        }
        var plain = Set<Int32>()
        for word in PhraseLexicon.plainWords {
            if let id = wordIds[word] { plain.insert(id) }
        }

        var postings = [[Int32]](repeating: [], count: wordIds.count)
        for (k, key) in keys.enumerated() {
            for id in Set(key.words) { postings[Int(id)].append(Int32(k)) }
        }
        var languages = [UInt8](repeating: 0, count: wordIds.count)
        for (id, bits) in languageBits { languages[Int(id)] = bits }
        var plainVietnamese = [Bool](repeating: false, count: wordIds.count)
        // Vietnamese names and other names with diacritics, outside
        // parentheses; never an English name with a borrowed word ("Banh mi
        // with pâté" doesn't make "banh" a word written so, nor "Beef pho
        // (tái lăn)" "pho"), nor a name borrowed as it is ("(Nom Banh Chok)").
        for key in keys where key.source == 0 || (key.source == 2 && key.marks.contains(where: { $0 >= 0 })) {
            for (p, id) in key.words.enumerated() where key.marks[p] < 0 && (p >= 64 || key.inParentheses & (UInt64(1) << UInt64(p)) == 0) {
                plainVietnamese[Int(id)] = true
            }
        }

        var families: [UInt64] = []
        var countable: [Bool] = []
        var fried: [Bool] = []
        var pieceGrams: [Double?] = []
        var cupGrams: [Double?] = []
        for entry in entries {
            let bits = PhraseIndex.families(ofSize: entry.size.vi, vietnamese: true)
                | PhraseIndex.families(ofSize: entry.size.en, vietnamese: false)
            families.append(bits)
            let piece = PhraseIndex.pieceGramsById[entry.id]
            pieceGrams.append(piece)
            cupGrams.append(PhraseIndex.cupGramsById[entry.id])
            countable.append(entry.unit == .piece || bits & UnitFamily.pieces != 0 || piece != nil)
            let named = PhraseIndex.split(entry.en + " " + entry.vi).map { FoodTable.fold(String($0)) }
            fried.append(named.contains(where: PhraseIndex.friedWords.contains))
        }

        self.entries = entries
        self.keys = keys
        self.plain = plain
        var usual: [String: Int] = [:]
        for (words, id) in PhraseIndex.usualIds {
            if let e = entries.firstIndex(where: { $0.id == id }) { usual[words] = e }
        }
        self.usual = usual
        self.postings = postings
        self.wordIds = wordIds
        self.markIds = markIds
        self.pairs = pairs
        self.languages = languages
        self.plainVietnamese = plainVietnamese
        self.families = families
        self.countable = countable
        self.fried = fried
        self.pieceGrams = pieceGrams
        self.cupGrams = cupGrams
    }

    /// A name with "cà phê" written "cafe"; the name itself without it.
    static func cafeSpelling(_ name: String) -> String {
        var spelled = name
        for form in ["cà phê", "ca phe", "cà phe", "ca phê"] {
            spelled = spelled.replacingOccurrences(of: form, with: "cafe", options: .caseInsensitive)
        }
        return spelled
    }

    /// Words of a fried, battered or crispy food's name, folded.
    static let friedWords: Set<String> = [
        "fried", "deep", "tempura", "battered", "breaded", "crispy", "crunchy", "katsu", "karaage", "fritter",
        "fritters", "nugget", "nuggets", "chien", "ran", "gion",
    ]

    /// One piece's edible grams of foods the table serves by amount, for a
    /// count of pieces ("15 quả nho", "10 almonds", "10 con tôm", "two
    /// scrambled eggs"), from USDA FoodData Central's portions
    /// (Tools/food-table/usda, `find.py --portions`). Ids missing from the
    /// table are left out.
    static let pieceGramsById: [String: Double] = [
        "grapes": 4.9,              // SR 174683: 10 grapes, 49 g
        "strawberries": 12,         // SR 167762: 1 medium
        "cherries": 8.2,            // SR 171719: 1 cherry
        "longan": 3.2,              // SR 169089: 1 fruit without refuse
        "cherry_tomatoes": 17,      // SR 170457: 1 cherry tomato
        "almonds": 1.3,             // SR 170158: 1 oz, 22 kernels
        "cashews": 1.5,             // FNDDS 2707493: 1 nut
        "peanuts_roasted": 1,       // SR 173806: 1 peanut
        "walnuts": 4,               // SR 170187: 7 nuts, 28 g
        "pistachios": 0.7,          // SR 170185: 1 kernel
        "macadamia": 2.6,           // SR 170179: 1 oz, 10-12 kernels
        "chestnuts_roasted": 8.4,   // SR 170190: 10 kernels, 84 g
        "shrimp_boiled": 10,        // FNDDS 2706363: 1 small or medium shrimp
        "scrambled_eggs": 60.5,     // the entry's 2 eggs, 121 g (SR 172187: 61 g a large egg)
        "watermelon": 286,          // SR 167765: 1 wedge, 1/16 melon
        "pineapple": 84,            // SR 169124: 1 slice, 3½" across
        "cantaloupe": 69,           // SR 169092: 1 medium wedge, ⅛ melon
    ]

    /// A cup's grams of foods the table serves otherwise: "a cup of
    /// almonds" (USDA FoodData Central's portions, as above).
    static let cupGramsById: [String: Double] = [
        "almonds": 138,             // SR 170158: 1 cup whole kernels
        "cashews": 137,             // SR 170571: 1 cup, halves and whole
        "peanuts_roasted": 146,     // SR 173806: 1 cup
        "pistachios": 123,          // SR 170185: 1 cup
        "macadamia": 132,           // SR 170179: 1 cup
        "walnuts": 100,             // SR 170187: 1 cup shelled, 50 halves
        "grapes": 151,              // SR 174683: 1 cup
        "cherries": 154,            // SR 171719: 1 cup without pits
        "cherry_tomatoes": 149,     // SR 170457: 1 cup cherry tomatoes
        "raisins": 145,             // SR 168165: 1 cup, not packed
        "jackfruit": 165,           // SR 174687: 1 cup, sliced
        "pomelo": 190,              // SR 167754: 1 cup, sections
        "pineapple": 165,           // SR 169124: 1 cup, chunks
        "cantaloupe": 160,          // SR 169092: 1 cup, cubes
        "watermelon": 152,          // SR 167765: 1 cup, diced
    ]

    /// A name's words: runs of letters, runs of digits.
    static func split(_ name: String) -> [Substring] {
        var words: [Substring] = []
        var start: String.Index?
        var digits = false
        var i = name.startIndex
        while i < name.endIndex {
            let c = name[i]
            let isDigit = PhraseLexer.isDigit(c)
            if c.isLetter || isDigit {
                if let begun = start, digits != isDigit {
                    words.append(name[begun..<i])
                    start = i
                } else if start == nil {
                    start = i
                }
                digits = isDigit
            } else if let begun = start {
                words.append(name[begun..<i])
                start = nil
            }
            i = name.index(after: i)
        }
        if let begun = start { words.append(name[begun...]) }
        return words
    }

    /// For each word of a name (as `split` gives them), whether it is inside
    /// parentheses.
    static func insideParentheses(_ name: String) -> [Bool] {
        guard name.contains("(") else { return [] }
        var inside: [Bool] = []
        var depth = 0
        var inWord = false
        var digits = false
        for c in name {
            let isDigit = PhraseLexer.isDigit(c)
            if c.isLetter || isDigit {
                if !inWord || digits != isDigit { inside.append(depth > 0) }
                inWord = true
                digits = isDigit
            } else {
                inWord = false
                if c == "(" { depth += 1 }
                if c == ")" { depth = max(depth - 1, 0) }
            }
        }
        return inside
    }

    /// A name outside its parentheses: "Chả giò" of "Chả giò (nem rán)"; an
    /// unclosed "(" runs to the end.
    static func outsideParentheses(_ name: String) -> String {
        guard name.contains("(") else { return name }
        var outside = ""
        var depth = 0
        for character in name {
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

    /// The word index (all words) of an English name's head: the last word
    /// before the first qualifier, as `FoodTable.search` reads it.
    static func englishHead(_ name: String) -> Int {
        var end = name.endIndex
        for marker in ["(", ",", ":", " with ", " in ", " on ", " of "] {
            if let range = name.range(of: marker, options: .caseInsensitive), range.lowerBound < end { end = range.lowerBound }
        }
        return max(split(String(name[..<end])).count - 1, 0)
    }

    /// The unit families of a size word: "đĩa nhỏ" a plate, "muỗng canh" a
    /// tablespoon (and a spoon), "small bowl" a bowl.
    static func families(ofSize word: String, vietnamese: Bool) -> UInt64 {
        let tokens = split(word).map { PhraseLexer.word($0, range: $0.startIndex..<$0.endIndex) }
        guard !tokens.isEmpty else { return 0 }
        let positions = Array(tokens.indices)
        var bits: UInt64 = 0
        if vietnamese {
            if let (unit, _) = PhraseLexicon.units.match(tokens, positions, 0) { bits = unit.families }
        } else {
            if let (unit, _) = PhraseLexicon.units.match(tokens, positions, 0), positions.count == 1 { bits = unit.families }
            if let (unit, _) = PhraseLexicon.units.match(tokens, positions, positions.count - 1) { bits |= unit.families }
            if ["side", "appetizer", "entree", "cone"].contains(tokens.last?.folded ?? "") { bits |= UnitFamily.bit("serving") }
        }
        if bits & (UnitFamily.bit("tbsp") | UnitFamily.bit("tsp")) != 0 { bits |= UnitFamily.bit("spoon") }
        return bits
    }

    // MARK: Queries

    func queryWord(_ token: PhraseToken) -> QueryWord {
        var folded = token.folded
        if wordIds[folded] == nil, token.marked == nil, let synonym = PhraseLexicon.synonyms[folded] { folded = synonym }
        let id = wordIds[folded] ?? -1
        var ids: [Int32] = id >= 0 ? [id] : []
        // English plurals and singulars, never for a word with diacritics.
        if token.marked == nil, token.kind == .word, folded.count >= 3, folded.allSatisfy({ $0.isASCII && $0.isLetter }) {
            var variants = [folded + "s", folded + "es"]
            if folded.hasSuffix("s"), folded.count >= 4 { variants.append(String(folded.dropLast())) }
            if folded.hasSuffix("es"), folded.count >= 5 { variants.append(String(folded.dropLast(2))) }
            if folded.hasSuffix("ies"), folded.count >= 5 { variants.append(String(folded.dropLast(3)) + "y") }
            if folded.hasSuffix("y"), folded.count >= 4 { variants.append(String(folded.dropLast()) + "ies") }
            if folded.hasSuffix("ves") { variants.append(String(folded.dropLast(3)) + "f") }
            for variant in variants {
                if let other = wordIds[variant], !ids.contains(other) { ids.append(other) }
            }
        }
        // "eggs" counts "egg" as exactly what was typed: names of counted
        // foods are in the singular ("Boiled egg").
        var exact = id
        if token.marked == nil, folded.hasSuffix("s"), folded.count >= 4 {
            if let singular = wordIds[String(folded.dropLast())] { exact = singular }
            else if folded.hasSuffix("es"), let singular = wordIds[String(folded.dropLast(2))] { exact = singular }
            else if folded.hasSuffix("ies"), let singular = wordIds[String(folded.dropLast(3)) + "y"] { exact = singular }
        }
        let mark = token.marked.flatMap { markIds[$0] } ?? (token.marked == nil ? -1 : -2)
        return QueryWord(folded: folded, ids: ids, id: exact, mark: mark, bareOnly: token.bareOnly)
    }

    /// Whether word `k` and a word next to it follow each other in a name
    /// ("thịt ba chỉ", "chè ba màu", "mì ăn liền", "half-boiled egg"): then
    /// it's part of the food, not a number or a verb. Not before a unit
    /// ("hai quả").
    func isNamePair(_ tokens: [PhraseToken], _ seg: [Int], _ k: Int) -> Bool {
        guard let id = wordIds[tokens[seg[k]].folded] else { return false }
        if k + 1 < seg.count, tokens[seg[k + 1]].kind == .word, PhraseLexicon.units.match(tokens, seg, k + 1) == nil,
           let next = wordIds[tokens[seg[k + 1]].folded], pairs.contains(Int64(id) << 32 | Int64(next)) {
            return true
        }
        if k > 0, tokens[seg[k - 1]].kind == .word, let before = wordIds[tokens[seg[k - 1]].folded],
           pairs.contains(Int64(before) << 32 | Int64(id)) {
            return true
        }
        return false
    }

    /// Whether typed words read as Vietnamese: any diacritics, else more
    /// words only Vietnamese names have than only English ones have.
    func isVietnamese(_ words: [PhraseToken], language: String) -> Bool {
        if words.contains(where: { $0.marked != nil }) { return true }
        var vi = 0
        var en = 0
        for word in words {
            guard let id = wordIds[word.folded] else { continue }
            switch languages[Int(id)] {
            case 1: vi += 1
            case 2: en += 1
            default: break
            }
        }
        return vi != en ? vi > en : language == "vi"
    }

    /// Enough of a match to be that food: one word at a name's head, two
    /// together, three or more in order.
    static func accepts(level: Int, words: Int) -> Bool {
        switch words {
        case 1: return level >= 4
        case 2: return level >= 3
        default: return level >= 2
        }
    }

    /// Best first: accepted, score (level, unit, the usual dish of a bare
    /// word), level, the usual dish, the name in the member's language, a plain name ("Boiled
    /// egg" for "egg", "Whole milk" for "milk"), then much as
    /// `FoodTable.search` breaks ties: both names with the words, a plain
    /// food before a dish, names with the words exactly, the shortest
    /// matching name ("white bread" for "bread"); the table's order.
    static func precedes(_ a: Ranked, _ b: Ranked) -> Bool {
        if a.accepted != b.accepted { return a.accepted }
        // Two whole names: the one with more of the words typed, whatever
        // the unit ("1 phan com tam" is Cơm tấm, not "cơm phần" with "tam"
        // left out as "tầm").
        if a.level == 5, b.level == 5, a.words != b.words { return a.words > b.words }
        if a.score != b.score { return a.score > b.score }
        if a.level != b.level { return a.level > b.level }
        if a.words != b.words { return a.words > b.words }
        if a.isUsual != b.isUsual { return a.isUsual }
        if a.language != b.language { return a.language }
        if a.isPlain != b.isPlain { return a.isPlain }
        if a.kinds != b.kinds { return a.kinds > b.kinds }
        if a.isFood != b.isFood { return a.isFood }
        if a.strong != b.strong { return a.strong > b.strong }
        if a.nameLength != b.nameLength { return a.nameLength < b.nameLength }
        return a.entry < b.entry
    }

    /// What a bare word usually means where the table has several equals,
    /// worth a little more than a match level in the score: "phở" is phở bò
    /// tái, not the shortest name (phở gà); "1 chai nước" water, not the
    /// sports drink sold by the bottle; "hot dog" the one in a bun, not the
    /// sausage another name calls so; but "1 gói cà phê" the sachet ("cà phê
    /// gói"). Ids missing from the table are left out.
    static let usualIds: [String: String] = [
        "pho": "vn.pho_bo_tai", "pho bo": "vn.pho_bo_tai", "nuoc": "water", "ca phe": "black_coffee",
        "cafe": "black_coffee", "hot dog": "us.hot_dog", "hotdog": "us.hot_dog",
    ]
    static let usualBonus = 5

    /// Entries with every word of `query` in one name, unsorted, each with
    /// its best level. Words typed with diacritics match only names with
    /// the same ones ("bơ" isn't "Bò bía"'s "bo bia"), unless not `strict`
    /// (a wrong tone typed). The tie-breaks count names as
    /// `FoodTable.search` does, diacritics aside.
    func rank(_ query: [QueryWord], strict: Bool, language: String) -> [Ranked] {
        guard !query.isEmpty, query.allSatisfy({ !$0.ids.isEmpty }) else { return [] }
        // Typed with diacritics: a word without any is meant so ("cơm chay",
        // vegetarian, isn't "Cơm cháy").
        // A word alone counts the whole phrase: "Nam" before "ăn 2 quả
        // trứng" is a name, not "nấm"; words together without any ("phở, tra
        // da") are a food typed so.
        let marked = query.contains { $0.mark != -1 } || (query.count == 1 && query[0].bareOnly)
        // The rarest word's keys.
        var rarest = query[0]
        var fewest = Int.max
        for word in query {
            let count = word.ids.reduce(0) { $0 + postings[Int($1)].count }
            if count < fewest {
                fewest = count
                rarest = word
            }
        }
        var candidates = rarest.ids.flatMap { postings[Int($0)] }
        if rarest.ids.count > 1 { candidates = Array(Set(candidates)).sorted() }

        struct Best {
            var level = 0
            var language = false
            var plainest = Int.max
            var gaps = Int.max
            var shortest = Int.max
            var kinds: UInt8 = 0
            var strong = 0
        }
        var best: [Int32: Best] = [:]
        let languageSource: UInt8 = language == "vi" ? 0 : 1
        var scratch = Scratch(count: query.count)
        for k in candidates {
            let key = keys[Int(k)]
            guard let found = match(query, key, marked: marked, lenient: !strict, scratch: &scratch) else { continue }
            var entry = best[key.entry] ?? Best()
            // The Vietnamese and English names with the words ("pho" is in
            // both of the phở's, one of the phô mai's).
            if found.folded.level >= 3, key.source < 2 { entry.kinds |= 1 << key.source }
            if key.original && found.folded.together && found.folded.exactly { entry.strong += 1 }
            if let ranked = found.strict {
                let inLanguage = key.source == languageSource
                if ranked.level > entry.level {
                    entry.level = ranked.level
                    entry.language = inLanguage
                    entry.plainest = ranked.nonPlain
                    entry.gaps = ranked.gaps
                    entry.shortest = key.length
                } else if ranked.level == entry.level {
                    if inLanguage, !entry.language { entry.language = true }
                    entry.plainest = min(entry.plainest, ranked.nonPlain)
                    entry.gaps = min(entry.gaps, ranked.gaps)
                    entry.shortest = min(entry.shortest, key.length)
                }
            }
            best[key.entry] = entry
        }
        let usualEntry = usual[query.map(\.folded).joined(separator: " ")]
        return best.compactMap { id, found in
            guard found.level > 0 else { return nil }
            let e = Int(id)
            // Two names with the words exactly are as good as more: an entry
            // with more other names isn't the likelier one.
            return Ranked(entry: e, level: found.level, language: found.language, kinds: found.kinds.nonzeroBitCount,
                          isFood: entries[e].kind != "dish", strong: min(found.strong, 2), isPlain: found.plainest == 0,
                          isUsual: usualEntry == e, nameLength: found.shortest, gaps: found.gaps)
        }
    }

    /// How query words sit in one name, with their diacritics (`strict`,
    /// nil when one is missing so; `marked`: the query was typed with
    /// diacritics; `lenient`: any tone) and without (`folded`, for ties); nil
    /// when a word is missing either way.
    /// Bit masks of where each query word sits in a name, reused from name
    /// to name.
    struct Scratch {
        var masks: [UInt64]
        var strictMasks: [UInt64]
        var exact: [UInt64]

        init(count: Int) {
            masks = [UInt64](repeating: 0, count: count)
            strictMasks = masks
            exact = masks
        }
    }

    private func match(_ query: [QueryWord], _ key: Key, marked: Bool, lenient: Bool, scratch: inout Scratch)
        -> (strict: Found?, folded: Found)? {
        let n = query.count
        let m = key.words.count
        guard n <= m, m <= 64 else { return nil }
        var strictFound = true
        for (j, word) in query.enumerated() {
            var mask: UInt64 = 0
            var strictMask: UInt64 = 0
            var exactMask: UInt64 = 0
            // Without diacritics, in a phrase typed with them: the word as
            // written without any, or one that only exists with them.
            let bare = word.mark == -1 && marked && word.id >= 0 && plainVietnamese[Int(word.id)]
            for p in 0..<m {
                let id = key.words[p]
                guard word.ids.contains(id) else { continue }
                let bit = UInt64(1) << UInt64(p)
                if bare, key.marks[p] >= 0 { continue }
                mask |= bit
                // With diacritics: the same ones, unless `lenient` (a wrong
                // tone typed).
                if word.mark == -1 || lenient || key.marks[p] == word.mark { strictMask |= bit }
                if id == word.id { exactMask |= bit }
            }
            guard mask != 0 else { return nil }
            if strictMask == 0 { strictFound = false }
            scratch.masks[j] = mask
            scratch.strictMasks[j] = strictMask
            scratch.exact[j] = exactMask
        }
        guard let folded = arrange(scratch.masks, exact: scratch.exact, in: key) else { return nil }
        if folded.level == 5,
           (0..<n).allSatisfy({ scratch.strictMasks[$0] & (UInt64(1) << UInt64($0)) != 0 || key.marks[$0] < 0 }) {
            // The whole of a name written without diacritics ("banh mi" for
            // "bánh mì") is that name, as typed.
            return (folded, folded)
        }
        return (strictFound ? arrange(scratch.strictMasks, exact: scratch.exact, in: key) : nil, folded)
    }

    /// 5 the whole name, 4 together at its head, 3 together elsewhere or
    /// together in another order, 2 in order with words between, 1 in any
    /// order; nil when no word order fits.
    private func arrange(_ masks: [UInt64], exact: [UInt64], in key: Key) -> Found? {
        let n = masks.count
        let m = key.words.count
        func nonPlain(_ used: UInt64) -> Int {
            var count = 0
            for p in 0..<m where used & (UInt64(1) << UInt64(p)) == 0 && !plain.contains(key.words[p]) { count += 1 }
            return count
        }
        // Together in order.
        var together: (start: Int, head: Bool, exactly: Bool)?
        for s in 0...(m - n) {
            guard (0..<n).allSatisfy({ masks[$0] & (UInt64(1) << UInt64(s + $0)) != 0 }) else { continue }
            let head = key.head.holds(start: s, count: n, of: m)
            let exactly = (0..<n).allSatisfy { exact[$0] & (UInt64(1) << UInt64(s + $0)) != 0 }
            if together == nil || (head && together?.head == false) { together = (s, head, exactly) }
            if head { break }
        }
        if let together {
            let used = ((UInt64(1) << UInt64(n)) - 1) << UInt64(together.start)
            // Words only inside parentheses describe the food rather than
            // name it ("large pizza" in "Pepperoni pizza slice (large
            // pizza)"): no closer than words apart.
            let described = used & key.inParentheses == used
            let level = n == m ? 5 : described ? 2 : together.head ? 4 : 3
            return Found(level: level, together: !described, exactly: together.exactly, nonPlain: nonPlain(used),
                         gaps: described ? m : 0)
        }
        func assignable(_ window: UInt64) -> Bool {
            func assign(_ j: Int, _ used: UInt64) -> Bool {
                if j == n { return true }
                var options = masks[j] & window & ~used
                while options != 0 {
                    let bit = options & (~options &+ 1)
                    if assign(j + 1, used | bit) { return true }
                    options &= options - 1
                }
                return false
            }
            return assign(0, 0)
        }
        let all = masks.reduce(0, |)
        // Together in another order: "rice chicken" for "Chicken rice".
        if n >= 2, n <= 6 {
            let block = (UInt64(1) << UInt64(n)) - 1
            for s in 0...(m - n) where assignable(block << UInt64(s)) {
                return Found(level: 3, together: false, exactly: false, nonPlain: nonPlain(block << UInt64(s)))
            }
        }
        // In order, words between.
        var position = -1
        var inOrder = true
        for j in 0..<n {
            let above = position + 1 >= 64 ? 0 : masks[j] & (UInt64.max << UInt64(position + 1))
            guard above != 0 else {
                inOrder = false
                break
            }
            position = above.trailingZeroBitCount
        }
        if inOrder {
            let first = masks[0].trailingZeroBitCount
            return Found(level: 2, together: false, exactly: false, nonPlain: nonPlain(all), gaps: position - first + 1 - n)
        }
        guard n <= 8, assignable(UInt64.max) else { return nil }
        return Found(level: 1, together: false, exactly: false, nonPlain: nonPlain(all), gaps: m)
    }

    /// How a unit fits an entry, against a match level's 4: 2 its own kind
    /// of size word ("lon" for a can), 0 the same way of counting (a counted
    /// unit for a counted food, a container for one by amount) or no unit,
    /// -2 neither ("1 chai" of water by the glass). So a unit picks between
    /// names as good, and a fitting one equals a name one step better:
    /// "1 lon bia" is a can, "a bottle of water" still water. A bare count
    /// favors counted foods (1).
    func unitFit(_ entry: Int, unit: PhraseUnit?, bareCount: Bool) -> Int {
        guard let unit else { return bareCount && countable[entry] ? 1 : 0 }
        if unit.kind == .weight { return 0 }
        if unit.families & families[entry] != 0 { return 2 }
        switch (unit.kind, entries[entry].unit) {
        case (.counted, .piece), (.amount, .g): return 0
        // Pieces of a food by amount whose piece is known: "10 con tôm".
        case (.counted, .g) where pieceGrams[entry] != nil: return 0
        default: return -2
        }
    }
}
