//
//  AnatomyModels.swift
//  GymWorkout
//
//  Domain types behind the Anatomy Trainer screens.
//

import SwiftUI

// MARK: - Exercise

enum Difficulty: String, CaseIterable {
    case beginner = "BEGINNER"
    case intermediate = "INTERMEDIATE"
    case advanced = "ADVANCED"

    /// Difficulty is a *metric*, not an interactive element, so it is allowed
    /// to borrow the warm ramp. Beginner stays neutral.
    var dotColor: Color {
        switch self {
        case .beginner: return DS.silver.opacity(0.45)
        case .intermediate: return DS.difficultyMid
        case .advanced: return DS.activation
        }
    }
}

enum MuscleGroupName: String, CaseIterable, Identifiable {
    case all = "All"
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case legs = "Legs"
    case core = "Core"

    var id: String { rawValue }
}

struct Exercise: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: MuscleGroupName
    /// e.g. `PECTORALIS MAJOR` — already upper-cased for the mono meta line.
    let primaryMuscle: String
    /// e.g. `BARBELL`.
    let equipment: String
    let difficulty: Difficulty

    /// Monospaced meta line under a library row: `PECTORALIS MAJOR · BARBELL`.
    var meta: String { "\(primaryMuscle) · \(equipment)" }

    /// Monospaced meta line under the trainer's title.
    var trainerMeta: String {
        "\(category.rawValue.uppercased()) · \(equipment) · \(difficulty.rawValue)"
    }

    /// Stable key for the replaceable render slot backing this row.
    var slotID: String {
        "lib-" + name.lowercased()
            .replacingOccurrences(of: "[^a-z]+", with: "-", options: .regularExpression)
    }
}

// MARK: - Technique cues

struct TechniqueCue: Identifiable, Hashable {
    let id: String
    let title: String
    let intro: String
    let why: String
    let mistake: String
    let correct: String
}

// MARK: - Muscle activation

enum ActivationRank: String {
    case primary = "PRIMARY"
    case secondary = "SECONDARY"

    var tagBackground: Color {
        switch self {
        case .primary: return DS.activation.opacity(0.16)
        case .secondary: return DS.silver.opacity(0.08)
        }
    }

    var tagForeground: Color {
        switch self {
        case .primary: return DS.activationTint
        case .secondary: return DS.silver.opacity(0.6)
        }
    }

    var barColor: Color {
        switch self {
        case .primary: return DS.activation
        case .secondary: return DS.activationSoft.opacity(0.6)
        }
    }
}

struct MuscleActivation: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let rank: ActivationRank
    /// e.g. `HIGH ACTIVATION`.
    let activation: String
    /// 0…1 — EMG-relative contribution across the full range of motion.
    let fraction: Double

    var percentLabel: String { "\(Int((fraction * 100).rounded()))%" }
}

// MARK: - Trainer content

/// A cue pinned to a point on the model.
///
/// The label stays put; the leader runs from it to a dot on `joint`, which
/// follows the live model through the rep and when the viewer turns it.
/// Without a live model (or a joint) the dot sits `leaderLength` away from the
/// label, level with it.
struct CueAnnotation: Identifiable, Hashable {
    let id = UUID()
    let cueID: String
    let label: String
    /// Where the leader leaves the label — the middle of the label's edge
    /// nearest the dot — in unit fractions of the viewport, so it survives any
    /// device size.
    let labelPoint: CGPoint
    /// Which side of `labelPoint` the label sits on.
    var labelSide: HorizontalEdge = .leading
    let leaderLength: CGFloat
    /// Skeleton joint the dot follows, matched on the last component of the
    /// rig's joint path, e.g. `hand_L`.
    var joint: String? = nil
}

/// Copy for the correct-vs-mistake comparison screen.
struct FormComparisonCopy: Hashable {
    let correctBadge: String
    let mistakeBadge: String
    let correctCue: String
    let mistakeCue: String
    let correctNote: String
    let mistakeNote: String
}

/// Everything the 3D trainer needs for one exercise.
///
/// This is the gate: an exercise without an `ExerciseContent` cannot open the
/// trainer, because showing another lift's cues and muscle activation would be
/// actively misleading. Author one of these per exercise to unlock it.
struct ExerciseContent {
    let annotations: [CueAnnotation]
    let cues: [TechniqueCue]
    let activation: [MuscleActivation]
    /// Muscles that steady this lift but fall under the 20% cut for
    /// `activation`, named in the note under the muscle list. Lower case,
    /// e.g. `rotator cuff`. Empty hides the note.
    let stabilisers: [String]
    /// How to get into position, as short imperative steps written for this
    /// exercise's own model (bench angle, stance, grip, attachment). Shown in
    /// the trainer's swipe-up setup drawer.
    let setup: [String]
    let comparison: FormComparisonCopy
    /// Activation signature painted over the render.
    let glows: [ActivationGlowLayer.Glow]

    func cue(_ id: String) -> TechniqueCue {
        cues.first { $0.id == id } ?? cues[0]
    }

    /// 1-based index for the `TECHNIQUE CUE 02` eyebrow.
    func cueNumber(_ id: String) -> Int {
        (cues.firstIndex { $0.id == id } ?? 0) + 1
    }

    var primaryMuscles: [MuscleActivation] { activation.filter { $0.rank == .primary } }
    var secondaryMuscles: [MuscleActivation] { activation.filter { $0.rank == .secondary } }
}

// MARK: - Playback

enum FormMode {
    case correct
    case mistake
}

// MARK: - Home

struct MuscleGroupTileModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let count: String
}

struct RecentExercise: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let meta: String
}

// MARK: - Model framing

/// How an exercise's model is presented in the viewport.
///
/// These are authored per exercise rather than derived, because the models
/// cannot be measured: RealityKit's `visualBounds` reports a skinned mesh's
/// bind pose and never updates as the clip plays, and every exercise here is
/// driven by the same rig — so a push-up and a squat measure identically as a
/// standing figure. Sampling across playback returns the same box too. The
/// pose only exists on screen, so the framing is set by eye.
struct ModelFraming {
    /// Resting rotation about the vertical axis, in radians. The viewer's drag
    /// is applied on top of this.
    var yaw: Float = 0
    /// Scale multiplier against the rig's standing height.
    var zoom: Float = 1
    /// Translation after scaling, in normalised units.
    var offset: SIMD3<Float> = .zero

    /// Upright lifts — squat, lunge. Seen from the front.
    static let standing = ModelFraming(
        yaw: 0, zoom: 1.0, offset: [0, 0.10, 0]
    )

    /// Prone lifts — push-up, plank. Seen from the side, because head-on the
    /// body recedes straight away from the camera, and lifted back into frame
    /// because the rig's bind-pose centre sits at standing hip height while
    /// the body is actually near the floor.
    /// The zoom looks small next to `standing`, and has to be: a 1.8m body
    /// laid flat has to fit the *width* of a portrait viewport, which is only
    /// about a third of its height. The lift raises the body off the floor,
    /// where it sits well below the rig's standing bind-pose centre.
    static let prone = ModelFraming(
        yaw: .pi / 2, zoom: 0.62, offset: [0, 0.52, 0]
    )

    /// Push-up: side view like `prone`, but its clip holds the body higher off
    /// the floor at the top of each rep, so it needs less lift to sit centred.
    static let pushUp = ModelFraming(
        yaw: .pi / 2, zoom: 0.62, offset: [0, 0.30, 0]
    )

    /// Bench lifts — flat, incline, decline, barbell or dumbbell. The lifter
    /// lies head-away from the camera. Square side-on, the near barbell plate
    /// sits right over the chest, so these are seen three-quarter from the
    /// feet end instead, which keeps the worked pecs in view. Turned so the
    /// head and chest land on the right: the trainer's cue callouts sit on
    /// the left and point right, into the body. The offset pulls the rack
    /// back into frame on the right.
    static let bench = ModelFraming(
        yaw: -1.0, zoom: 0.66, offset: [-0.05, 0.04, 0.08]
    )

    /// Chest press machine: the handles travel straight at a head-on camera,
    /// which reads as no motion at all, so it is turned three-quarter.
    static let chestPress = ModelFraming(
        yaw: -0.7, zoom: 0.62, offset: [-0.023, 0.03, 0.019]
    )

    /// Pec deck: the arms sweep across the frame, which reads best head-on.
    /// The machine stands taller than the lifter, hence the small zoom.
    static let pecDeck = ModelFraming(
        yaw: 0, zoom: 0.68, offset: [0, 0.03, 0]
    )

    /// Cable fly, head-on between the two stacks. The station is far wider
    /// than a portrait viewport; the zoom favours the lifter and lets the
    /// stacks crop at the sides.
    static let cableStation = ModelFraming(
        yaw: 0, zoom: 0.85, offset: [0, 0.03, 0]
    )
}
