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
    /// bench.
    private static func pulloverTooDeep(withBar: Bool) -> FaultPose {
        FaultPose(chains: [armsToGrip] + (withBar ? [bar] : []),
                  moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: 25)],
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

    /// Pulldowns, short reps: the hands stop well above the chest.
    private static let pulldownShort = FaultPose(
        chains: [armsToGrip],
        moves: [.shift(["hand_*", "hand_*.tip"], up: 0.14), .shift(["forearm_*"], up: 0.06)],
        strength: .withBend("forearm_L")
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

    /// One-arm pulls: the working hand stopping short, high.
    private static let leftPullShort = FaultPose(
        chains: [["upper_arm_L", "forearm_L", "hand_L", "hand_L.tip"]],
        moves: [.shift(["hand_L", "hand_L.tip"], up: 0.14), .shift(["forearm_L"], up: 0.06)],
        strength: .withBend("forearm_L")
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
            // Short reps: the hands stop well short of full extension.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], forward: -0.16),
                                         .shift(["forearm_*"], forward: -0.08)]),
            "feet": seatedArched,
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
            // Pulled straight across at chest height instead of rising.
            "barpath": FaultPose(chains: [armsToGrip],
                                 moves: [.shift(["hand_*", "hand_*.tip"], up: -0.14), .shift(["forearm_*"], up: -0.06)]),
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
            "grip": wristBentBack(withBar: true),
            "elbow": pulloverElbowsBent(withBar: true),
            "arc": pulloverTooDeep(withBar: true),
            "ribs": lowerBackArched(0.1, pulloverStretch),
            "feet": benchFeet
        ],
        "Iso-Lateral Chest Press": [
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            "barpath": rangeCutShort,
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Incline Chest Press Machine": [
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            "barpath": rangeCutShort,
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Decline Chest Press Machine": [
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            "barpath": rangeCutShort,
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Plate-Loaded Chest Press": [
            "wrist": handsHigh,
            "elbow": elbowsFlared(34),
            "barpath": rangeCutShort,
            "feet": seatedArched,
            "scapula": shrugged
        ],
        "Wide-Grip Chest Press Machine": [
            "wrist": wristBentBack(withBar: false),
            // Elbows riding up to shoulder height at the back of the rep.
            "elbow": FaultPose(chains: [arms], moves: [.shift(["forearm_*"], up: 0.12)],
                               strength: .withBend("forearm_L")),
            "barpath": rangeCutShort,
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
            // Hands pulled right down to the hips.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: -0.22), .shift(["forearm_*"], up: -0.1)]),
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
            // Stopping with the hands still apart.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.1)]),
            "elbow": flyBentIntoPress,
            "barpath": flyTooDeep,
            "feet": benchFeet,
            "scapula": benchShoulders
        ],
        "Decline Cable Fly": [
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.1)]),
            "elbow": flyBentIntoPress,
            "barpath": flyTooDeep,
            "feet": declineFeetSlipping,
            "scapula": benchShoulders
        ],
        "Cable Crossover": [
            // Hands meeting high, in front of the face.
            "wrist": FaultPose(chains: [armsToGrip],
                               moves: [.shift(["hand_*", "hand_*.tip"], up: 0.2), .shift(["forearm_*"], up: 0.09)]),
            "elbow": flyFolded,
            "barpath": flyPressed,
            "feet": squareLockedStance,
            "scapula": shouldersRolledIn
        ],
        "Single-Arm Landmine Press": [
            "grip": leftWristBentBack,
            "elbow": leftElbowFlared(40, strength: .withBend("forearm_L")),
            // Stopping short: the arm still bent at the top.
            "barpath": FaultPose(chains: [leftArmToGrip],
                                 moves: [.shift(["hand_L", "hand_L.tip"], forward: -0.14, up: -0.1),
                                         .shift(["forearm_L"], forward: -0.05, up: -0.04)],
                                 strength: .whenStraight("forearm_L")),
            // Leaning back to press, turned side-on so the lean shows.
            "core": FaultPose(chains: [spine, leftArmToGrip],
                              moves: [.turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 14),
                                      .shift(["spine"], forward: 0.05)],
                              view: -0.9),
            "feet": squareLockedStance
        ],
        "Incline Push-Up": pushUpFaults,

        // MARK: Batch 133-160 (2026-09-25)
        "Diamond Push-Up": pushUpFaults,
        "Wide-Grip Push-Up": pushUpFaults,
        "Archer Push-Up": pushUpFaults,
        "Medicine Ball Push-Up": pushUpFaults,
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
            // of the bench and the lower back arching.
            "legs": FaultPose(chains: [spine, legs, hips],
                              moves: [.shift(["foot_*", "foot_*.tip"], forward: -0.65, up: 0.12), .shift(["shin_*"], forward: -0.05),
                                      .shift(["spine"], forward: 0.08)]),
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
            "grip": gripTooWide(withBar: true),
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
            "feet": barDrifting(0.15, 0.08, strength: .withBend("shin_L")),
            "spine": backRounded(.withBend("shin_L")),
            "hips": hipsShotUp,
            "grip": gripTooWide(withBar: true),
            "barpath": barDrifting(0.13, 0.07)
        ],
        "Barbell Yates Row": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: true),
            "grip": gripTooWide(withBar: true),
            "feet": trunkLifted(20),
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
            "elbow": elbowsWinged,
            "barpath": rangeCutShort,
            "grip": gripTooWide(withBar: true),
            "pad": chestOffPad,
            "scapula": shrugged
        ],
        "Meadows Row": [
            "grip": leftWristBentBack,
            "elbow": leftElbowWinged,
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
            "elbow": leftElbowWinged,
            "brace": leftTwistedOpen,
            "feet": trunkLifted(20),
            "scapula": leftShoulderForward
        ],
        "Landmine Row": [
            "elbow": elbowsWinged,
            "barpath": rowedShort,
            // Reaching for the handle with rounded shoulders.
            "grip": shouldersForward,
            "feet": backRounded(),
            "scapula": squeezeSkipped
        ],
        "Dumbbell Bent-Over Row": [
            "elbow": elbowsWinged,
            "barpath": rowedHigh(withBar: false),
            // Dumbbells drifting out to the sides.
            "grip": FaultPose(chains: [armsToGrip], moves: [.shift(["hand_*", "hand_*.tip"], outward: 0.13)]),
            "feet": trunkLifted(24),
            "scapula": shouldersForward
        ],
        "Renegade Row": [
            "body": hipsSagging,
            "hands": handsForward,
            "elbow": elbowsWinged,
            // The hips and legs twisting open under the rowing side.
            "hips": FaultPose(chains: [spine, hips, legs],
                              moves: [.turn(pivot: "chest", points: ["spine", "pelvis", "thigh_*", "shin_*", "foot_*", "foot_*.tip"],
                                            axis: .up, degrees: 18)]),
            // Feet drawn together.
            "feet": FaultPose(chains: [legs],
                              moves: [.shift(["foot_*", "foot_*.tip"], outward: -0.14), .shift(["shin_*"], outward: -0.07)])
        ],
        "Gorilla Row": [
            "feet": squareLockedStance,
            "spine": backRounded(),
            "elbow": elbowsWinged,
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
            "elbow": elbowsForward,
            "grip": gripTooWide(withBar: false),
            "barpath": chinCraned,
            "feet": kipping
        ],
        "Neutral-Grip Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward,
            "grip": wristBentBack(withBar: false),
            "barpath": chinCraned,
            "feet": kipping
        ],
        "Archer Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward,
            "grip": gripTooNarrow(withBar: false),
            "barpath": hangingShort,
            "feet": kipping
        ],
        "Weighted Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward,
            "grip": gripTooWide(withBar: false),
            "barpath": chinCraned,
            "feet": kipping
        ],
        "Assisted Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward,
            "grip": gripTooNarrow(withBar: false),
            "barpath": chinCraned,
            // Pushing through the knees: the whole body pressed up off the pad.
            "feet": FaultPose(chains: [spine, legs],
                              moves: [.shift(["pelvis", "spine", "chest", "neck", "head", "thigh_*", "shin_*", "foot_*", "foot_*.tip"], up: 0.12)])
        ],
        "Machine Pull-Up": [
            "scapula": shrugged,
            "elbow": elbowsForward,
            "grip": gripTooNarrow(withBar: false),
            "barpath": chinCraned,
            // Knees bending to push off the platform.
            "feet": FaultPose(chains: [legs, hips], moves: [.shift(["shin_*"], forward: 0.14)])
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
            "elbow": elbowsForward,
            "grip": gripTooWide(withBar: false),
            "barpath": hangingShort,
            "feet": kipping
        ],
        "Wide-Grip Lat Pulldown": [
            "spine": trunkLifted(26),
            "elbow": pulldownFlared,
            "grip": gripTooWide(withBar: true),
            "barpath": pulledBehindNeck,
            "feet": slidForward
        ],
        "Reverse-Grip Lat Pulldown": [
            "spine": trunkLifted(26),
            "elbow": pulldownFlared,
            "grip": gripTooWide(withBar: true),
            "barpath": pulldownShort,
            "feet": slidForward
        ],
        "Neutral-Grip Lat Pulldown": [
            "spine": trunkLifted(26),
            "elbow": pulldownFlared,
            "grip": wristBentBack(withBar: false),
            "barpath": pulledBehindNeck,
            "feet": slidForward
        ],
        "V-Bar Lat Pulldown": [
            "spine": trunkLifted(26),
            "elbow": pulldownFlared,
            "grip": wristBentBack(withBar: false),
            "barpath": pulledPastChest,
            "feet": slidForward
        ],
        "Kneeling Lat Pulldown": [
            "spine": trunkLifted(20),
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
            "spine": trunkLifted(26),
            "elbow": pulldownFlared,
            "grip": shrugged,
            "barpath": pulldownShort,
            "feet": slidForward
        ],
        "Iso-Lateral Lat Pulldown": [
            "spine": trunkLifted(26),
            "elbow": pulldownFlared,
            "grip": shrugged,
            // Leaning over to the working side.
            "barpath": FaultPose(chains: [spine, shoulders],
                                 moves: [.turn(pivot: "pelvis", points: trunk, axis: .forward, degrees: -12)]),
            "feet": slidForward
        ],
        "Single-Arm Lat Pulldown": [
            "core": leftTwistedOpen,
            "elbow": leftElbowWinged,
            "grip": leftWristBentBack,
            "barpath": leftPullShort,
            "feet": slidForward
        ],
        "Wide-Grip Seated Cable Row": [
            "scapula": shouldersForward,
            "elbow": elbowsWinged,
            "grip": gripTooNarrow(withBar: true),
            "barpath": rowedLow(withBar: true),
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
            "elbow": elbowsWinged,
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
            "arc": pulloverTooDeep(withBar: false),
            "ribs": lowerBackArched(0.1, pulloverStretch),
            "feet": benchFeet
        ],
        "Machine Pullover": [
            // Pulling with the hands: the elbows bend further.
            "elbow": FaultPose(chains: [armsToGrip],
                               moves: [.turn(pivot: "forearm_*", points: ["hand_*", "hand_*.tip"], axis: .lateral, degrees: 40)]),
            "grip": wristBentBack(withBar: false),
            // Starting short of the stretch: the arms held lower overhead.
            "arc": FaultPose(chains: [armsToGrip],
                             moves: [.turn(pivot: "upper_arm_*", points: ["forearm_*", "hand_*", "hand_*.tip"], axis: .lateral, degrees: -25)],
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
            "core": leanedBack(14, arch: 0.05).seen(-0.4),
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
            // about -2.0 in all: from the true side the near tower hides the
            // upper body and the lean.
            "torso": leanedBack(20, arch: 0.1).seen(0.95),
            // A bigger shrug than `shrugged`: with the arms overhead the
            // shoulders have to rise clearly above the neck point to read.
            "traps": FaultPose(chains: [shoulders, arms], moves: [.shift(["upper_arm_*", "forearm_*", "hand_*"], up: 0.18)]),
            // Elbows bending as the hands rise; none with the hands crossed at
            // the hips (hand_L to pelvis ~0.22 there, ~1.82 at the top).
            "elbow": elbowsFolded(.lateral, -50, strength: .between("hand_L", "pelvis", from: 0.7, to: 1.4)),
            "height": overheadShort,
            // Handles taken uncrossed: the hands start at the sides, shown at
            // the bottom only.
            "cross": armsTurned(.forward, 20, strength: .between("hand_L", "pelvis", from: 0.6, to: 0.25)),
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
            // The resting (right) arm left half-bent (elbow ~112°) while the
            // left arm curls; turned to the right side (total +1.1) so the
            // forearm shows swinging forward, not folding across the hips.
            "range": elbowsFolded(.lateral, 60, side: "R", strength: .withBend("forearm_L")).seen(1.5),
            // Either arm's curl: bodySwung's moves, shown as the hands spread
            // apart while one dumbbell rises (0.79 torso lengths hanging, 1.07
            // at the top of either curl).
            "torso": FaultPose(chains: [spine, armsToGrip, hips],
                               moves: [.shift(["pelvis", "thigh_*"], ahead: 0.06),
                                       .turn(pivot: "pelvis", points: trunk, axis: .lateral, degrees: 15)],
                               strength: .between("hand_L", "hand_R", from: 0.85, to: 1.0)).seen(-0.9)
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
        ]
    ]




}

/// The joints that fix the lifter's own axes: pelvis to neck is "up", right
/// hip to left hip is "left".
enum BodyFrameJoints {
    static let all = ["pelvis", "neck", "thigh_L", "thigh_R"]
}
