//
//  BalanceCard.swift
//  GymWorkout
//
//  Balance on Today (owner-approved 2026-11-22): Train, Eat and Sleep over
//  the last 7 days in one card, in the style the user picked in Settings —
//  A bars, B triangle, C a ring in three parts. The triangle and the ring
//  need all three pillars scored and fall back to the bars otherwise.
//
//  - The number is silver, neutral; pillar colours sit only on each
//    pillar's own marks. Never red, yellow or green, which mean recovery
//    on Train.
//  - A pillar with nothing to score shows a dashed track, "Not tracked"
//    and one invitation, never a 0.
//  - Eat and Sleep keep a chip for today's check-in or "Slept about…"
//    while today has none, scored or not, in every style: on the pillar's
//    row in the bars, in one line under the triangle and the ring. One chip
//    a pillar at most, never the same as the footer's.
//  - Balance needs two scored pillars ("2 of 3"); with fewer the card shows
//    the pillars and their invitations without a number.
//  - The lowest pillar carries "Your lever", and the card ends on one line
//    with one button for it. The goal's result sits beside the number as a
//    chip, never part of it. A paused week says "Paused".
//

import SwiftUI

// MARK: - Shared pieces

/// What the Balance views share: the pillar colours, the captions and each
/// pillar's one chip (today's log, or how scoring starts).
enum BalanceKit {

    /// A pillar's identity colour, only ever on its own marks.
    static func color(_ pillar: BalancePillar) -> Color {
        switch pillar {
        case .train: return BalanceTone.train
        case .eat: return BalanceTone.eat
        case .sleep: return BalanceTone.sleep
        }
    }

    /// Train's score is held back in a paused week, though the pillar is
    /// otherwise "scored".
    static func isPausedTrain(_ score: PillarScore, paused: Bool) -> Bool {
        paused && score.pillar == .train && score.score == nil
    }

    /// The line under a pillar's track.
    static func caption(_ score: PillarScore, paused: Bool) -> String {
        if isPausedTrain(score, paused: paused) {
            return String(localized: "Paused this week", comment: "Balance: Train while the week is paused")
        }
        switch score.status {
        case .scored, .needsMore: return score.summary
        case .notTracked: return String(localized: "Not tracked", comment: "Balance: a pillar with no data")
        case .off:
            // Eat still on in Settings but with nothing it may score (kidney
            // disease and calorie numbers hidden): not the user's off switch.
            if score.pillar == .eat && BalanceSettings.shared.scoresEat {
                return String(localized: "Nothing to score", comment: "Balance: Eat with neither protein nor calories scored")
            }
            return String(localized: "Off in Settings", comment: "Balance: a pillar the user stopped scoring")
        }
    }

    /// A pillar's one way in. Today's eating check-in and "Slept about…" are
    /// offered while today has none, whatever the pillar's status
    /// (`BalanceScore.todayInvitation`), so a pillar scored from them keeps
    /// its way in; a pillar with no score yet says how scoring starts. Sleep
    /// with nothing to estimate offers Apple Health until it's connected.
    /// Nil for a pillar that's off, and for Train (always scored).
    ///
    /// - eveningOnly: Today's card holds a scored Eat's check-in until the
    ///   evening (17:00, or the check-in reminder's hour if earlier), so
    ///   someone who logs meals isn't asked in the morning; the sheet offers
    ///   it at any hour.
    static func invitation(for score: PillarScore, today input: BalanceInputs?, health: AppleHealth?,
                           eveningOnly: Bool = false) -> BalanceAction? {
        if score.status == .off { return nil }
        let scored = score.status == .scored
        let offer = input.flatMap { BalanceScore.todayInvitation($0, pillar: score.pillar) }
        switch score.pillar {
        case .train:
            return nil
        case .eat:
            guard let offer, let input else { return nil }
            guard scored else {
                return BalanceAction(pillar: .eat,
                                     text: String(localized: "Two taps each evening: how protein went, and eating against your plan."),
                                     kind: offer.kind)
            }
            if eveningOnly {
                let reminder = input.daily.checkInReminder
                let from = reminder.isOn ? min(17, reminder.hour) : 17
                if input.calendar.component(.hour, from: input.now) < from { return nil }
            }
            return offer
        case .sleep:
            if let offer {
                return scored ? offer
                    : BalanceAction(pillar: .sleep,
                                    text: String(localized: "Tap about how long you slept each morning, or connect Apple Health."),
                                    kind: offer.kind)
            }
            guard !scored, let health, health.access == .notAsked else { return nil }
            return BalanceAction(pillar: .sleep,
                                 text: String(localized: "Connect Apple Health to score sleep from your Watch or iPhone."),
                                 kind: .connectHealth)
        }
    }

    /// VoiceOver for one pillar: "Sleep, 64 of 100. 6 h 12 a night. Your lever."
    static func spoken(_ score: PillarScore, isLever: Bool, paused: Bool) -> String {
        var parts: [String] = []
        if let value = score.score {
            parts.append(String(localized: "\(score.pillar.title), \(value) of 100", comment: "Balance, VoiceOver: a pillar's score"))
        } else {
            parts.append(score.pillar.title)
        }
        parts.append(caption(score, paused: paused))
        if isLever {
            parts.append(String(localized: "Your lever", comment: "Balance: the pillar that moves the score most"))
        }
        return parts.joined(separator: ". ")
    }

    /// "Balance 72, On track. 3 of 3 tracked."
    static func spokenHeadline(_ balance: Balance) -> String {
        if balance.paused {
            return String(localized: "Balance paused this week.", comment: "Balance, VoiceOver")
        }
        guard let score = balance.score, let word = balance.word else {
            return String(localized: "Balance: \(balance.coverage) tracked. It shows from two.",
                          comment: "Balance, VoiceOver: no number yet; the value is like 1 of 3")
        }
        return String(localized: "Balance \(score), \(word). \(balance.coverage) tracked.",
                      comment: "Balance, VoiceOver: Balance 72, On track. 3 of 3 tracked.")
    }
}

/// "Your lever": the pillar that moves Balance most. Silver, a label.
struct BalanceLeverCapsule: View {
    var body: some View {
        Text("Your lever", comment: "Balance: the pillar that moves the score most")
            .font(.mono(8.5, .bold))
            .trackingEm(0.08, size: 8.5)
            .textCase(.uppercase)
            .foregroundStyle(DS.silver.opacity(0.85))
            .lineLimit(1)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Capsule().fill(DS.silver.opacity(0.08)))
            .overlay(Capsule().strokeBorder(DS.silver.opacity(0.28), lineWidth: 1))
            .fixedSize()
    }
}

/// Where the goal stands, beside the number: the weigh-in violet, so it
/// reads as the result, never as a pillar.
struct BalanceResultChip: View {
    let result: BalanceResult

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 10.5, weight: .bold))
                .foregroundStyle(TodayTone.violet)
                .accessibilityHidden(true)
            Text(result.text)
                .font(.ui(12.5, .semibold))
                .monospacedDigit()
                .foregroundStyle(DS.silver.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(TodayTone.violet.opacity(0.13)))
        .overlay(Capsule().strokeBorder(TodayTone.violet.opacity(0.32), lineWidth: 1))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(localized: "Result: \(result.text)", comment: "Balance, VoiceOver: the goal's result chip"))
    }
}

/// A pillar's track: filled to the score in the pillar's colour, or dashed
/// when there is no score (with the days collected so far, if any).
struct BalanceTrack: View {
    let score: PillarScore
    var height: CGFloat = 6

    var body: some View {
        let tone = BalanceKit.color(score.pillar)
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                if let value = score.score {
                    Capsule().fill(tone.opacity(0.16))
                    Capsule().fill(tone)
                        .frame(width: max(height, geo.size.width * min(1, Double(value) / 100)))
                } else {
                    Capsule().strokeBorder(DS.silver.opacity(0.26), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    if case .needsMore(let have, let need) = score.status, need > 0, have > 0 {
                        Capsule().fill(tone.opacity(0.3))
                            .frame(width: max(height, geo.size.width * min(1, Double(have) / Double(need))))
                    }
                }
            }
        }
        .frame(height: height)
        .accessibilityHidden(true)
    }
}

// MARK: - Card

struct BalanceCard: View {
    let balance: Balance
    let onAction: (BalanceAction) -> Void
    let onOpen: () -> Void

    @Environment(\.dsLayout) private var layout
    /// Optional so the card still draws where a preview leaves them out;
    /// they only decide which of today's logs are still to do.
    @Environment(DailyStore.self) private var daily: DailyStore?
    @Environment(AppleHealth.self) private var health: AppleHealth?
    @Environment(WorkoutStore.self) private var store: WorkoutStore?

    /// The triangle and the ring need all three scored.
    private var style: BalanceStyle {
        let picked = BalanceSettings.shared.style
        return picked != .bars && balance.scored.count < 3 ? .bars : picked
    }

    var body: some View {
        let chips = offers()
        VStack(alignment: .leading, spacing: 0) {
            header
            switch style {
            case .bars: barsBody(chips)
            case .triangle: triangleBody(chips)
            case .ring: ringBody(chips)
            }
            footer
        }
        .padding(layout.value(16, 18))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(DS.surface))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
        .accessibilityElement(children: .contain)
    }

    // MARK: Header

    private var header: some View {
        Button(action: onOpen) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                TodayEyebrow(text: String(localized: "Balance", comment: "Balance card eyebrow"))
                Spacer(minLength: 8)
                TodayEyebrow(text: meta, size: 9.5, opacity: 0.45)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.4))
            }
            .frame(minHeight: 30)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(String(localized: "Balance, \(meta)", comment: "Balance card header, VoiceOver: Balance, Last 7 days · 2 of 3"))
        .accessibilityHint(String(localized: "Opens what's behind your Balance", comment: "Balance card, VoiceOver hint"))
        .accessibilityAddTraits(.isHeader)
    }

    private var meta: String {
        if balance.paused { return String(localized: "Paused", comment: "Balance: the week is left out") }
        return String(localized: "Last 7 days · \(balance.coverage)", comment: "Balance card meta: Last 7 days · 2 of 3")
    }

    // MARK: Headline

    private var numberSize: CGFloat { layout.value(40, 44) }

    /// The number and its word, "Paused", or why there's no number yet.
    @ViewBuilder
    private func headline(showsResult: Bool) -> some View {
        if balance.paused {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .accessibilityHidden(true)
                    Text("Paused", comment: "Balance: the week is left out")
                        .font(.ui(24, .bold))
                        .tracking(-0.4)
                        .foregroundStyle(DS.silver)
                }
                Text("This week is left out of your Balance. Resume it in the details.")
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityElement(children: .combine)
        } else if let score = balance.score, let word = balance.word {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    BigValue(value: score.formatted(), size: numberSize)
                    Text(word)
                        .font(.ui(layout.value(17, 18), .semibold))
                        .foregroundStyle(DS.silver.opacity(0.75))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(BalanceKit.spokenHeadline(balance))
                if showsResult, let result = balance.result {
                    BalanceResultChip(result: result)
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 4) {
                Text("Track one more to see your Balance")
                    .font(.ui(17, .semibold))
                    .foregroundStyle(DS.silver)
                    .fixedSize(horizontal: false, vertical: true)
                Text("It needs two of Train, Eat and Sleep scored.")
                    .font(.ui(13))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityElement(children: .combine)
        }
    }

    // MARK: Chips

    /// The footer's action: the lever's, once there's a number.
    private var footerAction: BalanceAction? {
        !balance.paused && balance.score != nil ? balance.action : nil
    }

    /// Each pillar's chip (`BalanceKit.invitation`), left out when the
    /// footer already offers the same, so a pillar never has two.
    private func offers() -> [BalancePillar: BalanceAction] {
        let input = BalanceBuilder.todayInputs(store: store, daily: daily, health: health)
        let lever = footerAction
        var chips: [BalancePillar: BalanceAction] = [:]
        for score in balance.pillars {
            guard let offer = BalanceKit.invitation(for: score, today: input, health: health, eveningOnly: true),
                  offer.buttonTitle != nil,
                  !(lever?.pillar == offer.pillar && lever?.kind == offer.kind) else { continue }
            chips[score.pillar] = offer
        }
        return chips
    }

    /// The triangle and the ring have no row for each pillar, so their
    /// chips share one line under the figure, each with its pillar's symbol.
    @ViewBuilder
    private func offerLine(_ offers: [BalancePillar: BalanceAction]) -> some View {
        let items = balance.pillars.compactMap { offers[$0.pillar] }
        if !items.isEmpty {
            HStack(spacing: 8) {
                ForEach(items, id: \.pillar) { offer in
                    let title = offer.buttonTitle ?? ""
                    QuickChip(title: title, symbol: offer.pillar.symbol) { onAction(offer) }
                        .accessibilityLabel(String(localized: "\(offer.pillar.title): \(title)",
                                                   comment: "Balance card, VoiceOver: a pillar's chip, e.g. Eat: Check in"))
                        .accessibilityHint(offer.text)
                }
                Spacer(minLength: 0)
            }
            .padding(.top, 10)
        }
    }

    // MARK: A · Bars

    private func barsBody(_ offers: [BalancePillar: BalanceAction]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            headline(showsResult: true)
                .padding(.top, 4)
            VStack(spacing: layout.value(12, 14)) {
                ForEach(balance.pillars, id: \.pillar) { pillar in
                    barRow(pillar, invitation: offers[pillar.pillar])
                }
            }
            .padding(.top, 16)
        }
    }

    private func barRow(_ score: PillarScore, invitation: BalanceAction?) -> some View {
        let isLever = balance.lever == score.pillar
        let muted = score.status == .off || BalanceKit.isPausedTrain(score, paused: balance.paused)
        return HStack(alignment: .center, spacing: 10) {
            Button(action: onOpen) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 7) {
                        Image(systemName: score.pillar.symbol)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(muted || !score.isScored ? DS.silver.opacity(0.5) : BalanceKit.color(score.pillar))
                            .frame(width: 16)
                        Text(score.pillar.title)
                            .font(.ui(layout.value(15, 16), .semibold))
                            .foregroundStyle(DS.silver.opacity(muted ? 0.55 : 1))
                        if isLever { BalanceLeverCapsule() }
                        Spacer(minLength: 6)
                        if let value = score.score {
                            Text(value.formatted())
                                .font(.ui(layout.value(17, 18), .bold))
                                .monospacedDigit()
                                .foregroundStyle(DS.silver)
                                .contentTransition(.numericText())
                        }
                    }
                    BalanceTrack(score: score)
                    Text(BalanceKit.caption(score, paused: balance.paused))
                        .font(.ui(12.5))
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(BalanceKit.spoken(score, isLever: isLever, paused: balance.paused))
            .accessibilityHint(String(localized: "Opens what's behind your Balance", comment: "Balance card, VoiceOver hint"))
            .accessibilityAddTraits(.isButton)

            if let invitation, let title = invitation.buttonTitle {
                QuickChip(title: title) { onAction(invitation) }
                    .accessibilityHint(invitation.text)
            }
        }
    }

    // MARK: B · Triangle

    private func triangleBody(_ offers: [BalancePillar: BalanceAction]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                headline(showsResult: false)
                Spacer(minLength: 0)
                Button(action: onOpen) {
                    BalanceTriangle(balance: balance)
                        .frame(width: layout.value(150, 170), height: layout.value(138, 156))
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityHidden(true)
            }
            .padding(.top, 2)
            if let result = balance.result {
                BalanceResultChip(result: result)
                    .padding(.top, 8)
            }
            pillarColumns
                .padding(.top, 14)
            offerLine(offers)
        }
    }

    /// The three pillars side by side under the triangle: symbol, score,
    /// summary, and the lever's capsule.
    private var pillarColumns: some View {
        HStack(alignment: .top, spacing: 10) {
            ForEach(balance.pillars, id: \.pillar) { score in
                let isLever = balance.lever == score.pillar
                Button(action: onOpen) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 5) {
                            Image(systemName: score.pillar.symbol)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(BalanceKit.color(score.pillar))
                            TodayEyebrow(text: score.pillar.title, size: 9.5, opacity: 0.7)
                        }
                        Text(score.score.map { $0.formatted() } ?? "–")
                            .font(.ui(layout.value(20, 22), .bold))
                            .monospacedDigit()
                            .foregroundStyle(DS.silver)
                        Text(BalanceKit.caption(score, paused: balance.paused))
                            .font(.ui(11.5))
                            .foregroundStyle(DS.silver.opacity(0.6))
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        if isLever { BalanceLeverCapsule().padding(.top, 2) }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(BalanceKit.spoken(score, isLever: isLever, paused: balance.paused))
                .accessibilityHint(String(localized: "Opens what's behind your Balance", comment: "Balance card, VoiceOver hint"))
                .accessibilityAddTraits(.isButton)
            }
        }
    }

    // MARK: C · Ring

    private func ringBody(_ offers: [BalancePillar: BalanceAction]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: layout.value(16, 20)) {
                Button(action: onOpen) {
                    BalanceRingFigure(balance: balance, lineWidth: layout.value(11, 12))
                        .frame(width: layout.value(132, 150), height: layout.value(132, 150))
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(BalanceKit.spokenHeadline(balance))
                .accessibilityHint(String(localized: "Opens what's behind your Balance", comment: "Balance card, VoiceOver hint"))
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(balance.pillars, id: \.pillar) { score in
                        ringRow(score)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 6)
            if let result = balance.result {
                BalanceResultChip(result: result)
                    .padding(.top, 12)
            }
            offerLine(offers)
        }
    }

    private func ringRow(_ score: PillarScore) -> some View {
        let isLever = balance.lever == score.pillar
        return Button(action: onOpen) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Circle()
                        .fill(BalanceKit.color(score.pillar))
                        .frame(width: 8, height: 8)
                    Text(score.pillar.title)
                        .font(.ui(14.5, .semibold))
                        .foregroundStyle(DS.silver)
                    if isLever { BalanceLeverCapsule() }
                    Spacer(minLength: 4)
                    Text(score.score.map { $0.formatted() } ?? "–")
                        .font(.ui(16, .bold))
                        .monospacedDigit()
                        .foregroundStyle(DS.silver)
                }
                Text(BalanceKit.caption(score, paused: balance.paused))
                    .font(.ui(12))
                    .foregroundStyle(DS.silver.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .padding(.leading, 14)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(BalanceKit.spoken(score, isLever: isLever, paused: balance.paused))
        .accessibilityHint(String(localized: "Opens what's behind your Balance", comment: "Balance card, VoiceOver hint"))
        .accessibilityAddTraits(.isButton)
    }

    // MARK: Footer

    /// The lever's one line and one button.
    @ViewBuilder
    private var footer: some View {
        if let action = footerAction {
            Hairline(opacity: 0.08)
                .padding(.top, 14)
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: action.pillar.symbol)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(BalanceKit.color(action.pillar))
                    .frame(width: 16)
                    .accessibilityHidden(true)
                Text(action.text)
                    .font(.ui(layout.value(13.5, 14.5), .medium))
                    .foregroundStyle(DS.silver.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 6)
                if let title = action.buttonTitle {
                    // Tinted: the page's one filled control is the session's.
                    QuickChip(title: title) { onAction(action) }
                        .accessibilityHint(action.text)
                }
            }
            .padding(.top, 10)
        }
    }
}

// MARK: - Figures

/// B: one corner per pillar — Train at the top, Eat bottom right, Sleep
/// bottom left. A weak pillar pulls its corner in. Silver shape, pillar
/// colours only on the corner dots.
struct BalanceTriangle: View {
    let balance: Balance

    private static let angles: [BalancePillar: CGFloat] = [.train: -90, .eat: 30, .sleep: 150]

    var body: some View {
        GeometryReader { geo in
            let room: CGFloat = 22
            let radius = max(10, min((geo.size.width - 2 * room) / CGFloat(3).squareRoot(),
                                     (geo.size.height - 2 * room) / 1.5))
            let center = CGPoint(x: geo.size.width / 2, y: room + radius)
            let pillars = balance.pillars
            ZStack {
                // The full triangle, the halfway one and the spokes.
                Path { path in
                    path.addLines(pillars.map { point($0.pillar, radius, center) })
                    path.closeSubpath()
                }
                .stroke(DS.silver.opacity(0.18), lineWidth: 1)
                Path { path in
                    path.addLines(pillars.map { point($0.pillar, radius / 2, center) })
                    path.closeSubpath()
                }
                .stroke(DS.silver.opacity(0.12), style: StrokeStyle(lineWidth: 1, dash: [2, 3]))
                Path { path in
                    for pillar in pillars {
                        path.move(to: center)
                        path.addLine(to: point(pillar.pillar, radius, center))
                    }
                }
                .stroke(DS.silver.opacity(0.08), lineWidth: 1)

                // The week's shape.
                let shape = Path { path in
                    path.addLines(pillars.map { point($0.pillar, reach($0, radius), center) })
                    path.closeSubpath()
                }
                shape.fill(DS.silver.opacity(0.10))
                shape.stroke(DS.silver.opacity(0.75), style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))

                ForEach(pillars, id: \.pillar) { score in
                    Circle()
                        .fill(BalanceKit.color(score.pillar))
                        .frame(width: 9, height: 9)
                        .overlay(Circle().strokeBorder(DS.surface, lineWidth: 1.5))
                        .position(point(score.pillar, reach(score, radius), center))
                    label(score)
                        .position(labelPoint(score.pillar, radius, center))
                }
            }
        }
        .accessibilityHidden(true)
    }

    private func reach(_ score: PillarScore, _ radius: CGFloat) -> CGFloat {
        radius * max(0.06, min(1, CGFloat(score.score ?? 0) / 100))
    }

    private func point(_ pillar: BalancePillar, _ distance: CGFloat, _ center: CGPoint) -> CGPoint {
        let angle: CGFloat = (Self.angles[pillar] ?? 0) * .pi / 180
        return CGPoint(x: center.x + distance * cos(angle), y: center.y + distance * sin(angle))
    }

    /// Outside each corner: above Train, below Eat and Sleep.
    private func labelPoint(_ pillar: BalancePillar, _ radius: CGFloat, _ center: CGPoint) -> CGPoint {
        let corner = point(pillar, radius, center)
        return pillar == .train ? CGPoint(x: corner.x, y: corner.y - 12) : CGPoint(x: corner.x, y: corner.y + 13)
    }

    private func label(_ score: PillarScore) -> some View {
        HStack(spacing: 3) {
            Image(systemName: score.pillar.symbol)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(BalanceKit.color(score.pillar))
            Text(score.score.map { $0.formatted() } ?? "–")
                .font(.ui(12, .bold))
                .monospacedDigit()
                .foregroundStyle(DS.silver)
        }
        .fixedSize()
    }
}

/// C: one ring in three parts — Train from the top, then Eat, then Sleep —
/// each filled to its score in its own colour, Balance in the middle.
struct BalanceRingFigure: View {
    let balance: Balance
    var lineWidth: CGFloat = 11

    /// Of the whole circle, between two parts (round caps eat into it).
    private let gap = 0.065

    var body: some View {
        ZStack {
            ForEach(Array(balance.pillars.enumerated()), id: \.offset) { index, score in
                let tone = BalanceKit.color(score.pillar)
                let start = Double(index) / 3 + gap / 2
                let span = 1.0 / 3 - gap
                let fill = min(1, Double(score.score ?? 0) / 100)
                Circle()
                    .trim(from: start, to: start + span)
                    .stroke(tone.opacity(0.16), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                if fill > 0 {
                    Circle()
                        .trim(from: start, to: start + span * fill)
                        .stroke(tone, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
            }
            VStack(spacing: 2) {
                if balance.paused {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(DS.silver.opacity(0.6))
                } else {
                    Text(balance.score.map { $0.formatted() } ?? "–")
                        .font(.ui(34, .bold))
                        .tracking(-0.8)
                        .monospacedDigit()
                        .foregroundStyle(DS.silver)
                        .contentTransition(.numericText())
                }
                if let word = balance.paused ? String(localized: "Paused", comment: "Balance: the week is left out") : balance.word {
                    Text(word)
                        .font(.mono(9, .semibold))
                        .trackingEm(0.08, size: 9)
                        .textCase(.uppercase)
                        .foregroundStyle(DS.silver.opacity(0.6))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .padding(lineWidth + 6)
        }
        .padding(lineWidth / 2)
    }
}
