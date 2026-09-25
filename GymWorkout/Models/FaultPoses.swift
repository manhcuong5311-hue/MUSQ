//
//  FaultPoses.swift
//  GymWorkout
//
//  Common mistakes as poses: which limbs a mistake changes and how. The
//  trainer draws them as a yellow line "ghost" over the lifter, who keeps
//  doing the rep correctly, so the two can be compared as they move.
//
//  Moves are measured on the lifter's own body, not the screen, so they hold
//  through the whole rep and from any angle the viewer turns the model to:
//  distances are in torso lengths (neck to pelvis) along the lifter's axes,
//  and turns swing a limb about a joint.
//

import Foundation

/// One of the lifter's own directions.
enum BodyAxis {
    /// Out of the chest.
    case forward
    /// Toward the head.
    case up
    /// Toward the lifter's left; the side-to-side axis.
    case lateral
}

enum FaultMove {
    /// Moves points in torso lengths. `outward` is away from the midline:
    /// left for `_L` joints, right for `_R` joints. `ahead` and `rise` are
    /// the room's directions, for hinged lifters whose chest faces the floor:
    /// level with the floor in the direction they face, and straight up.
    case shift([String], forward: Float = 0, up: Float = 0, outward: Float = 0,
               ahead: Float = 0, rise: Float = 0)
    /// Swings points about a pivot joint, around one of the lifter's axes. A
    /// positive angle turns a left limb toward the head (about `.forward`), the
    /// front (about `.up`), or turns it front-to-head (about `.lateral`); `_R`
    /// limbs mirror it, so one move reads the same on both sides.
    case turn(pivot: String, points: [String], axis: BodyAxis, degrees: Float)
    /// Puts a knee or elbow on the straight line between its neighbours — a
    /// locked joint — and `past` torso lengths beyond it, against the way it
    /// bent, for one forced past straight.
    case straighten([String], past: Float = 0)
    /// Re-seats a knee or elbow between its neighbours once they have moved,
    /// keeping both bones' lengths and the way it bends: hips that rise open
    /// the knees under them, a heel that lifts drives the knee forward.
    case resolve([String])
}

/// How much of a fault shows at each moment of the rep.
enum FaultStrength {
    /// The same throughout.
    case always
    /// With how bent a joint is — none when straight, all of it at 90° or
    /// more — so a fault of the bottom of the rep fades out at lockout.
    /// `forearm_L` is the elbow, `shin_L` the knee, `thigh_L` the hip.
    case withBend(String)
    /// The opposite: all of it with the joint straight, none at 90° — for
    /// faults of the lockout.
    case whenStraight(String)
    /// With the distance between two joints, in torso lengths: none at
    /// `from`, all of it at `to` — for lifts that spread the legs rather than
    /// bend them.
    case between(String, String, from: Float, to: Float)
}

/// A mistake drawn as the limbs it changes.
///
/// Joint names are the rig's (`upper_arm_L` is the shoulder, `forearm_L` the
/// elbow, `hand_L` the wrist, `thigh_L` the hip, `shin_L` the knee, `foot_L`
/// the ankle). `name.tip` is further along that bone — the middle of the
/// palm, where a bar sits, for a hand; the toes for a foot. A `*` stands for
/// both sides: `hand_*` is `hand_L` and `hand_R`. For lifts that alternate
/// legs, `_front` and `_back` stand for the side whose foot is further ahead
/// and the other, decided afresh every frame.
struct FaultPose {
    /// Joints joined into the ghost's lines, each list one polyline.
    let chains: [[String]]
    /// Applied in order to the lifter's real pose.
    let moves: [FaultMove]
    var strength: FaultStrength = .always
    /// How far to turn the model about the vertical, in radians, while the
    /// mistake shows, when the exercise's own framing looks along the fault:
    /// negative brings the lifter's left side round to the camera.
    var view: Float = 0

    init(chains: [[String]], moves: [FaultMove], strength: FaultStrength = .always, view: Float = 0) {
        self.chains = chains.flatMap(FaultPose.sides)
        self.moves = moves.flatMap(FaultPose.sides)
        self.strength = strength
        self.view = view
    }

    /// The same fault, seen from another side.
    func seen(_ view: Float) -> FaultPose {
        var copy = self
        copy.view = view
        return copy
    }

    /// Every joint the ghost reads, tips resolved to their bone.
    var joints: Set<String> {
        var names = Set(chains.joined())
        for move in moves {
            switch move {
            case .shift(let points, _, _, _, _, _): names.formUnion(points)
            case .turn(let pivot, let points, _, _): names.insert(pivot); names.formUnion(points)
            case .straighten(let points, _), .resolve(let points):
                for point in points {
                    names.insert(point)
                    if let (a, b) = FaultPose.neighbours(point) { names.insert(a); names.insert(b) }
                }
            }
        }
        switch strength {
        case .withBend(let joint), .whenStraight(let joint):
            if let (a, b) = FaultPose.neighbours(joint) { names.formUnion([joint, a, b]) }
        case .between(let a, let b, _, _):
            names.formUnion([a, b])
        case .always:
            break
        }
        if alternates { names.formUnion(["foot_L", "foot_R"]) }
        // Both sides of a leading or trailing leg, since either may lead.
        return Set(names.flatMap { name -> [String] in
            let bone = FaultPose.bone(name)
            guard bone.hasSuffix("_front") || bone.hasSuffix("_back") else { return [bone] }
            let stem = bone[..<bone.lastIndex(of: "_")!]
            return ["\(stem)_L", "\(stem)_R"]
        })
    }

    // MARK: - Leading leg

    /// Whether the fault names the leading or trailing leg.
    var alternates: Bool {
        rename { $0 }.1
    }

    /// The fault with `_front` and `_back` made `side` and the other side.
    func leading(_ side: String) -> FaultPose {
        let other = side == "L" ? "R" : "L"
        return rename {
            $0.replacingOccurrences(of: "_front", with: "_" + side)
              .replacingOccurrences(of: "_back", with: "_" + other)
        }.0
    }

    /// Every joint name passed through `change`, and whether any changed.
    private func rename(_ change: (String) -> String) -> (FaultPose, Bool) {
        var changed = false
        func name(_ n: String) -> String {
            let new = change(n)
            if n.contains("_front") || n.contains("_back") { changed = true }
            return new
        }
        let moves = moves.map { move -> FaultMove in
            switch move {
            case .shift(let points, let forward, let up, let outward, let ahead, let rise):
                return .shift(points.map(name), forward: forward, up: up, outward: outward, ahead: ahead, rise: rise)
            case .turn(let pivot, let points, let axis, let degrees):
                return .turn(pivot: name(pivot), points: points.map(name), axis: axis, degrees: degrees)
            case .straighten(let points, let past):
                return .straighten(points.map(name), past: past)
            case .resolve(let points):
                return .resolve(points.map(name))
            }
        }
        let strength: FaultStrength
        switch self.strength {
        case .always: strength = .always
        case .withBend(let joint): strength = .withBend(name(joint))
        case .whenStraight(let joint): strength = .whenStraight(name(joint))
        case .between(let a, let b, let from, let to): strength = .between(name(a), name(b), from: from, to: to)
        }
        let pose = FaultPose(chains: chains.map { $0.map(name) }, moves: moves, strength: strength, view: view)
        return (pose, changed)
    }

    /// The joints either side of an elbow, knee or hip: shoulder and wrist,
    /// hip and ankle, trunk and knee.
    static func neighbours(_ joint: String) -> (String, String)? {
        let side = joint.hasSuffix("_R") ? "R" : "L"
        if joint.hasPrefix("forearm") { return ("upper_arm_\(side)", "hand_\(side)") }
        if joint.hasPrefix("shin") { return ("thigh_\(side)", "foot_\(side)") }
        // The hip, between the trunk and the knee: only read for how far it
        // bends, never moved.
        if joint.hasPrefix("thigh") { return ("spine", "shin_\(side)") }
        return nil
    }

    /// `hand_L.tip` → `hand_L`.
    static func bone(_ name: String) -> String {
        name.hasSuffix(".tip") ? String(name.dropLast(4)) : name
    }

    /// Bone length to a tip, in torso lengths.
    static func tipLength(_ bone: String) -> Float {
        bone.hasPrefix("foot") ? 0.38 : 0.2
    }

    // MARK: - Both sides

    private static func sides(_ names: [String]) -> [[String]] {
        names.contains { $0.contains("*") }
            ? ["L", "R"].map { side in names.map { $0.replacingOccurrences(of: "*", with: side) } }
            : [names]
    }

    /// Both sides' points in one list, each midline point once.
    private static func bothSides(_ points: [String]) -> [String] {
        var seen = Set<String>()
        return sides(points).flatMap { $0 }.filter { seen.insert($0).inserted }
    }

    private static func sides(_ move: FaultMove) -> [FaultMove] {
        switch move {
        case .shift(let points, let forward, let up, let outward, let ahead, let rise):
            // One move for both sides: each point's own side sets `outward`,
            // and a midline point listed with sided ones moves once.
            return [.shift(bothSides(points), forward: forward, up: up, outward: outward, ahead: ahead, rise: rise)]
        case .turn(let pivot, let points, let axis, let degrees):
            // A shared pivot (the pelvis) carries both sides in one move.
            guard pivot.contains("*") else {
                return [.turn(pivot: pivot, points: bothSides(points), axis: axis, degrees: degrees)]
            }
            return ["L", "R"].map { side in
                .turn(pivot: pivot.replacingOccurrences(of: "*", with: side),
                      points: points.map { $0.replacingOccurrences(of: "*", with: side) },
                      axis: axis, degrees: degrees)
            }
        case .straighten(let points, let past):
            return sides(points).map { .straighten($0, past: past) }
        case .resolve(let points):
            return sides(points).map { .resolve($0) }
        }
    }
}

/// The faults authored so far, by exercise and cue.
enum FaultPoses {

    static func fault(exercise: String, cue: String) -> FaultPose? {
        table[exercise]?[cue]
    }

    /// Joints the trainer must track for an exercise's faults, including the
    /// four that fix the lifter's body axes.
    static func joints(for exercise: String) -> [String] {
        guard let faults = table[exercise] else { return [] }
        var names = Set(BodyFrameJoints.all)
        for fault in faults.values { names.formUnion(fault.joints) }
        return names.sorted()
    }

    // MARK: - Pieces

    private static let arms = ["upper_arm_*", "forearm_*", "hand_*"]
    private static let armsToGrip = ["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"]
    private static let legs = ["thigh_*", "shin_*", "foot_*", "foot_*.tip"]
    private static let hips = ["thigh_L", "thigh_R"]
    private static let bar = ["hand_L.tip", "hand_R.tip"]
    private static let spine = ["pelvis", "spine", "chest", "neck", "head"]
    /// Shoulder to neck to shoulder: the girdle a shrug lifts.
    private static let shoulders = ["upper_arm_L", "neck", "upper_arm_R"]

    /// The wrist bent back under the load: the grip rolls toward the face.
    private static func wristBentBack(withBar: Bool) -> FaultPose {
        FaultPose(
            chains: [["forearm_*", "hand_*", "hand_*.tip"]] + (withBar ? [bar] : []),
            moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .lateral, degrees: 48)]
        )
    }

    /// Upper arms flared toward 90° while the hands stay put. Turning about
    /// the chest's own axis means nothing changes with the arms straight.
    private static func elbowsFlared(_ degrees: Float = 38) -> FaultPose {
        FaultPose(chains: [arms],
                  moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*"], axis: .forward, degrees: degrees)])
    }

    /// Lying on a bench: heels up with the toes left down, hips lifting.
    private static let benchFeet = FaultPose(
        chains: [legs, hips],
        moves: [
            .shift(["foot_*"], forward: 0.17),
            .shift(["shin_*"], forward: 0.08),
            .shift(["thigh_*"], forward: 0.12)
        ]
    )

    /// Lying on a bench: shoulders rolled up off it, arms carried along.
    private static let benchShoulders = FaultPose(
        chains: [arms, ["upper_arm_L", "upper_arm_R"]],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], forward: 0.12, outward: -0.04)]
    )

    /// Bar or dumbbells lowered toward the neck, elbows flaring with them.
    private static func pressedHigh(_ up: Float, withBar: Bool) -> FaultPose {
        FaultPose(
            chains: [armsToGrip] + (withBar ? [bar] : []),
            moves: [
                .shift(["hand_*", "hand_*.tip"], up: up),
                .turn(pivot: "upper_arm_*", points: ["forearm_*"], axis: .forward, degrees: 20)
            ]
        )
    }

    /// A fly's arms sinking below the line of the torso at the bottom.
    private static let flyTooDeep = FaultPose(
        chains: [armsToGrip],
        moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .up, degrees: -28)]
    )

    /// A fly's elbows bending further, turning the arc into a press.
    private static let flyBentIntoPress = FaultPose(
        chains: [armsToGrip],
        moves: [.turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .up, degrees: 45)]
    )

    /// Shoulders shrugged toward the ears, the arms lifted with them.
    private static let shrugged = FaultPose(
        chains: [shoulders, arms],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.12)]
    )

    /// Knees locked straight.
    private static let lockedKneesOnly = FaultPose(chains: [legs], moves: [.straighten(["shin_*"])])

    /// Standing square and stiff: feet drawn in, knees locked straight.
    private static let squareLockedStance = FaultPose(
        chains: [legs],
        moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.1), .straighten(["shin_*"])]
    )

    // MARK: Back pieces

    /// Everything above the pelvis, for turning the whole trunk.
    private static let trunk = ["spine", "chest", "neck", "head", "upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"]

    /// Elbows winging out to the sides at the top of a pull.
    private static let elbowsWinged = FaultPose(
        chains: [arms], moves: [.shift(["forearm_*"], outward: 0.14)], strength: .withBend("forearm_L")
    )

    /// Rowing high, toward the chest: the hands ride up, the elbows flare.
    private static func rowedHigh(withBar: Bool) -> FaultPose {
        FaultPose(
            chains: [armsToGrip] + (withBar ? [bar] : []),
            moves: [.shift(["hand_*", "hand_*.tip"], up: 0.14), .shift(["forearm_*"], up: 0.04, outward: 0.1)],
            strength: .withBend("forearm_L")
        )
    }

    /// Hands (or the bar) held wider than shoulder-width.
    private static func gripTooWide(withBar: Bool) -> FaultPose {
        FaultPose(
            chains: [armsToGrip] + (withBar ? [bar] : []),
            moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.13), .shift(["forearm_*"], outward: 0.08)]
        )
    }

    /// Shoulders left rounded forward, the arms hanging from them.
    private static let shouldersForward = FaultPose(
        chains: [arms, ["upper_arm_L", "upper_arm_R"]],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], forward: 0.11, outward: -0.03)]
    )

    /// The trunk swinging back toward upright to heave the weight.
    private static func trunkLifted(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, arms], moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: degrees)])
    }

    /// The back rounding: the middle of the spine humps up, the head drops.
    private static func backRounded(_ strength: FaultStrength = .always) -> FaultPose {
        FaultPose(
            chains: [spine],
            moves: [
                .shift(["spine"], forward: -0.07),
                .shift(["chest"], forward: -0.05),
                .shift(["neck"], forward: 0.05),
                .shift(["head"], forward: 0.12)
            ],
            strength: strength
        )
    }

    /// Kipping: the legs swing forward from the hips.
    private static let kipping = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["pelvis", "thigh_*"], forward: 0.05),
                .turn(pivot: "thigh_*", points: ["shin_*", "foot_*", "foot_*.tip"], axis: .lateral, degrees: 38)]
    )

    /// Upper arms flared out to the sides on a pulldown, the hands on the bar.
    private static let pulldownFlared = FaultPose(
        chains: [arms], moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*"], axis: .forward, degrees: 30)]
    )

    /// Sliding forward on the seat.
    private static let slidForward = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["thigh_*"], forward: 0.13), .shift(["shin_*"], forward: 0.08)]
    )

    /// Hands never reaching the stretch: they stay short of full extension.
    private static let rangeCutShort = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.14), .shift(["forearm_*"], forward: -0.06)]
    )

    /// The chest lifting off a support pad, arms carried with it.
    private static let chestOffPad = FaultPose(
        chains: [spine, arms],
        moves: [.shift(["chest", "upper_arm_*", "forearm_*", "hand_*"], forward: -0.1),
                .shift(["neck", "head"], forward: -0.14)]
    )

    // MARK: Leg pieces

    /// Turns that bring a straight-on lifter side-on (left side to the
    /// camera), or a side-on one round to face it.
    private static let sideOn: Float = -1.1
    private static let faceOn: Float = 1.1
    /// The leg press and hack squat turned to a true side view of the sled.
    private static let sledSide: Float = -0.97

    /// Hip, knee, ankle and toes of one leg: `L`, `R`, `*`, `front` or `back`.
    private static func leg(_ side: String) -> [String] {
        ["thigh_\(side)", "shin_\(side)", "foot_\(side)", "foot_\(side).tip"]
    }

    /// The knee a one-leg fault reads its bend from.
    private static func knee(_ side: String) -> String {
        side == "*" ? "shin_L" : "shin_\(side)"
    }

    /// The hips and everything they carry.
    private static let carried = ["pelvis", "thigh_*"] + trunk
    /// Just the trunk and head, without the arms.
    private static let torso = ["spine", "chest", "neck", "head"]

    /// Knees caving in over planted feet.
    private static func kneesIn(_ side: String = "*", _ amount: Float = 0.17) -> FaultPose {
        FaultPose(chains: [leg(side), hips], moves: [.shift(["shin_\(side)"], outward: -amount)],
                  strength: .withBend(knee(side)))
    }

    /// The heel lifting: the foot rocks up onto the toes and the knee drives
    /// forward over them.
    private static func heelsUp(_ side: String = "*") -> FaultPose {
        FaultPose(chains: [leg(side)],
                  moves: [.turn(pivot: "foot_\(side).tip", points: ["foot_\(side)"], axis: .lateral, degrees: -24),
                          .resolve(["shin_\(side)"])],
                  strength: .withBend(knee(side)))
    }

    /// Stopping high: the hips and all they carry held `rise` torso lengths
    /// up, the knees opening under them.
    private static func shallow(_ rise: Float, ahead: Float = 0, withBar: Bool = false, withArms: Bool = true) -> FaultPose {
        FaultPose(chains: [spine, legs, hips] + (withArms ? [armsToGrip] : []) + (withBar ? [bar] : []),
                  moves: [.shift(carried, ahead: ahead, rise: rise), .resolve(["shin_*"])],
                  strength: .withBend("shin_L"))
    }

    /// The trunk tipping forward from the hips, the arms and load with it.
    private static func leanedForward(_ degrees: Float, withBar: Bool = false,
                                      strength: FaultStrength = .withBend("shin_L")) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -degrees)],
                  strength: strength)
    }

    /// The trunk leaning forward and rounding as it goes: the lower back
    /// humps, the chest drops toward the knees.
    private static func chestDropped(_ degrees: Float, withBar: Bool = false,
                                     strength: FaultStrength = .withBend("shin_L")) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -degrees),
                          .shift(["spine"], forward: -0.08), .shift(["chest"], forward: -0.03),
                          .shift(["neck"], forward: 0.04), .shift(["head"], forward: 0.1)],
                  strength: strength)
    }

    /// The upper back rounding and the head dropping.
    private static func headDropped(_ strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [spine],
                  moves: [.shift(["chest"], forward: -0.06), .shift(["neck"], forward: 0.06), .shift(["head"], forward: 0.18)],
                  strength: strength)
    }

    /// The lower back arching: the middle of the spine sinks toward the belly.
    private static func lowerBackArched(_ amount: Float = 0.09, _ strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [spine], moves: [.shift(["spine"], forward: amount), .shift(["chest"], forward: amount * 0.45)],
                  strength: strength)
    }

    /// A split stance's rear leg pushing the body up: the rear knee locks
    /// straight.
    private static func rearLegPushing(_ side: String, strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [leg(side), hips], moves: [.straighten(["shin_\(side)"])], strength: strength)
    }

    /// Hanging arms swinging forward from the shoulders, the load with them.
    private static func armsSwungForward(_ degrees: Float, withBar: Bool = false,
                                         strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: degrees)],
                  strength: strength)
    }

    /// Knees locked hard at the top, pushed past straight.
    private static let kneesSnapped = FaultPose(chains: [legs], moves: [.straighten(["shin_*"], past: 0.05)],
                                                strength: .whenStraight("shin_L"))

    /// Hinging with the knees instead of the hips: the hips drop and come
    /// forward, the trunk rises, the knees bend — a squat.
    private static func hingeSquatted(withBar: Bool) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, legs, hips] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 22),
                          .shift(carried, ahead: 0.1, rise: -0.22), .resolve(["shin_*"])],
                  strength: .withBend("thigh_L"))
    }

    /// Hinging while the knees keep bending: the hips sink.
    private static func hingeKneesBending(withBar: Bool) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, legs, hips] + (withBar ? [bar] : []),
                  moves: [.shift(carried, ahead: 0.04, rise: -0.13), .resolve(["shin_*"])],
                  strength: .withBend("thigh_L"))
    }

    /// Lying face down on a curl bench: the hips lifting off the pad.
    private static let proneHipsUp = FaultPose(
        chains: [spine, legs, hips],
        moves: [.shift(["pelvis", "thigh_*"], rise: 0.12), .shift(["spine"], rise: 0.05)],
        strength: .withBend("shin_L")
    )

    /// A curl stopping short: the knees open back toward straight.
    private static func curlShort(_ side: String, _ degrees: Float) -> FaultPose {
        FaultPose(chains: [leg(side)],
                  moves: [.turn(pivot: "shin_\(side)", points: ["foot_\(side)", "foot_\(side).tip"], axis: .lateral, degrees: degrees)],
                  strength: .withBend(knee(side)))
    }

    /// Lying too far up a curl bench: the knees sit off the machine's pivot.
    private static let proneSlidUp = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip"], up: 0.13)]
    )

    /// A bridge's ribs flaring: the lower back arches the hips higher.
    private static let bridgeArched = FaultPose(
        chains: [spine],
        moves: [.shift(["spine"], rise: 0.09), .shift(["chest"], rise: 0.04)],
        strength: .whenStraight("thigh_L")
    )

    /// The trunk tipping over to the right, away from a left leg that lifts.
    private static func leanedAway(_ degrees: Float, strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [spine, shoulders],
                  moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .forward, degrees: degrees)],
                  strength: strength)
    }

    /// Hauling on a support in the right hand: the body leans over to it and
    /// the arm bends.
    private static func pulledOnSupport(strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [spine, shoulders, ["upper_arm_R", "forearm_R", "hand_R"]],
                  moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .forward, degrees: 12),
                          .shift(["forearm_R"], forward: -0.04, up: -0.08),
                          .resolve(["forearm_R"])],
                  strength: strength)
    }

    /// The left foot's toes turned up to the ceiling.
    private static func toesUp(_ degrees: Float, _ strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [leg("L")],
                  moves: [.turn(pivot: "foot_L", points: ["foot_L.tip"], axis: .lateral, degrees: degrees)],
                  strength: strength)
    }

    /// Seated: pushing through the feet, the knees opening like a leg press.
    private static let seatedFeetPushing = FaultPose(
        chains: [legs], moves: [.shift(["foot_*", "foot_*.tip"], ahead: 0.12), .resolve(["shin_*"])]
    )

    /// Seated with the hands on the handles: the trunk rocking forward
    /// (negative) or back, the elbows bending to haul it.
    private static func seatedRocked(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, arms],
                  moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .lateral, degrees: degrees),
                          .resolve(["forearm_*"])])
    }

    // MARK: Shoulder pieces

    /// Shoulder to grip for one arm: `L`, `R` or `*`.
    private static func arm(_ side: String) -> [String] {
        ["upper_arm_\(side)", "forearm_\(side)", "hand_\(side)", "hand_\(side).tip"]
    }

    /// The elbow a one-arm fault reads its bend from.
    private static func elbow(_ side: String) -> String {
        side == "*" ? "forearm_L" : "forearm_\(side)"
    }

    /// Whole arms swung about the shoulders: about `.forward` a positive turn
    /// raises arms held out to the sides, about `.lateral` it raises arms held
    /// in front, about `.up` it swings them forward.
    private static func armsTurned(_ axis: BodyAxis, _ degrees: Float, side: String = "*", withBar: Bool = false,
                                   strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [arm(side)] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "upper_arm_\(side)", points: ["forearm_\(side)", "hand_\(side)", "hand_\(side).tip"],
                                axis: axis, degrees: degrees)],
                  strength: strength)
    }

    /// The forearms folding about the elbows.
    private static func elbowsFolded(_ axis: BodyAxis, _ degrees: Float, side: String = "*",
                                     strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [arm(side)],
                  moves: [.turn(pivot: "forearm_\(side)", points: ["hand_\(side)", "hand_\(side).tip"], axis: axis, degrees: degrees)],
                  strength: strength)
    }

    /// Leaning back from the hips with the arms and load carried along;
    /// `arch` sinks the lower back as well.
    private static func leanedBack(_ degrees: Float, arch: Float = 0, withBar: Bool = false) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: degrees),
                          .shift(["spine"], forward: arch), .shift(["chest"], forward: arch * 0.45)])
    }

    /// Seated: the feet pulled back under the seat and up on the toes.
    private static let feetTucked = FaultPose(
        chains: [legs],
        moves: [.shift(["foot_*", "foot_*.tip"], ahead: -0.16),
                .turn(pivot: "foot_*.tip", points: ["foot_*"], axis: .lateral, degrees: -25),
                .resolve(["shin_*"])]
    )

    /// Shrugging up and pinching back at the end of a rear-delt pull.
    private static let shruggedBack = FaultPose(
        chains: [shoulders, arms],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], forward: -0.06, up: 0.12)]
    )

    // MARK: Arm pieces

    /// Upper arms swinging forward off the sides as the elbows bend.
    private static func elbowsForward(_ degrees: Float, side: String = "*", withBar: Bool = false) -> FaultPose {
        armsTurned(.lateral, degrees, side: side, withBar: withBar, strength: .withBend(elbow(side)))
    }

    /// Rocking the hips forward and the trunk back to heave the weight up.
    private static func bodySwung(withBar: Bool) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, hips] + (withBar ? [bar] : []),
                  moves: [.shift(["pelvis", "thigh_*"], ahead: 0.06),
                          .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 15)],
                  strength: .withBend("forearm_L"))
    }

    /// Hunched over the handle: the shoulders up and rolled forward.
    private static func hunched(_ side: String = "*") -> FaultPose {
        FaultPose(chains: [shoulders, arm(side)],
                  moves: [.shift(["upper_arm_\(side)", "forearm_\(side)", "hand_\(side)", "hand_\(side).tip"], forward: 0.07, up: 0.1)])
    }

    /// A pushdown stopped short: the elbows stay bent at the bottom, shown
    /// only near lockout (`from`…`to` is shoulder-to-wrist in torso lengths).
    private static func pushdownShort(_ side: String = "*", from: Float, to: Float) -> FaultPose {
        elbowsFolded(.lateral, 40, side: side, strength: .between("upper_arm_L", "hand_L", from: from, to: to))
    }

    /// Standing so close to the stack the elbows get jammed back.
    private static let crowdingTheStack = FaultPose(
        chains: [spine, legs, arms],
        moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip", "upper_arm_*"] + torso, ahead: 0.12),
                .resolve(["forearm_*"])]
    )

    /// Overhead extension: the elbows splaying out as the weight lowers.
    private static let overheadElbowsOut = FaultPose(
        chains: [armsToGrip], moves: [.shift(["forearm_*"], outward: 0.12), .resolve(["forearm_*"])],
        strength: .withBend("forearm_L")
    )

    /// Dips: the body sinks with the hands fixed, the shoulders rolling
    /// forward. The feet stay planted on a bench dip; kneeling on an assisted
    /// dip's pad, the legs ride down with it.
    private static func dipSunk(_ rise: Float, legsRide: Bool = false, strength: FaultStrength) -> FaultPose {
        let legJoints = legsRide ? ["shin_*", "foot_*", "foot_*.tip"] : []
        return FaultPose(chains: [spine, arms, legs, hips],
                         moves: [.shift(["pelvis", "thigh_*", "upper_arm_*"] + torso + legJoints, rise: rise),
                                 .shift(["upper_arm_*"], forward: 0.06),
                                 .resolve(legsRide ? ["forearm_*"] : ["forearm_*", "shin_*"])],
                         strength: strength)
    }

    // MARK: Core pieces

    /// Lying face down: the hips sagging toward the floor.
    private static let hipsSagging = FaultPose(
        chains: [spine, ["pelvis", "thigh_L"], ["pelvis", "thigh_R"], ["thigh_*", "shin_*", "foot_*"]],
        moves: [.shift(["spine"], forward: 0.08), .shift(["pelvis", "thigh_*"], forward: 0.16), .shift(["shin_*"], forward: 0.07)]
    )

    /// Lying face up: the head yanked forward, chin to the chest, the hands
    /// behind it pulling.
    private static let headYanked = FaultPose(
        chains: [["chest", "neck", "head"], armsToGrip],
        moves: [.turn(pivot: "neck", points: ["head", "forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -35),
                .resolve(["forearm_*"])]
    )

    /// Lying face up: sitting all the way up from the hips.
    private static func satUp(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip], moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -degrees)])
    }

    /// Hanging: loose from the shoulders, the body sinking between them.
    private static let hangingLoose = FaultPose(
        chains: [spine, shoulders, legs, arms],
        moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip"] + torso, rise: -0.1),
                .shift(["upper_arm_*"], rise: -0.03), .resolve(["forearm_*"])]
    )

    /// Raising the legs with the lower back still arched: the pelvis never
    /// tucks and the legs stop lower.
    private static let legsRaisedArched = FaultPose(
        chains: [spine, legs, hips],
        moves: [.shift(["spine"], forward: 0.09),
                .turn(pivot: "thigh_*", points: ["shin_*", "foot_*", "foot_*.tip"], axis: .lateral, degrees: -15)],
        strength: .withBend("thigh_L")
    )

    /// Swinging the legs back behind the body at the bottom, to kick them up.
    private static let legsSwungBack = FaultPose(
        chains: [legs, hips],
        moves: [.turn(pivot: "thigh_*", points: ["shin_*", "foot_*", "foot_*.tip"], axis: .lateral, degrees: -30)],
        strength: .whenStraight("thigh_L")
    )

    /// Russian twist toward the left, where the fault is drawn.
    private static let twistedLeft = FaultStrength.between("hand_L", "thigh_L", from: 0.745, to: 0.693)

    // MARK: - Table

    private static let table: [String: [String: FaultPose]] = [
        // MARK: Chest
        "Barbell Bench Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(),
            // Bar lowered to the neck.
            "barpath": pressedHigh(0.26, withBar: true),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Incline Barbell Bench Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(),
            // Touching at the collarbone, pressing more overhead than up.
            "barpath": pressedHigh(0.2, withBar: true),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Decline Barbell Bench Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(),
            // Bounced: the bar sinks into the chest at the bottom.
            "barpath": FaultPose(
                chains: [armsToGrip, bar],
                moves: [
                    .shift(["hand_*", "hand_*.tip"], forward: -0.1),
                    .shift(["forearm_*"], forward: -0.06)
                ],
                strength: .withBend("forearm_L")
            ),
            // Feet slipping out of the pads, the hips sliding up the bench.
            "feet": FaultPose(
                chains: [legs, hips],
                moves: [
                    .shift(["foot_*", "foot_*.tip"], forward: 0.1, up: 0.14),
                    .shift(["shin_*"], forward: 0.06, up: 0.14),
                    .shift(["thigh_*"], up: 0.12)
                ]
            ),
            "scapula": benchShoulders
        ],
        "Dumbbell Bench Press": [
            "wrist": wristBentBack(withBar: false),
            // Elbows sinking below the torso at the bottom.
            "elbow": FaultPose(chains: [arms], moves: [.shift(["forearm_*"], forward: -0.12)],
                               strength: .withBend("forearm_L")),
            // Pressed straight up like a barbell: the dumbbells never meet.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip", "forearm_*"], outward: 0.12)]),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Incline Dumbbell Press": [
            "wrist": wristBentBack(withBar: false),
            "elbow": elbowsFlared(34),
            // Bench too steep: pressing more overhead than up.
            "barpath": pressedHigh(0.22, withBar: false),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Dumbbell Fly": [
            // Dumbbells drifting apart.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.1)]),
            "elbow": flyBentIntoPress,
            "barpath": flyTooDeep,
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Incline Dumbbell Fly": [
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.1)]),
            "elbow": flyBentIntoPress,
            "barpath": flyTooDeep,
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Chest Press Machine": [
            // Handles gripped too high: hands and elbows ride up.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: 0.14), .shift(["forearm_*"], up: 0.1)]),
            "elbow": elbowsFlared(34),
            // Short reps: the hands stop well short of full extension.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.16),
                                         .shift(["forearm_*"], forward: -0.08)]),
            // Back arched off the pad, heels up.
            "feet": FaultPose(
                chains: [["pelvis", "spine", "chest", "neck"], legs],
                moves: [
                    .shift(["spine"], forward: 0.07),
                    .shift(["chest", "neck"], forward: 0.1),
                    .shift(["foot_*"], up: 0.07)
                ]
            ),
            "scapula": shrugged
        ],
        "Pec Deck Fly": [
            // Pushing through the hands: the elbows leave the pads.
            "wrist": FaultPose(chains: [arms],
                               moves: [.shift(["forearm_*"], forward: -0.06, up: -0.12)]),
            // Elbows dropped below shoulder height.
            "elbow": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["forearm_*", "hand_*", "hand_*.tip"], up: -0.15)]),
            // Swung and released: the arms fly open behind the body.
            "barpath": flyTooDeep,
            // Feet tucked up under the seat, off the floor.
            "feet": FaultPose(chains: [legs],
                              moves: [.shift(["foot_*", "foot_*.tip"], forward: -0.12, up: 0.1),
                                      .shift(["shin_*"], forward: -0.03)]),
            // Twisting off the backrest: the upper body leans away from it.
            "scapula": FaultPose(chains: [spine, shoulders],
                                 moves: [.turn(pivot: "pelvis",
                                               points: ["spine", "chest", "neck", "head", "upper_arm_L", "upper_arm_R"],
                                               axis: .forward, degrees: 12)])
        ],
        "Cable Fly": [
            // Hands meeting too high.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: 0.18), .shift(["forearm_*"], up: 0.08)]),
            // Elbows bending in: the hands fold toward the chest. Seen head-on,
            // so the moves stay in the plane the camera sees.
            "elbow": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], forward: 0.08, outward: -0.14),
                                       .shift(["forearm_*"], up: -0.05, outward: -0.06)]),
            // Pressing: the elbows tuck in and drive forward.
            "barpath": FaultPose(chains: [arms],
                                 moves: [.shift(["forearm_*"], forward: 0.12, up: -0.04, outward: -0.12)]),
            "feet": squareLockedStance,
            // Shoulders rolled forward and in.
            "scapula": FaultPose(chains: [arms, ["upper_arm_L", "upper_arm_R"]],
                                 moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], forward: 0.1, up: 0.03, outward: -0.08)])
        ],
        "Low-to-High Cable Fly": [
            // Hands pulled up past the head.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: 0.24), .shift(["forearm_*"], up: 0.14)]),
            // Elbows bending as the arms rise, pressing upward.
            "elbow": FaultPose(chains: [armsToGrip],
                               moves: [.turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: 40)]),
            // Pulled straight across at chest height instead of rising.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], up: -0.14), .shift(["forearm_*"], up: -0.06)]),
            "feet": squareLockedStance,
            "scapula": shrugged
        ],
        "Push-Up": [
            // Hips sagging toward the floor.
            "body": FaultPose(
                chains: [spine, ["pelvis", "thigh_L"], ["pelvis", "thigh_R"], ["thigh_*", "shin_*", "foot_*"]],
                moves: [
                    .shift(["spine"], forward: 0.08),
                    .shift(["pelvis", "thigh_*"], forward: 0.16),
                    .shift(["shin_*"], forward: 0.07)
                ]
            ),
            // Hands placed forward, toward the head.
            "hands": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: 0.26), .shift(["forearm_*"], up: 0.12)]),
            "elbow": elbowsFlared(),
            // Short reps: the chest stays high at the bottom.
            "depth": FaultPose(
                chains: [spine, arms],
                moves: [
                    .shift(["head", "neck", "chest", "upper_arm_*"], forward: -0.2),
                    .shift(["spine"], forward: -0.15),
                    .shift(["pelvis"], forward: -0.1),
                    .shift(["forearm_*"], forward: -0.1)
                ],
                strength: .withBend("forearm_L")
            ),
            // Feet sliding back along the floor.
            "feet": FaultPose(chains: [legs],
                              moves: [.shift(["foot_*", "foot_*.tip"], up: -0.14), .shift(["shin_*"], up: -0.06)])
        ],

        // MARK: Back
        "Deadlift": [
            // Bar drifting out in front of the shins.
            "barpath": FaultPose(chains: [armsToGrip, bar],
                                 moves: [.shift(["hand_*", "hand_*.tip"], ahead: 0.13), .shift(["forearm_*"], ahead: 0.07)]),
            // Hips shooting up first, knees locking: a stiff-legged good morning.
            "hips": FaultPose(
                chains: [spine, legs, hips],
                moves: [.shift(["pelvis", "thigh_*"], rise: 0.14), .shift(["spine"], rise: 0.07), .straighten(["shin_*"])],
                strength: .withBend("shin_L")
            ),
            // Starting with the bar over the toes.
            "feet": FaultPose(chains: [armsToGrip, bar],
                              moves: [.shift(["hand_*", "hand_*.tip"], ahead: 0.15), .shift(["forearm_*"], ahead: 0.08)],
                              strength: .withBend("shin_L")),
            "spine": backRounded(.withBend("shin_L"))
        ],
        "Barbell Bent-Over Row": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: true),
            "grip": gripTooWide(withBar: true),
            "feet": trunkLifted(26),
            "scapula": shouldersForward
        ],
        "Dumbbell Row": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: false),
            // Dumbbells drifting out to the sides.
            "grip": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.13)]),
            "feet": trunkLifted(24),
            "scapula": shouldersForward
        ],
        "One-Arm Dumbbell Row": [
            // Only the left arm rows in this model.
            "elbow": FaultPose(chains: [["upper_arm_L", "forearm_L", "hand_L"]],
                               moves: [.shift(["forearm_L"], outward: 0.14)], strength: .withBend("forearm_L")),
            "barpath": FaultPose(chains: [["upper_arm_L", "forearm_L", "hand_L", "hand_L.tip"]],
                                 moves: [.shift(["hand_L", "hand_L.tip"], up: 0.14), .shift(["forearm_L"], outward: 0.08)],
                                 strength: .withBend("forearm_L")),
            // Never lowered to a full stretch.
            "grip": FaultPose(chains: [["upper_arm_L", "forearm_L", "hand_L", "hand_L.tip"]],
                              moves: [.shift(["hand_L", "hand_L.tip"], forward: -0.14), .shift(["forearm_L"], forward: -0.06)]),
            // The trunk twisting open to heave the dumbbell.
            "feet": FaultPose(chains: [spine, shoulders, ["upper_arm_L", "forearm_L", "hand_L"]],
                              moves: [.turn(pivot: "pelvis", points: trunk, axis: .up, degrees: -20)]),
            "scapula": FaultPose(chains: [["upper_arm_L", "forearm_L", "hand_L"], ["upper_arm_L", "upper_arm_R"]],
                                 moves: [.shift(["upper_arm_L", "forearm_L", "hand_L"], forward: 0.11)])
        ],
        "Chest-Supported Dumbbell Row": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: false),
            "grip": rangeCutShort,
            "feet": chestOffPad,
            "scapula": shrugged
        ],
        "Pull-Up": [
            // Elbows drifting forward, curling the body up.
            "elbow": FaultPose(chains: [arms], moves: [.shift(["forearm_*"], forward: 0.15)], strength: .withBend("forearm_L")),
            // Craning the chin up and over while the body stays low.
            "barpath": FaultPose(chains: [["chest", "neck", "head"]],
                                 moves: [.shift(["neck"], forward: 0.06, up: 0.03), .shift(["head"], forward: 0.14, up: 0.06)]),
            "grip": gripTooWide(withBar: false),
            "feet": kipping,
            "scapula": shrugged
        ],
        "Chin-Up": [
            "elbow": elbowsWinged,
            // Short reps: the body stops well below the bar.
            "barpath": FaultPose(
                chains: [spine, arms],
                moves: [.shift(["pelvis", "spine", "chest", "neck", "head", "upper_arm_*"], up: -0.16),
                        .shift(["forearm_*"], up: -0.08)],
                strength: .withBend("forearm_L")
            ),
            "grip": gripTooWide(withBar: false),
            "feet": kipping,
            "scapula": shrugged
        ],
        "Lat Pulldown": [
            "elbow": pulldownFlared,
            // Bar pulled down behind the neck.
            "barpath": FaultPose(chains: [armsToGrip, bar],
                                 moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.2, up: 0.05), .shift(["forearm_*"], forward: -0.1)],
                                 strength: .withBend("forearm_L")),
            "grip": gripTooWide(withBar: true),
            "feet": slidForward,
            // Rocking far back on every rep.
            "spine": trunkLifted(26)
        ],
        "Close-Grip Lat Pulldown": [
            "elbow": pulldownFlared,
            // Handle pulled down past the chest.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], up: -0.15), .shift(["forearm_*"], forward: -0.05, up: -0.05)],
                                 strength: .withBend("forearm_L")),
            "grip": gripTooWide(withBar: false),
            // Rising off the seat.
            "feet": FaultPose(chains: [spine, legs],
                              moves: [.shift(["pelvis", "spine", "chest", "neck", "head", "thigh_*"], up: 0.1),
                                      .shift(["shin_*"], up: 0.04)]),
            "spine": trunkLifted(28)
        ],
        "Seated Cable Row": [
            // Curling the handle in: the elbows stay forward.
            "elbow": FaultPose(chains: [arms], moves: [.shift(["forearm_*"], forward: 0.14)], strength: .withBend("forearm_L")),
            "barpath": rowedHigh(withBar: false),
            "grip": rangeCutShort,
            "feet": lockedKneesOnly,
            // Pulling with the arms while the shoulders stay forward.
            "scapula": shouldersForward
        ],
        "Straight-Arm Pulldown": [
            // Elbows bending into a pushdown.
            "elbow": FaultPose(chains: [armsToGrip],
                               moves: [.turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: 40)]),
            // Pushed straight down: the hands come in toward the body.
            "barpath": FaultPose(chains: [armsToGrip, bar],
                                 moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.12), .shift(["forearm_*"], forward: -0.06, up: -0.04)]),
            // One arm pulling ahead of the other.
            "grip": FaultPose(chains: [armsToGrip, bar],
                              moves: [.shift(["hand_R", "hand_R.tip"], up: -0.12), .shift(["forearm_R"], up: -0.06)]),
            // Standing bolt upright.
            "feet": trunkLifted(20),
            "scapula": shouldersForward
        ],
        "T-Bar Row": [
            "elbow": elbowsWinged,
            // Only a few inches of pull: the hands stay low.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], forward: 0.14), .shift(["forearm_*"], forward: 0.07)],
                                 strength: .withBend("forearm_L")),
            // Reaching for the handles with rounded shoulders.
            "grip": shouldersForward,
            "feet": backRounded(),
            // Stopping before the squeeze: the elbows never pass the trunk.
            "scapula": FaultPose(chains: [arms, ["upper_arm_L", "upper_arm_R"]],
                                 moves: [.shift(["upper_arm_*"], forward: 0.07), .shift(["forearm_*"], forward: 0.1)],
                                 strength: .withBend("forearm_L"))
        ],
        "Chest-Supported Row Machine": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: false),
            "grip": chestOffPad,
            // Driving through the legs: the body pushed back off the pad.
            "feet": FaultPose(chains: [spine, legs],
                              moves: [.shift(["pelvis", "spine", "chest", "neck", "head", "thigh_*"], forward: -0.09),
                                      .shift(["shin_*"], forward: -0.04)]),
            // Stopping short of the squeeze.
            "scapula": FaultPose(chains: [arms],
                                 moves: [.shift(["upper_arm_*"], forward: 0.06), .shift(["forearm_*"], forward: 0.1)],
                                 strength: .withBend("forearm_L"))
        ],
        "High Row Machine": [
            "elbow": pulldownFlared,
            // Handles pulled up toward the face.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], up: 0.14), .shift(["forearm_*"], up: 0.06)],
                                 strength: .withBend("forearm_L")),
            // Grip too narrow.
            "grip": FaultPose(chains: [armsToGrip],
                              moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.1), .shift(["forearm_*"], outward: -0.05)]),
            "feet": slidForward,
            "spine": trunkLifted(22)
        ],
        "Back Extension": [
            // Arching past neutral at the top.
            "spine": trunkLifted(22),
            // Folding from the lower back while the hips stay put.
            "hips": FaultPose(chains: [spine],
                              moves: [.shift(["spine"], forward: 0.04), .shift(["chest"], forward: 0.1),
                                      .shift(["neck"], forward: 0.16), .shift(["head"], forward: 0.22)]),
            // Arms flung forward to yank the body up.
            "grip": FaultPose(chains: [arms],
                              moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*"], axis: .lateral, degrees: 70)]),
            // Feet slipping out of the pads.
            "feet": FaultPose(chains: [legs],
                              moves: [.shift(["foot_*", "foot_*.tip"], up: -0.12), .shift(["shin_*"], up: -0.05)]),
            // Hips too far forward over the pad.
            "thigh": FaultPose(chains: [spine, hips],
                               moves: [.shift(["pelvis", "thigh_*"], up: 0.12), .shift(["spine"], up: 0.08)])
        ],

        // MARK: Legs
        "Squat": [
            // The arms dropping, the chest falling after them.
            "arms": FaultPose(chains: [spine, armsToGrip],
                              moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -12),
                                      .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -40)],
                              strength: .withBend("shin_L"), view: -0.6),
            "torso": chestDropped(16).seen(-0.6),
            "knee": kneesIn().seen(0.5),
            "foot": heelsUp().seen(-0.8)
        ],
        "Lunge": [
            "posture": leanedForward(22),
            // The back hip sinking.
            "hips": FaultPose(chains: [["thigh_L", "pelvis", "thigh_R"], leg("R")],
                              moves: [.shift(["thigh_R"], rise: -0.16), .shift(["pelvis"], rise: -0.08), .resolve(["shin_R"])],
                              view: faceOn),
            "front": kneesIn("L").seen(faceOn),
            // Stopping halfway with the hips pushed forward.
            "rear": shallow(0.12, ahead: 0.12),
            "foot": heelsUp("L")
        ],
        "Lunge (Lean)": [
            "lean": headDropped(),
            // The lower back rounding.
            "core": FaultPose(chains: [spine], moves: [.shift(["spine"], forward: -0.14), .shift(["chest"], forward: -0.05)]),
            "front": kneesIn("L").seen(faceOn),
            "rear": rearLegPushing("R"),
            "foot": heelsUp("L")
        ],
        "Bulgarian Split Squat": [
            "torso": leanedForward(24).seen(sideOn),
            // The dumbbells drifting forward and pulling the chest down.
            "grip": FaultPose(chains: [spine, armsToGrip],
                              moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -8),
                                      .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: 28)],
                              view: sideOn),
            "knee": kneesIn("L"),
            // Drifting forward instead of down.
            "depth": shallow(0.1, ahead: 0.12, withArms: false).seen(sideOn),
            "front": heelsUp("L").seen(sideOn)
        ],
        "Bulgarian Split Squat (Lean)": [
            "lean": backRounded().seen(sideOn),
            // Dropping straight down, the lean only in the shoulders.
            "hips": FaultPose(chains: [spine],
                              moves: [.turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: 20),
                                      .turn(pivot: "chest", points: ["neck", "head"], axis: .lateral, degrees: -40)],
                              view: sideOn),
            "knee": kneesIn("R"),
            "rear": rearLegPushing("L").seen(-0.6),
            "front": heelsUp("R").seen(sideOn)
        ],
        "Back Squat": [
            // The bar slid down onto the rear delts, the lean deepening.
            "bar": FaultPose(chains: [spine, armsToGrip, bar],
                             moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -14),
                                     .shift(["hand_*", "hand_*.tip"], forward: -0.03, up: -0.1),
                                     .resolve(["forearm_*"])],
                             strength: .withBend("shin_L")),
            "brace": chestDropped(12, withBar: true),
            "knee": kneesIn().seen(0.7),
            "depth": shallow(0.35, withBar: true),
            // Up on the toes, the chest pulled forward.
            "drive": FaultPose(chains: [legs, spine, armsToGrip, bar],
                               moves: [.turn(pivot: "foot_*.tip", points: ["foot_*"], axis: .lateral, degrees: -24),
                                       .resolve(["shin_*"]),
                                       .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -10)],
                               strength: .withBend("shin_L"))
        ],
        "Front Squat": [
            // Gripping like a curl: the elbows sink under the bar.
            "rack": FaultPose(chains: [armsToGrip, bar], moves: [.shift(["forearm_*"], up: -0.25), .resolve(["forearm_*"])]),
            // The elbows dropping as the squat deepens, the bar rolling forward.
            "elbow": FaultPose(chains: [spine, armsToGrip, bar],
                               moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -10),
                                       .shift(["hand_*", "hand_*.tip"], forward: 0.05, up: -0.04),
                                       .shift(["forearm_*"], up: -0.22), .resolve(["forearm_*"])],
                               strength: .withBend("shin_L"), view: sideOn),
            "torso": leanedForward(25, withBar: true).seen(sideOn),
            // Shins kept vertical: the hips sit back and the chest tips over.
            "knee": FaultPose(chains: [spine, armsToGrip, legs, hips, bar],
                              moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -18),
                                      .shift(carried, ahead: -0.18), .resolve(["shin_*"])],
                              strength: .withBend("shin_L"), view: sideOn),
            "depth": shallow(0.3, withBar: true)
        ],
        "Goblet Squat": [
            // The dumbbell sagging down and away from the chest.
            "hold": FaultPose(chains: [spine, armsToGrip],
                              moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -8),
                                      .shift(["hand_*", "hand_*.tip"], forward: 0.1, up: -0.18), .resolve(["forearm_*"])],
                              strength: .withBend("shin_L"), view: sideOn),
            // Feet and knees too close for the elbows to fit between.
            "elbow": FaultPose(chains: [legs, hips],
                               moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.08), .shift(["shin_*"], outward: -0.15)],
                               strength: .withBend("shin_L")),
            "torso": chestDropped(15).seen(sideOn),
            "knee": kneesIn(),
            "depth": shallow(0.35)
        ],
        "Walking Lunge": [
            // A short, narrow step: the front knee shoots past the toes.
            "step": FaultPose(chains: [leg("front"), hips],
                              moves: [.shift(["foot_front", "foot_front.tip"], outward: -0.05, ahead: -0.25), .resolve(["shin_front"])],
                              strength: .withBend("shin_front"), view: sideOn),
            "knee": kneesIn("front"),
            "torso": leanedForward(20, strength: .withBend("shin_front")).seen(sideOn),
            // Launching off the back toes.
            "drive": FaultPose(chains: [spine, leg("front"), leg("back"), hips],
                               moves: [.shift(carried, ahead: 0.08), .straighten(["shin_back"]), .resolve(["shin_front"])],
                               strength: .withBend("shin_front"), view: sideOn),
            // The back knee dropped to bounce off the floor.
            "balance": FaultPose(chains: [spine, leg("front"), leg("back"), hips],
                                 moves: [.shift(carried, rise: -0.12), .resolve(["shin_front", "shin_back"])],
                                 strength: .withBend("shin_front"), view: sideOn)
        ],
        "Reverse Lunge": [
            "torso": leanedForward(22).seen(sideOn),
            // Sitting back onto the rear leg.
            "load": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(carried, ahead: -0.12), .resolve(["shin_*"])],
                              strength: .withBend("shin_L"), view: sideOn),
            // The hips drifting forward, the front knee past the toes.
            "knee": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(carried, ahead: 0.14), .resolve(["shin_*"])],
                              strength: .withBend("shin_L"), view: sideOn),
            // Standing up off the rear toes.
            "drive": FaultPose(chains: [leg("R"), hips],
                               moves: [.turn(pivot: "foot_R.tip", points: ["foot_R"], axis: .lateral, degrees: -20),
                                       .straighten(["shin_R"])],
                               strength: .withBend("shin_L"), view: sideOn),
            // Too short a step back.
            "step": FaultPose(chains: [leg("R"), hips],
                              moves: [.shift(["foot_R", "foot_R.tip"], ahead: 0.25), .resolve(["shin_R"])],
                              strength: .withBend("shin_L"), view: sideOn)
        ],
        "Hack Squat": [
            // Feet low on the platform: the knees crowd far forward.
            "feet": FaultPose(chains: [legs], moves: [.shift(["foot_*", "foot_*.tip"], ahead: -0.14), .resolve(["shin_*"])],
                              strength: .withBend("shin_L"), view: sledSide),
            // Hips and back peeling off the pad at the bottom.
            "pad": FaultPose(chains: [spine, legs, hips],
                             moves: [.shift(["pelvis", "thigh_*", "spine"], forward: 0.1), .shift(["chest"], forward: 0.05),
                                     .resolve(["shin_*"])],
                             strength: .withBend("shin_L"), view: sledSide),
            "knee": kneesIn(),
            // Bouncing: the sled sinks past a controlled bottom.
            "depth": FaultPose(chains: [spine, legs, hips],
                               moves: [.shift(carried, up: -0.12), .resolve(["shin_*"])],
                               strength: .withBend("shin_L"), view: sledSide),
            "lockout": kneesSnapped.seen(sledSide)
        ],
        "Leg Extension": [
            // Already dropping at the top: no pause.
            "squeeze": FaultPose(chains: [legs],
                                 moves: [.turn(pivot: "shin_*", points: ["foot_*", "foot_*.tip"], axis: .lateral, degrees: -30)],
                                 strength: .whenStraight("shin_L"), view: -0.6),
            // Hips lifting off the seat, the back leaning away.
            "hips": FaultPose(chains: [spine, legs, hips],
                              moves: [.turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: 12),
                                      .shift(["pelvis", "thigh_*"] + torso, rise: 0.08)],
                              view: -0.6)
        ],
        "Smith Machine Squat": [
            // Feet under the bar: the knees forced forward.
            "stance": FaultPose(chains: [legs, hips], moves: [.shift(["foot_*", "foot_*.tip"], ahead: -0.14), .resolve(["shin_*"])],
                                strength: .withBend("shin_L"), view: sideOn),
            // The hips shoved sideways off the bar's line.
            "path": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_L"], outward: 0.1), .shift(["thigh_R"], outward: -0.1),
                                      .shift(["spine"], outward: 0.06), .shift(["chest"], outward: 0.03), .resolve(["shin_*"])],
                              strength: .withBend("shin_L")),
            "knee": kneesIn(),
            "depth": shallow(0.3, withBar: true),
            "brace": backRounded(.withBend("shin_L")).seen(sideOn)
        ],
        "Sissy Squat": [
            // Feet slipping forward out of the anchor.
            "anchor": FaultPose(chains: [legs], moves: [.shift(["foot_*", "foot_*.tip"], ahead: 0.1), .resolve(["shin_*"])],
                                view: sideOn),
            // Folding at the hips like a squat.
            "line": FaultPose(chains: [spine, arms],
                              moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -35)],
                              strength: .withBend("shin_L"), view: sideOn),
            // Too upright: the hips stay over the knees.
            "lean": FaultPose(chains: [spine, arms, legs, hips],
                              moves: [.shift(carried, ahead: 0.15, rise: 0.08), .resolve(["shin_*"])],
                              strength: .withBend("shin_L"), view: sideOn),
            "core": lowerBackArched(0.09, .withBend("shin_L")).seen(sideOn),
            // The hips breaking the line to sink lower.
            "depth": FaultPose(chains: [spine, legs, hips],
                               moves: [.shift(["pelvis", "thigh_*"], ahead: -0.1, rise: -0.1), .shift(["spine"], ahead: -0.05, rise: -0.05),
                                       .resolve(["shin_*"])],
                               strength: .withBend("shin_L"), view: sideOn)
        ],
        "Romanian Deadlift": [
            "hinge": hingeSquatted(withBar: true).seen(sideOn),
            "knee": hingeKneesBending(withBar: true).seen(sideOn),
            "barpath": armsSwungForward(22, withBar: true, strength: .withBend("thigh_L")).seen(sideOn),
            "back": backRounded(.withBend("thigh_L")).seen(sideOn),
            // Chasing the floor: rounding and sinking once the stretch runs out.
            "stretch": FaultPose(chains: [spine, armsToGrip, legs, hips, bar],
                                 moves: [.shift(carried, rise: -0.1), .resolve(["shin_*"]),
                                         .shift(["spine"], forward: -0.07), .shift(["chest"], forward: -0.05),
                                         .shift(["neck"], forward: 0.05), .shift(["head"], forward: 0.12)],
                                 strength: .withBend("thigh_L"), view: sideOn)
        ],
        "Leg Press": [
            // Feet too narrow on the platform.
            "feet": FaultPose(chains: [legs, hips],
                              moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.1), .shift(["shin_*"], outward: -0.08)]),
            "knee": kneesIn(),
            // Sinking so deep the hips roll off the seat.
            "range": FaultPose(chains: [spine, legs, hips],
                               moves: [.shift(["pelvis", "thigh_*"], forward: 0.1), .shift(["spine"], forward: 0.05), .resolve(["shin_*"])],
                               strength: .withBend("shin_L"), view: sledSide),
            "lockout": kneesSnapped.seen(sledSide),
            "back": lowerBackArched(0.14).seen(sledSide)
        ],
        "Step-Up": [
            "torso": leanedForward(25),
            // Springing off the back foot.
            "drive": FaultPose(chains: [leg("R"), hips],
                               moves: [.turn(pivot: "foot_R.tip", points: ["foot_R"], axis: .lateral, degrees: -25),
                                       .straighten(["shin_R"])],
                               strength: .withBend("shin_L"), view: -0.3),
            "knee": kneesIn("L").seen(0.8),
            // The free leg's hip sagging while it swings.
            "hips": FaultPose(chains: [["thigh_L", "pelvis", "thigh_R"], leg("R")],
                              moves: [.shift(["thigh_R", "shin_R", "foot_R", "foot_R.tip"], rise: -0.1), .shift(["pelvis"], rise: -0.05)],
                              strength: .withBend("shin_R"), view: 0.8),
            "grip": armsSwungForward(25)
        ],
        "Dumbbell Romanian Deadlift": [
            "spine": backRounded(.withBend("thigh_L")).seen(-0.4),
            "hips": hingeSquatted(withBar: false).seen(-0.4),
            "path": armsSwungForward(22, strength: .withBend("thigh_L")).seen(-0.4),
            "knee": FaultPose(chains: [legs], moves: [.straighten(["shin_*"])], view: -0.4),
            // Rocking onto the toes, the dumbbells drifting out.
            "feet": FaultPose(chains: [legs, armsToGrip],
                              moves: [.turn(pivot: "foot_*.tip", points: ["foot_*"], axis: .lateral, degrees: -22),
                                      .resolve(["shin_*"]),
                                      .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: 12)],
                              strength: .withBend("thigh_L"), view: -0.4)
        ],
        "Stiff-Leg Deadlift": [
            "spine": headDropped(.withBend("thigh_L")).seen(-0.4),
            // A toe-touch: the hips stay over the feet and the waist folds.
            "hips": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_*"], ahead: 0.12), .shift(["spine"], ahead: 0.06, rise: 0.02),
                                      .resolve(["shin_*"]),
                                      .shift(["chest"], forward: -0.05), .shift(["neck"], forward: 0.05), .shift(["head"], forward: 0.12)],
                              strength: .withBend("thigh_L"), view: -0.4),
            "bar": armsSwungForward(22, withBar: true, strength: .withBend("thigh_L")).seen(-0.4),
            "knee": FaultPose(chains: [legs], moves: [.straighten(["shin_*"], past: 0.05)], view: -0.6),
            // Rocking back onto the heels: the toes lift, the hips drift back.
            "feet": FaultPose(chains: [legs, hips],
                              moves: [.shift(["pelvis", "thigh_*", "shin_*"], ahead: -0.05),
                                      .turn(pivot: "foot_*", points: ["foot_*.tip"], axis: .lateral, degrees: 22)],
                              strength: .withBend("thigh_L"), view: -0.4)
        ],
        "Lying Leg Curl": [
            "hips": proneHipsUp,
            "curl": curlShort("*", 35),
            "knee": proneSlidUp,
            // Heaving on the handles: the chest lifts off the bench.
            "grip": FaultPose(chains: [spine, arms],
                              moves: [.shift(["chest", "neck", "head", "upper_arm_*"], rise: 0.1), .shift(["spine"], rise: 0.04),
                                      .resolve(["forearm_*"])],
                              strength: .withBend("shin_L"))
        ],
        "Seated Leg Curl": [
            // Slumping forward off the back pad.
            "back": FaultPose(chains: [spine, arms],
                              moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .lateral, degrees: -15),
                                      .shift(["spine"], forward: -0.05), .resolve(["forearm_*"])],
                              view: -0.67),
            // The thighs lifting under a loose pad.
            "thigh": FaultPose(chains: [legs, hips], moves: [.shift(["shin_*", "foot_*", "foot_*.tip"], rise: 0.1)],
                               strength: .withBend("shin_L"), view: -0.67),
            // Sitting too far forward: the knees off the pivot.
            "knee": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip", "spine"], ahead: 0.1)],
                              view: -0.67),
            // Never straightening: the knees stay bent at the start.
            "curl": FaultPose(chains: [legs],
                              moves: [.turn(pivot: "shin_*", points: ["foot_*", "foot_*.tip"], axis: .lateral, degrees: -40)],
                              strength: .whenStraight("shin_L"), view: -0.67),
            "grip": seatedRocked(-14).seen(-0.67)
        ],
        "Single-Leg Curl": [
            // The working hip rolling up off the pad.
            "hips": FaultPose(chains: [["thigh_R", "pelvis", "thigh_L"], leg("L")],
                              moves: [.shift(["thigh_L"], rise: 0.1), .shift(["pelvis"], rise: 0.04)],
                              strength: .withBend("shin_L")),
            "curl": curlShort("L", 35),
            "knee": proneSlidUp
        ],
        "Glute Bridge": [
            // Stopping short: the hips sag below the line.
            "hips": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_*"], rise: -0.14), .shift(["spine"], rise: -0.07), .resolve(["shin_*"])],
                              strength: .whenStraight("thigh_L")),
            "ribs": bridgeArched,
            // Feet walked too far from the hips.
            "feet": FaultPose(chains: [legs, hips], moves: [.shift(["foot_*", "foot_*.tip"], ahead: -0.2), .resolve(["shin_*"])]),
            "knee": kneesIn("*", 0.1).seen(-0.9)
        ],
        "Single-Leg Glute Bridge": [
            // The lifted side's hip sagging.
            "hips": FaultPose(chains: [["thigh_L", "pelvis", "thigh_R"], leg("R")],
                              moves: [.shift(["thigh_R", "shin_R", "foot_R", "foot_R.tip"], rise: -0.1), .shift(["pelvis"], rise: -0.05)],
                              strength: .whenStraight("thigh_L")),
            "drive": heelsUp("L"),
            "knee": kneesIn("L", 0.1).seen(-0.9),
            // Kicking the free leg up to swing the hips.
            "free": FaultPose(chains: [leg("R"), hips],
                              moves: [.turn(pivot: "thigh_R", points: ["shin_R", "foot_R", "foot_R.tip"], axis: .lateral, degrees: 30)]),
            "ribs": bridgeArched
        ],
        "Cable Glute Kickback": [
            // Stood up tall, the back arching.
            "torso": FaultPose(chains: [spine],
                               moves: [.turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: 30), .shift(["spine"], forward: 0.05)]),
            // The hip opening out as the leg goes back.
            "hips": FaultPose(chains: [leg("L"), hips],
                              moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .forward, degrees: 22)],
                              view: -0.9),
            // Swung too high, the lower back arching.
            "kick": FaultPose(chains: [leg("L"), spine],
                              moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .lateral, degrees: -25),
                                      .shift(["spine"], forward: 0.07)],
                              strength: .whenStraight("shin_L")),
            // Twisting the trunk open against the frame.
            "grip": FaultPose(chains: [spine, shoulders],
                              moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .up, degrees: -18)],
                              view: -0.9)
        ],
        "Cable Side Kick": [
            "torso": leanedAway(16, strength: .between("foot_L", "foot_R", from: 0.43, to: 1.26)),
            // Hips and toes turned up: the leg swings forward, not out.
            "hips": FaultPose(chains: [leg("L"), hips],
                              moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .lateral, degrees: 22),
                                      .turn(pivot: "foot_L", points: ["foot_L.tip"], axis: .lateral, degrees: 40)],
                              strength: .between("foot_L", "foot_R", from: 0.43, to: 1.26), view: -0.7),
            // Short kicks that stop low.
            "kick": FaultPose(chains: [leg("L"), hips],
                              moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .forward, degrees: -18)],
                              strength: .between("foot_L", "foot_R", from: 0.43, to: 1.26)),
            "foot": toesUp(50, .between("foot_L", "foot_R", from: 0.43, to: 1.26)).seen(-0.5),
            "grip": pulledOnSupport(strength: .between("foot_L", "foot_R", from: 0.43, to: 1.26))
        ],
        "Cable Hip Abduction": [
            "torso": leanedAway(16, strength: .between("foot_L", "foot_R", from: 0.49, to: 1.14)),
            // The working hip hitched up toward the ribs.
            "hips": FaultPose(chains: [["thigh_R", "pelvis", "thigh_L"], leg("L")],
                              moves: [.shift(["thigh_L", "shin_L", "foot_L", "foot_L.tip"], rise: 0.08), .shift(["pelvis"], rise: 0.04)],
                              strength: .between("foot_L", "foot_R", from: 0.49, to: 1.14)),
            // Swung as high as it goes, the trunk tipping to allow it.
            "lift": FaultPose(chains: [leg("L"), hips, spine],
                              moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .forward, degrees: 22),
                                      .turn(pivot: "pelvis", points: torso, axis: .forward, degrees: 8)],
                              strength: .between("foot_L", "foot_R", from: 0.49, to: 1.14)),
            "foot": toesUp(75, .between("foot_L", "foot_R", from: 0.49, to: 1.14)).seen(-0.5),
            "grip": pulledOnSupport(strength: .between("foot_L", "foot_R", from: 0.49, to: 1.14))
        ],
        "Hip Abduction Machine": [
            // Slumping forward to shove the pads apart.
            "back": FaultPose(chains: [spine],
                              moves: [.turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: -15),
                                      .shift(["spine"], forward: -0.07)],
                              view: -1.2),
            // Hips lifting off the seat.
            "hips": FaultPose(chains: [spine, legs, hips], moves: [.shift(["pelvis", "thigh_*"] + torso, rise: 0.1)], view: -1.2),
            "feet": seatedFeetPushing.seen(-1.2),
            "grip": seatedRocked(-14).seen(-1.2)
        ],
        "Hip Abduction Machine (Lean)": [
            "lean": backRounded().seen(-1.2),
            // Short reps: the knees stop well inside the full range.
            "push": FaultPose(chains: [legs, hips], moves: [.shift(["shin_*"], outward: -0.15)],
                              strength: .between("shin_L", "shin_R", from: 0.44, to: 1.17)),
            // Sliding forward on the seat to lean further.
            "hips": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_*"] + torso, ahead: 0.1), .resolve(["shin_*"])],
                              view: -1.2),
            "feet": seatedFeetPushing.seen(-1.2),
            "grip": seatedRocked(14).seen(-1.2)
        ],
        // MARK: Shoulders
        "Barbell Overhead Press": [
            "grip": wristBentBack(withBar: true),
            // Pressed out around the face: locked out in front of the head.
            "barpath": armsTurned(.lateral, -18, withBar: true, strength: .whenStraight("forearm_L")).seen(-0.6),
            // The head left back, the bar parked in front of it.
            "head": FaultPose(chains: [["chest", "neck", "head"], armsToGrip, bar],
                              moves: [.shift(["head"], forward: -0.1),
                                      .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -12)],
                              strength: .whenStraight("forearm_L"), view: -0.6),
            "brace": leanedBack(14, arch: 0.08, withBar: true).seen(-0.6),
            // Dipping the knees to drive the bar.
            "feet": FaultPose(chains: [spine, legs, hips, armsToGrip, bar],
                              moves: [.shift(carried, rise: -0.12), .resolve(["shin_*"])], view: -0.6)
        ],
        "Dumbbell Shoulder Press": [
            // Elbows flared out and pulled behind the body at the bottom.
            "elbow": FaultPose(chains: [armsToGrip], moves: [.shift(["forearm_*"], forward: -0.12, outward: 0.05), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L"), view: -1.0),
            // Drifting wide at the top.
            "path": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.14), .resolve(["forearm_*"])],
                              strength: .whenStraight("forearm_L")),
            // The elbows dropped far below the shoulders.
            "depth": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], up: -0.18), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            // Slid down the pad, the lower back arched.
            "back": FaultPose(chains: [spine, hips],
                              moves: [.shift(["pelvis", "thigh_*"], forward: 0.06), .shift(["spine"], forward: 0.12), .shift(["chest"], forward: 0.05)],
                              view: -1.0),
            "feet": feetTucked.seen(-1.0)
        ],
        "Arnold Press": [
            // Elbows already out to the sides at the start: a plain shoulder press.
            "start": armsTurned(.up, -55, strength: .withBend("forearm_L")),
            // Arms still bent at the top, the dumbbells in front of the face.
            "finish": FaultPose(chains: [armsToGrip],
                                moves: [.shift(["hand_*", "hand_*.tip"], forward: 0.1, up: -0.12), .resolve(["forearm_*"])],
                                strength: .whenStraight("forearm_L"), view: -1.0),
            "back": lowerBackArched(0.12).seen(-1.0),
            "feet": feetTucked.seen(-1.0)
        ],
        "Machine Shoulder Press": [
            // Sitting too low: the handles start high over the head.
            "seat": FaultPose(chains: [spine, arms, hips],
                              moves: [.shift(["pelvis", "thigh_*"] + torso + ["upper_arm_*"], rise: -0.14), .resolve(["forearm_*"])],
                              view: -1.0),
            "elbow": FaultPose(chains: [armsToGrip], moves: [.shift(["forearm_*"], forward: -0.08, outward: 0.1), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            // Short reps: the handles never come back down.
            "lockout": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], up: 0.16), .resolve(["forearm_*"])],
                                 strength: .withBend("forearm_L")),
            "back": lowerBackArched(0.12).seen(-1.0),
            "feet": heelsUp().seen(-1.0)
        ],
        "Dumbbell Lateral Raise": [
            "traps": shrugged,
            // Arms swept back behind the body at the top.
            "plane": armsTurned(.up, -25).seen(-1.2),
            // Elbows bending into an upright row.
            "elbow": elbowsFolded(.forward, -60),
            "height": armsTurned(.forward, 28),
            "torso": leanedBack(12).seen(-1.2)
        ],
        "Cable Lateral Raise": [
            // Only the left arm raises in this model.
            "traps": FaultPose(chains: [shoulders, arm("L")], moves: [.shift(["upper_arm_L", "forearm_L", "hand_L", "hand_L.tip"], up: 0.12)]),
            "elbow": elbowsFolded(.forward, -60, side: "L"),
            "height": armsTurned(.forward, 30, side: "L"),
            // Leaning away from the stack to swing the arm up.
            "torso": FaultPose(chains: [spine, shoulders, arm("L")],
                               moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"] + arm("L").dropFirst(), axis: .forward, degrees: -14)]),
            // The cable dragging the arm forward across the body.
            "setup": armsTurned(.up, 28, side: "L").seen(-1.2)
        ],
        "Machine Lateral Raise": [
            "traps": shrugged,
            // Sat too low: the shoulders shrug up to reach the pads.
            "pivot": FaultPose(chains: [spine, shoulders, arms],
                               moves: [.shift(["pelvis", "thigh_*", "spine", "chest", "neck", "head"], rise: -0.1),
                                       .shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.05)]),
            "height": armsTurned(.forward, 22),
            "back": leanedBack(12).seen(-1.2)
        ],
        "Dumbbell Front Raise": [
            "height": armsTurned(.lateral, 40).seen(-1.0),
            // Shoulders hunched up and forward.
            "shoulder": FaultPose(chains: [shoulders, armsToGrip],
                                  moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], forward: 0.08, up: 0.1)],
                                  view: -1.0),
            "elbow": elbowsFolded(.lateral, 50).seen(-1.0),
            "torso": leanedBack(12).seen(-1.0),
            // Feet together and knees locked, the body tipping back.
            "stance": FaultPose(chains: [legs, spine],
                                moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.1), .straighten(["shin_*"]),
                                        .turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: 8)])
        ],
        "Reverse Dumbbell Fly": [
            // Craning the head up.
            "neck": FaultPose(chains: [["chest", "neck", "head"]], moves: [.turn(pivot: "neck", points: ["head"], axis: .lateral, degrees: 40)]),
            // Elbows bending into a row.
            "elbow": elbowsFolded(.up, 70),
            // Swept back toward the hips.
            "path": armsTurned(.forward, -30),
            // Standing too upright.
            "hinge": FaultPose(chains: [spine, shoulders],
                               moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .lateral, degrees: 24)]),
            // Knees locked and up on the toes.
            "feet": FaultPose(chains: [legs],
                              moves: [.turn(pivot: "foot_*.tip", points: ["foot_*"], axis: .lateral, degrees: -20), .straighten(["shin_*"])])
        ],
        "Reverse Pec Deck": [
            "traps": shruggedBack,
            // Seat too high: the arms pull down to the handles.
            "seat": FaultPose(chains: [spine, shoulders, arms],
                              moves: [.shift(["pelvis", "thigh_*"] + torso + ["upper_arm_*", "forearm_*"], rise: 0.12)]),
            "elbow": elbowsFolded(.up, 60).seen(0.6),
            // Elbows driven down and back.
            "path": FaultPose(chains: [armsToGrip],
                              moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .forward, degrees: -25),
                                      .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .up, degrees: -12)]),
            "chest": leanedBack(15).seen(1.15)
        ],
        "Face Pull": [
            // Rowed down to the chest.
            "target": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], up: -0.26), .resolve(["forearm_*"])],
                                strength: .withBend("forearm_L"), view: 1.1),
            // No turn out at the finish: the forearms point forward.
            "rotate": elbowsFolded(.lateral, -70, strength: .withBend("forearm_L")).seen(1.1),
            // Elbows dropped and tucked.
            "elbow": FaultPose(chains: [armsToGrip], moves: [.shift(["forearm_*"], up: -0.16, outward: -0.08), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            "scapula": shouldersForward.seen(1.1),
            "stance": leanedBack(15).seen(1.1)
        ],
        "Cable Rear Delt Fly": [
            "traps": shruggedBack,
            // Pulleys too low: the arms finish angled down.
            "height": armsTurned(.forward, -22),
            "elbow": elbowsFolded(.up, 60).seen(0.6),
            // Hands dipping toward the hips.
            "path": FaultPose(chains: [armsToGrip],
                              moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .forward, degrees: -32),
                                      .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .up, degrees: -15)]),
            "stance": leanedBack(15).seen(1.2)
        ],
        // MARK: Arms
        "Barbell Curl": [
            // Shoulders rounded, the bar drifting out in front.
            "shoulder": FaultPose(chains: [shoulders, armsToGrip, bar],
                                  moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], forward: 0.1),
                                          .shift(["hand_*", "hand_*.tip"], forward: 0.08), .resolve(["forearm_*"])],
                                  view: -0.5),
            "elbow": elbowsForward(35, withBar: true).seen(-0.5),
            "grip": gripTooWide(withBar: true),
            "torso": bodySwung(withBar: true).seen(-0.5),
            // Half reps: the elbows never straighten at the bottom.
            "range": elbowsFolded(.lateral, 45, strength: .between("upper_arm_L", "hand_L", from: 0.62, to: 0.8)).seen(-0.5)
        ],
        "Biceps Curl": [
            // Shoulders shrugged up and rolled forward at the top.
            "shoulder": FaultPose(chains: [shoulders, armsToGrip],
                                  moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], forward: 0.06, up: 0.1)],
                                  view: -0.6),
            "elbow": elbowsForward(35).seen(-0.9),
            // Wrists curling in toward the forearms.
            "wrist": FaultPose(chains: [["forearm_*", "hand_*", "hand_*.tip"]],
                               moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .lateral, degrees: 50)],
                               view: -0.9),
            "core": bodySwung(withBar: false).seen(-0.9)
        ],
        "Triceps Pushdown": [
            "shoulder": hunched().seen(-0.8),
            // Elbows lifting forward as the bar comes up.
            "elbow": elbowsForward(30, withBar: true).seen(-0.9),
            "lockout": pushdownShort(from: 0.62, to: 0.82).seen(-0.9),
            "torso": leanedForward(18, strength: .always).seen(-0.9),
            "feet": crowdingTheStack.seen(-0.9)
        ],
        "Rope Pushdown": [
            "shoulder": hunched().seen(-0.8),
            "elbow": elbowsForward(30).seen(-0.9),
            // Hands kept together: the rope stops on the thighs short of lockout.
            "split": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: 0.08, outward: -0.12), .resolve(["forearm_*"])],
                               strength: .between("hand_L", "hand_R", from: 0.65, to: 0.82)),
            "torso": leanedForward(18, strength: .always).seen(-0.9),
            "feet": crowdingTheStack.seen(-0.9)
        ],
        "Single-Arm Cable Pushdown": [
            // Only the left arm pushes in this model.
            "shoulder": hunched("L").seen(-0.8),
            "elbow": elbowsForward(30, side: "L").seen(-0.9),
            "lockout": pushdownShort("L", from: 0.64, to: 0.845).seen(-0.9),
            // Twisting toward the working side.
            "hips": FaultPose(chains: [spine, shoulders, arm("L")],
                              moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"] + arm("L").dropFirst(), axis: .up, degrees: -18)]),
            "feet": crowdingTheStack.seen(-0.9)
        ],
        "Overhead Cable Triceps Extension": [
            // Short range: the hands never drop behind the head.
            "stretch": elbowsFolded(.lateral, -45, strength: .withBend("forearm_L")).seen(-0.9),
            "elbow": overheadElbowsOut,
            // Upper arms falling forward.
            "upperarm": armsTurned(.lateral, -25).seen(-0.9),
            "brace": lowerBackArched(0.12).seen(-0.9),
            "stance": squareLockedStance
        ],
        "Dumbbell Overhead Triceps Extension": [
            // A loose grip: the dumbbell tips in the hands.
            "grip": FaultPose(chains: [["forearm_*", "hand_*", "hand_*.tip"]],
                              moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .lateral, degrees: 45)],
                              view: -0.9),
            "elbow": overheadElbowsOut,
            "upperarm": armsTurned(.lateral, -25).seen(-0.9),
            "brace": lowerBackArched(0.12).seen(-0.9),
            "stance": squareLockedStance
        ],
        "Skull Crusher": [
            "elbow": FaultPose(chains: [armsToGrip, bar], moves: [.shift(["forearm_*"], outward: 0.12), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L"), view: 0.9),
            // Dropped toward the face.
            "bar": FaultPose(chains: [armsToGrip, bar],
                             moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.06, up: -0.1), .resolve(["forearm_*"])],
                             strength: .withBend("forearm_L")),
            // Upper arms straight up at lockout: the triceps rest.
            "upperarm": armsTurned(.lateral, -20, withBar: true, strength: .whenStraight("forearm_L")),
            // Hips lifting, the back arching off the bench.
            "back": FaultPose(chains: [spine, hips],
                              moves: [.shift(["pelvis", "thigh_*"], forward: 0.06), .shift(["spine"], forward: 0.1), .shift(["chest"], forward: 0.04)]),
            "feet": heelsUp()
        ],
        "Bench Dip": [
            "elbow": FaultPose(chains: [armsToGrip], moves: [.shift(["forearm_*"], outward: 0.12), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L"), view: 0.6),
            "depth": dipSunk(-0.14, strength: .withBend("forearm_L")),
            // The hips drifting away from the bench.
            "hips": FaultPose(chains: [spine, arms, legs, hips],
                              moves: [.shift(["pelvis", "thigh_*", "upper_arm_*"] + torso, ahead: 0.12), .resolve(["forearm_*", "shin_*"])],
                              view: -0.5),
            "hands": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.12), .resolve(["forearm_*"])],
                               view: 0.6)
        ],
        "Assisted Dip": [
            // Pitching forward over the handles.
            "torso": FaultPose(chains: [spine, arms],
                               moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .lateral, degrees: -20),
                                       .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            "depth": dipSunk(-0.14, legsRide: true, strength: .withBend("forearm_L")),
            "elbow": FaultPose(chains: [armsToGrip], moves: [.shift(["forearm_*"], outward: 0.12), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            // Stopping short of lockout.
            "lockout": dipSunk(-0.12, legsRide: true, strength: .whenStraight("forearm_L")),
            // Kneeling off-centre on the pad.
            "knees": FaultPose(chains: [legs, hips],
                               moves: [.shift(["shin_L", "foot_L", "foot_L.tip"], outward: 0.1),
                                       .shift(["shin_R", "foot_R", "foot_R.tip"], outward: -0.1)])
        ],
        // MARK: Core
        "Plank": [
            "body": hipsSagging,
            // Elbows placed far out in front of the shoulders.
            "elbow": armsTurned(.lateral, 30),
            "ribs": lowerBackArched(0.1),
            // The head dropping toward the floor.
            "head": FaultPose(chains: [["chest", "neck", "head"]], moves: [.turn(pivot: "neck", points: ["head"], axis: .lateral, degrees: -45)]),
            // Legs gone soft: the knees and hips sinking.
            "feet": FaultPose(chains: [legs, hips, ["pelvis", "spine"]],
                              moves: [.shift(["pelvis", "thigh_*"], forward: 0.07), .shift(["shin_*"], forward: 0.11)])
        ],
        "Crunch": [
            "curl": satUp(45),
            "neck": headYanked,
            "low": lowerBackArched(0.12),
            // Arms flung forward to swing up.
            "range": FaultPose(chains: [spine, armsToGrip],
                               moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -20),
                                       .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -100)])
        ],
        "Reverse Crunch": [
            // Knees to the chest while the hips stay down.
            "pelvis": FaultPose(chains: [spine, legs, hips],
                                moves: [.shift(["pelvis", "thigh_*"], rise: -0.16), .shift(["spine"], rise: -0.08)],
                                strength: .withBend("thigh_L")),
            // Legs kicking straight to throw the hips up.
            "knees": FaultPose(chains: [legs], moves: [.straighten(["shin_*"])], strength: .withBend("thigh_L")),
            // Head and shoulders lifting to help.
            "upper": FaultPose(chains: [spine, armsToGrip],
                               moves: [.turn(pivot: "spine", points: ["chest", "neck", "head", "upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"],
                                             axis: .lateral, degrees: -25)],
                               strength: .withBend("thigh_L"))
        ],
        "Decline Crunch": [
            "curl": satUp(40),
            "neck": headYanked,
            // The whole back lifting in one flat piece.
            "low": FaultPose(chains: [spine, armsToGrip],
                             moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -20),
                                     .shift(["spine"], forward: 0.07), .shift(["chest"], forward: 0.04)])
        ],
        "Cable Crunch": [
            // Hauling the rope down with the arms.
            "rope": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], rise: -0.16), .resolve(["forearm_*"])]),
            // Bowing from the hips with a flat back.
            "curl": FaultPose(chains: [spine, armsToGrip],
                              moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -10),
                                      .shift(["spine"], forward: 0.09), .shift(["chest"], forward: 0.05)]),
            // Sitting back toward the heels.
            "hips": FaultPose(chains: [spine, legs, hips], moves: [.shift(carried, ahead: -0.12, rise: -0.09)]),
            // Kneeling too far back: pulled forward off balance.
            "knees": FaultPose(chains: [spine, legs, hips, armsToGrip], moves: [.shift(carried, ahead: 0.12)]),
            // Up on the toes, the knees lifting.
            "feet": FaultPose(chains: [legs], moves: [.shift(["shin_*"], rise: 0.08)])
        ],
        "Hanging Knee Raise": [
            "grip": hangingLoose,
            "tilt": legsRaisedArched,
            // Stopping with the thighs below level.
            "knees": FaultPose(chains: [legs, hips],
                               moves: [.turn(pivot: "thigh_*", points: ["shin_*", "foot_*", "foot_*.tip"], axis: .lateral, degrees: -28)],
                               strength: .withBend("thigh_L")),
            "swing": legsSwungBack,
            // Leaning back and pulling with the arms.
            "torso": FaultPose(chains: [spine, arms, legs],
                               moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip"] + torso + ["upper_arm_*"], rise: 0.1),
                                       .turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: 10),
                                       .resolve(["forearm_*"])])
        ],
        "Hanging Leg Raise": [
            "grip": hangingLoose,
            "tilt": legsRaisedArched,
            // Knees bending halfway up.
            "legs": FaultPose(chains: [legs],
                              moves: [.turn(pivot: "shin_*", points: ["foot_*", "foot_*.tip"], axis: .lateral, degrees: -70)],
                              strength: .withBend("thigh_L")),
            "swing": legsSwungBack,
            // Leaning back to counterbalance the legs.
            "torso": FaultPose(chains: [spine, arms],
                               moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .lateral, degrees: 15),
                                       .resolve(["forearm_*"])])
        ],
        "Captain's Chair Leg Raise": [
            // Leaning off the back pad to swing the legs.
            "back": FaultPose(chains: [spine, hips],
                              moves: [.shift(["pelvis", "thigh_*"], ahead: 0.05),
                                      .turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: -15)]),
            // Shoulders shrugged: the neck sinking between them.
            "arms": FaultPose(chains: [shoulders, ["chest", "neck", "head"]],
                              moves: [.shift(["neck", "head"], rise: -0.08), .shift(["chest"], rise: -0.03)]),
            "tilt": legsRaisedArched,
            "legs": FaultPose(chains: [legs],
                              moves: [.turn(pivot: "shin_*", points: ["foot_*", "foot_*.tip"], axis: .lateral, degrees: -60)],
                              strength: .withBend("thigh_L"))
        ],
        "Ab Wheel Rollout": [
            "hips": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_*"], forward: 0.14), .shift(["spine"], forward: 0.08)],
                              strength: .between("hand_L", "shin_L", from: 1.9, to: 2.3)),
            // Rolled out too far and collapsing.
            "reach": FaultPose(chains: [spine, arms, legs, hips],
                               moves: [.shift(["forearm_*", "hand_*"], up: 0.2),
                                       .shift(["upper_arm_*", "chest", "neck", "head"], forward: 0.06, up: 0.12),
                                       .shift(["pelvis", "thigh_*", "spine"], forward: 0.1)],
                               strength: .between("hand_L", "shin_L", from: 1.9, to: 2.3)),
            // Looking up, the ribs flaring and the back arching.
            "ribs": FaultPose(chains: [spine],
                              moves: [.shift(["spine"], forward: 0.08), .turn(pivot: "neck", points: ["head"], axis: .lateral, degrees: 45)]),
            // Hips stuck back to drag the wheel in.
            "return": FaultPose(chains: [spine, legs, hips],
                                moves: [.shift(["pelvis", "thigh_*"], ahead: -0.08, rise: 0.15), .shift(["spine"], rise: 0.08)])
        ],
        "Side Plank": [
            // The support elbow set out in front of the shoulder.
            "elbow": armsTurned(.forward, 25, side: "L"),
            // The bottom hip sagging to the floor.
            "hips": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_L"], outward: 0.12), .shift(["thigh_R"], outward: -0.12),
                                      .shift(["spine"], outward: 0.06)]),
            // Hips piked back behind the line.
            "line": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_*"], forward: -0.13), .shift(["spine"], forward: -0.06)],
                              view: 0.8),
            // Rolled onto the edge of the bottom foot.
            "feet": FaultPose(chains: [leg("L")], moves: [.turn(pivot: "foot_L", points: ["foot_L.tip"], axis: .up, degrees: -50)]),
            // The head drooping toward the floor.
            "head": FaultPose(chains: [["chest", "neck", "head"]], moves: [.turn(pivot: "neck", points: ["head"], axis: .forward, degrees: -30)])
        ],
        "Russian Twist": [
            // The arms swinging past a chest that stays square.
            "rotate": FaultPose(chains: [armsToGrip],
                                moves: [.turn(pivot: "upper_arm_L", points: arm("L").dropFirst().map { $0 }, axis: .up, degrees: -30),
                                        .turn(pivot: "upper_arm_R", points: arm("R").dropFirst().map { $0 }, axis: .up, degrees: 30)],
                                strength: twistedLeft),
            // Reaching down and out to tap the floor.
            "ball": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], rise: -0.14), .resolve(["forearm_*"])]),
            "lean": backRounded().seen(-1.0),
            // The knees rocking the other way.
            "hips": FaultPose(chains: [legs, hips],
                              moves: [.shift(["shin_L"], outward: -0.12), .shift(["shin_R"], outward: 0.12),
                                      .shift(["foot_L", "foot_L.tip"], outward: -0.05), .shift(["foot_R", "foot_R.tip"], outward: 0.05)],
                              strength: twistedLeft),
            // Feet lifted before the twist is under control.
            "feet": FaultPose(chains: [legs], moves: [.shift(["foot_*", "foot_*.tip"], rise: 0.15), .shift(["shin_*"], rise: 0.06)])
        ],
        "Cable Wood Chop": [
            // Pulling with bent arms.
            "arms": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.12, up: 0.06), .resolve(["forearm_*"])]),
            // Bending sideways instead of turning.
            "rotate": FaultPose(chains: [spine, armsToGrip],
                                moves: [.turn(pivot: "pelvis", points: trunk, axis: .forward, degrees: 18)]),
            // Both feet flat: the back knee twists in.
            "pivot": kneesIn("L"),
            // Whipping loose past the finish.
            "brace": FaultPose(chains: [spine, shoulders, armsToGrip],
                               moves: [.turn(pivot: "pelvis", points: trunk, axis: .up, degrees: 22)])
        ]
    ]




}

/// The joints that fix the lifter's own axes: pelvis to neck is "up", right
/// hip to left hip is "left".
enum BodyFrameJoints {
    static let all = ["pelvis", "neck", "thigh_L", "thigh_R"]
}
