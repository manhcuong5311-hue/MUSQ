//
//  XRayDemos.swift
//  GymWorkout
//
//  Bone-level demos a technique cue can open: the lifter in see-through
//  muscle with the bones the cue is about drawn inside, so "retract your
//  shoulder blades" can be watched happening rather than only read.
//
//  The first one (2026-10-17) is the bench set-up: sitting on the end of a
//  flat bench the lifter squeezes the shoulder blades back and down, lets go,
//  lies back, locks them, arches and presses three empty-handed reps, then
//  sits up. Built in Blender from the male master rig (the real Scapula /
//  Clavicle meshes of its SKELETON collection, skinned to the scapula and
//  clavicle bones the retraction switch drives); sources and notes in
//  `/Volumes/HIKSEMI/BLENDER/_co_mo_xuong_ba_vai_20261017/`.
//

import Foundation

struct XRayDemo: Identifiable, Hashable {
    /// Resource name without extension.
    let resource: String
    let title: String
    /// One line under the title.
    let summary: String
    /// Moments of the clip, in order. Each also says which view shows it
    /// best, for the Auto angle.
    let phases: [Phase]
    /// The clip's length in seconds; the clip loops.
    let duration: TimeInterval
    /// Legend: what the two colours on the model are.
    let boneLabel: String
    let muscleLabel: String
    /// The angles offered in the picker, in order.
    var angles: [XRayView] = [.auto, .back, .backThreeQuarter, .side, .top]
    /// Zoom on top of an angle's own: the back-bar set-up pulls back to keep
    /// both hands in frame, and comes in on the trunk from the side, as the
    /// lifter stands rather than lies.
    var zoomScale: [XRayView: Float] = [:]
    /// The playback speed the demo opens at.
    var speed: Float = 1
    /// Name prefix of the parts on the model's left (+X) side, outside the
    /// left hand — rack upright, J-cup, bar sleeve, plates — that hide while
    /// that side faces the camera, so the side view looks past them at the
    /// lifter.
    var sideHiddenPrefix: String? = nil

    var id: String { resource }

    struct Phase: Hashable {
        /// Chip title, e.g. `Squeeze`.
        let chip: String
        /// Caption over the model while the phase plays.
        let caption: String
        /// Seconds into the clip the phase starts.
        let start: TimeInterval
        /// Where a chip tap jumps to, a little after `start` so the motion is
        /// under way.
        let jump: TimeInterval
        /// The view the Auto angle switches to, and from which second.
        let views: [(from: TimeInterval, view: XRayView)]

        static func == (a: Phase, b: Phase) -> Bool { a.chip == b.chip && a.start == b.start }
        func hash(into hasher: inout Hasher) { hasher.combine(chip); hasher.combine(start) }
    }

    func phase(at time: TimeInterval) -> Phase? {
        phases.last { $0.start <= time } ?? phases.first
    }

    /// The Auto angle's view at `time`.
    func autoView(at time: TimeInterval) -> XRayView {
        let all = phases.flatMap(\.views).sorted { $0.from < $1.from }
        return all.last { $0.from <= time }?.view ?? .back
    }
}

/// The fixed angles a demo can be seen from. The model faces the camera at
/// yaw 0 (it is exported facing +Z); yaw turns it about the vertical, pitch
/// tips its top towards the camera, so the camera seems to rise.
enum XRayView: String, CaseIterable, Hashable {
    case auto, back, backThreeQuarter, side, top, hand

    var title: String {
        switch self {
        case .auto: return "AUTO"
        case .back: return "BACK"
        case .backThreeQuarter: return "BACK ¾"
        case .side: return "SIDE"
        case .top: return "TOP"
        case .hand: return "HAND"
        }
    }

    /// Yaw, pitch (radians) and zoom (pivot scale; 1 = metres as authored),
    /// for a phone in portrait.
    var pose: (yaw: Float, pitch: Float, zoom: Float) {
        switch self {
        case .auto, .back: return (.pi, 0.14, 1.15)
        case .backThreeQuarter: return (2.43, 0.30, 1.05)
        case .side: return (-.pi / 2, 0.13, 0.48)
        case .top: return (0, .pi / 2, 1.0)
        // The left hand on the bar, close: from outside it and a little
        // behind (62° round from the back) and 17° up, looking in along the
        // bar, so the four fingers are seen closing over it.
        case .hand: return (-1.95, 0.30, 2.4)
        }
    }

    /// What the camera keeps centred: the shoulder blades up close, the
    /// middle of the trunk for the whole-body side view, the left hand for
    /// the grip.
    var focus: XRayFocus {
        switch self {
        case .side: return .body
        case .hand: return .hand
        default: return .shoulders
        }
    }
}

enum XRayFocus { case shoulders, body, hand }

enum XRayDemos {
    static let benchScapula = XRayDemo(
        resource: "XRayScapulaBenchSetup",
        title: "Shoulder Blades in X-Ray",
        summary: "Squeeze them back and down, lie back, lock them, then press without letting them slip.",
        phases: [
            .init(chip: "Squeeze", caption: "Seated: pull the shoulder blades together, then down",
                  start: 0, jump: 0.4,
                  views: [(0, .back), (56.0 / 24, .backThreeQuarter)]),
            .init(chip: "Lie back", caption: "Lie back onto the bench",
                  start: 102.0 / 24, jump: 106.0 / 24,
                  views: [(106.0 / 24, .side)]),
            .init(chip: "Lock", caption: "Lock them back and down, then arch",
                  start: 176.0 / 24, jump: 176.0 / 24,
                  views: [(176.0 / 24, .top)]),
            .init(chip: "Press", caption: "Press: the blades stay locked on the bench",
                  start: 216.0 / 24, jump: 216.0 / 24, views: []),
            .init(chip: "Sit up", caption: "Release and sit up",
                  start: 322.0 / 24, jump: 322.0 / 24,
                  views: [(338.0 / 24, .side)]),
        ],
        duration: 384.0 / 24,
        boneLabel: "Shoulder blades & collarbones",
        muscleLabel: "Mid & lower traps, rhomboids"
    )

    /// The back-bar set-up (2026-10-19): a beginner under a racked bar —
    /// back rounded, hands wide and loose, wrists bent back, elbows forward —
    /// takes the hands off, sets them just outside the shoulders, wraps all
    /// five fingers, squeezes the shoulder blades back and down, braces until
    /// the spine stacks straight, and pulls the elbows down and back. Built in
    /// Blender from the barbell split squat's corrected grip (840 mm, all five
    /// fingers) on the male master rig, standing in a power rack whose J-cups
    /// hold the bar; the vertebrae straighten on bones of their own. Sources
    /// and notes in `/Volumes/HIKSEMI/BLENDER/300-400 🔴/quads_series🟢/
    /// 316B_sua_cach_cam_ganh_thanh/`.
    static let backBarSetup = XRayDemo(
        resource: "XRayBackBarSetup",
        title: "Back-Bar Set-Up in X-Ray",
        summary: "Grip the bar tight, lock the shoulder blades, brace, then pull the elbows down and back.",
        phases: [
            .init(chip: "Not set", caption: "Not set: back rounded, grip wide and loose, wrists bent back, elbows forward",
                  start: 0, jump: 0.3,
                  views: [(0, .backThreeQuarter)]),
            .init(chip: "Re-grip", caption: "Hands off the bar, then set them just outside the shoulders",
                  start: 24.0 / 24, jump: 26.0 / 24, views: []),
            // The close-up starts as the hand comes down, so the camera has
            // settled before the fingers close (frames 58–68) and the thumb
            // wraps (60–74).
            .init(chip: "Grip", caption: "Open a C, set the bar in the base of the fingers, close all five",
                  start: 46.0 / 24, jump: 46.0 / 24,
                  views: [(40.0 / 24, .hand)]),
            .init(chip: "Lock", caption: "Squeeze the shoulder blades together, then down",
                  start: 74.0 / 24, jump: 76.0 / 24,
                  views: [(74.0 / 24, .back)]),
            .init(chip: "Brace", caption: "Brace the core: the spine stacks straight",
                  start: 104.0 / 24, jump: 104.0 / 24,
                  views: [(104.0 / 24, .side)]),
            .init(chip: "Elbows", caption: "Pull the elbows down and back",
                  start: 134.0 / 24, jump: 134.0 / 24, views: []),
            .init(chip: "Ready", caption: "Ready: grip tight, shoulder blades locked, core braced",
                  start: 158.0 / 24, jump: 158.0 / 24,
                  views: [(158.0 / 24, .backThreeQuarter)]),
        ],
        duration: 200.0 / 24,
        boneLabel: "Spine, shoulder blades & hands",
        muscleLabel: "Upper back, forearms & core",
        angles: [.auto, .back, .backThreeQuarter, .side, .hand],
        zoomScale: [.back: 0.7, .backThreeQuarter: 0.8, .side: 1.4],
        // About a second a moment at full speed: too quick to read along.
        speed: 0.5,
        sideHiddenPrefix: "XRSIDE_"
    )

    /// Callouts on the back-loaded barbell lifts that say where the bar sits.
    private static let backBarLabels: Set<String> = [
        "Bar high on the traps", "Bar high on traps", "Bar on the traps", "High bar", "Bar on upper back",
    ]

    /// The demo a cue opens, if any: the bench set-up for every press whose
    /// scapula callout reads "Retract scapula" (the flat, incline and decline
    /// barbell, dumbbell, Smith and cable presses); the back-bar set-up for
    /// the grip and shoulder-blade cue (`shelf`) and for every lift whose bar
    /// callout puts the bar on the upper back (the back, box, pause, sumo and
    /// heel-elevated squats, the barbell and Smith split and Bulgarian split
    /// squats, the good mornings and the barbell step-up).
    static func demo(for exercise: Exercise, cue: String) -> XRayDemo? {
        guard let content = SampleData.content(for: exercise) else { return nil }
        switch cue {
        case "scapula":
            let retracts = content.annotations.contains { $0.cueID == cue && $0.label == "Retract scapula" }
            return retracts ? benchScapula : nil
        case "shelf":
            return backBarSetup
        case "bar":
            let onBack = content.annotations.contains { $0.cueID == cue && backBarLabels.contains($0.label) }
            return onBack ? backBarSetup : nil
        default:
            return nil
        }
    }
}
