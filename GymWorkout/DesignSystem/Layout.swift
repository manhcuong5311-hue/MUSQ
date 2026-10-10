//
//  Layout.swift
//  GymWorkout
//
//  The iPad half of the design system. Every screen adapts to one value,
//  `@Environment(\.dsLayout)`, which RootView resolves from the width of the
//  content column (the window minus the sidebar). On iPhone it is always
//  `.compact`, and every token below hands back today's literal for
//  `.compact`, so the phone keeps rendering exactly the code it always has:
//  iPad layouts hang off `layout.isRegular` / `layout.isWide`, never off a
//  changed default.
//
//  Tiers:
//    .compact  iPhone, Slide Over, 1/3 and the 11-inch's 1/2 Split View
//    .regular  a content column under 900pt — single centred columns,
//              larger type, adaptive grids
//    .wide     900pt and up — the two-pane dashboards
//

import SwiftUI

// MARK: - Tier

enum DSTier: Int, Comparable {
    case compact, regular, wide

    static func < (lhs: DSTier, rhs: DSTier) -> Bool { lhs.rawValue < rhs.rawValue }
}

/// Type roles whose size grows with the tier. Compact sizes are the ones the
/// screens use today.
enum DSTextRole {
    /// Tab-root titles: 28 → 34.
    case largeTitle
    /// Pushed-screen headers: 16 → 20.
    case screenTitle
    /// 20 → 24.
    case sectionTitle
    /// 22 → 26.
    case sheetTitle
    /// 15 → 17.
    case cardTitle
    /// 14 → 15.5.
    case body
    /// 12 → 13.
    case detail
    /// 11 → 12.
    case eyebrow
    /// 9.5 → 10.5.
    case meta
}

// MARK: - Chrome

/// What the window spends on navigation chrome beside the content column.
enum DSChrome: Equatable {
    /// The per-screen bottom tab bar: iPhone, and iPad windows too narrow for
    /// a sidebar.
    case bottomBar
    /// The floating sidebar card in regular-width iPad windows.
    case sidebar(SidebarStyle)

    enum SidebarStyle: Equatable {
        /// 64pt card of icons in an 84pt column.
        case rail
        /// 240pt card with labels in a 260pt column.
        case expanded
    }

    /// Width taken from the window, insets included.
    var width: CGFloat {
        switch self {
        case .bottomBar: return 0
        case .sidebar(.rail): return DS.Layout.sidebarRail
        case .sidebar(.expanded): return DS.Layout.sidebarExpanded
        }
    }

    var isSidebar: Bool { self != .bottomBar }
}

// MARK: - Layout

struct DSLayout: Equatable {
    var tier: DSTier
    /// The content column: window minus sidebar, or the sheet / pane this
    /// layout was resolved for. Zero on iPhone, which never measures.
    var containerWidth: CGFloat
    var containerHeight: CGFloat

    static let compact = DSLayout(tier: .compact, containerWidth: 0, containerHeight: 0)

    /// Regular or wide.
    var isRegular: Bool { tier != .compact }
    var isWide: Bool { tier == .wide }

    // MARK: Tokens (compact == today)

    /// Horizontal gutter; compact is `DS.Metric.gutter`.
    var gutter: CGFloat { value(DS.Metric.gutter, 28, wide: 32) }
    var gridSpacing: CGFloat { value(10, 14, wide: 16) }
    var cardRadius: CGFloat { value(16, 20, wide: 20) }
    /// Gap between the panes of a two-pane layout.
    var paneGap: CGFloat { value(0, 24, wide: 24) }
    /// Space between stacked sections; for regular branches only.
    var sectionSpacing: CGFloat { value(0, 32, wide: 36) }
    /// Letter-spacing for `.largeTitle`; compact is the -0.7 the tab roots use.
    var largeTitleTracking: CGFloat { value(-0.7, -0.85) }

    /// A metric that grows on iPad. Compact returns `compact` untouched;
    /// regular returns `regular`, or `compact` × 1.15 rounded to the half
    /// point; wide returns `wide`, or the regular value.
    func pt(_ compact: CGFloat, _ regular: CGFloat? = nil, wide: CGFloat? = nil) -> CGFloat {
        switch tier {
        case .compact: return compact
        case .regular: return regular ?? Self.scaled(compact)
        case .wide: return wide ?? regular ?? Self.scaled(compact)
        }
    }

    /// Any per-tier value; wide falls back to the regular one.
    func value<T>(_ compact: T, _ regular: T, wide: T? = nil) -> T {
        switch tier {
        case .compact: return compact
        case .regular: return regular
        case .wide: return wide ?? regular
        }
    }

    /// Point size for a type role.
    func text(_ role: DSTextRole) -> CGFloat {
        switch role {
        case .largeTitle: return value(28, 34)
        case .screenTitle: return value(16, 20)
        case .sectionTitle: return value(20, 24)
        case .sheetTitle: return value(22, 26)
        case .cardTitle: return value(15, 17)
        case .body: return value(14, 15.5)
        case .detail: return value(12, 13)
        case .eyebrow: return value(11, 12)
        case .meta: return value(9.5, 10.5)
        }
    }

    /// How many columns of at least `minimum` fit across `width`.
    func columnCount(fitting width: CGFloat, minimum: CGFloat, spacing: CGFloat,
                     range: ClosedRange<Int>) -> Int {
        guard minimum + spacing > 0, width.isFinite else { return range.lowerBound }
        let fit = Int(((width + spacing) / (minimum + spacing)).rounded(.down))
        return min(max(fit, range.lowerBound), range.upperBound)
    }

    /// A share of the container, clamped.
    func paneWidth(_ fraction: CGFloat, min lower: CGFloat, max upper: CGFloat) -> CGFloat {
        Swift.min(Swift.max(fraction * containerWidth, lower), upper)
    }

    /// The same tier for a narrower container — a pane, a popover. Tier is
    /// kept on purpose: an inspector beside a wide dashboard still wants iPad
    /// type, not phone type.
    func with(containerWidth: CGFloat, containerHeight: CGFloat? = nil) -> DSLayout {
        DSLayout(tier: tier, containerWidth: containerWidth,
                 containerHeight: containerHeight ?? self.containerHeight)
    }

    // MARK: Resolution

    /// The app window. Regular needs an iPad, a regular size class and a
    /// window at least 600pt wide; the tier then comes from what is left
    /// after the chrome.
    static func window(windowSize: CGSize, chrome: DSChrome,
                       sizeClass: UserInterfaceSizeClass?) -> DSLayout {
        let column = max(0, windowSize.width - chrome.width)
        guard DS.isPad, sizeClass == .regular, windowSize.width >= DS.Layout.regularWindowMin else {
            return DSLayout(tier: .compact, containerWidth: column, containerHeight: windowSize.height)
        }
        return DSLayout(tier: column >= DS.Layout.wideMin ? .wide : .regular,
                        containerWidth: column, containerHeight: windowSize.height)
    }

    /// A sheet or cover, measured from inside. Size class is ignored: iPad
    /// form and page sheets report compact even when they are 700pt wide.
    static func sheet(size: CGSize) -> DSLayout {
        let tier: DSTier
        if !DS.isPad || size.width < DS.Layout.sheetRegularMin {
            tier = .compact
        } else {
            tier = size.width >= DS.Layout.wideMin ? .wide : .regular
        }
        return DSLayout(tier: tier, containerWidth: size.width, containerHeight: size.height)
    }

    /// For #Previews, which may run on an iPhone canvas: resolves as an iPad
    /// window of this size would, without looking at the device or size
    /// class.
    static func preview(width: CGFloat, height: CGFloat, chrome: DSChrome = .bottomBar) -> DSLayout {
        let column = max(0, width - chrome.width)
        guard width >= DS.Layout.regularWindowMin else {
            return DSLayout(tier: .compact, containerWidth: column, containerHeight: height)
        }
        return DSLayout(tier: column >= DS.Layout.wideMin ? .wide : .regular,
                        containerWidth: column, containerHeight: height)
    }

    private static func scaled(_ value: CGFloat) -> CGFloat {
        (value * 1.15 * 2).rounded() / 2
    }
}

// MARK: - Environment

extension EnvironmentValues {
    /// The layout every screen adapts to. RootView sets it for the window,
    /// `.dsLayoutRoot()` for a sheet, `.dsPopover` for a popover.
    @Entry var dsLayout: DSLayout = .compact
    /// Which navigation chrome the window is showing.
    @Entry var dsChrome: DSChrome = .bottomBar
    /// Multiplies callout, ghost and fault-ring sizes over a 3D viewport, for
    /// viewports far larger than a phone's.
    @Entry var dsAnnotationScale: CGFloat = 1
    /// Set by an embedded pane whose host already shows the rest timer, so
    /// `restTimerInset()` inside it adds nothing.
    @Entry var restTimerInsetSuppressed: Bool = false
}

// MARK: - Device & metrics

extension DS {
    static var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    /// "iPad" or "iPhone", for copy that names the device. iPhone copy stays
    /// byte-identical.
    static var deviceNoun: String { isPad ? "iPad" : "iPhone" }

    enum Layout {
        /// Content column at which the two-pane layouts take over.
        static let wideMin: CGFloat = 900
        /// Narrowest window that may be regular.
        static let regularWindowMin: CGFloat = 600
        /// Narrowest sheet that may be regular.
        static let sheetRegularMin: CGFloat = 560

        static let contentMaxWidth: CGFloat = 960
        static let columnWidth: CGFloat = 680
        static let readableWidth: CGFloat = 600
        static let formWidth: CGFloat = 560
        static let dashboardMaxWidth: CGFloat = 1240
        static let ctaMaxWidth: CGFloat = 400
        static let popoverWidth: CGFloat = 380
        static let inspectorMin: CGFloat = 360
        static let inspectorMax: CGFloat = 420
        static let sidebarExpanded: CGFloat = 260
        static let sidebarRail: CGFloat = 84
        static let paneRadius: CGFloat = 26
        static let gridCardMin: CGFloat = 180
        static let gridCardMax: CGFloat = 240
    }

    /// `n` equal flexible grid columns.
    static func flexibleColumns(_ n: Int, spacing: CGFloat) -> [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: max(1, n))
    }
}

// MARK: - Modifiers

extension View {
    /// The tier's horizontal gutter: 20 in compact, exactly as today.
    func dsGutter(_ edges: Edge.Set = .horizontal) -> some View {
        modifier(DSGutter(edges: edges))
    }

    /// In regular, caps the content at `maxWidth` and places it in the full
    /// width; in compact it changes nothing.
    func dsReadable(_ maxWidth: CGFloat, alignment: Alignment = .center) -> some View {
        modifier(DSReadable(maxWidth: maxWidth, alignment: alignment))
    }

    /// Caps a full-width call to action in regular, so a WideButton never
    /// stretches across a 1000pt column.
    func dsCTA(_ maxWidth: CGFloat = DS.Layout.ctaMaxWidth, alignment: Alignment = .center) -> some View {
        modifier(DSReadable(maxWidth: maxWidth, alignment: alignment))
    }

    /// The app's one pane material: the sidebar, the Today pane, inspectors
    /// and rails all sit on it. Unconditional — use it inside regular
    /// branches.
    func dsPane(radius: CGFloat = DS.Layout.paneRadius, fill: Color = DS.surface) -> some View {
        background {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(fill)
                .overlay(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .strokeBorder(DS.silver.opacity(0.08), lineWidth: 1)
                )
        }
    }

    /// Selection (a chosen row, the open preset), never activation. Regular
    /// only.
    func dsSelected(_ isOn: Bool, radius: CGFloat) -> some View {
        modifier(DSSelected(isOn: isOn, radius: radius))
    }

    /// Pointer hover on iPad; nothing on iPhone. `radius` nil hovers a
    /// capsule. Pass `.lift` for cards.
    func dsHover(_ effect: HoverEffect = .highlight, radius: CGFloat? = nil) -> some View {
        modifier(DSHover(effect: effect, radius: radius))
    }

    /// ⌘[ and Esc run `action` on iPad — the back chevron of a pushed screen,
    /// or a sheet's close.
    func dsBackShortcuts(_ action: @escaping () -> Void) -> some View {
        modifier(DSBackShortcuts(action: action))
    }

    /// For sheet and cover roots: on iPad, measures its own size and resolves
    /// `DSLayout.sheet(size:)` for everything inside. Draws nothing until the
    /// first measurement, so the content's state is only ever created once.
    /// Passes straight through on iPhone. Not for `.fitted` sheets or
    /// popovers — inject `layout.with(containerWidth:)` there instead.
    func dsLayoutRoot() -> some View {
        modifier(DSLayoutRoot())
    }

    /// How a sheet sizes itself in regular. Apply it on the sheet's content,
    /// outside `.dsLayoutRoot()`, so it reads the presenting window's tier.
    /// Does nothing in compact, where the existing detents stay in charge.
    func dsSheetSizing(_ sizing: DSSheetSizing) -> some View {
        modifier(DSSheetSizingModifier(sizing: sizing))
    }

    /// An anchored popover on iPad, for what is a small sheet on iPhone.
    /// Lock the style at tap time — `if layout.isRegular { popoverItem = x }
    /// else { sheetItem = x }` — and leave the compact `.sheet` where it is.
    func dsPopover<Item: Identifiable, C: View>(
        item: Binding<Item?>,
        width: CGFloat = DS.Layout.popoverWidth,
        arrowEdge: Edge? = nil,
        @ViewBuilder content: @escaping (Item) -> C
    ) -> some View {
        modifier(DSPopover(item: item, width: width, arrowEdge: arrowEdge, popover: content))
    }

    /// A full-screen cover in compact; a page sheet that can't be swiped
    /// away in regular. The style is chosen while nothing is presented, so
    /// resizing the window mid-edit never swaps the presentation.
    func dsCover<C: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> C) -> some View {
        modifier(DSCover(isPresented: isPresented, cover: content))
    }
}

enum DSSheetSizing: Equatable {
    case form
    case page
    /// A form sheet as tall as its content and exactly this wide.
    case fitted(width: CGFloat)
}

private struct DSGutter: ViewModifier {
    var edges: Edge.Set
    @Environment(\.dsLayout) private var layout

    func body(content: Content) -> some View {
        content.padding(edges, layout.gutter)
    }
}

private struct DSReadable: ViewModifier {
    var maxWidth: CGFloat
    var alignment: Alignment
    @Environment(\.dsLayout) private var layout

    // On iPad, a frame with every bound nil in compact keeps the view one
    // identity across a tier change (Split View resizing). It isn't a true
    // no-op, though: a child that rounds a fraction of a point past its
    // proposal gets centred, shifting it by a pixel, so the phone, which
    // never changes tier, skips the frames altogether.
    @ViewBuilder
    func body(content: Content) -> some View {
        if DS.isPad {
            content
                .frame(maxWidth: layout.isRegular ? maxWidth : nil, alignment: .leading)
                .frame(maxWidth: layout.isRegular ? .infinity : nil, alignment: alignment)
        } else {
            content
        }
    }
}

private struct DSSelected: ViewModifier {
    var isOn: Bool
    var radius: CGFloat
    @Environment(\.dsLayout) private var layout

    func body(content: Content) -> some View {
        let shows = isOn && layout.isRegular
        content
            .background {
                if shows {
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .fill(DS.selectionFill)
                }
            }
            .overlay {
                if shows {
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .strokeBorder(DS.selectionStroke, lineWidth: 1.5)
                }
            }
    }
}

private struct DSHover: ViewModifier {
    var effect: HoverEffect
    var radius: CGFloat?

    func body(content: Content) -> some View {
        if DS.isPad {
            content
                .contentShape(.hoverEffect, shape)
                .hoverEffect(effect)
        } else {
            content
        }
    }

    private var shape: AnyShape {
        if let radius {
            AnyShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        } else {
            AnyShape(Capsule())
        }
    }
}

private struct DSBackShortcuts: ViewModifier {
    var action: () -> Void

    func body(content: Content) -> some View {
        if DS.isPad {
            content.background {
                // Invisible but live: a hidden() button would drop its
                // shortcut along with it.
                ZStack {
                    Button("Back", action: action)
                        .keyboardShortcut("[", modifiers: .command)
                    Button("Close", action: action)
                        .keyboardShortcut(.cancelAction)
                }
                .frame(width: 0, height: 0)
                .opacity(0)
                .accessibilityHidden(true)
                .allowsHitTesting(false)
            }
        } else {
            content
        }
    }
}

private struct DSLayoutRoot: ViewModifier {
    @State private var size: CGSize?

    func body(content: Content) -> some View {
        if DS.isPad {
            ZStack {
                if let size {
                    content.environment(\.dsLayout, .sheet(size: size))
                } else {
                    Color.clear
                }
            }
            // Measures the space offered, not the content, so a content
            // column that narrows itself can't feed back into its own tier.
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
        } else {
            content
        }
    }
}

private struct DSSheetSizingModifier: ViewModifier {
    var sizing: DSSheetSizing
    @Environment(\.dsLayout) private var layout

    func body(content: Content) -> some View {
        if layout.isRegular {
            switch sizing {
            case .form:
                content.presentationSizing(.form)
            case .page:
                content.presentationSizing(.page)
            case .fitted(let width):
                content
                    .frame(width: width)
                    .presentationSizing(.form.fitted(horizontal: false, vertical: true))
            }
        } else {
            content
        }
    }
}

private struct DSPopover<Item: Identifiable, C: View>: ViewModifier {
    @Binding var item: Item?
    var width: CGFloat
    var arrowEdge: Edge?
    var popover: (Item) -> C
    @Environment(\.dsLayout) private var layout

    func body(content: Content) -> some View {
        content.popover(item: $item, attachmentAnchor: .rect(.bounds), arrowEdge: arrowEdge) { item in
            popover(item)
                .frame(width: width)
                .presentationBackground(DS.surface)
                .presentationCompactAdaptation(.sheet)
                .environment(\.dsLayout, layout.with(containerWidth: width))
        }
    }
}

private struct DSCover<C: View>: ViewModifier {
    @Binding var isPresented: Bool
    var cover: () -> C
    @Environment(\.dsLayout) private var layout
    /// Locked while presented: a page sheet stays a page sheet even if the
    /// window narrows to compact under it, and vice versa.
    @State private var usesSheet = false

    func body(content: Content) -> some View {
        if DS.isPad {
            content
                .fullScreenCover(isPresented: Binding(
                    get: { isPresented && !usesSheet },
                    set: { isPresented = $0 }
                )) { cover() }
                .sheet(isPresented: Binding(
                    get: { isPresented && usesSheet },
                    set: { isPresented = $0 }
                )) {
                    cover()
                        .presentationSizing(.page)
                        .interactiveDismissDisabled()
                }
                .onChange(of: layout.isRegular, initial: true) { _, regular in
                    if !isPresented { usesSheet = regular }
                }
                .onChange(of: isPresented) { _, presented in
                    if !presented { usesSheet = layout.isRegular }
                }
        } else {
            content.fullScreenCover(isPresented: $isPresented, content: cover)
        }
    }
}

// MARK: - Columns

/// Which column of a `DSColumns` a child goes in. Nonisolated because Layout
/// reads it outside the main actor.
nonisolated private struct DSColumnKey: LayoutValueKey {
    static let defaultValue = 0
}

extension View {
    /// The column of the enclosing `DSColumns` this view is placed in;
    /// clamped to the columns there are, ignored when there is one.
    func dsColumn(_ index: Int) -> some View {
        layoutValue(key: DSColumnKey.self, value: index)
    }
}

/// Masonry columns that keep their children's identity across a 1 ↔ 2 column
/// switch. A conditional HStack/VStack would rebuild every child when the
/// window rotates or a Split View drags, dropping focus and restarting tasks;
/// here only the placement changes.
///
/// One column stacks every child in source order. Two or more place each child
/// under the previous one in its own `.dsColumn`, proposing a concrete column
/// width so wrapping content (FlowRow) always knows how wide it is.
struct DSColumns: Layout {
    var columns: Int
    var spacing: CGFloat = 24
    var rowSpacing: CGFloat = 28

    init(columns: Int, spacing: CGFloat = 24, rowSpacing: CGFloat = 28) {
        self.columns = max(1, columns)
        self.spacing = spacing
        self.rowSpacing = rowSpacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let frames = place(width: proposal.width, subviews: subviews)
        let width = proposal.width ?? frames.map(\.maxX).max() ?? 0
        let height = frames.map(\.maxY).max() ?? 0
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let frames = place(width: bounds.width, subviews: subviews)
        for (subview, frame) in zip(subviews, frames) {
            subview.place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                          anchor: .topLeading,
                          proposal: ProposedViewSize(width: frame.width, height: frame.height))
        }
    }

    /// Each child's frame, in order. A child that comes out zero-tall (an
    /// empty section) takes no spacing either.
    private func place(width: CGFloat?, subviews: Subviews) -> [CGRect] {
        let n = columns
        let columnWidth: CGFloat? = width.map { max(0, ($0 - CGFloat(n - 1) * spacing) / CGFloat(n)) }
        var tops = Array(repeating: CGFloat(0), count: n)
        var started = Array(repeating: false, count: n)
        var frames: [CGRect] = []
        frames.reserveCapacity(subviews.count)

        for subview in subviews {
            let column = n == 1 ? 0 : min(max(subview[DSColumnKey.self], 0), n - 1)
            let size = subview.sizeThatFits(ProposedViewSize(width: columnWidth, height: nil))
            let w = columnWidth ?? size.width
            let x = CGFloat(column) * (w + spacing)
            if size.height > 0 {
                if started[column] { tops[column] += rowSpacing }
                started[column] = true
            }
            frames.append(CGRect(x: x, y: tops[column], width: w, height: size.height))
            tops[column] += size.height
        }
        return frames
    }
}

// MARK: - Previews

/// Content-column sizes worth previewing, from the phone to the 13-inch with
/// a rail. `width` is the column; the sidebar, if any, is beside it.
enum DSPreviewDevice: String, CaseIterable, Identifiable {
    /// iPhone, or anything compact.
    case phone
    /// 13-inch half Split View.
    case split600
    /// iPad mini portrait.
    case mini660
    /// 11-inch portrait.
    case pad11Portrait750
    /// 13-inch portrait with the rail.
    case pad13Portrait940
    /// 13-inch landscape with the expanded sidebar.
    case pad13Landscape1110
    /// 13-inch landscape with the rail.
    case pad13Landscape1292

    var id: String { rawValue }

    var width: CGFloat {
        switch self {
        case .phone: return 375
        case .split600: return 600
        case .mini660: return 660
        case .pad11Portrait750: return 750
        case .pad13Portrait940: return 940
        case .pad13Landscape1110: return 1110
        case .pad13Landscape1292: return 1292
        }
    }

    var height: CGFloat {
        switch self {
        case .phone: return 812
        case .split600: return 1032
        case .mini660: return 1133
        case .pad11Portrait750: return 1180
        case .pad13Portrait940: return 1376
        case .pad13Landscape1110, .pad13Landscape1292: return 1032
        }
    }

    var chrome: DSChrome {
        switch self {
        case .phone: return .bottomBar
        case .pad13Landscape1110: return .sidebar(.expanded)
        default: return .sidebar(.rail)
        }
    }

    /// The layout a column this size resolves to.
    var layout: DSLayout {
        DSLayout.preview(width: width + chrome.width, height: height, chrome: chrome)
    }
}

extension View {
    /// Frames a #Preview at the device's content column and injects the
    /// layout and chrome it would get there.
    func dsPreview(_ device: DSPreviewDevice) -> some View {
        environment(\.dsLayout, device.layout)
            .environment(\.dsChrome, device.chrome)
            .frame(width: device.width, height: device.height)
            .background(DS.ink)
    }
}
