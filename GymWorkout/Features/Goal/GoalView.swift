//
//  GoalView.swift
//  GymWorkout
//
//  The Goal page (owner-approved 2026-11-23), a sheet from Today and
//  Progress: the goal photo beside the photo it was made from, the look
//  picked, where the estimate says the member is, how long is left, how
//  regularly they train, the Sunday check-in, and the photo's actions. The
//  hero is one photo with a divider to drag between the start and the goal
//  (the owner's pick from two, 2026-11-23).
//
//  Everything is worked out on the phone from the record GoalStore keeps
//  (GoalModel.swift). One accent, silver; every offer tinted, none filled.
//

import SwiftUI
import UIKit
import UserNotifications

// MARK: - Page

struct GoalView: View {
    var onNewPhoto: () -> Void
    /// Opens the training days once the page has closed; nil where the host
    /// can't, and the page then says where they're set instead.
    var onEditSchedule: (() -> Void)? = nil

    @Environment(WorkoutStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    @Environment(\.dynamicTypeSize) private var typeSize

    /// On unless turned off here (`GoalReminder.isOn` reads the same key).
    @AppStorage(GoalReminder.storageKey) private var reminderOn = true
    /// Nil until read; read again whenever the app comes back, so a change
    /// made in iOS Settings shows at once.
    @State private var notificationStatus: UNAuthorizationStatus?
    @State private var confirmsDelete = false
    @State private var isSaving = false
    @State private var savedToPhotos = false
    @State private var photoAlert: GoalPhotoSaveResult?

    private var progress: GoalProgress? {
        GoalStore.shared.progress(profile: store.profile, experience: store.experience, trainedDays: store.trainedDays)
    }

    /// Whether a new goal photo can be made now (adults, not while pregnant
    /// or before the after-birth check-up): without it the page offers none.
    private var canCreate: Bool { GoalPhotoCard.canCreate(for: store.profile) }

    var body: some View {
        let goal = GoalStore.shared
        let progress = self.progress
        let paused = progress?.course == .paused
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let record = goal.record {
                        GoalHeader(record: record)
                        if let photo = goal.photo {
                            GoalHero(goal: photo, start: goal.before, since: record.createdAt)
                        }
                        GoalLookSection(look: record.look)
                        if let progress {
                            if paused {
                                GoalPausedSection()
                            } else {
                                GoalProgressSection(progress: progress, unit: store.unit)
                                GoalTimeSection(progress: progress, onEditSchedule: onEditSchedule, canCreate: canCreate)
                                GoalConsistencySection(progress: progress, since: record.createdAt)
                            }
                        } else {
                            GoalSectionCard {
                                Text(String(localized: "Finish your plan, and MUSQ shows how far along you are and how long is left.",
                                            comment: "Goal page without a plan"))
                                    .goalFont(14)
                                    .foregroundStyle(DS.silver.opacity(0.7))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        // No Sunday check-ins while the goal is paused.
                        if !paused {
                            GoalCheckInSection(isOn: $reminderOn, status: notificationStatus, onAllow: allowNotifications)
                        }
                        actions(offersNewPhoto: canCreate && !paused)
                        TodayFootnote()
                    } else {
                        GoalEmptyState(onNewPhoto: canCreate ? onNewPhoto : nil)
                    }
                }
                .dsGutter()
                .padding(.top, 8)
                .padding(.bottom, 36)
                .dsReadable(DS.Layout.columnWidth)
            }
            .background(DS.ink.ignoresSafeArea())
            .navigationTitle(String(localized: "Your goal", comment: "Goal page title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
        }
        .dsLayoutRoot()
        .tint(DS.silver)
        .task {
            GoalStore.shared.refresh(profile: store.profile)
            await readNotifications(relay: false)
        }
        .onChange(of: reminderOn) { _, isOn in reminderChanged(isOn) }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { Task { await readNotifications(relay: true) } }
        }
        .alert(photoAlert == .denied ? String(localized: "MUSQ can't save to Photos")
                                     : String(localized: "The photo couldn't be saved."),
               isPresented: Binding(get: { photoAlert == .denied || photoAlert == .failed },
                                    set: { if !$0 { photoAlert = nil } })) {
            if photoAlert == .denied {
                Button(String(localized: "Open Settings")) { openSettings() }
                Button(String(localized: "Not now"), role: .cancel) {}
            } else {
                Button(String(localized: "OK"), role: .cancel) {}
            }
        } message: {
            Text(photoAlert == .denied ? String(localized: "Let MUSQ add photos in Settings, then try again.")
                                       : String(localized: "Try again."))
        }
    }

    // MARK: Actions

    /// A new photo (only where one can be made, and not while paused), Save
    /// to Photos, then the quiet links: reporting the image (App Store 1.2:
    /// AI-made content can be reported) and deleting the goal.
    private func actions(offersNewPhoto: Bool) -> some View {
        VStack(spacing: 12) {
            let stack = typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(spacing: 10)) : AnyLayout(HStackLayout(spacing: 10))
            stack {
                if offersNewPhoto {
                    WideButton(title: String(localized: "New goal photo"), prominent: false, fontSize: 15,
                               verticalPadding: 13, action: onNewPhoto)
                }
                WideButton(title: savedToPhotos ? String(localized: "Saved") : String(localized: "Save to Photos"),
                           prominent: false, fontSize: 15, verticalPadding: 13, action: saveToPhotos)
                    .disabled(savedToPhotos || isSaving)
                    .opacity(isSaving ? 0.6 : 1)
            }
            HStack(spacing: 22) {
                Button {
                    if let url = Self.reportURL { openURL(url) }
                } label: {
                    quietLink(String(localized: "Report this image"), symbol: "flag")
                }
                .buttonStyle(.plain)
                Button { confirmsDelete = true } label: {
                    quietLink(String(localized: "Delete goal", comment: "Goal page: removes the goal and its photos"),
                              symbol: "trash")
                }
                .buttonStyle(.plain)
                .confirmationDialog(String(localized: "Delete your goal?"), isPresented: $confirmsDelete,
                                    titleVisibility: .visible) {
                    Button(String(localized: "Delete"), role: .destructive) { deleteGoal() }
                    Button(String(localized: "Cancel"), role: .cancel) {}
                } message: {
                    Text(String(localized: "The goal photo and its progress are removed from this \(DS.deviceNoun). Save the photo first to keep it."))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 4)
    }

    private func quietLink(_ title: String, symbol: String) -> some View {
        Label(title, systemImage: symbol)
            .goalFont(13.5, .semibold)
            .foregroundStyle(DS.silver.opacity(0.6))
            .frame(minHeight: 44)
            .contentShape(Rectangle())
    }

    private static let reportURL = URL(string: "mailto:\(AppLinks.supportEmail)?subject=MUSQ%20goal%20photo%20report")

    private func saveToPhotos() {
        guard !isSaving else { return }
        isSaving = true
        Task {
            let outcome = await GoalPhotoStore.saveLatestToPhotos()
            isSaving = false
            if outcome == .saved {
                savedToPhotos = true
                AccessibilityNotification.Announcement(String(localized: "Saved to Photos")).post()
            } else {
                photoAlert = outcome
            }
        }
    }

    private func deleteGoal() {
        GoalStore.shared.delete()
        GoalReminder.cancel()
        dismiss()
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
    }

    // MARK: Check-in

    /// On: ask for notifications if they never were, then lay the check-in.
    /// Off: take it down.
    private func reminderChanged(_ isOn: Bool) {
        guard isOn else {
            GoalReminder.cancel()
            return
        }
        Task {
            await requestNotificationsIfNeeded()
            await relayCheckIn()
        }
    }

    private func allowNotifications() {
        Task {
            await requestNotificationsIfNeeded()
            await relayCheckIn()
        }
    }

    /// Lays the Sunday check-in again; GoalReminder works out its numbers.
    private func relayCheckIn() async {
        await GoalReminder.relay(profile: store.profile, experience: store.experience, trainedDays: store.trainedDays)
    }

    private func requestNotificationsIfNeeded() async {
        let center = UNUserNotificationCenter.current()
        if await center.notificationSettings().authorizationStatus == .notDetermined {
            _ = try? await center.requestAuthorization(options: [.alert, .sound])
        }
        notificationStatus = await center.notificationSettings().authorizationStatus
    }

    /// `relay`: lay the check-in again when the answer changed while away
    /// (turned on in iOS Settings, say).
    private func readNotifications(relay: Bool) async {
        let status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        let changed = notificationStatus != nil && notificationStatus != status
        notificationStatus = status
        if relay && changed && reminderOn {
            await relayCheckIn()
        }
    }
}

// MARK: - Header

/// The look in the coach's serif voice, and since when.
private struct GoalHeader: View {
    let record: GoalRecord

    var body: some View {
        let since = record.createdAt.formatted(.dateTime.day().month(.abbreviated).year())
        VStack(alignment: .leading, spacing: 6) {
            TodayEyebrow(text: String(localized: "Since \(since)", comment: "Goal page: when the goal was set, e.g. Since 23 Nov 2026"),
                         size: 10.5)
            GoalLookTitle(look: record.look, size: 30, design: .serif)
                .tracking(-0.6)
                .foregroundStyle(DS.silver)
        }
        .padding(.top, 4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(String(localized: "Your goal: \(GoalWords.spokenLook(record.look)), since \(since)",
                                   comment: "VoiceOver, Goal page header: the look, then the date it was set"))
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Hero

/// The photos, then the caption that says what they are. Without the photo
/// the goal was made from, the goal photo alone.
private struct GoalHero: View {
    let goal: UIImage
    /// The photo the goal was made from.
    let start: UIImage?
    /// When the goal was made.
    let since: Date

    /// The goal photo's own shape, within portrait bounds.
    private var aspect: CGFloat {
        let size = goal.size
        guard size.width > 0, size.height > 0 else { return 0.75 }
        return min(1, max(0.56, size.width / size.height))
    }

    var body: some View {
        let startLabel = GoalStartLabel(since: since)
        VStack(alignment: .leading, spacing: 10) {
            if let start {
                GoalCompareSlider(start: start, goal: goal, aspect: aspect, startLabel: startLabel)
            } else {
                GoalPhotoCrop(image: goal, label: GoalHeroText.goalSpoken)
                    .aspectRatio(aspect, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
                    .overlay(alignment: .bottomLeading) {
                        GoalPhotoLabel(text: GoalHeroText.goal, ai: true).padding(12)
                    }
                    .frame(maxWidth: 500 * aspect)
                    .frame(maxWidth: .infinity)
            }
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Image(systemName: "sparkles")
                    .goalFont(11, .semibold)
                    .accessibilityHidden(true)
                Text(String(localized: "AI illustration: a possible result, not a prediction.",
                            comment: "Goal page, under the photos"))
                    .goalFont(12.5)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(DS.silver.opacity(0.55))
        }
    }
}

private enum GoalHeroText {
    static var goal: String { String(localized: "Goal", comment: "Goal page: label on the goal photo") }
    static var goalSpoken: String { String(localized: "Your goal photo") }
}

/// The label on the photo the goal was made from: "NOW" in the goal's first
/// week, then "START · 23 NOV", since by then it shows where the member
/// began, not where they are.
private struct GoalStartLabel {
    let text: String
    let spoken: String

    init(since: Date, now: Date = Date(), calendar: Calendar = .current) {
        let age = calendar.dateComponents([.day], from: calendar.startOfDay(for: since),
                                          to: calendar.startOfDay(for: now)).day ?? 0
        if age < 7 {
            text = String(localized: "Now", comment: "Goal page: label on the photo the goal was made from, in its first week")
            spoken = String(localized: "Your photo now")
        } else {
            let sameYear = calendar.isDate(since, equalTo: now, toGranularity: .year)
            let day = since.formatted(sameYear ? .dateTime.day().month(.abbreviated)
                                               : .dateTime.day().month(.abbreviated).year())
            text = String(localized: "Start · \(day)",
                          comment: "Goal page: label on the photo the goal was made from, with its date, e.g. Start · 23 Nov")
            spoken = String(localized: "Your photo at the start, \(since.formatted(.dateTime.day().month(.wide).year()))",
                            comment: "VoiceOver: the photo the goal was made from, with its date")
        }
    }
}

/// B: one photo, the start on the left of the divider and the goal on the
/// right. Drag the handle, or tap where the divider should go; the rest of
/// the photo still scrolls the page. VoiceOver adjusts it in quarters.
private struct GoalCompareSlider: View {
    let start: UIImage
    let goal: UIImage
    let aspect: CGFloat
    let startLabel: GoalStartLabel

    /// The divider, 0...1 across: the start to its left, the goal to its right.
    @State private var split: CGFloat = 0.5

    private static let space = "goal.compare"

    var body: some View {
        GeometryReader { geo in
            let width = max(geo.size.width, 1)
            let x = width * split
            ZStack(alignment: .topLeading) {
                GoalPhotoCrop(image: start)
                GoalPhotoCrop(image: goal)
                    .mask(alignment: .leading) {
                        HStack(spacing: 0) {
                            Color.clear.frame(width: x)
                            Color.black
                        }
                    }
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 2)
                    .shadow(color: .black.opacity(0.35), radius: 3)
                    .offset(x: x - 1)
                    .allowsHitTesting(false)
                GoalPhotoLabel(text: startLabel.text)
                    .padding(10)
                    .opacity(split > 0.3 ? 1 : 0)
                GoalPhotoLabel(text: GoalHeroText.goal, ai: true)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .opacity(split < 0.8 ? 1 : 0)
                // The handle: a 44-pt strip down the divider, the knob on it.
                Color.clear
                    .frame(width: 44)
                    .contentShape(Rectangle())
                    .overlay {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 34, height: 34)
                            .overlay(Image(systemName: "arrow.left.and.right")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color.black.opacity(0.75)))
                            .shadow(color: .black.opacity(0.3), radius: 6, y: 2)
                    }
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named(Self.space))
                        .onChanged { value in split = min(1, max(0, value.location.x / width)) })
                    .position(x: x, y: geo.size.height / 2)
            }
            .coordinateSpace(.named(Self.space))
            .contentShape(Rectangle())
            .onTapGesture(coordinateSpace: .local) { location in
                withAnimation(.snappy(duration: 0.3)) { split = min(1, max(0, location.x / width)) }
            }
        }
        .aspectRatio(aspect, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
        .frame(maxWidth: 520 * aspect)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(String(localized: "\(startLabel.spoken), and your goal photo, with a divider between them",
                                   comment: "VoiceOver, the compare slider; the value is the start photo, e.g. Your photo now"))
        .accessibilityValue(String(localized: "\(GoalWords.percent(1 - split)) goal photo",
                                   comment: "VoiceOver: how much of the compare shows the goal photo, e.g. 50% goal photo"))
        .accessibilityHint(String(localized: "Swipe up or down to move the divider"))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: split = max(0, split - 0.25)
            case .decrement: split = min(1, split + 0.25)
            @unknown default: break
            }
        }
    }
}

/// "NOW", "START · 23 NOV", "✦ GOAL" on a photo: dark glass and white
/// whatever the photo.
private struct GoalPhotoLabel: View {
    let text: String
    var ai = false

    var body: some View {
        HStack(spacing: 4) {
            if ai {
                Image(systemName: "sparkles")
                    .font(.system(size: 9, weight: .bold))
            }
            Text(text)
                .goalFont(10, .semibold, design: .monospaced)
                .trackingEm(0.1, size: 10)
                .textCase(.uppercase)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(Capsule().fill(Color.black.opacity(0.45)))
        .accessibilityHidden(true)
    }
}

// MARK: - Sections

/// A section on the sheet's ground: an eyebrow, a course tag at the right
/// when there is one, then the content.
private struct GoalSectionCard<Content: View>: View {
    var title: String? = nil
    var tag: String? = nil
    @ViewBuilder var content: () -> Content

    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if title != nil || tag != nil {
                HStack(alignment: .center, spacing: 8) {
                    if let title {
                        TodayEyebrow(text: title, size: 10.5 * typeSize.goalScale)
                            .accessibilityAddTraits(.isHeader)
                    }
                    Spacer(minLength: 8)
                    if let tag { GoalTag(text: tag) }
                }
            }
            content()
        }
        .padding(18)
        .goalCard()
    }
}

/// The muscle and body fat picked: two tiles, each level's name and what it
/// shows. A level kept as it is reads dimmer.
private struct GoalLookSection: View {
    let look: GoalLook

    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        let stack = typeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 10))
            : AnyLayout(HStackLayout(alignment: .top, spacing: 10))
        GoalSectionCard(title: String(localized: "The look", comment: "Goal page section: the muscle and body fat picked")) {
            stack {
                tile(symbol: "dumbbell.fill", label: String(localized: "Muscle", comment: "Goal page: the muscle level picked"),
                     title: look.muscle.title, detail: look.muscle.detail(for: look.sex), changes: look.muscle != .same)
                tile(symbol: "percent", label: String(localized: "Body fat", comment: "Goal page: the body-fat level picked"),
                     title: look.fat.title, detail: look.fat.detail(for: look.sex), changes: look.fat != .same)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 12)
        }
    }

    private func tile(symbol: String, label: String, title: String, detail: String, changes: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Image(systemName: symbol)
                    .goalFont(9.5, .bold)
                    .accessibilityHidden(true)
                Text(label)
                    .goalFont(10, .semibold, design: .monospaced)
                    .trackingEm(0.08, size: 10)
                    .textCase(.uppercase)
                    .lineLimit(1)
            }
            .foregroundStyle(DS.silver.opacity(0.5))
            Text(title)
                .goalFont(18, .semibold)
                .foregroundStyle(DS.silver.opacity(changes ? 1 : 0.6))
            Text(detail)
                .goalFont(12.5)
                .foregroundStyle(DS.silver.opacity(0.62))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(DS.silver.opacity(0.05)))
        .accessibilityElement(children: .combine)
    }
}

/// The share reached, then each part the look changes: body fat and lean
/// mass from their start to the goal, filled to now; the weight now; and
/// where the numbers come from.
private struct GoalProgressSection: View {
    let progress: GoalProgress
    let unit: WeightUnit

    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        let measured = GoalWords.isMeasured(progress)
        let shown = GoalWords.shownFraction(progress)
        GoalSectionCard(title: String(localized: "Progress", comment: "Goal page section")) {
            if measured {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    GoalPercentFigure(percent: GoalWords.wholePercent(shown), size: 44 * typeSize.goalScale)
                    Text(String(localized: "of the way there", comment: "Goal page: after the share reached, 34% of the way there"))
                        .goalFont(14, .medium)
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 6)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(String(localized: "\(GoalWords.percent(shown)) of the way there",
                                           comment: "VoiceOver: the share of the goal reached"))
                GoalMeter(value: shown, height: 8)
                    .padding(.top, 10)
            } else if progress.bodyFatPercent == nil {
                Text(String(localized: "Not measured yet", comment: "Goal page: no body-fat estimate to measure progress with"))
                    .goalFont(20, .semibold)
                    .foregroundStyle(DS.silver)
                    .padding(.top, 8)
            }
            VStack(alignment: .leading, spacing: 18) {
                fatRow
                leanRow
                weightRow
            }
            .padding(.top, measured ? 22 : 14)
            Text(note)
                .goalFont(12.5)
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 16)
        }
    }

    @ViewBuilder
    private var fatRow: some View {
        if let now = progress.bodyFatPercent, let start = progress.startBodyFatPercent,
           let target = progress.targetBodyFatPercent, let fraction = progress.fatFraction {
            measureRow(title: String(localized: "Body fat", comment: "Goal page progress row"),
                       now: GoalWords.bodyFat(now), start: GoalWords.bodyFat(start), goal: GoalWords.bodyFat(target),
                       fraction: fraction)
        } else if progress.look.fat != .same, let now = progress.bodyFatPercent {
            // The look asks for less body fat, and the estimate is already there.
            plainRow(title: String(localized: "Body fat", comment: "Goal page progress row"), value: GoalWords.bodyFat(now),
                     detail: String(localized: "Already in your goal's range"))
        }
    }

    @ViewBuilder
    private var leanRow: some View {
        if let now = progress.leanKg, let start = progress.startLeanKg,
           let target = progress.targetLeanKg, let fraction = progress.muscleFraction {
            measureRow(title: String(localized: "Lean mass", comment: "Goal page progress row: weight minus fat"),
                       now: unit.bodyWeight(now), start: unit.bodyWeight(start), goal: unit.bodyWeight(target),
                       fraction: fraction)
        }
    }

    private var weightRow: some View {
        plainRow(title: String(localized: "Weight now", comment: "Goal page progress row"),
                 value: unit.bodyWeight(progress.weightKg), detail: nil)
    }

    private var note: String {
        progress.bodyFatPercent == nil
            ? String(localized: "Add your body-fat % in Edit Profile (from a smart scale or a body scan) to see body fat and lean mass here.")
            : String(localized: "Estimated from your weigh-ins and your body-fat estimate. Entering a body-fat % from a smart scale in Edit Profile makes it more accurate.")
    }

    /// "Body fat · now 18% → goal 13%", a bar from the start to the goal
    /// filled to now, and under it the start and the share reached. With
    /// large text the values take a line each rather than being cut off.
    private func measureRow(title: String, now: String, start: String, goal: String, fraction: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    rowTitle(title)
                    Spacer(minLength: 8)
                    values(now: now, goal: goal)
                }
                VStack(alignment: .leading, spacing: 4) {
                    rowTitle(title)
                    values(now: now, goal: goal)
                }
                VStack(alignment: .leading, spacing: 4) {
                    rowTitle(title)
                    value(word: nowWord, value: now, strong: true)
                    value(word: goalWord, value: goal, strong: false)
                }
            }
            GoalMeter(value: fraction, height: 5)
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    startText(start)
                    Spacer(minLength: 8)
                    thereText(fraction)
                }
                VStack(alignment: .leading, spacing: 2) {
                    startText(start)
                    thereText(fraction)
                }
            }
            .goalFont(12, .medium, digits: true)
            .foregroundStyle(DS.silver.opacity(0.6))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(String(localized: "\(title): now \(now), goal \(goal), \(start) at the start. \(GoalWords.percent(fraction)) of the way.",
                                   comment: "VoiceOver, a goal progress row: Body fat: now 18%, goal 13%, 20.5% at the start. 33% of the way."))
    }

    private func rowTitle(_ title: String) -> some View {
        Text(title)
            .goalFont(15, .semibold)
            .foregroundStyle(DS.silver)
    }

    private var nowWord: String {
        String(localized: "now", comment: "Goal page: before the current value, now 18%")
    }

    private var goalWord: String {
        String(localized: "goal", comment: "Goal page: before the goal value, goal 13%")
    }

    /// "Start 20.5%".
    private func startText(_ start: String) -> Text {
        Text(String(localized: "Start \(start)", comment: "Goal page, under a progress bar: the value when the goal was set, e.g. Start 20.5%"))
    }

    /// "33% there": this part's share of the way, so it never reads as a value.
    private func thereText(_ fraction: Double) -> Text {
        Text(String(localized: "\(GoalWords.percent(fraction)) there",
                    comment: "Goal page, under a progress bar: the share of this part reached, e.g. 33% there"))
    }

    /// "now 18% → goal 13%" on one line.
    private func values(now: String, goal: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            value(word: nowWord, value: now, strong: true)
            Image(systemName: "arrow.right")
                .goalFont(10, .bold)
                .foregroundStyle(DS.silver.opacity(0.35))
                .padding(.horizontal, 2)
            value(word: goalWord, value: goal, strong: false)
        }
        .lineLimit(1)
    }

    /// "now 18%"; the goal's value a little dimmer than now's.
    private func value(word: String, value: String, strong: Bool) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            Text(word)
                .goalFont(12.5, .medium)
                .foregroundStyle(DS.silver.opacity(0.5))
            Text(value)
                .goalFont(16, .semibold, digits: true)
                .foregroundStyle(DS.silver.opacity(strong ? 1 : 0.7))
        }
    }

    private func plainRow(title: String, value: String, detail: String?) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                rowTitle(title)
                if let detail {
                    Text(detail)
                        .goalFont(12.5)
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 8)
            Text(value)
                .goalFont(16, .semibold, digits: true)
                .foregroundStyle(DS.silver)
        }
        .accessibilityElement(children: .combine)
    }
}

/// How long is left and around when; the course's words when no date can
/// be said; a celebration once the estimate is there.
private struct GoalTimeSection: View {
    let progress: GoalProgress
    var onEditSchedule: (() -> Void)?
    /// Whether a new goal photo can be made: only then do the reached words
    /// suggest one.
    var canCreate: Bool

    var body: some View {
        GoalSectionCard(title: String(localized: "Time to goal", comment: "Goal page section")) {
            content
                .padding(.top, 8)
        }
    }

    @ViewBuilder
    private var content: some View {
        if progress.course == .reached {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image(systemName: "flag.checkered")
                        .goalFont(18, .semibold)
                        .foregroundStyle(DS.silver.opacity(0.85))
                        .accessibilityHidden(true)
                    Text(String(localized: "You've reached your goal"))
                        .goalFont(24, .semibold, design: .serif)
                        .foregroundStyle(DS.silver)
                        .fixedSize(horizontal: false, vertical: true)
                }
                detail(canCreate
                       ? String(localized: "By the estimate, you're there. Make a new goal photo to see how far you've come, and to set your next goal.")
                       : String(localized: "By the estimate, you're there. Keep training to hold on to it."))
            }
            .accessibilityElement(children: .combine)
        } else if let toGo = GoalWords.toGo(progress) {
            VStack(alignment: .leading, spacing: 6) {
                Text(toGo)
                    .goalFont(24, .semibold)
                    .tracking(-0.4)
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                detail(paceLine)
            }
            .accessibilityElement(children: .combine)
        } else {
            VStack(alignment: .leading, spacing: 6) {
                Text(String(localized: "No date yet", comment: "Goal page: no time-to-goal can be worked out"))
                    .goalFont(22, .semibold)
                    .foregroundStyle(DS.silver)
                detail(noDateLine)
                if progress.course == .noSchedule, let onEditSchedule {
                    WideButton(title: String(localized: "Set training days"), prominent: false, fontSize: 15,
                               verticalPadding: 12, cornerRadius: 12, action: onEditSchedule)
                        .dsCTA(alignment: .leading)
                        .padding(.top, 8)
                }
            }
        }
    }

    private func detail(_ text: String) -> some View {
        Text(text)
            .goalFont(14)
            .foregroundStyle(DS.silver.opacity(0.65))
            .fixedSize(horizontal: false, vertical: true)
    }

    /// "Around 2 Mar 2027, at the pace you're training now."
    private var paceLine: String {
        let day = progress.targetDate.map { $0.formatted(.dateTime.day().month(.abbreviated).year()) }
        switch progress.course {
        case .starting:
            return day.map {
                String(localized: "Around \($0), if you keep to your training days.",
                       comment: "Goal page in the goal's first week; the value is a date, e.g. 2 Mar 2027")
            } ?? String(localized: "If you keep to your training days.")
        case .behind:
            return day.map {
                String(localized: "Around \($0) at your current pace. Every session you add brings it closer.",
                       comment: "Goal page when behind; the value is a date, e.g. 2 Mar 2027")
            } ?? String(localized: "At your current pace. Every session you add brings it closer.")
        default:
            return day.map {
                String(localized: "Around \($0), at the pace you're training now.",
                       comment: "Goal page on course; the value is a date, e.g. 2 Mar 2027")
            } ?? String(localized: "At the pace you're training now.")
        }
    }

    private var noDateLine: String {
        switch progress.course {
        case .noSchedule:
            return onEditSchedule != nil
                ? String(localized: "MUSQ works out the date from your training days. Set them, and your goal gets a date.")
                : String(localized: "MUSQ works out the date from your training days. Set them in Edit Profile, and your goal gets a date.")
        case .offTrack:
            return String(localized: "At this rate your goal is hard to reach. Training regularly brings a date back.")
        default:
            // Nothing measured: no body-fat estimate to count from, or the
            // body fat the look asks for is already there.
            return progress.bodyFatPercent == nil
                ? String(localized: "Add your body-fat % in Edit Profile, and MUSQ can work out how long is left.")
                : String(localized: "Your body fat is already in your goal's range, so there's nothing left to count down.")
        }
    }
}

/// This week's sessions against the plan, how regularly the plan is kept,
/// and the last five weeks as columns of sessions.
private struct GoalConsistencySection: View {
    let progress: GoalProgress
    /// When the goal was set: the consistency window starts there when newer
    /// than four weeks.
    let since: Date

    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        let week = progress.thisWeek
        let done = week?.done ?? 0
        let planned = week?.planned ?? 0
        // Out of the week's goal: the plan, or the sessions done when they're more.
        let goal = week?.goal ?? 0
        let scale = typeSize.goalScale
        GoalSectionCard(title: String(localized: "Training", comment: "Goal page section: how regularly the member trains"),
                        tag: GoalWords.tag(progress.course)) {
            HStack(alignment: .top, spacing: 12) {
                figure(caption: (planned > 0 ? goal : done) == 1
                           ? String(localized: "session this week", comment: "Goal page: under 1 of 1, or 1 without training days")
                           : String(localized: "sessions this week", comment: "Goal page: under 2 of 4"),
                       spoken: GoalWords.spokenWeek(week)) {
                    BigValue(value: done.formatted(),
                             unit: planned > 0 ? String(localized: "of \(goal)", comment: "Goal page: after the sessions done this week, out of the week's goal, 2 of 4") : nil,
                             size: 30 * scale)
                }
                if planned > 0 {
                    if GoalWords.noSessionYet(progress) {
                        // Day one: nothing to count yet, so a dash, never 0%.
                        figure(caption: GoalWords.tag(.starting),
                               spoken: String(localized: "First week: no sessions to count yet",
                                              comment: "VoiceOver: the consistency figure before the goal's first session")) {
                            BigValue(value: "–", size: 30 * scale, color: DS.silver.opacity(0.35))
                        }
                    } else {
                        figure(caption: windowCaption,
                               spoken: String(localized: "\(GoalWords.percent(progress.consistency)) \(windowCaption)",
                                              comment: "VoiceOver: consistency, e.g. 75% of planned sessions, last 4 weeks")) {
                            GoalPercentFigure(percent: GoalWords.wholePercent(progress.consistency), size: 30 * scale)
                        }
                    }
                }
            }
            .padding(.top, 10)
            GoalWeekBars(weeks: progress.weeks)
                .frame(height: 104 * min(scale, 1.25))
                .padding(.top, 18)
            if progress.weeks.contains(where: \.beforeGoal) {
                Text(String(localized: "Lighter weeks are from before you set your goal.",
                            comment: "Goal page, under the week chart"))
                    .goalFont(12)
                    .foregroundStyle(DS.silver.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 10)
            }
            if planned == 0 {
                Text(String(localized: "Set your training days to see how regularly you keep to them."))
                    .goalFont(12.5)
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 12)
            }
        }
    }

    /// The same window GoalProgress counts over: the last 7 days in the
    /// goal's first week, the days since the goal until it's 4 weeks old,
    /// then the last 4 weeks.
    private var windowCaption: String {
        let calendar = Calendar.current
        let age = calendar.dateComponents([.day], from: calendar.startOfDay(for: since),
                                          to: calendar.startOfDay(for: Date())).day ?? 0
        let days = min(28, max(7, age + 1))
        if days >= 28 {
            return String(localized: "of planned sessions, last 4 weeks", comment: "Goal page: under the consistency %")
        }
        if days <= 7 {
            return String(localized: "of planned sessions, last 7 days", comment: "Goal page: under the consistency %")
        }
        return String(localized: "of planned sessions since you set your goal", comment: "Goal page: under the consistency %")
    }

    private func figure<Number: View>(caption: String, spoken: String, @ViewBuilder number: () -> Number) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            number()
            Text(caption)
                .goalFont(12.5)
                .foregroundStyle(DS.silver.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(spoken)
    }
}

/// Five weeks as columns of sessions, one block each: done filled, planned
/// but not done faint (dashed this week: still to come), sessions past the
/// plan stacked on top. Weeks that ended before the goal are drawn lighter,
/// with only what was done: nothing then counts as missed. The count over
/// each column, its week under it.
private struct GoalWeekBars: View {
    let weeks: [GoalProgress.Week]

    var body: some View {
        let top = max(1, weeks.map { $0.beforeGoal ? $0.done : $0.goal }.max() ?? 1)
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
                column(week, top: top, isCurrent: index == weeks.count - 1)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(spoken)
    }

    private func column(_ week: GoalProgress.Week, top: Int, isCurrent: Bool) -> some View {
        let quiet = week.beforeGoal
        return VStack(spacing: 6) {
            Text(week.done.formatted())
                .goalFont(11, .semibold, design: .monospaced)
                .foregroundStyle(DS.silver.opacity(isCurrent ? 0.95 : quiet ? 0.3 : 0.5))
            VStack(spacing: 3) {
                ForEach(Array((0..<top).reversed()), id: \.self) { slot in
                    block(slot: slot, week: week, isCurrent: isCurrent)
                }
            }
            .frame(maxWidth: 30)
            Text(week.start.formatted(.dateTime.day().month(.abbreviated)))
                .goalFont(9.5, isCurrent ? .bold : .semibold, design: .monospaced)
                .textCase(.uppercase)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .foregroundStyle(DS.silver.opacity(isCurrent ? 0.9 : quiet ? 0.28 : 0.4))
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func block(slot: Int, week: GoalProgress.Week, isCurrent: Bool) -> some View {
        let shape = RoundedRectangle(cornerRadius: 3, style: .continuous)
        if week.beforeGoal {
            if slot < week.done {
                shape.fill(DS.silver.opacity(0.22))
            } else {
                Color.clear
            }
        } else if slot < week.done {
            shape.fill(DS.silver)
        } else if slot < week.planned {
            if isCurrent {
                shape.strokeBorder(DS.silver.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
            } else {
                shape.fill(DS.silver.opacity(0.09))
            }
        } else {
            Color.clear
        }
    }

    /// "Sessions per week. Week of 27 October: 3 of 4. …"
    private var spoken: String {
        let items = weeks.map { week in
            let day = week.start.formatted(.dateTime.day().month(.wide))
            if week.beforeGoal {
                return String(localized: "Week of \(day), before your goal: \(GoalWords.sessions(week.done))",
                              comment: "VoiceOver, goal week chart: a week before the goal was set; the value is a count such as 2 sessions")
            }
            return week.planned > 0
                ? String(localized: "Week of \(day): \(week.done) of \(week.goal)",
                         comment: "VoiceOver, goal week chart: a week's sessions done of the week's goal")
                : String(localized: "Week of \(day): \(GoalWords.sessions(week.done))",
                         comment: "VoiceOver, goal week chart: a week's sessions without training days")
        }
        return ([String(localized: "Sessions per week", comment: "VoiceOver: the goal week chart")] + items)
            .joined(separator: ". ")
    }
}

/// In place of progress, time and training while the plan is on hold
/// (pregnant, after birth before the check-up, under 19 or underweight):
/// no countdown and no check-ins, just why.
private struct GoalPausedSection: View {
    var body: some View {
        GoalSectionCard(title: String(localized: "Progress", comment: "Goal page section"),
                        tag: GoalWords.tag(.paused)) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Image(systemName: GoalWords.statusSymbol(.paused))
                    .goalFont(15, .semibold)
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .accessibilityHidden(true)
                Text(String(localized: "Your goal is paused: your plan is set to stay fit for now, so MUSQ doesn't count down to a leaner or bigger body. It picks up again when your plan does.",
                            comment: "Goal page while the plan is on hold"))
                    .goalFont(14)
                    .foregroundStyle(DS.silver.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 10)
        }
    }
}

/// The Sunday evening check-in's switch, and what it needs to arrive:
/// notifications allowed, or turned back on in iOS Settings.
private struct GoalCheckInSection: View {
    @Binding var isOn: Bool
    var status: UNAuthorizationStatus?
    var onAllow: () -> Void

    var body: some View {
        GoalSectionCard {
            Toggle(isOn: $isOn) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(String(localized: "Sunday evening check-in", comment: "Goal page: the weekly reminder's switch"))
                        .goalFont(15, .semibold)
                        .foregroundStyle(DS.silver)
                    Text(String(localized: "A short note each Sunday evening: your sessions that week and how long is left to your goal."))
                        .goalFont(12.5)
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .tint(DS.silver)
            if isOn, status == .denied {
                hint(String(localized: "Notifications are off for MUSQ in iOS Settings, so the check-in can't arrive."),
                     button: String(localized: "Open Settings"), symbol: "gear") {
                    if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
                }
            } else if isOn, status == .notDetermined {
                hint(String(localized: "Allow notifications so the check-in can arrive."),
                     button: String(localized: "Allow notifications"), symbol: "bell", action: onAllow)
            }
        }
    }

    private func hint(_ text: String, button: String, symbol: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Hairline(opacity: 0.08)
                .padding(.bottom, 8)
            Text(text)
                .goalFont(13)
                .foregroundStyle(DS.silver.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
            QuickChip(title: button, symbol: symbol, action: action)
        }
        .padding(.top, 12)
    }
}

/// No goal (deleted elsewhere, or not made yet): the invitation, with its
/// one tinted button where a goal photo can be made.
private struct GoalEmptyState: View {
    let onNewPhoto: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: GoalInviteContent.symbol)
                .goalFont(26)
                .foregroundStyle(DS.silver.opacity(0.75))
                .frame(width: 56, height: 56)
                .background(Circle().fill(DS.silver.opacity(0.07)))
                .accessibilityHidden(true)
            Text(GoalInviteContent.title)
                .goalFont(26, .semibold, design: .serif)
                .foregroundStyle(DS.silver)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            ForEach(GoalInviteContent.lines, id: \.self) { line in
                Text(line)
                    .goalFont(15)
                    .foregroundStyle(DS.silver.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let onNewPhoto {
                WideButton(title: GoalInviteContent.button, prominent: false, fontSize: 15, verticalPadding: 13,
                           action: onNewPhoto)
                    .dsCTA(alignment: .leading)
                    .padding(.top, 6)
            }
        }
        .padding(.top, 24)
    }
}
