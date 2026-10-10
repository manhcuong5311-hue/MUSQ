//
//  TrainView.swift
//  GymWorkout
//
//  Tab 1. Open the app and see: the day, what's suggested, what's still
//  recovering, what has gone longest without training, and the workout in
//  progress. Every group stays tappable.
//
//  On iPad the same day reads at iPad scale. A regular column (portrait, a
//  Split View) keeps the phone's single scroll with larger type, the planned
//  groups side by side and wider card grids. A wide one splits into a Today
//  pane (the calendar as a grid and the workout in progress, at phone width)
//  beside the muscle groups. The phone keeps its own tree untouched.
//

import SwiftUI

struct TrainView: View {
    @Binding var tab: AppTab

    @Environment(WorkoutStore.self) private var store
    @Environment(Ads.self) private var ads
    @Environment(Paywall.self) private var paywall
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dsLayout) private var layout
    @State private var router = TrainRouter()
    @State private var selectedDay = Calendar.current.startOfDay(for: Date())
    /// The day the screen last took for today, so a return after midnight
    /// can tell the day has changed under it.
    @State private var today = Calendar.current.startOfDay(for: Date())
    @State private var infoGroup: MuscleGroup?
    /// The card whose recovery popover is open, in a regular-width iPad
    /// window. Chosen at tap time, so `infoGroup`'s sheet stays the phone's.
    @State private var popoverGroup: MuscleGroup?
    /// iPad wide: the Today pane's content height, so the pane hugs a short
    /// day instead of standing a near-empty card the window's full height.
    @State private var todayContentHeight: CGFloat?
    private let cardColors = CardColorPrefs()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    private var calendar: Calendar { .current }
    private var isToday: Bool { calendar.isDateInToday(selectedDay) }
    private var isPast: Bool { selectedDay < calendar.startOfDay(for: Date()) }

    /// The moment recovery is judged at: now for today, the same time of day
    /// on another selected day.
    private var referenceTime: Date {
        isToday ? Date() : selectedDay.addingTimeInterval(Date().timeIntervalSince(calendar.startOfDay(for: Date())))
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.path) {
            ZStack {
                DS.ink.ignoresSafeArea()

                if layout.isWide {
                    wideDashboard
                } else if layout.isRegular {
                    regularColumn
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            header
                            CalendarStrip(selection: $selectedDay, markedDays: store.trainedDays)
                                .padding(.top, 16)
                            dayHeading
                                .padding(.top, 22)
                                .padding(.horizontal, DS.Metric.gutter)
                            content
                        }
                        .padding(.top, 22)
                        .padding(.bottom, 24)
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            // Only the single-scroll layouts run under the status bar; over
            // the wide one's fixed header it repaints the ground it sits on,
            // so it can stay in every tier.
            .statusBarScrim()
            .background { dayShortcuts }
            .trainDestinations()
            .toolbar(.hidden, for: .navigationBar)
        }
        .environment(router)
        .tint(DS.silver)
        .sheet(item: $infoGroup) { group in
            if let record = store.recoveryRecords(at: referenceTime)[group] {
                RecoveryInfoSheet(
                    group: group,
                    record: record,
                    onViewExercises: { router.push(.preset(group, day: selectedDay)) },
                    onTrainAnyway: {
                        planAnyway(group)
                        router.push(.preset(group, day: selectedDay))
                    }
                )
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { followNewDay() }
        }
        // Posted at midnight while the app is open, and on wake when the
        // phone slept through it.
        .task {
            for await _ in NotificationCenter.default.notifications(named: .NSCalendarDayChanged) {
                followNewDay()
            }
        }
    }

    /// Once midnight has passed, moves the selection to the new today if it
    /// was on the old one, so new sets aren't logged to yesterday. A day the
    /// user picked on purpose stays picked.
    private func followNewDay() {
        let now = calendar.startOfDay(for: Date())
        guard now != today else { return }
        if calendar.isDate(selectedDay, inSameDayAs: today) { selectedDay = now }
        today = now
    }

    // MARK: - Header

    /// A hello by name, then a line about the day picked below (see
    /// `GreetingHeader`). The tab bar already says this is Train.
    private var header: some View {
        GreetingHeader(greeting: greeting())
            .padding(.horizontal, DS.Metric.gutter)
    }

    /// - Parameter roomy: an iPad header, wide enough for a longer name.
    private func greeting(roomy: Bool = false) -> Greeting {
        let planned = store.session(on: selectedDay)?.groups ?? []
        // What the planner would suggest for that day, to name in a question;
        // a past day is a log, so it suggests nothing.
        let suggested = isPast ? [] : TrainingPlanner(records: store.recoveryRecords(at: referenceTime),
                                                      now: referenceTime,
                                                      rotation: ProgramAdvisor.rotation(for: store.profile))
            .recommended(planned: planned)
        return Greeting(name: store.profile?.name, sessions: store.sessions,
                        selected: selectedDay, next: splitDay(for: suggested)?.name, roomy: roomy)
    }

    /// The split's day a suggestion comes from: the one sharing most groups.
    private func splitDay(for groups: [MuscleGroup]) -> ProgramAdvisor.SplitDay? {
        guard !groups.isEmpty else { return nil }
        return ProgramAdvisor.days(for: store.profile)
            .max { $0.groups.filter(groups.contains).count < $1.groups.filter(groups.contains).count }
    }

    private var dayEyebrow: String {
        isToday ? "TODAY" : selectedDay
            .formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated)).uppercased()
    }

    private var dayTitle: String {
        isToday ? "Recommended Workout" : isPast ? "Workout Log" : "Plan Ahead"
    }

    private var showsLegend: Bool { !isPast && cardColors.mode != .off }

    private var dayHeading: some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionEyebrow(text: dayEyebrow)
            Text(dayTitle)
                .font(.ui(20, .semibold))
                .tracking(-0.4)
                .foregroundStyle(DS.silver)
            if showsLegend {
                rhythmLegend
                    .padding(.top, 8)
            }
        }
    }

    /// What the card edges mean. VoiceOver skips it: the cards' labels say
    /// whether a group is recovering, and add "due" to the ones that are.
    private var rhythmLegend: some View {
        legend(dot: 7, size: 8.5)
    }

    private func legend(dot: CGFloat, size: CGFloat) -> some View {
        HStack(spacing: 14) {
            ForEach(cardColors.mode.tones, id: \.self) { tone in
                HStack(spacing: 5) {
                    Circle()
                        .fill(cardColors.color(for: tone))
                        .frame(width: dot, height: dot)
                    MetaLine(text: tone.title(reset: cardColors.reset).uppercased(), size: size)
                }
            }
        }
        .accessibilityHidden(true)
    }

    /// The iPad's heading: the title at section scale with the legend on its
    /// baseline, or under it where a narrow column can't hold both.
    private var dayHeadingRow: some View {
        let title = VStack(alignment: .leading, spacing: 5) {
            SectionEyebrow(text: dayEyebrow)
            Text(dayTitle)
                .font(.ui(layout.text(.sectionTitle), .semibold))
                .tracking(-0.5)
                .foregroundStyle(DS.silver)
                .lineLimit(1)
        }
        // 9.5 is MetaLine's default, which it grows to iPad size itself.
        let key = legend(dot: 8, size: 9.5)
        return ViewThatFits(in: .horizontal) {
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                title
                Spacer(minLength: 24)
                if showsLegend { key }
            }
            VStack(alignment: .leading, spacing: 12) {
                title
                if showsLegend { key }
            }
        }
    }

    // MARK: - Content

    /// The day's groups, sorted into the sections the screen shows.
    private struct DayGroups {
        var records: [MuscleGroup: MuscleTrainingRecord]
        /// Every trainable group not planned: a past day's LOG A WORKOUT.
        var trainable: [MuscleGroup]
        var trained: Set<MuscleGroup> = []
        var recommended: [MuscleGroup] = []
        var recent: [MuscleGroup] = []
        var others: [MuscleGroup] = []
    }

    private func dayGroups(planned: [MuscleGroup]) -> DayGroups {
        let records = store.recoveryRecords(at: referenceTime)
        let trainable = ProgramAdvisor.ordered(PresetProvider.trainableGroups, for: store.profile)
            .filter { !planned.contains($0) }
        guard !isPast else { return DayGroups(records: records, trainable: trainable) }

        let trained = cardColors.mode == .off ? []
            : store.trainedThisRound(at: referenceTime, reset: cardColors.reset)
        let recommended = TrainingPlanner(records: records, now: referenceTime,
                                          rotation: ProgramAdvisor.rotation(for: store.profile))
            .recommended(planned: planned).filter { !planned.contains($0) }
        let recent = trainable
            .filter { !recommended.contains($0) && (records[$0].map { $0.status != .ready } ?? false) }
            .sorted { (records[$0]?.lastTrainedAt ?? .distantPast) > (records[$1]?.lastTrainedAt ?? .distantPast) }
        // Least recently trained first, never-trained groups on top, so
        // what's been left out leads MORE MUSCLE GROUPS (after anything
        // still recovering). Compared by day, so groups from one session
        // keep the program's order (the sort is stable).
        let others = trainable
            .filter { !recommended.contains($0) && !recent.contains($0) }
            .sorted { trainedDay(records[$0]) < trainedDay(records[$1]) }
        return DayGroups(records: records, trainable: trainable, trained: trained,
                         recommended: recommended, recent: recent, others: others)
    }

    /// Names the split's day: the one the suggestion comes from.
    private func recommendedTitle(_ recommended: [MuscleGroup]) -> String {
        let day = splitDay(for: recommended)
        let title = isToday ? "RECOMMENDED TODAY" : "RECOMMENDED"
        return day.map { "\(title) · \($0.name.uppercased())" } ?? title
    }

    private static let restedNote =
        "Everything in the rotation was trained recently. Pick any group below — recovery times are only estimates."

    @ViewBuilder
    private var content: some View {
        let session = store.session(on: selectedDay)
        let planned = session?.groups ?? []
        let groups = dayGroups(planned: planned)

        if let session, !session.exercises.isEmpty {
            workoutSection(session)
                .padding(.top, 16)
        }

        if isPast {
            groupSection("LOG A WORKOUT", groups: groups.trainable, records: groups.records, trained: [])
        } else {
            if !groups.recommended.isEmpty {
                groupSection(recommendedTitle(groups.recommended),
                             groups: groups.recommended, records: groups.records, trained: groups.trained)
            } else if planned.isEmpty {
                Text(Self.restedNote)
                    .font(.ui(13))
                    .cssLineHeight(13, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 16)
            }
            if !groups.recent.isEmpty {
                groupSection("RECENTLY TRAINED", groups: groups.recent, records: groups.records, trained: groups.trained)
            }
            if !groups.others.isEmpty {
                groupSection("MORE MUSCLE GROUPS", groups: groups.others, records: groups.records, trained: groups.trained)
            }
        }
    }

    private func groupSection(_ title: String, groups: [MuscleGroup],
                              records: [MuscleGroup: MuscleTrainingRecord],
                              trained: Set<MuscleGroup>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionEyebrow(text: title)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(groups) { group in
                    card(group, record: records[group], trained: trained)
                }
            }
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 24)
    }

    private func card(_ group: MuscleGroup, record: MuscleTrainingRecord?,
                      trained: Set<MuscleGroup>, size: MuscleCardSize = .standard) -> some View {
        let state = isPast ? MuscleCardState.ready : MuscleCardState(record?.status)
        // What the group opens on: the user's own list, else the preset.
        let exerciseCount = store.preview(group, level: store.defaultLevel(for: group)).count
        let exercises = "\(exerciseCount) \(exerciseCount == 1 ? "exercise" : "exercises")"
        // Recent load that doesn't hold the group back. A past day is a log,
        // not advice, so it shows none.
        let note: String? = isPast ? nil : record?.sideNotes.first.map { RecoveryText.sideNote($0, now: referenceTime) }
        let detail: String
        var secondary: String? = nil
        if let record, state == .partlyReady {
            // Name the parts, so a chest day reads as "front delts" rather
            // than "shoulders".
            detail = RecoveryText.recovering(record.tiredParts.map(\.part))
            secondary = RecoveryText.ready(record.readyParts)
        } else if let record, state != .ready {
            detail = RecoveryText.trainedAgo(record.lastTrainedAt, now: referenceTime)
            secondary = "Est. \(RecoveryText.remaining(record.hoursRemaining))"
        } else if !isPast, let last = record?.lastCountedAt {
            // READY alone can't tell a group trained two days ago from one
            // never trained, so say when it last was, where a recovering card
            // does. Helping on another group's day isn't training it.
            detail = RecoveryText.trainedAgo(last, now: referenceTime)
            secondary = note ?? exercises
        } else {
            detail = exercises
            secondary = note
        }
        let tone = tone(for: group, state: state, trained: trained)
        let recovering = !isPast && record.map { $0.status != .ready } == true
        return MuscleGroupCard(group: group, state: state, detail: detail, secondaryDetail: secondary,
                               tone: tone, edgeColor: cardColors.edge(for: tone), size: size) {
            if recovering {
                showRecovery(group)
            } else {
                router.push(.preset(group, day: selectedDay))
            }
        } accessory: {
            PresetMenu(group: group) { open(group, on: $0) }
        }
        // Only ever presented in a regular window (see `showRecovery`), so
        // the phone's cards never carry it.
        .onPad {
            $0.dsPopover(item: popoverItem(for: group)) { group in
                recoveryPopover(group)
            }
        }
        .modifier(PadContextMenu(radius: size.metrics.radius) {
            if recovering {
                Section {
                    Button { showRecovery(group) } label: {
                        Label("Recovery details", systemImage: "clock.arrow.circlepath")
                    }
                }
            }
            PresetMenuSections(group: group) { open(group, on: $0) }
        })
    }

    /// Where the group stands this round, for its card's edge (see
    /// `TrainingRound`). Red while it recovers: still recovering, or trained
    /// this round and not all the way back. Yellow once trained this round
    /// and recovered, and it stays yellow, so the groups still waiting for
    /// their turn are the green ones until each has had it. Green for those,
    /// almost or partly ready included: the planner suggests them too. A
    /// full round only covers the split, so a group outside it is never due.
    /// None on a past day, which is a log, or with card colours off.
    private func tone(for group: MuscleGroup, state: MuscleCardState,
                      trained: Set<MuscleGroup>) -> MuscleCardTone? {
        guard !isPast, cardColors.mode != .off else { return nil }
        if state == .recovering { return .waiting }
        if trained.contains(group) { return state == .ready ? .recent : .waiting }
        if cardColors.reset == .fullRound, !store.roundSplit.contains(group) { return nil }
        return .due
    }

    /// The calendar day a group was last really trained; never sorts first.
    private func trainedDay(_ record: MuscleTrainingRecord?) -> Date {
        record?.lastCountedAt.map { calendar.startOfDay(for: $0) } ?? .distantPast
    }

    /// Opens the group on a preset picked from its ⋯ menu. A planned group
    /// switches to it first, keeping exercises already started; an
    /// unplanned one only shows it until the user adds it. A preset with
    /// nothing in it never clears a planned group.
    private func open(_ group: MuscleGroup, on level: PresetLevel) {
        if store.exercises(for: group, on: selectedDay).isEmpty {
            router.push(.preset(group, day: selectedDay, level: level))
        } else {
            if store.level(for: group, on: selectedDay) != level,
               !store.preview(group, level: level).isEmpty {
                store.switchLevel(group, on: selectedDay, to: level)
            }
            router.push(.preset(group, day: selectedDay))
        }
    }

    // MARK: - Recovery info

    /// A sheet on the phone, a popover on the card in a regular iPad window.
    /// The style is fixed here, at the tap, so a window resized while it's
    /// open never swaps one for the other.
    private func showRecovery(_ group: MuscleGroup) {
        if layout.isRegular {
            popoverGroup = group
        } else {
            infoGroup = group
        }
    }

    /// The popover's item as seen by one card: its own group or nothing, so
    /// only the tapped card presents.
    private func popoverItem(for group: MuscleGroup) -> Binding<MuscleGroup?> {
        Binding(
            get: { popoverGroup == group ? group : nil },
            set: { if $0 == nil, popoverGroup == group { popoverGroup = nil } }
        )
    }

    @ViewBuilder
    private func recoveryPopover(_ group: MuscleGroup) -> some View {
        if let record = store.recoveryRecords(at: referenceTime)[group] {
            RecoveryInfoSheet(
                group: group,
                record: record,
                presentation: .popover,
                onViewExercises: {
                    pushAfterPopover(.preset(group, day: selectedDay))
                },
                onTrainAnyway: {
                    planAnyway(group)
                    pushAfterPopover(.preset(group, day: selectedDay))
                }
            )
        }
    }

    /// Closes the popover, then pushes on the next turn of the run loop: a
    /// push in the same turn as the dismissal can be dropped.
    private func pushAfterPopover(_ route: TrainRoute) {
        popoverGroup = nil
        Task { @MainActor in router.push(route) }
    }

    /// "Train Anyway": plans the group on the selected day at the preset it
    /// would open on.
    private func planAnyway(_ group: MuscleGroup) {
        let level = store.level(for: group, on: selectedDay) ?? store.defaultLevel(for: group)
        store.ensurePlan(group, on: selectedDay, level: level,
                         planned: store.preview(group, level: level))
    }

    // MARK: - Workout in progress

    private func workoutSection(_ session: WorkoutSession) -> some View {
        workoutStack(session)
            .padding(.horizontal, DS.Metric.gutter)
    }

    /// The phone's section, rows one per line: on iPhone, and at phone width
    /// in the iPad's Today pane.
    private func workoutStack(_ session: WorkoutSession) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            workoutHeader(session)

            ForEach(session.groups) { group in
                workoutRow(group, in: session)
            }

            if store.canLog(on: selectedDay) {
                if session.completedAt != nil {
                    completedLine
                        .font(.ui(13, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 6)

                    if isToday, let walk = store.walkSuggestion {
                        walkCard(walk, session: session)
                            .padding(.top, 8)
                    }
                } else {
                    completeButton(session)
                        .padding(.top, 4)
                    if !session.hasCompletedSets {
                        Text(Self.completeHint)
                            .font(.ui(11.5))
                            .foregroundStyle(DS.silver.opacity(0.4))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    private static let completeHint = "Mark at least one set done to complete the workout."

    private func workoutHeader(_ session: WorkoutSession) -> some View {
        let done = session.exercises.reduce(0) { $0 + $1.completedSets.count }
        let total = session.exercises.reduce(0) { $0 + $1.sets.count }
        return HStack(alignment: .firstTextBaseline) {
            SectionEyebrow(text: session.completedAt != nil ? "COMPLETED WORKOUT" : "YOUR WORKOUT")
            Spacer()
            MetaLine(text: "\(done) OF \(total) SETS", em: 0.08)
        }
    }

    private func workoutRow(_ group: MuscleGroup, in session: WorkoutSession,
                            size: MuscleCardSize = .standard) -> some View {
        let exercises = session.exercises.filter { $0.group == group }
        let current = store.level(for: group, on: selectedDay)
        let radius: CGFloat = size == .standard ? 16 : 20
        return Button {
            router.push(.preset(group, day: selectedDay))
        } label: {
            WorkoutGroupRow(group: group, exercises: exercises, isToday: isToday,
                            workoutCompleted: session.completedAt != nil, showsChevron: false,
                            size: size)
        }
        .buttonStyle(.plain)
        .overlay(alignment: .trailing) {
            PresetMenu(group: group, current: current) {
                open(group, on: $0)
            }
            // Centred on the row's reserved trailing slot.
            .padding(.trailing, size == .standard ? 4 : 6)
        }
        .dsHover(.lift, radius: radius)
        .modifier(PadContextMenu(radius: radius) {
            PresetMenuSections(group: group, current: current) { open(group, on: $0) }
        })
    }

    private var completedLine: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill")
            Text("Workout completed · recovery updated")
        }
    }

    private func completeButton(_ session: WorkoutSession) -> some View {
        WideButton(title: "Complete Workout", prominent: session.hasCompletedSets) {
            withAnimation(.easeOut(duration: 0.2)) { store.completeWorkout(on: selectedDay) }
            ads.moment(.workoutCompleted)
        }
        .disabled(!session.hasCompletedSets)
        .opacity(session.hasCompletedSets ? 1 : 0.5)
    }

    private func walkCard(_ walk: WalkSuggestion, session: WorkoutSession) -> some View {
        WalkCard(walk: walk, isDone: session.walkDone == true) { done in
            withAnimation(.easeOut(duration: 0.2)) { store.setWalkDone(done, on: selectedDay) }
        }
    }

    // MARK: - iPad: regular column

    /// One centred scroll, as on the phone, at iPad scale: the planned
    /// groups two to a row and the muscle groups in as many columns as fit.
    private var regularColumn: some View {
        let session = store.session(on: selectedDay)
        let planned = session?.groups ?? []
        let groups = dayGroups(planned: planned)
        let width = max(0, min(layout.containerWidth, DS.Layout.contentMaxWidth) - 2 * layout.gutter)
        return ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                GreetingHeader(greeting: greeting(roomy: true), fontSize: 36)
                    .padding(.horizontal, layout.gutter)
                CalendarStrip(selection: $selectedDay, markedDays: store.trainedDays)
                    .padding(.top, 20)
                dayHeadingRow
                    .padding(.top, 28)
                    .padding(.horizontal, layout.gutter)
                VStack(alignment: .leading, spacing: layout.sectionSpacing) {
                    if let session, !session.exercises.isEmpty {
                        regularWorkoutSection(session, width: width)
                    }
                    sections(groups, planned: planned, width: width)
                }
                .padding(.top, 24)
                .padding(.horizontal, layout.gutter)
            }
            .dsReadable(DS.Layout.contentMaxWidth)
            .padding(.top, 22)
            .padding(.bottom, 32)
        }
    }

    private func regularWorkoutSection(_ session: WorkoutSession, width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            workoutHeader(session)

            LazyVGrid(columns: DS.flexibleColumns(width >= 560 ? 2 : 1, spacing: 12), spacing: 12) {
                ForEach(session.groups) { group in
                    workoutRow(group, in: session, size: .regular)
                }
            }

            if store.canLog(on: selectedDay) {
                if session.completedAt != nil {
                    completedLine
                        .font(.ui(14, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                        .padding(.top, 4)

                    if isToday, let walk = store.walkSuggestion {
                        walkCard(walk, session: session)
                            .dsReadable(560, alignment: .leading)
                            .padding(.top, 4)
                    }
                } else {
                    // The hint beside what it explains, the button at a
                    // button's width rather than the column's.
                    HStack(alignment: .center, spacing: 20) {
                        if !session.hasCompletedSets {
                            Text(Self.completeHint)
                                .font(.ui(13))
                                .foregroundStyle(DS.silver.opacity(0.45))
                                .dsReadable(420, alignment: .leading)
                        }
                        Spacer(minLength: 0)
                        completeButton(session)
                            .frame(width: 260)
                    }
                    .padding(.top, 4)
                }
            }
        }
    }

    // MARK: - iPad: wide dashboard

    /// A header across the column, then the Today pane (calendar grid and
    /// the workout, at phone width) beside the muscle groups, each scrolling
    /// on its own. Centred at the dashboard's width in a window larger than
    /// any iPad's own screen (Stage Manager on a display).
    private var wideDashboard: some View {
        let width = min(layout.containerWidth, DS.Layout.dashboardMaxWidth + 2 * layout.gutter)
        let paneWidth = layout.paneWidth(0.34, min: 340, max: 400)
        let trailingWidth = max(0, width - 2 * layout.gutter - paneWidth - layout.paneGap)
        return VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline, spacing: 24) {
                GreetingHeader(greeting: greeting(roomy: true), fontSize: 40)
                SectionEyebrow(text: today.formatted(.dateTime.weekday(.wide).day().month(.wide)).uppercased())
                    .lineLimit(1)
                    .fixedSize()
            }
            .padding(.horizontal, layout.gutter)
            .padding(.top, 22)

            HStack(alignment: .top, spacing: 0) {
                todayPane
                    .frame(width: paneWidth)
                    .environment(\.dsLayout, layout.with(containerWidth: paneWidth))
                    .padding(.leading, layout.gutter)
                    // Level with the foot of the sidebar card.
                    .padding(.bottom, 10)
                // The gap and gutter are inside the scroll, so card halos
                // and the hover lift aren't clipped at its edges.
                ScrollView(showsIndicators: false) {
                    trailingPane(width: trailingWidth)
                        .padding(.leading, layout.paneGap)
                        .padding(.trailing, layout.gutter)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                }
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: width)
        .frame(maxWidth: .infinity)
    }

    private var todayPane: some View {
        let session = store.session(on: selectedDay)
        return ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                CalendarGrid(selection: $selectedDay, markedDays: store.trainedDays)
                Hairline()
                    .padding(.vertical, 20)
                if let session, !session.exercises.isEmpty {
                    workoutStack(session)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionEyebrow(text: "YOUR WORKOUT")
                        emptyWorkout
                    }
                }
            }
            .padding(16)
            .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { todayContentHeight = $0 }
        }
        .scrollBounceBehavior(.basedOnSize)
        // As tall as its content, and scrolling only past the window's foot.
        .frame(maxHeight: todayContentHeight ?? .infinity, alignment: .top)
        .clipShape(RoundedRectangle(cornerRadius: DS.Layout.paneRadius, style: .continuous))
        .dsPane()
    }

    /// Holds the workout's place in the Today pane until a group is picked.
    private var emptyWorkout: some View {
        Text(isPast ? "Pick a muscle group to log it" : isToday ? "Pick a muscle group to start"
             : "Pick a muscle group to plan it")
            .font(.ui(14))
            .foregroundStyle(DS.silver.opacity(0.5))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.13), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            )
    }

    private func trailingPane(width: CGFloat) -> some View {
        let planned = store.session(on: selectedDay)?.groups ?? []
        let groups = dayGroups(planned: planned)
        return VStack(alignment: .leading, spacing: 0) {
            dayHeadingRow
            VStack(alignment: .leading, spacing: layout.sectionSpacing) {
                sections(groups, planned: planned, width: width)
            }
            .padding(.top, 24)
        }
    }

    // MARK: - iPad: group sections

    /// RECOMMENDED as hero cards, then the other groups in a grid, for
    /// `width` of column.
    @ViewBuilder
    private func sections(_ groups: DayGroups, planned: [MuscleGroup], width: CGFloat) -> some View {
        if isPast {
            gridSection("LOG A WORKOUT", groups: groups.trainable, records: groups.records,
                        trained: [], width: width)
        } else {
            if !groups.recommended.isEmpty {
                heroSection(recommendedTitle(groups.recommended), groups: groups.recommended,
                            records: groups.records, trained: groups.trained, width: width)
            } else if planned.isEmpty {
                Text(Self.restedNote)
                    .font(.ui(15))
                    .cssLineHeight(15, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 420)
                    .frame(maxWidth: .infinity)
            }
            if !groups.recent.isEmpty {
                gridSection("RECENTLY TRAINED", groups: groups.recent, records: groups.records,
                            trained: groups.trained, width: width)
            }
            if !groups.others.isEmpty {
                gridSection("MORE MUSCLE GROUPS", groups: groups.others, records: groups.records,
                            trained: groups.trained, width: width)
            }
        }
    }

    /// Hero cards stay at least 215pt, where "Trained 4 days ago" still
    /// fits on one line beside the larger figure; they're never more than
    /// 420, where a lone one would turn into a banner.
    private func heroSection(_ title: String, groups: [MuscleGroup],
                             records: [MuscleGroup: MuscleTrainingRecord],
                             trained: Set<MuscleGroup>, width: CGFloat) -> some View {
        let spacing: CGFloat = 14
        let fit = layout.columnCount(fitting: width, minimum: 215, spacing: spacing,
                                     range: layout.isWide ? 2...4 : 2...3)
        let count = max(1, min(groups.count, fit))
        let maxWidth = CGFloat(count) * 420 + CGFloat(count - 1) * spacing
        return VStack(alignment: .leading, spacing: 14) {
            SectionEyebrow(text: title)
            LazyVGrid(columns: DS.flexibleColumns(count, spacing: spacing), spacing: spacing) {
                ForEach(groups) { group in
                    card(group, record: records[group], trained: trained, size: .hero)
                }
            }
            .frame(maxWidth: maxWidth, alignment: .leading)
        }
    }

    /// Regular cards at least 200pt wide, the narrowest that keeps PARTLY
    /// READY and "Est. ~35h remaining" each on a line beside the figure;
    /// two columns where three would be cramped.
    private func gridSection(_ title: String, groups: [MuscleGroup],
                             records: [MuscleGroup: MuscleTrainingRecord],
                             trained: Set<MuscleGroup>, width: CGFloat) -> some View {
        let spacing: CGFloat = 14
        let count = layout.columnCount(fitting: width, minimum: 200, spacing: spacing,
                                       range: layout.isWide ? 2...5 : 2...4)
        return VStack(alignment: .leading, spacing: 14) {
            SectionEyebrow(text: title)
            LazyVGrid(columns: DS.flexibleColumns(count, spacing: spacing), spacing: spacing) {
                ForEach(groups) { group in
                    card(group, record: records[group], trained: trained, size: .regular)
                }
            }
        }
    }

    // MARK: - iPad: keyboard

    /// ← and → step through the calendar's days, ⌘T goes back to today. Only
    /// while the dashboard itself is showing, so the arrows never move the
    /// day under a pushed screen, a sheet or an open popover.
    @ViewBuilder
    private var dayShortcuts: some View {
        if DS.isPad, router.path.isEmpty, infoGroup == nil, popoverGroup == nil, paywall.reason == nil {
            ZStack {
                Button("Previous Day") { moveSelection(by: -1) }
                    .keyboardShortcut(.leftArrow, modifiers: [])
                Button("Next Day") { moveSelection(by: 1) }
                    .keyboardShortcut(.rightArrow, modifiers: [])
                Button("Today") {
                    withAnimation(.easeOut(duration: 0.18)) { selectedDay = calendar.startOfDay(for: Date()) }
                }
                .keyboardShortcut("t", modifiers: .command)
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            .accessibilityHidden(true)
            .allowsHitTesting(false)
        }
    }

    /// Moves the selection by whole days, within the calendar's range.
    private func moveSelection(by days: Int) {
        let now = calendar.startOfDay(for: Date())
        let range = CalendarStrip.range
        guard let day = calendar.date(byAdding: .day, value: days, to: calendar.startOfDay(for: selectedDay)),
              let first = calendar.date(byAdding: .day, value: range.lowerBound, to: now),
              let last = calendar.date(byAdding: .day, value: range.upperBound, to: now),
              day >= first, day <= last else { return }
        withAnimation(.easeOut(duration: 0.18)) { selectedDay = day }
    }
}

/// A context menu on iPad (right-click, or a long press), with the lifted
/// preview rounded like the card; nothing on iPhone, where a long press on a
/// card stays what it is today.
private struct PadContextMenu<Items: View>: ViewModifier {
    var radius: CGFloat
    @ViewBuilder var items: () -> Items

    func body(content: Content) -> some View {
        if DS.isPad {
            content
                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: radius, style: .continuous))
                .contextMenu { items() }
        } else {
            content
        }
    }
}

private extension View {
    /// `transform` on iPad only; on iPhone the view is left exactly as it is.
    @ViewBuilder func onPad<V: View>(@ViewBuilder _ transform: (Self) -> V) -> some View {
        if DS.isPad { transform(self) } else { self }
    }
}

/// One planned group inside today's workout, with its set progress.
struct WorkoutGroupRow: View {
    var group: MuscleGroup
    var exercises: [WorkoutExercise]
    var isToday: Bool
    /// A finished workout counts every group with logged sets as completed.
    var workoutCompleted = false
    /// Off when a control sits over the row's trailing edge instead.
    var showsChevron = true
    /// The phone's metrics, or the iPad grid's larger ones (`.hero` reads
    /// as `.regular`).
    var size: MuscleCardSize = .standard

    private var done: Int { exercises.reduce(0) { $0 + $1.completedSets.count } }
    private var total: Int { exercises.reduce(0) { $0 + $1.sets.count } }
    private var state: MuscleCardState {
        let finished = (workoutCompleted && done > 0)
            || (!exercises.isEmpty && exercises.allSatisfy { $0.isCompleted || $0.sets.allSatisfy(\.isCompleted) })
        if finished { return isToday ? .completedToday : .completed }
        return done > 0 ? .inProgress : .planned
    }

    var body: some View {
        let regular = size != .standard
        let radius: CGFloat = regular ? 20 : 16
        HStack(spacing: regular ? 14 : 12) {
            MiniBodyMap(group: group)
                .frame(width: regular ? 32 : 26, height: regular ? 72 : 60)
            VStack(alignment: .leading, spacing: regular ? 6 : 5) {
                HStack {
                    Text(group.title)
                        .font(.ui(regular ? 16 : 15, .semibold))
                        .foregroundStyle(DS.silver)
                        // Two to a row on iPad, beside a longer state.
                        .lineLimit(regular ? 1 : nil)
                        .minimumScaleFactor(regular ? 0.85 : 1)
                    Spacer()
                    MuscleStateLabel(state: state, size: regular ? 9.5 : 8.5)
                }
                Text("\(exercises.count) \(exercises.count == 1 ? "exercise" : "exercises") · \(done) of \(total) sets done")
                    .font(.ui(regular ? 13 : 12))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .lineLimit(regular ? 1 : nil)
                    .minimumScaleFactor(regular ? 0.85 : 1)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(DS.silver.opacity(0.08))
                        Capsule()
                            .fill(DS.silver.opacity(0.7))
                            .frame(width: total > 0 ? geo.size.width * CGFloat(done) / CGFloat(total) : 0)
                    }
                }
                .frame(height: regular ? 5 : 4)
            }
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.3))
            } else {
                Color.clear.frame(width: 28, height: 1)
            }
        }
        .padding(regular ? 14 : 12)
        .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(DS.surfaceAlt)
        )
        .overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}
