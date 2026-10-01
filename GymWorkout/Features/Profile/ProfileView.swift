//
//  ProfileView.swift
//  GymWorkout
//
//  Tab 4. The totals, the onboarding answers and the plan they add up to,
//  the settings that shape every other tab (units, experience for recovery
//  estimates, rest timer), Premium and ad privacy, personal records, and the
//  workout history they come from. Only completed sets count.
//

import SwiftUI

enum ProfileRoute: Hashable {
    case session(UUID)
    case exercise(String)
}

struct ProfileView: View {
    @Binding var tab: AppTab

    @Environment(WorkoutStore.self) private var store
    @Environment(Purchases.self) private var purchases
    @Environment(Ads.self) private var ads
    @Environment(Paywall.self) private var paywall
    @State private var path: [ProfileRoute] = []
    @State private var showsAllRecords = false
    @State private var historyLimit = ProfileView.historyPage
    @State private var editsProfile = false

    private static let recordPreview = 5
    private static let historyPage = 8

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                DS.ink.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Profile")
                            .font(.ui(28, .semibold))
                            .tracking(-0.7)
                            .foregroundStyle(DS.silver)

                        stats
                            .padding(.top, 18)
                        aboutYou
                            .padding(.top, 28)
                        settings
                            .padding(.top, 28)
                        premiumAndPrivacy
                            .padding(.top, 28)
                        records
                            .padding(.top, 30)
                        history
                            .padding(.top, 30)
                    }
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 22)
                    .padding(.bottom, 24)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            .statusBarScrim()
            .navigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .session(let id): SessionHistoryView(sessionID: id)
                case .exercise(let name): ExerciseHistoryView(exerciseName: name)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(DS.silver)
        .fullScreenCover(isPresented: $editsProfile) {
            OnboardingView(isEditing: true, onClose: { editsProfile = false })
                .environment(store)
                .environment(purchases)
        }
    }

    private var loggedSessions: [WorkoutSession] {
        store.sessions.filter(\.hasCompletedSets).sorted { $0.day > $1.day }
    }

    // MARK: - Totals

    private var stats: some View {
        let week = Calendar.current.dateInterval(of: .weekOfYear, for: Date())
            ?? DateInterval(start: Date(), duration: 0)
        let thisWeek = PerformanceHistory.sessions(in: week, from: store.sessions)
        let volume = thisWeek.reduce(0) { $0 + $1.volume }
        return HStack(spacing: 8) {
            StatTile(label: "Workouts", value: loggedSessions.count.formatted())
            StatTile(label: "This week", value: thisWeek.count.formatted())
            StatTile(label: "Volume this week",
                     value: StatTile.compact(store.unit.fromKilograms(volume)),
                     unit: store.unit.symbol)
        }
    }

    // MARK: - About you

    @ViewBuilder
    private var aboutYou: some View {
        if let profile = store.profile {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    SectionEyebrow(text: "ABOUT YOU")
                    Spacer()
                    Button("Edit") { editsProfile = true }
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver)
                        .buttonStyle(.plain)
                }
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        fact("GOAL", profile.goal.title)
                        fact("SEX", profile.sex == .unspecified ? "–" : profile.sex.title)
                    }
                    HStack(spacing: 8) {
                        fact("HEIGHT", store.unit.height(profile.heightCm))
                        fact("WEIGHT", store.unit.total(profile.weightKg))
                    }
                    Hairline(opacity: 0.06)
                    Text(planSummary(profile))
                        .font(.ui(12.5))
                        .cssLineHeight(12.5, 1.45)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
            }
        }
    }

    private func fact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            MetaLine(text: label, size: 8.5)
            Text(value)
                .font(.ui(15, .semibold))
                .foregroundStyle(DS.silver)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    /// "Front / Back, 3 days a week · Lower-body focus · Basic presets · walk
    /// 3,000 steps after workouts."
    private func planSummary(_ profile: UserProfile) -> String {
        let split = ProgramAdvisor.split(for: profile).title
        var parts = [profile.daysPerWeek.map { "\(split), \($0) days a week" } ?? split]
        if ProgramAdvisor.isLowerFocused(profile) { parts.append("Lower-body focus") }
        parts.append("\(store.suggestedLevel.title.capitalized) presets")
        if let walk = store.walkSuggestion {
            parts.append("walk \(walk.steps.formatted()) steps after workouts")
        }
        return parts.joined(separator: " · ") + "."
    }

    // MARK: - Settings

    private var settings: some View {
        @Bindable var store = store
        return VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "SETTINGS")
            VStack(spacing: 0) {
                settingRow("Units", detail: "Switching only changes how weights are shown.") {
                    MonoSegmentedControl(
                        options: WeightUnit.allCases.map { ($0, $0.symbol.uppercased()) },
                        selection: $store.unit,
                        fontSize: 10,
                        itemPaddingH: 13,
                        itemPaddingV: 7
                    )
                }
                Hairline(opacity: 0.06)
                settingRow("Training experience", detail: "Sets how long recovery estimates run.") {
                    menu(selection: $store.experience, options: TrainingExperience.allCases, title: \.title)
                }
                Hairline(opacity: 0.06)
                settingRow("Rest timer", detail: store.rest == .auto
                           ? "Auto: 3 min for 6 reps or fewer, 2 min up to 9, 90 s above, 1 min after holds."
                           : store.rest == .off ? "No timer after sets."
                           : "Starts when a set is marked done.") {
                    menu(selection: $store.rest, options: RestSetting.allCases, title: \.title)
                }
            }
            .padding(.horizontal, 14)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
        }
    }

    // MARK: - Premium & privacy

    private var premiumAndPrivacy: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "PREMIUM & PRIVACY")
            VStack(spacing: 0) {
                settingRow("MUSQ Premium", detail: premiumDetail) {
                    pillButton(purchases.isPremium ? "ACTIVE" : "UPGRADE", prominent: !purchases.isPremium) {
                        paywall.show(.profile)
                    }
                }
                if ads.privacyOptionsRequired {
                    Hairline(opacity: 0.06)
                    settingRow("Privacy choices", detail: "Change what you agreed to for ads.") {
                        pillButton("OPEN") { Task { await ads.presentPrivacyOptions() } }
                    }
                }
            }
            .padding(.horizontal, 14)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))

            HStack(spacing: 14) {
                Link("Privacy Policy", destination: AppLinks.privacy)
                Link("Terms of Use", destination: AppLinks.terms)
                Link("Support", destination: AppLinks.support)
            }
            .font(.ui(12, .semibold))
            .foregroundStyle(DS.silver.opacity(0.55))
            .padding(.horizontal, 4)
            .padding(.top, 2)
        }
    }

    private var premiumDetail: String {
        switch purchases.activePlan {
        case Purchases.ProductID.yearly: return "Your yearly plan is active."
        case Purchases.ProductID.monthly: return "Your monthly plan is active."
        case Purchases.ProductID.lifetime: return "Lifetime. Premium is yours for good."
        default:
            return purchases.isPremium
                ? "Premium is on."
                : "Common mistakes, Form Comparison, Preset 2 and 3, no ads."
        }
    }

    /// A small capsule action; prominent (silver) when it's an offer.
    private func pillButton(_ title: String, prominent: Bool = false,
                            action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.mono(10, .semibold))
                .trackingEm(0.08, size: 10)
                .foregroundStyle(prominent ? DS.ink : DS.silver.opacity(0.8))
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(Capsule().fill(prominent ? DS.silver : DS.silver.opacity(0.07)))
        }
        .buttonStyle(.plain)
    }

    private func settingRow<Control: View>(_ title: String, detail: String,
                                           @ViewBuilder control: () -> Control) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.ui(14.5, .semibold))
                    .foregroundStyle(DS.silver)
                Text(detail)
                    .font(.ui(12))
                    .cssLineHeight(12, 1.4)
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
            control()
        }
        .padding(.vertical, 13)
    }

    private func menu<Value: Hashable & Identifiable>(selection: Binding<Value>, options: [Value],
                                                      title: KeyPath<Value, String>) -> some View {
        Menu {
            Picker(selection: selection) {
                ForEach(options) { Text($0[keyPath: title]).tag($0) }
            } label: { EmptyView() }
        } label: {
            HStack(spacing: 5) {
                Text(selection.wrappedValue[keyPath: title].uppercased())
                    .font(.mono(10, .semibold))
                    .trackingEm(0.08, size: 10)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 8, weight: .bold))
            }
            .foregroundStyle(DS.silver.opacity(0.8))
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .background(Capsule().fill(DS.silver.opacity(0.07)))
        }
    }

    // MARK: - Personal records

    @ViewBuilder
    private var records: some View {
        let all = PerformanceHistory.records(in: store.sessions)
        let shown = showsAllRecords ? all : Array(all.prefix(Self.recordPreview))
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "PERSONAL RECORDS")
                Spacer()
                if !all.isEmpty {
                    MetaLine(text: "\(all.count) \(all.count == 1 ? "EXERCISE" : "EXERCISES")", em: 0.08)
                }
            }
            if all.isEmpty {
                emptyNote("Your best set for each exercise shows up here once you mark sets done in Train.")
            } else {
                VStack(spacing: 0) {
                    ForEach(shown) { record in
                        Button {
                            path.append(.exercise(record.exerciseName))
                        } label: {
                            RecordRow(record: record, unit: store.unit)
                        }
                        .buttonStyle(.plain)
                        if record.id != shown.last?.id { Hairline(opacity: 0.06) }
                    }
                }
                if all.count > Self.recordPreview {
                    moreButton(showsAllRecords ? "Show fewer" : "Show all \(all.count)") {
                        withAnimation(.easeOut(duration: 0.2)) { showsAllRecords.toggle() }
                    }
                }
            }
        }
    }

    // MARK: - History

    @ViewBuilder
    private var history: some View {
        let sessions = loggedSessions
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "HISTORY")
            if sessions.isEmpty {
                emptyNote("Every workout with a set marked done is listed here, newest first.")
            } else {
                ForEach(sessions.prefix(historyLimit)) { session in
                    Button {
                        path.append(.session(session.id))
                    } label: {
                        SessionRow(session: session, unit: store.unit)
                    }
                    .buttonStyle(.plain)
                }
                if sessions.count > historyLimit {
                    moreButton("Show more") {
                        withAnimation(.easeOut(duration: 0.2)) { historyLimit += Self.historyPage }
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func emptyNote(_ text: String) -> some View {
        Text(text)
            .font(.ui(13))
            .cssLineHeight(13, 1.5)
            .foregroundStyle(DS.silver.opacity(0.5))
            .fixedSize(horizontal: false, vertical: true)
    }

    private func moreButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.ui(13, .semibold))
                .foregroundStyle(DS.silver.opacity(0.7))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Stat tile

/// One total: a sentence-case label over its value.
struct StatTile: View {
    var label: String
    var value: String
    var unit: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.ui(11.5))
                .foregroundStyle(DS.silver.opacity(0.5))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.ui(22, .semibold))
                    .tracking(-0.4)
                    .foregroundStyle(DS.silver)
                if let unit {
                    Text(unit)
                        .font(.ui(12, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
        .accessibilityElement(children: .combine)
    }

    /// "940", "3,240", "12.9K".
    static func compact(_ value: Double) -> String {
        value < 10_000
            ? Int(value.rounded()).formatted()
            : value.formatted(.number.notation(.compactName).precision(.fractionLength(0...1)))
    }
}

// MARK: - Rows

/// An exercise's best: the headline number on the right, how it was set below
/// the name.
struct RecordRow: View {
    var record: ExerciseRecord
    var unit: WeightUnit

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.exerciseName)
                    .font(.ui(14.5, .semibold))
                    .foregroundStyle(DS.silver)
                    .multilineTextAlignment(.leading)
                Text(detail)
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 3) {
                Text(headline.value)
                    .font(.mono(14, .semibold))
                    .foregroundStyle(DS.silver)
                MetaLine(text: headline.label, size: 8.5, em: 0.08)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.28))
        }
        .padding(.vertical, 11)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }

    private var headline: (value: String, label: String) {
        if record.measure == .time, let best = record.bestUnloaded {
            return (SetMeasure.clock(best.reps), "LONGEST")
        }
        if let heaviest = record.heaviest, let weight = heaviest.weight {
            return (unit.format(weight), "HEAVIEST")
        }
        if let best = record.bestUnloaded {
            return ("\(best.reps)", "MOST REPS")
        }
        return ("–", "")
    }

    private var detail: String {
        var parts: [String] = []
        if let best = record.bestSet, let weight = best.weight, let estimate = best.estimatedMax {
            parts.append("Best set \(unit.format(weight)) × \(best.reps) · est. 1RM \(unit.total(estimate))")
        }
        parts.append("Last done \(RecoveryText.dayPhrase(record.lastDone))")
        return parts.joined(separator: " · ")
    }
}

/// One day's workout in the history list.
struct SessionRow: View {
    var session: WorkoutSession
    var unit: WeightUnit

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(RecoveryText.day(session.day))
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                    if session.completedAt == nil {
                        MetaLine(text: "IN PROGRESS", size: 8.5)
                    }
                }
                MetaLine(text: session.groups.map { $0.title.uppercased() }.joined(separator: " · "), em: 0.06)
                    .lineLimit(1)
                Text(SessionText.summary(session, unit: unit))
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.55))
            }
            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.28))
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

enum SessionText {
    /// "4 exercises · 14 sets · 3,240 kg" — counting what was done.
    static func summary(_ session: WorkoutSession, unit: WeightUnit) -> String {
        let done = session.exercises.filter { !$0.completedSets.isEmpty }.count
        let sets = session.completedSetCount
        var parts = ["\(done) \(done == 1 ? "exercise" : "exercises")", "\(sets) \(sets == 1 ? "set" : "sets")"]
        if session.volume > 0 { parts.append(unit.total(session.volume)) }
        return parts.joined(separator: " · ")
    }
}
