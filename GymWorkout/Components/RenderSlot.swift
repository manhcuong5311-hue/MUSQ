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
///
/// With `stageAspect` set (iPad panes far wider than the phone's), the ground
/// fills the pane while the model, glows, guides and `overlay` share one
/// centred stage of that aspect, so tracked points, callout fractions and
/// glows all stay in the space they were authored in. `chrome` is laid over
/// the whole pane, and the rotate drag works anywhere on it. Without it the
/// view is exactly the phone's.
struct Viewport<Overlay: View, Chrome: View>: View {
    var slot: String
    /// usdz resource name. When set, the slot renders a live RealityKit scene
    /// instead of a flat render.
    var model: String? = nil
    /// How that model should be presented.
    var framing: ModelFraming = .standing
    /// Playback rate for that model.
    var speed: Float = 1
    /// Holds the model's clip at this many seconds in, for still renders.
    var still: TimeInterval? = nil
    /// Extra turn of that model about the vertical, in radians; changes
    /// animate.
    var turn: Float = 0
    /// Share of the viewport's height a panel covers at the bottom, for the
    /// model to rise clear of.
    var roomBelow: Float = 0
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
    /// Width over height of the stage the model and overlay live in; nil
    /// makes the whole viewport the stage.
    var stageAspect: CGFloat? = nil
    /// A full turn takes a swipe this wide at most (see `USDZViewport`).
    var dragReferenceWidth: CGFloat? = nil
    @ViewBuilder var overlay: () -> Overlay
    @ViewBuilder var chrome: () -> Chrome

    /// The model's turn when the whole pane drives it (staged layout only).
    @State private var paneYaw: Double = 0
    @State private var paneDragStartYaw: Double = 0

    var body: some View {
        if let stageAspect {
            staged(aspect: stageAspect)
        } else {
            GeometryReader { geo in
                ZStack {
                    ViewportGround(inner: inner, outer: outer,
                                   rx: rx, ry: ry, cx: cx, cy: cy, stop: stop)

                    stage(size: geo.size, yaw: nil)

                    chrome()
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }

    /// Render, glows, guides and overlay, in the space `size` describes.
    @ViewBuilder
    private func stage(size: CGSize, yaw: Double?) -> some View {
        if let model {
            USDZViewport(resource: model, framing: framing, speed: speed,
                         still: still, turn: turn, roomBelow: roomBelow,
                         tracker: tracker, dragReferenceWidth: dragReferenceWidth,
                         externalYaw: yaw)
        } else {
            RenderSlot(id: slot)
        }

        if !glows.isEmpty {
            ActivationGlowLayer(glows: glows, pulses: pulses)
        }

        if showsGuides {
            ViewportGuides(
                caption: "RK VIEWPORT · \(Int(size.width))×\(Int(size.height)) · REPLACEABLE"
            )
        }

        overlay()
    }

    private func staged(aspect: CGFloat) -> some View {
        GeometryReader { geo in
            let fit = Self.fit(aspect: aspect, in: geo.size)
            ZStack {
                ViewportGround(inner: inner, outer: outer,
                               rx: rx, ry: ry, cx: cx, cy: cy, stop: stop,
                               aspectLocked: true)

                ZStack { stage(size: fit, yaw: model == nil ? nil : paneYaw) }
                    .frame(width: fit.width, height: fit.height)

                chrome()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            // The drag covers the pane, not just the stage: on a wide iPad
            // viewport most of the surface is the margin beside the lifter.
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged { value in
                        let width = min(geo.size.width, dragReferenceWidth ?? geo.size.width)
                        let turns = Double(value.translation.width / max(width, 1))
                        paneYaw = paneDragStartYaw + turns * 2 * .pi
                    }
                    .onEnded { _ in paneDragStartYaw = paneYaw }
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    /// The largest `aspect` rectangle that fits `size`.
    private static func fit(aspect: CGFloat, in size: CGSize) -> CGSize {
        guard aspect > 0, size.width > 0, size.height > 0 else { return size }
        if size.width / size.height > aspect {
            return CGSize(width: size.height * aspect, height: size.height)
        }
        return CGSize(width: size.width, height: size.width / aspect)
    }
}

extension Viewport where Chrome == EmptyView {
    /// Every phone call site: an overlay and no pane chrome.
    init(
        slot: String,
        model: String? = nil,
        framing: ModelFraming = .standing,
        speed: Float = 1,
        still: TimeInterval? = nil,
        turn: Float = 0,
        roomBelow: Float = 0,
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
        tracker: JointTracker? = nil,
        cornerRadius: CGFloat = DS.Metric.viewportRadius,
        stageAspect: CGFloat? = nil,
        dragReferenceWidth: CGFloat? = nil,
        @ViewBuilder overlay: @escaping () -> Overlay
    ) {
        self.init(slot: slot, model: model, framing: framing, speed: speed, still: still,
                  turn: turn, roomBelow: roomBelow, inner: inner, outer: outer,
                  rx: rx, ry: ry, cx: cx, cy: cy, stop: stop, glows: glows, pulses: pulses,
                  showsGuides: showsGuides, tracker: tracker, cornerRadius: cornerRadius,
                  stageAspect: stageAspect, dragReferenceWidth: dragReferenceWidth,
                  overlay: overlay, chrome: { EmptyView() })
    }
}

extension Viewport where Overlay == EmptyView, Chrome == EmptyView {
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
        cornerRadius: CGFloat = DS.Metric.viewportRadius,
        stageAspect: CGFloat? = nil,
        dragReferenceWidth: CGFloat? = nil
    ) {
        self.init(slot: slot, model: model, framing: framing, speed: speed, inner: inner, outer: outer, rx: rx, ry: ry,
                  cx: cx, cy: cy, stop: stop, glows: glows, pulses: pulses,
                  showsGuides: showsGuides, cornerRadius: cornerRadius,
                  stageAspect: stageAspect, dragReferenceWidth: dragReferenceWidth,
                  overlay: { EmptyView() }, chrome: { EmptyView() })
    }
}
