//
//  USDZViewport.swift
//  GymWorkout
//
//  A RealityKit-backed 3D slot — the real thing behind the design's
//  "REALITYKIT VIEWPORT — replaceable" regions.
//
//  Source models are exported from Blender straight to a Y-up, ARKit-valid USD
//  (Convert Orientation on; lights and cameras excluded), then packaged with
//  `usdzip`. Lighting is rebuilt here because the usdz profile rejects the
//  DCC scene's DiskLight/DomeLight rig.
//
//  These meshes are deliberately near-black (0.0075 linear, ~sRGB 28) with the
//  worked muscles carrying a hot emissive red. Readability therefore comes
//  from rim light and specular, not from a bright key — a conventional key
//  just crushes the whole figure into one silhouette.
//

import SwiftUI
import RealityKit

/// Where named skeleton joints of a live `USDZViewport` model land on screen,
/// refreshed every frame, so overlays can point at the body as it moves
/// through the rep and as the viewer turns it.
@Observable
final class JointTracker {
    /// Joints to follow, matched on the last component of the rig's joint
    /// path, e.g. `hand_L`.
    let joints: [String]
    /// Viewport-space position of each tracked joint, in points. A joint is
    /// absent until the model has loaded, and while it is behind the camera.
    var points: [String: CGPoint] = [:]
    /// World transform of each tracked joint, for overlays that pose limbs of
    /// their own (the fault ghost). Position in the last column, the bone's
    /// head-to-tail direction in the second.
    var transforms: [String: simd_float4x4] = [:]
    /// Size of the viewport the points are measured in; kept current by the
    /// viewport itself.
    @ObservationIgnored var viewSize: CGSize = .zero
    /// World point to viewport point through the viewport's camera; set once
    /// the model has loaded.
    @ObservationIgnored var projector: ((SIMD3<Float>) -> CGPoint?)?

    init(joints: [String]) {
        self.joints = joints
    }
}

struct USDZViewport: View {
    /// Resource name without extension, e.g. `SquatPose`.
    var resource: String
    /// How the model is presented: view angle, zoom and vertical nudge.
    var framing: ModelFraming = .standing
    /// Playback rate applied to every clip.
    var speed: Float = 1
    /// When set, every clip is held still at this many seconds in, instead of
    /// playing — for rendering a fixed moment of the rep as a still image.
    var still: TimeInterval? = nil
    /// An extra turn about the vertical, in radians, on top of the framing and
    /// the viewer's drag — for showing something from a better side. Changes
    /// animate; the first value applies at once.
    var turn: Float = 0
    /// Fraction of the viewport's height a panel covers at the bottom: the
    /// model shrinks a little and rises to stay clear of it. Changes animate.
    var roomBelow: Float = 0
    /// Joints to project to screen for overlays, if any.
    var tracker: JointTracker? = nil
    /// Camera distance in model units.
    var distance: Float = 2.05
    var fieldOfView: Float = 32

    @State private var pivot = Entity()
    @State private var yaw: Double = 0
    @State private var dragStartYaw: Double = 0
    @State private var status: Status = .loading
    @State private var tracking: EventSubscription?
    /// `turn` and `roomBelow` as shown so far while they animate; nil until
    /// either first changes.
    @State private var shown: Staging?
    @State private var staging: Task<Void, Never>?

    /// The extra turn and room, eased between as one.
    private struct Staging: Equatable {
        var turn: Float
        var room: Float
    }

    private enum Status: Equatable {
        case loading
        case ready
        case failed(String)
    }

    var body: some View {
        GeometryReader { geo in
            viewport(width: geo.size.width)
        }
    }

    private func viewport(width: CGFloat) -> some View {
        ZStack {
            RealityView { content in
                content.camera = .virtual

                let camera = PerspectiveCamera()
                camera.camera.fieldOfViewInDegrees = fieldOfView
                camera.position = [0, 0, distance]
                content.add(camera)

                content.add(pivot)
                addLighting(to: content)

                do {
                    let model = try await Entity(named: resource, in: .main)
                    hideStudioProps(in: model)
                    pivot.addChild(model)
                    playAnimations(in: model)
                    await settleFraming(model)
                    if let tracker {
                        tracking = track(tracker, in: model, content: content)
                    }
                    status = .ready
                } catch {
                    status = .failed(error.localizedDescription)
                }
            } update: { _ in
                let stage = shown ?? Staging(turn: turn, room: roomBelow)
                pivot.transform.rotation =
                    simd_quatf(angle: Float(yaw) + framing.yaw + stage.turn, axis: [0, 1, 0])
                // Scaled about the middle of the view, then lifted by a share
                // of its height at the model's depth.
                let height = 2 * distance * tan(fieldOfView * .pi / 360)
                pivot.transform.scale = SIMD3(repeating: 1 - 0.25 * stage.room)
                pivot.transform.translation = [0, 0.35 * stage.room * height, 0]
            }
            .opacity(status == .ready ? 1 : 0)

            switch status {
            case .loading:
                ProgressView()
                    .tint(DS.silver.opacity(0.4))
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
        // The drag lives on the container, not on the RealityView: a hit-
        // testable shape over the whole viewport receives every swipe
        // regardless of how RealityView routes touches internally.
        //
        // A swipe the full width of the viewport is exactly one turn. The old
        // fixed 0.01 rad/pt needed ~630pt for 360° — wider than any iPhone —
        // so a single swipe could never bring the model all the way around.
        .contentShape(Rectangle())
        .onGeometryChange(for: CGSize.self, of: \.size) { tracker?.viewSize = $0 }
        .onChange(of: Staging(turn: turn, room: roomBelow)) { old, new in stage(from: shown ?? old, to: new) }
        .gesture(
            DragGesture(minimumDistance: 2)
                .onChanged { value in
                    let turns = Double(value.translation.width / max(width, 1))
                    yaw = dragStartYaw + turns * 2 * .pi
                }
                .onEnded { _ in dragStartYaw = yaw }
        )
    }

    /// Eases the model to a new turn and room over about half a second.
    private func stage(from start: Staging, to end: Staging) {
        staging?.cancel()
        staging = Task {
            let steps = 30
            for step in 1...steps {
                try? await Task.sleep(for: .milliseconds(16))
                guard !Task.isCancelled else { return }
                let t = Float(step) / Float(steps)
                let eased = t * t * (3 - 2 * t)
                shown = Staging(turn: start.turn + (end.turn - start.turn) * eased,
                                room: start.room + (end.room - start.room) * eased)
            }
        }
    }

    /// Plays every skeletal clip the file carries, looping.
    ///
    /// Blender writes the whole scene's animation as one clip per animated
    /// entity, so this walks the hierarchy rather than assuming it sits on the
    /// root.
    private func playAnimations(in root: Entity) {
        func walk(_ entity: Entity) {
            if let clip = entity.availableAnimations.first {
                let controller = entity.playAnimation(
                    clip.repeat(), transitionDuration: 0, startsPaused: false
                )
                controller.speed = speed
                if let still {
                    controller.time = still
                    controller.pause()
                }
            }
            for child in entity.children { walk(child) }
        }
        walk(root)
    }

    /// Hides the DCC studio floor: the viewport draws its own ground, and a
    /// matte plane sitting in it reads as a seam.
    private func hideStudioProps(in root: Entity) {
        let hidden: Set<String> = ["DARK_Floor"]
        func walk(_ entity: Entity) {
            if hidden.contains(entity.name) { entity.isEnabled = false }
            for child in entity.children { walk(child) }
        }
        walk(root)
    }

    /// Normalises the model to one unit tall and centres it on the pivot, so
    /// framing does not depend on the DCC scene's scale or origin.
    ///
    /// Framing is driven by height, not the largest dimension: these scenes
    /// include equipment (a barbell is wider than the lifter is tall), and
    /// normalising by width would shrink the figure into the middle of a
    /// portrait viewport.
    /// Frames the model against the pose it actually holds while playing.
    ///
    /// Measuring at load is useless here: every exercise shares one rig, so
    /// `visualBounds` reports the same standing box for a squat and a push-up
    /// alike — the pose only exists once the clip is running. So sample the
    /// bounds across the first second of playback and fit the union, which
    /// also keeps the framing stable as the lifter moves through the rep.
    private func settleFraming(_ model: Entity) async {
        let subject = model.findEntity(named: Self.rigEntityName) ?? model
        var union: BoundingBox?

        for _ in 0..<2 {
            try? await Task.sleep(for: .milliseconds(80))
            let sample = subject.visualBounds(recursive: true, relativeTo: nil)
            union = union.map { $0.union(sample) } ?? sample
        }

        guard let bounds = union else { return }
        let longest = max(bounds.extents.x, max(bounds.extents.y, bounds.extents.z))
        guard longest > 0 else { return }

        let scale = framing.zoom / longest
        model.scale = SIMD3(repeating: scale)
        model.position = -bounds.center * scale + framing.offset
    }

    /// SkelRoot written by the Blender rig.
    private static let rigEntityName = "Anatomy_MasterRig"

    /// Follows `tracker.joints` every frame and publishes their screen points.
    ///
    /// RealityKit cannot parent an entity to a joint, so the joint is found the
    /// long way: its pose is read off a skinned mesh as parent-relative
    /// transforms, chained up the joint paths into the mesh's space, then taken
    /// to world space and projected through this viewport's camera.
    private func track(
        _ tracker: JointTracker, in model: Entity, content: RealityViewCameraContent
    ) -> EventSubscription? {
        guard let skin = Self.skinnedModel(in: model) else { return nil }
        let names = skin.jointNames
        var indexByPath: [String: Int] = [:]
        for (i, name) in names.enumerated() { indexByPath[name] = i }
        let parents: [Int?] = names.map { path in
            guard let slash = path.lastIndex(of: "/") else { return nil }
            return indexByPath[String(path[..<slash])]
        }
        let targets: [(name: String, index: Int)] = tracker.joints.compactMap { joint in
            names.firstIndex { $0 == joint || $0.hasSuffix("/" + joint) }
                .map { (joint, $0) }
        }
        guard !targets.isEmpty else { return nil }

        let distance = distance, fieldOfView = fieldOfView
        tracker.projector = { [weak tracker] p in
            guard let tracker else { return nil }
            return Self.project(p, in: tracker.viewSize, distance: distance, fieldOfView: fieldOfView)
        }

        return content.subscribe(to: SceneEvents.Update.self) { _ in
            let local = skin.jointTransforms
            var resolved: [Int: simd_float4x4] = [:]
            func meshSpace(_ i: Int) -> simd_float4x4 {
                if let m = resolved[i] { return m }
                let parent = parents[i].map(meshSpace) ?? matrix_identity_float4x4
                let m = parent * local[i].matrix
                resolved[i] = m
                return m
            }
            let toWorld = skin.transformMatrix(relativeTo: nil)
            var points: [String: CGPoint] = [:]
            var transforms: [String: simd_float4x4] = [:]
            for target in targets {
                let world = toWorld * meshSpace(target.index)
                transforms[target.name] = world
                let p = world.columns.3
                if let screen = Self.project([p.x, p.y, p.z], in: tracker.viewSize,
                                             distance: distance, fieldOfView: fieldOfView) {
                    points[target.name] = screen
                }
            }
            tracker.points = points
            tracker.transforms = transforms
        }
    }

    /// World point to viewport point, for the fixed camera this view sets up:
    /// at `[0, 0, distance]`, looking down -Z, `fieldOfView` measured
    /// vertically.
    private static func project(_ p: SIMD3<Float>, in size: CGSize,
                                distance: Float, fieldOfView: Float) -> CGPoint? {
        let v = p - [0, 0, distance]
        guard v.z < -0.01, size.width > 0, size.height > 0 else { return nil }
        let t = tan(fieldOfView * .pi / 360)
        let aspect = Float(size.width / size.height)
        let x = v.x / (-v.z * t * aspect)
        let y = v.y / (-v.z * t)
        return CGPoint(x: CGFloat(x + 1) / 2 * size.width,
                       y: CGFloat(1 - y) / 2 * size.height)
    }

    /// First mesh bound to the rig; every skinned part shares its skeleton.
    private static func skinnedModel(in root: Entity) -> ModelEntity? {
        if let model = root as? ModelEntity, !model.jointNames.isEmpty { return model }
        for child in root.children {
            if let found = skinnedModel(in: child) { return found }
        }
        return nil
    }

    /// Key / fill / rim, echoing the design's studio: one bright source high
    /// and to the left, a dim fill, and two rims to separate the figure from a
    /// near-black ground.
    private func addLighting(to content: RealityViewCameraContent) {
        func light(
            intensity: Float, from: SIMD3<Float>, colour: UIColor = .white
        ) -> DirectionalLight {
            let entity = DirectionalLight()
            entity.light.intensity = intensity
            entity.light.color = colour
            entity.position = from
            entity.look(at: .zero, from: from, relativeTo: nil)
            return entity
        }

        // Rim-led: the back pair does most of the work of separating a
        // near-black figure from a near-black ground, while the key stays low
        // enough that the emissive worked muscles still read as the brightest
        // thing on screen.
        content.add(light(intensity: 3_200, from: [-1.4, 1.6, 1.8]))
        content.add(light(intensity: 900, from: [1.8, 0.4, 1.2]))
        content.add(light(intensity: 6_500, from: [1.7, 0.9, -1.6]))
        content.add(light(intensity: 5_200, from: [-1.7, 0.7, -1.5]))
    }
}
