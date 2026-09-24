//
//  RenderSlot.swift
//  GymWorkout
//
//  Every 3D area in the design is an `<image-slot>` — a replaceable region.
//  Here it resolves to an asset-catalog image when one exists under the slot's
//  name, and otherwise leaves the ground bare so the marked embed region shows
//  through. Drop renders into Assets.xcassets using the slot id, or swap the
//  body for a `RealityView` where a live model is wanted.
//

import SwiftUI

struct RenderSlot: View {
    /// Slot identifier from the design, e.g. `ex3d-viewport`, `home-continue`.
    var id: String
    var contentMode: ContentMode = .fill

    var body: some View {
        if UIImage(named: id) != nil {
            Image(id)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            Color.clear
        }
    }
}

/// The dashed "replaceable region" marker the primary viewport draws over
/// itself while `showViewportGuides` is on.
struct ViewportGuides: View {
    var caption: String

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        DS.silver.opacity(0.13),
                        style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                    )
                    .padding(10)

                Text(caption)
                    .font(.mono(8.5, .medium))
                    .trackingEm(0.12, size: 8.5)
                    .foregroundStyle(DS.silver.opacity(0.32))
                    .padding(.leading, 20)
                    .padding(.top, 20)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .allowsHitTesting(false)
    }
}

/// A 3D viewport: studio ground, replaceable render, activation glow, optional
/// embed guides, and whatever chrome the screen layers on top.
struct Viewport<Overlay: View>: View {
    var slot: String
    /// usdz resource name. When set, the slot renders a live RealityKit scene
    /// instead of a flat render.
    var model: String? = nil
    /// How that model should be presented.
    var framing: ModelFraming = .standing
    /// Playback rate for that model.
    var speed: Float = 1
    var inner: Color = DS.viewportInner
    var outer: Color = DS.viewportOuter
    var rx: CGFloat = 1.20
    var ry: CGFloat = 0.72
    var cx: CGFloat = 0.50
    var cy: CGFloat = 0.80
    var stop: CGFloat = 0.70
    var glows: [ActivationGlowLayer.Glow] = []
    var pulses: Bool = false
    var showsGuides: Bool = false
    /// Joints of the live model to project for the overlay.
    var tracker: JointTracker? = nil
    var cornerRadius: CGFloat = DS.Metric.viewportRadius
    @ViewBuilder var overlay: () -> Overlay

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ViewportGround(inner: inner, outer: outer,
                               rx: rx, ry: ry, cx: cx, cy: cy, stop: stop)

                if let model {
                    USDZViewport(resource: model, framing: framing, speed: speed,
                                 tracker: tracker)
                } else {
                    RenderSlot(id: slot)
                }

                if !glows.isEmpty {
                    ActivationGlowLayer(glows: glows, pulses: pulses)
                }

                if showsGuides {
                    ViewportGuides(
                        caption: "RK VIEWPORT · \(Int(geo.size.width))×\(Int(geo.size.height)) · REPLACEABLE"
                    )
                }

                overlay()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

extension Viewport where Overlay == EmptyView {
    init(
        slot: String,
        model: String? = nil,
        framing: ModelFraming = .standing,
        speed: Float = 1,
        inner: Color = DS.viewportInner,
        outer: Color = DS.viewportOuter,
        rx: CGFloat = 1.20,
        ry: CGFloat = 0.72,
        cx: CGFloat = 0.50,
        cy: CGFloat = 0.80,
        stop: CGFloat = 0.70,
        glows: [ActivationGlowLayer.Glow] = [],
        pulses: Bool = false,
        showsGuides: Bool = false,
        cornerRadius: CGFloat = DS.Metric.viewportRadius
    ) {
        self.init(slot: slot, model: model, framing: framing, speed: speed, inner: inner, outer: outer, rx: rx, ry: ry,
                  cx: cx, cy: cy, stop: stop, glows: glows, pulses: pulses,
                  showsGuides: showsGuides, cornerRadius: cornerRadius,
                  overlay: { EmptyView() })
    }
}
