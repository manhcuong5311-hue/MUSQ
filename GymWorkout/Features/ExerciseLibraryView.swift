//
//  ExerciseLibraryView.swift
//  GymWorkout
//
//  Screen 1b — Exercise Library. The category filter is live, plus a Saved
//  filter for the exercises hearted in the 3D view, and a level filter under
//  the button top right. Every option shows how many exercises it would
//  list, and the list says how many it shows.
//
//  On iPad (regular width) the list becomes a grid of thumbnail cards under
//  a large title, with the chips laid out flat when they fit. Wide windows
//  trade the chips and the level menu for a filter rail down the leading
//  side. The filtering itself is shared, so every layout counts the same.
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
    @FocusState private var searchFocused: Bool
    /// The grid's scroll view, for its column count; zero until measured.
    @State private var gridWidth: CGFloat = 0

    @Environment(\.dsLayout) private var layout

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

                if layout.isRegular {
                    regularPage
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Exercises")
                                .font(.ui(28, .semibold))
                                .tracking(-0.7)
                                .foregroundStyle(DS.silver)
                            Spacer()
                            levelMenu(diameter: 34)
                        }
                        .padding(.horizontal, DS.Metric.gutter)

                        searchField.padding(.top, 16)

                        filterChips.padding(.top, 14)

                        resultLine.padding(.top, 12)

                        list.padding(.top, 10)
                    }
                    .padding(.top, 22)
                }

                // ⌘F, while the library itself is on screen.
                if DS.isPad && path.isEmpty {
                    searchShortcut
                }
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
            .focused($searchFocused)
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
    private func levelMenu(diameter: CGFloat) -> some View {
        Menu {
            Section("Level") {
                levelOption(nil)
                ForEach(Difficulty.allCases, id: \.self) { levelOption($0) }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(level == nil ? DS.silver : DS.ink)
                .frame(width: diameter, height: diameter)
                .background(Circle().fill(level == nil ? DS.silver.opacity(0.08) : DS.silver))
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .menuOrder(.fixed)
        .dsHover(.highlight)
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
            MetaLine(text: resultText, em: 0.08)
            Spacer()
            if let level {
                clearLevelButton(level)
            }
        }
        .frame(minHeight: 24)
        .padding(.horizontal, DS.Metric.gutter)
    }

    private var resultText: String {
        "\(visible.count) \(visible.count == 1 ? "EXERCISE" : "EXERCISES")"
    }

    /// `size` is the label's mono size: 9 beside the phone's result line,
    /// 10 beside the larger iPad one.
    private func clearLevelButton(_ level: Difficulty, size: CGFloat = 9) -> some View {
        Button {
            withAnimation(.easeOut(duration: 0.18)) { self.level = nil }
        } label: {
            HStack(spacing: 5) {
                Circle()
                    .fill(level.dotColor)
                    .frame(width: 5, height: 5)
                Text(level.rawValue)
                    .font(.mono(size, .semibold))
                    .trackingEm(0.09, size: size)
                Image(systemName: "xmark")
                    .font(.system(size: size - 1, weight: .bold))
            }
            .foregroundStyle(DS.silver.opacity(0.75))
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(Capsule().fill(DS.silver.opacity(0.08)))
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight)
        .accessibilityLabel("Clear level filter, \(level.rawValue.capitalized)")
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                chipButtons
            }
            .padding(.horizontal, DS.Metric.gutter)
        }
    }

    /// All, Saved, then the groups, each with what it would list.
    @ViewBuilder
    private var chipButtons: some View {
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

    // MARK: - Regular (iPad)

    /// Wide windows put a filter rail beside the grid; narrower ones keep the
    /// search and chips above it. The rail and the controls above are
    /// optional slots around one grid, so a resize across the two keeps the
    /// grid — and its scroll position — rather than building a new one.
    private var regularPage: some View {
        VStack(alignment: .leading, spacing: 0) {
            regularHeader
                .dsGutter()

            if !layout.isWide {
                VStack(alignment: .leading, spacing: 0) {
                    regularSearchField
                        .dsReadable(520, alignment: .leading)
                        .dsGutter()

                    regularChips
                        .padding(.top, 16)
                }
                .padding(.top, 18)
            }

            HStack(alignment: .top, spacing: layout.isWide ? layout.paneGap - Self.liftRoom : 0) {
                if layout.isWide {
                    filterRail
                        .frame(width: Self.railWidth)
                        .padding(.top, Self.liftRoom)
                }
                grid
            }
            .padding(.leading, layout.isWide ? layout.gutter : 0)
            .padding(.top, layout.isWide ? 24 - Self.liftRoom : 20 - Self.liftRoom)
        }
        .padding(.top, 28)
    }

    private static let railWidth: CGFloat = 232
    /// Clear space around the grid inside its scroll view, so a card lifting
    /// under the pointer isn't clipped at the scroll view's edge.
    private static let liftRoom: CGFloat = 6

    /// The large title with the count under it. Wide windows put the search
    /// beside it; the level filter is then in the rail.
    private var regularHeader: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Exercises")
                    .font(.ui(layout.text(.largeTitle), .semibold))
                    .tracking(layout.largeTitleTracking)
                    .foregroundStyle(DS.silver)

                HStack(spacing: 10) {
                    MetaLine(text: resultText, em: 0.08)
                    if !layout.isWide, let level {
                        clearLevelButton(level, size: 10)
                            .transition(.opacity)
                    }
                }
                .frame(minHeight: 22, alignment: .leading)
            }

            Spacer(minLength: 24)

            if layout.isWide {
                regularSearchField
                    .frame(width: 340)
            } else {
                levelMenu(diameter: 40)
            }
        }
    }

    private var regularSearchField: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .medium))
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
            .submitLabel(.search)
            .focused($searchFocused)

            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(DS.silver.opacity(0.3))
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 13)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(DS.surfaceDim)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(DS.silver.opacity(searchFocused ? 0.2 : 0.07), lineWidth: 1)
        )
        .animation(.easeOut(duration: 0.15), value: searchFocused)
    }

    /// Flat when every chip fits across, scrolling as on the phone when not.
    private var regularChips: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) { chipButtons }
                .dsGutter()
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) { chipButtons }
                    .dsGutter()
            }
        }
    }

    private var searchShortcut: some View {
        Button("Search") { searchFocused = true }
            .keyboardShortcut("f", modifiers: .command)
            .frame(width: 0, height: 0)
            .opacity(0)
            .accessibilityHidden(true)
            .allowsHitTesting(false)
    }

    // MARK: Filter rail (wide)

    /// The chips and the level menu as one list down the leading side. It
    /// hugs its rows, and only scrolls when the window is too short for them.
    private var filterRail: some View {
        ViewThatFits(in: .vertical) {
            railContent
            ScrollView(showsIndicators: false) { railContent }
        }
        .dsPane()
        .padding(.bottom, 16)
    }

    private var railContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            railEyebrow("BROWSE")

            railRow("All", count: count(in: .all), isOn: !savedOnly && filter == .all) {
                GroupGlyph(group: .all, isOn: !savedOnly && filter == .all)
            } action: {
                savedOnly = false
                filter = .all
            }

            railRow("Saved", count: savedCount, isOn: savedOnly) {
                Image(systemName: savedOnly ? "heart.fill" : "heart")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(DS.silver.opacity(savedOnly ? 1 : 0.55))
            } action: {
                savedOnly = true
            }

            ForEach(MuscleGroupName.allCases.filter { $0 != .all }) { group in
                let isOn = !savedOnly && filter == group
                railRow(group.rawValue, count: count(in: group), isOn: isOn) {
                    GroupGlyph(group: group, isOn: isOn)
                } action: {
                    savedOnly = false
                    filter = group
                }
            }

            railEyebrow("LEVEL")
                .padding(.top, 18)

            railRow("All levels", count: count(at: nil), isOn: level == nil) {
                Circle()
                    .strokeBorder(DS.silver.opacity(level == nil ? 0.8 : 0.4), lineWidth: 1.2)
                    .frame(width: 9, height: 9)
            } action: {
                level = nil
            }

            ForEach(Difficulty.allCases, id: \.self) { option in
                railRow(option.rawValue.capitalized, count: count(at: option), isOn: level == option) {
                    Circle()
                        .fill(option.dotColor)
                        .frame(width: 8, height: 8)
                } action: {
                    level = option
                }
            }
        }
        .padding(10)
    }

    private func railEyebrow(_ text: String) -> some View {
        SectionEyebrow(text: text)
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .padding(.bottom, 6)
    }

    /// A 44pt row: glyph, name, and what it would list. Selection is the tab
    /// bar's own silver wash, so the rail reads as navigation, not as a
    /// form.
    private func railRow<Glyph: View>(
        _ title: String, count: Int, isOn: Bool,
        @ViewBuilder glyph: () -> Glyph,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            withAnimation(.easeOut(duration: 0.18)) { action() }
        } label: {
            HStack(spacing: 12) {
                glyph()
                    .frame(width: 20, height: 28)
                Text(title)
                    .font(.ui(15, isOn ? .semibold : .medium))
                    .foregroundStyle(isOn ? DS.silver : DS.silver.opacity(0.6))
                    .lineLimit(1)
                Spacer(minLength: 8)
                Text("\(count)")
                    .font(.mono(10.5, .semibold))
                    .trackingEm(0.04, size: 10.5)
                    .foregroundStyle(DS.silver.opacity(isOn ? 0.6 : 0.35))
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background {
                if isOn {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(DS.silver.opacity(0.09))
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: 12)
        .accessibilityLabel("\(title), \(count) \(count == 1 ? "exercise" : "exercises")")
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }

    // MARK: Grid

    private var grid: some View {
        let items = visible
        let spacing: CGFloat = 16
        let inset = gridInsets
        let measured = gridWidth > 0 ? gridWidth : fallbackGridWidth
        let available = max(0, measured - inset.leading - inset.trailing)
        // Three across from an iPad mini up. Only a Split View narrower than
        // that drops to two, rather than squeezing three cards to ~140pt.
        let columns = layout.columnCount(fitting: available, minimum: DS.Layout.gridCardMin,
                                         spacing: spacing, range: 2...5)
        // Past 240pt the 400px thumbnails go soft, so the grid stops
        // growing there and leaves the rest of the row empty.
        let widest = CGFloat(columns) * DS.Layout.gridCardMax + CGFloat(columns - 1) * spacing

        return ScrollView(showsIndicators: false) {
            Group {
                if items.isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: DS.flexibleColumns(columns, spacing: spacing),
                              alignment: .leading, spacing: 24) {
                        ForEach(items) { exercise in
                            card(exercise)
                        }
                    }
                    .frame(maxWidth: widest, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(inset)
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { gridWidth = $0 }
    }

    /// The rail's own gutter is outside the scroll view; the narrower layout
    /// pads the grid itself, so the scroll view (and a lifted card) runs to
    /// the screen edge.
    private var gridInsets: EdgeInsets {
        EdgeInsets(top: Self.liftRoom,
                   leading: layout.isWide ? Self.liftRoom : layout.gutter,
                   bottom: 28,
                   trailing: layout.gutter)
    }

    /// What the grid will measure, for the first pass before it has.
    private var fallbackGridWidth: CGFloat {
        let rail = layout.isWide ? Self.railWidth + layout.paneGap - Self.liftRoom + layout.gutter : 0
        return max(0, layout.containerWidth - rail)
    }

    private func card(_ exercise: Exercise) -> some View {
        let isSaved = store.isSaved(exercise.name)
        return Button {
            path.append(exercise)
        } label: {
            ExerciseCard(exercise: exercise, isSaved: isSaved)
        }
        .buttonStyle(CardPressStyle())
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20, style: .continuous))
        .contextMenu {
            Button {
                store.toggleSaved(exercise.name)
            } label: {
                Label(isSaved ? "Remove from Saved" : "Save", systemImage: isSaved ? "heart.slash" : "heart")
            }
            let inToday = store.isInToday(exercise.name)
            Button {
                store.addToToday(exerciseNamed: exercise.name)
            } label: {
                Label(inToday ? "In Today" : "Add to Today", systemImage: inToday ? "checkmark" : "plus")
            }
            .disabled(inToday)
        }
    }

    private var emptyState: some View {
        let savedHint = savedOnly && query.isEmpty
        return VStack(spacing: 14) {
            Image(systemName: savedHint ? "heart" : "magnifyingglass")
                .font(.system(size: 28, weight: .light))
                .foregroundStyle(DS.silver.opacity(0.3))
            Text(savedHint
                 ? "Tap the heart on any exercise to save it here."
                 : "No exercises match.")
                .font(.ui(15))
                .cssLineHeight(15, 1.45)
                .multilineTextAlignment(.center)
                .foregroundStyle(DS.silver.opacity(0.5))
                .frame(maxWidth: 320)
        }
        .frame(maxWidth: .infinity)
        // Centred a little above the middle of what the grid would fill.
        .containerRelativeFrame(.vertical) { height, _ in height * 0.8 }
    }
}

// MARK: - Card (iPad)

/// One exercise in the iPad grid: the render as a square tile, with what
/// the phone row puts in its meta line — 3D, saved, level — pinned to the
/// tile as glass. No chevron; the whole card opens the trainer.
struct ExerciseCard: View {
    var exercise: Exercise
    var isSaved = false

    private var hasModel: Bool { SampleData.model(for: exercise) != nil }

    private var tile: RoundedRectangle {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            thumbnail

            Text(exercise.name)
                .font(.ui(15.5, .semibold))
                .tracking(-0.15)
                .foregroundStyle(DS.silver)
                .multilineTextAlignment(.leading)
                // Two lines held for every card, so a row's names and meta
                // lines stay level.
                .lineLimit(2, reservesSpace: true)
                .padding(.top, 12)

            // 10pt rather than the regular 10.5, so a muscle and its
            // equipment still fit across the narrowest card.
            MetaLine(text: exercise.meta, size: 10, em: 0.06)
                .lineLimit(1)
                .padding(.top, 5)
        }
        .frame(maxWidth: DS.Layout.gridCardMax, alignment: .leading)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }

    private var thumbnail: some View {
        tile
            .fill(DS.surfaceDim)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                RenderSlot(id: exercise.slotID)
                    .clipShape(tile)
            }
            .overlay {
                tile.strokeBorder(DS.silver.opacity(0.07), lineWidth: 1)
            }
            .overlay(alignment: .topTrailing) {
                badges.padding(10)
            }
            .overlay(alignment: .bottomLeading) {
                difficulty.padding(10)
            }
            .dsHover(.lift, radius: 20)
    }

    @ViewBuilder
    private var badges: some View {
        // Keyed on the model, like the row's badge: it claims "3D".
        if hasModel || isSaved {
            HStack(spacing: 6) {
                if hasModel {
                    Text("3D")
                        .font(.mono(9, .semibold))
                        .trackingEm(0.10, size: 9)
                }
                if isSaved {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 9.5, weight: .semibold))
                        .accessibilityLabel("Saved")
                }
            }
            .foregroundStyle(DS.silver.opacity(0.75))
            .glassPill()
        }
    }

    private var difficulty: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(exercise.difficulty.dotColor)
                .frame(width: 5, height: 5)
            Text(exercise.difficulty.rawValue)
                .font(.mono(9, .semibold))
                .trackingEm(0.09, size: 9)
                .foregroundStyle(DS.silver.opacity(0.7))
        }
        .glassPill()
    }
}

private extension View {
    /// The capsule of glass a badge sits in over a card's render.
    func glassPill() -> some View {
        padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Capsule().fill(DS.glass(0.72)))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
    }
}

/// A card gives a little under the finger.
private struct CardPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// A body the size of a glyph with the group lit: the filter rail's icon
/// for each muscle group, drawn from the same map as the Muscles tab.
private struct GroupGlyph: View {
    var group: MuscleGroupName
    var isOn: Bool

    var body: some View {
        // "All" lights the whole figure, so it is lit softer to weigh no more
        // than a single group does.
        let color = group == .all
            ? DS.silver.opacity(isOn ? 0.6 : 0.35)
            : DS.silver.opacity(isOn ? 0.9 : 0.5)
        BodyMapCanvas(side: group == .back ? .back : .front,
                      fills: Dictionary(regions.map { ($0, color) }, uniquingKeysWith: { a, _ in a }),
                      lineWidth: 0.4)
            .frame(width: 26 * BodyMapCanvas.aspect, height: 26)
            .accessibilityHidden(true)
    }

    private var regions: [BodyRegion] {
        switch group {
        case .all:
            return [.chest, .obliques, .abs, .biceps, .triceps, .trapezius, .deltoids,
                    .adductors, .quadriceps, .tibialis, .calves, .forearm]
        case .chest: return [.chest]
        case .back: return [.upperBack, .lowerBack, .trapezius]
        case .shoulders: return [.deltoids]
        case .arms: return [.biceps, .triceps, .forearm]
        case .legs: return [.quadriceps, .adductors, .tibialis, .calves]
        case .core: return [.abs, .obliques]
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
