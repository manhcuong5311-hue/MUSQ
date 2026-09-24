//
//  SampleData.swift
//  GymWorkout
//
//  Content transcribed verbatim from the design's data script. Swap this for a
//  real store; every screen reads through these types, not through literals.
//

import SwiftUI

enum SampleData {

    // MARK: - Library

    static let exercises: [Exercise] = [
        Exercise(name: "Barbell Bench Press", category: .chest,
                 primaryMuscle: "PECTORALIS MAJOR", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Incline Barbell Bench Press", category: .chest,
                 primaryMuscle: "UPPER PECTORALIS", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Decline Barbell Bench Press", category: .chest,
                 primaryMuscle: "LOWER PECTORALIS", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Dumbbell Bench Press", category: .chest,
                 primaryMuscle: "PECTORALIS MAJOR", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Incline Dumbbell Press", category: .chest,
                 primaryMuscle: "UPPER PECTORALIS", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Dumbbell Fly", category: .chest,
                 primaryMuscle: "PECTORALIS MAJOR", equipment: "DUMBBELL",
                 difficulty: .intermediate),
        Exercise(name: "Incline Dumbbell Fly", category: .chest,
                 primaryMuscle: "UPPER PECTORALIS", equipment: "DUMBBELL",
                 difficulty: .intermediate),
        Exercise(name: "Chest Press Machine", category: .chest,
                 primaryMuscle: "PECTORALIS MAJOR", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Pec Deck Fly", category: .chest,
                 primaryMuscle: "PECTORALIS MAJOR", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Cable Fly", category: .chest,
                 primaryMuscle: "PECTORALIS MAJOR", equipment: "CABLE",
                 difficulty: .intermediate),
        Exercise(name: "Low-to-High Cable Fly", category: .chest,
                 primaryMuscle: "UPPER PECTORALIS", equipment: "CABLE",
                 difficulty: .intermediate),
        Exercise(name: "Squat", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Lunge", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Bulgarian Split Squat", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "BENCH",
                 difficulty: .intermediate),
        Exercise(name: "Bulgarian Split Squat (Lean)", category: .legs,
                 primaryMuscle: "GLUTEUS MAXIMUS", equipment: "BENCH",
                 difficulty: .intermediate),
        Exercise(name: "Back Squat", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Front Squat", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "BARBELL",
                 difficulty: .advanced),
        Exercise(name: "Goblet Squat", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Walking Lunge", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Reverse Lunge", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Hack Squat", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "MACHINE",
                 difficulty: .intermediate),
        Exercise(name: "Leg Extension", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Smith Machine Squat", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Sissy Squat", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "BODYWEIGHT",
                 difficulty: .advanced),
        Exercise(name: "Romanian Deadlift", category: .legs,
                 primaryMuscle: "HAMSTRINGS", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Deadlift", category: .back,
                 primaryMuscle: "POSTERIOR CHAIN", equipment: "BARBELL",
                 difficulty: .advanced),
        Exercise(name: "Barbell Bent-Over Row", category: .back,
                 primaryMuscle: "MID-BACK", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Dumbbell Row", category: .back,
                 primaryMuscle: "MID-BACK", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "One-Arm Dumbbell Row", category: .back,
                 primaryMuscle: "LATISSIMUS DORSI", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Chest-Supported Dumbbell Row", category: .back,
                 primaryMuscle: "MID-BACK", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Pull-Up", category: .back,
                 primaryMuscle: "LATISSIMUS DORSI", equipment: "BODYWEIGHT",
                 difficulty: .intermediate),
        Exercise(name: "Chin-Up", category: .back,
                 primaryMuscle: "LATISSIMUS DORSI", equipment: "BODYWEIGHT",
                 difficulty: .intermediate),
        Exercise(name: "Lat Pulldown", category: .back,
                 primaryMuscle: "LATISSIMUS DORSI", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Close-Grip Lat Pulldown", category: .back,
                 primaryMuscle: "LATISSIMUS DORSI", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Seated Cable Row", category: .back,
                 primaryMuscle: "MID-BACK", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Straight-Arm Pulldown", category: .back,
                 primaryMuscle: "LATISSIMUS DORSI", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "T-Bar Row", category: .back,
                 primaryMuscle: "MID-BACK", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Chest-Supported Row Machine", category: .back,
                 primaryMuscle: "MID-BACK", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "High Row Machine", category: .back,
                 primaryMuscle: "LATISSIMUS DORSI", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Back Extension", category: .back,
                 primaryMuscle: "ERECTOR SPINAE", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Barbell Overhead Press", category: .shoulders,
                 primaryMuscle: "ANT. + LAT. DELTOID", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Dumbbell Shoulder Press", category: .shoulders,
                 primaryMuscle: "ANT. + LAT. DELTOID", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Arnold Press", category: .shoulders,
                 primaryMuscle: "ANTERIOR DELTOID", equipment: "DUMBBELL",
                 difficulty: .intermediate),
        Exercise(name: "Machine Shoulder Press", category: .shoulders,
                 primaryMuscle: "ANT. + LAT. DELTOID", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Dumbbell Lateral Raise", category: .shoulders,
                 primaryMuscle: "LATERAL DELTOID", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Cable Lateral Raise", category: .shoulders,
                 primaryMuscle: "LATERAL DELTOID", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Machine Lateral Raise", category: .shoulders,
                 primaryMuscle: "LATERAL DELTOID", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Dumbbell Front Raise", category: .shoulders,
                 primaryMuscle: "ANTERIOR DELTOID", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Reverse Dumbbell Fly", category: .shoulders,
                 primaryMuscle: "POSTERIOR DELTOID", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Reverse Pec Deck", category: .shoulders,
                 primaryMuscle: "POSTERIOR DELTOID", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Face Pull", category: .shoulders,
                 primaryMuscle: "POSTERIOR DELTOID", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Cable Rear Delt Fly", category: .shoulders,
                 primaryMuscle: "POSTERIOR DELTOID", equipment: "CABLE",
                 difficulty: .intermediate),
        Exercise(name: "Biceps Curl", category: .arms,
                 primaryMuscle: "BICEPS BRACHII", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Barbell Curl", category: .arms,
                 primaryMuscle: "BICEPS BRACHII", equipment: "BARBELL",
                 difficulty: .beginner),
        Exercise(name: "Triceps Pushdown", category: .arms,
                 primaryMuscle: "TRICEPS BRACHII", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Rope Pushdown", category: .arms,
                 primaryMuscle: "TRICEPS BRACHII", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Single-Arm Cable Pushdown", category: .arms,
                 primaryMuscle: "TRICEPS BRACHII", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Overhead Cable Triceps Extension", category: .arms,
                 primaryMuscle: "TRICEPS BRACHII", equipment: "CABLE",
                 difficulty: .intermediate),
        Exercise(name: "Dumbbell Overhead Triceps Extension", category: .arms,
                 primaryMuscle: "TRICEPS BRACHII", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Skull Crusher", category: .arms,
                 primaryMuscle: "TRICEPS BRACHII", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Bench Dip", category: .arms,
                 primaryMuscle: "TRICEPS BRACHII", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Assisted Dip", category: .arms,
                 primaryMuscle: "TRICEPS BRACHII", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Leg Press", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Step-Up", category: .legs,
                 primaryMuscle: "QUADRICEPS", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Dumbbell Romanian Deadlift", category: .legs,
                 primaryMuscle: "HAMSTRINGS", equipment: "DUMBBELL",
                 difficulty: .beginner),
        Exercise(name: "Stiff-Leg Deadlift", category: .legs,
                 primaryMuscle: "HAMSTRINGS", equipment: "BARBELL",
                 difficulty: .intermediate),
        Exercise(name: "Lying Leg Curl", category: .legs,
                 primaryMuscle: "HAMSTRINGS", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Seated Leg Curl", category: .legs,
                 primaryMuscle: "HAMSTRINGS", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Single-Leg Curl", category: .legs,
                 primaryMuscle: "HAMSTRINGS", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Glute Bridge", category: .legs,
                 primaryMuscle: "GLUTEUS MAXIMUS", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Single-Leg Glute Bridge", category: .legs,
                 primaryMuscle: "GLUTEUS MAXIMUS", equipment: "BODYWEIGHT",
                 difficulty: .intermediate),
        Exercise(name: "Cable Glute Kickback", category: .legs,
                 primaryMuscle: "GLUTEUS MAXIMUS", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Cable Side Kick", category: .legs,
                 primaryMuscle: "GLUTEUS MEDIUS", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Cable Hip Abduction", category: .legs,
                 primaryMuscle: "GLUTEUS MEDIUS", equipment: "CABLE",
                 difficulty: .beginner),
        Exercise(name: "Hip Abduction Machine", category: .legs,
                 primaryMuscle: "GLUTEUS MEDIUS", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Hip Abduction Machine (Lean)", category: .legs,
                 primaryMuscle: "GLUTEUS MEDIUS", equipment: "MACHINE",
                 difficulty: .beginner),
        Exercise(name: "Push-Up", category: .chest,
                 primaryMuscle: "PECTORALIS MAJOR", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Plank", category: .core,
                 primaryMuscle: "RECTUS ABDOMINIS", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Crunch", category: .core,
                 primaryMuscle: "RECTUS ABDOMINIS", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Reverse Crunch", category: .core,
                 primaryMuscle: "RECTUS ABDOMINIS", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Decline Crunch", category: .core,
                 primaryMuscle: "RECTUS ABDOMINIS", equipment: "BENCH",
                 difficulty: .intermediate),
        Exercise(name: "Cable Crunch", category: .core,
                 primaryMuscle: "RECTUS ABDOMINIS", equipment: "CABLE",
                 difficulty: .intermediate),
        Exercise(name: "Hanging Knee Raise", category: .core,
                 primaryMuscle: "RECTUS ABDOMINIS", equipment: "BODYWEIGHT",
                 difficulty: .intermediate),
        Exercise(name: "Hanging Leg Raise", category: .core,
                 primaryMuscle: "RECTUS ABDOMINIS", equipment: "BODYWEIGHT",
                 difficulty: .advanced),
        Exercise(name: "Captain's Chair Leg Raise", category: .core,
                 primaryMuscle: "RECTUS ABDOMINIS", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Ab Wheel Rollout", category: .core,
                 primaryMuscle: "RECTUS ABDOMINIS", equipment: "AB WHEEL",
                 difficulty: .advanced),
        Exercise(name: "Side Plank", category: .core,
                 primaryMuscle: "OBLIQUES", equipment: "BODYWEIGHT",
                 difficulty: .beginner),
        Exercise(name: "Russian Twist", category: .core,
                 primaryMuscle: "OBLIQUES", equipment: "MEDICINE BALL",
                 difficulty: .beginner),
        Exercise(name: "Cable Wood Chop", category: .core,
                 primaryMuscle: "OBLIQUES", equipment: "CABLE",
                 difficulty: .intermediate)
    ]

    static var benchPress: Exercise {
        exercises.first { $0.name == "Barbell Bench Press" } ?? exercises[0]
    }

    // MARK: - Trainer content (the gate)

    /// Trainer content keyed by exercise name.
    ///
    /// Chest, Back, Legs, Shoulders and Arms are authored (2026-09-24). Still
    /// gated, rather than shown another lift's cues and activation under
    /// their own name: `Squat` (its model is a cross-arm bodyweight squat,
    /// not the barbell lift the library lists), `Lunge` (its legacy model is
    /// turned away from its own skeleton, so tracked cue dots float off the
    /// body) and `Biceps Curl` (no model).
    /// Add an entry here to unlock an exercise; nothing else needs to change.
    private static let contentByExercise: [String: ExerciseContent] = [
        "Barbell Bench Press": benchPressContent,
        "Incline Barbell Bench Press": inclineBarbellBenchPressContent,
        "Decline Barbell Bench Press": declineBarbellBenchPressContent,
        "Dumbbell Bench Press": dumbbellBenchPressContent,
        "Incline Dumbbell Press": inclineDumbbellPressContent,
        "Dumbbell Fly": dumbbellFlyContent,
        "Incline Dumbbell Fly": inclineDumbbellFlyContent,
        "Chest Press Machine": chestPressMachineContent,
        "Pec Deck Fly": pecDeckFlyContent,
        "Cable Fly": cableFlyContent,
        "Low-to-High Cable Fly": lowToHighCableFlyContent,
        "Deadlift": deadliftContent,
        "Barbell Bent-Over Row": barbellBentOverRowContent,
        "Dumbbell Row": dumbbellRowContent,
        "One-Arm Dumbbell Row": oneArmDumbbellRowContent,
        "Chest-Supported Dumbbell Row": chestSupportedDumbbellRowContent,
        "Pull-Up": pullUpContent,
        "Chin-Up": chinUpContent,
        "Lat Pulldown": latPulldownContent,
        "Close-Grip Lat Pulldown": closeGripLatPulldownContent,
        "Seated Cable Row": seatedCableRowContent,
        "Straight-Arm Pulldown": straightArmPulldownContent,
        "T-Bar Row": tBarRowContent,
        "Chest-Supported Row Machine": chestSupportedRowMachineContent,
        "High Row Machine": highRowMachineContent,
        "Back Extension": backExtensionContent,
        "Back Squat": backSquatContent,
        "Front Squat": frontSquatContent,
        "Goblet Squat": gobletSquatContent,
        "Walking Lunge": walkingLungeContent,
        "Reverse Lunge": reverseLungeContent,
        "Leg Press": legPressContent,
        "Hack Squat": hackSquatContent,
        "Leg Extension": legExtensionContent,
        "Smith Machine Squat": smithMachineSquatContent,
        "Sissy Squat": sissySquatContent,
        "Romanian Deadlift": romanianDeadliftContent,
        "Barbell Overhead Press": barbellOverheadPressContent,
        "Dumbbell Shoulder Press": dumbbellShoulderPressContent,
        "Arnold Press": arnoldPressContent,
        "Machine Shoulder Press": machineShoulderPressContent,
        "Dumbbell Lateral Raise": dumbbellLateralRaiseContent,
        "Cable Lateral Raise": cableLateralRaiseContent,
        "Machine Lateral Raise": machineLateralRaiseContent,
        "Dumbbell Front Raise": dumbbellFrontRaiseContent,
        "Reverse Dumbbell Fly": reverseDumbbellFlyContent,
        "Reverse Pec Deck": reversePecDeckContent,
        "Face Pull": facePullContent,
        "Cable Rear Delt Fly": cableRearDeltFlyContent,
        "Barbell Curl": barbellCurlContent,
        "Triceps Pushdown": tricepsPushdownContent,
        "Rope Pushdown": ropePushdownContent,
        "Single-Arm Cable Pushdown": singleArmCablePushdownContent,
        "Overhead Cable Triceps Extension": overheadCableTricepsExtensionContent,
        "Dumbbell Overhead Triceps Extension": dumbbellOverheadTricepsExtensionContent,
        "Skull Crusher": skullCrusherContent,
        "Bench Dip": benchDipContent,
        "Assisted Dip": assistedDipContent,
        "Bulgarian Split Squat": bulgarianSplitSquatContent,
        "Bulgarian Split Squat (Lean)": bulgarianSplitSquatLeanContent,
        "Dumbbell Romanian Deadlift": dumbbellRomanianDeadliftContent,
        "Stiff-Leg Deadlift": stiffLegDeadliftContent,
        "Lying Leg Curl": lyingLegCurlContent,
        "Seated Leg Curl": seatedLegCurlContent,
        "Single-Leg Curl": singleLegCurlContent,
        "Glute Bridge": gluteBridgeContent,
        "Single-Leg Glute Bridge": singleLegGluteBridgeContent,
        "Cable Glute Kickback": cableGluteKickbackContent,
        "Cable Side Kick": cableSideKickContent,
        "Cable Hip Abduction": cableHipAbductionContent,
        "Hip Abduction Machine": hipAbductionMachineContent,
        "Hip Abduction Machine (Lean)": hipAbductionMachineLeanContent,
        "Step-Up": stepUpContent,
        "Push-Up": pushUpContent,
        "Plank": plankContent,
        "Crunch": crunchContent,
        "Reverse Crunch": reverseCrunchContent,
        "Decline Crunch": declineCrunchContent,
        "Cable Crunch": cableCrunchContent,
        "Hanging Knee Raise": hangingKneeRaiseContent,
        "Hanging Leg Raise": hangingLegRaiseContent,
        "Captain's Chair Leg Raise": captainsChairLegRaiseContent,
        "Ab Wheel Rollout": abWheelRolloutContent,
        "Side Plank": sidePlankContent,
        "Russian Twist": russianTwistContent,
        "Cable Wood Chop": cableWoodChopContent
    ]

    static func content(for exercise: Exercise) -> ExerciseContent? {
        contentByExercise[exercise.name]
    }

    /// usdz resource shipped for an exercise, if any.
    ///
    /// Independent of `contentByExercise`: a model can exist before the
    /// coaching content is authored, and the gate withholds the coaching, not
    /// the anatomy.
    /// Resource name plus how that model wants to be framed and played.
    struct ExerciseModel {
        let resource: String
        let framing: ModelFraming
        /// Playback rate. The clips are authored at real tempo, which is too
        /// quick to read form from on a phone for some lifts.
        var speed: Float = 1
    }

    private static let modelByExercise: [String: ExerciseModel] = [
        "Squat":   ExerciseModel(resource: "Squat",  framing: .standing),
        "Lunge":   ExerciseModel(resource: "Lunge",  framing: .standing),
        "Bulgarian Split Squat":        ExerciseModel(resource: "BulgarianSplitSquatUpright", framing: .standing),
        "Bulgarian Split Squat (Lean)": ExerciseModel(resource: "BulgarianSplitSquatLean",    framing: .standing),
        // Framing below was fitted offline the same way as the back lifts:
        // joints plus held equipment projected through the viewport camera,
        // solved for the largest zoom that keeps everything in the margins
        // (`Tools/model-pipeline/solve_all.py`). Free-weight squats, lunges
        // and the smith machine/sissy squat are seen straight-on, matching
        // `Squat`/`Lunge`; the leg press, hack squat and leg extension are
        // turned three-quarter so the pressing motion actually reads, and
        // their machines are allowed to crop rather than shrinking the
        // lifter to fit the whole rig in frame.
        "Back Squat":            ExerciseModel(resource: "BackSquat",
                                        framing: ModelFraming(yaw: 0, zoom: 0.890, offset: [0, 0.025, 0])),
        "Front Squat":           ExerciseModel(resource: "FrontSquat",
                                        framing: ModelFraming(yaw: 0, zoom: 0.603, offset: [0, 0.021, 0])),
        "Goblet Squat":          ExerciseModel(resource: "GobletSquat",
                                        framing: ModelFraming(yaw: 0, zoom: 0.899, offset: [0, 0.030, 0])),
        "Walking Lunge":         ExerciseModel(resource: "WalkingLunge",
                                        framing: ModelFraming(yaw: 0, zoom: 0.649, offset: [0, 0.010, 0])),
        "Reverse Lunge":         ExerciseModel(resource: "ReverseLunge",
                                        framing: ModelFraming(yaw: 0, zoom: 0.897, offset: [0, 0.028, 0])),
        "Leg Press":             ExerciseModel(resource: "LegPress",
                                        framing: ModelFraming(yaw: -0.6, zoom: 1.173, offset: [-0.021, 0.222, 0.015])),
        "Hack Squat":            ExerciseModel(resource: "HackSquat",
                                        framing: ModelFraming(yaw: -0.6, zoom: 1.013, offset: [0.015, 0.112, -0.010])),
        "Leg Extension":         ExerciseModel(resource: "LegExtension",
                                        framing: ModelFraming(yaw: -0.5, zoom: 0.972, offset: [0.043, 0.076, -0.023])),
        "Smith Machine Squat":   ExerciseModel(resource: "SmithMachineSquat",
                                        framing: ModelFraming(yaw: 0, zoom: 0.619, offset: [0, 0.023, 0])),
        "Sissy Squat":           ExerciseModel(resource: "SissySquat",
                                        framing: ModelFraming(yaw: 0, zoom: 0.867, offset: [0, 0.012, 0])),
        "Romanian Deadlift":     ExerciseModel(resource: "RomanianDeadlift",
                                        framing: ModelFraming(yaw: 0, zoom: 0.597, offset: [0, 0.019, 0])),
        "Barbell Bench Press":          ExerciseModel(resource: "BarbellBenchPress",          framing: .bench),
        "Incline Barbell Bench Press":  ExerciseModel(resource: "InclineBarbellBenchPress",   framing: .bench),
        "Decline Barbell Bench Press":  ExerciseModel(resource: "DeclineBarbellBenchPress",   framing: .bench),
        "Dumbbell Bench Press":         ExerciseModel(resource: "DumbbellBenchPress",         framing: .bench),
        "Incline Dumbbell Press":       ExerciseModel(resource: "InclineDumbbellPress",       framing: .bench),
        "Dumbbell Fly":                 ExerciseModel(resource: "DumbbellFly",                framing: .bench),
        "Incline Dumbbell Fly":         ExerciseModel(resource: "InclineDumbbellFly",         framing: .bench),
        "Chest Press Machine":          ExerciseModel(resource: "ChestPressMachine",          framing: .chestPress),
        "Pec Deck Fly":                 ExerciseModel(resource: "PecDeckFly",                 framing: .pecDeck),
        "Cable Fly":                    ExerciseModel(resource: "CableFly",                   framing: .cableStation),
        // Framing below was fitted offline — joints across the whole clip plus
        // the equipment, projected through this viewport's camera — then
        // checked on screen. Back lifts are seen from behind or three-quarter
        // behind so the worked lats and traps face the camera; hinges sit
        // closer to side-on, or the glutes fill the frame. Where a machine is
        // much bigger than the lifter it is allowed to crop.
        "Low-to-High Cable Fly":        ExerciseModel(resource: "LowToHighCableFly",
                                        framing: ModelFraming(yaw: 0, zoom: 0.913, offset: [0, 0.037, 0])),
        "Deadlift":                     ExerciseModel(resource: "ConventionalDeadlift",
                                        framing: ModelFraming(yaw: -2, zoom: 0.866, offset: [-0.048, 0.031, -0.104])),
        "Barbell Bent-Over Row":        ExerciseModel(resource: "BarbellBentOverRow",
                                        framing: ModelFraming(yaw: -2, zoom: 0.965, offset: [-0.078, 0.182, -0.17])),
        "Dumbbell Row":                 ExerciseModel(resource: "DumbbellRow",
                                        framing: ModelFraming(yaw: -2, zoom: 1.215, offset: [-0.027, 0.233, -0.06])),
        "One-Arm Dumbbell Row":         ExerciseModel(resource: "OneArmDumbbellRow",
                                        framing: ModelFraming(yaw: -2, zoom: 1.076, offset: [0.002, 0.181, 0.004])),
        "Chest-Supported Dumbbell Row": ExerciseModel(resource: "ChestSupportedDumbbellRow",
                                        framing: ModelFraming(yaw: -2, zoom: 1.215, offset: [-0.027, 0.233, -0.06])),
        "Pull-Up":                      ExerciseModel(resource: "PullUp",
                                        framing: ModelFraming(yaw: -2.6, zoom: 0.724, offset: [-0.082, -0.046, -0.049])),
        "Chin-Up":                      ExerciseModel(resource: "ChinUp",
                                        framing: ModelFraming(yaw: -2.6, zoom: 0.724, offset: [-0.071, -0.046, -0.043])),
        "Lat Pulldown":                 ExerciseModel(resource: "LatPulldown",
                                        framing: ModelFraming(yaw: 0.5, zoom: 0.866, offset: [-0.087, 0.017, -0.048])),
        "Close-Grip Lat Pulldown":      ExerciseModel(resource: "CloseGripLatPulldown",
                                        framing: ModelFraming(yaw: 0.5, zoom: 0.857, offset: [-0.085, 0.011, -0.047])),
        "Seated Cable Row":             ExerciseModel(resource: "SeatedCableRow",
                                        framing: ModelFraming(yaw: -2.2, zoom: 0.971, offset: [0.017, 0.113, 0.023])),
        "Straight-Arm Pulldown":        ExerciseModel(resource: "StraightArmPulldown",
                                        framing: ModelFraming(yaw: -2.5, zoom: 0.824, offset: [-0.198, -0.011, -0.148])),
        "T-Bar Row":                    ExerciseModel(resource: "TBarRow",
                                        framing: ModelFraming(yaw: -2.7, zoom: 0.984, offset: [0.174, 0.235, 0.082])),
        "Chest-Supported Row Machine":  ExerciseModel(resource: "ChestSupportedRowMachine",
                                        framing: ModelFraming(yaw: 2.4, zoom: 1.065, offset: [0.023, 0.152, -0.021])),
        "High Row Machine":             ExerciseModel(resource: "HighRowMachine",
                                        framing: ModelFraming(yaw: -2.5, zoom: 0.86, offset: [-0.007, 0.033, -0.005])),
        "Back Extension":               ExerciseModel(resource: "BackExtension",
                                        framing: ModelFraming(yaw: -2.5, zoom: 1.022, offset: [-0.022, 0.127, -0.016])),
        "Barbell Overhead Press":       ExerciseModel(resource: "BarbellOverheadPress",
                                        framing: ModelFraming(yaw: -0.5, zoom: 0.654, offset: [-0.009, -0.083, 0.005])),
        "Dumbbell Shoulder Press":      ExerciseModel(resource: "DumbbellShoulderPress",
                                        framing: ModelFraming(yaw: -0.5, zoom: 0.838, offset: [-0.016, 0.016, 0.009])),
        "Arnold Press":                 ExerciseModel(resource: "ArnoldPress",
                                        framing: ModelFraming(yaw: -0.5, zoom: 0.839, offset: [-0.005, 0.016, 0.003])),
        "Machine Shoulder Press":       ExerciseModel(resource: "MachineShoulderPress",
                                        framing: ModelFraming(yaw: -0.6, zoom: 0.894, offset: [0.002, 0.033, -0.001])),
        "Dumbbell Lateral Raise":       ExerciseModel(resource: "DumbbellLateralRaise",
                                        framing: ModelFraming(yaw: -0.25, zoom: 0.736, offset: [-0.01, 0.028, 0.003])),
        "Cable Lateral Raise":          ExerciseModel(resource: "CableLateralRaise",
                                        framing: ModelFraming(yaw: -0.25, zoom: 0.842, offset: [-0.019, -0.023, 0.005])),
        "Machine Lateral Raise":        ExerciseModel(resource: "MachineLateralRaise",
                                        framing: ModelFraming(yaw: -0.25, zoom: 0.931, offset: [0.008, 0.045, -0.002])),
        "Dumbbell Front Raise":         ExerciseModel(resource: "DumbbellFrontRaise",
                                        framing: ModelFraming(yaw: -0.55, zoom: 0.882, offset: [0.073, 0.026, -0.045])),
        "Reverse Dumbbell Fly":         ExerciseModel(resource: "ReverseDumbbellFly",
                                        framing: ModelFraming(yaw: -2.3, zoom: 0.987, offset: [-0.115, 0.228, -0.129])),
        "Reverse Pec Deck":             ExerciseModel(resource: "ReversePecDeck",
                                        framing: ModelFraming(yaw: 0.4, zoom: 0.846, offset: [0.032, 0.112, 0.013])),
        "Face Pull":                    ExerciseModel(resource: "FacePull",
                                        framing: ModelFraming(yaw: -2.7, zoom: 0.874, offset: [-0.061, 0.019, -0.029])),
        "Cable Rear Delt Fly":          ExerciseModel(resource: "CableRearDeltFly",
                                        framing: ModelFraming(yaw: -2.8, zoom: 0.689, offset: [-0.104, -0.005, -0.037])),
        "Barbell Curl":                       ExerciseModel(resource: "BarbellCurl",
                                        framing: ModelFraming(yaw: -0.4, zoom: 0.615, offset: [0.004, 0.019, -0.002])),
        "Triceps Pushdown":                   ExerciseModel(resource: "CableTricepsPushdown",
                                        framing: ModelFraming(yaw: -0.6, zoom: 0.884, offset: [0.031, 0.028, -0.021])),
        "Rope Pushdown":                       ExerciseModel(resource: "RopePushdown",
                                        framing: ModelFraming(yaw: -0.6, zoom: 0.883, offset: [0.039, 0.027, -0.026])),
        "Single-Arm Cable Pushdown":           ExerciseModel(resource: "SingleArmCablePushdown",
                                        framing: ModelFraming(yaw: -0.6, zoom: 0.88, offset: [0.016, 0.025, -0.011])),
        "Overhead Cable Triceps Extension":    ExerciseModel(resource: "OverheadCableTricepsExtension",
                                        framing: ModelFraming(yaw: -0.6, zoom: 0.802, offset: [-0.027, -0.05, 0.018])),
        "Dumbbell Overhead Triceps Extension": ExerciseModel(resource: "DumbbellOverheadTricepsExtension",
                                        framing: ModelFraming(yaw: -0.6, zoom: 0.766, offset: [-0.016, -0.039, 0.011])),
        "Skull Crusher":                       ExerciseModel(resource: "SkullCrusher",
                                        framing: ModelFraming(yaw: -1.0, zoom: 0.781, offset: [-0.046, 0.124, 0.072])),
        "Bench Dip":                           ExerciseModel(resource: "BenchDip",
                                        framing: ModelFraming(yaw: -1.0, zoom: 0.893, offset: [0.009, 0.135, -0.014])),
        "Assisted Dip":                        ExerciseModel(resource: "AssistedDip",
                                        framing: ModelFraming(yaw: -0.6, zoom: 0.658, offset: [-0.005, -0.042, 0.004])),
        // Legs2 batch and the four re-exported legacy models (2026-09-24),
        // solved at the trainer's real aspect (382×655), not the 0.74 the
        // older entries above were fitted at. Hinges and step-ups are seen
        // three-quarter from the lifter's left, lying and kneeling lifts
        // nearly side-on, abduction lifts almost head-on so the leg travels
        // across the frame.
        "Dumbbell Romanian Deadlift":          ExerciseModel(resource: "DumbbellRomanianDeadlift",
                                        framing: ModelFraming(yaw: -0.8, zoom: 0.883, offset: [0.034, 0.029, -0.035])),
        "Stiff-Leg Deadlift":                  ExerciseModel(resource: "StiffLegDeadlift",
                                        framing: ModelFraming(yaw: -0.8, zoom: 0.666, offset: [-0.007, 0.021, 0.007])),
        "Lying Leg Curl":                      ExerciseModel(resource: "LyingLegCurl",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.551, offset: [-0.006, 0.107, 0.029])),
        "Seated Leg Curl":                     ExerciseModel(resource: "SeatedLegCurl",
                                        framing: ModelFraming(yaw: -0.9, zoom: 0.813, offset: [0.053, 0.041, -0.067])),
        "Single-Leg Curl":                     ExerciseModel(resource: "SingleLegCurl",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.551, offset: [-0.006, 0.107, 0.029])),
        "Glute Bridge":                        ExerciseModel(resource: "GluteBridge",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.474, offset: [-0.015, 0.168, 0.068])),
        "Single-Leg Glute Bridge":             ExerciseModel(resource: "SingleLegGluteBridge",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.474, offset: [-0.015, 0.134, 0.068])),
        "Cable Glute Kickback":                ExerciseModel(resource: "CableGluteKickback",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.503, offset: [0.019, -0.030, -0.085])),
        "Cable Side Kick":                     ExerciseModel(resource: "CableSideKick",
                                        framing: ModelFraming(yaw: -0.3, zoom: 0.834, offset: [-0.016, 0.024, 0.005])),
        "Cable Hip Abduction":                 ExerciseModel(resource: "CableHipAbduction",
                                        framing: ModelFraming(yaw: -0.3, zoom: 0.893, offset: [-0.015, 0.029, 0.005])),
        "Hip Abduction Machine":               ExerciseModel(resource: "HipAbductionMachine",
                                        framing: ModelFraming(yaw: -0.3, zoom: 0.888, offset: [0.031, 0.027, -0.010])),
        "Hip Abduction Machine (Lean)":        ExerciseModel(resource: "HipAbductionMachineLean",
                                        framing: ModelFraming(yaw: -0.3, zoom: 0.863, offset: [0.031, 0.012, -0.010])),
        "Step-Up":                             ExerciseModel(resource: "StepUp",
                                        framing: ModelFraming(yaw: -0.9, zoom: 0.745, offset: [0.030, -0.049, -0.038])),
        "Push-Up":                             ExerciseModel(resource: "pushup",
                                        framing: ModelFraming(yaw: -1.2, zoom: 0.429, offset: [-0.014, 0.139, 0.037])),
        "Plank":                               ExerciseModel(resource: "Plank",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.441, offset: [-0.011, 0.168, 0.048])),
        // Abs batch (2026-09-24): lying, kneeling and hanging lifts are seen
        // near side-on from the lifter's left so the trunk and hip flexion
        // read; the side plank is seen from the front (it rests on the left
        // forearm, chest facing the camera); rotation lifts are near head-on.
        "Crunch":                              ExerciseModel(resource: "Crunch",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.441, offset: [-0.011, 0.155, 0.048])),
        "Reverse Crunch":                      ExerciseModel(resource: "ReverseCrunch",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.441, offset: [-0.011, 0.113, 0.048])),
        "Decline Crunch":                      ExerciseModel(resource: "DeclineCrunch",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.682, offset: [-0.018, 0.132, 0.081])),
        "Cable Crunch":                        ExerciseModel(resource: "CableCrunch",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.874, offset: [-0.015, 0.124, 0.066])),
        "Hanging Knee Raise":                  ExerciseModel(resource: "HangingKneeRaise",
                                        framing: ModelFraming(yaw: -1.3, zoom: 0.674, offset: [-0.002, -0.075, 0.006])),
        "Hanging Leg Raise":                   ExerciseModel(resource: "HangingLegRaise",
                                        framing: ModelFraming(yaw: -1.3, zoom: 0.654, offset: [0.015, -0.073, -0.053])),
        "Captain's Chair Leg Raise":           ExerciseModel(resource: "CaptainsChairLegRaise",
                                        framing: ModelFraming(yaw: -1.0, zoom: 0.670, offset: [0.030, 0.010, -0.047])),
        "Ab Wheel Rollout":                    ExerciseModel(resource: "AbWheelRollout",
                                        framing: ModelFraming(yaw: -1.35, zoom: 0.487, offset: [0.018, 0.151, -0.081])),
        "Side Plank":                          ExerciseModel(resource: "SidePlank",
                                        framing: ModelFraming(yaw: 1.5, zoom: 0.448, offset: [0.003, 0.113, 0.046])),
        "Russian Twist":                       ExerciseModel(resource: "RussianTwist",
                                        framing: ModelFraming(yaw: -0.5, zoom: 0.512, offset: [0.006, 0.142, -0.003])),
        "Cable Wood Chop":                     ExerciseModel(resource: "CableWoodChop",
                                        framing: ModelFraming(yaw: -0.3, zoom: 0.899, offset: [0.011, 0.033, -0.003]))
    ]

    static func model(for exercise: Exercise) -> ExerciseModel? {
        modelByExercise[exercise.name]
    }

    static func modelName(for exercise: Exercise) -> String? {
        modelByExercise[exercise.name]?.resource
    }

    static func hasTrainer(_ exercise: Exercise) -> Bool {
        contentByExercise[exercise.name] != nil
    }

    /// Exercises whose trainer is fully authored, in library order.
    static var trainableExercises: [Exercise] {
        exercises.filter(hasTrainer)
    }

    static let benchPressContent = ExerciseContent(
        annotations: [
            // Each dot follows its joint on the live model; only the labels are
            // placed by hand. Label points are unit fractions of the viewport —
            // the middle of the label edge the leader leaves from — laid out
            // for the `.bench` framing in the empty space around the lifter:
            // wrist above the near plate so its leader drops onto the grip,
            // elbow and bar path top left, stacked so their leaders never
            // cross, and the two lower-body cues under the bench. The joints
            // are the lifter's left side, which is the side facing the camera.
            // Keep these as Double literals — integer division here silently
            // collapses every label onto the origin.
            CueAnnotation(cueID: "wrist", label: "Keep wrists stacked",
                          labelPoint: CGPoint(x: 218.0 / 382.0, y: 147.0 / 567.0),
                          labelSide: .trailing, leaderLength: 34, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows ~45°",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 113.0 / 567.0),
                          leaderLength: 52, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Bar to lower chest",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 159.0 / 567.0),
                          leaderLength: 40,
                          joint: "support_PectoralisMajor_Abdominal_L"),
            CueAnnotation(cueID: "feet", label: "Feet planted",
                          labelPoint: CGPoint(x: 115.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Retract scapula",
                          labelPoint: CGPoint(x: 237.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 46, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "A stable shoulder blade gives the press a fixed base to push from.",
                why: "Retracting and depressing the scapula shortens the range the shoulder must travel and keeps the humeral head centred.",
                mistake: "Letting the shoulders round forward off the bench, so the press starts from an unstable, protracted position.",
                correct: "Pull the shoulder blades back and down into the bench and hold them there for the whole set."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "Elbow angle decides how load splits between the pecs and the shoulder joint.",
                why: "At roughly 45° from the torso the pectoralis major stays in its strongest line of pull while the humeral head keeps clearance in the socket.",
                mistake: "Flaring to 90° places the shoulder in full abduction and external rotation, loading the anterior capsule instead of the chest.",
                correct: "Tuck the upper arms toward the ribs as the bar descends, keeping forearms vertical under the wrist."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Wrist Stacking",
                intro: "The bar should sit over the forearm, not behind it.",
                why: "A stacked wrist transmits force straight down the forearm into the bar with no leak at the joint.",
                mistake: "Letting the bar drift back into the fingers, which extends the wrist and shifts the load off the pressing line.",
                correct: "Hold the bar low in the palm against the heel of the hand, knuckles up, wrist neutral."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "The bar does not travel straight up and down — it touches low and finishes over the shoulders.",
                why: "Touching the lower chest keeps the forearms vertical and the elbows tucked; pressing up and slightly back ends the rep over the shoulder joint, where the bar is most stable.",
                mistake: "Lowering to the neck or upper chest, which forces the elbows to flare and loads the front of the shoulder.",
                correct: "Lower to the bottom of the breastbone, around the nipple line, then press up and slightly back so the bar finishes above the shoulders."
            ),
            TechniqueCue(
                id: "feet",
                title: "Leg Drive",
                intro: "The feet are the press's contact with the floor, and they set the tension for the whole body.",
                why: "Driving the feet into the floor tightens the upper back and arch and carries force up through the torso into the bar.",
                mistake: "Feet floating, up on the toes or shuffling mid-set, so the hips shift and the press loses its base.",
                correct: "Plant both feet flat, a little wider than the hips, and push them into the floor through every rep without lifting the hips off the bench."
            )
        ],
        activation: [
            MuscleActivation(name: "Pectoralis Major", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.92),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.58),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.51)
        ],
        stabilisers: ["serratus anterior", "rotator cuff", "core"],
        setup: [
            "Lie on the flat bench with your eyes under the bar.",
            "Grip the bar slightly wider than shoulder-width.",
            "Plant your feet and pull your shoulder blades together.",
            "Unrack to straight arms, bar over your shoulders."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ELBOWS FLARED 90°",
            correctCue: "Elbows ~45° under the bar",
            mistakeCue: "Shoulder abducted 90°",
            correctNote: "Upper arms at roughly 45° keep the pectoralis major in its strongest line of pull and the shoulder joint in a supported position through the full range.",
            mistakeNote: "The upper arms sit perpendicular to the torso, so the load transfers off the pectoralis major and onto the anterior shoulder capsule. Chest activation drops while joint stress rises."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.26, ry: 0.15, cx: 0.46, cy: 0.40),
            .init(DS.activationSoft.opacity(0.32), rx: 0.13, ry: 0.09, cx: 0.66, cy: 0.52),
            .init(DS.activationSoft.opacity(0.32), rx: 0.11, ry: 0.08, cx: 0.33, cy: 0.33)
        ]
    )

    // MARK: - Chest content (2026-09-23)
    //
    // Every barbell/dumbbell bench variant below shares the bench press's
    // exact `.bench` framing (same yaw/zoom/offset), so the on-screen
    // composition is the same lifter-on-a-bench shot — the label layout is
    // reused as-is from `benchPressContent`, only the copy and target joints
    // change. The four machine/cable exercises have their own framing, so
    // their label points were placed from an offline projection of the real
    // joints through that framing's camera (see `Tools/model-pipeline/
    // joint_probe.py`) rather than eyeballed.
    //
    // Cues are grounded in widely-published technique guidance (ExRx.net,
    // ACE, NASM, StrengthLog, ATHLEAN-X, PowerliftingTechnique.com and
    // similar): 30° incline for upper-chest bias without over-loading the
    // front deltoid, 45° decline for lower-chest bias, elbows tracking
    // 45–60° off the torso rather than flared to 90°, a fixed slight elbow
    // bend through a fly's arc stopping at torso/shoulder level rather than
    // stretching past it, and low-to-high cable work finishing at chin
    // height rather than overhead.

    static let inclineBarbellBenchPressContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "wrist", label: "Keep wrists stacked",
                          labelPoint: CGPoint(x: 218.0 / 382.0, y: 147.0 / 567.0),
                          labelSide: .trailing, leaderLength: 34, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows ~45–60°",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 113.0 / 567.0),
                          leaderLength: 52, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Bar to upper chest",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 159.0 / 567.0),
                          leaderLength: 40,
                          joint: "support_PectoralisMajor_Clavicular_L"),
            CueAnnotation(cueID: "feet", label: "Feet planted",
                          labelPoint: CGPoint(x: 115.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Retract scapula",
                          labelPoint: CGPoint(x: 237.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 46, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "A retracted shoulder blade keeps the incline press stable overhead.",
                why: "Pulling the scapula back and down keeps the humeral head centred as the bar travels up and back over the shoulders.",
                mistake: "Shoulders rounding forward off the bench as the incline pulls the upper back out of position.",
                correct: "Pull the shoulder blades back and down into the bench before the first rep and hold them there."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Angle",
                intro: "Elbow angle decides how much of the load reaches the upper chest versus the front shoulder.",
                why: "Around 45–60° from the torso keeps the clavicular head of the pec in its strongest line without over-rotating the shoulder.",
                mistake: "Flaring the elbows out to 90°, which shifts the load onto the anterior deltoid.",
                correct: "Keep the upper arms tucked around 45–60° as the bar descends toward the upper chest."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Wrist Stacking",
                intro: "Same as the flat press — the bar sits over the forearm, not the fingers.",
                why: "A neutral, stacked wrist sends force straight down the arm instead of leaking at the joint.",
                mistake: "Letting the bar roll back into the fingers, extending the wrist under load.",
                correct: "Grip low in the palm, knuckles up, wrist locked neutral."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "Incline pressing lives or dies on bench angle and where the bar lands.",
                why: "A 30° bench biases the upper chest fibres over the front shoulder; steeper angles hand the set to the deltoid instead.",
                mistake: "Setting the bench past 45° and touching near the collarbone, which turns the lift into a shoulder press.",
                correct: "Keep the bench around 30°, touch the upper chest just below the collarbone, then press up and slightly back."
            ),
            TechniqueCue(
                id: "feet",
                title: "Leg Drive",
                intro: "The incline angle makes the base easier to lose than on a flat bench.",
                why: "Driving the feet down keeps the hips pinned and the upper back tight against the incline.",
                mistake: "Feet drifting or lifting as the steeper angle pulls the body toward the head of the bench.",
                correct: "Plant both feet flat and push down through every rep, keeping the hips on the bench."
            )
        ],
        activation: [
            MuscleActivation(name: "Upper Pectoralis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.85),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.62),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.45)
        ],
        stabilisers: ["serratus anterior", "rotator cuff", "core"],
        setup: [
            "Set the bench to about 30° and lie back, eyes under the bar.",
            "Grip the bar slightly wider than shoulder-width.",
            "Plant your feet and pull your shoulder blades back and down.",
            "Unrack to straight arms, bar over your collarbones."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "BENCH TOO STEEP",
            correctCue: "30° incline, bar to upper chest",
            mistakeCue: "Past 45°, delts take over",
            correctNote: "A 30° incline keeps the clavicular head of the pec in its strongest line while sharing the load sensibly with the front shoulder.",
            mistakeNote: "Above roughly 45° the movement behaves like a shoulder press — chest activation drops and the anterior deltoid takes over most of the work."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.24, ry: 0.14, cx: 0.46, cy: 0.32),
            .init(DS.activationSoft.opacity(0.32), rx: 0.12, ry: 0.08, cx: 0.65, cy: 0.44),
            .init(DS.activationSoft.opacity(0.32), rx: 0.10, ry: 0.07, cx: 0.34, cy: 0.26)
        ]
    )

    static let declineBarbellBenchPressContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "wrist", label: "Keep wrists stacked",
                          labelPoint: CGPoint(x: 218.0 / 382.0, y: 147.0 / 567.0),
                          labelSide: .trailing, leaderLength: 34, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows ~45°",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 113.0 / 567.0),
                          leaderLength: 52, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Bar to lower chest",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 159.0 / 567.0),
                          leaderLength: 40,
                          joint: "support_PectoralisMajor_Abdominal_L"),
            CueAnnotation(cueID: "feet", label: "Feet hooked in",
                          labelPoint: CGPoint(x: 115.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Retract scapula",
                          labelPoint: CGPoint(x: 237.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 46, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "The decline angle makes it easy to let the upper back float off the bench.",
                why: "A retracted, depressed scapula keeps the shoulder stable while gravity pulls the bar toward the face.",
                mistake: "Letting the shoulder blades lift off the pad as the bar comes down.",
                correct: "Pin the shoulder blades back and down before unracking, and keep them there for the set."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Angle",
                intro: "The elbow angle is the same rule as any bench press, just upside down.",
                why: "Roughly 45° keeps the lower pec fibres loaded without over-stressing the front of the shoulder.",
                mistake: "Flaring the elbows to 90° under a downward-angled bar, which stacks extra stress on the shoulder.",
                correct: "Tuck the upper arms to about 45° as the bar lowers toward the lower chest."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Wrist Stacking",
                intro: "Wrist position matters even more upside down, where it is harder to feel.",
                why: "A stacked wrist keeps force running straight down the forearm instead of into a bent joint.",
                mistake: "The bar drifting back into the fingers as the decline angle changes the pressing line.",
                correct: "Hold the bar low in the palm with the wrist locked straight over the forearm."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "Decline pressing targets the lower chest by changing where the bar lands, not how hard it is pressed.",
                why: "Touching the lower chest, around the bottom of the sternum, keeps the lower fibres in their strongest line of pull.",
                mistake: "Bouncing the bar off the chest to help it back up — a common decline fault that risks the sternum.",
                correct: "Lower under control to the bottom of the chest, pause, then press up and slightly back without bouncing."
            ),
            TechniqueCue(
                id: "feet",
                title: "Foot Position",
                intro: "The decline bench trades floor contact for a foot brace.",
                why: "Locking the feet under the roller pads replaces the leg drive a flat bench gets from the floor.",
                mistake: "Feet slipping out from under the pads mid-set, so the hips slide up the bench.",
                correct: "Hook both feet firmly under the roller pads and brace before the first rep."
            )
        ],
        activation: [
            MuscleActivation(name: "Lower Pectoralis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.93),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.55),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.38)
        ],
        stabilisers: ["latissimus dorsi", "rotator cuff", "core"],
        setup: [
            "Hook your legs under the foot rollers of the decline bench.",
            "Lie back with your eyes under the bar.",
            "Grip the bar slightly wider than shoulder-width.",
            "Unrack to straight arms, bar over your shoulders."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "BOUNCING OFF CHEST",
            correctCue: "Controlled touch, lower chest",
            mistakeCue: "Bouncing the bar off the chest",
            correctNote: "Pausing briefly at the lower chest keeps tension on the pec and protects the sternum and shoulders.",
            mistakeNote: "Bouncing the bar uses momentum instead of muscle, and repeated impact on the sternum is a well-documented cause of bench-press injuries."
        ),
        glows: [
            .init(DS.activation.opacity(0.60), rx: 0.26, ry: 0.15, cx: 0.46, cy: 0.48),
            .init(DS.activationSoft.opacity(0.28), rx: 0.11, ry: 0.08, cx: 0.66, cy: 0.58),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.07, cx: 0.33, cy: 0.40)
        ]
    )

    static let dumbbellBenchPressContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "wrist", label: "Keep wrists stacked",
                          labelPoint: CGPoint(x: 218.0 / 382.0, y: 147.0 / 567.0),
                          labelSide: .trailing, leaderLength: 34, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows 45–60°",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 113.0 / 567.0),
                          leaderLength: 52, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Dumbbells over chest",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 159.0 / 567.0),
                          leaderLength: 40,
                          joint: "support_PectoralisMajor_Sternal_L"),
            CueAnnotation(cueID: "feet", label: "Feet planted",
                          labelPoint: CGPoint(x: 115.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Retract scapula",
                          labelPoint: CGPoint(x: 237.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 46, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "Two independent weights ask more of the upper back than a fixed bar.",
                why: "A retracted, stable scapula gives each arm a fixed base, so the dumbbells travel on matching paths.",
                mistake: "Shoulders rounding forward, which lets the two dumbbells drift out of sync.",
                correct: "Retract the shoulder blades into the bench and keep them still through the set."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Angle",
                intro: "Dumbbells let the elbow travel more freely than a barbell — that freedom has to be controlled.",
                why: "Keeping the upper arms around 45–60° protects the shoulder; dropping the elbows below torso level externally rotates the joint under load.",
                mistake: "Letting the elbows drop below the line of the torso at the bottom, opening the shoulder up.",
                correct: "Lower until the upper arm is level with the torso, elbows around 45–60° out."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Wrist Stacking",
                intro: "Each dumbbell needs its own stacked wrist, with no bar to keep it honest.",
                why: "A neutral wrist keeps the dumbbell's weight running straight through the forearm.",
                mistake: "Wrists bending back under the dumbbell's weight, especially as the set gets hard.",
                correct: "Keep the wrist straight and firm, dumbbell resting over the middle of the forearm."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Press Path",
                intro: "Dumbbells travel in a slight arc that a fixed bar cannot.",
                why: "The extra range lets the dumbbells nearly touch at the top and sit slightly wider at the bottom, giving the pec a deeper stretch.",
                mistake: "Pressing straight up and down like a barbell, which wastes the range dumbbells allow.",
                correct: "Lower until the dumbbells are level with the chest, then press up and slightly in so they finish over the shoulders."
            ),
            TechniqueCue(
                id: "feet",
                title: "Leg Drive",
                intro: "The base matters even more with two independently balanced weights.",
                why: "Planted feet keep the torso still, which is what lets each arm press on the same path.",
                mistake: "Feet floating or shifting, adding instability to an already less-stable lift.",
                correct: "Plant both feet flat and drive them into the floor for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Pectoralis Major", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.90),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.53),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50)
        ],
        stabilisers: ["rotator cuff", "serratus anterior", "biceps brachii"],
        setup: [
            "Sit on the end of a flat bench, dumbbells on your thighs.",
            "Lie back and bring the dumbbells beside your chest.",
            "Plant your feet and pull your shoulder blades together.",
            "Press to straight arms, palms facing forward."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ELBOWS DROPPED BELOW SHOULDER",
            correctCue: "Elbows 45–60°, dumbbells stacked",
            mistakeCue: "Elbows sink below torso line",
            correctNote: "Stopping the descent when the upper arm is level with the torso keeps the shoulder supported through the deeper dumbbell range.",
            mistakeNote: "Letting the elbows travel below the torso externally rotates the shoulder at its most loaded point — a common cause of dumbbell-press shoulder strain."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.26, ry: 0.15, cx: 0.46, cy: 0.42),
            .init(DS.activationSoft.opacity(0.32), rx: 0.13, ry: 0.09, cx: 0.67, cy: 0.53),
            .init(DS.activationSoft.opacity(0.32), rx: 0.11, ry: 0.08, cx: 0.32, cy: 0.35)
        ]
    )

    static let inclineDumbbellPressContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "wrist", label: "Keep wrists stacked",
                          labelPoint: CGPoint(x: 218.0 / 382.0, y: 147.0 / 567.0),
                          labelSide: .trailing, leaderLength: 34, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows 45–60°",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 113.0 / 567.0),
                          leaderLength: 52, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Dumbbells to upper chest",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 159.0 / 567.0),
                          leaderLength: 40,
                          joint: "support_PectoralisMajor_Clavicular_L"),
            CueAnnotation(cueID: "feet", label: "Feet planted",
                          labelPoint: CGPoint(x: 115.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Retract scapula",
                          labelPoint: CGPoint(x: 237.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 46, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "The incline angle makes it easier to lose the shoulder blades than on a flat bench.",
                why: "Retracting and depressing the scapula keeps the shoulder joint centred as the dumbbells travel up and back.",
                mistake: "Shoulders creeping forward as the steeper angle pulls the upper back out of the bench.",
                correct: "Set the shoulder blades back and down before the first rep and hold them through the set."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Angle",
                intro: "Elbow angle still splits the load between chest and shoulder on an incline.",
                why: "Around 45–60° keeps the upper pec in its strongest line without handing the rep to the front deltoid.",
                mistake: "Elbows flaring wide as the dumbbells let them drift outside the frame.",
                correct: "Keep the upper arms tucked to about 45–60° as the dumbbells lower toward the upper chest."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Wrist Stacking",
                intro: "Same rule as any dumbbell press, just at an angle.",
                why: "A stacked wrist keeps the dumbbell's load running straight through the forearm instead of bending the joint.",
                mistake: "The wrist folding backward as the incline changes the angle the load pulls from.",
                correct: "Keep the wrist neutral and firm, dumbbell centred over the forearm."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Press Path",
                intro: "Bench angle decides how much of this lands on the upper chest.",
                why: "A 30° incline keeps the clavicular pec fibres in their strongest line without overloading the front shoulder.",
                mistake: "Setting the bench too steep and pressing more overhead than up, which shifts the work to the shoulder.",
                correct: "Keep the bench near 30°, lower to the upper chest, then press up and slightly back."
            ),
            TechniqueCue(
                id: "feet",
                title: "Leg Drive",
                intro: "The incline still needs a solid floor connection to press against.",
                why: "Driving the feet down keeps the hips anchored against the incline instead of sliding up it.",
                mistake: "Feet lifting or sliding as the angle pulls the body toward the top of the bench.",
                correct: "Plant both feet flat and push down through the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Upper Pectoralis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.83),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.60),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.44)
        ],
        stabilisers: ["rotator cuff", "serratus anterior", "biceps brachii"],
        setup: [
            "Set the bench to about 30° and sit with the dumbbells on your thighs.",
            "Lie back and bring the dumbbells beside your upper chest.",
            "Plant your feet and pull your shoulder blades together.",
            "Press to straight arms, palms facing forward."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "BENCH TOO STEEP",
            correctCue: "30° incline, dumbbells to upper chest",
            mistakeCue: "Steep bench turns it into a shoulder press",
            correctNote: "A moderate incline keeps tension on the upper chest while sharing load sensibly with the front shoulder.",
            mistakeNote: "Past roughly 45° the dumbbells travel nearly straight overhead, so the anterior deltoid — not the chest — ends up doing most of the pressing."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.24, ry: 0.14, cx: 0.46, cy: 0.34),
            .init(DS.activationSoft.opacity(0.32), rx: 0.12, ry: 0.08, cx: 0.66, cy: 0.46),
            .init(DS.activationSoft.opacity(0.32), rx: 0.10, ry: 0.07, cx: 0.33, cy: 0.28)
        ]
    )

    static let dumbbellFlyContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "wrist", label: "Palms facing in",
                          labelPoint: CGPoint(x: 218.0 / 382.0, y: 147.0 / 567.0),
                          labelSide: .trailing, leaderLength: 34, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Fixed ~15–20° bend",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 113.0 / 567.0),
                          leaderLength: 52, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Arc stops at torso level",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 159.0 / 567.0),
                          leaderLength: 40,
                          joint: "support_PectoralisMajor_Sternal_L"),
            CueAnnotation(cueID: "feet", label: "Feet planted",
                          labelPoint: CGPoint(x: 115.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Shoulder blades set",
                          labelPoint: CGPoint(x: 237.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 46, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "A fly loads the shoulder in its most open position, so the base has to be solid.",
                why: "Retracted shoulder blades keep the joint centred while the arms travel wide with no bar to share the load.",
                mistake: "Shoulder blades rolling forward at the bottom, right where the stretch is deepest.",
                correct: "Keep the shoulder blades pulled back into the bench through the whole arc."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Bend",
                intro: "The elbow angle should barely change for the whole rep.",
                why: "A fixed, slight bend keeps the work on the chest; bending more at the bottom hands the rep to the triceps and shoulders.",
                mistake: "Bending the elbows further as the weight drops, quietly turning the fly into a press.",
                correct: "Set a soft 15–20° elbow bend at the top and hold that angle all the way down and back up."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Hand Position",
                intro: "The palms stay facing each other for the whole movement.",
                why: "A neutral, facing-in grip keeps the dumbbells travelling on the same arc as the arms.",
                mistake: "Wrists rolling or drifting apart as the weight pulls the dumbbells off-path.",
                correct: "Keep the palms facing each other and the wrists neutral throughout."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Fly Arc",
                intro: "This is an arc, not a press — the dumbbells sweep out and back, not down and up.",
                why: "Stopping the stretch when the upper arms are level with the torso keeps the anterior shoulder capsule out of its riskiest range.",
                mistake: "Lowering the dumbbells past shoulder level chasing a deeper stretch.",
                correct: "Sweep the arms out until the upper arms are level with the torso, then squeeze back up in the same arc."
            ),
            TechniqueCue(
                id: "feet",
                title: "Leg Drive",
                intro: "A fly has no bar to anchor against, so the base does that job.",
                why: "Planted feet keep the torso still so the shoulders — not the whole body — do the moving.",
                mistake: "Feet floating as the wide arm path pulls the torso off balance.",
                correct: "Plant both feet flat and keep them still for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Pectoralis Major", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["biceps brachii", "rotator cuff", "serratus anterior"],
        setup: [
            "Lie on a flat bench with your feet flat on the floor.",
            "Press the dumbbells over your chest, palms facing each other.",
            "Unlock the elbows slightly and keep that bend throughout."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "OVERSTRETCHED SHOULDERS",
            correctCue: "Arc stops at torso level",
            mistakeCue: "Dumbbells drop past shoulder line",
            correctNote: "Stopping the arc when the upper arms reach torso level keeps the pec loaded without pushing the shoulder into its most vulnerable position.",
            mistakeNote: "Chasing a deeper stretch past shoulder level loads the anterior capsule instead of the chest, and is one of the more common ways lifters strain the shoulder on a fly."
        ),
        glows: [
            .init(DS.activation.opacity(0.60), rx: 0.28, ry: 0.15, cx: 0.46, cy: 0.42),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.07, cx: 0.68, cy: 0.50)
        ]
    )

    static let inclineDumbbellFlyContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "wrist", label: "Palms facing in",
                          labelPoint: CGPoint(x: 218.0 / 382.0, y: 147.0 / 567.0),
                          labelSide: .trailing, leaderLength: 34, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Fixed ~15–20° bend",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 113.0 / 567.0),
                          leaderLength: 52, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Squeeze over upper chest",
                          labelPoint: CGPoint(x: 172.0 / 382.0, y: 159.0 / 567.0),
                          leaderLength: 40,
                          joint: "support_PectoralisMajor_Clavicular_L"),
            CueAnnotation(cueID: "feet", label: "Feet planted",
                          labelPoint: CGPoint(x: 115.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Shoulder blades set",
                          labelPoint: CGPoint(x: 237.0 / 382.0, y: 473.0 / 567.0),
                          labelSide: .trailing, leaderLength: 46, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "On an incline, gravity pulls even harder on a rounded shoulder.",
                why: "Retracted shoulder blades keep the joint centred as the arms open wide against the steeper angle.",
                mistake: "Shoulder blades lifting off the bench as the incline adds extra pull at the bottom.",
                correct: "Keep the shoulder blades pinned back into the bench through the whole arc."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Bend",
                intro: "Same fixed-elbow rule as any fly, just at an angle.",
                why: "A constant, slight bend keeps the target on the upper chest instead of leaking into the triceps.",
                mistake: "Elbows bending more at the bottom, which quietly turns the fly into an incline press.",
                correct: "Hold a soft 15–20° elbow bend from the top of the arc to the bottom."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Hand Position",
                intro: "The grip stays neutral for the whole arc, even at an incline.",
                why: "Facing palms keep the dumbbells tracking the same arc as the arms.",
                mistake: "Wrists drifting apart as the incline changes the angle the weight pulls from.",
                correct: "Keep the palms facing each other and the wrists neutral for the whole set."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Fly Arc",
                intro: "Bench angle decides how much of this reaches the upper chest.",
                why: "A moderate incline keeps the clavicular pec fibres loaded through the arc without turning the shoulder into the limiting joint.",
                mistake: "Letting the arc drop past shoulder level chasing extra stretch.",
                correct: "Open the arms until the upper arms are level with the torso, then squeeze them back together over the upper chest."
            ),
            TechniqueCue(
                id: "feet",
                title: "Leg Drive",
                intro: "A planted base keeps the incline from rocking the torso as the arms swing wide.",
                why: "Still feet let the shoulders do the moving instead of the whole body helping the swing.",
                mistake: "Feet lifting as the wider arc pulls the body off the bench.",
                correct: "Plant both feet flat and keep them still through the set."
            )
        ],
        activation: [
            MuscleActivation(name: "Upper Pectoralis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.82),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.46)
        ],
        stabilisers: ["biceps brachii", "rotator cuff", "serratus anterior"],
        setup: [
            "Set the bench to about 30° and lie back.",
            "Press the dumbbells over your upper chest, palms facing each other.",
            "Unlock the elbows slightly and keep that bend throughout."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "TURNING FLY INTO A PRESS",
            correctCue: "Fixed elbow bend, arc to torso level",
            mistakeCue: "Elbows bend more at the bottom",
            correctNote: "Holding the elbow angle constant keeps the upper chest doing the work through the whole arc.",
            mistakeNote: "Letting the elbows bend more at the bottom shifts load onto the triceps and front shoulder, so the set quietly turns into a weak incline press."
        ),
        glows: [
            .init(DS.activation.opacity(0.60), rx: 0.26, ry: 0.14, cx: 0.46, cy: 0.32),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.07, cx: 0.67, cy: 0.42)
        ]
    )

    static let chestPressMachineContent = ExerciseContent(
        annotations: [
            // `.chestPress` is a three-quarter seated shot (yaw -0.7) — label
            // points come from projecting the real joints through that
            // framing (see joint_probe.py), not the bench layout.
            CueAnnotation(cueID: "wrist", label: "Grip ~45–60° from torso",
                          labelPoint: CGPoint(x: 0.80, y: 0.42),
                          leaderLength: 44, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows in line with wrists",
                          labelPoint: CGPoint(x: 0.22, y: 0.16),
                          labelSide: .trailing, leaderLength: 50, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Press to full extension",
                          labelPoint: CGPoint(x: 0.22, y: 0.30),
                          labelSide: .trailing, leaderLength: 44,
                          joint: "support_PectoralisMajor_Sternal_L"),
            CueAnnotation(cueID: "feet", label: "Feet flat, back on pad",
                          labelPoint: CGPoint(x: 0.22, y: 0.85),
                          labelSide: .trailing, leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "No shrugging",
                          labelPoint: CGPoint(x: 0.80, y: 0.65),
                          leaderLength: 46, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "The seat and back pad do less work than they look like — the shoulder blades still have to hold their own position.",
                why: "Retracting and depressing the scapula keeps the shoulder stable through the guided path.",
                mistake: "Shoulders creeping up toward the ears as the set gets hard.",
                correct: "Pull the shoulder blades back and down before the first rep and keep them there."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Alignment",
                intro: "The machine fixes the bar path, but the elbow still has to track correctly under it.",
                why: "Keeping the elbow lined up under the wrist, around 45–60° from the torso, keeps the chest in its strongest line without straining the wrist.",
                mistake: "Elbows drifting either wide of the wrists or tucked tight against the ribs.",
                correct: "Keep the elbows tracking directly under the wrists as you press."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Grip Position",
                intro: "Handle height and grip angle set which part of the chest does the work.",
                why: "A grip roughly level with mid-chest keeps the load on the pec instead of the front shoulder.",
                mistake: "Gripping too high or too low, which quietly turns the press into a shoulder or triceps exercise.",
                correct: "Set the seat so the handles sit at mid-chest height before starting."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Press Path",
                intro: "The machine's fixed arc still needs a full, controlled range to earn its keep.",
                why: "Extending fully without locking out hard keeps continuous tension on the chest through the whole rep.",
                mistake: "Using short, bouncy reps that never load the chest through a full range.",
                correct: "Press out to just short of lockout, then lower under control back to the chest."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base Position",
                intro: "A machine removes balance demands, but the base still has to hold still.",
                why: "Feet flat and back pinned to the pad stop the body from helping the press with momentum.",
                mistake: "Arching the back off the pad or pushing through the toes to move more weight.",
                correct: "Keep the back flat against the pad and both feet flat on the floor for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Pectoralis Major", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.87),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.54),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.46)
        ],
        stabilisers: ["serratus anterior", "rotator cuff"],
        setup: [
            "Set the seat so the handles line up with your mid-chest.",
            "Sit with your back flat against the pad, feet on the floor.",
            "Grip the handles with your elbows just below shoulder height."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SHOULDERS SHRUGGED",
            correctCue: "Handles at mid-chest, scapula set",
            mistakeCue: "Shoulders creep toward the ears",
            correctNote: "Setting the seat so the handles sit at mid-chest and keeping the scapula retracted channels the load into the pec.",
            mistakeNote: "Handles set too high, or shoulders shrugging mid-set, shift the work onto the front deltoid and traps instead of the chest."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.24, ry: 0.14, cx: 0.50, cy: 0.42),
            .init(DS.activationSoft.opacity(0.30), rx: 0.11, ry: 0.08, cx: 0.65, cy: 0.44)
        ]
    )

    static let pecDeckFlyContent = ExerciseContent(
        annotations: [
            // `.pecDeck` is head-on (yaw 0) — see joint_probe.py.
            CueAnnotation(cueID: "wrist", label: "Forearms on the pads",
                          labelPoint: CGPoint(x: 0.85, y: 0.44),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows at chest height",
                          labelPoint: CGPoint(x: 0.18, y: 0.18),
                          labelSide: .trailing, leaderLength: 50, joint: "upper_arm_L"),
            CueAnnotation(cueID: "barpath", label: "Squeeze pads together",
                          labelPoint: CGPoint(x: 0.18, y: 0.32),
                          labelSide: .trailing, leaderLength: 46,
                          joint: "support_PectoralisMajor_Sternal_L"),
            CueAnnotation(cueID: "feet", label: "Feet flat on floor",
                          labelPoint: CGPoint(x: 0.82, y: 0.85),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Back flat on pad",
                          labelPoint: CGPoint(x: 0.82, y: 0.55),
                          leaderLength: 42, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "A seated fly still needs a stable base to squeeze against.",
                why: "Keeping the back and shoulder blades against the pad stops the torso from helping the squeeze.",
                mistake: "Arching or twisting off the backrest to force the pads together.",
                correct: "Press the whole back into the pad and keep it there through every rep."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Height",
                intro: "Elbow height decides where on the chest the tension lands.",
                why: "Elbows level with the shoulders keep the mid pec in its strongest line; letting them drop or rise shifts the target.",
                mistake: "Letting the elbows drop below shoulder height as the set fatigues.",
                correct: "Keep the upper arms level with the shoulders, forearms resting on the pads."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Forearm Contact",
                intro: "The pads do the gripping, so forearm contact is what actually transmits force.",
                why: "Full contact between forearm and pad spreads the load evenly and protects the wrist and elbow.",
                mistake: "Pressing mainly through the hands, which loads the wrist instead of the chest.",
                correct: "Keep the forearms flat against the pads and push through them, not through the grip."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Fly Path",
                intro: "The pec deck trades range for a locked-in path — use the range it gives you.",
                why: "A full squeeze at the front, held briefly, maximises time under tension for the chest.",
                mistake: "Using momentum to swing the pads together and immediately releasing.",
                correct: "Bring the pads together under control, squeeze the chest for a moment, then return slowly."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base Position",
                intro: "A stable base keeps the fatigue in the chest, not the legs.",
                why: "Feet flat on the floor anchor the body so the arms can move without the legs compensating.",
                mistake: "Feet tucked under the seat or pushing off the floor to help the squeeze.",
                correct: "Keep both feet flat on the floor for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Pectoralis Major", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.90),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.35)
        ],
        stabilisers: ["serratus anterior", "rotator cuff"],
        setup: [
            "Set the seat so the handles sit at chest height.",
            "Sit tall with your back against the pad.",
            "Take the handles out wide with a slight bend in the elbows."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "MOMENTUM SWING",
            correctCue: "Controlled squeeze, brief hold",
            mistakeCue: "Pads swung together and released",
            correctNote: "A controlled squeeze with a brief hold at the front keeps continuous tension on the chest through the whole range.",
            mistakeNote: "Swinging the pads together with momentum and releasing immediately turns a chest isolation exercise into a fast, low-tension rep that barely touches the pec."
        ),
        glows: [
            .init(DS.activation.opacity(0.62), rx: 0.24, ry: 0.13, cx: 0.50, cy: 0.40),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.07, cx: 0.50, cy: 0.40)
        ]
    )

    static let cableFlyContent = ExerciseContent(
        annotations: [
            // `.cableStation` is head-on (yaw 0) — see joint_probe.py.
            CueAnnotation(cueID: "wrist", label: "Hands meet at sternum height",
                          labelPoint: CGPoint(x: 0.88, y: 0.42),
                          leaderLength: 42, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows fixed, slight bend",
                          labelPoint: CGPoint(x: 0.15, y: 0.14),
                          labelSide: .trailing, leaderLength: 52, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Hug the arc, don't press",
                          labelPoint: CGPoint(x: 0.15, y: 0.28),
                          labelSide: .trailing, leaderLength: 46,
                          joint: "support_PectoralisMajor_Sternal_L"),
            CueAnnotation(cueID: "feet", label: "Split stance, knees soft",
                          labelPoint: CGPoint(x: 0.82, y: 0.88),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Chest up, shoulders back",
                          labelPoint: CGPoint(x: 0.18, y: 0.60),
                          labelSide: .trailing, leaderLength: 44, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "Constant cable tension makes it easy to let the shoulders round forward.",
                why: "Keeping the chest lifted and shoulder blades back stabilises the joint through a movement with tension in every position.",
                mistake: "Shoulders rolling forward as the cables pull the arms back at the start.",
                correct: "Set the chest up and shoulder blades back before taking the first step into the stance."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The elbow angle should barely move for the whole set.",
                why: "A fixed, slight bend keeps the work in the shoulder joint and on the chest instead of turning the move into a press.",
                mistake: "Bending the elbows more as the cables come together, quietly pressing instead of flying.",
                correct: "Set a slight elbow bend at the start and hold that same angle through the whole rep."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Hand Path",
                intro: "Where the hands meet decides which fibres of the chest do the most work.",
                why: "Bringing the hands together in front of the sternum keeps the tension on the mid chest.",
                mistake: "Hands meeting too high or too low, which drifts the target to the shoulder or lower chest.",
                correct: "Sweep the hands together directly in front of the sternum."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Fly Arc",
                intro: "The cue that keeps a cable fly a fly.",
                why: "Thinking 'hug a barrel' keeps the movement happening at the shoulder joint instead of the elbow.",
                mistake: "Elbows driving forward like a press instead of the arms sweeping through an arc.",
                correct: "Imagine hugging a large barrel and sweep the arms through that arc."
            ),
            TechniqueCue(
                id: "feet",
                title: "Stance",
                intro: "Constant cable pull needs a braced base to work against.",
                why: "A split stance with soft knees resists the forward pull of the cables and keeps the torso still.",
                mistake: "Standing square with locked knees, so the cables pull the body forward mid-rep.",
                correct: "Stagger the feet, soften the knees, and brace before starting the set."
            )
        ],
        activation: [
            MuscleActivation(name: "Pectoralis Major", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.42)
        ],
        stabilisers: ["biceps brachii", "serratus anterior", "core"],
        setup: [
            "Set both pulleys at about shoulder height.",
            "Take a handle in each hand and step forward between the stacks.",
            "Stand in a split stance, leaning slightly forward, elbows soft."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "TURNING FLY INTO A PRESS",
            correctCue: "Fixed elbow, arc to sternum",
            mistakeCue: "Elbows drive forward like a press",
            correctNote: "Holding the elbow angle constant and thinking of the movement as a hug keeps the tension on the chest through the whole arc.",
            mistakeNote: "Letting the elbows bend and drive forward turns the constant cable tension into a weak press, handing work to the shoulders and triceps instead of the chest."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.22, ry: 0.13, cx: 0.50, cy: 0.36),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.07, cx: 0.50, cy: 0.36)
        ]
    )

    static let lowToHighCableFlyContent = ExerciseContent(
        annotations: [
            // Custom framing (yaw 0, zoom 0.913) — see joint_probe.py.
            CueAnnotation(cueID: "wrist", label: "Hands meet at chin height",
                          labelPoint: CGPoint(x: 0.85, y: 0.46),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows lead the sweep",
                          labelPoint: CGPoint(x: 0.15, y: 0.16),
                          labelSide: .trailing, leaderLength: 50, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Diagonal path, low to high",
                          labelPoint: CGPoint(x: 0.15, y: 0.30),
                          labelSide: .trailing, leaderLength: 44,
                          joint: "support_PectoralisMajor_Clavicular_L"),
            CueAnnotation(cueID: "feet", label: "Split stance for balance",
                          labelPoint: CGPoint(x: 0.82, y: 0.88),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "scapula", label: "Shoulders down, not shrugged",
                          labelPoint: CGPoint(x: 0.82, y: 0.60),
                          leaderLength: 42, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "The upward angle makes it easy to shrug instead of press through the chest.",
                why: "Keeping the shoulder blades down and back stops the traps from taking over the diagonal pull.",
                mistake: "Shoulders creeping up toward the ears as the hands rise past chin height.",
                correct: "Keep the shoulder blades set down and back through the whole sweep."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "Same fixed-elbow rule as any fly, on a diagonal path.",
                why: "A constant, slight bend keeps the upper chest doing the work as the arms sweep up and in.",
                mistake: "Elbows bending more as the arms rise, turning the sweep into an upward press.",
                correct: "Set a slight elbow bend at the bottom and hold it all the way to the top."
            ),
            TechniqueCue(
                id: "wrist",
                title: "Hand Path",
                intro: "Where the hands finish decides whether the upper chest or the front shoulder gets the work.",
                why: "Meeting at chin-to-upper-chest height keeps the tension on the clavicular pec.",
                mistake: "Pulling the hands up past head height, which shifts the load onto the front deltoid.",
                correct: "Stop the hands at chin to upper-chest height, not overhead."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Cable Path",
                intro: "The whole point of this fly is the diagonal — low pulley to a high finish.",
                why: "Sweeping from low at the sides to high at the chin biases the upper, clavicular fibres of the pec.",
                mistake: "Pulling straight across like a standard cable fly, which loses the upper-chest bias.",
                correct: "Sweep both hands up and in on a diagonal, finishing high and together in front of the chin."
            ),
            TechniqueCue(
                id: "feet",
                title: "Stance",
                intro: "The upward pull needs a stance that resists being pulled forward and up.",
                why: "A staggered stance with soft knees keeps the torso still against the low pulleys' pull.",
                mistake: "Standing square, which lets the cables rock the body during the sweep.",
                correct: "Split the stance, soften the knees, and keep the torso still through the sweep."
            )
        ],
        activation: [
            MuscleActivation(name: "Upper Pectoralis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.84),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50)
        ],
        stabilisers: ["biceps brachii", "serratus anterior", "core"],
        setup: [
            "Set both pulleys at their lowest position.",
            "Take a handle in each hand and step forward to the centre.",
            "Start with the hands low beside your hips, elbows soft."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "OVERSHOOTING OVERHEAD",
            correctCue: "Hands finish at chin height",
            mistakeCue: "Hands pulled up past the head",
            correctNote: "Finishing the sweep at chin-to-upper-chest height keeps the tension on the clavicular pec fibres.",
            mistakeNote: "Pulling the hands higher than the chin hands the top of the movement to the front deltoid instead of the upper chest."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.22, ry: 0.12, cx: 0.50, cy: 0.28),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.07, cx: 0.65, cy: 0.36)
        ]
    )

    // MARK: - Back content (2026-09-23)
    //
    // Every Back exercise has its own hand-solved framing (see modelByExercise
    // above), so — unlike the chest bench variants — the five label points
    // below are not shared verbatim across exercises. They do reuse one
    // layout *shape*, though: a stacked pair top-left (elbow, then pull
    // target, mirroring the bench press's own elbow/bar-path stack), a single
    // label top-right (grip), and two bottom labels (base, scapula). That
    // shape is what keeps five labels from colliding regardless of the
    // exercise's actual camera angle; only the copy and the tracked joint
    // change per exercise. Positions were sanity-checked against each
    // exercise's real joint projections offline (see
    // `Tools/model-pipeline/joint_probe.py`) before writing.
    //
    // Technique cues are grounded in widely-published guidance (StrongLifts,
    // Barbell Logic, BarBend, ATHLEAN-X, PowerliftingTechnique.com, NASM):
    // a vertical bar path over mid-foot with a neutral spine on the deadlift,
    // elbows driving back (not out) and the bar/handle finishing at the
    // lower ribs on rows, chest (not chin) to the bar on pull-ups/chin-ups,
    // elbows down-and-back to the upper chest on pulldowns, a rigid elbow
    // on the straight-arm pulldown so the lats — not the triceps — do the
    // work, and a controlled hip hinge rather than a lower-back arch on the
    // back extension.

    private static func backAnnotation(
        _ cueID: String, _ label: String, _ joint: String,
        slot: (x: Double, y: Double), side: HorizontalEdge = .leading, leader: CGFloat
    ) -> CueAnnotation {
        CueAnnotation(cueID: cueID, label: label,
                      labelPoint: CGPoint(x: slot.x, y: slot.y),
                      labelSide: side, leaderLength: leader, joint: joint)
    }

    // The five reusable label slots (unit fractions), in the same layout
    // shape as `benchPressContent`'s hand-placed points.
    private static let backSlotElbow = (x: 172.0 / 382.0, y: 113.0 / 567.0)   // top-left, upper
    private static let backSlotPath = (x: 172.0 / 382.0, y: 159.0 / 567.0)    // top-left, lower
    private static let backSlotGrip = (x: 218.0 / 382.0, y: 147.0 / 567.0)    // top-right
    private static let backSlotBase = (x: 115.0 / 382.0, y: 473.0 / 567.0)   // bottom-left
    private static let backSlotScapula = (x: 237.0 / 382.0, y: 473.0 / 567.0) // bottom-right

    static let deadliftContent = ExerciseContent(
        annotations: [
            backAnnotation("barpath", "Bar close to shins", "forearm_L", slot: backSlotElbow, leader: 50),
            backAnnotation("hips", "Hips hinge back", "pelvis", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Hook or double grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Bar over mid-foot", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("spine", "Neutral spine", "spine", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "spine",
                title: "Spine Position",
                intro: "The deadlift is safe or risky almost entirely based on what the lower back does under load.",
                why: "A neutral spine transmits force through the skeleton; a rounded one asks the lumbar discs to do a job they are poor at.",
                mistake: "The lower back rounding as the bar leaves the floor, usually because the hips shot up too early.",
                correct: "Take the slack out of the bar, brace the core, and keep the chest tall so the spine stays neutral throughout."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Hinge",
                intro: "The deadlift is a hip hinge loaded with a bar, not a squat.",
                why: "Sending the hips back first loads the hamstrings and glutes, which are built for this kind of force; squatting the weight up overloads the knees and quads instead.",
                mistake: "Hips rising faster than the chest, turning the pull into a stiff-legged good morning.",
                correct: "Push the hips back to find the bar, then drive them forward to lock out, keeping shoulders over the bar at the start."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "The grip is the only connection to the bar, and it has to survive the whole set.",
                why: "A hook grip or an alternating grip stops the bar from rolling out of the hands as the weight gets heavy.",
                mistake: "A double-overhand grip that slips before the legs or back give out.",
                correct: "Grip just outside the knees with a hook grip or an alternating grip once the load gets heavy."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "The single clearest sign of a good deadlift is what the bar does, not what the lifter feels.",
                why: "A bar that stays vertical over mid-foot travels the shortest possible distance; one that drifts forward turns into a much harder, less stable pull.",
                mistake: "The bar drifting away from the shins into an S-shaped path, usually because the lats aren't holding it in.",
                correct: "Drag the bar up the shins and thighs in a straight vertical line, thinking 'squeeze the bar into my legs.'"
            ),
            TechniqueCue(
                id: "feet",
                title: "Foot Position",
                intro: "Where the bar starts relative to the feet decides the whole bar path.",
                why: "The bar over mid-foot is the shortest, most mechanically efficient path from floor to lockout.",
                mistake: "The bar starting too far forward, over the toes, forcing it away from the body for the whole pull.",
                correct: "Set up with the bar about an inch from the shins, directly over mid-foot, feet roughly hip-width apart."
            )
        ],
        activation: [
            MuscleActivation(name: "Erector Spinae", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.85),
            MuscleActivation(name: "Gluteus Maximus", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.76),
            MuscleActivation(name: "Hamstrings", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.62)
        ],
        stabilisers: ["latissimus dorsi", "upper trapezius", "forearms", "core"],
        setup: [
            "Stand with feet hip-width, the bar over mid-foot.",
            "Hinge down and grip the bar just outside your knees.",
            "Drop your hips until your shins touch the bar.",
            "Chest up, back flat, pull the slack out of the bar."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ROUNDED LOWER BACK",
            correctCue: "Neutral spine, bar on the shins",
            mistakeCue: "Lower back rounds under load",
            correctNote: "A neutral spine lets the hips and legs do the lifting while the back simply transmits the force.",
            mistakeNote: "A rounded lower back shifts load from the strong hip and leg muscles onto the lumbar discs and ligaments — the most common cause of deadlift back injuries."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.16, ry: 0.30, cx: 0.55, cy: 0.55),
            .init(DS.activationSoft.opacity(0.30), rx: 0.14, ry: 0.10, cx: 0.60, cy: 0.68)
        ]
    )

    static let barbellBentOverRowContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows drive back", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Bar to lower ribs", "attachment_LatissimusDorsi_L", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Shoulder-width grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Hips back", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "Squeeze the blades", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "The row starts and ends with the shoulder blades, not the arms.",
                why: "Squeezing the blades together at the top is what turns an arm pull into a back exercise.",
                mistake: "The shoulders staying protracted throughout, so the lats and traps never fully engage.",
                correct: "Retract the shoulder blades hard at the top of every rep, then let them protract slightly on the way down."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "Where the elbows travel decides which muscles do the pulling.",
                why: "Driving the elbows straight back and slightly up keeps the lats and mid-back in their strongest line; flaring them out shifts work onto the shoulders.",
                mistake: "Elbows winging out to the sides instead of tracking back along the body.",
                correct: "Keep the elbows close to the torso and drive them straight back and up."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "Grip width changes how far the bar has to travel and which fibres take the most load.",
                why: "A shoulder-width overhand grip keeps the forearms vertical under the bar for an efficient pulling line.",
                mistake: "A grip so wide the elbows can't track back properly, turning the pull into a shrug.",
                correct: "Take an overhand grip roughly shoulder-width apart."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "The bar should travel in a straight line, close to the body, from thighs to ribs.",
                why: "Rowing to the lower ribs or upper abdomen keeps the elbows tracking back rather than flaring, and keeps the bar close to the body's centre of mass.",
                mistake: "Rowing up to the chest, which forces the elbows out wide and turns the lift into a rear-delt raise.",
                correct: "Pull the bar to the lower ribs or upper abdomen, keeping it close to the body the whole way up."
            ),
            TechniqueCue(
                id: "feet",
                title: "Hip Hinge",
                intro: "The bent-over row is a hip hinge with a pull layered on top of it.",
                why: "Hinging to roughly 45° above horizontal loads the back muscles doing the pulling without asking the lower back to hold a fully bent-over position under load.",
                mistake: "The torso rising toward vertical on each rep, turning the row into a shrug with momentum.",
                correct: "Push the hips back, soften the knees, and hold the torso still at roughly 45° for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.80),
            MuscleActivation(name: "Middle Trapezius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.76),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.45)
        ],
        stabilisers: ["erector spinae", "hamstrings", "forearms", "core"],
        setup: [
            "Hold the bar with an overhand, shoulder-width grip.",
            "Soften your knees and hinge forward to about 45°.",
            "Brace with a flat back, the bar hanging below your shoulders."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "TORSO STANDING UP",
            correctCue: "45° torso, elbows drive back",
            mistakeCue: "Torso rises, turns into a shrug",
            correctNote: "Holding the torso angle steady keeps the back muscles under tension for the whole set instead of handing the work to momentum.",
            mistakeNote: "Letting the torso rise toward vertical on each rep turns the row into a standing shrug, and the sudden extension puts unplanned load on the lower back."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.16, cx: 0.55, cy: 0.35),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.09, cx: 0.45, cy: 0.30)
        ]
    )

    static let dumbbellRowContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows track to hip", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Row to the hip", "attachment_LatissimusDorsi_L", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Neutral grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Flat back, hinged", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "Squeeze the blades", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "Two dumbbells give each side its own shoulder blade to manage.",
                why: "Retracting both blades at the top keeps the pull symmetrical and puts the back muscles, not the arms, at the end range.",
                mistake: "One or both shoulders staying rounded forward through the set.",
                correct: "Pull both shoulder blades back and together at the top of every rep."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "The elbow path decides whether this is a back exercise or an arm exercise.",
                why: "Driving the elbows back toward the hip keeps the lats in their strongest line of pull.",
                mistake: "Elbows flaring wide or drifting forward, shifting the load onto the shoulders and arms.",
                correct: "Keep the elbows close to the torso and drive them back toward the hip."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "A neutral grip keeps both wrists in a strong, comfortable position through a long range.",
                why: "Palms facing each other let the shoulder move through its natural rowing arc without twisting the forearm.",
                mistake: "Letting the dumbbells drift out to the sides instead of tracking straight up.",
                correct: "Hold a neutral grip and let the arms extend fully at the bottom of every rep."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Row Path",
                intro: "Where the dumbbells finish decides which fibres get the work.",
                why: "Rowing toward the hip keeps the elbows tracking back and biases the lats; rowing toward the chest flares the elbows and biases the rear shoulder.",
                mistake: "Pulling the dumbbells up toward the chest, flaring the elbows out to the sides.",
                correct: "Pull both dumbbells toward the hips, elbows brushing the ribs."
            ),
            TechniqueCue(
                id: "feet",
                title: "Torso Position",
                intro: "The bent-over torso position is the base the whole row is built on.",
                why: "A flat back with the hips hinged back keeps the spine safe and the lats loaded through a full range.",
                mistake: "The back rounding, or the torso swinging upright to help heave the weight up.",
                correct: "Hinge at the hips, flatten the back, and keep the torso still for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.78),
            MuscleActivation(name: "Middle Trapezius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.74),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.46)
        ],
        stabilisers: ["erector spinae", "hamstrings", "forearms", "core"],
        setup: [
            "Hold a dumbbell in each hand, palms facing in.",
            "Soften your knees and hinge forward to about 45°.",
            "Brace with a flat back, the dumbbells hanging below your shoulders."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "USING MOMENTUM",
            correctCue: "Controlled pull, flat back",
            mistakeCue: "Torso jerks to heave the weight",
            correctNote: "A controlled pull with a flat, still torso keeps both sides working evenly and keeps the tension on the back.",
            mistakeNote: "Jerking the torso to swing the dumbbells up borrows momentum from the lower back instead of the lats — the classic way this exercise turns into a back-strain risk."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.16, cx: 0.52, cy: 0.32),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.09, cx: 0.40, cy: 0.28)
        ]
    )

    static let oneArmDumbbellRowContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbow stays close", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Row to hip pocket", "attachment_LatissimusDorsi_L", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Neutral grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Torso stays flat", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "Blade pulls back", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "With one hand braced on the bench, the working shoulder blade has to do its job alone.",
                why: "Retracting the working-side blade at the top isolates the lat instead of just moving the arm.",
                mistake: "The working shoulder staying rounded forward for the whole set.",
                correct: "Pull the working shoulder blade back and down at the top of every rep."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "This is the single biggest factor in whether the lat or the mid-back does the work.",
                why: "Keeping the elbow tucked and driving it toward the hip stays in the lat's plane of motion; letting it flare shifts the work to the rear delt.",
                mistake: "The elbow flaring out away from the body during the pull.",
                correct: "Keep the elbow tucked close and drive it back toward the hip, not the armpit."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "A long dead-hang at the bottom is what makes this row worth doing.",
                why: "Letting the arm hang fully extended stretches the lat before every rep, adding range a barbell row cannot match.",
                mistake: "Stopping the dumbbell short of full extension, cutting the stretch off before it starts.",
                correct: "Hold a neutral grip and let the arm hang fully extended at the bottom of every rep."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Row Path",
                intro: "The target is the hip, not the armpit.",
                why: "Driving the dumbbell toward the hip pocket keeps the pull in the lat's strongest line; aiming for the armpit or chest recruits the rear delt instead.",
                mistake: "Rowing the dumbbell up toward the armpit or chest.",
                correct: "Drive the dumbbell up and back toward the hip pocket."
            ),
            TechniqueCue(
                id: "feet",
                title: "Torso Position",
                intro: "A rotating torso is the easiest way to cheat this exercise.",
                why: "Keeping the torso parallel to the floor and still means the lat, not the lower back or obliques, produces the pull.",
                mistake: "The torso twisting or rising to help heave the dumbbell up.",
                correct: "Keep the torso parallel to the floor and square to the bench for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.87),
            MuscleActivation(name: "Middle Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.55),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.45)
        ],
        stabilisers: ["obliques", "rotator cuff", "forearms"],
        setup: [
            "Put one knee and the same-side hand on a flat bench.",
            "Plant the other foot out to the side on the floor.",
            "Hold the dumbbell at arm's length, back flat and level."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "TORSO ROTATES",
            correctCue: "Row to the hip, torso still",
            mistakeCue: "Torso twists to help the pull",
            correctNote: "Keeping the torso still and square isolates the lat and makes every rep count toward the same muscle.",
            mistakeNote: "Twisting the torso to help the weight up borrows work from the obliques and lower back, and stops the lat from doing the job on its own."
        ),
        glows: [
            .init(DS.activation.opacity(0.60), rx: 0.16, ry: 0.20, cx: 0.45, cy: 0.35),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.08, cx: 0.55, cy: 0.30)
        ]
    )

    static let chestSupportedDumbbellRowContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows drive back", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Row to the hip", "attachment_LatissimusDorsi_L", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Neutral grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Chest pinned", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "No momentum", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "With the torso braced, the shoulder blades are free to move without helping stabilise the body.",
                why: "Retracting the blades fully at the top isolates the back muscles without any assistance from momentum.",
                mistake: "Shrugging the shoulders up toward the ears instead of pulling the blades back and down.",
                correct: "Pull the shoulder blades back and down at the top of every rep."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "The chest support removes momentum, so the elbow path is what's left to get right.",
                why: "Driving the elbows back and slightly up keeps the pull in the lats' and mid-back's strongest line.",
                mistake: "Elbows flaring straight out to the sides instead of tracking back.",
                correct: "Keep the elbows close to the torso and drive them back and up."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "The chest support lets the arms hang completely free at the bottom.",
                why: "A full dead-hang at the bottom stretches the lats before every rep — the main advantage of bracing the chest.",
                mistake: "Cutting the bottom of the rep short instead of letting the arms fully extend.",
                correct: "Hold a neutral grip and let both arms hang fully extended at the bottom."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Row Path",
                intro: "The target is the hip, same as any row that isolates the lats.",
                why: "Rowing toward the hip keeps the elbows tracking back rather than flaring wide.",
                mistake: "Rowing up toward the chest, which flares the elbows and shifts the work to the rear delts.",
                correct: "Pull both dumbbells toward the hips, elbows brushing the ribs."
            ),
            TechniqueCue(
                id: "feet",
                title: "Chest Contact",
                intro: "The entire point of this row is what the chest support takes away: momentum.",
                why: "Keeping the chest pinned to the pad removes any help from the lower back or legs, so the back muscles do all the work.",
                mistake: "The chest lifting off the pad to help swing the weight up.",
                correct: "Keep the chest in contact with the pad for the whole set, even on the last hard reps."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.76),
            MuscleActivation(name: "Middle Trapezius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.78),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["rotator cuff", "forearms"],
        setup: [
            "Set an incline bench to about 30–45°.",
            "Lie chest-down on it with your feet on the floor.",
            "Let the dumbbells hang straight down, palms facing in."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "CHEST LIFTS OFF THE PAD",
            correctCue: "Chest pinned, elbows drive back",
            mistakeCue: "Chest lifts off the pad",
            correctNote: "Keeping the chest pinned to the pad removes momentum entirely, so every ounce of force comes from the back muscles.",
            mistakeNote: "Letting the chest lift off the pad brings the lower back and momentum back into the lift, defeating the whole point of a chest-supported row."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.16, cx: 0.52, cy: 0.32),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.09, cx: 0.40, cy: 0.28)
        ]
    )

    static let pullUpContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows down and back", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Chest to the bar", "chest", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Wide overhand grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "No kipping", "pelvis", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "Set blades first", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "The pull-up starts before the elbows bend at all.",
                why: "Depressing the shoulder blades first — 'packing' the shoulder — creates a stable base for the lats to pull from.",
                mistake: "Hanging in a fully shrugged position and pulling straight from there.",
                correct: "Pull the shoulder blades down and back before bending the elbows, then pull."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "The overhand grip naturally pulls the elbows out to the sides — that's fine, within reason.",
                why: "Driving the elbows down and back, finishing wide, keeps the lats and lower traps in their strongest line for this grip.",
                mistake: "Elbows drifting forward, turning the pull into mostly a biceps curl.",
                correct: "Drive the elbows down and back, letting them travel slightly out to the sides."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "Grip width and orientation set the whole exercise.",
                why: "An overhand grip just outside the shoulders emphasises shoulder adduction and hits the lats through a wide range.",
                mistake: "A grip so wide the shoulders can't move through a full range.",
                correct: "Take an overhand grip a little wider than the shoulders."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Range of Motion",
                intro: "How high is high enough is decided by the chest, not the chin.",
                why: "Driving the chest toward the bar ensures the shoulder finishes fully adducted, getting the lats through their complete range.",
                mistake: "Craning the neck to get the chin over the bar while the shoulders barely move.",
                correct: "Pull until the chest, not just the chin, approaches the bar."
            ),
            TechniqueCue(
                id: "feet",
                title: "Body Control",
                intro: "A strict pull-up is a still one from the hips down.",
                why: "Keeping the legs and hips still means the lats and arms do all the work, instead of momentum from a leg swing.",
                mistake: "Kipping — swinging the legs and hips to sling the body up and over the bar.",
                correct: "Keep the legs still, or crossed at the ankles, and let the upper body do all the work."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.55),
            MuscleActivation(name: "Middle Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.48)
        ],
        stabilisers: ["lower trapezius", "forearms", "core"],
        setup: [
            "Grip the bar overhand, slightly wider than shoulder-width.",
            "Hang with straight arms and your shoulders pulled down.",
            "Cross your ankles and brace your core."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "KIPPING SWING",
            correctCue: "Controlled pull, chest to the bar",
            mistakeCue: "Legs kip to swing the body up",
            correctNote: "A strict, controlled pull keeps continuous tension on the lats and arms through the whole rep.",
            mistakeNote: "Kipping uses a leg swing to sling the body past the sticking point, turning a back exercise into a momentum trick that barely loads the lats."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.18, ry: 0.22, cx: 0.45, cy: 0.35),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.08, cx: 0.55, cy: 0.30)
        ]
    )

    static let chinUpContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows stay close", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Chest to the bar", "chest", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Underhand grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "No kipping", "pelvis", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "Set blades first", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "Same starting rule as the pull-up: set the shoulder before bending the elbow.",
                why: "Depressing the shoulder blades first gives the lats and biceps a stable base to pull from.",
                mistake: "Starting every rep from a fully shrugged, passive hang.",
                correct: "Pull the shoulder blades down and back before the elbows bend."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "The underhand grip changes the elbow path from the pull-up's.",
                why: "Keeping the elbows tucked close to the torso matches the shoulder extension this grip is built for, and lets the biceps assist more.",
                mistake: "Letting the elbows flare out wide, which fights the underhand grip's natural path.",
                correct: "Keep the elbows tucked close to the torso as they bend."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "The supinated grip is what separates a chin-up from a pull-up.",
                why: "Palms facing the body put the biceps in their strongest position, which is why chin-ups usually feel easier at the same bodyweight.",
                mistake: "A grip too wide for a true underhand position, losing the biceps' mechanical advantage.",
                correct: "Take an underhand grip roughly shoulder-width apart."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Range of Motion",
                intro: "Full range is what makes a chin-up worth doing.",
                why: "Starting from a full dead-hang and finishing with the chest near the bar works the lats through their complete length.",
                mistake: "Short, bouncy reps that never reach a full hang or a full top position.",
                correct: "Start from a dead hang and pull until the chest approaches the bar."
            ),
            TechniqueCue(
                id: "feet",
                title: "Body Control",
                intro: "Control from the hips down is what keeps this a back-and-arms exercise.",
                why: "Still legs and hips mean the pulling muscles do all the work instead of a body swing.",
                mistake: "Swinging the legs to build momentum into the bar.",
                correct: "Keep the legs still and let the arms and back do the pulling."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.85),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "HIGH ACTIVATION", fraction: 0.68)
        ],
        stabilisers: ["lower trapezius", "forearms", "core"],
        setup: [
            "Grip the bar underhand, about shoulder-width apart.",
            "Hang with straight arms and your shoulders pulled down.",
            "Cross your ankles and brace your core."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "PARTIAL RANGE",
            correctCue: "Full hang to chin over the bar",
            mistakeCue: "Stopping short at the top or bottom",
            correctNote: "A full range, from a dead hang to chin over the bar, works the lats and biceps through their complete length.",
            mistakeNote: "Cutting the range short at either end trims the hardest — and most productive — parts of the rep."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.18, ry: 0.22, cx: 0.44, cy: 0.35),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.40, cy: 0.55)
        ]
    )

    static let latPulldownContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows down and back", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Bar to upper chest", "chest", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Wide overhand grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Thighs locked", "thigh_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("spine", "Slight lean back", "spine", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "spine",
                title: "Torso Position",
                intro: "A little lean is fine; a lot is cheating.",
                why: "A slight 5–10° backward lean keeps the pull in line with the torso without turning the exercise into a standing row.",
                mistake: "Rocking the torso far back on every rep to use body weight instead of the lats.",
                correct: "Keep the chest up and lean back only slightly, then hold that position for the whole set."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "This is the single biggest factor in whether the lats or the arms do the work.",
                why: "Driving the elbows down and back, not straight down, keeps the shoulder moving through the lat's actual line of pull.",
                mistake: "Elbows flaring out to the sides as the bar comes down.",
                correct: "Drive the elbows down and back, brushing close to the sides of the torso."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "A wide grip is the classic lat pulldown setup for a reason.",
                why: "A grip wider than shoulder width shortens the range the arms travel and biases the lats over the arms.",
                mistake: "A grip so narrow or so wide it turns the pull into mostly a biceps or a rear-delt exercise.",
                correct: "Take a wide overhand grip, hands a comfortable amount outside the shoulders."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "Where the bar finishes decides whether the shoulder gets a safe range or a risky one.",
                why: "Pulling to the upper chest, above the sternum, keeps the shoulder in a strong, supported position.",
                mistake: "Pulling the bar behind the neck, which forces the shoulder into a vulnerable, over-rotated position.",
                correct: "Pull the bar down in front of the body to the upper chest, just below the collarbone."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base Position",
                intro: "The thigh pads exist to stop the body from being pulled off the seat.",
                why: "Thighs locked firmly under the pads let the lats pull the bar down instead of pulling the body up.",
                mistake: "Sliding forward on the seat as the weight gets heavy.",
                correct: "Set the thigh pads snug against the thighs before the first rep."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.85),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50),
            MuscleActivation(name: "Middle Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.42)
        ],
        stabilisers: ["lower trapezius", "rotator cuff", "forearms"],
        setup: [
            "Adjust the thigh pad so your legs are locked in.",
            "Take a wide overhand grip on the bar.",
            "Sit down tall with your arms straight overhead."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "PULLING BEHIND THE NECK",
            correctCue: "Bar to upper chest",
            mistakeCue: "Bar pulled behind the neck",
            correctNote: "Pulling to the front, to the upper chest, keeps the shoulder in a strong, naturally supported position through the whole rep.",
            mistakeNote: "Pulling the bar behind the neck forces the shoulder into extreme, unsupported external rotation — a well-known cause of shoulder impingement."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.18, ry: 0.22, cx: 0.52, cy: 0.38),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.08, cx: 0.45, cy: 0.30)
        ]
    )

    static let closeGripLatPulldownContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows track close", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Handle to upper chest", "chest", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Neutral, close grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Thighs locked", "thigh_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("spine", "Slight lean back", "spine", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "spine",
                title: "Torso Position",
                intro: "Same rule as the wide pulldown: a small lean, held steady.",
                why: "A slight backward lean keeps the pull aligned without letting the body swing to move the weight.",
                mistake: "Using a big backward lean to muscle the handle down.",
                correct: "Keep the chest up, lean back only slightly, and hold it there."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "The closer grip changes the elbow path from the wide pulldown.",
                why: "With a neutral or close grip, the elbows track close to the torso, which lengthens the lat's range at the top of the rep.",
                mistake: "Letting the elbows flare out, which shortens the range and shifts load to the arms.",
                correct: "Keep the elbows close to the torso as they drive down and back."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "A closer, often neutral grip is what defines this variation.",
                why: "A neutral, shoulder-width grip lets the shoulder adduct through a longer range than a wide bar allows.",
                mistake: "A grip wide enough that it behaves like the standard wide-grip pulldown.",
                correct: "Take a neutral or close grip, roughly shoulder-width apart."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Handle Path",
                intro: "The target is the same as any pulldown: the upper chest, not the neck.",
                why: "Pulling to the upper chest keeps the shoulder in a strong position through the longer range this grip allows.",
                mistake: "Pulling too low, past the chest, which adds nothing but strain.",
                correct: "Pull the handle down to the upper chest and control it back up."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base Position",
                intro: "The thigh pads matter even more with a heavier stretch on the lats.",
                why: "A locked base means the extra range this grip offers comes from the shoulder, not from the body rising off the seat.",
                mistake: "Rising off the seat as the handle is pulled down.",
                correct: "Set the thigh pads snug and keep the hips on the seat for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.87),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.55)
        ],
        stabilisers: ["lower trapezius", "rotator cuff", "forearms"],
        setup: [
            "Adjust the thigh pad so your legs are locked in.",
            "Take a close grip, hands about shoulder-width apart.",
            "Sit down tall with your arms straight overhead."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ELBOWS FLARE OUT",
            correctCue: "Elbows track close",
            mistakeCue: "Elbows flare out to the sides",
            correctNote: "Keeping the elbows close lengthens the lat's range at the top of the pull, which is the main reason to choose this grip.",
            mistakeNote: "Letting the elbows flare out shortens the range and turns the exercise back into a wide-grip pulldown without the wide bar."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.18, ry: 0.22, cx: 0.52, cy: 0.38),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.08, cx: 0.45, cy: 0.30)
        ]
    )

    static let seatedCableRowContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows drive back", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Handle to the abdomen", "attachment_LatissimusDorsi_L", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Neutral grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Knees soft", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "Set blades first", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "The seated row rewards setting the shoulder before the arms ever move.",
                why: "Retracting the shoulder blades first, before bending the elbows, builds a stable platform for the lats to pull from.",
                mistake: "Starting the pull with the arms, then trying to retract the blades afterward.",
                correct: "Retract the shoulder blades first, then bend the elbows to finish the pull."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "Driving with the elbows, not curling with the arms, is what keeps this a back exercise.",
                why: "Driving the elbows straight back keeps the humerus and forearm at roughly 90° and limits how much the biceps take over.",
                mistake: "Curling the handle in with the forearms before the elbows even move.",
                correct: "Lead the pull with the elbows, driving them straight back past the torso."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "A neutral grip suits the seated row's straight-back pulling line.",
                why: "Palms facing each other let the elbow track straight back without twisting the wrist.",
                mistake: "Cutting the stretch short at the front instead of reaching the arms fully forward.",
                correct: "Hold a neutral grip and let the arms extend fully forward between reps."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Row Path",
                intro: "The target sits at the upper abdomen, not the chest.",
                why: "Pulling to the upper abdomen keeps the elbows tracking back along the torso rather than flaring up toward the chest.",
                mistake: "Pulling the handle up to the chest, which flares the elbows and shifts the work to the rear delts.",
                correct: "Pull the handle to the upper abdomen, elbows brushing the ribs."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base Position",
                intro: "A braced lower body is what lets the upper body move safely.",
                why: "Soft knees and firmly braced feet on the platform stop the legs from taking over the pull.",
                mistake: "Locking the knees straight, which transfers load into the lower back on every rep.",
                correct: "Keep the knees slightly bent and the feet pressed firmly into the platform."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.80),
            MuscleActivation(name: "Middle Trapezius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.74),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.42)
        ],
        stabilisers: ["erector spinae", "forearms", "core"],
        setup: [
            "Sit on the bench with your feet braced on the foot plate.",
            "Bend your knees slightly and grab the handle.",
            "Sit tall with your arms extended and your chest up."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "EXCESSIVE BACK LEAN",
            correctCue: "Chest up, slight 10–15° lean",
            mistakeCue: "Torso rocks far back and forward",
            correctNote: "A small, controlled lean keeps tension on the back muscles through the whole range without recruiting the spinal erectors to swing the weight.",
            mistakeNote: "Rocking the torso far back and forward turns the row into a swinging motion that trades back-muscle tension for lower-back strain."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.16, cx: 0.55, cy: 0.35),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.09, cx: 0.45, cy: 0.30)
        ]
    )

    static let straightArmPulldownContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Soft elbow lock", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Sweep down to thighs", "thigh_L", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Shoulder-width grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Lean forward", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "Blades set back", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "With the elbows locked out, the shoulder blades carry the whole exercise.",
                why: "Setting the blades down and back before pulling — 'proud chest' — creates the stable base the lats pull against.",
                mistake: "Letting the shoulders round forward as the cable resists at the top.",
                correct: "Set the shoulder blades down and back, chest lifted, before starting the pull."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Lock",
                intro: "The one rule that defines this exercise: the elbows do not bend.",
                why: "A fixed, soft-locked elbow turns the arms into rigid levers, so the lats — not the triceps or biceps — produce all the force.",
                mistake: "The elbows bending as the weight gets heavy, quietly turning the pulldown into a triceps pushdown.",
                correct: "Fix a slight, comfortable bend in the elbows and hold that exact angle for the whole set."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "Grip width barely matters here — the arms don't bend either way.",
                why: "A shoulder-width overhand grip on the bar keeps the shoulders working evenly.",
                mistake: "An uneven grip that lets one arm dominate the pull.",
                correct: "Take an even, shoulder-width overhand grip on the bar or rope."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "The bar traces a wide arc from overhead to the thighs.",
                why: "Sweeping the straight arms down in an arc, finishing near the thighs, takes the lats through a long range of shoulder extension a bent-elbow pull cannot match.",
                mistake: "Pushing the bar straight down toward the floor instead of sweeping it in an arc.",
                correct: "Sweep the arms down and back in an arc until the hands reach the thighs."
            ),
            TechniqueCue(
                id: "feet",
                title: "Stance",
                intro: "A small forward lean gives the arc room to travel.",
                why: "Leaning slightly forward from the hips lets the straight arms sweep through their full arc without the cable pulling the body off balance.",
                mistake: "Standing bolt upright, which shortens the arc and cuts the range short.",
                correct: "Take a stable stance and lean slightly forward from the hips."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.85),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.35)
        ],
        stabilisers: ["lower trapezius", "forearms", "core"],
        setup: [
            "Set the pulley high and grip the bar with both hands.",
            "Step back and hinge slightly at the hips.",
            "Start with straight arms at shoulder height, elbows soft."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ELBOWS BEND ON THE PULL",
            correctCue: "Rigid arms, the lats do the work",
            mistakeCue: "Elbows bend, turning it into a pushdown",
            correctNote: "Locking the elbow angle turns the arm into a rigid lever, isolating the lats through a long range of shoulder extension.",
            mistakeNote: "Letting the elbows bend recruits the triceps and turns the movement into a pushdown, taking tension away from the lats it's meant to isolate."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.24, cx: 0.55, cy: 0.35),
            .init(DS.activationSoft.opacity(0.26), rx: 0.10, ry: 0.08, cx: 0.65, cy: 0.30)
        ]
    )

    static let tBarRowContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows tuck in", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Bar to lower chest", "attachment_LatissimusDorsi_L", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Neutral grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Hips hinged", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "Squeeze at the top", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "The T-bar's fixed path still needs the shoulder blades to finish the job.",
                why: "Squeezing the blades together at the top of every rep is what separates a full row from a half-hearted one.",
                mistake: "Stopping the pull as soon as the elbows pass the torso, without finishing the squeeze.",
                correct: "Pull until the shoulder blades squeeze together at the top, then lower under control."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "The landmine-style bar fixes the path, but the elbows still decide the target.",
                why: "Tucking the elbows to the sides and driving them back keeps the pull in the lats' and mid-back's strongest line.",
                mistake: "Elbows flaring wide, turning the pull into a rear-delt raise.",
                correct: "Keep the elbows tucked to the sides as they drive back."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "The handles set a fixed, neutral grip width.",
                why: "A neutral grip on the handles keeps both wrists in a strong position through the pull.",
                mistake: "Letting the shoulders round forward to reach the handles at the bottom.",
                correct: "Take the handles with a neutral grip and set the shoulders before pulling."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "The bar should travel straight up to the lower chest.",
                why: "Pulling to the lower chest or upper abdomen keeps the elbows tracking back rather than flaring wide.",
                mistake: "Only pulling the bar a few inches, well short of the torso.",
                correct: "Pull the bar all the way to the lower chest, then lower it under control."
            ),
            TechniqueCue(
                id: "feet",
                title: "Torso Position",
                intro: "The T-bar row is still a hip hinge underneath the pulling motion.",
                why: "Hinging at the hips with a flat back keeps the lower back safe while the arms and back do the pulling.",
                mistake: "Rounding the lower back to reach the handles or to heave the weight up.",
                correct: "Hinge at the hips, keep the chest up and the back flat for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.78),
            MuscleActivation(name: "Middle Trapezius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.78),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.45)
        ],
        stabilisers: ["erector spinae", "hamstrings", "forearms", "core"],
        setup: [
            "Straddle the bar with feet about shoulder-width apart.",
            "Hinge to about 45° and grip the handle just below the plates.",
            "Brace with a flat back and your arms extended."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ROUNDED LOWER BACK",
            correctCue: "Hips hinged",
            mistakeCue: "Lower back rounds to move the weight",
            correctNote: "A hinged hip and a flat back keep the spine safe while the back muscles handle the actual pulling.",
            mistakeNote: "Rounding the lower back to add extra heave to the pull is one of the most common ways this exercise causes lower-back strain."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.16, cx: 0.50, cy: 0.32),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.09, cx: 0.40, cy: 0.28)
        ]
    )

    static let chestSupportedRowMachineContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows drive back", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "Handles to the ribs", "attachment_LatissimusDorsi_L", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Chest pinned", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "No leg drive", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("scapula", "Squeeze the blades", "scapula_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "scapula",
                title: "Scapular Position",
                intro: "The machine removes balance demands so the shoulder blades can do their job in isolation.",
                why: "Squeezing the blades together at the back of every rep is what turns the pull into a full back contraction.",
                mistake: "Stopping short and never fully retracting the shoulder blades.",
                correct: "Pull until the shoulder blades squeeze together, then return under control."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "The machine fixes the handle path, but the elbow still decides the target.",
                why: "Driving the elbows back and slightly up keeps the pull in the lats' and mid-back's strongest line.",
                mistake: "Elbows flaring straight out to the sides instead of tracking back.",
                correct: "Keep the elbows close and drive them back and up."
            ),
            TechniqueCue(
                id: "grip",
                title: "Chest Contact",
                intro: "The chest pad is the entire reason this variation exists.",
                why: "Keeping the chest pinned to the pad removes any help from the lower back or legs.",
                mistake: "The chest lifting off the pad to help move the weight.",
                correct: "Keep the chest in contact with the pad for every rep, even the hard ones."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Handle Path",
                intro: "The target is the ribs, not the chest or the neck.",
                why: "Pulling the handles to the ribs keeps the elbows tracking back rather than flaring wide.",
                mistake: "Pulling too high, toward the shoulders, which flares the elbows out.",
                correct: "Pull the handles to the ribs, elbows brushing the sides."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base Position",
                intro: "A still lower body keeps every rep honest.",
                why: "Feet planted and still means the back muscles, not the legs, generate the pulling force.",
                mistake: "Pushing through the legs against the seat to help start the pull.",
                correct: "Keep the feet planted and the lower body still for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Middle Trapezius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.78),
            MuscleActivation(name: "Latissimus Dorsi", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.62),
            MuscleActivation(name: "Posterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.56),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.38)
        ],
        stabilisers: ["rotator cuff", "forearms"],
        setup: [
            "Set the seat so the handles line up with your lower chest.",
            "Sit with your chest against the pad, feet planted.",
            "Reach forward and grab the handles with straight arms."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SHRUGGING THE PULL",
            correctCue: "Elbows drive back, blades squeeze",
            mistakeCue: "Shoulders shrug instead of blades squeezing",
            correctNote: "Driving the elbows back while the shoulder blades squeeze keeps the tension on the mid-back and lats.",
            mistakeNote: "Shrugging the shoulders up toward the ears lets the traps take over from the lats and rhomboids, cutting the exercise's main benefit."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.16, cx: 0.48, cy: 0.35),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.09, cx: 0.38, cy: 0.30)
        ]
    )

    static let highRowMachineContent = ExerciseContent(
        annotations: [
            backAnnotation("elbow", "Elbows down and back", "forearm_L", slot: backSlotElbow, leader: 52),
            backAnnotation("barpath", "To the upper chest", "chest", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Wide overhand grip", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Chest on the pad", "thigh_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("spine", "No leaning back", "spine", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "spine",
                title: "Torso Position",
                intro: "The chest pad exists to keep the torso from helping the pull.",
                why: "A still, upright torso against the pad isolates the back muscles from any lower-back or momentum assistance.",
                mistake: "Leaning back away from the pad to help muscle the handles down.",
                correct: "Keep the chest against the pad and the torso still for the whole set."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Path",
                intro: "Similar path to a lat pulldown, just from a fixed seated angle.",
                why: "Driving the elbows down and back keeps the shoulder moving through the lat's actual line of pull.",
                mistake: "Elbows flaring out to the sides as the handles come down.",
                correct: "Drive the elbows down and back, close to the sides of the torso."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "A wide grip on this machine mirrors the wide-grip pulldown.",
                why: "A grip wider than shoulder width biases the lats over the arms through the pull.",
                mistake: "A grip narrow enough to shift the work onto the arms.",
                correct: "Take a wide overhand grip on the handles."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Handle Path",
                intro: "The target is the upper chest, same principle as any pulldown.",
                why: "Pulling to the upper chest keeps the shoulder in a strong, supported position.",
                mistake: "Pulling the handles too high, toward the face or neck.",
                correct: "Pull the handles down and in toward the upper chest."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base Position",
                intro: "The seat and chest pad set the base for this pull.",
                why: "Thighs and chest both braced against the machine keep the body still so the back does the pulling.",
                mistake: "Sliding around on the seat as the weight gets heavier.",
                correct: "Set the seat height so the chest pad and thigh pads both sit snugly before starting."
            )
        ],
        activation: [
            MuscleActivation(name: "Latissimus Dorsi", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.82),
            MuscleActivation(name: "Middle Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.55),
            MuscleActivation(name: "Biceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.42)
        ],
        stabilisers: ["lower trapezius", "rotator cuff", "forearms"],
        setup: [
            "Adjust the seat and thigh pad so your legs are locked in.",
            "Reach up and grab the handles with straight arms.",
            "Sit tall, chest up and shoulders down."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "LEANING BACK",
            correctCue: "Chest on the pad",
            mistakeCue: "Torso leans back to move the weight",
            correctNote: "Keeping the chest against the pad isolates the lats and traps from any assistance by the lower back.",
            mistakeNote: "Leaning back away from the pad turns the pull into a standing-row-like motion, adding momentum instead of muscle."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.18, ry: 0.22, cx: 0.52, cy: 0.40),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.08, cx: 0.44, cy: 0.32)
        ]
    )

    static let backExtensionContent = ExerciseContent(
        annotations: [
            backAnnotation("spine", "Neutral spine", "spine", slot: backSlotElbow, leader: 52),
            backAnnotation("hips", "Hinge at the hips", "pelvis", slot: backSlotPath, leader: 44),
            backAnnotation("grip", "Cross arms on chest", "hand_L", slot: backSlotGrip, side: .trailing, leader: 34),
            backAnnotation("feet", "Ankles locked", "foot_L", slot: backSlotBase, side: .trailing, leader: 40),
            backAnnotation("thigh", "Hips at pad edge", "thigh_L", slot: backSlotScapula, side: .trailing, leader: 46)
        ],
        cues: [
            TechniqueCue(
                id: "thigh",
                title: "Bench Position",
                intro: "Where the hips sit on the pad decides whether the hips or the lower back do the hinging.",
                why: "Aligning the hip crease with the top edge of the pad lets the hips hinge freely through their full range.",
                mistake: "Sitting too far forward or back, so the pad blocks the hip hinge and the lower back compensates.",
                correct: "Adjust the pad so the hip crease lines up with its top edge before starting."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Hinge",
                intro: "This is a hip hinge exercise wearing a lower-back exercise's name.",
                why: "Sending the hips back and folding forward from there loads the glutes and hamstrings, protecting the lower back from doing the work alone.",
                mistake: "Folding from the lower back with the hips barely moving.",
                correct: "Hinge at the hips first, letting the torso lower as one straight line from the hips."
            ),
            TechniqueCue(
                id: "grip",
                title: "Arm Position",
                intro: "Arm position is a simple way to change how hard the exercise is.",
                why: "Crossing the arms over the chest is the easiest version; holding them behind the head or extended overhead adds a longer lever and more load.",
                mistake: "Using the arms to yank the body up instead of the hips and back.",
                correct: "Choose an arm position that matches the load you want, and keep it still through the set."
            ),
            TechniqueCue(
                id: "spine",
                title: "Spine Position",
                intro: "The top of the rep is a straight line, not an arch.",
                why: "Finishing with the shoulders, hips and ankles in one straight line works the glutes and spinal erectors without hyperextending the spine.",
                mistake: "Arching the lower back past neutral at the top to squeeze out a bit more range.",
                correct: "Raise until the body forms a straight line, then stop — do not arch beyond it."
            ),
            TechniqueCue(
                id: "feet",
                title: "Foot Position",
                intro: "The ankle pads are the anchor the whole hinge works against.",
                why: "Locking the ankles snugly under the pads keeps the lower body still so the hips and back control the movement.",
                mistake: "Feet loose in the pads, letting the legs shift during the set.",
                correct: "Set the ankles snugly under the pads before starting the first rep."
            )
        ],
        activation: [
            MuscleActivation(name: "Erector Spinae", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.85),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.65),
            MuscleActivation(name: "Hamstrings", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50)
        ],
        stabilisers: ["adductors", "core"],
        setup: [
            "Set the hip pad just below your hip bones.",
            "Lock your heels under the ankle roller.",
            "Cross your arms over your chest, body in a straight line."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HYPEREXTENDING THE SPINE",
            correctCue: "Straight line at the top",
            mistakeCue: "Lower back arches past neutral",
            correctNote: "Stopping at a straight line from shoulders to ankles works the glutes and erectors without asking the spine to hyperextend.",
            mistakeNote: "Arching past a straight line at the top loads the lumbar spine in extension, which is exactly the position this exercise should be protecting."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.28, cx: 0.42, cy: 0.30),
            .init(DS.activationSoft.opacity(0.28), rx: 0.12, ry: 0.10, cx: 0.48, cy: 0.40)
        ]
    )

    // MARK: - Legs content (2026-09-23)
    //
    // Label points below were projected from the real rig through each
    // exercise's own `modelByExercise` framing at a representative loaded
    // frame (bottom of the squat/lunge/hinge, or the machine's working
    // position) using `Tools/model-pipeline/joint_probe.py`, then nudged
    // outward into open space the same way the bench press's labels were —
    // close to, not exactly on, the joint they track. The six standing
    // free-weight lifts (Back Squat, Front Squat, Goblet Squat, Smith
    // Machine Squat, Sissy Squat, Romanian Deadlift) share a similar
    // symmetric front-on silhouette, so they reuse the same five-slot ring
    // shape: two top corners, two mid corners, one bottom centre. The two
    // lunges are asymmetric (one leg forward) so their labels follow the
    // actual leg positions instead. The three machines (Leg Press, Hack
    // Squat, Leg Extension) are framed three-quarter like the chest
    // machines, so their labels are bespoke to that camera angle.

    static let backSquatContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "bar", label: "Bar high on the traps",
                          labelPoint: CGPoint(x: 0.22, y: 0.14),
                          labelSide: .trailing, leaderLength: 58, joint: "chest"),
            CueAnnotation(cueID: "brace", label: "Brace your core",
                          labelPoint: CGPoint(x: 0.78, y: 0.32),
                          leaderLength: 46, joint: "spine"),
            CueAnnotation(cueID: "knee", label: "Knees track over toes",
                          labelPoint: CGPoint(x: 0.86, y: 0.50),
                          leaderLength: 42, joint: "patella_L"),
            CueAnnotation(cueID: "depth", label: "Hip crease below the knee",
                          labelPoint: CGPoint(x: 0.14, y: 0.68),
                          labelSide: .trailing, leaderLength: 46, joint: "pelvis"),
            CueAnnotation(cueID: "drive", label: "Drive through the whole foot",
                          labelPoint: CGPoint(x: 0.50, y: 0.87),
                          labelSide: .trailing, leaderLength: 38, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "bar",
                title: "Bar Position",
                intro: "Where the bar sits on the back changes how the torso has to angle to stay balanced over it.",
                why: "A high-bar position sits the bar over the middle of the foot with a more upright torso, keeping the quads in the primary role this variation is built for.",
                mistake: "Letting the bar drift down onto the rear deltoids, which forces a much deeper forward lean and turns the lift into a de facto low-bar squat.",
                correct: "Set the bar across the traps just below the base of the neck and keep the chest tall through the whole rep."
            ),
            TechniqueCue(
                id: "brace",
                title: "Core Bracing",
                intro: "A stiff torso is what lets the hips and knees move heavy weight safely.",
                why: "Bracing the abs and lower back before the descent turns the trunk into a rigid column that transfers force from the legs to the bar instead of losing it to a bending spine.",
                mistake: "Letting the belly relax and the chest collapse forward as the weight gets heavy, rounding the lower back under load.",
                correct: "Take a full breath into the belly, brace hard as if bracing for a punch, and hold that tension from unrack to rerack."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Tracking",
                intro: "The knees have to travel forward and out together with the toes, not independently.",
                why: "Tracking in line with the second toe keeps the load centred in the knee joint; letting the knees drift inward twists the joint and shifts stress onto the inner knee ligaments.",
                mistake: "Knees caving inward, especially out of the bottom of a hard rep — a classic sign of the hips giving way to the load.",
                correct: "Actively push the knees out over the toes throughout the descent and the drive back up."
            ),
            TechniqueCue(
                id: "depth",
                title: "Squat Depth",
                intro: "How deep the squat goes decides which muscles do the work.",
                why: "Reaching at least hip-crease-below-knee depth recruits the glutes and the full range of the quadriceps; stopping short trains only the top portion of the lift.",
                mistake: "Cutting the squat short at quarter or half depth, often to handle more weight than full range allows.",
                correct: "Sit down and back until the hip crease drops just below the top of the knee, then drive back up."
            ),
            TechniqueCue(
                id: "drive",
                title: "Foot Drive",
                intro: "The feet are the base the entire lift pushes against.",
                why: "Driving through the whole foot — weight balanced across heel and midfoot — keeps the bar path vertical and the hips from shooting up before the chest.",
                mistake: "Rising onto the toes or letting the weight shift forward onto the front of the foot, which pulls the torso forward and stresses the lower back.",
                correct: "Screw the feet into the floor and push through the whole foot evenly as you stand, keeping the heels down."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.90),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.62),
            MuscleActivation(name: "Erector Spinae", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.45)
        ],
        stabilisers: ["adductors", "hamstrings", "calves", "core"],
        setup: [
            "Set the bar on your upper traps, hands just outside the shoulders.",
            "Step back and set your feet shoulder-width, toes slightly out.",
            "Take a deep breath and brace, chest tall."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "KNEES CAVING IN",
            correctCue: "Knees track over toes",
            mistakeCue: "Knees collapse inward",
            correctNote: "Pushing the knees out over the toes keeps the load centred in the joint and lets the glutes and hip abductors share the work.",
            mistakeNote: "Letting the knees fall inward under load twists the knee joint and shifts stress onto the ACL and inner knee — one of the most common and riskiest squat faults."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.22, ry: 0.14, cx: 0.50, cy: 0.62),
            .init(DS.activationSoft.opacity(0.30), rx: 0.14, ry: 0.10, cx: 0.50, cy: 0.50)
        ]
    )

    static let frontSquatContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "rack", label: "Bar rests on the shoulders",
                          labelPoint: CGPoint(x: 0.80, y: 0.14),
                          leaderLength: 55, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows driven up high",
                          labelPoint: CGPoint(x: 0.20, y: 0.32),
                          labelSide: .trailing, leaderLength: 55, joint: "hand_R"),
            CueAnnotation(cueID: "torso", label: "Torso stays upright",
                          labelPoint: CGPoint(x: 0.80, y: 0.50),
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "knee", label: "Knees track forward",
                          labelPoint: CGPoint(x: 0.84, y: 0.68),
                          leaderLength: 38, joint: "patella_L"),
            CueAnnotation(cueID: "depth", label: "Hip crease below the knee",
                          labelPoint: CGPoint(x: 0.16, y: 0.86),
                          labelSide: .trailing, leaderLength: 42, joint: "pelvis")
        ],
        cues: [
            TechniqueCue(
                id: "rack",
                title: "Rack Position",
                intro: "The bar rests on the front of the shoulders, held up by the fingertips more than gripped in the palm.",
                why: "A stable shelf made by the raised collarbones and front delts keeps the bar from rolling forward without the wrists having to bear the load.",
                mistake: "Trying to grip the bar tightly in the hands like a curl, which fights the wrist and lets the elbows drop.",
                correct: "Loosen the fingers under the bar and let it rest on the shoulders — the hands are there to steady it, not hold it."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Height",
                intro: "Elbow height is what keeps the bar from sliding off the front rack.",
                why: "Driving the elbows up toward parallel with the floor keeps the upper arm supporting the bar's weight instead of the wrists.",
                mistake: "Elbows dropping as the squat gets heavy or deep, tipping the bar forward off the shoulders.",
                correct: "Point the elbows up and slightly forward before the first rep and keep lifting them through the whole set."
            ),
            TechniqueCue(
                id: "torso",
                title: "Torso Angle",
                intro: "A front squat is built to be lifted with a near-vertical torso.",
                why: "Any forward lean tips the bar off the front rack, so the torso has to stay upright for the whole rep — exactly why this variation hits the quads so directly.",
                mistake: "Leaning forward at the bottom the way a back squat allows, which the front rack position cannot tolerate.",
                correct: "Keep the chest lifted and the torso close to vertical from the top of the rep to the bottom."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Travel",
                intro: "The knees travel further forward here than in a back squat, and that is normal.",
                why: "An upright torso shifts more of the work — and the knee's forward travel — onto the quadriceps, which is the point of the front-loaded position.",
                mistake: "Trying to keep the shins vertical like a back squat, which just tips the torso forward and drops the bar off the rack.",
                correct: "Let the knees track forward over the toes as the hips sink, keeping the weight balanced through the whole foot."
            ),
            TechniqueCue(
                id: "depth",
                title: "Squat Depth",
                intro: "Depth is still measured the same way as any squat.",
                why: "Reaching hip-crease-below-knee depth trains the full range of the quadriceps this variation is meant to load.",
                mistake: "Stopping high to protect the bar's balance rather than because the hips ran out of range.",
                correct: "Sink until the hip crease drops just below the knee, keeping the elbows up the whole way down."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.94),
            MuscleActivation(name: "Erector Spinae", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["upper back", "adductors", "core"],
        setup: [
            "Rest the bar on the front of your shoulders, close to the throat.",
            "Fingertips under the bar, elbows pointing forward and high.",
            "Feet shoulder-width, toes slightly out."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ELBOWS DROPPING",
            correctCue: "Elbows driven up high",
            mistakeCue: "Elbows sink, bar rolls forward",
            correctNote: "Keeping the elbows lifted toward parallel holds the bar securely on the shoulders and keeps the torso upright through the whole rep.",
            mistakeNote: "Once the elbows drop, the bar starts to roll off the front rack, and the torso instinctively leans forward to catch it — turning a front squat into an unstable, unsupported lift."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.14, cx: 0.50, cy: 0.58),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.09, cx: 0.50, cy: 0.42)
        ]
    )

    static let gobletSquatContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "hold", label: "Cup the weight at the chest",
                          labelPoint: CGPoint(x: 0.78, y: 0.14),
                          leaderLength: 42, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows inside the knees",
                          labelPoint: CGPoint(x: 0.22, y: 0.32),
                          labelSide: .trailing, leaderLength: 42, joint: "hand_R"),
            CueAnnotation(cueID: "torso", label: "Chest lifted, torso tall",
                          labelPoint: CGPoint(x: 0.30, y: 0.50),
                          labelSide: .trailing, leaderLength: 50, joint: "chest"),
            CueAnnotation(cueID: "knee", label: "Knees track over toes",
                          labelPoint: CGPoint(x: 0.88, y: 0.68),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "depth", label: "Sit to full depth",
                          labelPoint: CGPoint(x: 0.14, y: 0.86),
                          labelSide: .trailing, leaderLength: 44, joint: "pelvis")
        ],
        cues: [
            TechniqueCue(
                id: "hold",
                title: "Goblet Hold",
                intro: "Holding the weight at the chest is what makes the goblet squat such a good depth and posture teacher.",
                why: "A single load held centred in front of the chest keeps the whole body's centre of gravity balanced over the mid-foot without any barbell setup.",
                mistake: "Letting the weight drift down toward the belt or out away from the chest, pulling the torso forward and off balance.",
                correct: "Cup the weight against the sternum with both hands, elbows pointing down, and keep it pinned there the whole set."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Checkpoint",
                intro: "The elbows have a job at the bottom of a goblet squat that no other squat variation asks for.",
                why: "Letting the elbows slide just inside the knees at full depth gently pushes the knees out into good tracking and confirms the squat is deep enough.",
                mistake: "Squatting with the knees drawn together too narrow for the elbows to fit between them at the bottom.",
                correct: "Sit down between the knees until the elbows lightly touch the inside of the knees at the bottom of the rep."
            ),
            TechniqueCue(
                id: "torso",
                title: "Torso Position",
                intro: "The goblet hold naturally teaches an upright torso.",
                why: "Because the load sits in front of the chest instead of on the back, staying tall is what keeps the weight balanced — lean forward and it pulls straight out of the hands.",
                mistake: "Rounding forward at the bottom, which is usually a sign the ankles or hips are short on mobility rather than a strength problem.",
                correct: "Keep the chest lifted through the whole squat, breathing into the belly to help hold the position."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Tracking",
                intro: "Good knee tracking is easy to feel in a goblet squat because the elbows give it instant feedback.",
                why: "Letting the knees travel out in line with the toes — helped by the elbows pressing them apart at the bottom — keeps the load centred in the knee joint.",
                mistake: "Knees caving in as the squat gets deep, closing the gap the elbows are meant to fill.",
                correct: "Push the knees out over the toes as you descend, using the elbows at the bottom as a checkpoint."
            ),
            TechniqueCue(
                id: "depth",
                title: "Full Depth",
                intro: "Full depth is where the goblet squat earns its reputation as a mobility and pattern-building tool.",
                why: "Sitting all the way down until the elbows meet the knees opens the hips through their full range and builds the squat pattern other variations build on.",
                mistake: "Stopping at a shallow quarter squat, which skips the mobility and glute work the position is meant to build.",
                correct: "Sink until the elbows brush the inside of the knees, then stand back up through the whole foot."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.85),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.52),
            MuscleActivation(name: "Rectus Abdominis", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.32)
        ],
        stabilisers: ["adductors", "upper back", "forearms"],
        setup: [
            "Hold one dumbbell upright against your chest.",
            "Tuck your elbows under the dumbbell.",
            "Feet shoulder-width, toes slightly out, chest tall."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HEELS LIFTING",
            correctCue: "Weight through the whole foot",
            mistakeCue: "Heels rise, weight shifts forward",
            correctNote: "Keeping the heels down and weight spread across the whole foot keeps the torso balanced under the goblet hold.",
            mistakeNote: "When the heels lift, the torso tips forward to stay balanced over the toes, rounding the back and shifting stress onto the knees and lower spine."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.14, cx: 0.50, cy: 0.60),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.46)
        ]
    )

    static let walkingLungeContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "torso", label: "Torso stays tall",
                          labelPoint: CGPoint(x: 0.24, y: 0.14),
                          labelSide: .trailing, leaderLength: 46, joint: "chest"),
            CueAnnotation(cueID: "step", label: "Step long enough for 90°",
                          labelPoint: CGPoint(x: 0.86, y: 0.32),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "knee", label: "Knee stacks over the ankle",
                          labelPoint: CGPoint(x: 0.86, y: 0.50),
                          leaderLength: 38, joint: "patella_L"),
            CueAnnotation(cueID: "balance", label: "Tap the back knee, don't bounce",
                          labelPoint: CGPoint(x: 0.16, y: 0.68),
                          labelSide: .trailing, leaderLength: 40, joint: "thigh_R"),
            CueAnnotation(cueID: "drive", label: "Drive through the front heel",
                          labelPoint: CGPoint(x: 0.16, y: 0.86),
                          labelSide: .trailing, leaderLength: 42, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "step",
                title: "Step Length",
                intro: "Step length sets up everything else in a walking lunge.",
                why: "A stride long enough to let both knees reach roughly 90 degrees at the bottom keeps the front shin close to vertical and the back knee under the hip, not way out behind it.",
                mistake: "Taking a short, narrow step that forces the front knee far past the toes to reach depth.",
                correct: "Step out far enough that the front knee stacks over the ankle and the back knee drops straight down toward the floor."
            ),
            TechniqueCue(
                id: "knee",
                title: "Front Knee Tracking",
                intro: "The front knee is doing most of the steering in this lift.",
                why: "Keeping the front shin close to vertical at the bottom of each step keeps the load on the quads and glutes instead of the knee joint.",
                mistake: "Letting the front knee drive out past the toes or cave inward as fatigue sets in over the set.",
                correct: "Track the front knee straight ahead over the foot, stacking directly above the ankle at the bottom of each step."
            ),
            TechniqueCue(
                id: "torso",
                title: "Torso Position",
                intro: "The torso has to stay stacked over the hips through every step of a walking lunge.",
                why: "An upright torso keeps the centre of gravity balanced between the two feet, which is what makes a walking lunge stable to travel on.",
                mistake: "Leaning forward from the hips to help momentum carry the body into the next step.",
                correct: "Keep the chest lifted and the torso vertical, letting the legs — not a forward lean — do the work of moving forward."
            ),
            TechniqueCue(
                id: "drive",
                title: "Forward Drive",
                intro: "Each step ends the same way it should: driving forward off the front leg.",
                why: "Pushing hard through the front heel to bring the back leg through keeps continuous tension on the working leg instead of relying on a bounce off the back knee.",
                mistake: "Pushing off the back toe to launch forward, which lets momentum finish the rep instead of the front leg's muscles.",
                correct: "Drive through the front heel and midfoot to bring the trailing leg forward into the next step."
            ),
            TechniqueCue(
                id: "balance",
                title: "Controlled Balance",
                intro: "A walking lunge is a moving exercise, and control has to travel with it.",
                why: "Lightly tapping the back knee near the floor rather than dropping into it keeps tension on the legs continuously between steps.",
                mistake: "Letting the back knee bounce off the floor to rebound into the next step, trading control for momentum.",
                correct: "Lower the back knee under control until it lightly grazes the floor, then drive straight into the next step."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.83),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.62),
            MuscleActivation(name: "Hamstrings", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.35)
        ],
        stabilisers: ["gluteus medius", "adductors", "calves", "core"],
        setup: [
            "Hold a dumbbell in each hand at your sides.",
            "Stand tall with your feet hip-width apart.",
            "Clear space ahead to walk forward in long steps."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "KNEE PAST THE TOES",
            correctCue: "Front knee stacks over the ankle",
            mistakeCue: "Front knee drives past the toes",
            correctNote: "A long enough step keeps the front shin close to vertical, stacking the knee over the ankle and keeping the load on the big hip and thigh muscles.",
            mistakeNote: "A short step forces the knee to travel well past the toes to reach depth, loading the knee joint itself instead of the muscles around it."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.18, ry: 0.15, cx: 0.54, cy: 0.64),
            .init(DS.activationSoft.opacity(0.28), rx: 0.12, ry: 0.10, cx: 0.46, cy: 0.50)
        ]
    )

    static let reverseLungeContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "torso", label: "Torso stays tall",
                          labelPoint: CGPoint(x: 0.24, y: 0.14),
                          labelSide: .trailing, leaderLength: 46, joint: "chest"),
            CueAnnotation(cueID: "load", label: "Weight stays on the front leg",
                          labelPoint: CGPoint(x: 0.16, y: 0.32),
                          labelSide: .trailing, leaderLength: 40, joint: "thigh_R"),
            CueAnnotation(cueID: "knee", label: "Front knee stacks over ankle",
                          labelPoint: CGPoint(x: 0.84, y: 0.50),
                          leaderLength: 38, joint: "pelvis"),
            CueAnnotation(cueID: "drive", label: "Drive up through the front heel",
                          labelPoint: CGPoint(x: 0.16, y: 0.68),
                          labelSide: .trailing, leaderLength: 42, joint: "foot_R"),
            CueAnnotation(cueID: "step", label: "Step straight back",
                          labelPoint: CGPoint(x: 0.84, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "step",
                title: "Step Direction",
                intro: "A reverse lunge starts by stepping one foot straight back, not out to the side.",
                why: "Stepping straight back keeps the hips square and the front leg carrying almost the full load, which is what makes this variation easier on the front knee than a forward lunge.",
                mistake: "Stepping back at an angle or too short a distance, which twists the hips or crowds the front knee.",
                correct: "Step straight back into a stride long enough that the front shin stays close to vertical at the bottom."
            ),
            TechniqueCue(
                id: "knee",
                title: "Front Knee",
                intro: "The front leg is the one doing the work here — the back leg is just a kickstand.",
                why: "Because the step lands behind the body, almost all of the weight loads through the front leg's quad and glute, with the front knee staying stacked over the ankle.",
                mistake: "Letting the front knee drift forward past the toes as the back foot reaches for the floor.",
                correct: "Keep the front shin close to vertical and the knee stacked over the ankle as the back knee lowers."
            ),
            TechniqueCue(
                id: "torso",
                title: "Torso Position",
                intro: "Balance in a reverse lunge comes from the torso staying tall over the front hip.",
                why: "An upright torso keeps the bodyweight stacked over the working leg, which is what lets this lunge load the front leg so directly.",
                mistake: "Leaning forward to help the back leg reach the floor, which shifts load off the front leg and onto the lower back.",
                correct: "Keep the chest lifted and the torso vertical as the back knee lowers toward the floor."
            ),
            TechniqueCue(
                id: "load",
                title: "Weight Distribution",
                intro: "Almost all of the work in a reverse lunge should be felt in the front leg.",
                why: "The back leg only needs enough weight to steady balance; loading it more turns the movement into a split squat sharing work between both legs.",
                mistake: "Pushing off the back foot to help stand back up, which shares work the front leg is meant to do alone.",
                correct: "Keep the back foot light on the floor and drive the whole rep from the front leg."
            ),
            TechniqueCue(
                id: "drive",
                title: "Standing Drive",
                intro: "The rep finishes exactly the way it started — powered by the front leg.",
                why: "Driving up through the front heel back to standing keeps continuous tension on the front leg's quad and glute through the entire rep.",
                mistake: "Pushing through the back toe to help stand up, letting it share the work the front leg should be doing alone.",
                correct: "Press through the front heel and midfoot to stand tall, bringing the back leg through to finish the step."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.80),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.65),
            MuscleActivation(name: "Hamstrings", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.32)
        ],
        stabilisers: ["gluteus medius", "adductors", "core"],
        setup: [
            "Hold a dumbbell in each hand at your sides.",
            "Stand tall with your feet hip-width apart.",
            "Brace your core before each step back."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "WEIGHT ON THE BACK LEG",
            correctCue: "Front leg carries the load",
            mistakeCue: "Pushing off the back foot",
            correctNote: "Keeping the back foot light and driving up through the front heel keeps the front leg's quad and glute doing almost all of the work.",
            mistakeNote: "Pushing off the back toe to help stand up shares the load with the back leg, undercutting the single-leg strength this exercise is meant to build."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.18, ry: 0.15, cx: 0.46, cy: 0.60),
            .init(DS.activationSoft.opacity(0.28), rx: 0.12, ry: 0.10, cx: 0.54, cy: 0.46)
        ]
    )

    static let legPressContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "feet", label: "Feet shoulder-width, centred",
                          labelPoint: CGPoint(x: 0.30, y: 0.14),
                          labelSide: .trailing, leaderLength: 46, joint: "foot_L"),
            CueAnnotation(cueID: "knee", label: "Knees track over toes",
                          labelPoint: CGPoint(x: 0.86, y: 0.28),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "lockout", label: "Stop just short of lockout",
                          labelPoint: CGPoint(x: 0.86, y: 0.48),
                          leaderLength: 36, joint: "shin_L"),
            CueAnnotation(cueID: "back", label: "Hips flat against the pad",
                          labelPoint: CGPoint(x: 0.30, y: 0.68),
                          labelSide: .trailing, leaderLength: 44, joint: "chest"),
            CueAnnotation(cueID: "range", label: "Stop before hips tuck under",
                          labelPoint: CGPoint(x: 0.82, y: 0.86),
                          leaderLength: 42, joint: "pelvis")
        ],
        cues: [
            TechniqueCue(
                id: "feet",
                title: "Foot Placement",
                intro: "Where the feet sit on the platform changes which muscles carry the rep.",
                why: "A shoulder-width stance centred on the platform balances quad and glute involvement, while pressing evenly through the whole foot keeps the knees tracking cleanly.",
                mistake: "Placing the feet too high, too low, or too narrow for a stable, evenly loaded press.",
                correct: "Set the feet shoulder-width apart, centred on the platform, and press evenly through the whole foot."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Tracking",
                intro: "The sled's fixed path does not fix bad knee tracking — that is still on the lifter.",
                why: "Letting the knees travel out in line with the toes keeps the load centred in the joint through the full range of the press.",
                mistake: "Knees caving inward as the weight gets heavy, especially on the way up from the bottom.",
                correct: "Push the knees out over the toes through both the lowering and the press, matching the stance's natural angle."
            ),
            TechniqueCue(
                id: "range",
                title: "Range of Motion",
                intro: "How far the sled lowers should be limited by the hips, not the platform.",
                why: "Lowering only until the hips are about to tuck under — the lower back rounding off the pad — keeps the load on the legs instead of the lumbar spine.",
                mistake: "Lowering the sled all the way down until the hips round off the seat pad to chase extra range.",
                correct: "Lower until the knees reach roughly 90 degrees or the hips start to lift off the pad, whichever comes first, then press back up."
            ),
            TechniqueCue(
                id: "lockout",
                title: "Top Lockout",
                intro: "The top of a leg press rep should stop just short of straight.",
                why: "Leaving a slight bend in the knees at the top keeps tension on the quads and avoids resting the joint into a locked, hyperextended position under load.",
                mistake: "Punching the knees all the way straight and locking out at the top of every rep.",
                correct: "Extend the legs until they are almost straight, stopping just short of a hard lockout."
            ),
            TechniqueCue(
                id: "back",
                title: "Back Position",
                intro: "The lower back has a job on a leg press: staying flat against the pad.",
                why: "A back and hips that stay flush against the seat pad transmit the leg drive cleanly, instead of letting the pelvis rock under load.",
                mistake: "Letting the hips shift or the lower back arch off the pad as the sled lowers.",
                correct: "Keep the hips and lower back pressed flat into the pad through the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.87),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.48)
        ],
        stabilisers: ["hamstrings", "adductors", "calves"],
        setup: [
            "Sit with your back and hips flat against the pad.",
            "Place your feet shoulder-width in the middle of the platform.",
            "Press the platform up and release the safety handles."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "KNEES LOCKING OUT",
            correctCue: "Slight bend held at the top",
            mistakeCue: "Knees punched straight",
            correctNote: "Stopping just short of a full lockout keeps tension on the quads and keeps the knee joint out of a hyperextended, unsupported position.",
            mistakeNote: "Locking the knees out hard at the top shifts the load off the muscles and onto the joint itself, and is a common way lifters strain the knee on a leg press."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.16, ry: 0.13, cx: 0.60, cy: 0.50),
            .init(DS.activationSoft.opacity(0.28), rx: 0.10, ry: 0.08, cx: 0.62, cy: 0.36)
        ]
    )

    static let hackSquatContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "lockout", label: "Stop just short of lockout",
                          labelPoint: CGPoint(x: 0.86, y: 0.14),
                          leaderLength: 46, joint: "hand_L"),
            CueAnnotation(cueID: "pad", label: "Back stays on the pad",
                          labelPoint: CGPoint(x: 0.82, y: 0.32),
                          leaderLength: 44, joint: "chest"),
            CueAnnotation(cueID: "knee", label: "Knees track over toes",
                          labelPoint: CGPoint(x: 0.18, y: 0.50),
                          labelSide: .trailing, leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "depth", label: "Lower under control, no bounce",
                          labelPoint: CGPoint(x: 0.16, y: 0.68),
                          labelSide: .trailing, leaderLength: 38, joint: "pelvis"),
            CueAnnotation(cueID: "feet", label: "Centre feet on the plate",
                          labelPoint: CGPoint(x: 0.16, y: 0.86),
                          labelSide: .trailing, leaderLength: 42, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "feet",
                title: "Foot Placement",
                intro: "Foot placement on a hack squat's angled plate works like a dial for where the tension lands.",
                why: "A lower, centred foot position biases the quads through a deep knee bend, while sliding the feet higher up the plate shifts more of the work to the glutes and hamstrings.",
                mistake: "Placing the feet right at the very edge of the plate, which crowds the ankles and limits how deep the sled can travel safely.",
                correct: "Centre the feet shoulder-width on the plate, adjusting higher or lower deliberately depending on the target."
            ),
            TechniqueCue(
                id: "pad",
                title: "Pad Contact",
                intro: "The shoulder and back pads are there to keep the spine supported through a much deeper range than a free squat allows.",
                why: "Staying flush against the pads keeps the sled's angle carrying the load instead of the lower back compensating for a floating torso.",
                mistake: "Letting the hips or shoulders lift off the pads at the bottom to chase extra depth.",
                correct: "Keep the back and shoulders pressed into the pads through the descent and the drive back up."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Tracking",
                intro: "A fixed sled angle does not fix knee tracking — that still comes from the lifter.",
                why: "Pushing the knees out in line with the toes keeps the load centred in the joint through the machine's long range of motion.",
                mistake: "Letting the knees cave inward, which is easy to miss on a machine that feels stable side-to-side.",
                correct: "Actively track the knees out over the toes for the whole rep, the same as on a free squat."
            ),
            TechniqueCue(
                id: "depth",
                title: "Controlled Depth",
                intro: "The hack squat's fixed angle allows a deeper, safer range than most free squats.",
                why: "Lowering under control until the thighs are well past parallel loads the quads through a much longer range than a partial rep would.",
                mistake: "Bouncing off the bottom to rebound the weight back up, using momentum instead of the quads to reverse the sled.",
                correct: "Lower under control to a deep, comfortable stretch, pause briefly, then press back up without bouncing."
            ),
            TechniqueCue(
                id: "lockout",
                title: "Top Lockout",
                intro: "The top of the rep should be controlled, not slammed.",
                why: "Extending to just short of a hard lockout keeps tension on the quads and protects the knee from repeatedly absorbing a locked-out impact under load.",
                mistake: "Snapping the knees straight and letting the sled's weight jolt into the top stop on every rep.",
                correct: "Press up to nearly straight legs under control, stopping just short of locking the knees out hard."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.89),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.44)
        ],
        stabilisers: ["hamstrings", "adductors", "calves"],
        setup: [
            "Stand on the platform with your back against the pad.",
            "Set your shoulders under the pads, feet shoulder-width.",
            "Hold the handles and release the safety."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIPS LIFTING OFF THE PAD",
            correctCue: "Back and hips stay on the pad",
            mistakeCue: "Hips lift to chase more depth",
            correctNote: "Keeping the hips and back flush against the pad channels the load through the legs along the machine's fixed angle.",
            mistakeNote: "Letting the hips lift off the pad to reach extra depth rounds the lower back at the bottom — the same fault a free squat punishes, just easier to miss on a supported machine."
        ),
        glows: [
            .init(DS.activation.opacity(0.56), rx: 0.15, ry: 0.13, cx: 0.49, cy: 0.48),
            .init(DS.activationSoft.opacity(0.26), rx: 0.10, ry: 0.08, cx: 0.52, cy: 0.35)
        ]
    )

    static let legExtensionContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "pad", label: "Pad rests above the ankle",
                          labelPoint: CGPoint(x: 0.16, y: 0.72),
                          labelSide: .trailing, leaderLength: 42, joint: "foot_L"),
            CueAnnotation(cueID: "tempo", label: "Slow, controlled tempo",
                          labelPoint: CGPoint(x: 0.18, y: 0.50),
                          labelSide: .trailing, leaderLength: 38, joint: "shin_L"),
            CueAnnotation(cueID: "squeeze", label: "Pause and squeeze at the top",
                          labelPoint: CGPoint(x: 0.86, y: 0.40),
                          leaderLength: 40, joint: "thigh_L"),
            CueAnnotation(cueID: "hips", label: "Hips stay on the seat",
                          labelPoint: CGPoint(x: 0.84, y: 0.62),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "negative", label: "Control the full lowering",
                          labelPoint: CGPoint(x: 0.86, y: 0.20),
                          leaderLength: 44, joint: "hand_L")
        ],
        cues: [
            TechniqueCue(
                id: "pad",
                title: "Pad Position",
                intro: "Where the shin pad sits changes the leverage on the knee.",
                why: "Resting the pad just above the ankle, not on it, gives the quads the longest, most controlled lever to extend against.",
                mistake: "Letting the pad sit too high on the shin or right on the ankle joint, shortening or awkwardly loading the lever.",
                correct: "Adjust the pad to rest just above the ankle bone before starting the set."
            ),
            TechniqueCue(
                id: "tempo",
                title: "Tempo",
                intro: "A leg extension is easy to turn into a swinging, momentum-driven rep.",
                why: "A slow, controlled tempo keeps the quads doing the lifting instead of letting the weight stack's own momentum carry the leg up and down.",
                mistake: "Kicking the weight up fast and letting it drop, using momentum instead of muscle for most of the rep.",
                correct: "Extend and lower the leg at a controlled, even pace for the whole set."
            ),
            TechniqueCue(
                id: "squeeze",
                title: "Top Squeeze",
                intro: "The very top of the rep is where the quads are shortest and hardest to keep tense.",
                why: "A brief pause and squeeze at full extension keeps the quads under tension through the point of the range they most want to skip.",
                mistake: "Bouncing off the top of the rep the instant the leg straightens, without any pause.",
                correct: "Extend fully, pause for a moment and squeeze the quads, then lower under control."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Position",
                intro: "The hips and back should stay exactly where the seat put them.",
                why: "Keeping the hips flush against the seat back isolates the knee extension to the quads, instead of letting the hip flexors and lower back help lift the weight.",
                mistake: "Arching the back or lifting the hips off the seat to help swing the weight up as the set gets hard.",
                correct: "Keep the hips and back pressed into the seat through every rep, using the handles to stay anchored if needed."
            ),
            TechniqueCue(
                id: "negative",
                title: "The Negative",
                intro: "The lowering half of a leg extension does as much work as the lift.",
                why: "Controlling the negative through the full range keeps the quads under tension on the way down instead of just letting gravity and the stack do the work.",
                mistake: "Letting the weight stack drop quickly back down once the top of the rep is reached.",
                correct: "Lower the weight under control through the full range before starting the next rep."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.91)
        ],
        stabilisers: [],
        setup: [
            "Set the back pad so your knees line up with the machine's pivot.",
            "Set the ankle pad just above your feet.",
            "Sit tall and hold the side handles."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SWINGING THE WEIGHT",
            correctCue: "Slow, controlled extension",
            mistakeCue: "Kicking the weight up fast",
            correctNote: "A controlled tempo through both the lift and the lowering keeps the tension on the quads for the whole range of the rep.",
            mistakeNote: "Kicking the weight up fast lets momentum do the lifting instead of the quads, and the sudden stop at full extension puts unnecessary stress on the knee."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.14, ry: 0.13, cx: 0.55, cy: 0.48),
            .init(DS.activationSoft.opacity(0.26), rx: 0.09, ry: 0.07, cx: 0.50, cy: 0.60)
        ]
    )

    static let smithMachineSquatContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "brace", label: "Brace core, chest up",
                          labelPoint: CGPoint(x: 0.30, y: 0.14),
                          labelSide: .trailing, leaderLength: 46, joint: "chest"),
            CueAnnotation(cueID: "path", label: "Bar travels straight down",
                          labelPoint: CGPoint(x: 0.82, y: 0.32),
                          leaderLength: 50, joint: "hand_L"),
            CueAnnotation(cueID: "knee", label: "Knees track over toes",
                          labelPoint: CGPoint(x: 0.86, y: 0.50),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "depth", label: "Hip crease below the knee",
                          labelPoint: CGPoint(x: 0.16, y: 0.68),
                          labelSide: .trailing, leaderLength: 42, joint: "pelvis"),
            CueAnnotation(cueID: "stance", label: "Feet set forward of the bar",
                          labelPoint: CGPoint(x: 0.16, y: 0.86),
                          labelSide: .trailing, leaderLength: 46, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "stance",
                title: "Foot Stance",
                intro: "The Smith machine's bar only moves in a straight vertical line, so the feet have to set up around that fixed path instead of under it.",
                why: "Walking the feet slightly forward of the bar lets the hips sit back naturally on the way down without the knees having to travel excessively past the toes.",
                mistake: "Standing with the feet directly under the bar the way a free squat would, which forces the knees forward into a shin-dominant, awkward squat.",
                correct: "Step the feet out several inches in front of the bar before unracking, so the body can lean back slightly into the machine's fixed line."
            ),
            TechniqueCue(
                id: "path",
                title: "Bar Path",
                intro: "The rail does the balancing that a free bar would ask the body to do.",
                why: "Because the bar can only travel straight up and down, all of the depth and knee control has to come from the hips and knees rather than from steering the bar.",
                mistake: "Fighting the fixed path by trying to shift the hips around it, which just loads the joints unevenly instead of following the rail.",
                correct: "Let the machine hold the bar's line and focus all of the effort on sitting the hips straight down and driving straight back up."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Tracking",
                intro: "Knee tracking still matters on a guided machine — the rail does not fix bad knee position.",
                why: "Because the feet sit forward of the bar, it is easy to let the knees dive in front of the toes instead of out over them.",
                mistake: "Knees caving inward or shooting forward past the toes as the fixed bar path removes the usual balance cues.",
                correct: "Keep pushing the knees out in line with the toes for the whole rep, exactly as in a free squat."
            ),
            TechniqueCue(
                id: "depth",
                title: "Squat Depth",
                intro: "Depth is set by the hips, not by the machine.",
                why: "The safety of the fixed bar path can tempt lifters to stop short; reaching real depth still trains the full range of the quads and glutes.",
                mistake: "Bouncing at a shallow quarter-depth because the guided bar feels stable enough to rush.",
                correct: "Sink until the hip crease drops just below the knee before pressing back up."
            ),
            TechniqueCue(
                id: "brace",
                title: "Core Bracing",
                intro: "A supported bar path does not mean a supported spine.",
                why: "The torso still has to stay braced and upright through the lift; the machine only removes the side-to-side balancing, not the need for core tension.",
                mistake: "Relaxing the core because the rail feels stable, letting the lower back round at the bottom.",
                correct: "Brace the abs and keep the chest lifted through the whole rep, just as with a free-standing squat."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50),
            MuscleActivation(name: "Erector Spinae", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.30)
        ],
        stabilisers: ["hamstrings", "adductors", "calves", "core"],
        setup: [
            "Set the bar at shoulder height and step under it.",
            "Bar on your upper traps, feet slightly in front of the bar.",
            "Turn the bar to unhook it and brace your core."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "FEET UNDER THE BAR",
            correctCue: "Feet set forward of the fixed bar",
            mistakeCue: "Feet directly under the bar",
            correctNote: "Stepping the feet forward lets the hips sit back naturally along the machine's straight path, keeping the squat comfortable on the knees.",
            mistakeNote: "Standing directly under the bar forces the knees to travel far past the toes to follow the fixed vertical path, loading the knee joint awkwardly."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.14, cx: 0.50, cy: 0.58),
            .init(DS.activationSoft.opacity(0.28), rx: 0.12, ry: 0.09, cx: 0.50, cy: 0.44)
        ]
    )

    static let sissySquatContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "lean", label: "Torso reclines with control",
                          labelPoint: CGPoint(x: 0.30, y: 0.14),
                          labelSide: .trailing, leaderLength: 50, joint: "chest"),
            CueAnnotation(cueID: "core", label: "Brace the core",
                          labelPoint: CGPoint(x: 0.80, y: 0.32),
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "line", label: "Knee, hip and shoulder in line",
                          labelPoint: CGPoint(x: 0.82, y: 0.50),
                          leaderLength: 42, joint: "pelvis"),
            CueAnnotation(cueID: "depth", label: "Go only as far as controlled",
                          labelPoint: CGPoint(x: 0.18, y: 0.68),
                          labelSide: .trailing, leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "anchor", label: "Ankles locked under the pad",
                          labelPoint: CGPoint(x: 0.18, y: 0.86),
                          labelSide: .trailing, leaderLength: 44, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "anchor",
                title: "Ankle Anchor",
                intro: "The sissy squat starts from a locked base at the ankles.",
                why: "Anchoring the ankles under the pad is what lets the body lean back and the knees travel forward without the feet sliding out.",
                mistake: "Setting up with the ankles loose or only half hooked under the pad, which lets the base slip mid-rep.",
                correct: "Hook both ankles firmly under the support pad before leaning back into the first rep."
            ),
            TechniqueCue(
                id: "line",
                title: "Body Line",
                intro: "A sissy squat has a very particular shape — nothing else in the gym moves quite like it.",
                why: "The body stays in a straight line from the knees through the hips to the shoulders, with the hips extended rather than folding forward like a normal squat.",
                mistake: "Bending at the hips like a regular squat, which turns the exercise into a half-lunge and takes tension off the quads.",
                correct: "Keep the hips open and the torso, hips and knees moving as one straight line as the knees travel forward and down."
            ),
            TechniqueCue(
                id: "lean",
                title: "Controlled Lean",
                intro: "This is the one squat variation where leaning back is the whole point.",
                why: "Leaning the torso back as the knees bend keeps the centre of gravity over the base and puts the quadriceps under a very deep, direct stretch.",
                mistake: "Staying too upright through the movement, which turns it into a normal squat and loses the quad-specific overload.",
                correct: "Let the torso recline back in a straight line with the hips as the knees bend, controlled by the quads the whole way."
            ),
            TechniqueCue(
                id: "core",
                title: "Core Bracing",
                intro: "The spine has to stay stiff even though the torso is reclining.",
                why: "Bracing the core keeps the lean coming from the ankles and knees rather than from the lower back rounding or hyperextending.",
                mistake: "Letting the lower back arch or round to chase more lean than the hips and ankles can actually support.",
                correct: "Brace the abs and keep the torso rigid, so the recline comes only from the ankle and knee angle changing."
            ),
            TechniqueCue(
                id: "depth",
                title: "Range of Motion",
                intro: "How far back to go is more personal here than in almost any other squat variation.",
                why: "Range depends on ankle mobility and quad flexibility — pushing past what the hips and knees can control trades tension for momentum.",
                mistake: "Forcing a deeper lean than mobility allows, which shows up as the hips breaking the straight line to compensate.",
                correct: "Go as far back as the straight line from knee to shoulder can be held under control, and build range over time rather than forcing it."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88),
            MuscleActivation(name: "Rectus Abdominis", rank: .secondary,
                             activation: "LOW ACTIVATION", fraction: 0.30)
        ],
        stabilisers: ["hip flexors", "calves"],
        setup: [
            "Lock your heels under the foot pad, shins against the front pad.",
            "Stand tall with your hips fully extended.",
            "Hold your hands in front of your chest for balance."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIPS BREAKING THE LINE",
            correctCue: "Knee, hip and shoulder stay in line",
            mistakeCue: "Hips fold forward like a squat",
            correctNote: "Keeping the hips extended and in line with the knees and shoulders keeps the tension on the quads through their full stretch.",
            mistakeNote: "Letting the hips fold forward turns the movement into a shallow lunge, pulling the load off the quads and losing the exercise's whole purpose."
        ),
        glows: [
            .init(DS.activation.opacity(0.58), rx: 0.20, ry: 0.16, cx: 0.50, cy: 0.56),
            .init(DS.activationSoft.opacity(0.26), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.40)
        ]
    )

    static let romanianDeadliftContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "back", label: "Flat, neutral back",
                          labelPoint: CGPoint(x: 0.24, y: 0.14),
                          labelSide: .trailing, leaderLength: 46, joint: "chest"),
            CueAnnotation(cueID: "hinge", label: "Push hips straight back",
                          labelPoint: CGPoint(x: 0.18, y: 0.32),
                          labelSide: .trailing, leaderLength: 48, joint: "pelvis"),
            CueAnnotation(cueID: "knee", label: "Soft, fixed knee bend",
                          labelPoint: CGPoint(x: 0.82, y: 0.50),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "stretch", label: "Stop at the hamstring stretch",
                          labelPoint: CGPoint(x: 0.18, y: 0.68),
                          labelSide: .trailing, leaderLength: 40, joint: "shin_L"),
            CueAnnotation(cueID: "barpath", label: "Bar brushes the legs",
                          labelPoint: CGPoint(x: 0.80, y: 0.86),
                          leaderLength: 36, joint: "hand_L")
        ],
        cues: [
            TechniqueCue(
                id: "hinge",
                title: "Hip Hinge",
                intro: "A Romanian deadlift is a hip hinge, not a squat with a bar.",
                why: "Pushing the hips straight back keeps the movement loading the hamstrings and glutes through a stretch, instead of turning into a knee-dominant squat.",
                mistake: "Bending the knees and sitting down like a squat instead of sending the hips back, which takes the tension off the hamstrings.",
                correct: "Start every rep by pushing the hips backward as if closing a car door with them, letting the torso lower as a result."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Angle",
                intro: "The knees do very little bending in this lift — that job belongs to the hips.",
                why: "A soft, fixed knee bend set at the top and held through the rep keeps the hamstrings under continuous tension across their full length.",
                mistake: "Letting the knees bend more as the bar descends, which turns the RDL into a stiff-legged squat and shortens the hamstring stretch.",
                correct: "Set a slight knee bend at the top and keep that same angle through the whole rep, hinging only at the hip."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "The bar should stay in contact with the legs for almost the entire rep.",
                why: "Keeping the bar brushing down the front of the thighs and shins keeps it directly under the shoulders, which is what keeps the low back from having to fight the weight.",
                mistake: "Letting the bar drift forward away from the legs, which extends the lever arm and dramatically increases the load on the lower back.",
                correct: "Keep the bar dragging lightly down the thighs and shins on the way down, and back up the same path on the way up."
            ),
            TechniqueCue(
                id: "back",
                title: "Spine Position",
                intro: "The spine holds one position for this entire lift — it never rounds and never over-arches.",
                why: "A flat, neutral back transmits force evenly through the spine; a rounded back concentrates that same load onto the lower discs.",
                mistake: "Letting the lower back round as the hips reach the end of their range, usually a sign of going past the hamstrings' available stretch.",
                correct: "Set a neutral spine before the first rep and keep the chest and hips moving together to preserve it through the whole set."
            ),
            TechniqueCue(
                id: "stretch",
                title: "Range of Motion",
                intro: "How low the bar travels is decided by the hamstrings, not by a fixed target like the floor.",
                why: "The rep ends the moment the hips can no longer hinge back further without the lower back rounding to compensate — usually somewhere around mid-shin.",
                mistake: "Chasing the floor by rounding the back or bending the knees more once the hamstrings run out of range.",
                correct: "Lower only until a firm stretch is felt through the hamstrings and the back is about to round, then reverse the movement."
            )
        ],
        activation: [
            MuscleActivation(name: "Hamstrings", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.60),
            MuscleActivation(name: "Erector Spinae", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.42)
        ],
        stabilisers: ["latissimus dorsi", "upper trapezius", "forearms", "core"],
        setup: [
            "Hold the bar at hip height with an overhand, shoulder-width grip.",
            "Feet hip-width, knees slightly bent.",
            "Shoulders back and back flat, bar against your thighs."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "TURNS INTO A SQUAT",
            correctCue: "Hips hinge back, knees stay soft",
            mistakeCue: "Knees bend, hips barely move",
            correctNote: "Sending the hips back with a fixed knee bend keeps the hamstrings loaded through a full stretch, which is the entire point of the lift.",
            mistakeNote: "Bending the knees instead of hinging the hips turns the RDL into a shallow squat, taking the load off the hamstrings and onto the quads instead."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.16, ry: 0.18, cx: 0.50, cy: 0.56),
            .init(DS.activationSoft.opacity(0.28), rx: 0.14, ry: 0.10, cx: 0.50, cy: 0.42)
        ]
    )

    // MARK: - Shoulder content (2026-09-24)
    //
    // Label points below were laid out from the real rig: every tracked
    // joint projected through the exercise's own `modelByExercise` framing
    // at eight points across the clip, with this device's 382 x 705
    // viewport aspect (the framings were solved at 0.74; the viewport is
    // really ~0.54 wide-to-tall, which matters for x). The five labels take
    // the fixed rows 0.14 / 0.32 / 0.50 / 0.68 / 0.86 in the order of their
    // joints' height — the 0.18 spacing the legs taught us — on the same
    // side of the screen as their joint, flipping sides only when the label
    // would cover any tracked dot at any point in the clip. `overrides` in
    // the generator pinned three lifts by hand (Skull Crusher, both
    // Bulgarian split squats).
    //
    // Activation ranks follow published sEMG comparisons: the anterior
    // deltoid leads every overhead press (Campos et al. 2020, J Hum Kinet 75;
    // Saeterbakken & Fimland 2013, JSCR — standing/dumbbell presses highest,
    // barbell presses highest for the triceps), machine presses draw less
    // deltoid activity than barbell presses (Coratella et al. 2022,
    // Front Physiol), and the Arnold press out-activates the ordinary
    // dumbbell press in both anterior and medial heads (IJPHRD 2017). For
    // raises, a neutral-grip lateral raise maximises the medial deltoid with
    // the posterior head next, internal rotation shifts work to the rear
    // head and upper trapezius, and the front raise adds the pectoralis
    // major (Coratella et al. 2020, IJERPH 17). Rear-delt isolation (reverse
    // fly, reverse pec deck, face pull) draws far more posterior deltoid
    // activity than rows or presses (Schoenfeld et al. 2013, JSCR on hand
    // position; ACE/ExRx rankings). Technique cues follow the NSCA Exercise
    // Technique Manual, the ACE exercise library, ExRx.net and StrengthLog:
    // vertical forearms and a straight bar path with the head moving through
    // on the press, elbows in the scapular plane, raises stopping at shoulder
    // height without a shrug, and face pulls finishing high with external
    // rotation.

    static let barbellOverheadPressContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "grip", label: "Wrists over elbows",
                          labelPoint: CGPoint(x: 0.638, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "barpath", label: "Bar travels straight up",
                          labelPoint: CGPoint(x: 0.565, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "head", label: "Head through at lockout",
                          labelPoint: CGPoint(x: 0.435, y: 0.32),
                          leaderLength: 40, joint: "head"),
            CueAnnotation(cueID: "brace", label: "Glutes tight, ribs down",
                          labelPoint: CGPoint(x: 0.435, y: 0.68),
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "feet", label: "Legs locked, no dip",
                          labelPoint: CGPoint(x: 0.624, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "grip",
                title: "Grip & Forearms",
                intro: "The press starts from the rack position, and the forearms set its line.",
                why: "With the wrists stacked over vertical forearms, force travels straight up into the bar instead of bending the wrists back.",
                mistake: "A grip so wide or a wrist so cocked that the bar rolls onto the fingers and drifts forward.",
                correct: "Grip just outside the shoulders with the bar low in the palm, forearms vertical and elbows slightly in front of the bar."
            ),
            TechniqueCue(
                id: "barpath",
                title: "Bar Path",
                intro: "The bar should rise in a straight vertical line over the middle of the foot.",
                why: "A vertical path keeps the load balanced over the base; a bar that loops forward lengthens the lever on the shoulders and lower back.",
                mistake: "Pressing the bar out and around the face so it finishes in front of the head.",
                correct: "Pull the chin back to clear a straight path, press the bar close to the face and finish directly over mid-foot."
            ),
            TechniqueCue(
                id: "head",
                title: "Head Position",
                intro: "The head moves out of the way on the way up and back in at the top.",
                why: "Bringing the head through under the bar at lockout stacks bar, shoulders and hips, so the deltoids and triceps finish the rep without the lower back compensating.",
                mistake: "Leaving the head back at lockout, which parks the bar in front of the body.",
                correct: "Once the bar passes the forehead, push the head forward under it and finish with the arms beside the ears."
            ),
            TechniqueCue(
                id: "brace",
                title: "Trunk Bracing",
                intro: "Standing overhead work is only as stable as the trunk under it.",
                why: "Squeezing the glutes and keeping the ribs down stops the lower back arching, which would turn the lift into a steep incline press.",
                mistake: "Leaning back to press, over-arching the lumbar spine to get the bar up.",
                correct: "Brace the abs, squeeze the glutes and keep the ribs stacked over the pelvis on every rep."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base",
                intro: "A strict press gets no help from the legs.",
                why: "Locked knees and a hip-width stance keep the effort on the shoulders and triceps and give a stable base to press from.",
                mistake: "Dipping the knees to bounce the bar up, which turns the press into a push press.",
                correct: "Stand with the feet about hip-width, knees locked and weight balanced over mid-foot for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Anterior Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Lateral Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.74),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.58)
        ],
        stabilisers: ["serratus anterior", "rotator cuff", "core", "glutes"],
        setup: [
            "Hold the bar at your collarbones, hands just outside the shoulders.",
            "Stand with your feet hip-width and knees locked.",
            "Squeeze your glutes and brace your core."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "LEANING BACK",
            correctCue: "Ribs down, bar over mid-foot",
            mistakeCue: "Lower back arches to press",
            correctNote: "Keeping the ribs down and the glutes tight holds the trunk vertical, so the deltoids and triceps drive the bar straight up.",
            mistakeNote: "Leaning back turns the press into a steep incline press and loads the lumbar spine in extension — the most common overhead-press fault."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.08, cx: 0.50, cy: 0.30),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.50, cy: 0.40)
        ]
    )

    static let dumbbellShoulderPressContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "elbow", label: "Elbows slightly forward",
                          labelPoint: CGPoint(x: 0.435, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "path", label: "Press up and slightly in",
                          labelPoint: CGPoint(x: 0.550, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "depth", label: "Lower to ear level",
                          labelPoint: CGPoint(x: 0.638, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "back", label: "Back against the pad",
                          labelPoint: CGPoint(x: 0.609, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "feet", label: "Feet flat, wide base",
                          labelPoint: CGPoint(x: 0.391, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "Where the elbows sit decides how the shoulder joint takes the load.",
                why: "Keeping the elbows slightly in front of the torso lets the anterior and lateral deltoids press without jamming the front of the shoulder.",
                mistake: "Elbows flared straight out to the sides and pulled behind the body at the bottom.",
                correct: "Start with the elbows a little forward of the shoulders and the forearms vertical under the dumbbells."
            ),
            TechniqueCue(
                id: "path",
                title: "Press Path",
                intro: "The dumbbells travel in a slight arc, not straight out to the sides.",
                why: "Pressing up and slightly inward keeps the forearms vertical, so the load stays over the joints the deltoids are moving.",
                mistake: "Letting the dumbbells drift wide, or clanging them together at the top and losing tension.",
                correct: "Press up and slightly in until the arms are straight, stopping with the dumbbells just short of touching."
            ),
            TechniqueCue(
                id: "depth",
                title: "Range of Motion",
                intro: "How low the dumbbells go decides how much of the deltoid's range is trained.",
                why: "Lowering to about ear level loads the deltoids through a long range while keeping stress on the front of the shoulder manageable.",
                mistake: "Cutting reps short a few inches from lockout, or dropping the elbows far below the shoulders.",
                correct: "Lower under control until the dumbbells are roughly level with the ears, then press back to straight arms."
            ),
            TechniqueCue(
                id: "back",
                title: "Back Support",
                intro: "The seat back is there to keep the torso out of the lift.",
                why: "Keeping the back against the pad removes momentum and lumbar arching, so the shoulders do the pressing.",
                mistake: "Sliding down the pad and arching the lower back to push heavier dumbbells.",
                correct: "Sit tall with the hips back and the upper back against the pad for the whole set."
            ),
            TechniqueCue(
                id: "feet",
                title: "Foot Position",
                intro: "The feet anchor the seated body.",
                why: "Flat feet set wide give a stable base, so balancing the dumbbells doesn't pull the torso around.",
                mistake: "Feet tucked under the bench or up on the toes, so the hips shift with every rep.",
                correct: "Plant both feet flat, a little wider than the hips, and keep them still throughout the set."
            )
        ],
        activation: [
            MuscleActivation(name: "Anterior Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.84),
            MuscleActivation(name: "Lateral Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.72),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.52)
        ],
        stabilisers: ["rotator cuff", "serratus anterior", "biceps brachii"],
        setup: [
            "Set the bench upright and sit with your back against the pad.",
            "Kick the dumbbells up to shoulder height.",
            "Palms forward, forearms vertical, feet flat and wide."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ELBOWS FLARED BACK",
            correctCue: "Elbows slightly forward",
            mistakeCue: "Elbows flared behind the torso",
            correctNote: "Pressing with the elbows a little in front of the body keeps the shoulder in the scapular plane, where the deltoids are strong and the joint is well supported.",
            mistakeNote: "Flaring the elbows out and back at the bottom pinches the front of the shoulder and shifts load onto the rotator cuff."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.08, cx: 0.50, cy: 0.30),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.50, cy: 0.40)
        ]
    )

    static let arnoldPressContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "rotation", label: "Rotate while you press",
                          labelPoint: CGPoint(x: 0.420, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "start", label: "Start palms in, at chin",
                          labelPoint: CGPoint(x: 0.565, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "finish", label: "Finish over the shoulders",
                          labelPoint: CGPoint(x: 0.536, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "back", label: "Back against the pad",
                          labelPoint: CGPoint(x: 0.609, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "feet", label: "Feet flat, wide base",
                          labelPoint: CGPoint(x: 0.609, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "rotation",
                title: "Rotation",
                intro: "The turn of the palms is what makes this press distinctive.",
                why: "Rotating the palms outward as the elbows open brings the lateral deltoid into the press while the anterior deltoid keeps working.",
                mistake: "Rotating first and pressing afterwards, or whipping through the turn with momentum.",
                correct: "Open the elbows and turn the palms out smoothly as you press, so the rotation finishes as the arms straighten."
            ),
            TechniqueCue(
                id: "start",
                title: "Start Position",
                intro: "The Arnold press begins where a curl finishes.",
                why: "Starting with the palms facing you at chin height puts the front deltoids on stretch and under load before the press begins.",
                mistake: "Starting with the elbows flared and palms already forward, which makes it an ordinary shoulder press.",
                correct: "Hold the dumbbells in front of the chin, palms toward the face and elbows tucked in front of the body."
            ),
            TechniqueCue(
                id: "finish",
                title: "Lockout",
                intro: "Every rep finishes in the same place.",
                why: "Ending with the palms forward and the dumbbells stacked over the shoulders keeps the load on the deltoids rather than the elbows.",
                mistake: "Finishing with bent arms or the dumbbells drifting in front of the face.",
                correct: "Press until the arms are straight with the palms forward, then reverse the rotation on the way down."
            ),
            TechniqueCue(
                id: "back",
                title: "Back Support",
                intro: "The seat back keeps the torso out of the lift.",
                why: "With the back on the pad, the rotation comes from the shoulders instead of a twisting, arching torso.",
                mistake: "Arching away from the pad as the dumbbells rotate overhead.",
                correct: "Sit tall with the hips back and the upper back against the pad for the whole set."
            ),
            TechniqueCue(
                id: "feet",
                title: "Foot Position",
                intro: "The feet anchor the seated body.",
                why: "A wide, flat base keeps the hips still while the arms rotate and press.",
                mistake: "Feet tucked under the bench or up on the toes.",
                correct: "Plant both feet flat, a little wider than the hips, and keep them still."
            )
        ],
        activation: [
            MuscleActivation(name: "Anterior Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Lateral Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.64),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50)
        ],
        stabilisers: ["rotator cuff", "serratus anterior", "biceps brachii"],
        setup: [
            "Set the bench upright and sit with your back against the pad.",
            "Hold the dumbbells in front of your chin, palms facing you.",
            "Plant your feet flat and wide."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ROTATING TOO EARLY",
            correctCue: "Rotate and press together",
            mistakeCue: "Palms turned before the press",
            correctNote: "Turning the palms while pressing blends the anterior and lateral deltoids into one continuous movement.",
            mistakeNote: "Rotating before pressing skips the stretched start position and reduces the lift to a regular shoulder press with extra wrist twisting."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.08, cx: 0.50, cy: 0.30),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.08, cx: 0.50, cy: 0.36)
        ]
    )

    static let machineShoulderPressContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "seat", label: "Handles at shoulder height",
                          labelPoint: CGPoint(x: 0.521, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows under the handles",
                          labelPoint: CGPoint(x: 0.550, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "lockout", label: "Press to a soft lockout",
                          labelPoint: CGPoint(x: 0.435, y: 0.14),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "back", label: "Back flat on the pad",
                          labelPoint: CGPoint(x: 0.609, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "feet", label: "Feet flat on the floor",
                          labelPoint: CGPoint(x: 0.420, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "seat",
                title: "Seat Height",
                intro: "A machine only fits you once the seat is set.",
                why: "With the handles level with the shoulders the press starts where the deltoids are strong and the machine's arc matches the shoulder joint.",
                mistake: "A seat so low the handles start above the head, or so high the elbows drop far below the shoulders.",
                correct: "Adjust the seat so the handles line up with the tops of the shoulders before loading the stack."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The forearms should push straight up into the handles.",
                why: "Forearms stacked under the handles send the load straight through the arm; flared elbows twist the shoulder.",
                mistake: "Elbows flared wide behind the handles.",
                correct: "Keep the elbows slightly forward and directly under the handles for the whole rep."
            ),
            TechniqueCue(
                id: "lockout",
                title: "Range of Motion",
                intro: "Use the full path the machine allows.",
                why: "Pressing to near-straight arms and lowering back to shoulder level trains the deltoids through their whole range.",
                mistake: "Short, bouncing reps that never come back below the forehead.",
                correct: "Press to a soft lockout, pause, then lower under control until the handles return to shoulder height."
            ),
            TechniqueCue(
                id: "back",
                title: "Back Support",
                intro: "The pad takes the trunk out of the lift, which is the point of a machine press.",
                why: "A flat back on the pad means the deltoids and triceps move the stack, not a lumbar arch.",
                mistake: "Arching away from the pad to move more weight.",
                correct: "Keep the hips back and the back flat on the pad; don't let the chest lift away as you press."
            ),
            TechniqueCue(
                id: "feet",
                title: "Foot Position",
                intro: "The feet keep the hips planted in the seat.",
                why: "Flat feet stop the hips sliding forward as the load gets heavy.",
                mistake: "Feet dangling or pushing off the toes.",
                correct: "Plant both feet flat on the floor, about hip-width apart."
            )
        ],
        activation: [
            MuscleActivation(name: "Anterior Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.80),
            MuscleActivation(name: "Lateral Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.76),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50)
        ],
        stabilisers: ["rotator cuff", "serratus anterior"],
        setup: [
            "Set the seat so the handles are at shoulder height.",
            "Sit with your back flat against the pad, feet on the floor.",
            "Grip the handles with your elbows under your wrists."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "BACK OFF THE PAD",
            correctCue: "Back flat on the pad",
            mistakeCue: "Lower back arches off the pad",
            correctNote: "With the back flat on the pad, the machine's fixed path lets the deltoids press with nothing else joining in.",
            mistakeNote: "Arching off the pad changes the pressing angle toward an incline press and loads the lower back the machine is meant to protect."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.20, ry: 0.08, cx: 0.50, cy: 0.30),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.50, cy: 0.40)
        ]
    )

    static let dumbbellLateralRaiseContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "traps", label: "Shoulders down, no shrug",
                          labelPoint: CGPoint(x: 0.450, y: 0.14),
                          leaderLength: 40, joint: "support_TrapeziusUpper_L"),
            CueAnnotation(cueID: "plane", label: "Arms slightly forward",
                          labelPoint: CGPoint(x: 0.406, y: 0.32),
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "elbow", label: "Soft, fixed elbows",
                          labelPoint: CGPoint(x: 0.362, y: 0.50),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "height", label: "Stop at shoulder height",
                          labelPoint: CGPoint(x: 0.565, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "torso", label: "Torso still, no swing",
                          labelPoint: CGPoint(x: 0.594, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine")
        ],
        cues: [
            TechniqueCue(
                id: "traps",
                title: "Shoulder Position",
                intro: "A lateral raise is a deltoid exercise, not a shrug.",
                why: "Keeping the shoulders down stops the upper trapezius taking over the top of the lift.",
                mistake: "Shrugging the shoulders toward the ears as the dumbbells rise.",
                correct: "Keep the shoulder blades down and the neck long, and lead the movement with the elbows rather than the hands."
            ),
            TechniqueCue(
                id: "plane",
                title: "Arm Path",
                intro: "The arms rise slightly in front of the body, not straight out to the side.",
                why: "Raising the arms about 20–30° forward lines the lift up with the shoulder blade and keeps the joint comfortable.",
                mistake: "Pulling the arms back behind the body at the top, which pinches the shoulder.",
                correct: "Keep the dumbbells slightly in front of the hips on the way up, with the hands level — neither thumbs nor pinkies tipped up."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Bend",
                intro: "The arm is a fixed lever for the whole raise.",
                why: "A slight, constant elbow bend keeps the load on the lateral deltoid; bending further as you lift shortens the lever and hands the work to the traps.",
                mistake: "Bending the elbows more as the dumbbells rise, turning the raise into an upright row.",
                correct: "Set a soft bend in the elbows at the bottom and hold exactly that angle up and down."
            ),
            TechniqueCue(
                id: "height",
                title: "Range of Motion",
                intro: "The lateral deltoid does its work between the side of the body and shoulder height.",
                why: "Raising to about shoulder height loads the lateral deltoid fully; going higher shifts the effort onto the upper trapezius.",
                mistake: "Swinging the dumbbells up past the head, or stopping well short of shoulder level.",
                correct: "Raise until the arms are roughly parallel to the floor, pause briefly, then lower under control."
            ),
            TechniqueCue(
                id: "torso",
                title: "Torso Control",
                intro: "Momentum is the most common way to cheat this lift.",
                why: "A still torso makes the lateral deltoid lift the weight from a dead stop instead of borrowing speed from the hips.",
                mistake: "Rocking the torso to swing heavy dumbbells up.",
                correct: "Stand tall with soft knees, brace the core and raise the dumbbells without any body swing."
            )
        ],
        activation: [
            MuscleActivation(name: "Lateral Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88),
            MuscleActivation(name: "Posterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50),
            MuscleActivation(name: "Upper Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.45)
        ],
        stabilisers: ["rotator cuff", "serratus anterior", "core"],
        setup: [
            "Stand tall with a dumbbell in each hand at your sides.",
            "Feet hip-width, knees soft.",
            "Palms facing in, a slight bend in the elbows."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SHRUGGING UP",
            correctCue: "Shoulders down, arms to 90°",
            mistakeCue: "Traps shrug the weight up",
            correctNote: "With the shoulders held down, the lateral deltoid lifts the arm all the way to shoulder height.",
            mistakeNote: "Shrugging hands the top of the raise to the upper trapezius — which is why the traps often feel lateral raises more than the shoulders do."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.08, cx: 0.32, cy: 0.31),
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.08, cx: 0.68, cy: 0.31)
        ]
    )

    static let cableLateralRaiseContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "traps", label: "Shoulder down, no shrug",
                          labelPoint: CGPoint(x: 0.565, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "support_TrapeziusUpper_L"),
            CueAnnotation(cueID: "elbow", label: "Soft, fixed elbow",
                          labelPoint: CGPoint(x: 0.347, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "height", label: "Stop at shoulder height",
                          labelPoint: CGPoint(x: 0.435, y: 0.50),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "torso", label: "Stay upright, no lean",
                          labelPoint: CGPoint(x: 0.594, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "setup", label: "Side-on to the stack",
                          labelPoint: CGPoint(x: 0.609, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "traps",
                title: "Shoulder Position",
                intro: "The working shoulder stays down throughout.",
                why: "Keeping the shoulder blade down keeps the lateral deltoid, not the upper trapezius, lifting the arm.",
                mistake: "Hiking the shoulder toward the ear as the handle rises.",
                correct: "Keep the working shoulder down and the neck long, leading with the elbow."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Bend",
                intro: "The arm is a fixed lever for the whole raise.",
                why: "A slight, constant elbow bend keeps the cable's pull on the lateral deltoid and off the elbow joint.",
                mistake: "Bending the elbow as the handle rises, turning the raise into a pull.",
                correct: "Set a soft bend in the elbow at the bottom and hold it there on every rep."
            ),
            TechniqueCue(
                id: "height",
                title: "Range of Motion",
                intro: "The cable loads the whole arc, so use all of it.",
                why: "Unlike a dumbbell, the cable keeps tension on the lateral deltoid at the bottom of the rep, where a free weight loads it least.",
                mistake: "Stopping short at the bottom to rest, or yanking the handle above the head.",
                correct: "Let the handle travel in front of the body at the bottom, then raise until the arm is about parallel to the floor."
            ),
            TechniqueCue(
                id: "torso",
                title: "Torso Control",
                intro: "The body stays upright while the arm moves.",
                why: "An upright torso means the deltoid moves the load instead of body weight leaning away from the stack.",
                mistake: "Leaning away from the stack to swing the handle up.",
                correct: "Hold the frame lightly with the free hand, stand tall and brace so nothing moves but the arm."
            ),
            TechniqueCue(
                id: "setup",
                title: "Setup",
                intro: "Where you stand sets the line of pull.",
                why: "Standing side-on with the pulley low means the cable pulls straight down across the body, which is the direction the lateral deltoid resists.",
                mistake: "Facing the stack, or standing so close that the cable pulls the arm forward instead of down.",
                correct: "Set the pulley at its lowest point and stand side-on, a step away, holding the handle in the hand farthest from the stack."
            )
        ],
        activation: [
            MuscleActivation(name: "Lateral Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Posterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.46),
            MuscleActivation(name: "Upper Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.42)
        ],
        stabilisers: ["rotator cuff", "obliques", "core"],
        setup: [
            "Set the pulley at its lowest position.",
            "Stand side-on and take the handle in the far hand.",
            "Hold the frame with your free hand, handle in front of your hips."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "LEANING AWAY",
            correctCue: "Upright torso, arm to 90°",
            mistakeCue: "Torso leans away from the stack",
            correctNote: "Standing tall keeps the cable's pull on the lateral deltoid through the whole arc.",
            mistakeNote: "Leaning away shortens the arc and lets body weight swing the handle up, taking load off the lateral deltoid."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.08, cx: 0.66, cy: 0.31),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.06, cx: 0.60, cy: 0.26)
        ]
    )

    static let machineLateralRaiseContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "traps", label: "No shrugging",
                          labelPoint: CGPoint(x: 0.726, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "support_TrapeziusUpper_L"),
            CueAnnotation(cueID: "pivot", label: "Shoulders level with pivot",
                          labelPoint: CGPoint(x: 0.479, y: 0.32),
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "pads", label: "Push through the elbows",
                          labelPoint: CGPoint(x: 0.565, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "height", label: "Lift to shoulder height",
                          labelPoint: CGPoint(x: 0.435, y: 0.50),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "back", label: "Sit tall, chest up",
                          labelPoint: CGPoint(x: 0.638, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine")
        ],
        cues: [
            TechniqueCue(
                id: "traps",
                title: "Shoulder Position",
                intro: "The shoulders stay down while the arms rise.",
                why: "Shrugging lets the upper trapezius lift the pads; keeping the shoulders down keeps the lateral deltoid in charge.",
                mistake: "Shoulders creeping up toward the ears near the top.",
                correct: "Keep the shoulder blades down and the neck long through every rep."
            ),
            TechniqueCue(
                id: "pivot",
                title: "Seat Setup",
                intro: "A machine raise only works if its pivot lines up with the shoulder.",
                why: "With the shoulder joint level with the pivot, the pads travel the same arc as the arm and the lateral deltoid stays loaded throughout.",
                mistake: "A seat too low or too high, so the pads slide along the arms and the shoulders shrug to compensate.",
                correct: "Adjust the seat so the tops of the shoulders line up with the machine's pivot points."
            ),
            TechniqueCue(
                id: "pads",
                title: "Contact Point",
                intro: "Drive the movement from the elbows, not the hands.",
                why: "Pushing through the outsides of the arms keeps the lateral deltoid as the prime mover instead of the forearms pulling on the handles.",
                mistake: "Gripping the handles hard and pulling with the hands.",
                correct: "Hold the handles lightly and press the outsides of the arms into the pads as you raise."
            ),
            TechniqueCue(
                id: "height",
                title: "Range of Motion",
                intro: "Lift to shoulder height and no higher.",
                why: "The lateral deltoid does its work up to about 90° of abduction; above that the upper trapezius takes over.",
                mistake: "Driving the pads above shoulder height, or cutting reps short at the bottom.",
                correct: "Raise until the arms are level with the shoulders, pause, and lower under control."
            ),
            TechniqueCue(
                id: "back",
                title: "Posture",
                intro: "The torso stays still against the machine.",
                why: "A tall, still torso stops momentum from the hips starting each rep.",
                mistake: "Rocking back or slumping to heave the pads up.",
                correct: "Sit tall with the chest up and keep the torso still for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Lateral Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.84),
            MuscleActivation(name: "Upper Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.40),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.38)
        ],
        stabilisers: ["rotator cuff", "serratus anterior"],
        setup: [
            "Set the seat so your shoulders line up with the pivots.",
            "Sit tall with the pads against the outsides of your arms.",
            "Hold the handles lightly."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SHRUGGING UP",
            correctCue: "Shoulders down, arms to 90°",
            mistakeCue: "Traps shrug the pads up",
            correctNote: "Keeping the shoulders down lets the lateral deltoid lift the pads through the machine's full arc.",
            mistakeNote: "Shrugging hands the top of each rep to the upper trapezius and takes tension off the lateral deltoid."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.08, cx: 0.32, cy: 0.31),
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.08, cx: 0.68, cy: 0.31)
        ]
    )

    static let dumbbellFrontRaiseContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "height", label: "Stop at shoulder height",
                          labelPoint: CGPoint(x: 0.565, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "shoulder", label: "Shoulders down and back",
                          labelPoint: CGPoint(x: 0.565, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "elbow", label: "Soft, fixed elbows",
                          labelPoint: CGPoint(x: 0.362, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "torso", label: "No backward lean",
                          labelPoint: CGPoint(x: 0.668, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "stance", label: "Knees soft, feet hip-width",
                          labelPoint: CGPoint(x: 0.521, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "height",
                title: "Range of Motion",
                intro: "The anterior deltoid lifts the arm forward to about shoulder height.",
                why: "Raising to shoulder level trains the front deltoid through its working range; above that the upper trapezius and serratus take over.",
                mistake: "Swinging the dumbbells up to overhead height.",
                correct: "Lift until the arms are about parallel to the floor, pause, and lower slowly."
            ),
            TechniqueCue(
                id: "shoulder",
                title: "Shoulder Position",
                intro: "The shoulders stay set while the arms move.",
                why: "Keeping the shoulder blades down and back stops the shoulders rolling forward and the traps shrugging the weight up.",
                mistake: "Shoulders hunching forward and up as the dumbbells rise.",
                correct: "Set the shoulders down and back before the first rep and keep them there."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Arm Position",
                intro: "A long arm makes a long lever for the front deltoid.",
                why: "A soft, fixed elbow keeps the lever long and the stress off the elbow joint.",
                mistake: "Bending the elbows as the dumbbells rise, which shortens the lever and invites a swing.",
                correct: "Keep a slight bend in the elbows and hold it constant through the rep."
            ),
            TechniqueCue(
                id: "torso",
                title: "Torso Control",
                intro: "Only the arms should move.",
                why: "Leaning back uses body weight to start the lift and arches the lower back.",
                mistake: "Rocking the torso back to swing the dumbbells up.",
                correct: "Brace the core, squeeze the glutes and keep the torso vertical from the first rep to the last."
            ),
            TechniqueCue(
                id: "stance",
                title: "Base",
                intro: "A stable base makes a strict raise possible.",
                why: "Soft knees and hip-width feet absorb nothing and give the arms a still platform to lift from.",
                mistake: "Locked knees and a narrow stance that tips the body back as the weights come up.",
                correct: "Stand with the feet hip-width apart and the knees slightly bent."
            )
        ],
        activation: [
            MuscleActivation(name: "Anterior Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88),
            MuscleActivation(name: "Upper Pectoralis", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50),
            MuscleActivation(name: "Lateral Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.38)
        ],
        stabilisers: ["serratus anterior", "rotator cuff", "core"],
        setup: [
            "Stand with a dumbbell in each hand in front of your thighs.",
            "Palms facing your body, elbows softly bent.",
            "Feet hip-width, core braced."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SWINGING THE WEIGHT",
            correctCue: "Controlled lift to shoulder height",
            mistakeCue: "Hips swing the dumbbells up",
            correctNote: "A controlled raise to shoulder height keeps the front deltoid lifting the full weight.",
            mistakeNote: "Swinging with the hips and lower back moves the dumbbells with momentum and leaves the front deltoid doing little of the work."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.40, cy: 0.31),
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.60, cy: 0.31)
        ]
    )

    static let reverseDumbbellFlyContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "neck", label: "Neck neutral, chin tucked",
                          labelPoint: CGPoint(x: 0.536, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "head"),
            CueAnnotation(cueID: "elbow", label: "Soft, fixed elbows",
                          labelPoint: CGPoint(x: 0.638, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "path", label: "Arms out wide, not back",
                          labelPoint: CGPoint(x: 0.435, y: 0.68),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "hinge", label: "Hinge to near parallel",
                          labelPoint: CGPoint(x: 0.580, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "feet", label: "Knees soft, weight mid-foot",
                          labelPoint: CGPoint(x: 0.506, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "neck",
                title: "Head Position",
                intro: "The head stays in line with a bent-over spine.",
                why: "A neutral neck keeps the whole spine in line while the torso is bent over.",
                mistake: "Craning the head up to watch the mirror.",
                correct: "Keep the chin tucked and look at the floor a little ahead of the feet."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Bend",
                intro: "A fly keeps the arms long; a row bends them.",
                why: "A slight, locked elbow bend keeps a long lever on the rear deltoid; bending further turns the fly into a row for the lats and mid-back.",
                mistake: "Bending the elbows and pulling the dumbbells back like a row.",
                correct: "Hold a soft bend in the elbows and keep it constant through the rep."
            ),
            TechniqueCue(
                id: "path",
                title: "Arm Path",
                intro: "The arms travel out to the sides in a wide arc.",
                why: "Moving the arms out, perpendicular to the torso, is exactly what the posterior deltoid does; sweeping them back toward the hips hands the work to the lats.",
                mistake: "Sweeping the dumbbells back toward the hips.",
                correct: "Raise the dumbbells straight out to the sides until the upper arms are level with the torso."
            ),
            TechniqueCue(
                id: "hinge",
                title: "Torso Angle",
                intro: "The rear deltoids only work against gravity if the torso is bent over far enough.",
                why: "Hinging until the torso is close to parallel lines the arms' path up with the posterior deltoid's line of pull.",
                mistake: "Standing too upright, so the raise becomes a lateral raise for the side delts.",
                correct: "Push the hips back with soft knees and a flat back until the torso is roughly parallel to the floor."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base",
                intro: "The legs hold the hinge so the back doesn't have to.",
                why: "Soft knees and weight over mid-foot let the hips hold the position without the lower back tiring first.",
                mistake: "Locked knees and the weight rocking onto the toes.",
                correct: "Stand hip-width with the knees slightly bent and the weight balanced over mid-foot."
            )
        ],
        activation: [
            MuscleActivation(name: "Posterior Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Middle Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.58),
            MuscleActivation(name: "Lateral Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["erector spinae", "hamstrings", "forearms"],
        setup: [
            "Hold a dumbbell in each hand, palms facing in.",
            "Hinge forward until your torso is nearly parallel to the floor.",
            "Let the dumbbells hang under your chest, elbows soft."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ROWING THE WEIGHT",
            correctCue: "Arms sweep out wide",
            mistakeCue: "Elbows bend into a row",
            correctNote: "Long arms sweeping straight out to the sides keep the rear deltoid as the prime mover.",
            mistakeNote: "Bending the elbows and pulling back turns the fly into a row, shifting the work to the lats and mid-back."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.34, cy: 0.30),
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.66, cy: 0.30)
        ]
    )

    static let reversePecDeckContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "traps", label: "Shoulders down",
                          labelPoint: CGPoint(x: 0.697, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "support_TrapeziusUpper_L"),
            CueAnnotation(cueID: "seat", label: "Handles at shoulder height",
                          labelPoint: CGPoint(x: 0.521, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "elbow", label: "Soft, fixed elbows",
                          labelPoint: CGPoint(x: 0.362, y: 0.50),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "path", label: "Sweep out, not back",
                          labelPoint: CGPoint(x: 0.376, y: 0.68),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "chest", label: "Chest on the pad",
                          labelPoint: CGPoint(x: 0.668, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest")
        ],
        cues: [
            TechniqueCue(
                id: "traps",
                title: "Shoulder Position",
                intro: "The rear deltoids should move the handles, not the traps.",
                why: "Keeping the shoulders down limits the upper trapezius and keeps the effort on the posterior deltoid.",
                mistake: "Shrugging the shoulders up and back to finish each rep.",
                correct: "Keep the shoulder blades down and the neck long through the whole set."
            ),
            TechniqueCue(
                id: "seat",
                title: "Seat Height",
                intro: "The seat decides the angle of pull.",
                why: "With the handles at shoulder height the arms move in the horizontal plane where the posterior deltoid is the prime mover.",
                mistake: "A seat so high the arms pull downward, turning the movement into a row.",
                correct: "Set the seat so the handles line up with the shoulders when you hold them."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Bend",
                intro: "The arms stay long throughout.",
                why: "A slight, fixed elbow bend keeps the lever long on the rear deltoid.",
                mistake: "Bending the elbows to pull the handles back.",
                correct: "Hold the handles with a soft bend in the elbows and keep that angle on every rep."
            ),
            TechniqueCue(
                id: "path",
                title: "Arm Path",
                intro: "The handles travel out to the sides in a wide arc.",
                why: "Moving the arms out to the sides at shoulder height is horizontal abduction, the posterior deltoid's main job; pulling back toward the hips shifts work to the lats.",
                mistake: "Driving the elbows down and back.",
                correct: "Sweep the arms out until they line up with the torso, pause, and return under control."
            ),
            TechniqueCue(
                id: "chest",
                title: "Body Position",
                intro: "The pad keeps the torso out of the lift.",
                why: "With the chest on the pad, momentum can't start the rep and the rear deltoids work from a dead stop.",
                mistake: "Leaning back off the pad to heave the handles.",
                correct: "Keep the chest against the pad and the back still for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Posterior Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88),
            MuscleActivation(name: "Middle Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.56),
            MuscleActivation(name: "Lateral Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["rotator cuff", "lower trapezius", "forearms"],
        setup: [
            "Set the handles to the rear position, at shoulder height.",
            "Sit facing the machine with your chest against the pad.",
            "Grip the handles with straight arms."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SHRUGGING BACK",
            correctCue: "Shoulders down, arms sweep wide",
            mistakeCue: "Traps shrug the handles back",
            correctNote: "Keeping the shoulders down lets the rear deltoids sweep the handles through the machine's full arc.",
            mistakeNote: "Shrugging and squeezing the shoulder blades hard turns the movement into a trap exercise and cuts the rear deltoid's range."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.34, cy: 0.30),
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.66, cy: 0.30)
        ]
    )

    static let facePullContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "target", label: "Pull to the face",
                          labelPoint: CGPoint(x: 0.668, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "head"),
            CueAnnotation(cueID: "rotate", label: "Rotate hands back",
                          labelPoint: CGPoint(x: 0.653, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows high and wide",
                          labelPoint: CGPoint(x: 0.391, y: 0.50),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "scapula", label: "Squeeze the blades",
                          labelPoint: CGPoint(x: 0.638, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "scapula_L"),
            CueAnnotation(cueID: "stance", label: "Staggered, braced stance",
                          labelPoint: CGPoint(x: 0.450, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "target",
                title: "Pull Target",
                intro: "The rope comes to the face, not the chest.",
                why: "Pulling toward the eyes keeps the upper arms up and out, so the rear deltoids and external rotators do the work.",
                mistake: "Rowing the rope down to the chest, which turns it into a cable row for the lats.",
                correct: "Set the pulley at about upper-chest to face height and pull the middle of the rope toward the eyes."
            ),
            TechniqueCue(
                id: "rotate",
                title: "External Rotation",
                intro: "A face pull finishes with an outward rotation of the shoulders.",
                why: "Pulling the rope ends apart and turning the knuckles back trains the infraspinatus and teres minor, the rotator cuff muscles that balance heavy pressing.",
                mistake: "Stopping with the hands in front of the face and the forearms pointing forward.",
                correct: "Split the rope as it nears the face and finish with the hands beside the ears, knuckles pointing back."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Height",
                intro: "The elbows stay at or above shoulder height.",
                why: "High, wide elbows keep the pull horizontal for the posterior deltoid; low elbows turn it into a row.",
                mistake: "Elbows dropping below the hands and tucking into the sides.",
                correct: "Lead with the elbows, keeping them level with or slightly above the shoulders."
            ),
            TechniqueCue(
                id: "scapula",
                title: "Shoulder Blades",
                intro: "Let the shoulder blades move, under control.",
                why: "Drawing the shoulder blades together at the finish brings in the middle trapezius alongside the rear deltoids.",
                mistake: "Shoulders rounding forward throughout, or the rope yanked in with a jerk.",
                correct: "Squeeze the shoulder blades together at the end of each rep, then let them glide forward as the rope returns."
            ),
            TechniqueCue(
                id: "stance",
                title: "Stance",
                intro: "The body stays still while the arms pull.",
                why: "A staggered stance and braced trunk stop you leaning back and using body weight to move the stack.",
                mistake: "Leaning back further on every rep to keep the weight moving.",
                correct: "Stand with one foot slightly ahead, brace the core and keep the torso still."
            )
        ],
        activation: [
            MuscleActivation(name: "Posterior Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.82),
            MuscleActivation(name: "Middle Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.62),
            MuscleActivation(name: "Rotator Cuff", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50)
        ],
        stabilisers: ["lower trapezius", "biceps brachii", "core"],
        setup: [
            "Set the pulley at upper-chest to face height with a rope.",
            "Hold the rope ends with your palms facing each other.",
            "Step back until your arms are straight, feet staggered."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ROWING TO THE CHEST",
            correctCue: "Rope to the face, elbows high",
            mistakeCue: "Elbows drop, rope rows to the chest",
            correctNote: "Pulling high to the face with the elbows up keeps the rear deltoids and rotator cuff doing the work.",
            mistakeNote: "Letting the elbows drop and rowing to the chest turns the face pull into a row, so the lats take over from the rear deltoids."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.34, cy: 0.30),
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.66, cy: 0.30)
        ]
    )

    static let cableRearDeltFlyContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "traps", label: "Shoulders down",
                          labelPoint: CGPoint(x: 0.697, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "support_TrapeziusUpper_L"),
            CueAnnotation(cueID: "height", label: "Pull at shoulder height",
                          labelPoint: CGPoint(x: 0.435, y: 0.32),
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "elbow", label: "Arms long, soft elbows",
                          labelPoint: CGPoint(x: 0.420, y: 0.50),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "path", label: "Sweep out, not down",
                          labelPoint: CGPoint(x: 0.376, y: 0.68),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "stance", label: "Stand tall, feet planted",
                          labelPoint: CGPoint(x: 0.550, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "traps",
                title: "Shoulder Position",
                intro: "The shoulders stay down as the arms open.",
                why: "Keeping the shoulders down stops the upper trapezius taking the load off the rear deltoids.",
                mistake: "Shrugging up and back at the end of every rep.",
                correct: "Keep the shoulder blades down and the neck long throughout."
            ),
            TechniqueCue(
                id: "height",
                title: "Setup",
                intro: "The pulleys set the plane of the movement.",
                why: "With the pulleys at shoulder height and the cables crossed, the rear deltoids are loaded from a stretched start all the way to the finish.",
                mistake: "Pulleys set low, so the arms pull downward like a straight-arm pulldown.",
                correct: "Set both pulleys at shoulder height, take the left handle in the right hand and the right in the left, and step back to the middle."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Bend",
                intro: "The arms stay long; bending them makes it a row.",
                why: "A slight, fixed elbow bend keeps the lever long on the posterior deltoid.",
                mistake: "Bending the elbows to pull the handles in.",
                correct: "Hold a soft bend in the elbows and keep it constant through each rep."
            ),
            TechniqueCue(
                id: "path",
                title: "Arm Path",
                intro: "The hands travel out to the sides at shoulder height.",
                why: "Horizontal abduction at shoulder height is the posterior deltoid's main job; letting the hands drop turns the pull toward the lats.",
                mistake: "Hands dipping down toward the hips as the cables open.",
                correct: "Sweep the arms out wide until they line up with the torso, pause, and return slowly."
            ),
            TechniqueCue(
                id: "stance",
                title: "Stance",
                intro: "Only the arms should move.",
                why: "A tall, braced stance stops you leaning back to move the stack.",
                mistake: "Rocking the torso back to finish each rep.",
                correct: "Stand tall with the feet planted about hip-width apart and the core braced."
            )
        ],
        activation: [
            MuscleActivation(name: "Posterior Deltoid", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Middle Trapezius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.54),
            MuscleActivation(name: "Lateral Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["rotator cuff", "lower trapezius", "core"],
        setup: [
            "Set both pulleys at shoulder height.",
            "Cross the cables: left handle in your right hand, right in your left.",
            "Step back to the middle with your arms straight in front."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SHRUGGING BACK",
            correctCue: "Arms sweep out at shoulder height",
            mistakeCue: "Shoulders shrug the cables back",
            correctNote: "Long arms sweeping out at shoulder height keep the rear deltoids doing the work.",
            mistakeNote: "Shrugging and pulling the handles down and back hands the movement to the traps and lats."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.34, cy: 0.30),
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.08, cx: 0.66, cy: 0.30)
        ]
    )

    // MARK: - Arm content (2026-09-24)
    //
    // Same label layout method as the shoulders above.
    //
    // Triceps ranks and cues follow the ACE-sponsored triceps study
    // (Boehler, Porcari et al. 2011: dips 87% and overhead extensions 76% of
    // the triangle push-up, rope pushdowns 74%, bar pushdowns 67%, lying
    // extensions 62% — pushdowns lose ground mostly to momentum), the
    // finding that overhead elbow extension grows the triceps ~40% more than
    // pushdowns because the long head is lengthened (Maeo et al. 2023, Eur J
    // Sport Sci), and a 3D/EMG comparison of dips showing the bench dip
    // drives the shoulder to ~101% of its own extension range while the bar
    // dip draws more chest and front-deltoid activity (McKenzie et al. 2022,
    // IJERPH) — hence the 90° depth cue on the bench dip and the chest and
    // anterior deltoid rows on the assisted dip. The barbell curl's shoulder
    // cue reflects the ACE biceps study (Porcari et al. 2014), where the
    // barbell curl drew significantly more anterior-deltoid activity than
    // the strict curl variations.

    static let barbellCurlContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "shoulder", label: "Shoulders stay back",
                          labelPoint: CGPoint(x: 0.624, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows pinned to sides",
                          labelPoint: CGPoint(x: 0.420, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "grip", label: "Shoulder-width grip",
                          labelPoint: CGPoint(x: 0.624, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "torso", label: "No hip swing",
                          labelPoint: CGPoint(x: 0.726, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "range", label: "Lower all the way down",
                          labelPoint: CGPoint(x: 0.420, y: 0.68),
                          leaderLength: 40, joint: "hand_R")
        ],
        cues: [
            TechniqueCue(
                id: "shoulder",
                title: "Shoulder Position",
                intro: "The shoulders stay back and still.",
                why: "Rolling the shoulders forward to finish the curl brings the front deltoid in and takes tension off the biceps.",
                mistake: "Shoulders rounding forward and the bar drifting away from the body at the top.",
                correct: "Keep the chest up and the shoulders back, and stop the curl before the elbows start to travel forward."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The elbows are the hinge of a curl, and a hinge doesn't move.",
                why: "Keeping the elbows by the sides makes elbow flexion the only motion, so the biceps and brachialis lift the bar instead of the front deltoids.",
                mistake: "Elbows drifting forward as the bar rises, which shortens the range and hands the top of the rep to the shoulders.",
                correct: "Pin the elbows lightly against the ribs and keep them there from the bottom of the rep to the top."
            ),
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "Hand position changes how hard the biceps work.",
                why: "A shoulder-width underhand grip keeps the forearms fully supinated, the position in which the biceps brachii is strongest.",
                mistake: "A grip so narrow or wide that the wrists bend and the forearms fatigue first.",
                correct: "Hold the bar palms-up with the hands about shoulder-width apart and the wrists straight."
            ),
            TechniqueCue(
                id: "torso",
                title: "Body Swing",
                intro: "The legs and back have no part in a strict curl.",
                why: "Swinging the hips uses momentum from the legs and lower back and loads the spine.",
                mistake: "Rocking the hips forward and the torso back to heave the bar up.",
                correct: "Stand tall with soft knees, brace the core and keep the torso still for every rep."
            ),
            TechniqueCue(
                id: "range",
                title: "Range of Motion",
                intro: "Each rep starts from straight arms.",
                why: "Lowering to fully straight arms trains the biceps through its whole length, and a slow lowering phase adds time under tension.",
                mistake: "Half reps that never let the elbows straighten.",
                correct: "Lower over two to three seconds until the arms are straight, then curl again without bouncing."
            )
        ],
        activation: [
            MuscleActivation(name: "Biceps Brachii", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.90),
            MuscleActivation(name: "Brachialis", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.66),
            MuscleActivation(name: "Brachioradialis", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.52)
        ],
        stabilisers: ["anterior deltoid", "forearm flexors", "core"],
        setup: [
            "Hold the bar underhand, hands shoulder-width apart.",
            "Stand tall with straight arms, the bar against your thighs.",
            "Elbows by your sides, knees soft."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SWINGING THE BAR",
            correctCue: "Elbows fixed, torso still",
            mistakeCue: "Hips and back swing the bar up",
            correctNote: "With the elbows fixed and the torso still, the biceps lift the bar through the whole range.",
            mistakeNote: "Swinging uses the hips and lower back to start the rep, so the biceps skip the hardest part of the lift and the spine takes the strain."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.10, ry: 0.08, cx: 0.30, cy: 0.40),
            .init(DS.activation.opacity(0.55), rx: 0.10, ry: 0.08, cx: 0.70, cy: 0.40)
        ]
    )

    static let tricepsPushdownContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "shoulder", label: "Shoulders down and back",
                          labelPoint: CGPoint(x: 0.565, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows pinned to sides",
                          labelPoint: CGPoint(x: 0.420, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "lockout", label: "Full lockout at the bottom",
                          labelPoint: CGPoint(x: 0.521, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "torso", label: "Slight forward lean",
                          labelPoint: CGPoint(x: 0.624, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "feet", label: "Hip-width, knees soft",
                          labelPoint: CGPoint(x: 0.594, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "shoulder",
                title: "Shoulder Position",
                intro: "The shoulders stay set so the arms can do the work.",
                why: "Rolling the shoulders forward and leaning over the handle lets body weight push it down.",
                mistake: "Hunching over the handle and shrugging the shoulders up.",
                correct: "Keep the chest up and the shoulders down and back."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The elbows are pinned; only the forearms move.",
                why: "Pinned elbows make elbow extension the only motion, so the triceps move the load; elbows that drift forward bring the lats, chest and shoulders in.",
                mistake: "Elbows lifting and flaring forward as the handle comes up.",
                correct: "Tuck the elbows against the sides of the torso and keep them there for the whole set."
            ),
            TechniqueCue(
                id: "lockout",
                title: "Lockout",
                intro: "Every rep finishes with straight arms.",
                why: "The triceps reach full contraction at full elbow extension, so cutting reps short skips the hardest part of the lift.",
                mistake: "Stopping each rep with the elbows still bent.",
                correct: "Push down until the arms are fully straight, pause briefly, then let the handle rise under control."
            ),
            TechniqueCue(
                id: "torso",
                title: "Torso Angle",
                intro: "A slight lean gives the cable a clear path.",
                why: "Hinging a little forward from the hips lets the handle travel straight down past the body without catching on the torso.",
                mistake: "Leaning further on every rep to push the stack with body weight.",
                correct: "Hinge slightly forward, brace the core and hold that angle for the whole set."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base",
                intro: "A still base keeps the body out of the lift.",
                why: "A hip-width stance with soft knees gives a stable platform, so the triceps work against the full load.",
                mistake: "Standing so close to the stack that the body sways with each rep.",
                correct: "Stand hip-width, about a foot from the stack, with the knees slightly bent."
            )
        ],
        activation: [
            MuscleActivation(name: "Triceps Brachii", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86)
        ],
        stabilisers: ["latissimus dorsi", "forearms", "core"],
        setup: [
            "Attach a straight bar to a high pulley.",
            "Grip it overhand with your hands shoulder-width apart.",
            "Elbows at your sides, lean slightly forward."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ELBOWS FLARING",
            correctCue: "Elbows fixed at the sides",
            mistakeCue: "Elbows lift and flare forward",
            correctNote: "With the elbows pinned, the triceps extend the elbow against the whole stack.",
            mistakeNote: "Letting the elbows drift forward brings the lats and chest into the push and takes load off the triceps."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.30, cy: 0.38),
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.70, cy: 0.38)
        ]
    )

    static let ropePushdownContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "shoulder", label: "Shoulders down and back",
                          labelPoint: CGPoint(x: 0.565, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows pinned to sides",
                          labelPoint: CGPoint(x: 0.420, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "split", label: "Spread the rope at the bottom",
                          labelPoint: CGPoint(x: 0.523, y: 0.50),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "torso", label: "Slight forward lean",
                          labelPoint: CGPoint(x: 0.624, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "feet", label: "Hip-width, knees soft",
                          labelPoint: CGPoint(x: 0.594, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "shoulder",
                title: "Shoulder Position",
                intro: "The shoulders stay set so the arms can do the work.",
                why: "Rolling the shoulders forward and leaning over the handle lets body weight push it down.",
                mistake: "Hunching over the handle and shrugging the shoulders up.",
                correct: "Keep the chest up and the shoulders down and back."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The elbows are pinned; only the forearms move.",
                why: "Pinned elbows make elbow extension the only motion, so the triceps move the load; elbows that drift forward bring the lats, chest and shoulders in.",
                mistake: "Elbows lifting and flaring forward as the handle comes up.",
                correct: "Tuck the elbows against the sides of the torso and keep them there for the whole set."
            ),
            TechniqueCue(
                id: "split",
                title: "Rope Split",
                intro: "The rope lets the hands finish wider than a bar.",
                why: "Pulling the rope ends apart at the bottom lets the hands pass the thighs, so the elbows reach full extension.",
                mistake: "Keeping the hands together so the rope stops against the thighs short of lockout.",
                correct: "As the hands pass the waist, spread the rope ends apart and finish with the arms fully straight."
            ),
            TechniqueCue(
                id: "torso",
                title: "Torso Angle",
                intro: "A slight lean gives the cable a clear path.",
                why: "Hinging a little forward from the hips lets the handle travel straight down past the body without catching on the torso.",
                mistake: "Leaning further on every rep to push the stack with body weight.",
                correct: "Hinge slightly forward, brace the core and hold that angle for the whole set."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base",
                intro: "A still base keeps the body out of the lift.",
                why: "A hip-width stance with soft knees gives a stable platform, so the triceps work against the full load.",
                mistake: "Standing so close to the stack that the body sways with each rep.",
                correct: "Stand hip-width, about a foot from the stack, with the knees slightly bent."
            )
        ],
        activation: [
            MuscleActivation(name: "Triceps Brachii", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88)
        ],
        stabilisers: ["latissimus dorsi", "forearms", "core"],
        setup: [
            "Attach a rope to a high pulley.",
            "Grip the rope ends with your palms facing each other.",
            "Elbows at your sides, lean slightly forward."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "CUTTING THE LOCKOUT",
            correctCue: "Rope split, arms straight",
            mistakeCue: "Hands stop at the thighs",
            correctNote: "Splitting the rope at the bottom lets the elbows straighten fully, where the triceps contract hardest.",
            mistakeNote: "Stopping with the rope against the thighs leaves the elbows bent and skips the triceps' strongest contraction."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.30, cy: 0.38),
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.70, cy: 0.38)
        ]
    )

    static let singleArmCablePushdownContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "shoulder", label: "Shoulder stays down",
                          labelPoint: CGPoint(x: 0.624, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "elbow", label: "Elbow pinned to the side",
                          labelPoint: CGPoint(x: 0.450, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "lockout", label: "Full lockout at the bottom",
                          labelPoint: CGPoint(x: 0.479, y: 0.50),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "hips", label: "Hips square, no twist",
                          labelPoint: CGPoint(x: 0.594, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "feet", label: "Hip-width, knees soft",
                          labelPoint: CGPoint(x: 0.406, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "shoulder",
                title: "Shoulder Position",
                intro: "The shoulders stay set so the arms can do the work.",
                why: "Rolling the shoulders forward and leaning over the handle lets body weight push it down.",
                mistake: "Hunching over the handle and shrugging the shoulders up.",
                correct: "Keep the chest up and the shoulders down and back."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The elbows are pinned; only the forearms move.",
                why: "Pinned elbows make elbow extension the only motion, so the triceps move the load; elbows that drift forward bring the lats, chest and shoulders in.",
                mistake: "Elbows lifting and flaring forward as the handle comes up.",
                correct: "Tuck the elbows against the sides of the torso and keep them there for the whole set."
            ),
            TechniqueCue(
                id: "lockout",
                title: "Lockout",
                intro: "Every rep finishes with straight arms.",
                why: "The triceps reach full contraction at full elbow extension, so cutting reps short skips the hardest part of the lift.",
                mistake: "Stopping each rep with the elbows still bent.",
                correct: "Push down until the arms are fully straight, pause briefly, then let the handle rise under control."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hips & Torso",
                intro: "Working one arm at a time invites a twist.",
                why: "Keeping the hips and shoulders square stops the torso rotating to push the handle down, so one triceps does all the work.",
                mistake: "Twisting the torso toward the working side to finish each rep.",
                correct: "Face the stack squarely, brace the core and keep the free hand on the hip or the frame."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base",
                intro: "A still base keeps the body out of the lift.",
                why: "A hip-width stance with soft knees gives a stable platform, so the triceps work against the full load.",
                mistake: "Standing so close to the stack that the body sways with each rep.",
                correct: "Stand hip-width, about a foot from the stack, with the knees slightly bent."
            )
        ],
        activation: [
            MuscleActivation(name: "Triceps Brachii", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86)
        ],
        stabilisers: ["obliques", "latissimus dorsi", "forearms"],
        setup: [
            "Attach a single handle to a high pulley.",
            "Grip it with one hand, palm down.",
            "Elbow at your side, free hand on your hip."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "TWISTING THE TORSO",
            correctCue: "Hips square, elbow pinned",
            mistakeCue: "Torso twists to push the handle",
            correctNote: "Staying square to the stack keeps the working triceps moving the whole load on its own.",
            mistakeNote: "Twisting the torso uses body rotation to push the handle and hides a strength difference between arms."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.70, cy: 0.38),
            .init(DS.activationSoft.opacity(0.25), rx: 0.08, ry: 0.08, cx: 0.30, cy: 0.38)
        ]
    )

    static let overheadCableTricepsExtensionContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "stretch", label: "Deep stretch behind the head",
                          labelPoint: CGPoint(x: 0.508, y: 0.14),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows point forward",
                          labelPoint: CGPoint(x: 0.609, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "upperarm", label: "Upper arms by the ears",
                          labelPoint: CGPoint(x: 0.580, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "brace", label: "Ribs down, no arch",
                          labelPoint: CGPoint(x: 0.638, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "stance", label: "Staggered stance",
                          labelPoint: CGPoint(x: 0.668, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "stretch",
                title: "Stretch Position",
                intro: "The overhead position is what sets this lift apart.",
                why: "With the arms overhead, the long head of the triceps — which crosses the shoulder — is stretched, and training at that length has been shown to grow the triceps more than pushdowns.",
                mistake: "Shortening the range so the hands never drop behind the head.",
                correct: "Lower the hands behind the head until the elbows are fully bent, then extend back to straight arms."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The elbows point forward, not out.",
                why: "Keeping the elbows close to the head and pointing forward holds the upper arm still, so only the elbow bends; flared elbows shift the load to the shoulders.",
                mistake: "Elbows splaying out to the sides as the weight lowers.",
                correct: "Keep the elbows about shoulder-width, pointing forward, from the bottom of the rep to the top."
            ),
            TechniqueCue(
                id: "upperarm",
                title: "Upper Arm Position",
                intro: "The upper arms stay fixed beside the head.",
                why: "Still upper arms keep the work on elbow extension; letting them swing forward turns the lift into a pullover.",
                mistake: "Upper arms dropping forward as the weight comes up.",
                correct: "Keep the upper arms close to the ears and let only the forearms move."
            ),
            TechniqueCue(
                id: "brace",
                title: "Trunk Control",
                intro: "Reaching overhead tempts the lower back to arch.",
                why: "Keeping the ribs down and the core braced stops the lower back arching to make room for the weight.",
                mistake: "Arching the lower back and flaring the ribs to get the arms overhead.",
                correct: "Brace the abs, squeeze the glutes and keep the ribs stacked over the pelvis."
            ),
            TechniqueCue(
                id: "stance",
                title: "Stance",
                intro: "A stable stance keeps the body out of the lift.",
                why: "A split or hip-width stance with soft knees gives the arms a still base to extend from.",
                mistake: "Locked knees and a narrow stance that sways with each rep.",
                correct: "Stand with the feet hip-width or one foot forward, knees soft, and hold that position."
            )
        ],
        activation: [
            MuscleActivation(name: "Triceps Brachii", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88)
        ],
        stabilisers: ["core", "rotator cuff", "serratus anterior"],
        setup: [
            "Attach a rope to a low pulley.",
            "Face away from the stack with the rope behind your head.",
            "Staggered stance, elbows pointing forward."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ELBOWS FLARED",
            correctCue: "Elbows forward, upper arms fixed",
            mistakeCue: "Elbows splay out to the sides",
            correctNote: "With the elbows forward and the upper arms still, the triceps extend the elbow from a full stretch.",
            mistakeNote: "Flared elbows shorten the triceps' stretch and shift load onto the shoulders."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.36, cy: 0.26),
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.64, cy: 0.26)
        ]
    )

    static let dumbbellOverheadTricepsExtensionContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "grip", label: "Cup the top plate",
                          labelPoint: CGPoint(x: 0.653, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows point forward",
                          labelPoint: CGPoint(x: 0.609, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "upperarm", label: "Upper arms by the ears",
                          labelPoint: CGPoint(x: 0.580, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "brace", label: "Ribs down, no arch",
                          labelPoint: CGPoint(x: 0.362, y: 0.68),
                          leaderLength: 40, joint: "spine"),
            CueAnnotation(cueID: "stance", label: "Feet hip-width, knees soft",
                          labelPoint: CGPoint(x: 0.479, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "grip",
                title: "Grip",
                intro: "Two hands hold one dumbbell.",
                why: "Cupping the top plate with both palms keeps the dumbbell secure and the wrists straight overhead.",
                mistake: "Gripping the handle loosely with the fingers, so the dumbbell tips as it lowers.",
                correct: "Hold the dumbbell vertically by its top plate, palms flat against it and thumbs wrapped around the handle."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The elbows point forward, not out.",
                why: "Keeping the elbows close to the head and pointing forward holds the upper arm still, so only the elbow bends; flared elbows shift the load to the shoulders.",
                mistake: "Elbows splaying out to the sides as the weight lowers.",
                correct: "Keep the elbows about shoulder-width, pointing forward, from the bottom of the rep to the top."
            ),
            TechniqueCue(
                id: "upperarm",
                title: "Upper Arm Position",
                intro: "The upper arms stay fixed beside the head.",
                why: "Still upper arms keep the work on elbow extension; letting them swing forward turns the lift into a pullover.",
                mistake: "Upper arms dropping forward as the weight comes up.",
                correct: "Keep the upper arms close to the ears and let only the forearms move."
            ),
            TechniqueCue(
                id: "brace",
                title: "Trunk Control",
                intro: "Reaching overhead tempts the lower back to arch.",
                why: "Keeping the ribs down and the core braced stops the lower back arching to make room for the weight.",
                mistake: "Arching the lower back and flaring the ribs to get the arms overhead.",
                correct: "Brace the abs, squeeze the glutes and keep the ribs stacked over the pelvis."
            ),
            TechniqueCue(
                id: "stance",
                title: "Stance",
                intro: "A stable stance keeps the body out of the lift.",
                why: "A split or hip-width stance with soft knees gives the arms a still base to extend from.",
                mistake: "Locked knees and a narrow stance that sways with each rep.",
                correct: "Stand with the feet hip-width or one foot forward, knees soft, and hold that position."
            )
        ],
        activation: [
            MuscleActivation(name: "Triceps Brachii", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88)
        ],
        stabilisers: ["core", "rotator cuff", "forearms"],
        setup: [
            "Hold one dumbbell with both hands under its top plate.",
            "Press it overhead to straight arms.",
            "Feet hip-width, ribs down, core braced."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ARCHING THE BACK",
            correctCue: "Ribs down, upper arms fixed",
            mistakeCue: "Lower back arches overhead",
            correctNote: "A braced trunk lets the arms stay overhead while only the elbows move.",
            mistakeNote: "Arching the lower back to reach overhead shortens the triceps' stretch and loads the lumbar spine."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.36, cy: 0.26),
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.64, cy: 0.26)
        ]
    )

    static let skullCrusherContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "elbow", label: "Elbows fixed, pointing up",
                          labelPoint: CGPoint(x: 0.464, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "bar", label: "Bar to the forehead",
                          labelPoint: CGPoint(x: 0.624, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "upperarm", label: "Upper arms tilted back",
                          labelPoint: CGPoint(x: 0.580, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "back", label: "Hips on bench",
                          labelPoint: CGPoint(x: 0.288, y: 0.50),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "feet", label: "Feet flat on the floor",
                          labelPoint: CGPoint(x: 0.420, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "Only the elbows bend.",
                why: "Fixed upper arms make elbow extension the only motion, so the triceps do the work instead of the lats and chest.",
                mistake: "Elbows flaring wide as the bar lowers, or the upper arms swinging to help press it back up.",
                correct: "Keep the elbows about shoulder-width and pointing at the ceiling for every rep."
            ),
            TechniqueCue(
                id: "bar",
                title: "Bar Path",
                intro: "The bar travels in an arc toward the head.",
                why: "Lowering the bar to the forehead or just behind it takes the triceps through a long range while keeping the path controlled.",
                mistake: "Dropping the bar quickly toward the face.",
                correct: "Lower the bar slowly to the forehead or just behind the head, then extend the elbows to bring it back."
            ),
            TechniqueCue(
                id: "upperarm",
                title: "Arm Angle",
                intro: "The upper arms lean slightly back toward the head.",
                why: "Tilting the upper arms back keeps tension on the triceps at the top, where vertical arms let the bones take the load.",
                mistake: "Upper arms vertical at lockout, so the triceps rest between reps.",
                correct: "Start with the arms angled slightly back from vertical and keep that angle throughout."
            ),
            TechniqueCue(
                id: "back",
                title: "Body Position",
                intro: "The body stays flat and still on the bench.",
                why: "Keeping the hips and upper back on the bench prevents arching and keeps the triceps working against the whole load.",
                mistake: "Lifting the hips or arching the back as the reps get hard.",
                correct: "Keep the head, upper back and hips in contact with the bench throughout."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base",
                intro: "The feet anchor the body to the floor.",
                why: "Flat feet give a stable base so the body doesn't shift as the bar moves overhead.",
                mistake: "Feet up on the bench edge or on the toes.",
                correct: "Plant both feet flat on the floor, about hip-width apart."
            )
        ],
        activation: [
            MuscleActivation(name: "Triceps Brachii", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86)
        ],
        stabilisers: ["latissimus dorsi", "forearms", "rotator cuff"],
        setup: [
            "Lie on a flat bench with your feet flat on the floor.",
            "Hold an EZ bar with a narrow overhand grip.",
            "Press it up, arms tilted slightly back toward your head."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ELBOWS FLARING OUT",
            correctCue: "Elbows narrow and fixed",
            mistakeCue: "Elbows splay wide as the bar lowers",
            correctNote: "Narrow, fixed elbows keep the triceps extending the elbow in a clean arc.",
            mistakeNote: "Flared elbows turn the lift into a press, shifting the load onto the chest and shoulders."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.50, cy: 0.30)
        ]
    )

    static let benchDipContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "elbow", label: "Elbows point straight back",
                          labelPoint: CGPoint(x: 0.479, y: 0.32),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "depth", label: "Stop at 90° elbow bend",
                          labelPoint: CGPoint(x: 0.580, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_L"),
            CueAnnotation(cueID: "hips", label: "Hips close to the bench",
                          labelPoint: CGPoint(x: 0.565, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "hands", label: "Hands by the hips",
                          labelPoint: CGPoint(x: 0.347, y: 0.50),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "feet", label: "Legs out, heels down",
                          labelPoint: CGPoint(x: 0.391, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The elbows track straight back, not out.",
                why: "Elbows pointing back keep the triceps extending the elbow in line and spare the shoulder a twisting load.",
                mistake: "Elbows flaring out to the sides as the body lowers.",
                correct: "Keep the elbows pointing straight behind you and close to the body throughout."
            ),
            TechniqueCue(
                id: "depth",
                title: "Depth",
                intro: "The bench dip takes the shoulder close to the end of its range.",
                why: "Bench dips extend the shoulder further than bar dips, so stopping with the upper arms about parallel to the floor keeps the front of the shoulder out of a vulnerable stretch.",
                mistake: "Dropping as low as possible, rolling the shoulders forward at the bottom.",
                correct: "Lower until the elbows reach about 90°, then press back up to straight arms."
            ),
            TechniqueCue(
                id: "hips",
                title: "Body Position",
                intro: "The body lowers straight down, close to the bench.",
                why: "Keeping the hips close to the bench keeps the load on the triceps rather than turning the dip into a shoulder stretch.",
                mistake: "Letting the hips drift away from the bench as you lower.",
                correct: "Slide the hips off the bench just enough to clear it and keep the back close to it throughout."
            ),
            TechniqueCue(
                id: "hands",
                title: "Hand Position",
                intro: "The hands set the shoulder position.",
                why: "Hands beside the hips with the fingers forward keep the shoulders in a stable, neutral position.",
                mistake: "Hands set wide or turned out, which rotates the shoulders.",
                correct: "Place the hands shoulder-width on the bench edge, beside the hips, fingers pointing forward."
            ),
            TechniqueCue(
                id: "feet",
                title: "Leg Position",
                intro: "The legs control how much body weight the arms lift.",
                why: "Straighter legs put more load on the triceps; bent knees make the dip easier.",
                mistake: "Pushing off the heels to help the arms up.",
                correct: "Set the legs out with the heels down, bending the knees more if you need it easier, and keep them passive."
            )
        ],
        activation: [
            MuscleActivation(name: "Triceps Brachii", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.46)
        ],
        stabilisers: ["pectoralis major", "serratus anterior", "core"],
        setup: [
            "Sit on the edge of a bench, hands beside your hips.",
            "Fingers forward, slide your hips off the bench.",
            "Legs out with heels on the floor, arms straight."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "DIPPING TOO DEEP",
            correctCue: "Stop at a 90° elbow bend",
            mistakeCue: "Shoulders roll forward past 90°",
            correctNote: "Stopping with the upper arms parallel to the floor loads the triceps through a full, safe range.",
            mistakeNote: "Dipping past 90° forces the shoulder into extreme extension and rolls it forward, straining the front of the joint."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.34, cy: 0.36),
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.66, cy: 0.36)
        ]
    )

    static let assistedDipContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "torso", label: "Torso upright",
                          labelPoint: CGPoint(x: 0.712, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "depth", label: "Lower to a 90° elbow bend",
                          labelPoint: CGPoint(x: 0.536, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "upper_arm_R"),
            CueAnnotation(cueID: "elbow", label: "Elbows tucked back",
                          labelPoint: CGPoint(x: 0.362, y: 0.32),
                          leaderLength: 40, joint: "forearm_R"),
            CueAnnotation(cueID: "lockout", label: "Press to full lockout",
                          labelPoint: CGPoint(x: 0.406, y: 0.68),
                          leaderLength: 40, joint: "hand_R"),
            CueAnnotation(cueID: "knees", label: "Knees centred on the pad",
                          labelPoint: CGPoint(x: 0.550, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_R")
        ],
        cues: [
            TechniqueCue(
                id: "torso",
                title: "Torso Angle",
                intro: "How far you lean decides which muscle leads.",
                why: "An upright torso keeps the triceps as the prime mover; leaning forward shifts more of the work to the chest.",
                mistake: "Pitching forward over the handles on every rep.",
                correct: "Keep the chest up and the torso close to vertical as you lower and press."
            ),
            TechniqueCue(
                id: "depth",
                title: "Depth",
                intro: "Go deep enough to load the triceps, not the shoulder joint.",
                why: "Lowering until the upper arms are about parallel to the floor trains the triceps through a full range without over-stretching the front of the shoulder.",
                mistake: "Sinking far below 90° with the shoulders rolling forward.",
                correct: "Lower until the elbows reach about 90°, then press back up."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "The elbows travel straight back.",
                why: "Elbows tucked close to the body keep the triceps working in line and the shoulders stable.",
                mistake: "Elbows flaring out to the sides at the bottom.",
                correct: "Keep the elbows pointing back and close to the torso throughout."
            ),
            TechniqueCue(
                id: "lockout",
                title: "Lockout",
                intro: "Each rep finishes with straight arms.",
                why: "Full elbow extension at the top is where the triceps contract hardest.",
                mistake: "Stopping short of lockout and bouncing out of the bottom.",
                correct: "Press until the arms are straight and the shoulders are down, then lower under control."
            ),
            TechniqueCue(
                id: "knees",
                title: "Machine Setup",
                intro: "The assistance pad takes some of your body weight.",
                why: "More counterweight makes the dip easier, so you can pick an amount that allows clean reps through the full range.",
                mistake: "Using so little assistance that form breaks down, or kneeling off-centre so the pad tips.",
                correct: "Kneel centred on the pad, choose an assistance weight that lets you reach 90° with control, and reduce it as you get stronger."
            )
        ],
        activation: [
            MuscleActivation(name: "Triceps Brachii", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.84),
            MuscleActivation(name: "Pectoralis Major", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.56),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.48)
        ],
        stabilisers: ["serratus anterior", "latissimus dorsi", "rotator cuff"],
        setup: [
            "Select an assistance weight on the stack.",
            "Grip the dip handles and kneel on the pad.",
            "Start with straight arms, shoulders down."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SHOULDERS ROLL FORWARD",
            correctCue: "Chest up, shoulders back",
            mistakeCue: "Shoulders roll forward at the bottom",
            correctNote: "Keeping the chest up and shoulders back lets the triceps press through a full, controlled range.",
            mistakeNote: "Letting the shoulders roll forward at the bottom stretches the front of the joint and shifts the effort away from the triceps."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.09, ry: 0.10, cx: 0.34, cy: 0.36),
            .init(DS.activationSoft.opacity(0.30), rx: 0.16, ry: 0.08, cx: 0.50, cy: 0.30)
        ]
    )

    // MARK: - Remaining leg content (2026-09-24)
    //
    // Same label layout method as the shoulders above. Both use the older
    // `.standing` preset framing, seen from the front, which hides the rear
    // foot behind the body — so no cue tracks it; the rear-foot advice
    // lives in the foot-setup and rear-leg cues instead.
    //
    // Ranks follow sEMG data: the rear-foot-elevated split squat matches the
    // split squat and single-leg squat for gluteus maximus and vastus
    // lateralis activity (Mausehund et al. 2019, JSCR), and a ~40° forward
    // trunk lean raises gluteus maximus, biceps femoris and rectus femoris
    // activity while the vasti stay unchanged (Bulgarian split squat
    // variations, 2025, PMC12382192) — so the lean variation keeps the
    // quadriceps as the largest contributor but lifts the glutes and
    // hamstrings. Cues follow the NSCA and ACE exercise descriptions.

    static let bulgarianSplitSquatContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "torso", label: "Torso upright",
                          labelPoint: CGPoint(x: 0.712, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "grip", label: "Dumbbells at your sides",
                          labelPoint: CGPoint(x: 0.565, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "knee", label: "Front knee tracks the toes",
                          labelPoint: CGPoint(x: 0.521, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "depth", label: "Back knee toward the floor",
                          labelPoint: CGPoint(x: 0.479, y: 0.50),
                          leaderLength: 40, joint: "patella_R"),
            CueAnnotation(cueID: "front", label: "Front foot flat, mid-foot",
                          labelPoint: CGPoint(x: 0.464, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "torso",
                title: "Torso Position",
                intro: "An upright torso makes this a quad-dominant split squat.",
                why: "Keeping the torso vertical keeps the load over the front knee, where the quadriceps do most of the work.",
                mistake: "Folding forward at the bottom without meaning to, or arching the lower back.",
                correct: "Keep the chest up and the shoulders over the hips as you lower and drive up."
            ),
            TechniqueCue(
                id: "grip",
                title: "Load Position",
                intro: "Where the dumbbells hang decides how upright you can stay.",
                why: "With the weights at arm's length by the sides, the load sits under the shoulders, so the torso stays vertical and the front leg does the work.",
                mistake: "Letting the dumbbells drift forward or shrugging them up, which pulls the chest down.",
                correct: "Hold the dumbbells at arm's length by your sides, shoulders down, and let them travel straight down and up with you."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Tracking",
                intro: "The front knee follows the line of the foot.",
                why: "Tracking over the middle toes keeps the knee aligned while the quadriceps take the load.",
                mistake: "The front knee caving inward on the way up.",
                correct: "Keep the front knee in line with the middle of the foot throughout the rep."
            ),
            TechniqueCue(
                id: "depth",
                title: "Depth",
                intro: "Drop straight down, not forward.",
                why: "Lowering until the back knee nearly touches the floor takes the front leg through its full range, where most of the work happens.",
                mistake: "Stopping halfway or letting the body drift forward instead of down.",
                correct: "Lower the back knee toward the floor until the front thigh is about parallel, then drive up through the front foot."
            ),
            TechniqueCue(
                id: "front",
                title: "Foot Setup",
                intro: "Set both feet before the first rep.",
                why: "A front foot far enough from the bench stays flat with the shin near vertical, and resting the rear laces on the bench keeps the back leg passive so the front leg does the work.",
                mistake: "Standing so close to the bench that the front heel lifts, or balancing on the rear toes and pushing off with them.",
                correct: "Rest the laces of the rear foot on a knee-height bench and place the front foot far enough forward that it stays flat at the bottom."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.58),
            MuscleActivation(name: "Gluteus Medius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.44)
        ],
        stabilisers: ["adductors", "hamstrings", "forearms", "core"],
        setup: [
            "Stand about a stride in front of a knee-height bench.",
            "Rest the laces of your rear foot on the bench.",
            "Hold a dumbbell in each hand at your sides."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "FRONT HEEL LIFTING",
            correctCue: "Whole front foot planted",
            mistakeCue: "Front heel lifts, knee shoots forward",
            correctNote: "A flat front foot with the shin near vertical keeps the load on the front leg's quads and glutes.",
            mistakeNote: "When the front heel lifts, balance shifts onto the toes and the knee takes a sharp, unstable load."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.12, cx: 0.58, cy: 0.62),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.08, cx: 0.54, cy: 0.50)
        ]
    )

    static let bulgarianSplitSquatLeanContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "lean", label: "Lean ~40° from the hips",
                          labelPoint: CGPoint(x: 0.565, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "hips", label: "Hips back, not just down",
                          labelPoint: CGPoint(x: 0.550, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "knee", label: "Front knee tracks the toes",
                          labelPoint: CGPoint(x: 0.479, y: 0.50),
                          leaderLength: 40, joint: "patella_R"),
            CueAnnotation(cueID: "rear", label: "Back knee drops straight down",
                          labelPoint: CGPoint(x: 0.523, y: 0.68),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "front", label: "Drive through the front heel",
                          labelPoint: CGPoint(x: 0.492, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_R")
        ],
        cues: [
            TechniqueCue(
                id: "lean",
                title: "Torso Lean",
                intro: "Leaning forward is what makes this variation glute-biased.",
                why: "A forward lean of about 40° increases gluteus maximus and hamstring activity compared with an upright split squat, while the quadriceps still work hard.",
                mistake: "Rounding the back to get the chest down instead of hinging at the hips.",
                correct: "Keep the spine long and tilt the torso forward from the hips to roughly 40° before you descend."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Hinge",
                intro: "The hips travel back as well as down.",
                why: "Sending the hips back lengthens the glutes and hamstrings of the front leg, so they drive the ascent.",
                mistake: "Dropping straight down with the lean held only at the shoulders.",
                correct: "Push the hips back as you lower, keeping the torso angle fixed throughout the rep."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Tracking",
                intro: "The front knee follows the line of the foot.",
                why: "Tracking over the middle toes keeps the knee aligned while the hip does more of the work.",
                mistake: "The front knee caving inward on the way up.",
                correct: "Keep the front knee in line with the middle of the foot throughout the rep."
            ),
            TechniqueCue(
                id: "rear",
                title: "Rear Leg",
                intro: "The back leg stays passive while its knee drops.",
                why: "Resting the rear laces on the bench keeps that leg relaxed, so as the back knee drops toward the floor nearly all the load stays on the front leg.",
                mistake: "Pushing off the rear toes to help the front leg up.",
                correct: "Rest the rear laces on a knee-height bench, let that leg relax, and lower until the back knee is just above the floor."
            ),
            TechniqueCue(
                id: "front",
                title: "Front Foot",
                intro: "Drive through the heel and mid-foot.",
                why: "Pushing through the heel keeps the load on the posterior chain the lean is meant to target.",
                mistake: "Rising onto the ball of the front foot, which shifts the work back to the quads.",
                correct: "Keep the whole front foot planted and push the floor away through the heel as you stand."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.80),
            MuscleActivation(name: "Gluteus Maximus", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.74),
            MuscleActivation(name: "Hamstrings", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.48)
        ],
        stabilisers: ["gluteus medius", "adductors", "erector spinae", "core"],
        setup: [
            "Stand about a stride in front of a knee-height bench.",
            "Rest the laces of your rear foot on the bench.",
            "Hands on your hips, lean forward about 40° from the hips."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ROUNDED LOWER BACK",
            correctCue: "Lean from the hips, spine long",
            mistakeCue: "Back rounds instead of hinging",
            correctNote: "Hinging from the hips with a long spine lets the lean load the glutes and hamstrings of the front leg.",
            mistakeNote: "Rounding the back to fake the lean puts the load on the lumbar spine and leaves the glutes no more involved than an upright split squat."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.12, cx: 0.42, cy: 0.60),
            .init(DS.activationSoft.opacity(0.35), rx: 0.14, ry: 0.10, cx: 0.46, cy: 0.50)
        ]
    )

    // MARK: - Legs2 and re-exported content (2026-09-24)
    //
    // Hamstring curls and hinges, glute bridges, cable kickbacks and hip
    // abduction, plus Step-Up, Push-Up and Plank on their re-exported models.
    // Generated by `Tools/trainer-content/gen.py` from `spec_legs2.py`; the
    // lifter's left side faces the camera, so cues track the _L joints.
    // Sources: Neto 2020 (gluteus maximus activation review), Distefano 2009
    // (gluteal activation in bridges and side-lying/standing abduction), Maeo
    // 2021 (seated vs lying leg curl), Calatayud 2015 (push-up vs bench
    // press), Schoenfeld 2014 (plank with posterior pelvic tilt).

    static let dumbbellRomanianDeadliftContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "spine", label: "Neutral spine",
                          labelPoint: CGPoint(x: 0.712, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "hips", label: "Push the hips back",
                          labelPoint: CGPoint(x: 0.638, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "path", label: "Dumbbells slide down the thighs",
                          labelPoint: CGPoint(x: 0.552, y: 0.50),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "knee", label: "Soft, fixed knees",
                          labelPoint: CGPoint(x: 0.653, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "feet", label: "Weight on mid-foot",
                          labelPoint: CGPoint(x: 0.638, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "spine",
                title: "Spine Position",
                intro: "The back stays long while the hips do the moving.",
                why: "A neutral spine keeps the load on the hamstrings and glutes, which lengthen as the hips travel back, instead of on the lower back.",
                mistake: "Rounding the upper or lower back to get the dumbbells lower.",
                correct: "Chest proud, shoulders back and the head in line with the torso from the top of the rep to the bottom."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Hinge",
                intro: "The rep is a hinge, not a squat.",
                why: "Sending the hips back stretches the hamstrings under load, which is where this lift does most of its work.",
                mistake: "Bending the knees and dropping the hips straight down, which turns it into a squat.",
                correct: "Push the hips back as if closing a door behind you, and stop when the hamstrings are fully stretched or the back starts to round."
            ),
            TechniqueCue(
                id: "path",
                title: "Dumbbell Path",
                intro: "Keep the weights close to the legs.",
                why: "Dumbbells that stay against the thighs keep the load over mid-foot and shorten the lever on the lower back.",
                mistake: "Letting the dumbbells swing out in front of the body as the torso tips forward.",
                correct: "Keep the dumbbells brushing the fronts of the thighs and shins, arms long and lats tight."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Angle",
                intro: "The knees bend a little at the start and then stay put.",
                why: "A fixed, slight bend lets the hips move back without the knees taking over, so the hamstrings stay loaded.",
                mistake: "Locking the knees straight, or bending them more and more as you go down.",
                correct: "Unlock the knees slightly before the first rep and keep that same angle for the whole set."
            ),
            TechniqueCue(
                id: "feet",
                title: "Balance",
                intro: "The weight stays over the middle of the foot.",
                why: "Balance over mid-foot lets the hips shift back without tipping onto the toes or the heels.",
                mistake: "Rocking onto the toes at the bottom as the weights drift forward.",
                correct: "Stand hip-width, grip the floor with the whole foot and feel the pressure stay under the laces."
            )
        ],
        activation: [
            MuscleActivation(name: "Hamstrings", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.84),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "HIGH ACTIVATION", fraction: 0.66),
            MuscleActivation(name: "Erector Spinae", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.52)
        ],
        stabilisers: ["forearms", "lats", "core", "adductors"],
        setup: [
            "Stand hip-width with a dumbbell in each hand in front of your thighs.",
            "Unlock your knees slightly and brace your trunk.",
            "Pull your shoulders back and keep the dumbbells against your legs."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ROUNDED BACK",
            correctCue: "Long spine, hips back",
            mistakeCue: "Back rounds to reach lower",
            correctNote: "Hinging with a neutral spine lets the hamstrings and glutes lengthen and drive the dumbbells back up.",
            mistakeNote: "Rounding the back to chase depth moves the load from the hamstrings onto the spine and shortens the useful stretch."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.16, ry: 0.12, cx: 0.52, cy: 0.55),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.45)
        ]
    )

    static let stiffLegDeadliftContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "spine", label: "Flat back throughout",
                          labelPoint: CGPoint(x: 0.391, y: 0.14),
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "hips", label: "Hips back, knees near-straight",
                          labelPoint: CGPoint(x: 0.462, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "bar", label: "Bar close to the legs",
                          labelPoint: CGPoint(x: 0.594, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "knee", label: "Knees barely bent",
                          labelPoint: CGPoint(x: 0.653, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "feet", label: "Feet hip-width, flat",
                          labelPoint: CGPoint(x: 0.609, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "spine",
                title: "Back Position",
                intro: "A straighter knee means a longer lever on the back.",
                why: "Keeping the back flat lets the hamstrings take the stretch; with the knees nearly straight, any rounding loads the spine quickly.",
                mistake: "Letting the upper back round forward as the bar passes the knees.",
                correct: "Brace the trunk, keep the shoulders pulled back and hold a flat back from the first rep to the last."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Hinge",
                intro: "The hips travel back while the legs stay nearly straight.",
                why: "With little knee bend, the hamstrings are stretched further than in a Romanian deadlift, which makes this the more hamstring-biased hinge.",
                mistake: "Turning the rep into a toe-touch by bending only at the waist.",
                correct: "Push the hips back, let the torso tip forward and stop at the depth your hamstrings allow with a flat back."
            ),
            TechniqueCue(
                id: "bar",
                title: "Bar Path",
                intro: "The bar travels close to the body.",
                why: "A bar that stays near the legs keeps the load over mid-foot and limits the pull on the lower back.",
                mistake: "Letting the bar hang away from the shins at the bottom.",
                correct: "Keep the arms long and the lats tight so the bar stays over the middle of the foot."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Angle",
                intro: "Stiff-legged, not locked.",
                why: "A slight bend protects the back of the knee while still putting the hamstrings in a long position.",
                mistake: "Hyperextending the knees, or letting them bend so far the lift becomes a Romanian deadlift.",
                correct: "Keep a small, fixed bend in the knees throughout."
            ),
            TechniqueCue(
                id: "feet",
                title: "Stance",
                intro: "A narrow, flat stance keeps the hinge balanced.",
                why: "Feet hip-width and flat give a stable base as the hips move back behind the heels.",
                mistake: "Rocking back on the heels, or up on the toes, at the bottom.",
                correct: "Stand with the feet hip-width, toes forward, and keep the whole foot planted."
            )
        ],
        activation: [
            MuscleActivation(name: "Hamstrings", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.58),
            MuscleActivation(name: "Erector Spinae", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.58)
        ],
        stabilisers: ["forearms", "lats", "trapezius", "core"],
        setup: [
            "Stand hip-width holding the barbell at arm's length, overhand grip.",
            "Keep your knees almost straight, with just a slight bend.",
            "Brace your trunk and pull your shoulders back."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "BACK ROUNDING",
            correctCue: "Flat back, hips back",
            mistakeCue: "Upper back rounds over the bar",
            correctNote: "Holding a flat back puts the whole stretch through the hamstrings, which is the point of keeping the legs straight.",
            mistakeNote: "When the back rounds, the depth comes from the spine instead of the hips, and the lumbar discs take the load."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.16, ry: 0.12, cx: 0.52, cy: 0.55),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.45)
        ]
    )

    static let lyingLegCurlContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "hips", label: "Hips pressed into the pad",
                          labelPoint: CGPoint(x: 0.536, y: 0.28),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "pad", label: "Pad just above the heels",
                          labelPoint: CGPoint(x: 0.550, y: 0.15),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "curl", label: "Curl heels to the glutes",
                          labelPoint: CGPoint(x: 0.550, y: 0.63),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "shin_L"),
            CueAnnotation(cueID: "knee", label: "Knees just off the pad",
                          labelPoint: CGPoint(x: 0.580, y: 0.75),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "grip", label: "Hold the handles",
                          labelPoint: CGPoint(x: 0.332, y: 0.87),
                          leaderLength: 40, joint: "hand_L")
        ],
        cues: [
            TechniqueCue(
                id: "hips",
                title: "Hip Position",
                intro: "The hips stay down for the whole set.",
                why: "Keeping the hips on the pad stops the lower back and glutes from helping, so the hamstrings do the curling.",
                mistake: "Lifting the hips off the pad to finish the curl.",
                correct: "Press the hips into the pad and keep them there, even on the last reps."
            ),
            TechniqueCue(
                id: "pad",
                title: "Pad Position",
                intro: "Set the roller before the first rep.",
                why: "A roller just above the heels gives the hamstrings a long lever to work against without pressing on the Achilles tendon.",
                mistake: "Setting the pad high on the calves, which shortens the lever and lets the weight feel easier than it is.",
                correct: "Adjust the roller so it sits on the back of the lower legs, just above the heels."
            ),
            TechniqueCue(
                id: "curl",
                title: "Range of Motion",
                intro: "Curl all the way in, lower all the way out.",
                why: "Taking the knee from nearly straight to fully bent works the hamstrings through their full range.",
                mistake: "Stopping short at the top, or dropping the weight fast on the way down.",
                correct: "Curl the heels toward the glutes, pause, then lower under control until the legs are almost straight."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Alignment",
                intro: "The knee joint lines up with the machine's pivot.",
                why: "When the knee sits over the axis, the machine's arc matches the knee's own, so the load stays smooth through the rep.",
                mistake: "Lying too far up or down the bench so the pad slides along the leg as you curl.",
                correct: "Lie so your knees sit just off the end of the pad, in line with the pivot point."
            ),
            TechniqueCue(
                id: "grip",
                title: "Upper Body",
                intro: "The hands anchor the body, they do not pull.",
                why: "Holding the handles lightly keeps the torso still so the curl comes only from the knees.",
                mistake: "Yanking on the handles to heave the weight up.",
                correct: "Hold the handles, rest the chest on the bench and keep the upper body relaxed."
            )
        ],
        activation: [
            MuscleActivation(name: "Hamstrings", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.90),
            MuscleActivation(name: "Gastrocnemius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.46)
        ],
        stabilisers: ["gluteus maximus", "core"],
        setup: [
            "Lie face down on the bench, knees just off the end of the pad.",
            "Set the roller on your lower legs, just above the heels.",
            "Hold the handles and press your hips into the pad."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIPS LIFTING",
            correctCue: "Hips down, curl from the knees",
            mistakeCue: "Hips rise to finish the rep",
            correctNote: "With the hips pinned, only the knee bends, so the hamstrings take the full load through the full range.",
            mistakeNote: "Lifting the hips shortens the hamstrings at the hip and lets momentum finish the rep, taking tension off the target."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.18, ry: 0.08, cx: 0.55, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.08, cx: 0.45, cy: 0.50)
        ]
    )

    static let seatedLegCurlContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "back", label: "Back against the pad",
                          labelPoint: CGPoint(x: 0.609, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "thigh", label: "Thigh pad locked down",
                          labelPoint: CGPoint(x: 0.406, y: 0.50),
                          leaderLength: 40, joint: "thigh_L"),
            CueAnnotation(cueID: "knee", label: "Knees in line with the pivot",
                          labelPoint: CGPoint(x: 0.492, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "curl", label: "Curl heels under the seat",
                          labelPoint: CGPoint(x: 0.536, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "shin_L"),
            CueAnnotation(cueID: "grip", label: "Hold the handles",
                          labelPoint: CGPoint(x: 0.668, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L")
        ],
        cues: [
            TechniqueCue(
                id: "back",
                title: "Seat Position",
                intro: "Sit back into the pad.",
                why: "Sitting upright with the hips flexed stretches the hamstrings at the hip, which lets them work harder at long lengths than when lying down.",
                mistake: "Slouching forward or lifting off the back pad during the curl.",
                correct: "Sit all the way back and keep the torso against the pad for the whole set."
            ),
            TechniqueCue(
                id: "thigh",
                title: "Thigh Pad",
                intro: "The thigh pad keeps the hips still.",
                why: "A snug pad above the knees stops the thighs lifting, so the knee is the only joint moving.",
                mistake: "Leaving the pad loose, so the thighs rise as you curl.",
                correct: "Lower the thigh pad until it presses firmly just above the knees."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Alignment",
                intro: "Line the knees up with the machine's axis.",
                why: "When the knee sits on the pivot, the pad stays in one place on the leg and the resistance is smooth.",
                mistake: "Sitting too far forward or back so the ankle pad slides up and down the calves.",
                correct: "Adjust the back pad so your knees line up with the pivot marked on the machine."
            ),
            TechniqueCue(
                id: "curl",
                title: "Range of Motion",
                intro: "Full curl, slow return.",
                why: "The seated position already loads the hamstrings long, so a full range makes the most of it.",
                mistake: "Short, bouncing reps that never straighten the legs.",
                correct: "Curl until the heels pass under the seat, then let the legs straighten slowly."
            ),
            TechniqueCue(
                id: "grip",
                title: "Upper Body",
                intro: "Hold on to stay seated.",
                why: "Gripping the handles keeps the hips down as the load increases.",
                mistake: "Pulling on the handles or rocking the torso to help the curl.",
                correct: "Hold the handles firmly with relaxed shoulders and let the legs do the work."
            )
        ],
        activation: [
            MuscleActivation(name: "Hamstrings", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.92),
            MuscleActivation(name: "Gastrocnemius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["hip flexors", "core"],
        setup: [
            "Sit with your back against the pad, knees in line with the pivot.",
            "Rest your lower legs on the roller, just above the heels.",
            "Lock the thigh pad down above your knees and hold the handles."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "PARTIAL REPS",
            correctCue: "Full curl, legs straighten",
            mistakeCue: "Legs never straighten",
            correctNote: "Using the full range while seated trains the hamstrings at the long lengths this machine is best at.",
            mistakeNote: "Cutting the return short skips the stretched position, which is where the seated curl has its advantage."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.52, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.48, cy: 0.60)
        ]
    )

    static let singleLegCurlContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "hips", label: "Hips square on the pad",
                          labelPoint: CGPoint(x: 0.580, y: 0.28),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "pad", label: "Pad just above the heel",
                          labelPoint: CGPoint(x: 0.565, y: 0.15),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "curl", label: "Curl to full bend",
                          labelPoint: CGPoint(x: 0.653, y: 0.63),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "shin_L"),
            CueAnnotation(cueID: "knee", label: "Knee off the end of the pad",
                          labelPoint: CGPoint(x: 0.506, y: 0.75),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "still", label: "Other leg stays relaxed",
                          labelPoint: CGPoint(x: 0.565, y: 0.87),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_R")
        ],
        cues: [
            TechniqueCue(
                id: "hips",
                title: "Hip Position",
                intro: "One leg working makes the hips want to twist.",
                why: "Keeping both hips pressed down stops the pelvis rotating, so the working hamstring cannot borrow help from the lower back.",
                mistake: "Rolling the hip of the working leg up off the pad as it curls.",
                correct: "Press both hips into the pad and keep them level for every rep."
            ),
            TechniqueCue(
                id: "pad",
                title: "Pad Position",
                intro: "Set the roller for one leg.",
                why: "A roller just above the heel gives the hamstring the longest lever without pressing on the Achilles tendon.",
                mistake: "Sliding the pad onto the calf.",
                correct: "Place the roller on the back of the lower leg, just above the heel."
            ),
            TechniqueCue(
                id: "curl",
                title: "Range of Motion",
                intro: "Curl fully, then lower slowly.",
                why: "Working one leg at a time lets each hamstring go through its full range without the stronger side taking over.",
                mistake: "Stopping halfway, or dropping the weight back down.",
                correct: "Curl the heel toward the glute, pause, and lower until the leg is nearly straight."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Alignment",
                intro: "The knee sits over the pivot.",
                why: "Lining the knee up with the machine's axis keeps the resistance smooth through the arc.",
                mistake: "Lying too far up the bench, so the knee rests on the pad.",
                correct: "Position yourself so the knee is just off the end of the pad, level with the pivot."
            ),
            TechniqueCue(
                id: "still",
                title: "Resting Leg",
                intro: "The other leg stays out of it.",
                why: "A relaxed, still resting leg keeps the pelvis quiet and the work on one side.",
                mistake: "Pressing the resting leg into the bench to lever the working leg up.",
                correct: "Let the resting leg lie straight and relaxed on the bench."
            )
        ],
        activation: [
            MuscleActivation(name: "Hamstrings", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.90),
            MuscleActivation(name: "Gastrocnemius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.46)
        ],
        stabilisers: ["gluteus maximus", "core", "obliques"],
        setup: [
            "Lie face down on the bench, knees just off the end of the pad.",
            "Set the roller above the heel of the working leg.",
            "Hold the handles and keep both hips pressed into the pad."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIP ROTATING",
            correctCue: "Hips level on the pad",
            mistakeCue: "Working hip lifts and twists",
            correctNote: "Level hips keep the curl at the knee, so one hamstring does all the work.",
            mistakeNote: "When the hip rolls up, the pelvis joins in and the hamstring does less of each rep."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.18, ry: 0.08, cx: 0.55, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.12, ry: 0.08, cx: 0.45, cy: 0.50)
        ]
    )

    static let gluteBridgeContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "hips", label: "Drive the hips up",
                          labelPoint: CGPoint(x: 0.347, y: 0.28),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "ribs", label: "Ribs down, no arch",
                          labelPoint: CGPoint(x: 0.638, y: 0.63),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "feet", label: "Heels close to the glutes",
                          labelPoint: CGPoint(x: 0.464, y: 0.75),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "knee", label: "Knees over the feet",
                          labelPoint: CGPoint(x: 0.376, y: 0.15),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "arms", label: "Arms flat on the floor",
                          labelPoint: CGPoint(x: 0.580, y: 0.87),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L")
        ],
        cues: [
            TechniqueCue(
                id: "hips",
                title: "Hip Extension",
                intro: "The glutes lift the hips; the lower back does not.",
                why: "Finishing with the hips fully extended is where the gluteus maximus works hardest in a bridge.",
                mistake: "Stopping short of full extension, or pushing higher by arching the back.",
                correct: "Squeeze the glutes to lift until knees, hips and shoulders form a straight line, then pause."
            ),
            TechniqueCue(
                id: "ribs",
                title: "Rib Position",
                intro: "Keep the ribs down at the top.",
                why: "A posterior-tilted pelvis with ribs down keeps the extension at the hip, not in the lumbar spine.",
                mistake: "Flaring the ribs and arching the lower back to look higher.",
                correct: "Tuck the pelvis slightly and keep the ribs pulled down as the hips rise."
            ),
            TechniqueCue(
                id: "feet",
                title: "Foot Position",
                intro: "Foot distance decides which muscles work.",
                why: "With the heels close to the glutes, the shins are near vertical at the top, which favours the glutes over the hamstrings.",
                mistake: "Placing the feet far away, which shifts the work to the hamstrings and can cramp them.",
                correct: "Set the heels about a hand's length from the glutes, feet hip-width and flat."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Alignment",
                intro: "Knees stay in line with the feet.",
                why: "Knees tracking over the feet keep the hips square and let both glutes share the load.",
                mistake: "Letting the knees fall inward as the hips rise.",
                correct: "Push the knees gently out so they stay over the middle of the feet."
            ),
            TechniqueCue(
                id: "arms",
                title: "Arm Position",
                intro: "The arms steady the body, not push it.",
                why: "Flat arms give a wide base so the hips can lift without rocking.",
                mistake: "Pressing hard through the hands to help lift the hips.",
                correct: "Rest the arms flat on the floor beside you, palms down and relaxed."
            )
        ],
        activation: [
            MuscleActivation(name: "Gluteus Maximus", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.82),
            MuscleActivation(name: "Hamstrings", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.52),
            MuscleActivation(name: "Erector Spinae", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.36)
        ],
        stabilisers: ["gluteus medius", "adductors", "core"],
        setup: [
            "Lie on your back on a mat, knees bent.",
            "Set your heels about a hand's length from your glutes, hip-width apart.",
            "Rest your arms flat beside you, palms down."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "LOWER BACK ARCHING",
            correctCue: "Hips up, ribs down",
            mistakeCue: "Lower back arches at the top",
            correctNote: "Finishing with a straight line from knees to shoulders keeps the lift at the hips, where the glutes work.",
            mistakeNote: "Arching the lower back adds height without adding hip extension, so the glutes do less and the spine does more."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.52, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.48, cy: 0.60)
        ]
    )

    static let singleLegGluteBridgeContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "hips", label: "Hips stay level",
                          labelPoint: CGPoint(x: 0.318, y: 0.63),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "drive", label: "Drive through the heel",
                          labelPoint: CGPoint(x: 0.420, y: 0.87),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "knee", label: "Knee over the foot",
                          labelPoint: CGPoint(x: 0.362, y: 0.28),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "free", label: "Free leg lifted, still",
                          labelPoint: CGPoint(x: 0.420, y: 0.15),
                          leaderLength: 40, joint: "foot_R"),
            CueAnnotation(cueID: "ribs", label: "Ribs down at the top",
                          labelPoint: CGPoint(x: 0.609, y: 0.75),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest")
        ],
        cues: [
            TechniqueCue(
                id: "hips",
                title: "Pelvis Level",
                intro: "One leg on the floor makes the hips want to drop.",
                why: "Keeping the pelvis level makes the working-side glutes resist rotation as well as extend, which is what makes this harder than the two-leg bridge.",
                mistake: "Letting the hip on the lifted side sag or twist on the way up.",
                correct: "Keep both hip bones at the same height through the whole rep."
            ),
            TechniqueCue(
                id: "drive",
                title: "Foot Drive",
                intro: "Push through the heel of the planted foot.",
                why: "Driving through the heel keeps the work in the glutes and hamstrings rather than the quads.",
                mistake: "Pushing through the toes, which shifts the load forward onto the thigh.",
                correct: "Plant the working foot close to the glutes and press the heel into the floor."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Alignment",
                intro: "The working knee follows the foot.",
                why: "A knee kept over the foot stops the hip rolling inward.",
                mistake: "The knee drifting in toward the other leg.",
                correct: "Keep the working knee over the middle of the foot from bottom to top."
            ),
            TechniqueCue(
                id: "free",
                title: "Free Leg",
                intro: "The raised leg only goes along for the ride.",
                why: "A still free leg keeps momentum out of the lift, so the planted side does all the work.",
                mistake: "Kicking the free leg up to help the hips rise.",
                correct: "Hold the free leg up and steady, knee bent or straight, as the hips move."
            ),
            TechniqueCue(
                id: "ribs",
                title: "Rib Position",
                intro: "Finish with the hips, not the back.",
                why: "Ribs down means the height comes from hip extension, where the glutes work.",
                mistake: "Arching the lower back at the top.",
                correct: "Keep the ribs down and stop when hip, knee and shoulder line up."
            )
        ],
        activation: [
            MuscleActivation(name: "Gluteus Maximus", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Hamstrings", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.56),
            MuscleActivation(name: "Gluteus Medius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50)
        ],
        stabilisers: ["adductors", "obliques", "erector spinae"],
        setup: [
            "Lie on your back on a mat, knees bent.",
            "Plant the working foot close to your glutes.",
            "Lift the other foot off the floor and rest your arms flat beside you."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIP DROPPING",
            correctCue: "Pelvis level at the top",
            mistakeCue: "Free-leg side of the hips sags",
            correctNote: "A level pelvis makes the working glutes both lift and stabilise the hips.",
            mistakeNote: "When the hips twist or sag, the load leaks away from the working side and the lower back takes over."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.52, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.48, cy: 0.60)
        ]
    )

    static let cableGluteKickbackContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "torso", label: "Hinge forward, spine long",
                          labelPoint: CGPoint(x: 0.536, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "hips", label: "Hips square to the stack",
                          labelPoint: CGPoint(x: 0.450, y: 0.50),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "kick", label: "Kick back from the hip",
                          labelPoint: CGPoint(x: 0.420, y: 0.68),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "cuff", label: "Cuff on the working ankle",
                          labelPoint: CGPoint(x: 0.536, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "grip", label: "Hands on the frame",
                          labelPoint: CGPoint(x: 0.362, y: 0.32),
                          leaderLength: 40, joint: "hand_L")
        ],
        cues: [
            TechniqueCue(
                id: "torso",
                title: "Torso Angle",
                intro: "A slight forward lean gives the leg room to travel.",
                why: "Hinging forward lets the hip extend fully without the lower back arching to make up the range.",
                mistake: "Standing bolt upright and arching the back to get the leg behind the body.",
                correct: "Hold the frame, hinge forward a little from the hips and keep the spine long."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Position",
                intro: "The hips stay facing the stack.",
                why: "Square hips keep the movement in the sagittal plane, so the gluteus maximus extends the hip instead of the pelvis rotating.",
                mistake: "Opening the hip outward as the leg kicks back.",
                correct: "Keep both hip bones pointing at the machine for every rep."
            ),
            TechniqueCue(
                id: "kick",
                title: "Range of Motion",
                intro: "The movement ends where the hip does.",
                why: "Kicking back only as far as the hip extends keeps the tension in the glute rather than the lumbar spine.",
                mistake: "Swinging the leg high with momentum and arching the back at the top.",
                correct: "Drive the heel back and slightly up, squeeze the glute at the end and return under control."
            ),
            TechniqueCue(
                id: "cuff",
                title: "Attachment",
                intro: "The cable pulls from the ankle.",
                why: "An ankle cuff on a low pulley keeps the resistance in line with the kick.",
                mistake: "Letting the cable slacken at the start so the load only appears at the end.",
                correct: "Strap the cuff around the working ankle and step back until there is tension at the start."
            ),
            TechniqueCue(
                id: "grip",
                title: "Support",
                intro: "The frame steadies you.",
                why: "Holding the frame takes balance out of the lift, so the working glute can be loaded properly.",
                mistake: "Pulling on the frame to twist the body into the kick.",
                correct: "Hold the frame with both hands, arms relaxed, standing leg slightly bent."
            )
        ],
        activation: [
            MuscleActivation(name: "Gluteus Maximus", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.84),
            MuscleActivation(name: "Hamstrings", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.50),
            MuscleActivation(name: "Gluteus Medius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["standing-leg glutes", "core", "erector spinae"],
        setup: [
            "Attach an ankle cuff to the low pulley and strap it to your working ankle.",
            "Face the stack and hold the frame with both hands.",
            "Step back until the cable is tight and hinge forward slightly."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "BACK ARCHING",
            correctCue: "Hip extends, spine still",
            mistakeCue: "Lower back arches to lift the leg",
            correctNote: "Keeping the spine still ends the kick at full hip extension, which is where the glute is working hardest.",
            mistakeNote: "Arching the back lifts the leg higher but the extra range comes from the spine, not the glute."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.52, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.48, cy: 0.60)
        ]
    )

    static let cableSideKickContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "torso", label: "Stand tall, no lean",
                          labelPoint: CGPoint(x: 0.376, y: 0.32),
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "hips", label: "Hips face forward",
                          labelPoint: CGPoint(x: 0.347, y: 0.50),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "kick", label: "Sweep the leg out to the side",
                          labelPoint: CGPoint(x: 0.477, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "foot", label: "Toes point forward",
                          labelPoint: CGPoint(x: 0.638, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "grip", label: "Hold the rail lightly",
                          labelPoint: CGPoint(x: 0.406, y: 0.14),
                          leaderLength: 40, joint: "hand_R")
        ],
        cues: [
            TechniqueCue(
                id: "torso",
                title: "Torso Position",
                intro: "The torso stays upright while the leg moves.",
                why: "Leaning away from the working leg shortens the range at the hip and lets the trunk muscles take over from the gluteus medius.",
                mistake: "Tipping the torso away to lift the leg higher.",
                correct: "Stand tall, shoulders over the hips, and let only the leg move."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Position",
                intro: "Keep the hips square to the front.",
                why: "Facing forward keeps the leg moving straight out to the side, which is the gluteus medius's line of pull.",
                mistake: "Turning the hips and toes up, which swaps in the hip flexors.",
                correct: "Point both hip bones forward for the whole set."
            ),
            TechniqueCue(
                id: "kick",
                title: "Range of Motion",
                intro: "From across the body to out wide.",
                why: "Starting with the leg crossed in front lengthens the abductors, so the side glute works through its full range.",
                mistake: "Short, fast kicks that never cross the midline.",
                correct: "Let the leg cross slightly in front, then sweep it out to the side under control and return slowly."
            ),
            TechniqueCue(
                id: "foot",
                title: "Foot Position",
                intro: "The toes lead forward, not up.",
                why: "Toes forward or slightly down keep the gluteus medius in charge; rotating the foot up hands the work to the hip flexors.",
                mistake: "Turning the toes toward the ceiling as the leg rises.",
                correct: "Keep the toes pointing forward throughout the kick."
            ),
            TechniqueCue(
                id: "grip",
                title: "Support",
                intro: "Hold on just enough to balance.",
                why: "A light hand on the rail removes the balance demand so you can load the moving side.",
                mistake: "Pulling on the rail to lean the body.",
                correct: "Hold the rail with the near hand and keep the standing knee soft."
            )
        ],
        activation: [
            MuscleActivation(name: "Gluteus Medius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.82),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.48)
        ],
        stabilisers: ["standing-leg gluteus medius", "obliques", "adductors"],
        setup: [
            "Attach an ankle cuff to the low pulley and strap it to the far ankle.",
            "Stand side-on to the stack and hold the rail with your near hand.",
            "Let the working leg cross slightly in front, toes forward."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "TORSO LEANING",
            correctCue: "Upright torso, leg sweeps out",
            mistakeCue: "Torso tips to lift the leg",
            correctNote: "Staying upright makes the side glute lift the leg through the full range.",
            mistakeNote: "Leaning away lifts the foot higher but the extra range comes from the trunk, not the hip."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.52, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.48, cy: 0.60)
        ]
    )

    static let cableHipAbductionContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "torso", label: "Stay upright",
                          labelPoint: CGPoint(x: 0.726, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "hips", label: "Pelvis level",
                          labelPoint: CGPoint(x: 0.274, y: 0.50),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "lift", label: "Lift the leg out, not up",
                          labelPoint: CGPoint(x: 0.550, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "foot", label: "Toes forward",
                          labelPoint: CGPoint(x: 0.726, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "grip", label: "Hand on the post",
                          labelPoint: CGPoint(x: 0.332, y: 0.14),
                          leaderLength: 40, joint: "hand_R")
        ],
        cues: [
            TechniqueCue(
                id: "torso",
                title: "Torso Position",
                intro: "Only the leg moves.",
                why: "An upright torso keeps the movement at the hip, so the gluteus medius lifts the leg.",
                mistake: "Leaning the upper body away from the moving leg.",
                correct: "Stand tall with the shoulders stacked over the hips."
            ),
            TechniqueCue(
                id: "hips",
                title: "Pelvis",
                intro: "Keep the pelvis still and level.",
                why: "Hiking the hip on the working side lets the side trunk muscles lift the leg instead of the glute.",
                mistake: "Shrugging the working hip up toward the ribs.",
                correct: "Keep both hip bones level and move the leg from the hip joint."
            ),
            TechniqueCue(
                id: "lift",
                title: "Range of Motion",
                intro: "A modest, controlled range.",
                why: "The hip abducts about 30–45°; past that the pelvis tips and the glute stops doing the work.",
                mistake: "Swinging the leg as high as possible.",
                correct: "Lift the leg out to the side until the pelvis wants to move, pause, and lower slowly."
            ),
            TechniqueCue(
                id: "foot",
                title: "Foot Position",
                intro: "Lead with the heel, toes forward.",
                why: "Keeping the foot facing forward keeps the gluteus medius in its line of pull.",
                mistake: "Rotating the toes up toward the ceiling.",
                correct: "Keep the toes forward, or slightly down, as the leg moves."
            ),
            TechniqueCue(
                id: "grip",
                title: "Support",
                intro: "The post is for balance.",
                why: "Light support lets you focus on the working hip without the standing leg wobbling.",
                mistake: "Leaning on the post to move the body.",
                correct: "Rest the near hand on the post, standing knee soft."
            )
        ],
        activation: [
            MuscleActivation(name: "Gluteus Medius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.80),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.42)
        ],
        stabilisers: ["standing-leg gluteus medius", "obliques", "core"],
        setup: [
            "Attach an ankle cuff to the low pulley and strap it to the far ankle.",
            "Stand side-on to the stack, one hand on the balance post.",
            "Stand tall with the hips level and the standing knee soft."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIP HIKING",
            correctCue: "Pelvis level, leg moves out",
            mistakeCue: "Hip hikes to lift the leg",
            correctNote: "With a level pelvis the gluteus medius lifts the leg by itself.",
            mistakeNote: "Hiking the hip moves the leg with the trunk muscles, so it looks like more range but the glute does less."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.52, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.48, cy: 0.60)
        ]
    )

    static let hipAbductionMachineContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "back", label: "Back against the pad",
                          labelPoint: CGPoint(x: 0.609, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "push", label: "Push knees out",
                          labelPoint: CGPoint(x: 0.697, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "hips", label: "Hips stay in the seat",
                          labelPoint: CGPoint(x: 0.594, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "feet", label: "Feet on the footrests",
                          labelPoint: CGPoint(x: 0.594, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "grip", label: "Hold the handles",
                          labelPoint: CGPoint(x: 0.668, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L")
        ],
        cues: [
            TechniqueCue(
                id: "back",
                title: "Seat Position",
                intro: "Sit upright against the back pad.",
                why: "An upright torso keeps the hips at about 90°, which biases the gluteus medius and the upper fibres of the gluteus maximus.",
                mistake: "Slouching or rocking the torso forward to push the pads apart.",
                correct: "Sit all the way back and keep the torso still against the pad."
            ),
            TechniqueCue(
                id: "push",
                title: "Knee Drive",
                intro: "Push through the outsides of the knees.",
                why: "Driving the pads apart with the knees abducts the hips, the main job of the gluteus medius.",
                mistake: "Letting the pads snap back together between reps.",
                correct: "Press the knees out as far as the hips allow, pause, then let them return slowly."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Position",
                intro: "The hips stay planted.",
                why: "A still pelvis keeps the effort at the hip joint instead of shifting in the seat.",
                mistake: "Lifting the hips off the seat to force the last reps.",
                correct: "Keep the glutes pressed into the seat for the whole set."
            ),
            TechniqueCue(
                id: "feet",
                title: "Foot Position",
                intro: "Feet rest, they do not push.",
                why: "Relaxed feet on the rests keep the movement coming from the hips.",
                mistake: "Pushing the feet into the rests, which turns the lift into a leg press.",
                correct: "Place the feet flat on the footrests and keep them relaxed."
            ),
            TechniqueCue(
                id: "grip",
                title: "Handles",
                intro: "Hold on to stay put.",
                why: "Holding the handles keeps the torso still as the load increases.",
                mistake: "Pulling on the handles to rock the body.",
                correct: "Grip the handles lightly with relaxed shoulders."
            )
        ],
        activation: [
            MuscleActivation(name: "Gluteus Medius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.82),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.52)
        ],
        stabilisers: ["core", "hip flexors"],
        setup: [
            "Set the pads so your knees start close together.",
            "Sit back against the pad with your feet on the footrests.",
            "Place the pads on the outsides of your knees and hold the handles."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "PADS SLAMMING",
            correctCue: "Controlled return",
            mistakeCue: "Knees snap back together",
            correctNote: "A slow return keeps the gluteus medius working on the way in as well as the way out.",
            mistakeNote: "Letting the weight stack slam the pads together throws away half of every rep."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.52, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.48, cy: 0.60)
        ]
    )

    static let hipAbductionMachineLeanContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "lean", label: "Lean forward from the hips",
                          labelPoint: CGPoint(x: 0.521, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "push", label: "Push knees out",
                          labelPoint: CGPoint(x: 0.697, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "hips", label: "Hips stay in the seat",
                          labelPoint: CGPoint(x: 0.594, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "feet", label: "Feet on the footrests",
                          labelPoint: CGPoint(x: 0.594, y: 0.86),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "grip", label: "Hold the handles",
                          labelPoint: CGPoint(x: 0.668, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L")
        ],
        cues: [
            TechniqueCue(
                id: "lean",
                title: "Torso Lean",
                intro: "Leaning forward changes which glute fibres work.",
                why: "With the hips flexed further, the upper fibres of the gluteus maximus act more as hip abductors, so the lean shifts more of the work onto the glute max.",
                mistake: "Rounding the back to lean instead of hinging at the hips.",
                correct: "Keep the spine long and tip the torso forward from the hips, then hold that angle for the set."
            ),
            TechniqueCue(
                id: "push",
                title: "Knee Drive",
                intro: "Push through the outsides of the knees.",
                why: "Driving the pads apart from a flexed-hip position trains the glutes at a longer length.",
                mistake: "Short reps that stop well before the end of the range.",
                correct: "Press the knees out as far as the hips allow, pause, then return slowly."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Position",
                intro: "The hips stay planted as you lean.",
                why: "Keeping the glutes on the seat makes the lean come from the hips rather than sliding forward.",
                mistake: "Sliding forward on the seat to lean further.",
                correct: "Stay seated right back, then hinge forward over the thighs."
            ),
            TechniqueCue(
                id: "feet",
                title: "Foot Position",
                intro: "Feet rest, they do not push.",
                why: "Relaxed feet keep the effort at the hips.",
                mistake: "Pressing the feet into the rests to help the pads apart.",
                correct: "Keep the feet flat and relaxed on the footrests."
            ),
            TechniqueCue(
                id: "grip",
                title: "Handles",
                intro: "Hold on to keep the lean steady.",
                why: "Holding the handles supports the forward lean so the torso does not bob with each rep.",
                mistake: "Pulling on the handles to rock forward and back.",
                correct: "Hold the handles and keep the torso angle fixed."
            )
        ],
        activation: [
            MuscleActivation(name: "Gluteus Medius", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.78),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "HIGH ACTIVATION", fraction: 0.66)
        ],
        stabilisers: ["erector spinae", "core"],
        setup: [
            "Set the pads so your knees start close together.",
            "Sit with your feet on the footrests and the pads outside your knees.",
            "Hold the handles and lean forward from the hips."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ROUNDED BACK",
            correctCue: "Hinge from the hips",
            mistakeCue: "Back rounds to lean",
            correctNote: "Hinging from the hips puts the glutes in a flexed position, where the upper glute max helps abduct.",
            mistakeNote: "Rounding the back leans the shoulders without flexing the hips, so the glutes gain nothing from the lean."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.52, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.48, cy: 0.60)
        ]
    )

    static let stepUpContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "torso", label: "Chest up, slight lean",
                          labelPoint: CGPoint(x: 0.594, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "drive", label: "Drive through the top foot",
                          labelPoint: CGPoint(x: 0.479, y: 0.86),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "knee", label: "Knee tracks the toes",
                          labelPoint: CGPoint(x: 0.391, y: 0.68),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "hips", label: "Hips level",
                          labelPoint: CGPoint(x: 0.756, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "grip", label: "Dumbbells at your sides",
                          labelPoint: CGPoint(x: 0.565, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L")
        ],
        cues: [
            TechniqueCue(
                id: "torso",
                title: "Torso Position",
                intro: "Stay tall with a slight forward lean.",
                why: "A small lean over the top foot keeps your balance over the working leg so it does the lifting.",
                mistake: "Folding forward to heave the body up, or leaning back at the top.",
                correct: "Keep the chest up and shoulders slightly in front of the hips as you rise."
            ),
            TechniqueCue(
                id: "drive",
                title: "Working Leg",
                intro: "The top leg does the work.",
                why: "Driving through the whole foot on the box works the quadriceps and glutes of that leg.",
                mistake: "Pushing off the floor with the back foot, which turns it into a jump.",
                correct: "Plant the whole foot on the box and push through it until you stand tall; keep the back leg passive."
            ),
            TechniqueCue(
                id: "knee",
                title: "Knee Tracking",
                intro: "The working knee follows the foot.",
                why: "Knee over the middle toes keeps the knee aligned under load.",
                mistake: "The knee caving inward as you drive up.",
                correct: "Keep the knee in line with the middle of the foot from bottom to top."
            ),
            TechniqueCue(
                id: "hips",
                title: "Pelvis",
                intro: "Keep the hips level on the way up and down.",
                why: "A level pelvis makes the working-side glutes stabilise the hip as well as extend it.",
                mistake: "The hip of the free leg dropping as you step.",
                correct: "Keep both hip bones level and step down slowly under control."
            ),
            TechniqueCue(
                id: "grip",
                title: "Load Position",
                intro: "The dumbbells hang straight down.",
                why: "Weights at arm's length keep the load under the shoulders, so balance stays over the working leg.",
                mistake: "Letting the dumbbells swing forward or curl up.",
                correct: "Hold a dumbbell in each hand, arms long and shoulders down."
            )
        ],
        activation: [
            MuscleActivation(name: "Quadriceps", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.82),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "HIGH ACTIVATION", fraction: 0.64),
            MuscleActivation(name: "Gluteus Medius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.44)
        ],
        stabilisers: ["hamstrings", "adductors", "forearms", "core"],
        setup: [
            "Stand facing a knee-height box, a dumbbell in each hand.",
            "Place your whole working foot flat on the box.",
            "Lean slightly forward over the top foot."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "BACK FOOT PUSHING",
            correctCue: "Top leg lifts you",
            mistakeCue: "Back foot bounces off the floor",
            correctNote: "Letting the top leg do all the lifting keeps the work in that leg's quads and glutes.",
            mistakeNote: "A push from the back foot makes the step easier by moving the work to the leg that is not meant to be training."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.12, cx: 0.50, cy: 0.55),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.10, cx: 0.50, cy: 0.45)
        ]
    )

    static let pushUpContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "body", label: "Body in one straight line",
                          labelPoint: CGPoint(x: 0.464, y: 0.28),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "hands", label: "Hands under the shoulders",
                          labelPoint: CGPoint(x: 0.464, y: 0.87),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "elbow", label: "Elbows ~45° from the body",
                          labelPoint: CGPoint(x: 0.464, y: 0.63),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "depth", label: "Chest to just above the floor",
                          labelPoint: CGPoint(x: 0.523, y: 0.15),
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "feet", label: "Feet together, toes tucked",
                          labelPoint: CGPoint(x: 0.521, y: 0.75),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "body",
                title: "Body Line",
                intro: "A push-up is a moving plank.",
                why: "A straight line from head to heels keeps the load on the chest and triceps and makes the abs work to hold the trunk.",
                mistake: "Letting the hips sag toward the floor, or piking them up.",
                correct: "Squeeze the glutes and brace the abs so the body moves as one piece."
            ),
            TechniqueCue(
                id: "hands",
                title: "Hand Position",
                intro: "Hands a little wider than the shoulders.",
                why: "Hands under or just outside the shoulders keep the forearms vertical at the bottom, the strongest pressing position.",
                mistake: "Placing the hands far forward, toward the head, which loads the shoulders.",
                correct: "Set the hands slightly wider than shoulder-width, level with the chest, fingers forward."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Angle",
                intro: "Tuck the elbows about 45°.",
                why: "At roughly 45° from the torso the chest stays in its strongest line of pull and the shoulder joint stays supported.",
                mistake: "Flaring the elbows straight out to the sides.",
                correct: "Let the elbows travel back at about 45° as you lower."
            ),
            TechniqueCue(
                id: "depth",
                title: "Depth",
                intro: "Lower all the way.",
                why: "Taking the chest close to the floor works the chest through its full range.",
                mistake: "Short reps that only bend the elbows a little.",
                correct: "Lower until the chest is just above the floor, then press back up to straight arms."
            ),
            TechniqueCue(
                id: "feet",
                title: "Base",
                intro: "The toes are the back of the plank.",
                why: "Feet together make the trunk resist more rotation; wider feet are easier to balance.",
                mistake: "Letting the feet slide or the heels drop to one side.",
                correct: "Tuck the toes, keep the feet together or hip-width, and push back through the heels."
            )
        ],
        activation: [
            MuscleActivation(name: "Pectoralis Major", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.84),
            MuscleActivation(name: "Triceps Brachii", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.60),
            MuscleActivation(name: "Anterior Deltoid", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.52)
        ],
        stabilisers: ["serratus anterior", "rectus abdominis", "gluteus maximus"],
        setup: [
            "Kneel on a mat with your hands slightly wider than your shoulders.",
            "Step your feet back, toes tucked, body in one straight line.",
            "Brace your abs and squeeze your glutes."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIPS SAGGING",
            correctCue: "Straight line head to heels",
            mistakeCue: "Hips drop toward the floor",
            correctNote: "A rigid body line makes the chest and triceps lift the whole body in one piece.",
            mistakeNote: "When the hips sag, the lower back arches and part of each rep is lost to the trunk bending instead of the chest pressing."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.16, ry: 0.08, cx: 0.45, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.40, cy: 0.50)
        ]
    )

    static let plankContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "body", label: "Straight line, head to heels",
                          labelPoint: CGPoint(x: 0.508, y: 0.63),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "elbow", label: "Elbows under the shoulders",
                          labelPoint: CGPoint(x: 0.479, y: 0.87),
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "ribs", label: "Ribs down, abs braced",
                          labelPoint: CGPoint(x: 0.406, y: 0.15),
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "head", label: "Neck neutral, eyes down",
                          labelPoint: CGPoint(x: 0.435, y: 0.28),
                          leaderLength: 40, joint: "head"),
            CueAnnotation(cueID: "feet", label: "Push back through the heels",
                          labelPoint: CGPoint(x: 0.506, y: 0.75),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "body",
                title: "Body Line",
                intro: "The hold is only useful while the line is straight.",
                why: "A straight body makes the abdominals resist gravity pulling the hips down, which is the whole point of the plank.",
                mistake: "Hips sagging toward the floor, or piked up to rest.",
                correct: "Line up ears, shoulders, hips and ankles and hold it there."
            ),
            TechniqueCue(
                id: "elbow",
                title: "Elbow Position",
                intro: "Stack the shoulders over the elbows.",
                why: "Elbows under the shoulders let the upper body rest on bone, so the effort stays in the trunk.",
                mistake: "Elbows far in front of the shoulders, or the shoulder blades collapsing together.",
                correct: "Place the elbows under the shoulders and push the floor away to spread the shoulder blades."
            ),
            TechniqueCue(
                id: "ribs",
                title: "Bracing",
                intro: "Brace as if about to be poked in the stomach.",
                why: "Pulling the ribs toward the pelvis tilts it slightly back, which increases abdominal activity compared with a relaxed plank.",
                mistake: "Holding the breath with the lower back arched.",
                correct: "Tuck the pelvis slightly, squeeze the glutes, pull the ribs down and keep breathing."
            ),
            TechniqueCue(
                id: "head",
                title: "Head Position",
                intro: "The neck is part of the line.",
                why: "A neutral neck keeps the shoulders from shrugging and the line honest.",
                mistake: "Dropping the head or craning it up to look forward.",
                correct: "Look at the floor just in front of the hands."
            ),
            TechniqueCue(
                id: "feet",
                title: "Feet",
                intro: "The feet anchor the back of the plank.",
                why: "Pressing back through the heels tightens the legs and glutes, which helps hold the pelvis in place.",
                mistake: "Legs relaxed, with the weight sinking into the hips.",
                correct: "Feet hip-width, toes tucked, legs straight and pressing back."
            )
        ],
        activation: [
            MuscleActivation(name: "Rectus Abdominis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.78),
            MuscleActivation(name: "Obliques", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.56),
            MuscleActivation(name: "Gluteus Maximus", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.36)
        ],
        stabilisers: ["transverse abdominis", "serratus anterior", "quadriceps", "shoulders"],
        setup: [
            "Kneel on a mat and set your elbows under your shoulders.",
            "Step your feet back, toes tucked, hip-width apart.",
            "Lift your knees and hold a straight line from head to heels."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIPS SAGGING",
            correctCue: "Body straight, ribs down",
            mistakeCue: "Hips sink toward the floor",
            correctNote: "With the ribs down and glutes tight, the abs hold the trunk straight against gravity.",
            mistakeNote: "Sagging hips hand the hold to the lower back's ligaments and the abs stop working."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.14, ry: 0.07, cx: 0.50, cy: 0.52),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.07, cx: 0.45, cy: 0.52)
        ]
    )

    // MARK: - Abs content (2026-09-24)
    //
    // Crunches, leg raises, rollout, side plank and rotation lifts on the
    // 088-099 models. Generated by `Tools/trainer-content/gen.py` from
    // `spec_abs.py`. Sources: Escamilla 2006 (Phys Ther, traditional vs
    // nontraditional ab exercises), Escamilla 2010 (JOSPT, rollout and pike),
    // the ACE-sponsored San Diego State study (captain's chair, reverse
    // crunch), Youdas 2008 (JSCR, crunch/side bridge), McGill 1996 (quadratus
    // lumborum in side support) and McGill 2010 (SCJ, core stiffness), Youdas
    // 2014 (Sports Health, side bridge). "Hip Flexors" and "Quadratus
    // Lumborum" have no MusclePart, so recovery ignores them by design.

    static let crunchContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "curl", label: "Curl ribs toward the pelvis",
                          labelPoint: CGPoint(x: 0.506, y: 0.75),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "neck", label: "Hands support, don't pull",
                          labelPoint: CGPoint(x: 0.536, y: 0.15),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "low", label: "Lower back stays down",
                          labelPoint: CGPoint(x: 0.406, y: 0.63),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "feet", label: "Feet flat, knees bent",
                          labelPoint: CGPoint(x: 0.406, y: 0.87),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "range", label: "Shoulder blades just off",
                          labelPoint: CGPoint(x: 0.550, y: 0.28),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "curl",
                title: "Spinal Flexion",
                intro: "A crunch is a curl of the spine, not a sit-up.",
                why: "The rectus abdominis flexes the trunk by pulling the ribs toward the pelvis, so a short curl works it without handing the job to the hip flexors.",
                mistake: "Sitting all the way up, which turns the second half of the rep into a hip-flexor exercise.",
                correct: "Curl the upper back off the floor as if closing the gap between ribs and hips, then lower slowly."
            ),
            TechniqueCue(
                id: "neck",
                title: "Hand Position",
                intro: "The hands only cradle the head.",
                why: "Pulling on the head flexes the neck instead of the trunk and loads the cervical spine.",
                mistake: "Yanking the head forward with the hands, chin jammed into the chest.",
                correct: "Rest the fingertips behind the ears, elbows wide, and keep a fist's space between chin and chest."
            ),
            TechniqueCue(
                id: "low",
                title: "Lower Back",
                intro: "The lower back stays in contact with the floor.",
                why: "Keeping the pelvis still keeps the movement in the trunk, where the abdominals work.",
                mistake: "Arching the lower back or lifting the hips to gain momentum.",
                correct: "Keep the lower back and hips resting on the mat for every rep."
            ),
            TechniqueCue(
                id: "feet",
                title: "Leg Position",
                intro: "Bent knees take the hip flexors out of it.",
                why: "With the knees bent and feet flat, the hip flexors are slack and cannot pull the trunk up for the abs.",
                mistake: "Hooking the feet under something, which lets the hip flexors turn it into a sit-up.",
                correct: "Bend the knees to about 90° with the feet flat and free."
            ),
            TechniqueCue(
                id: "range",
                title: "Range of Motion",
                intro: "A short range is enough.",
                why: "The abdominals do most of their work in the first 30° of trunk flexion; past the point where the shoulder blades leave the floor, the hip flexors take over.",
                mistake: "Chasing a bigger range by swinging the arms or sitting up.",
                correct: "Lift until the shoulder blades clear the floor, pause, and lower under control."
            )
        ],
        activation: [
            MuscleActivation(name: "Rectus Abdominis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.80),
            MuscleActivation(name: "Obliques", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.45)
        ],
        stabilisers: ["transverse abdominis", "neck flexors"],
        setup: [
            "Lie on your back on a mat, knees bent, feet flat.",
            "Rest your fingertips behind your ears, elbows wide.",
            "Press your lower back gently into the mat."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "PULLING ON THE NECK",
            correctCue: "Ribs curl toward the hips",
            mistakeCue: "Hands pull the head forward",
            correctNote: "Curling from the trunk keeps the rectus abdominis doing the lifting.",
            mistakeNote: "Pulling the head forward flexes the neck instead of the trunk, so the abs do less and the neck takes the strain."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let reverseCrunchContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "pelvis", label: "Curl the hips off the floor",
                          labelPoint: CGPoint(x: 0.494, y: 0.63),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "knees", label: "Knees stay bent ~90°",
                          labelPoint: CGPoint(x: 0.609, y: 0.28),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "control", label: "Lower slowly, no swing",
                          labelPoint: CGPoint(x: 0.420, y: 0.15),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "arms", label: "Arms flat for balance",
                          labelPoint: CGPoint(x: 0.594, y: 0.87),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "upper", label: "Upper back stays down",
                          labelPoint: CGPoint(x: 0.594, y: 0.75),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest")
        ],
        cues: [
            TechniqueCue(
                id: "pelvis",
                title: "Pelvic Curl",
                intro: "The work is in rolling the pelvis up, not moving the legs.",
                why: "Curling the pelvis toward the ribs flexes the lumbar spine from below, which is how the reverse crunch works the rectus abdominis and obliques.",
                mistake: "Swinging the knees toward the chest without the hips ever leaving the floor.",
                correct: "Tilt the pelvis back and peel the hips off the mat, as if pouring the knees toward your face."
            ),
            TechniqueCue(
                id: "knees",
                title: "Knee Angle",
                intro: "Keep the legs as a fixed lever.",
                why: "A fixed 90° knee keeps the load short and steady, so the abs, not the hip flexors, set the pace.",
                mistake: "Straightening and bending the legs to kick the hips up.",
                correct: "Hold the knees bent at about 90° from the first rep to the last."
            ),
            TechniqueCue(
                id: "control",
                title: "Tempo",
                intro: "The way down counts as much as the way up.",
                why: "Lowering slowly keeps tension on the abdominals and stops momentum doing the next rep.",
                mistake: "Dropping the hips and bouncing into the next rep.",
                correct: "Take about two seconds to lower the hips back to the mat."
            ),
            TechniqueCue(
                id: "arms",
                title: "Arm Position",
                intro: "The arms steady the body.",
                why: "Arms flat on the floor give a wide base so the pelvis can curl without rolling.",
                mistake: "Pushing hard through the hands to throw the hips up.",
                correct: "Rest the arms beside you, palms down, and keep them relaxed."
            ),
            TechniqueCue(
                id: "upper",
                title: "Upper Body",
                intro: "The upper back stays on the mat.",
                why: "Keeping the shoulders down isolates the curl to the lower end of the trunk.",
                mistake: "Lifting the head and shoulders to help the legs up.",
                correct: "Rest the head and shoulders on the mat for the whole set."
            )
        ],
        activation: [
            MuscleActivation(name: "Rectus Abdominis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.82),
            MuscleActivation(name: "Obliques", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.58),
            MuscleActivation(name: "Hip Flexors", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.42)
        ],
        stabilisers: ["transverse abdominis"],
        setup: [
            "Lie on your back on a mat, arms flat beside you.",
            "Lift your legs so your knees are bent about 90° over your hips.",
            "Keep your head and shoulders resting on the mat."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SWINGING THE LEGS",
            correctCue: "Pelvis curls off the mat",
            mistakeCue: "Legs swing, hips stay down",
            correctNote: "Curling the pelvis up makes the abdominals flex the spine from below.",
            mistakeNote: "Swinging the legs moves them with the hip flexors and momentum while the abs barely work."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let declineCrunchContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "curl", label: "Curl, don't sit up",
                          labelPoint: CGPoint(x: 0.638, y: 0.87),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "feet", label: "Feet locked under the pads",
                          labelPoint: CGPoint(x: 0.479, y: 0.15),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "neck", label: "Hands support the head",
                          labelPoint: CGPoint(x: 0.580, y: 0.28),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "low", label: "Lower back stays on the bench",
                          labelPoint: CGPoint(x: 0.523, y: 0.63),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "control", label: "Lower slowly",
                          labelPoint: CGPoint(x: 0.726, y: 0.75),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "curl",
                title: "Spinal Flexion",
                intro: "The decline makes the crunch harder, not longer.",
                why: "Lying head-down increases the load on the rectus abdominis through the same short curl as a floor crunch.",
                mistake: "Coming all the way up to the knees, which turns it into a hip-flexor-driven sit-up.",
                correct: "Curl the ribs toward the hips until the shoulder blades clear the bench, then lower."
            ),
            TechniqueCue(
                id: "feet",
                title: "Anchor",
                intro: "The foot pads hold you on the bench.",
                why: "Hooked feet keep you from sliding, but pulling with them lets the hip flexors lift the trunk.",
                mistake: "Pulling hard against the pads to yank the body up.",
                correct: "Hook the ankles under the pads and keep the legs relaxed."
            ),
            TechniqueCue(
                id: "neck",
                title: "Hand Position",
                intro: "Cradle the head, never pull it.",
                why: "Pulling on the head flexes the neck instead of the trunk.",
                mistake: "Jerking the head forward with the hands.",
                correct: "Fingertips behind the ears or arms crossed on the chest, chin off the chest."
            ),
            TechniqueCue(
                id: "low",
                title: "Lower Back",
                intro: "The curl comes from above the pelvis.",
                why: "Keeping the lower back on the bench keeps the hips out of the movement.",
                mistake: "Lifting the whole back off the bench in one piece.",
                correct: "Keep the lower back pressed to the bench as the upper back curls."
            ),
            TechniqueCue(
                id: "control",
                title: "Tempo",
                intro: "Gravity pulls harder on a decline.",
                why: "Controlling the way down keeps the abdominals loaded and protects the lower back.",
                mistake: "Falling back onto the bench between reps.",
                correct: "Lower over about two seconds and start the next rep without bouncing."
            )
        ],
        activation: [
            MuscleActivation(name: "Rectus Abdominis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.84),
            MuscleActivation(name: "Obliques", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.48),
            MuscleActivation(name: "Hip Flexors", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["transverse abdominis", "quadriceps"],
        setup: [
            "Set the bench to a slight decline.",
            "Hook your ankles under the foot pads and lie back.",
            "Rest your fingertips behind your ears, or cross your arms on your chest."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "FULL SIT-UP",
            correctCue: "Short curl, back on the bench",
            mistakeCue: "Sitting all the way up",
            correctNote: "A short curl keeps the extra load of the decline on the abdominals.",
            mistakeNote: "Sitting all the way up lets the hip flexors pull the trunk and adds compressive load on the lower back."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let cableCrunchContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "rope", label: "Rope fixed beside the head",
                          labelPoint: CGPoint(x: 0.479, y: 0.14),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "curl", label: "Curl elbows toward the thighs",
                          labelPoint: CGPoint(x: 0.477, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "hips", label: "Hips stay high and still",
                          labelPoint: CGPoint(x: 0.550, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "knees", label: "Kneel on a mat",
                          labelPoint: CGPoint(x: 0.303, y: 0.86),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "feet", label: "Feet relaxed behind",
                          labelPoint: CGPoint(x: 0.376, y: 0.68),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "rope",
                title: "Rope Position",
                intro: "The arms only hold the rope.",
                why: "Holding the rope fixed beside the head makes the trunk move the load, not the arms.",
                mistake: "Pulling the rope down with the arms and shoulders.",
                correct: "Hold the rope ends beside the ears and keep them there for the whole rep."
            ),
            TechniqueCue(
                id: "curl",
                title: "Spinal Flexion",
                intro: "Round the spine; don't hinge at the hips.",
                why: "Curling the ribs toward the pelvis loads the rectus abdominis through spinal flexion, the movement it actually produces.",
                mistake: "Bowing forward from the hips with a flat back, which only moves the weight with body weight.",
                correct: "Exhale and curl the chest down toward the thighs, rounding the upper and mid back."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Position",
                intro: "The hips stay put.",
                why: "Fixed hips stop you from sitting back onto the heels to drag the weight down.",
                mistake: "Sitting the hips back toward the heels as the weight comes down.",
                correct: "Keep the hips stacked over the knees throughout."
            ),
            TechniqueCue(
                id: "knees",
                title: "Kneeling Base",
                intro: "A stable base lets you load the abs.",
                why: "Kneeling on a mat a short distance from the stack keeps the cable pulling straight down through the rope.",
                mistake: "Kneeling so far back that the cable pulls you forward off balance.",
                correct: "Kneel on a mat about an arm's length from the stack, knees hip-width."
            ),
            TechniqueCue(
                id: "feet",
                title: "Lower Legs",
                intro: "The lower legs just rest.",
                why: "Relaxed lower legs keep the body still so only the spine moves.",
                mistake: "Pushing up onto the toes to lever the body down.",
                correct: "Rest the tops of the feet on the floor behind you."
            )
        ],
        activation: [
            MuscleActivation(name: "Rectus Abdominis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Obliques", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.52)
        ],
        stabilisers: ["latissimus dorsi", "transverse abdominis"],
        setup: [
            "Attach a rope to the high pulley.",
            "Kneel on a mat about an arm's length from the stack.",
            "Hold the rope ends beside your head, hips over your knees."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HINGING AT THE HIPS",
            correctCue: "Spine curls, hips still",
            mistakeCue: "Flat back bows from the hips",
            correctNote: "Rounding the spine against the cable makes the rectus abdominis lift the load.",
            mistakeNote: "Hinging with a flat back lets body weight pull the rope down, so the abdominals barely shorten."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let hangingKneeRaiseContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "grip", label: "Dead hang, shoulders active",
                          labelPoint: CGPoint(x: 0.494, y: 0.14),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "tilt", label: "Tuck the pelvis at the top",
                          labelPoint: CGPoint(x: 0.521, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "knees", label: "Knees up toward the chest",
                          labelPoint: CGPoint(x: 0.536, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "swing", label: "No swinging",
                          labelPoint: CGPoint(x: 0.259, y: 0.86),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "torso", label: "Torso stays still",
                          labelPoint: CGPoint(x: 0.653, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest")
        ],
        cues: [
            TechniqueCue(
                id: "grip",
                title: "Hang",
                intro: "A steady hang is the base of the rep.",
                why: "Gripping the bar with the shoulders gently pulled down keeps the body from swinging, so the trunk does the work.",
                mistake: "Hanging loose from the shoulders and swaying between reps.",
                correct: "Grip just outside shoulder-width and pull the shoulders slightly down away from the ears."
            ),
            TechniqueCue(
                id: "tilt",
                title: "Pelvic Tilt",
                intro: "Lifting the knees is the hip flexors; curling the pelvis is the abs.",
                why: "The abdominals are worked when the pelvis tilts back and the lower spine curls at the top of the lift.",
                mistake: "Raising the knees to hip height with the lower back still arched.",
                correct: "As the knees pass hip height, keep going by curling the pelvis up toward the ribs."
            ),
            TechniqueCue(
                id: "knees",
                title: "Range of Motion",
                intro: "Knees high, then higher.",
                why: "Taking the knees toward the chest gives the pelvis room to curl, which is where the abs do most of the work.",
                mistake: "Stopping with the thighs just below horizontal.",
                correct: "Draw the knees up toward the chest and pause briefly at the top."
            ),
            TechniqueCue(
                id: "swing",
                title: "Control",
                intro: "Momentum is the enemy.",
                why: "Swinging lets the body's pendulum lift the legs instead of the trunk muscles.",
                mistake: "Kicking the legs back to swing them up.",
                correct: "Lower the legs slowly and let the body settle before the next rep."
            ),
            TechniqueCue(
                id: "torso",
                title: "Upper Body",
                intro: "The torso stays under the bar.",
                why: "A still torso means the lift comes from the hips and trunk.",
                mistake: "Leaning back or pulling up with the arms to help the legs rise.",
                correct: "Keep the arms straight and the chest under the bar."
            )
        ],
        activation: [
            MuscleActivation(name: "Rectus Abdominis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.80),
            MuscleActivation(name: "Hip Flexors", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.76),
            MuscleActivation(name: "Obliques", rank: .secondary,
                             activation: "HIGH ACTIVATION", fraction: 0.64)
        ],
        stabilisers: ["forearms", "latissimus dorsi", "shoulders"],
        setup: [
            "Grip the bar just outside shoulder-width.",
            "Hang with straight arms, shoulders pulled slightly down.",
            "Let your legs hang still before the first rep."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "NO PELVIC CURL",
            correctCue: "Pelvis curls at the top",
            mistakeCue: "Knees rise, pelvis stays flat",
            correctNote: "Curling the pelvis at the top brings the abdominals in on top of the hip flexors.",
            mistakeNote: "Stopping at hip height leaves the lift almost entirely to the hip flexors."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let hangingLegRaiseContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "grip", label: "Dead hang, shoulders active",
                          labelPoint: CGPoint(x: 0.494, y: 0.14),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "tilt", label: "Curl the pelvis at the top",
                          labelPoint: CGPoint(x: 0.479, y: 0.50),
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "legs", label: "Legs straight, lift to level",
                          labelPoint: CGPoint(x: 0.508, y: 0.68),
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "swing", label: "Lower slowly, no swing",
                          labelPoint: CGPoint(x: 0.420, y: 0.86),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "torso", label: "Torso stays under the bar",
                          labelPoint: CGPoint(x: 0.536, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest")
        ],
        cues: [
            TechniqueCue(
                id: "grip",
                title: "Hang",
                intro: "A steady hang keeps the lift honest.",
                why: "Shoulders pulled slightly down and a firm grip stop the body swinging as the long legs move.",
                mistake: "Hanging loose and swaying.",
                correct: "Grip just outside shoulder-width and set the shoulders down away from the ears."
            ),
            TechniqueCue(
                id: "tilt",
                title: "Pelvic Tilt",
                intro: "The abs work when the pelvis curls, not while the legs travel.",
                why: "The hip flexors lift the straight legs; the abdominals are worked most as the pelvis tilts back at the top.",
                mistake: "Lifting the legs with the lower back arched throughout.",
                correct: "As the legs reach level, curl the pelvis up and slightly forward."
            ),
            TechniqueCue(
                id: "legs",
                title: "Leg Position",
                intro: "Straight legs make a long, heavy lever.",
                why: "Straight legs put the weight of the legs much further from the hip than a knee raise does, so the trunk has to work harder to control the pelvis.",
                mistake: "Bending the knees halfway up to make it easier, then calling it a leg raise.",
                correct: "Keep the knees straight and lift the feet at least to hip height."
            ),
            TechniqueCue(
                id: "swing",
                title: "Control",
                intro: "The way down decides the next rep.",
                why: "A slow return stops the legs swinging back and throwing the next rep up with momentum.",
                mistake: "Dropping the legs and swinging into the next rep.",
                correct: "Lower over two seconds and pause at the bottom."
            ),
            TechniqueCue(
                id: "torso",
                title: "Upper Body",
                intro: "Stay under the bar.",
                why: "A still torso keeps the effort in the hips and trunk.",
                mistake: "Leaning back to counterbalance the legs.",
                correct: "Arms straight, chest under the bar."
            )
        ],
        activation: [
            MuscleActivation(name: "Rectus Abdominis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.84),
            MuscleActivation(name: "Hip Flexors", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.86),
            MuscleActivation(name: "Obliques", rank: .secondary,
                             activation: "HIGH ACTIVATION", fraction: 0.62)
        ],
        stabilisers: ["forearms", "latissimus dorsi", "quadriceps"],
        setup: [
            "Grip the bar just outside shoulder-width.",
            "Hang with straight arms, shoulders pulled slightly down.",
            "Keep your legs straight and together, and stop any swing."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "SWINGING",
            correctCue: "Slow, still torso",
            mistakeCue: "Legs swing up with momentum",
            correctNote: "A controlled lift makes the hip flexors and abdominals move and hold the long legs.",
            mistakeNote: "Swinging uses the body as a pendulum, so the trunk muscles do much less of the lift."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let captainsChairLegRaiseContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "back", label: "Back against the pad",
                          labelPoint: CGPoint(x: 0.609, y: 0.32),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "arms", label: "Forearms on the pads",
                          labelPoint: CGPoint(x: 0.609, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "tilt", label: "Curl the pelvis up",
                          labelPoint: CGPoint(x: 0.638, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "legs", label: "Legs straight to level",
                          labelPoint: CGPoint(x: 0.580, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "control", label: "Lower slowly",
                          labelPoint: CGPoint(x: 0.274, y: 0.86),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "back",
                title: "Back Pad",
                intro: "The pad keeps the body from swinging.",
                why: "With the back against the pad, momentum is removed and the lift has to come from the trunk and hips.",
                mistake: "Leaning away from the pad to swing the legs.",
                correct: "Press the lower and upper back lightly into the pad throughout."
            ),
            TechniqueCue(
                id: "arms",
                title: "Support",
                intro: "The forearms carry the body.",
                why: "Supporting yourself on the forearms frees the hands and keeps the shoulders stable.",
                mistake: "Shrugging the shoulders up toward the ears.",
                correct: "Rest the forearms on the pads, grip the handles and push the shoulders down."
            ),
            TechniqueCue(
                id: "tilt",
                title: "Pelvic Tilt",
                intro: "Finish by curling the pelvis.",
                why: "In the ACE-sponsored comparison of 13 ab exercises, the captain's chair ranked first for the obliques and second for the rectus abdominis — the pelvic curl at the top is what engages them.",
                mistake: "Lifting the legs with the lower back arched off the pad.",
                correct: "As the legs come up, tilt the pelvis back so the lower back flattens into the pad."
            ),
            TechniqueCue(
                id: "legs",
                title: "Leg Position",
                intro: "Straight legs make it harder.",
                why: "A long lever raises the load on the hip flexors and the abdominals controlling the pelvis; bent knees are the easier version.",
                mistake: "Letting the knees bend as fatigue sets in without noticing.",
                correct: "Keep the legs straight and lift them to at least hip height."
            ),
            TechniqueCue(
                id: "control",
                title: "Tempo",
                intro: "Control the way down.",
                why: "Lowering slowly keeps the trunk loaded and stops the legs swinging under the chair.",
                mistake: "Dropping the legs back down.",
                correct: "Lower over about two seconds and stop before the feet swing back."
            )
        ],
        activation: [
            MuscleActivation(name: "Rectus Abdominis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.82),
            MuscleActivation(name: "Hip Flexors", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.80),
            MuscleActivation(name: "Obliques", rank: .secondary,
                             activation: "HIGH ACTIVATION", fraction: 0.66)
        ],
        stabilisers: ["shoulders", "triceps", "quadriceps"],
        setup: [
            "Step up and rest your forearms on the arm pads.",
            "Grip the handles and press your back against the pad.",
            "Let your legs hang straight below you."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "LOWER BACK ARCHED",
            correctCue: "Pelvis curls, back to the pad",
            mistakeCue: "Back arches off the pad",
            correctNote: "Flattening the lower back into the pad as the legs rise brings the abdominals into the lift.",
            mistakeNote: "With the back arched, the hip flexors lift the legs and pull on the lumbar spine while the abs do little."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let abWheelRolloutContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "hips", label: "Hips don't sag",
                          labelPoint: CGPoint(x: 0.697, y: 0.63),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "reach", label: "Stop before the back arches",
                          labelPoint: CGPoint(x: 0.494, y: 0.75),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "ribs", label: "Ribs down, back slightly rounded",
                          labelPoint: CGPoint(x: 0.433, y: 0.28),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "knees", label: "Kneel on a pad",
                          labelPoint: CGPoint(x: 0.697, y: 0.87),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "patella_L"),
            CueAnnotation(cueID: "return", label: "Pull back with the abs",
                          labelPoint: CGPoint(x: 0.420, y: 0.15),
                          leaderLength: 40, joint: "scapula_L")
        ],
        cues: [
            TechniqueCue(
                id: "hips",
                title: "Hip Position",
                intro: "The rollout is a moving plank.",
                why: "The abdominals work to stop the lower back arching as the wheel travels away; once the hips sag, the load moves onto the spine.",
                mistake: "Letting the hips drop toward the floor at the far end.",
                correct: "Keep a slight posterior pelvic tilt so the hips and trunk move as one."
            ),
            TechniqueCue(
                id: "reach",
                title: "Range of Motion",
                intro: "Go only as far as you can hold the position.",
                why: "Rollouts produce some of the highest rectus abdominis and oblique activity measured in EMG studies, so a shorter, controlled reach is still very hard.",
                mistake: "Rolling out to full length on the first rep and collapsing.",
                correct: "Roll out until you feel the lower back start to arch, then stop and return."
            ),
            TechniqueCue(
                id: "ribs",
                title: "Trunk Position",
                intro: "Keep the ribs pulled toward the pelvis.",
                why: "Ribs down and a slightly rounded upper back keep the abdominals shortened enough to resist extension.",
                mistake: "Looking up and flaring the ribs, which arches the back.",
                correct: "Look at the floor, brace, and keep the ribs tucked throughout."
            ),
            TechniqueCue(
                id: "knees",
                title: "Base",
                intro: "Kneeling is the standard version.",
                why: "A padded kneeling base shortens the lever compared with the standing rollout, which is for advanced lifters.",
                mistake: "Kneeling on a hard floor, which shifts the focus to the knees.",
                correct: "Kneel on a mat with the knees hip-width and the wheel under the shoulders."
            ),
            TechniqueCue(
                id: "return",
                title: "Return",
                intro: "Come back with the trunk, not the hips.",
                why: "Pulling back by flexing the trunk keeps the abdominals and lats working; pushing the hips back first shortens the lever and skips the hard part.",
                mistake: "Sticking the hips back to drag the wheel home.",
                correct: "Pull the wheel back toward the knees by curling the trunk, hips following."
            )
        ],
        activation: [
            MuscleActivation(name: "Rectus Abdominis", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.88),
            MuscleActivation(name: "Obliques", rank: .secondary,
                             activation: "HIGH ACTIVATION", fraction: 0.68),
            MuscleActivation(name: "Latissimus Dorsi", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.48)
        ],
        stabilisers: ["triceps", "shoulders", "gluteus maximus"],
        setup: [
            "Kneel on a mat, knees hip-width apart.",
            "Hold the wheel handles under your shoulders, arms straight.",
            "Brace your abs and tuck your pelvis slightly."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIPS SAGGING",
            correctCue: "Hips and trunk in one line",
            mistakeCue: "Lower back arches, hips drop",
            correctNote: "Holding a slight pelvic tuck makes the abdominals resist the stretch as the wheel rolls out.",
            mistakeNote: "When the hips sag, the lumbar spine extends under load and the abs stop protecting it."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let sidePlankContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "elbow", label: "Elbow under the shoulder",
                          labelPoint: CGPoint(x: 0.550, y: 0.87),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "forearm_L"),
            CueAnnotation(cueID: "hips", label: "Hips lifted, no sag",
                          labelPoint: CGPoint(x: 0.624, y: 0.63),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "line", label: "Straight line head to feet",
                          labelPoint: CGPoint(x: 0.521, y: 0.28),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "feet", label: "Feet stacked",
                          labelPoint: CGPoint(x: 0.274, y: 0.75),
                          leaderLength: 40, joint: "foot_L"),
            CueAnnotation(cueID: "head", label: "Head in line",
                          labelPoint: CGPoint(x: 0.726, y: 0.15),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "head")
        ],
        cues: [
            TechniqueCue(
                id: "elbow",
                title: "Support Arm",
                intro: "The shoulder sits over the elbow.",
                why: "An elbow directly under the shoulder lets the arm hold the body on bone, so the trunk muscles do the holding.",
                mistake: "Placing the elbow far in front of the shoulder, which strains it.",
                correct: "Set the forearm flat with the elbow under the shoulder and push the floor away."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hip Height",
                intro: "The bottom obliques hold the hips up.",
                why: "The side plank loads the obliques and quadratus lumborum — about 54% of maximum in McGill's measurements — with low compressive load on the spine.",
                mistake: "Letting the bottom hip sag toward the floor.",
                correct: "Lift the hips until the body is straight and keep pushing them up for the whole hold."
            ),
            TechniqueCue(
                id: "line",
                title: "Body Line",
                intro: "No bending forward or back.",
                why: "A straight line keeps the load across the side of the trunk instead of letting the body rotate out of it.",
                mistake: "Piking the hips back or rolling the chest toward the floor.",
                correct: "Stack the shoulders over each other and keep the hips in line with them."
            ),
            TechniqueCue(
                id: "feet",
                title: "Feet",
                intro: "The feet are the other end of the bridge.",
                why: "Stacked feet make the hold harder; staggering them front to back is an easier option.",
                mistake: "Rolling onto the edge of the bottom foot and losing the line.",
                correct: "Stack the top foot on the bottom one, or stagger them to make it easier."
            ),
            TechniqueCue(
                id: "head",
                title: "Head Position",
                intro: "The neck is part of the line.",
                why: "A neutral neck keeps the shoulders relaxed and the line honest.",
                mistake: "Letting the head drop toward the floor.",
                correct: "Keep the head in line with the spine, eyes forward."
            )
        ],
        activation: [
            MuscleActivation(name: "Obliques", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.78),
            MuscleActivation(name: "Quadratus Lumborum", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.54),
            MuscleActivation(name: "Gluteus Medius", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.46)
        ],
        stabilisers: ["transverse abdominis", "rectus abdominis", "shoulders"],
        setup: [
            "Lie on your side on a mat, legs straight and stacked.",
            "Place your elbow directly under your shoulder.",
            "Rest your top hand on your hip, then lift your hips."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "HIPS SAGGING",
            correctCue: "Hips up, body straight",
            mistakeCue: "Bottom hip sinks",
            correctNote: "Holding the hips up makes the lower obliques and quadratus lumborum support the trunk.",
            mistakeNote: "When the hip sags, the body hangs on the spine and shoulder instead of the trunk muscles."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let russianTwistContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "rotate", label: "Rotate from the ribs",
                          labelPoint: CGPoint(x: 0.609, y: 0.63),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "ball", label: "Ball moves with the chest",
                          labelPoint: CGPoint(x: 0.536, y: 0.28),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "lean", label: "Lean back, spine long",
                          labelPoint: CGPoint(x: 0.594, y: 0.15),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "head"),
            CueAnnotation(cueID: "hips", label: "Hips stay still",
                          labelPoint: CGPoint(x: 0.682, y: 0.75),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "feet", label: "Feet on the floor",
                          labelPoint: CGPoint(x: 0.347, y: 0.87),
                          leaderLength: 40, joint: "foot_L")
        ],
        cues: [
            TechniqueCue(
                id: "rotate",
                title: "Rotation",
                intro: "Turn the ribcage, not just the arms.",
                why: "The obliques rotate the trunk, so the rib cage has to turn over the pelvis for them to work.",
                mistake: "Swinging the ball side to side with the arms while the chest stays facing forward.",
                correct: "Turn the chest and shoulders together toward each side, following the ball with the eyes."
            ),
            TechniqueCue(
                id: "ball",
                title: "Load Position",
                intro: "Keep the ball close.",
                why: "A ball held near the chest keeps the load on the trunk rather than the shoulders.",
                mistake: "Reaching the ball far away from the body to tap the floor.",
                correct: "Hold the ball at chest height, elbows bent, and move it only as far as the chest turns."
            ),
            TechniqueCue(
                id: "lean",
                title: "Torso Angle",
                intro: "A long spine, leaning back.",
                why: "Leaning back about 45° makes the abdominals hold the trunk up while the obliques rotate it.",
                mistake: "Slumping into a rounded lower back.",
                correct: "Sit tall, then lean back with a straight spine until the abs switch on."
            ),
            TechniqueCue(
                id: "hips",
                title: "Pelvis",
                intro: "The hips are the fixed point.",
                why: "A still pelvis means the rotation happens in the trunk, where the obliques act.",
                mistake: "Rocking the hips and knees side to side with each twist.",
                correct: "Keep the knees together and pointing forward as the chest turns."
            ),
            TechniqueCue(
                id: "feet",
                title: "Feet",
                intro: "Feet down is the base version.",
                why: "Keeping the feet on the floor stabilises the pelvis and keeps the load on the rotation, not on balance.",
                mistake: "Lifting the feet before you can control the twist.",
                correct: "Rest the heels on the floor; lift them only once the twist stays controlled."
            )
        ],
        activation: [
            MuscleActivation(name: "Obliques", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.76),
            MuscleActivation(name: "Rectus Abdominis", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.52),
            MuscleActivation(name: "Hip Flexors", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.38)
        ],
        stabilisers: ["transverse abdominis", "erector spinae"],
        setup: [
            "Sit on a mat with your knees bent and heels on the floor.",
            "Hold a medicine ball at chest height.",
            "Lean back about 45° with a straight spine."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "ARMS ONLY",
            correctCue: "Chest turns with the ball",
            mistakeCue: "Arms swing, chest faces forward",
            correctNote: "Turning the rib cage over a still pelvis makes the obliques do the rotation.",
            mistakeNote: "Swinging the ball with the arms moves the load without rotating the trunk, so the obliques barely work."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    static let cableWoodChopContent = ExerciseContent(
        annotations: [
            CueAnnotation(cueID: "arms", label: "Arms long, handle close",
                          labelPoint: CGPoint(x: 0.435, y: 0.32),
                          leaderLength: 40, joint: "hand_L"),
            CueAnnotation(cueID: "rotate", label: "Rotate the trunk",
                          labelPoint: CGPoint(x: 0.668, y: 0.14),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "chest"),
            CueAnnotation(cueID: "hips", label: "Hips turn with you",
                          labelPoint: CGPoint(x: 0.638, y: 0.68),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "pelvis"),
            CueAnnotation(cueID: "pivot", label: "Pivot the back foot",
                          labelPoint: CGPoint(x: 0.376, y: 0.86),
                          leaderLength: 40, joint: "foot_R"),
            CueAnnotation(cueID: "brace", label: "Brace before you chop",
                          labelPoint: CGPoint(x: 0.594, y: 0.50),
                          labelSide: .trailing,
                          leaderLength: 40, joint: "spine")
        ],
        cues: [
            TechniqueCue(
                id: "arms",
                title: "Arm Position",
                intro: "The arms transfer the force; they don't make it.",
                why: "With straight arms, the load on the handle can only move if the trunk rotates, which puts the work on the obliques.",
                mistake: "Bending the elbows and pulling the handle down with the arms.",
                correct: "Keep the arms long and the handle in front of the chest as it travels."
            ),
            TechniqueCue(
                id: "rotate",
                title: "Rotation",
                intro: "Turn the chest diagonally, high to low.",
                why: "The obliques rotate and flex the trunk together, which is exactly the diagonal path of the chop.",
                mistake: "Bending sideways at the waist instead of turning.",
                correct: "Turn the chest from the high pulley down toward the opposite hip."
            ),
            TechniqueCue(
                id: "hips",
                title: "Hips",
                intro: "Power starts at the hips.",
                why: "Letting the hips turn a little spreads the rotation between hips and trunk and protects the lower back from twisting alone.",
                mistake: "Locking the hips and wringing all the rotation out of the lumbar spine.",
                correct: "Let the hips turn slightly with the chest, knees soft."
            ),
            TechniqueCue(
                id: "pivot",
                title: "Footwork",
                intro: "The back foot pivots.",
                why: "Pivoting on the back foot lets the hips rotate without twisting the knee.",
                mistake: "Keeping both feet flat so the knee takes the twist.",
                correct: "Stand wider than the shoulders and let the back heel lift and turn as you chop."
            ),
            TechniqueCue(
                id: "brace",
                title: "Bracing",
                intro: "Stiffen, then move.",
                why: "Bracing the trunk first stiffens the spine so the hips and shoulders move around it, the job McGill describes as the core's main one.",
                mistake: "Chopping loose and fast so the spine whips around.",
                correct: "Brace the abs, then chop in a smooth, controlled arc and return slowly."
            )
        ],
        activation: [
            MuscleActivation(name: "Obliques", rank: .primary,
                             activation: "HIGH ACTIVATION", fraction: 0.78),
            MuscleActivation(name: "Rectus Abdominis", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.44),
            MuscleActivation(name: "Transverse Abdominis", rank: .secondary,
                             activation: "MODERATE ACTIVATION", fraction: 0.40)
        ],
        stabilisers: ["gluteus maximus", "latissimus dorsi", "shoulders"],
        setup: [
            "Set a handle on the high pulley and stand side-on to the stack.",
            "Take a wide stance and hold the handle with both hands.",
            "Start with straight arms reaching up toward the pulley."
        ],
        comparison: FormComparisonCopy(
            correctBadge: "CORRECT FORM",
            mistakeBadge: "PULLING WITH THE ARMS",
            correctCue: "Straight arms, trunk rotates",
            mistakeCue: "Elbows bend to pull the handle",
            correctNote: "Straight arms mean the handle moves only when the trunk rotates, loading the obliques.",
            mistakeNote: "Bending the arms turns the chop into a cable pull, and the obliques do little of the work."
        ),
        glows: [
            .init(DS.activation.opacity(0.55), rx: 0.12, ry: 0.10, cx: 0.50, cy: 0.50),
            .init(DS.activationSoft.opacity(0.30), rx: 0.10, ry: 0.08, cx: 0.50, cy: 0.42)
        ]
    )

    // MARK: - Home

    static let userName = "Alex"

    static let muscleGroups: [MuscleGroupTileModel] = [
        MuscleGroupTileModel(name: "Chest", count: "24 EXERCISES"),
        MuscleGroupTileModel(name: "Back", count: "31 EXERCISES"),
        MuscleGroupTileModel(name: "Shoulders", count: "22 EXERCISES"),
        MuscleGroupTileModel(name: "Arms", count: "28 EXERCISES"),
        MuscleGroupTileModel(name: "Legs", count: "26 EXERCISES"),
        MuscleGroupTileModel(name: "Core", count: "18 EXERCISES")
    ]

    static let popular: [(name: String, meta: String)] = [
        ("Squat", "QUADRICEPS"),
        ("Deadlift", "POSTERIOR CHAIN")
    ]

    static let recentlyViewed: [RecentExercise] = [
        RecentExercise(name: "Lat Pulldown", meta: "LATS · CABLE"),
        RecentExercise(name: "Lateral Raise", meta: "LAT. DELTOID · DUMBBELL")
    ]
}
