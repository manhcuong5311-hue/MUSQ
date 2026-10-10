//
//  HistoryViews.swift
//  GymWorkout
//
//  Read-only history pushed from the Muscles tab: one day's workout, and one
//  exercise across every day it was done, plus the rows and totals that list
//  them there. Editing stays in Train.
//
//  On iPad both screens sit in a centred column under a header aligned to
//  it: the workout as a summary band over a grid of exercise cards, the
//  exercise with its trend drawn; in wide the exercise splits into its
//  records beside the day list.
//

import Charts
import SwiftUI

// MARK: - One workout

struct SessionHistoryView: View {
    var sessionID: UUID

    @Environment(WorkoutStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout
    /// Every stack that pushes this screen provides one; optional so the
    /// iPad context menu simply goes missing anywhere one doesn't.
    @Environment(TrainRouter.self) private var router: TrainRouter?

    /// iPad column: two cards across in regular, three in wide.
    private var columnMax: CGFloat { layout.isWide ? 1040 : 880 }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            if let session = store.sessions.first(where: { $0.id == sessionID }) {
                let records = recordIDs(in: session)
                VStack(spacing: 0) {
                    HistoryHeader(title: RecoveryText.day(session.day),
                                  meta: session.day.formatted(.dateTime.weekday(.wide).day().month(.wide).year()).uppercased(),
                                  maxWidth: layout.isRegular ? columnMax : nil,
                                  onBack: { dismiss() })
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            if layout.isRegular {
                                summaryBand(session)
                            } else {
                                Text(SessionText.summary(session, unit: store.unit))
                                    .font(.ui(13))
                                    .foregroundStyle(DS.silver.opacity(0.6))
                            }
                            if session.completedAt == nil {
                                Text("Still in progress — finish it from Train.")
                                    .font(.ui(layout.pt(12, 13)))
                                    .foregroundStyle(DS.silver.opacity(0.4))
                                    .dsReadable(560, alignment: .leading)
                                    .padding(.top, layout.pt(4, 12))
                            }

                            if layout.isRegular {
                                exerciseGrid(session, records: records)
                                    .padding(.top, 20)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(session.exercises) { exercise in
                                        exerciseCard(exercise, records: records)
                                    }
                                }
                                .padding(.top, 18)
                            }
                        }
                        .dsReadable(columnMax)
                        .dsGutter()
                        .padding(.top, layout.pt(6, 8))
                        .padding(.bottom, layout.pt(32, 40))
                    }
                }
            } else {
                MissingHistory(onBack: { dismiss() })
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .restTimerInset()
        // On the screen rather than in `HistoryHeader`, which FAQView shares
        // and gives its own.
        .dsBackShortcuts { dismiss() }
    }

    private func recordIDs(in session: WorkoutSession) -> Set<UUID> {
        let names = Set(session.exercises.map(\.exerciseName))
        return names.reduce(into: Set<UUID>()) { ids, name in
            ids.formUnion(PerformanceHistory.recordSetIDs(for: name, in: store.sessions))
        }
    }

    private func exerciseCard(_ exercise: WorkoutExercise, records: Set<UUID>) -> some View {
        NavigationLink(value: TrainRoute.exerciseHistory(exercise.exerciseName)) {
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

    // MARK: iPad

    /// The phone's one summary line as tiles, with the groups the workout
    /// reached lit on a small front-and-back pair. The pair goes where the
    /// band is too narrow for both.
    private func summaryBand(_ session: WorkoutSession) -> some View {
        let done = session.exercises.filter { !$0.completedSets.isEmpty }
        let unit = store.unit
        var fills: [BodyRegion: Color] = [:]
        for group in done.map(\.group) {
            for region in group.bodyRegions { fills[region] = DS.activation }
        }
        let divider = Rectangle()
            .fill(DS.silver.opacity(0.08))
            .frame(width: 1, height: 44)
        // The tiles keep their own ground, the band's colour, so on the band
        // they read as one strip of totals.
        let tiles = HStack(spacing: 0) {
            StatTile(label: "Exercises", value: done.count.formatted())
            divider
            StatTile(label: "Sets", value: session.completedSetCount.formatted())
            if session.volume > 0 {
                divider
                StatTile(label: "Volume",
                         value: StatTile.compact(unit.fromKilograms(session.volume)),
                         unit: unit.symbol)
            }
        }
        return ViewThatFits(in: .horizontal) {
            HStack(spacing: 24) {
                tiles
                BodyMapPair(source: .fills(front: fills, back: fills), figureHeight: 120,
                            showsCaptions: false)
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Groups worked: "
                                        + Set(done.map(\.group)).map(\.title).sorted().joined(separator: ", "))
            }
            tiles
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surfaceAlt))
    }

    /// Exercise cards two or three across: as many 320pt-plus columns as the
    /// column holds.
    private func exerciseGrid(_ session: WorkoutSession, records: Set<UUID>) -> some View {
        let width = min(columnMax, max(320, layout.containerWidth - 2 * layout.gutter))
        let columns = layout.columnCount(fitting: width, minimum: 320, spacing: 12, range: 1...3)
        return ProgressCardGrid(items: session.exercises, columns: columns, width: width) { exercise in
            gridCard(exercise, records: records)
        }
    }

    /// The phone card with room: the group under the name instead of beside
    /// it, and the chevron by the name rather than across a wide card.
    private func gridCard(_ exercise: WorkoutExercise, records: Set<UUID>) -> some View {
        let radius: CGFloat = 18
        return NavigationLink(value: TrainRoute.exerciseHistory(exercise.exerciseName)) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(exercise.exerciseName)
                            .font(.ui(15.5, .semibold))
                            .foregroundStyle(DS.silver)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 8)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(DS.silver.opacity(0.28))
                    }
                    MetaLine(text: exercise.group.title.uppercased())
                }
                if exercise.completedSets.isEmpty {
                    Text("Not done")
                        .font(.ui(13))
                        .foregroundStyle(DS.silver.opacity(0.4))
                } else {
                    SetChips(sets: exercise.completedSets, measure: exercise.setMeasure,
                             unit: store.unit, records: records)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(DS.surfaceAlt))
            .contentShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: radius)
        .contextMenu {
            if DS.isPad, let router {
                Button {
                    router.push(.exerciseHistory(exercise.exerciseName))
                } label: {
                    Label("Exercise History", systemImage: "chart.line.uptrend.xyaxis")
                }
            }
        }
    }
}

// MARK: - One exercise over time

struct ExerciseHistoryView: View {
    var exerciseName: String

    @Environment(WorkoutStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout

    /// iPad column; wide fits the records pane beside the day list.
    private var columnMax: CGFloat { layout.isWide ? 1100 : 820 }

    var body: some View {
        let days = PerformanceHistory.days(of: exerciseName, in: store.sessions)
        let record = PerformanceHistory.record(for: exerciseName, in: store.sessions)
        ZStack {
            DS.ink.ignoresSafeArea()

            VStack(spacing: 0) {
                HistoryHeader(title: exerciseName,
                              meta: ExerciseCatalog.exercise(named: exerciseName)?.trainerMeta ?? "",
                              maxWidth: layout.isRegular ? columnMax : nil,
                              onBack: { dismiss() })
                if layout.isWide, let record {
                    panes(record, days: days)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            if let record {
                                bests(record)
                                if layout.isRegular {
                                    trend(record, days: days)
                                        .padding(.top, 32)
                                }
                            }

                            SectionEyebrow(text: "HISTORY")
                                .padding(.top, layout.pt(26, 32))
                            if days.isEmpty {
                                Text("No completed sets yet.")
                                    .font(.ui(13))
                                    .foregroundStyle(DS.silver.opacity(0.5))
                                    .padding(.top, 10)
                            }
                            dayList(days)
                                .padding(.top, layout.pt(4, 12))
                        }
                        .dsReadable(columnMax)
                        .dsGutter()
                        .padding(.top, layout.pt(6, 8))
                        .padding(.bottom, layout.pt(32, 40))
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .restTimerInset()
        // On the screen rather than in `HistoryHeader`, which FAQView shares
        // and gives its own.
        .dsBackShortcuts { dismiss() }
    }

    /// Records tiles: two across on the phone and in the wide records pane,
    /// one row of up to four in a regular column.
    private func bests(_ record: ExerciseRecord, columns: Int? = nil) -> some View {
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
        let roomy = layout.containerWidth - 2 * layout.gutter >= 560
        let count = columns ?? (layout.isRegular && roomy ? tiles.count : 2)
        let spacing: CGFloat = layout.isRegular ? 12 : 8
        return VStack(alignment: .leading, spacing: layout.pt(10, 12)) {
            SectionEyebrow(text: "PERSONAL RECORDS")
            LazyVGrid(columns: DS.flexibleColumns(count, spacing: spacing), spacing: spacing) {
                ForEach(tiles, id: \.label) { tile in
                    StatTile(label: tile.label, value: tile.value)
                }
            }
            Text("Est. 1RM uses the Epley formula on your best loaded set. A set marked PR beat every earlier set of this exercise.")
                .font(.ui(layout.pt(11.5, 12)))
                .cssLineHeight(layout.pt(11.5, 12), 1.5)
                .foregroundStyle(DS.silver.opacity(0.4))
                .fixedSize(horizontal: false, vertical: true)
                .dsReadable(560, alignment: .leading)
        }
    }

    @ViewBuilder
    private func dayList(_ days: [ExerciseDay]) -> some View {
        if layout.isRegular {
            // One grouped card, so the hairlines end with it; the rows sit
            // inset so their hover stays concentric with its corners.
            if !days.isEmpty {
                VStack(spacing: 0) {
                    ForEach(days) { day in
                        regularDayRow(day)
                        if day.id != days.last?.id {
                            Hairline(opacity: 0.06)
                                .padding(.horizontal, 12)
                        }
                    }
                }
                .padding(6)
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surfaceAlt))
            }
        } else {
            VStack(spacing: 0) {
                ForEach(days) { day in
                    dayRow(day)
                    if day.id != days.last?.id { Hairline(opacity: 0.06) }
                }
            }
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

    // MARK: iPad

    /// Records, the footnote and the trend pinned on the leading side, the
    /// days scrolling beside them.
    private func panes(_ record: ExerciseRecord, days: [ExerciseDay]) -> some View {
        HStack(alignment: .top, spacing: 32) {
            // Scrolls only where the pane is shorter than its content — a
            // mini in landscape with the rest bar up.
            ViewThatFits(in: .vertical) {
                recordsPane(record, days: days)
                ScrollView(showsIndicators: false) {
                    recordsPane(record, days: days)
                }
            }
            .frame(width: 360)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline) {
                        SectionEyebrow(text: "HISTORY")
                        Spacer()
                        MetaLine(text: "\(days.count) \(days.count == 1 ? "DAY" : "DAYS")", em: 0.08)
                    }
                    dayList(days)
                }
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: 640)
        }
        .dsReadable(columnMax)
        .dsGutter()
    }

    private func recordsPane(_ record: ExerciseRecord, days: [ExerciseDay]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            bests(record, columns: 2)
            trend(record, days: days)
                .padding(.top, 28)
        }
        .padding(.top, 8)
        .padding(.bottom, 24)
    }

    /// A day as a row that opens its whole workout — on iPad only, where the
    /// row hovers, so it must lead somewhere.
    @ViewBuilder
    private func regularDayRow(_ day: ExerciseDay) -> some View {
        let session = store.sessions.first { $0.day == day.day }
        let radius: CGFloat = 12
        let row = VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(RecoveryText.day(day.day))
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                Spacer(minLength: 24)
                if let volume = Self.volume(day) {
                    MetaLine(text: store.unit.total(volume).uppercased(), em: 0.06)
                }
                if session != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.28))
                        .padding(.leading, 12)
                }
            }
            SetChips(sets: day.sets, measure: day.measure, unit: store.unit, records: day.recordSetIDs)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(RoundedRectangle(cornerRadius: radius, style: .continuous))

        if let session {
            NavigationLink(value: TrainRoute.session(session.id)) { row }
                .buttonStyle(.plain)
                .dsHover(.highlight, radius: radius)
                .accessibilityHint("Opens that day's workout")
        } else {
            row
        }
    }

    private static func volume(_ day: ExerciseDay) -> Double? {
        guard day.measure == .reps else { return nil }
        let volume = day.sets.reduce(0) { $0 + ($1.weight ?? 0) * Double($1.reps) }
        return volume > 0 ? volume : nil
    }

    /// The best of each day, oldest first: est. 1RM for a loaded lift, else
    /// the longest hold or the most reps.
    @ViewBuilder
    private func trend(_ record: ExerciseRecord, days: [ExerciseDay]) -> some View {
        let trend = ExerciseTrend(record: record, days: days, unit: store.unit)
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: "TREND")
                Spacer()
                MetaLine(text: trend.caption, em: 0.08)
            }
            if trend.points.count >= 2 {
                ExerciseTrendChart(trend: trend)
                    .frame(height: 200)
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surfaceAlt))
            } else {
                Text("The trend draws once this exercise is logged on a second day.")
                    .font(.ui(13))
                    .cssLineHeight(13, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Trend

/// One number per day for `ExerciseTrendChart`, in the unit the user sees.
private struct ExerciseTrend {
    enum Kind { case estimatedMax, hold, reps }

    struct Point: Identifiable {
        let day: Date
        let value: Double
        var id: Date { day }
    }

    let kind: Kind
    let unit: WeightUnit
    let points: [Point]

    init(record: ExerciseRecord, days: [ExerciseDay], unit: WeightUnit) {
        self.unit = unit
        let kind: Kind = record.measure == .time ? .hold : record.bestSet != nil ? .estimatedMax : .reps
        self.kind = kind
        points = days.reversed().compactMap { day in
            let best: Double?
            switch kind {
            case .estimatedMax:
                best = day.sets
                    .compactMap { PerformanceHistory.estimatedMax(weight: $0.weight, reps: $0.reps) }
                    .max()
                    .map(unit.fromKilograms)
            case .hold, .reps:
                best = day.sets.map { Double($0.reps) }.max()
            }
            return best.map { Point(day: day.day, value: $0) }
        }
    }

    var title: String {
        switch kind {
        case .estimatedMax: return "Est. 1RM"
        case .hold: return "Longest hold"
        case .reps: return "Most reps"
        }
    }

    var caption: String {
        switch kind {
        case .estimatedMax: return "BEST EST. 1RM · \(unit.symbol.uppercased())"
        case .hold: return "LONGEST HOLD"
        case .reps: return "MOST REPS"
        }
    }

    /// Padded around the values rather than from zero, so a few kilos of
    /// progress still reads as a slope.
    var domain: ClosedRange<Double> {
        let values = points.map(\.value)
        let low = values.min() ?? 0
        let high = values.max() ?? 1
        let pad = max((high - low) * 0.2, high * 0.05, 1)
        return max(0, low - pad)...(high + pad)
    }

    func label(_ value: Double) -> String {
        kind == .hold ? SetMeasure.clock(Int(value.rounded())) : Int(value.rounded()).formatted()
    }
}

/// Silver line and wash on the card ground. Never activation — that colour
/// is for muscles only.
private struct ExerciseTrendChart: View {
    var trend: ExerciseTrend

    var body: some View {
        let domain = trend.domain
        Chart(trend.points) { point in
            AreaMark(x: .value("Day", point.day, unit: .day),
                     yStart: .value("Floor", domain.lowerBound),
                     yEnd: .value(trend.title, point.value))
                .interpolationMethod(.monotone)
                .foregroundStyle(
                    LinearGradient(colors: [DS.silver.opacity(0.15), DS.silver.opacity(0)],
                                   startPoint: .top, endPoint: .bottom)
                )
            LineMark(x: .value("Day", point.day, unit: .day),
                     y: .value(trend.title, point.value))
                .interpolationMethod(.monotone)
                .foregroundStyle(DS.silver.opacity(0.8))
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            PointMark(x: .value("Day", point.day, unit: .day),
                      y: .value(trend.title, point.value))
                .symbolSize(20)
                .foregroundStyle(DS.silver)
        }
        .chartYScale(domain: domain)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                AxisGridLine().foregroundStyle(DS.silver.opacity(0.06))
                AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                    .font(.mono(9, .medium))
                    .foregroundStyle(DS.silver.opacity(0.45))
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 4)) { value in
                AxisGridLine().foregroundStyle(DS.silver.opacity(0.06))
                AxisValueLabel {
                    if let number = value.as(Double.self) {
                        Text(trend.label(number))
                    }
                }
                .font(.mono(9, .medium))
                .foregroundStyle(DS.silver.opacity(0.45))
            }
        }
    }
}

// MARK: - Shared

/// iPad cards in rows of `columns`, each card as tall as the tallest in its
/// row — a `LazyVGrid` leaves the shorter ones ragged. A card stretches to
/// the row by filling its frame. Every cell gets a concrete width, so
/// wrapping content (`FlowRow`) always knows how wide it is.
struct ProgressCardGrid<Item: Identifiable, Content: View>: View {
    var items: [Item]
    var columns: Int
    /// The grid's full width, shared by the cells and the gaps.
    var width: CGFloat
    var spacing: CGFloat
    var content: (Item) -> Content

    init(items: [Item], columns: Int, width: CGFloat, spacing: CGFloat = 12,
         @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.columns = columns
        self.width = width
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        let n = max(1, columns)
        let cell = max(0, ((width - CGFloat(n - 1) * spacing) / CGFloat(n)).rounded(.down))
        Grid(alignment: .topLeading, horizontalSpacing: spacing, verticalSpacing: spacing) {
            ForEach(Array(stride(from: 0, to: items.count, by: n)), id: \.self) { start in
                GridRow {
                    ForEach(items[start..<min(start + n, items.count)]) { item in
                        content(item)
                            .frame(width: cell)
                    }
                }
            }
        }
    }
}

/// Logged sets as chips, records outlined and tagged.
struct SetChips: View {
    var sets: [WorkoutSet]
    var measure: SetMeasure
    var unit: WeightUnit
    var records: Set<UUID> = []

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let regular = layout.isRegular
        let size: CGFloat = regular ? 12.5 : 11.5
        let tagSize: CGFloat = regular ? 9 : 8.5
        FlowRow(spacing: regular ? 7 : 6) {
            ForEach(sets) { set in
                let isRecord = records.contains(set.id)
                HStack(spacing: 5) {
                    Text(SetText.short(set, measure: measure, unit: unit))
                        .font(.mono(size, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.8))
                    if isRecord {
                        Text("PR")
                            .font(.mono(tagSize, .bold))
                            .trackingEm(0.08, size: tagSize)
                            .foregroundStyle(DS.silver)
                    }
                }
                .padding(.horizontal, regular ? 10 : 9)
                .padding(.vertical, regular ? 7 : 5)
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
    /// iPad: the cap of the content column below, so the back button lines
    /// up with the column rather than the window's edge. Nil spans the width.
    var maxWidth: CGFloat? = nil
    var onBack: () -> Void

    @Environment(\.dsLayout) private var layout

    var body: some View {
        HStack(spacing: layout.pt(12, 14)) {
            CircleIconButton(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: layout.pt(14, 16), weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel("Back")

            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.ui(layout.text(.screenTitle), .semibold))
                    .tracking(layout.value(-0.25, -0.4))
                    .foregroundStyle(DS.silver)
                    .lineLimit(1)
                MetaLine(text: meta)
                    .padding(.top, layout.pt(3, 4))
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .dsReadable(maxWidth ?? .infinity)
        // Regular pads by the gutter, so the header lines up with content
        // under `.dsGutter()`; the phone keeps its tighter 16.
        .padding(.horizontal, layout.isRegular ? layout.gutter : 16)
        .padding(.top, layout.pt(11, 16))
        .padding(.bottom, layout.pt(10, 14))
    }
}

private struct MissingHistory: View {
    var onBack: () -> Void

    @Environment(\.dsLayout) private var layout

    var body: some View {
        VStack(spacing: 14) {
            Text("This workout is no longer in your history.")
                .font(.ui(layout.pt(14, 15)))
                .foregroundStyle(DS.silver.opacity(0.6))
                .multilineTextAlignment(layout.isRegular ? .center : .leading)
                .frame(maxWidth: layout.isRegular ? 420 : nil)
            WideButton(title: "Back", prominent: false, action: onBack)
                .frame(width: 160)
        }
    }
}

// MARK: - Stat tile

/// One total: a sentence-case label over its value.
struct StatTile: View {
    enum Prominence {
        /// Today's tile on iPhone, the larger one in regular.
        case automatic
        /// Today's tile everywhere.
        case standard
        /// The larger tile everywhere.
        case large
    }

    var label: String
    var value: String
    var unit: String? = nil
    var prominence: Prominence = .automatic

    @Environment(\.dsLayout) private var layout

    private var isLarge: Bool {
        switch prominence {
        case .automatic: return layout.isRegular
        case .standard: return false
        case .large: return true
        }
    }

    var body: some View {
        let large = isLarge
        VStack(alignment: .leading, spacing: large ? 7 : 6) {
            Text(label)
                .font(.ui(large ? 12.5 : 11.5))
                .foregroundStyle(DS.silver.opacity(0.5))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.ui(large ? 28 : 22, .semibold))
                    .tracking(large ? -0.6 : -0.4)
                    .foregroundStyle(DS.silver)
                if let unit {
                    Text(unit)
                        .font(.ui(large ? 13.5 : 12, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, large ? 16 : 12)
        .padding(.vertical, large ? 16 : 12)
        .background(RoundedRectangle(cornerRadius: large ? 18 : 16, style: .continuous).fill(DS.surfaceAlt))
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

    @Environment(\.dsLayout) private var layout

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.exerciseName)
                    .font(.ui(layout.pt(14.5, 15.5), .semibold))
                    .foregroundStyle(DS.silver)
                    .multilineTextAlignment(.leading)
                Text(detail)
                    .font(.ui(layout.pt(12, 12.5)))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 3) {
                Text(headline.value)
                    .font(.mono(layout.pt(14, 15), .semibold))
                    .foregroundStyle(DS.silver)
                MetaLine(text: headline.label, size: layout.pt(8.5, 9), em: 0.08)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.28))
        }
        .padding(.vertical, 11)
        // In regular the row sits inset in a grouped card, with room for
        // its hover on either side.
        .padding(.horizontal, layout.isRegular ? 12 : 0)
        .contentShape(Rectangle())
        .dsHover(.highlight, radius: 14)
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

    @Environment(\.dsLayout) private var layout

    var body: some View {
        let radius: CGFloat = layout.isRegular ? 18 : 16
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(RecoveryText.day(session.day))
                        .font(.ui(layout.pt(15, 16), .semibold))
                        .foregroundStyle(DS.silver)
                    if session.completedAt == nil {
                        MetaLine(text: "IN PROGRESS", size: layout.pt(8.5, 9))
                    }
                }
                MetaLine(text: session.groups.map { $0.title.uppercased() }.joined(separator: " · "), em: 0.06)
                    .lineLimit(1)
                Text(SessionText.summary(session, unit: unit))
                    .font(.ui(layout.pt(12, 12.5)))
                    .foregroundStyle(DS.silver.opacity(0.55))
            }
            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.28))
        }
        .padding(layout.isRegular ? 14 : 12)
        .background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(DS.surfaceAlt))
        .contentShape(Rectangle())
        .dsHover(.highlight, radius: radius)
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
