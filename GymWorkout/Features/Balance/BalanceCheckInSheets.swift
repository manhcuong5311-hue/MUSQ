//
//  BalanceCheckInSheets.swift
//  GymWorkout
//
//  Balance's two-tap logs (2026-11-22), for days without a meal log or
//  without sleep data: the evening eating check-in (how protein went, and
//  eating against the plan) and the morning "Slept about…". Both are the
//  user's own answers about today, kept in MUSQ's log (`DailyStore`), never
//  written to Apple Health. Opening one that's already done shows it,
//  ready to change or clear.
//
//  Neutral silver buttons: the answers are not graded in red, yellow or
//  green, which mean recovery on Train.
//

import SwiftUI

// MARK: - Eating check-in

struct EatCheckInSheet: View {
    @Environment(DailyStore.self) private var daily
    /// For the protein target and the kidney rule; the sheet still works
    /// where a caller leaves them out.
    @Environment(WorkoutStore.self) private var store: WorkoutStore?
    @Environment(AppleHealth.self) private var health: AppleHealth?
    @Environment(\.dismiss) private var dismiss

    @State private var protein: EatCheckIn.Protein?
    @State private var plan: EatCheckIn.Plan?
    /// Today's check-in was already there: each tap saves, and Done closes.
    @State private var isEditing = false
    @State private var didLoad = false

    /// With kidney disease protein is the doctor's call, and Balance
    /// doesn't score it.
    private var asksProtein: Bool { !(store?.profile?.health?.has(.kidneyDisease) ?? false) }
    /// With calories hidden in Settings, eating isn't set against the plan.
    private var asksPlan: Bool { !BalanceSettings.shared.hidesCalories }

    private var nutrition: NutritionPlan? {
        store?.profile.flatMap { NutritionPlan(profile: $0, measured: health?.measuredActivity) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack(spacing: 8) {
                        Image(systemName: BalancePillar.eat.symbol)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(BalanceTone.eat)
                            .accessibilityHidden(true)
                        Text("How did you eat today?")
                            .font(.ui(20, .bold))
                            .tracking(-0.3)
                            .foregroundStyle(DS.silver)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityAddTraits(.isHeader)
                    }

                    if asksProtein {
                        question(String(localized: "Protein", comment: "Eating check-in question"),
                                 hint: nutrition.map {
                                     String(localized: "Your target is about \(Int($0.protein)) g.",
                                            comment: "Eating check-in: the day's protein target")
                                 }) {
                            ForEach(EatCheckIn.Protein.allCases) { option in
                                BalanceCheckInOption(title: Self.title(option), selected: protein == option) {
                                    choose(protein: option)
                                }
                            }
                        }
                    }

                    if asksPlan {
                        question(String(localized: "Eating against your plan", comment: "Eating check-in question"),
                                 hint: String(localized: "Roughly your calories, not to the gram.")) {
                            ForEach(EatCheckIn.Plan.allCases) { option in
                                BalanceCheckInOption(title: Self.title(option), selected: plan == option) {
                                    choose(plan: option)
                                }
                            }
                        }
                    }

                    if !asksProtein && !asksPlan {
                        Text("With your settings there's nothing to check in on: eating isn't scored.")
                            .font(.ui(14))
                            .foregroundStyle(DS.silver.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your own answer, kept on this device. On a day you log meals, the log counts instead.")
                            .font(.ui(12.5))
                            .foregroundStyle(DS.silver.opacity(0.55))
                            .fixedSize(horizontal: false, vertical: true)
                        if isEditing {
                            Button {
                                daily.clearCheckIn(on: Date())
                                dismiss()
                            } label: {
                                Text("Clear today's check-in")
                                    .font(.ui(14, .semibold))
                                    .foregroundStyle(DS.silver.opacity(0.75))
                                    .frame(minHeight: 44)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.top, 8)
                .padding(.bottom, 24)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Eating check-in"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isEditing {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(String(localized: "Done")) { dismiss() }
                    }
                } else {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "Cancel")) { dismiss() }
                    }
                }
            }
        }
        .tint(DS.silver)
        .presentationDetents([.medium, .large])
        .sensoryFeedback(.selection, trigger: protein)
        .sensoryFeedback(.selection, trigger: plan)
        .onAppear {
            guard !didLoad else { return }
            didLoad = true
            // Either answer may be missing: a question that wasn't asked
            // that day is shown unpicked.
            if let existing = daily.checkIn(on: Date()) {
                protein = existing.protein
                plan = existing.plan
                isEditing = true
            }
        }
    }

    private func question<Options: View>(_ title: String, hint: String?,
                                         @ViewBuilder options: () -> Options) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                    .accessibilityAddTraits(.isHeader)
                if let hint {
                    Text(hint)
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            HStack(spacing: 8) {
                options()
            }
        }
    }

    private func choose(protein value: EatCheckIn.Protein) {
        protein = value
        commit()
    }

    private func choose(plan value: EatCheckIn.Plan) {
        plan = value
        commit()
    }

    /// A new check-in saves once every question asked has an answer, then
    /// closes itself; today's existing one saves each tap. A question not
    /// asked (protein with kidney disease, the plan with calories hidden) is
    /// saved as no answer, so it never counts if that setting changes later.
    private func commit() {
        let proteinAnswer = asksProtein ? protein : nil
        let planAnswer = asksPlan ? plan : nil
        guard proteinAnswer != nil || planAnswer != nil else { return }
        if !isEditing && ((asksProtein && proteinAnswer == nil) || (asksPlan && planAnswer == nil)) { return }
        daily.setCheckIn(proteinAnswer, planAnswer, on: Date())
        guard !isEditing else { return }
        Task {
            try? await Task.sleep(for: .milliseconds(350))
            dismiss()
        }
    }

    static func title(_ option: EatCheckIn.Protein) -> String {
        switch option {
        case .hit: return String(localized: "Hit it", comment: "Eating check-in: protein target reached")
        case .close: return String(localized: "Close", comment: "Eating check-in: protein nearly reached")
        case .missed: return String(localized: "Missed", comment: "Eating check-in: protein well short")
        }
    }

    static func title(_ option: EatCheckIn.Plan) -> String {
        switch option {
        case .aboutRight: return String(localized: "About right", comment: "Eating check-in: eating against the plan")
        case .bitOff: return String(localized: "A bit off", comment: "Eating check-in: eating against the plan")
        case .wayOff: return String(localized: "Way off", comment: "Eating check-in: eating against the plan")
        }
    }
}

// MARK: - Sleep estimate

struct SleepEstimateSheet: View {
    @Environment(DailyStore.self) private var daily
    @Environment(\.dismiss) private var dismiss

    @State private var band: SleepEstimate.Band?
    @State private var isEditing = false
    @State private var didLoad = false

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(spacing: 8) {
                        Image(systemName: BalancePillar.sleep.symbol)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(BalanceTone.sleep)
                            .accessibilityHidden(true)
                        Text("How long did you sleep last night?")
                            .font(.ui(20, .bold))
                            .tracking(-0.3)
                            .foregroundStyle(DS.silver)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityAddTraits(.isHeader)
                    }

                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(SleepEstimate.Band.allCases) { option in
                            BalanceCheckInOption(title: Self.title(option), selected: band == option, height: 64) {
                                choose(option)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("A rough guess is fine. Your estimate counts a little less than a measured night; with sleep tracking on an Apple Watch or iPhone, Apple Health fills it in.")
                            .font(.ui(12.5))
                            .foregroundStyle(DS.silver.opacity(0.55))
                            .fixedSize(horizontal: false, vertical: true)
                        if isEditing {
                            Button {
                                daily.clearSleepEstimate(on: Date())
                                dismiss()
                            } label: {
                                Text("Clear today's estimate")
                                    .font(.ui(14, .semibold))
                                    .foregroundStyle(DS.silver.opacity(0.75))
                                    .frame(minHeight: 44)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.top, 8)
                .padding(.bottom, 24)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Sleep", comment: "Sleep estimate sheet title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
        }
        .tint(DS.silver)
        .presentationDetents([.medium, .large])
        .sensoryFeedback(.selection, trigger: band)
        .onAppear {
            guard !didLoad else { return }
            didLoad = true
            if let existing = daily.sleepEstimate(on: Date()) {
                band = existing.band
                isEditing = true
            }
        }
    }

    /// One tap: saved for today, and the sheet closes.
    private func choose(_ option: SleepEstimate.Band) {
        band = option
        daily.setSleepEstimate(option, on: Date())
        Task {
            try? await Task.sleep(for: .milliseconds(300))
            dismiss()
        }
    }

    static func title(_ option: SleepEstimate.Band) -> String {
        switch option {
        case .under6: return String(localized: "Under 6 h", comment: "Sleep estimate option")
        case .sixToSeven: return String(localized: "6–7 h", comment: "Sleep estimate option")
        case .sevenToEight: return String(localized: "7–8 h", comment: "Sleep estimate option")
        case .overEight: return String(localized: "Over 8 h", comment: "Sleep estimate option")
        }
    }
}

// MARK: - Option button

/// A big answer button: silver when picked, glass otherwise.
struct BalanceCheckInOption: View {
    let title: String
    let selected: Bool
    var height: CGFloat = 56
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ui(15, .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .foregroundStyle(selected ? DS.ink : DS.silver)
                .padding(.horizontal, 6)
                .frame(maxWidth: .infinity, minHeight: height)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(selected ? DS.silver : DS.silver.opacity(0.07)))
                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(DS.silver.opacity(selected ? 0 : 0.10), lineWidth: 1))
                .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: 14)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}
