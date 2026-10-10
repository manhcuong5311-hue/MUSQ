//
//  Effects.swift
//  GymWorkout
//
//  CSS radial-gradient equivalents.
//
//  The design leans heavily on elliptical radial gradients — both for the
//  viewport "studio" grounds and for the muscle-activation glows that sit over
//  the 3D renders in `screen` blend mode. SwiftUI's `RadialGradient` is
//  circular, so these draw a unit circle and scale it to the ellipse the CSS
//  asks for (`rx` is a fraction of the width, `ry` a fraction of the height).
//

import SwiftUI

/// One `radial-gradient(<rx> <ry> at <cx> <cy>, color, transparent <stop>)` layer.
///
/// `rx`/`ry` are fractions of the container's width/height, matching the CSS
/// percentage sizing. `stop` is where the colour reaches full transparency,
/// expressed as a fraction of the ellipse radius (CSS's `transparent 70%`).
struct RadialGlow: View {
    var color: Color
    var rx: CGFloat
    var ry: CGFloat
    var cx: CGFloat
    var cy: CGFloat
    var stop: CGFloat = 0.70
    /// The stage the fractions are measured in, within this view's own
    /// bounds; nil uses the whole view. Lets an iPad pane keep a glow on the
    /// phone-shaped stage its fractions were drawn for.
    var stage: CGRect? = nil

    /// Diameter of the unscaled base circle. Arbitrary — it cancels out.
    private let base: CGFloat = 200

    init(color: Color, rx: CGFloat, ry: CGFloat, cx: CGFloat, cy: CGFloat,
         stop: CGFloat = 0.70, in rect: CGRect? = nil) {
        self.color = color
        self.rx = rx
        self.ry = ry
        self.cx = cx
        self.cy = cy
        self.stop = stop
        self.stage = rect
    }

    var body: some View {
        GeometryReader { geo in
            let w = stage?.width ?? geo.size.width
            let h = stage?.height ?? geo.size.height
            let x0 = stage?.minX ?? 0
            let y0 = stage?.minY ?? 0
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: color, location: 0),
                            .init(color: color.opacity(0), location: stop)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: base / 2
                    )
                )
                .frame(width: base, height: base)
                .scaleEffect(
                    x: max(0.0001, (rx * w) / (base / 2)),
                    y: max(0.0001, (ry * h) / (base / 2)),
                    anchor: .center
                )
                .position(x: x0 + cx * w, y: y0 + cy * h)
        }
        .allowsHitTesting(false)
    }
}

/// The "studio" ground behind every 3D viewport:
/// `radial-gradient(<rx> <ry> at <cx> <cy>, inner, outer <stop>)`.
struct ViewportGround: View {
    var inner: Color
    var outer: Color
    var rx: CGFloat
    var ry: CGFloat
    var cx: CGFloat
    var cy: CGFloat
    var stop: CGFloat = 0.70
    /// Keeps the pool round on a frame much wider than tall: `rx` is taken
    /// of at most 1.2× the height instead of the full width, so an iPad
    /// pane's studio floor doesn't stretch into a flat band.
    var aspectLocked: Bool = false

    var body: some View {
        if aspectLocked {
            GeometryReader { geo in
                let w = max(geo.size.width, 1)
                ground(rx: rx * min(w, 1.2 * geo.size.height) / w)
            }
        } else {
            ground(rx: rx)
        }
    }

    private func ground(rx: CGFloat) -> some View {
        ZStack {
            outer
            RadialGlow(color: inner, rx: rx, ry: ry, cx: cx, cy: cy, stop: stop)
        }
    }
}

/// A stack of activation glows composited in `screen` blend mode, exactly as
/// the design layers them over a render. Never interactive.
struct ActivationGlowLayer: View {
    struct Glow {
        var color: Color
        var rx: CGFloat
        var ry: CGFloat
        var cx: CGFloat
        var cy: CGFloat

        init(_ color: Color, rx: CGFloat, ry: CGFloat, cx: CGFloat, cy: CGFloat) {
            self.color = color
            self.rx = rx
            self.ry = ry
            self.cx = cx
            self.cy = cy
        }
    }

    var glows: [Glow]
    /// The primary 3D view breathes its activation overlay (`pulseAct`, 2.8s).
    var pulses: Bool = false

    @State private var dim = false

    var body: some View {
        ZStack {
            ForEach(Array(glows.enumerated()), id: \.offset) { _, g in
                RadialGlow(color: g.color, rx: g.rx, ry: g.ry, cx: g.cx, cy: g.cy)
            }
        }
        .blendMode(.screen)
        .opacity(pulses ? (dim ? 0.45 : 0.85) : 1)
        .allowsHitTesting(false)
        .onAppear {
            guard pulses else { return }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                dim = true
            }
        }
    }
}
