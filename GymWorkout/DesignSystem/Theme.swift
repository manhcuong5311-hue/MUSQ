//
//  Theme.swift
//  GymWorkout
//
//  Design tokens transcribed from `Anatomy Trainer iOS.dc.html`.
//
//  The palette is deliberately narrow: an ink/silver pair that follows the
//  system appearance (near-black ground with near-white content in Dark Mode,
//  near-white ground with near-black content in Light Mode), and warm red
//  reserved exclusively for muscle activation. Do not use `activation` for
//  buttons, links or selection — that separation is the whole point of the
//  system. `silver` doubles as the app's general foreground colour, so every
//  label opacity (`DS.silver.opacity(...)`) inverts correctly with the ground.
//

import SwiftUI

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }

    /// A colour that switches hex value with the system's Light/Dark appearance.
    init(light: UInt32, dark: UInt32, opacity: Double = 1) {
        self.init(uiColor: UIColor { trait in
            UIColor(Color(hex: trait.userInterfaceStyle == .dark ? dark : light,
                          opacity: opacity))
        })
    }
}

enum DS {

    // MARK: - Ground & surfaces

    /// Screen background.
    static let ink = Color(light: 0xF5F6F7, dark: 0x08090A)
    /// Sheets, panels, note cards.
    static let surface = Color(light: 0xFFFFFF, dark: 0x15181C)
    /// Muscle-group tiles.
    static let surfaceAlt = Color(light: 0xEDEEF0, dark: 0x14161A)
    /// Image wells, cue cards, search field.
    static let surfaceDim = Color(light: 0xEFF0F2, dark: 0x15171A)
    /// Avatar well.
    static let surfaceRaised = Color(light: 0xFFFFFF, dark: 0x1B1E22)
    /// Tab bar ground (sits under a blur).
    static let chrome = Color(light: 0xFAFAFB, dark: 0x0B0C0E, opacity: 0.92)

    /// The 3D viewport's "studio" radial ground — bright centre, dimmer edge,
    /// in either appearance.
    static let viewportInner = Color(light: 0xFFFFFF, dark: 0x1E2126)
    static let viewportOuter = Color(light: 0xEDEEF0, dark: 0x0A0B0D)

    /// Translucent glass fill for chips and pills that float over a viewport.
    static func glass(_ opacity: Double = 0.66) -> Color {
        Color(light: 0xFFFFFF, dark: 0x0C0D0F, opacity: opacity)
    }

    /// The gradient a card fades into behind its own caption, so the caption's
    /// `silver`-based text always sits on ground of the right polarity.
    static func cardFade(_ opacity: Double = 1) -> Color {
        Color(light: 0xFFFFFF, dark: 0x060708, opacity: opacity)
    }

    // MARK: - Interactive accent / content

    /// The only interactive accent, and the general foreground colour — near-
    /// white on the dark ground, near-black on the light one.
    static let silver = Color(light: 0x08090A, dark: 0xF5F6F7)

    // MARK: - Muscle activation (never interactive)

    /// Primary activation.
    static let activation = Color(hex: 0xFF5622)
    /// Secondary activation, always used at partial opacity.
    static let activationSoft = Color(hex: 0xFF8C3C)
    /// Activation label text.
    static let activationText = Color(hex: 0xFF7A45)
    /// Activation text on a tinted chip.
    static let activationTint = Color(hex: 0xFFB599)
    /// Intermediate difficulty dot.
    static let difficultyMid = Color(hex: 0xFF9A6B)

    // MARK: - Form faults (never interactive)

    /// The yellow "ghost" limbs that draw a common mistake over the model.
    /// Kept apart from `activation` so a mistake never reads as a worked
    /// muscle.
    static let fault = Color(hex: 0xFFC61A)
    /// Underlay that keeps `fault` lines legible on the light ground.
    static let faultShade = Color(hex: 0x5C3D00, opacity: 0.45)

    // MARK: - Metrics

    enum Metric {
        /// Horizontal gutter for list/section content.
        static let gutter: CGFloat = 20
        /// Corner radius of a full-bleed 3D viewport.
        static let viewportRadius: CGFloat = 26
        /// Corner radius of the bottom sheets.
        static let sheetRadius: CGFloat = 26
        /// Inset of the viewport from the screen edge.
        static let viewportInset: CGFloat = 10
    }
}

// MARK: - Typography

extension Font {
    /// SF Text / system UI face used for all prose and titles.
    static func ui(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }

    /// The monospaced face used for every label, meta line and metric.
    /// Always pair with `.tracking(...)` — the design letter-spaces all of them.
    static func mono(_ size: CGFloat, _ weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
}

extension View {
    /// Approximates a CSS `line-height: <multiple>` for a given font size.
    /// SwiftUI's default leading is ~1.2×, so we add only the difference.
    func cssLineHeight(_ size: CGFloat, _ multiple: CGFloat) -> some View {
        lineSpacing(max(0, size * (multiple - 1.2)))
    }

    /// CSS `letter-spacing: <em>em` at a given font size.
    func trackingEm(_ em: CGFloat, size: CGFloat) -> some View {
        tracking(em * size)
    }
}
