//
//  ExercisePickerView.swift
//  GymWorkout
//
//  Picks an exercise from the existing library: exercises that train the
//  current group first, then everything else. Search covers both.
//

import SwiftUI

struct ExercisePickerView: View {
    var group: MuscleGroup
    var title: String
    /// Names already in the group's list, marked rather than hidden.
    var alreadyAdded: Set<String> = []
    var onPick: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    private func matches(_ exercise: Exercise) -> Bool {
        query.isEmpty
            || exercise.name.localizedCaseInsensitiveContains(query)
            || exercise.meta.localizedCaseInsensitiveContains(query)
    }

    private var recommended: [Exercise] {
        ExerciseCatalog.exercises(for: group).filter(matches)
    }

    private var others: [Exercise] {
        let shown = Set(ExerciseCatalog.exercises(for: group).map(\.name))
        return SampleData.exercises.filter { !shown.contains($0.name) && matches($0) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 0) {
                    MetaLine(text: group.title.uppercased(), em: 0.10)
                    Text(title)
                        .font(.ui(22, .semibold))
                        .tracking(-0.45)
                        .foregroundStyle(DS.silver)
                        .padding(.top, 5)
                }
                Spacer()
                Button("Close") { dismiss() }
                    .font(.ui(13, .semibold))
                    .foregroundStyle(DS.silver)
                    .buttonStyle(.plain)
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.top, 24)

            searchField
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.top, 16)

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    if !recommended.isEmpty {
                        section("RECOMMENDED FOR \(group.title.uppercased())", recommended)
                    }
                    if !others.isEmpty {
                        section("ALL EXERCISES", others)
                    }
                    if recommended.isEmpty && others.isEmpty {
                        Text("No exercises match “\(query)”.")
                            .font(.ui(13))
                            .foregroundStyle(DS.silver.opacity(0.5))
                            .padding(.top, 30)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.bottom, 30)
            }
            .padding(.top, 6)
        }
        .background(DS.surface.ignoresSafeArea())
        .presentationDragIndicator(.visible)
        .presentationBackground(DS.surface)
        .presentationCornerRadius(DS.Metric.sheetRadius)
    }

    private var searchField: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(DS.silver.opacity(0.4))
            TextField("", text: $query,
                      prompt: Text("Search exercises").foregroundStyle(DS.silver.opacity(0.35)))
                .font(.ui(15))
                .foregroundStyle(DS.silver)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 11)
        .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(DS.surfaceDim))
        .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
            .strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
    }

    private func section(_ title: String, _ exercises: [Exercise]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionEyebrow(text: title, size: 10)
                .padding(.top, 18)
                .padding(.bottom, 6)
            ForEach(exercises) { exercise in
                Button {
                    onPick(exercise.name)
                    dismiss()
                } label: {
                    pickerRow(exercise)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func pickerRow(_ exercise: Exercise) -> some View {
        let role = ExerciseCatalog.role(of: group, in: exercise)
        return HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(DS.surfaceDim)
                .frame(width: 46, height: 46)
                .overlay(RenderSlot(id: exercise.slotID)
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous)))

            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.ui(14.5, .semibold))
                    .foregroundStyle(DS.silver)
                MetaLine(text: exercise.meta, size: 9, em: 0.05)
            }

            Spacer(minLength: 6)

            if alreadyAdded.contains(exercise.name) {
                tag("ADDED")
            } else if let role {
                tag(role == .primary ? "PRIMARY" : "SECONDARY")
            }
        }
        .padding(.vertical, 9)
        .overlay(alignment: .bottom) { Hairline(opacity: 0.06) }
        .contentShape(Rectangle())
    }

    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.mono(8.5, .semibold))
            .trackingEm(0.08, size: 8.5)
            .foregroundStyle(DS.silver.opacity(0.55))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(DS.silver.opacity(0.08)))
    }
}
