//
//  ModelLook.swift
//  GymWorkout
//
//  How the 3D lifter is drawn, picked in Settings (2026-10-25). The black of
//  the files read well on the web guide but too dark on a phone, so the
//  viewer chooses: the web's black, a charcoal (the default), a lighter grey,
//  or black on a pale ground. Only the live model follows it; the library's
//  tiles are photos and stay as they were shot.
//

import SwiftUI
import UIKit

enum ModelLook: String, CaseIterable, Identifiable {
    case black, charcoal, light, highContrast

    static let storageKey = "trainer.modelLook"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .black: return "Black"
        case .charcoal: return "Charcoal"
        case .light: return "Light"
        case .highContrast: return "High contrast"
        }
    }

    var detail: String {
        switch self {
        case .black: return "The deep black of the web guide, with a soft sheen."
        case .charcoal: return "A dark grey with lit edges, easy to read on a phone."
        case .light: return "A lighter grey, for bright rooms and low screen brightness."
        case .highContrast: return "A black lifter on a pale ground."
        }
    }

    /// The skin's colour on stage; nil keeps the files' near-black.
    var skin: UIColor? {
        switch self {
        case .black, .highContrast: return nil
        case .charcoal: return UIColor(hex: 0x4A4E55)
        case .light: return UIColor(hex: 0x7A7F87)
        }
    }

    /// The male shorts' colour on stage (2026-10-28, the owner's pick). The
    /// files dress the lifter in shorts as near-black as his skin, so every
    /// look painted them the skin's colour and the hips read as one bare mass,
    /// the glutes' red showing through it. A navy darker than the skin (a
    /// cool slate on the black skins) makes body, clothing and the worked
    /// muscles three separate layers, and keeps the red the only warm thing.
    var shorts: UIColor {
        switch self {
        case .charcoal, .light: return UIColor(hex: 0x1C2738)
        case .black, .highContrast: return UIColor(hex: 0x263445)
        }
    }

    /// The skin's specular. Matte where the skin is lifted or the ground does
    /// the work; the web's sheen on the black, which is what shows its muscle
    /// shapes there.
    var specular: Float {
        self == .black ? 0.5 : 0.1
    }

    /// Whether two back rims edge the figure next to the studio light.
    var rims: Bool {
        self == .charcoal || self == .light
    }

    /// The skin as a flat swatch for the Settings picker.
    var swatch: Color {
        skin.map { Color(uiColor: $0) } ?? Color(hex: 0x141518)
    }

    /// The ground behind the model: the web's grey studio, pale for high
    /// contrast.
    var groundInner: Color {
        self == .highContrast ? Color(hex: 0xDDE0E5) : DS.modelGroundInner
    }

    var groundOuter: Color {
        self == .highContrast ? Color(hex: 0x9DA2AA) : DS.modelGroundOuter
    }
}

private extension UIColor {
    convenience init(hex: UInt32) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255, green: CGFloat((hex >> 8) & 0xFF) / 255,
                  blue: CGFloat(hex & 0xFF) / 255, alpha: 1)
    }
}
