//
//  Icons.swift
//  GymWorkout
//
//  The design draws its chrome as inline SVG. Generic glyphs (chevron, heart,
//  search, transport) map 1:1 onto SF Symbols and are used as such — same
//  silhouette, better rendering and accessibility. Only the marks that carry
//  meaning specific to this app are drawn by hand below.
//

import SwiftUI

/// The muscle-activation affordance: a warm ring around a solid core. This is
/// the one control allowed to wear the activation colour, because it *opens*
/// muscle activation.
struct MuscleTargetIcon: View {
    var size: CGFloat = 14

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(DS.activationText, lineWidth: 1.4)
            Circle()
                .fill(DS.activation)
                .frame(width: size * (4 / 14), height: size * (4 / 14))
        }
        .frame(width: size, height: size)
    }
}

/// Orbit mark on the "PAUSED · DRAG TO ROTATE" chip.
struct OrbitIcon: View {
    var size: CGFloat = 12
    var color: Color = DS.silver.opacity(0.6)

    var body: some View {
        ZStack {
            Circle().strokeBorder(color, lineWidth: 1.2)
            Ellipse()
                .strokeBorder(color, lineWidth: 1.2)
                .frame(width: size * (4.4 / 12), height: size * (10 / 12))
        }
        .frame(width: size, height: size)
    }
}

/// The overflow control — three 3pt dots, as drawn in the header of 1c.
struct MoreDotsIcon: View {
    var body: some View {
        HStack(spacing: 2.5) {
            ForEach(0..<3, id: \.self) { _ in
                Circle()
                    .fill(DS.silver)
                    .frame(width: 3, height: 3)
            }
        }
    }
}

/// Tab-bar glyph: the tab's SF Symbol (see `AppTab.symbol(selected:)`), or
/// the design's rounded-square placeholder when none is given. `size` is the
/// frame; the symbol is drawn at 82% of it (22 → 18 on the bar, as always).
struct TabGlyph: View {
    var color: Color
    var symbol: String?
    var size: CGFloat = 22

    var body: some View {
        Group {
            if let symbol {
                Image(systemName: symbol)
                    .font(.system(size: (size * 0.82).rounded(), weight: .medium))
                    .foregroundStyle(color)
            } else {
                RoundedRectangle(cornerRadius: 7 * size / 22, style: .continuous)
                    .strokeBorder(color, lineWidth: 1.6)
            }
        }
        .frame(width: size, height: size)
    }
}
