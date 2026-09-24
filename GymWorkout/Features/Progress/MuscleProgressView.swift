//
//  MuscleProgressView.swift
//  GymWorkout
//
//  Tab 3. "What have I actually trained, and what am I missing?" — the body
//  map lit by completed sets this week or month, the groups worth a look, and
//  the full list. Planned-but-unfinished sets never count.
//

import SwiftUI

struct MuscleProgressView: View {
    @Binding var tab: AppTab

    @Environment(WorkoutStore.self) private var store
    @State private var router = TrainRouter()
    @State private var period: ActivityPeriod = .week
    @State private var side: BodySide = .front

    private let calculator = MuscleActivityCalculator()

    private var activity: [MuscleActivity] {
        calculator.activity(from: store.sessions, period: period)
    }

    var body: some View {
        @Bindable var router = router
        let activity = activity
        NavigationStack(path: $router.path) {
            ZStack {
                DS.ink.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Muscle Progress")
                            .font(.ui(28, .semibold))
                            .tracking(-0.7)
                            .foregroundStyle(DS.silver)

                        MonoSegmentedControl(
                            options: [(ActivityPeriod.week, "THIS WEEK"), (.month, "THIS MONTH")],
                            selection: $period,
                            fontSize: 10,
                            itemPaddingV: 8,
                            fillsWidth: true
                        )
                        .padding(.top, 16)

                        bodyMap(activity)
                            .padding(.top, 16)

                        if activity.allSatisfy({ $0.level == .notTrained }) {
                            emptyNote.padding(.top, 18)
                        }

                        needsAttention(activity)
                            .padding(.top, 26)

                        activityList(activity)
                            .padding(.top, 28)
                    }
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 22)
                    .padding(.bottom, 24)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            .trainDestinations()
            .toolbar(.hidden, for: .navigationBar)
        }
        .environment(router)
        .tint(DS.silver)
    }

    // MARK: - Body map

    private func bodyMap(_ activity: [MuscleActivity]) -> some View {
        var fills: [BodyRegion: Color] = [:]
        for entry in activity {
            guard let color = entry.level.color else { continue }
            for region in entry.muscle.bodyRegions { fills[region] = color }
        }
        return VStack(spacing: 12) {
            MonoSegmentedControl(
                options: BodySide.allCases.map { ($0, $0.title) },
                selection: $side
            )

            BodyMapCanvas(side: side, fills: fills)
                .frame(height: 360)
                .frame(maxWidth: .infinity)
                .accessibilityElement()
                .accessibilityLabel(accessibilityText(activity))
                .id(side)
                .transition(.opacity)

            HStack(spacing: 12) {
                ForEach([ActivityLevel.notTrained, .low, .trained, .high], id: \.self) { level in
                    HStack(spacing: 5) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(level.color ?? DS.silver.opacity(0.13))
                            .frame(width: 10, height: 10)
                        Text(level.title.uppercased())
                            .font(.mono(8, .semibold))
                            .trackingEm(0.05, size: 8)
                            .foregroundStyle(DS.silver.opacity(0.5))
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            ViewportGround(inner: DS.viewportInner, outer: DS.viewportOuter,
                           rx: 0.9, ry: 0.7, cx: 0.5, cy: 0.45)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        )
        .animation(.easeOut(duration: 0.2), value: side)
    }

    private func accessibilityText(_ activity: [MuscleActivity]) -> String {
        let trained = activity.filter { $0.level != .notTrained }
            .map { "\($0.muscle.title) \($0.setsLabel)" }
        return trained.isEmpty ? "No muscles trained \(period.phrase)"
            : "Trained \(period.phrase): " + trained.joined(separator: ", ")
    }

    private var emptyNote: some View {
        Text("No completed sets \(period.phrase) yet. Sets you mark Done in Train show up here.")
            .font(.ui(13))
            .cssLineHeight(13, 1.5)
            .foregroundStyle(DS.silver.opacity(0.5))
    }

    // MARK: - Needs attention

    @ViewBuilder
    private func needsAttention(_ activity: [MuscleActivity]) -> some View {
        let items = calculator.needsAttention(activity, period: period,
                                              candidates: PresetProvider.trainableGroups)
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                SectionEyebrow(text: "NEEDS ATTENTION")
                ForEach(items) { item in
                    attentionCard(item)
                }
            }
        }
    }

    private func attentionCard(_ item: AttentionItem) -> some View {
        let group = item.activity.muscle
        let inToday = !store.exercises(for: group, on: Date()).isEmpty
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                MiniBodyMap(group: group, color: DS.silver.opacity(0.55))
                    .frame(width: 26, height: 60)
                VStack(alignment: .leading, spacing: 4) {
                    Text(group.title)
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                    Text(item.reason)
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            HStack(spacing: 8) {
                WideButton(title: "View Exercises", prominent: false, fontSize: 12.5, verticalPadding: 9, cornerRadius: 11) {
                    router.push(.preset(group, day: Calendar.current.startOfDay(for: Date())))
                }
                WideButton(title: inToday ? "In Today's Workout" : "Add to Today", prominent: !inToday,
                           fontSize: 12.5, verticalPadding: 9, cornerRadius: 11) {
                    if !inToday { store.addToToday(group) }
                    tab = .train
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
            .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
    }

    // MARK: - Full list

    private func activityList(_ activity: [MuscleActivity]) -> some View {
        let sorted = activity.sorted {
            ($0.effectiveSets, $1.muscle.title) > ($1.effectiveSets, $0.muscle.title)
        }
        let maxSets = max(sorted.first?.effectiveSets ?? 0, 1)
        let trainable = Set(PresetProvider.trainableGroups)
        return VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "MUSCLE ACTIVITY")
                Spacer()
                MetaLine(text: "EFFECTIVE SETS", em: 0.08)
            }
            .padding(.bottom, 6)

            ForEach(sorted) { entry in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(entry.muscle.title)
                            .font(.ui(14.5, .semibold))
                            .foregroundStyle(DS.silver)
                        Text(!trainable.contains(entry.muscle) && entry.level == .notTrained
                             ? "Not trained · no exercises in the library yet"
                             : entry.level.title)
                            .font(.ui(12))
                            .foregroundStyle(DS.silver.opacity(0.5))
                    }
                    Spacer(minLength: 8)
                    VStack(alignment: .trailing, spacing: 5) {
                        Text(entry.setsLabel)
                            .font(.mono(12, .semibold))
                            .foregroundStyle(DS.silver.opacity(entry.effectiveSets > 0 ? 0.9 : 0.4))
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(DS.silver.opacity(0.07))
                                Capsule()
                                    .fill(entry.level.color ?? .clear)
                                    .frame(width: geo.size.width * CGFloat(entry.effectiveSets / maxSets))
                            }
                        }
                        .frame(width: 72, height: 4)
                    }
                }
                .padding(.vertical, 11)
                .overlay(alignment: .bottom) { Hairline(opacity: 0.06) }
                .accessibilityElement(children: .combine)
            }

            Text("Effective sets: each completed set counts \(Self.weight(.primary)) for its primary muscles and \(Self.weight(.secondary)) for secondary ones.")
                .font(.ui(11.5))
                .cssLineHeight(11.5, 1.5)
                .foregroundStyle(DS.silver.opacity(0.4))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 12)
        }
    }
}

extension MuscleProgressView {
    fileprivate static func weight(_ role: ContributionRole) -> String {
        let w = role.defaultWeight
        return w.rounded() == w ? String(Int(w)) : String(w)
    }
}

extension ActivityLevel {
    /// On the activation ramp, lighter to stronger. `nil` draws as untrained.
    var color: Color? {
        switch self {
        case .notTrained: return nil
        case .low: return DS.activationSoft.opacity(0.35)
        case .trained: return DS.activationSoft.opacity(0.75)
        case .high: return DS.activation
        }
    }
}
