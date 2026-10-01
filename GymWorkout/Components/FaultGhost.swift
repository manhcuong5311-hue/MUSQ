//
//  FaultGhost.swift
//  GymWorkout
//
//  Draws a `FaultPose` over the live model: the limbs the mistake changes, as
//  yellow lines and joints, with a dashed guide from each real joint to where
//  the mistake puts it. Rebuilt every frame from the tracked skeleton, so the
//  ghost moves with the rep and turns with the model.
//

import SwiftUI
import simd

struct FaultGhost: View {
    var fault: FaultPose
    var tracker: JointTracker

    var body: some View {
        Canvas { context, _ in
            guard let pose = FaultGhost.solve(fault, tracker.transforms) else { return }
            let project = { (p: SIMD3<Float>) in tracker.projector?(p) }

            // Where each moved joint came from.
            for (name, ghost) in pose.ghost where simd_distance(ghost, pose.real[name] ?? ghost) > 0.002 {
                guard let a = pose.real[name].flatMap(project), let b = project(ghost) else { continue }
                var guide = Path()
                guide.move(to: a)
                guide.addLine(to: b)
                context.stroke(guide, with: .color(DS.fault.opacity(0.7)),
                               style: StrokeStyle(lineWidth: 1.2, dash: [3, 3]))
                context.stroke(Path(ellipseIn: CGRect(x: a.x - 3, y: a.y - 3, width: 6, height: 6)),
                               with: .color(DS.fault.opacity(0.7)), lineWidth: 1)
            }

            var limbs = Path()
            var joints: [CGPoint] = []
            for chain in pose.chains {
                let points = chain.compactMap { pose.ghost[$0].flatMap(project) }
                guard points.count == chain.count, let first = points.first else { continue }
                limbs.move(to: first)
                for point in points.dropFirst() { limbs.addLine(to: point) }
                joints.append(contentsOf: points)
            }

            // A dark underlay keeps yellow legible on the light ground, the
            // glow carries it on the dark one.
            let round = StrokeStyle(lineWidth: 3.4, lineCap: .round, lineJoin: .round)
            context.stroke(limbs, with: .color(DS.faultShade), style: StrokeStyle(lineWidth: 6.5, lineCap: .round, lineJoin: .round))
            context.drawLayer { glow in
                glow.addFilter(.shadow(color: DS.fault.opacity(0.9), radius: 5))
                glow.stroke(limbs, with: .color(DS.fault), style: round)
            }
            for point in joints {
                let dot = Path(ellipseIn: CGRect(x: point.x - 4.5, y: point.y - 4.5, width: 9, height: 9))
                context.fill(dot, with: .color(DS.fault))
                context.stroke(dot, with: .color(DS.faultShade), lineWidth: 1.2)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: - Pose

    /// World positions of every joint the fault names: as the lifter holds
    /// them (`real`) and as the mistake moves them (`ghost`).
    struct Solved {
        var real: [String: SIMD3<Float>]
        var ghost: [String: SIMD3<Float>]
        /// The fault's lines, with any leading or trailing leg named.
        var chains: [[String]]
    }

    static func solve(_ fault: FaultPose, _ transforms: [String: simd_float4x4]) -> Solved? {
        guard let frame = BodyFrame(transforms) else { return nil }
        var fault = fault
        if fault.alternates {
            guard let side = BodyFrame.leadingSide(transforms) else { return nil }
            fault = fault.leading(side)
        }
        if fault.bends {
            guard let side = BodyFrame.bentSide(transforms) else { return nil }
            fault = fault.bending(side)
        }

        var names = fault.joints.union(fault.chains.joined())
        for move in fault.moves {
            switch move {
            case .shift(let points, _, _, _, _, _): names.formUnion(points)
            case .turn(let pivot, let points, _, _): names.insert(pivot); names.formUnion(points)
            case .straighten, .resolve: break
            }
        }

        var real: [String: SIMD3<Float>] = [:]
        for name in names {
            let bone = FaultPose.bone(name)
            guard let m = transforms[bone] else { return nil }
            let head = SIMD3(m.columns.3.x, m.columns.3.y, m.columns.3.z)
            if name == bone {
                real[name] = head
            } else {
                // A bone's +Y runs head to tail in this rig.
                let along = simd_normalize(SIMD3(m.columns.1.x, m.columns.1.y, m.columns.1.z))
                real[name] = head + along * FaultPose.tipLength(bone) * frame.torso
            }
        }

        let amount = strength(fault.strength, real, torso: frame.torso)
        var ghost = real
        for move in fault.moves {
            switch move {
            case .shift(let points, let forward, let up, let outward, let ahead, let rise):
                for name in points {
                    let side: Float = name.contains("_R") ? -1 : 1
                    let body: SIMD3<Float> = frame.forward * forward + frame.up * up + frame.left * (outward * side)
                    let room: SIMD3<Float> = frame.ahead * ahead + BodyFrame.rise * rise
                    let offset = body + room
                    ghost[name]? += offset * frame.torso * amount
                }
            case .turn(let pivot, let points, let axis, let degrees):
                guard let centre = ghost[pivot] else { continue }
                let mirrored = pivot.contains("_R") && axis != .lateral
                let angle = degrees * amount * .pi / 180 * (mirrored ? -1 : 1)
                let rotation = simd_quatf(angle: angle, axis: frame.turnAxis(axis))
                for name in points {
                    guard let p = ghost[name] else { continue }
                    ghost[name] = centre + rotation.act(p - centre)
                }
            case .straighten(let points, let past):
                for name in points {
                    guard let (a, b) = FaultPose.neighbours(name),
                          let start = ghost[a], let end = ghost[b], let joint = ghost[name] else { continue }
                    let upper = simd_distance(start, joint), lower = simd_distance(joint, end)
                    guard upper + lower > 1e-5 else { continue }
                    let straight = start + (end - start) * (upper / (upper + lower))
                    var target = straight
                    let bend = joint - straight
                    if past > 0, simd_length(bend) > 1e-5 {
                        target -= simd_normalize(bend) * past * frame.torso
                    }
                    ghost[name] = joint + (target - joint) * amount
                }
            case .resolve(let points):
                for name in points {
                    guard let (a, b) = FaultPose.neighbours(name),
                          let hip = ghost[a], let ankle = ghost[b], let knee = ghost[name],
                          let realHip = real[a], let realKnee = real[name], let realAnkle = real[b] else { continue }
                    let upper = simd_distance(realHip, realKnee), lower = simd_distance(realKnee, realAnkle)
                    let span = simd_distance(hip, ankle)
                    guard span > 1e-5 else { continue }
                    let axis = (ankle - hip) / span
                    guard span < upper + lower else {
                        // Out of reach: straight, on the line.
                        ghost[name] = hip + axis * span * upper / (upper + lower)
                        continue
                    }
                    let along = (upper * upper - lower * lower + span * span) / (2 * span)
                    let height = sqrt(max(0, upper * upper - along * along))
                    var side = (knee - hip) - simd_dot(knee - hip, axis) * axis
                    if simd_length(side) < 1e-5 { side = frame.forward - simd_dot(frame.forward, axis) * axis }
                    ghost[name] = hip + axis * along + simd_normalize(side) * height
                }
            }
        }
        return Solved(real: real, ghost: ghost, chains: fault.chains)
    }

    /// 0…1: how much of the fault shows right now.
    private static func strength(_ strength: FaultStrength, _ real: [String: SIMD3<Float>], torso: Float) -> Float {
        func bend(_ joint: String) -> Float {
            guard let (a, b) = FaultPose.neighbours(joint),
                  let j = real[joint], let p = real[a], let c = real[b] else { return 1 }
            let u = simd_normalize(p - j), v = simd_normalize(c - j)
            let angle = acos(max(-1, min(1, simd_dot(u, v)))) * 180 / .pi   // 180 = straight
            return max(0, min(1, (180 - angle) / 90))
        }
        switch strength {
        case .always: return 1
        case .withBend(let joint): return bend(joint)
        case .whenStraight(let joint): return 1 - bend(joint)
        case .between(let a, let b, let from, let to):
            guard let p = real[a], let q = real[b], abs(to - from) > 1e-5 else { return 1 }
            return max(0, min(1, (simd_distance(p, q) / torso - from) / (to - from)))
        }
    }
}

/// The lifter's own axes, from the pelvis, neck and hips, in world space.
struct BodyFrame {
    let forward: SIMD3<Float>
    let up: SIMD3<Float>
    let left: SIMD3<Float>
    /// Level with the floor, the way the lifter faces.
    let ahead: SIMD3<Float>
    /// Neck to pelvis, in world units — the unit fault distances are in.
    let torso: Float
    /// Straight up: the models are Y-up and only ever turned about Y.
    static let rise = SIMD3<Float>(0, 1, 0)

    init?(_ transforms: [String: simd_float4x4]) {
        func position(_ name: String) -> SIMD3<Float>? {
            transforms[name].map { SIMD3($0.columns.3.x, $0.columns.3.y, $0.columns.3.z) }
        }
        guard let pelvis = position("pelvis"), let neck = position("neck"),
              let hipL = position("thigh_L"), let hipR = position("thigh_R") else { return nil }
        let spine = neck - pelvis
        torso = simd_length(spine)
        guard torso > 1e-5 else { return nil }
        up = spine / torso
        let across = (hipL - hipR) - simd_dot(hipL - hipR, spine / torso) * (spine / torso)
        guard simd_length(across) > 1e-5 else { return nil }
        left = simd_normalize(across)
        forward = simd_cross(left, up)
        // Lying face-up the chest faces the ceiling, so fall back to the head.
        let level = forward - simd_dot(forward, Self.rise) * Self.rise
        let fallback = up - simd_dot(up, Self.rise) * Self.rise
        ahead = simd_length(level) > 0.3 ? simd_normalize(level)
            : simd_length(fallback) > 1e-5 ? simd_normalize(fallback) : forward
    }

    /// `L` or `R`, whichever foot is further ahead — the leading leg of a lift
    /// that alternates legs. Nil until the feet and body axes are tracked.
    static func leadingSide(_ transforms: [String: simd_float4x4]) -> String? {
        guard let frame = BodyFrame(transforms),
              let left = transforms["foot_L"], let right = transforms["foot_R"] else { return nil }
        return simd_dot(left.columns.3.xyz - right.columns.3.xyz, frame.ahead) >= 0 ? "L" : "R"
    }

    /// `L` or `R`, whichever knee is bent further — the working leg of a lift
    /// that shifts from side to side (lateral lunge, Cossack squat), where
    /// neither foot leads. Nil until both legs are tracked.
    static func bentSide(_ transforms: [String: simd_float4x4]) -> String? {
        func bend(_ side: String) -> Float? {
            guard let hip = transforms["thigh_\(side)"], let knee = transforms["shin_\(side)"],
                  let ankle = transforms["foot_\(side)"] else { return nil }
            let up = hip.columns.3.xyz - knee.columns.3.xyz, down = ankle.columns.3.xyz - knee.columns.3.xyz
            guard simd_length(up) > 1e-5, simd_length(down) > 1e-5 else { return nil }
            // Cosine of the knee's inner angle: larger the more it bends.
            return simd_dot(simd_normalize(up), simd_normalize(down))
        }
        guard let left = bend("L"), let right = bend("R") else { return nil }
        return left >= right ? "L" : "R"
    }

    /// The rotation axis that makes a positive turn match `FaultMove.turn`.
    func turnAxis(_ axis: BodyAxis) -> SIMD3<Float> {
        switch axis {
        case .forward: return forward   // left → head
        case .up: return -up            // left → front
        case .lateral: return -left     // front → head
        }
    }
}

private extension SIMD4 where Scalar == Float {
    var xyz: SIMD3<Float> { SIMD3(x, y, z) }
}
