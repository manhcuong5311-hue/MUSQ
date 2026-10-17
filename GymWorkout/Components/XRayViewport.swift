//
//  XRayViewport.swift
//  GymWorkout
//
//  The RealityKit scene behind an x-ray demo (`XRayDemo`): see-through
//  muscle with the bones drawn inside, which the viewer can turn all the way
//  round and over the top, pinch closer to, slow down, pause and scrub.
//
//  Kept apart from `USDZViewport` on purpose: the trainer's viewport only
//  turns about the vertical and never zooms, and its framing, callouts and
//  fault ghosts depend on that fixed camera. Here the camera stays put too,
//  but the model is turned (yaw, then pitch) and scaled on a pivot, and kept
//  centred on what the cue is about — the shoulder blades, or the hips for
//  the whole-body side view — by following those joints every frame. So a
//  pinch always closes in on the shoulder blades, even as the lifter lies
//  back onto the bench.
//
//  The muscles' see-through look comes from the model itself (each
//  UsdPreviewSurface carries its opacity); nothing is recoloured here.
//

import SwiftUI
import RealityKit

/// What the controls ask of the scene, and what the clip is doing.
@Observable
final class XRayStage {
    enum Status: Equatable { case loading, ready, failed(String) }

    let demo: XRayDemo
    var status: Status = .loading
    /// The picked angle; `.auto` follows the clip's phases.
    private(set) var view: XRayView = .auto
    /// Playback rate of the clip.
    var speed: Float = 1 { didSet { if !paused { for c in controllers where c.isValid { c.speed = speed } } } }
    private(set) var paused = false
    /// Seconds into the clip, refreshed about ten times a second.
    private(set) var time: TimeInterval = 0

    // Scene state, touched every frame, so outside observation.
    @ObservationIgnored let pivot = Entity()
    @ObservationIgnored private var model: Entity?
    @ObservationIgnored private var controllers: [AnimationPlaybackController] = []
    @ObservationIgnored private var clips: [(controller: AnimationPlaybackController, duration: TimeInterval)] = []
    /// The clip whose time the captions and the Auto angle follow: the
    /// longest one still playing. The file's root, its `root` prim and the
    /// rig each offer the same clip, and starting it on a child stops the
    /// parent's, so the first one started is not the one that runs. The clips
    /// play as in the trainer; pausing sets their speed to zero.
    @ObservationIgnored private var main: (controller: AnimationPlaybackController, duration: TimeInterval)?
    private func liveMain() -> (controller: AnimationPlaybackController, duration: TimeInterval)? {
        if let main, main.controller.isValid { return main }
        main = clips.filter { $0.controller.isValid }.max { $0.duration < $1.duration }
        return main
    }
    /// Viewport width over height; wider views zoom in further.
    @ObservationIgnored var aspect: Float = 0.77
    @ObservationIgnored private var skin: ModelEntity?
    @ObservationIgnored private var parents: [Int?] = []
    @ObservationIgnored private var joints: [String: Int] = [:]
    /// Drawn only while the camera is not overhead: from above, the rib cage
    /// sits right over the shoulder blades and hides them. RealityKit merges
    /// the skinned bone meshes into the rig's model, so they are found by
    /// material: `DARK_Anatomy_Bone` covers the rib cage, sternum, spine and
    /// upper arms, while the shoulder blades and collarbones have their own.
    @ObservationIgnored private var contextBones: [(entity: Entity, slots: [Int], originals: [any RealityKit.Material])] = []
    @ObservationIgnored private var bonesHidden = false
    @ObservationIgnored var subscription: EventSubscription?
    /// The viewer's own turn, tilt and pinch on top of the picked angle.
    @ObservationIgnored var dragYaw: Float = 0
    @ObservationIgnored var dragPitch: Float = 0
    @ObservationIgnored var pinch: Float = 1
    /// What is on screen, eased towards the target each frame.
    @ObservationIgnored private var shown: (yaw: Float, pitch: Float, zoom: Float)?
    @ObservationIgnored private var focus: SIMD3<Float>?

    init(demo: XRayDemo) {
        self.demo = demo
    }

    // MARK: Controls

    func pick(_ view: XRayView) {
        self.view = view
        resetUserView()
    }

    func resetUserView() {
        dragYaw = 0; dragPitch = 0; pinch = 1
    }

    func togglePause() {
        paused.toggle()
        for c in controllers where c.isValid { c.speed = paused ? 0 : speed }
    }

    func seek(to seconds: TimeInterval) {
        let t = min(max(seconds, 0), (liveMain()?.duration ?? demo.duration) - 0.01)
        for c in controllers where c.isValid { c.time = t }
        time = t
    }

    // MARK: Scene

    /// Puts the loaded model on the pivot, binds the joints it follows and
    /// starts the clip, looping.
    func attach(_ model: Entity) {
        func walk(_ entity: Entity) {
            if entity.name == "DARK_Floor" { entity.isEnabled = false }
            if let model = entity.components[ModelComponent.self] {
                let slots = model.materials.indices.filter { (model.materials[$0].name ?? "").contains("DARK_Anatomy_Bone") }
                if !slots.isEmpty { contextBones.append((entity, slots, model.materials)) }
            }
            if let clip = entity.availableAnimations.first {
                let controller = entity.playAnimation(clip.repeat(), transitionDuration: 0, startsPaused: false)
                controller.speed = speed
                controllers.append(controller)
                clips.append((controller, clip.definition.duration))
            }
            for child in entity.children { walk(child) }
        }
        // On stage first, then play: a clip started on an entity that is not
        // in a scene yet never advances (the trainer does it in this order).
        pivot.addChild(model)
        walk(model)
        self.model = model
        bindJoints(in: model.findEntity(named: "Anatomy_MasterRig") ?? model)
    }

    private func bindJoints(in root: Entity) {
        func skinned(_ e: Entity) -> ModelEntity? {
            if let m = e as? ModelEntity, !m.jointNames.isEmpty { return m }
            for c in e.children { if let f = skinned(c) { return f } }
            return nil
        }
        guard let skin = skinned(root) else { return }
        let names = skin.jointNames
        var index: [String: Int] = [:]
        for (i, n) in names.enumerated() { index[n] = i }
        parents = names.map { path in
            guard let slash = path.lastIndex(of: "/") else { return nil }
            return index[String(path[..<slash])]
        }
        for joint in ["scapula_L", "scapula_R", "pelvis"] {
            if let i = names.firstIndex(where: { $0 == joint || $0.hasSuffix("/" + joint) }) { joints[joint] = i }
        }
        self.skin = skin
    }

    /// Where `wanted` sits in the model's own space right now.
    private func focusPoint(_ wanted: XRayFocus) -> SIMD3<Float>? {
        guard let skin, let model else { return nil }
        let local = skin.jointTransforms
        var resolved: [Int: simd_float4x4] = [:]
        func meshSpace(_ i: Int) -> simd_float4x4 {
            if let m = resolved[i] { return m }
            let m = (parents[i].map(meshSpace) ?? matrix_identity_float4x4) * local[i].matrix
            resolved[i] = m
            return m
        }
        let toModel = skin.transformMatrix(relativeTo: model)
        func point(_ joint: String) -> SIMD3<Float>? {
            guard let i = joints[joint], i < local.count else { return nil }
            let p = (toModel * meshSpace(i)).columns.3
            return [p.x, p.y, p.z]
        }
        switch wanted {
        case .shoulders:
            guard let l = point("scapula_L"), let r = point("scapula_R") else { return nil }
            return (l + r) / 2
        case .body:
            // Mid-trunk: halfway from the hips to the shoulder blades, so the
            // whole lifter stays in frame lying down as well as sitting.
            guard let h = point("pelvis"), let l = point("scapula_L"), let r = point("scapula_R") else { return nil }
            return (h + (l + r) / 2) / 2
        }
    }

    /// One frame: read the clip's time, ease the angle, zoom and centre
    /// towards what is asked, and hide the ribs from overhead.
    func tick(_ dt: TimeInterval) {
        guard let model else { return }
        let t = liveMain().map { $0.controller.time.truncatingRemainder(dividingBy: max($0.duration, 0.01)) } ?? 0
        if abs(t - time) > 0.1 { time = t }

        let target = view == .auto ? demo.autoView(at: t) : view
        let pose = target.pose
        // The presets are set for a phone in portrait; a wider view has room
        // to come in closer.
        let widen = min(max(aspect / 0.77, 1), 1.6)
        let goal = (yaw: pose.yaw + dragYaw,
                    pitch: min(max(pose.pitch + dragPitch, -0.35), .pi / 2),
                    zoom: pose.zoom * pinch * widen)
        let k = Float(1 - exp(-dt * 5))
        var now = shown ?? goal
        var dYaw = (goal.yaw - now.yaw).truncatingRemainder(dividingBy: 2 * .pi)
        if dYaw > .pi { dYaw -= 2 * .pi } else if dYaw < -.pi { dYaw += 2 * .pi }
        now.yaw += dYaw * k
        now.pitch += (goal.pitch - now.pitch) * k
        now.zoom += (goal.zoom - now.zoom) * k
        shown = now

        if let p = focusPoint(target.focus) {
            focus = focus.map { $0 + (p - $0) * k } ?? p
        }
        pivot.transform.rotation = simd_quatf(angle: now.pitch, axis: [1, 0, 0]) * simd_quatf(angle: now.yaw, axis: [0, 1, 0])
        pivot.transform.scale = SIMD3(repeating: now.zoom)
        model.position = -(focus ?? .zero)
        let overhead = now.pitch > 1.0
        if overhead != bonesHidden {
            bonesHidden = overhead
            var clear = PhysicallyBasedMaterial()
            clear.blending = .transparent(opacity: .init(floatLiteral: 0))
            for (entity, slots, originals) in contextBones {
                guard var model = entity.components[ModelComponent.self] else { continue }
                for i in slots where i < model.materials.count { model.materials[i] = overhead ? clear : originals[i] }
                entity.components.set(model)
            }
        }
    }
}

struct XRayViewport: View {
    let stage: XRayStage

    @State private var dragStart: (yaw: Float, pitch: Float)?
    @State private var pinchStart: Float?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RealityView { content in
                    content.camera = .virtual
                    let camera = PerspectiveCamera()
                    camera.camera.fieldOfViewInDegrees = 32
                    camera.position = [0, 0, 2.05]
                    content.add(camera)
                    content.add(stage.pivot)
                    addLighting(to: content)
                    do {
                        let model = try await Entity(named: stage.demo.resource, in: .main)
                        stage.attach(model)
                        let stage = stage
                        stage.subscription = content.subscribe(to: SceneEvents.Update.self) { event in
                            stage.tick(event.deltaTime)
                        }
                        stage.status = .ready
                    } catch {
                        stage.status = .failed(error.localizedDescription)
                    }
                }
                .opacity(stage.status == .ready ? 1 : 0)

                switch stage.status {
                case .loading:
                    ProgressView().tint(DS.silver.opacity(0.4))
                case .failed(let message):
                    VStack(spacing: 8) {
                        SectionEyebrow(text: "MODEL FAILED TO LOAD", size: 9, em: 0.11)
                        Text(message)
                            .font(.ui(11))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(DS.silver.opacity(0.4))
                    }
                    .padding(24)
                case .ready:
                    EmptyView()
                }
            }
            .contentShape(Rectangle())
            .onGeometryChange(for: CGSize.self, of: \.size) { size in
                stage.aspect = Float(size.width / max(size.height, 1))
            }
            // A full-width swipe is one full turn, as in the trainer; a
            // full-height one tips the model half a turn over.
            // One gesture for both, so a pinch is never swallowed by the drag
            // its first finger starts.
            .gesture(
                DragGesture(minimumDistance: 2)
                    .simultaneously(with: MagnifyGesture(minimumScaleDelta: 0.01))
                    .onChanged { value in
                        if let pinch = value.second {
                            let start = pinchStart ?? stage.pinch
                            pinchStart = start
                            stage.pinch = min(max(start * Float(pinch.magnification), 0.45), 3.2)
                        } else if let drag = value.first {
                            let start = dragStart ?? (stage.dragYaw, stage.dragPitch)
                            dragStart = start
                            stage.dragYaw = start.yaw + Float(drag.translation.width / max(geo.size.width, 1)) * 2 * .pi
                            stage.dragPitch = start.pitch + Float(drag.translation.height / max(geo.size.height, 1)) * .pi
                        }
                    }
                    .onEnded { _ in dragStart = nil; pinchStart = nil }
            )
            .onTapGesture(count: 2) { stage.resetUserView() }
            .accessibilityElement()
            .accessibilityLabel("X-ray model")
            .accessibilityHint("Drag to turn, pinch to zoom, double-tap to reset the view")
        }
    }

    /// Lights that turn with the camera rather than the model, so any angle
    /// the viewer picks is lit the same way: a key high on the left, a fill
    /// on the right, a light from above, and two rims behind that outline the
    /// see-through muscle against the dark ground.
    private func addLighting(to content: RealityViewCameraContent) {
        func light(_ intensity: Float, from: SIMD3<Float>) -> DirectionalLight {
            let entity = DirectionalLight()
            entity.light.intensity = intensity
            entity.position = from
            entity.look(at: .zero, from: from, relativeTo: nil)
            return entity
        }
        content.add(light(5_200, from: [-1.4, 1.6, 1.8]))
        content.add(light(2_200, from: [1.8, 0.4, 1.2]))
        content.add(light(2_400, from: [0.0, 2.2, 0.4]))
        content.add(light(6_000, from: [1.7, 0.9, -1.6]))
        content.add(light(5_000, from: [-1.7, 0.7, -1.5]))
    }
}
