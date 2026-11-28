//
//  TodayKit.swift
//  GymWorkout
//
//  What the Today tab's candidate layouts share (2026-11-21): the switch
//  between them, the actions they call, the identity colours, and the
//  pieces more than one of them draws — the session poster on the body map,
//  the week strip, quick chips, exercise stills, the macro bar, the notes
//  and the weight trend chart. Phase 2 (2026-11-22) adds the Apple Health
//  pieces: the invitation, the steps and sleep week bars and words, and
//  the active-energy note beside the calorie target.
//

import Charts
import SwiftUI

// MARK: - Colours

/// One identity colour per habit, used on rings, glyphs and lines; values
/// stay silver. Kept apart from Train's rhythm colours (green, yellow and red
/// mean recovery there) and from activation, which means muscles.
enum TodayTone {
    static let workout = DS.activation
    static let workoutText = Color(light: 0xC2410C, dark: 0xFF7A45)
    static let water = Color(light: 0x1F74E0, dark: 0x4A9DFF)
    static let violet = Color(light: 0x6E56CF, dark: 0x9F8CFF)
    static let pink = Color(light: 0xC0266C, dark: 0xFF6FAE)
}

// MARK: - Actions

/// What a layout can ask the tab to do; the tab owns the sheets.
struct TodayActions {
    var addWater: (Int) -> Void
    var undoWater: () -> Void
    var logWeight: () -> Void
    var weightHistory: () -> Void
    var waterSettings: () -> Void
    var weighInTime: () -> Void
    var reminders: () -> Void
    var setWaterReminder: (Bool) -> Void
    var setWeighInReminder: (Bool) -> Void
    var showPlan: () -> Void
    var editProfile: () -> Void
    var openTrain: () -> Void
    /// Plans the suggested groups on today (Train's Add to Today for each)
    /// and opens Train.
    var startDay: ([MuscleGroup]) -> Void
    /// Opens the coach chat, for every tier (2026-11-27: Free gets a few
    /// questions a day; the chat itself says when they're used up).
    var askCoach: () -> Void
    /// Opens Progress on Overview, scrolled to the steps and sleep trends.
    var openProgress: () -> Void
    /// Opens the quick log (2026-11-22) on water, a walk or a meal, typed
    /// or spoken: a custom water amount and today's glasses, steps from a
    /// walk without the phone, or a meal by hand (free for everyone).
    var quickLog: (QuickLogKind) -> Void = { _ in }
    /// Runs Balance's one action (its lever's button).
    var balanceAction: (BalanceAction) -> Void = { _ in }
    /// Opens Balance's sheet: the pillars, what's behind them, Ask MUSQ.
    var openBalance: () -> Void = {}
    /// Opens the goal (2026-11-23): the Goal page, or the goal photo setup
    /// when there is none yet.
    var openGoal: () -> Void = {}
    /// The Food page (2026-11-27): the day's energy bar, macros and meals.
    var openFood: () -> Void = {}
    /// Hours slept last night, logged by hand (the dock's Sleep).
    var logSleep: () -> Void = {}
    /// The quick log with its mic already on (the dock's mic).
    var voiceLog: () -> Void = {}
    /// The full "Your day" panel, as a sheet (the dock's last button).
    var openYourDay: () -> Void = {}

    /// What a tap on the steps row or tile does: with every step today
    /// added by hand, the walk log (Progress would show only Apple Health,
    /// without them); otherwise Progress's trends.
    func openSteps(_ metrics: TodayMetrics) -> () -> Void {
        guard metrics.stepsAllManual else { return openProgress }
        let log = quickLog
        return { log(.steps) }
    }
}

// MARK: - Counts

/// Counts in words, with the singular for one. The keys are the app's
/// existing count phrases, so their translations carry over.
enum TodayCount {
    static func sets(_ count: Int) -> String {
        count == 1 ? String(localized: "1 set") : String(localized: "\(count) sets")
    }

    static func exercises(_ count: Int) -> String {
        count == 1 ? String(localized: "1 exercise") : String(localized: "\(count) exercises")
    }

    /// "6 exercises · 18 sets".
    static func session(exercises: Int, sets: Int) -> String {
        "\(Self.exercises(exercises)) · \(Self.sets(sets))"
    }
}

// MARK: - Text pieces

/// A big number with its unit or denominator small beside it: "750 / 2.5 L".
struct BigValue: View {
    var value: String
    var unit: String? = nil
    var size: CGFloat
    var weight: Font.Weight = .bold
    var color: Color = DS.silver
    var unitColor: Color = DS.silver.opacity(0.55)

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: max(2, size * 0.1)) {
            Text(value)
                .font(.ui(size, weight))
                .tracking(-0.02 * size)
                .monospacedDigit()
                .foregroundStyle(color)
                .contentTransition(.numericText())
            if let unit {
                Text(unit)
                    .font(.ui(max(12, (size * 0.48).rounded()), .semibold))
                    .foregroundStyle(unitColor)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .accessibilityElement(children: .combine)
    }
}

/// A mono eyebrow: "TODAY'S SESSION".
struct TodayEyebrow: View {
    var text: String
    var size: CGFloat = 10.5
    var opacity: Double = 0.6

    var body: some View {
        Text(text)
            .font(.mono(size, .semibold))
            .trackingEm(0.10, size: size)
            .foregroundStyle(DS.silver.opacity(opacity))
            .textCase(.uppercase)
            .lineLimit(1)
    }
}

/// A section's title with an optional link on the right: "Weight · History ›".
struct TodaySectionHead: View {
    var title: String
    var link: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.ui(20, .bold))
                .tracking(-0.3)
                .foregroundStyle(DS.silver)
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 8)
            if let link, let action {
                Button(action: action) {
                    HStack(spacing: 3) {
                        Text(link)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .font(.ui(13.5, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

/// "Estimates for general guidance, not medical advice."
struct TodayFootnote: View {
    var body: some View {
        Text("Estimates for general guidance, not medical advice.")
            .font(.ui(12))
            .foregroundStyle(DS.silver.opacity(0.55))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 8)
    }
}

// MARK: - Controls

/// A capsule action, tinted unless it is the page's one filled control.
struct QuickChip: View {
    var title: String
    var symbol: String? = nil
    var filled = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 12, weight: .bold))
                }
                Text(title)
                    .font(.ui(14, .semibold))
                    .monospacedDigit()
                    .lineLimit(1)
            }
            .fixedSize()
            .foregroundStyle(filled ? DS.ink : DS.silver)
            .padding(.horizontal, 13)
            .frame(height: 34)
            .background(Capsule().fill(filled ? DS.silver : DS.silver.opacity(0.07)))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(filled ? 0 : 0.10), lineWidth: 1))
            .padding(.vertical, 5)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

/// The quick log's way in: a mic "Log" chip whose menu picks water, a walk
/// or a meal. Typed or spoken on the device; nothing is sent anywhere.
struct TodayQuickLogMenu: View {
    var action: (QuickLogKind) -> Void

    var body: some View {
        Menu {
            Button(String(localized: "Water", comment: "Quick log menu item"), systemImage: "drop.fill") {
                action(.water)
            }
            Button(String(localized: "Walk", comment: "Quick log menu item: steps from a walk without the phone or Watch"),
                   systemImage: "figure.walk") {
                action(.steps)
            }
            Button(String(localized: "Food", comment: "Quick log menu item: a meal added by hand"), systemImage: "fork.knife") {
                action(.food)
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 12, weight: .bold))
                Text("Log", comment: "Opens the quick log: water, a walk or food, typed or spoken")
                    .font(.ui(14, .semibold))
                    .lineLimit(1)
            }
            .fixedSize()
            .foregroundStyle(DS.silver)
            .padding(.horizontal, 13)
            .frame(height: 34)
            .background(Capsule().fill(DS.silver.opacity(0.07)))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
            .padding(.vertical, 5)
            .contentShape(Rectangle())
        }
        .accessibilityLabel(String(localized: "Log water, a walk or a meal"))
        .accessibilityHint(String(localized: "Type it or say it"))
    }
}

/// The quick log's chip with a line saying what it takes, for layouts
/// without a header to hold it (A and B, by the water tile).
struct TodayQuickLogRow: View {
    var actions: TodayActions

    var body: some View {
        HStack(spacing: 10) {
            TodayQuickLogMenu(action: actions.quickLog)
            Text("Water, a walk or a meal — type it or say it.", comment: "Beside the quick log button on Today")
                .font(.ui(13))
                .foregroundStyle(DS.silver.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityHidden(true)
            Spacer(minLength: 0)
        }
    }
}

/// Today's meals (`TodayMealsSection`, with the photo scan for Pro), shown
/// to everyone since 2026-11-22: a meal added by words is free — the
/// section's own "Log food" opens the quick log's Food tab, which finds
/// each food in MUSQ's food table (2026-11-23).
struct TodayMealsBlock: View {
    var metrics: TodayMetrics
    var actions: TodayActions

    var body: some View {
        TodayMealsSection(metrics: metrics)
    }
}

// MARK: - Water

/// The words the water pieces share.
enum TodayWaterText {
    /// VoiceOver hint where a tap opens the water log.
    static var opensLog: String {
        String(localized: "Opens your water log: a custom amount and today's glasses",
               comment: "VoiceOver hint on Today's water")
    }

    /// "Custom amount…" in the water menus.
    static var custom: String {
        String(localized: "Custom amount…", comment: "Opens the water log for an amount of one's own")
    }

    /// What follows a water amount in litres: "/ 2.5 L" against the day's
    /// target, or "L" alone (no target beside it).
    static func litresUnit(target ml: Int? = nil) -> String {
        guard let ml else {
            return String(localized: "L", comment: "Unit: litres, beside a water amount (1.25 L)")
        }
        let target = (Double(ml) / 1_000).formatted(.number.precision(.fractionLength(0...2)))
        return String(localized: "/ \(target) L", comment: "After today's water in litres, the day's target: 1.25 / 2.5 L")
    }
}

/// For a few seconds after a glass is added, on every layout: what went in,
/// and the Undo that takes back exactly that glass.
struct WaterUndoToast: View {
    var ml: Int
    var onUndo: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "drop.fill")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(TodayTone.water)
                .accessibilityHidden(true)
            Text("Added \(DailyStore.litres(ml))", comment: "Toast after logging water: Added 250 ml")
                .font(.ui(14.5, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            Spacer(minLength: 12)
            Button(action: onUndo) {
                Text("Undo")
                    .font(.ui(14.5, .semibold))
                    .foregroundStyle(DS.silver)
                    .padding(.horizontal, 14)
                    .frame(height: 32)
                    .background(Capsule().fill(DS.silver.opacity(0.10)))
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(String(localized: "Undo the last glass"))
        }
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .frame(height: 52)
        .frame(maxWidth: 440)
        .background(Capsule().fill(DS.surfaceRaised)
            .shadow(color: .black.opacity(scheme == .dark ? 0.4 : 0.12), radius: 18, y: 6))
        .overlay(Capsule().strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
    }
}

/// A short confirmation just above the tab bar, built like water's Undo
/// toast with nothing to tap: "Wind-down reminder set for 10:15 PM". The tab
/// clears it after a few seconds and announces the same words to VoiceOver.
struct TodayConfirmToast: View {
    var symbol: String
    var tint: Color
    var text: String

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(tint)
                .accessibilityHidden(true)
            Text(text)
                .font(.ui(14.5, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(minHeight: 52)
        .frame(maxWidth: 440)
        .background(Capsule().fill(DS.surfaceRaised)
            .shadow(color: .black.opacity(scheme == .dark ? 0.4 : 0.12), radius: 18, y: 6))
        .overlay(Capsule().strokeBorder(DS.silver.opacity(0.10), lineWidth: 1))
        .accessibilityElement(children: .combine)
    }
}

/// A note above the page's main content: the doctor's check, finishing the
/// plan, a reached target, the Apple Health invitation. Silver, so it never
/// reads as Train's recovery colours.
struct TodayNote: View {
    var symbol: String
    var title: String
    var lines: [String]
    var button: String? = nil
    /// Filled only when it is the page's one filled control.
    var prominent = true
    var action: (() -> Void)? = nil
    /// A close button that puts the note away for good.
    var onDismiss: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.85))
                .frame(width: 32, height: 32)
                .background(Circle().fill(DS.silver.opacity(0.08)))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)
                ForEach(lines, id: \.self) { line in
                    Text(line)
                        .font(.ui(13.5))
                        .foregroundStyle(DS.silver.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                }
                if let button, let action {
                    WideButton(title: button, prominent: prominent, fontSize: 15, verticalPadding: 12, cornerRadius: 12,
                               action: action)
                        .padding(.top, 6)
                }
            }
            Spacer(minLength: 0)
            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(DS.silver.opacity(0.55))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                // The 44-pt target reaches into the padding, not the text.
                .padding(.top, -10)
                .padding(.trailing, -10)
                .accessibilityLabel(String(localized: "Don't show again", comment: "Closes a Today note for good"))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(DS.surface))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
    }
}

/// The notes every layout carries: the doctor's check (the onboarding's own
/// card), finishing a plan begun before the plan questions existed, a
/// reached target, and the one-time invitation to connect Apple Health.
struct TodayNotices: View {
    var metrics: TodayMetrics
    var actions: TodayActions
    var showsTargetReached = true

    @Environment(AppleHealth.self) private var health
    @Environment(Purchases.self) private var purchases
    @AppStorage(TodayNotices.healthInviteKey) private var healthInviteDismissed = false
    @AppStorage(TodayNotices.goalInviteKey) private var goalInviteDismissed = false

    /// Set once the invitation is closed; Profile › Settings › Apple Health
    /// still connects later.
    static let healthInviteKey = "today.healthInvite.dismissed"
    /// Set once "No data from Apple Health" is closed; Progress › Overview
    /// still says where access is changed.
    static let healthEmptyKey = "today.healthEmpty.dismissed"

    /// Set once the goal photo invitation is closed; Progress › Body still
    /// has the goal.
    static let goalInviteKey = "today.goalInvite.dismissed"

    /// The owner's ask (2026-11-23): a new member is offered the goal photo
    /// on Today straight away. Until they have a goal or close it; never on
    /// top of finishing the plan, and only where a goal photo can be made.
    static func showsGoalInvite(_ metrics: TodayMetrics, dismissed: Bool) -> Bool {
        metrics.offersGoal && !dismissed && !metrics.needsPlan
    }

    /// Only before Health's sheet was ever shown, never on a device without
    /// Health, and not on top of finishing the plan.
    static func showsHealthInvite(_ metrics: TodayMetrics, dismissed: Bool) -> Bool {
        metrics.healthAccess == .notAsked && !dismissed && !metrics.needsPlan
    }

    var body: some View {
        if metrics.needsPlan {
            TodayNote(symbol: "sparkles", title: String(localized: "Finish your plan"),
                      lines: [String(localized: "A few new questions — age, daily activity, goal and health — turn your answers into calories, macros and safer exercise picks.")],
                      button: String(localized: "Answer the new questions"), action: actions.editProfile)
        }
        if !metrics.clearanceReasons.isEmpty {
            NoticeCard(title: String(localized: "Check with your doctor before you start"),
                       lines: metrics.clearanceReasons)
        }
        if showsTargetReached && metrics.targetReached {
            // Tinted: on a training day the session's button is the filled one.
            TodayNote(symbol: "flag.checkered", title: String(localized: "You reached your target"),
                      lines: [String(localized: "Your plan now eats what you burn. Set a new goal when you're ready.")],
                      button: String(localized: "Set a new goal"), prominent: false, action: actions.editProfile)
        }
        let showsGoalInvite = Self.showsGoalInvite(metrics, dismissed: goalInviteDismissed)
        if showsGoalInvite {
            // Tinted like the other offers: the session keeps the filled button.
            // "Free" only while it is: no plan, and the free photo not used.
            let free = !purchases.isPremium && AIService.shared.freeGoalPhotoUsed != true
            TodayNote(symbol: GoalInviteContent.symbol,
                      title: GoalInviteContent.title,
                      lines: GoalInviteContent.lines + (free ? [GoalInviteContent.freeLine] : []),
                      button: GoalInviteContent.button, prominent: false,
                      action: actions.openGoal,
                      onDismiss: { withAnimation(.easeOut(duration: 0.2)) { goalInviteDismissed = true } })
        }
        // One offer at a time for a new member: Apple Health's after the goal's.
        if !showsGoalInvite, Self.showsHealthInvite(metrics, dismissed: healthInviteDismissed) {
            // Tinted, never the page's filled control: an offer, not a task.
            TodayNote(symbol: "heart.text.square", title: HealthCopy.connectTitle,
                      lines: [HealthCopy.connectDetail],
                      button: String(localized: "Connect", comment: "Connects Apple Health from the Today note"),
                      prominent: false,
                      action: { Task { await health.connect() } },
                      onDismiss: { withAnimation(.easeOut(duration: 0.2)) { healthInviteDismissed = true } })
        }
    }
}

// MARK: - Rings

/// A ring with its symbol riding the stroke at 12 o'clock, as the Fitness
/// rings carry their arrows.
struct SymbolRing: View {
    var progress: Double
    var color: Color
    var size: CGFloat
    var lineWidth: CGFloat
    var symbol: String
    var dashedTrack = false

    var body: some View {
        ZStack {
            if dashedTrack {
                Circle()
                    .inset(by: lineWidth / 2)
                    .stroke(DS.silver.opacity(0.22), style: StrokeStyle(lineWidth: 1.5, dash: [2, 4]))
            } else {
                Ring(progress: progress, color: color, lineWidth: lineWidth)
                    .padding(lineWidth / 2)
            }
            Image(systemName: symbol)
                .font(.system(size: max(8, lineWidth * 0.62), weight: .bold))
                .foregroundStyle(progress > 0.03 && !dashedTrack ? Color.black.opacity(0.75) : color)
                .offset(y: -(size - lineWidth) / 2)
        }
        .frame(width: size, height: size)
    }
}

/// A 40pt ring with a symbol inside, and a check once the habit is done.
struct RingGlyph: View {
    var progress: Double
    var color: Color
    var symbol: String
    var done: Bool
    var dashed = false

    var body: some View {
        ZStack {
            if dashed {
                Circle()
                    .stroke(DS.silver.opacity(0.25), style: StrokeStyle(lineWidth: 2, dash: [2, 3.5]))
            } else {
                Ring(progress: progress, color: color, lineWidth: 4)
            }
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(dashed ? DS.silver.opacity(0.55) : color)
        }
        .padding(2)
        .frame(width: 42, height: 42)
        .overlay(alignment: .bottomTrailing) {
            if done {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(DS.silver, DS.ink)
                    .background(Circle().fill(DS.ink).padding(1))
                    .offset(x: 3, y: 3)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Session poster

/// An exercise's still, as the library shows it: the lifter on its white
/// studio card.
struct ExerciseStill: View {
    var name: String
    var size: CGFloat = 44
    var done = false

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: size * 0.25, style: .continuous)
        shape.fill(Color.white)
            .frame(width: size, height: size)
            .overlay(RenderSlot(id: ExerciseCatalog.exercise(named: name)?.slotID ?? "").clipShape(shape))
            .overlay(shape.strokeBorder(Color.black.opacity(0.06), lineWidth: 1))
            .overlay(alignment: .topTrailing) {
                if done {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.white, Color.black)
                        .offset(x: 4, y: -4)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(name)
            .accessibilityValue(done ? String(localized: "today.exercise.done", defaultValue: "Done",
                                              comment: "An exercise whose sets are all done, read by VoiceOver") : "")
    }
}

/// One capsule per planned set, done ones lit; a plain bar past 36 sets.
struct SegmentedSetBar: View {
    var done: Int
    var total: Int

    var body: some View {
        GeometryReader { geo in
            if total <= 36 {
                HStack(spacing: 3) {
                    ForEach(0..<max(total, 1), id: \.self) { index in
                        Capsule().fill(index < done ? TodayTone.workout : DS.silver.opacity(0.14))
                    }
                }
            } else {
                ZStack(alignment: .leading) {
                    Capsule().fill(DS.silver.opacity(0.14))
                    Capsule().fill(TodayTone.workout)
                        .frame(width: geo.size.width * Double(done) / Double(max(total, 1)))
                }
            }
        }
        .frame(height: 6)
        .accessibilityElement()
        .accessibilityLabel(total == 1 ? String(localized: "\(done) of 1 set done", comment: "Sets done today")
                                       : String(localized: "\(done) of \(total) sets done", comment: "Sets done today"))
    }
}

/// Today's session drawn on the body: the day's groups lit on the front and
/// back figures inside the onboarding hero's studio, the exercises' stills,
/// and the session's button. Full on training days, compact when there is
/// nothing to start (done, rest, still recovering).
struct SessionPoster: View {
    enum Style { case full, compact }

    var metrics: TodayMetrics
    var style: Style
    var eyebrow: String = String(localized: "Today's session")
    /// The page's one filled control is this poster's button.
    var isPrimary: Bool
    var showsWeek = true
    var actions: TodayActions

    /// A suggestion is planned on today, then Train opens; otherwise Train
    /// opens on what's there.
    private func action() {
        if metrics.state == .recommended {
            actions.startDay(metrics.posterGroups)
        } else {
            actions.openTrain()
        }
    }

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.bottom, 10)
            if style == .full {
                fullBody
            } else {
                compactBody
            }
            if showsWeek {
                Hairline(opacity: 0.08)
                    .padding(.top, 14)
                TodayWeekStrip(metrics: metrics)
                    .padding(.top, 12)
            }
        }
        .padding(16)
        .background(ground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
        .animation(.easeInOut(duration: 0.3), value: style)
    }

    // MARK: Ground

    private var ground: some View {
        ZStack {
            ViewportGround(inner: DS.viewportInner, outer: DS.viewportOuter,
                           rx: 0.60, ry: 0.80, cx: 0.74, cy: 0.40, stop: 1.0)
            if !metrics.posterGroups.isEmpty {
                RadialGlow(color: DS.activation.opacity((scheme == .dark ? 0.16 : 0.10) * (isLit ? 1 : 0.5)),
                           rx: 0.30, ry: 0.36, cx: 0.74, cy: style == .full ? 0.30 : 0.36)
            }
        }
    }

    // MARK: Pieces

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            TodayEyebrow(text: eyebrow)
            Spacer(minLength: 8)
            HStack(spacing: 5) {
                Image(systemName: statusSymbol)
                    .font(.system(size: 10, weight: .bold))
                TodayEyebrow(text: statusText, opacity: 0.8)
            }
            .foregroundStyle(DS.silver.opacity(0.8))
        }
    }

    private var fullBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(metrics.posterTitle)
                        .font(.ui(24, .bold))
                        .tracking(-0.5)
                        .foregroundStyle(DS.silver)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                    legend
                        .padding(.top, 10)
                    Text(meta)
                        .font(.ui(13, .medium))
                        .monospacedDigit()
                        .foregroundStyle(DS.silver.opacity(0.65))
                        .padding(.top, 10)
                }
                Spacer(minLength: 0)
                figures(height: 148)
            }
            if !metrics.posterExercises.isEmpty {
                stills
                    .padding(.top, 12)
            }
            if metrics.state == .inProgress {
                SegmentedSetBar(done: metrics.setsDone, total: metrics.setsPlanned)
                    .padding(.top, 12)
            }
            WideButton(title: buttonTitle, prominent: isPrimary, fontSize: 16, verticalPadding: 14, cornerRadius: 14,
                       action: action)
                .padding(.top, 14)
        }
    }

    private var compactBody: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(metrics.posterTitle)
                    .font(.ui(22, .bold))
                    .tracking(-0.4)
                    .foregroundStyle(DS.silver)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Text(compactDetail)
                    .font(.ui(13.5, .medium))
                    .foregroundStyle(DS.silver.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                QuickChip(title: buttonTitle, filled: isPrimary, action: action)
                    .padding(.top, 2)
            }
            Spacer(minLength: 0)
            figures(height: 112)
        }
    }

    private func figures(height: CGFloat) -> some View {
        let fills = Dictionary(uniqueKeysWithValues: metrics.posterGroups.flatMap(\.bodyRegions).map { ($0, litColor) })
        return BodyMapPair(source: .fills(front: fills, back: fills), figureHeight: height, showsCaptions: false)
            .accessibilityElement()
            .accessibilityLabel(metrics.posterGroups.map(\.title).formatted(.list(type: .and)))
    }

    /// Up to four groups as rows; more read as one wrapped line.
    @ViewBuilder
    private var legend: some View {
        let groups = metrics.posterGroups
        if groups.count <= 4 {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(groups, id: \.self) { group in
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(litColor)
                            .frame(width: 10, height: 10)
                        Text(group.title)
                            .font(.ui(15, .semibold))
                            .foregroundStyle(DS.silver)
                    }
                }
            }
        } else {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(litColor)
                    .frame(width: 10, height: 10)
                Text(groups.map(\.title).joined(separator: " · "))
                    .font(.ui(14, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var stills: some View {
        let exercises = metrics.posterExercises
        let shown = exercises.count > 6 ? Array(exercises.prefix(5)) : exercises
        return HStack(spacing: 8) {
            // By position: a name can repeat (Bulgarian Split Squat under
            // quads and glutes), and previews get new ids on every render.
            ForEach(Array(shown.enumerated()), id: \.offset) { _, exercise in
                ExerciseStill(name: exercise.exerciseName, size: 44,
                              done: exercise.isCompleted
                                  || (!exercise.sets.isEmpty && exercise.completedSets.count == exercise.sets.count))
            }
            if exercises.count > 6 {
                Text(verbatim: "+\(exercises.count - 5)")
                    .font(.ui(15, .semibold))
                    .foregroundStyle(DS.silver.opacity(0.8))
                    .frame(width: 44, height: 44)
                    .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(DS.silver.opacity(0.08)))
            }
        }
    }

    // MARK: Words

    /// Lit for what's on today; soft for next time or still recovering.
    private var isLit: Bool {
        switch metrics.state {
        case .recommended, .planned, .inProgress, .done: return true
        case .rest, .recovering: return false
        }
    }

    private var litColor: Color {
        isLit ? DS.activation : DS.activationSoft.opacity(0.5)
    }

    private var meta: String {
        TodayCount.session(exercises: metrics.posterExercises.count,
                           sets: metrics.posterExercises.reduce(0) { $0 + $1.sets.count })
    }

    private var compactDetail: String {
        switch metrics.state {
        case .done:
            let sets = TodayCount.sets(metrics.setsDone)
            // Apple Health's figure when a workout there covers the session,
            // with that workout's own length, in place of the estimate.
            if let minutes = metrics.sessionMinutesMeasured, let kcal = metrics.sessionKcalMeasured {
                return String(localized: "\(sets) · \(minutes) min · \(kcal) kcal above rest · Apple Health",
                              comment: "A finished workout with a workout in Apple Health (its length and energy); the first value is a count of sets: 18 sets · 48 min · 210 kcal above rest · Apple Health")
            }
            if let minutes = metrics.trainingMinutes, let kcal = metrics.trainingKcal {
                return String(localized: "\(sets) · about \(minutes) min · \(kcal) kcal above rest",
                              comment: "A finished workout; the first value is a count of sets: 18 sets · about 52 min · 140 kcal above rest")
            }
            return String(localized: "\(sets) done today.", comment: "A finished workout; the value is a count of sets: 18 sets done today.")
        case .rest:
            guard let next = metrics.recommendedDay else {
                return String(localized: "A walk still counts, and you can train any day.")
            }
            return String(localized: "Next up: \(TodayMetrics.dayName(next.name)). A walk still counts.",
                          comment: "Rest day: Next up: Push day. A walk still counts.")
        case .recovering:
            if let soonest = metrics.soonestReady {
                return String(localized: "\(soonest.group.title) will be ready in about \(soonest.hours) h.",
                              comment: "Nothing recovered yet: Back will be ready in about 14 h.")
            }
            return String(localized: "Your muscles are still recovering.")
        default:
            return meta
        }
    }

    private var statusText: String {
        switch metrics.state {
        case .recommended: return String(localized: "Recommended", comment: "Today's session state")
        case .planned: return MuscleCardState.planned.label
        case .inProgress: return MuscleCardState.inProgress.label
        case .done: return String(localized: "today.state.done", defaultValue: "Done",
                                  comment: "Today's workout state: finished (not the Done button)")
        case .rest: return String(localized: "Rest day", comment: "Today's session state")
        case .recovering: return MuscleCardState.recovering.label
        }
    }

    private var statusSymbol: String {
        switch metrics.state {
        case .recommended: return "sparkle"
        case .planned: return MuscleCardState.planned.symbol
        case .inProgress: return MuscleCardState.inProgress.symbol
        case .done: return "checkmark.circle.fill"
        case .rest: return "moon.zzz.fill"
        case .recovering: return "hourglass"
        }
    }

    private var buttonTitle: String {
        switch metrics.state {
        case .recommended:
            guard let day = metrics.posterDayName else { return String(localized: "Start workout") }
            return String(localized: "Start \(day)", comment: "Today's session button: Start Push day")
        case .planned: return String(localized: "Start workout")
        case .inProgress: return String(localized: "Continue workout")
        case .done: return String(localized: "See workout")
        case .rest: return String(localized: "Train anyway")
        case .recovering: return String(localized: "See what's ready")
        }
    }
}

// MARK: - Week

/// This week's days: trained filled, scheduled ringed, rest as a letter.
/// Silver, never Train's rhythm green.
struct TodayWeekStrip: View {
    var metrics: TodayMetrics

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            HStack(spacing: 5) {
                ForEach(metrics.week) { day in
                    dot(day)
                }
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 1) {
                Text(verbatim: "\(metrics.weekDone)/\(metrics.weekGoal)")
                    .font(.ui(15, .bold))
                    .monospacedDigit()
                    .foregroundStyle(DS.silver)
                TodayEyebrow(text: String(localized: "This week", comment: "Week strip: small capitals under this week's workouts, 2/4"),
                             size: 9.5)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Self.summary(metrics))
    }

    /// "2 of 4 workouts this week", or the count alone without a schedule.
    static func summary(_ metrics: TodayMetrics) -> String {
        if metrics.weekPlanned == 0 {
            return metrics.weekDone == 1 ? String(localized: "1 workout this week")
                : String(localized: "\(metrics.weekDone) workouts this week", comment: "Workouts done this week, no schedule")
        }
        return String(localized: "\(metrics.weekDone) of \(metrics.weekGoal) workouts this week",
                      comment: "Week strip: 2 of 4 workouts this week")
    }

    private func dot(_ day: TodayMetrics.WeekDay) -> some View {
        ZStack {
            if day.trained {
                Circle().fill(DS.silver)
            } else if day.scheduled {
                Circle().strokeBorder(DS.silver.opacity(day.isPast ? 0.22 : 0.6), lineWidth: 1.5)
            }
            Text(day.letter)
                .font(.mono(11, day.isToday ? .bold : .semibold))
                .foregroundStyle(day.trained ? DS.ink : DS.silver.opacity(day.scheduled ? 0.9 : 0.4))
        }
        .frame(width: 27, height: 27)
        .overlay(alignment: .bottom) {
            if day.isToday {
                Capsule().fill(DS.silver).frame(width: 5, height: 2).offset(y: 5)
            }
        }
    }
}

// MARK: - Macros

/// Protein, fat and carbs by their share of the day's calories.
struct TodayMacroBar: View {
    var protein: Int
    var fat: Int
    var carbs: Int
    var colors: (Color, Color, Color) = (DS.activation, DS.activationSoft, DS.silver.opacity(0.35))
    var height: CGFloat = 10

    var body: some View {
        let kcal = [Double(protein) * 4, Double(fat) * 9, Double(carbs) * 4]
        let total = max(kcal.reduce(0, +), 1)
        let tones = [colors.0, colors.1, colors.2]
        GeometryReader { geo in
            HStack(spacing: 3) {
                ForEach(0..<3, id: \.self) { index in
                    RoundedRectangle(cornerRadius: height / 2.5, style: .continuous)
                        .fill(tones[index])
                        .frame(width: max(0, (geo.size.width - 6) * kcal[index] / total))
                }
            }
        }
        .frame(height: height)
        .accessibilityHidden(true)
    }

    /// Each macro's share of the calories, in percent, adding up to 100
    /// (largest remainders get the leftover points).
    static func shares(protein: Int, fat: Int, carbs: Int) -> [Int] {
        let kcal = [Double(protein) * 4, Double(fat) * 9, Double(carbs) * 4]
        let total = kcal.reduce(0, +)
        guard total > 0 else { return [0, 0, 0] }
        let exact = kcal.map { $0 / total * 100 }
        var shares = exact.map { Int($0.rounded(.down)) }
        let order = exact.indices.sorted { exact[$0] - Double(shares[$0]) > exact[$1] - Double(shares[$1]) }
        for index in order.prefix(max(0, 100 - shares.reduce(0, +))) { shares[index] += 1 }
        return shares
    }
}

// MARK: - Weight trend

/// The last 30 days of weigh-ins and their 7-day average, in the display
/// unit, with the plan's pace ahead and the target when it is near.
struct WeightTrend {
    struct Point: Identifiable {
        let date: Date
        let value: Double
        /// Which unbroken stretch of the average this point belongs to: a
        /// week with no weigh-ins has no average, and the line breaks there.
        var run = 0
        var id: Date { date }
    }

    let weighIns: [Point]
    let average: [Point]
    let pace: [Point]
    let target: Double?
    /// The target is within 3 kg / 7 lb of the weigh-ins, so it is drawn.
    let targetInRange: Bool
    /// The lowest and highest values plotted, before padding.
    let dataLow: Double
    let dataHigh: Double
    let domain: ClosedRange<Double>
    let start: Date
    let today: Date
    let end: Date

    init?(daily: DailyStore, plan: NutritionPlan?, unit: WeightUnit, now: Date, days: Int = 30) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)
        guard let start = calendar.date(byAdding: .day, value: -(days - 1), to: today) else { return nil }
        let weighIns = daily.weights.filter { $0.date >= start }
            .map { Point(date: $0.date, value: unit.fromKilograms($0.kg)) }
        guard weighIns.count >= 3 else { return nil }
        var average: [Point] = []
        var run = 0, gap = false
        for offset in 0..<days {
            guard let day = calendar.date(byAdding: .day, value: offset, to: start) else { continue }
            let noon = day.addingTimeInterval(12 * 3600)
            if let kg = daily.trendWeight(at: noon) {
                if gap && !average.isEmpty { run += 1 }
                gap = false
                average.append(Point(date: noon, value: unit.fromKilograms(kg), run: run))
            } else {
                gap = true
            }
        }
        // The plan's pace runs two weeks on from today's average, and stops
        // at the target, where the plan switches to maintenance.
        var pace: [Point] = []
        if let plan, let targetKg = plan.targetWeightKg, plan.weeklyRate != 0, let last = average.last,
           calendar.isDate(last.date, inSameDayAs: today),
           let ahead = calendar.date(byAdding: .day, value: 14, to: last.date) {
            let goal = unit.fromKilograms(targetKg)
            let projected = last.value + unit.fromKilograms(plan.weeklyChangeKg) * 2
            let losing = plan.weeklyRate < 0
            if losing ? last.value > goal : last.value < goal {
                pace = [last, Point(date: ahead, value: losing ? max(projected, goal) : min(projected, goal), run: last.run)]
            }
        }
        let values = weighIns.map(\.value) + average.map(\.value) + pace.map(\.value)
        let low = values.min() ?? 0, high = values.max() ?? 0
        let target = plan?.targetWeightKg.map { unit.fromKilograms($0) }
        let reach = unit == .kg ? 3.0 : 7.0
        let inRange = target.map { $0 >= low - reach && $0 <= high + reach } ?? false
        let lower = min(low, inRange ? target ?? low : low), upper = max(high, inRange ? target ?? high : high)
        let pad = max((upper - lower) * 0.18, unit == .kg ? 0.4 : 1)
        self.weighIns = weighIns
        self.average = average
        self.pace = pace
        self.target = target
        targetInRange = inRange
        dataLow = low
        dataHigh = high
        domain = (lower - pad)...(upper + pad)
        self.start = start
        self.today = today.addingTimeInterval(12 * 3600)
        end = max(pace.last?.date ?? today, today.addingTimeInterval(24 * 3600))
    }
}

/// The trend as a static chart: no scrubbing, so it never catches the
/// page's scroll. Tapping the section opens the history instead.
struct WeightTrendChart: View {
    var trend: WeightTrend
    var tone: Color
    var unit: WeightUnit

    var body: some View {
        Chart {
            ForEach(trend.weighIns) { point in
                PointMark(x: .value("Day", point.date), y: .value("Weight", point.value))
                    .foregroundStyle(tone.opacity(0.35))
                    .symbolSize(16)
            }
            ForEach(trend.average) { point in
                LineMark(x: .value("Day", point.date), y: .value("Weight", point.value),
                         series: .value("Line", "average-\(point.run)"))
                    .foregroundStyle(tone)
                    .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.monotone)
            }
            ForEach(trend.pace) { point in
                LineMark(x: .value("Day", point.date), y: .value("Weight", point.value),
                         series: .value("Line", "pace"))
                    .foregroundStyle(tone.opacity(0.55))
                    .lineStyle(StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [4, 4]))
            }
            if let first = trend.pace.first, let end = trend.pace.last {
                PointMark(x: .value("Day", first.date.addingTimeInterval(end.date.timeIntervalSince(first.date) / 2)),
                          y: .value("Weight", (first.value + end.value) / 2))
                    .foregroundStyle(.clear)
                    .annotation(position: .bottom, alignment: .center, spacing: 6) {
                        chartLabel(String(localized: "Plan pace",
                                          comment: "Weight chart: label on the dashed line where the plan expects the weight to go over the next two weeks; short, shown in capitals"))
                    }
            }
            if let last = trend.average.last {
                PointMark(x: .value("Day", last.date), y: .value("Weight", last.value))
                    .foregroundStyle(tone)
                    .symbolSize(46)
            }
            if let target = trend.target, trend.targetInRange {
                RuleMark(y: .value("Target", target))
                    .foregroundStyle(DS.silver.opacity(0.35))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 3]))
                    .annotation(position: .top, alignment: .leading, spacing: 2) {
                        chartLabel(String(localized: "Target \(unit.bodyWeight(unit.toKilograms(target)))",
                                          comment: "Chart label: Target 71 kg"))
                    }
            }
        }
        .chartXScale(domain: trend.start...trend.end)
        .chartYScale(domain: trend.domain)
        .chartXAxis {
            AxisMarks(values: [trend.start, trend.today]) { value in
                let isStart = value.as(Date.self).map { $0 == trend.start } ?? false
                AxisValueLabel(anchor: isStart ? .topLeading : .top, collisionResolution: .disabled) {
                    if let date = value.as(Date.self) {
                        chartLabel(Calendar.current.isDate(date, inSameDayAs: trend.today)
                                   ? String(localized: "Today")
                                   : date.formatted(.dateTime.day().month(.abbreviated)))
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) { _ in
                AxisGridLine().foregroundStyle(DS.silver.opacity(0.07))
                AxisValueLabel().font(.mono(9.5, .medium)).foregroundStyle(DS.silver.opacity(0.55))
            }
        }
        .accessibilityElement()
        .accessibilityLabel(accessibilityText)
    }

    private func chartLabel(_ text: String) -> some View {
        Text(text)
            .font(.mono(9.5, .medium))
            .trackingEm(0.06, size: 9.5)
            .textCase(.uppercase)
            .foregroundStyle(DS.silver.opacity(0.6))
    }

    private var accessibilityText: String {
        guard let first = trend.average.first, let last = trend.average.last else { return "" }
        return String(localized: "Weight trend: 7-day average from \(unit.bodyWeight(unit.toKilograms(first.value))) to \(unit.bodyWeight(unit.toKilograms(last.value))).",
                      comment: "Weight chart for VoiceOver")
    }
}

/// A thin line of the last weigh-ins, for a small tile.
struct TrendSpark: View {
    var values: [Double]
    var tone: Color

    var body: some View {
        let low = (values.min() ?? 0) - 0.4, high = (values.max() ?? 0) + 0.4
        Chart {
            ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                LineMark(x: .value("Day", index), y: .value("Weight", value))
                    .foregroundStyle(tone)
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                    .interpolationMethod(.monotone)
            }
            if let last = values.last {
                PointMark(x: .value("Day", values.count - 1), y: .value("Weight", last))
                    .foregroundStyle(tone)
                    .symbolSize(24)
            }
        }
        .chartYScale(domain: low...high)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .accessibilityHidden(true)
    }
}

// MARK: - Apple Health

/// Seven days of steps, or seven nights of sleep, as bars against the goal
/// (dashed): the latest at full strength, the rest faded, a dot where
/// Health has nothing. Built like the water week's bars.
struct HealthWeekBars: View {
    var days: [TodayMetrics.HealthDay]
    var goal: Int
    var tone: Color

    var body: some View {
        let calendar = Calendar.current
        let goal = Double(max(goal, 1))
        GeometryReader { geo in
            let barHeight = geo.size.height - 14
            ZStack(alignment: .topLeading) {
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(days) { day in
                        let isLatest = day.id == days.last?.id
                        VStack(spacing: 0) {
                            Spacer(minLength: 0)
                            if let value = day.value, value > 0 {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(tone.opacity(isLatest ? 1 : 0.4))
                                    .frame(width: 10, height: max(4, barHeight * min(Double(value) / goal, 1.15) / 1.15))
                            } else {
                                Circle().fill(DS.silver.opacity(0.18)).frame(width: 4, height: 4)
                            }
                            Text(calendar.veryShortStandaloneWeekdaySymbols[calendar.component(.weekday, from: day.day) - 1])
                                .font(.mono(8.5, isLatest ? .bold : .semibold))
                                .foregroundStyle(DS.silver.opacity(isLatest ? 0.9 : 0.45))
                                .frame(height: 11)
                                .padding(.top, 3)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                Path { path in
                    let y = barHeight - barHeight / 1.15
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                }
                .stroke(DS.silver.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
            }
        }
        .accessibilityHidden(true)
    }
}

/// Today's active energy from Apple Health, beside the calorie target. For
/// reference only: the plan already counts daily activity (the steps, or
/// the onboarding answer), so adding this would count it twice.
struct ActiveEnergyNote: View {
    var kcal: Int
    /// One short line under it, for a half-width tile.
    var compact = false
    /// MUSQ's rough figure from today's steps, height and weight
    /// (`WalkSuggestion.walkingKcal`) where Apple Health has no active
    /// energy: labelled an estimate, and never added either.
    var fromSteps = false

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Image(systemName: fromSteps ? "figure.walk" : "flame")
                .font(.system(size: compact ? 10 : 11, weight: .semibold))
                .foregroundStyle(DS.silver.opacity(0.6))
            VStack(alignment: .leading, spacing: 2) {
                Group {
                    if fromSteps {
                        Text("Walking ≈ \(kcal.formatted()) kcal · estimate from steps",
                             comment: "Today's walking energy estimated from steps, beside the calorie target: Walking ≈ 180 kcal · estimate from steps")
                    } else {
                        Text("Active today · \(kcal.formatted()) kcal · Apple Health",
                             comment: "Today's active energy beside the calorie target: Active today · 420 kcal · Apple Health")
                    }
                }
                .font(.ui(compact ? 12 : 13, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
                Text(compact ? String(localized: "Not added to your target.", comment: "Active energy note, short")
                             : String(localized: "Not added to your target: the plan already counts your daily activity.",
                                      comment: "Active energy note under the calorie target"))
                    .font(.ui(compact ? 11.5 : 12.5))
                    .foregroundStyle(DS.silver.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

/// Apple Health's active energy when it has some, else the walking
/// estimate from today's steps, else nothing (see `TodayMetrics.showsEnergyNote`).
struct TodayEnergyNote: View {
    var metrics: TodayMetrics
    var compact = false

    var body: some View {
        if let kcal = metrics.shownActiveKcal {
            ActiveEnergyNote(kcal: kcal, compact: compact)
        } else if let kcal = metrics.shownWalkingKcal {
            ActiveEnergyNote(kcal: kcal, compact: compact, fromSteps: true)
        }
    }
}

/// Connected, but Health sent nothing: where to look, and the way there.
/// Closed for good with its ×, like the invitation.
struct TodayHealthEmptyNote: View {
    @AppStorage(TodayNotices.healthEmptyKey) private var dismissed = false

    var body: some View {
        if !dismissed {
            TodayNote(symbol: "heart.text.square", title: String(localized: "Apple Health", comment: "Today note title"),
                      lines: [HealthCopy.noData],
                      button: String(localized: "Open the Health app"), prominent: false,
                      action: { HealthCopy.openHealthApp() },
                      onDismiss: { withAnimation(.easeOut(duration: 0.2)) { dismissed = true } })
        }
    }
}

/// The words the steps and sleep pieces share.
enum TodayHealthText {
    static var opensProgress: String {
        String(localized: "Opens your trends in Progress", comment: "VoiceOver hint on Today's steps and sleep")
    }

    /// The steps pieces' hint: the walk log when every step today was added
    /// by hand (`TodayMetrics.stepsAllManual`), else Progress's trends.
    static func stepsHint(_ m: TodayMetrics) -> String {
        m.stepsAllManual
            ? String(localized: "Opens today's walks", comment: "VoiceOver hint on Today's steps when every step today was added by hand")
            : opensProgress
    }

    /// Under the steps tile's number (which carries the goal): "5.2 km ·
    /// Apple Health", or the source alone; with steps added by hand, how
    /// many of them (Health's distance leaves those out, so it goes).
    static func stepsCaption(_ m: TodayMetrics) -> String {
        if m.manualStepsToday > 0 {
            // Without Health, or with none from it today, they're all the user's.
            guard !m.stepsAllManual else {
                return String(localized: "Added by you", comment: "Steps caption: every step today was added by hand (Apple Health not connected, or none from it today)")
            }
            return String(localized: "Incl. \(HealthFormat.steps(m.manualStepsToday)) added · Apple Health",
                          comment: "Steps caption: today's steps include some the user added by hand, Incl. 2,000 added · Apple Health")
        }
        guard let km = m.distanceTodayKm else {
            return String(localized: "From Apple Health", comment: "Steps tile caption: the source")
        }
        return String(localized: "\(HealthFormat.distance(km: km)) · Apple Health",
                      comment: "Steps tile caption: today's walking distance and the source, 5.2 km · Apple Health")
    }

    /// Under the sleep tile's number: "Time asleep · Apple Health", or the
    /// goal when last night has nothing.
    static func sleepCaption(_ m: TodayMetrics) -> String {
        guard m.lastNightMinutes != nil else {
            return String(localized: "Goal \(HealthFormat.sleep(minutes: m.sleepGoalMinutes)) · Apple Health",
                          comment: "Sleep tile with nothing for last night: Goal 8 h · Apple Health")
        }
        return String(localized: "Time asleep · Apple Health", comment: "Sleep tile caption: time asleep (not in bed) and the source")
    }

    /// "Steps today: 8,240 of 8,000.", and how many were added by hand.
    static func stepsSpoken(_ m: TodayMetrics) -> String {
        let line = String(localized: "Steps today: \(HealthFormat.steps(m.stepsToday ?? 0)) of \(HealthFormat.steps(m.stepsGoal)).",
                          comment: "VoiceOver: today's steps against the goal")
        guard m.manualStepsToday > 0 else { return line }
        if m.stepsAllManual {
            return line + " " + String(localized: "All added by you.", comment: "VoiceOver, after today's steps: every step today was added by hand")
        }
        return line + " " + String(localized: "Including \(HealthFormat.steps(m.manualStepsToday)) you added.",
                                   comment: "VoiceOver, after today's steps: how many the user added by hand")
    }

    /// "Last night: 7 hours 12 minutes asleep. Goal 8 hours."
    static func sleepSpoken(_ m: TodayMetrics) -> String {
        let goal = HealthFormat.sleepSpoken(minutes: m.sleepGoalMinutes)
        guard let minutes = m.lastNightMinutes else {
            return String(localized: "Last night: no sleep recorded. Goal \(goal).", comment: "VoiceOver: no sleep for last night, and the goal")
        }
        return String(localized: "Last night: \(HealthFormat.sleepSpoken(minutes: minutes)) asleep. Goal \(goal).",
                      comment: "VoiceOver: last night's sleep against the goal")
    }
}

// MARK: - Reminders

/// The water target and both reminders in one place, for layouts that fold
/// them into a single row.
struct RemindersSheet: View {
    /// The profile's recommended water target, in millilitres.
    var recommended: Int

    @Environment(DailyStore.self) private var daily
    @Environment(\.dismiss) private var dismiss
    @State private var showsDenied = false

    var body: some View {
        @Bindable var daily = daily
        NavigationStack {
            Form {
                Section {
                    Stepper(value: Binding(get: { daily.waterTarget },
                                           set: { daily.waterTargetOverride = $0 == recommended ? nil : $0 }),
                            in: 1_000...5_000, step: 250) {
                        LabeledContent(String(localized: "Daily target"), value: DailyStore.litres(daily.waterTarget))
                    }
                    if daily.waterTargetOverride != nil && daily.waterTargetOverride != recommended {
                        Button(String(localized: "Use the recommended \(DailyStore.litres(recommended))",
                                      comment: "Resets the water target: Use the recommended 2.5 L")) {
                            daily.waterTargetOverride = nil
                        }
                    }
                } header: {
                    Text("Water", comment: "Settings section")
                } footer: {
                    Text("EFSA's adequate intake is about 2.0 L of water a day for women and 2.5 L for men, food included, and more in pregnancy and while breastfeeding. Training and heat add to it, so MUSQ sets that much as your drinks target. With a heart or kidney condition, ask your doctor: some need to limit fluids.")
                }
                Section {
                    Toggle(String(localized: "Water reminders"),
                           isOn: Binding(get: { daily.waterReminder.isOn }, set: { set(water: $0) }))
                    if daily.waterReminder.isOn {
                        Picker(String(localized: "From"), selection: $daily.waterReminder.startHour) {
                            ForEach(5...12, id: \.self) { Text(TodayView.hour($0)).tag($0) }
                        }
                        Picker(String(localized: "Until"), selection: $daily.waterReminder.endHour) {
                            ForEach(14...23, id: \.self) { Text(TodayView.hour($0)).tag($0) }
                        }
                        Picker(String(localized: "Every"), selection: $daily.waterReminder.everyHours) {
                            ForEach([1, 2, 3], id: \.self) {
                                Text(String(localized: "\($0) h", comment: "Reminder interval in hours: 2 h")).tag($0)
                            }
                        }
                    }
                } footer: {
                    Text("No reminders outside these hours, and none for the rest of the day once you reach your target.")
                }
                Section {
                    Toggle(String(localized: "Morning weigh-in"),
                           isOn: Binding(get: { daily.weighInReminder.isOn }, set: { set(weighIn: $0) }))
                    if daily.weighInReminder.isOn {
                        DatePicker(String(localized: "Time"), selection: weighInTime, displayedComponents: .hourAndMinute)
                    }
                } footer: {
                    if daily.notificationsDenied {
                        Text("Notifications are off for MUSQ in iOS Settings, so no reminders can arrive. Turn them on there.")
                    } else {
                        Text("Weigh in at the same time each day, ideally in the morning before breakfast.")
                    }
                }
            }
            .navigationTitle(String(localized: "Water & reminders"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
            .alert(String(localized: "Notifications are off"), isPresented: $showsDenied) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Turn on notifications for MUSQ in iOS Settings to get reminders.")
            }
        }
    }

    private var weighInTime: Binding<Date> {
        Binding(get: {
                    var parts = DateComponents()
                    parts.hour = daily.weighInReminder.hour
                    parts.minute = daily.weighInReminder.minute
                    return Calendar.current.date(from: parts) ?? Date()
                },
                set: { date in
                    let parts = Calendar.current.dateComponents([.hour, .minute], from: date)
                    daily.weighInReminder.hour = parts.hour ?? 7
                    daily.weighInReminder.minute = parts.minute ?? 0
                })
    }

    private func set(water isOn: Bool) {
        guard isOn else { daily.waterReminder.isOn = false; return }
        Task {
            if await daily.requestNotifications() { daily.waterReminder.isOn = true } else { showsDenied = true }
        }
    }

    private func set(weighIn isOn: Bool) {
        guard isOn else { daily.weighInReminder.isOn = false; return }
        Task {
            if await daily.requestNotifications() { daily.weighInReminder.isOn = true } else { showsDenied = true }
        }
    }
}
