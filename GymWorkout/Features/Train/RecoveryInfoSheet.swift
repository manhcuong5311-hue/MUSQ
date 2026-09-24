//
//  RecoveryInfoSheet.swift
//  GymWorkout
//
//  Shown when a recently trained group is tapped. Informs, never blocks:
//  "Train Anyway" is always one tap away. A group with more than one part
//  (Shoulders, Back) is broken down by part, so it's clear what is actually
//  tired and what can still be trained.
//

import SwiftUI

struct RecoveryInfoSheet: View {
    var group: MuscleGroup
    var record: MuscleTrainingRecord
    var onViewExercises: () -> Void
    var onTrainAnyway: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var height: CGFloat = 440

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MetaLine(text: group.title.uppercased(), em: 0.10)
            Text(record.status.title)
                .font(.ui(22, .semibold))
                .tracking(-0.45)
                .foregroundStyle(DS.silver)
                .padding(.top, 5)

            Group {
                if record.mainParts.count > 1 || !record.sideNotes.isEmpty {
                    partList
                } else {
                    facts
                }
            }
            .padding(.top, 18)

            Text(message)
                .font(.ui(13))
                .cssLineHeight(13, 1.5)
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 18)

            HStack(spacing: 9) {
                WideButton(title: "View Exercises", prominent: false) {
                    dismiss()
                    onViewExercises()
                }
                WideButton(title: record.status == .partlyReady ? "Train" : "Train Anyway",
                           prominent: true) {
                    dismiss()
                    onTrainAnyway()
                }
            }
            .padding(.top, 22)

            Button("Cancel") { dismiss() }
                .font(.ui(13.5, .semibold))
                .foregroundStyle(DS.silver.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.top, 14)
                .buttonStyle(.plain)
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 26)
        .padding(.bottom, 12)
        // Fit the sheet to its content: the part list is longer for Back than
        // for Triceps.
        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { height = $0 + 20 }
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
        .presentationBackground(DS.surface)
        .presentationCornerRadius(DS.Metric.sheetRadius)
    }

    // MARK: - Single part

    private var facts: some View {
        VStack(alignment: .leading, spacing: 12) {
            fact("LAST TRAINED",
                 "\(RecoveryText.day(record.lastTrainedAt)) · \(RecoveryText.trainedAgo(record.lastTrainedAt))")
            fact("ESTIMATED RECOVERY TARGET", RecoveryText.hours(record.recoveryTargetHours))
            fact("APPROXIMATELY", record.hoursRemaining > 0
                 ? "\(RecoveryText.hours(record.hoursRemaining)) remaining" : "Ready")
        }
    }

    private func fact(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.mono(9, .semibold))
                .trackingEm(0.10, size: 9)
                .foregroundStyle(DS.silver.opacity(0.4))
            Text(value)
                .font(.ui(15))
                .foregroundStyle(DS.silver)
        }
    }

    // MARK: - By part

    /// The parts a session for the group works, then any other recent load
    /// in the group.
    private var partList: some View {
        let byPart = Dictionary(uniqueKeysWithValues: record.parts.map { ($0.part, $0) })
        let others = record.parts.filter { !record.mainParts.contains($0.part) && $0.status != .ready }
        return VStack(alignment: .leading, spacing: 12) {
            Text("BY MUSCLE")
                .font(.mono(9, .semibold))
                .trackingEm(0.10, size: 9)
                .foregroundStyle(DS.silver.opacity(0.4))
            ForEach(record.mainParts) { part in
                partRow(part, byPart[part])
            }
            ForEach(others) { entry in
                partRow(entry.part, entry)
            }
        }
    }

    private func partRow(_ part: MusclePart, _ entry: MusclePartRecord?) -> some View {
        let state = rowState(entry)
        return HStack(alignment: .firstTextBaseline, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(part.title)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                if let entry {
                    Text(detail(entry))
                        .font(.ui(12))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .lineLimit(1)
                }
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 3) {
                MuscleStateLabel(state: state)
                if let entry, entry.isTired {
                    Text(RecoveryText.remaining(entry.hoursRemaining))
                        .font(.ui(11.5))
                        .foregroundStyle(DS.silver.opacity(0.45))
                }
            }
        }
        .accessibilityElement(children: .combine)
    }

    /// "Helped today · Chest Press Machine +2".
    private func detail(_ entry: MusclePartRecord) -> String {
        guard let first = entry.exercises.first else { return RecoveryText.load(entry) }
        let more = entry.exercises.count > 1 ? " +\(entry.exercises.count - 1)" : ""
        return "\(RecoveryText.load(entry)) · \(first)\(more)"
    }

    /// Helper-only load is shown as ready: it never holds the group back.
    private func rowState(_ entry: MusclePartRecord?) -> MuscleCardState {
        guard let entry, entry.isTired else { return .ready }
        return MuscleCardState(entry.status)
    }

    // MARK: - Message

    private var message: String {
        switch record.status {
        case .partlyReady:
            let tired = RecoveryText.list(record.tiredParts.map(\.part)).lowercased()
            let ready = RecoveryText.list(record.readyParts).lowercased()
            return "Still recovering: \(tired) (trained \(RecoveryText.dayPhrase(record.lastTrainedAt))). "
                + "Ready: \(ready). You can still train \(group.title.lowercased()) — "
                + "go lighter on exercises that lean on the \(tired)."
        default:
            return "You trained this muscle recently. Recovery time is only an estimate and can vary."
        }
    }
}
