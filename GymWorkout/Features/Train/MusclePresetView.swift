//
//  MusclePresetView.swift
//  GymWorkout
//
//  One muscle group's exercises for a day. Opens on the preset picked from
//  the card's menu, else the user's first saved preset, else Basic or
//  Advanced; the list is only written into the day once the user does
//  something with it (adds it, edits it, or opens an exercise), so looking
//  never changes the workout. Any list can be saved as Preset 1, 2 or 3 —
//  2 and 3 with Premium. Ones saved before a subscription lapsed stay
//  usable and deletable, just not saved over.
//
//  Swap All swaps every exercise not started yet, and each row's swap button
//  one of them, for another that trains the same part the same way — one
//  the user hasn't done lately (`ExerciseRotation`). Swaps, saving over a
//  preset and deleting one can all be undone from the toast.
//
//  On iPad the list is one centred column, and from 900pt a master/detail:
//  the list on the left, the chosen exercise's sets (or the group at a
//  glance) on the right, without pushing anything.
//

import SwiftUI

struct MusclePresetView: View {
    var group: MuscleGroup
    var day: Date
    /// The preset to open an unplanned group on, from the card's menu.
    var initialLevel: PresetLevel? = nil

    @Environment(WorkoutStore.self) private var store
    @Environment(TrainRouter.self) private var router
    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall
    @Environment(Ads.self) private var ads
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout
    /// Set by a host that already shows the rest timer.
    @Environment(\.restTimerInsetSuppressed) private var hostShowsRest

    @State private var level: PresetLevel = .basic
    @State private var preview: [WorkoutExercise] = []
    @State private var didLoad = false
    @State private var picker: PickerMode?
    @State private var editingTarget: WorkoutExercise?
    @State private var editMode: EditMode = .inactive
    @State private var confirmsRemoval = false
    /// A row with sets already done, waiting on the remove confirmation.
    @State private var removingExercise: WorkoutExercise?
    /// The saved preset waiting on the delete confirmation.
    @State private var deletingPreset: PresetLevel?
    /// Every exercise the list has shown on this visit, so Shuffle and the
    /// swap buttons keep bringing ones not seen yet.
    @State private var shown: Set<String> = []
    @State private var toast: Toast?
    /// Rows just swapped, outlined for a moment so the change is visible.
    @State private var flashed: Set<UUID> = []
    /// The exercise open in the wide layout's detail pane. Screen state,
    /// never a route, and never chosen for the user: opening one plans the
    /// group, and looking must not change the workout.
    @State private var selectedID: UUID?
    /// The row whose target is being edited in a popover (iPad).
    @State private var targetPopover: WorkoutExercise?
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOver

    /// A short note over the list, with an undo when it follows a change.
    struct Toast: Identifiable, Equatable {
        let id = UUID()
        var text: String
        /// The names swapped out, by row, to put back.
        var undo: [UUID: String] = [:]
        /// The unsaved list as it was, when the swap was made before the list
        /// was added to the day.
        var previewBefore: [WorkoutExercise]? = nil
        /// The saved preset to put back, as it was before it was saved over
        /// or deleted (nil: the slot was empty), and the level the screen
        /// was on.
        var restoresPreset: PresetLevel? = nil
        var presetBefore: [PresetItem]? = nil
        var levelBefore: PresetLevel? = nil

        var canUndo: Bool { !undo.isEmpty || restoresPreset != nil }
    }

    enum PickerMode: Identifiable {
        case add
        case replace(UUID)

        var id: String {
            switch self {
            case .add: return "add"
            case .replace(let id): return id.uuidString
            }
        }
    }

    private var planned: [WorkoutExercise] { store.exercises(for: group, on: day) }
    private var isPlanned: Bool { !planned.isEmpty }
    private var rows: [WorkoutExercise] { isPlanned ? planned : preview }
    private var isToday: Bool { Calendar.current.isDateInToday(day) }
    private var dayName: String { isToday ? "Today's" : RecoveryText.day(day) + "'s" }
    private var isPast: Bool { Calendar.current.startOfDay(for: day) < Calendar.current.startOfDay(for: Date()) }

    /// The moment recovery is judged at, as on Train: now for today, the
    /// same time of day on another day.
    private var referenceTime: Date {
        let now = Date()
        let calendar = Calendar.current
        return isToday ? now
            : calendar.startOfDay(for: day).addingTimeInterval(now.timeIntervalSince(calendar.startOfDay(for: now)))
    }

    var body: some View {
        ZStack {
            DS.ink.ignoresSafeArea()

            if layout.isWide {
                wide
            } else {
                VStack(spacing: 0) {
                    header
                    list
                }

                if let toast {
                    toastView(toast)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 18)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .task(id: toast?.id) {
            guard let current = toast else { return }
            // A newer toast cancels this wait; it must not dismiss that one.
            let seconds: Double = voiceOver ? 12 : current.canUndo ? 6 : 3
            do { try await Task.sleep(for: .seconds(seconds)) } catch { return }
            withAnimation(.easeOut(duration: 0.2)) { toast = nil }
        }
        .onDisappear { toast = nil }
        .onChange(of: store.savedLevels(for: group)) { _, saved in
            // The preset on screen deleted from another screen.
            guard level.isSaved, !saved.contains(level) else { return }
            level = store.suggestedLevel
            if !isPlanned { preview = store.preview(group, level: level) }
        }
        .onChange(of: rows.map(\.id)) { _, ids in
            // A level switch, swap, removal or undo took the open exercise
            // out of the list.
            if let selectedID, !ids.contains(selectedID) { self.selectedID = nil }
        }
        .onChange(of: layout.isWide) { _, isWide in
            // Narrowed past the split: the open exercise carries on as the
            // pushed screen it is everywhere else.
            guard !isWide, let id = selectedID else { return }
            selectedID = nil
            router.push(.exercise(id))
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .restTimerInset()
        // The split shows the rest under its detail pane instead.
        .environment(\.restTimerInsetSuppressed, hostShowsRest || layout.isWide)
        .dsBackShortcuts(backShortcut)
        .onAppear(perform: load)
        .sheet(item: $picker) { mode in
            ExercisePickerView(
                group: group,
                title: { if case .replace = mode { return "Choose Another" } else { return "Add Exercise" } }(),
                alreadyAdded: Set(rows.map(\.exerciseName))
            ) { name in
                ensurePlanned()
                switch mode {
                case .add: store.addExercise(named: name, to: group, on: day)
                case .replace(let id): store.replaceExercise(id: id, with: name)
                }
            }
        }
        .sheet(item: $editingTarget) { exercise in
            TargetEditorSheet(exercise: exercise) { sets, reps in
                saveTarget(exercise, sets: sets, reps: reps)
            }
        }
        // iPad anchors each confirmation to the control that asked for it;
        // the phone's action sheets stay where they always were.
        .applying(!DS.isPad) { view in
            view
                .modifier(groupRemovalDialog)
                .modifier(exerciseRemovalDialog(isPresented: Binding(get: { removingExercise != nil },
                                                                      set: { if !$0 { removingExercise = nil } })))
                .modifier(presetDeletionDialog)
        }
    }

    // MARK: - Confirmations

    private var groupRemovalDialog: PresetConfirmation<Bool> {
        PresetConfirmation(
            title: "Remove \(group.title) from \(dayName.lowercased()) workout?",
            isPresented: $confirmsRemoval,
            presenting: true,
            action: "Remove",
            message: { _ in "Sets you've already marked done are removed too." },
            onConfirm: { _ in
                store.removeGroup(group, on: day)
                dismiss()
            })
    }

    private func exerciseRemovalDialog(isPresented: Binding<Bool>) -> PresetConfirmation<WorkoutExercise> {
        PresetConfirmation(
            title: "Remove \(removingExercise?.exerciseName ?? "Exercise")?",
            isPresented: isPresented,
            presenting: removingExercise,
            action: "Remove",
            message: { exercise in
                let done = exercise.completedSets.count
                return done == 1 ? "The set you've marked done is removed too."
                    : "The \(done) sets you've marked done are removed too."
            },
            onConfirm: { remove($0) })
    }

    private var presetDeletionDialog: PresetConfirmation<PresetLevel> {
        PresetConfirmation(
            title: "Delete \(deletingPreset?.name ?? "Preset") for \(group.title)?",
            isPresented: Binding(get: { deletingPreset != nil },
                                 set: { if !$0 { deletingPreset = nil } }),
            presenting: deletingPreset,
            action: "Delete",
            message: { _ in "Days you've already planned keep their exercises." },
            onConfirm: { deletePreset($0) })
    }

    // MARK: - List

    private var list: some View {
        List {
            intro
                .modifier(PlainRow(top: 4, bottom: 14, inset: rowInset))

            listHeader
                .modifier(PlainRow(top: 0, bottom: 2, inset: rowInset))

            ForEach(rows) { exercise in
                row(exercise)
                    .modifier(PlainRow(top: 5, bottom: 5, inset: rowInset))
                    // Logged sets go only through ⋯ Remove, which asks first.
                    .deleteDisabled(!exercise.completedSets.isEmpty)
            }
            .onDelete(perform: delete)
            .onMove(perform: move)

            addButton
                .modifier(PlainRow(top: 10, bottom: 6, inset: rowInset))

            footer
                .modifier(PlainRow(top: 14, bottom: 30, inset: rowInset))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, $editMode)
        // Room to scroll the footer clear of the toast.
        .contentMargins(.bottom, toast == nil ? 0 : 72, for: .scrollContent)
    }

    /// The list's side inset. The phone's gutter; on iPad the gutter inside
    /// a centred 680pt column, so the rows read as one column while the
    /// whole width still scrolls; in the split's list pane, the pane gap.
    private var rowInset: CGFloat {
        guard layout.isRegular else { return DS.Metric.gutter }
        if layout.isWide { return layout.paneGap }
        let margin = (layout.containerWidth - DS.Layout.columnWidth) / 2
        return max(layout.gutter, margin + layout.gutter)
    }

    /// ⌘[ and Esc: close the open exercise first, then go back — only while
    /// this is the top of the stack, as the pushed exercise has its own.
    private func backShortcut() {
        guard case .preset(let shown, _, _)? = router.path.last, shown == group else { return }
        if selectedID != nil { closeDetail() } else { back() }
    }

    private func back() {
        // Leaving with an exercise open closes it, as Back does on iPhone.
        if selectedID != nil { ads.moment(.exerciseClosed) }
        dismiss()
    }

    // MARK: - Header

    private var header: some View {
        let regular = layout.isRegular
        return HStack(spacing: 12) {
            CircleIconButton(action: back) {
                Image(systemName: "chevron.left")
                    .font(.system(size: regular ? 15 : 14, weight: .semibold))
                    .foregroundStyle(DS.silver)
            }
            .accessibilityLabel("Back")

            VStack(alignment: .leading, spacing: 0) {
                Text(group.title)
                    .font(.ui(layout.isWide ? 22 : layout.text(.screenTitle), .semibold))
                    .tracking(regular ? -0.4 : -0.25)
                    .foregroundStyle(DS.silver)
                MetaLine(text: "\(dayName.uppercased()) WORKOUT · \(rows.count) \(rows.count == 1 ? "EXERCISE" : "EXERCISES")")
                    // One line in the split's list pane, beside Reorder.
                    .lineLimit(regular ? 1 : nil)
                    .minimumScaleFactor(regular ? 0.8 : 1)
                    .padding(.top, 3)
            }

            Spacer(minLength: 0)

            if rows.count > 1 {
                Button(editMode.isEditing ? "Done" : "Reorder") {
                    withAnimation { editMode = editMode.isEditing ? .inactive : .active }
                }
                .font(.ui(regular ? 14 : 13, .semibold))
                .foregroundStyle(DS.silver)
                .buttonStyle(.plain)
                .padding(.horizontal, regular ? 12 : 0)
                .padding(.vertical, regular ? 8 : 0)
                .dsHover(.highlight)
                // The hover pad overhangs, so the word keeps the rows' edge.
                .padding(.trailing, regular ? -12 : 0)
            }
        }
        // Regular lines the back button up with the rows' leading edge.
        .padding(.horizontal, regular ? rowInset : 16)
        // The same band as the exercise header beside it in the split.
        .padding(.top, regular ? 14 : 11)
        .padding(.bottom, regular ? 14 : 10)
    }

    // MARK: - Wide (iPad, 900pt and up)

    /// The list in a pane of its own beside the open exercise, each under
    /// its own header on one line, so picking an exercise never pushes.
    private var wide: some View {
        // Never under 400: below that a row's name and recovery note wrap
        // to three lines beside the thumbnail and the row's two buttons.
        let listWidth = layout.paneWidth(0.36, min: 400, max: DS.Layout.inspectorMax)
        let detailWidth = max(0, layout.containerWidth - listWidth - 1)
        return HStack(spacing: 0) {
            VStack(spacing: 0) {
                header
                ZStack {
                    list
                    if let toast {
                        toastView(toast)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, 18)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .frame(width: listWidth)
            .environment(\.dsLayout, layout.with(containerWidth: listWidth))

            Rectangle()
                .fill(DS.silver.opacity(0.07))
                .frame(width: 1)
                .ignoresSafeArea(edges: .bottom)

            detail
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environment(\.dsLayout, layout.with(containerWidth: detailWidth))
                // The screen's one rest timer, under the pane the sets are
                // logged in.
                .restTimerInset()
                .environment(\.restTimerInsetSuppressed, hostShowsRest)
        }
    }

    @ViewBuilder
    private var detail: some View {
        if let id = selectedID, let item = rows.first(where: { $0.id == id }) {
            ExerciseDetailView(workoutExerciseID: id,
                               presentation: .embedded(onClose: closeDetail,
                                                       onCompleted: { advance(from: id) }))
                .restTimerInsetSuppressed()
                // Rebuilt per exercise (a swap keeps the row's id), so the
                // 3D model is loaded once for each and not on every edit.
                .id("\(id)|\(item.exerciseName)")
                .transition(.opacity)
        } else {
            overview
                .transition(.opacity)
        }
    }

    /// Nothing chosen yet: the group at a glance — where it trains, how
    /// it's recovering, what the preset is — and the step that comes next.
    private var overview: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                overviewContent(paneHeight: geo.size.height)
                    .padding(.horizontal, layout.gutter)
                    .padding(.vertical, layout.sectionSpacing)
                    .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
        }
    }

    private func overviewContent(paneHeight: CGFloat) -> some View {
        let now = referenceTime
        let lit = Dictionary(group.bodyRegions.map { ($0, DS.activation) }, uniquingKeysWith: { a, _ in a })
        return VStack(spacing: 0) {
            BodyMapPair(source: .fills(front: lit, back: lit),
                        figureHeight: min(300, paneHeight * 0.45))

            VStack(alignment: .leading, spacing: 0) {
                // A past day's log is a record; recovery is about what's next.
                if !isPast {
                    recovery(store.recoveryRecords(at: now)[group], now: now)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                    Hairline()
                }
                VStack(alignment: .leading, spacing: 6) {
                    SectionEyebrow(text: "PRESET", size: 10.5)
                    if levels.contains(level) {
                        Text(level.name)
                            .font(.ui(15, .semibold))
                            .foregroundStyle(DS.silver)
                    }
                    Text(levelCaption)
                        .font(.ui(13.5))
                        .cssLineHeight(13.5, 1.45)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            }
            .frame(maxWidth: 440)
            .dsPane(radius: layout.cardRadius)
            .padding(.top, 32)

            overviewAction
                .padding(.top, 28)
        }
    }

    @ViewBuilder
    private var overviewAction: some View {
        if isPlanned {
            let share = setsTotal == 0 ? 0 : CGFloat(setsDone) / CGFloat(setsTotal)
            VStack(spacing: 10) {
                Text("\(setsDone) of \(setsTotal) sets done")
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.75))
                Capsule()
                    .fill(DS.silver.opacity(0.08))
                    .frame(width: 240, height: 4)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(DS.silver)
                            .frame(width: 240 * share)
                    }
                    .padding(.vertical, 2)
                Text("Choose an exercise to log its sets.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
            .accessibilityElement(children: .combine)
        } else if !rows.isEmpty {
            VStack(spacing: 10) {
                WideButton(title: "Add to \(dayName) Workout", prominent: true) {
                    withAnimation { ensurePlanned() }
                }
                .dsCTA(360)
                Text("Or choose an exercise to start logging sets.")
                    .font(.ui(12.5))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
        } else {
            Text("Add an exercise to plan \(group.title).")
                .font(.ui(13.5))
                .foregroundStyle(DS.silver.opacity(0.5))
        }
    }

    // MARK: - Intro

    private var intro: some View {
        let now = referenceTime
        let levels = levels
        let regular = layout.isRegular
        return VStack(alignment: .leading, spacing: regular ? 16 : 14) {
            HStack(alignment: .top, spacing: 12) {
                // A past day's log is a record; recovery is about what's next.
                if !isPast {
                    recovery(store.recoveryRecords(at: now)[group], now: now)
                }
                Spacer()
                MiniBodyMap(group: group, lineWidth: regular ? 0.75 : 0.5)
                    .frame(width: regular ? 44 : 30, height: regular ? 104 : 70)
            }

            // Nothing to pick between for a group with no built-in preset
            // and none saved.
            if !levels.isEmpty {
                MonoSegmentedControl(
                    options: levels.map { ($0, $0.title) },
                    selection: Binding(get: { level }, set: select),
                    fontSize: levels.count > 3 ? 9 : 10,
                    itemPaddingH: levels.count > 3 ? 4 : 11,
                    itemPaddingV: 8,
                    fillsWidth: true
                )
            }

            Text(levelCaption)
                .font(.ui(regular ? 13.5 : 12.5))
                .foregroundStyle(DS.silver.opacity(0.5))
        }
    }

    /// The group's recovery as of `now`: the day open, at this time of day.
    private func recovery(_ record: MuscleTrainingRecord?, now: Date) -> some View {
        let detail: CGFloat = layout.isRegular ? 13 : 12
        return VStack(alignment: .leading, spacing: layout.isRegular ? 6 : 5) {
            SectionEyebrow(text: "RECOVERY", size: layout.isRegular ? 10.5 : 9.5)
            MuscleStateLabel(state: MuscleCardState(record?.status))
            if let record, record.status == .partlyReady {
                Text("\(RecoveryText.recovering(record.tiredParts.map(\.part))) · \(RecoveryText.ready(record.readyParts).lowercased())")
                    .font(.ui(detail))
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
            } else if let record, record.status != .ready {
                Text("\(RecoveryText.trainedAgo(record.lastTrainedAt, now: now)) · est. \(RecoveryText.remaining(record.hoursRemaining))")
                    .font(.ui(detail))
                    .foregroundStyle(DS.silver.opacity(0.5))
            } else if let record {
                // Helping on another group's day isn't "trained".
                if let note = record.sideNotes.first {
                    Text(RecoveryText.sideNote(note, now: now))
                        .font(.ui(detail))
                        .foregroundStyle(DS.silver.opacity(0.5))
                } else if let last = record.lastCountedAt {
                    Text(RecoveryText.trainedAgo(last, now: now))
                        .font(.ui(detail))
                        .foregroundStyle(DS.silver.opacity(0.5))
                }
            }
        }
    }

    /// Basic and Advanced when the group has them (Forearms, Calves and
    /// Adductors don't), then each preset the user saved.
    private var levels: [PresetLevel] {
        [PresetLevel.basic, .advanced].filter { PresetProvider.preset(for: group, level: $0) != nil }
            + store.savedLevels(for: group)
    }

    private var levelCaption: String {
        // Only a group with no built-in preset can be on a level it doesn't offer.
        guard levels.contains(level) else {
            return "There's no built-in preset for \(group.title). Add exercises, then save the list as a preset."
        }
        let suggested = store.profile != nil && level == store.suggestedLevel ? " Suggested for you." : ""
        switch level {
        case .basic: return "Machines and supported positions — a good place to start." + suggested
        case .advanced: return "Free-weight compounds that need more balance and bracing." + suggested
        case .mine, .mine2, .mine3: return "Your saved \(level.name) for \(group.title)."
        }
    }

    // MARK: - Shuffle

    private var listHeader: some View {
        let regular = layout.isRegular
        return HStack {
            SectionEyebrow(text: "EXERCISES", size: regular ? 10.5 : 9.5)
            Spacer()
            if canSwapAll {
                Button(action: shuffleAll) {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: regular ? 12 : 11, weight: .semibold))
                        Text("Swap All")
                            .font(.ui(regular ? 13.5 : 12.5, .semibold))
                    }
                    .foregroundStyle(DS.silver)
                    .padding(.horizontal, regular ? 14 : 12)
                    .padding(.vertical, regular ? 8 : 7)
                    .background(Capsule().fill(DS.silver.opacity(0.08)))
                    .contentShape(Capsule())
                    .dsHover(.highlight)
                }
                .buttonStyle(.borderless)
                .accessibilityHint("Swaps the exercises not started yet for ones you haven't done lately, keeping the sets and the muscles worked.")
            }
        }
        .frame(minHeight: regular ? 36 : 32)
    }

    /// Swapping is for planning: not on a past day's log, not while
    /// reordering, and only for rows with no sets done.
    private func canSwap(_ exercise: WorkoutExercise) -> Bool {
        !isPast && !editMode.isEditing && exercise.completedSets.isEmpty
    }

    private var canSwapAll: Bool { rows.contains(where: canSwap) }

    // MARK: - Rows

    private func row(_ exercise: WorkoutExercise) -> some View {
        let regular = layout.isRegular
        return HStack(spacing: 8) {
            Button {
                open(exercise)
            } label: {
                PresetExerciseRow(exercise: exercise, caution: caution(for: exercise))
                    .dsSelected(selectedID == exercise.id, radius: 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(DS.silver.opacity(flashed.contains(exercise.id) ? 0.5 : 0), lineWidth: 1.5)
                    )
                    .dsHover(.lift, radius: 16)
            }
            .buttonStyle(.borderless)
            .disabled(editMode.isEditing)

            if canSwap(exercise) {
                Button {
                    swap(exercise)
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: regular ? 14 : 13, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .frame(width: regular ? 32 : 28, height: 44)
                        .contentShape(Rectangle())
                        .dsHover(.highlight, radius: 10)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Swap \(exercise.exerciseName)")
                .accessibilityHint("Replaces it with a similar exercise you haven't done lately.")
            } else if regular && !editMode.isEditing {
                // iPad keeps the swap's slot, so every card is the same
                // width and the column reads as one edge.
                Color.clear.frame(width: 32, height: 44)
            }

            if !editMode.isEditing {

                Menu {
                    Button(exercise.isTimed ? "Edit Sets & Time" : "Edit Sets & Reps", systemImage: "slider.horizontal.3") {
                        // iPad edits in place, in a popover off the row.
                        if regular { targetPopover = exercise } else { editingTarget = exercise }
                    }
                    Button("Choose Another", systemImage: "list.bullet") {
                        picker = .replace(exercise.id)
                    }
                    .disabled(!exercise.completedSets.isEmpty)
                    Button("Remove", systemImage: "trash", role: .destructive) {
                        // Logged sets go with the row, so ask first.
                        if exercise.completedSets.isEmpty { remove(exercise) } else { removingExercise = exercise }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: regular ? 15 : 14, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .frame(width: regular ? 34 : 30, height: 44)
                        .contentShape(Rectangle())
                        .dsHover(.highlight, radius: 10)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Options for \(exercise.exerciseName)")
                .applying(DS.isPad) { menu in
                    menu.modifier(exerciseRemovalDialog(isPresented: Binding(
                        get: { removingExercise?.id == exercise.id },
                        set: { if !$0 { removingExercise = nil } })))
                }
            }
        }
        .applying(DS.isPad) { row in
            row.dsPopover(item: Binding(get: { targetPopover?.id == exercise.id ? targetPopover : nil },
                                        set: { targetPopover = $0 }),
                          width: 360) { editing in
                TargetEditorSheet(exercise: editing, style: .popover) { sets, reps in
                    saveTarget(editing, sets: sets, reps: reps)
                }
            }
        }
    }

    private func saveTarget(_ exercise: WorkoutExercise, sets: Int, reps: RepRange) {
        ensurePlanned()
        store.updateTarget(id: exercise.id, sets: sets, reps: reps)
    }

    private var addButton: some View {
        let regular = layout.isRegular
        let radius: CGFloat = regular ? 16 : 14
        return Button {
            picker = .add
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "plus")
                    .font(.system(size: regular ? 13 : 12, weight: .semibold))
                Text("Add Exercise")
                    .font(.ui(regular ? 15 : 14, .semibold))
            }
            .foregroundStyle(DS.silver)
            .frame(maxWidth: .infinity)
            .padding(.vertical, regular ? 15 : 13)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.18), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            )
            .dsHover(.highlight, radius: radius)
        }
        .buttonStyle(.borderless)
    }

    @ViewBuilder
    private var footer: some View {
        VStack(spacing: 22) {
            dayFooter
            mineFooter
        }
    }

    /// The footer's alignment: centred on the phone, on the column's
    /// leading edge on iPad, under the leading-aligned controls above.
    private var footerAlignment: HorizontalAlignment { layout.isRegular ? .leading : .center }

    @ViewBuilder
    private var dayFooter: some View {
        let regular = layout.isRegular
        if isPlanned {
            VStack(alignment: footerAlignment, spacing: 12) {
                Text("\(setsDone) of \(setsTotal) sets done")
                    .font(.ui(regular ? 14 : 13, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.6))
                Button("Remove \(group.title) from this workout") { confirmsRemoval = true }
                    .font(.ui(regular ? 13.5 : 12.5))
                    .foregroundStyle(DS.silver.opacity(0.45))
                    .buttonStyle(.borderless)
                    .applying(DS.isPad) { $0.modifier(groupRemovalDialog) }
            }
            .frame(maxWidth: .infinity, alignment: Alignment(horizontal: footerAlignment, vertical: .center))
        } else if !rows.isEmpty {
            // An empty list (no built-in preset) has nothing to add yet;
            // Add Exercise plans the group with its first pick.
            VStack(alignment: footerAlignment, spacing: 8) {
                WideButton(title: "Add to \(dayName) Workout", prominent: true) {
                    withAnimation { ensurePlanned() }
                }
                .dsCTA(DS.Layout.ctaMaxWidth, alignment: .leading)
                Text(layout.isWide ? "Or choose an exercise to start logging sets."
                     : "Or tap an exercise to start logging sets.")
                    .font(.ui(regular ? 12.5 : 11.5))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
        }
    }

    private var setsDone: Int { planned.reduce(0) { $0 + $1.completedSets.count } }
    private var setsTotal: Int { planned.reduce(0) { $0 + $1.sets.count } }

    /// Says which preset the list is saved as, or offers to save it as
    /// Preset 1, 2 or 3. Saving only shows while a slot is free, on a saved
    /// preset, or once the list has been changed from what its level gives,
    /// so just looking at Basic or Advanced never offers to write over a
    /// full set of presets. Without Premium an empty Preset 2 or 3 still
    /// counts as free: the menu lists it locked, and tapping it opens the
    /// paywall.
    @ViewBuilder
    private var mineFooter: some View {
        if !rows.isEmpty {
            if let saved = store.matchingPreset(rows, for: group) {
                HStack(spacing: 6) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: layout.isRegular ? 11 : 10, weight: .semibold))
                    Text("Saved as \(saved.name)")
                    Text("·")
                    Button { deletingPreset = saved } label: {
                        Text("Delete")
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .accessibilityLabel("Delete \(saved.name)")
                    .applying(DS.isPad) { $0.modifier(presetDeletionDialog) }
                }
                .font(.ui(layout.isRegular ? 13 : 12))
                .foregroundStyle(DS.silver.opacity(0.45))
                .frame(maxWidth: .infinity, alignment: Alignment(horizontal: footerAlignment, vertical: .center))
            } else if store.savedLevels(for: group).count < PresetLevel.saved.count || level.isSaved || isEdited {
                Menu {
                    Section("Save this list as") {
                        ForEach(saveSlots, id: \.self) { slot in
                            let existing = store.customPreset(for: group, slot)
                            let title = existing == nil ? slot.name : slot == level ? "Update \(slot.name)" : "Replace \(slot.name)"
                            if isLocked(slot) {
                                Button { paywall.show(.preset) } label: {
                                    Label(title, systemImage: "lock.fill")
                                    Text("Premium")
                                }
                            } else {
                                Button { saveAsPreset(slot) } label: {
                                    Label(title, systemImage: existing == nil ? "bookmark" : "arrow.triangle.2.circlepath")
                                    Text(existing.map { "\($0.count) \($0.count == 1 ? "exercise" : "exercises")" } ?? "Empty")
                                }
                            }
                        }
                    }
                } label: {
                    Label(level.isSaved && !isLocked(level) ? "Update \(level.name)" : "Save as Preset", systemImage: "bookmark")
                        .font(.ui(layout.isRegular ? 13.5 : 12.5, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.75))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .contentShape(Rectangle())
                        .dsHover(.highlight, radius: 10)
                }
                .buttonStyle(.borderless)
                // Leading-aligned on iPad, the label (not its hit pad) on the edge.
                .padding(.leading, layout.isRegular ? -12 : 0)
                .frame(maxWidth: .infinity, alignment: Alignment(horizontal: footerAlignment, vertical: .center))
                .accessibilityHint(purchases.isPremium
                                   ? "Saves this list as Preset 1, 2 or 3, in the menu next to \(group.title) on Train."
                                   : "Saves this list as Preset 1, in the menu next to \(group.title) on Train. Preset 2 and 3 come with Premium.")
            }
        }
    }

    /// The save menu's slots, the preset on screen first unless it's locked,
    /// so the first row is one that saves.
    private var saveSlots: [PresetLevel] {
        level.isSaved && !isLocked(level) ? [level] + PresetLevel.saved.filter { $0 != level } : PresetLevel.saved
    }

    /// Preset 2 and 3 can't be saved or saved over without Premium. One
    /// saved before a subscription lapsed is still opened and deleted as usual.
    private func isLocked(_ slot: PresetLevel) -> Bool {
        !purchases.isPremium && (slot.slot ?? 0) > Premium.freePresets
    }

    /// The list differs from the preset its level would give.
    private var isEdited: Bool {
        rows.map(\.exerciseName) != store.preview(group, level: level).map(\.exerciseName)
    }

    private func toastView(_ toast: Toast) -> some View {
        HStack(spacing: 10) {
            Text(toast.text)
                .font(.ui(13, .semibold))
                .lineLimit(2)
            if toast.canUndo {
                Button { undo(toast) } label: {
                    Text("Undo")
                        .font(.ui(13, .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.borderless)
            }
        }
        .foregroundStyle(DS.ink)
        .padding(.leading, 16)
        .padding(.trailing, toast.canUndo ? 8 : 16)
        .padding(.vertical, toast.canUndo ? 3 : 11)
        .background(Capsule().fill(DS.silver))
        .padding(.horizontal, layout.isRegular ? rowInset : DS.Metric.gutter)
        .accessibilityElement(children: .contain)
    }

    /// "FRONT DELTS RECOVERING" when the exercise works a part of this group
    /// that is still recovering as a primary mover. Only for today or later —
    /// a past day's log is just a record.
    private func caution(for exercise: WorkoutExercise) -> String? {
        guard !isPast, let record = store.recoveryRecords(at: referenceTime)[group] else { return nil }
        let tired = Set(record.tiredParts.map(\.part))
        let hit = RecoveryCalculator.partContributions(of: exercise)
            .filter { $0.role == .primary && tired.contains($0.part) }
            .map(\.part)
        return hit.isEmpty ? nil : RecoveryText.recovering(hit).uppercased()
    }

    // MARK: - Actions

    private func load() {
        guard !didLoad else { return }
        didLoad = true
        // A group already on the day without a level (added from the library)
        // isn't the saved list, whatever the group opens on otherwise.
        // A preset picked from the menu wins over a level the day kept after
        // the group's last exercise was removed.
        level = isPlanned
            ? store.level(for: group, on: day) ?? store.suggestedLevel
            : initialLevel ?? store.level(for: group, on: day) ?? store.defaultLevel(for: group)
        if level.isSaved && store.customPreset(for: group, level) == nil { level = store.suggestedLevel }
        preview = store.preview(group, level: level)
        shown = Set(rows.map(\.exerciseName))
    }

    private func select(_ newLevel: PresetLevel) {
        // A level with no list would empty the screen, or a planned group
        // of everything not started yet.
        guard newLevel != level, !store.preview(group, level: newLevel).isEmpty else { return }
        toast = nil
        withAnimation(.easeOut(duration: 0.18)) {
            level = newLevel
            if isPlanned {
                store.switchLevel(group, on: day, to: newLevel)
            } else {
                preview = store.preview(group, level: newLevel)
            }
        }
    }

    /// Writes the previewed preset into the day, keeping its ids.
    private func ensurePlanned() {
        if !isPlanned {
            store.ensurePlan(group, on: day, level: level, planned: preview)
        }
    }

    private var rotationContext: ExerciseRotation.Context {
        // Recovery as of the day being planned, in every group: a quads pick
        // shouldn't lean on glutes trained yesterday.
        let when = max(day, Date())
        let tired = store.recoveryRecords(at: when).values.flatMap { $0.parts.filter(\.isTired).map(\.part) }
        let ceiling = (store.customPreset(for: group, level) ?? [])
            .compactMap { ExerciseCatalog.exercise(named: $0.exerciseName)?.difficulty }
            .max { ExerciseRotation.rank($0) < ExerciseRotation.rank($1) } ?? .intermediate
        return ExerciseRotation.Context(group: group, level: level, lastDone: store.lastDoneDates,
                                        tired: Set(tired), saved: store.saved, ceiling: ceiling, now: when)
    }

    /// The day's exercises in other groups, which a swap here mustn't repeat.
    private var elsewhereToday: Set<String> {
        Set((store.session(on: day)?.exercises ?? []).filter { $0.group != group }.map(\.exerciseName))
    }

    /// Another exercise for the row: first one not shown on this visit, then
    /// any not in the list (or `alsoAvoid`); never one already on the day.
    private func replacement(for exercise: WorkoutExercise, in list: [String],
                             alsoAvoid: Set<String> = [], context: ExerciseRotation.Context) -> String? {
        let taken = Set(list).union(elsewhereToday).union(alsoAvoid)
        return ExerciseRotation.replacement(for: exercise.exerciseName, context: context,
                                            avoid: taken.union(shown), thenAvoid: taken)
    }

    private func shuffleAll() {
        let context = rotationContext
        shown.formUnion(rows.map(\.exerciseName))
        // What the list held before, so rows don't just trade places.
        let original = Set(rows.map(\.exerciseName))
        var list = rows.map(\.exerciseName)
        var changes: [(WorkoutExercise, String)] = []
        for (index, exercise) in rows.enumerated() where canSwap(exercise) {
            guard let name = replacement(for: exercise, in: list, alsoAvoid: original, context: context) else { continue }
            list[index] = name
            changes.append((exercise, name))
        }
        guard !changes.isEmpty else {
            show(Toast(text: "No other exercises to swap in yet."))
            return
        }
        let before = isPlanned ? nil : preview
        apply(changes)
        show(Toast(text: changes.count == 1 ? "1 exercise swapped" : "\(changes.count) exercises swapped",
                   undo: Dictionary(uniqueKeysWithValues: changes.map { ($0.0.id, $0.0.exerciseName) }),
                   previewBefore: before))
    }

    private func swap(_ exercise: WorkoutExercise) {
        shown.formUnion(rows.map(\.exerciseName))
        guard let name = replacement(for: exercise, in: rows.map(\.exerciseName), context: rotationContext) else {
            show(Toast(text: "No other exercise like this to swap in yet."))
            return
        }
        let before = isPlanned ? nil : preview
        apply([(exercise, name)])
        show(Toast(text: "Swapped for \(name)", undo: [exercise.id: exercise.exerciseName], previewBefore: before))
    }

    /// Puts each new exercise in its row: in the day's plan when there is
    /// one, else in the unsaved list.
    private func apply(_ changes: [(WorkoutExercise, String)]) {
        withAnimation(.easeOut(duration: 0.2)) {
            for (exercise, name) in changes {
                shown.insert(name)
                if isPlanned {
                    store.replaceExercise(id: exercise.id, with: name)
                } else if let index = preview.firstIndex(where: { $0.id == exercise.id }),
                          let swapped = store.swapped(exercise, to: name) {
                    preview[index] = swapped
                }
            }
        }
        flash(Set(changes.map(\.0.id)))
    }

    private func flash(_ ids: Set<UUID>) {
        withAnimation(.easeOut(duration: 0.15)) { flashed = ids }
        Task {
            try? await Task.sleep(for: .seconds(1.2))
            withAnimation(.easeOut(duration: 0.4)) { if flashed == ids { flashed = [] } }
        }
    }

    private func undo(_ toast: Toast) {
        withAnimation(.easeOut(duration: 0.2)) {
            if let preset = toast.restoresPreset {
                store.restoreCustomPreset(toast.presetBefore, for: group, preset)
                let before = toast.levelBefore ?? level
                let restored = before.isSaved && store.customPreset(for: group, before) == nil ? store.suggestedLevel : before
                if restored != level {
                    level = restored
                    if isPlanned {
                        store.markLevel(restored, for: group, on: day)
                    } else if restored == preset {
                        // Undoing a delete: the list it showed comes back.
                        // Undoing a save keeps the list on screen.
                        preview = store.preview(group, level: restored)
                    }
                }
            } else if let before = toast.previewBefore, !isPlanned {
                preview = before
            } else {
                // Rows started since keep what was logged on them, and a name
                // now in another row isn't brought back as a duplicate.
                for (id, name) in toast.undo where store.exercise(id: id)?.completedSets.isEmpty == true
                    && !rows.contains(where: { $0.exerciseName == name && $0.id != id }) {
                    store.replaceExercise(id: id, with: name)
                }
            }
            self.toast = nil
        }
    }

    private func show(_ newToast: Toast) {
        withAnimation(.easeOut(duration: 0.2)) { toast = newToast }
        AccessibilityNotification.Announcement(newToast.text + (newToast.canUndo ? ". Undo available." : "")).post()
    }

    private func saveAsPreset(_ preset: PresetLevel) {
        // The menu routes locked slots to the paywall; this is the backstop.
        guard !isLocked(preset) else { paywall.show(.preset); return }
        let before = store.customPreset(for: group, preset)
        let levelBefore = level
        store.saveCustomPreset(rows, for: group, as: preset)
        if isPlanned { store.markLevel(preset, for: group, on: day) }
        withAnimation(.easeOut(duration: 0.18)) { level = preset }
        show(before == nil
             ? Toast(text: "Saved as \(preset.name). Find it under ⋯ next to \(group.title) on Train.")
             : Toast(text: "\(preset.name) updated", restoresPreset: preset, presetBefore: before, levelBefore: levelBefore))
    }

    private func deletePreset(_ preset: PresetLevel) {
        let before = store.customPreset(for: group, preset)
        store.deleteCustomPreset(for: group, preset)
        show(Toast(text: "\(preset.name) deleted", restoresPreset: preset, presetBefore: before, levelBefore: level))
        guard level == preset else { return }
        withAnimation(.easeOut(duration: 0.18)) {
            level = store.suggestedLevel
            if !isPlanned { preview = store.preview(group, level: level) }
        }
    }

    private func open(_ exercise: WorkoutExercise) {
        ensurePlanned()
        guard layout.isWide else {
            router.push(.exercise(exercise.id))
            return
        }
        guard selectedID != exercise.id else { return }
        // Moving on from an open exercise is the iPhone's Back.
        if selectedID != nil { ads.moment(.exerciseClosed) }
        withAnimation(.easeOut(duration: 0.2)) { selectedID = exercise.id }
    }

    private func closeDetail() {
        ads.moment(.exerciseClosed)
        withAnimation(.easeOut(duration: 0.2)) { selectedID = nil }
    }

    /// After Complete Exercise: the next exercise not finished yet, after
    /// this one and then from the top, or the overview when all are done.
    /// No ad moment — Complete on iPhone doesn't make one either.
    private func advance(from id: UUID) {
        let list = rows
        let start = (list.firstIndex { $0.id == id } ?? -1) + 1
        let next = (Array(list[start...]) + Array(list[..<start])).first { $0.id != id && !$0.isCompleted }
        withAnimation(.easeOut(duration: 0.2)) { selectedID = next?.id }
    }

    private func remove(_ exercise: WorkoutExercise) {
        ensurePlanned()
        store.removeExercise(id: exercise.id)
    }

    private func delete(_ offsets: IndexSet) {
        // Rows with sets done can't be swiped (`deleteDisabled`); this is
        // the backstop.
        let ids = offsets.map { rows[$0] }.filter { $0.completedSets.isEmpty }.map(\.id)
        guard !ids.isEmpty else { return }
        ensurePlanned()
        ids.forEach { store.removeExercise(id: $0) }
    }

    private func move(_ source: IndexSet, _ destination: Int) {
        ensurePlanned()
        store.moveExercises(in: group, on: day, from: source, to: destination)
    }
}

// MARK: - Row

struct PresetExerciseRow: View {
    var exercise: WorkoutExercise
    /// A recovery heads-up for this exercise, e.g. "FRONT DELTS RECOVERING".
    var caution: String? = nil

    @Environment(\.dsLayout) private var layout

    private var libraryExercise: Exercise? { ExerciseCatalog.exercise(named: exercise.exerciseName) }
    private var done: Int { exercise.completedSets.count }

    var body: some View {
        let regular = layout.isRegular
        let thumb: CGFloat = regular ? 64 : 54
        let thumbRadius: CGFloat = regular ? 14 : 12
        let tag: CGFloat = regular ? 10 : 9
        return HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: thumbRadius, style: .continuous)
                .fill(DS.surfaceDim)
                .frame(width: thumb, height: thumb)
                .overlay(
                    RenderSlot(id: libraryExercise?.slotID ?? "")
                        .clipShape(RoundedRectangle(cornerRadius: thumbRadius, style: .continuous))
                )

            VStack(alignment: .leading, spacing: regular ? 6 : 5) {
                Text(exercise.exerciseName)
                    .font(.ui(regular ? 16 : 14.5, .semibold))
                    .foregroundStyle(DS.silver)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 8) {
                    Text(exercise.targetLabel)
                        .font(.mono(regular ? 12 : 11, .semibold))
                        .foregroundStyle(DS.silver.opacity(0.7))
                    if exercise.isCompleted || (done > 0 && done == exercise.sets.count) {
                        HStack(spacing: 3) {
                            Image(systemName: "checkmark")
                                .font(.system(size: regular ? 9 : 8, weight: .bold))
                            Text("\(done)/\(exercise.sets.count) DONE")
                                .font(.mono(tag, .semibold))
                                .trackingEm(0.06, size: tag)
                        }
                        .foregroundStyle(DS.silver.opacity(0.7))
                    } else if done > 0 {
                        Text("\(done)/\(exercise.sets.count) DONE")
                            .font(.mono(tag, .semibold))
                            .trackingEm(0.06, size: tag)
                            .foregroundStyle(DS.silver.opacity(0.5))
                    }
                }
                if let caution {
                    HStack(spacing: 4) {
                        Image(systemName: MuscleCardState.recovering.symbol)
                            .font(.system(size: regular ? 8 : 7, weight: .semibold))
                        Text(caution)
                            .font(.mono(regular ? 9.5 : 8.5, .semibold))
                            .trackingEm(0.06, size: regular ? 9.5 : 8.5)
                    }
                    .foregroundStyle(DS.silver.opacity(0.5))
                }
            }

            Spacer(minLength: 4)

            // In the split a row selects in place rather than going on.
            if !layout.isWide {
                Image(systemName: "chevron.right")
                    .font(.system(size: regular ? 12 : 11, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.28))
            }
        }
        .padding(regular ? 12 : 10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(DS.surfaceAlt)
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(exercise.exerciseName), \(exercise.sets.count) sets of \(exercise.repRange.label) \(exercise.isTimed ? "seconds" : "reps"), \(done) done"
                            + (caution.map { ", \($0.lowercased())" } ?? ""))
    }
}

/// A list row with no chrome, so rows sit on the screen ground like the rest
/// of the app.
struct PlainRow: ViewModifier {
    var top: CGFloat
    var bottom: CGFloat
    /// The side insets; iPad centres a column with them.
    var inset: CGFloat = DS.Metric.gutter

    func body(content: Content) -> some View {
        content
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: top, leading: inset, bottom: bottom, trailing: inset))
    }
}

// MARK: - Target editor

struct TargetEditorSheet: View {
    var exercise: WorkoutExercise
    /// A bottom sheet on the phone; on iPad a popover off the row, which
    /// sizes itself and takes Return and Esc.
    var style: Style = .sheet
    var onSave: (Int, RepRange) -> Void

    enum Style { case sheet, popover }

    @Environment(\.dismiss) private var dismiss
    @State private var sets: Int
    @State private var lower: Int
    @State private var upper: Int

    init(exercise: WorkoutExercise, style: Style = .sheet, onSave: @escaping (Int, RepRange) -> Void) {
        self.exercise = exercise
        self.style = style
        self.onSave = onSave
        _sets = State(initialValue: exercise.sets.count)
        _lower = State(initialValue: exercise.repRange.lower)
        _upper = State(initialValue: exercise.repRange.upper)
    }

    var body: some View {
        switch style {
        case .sheet:
            form
                .padding(.horizontal, DS.Metric.gutter)
                .padding(.top, 26)
                .onChange(of: lower) { _, new in if upper < new { upper = new } }
                .presentationDetents([.height(380)])
                .presentationDragIndicator(.visible)
                .presentationBackground(DS.surface)
                .presentationCornerRadius(DS.Metric.sheetRadius)
        case .popover:
            form
                .padding(20)
                .onChange(of: lower) { _, new in if upper < new { upper = new } }
                .dsBackShortcuts { dismiss() }
        }
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 0) {
            MetaLine(text: exercise.exerciseName.uppercased(), em: 0.10)
            Text(exercise.isTimed ? "Sets & Time" : "Sets & Reps")
                .font(.ui(22, .semibold))
                .tracking(-0.45)
                .foregroundStyle(DS.silver)
                .padding(.top, 5)

            VStack(spacing: 4) {
                // Add Set has no cap: past 10 the range grows to the sets
                // already there, never below the ones done.
                stepper("Sets", value: $sets,
                        range: max(1, exercise.completedSets.count)...max(10, exercise.sets.count))
                if exercise.isTimed {
                    stepper("Seconds from", value: $lower, range: 5...300, step: 5)
                    stepper("Seconds up to", value: $upper, range: lower...300, step: 5)
                } else {
                    stepper("Reps from", value: $lower, range: 1...50)
                    stepper("Reps up to", value: $upper, range: lower...50)
                }
            }
            .padding(.top, 18)

            Text("Target: \(sets) × \(exercise.setMeasure.label(RepRange(lower, upper)))")
                .font(.mono(11, .semibold))
                .foregroundStyle(DS.silver.opacity(0.5))
                .padding(.top, 12)

            WideButton(title: "Save", prominent: true) {
                onSave(sets, RepRange(lower, upper))
                dismiss()
            }
            .applying(style == .popover) { $0.keyboardShortcut(.defaultAction) }
            .padding(.top, 20)
        }
    }

    private func stepper(_ title: String, value: Binding<Int>, range: ClosedRange<Int>,
                         step: Int = 1) -> some View {
        Stepper(value: value, in: range, step: step) {
            HStack {
                Text(title)
                    .font(.ui(15))
                    .foregroundStyle(DS.silver.opacity(0.8))
                Spacer()
                Text("\(value.wrappedValue)")
                    .font(.mono(15, .semibold))
                    .foregroundStyle(DS.silver)
                    .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Helpers

/// One of the screen's destructive confirmations, built once so it can sit
/// on the screen (iPhone, as an action sheet) or on the control that asked
/// for it (iPad, where it becomes a popover pointing at that control).
private struct PresetConfirmation<Item>: ViewModifier {
    var title: String
    var isPresented: Binding<Bool>
    var presenting: Item?
    var action: String
    var message: (Item) -> String
    var onConfirm: (Item) -> Void

    func body(content: Content) -> some View {
        content.confirmationDialog(title, isPresented: isPresented, titleVisibility: .visible,
                                  presenting: presenting) { item in
            Button(action, role: .destructive) { onConfirm(item) }
        } message: { item in
            Text(message(item))
        }
    }
}

extension View {
    /// Applies `transform` only when `condition` holds. For conditions fixed
    /// for the run (the device), so the view's identity never flips.
    @ViewBuilder
    fileprivate func applying<V: View>(_ condition: Bool, _ transform: (Self) -> V) -> some View {
        if condition { transform(self) } else { self }
    }
}
