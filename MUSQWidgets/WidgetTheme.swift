//
//  WidgetTheme.swift
//  MUSQWidgets
//
//  The three looks (IslandStyle) as concrete colours, plus the small pieces
//  every surface shares: rings, numerals, pill buttons, the next-training line.
//
//    bold    — black, vivid MUSQ orange, heavy rounded numerals
//    glass   — translucent, one colour per metric (water blue, kcal orange,
//              sets green), soft tinted backgrounds
//    minimal — monochrome, hairline rings, light typographic numerals
//
//  The Dynamic Island is always black, so `island*` colours are tuned for a
//  black background whatever the style; Lock Screen and Home Screen colours
//  adapt to light/dark where the style allows.
//

import SwiftUI
import WidgetKit

/// Every word the extension shows goes through here (or Text("…")), so it is
/// looked up in MUSQWidgets/Localizable.xcstrings (English + Vietnamese).
/// Values from the app (exercise, workout and split-day names, the ready-made
/// set target) arrive already in the app's language.
func L(_ value: String.LocalizationValue) -> String {
    String(localized: value)
}

// MARK: - Palette

extension Color {
    /// MUSQ brand orange (#FF6B2E), same as the extension's AccentColor.
    static let musqOrange = Color(red: 1.0, green: 0.42, blue: 0.18)
    static let musqAmber = Color(red: 1.0, green: 0.62, blue: 0.20)
    static let musqWater = Color(red: 0.24, green: 0.62, blue: 1.0)
    static let musqWaterDeep = Color(red: 0.16, green: 0.42, blue: 0.96)
    static let musqLime = Color(red: 0.36, green: 0.86, blue: 0.48)
    static let musqInk = Color(red: 0.06, green: 0.06, blue: 0.07)
}

struct WidgetTheme {
    let style: IslandStyle

    init(_ style: IslandStyle) { self.style = style }

    // Metric colours ----------------------------------------------------------

    /// Workout sets / rest ring.
    var workout: Color {
        switch style {
        case .bold: .musqOrange
        case .glass: .musqLime
        case .minimal: .primary
        }
    }

    var water: Color {
        switch style {
        case .bold: .musqOrange
        case .glass: .musqWater
        case .minimal: .primary
        }
    }

    var kcal: Color {
        switch style {
        case .bold: .white
        case .glass: .musqOrange
        case .minimal: .primary
        }
    }

    /// Same metric colours for the always-black Dynamic Island.
    var islandWorkout: Color { style == .minimal ? .white : workout }
    var islandWater: Color { style == .minimal ? .white : water }
    var islandKcal: Color {
        switch style {
        case .bold: .white
        case .glass: .musqOrange
        case .minimal: .white
        }
    }
    /// Secondary accent in the island (labels next to the big number).
    var islandAccent: Color {
        switch style {
        case .bold: .musqOrange
        case .glass: .musqLime
        case .minimal: .white
        }
    }

    // Rings -------------------------------------------------------------------

    /// Ring line width relative to the ring's diameter.
    var ringWidthRatio: CGFloat {
        switch style {
        case .bold: 0.13
        case .glass: 0.11
        case .minimal: 0.05
        }
    }

    var trackOpacity: Double {
        switch style {
        case .bold: 0.22
        case .glass: 0.20
        case .minimal: 0.14
        }
    }

    // Type --------------------------------------------------------------------

    /// Weight of the big numbers.
    var numberWeight: Font.Weight {
        switch style {
        case .bold: .heavy
        case .glass: .bold
        case .minimal: .light
        }
    }

    var labelWeight: Font.Weight {
        switch style {
        case .bold: .bold
        case .glass: .semibold
        case .minimal: .regular
        }
    }

    /// Upper-case tracked labels read as "brand" in bold, as type in minimal.
    var labelTracking: CGFloat {
        switch style {
        case .bold: 0.6
        case .glass: 0.2
        case .minimal: 1.2
        }
    }

    // Lock Screen card (Live Activities) ------------------------------------------

    /// nil = the system's own translucent Lock Screen material.
    var activityBackground: Color? {
        switch style {
        case .bold: .musqInk
        // Dark enough that the white/lime text keeps its contrast on a light
        // wallpaper (0.42 left the secondary text near 2:1).
        case .glass: Color.black.opacity(0.74)
        case .minimal: nil
        }
    }

    /// Text on the Lock Screen card: bold/glass are always on a dark card.
    var cardPrimary: Color {
        switch style {
        case .bold, .glass: .white
        case .minimal: .primary
        }
    }

    var cardSecondary: Color {
        switch style {
        case .bold: .white.opacity(0.62)
        case .glass: .white.opacity(0.72)
        case .minimal: .secondary
        }
    }

    /// Lock Screen colours of the metrics (minimal stays adaptive).
    var cardWorkout: Color { style == .minimal ? .primary : islandWorkout }
    var cardWater: Color { style == .minimal ? .primary : islandWater }
    var cardKcal: Color { style == .minimal ? .primary : islandKcal }

    /// Colour the system uses for its own buttons on the card (e.g. "Clear").
    var systemActionTint: Color {
        switch style {
        case .bold: .musqOrange
        case .glass: .white
        case .minimal: .primary
        }
    }

    // Home Screen widget background ------------------------------------------------

    @ViewBuilder
    var widgetBackground: some View {
        switch style {
        case .bold:
            ZStack {
                Color.musqInk
                RadialGradient(colors: [Color.musqOrange.opacity(0.22), .clear],
                               center: .topTrailing, startRadius: 0, endRadius: 180)
            }
        case .glass:
            GlassWidgetBackground()
        case .minimal:
            Color(uiColor: .systemBackground)
        }
    }

    /// Home Screen widget text colours (bold is always dark).
    var widgetPrimary: Color { style == .bold ? .white : .primary }
    var widgetSecondary: Color { style == .bold ? .white.opacity(0.6) : .secondary }
    var widgetWater: Color { style == .minimal ? .primary : water }
    var widgetKcal: Color {
        switch style {
        case .bold: .white
        case .glass: .musqOrange
        case .minimal: .primary
        }
    }
    var widgetColorScheme: ColorScheme? { style == .bold ? .dark : nil }
}

private struct GlassWidgetBackground: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
            LinearGradient(colors: [Color.musqWater.opacity(scheme == .dark ? 0.30 : 0.18),
                                    Color.musqOrange.opacity(scheme == .dark ? 0.18 : 0.12)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            // Frosted top sheen.
            LinearGradient(colors: [.white.opacity(scheme == .dark ? 0.06 : 0.45), .clear],
                           startPoint: .top, endPoint: .center)
        }
    }
}

// MARK: - Ring

/// A progress ring with a round cap; the line scales with its frame.
struct MetricRing: View {
    var progress: Double
    var color: Color
    var theme: WidgetTheme
    /// Explicit line width; nil = theme ratio of the diameter.
    var lineWidth: CGFloat? = nil
    var trackColor: Color? = nil

    var body: some View {
        GeometryReader { geo in
            let d = min(geo.size.width, geo.size.height)
            let w = lineWidth ?? max(1.5, d * theme.ringWidthRatio)
            ZStack {
                Circle()
                    .stroke((trackColor ?? color).opacity(theme.trackOpacity), lineWidth: w)
                Circle()
                    .trim(from: 0, to: max(0.001, min(1, progress)))
                    .stroke(fill, style: StrokeStyle(lineWidth: w, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .widgetAccentable()
            }
            .padding(w / 2)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private var fill: AnyShapeStyle {
        theme.style == .glass
            ? AnyShapeStyle(AngularGradient(colors: [color.opacity(0.75), color],
                                            center: .center, startAngle: .degrees(0),
                                            endAngle: .degrees(360 * max(0.05, progress))))
            : AnyShapeStyle(color)
    }
}

/// A live countdown ring: the system animates ProgressView(timerInterval:)
/// without app updates. The circular style is the only one that animates in
/// a widget, so the look comes from tint + frame.
struct CountdownRing: View {
    var interval: ClosedRange<Date>
    var color: Color

    var body: some View {
        ProgressView(timerInterval: interval, countsDown: true) {
            EmptyView()
        } currentValueLabel: {
            EmptyView()
        }
        .progressViewStyle(.circular)
        .labelsHidden()
        .tint(color)
    }
}

// MARK: - Numerals & labels

extension View {
    /// Rounded, monospaced digits: the MUSQ numeral.
    func musqNumber(_ size: CGFloat, _ weight: Font.Weight) -> some View {
        font(.system(size: size, weight: weight, design: .rounded))
            .monospacedDigit()
    }
}

struct TrackedLabel: View {
    var text: String
    var theme: WidgetTheme
    var size: CGFloat = 11
    var color: Color? = nil

    var body: some View {
        Text(text.localizedUppercase)
            .font(.system(size: size, weight: theme.labelWeight, design: .rounded))
            .tracking(theme.labelTracking)
            .foregroundStyle(color ?? .secondary)
            .lineLimit(1)
    }
}

/// A rounded pill for Button(intent:) / Link labels.
struct PillLabel: View {
    var title: String
    var systemImage: String? = nil
    var foreground: Color
    var background: AnyShapeStyle
    var height: CGFloat = 36
    var stroke: Color? = nil
    /// Tinted / clear Home Screen and the Lock Screen draw everything in one
    /// tint: a filled capsule would swallow its own label there.
    @Environment(\.widgetRenderingMode) private var renderingMode

    var body: some View {
        if renderingMode == .fullColor {
            filled
        } else {
            HStack(spacing: 5) { content }
                .foregroundStyle(.primary)
                .widgetAccentable()
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(Color.primary.opacity(0.10), in: Capsule())
                .overlay { Capsule().strokeBorder(Color.primary.opacity(0.6), lineWidth: 1) }
                .contentShape(Capsule())
        }
    }

    @ViewBuilder
    private var content: some View {
        if let systemImage {
            Image(systemName: systemImage).font(.system(size: height * 0.38, weight: .bold))
        }
        Text(title)
            .font(.system(size: height * 0.42, weight: .semibold, design: .rounded))
            .monospacedDigit()
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }

    private var filled: some View {
        HStack(spacing: 5) {
            if let systemImage {
                Image(systemName: systemImage).font(.system(size: height * 0.38, weight: .bold))
            }
            Text(title)
                .font(.system(size: height * 0.42, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(foreground)
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(background, in: Capsule())
        .overlay {
            if let stroke { Capsule().strokeBorder(stroke, lineWidth: 1) }
        }
        .contentShape(Capsule())
    }
}

extension WidgetTheme {
    /// Primary pill on a dark surface (island, bold/glass cards).
    func darkPrimaryPill(_ title: String, _ icon: String?, accent: Color, height: CGFloat = 36) -> PillLabel {
        switch style {
        case .bold:
            PillLabel(title: title, systemImage: icon, foreground: .black,
                      background: AnyShapeStyle(accent), height: height)
        case .glass:
            // Dark ink on the bright metric colour: white on lime/blue was
            // under 3:1.
            PillLabel(title: title, systemImage: icon, foreground: .musqInk,
                      background: AnyShapeStyle(accent.gradient), height: height,
                      stroke: .white.opacity(0.25))
        case .minimal:
            PillLabel(title: title, systemImage: icon, foreground: .black,
                      background: AnyShapeStyle(Color.white), height: height)
        }
    }

    /// Secondary pill on a dark surface.
    func darkSecondaryPill(_ title: String, _ icon: String? = nil, height: CGFloat = 36) -> PillLabel {
        switch style {
        case .bold:
            PillLabel(title: title, systemImage: icon, foreground: .white,
                      background: AnyShapeStyle(Color.white.opacity(0.14)), height: height)
        case .glass:
            PillLabel(title: title, systemImage: icon, foreground: .white,
                      background: AnyShapeStyle(Color.white.opacity(0.16)), height: height,
                      stroke: .white.opacity(0.18))
        case .minimal:
            PillLabel(title: title, systemImage: icon, foreground: .white,
                      background: AnyShapeStyle(Color.clear), height: height,
                      stroke: .white.opacity(0.45))
        }
    }

    /// Pills on the Lock Screen card / Home Screen widget: minimal adapts.
    func cardPrimaryPill(_ title: String, _ icon: String?, accent: Color, height: CGFloat = 36) -> PillLabel {
        guard style == .minimal else { return darkPrimaryPill(title, icon, accent: accent, height: height) }
        return PillLabel(title: title, systemImage: icon, foreground: Color(uiColor: .systemBackground),
                         background: AnyShapeStyle(Color.primary), height: height)
    }

    func cardSecondaryPill(_ title: String, _ icon: String? = nil, height: CGFloat = 36) -> PillLabel {
        guard style == .minimal else { return darkSecondaryPill(title, icon, height: height) }
        return PillLabel(title: title, systemImage: icon, foreground: .primary,
                         background: AnyShapeStyle(Color.clear), height: height,
                         stroke: Color.primary.opacity(0.35))
    }
}

// MARK: - Formatting

enum WidgetFormat {
    /// "1.5 L" above a litre, "750 ml" below; the decimal mark follows the
    /// locale ("1,5 L" in Vietnamese), like the kcal numbers beside it.
    static func water(_ ml: Int) -> String {
        guard ml >= 1000 else { return "\(ml) ml" }
        return "\(litres(ml)) L"
    }

    /// "1.5" / "2" (no unit) for tight spots, in the locale's decimal mark.
    static func litres(_ ml: Int) -> String {
        let l = Double(ml) / 1000
        if l >= 10 || l.truncatingRemainder(dividingBy: 1) == 0 {
            return l.formatted(.number.precision(.fractionLength(0)))
        }
        return l.formatted(.number.precision(.fractionLength(1)))
    }

    /// kcal: no thousands mark below 10,000 — "1420", never "1.420", which a
    /// reader of a dot-thousands locale can't tell from 1.42.
    static func number(_ n: Int) -> String {
        n.formatted(.number.grouping(abs(n) >= 10_000 ? .automatic : .never))
    }

    /// "1.4K" / "1,4 N" for the compact island: keeps it narrow.
    static func compact(_ n: Int) -> String {
        guard abs(n) >= 1000 else { return "\(n)" }
        return n.formatted(.number.notation(.compactName).precision(.fractionLength(0...1)))
    }

    /// The next-training line: "Push · 18:00", "Legs · Tomorrow", "Rest day".
    static func nextTraining(label: String?, day: Date?, time: Date?, isTrainingDay: Bool,
                             trainedToday: Bool, now: Date = Date()) -> (title: String, detail: String) {
        let cal = Calendar.current
        if trainedToday {
            if let label, let day, !cal.isDate(day, inSameDayAs: now) {
                return (L("Done today"), L("Next: \(label) · \(dayName(day, now: now))"))
            }
            return (L("Done today"), L("Nice work"))
        }
        guard let label else {
            if isTrainingDay {
                if let time, let day, cal.isDate(day, inSameDayAs: now) {
                    return (L("Training day"), time.formatted(date: .omitted, time: .shortened))
                }
                return (L("Training day"), L("Let's go"))
            }
            if let day, !cal.isDate(day, inSameDayAs: now) {
                return (L("Rest day"), L("Next: \(dayName(day, now: now))"))
            }
            return (L("Rest day"), L("Recover well"))
        }
        if let day, cal.isDate(day, inSameDayAs: now) {
            if let time { return (label, time.formatted(date: .omitted, time: .shortened)) }
            return (label, L("Today"))
        }
        if let day {
            return (isTrainingDay ? label : L("Rest day"),
                    isTrainingDay ? dayName(day, now: now) : L("Next: \(label) · \(dayName(day, now: now))"))
        }
        return (label, L("Up next"))
    }

    static func dayName(_ day: Date, now: Date = Date()) -> String {
        let cal = Calendar.current
        if cal.isDate(day, inSameDayAs: now) { return L("Today") }
        if let tomorrow = cal.date(byAdding: .day, value: 1, to: now), cal.isDate(day, inSameDayAs: tomorrow) {
            return L("Tomorrow")
        }
        return day.formatted(.dateTime.weekday(.wide))
    }

    static func meals(_ n: Int) -> String {
        n == 1 ? L("1 meal") : L("\(n) meals")
    }
}

// MARK: - Workout state helpers

extension WorkoutActivityAttributes.ContentState {
    /// "60 kg × 8", "Bodyweight × 12", "Hold 45 s".
    var targetText: String {
        if isAllDone { return L("Tap to finish") }
        if let nextTargetText, !nextTargetText.isEmpty { return nextTargetText }
        if let hold = nextHoldSeconds {
            if let w = nextWeightKg { return "\(Self.weight(w)) \(weightUnit) · \(hold) s" }
            return L("Hold \(hold) s")
        }
        let w = nextWeightKg.map { "\(Self.weight($0)) \(weightUnit)" } ?? L("Bodyweight")
        if let reps = nextReps { return "\(w) × \(reps)" }
        return w
    }

    static func weight(_ w: Double) -> String {
        w.formatted(.number.precision(.fractionLength(w.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 1)))
    }

    /// The rest window to draw, only while it is running.
    var liveRest: ClosedRange<Date>? {
        guard isResting, !isFinished else { return nil }
        return restInterval
    }

    /// The app sends restEndsAt only while a rest runs and clears it when the
    /// rest ends; a past restEndsAt means the rest ran out while the app was
    /// suspended (the system redraws at staleDate = restEndsAt).
    var restOver: Bool {
        guard !isFinished, let end = restEndsAt else { return false }
        return end <= Date()
    }

    var setsFraction: String { "\(setsDone)/\(setsTotal)" }
}
