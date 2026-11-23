//
//  QuickLogParser.swift
//  GymWorkout
//
//  Reads a short typed or spoken phrase into a log (2026-11-22): water
//  ("drank 500 ml", "2 glasses", "uống nửa lít", "1 chai nước"), a walk
//  ("walked 30 minutes", "5,000 steps", "đi bộ 2 km") or food ("chicken rice
//  650 kcal 40 g protein", "cơm gà 650 calo"). On the device, no AI: numbers
//  and a few words in English and Vietnamese. The user always confirms what
//  was read before it's logged.
//
//  A glass or cup counts 250 ml, a bottle 500 ml, unless the phrase gives
//  its size ("2 chai 500ml" is 1 L). A minute's walk is about 100 steps
//  (`WalkSuggestion`'s pace); a kilometre uses the stride of 41.5% of height.
//
//  Review fixes (2026-11-22): only plain digits are numbers ("nan", "inf"
//  and 20-digit strings are not) and every amount is capped, so nothing can
//  overflow; halves and simple fractions ("half a bottle", "1 và nửa lít",
//  "một phần tư lít", "an hour") with anything else fractional read as
//  nothing; "chất đạm"/"chất béo"/"chất bột đường" and "protein 40 g";
//  a time of day ("lúc 6 giờ", "6h sáng") is not walk time; oz and miles.
//

import Foundation

enum QuickLog: Hashable {
    case water(ml: Int)
    case steps(count: Int, minutes: Int?)
    case food(name: String, kcal: Int?, proteinG: Int?, fatG: Int?, carbsG: Int?)
}

enum QuickLogKind: Hashable {
    case water, steps, food
}

enum QuickLogParser {

    /// `kind`: what the sheet the phrase came from logs; nil reads it from
    /// the words. `heightCm` turns a distance into steps.
    static func parse(_ phrase: String, as kind: QuickLogKind? = nil, heightCm: Double = 170) -> QuickLog? {
        let text = normalize(phrase)
        guard !text.isEmpty else { return nil }
        let detected = kind ?? detect(text)
        switch detected {
        // "A fifth of a bottle": a fraction MUSQ can't read is no amount,
        // never a whole bottle.
        case .water: return hasUnreadFraction(text) ? nil : water(text)
        case .steps: return hasUnreadFraction(text) ? nil : steps(text, heightCm: heightCm)
        case .food: return food(text, original: phrase)
        }
    }

    // MARK: Kinds

    static func detect(_ text: String) -> QuickLogKind {
        let waterWords = ["water", "nước", "nuoc", "drank", "drink", "uống", "uong", "ml", "lít", "liter", "litre",
                          "glass", "glasses", "ly", "cốc", "chai", "bottle"]
        let stepWords = ["step", "steps", "bước", "buoc", "walk", "walked", "walking", "đi bộ", "di bo", "km",
                         "mile", "miles"]
        let foodWords = ["kcal", "calo", "calorie", "calories", "cal", "protein", "đạm", "ăn", "ate", "eat", "ăn sáng", "ăn trưa", "ăn tối"]
        let words = Set(text.split(whereSeparator: { !$0.isLetter && !$0.isNumber }).map(String.init))
        // Whole words, or the phrase for two-word ones ("đi bộ"), so "water"
        // doesn't read as "ate".
        func has(_ list: [String]) -> Bool {
            list.contains { $0.contains(" ") ? text.contains($0) : words.contains($0) }
        }
        if has(foodWords) { return .food }
        if has(stepWords) { return .steps }
        if has(waterWords) { return .water }
        return .food
    }

    /// Whether a normalized phrase names plain water and nothing else:
    /// "2 chai 500ml", "uống 1 ly nước lọc", "drank a glass of water",
    /// "500 ml". Juice, coffee, milk tea, soda or beer ("nước cam",
    /// "1 chai coca", "a glass of orange juice") are drinks to log as food.
    static func isPlainWater(_ text: String) -> Bool {
        let plain: Set<String> = [
            // the water itself
            "water", "nước", "nuoc", "lọc", "loc", "suối", "suoi", "khoáng", "khoang", "tinh", "khiết", "khiet",
            "đun", "dun", "sôi", "soi", "đá", "da", "ấm", "am", "lạnh", "lanh", "nóng", "nong", "plain", "still",
            "sparkling", "mineral", "tap", "filtered", "bottled", "cold", "warm", "hot", "ice", "iced",
            // filler
            "a", "an", "of", "the", "some", "just", "another", "more", "i", "had", "have", "drank", "drink",
            "drinking", "uống", "uong", "đã", "vừa", "vua", "mới", "moi", "tôi", "toi", "mình", "minh", "một",
            "mot", "thêm", "them", "nữa", "nua", "và", "va", "and", "half", "nửa", "rưỡi", "ruoi", "x", "about",
            "around", "khoảng", "each", "mỗi",
        ]
        let words = text.split(whereSeparator: { !$0.isLetter && !$0.isNumber }).map(String.init)
        return words.allSatisfy { word in
            amount(word) != nil || plain.contains(word) || millilitres(per: word) != nil || containerMl(word) != nil
        }
    }

    // MARK: Water

    /// Millilitres in one of `unit`: 1 for ml, 1,000 for a litre, 29.57 for
    /// a US fluid ounce; nil for any other word.
    static func millilitres(per unit: String) -> Double? {
        if ["ml", "mililit", "milliliter", "millilitre"].contains(where: { unit.hasPrefix($0) }) { return 1 }
        if ["l", "lít", "lit", "liter", "litre"].contains(unit) || ["lít", "liter", "litre"].contains(where: { unit.hasPrefix($0) }) {
            return 1_000
        }
        if ["oz", "ounce", "ounces", "fl"].contains(unit) { return 29.57 }
        return nil
    }

    /// A glass or cup's usual size, or a bottle's; nil for any other word.
    static func containerMl(_ word: String) -> Double? {
        if ["ly", "cốc", "coc", "glass", "glasses", "cup", "cups"].contains(word) { return 250 }
        if ["chai", "bottle", "bottles"].contains(word) { return 500 }
        return nil
    }

    static func water(_ text: String) -> QuickLog? {
        let parts = text.split(separator: " ").map(String.init)
        let numbers = numbered(parts)
        var used = Set<Int>()
        var total = 0.0
        // Words between a container and the size it's given: "1 chai nước
        // 500ml", "2 glasses of 300 ml", "2 chai x 500ml".
        let between: Set<String> = ["nước", "nuoc", "water", "of", "loại", "loai", "của", "cua", "x", "×", "lọc", "loc",
                                    "suối", "suoi", "khoáng", "khoang", "each", "mỗi"]
        for i in parts.indices {
            guard let usual = containerMl(parts[i]) else { continue }
            // How many: the number just before ("2 ly"), else one ("a glass",
            // "nửa chai" is already 0.5).
            var count = 1.0
            if i > 0, !used.contains(i - 1), let n = amount(parts[i - 1]) {
                count = n
                used.insert(i - 1)
            }
            // A size after it is one container's: "2 chai 500ml" is 1 L.
            var j = i + 1
            while j < parts.count, j - i <= 3, between.contains(parts[j]) { j += 1 }
            if j + 1 < parts.count, !used.contains(j), let size = amount(parts[j]), let per = millilitres(per: parts[j + 1]) {
                used.insert(j)
                total += count * size * per
                continue
            }
            // Or before it: "a 500 ml bottle", "2 x 500ml bottles".
            if i >= 2, !used.contains(i - 2), let per = millilitres(per: parts[i - 1]), let size = amount(parts[i - 2]) {
                used.insert(i - 2)
                var k = i - 3
                if k >= 0, ["x", "×"].contains(parts[k]) { k -= 1 }
                var times = 1.0
                if k >= 0, !used.contains(k), let n = amount(parts[k]) {
                    times = n
                    used.insert(k)
                }
                total += times * size * per
                continue
            }
            total += count * usual
        }
        for (i, value) in numbers where !used.contains(i) {
            let unit = i + 1 < parts.count ? parts[i + 1] : ""
            if let per = millilitres(per: unit) {
                total += value * per
            } else if unit.isEmpty, numbers.count == 1, total == 0 {
                // A bare number: under 10 reads as glasses, otherwise ml.
                total = value < 10 ? value * 250 : value
            }
        }
        let ml = total.rounded()
        guard ml >= 1, ml <= 5_000 else { return nil }
        return .water(ml: Int(ml))
    }

    // MARK: Steps

    static func steps(_ text: String, heightCm: Double) -> QuickLog? {
        let parts = text.split(separator: " ").map(String.init)
        let numbers = numbered(parts)
        let stepUnits = ["step", "steps", "bước", "buoc"]
        let minuteUnits: Set<String> = ["phút", "phut", "min", "mins", "minute", "minutes"]
        let hourUnits: Set<String> = ["giờ", "gio", "h", "hour", "hours", "hr", "hrs", "tiếng", "tieng"]
        let kmUnits = ["km", "kilomet", "kilometer", "kilometre", "kilometers", "kilometres"]
        let mileUnits: Set<String> = ["mi", "mile", "miles"]
        // Before a time of day: "lúc 6 giờ", "at 6h", "từ 6 giờ đến 7 giờ".
        let clockBefore: Set<String> = ["lúc", "luc", "vào", "vao", "từ", "tu", "đến", "den", "tới", "at", "from",
                                        "until", "till", "by", "since"]
        // After one: "6 giờ sáng", "6h chiều", "7 pm".
        let timeOfDay: Set<String> = ["sáng", "sang", "trưa", "trua", "chiều", "chieu", "tối", "toi", "đêm", "dem",
                                      "khuya", "am", "pm", "a.m", "p.m", "morning", "evening", "tonight"]
        let unitAfter = { (i: Int) in i + 1 < parts.count ? parts[i + 1] : "" }
        /// The minutes number joined to the hour at `i`: "1 giờ 30 phút",
        /// "1 hour and 30 minutes".
        func joinedMinutes(_ i: Int) -> Int? {
            var k = i + 2
            if k < parts.count, ["và", "va", "and"].contains(parts[k]) { k += 1 }
            guard k < parts.count, amount(parts[k]) != nil, minuteUnits.contains(unitAfter(k)) else { return nil }
            return k
        }
        let hasMinutes = numbers.contains { minuteUnits.contains(unitAfter($0.index)) }
        let strideCm = max(120, heightCm) * 0.415
        var count = 0.0
        var minutes = 0.0
        var skipped = Set<Int>()
        for (i, value) in numbers where !skipped.contains(i) {
            let unit = unitAfter(i)
            if stepUnits.contains(where: { unit.hasPrefix($0) }) {
                count += value
            } else if minuteUnits.contains(unit) {
                minutes += value
            } else if hourUnits.contains(unit) {
                let joined = joinedMinutes(i)
                let before = i > 0 ? parts[i - 1] : ""
                let after = i + 2 < parts.count ? parts[i + 2] : ""
                let afterJoined = joined.map { $0 + 2 < parts.count ? parts[$0 + 2] : "" } ?? ""
                if clockBefore.contains(before) || timeOfDay.contains(after) || timeOfDay.contains(afterJoined) {
                    // A time of day, minutes and all ("lúc 6 giờ 30 phút").
                    if let joined { skipped.insert(joined) }
                    continue
                }
                // With minutes in the phrase too, an hour counts only joined
                // to them.
                if hasMinutes, joined == nil { continue }
                minutes += value * 60
            } else if kmUnits.contains(where: { unit.hasPrefix($0) }) {
                count += value * 100_000 / strideCm
            } else if mileUnits.contains(unit) {
                count += value * 160_934 / strideCm
            }
        }
        if count == 0, minutes > 0 { count = minutes * 100 }
        let steps = count.rounded()
        guard steps >= 1, steps <= 100_000 else { return nil }
        let wholeMinutes = minutes.rounded()
        return .steps(count: Int(steps), minutes: wholeMinutes >= 1 && wholeMinutes <= 100_000 ? Int(wholeMinutes) : nil)
    }

    // MARK: Food

    private enum Macro { case protein, fat, carbs }

    /// The macro the word at `i` names. "Chất" ("substance") comes before
    /// all three on Vietnamese labels, so it names none; "tinh" only as
    /// "tinh bột".
    private static func macro(at i: Int, in parts: [String]) -> Macro? {
        guard parts.indices.contains(i) else { return nil }
        switch parts[i] {
        case "protein", "proteins", "pro", "đạm", "dam": return .protein
        case "fat", "fats", "béo", "beo": return .fat
        case "carb", "carbs", "carbohydrate", "carbohydrates", "bột", "bot", "đường", "duong": return .carbs
        case "tinh": return i + 1 < parts.count && ["bột", "bot"].contains(parts[i + 1]) ? .carbs : nil
        default: return nil
        }
    }

    static func food(_ text: String, original: String) -> QuickLog? {
        let parts = text.split(separator: " ").map(String.init)
        let kcalUnits: Set<String> = ["kcal", "kcals", "calo", "calories", "calorie", "cal"]
        let gramUnits: Set<String> = ["g", "gam", "gram", "grams", "gr"]
        let joiners: Set<String> = ["and", "và", "va"]
        var kcal: Int?
        var grams: [Macro: Int] = [:]
        var used = Set<Int>()
        // Where the amounts begin: the name is the words before.
        var start = parts.count
        /// Digits, even too many to read: "12345678901234567890 kcal" is no
        /// name, and no calories either.
        func isNumber(_ i: Int) -> Bool {
            parts.indices.contains(i) && parts[i].first.map { ("0"..."9").contains($0) } == true
                && parts[i].allSatisfy { $0 == "." || ("0"..."9").contains($0) }
        }

        for i in parts.indices where isNumber(i) && i + 1 < parts.count && kcalUnits.contains(parts[i + 1]) {
            used.insert(i)
            start = min(start, i)
            if let value = amount(parts[i]), value <= 10_000 { kcal = Int(value.rounded()) }
        }

        /// A macro's grams said first: "40 g protein", "30 g chất đạm",
        /// "40 grams of protein", "40 protein".
        func numberBefore(_ m: Int) -> Int? {
            var k = m - 1
            while k >= 0, m - k <= 2, ["of", "của", "cua", "chất", "chat"].contains(parts[k]) { k -= 1 }
            if k >= 1, gramUnits.contains(parts[k]), isNumber(k - 1) { return k - 1 }
            // No unit: only when the macro ends the amount ("40 protein",
            // "40 protein 20 fat"), so "1 protein bar" isn't 1 g.
            guard k >= 0, isNumber(k) else { return nil }
            let next = m + 1 < parts.count ? parts[m + 1] : ""
            let ends = next.isEmpty || isNumber(m + 1) || macro(at: m + 1, in: parts) != nil || joiners.contains(next)
            return ends ? k : nil
        }
        /// Or the name first: "protein 40 g", "chất béo 10g", "đạm 30".
        func numberAfter(_ m: Int) -> Int? {
            let k = m + 1
            guard isNumber(k) else { return nil }
            let unit = k + 1 < parts.count ? parts[k + 1] : ""
            let fits = gramUnits.contains(unit) || unit.isEmpty || macro(at: k + 1, in: parts) != nil || joiners.contains(unit)
            return fits ? k : nil
        }
        for m in parts.indices {
            guard let kind = macro(at: m, in: parts) else { continue }
            if let i = numberBefore(m), !used.contains(i) {
                used.insert(i)
                start = min(start, i)
                if let value = amount(parts[i]), value <= 1_000 { grams[kind] = Int(value.rounded()) }
            } else if let i = numberAfter(m), !used.contains(i) {
                used.insert(i)
                // The name stops at the macro's words: "chất bột đường 50 g".
                var first = m
                while first > 0, ["chất", "chat"].contains(parts[first - 1]) || macro(at: first - 1, in: parts) == kind {
                    first -= 1
                }
                start = min(start, first)
                if let value = amount(parts[i]), value <= 1_000 { grams[kind] = Int(value.rounded()) }
            }
        }

        // The name: the words before the amounts, minus filler at the start
        // ("1 ly trà sữa" names "Ly trà sữa"), as typed when it can be found.
        let filler: Set<String> = ["i", "ate", "had", "eat", "an", "ăn", "đã", "da", "tôi", "toi", "mình", "minh", "a", "một", "mot",
                                   "with", "và", "va", "and", "of", "khoảng", "khoang", "about", "around", "1", "uống", "uong",
                                   "drank", "drink"]
        var nameWords = Array(parts[..<start])
        while let first = nameWords.first, filler.contains(first) { nameWords.removeFirst() }
        if !nameWords.contains(where: { $0.contains(where: \.isLetter) }) { nameWords = [] }
        var name = nameWords.joined(separator: " ")
        if !name.isEmpty, let range = original.range(of: name, options: .caseInsensitive) {
            name = String(original[range])
        }
        if name.isEmpty { name = String(localized: "Meal", comment: "Quick food log: default name") }
        let protein = grams[.protein]
        guard kcal != nil || protein != nil || !nameWords.isEmpty else { return nil }
        return .food(name: name.prefix(1).uppercased() + name.dropFirst(), kcal: kcal, proteinG: protein,
                     fatG: grams[.fat], carbsG: grams[.carbs])
    }

    // MARK: Numbers

    /// A plain decimal number ("500", "1.5"), finite and under a million;
    /// nil for any other word, "nan", "inf" and 20-digit strings included,
    /// so every amount read fits an `Int`.
    static func amount(_ word: String) -> Double? {
        let pieces = word.split(separator: ".", omittingEmptySubsequences: false)
        guard (1...2).contains(pieces.count), pieces[0].count <= 7,
              pieces.allSatisfy({ !$0.isEmpty && $0.allSatisfy { ("0"..."9").contains($0) } }),
              let value = Double(word), value.isFinite, value < 1_000_000 else { return nil }
        return value
    }

    /// Each number in the words with its place.
    static func numbered(_ parts: [String]) -> [(index: Int, value: Double)] {
        parts.indices.compactMap { i in amount(parts[i]).map { (i, $0) } }
    }

    /// A number written back into the words: "5000", "1.5", "0.25".
    private static func written(_ value: Double) -> String {
        guard value.isFinite, value >= 0, value < 1e12 else { return "many" }
        return value == value.rounded() ? String(Int(value)) : String(value)
    }

    /// Units a half, a fraction or "a"/"an" can measure.
    private static let measureUnits: Set<String> = [
        "ly", "cốc", "coc", "glass", "glasses", "cup", "cups", "chai", "bottle", "bottles",
        "ml", "l", "lít", "lit", "liter", "liters", "litre", "litres", "oz", "ounce", "ounces",
        "giờ", "gio", "h", "hour", "hours", "hr", "hrs", "tiếng", "tieng", "phút", "phut", "min", "mins", "minute", "minutes",
        "km", "kilomet", "kilometer", "kilometers", "kilometre", "kilometres", "mi", "mile", "miles",
    ]

    private static let numberWords: [String: String] = [
        "một": "1", "hai": "2", "ba": "3", "bốn": "4", "tư": "4", "năm": "5", "sáu": "6", "bảy": "7", "tám": "8", "chín": "9", "mười": "10",
        "one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9", "ten": "10",
    ]

    /// Whether a fraction is left that `normalize` couldn't read ("a fifth
    /// of a bottle", "một phần năm lít").
    private static func hasUnreadFraction(_ text: String) -> Bool {
        let parts = text.split(separator: " ").map(String.init)
        let fractions: Set<String> = ["half", "nửa", "third", "thirds", "quarter", "quarters", "fifth", "fifths", "sixth", "sixths",
                                      "eighth", "eighths", "tenth", "tenths"]
        for (i, word) in parts.enumerated() {
            if fractions.contains(word), parts[(i + 1)...].prefix(3).contains(where: measureUnits.contains) { return true }
            if ["phần", "phan"].contains(word), i + 1 < parts.count,
               numberWords[parts[i + 1]] != nil || amount(parts[i + 1]) != nil {
                return true
            }
        }
        return false
    }

    /// Lower-cased, single spaces, punctuation off each word, "5.000"/"5,000"
    /// thousands joined, "2,5" as 2.5, number words read ("hai ly", "two
    /// glasses", "nghìn"), and halves and simple fractions as numbers
    /// ("nửa lít" → 0.5 lít, "one and a half liters" → 1.5 liters, "an hour"
    /// → 1 hour, "một phần tư lít" → 0.25 lít).
    static func normalize(_ phrase: String) -> String {
        var text = phrase.lowercased()
            .replacingOccurrences(of: "\u{00A0}", with: " ")
        // Thousands separators: 5.000 / 5,000 / 12.500 → 5000.
        text = text.replacingOccurrences(of: #"(\d{1,3})[.,](\d{3})(?!\d)"#, with: "$1$2", options: .regularExpression)
        // Decimal comma: 2,5 → 2.5
        text = text.replacingOccurrences(of: #"(\d),(\d)"#, with: "$1.$2", options: .regularExpression)
        // Glue units: 500ml → 500 ml, 2l → 2 l, 650kcal → 650 kcal.
        text = text.replacingOccurrences(of: #"(\d)([a-zà-ỹ]+)"#, with: "$1 $2", options: .regularExpression)
        let parts = text.split(whereSeparator: \.isWhitespace)
            .map { $0.trimmingCharacters(in: .punctuationCharacters) }
            .filter { !$0.isEmpty }

        // Numbers.
        var out: [String] = []
        for (i, part) in parts.enumerated() {
            // "5 nghìn", "5k" → 5000
            if ["nghìn", "ngàn", "nghin", "ngan", "thousand", "k"].contains(part), let last = out.last, let value = amount(last) {
                out[out.count - 1] = written(value * 1_000); continue
            }
            // "1 lít rưỡi", "1 tiếng rưỡi", "một rưỡi" → 1.5
            if part == "rưỡi" || part == "ruoi" {
                if let last = out.last, let value = amount(last) {
                    out[out.count - 1] = written(value + 0.5); continue
                }
                if out.count >= 2, let value = amount(out[out.count - 2]) {
                    out[out.count - 2] = written(value + 0.5); continue
                }
                // "chai rưỡi" → 1.5 chai
                if let last = out.last, measureUnits.contains(last) {
                    out.insert("1.5", at: out.count - 1); continue
                }
            }
            // "1/2 lít" → 0.5 lít
            let halves = part.split(separator: "/")
            if halves.count == 2, let top = amount(String(halves[0])), let bottom = amount(String(halves[1])),
               (2...10).contains(bottom), top < bottom * 10 {
                out.append(written(top / bottom)); continue
            }
            // A number word only before another word, so "ba" ending a food
            // name stays, and never the "tư" of "một phần tư" (a quarter).
            if let mapped = numberWords[part], i + 1 < parts.count, !(i > 0 && ["phần", "phan"].contains(parts[i - 1])) {
                out.append(mapped); continue
            }
            out.append(part)
        }

        // "an hour", "a litre", "a mile" → 1. Not "a glass": a glass with no
        // number already counts one.
        let articleUnits: Set<String> = ["hour", "hr", "liter", "litre", "mile", "km", "kilometer", "kilometre"]
        for i in out.indices where ["a", "an"].contains(out[i]) && i + 1 < out.count && articleUnits.contains(out[i + 1]) {
            out[i] = "1"
        }

        // Halves and fractions.
        var result: [String] = []
        var i = 0
        while i < out.count {
            let word = out[i]
            if ["half", "nửa", "nua"].contains(word) {
                // "1 and a half liters", "1 lít và nửa", "an hour and a half" → 1.5
                var back = result.count
                if back > 0, result[back - 1] == "a" { back -= 1 }
                if back > 0, ["and", "và", "va"].contains(result[back - 1]) {
                    var head = Array(result[..<(back - 1)])
                    if let last = head.last, let value = amount(last) {
                        head[head.count - 1] = written(value + 0.5)
                        result = head; i += 1; continue
                    }
                    // "a bottle and a half" → 1.5 bottle
                    if let last = head.last, measureUnits.contains(last) {
                        let unit = head.count - 1
                        if unit > 0, let value = amount(head[unit - 1]) {
                            head[unit - 1] = written(value + 0.5)
                        } else if unit > 0, ["a", "an"].contains(head[unit - 1]) {
                            head[unit - 1] = "1.5"
                        } else {
                            head.insert("1.5", at: unit)
                        }
                        result = head; i += 1; continue
                    }
                }
                // "half a glass", "nửa chai", "half an hour", "half of a bottle",
                // "nửa tiếng" → 0.5 of it
                var next = i + 1
                if next < out.count, out[next] == "of" { next += 1 }
                if next < out.count, ["a", "an", "1", "một", "mot"].contains(out[next]) { next += 1 }
                if next < out.count, measureUnits.contains(out[next]) {
                    result.append("0.5"); i = next; continue
                }
            }
            if let bottom = ["quarter": 4.0, "quarters": 4, "third": 3, "thirds": 3][word] {
                // "a quarter liter", "three quarters of a liter" → 0.25, 0.75
                var head = result
                var top = 1.0
                if let last = head.last, let value = amount(last) {
                    top = value; head.removeLast()
                } else if let last = head.last, ["a", "an"].contains(last) {
                    head.removeLast()
                }
                var next = i + 1
                if next < out.count, out[next] == "of" { next += 1 }
                if next < out.count, ["a", "an", "1"].contains(out[next]) { next += 1 }
                if next < out.count, measureUnits.contains(out[next]) {
                    result = head
                    result.append(written(top / bottom)); i = next; continue
                }
            }
            if ["phần", "phan"].contains(word), let last = result.last, let top = amount(last), i + 2 < out.count,
               let bottom = ["hai": 2.0, "ba": 3, "tư": 4, "tu": 4, "bốn": 4, "bon": 4][out[i + 1]],
               measureUnits.contains(out[i + 2]) {
                // "một phần tư lít" → 0.25 lít
                result[result.count - 1] = written(top / bottom); i += 2; continue
            }
            result.append(word)
            i += 1
        }
        return result.joined(separator: " ")
    }
}
