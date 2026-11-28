//
//  ScheduleEditorView.swift
//  GymWorkout
//
//  The training schedule, opened from the calendar button at the top of
//  Train (2026-11-27). Two ways to plan, one sheet:
//
//  - Weekly: tap the days to train (the rest are rest days, with a moon),
//    then pick a split: Full Body, Upper / Lower, Front / Back, Push / Pull
//    / Legs, the bro split, or Custom days the user names and fills with
//    muscle groups, in an order they can change.
//  - By date: a month calendar; tap a date and set it to one of the split's
//    days or to rest. Dates left alone follow the weekly days.
//
//  Big taps, little text, and the one primary action, Save schedule, at the
//  foot where the thumb is. Onboarding opens the same sheet on its Custom
//  days only (`Scope.customDays`).
//

import SwiftUI

struct ScheduleEditorView: View {
    enum Scope {
        /// Both modes, the weekdays and the split.
        case full
        /// Only a Custom split's days, for onboarding, whose own pages ask
        /// for the weekdays and the split.
        case customDays
    }

    var initial: TrainingSchedule
    /// Lower-body focus, for the built-in splits' days.
    var lowerFocus: Bool
    var experience: TrainingExperience?
    var scope: Scope
    var onSave: (TrainingSchedule) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout
    @State private var draft: TrainingSchedule
    @State private var mode: TrainingSchedule.Mode
    @State private var selectedDate: Date
    @State private var month: Date

    private var calendar: Calendar { .current }

    /// - Parameter focusDate: opens By date on that day.
    init(initial: TrainingSchedule, lowerFocus: Bool, experience: TrainingExperience? = nil,
         focusDate: Date? = nil, scope: Scope = .full, onSave: @escaping (TrainingSchedule) -> Void) {
        self.initial = initial
        self.lowerFocus = lowerFocus
        self.experience = experience
        self.scope = scope
        self.onSave = onSave
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let day = max(today, calendar.startOfDay(for: focusDate ?? today))
        var start = initial
        if scope == .customDays, start.customDays.isEmpty {
            start.customDays = Self.seedDays(from: .pushPullLegs, lowerFocus: lowerFocus)
        }
        _draft = State(initialValue: start)
        _mode = State(initialValue: focusDate != nil ? .byDate : initial.mode)
        _selectedDate = State(initialValue: day)
        _month = State(initialValue: calendar.dateInterval(of: .month, for: day)?.start ?? day)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    switch scope {
                    case .customDays:
                        customDaysSection
                    case .full:
                        modePicker
                        if mode == .weekly {
                            weekdaysSection
                            splitSection
                            if draft.split == .custom { customDaysSection }
                        } else {
                            monthSection
                            dateSection
                        }
                    }
                }
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.top, 8)
                .padding(.bottom, 24)
                .dsReadable(620)
            }
            .background(DS.ink.ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 0) { saveBar }
            .navigationTitle(scope == .customDays ? String(localized: "Your days") : String(localized: "Schedule"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .tint(DS.silver)
        .presentationDragIndicator(.visible)
        .presentationBackground(DS.ink)
    }

    // MARK: - Save

    /// The week this sheet counts the rotation from when it changes.
    private var thisWeekStart: Date {
        calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? calendar.startOfDay(for: Date())
    }

    /// What Save writes. A changed rotation restarts from this week, so
    /// this week reads as the preview shows it.
    private var result: TrainingSchedule {
        var schedule = draft
        schedule.weekdays = draft.weekdays.sorted()
        if scope == .full { schedule.mode = mode }
        let changed = schedule.split != initial.split || Set(schedule.weekdays) != Set(initial.weekdays)
            || schedule.customDays != initial.customDays
        if changed || schedule.anchor == nil { schedule.anchor = thisWeekStart }
        return schedule
    }

    private var canSave: Bool {
        if draft.split == .custom || scope == .customDays,
           !draft.customDays.contains(where: { !$0.groups.isEmpty }) { return false }
        // Weekly with no days is allowed: the flexible plan, where every
        // day is open and Train suggests by recovery.
        return true
    }

    private var saveBar: some View {
        WideButton(title: "Save schedule", prominent: true, fontSize: 16, verticalPadding: 17, cornerRadius: 16) {
            onSave(result)
            dismiss()
        }
        .disabled(!canSave)
        .opacity(canSave ? 1 : 0.45)
        .dsCTA()
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(DS.ink.ignoresSafeArea())
    }

    // MARK: - Mode

    private var modePicker: some View {
        HStack(spacing: 8) {
            modeButton(.weekly, title: String(localized: "Weekly", comment: "Schedule mode: the same days every week"),
                       symbol: "repeat")
            modeButton(.byDate, title: String(localized: "By date", comment: "Schedule mode: plan single dates"),
                       symbol: "calendar")
        }
    }

    private func modeButton(_ value: TrainingSchedule.Mode, title: String, symbol: String) -> some View {
        let isOn = mode == value
        return Button {
            withAnimation(.easeOut(duration: 0.15)) { mode = value }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: symbol)
                    .font(.system(size: 15, weight: .semibold))
                Text(title)
                    .font(.ui(15, .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(isOn ? DS.ink : DS.silver)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 52)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isOn ? DS.silver : DS.silver.opacity(0.06)))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(DS.silver.opacity(isOn ? 0 : 0.1), lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }

    // MARK: - Weekly: days

    /// Weekday numbers in the locale's week order.
    private var weekOrder: [Int] { (0..<7).map { (calendar.firstWeekday - 1 + $0) % 7 + 1 } }

    /// The split's days, as the planner and the chips use them.
    private var templateDays: [ProgramAdvisor.SplitDay] {
        let trainable = Set(PresetProvider.trainableGroups)
        return ProgramAdvisor.days(of: draft.split, lowerFocus: lowerFocus, customDays: draft.customDays)
            .map { ProgramAdvisor.SplitDay(name: $0.name, groups: $0.groups.filter(trainable.contains)) }
            .filter { !$0.groups.isEmpty }
    }

    private var weekdaysSection: some View {
        let weekly = { () -> TrainingSchedule in var s = result; s.mode = .weekly; return s }()
        let days = templateDays
        return VStack(alignment: .leading, spacing: 12) {
            SectionEyebrow(text: String(localized: "TRAINING DAYS"))
            HStack(spacing: 6) {
                ForEach(Array(weekOrder.enumerated()), id: \.element) { offset, weekday in
                    let date = calendar.date(byAdding: .day, value: offset, to: thisWeekStart) ?? thisWeekStart
                    let plan = ProgramAdvisor.plan(on: date, schedule: weekly, days: days, calendar: calendar)
                    weekdayToggle(weekday, plan: plan)
                }
            }
            if draft.weekdays.isEmpty {
                MetaLine(text: String(localized: "NO FIXED DAYS · TRAIN SUGGESTS BY RECOVERY",
                                      comment: "Under the weekday toggles when none is on: the flexible plan"))
            } else {
                MetaLine(text: String(localized: "\(draft.weekdays.count) DAYS · TAP TO SWITCH TRAIN / REST",
                                      comment: "Under the weekday toggles: 3 DAYS · TAP TO SWITCH TRAIN / REST"))
            }
        }
    }

    private func weekdayToggle(_ weekday: Int, plan: ProgramAdvisor.DayPlan) -> some View {
        let isOn = draft.weekdays.contains(weekday)
        let name = CalendarDayMark(plan).shortName
        return Button {
            withAnimation(.easeOut(duration: 0.15)) {
                if isOn { draft.weekdays.removeAll { $0 == weekday } } else { draft.weekdays.append(weekday) }
            }
        } label: {
            VStack(spacing: 6) {
                Text(calendar.veryShortStandaloneWeekdaySymbols[weekday - 1])
                    .font(.ui(15, .semibold))
                Image(systemName: isOn ? "dumbbell.fill" : "moon.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .opacity(isOn ? 0.75 : 0.45)
                Text(name ?? " ")
                    .font(.mono(7, .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .opacity(0.7)
            }
            .foregroundStyle(isOn ? DS.ink : DS.silver)
            .padding(.vertical, 10)
            .padding(.horizontal, 2)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 76)
            .background(RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(isOn ? DS.silver : DS.surfaceAlt))
            .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
                .strokeBorder(DS.silver.opacity(isOn ? 0 : 0.08), lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(calendar.weekdaySymbols[weekday - 1])
        .accessibilityValue(isOn ? (plan.accessibilityText ?? String(localized: "Training day"))
                                 : String(localized: "Rest day"))
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }

    // MARK: - Weekly: split

    private var splitSection: some View {
        let count = draft.weekdays.count
        let best = count > 0 ? ProgramAdvisor.recommendedSplit(daysPerWeek: count, experience: experience) : nil
        return VStack(alignment: .leading, spacing: 10) {
            SectionEyebrow(text: String(localized: "SPLIT"))
            ForEach(Self.splitOrder) { split in
                OptionCard(symbol: OnboardingQuestion.symbol(split), title: split.title,
                           detail: splitDetail(split),
                           badge: split == best ? String(localized: "BEST FIT", comment: "Tag on the split that suits the days a week best") : nil,
                           isSelected: draft.split == split) {
                    withAnimation(.easeOut(duration: 0.15)) { pick(split) }
                }
            }
        }
    }

    /// Full Body first, the splits by how many days they take, Custom last.
    static let splitOrder: [TrainingSplit] = [.fullBody, .upperLower, .frontBack, .pushPullLegs, .bro, .custom]

    /// The split's days by name: "Push · Pull · Legs".
    private func splitDetail(_ split: TrainingSplit) -> String {
        if split == .custom, !draft.customDays.contains(where: { !$0.groups.isEmpty }) {
            return String(localized: "Name your days, pick the muscles.")
        }
        let customDays = split == .custom ? draft.customDays : []
        return ProgramAdvisor.days(of: split, lowerFocus: lowerFocus, customDays: customDays)
            .map(\.name).joined(separator: " · ")
    }

    /// Custom starts from the split it replaces, so there's something to
    /// edit rather than an empty list.
    private func pick(_ split: TrainingSplit) {
        if split == .custom, draft.customDays.isEmpty {
            draft.customDays = Self.seedDays(from: draft.split == .custom ? .pushPullLegs : draft.split,
                                             lowerFocus: lowerFocus)
        }
        draft.split = split
    }

    static func seedDays(from split: TrainingSplit, lowerFocus: Bool) -> [ScheduleDay] {
        ProgramAdvisor.days(of: split, lowerFocus: lowerFocus)
            .map { ScheduleDay(name: $0.name, groups: $0.groups.filter(PresetProvider.trainableGroups.contains)) }
    }

    // MARK: - Custom days

    private static let maxCustomDays = 7

    private var customDaysSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionEyebrow(text: String(localized: "YOUR DAYS · IN ORDER", comment: "A custom split's days, in rotation order"))
            ForEach($draft.customDays) { $day in
                customDayCard($day)
            }
            if draft.customDays.count < Self.maxCustomDays {
                Button {
                    withAnimation(.easeOut(duration: 0.15)) {
                        draft.customDays.append(ScheduleDay(name: String(localized: "Day \(draft.customDays.count + 1)",
                                                                         comment: "A new custom split day: Day 4"),
                                                            groups: []))
                    }
                } label: {
                    Label("Add day", systemImage: "plus")
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 52)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(DS.silver.opacity(0.18), style: StrokeStyle(lineWidth: 1, dash: [4, 4])))
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func customDayCard(_ day: Binding<ScheduleDay>) -> some View {
        let id = day.wrappedValue.id
        let index = draft.customDays.firstIndex { $0.id == id } ?? 0
        let isFirst = index == 0, isLast = index == draft.customDays.count - 1
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("\(index + 1)")
                    .font(.mono(11, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.4))
                    .frame(width: 18, alignment: .leading)
                    .accessibilityHidden(true)
                TextField(String(localized: "Day name"), text: day.name)
                    .font(.ui(17, .semibold))
                    .foregroundStyle(DS.silver)
                    .submitLabel(.done)
                    .accessibilityLabel(String(localized: "Name of day \(index + 1)"))
                iconButton("chevron.up", label: String(localized: "Move up"), disabled: isFirst) { move(id, by: -1) }
                iconButton("chevron.down", label: String(localized: "Move down"), disabled: isLast) { move(id, by: 1) }
                iconButton("trash", label: String(localized: "Delete day"), disabled: draft.customDays.count <= 1) {
                    withAnimation(.easeOut(duration: 0.15)) { draft.customDays.removeAll { $0.id == id } }
                }
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                ForEach(PresetProvider.trainableGroups) { group in
                    let isOn = day.wrappedValue.groups.contains(group)
                    BigChip(title: group.title, isOn: isOn) {
                        if isOn { day.wrappedValue.groups.removeAll { $0 == group } } else { day.wrappedValue.groups.append(group) }
                    }
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(DS.surfaceAlt))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
            .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
    }

    private func iconButton(_ symbol: String, label: String, disabled: Bool,
                            action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(disabled ? 0.2 : 0.75))
                .frame(width: 40, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .accessibilityLabel(label)
    }

    private func move(_ id: UUID, by offset: Int) {
        guard let from = draft.customDays.firstIndex(where: { $0.id == id }) else { return }
        let to = from + offset
        guard draft.customDays.indices.contains(to) else { return }
        withAnimation(.easeOut(duration: 0.18)) { draft.customDays.swapAt(from, to) }
    }

    // MARK: - By date: month

    /// This month and the five after it.
    private var monthRange: ClosedRange<Date> {
        let first = calendar.dateInterval(of: .month, for: Date())?.start ?? Date()
        let last = calendar.date(byAdding: .month, value: 5, to: first) ?? first
        return first...last
    }

    private var byDateSchedule: TrainingSchedule {
        var schedule = result
        schedule.mode = .byDate
        return schedule
    }

    private var monthSection: some View {
        let today = calendar.startOfDay(for: Date())
        let schedule = byDateSchedule
        let days = templateDays
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                iconButton("chevron.left", label: String(localized: "Previous month"),
                           disabled: month <= monthRange.lowerBound) { shiftMonth(-1) }
                Spacer()
                Text(month.formatted(.dateTime.month(.wide).year()))
                    .font(.ui(17, .semibold))
                    .foregroundStyle(DS.silver)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                iconButton("chevron.right", label: String(localized: "Next month"),
                           disabled: month >= monthRange.upperBound) { shiftMonth(1) }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 7), spacing: 5) {
                ForEach(Array(weekOrder.enumerated()), id: \.offset) { _, weekday in
                    Text(calendar.veryShortStandaloneWeekdaySymbols[weekday - 1])
                        .font(.mono(10, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.35))
                        .frame(maxWidth: .infinity)
                        .accessibilityHidden(true)
                }
                ForEach(monthCells(), id: \.offset) { item in
                    if let date = item.element {
                        let plan = ProgramAdvisor.plan(on: date, schedule: schedule, days: days, calendar: calendar)
                        dateCell(date, plan: plan, isPast: date < today,
                                 isSet: schedule.dated[TrainingSchedule.key(for: date, calendar: calendar)] != nil)
                    } else {
                        Color.clear.frame(height: 52).accessibilityHidden(true)
                    }
                }
            }
            MetaLine(text: String(localized: "DAYS YOU DON'T SET FOLLOW YOUR WEEK",
                                  comment: "Under the By date calendar"))
        }
    }

    private func shiftMonth(_ offset: Int) {
        guard let next = calendar.date(byAdding: .month, value: offset, to: month) else { return }
        withAnimation(.easeOut(duration: 0.18)) {
            month = min(max(next, monthRange.lowerBound), monthRange.upperBound)
        }
    }

    /// The month's dates in week rows, nil for the blanks before the 1st.
    private func monthCells() -> [EnumeratedSequence<[Date?]>.Element] {
        guard let interval = calendar.dateInterval(of: .month, for: month) else { return [] }
        let leading = (calendar.component(.weekday, from: interval.start) - calendar.firstWeekday + 7) % 7
        var cells: [Date?] = Array(repeating: nil, count: leading)
        var day = interval.start
        while day < interval.end {
            cells.append(day)
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = calendar.startOfDay(for: next)
        }
        return Array(cells.enumerated())
    }

    private func dateCell(_ date: Date, plan: ProgramAdvisor.DayPlan, isPast: Bool, isSet: Bool) -> some View {
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let mark = CalendarDayMark(plan)
        return Button {
            withAnimation(.easeOut(duration: 0.15)) { selectedDate = date }
        } label: {
            VStack(spacing: 4) {
                Text(date.formatted(.dateTime.day()))
                    .font(.ui(16, isSelected ? .semibold : .regular))
                ZStack {
                    if mark == .rest {
                        Image(systemName: "moon.fill").font(.system(size: 8.5, weight: .semibold))
                    } else if let name = mark.shortName {
                        Text(name)
                            .font(.mono(7, .semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            .padding(.horizontal, 2)
                    }
                }
                .frame(height: 9)
                .opacity(0.7)
            }
            .foregroundStyle(isSelected ? DS.ink : DS.silver)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isSelected ? DS.silver : DS.silver.opacity(0.04)))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                // A date set by hand is outlined.
                .strokeBorder(DS.silver.opacity(isSet && !isSelected ? 0.55 : 0.07), lineWidth: 1))
            .opacity(isPast ? 0.3 : 1)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isPast)
        .accessibilityLabel(date.formatted(date: .complete, time: .omitted))
        .accessibilityValue(mark.accessibilityText ?? "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    // MARK: - By date: the picked date

    private var dateSection: some View {
        let key = TrainingSchedule.key(for: selectedDate, calendar: calendar)
        let current = draft.dated[key]
        return VStack(alignment: .leading, spacing: 12) {
            SectionEyebrow(text: selectedDate.formatted(.dateTime.weekday(.wide).day().month(.wide)).uppercased())
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 8)], spacing: 8) {
                BigChip(title: String(localized: "Auto", comment: "A date that follows the weekly schedule"),
                        symbol: "arrow.triangle.2.circlepath", isOn: current == nil) {
                    draft.dated[key] = nil
                }
                BigChip(title: String(localized: "Rest", comment: "Set a date as a rest day"),
                        symbol: "moon.fill", isOn: current?.isRest == true) {
                    draft.dated[key] = .rest
                }
                ForEach(Array(templateDays.enumerated()), id: \.offset) { _, day in
                    let isOn = current.map { !$0.isRest && $0.name == day.name && $0.groups == day.groups } ?? false
                    BigChip(title: day.name, isOn: isOn) {
                        draft.dated[key] = DatedPlan(isRest: false, name: day.name, groups: day.groups)
                    }
                }
                // A date set from a day the split no longer has as it was
                // (its groups changed since): shown as set, under its name.
                if let current, !current.isRest, !current.groups.isEmpty,
                   !templateDays.contains(where: { $0.name == current.name && $0.groups == current.groups }) {
                    BigChip(title: current.name ?? String(localized: "Set", comment: "A date set by hand, no name"),
                            isOn: true) {}
                        .accessibilityHint(String(localized: "Set before the split's days changed",
                                                  comment: "VoiceOver hint on a stale date chip"))
                }
            }
        }
    }
}

extension CalendarDayMark {
    init(_ plan: ProgramAdvisor.DayPlan) {
        switch plan {
        case .train(let day): self = .train(day.name)
        case .rest: self = .rest
        case .open: self = .none
        }
    }
}

extension ProgramAdvisor.DayPlan {
    var accessibilityText: String? { CalendarDayMark(self).accessibilityText }
}

/// A large toggle: filled when on. At least 48pt tall for the thumb.
private struct BigChip: View {
    var title: String
    var symbol: String? = nil
    var isOn: Bool
    var action: () -> Void

    var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.12)) { action() }
        } label: {
            HStack(spacing: 6) {
                if let symbol {
                    Image(systemName: symbol).font(.system(size: 12, weight: .bold))
                }
                Text(title)
                    .font(.ui(14, .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .foregroundStyle(isOn ? DS.ink : DS.silver)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 48)
            .background(RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(isOn ? DS.silver : DS.silver.opacity(0.06)))
            .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
                .strokeBorder(DS.silver.opacity(isOn ? 0 : 0.1), lineWidth: 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}
