//
//  FoodView.swift
//  GymWorkout
//
//  The Food page (2026-11-27, the owner's UX overhaul), opened from
//  Today's food card: an energy bar for the calories eaten against the
//  plan that fills with a spring as meals go in, four macro cards (protein,
//  carbs, fat, fiber) each with its own colour and a small bar, and today's
//  meals with a big "Add food" at the bottom where the thumb is. A tap on a
//  macro opens a small sheet with Ask MUSQ: foods high in it, or what to eat
//  now — the question waits in the chat's field until the member sends it.
//
//  Fiber: meals don't carry fiber yet (`MealEntry` has none), so its card
//  shows the plan's target with "—" eaten.
//

import SwiftUI

// MARK: - Colours

enum FoodPalette {
    static let energyStart = Color(light: 0xEA580C, dark: 0xFF7A1A)
    static let energyEnd = Color(light: 0xDB2777, dark: 0xFF4F9A)
    static var energyGradient: LinearGradient {
        LinearGradient(colors: [energyStart, energyEnd], startPoint: .leading, endPoint: .trailing)
    }
    static let protein = Color(light: 0xDC2626, dark: 0xFF5A5F)
    static let carbs = Color(light: 0xD97706, dark: 0xFBBF24)
    static let fat = Color(light: 0x0891B2, dark: 0x22D3EE)
    static let fiber = Color(light: 0x16A34A, dark: 0x4ADE80)
}

/// The day's energy as a vivid bar that springs to its value as it appears
/// and as meals go in; past the target it stays full.
struct FoodEnergyBar: View {
    var value: Double
    var height: CGFloat = 14

    @State private var drawn = 0.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(DS.silver.opacity(0.10))
                Capsule()
                    .fill(FoodPalette.energyGradient)
                    .frame(width: max(drawn > 0 ? height : 0, geo.size.width * min(1, max(0, drawn))))
                    .shadow(color: FoodPalette.energyEnd.opacity(0.35), radius: drawn > 0 ? 6 : 0)
            }
        }
        .frame(height: height)
        .accessibilityHidden(true)
        .onAppear { animate(to: value) }
        .onChange(of: value) { _, new in animate(to: new) }
    }

    private func animate(to new: Double) {
        if reduceMotion {
            drawn = new
        } else {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.72)) { drawn = new }
        }
    }
}

// MARK: - Macros

enum FoodMacro: String, Identifiable, CaseIterable {
    case protein, carbs, fat, fiber
    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .protein: return "bolt.fill"
        case .carbs: return "takeoutbag.and.cup.and.straw.fill"
        case .fat: return "drop.fill"
        case .fiber: return "leaf.fill"
        }
    }

    var tint: Color {
        switch self {
        case .protein: return FoodPalette.protein
        case .carbs: return FoodPalette.carbs
        case .fat: return FoodPalette.fat
        case .fiber: return FoodPalette.fiber
        }
    }

    var name: String {
        switch self {
        case .protein: return String(localized: "Protein", comment: "Macro")
        case .carbs: return String(localized: "Carbs", comment: "Macro")
        case .fat: return String(localized: "Fat", comment: "Macro")
        case .fiber: return String(localized: "Fiber", comment: "Macro: dietary fiber")
        }
    }

    /// Grams eaten today; nil where meals don't carry it (fiber).
    func eaten(_ eaten: (kcal: Int, proteinG: Int, fatG: Int, carbsG: Int)) -> Int? {
        switch self {
        case .protein: return eaten.proteinG
        case .carbs: return eaten.carbsG
        case .fat: return eaten.fatG
        case .fiber: return nil
        }
    }

    func target(_ plan: NutritionPlan?) -> Int? {
        guard let plan else { return nil }
        switch self {
        case .protein: return Int(plan.protein)
        case .carbs: return Int(plan.carbs)
        case .fat: return Int(plan.fat)
        case .fiber: return Int(plan.fiber)
        }
    }

    /// The question for "Suggest foods high in …", put in the chat's field.
    func suggestQuestion(eaten: Int?, target: Int?) -> String {
        switch (self, eaten, target) {
        case (.protein, let eaten?, let target?):
            return String(localized: "Suggest foods high in protein that fit my plan. I've had \(eaten) g of my \(target) g today.",
                          comment: "Ask MUSQ prefill from the Food page's protein card")
        case (.carbs, let eaten?, let target?):
            return String(localized: "Suggest good sources of carbs that fit my plan. I've had \(eaten) g of my \(target) g today.",
                          comment: "Ask MUSQ prefill from the Food page's carbs card")
        case (.fat, let eaten?, let target?):
            return String(localized: "Suggest healthy foods high in fat that fit my plan. I've had \(eaten) g of my \(target) g today.",
                          comment: "Ask MUSQ prefill from the Food page's fat card")
        case (.fiber, _, let target?):
            return String(localized: "Suggest foods high in fiber that fit my plan. My target is \(target) g a day.",
                          comment: "Ask MUSQ prefill from the Food page's fiber card")
        case (.protein, _, _):
            return String(localized: "Suggest foods high in protein for my training.", comment: "Ask MUSQ prefill, no plan")
        case (.carbs, _, _):
            return String(localized: "Suggest good sources of carbs for my training.", comment: "Ask MUSQ prefill, no plan")
        case (.fat, _, _):
            return String(localized: "Suggest healthy foods high in fat.", comment: "Ask MUSQ prefill, no plan")
        case (.fiber, _, _):
            return String(localized: "Suggest foods high in fiber.", comment: "Ask MUSQ prefill, no plan")
        }
    }

    /// "Suggest foods high in protein": the sheet's button.
    var suggestTitle: String {
        switch self {
        case .protein: return String(localized: "Suggest foods high in protein", comment: "Food page macro sheet button")
        case .carbs: return String(localized: "Suggest good carbs", comment: "Food page macro sheet button")
        case .fat: return String(localized: "Suggest healthy fats", comment: "Food page macro sheet button")
        case .fiber: return String(localized: "Suggest foods high in fiber", comment: "Food page macro sheet button")
        }
    }
}

// MARK: - The page

struct FoodView: View {
    var metrics: TodayMetrics
    var plan: NutritionPlan?
    /// Opens Ask MUSQ with a question in its field; nil where the chat isn't
    /// available (the AI buttons hide).
    var onAsk: ((String) -> Void)?

    @Environment(DailyStore.self) private var daily
    @Environment(WorkoutStore.self) private var store
    @Environment(AppleHealth.self) private var health
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsLayout) private var layout

    @State private var showsLog = false
    @State private var macro: FoodMacro?
    /// A question from the macro sheet, asked once it has closed.
    @State private var pendingAsk: String?

    var body: some View {
        let eaten = daily.eaten(on: Date())
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                energyCard(eaten)
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(FoodMacro.allCases) { item in
                        macroCard(item, eaten: eaten)
                    }
                }
                TodayMealsSection(metrics: metrics, chips: .scanOnly)
                    .padding(.top, 6)
                TodayFootnote()
            }
            .dsReadable(720)
            .dsGutter()
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(DS.ink.ignoresSafeArea())
        // The thumb's button.
        .safeAreaInset(edge: .bottom, spacing: 0) {
            WideButton(title: String(localized: "Add food", comment: "Food page: the big button that logs a meal"),
                       prominent: true, fontSize: 17, verticalPadding: 16, cornerRadius: 16) {
                showsLog = true
            }
            .accessibilityHint(String(localized: "Say or type what you ate", comment: "VoiceOver hint on Today's Log food"))
            .frame(maxWidth: 560)
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.top, 10)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity)
            .background(DS.chrome.background(.ultraThinMaterial).ignoresSafeArea(edges: .bottom))
        }
        .navigationTitle(String(localized: "Food", comment: "Food page title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .sensoryFeedback(.success, trigger: eaten.kcal) { old, new in new > old }
        .sheet(isPresented: $showsLog) {
            QuickLogSheet(kind: .food)
                .environment(daily)
                .environment(store)
                .environment(health)
        }
        .sheet(item: $macro, onDismiss: {
            guard let question = pendingAsk else { return }
            pendingAsk = nil
            onAsk?(question)
        }) { item in
            FoodMacroSheet(macro: item, eaten: item.eaten(eaten), target: item.target(plan),
                           eatenKcal: eaten.kcal, targetKcal: metrics.calories, totals: eaten, plan: plan,
                           canAsk: onAsk != nil) { question in
                pendingAsk = question
                macro = nil
            }
        }
    }

    // MARK: Energy

    private func energyCard(_ eaten: (kcal: Int, proteinG: Int, fatG: Int, carbsG: Int)) -> some View {
        let target = metrics.calories
        let left = target.map { $0 - eaten.kcal }
        return VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                StyledSymbol(name: "flame.fill", size: 20, weight: .bold)
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, value: eaten.kcal)
                    .frame(width: 46, height: 46)
                    .background(Circle().fill(FoodPalette.energyGradient))
                    .shadow(color: FoodPalette.energyEnd.opacity(0.35), radius: 10, y: 3)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    TodayEyebrow(text: String(localized: "Energy today", comment: "Food page: the calories eaten today"), size: 10.5)
                    BigValue(value: eaten.kcal.formatted(),
                             unit: target.map { String(localized: "/ \($0.formatted()) kcal", comment: "After calories eaten: / 2,020 kcal") }
                                 ?? String(localized: "kcal"),
                             size: 32, weight: .bold)
                        .animation(.snappy, value: eaten.kcal)
                }
                Spacer(minLength: 0)
            }
            if let target {
                FoodEnergyBar(value: Double(eaten.kcal) / Double(max(target, 1)), height: 16)
            }
            if let left {
                Text(left >= 0
                     ? String(localized: "\(left.formatted()) kcal left today", comment: "Meals: 780 kcal left today")
                     : String(localized: "\((-left).formatted()) kcal over today's plan", comment: "Meals: 120 kcal over today's plan"))
                    .font(.ui(14, .semibold))
                    .monospacedDigit()
                    .foregroundStyle(left >= 0 ? DS.silver.opacity(0.7) : FoodPalette.energyEnd)
                    .contentTransition(.numericText())
                    .animation(.snappy, value: left)
            } else {
                Text("Finish your plan to see your daily target.", comment: "Food page without a plan")
                    .font(.ui(13.5))
                    .foregroundStyle(DS.silver.opacity(0.6))
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(DS.surface)
            .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.05), radius: 16, y: 6))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous)
            .strokeBorder(DS.silver.opacity(scheme == .dark ? 0.08 : 0.04), lineWidth: 1))
        .accessibilityElement(children: .combine)
    }

    // MARK: Macro cards

    private func macroCard(_ item: FoodMacro, eaten totals: (kcal: Int, proteinG: Int, fatG: Int, carbsG: Int)) -> some View {
        let eaten = item.eaten(totals)
        let target = item.target(plan)
        return Button {
            macro = item
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    StyledSymbol(name: item.symbol, size: 13, weight: .bold, role: item.rawValue)
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(item.tint))
                    Text(item.name)
                        .font(.ui(14.5, .semibold))
                        .foregroundStyle(DS.silver)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer(minLength: 0)
                }
                BigValue(value: eaten.map { "\($0)" } ?? "—",
                         unit: target.map { "/ \($0) g" } ?? String(localized: "g", comment: "Grams, after a macro's daily amount: 148 g"),
                         size: 22)
                ProgressBar(value: target.flatMap { target in eaten.map { Double($0) / Double(max(target, 1)) } } ?? 0,
                            color: item.tint)
                    .frame(height: 6)
                    .animation(.spring(response: 0.6, dampingFraction: 0.75), value: eaten)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surface))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(item.tint.opacity(scheme == .dark ? 0.25 : 0.18), lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint(String(localized: "Opens ideas from Ask MUSQ", comment: "VoiceOver hint on a Food page macro card"))
    }
}

// MARK: - A macro's sheet

/// One macro up close, with Ask MUSQ's two questions as big buttons.
struct FoodMacroSheet: View {
    var macro: FoodMacro
    var eaten: Int?
    var target: Int?
    var eatenKcal: Int
    var targetKcal: Int?
    var totals: (kcal: Int, proteinG: Int, fatG: Int, carbsG: Int)
    var plan: NutritionPlan?
    var canAsk: Bool
    var onAsk: (String) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 14) {
                        StyledSymbol(name: macro.symbol, size: 26, weight: .bold, role: macro.rawValue)
                            .foregroundStyle(.white)
                            .frame(width: 64, height: 64)
                            .background(Circle().fill(macro.tint))
                            .accessibilityHidden(true)
                            .padding(.top, 6)
                        BigValue(value: eaten.map { "\($0)" } ?? "—",
                                 unit: target.map { "/ \($0) g" } ?? String(localized: "g", comment: "Grams, after a macro's daily amount: 148 g"),
                                 size: 36)
                        if let target, let eaten {
                            Text(eaten >= target
                                 ? String(localized: "Target reached today", comment: "Food page macro sheet: the day's grams reached")
                                 : String(localized: "\(target - eaten) g to go today", comment: "Food page macro sheet: grams left, 40 g to go today"))
                                .font(.ui(14.5, .semibold))
                                .foregroundStyle(macro.tint)
                        } else if macro == .fiber {
                            Text("Meals don't count fiber yet. Aim for your daily target.", comment: "Food page fiber sheet")
                                .font(.ui(13.5))
                                .foregroundStyle(DS.silver.opacity(0.6))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        if !canAsk {
                            Text("Ask MUSQ isn't available here yet.", comment: "Food page macro sheet without the AI chat")
                                .font(.ui(13.5))
                                .foregroundStyle(DS.silver.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, DS.Metric.gutter)
                    .frame(maxWidth: .infinity)
                }
                if canAsk {
                    VStack(spacing: 10) {
                        askButton(title: macro.suggestTitle, symbol: "sparkles", prominent: true) {
                            onAsk(macro.suggestQuestion(eaten: eaten, target: target))
                        }
                        askButton(title: String(localized: "What should I eat now?", comment: "Food page macro sheet button: Ask MUSQ"),
                                  symbol: "fork.knife", prominent: false) {
                            onAsk(whatToEatQuestion)
                        }
                    }
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.bottom, 12)
                    .frame(maxWidth: 520)
                }
            }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(macro.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(DS.ink)
    }

    private func askButton(title: String, symbol: String, prominent: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: symbol)
                    .font(.system(size: 16, weight: .bold))
                Text(title)
                    .font(.ui(16, .semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 13, weight: .bold))
                    .opacity(0.7)
            }
            .foregroundStyle(prominent ? Color.white : DS.silver)
            .padding(.horizontal, 18)
            .frame(minHeight: 56)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(prominent ? AnyShapeStyle(macro.tint) : AnyShapeStyle(DS.silver.opacity(0.08))))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(String(localized: "Opens Ask MUSQ with the question written for you to send",
                                  comment: "VoiceOver hint on the Food page's Ask MUSQ buttons"))
    }

    /// "What should I eat for the rest of today?" with the day's numbers.
    private var whatToEatQuestion: String {
        guard let targetKcal, let plan else {
            return String(localized: "What should I eat for the rest of today? I've eaten \(eatenKcal) kcal so far.",
                          comment: "Ask MUSQ prefill from the Food page, no plan")
        }
        return String(localized: "What should I eat for the rest of today? I've eaten \(eatenKcal) of \(targetKcal) kcal — protein \(totals.proteinG)/\(Int(plan.protein)) g, carbs \(totals.carbsG)/\(Int(plan.carbs)) g, fat \(totals.fatG)/\(Int(plan.fat)) g.",
                      comment: "Ask MUSQ prefill from the Food page with the day's numbers")
    }
}
