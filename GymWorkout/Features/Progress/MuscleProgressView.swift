//
//  MuscleProgressView.swift
//  GymWorkout
//
//  Tab 3. "What have I actually trained, and what am I missing?" — the
//  totals, the body map lit by completed sets this week or month, the groups
//  worth a look, the full list, personal records, and the workout history
//  they come from. Planned-but-unfinished sets never count.
//
//  On iPad the same sections get room: a single centred column with both
//  sides of the body at once in regular, and in wide a pinned hero pane
//  beside a scrolling one. Picking a group in either lights it alone on the
//  hero. iPhone keeps its own tree, untouched.
//

import SwiftUI

struct MuscleProgressView: View {
    @Binding var tab: AppTab

    @Environment(WorkoutStore.self) private var store
    @Environment(\.dsLayout) private var layout
    @State private var router = TrainRouter()
    @State private var period: ActivityPeriod = .week
    @State private var side: BodySide = .front
    @State private var showsAllRecords = false
    /// Pages of history shown, so the page can grow on iPad (10) without
    /// changing what "Show more" adds on iPhone (8).
    @State private var historyPages = 1
    /// iPad: the group picked in the activity list or Needs Attention, lit
    /// alone on the hero. Selection, so it is silver on the row, never
    /// activation.
    @State private var highlighted: MuscleGroup?

    private var recordPreview: Int { layout.value(5, 6) }
    private var historyPage: Int { layout.value(8, 10) }
    private var historyLimit: Int { historyPages * historyPage }

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

                if layout.isWide {
                    dashboard(activity)
                } else if layout.isRegular {
                    column(activity)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Muscle Progress")
                                .font(.ui(28, .semibold))
                                .tracking(-0.7)
                                .foregroundStyle(DS.silver)

                            stats
                                .padding(.top, 18)

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
            }
            .background {
                if DS.isPad { periodShortcuts }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            .statusBarScrim()
            .trainDestinations()
            .toolbar(.hidden, for: .navigationBar)
        }
        .environment(router)
        .tint(DS.silver)
    }

    private var loggedSessions: [WorkoutSession] {
        store.sessions.filter(\.hasCompletedSets).sorted { $0.day > $1.day }
    }

    // MARK: - Totals

    private var stats: some View {
        let week = weekTotals
        return HStack(spacing: 8) {
            StatTile(label: "Workouts", value: loggedSessions.count.formatted())
            StatTile(label: "This week", value: week.count.formatted())
            StatTile(label: "Volume this week",
                     value: StatTile.compact(store.unit.fromKilograms(week.volume)),
                     unit: store.unit.symbol)
        }
    }

    /// Workouts logged this calendar week, and their volume in kilograms.
    private var weekTotals: (count: Int, volume: Double) {
        let week = Calendar.current.dateInterval(of: .weekOfYear, for: Date())
            ?? DateInterval(start: Date(), duration: 0)
        let thisWeek = PerformanceHistory.sessions(in: week, from: store.sessions)
        return (thisWeek.count, thisWeek.reduce(0) { $0 + $1.volume })
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
                        // No preset reaches these groups, so say where their
                        // exercises are.
                        Text(!trainable.contains(entry.muscle) && entry.level == .notTrained
                             ? "Not trained · add exercises from the Exercises tab"
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
    // MARK: - Personal records

    @ViewBuilder
    private var records: some View {
        let all = PerformanceHistory.records(in: store.sessions)
        let shown = showsAllRecords ? all : Array(all.prefix(recordPreview))
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "PERSONAL RECORDS")
                Spacer()
                if !all.isEmpty {
                    MetaLine(text: "\(all.count) \(all.count == 1 ? "EXERCISE" : "EXERCISES")", em: 0.08)
                }
            }
            if all.isEmpty {
                logNote("Your best set for each exercise shows up here once you mark sets done in Train.")
            } else {
                recordList(shown)
                if all.count > recordPreview {
                    moreButton(showsAllRecords ? "Show fewer" : "Show all \(all.count)") {
                        withAnimation(.easeOut(duration: 0.2)) { showsAllRecords.toggle() }
                    }
                }
            }
        }
    }

    /// Hairline rows; in regular they sit in one grouped card, inset so a
    /// row's hover and its corners stay concentric with the card's.
    @ViewBuilder
    private func recordList(_ shown: [ExerciseRecord]) -> some View {
        let regular = layout.isRegular
        let rows = VStack(spacing: 0) {
            ForEach(shown) { record in
                Button {
                    router.push(.exerciseHistory(record.exerciseName))
                } label: {
                    RecordRow(record: record, unit: store.unit)
                }
                .buttonStyle(.plain)
                if record.id != shown.last?.id {
                    Hairline(opacity: 0.06)
                        .padding(.horizontal, regular ? Self.rowInset : 0)
                }
            }
        }
        if regular {
            rows
                .padding(Self.cardInset)
                .dsPane(radius: Self.groupedRadius, fill: DS.surfaceAlt)
        } else {
            rows
        }
    }

    // MARK: - History

    @ViewBuilder
    private var history: some View {
        let sessions = loggedSessions
        VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: "HISTORY")
            if sessions.isEmpty {
                logNote("Every workout with a set marked done is listed here, newest first.")
            } else {
                ForEach(sessions.prefix(historyLimit)) { session in
                    Button {
                        router.push(.session(session.id))
                    } label: {
                        SessionRow(session: session, unit: store.unit)
                    }
                    .buttonStyle(.plain)
                }
                if sessions.count > historyLimit {
                    moreButton("Show more") {
                        withAnimation(.easeOut(duration: 0.2)) { historyPages += 1 }
                    }
                }
            }
        }
    }

    private func logNote(_ text: String) -> some View {
        Text(text)
            .font(.ui(13))
            .cssLineHeight(13, 1.5)
            .foregroundStyle(DS.silver.opacity(0.5))
            .fixedSize(horizontal: false, vertical: true)
            .dsReadable(560, alignment: .leading)
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
        .dsHover(.highlight, radius: 12)
    }

    fileprivate static func weight(_ role: ContributionRole) -> String {
        let w = role.defaultWeight
        return w.rounded() == w ? String(Int(w)) : String(w)
    }
}

// MARK: - iPad

extension MuscleProgressView {
    /// Gap between the hero pane and the scrolling one in wide.
    private static let paneGap: CGFloat = 32
    /// The regular column's cap.
    private static let columnMax: CGFloat = 820
    /// The wide right pane's cap; the dashboard's own cap reaches it first.
    private static let rightPaneMax: CGFloat = 760
    /// The right pane keeps at least this much before the hero pane grows.
    private static let rightPaneMin: CGFloat = 480
    /// Grouped list cards: the card's radius, the inset of its rows, and the
    /// rows' own padding — 20 − 6 keeps a row's hover concentric.
    private static let groupedRadius: CGFloat = 20
    private static let cardInset: CGFloat = 6
    private static let rowInset: CGFloat = 12
    /// Front and back side by side, as wide as they are tall: two figures
    /// plus `BodyMapPair`'s 0.10·h gap.
    private static let pairAspect: CGFloat = 2 * BodyMapCanvas.aspect + 0.10
    /// FRONT/BACK under the figures: 8pt gap and a 9.5pt mono line.
    private static let captionHeight: CGFloat = 22
    /// The legend at its tallest, wrapped onto two rows in a narrow pane.
    private static let legendHeight: CGFloat = 36
    private static let heroPadding: CGFloat = 24

    /// Widths the iPad sections break on, worked out from the content column
    /// rather than measured, so a section never lays out twice.
    private var columnWidth: CGFloat {
        min(Self.columnMax, max(320, layout.containerWidth - 2 * layout.gutter))
    }

    /// The pinned hero pane. The figures are bound by the pane's width long
    /// before its height, so the pane takes what the right pane can spare
    /// (keeping it at least 480 wide), between 400 and 520.
    private var heroPaneWidth: CGFloat {
        let content = min(DS.Layout.dashboardMaxWidth, layout.containerWidth - 2 * layout.gutter)
        return min(520, max(400, content - Self.paneGap - Self.rightPaneMin))
    }

    private var rightPaneWidth: CGFloat {
        let content = min(DS.Layout.dashboardMaxWidth, layout.containerWidth - 2 * layout.gutter)
        return min(Self.rightPaneMax, max(320, content - Self.paneGap - heroPaneWidth))
    }

    // MARK: Regular

    /// One centred column: the same sections as the phone, with both sides
    /// of the body at once and the lists side by side.
    private func column(_ activity: [MuscleActivity]) -> some View {
        let width = columnWidth
        let figure = min(440, ((width - 2 * Self.heroPadding) / Self.pairAspect).rounded(.down))
        return ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: layout.sectionSpacing) {
                header
                statGrid(activity, width: width)
                VStack(alignment: .leading, spacing: 16) {
                    heroCard(activity, figure: .fixed(figure))
                    if activity.allSatisfy({ $0.level == .notTrained }) {
                        emptyNote.dsReadable(560, alignment: .leading)
                    }
                }
                attentionGrid(activity, width: width)
                activitySection(activity, width: width)
                recordsAndHistory(width: width)
            }
            .dsReadable(Self.columnMax)
            .dsGutter()
            .padding(.top, 24)
            .padding(.bottom, 40)
        }
    }

    // MARK: Wide

    /// The hero pinned on the leading side, everything else scrolling beside
    /// it, so the body map stays in view while the lists are read — and
    /// lights whichever group is picked there.
    private func dashboard(_ activity: [MuscleActivity]) -> some View {
        let pane = heroPaneWidth
        let right = rightPaneWidth
        return HStack(alignment: .top, spacing: Self.paneGap) {
            heroPane(activity, width: pane)
                .frame(width: pane)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: layout.sectionSpacing) {
                    statGrid(activity, width: right)
                    if activity.allSatisfy({ $0.level == .notTrained }) {
                        emptyNote.dsReadable(560, alignment: .leading)
                    }
                    attentionGrid(activity, width: right)
                    activitySection(activity, width: right)
                    recordsAndHistory(width: right)
                }
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            // Lets a lifted card's shadow spill into the pane gap instead of
            // being cut at the scroll view's edge.
            .scrollClipDisabled()
            .frame(maxWidth: Self.rightPaneMax)
        }
        .dsReadable(DS.Layout.dashboardMaxWidth)
        .dsGutter()
    }

    /// Title, period and the hero filling the rest of the pane. A pane too
    /// short for the smallest figure (a mini in landscape with the rest bar
    /// and an ad up) scrolls instead of clipping.
    private func heroPane(_ activity: [MuscleActivity], width: CGFloat) -> some View {
        ViewThatFits(in: .vertical) {
            heroPaneStack(activity, width: width)
            ScrollView(showsIndicators: false) {
                heroPaneStack(activity, width: width)
            }
        }
    }

    private func heroPaneStack(_ activity: [MuscleActivity], width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            heroCard(activity, figure: .fills(width: width - 2 * Self.heroPadding))
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .padding(.top, 24)
        .padding(.bottom, 24)
    }

    // MARK: Header

    /// The large title with the period beside it, or under it where the two
    /// don't fit on one line (the wide hero pane, narrow regular windows).
    private var header: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .center, spacing: 0) {
                largeTitle
                Spacer(minLength: 24)
                periodControl
                    .frame(width: 280)
            }
            VStack(alignment: .leading, spacing: 16) {
                largeTitle
                periodControl
                    .frame(maxWidth: 360, alignment: .leading)
            }
        }
    }

    private var largeTitle: some View {
        Text("Muscle Progress")
            .font(.ui(layout.text(.largeTitle), .semibold))
            .tracking(layout.largeTitleTracking)
            .foregroundStyle(DS.silver)
            .lineLimit(1)
            .accessibilityAddTraits(.isHeader)
    }

    private var periodControl: some View {
        MonoSegmentedControl(
            options: [(ActivityPeriod.week, "THIS WEEK"), (.month, "THIS MONTH")],
            selection: $period,
            fontSize: 10,
            itemPaddingV: 8,
            fillsWidth: true
        )
    }

    /// ⌥⌘1 / ⌥⌘2 pick the week or the month. Plain ⌘1–4 belong to the
    /// sidebar's tabs.
    private var periodShortcuts: some View {
        ZStack {
            Button("This Week") { period = .week }
                .keyboardShortcut("1", modifiers: [.command, .option])
            Button("This Month") { period = .month }
                .keyboardShortcut("2", modifiers: [.command, .option])
        }
        .frame(width: 0, height: 0)
        .opacity(0)
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    // MARK: Totals

    /// Four tiles: the phone's three plus how many groups the period reached.
    /// One row once each tile can hold "Volume this week" unshrunk, else 2×2.
    private func statGrid(_ activity: [MuscleActivity], width: CGFloat) -> some View {
        let week = weekTotals
        let trained = activity.filter { $0.level != .notTrained }.count
        let columns = width >= 560 ? 4 : 2
        return LazyVGrid(columns: DS.flexibleColumns(columns, spacing: 12), spacing: 12) {
            StatTile(label: "Workouts", value: loggedSessions.count.formatted())
            StatTile(label: "This week", value: week.count.formatted())
            StatTile(label: "Volume this week",
                     value: StatTile.compact(store.unit.fromKilograms(week.volume)),
                     unit: store.unit.symbol)
            StatTile(label: "Groups trained", value: trained.formatted(), unit: "/\(activity.count)")
        }
    }

    // MARK: Hero

    enum HeroFigure {
        /// Figures this tall, the card hugging them.
        case fixed(CGFloat)
        /// The card fills the height it's given and the figures grow into
        /// it, up to what `width` allows.
        case fills(width: CGFloat)
    }

    /// Front and back together on the studio ground, no toggle.
    private func heroCard(_ activity: [MuscleActivity], figure: HeroFigure) -> some View {
        let fills = heroFills(activity)
        let spacing: CGFloat = 18
        return Group {
            switch figure {
            case .fixed(let height):
                VStack(spacing: spacing) {
                    pair(fills, height: height, activity: activity)
                    legend
                }
            case .fills(let width):
                // The pane is far taller than its width lets the figures
                // grow, so the figures and legend sit together in the middle
                // of the stage rather than the legend pinned to its floor.
                // The pair grows with the pane up to 620, never past the
                // width, and never under the floor that triggers scrolling.
                let widthBound = (width / Self.pairAspect).rounded(.down)
                let reserved = Self.captionHeight + spacing + Self.legendHeight
                GeometryReader { geo in
                    let height = min(widthBound, 620, geo.size.height - reserved).rounded(.down)
                    VStack(spacing: spacing) {
                        pair(fills, height: max(120, height), activity: activity)
                        legend
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                // No taller than the figures at full width need: a portrait
                // pane is far taller than that, and the card would otherwise
                // stand mostly empty around them.
                .frame(minHeight: min(320, widthBound) + reserved,
                       maxHeight: min(widthBound, 620) + reserved)
            }
        }
        .padding(Self.heroPadding)
        .frame(maxWidth: .infinity)
        .background(
            ViewportGround(inner: DS.viewportInner, outer: DS.viewportOuter,
                           rx: 0.55, ry: 0.75, cx: 0.5, cy: 0.45, aspectLocked: true)
                .clipShape(RoundedRectangle(cornerRadius: DS.Metric.viewportRadius, style: .continuous))
        )
        .overlay(alignment: .topLeading) {
            if let group = highlighted, let entry = activity.first(where: { $0.muscle == group }) {
                highlightPill(entry)
                    .padding(14)
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.2), value: highlighted)
    }

    private func pair(_ fills: [BodyRegion: Color], height: CGFloat,
                      activity: [MuscleActivity]) -> some View {
        BodyMapPair(source: .fills(front: fills, back: fills), figureHeight: height)
            .accessibilityElement(children: .contain)
            .accessibilityLabel(accessibilityText(activity))
    }

    /// The period's fills; with a group picked, that group at full strength
    /// (or silver, to show where it is, if it wasn't trained) and every other
    /// group at 40%.
    private func heroFills(_ activity: [MuscleActivity]) -> [BodyRegion: Color] {
        var fills: [BodyRegion: Color] = [:]
        for entry in activity {
            let color: Color?
            if let focus = highlighted {
                color = entry.muscle == focus
                    ? entry.level.color ?? DS.silver.opacity(0.5)
                    : entry.level.color?.opacity(0.4)
            } else {
                color = entry.level.color
            }
            guard let color else { continue }
            for region in entry.muscle.bodyRegions { fills[region] = color }
        }
        return fills
    }

    /// The picked group, named on the hero; tapping it clears the pick.
    private func highlightPill(_ entry: MuscleActivity) -> some View {
        Button {
            toggleHighlight(entry.muscle)
        } label: {
            HStack(spacing: 8) {
                Text("\(entry.muscle.title.uppercased()) · \(entry.setsLabel.uppercased())")
                    .font(.mono(10, .semibold))
                    .trackingEm(0.08, size: 10)
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(DS.silver.opacity(0.6))
            }
            .foregroundStyle(DS.silver)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Capsule().fill(DS.glass(0.72)))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.12), lineWidth: 1))
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .dsHover(.highlight)
        .accessibilityLabel("Showing \(entry.muscle.title) on the body map")
        .accessibilityHint("Shows every group again")
    }

    /// Centred under the figures; two rows where one won't fit.
    private var legend: some View {
        let levels: [ActivityLevel] = [.notTrained, .low, .trained, .high]
        return ViewThatFits(in: .horizontal) {
            HStack(spacing: 18) {
                ForEach(levels, id: \.self) { legendItem($0) }
            }
            Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 8) {
                GridRow { legendItem(levels[0]); legendItem(levels[1]) }
                GridRow { legendItem(levels[2]); legendItem(levels[3]) }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func legendItem(_ level: ActivityLevel) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 3.5, style: .continuous)
                .fill(level.color ?? DS.silver.opacity(0.13))
                .frame(width: 12, height: 12)
            Text(level.title.uppercased())
                .font(.mono(9.5, .semibold))
                .trackingEm(0.05, size: 9.5)
                .foregroundStyle(DS.silver.opacity(0.5))
                .lineLimit(1)
        }
    }

    private func toggleHighlight(_ group: MuscleGroup) {
        withAnimation(.easeOut(duration: 0.2)) {
            highlighted = highlighted == group ? nil : group
        }
    }

    // MARK: Needs attention

    /// Two across once a card can hold its title beside the map; its two
    /// actions stack where they wouldn't fit side by side.
    @ViewBuilder
    private func attentionGrid(_ activity: [MuscleActivity], width: CGFloat) -> some View {
        let items = calculator.needsAttention(activity, period: period,
                                              candidates: PresetProvider.trainableGroups)
        if !items.isEmpty {
            // A lone card takes the row rather than leaving half of it empty.
            let columns = width >= 560 && items.count > 1 ? 2 : 1
            let cardWidth = (width - CGFloat(columns - 1) * 12) / CGFloat(columns)
            VStack(alignment: .leading, spacing: 12) {
                SectionEyebrow(text: "NEEDS ATTENTION")
                ProgressCardGrid(items: items, columns: columns, width: width) { item in
                    regularAttentionCard(item, stacksActions: cardWidth - 32 < 292)
                }
            }
        }
    }

    private func regularAttentionCard(_ item: AttentionItem, stacksActions: Bool) -> some View {
        let group = item.activity.muscle
        let inToday = !store.exercises(for: group, on: Date()).isEmpty
        let radius = layout.cardRadius
        let actions = Group {
            WideButton(title: "View Exercises", prominent: false, fontSize: 12.5, verticalPadding: 9, cornerRadius: 11) {
                router.push(.preset(group, day: Calendar.current.startOfDay(for: Date())))
            }
            WideButton(title: inToday ? "In Today's Workout" : "Add to Today", prominent: !inToday,
                       fontSize: 12.5, verticalPadding: 9, cornerRadius: 11) {
                if !inToday { store.addToToday(group) }
                tab = .train
            }
        }
        return VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                MiniBodyMap(group: group, color: DS.silver.opacity(0.55))
                    .frame(width: 34, height: 78)
                VStack(alignment: .leading, spacing: 5) {
                    Text(group.title)
                        .font(.ui(16, .semibold))
                        .foregroundStyle(DS.silver)
                    Text(item.reason)
                        .font(.ui(13))
                        .cssLineHeight(13, 1.4)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 4)
                Spacer(minLength: 0)
            }
            // Cards in a row share its height; the actions keep to the
            // bottom edge so they line up across the row.
            Spacer(minLength: 0)
            if stacksActions {
                VStack(spacing: 8) { actions }
            } else {
                HStack(spacing: 8) { actions }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(DS.surfaceAlt))
        .overlay(RoundedRectangle(cornerRadius: radius, style: .continuous)
            .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
        .dsSelected(highlighted == group, radius: radius)
        .contentShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        .onTapGesture { toggleHighlight(group) }
        .dsHover(.lift, radius: radius)
        .accessibilityElement(children: .contain)
        .accessibilityAction(named: "Show on body map") { toggleHighlight(group) }
    }

    // MARK: Activity

    /// Upper body beside lower body and core where there's room — six and
    /// six — each sorted by its own sets but measured against one maximum,
    /// so a bar means the same in both columns. One sorted list otherwise.
    private func activitySection(_ activity: [MuscleActivity], width: CGFloat) -> some View {
        let maxSets = max(activity.map(\.effectiveSets).max() ?? 0, 1)
        let split = width >= 560
        let listWidth = split ? (width - 32) / 2 : width
        // The bar takes a share of the row, the same in every row of a
        // column, so bar lengths compare.
        let rowWidth = listWidth - 2 * Self.cardInset - 2 * Self.rowInset
        let barWidth = min(140, max(96, (rowWidth * 0.36).rounded()))
        let bySets: (MuscleActivity, MuscleActivity) -> Bool = {
            ($0.effectiveSets, $1.muscle.title) > ($1.effectiveSets, $0.muscle.title)
        }
        let upper = activity.filter { $0.muscle.area == .upper }.sorted(by: bySets)
        let lower = activity.filter { $0.muscle.area != .upper }.sorted(by: bySets)
        return VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "MUSCLE ACTIVITY")
                Spacer()
                MetaLine(text: "EFFECTIVE SETS", em: 0.08)
            }
            .padding(.bottom, 12)

            if split {
                HStack(alignment: .top, spacing: 32) {
                    activityGroup("UPPER BODY", upper, maxSets: maxSets, barWidth: barWidth)
                        .frame(width: listWidth)
                    activityGroup("LOWER BODY & CORE", lower, maxSets: maxSets, barWidth: barWidth)
                        .frame(width: listWidth)
                }
            } else {
                activityCard(activity.sorted(by: bySets), maxSets: maxSets, barWidth: barWidth)
            }

            Text("Effective sets: each completed set counts \(Self.weight(.primary)) for its primary muscles and \(Self.weight(.secondary)) for secondary ones.")
                .font(.ui(12))
                .cssLineHeight(12, 1.5)
                .foregroundStyle(DS.silver.opacity(0.4))
                .fixedSize(horizontal: false, vertical: true)
                .dsReadable(560, alignment: .leading)
                .padding(.top, 14)
        }
    }

    private func activityGroup(_ title: String, _ entries: [MuscleActivity],
                               maxSets: Double, barWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            MetaLine(text: title, em: 0.1)
                .padding(.leading, Self.cardInset + Self.rowInset)
            activityCard(entries, maxSets: maxSets, barWidth: barWidth)
        }
    }

    private func activityCard(_ entries: [MuscleActivity], maxSets: Double, barWidth: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach(entries) { entry in
                activityRow(entry, maxSets: maxSets, barWidth: barWidth)
                if entry.id != entries.last?.id {
                    Hairline(opacity: 0.06)
                        .padding(.horizontal, Self.rowInset)
                }
            }
        }
        .padding(Self.cardInset)
        .dsPane(radius: Self.groupedRadius, fill: DS.surfaceAlt)
    }

    private func activityRow(_ entry: MuscleActivity, maxSets: Double, barWidth: CGFloat) -> some View {
        let isOn = highlighted == entry.muscle
        let untrainable = !PresetProvider.trainableGroups.contains(entry.muscle)
        let radius = Self.groupedRadius - Self.cardInset
        return Button {
            toggleHighlight(entry.muscle)
        } label: {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(entry.muscle.title)
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                    Text(untrainable && entry.level == .notTrained
                         ? "Not trained · add exercises from the Exercises tab"
                         : entry.level.title)
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.5))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 12)
                VStack(alignment: .trailing, spacing: 6) {
                    Text(entry.setsLabel)
                        .font(.mono(12.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(entry.effectiveSets > 0 ? 0.9 : 0.4))
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(DS.silver.opacity(0.07))
                            Capsule()
                                .fill(entry.level.color ?? .clear)
                                .frame(width: geo.size.width * CGFloat(entry.effectiveSets / maxSets))
                        }
                    }
                    .frame(width: barWidth, height: 5)
                }
            }
            .padding(.horizontal, Self.rowInset)
            .padding(.vertical, 12)
            .contentShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsSelected(isOn, radius: radius)
        .dsHover(.highlight, radius: radius)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isOn ? .isSelected : [])
        .accessibilityHint("Shows it on the body map")
    }

    // MARK: Records & history

    /// Side by side where each gets a readable column, stacked otherwise.
    /// `DSColumns` keeps both lists' identity when that flips.
    private func recordsAndHistory(width: CGFloat) -> some View {
        DSColumns(columns: width >= 640 ? 2 : 1, spacing: 32, rowSpacing: layout.sectionSpacing) {
            records.dsColumn(0)
            history.dsColumn(1)
        }
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

#Preview("Muscles · 11-inch portrait") {
    MuscleProgressView(tab: .constant(.muscles))
        .environment(WorkoutStore())
        .environment(RestTimer())
        .environment(Ads(purchases: Purchases()))
        .dsPreview(.pad11Portrait750)
}

#Preview("Muscles · 13-inch landscape") {
    MuscleProgressView(tab: .constant(.muscles))
        .environment(WorkoutStore())
        .environment(RestTimer())
        .environment(Ads(purchases: Purchases()))
        .dsPreview(.pad13Landscape1110)
}
