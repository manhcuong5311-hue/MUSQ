//
//  HistoryViews.swift
//  GymWorkout
//
//  Read-only history pushed from Profile: one day's workout, and one
//  exercise across every day it was done. Editing stays in Train.
//

import SwiftUI

// MARK: - One workout

struct SessionHistoryView: View {
    var sessionID: UUID

    @Environment(WorkoutStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            if let session = store.sessions.first(where: { $0.id == sessionID }) {
                let records = recordIDs(in: session)
                VStack(spacing: 0) {
                    HistoryHeader(title: RecoveryText.day(session.day),
                                  meta: session.day.formatted(.dateTime.weekday(.wide).day().month(.wide).year()).uppercased(),
                                  onBack: { dismiss() })
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(SessionText.summary(session, unit: store.unit))
                                .font(.ui(13))
                                .foregroundStyle(DS.silver.opacity(0.6))
                            if session.completedAt == nil {
                                Text("Still in progress — finish it from Train.")
                                    .font(.ui(12))
                                    .foregroundStyle(DS.silver.opacity(0.4))
                                    .padding(.top, 4)
                            }

                            VStack(spacing: 10) {
                                ForEach(session.exercises) { exercise in
                                    exerciseCard(exercise, records: records)
                                }
                            }
                            .padding(.top, 18)
                        }
                        .padding(.horizontal, DS.Metric.gutter)
                        .padding(.top, 6)
                        .padding(.bottom, 32)
                    }
                }
            } else {
                MissingHistory(onBack: { dismiss() })
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .restTimerInset()
    }

    private func recordIDs(in session: WorkoutSession) -> Set<UUID> {
        let names = Set(session.exercises.map(\.exerciseName))
        return names.reduce(into: Set<UUID>()) { ids, name in
            ids.formUnion(PerformanceHistory.recordSetIDs(for: name, in: store.sessions))
        }
    }

    private func exerciseCard(_ exercise: WorkoutExercise, records: Set<UUID>) -> some View {
        NavigationLink(value: ProfileRoute.exercise(exercise.exerciseName)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(exercise.exerciseName)
                        .font(.ui(14.5, .semibold))
                        .foregroundStyle(DS.silver)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 8)
                    MetaLine(text: exercise.group.title.uppercased(), size: 8.5)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.28))
                }
                if exercise.completedSets.isEmpty {
                    Text("Not done")
                        .font(.ui(12))
                        .foregroundStyle(DS.silver.opacity(0.4))
                } else {
                    SetChips(sets: exercise.completedSets, measure: exercise.setMeasure,
                             unit: store.unit, records: records)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surfaceAlt))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - One exercise over time

struct ExerciseHistoryView: View {
    var exerciseName: String

    @Environment(WorkoutStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let days = PerformanceHistory.days(of: exerciseName, in: store.sessions)
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                HistoryHeader(title: exerciseName,
                              meta: ExerciseCatalog.exercise(named: exerciseName)?.trainerMeta ?? "",
                              onBack: { dismiss() })
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        if let record = PerformanceHistory.record(for: exerciseName, in: store.sessions) {
                            bests(record)
                        }

                        SectionEyebrow(text: "HISTORY")
                            .padding(.top, 26)
                        if days.isEmpty {
                            Text("No completed sets yet.")
                                .font(.ui(13))
                                .foregroundStyle(DS.silver.opacity(0.5))
                                .padding(.top, 10)
                        }
                        VStack(spacing: 0) {
                            ForEach(days) { day in
                                dayRow(day)
                                if day.id != days.last?.id { Hairline(opacity: 0.06) }
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 6)
                    .padding(.bottom, 32)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .restTimerInset()
    }

    private func bests(_ record: ExerciseRecord) -> some View {
        let unit = store.unit
        var tiles: [(label: String, value: String)] = []
        if let heaviest = record.heaviest, let weight = heaviest.weight {
            tiles.append(("Heaviest", "\(unit.format(weight)) × \(heaviest.reps)"))
        }
        if let best = record.bestSet, let estimate = best.estimatedMax {
            tiles.append(("Est. 1RM", unit.total(estimate)))
        }
        if let best = record.bestUnloaded {
            tiles.append(record.measure == .time
                         ? ("Longest hold", SetMeasure.clock(best.reps))
                         : ("Most reps", "\(best.reps)"))
        }
        tiles.append(("Days logged", "\(record.dayCount)"))
        return VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "PERSONAL RECORDS")
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                ForEach(tiles, id: \.label) { tile in
                    StatTile(label: tile.label, value: tile.value)
                }
            }
            Text("Est. 1RM uses the Epley formula on your best loaded set. A set marked PR beat every earlier set of this exercise.")
                .font(.ui(11.5))
                .cssLineHeight(11.5, 1.5)
                .foregroundStyle(DS.silver.opacity(0.4))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func dayRow(_ day: ExerciseDay) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(RecoveryText.day(day.day))
                    .font(.ui(14, .semibold))
                    .foregroundStyle(DS.silver)
                Spacer()
                if day.measure == .reps {
                    let volume = day.sets.reduce(0) { $0 + ($1.weight ?? 0) * Double($1.reps) }
                    if volume > 0 {
                        MetaLine(text: store.unit.total(volume).uppercased(), em: 0.06)
                    }
                }
            }
            SetChips(sets: day.sets, measure: day.measure, unit: store.unit, records: day.recordSetIDs)
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Shared

/// Logged sets as chips, records outlined and tagged.
struct SetChips: View {
    var sets: [WorkoutSet]
    var measure: SetMeasure
    var unit: WeightUnit
    var records: Set<UUID> = []

    var body: some View {
        FlowRow(spacing: 6) {
            ForEach(sets) { set in
                let isRecord = records.contains(set.id)
                HStack(spacing: 5) {
                    Text(SetText.short(set, measure: measure, unit: unit))
                        .font(.mono(11.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.8))
                    if isRecord {
                        Text("PR")
                            .font(.mono(8.5, .bold))
                            .trackingEm(0.08, size: 8.5)
                            .foregroundStyle(DS.silver)
                    }
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(Capsule().fill(DS.silver.opacity(0.06)))
                .overlay(Capsule().strokeBorder(DS.silver.opacity(isRecord ? 0.45 : 0), lineWidth: 1))
                .accessibilityLabel(SetText.short(set, measure: measure, unit: unit) + (isRecord ? ", personal record" : ""))
            }
        }
    }
}

/// Back button, title and meta line — the pushed-screen header used across
/// the app.
struct HistoryHeader: View {
    var title: String
    var meta: String
    var onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CircleIconButton(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel("Back")

            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.ui(16, .semibold))
                    .tracking(-0.25)
                    .foregroundStyle(DS.silver)
                    .lineLimit(1)
                MetaLine(text: meta)
                    .padding(.top, 3)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 11)
        .padding(.bottom, 10)
    }
}

private struct MissingHistory: View {
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Text("This workout is no longer in your history.")
                .font(.ui(14))
                .foregroundStyle(DS.silver.opacity(0.6))
            WideButton(title: "Back", prominent: false, action: onBack)
                .frame(width: 160)
        }
    }
}
