//
//  TabBar.swift
//  GymWorkout
//
//  The design draws the tab bar per-screen rather than globally: on the tab
//  roots it is chrome sitting on the screen ground, while on Anatomy it is
//  ruled into the bottom of the muscle panel itself. `Style` covers both, and
//  screens pushed on top of a tab (the 3D view, step mode) simply
//  don't render one.
//

import Combine
import Observation
import SwiftUI

/// Today leads since the all-in-one plan (2026-11-21, layout A); the third
/// tab, still `muscles` underneath, is shown as Progress.
enum AppTab: String, CaseIterable, Identifiable {
    case today = "Today"
    case train = "Train"
    case exercises = "Exercises"
    case muscles = "Muscles"
    /// Friends (2026-11-28): sits before Profile in the swipeable strip.
    case friends = "Friends"
    case profile = "Profile"

    var id: String { rawValue }

    /// The tab's name on screen. Keyed apart from the same words elsewhere
    /// ("Train" the button), since the bar has room for less.
    var title: String {
        switch self {
        case .today: return String(localized: "tab.today", defaultValue: "Today", comment: "Tab name")
        case .train: return String(localized: "tab.train", defaultValue: "Train", comment: "Tab name")
        case .exercises: return String(localized: "tab.exercises", defaultValue: "Exercises", comment: "Tab name")
        case .muscles: return String(localized: "tab.progress", defaultValue: "Progress",
                                     comment: "Tab name: training and body progress (was Muscles)")
        case .friends: return String(localized: "tab.friends", defaultValue: "Friends", comment: "Tab name")
        case .profile: return String(localized: "tab.profile", defaultValue: "Profile", comment: "Tab name")
        }
    }

    /// Outline when idle, filled when selected — the same silhouette, so the
    /// bar reads by shape and the selection by weight.
    func symbol(selected: Bool) -> String {
        switch self {
        case .today: return selected ? "sun.max.fill" : "sun.max"
        case .train: return selected ? "dumbbell.fill" : "dumbbell"
        case .exercises: return selected ? "list.bullet.rectangle.portrait.fill" : "list.bullet.rectangle.portrait"
        case .muscles: return "figure.arms.open"
        case .friends: return selected ? "person.2.fill" : "person.2"
        case .profile: return selected ? "person.crop.circle.fill" : "person.crop.circle"
        }
    }
}

struct TabBarView: View {
    enum Style {
        /// Blurred chrome with its own ground — the tab roots.
        case chrome
        /// Ruled into the surface it sits on — Anatomy's muscle panel.
        case inline
    }

    @Binding var selection: AppTab
    var style: Style = .chrome
    /// False where the screen places the ad itself (Today puts it above its
    /// quick-log dock, so it never sits between two rows of buttons).
    var showsAd: Bool = true

    @Environment(\.dsChrome) private var windowChrome
    /// The bar's big round button (2026-11-27), set up by the root; absent
    /// in previews and wherever no root hosts it.
    @Environment(TabPrimaryAction.self) private var primary: TabPrimaryAction?
    @Environment(Purchases.self) private var purchases: Purchases?
    @State private var appeared = false
    @State private var barWidth: CGFloat = 0

    var body: some View {
        if windowChrome.isSidebar {
            // The sidebar does the navigating; the rest and the ad still
            // ride at the foot of the content column, and take no space
            // while neither is showing.
            VStack(spacing: 0) {
                RestTimerBar()
                if showsAd { AdBanner() }
            }
            .frame(maxWidth: .infinity)
            // No bar to hold it: the big button floats over the column's
            // trailing corner, just above the rest and the ad, and takes no
            // height from the content.
            .overlay(alignment: .topTrailing) {
                if let primary {
                    TabPrimarySlot(primary: primary, purchases: purchases)
                        .alignmentGuide(.top) { $0[.bottom] + 12 }
                        .padding(.trailing, 20)
                }
            }
        } else {
            VStack(spacing: 0) {
                // Every tab root carries the bar, so the running rest rides on it
                // and stays visible whichever tab is open.
                RestTimerBar()
                // Pinned to the tab bar, below the rest: the rest coming and
                // going never slides the ad under a finger reaching for Skip.
                if showsAd { AdBanner() }
                bar
            }
        }
    }

    /// Each tab's width in the strip: fixed, so six tabs overflow a phone
    /// and the strip scrolls sideways (owner, 2026-11-28).
    private static let tabWidth: CGFloat = 66

    private var bar: some View {
        HStack(spacing: 10) {
            // The tabs ride in one rounded strip that swipes left and right;
            // the big button stays put beside it.
            ScrollViewReader { reader in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(AppTab.allCases) { tab in
                            let isOn = tab == selection
                            Button {
                                selection = tab
                            } label: {
                                // Each tab root draws its own bar, so the new
                                // tab's icon bounces as its bar appears.
                                TabItemLabel(tab: tab, isOn: isOn, layout: .bar,
                                             bounce: isOn && appeared ? 1 : 0)
                                    .frame(width: Self.tabWidth)
                                    .padding(.vertical, 6)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .id(tab)
                            .accessibilityLabel(tab.title)
                            .accessibilityAddTraits(isOn ? .isSelected : [])
                        }
                    }
                    .padding(.horizontal, 6)
                }
                .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
                .background(Capsule().fill(DS.silver.opacity(0.06)))
                .overlay(Capsule().strokeBorder(DS.silver.opacity(0.08), lineWidth: 1))
                .clipShape(Capsule())
                .onAppear { reader.scrollTo(selection, anchor: .center) }
                .onChange(of: selection) { _, tab in
                    withAnimation(.easeOut(duration: 0.25)) { reader.scrollTo(tab, anchor: .center) }
                }
            }
            if let primary {
                // Narrower in a narrow window (Slide Over, 1/3 Split View).
                TabPrimarySlot(primary: primary, purchases: purchases)
                    .frame(width: barWidth > 0 && barWidth < 360 ? 58 : 66)
            }
        }
        .padding(.horizontal, 12)
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { barWidth = $0 }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(alignment: .top) {
            Rectangle()
                .fill(DS.silver.opacity(0.08))
                .frame(height: 1)
        }
        .background {
            if style == .chrome {
                DS.chrome
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .onAppear { appeared = true }
    }
}

/// One tab's glyph and name, as the bottom bar, the sidebar rail or the
/// expanded sidebar draws it. Same symbols and the same silver weights
/// everywhere, so a tab reads the same whichever chrome is showing.
struct TabItemLabel: View {
    enum Placement {
        /// The bottom bar: glyph in a 54×30 capsule over a 10pt name.
        case bar
        /// The sidebar rail: glyph in a 48×40 capsule over a 10pt name.
        case rail
        /// The expanded sidebar: a 46pt row, glyph beside a 15pt name.
        case row
    }

    var tab: AppTab
    var isOn: Bool
    var layout: Placement
    /// The glyph bounces whenever this changes.
    var bounce: Int = 0

    var body: some View {
        switch layout {
        case .bar:
            VStack(spacing: 4) {
                TabGlyph(color: isOn ? DS.silver : DS.silver.opacity(0.45),
                         symbol: tab.symbol(selected: isOn))
                    .symbolEffect(.bounce, value: bounce)
                    .frame(minWidth: 40, idealWidth: 54, maxWidth: 54)
                    .frame(height: 30)
                    .background {
                        if isOn {
                            Capsule().fill(DS.silver.opacity(0.09))
                        }
                    }
                Text(tab.title)
                    .font(.ui(10, isOn ? .semibold : .medium))
                    .foregroundStyle(isOn ? DS.silver : DS.silver.opacity(0.45))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        case .rail:
            VStack(spacing: 4) {
                TabGlyph(color: isOn ? DS.silver : DS.silver.opacity(0.45),
                         symbol: tab.symbol(selected: isOn), size: 24)
                    .symbolEffect(.bounce, value: bounce)
                    .frame(width: 48, height: 40)
                    .background {
                        if isOn {
                            Capsule().fill(DS.silver.opacity(0.09))
                        }
                    }
                Text(tab.title)
                    .font(.ui(10, isOn ? .semibold : .medium))
                    .foregroundStyle(isOn ? DS.silver : DS.silver.opacity(0.45))
                    .lineLimit(1)
                    .fixedSize()
            }
        case .row:
            HStack(spacing: 12) {
                TabGlyph(color: isOn ? DS.silver : DS.silver.opacity(0.55),
                         symbol: tab.symbol(selected: isOn), size: 20)
                    .symbolEffect(.bounce, value: bounce)
                Text(tab.title)
                    .font(.ui(15, isOn ? .semibold : .medium))
                    .foregroundStyle(isOn ? DS.silver : DS.silver.opacity(0.55))
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background {
                if isOn {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(DS.silver.opacity(0.09))
                }
            }
        }
    }
}

#Preview("Tab bar · bottom") {
    @Previewable @State var tab: AppTab = .train
    VStack {
        Spacer()
        TabBarView(selection: $tab)
    }
    .environment(RestTimer())
    .environment(Ads(purchases: Purchases()))
    .dsPreview(.phone)
}

#Preview("Tab bar · sidebar") {
    @Previewable @State var tab: AppTab = .train
    VStack {
        Spacer()
        Text("With the sidebar the bar draws only the rest and the ad.")
            .font(.ui(13))
            .foregroundStyle(DS.silver.opacity(0.5))
        Spacer()
        TabBarView(selection: $tab)
    }
    .environment(RestTimer())
    .environment(Ads(purchases: Purchases()))
    .dsPreview(.pad13Portrait940)
}

// MARK: - The big button

/// The tab bar's primary action (2026-11-27, the owner's "lazy thumb"): a
/// big round button at the bar's right end on every tab. Pro members with
/// scans left get "Scan" (the meal scan); everyone else gets "Log", the
/// typed or spoken food log. The root presents what it opens, so it works
/// on every tab.
@Observable
final class TabPrimaryAction {
    enum Mode: Equatable {
        case scan, log

        var symbol: String { self == .scan ? "camera.viewfinder" : "fork.knife" }

        var title: String {
            switch self {
            case .scan: return String(localized: "tab.primary.scan", defaultValue: "Scan",
                                      comment: "The tab bar's big button: scan a meal (Pro)")
            case .log: return String(localized: "tab.primary.log", defaultValue: "Log",
                                     comment: "The tab bar's big button: log food by words")
            }
        }

        var spoken: String {
            switch self {
            case .scan: return String(localized: "Scan a meal", comment: "Today: a short chip that opens the meal scan (Pro); also the scan sheet's title")
            case .log: return String(localized: "Log food", comment: "Today: log a meal by saying or typing what was eaten")
            }
        }
    }

    /// What the root presents.
    enum Request: Identifiable, Equatable {
        case scan, log, signIn, consent
        var id: Self { self }
    }

    var request: Request?
    /// Signed in or agreed in a gate sheet: the scan opens once it has closed.
    @ObservationIgnored var resumesScan = false

    /// "Scan" while the tier has meal scans and today's aren't used up.
    @MainActor
    static func mode(_ purchases: Purchases?) -> Mode {
        guard AIService.isLive, let purchases, (purchases.tier.ai?.mealScansPerDay ?? 0) > 0,
              !MealScanQuota.exhaustedToday else { return .log }
        return .scan
    }

    @MainActor
    func tap(_ purchases: Purchases?) {
        switch Self.mode(purchases) {
        case .log:
            request = .log
        case .scan:
            switch AIGate.check(isPremium: true, consent: .meal) {
            case .ready: request = .scan
            case .signIn: request = .signIn
            case .consent: request = .consent
            case .paywall: request = .log
            }
        }
    }

    /// A gate sheet has closed: on to the scan if it was passed.
    @MainActor
    func resume(_ purchases: Purchases?) {
        guard resumesScan else { return }
        resumesScan = false
        tap(purchases)
    }
}

/// The big button, kept in step with the scan quota: the quota lives in
/// UserDefaults (`MealScanQuota`), read here through `@AppStorage` so a scan
/// that uses the last one turns "Scan" into "Log" at once, and a new day
/// (`.NSCalendarDayChanged`) turns it back.
private struct TabPrimarySlot: View {
    var primary: TabPrimaryAction
    var purchases: Purchases?

    @AppStorage(MealScanQuota.dayKey) private var quotaDay = ""
    @AppStorage(MealScanQuota.remainingKey) private var quotaLeft = -1
    @State private var dayTick = 0

    var body: some View {
        // Read so a change redraws the button; `mode` reads the store itself.
        let _ = (quotaDay, quotaLeft, dayTick)
        TabPrimaryButton(mode: TabPrimaryAction.mode(purchases), action: { primary.tap(purchases) })
            .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged).receive(on: RunLoop.main)) { _ in
                dayTick += 1
            }
    }
}

struct TabPrimaryButton: View {
    var mode: TabPrimaryAction.Mode
    var action: () -> Void

    @State private var taps = 0

    var body: some View {
        Button {
            taps += 1
            action()
        } label: {
            VStack(spacing: 3) {
                StyledSymbol(name: mode.symbol, size: 22, weight: .bold)
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, value: taps)
                    .frame(width: 54, height: 54)
                    .background(Circle().fill(
                        LinearGradient(colors: [DS.activationSoft, DS.activation], startPoint: .top, endPoint: .bottom)))
                    .overlay(Circle().strokeBorder(.white.opacity(0.22), lineWidth: 1))
                    .shadow(color: DS.activation.opacity(0.45), radius: 10, y: 4)
                Text(mode.title)
                    .font(.ui(10.5, .bold))
                    .foregroundStyle(DS.activation)
                    .lineLimit(1)
                    .fixedSize()
            }
            // Stays inside the bar: rising over its line put the button on the
            // ad banner's own button (AdMob accidental-click risk, 2026-11-28).
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(mode.spoken)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }
}
