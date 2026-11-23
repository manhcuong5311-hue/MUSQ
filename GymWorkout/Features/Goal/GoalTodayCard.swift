//
//  GoalTodayCard.swift
//  GymWorkout
//
//  The goal on Today (owner-approved 2026-11-23): the goal photo, the look
//  picked, how far along the estimate says the member is, how long is left
//  and this week's sessions, in one card that opens the Goal page. Three
//  looks for the owner to pick from, switched for screenshots with
//  `-goal.cardStyle bar|ring|banner`: A, a progress bar beside the photo;
//  B, a ring around it; C, a wide banner over it.
//
//  The pieces the Goal page shares live here too: the photo crop, the bar,
//  the ring, the week dots, the course tag, the words, and the type that
//  grows with Dynamic Type. And the words of Today's invitation for members
//  without a goal yet.
//
//  One accent: silver. Orange means muscles and stays out; red, yellow and
//  green mean recovery on Train and stay out too.
//

import SwiftUI
import UIKit

// MARK: - Which card

/// How the goal card on Today is drawn. The owner kept all three
/// (2026-11-23, "lâu lâu đổi lại giữa các kiểu này"): the card changes style
/// now and then, a new one each week in turn. `-goal.cardStyle ring` on the
/// command line pins one, for screenshots.
enum GoalCardStyle: String, CaseIterable, Identifiable {
    /// A: the photo beside the look, a progress bar, the time left and this
    /// week's dots.
    case bar
    /// B: a progress ring with the photo inside it, the numbers beside it.
    case ring
    /// C: a wide card over the photo, darkened and faded, the numbers on the
    /// fade.
    case banner

    static let storageKey = "goal.cardStyle"

    var id: String { rawValue }

    /// This week's style: the one pinned in the defaults (a launch argument),
    /// else the next in turn each calendar week.
    static func current(now: Date = Date(), calendar: Calendar = .current) -> GoalCardStyle {
        if let pinned = UserDefaults.standard.string(forKey: storageKey).flatMap(GoalCardStyle.init(rawValue:)) {
            return pinned
        }
        let week = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        let index = ((week.yearForWeekOfYear ?? 0) * 53 + (week.weekOfYear ?? 0)) % allCases.count
        return allCases[index]
    }

    var title: String {
        switch self {
        case .bar: return String(localized: "Bar", comment: "Goal card style on Today: a progress bar beside the photo")
        case .ring: return String(localized: "Ring", comment: "Goal card style on Today: a progress ring around the photo")
        case .banner: return String(localized: "Banner", comment: "Goal card style on Today: the numbers over the photo")
        }
    }
}

// MARK: - Card

/// The goal on Today, shown while `GoalStore.shared.hasGoal`: one button
/// that opens the Goal page.
struct GoalTodayCard: View {
    let progress: GoalProgress
    let photo: UIImage
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            Group {
                // Read on each render: Today redraws at midnight, so a new
                // week brings the next style.
                switch GoalCardStyle.current() {
                case .bar: GoalBarCard(progress: progress, photo: photo)
                case .ring: GoalRingCard(progress: progress, photo: photo)
                case .banner: GoalBannerCard(progress: progress, photo: photo)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.lift, radius: 20)
        .accessibilityLabel(GoalWords.spokenCard(progress))
        .accessibilityHint(String(localized: "Opens your goal page", comment: "VoiceOver hint on Today's goal card"))
    }
}

/// A: the photo as a portrait on the left; the look, the share with its
/// bar, the time left, the course and this week's dots on the right.
private struct GoalBarCard: View {
    let progress: GoalProgress
    let photo: UIImage

    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.dsLayout) private var layout

    var body: some View {
        let scale = typeSize.goalScale
        let lead = GoalWords.leadLine(progress)
        let paused = progress.course == .paused
        HStack(alignment: .top, spacing: 14) {
            GoalPhotoCrop(image: photo)
                .frame(width: layout.value(CGFloat(84), 100))
                .frame(minHeight: layout.value(CGFloat(112), 132), maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    TodayEyebrow(text: GoalWords.eyebrow, size: 10.5 * scale)
                    Spacer(minLength: 6)
                    GoalChevron()
                }
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    GoalLookTitle(look: progress.look, size: 17)
                        .foregroundStyle(DS.silver)
                    Spacer(minLength: 6)
                    if !paused {
                        GoalPercentValue(progress: progress, size: 22 * scale)
                    }
                }
                .padding(.top, 6)
                if GoalWords.isMeasured(progress) {
                    GoalMeter(value: GoalWords.shownFraction(progress), height: 6)
                        .padding(.top, 10)
                }
                if let lead {
                    Text(lead)
                        .goalFont(14, .semibold)
                        .foregroundStyle(DS.silver.opacity(0.88))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 12)
                }
                GoalStatusLine(course: progress.course)
                    .padding(.top, lead == nil ? 12 : 3)
                if !paused {
                    GoalWeekLine(week: progress.thisWeek)
                        .padding(.top, 12)
                }
            }
        }
        // The photo grows to the text's height, whatever the text size.
        .fixedSize(horizontal: false, vertical: true)
        .padding(16)
        .goalCard()
    }
}

/// B: the photo inside a progress ring, the numbers beside it. At the
/// largest text sizes the numbers go under the ring.
private struct GoalRingCard: View {
    let progress: GoalProgress
    let photo: UIImage

    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.dsLayout) private var layout

    var body: some View {
        let scale = typeSize.goalScale
        let lead = GoalWords.leadLine(progress)
        let paused = progress.course == .paused
        let side = layout.value(CGFloat(108), 124)
        let line: CGFloat = 5
        let stack = typeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 14))
            : AnyLayout(HStackLayout(alignment: .center, spacing: 16))
        stack {
            ZStack {
                GoalRing(value: GoalWords.shownFraction(progress), lineWidth: line)
                GoalPhotoCrop(image: photo, focus: UnitPoint(x: 0.5, y: 0.3))
                    .clipShape(Circle())
                    .padding(line + 5)
            }
            .frame(width: side, height: side)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    TodayEyebrow(text: GoalWords.eyebrow, size: 10.5 * scale)
                    Spacer(minLength: 6)
                    GoalChevron()
                }
                if !paused {
                    GoalShareLine(progress: progress, size: 30 * scale)
                        .padding(.top, 4)
                }
                GoalLookTitle(look: progress.look, size: paused ? 17 : 15)
                    .foregroundStyle(DS.silver.opacity(0.9))
                    .padding(.top, paused ? 6 : 2)
                if let lead {
                    Text(lead)
                        .goalFont(13.5, .medium)
                        .foregroundStyle(DS.silver.opacity(0.78))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 10)
                }
                GoalStatusLine(course: progress.course)
                    .padding(.top, lead == nil ? 10 : 2)
                if !paused {
                    GoalWeekLine(week: progress.thisWeek)
                        .padding(.top, 10)
                }
            }
        }
        .padding(16)
        .goalCard()
    }
}

/// C: the photo fills the right side, darkened, fading into the card;
/// the numbers sit on the fade.
private struct GoalBannerCard: View {
    let progress: GoalProgress
    let photo: UIImage

    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let scale = typeSize.goalScale
        GoalBannerLayout(textShare: 0.64, photoShare: 0.58, minHeight: 188 * min(scale, 1.2)) {
            photoLayer
            numbers(scale: scale)
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.white.opacity(0.9))
                .frame(width: 28, height: 28)
                .background(Circle().fill(Color.black.opacity(0.35)))
                .padding(12)
                .accessibilityHidden(true)
        }
        .goalCard()
    }

    /// Darker in the dark appearance; the fade is the card's own surface, so
    /// the numbers always sit on ground of the right polarity.
    private var photoLayer: some View {
        GoalPhotoCrop(image: photo, focus: UnitPoint(x: 0.5, y: 0.32))
            .overlay(Color.black.opacity(scheme == .dark ? 0.28 : 0.04))
            .overlay(LinearGradient(stops: [
                .init(color: DS.surface, location: 0),
                .init(color: DS.surface.opacity(0.8), location: 0.25),
                .init(color: DS.surface.opacity(0), location: 0.7)
            ], startPoint: .leading, endPoint: .trailing))
            .overlay(LinearGradient(colors: [DS.surface.opacity(0), DS.surface.opacity(0.55)],
                                    startPoint: UnitPoint(x: 0.5, y: 0.55), endPoint: .bottom))
    }

    private func numbers(scale: CGFloat) -> some View {
        let lead = GoalWords.leadLine(progress)
        let paused = progress.course == .paused
        return VStack(alignment: .leading, spacing: 0) {
            TodayEyebrow(text: GoalWords.eyebrow, size: 10.5 * scale)
            GoalLookTitle(look: progress.look, size: 20, weight: .bold)
                .tracking(-0.3)
                .foregroundStyle(DS.silver)
                .padding(.top, 6)
            if !paused {
                GoalShareLine(progress: progress, size: 34 * scale)
                    .padding(.top, 8)
            }
            if GoalWords.isMeasured(progress) {
                GoalMeter(value: GoalWords.shownFraction(progress), height: 5)
                    .padding(.top, 8)
            }
            if let lead {
                Text(lead)
                    .goalFont(14, .semibold)
                    .foregroundStyle(DS.silver.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 12)
            }
            GoalStatusLine(course: progress.course)
                .padding(.top, lead == nil ? 12 : 3)
            if !paused {
                GoalWeekLine(week: progress.thisWeek)
                    .padding(.top, 10)
            }
        }
        .padding(18)
    }
}

/// The banner's two layers: the photo on the trailing `photoShare` of the
/// width, full height; the numbers on the leading `textShare`, centred
/// down the card, which grows with them. A narrow card (an iPhone SE) gives
/// the numbers more of it.
private struct GoalBannerLayout: Layout {
    var textShare: CGFloat
    var photoShare: CGFloat
    var minHeight: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = Self.width(proposal)
        guard subviews.count == 2 else { return CGSize(width: width, height: minHeight) }
        let text = subviews[1].sizeThatFits(ProposedViewSize(width: textWidth(width), height: nil))
        return CGSize(width: width, height: max(minHeight, text.height))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count == 2 else { return }
        let narrow = bounds.width < 330
        let photoWidth = bounds.width * (narrow ? min(photoShare, 0.5) : photoShare)
        subviews[0].place(at: CGPoint(x: bounds.maxX - photoWidth, y: bounds.minY), anchor: .topLeading,
                          proposal: ProposedViewSize(width: photoWidth, height: bounds.height))
        let textProposal = ProposedViewSize(width: textWidth(bounds.width), height: nil)
        let text = subviews[1].sizeThatFits(textProposal)
        subviews[1].place(at: CGPoint(x: bounds.minX, y: bounds.minY + max(0, (bounds.height - text.height) / 2)),
                          anchor: .topLeading, proposal: textProposal)
    }

    private func textWidth(_ width: CGFloat) -> CGFloat {
        width * (width < 330 ? max(textShare, 0.72) : textShare)
    }

    /// The width offered, or a phone card's when none is.
    private static func width(_ proposal: ProposedViewSize) -> CGFloat {
        guard let width = proposal.width, width.isFinite else { return 350 }
        return width
    }
}

// MARK: - Card pieces

/// "34%" beside the look; a dash before anything can be measured (no
/// body-fat estimate yet), so nothing reads as 0%.
private struct GoalPercentValue: View {
    let progress: GoalProgress
    var size: CGFloat

    var body: some View {
        if GoalWords.isMeasured(progress) {
            GoalPercentFigure(percent: GoalWords.wholePercent(GoalWords.shownFraction(progress)), size: size)
        } else {
            BigValue(value: "–", size: size, color: DS.silver.opacity(0.35))
        }
    }
}

/// "34% of the way"; the percent alone where the words don't fit.
private struct GoalShareLine: View {
    let progress: GoalProgress
    var size: CGFloat

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                GoalPercentValue(progress: progress, size: size)
                if GoalWords.isMeasured(progress) {
                    Text(GoalWords.ofTheWay)
                        .goalFont(13, .medium)
                        .foregroundStyle(DS.silver.opacity(0.58))
                        .lineLimit(1)
                }
            }
            GoalPercentValue(progress: progress, size: size)
        }
    }
}

/// "●●○○ This week 2 of 4 sessions"; on a narrow card the dots and the
/// count, wrapping if even that is too wide.
private struct GoalWeekLine: View {
    let week: GoalProgress.Week?

    var body: some View {
        let done = week?.done ?? 0
        let planned = week?.planned ?? 0
        HStack(alignment: .center, spacing: 8) {
            if max(done, planned) > 0 {
                GoalWeekDots(done: done, planned: planned)
            }
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text(String(localized: "This week", comment: "Goal card: before the sessions done this week, This week 2 of 4 sessions"))
                        .goalFont(12.5, .medium)
                        .foregroundStyle(DS.silver.opacity(0.55))
                    count
                }
                .lineLimit(1)
                count
                    .lineLimit(1)
                count
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var count: some View {
        Text(GoalWords.weekCount(week))
            .goalFont(12.5, .semibold, digits: true)
            .foregroundStyle(DS.silver.opacity(0.9))
    }
}

private struct GoalChevron: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(DS.silver.opacity(0.35))
            .accessibilityHidden(true)
    }
}

// MARK: - Shared with the Goal page

/// The look's name: "Muscular · Athletic" on one line when it fits, else a
/// line for each part, so no line ever starts with the dot.
struct GoalLookTitle: View {
    let look: GoalLook
    var size: CGFloat
    var weight: Font.Weight = .semibold
    var design: Font.Design = .default

    var body: some View {
        let parts = [look.muscle == .same ? nil : look.muscle.title, look.fat == .same ? nil : look.fat.title]
            .compactMap { $0 }
        ViewThatFits(in: .horizontal) {
            Text(look.summary.isEmpty ? GoalWords.eyebrow : look.summary)
                .goalFont(size, weight, design: design)
                .lineLimit(1)
            VStack(alignment: .leading, spacing: 0) {
                ForEach(parts, id: \.self) { part in
                    Text(part)
                        .goalFont(size, weight, design: design)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(GoalWords.spokenLook(look))
    }
}

/// "34%": the number big, the sign small and close to it.
struct GoalPercentFigure: View {
    var percent: Int
    var size: CGFloat

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            Text(percent.formatted())
                .font(.ui(size, .bold))
                .tracking(-0.02 * size)
                .monospacedDigit()
                .foregroundStyle(DS.silver)
                .contentTransition(.numericText())
            Text(verbatim: "%")
                .font(.ui(max(12, (size * 0.5).rounded()), .semibold))
                .foregroundStyle(DS.silver.opacity(0.55))
        }
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel((Double(percent) / 100).formatted(.percent.precision(.fractionLength(0))))
    }
}

/// A photo cropped to fill its frame, keeping `focus` (a point of the photo,
/// in unit coordinates) as near the middle as the frame allows: the upper
/// middle by default, where the face and chest are. Hidden from VoiceOver
/// unless it has a label.
struct GoalPhotoCrop: View {
    let image: UIImage
    var focus = UnitPoint(x: 0.5, y: 0.35)
    var label: String? = nil

    var body: some View {
        GeometryReader { geo in
            let frame = geo.size
            let source = CGSize(width: max(image.size.width, 1), height: max(image.size.height, 1))
            let scale = max(frame.width / source.width, frame.height / source.height)
            let width = source.width * scale
            let height = source.height * scale
            Image(uiImage: image)
                .resizable()
                .interpolation(.high)
                .frame(width: width, height: height)
                .offset(x: min(0, max(frame.width - width, frame.width / 2 - focus.x * width)),
                        y: min(0, max(frame.height - height, frame.height / 2 - focus.y * height)))
        }
        .clipped()
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "")
        .accessibilityAddTraits(.isImage)
        .accessibilityHidden(label == nil)
    }
}

/// The goal's share as a bar: silver on a faint track. A sliver shows as a
/// dot rather than nothing; under half a percent (what reads as 0%), nothing.
struct GoalMeter: View {
    var value: Double
    var height: CGFloat = 6

    var body: some View {
        let shown = min(1, max(0, value))
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(DS.silver.opacity(0.12))
                Capsule().fill(DS.silver)
                    .frame(width: max(height, geo.size.width * shown))
                    .opacity(shown >= 0.005 ? 1 : 0)
            }
        }
        .frame(height: height)
        .animation(.easeOut(duration: 0.4), value: shown)
        .accessibilityHidden(true)
    }
}

/// The goal's share as a ring, drawn inside its frame.
struct GoalRing: View {
    var value: Double
    var lineWidth: CGFloat = 5

    var body: some View {
        let shown = min(1, max(0, value))
        ZStack {
            Circle().stroke(DS.silver.opacity(0.12), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0.001, shown))
                .stroke(DS.silver, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .opacity(shown >= 0.005 ? 1 : 0)
        }
        .padding(lineWidth / 2)
        .animation(.easeOut(duration: 0.4), value: shown)
        .accessibilityHidden(true)
    }
}

/// One dot per planned session this week, filled once done; sessions past
/// the plan add filled dots.
struct GoalWeekDots: View {
    var done: Int
    var planned: Int
    var size: CGFloat = 8

    var body: some View {
        let count = min(7, max(planned, done))
        HStack(spacing: size * 0.55) {
            ForEach(0..<count, id: \.self) { index in
                ZStack {
                    if index < done {
                        Circle().fill(DS.silver)
                    } else {
                        Circle().strokeBorder(DS.silver.opacity(0.35), lineWidth: 1.2)
                    }
                }
                .frame(width: size, height: size)
            }
        }
        .accessibilityHidden(true)
    }
}

/// The course's line with its symbol: "✓ On course".
struct GoalStatusLine: View {
    var course: GoalProgress.Course
    var size: CGFloat = 12.5

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            Image(systemName: GoalWords.statusSymbol(course))
                .goalFont(size - 1, .semibold)
                .accessibilityHidden(true)
            Text(GoalWords.status(course))
                .goalFont(size, .medium)
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundStyle(DS.silver.opacity(0.62))
    }
}

/// A small outlined tag: "ON COURSE". A label, never a control.
struct GoalTag: View {
    var text: String

    var body: some View {
        Text(text)
            .goalFont(9.5, .semibold, design: .monospaced)
            .trackingEm(0.08, size: 9.5)
            .textCase(.uppercase)
            .lineLimit(1)
            .foregroundStyle(DS.silver.opacity(0.8))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.28), lineWidth: 1))
    }
}

// MARK: - Words

/// The words the goal's pieces share, on Today and the Goal page.
enum GoalWords {
    /// "Goal physique", the card's eyebrow: on the Dial layout the plan's
    /// weight card is already headed "Your goal".
    static var eyebrow: String {
        String(localized: "Goal physique", comment: "Eyebrow over the goal card on Today: the body the goal photo shows")
    }

    /// "of the way", after the share: "34% of the way".
    static var ofTheWay: String {
        String(localized: "of the way", comment: "After the share of the goal reached: 34% of the way")
    }

    /// A share needs the body-fat estimate: without it nothing is measured.
    /// Nor while the goal is paused: there's no countdown then.
    static func isMeasured(_ progress: GoalProgress) -> Bool {
        progress.course != .paused && (progress.fatFraction != nil || progress.muscleFraction != nil)
    }

    /// The share shown: all of it once the estimate has reached the goal
    /// (it counts as reached from 98%).
    static func shownFraction(_ progress: GoalProgress) -> Double {
        progress.course == .reached ? 1 : min(1, max(0, progress.fraction))
    }

    /// 0...100, whole.
    static func wholePercent(_ fraction: Double) -> Int {
        Int((min(1, max(0, fraction)) * 100).rounded())
    }

    /// "34%".
    static func percent(_ fraction: Double) -> String {
        (Double(wholePercent(fraction)) / 100).formatted(.percent.precision(.fractionLength(0)))
    }

    /// "18%", "18.4%": body fat to a tenth at most.
    static func bodyFat(_ percent: Double) -> String {
        (percent / 100).formatted(.percent.precision(.fractionLength(0...1)))
    }

    /// "About 14 weeks to go"; nil when no date can be said (no training
    /// days, too few sessions, nothing measured, paused) or the goal is
    /// reached.
    static func toGo(_ progress: GoalProgress) -> String? {
        guard let weeks = progress.weeksLeft, weeks > 0 else { return nil }
        switch progress.course {
        case .starting, .onTrack, .behind:
            return sentence(String(localized: "\(GoalProgress.timeLeft(weeks: weeks)) to go",
                                   comment: "Time left to the goal; the value is a phrase such as about 14 weeks, about 5 months or over 2 years"))
        case .offTrack, .noSchedule, .reached, .paused:
            return nil
        }
    }

    /// The cards' line under the look: the time left, or without a body-fat
    /// estimate, what measuring needs. Nil when the course line says it all
    /// (paused among them).
    static func leadLine(_ progress: GoalProgress) -> String? {
        if progress.course == .paused { return nil }
        if isMeasured(progress) { return toGo(progress) }
        return progress.bodyFatPercent == nil ? unmeasured : nil
    }

    /// The first week with no session logged yet: nothing to count yet, so
    /// no 0%.
    static func noSessionYet(_ progress: GoalProgress) -> Bool {
        progress.course == .starting && progress.consistency == 0
    }

    /// On Today's card while there's no body-fat estimate to measure with.
    static var unmeasured: String {
        String(localized: "Add your body-fat % to track progress",
               comment: "Goal card on Today without a body-fat estimate; it's entered in Edit Profile")
    }

    /// The course in one line. The first week never says "On course": the
    /// estimate then only assumes the plan is kept.
    static func status(_ course: GoalProgress.Course) -> String {
        switch course {
        case .starting:
            return String(localized: "First week", comment: "Goal status line in the goal's first week")
        case .onTrack:
            return String(localized: "On course", comment: "Goal status line")
        case .behind:
            return String(localized: "Behind: every session counts", comment: "Goal status line")
        case .offTrack:
            return String(localized: "At this rate your goal is hard to reach", comment: "Goal status line")
        case .noSchedule:
            return String(localized: "Set your training days to stay on course", comment: "Goal status line")
        case .reached:
            return String(localized: "Goal reached by the estimate", comment: "Goal status line")
        case .paused:
            return String(localized: "Paused while your plan is on hold",
                          comment: "Goal status line while the plan is set to stay fit (pregnancy, after birth, under 19 or underweight)")
        }
    }

    static func statusSymbol(_ course: GoalProgress.Course) -> String {
        switch course {
        case .starting: return "sunrise"
        case .onTrack: return "checkmark.circle"
        case .behind: return "arrow.down.right.circle"
        case .offTrack: return "exclamationmark.circle"
        case .noSchedule: return "calendar"
        case .reached: return "flag.checkered"
        case .paused: return "pause.circle"
        }
    }

    /// The course as a short tag: "On course" (shown in capitals).
    static func tag(_ course: GoalProgress.Course) -> String {
        switch course {
        case .starting:
            return String(localized: "First week",
                          comment: "Goal course tag: the goal's first week. A small tag in capitals beside a section title: keep it short")
        case .onTrack:
            return String(localized: "On course",
                          comment: "Goal course tag. A small tag in capitals beside a section title: keep it short")
        case .behind:
            return String(localized: "Behind",
                          comment: "Goal course tag: fewer sessions than planned. A small tag in capitals beside a section title: keep it short")
        case .offTrack:
            return String(localized: "Off course",
                          comment: "Goal course tag: so few sessions the goal is hard to reach. A small tag in capitals beside a section title: keep it short")
        case .noSchedule:
            return String(localized: "No training days",
                          comment: "Goal course tag. A small tag in capitals beside a section title: keep it short")
        case .reached:
            return String(localized: "Reached",
                          comment: "Goal course tag: the goal is reached. A small tag in capitals beside a section title: keep it short")
        case .paused:
            return String(localized: "Paused",
                          comment: "Goal course tag: the plan is on hold. A small tag in capitals beside a section title: keep it short")
        }
    }

    /// "2 of 4 sessions" this week, out of the week's goal (the plan, or the
    /// sessions done when they're more: never "4 of 3"); "2 sessions"
    /// without training days.
    static func weekCount(_ week: GoalProgress.Week?) -> String {
        let done = week?.done ?? 0
        guard let week, week.planned > 0 else { return sessions(done) }
        return week.goal == 1
            ? String(localized: "\(done) of 1 session", comment: "Goal: sessions done this week of a goal of one, e.g. 0 of 1 session")
            : String(localized: "\(done) of \(week.goal) sessions", comment: "Goal: sessions done this week of the week's goal, e.g. 2 of 4 sessions")
    }

    /// "1 session", "3 sessions".
    static func sessions(_ count: Int) -> String {
        count == 1 ? String(localized: "1 session", comment: "Goal: a count of training sessions")
            : String(localized: "\(count) sessions", comment: "Goal: a count of training sessions")
    }

    /// "Muscular and Athletic", for VoiceOver (the summary's dot reads badly).
    static func spokenLook(_ look: GoalLook) -> String {
        [look.muscle == .same ? nil : look.muscle.title, look.fat == .same ? nil : look.fat.title]
            .compactMap { $0 }
            .formatted(.list(type: .and))
    }

    /// "This week, 2 of 4 sessions done", out of the week's goal.
    static func spokenWeek(_ week: GoalProgress.Week?) -> String {
        let done = week?.done ?? 0
        guard let week, week.planned > 0 else {
            return String(localized: "This week, \(sessions(done))",
                          comment: "VoiceOver: goal sessions this week without training days; the value is a count such as 2 sessions")
        }
        return week.goal == 1
            ? String(localized: "This week, \(done) of 1 session done",
                     comment: "VoiceOver: goal sessions this week, done of a goal of one")
            : String(localized: "This week, \(done) of \(week.goal) sessions done",
                     comment: "VoiceOver: goal sessions this week, done of the week's goal")
    }

    /// The whole card in one sentence for VoiceOver.
    static func spokenCard(_ progress: GoalProgress) -> String {
        var parts = [String(localized: "Goal physique: \(spokenLook(progress.look))",
                            comment: "VoiceOver, Today's goal card; the value is the look, e.g. Muscular and Athletic")]
        if isMeasured(progress) {
            parts.append(String(localized: "\(percent(shownFraction(progress))) of the way",
                                comment: "VoiceOver: the share of the goal reached, e.g. 34% of the way"))
        }
        if let lead = leadLine(progress) { parts.append(lead) }
        parts.append(status(progress.course))
        if progress.course != .paused { parts.append(spokenWeek(progress.thisWeek)) }
        return parts.joined(separator: ". ")
    }

    /// The first letter in capitals: "about 14 weeks to go" → "About 14 weeks to go".
    static func sentence(_ text: String) -> String {
        guard let first = text.first else { return text }
        return first.uppercased() + text.dropFirst()
    }
}

// MARK: - Invitation

/// The words of Today's invitation for a member without a goal yet (a
/// `TodayNote`, tinted: an offer, never the page's filled control).
struct GoalInviteContent {
    static let symbol = "figure.strengthtraining.traditional"

    static var title: String {
        String(localized: "See your goal physique", comment: "Today invitation to make a goal photo")
    }

    static var lines: [String] {
        [String(localized: "Upload a photo, pick the muscle and body fat you want, and see yourself there, with your own face.",
                comment: "Today invitation to make a goal photo")]
    }

    /// Added under `lines` while the member's free goal photo is unused.
    static var freeLine: String {
        String(localized: "Your first one is free.", comment: "Today invitation: the first goal photo costs nothing")
    }

    static var button: String {
        String(localized: "Create my goal photo", comment: "Today invitation's button")
    }
}

// MARK: - Type and ground

extension DynamicTypeSize {
    /// How much the goal's type grows with the reader's text size: as body
    /// text does up to xxxLarge, then more slowly, capped so the cards keep
    /// their shape. 1 at the default size, so it looks as designed there.
    var goalScale: CGFloat {
        switch self {
        case .xSmall: return 0.88
        case .small: return 0.92
        case .medium: return 0.96
        case .large: return 1
        case .xLarge: return 1.1
        case .xxLarge: return 1.2
        case .xxxLarge: return 1.3
        case .accessibility1: return 1.4
        case .accessibility2: return 1.48
        default: return 1.55
        }
    }
}

extension View {
    /// The app's type (`Font.ui`, or `Font.mono` with `.monospaced`) grown
    /// with Dynamic Type (`DynamicTypeSize.goalScale`). `digits` keeps
    /// numbers from jumping as they change.
    func goalFont(_ size: CGFloat, _ weight: Font.Weight = .regular, design: Font.Design = .default,
                  digits: Bool = false) -> some View {
        modifier(GoalFontModifier(size: size, weight: weight, design: design, digits: digits))
    }

    /// The goal's card: the raised surface, rounded, with a hairline edge and
    /// a soft shadow on the light ground. Clips what's inside, photos too.
    func goalCard(radius: CGFloat = 20) -> some View {
        modifier(GoalCardGround(radius: radius))
    }
}

private struct GoalFontModifier: ViewModifier {
    var size: CGFloat
    var weight: Font.Weight
    var design: Font.Design
    var digits: Bool

    @Environment(\.dynamicTypeSize) private var typeSize

    func body(content: Content) -> some View {
        let font = Font.system(size: size * typeSize.goalScale, weight: weight, design: design)
        content.font(digits ? font.monospacedDigit() : font)
    }
}

private struct GoalCardGround: ViewModifier {
    var radius: CGFloat

    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DS.surface)
            .clipShape(shape)
            .background(shape.fill(DS.surface)
                .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.05), radius: 16, y: 6))
            .overlay(shape.strokeBorder(DS.silver.opacity(scheme == .dark ? 0.08 : 0.05), lineWidth: 1))
    }
}
