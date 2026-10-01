//
//  TrainView.swift
//  GymWorkout
//
//  Tab 1. Open the app and see: the day, what's suggested, what's still
//  recovering, and the workout in progress. Every group stays tappable.
//

import SwiftUI

struct TrainView: View {
    @Binding var tab: AppTab

    @Environment(WorkoutStore.self) private var store
    @Environment(Ads.self) private var ads
    @Environment(\.scenePhase) private var scenePhase
    @State private var router = TrainRouter()
    @State private var selectedDay = Calendar.current.startOfDay(for: Date())
    /// The day the screen last took for today, so a return after midnight
    /// can tell the day has changed under it.
    @State private var today = Calendar.current.startOfDay(for: Date())
    @State private var infoGroup: MuscleGroup?

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
            .safeAreaInset(edge: .bottom, spacing: 0) {
                TabBarView(selection: $tab)
            }
            .statusBarScrim()
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
                        let level = store.level(for: group, on: selectedDay) ?? store.defaultLevel(for: group)
                        store.ensurePlan(group, on: selectedDay, level: level,
                                         planned: store.preview(group, level: level))
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

    private var header: some View {
        Text("Train")
            .font(.ui(28, .semibold))
            .tracking(-0.7)
            .foregroundStyle(DS.silver)
            .padding(.horizontal, DS.Metric.gutter)
    }

    private var dayHeading: some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionEyebrow(text: isToday ? "TODAY" : selectedDay
                .formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated)).uppercased())
            Text(isToday ? "Recommended Workout" : isPast ? "Workout Log" : "Plan Ahead")
                .font(.ui(20, .semibold))
                .tracking(-0.4)
                .foregroundStyle(DS.silver)
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        let session = store.session(on: selectedDay)
        let records = store.recoveryRecords(at: referenceTime)
        let planned = session?.groups ?? []
        let trainable = ProgramAdvisor.ordered(PresetProvider.trainableGroups, for: store.profile)
            .filter { !planned.contains($0) }

        if let session, !session.exercises.isEmpty {
            workoutSection(session)
                .padding(.top, 16)
        }

        if isPast {
            groupSection("LOG A WORKOUT", groups: trainable, records: records)
        } else {
            let recommended = TrainingPlanner(records: records, now: referenceTime,
                                              rotation: ProgramAdvisor.rotation(for: store.profile))
                .recommended(planned: planned).filter { !planned.contains($0) }
            let recent = trainable
                .filter { !recommended.contains($0) && (records[$0].map { $0.status != .ready } ?? false) }
                .sorted { (records[$0]?.lastTrainedAt ?? .distantPast) > (records[$1]?.lastTrainedAt ?? .distantPast) }
            let others = trainable.filter { !recommended.contains($0) && !recent.contains($0) }

            if !recommended.isEmpty {
                // Name the split's day: the one the suggestion comes from.
                let day = ProgramAdvisor.days(for: store.profile)
                    .max { $0.groups.filter(recommended.contains).count < $1.groups.filter(recommended.contains).count }
                let title = isToday ? "RECOMMENDED TODAY" : "RECOMMENDED"
                groupSection(day.map { "\(title) · \($0.name.uppercased())" } ?? title,
                             groups: recommended, records: records)
            } else if planned.isEmpty {
                Text("Everything in the rotation was trained recently. Pick any group below — recovery times are only estimates.")
                    .font(.ui(13))
                    .cssLineHeight(13, 1.5)
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .padding(.horizontal, DS.Metric.gutter)
                    .padding(.top, 16)
            }
            if !recent.isEmpty {
                groupSection("RECENTLY TRAINED", groups: recent, records: records)
            }
            if !others.isEmpty {
                groupSection("MORE MUSCLE GROUPS", groups: others, records: records)
            }
        }
    }

    private func groupSection(_ title: String, groups: [MuscleGroup],
                              records: [MuscleGroup: MuscleTrainingRecord]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionEyebrow(text: title)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(groups) { group in
                    card(group, record: records[group])
                }
            }
        }
        .padding(.horizontal, DS.Metric.gutter)
        .padding(.top, 24)
    }

    private func card(_ group: MuscleGroup, record: MuscleTrainingRecord?) -> some View {
        let state = isPast ? MuscleCardState.ready : MuscleCardState(record?.status)
        // What the group opens on: the user's own list, else the preset.
        let exerciseCount = store.preview(group, level: store.defaultLevel(for: group)).count
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
        } else {
            detail = "\(exerciseCount) exercises"
            if !isPast, let note = record?.sideNotes.first {
                secondary = RecoveryText.sideNote(note, now: referenceTime)
            }
        }
        return MuscleGroupCard(group: group, state: state, detail: detail, secondaryDetail: secondary) {
            if !isPast, let record, record.status != .ready {
                infoGroup = group
            } else {
                router.push(.preset(group, day: selectedDay))
            }
        } accessory: {
            PresetMenu(group: group) { open(group, on: $0) }
        }
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

    // MARK: - Workout in progress

    private func workoutSection(_ session: WorkoutSession) -> some View {
        let done = session.exercises.reduce(0) { $0 + $1.completedSets.count }
        let total = session.exercises.reduce(0) { $0 + $1.sets.count }
        return VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                SectionEyebrow(text: session.completedAt != nil ? "COMPLETED WORKOUT" : "YOUR WORKOUT")
                Spacer()
                MetaLine(text: "\(done) OF \(total) SETS", em: 0.08)
            }

            ForEach(session.groups) { group in
                let exercises = session.exercises.filter { $0.group == group }
                Button {
                    router.push(.preset(group, day: selectedDay))
                } label: {
                    WorkoutGroupRow(group: group, exercises: exercises, isToday: isToday,
                                    workoutCompleted: session.completedAt != nil, showsChevron: false)
                }
                .buttonStyle(.plain)
                .overlay(alignment: .trailing) {
                    PresetMenu(group: group, current: store.level(for: group, on: selectedDay)) {
                        open(group, on: $0)
                    }
                    .padding(.trailing, 4)
                }
            }

            if store.canLog(on: selectedDay) {
                if session.completedAt != nil {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Workout completed · recovery updated")
                    }
                    .font(.ui(13, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)

                    if isToday, let walk = store.walkSuggestion {
                        WalkCard(walk: walk, isDone: session.walkDone == true) { done in
                            withAnimation(.easeOut(duration: 0.2)) { store.setWalkDone(done, on: selectedDay) }
                        }
                        .padding(.top, 8)
                    }
                } else {
                    WideButton(title: "Complete Workout", prominent: session.hasCompletedSets) {
                        withAnimation(.easeOut(duration: 0.2)) { store.completeWorkout(on: selectedDay) }
                        ads.moment(.workoutCompleted)
                    }
                    .disabled(!session.hasCompletedSets)
                    .opacity(session.hasCompletedSets ? 1 : 0.5)
                    .padding(.top, 4)
                    if !session.hasCompletedSets {
                        Text("Mark at least one set done to complete the workout.")
                            .font(.ui(11.5))
                            .foregroundStyle(DS.silver.opacity(0.4))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, DS.Metric.gutter)
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

    private var done: Int { exercises.reduce(0) { $0 + $1.completedSets.count } }
    private var total: Int { exercises.reduce(0) { $0 + $1.sets.count } }
    private var state: MuscleCardState {
        let finished = (workoutCompleted && done > 0)
            || (!exercises.isEmpty && exercises.allSatisfy { $0.isCompleted || $0.sets.allSatisfy(\.isCompleted) })
        if finished { return isToday ? .completedToday : .completed }
        return done > 0 ? .inProgress : .planned
    }

    var body: some View {
        HStack(spacing: 12) {
            MiniBodyMap(group: group)
                .frame(width: 26, height: 60)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(group.title)
                        .font(.ui(15, .semibold))
                        .foregroundStyle(DS.silver)
                    Spacer()
                    MuscleStateLabel(state: state)
                }
                Text("\(exercises.count) \(exercises.count == 1 ? "exercise" : "exercises") · \(done) of \(total) sets done")
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.55))
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(DS.silver.opacity(0.08))
                        Capsule()
                            .fill(DS.silver.opacity(0.7))
                            .frame(width: total > 0 ? geo.size.width * CGFloat(done) / CGFloat(total) : 0)
                    }
                }
                .frame(height: 4)
            }
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.3))
            } else {
                Color.clear.frame(width: 28, height: 1)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(DS.surfaceAlt)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}
