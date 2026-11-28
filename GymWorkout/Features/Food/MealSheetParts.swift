//
//  MealSheetParts.swift
//  GymWorkout
//
//  The look the meal scan's result and the meal editor share (2026-11-27,
//  owner's reference): the meal photo on a blurred backdrop at the top, a
//  sheet under it with the meal's name, energy, macros, time and how sure
//  the AI is, its foods as cards, and the main action pinned at the bottom
//  where the thumb is.
//

import SwiftUI
import UIKit

// MARK: - Layout

/// The photo (or nothing) on its blurred backdrop, a close button top-left,
/// a sheet of `content` with a grabber, and `bottom` pinned under it.
struct MealPhotoSheetLayout<Content: View, Bottom: View>: View {
    var photo: UIImage?
    /// The photo is being read: a shimmer runs over it.
    var isReading: Bool
    /// With no photo, an empty photo slot (the scan before a photo).
    var showsEmptySlot: Bool
    var closeLabel: String
    var onClose: () -> Void
    private let content: Content
    private let bottom: Bottom

    @State private var viewport: CGFloat = 0
    @State private var headerHeight: CGFloat = 0
    @Environment(\.colorScheme) private var scheme

    init(photo: UIImage?, isReading: Bool = false, showsEmptySlot: Bool = false, closeLabel: String,
         onClose: @escaping () -> Void, @ViewBuilder content: () -> Content, @ViewBuilder bottom: () -> Bottom) {
        self.photo = photo
        self.isReading = isReading
        self.showsEmptySlot = showsEmptySlot
        self.closeLabel = closeLabel
        self.onClose = onClose
        self.content = content()
        self.bottom = bottom()
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            backdrop
            ScrollView {
                VStack(spacing: 0) {
                    header
                        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { headerHeight = $0 }
                    sheet
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollDismissesKeyboard(.interactively)
            .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { viewport = $0 }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                bottom
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity)
                    .background(DS.surface.ignoresSafeArea(edges: .bottom))
            }
            MealSheetCloseButton(label: closeLabel, action: onClose)
                .padding(.leading, 12)
                .padding(.top, 8)
        }
    }

    /// The photo blurred to the edges, darkened so the sheet and the close
    /// button read on it; the plain ground without a photo.
    @ViewBuilder
    private var backdrop: some View {
        if let photo {
            Color.black
                .overlay {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 40, opaque: true)
                        .overlay(Color.black.opacity(scheme == .dark ? 0.55 : 0.35))
                }
                .clipped()
                .ignoresSafeArea()
                .accessibilityHidden(true)
        } else {
            DS.ink.ignoresSafeArea()
        }
    }

    @ViewBuilder
    private var header: some View {
        if let photo {
            Image(uiImage: photo)
                .resizable()
                .scaledToFill()
                // A minimum width too, so a wide photo is cropped instead of
                // widening the sheet.
                .frame(minWidth: 0, maxWidth: 420)
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay {
                    if isReading {
                        MealShimmer()
                            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        VStack(spacing: 10) {
                            ProgressView().tint(.white)
                            Text("Reading your meal…")
                                .font(.ui(16, .semibold))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .shadow(color: .black.opacity(0.35), radius: 20, y: 10)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(String(localized: "Meal photo", comment: "VoiceOver: the photo of the meal being scanned"))
                .accessibilityAddTraits(.isImage)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
                .padding(.top, 60)
                .padding(.bottom, 22)
        } else if showsEmptySlot {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(DS.silver.opacity(0.05))
                .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.14), style: StrokeStyle(lineWidth: 1.5, dash: [6, 6])))
                .overlay {
                    Image(systemName: "fork.knife.circle")
                        .font(.system(size: 54, weight: .light))
                        .foregroundStyle(DS.silver.opacity(0.4))
                }
                .frame(maxWidth: 420)
                .frame(height: 210)
                .accessibilityHidden(true)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
                .padding(.top, 60)
                .padding(.bottom, 22)
        } else {
            Color.clear.frame(height: 62)
        }
    }

    private var sheet: some View {
        VStack(alignment: .leading, spacing: 18) {
            Capsule()
                .fill(DS.silver.opacity(0.18))
                .frame(width: 38, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .accessibilityHidden(true)
            content
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.bottom, 24)
        // Down to the bottom of the screen when there's little in it.
        .frame(maxWidth: .infinity, minHeight: max(0, viewport - headerHeight), alignment: .top)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28, style: .continuous)
                .fill(DS.surface)
                .shadow(color: .black.opacity(scheme == .dark ? 0.4 : 0.12), radius: 18, y: -4)
        )
    }
}

/// The round close button over the photo.
struct MealSheetCloseButton: View {
    var label: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(DS.silver)
                .frame(width: 40, height: 40)
                .background(Circle().fill(.ultraThinMaterial))
                .overlay(Circle().strokeBorder(DS.silver.opacity(0.12), lineWidth: 1))
                .frame(width: 44, height: 44)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight)
        .accessibilityLabel(label)
    }
}

/// A light sweeping over the photo while it's read; still under Reduce
/// Motion.
struct MealShimmer: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var moves = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.opacity(0.4)
                if !reduceMotion {
                    LinearGradient(colors: [.clear, .white.opacity(0.28), .clear], startPoint: .leading, endPoint: .trailing)
                        .frame(width: proxy.size.width * 0.6)
                        .offset(x: moves ? proxy.size.width * 0.8 : -proxy.size.width * 0.8)
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) { moves = true }
        }
    }
}

// MARK: - Bottom buttons

/// The big pill of the main action, at the bottom.
struct MealPillLabel: View {
    var title: String
    var symbol: String?
    var enabled = true

    var body: some View {
        HStack(spacing: 8) {
            if let symbol {
                Image(systemName: symbol)
                    .font(.system(size: 16, weight: .bold))
                    .accessibilityHidden(true)
            }
            Text(title)
                .font(.ui(17, .semibold))
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(DS.ink)
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(Capsule().fill(DS.silver))
        .opacity(enabled ? 1 : 0.45)
        .contentShape(Capsule())
    }
}

struct MealPillButton: View {
    var title: String
    var symbol: String? = nil
    var enabled = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            MealPillLabel(title: title, symbol: symbol, enabled: enabled)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .dsHover(.highlight, radius: 28)
    }
}

/// The round secondary button beside the pill.
struct MealRoundLabel: View {
    var symbol: String
    var enabled = true

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(DS.silver)
            .frame(width: 56, height: 56)
            .background(Circle().fill(DS.silver.opacity(0.08)))
            .overlay(Circle().strokeBorder(DS.silver.opacity(0.14), lineWidth: 1))
            .opacity(enabled ? 1 : 0.4)
            .contentShape(Circle())
    }
}

struct MealRoundButton: View {
    var symbol: String
    var label: String
    var enabled = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            MealRoundLabel(symbol: symbol, enabled: enabled)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .dsHover(.highlight, radius: 28)
        .accessibilityLabel(label)
    }
}

// MARK: - Header

/// The meal's name (it wraps), its energy on the right, its macros as
/// chips, when it was eaten (a tap changes it) and how sure the AI is.
struct MealResultHeader: View {
    @Binding var title: String
    var foods: [MealReviewFood]
    @Binding var date: Date
    /// The latest the time can be set to.
    var latest: Date
    var confidence: MealConfidence?
    var showsTypedBadge = false

    @State private var showsTimePicker = false
    @FocusState private var titleFocused: Bool

    var body: some View {
        let total = MealReviewFood.totals(foods)
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                TextField(String(localized: "Meal name", comment: "A meal's name: the placeholder of its name field"),
                          text: $title, axis: .vertical)
                    .font(.ui(26, .bold))
                    .foregroundStyle(DS.silver)
                    .lineLimit(1...4)
                    .submitLabel(.done)
                    .focused($titleFocused)
                BigValue(value: total.kcal.formatted(),
                         unit: String(localized: "kcal", comment: "Unit: kilocalories, beside a meal's energy"), size: 28)
                    .fixedSize()
            }
            if !foods.isEmpty, MealReviewFood.showsMacros(foods) {
                FlowLayout(spacing: 8) {
                    macroChip(String(localized: "Protein", comment: "Macro"), total.proteinG, MealFoodLook.proteinColor)
                    macroChip(String(localized: "Carbs", comment: "Macro"), total.carbsG, MealFoodLook.carbsColor)
                    macroChip(String(localized: "Fat", comment: "Macro"), total.fatG, MealFoodLook.fatColor)
                }
            }
            HStack(spacing: 10) {
                Button {
                    titleFocused = false
                    withAnimation(.snappy) { showsTimePicker.toggle() }
                } label: {
                    HStack(spacing: 5) {
                        Text(MealTimeText.label(date))
                            .font(.ui(15, .semibold))
                            .monospacedDigit()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .bold))
                            .rotationEffect(.degrees(showsTimePicker ? 180 : 0))
                    }
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(localized: "Eaten", comment: "Meal editor: when the meal was eaten, before a date and time"))
                .accessibilityValue(MealTimeText.label(date))
                .accessibilityHint(String(localized: "Changes when you ate it", comment: "VoiceOver hint on a meal's time in the meal scan and editor"))
                Spacer(minLength: 8)
                if let confidence {
                    MealConfidenceBadge(level: confidence)
                } else if showsTypedBadge {
                    MealSourceBadge(source: .manual)
                }
            }
            if showsTimePicker {
                DatePicker(String(localized: "Eaten", comment: "Meal editor: when the meal was eaten, before a date and time"),
                           selection: $date, in: ...latest, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .transition(.opacity)
            }
        }
        // Return ends the name instead of starting a line.
        .onChange(of: title) { _, text in
            guard text.contains("\n") else { return }
            title = text.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(in: .whitespaces)
            titleFocused = false
        }
    }

    private func macroChip(_ name: String, _ grams: Int, _ color: Color) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 7, height: 7)
                .accessibilityHidden(true)
            Text(String(localized: "\(name) \(grams) g", comment: "A macro and its grams: Protein 150 g"))
                .font(.ui(13, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver.opacity(0.8))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(DS.silver.opacity(0.06)))
        .accessibilityElement(children: .combine)
    }
}

/// "Ingredients" over a meal's foods, with "+ Add" on its right.
struct MealIngredientsHeader: View {
    var onAdd: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            Text("Ingredients", comment: "Meal scan and editor: the header over a meal's foods")
                .font(.ui(19, .bold))
                .foregroundStyle(DS.silver)
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 8)
            Button(action: onAdd) {
                HStack(spacing: 5) {
                    Image(systemName: "plus")
                        .font(.system(size: 13, weight: .bold))
                    Text("Add", comment: "Meal scan and editor: adds a food, on the right of the Ingredients header")
                        .font(.ui(15, .semibold))
                }
                .foregroundStyle(DS.ink)
                .padding(.horizontal, 16)
                .frame(minHeight: 38)
                .background(Capsule().fill(DS.silver))
                .padding(.vertical, 3)
                .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .dsHover(.highlight, radius: 19)
            .accessibilityLabel(String(localized: "Add food", comment: "Meal scan review: adds a food from MUSQ's food table"))
        }
    }
}

// MARK: - Confidence

/// How sure the AI is of a scanned meal: the server's word, or, without
/// one, what the foods say (all matched to the food table, some, none).
/// Never a percentage: the server sends none.
enum MealConfidence: String {
    case high, medium, low

    static func resolve(_ raw: String?, foods: [MealReviewFood]) -> MealConfidence {
        if let raw, let level = MealConfidence(rawValue: raw.lowercased()) { return level }
        let scanned = foods.filter { !$0.isManual }
        guard !scanned.isEmpty else { return .medium }
        let matched = scanned.filter { $0.basis == "table" }.count
        return matched == scanned.count ? .high : matched > 0 ? .medium : .low
    }

    var title: String {
        switch self {
        case .high: return String(localized: "High confidence", comment: "Badge on a scanned meal: the AI is quite sure of it")
        case .medium: return String(localized: "Medium confidence", comment: "Badge on a scanned meal: the AI is fairly sure of it")
        case .low: return String(localized: "Low confidence", comment: "Badge on a scanned meal: the AI isn't sure, check the portions")
        }
    }

    var color: Color {
        switch self {
        case .high: return DS.rhythmDue
        case .medium: return DS.rhythmRecent
        case .low: return DS.rhythmWaiting
        }
    }
}

struct MealConfidenceBadge: View {
    var level: MealConfidence

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "sparkles")
                .font(.system(size: 11, weight: .bold))
            Text(level.title)
                .font(.ui(13, .semibold))
                .lineLimit(1)
        }
        .foregroundStyle(level.color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(level.color.opacity(0.14)))
        .fixedSize()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(MealScanSheet.confidenceText(level.rawValue))
    }
}

// MARK: - Time

enum MealTimeText {
    /// "Today, 11:59", "Yesterday, 08:30", "Sat, 21 Nov, 19:05".
    static func label(_ date: Date) -> String {
        let time = date.formatted(date: .omitted, time: .shortened)
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return String(localized: "Today, \(time)", comment: "When a meal was eaten: Today, 11:59")
        }
        if calendar.isDateInYesterday(date) {
            return String(localized: "Yesterday, \(time)", comment: "When a meal was eaten: Yesterday, 08:30")
        }
        let day = date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
        return String(localized: "\(day), \(time)", comment: "When a meal was eaten, another day: Sat, 21 Nov, 19:05")
    }
}

// MARK: - Food look

/// A food's round picture (an emoji for its kind of food: there are no food
/// photos) and the colour of the macro most of its energy comes from.
enum MealFoodLook {
    /// The macro colours of Today's coach layout.
    static let proteinColor = DS.activation
    static let fatColor = DS.activationSoft
    static let carbsColor = DS.silver.opacity(0.35)

    static func category(of food: MealReviewFood) -> String? {
        if let category = food.entry?.category { return category }
        guard let ref = food.ref else { return nil }
        return FoodTable.shared.entry(id: ref)?.category
    }

    static func emoji(for category: String?) -> String {
        switch category {
        case "rice dish": return "🍚"
        case "drink": return "🥤"
        case "noodles", "noodle soup": return "🍜"
        case "snack": return "🍿"
        case "meat": return "🥩"
        case "dessert": return "🍮"
        case "vegetable": return "🥦"
        case "sandwich": return "🥪"
        case "fried": return "🍗"
        case "bread": return "🍞"
        case "breakfast": return "🍳"
        case "fruit": return "🍎"
        case "grill": return "🍢"
        case "stew": return "🍲"
        case "soup": return "🥣"
        case "pastry": return "🥐"
        case "sauce": return "🥫"
        case "dairy": return "🥛"
        case "sweets": return "🍬"
        case "salad": return "🥗"
        case "fish": return "🐟"
        case "curry": return "🍛"
        case "eggs": return "🥚"
        case "dumplings": return "🥟"
        case "nuts": return "🥜"
        case "grains": return "🌾"
        case "alcohol": return "🍺"
        case "fats": return "🧈"
        case "sushi": return "🍣"
        case "pizza": return "🍕"
        case "seafood": return "🦐"
        case "beans": return "🫘"
        case "tofu": return "🥢"
        case "supplement": return "💊"
        default: return "🍽️"
        }
    }

    /// The macro most of the energy comes from (4 kcal a gram of protein
    /// or carbs, 9 of fat); nil with no macros.
    static func dominantColor(_ item: MealEntry.Item) -> Color? {
        let protein = Double(item.proteinG) * 4, carbs = Double(item.carbsG) * 4, fat = Double(item.fatG) * 9
        guard protein + carbs + fat > 0 else { return nil }
        if protein >= carbs && protein >= fat { return proteinColor }
        return fat > carbs ? fatColor : carbsColor
    }
}

/// A food's round picture: its kind's emoji on a tinted circle.
struct MealFoodThumb: View {
    var food: MealReviewFood
    var size: CGFloat = 46

    var body: some View {
        let tint = MealFoodLook.dominantColor(food.logged) ?? DS.silver.opacity(0.4)
        Text(verbatim: MealFoodLook.emoji(for: MealFoodLook.category(of: food)))
            .font(.system(size: size * 0.48))
            .frame(width: size, height: size)
            .background(Circle().fill(tint.opacity(0.16)))
            .overlay(Circle().strokeBorder(tint.opacity(0.25), lineWidth: 1))
            .accessibilityHidden(true)
    }
}
