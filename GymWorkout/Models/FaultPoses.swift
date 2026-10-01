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
/// and the other, decided afresh every frame. For lifts that shift from side
/// to side, `_bent` and `_straight` stand for the side whose knee is bent
/// further and the other, decided the same way.
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
        if bends { names.formUnion(["thigh_L", "thigh_R", "shin_L", "shin_R", "foot_L", "foot_R"]) }
        // Both sides of a leading, trailing, bent or straight leg, since
        // either side may be it.
        return Set(names.flatMap { name -> [String] in
            let bone = FaultPose.bone(name)
            guard FaultPose.roleSuffixes.contains(where: bone.hasSuffix) else { return [bone] }
            let stem = bone[..<bone.lastIndex(of: "_")!]
            return ["\(stem)_L", "\(stem)_R"]
        })
    }

    // MARK: - Leading leg

    /// Suffixes that name a leg by its role rather than its side.
    static let roleSuffixes = ["_front", "_back", "_bent", "_straight"]

    /// Whether the fault names the leading or trailing leg.
    var alternates: Bool {
        roles("_front", "_back", "L").1
    }

    /// Whether the fault names the bent or straight leg.
    var bends: Bool {
        roles("_bent", "_straight", "L").1
    }

    /// The fault with `_front` and `_back` made `side` and the other side.
    func leading(_ side: String) -> FaultPose {
        roles("_front", "_back", side).0
    }

    /// The fault with `_bent` and `_straight` made `side` and the other side.
    func bending(_ side: String) -> FaultPose {
        roles("_bent", "_straight", side).0
    }

    /// `first` renamed to `side` and `second` to the other side, and whether
    /// any joint was named that way.
    private func roles(_ first: String, _ second: String, _ side: String) -> (FaultPose, Bool) {
        let other = side == "L" ? "R" : "L"
        return rename {
            $0.replacingOccurrences(of: first, with: "_" + side)
              .replacingOccurrences(of: second, with: "_" + other)
        }
    }

    /// Every joint name passed through `change`, and whether any changed.
    private func rename(_ change: (String) -> String) -> (FaultPose, Bool) {
        var changed = false
        func name(_ n: String) -> String {
            let new = change(n)
            if new != n { changed = true }
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

    /// Decline bench, bounced: the bar sinks into the chest at the bottom.
    private static let barBounced = FaultPose(
        chains: [armsToGrip, bar],
        moves: [
            .shift(["hand_*", "hand_*.tip"], forward: -0.1),
            .shift(["forearm_*"], forward: -0.06)
        ],
        strength: .withBend("forearm_L")
    )

    /// Decline bench: feet slipping out of the pads, the hips sliding up it.
    private static let declineFeetSlipping = FaultPose(
        chains: [legs, hips],
        moves: [
            .shift(["foot_*", "foot_*.tip"], forward: 0.1, up: 0.14),
            .shift(["shin_*"], forward: 0.06, up: 0.14),
            .shift(["thigh_*"], up: 0.12)
        ]
    )

    /// Dumbbells pressed straight up and apart, out over the shoulders.
    private static let dumbbellsWide = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip", "forearm_*"], outward: 0.12)]
    )

    /// Seated press: handles gripped too high, the hands and elbows riding up.
    private static let handsHigh = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], up: 0.14), .shift(["forearm_*"], up: 0.1)]
    )

    /// Seated press: the back arched off the pad, the heels up.
    private static let seatedArched = FaultPose(
        chains: [["pelvis", "spine", "chest", "neck"], legs],
        moves: [
            .shift(["spine"], forward: 0.07),
            .shift(["chest", "neck"], forward: 0.1),
            .shift(["foot_*"], up: 0.07)
        ]
    )

    /// Standing cable fly: the elbows bending in, the hands folding toward
    /// the chest. Seen head-on, so the moves stay in the plane the camera sees.
    private static let flyFolded = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: 0.08, outward: -0.14),
                .shift(["forearm_*"], up: -0.05, outward: -0.06)]
    )

    /// Standing cable fly turned into a press: the elbows tuck in and drive
    /// forward.
    private static let flyPressed = FaultPose(
        chains: [arms],
        moves: [.shift(["forearm_*"], forward: 0.12, up: -0.04, outward: -0.12)]
    )

    /// Standing: the shoulders rolled forward and in.
    private static let shouldersRolledIn = FaultPose(
        chains: [arms, ["upper_arm_L", "upper_arm_R"]],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], forward: 0.1, up: 0.03, outward: -0.08)]
    )

    /// Lying on the floor: the hips bridging up to drive the weight, the
    /// feet left where they were.
    private static let hipsBridged = FaultPose(
        chains: [spine, ["pelvis", "thigh_L"], ["pelvis", "thigh_R"], legs],
        moves: [.shift(["pelvis", "thigh_*"], forward: 0.16), .shift(["spine"], forward: 0.07), .resolve(["shin_*"])]
    )

    /// The trunk turning about its own length, the left shoulder coming
    /// forward: rolling off a bench, or twisting to push one arm.
    private static func twisted(_ degrees: Float, about pivot: String = "pelvis") -> FaultPose {
        FaultPose(chains: [spine, shoulders, arms],
                  moves: [.turn(pivot: pivot, points: ["spine", "chest", "neck", "head", "upper_arm_*", "forearm_*", "hand_*"],
                                axis: .up, degrees: degrees)])
    }

    /// The single-arm lifts work the left arm.
    private static let leftArm = ["upper_arm_L", "forearm_L", "hand_L"]
    private static let leftArmToGrip = ["upper_arm_L", "forearm_L", "hand_L", "hand_L.tip"]

    private static let leftWristBentBack = FaultPose(
        chains: [["forearm_L", "hand_L", "hand_L.tip"]],
        moves: [.turn(pivot: "hand_L", points: ["hand_L.tip"], axis: .lateral, degrees: 48)]
    )

    private static func leftElbowFlared(_ degrees: Float = 38, strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [leftArm],
                  moves: [.turn(pivot: "upper_arm_L", points: ["forearm_L"], axis: .forward, degrees: degrees)],
                  strength: strength)
    }

    /// A pullover's stretch: the hands this far from the pelvis, in torso
    /// lengths, from arms over the chest (~1.3) to overhead (~1.8).
    private static let pulloverStretch = FaultStrength.between("hand_L", "pelvis", from: 1.4, to: 1.7)

    /// Pullover: the elbows bending at the stretch, the weight dropping
    /// behind the head.
    private static func pulloverElbowsBent(withBar: Bool) -> FaultPose {
        FaultPose(chains: [armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: 40)],
                  strength: pulloverStretch)
    }

    /// Pullover: the arms carried on past the line of the torso, below the
    /// bench. `degrees` is the swing past the model's own stretch, so a model
    /// that stops well short of the line needs more of it.
    private static func pulloverTooDeep(withBar: Bool, degrees: Float = 25) -> FaultPose {
        FaultPose(chains: [armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: degrees)],
                  strength: pulloverStretch)
    }

    /// Push-ups, flat or hands raised on a bench.
    private static let pushUpFaults: [String: FaultPose] = [
        "body": hipsSagging,
        "hands": handsForward,
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
    ]

    // MARK: Batch 133-160 pieces (2026-09-25)

    /// Push-up: the hands placed forward, toward the head.
    private static let handsForward = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], up: 0.26), .shift(["forearm_*"], up: 0.12)]
    )

    // Push-up variants (2026-09-30).

    /// Incline push-up: the hands placed forward on the bench, level with the
    /// head. Slid level (`ahead`), since the lifter's own `up` climbs with the
    /// incline and would lift them 7-10 cm off the bench.
    private static let handsForwardOnBench = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], ahead: 0.26), .shift(["forearm_*"], ahead: 0.12)]
    )

    /// Incline push-up: the feet sliding back, level along the floor rather
    /// than down the incline into it.
    private static let feetSlidBackLevel = FaultPose(
        chains: [legs],
        moves: [.shift(["foot_*", "foot_*.tip"], ahead: -0.14), .shift(["shin_*"], ahead: -0.06)]
    )

    /// Archer push-up: the hands set too close to shift over, about shoulder
    /// width instead of twice it.
    private static let archerHandsNarrow = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.4), .shift(["forearm_*"], outward: -0.2)]
    )

    /// Archer push-up: the working (bending) elbow flaring straight out to
    /// the side. The straight arm is left alone.
    private static let archerElbowFlared = FaultPose(
        chains: [["upper_arm_bent", "forearm_bent", "hand_bent"]],
        moves: [.shift(["forearm_bent"], outward: 0.25)],
        strength: .withBend("forearm_bent")
    )

    /// Archer push-up: short reps, the chest staying high over whichever arm
    /// is working (the push-up's own version fades with the left elbow).
    private static let archerStoppedHigh = FaultPose(
        chains: [spine, arms],
        moves: [
            .shift(["head", "neck", "chest", "upper_arm_*"], forward: -0.2),
            .shift(["spine"], forward: -0.15),
            .shift(["pelvis"], forward: -0.1),
            .shift(["forearm_*"], forward: -0.1)
        ],
        strength: .withBend("forearm_bent")
    )

    /// Hanging face-up under a bar: the hips sagging toward the floor.
    private static let hipsSaggingUnderBar = FaultPose(
        chains: [spine, ["pelvis", "thigh_L"], ["pelvis", "thigh_R"], ["thigh_*", "shin_*", "foot_*"]],
        moves: [
            .shift(["spine"], forward: -0.08),
            .shift(["pelvis", "thigh_*"], forward: -0.16),
            .shift(["shin_*"], forward: -0.07)
        ]
    )

    /// Pulls from the floor: the hips shooting up first and the knees locking,
    /// a stiff-legged good morning.
    private static let hipsShotUp = FaultPose(
        chains: [spine, legs, hips],
        moves: [.shift(["pelvis", "thigh_*"], rise: 0.14), .shift(["spine"], rise: 0.07), .straighten(["shin_*"])],
        strength: .withBend("shin_L")
    )

    /// The bar drifting out in front of the legs.
    private static func barDrifting(_ hands: Float, _ forearms: Float, withBar: Bool = true,
                                    strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [armsToGrip] + (withBar ? [bar] : []),
                  moves: [.shift(["hand_*", "hand_*.tip"], ahead: hands), .shift(["forearm_*"], ahead: forearms)],
                  strength: strength)
    }

    /// Leaning back past upright at the top of a pull, once the hips are
    /// straight.
    private static func leanedBackAtLockout(withBar: Bool) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 16)],
                  strength: .whenStraight("thigh_L"))
    }

    /// A row that only moves a few inches: the hands stay low.
    private static let rowedShort = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: 0.14), .shift(["forearm_*"], forward: 0.07)],
        strength: .withBend("forearm_L")
    )

    /// Stopping before the squeeze: the elbows never pass the trunk.
    private static let squeezeSkipped = FaultPose(
        chains: [arms, ["upper_arm_L", "upper_arm_R"]],
        moves: [.shift(["upper_arm_*"], forward: 0.07), .shift(["forearm_*"], forward: 0.1)],
        strength: .withBend("forearm_L")
    )

    /// One-arm rows (the left arm works): the elbow winging out.
    private static let leftElbowWinged = FaultPose(
        chains: [["upper_arm_L", "forearm_L", "hand_L"]],
        moves: [.shift(["forearm_L"], outward: 0.14)], strength: .withBend("forearm_L")
    )

    /// One-arm rows whose model rows with the elbow tucked (the 2026-09-30
    /// Meadows, Kettlebell, Gorilla and Renegade Rows, 5-21° out from the
    /// side): the working elbow winging well out. `leftElbowWinged` took
    /// these only to ~20-32°, and side-on, their framing, it moved straight
    /// at the camera (3-10 px). Pushed out, then re-seated between the
    /// shoulder and the hand so both bones keep their length, the elbow
    /// flares to ~50-55° at the top of the pull, seen from `view`.
    private static func leftElbowWingedWide(view: Float) -> FaultPose {
        FaultPose(chains: [["upper_arm_L", "forearm_L", "hand_L"]],
                  moves: [.shift(["forearm_L"], outward: 0.6), .resolve(["forearm_L"])],
                  strength: .withBend("forearm_L"), view: view)
    }

    /// One-arm rows: the trunk twisting open to heave the weight.
    private static let leftTwistedOpen = FaultPose(
        chains: [spine, shoulders, ["upper_arm_L", "forearm_L", "hand_L"]],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .up, degrees: -20)]
    )

    /// One-arm rows: the working shoulder left rounded forward.
    private static let leftShoulderForward = FaultPose(
        chains: [["upper_arm_L", "forearm_L", "hand_L"], ["upper_arm_L", "upper_arm_R"]],
        moves: [.shift(["upper_arm_L", "forearm_L", "hand_L"], forward: 0.11)]
    )

    /// Inverted rows, flat, feet-elevated or underhand.
    private static let invertedRowFaults: [String: FaultPose] = [
        "body": hipsSaggingUnderBar,
        "grip": gripTooWide(withBar: false),
        "elbow": elbowsWinged,
        // Short reps: the chest stays well below the bar.
        "barpath": FaultPose(
            chains: [spine, arms],
            moves: [
                .shift(["head", "neck", "chest", "upper_arm_*"], forward: -0.18),
                .shift(["spine"], forward: -0.13),
                .shift(["pelvis"], forward: -0.08),
                .shift(["forearm_*"], forward: -0.09)
            ],
            strength: .withBend("forearm_L")
        ),
        "scapula": shrugged
    ]

    // MARK: Batch 161-190 pieces (2026-09-25)

    /// Hanging pulls: the elbows drifting forward, curling the body up.
    private static let elbowsForward = FaultPose(
        chains: [arms], moves: [.shift(["forearm_*"], forward: 0.15)], strength: .withBend("forearm_L")
    )

    /// Hanging pulls: craning the chin up and over while the body stays low.
    private static let chinCraned = FaultPose(
        chains: [["chest", "neck", "head"]],
        moves: [.shift(["neck"], forward: 0.06, up: 0.03), .shift(["head"], forward: 0.14, up: 0.06)]
    )

    /// Hanging pulls, short reps: the body stops well below the bar.
    private static let hangingShort = FaultPose(
        chains: [spine, arms],
        moves: [.shift(["pelvis", "spine", "chest", "neck", "head", "upper_arm_*"], up: -0.16),
                .shift(["forearm_*"], up: -0.08)],
        strength: .withBend("forearm_L")
    )

    /// Pulldowns: the bar pulled down behind the neck.
    private static let pulledBehindNeck = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.2, up: 0.05), .shift(["forearm_*"], forward: -0.1)],
        strength: .withBend("forearm_L")
    )

    /// Pulldowns: the handle pulled down past the chest.
    private static let pulledPastChest = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], up: -0.15), .shift(["forearm_*"], forward: -0.05, up: -0.05)],
        strength: .withBend("forearm_L")
    )

    /// Pulldowns, short reps: the bar stopping at the chin (Reverse-Grip Lat
    /// Pulldown). The hands end 0.32 torso lengths (~19 cm) higher and 0.15
    /// (~9 cm) further forward than the model's bottom, the bar (palms) at
    /// about chin height, with the elbows re-seated between the shoulders and
    /// the raised hands (~70°, as the model holds them when its own bar passes
    /// the chin). 0.14 up put the bar only at the collarbones. Shown near the
    /// bottom only: none by a shoulder-to-wrist distance of 0.53 torso lengths
    /// (the model's bar passing the chin), all of it by 0.47 (the model's
    /// bottom is 0.45-0.48).
    private static let pulldownShort = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: 0.15, up: 0.32), .resolve(["forearm_*"])],
        strength: .between("upper_arm_L", "hand_L", from: 0.53, to: 0.47)
    )

    /// Lever pulldowns, short reps: the elbows stopping above the shoulders
    /// (Machine Lat Pulldown). The hands end 0.72 torso lengths (~43 cm)
    /// higher and 0.18 (~11 cm) further forward than the model's bottom, level
    /// with the top of the head, and the re-seated elbows ~5 cm above the
    /// shoulders at ~124°, the model's own pose ~0.45 s into the pull. Shown
    /// near the bottom only: none by a shoulder-to-wrist distance of 0.72
    /// torso lengths, all of it by 0.56 (the model's bottom is 0.53), so the
    /// ghost never passes the top of the rep.
    private static let leverPulldownShort = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: 0.18, up: 0.72), .resolve(["forearm_*"])],
        strength: .between("upper_arm_L", "hand_L", from: 0.72, to: 0.56)
    )

    /// Rows: the handle pulled low, toward the belly, instead of the chest.
    private static func rowedLow(withBar: Bool) -> FaultPose {
        FaultPose(chains: [armsToGrip] + (withBar ? [bar] : []),
                  moves: [.shift(["hand_*", "hand_*.tip"], up: -0.14), .shift(["forearm_*"], up: -0.06, outward: -0.06)],
                  strength: .withBend("forearm_L"))
    }

    /// Hands drawn in toward each other on a wide grip.
    private static func gripTooNarrow(withBar: Bool) -> FaultPose {
        FaultPose(chains: [armsToGrip] + (withBar ? [bar] : []),
                  moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.14), .shift(["forearm_*"], outward: -0.08)])
    }

    /// Both-hands rows: the trunk twisting toward one side.
    private static let trunkTwisted = FaultPose(
        chains: [spine, shoulders, arms],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .up, degrees: -20)]
    )

    /// One-arm pulldowns, short reps: the working hand stopping above the head
    /// (Single-Arm Lat Pulldown). The hand ends 0.66 torso lengths (~39 cm)
    /// higher and 0.22 (~13 cm) further forward than the model's bottom, the
    /// handle above the crown, and the elbow is re-seated just above the
    /// shoulder (~115°), the model's own pose ~0.35 s into the pull. 0.14 up
    /// left the hand at the neck. Shown near the bottom only: none by a
    /// shoulder-to-wrist distance of 0.56 torso lengths, all of it by 0.46
    /// (the model's bottom is 0.45).
    private static let leftPullShort = FaultPose(
        chains: [["upper_arm_L", "forearm_L", "hand_L", "hand_L.tip"]],
        moves: [.shift(["hand_L", "hand_L.tip"], forward: 0.22, up: 0.66), .resolve(["forearm_L"])],
        strength: .between("upper_arm_L", "hand_L", from: 0.56, to: 0.46)
    )

    /// One-arm pulls: the working shoulder shrugging up.
    private static let leftShrugged = FaultPose(
        chains: [shoulders, ["upper_arm_L", "forearm_L", "hand_L"]],
        moves: [.shift(["upper_arm_L", "forearm_L", "hand_L"], up: 0.12)]
    )

    // MARK: Batch 191-240 pieces (2026-09-26)

    // MARK: Batch 191-240 barbell, Smith and landmine press pieces (2026-09-26)

    /// Overhead presses: the hands, and the bar, held above where the rep
    /// should start — a rep cut short at the bottom, or the arms pressing
    /// early out of a push press's dip — the elbows opening under them.
    private static func barHeldHigh(withBar: Bool, strength: FaultStrength = .withBend("forearm_L")) -> FaultPose {
        FaultPose(chains: [armsToGrip] + (withBar ? [bar] : []),
                  moves: [.shift(["hand_*", "hand_*.tip"], up: 0.16), .resolve(["forearm_*"])],
                  strength: strength)
    }

    /// A push press's dip: none standing tall, all of it at the bottom of the
    /// dip. The pelvis is this far from the left ankle, in torso lengths:
    /// ~1.42 standing, ~1.27 at the bottom of the model's dip.
    private static let pushPressDip = FaultStrength.between("pelvis", "foot_L", from: 1.40, to: 1.30)

    /// One-arm landmine presses (the left arm works): the hand driven across
    /// the body toward the midline near the top instead of straight up and
    /// out, turned toward face-on so the drift shows.
    private static let leftPressedAcross = FaultPose(
        chains: [leftArmToGrip],
        moves: [.shift(["hand_L", "hand_L.tip"], outward: -0.16), .shift(["forearm_L"], outward: -0.06)],
        strength: .whenStraight("forearm_L"), view: 0.6
    )

    /// One-arm landmine presses: the trunk turning 30° to drive the pressing
    /// (left) shoulder forward. Seen side-on (a total of about -1.5), where
    /// square shoulders sit one behind the other and the twisted ones split
    /// ~20 cm front to back, the pressing arm carried forward with them. The
    /// free arm is left out: its hand stays on the hip, and drawn it only
    /// made lines across the chest.
    private static let leftShoulderTwistedForward = FaultPose(
        chains: [spine, shoulders, leftArm],
        moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*", "forearm_L", "hand_L"], axis: .up, degrees: 30)],
        view: -0.5
    )

    // MARK: Batch 191-240 dumbbell and cable press pieces (2026-09-26)

    /// Dumbbell push press: how far into the dip the lifter is. None standing
    /// (pelvis ~1.42 torso lengths from the left ankle), all of it at the
    /// bottom of the ~8 cm dip (~1.29), so dip faults fade out as the knees
    /// straighten and never show while the dumbbells are lowered. The same
    /// numbers as the barbell family's `pushPressDip`; either can stand in.
    private static let dumbbellPushPressDip = FaultStrength.between("pelvis", "foot_L", from: 1.40, to: 1.30)

    /// Overhead presses: the elbows (`*`, or the left one, `L`) pulled back
    /// behind the shoulders at the bottom, out of the scapular plane, the
    /// weight drifting back with them. The elbow's shift is large because the
    /// re-seat pulls most of it back toward the real pose: on the rig it ends
    /// ~3 cm behind the shoulder joint (the real one is ~9 cm in front), the
    /// hand ~7 cm back. Turned side-on so the drift back shows.
    private static func pressElbowsDraggedBack(_ side: String) -> FaultPose {
        FaultPose(chains: [arm(side)],
                  moves: [.shift(["forearm_\(side)"], forward: -0.25, outward: 0.06),
                          .shift(["hand_\(side)", "hand_\(side).tip"], forward: -0.12),
                          .resolve(["forearm_\(side)"])],
                  strength: .withBend(elbow(side)), view: -1.0)
    }

    /// Overhead presses: stopping short of lockout, the hands (`*`, or the left
    /// one, `L`) held low with the elbows still bent. Shown near lockout. The
    /// elbow is nudged out to the side first so the re-seat bends it in the
    /// frontal plane, across the screen: a soft lockout bows the left elbow
    /// toward the camera, where the bend hid. On the rig the elbow ends ~12 cm
    /// out at ~108°, the hand ~9 cm lower.
    private static func pressLockoutBent(_ side: String) -> FaultPose {
        FaultPose(chains: [arm(side)],
                  moves: [.shift(["forearm_\(side)"], outward: 0.12),
                          .shift(["hand_\(side)", "hand_\(side).tip"], up: -0.2),
                          .resolve(["forearm_\(side)"])],
                  strength: .whenStraight(elbow(side)))
    }

    /// Seated presses: the feet pulled back under the seat and up on the toes,
    /// further than the shared `feetTucked` (whose shins only reach vertical):
    /// on the rig the toes go ~18 cm back and the ankles end behind the knees.
    private static let pressFeetTucked = FaultPose(
        chains: [legs],
        moves: [.shift(["foot_*", "foot_*.tip"], ahead: -0.3),
                .turn(pivot: "foot_*.tip", points: ["foot_*"], axis: .lateral, degrees: -25),
                .resolve(["shin_*"])]
    )

    /// Cable presses: the feet drawn together, the ankles about touching (~10
    /// cm apart against the real 34 and the hips' 18), and the knees locked.
    /// The shared `squareLockedStance` only brings them to about hip width.
    private static let cableFeetTogetherLocked = FaultPose(
        chains: [legs],
        moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.2), .straighten(["shin_*"])]
    )

    /// One-arm overhead presses (the left arm works): the trunk bending over
    /// to the right, away from the working arm, with everything it carries.
    private static let pressLeanedAway = FaultPose(
        chains: [spine, shoulders, armsToGrip],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .forward, degrees: 12)]
    )

    /// Strict standing presses: the knees dipping to drive the weight, the
    /// hips and all they carry sinking. Shown while the arms are bent, turned
    /// so the knees show.
    private static let pressKneesDipped = FaultPose(
        chains: [spine, legs, hips, armsToGrip],
        moves: [.shift(carried, rise: -0.1), .resolve(["shin_*"])],
        strength: .withBend("forearm_L"), view: -0.6
    )

    /// Neutral-grip presses: the wrists bent back. With the palms facing in,
    /// the backs of the hands face out, so the hands tip outward (about the
    /// chest's axis, not the side-to-side one `wristBentBack` turns about).
    private static let palmsInWristsBentBack = FaultPose(
        chains: [["forearm_*", "hand_*", "hand_*.tip"]],
        moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .forward, degrees: -40)]
    )

    // MARK: Batch 191-240 lateral and cuff pieces (2026-09-26)

    /// One-arm lifts (the left arm works): the trunk tipping sideways about
    /// the pelvis with the left arm carried along, positive to the lifter's
    /// right, negative to the left. The right arm is left out of the ghost,
    /// since its hand stays on a support or the hip.
    private static func leftArmTrunkTipped(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, shoulders, arm("L")],
                  moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"] + arm("L").dropFirst(),
                                axis: .forward, degrees: degrees)])
    }

    /// One-arm raises: the left arm left hanging out from the side instead of
    /// coming all the way down. None once the hand is 0.9 torso lengths from
    /// the hip (mid-rep), all of it at the bottom (~0.45).
    private static let leftRaiseShortAtBottom = armsTurned(.forward, 30, side: "L",
                                                           strength: .between("hand_L", "thigh_L", from: 0.9, to: 0.45))

    /// One-arm lifts: the trunk twisting the other way from
    /// `leftTwistedOpen`, the left shoulder coming forward to carry the hand
    /// across the body.
    private static let leftTwistedIn = FaultPose(
        chains: [spine, shoulders, ["upper_arm_L", "forearm_L", "hand_L"]],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .up, degrees: 20)]
    )

    /// Overhead raises (Y, cable Y): the arms stopping well short of the top,
    /// lowered out to the sides to about shoulder level, a T instead of a Y,
    /// so both arms stay in the trunk's plane and show from behind. None
    /// until the hands are 1.5 torso lengths from the pelvis, all of it at
    /// the top (~1.8).
    private static let overheadShort = armsTurned(.forward, -50, strength: .between("hand_L", "pelvis", from: 1.5, to: 1.8))

    /// Chest-supported raises: the shoulders shrugged toward the ears, the
    /// arms lifted with them, and the head drawn so the closing gap shows.
    /// Bigger than `shrugged` and seen from the rear-left, since from behind
    /// a shrug runs into the screen.
    private static let proneShrugged = FaultPose(
        chains: [["head", "neck"], shoulders, arms],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.2)]
    ).seen(0.9)

    /// Side-lying raises: the top (left) shoulder hiked toward the ear, with
    /// the head drawn so the closing gap shows; the shoulder line is
    /// otherwise one straight line with the raised arm.
    private static let leftShruggedLying = FaultPose(
        chains: [["head", "neck"], shoulders, ["upper_arm_L", "forearm_L", "hand_L"]],
        moves: [.shift(["upper_arm_L", "forearm_L", "hand_L"], up: 0.2)]
    )

    /// Side-lying raises: the chest rolling back toward the ceiling about
    /// the trunk's long axis, the working arm carried along. Turned further
    /// than `leftTwistedOpen` so the shoulder line visibly turns, not only
    /// the arm.
    private static func leftRolledBack(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, shoulders, ["upper_arm_L", "forearm_L", "hand_L"]],
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .up, degrees: -degrees)])
    }

    // MARK: Batch 191-240 front raise, rear-delt row and upright row pieces (2026-09-26)

    /// Front raises: how far the working hand has risen, hand to pelvis in
    /// torso lengths — about 0.45-0.55 hanging at the thighs, 1.25-1.5 at
    /// shoulder height in every front-raise model — so a fault of the top of
    /// the raise grows as the arm lifts. Read on the left hand, so on the
    /// alternating raise it shows during the left arm's rep only.
    private static let frontRaiseRising = FaultStrength.between("hand_L", "pelvis", from: 0.9, to: 1.25)

    /// Rear-delt rows: the elbows tucked in to the sides, the upper arms
    /// swung down along the trunk toward the hips — a lat row (upper arms
    /// about 43° from the trunk instead of 87°). Shown with the elbows bent,
    /// at the top of the row.
    private static let rearDeltElbowsTucked = FaultPose(
        chains: [armsToGrip],
        moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .forward, degrees: -50)],
        strength: .withBend("forearm_L")
    )

    /// Upright rows hauled too high: the bar (palms) up to the chin, about
    /// 10 cm above the shoulder joints instead of 17 cm below, the elbows
    /// about 18 cm above the shoulders. The elbows are re-seated between the
    /// shoulders and the raised hands. Shown with the elbows bent, at the top.
    private static let uprightRowHigh = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["hand_*", "hand_*.tip"], up: 0.45), .shift(["forearm_*"], up: 0.3, outward: 0.03),
                .resolve(["forearm_*"])],
        strength: .withBend("forearm_L")
    )

    /// Upright rows led by the hands: the elbows trailing low and in, about
    /// 25 cm below the shoulders and below the bar, which is curled up with
    /// the wrists (a reverse curl). The elbows are re-seated between the
    /// shoulders and the fixed hands; the shift only picks the direction.
    private static let uprightRowElbowsLow = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["forearm_*"], up: -0.45, outward: -0.25), .resolve(["forearm_*"])],
        strength: .withBend("forearm_L")
    )

    /// Hands bunched in the middle of the bar, about 16-22 cm apart instead
    /// of 42-48. Clearest at the bottom, where the hanging arms form a V
    /// against the parallel grey arms.
    private static let gripBunched = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.22), .shift(["forearm_*"], outward: -0.1)]
    )

    // MARK: Batch 191-240 pieces: shrugs and loaded carries (2026-09-26)

    /// Shrugs: none of the fault with the shoulders dropped, all of it at
    /// the top. Every shrug model lifts the left shoulder from 0.95 to 1.03
    /// torso lengths above the pelvis.
    private static let shrugTop = FaultStrength.between("upper_arm_L", "pelvis", from: 0.96, to: 1.02)

    /// The shoulders held lower than the lifter's, the arms and grip lowered
    /// with them: a shrug stopped short (with `shrugTop`), or shoulders
    /// sinking under weights held overhead.
    private static func shouldersLowered(_ amount: Float, withBar: Bool = false,
                                         strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [shoulders, armsToGrip] + (withBar ? [bar] : []),
                  moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], up: -amount)],
                  strength: strength)
    }

    /// A shrug rolled at the top: the shoulders come forward (positive) or
    /// go back, the arms and grip carried with them.
    private static func shrugRolled(_ forward: Float, withBar: Bool = false) -> FaultPose {
        FaultPose(chains: [shoulders, armsToGrip] + (withBar ? [bar] : []),
                  moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], forward: forward)],
                  strength: shrugTop)
    }

    /// A shrug rolled forward on a Smith bar, which cannot leave its rails:
    /// at the top the shoulders come forward (as far as `shrugRolled(0.14)`)
    /// while the hands stay on the track, sinking about 1.5 cm so the
    /// straight arms keep their length (the elbows re-seat at 175° against
    /// the lifter's 178° at the top, about 170° while it fades).
    private static let shrugRolledOnTrack = FaultPose(
        chains: [shoulders, armsToGrip, bar],
        moves: [.shift(["upper_arm_*"], forward: 0.14),
                .shift(["hand_*", "hand_*.tip"], up: -0.025),
                .resolve(["forearm_*"])],
        strength: shrugTop
    )

    /// A shrug finished with the arms: at the top the elbows bend and the
    /// hands curl up and forward. For loads that are free to swing forward
    /// (dumbbells, cable handles, a trap bar, a free bar in front).
    private static func shrugCurled(withBar: Bool) -> FaultPose {
        FaultPose(chains: [armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: 40)],
                  strength: shrugTop)
    }

    /// A shrug finished with the arms on a bar that cannot swing forward (a
    /// Smith track, or a bar behind the legs): at the top the elbows drive
    /// back `back`° and bend `bend`°, the bar riding straight up close to the
    /// body. Pick `back` so the grip keeps its distance ahead of or behind
    /// the pelvis.
    private static func shrugRowed(back: Float, bend: Float) -> FaultPose {
        FaultPose(chains: [armsToGrip, bar],
                  moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -back),
                          .turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: bend)],
                  strength: shrugTop)
    }

    /// Carries walked in place: a long, reaching stride that opens at both
    /// ends, the leading foot planted further ahead and the trailing foot
    /// further behind, the hips dropping a little as the stride opens (the
    /// bob of a long stride) so the straight trailing leg still reaches; both
    /// knees re-seated. `from`…`to` is the gap between the ankles in torso
    /// lengths, so the ghost fades out as the feet pass each other, where the
    /// leading side swaps.
    private static func longStride(from: Float, to: Float) -> FaultPose {
        FaultPose(chains: [legs, hips],
                  moves: [.shift(["thigh_*"], up: -0.05),
                          .shift(["foot_front", "foot_front.tip"], forward: 0.2),
                          .shift(["foot_back", "foot_back.tip"], forward: -0.14),
                          .resolve(["shin_front", "shin_back"])],
                  strength: .between("foot_L", "foot_R", from: from, to: to))
    }

    /// One-sided carries (the weight in the left hand): the trunk bending
    /// over toward the weight, the loaded shoulder dropping.
    private static let leanedToLoad = FaultPose(
        chains: [spine, shoulders, armsToGrip],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .forward, degrees: -10)]
    )

    // MARK: Batch 191-240 curl pieces (2026-09-26)

    /// Curls: the wrist curling in toward the forearm as the weight comes up,
    /// the fingers tipping toward the shoulder — the Biceps Curl's wrist fault
    /// for one side or both, strongest at the top of the rep. With the palm
    /// up (or turned up by the top), a positive turn about `.lateral` folds the
    /// hand toward the palm. `degrees` is raised where the lifter is framed
    /// small (the Spider Curl), so the fold reads at a glance.
    private static func curlWristsCurled(_ side: String = "*", withBar: Bool = false,
                                         degrees: Float = 50) -> FaultPose {
        FaultPose(chains: [["forearm_\(side)", "hand_\(side)", "hand_\(side).tip"]] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "hand_\(side)", points: ["hand_\(side).tip"], axis: .lateral, degrees: degrees)],
                  strength: .withBend(elbow(side)))
    }

    /// Preacher pad or curl machine: the upper arms lifting off the pad as the
    /// weight rises (`elbowsForward`'s turn), drawn to the wrists only: at the
    /// top of the curl a hand tip would reach up into the mistake pill.
    private static func curlArmsOffPad(_ degrees: Float, side: String = "*") -> FaultPose {
        FaultPose(chains: [["upper_arm_\(side)", "forearm_\(side)", "hand_\(side)"]],
                  moves: [.turn(pivot: "upper_arm_\(side)", points: ["forearm_\(side)", "hand_\(side)"],
                                axis: .lateral, degrees: degrees)],
                  strength: .withBend(elbow(side)))
    }

    /// Curls cut short at the bottom: the elbows stay bent where the arms
    /// should be (nearly) straight, shown only near full extension. `from`…`to`
    /// is shoulder-to-wrist in torso lengths, read on the left arm (or `side`),
    /// as in `pushdownShort`.
    private static func curlBottomCut(_ side: String = "*", from: Float, to: Float) -> FaultPose {
        let s = side == "*" ? "L" : side
        return elbowsFolded(.lateral, 45, side: side,
                            strength: .between("upper_arm_\(s)", "hand_\(s)", from: from, to: to))
    }

    /// Seated curls on a preacher pad or curl machine: the trunk rocking back
    /// from the hips as the weight comes up, the arms carried off the pad.
    /// Both models sit 12° forward, so the turn must pass 12° for the ghost
    /// to lean back rather than sit tall (22° ends ~10° behind vertical).
    /// `side` is the arm drawn, to the wrist (a hand tip at the top would
    /// reach the mistake pill): `*` for both, `L` for the one-arm preacher.
    private static func curlSeatedSwungBack(_ degrees: Float, side: String = "*") -> FaultPose {
        FaultPose(chains: [spine, ["upper_arm_\(side)", "forearm_\(side)", "hand_\(side)"]],
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: degrees)],
                  strength: .withBend(elbow(side)))
    }

    /// Preacher bench, seat too low: the body sinks 0.2 torso lengths while
    /// the arms stay hooked over the pad, so the shoulders ride up toward the
    /// ears (the neck ends ~5 cm below the shoulder line, the head ~12 cm
    /// lower) and the knees bend further (124° to ~101°). The toes never move,
    /// so the legs are drawn to the ankles only.
    private static let preacherSatLow = FaultPose(
        chains: [spine, shoulders, ["thigh_*", "shin_*", "foot_*"], hips],
        moves: [.shift(["pelvis", "thigh_*"] + torso, rise: -0.2), .resolve(["shin_*"])]
    )

    /// Curl machine, seat too low: the body and upper arms sit lower while the
    /// hands stay on the handle, so the elbows drop below the lever's pivot.
    private static let curlMachineSatLow = FaultPose(
        chains: [spine, arms, legs, hips],
        moves: [.shift(["pelvis", "thigh_*", "upper_arm_*"] + torso, rise: -0.1), .resolve(["forearm_*", "shin_*"])]
    )

    // MARK: Legs 300-350 pieces (2026-09-26)

    // MARK: Batch 300-350 split squat pieces (2026-09-26)

    /// A back-loaded bar sliding down onto the rear delts, the chest tipping
    /// forward to balance it: the Back Squat's bar fault with less lean, as
    /// these split squats stay nearly upright (3-14° in the models). It grows
    /// with the front knee's bend.
    private static let barSlidLow = FaultPose(
        chains: [spine, armsToGrip, bar],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -10),
                .shift(["hand_*", "hand_*.tip"], forward: -0.03, up: -0.1),
                .resolve(["forearm_*"])],
        strength: .withBend("shin_L")
    )

    /// Smith lifts: the chest folding forward under the fixed bar. The hips
    /// and all they carry slide back by as much as the lean brings the
    /// shoulders forward, so the bar stays over its vertical track while the
    /// chest drops; both knees re-seat under the moved hips.
    private static func hipsBehindFixedBar(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, legs, hips, bar],
                  moves: [.shift(carried, ahead: -sin(degrees * .pi / 180)),
                          .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -degrees),
                          .resolve(["shin_*"])],
                  strength: .withBend("shin_L"))
    }

    /// Smith lifts: the bar set low on the back of the shoulders under the
    /// fixed track. The hands sit ~6 cm lower on the back, the chest tips 10°
    /// and the hips slide ~8 cm back, so the bar stays on its vertical line
    /// (within 3 mm of it at the bottom on the rig) — unlike `barSlidLow`,
    /// whose bar tips ~8 cm forward with the chest. Grows with the front knee.
    private static let barLowOnTrack = FaultPose(
        chains: [spine, armsToGrip, legs, hips, bar],
        moves: [.shift(carried, ahead: -0.13),
                .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -10),
                .shift(["hand_*", "hand_*.tip"], forward: -0.03, up: -0.1),
                .resolve(["forearm_*"]),
                .resolve(["shin_*"])],
        strength: .withBend("shin_L")
    )

    /// Split squats with the left foot forward: the front foot tucked too
    /// close under a fixed bar, so the heel cannot stay down. The foot sits
    /// ~12 cm closer to the back foot and rocks up about the toes (the ankle
    /// ~7 cm higher at the bottom); the knee, re-seated between the same hip
    /// and the lifted ankle, ends about over the toes.
    private static let frontFootTooClose = FaultPose(
        chains: [leg("L"), hips],
        moves: [.shift(["foot_L", "foot_L.tip"], ahead: -0.2),
                .turn(pivot: "foot_L.tip", points: ["foot_L"], axis: .lateral, degrees: -20),
                .resolve(["shin_L"])],
        strength: .withBend("shin_L")
    )

    /// Rear-foot-elevated split squats (right foot on the bench): the back
    /// foot perched on its toes instead of lying on its laces. The ankle
    /// swings up about the toes (~15 cm) and the knee re-seats under the hip.
    /// The laces-down foot points backward from the ankle, so a positive turn
    /// about `.lateral` lifts the ankle.
    private static let rearFootOnToes = FaultPose(
        chains: [leg("R")],
        moves: [.turn(pivot: "foot_R.tip", points: ["foot_R"], axis: .lateral, degrees: 40),
                .resolve(["shin_R"])]
    )

    // MARK: Legs 300-350 lunge pieces (2026-09-26)

    /// An alternating lunge's front foot planted `by` torso lengths nearer
    /// the back foot along the floor, the front knee re-seated further
    /// forward over it: a short step, or a front foot set too far back
    /// under a Smith bar. `heelUp` degrees also rock the foot up onto its
    /// toes, for a foot so far back that the heel peels off the floor at the
    /// bottom. Grows as the front knee bends.
    private static func lungeStepShort(_ by: Float, heelUp: Float = 0) -> FaultPose {
        let lift: [FaultMove] = heelUp > 0
            ? [.turn(pivot: "foot_front.tip", points: ["foot_front"], axis: .lateral, degrees: -heelUp)]
            : []
        return FaultPose(chains: [leg("front"), hips],
                         moves: [.shift(["foot_front", "foot_front.tip"], ahead: -by)] + lift + [.resolve(["shin_front"])],
                         strength: .withBend("shin_front"))
    }

    /// An alternating lunge's front foot landing on the back foot's line (a
    /// tightrope stance): moved `by` torso lengths in toward the midline, the
    /// front knee following it in.
    private static func lungeStepInLine(_ by: Float) -> FaultPose {
        FaultPose(chains: [leg("front"), hips],
                  moves: [.shift(["foot_front", "foot_front.tip"], outward: -by), .resolve(["shin_front"])],
                  strength: .withBend("shin_front"))
    }

    /// A lunge's back leg from hip to ankle. Its heel is up, so the foot's
    /// `.tip`, drawn a fixed length along the foot, would run ~5 cm through
    /// the floor; these ghosts stop the back leg at the ankle.
    private static let lungeBackLeg = ["thigh_back", "shin_back", "foot_back"]

    /// A lunge stopping high: `shallow` with the back leg drawn only to the
    /// ankle.
    private static func lungeShallow(_ rise: Float, ahead: Float = 0) -> FaultPose {
        FaultPose(chains: [spine, leg("front"), lungeBackLeg, hips, armsToGrip],
                  moves: [.shift(carried, ahead: ahead, rise: rise), .resolve(["shin_*"])],
                  strength: .withBend("shin_L"))
    }

    /// A lunge's back leg pushing the body up, its knee straightening:
    /// `rearLegPushing` with the back leg drawn only to the ankle.
    private static func lungeBackLegPushing(strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [lungeBackLeg, hips], moves: [.straighten(["shin_back"])], strength: strength)
    }

    /// A curtsy lunge's hips opening: the pelvis and everything above it turn
    /// about the front hip toward the leg that crosses behind, the back hip
    /// swinging back and the back knee re-seated over the planted back foot.
    /// The pivot is the front hip, so a positive turn opens toward whichever
    /// leg is behind (an `_R` pivot mirrors it).
    private static func curtsyHipsOpened(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, shoulders, arms, ["thigh_front", "pelvis", "thigh_back"], leg("back")],
                  moves: [.turn(pivot: "thigh_front", points: ["pelvis", "thigh_back"] + trunk, axis: .up, degrees: degrees),
                          .resolve(["shin_back"])],
                  strength: .withBend("shin_front"))
    }

    /// A curtsy lunge's back foot swung far across behind the front one:
    /// moved `by` torso lengths further toward the front leg's side (it
    /// already sits past the midline, so that is inward for its own side),
    /// the back knee re-seated.
    private static func curtsyCrossedFar(_ by: Float) -> FaultPose {
        FaultPose(chains: [leg("back"), hips],
                  moves: [.shift(["foot_back", "foot_back.tip"], outward: -by), .resolve(["shin_back"])],
                  strength: .withBend("shin_front"))
    }

    // MARK: Late additions pieces (2026-09-27)

    // MARK: Late additions 2026-09-27: seated lateral raise, cable rear delt row and dumbbell upright row pieces

    /// Seated lateral raise: how far the left hand has risen, hand to pelvis
    /// in torso lengths — about 0.64 with the arms hanging beside the bench,
    /// 1.49 with the arms level in the Seated Dumbbell Lateral Raise — so a
    /// fault of the top of the raise grows over the upper half of the lift
    /// and is gone with the arms by the sides.
    private static let seatedRaiseRising = FaultStrength.between("hand_L", "pelvis", from: 1.0, to: 1.4)

    /// Dumbbell upright rows: how far the dumbbells have risen, left hand to
    /// pelvis in torso lengths — about 0.51 at the thighs, 0.89 at the top in
    /// the Dumbbell Upright Row — so a fault of the top shows only over the
    /// last part of the pull (the elbow is already ~150° at the thighs, so
    /// `.withBend` would draw a third of it at the bottom).
    private static let dumbbellUprightRowTop = FaultStrength.between("hand_L", "pelvis", from: 0.7, to: 0.88)

    /// Dumbbell upright rows hauled too high: `uprightRowHigh`'s moves
    /// without the bar line, since each hand holds its own dumbbell. On the
    /// rig the hands end ~12 cm above the shoulder joints (chin height)
    /// instead of 14 cm below, the elbows ~14 cm above the shoulders (upper
    /// arms ~120° instead of 90°), re-seated between the shoulders and the
    /// raised hands. Shown near the top only.
    private static let dumbbellUprightRowHigh = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], up: 0.45), .shift(["forearm_*"], up: 0.3, outward: 0.03),
                .resolve(["forearm_*"])],
        strength: dumbbellUprightRowTop
    )

    /// Dumbbell upright rows led by the hands: `uprightRowElbowsLow` without
    /// the bar line. On the rig, at the top, the elbows trail ~27 cm below
    /// the shoulders and ~7 cm out from them (upper arms ~20° from the
    /// sides) while the hands stay at the chest, curled up by the wrists.
    private static let dumbbellUprightRowElbowsLow = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["forearm_*"], up: -0.45, outward: -0.25), .resolve(["forearm_*"])],
        strength: .withBend("forearm_L")
    )

    /// Dumbbells held together in the middle instead of about shoulder-width:
    /// the hands ~7 cm in on each side (~26-32 cm apart instead of 40-47),
    /// the elbows ~3 cm in and re-seated so both bones keep their length. No
    /// bar line.
    private static let dumbbellsTogether = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.12), .shift(["forearm_*"], outward: -0.05),
                .resolve(["forearm_*"])]
    )

    // MARK: Barbell hip thrust pieces (2026-09-27)
    //
    // Moves along the floor use the body's own `up` or the room's `rise`,
    // never `ahead`: a hip thrust's trunk tilts up toward the head at the
    // bottom and lies level at lockout, so `BodyFrame.ahead` points at the
    // feet for the first ~0.6 s of each rep and at the head for the rest.

    /// A hip thrust's lockout, read from hip height: the pelvis this far
    /// from the left ankle, in torso lengths (0.86 at the bottom, 1.06 at
    /// lockout on the rig), so a fault of the top shows fully at lockout and
    /// not at all in the lower half of the rep. `.whenStraight("thigh_L")`
    /// tops out near 0.6 on this lift: it reads the hip from the spine joint,
    /// which sits only ~11 cm up the trunk from hip joints ~9 cm to either
    /// side, so a straight hip measures ~145°.
    private static let thrustLockout = FaultStrength.between("pelvis", "foot_L", from: 0.9, to: 1.04)

    /// A bridge or hip thrust stopped short of lockout: the hips, and the bar
    /// resting on them, hang `drop` torso lengths below the line of the knees
    /// and shoulders. The trunk pivots on the shoulders, so the spine and
    /// chest sink less than the pelvis; the knees and elbows re-seat. Shown
    /// at the top: `strength` is the lift's lockout reading.
    private static func hipsShortOfLockout(_ drop: Float, strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [spine, legs, hips, armsToGrip, bar],
                  moves: [.shift(["pelvis", "thigh_*", "hand_*", "hand_*.tip"], rise: -drop),
                          .shift(["spine"], rise: -drop * 0.8),
                          .shift(["chest"], rise: -drop * 0.5),
                          .resolve(["shin_*"]),
                          .resolve(["forearm_*"])],
                  strength: strength)
    }

    /// A hip thrust finished with the lower back: the lumbar spine humps up
    /// above the line of the pelvis and chest at lockout. `bridgeArched`,
    /// larger (~7 cm at the spine joint) and read from hip height.
    private static let thrustArched = FaultPose(
        chains: [spine],
        moves: [.shift(["spine"], rise: 0.12), .shift(["chest"], rise: 0.05)],
        strength: thrustLockout
    )

    /// Hip thrust feet set too far out: the feet sit `reach` torso lengths
    /// further from the hips along the trunk's line (level at lockout), so
    /// the shins slope away and the knees open well past 90°. Shown only
    /// toward lockout, where it is judged; at the bottom the tilted trunk
    /// would push the moved feet into the floor.
    private static func thrustFeetFar(_ reach: Float) -> FaultPose {
        FaultPose(chains: [legs, hips],
                  moves: [.shift(["foot_*", "foot_*.tip"], up: -reach), .resolve(["shin_*"])],
                  strength: thrustLockout)
    }

    /// Hip thrust: the back sliding up the bench as the hips rise instead of
    /// hinging on its edge. The hips, trunk, arms and bar ride `slide` torso
    /// lengths toward the head, the feet stay planted and the knees open
    /// behind them; it grows as the hips rise.
    private static func slidUpBench(_ slide: Float) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, bar, legs, hips],
                  moves: [.shift(carried, up: slide), .resolve(["shin_*"])],
                  strength: thrustLockout)
    }

    /// Hip thrust: the bar rolled up off the hip crease onto the stomach as
    /// the hips near lockout (ExRx: keep the bar from rolling back near the
    /// top), the hands following it `roll` torso lengths toward the head and
    /// the elbows re-seating between them and the shoulders. Read from hip
    /// height: at the bottom the trunk slopes up toward the head, so the
    /// crease is a valley the bar cannot roll out of.
    private static func barRolledUp(_ roll: Float, strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [armsToGrip, bar],
                  moves: [.shift(["hand_*", "hand_*.tip"], up: roll), .resolve(["forearm_*"])],
                  strength: strength)
    }

    // MARK: Batch 241-300 pieces (2026-09-27)

    // MARK: Batch 241-300 preacher and machine curl pieces (2026-09-27)

    /// Palm-down or thumb-up curls: the wrist giving way under the weight,
    /// the hand tipping down toward the floor — into flexion with the palm
    /// down (Reverse Preacher Curl), toward the little finger with the thumb
    /// up (Preacher Hammer Curl). With the palm facing down or in, a
    /// negative turn about `.lateral` tips the hand down, the other way from
    /// `curlWristsCurled`. On a preacher pad the weight sits furthest out in
    /// front of the wrist near the bottom, so all of it shows from the
    /// bottom until the elbow is at ~125° (shoulder to wrist 0.8 torso
    /// lengths, read on the left arm or `side`) and none of it by 90°
    /// (0.64). On the rig the hand ends 45° below the forearm's line at the
    /// bottom and is back in line at the top.
    private static func curlWristsGivingWay(_ side: String = "*", withBar: Bool = false,
                                            degrees: Float = 45) -> FaultPose {
        let s = side == "*" ? "L" : side
        return FaultPose(chains: [["forearm_\(side)", "hand_\(side)", "hand_\(side).tip"]] + (withBar ? [bar] : []),
                         moves: [.turn(pivot: "hand_\(side)", points: ["hand_\(side).tip"], axis: .lateral, degrees: -degrees)],
                         strength: .between("upper_arm_\(s)", "hand_\(s)", from: 0.64, to: 0.8))
    }

    /// Curls stopped short of the top: the forearms held 40° lower than the
    /// lifter's as the curl finishes, a negative turn about `.lateral`
    /// unfolding the elbows (on the Cable Preacher Curl rig the ghost elbows
    /// sit at ~95-102° while the real ones close from 90° to 63°). Shown only
    /// over the last part of the lift: `from`…`to` is shoulder-to-wrist in
    /// torso lengths on the left arm (or `side`), 0.64 with the elbow at 90°
    /// and 0.48 at the preacher models' top (63°), so pass `from: 0.64, to:
    /// 0.5`. Drawn to the wrists only, like `curlArmsOffPad`: at the top the
    /// hand tips would reach up into the top-row label.
    private static func curlStoppedShortOfTop(_ side: String = "*", from: Float, to: Float) -> FaultPose {
        let s = side == "*" ? "L" : side
        return FaultPose(chains: [["upper_arm_\(side)", "forearm_\(side)", "hand_\(side)"]],
                         moves: [.turn(pivot: "forearm_\(side)", points: ["hand_\(side)"], axis: .lateral, degrees: -40)],
                         strength: .between("upper_arm_\(s)", "hand_\(s)", from: from, to: to))
    }

    /// Seated curls on a preacher pad or curl machine: the trunk rocking back
    /// from the hips as the weight comes up, the arms carried off the pad.
    /// `curlSeatedSwungBack` turns the whole `trunk`, both arms and hand tips
    /// included, while it draws only the spine and `side`'s arm to the wrist,
    /// so the ghost left dashed guides from the resting arm and the hand tips
    /// to points with no line; this one moves only what it draws. Both models
    /// sit 12° forward, so 22° ends ~10° behind vertical.
    private static func preacherRockedBack(_ degrees: Float, side: String = "*") -> FaultPose {
        let drawn = ["upper_arm_\(side)", "forearm_\(side)", "hand_\(side)"]
        return FaultPose(chains: [spine, drawn],
                         moves: [.turn(pivot: "pelvis", points: torso + drawn, axis: .lateral, degrees: degrees)],
                         strength: .withBend(elbow(side)))
    }

    /// One-arm curl machine (the left arm works), seat too low:
    /// `curlMachineSatLow` with only the working arm drawn, to the wrist.
    /// The body and shoulders sit 0.1 torso lengths lower while the hand
    /// stays on the handle, so the elbow drops below the lever's pivot (and
    /// into the arm pad, which the ghost ignores; on the rig ~8 cm below and
    /// ~4 cm behind the hub at the bottom, ~5 cm inside the pad, ~2 cm below
    /// and ~5 cm in front of it at the top). The direction follows the
    /// Machine Biceps Curl's piece; no source states it. The free arm rests
    /// on the pad and is left out, and its shoulder does not move, so no
    /// dashed guide starts there. The toes never move, so the legs are drawn
    /// to the ankles only (the near foot sits behind the machine's front
    /// base rail, where a toe line was drawn on the rail).
    private static let leftCurlMachineSatLow = FaultPose(
        chains: [spine, leftArm, ["thigh_*", "shin_*", "foot_*"], hips],
        moves: [.shift(["pelvis", "thigh_*", "upper_arm_L"] + torso, rise: -0.1), .resolve(["forearm_L", "shin_*"])]
    )

    /// `preacherSatLow` with the sink set by `drop` (torso lengths), for a
    /// lifter framed small: on the Barbell Preacher Curl (zoom 0.602) the
    /// shared 0.2 sink left the shoulders' V only ~9 pt deep; 0.28 about
    /// doubles it (the trunk moves ~58 px instead of ~42 px at 764 wide).
    /// The arms stay hooked over the pad and the knees re-seat, as there.
    private static func preacherSatLower(_ drop: Float) -> FaultPose {
        FaultPose(chains: [spine, shoulders, ["thigh_*", "shin_*", "foot_*"], hips],
                  moves: [.shift(["pelvis", "thigh_*"] + torso, rise: -drop), .resolve(["shin_*"])])
    }

    // MARK: Batch 241-300 standing cable curl pieces (2026-09-27)

    /// Neutral-grip (hammer) curls: the wrists bent back, the knuckles
    /// tipping out to the sides. With the palms facing in, the backs of the
    /// hands face out, so the bend is sideways. The turn is about the body's
    /// up axis: it swings the forward-pointing part of each hand outward (a
    /// negative turn is outward on both sides) and leaves a hand hanging
    /// straight down alone, so the ghost never bends the wrong way on the way
    /// up, as a turn about `.forward` would once the forearm passes level.
    /// Grows with the left elbow's bend: strongest from mid-rep to the top.
    private static let hammerWristsBentBack = FaultPose(
        chains: [["forearm_*", "hand_*", "hand_*.tip"]],
        moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .up, degrees: -45)],
        strength: .withBend("forearm_L")
    )

    /// Curls with the upper arms held out to the sides (the high cable curl):
    /// the wrists curling in toward the palms. The palms face up with the
    /// arms out and toward the head at the top, so the fold lies in the plane
    /// the forearms curl in, about the chest's axis: a positive turn tips a
    /// hand pointing out to the side up, and one pointing up in toward the
    /// head (`curlWristsCurled` turns about `.lateral`, for arms by the
    /// sides). Grows with the left elbow's bend: strongest at the top.
    private static let armsOutWristsCurled = FaultPose(
        chains: [["forearm_*", "hand_*", "hand_*.tip"]],
        moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .forward, degrees: 50)],
        strength: .withBend("forearm_L")
    )

    /// Standing curls seen side-on: `bodySwung(withBar: false)` (the hips
    /// 0.06 ahead, the trunk 15° back from them) drawn with one arm, `side`,
    /// and only the drawn points move, so the other arm gets no dashed
    /// guides. Side-on, the other arm's ghost crossed the leaned spine and the
    /// drawn arm: the free arm's hand-on-hip triangle on the one-arm curl,
    /// a second offset V on the hammer curl. Grows with the left elbow's
    /// bend, as `bodySwung` does.
    private static func bodySwungOneArm(_ side: String) -> FaultPose {
        FaultPose(chains: [spine, arm(side), hips],
                  moves: [.shift(["pelvis", "thigh_*"], ahead: 0.06),
                          .turn(pivot: "pelvis", points: torso + arm(side), axis: .lateral, degrees: 15)],
                  strength: .withBend("forearm_L"))
    }

    // MARK: Batch 241-300 drag, spider and hammer curl pieces (2026-09-27)

    /// Drag curls: how much of a fault of the top of the rep shows, read from
    /// the left shoulder-to-wrist distance in torso lengths: none at 0.75
    /// (elbow ~112°), all of it by 0.5 (~67°); the top of these models is
    /// 0.42. The elbow bend alone would already show half of it with the bar
    /// at the thighs, where the drag curl models start at ~138°.
    private static let dragTop = FaultStrength.between("upper_arm_L", "hand_L", from: 0.75, to: 0.5)

    /// Drag curls: the bar shrugged the last few centimetres like an upright
    /// row, the shoulders, arms and grip lifted 0.12 torso lengths (~7 cm)
    /// toward the ears near the top (`shouldersLowered` run upward).
    private static func dragShrugged(withBar: Bool) -> FaultPose {
        shouldersLowered(-0.12, withBar: withBar, strength: dragTop)
    }

    /// Drag curls: the wrists curling in at the top, `curlWristsCurled`'s
    /// fold toward the palm (50° unless a model framed small needs a deeper
    /// one to read), read by `dragTop` rather than the elbow bend.
    private static func dragWristsCurled(_ degrees: Float = 50) -> FaultPose {
        FaultPose(
            chains: [["forearm_*", "hand_*", "hand_*.tip"], bar],
            moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .lateral, degrees: degrees)],
            strength: dragTop
        )
    }

    /// Drag curls cut short at the bottom: the bar turns round at the
    /// stomach, still on the body. The upper arms stay 18° further back and
    /// the elbows 43° more bent, so the models' ~138° bottom becomes ~95°,
    /// their own pose about a third of the way up (the ghost bar ~14 cm
    /// higher, still against the body). Shown only near the
    /// bottom: `from`…`to` is the left shoulder-to-wrist distance in torso
    /// lengths (0.848 at the models' bottom, 0.73 at ~108°).
    private static func dragCurlShort(from: Float, to: Float) -> FaultPose {
        FaultPose(chains: [armsToGrip, bar],
                  moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -18),
                          .turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: 43)],
                  strength: .between("upper_arm_L", "hand_L", from: from, to: to))
    }

    /// Drag curls: `bodySwung`'s moves (hips 0.06 forward, trunk and arms 15°
    /// back about the pelvis), growing from the models' bottom (shoulder to
    /// wrist 0.84 torso lengths, elbows ~138°) to all of it by 0.6 (~83°).
    /// `bodySwung` reads the elbow bend, which would already show ~0.47 of
    /// the lean with the bar still at the thighs, since these models never
    /// straighten the elbows. Drawn as the spine, the hips and the arm nearer
    /// the camera (`side`): seen side-on, the far arm lies beside the near
    /// one, its upper arm running down next to the spine and its forearm
    /// doubling the near one, and the bar is end-on, a stub.
    private static func dragSwung(near side: String) -> FaultPose {
        FaultPose(chains: [spine, arm(side), hips],
                  moves: [.shift(["pelvis", "thigh_*"], ahead: 0.06),
                          .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 15)],
                  strength: .between("upper_arm_L", "hand_L", from: 0.84, to: 0.6))
    }

    /// Spider curls: the shoulders shrugging up the pad toward the ears (0.18
    /// torso lengths, ~10.6 cm, ending above the neck), drawn as the girdle
    /// and upper arms only so no forearm crosses the shoulder line. The
    /// Spider Curl's inline shrug, pulled out unchanged so the dumbbell and
    /// EZ bar spider curls share it.
    private static let spiderShrugged = FaultPose(
        chains: [shoulders, ["upper_arm_*", "forearm_*"]],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.18)]
    )

    /// Spider curls: `trunkLifted(18)` (chest and shoulders heaving 18° up off
    /// the pad about the pelvis, the arms riding with it), drawn as the spine
    /// and the near (left) arm only. Side-on with the arms curled, the two arm
    /// chains cross each other and the lifted spine; the far arm is behind the
    /// torso and pad in the trainer view anyway.
    private static let spiderPadLifted = FaultPose(
        chains: [spine, ["upper_arm_L", "forearm_L", "hand_L"]],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 18)]
    )

    /// Hammer curls (palm facing in): the left wrist bending in toward the
    /// palm, the fingers tipping toward the midline, with the left elbow bend.
    /// With the palm facing the body a fold toward the palm is a turn about
    /// the lifter's vertical; `.lateral` would tip the thumb side up instead.
    /// 55° about `.up` bends the hand ~47° with the forearm level and ~39°
    /// at the top, where the forearm is ~45° up.
    private static let hammerWristBent = FaultPose(
        chains: [["forearm_L", "hand_L", "hand_L.tip"]],
        moves: [.turn(pivot: "hand_L", points: ["hand_L.tip"], axis: .up, degrees: 55)],
        strength: .withBend("forearm_L")
    )

    /// Alternating hammer curl: `hunched()` (both shoulders and arms 0.07
    /// forward, 0.1 up) drawn as the girdle and upper arms only, like
    /// `spiderShrugged`: at the top of either curl the working forearm runs
    /// up across the chest to the other shoulder, and its line outweighs the
    /// raised girdle the fault is about.
    private static let hammerHunched = FaultPose(
        chains: [shoulders, ["upper_arm_*", "forearm_*"]],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], forward: 0.07, up: 0.1)]
    )

    /// Alternating hammer curl: `bodySwung`'s moves (hips 0.06 forward, trunk
    /// and arms 15° back about the pelvis), shown as the hands spread apart
    /// while one dumbbell rises (1.075 torso lengths with both arms down, 0.97
    /// mid-curl, 1.155 at the top of either curl). Drawn as the spine, girdle,
    /// upper arms and hips: drawn to the hands, the working forearm crosses
    /// the resting upper arm over the chest.
    private static let hammerSwung = FaultPose(
        chains: [spine, shoulders, ["upper_arm_*", "forearm_*"], hips],
        moves: [.shift(["pelvis", "thigh_*"], ahead: 0.06),
                .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 15)],
        strength: .between("hand_L", "hand_R", from: 1.09, to: 1.15)
    )

    // MARK: Batch 241-300 wrist curl pieces (2026-09-27)

    /// Seated wrist, reverse wrist and finger curls, forearms along the
    /// thighs: where the hands are in their arc, read as the middle of the
    /// left palm's distance from the left knee, in torso lengths. It is
    /// 0.12-0.18 with the hands hanging low at the bottom (palms-up curls
    /// 0.12, palms-down 0.16, the finger curl 0.18 with the bar in the
    /// fingertips), 0.28 with the hands in line with the forearms, about
    /// 0.34 as they pass level and 0.37-0.40 with them curled up at the top,
    /// in all six seated models. `wristCurlLow` shows a fault only near the
    /// bottom; `wristCurlHigh` fades in once the hands rise ~3° above the
    /// forearm line, about 60% shown as they pass level, in full from ~14°
    /// above level, so a hand turned 35° lower never dips below the forearm
    /// line on the way up or down (at 0.28-0.36 it dipped ~4° mid-rep). The
    /// palm point is in every chain drawn with them, so the ghost solves it.
    private static let wristCurlLow = FaultStrength.between("hand_L.tip", "shin_L", from: 0.27, to: 0.18)
    private static let wristCurlHigh = FaultStrength.between("hand_L.tip", "shin_L", from: 0.29, to: 0.37)

    /// Palms-up wrist curl cut short at the bottom: all of it with the hands
    /// hanging at the bottom (0.124), none once they rise past ~31° below
    /// level (0.257). Fitted on the rig so the 40° ghost holds at ~31° below
    /// level until the lifter's hands pass it, rather than rising with them
    /// and falling back as `wristCurlLow` (full to 0.18, ~56° below) made it.
    private static let wristCurlBottomShort = FaultStrength.between("hand_L.tip", "shin_L", from: 0.257, to: 0.124)

    /// Wrist curls: the hands turned about the wrists, the forearms left on
    /// the thighs. A positive turn raises the fingers (the wrist curled up
    /// on a palms-up curl, bent up on a palms-down one; on the standing
    /// behind-the-back curl, where the hands hang, it tips them forward, out
    /// of the curl), a negative one lowers them: a rep cut short at either
    /// end, with the matching strength.
    private static func wristCurlHandsTurned(_ degrees: Float, withBar: Bool = false,
                                             strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [["forearm_*", "hand_*", "hand_*.tip"]] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .lateral, degrees: degrees)],
                  strength: strength)
    }

    /// Seated wrist curls: the forearms lifting off the thighs, turned up
    /// about the elbows with the hands carried along (`elbowsFolded`'s turn,
    /// with the bar drawn). 22° brings the models' forearms from 23° below
    /// level to level and the wrists up ~9 cm. Drawn from the elbows: the
    /// upper arms do not move, and seen from the side the far one crossed
    /// the near hand and bar.
    private static func wristCurlForearmsLifted(_ degrees: Float, withBar: Bool = false,
                                                strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [["forearm_*", "hand_*", "hand_*.tip"]] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: degrees)],
                  strength: strength)
    }

    /// Seated wrist curls: the forearms resting too far back along the
    /// thighs, the wrists on them instead of just past the knees. Elbows,
    /// wrists and hands slide ~8 cm back and up the thighs' 15° slope, so at
    /// the bottom the hanging hands reach down into the legs; drawn from the
    /// elbows, since the upper arms could only follow with a change of trunk
    /// angle.
    private static func wristCurlOnThighs(withBar: Bool = false) -> FaultPose {
        FaultPose(chains: [["forearm_*", "hand_*", "hand_*.tip"]] + (withBar ? [bar] : []),
                  moves: [.shift(["forearm_*", "hand_*", "hand_*.tip"], ahead: -0.135, rise: 0.036)])
    }

    /// Seated wrist curls: the grip loosening at the bottom, the handle
    /// slipping ~6 cm on down the hanging hands toward the fingertips (the
    /// palm point pushed ~70° below level, along the models' hands, which
    /// hang 61-72° below level there, from 11.8 cm to ~17.7 cm past the
    /// wrist: at the finger joints, inside the open fingers' ~19 cm). The
    /// slipped handle is drawn as a dot (or the bar) of its own, not joined
    /// to the wrist, so it reads as the handle moving rather than a longer
    /// hand, with the guide from the palm showing how far. Use with
    /// `wristCurlLow`.
    private static func wristCurlGripSlipping(withBar: Bool = false, strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [["forearm_*", "hand_*"], ["hand_*.tip"]] + (withBar ? [bar] : []),
                  moves: [.shift(["hand_*.tip"], ahead: 0.035, rise: -0.095)],
                  strength: strength)
    }

    /// Seated wrist curls: the trunk rocking back `degrees` from the hips,
    /// the arms, grip and any bar carried with it (`trunkLifted`'s turn,
    /// drawn out to the palm points, which it also moves, so no guide is
    /// left without a line), on the top's ramp (`wristCurlHigh`), rising
    /// with the load as the copy's "as the dumbbells come up" says; shown
    /// throughout, the ghost sat too upright at the bottom rather than
    /// rocking. The ramp reads the lifter's own palm point, not the moved
    /// one.
    private static func wristCurlTrunkLifted(_ degrees: Float, withBar: Bool = false,
                                             strength: FaultStrength = .always) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: degrees)],
                  strength: strength)
    }

    /// Behind-the-back wrist curl: how far the wrists have curled the bar up
    /// behind the hips, read as the middle of the left palm's distance from
    /// the left knee in torso lengths (0.69 hanging at the bottom, 0.82
    /// curled at the top).
    private static let behindWristCurlTop = FaultStrength.between("hand_L.tip", "shin_L", from: 0.72, to: 0.80)

    /// Behind-the-back wrist curl: the shoulders shrugging up as the bar
    /// rises (`shrugged`'s lift, 0.12 torso lengths, ~7 cm), the arms, grip
    /// and bar carried up with them, on the curl's own strength.
    private static let behindWristCurlShrugged = FaultPose(
        chains: [shoulders, armsToGrip, bar],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], up: 0.12)],
        strength: behindWristCurlTop
    )

    /// Behind-the-back wrist curl: the elbows driving back `back`° and bending
    /// `bend`° to pull the bar up behind the hips as the wrists curl
    /// (`shrugRowed`'s moves on the curl's own strength). On the rig 30° and
    /// 50° raise the wrists ~7 cm and keep the grip ~25 cm behind the pelvis.
    private static func behindWristCurlRowed(back: Float, bend: Float) -> FaultPose {
        FaultPose(chains: [armsToGrip, bar],
                  moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -back),
                          .turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: bend)],
                  strength: behindWristCurlTop)
    }

    /// Standing with straight arms: the knees dipping to bounce the bar up,
    /// the hips and everything they carry sinking 0.1 torso lengths (~6 cm)
    /// and the knees re-seated (174° to ~136°, ~13 cm forward on the rig).
    /// `pressKneesDipped`'s moves, shown throughout: that piece fades with
    /// elbow bend, and these arms stay straight.
    private static let behindWristCurlKneesDipped = FaultPose(
        chains: [spine, legs, hips, armsToGrip, bar],
        moves: [.shift(carried, rise: -0.1), .resolve(["shin_*"])]
    )

    // MARK: Batch 241-300 grip hold pieces (2026-09-27)

    /// Grip holds: the wrists curling toward the palms as the grip tires,
    /// which leaves the finger flexors short and weak. A negative `degrees`
    /// folds each hand toward its palm: about `.forward` for hands hanging
    /// palms-in at the sides (dumbbells), which tip in toward the thighs;
    /// about `.lateral` for a bar held palms-back in front, where the grip
    /// swings back toward the thighs, and for fists gripping towels overhead
    /// palms-forward, which tip forward. Only the forearms and hands are
    /// drawn: a bar drawn between the tips moves back along its own length
    /// in the barbell's -0.8 view, so it reads as the bar sliding sideways.
    /// Not for the Plate Pinch Hold: its plates rest on the outer thighs, and
    /// turning them about `.forward` would swing their lower edges about
    /// 20 cm into the legs.
    private static func holdWristsCurled(_ axis: BodyAxis, _ degrees: Float) -> FaultPose {
        FaultPose(chains: [["forearm_*", "hand_*", "hand_*.tip"]],
                  moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: axis, degrees: degrees)])
    }

    /// Standing holds: the load dragging the shoulders forward and down and
    /// rounding the upper back, the arms and grip hanging from them — the
    /// Farmer's Carry slump, drawn to the grip so a bar rides along.
    private static func holdSlumped(withBar: Bool = false) -> FaultPose {
        FaultPose(chains: [spine, shoulders, armsToGrip] + (withBar ? [bar] : []),
                  moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], forward: 0.13, up: -0.06, outward: -0.03),
                          .shift(["chest"], forward: -0.07),
                          .shift(["neck", "head"], forward: 0.09, up: -0.03)])
    }

    /// Standing holds, leaning forward over the load: the trunk tips forward
    /// from the hips (`leanedForward`'s turn) while the arms keep hanging
    /// straight down from the shoulders, so the load comes forward under
    /// them. `leanedForward` turns the arms with the trunk: on the Plate Pinch
    /// and Dumbbell Static Hold models 10° took the shoulders 9.1 cm forward
    /// and the grip 2 cm back, the arms 10° behind vertical. Here the grip
    /// goes 9.1 cm forward with the shoulders and the arms keep their angle
    /// (the same counter-turn as `barRestedOnThighs`).
    private static func holdLeanedForward(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip],
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -degrees),
                          .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: degrees)])
    }

    /// A barbell held in front: the hips pushed 6 cm forward and the trunk
    /// leaning back (~14° behind vertical) so the bar rests on the thighs.
    /// The arms keep hanging as they were from the shoulders, which go back
    /// with the trunk: on the Barbell Static Hold model the bar (3.5-5 cm off
    /// the thighs, just below the hip crease) comes back ~7 cm, so the ghost
    /// bar is drawn on the lifter's own thighs. Turning the arms with the
    /// trunk instead (the Trap Bar Shrug's posture moves) lifts the bar 3 cm
    /// and carries it forward with the hips, so over the real lifter it would
    /// not read as coming back onto the legs.
    private static let barRestedOnThighs = FaultPose(
        chains: [spine, armsToGrip, hips, legs, bar],
        moves: [.shift(["pelvis", "thigh_*"], ahead: 0.1),
                .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 8),
                .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -8),
                .resolve(["shin_*"])]
    )

    /// Hanging from towels: the elbows bending into a half pull-up, the body
    /// rising 0.12 torso lengths (7 cm) under hands that stay on the towels.
    /// On the Towel Grip Hold model the elbows bend from 168° to ~119°,
    /// flaring out the way they already point.
    private static let hangPulledUp = FaultPose(
        chains: [spine, arms, legs, hips],
        moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip", "upper_arm_*"] + torso, rise: 0.12),
                .resolve(["forearm_*"])]
    )

    /// Hanging with the knees bent and the shins pointing back: the shins
    /// swing down about the knees. On the Towel Grip Hold model 11° brings
    /// the ankles ~7 cm lower and the toe tips (the shoes are ~6 cm clear) to
    /// the floor.
    private static func hangToesDown(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [legs, hips],
                  moves: [.turn(pivot: "shin_*", points: ["foot_*", "foot_*.tip"], axis: .lateral, degrees: degrees)])
    }

    /// Hanging: the whole body swinging forward under the hands, which stay
    /// where they grip. The lateral axis through `hand_L` also passes through
    /// `hand_R` on a level, square grip, so both hands stay put. On the Towel
    /// Grip Hold model 10° brings the knees ~27 cm forward, the hips ~19 cm
    /// and the head ~7 cm, keeps the elbows as they are and the toe tips
    /// ~5 cm off the floor (`kipping` there would put them ~8 cm through it).
    private static func hangSwung(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, arms, legs, hips],
                  moves: [.turn(pivot: "hand_L",
                                points: ["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip", "upper_arm_*", "forearm_*"] + torso,
                                axis: .lateral, degrees: degrees)])
    }

    /// Standing holds, looking down at the load: the upper back rounds and
    /// the head bows forward and down about the neck, its length kept (the
    /// Farmer's Carry "head" moves): the head point ~12 cm forward and ~6 cm
    /// lower on the grip-hold models (`headDropped` there pushes it ~11 cm
    /// straight forward and stretches the neck).
    private static let lookingDown = FaultPose(
        chains: [spine],
        moves: [.shift(["chest"], forward: -0.06),
                .shift(["neck", "head"], forward: 0.07, up: -0.03),
                .turn(pivot: "neck", points: ["head"], axis: .lateral, degrees: -55)]
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

    /// Hands (or the bar) held wider than shoulder-width: the hands `hands`
    /// torso lengths out and the elbows `forearms` (the defaults everywhere
    /// else).
    private static func gripTooWide(withBar: Bool, hands: Float = 0.13, forearms: Float = 0.08) -> FaultPose {
        FaultPose(
            chains: [armsToGrip] + (withBar ? [bar] : []),
            moves: [.shift(["hand_*", "hand_*.tip"], outward: hands), .shift(["forearm_*"], outward: forearms)]
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

    /// Seated pulldowns: loose under the thigh pads, the lifter pulled up off
    /// the seat. The hips and trunk lift 0.18 torso lengths (~11 cm) and the
    /// knees re-seat over the planted feet. Drawn as the spine, hips and legs
    /// to the ankles, no arms or bar. Framed from behind, `slidForward`'s
    /// forward move ran almost along the line of sight and the ghost legs lay
    /// on the real ones; a rise shows from any side.
    private static let risenOffSeat = FaultPose(
        chains: [spine, ["thigh_*", "shin_*", "foot_*"], hips],
        moves: [.shift(["pelvis", "thigh_*"] + torso, rise: 0.18), .resolve(["shin_*"])]
    )

    /// Hands never reaching the stretch: they stay short of full extension.
    private static let rangeCutShort = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.14), .shift(["forearm_*"], forward: -0.06)]
    )

    /// Seated machine press cut short: the hands stop well short of full
    /// extension with the elbows still bent (re-seated between the shoulder
    /// and the hand, so the arms keep their length). A fault of the lockout,
    /// so it grows as the elbows straighten instead of pulling the hands back
    /// past the chest at the bottom of the rep, as `rangeCutShort` does.
    private static let pressCutShort = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.2), .resolve(["forearm_*"])],
        strength: .whenStraight("forearm_L")
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

    /// A bridge's ribs flaring: the lower back arches the hips higher, the
    /// lumbar spine lifted `rise` torso lengths and the chest `chest`.
    private static func bridgeArched(_ rise: Float = 0.09, chest: Float = 0.04) -> FaultPose {
        FaultPose(chains: [spine],
                  moves: [.shift(["spine"], rise: rise), .shift(["chest"], rise: chest)],
                  strength: .whenStraight("thigh_L"))
    }

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

    // MARK: 30-leg set pieces (2026-09-28)
    // MARK: 30-leg set barbell squat pieces (2026-09-28)

    /// Box squat: relaxing on the box. The brace lets go: the lower back
    /// rounds (the middle of the spine sinks back ~3.5 cm) and the trunk rocks
    /// back 18° about the hips, the bar and arms with it — from the model's
    /// 44° lean on the box to ~26°. Full while seated (knees ~84°).
    private static let barbellBoxRockedBack = FaultPose(
        chains: [spine, armsToGrip, bar],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 18),
                .shift(["spine"], forward: -0.06), .shift(["chest"], forward: -0.02)],
        strength: .withBend("shin_L")
    )

    /// Box squat: squatting straight down instead of sitting back. The hips
    /// and all they carry come ~12 cm forward (level), the trunk 12° more
    /// upright, and both knees re-seat further forward over the feet: the
    /// pelvis ends ~21 cm behind the ankles instead of ~33 cm, over the box's
    /// front edge (~18 cm behind the ankles).
    private static let barbellBoxKneesForward = FaultPose(
        chains: [spine, armsToGrip, legs, hips, bar],
        moves: [.shift(carried, ahead: 0.2),
                .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 12),
                .resolve(["shin_*"])],
        strength: .withBend("shin_L")
    )

    /// Safety bar squat: the handles held loosely out in front. The hands
    /// move ~12 cm further ahead and ~5 cm up (level and vertical) and the
    /// elbows re-seat ~14 cm further forward (at the bottom on the rig), so
    /// the upper arms lift forward and the arms reach out.
    private static let barbellHandlesPushedAway = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], ahead: 0.2, rise: 0.08),
                .resolve(["forearm_*"])]
    )

    /// Zercher squat: the arms sagging away from the body. The trunk tips 8°
    /// forward after the load; the upper arms swing 15° forward about the
    /// shoulders, so the elbows, where the bar sits, move ~10 cm ahead and
    /// ~2 cm lower (at the bottom on the rig; ~7 cm further from the chest),
    /// and the forearms open 30° about the elbows (46° -> ~72°), the clasped
    /// hands dropping ~8 cm and moving ~17 cm ahead. Rigid turns only, so the
    /// arm lengths hold. No bar line: the hands are clasped, so a line
    /// between them would not be the bar. Grows with the knees.
    private static let barbellZercherArmsSagging = FaultPose(
        chains: [spine, armsToGrip],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -8),
                .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: 15),
                .turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: -30)],
        strength: .withBend("shin_L")
    )

    /// Overhead squat: the elbows softening. The hands and bar sink ~11 cm
    /// along the trunk (~10 cm lower at the bottom on the rig) and the
    /// elbows re-seat, bending the way they already bend slightly (~170° on
    /// the model): they come ~11 cm forward.
    private static let barbellOverheadElbowsBent = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["hand_*", "hand_*.tip"], up: -0.18), .resolve(["forearm_*"])]
    )

    /// Landmine squat: the handle drifting away from the chest. The trunk
    /// tips 8° forward after the load and the hands move ~18 cm further
    /// ahead (level): ~24 cm ahead and ~5 cm lower in all at the bottom on
    /// the rig, the elbows re-seated as the arms open. No bar line: the
    /// hands share one short handle. Grows with the knees.
    private static let barbellLandmineHandleAway = FaultPose(
        chains: [spine, armsToGrip],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -8),
                .shift(["hand_*", "hand_*.tip"], ahead: 0.3),
                .resolve(["forearm_*"])],
        strength: .withBend("shin_L")
    )
    // MARK: 30-leg set calf raise pieces (2026-09-28)

    /// Calf raises: how far the heels are up, read off the distance from the
    /// knee to the toe tips. The shin and foot keep their lengths, so that
    /// distance depends on the ankle angle alone: 0.82-0.87 torso lengths with
    /// the heels at their lowest in these five models (ankle 98-108°), 0.98-1.02
    /// at their highest (ankle 138-148°). `from` below `to` grows the fault
    /// toward the top of the rep, `from` above `to` toward the bottom.
    private static func calfHeelHeight(from: Float, to: Float) -> FaultStrength {
        .between("shin_L", "foot_L.tip", from: from, to: to)
    }

    /// The single-leg calf raise's body above the working (left) ankle: the
    /// hips, trunk, head, both upper arms, the left arm with its dumbbell and
    /// the bent right leg hanging behind. The right hand stays on the fixed
    /// balance handle, so its elbow is re-seated rather than carried.
    private static let calfOneLegBody = ["pelvis", "thigh_*", "spine", "chest", "neck", "head",
                                         "upper_arm_*", "forearm_L", "hand_L", "hand_L.tip",
                                         "shin_R", "foot_R", "foot_R.tip"]

    /// Standing calf raises: stopping partway up. The heels sit 20° lower about
    /// the planted toes (on the rig at the top, 1.5 s: ankle ~139° -> ~117°,
    /// about half the rise) and the body drops with them, ~6 cm, and `back`
    /// torso lengths back with the ankles (0.08, ~5 cm; 0 under a Smith bar,
    /// whose track holds the shoulders over the same line); the knees
    /// re-seat. Full once the heels are nearly at the top, none below
    /// mid-rise. `body` is what rides on the ankles: `carried` on two legs,
    /// `calfOneLegBody` on one.
    private static func calfStoppedShortOfTop(_ side: String = "*", body: [String], back: Float = 0.08,
                                              reseat extra: [String] = []) -> FaultPose {
        FaultPose(chains: [leg(side), hips, spine],
                  moves: [.turn(pivot: "foot_\(side).tip", points: ["foot_\(side)"], axis: .lateral, degrees: 20),
                          .shift(["shin_\(side)"] + body, ahead: -back, rise: -0.105),
                          .resolve(["shin_\(side)"] + extra)],
                  strength: calfHeelHeight(from: 0.9, to: 0.97))
    }

    /// Standing calf raises: the heels never coming back down. At the bottom
    /// the heels stay 22° up about the planted toes (ankle ~99° -> ~120°, about
    /// half the rise) and the body stays ~8 cm higher, `forward` torso lengths
    /// ahead with the ankles (0.06, ~4 cm; 0 under a Smith bar); the knees
    /// re-seat. Full with the heels at their lowest, gone by mid-rise.
    private static func calfHeelsLeftHigh(_ side: String = "*", body: [String], forward: Float = 0.06,
                                          reseat extra: [String] = []) -> FaultPose {
        FaultPose(chains: [leg(side), hips, spine],
                  moves: [.turn(pivot: "foot_\(side).tip", points: ["foot_\(side)"], axis: .lateral, degrees: -22),
                          .shift(["shin_\(side)"] + body, ahead: forward, rise: 0.13),
                          .resolve(["shin_\(side)"] + extra)],
                  strength: calfHeelHeight(from: 0.9, to: 0.86))
    }

    /// Standing calf raises: dipping at the knees at the bottom to bounce the
    /// load up with the thighs. The body drops ~4 cm over the planted feet and
    /// the knees re-seat forward (172° -> ~142°, the knee ~10 cm further
    /// forward). Full with the heels at their lowest.
    private static func calfKneesDipped(_ side: String = "*", body: [String], reseat extra: [String] = []) -> FaultPose {
        FaultPose(chains: [leg(side), hips, spine],
                  moves: [.shift(body, rise: -0.07),
                          .resolve(["shin_\(side)"] + extra)],
                  strength: calfHeelHeight(from: 0.9, to: 0.86))
    }

    /// Standing machine and Smith calf raises: the hips pushed back under
    /// shoulders held by the pads or the bar. The pelvis goes ~12 cm back and
    /// ~3 cm down, the middle of the spine half as far, the chest and
    /// shoulders stay, so the trunk tips ~10° forward; the knees re-seat
    /// (172° -> ~152-157°). The same all rep.
    private static let calfHipsBack = FaultPose(
        chains: [spine, legs, hips],
        moves: [.shift(["pelvis", "thigh_*"], ahead: -0.2, rise: -0.05),
                .shift(["spine"], ahead: -0.1, rise: -0.025),
                .resolve(["shin_*"])]
    )

    /// Seated calf raise: stopping partway up. The heels sit 20° lower about
    /// the planted toes (ankle ~148° -> ~120° at the top); with the hips on
    /// the seat the knees, and the pad on them, sit ~6 cm lower. Full near the
    /// top.
    private static let calfSeatedShortOfTop = FaultPose(
        chains: [legs],
        moves: [.turn(pivot: "foot_*.tip", points: ["foot_*"], axis: .lateral, degrees: 20),
                .resolve(["shin_*"])],
        strength: calfHeelHeight(from: 0.93, to: 1.0)
    )

    /// Seated calf raise: the heels staying up at the bottom (ankle ~103° ->
    /// ~130°), the knees and pad ~8 cm higher. Full at the bottom.
    private static let calfSeatedHeelsLeftHigh = FaultPose(
        chains: [legs],
        moves: [.turn(pivot: "foot_*.tip", points: ["foot_*"], axis: .lateral, degrees: -22),
                .resolve(["shin_*"])],
        strength: calfHeelHeight(from: 0.92, to: 0.87)
    )

    /// Seated calf raise: the feet set ~12 cm further out in front, flat on
    /// the platform, so the shins slope forward and the knees open from ~96°
    /// to ~116° under the pad (the knee itself moves under 2 cm at the
    /// bottom, ~3.5 cm at the top). The same all rep; stilled at the bottom.
    private static let calfSeatedFeetForward = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["foot_*", "foot_*.tip"], ahead: 0.2), .resolve(["shin_*"])]
    )

    /// Leg press calf raise: the sled stopping short. The hips stay on the
    /// seat and the knees hold their angle, so the ankle stays put and the
    /// toes, with the plate, come 20° back toward the shins (~8 cm; ankle
    /// ~148° -> ~129°). Full near the top.
    private static let calfPressShortOfTop = FaultPose(
        chains: [legs],
        moves: [.turn(pivot: "foot_*", points: ["foot_*.tip"], axis: .lateral, degrees: 20)],
        strength: calfHeelHeight(from: 0.95, to: 1.0)
    )

    /// Leg press calf raise: the ankles staying pointed at the bottom, the
    /// toes and plate ~8 cm further out (ankle ~108° -> ~130°). Full at the
    /// bottom.
    private static let calfPressHeelsLeftHigh = FaultPose(
        chains: [legs],
        moves: [.turn(pivot: "foot_*", points: ["foot_*.tip"], axis: .lateral, degrees: -22)],
        strength: calfHeelHeight(from: 0.93, to: 0.875)
    )

    /// Leg press calf raise: the knees bending at the bottom and the sled
    /// sinking toward the lifter. The feet come ~5 cm back along the legs'
    /// line (the lifter's forward axis on this 45° back pad) and the knees
    /// re-seat (170° -> ~140°, the knee ~11 cm lower). Full at the bottom.
    private static let calfPressKneesBent = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["foot_*", "foot_*.tip"], forward: -0.08), .resolve(["shin_*"])],
        strength: calfHeelHeight(from: 0.93, to: 0.875)
    )
    // MARK: 30-leg set machine squat pieces (2026-09-28)

    /// Belt squat: the feet set ahead of the cable, so the cable (and the
    /// hips hanging on it) sits behind the heels. Both feet 0.2 torso lengths
    /// (~12 cm) further ahead along the floor, the knees re-seated between the
    /// same hips and the moved ankles, so the shins stand more upright and the
    /// hips sit back behind the feet. Grows with the knee bend: at the top the
    /// knees are nearly straight (161°) and there is no room to re-seat them.
    private static let machineFeetAheadOfCable = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["foot_*", "foot_*.tip"], ahead: 0.2),
                .resolve(["shin_*"])],
        strength: .withBend("shin_L")
    )

    /// Pendulum and V-squat: the hips and lower back peeling off the back
    /// pad at the bottom, the pelvis tucking under. The pelvis and hips come
    /// 0.12 torso lengths (~7 cm) forward off the pad and the chest 0.02, so
    /// the upper back stays on the pad. The mid-spine (about 45% of the way
    /// from pelvis to chest) moves only 0.03, less than the ~0.075 a
    /// straight line would give, so it sits ~2.7 cm behind the chest-pelvis
    /// line, toward the pad: the lower back bows backward (rounds). The knees
    /// re-seat over the planted feet. Grows with the knee bend.
    private static let machineHipsOffPad = FaultPose(
        chains: [spine, legs, hips],
        moves: [.shift(["pelvis", "thigh_*"], forward: 0.12),
                .shift(["spine"], forward: 0.03),
                .shift(["chest"], forward: 0.02),
                .resolve(["shin_*"])],
        strength: .withBend("shin_L")
    )
    // MARK: 30-leg set leg press pieces (2026-09-28)

    /// 45-degree presses (back pad 60° back from vertical, the footplate's
    /// face 33° back from vertical): the feet set `by` torso lengths lower
    /// down the platform. Down the plate is 0.45 of a step back toward the
    /// chest's side and 0.89 of it toward the feet in the lifter's own axes
    /// (the plate's normal is (0, 0.545, 0.839) in the model, the body's
    /// forward (0, 0.866, 0.5), its up (0, 0.5, -0.866)). The foot then rocks
    /// `heelUp` degrees up about its toes, the heel peeling off, and the knee
    /// re-seats. A setup fault, so it holds all rep (the feet do not slide on
    /// the plate), like pressFeetTogether; the heel lift is kept small because
    /// one FaultPose has one strength and it then shows at the top too. On
    /// the rig (`by` 0.2, `heelUp` 10) the toes sit 12 cm lower on the plate
    /// all rep; at the bottom (1.5 s) the ankle rises ~3.4 cm off the plate
    /// and the knee, moved ~2.5 cm, ends ~6 cm past the toe tips instead of
    /// ~4 cm short of them, closing from 95° to 84°; at the top (0 s) the
    /// shorter hip-to-ankle span (0.83 -> 0.77 m) seats the knee at 133°
    /// instead of 160°, as it would be with the feet that low.
    private static func pressFeetLow(_ side: String = "*", by: Float = 0.2, heelUp: Float = 10) -> FaultPose {
        FaultPose(chains: [leg(side)],
                  moves: [.shift(["foot_\(side)", "foot_\(side).tip"], forward: -0.45 * by, up: -0.89 * by),
                          .turn(pivot: "foot_\(side).tip", points: ["foot_\(side)"], axis: .lateral, degrees: -heelUp),
                          .resolve(["shin_\(side)"])])
    }

    /// Seated and lying presses: lowering past the hips' range, so the hips
    /// curl up off the seat (away from the pad, a little toward the head)
    /// and the lower back rounds; the knees re-seat under the moved hips.
    /// On the vertical press the pad is level, so this lifts the hips
    /// straight up. Grows with the left knee's bend.
    private static let pressHipsCurled = FaultPose(
        chains: [spine, legs, hips],
        moves: [.shift(["pelvis", "thigh_*"], forward: 0.1, up: 0.03),
                .shift(["spine"], forward: 0.05),
                .resolve(["shin_*"])],
        strength: .withBend("shin_L")
    )

    /// Single-leg press with the left leg: the working hip lifting off the
    /// seat at the bottom, the pelvis tilting up on that side while the
    /// resting right hip stays down; the working knee re-seats.
    private static let pressHipLifted = FaultPose(
        chains: [spine, leg("L"), ["thigh_L", "pelvis", "thigh_R"]],
        moves: [.shift(["thigh_L"], forward: 0.14),
                .shift(["pelvis"], forward: 0.07),
                .shift(["spine"], forward: 0.03),
                .resolve(["shin_L"])],
        strength: .withBend("shin_L")
    )

    /// Vertical press: the hands leaving the handles to push on the thighs
    /// just above the knees. On the rig at the bottom (1.5 s) the hands move
    /// from beside the hips to ~85% of the way from hip to knee: 0.30 torso
    /// lengths in toward the midline, 0.46 toward the ceiling (the lying
    /// lifter's forward) and 0.31 toward the head; the elbows re-seat. Grows
    /// with the knee's bend, so it only sits on the thighs at the bottom.
    private static let pressHandsOnKnees = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: 0.46, up: 0.31, outward: -0.3),
                .resolve(["forearm_*"])],
        strength: .withBend("shin_L")
    )

    /// Narrow stance taken too far: the feet ~6 cm in toward the midline on
    /// each side (touching) and the knees crowding in with them. A setup
    /// fault (the feet do not slide on the plate), so it holds all rep, as
    /// the older Leg Press's "feet" fault does.
    private static let pressFeetTogether = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.1), .shift(["shin_*"], outward: -0.1)]
    )

    /// Single-leg press: only the working (left) knee snapped straight; the
    /// resting right leg is bent on its foot rest and must not straighten.
    private static let pressLeftKneeSnapped = FaultPose(
        chains: [leg("L")],
        moves: [.straighten(["shin_L"], past: 0.05)],
        strength: .whenStraight("shin_L")
    )
    // MARK: 30-leg set single-leg and heel-elevated squat pieces (2026-09-28)

    /// Heel-elevated and cyclist squats: sitting the hips back with the shins
    /// kept upright, a flat-footed hip-led squat. The hips and all they carry
    /// go 0.16 torso lengths (~9 cm) back and the trunk tips 15° further; the
    /// knees, re-seated over the planted feet, end ~9 cm further back with
    /// the shins more upright. Grows with the knee's bend.
    private static let singleSatBack = FaultPose(
        chains: [spine, armsToGrip, legs, hips, bar],
        moves: [.shift(carried, ahead: -0.16),
                .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -15),
                .resolve(["shin_*"])],
        strength: .withBend("shin_L")
    )

    /// Cyclist squat: the feet set out wide like a regular squat. Each ankle,
    /// its toes and its knee go 0.14 torso lengths (~8 cm) further out, the
    /// ankles ~0.38 m apart instead of the model's 0.21 m.
    private static let singleStanceWide = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["foot_*", "foot_*.tip", "shin_*"], outward: 0.14)]
    )

    /// Heel-elevated and cyclist squats: stopping halfway. `shallow()`'s
    /// chains and moves, the hips and all they carry held `rise` torso
    /// lengths up (0.3: ~18 cm, the knees ~77° instead of ~50°), but faded by
    /// how deep the hips sit rather than by the knee's bend: these models
    /// never stand up (knee 139° / 135° at the top), so a knee-bend strength
    /// would still show ~46-50% there and lift the hips past a straight leg.
    /// None with the pelvis 1.2 torso lengths or more above the left ankle
    /// (the top is 1.33-1.37), all of it from 0.8 down (the bottom 0.62-0.69).
    private static func singleSquatShallow(_ rise: Float) -> FaultPose {
        FaultPose(chains: [spine, legs, hips, armsToGrip, bar],
                  moves: [.shift(carried, rise: rise), .resolve(["shin_*"])],
                  strength: .between("pelvis", "foot_L", from: 1.2, to: 0.8))
    }

    /// Pistols (left leg standing): how deep the hips sit. None with the
    /// pelvis 1.2 torso lengths or more above the standing ankle (the model's
    /// top is 1.39: its knee stops at 156°, so a knee-bend strength would still
    /// show ~27% there), all of it from 0.8 down (the bottom is 0.54).
    private static let singlePistolDepth = FaultStrength.between("pelvis", "foot_L", from: 1.2, to: 0.8)

    /// A pistol's free (right) leg below the hip.
    private static let singleFreeLeg = ["shin_R", "foot_R", "foot_R.tip"]

    /// The assisted pistol's body without the hands, which stay on the bar:
    /// hips, trunk, head, shoulders and the free leg.
    private static let singleBodyOffBar = ["pelvis", "thigh_*", "spine", "chest", "neck", "head", "upper_arm_*"] + singleFreeLeg

    /// Pistols: the free leg sagging 25° about its hip. At the bottom, where
    /// the model holds it about level with the hips, its heel comes down to
    /// the floor (the ankle ~36 cm lower on the rig).
    private static let singleFreeLegDropped = FaultPose(
        chains: [leg("R"), hips],
        moves: [.turn(pivot: "thigh_R", points: singleFreeLeg, axis: .lateral, degrees: -25)],
        strength: singlePistolDepth
    )

    /// Pistol: the arms dropping and the trunk rocking back at the bottom. The
    /// trunk turns 12° back toward upright and the arms swing 70° down from
    /// reaching forward to hanging by the knee, so nothing reaches forward to
    /// balance the hips behind the foot.
    private static let singleArmsDropped = FaultPose(
        chains: [spine, armsToGrip],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 12),
                .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -70)],
        strength: singlePistolDepth
    )

    /// Pistol: stopping high. The hips, trunk, arms and free leg are held
    /// `rise` torso lengths up (0.4: ~24 cm, the standing knee ~82° instead of
    /// 45°), the standing knee re-seated over the planted foot.
    private static func singlePistolShallow(_ rise: Float) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, leg("L"), leg("R"), hips],
                  moves: [.shift(carried + singleFreeLeg, rise: rise), .resolve(["shin_L"])],
                  strength: singlePistolDepth)
    }

    /// Assisted pistol: stopping high with the hands kept on the bar. The body
    /// and free leg rise as in `singlePistolShallow`, the elbows re-seated
    /// between the raised shoulders and the hands.
    private static func singleAssistedShallow(_ rise: Float) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, leg("L"), leg("R"), hips],
                  moves: [.shift(singleBodyOffBar, rise: rise), .resolve(["forearm_*", "shin_L"])],
                  strength: singlePistolDepth)
    }

    /// Assisted pistol: pulling on the bar to get out of the bottom. The
    /// hips, trunk and free leg are hauled 0.12 torso lengths (~7 cm) up and
    /// ~7 cm in toward the bar and the trunk leans 6° further into it while
    /// the hands stay put, so the shoulders end ~12 cm nearer the bar and the
    /// elbows fold from ~110° to ~77°; the standing knee re-seats (45° to
    /// ~54°).
    private static let singlePulledToBar = FaultPose(
        chains: [spine, armsToGrip, leg("L"), leg("R"), hips],
        moves: [.shift(singleBodyOffBar, ahead: 0.12, rise: 0.12),
                .turn(pivot: "pelvis", points: ["spine", "chest", "neck", "head", "upper_arm_*"], axis: .lateral, degrees: -6),
                .resolve(["forearm_*", "shin_L"])],
        strength: singlePistolDepth
    )
    // MARK: 30-leg set wide-stance pieces (2026-09-28): lateral lunge, Cossack and sumo squats, kettlebell goblet squat

    /// Lifts that shift from side to side (lateral lunge, Cossack squat): the
    /// straight leg bending, its foot sliding `by` torso lengths in toward the
    /// midline and the knee re-seated between the same hip and the moved
    /// ankle, so it folds forward — the weight settling between the feet
    /// instead of over the bent leg. `_bent` / `_straight` follow whichever
    /// knee is bent further, so the ghost switches legs with the reps; it
    /// grows with the bent knee.
    private static func wideStraightLegBent(_ by: Float) -> FaultPose {
        FaultPose(chains: [leg("straight"), hips],
                  moves: [.shift(["foot_straight", "foot_straight.tip"], outward: -by),
                          .resolve(["shin_straight"])],
                  strength: .withBend("shin_bent"))
    }

    /// Lateral lunge: the hips kept forward (still behind the stepping foot)
    /// instead of sitting back. The hips and all they carry sit 0.15 torso lengths
    /// (~9 cm) further forward and the trunk comes 25° more upright, so both
    /// knees re-seat and the bent knee drives forward over the toes. With
    /// its foot fixed, the straight leg also folds (171° -> ~149°) as the
    /// hips come toward it; it is drawn so the ghost's hips stay joined.
    private static let wideHipsForward = FaultPose(
        chains: [spine, arms, leg("bent"), leg("straight"), hips],
        moves: [.shift(carried, ahead: 0.15),
                .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 25),
                .resolve(["shin_bent", "shin_straight"])],
        strength: .withBend("shin_bent")
    )

    /// Side-to-side lifts stopping high: `shallow` with the strength read
    /// from whichever knee is bent (the left knee is straight in rep 2), both
    /// legs drawn and re-seated under the raised hips.
    private static func wideSideShallow(_ rise: Float) -> FaultPose {
        FaultPose(chains: [spine, arms, leg("bent"), leg("straight"), hips],
                  moves: [.shift(carried, rise: rise), .resolve(["shin_bent", "shin_straight"])],
                  strength: .withBend("shin_bent"))
    }

    /// Wide stances: the toes turned to point straight ahead. Each foot's toes
    /// swing about its ankle toward the front (35°, the sumo models' toe-out)
    /// while the knees stay out, so the ghost shows the feet no longer under
    /// the knees. The same at every moment.
    private static let wideToesForward = FaultPose(
        chains: [legs],
        moves: [.turn(pivot: "foot_*", points: ["foot_*.tip"], axis: .up, degrees: 35)]
    )

    /// Goblet squat with a kettlebell: the bell sagging down and away from
    /// the chest, the trunk tipping 8° after it (the library Goblet Squat's
    /// hold fault). Grows with the knees.
    private static let wideBellSagging = FaultPose(
        chains: [spine, armsToGrip],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -8),
                .shift(["hand_*", "hand_*.tip"], forward: 0.1, up: -0.18),
                .resolve(["forearm_*"])],
        strength: .withBend("shin_L")
    )

    // BEGIN Redone 190-280 (2026-09-30) pieces
    // MARK: Redone 190-280: Machine Preacher Curl pieces (2026-09-30)

    /// Curl machine, seat too low, both arms: `curlMachineSatLow` with the
    /// legs drawn to the ankles, as `leftCurlMachineSatLow` does for one arm.
    /// The body and upper arms sit 0.1 torso lengths lower while the hands
    /// stay on the handle, so the elbows drop below the lever's pivots (on
    /// the Machine Preacher Curl's rig ~8 cm below and ~2.5 cm behind the
    /// hubs at the bottom, ~1 cm under the pad's front underside, so the
    /// ghost upper arms pass through the pad, which the ghost ignores; ~1 cm
    /// below and ~4 cm in front at the top). The direction follows the
    /// Machine Biceps Curl's piece; no source states it. The toes never move,
    /// and from the -0.5 side view the near foot sits behind the machine's
    /// base rail, where `curlMachineSatLow`'s toe line was drawn on the rail.
    private static let curlMachineSatLowToAnkles = FaultPose(
        chains: [spine, arms, ["thigh_*", "shin_*", "foot_*"], hips],
        moves: [.shift(["pelvis", "thigh_*", "upper_arm_*"] + torso, rise: -0.1), .resolve(["forearm_*", "shin_*"])]
    )
    // END Redone 190-280 (2026-09-30) pieces
    // BEGIN 351-400 (2026-09-30) pieces
    // MARK: 351-400 hinge family pieces (2026-09-30)

    /// Good mornings: how far the trunk has tipped, from the neck's distance
    /// to the left knee in torso lengths. The hip's own bend cannot be used:
    /// in these rigs the spine-hip-knee angle already reads ~146° standing
    /// (~34° of "bend", ~38% of a `.withBend("thigh_L")` fault at the top)
    /// and ~122° seated upright. Standing: 1.76 at the top, 1.28 at the
    /// bottom; seated: 1.47 and 0.90; Smith: 1.76 and 1.35. Each is none
    /// standing or sitting tall, all of it from just above the bottom.
    private static let hingeGMLean = FaultStrength.between("neck", "shin_L", from: 1.72, to: 1.30)
    private static let hingeSeatedLean = FaultStrength.between("neck", "shin_L", from: 1.40, to: 0.95)
    private static let hingeSmithLean = FaultStrength.between("neck", "shin_L", from: 1.72, to: 1.38)

    /// Good mornings: the bar set low on the back of the shoulders. The hands
    /// (the bar between them) sit 0.12 torso lengths (~7 cm) further down the
    /// back and a little behind it, the elbows re-seated; the same all rep.
    /// Only the arms and bar are drawn: the spine does not move, and drawn
    /// over the back it buried the ~12 px shift of the hands side-on.
    private static let hingeGMBarLow = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.03, up: -0.12), .resolve(["forearm_*"])]
    )

    /// Smith good morning: the bar set low on the back under the fixed track.
    /// `barLowOnTrack`'s moves grown with the lean instead of the knee, which
    /// bends only 16-30° in this model, and with the hips taken back only
    /// 0.03 torso lengths (~2 cm) instead of 0.13: on this rig that is what
    /// keeps the bar on its line (within ~1.3 cm through the rep; with 0.13
    /// it ended 6 cm behind it). At the bottom the hands sit ~6 cm lower on
    /// the back and the bar ~10 cm lower on the rails, the chest tipped 10°
    /// further, the knees re-seated at ~153°.
    private static let hingeSmithBarLow = FaultPose(
        chains: [spine, armsToGrip, legs, hips, bar],
        moves: [.shift(carried, ahead: -0.03),
                .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -10),
                .shift(["hand_*", "hand_*.tip"], forward: -0.03, up: -0.1),
                .resolve(["forearm_*"]),
                .resolve(["shin_*"])],
        strength: hingeSmithLean
    )

    /// Good mornings: the hips staying over the heels. The pelvis, thighs and
    /// trunk go 0.4 torso lengths (~24 cm) forward and 0.06 (~4 cm) up at
    /// the bottom, so the pelvis ends over the ankles; the trunk keeps its
    /// length and its tip, so the chest folds out over the toes, and the hip
    /// stays ~26° more open (less hamstring stretch). The knees, re-seated
    /// over the planted feet, keep their ~18° bend (162-165°), so this does
    /// not read as the knees-bending ghost.
    private static func hingeGMWaistFold(_ strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [spine, legs, hips],
                  moves: [.shift(["pelvis", "thigh_*"] + torso, ahead: 0.4, rise: 0.06),
                          .resolve(["shin_*"])],
                  strength: strength)
    }

    /// Good mornings: the knees bending more and more on the way down. The
    /// hips, trunk and bar sink 0.08 torso lengths (~5 cm) and come ~2 cm
    /// forward, the knees re-seated: ~40° bent at the bottom instead of ~18°.
    private static func hingeGMKneesBending(_ strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, legs, hips, bar],
                  moves: [.shift(carried, ahead: 0.03, rise: -0.08), .resolve(["shin_*"])],
                  strength: strength)
    }

    /// Good mornings: stopping short, the trunk, arms and bar turned
    /// `degrees` back toward upright about the hips. Sized so the ghost
    /// holds a short nod (~15-19° standing, ~8-15° seated) from mid-descent
    /// on and never tips past upright.
    private static func hingeGMShort(_ degrees: Float, _ strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, bar],
                  moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: degrees)],
                  strength: strength)
    }

    /// Seated good morning: the feet pulled in close. Each foot moves 0.3
    /// torso lengths (~18 cm) toward the middle (the ankles ~0.25 m apart
    /// instead of 0.60 m) and each knee ~7 cm.
    private static let hingeSeatedFeetNarrow = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.3), .shift(["shin_*"], outward: -0.12)]
    )

    /// Seated good morning: leaning by curling the upper back instead of
    /// folding at the hips. The trunk turns 15° back toward upright about the
    /// pelvis while the chest caves and the neck and head curl forward: at
    /// the bottom the lower trunk sits ~15° more upright and the chest ~8 cm
    /// higher, while the head ends near the real head, so the lean looks as
    /// deep but comes from the upper back. Unlike `backRounded` (the back
    /// ghost), whose whole trunk drops with the hips still folding.
    private static let hingeSeatedUpperBackCurl = FaultPose(
        chains: [spine],
        moves: [.turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: 15),
                .shift(["chest"], forward: -0.06), .shift(["neck"], forward: 0.1), .shift(["head"], forward: 0.25)],
        strength: hingeSeatedLean
    )

    /// Smith good morning: squatting the bar down the rails. The trunk rises
    /// 15° toward upright, the hips and all they carry sink 0.25 torso
    /// lengths (~15 cm) and come 0.22 (~13 cm) forward, the knees re-seated
    /// (~99° at the bottom instead of 150°). The forward shift is what keeps
    /// the bar on its fixed line (within ~1 cm through the rep) while it
    /// slides ~6 cm further down the rails.
    private static let hingeSmithSquatted = FaultPose(
        chains: [spine, armsToGrip, legs, hips, bar],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 15),
                .shift(carried, ahead: 0.22, rise: -0.25),
                .resolve(["shin_*"])],
        strength: hingeSmithLean
    )

    /// Smith good morning: the feet set out in front of the bar, as for a
    /// Smith squat. Both feet 0.35 torso lengths (~21 cm) further forward,
    /// the ankles ~2 cm in front of the bar's line instead of ~18 cm behind
    /// it and the toes ~26 cm ahead of it, the knees re-seated. Read at the
    /// top: once the hips travel back the planted ankles are out of reach,
    /// so from mid-descent the legs lock straight and stretch (~6% at the
    /// bottom), which the still avoids.
    private static let hingeSmithFeetForward = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["foot_*", "foot_*.tip"], ahead: 0.35), .resolve(["shin_*"])]
    )

    /// Nordics and the glute-ham raise: the thighs as one line through the
    /// hips, knee to knee.
    private static let hingeNordicThighs = ["shin_L", "thigh_L", "pelvis", "thigh_R", "shin_R"]

    /// Nordics and the glute-ham raise: how far the body has tipped from
    /// kneeling upright, read from the knees opening: none at the top (89°),
    /// ~40% at 1 s, ~82% at the Nordic's bottom (164°), ~91% at the glute-ham
    /// raise's (172°).
    private static let hingeNordicLowered = FaultStrength.whenStraight("shin_L")

    /// Bending at the hips, the backside pushing back: the thighs, hips and
    /// trunk turn 20° back toward upright about the knees, then the trunk and
    /// head fold 45° forward about the hips. At the Nordic's bottom (82%)
    /// the knees open to ~147° instead of 164°, the hips sit ~12 cm higher
    /// and ~5 cm further back, folded ~37°, the chest at the real height and
    /// the head ~13 cm lower (still ~35 cm above the mat); the glute-ham
    /// raise's knees ~153° instead of 172°. The arms are left out: carried
    /// along they reach the floor at the Nordic's bottom.
    private static let hingeNordicHipsBent = FaultPose(
        chains: [spine, hingeNordicThighs],
        moves: [.turn(pivot: "shin_L", points: ["thigh_*", "pelvis"] + torso, axis: .lateral, degrees: 20),
                .turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: -45)],
        strength: hingeNordicLowered
    )

    /// Stopping short: the hips, trunk, head and arms turned `degrees` back
    /// toward kneeling upright about the knees, never past upright at any
    /// point of the rep (at the Nordic's bottom 50 leaves the body ~34°
    /// forward instead of 75°, 60 ~26°; at the glute-ham raise's 45 leaves
    /// it ~42° instead of 83°, about halfway).
    private static func hingeNordicShort(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, hingeNordicThighs],
                  moves: [.turn(pivot: "shin_L", points: ["thigh_*", "pelvis"] + trunk, axis: .lateral, degrees: degrees)],
                  strength: hingeNordicLowered)
    }

    /// Dropping the last part: the hips, trunk and head `degrees` further
    /// toward the floor about the knees (~10° of 12 at the bottom: the body
    /// ~5° above level, the head joint still ~33 cm up). The arms are left
    /// out: carried along they would pass through the floor.
    private static func hingeNordicDropped(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, hingeNordicThighs],
                  moves: [.turn(pivot: "shin_L", points: ["thigh_*"] + spine, axis: .lateral, degrees: -degrees)],
                  strength: hingeNordicLowered)
    }

    /// The heels lifting out of a loose anchor: the lower legs swing
    /// `degrees` up about the knees (the ankles ~14 cm off the pad at the
    /// bottom).
    private static func hingeNordicHeelsUp(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [legs],
                  moves: [.turn(pivot: "shin_*", points: ["foot_*", "foot_*.tip"], axis: .lateral, degrees: -degrees)],
                  strength: hingeNordicLowered)
    }

    /// Propping on the hands at the bottom: the hands 0.18 torso lengths
    /// straight down (~9 cm at the bottom), the elbows re-seated. The real
    /// wrists sit ~18 cm and the palms ~9 cm above the mat (5 cm thick) at
    /// the bottom; the propped palms land on it.
    private static let hingeNordicPropped = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], rise: -0.18), .shift(["forearm_*"], rise: -0.09),
                .resolve(["forearm_*"])],
        strength: hingeNordicLowered
    )

    /// Glute-ham raise: set up too far forward, the kneecaps on the pad. The
    /// whole lifter 0.15 torso lengths (~9 cm) further forward down to the
    /// ankles (the footplate set too close). The toe tips are left out: moved
    /// along they would hang ~9 cm off the real footplate, which reads as the
    /// loose-feet fault.
    private static let hingeGHRKneesOnPad = FaultPose(
        chains: [spine, ["thigh_*", "shin_*", "foot_*"], hips],
        moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*"] + torso, ahead: 0.15)]
    )

    /// Glute-ham raise: the feet gone loose, the toes pulled 25° toward the
    /// shins, ~10 cm off the footplate.
    private static let hingeGHRFeetLoose = FaultPose(
        chains: [legs],
        moves: [.turn(pivot: "foot_*", points: ["foot_*.tip"], axis: .lateral, degrees: 25)]
    )
    // MARK: 351-400 hip family pieces (2026-09-30)

    /// Frog pumps: the top of the rep, read from how far the hips sit from
    /// the left ankle (0.67 torso lengths at the bottom, 0.86 at the top on
    /// the rig): none below 0.74 (the first ~1 s of the rise), all of it
    /// from 0.84 (1.5-2.4 s). The hip angle cannot be used: with the thighs
    /// splayed ~50 deg the spine-hip-knee angle stays at 128-132 deg all rep.
    private static let hipFrogTop = FaultStrength.between("pelvis", "foot_L", from: 0.74, to: 0.84)

    /// Frog pump, stopping short: the hips and thighs hang 0.2 torso lengths
    /// (~12 cm) below the top, the spine and chest less as the trunk pivots
    /// on the shoulders (0.16, 0.1), the knees re-seated over the planted
    /// feet: the pelvis ends at ~0.24 m instead of 0.36 m, about where it
    /// passes at 1.0 s. `hipsShortOfLockout` without the hands, which rest
    /// on the floor here.
    private static let hipFrogShort = FaultPose(
        chains: [spine, legs, hips],
        moves: [.shift(["pelvis", "thigh_*"], rise: -0.2), .shift(["spine"], rise: -0.16),
                .shift(["chest"], rise: -0.1), .resolve(["shin_*"])],
        strength: hipFrogTop
    )

    /// Frog pumps, finished with the lower back: the lumbar spine bows ~7 cm
    /// up above the line of the pelvis and chest at the top, the chest ~3 cm.
    /// `thrustArched` read from the frog pump's own top.
    private static let hipFrogArched = FaultPose(
        chains: [spine],
        moves: [.shift(["spine"], rise: 0.12), .shift(["chest"], rise: 0.05)],
        strength: hipFrogTop
    )

    /// Frog pumps: the feet slid away from the hips. Both feet go 0.22 torso
    /// lengths (~13 cm) level along the floor away from the head (`ahead` is
    /// toward the head for a lifter lying face up), the knees re-seat, ~2.5 cm
    /// lower and straighter. Seen turned 0.7 toward the feet: side-on the
    /// feet already sit at the viewport's left edge and the slid toes would
    /// be cut off (the ghost's toes reach x 2 of 322 on the still); turned,
    /// they stop ~20 pt inside it.
    private static let hipFrogFeetFar = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["foot_*", "foot_*.tip"], ahead: -0.22), .resolve(["shin_*"])]
    )

    /// Frog pumps: the knees drifting up and together into an ordinary
    /// bridge as the hips rise, while the soles stay together. Each knee is
    /// pushed 0.5 torso lengths toward the ceiling and 0.35 toward the
    /// midline, then re-seated between the hip and the planted foot, so at
    /// the top it ends ~16 cm higher and ~21 cm further in (0.78 m apart
    /// becomes ~0.36 m). None at the bottom, all of it at the top.
    private static let hipFrogKneesIn = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["shin_*"], forward: 0.5, outward: -0.35), .resolve(["shin_*"])],
        strength: hipFrogTop
    )

    /// Lying face up: the head lifted off the mat to watch the hips, the neck
    /// raised ~3.5 cm and the head nodded 40 deg forward, ~10 cm up.
    private static let hipFrogHeadUp = FaultPose(
        chains: [["chest", "neck", "head"]],
        moves: [.shift(["neck", "head"], forward: 0.06),
                .turn(pivot: "neck", points: ["head"], axis: .lateral, degrees: -40)]
    )

    /// Cable hip adduction: the working (left) leg swept in, read from the
    /// knees' spread (0.67 torso lengths with the leg out, 0.16 crossed):
    /// none from 0.45, all of it from 0.22 (1.5-2.5 s).
    private static let hipCableIn = FaultStrength.between("shin_L", "shin_R", from: 0.45, to: 0.22)

    /// Cable hip adduction: the upper body twisting toward the standing leg
    /// as the foot crosses. The trunk, head, shoulders and hanging right arm
    /// turn 25 deg about the spine (the left shoulder forward), the left hand
    /// stays on the post and its elbow re-seats. Seen turned 1.3 (the
    /// lifter's front-right, the post and stack behind): the chest turns
    /// toward the camera, so the ghost's shoulders open ~12 pt a side wider
    /// than the lifter's and the hanging arm swings back. From the front-left
    /// (-0.6) the shoulders turned into the line of sight, the ghost
    /// narrowed to a sliver and the post-side elbow folded across the waist.
    private static let hipCableTwist = FaultPose(
        chains: [spine, shoulders, arms],
        moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*", "forearm_R", "hand_R"], axis: .up, degrees: 25),
                .resolve(["forearm_L"])],
        strength: hipCableIn
    )

    /// Cable hip adduction: hauling on the post in the left hand. The trunk
    /// tips 10 deg over toward the post and the stack (the head ~12 cm), the
    /// hand stays on the post and the elbow bends to let it.
    private static let hipCableHauled = FaultPose(
        chains: [spine, shoulders, ["upper_arm_L", "forearm_L", "hand_L"]],
        moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .forward, degrees: -10),
                .resolve(["forearm_L"])]
    )

    /// Cable hip adduction: the working hip dropping to swing the foot
    /// across. The pelvis and the whole left leg tilt 12 deg about the
    /// standing (right) hip, so the left hip sinks ~4 cm, the hip line tips
    /// down on the working side and the foot, carried with it, ends ~16 cm
    /// further across without the hip adducting any further; the toes stay
    /// clear of the floor. A `_R` pivot mirrors turns about `.forward`, so
    /// a positive turn drops the left side.
    private static let hipCableHipDropped = FaultPose(
        chains: [["thigh_R", "pelvis", "thigh_L"], leg("L")],
        moves: [.turn(pivot: "thigh_R", points: ["pelvis", "thigh_L", "shin_L", "foot_L", "foot_L.tip"],
                      axis: .forward, degrees: 12)],
        strength: hipCableIn
    )

    /// Cable hip adduction: the working knee bending, the lower leg swinging
    /// 45 deg back from the knee (the ankle ~29 cm back), which shortens the
    /// cable's lever on the hip. The foot tips its toes back up 30 deg at
    /// the ankle so they stay clear of the floor (they would pass ~3 cm
    /// under it swung with the shin). Seen turned -0.6 (front-left): at -0.9
    /// the post and the stack's rods stood between the camera and the lifter.
    private static let hipCableKneeBent = FaultPose(
        chains: [leg("L")],
        moves: [.turn(pivot: "shin_L", points: ["foot_L", "foot_L.tip"], axis: .lateral, degrees: -45),
                .turn(pivot: "foot_L", points: ["foot_L.tip"], axis: .lateral, degrees: 30)]
    )

    /// Cable hip adduction: short swings that stop at the midline. At the
    /// crossing the left leg is turned 10 deg back out, so the foot stops on
    /// the body's midline instead of ~14 cm past it in front of the
    /// standing foot (~14 cm shorter).
    private static let hipCableShort = FaultPose(
        chains: [leg("L"), hips],
        moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .forward, degrees: 10)],
        strength: hipCableIn
    )

    /// Standing hip abduction: the left leg out, read from the feet's spread
    /// (0.31 torso lengths together, 1.04 at the top): none at 0.45, all of
    /// it from 0.95 (1.5-2.5 s).
    private static let hipStandOut = FaultStrength.between("foot_L", "foot_R", from: 0.45, to: 0.95)

    /// Standing hip abduction: the lifting hip hitched up toward the ribs,
    /// the left hip and leg 0.08 torso lengths (~5 cm) up, the pelvis half
    /// that. The Cable Hip Abduction's hip fault.
    private static let hipStandHiked = FaultPose(
        chains: [["thigh_R", "pelvis", "thigh_L"], leg("L")],
        moves: [.shift(["thigh_L", "shin_L", "foot_L", "foot_L.tip"], rise: 0.08), .shift(["pelvis"], rise: 0.04)],
        strength: hipStandOut
    )

    /// Standing hip abduction: the leg swung out as high as it goes, 12 deg
    /// past the model's 30 to 42 (the foot ~10 cm higher), about the 45 deg
    /// the thigh can abduct before the pelvis tips. At 20 deg past, the
    /// ghost's foot ran off the viewport's right edge in the lifted mistake
    /// view; at 12 its toes stop ~10 pt inside.
    private static let hipStandSwungHigh = FaultPose(
        chains: [leg("L"), hips],
        moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .forward, degrees: 12)],
        strength: hipStandOut
    )

    /// Standing hip abduction: the toes turned out as the leg lifts, the left
    /// foot's toes swung 45 deg outward about the body's long axis.
    private static let hipStandToesOut = FaultPose(
        chains: [leg("L")],
        moves: [.turn(pivot: "foot_L", points: ["foot_L.tip"], axis: .up, degrees: -45)],
        strength: hipStandOut
    )

    /// Side-lying hip abduction: the top (left) leg up, read from the feet's
    /// spread (0.31 torso lengths stacked, 1.08 at the top): none at 0.45,
    /// all of it from 1.0 (1.5-2.5 s).
    private static let hipSideUp = FaultStrength.between("foot_L", "foot_R", from: 0.45, to: 1.0)

    /// Side-lying hip abduction: the top leg swung 18 deg past the model's
    /// 32 (the foot ~20 cm higher and ~17 cm toward the head).
    private static let hipSideSwungHigh = FaultPose(
        chains: [leg("L"), hips],
        moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .forward, degrees: 18)],
        strength: hipSideUp
    )

    /// Side-lying hip abduction: the top leg drifting forward of the body as
    /// it rises, 25 deg of hip flexion (the foot ~30 cm forward), with the
    /// toes turned up toward the ceiling. Forward is along the line of sight
    /// from behind, so it is seen from the feet end.
    private static let hipSideLegForward = FaultPose(
        chains: [leg("L"), hips],
        moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .lateral, degrees: 25),
                .turn(pivot: "foot_L", points: ["foot_L.tip"], axis: .up, degrees: -40)],
        strength: hipSideUp
    )

    /// Lying on the side: the pelvis and shoulders rolling back 35 deg about
    /// the spine (the angle Willcox & Burden 2013 reclined the pelvis to),
    /// the top hip and shoulder going back and the bottom ones forward while
    /// the top knee and foot stay where they are, so the top thigh ends
    /// angled forward of the pelvis. Seen from the feet end.
    private static let hipRolledBack = FaultPose(
        chains: [["thigh_R", "pelvis", "thigh_L"], ["upper_arm_L", "neck", "upper_arm_R"], leg("L")],
        moves: [.turn(pivot: "pelvis", points: ["thigh_*", "upper_arm_*"], axis: .up, degrees: -35)]
    )

    /// Side-lying hip abduction: the top hip hitched toward the ribs to lift
    /// the leg higher, a lateral pelvic tilt. The pelvis and the whole top
    /// leg tilt 12 deg about the bottom (right) hip, so the top hip rides
    /// ~4 cm toward the head, the waist shortens (the pelvis-spine line
    /// bends) and the leg rises from 32 to ~44 deg (the foot ~19 cm higher)
    /// with no more hip abduction (Cynn 2006 measured 13.9 deg of lateral
    /// pelvic tilt in the unstabilised lift). A `_R` pivot mirrors turns
    /// about `.forward`, so a negative turn lifts the left side toward the
    /// head. (Sliding the hip and leg 8 cm toward the head read on the still
    /// only as a small shift along the body.)
    private static let hipSideHitched = FaultPose(
        chains: [["thigh_R", "pelvis", "thigh_L"], leg("L"), ["pelvis", "spine", "chest"]],
        moves: [.turn(pivot: "thigh_R", points: ["pelvis", "thigh_L", "shin_L", "foot_L", "foot_L.tip"],
                      axis: .forward, degrees: -12)],
        strength: hipSideUp
    )

    /// Lying on the side: the head lifted off the floor, the neck ~3 cm up
    /// and the head bent 35 deg toward the ceiling (~9 cm).
    private static let hipSideHeadUp = FaultPose(
        chains: [["chest", "neck", "head"]],
        moves: [.shift(["neck", "head"], outward: 0.05),
                .turn(pivot: "neck", points: ["head"], axis: .forward, degrees: -35)]
    )

    /// Seated banded hip abduction: the knees pushed apart, read from their
    /// spread (0.60 torso lengths at rest, 1.15 at the top): none at 0.75,
    /// all of it from 1.08 (1.5-2.5 s).
    private static let hipBandApart = FaultStrength.between("shin_L", "shin_R", from: 0.75, to: 1.08)

    /// Seated banded hip abduction: short pulses. Each knee held 0.15 torso
    /// lengths further in and re-seated over its foot, ~7 cm short of the
    /// model's widest point on each side.
    private static let hipBandShort = FaultPose(
        chains: [legs, hips],
        moves: [.shift(["shin_*"], outward: -0.15), .resolve(["shin_*"])],
        strength: hipBandApart
    )

    /// Seated with the hands on the bench: pressing down through straight
    /// arms so the hips lift off it. The hips and trunk rise 0.1 torso
    /// lengths (~6 cm) between the shoulders, which stay where they are with
    /// the arms and hands (the arms are nearly straight and cannot reach
    /// further); the knees re-seat over the planted feet. Seen face-on the
    /// rise runs up the screen between the two unmoving arms.
    private static let hipBandHipsUp = FaultPose(
        chains: [spine, legs, hips, arms],
        moves: [.shift(["pelvis", "thigh_*"] + torso, rise: 0.1), .resolve(["shin_*"])]
    )

    /// Clamshell: the top knee open, read from the knees' spread (0.27 torso
    /// lengths closed, 0.61 open): none at 0.40, all of it from 0.58.
    private static let hipClamOpen = FaultStrength.between("shin_L", "shin_R", from: 0.40, to: 0.58)

    /// Clamshell: short openings. The top knee is pushed 0.3 torso lengths
    /// back down toward the bottom one and re-seated between the hip and the
    /// foot, so at the top it sits only ~3 cm above its closed height
    /// instead of ~19 cm: the knees barely part.
    private static let hipClamShort = FaultPose(
        chains: [leg("L"), hips],
        moves: [.shift(["shin_L"], outward: -0.3), .resolve(["shin_L"])],
        strength: hipClamOpen
    )

    /// Clamshell: the top foot lifting off the bottom one, 0.15 torso lengths
    /// (~9 cm) toward the ceiling, the top knee re-seated. Shown as the knee
    /// opens, from a spread of 0.30 to 0.50.
    private static let hipClamFootUp = FaultPose(
        chains: [leg("L"), leg("R")],
        moves: [.shift(["foot_L", "foot_L.tip"], outward: 0.15), .resolve(["shin_L"])],
        strength: .between("shin_L", "shin_R", from: 0.30, to: 0.50)
    )

    /// Clamshell: lying with the hips nearly straight, both legs turned 30
    /// deg back about the hips (from ~51 deg of hip flexion to ~21), the feet
    /// still together. Seen from the feet end.
    private static let hipClamHipsStraight = FaultPose(
        chains: [legs, hips],
        moves: [.turn(pivot: "thigh_*", points: ["shin_*", "foot_*", "foot_*.tip"], axis: .lateral, degrees: -30)]
    )
    // MARK: 351-400 leg curl pieces (2026-10-01)

    /// Standing and kneeling machine curls (the left leg works): the trunk
    /// and upper arms swung `degrees` about the hips, positive rocking back
    /// and up, with the hands left on the handles and the elbows re-seated
    /// between. Grows with the left knee's bend, so it shows as the heel
    /// comes up (all of it at the top, 73°). Keep the shoulder-to-hand span
    /// within the arm's reach (0.538 m): tipping forward toward fixed hands
    /// folds the elbows into a tangle, and too far back locks them.
    private static func legCurlRocked(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [spine, arms],
                  moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .lateral, degrees: degrees),
                          .resolve(["forearm_*"])],
                  strength: .withBend("shin_L"))
    }

    /// Standing one-leg curls: the working (left) knee drifting forward off
    /// the lever's pivot or toward the stack, the whole left leg swung
    /// `degrees` forward about the hip with the knee bend kept, so the thigh
    /// no longer hangs straight down. Grows with the left knee's bend.
    private static func legCurlKneeForward(_ degrees: Float) -> FaultPose {
        FaultPose(chains: [leg("L"), hips],
                  moves: [.turn(pivot: "thigh_L", points: ["shin_L", "foot_L", "foot_L.tip"], axis: .lateral, degrees: degrees)],
                  strength: .withBend("shin_L"))
    }

    /// Floor curls (lying face up, heels on a ball or sliders): the lower
    /// back arching the hips higher at the top, the lumbar spine lifted
    /// `rise` torso lengths and the chest `chest`, as `bridgeArched`, but
    /// growing with the knee bend, since these bridges peak with the knees
    /// most bent (the Sliding Leg Curl's hips are only 148° there).
    private static func floorCurlArched(_ rise: Float, chest: Float) -> FaultPose {
        FaultPose(chains: [spine],
                  moves: [.shift(["spine"], rise: rise), .shift(["chest"], rise: chest)],
                  strength: .withBend("shin_L"))
    }

    /// Floor curls: the hips sinking toward the floor, the pelvis and hips
    /// `drop` torso lengths lower and the lumbar spine half that, the knees
    /// re-seated between the lowered hips and the heels, which stay on the
    /// ball or sliders.
    private static func floorCurlHipsDown(_ drop: Float, strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [spine, legs, hips],
                  moves: [.shift(["pelvis", "thigh_*"], rise: -drop), .shift(["spine"], rise: -drop / 2),
                          .resolve(["shin_*"])],
                  strength: strength)
    }

    /// Floor curls: both arms lifted off the floor about the shoulders.
    /// Arms that lie along the body toward the feet lift about `.lateral`;
    /// arms spread out to the sides with the elbows bent (the sliding curls)
    /// lift about `.up`, the body's long axis (mirrored for the right arm).
    private static func floorCurlArmsUp(_ axis: BodyAxis, _ degrees: Float) -> FaultPose {
        FaultPose(chains: [armsToGrip],
                  moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: axis, degrees: degrees)])
    }
    // MARK: 351-400 folder, Romanian deadlift pieces (2026-10-01)

    /// Single-leg and B-stance RDLs: how far the standing (left) hip has
    /// hinged. None standing tall (hip 171-172°), all of it from 90° down
    /// (the bottom is 79° on the single-leg lifts, 93° on the B-stance), so
    /// the faults of the bottom fade out as the lifter stands.
    private static let rdl4Hinged = FaultStrength.withBend("thigh_L")

    /// Single-leg RDLs (the left leg stands, the right reaches back): the free
    /// leg's knee, ankle and toes.
    private static let rdl4FreeLeg = ["shin_R", "foot_R", "foot_R.tip"]

    /// Every RDL and the Dumbbell Deadlift: the back rounding at the bottom.
    /// The Pendlay Row's deeper `backRounded`: the lower and middle back hump
    /// 0.10 torso lengths (~6 cm) toward the ceiling, and the neck and head
    /// drop toward the floor and draw in along the spine, so the rounding
    /// shows as an arch over the real back. On the simulator stills the
    /// shared piece's ~3-4 cm hump lay along the model's back as a flat line,
    /// only the head dropping, side-on and from the three-quarter views alike.
    private static func rdl4BackRounded(_ strength: FaultStrength) -> FaultPose {
        FaultPose(chains: [spine],
                  moves: [.shift(["spine"], forward: -0.10),
                          .shift(["chest"], forward: -0.10, up: -0.02),
                          .shift(["neck"], forward: 0.04, up: -0.04),
                          .shift(["head"], forward: 0.13, up: -0.07)],
                  strength: strength)
    }

    /// Single-leg RDLs: reaching for the floor while the hips stay over the
    /// foot and the free leg hangs. The Stiff-Leg Deadlift's toe-touch (the
    /// hips and free leg 0.12 torso lengths, ~7 cm, forward over the
    /// standing foot, the standing knee re-seated, the waist folding and the
    /// head dropping), then the free leg swings 35° down about its hip, from
    /// ~18° below level at the bottom to ~53°, its ankle ~42 cm lower and
    /// the toes just at the floor (45° put them ~7 cm through it).
    private static let rdl4ReachedDown = FaultPose(
        chains: [spine, leg("L"), leg("R"), hips],
        moves: [.shift(["pelvis", "thigh_*"] + rdl4FreeLeg, ahead: 0.12),
                .shift(["spine"], ahead: 0.06, rise: 0.02),
                .resolve(["shin_L"]),
                .shift(["chest"], forward: -0.05), .shift(["neck"], forward: 0.05), .shift(["head"], forward: 0.12),
                .turn(pivot: "thigh_R", points: rdl4FreeLeg, axis: .lateral, degrees: 35)],
        strength: rdl4Hinged
    )

    /// Single-leg RDLs: the standing knee bending further as the chest lowers.
    /// `hingeKneesBending` for one leg: the hips, trunk, arms, load and the
    /// free leg sink 0.13 torso lengths (~7 cm) and come 0.04 forward, the
    /// standing knee re-seated over the planted foot (160° to ~125° at the
    /// bottom). The free foot moves with the hips instead of being re-seated,
    /// since it is in the air.
    private static func rdl4StandingKneeSinks(withBar: Bool) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, leg("L"), leg("R"), hips] + (withBar ? [bar] : []),
                  moves: [.shift(carried + rdl4FreeLeg, ahead: 0.04, rise: -0.13), .resolve(["shin_L"])],
                  strength: rdl4Hinged)
    }

    /// Single-leg RDLs: the free (right) hip rolling open toward the ceiling.
    /// The pelvis and free leg turn 25° about the standing hip around the
    /// trunk's long axis, lifting the free hip ~7 cm, and the free leg swings
    /// 20° out to the side (the free foot ~25 cm out, toes turned out). With
    /// a load in each hand (`withArm`), the whole right arm, shoulder to
    /// palm, rises 0.1 torso lengths (~6 cm) with the opening side, so that
    /// side's dumbbell rides higher or, with `withBar`, the bar tips; moving
    /// the shoulder too keeps every arm bone its length. The trunk is left
    /// alone: turned with the pelvis, the hanging arms swung out sideways
    /// instead of hanging. The opening is across the line of sight side-on,
    /// so it is seen from behind on the left (turned -1.3, a total of -2.6),
    /// where the ghost's free foot moves about twice as far on screen as at
    /// -0.8 or unturned.
    private static func rdl4HipOpened(withArm: Bool = false, withBar: Bool = false) -> FaultPose {
        let arm = ["upper_arm_R", "forearm_R", "hand_R", "hand_R.tip"]
        let hand: [FaultMove] = withArm ? [.shift(arm, forward: -0.1)] : []
        return FaultPose(chains: [["thigh_L", "pelvis", "thigh_R"], leg("R")]
                                 + (withArm ? [arm] : []) + (withBar ? [bar] : []),
                         moves: [.turn(pivot: "thigh_L", points: ["pelvis", "thigh_R"] + rdl4FreeLeg, axis: .up, degrees: 25),
                                 .turn(pivot: "thigh_R", points: rdl4FreeLeg, axis: .forward, degrees: 20)] + hand,
                         strength: rdl4Hinged)
    }

    /// Single-leg RDL: rocking onto the toes of the standing foot. The left
    /// heel lifts (the foot turns 22° about the toes) with the knee re-seated,
    /// and the arms drift 12° forward as the weight goes over the toes.
    private static let rdl4StandingHeelUp = FaultPose(
        chains: [leg("L"), armsToGrip],
        moves: [.turn(pivot: "foot_L.tip", points: ["foot_L"], axis: .lateral, degrees: -22),
                .resolve(["shin_L"]),
                .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: 12)],
        strength: rdl4Hinged
    )

    /// B-stance RDL (the left foot works, the right is the kickstand): the
    /// back heel dropping and the hips drifting back onto it, so both feet
    /// share the load. The right foot turns 30° about its toes (pitch ~56° to
    /// ~26°, flat, the ankle ~9 cm lower), the hips, trunk and arms go 0.06
    /// torso lengths (~3.5 cm) back and 0.04 (~2.4 cm) down, and both knees
    /// re-seat: the back knee opens (113° to ~131° at the bottom, the leg
    /// pushing) while the front knee stays soft (162° to ~154°). Moved back
    /// only, the hips went out of the front leg's reach and snapped its knee
    /// straight, which read as the locked-knee fault instead.
    private static let rdl4KickstandLoaded = FaultPose(
        chains: [legs, hips, spine],
        moves: [.turn(pivot: "foot_R.tip", points: ["foot_R"], axis: .lateral, degrees: 30),
                .shift(carried, ahead: -0.06, rise: -0.04), .resolve(["shin_*"])]
    )

    /// B-stance RDL: the back foot stepped far back like a lunge. The right
    /// ankle and toes go 0.35 torso lengths (~20 cm) further back, the toes
    /// ~34 cm behind the front heel instead of level with it, the back knee
    /// re-seated (straight where the foot is out of reach at the top).
    private static let rdl4KickstandFarBack = FaultPose(
        chains: [leg("R"), hips],
        moves: [.shift(["foot_R", "foot_R.tip"], ahead: -0.35), .resolve(["shin_R"])]
    )

    /// Two-leg RDLs: the knees locked straight as the hips go back, drawn at
    /// the bottom (the models' knees 150-154° there), none standing tall.
    private static let rdl4KneesLocked = FaultPose(
        chains: [legs], moves: [.straighten(["shin_*"])], strength: .withBend("thigh_L")
    )

    /// Smith RDL: chasing the floor once the stretch runs out. The Romanian
    /// Deadlift's range fault: the hips and all they carry sink 0.1 torso
    /// lengths (~6 cm), the knees re-seat, and the back rounds, the head
    /// dropping. The bar sinks with the hands, straight down its track.
    private static func rdl4ChasedFloor(withBar: Bool) -> FaultPose {
        FaultPose(chains: [spine, armsToGrip, legs, hips] + (withBar ? [bar] : []),
                  moves: [.shift(carried, rise: -0.1), .resolve(["shin_*"]),
                          .shift(["spine"], forward: -0.07), .shift(["chest"], forward: -0.05),
                          .shift(["neck"], forward: 0.05), .shift(["head"], forward: 0.12)],
                  strength: .withBend("thigh_L"))
    }

    /// Cable RDL: the cable dragging the arms out toward the low pulley, the
    /// shoulders rounding forward with them. The shoulders, elbows and hands
    /// go 0.08 torso lengths (~5 cm) out of the chest and the arms swing 28°
    /// further forward about the shoulders, the bar ~30 cm nearer the
    /// machine at the bottom; none standing tall. At the bottom the model's
    /// arms hang about 5° forward of vertical and the ghost's ~31°, past the
    /// ~28° the cable already draws them to at the top, so the ghost never
    /// looks like the model's own top.
    private static let rdl4ArmsDragged = FaultPose(
        chains: [shoulders, armsToGrip, bar],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], forward: 0.08),
                .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: 28)],
        strength: .withBend("thigh_L")
    )

    /// Cable RDL: standing too close to the low pulley. The whole lifter,
    /// feet and bar included, drawn 0.6 torso lengths (~34 cm) nearer the
    /// machine in the same pose, about half the model's ~0.9 m from the
    /// pulley, where the stack comes down onto its rest at the bottom.
    private static let rdl4CloserToPulley = FaultPose(
        chains: [spine, armsToGrip, legs, hips, bar],
        moves: [.shift(carried + ["shin_*", "foot_*", "foot_*.tip"], ahead: 0.6)]
    )

    /// Smith RDL: standing too far back from the bar, which the rails hold in
    /// place. The body, feet and shoulders stand 0.15 torso lengths (~9 cm)
    /// further back while the hands stay on the bar and the elbows re-seat,
    /// so at the bottom the bar sits over the ghost's toe tips instead of
    /// mid-foot and the arms reach forward to it (the Smith Machine Upright
    /// Row's stance fault; `barDrifting` would move the bar off its track).
    /// It grows as the hips hinge, so the arms are never stretched to reach
    /// the bar at the top.
    private static let rdl4StoodBackFromBar = FaultPose(
        chains: [spine, legs, hips, armsToGrip, bar],
        moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip", "upper_arm_*"] + torso, ahead: -0.15),
                .resolve(["forearm_*"])],
        strength: .withBend("thigh_L")
    )

    /// Dumbbell Deadlift: the hips shooting up out of the bottom while the
    /// chest stays low. The pelvis, hips and lower trunk turn 25° up about
    /// the neck, so the head and hands stay where they are while the hips
    /// rise ~24 cm and go ~10 cm back, the trunk tips from ~56° to ~81°, and
    /// the knees re-seat, opening from ~65° to ~114°. The shared
    /// `hipsShotUp` straightens the knees onto the hip-ankle line, which at
    /// this model's deep 65° knees shrank both leg bones by about 40%.
    private static let rdl4HipsShotUp = FaultPose(
        chains: [spine, legs, hips],
        moves: [.turn(pivot: "neck", points: ["pelvis", "thigh_*", "spine", "chest"], axis: .lateral, degrees: -25),
                .resolve(["shin_*"])],
        strength: .withBend("shin_L")
    )
    // END 351-400 (2026-09-30) pieces
    // MARK: Exercises 1-50 redo pieces (2026-09-29)
    // MARK: Exercises 1-50 redo: Pendlay Row and Close-Grip Bench Press (2026-09-29)

    /// Pendlay row: how near the floor the bar is, read off the distance from
    /// the left wrist to the pelvis in torso lengths: 1.19 with the plates at
    /// their lowest (0 s and 4 s), 1.03 half a second into the pull, 0.80 at
    /// the top (1.25-1.9 s). All of it at the floor, none once the bar is
    /// ~11 cm up.
    private static let pendlayAtFloor = FaultStrength.between("hand_L", "pelvis", from: 1.0, to: 1.17)

    /// Pendlay row: the chest swinging up 25° about the hips to heave the bar
    /// off the floor. The trunk turns as in `trunkLifted`, then each arm turns
    /// back by the same angle about its shoulder, so the arms keep hanging as
    /// the real ones do and the bar comes up with the chest instead of being
    /// rowed: at the bottom the ghost bar rises ~19 cm, to knee height, ~12 cm
    /// in front of the knees, the trunk ~45° above level. (Turned with the
    /// trunk, the arms swung forward to point level in the air, and at the
    /// top of the pull they drew a zigzag over the back.) The heave is the
    /// start of the pull, so it fades as the bar rises: all of it from the
    /// floor until the left wrist is within 1.10 torso lengths of the pelvis
    /// (~0.35 s), about three quarters at 0.5 s, none by 0.85 (~0.9 s) and
    /// through the top, where the counter-turned arms, folded back past the
    /// trunk, drew a zigzag with the hands above the back.
    private static let pendlayChestHeave = FaultPose(
        chains: [spine, armsToGrip, bar],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 25),
                .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -25)],
        strength: .between("hand_L", "pelvis", from: 0.85, to: 1.10)
    )

    /// Pendlay row: the back rounding to reach the bar on the floor. A deeper
    /// `backRounded` (the Z Press's idiom): the lower and middle back hump
    /// 0.10 torso lengths (~6 cm) away from the floor, the neck and head
    /// drop toward it and draw in along the spine, so the rounding shows as
    /// an arch over the real back from the rear three-quarter view, where the
    /// shared piece's ~4 cm hump read as a flat line with the head dropping.
    /// Strength `pendlayAtFloor`.
    private static let pendlayBackRounded = FaultPose(
        chains: [spine],
        moves: [
            .shift(["spine"], forward: -0.10),
            .shift(["chest"], forward: -0.10, up: -0.02),
            .shift(["neck"], forward: 0.04, up: -0.04),
            .shift(["head"], forward: 0.13, up: -0.07)
        ],
        strength: pendlayAtFloor
    )

    /// Pendlay row: the bar left hovering between reps instead of going back
    /// to the floor, a bent-over row's bottom. The hands, with the bar, stay
    /// 0.15 torso lengths (~9 cm) higher, the plates ~12 cm off the floor,
    /// and the elbows re-seat under the shoulders, which hold still. Full
    /// with the plates at their lowest, fading as the bar rises.
    private static let pendlayBarHovering = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["hand_*", "hand_*.tip"], rise: 0.15), .resolve(["forearm_*"])],
        strength: pendlayAtFloor
    )

    /// Pendlay row: the pull stopping about half-way, out in front of the
    /// knees (the correct top is beside them, brushing the thighs). The
    /// hands sit 0.14 torso lengths (~8 cm) further ahead and 0.17 (~10 cm)
    /// lower, back along the bar's own path (the model's bar rises 24 cm and
    /// comes 20 cm toward the body), the elbows re-seating less bent; the
    /// ghost bar ends ~7 cm in front of the knees. Full
    /// once the left wrist is within 0.85 torso lengths of the pelvis (0.80
    /// at the top), none beyond 1.05, so it never pushes the bar into the
    /// floor.
    private static let pendlayPulledShort = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["hand_*", "hand_*.tip"], ahead: 0.14, rise: -0.17), .resolve(["forearm_*"])],
        strength: .between("hand_L", "pelvis", from: 1.05, to: 0.85)
    )

    /// Close-grip bench press: the hands slid in until they nearly touch. The
    /// model's wrists are 0.38 m apart, right over the shoulder joints; each
    /// moves 0.2 torso lengths (~12 cm) in, leaving ~14 cm between them, and
    /// the elbows stay where they are, so the forearms slant in toward the
    /// middle of the bar. The same all rep; drawn at the top, where the
    /// forearms converge on the bar in open space above the chest (at the
    /// bottom the elbows splay beside the chest and the ghost is a tangle
    /// over the torso).
    private static let closeGripHandsTogether = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.2)]
    )

    /// Close-grip bench press: the bar drifting down onto the upper stomach
    /// and pressed straight up from there. The model's bar touches the lower
    /// chest and comes 13 cm back on the way up to finish over the shoulders;
    /// the ghost's hands sit 0.30 torso lengths toward the feet and 0.075
    /// lower at full strength, and the shift grows as the bar rises (the
    /// left wrist 0.75 torso lengths from the pelvis at the bottom, 1.27 at
    /// the top): about half of it at the bottom, ~9.4 cm toward the feet and
    /// ~2.4 cm down, over the upper stomach, and all of it at the top, so the
    /// ghost bar rises almost straight up (only ~5 cm toward the head over
    /// ~40 cm) and ends over the upper stomach instead of the shoulders. The
    /// elbows move with the hands before re-seating, so they keep bending
    /// toward the feet like the real ones: re-seated from where they were,
    /// at the top the shoulder-to-wrist line swung past them and the ghost
    /// elbows bent the wrong way, toward the head (simulator QA). Elbows 51°
    /// at the bottom and 136° at the top. Drawn at the top, where all of it
    /// shows: side-on, the ghost upper arms lean ~42° toward the feet and the
    /// forearms stand upright under a bar over the upper stomach, while the
    /// real forearms lean back over the shoulders (at the bottom,
    /// half-strength, the ghost stood on the real arms ~15 pt away).
    private static let closeGripBarLow = FaultPose(
        chains: [armsToGrip, bar],
        moves: [.shift(["hand_*", "hand_*.tip", "forearm_*"], forward: -0.075, up: -0.30), .resolve(["forearm_*"])],
        strength: .between("hand_L", "pelvis", from: 0.17, to: 1.27)
    )
    // MARK: 1-50 redo curl pieces (2026-09-29)

    /// Incline curls: the bench set upright, or the lifter sitting up off it.
    /// The trunk comes forward 25° about the hips (to vertical on the Incline
    /// Dumbbell Curl, whose back pad slopes 65°), and the arms turn 25° back
    /// forward about the shoulders, so they hang straight down in line with
    /// the body instead of 25° behind it. Read at the bottom, with the arms
    /// hanging: on the rig the ghost shoulders sit ~23 cm in front of the
    /// real ones and the ghost arms hang straight below them.
    private static let inclineSatUpright = FaultPose(
        chains: [spine, shoulders, armsToGrip],
        moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: -25),
                .turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: 25)]
    )

    /// One-arm curls with the pulley behind the lifter (the Bayesian curl,
    /// left arm): the body rocking forward to drag the handle, the hips
    /// sliding 0.06 torso lengths back and the trunk tipping 15° forward from
    /// them with the working arm carried along — `bodySwungOneArm` mirrored.
    /// Only the drawn points move, so the free arm gets no dashed guides.
    /// Grows with the left elbow's bend.
    private static let cableBehindRockedForward = FaultPose(
        chains: [spine, arm("L"), hips],
        moves: [.shift(["pelvis", "thigh_*"], ahead: -0.06),
                .turn(pivot: "pelvis", points: torso + arm("L"), axis: .lateral, degrees: -15)],
        strength: .withBend("forearm_L")
    )
    // MARK: Exercises 1-50 redo, forearm pieces (2026-09-29)

    /// Wrist curl on a forearm pad (the Wrist Curl: seated, forearms level
    /// on the pad, elbows ~95°, wrists just past its front edge): where the
    /// hands are in their arc, read as the middle of the left palm's distance
    /// from the left knee, in torso lengths. On the rig it is 0.63 at the
    /// bottom (the palm point ~26° below level), 0.717 as the palm point
    /// passes level, 0.742 at ~8° above it (the knuckles level), 0.774 at
    /// ~22° above and 0.805 at the top (~39° above). `wristPadTop` fades a
    /// fault of the top in once the knuckles rise past level, in full from
    /// ~30° above; `wristPadBottomShort` shows all of one at the bottom and
    /// none once the knuckles reach level, so a hand turned 35° up holds at
    /// about level (the palm point 8-8.4° above it, within ~0.5°) until the
    /// lifter's hands reach it, rather than rising with them.
    private static let wristPadTop = FaultStrength.between("hand_L.tip", "shin_L", from: 0.745, to: 0.79)
    private static let wristPadBottomShort = FaultStrength.between("hand_L.tip", "shin_L", from: 0.742, to: 0.63)

    /// Wrist curl on a forearm pad: the forearms resting too far back, the
    /// wrists on the pad instead of just past its front edge. Elbows, wrists
    /// and hands slide 0.17 torso lengths (~10 cm) straight back along the
    /// level pad, so the wrists sit ~8 cm in from the edge and the elbows
    /// hang off its back; at the bottom the hand line, tipped as far as the
    /// lifter's (~26° below level), only just clears the pad's front corner
    /// (~1.6 cm above it, less than the back of the hand's depth). Drawn from
    /// the elbows, since the upper arms could only follow with the whole body
    /// moving back.
    private static let wristPadForearmsBack = FaultPose(
        chains: [["forearm_*", "hand_*", "hand_*.tip"]],
        moves: [.shift(["forearm_*", "hand_*", "hand_*.tip"], ahead: -0.17)]
    )

    /// Standing reverse (overhand) curl: the shoulders rolling forward and
    /// shrugging up as the bar reaches the top (the Biceps Curl's shoulder
    /// fault, 0.06 forward and 0.1 up, ~4 and ~6 cm), the arms, grip and bar
    /// carried with them. Grows with the left elbow's bend, so it is all
    /// there from the elbows at 90° to the top and gone with the arms
    /// straight.
    private static let reverseCurlShouldersRolled = FaultPose(
        chains: [shoulders, armsToGrip, bar],
        moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], forward: 0.06, up: 0.1)],
        strength: .withBend("forearm_L")
    )

    // MARK: - Table

    private static let table: [String: [String: FaultPose]] = [
        // MARK: Chest
        "Barbell Bench Press": [
            "wrist": wristBentBack(withBar: true),
            // The 2026-09-29 model tucks the elbows to ~41-45° at the chest
            // (the old one sat at ~57°), so the flare turns further to put the
            // ghost at the 90° the mistake badge names.
            "elbow": elbowsFlared(46),
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
            "barpath": barBounced,
            "feet": declineFeetSlipping,
            "scapula": benchShoulders
        ],
        "Dumbbell Bench Press": [
            "wrist": wristBentBack(withBar: false),
            // Elbows sinking below the torso at the bottom.
            "elbow": FaultPose(chains: [arms], moves: [.shift(["forearm_*"], forward: -0.12)],
                               strength: .withBend("forearm_L")),
            // Pressed straight up like a barbell: the dumbbells never meet.
            "barpath": dumbbellsWide,
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
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            // Short reps: the hands stop well short of full extension. A
            // fault of the lockout, so it grows as the elbows straighten
            // (63 % at this model's 147° lockout: the same 9 cm as before)
            // rather than pushing the hands back past the chest at the bottom.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.25),
                                         .shift(["forearm_*"], forward: -0.125)],
                                 strength: .whenStraight("forearm_L")),
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Pec Deck Fly": [
            // Pulling with the hands: the elbows bend and drop.
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
            "elbow": flyFolded,
            "barpath": flyPressed,
            "feet": squareLockedStance,
            "scapula": shouldersRolledIn
        ],
        "Low-to-High Cable Fly": [
            // Hands pulled up past the head.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: 0.24), .shift(["forearm_*"], up: 0.14)]),
            // Elbows bending as the arms rise, pressing upward.
            "elbow": FaultPose(chains: [armsToGrip],
                               moves: [.turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: 40)]),
            // Pulled straight across at chest height instead of rising: a
            // fault of the finish, so it shows as the hands come together.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], up: -0.14), .shift(["forearm_*"], up: -0.06)],
                                 strength: .between("hand_L", "hand_R", from: 1.5, to: 0.5)),
            "feet": squareLockedStance,
            "scapula": shrugged
        ],
        "Push-Up": pushUpFaults,

        // MARK: Chest batch 101-131 (2026-09-25)
        "Barbell Floor Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(),
            // Bar drifting toward the neck.
            "barpath": pressedHigh(0.22, withBar: true),
            "feet": hipsBridged,
            "scapula": benchShoulders
        ],
        "Smith Machine Bench Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(),
            // Bench set too far back: the bar lands high, near the neck.
            "barpath": pressedHigh(0.26, withBar: true),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Smith Machine Incline Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(),
            "barpath": pressedHigh(0.2, withBar: true),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Smith Machine Decline Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(),
            "barpath": barBounced,
            "feet": declineFeetSlipping,
            "scapula": benchShoulders
        ],
        "Dumbbell Floor Press": [
            "wrist": wristBentBack(withBar: false),
            "elbow": elbowsFlared(),
            "barpath": dumbbellsWide,
            "feet": hipsBridged,
            "scapula": benchShoulders
        ],
        "Single-Arm Dumbbell Bench Press": [
            "wrist": leftWristBentBack,
            "elbow": leftElbowFlared(),
            // Rolling toward the free side, the working shoulder off the bench.
            "core": twisted(16, about: "spine"),
            "feet": benchFeet,
            "scapula": FaultPose(chains: [leftArm, ["upper_arm_L", "upper_arm_R"]],
                                 moves: [.shift(leftArm, forward: 0.12, outward: -0.04)])
        ],
        "Alternating Dumbbell Bench Press": [
            "wrist": wristBentBack(withBar: false),
            // The waiting (right) elbow sagging below the bench; it fades
            // out when that arm takes its turn to press.
            "elbow": FaultPose(chains: [["upper_arm_R", "forearm_R", "hand_R"]],
                               moves: [.shift(["forearm_R"], forward: -0.12)],
                               strength: .withBend("forearm_R")),
            // Rocking from side to side as the arms switch.
            "alternate": twisted(14, about: "spine"),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Neutral-Grip Dumbbell Press": [
            "wrist": wristBentBack(withBar: false),
            "elbow": elbowsFlared(34),
            "barpath": dumbbellsWide,
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Dumbbell Squeeze Press": [
            // Dumbbells drifting apart.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.1)]),
            "elbow": elbowsFlared(34),
            // Lowered toward the neck.
            "barpath": pressedHigh(0.2, withBar: false),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Incline Dumbbell Squeeze Press": [
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.1)]),
            "elbow": elbowsFlared(34),
            "barpath": pressedHigh(0.18, withBar: false),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Dumbbell Pullover": [
            "grip": wristBentBack(withBar: false),
            "elbow": pulloverElbowsBent(withBar: false),
            "arc": pulloverTooDeep(withBar: false),
            "ribs": lowerBackArched(0.1, pulloverStretch),
            "feet": benchFeet
        ],
        "Barbell Pullover": [
            // A grip too wide, as the sheet says: hands and elbows out. Seen
            // side-on that move runs along the line of sight, so while it
            // shows the model turns to be seen more from the feet end.
            "grip": FaultPose(chains: [armsToGrip, bar],
                              moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.2), .shift(["forearm_*"], outward: 0.12)],
                              view: 0.8),
            "elbow": pulloverElbowsBent(withBar: true),
            "arc": pulloverTooDeep(withBar: true),
            // This framing's small figure needs a deeper arch to show (~9 px).
            "ribs": lowerBackArched(0.13, pulloverStretch),
            "feet": benchFeet
        ],
        "Iso-Lateral Chest Press": [
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            // Each press cut short, the elbow still bent: a fault of the
            // lockout, on the left arm, which presses first (0-4 s) while the
            // right waits at the chest.
            "barpath": FaultPose(chains: [leftArmToGrip],
                                 moves: [.shift(["hand_L", "hand_L.tip"], forward: -0.2), .resolve(["forearm_L"])],
                                 strength: .whenStraight("forearm_L")),
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Incline Chest Press Machine": [
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            "barpath": pressCutShort,
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Decline Chest Press Machine": [
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            "barpath": pressCutShort,
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Plate-Loaded Chest Press": [
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            "barpath": pressCutShort,
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Wide-Grip Chest Press Machine": [
            "wrist": wristBentBack(withBar: false),
            // Elbows riding up level with the shoulders at the back of the rep,
            // re-seated between the shoulder and the handle so the arms keep
            // their length.
            "elbow": FaultPose(chains: [arms], moves: [.shift(["forearm_*"], up: 0.3), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            "barpath": pressCutShort,
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Cable Chest Press": [
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            "barpath": rangeCutShort,
            "feet": squareLockedStance,
            "scapula": shrugged
        ],
        "Single-Arm Cable Chest Press": [
            "wrist": FaultPose(chains: [leftArmToGrip],
                               moves: [.shift(["hand_L", "hand_L.tip"], up: 0.14), .shift(["forearm_L"], up: 0.1)]),
            "elbow": leftElbowFlared(34),
            // Twisting to push: the working shoulder reaches forward.
            "core": twisted(20),
            "feet": squareLockedStance,
            "scapula": FaultPose(chains: [shoulders, leftArm], moves: [.shift(leftArm, up: 0.12)])
        ],
        "Incline Cable Press": [
            "wrist": wristBentBack(withBar: false),
            "elbow": elbowsFlared(34),
            // Pressing toward the face.
            "barpath": pressedHigh(0.2, withBar: false),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Decline Cable Press": [
            "wrist": wristBentBack(withBar: false),
            "elbow": elbowsFlared(),
            "barpath": pressedHigh(0.2, withBar: false),
            "feet": declineFeetSlipping,
            "scapula": benchShoulders
        ],
        "High-to-Low Cable Fly": [
            // Hands pulled right down to the hips: a fault of the finish, so it
            // shows as the hands come together rather than drooping the arms
            // at the stretch.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: -0.4), .shift(["forearm_*"], up: -0.16)],
                               strength: .between("hand_L", "hand_R", from: 1.5, to: 0.5)),
            "elbow": flyFolded,
            "barpath": flyPressed,
            "feet": squareLockedStance,
            "scapula": shouldersRolledIn
        ],
        "Single-Arm Cable Fly": [
            // Hand hauled across the body, past the other shoulder.
            "wrist": FaultPose(chains: [leftArmToGrip],
                               moves: [.shift(["hand_L", "hand_L.tip"], outward: -0.22), .shift(["forearm_L"], outward: -0.08)]),
            "elbow": FaultPose(chains: [leftArmToGrip],
                               moves: [.shift(["hand_L", "hand_L.tip"], forward: 0.08, outward: -0.14),
                                       .shift(["forearm_L"], up: -0.05, outward: -0.06)]),
            // Twisting to swing the hand across; turned so the twist shows.
            "core": twisted(20).seen(-0.6),
            "feet": squareLockedStance,
            "scapula": FaultPose(chains: [leftArm, ["upper_arm_L", "upper_arm_R"]],
                                 moves: [.shift(leftArm, forward: 0.1, up: 0.03, outward: -0.08)])
        ],
        "Incline Cable Fly": [
            // Stopping with the hands still apart, about shoulder-width: a
            // fault of the finish, so it shows as the hands come together.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.2)],
                               strength: .between("hand_L", "hand_R", from: 1.3, to: 0.7)),
            "elbow": flyBentIntoPress,
            "barpath": flyTooDeep,
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Decline Cable Fly": [
            // Stopping with the hands still apart, a little wider than the
            // shoulders on this small figure: a fault of the finish.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.25)],
                               strength: .between("hand_L", "hand_R", from: 1.3, to: 0.7)),
            "elbow": flyBentIntoPress,
            "barpath": flyTooDeep,
            "feet": declineFeetSlipping,
            "scapula": benchShoulders
        ],
        "Cable Crossover": [
            // Hands meeting high, in front of the face: a fault of the finish,
            // so it shows as the hands come together.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: 0.2), .shift(["forearm_*"], up: 0.09)],
                               strength: .between("hand_L", "hand_R", from: 1.5, to: 0.5)),
            "elbow": flyFolded,
            "barpath": flyPressed,
            "feet": squareLockedStance,
            "scapula": shouldersRolledIn
        ],
        "Single-Arm Landmine Press": [
            "grip": leftWristBentBack,
            "elbow": leftElbowFlared(40, strength: .withBend("forearm_L")),
            // Stopping short: the arm still bent at the top (the elbow re-seated
            // between the shoulder and the hand), turned a little so the bend shows.
            "barpath": FaultPose(chains: [leftArmToGrip],
                                 moves: [.shift(["hand_L", "hand_L.tip"], forward: -0.14, up: -0.1),
                                         .resolve(["forearm_L"])],
                                 strength: .whenStraight("forearm_L"), view: -0.3),
            // Leaning back to press, turned side-on so the lean shows.
            "core": FaultPose(chains: [spine, leftArmToGrip],
                              moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 14),
                                      .shift(["spine"], forward: 0.05)],
                              view: -0.9),
            "feet": squareLockedStance
        ],
        "Incline Push-Up": pushUpFaults.merging(["hands": handsForwardOnBench, "feet": feetSlidBackLevel]) { _, variant in variant },

        // MARK: Batch 133-160 (2026-09-25)
        "Diamond Push-Up": pushUpFaults.merging(["elbow": elbowsFlared().seen(0.8)]) { _, variant in variant },
        "Wide-Grip Push-Up": pushUpFaults,
        "Archer Push-Up": pushUpFaults.merging(["hands": archerHandsNarrow, "elbow": archerElbowFlared,
                                                "depth": archerStoppedHigh]) { _, variant in variant },
        "Medicine Ball Push-Up": pushUpFaults.merging(["elbow": elbowsFlared().seen(0.8)]) { _, variant in variant },
        "Pause Bench Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(),
            // Bounced instead of paused.
            "pause": barBounced,
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Larsen Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(),
            "barpath": pressedHigh(0.26, withBar: true),
            // Feet dropped to find the floor, the knees bending over the end
            // of the bench (where this lifter's knees rest) and the lower back
            // arching: the shins hang straight down, the toes point away.
            "legs": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["foot_*"], forward: -0.62, up: 0.67), .shift(["foot_*.tip"], forward: -0.94, up: 0.56),
                                      .resolve(["shin_*"]), .shift(["spine"], forward: 0.08)]),
            "scapula": benchShoulders
        ],
        "Reverse-Grip Bench Press": [
            "wrist": wristBentBack(withBar: true),
            "elbow": elbowsFlared(30),
            "barpath": pressedHigh(0.2, withBar: true),
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Rack Pull": [
            "spine": backRounded(.withBend("thigh_L")),
            "hips": hipsShotUp,
            "grip": gripTooWide(withBar: true),
            "barpath": barDrifting(0.13, 0.07),
            "lockout": leanedBackAtLockout(withBar: true)
        ],
        "Block Pull": [
            "spine": backRounded(.withBend("thigh_L")),
            "hips": hipsShotUp,
            "grip": gripTooWide(withBar: true),
            "barpath": barDrifting(0.13, 0.07),
            "lockout": leanedBackAtLockout(withBar: true)
        ],
        "Sumo Deadlift": [
            // Feet drawn in to a narrow stance.
            "feet": FaultPose(chains: [legs, hips],
                              moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.2), .resolve(["shin_*"])]),
            "knees": kneesIn(),
            // Gripping outside the knees: at the default 0.13 the hands (20 cm
            // out) only reached 28 cm, still inside the knees (37 cm); 0.42
            // puts them at ~45 cm.
            "grip": gripTooWide(withBar: true, hands: 0.42, forearms: 0.18),
            "spine": backRounded(.withBend("shin_L")),
            "hips": hipsShotUp
        ],
        "Trap Bar Deadlift": [
            // Rocking onto the toes.
            "feet": heelsUp(),
            "knees": kneesIn(),
            "spine": backRounded(.withBend("shin_L")),
            "hips": hipsShotUp,
            "lockout": leanedBackAtLockout(withBar: false)
        ],
        "Snatch-Grip Deadlift": [
            // Hands drawn in toward a normal deadlift grip.
            "grip": FaultPose(chains: [armsToGrip, bar],
                              moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.16), .shift(["forearm_*"], outward: -0.08)]),
            // The upper back rounding, the shoulders dragged forward by the grip.
            "spine": FaultPose(chains: [spine, arms],
                               moves: [.shift(["chest"], forward: -0.06), .shift(["neck"], forward: 0.06), .shift(["head"], forward: 0.16),
                                       .shift(["upper_arm_*", "forearm_*", "hand_*"], forward: 0.08)],
                               strength: .withBend("shin_L")),
            "hips": hipsShotUp,
            "barpath": barDrifting(0.13, 0.07),
            // Starting with the bar over the toes.
            "feet": barDrifting(0.15, 0.08, strength: .withBend("shin_L"))
        ],
        "Deficit Deadlift": [
            // A platform too high to keep the back flat: the back rounding at
            // the bottom (the bar-over-the-toes ghost drew another mistake).
            "feet": backRounded(.withBend("shin_L")),
            "spine": backRounded(.withBend("shin_L")),
            "hips": hipsShotUp,
            "grip": gripTooWide(withBar: true),
            "barpath": barDrifting(0.13, 0.07)
        ],
        "Barbell Yates Row": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: true),
            "grip": gripTooWide(withBar: true),
            // 10 degrees: the Yates Row's head sits just under the mistake badge,
            // and a 20-degree swing drew the ghost's head on the badge's text.
            "feet": trunkLifted(10),
            "scapula": shouldersForward
        ],
        "Reverse-Grip Barbell Row": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: true),
            "grip": gripTooWide(withBar: true),
            "feet": trunkLifted(24),
            "scapula": shouldersForward
        ],
        "Wide-Grip Barbell Row": [
            // Elbows tucked in to the sides.
            "elbow": FaultPose(chains: [arms], moves: [.shift(["forearm_*"], outward: -0.12)],
                               strength: .withBend("forearm_L")),
            "barpath": rowedLow(withBar: true),
            // Grip creeping in toward shoulder-width.
            "grip": FaultPose(chains: [armsToGrip, bar],
                              moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.14), .shift(["forearm_*"], outward: -0.08)]),
            "feet": trunkLifted(24),
            "scapula": shouldersForward
        ],
        "Seal Row": [
            // Seen three-quarter from the head end: side-on (the framing) the
            // winged elbows and the wide hands moved 1-2 px.
            "elbow": elbowsWinged.seen(1.0),
            // Stopping short of the hang: the hands ~12 cm shy of straight arms,
            // shown as the arms straighten (always on, it lifted the hands
            // above the bench at the top of the row).
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.2), .shift(["forearm_*"], forward: -0.09)],
                                 strength: .whenStraight("forearm_L")),
            "grip": gripTooWide(withBar: true).seen(1.0),
            // The chest and head lifting ~10-13 cm off the bench (chestOffPad's
            // 6-8 cm moved 8-11 px on this small figure, under its label).
            "pad": FaultPose(chains: [spine, arms],
                             moves: [.shift(["chest", "upper_arm_*", "forearm_*", "hand_*"], forward: -0.16),
                                     .shift(["neck", "head"], forward: -0.22)]),
            "scapula": shrugged
        ],
        "Meadows Row": [
            "grip": leftWristBentBack,
            // The redone model tucks the working elbow (~10 cm out at the top,
            // 18°), so the shared 0.14 push only reached 32° and, side-on,
            // moved the elbow 8 px: the ghost lay on the arm. Turned half a
            // radian so the lifter's left runs across the screen, the elbow
            // swings ~54 pt out to the side.
            "elbow": leftElbowWingedWide(view: -0.5),
            "brace": leftTwistedOpen,
            "feet": trunkLifted(20),
            "scapula": leftShoulderForward
        ],
        "Single-Arm Landmine Row": [
            "grip": leftWristBentBack,
            "elbow": leftElbowWinged,
            "brace": leftTwistedOpen,
            "feet": trunkLifted(20),
            "scapula": leftShoulderForward
        ],
        "Kettlebell Row": [
            "grip": leftWristBentBack,
            // The elbow rows tucked (7-9° out), so the shared push moved it
            // 10 px, side-on, onto the arm; turned so it swings out sideways.
            "elbow": leftElbowWingedWide(view: -0.5),
            "brace": leftTwistedOpen,
            // 8 degrees: at 20 the ghost's head rose to 107 px and its lines
            // crossed the mistake badge (bottom 127 px), as on the Yates Row.
            "feet": trunkLifted(8),
            "scapula": leftShoulderForward
        ],
        "Landmine Row": [
            "elbow": elbowsWinged,
            "barpath": rowedShort,
            // Reaching for the handle with rounded shoulders.
            "grip": shouldersForward,
            // The torso rising toward upright, the cue's mistake (the rounded
            // back drawn here before is the Reverse-Grip T-Bar Row's). 6
            // degrees: more lifts the head into the mistake badge.
            "feet": trunkLifted(6),
            "scapula": squeezeSkipped
        ],
        "Dumbbell Bent-Over Row": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: false),
            // Dumbbells drifting out to the sides, seen from behind: side-on
            // (the framing) the hands moved 7-10 px, toward and away from the
            // camera.
            "grip": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.13)],
                              view: -1.2),
            // 7 degrees: at 24 the ghost's head rose to 94 px, over the
            // mistake badge's text; at 7 it stays just under it.
            "feet": trunkLifted(7),
            "scapula": shouldersForward
        ],
        "Renegade Row": [
            "body": hipsSagging,
            "hands": handsForward,
            // The rowing (left, first half of the clip) elbow only, seen from
            // behind the feet: elbowsWinged also bent the straight supporting
            // arm and, side-on, moved 2-3 px.
            "elbow": leftElbowWingedWide(view: -1.2),
            // The hips and legs twisting open under the rowing side.
            "hips": FaultPose(chains: [spine, hips, legs],
                              moves: [.turn(pivot: "chest", points: ["spine", "pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip"],
                                            axis: .up, degrees: 18)]),
            // Feet drawn together (ankles ~15 cm apart against the model's
            // 62), seen from behind the feet like the elbow: side-on the
            // feet moved 4-5 px, along the line of sight.
            "feet": FaultPose(chains: [legs],
                              moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.4), .shift(["shin_*"], outward: -0.2)],
                              view: -1.2)
        ],
        "Gorilla Row": [
            "feet": squareLockedStance,
            "spine": backRounded(),
            // The rowing (left, first half of the clip) elbow only:
            // elbowsWinged also bent the straight arm pressing the other bell
            // down and, side-on, moved the elbows 8-10 px.
            "elbow": leftElbowWingedWide(view: -0.5),
            // Twisting to swing each bell up.
            "alternate": FaultPose(chains: [spine, shoulders, arms],
                                   moves: [.turn(pivot: "pelvis", points: trunk, axis: .up, degrees: -20)]),
            "scapula": shouldersForward
        ],
        "Inverted Row": invertedRowFaults,
        "Feet-Elevated Inverted Row": invertedRowFaults,
        "Underhand Inverted Row": invertedRowFaults,

        // MARK: Batch 161-190 (2026-09-25)
        "Wide-Grip Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward.seen(0.5),
            "grip": gripTooWide(withBar: false, hands: 0.25, forearms: 0.1),
            "barpath": chinCraned.seen(0.5),
            "feet": kipping
        ],
        "Neutral-Grip Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward.seen(0.5),
            "grip": palmsInWristsBentBack,
            "barpath": chinCraned.seen(0.5),
            "feet": kipping
        ],
        "Archer Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward.seen(0.5),
            "grip": gripTooNarrow(withBar: false),
            "barpath": hangingShort,
            "feet": kipping
        ],
        "Weighted Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward.seen(0.5),
            "grip": gripTooWide(withBar: false),
            "barpath": chinCraned.seen(0.5),
            "feet": kipping
        ],
        "Assisted Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward.seen(0.5),
            "grip": gripTooNarrow(withBar: false),
            "barpath": chinCraned.seen(0.5),
            // Pushing through the knees: the whole body pressed up off the pad.
            "feet": FaultPose(chains: [spine, legs],
                              moves: [.shift(["pelvis", "spine", "chest", "neck", "head", "thigh_*", "shin_*", "foot_*", "foot_*.tip"], up: 0.12)])
        ],
        "Machine Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward.seen(0.5),
            "grip": gripTooNarrow(withBar: false),
            "barpath": chinCraned.seen(0.5),
            // Knees bending to push off the platform, turned so the knees
            // come forward across the view instead of into it.
            "feet": FaultPose(chains: [legs, hips], moves: [.shift(["shin_*"], forward: 0.22)], view: 0.5)
        ],
        "Neutral-Grip Chin-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward,
            "grip": wristBentBack(withBar: false),
            "barpath": hangingShort,
            "feet": kipping
        ],
        "Weighted Chin-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward.seen(0.5),
            "grip": gripTooWide(withBar: false),
            "barpath": hangingShort,
            "feet": kipping
        ],
        // The pulldowns below are framed from behind-left (yaw -2.6): their
        // lean-back faults turn +0.9 (total -1.7, nearly the left side), where
        // the trunk tips back across the screen instead of sideways, and the
        // seat faults are drawn as a rise (`risenOffSeat`), which reads from
        // behind.
        "Wide-Grip Lat Pulldown": [
            "spine": trunkLifted(26).seen(0.9),
            "elbow": pulldownFlared,
            "grip": gripTooWide(withBar: true),
            "barpath": pulledBehindNeck,
            "feet": risenOffSeat
        ],
        "Reverse-Grip Lat Pulldown": [
            "spine": trunkLifted(26).seen(0.9),
            "elbow": pulldownFlared,
            "grip": gripTooWide(withBar: true),
            "barpath": pulldownShort,
            "feet": risenOffSeat
        ],
        "Neutral-Grip Lat Pulldown": [
            "spine": trunkLifted(26).seen(0.9),
            "elbow": pulldownFlared,
            "grip": wristBentBack(withBar: false),
            "barpath": pulledBehindNeck,
            "feet": risenOffSeat
        ],
        "V-Bar Lat Pulldown": [
            "spine": trunkLifted(26).seen(0.9),
            "elbow": pulldownFlared,
            "grip": wristBentBack(withBar: false),
            "barpath": pulledPastChest,
            "feet": risenOffSeat
        ],
        "Kneeling Lat Pulldown": [
            "spine": trunkLifted(20).seen(0.9),
            "elbow": pulldownFlared,
            "grip": gripTooWide(withBar: true),
            "barpath": pulledBehindNeck,
            // Sitting back toward the heels.
            "feet": FaultPose(chains: [spine, hips, legs],
                              moves: [.shift(["pelvis", "thigh_*"], forward: -0.14, up: -0.08), .shift(["spine"], forward: -0.07)])
        ],
        "Rope Lat Pulldown": [
            "spine": trunkLifted(26),
            "elbow": pulldownFlared,
            "grip": wristBentBack(withBar: false),
            // The hands kept together instead of splitting the rope.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.1), .shift(["forearm_*"], outward: -0.05)],
                                 strength: .withBend("forearm_L")),
            "feet": slidForward
        ],
        "Machine Lat Pulldown": [
            "spine": trunkLifted(26).seen(0.9),
            "elbow": pulldownFlared,
            "grip": shrugged,
            "barpath": leverPulldownShort,
            "feet": risenOffSeat
        ],
        "Iso-Lateral Lat Pulldown": [
            "spine": trunkLifted(26).seen(0.9),
            "elbow": pulldownFlared,
            "grip": shrugged,
            // Leaning over to the working side.
            "barpath": FaultPose(chains: [spine, shoulders],
                                 moves: [.turn(pivot: "pelvis", points: trunk, axis: .forward, degrees: -12)]),
            "feet": risenOffSeat
        ],
        "Single-Arm Lat Pulldown": [
            "core": leftTwistedOpen,
            "elbow": leftElbowWinged,
            "grip": leftWristBentBack,
            "barpath": leftPullShort,
            "feet": risenOffSeat
        ],
        "Wide-Grip Seated Cable Row": [
            "scapula": shouldersForward,
            "elbow": elbowsWinged,
            "grip": gripTooNarrow(withBar: false),
            "barpath": rowedLow(withBar: false),
            "torso": trunkLifted(18)
        ],
        "Close-Grip Seated Cable Row": [
            "scapula": shouldersForward,
            "elbow": elbowsWinged,
            "grip": wristBentBack(withBar: false),
            "barpath": rowedHigh(withBar: false),
            "torso": trunkLifted(18)
        ],
        "High Cable Row": [
            "scapula": shouldersForward,
            "elbow": elbowsWinged,
            "grip": wristBentBack(withBar: false),
            "barpath": rowedLow(withBar: false),
            "torso": trunkLifted(18)
        ],
        "Low Cable Row": [
            "scapula": shouldersForward,
            "elbow": elbowsWinged,
            "grip": backRounded(),
            "barpath": rowedHigh(withBar: false),
            "torso": trunkLifted(18)
        ],
        "Standing Cable Row": [
            "scapula": shouldersForward,
            "elbow": elbowsWinged,
            "grip": wristBentBack(withBar: false),
            "barpath": rowedShort,
            "torso": squareLockedStance
        ],
        "Single-Arm Cable Row": [
            "scapula": leftShoulderForward,
            "elbow": leftElbowWinged,
            "grip": leftWristBentBack,
            "core": leftTwistedOpen,
            "torso": trunkLifted(18)
        ],
        "Half-Kneeling Cable Row": [
            "scapula": leftShoulderForward,
            "elbow": leftElbowWinged,
            "grip": leftWristBentBack,
            "core": leftTwistedOpen,
            "stance": lowerBackArched(0.1)
        ],
        "Machine Seated Row": [
            "pad": chestOffPad,
            "elbow": elbowsWinged,
            "grip": shouldersForward,
            "barpath": rowedShort,
            "scapula": shrugged
        ],
        "Iso-Lateral Row Machine": [
            "pad": chestOffPad,
            "elbow": leftElbowWinged,
            "grip": shouldersForward,
            "barpath": trunkTwisted,
            "scapula": shrugged
        ],
        "Single-Arm Machine Row": [
            "pad": chestOffPad,
            "elbow": leftElbowWinged,
            "grip": leftShoulderForward,
            "brace": leftTwistedOpen,
            "scapula": leftShrugged
        ],
        "Reverse-Grip T-Bar Row": [
            "elbow": elbowsWinged,
            "barpath": rowedShort,
            "grip": shouldersForward,
            "feet": backRounded(),
            "scapula": squeezeSkipped
        ],
        "Dumbbell Pullover Row": [
            "grip": wristBentBack(withBar: false),
            "elbow": pulloverElbowsBent(withBar: false),
            // The 2026-09-30 model's upper arms stop ~25° short of the line of
            // the torso, so the shared 25° only brought them level with it,
            // the wrists still above the bench pad; 45° takes them ~20° below
            // the line, the wrists ~14 cm under the pad top, beside the bench.
            "arc": pulloverTooDeep(withBar: false, degrees: 45),
            "ribs": lowerBackArched(0.1, pulloverStretch),
            "feet": benchFeet
        ],
        "Machine Pullover": [
            // Pulling with the hands: the elbows bend further.
            "elbow": FaultPose(chains: [armsToGrip],
                               moves: [.turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: 40)]),
            "grip": wristBentBack(withBar: false),
            // Starting short of the stretch: the arms held lower overhead. The
            // forearms keep their slope back to the bar, so the hands drop with
            // the elbows; turning the bent arm alone swung the forearms upright
            // and left the hands as high as the lifter's (2026-09-30 QA).
            "arc": FaultPose(chains: [armsToGrip],
                             moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -35),
                                     .turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: 35)],
                             strength: .between("hand_L", "pelvis", from: 1.0, to: 1.5)),
            "spine": lowerBackArched(0.1),
            "scapula": shrugged
        ],

        // MARK: Back
        "Deadlift": [
            // Bar drifting out in front of the shins.
            "barpath": FaultPose(chains: [armsToGrip, bar],
                                 moves: [.shift(["hand_*", "hand_*.tip"], ahead: 0.13), .shift(["forearm_*"], ahead: 0.07)]),
            "hips": hipsShotUp,
            // Starting with the bar over the toes.
            "feet": FaultPose(chains: [armsToGrip, bar],
                              moves: [.shift(["hand_*", "hand_*.tip"], ahead: 0.15), .shift(["forearm_*"], ahead: 0.08)],
                              strength: .withBend("shin_L")),
            "spine": backRounded(.withBend("shin_L"))
        ],
        "Barbell Bent-Over Row": [
            // The 2026-09-29 model already rows with the elbows ~30° out, so
            // the fault swings the upper arms out toward shoulder height.
            "elbow": elbowsFlared(35),
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
            // The trunk twisting open to heave the dumbbell; the supporting
            // hand stays planted on the bench (only its shoulder turns).
            "feet": FaultPose(chains: [spine, shoulders, ["upper_arm_L", "forearm_L", "hand_L"]],
                              moves: [.turn(pivot: "pelvis",
                                            points: ["spine", "chest", "neck", "head", "upper_arm_*", "forearm_L", "hand_L", "hand_L.tip"],
                                            axis: .up, degrees: -20)]),
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
            "elbow": elbowsForward,
            "barpath": chinCraned,
            "grip": gripTooWide(withBar: false),
            "feet": kipping,
            "scapula": shrugged
        ],
        "Chin-Up": [
            "elbow": elbowsWinged,
            "barpath": hangingShort,
            "grip": gripTooWide(withBar: false),
            "feet": kipping,
            "scapula": shrugged
        ],
        "Lat Pulldown": [
            "elbow": pulldownFlared,
            "barpath": pulledBehindNeck,
            "grip": gripTooWide(withBar: true),
            "feet": slidForward,
            // Rocking far back on every rep.
            "spine": trunkLifted(26)
        ],
        "Close-Grip Lat Pulldown": [
            "elbow": pulldownFlared,
            "barpath": pulledPastChest,
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
            // Pushed straight down: the hands come in toward the body. Two
            // separate handles, so no bar line between the hands.
            "barpath": FaultPose(chains: [armsToGrip],
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
            "barpath": rowedShort,
            // Reaching for the handles with rounded shoulders.
            "grip": shouldersForward,
            "feet": backRounded(),
            "scapula": squeezeSkipped
        ],
        "Chest-Supported Row Machine": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: false),
            "grip": chestOffPad,
            // Driving through the legs: the body pushed back off the pad, the
            // knees opening under it with the feet still on the foot rests.
            "feet": FaultPose(chains: [spine, legs],
                              moves: [.shift(["pelvis", "spine", "chest", "neck", "head", "thigh_*"], forward: -0.16),
                                      .resolve(["shin_*"])]),
            // Stopping short of the squeeze.
            "scapula": FaultPose(chains: [arms],
                                 moves: [.shift(["upper_arm_*"], forward: 0.1), .shift(["forearm_*"], forward: 0.18)],
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
            // The lower-back version since 2026-09-30: the hips rest on the pad,
            // the pelvis turning only about 22°, while the spine curls over its
            // edge, seen near side-on from behind-left, so the moves stay in the
            // plane the camera sees. The faults of the bottom read from the
            // neck's distance to the ankle (about 2.23 torso lengths at the
            // bottom, 2.43 at the top): next to none at the top, all of it from
            // the bottom's hold.
            //
            // Arching past neutral at the top: the lower back, then the upper
            // back, bending backward (the crossed arms turned with it only
            // tangled the line under the mistake bar), showing only near the
            // top of the rep and gone before the curl deepens.
            "spine": FaultPose(chains: [spine],
                               moves: [.turn(pivot: "spine", points: ["chest", "neck", "head"], axis: .lateral, degrees: 14),
                                       .turn(pivot: "chest", points: ["neck", "head"], axis: .lateral, degrees: 12)],
                               strength: .between("neck", "foot_L", from: 2.40, to: 2.425)),
            // The glute and hamstring version: the back held flat and the fold
            // coming from the hips. The curl is undone at the upper and lower
            // back (about 38° and 34° at the bottom) and the straight trunk
            // tipped 49° at the hips, onto the line from the pelvis to the neck,
            // with the thighs drawn to show the hip closing.
            "hips": FaultPose(chains: [spine, ["shin_*", "thigh_*"], hips],
                              moves: [.turn(pivot: "chest", points: ["neck", "head"], axis: .lateral, degrees: 38),
                                      .turn(pivot: "spine", points: ["chest", "neck", "head"], axis: .lateral, degrees: 34),
                                      .turn(pivot: "pelvis", points: ["spine", "chest", "neck", "head"], axis: .lateral, degrees: -49)],
                              strength: .between("neck", "foot_L", from: 2.43, to: 2.26)),
            // Arms flung forward to yank the body up: uncrossed and reaching
            // out straight ahead of the shoulders (about level at the top of
            // the rep). Turning the crossed arms about the shoulders only
            // bunched them over the head, seen side-on.
            "grip": FaultPose(chains: [arms],
                              moves: [.shift(["hand_*"], forward: 0.38, up: 0.48, outward: 0.58),
                                      .shift(["forearm_*"], forward: -0.08, up: 0.32, outward: 0.2)]),
            // Feet slipping out from under the roller: slid down the foot
            // plate (about 55° steep), away from the roller, in the room's
            // directions, since the body's own up turns over with the curling
            // spine; `ahead` stays toward the head all rep.
            "feet": FaultPose(chains: [legs],
                              moves: [.shift(["foot_*", "foot_*.tip"], ahead: 0.07, rise: -0.10),
                                      .shift(["shin_*"], ahead: 0.035, rise: -0.05)]),
            // The pad set below the hip bones: the pelvis tips forward over its
            // edge, so the curled trunk drops further at the hips.
            "thigh": FaultPose(chains: [spine, ["shin_*", "thigh_*"], hips],
                               moves: [.turn(pivot: "pelvis", points: ["spine", "chest", "neck", "head"], axis: .lateral, degrees: -24)],
                               strength: .between("neck", "foot_L", from: 2.43, to: 2.26))
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
            // The back hip sinking. The back knee stays where it is: at the
            // bottom it is already just above the floor, and re-seating it
            // under the lowered hip (`.resolve`) put the knee joint 0.5 cm
            // under the floor on the 2026-09-30 model (and at floor level on
            // the one before), in the still the mistake is shot at.
            "hips": FaultPose(chains: [["thigh_L", "pelvis", "thigh_R"], leg("R")],
                              moves: [.shift(["thigh_R"], rise: -0.16), .shift(["pelvis"], rise: -0.08)],
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
            // A short, narrow step: the front foot lands ~26 cm short and ~3 cm
            // in, and the knee, re-seated under the same hips, shoots ~5 cm
            // past the toes (at -0.25 it stopped ~5 cm behind them).
            "step": FaultPose(chains: [leg("front"), hips],
                              moves: [.shift(["foot_front", "foot_front.tip"], outward: -0.05, ahead: -0.45), .resolve(["shin_front"])],
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
            // The hips drifting ~17 cm forward: the front knee ~3 cm past the
            // toes, the back knee opening off the floor (at 0.14 the knee
            // stopped ~3 cm behind the toes).
            "knee": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(carried, ahead: 0.28), .resolve(["shin_*"])],
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
            // Framed rear three-quarter (-2.0) since 2026-09-30, like the
            // 45-degree presses: the sagittal faults need no turn, and the
            // side-to-side ones turn toward a view from behind the head.
            // Feet too narrow on the platform.
            "feet": FaultPose(chains: [legs, hips],
                              moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.1), .shift(["shin_*"], outward: -0.08)],
                              view: -0.7),
            "knee": kneesIn().seen(-0.7),
            // Sinking so deep the hips roll off the seat.
            "range": FaultPose(chains: [spine, legs, hips],
                               moves: [.shift(["pelvis", "thigh_*"], forward: 0.1), .shift(["spine"], forward: 0.05), .resolve(["shin_*"])],
                               strength: .withBend("shin_L")),
            "lockout": kneesSnapped,
            "back": lowerBackArched(0.14)
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
            // Stopping short: the hips sag below the line. The bridges' small
            // figures (zoom 0.474) need about 9 cm of sag, ~10 px, to show.
            "hips": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_*"], rise: -0.22), .shift(["spine"], rise: -0.11), .resolve(["shin_*"])],
                              strength: .whenStraight("thigh_L")),
            // An arched lower back: the lumbar spine ~9 cm (~10 px) up.
            "ribs": bridgeArched(0.22, chest: 0.1),
            // Feet walked too far from the hips.
            "feet": FaultPose(chains: [legs, hips], moves: [.shift(["foot_*", "foot_*.tip"], ahead: -0.2), .resolve(["shin_*"])]),
            "knee": kneesIn("*", 0.2).seen(-0.9)
        ],
        "Single-Leg Glute Bridge": [
            // The lifted side's hip sagging, seen from the feet end like the
            // knee so the pelvis visibly tips (~9 px on this small figure).
            "hips": FaultPose(chains: [["thigh_L", "pelvis", "thigh_R"], leg("R")],
                              moves: [.shift(["thigh_R", "shin_R", "foot_R", "foot_R.tip"], rise: -0.25), .shift(["pelvis"], rise: -0.12)],
                              strength: .whenStraight("thigh_L"), view: -0.9),
            "drive": heelsUp("L"),
            "knee": kneesIn("L", 0.25).seen(-0.9),
            // Kicking the free leg up to swing the hips.
            "free": FaultPose(chains: [leg("R"), hips],
                              moves: [.turn(pivot: "thigh_R", points: ["shin_R", "foot_R", "foot_R.tip"], axis: .lateral, degrees: 30)]),
            "ribs": bridgeArched(0.22, chest: 0.1)
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
            // Turned to -0.9 so the raised toes stand clear of the shin rather
            // than lying along it.
            "foot": toesUp(50, .between("foot_L", "foot_R", from: 0.43, to: 1.26)).seen(-0.9),
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
            // Turned to -0.9 so the raised toes stand clear of the shin rather
            // than lying along it.
            "foot": toesUp(75, .between("foot_L", "foot_R", from: 0.49, to: 1.14)).seen(-0.9),
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
            // Seen from the lifter's left like the other four: the wrist bends
            // back in the sagittal plane, which the front-on framing looks
            // straight along.
            "grip": wristBentBack(withBar: true).seen(-0.6),
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
            // Elbows flared out and pulled behind the body at the bottom. The
            // 2026-09-29 model holds the elbows ~12 cm ahead of the shoulders
            // there (~6 cm before), so the shift back is larger to bring the
            // ghost's elbows in line with the shoulders again.
            "elbow": FaultPose(chains: [armsToGrip], moves: [.shift(["forearm_*"], forward: -0.22, outward: 0.05), .resolve(["forearm_*"])],
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
            // Sat up until the trunk stands near upright over the hips, as far
            // up toward the knees as the sheet says (40 stopped halfway).
            "curl": satUp(60),
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
        ],
        // MARK: Batch 191-240 (2026-09-26)
        // MARK: Batch 191-240 barbell, Smith and landmine presses (2026-09-26)
        // Framed at yaw -0.8 (seated, behind-the-neck, push press), -1.3 (Z
        // press), -0.6 (Smith) and -1.0 (landmines, Viking): sagittal faults
        // turn to a total of about -1.4, side-to-side ones on the landmines
        // and Viking turn toward face-on (about -0.4); the behind-the-neck
        // depth fault is seen from behind-left (-2.3).
        "Seated Barbell Overhead Press": [
            // Leaning back from the hips, the lower back arching.
            "torso": leanedBack(12, arch: 0.08, withBar: true).seen(-0.6),
            // Pressed out around the face: locked out in front of the head.
            "barpath": armsTurned(.lateral, -18, withBar: true, strength: .whenStraight("forearm_L")).seen(-0.6),
            "grip": wristBentBack(withBar: true),
            // Short reps: the bar stops at the nose instead of the chin
            // (0.16 torso lengths is ~9 cm on this model).
            "depth": barHeldHigh(withBar: true),
            "feet": feetTucked.seen(-0.6)
        ],
        "Behind-the-Neck Press": [
            // A narrow grip: the hands ~12 cm further in each, the elbows
            // left where they were, so the forearms slant in instead of
            // standing straight up. Turned toward face-on (total -0.3).
            "grip": FaultPose(chains: [armsToGrip, bar],
                              moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.2), .shift(["forearm_*"], outward: -0.04)],
                              view: 0.5),
            // Bar forced further down the back of the neck than the
            // shoulders allow: the hands sink lower behind it (about 8 cm
            // down, 3.5 cm back), turning the shoulders further out. Seen
            // from behind-left (total -2.3): the bar lies against the back
            // of the neck, the two arms split apart and the plates sit well
            // out to the sides, clear of the hands.
            "depth": FaultPose(chains: [armsToGrip, bar],
                               moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.06, up: -0.14), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L"), view: -1.5),
            // Upper back rounding, the head pushed forward to let the bar pass.
            "head": headDropped(.withBend("forearm_L")).seen(-0.6),
            "brace": leanedBack(10, arch: 0.08, withBar: true).seen(-0.6),
            // Locked out in front of the face instead of over the neck. This
            // model locks out ~3 cm behind the shoulders, so it needs a
            // bigger swing than the front presses: -25° puts the bar ~19 cm
            // ahead of them, clearly in front of the face.
            "lockout": armsTurned(.lateral, -25, withBar: true, strength: .whenStraight("forearm_L")).seen(-0.6)
        ],
        "Push Press": [
            // The arms pressing during the dip: the bar rises before the legs
            // drive. Shown only in the dip.
            "rack": barHeldHigh(withBar: true, strength: pushPressDip),
            "lockout": armsTurned(.lateral, -18, withBar: true, strength: .whenStraight("forearm_L")).seen(-0.6),
            "brace": leanedBack(12, arch: 0.08, withBar: true).seen(-0.6),
            // The chest tipping forward in the dip, the bar going with it.
            "dip": leanedForward(16, withBar: true, strength: pushPressDip).seen(-0.6),
            // Rocking onto the toes in the dip (heelsUp, read off the dip
            // rather than the knee, which stays soft at ~157° standing).
            "heels": FaultPose(chains: [legs],
                               moves: [.turn(pivot: "foot_*.tip", points: ["foot_*"], axis: .lateral, degrees: -24),
                                       .resolve(["shin_*"])],
                               strength: pushPressDip, view: -0.6)
        ],
        "Z Press": [
            // Slumped: the lower back rounding back, the chest sinking and
            // the head dropping forward (a deeper `backRounded`, with the
            // chest, neck and head also coming down). Framed side-on already.
            "torso": FaultPose(chains: [spine],
                               moves: [.shift(["spine"], forward: -0.10), .shift(["chest"], forward: -0.05, up: -0.05),
                                       .shift(["neck"], forward: 0.06, up: -0.07), .shift(["head"], forward: 0.15, up: -0.09)]),
            "brace": leanedBack(12, arch: 0.06, withBar: true),
            "barpath": armsTurned(.lateral, -18, withBar: true, strength: .whenStraight("forearm_L")),
            "grip": wristBentBack(withBar: true),
            // Turned toward front three-quarter (total -0.8, as the seated
            // press): side-on, the near plate hides the face and the real bar.
            "depth": barHeldHigh(withBar: true).seen(0.5)
        ],
        "Smith Machine Shoulder Press": [
            // Bench set too far back from the fixed bar: the body sits ~13 cm
            // back, the hands stay on the bar (drawn as the fixed reference)
            // and the upper arms angle forward to it. The legs are left out:
            // they only added near-parallel lines.
            "bench": FaultPose(chains: [spine, armsToGrip, bar],
                               moves: [.shift(["pelvis", "thigh_*", "upper_arm_*"] + torso, ahead: -0.22),
                                       .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L"), view: -0.8),
            "back": lowerBackArched(0.12).seen(-0.8),
            // Elbows flared out and back behind the bar at the bottom (~14 cm
            // each), turned near face-on (total -0.2) so both open out alike.
            "elbow": FaultPose(chains: [armsToGrip], moves: [.shift(["forearm_*"], forward: -0.1, outward: 0.25), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L"), view: 0.4),
            // Short reps: the bar stops at the chin instead of the
            // collarbones (0.16 torso lengths is ~9 cm on this model).
            "depth": barHeldHigh(withBar: true),
            "feet": feetTucked.seen(-0.8)
        ],
        "Landmine Shoulder Press": [
            "elbow": leftElbowFlared(40, strength: .withBend("forearm_L")).seen(0.5),
            "path": leftPressedAcross,
            // The 2026-09-30 model leans ~5° forward at the bottom and ~10° at
            // lockout, so a 14° lean back only brought the ghost to about
            // upright at the top; 20° puts it ~10° behind upright there, as
            // the old model's ghost was, and ~15° at the bottom.
            "core": leanedBack(20, arch: 0.05).seen(-0.4),
            // Twisting the pressing shoulder forward.
            "twist": leftShoulderTwistedForward,
            // Feet brought level, side by side, instead of split: each ankle
            // sits ~0.3 m (0.5 torso lengths) ahead of or behind the hips, so
            // this puts both under them. The legs are drawn straight between
            // hip and ankle (re-seating the knees would squat them to ~140°).
            // Turned to a total of -1.4, side-on, so the feet close up.
            "stance": FaultPose(chains: [legs],
                                moves: [.shift(["foot_R", "foot_R.tip"], ahead: -0.5),
                                        .shift(["foot_L", "foot_L.tip"], ahead: 0.5),
                                        .straighten(["shin_*"])],
                                view: -0.4)
        ],
        "Half-Kneeling Landmine Press": [
            "elbow": leftElbowFlared(40, strength: .withBend("forearm_L")).seen(0.5),
            "path": leftPressedAcross,
            "core": leanedBack(14, arch: 0.05).seen(-0.4),
            "twist": leftShoulderTwistedForward,
            // Sitting back toward the back heel, the trunk bending forward
            // at the hip: the hips ~13 cm back and ~7 cm down.
            "stance": FaultPose(chains: [spine, hips, legs],
                                moves: [.shift(["pelvis", "thigh_*"], forward: -0.22, up: -0.12), .shift(["spine"], forward: -0.1)],
                                view: -0.4)
        ],
        "Viking Press": [
            // The wrists bent back. The palms face in on these handles, so the
            // backs of the hands tip out, about the chest's axis; the
            // side-to-side turn of `wristBentBack` would only tilt them within
            // the palm. Uses the dumbbell family's `palmsInWristsBentBack`
            // (already in FaultPoses.swift), turned toward face-on (total
            // -0.4) so the tilt shows.
            "grip": palmsInWristsBentBack.seen(0.6),
            // Elbows flared out to the sides at the bottom.
            "elbow": FaultPose(chains: [arms],
                               moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*"], axis: .forward, degrees: 38)],
                               strength: .withBend("forearm_L"), view: 0.6),
            // Stopping short: the arms still bent at the top. The handles
            // stop ~9 cm short and the elbows drop under the arms before
            // they are re-seated, so the bend (~112° from the model's ~161°)
            // opens downward, where the side-on view (total -1.4) shows it.
            "path": FaultPose(chains: [armsToGrip],
                              moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.14, up: -0.12),
                                      .shift(["forearm_*"], up: -0.14), .resolve(["forearm_*"])],
                              strength: .whenStraight("forearm_L"), view: -0.4),
            "core": leanedBack(14, arch: 0.06).seen(-0.4),
            // Dipping the knees to drive the handles up.
            "feet": FaultPose(chains: [spine, legs, hips, armsToGrip],
                              moves: [.shift(carried, rise: -0.12), .resolve(["shin_*"])], view: -0.4)
        ],
        // MARK: Batch 191-240 dumbbell and cable presses (2026-09-26)
        "Dumbbell Push Press": [
            // The chest tipping forward in the dip, turned side-on so the lean shows.
            "dip": leanedForward(14, strength: dumbbellPushPressDip).seen(-0.8),
            // Sinking into a half squat: the hips drop ~12 cm below the real dip,
            // the knees close from ~122° to ~94°.
            "depth": FaultPose(chains: [spine, legs, hips, armsToGrip],
                               moves: [.shift(carried, rise: -0.2), .resolve(["shin_*"])],
                               strength: dumbbellPushPressDip, view: -0.6),
            // Up on the toes in the dip.
            "heels": FaultPose(chains: [legs],
                               moves: [.turn(pivot: "foot_*.tip", points: ["foot_*"], axis: .lateral, degrees: -24),
                                       .resolve(["shin_*"])],
                               strength: dumbbellPushPressDip, view: -0.8),
            // Elbows dropped back behind the dumbbells (and the shoulders) in the rack.
            "elbow": pressElbowsDraggedBack("*"),
            // Finished in front of the face, the arms angled forward.
            "lockout": armsTurned(.lateral, -18, strength: .whenStraight("forearm_L")).seen(-0.8)
        ],
        "Standing Dumbbell Press": [
            "elbow": pressElbowsDraggedBack("*"),
            "lockout": pressLockoutBent("*"),
            "brace": leanedBack(12, arch: 0.08).seen(-0.8),
            "wrist": wristBentBack(withBar: false).seen(-0.8),
            "stance": pressKneesDipped
        ],
        "Seated Dumbbell Press": [
            "elbow": pressElbowsDraggedBack("*"),
            // Drifting wide at the top: the hands ~74 cm apart against the real
            // 47, the arms tilting ~19° out in a clear V. The hands sink ~2 cm
            // as they swing out, so the arms keep their length (elbows ~167°).
            "path": FaultPose(chains: [armsToGrip],
                              moves: [.shift(["hand_*", "hand_*.tip"], up: -0.05, outward: 0.28), .resolve(["forearm_*"])],
                              strength: .whenStraight("forearm_L")),
            // Short reps: the dumbbells turn round at forehead height.
            "depth": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: 0.16), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            // Leaning back toward the pad, the lower back arched.
            "torso": leanedBack(12, arch: 0.08).seen(-1.0),
            "feet": pressFeetTucked.seen(-1.0)
        ],
        "Neutral-Grip Dumbbell Shoulder Press": [
            "grip": palmsInWristsBentBack,
            // The elbows flaring out to the sides while the palms stay in.
            "elbow": FaultPose(chains: [armsToGrip],
                               moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*"], axis: .forward, degrees: 40),
                                       .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            // Stopped with the dumbbells in front of the face.
            "lockout": armsTurned(.lateral, -20, strength: .whenStraight("forearm_L")).seen(-0.8),
            // Arched off the pad.
            "back": lowerBackArched(0.12).seen(-0.9),
            "feet": pressFeetTucked.seen(-0.9)
        ],
        "Single-Arm Dumbbell Shoulder Press": [
            "core": pressLeanedAway,
            "elbow": pressElbowsDraggedBack("L"),
            "lockout": pressLockoutBent("L"),
            "brace": leanedBack(12, arch: 0.08).seen(-0.8),
            "stance": pressKneesDipped
        ],
        "Cable Shoulder Press": [
            // The cables dragging the elbows back behind the shoulders.
            "elbow": pressElbowsDraggedBack("*"),
            // The cables pulling the arms back behind the head at lockout.
            "lockout": armsTurned(.lateral, 14, strength: .whenStraight("forearm_L")).seen(-0.8),
            "brace": leanedBack(12, arch: 0.08).seen(-0.8),
            "stance": cableFeetTogetherLocked,
            "wrist": wristBentBack(withBar: false).seen(-0.8)
        ],
        "Single-Arm Cable Shoulder Press": [
            "core": pressLeanedAway,
            "elbow": pressElbowsDraggedBack("L"),
            // The cable pulling the arm back behind the head at lockout.
            "lockout": armsTurned(.lateral, 14, side: "L", strength: .whenStraight("forearm_L")).seen(-0.8),
            "brace": leanedBack(12, arch: 0.08).seen(-0.8),
            "stance": cableFeetTogetherLocked
        ],
        // MARK: Batch 191-240 lateral and cuff (2026-09-26)
        "Leaning Lateral Raise": [
            // Standing up out of the lean: the trunk back upright over the hips.
            "lean": leftArmTrunkTipped(-14),
            "traps": leftShrugged,
            // Bending the elbow as the dumbbell rises; none at the bottom
            // (hand_L to thigh_L ~0.38 there, ~1.4 at the top).
            "elbow": elbowsFolded(.forward, -60, side: "L", strength: .between("hand_L", "thigh_L", from: 0.6, to: 1.0)),
            "range": leftRaiseShortAtBottom,
            // Hauling on the upright: the trunk tips further toward it, the
            // rack arm bends, and the dumbbell arm is carried up with the
            // trunk, the swing.
            "support": FaultPose(chains: [spine, shoulders, ["upper_arm_R", "forearm_R", "hand_R"], arm("L")],
                                 moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"] + arm("L").dropFirst(),
                                               axis: .forward, degrees: 12),
                                         .shift(["forearm_R"], forward: -0.04, up: -0.08),
                                         .resolve(["forearm_R"])]),
        ],
        "Incline Lateral Raise": [
            // Rolling back off the pad, seen along the body: the shoulder
            // line turns ~0.19 torso lengths at each end, so the trunk roll
            // shows and not only the arm sweep of the path ghost.
            "body": leftRolledBack(35).seen(-0.8),
            "traps": leftShruggedLying,
            // Bending the elbow as the dumbbell rises; none at the bottom.
            "elbow": elbowsFolded(.forward, -60, side: "L", strength: .between("hand_L", "thigh_L", from: 0.6, to: 1.0)),
            "range": leftRaiseShortAtBottom,
            // The arm swept back behind the body.
            "path": armsTurned(.up, -25, side: "L").seen(-0.8),
        ],
        "Chest-Supported Lateral Raise": [
            // The trunk rising off the pad about the hips, a wedge opening
            // between chest and pad (neck 0.26, head 0.31 torso lengths).
            "pad": leanedBack(15).seen(1.2),
            // Shrugging toward the ears, big enough to read against the pad
            // and seen from the pad's side, where the neck-to-shoulder gap closes.
            "traps": FaultPose(chains: [["head", "neck"], shoulders, arms],
                               moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.3)]).seen(1.2),
            // Elbows bending, the dumbbells hanging below them: a row. Shown as
            // the arms rise (hand_L to pelvis ~0.98 hanging, ~1.56 level).
            "elbow": elbowsFolded(.up, 60, strength: .between("hand_L", "pelvis", from: 1.1, to: 1.4)),
            // Arms pulled back toward the ceiling, behind the shoulders. Shown
            // as the arms rise: hanging, the same turn swings them out to the
            // sides, which is the correct path. Seen from the rear-left: from
            // straight behind, back toward the ceiling runs up the screen like
            // the height ghost; here the hands go up and toward the hips, the
            // height ghost's up and toward the head.
            "path": armsTurned(.up, -25, strength: .between("hand_L", "pelvis", from: 1.1, to: 1.4)).seen(0.9),
            // Swung above shoulder level, shown near the top.
            "height": armsTurned(.forward, 40, strength: .between("hand_L", "pelvis", from: 1.3, to: 1.55)),
        ],
        "Y-Raise": [
            // The chest and head lifting off the pad, the lower back arching
            // toward it and the arms rising with the trunk. Nearer behind than
            // side-on, so the overhead arms stay in frame.
            "pad": leanedBack(15, arch: 0.06).seen(0.6),
            "traps": proneShrugged.seen(0.6),
            // Craning the head up off the line of the spine. `head.tip` draws
            // the head itself (the head bone runs to the crown), so the crown
            // moves ~0.25 torso lengths rather than the skull base's 0.12.
            "neck": FaultPose(chains: [["chest", "neck", "head", "head.tip"]],
                              moves: [.turn(pivot: "neck", points: ["head", "head.tip"], axis: .lateral, degrees: 40)]).seen(0.9),
            // Elbows bending, the hands dropping toward the floor; shown as
            // the arms rise (hand_L to pelvis ~0.91 hanging, ~1.84 at the top).
            "elbow": elbowsFolded(.lateral, -50, strength: .between("hand_L", "pelvis", from: 1.2, to: 1.6)),
            "height": overheadShort,
        ],
        "Cable Y-Raise": [
            // Leaning back 20° with the lower back arched, seen rear-left at
            // about -2.35 in all: from the true side the near tower hides the
            // upper body and the lean, and since the 2026-09-30 model (station
            // moved 11 cm) it hides them from -2.0 as well. Drawn to the
            // elbows: with the hands overhead the tipped forearms ran into the
            // mistake banner and off the top of the view.
            "torso": FaultPose(chains: [spine, ["forearm_L", "upper_arm_L", "neck", "upper_arm_R", "forearm_R"]],
                               moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*", "forearm_*"], axis: .lateral, degrees: 20),
                                       .shift(["spine"], forward: 0.1), .shift(["chest"], forward: 0.045)]).seen(0.6),
            // A bigger shrug than `shrugged`: with the arms overhead the
            // shoulders have to rise clearly above the neck point to read.
            "traps": FaultPose(chains: [shoulders, arms], moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.18)]),
            // Elbows bending as the hands rise; none with the hands at the
            // hips (hand_L to pelvis ~0.61 there since the 2026-09-30 model,
            // ~1.83 at the top).
            "elbow": elbowsFolded(.lateral, -50, strength: .between("hand_L", "pelvis", from: 0.7, to: 1.4)),
            "height": overheadShort,
            // Handles taken uncrossed: the hands start at the sides, shown at
            // the bottom only (all of it at the model's ~0.61, none by 1.0).
            "cross": armsTurned(.forward, 20, strength: .between("hand_L", "pelvis", from: 1.0, to: 0.65)),
        ],
        "Lu Raise": [
            // Shrugging before the arms leave the sides; fades out overhead,
            // where the shoulders are meant to rise.
            "traps": FaultPose(chains: [shoulders, arms], moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.12)],
                               strength: .between("hand_L", "head", from: 0.95, to: 1.25)),
            // Elbows bending as the arms go overhead, the hands folding in over
            // the head like a press. None below shoulder height.
            "elbow": elbowsFolded(.forward, 40, strength: .between("hand_L", "head", from: 1.25, to: 0.95)),
            "torso": leanedBack(12, arch: 0.08).seen(-1.2),
            // Stopping at shoulder height, shown overhead.
            "height": armsTurned(.forward, -70, strength: .between("hand_L", "head", from: 1.15, to: 0.85)),
            // Swinging forward into a front raise.
            "path": armsTurned(.up, 30).seen(-1.2),
        ],
        "Cable External Rotation": [
            // The elbow drifting out from the side.
            "elbow": armsTurned(.forward, 25, side: "L"),
            // The elbow opening, the hand dropping.
            "angle": elbowsFolded(.lateral, -35, side: "L"),
            "shoulder": leftShrugged,
            "torso": leftTwistedOpen.seen(-1.1),
            // Leaning away from the stack (on the right).
            "stance": leftArmTrunkTipped(-12),
        ],
        "Cable Internal Rotation": [
            // The elbow drifting forward off the side. A front-left
            // three-quarter, where the pulley housing clears the shoulder.
            "elbow": armsTurned(.lateral, 25, side: "L").seen(-0.9),
            "angle": elbowsFolded(.lateral, -35, side: "L"),
            // The shoulder rolling forward: the neck-to-shoulder segment tips
            // forward past the neck, not just the arm moving.
            "shoulder": FaultPose(chains: [["neck", "upper_arm_L", "forearm_L", "hand_L"], ["upper_arm_L", "upper_arm_R"]],
                                  moves: [.shift(["upper_arm_L", "forearm_L", "hand_L"], forward: 0.16)]).seen(-0.9),
            // Seen with the real shoulders edge-on, so the twist fans them out
            // (left forward, right back) instead of folding them onto the spine.
            "torso": leftTwistedIn.seen(-1.2),
            // Leaning away from the stack (on the left).
            "stance": leftArmTrunkTipped(12),
        ],
        "Powell Raise": [
            // Rolling back to throw the weight up, seen from the feet at a
            // three-quarter (fully end-on the lifter is a blob): the shoulder
            // line turns ~0.15 torso lengths at each end.
            "body": leftRolledBack(30).seen(-0.3),
            // The shoulder hiked toward the ear, along the bench, ending
            // between the neck and head points.
            "scapula": leftShruggedLying.seen(0.6),
            "elbow": elbowsFolded(.up, 50, side: "L").seen(-0.6),
            // The arm drifting toward the hip instead of staying at right
            // angles to the body: swung in the trunk's plane at full length
            // (hand ~0.34 torso lengths at the top, almost none at the bottom
            // where the arm points forward).
            "path": armsTurned(.forward, -22, side: "L").seen(0.6),
            // Short at the bottom: the arm stops about level with the shoulder
            // instead of angling down in front of the chest. None once the
            // hands are 1.2 torso lengths apart, all of it at the bottom
            // (~0.85).
            "range": armsTurned(.up, -30, side: "L", strength: .between("hand_L", "hand_R", from: 1.2, to: 0.85)),
        ],
        // MARK: Batch 191-240 front raises, rear-delt rows and upright rows (2026-09-26)
        // Framed at yaw -0.55 (plate, cable, alternating) or -1.0 (barbell):
        // sagittal faults turn the left side round to about -1.35.
        "Plate Front Raise": [
            // Swung on past the face toward overhead, shown near the top.
            "height": armsTurned(.lateral, 35, strength: frontRaiseRising).seen(-0.8),
            "shoulder": hunched().seen(-0.8),
            "elbow": elbowsFolded(.lateral, 50, strength: frontRaiseRising).seen(-0.8),
            // Wrists bending so the plate tilts back toward the face, growing
            // as the plate rises (wristBentBack has no strength of its own).
            "grip": FaultPose(chains: [["forearm_*", "hand_*", "hand_*.tip"]],
                              moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .lateral, degrees: 48)],
                              strength: frontRaiseRising, view: -0.8),
            "torso": leanedBack(12).seen(-0.8),
        ],
        "Barbell Front Raise": [
            // Swung on to about 139°, the bar well above the head. This
            // framing leaves room above the head, unlike the plate and cable.
            "height": armsTurned(.lateral, 50, withBar: true, strength: frontRaiseRising).seen(-0.35),
            // Hands bunched in the middle of the bar, turned toward face-on so
            // the width shows; read at the bottom, arms hanging in a V.
            "grip": gripBunched.seen(0.6),
            "elbow": elbowsFolded(.lateral, 50, strength: frontRaiseRising).seen(-0.35),
            // Shoulders hunched up and forward, arms and bar carried along,
            // turned toward face-on so the shoulder line rises past the neck.
            "shoulder": FaultPose(chains: [shoulders, armsToGrip, bar],
                                  moves: [.shift(["upper_arm_*", "forearm_*", "hand_*", "hand_*.tip"], forward: 0.07, up: 0.15)],
                                  view: 0.6),
            "torso": leanedBack(12, withBar: true).seen(-0.35),
        ],
        "Cable Front Raise": [
            "height": armsTurned(.lateral, 35, withBar: true, strength: frontRaiseRising).seen(-0.8),
            "shoulder": hunched().seen(-0.8),
            "elbow": elbowsFolded(.lateral, 50, strength: frontRaiseRising).seen(-0.8),
            // Rocking back from the model's ~15° forward lean to past upright.
            "torso": leanedBack(20, withBar: true).seen(-0.8),
            // Feet drawn together (ankles about 15 cm apart instead of 36) and
            // knees locked, the trunk tipped back toward the stack.
            "stance": FaultPose(chains: [legs, spine],
                                moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.18), .straighten(["shin_*"]),
                                        .turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: 10)]),
        ],
        "Alternating Dumbbell Front Raise": [
            // The left arm swung on above shoulder height; shown during the
            // left arm's rep (the first half of the clip).
            "height": armsTurned(.lateral, 35, side: "L", strength: frontRaiseRising).seen(-0.8),
            "shoulder": shrugged,
            // Both elbows folded, working and resting arm alike.
            "elbow": elbowsFolded(.lateral, 50).seen(-0.8),
            // Twisting the working (left) shoulder forward 24° to throw the
            // left dumbbell up, gated to the left arm's rep so it never twists
            // the wrong way while the right arm lifts. The hip line stays
            // square; the default 3/4 front view shows the shoulder line
            // turning against it and the raised hand swinging across.
            "alternate": FaultPose(chains: [spine, shoulders, arms, hips],
                                   moves: [.turn(pivot: "pelvis", points: ["spine", "chest", "neck", "head", "upper_arm_*", "forearm_*", "hand_*"],
                                                 axis: .up, degrees: 24)],
                                   strength: frontRaiseRising),
            "torso": leanedBack(12).seen(-0.8),
        ],
        // Framed from behind the left side (yaw -2.3): +0.75 brings the left
        // side round for the trunk faults.
        "Rear Delt Row": [
            // Turned to straight behind (-3.14), where the tucked arms read
            // against the wide grey ones.
            "elbow": rearDeltElbowsTucked.seen(-0.84),
            // Short reps: the elbows stop below the line of the back, still
            // flared, the dumbbells hanging under them. rowedShort's forward
            // points at the floor on this hinge and barely moves the arms.
            "height": FaultPose(chains: [armsToGrip],
                                moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*"], axis: .up, degrees: 40),
                                        .shift(["hand_*", "hand_*.tip"], ahead: 0.15, rise: -0.25),
                                        .resolve(["forearm_*"])],
                                strength: .withBend("forearm_L")),
            // Standing up out of the hinge: the trunk and head only, 20° more
            // upright, so one line stands out against the grey back (the
            // carried arms crossed it at the top of the row).
            "hinge": FaultPose(chains: [spine],
                               moves: [.turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: 20)],
                               view: 0.75),
            // Shrugging: the shoulders slide along the back toward the ears,
            // seen from the left side.
            "traps": FaultPose(chains: [shoulders, arms],
                               moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.16)],
                               view: 0.75),
            // The upper back rounding (the hump at the chest joint, not the
            // lower back) and the head dropping.
            "back": FaultPose(chains: [spine],
                              moves: [.shift(["spine"], forward: -0.04), .shift(["chest"], forward: -0.11),
                                      .shift(["neck"], forward: 0.04), .shift(["head"], forward: 0.18)],
                              view: 0.75),
        ],
        // Framed from behind the right side (yaw 2.4): -0.8 turns the right
        // side square to the camera.
        "Machine Rear Delt Row": [
            // Seat too high: the body sits about 12 cm higher while the hands
            // stay on the handles, so the elbows re-seat below the shoulders
            // and the upper arms slope down to the handles.
            "seat": FaultPose(chains: [spine, shoulders, arms],
                              moves: [.shift(["pelvis", "thigh_*"] + torso + ["upper_arm_*"], rise: 0.2),
                                      .resolve(["forearm_*"])]),
            // Elbows dropped and tucked toward the ribs.
            "elbow": FaultPose(chains: [armsToGrip], moves: [.shift(["forearm_*"], up: -0.16, outward: -0.08), .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            // Stopping with the elbows still in front of the body: the upper
            // arms swung forward about 30° at the same height, the hands on
            // the handles further forward (the mid-rep position).
            "range": FaultPose(chains: [armsToGrip],
                               moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*"], axis: .up, degrees: 35),
                                       .shift(["hand_*", "hand_*.tip"], forward: 0.2),
                                       .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L"), view: -0.8),
            // Shrugging up and back at the end of the pull: the shoulders
            // rise about 9 cm toward the ears while the hands stay on the
            // handles, the elbows re-seated.
            "traps": FaultPose(chains: [shoulders, armsToGrip],
                               moves: [.shift(["upper_arm_*"], forward: -0.06, up: 0.16), .resolve(["forearm_*"])]),
            // Leaning back off the pad, straight from the hips on the seat:
            // the head about 17 cm back. The hands stay at handle height and
            // travel back with the shoulders, as the handles would.
            "chest": FaultPose(chains: [spine, armsToGrip],
                               moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .lateral, degrees: 14),
                                       .shift(["forearm_*", "hand_*", "hand_*.tip"], ahead: -0.21),
                                       .resolve(["forearm_*"])],
                               view: -0.8),
        ],
        // Upright rows: yaw -0.8 (barbell), +0.6 (cable, right side toward the
        // camera), -0.5 (Smith).
        "Barbell Upright Row": [
            "grip": gripBunched,
            "elbow": uprightRowElbowsLow,
            "height": uprightRowHigh,
            // The bar drifting about 15 cm out in front of the body, turned to
            // -1.0, where the near plate sits clear of the chest.
            "barpath": barDrifting(0.25, 0.12).seen(-0.2),
            "torso": bodySwung(withBar: true).seen(-0.2),
        ],
        "Cable Upright Row": [
            "grip": gripBunched,
            "elbow": uprightRowElbowsLow,
            "height": uprightRowHigh,
            // Standing a big step back: the whole body about 24 cm further
            // from the pulley, the bar dragged out about 15 cm further in
            // front of the chest, the elbows re-seated.
            "stance": FaultPose(chains: [spine, legs, hips, armsToGrip, bar],
                                moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip", "upper_arm_*"] + torso,
                                               ahead: -0.4),
                                        .shift(["hand_*", "hand_*.tip"], ahead: -0.15),
                                        .resolve(["forearm_*"])],
                                view: 0.9),
            // Leaning back away from the stack.
            "torso": leanedBack(14, withBar: true).seen(0.9),
        ],
        "Smith Machine Upright Row": [
            "grip": gripBunched,
            "elbow": uprightRowElbowsLow,
            "height": uprightRowHigh,
            // Standing back from the bar: the body stands 0.25 torso lengths
            // (about 15 cm) further back while the hands stay on the bar,
            // which the rails hold in place, so the arms reach forward to it
            // (the reverse of crowdingTheStack). barDrifting would move the
            // bar off the rails. Turned to -0.9, where the near plate sits
            // clear of the chest.
            "stance": FaultPose(chains: [spine, legs, hips, armsToGrip, bar],
                                moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip", "upper_arm_*"] + torso,
                                               ahead: -0.25),
                                        .resolve(["forearm_*"])],
                                view: -0.4),
            // Leaning back while the hands stay on the bar, which the rails
            // hold in place: the elbows open as the trunk tips back.
            "torso": FaultPose(chains: [spine, armsToGrip, bar],
                               moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .lateral, degrees: 12),
                                       .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L"), view: -0.4),
        ],
        // MARK: Batch 191-240: shrugs and loaded carries (2026-09-26)
        // Framed front-on (yaw -0.5, the barbell -0.8): faults along the
        // lifter's forward axis turn toward a left-side view. The Smith and
        // cable shrugs stop at -1.1 in total so the rails and columns stay
        // clear of the lifter.
        "Dumbbell Shrug": [
            // Stopping short: the shoulders still low at the top.
            "range": shouldersLowered(0.07, strength: shrugTop),
            // Rolled forward at the top (8 cm, so it reads clear of the
            // lifter's arms side-on).
            "path": shrugRolled(0.14).seen(-0.8),
            "head": chinCraned.seen(-0.8),
            "arms": shrugCurled(withBar: false).seen(-0.8),
            // Dumbbells drifting in front of the thighs.
            "grip": armsSwungForward(14).seen(-0.8)
        ],
        "Barbell Shrug": [
            "range": shouldersLowered(0.07, withBar: true, strength: shrugTop),
            "path": shrugRolled(0.14, withBar: true).seen(-0.6),
            "head": chinCraned.seen(-0.6),
            "arms": shrugCurled(withBar: true).seen(-0.6),
            // The bar hanging away from the thighs.
            "grip": armsSwungForward(14, withBar: true).seen(-0.6)
        ],
        "Smith Machine Shrug": [
            "range": shouldersLowered(0.07, withBar: true, strength: shrugTop),
            // Rolled forward at the top, the bar held on its track.
            "path": shrugRolledOnTrack.seen(-0.6),
            "head": chinCraned.seen(-0.6),
            // The bar stays on its track: the elbows go back instead (the
            // grip moves under 1 cm fore-aft and rises 6.6 cm at the top).
            "arms": shrugRowed(back: 27, bend: 50).seen(-0.6),
            // Standing back from the rails: the trunk leans in to the bar.
            "bar": leanedForward(10, withBar: true, strength: .always).seen(-0.6)
        ],
        "Cable Shrug": [
            "range": shouldersLowered(0.07, strength: shrugTop),
            "path": shrugRolled(0.14).seen(-0.6),
            "head": chinCraned.seen(-0.6),
            "arms": shrugCurled(withBar: false).seen(-0.6),
            // Feet together (ankles about 8 cm apart), knees locked: the
            // straight legs converge from the hips.
            "stance": FaultPose(chains: [legs, hips],
                                moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.2), .straighten(["shin_*"])])
        ],
        "Trap Bar Shrug": [
            "range": shouldersLowered(0.07, strength: shrugTop),
            "path": shrugRolled(0.14).seen(-0.8),
            "head": chinCraned.seen(-0.8),
            "arms": shrugCurled(withBar: false).seen(-0.8),
            // Leaning back and rocking the hips forward to heave the bar
            // (`bodySwung`'s moves, shown throughout: its elbow-bend strength
            // is zero with this model's straight arms). The legs are drawn so
            // the thighs slant up to the forward hips: the banana shape.
            "posture": FaultPose(chains: [spine, armsToGrip, hips, legs],
                                 moves: [.shift(["pelvis", "thigh_*"], ahead: 0.09),
                                         .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 12),
                                         .resolve(["shin_*"])]).seen(-0.8)
        ],
        // Framed from behind-left (yaw -2.4): +0.9 turns it to a left-side view.
        "Behind-the-Back Barbell Shrug": [
            "range": shouldersLowered(0.07, withBar: true, strength: shrugTop),
            // Rolled back at the top. Seen from a touch behind the left side
            // (-1.7 in total) so the shoulders, rolled back toward the
            // "Straight up, no rolling" pill, stay clear of it.
            "path": shrugRolled(-0.14, withBar: true).seen(0.7),
            "head": chinCraned.seen(0.9),
            // A curl would swing the bar forward through the hips: the
            // elbows drive back and the bar rides up behind the legs (the
            // grip stays 0.17 m behind the pelvis and rises 6.5 cm).
            "arms": shrugRowed(back: 30, bend: 50).seen(0.9),
            // The bar swinging away from the backs of the legs.
            "bar": armsSwungForward(-14, withBar: true).seen(0.9)
        ],
        // The carries walk in place; framed at -0.6, -0.3 and -1.0.
        "Farmer's Carry": [
            // Looking down: the upper back rounds and the head bows forward
            // and down about the neck (its length kept), the head point
            // about 0.2 forward and 0.1 lower.
            "head": FaultPose(chains: [spine],
                              moves: [.shift(["chest"], forward: -0.06),
                                      .shift(["neck", "head"], forward: 0.07, up: -0.03),
                                      .turn(pivot: "neck", points: ["head"], axis: .lateral, degrees: -55)]).seen(-0.8),
            // Shoulders dragged forward and down, the upper back rounding
            // (`backRounded`'s chest-back, head-forward idiom); the girdle is
            // drawn from the neck so the drop reads as a slump.
            "shoulders": FaultPose(chains: [spine, arms, shoulders],
                                   moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], forward: 0.13, up: -0.06, outward: -0.03),
                                           .shift(["chest"], forward: -0.07),
                                           .shift(["neck", "head"], forward: 0.09, up: -0.03)]).seen(-0.8),
            "posture": leanedForward(10, strength: .always).seen(-0.8),
            // A loose grip: the dumbbells swinging forward.
            "grip": armsSwungForward(15).seen(-0.8),
            "steps": longStride(from: 0.6, to: 0.76).seen(-0.8)
        ],
        "Suitcase Carry": [
            "level": leanedToLoad,
            // The right shoulder swinging forward, seen near side-on (-1.3 in
            // total, as the grip): the upper body opens toward the camera
            // over the side-on hips, the right arm ahead of the chest. A left
            // shoulder forward from this side would fold both arms together.
            "twist": twisted(-22).seen(-1.0),
            // The dumbbell swinging forward.
            "grip": armsTurned(.lateral, 15, side: "L").seen(-1.0),
            // The free arm held out as a counterweight.
            "free": armsTurned(.forward, 35, side: "R"),
            "steps": longStride(from: 0.52, to: 0.68).seen(-1.0)
        ],
        "Overhead Carry": [
            "wrist": wristBentBack(withBar: false).seen(-0.4),
            // Arms drifting forward of the head.
            "lockout": armsTurned(.lateral, -18).seen(-0.4),
            // The shoulders sinking under the weights.
            "shoulders": shouldersLowered(0.16),
            "ribs": leanedBack(10, arch: 0.08).seen(-0.4),
            "steps": longStride(from: 0.52, to: 0.68).seen(-0.4)
        ],
        // MARK: Batch 191-240 curls (2026-09-26)
        // Standing, framed at yaw -0.4 like the Biceps Curl. The LEFT arm curls
        // first (0-4 s) and turns palm-up as it rises; the elbow, turn and range
        // faults read the left elbow, so they show during the left curl and fade
        // while the right arm works; the body swing shows on either curl.
        // Sagittal faults turn to the left side (total -1.3).
        "Alternating Dumbbell Curl": [
            // Both shoulders hunched up and forward (the label points at the
            // right shoulder, which is on the open side of the frame).
            "shoulder": hunched().seen(-0.6),
            "elbow": elbowsForward(35, side: "L").seen(-0.9),
            // Wrist curled in at the top instead of the palm turning up.
            "turn": curlWristsCurled("L").seen(-0.9),
            // The resting (right) arm left half-bent (elbow ~118°) while the
            // left arm curls; turned to the right side (total +1.1) so the
            // forearm shows swinging forward, not folding across the hips.
            "range": elbowsFolded(.lateral, 60, side: "R", strength: .withBend("forearm_L")).seen(1.5),
            // Either arm's curl: bodySwung's moves, shown as the hands spread
            // apart while one dumbbell rises. The 2026-09-30 model hangs the
            // dumbbells wider (13° out from the sides): 1.075 torso lengths
            // with both arms down, up to 1.108 as the curling hand first
            // swings out, 0.95 as it turns in and 1.155 at the top of either
            // curl, so the ghost starts just clear of the swing-out and shows
            // over the top of each curl, as the Alternating Hammer Curl's
            // `hammerSwung`.
            "torso": FaultPose(chains: [spine, armsToGrip, hips],
                               moves: [.shift(["pelvis", "thigh_*"], ahead: 0.06),
                                       .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 15)],
                               strength: .between("hand_L", "hand_R", from: 1.115, to: 1.15)).seen(-0.9)
        ],
        // Kneeling on an incline bench, seen from behind on the left (yaw
        // -2.0); +0.45 brings it to a true left side view.
        "Spider Curl": [
            // Chest and shoulders heaving up off the pad: the trunk rocks up
            // from the hips (48° to 30° forward of vertical), opening a wedge
            // between the ghost back and the pad; the arms ride with it.
            "pad": trunkLifted(18).seen(0.45),
            // Shoulders shrugging up the pad toward the ears (10.6 cm, ending
            // above the neck); the back view shows it best. Only the girdle
            // and upper arms are drawn, so no forearms cross the shoulder line.
            "shoulder": FaultPose(chains: [shoulders, ["upper_arm_*", "forearm_*"]],
                                  moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.18)]),
            // Upper arms swinging from vertical toward the head as the bar rises.
            "elbow": elbowsForward(30, withBar: true).seen(0.45),
            // Framed small: a deeper fold, the fingers tipping past vertical.
            "grip": curlWristsCurled(withBar: true, degrees: 65).seen(0.45),
            // Half reps: shoulder-to-wrist 0.90 torso lengths at the bottom
            // (170°), 0.78 at 120°.
            "range": curlBottomCut(from: 0.8, to: 0.89).seen(0.45)
        ],
        // Seated, framed at yaw -1.1; -0.4 turns to a true left side view of
        // the pad. Only the LEFT arm curls; the right rests on the pad.
        "Dumbbell Preacher Curl": [
            // The upper arm lifting off the pad as the dumbbell rises.
            "pad": curlArmsOffPad(25, side: "L").seen(-0.4),
            // Half reps: 0.896 torso lengths at the model's bottom (162°),
            // 0.78 at 120°.
            "range": curlBottomCut("L", from: 0.8, to: 0.885).seen(-0.4),
            "wrist": curlWristsCurled("L").seen(-0.4),
            // Rocking back past upright to swing the dumbbell, the working arm
            // coming off the pad (only the left arm is drawn).
            "torso": curlSeatedSwungBack(22, side: "L").seen(-0.4),
            // Seat too low: turned toward the front (total -0.6) so the
            // shoulder line spreads and the neck shows sinking between the
            // shoulders; read at the bottom, with the dumbbell away from the head.
            "seat": preacherSatLow.seen(0.5)
        ],
        // Seated, framed at yaw -1.0; -0.5 turns to a true left side view, where
        // the elbows line up with the lever's side pivot.
        "Machine Biceps Curl": [
            "pivot": curlMachineSatLow.seen(-0.5),
            // Upper arms lifting off the pad at the top.
            "pad": curlArmsOffPad(25).seen(-0.5),
            "grip": curlWristsCurled().seen(-0.5),
            "range": curlBottomCut(from: 0.8, to: 0.885).seen(-0.5),
            // Rocking back past upright, the arms carried off the pad.
            "torso": curlSeatedSwungBack(22).seen(-0.5)
        ],
        // MARK: Legs 300-350 (2026-09-26)
        // MARK: Batch 300-350 split squats and Bulgarian split squats (2026-09-26)
        // Every model keeps the LEFT foot forward for both reps and is framed
        // from the left: yaw -1.3 (barbell, dumbbell, front-foot-elevated and
        // rear-foot-elevated split squats) or -1.0 (the two Smith lifts and the
        // barbell Bulgarian). Sagittal faults need no turn at -1.3 and turn -0.4
        // (a total of -1.4) at -1.0; the front knee caving in turns toward
        // face-on, a total of about -0.2 (faceOn at -1.3, 0.8 at -1.0).
        "Barbell Split Squat": [
            // The bar slid down the back, the chest tipping to balance it.
            "bar": barSlidLow,
            "torso": leanedForward(20, withBar: true),
            "knee": kneesIn("L").seen(faceOn),
            // Stopping halfway, the hips drifting forward instead of down.
            "depth": shallow(0.18, ahead: 0.1, withBar: true),
            "heel": heelsUp("L")
        ],
        "Dumbbell Split Squat": [
            // The dumbbells swinging forward off the sides at the bottom.
            "grip": armsSwungForward(28, strength: .withBend("shin_L")),
            "torso": leanedForward(20),
            "knee": kneesIn("L").seen(faceOn),
            "depth": shallow(0.18, ahead: 0.1),
            "heel": heelsUp("L")
        ],
        "Smith Machine Split Squat": [
            // The bar low on the back, held on its track: the chest tips, the
            // hips slide back.
            "bar": barLowOnTrack.seen(-0.4),
            // Hips back behind the fixed bar, the chest folding under it.
            "torso": hipsBehindFixedBar(14).seen(-0.4),
            "knee": kneesIn("L").seen(0.8),
            // Stopping high on the track: straight up, the bar on its rails.
            "depth": shallow(0.18, withBar: true).seen(-0.4),
            // Front foot too close to the bar: the heel peels up.
            "stance": frontFootTooClose.seen(-0.4)
        ],
        "Front-Foot-Elevated Split Squat": [
            "grip": armsSwungForward(28, strength: .withBend("shin_L")),
            "torso": leanedForward(20),
            "knee": kneesIn("L").seen(faceOn),
            // Stopping at flat split squat depth: the hips ~13 cm higher.
            "depth": shallow(0.22),
            // The front heel lifting off the step.
            "step": heelsUp("L")
        ],
        "Rear-Foot-Elevated Split Squat": [
            "grip": armsSwungForward(28, strength: .withBend("shin_L")),
            "torso": leanedForward(20),
            "knee": kneesIn("L").seen(faceOn),
            "depth": shallow(0.18, ahead: 0.1),
            // The back foot up on its toes on the bench.
            "rear": rearFootOnToes
        ],
        "Barbell Bulgarian Split Squat": [
            "bar": barSlidLow.seen(-0.4),
            "torso": leanedForward(20, withBar: true).seen(-0.4),
            "knee": kneesIn("L").seen(0.8),
            "depth": shallow(0.18, ahead: 0.1, withBar: true).seen(-0.4),
            "rear": rearFootOnToes.seen(-0.4)
        ],
        "Smith Machine Bulgarian Split Squat": [
            "bar": barLowOnTrack.seen(-0.4),
            "torso": hipsBehindFixedBar(14).seen(-0.4),
            "knee": kneesIn("L").seen(0.8),
            "depth": shallow(0.18, withBar: true).seen(-0.4),
            "rear": rearFootOnToes.seen(-0.4)
        ],
        // MARK: Legs 300-350 lunges (2026-09-26)
        // All four alternate legs, so every fault names the `front` and
        // `back` leg and follows whichever foot leads. Torso length is 0.59 m.
        // Forward Lunge is framed at yaw -1.3 (near side-on), so its sagittal
        // faults need no turn and knee caving is turned face-on (-0.2 in
        // total). Barbell Lunge is framed at -0.6: its sagittal faults turn
        // only to -1.05, since side-on the near plate hides the head, and its
        // frontal ones turn face-on. Smith Machine Reverse Lunge is framed at
        // -1.0, already showing the sagittal plane; its sagittal faults stay
        // unturned so the rails and plates stay off the lifter, and knee
        // caving turns face-on. Curtsy Lunge is framed at -0.5: sagittal
        // faults turn to -1.3, frontal ones face-on, and the hips turning
        // open (a turn about the vertical, which swings the back hip and
        // shoulder backward) also turn to -1.3, where that swing lies across
        // the screen instead of into it. The back foot stands on its toes,
        // so ghosts that draw the back leg stop it at the ankle
        // (`lungeBackLeg`). In the mistake view the model sits ~0.09 higher
        // on screen, so two ghosts turn a little to keep their moved joints
        // out from under the cue's own label.
        "Forward Lunge": [
            // A short step: the front foot lands ~21 cm nearer the back one
            // and the knee travels ~10 cm past the toes, the shin ~39°
            // forward.
            "step": lungeStepShort(0.35),
            "torso": leanedForward(22, strength: .withBend("shin_front")),
            "knee": kneesIn("front").seen(faceOn),
            // Stopping halfway: the hips held ~18 cm up and pushed ~6 cm
            // forward instead of down.
            "depth": lungeShallow(0.3, ahead: 0.1),
            // Pushing back off the ball of the front foot.
            "drive": heelsUp("front")
        ],
        "Barbell Lunge": [
            "step": lungeStepShort(0.35).seen(-0.45),
            // The chest dropping and the upper back rounding under the bar.
            "torso": chestDropped(16, withBar: true, strength: .withBend("shin_front")).seen(-0.45),
            // The front foot landing on the back foot's line, ~24 cm in.
            "track": lungeStepInLine(0.4).seen(0.6),
            "knee": kneesIn("front").seen(0.6),
            "drive": heelsUp("front").seen(-0.45)
        ],
        "Smith Machine Reverse Lunge": [
            // The front foot set under the bar: ~21 cm further back, where
            // the rails keep the bar over it, so at the bottom the knee is
            // forced past the toes and the heel peels up ~7 cm.
            "stance": lungeStepShort(0.35, heelUp: 20),
            // Too short a step back: the back foot lands ~15 cm nearer.
            "step": FaultPose(chains: [lungeBackLeg, hips],
                              moves: [.shift(["foot_back"], ahead: 0.25), .resolve(["shin_back"])],
                              strength: .withBend("shin_front")),
            // Rounding under the bar instead of hinging; the bar stays on its
            // rails, so only the spine moves.
            "lean": backRounded(.withBend("shin_front")),
            "knee": kneesIn("front").seen(1.0),
            // Standing up off the back leg: its knee straightens first.
            // Turned to -0.7 so the straightened knee clears the label on
            // the right.
            "drive": lungeBackLegPushing(strength: .withBend("shin_front")).seen(0.3)
        ],
        "Curtsy Lunge": [
            // The pelvis and trunk turning ~30° toward the leg that crosses
            // behind: the back hip ~9 cm and that shoulder ~14 cm back.
            "hips": curtsyHipsOpened(30).seen(-0.8),
            // The back foot swung ~18 cm further across. Turned to +0.3,
            // just past face-on, so in rep 1 the moved foot lands left of
            // the label rather than under it.
            "cross": curtsyCrossedFar(0.3).seen(0.8),
            "knee": kneesIn("front").seen(0.5),
            "torso": leanedForward(20, strength: .withBend("shin_front")).seen(-0.8),
            "drive": heelsUp("front").seen(-0.8)
        ],
        // MARK: Late additions (2026-09-27)
        // MARK: Late additions 2026-09-27: seated lateral raise, cable rear delt row and dumbbell upright row
        // Framed from the front-left (yaw -0.6): sagittal faults turn the
        // left side round to about -1.3 to -1.5.
        "Seated Dumbbell Lateral Raise": [
            "traps": shrugged,
            // Elbows bending, the hands dropping below them (~40° more bend,
            // the hands ~18 cm lower at the top); none below mid-raise.
            "elbow": elbowsFolded(.forward, -60, strength: seatedRaiseRising),
            // Swung on past level to ~118°, the hands ~24 cm higher.
            "height": armsTurned(.forward, 30, strength: seatedRaiseRising),
            // Arms swept back behind the line of the shoulders at the top (the
            // hands ~27 cm back, ~3 cm behind the shoulders instead of 24 cm
            // in front), seen from nearly side-on (total -1.3), where the
            // sweep runs across the screen.
            "plane": armsTurned(.up, -30, strength: seatedRaiseRising).seen(-0.7),
            // Rocking back 12° about the hips on the bench, arms carried; the
            // head ~14 cm back. Side-on (total -1.5).
            "torso": leanedBack(12).seen(-0.9),
        ],
        // Framed from behind-left (yaw -2.6): +0.6 turns the left side
        // toward the camera (total -2.0) for faults along the line of pull.
        "Cable Rear Delt Row": [
            // Hands about shoulder-width (~42 cm apart instead of 66), the
            // elbows re-seated. Shown with the arms reaching forward: none by
            // the time the elbows reach 90° (hand to shoulder 0.6 torso
            // lengths; 0.89 at full reach), where re-seating the short span
            // would fold the elbows.
            "grip": FaultPose(chains: [armsToGrip, bar],
                              moves: [.shift(["hand_*", "hand_*.tip"], outward: -0.2), .resolve(["forearm_*"])],
                              strength: .between("hand_L", "upper_arm_L", from: 0.6, to: 0.8)),
            "traps": shruggedBack,
            // Elbows dropping and tucking: at the finish ~22 cm below the
            // shoulders and ~9 cm out (upper arms ~39° from the sides instead
            // of ~66°), the bar ~12 cm lower, at the lower chest.
            "elbow": FaultPose(chains: [armsToGrip, bar],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: -0.2),
                                       .shift(["forearm_*"], up: -0.3, outward: -0.12),
                                       .resolve(["forearm_*"])],
                               strength: .withBend("forearm_L")),
            // Short reps: at the finish the elbows stay ~13 cm in front of the
            // shoulders (instead of ~14 cm behind) at the same height, the bar
            // ~27 cm further forward, the elbows ~83° instead of ~31°. Shown
            // only near the finish (hand to shoulder 0.5 -> 0.25 torso
            // lengths; 0.89 at full reach): gated by elbow bend, the constant
            // forward shift put the ghost's straightened arms past the bar
            // through the reach.
            "range": FaultPose(chains: [armsToGrip, bar],
                               moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*"], axis: .up, degrees: 55),
                                       .shift(["hand_*", "hand_*.tip"], forward: 0.45),
                                       .resolve(["forearm_*"])],
                               strength: .between("hand_L", "upper_arm_L", from: 0.5, to: 0.25), view: 0.6),
            // Leaning back 15° behind the seat, the head ~18 cm back. The bar
            // stays on the level cable line and pays out ~14 cm with the
            // shoulders (as the Machine Rear Delt Row's chest fault), the
            // elbows re-seated.
            "torso": FaultPose(chains: [spine, armsToGrip, bar],
                               moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_*"], axis: .lateral, degrees: 15),
                                       .shift(["hand_*", "hand_*.tip"], ahead: -0.23),
                                       .resolve(["forearm_*"])],
                               view: 0.6),
        ],
        // Framed from the front-left (yaw -0.5).
        "Dumbbell Upright Row": [
            "height": dumbbellUprightRowHigh,
            "elbow": dumbbellUprightRowElbowsLow,
            // The dumbbells ~15 cm further out in front of the body at the
            // top (~4 cm at the thighs), the elbows re-seated so the arms keep
            // their length; turned to about side-on (total -1.1).
            "path": FaultPose(chains: [armsToGrip],
                              moves: [.shift(["hand_*", "hand_*.tip"], ahead: 0.25), .resolve(["forearm_*"])],
                              strength: .withBend("forearm_L"), view: -0.6),
            // Turned toward face-on (total -0.2) so the spacing shows.
            "width": dumbbellsTogether.seen(0.3),
            "torso": bodySwung(withBar: false).seen(-0.6),
        ],
        // MARK: Barbell hip thrust (2026-09-27)
        // Framed three-quarter from the feet on the lifter's left (yaw -0.7).
        // The hips and spine move up and down the screen in any framing, and
        // moves along the trunk's line show at about two-thirds of their
        // length (a 13 cm move is ~23 pt), so no fault turns the model: a turn
        // toward side-on would put the near plate over the hips and hands.
        // The model's knees sit ~7 cm inside the ankles at lockout, so there
        // is no knee cue (notes_0927_hipthrust.md).
        "Barbell Hip Thrust": [
            // Stopping short: the hips and bar hang ~15 cm below the line of
            // the knees and shoulders, the hips bent to ~150°.
            "hips": hipsShortOfLockout(0.25, strength: thrustLockout),
            // The lower back humping up above the line at the top.
            "ribs": thrustArched,
            // Feet ~13 cm too far out: at lockout the shins slope away and
            // the knees open to ~110°.
            "feet": thrustFeetFar(0.22),
            // The back sliding ~12 cm up the bench as the hips rise, so the
            // edge ends near the bottom of the shoulder blades.
            "bench": slidUpBench(0.2),
            // The bar rolled ~16 cm up onto the stomach near lockout, the
            // hands with it.
            "bar": barRolledUp(0.28, strength: thrustLockout),
        ],
        // MARK: Batch 241-300 (2026-09-27)
        // MARK: Batch 241-300 preacher and machine curls (2026-09-27)
        // Seated, framed at yaw -1.0 like the Machine Biceps Curl; -0.5 turns
        // to a true left side view, where the elbow lines up with the lever's
        // side pivot. Only the LEFT arm curls; the right rests on the pad.
        "Single-Arm Machine Curl": [
            // The upper arm lifting off the pad at the top.
            "pad": curlArmsOffPad(25, side: "L").seen(-0.5),
            // Half reps: 0.897 torso lengths shoulder-to-wrist at the model's
            // bottom (162°), 0.78 at 120°. A 30° fold (the ghost elbow ~132°,
            // the forearm about level), not curlBottomCut's 45°: from the side
            // a 45° fold lays the ghost forearm over the resting right one.
            "range": elbowsFolded(.lateral, 30, side: "L",
                                  strength: .between("upper_arm_L", "hand_L", from: 0.8, to: 0.885)).seen(-0.5),
            "grip": curlWristsCurled("L").seen(-0.5),
            // Rocking back past upright, the working arm carried off the pad.
            "torso": preacherRockedBack(22, side: "L").seen(-0.5),
            // Seat too low: the elbow under the pivot; read at the bottom.
            "pivot": leftCurlMachineSatLow.seen(-0.5)
        ],
        // Seated on a preacher bench facing a low pulley, framed from the
        // front-right at yaw +1.1; +0.4 turns to a true right side view (the
        // near arm is the right one). Both arms curl.
        "Cable Preacher Curl": [
            "pad": curlArmsOffPad(25).seen(0.4),
            // Half reps at the bottom: 0.899 torso lengths at 164°.
            "range": curlBottomCut(from: 0.8, to: 0.885).seen(0.4),
            // Reps stopped halfway up, where the cable still pulls hard.
            "top": curlStoppedShortOfTop(from: 0.64, to: 0.5).seen(0.4),
            // The near (right) hand only: from the side the two arms line up
            // and a second folded hand and the bar cross the near forearm.
            "grip": curlWristsCurled("R").seen(0.4),
            "torso": preacherRockedBack(22).seen(0.4)
        ],
        // The Dumbbell Preacher Curl's body on a preacher bench, yaw -1.1;
        // -0.4 turns to a true left side view. Only the LEFT arm curls, with
        // the palm facing in.
        "Preacher Hammer Curl": [
            "pad": curlArmsOffPad(25, side: "L").seen(-0.4),
            "range": curlBottomCut("L", from: 0.8, to: 0.885).seen(-0.4),
            // The thumb-up wrist giving way toward the little finger near the
            // bottom.
            "grip": curlWristsGivingWay("L").seen(-0.4),
            "torso": preacherRockedBack(22, side: "L").seen(-0.4),
            // Seat too low, as for the Dumbbell Preacher Curl.
            "seat": preacherSatLow.seen(0.5)
        ],
        // Same bench, an EZ bar overhand; framed at yaw -0.8, zoom 1.0. Pad
        // and wrist keep the framing's own view: turned further left the
        // near plate covers the head at the top and the two lifted upper arms
        // fall on one line (they separate from -0.9 on). Range and torso turn
        // -0.4 (total -1.2): the two short forearms stay apart at the bottom,
        // and the leaning ghost's spine, neck and head clear the near plate
        // (which covers the real head at the top; from -0.8 the ghost's head
        // and near arm were drawn on the plate). Seat +0.5 (total -0.3) keeps
        // both plates off the trunk (at -0.6 the near plate covers the ghost
        // spine).
        "Reverse Preacher Curl": [
            "pad": curlArmsOffPad(25),
            "range": curlBottomCut(from: 0.8, to: 0.885).seen(-0.4),
            // Palm-down wrists dropping into flexion near the bottom; from
            // -0.8 both hands show between the plates and the two dropped
            // hands separate (from the side both sit behind the near plate).
            "wrist": curlWristsGivingWay(withBar: true),
            // The far (right) arm only: from -1.2 the two lifted upper arms
            // fall on one line that crosses the spine (as the pad did).
            "torso": preacherRockedBack(22, side: "R").seen(-0.4),
            "seat": preacherSatLow.seen(0.5)
        ],
        // Same bench, an Olympic bar underhand; framed at yaw -0.8, zoom
        // 0.602. The top-of-rep faults keep the framing's own view: turned
        // further left (-0.9 and beyond) the near plate reaches the left
        // shoulder, where the lifted arms start, and the leaning ghost's head.
        // Range turns -0.4 (total -1.2) so the two arms stay apart at the
        // bottom (from -0.8 the near upper arm crosses the far forearm); seat
        // +0.5 (total -0.3) keeps both plates off the trunk. The lifter is
        // drawn small here, so the arms lift 35°, the wrists fold 65° (as
        // the Dumbbell Spider Curl) and the seat sinks 0.28 to read at a
        // glance.
        "Barbell Preacher Curl": [
            "pad": curlArmsOffPad(35),
            "range": curlBottomCut(from: 0.8, to: 0.885).seen(-0.4),
            // No bar line: drawn tip to tip it ran along the real bar, just
            // below it, and with the two folded hands read as a lowered bar
            // rather than two bent wrists.
            "grip": curlWristsCurled(degrees: 65),
            // The far (right) arm only: from -0.8 the near arm's forearm lies
            // along the ghost's neck and its upper arm crosses the spine.
            "torso": preacherRockedBack(22, side: "R"),
            "seat": preacherSatLower(0.28).seen(0.5)
        ],
        // MARK: Batch 241-300 standing cable curls (2026-09-27)
        // Standing, framed from the working left side (yaw -1.5), facing the
        // column on the left. Only the LEFT arm curls; the right hand rests on
        // the hip. The upper-arm, range, shoulder and lean-back faults read as
        // framed; the stance turns to the back-left (total -2.6).
        "Single-Arm Cable Curl": [
            "elbow": elbowsForward(35, side: "L"),
            // Short reps: shoulder-to-wrist 0.906 torso lengths at the model's
            // bottom (172°), 0.78 at 120°.
            "range": curlBottomCut("L", from: 0.8, to: 0.89),
            // The near shoulder rolled forward and shrugged, the working arm
            // carried with it; drawn on the working side only: side-on, the
            // free arm's ghost would cross the trunk.
            "shoulder": hunched("L"),
            // Side-on as framed: the lean back and the hips forward lie in the
            // picture plane. Turned toward the front (total -1.05) the column and
            // stack hide the lifter. Drawn on the working side only: the free
            // hand stays on the hip, and side-on its arm's ghost crossed the
            // trunk, the working arm and the lat dot's leader.
            "torso": bodySwungOneArm("L"),
            // Feet drawn together (ankles ~6 cm apart against the model's 30)
            // and knees locked, turned to the back-left (total -2.6) so the
            // width shows: the ankles ~70 pt apart, the ghost's ~15. The turn
            // swings away from the column, which stays beyond the lifter.
            "stance": cableFeetTogetherLocked.seen(-1.1),
        ],
        // Between two pulleys at shoulder height, framed nearly head-on (yaw
        // -0.3): every fault here moves in the plane the camera sees.
        "High Cable Curl": [
            // The upper arms sinking 20° below level as the hands come in.
            "upperarm": armsTurned(.forward, -20, strength: .withBend("forearm_L")),
            // Shoulders shrugged toward the ears (0.12 torso lengths, as
            // `shrugged`), drawn as the girdle and upper arms only, and the
            // undrawn hands are not moved: with the forearms, the raised right
            // hand sat on the top-left pill in the mistake view.
            "shoulder": FaultPose(chains: [shoulders, ["upper_arm_*", "forearm_*"]],
                                  moves: [.shift(["upper_arm_*", "forearm_*"], up: 0.12)]),
            "wrist": armsOutWristsCurled,
            // Short reps: the forearms stay folded 45° toward the head where
            // the arms should be almost straight (shoulder-to-wrist 0.903 torso
            // lengths at the model's 168°, 0.78 at 120°).
            "range": elbowsFolded(.forward, 45, strength: .between("upper_arm_L", "hand_L", from: 0.8, to: 0.885)),
            // Feet drawn together (ankles ~6 cm apart against the model's 30)
            // and knees locked.
            "stance": cableFeetTogetherLocked,
        ],
        // Seated at a pulldown station, framed from the left (yaw -1.3): the
        // faults move front to back and up and down, as framed.
        "Overhead Cable Curl": [
            // The upper arms swinging 30° down and forward as the elbows bend,
            // giving way to the cable (its shoulder moment is extension from
            // ~150° to the top): the bar drifts toward the pulley.
            "upperarm": armsTurned(.lateral, -30, withBar: true, strength: .withBend("forearm_L")),
            // Short reps: the forearms stay folded 45° back where the arms
            // should be almost straight overhead (shoulder-to-wrist 0.899
            // torso lengths at the model's 164°, 0.78 at 120°). This is
            // `curlBottomCut(from: 0.8, to: 0.885)`'s fold and strength drawn
            // and moved to the wrists only: in the mistake view the bar ends
            // sit under the mistake bar, and their guides ran across it.
            "range": FaultPose(chains: [["upper_arm_*", "forearm_*", "hand_*"]],
                               moves: [.turn(pivot: "forearm_*", points: ["hand_*"], axis: .lateral, degrees: 45)],
                               strength: .between("upper_arm_L", "hand_L", from: 0.8, to: 0.885)),
            // The palms face back toward the head with the arms up and down at
            // the top, so the Biceps Curl's fold about `.lateral` curls them in.
            "grip": curlWristsCurled(withBar: true),
            // Rocking back 15° from the hips as the bar comes down; the model
            // sits upright, so the ghost ends 15° behind vertical
            // (`curlSeatedSwungBack(15)`'s turn and strength). Drawn as the
            // spine and the near (left) arm to the wrist, and only those
            // points turn: side-on the far forearm crossed the near upper arm,
            // and the hand tips' guides ran off the right edge.
            "torso": FaultPose(chains: [spine, ["upper_arm_L", "forearm_L", "hand_L"]],
                               moves: [.turn(pivot: "pelvis", points: torso + ["upper_arm_L", "forearm_L", "hand_L"],
                                             axis: .lateral, degrees: 15)],
                               strength: .withBend("forearm_L")),
            // Loose under the pads, rising to follow the bar: the hips and
            // trunk lift 0.18 torso lengths (~10 cm, ~25 pt) off the seat and
            // the knees open from 92° to ~110° over the planted feet
            // (`shallow(0.18)`'s rise, knee re-seat and knee-bend strength,
            // full at the model's 92°). Drawn without the arms, bar or feet
            // (the legs to the ankles, as `preacherSatLow`; the feet stay
            // planted), and only the drawn points move, so no guides run up
            // into the mistake bar and no foot line reaches the pad pill. At
            // 0.1 the ghost all but lay on the body.
            "pad": FaultPose(chains: [spine, ["thigh_*", "shin_*", "foot_*"], hips],
                             moves: [.shift(["pelvis", "thigh_*"] + torso, rise: 0.18), .resolve(["shin_*"])],
                             strength: .withBend("shin_L")),
        ],
        // Between two low pulleys, framed from the right side (yaw +1.4).
        "Cable Hammer Curl": [
            "elbow": elbowsForward(35),
            // Short reps: shoulder-to-wrist 0.906 torso lengths at the model's
            // bottom (172°), 0.78 at 120°.
            "range": curlBottomCut(from: 0.8, to: 0.89),
            // Turned face-on (total 0) so the sideways bend shows; at +0.4 the
            // right stack column hides the right arm.
            "grip": hammerWristsBentBack.seen(-1.4),
            // Side-on as framed; drawn with the near (right) arm only: the far
            // arm's ghost made a second V across the spine and the near arm.
            "torso": bodySwungOneArm("R"),
            // Feet drawn together (ankles ~6 cm apart against the model's 30)
            // and knees locked, turned face-on (total 0).
            "stance": cableFeetTogetherLocked.seen(-1.4),
        ],
        // MARK: Batch 241-300 drag, spider and hammer curls (2026-09-27)
        // Drag curls, standing, framed at yaw -0.8 (Drag Curl, front-left),
        // -0.3 (EZ Bar Drag Curl, near front-on) and +1.1 (Cable Drag Curl,
        // right side to the camera). The bar rides up the body while the
        // elbows go back (upper arms 15-28° behind vertical); every rep starts
        // at ~138° with the bar at the thighs. The elbow and torso faults turn
        // to a true side view (total ±1.5: .seen(-0.7) / .seen(-1.2) /
        // .seen(0.4)), where both arms fold into one V and the lean shows in
        // full (the torso ghost draws the near arm only: side-on the far arm
        // doubles it and its upper arm runs down beside the spine); on the
        // two plate-loaded bars the near plate then stands in front of the
        // real arms at the top (the Olympic plate also the chest), and the
        // ghost is drawn over it. The shrug is seen near front-on (total -0.1
        // / 0 / +0.6; at +0.4 the cable column's back panel hides the far
        // hand; at +0.6 the bar line would cross the far upper arm, so the
        // cable drag curl's shrug leaves it out). The faults of the top read
        // `dragTop`.
        // Grip is seen from the front-left (total -0.8 on both plate-loaded
        // bars: the fold ~72% in the picture plane, the far hand clear of the
        // plate), range from the framing (both hands clear at the bottom).
        "Drag Curl": [
            // The elbows swinging forward into an ordinary curl, the bar
            // arcing out in front of the body (35° about the shoulders).
            "elbow": armsTurned(.lateral, 35, withBar: true, strength: dragTop).seen(-0.7),
            "shoulder": dragShrugged(withBar: true).seen(0.7),
            // No turn (-0.8); framed small, so a deeper 65° fold.
            "grip": dragWristsCurled(65),
            // Short reps: the bar turns round at the stomach (no turn).
            "range": dragCurlShort(from: 0.78, to: 0.84),
            // Leaning back and rocking the hips forward to get the bar up,
            // none of it with the bar still at the thighs. The left arm is
            // the near one.
            "torso": dragSwung(near: "L").seen(-0.7),
        ],
        "EZ Bar Drag Curl": [
            "elbow": armsTurned(.lateral, 35, withBar: true, strength: dragTop).seen(-1.2),
            // Square-on (total 0): both shoulders rise evenly, and the ghost's
            // near shoulder stays clear of the top-right pill.
            "shoulder": dragShrugged(withBar: true).seen(0.3),
            "grip": dragWristsCurled().seen(-0.5),
            // No turn: front-on shows the bar held at the stomach.
            "range": dragCurlShort(from: 0.78, to: 0.84),
            "torso": dragSwung(near: "L").seen(-1.2),
        ],
        "Cable Drag Curl": [
            // The cable drawing the bar out, the elbows swinging forward.
            "elbow": armsTurned(.lateral, 35, withBar: true, strength: dragTop).seen(0.4),
            // No bar line: at +0.6 it runs across the chest and crosses the
            // far upper arm; the hands and tips still show the handle rise.
            "shoulder": dragShrugged(withBar: false).seen(-0.5),
            "grip": dragWristsCurled().seen(0.4),
            "range": dragCurlShort(from: 0.78, to: 0.84).seen(0.4),
            // Leaning back against the cable; the right arm is the near one.
            "torso": dragSwung(near: "R").seen(0.4),
        ],
        // Spider curls: the Spider Curl's body and arm motion exactly, seen
        // from behind on the left (yaw -2.0); +0.45 brings them to a true left
        // side view. Two dumbbells (no bar line) or an EZ bar.
        "Dumbbell Spider Curl": [
            // Chest and shoulders heaving up off the pad (trunk 48° to 30°
            // forward of vertical), the near arm riding with it.
            "pad": spiderPadLifted.seen(0.45),
            "shoulder": spiderShrugged,
            // Upper arms swinging from vertical toward the head.
            "elbow": elbowsForward(30).seen(0.45),
            // Framed small: a deeper fold, the fingers tipping past vertical.
            "grip": curlWristsCurled(degrees: 65).seen(0.45),
            // Half reps: shoulder-to-wrist 0.90 torso lengths at the bottom
            // (170°), 0.81 at ~126°.
            "range": curlBottomCut(from: 0.8, to: 0.89).seen(0.45),
        ],
        "EZ Bar Spider Curl": [
            "pad": spiderPadLifted.seen(0.45),
            "shoulder": spiderShrugged,
            "elbow": elbowsForward(30, withBar: true).seen(0.45),
            // No turn: side-on the near plate covers both hands; from
            // behind (-2.0) the near hand is clear and the fold ~91% in view.
            "grip": curlWristsCurled(withBar: true, degrees: 65),
            "range": curlBottomCut(from: 0.8, to: 0.89).seen(0.45),
        ],
        // Standing, framed at yaw -0.4 like the Alternating Dumbbell Curl. The
        // LEFT arm curls first (0-4 s) with the palm facing in throughout; the
        // elbow and grip faults read the left elbow, so they show during the
        // left curl and fade while the right arm works.
        "Alternating Hammer Curl": [
            // Both shoulders hunched up and forward (the label points at the
            // top of the right trap, on the open side of the frame), drawn
            // as the girdle and upper arms.
            "shoulder": hammerHunched.seen(-0.6),
            "elbow": elbowsForward(35, side: "L").seen(-0.9),
            // The wrist bending in toward the midline; turned to face the
            // lifter (total 0) so the fold reads across the frame.
            "grip": hammerWristBent.seen(0.4),
            // The resting (right) arm left half-bent (elbow ~118°) while the
            // left arm curls; turned to the right side (total +1.1) so the
            // forearm shows swinging forward, not folding across the hips.
            "range": elbowsFolded(.lateral, 60, side: "R", strength: .withBend("forearm_L")).seen(1.5),
            // Either arm's curl: bodySwung's moves, shown as the hands spread
            // apart while one dumbbell rises, drawn without the forearms.
            "torso": hammerSwung.seen(-0.9),
        ],
        // MARK: Batch 241-300 wrist curls (2026-09-27)
        // Six seated models share one body: sitting on the end of a bench,
        // trunk ~55° forward, forearms along the thighs (23° below level),
        // wrists just past the knees; only the wrists (and the finger curl's
        // fingers) move. The barbell and finger curls are framed at yaw -1.0
        // and the cable curls at +1.0, ~57° round to the side; the two
        // dumbbell curls at -0.7 (~40°), where the near plates clear the
        // near fist at the top. The sagittal faults read from there without
        // a turn, except on the dumbbell curls: their trunk rock is seen from
        // -1.0 (`.seen(-0.3)`), where the rocked-back near shoulder stays
        // clear of the top-right pill, and their forearm lift is turned 0.15
        // to the front, so the far elbow does not sit on the near palm's
        // ring. Turning round past about -0.75 puts the near plate over the
        // near fist at the top. Faults of the bottom of the rep use
        // `wristCurlLow` (the Dumbbell Wrist Curl's short bottom
        // `wristCurlBottomShort`), of the top `wristCurlHigh`, the trunk rock
        // included. The trunk faults turn everything above the pelvis, palm
        // points and bar included, so they draw them too.
        "Dumbbell Wrist Curl": [
            // The forearms coming up off the thighs (to level) as the
            // dumbbells rise, the elbows bending to help. Turned 0.15 to the
            // front (-0.55 in total): unturned, the far elbow's dot sat on the
            // near palm's ring and the two arms read as one zig-zag; the near
            // fist stays clear of the plate.
            "forearm": wristCurlForearmsLifted(22, strength: wristCurlHigh).seen(0.15),
            // Wrists back on the thighs: at the bottom the hands hang into the legs.
            "position": wristCurlOnThighs(),
            // Short at the bottom: the hands stop 40° higher, the wrists
            // barely bent back (the lifter's hang 72° below level, the
            // ghost's 31°, held there until the lifter's hands pass it).
            "range": wristCurlHandsTurned(40, strength: wristCurlBottomShort),
            "grip": wristCurlGripSlipping(strength: wristCurlLow),
            // Rocking up from the hips (55° to 43° forward) as the hands curl
            // up, the arms carried up off the thighs. Seen from -1.0, the side
            // view: at -0.7 the ghost's near shoulder landed on the top-right
            // pill's text and the rock was foreshortened.
            "torso": wristCurlTrunkLifted(12, strength: wristCurlHigh).seen(-0.3),
        ],
        "Barbell Reverse Wrist Curl": [
            "forearm": wristCurlForearmsLifted(22, withBar: true, strength: wristCurlHigh),
            "position": wristCurlOnThighs(withBar: true),
            // Short at the top: the knuckles 35° lower, about level (the
            // lifter's hands end 24° above level, the ghost's 11° below, still
            // 11° above the forearms, which slope 22° down). wristCurlHigh
            // ramps over ~33° of the arc, from ~19° below level to ~14°
            // above, which keeps a 35° ghost level with the forearm line at
            // worst mid-rep; a bigger turn would dip it below.
            "top": wristCurlHandsTurned(-35, withBar: true, strength: wristCurlHigh),
            "grip": wristCurlGripSlipping(withBar: true, strength: wristCurlLow),
            "torso": wristCurlTrunkLifted(12, withBar: true, strength: wristCurlHigh),
        ],
        "Dumbbell Reverse Wrist Curl": [
            // As the Dumbbell Wrist Curl's, turned 0.15 to the front.
            "forearm": wristCurlForearmsLifted(22, strength: wristCurlHigh).seen(0.15),
            "position": wristCurlOnThighs(),
            // Short at the top: the knuckles 35° lower, as the barbell
            // version. The far hand is drawn from the wrist: at -0.7 the far
            // elbow sits on the near palm point, and drawn it hid that palm's
            // ring and joined the two hands into one zig-zag. Not turned as
            // the forearm fault is: this cue's pill is top-left, and 0.15 to
            // the front would run its leader through the head.
            "top": FaultPose(chains: [["forearm_L", "hand_L", "hand_L.tip"], ["hand_R", "hand_R.tip"]],
                             moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .lateral, degrees: -35)],
                             strength: wristCurlHigh),
            "grip": wristCurlGripSlipping(strength: wristCurlLow),
            // As the Dumbbell Wrist Curl's, seen from -1.0.
            "torso": wristCurlTrunkLifted(12, strength: wristCurlHigh).seen(-0.3),
        ],
        // The cable bar joins the hands; the cable itself is not drawn.
        "Cable Wrist Curl": [
            "forearm": wristCurlForearmsLifted(22, withBar: true, strength: wristCurlHigh),
            "position": wristCurlOnThighs(withBar: true),
            // Short at the top, where the cable pulls hardest: the palms stop
            // about level (the lifter's curl ends 34° above level, the
            // ghost's about 1° below).
            "top": wristCurlHandsTurned(-35, withBar: true, strength: wristCurlHigh),
            "grip": wristCurlGripSlipping(withBar: true, strength: wristCurlLow),
            "torso": wristCurlTrunkLifted(12, withBar: true, strength: wristCurlHigh),
        ],
        "Cable Reverse Wrist Curl": [
            "forearm": wristCurlForearmsLifted(22, withBar: true, strength: wristCurlHigh),
            "position": wristCurlOnThighs(withBar: true),
            "top": wristCurlHandsTurned(-35, withBar: true, strength: wristCurlHigh),
            "grip": wristCurlGripSlipping(withBar: true, strength: wristCurlLow),
            "torso": wristCurlTrunkLifted(12, withBar: true, strength: wristCurlHigh),
        ],
        // Standing, seen from behind on the left (yaw -2.4). The sagittal
        // faults turn +0.2 (-2.2 in total): the arms and hands moving back
        // show at ~81% of their length (68% unturned), and the near plate
        // stays ~4 cm clear of the left wrist at the top. Further round it
        // covers the wrist: by ~1 cm at -2.1, ~12 cm at -1.9.
        "Behind-the-Back Wrist Curl": [
            // The elbows driving back and bending to pull the bar up.
            "arms": behindWristCurlRowed(back: 30, bend: 50).seen(0.2),
            // Shoulders shrugged up as the bar rises, the arms, grip and bar
            // lifted with them; seen from behind, unturned.
            "shoulders": behindWristCurlShrugged,
            // The arms swinging back 15° from the shoulders (the grip ~14 cm
            // further back, ~8 cm higher) as the bar rises.
            "swing": armsSwungForward(-15, withBar: true, strength: behindWristCurlTop).seen(0.2),
            // Short at the top: the hands 35° less curled (the lifter's point
            // 27° below straight back; the ghost's 62°).
            "range": wristCurlHandsTurned(35, withBar: true, strength: behindWristCurlTop).seen(0.2),
            "stance": behindWristCurlKneesDipped.seen(0.2),
        ],
        // The clip starts at the top (bar in the palms) and reaches the
        // bottom (bar in the fingertips) at ~1.3-1.7 s.
        "Finger Curl": [
            "forearm": wristCurlForearmsLifted(22, withBar: true, strength: wristCurlHigh),
            "position": wristCurlOnThighs(withBar: true),
            // The bar kept in the palms: at the bottom the fingers stay closed
            // and the wrists about straight (the lifter's hands hang 57° below
            // level, the ghost's 27°), the palm point drawn ~3.3 cm back along
            // the hand, to 8.5 cm from the wrist, where the model holds the
            // bar in the palm (the lifter's bar sits 14 cm out, in the
            // fingertips).
            "roll": FaultPose(chains: [["forearm_*", "hand_*", "hand_*.tip"], bar],
                              moves: [.turn(pivot: "hand_*", points: ["hand_*.tip"], axis: .lateral, degrees: 30),
                                      .shift(["hand_*.tip"], ahead: -0.05, rise: 0.025)],
                              strength: wristCurlLow),
            // The fingers closed but the wrists never curled: the hands 30°
            // lower at the top (the lifter's 14° above level, the ghost's 16°
            // below; the model's fingers and wrists close together, so the
            // ghost is read at the top).
            "top": wristCurlHandsTurned(-30, withBar: true, strength: wristCurlHigh),
            // Read at the top, 0.0 s (99% shown).
            "torso": wristCurlTrunkLifted(12, withBar: true, strength: wristCurlHigh),
        ],
        // MARK: Batch 241-300 grip holds (2026-09-27)
        // Each clip is 8 s of stillness, so every fault shows throughout
        // (`.always`) and reads at any moment. The standing holds are framed
        // front-left (yaw -0.5): the palms-in wrist fault is side to side and
        // reads front-on; the forward-and-back faults turn toward the left
        // side (-1.3 in total), as the Farmer's Carry. The posture faults turn
        // further, to -1.5: the posture dot on the front of the chest then
        // stays clear of the ghost's arms, which hang forward over the trunk
        // at -1.3.
        "Plate Pinch Hold": [
            // No "pinch" ghost: the plates rest on the outer thighs, so the
            // wrists cannot curl in without driving the plates' lower edges
            // into the legs. The mistake shows as the ring on the left hand.

            // The plates drifting forward in front of the thighs (the grip
            // ~15 cm ahead).
            "sides": armsSwungForward(14).seen(-0.8),
            "shoulders": holdSlumped().seen(-0.8),
            // Leaning forward, the plates hanging forward under the
            // shoulders (both ~9 cm).
            "posture": holdLeanedForward(10).seen(-1.0),
            // Looking down at the plates.
            "head": lookingDown.seen(-0.8),
        ],
        "Dumbbell Static Hold": [
            // The wrists curling in toward the thighs; the handle, 8 cm below
            // the wrist, carries the heads ~4.6 cm in, about their ~4 cm of
            // clearance from the thighs.
            "grip": holdWristsCurled(.forward, -35),
            // The dumbbells drifting forward of the thighs.
            "sides": armsSwungForward(14).seen(-0.8),
            "shoulders": holdSlumped().seen(-0.8),
            "posture": holdLeanedForward(10).seen(-1.0),
            "head": lookingDown.seen(-0.8),
        ],
        // Framed at yaw -0.8, which shows forward-and-back moves at about
        // three-quarters of their length, but side-to-side ones nearly as
        // much: from here the head bowing and the shoulders slumping move the
        // way a tilt toward the lifter's right would. The trunk and head
        // faults therefore turn to the side (-1.4 in total), as the Barbell
        // Shrug: there the near (left) plates, 1 m out and 0.19 m ahead,
        // stand in front of the hips and hands, but the ghost's lines are
        // drawn over the plate, and the head, neck, chest and the posture
        // dot on the upper abdomen stay above it. The grip and bar faults
        // stay at -0.8: the wrist kink and the bar's rise read there, and at
        // -1.4 both real hands would be behind the plate.
        "Barbell Static Hold": [
            // Palms back: the hands curl back toward the thighs. The bar is
            // not drawn: from -0.8 its move back runs along its own length.
            "grip": holdWristsCurled(.lateral, -45),
            // The bar drifting forward, away from the thighs.
            "bar": armsSwungForward(14, withBar: true),
            "shoulders": holdSlumped(withBar: true).seen(-0.6),
            // In profile the trunk leans back, the hips come forward and the
            // bar, nearly end-on, comes back onto the ghost's thighs.
            "posture": barRestedOnThighs.seen(-0.6),
            // Looking down at the bar.
            "head": lookingDown.seen(-0.6),
        ],
        // Hanging in a rack, framed at yaw -0.5. Side views stop at -1.0 in
        // total: from about -1.3 to -2.0 the rack's front-left upright (0.69 m
        // out, level with the lifter) stands between the camera and the body.
        // The feet hang behind the lifter, so the upright and its base block
        // cover them from -1.0; the legs fault is seen at -0.8.
        "Towel Grip Hold": [
            // Palms forward, hands up: the fists tipping forward (~8 cm). The
            // body weight pulls straight along the forearms, so the copy calls
            // it a position to avoid, not something fatigue brings on.
            "grip": holdWristsCurled(.lateral, -40).seen(-0.5),
            // A half pull-up; front-on, the elbows flaring as they bend.
            "arms": hangPulledUp,
            // The toes brought down to rest on the floor. Seen at -0.8 in
            // total: at -1.0 the front-left upright's base block stands in
            // front of the ghost's toes and the upright hides the real left toe.
            "legs": hangToesDown(11).seen(-0.3),
            // Swinging: the whole body swings forward under the towels.
            "body": hangSwung(10).seen(-0.5),
            // Craning the chin up and forward to look at the bar.
            "head": chinCraned.seen(-0.5),
        ],
        // MARK: 30-leg set (2026-09-28)
        // MARK: 30-leg set barbell squats (2026-09-28)
        // Framed three-quarter from the lifter's front-left: yaw -1.0 (box,
        // pause, safety bar, Zercher), -0.8 (overhead) and -0.9 (landmine).
        // Sagittal faults turn to a total of -1.4, near side-on (.seen(-0.4),
        // -0.6, -0.5); knees caving in turn to a total of -0.2, near face-on
        // (.seen(0.8), 0.6, 0.7).
        "Box Squat": [
            // The bar slid down the back, the chest tipping further.
            "bar": barSlidLow.seen(-0.4),
            // The back rounding as the chest leans toward the box.
            "back": chestDropped(12, withBar: true).seen(-0.4),
            // Relaxed on the box: the trunk rocks back, the lower back rounds.
            "tight": barbellBoxRockedBack.seen(-0.4),
            // Straight down: knees forward, hips on the box's front edge.
            "sit": barbellBoxKneesForward.seen(-0.4),
            "knee": kneesIn().seen(0.8)
        ],
        "Pause Squat": [
            "bar": barSlidLow.seen(-0.4),
            // The chest sinking and the upper back rounding during the hold.
            "brace": chestDropped(12, withBar: true).seen(-0.4),
            // "pause" has no ghost: cutting the pause short and bouncing is
            // a matter of timing, not a position the ghost could draw.
            // Pausing above parallel: the hips ~13 cm higher.
            "depth": shallow(0.22, withBar: true).seen(-0.4),
            "knee": kneesIn().seen(0.8)
        ],
        "Safety Bar Squat": [
            // Handles held loosely out in front, the arms reaching forward.
            "handles": barbellHandlesPushedAway.seen(-0.4),
            // The upper back rounding, the chest dropping toward the knees.
            "torso": chestDropped(12).seen(-0.4),
            "knee": kneesIn().seen(0.8),
            "depth": shallow(0.22).seen(-0.4),
            "feet": heelsUp().seen(-0.4)
        ],
        "Zercher Squat": [
            // The elbows swinging away from the body and the hands dropping,
            // the chest following.
            "crook": barbellZercherArmsSagging.seen(-0.4),
            "back": chestDropped(14).seen(-0.4),
            "knee": kneesIn().seen(0.8),
            "depth": shallow(0.22).seen(-0.4),
            "feet": heelsUp().seen(-0.4)
        ],
        "Overhead Squat": [
            // The arms drifting forward about the shoulders, the bar ~14 cm
            // ahead of the ankles at the bottom.
            "bar": armsTurned(.lateral, -14, withBar: true, strength: .withBend("shin_L")).seen(-0.6),
            // The elbows softening, the bar sinking toward the head.
            "elbows": barbellOverheadElbowsBent.seen(-0.6),
            // The chest dropping forward, the bar going with it.
            "torso": leanedForward(18, withBar: true).seen(-0.6),
            "knee": kneesIn().seen(0.6),
            "depth": shallow(0.22, withBar: true).seen(-0.6)
        ],
        "Landmine Squat": [
            // The handle drifting away from the chest, the arms reaching.
            "handle": barbellLandmineHandleAway.seen(-0.5),
            // Folding at the hips, the chest dropping toward the handle.
            "torso": chestDropped(15).seen(-0.5),
            "depth": shallow(0.22).seen(-0.5),
            "knee": kneesIn().seen(0.7),
            "feet": heelsUp().seen(-0.5)
        ],
        // MARK: 30-leg set calf raises (2026-09-28)
        // All five do two reps in 8 s: about a second up, most of a second
        // held at the top, ~1.7 s down, a short pause with the heels level.
        // Standing, seated and single-leg are framed from the lifter's front
        // left (yaw -1.3), near side-on: faults in the lifter's sagittal
        // plane need no turn. The Smith machine is framed three-quarter
        // (-0.8): sagittal faults turn -0.5 (a total of -1.3). The leg press
        // is framed from behind on the left (-2.4, ~47° past a side view):
        // its faults turn 0.4 to -2.0, the view the leg press family reads
        // its sagittal faults from. The single-leg lean toward the handle is
        // side to side, so it turns faceOn (a total of -0.2). Every "tempo"
        // cue has no ghost: dropping fast and bouncing out of the bottom is a
        // matter of speed, not position.
        "Standing Calf Raise": [
            // Hips pushed back under the pads, the chest tipping forward.
            "body": calfHipsBack,
            // Dipping at the knees at the bottom.
            "knees": calfKneesDipped(body: carried),
            // Heels only half-way up at the top.
            "top": calfStoppedShortOfTop(body: carried),
            // Heels held half-way up at the bottom.
            "bottom": calfHeelsLeftHigh(body: carried)
        ],
        "Seated Calf Raise": [
            // Feet far out in front, the knees opening past a right angle.
            "knees": calfSeatedFeetForward,
            // Leaning back and hauling on the handles.
            "trunk": seatedRocked(12),
            "top": calfSeatedShortOfTop,
            "bottom": calfSeatedHeelsLeftHigh
        ],
        "Leg Press Calf Raise": [
            // The knees bending and the sled sinking at the bottom.
            "knees": calfPressKneesBent.seen(0.4),
            // The knees snapped straight under the sled.
            "lock": kneesSnapped.seen(0.4),
            "top": calfPressShortOfTop.seen(0.4),
            "bottom": calfPressHeelsLeftHigh.seen(0.4)
        ],
        "Single-Leg Calf Raise": [
            // Leaning to the right and pushing down on the handle, which sits below
            // the shoulder; face-on.
            "support": pulledOnSupport(strength: .always).seen(faceOn),
            "knee": calfKneesDipped("L", body: calfOneLegBody, reseat: ["forearm_R"]),
            "top": calfStoppedShortOfTop("L", body: calfOneLegBody, reseat: ["forearm_R"]),
            "bottom": calfHeelsLeftHigh("L", body: calfOneLegBody, reseat: ["forearm_R"])
        ],
        "Smith Machine Calf Raise": [
            // Hips pushed back under the fixed bar.
            "body": calfHipsBack.seen(-0.5),
            // Dipping at the knees; the bar drops straight down its track.
            "knees": calfKneesDipped(body: carried).seen(-0.5),
            "top": calfStoppedShortOfTop(body: carried, back: 0).seen(-0.5),
            "bottom": calfHeelsLeftHigh(body: carried, forward: 0).seen(-0.5)
        ],
        // MARK: 30-leg set machine squats (2026-09-28)
        // Belt Squat is framed side-on from the left (yaw -1.5), the view
        // its forward-line faults used to turn to (they turned -0.7 from the
        // old three-quarter framing at -0.8), so those need no turn now: at
        // -1.5 both knees, both ankles and the hips are clear of the machine
        // all rep (at -1.3 the front upright hides one knee). The knees
        // caving in turns -1.6 (a total of -3.1, from behind, as before):
        // the move is side to side, which side-on reads end-on, and turning
        // the other way to face-on puts the trolley's plates in front of the
        // legs (+1.6: the right knee and ankle; +1.3: the left knee and both
        // ankles, as the earlier review found); from behind both knees
        // and both ankles are clear at every moment, while 0.3 off it
        // either way (totals -2.8, -3.4) the belt's webbing covers one knee
        // at the bottom. Pendulum Squat and V-Squat are
        // framed side-on from the left (yaw -1.3): forward-line faults need
        // no turn, the knees caving in turns faceOn (a total of -0.2; the
        // machine is behind them, so the legs are clear). Both legs work
        // together on all three, so the faults use `*` and `shin_L` for the
        // bend.
        "Belt Squat": [
            // Feet ahead of the cable: the hips sit back behind the heels.
            // Seen from the framing: the feet slide ~12 cm toward the
            // upright along the deck and the shins stand up.
            "cable": machineFeetAheadOfCable,
            // "hands" has no ghost: hauling on the handles is a matter of
            // force, not position (the hands stay on the fixed handles
            // either way).
            // From behind (-1.5 - 1.6 = -3.1): the knees fold in across the
            // screen, ~10 cm each.
            "knee": kneesIn().seen(-1.6),
            // Stopping with the knees near a right angle: the hips ~21 cm
            // higher, straight up (they barely move back in this model), the
            // knees opening from 54° to ~88°; the arms are left out, since
            // the hands stay on the fixed handles. Seen from the framing.
            "depth": shallow(0.35, withArms: false),
            // Seen from the framing: the heel rocks up off the deck and the
            // knee drives forward.
            "heel": heelsUp()
        ],
        "Pendulum Squat": [
            // The hips and lower back peeling off the pad at the bottom.
            "pad": machineHipsOffPad,
            // The heels lifting off the heel-high plate.
            "feet": heelsUp(),
            "knee": kneesIn().seen(faceOn),
            // Stopping partway down the arc: the hips ~18 cm higher and
            // ~18 cm further forward, near where the arc passes on the way
            // down, the knees re-seated forward (knee 78° -> ~90°, ~21 cm
            // ahead of the ankle instead of ~9 cm).
            "depth": shallow(0.3, ahead: 0.3)
            // "tempo" has no ghost: bouncing out of the bottom is a matter of
            // speed, not position.
        ],
        "V-Squat": [
            "pad": machineHipsOffPad,
            "feet": heelsUp(),
            "knee": kneesIn().seen(faceOn),
            // Stopping near a right angle at the knee: the hips ~15 cm higher
            // and ~5 cm further back, where this machine's path has them
            // (knee 71° -> ~99°, the thighs well above parallel).
            "depth": shallow(0.26, ahead: -0.09)
            // "tempo" has no ghost: bouncing out of the bottom is a matter of
            // speed, not position.
        ],
        // MARK: 30-leg set leg presses (2026-09-28)
        // The pelvis never moves in these models, so every fault reads the
        // knee's bend. The four 45-degree presses are framed at yaw -2.0 and
        // the vertical press at -2.2, rear three-quarter views from the
        // lifter's left, 25° and 36° off a true side view: moves in the
        // lifter's sagittal plane (hips off the seat, the back arching, the
        // feet down the platform, the knees snapping straight) read without a
        // turn. The knees caving in move along the lifter's side-to-side
        // axis, only 25-36° off the camera's line of sight at these yaws, so
        // those faults turn the model toward a view from behind the head. On
        // the vertical press that is a total of -3.14 (-0.94): the knees sit
        // well above the head there. On the four 45-degree presses a total of
        // -3.14 put the head between the knees and under the caved ghost
        // knees, so they turn to a total of -2.7 (-0.7), which moves the head
        // to the right of the knees with the caving almost as wide.
        "Vertical Leg Press": [
            // The heels peeling off the plate at the bottom.
            "feet": heelsUp(),
            "lockout": kneesSnapped,
            "knee": kneesIn().seen(-0.94),
            // The hips curling up off the pad, the lower back rounding.
            "depth": pressHipsCurled,
            // Pushing on the thighs with the hands.
            "grip": pressHandsOnKnees
        ],
        "45-Degree Leg Press": [
            // Feet ~12 cm low on the platform: knees past the toes, heels up.
            "feet": pressFeetLow(),
            "lockout": kneesSnapped,
            "knee": kneesIn().seen(-0.7),
            "depth": pressHipsCurled,
            // The lower back arching off the pad.
            "back": lowerBackArched(0.14)
        ],
        "Single-Leg Press": [
            // The working (left) foot low on the platform, its heel up.
            "foot": pressFeetLow("L"),
            "lockout": pressLeftKneeSnapped,
            "knee": kneesIn("L").seen(-0.7),
            // The working hip lifting off the seat, the pelvis tilting.
            "hip": pressHipLifted,
            "back": lowerBackArched(0.14)
        ],
        "Narrow-Stance Leg Press": [
            // Feet touching, the knees crowding in together.
            "stance": pressFeetTogether.seen(-0.7),
            "lockout": kneesSnapped,
            // A smaller cave than the default 0.17: these knees start only
            // 0.11 m from the midline, so 0.09 (~5 cm each) brings them to
            // ~0.06 m, just touching, instead of through each other.
            "knee": kneesIn("*", 0.09).seen(-0.7),
            "depth": pressHipsCurled,
            "back": lowerBackArched(0.14)
        ],
        "Wide-Stance Leg Press": [
            // Wide but low on the platform: knees past the toes, heels up.
            "stance": pressFeetLow(),
            "lockout": kneesSnapped,
            "knee": kneesIn().seen(-0.7),
            "depth": pressHipsCurled,
            "back": lowerBackArched(0.14)
        ],
        // MARK: 30-leg set single-leg and heel-elevated squats (2026-09-28)
        // The heel-elevated and cyclist squats are framed three-quarter from
        // the left (yaw -1.0): sagittal faults turn -0.4 (a total of -1.4, near
        // side-on), knee and stance faults turn 0.8 (a total of -0.2, near
        // face-on). The pistol stands on its LEFT leg, framed at -1.2:
        // sagittal faults turn -0.2 (total -1.4), the knee caving turns faceOn
        // (total -0.1). The assisted pistol, the same legs, is framed side-on
        // at -1.6: sagittal faults need no turn, the knee turns 1.4 (total
        // -0.2); the upright stands off to the lifter's left at the crossbar's
        // left end, clear of the standing knee, and the crossbar runs above
        // the knees.
        "Heel-Elevated Squat": [
            // The bar slid down the back, the chest tipping to balance it.
            "bar": barSlidLow.seen(-0.4),
            // The chest folding toward the knees, the bar out over the toes.
            "torso": leanedForward(15, withBar: true).seen(-0.4),
            // Stopping halfway: the hips ~18 cm higher, the knees ~77°; faded
            // by hip height, as the model's knees never straighten.
            "depth": singleSquatShallow(0.3).seen(-0.4),
            "knee": kneesIn().seen(0.8),
            // The heels peeling off the wedges.
            "heels": heelsUp().seen(-0.4)
        ],
        "Cyclist Squat": [
            // Feet set out wide like a regular squat.
            "stance": singleStanceWide.seen(0.8),
            // Hips back, shins upright, the chest tipping forward.
            "knee": singleSatBack.seen(-0.4),
            "track": kneesIn().seen(0.8),
            "depth": singleSquatShallow(0.3).seen(-0.4),
            "heels": heelsUp().seen(-0.4)
        ],
        "Pistol Squat": [
            // Arms dropped, trunk rocked back: nothing reaching forward.
            "reach": singleArmsDropped.seen(-0.2),
            "depth": singlePistolShallow(0.4).seen(-0.2),
            "knee": kneesIn("L").seen(faceOn),
            // The standing heel lifting.
            "foot": heelsUp("L").seen(-0.2),
            // The free heel dropping to the floor at the bottom.
            "free": singleFreeLegDropped.seen(-0.2)
        ],
        "Assisted Pistol Squat": [
            // Pulling on the bar: body hauled up and in, elbows folded.
            "hold": singlePulledToBar,
            "depth": singleAssistedShallow(0.4),
            "knee": kneesIn("L").seen(1.4),
            "foot": heelsUp("L"),
            "free": singleFreeLegDropped
        ],
        // MARK: 30-leg set wide stances: lateral lunge, Cossack and sumo squats, kettlebell goblet squat (2026-09-28)
        // Lateral Lunge and Cossack Squat shift from side to side (rep 1 over
        // the LEFT leg, rep 2 the RIGHT), so their one-leg faults name the
        // `bent` and `straight` leg and follow the working leg. Both are
        // framed near front-on (yaw -0.3): sagittal faults turn -0.9 (a total
        // of -1.2, the left side, the working leg in rep 1, toward the
        // camera), the knee caving in turns 0.3 to face-on, the straight leg
        // bending turns -0.6 (three-quarter, so both the foot sliding in and
        // the knee folding forward show). The sumo and goblet squats are
        // symmetric: the dumbbell sumo and goblet squats are framed at -0.5
        // and the barbell sumo squat at -0.8; sagittal faults turn to -1.2,
        // knees caving in to face-on, the toes turned forward to -0.2.
        "Lateral Lunge": [
            // The back rounding and the head dropping toward the knee; the
            // model already hinges 58° forward, so the ghost rounds rather
            // than leans further.
            "torso": backRounded(.withBend("shin_bent")).seen(-0.9),
            // Hips kept forward: ~9 cm forward, trunk 58° -> 33°, the
            // kneecap 21 cm ahead of the ankle instead of 13 cm (a port of
            // FaultGhost.solve on the rig at 2.0 s); the straight knee folds
            // to ~149° as a side effect.
            "hips": wideHipsForward.seen(-0.9),
            // The straight leg bending, its foot ~7 cm in: the knee folds
            // from 171° to ~139°.
            "trail": wideStraightLegBent(0.12).seen(-0.6),
            "knee": kneesIn("bent").seen(0.3),
            "heel": heelsUp("bent").seen(-0.9)
        ],
        "Cossack Squat": [
            "torso": chestDropped(20, strength: .withBend("shin_bent")).seen(-0.9),
            // Stopping short of parallel (about three quarters down): the hips
            // ~12 cm higher, the hip joint ~7-8 cm above the bent knee instead
            // of 4 cm below it. Kept at 0.2: the
            // straight leg is already at 171° with its foot fixed, so a
            // higher pelvis stretches it (~4% here, ~7% at 0.3).
            "depth": wideSideShallow(0.2),
            // The straight leg bending, its foot ~12 cm in: the knee folds
            // from 171° to ~120° and rises ~17 cm.
            "trail": wideStraightLegBent(0.2).seen(-0.6),
            // The bent knee already sits ~16 cm outside the ankle and ~8 cm
            // outside the toe line (toes out 20°), so the default 0.17 (~10
            // cm) would only bring it onto the toes; 0.3 (~18 cm) puts the
            // ghost knee ~2 cm inside the ankle, over the arch.
            "knee": kneesIn("bent", 0.3).seen(0.3),
            "heel": heelsUp("bent").seen(-0.9)
        ],
        "Dumbbell Sumo Squat": [
            "torso": chestDropped(15).seen(-0.7),
            // Stopping at a half squat: the hips and the dumbbell ~21 cm up.
            "depth": shallow(0.35),
            // The dumbbell swinging forward in front of the knees.
            "hold": armsSwungForward(25, strength: .withBend("shin_L")).seen(-0.7),
            "knee": kneesIn().seen(0.5),
            // Toes turned from 35° out to straight ahead (within 3°).
            "stance": wideToesForward.seen(0.3)
        ],
        "Barbell Sumo Squat": [
            // The bar slid down onto the rear delts, the chest tipping 10°.
            "bar": barSlidLow.seen(-0.4),
            "torso": chestDropped(12, withBar: true).seen(-0.4),
            "depth": shallow(0.35, withBar: true),
            "knee": kneesIn().seen(0.8),
            "stance": wideToesForward.seen(0.6)
        ],
        "Kettlebell Goblet Squat": [
            "hold": wideBellSagging.seen(-0.7),
            "torso": chestDropped(15).seen(-0.7),
            "knee": kneesIn().seen(0.5),
            "depth": shallow(0.35),
            "heel": heelsUp().seen(-0.7)
        ],
        // BEGIN Redone 190-280 (2026-09-30)
        // MARK: Redone 190-280: Machine Preacher Curl (2026-09-30)
        // The Machine Biceps Curl's plate-stack curl machine with the arm pad
        // and pivots higher: seated, chest to the pad, both upper arms 45°
        // below horizontal (the Machine Biceps Curl's 55°), both elbows on
        // the lever's pivots, palms up on a straight handle, elbows 162° to
        // 62°. Framed at yaw -1.0 like the Machine Biceps Curl; -0.5 turns to
        // a true left side view, where the elbows line up with the pivots.
        // The lowering-speed cue is tempo and has no ghost.
        "Machine Preacher Curl": [
            // Seat too low: the body and upper arms 0.1 torso lengths lower,
            // the hands on the handle, so the elbows end ~8 cm below and
            // ~2.5 cm behind the pivots at the bottom (read there). The legs
            // stop at the ankles (the near foot is behind the base rail).
            "pivot": curlMachineSatLowToAnkles.seen(-0.5),
            // The upper arms lifting off the pad at the top, from 45° to 20°
            // below horizontal.
            "pad": curlArmsOffPad(25).seen(-0.5),
            "grip": curlWristsCurled().seen(-0.5),
            // Short reps: shoulder-to-wrist 0.897 torso lengths at the model's
            // bottom (162°), ~0.8 at ~122°.
            "range": curlBottomCut(from: 0.8, to: 0.885).seen(-0.5)
        ],
        // END Redone 190-280 (2026-09-30)
        // BEGIN 351-400 (2026-09-30)
        // MARK: 351-400 hinge family (2026-09-30)
        // Good Morning and Seated Good Morning are framed from behind the
        // lifter's left (yaw -2.3), the back and bar toward the camera: the
        // forward-line faults turn 0.9 (a total of -1.4, near side-on from the
        // left), where the trunk's lean, the hips and the bar read in profile;
        // the seated feet turn -0.5 (total -2.8, from behind), where the
        // stance width runs across the screen. The Smith Machine Good Morning
        // is framed three-quarter from the front-left (yaw -1.0): its faults
        // turn -0.4 (total -1.4), as the Smith lifts before it. The Nordic,
        // Assisted Nordic and Glute-Ham Raise are framed side-on from the left
        // (yaw -1.4) and need no turn. Every model works both legs together,
        // so the faults use `*` and `shin_L`. Checked offline with a copy of
        // FaultGhost.solve on the clips every 0.25 s through the first rep:
        // the Smith bar ghosts stay on the bar's fixed line, no stop-short
        // ghost tips past upright, the Nordics' ghost heads stay >= 33 cm up and
        // the propped palms land on the mat (5 cm up).
        "Good Morning": [
            // The bar low on the back of the shoulders, ~7 cm down the back.
            "bar": hingeGMBarLow.seen(0.9),
            "back": backRounded(hingeGMLean).seen(0.9),
            // The hips staying over the heels, the chest out over the toes.
            "hips": hingeGMWaistFold(hingeGMLean).seen(0.9),
            // The knees bending to ~40° as the hips sink ~5 cm.
            "knee": hingeGMKneesBending(hingeGMLean).seen(0.9),
            // Stopping short: a nod, the trunk ~16° forward at the bottom
            // instead of 64°.
            "depth": hingeGMShort(48, hingeGMLean).seen(0.9)
        ],
        "Seated Good Morning": [
            "bar": hingeGMBarLow.seen(0.9),
            // The lower back rounding at the bottom of the lean.
            "back": backRounded(hingeSeatedLean).seen(0.9),
            // Leaning by curling the upper back, the hips hardly folding.
            "hinge": hingeSeatedUpperBackCurl.seen(0.9),
            // Feet pulled in close, from behind.
            "feet": hingeSeatedFeetNarrow.seen(-0.5),
            // Stopping short: a nod, the trunk ~15° forward at the bottom
            // instead of 55°.
            "range": hingeGMShort(40, hingeSeatedLean).seen(0.9)
        ],
        "Smith Machine Good Morning": [
            "bar": hingeSmithBarLow.seen(-0.4),
            // Feet ~21 cm forward, out in front of the bar (read at the top).
            "feet": hingeSmithFeetForward.seen(-0.4),
            // Squatting the bar down the rails.
            "hips": hingeSmithSquatted.seen(-0.4),
            // The upper back rounding, the chest caving and the head dropping.
            "back": headDropped(hingeSmithLean).seen(-0.4),
            // Knees locked straight all rep.
            "knee": FaultPose(chains: [legs], moves: [.straighten(["shin_*"])], view: -0.4)
        ],
        "Nordic Hamstring Curl": [
            "line": hingeNordicHipsBent,
            "lower": hingeNordicDropped(12),
            // Stopping short: the body ~34° forward at the bottom, not 75°.
            "range": hingeNordicShort(50),
            "anchor": hingeNordicHeelsUp(25),
            "hands": hingeNordicPropped
        ],
        "Assisted Nordic Curl": [
            // A band so strong the lifter hangs in it and barely leans: the
            // body ~26° forward at the bottom, not 75°.
            "band": hingeNordicShort(60),
            "line": hingeNordicHipsBent,
            "lower": hingeNordicDropped(12),
            "anchor": hingeNordicHeelsUp(25),
            "hands": hingeNordicPropped
        ],
        "Glute-Ham Raise": [
            "pad": hingeGHRKneesOnPad,
            "feet": hingeGHRFeetLoose,
            "line": hingeNordicHipsBent,
            // Stopping halfway: the body ~42° forward at the bottom, not 83°.
            "range": hingeNordicShort(45)
            // "lower" has no ghost: dropping fast and bouncing is a matter of
            // speed, not position.
        ],
        // MARK: 351-400 hip family (2026-09-30)
        // The frog pumps lie face up framed side-on from the lifter's left
        // (yaw -1.57): the hips move up and down the screen, so the hip,
        // back and head faults need no turn; the knees closing move across
        // the line of sight, so they turn 0.9 toward the feet (a total of
        // -0.67), and the feet sliding away turn 0.7 so the toes stay in
        // frame. Cable adduction, standing abduction and the banded seated
        // abduction are framed near face-on (yaw -0.3): side-to-side and
        // up-and-down faults need no turn, forward-and-back ones turn -0.6
        // to -1.1, and the cable twist turns 1.3 to the front-right. The side-lying abduction and the clamshell
        // are framed from behind (yaw 3.14): up-and-down and head-to-feet
        // faults show as they are, forward-and-back ones (leg drifting
        // forward, pelvis rolling back, hips straightening, back arching)
        // turn 1.1 to look from the feet end. Only the left leg works in the
        // single-leg models (the right stands or lies underneath). The
        // banded abduction's band-placement cue has no ghost, nor has the
        // clamshell's arched-back cue: lying on the side, an arch bends the
        // spine in a level plane, which a camera turned about the vertical
        // sees edge-on from every side (the old ghost was a flat row of dots).
        "Frog Pump": [
            // Stopping short: the hips ~12 cm below the top.
            "hips": hipFrogShort,
            // The lower back bowing up at the top.
            "ribs": hipFrogArched,
            // Feet ~13 cm further from the hips, knees opening, turned
            // toward the feet so the slid toes stay in the viewport.
            "feet": hipFrogFeetFar.seen(0.7),
            // Knees up and together into an ordinary bridge.
            "knees": hipFrogKneesIn.seen(0.9),
            "head": hipFrogHeadUp
        ],
        "Weighted Frog Pump": [
            // Stopping short: the hips and the dumbbell with them ~12 cm low.
            "hips": hipsShortOfLockout(0.2, strength: hipFrogTop),
            // The dumbbell rolled ~15 cm up onto the stomach as the hips
            // rise, the hands with it.
            "dumbbell": barRolledUp(0.25, strength: hipFrogTop),
            "ribs": hipFrogArched,
            "feet": hipFrogFeetFar.seen(0.7),
            "knees": hipFrogKneesIn.seen(0.9)
        ],
        "Cable Hip Adduction": [
            // Twisting toward the standing leg as the foot crosses, seen
            // from the front-right so the shoulders open toward the camera.
            "torso": hipCableTwist.seen(1.3),
            // Hauling on the post, the trunk tipping toward the stack.
            "grip": hipCableHauled,
            // The pelvis tilting down on the working side at the crossing,
            // the foot carried further across.
            "hips": hipCableHipDropped,
            // The knee bending, the lower leg swinging back, seen from the
            // front-left, clear of the post and stack.
            "leg": hipCableKneeBent.seen(-0.6),
            // Stopping at the midline.
            "sweep": hipCableShort
        ],
        "Standing Hip Abduction": [
            // The trunk tipping 12 deg away from the lifting leg.
            "torso": leanedAway(12, strength: hipStandOut),
            // Leaning the chest forward onto the rails, the hands staying put.
            "grip": seatedRocked(-15).seen(-0.9),
            "hips": hipStandHiked,
            "lift": hipStandSwungHigh,
            "foot": hipStandToesOut
        ],
        "Side-Lying Hip Abduction": [
            "lift": hipSideSwungHigh,
            // Leg forward of the body, toes up: seen from the feet end.
            "line": hipSideLegForward.seen(1.1),
            // Pelvis and shoulders rolling back: seen from the feet end.
            "hips": hipRolledBack.seen(1.1),
            "waist": hipSideHitched,
            "head": hipSideHeadUp
        ],
        "Banded Hip Abduction": [
            // Rocking the trunk back 12 deg, seen near side-on.
            "torso": seatedRocked(12).seen(-1.1),
            // Pressing through the hands, the hips and trunk lifting off the
            // bench between the arms: seen face-on.
            "grip": hipBandHipsUp,
            "knees": hipBandShort,
            // The heels lifting as the knees push out.
            "feet": heelsUp().seen(-1.1)
        ],
        "Clamshell": [
            "open": hipClamShort,
            // Hips nearly straight: seen from the feet end.
            "angle": hipClamHipsStraight.seen(1.1),
            // Pelvis rolling back: seen from the feet end.
            "pelvis": hipRolledBack.seen(1.1),
            "heels": hipClamFootUp
        ],
        // MARK: 351-400 leg curls (2026-10-01)
        // Six knee-flexion curls, one body (torso 0.592 m). The three upright
        // ones curl the LEFT leg and are framed side-on from the left at yaw
        // -1.3 (about 15° short of a true left side view, the front a little
        // toward the camera); the three floor curls lie face up, feet toward
        // the lifter's +z, framed side-on from the left at -1.35. Faults in
        // the lifter's own front-back plane keep the framing, except the two
        // machine pivot faults, turned -0.3 to a true side view so the pivot
        // disc lines up with the knee; the two that move across the body
        // (the pelvis tips) turn to where that move runs across the screen.
        // Distances below were measured with a Python
        // port of FaultGhost.solve on the rigs at the fault's moment
        // (legcurl/ghost.py in the session scratchpad). Roller, cuff and
        // tempo cues and the Swiss ball's heels have no ghost: the roller's,
        // cuff's or heels' place is on the equipment, not a body position,
        // and speed is not a pose.
        "Standing Leg Curl": [
            // Rocking back off the chest pad: the trunk from 8° forward to 7°
            // back at the top, the head ~18 cm and the shoulders ~14 cm back,
            // the elbows re-seated toward straight (the hands stay on the
            // handles).
            "chest": legCurlRocked(15),
            // Short reps: the knee stops at ~118° instead of 73°, the lower
            // leg 28° below level instead of 17° above it (the heel ~30 cm
            // lower).
            "range": curlShort("L", 45),
            // The left knee ~15 cm forward of the pivot at the top, the
            // thigh swung 20° forward. Turned -0.3 to a true left side view:
            // from the framing (15° short of it) the pivot disc, 0.4 m
            // nearer the camera than the knee, shows ~36 pt behind the
            // correct knee, so the real knee already looks off the pivot;
            // side-on the disc covers the real knee (~5 pt off its centre)
            // and the ghost's knee sits ~44 pt off it, past the disc's rim
            // (~29 pt). At 15° it only reached the rim.
            "pivot": legCurlKneeForward(20).seen(-0.3),
            // Bobbing up off the standing (right) heel: the heel 20° up
            // about the toes (the ankle ~6.5 cm higher), both hips 0.1 torso
            // lengths (~6 cm) higher, the right knee re-seated (165° -> 163°).
            // Grows with the left knee's bend, as the bob comes with the
            // curl.
            "stance": FaultPose(chains: [leg("R"), hips],
                                moves: [.turn(pivot: "foot_R.tip", points: ["foot_R"], axis: .lateral, degrees: -20),
                                        .shift(["thigh_*"], rise: 0.1), .resolve(["shin_R"])],
                                strength: .withBend("shin_L"))
            // "pad" has no ghost: the roller's place on the leg.
        ],
        "Kneeling Leg Curl": [
            // Pushing up off the arm pads: the trunk from 50° forward to 32°,
            // the head ~22 cm and the shoulders ~16 cm up and back at the top,
            // the elbows opening from 89° to ~157° between the shoulders and
            // the fixed hands (at 20° they would lock past straight).
            "lean": legCurlRocked(18),
            // The left hip hitching: the left hip and leg 0.12 torso lengths
            // (~7 cm) up, the pelvis 0.05. Turned -1.0 (a total of -2.3, from
            // behind and to the left), where the hip line runs ~31 pt across
            // the screen and its left end lifts ~18 pt; from the framing the
            // two hips sit ~13 pt apart and the tilt reads as a stub.
            "hips": FaultPose(chains: [["thigh_R", "pelvis", "thigh_L"], leg("L")],
                              moves: [.shift(leg("L"), rise: 0.12), .shift(["pelvis"], rise: 0.05)],
                              strength: .withBend("shin_L"), view: -1.0),
            // Short reps: ~118° instead of 73° at the top.
            "range": curlShort("L", 45),
            // Kneeling too far back: the whole body 0.2 torso lengths
            // (~12 cm) back along the pad, so the left knee sits behind the
            // pivot. Turned -0.3 to a true left side view: from the framing
            // the pivot disc shows ~36 pt behind the correct knee, so a
            // knee moved back looked like it moved onto the disc; side-on
            // the correct knee is on the disc's centre and the ghost's knee
            // ~31 pt behind it, at the disc's back rim.
            "pivot": FaultPose(chains: [spine, legs, hips],
                               moves: [.shift(["pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip"] + torso, ahead: -0.2)],
                               view: -0.3)
            // "pad" has no ghost: the roller's place on the leg.
        ],
        "Cable Standing Leg Curl": [
            // Swinging all the way straight between reps: the left lower leg
            // turned 32° toward straight, fading as the knee bends; at the
            // model's start (155°, strength 0.72) the knee ends ~178°, the
            // foot ~16 cm forward; none at the top.
            "range": FaultPose(chains: [leg("L")],
                               moves: [.turn(pivot: "shin_L", points: ["foot_L", "foot_L.tip"], axis: .lateral, degrees: 32)],
                               strength: .whenStraight("shin_L")),
            // Bending forward over the frame: the trunk from 8° to 28°
            // forward at the top, the head ~24 cm forward and down. The arms
            // are left out: with the hands fixed 0.34 m from the shoulders,
            // re-seating the elbows would fold them to ~39°.
            "trunk": FaultPose(chains: [spine],
                               moves: [.turn(pivot: "pelvis", points: torso, axis: .lateral, degrees: -20)],
                               strength: .withBend("shin_L")),
            // The cable dragging the hips toward the stack as the leg lowers:
            // the pelvis, hips and hanging left leg 0.15 torso lengths
            // forward and the mid-spine 0.14, so it sits ahead of the
            // pelvis-chest line (the lower back arches); the right knee
            // re-seats over the planted foot (172° -> 161°). Fades as the
            // left knee bends; at the start (strength 0.72) the hips are
            // ~6.4 cm (~18 pt) forward.
            "hips": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["pelvis", "thigh_*", "shin_L", "foot_L", "foot_L.tip"], forward: 0.15),
                                      .shift(["spine"], forward: 0.14), .resolve(["shin_R"])],
                              strength: .whenStraight("shin_L")),
            // The left knee ~15 cm forward toward the stack at the top, the
            // thigh swung 20° forward.
            "thigh": legCurlKneeForward(20)
            // "cuff" has no ghost: the cuff's place on the ankle.
        ],
        "Swiss Ball Leg Curl": [
            // "heels" has no ghost: the heels' place on the ball (low on
            // its side instead of on top) is not a body position, and moving
            // the heels down the ball would push the toes, already ~20 pt
            // from the screen's left edge, off it.
            // Arching at the top: the lumbar spine ~11 cm (~20 pt) and the
            // chest ~5 cm up with the knees at 90°.
            "ribs": floorCurlArched(0.18, chest: 0.08),
            // The hips sinking as the legs straighten: at the start (knees
            // 164°, strength 0.82) the pelvis ~11 cm (~20 pt) lower, about
            // the ~11 cm the seat is held above the mat, the knees straight
            // between the lowered hips and the heels on the ball.
            "hips": floorCurlHipsDown(0.22, strength: .whenStraight("shin_L")),
            // The arms, which lie toward the feet ~35-40° out from the sides,
            // lifted 30° off the floor: the hands ~24 cm (~45 pt) up.
            "arms": floorCurlArmsUp(.lateral, 30)
            // "tempo" has no ghost: rolling the ball out slowly is speed.
        ],
        "Sliding Leg Curl": [
            // The hips left down as the heels come in: at the top the pelvis
            // 0.44 torso lengths (~26 cm, ~40 pt) lower, at its resting
            // height on the mat (0.21 m), the knees folding from 70° to ~45°
            // over the heels. Grows with how far the heels have come in (the
            // hip-to-ankle distance, 1.41 torso lengths at the start, 0.82 at
            // the top), so the ghost's seat never sinks into the mat: none at
            // the start, where the seat already rests on it.
            "hips": floorCurlHipsDown(0.44, strength: .between("thigh_L", "foot_L", from: 1.41, to: 0.82)),
            // Snapping straight: the knees pushed onto the hip-heel line and
            // 0.06 torso lengths past it, fading as they bend; at the start
            // (164°, strength 0.82) they end ~175°, ~8 cm (~12 pt) lower. The
            // heels stay put: the framing already puts the toes ~16 pt from
            // the screen's left edge.
            "knees": FaultPose(chains: [legs],
                               moves: [.straighten(["shin_*"], past: 0.06)],
                               strength: .whenStraight("shin_L")),
            // Arching at the top: the lumbar spine ~12 cm (~19 pt) up.
            "ribs": floorCurlArched(0.2, chest: 0.09),
            // The arms, out to the sides with the elbows bent ~75°, lifted
            // 40° about the body's long axis: the elbows ~20 cm (~30 pt) and
            // the hands 12-20 cm off the floor.
            "arms": floorCurlArmsUp(.up, 40)
            // "tempo" has no ghost: sliding out slowly is speed.
        ],
        "Single-Leg Sliding Curl": [
            // Kicking the free (right) knee up toward the chest to swing the
            // hips up, as the Single-Leg Glute Bridge's free-leg fault: the
            // right thigh 30° further up, from 68° to ~98° above the floor
            // (just past vertical), the knee ~23 cm (~35 pt) toward the head
            // and the foot ~23 cm higher at the top.
            "free": FaultPose(chains: [leg("R"), hips],
                              moves: [.turn(pivot: "thigh_R", points: ["shin_R", "foot_R", "foot_R.tip"], axis: .lateral, degrees: 30)],
                              strength: .withBend("shin_L")),
            // The free side of the pelvis dropping: the right hip and leg 0.2
            // torso lengths (~12 cm) lower, the pelvis 0.1. Turned +0.7 (a
            // total of -0.65, from the feet end on the left), where the hip
            // line runs ~23 pt across the screen and its right end drops
            // ~19 pt; from the framing the hips sit ~6 pt apart.
            "hips": FaultPose(chains: [["thigh_L", "pelvis", "thigh_R"], leg("R")],
                              moves: [.shift(leg("R"), rise: -0.2), .shift(["pelvis"], rise: -0.1)],
                              strength: .withBend("shin_L"), view: 0.7),
            // As the Sliding Leg Curl: the elbows ~20 cm off the floor.
            "arms": floorCurlArmsUp(.up, 40),
            // Stopping the slide halfway: the left heel 0.25 torso lengths
            // nearer the hips, fading as the knee bends; at the start
            // (strength 0.82) ~12 cm nearer, the knee 116° instead of 164°,
            // about halfway to the top's 70°.
            "range": FaultPose(chains: [leg("L")],
                               moves: [.shift(["foot_L", "foot_L.tip"], ahead: 0.25), .resolve(["shin_L"])],
                               strength: .whenStraight("shin_L"))
            // "tempo" has no ghost: sliding out slowly is speed.
        ],
        // MARK: 351-400 folder, Romanian deadlifts (2026-10-01)
        // The three single-leg RDLs and the B-stance stand on the LEFT leg
        // (the right leg reaches back, or is the B-stance's kickstand), framed
        // side-on from the left at yaw -1.3: sagittal faults need no turn;
        // the free hip opening is across the line of sight, so it turns -1.3
        // (a total of -2.6, from behind on the left; at -0.8 the free foot's
        // sideways swing and its change in depth cancelled on screen). The
        // Smith and cable RDLs are framed at -1.0 and turn -0.2 (total -1.2), the
        // kettlebell RDL and Dumbbell Deadlift at -0.8 and turn -0.4 (total
        // -1.2, as the Dumbbell Romanian Deadlift's faults); the Dumbbell
        // Deadlift's knees caving turn 0.6 (total -0.2, near face-on); the
        // B-stance's loaded kickstand turns -0.5 (total -1.8). Every back
        // ghost is `rdl4BackRounded`, the Pendlay Row's deeper rounding.
        "Single-Leg Romanian Deadlift": [
            "back": rdl4BackRounded(rdl4Hinged),
            // Hips over the foot, waist folding, the free leg hanging.
            "hinge": rdl4ReachedDown,
            // The free hip rolling open, the free leg swinging out.
            "square": rdl4HipOpened().seen(-1.3),
            "knee": rdl4StandingKneeSinks(withBar: false),
            // Rocking onto the toes, the standing heel up.
            "balance": rdl4StandingHeelUp
        ],
        "Barbell Single-Leg Romanian Deadlift": [
            // The bar swinging out in front of the standing leg.
            "barpath": armsSwungForward(22, withBar: true, strength: rdl4Hinged),
            "back": rdl4BackRounded(rdl4Hinged),
            "hinge": rdl4ReachedDown,
            "knee": rdl4StandingKneeSinks(withBar: true),
            // The free hip opening, the bar tipping with it.
            "square": rdl4HipOpened(withArm: true, withBar: true).seen(-1.3)
        ],
        "Dumbbell Single-Leg Romanian Deadlift": [
            // The dumbbells drifting forward toward the toes.
            "path": armsSwungForward(22, strength: rdl4Hinged),
            "back": rdl4BackRounded(rdl4Hinged),
            "hinge": rdl4ReachedDown,
            "knee": rdl4StandingKneeSinks(withBar: false),
            // The free hip opening, that side's dumbbell riding higher.
            "square": rdl4HipOpened(withArm: true).seen(-1.3)
        ],
        "B-Stance Romanian Deadlift": [
            "back": rdl4BackRounded(rdl4Hinged),
            // Both knees bending, the hips sinking: a split squat.
            "hinge": hingeSquatted(withBar: false),
            "path": armsSwungForward(22, strength: rdl4Hinged),
            // The back heel down, the weight spread over both feet. Turned
            // -0.5 (total -1.8, just behind side-on): at -1.3, ~16° in front
            // of side-on, the kickstand's 29 cm to the side cancelled most of
            // its 20 cm back on screen, and the ghost's back leg lay over the
            // front one; from just behind they sit over twice as far apart.
            "front": rdl4KickstandLoaded.seen(-0.5),
            // The back foot stepped far back like a lunge.
            "stance": rdl4KickstandFarBack
        ],
        "Smith Machine Romanian Deadlift": [
            "back": rdl4BackRounded(.withBend("thigh_L")).seen(-0.2),
            // Knees bending, hips sinking under the bar, which slides
            // straight down its track (hingeSquatted swung the bar ~20 cm
            // off the rails).
            "hinge": hingeKneesBending(withBar: true).seen(-0.2),
            // Rounding and sinking once the stretch runs out.
            "range": rdl4ChasedFloor(withBar: true).seen(-0.2),
            // Standing too far back: the lifter back, the bar on its track
            // out over the toes, the arms reaching forward to it.
            "stance": rdl4StoodBackFromBar.seen(-0.2),
            "knee": rdl4KneesLocked.seen(-0.2)
        ],
        "Cable Romanian Deadlift": [
            "hinge": hingeSquatted(withBar: true).seen(-0.2),
            // Leaning back against the cable at the top.
            "lockout": leanedBackAtLockout(withBar: true).seen(-0.2),
            "arms": rdl4ArmsDragged.seen(-0.2),
            "knee": rdl4KneesLocked.seen(-0.2),
            // Standing too close to the pulley.
            "stance": rdl4CloserToPulley.seen(-0.2)
        ],
        "Kettlebell Romanian Deadlift": [
            "back": rdl4BackRounded(.withBend("thigh_L")).seen(-0.4),
            // Knees bending, hips sinking, the chest rising: a squat. The
            // arms turn with the trunk, so the bell comes forward and up.
            "hinge": hingeSquatted(withBar: true).seen(-0.4),
            // Snapping the hips so the bell swings out in front at the top,
            // a kettlebell swing. The hip reads only ~0.62 straight at this
            // model's top, so ~37° of the 60° shows: the hands rise ~25 cm
            // and the bell swings out to about waist height.
            "tempo": armsSwungForward(60, withBar: true, strength: .whenStraight("thigh_L")).seen(-0.4),
            // The bell swinging out away from the shins.
            "path": armsSwungForward(22, withBar: true, strength: .withBend("thigh_L")).seen(-0.4),
            "knee": rdl4KneesLocked.seen(-0.4)
        ],
        "Dumbbell Deadlift": [
            "back": rdl4BackRounded(.withBend("shin_L")).seen(-0.4),
            "lockout": leanedBackAtLockout(withBar: false).seen(-0.4),
            // The hips shooting up first while the chest stays low.
            "hips": rdl4HipsShotUp.seen(-0.4),
            "knee": kneesIn().seen(0.6),
            // The dumbbells drifting forward in front of the knees.
            "path": armsSwungForward(22, strength: .withBend("shin_L")).seen(-0.4)
        ],
        // END 351-400 (2026-09-30)
        // MARK: Exercises 1-50 redo (2026-09-29)
        // MARK: Exercises 1-50 redo: Pendlay Row and Close-Grip Bench Press (2026-09-29)
        // Pendlay Row is framed from behind on the lifter's left (yaw -2.0,
        // ~25° past a side view), like the Barbell Bent-Over Row: its faults
        // are all in the lifter's own sagittal plane, which that view shows,
        // so none turns. Only the arms and bar move in the model (up 1.25 s,
        // held 0.65 s, down 2.1 s, no pause at the floor). Close-Grip Bench
        // Press uses the bench lifts' .bench framing (yaw -1.0), where the
        // lifter's side-to-side and head-to-feet axes both run across the
        // screen: the narrow grip and the flared elbows turn toward the foot
        // end (yaw -0.4) so the hands visibly close in and the two elbows
        // visibly spread, and the low bar path turns side-on (yaw -1.5) so
        // its shift reads as down the body rather than along the bar. The
        // feet fault turns side-on too: in the .bench view the far foot's toes
        // run past the viewport's left edge, and with them the ghost's far
        // toe; side-on both feet sit inside it and the heels and hips lift
        // straight up the screen.
        "Pendlay Row": [
            // The chest swinging up 25° to heave the bar off the floor, the arms hanging.
            "torso": pendlayChestHeave,
            // The back rounding and the head dropping as the bar reaches the floor.
            "spine": pendlayBackRounded,
            // The plates hovering ~12 cm above the floor between reps.
            "floor": pendlayBarHovering,
            // The pull stopping half-way, out in front of the knees.
            "pull": pendlayPulledShort,
            // The shoulders rounded forward toward the floor, hunched over the bar.
            "shoulders": shouldersForward
        ],
        "Close-Grip Bench Press": [
            // Hands nearly touching in the middle of the bar.
            "grip": closeGripHandsTogether.seen(0.6),
            // Upper arms flared ~45° further out from the sides, the hands staying put.
            "elbow": elbowsFlared(45).seen(0.6),
            // Bar lowered onto the stomach and pressed straight up.
            "barpath": closeGripBarLow.seen(-0.5),
            "scapula": benchShoulders,
            // Heels up and hips off the bench, seen side-on so the far foot stays in frame.
            "feet": benchFeet.seen(-0.5)
        ],
        // MARK: 1-50 redo curls (2026-09-29)
        // Standing, both arms together, palms forward from the start; framed
        // at yaw -0.4 like the Biceps Curl, whose faults these follow. The
        // sagittal faults turn to the left side (total -1.3).
        "Dumbbell Curl": [
            // Shoulders shrugged up and rolled forward at the top (as the
            // Alternating Dumbbell Curl's), turned to the front-left.
            "shoulder": hunched().seen(-0.6),
            "elbow": elbowsForward(35).seen(-0.9),
            "grip": curlWristsCurled().seen(-0.9),
            "torso": bodySwung(withBar: false).seen(-0.9),
            // Short reps: shoulder-to-wrist 0.908 torso lengths at the model's
            // bottom (180°), 0.78 at 120°.
            "range": curlBottomCut(from: 0.8, to: 0.9).seen(-0.9)
        ],
        // Seated back on a 65° pad, framed from the front-left at yaw -0.9;
        // -0.6 turns to a true left side view, where the arms hang behind the
        // line of the trunk.
        "Incline Dumbbell Curl": [
            // Bench upright or sitting up off it: the trunk upright and the
            // arms hanging in line with it (read at the bottom).
            "back": inclineSatUpright.seen(-0.6),
            // The upper arms swinging from 25° behind the trunk to 10° in
            // front of it as the dumbbells rise.
            "arms": elbowsForward(35).seen(-0.6),
            // Shoulders rolled forward off the pad (0.11 torso lengths out of
            // the chest, which faces up and forward here).
            "shoulder": shouldersForward.seen(-0.6),
            "grip": curlWristsCurled().seen(-0.6),
            // Short reps: 0.906 torso lengths at the model's bottom (172°),
            // 0.78 at 120°.
            "range": curlBottomCut(from: 0.8, to: 0.89).seen(-0.6)
        ],
        // EZ bar on a preacher bench with two arm pads, seated upright, framed
        // at yaw -0.8 like the Reverse and Barbell Preacher Curls, whose view
        // choices these follow: the faults of the top keep the framing's view
        // (turned further left the near plate covers the head at the top),
        // range and torso turn -0.4, seat +0.5.
        "Preacher Curl": [
            "pad": curlArmsOffPad(25),
            // Half reps at the bottom: 0.899 torso lengths at 164°.
            "range": curlBottomCut(from: 0.8, to: 0.885).seen(-0.4),
            // No bar line, as the Barbell Preacher Curl: drawn tip to tip it
            // runs along the real bar.
            "grip": curlWristsCurled(),
            // The model sits upright, so 15° ends 15° behind vertical; the far
            // (right) arm only, as the Reverse Preacher Curl.
            "torso": preacherRockedBack(15, side: "R").seen(-0.4),
            // Seat too low: the trunk sinks, the shoulders ride up; read at the
            // bottom, with the bar away from the head.
            "seat": preacherSatLow.seen(0.5)
        ],
        // Between two low pulleys ~0.9 m in front, framed from the left side
        // (yaw -1.4): the faults move front to back and up and down, as
        // framed. From the side the two arms line up, so the grip and torso
        // faults draw the near (left) arm only.
        "Cable Curl": [
            // Reps stopped halfway up (the cables still pull hard at the top):
            // shoulder-to-wrist 0.64 torso lengths at 90°, 0.457 at the top.
            "top": curlStoppedShortOfTop(from: 0.64, to: 0.5),
            "grip": curlWristsCurled("L"),
            "elbow": elbowsForward(35),
            "torso": bodySwungOneArm("L"),
            // Short reps: 0.906 torso lengths at the model's bottom (172°).
            "range": curlBottomCut(from: 0.8, to: 0.89)
        ],
        // Back to one low pulley, the LEFT arm working with the upper arm 23°
        // behind the trunk; framed from the left (yaw -1.2), close enough to
        // side-on that the faults read as framed.
        "Bayesian Cable Curl": [
            // The upper arm swinging from 23° behind the trunk to 12° in
            // front of it as the hand rises.
            "elbow": elbowsForward(35, side: "L"),
            // Short reps: 0.906 torso lengths at the model's bottom (172°).
            "range": curlBottomCut("L", from: 0.8, to: 0.89),
            "grip": curlWristsCurled("L"),
            // The working shoulder rolled forward and shrugged, the arm carried
            // with it.
            "shoulder": hunched("L"),
            "torso": cableBehindRockedForward
        ],
        // MARK: Exercises 1-50 redo, forearm (2026-09-29)
        // Standing, an EZ bar overhand; framed at yaw -0.4, nearly face-on,
        // like the Barbell Curl, and turned -0.5 (to -0.9) for the faults
        // that move along the lifter's forward axis, as the Barbell Curl's.
        // The dropped wrists turn too: in the framing's own view the forearms
        // and hands point at the camera from mid-rep up, and on the simulator
        // the ghost hands were ~11 pt stubs and the lowered bar lay along the
        // real bar's middle. From -0.9 each hand is ~24 pt long, bent ~50°
        // below its forearm on screen, and the bar ~22 pt under the real one.
        "Reverse Curl": [
            // Palm-down wrists bending toward the palm under the bar, the
            // hands turned 45° below the forearm line (`curlWristsCurled`
            // turned the other way), with the left elbow's bend: strongest
            // from mid-rep to the top, where the bar pulls the hands down
            // (on the rig the palm point ends ~10° below level at the top
            // against the lifter's 35° above, ~9 cm lower).
            "grip": curlWristsCurled(withBar: true, degrees: -45).seen(-0.5),
            // Upper arms swinging 35° forward as the elbows bend.
            "elbow": elbowsForward(35, withBar: true).seen(-0.5),
            // Half reps: the elbows stay ~45° bent at the bottom (the
            // lifter's 167°, the ghost's ~115-122°), shown from about 126°
            // down; shoulder to wrist 0.80-0.89 torso lengths on the rig
            // (0.90 at the bottom, 0.81 at 126°, 0.65 with the elbow at 90°).
            "range": curlBottomCut(from: 0.8, to: 0.89).seen(-0.5),
            // Hips forward and trunk 15° back to heave the bar.
            "torso": bodySwung(withBar: true).seen(-0.5),
            // Shoulders rolled forward and up at the top.
            "shoulder": reverseCurlShouldersRolled.seen(-0.5),
        ],
        // Seated at a forearm pad, dumbbells palms up; framed at yaw -0.7,
        // from the front-left, the lifter facing left. The forearm lift, the
        // short bottom and the low seat move up and down and read from the
        // framing's own view. The trunk rock and the forearms slid back move
        // along the lifter's forward axis and are seen from -1.0
        // (`.seen(-0.3)`), as the Dumbbell Wrist Curl's trunk rock.
        "Wrist Curl": [
            // The forearms coming up off the pad (20° about the elbows, the
            // wrists ~8 cm higher) as the dumbbells rise, the elbows bending
            // to help.
            "forearm": wristCurlForearmsLifted(20, strength: wristPadTop),
            // Wrists back on the pad: forearms slid ~10 cm back.
            "position": wristPadForearmsBack.seen(-0.3),
            // Short at the bottom: the hands held about level (the knuckles
            // level, the palm point ~8° above; the lifter's palm point ~26°
            // below), the wrists barely bent back.
            "range": wristCurlHandsTurned(35, strength: wristPadBottomShort),
            // Rocking back from the hips (25° to 13° forward) as the hands
            // curl up, the arms carried up off the pad.
            "torso": wristCurlTrunkLifted(12, strength: wristPadTop).seen(-0.3),
            // Seat too low: the body sinks ~12 cm while the forearms stay
            // on the pad, so the shoulders ride up toward the ears.
            "seat": preacherSatLow,
        ],
    ]




}

/// The joints that fix the lifter's own axes: pelvis to neck is "up", right
/// hip to left hip is "left".
enum BodyFrameJoints {
    static let all = ["pelvis", "neck", "thigh_L", "thigh_R"]
}
