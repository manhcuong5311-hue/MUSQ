//
//  ExerciseLibraryView.swift
//  GymWorkout
//
//  Screen 1b — Exercise Library. The category filter is live.
//

import SwiftUI

struct ExerciseLibraryView: View {
    @Binding var tab: AppTab
    /// Pre-selects a category when arriving from a muscle group tile.
    var initialFilter: MuscleGroupName = .all

    @State private var filter: MuscleGroupName = .all
    @State private var query = ""
    @State private var path: [Exercise] = []

    private var visible: [Exercise] {
        SampleData.exercises.filter { exercise in
            let matchesCategory = filter == .all || exercise.category == filter
            let matchesQuery = query.isEmpty
                || exercise.name.localizedCaseInsensitiveContains(query)
                || exercise.meta.localizedCaseInsensitiveContains(query)
            return matchesCategory && matchesQuery
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                DS.ink.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    Text("Exercises")
                        .font(.ui(28, .semibold))
                        .tracking(-0.7)
                        .foregroundStyle(DS.silver)
                        .padding(.horizontal, DS.Metric.gutter)

                    searchField.padding(.top, 16)

                    filterChips.padding(.top, 14)

                    list.padding(.top, 14)
                }
                .padding(.top, 22)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            .navigationDestination(for: Exercise.self) { exercise in
                Exercise3DView(exercise: exercise)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(DS.silver)
        .onAppear { filter = initialFilter }
    }

    // MARK: - Search

    private var searchField: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(DS.silver.opacity(0.4))

            TextField(
                "",
                text: $query,
                prompt: Text("Search exercises")
                    .font(.ui(15))
                    .foregroundStyle(DS.silver.opacity(0.35))
            )
            .font(.ui(15))
            .foregroundStyle(DS.silver)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 11)
        .background(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(DS.surfaceDim)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .strokeBorder(DS.silver.opacity(0.07), lineWidth: 1)
        )
        .padding(.horizontal, DS.Metric.gutter)
    }

    // MARK: - Filters

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(MuscleGroupName.allCases) { group in
                    FilterChip(title: group.rawValue, selected: group == filter) {
                        withAnimation(.easeOut(duration: 0.18)) { filter = group }
                    }
                }
            }
            .padding(.horizontal, DS.Metric.gutter)
        }
    }

    // MARK: - Results

    private var list: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(visible) { exercise in
                    Button {
                        path.append(exercise)
                    } label: {
                        ExerciseRow(exercise: exercise)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, DS.Metric.gutter)
            .padding(.bottom, 8)
        }
    }
}

// MARK: - Row

struct ExerciseRow: View {
    var exercise: Exercise

    var body: some View {
        HStack(spacing: 13) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(DS.surfaceDim)
                .frame(width: 68, height: 68)
                .overlay(
                    RenderSlot(id: exercise.slotID)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                )

            VStack(alignment: .leading, spacing: 0) {
                Text(exercise.name)
                    .font(.ui(15, .semibold))
                    .tracking(-0.1)
                    .foregroundStyle(DS.silver)

                MetaLine(text: exercise.meta, em: 0.06)
                    .padding(.top, 5)

                HStack(spacing: 6) {
                    Circle()
                        .fill(exercise.difficulty.dotColor)
                        .frame(width: 5, height: 5)
                    Text(exercise.difficulty.rawValue)
                        .font(.mono(9, .semibold))
                        .trackingEm(0.09, size: 9)
                        .foregroundStyle(DS.silver.opacity(0.5))

                    // Not in the design doc: marks which exercises ship a 3D
                    // model, so it is visible before tapping in. Keyed on the
                    // model, not on `hasTrainer` — the badge claims "3D", and
                    // an exercise can have its model before its coaching.
                    if SampleData.model(for: exercise) != nil {
                        Text("3D")
                            .font(.mono(8.5, .semibold))
                            .trackingEm(0.10, size: 8.5)
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(DS.silver.opacity(0.08))
                            )
                    }
                }
                .padding(.top, 8)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.28))
        }
        .padding(.bottom, 10)
        .overlay(alignment: .bottom) { Hairline(opacity: 0.06) }
    }
}
