//
//  IslandStyle.swift
//  Shared
//
//  The look of the Dynamic Island, Lock Screen activities and widgets,
//  picked by the owner/user and shared through the App Group:
//    bold    — black, vivid orange ring, big numbers (MUSQ brand)
//    glass   — translucent material, a colour per metric (water blue, kcal orange)
//    minimal — monochrome, thin rings, typographic
//

import Foundation

nonisolated enum IslandStyle: String, Codable, CaseIterable, Hashable, Sendable {
    case bold
    case glass
    case minimal

    static let `default`: IslandStyle = .bold

    var title: String {
        switch self {
        case .bold: String(localized: "islandStyle.bold", defaultValue: "Bold", comment: "Island style name")
        case .glass: String(localized: "islandStyle.glass", defaultValue: "Glass", comment: "Island style name")
        case .minimal: String(localized: "islandStyle.minimal", defaultValue: "Minimal", comment: "Island style name")
        }
    }

    /// The style in the shared suite (what widgets and activities draw).
    static var current: IslandStyle {
        get {
            AppGroup.defaults.string(forKey: AppGroup.Key.islandStyle)
                .flatMap(IslandStyle.init(rawValue:)) ?? .default
        }
        set { AppGroup.defaults.set(newValue.rawValue, forKey: AppGroup.Key.islandStyle) }
    }

    /// App only, call once at launch: copies a DEBUG `-island.style glass`
    /// launch argument into the shared suite (the extension never sees the
    /// app's launch arguments). Returns true when it changed the style.
    @discardableResult
    static func applyLaunchArgument() -> Bool {
        #if DEBUG
        if let raw = UserDefaults.standard.volatileDomain(forName: UserDefaults.argumentDomain)[AppGroup.Key.islandStyle] as? String,
           let style = IslandStyle(rawValue: raw), style != current {
            current = style
            return true
        }
        #endif
        return false
    }
}
