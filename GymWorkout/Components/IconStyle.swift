//
//  IconStyle.swift
//  GymWorkout
//
//  The icon set the main glyphs draw with (2026-11-28, owner: SF Symbols
//  "look too simple, not premium"). Compared with Phosphor Duotone, the
//  owner picked Solar Bold Duotone (480 Design, CC BY 4.0: the credit is in
//  Help & FAQ). The SVGs live in Assets.xcassets/Icons as template images
//  "ico-solar-<role>"; any glyph with no role stays an SF Symbol.
//  `-icons.style sf` shows the old look for comparisons.
//

import SwiftUI

enum IconStyle: String, CaseIterable {
    case sf, solar
    static let storageKey = "icons.style"

    fileprivate var prefix: String? {
        switch self {
        case .sf: return nil
        case .solar: return "ico-solar-"
        }
    }

    /// SF Symbol name → role in the drawn sets.
    fileprivate static let roles: [String: String] = [
        "sun.max": "today", "sun.max.fill": "today",
        "dumbbell": "train", "dumbbell.fill": "train",
        "list.bullet.rectangle.portrait": "exercises", "list.bullet.rectangle.portrait.fill": "exercises",
        "figure.arms.open": "progress",
        "person.2": "friends", "person.2.fill": "friends",
        "person.crop.circle": "profile", "person.crop.circle.fill": "profile",
        "camera.viewfinder": "scan",
        "fork.knife": "food",
        "drop.fill": "water",
        "figure.walk": "walk",
        "bed.double.fill": "sleep",
        "mic.fill": "mic",
        "checklist": "yourday",
        "flame.fill": "plan",
        "scalemass.fill": "weight",
        "bolt.fill": "protein",
        "takeoutbag.and.cup.and.straw.fill": "carbs",
        "leaf.fill": "fiber",
    ]
}

/// A glyph in the chosen icon style: the SF Symbol, or the same role from
/// the drawn set. `size` is the SF Symbol's point size; drawn icons get a
/// square a little larger, since they carry no font padding.
struct StyledSymbol: View {
    var name: String
    var size: CGFloat
    var weight: Font.Weight = .semibold
    /// Overrides the role the name maps to (fat shares water's drop).
    var role: String? = nil

    @AppStorage(IconStyle.storageKey) private var style: IconStyle = .solar

    var body: some View {
        if let prefix = style.prefix, let role = role ?? IconStyle.roles[name] {
            Image(prefix + role)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size * 1.25, height: size * 1.25)
        } else {
            Image(systemName: name)
                .font(.system(size: size, weight: weight))
        }
    }
}
