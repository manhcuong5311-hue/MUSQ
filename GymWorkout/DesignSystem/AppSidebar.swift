//
//  AppSidebar.swift
//  GymWorkout
//
//  The iPad's navigation in a regular-width window, in place of the bottom
//  bar: a floating pane card down the leading edge. Expanded it names the
//  tabs; as a rail it keeps only the glyphs, for windows that need the width.
//  RootView picks the style and the user can flip it (⌃⌘S). The tab roots
//  never know: they still call `TabBarView`, which draws only the rest timer
//  and the ad while the sidebar is up.
//

import SwiftUI

struct AppSidebar: View {
    @Binding var selection: AppTab
    var style: DSChrome.SidebarStyle
    var onToggle: () -> Void
    /// False when the window is too narrow for the expanded card, so the
    /// rail doesn't offer a toggle that can't do anything.
    var canExpand: Bool = true

    @Environment(Purchases.self) private var purchases
    @Environment(Paywall.self) private var paywall
    /// Per-tab counters, bumped when a tab is chosen: the sidebar stays on
    /// screen across switches, so only the newly chosen glyph should bounce.
    @State private var bounces: [AppTab: Int] = [:]
    /// Whether this window is narrower than the screen — Stage Manager's
    /// windowed mode, where the window controls sit over the top-leading
    /// corner.
    @State private var isWindowed = false

    var body: some View {
        Group {
            switch style {
            case .expanded: expanded
            case .rail: rail
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .dsPane(radius: DS.Layout.paneRadius)
        // 240 of the expanded 260, 64 of the rail's 84.
        .padding(10)
        .onGeometryChange(for: CGSize.self) { $0.size } action: { _ in
            isWindowed = Self.windowIsSmallerThanScreen
        }
        .onChange(of: selection) { _, tab in
            bounces[tab, default: 0] += 1
        }
        .background(toggleShortcut)
    }

    // MARK: - Expanded

    private var expanded: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("MUSQ")
                        .font(.mono(13, .bold))
                        .trackingEm(0.24, size: 13)
                        .foregroundStyle(DS.silver)
                    SectionEyebrow(text: Self.today, color: DS.silver.opacity(0.45))
                }
                Spacer(minLength: 8)
                toggleButton
            }
            .padding(.horizontal, 14)

            VStack(spacing: 4) {
                ForEach(AppTab.allCases) { tab in
                    item(tab) { isOn in
                        TabItemLabel(tab: tab, isOn: isOn, layout: .row, bounce: bounces[tab] ?? 0)
                            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .dsHover(.highlight, radius: 12)
                    }
                }
            }
            .padding(.top, 28)

            Spacer(minLength: 16)

            if !purchases.isPremium {
                premiumRow
            }
        }
        .padding(.top, 22 + windowedTopPadding)
        .padding(.horizontal, 10)
        .padding(.bottom, 12)
    }

    private var premiumRow: some View {
        Button {
            paywall.show(.profile)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "crown")
                    .font(.system(size: 15, weight: .medium))
                    .frame(width: 20, height: 20)
                Text("Go Premium")
                    .font(.ui(15, .medium))
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(DS.silver.opacity(0.35))
            }
            .foregroundStyle(DS.silver.opacity(0.75))
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(DS.silver.opacity(0.10), lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .dsHover(.highlight, radius: 12)
    }

    // MARK: - Rail

    private var rail: some View {
        VStack(spacing: 0) {
            Text("M")
                .font(.mono(15, .bold))
                .foregroundStyle(DS.silver)
                .accessibilityLabel("MUSQ")

            if canExpand {
                toggleButton
                    .padding(.top, 12)
            }

            VStack(spacing: 10) {
                ForEach(AppTab.allCases) { tab in
                    item(tab) { isOn in
                        TabItemLabel(tab: tab, isOn: isOn, layout: .rail, bounce: bounces[tab] ?? 0)
                            .frame(width: 64)
                            .contentShape(Rectangle())
                            .dsHover(.highlight, radius: 12)
                    }
                }
            }
            .padding(.top, 24)
        }
        .padding(.top, 22 + windowedTopPadding)
        .frame(width: 64)
    }

    // MARK: - Pieces

    private func item<Label: View>(_ tab: AppTab, @ViewBuilder label: (Bool) -> Label) -> some View {
        let isOn = tab == selection
        let index = AppTab.allCases.firstIndex(of: tab) ?? 0
        return Button {
            selection = tab
        } label: {
            label(isOn)
        }
        .buttonStyle(.plain)
        .keyboardShortcut(KeyEquivalent(Character(String(index + 1))), modifiers: .command)
        .accessibilityLabel(tab.rawValue)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }

    private var toggleButton: some View {
        CircleIconButton(diameter: 32, action: onToggle) {
            Image(systemName: "sidebar.left")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(DS.silver.opacity(0.7))
        }
        .accessibilityLabel(style == .expanded ? "Collapse sidebar" : "Expand sidebar")
    }

    /// ⌃⌘S works in either style, even where the rail hides its button.
    private var toggleShortcut: some View {
        Button("Toggle Sidebar", action: onToggle)
            .keyboardShortcut("s", modifiers: [.control, .command])
            .frame(width: 0, height: 0)
            .opacity(0)
            .accessibilityHidden(true)
            .allowsHitTesting(false)
    }

    /// Clears Stage Manager's window controls, which overlap the top of a
    /// window narrower than the screen.
    private var windowedTopPadding: CGFloat { isWindowed ? 28 : 0 }

    private static var windowIsSmallerThanScreen: Bool {
        guard let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene }).first,
              let window = scene.keyWindow ?? scene.windows.first else { return false }
        let screen = scene.screen.bounds.size
        return window.bounds.width < screen.width - 1 || window.bounds.height < screen.height - 1
    }

    /// "THU · 9 OCT".
    private static var today: String {
        let date = Date()
        let weekday = date.formatted(.dateTime.weekday(.abbreviated))
        let day = date.formatted(.dateTime.day().month(.abbreviated))
        return "\(weekday) · \(day)".uppercased()
    }
}

#Preview("Sidebar · expanded") {
    @Previewable @State var tab: AppTab = .train
    HStack(spacing: 0) {
        AppSidebar(selection: $tab, style: .expanded, onToggle: {})
            .frame(width: DS.Layout.sidebarExpanded)
        Spacer()
    }
    .environment(Purchases())
    .environment(Paywall())
    .dsPreview(.pad13Landscape1110)
}

#Preview("Sidebar · rail") {
    @Previewable @State var tab: AppTab = .muscles
    HStack(spacing: 0) {
        AppSidebar(selection: $tab, style: .rail, onToggle: {})
            .frame(width: DS.Layout.sidebarRail)
        Spacer()
    }
    .environment(Purchases())
    .environment(Paywall())
    .dsPreview(.pad13Portrait940)
}
