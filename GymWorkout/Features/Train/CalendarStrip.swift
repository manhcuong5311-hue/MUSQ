//
//  CalendarStrip.swift
//  GymWorkout
//
//  Compact horizontal day picker at the top of Train. Three weeks back and a
//  week ahead; today is outlined, the selected day is filled, and days with
//  logged sets carry a small dot. The iPad's two-pane Train lays the same
//  days out as a month-style grid instead (`CalendarGrid`), which doubles as
//  a glance at three weeks of training.
//

import SwiftUI

struct CalendarStrip: View {
    @Binding var selection: Date
    /// Start-of-day dates that get the completion dot.
    var markedDays: Set<Date>

    /// The days either side of today that can be picked, in both the strip
    /// and the grid.
    static let range = -21...7

    @Environment(\.dsLayout) private var layout

    private let days: [Date] = {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return CalendarStrip.range.compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }()

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: layout.isRegular ? 8 : 7) {
                    ForEach(days, id: \.self) { day in
                        DayChip(
                            day: day,
                            isSelected: Calendar.current.isDate(day, inSameDayAs: selection),
                            isToday: Calendar.current.isDateInToday(day),
                            isMarked: markedDays.contains(day)
                        ) {
                            withAnimation(.easeOut(duration: 0.18)) { selection = day }
                        }
                        .id(day)
                    }
                }
                .padding(.horizontal, layout.gutter)
            }
            .onAppear { proxy.scrollTo(Calendar.current.startOfDay(for: selection), anchor: .center) }
            .modifier(PadKeepsSelectionInView(selection: $selection, proxy: proxy))
        }
    }
}

/// iPad only; the phone's strip neither measures nor follows the selection.
private struct PadKeepsSelectionInView: ViewModifier {
    @Binding var selection: Date
    var proxy: ScrollViewProxy

    func body(content: Content) -> some View {
        if DS.isPad {
            content
                // An iPad window rotates and resizes under the strip (Split
                // View, Stage Manager), which would leave the selection off to
                // one side or out of sight.
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { _ in
                    proxy.scrollTo(Calendar.current.startOfDay(for: selection), anchor: .center)
                }
                // The arrow keys can pick a day that's scrolled out of view;
                // bring it in, moving no further than that.
                .onChange(of: selection) { _, day in
                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo(Calendar.current.startOfDay(for: day))
                    }
                }
        } else {
            content
        }
    }
}

/// The strip's days as a grid of whole weeks, for the iPad's Today pane: a
/// row per week from the locale's first weekday, with the days outside the
/// range left blank. Days of a month other than the selected day's are
/// dimmed, as a wall calendar does, so the numbers can't be misread across
/// the month's turn.
struct CalendarGrid: View {
    @Binding var selection: Date
    var markedDays: Set<Date>

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

    var body: some View {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selected = calendar.startOfDay(for: selection)

        VStack(alignment: .leading, spacing: 12) {
            header(selected: selected, today: today)

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(Array(weekdaySymbols(calendar).enumerated()), id: \.offset) { _, symbol in
                    Text(symbol.uppercased())
                        .font(.mono(9, .semibold))
                        .trackingEm(0.08, size: 9)
                        .foregroundStyle(DS.silver.opacity(0.35))
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 2)
                        .accessibilityHidden(true)
                }
                ForEach(cells(calendar, today: today, selected: selected), id: \.date) { cell in
                    if cell.inRange {
                        DayChip(
                            day: cell.date,
                            isSelected: cell.date == selected,
                            isToday: cell.date == today,
                            isMarked: markedDays.contains(cell.date),
                            kind: .cell(dimmed: !calendar.isDate(cell.date, equalTo: selected, toGranularity: .month))
                        ) {
                            withAnimation(.easeOut(duration: 0.18)) { selection = cell.date }
                        }
                    } else {
                        Color.clear
                            .frame(height: DayChip.cellHeight)
                            .accessibilityHidden(true)
                    }
                }
            }
        }
    }

    /// The selected day's month, and a way back to today once off it.
    private func header(selected: Date, today: Date) -> some View {
        HStack(alignment: .firstTextBaseline) {
            (Text(selected.formatted(.dateTime.month(.wide)))
                .foregroundStyle(DS.silver)
             + Text(" " + selected.formatted(.dateTime.year()))
                .foregroundStyle(DS.silver.opacity(0.4)))
                .font(.ui(17, .semibold))
                .tracking(-0.3)
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 8)
            Button {
                withAnimation(.easeOut(duration: 0.18)) { selection = today }
            } label: {
                Text("Today")
                    .font(.ui(12.5, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.8))
                    .padding(.horizontal, 11)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(DS.silver.opacity(0.07)))
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .dsHover(.highlight)
            // Kept in place while hidden, so the header never shifts.
            .opacity(selected == today ? 0 : 1)
            .disabled(selected == today)
            .accessibilityHidden(selected == today)
        }
    }

    /// Short weekday names, starting from the locale's first weekday.
    private func weekdaySymbols(_ calendar: Calendar) -> [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let first = calendar.firstWeekday - 1
        return Array(symbols[first...] + symbols[..<first])
    }

    private struct Cell {
        var date: Date
        var inRange: Bool
    }

    /// Whole weeks from the one holding the first day of the range to the
    /// one holding its last. A first week the range only clips the end of
    /// would be a row of blanks, so the grid starts a week later instead,
    /// unless the selected day is in it.
    private func cells(_ calendar: Calendar, today: Date, selected: Date) -> [Cell] {
        let range = CalendarStrip.range
        guard let first = calendar.date(byAdding: .day, value: range.lowerBound, to: today),
              let last = calendar.date(byAdding: .day, value: range.upperBound, to: today),
              var start = calendar.dateInterval(of: .weekOfYear, for: first)?.start,
              let end = calendar.dateInterval(of: .weekOfYear, for: last)?.end else { return [] }
        if start < first, let next = calendar.date(byAdding: .weekOfYear, value: 1, to: start),
           calendar.dateComponents([.day], from: first, to: next).day ?? 0 < 4, selected >= next {
            start = next
        }
        var cells: [Cell] = []
        var day = start
        while day < end {
            cells.append(Cell(date: day, inRange: day >= first && day <= last))
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = calendar.startOfDay(for: next)
        }
        return cells
    }
}

private struct DayChip: View {
    /// The strip's chip names its weekday; a grid cell sits under a header
    /// that already does, and may be dimmed as another month's.
    enum Kind: Equatable {
        case strip
        case cell(dimmed: Bool)
    }

    /// A grid cell's height; its width is the column's.
    static let cellHeight: CGFloat = 52

    var day: Date
    var isSelected: Bool
    var isToday: Bool
    var isMarked: Bool
    var kind: Kind = .strip
    var action: () -> Void

    @Environment(\.dsLayout) private var layout

    var body: some View {
        Button(action: action) {
            switch kind {
            case .strip: chip
            case .cell(let dimmed): cell(dimmed: dimmed)
            }
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: 13)
        .accessibilityLabel(day.formatted(date: .complete, time: .omitted))
        .accessibilityValue([isToday ? "Today" : nil, isMarked ? "Workout logged" : nil]
            .compactMap { $0 }.joined(separator: ", "))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var chip: some View {
        // Wider chips and larger type on iPad; the phone's own otherwise.
        let weekday: CGFloat = layout.isRegular ? 10 : 9
        return VStack(spacing: 5) {
            Text(day.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                .font(.mono(weekday, .semibold))
                .trackingEm(0.08, size: weekday)
                .foregroundStyle(isSelected ? DS.ink.opacity(0.7) : DS.silver.opacity(isToday ? 0.8 : 0.4))
            number(size: layout.isRegular ? 19 : 17)
            dot
        }
        .frame(width: layout.isRegular ? 52 : 44)
        .padding(.vertical, layout.isRegular ? 10 : 9)
        .background(ground)
        .overlay(outline)
    }

    private func cell(dimmed: Bool) -> some View {
        VStack(spacing: 5) {
            number(size: 17)
            dot
        }
        // Another month's day reads as such until it's picked.
        .opacity(dimmed && !isSelected ? 0.45 : 1)
        .frame(maxWidth: .infinity)
        .frame(height: Self.cellHeight)
        .background(ground)
        .overlay(outline)
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }

    private func number(size: CGFloat) -> some View {
        Text(day.formatted(.dateTime.day()))
            .font(.ui(size, isToday || isSelected ? .semibold : .regular))
            .foregroundStyle(isSelected ? DS.ink : DS.silver.opacity(isToday ? 1 : 0.75))
    }

    private var dot: some View {
        Circle()
            .fill(isSelected ? DS.ink.opacity(0.6) : DS.silver.opacity(0.55))
            .frame(width: 4, height: 4)
            .opacity(isMarked ? 1 : 0)
    }

    private var ground: some View {
        RoundedRectangle(cornerRadius: 13, style: .continuous)
            .fill(isSelected ? DS.silver : DS.silver.opacity(0.04))
    }

    private var outline: some View {
        RoundedRectangle(cornerRadius: 13, style: .continuous)
            .strokeBorder(isToday && !isSelected ? DS.silver.opacity(0.45) : DS.silver.opacity(0.07),
                          lineWidth: 1)
    }
}
