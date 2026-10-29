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
//  worked muscles carrying a hot emissive red. Since 2026-10-22 they are lit
//  the way the web guide lights the same models: by model-viewer's "neutral"
//  studio alone (`NeutralStudio.hdr`), the body's sheen turned down, against
//  the grey studio ground (`DS.modelGroundInner`), so the lifter reads as a
//  deep, matte black with the sneakers white and the equipment grey. The old
//  key/fill/rim rig only stands in if that light can't be made.
//
//  That black proved too dark to read on a phone, so since 2026-10-25 the
//  viewer picks a `ModelLook` in Settings: the skin's colour and sheen, and
//  whether the rig's two back rims light it alongside the studio. The default
//  is a charcoal skin with rims (the owner's pick of six looks), which keeps
//  the muscle shapes and the silhouette readable while the worked muscles
//  stay the hottest thing.
//
//  The files dress the male lifter in shorts as near-black as his skin, so
//  every look painted them the skin's colour and the hips read as one bare
//  mass with the glutes' red showing through. Since 2026-10-28 the shorts
//  take a colour of their own per look, a navy darker than the charcoal, and
//  the glutes under them follow it while they are unlit. The refitted shorts
//  now cover worked glutes whole, so the fabric over them takes their paint
//  instead (`ShortsGluteZone`).
//

import SwiftUI
import RealityKit
import ImageIO

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
    /// Caps the width a swipe is measured against, so a full turn on an iPad
    /// pane doesn't need a 900pt drag; nil uses the viewport's width.
    var dragReferenceWidth: CGFloat? = nil
    /// The viewer's turn, when a host drives it with its own drag over a
    /// larger surface (`Viewport`'s staged layout). The model then takes no
    /// drag of its own.
    var externalYaw: Double? = nil
    /// Camera distance in model units.
    var distance: Float = 2.05
    var fieldOfView: Float = 32
    /// The skin colour, sheen and rims (Settings' "Model color"). A change
    /// restyles the model on stage at once.
    var look: ModelLook = .charcoal

    @State private var pivot = Entity()
    @State private var yaw: Double = 0
    @State private var dragStartYaw: Double = 0
    @State private var status: Status = .loading
    @State private var tracking: EventSubscription?
    /// What the per-frame joint tracking reads, rebound in place when the
    /// model is swapped.
    @State private var bound = TrackedSkin()
    /// The model on stage and the resource it came from. A new `resource`
    /// (a stance picked in the trainer, 2026-10-10) is loaded into this same
    /// scene and cross-faded in, rather than tearing the scene down: two
    /// stances share one body file, and a scene released while the next one
    /// loads could leave the new model's meshes undrawn.
    @State private var onStage: Entity?
    @State private var loadedResource: String?
    /// `turn` and `roomBelow` as shown so far while they animate; nil until
    /// either first changes.
    @State private var shown: Staging?
    @State private var staging: Task<Void, Never>?
    /// The studio light every model on stage receives; nil when the
    /// key/fill/rim rig lights the scene instead.
    @State private var studioLight: Entity?
    /// The back rims next to the studio light, on only for looks that want
    /// them.
    @State private var rims: [Entity] = []
    @State private var skinSlots = SkinSlots()

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
                studioLight = await addStudioLight()
                if studioLight == nil {
                    addLighting(to: content)
                } else {
                    rims = addRims(to: content)
                    for rim in rims { rim.isEnabled = look.rims }
                }

                do {
                    let model = try await Entity(named: resource, in: .main)
                    hideStudioProps(in: model)
                    light(model)
                    pivot.addChild(model)
                    playAnimations(in: model)
                    await settleFraming(model)
                    if let tracker {
                        tracking = track(tracker, in: model, content: content)
                    }
                    onStage = model
                    loadedResource = resource
                    status = .ready
                } catch {
                    status = .failed(error.localizedDescription)
                }
            } update: { _ in
                let stage = shown ?? Staging(turn: turn, room: roomBelow)
                pivot.transform.rotation =
                    simd_quatf(angle: Float(externalYaw ?? yaw) + framing.yaw + stage.turn, axis: [0, 1, 0])
                // Scaled about the middle of the view, then lifted by a share
                // of its height at the model's depth.
                let height = 2 * distance * tan(fieldOfView * .pi / 360)
                pivot.transform.scale = SIMD3(repeating: 1 - 0.25 * stage.room)
                pivot.transform.translation = [0, 0.35 * stage.room * height, 0]
            }
            .opacity(status == .ready ? 1 : 0)
            .task(id: resource) {
                // The first model is the make closure's; later ones swap in.
                guard let loadedResource, loadedResource != resource else { return }
                await swap(to: resource)
            }

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
        .onChange(of: look) {
            for rim in rims { rim.isEnabled = look.rims }
            if let onStage { styleBody(in: onStage) }
        }
        .gesture(
            DragGesture(minimumDistance: 2)
                .onChanged { value in
                    let reference = min(width, dragReferenceWidth ?? width)
                    let turns = Double(value.translation.width / max(reference, 1))
                    yaw = dragStartYaw + turns * 2 * .pi
                }
                .onEnded { _ in dragStartYaw = yaw },
            isEnabled: externalYaw == nil
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
    /// Loads `resource` into the running scene, frames it like the first
    /// model, and cross-fades it in over the one on stage, which keeps playing
    /// until the new one is ready.
    private func swap(to resource: String) async {
        // A newer pick cancels this task (`.task(id:)`); a model it loaded
        // never reaches the stage.
        guard let next = try? await Entity(named: resource, in: .main), !Task.isCancelled else { return }
        hideStudioProps(in: next)
        light(next)
        next.components.set(OpacityComponent(opacity: 0))
        pivot.addChild(next)
        playAnimations(in: next)
        await settleFraming(next)
        guard !Task.isCancelled else { next.removeFromParent(); return }
        if let tracker { bound.bind(to: next, joints: tracker.joints) }
        let previous = onStage
        onStage = next
        loadedResource = resource
        for step in 1...8 {
            try? await Task.sleep(for: .milliseconds(30))
            let t = Float(step) / 8
            next.components.set(OpacityComponent(opacity: t))
            previous?.components.set(OpacityComponent(opacity: 1 - t))
        }
        next.components.remove(OpacityComponent.self)
        previous?.removeFromParent()
    }

    /// The skinned mesh and joint indices the tracking reads every frame.
    private final class TrackedSkin {
        var skin: ModelEntity?
        var parents: [Int?] = []
        var targets: [(name: String, index: Int)] = []

        /// Points the tracking at `model`'s rig; false when it has none of
        /// `joints`.
        @discardableResult
        func bind(to model: Entity, joints: [String]) -> Bool {
            // Looked for under the rig first: some props are skinned too (the
            // Assisted Nordic Curl's band has a one-joint skeleton of its own,
            // exported ahead of the rig), and their joints are not the lifter's.
            guard let skin = USDZViewport.skinnedModel(in: model.findEntity(named: USDZViewport.rigEntityName) ?? model)
            else { return false }
            let names = skin.jointNames
            var indexByPath: [String: Int] = [:]
            for (i, name) in names.enumerated() { indexByPath[name] = i }
            let targets: [(name: String, index: Int)] = joints.compactMap { joint in
                names.firstIndex { $0 == joint || $0.hasSuffix("/" + joint) }
                    .map { (joint, $0) }
            }
            guard !targets.isEmpty else { return false }
            self.parents = names.map { path in
                guard let slash = path.lastIndex(of: "/") else { return nil }
                return indexByPath[String(path[..<slash])]
            }
            self.targets = targets
            self.skin = skin
            return true
        }
    }

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
        guard bound.bind(to: model, joints: tracker.joints) else { return nil }

        let distance = distance, fieldOfView = fieldOfView
        tracker.projector = { [weak tracker] p in
            guard let tracker else { return nil }
            return Self.project(p, in: tracker.viewSize, distance: distance, fieldOfView: fieldOfView)
        }

        let bound = bound
        return content.subscribe(to: SceneEvents.Update.self) { _ in
            guard let skin = bound.skin else { return }
            let parents = bound.parents, targets = bound.targets
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

    /// The web guide's studio light: model-viewer's "neutral" environment,
    /// its own room and area lights unwrapped to a lat-long
    /// (`Tools/web-guide/capture/env.html`), so the app lights these models as
    /// the guide does. A child of the pivot, it turns with the model, as on
    /// the web where the camera orbits a fixed scene. Nil if the file can't be
    /// read; the caller then falls back to the key/fill/rim rig.
    private func addStudioLight() async -> Entity? {
        guard let environment = await Self.studioEnvironment() else { return nil }
        let light = Entity()
        light.components.set(ImageBasedLightComponent(source: .single(environment), intensityExponent: 0))
        pivot.addChild(light)
        return light
    }

    /// Decoded once and shared by every viewport.
    @MainActor private static var studio: EnvironmentResource?

    @MainActor private static func studioEnvironment() async -> EnvironmentResource? {
        if let studio { return studio }
        guard let url = Bundle.main.url(forResource: "NeutralStudio", withExtension: "hdr"),
              let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let image = CGImageSourceCreateImageAtIndex(source, 0, nil),
              let made = try? await EnvironmentResource(equirectangular: image)
        else { return nil }
        studio = made
        return made
    }

    /// Puts a freshly loaded model under the studio light, its body matte.
    private func light(_ model: Entity) {
        guard let studioLight else { return }
        func receive(_ entity: Entity) {
            entity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: studioLight))
            for child in entity.children { receive(child) }
        }
        receive(model)
        bodyMeshes(in: model) { mesh in
            guard let materials = mesh.model?.materials else { return }
            for (index, material) in materials.enumerated() {
                guard let body = material as? PhysicallyBasedMaterial,
                      body.baseColor.texture == nil, Self.isNearBlack(body.baseColor.tint) else { continue }
                skinSlots.original[ObjectIdentifier(mesh), default: [:]][index] = body.baseColor.tint
            }
            // Only the male bodies wear these shorts, and reading a model's
            // parts takes up to 2 s on the female ones, so look for the
            // shorts' entity first.
            guard model.findEntity(named: "Anatomy_Shorts") != nil else { return }
            let users = Self.slotUsers(of: mesh)
            skinSlots.shorts[ObjectIdentifier(mesh)] = Self.shortsSlots(users)
            skinSlots.wear[ObjectIdentifier(mesh)] = ShortsGluteZone.wear(of: mesh, users: users, unlit: Self.isNearBlack)
        }
        styleBody(in: model)
    }

    /// The near-black skin's slots in the models on stage, with the files'
    /// own tint, so a new look recolours a model in place, without reloading;
    /// which of them dress the shorts; and the glute paint the shorts show.
    private final class SkinSlots {
        var original: [ObjectIdentifier: [Int: UIColor]] = [:]
        var shorts: [ObjectIdentifier: Set<Int>] = [:]
        var wear: [ObjectIdentifier: ShortsGluteZone.Wear] = [:]
    }

    /// Sets the body's sheen and skin colour from `look`. Matte was the
    /// owner's pick of four glosses on 2026-10-22, so the files' roughness
    /// stays; the Black look keeps the web's sheen instead. The near-black
    /// skin takes the look's colour, or its own back; the near-black shorts
    /// take the look's shorts colour and stay matte, as fabric, turning red
    /// over the glutes when the lift works them (`ShortsGluteZone`); the
    /// painted muscles and textured garments keep theirs.
    private func styleBody(in model: Entity) {
        let look = look
        bodyMeshes(in: model) { mesh in
            guard var component = mesh.model else { return }
            let skinned = skinSlots.original[ObjectIdentifier(mesh)] ?? [:]
            let shorts = skinSlots.shorts[ObjectIdentifier(mesh)] ?? []
            let wear = skinSlots.wear[ObjectIdentifier(mesh)]
            component.materials = component.materials.enumerated().map { index, material in
                guard var body = material as? PhysicallyBasedMaterial else { return material }
                let original = skinned[index]
                let fabric = original != nil && shorts.contains(index)
                body.specular = .init(floatLiteral: fabric ? 0.1 : look.specular)
                guard let original else { return body }
                let colour = fabric ? look.shorts : look.skin ?? original
                if let wear, wear.lit, index == wear.slot,
                   let texture = ShortsGluteZone.texture(fabric: colour, wear: wear) {
                    body.baseColor = .init(tint: .white, texture: .init(texture))
                } else {
                    body.baseColor = .init(tint: colour)
                }
                return body
            }
            mesh.model = component
        }
    }

    /// The file meshes using each material slot of `mesh`. RealityKit merges
    /// the skinned body into the rig's one model, so the shorts and glutes
    /// are no entities of their own; its parts keep the file's mesh names,
    /// and each names its slot.
    private static func slotUsers(of mesh: ModelEntity) -> [Int: [String]] {
        guard let contents = mesh.model?.mesh.contents else { return [:] }
        var users: [Int: [String]] = [:]
        for model in contents.models {
            for part in model.parts { users[part.materialIndex, default: []].append(model.id) }
        }
        return users
    }

    /// The slots that dress the male lifter's shorts (2026-10-28), from
    /// `slotUsers`: the untextured `Anatomy_Shorts`, and the glutes on a body
    /// that wears them. The glutes sit wholly under the fabric, and where a
    /// pose pushes one through it (the shorts follow the hips by skinning
    /// alone, with no cloth solve) an unlit glute shows in the shorts' colour
    /// rather than as a patch of skin; a worked glute is painted red, not
    /// near-black, and keeps its red. A slot counts only if nothing else uses
    /// it.
    private static func shortsSlots(_ users: [Int: [String]]) -> Set<Int> {
        func only(_ prefix: String) -> Set<Int> {
            Set(users.filter { $0.value.allSatisfy { $0.hasPrefix(prefix) } }.keys)
        }
        let shorts = only("Anatomy_Shorts")
        return shorts.isEmpty ? [] : shorts.union(only("Gluteus"))
    }

    /// Every mesh under the rig but the sneakers, so the black shoes of the
    /// older body go along with the skin and the white ones stay as they are;
    /// the equipment, outside the rig, keeps its own.
    private func bodyMeshes(in model: Entity, _ visit: (ModelEntity) -> Void) {
        guard let rig = model.findEntity(named: Self.rigEntityName) else { return }
        func walk(_ entity: Entity, inSneaker: Bool) {
            let inSneaker = inSneaker || entity.name.contains("Sneaker")
            if !inSneaker, let mesh = entity as? ModelEntity { visit(mesh) }
            for child in entity.children { walk(child, inSneaker: inSneaker) }
        }
        walk(rig, inSneaker: false)
    }

    /// The files' unpainted near-black: the skin (0.0075 linear) and the male
    /// shorts (0.0144, or 0.0116/0.0203/0.0395 navy in the lifts exported
    /// from the patched .blend files on 2026-10-28, its blue 0.019 above its
    /// green, just inside the 0.02). The painted muscles are red and miss
    /// this, so it is also the test for an unlit muscle.
    nonisolated private static func isNearBlack(_ colour: UIColor) -> Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        colour.getRed(&r, green: &g, blue: &b, alpha: &a)
        return max(r, g, b) < 0.2 && abs(r - g) < 0.02 && abs(g - b) < 0.02
    }

    private static func directional(intensity: Float, from: SIMD3<Float>) -> DirectionalLight {
        let entity = DirectionalLight()
        entity.light.intensity = intensity
        entity.position = from
        entity.look(at: .zero, from: from, relativeTo: nil)
        return entity
    }

    /// Two rims from behind, fixed to the camera so they edge the figure
    /// whichever way it's turned: with the studio light for the looks that
    /// want them (2026-10-25), and the back half of the fallback rig.
    @discardableResult
    private func addRims(to content: RealityViewCameraContent) -> [Entity] {
        let rims = [Self.directional(intensity: 6_500, from: [1.7, 0.9, -1.6]),
                    Self.directional(intensity: 5_200, from: [-1.7, 0.7, -1.5])]
        for rim in rims { content.add(rim) }
        return rims
    }

    /// Key / fill / rim, echoing the design's studio: one bright source high
    /// and to the left, a dim fill, and two rims to separate the figure from a
    /// near-black ground. Only a fallback since the studio light (2026-10-22).
    private func addLighting(to content: RealityViewCameraContent) {
        // Rim-led: the back pair does most of the work of separating a
        // near-black figure from a near-black ground, while the key stays low
        // enough that the emissive worked muscles still read as the brightest
        // thing on screen.
        content.add(Self.directional(intensity: 3_200, from: [-1.4, 1.6, 1.8]))
        content.add(Self.directional(intensity: 900, from: [1.8, 0.4, 1.2]))
        addRims(to: content)
    }
}
