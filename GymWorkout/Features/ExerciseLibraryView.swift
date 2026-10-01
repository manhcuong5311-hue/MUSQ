//
//  ExerciseLibraryView.swift
//  GymWorkout
//
//  Screen 1b — Exercise Library. The category filter is live, plus a Saved
//  filter for the exercises hearted in the 3D view, and a level filter under
//  the button top right. Every option shows how many exercises it would
//  list, and the list says how many it shows.
//

import SwiftUI

struct ExerciseLibraryView: View {
    @Binding var tab: AppTab

    @Environment(WorkoutStore.self) private var store
    @State private var filter: MuscleGroupName = .all
    /// Only exercises saved with the heart; replaces the category filter.
    @State private var savedOnly = false
    /// Nil shows every level.
    @State private var level: Difficulty?
    @State private var query = ""
    @State private var path: [Exercise] = []

    private var visible: [Exercise] {
        SampleData.exercises.filter { inScope($0) && fits($0, level) && matchesQuery($0) }
    }

    // Each filter on its own, so a count can leave one out: a chip counts
    // what its group would list at the chosen level, a level what it would
    // list in the chosen group.

    private func inScope(_ exercise: Exercise) -> Bool {
        savedOnly ? store.isSaved(exercise.name) : inGroup(exercise, filter)
    }

    private func inGroup(_ exercise: Exercise, _ group: MuscleGroupName) -> Bool {
        group == .all || exercise.category == group
    }

    private func fits(_ exercise: Exercise, _ level: Difficulty?) -> Bool {
        level == nil || exercise.difficulty == level
    }

    private func matchesQuery(_ exercise: Exercise) -> Bool {
        query.isEmpty
            || exercise.name.localizedCaseInsensitiveContains(query)
            || exercise.meta.localizedCaseInsensitiveContains(query)
    }

    private func count(in group: MuscleGroupName) -> Int {
        SampleData.exercises.filter { inGroup($0, group) && fits($0, level) && matchesQuery($0) }.count
    }

    private var savedCount: Int {
        SampleData.exercises.filter { store.isSaved($0.name) && fits($0, level) && matchesQuery($0) }.count
    }

    private func count(at level: Difficulty?) -> Int {
        SampleData.exercises.filter { inScope($0) && fits($0, level) && matchesQuery($0) }.count
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                DS.ink.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Exercises")
                            .font(.ui(28, .semibold))
                            .tracking(-0.7)
                            .foregroundStyle(DS.silver)
                        Spacer()
                        levelMenu
                    }
                    .padding(.horizontal, DS.Metric.gutter)

                    searchField.padding(.top, 16)

                    filterChips.padding(.top, 14)

                    resultLine.padding(.top, 12)

                    list.padding(.top, 10)
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

    /// All levels, Beginner, Intermediate, Advanced — each with what it
    /// would list.
    private var levelMenu: some View {
        Menu {
            Section("Level") {
                levelOption(nil)
                ForEach(Difficulty.allCases, id: \.self) { levelOption($0) }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(level == nil ? DS.silver : DS.ink)
                .frame(width: 34, height: 34)
                .background(Circle().fill(level == nil ? DS.silver.opacity(0.08) : DS.silver))
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .menuOrder(.fixed)
        .accessibilityLabel(level.map { "Level filter, \($0.rawValue.capitalized)" } ?? "Level filter")
    }

    private func levelOption(_ option: Difficulty?) -> some View {
        let title = option?.rawValue.capitalized ?? "All levels"
        let count = count(at: option)
        return Button {
            withAnimation(.easeOut(duration: 0.18)) { level = option }
        } label: {
            if option == level {
                Label(title, systemImage: "checkmark")
            } else {
                Text(title)
            }
            Text("\(count) \(count == 1 ? "exercise" : "exercises")")
        }
    }

    /// How many the list shows, and the level filter when one is on, to
    /// clear it from here.
    private var resultLine: some View {
        HStack {
            MetaLine(text: "\(visible.count) \(visible.count == 1 ? "EXERCISE" : "EXERCISES")", em: 0.08)
            Spacer()
            if let level {
                Button {
                    withAnimation(.easeOut(duration: 0.18)) { self.level = nil }
                } label: {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(level.dotColor)
                            .frame(width: 5, height: 5)
                        Text(level.rawValue)
                            .font(.mono(9, .semibold))
                            .trackingEm(0.09, size: 9)
                        Image(systemName: "xmark")
                            .font(.system(size: 8, weight: .bold))
                    }
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(DS.silver.opacity(0.08)))
                    .contentShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear level filter, \(level.rawValue.capitalized)")
            }
        }
        .frame(minHeight: 24)
        .padding(.horizontal, DS.Metric.gutter)
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(MuscleGroupName.allCases) { group in
                    FilterChip(title: "\(group.rawValue) · \(count(in: group))", selected: !savedOnly && group == filter) {
                        withAnimation(.easeOut(duration: 0.18)) {
                            savedOnly = false
                            filter = group
                        }
                    }
                    if group == .all {
                        FilterChip(title: store.saved.isEmpty ? "Saved" : "Saved · \(savedCount)",
                                   selected: savedOnly) {
                            withAnimation(.easeOut(duration: 0.18)) { savedOnly = true }
                        }
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
                        ExerciseRow(exercise: exercise, isSaved: store.isSaved(exercise.name))
                    }
                    .buttonStyle(.plain)
                }
                if visible.isEmpty {
                    Text(savedOnly && query.isEmpty
                         ? "Tap the heart on any exercise to save it here."
                         : "No exercises match.")
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
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
    var isSaved = false

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
                    if isSaved {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .accessibilityLabel("Saved")
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
