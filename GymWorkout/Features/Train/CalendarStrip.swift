//
//  CalendarStrip.swift
//  GymWorkout
//
//  Compact horizontal day picker at the top of Train. Three weeks back and a
//  week ahead; today is outlined, the selected day is filled, and days with
//  logged sets carry a small dot.
//

import SwiftUI

struct CalendarStrip: View {
    @Binding var selection: Date
    /// Start-of-day dates that get the completion dot.
    var markedDays: Set<Date>

    private let days: [Date] = {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (-21...7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }()

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
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
                .padding(.horizontal, DS.Metric.gutter)
            }
            .onAppear { proxy.scrollTo(Calendar.current.startOfDay(for: selection), anchor: .center) }
        }
    }
}

private struct DayChip: View {
    var day: Date
    var isSelected: Bool
    var isToday: Bool
    var isMarked: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Text(day.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                    .font(.mono(9, .semibold))
                    .trackingEm(0.08, size: 9)
                    .foregroundStyle(isSelected ? DS.ink.opacity(0.7) : DS.silver.opacity(isToday ? 0.8 : 0.4))
                Text(day.formatted(.dateTime.day()))
                    .font(.ui(17, isToday || isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? DS.ink : DS.silver.opacity(isToday ? 1 : 0.75))
                Circle()
                    .fill(isSelected ? DS.ink.opacity(0.6) : DS.silver.opacity(0.55))
                    .frame(width: 4, height: 4)
                    .opacity(isMarked ? 1 : 0)
            }
            .frame(width: 44)
            .padding(.vertical, 9)
            .background(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(isSelected ? DS.silver : DS.silver.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .strokeBorder(isToday && !isSelected ? DS.silver.opacity(0.45) : DS.silver.opacity(0.07),
                                  lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(day.formatted(date: .complete, time: .omitted))
        .accessibilityValue([isToday ? "Today" : nil, isMarked ? "Workout logged" : nil]
            .compactMap { $0 }.joined(separator: ", "))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
