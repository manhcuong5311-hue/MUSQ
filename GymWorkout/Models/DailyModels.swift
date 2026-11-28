//
//  DailyModels.swift
//  GymWorkout
//
//  What the Today tab logs beside the workouts (2026-11-21): glasses of
//  water, weigh-ins and the reminders for both. Kept in their own file
//  (`DailyStore`), apart from the workout history.
//

import Foundation

/// Water drunk at a moment, in millilitres.
struct WaterEntry: Codable, Hashable, Identifiable {
    var id = UUID()
    var date: Date
    var ml: Int
}

/// A weigh-in, always stored in kilograms.
struct WeightEntry: Codable, Hashable, Identifiable {
    var id = UUID()
    var date: Date
    var kg: Double
}

/// Water reminders: every few hours between two hours of the day, never
/// while asleep, and none left for the day once its target is reached.
struct WaterReminder: Codable, Hashable {
    var isOn = false
    /// Hours of the day, 0-23.
    var startHour = 8
    var endHour = 20
    var everyHours = 2

    /// The hours a reminder goes off: 8, 10, … 20.
    var hours: [Int] {
        guard everyHours > 0, endHour >= startHour else { return [] }
        return Array(stride(from: startHour, through: endHour, by: everyHours))
    }
}

/// A daily reminder to step on the scale.
struct WeighInReminder: Codable, Hashable {
    var isOn = false
    var hour = 7
    var minute = 0
}

/// A logged meal (2026-11-21): what was eaten and its estimated energy and
/// macros, usually from a Premium photo scan the member checked and could
/// correct before saving.
///
/// Everything added since the first build is optional, and a meal saved
/// before `source` (2026-11-22) reads as a scan: the synthesized decoder
/// throws on a missing key even when the property has a default, and
/// DailyStore then moves the whole daily.json aside as unreadable.
struct MealEntry: Codable, Hashable, Identifiable {
    struct Item: Codable, Hashable, Identifiable {
        /// Grams of what a photo can't show in the logged amount: added fat,
        /// added sugar, sauces and dips.
        struct Hidden: Codable, Hashable {
            var oil: Double?
            var sugar: Double?
            var sauce: Double?
        }

        var id = UUID()
        var name: String
        /// 0 when no weight is known (a typed meal, or a scan that gave a
        /// count but no grams).
        var grams: Int
        var kcal: Int
        var proteinG: Int
        var fatG: Int
        var carbsG: Int
        // The food table round (2026-11-22); nil in older and typed meals,
        // and read leniently (see `init(from:)`).
        /// The food table entry ("vn.pho_bo_tai").
        var ref: String?
        /// "table" (the food table's numbers), "estimate" (the AI's own) or,
        /// from the meal editor (2026-11-22), "manual" (typed in by hand;
        /// nil in typed meals from before).
        var basis: String?
        /// How the member set the amount: "piece" (counted, by the piece or,
        /// with no weight known, by the portion the scan read) or "g".
        var unit: String?
        /// Pieces, for a counted food.
        var count: Double?
        /// What the scan sent, before the member's edits: for a table food
        /// the table's numbers at the grams it read.
        var aiGrams: Int?
        var aiKcal: Int?
        /// For a table food, the AI model's own grams and kcal, beside the
        /// table's (from 2026-11-22; nil before, and for an estimate, whose
        /// numbers are the model's).
        var modelGrams: Int?
        var modelKcal: Int?
        var hidden: Hidden?
        /// The scan's words for a food it counted by the portion with no
        /// weight ("1 glass", "2 servings"), so it opens in the meal editor
        /// as it was read, not as pieces (2026-11-23); nil for any other
        /// food, and in older meals.
        var portion: String?
        /// The energy and macros of the amount logged before rounding, for
        /// a food whose numbers scale from what it came with (an estimate, a
        /// food typed in by hand): the editor scales from them, so edits
        /// never drift (2026-11-23). Nil for a table food (the table's
        /// numbers) and in older meals.
        var exact: Exact?

        struct Exact: Codable, Hashable {
            var kcal: Double
            var proteinG: Double
            var fatG: Double
            var carbsG: Double
        }
    }

    enum Source: String, Codable { case photo, manual }

    var id = UUID()
    var date: Date
    var title: String
    var items: [Item]
    var source: Source = .photo
    /// The scan's "high", "medium" or "low".
    var confidence: String?
    /// The AI's note on its main assumption ("Assumed a little oil.").
    var aiNote: String?
    /// The note the member gave the scan ("Stir-fried, Little oil").
    var memberNote: String?

    var kcal: Int { items.reduce(0) { $0 + $1.kcal } }
    var proteinG: Int { items.reduce(0) { $0 + $1.proteinG } }
    var fatG: Int { items.reduce(0) { $0 + $1.fatG } }
    var carbsG: Int { items.reduce(0) { $0 + $1.carbsG } }

    /// Whether the meal's protein, fat and carbs mean something: some food
    /// of it has them (`Item.carriesMacros`). A scanned meal edited down to
    /// foods typed in by hand without macros (2026-11-23) has none, and a
    /// typed meal of table foods has the table's.
    var carriesMacros: Bool { items.contains { $0.carriesMacros(in: source) } }
}

extension MealEntry.Item {
    /// Whether its protein, fat and carbs mean something: a scan's or a
    /// table food's always (0 g is what it has), a food typed in by hand's
    /// only when any was given. A typed meal's food from before the table
    /// round (no basis, no entry) was typed in by hand; a food of the first
    /// scans (none either, in a scanned meal) is a scan's.
    func carriesMacros(in source: MealEntry.Source) -> Bool {
        if proteinG + fatG + carbsG > 0 { return true }
        switch basis {
        case "manual": return false
        case "table", "estimate": return true
        case nil: return ref != nil || source == .photo
        default: return ref != nil
        }
    }
}

extension MealEntry {
    /// Written out for `source`, which meals from the first scans
    /// (2026-11-21) don't have, and which a later build may give values
    /// this one doesn't know; in an extension, so the memberwise
    /// initializer stays. Strict about what the meal needs (its id, date,
    /// title and items), lenient about the rest: the notes and confidence
    /// of another type read as nil.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        title = try container.decode(String.self, forKey: .title)
        items = try container.decode([Item].self, forKey: .items)
        source = Self.source(in: container)
        confidence = (try? container.decodeIfPresent(String.self, forKey: .confidence)) ?? nil
        aiNote = (try? container.decodeIfPresent(String.self, forKey: .aiNote)) ?? nil
        memberNote = (try? container.decodeIfPresent(String.self, forKey: .memberNote)) ?? nil
    }

    /// Where a saved meal came from, never failing the meal: none (or null)
    /// is a scan, as the meals from before `source` are; a value this build
    /// doesn't know (a later build's "voice") or of another type reads as
    /// typed in, which claims no macros it may not have.
    private static func source(in container: KeyedDecodingContainer<CodingKeys>) -> Source {
        guard container.contains(.source), (try? container.decodeNil(forKey: .source)) != true else { return .photo }
        guard let raw = try? container.decode(String.self, forKey: .source) else { return .manual }
        return Source(rawValue: raw) ?? .manual
    }
}

extension MealEntry.Item {
    /// Strict about what a meal's totals need (the id, name, grams, kcal and
    /// macros), lenient about the food table round's fields, which are kept
    /// for reference only: a value of another type (a decimal where a whole
    /// number was saved, a later build's shape) reads as nil instead of
    /// failing the meal, and with it the whole daily.json. Numbers read as
    /// whole or decimal either way. In an extension, so the memberwise
    /// initializer stays.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        grams = try container.decode(Int.self, forKey: .grams)
        kcal = try container.decode(Int.self, forKey: .kcal)
        proteinG = try container.decode(Int.self, forKey: .proteinG)
        fatG = try container.decode(Int.self, forKey: .fatG)
        carbsG = try container.decode(Int.self, forKey: .carbsG)
        ref = Self.lenient(String.self, container, .ref)
        basis = Self.lenient(String.self, container, .basis)
        unit = Self.lenient(String.self, container, .unit)
        count = Self.lenient(Double.self, container, .count)
        aiGrams = Self.wholeNumber(container, .aiGrams)
        aiKcal = Self.wholeNumber(container, .aiKcal)
        modelGrams = Self.wholeNumber(container, .modelGrams)
        modelKcal = Self.wholeNumber(container, .modelKcal)
        hidden = Self.lenient(Hidden.self, container, .hidden)
        portion = Self.lenient(String.self, container, .portion)
        exact = Self.lenient(Exact.self, container, .exact)
    }

    private static func lenient<Value: Decodable>(_ type: Value.Type, _ container: KeyedDecodingContainer<CodingKeys>,
                                                   _ key: CodingKeys) -> Value? {
        try? container.decodeIfPresent(type, forKey: key)
    }

    /// A whole number, or a decimal rounded to one; nil for anything else.
    private static func wholeNumber(_ container: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys) -> Int? {
        if let whole = lenient(Int.self, container, key) { return whole }
        guard let decimal = lenient(Double.self, container, key), decimal.isFinite,
              abs(decimal) < Double(Int32.max) else { return nil }
        return Int(decimal.rounded())
    }
}

#if DEBUG
extension MealEntry {
    /// Meals saved by older builds must still read, or DailyStore moves the
    /// whole daily.json aside: one from the first scans (no `source`, none
    /// of the table round's fields), a typed one, a new one with every
    /// field, encoded and read back, one whose table-round fields have
    /// other types (as a later build might save them), and ones with a
    /// source this build doesn't know, which must all still read while a
    /// missing kcal must not. Returns what failed, nothing when all held.
    /// Run once per launch from Today (`TodayMealsSection`).
    static func selfTest() -> [String] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        var failures: [String] = []

        let firstScan = """
        {"date": "2026-11-21T15:59:45Z", "id": "BDD36B05-D0F2-4EE9-9B10-C35607708B74", "title": "Chicken rice bowl",
         "items": [{"carbsG": 0, "fatG": 15, "grams": 150, "id": "A1D46252-72FF-415B-A8D5-36C1A212207B", "kcal": 290,
                    "name": "Grilled chicken thigh", "proteinG": 38},
                   {"carbsG": 71, "fatG": 1, "grams": 250, "id": "C4CC577B-F437-451F-8626-3A45C7D8AFCA", "kcal": 325,
                    "name": "Steamed white rice", "proteinG": 6}]}
        """
        do {
            let meal = try decoder.decode(MealEntry.self, from: Data(firstScan.utf8))
            if meal.source != .photo { failures.append("a meal saved without a source isn't a scan") }
            if meal.kcal != 615 || meal.items.count != 2 { failures.append("a meal from the first scans read wrong") }
            if meal.confidence != nil || meal.memberNote != nil || meal.items.contains(where: { $0.ref != nil || $0.count != nil || $0.aiKcal != nil }) {
                failures.append("a meal from the first scans gained fields")
            }
        } catch {
            failures.append("a meal from the first scans doesn't read: \(error)")
        }

        let typed = """
        {"date": "2026-11-22T01:30:00Z", "id": "453EFC4D-53FD-475D-B5C2-C7A718626567", "source": "manual", "title": "Phở bò",
         "items": [{"carbsG": 58, "fatG": 12, "grams": 0, "id": "587F5062-AE7B-4F6E-8ED0-405A8355DDE9", "kcal": 450,
                    "name": "Phở bò", "proteinG": 28}]}
        """
        do {
            let meal = try decoder.decode(MealEntry.self, from: Data(typed.utf8))
            if meal.source != .manual || meal.kcal != 450 { failures.append("a typed meal read wrong") }
        } catch {
            failures.append("a typed meal doesn't read: \(error)")
        }

        let scanned = MealEntry(
            date: Date(timeIntervalSince1970: 1_795_000_000), title: "Beef pho breakfast",
            items: [Item(name: "Phở bò tái", grams: 450, kcal: 318, proteinG: 21, fatG: 5, carbsG: 48,
                         ref: "vn.pho_bo_tai", basis: "table", unit: "g", aiGrams: 674, aiKcal: 477,
                         modelGrams: 674, modelKcal: 450, hidden: Item.Hidden(oil: 2.3, sugar: 1.4)),
                    Item(name: "Trứng luộc", grams: 125, kcal: 194, proteinG: 16, fatG: 13, carbsG: 1,
                         ref: "egg_boiled", basis: "table", unit: "piece", count: 2.5, aiGrams: 100, aiKcal: 155,
                         modelGrams: 110, modelKcal: 170),
                    Item(name: "Bánh quẩy", grams: 0, kcal: 345, proteinG: 6, fatG: 18, carbsG: 41,
                         basis: "estimate", unit: "piece", count: 3, aiGrams: 0, aiKcal: 230),
                    Item(name: "Trà chanh", grams: 350, kcal: 105, proteinG: 0, fatG: 0, carbsG: 26,
                         basis: "estimate", unit: "g", aiGrams: 350, aiKcal: 105)],
            confidence: "medium", aiNote: "Assumed a standard street bowl.", memberNote: "Little oil")
        do {
            let back = try decoder.decode(MealEntry.self, from: encoder.encode(scanned))
            if back != scanned { failures.append("a scanned meal changed on its way through JSON") }
        } catch {
            failures.append("a scanned meal doesn't round-trip: \(error)")
        }

        // The table round's fields in other types: decimals read rounded,
        // anything else as nil, and the meal still reads whole.
        let otherTypes = """
        {"date": "2026-11-22T12:00:00Z", "id": "7C1E0B6A-3F55-4A55-9A0B-1F2E3D4C5B6A", "source": "photo", "title": "Lunch",
         "items": [{"carbsG": 72, "fatG": 14, "grams": 674, "id": "0E5C2B41-9D3A-4C1E-8F7B-6A5D4C3B2A10", "kcal": 477,
                    "name": "Phở bò tái", "proteinG": 31, "ref": "vn.pho_bo_tai", "basis": "table", "unit": "g",
                    "aiGrams": 100.5, "aiKcal": "lots", "modelGrams": 620.4, "modelKcal": 450, "count": "two",
                    "hidden": "oil"},
                   {"carbsG": 1, "fatG": 11, "grams": 100, "id": "5B4A3C2D-1E0F-4A9B-8C7D-6E5F4A3B2C1D", "kcal": 155,
                    "name": "Trứng luộc", "proteinG": 13, "unit": 5, "count": 2, "basis": null,
                    "hidden": {"oil": "some", "sugar": 0.4}}]}
        """
        do {
            let meal = try decoder.decode(MealEntry.self, from: Data(otherTypes.utf8))
            let pho = meal.items[0], egg = meal.items[1]
            if meal.kcal != 632 || pho.grams != 674 { failures.append("a meal with other types read wrong totals") }
            if pho.aiGrams != 101 || pho.modelGrams != 620 || pho.modelKcal != 450 {
                failures.append("decimal table-round numbers didn't read rounded")
            }
            if pho.aiKcal != nil || pho.count != nil || pho.hidden != nil || pho.ref != "vn.pho_bo_tai" || pho.unit != "g" {
                failures.append("table-round fields of other types didn't read as nil")
            }
            if egg.unit != nil || egg.count != 2 || egg.basis != nil || egg.hidden != nil {
                failures.append("a counted item with other types read wrong")
            }
        } catch {
            failures.append("a meal with other types in the table-round fields doesn't read: \(error)")
        }

        // A source a later build saved ("voice"), ones of other types (a
        // number, an object), a null and the two this build knows: the meal
        // still reads, as typed in for anything unknown and as a scan for
        // the null; notes and confidence of another type read as nil.
        for (source, expected) in [("\"voice\"", Source.manual), ("5", .manual), ("{\"kind\": \"photo\"}", .manual),
                                   ("null", .photo), ("\"photo\"", .photo), ("\"manual\"", .manual)] {
            let laterSource = """
            {"date": "2026-11-23T08:00:00Z", "id": "9D8C7B6A-5F4E-4D3C-8B2A-1F0E9D8C7B6A", "title": "Breakfast",
             "source": \(source), "confidence": 0.8, "aiNote": ["two"], "memberNote": "Little oil",
             "items": [{"carbsG": 30, "fatG": 5, "grams": 0, "id": "8C7B6A5F-4E3D-4C2B-9A1F-0E9D8C7B6A5F", "kcal": 200,
                        "name": "Oatmeal", "proteinG": 6}]}
            """
            do {
                let meal = try decoder.decode(MealEntry.self, from: Data(laterSource.utf8))
                if meal.source != expected || meal.kcal != 200 {
                    failures.append("a meal with source \(source) read as \(meal.source), \(meal.kcal) kcal")
                }
                if meal.confidence != nil || meal.aiNote != nil || meal.memberNote != "Little oil" {
                    failures.append("notes or confidence of another type didn't read as nil")
                }
            } catch {
                failures.append("a meal with source \(source) doesn't read: \(error)")
            }
        }

        // What the totals need stays strict.
        let noKcal = """
        {"date": "2026-11-22T12:00:00Z", "id": "2A3B4C5D-6E7F-4A8B-9C0D-1E2F3A4B5C6D", "title": "Snack",
         "items": [{"carbsG": 20, "fatG": 1, "grams": 100, "id": "3B4C5D6E-7F8A-4B9C-8D1E-2F3A4B5C6D7E",
                    "name": "Banana", "proteinG": 1}]}
        """
        if (try? decoder.decode(MealEntry.self, from: Data(noKcal.utf8))) != nil {
            failures.append("an item without kcal read")
        }
        return failures
    }
}
#endif

extension WeightUnit {
    /// A body weight to a tenth of the unit shown — rounded after converting,
    /// so 150.0 lb logged reads 150.0 lb, not 149.9. The unit is in the
    /// localized string, joined to the number by a no-break space.
    func bodyWeight(_ kg: Double) -> String {
        let value = (fromKilograms(kg) * 10).rounded() / 10
        let number = value.formatted(.number.precision(.fractionLength(0...1)))
        switch self {
        case .kg: return String(localized: "\(number)\u{00A0}kg", comment: "A body weight: 74.2 kg (keep the no-break space)")
        case .lb: return String(localized: "\(number)\u{00A0}lb", comment: "A body weight: 163.6 lb (keep the no-break space)")
        }
    }
}

// MARK: - Balance check-ins and quick logs (2026-11-22)

/// A calendar day as "yyyy-MM-dd" in the current time zone, for logs that
/// belong to a day rather than a moment (check-ins, sleep estimates, paused
/// weeks): a check-in made on the 22nd in Hanoi is still the 22nd's after a
/// flight to London. Gregorian digits whatever the calendar setting, so the
/// key reads the same under a Buddhist or Japanese calendar.
enum DayKey {
    static func make(_ date: Date, calendar: Calendar = .current) -> String {
        let parts = gregorian(calendar).dateComponents([.year, .month, .day], from: date)
        return "\(padded(parts.year ?? 0, 4))-\(padded(parts.month ?? 0, 2))-\(padded(parts.day ?? 0, 2))"
    }

    /// The start of the key's day in the current time zone; nil for
    /// anything that isn't a key.
    static func date(_ key: String, calendar: Calendar = .current) -> Date? {
        let parts = key.split(separator: "-")
        guard key.count == 10, parts.count == 3,
              let year = Int(parts[0]), let month = Int(parts[1]), let day = Int(parts[2]) else { return nil }
        return gregorian(calendar).date(from: DateComponents(year: year, month: month, day: day))
    }

    /// A key as saved, or an instant saved before keys (an ISO 8601 date
    /// from the first builds of 2026-11-22) turned into its day's key.
    static func normalized(_ raw: String, calendar: Calendar = .current) -> String {
        if date(raw, calendar: calendar) != nil { return raw }
        if let instant = ISO8601DateFormatter().date(from: raw) { return make(instant, calendar: calendar) }
        return raw
    }

    private static func gregorian(_ calendar: Calendar) -> Calendar {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = calendar.timeZone
        return gregorian
    }

    private static func padded(_ value: Int, _ width: Int) -> String {
        let digits = String(value)
        return String(repeating: "0", count: max(0, width - digits.count)) + digits
    }
}

/// The evening two-tap eating check-in, for whatever a meal log doesn't
/// cover: how protein went and how eating compared with the plan. Entered by the user;
/// not Apple Health data. A question the sheet didn't ask (protein with
/// kidney disease, the plan with calories hidden) stays nil, so it never
/// counts as an answer if that setting changes later.
struct EatCheckIn: Codable, Hashable, Identifiable {
    enum Protein: String, Codable, CaseIterable, Identifiable {
        case hit, close, missed
        var id: String { rawValue }
    }
    enum Plan: String, Codable, CaseIterable, Identifiable {
        case aboutRight, bitOff, wayOff
        var id: String { rawValue }
    }

    var id = UUID()
    /// The day it is about, as a `DayKey` ("2026-11-22").
    var day: String
    var protein: Protein?
    var plan: Plan?
}

/// "Slept about…" for someone without sleep data: the user's own estimate of
/// the night they woke from on `day`.
struct SleepEstimate: Codable, Hashable, Identifiable {
    enum Band: String, Codable, CaseIterable, Identifiable {
        case under6, sixToSeven, sevenToEight, overEight
        var id: String { rawValue }
        /// Minutes to show and to compare with the goal: the band's middle.
        var minutes: Int {
            switch self {
            case .under6: return 330
            case .sixToSeven: return 390
            case .sevenToEight: return 450
            case .overEight: return 510
            }
        }
    }

    var id = UUID()
    /// The day the user woke up, as a `DayKey` ("2026-11-22").
    var day: String
    var band: Band
}

/// Hours slept, logged by hand from Today's dock (2026-11-27): the night
/// the user woke from on `day`, in minutes. Kept in MUSQ's own log, never
/// written to Apple Health; Apple Health's own night, when there is one,
/// comes first wherever sleep is shown.
struct SleepLog: Codable, Hashable, Identifiable {
    var id = UUID()
    /// The day the user woke up, as a `DayKey` ("2026-11-27").
    var day: String
    var minutes: Int
}

extension SleepEstimate.Band {
    /// The band an exact night falls in, so Balance reads a logged night
    /// the way it reads an estimate.
    init(minutes: Int) {
        switch minutes {
        case ..<360: self = .under6
        case ..<420: self = .sixToSeven
        case ..<480: self = .sevenToEight
        default: self = .overEight
        }
    }
}

/// Steps the user added themselves — a walk without the phone or a Watch —
/// typed or spoken. Kept in MUSQ's own log, never written to Apple Health.
struct StepsEntry: Codable, Hashable, Identifiable {
    var id = UUID()
    var date: Date
    var steps: Int
    /// The walk's length when it was given in minutes.
    var minutes: Int?
}

/// The evening reminder to check in on eating.
struct CheckInReminder: Codable, Hashable {
    var isOn = false
    var hour = 20
    var minute = 30
}

/// A wind-down reminder before bed.
struct BedtimeReminder: Codable, Hashable {
    var isOn = false
    var hour = 22
    var minute = 15
}
