//
//  PresetProvider.swift
//  GymWorkout
//
//  Starting points for each muscle group, built only from exercises already
//  in the library. They are presets, not programs: once added to a day the
//  user can change anything.
//

import Foundation

enum PresetProvider {

    static func preset(for group: MuscleGroup, level: PresetLevel) -> ExercisePreset? {
        guard let items = table[group]?[level], !items.isEmpty else { return nil }
        return ExercisePreset(group: group, level: level, items: items)
    }

    /// Groups the library can actually train today. Forearms, Calves and
    /// Adductors have no dedicated exercise in the library yet, so they are
    /// tracked but not offered as presets.
    static var trainableGroups: [MuscleGroup] {
        MuscleGroup.allCases.filter { preset(for: $0, level: .basic) != nil }
    }

    /// `lower`/`upper` are reps, or seconds for a timed exercise.
    private static func item(_ name: String, _ sets: Int, _ lower: Int, _ upper: Int) -> PresetItem {
        PresetItem(exerciseName: name, sets: sets, reps: RepRange(lower, upper))
    }

    /// Basic favours machines, cables and supported positions; Advanced adds
    /// free-weight compounds that demand more balance and bracing.
    private static let table: [MuscleGroup: [PresetLevel: [PresetItem]]] = [
        .chest: [
            .basic: [
                item("Chest Press Machine", 3, 10, 12),
                item("Incline Dumbbell Press", 3, 8, 12),
                item("Pec Deck Fly", 3, 12, 15)
            ],
            .advanced: [
                item("Barbell Bench Press", 4, 6, 10),
                item("Incline Barbell Bench Press", 3, 8, 10),
                item("Decline Barbell Bench Press", 3, 8, 10),
                item("Cable Fly", 3, 12, 15)
            ]
        ],
        .back: [
            .basic: [
                item("Lat Pulldown", 3, 10, 12),
                item("Seated Cable Row", 3, 10, 12),
                item("Chest-Supported Row Machine", 3, 10, 12)
            ],
            .advanced: [
                item("Pull-Up", 3, 6, 10),
                item("Barbell Bent-Over Row", 4, 6, 10),
                item("T-Bar Row", 3, 8, 12),
                item("Straight-Arm Pulldown", 3, 12, 15)
            ]
        ],
        .shoulders: [
            .basic: [
                item("Machine Shoulder Press", 3, 10, 12),
                item("Dumbbell Lateral Raise", 3, 12, 15),
                item("Reverse Pec Deck", 3, 12, 15)
            ],
            .advanced: [
                item("Barbell Overhead Press", 4, 6, 8),
                item("Arnold Press", 3, 8, 12),
                item("Cable Lateral Raise", 3, 12, 15),
                item("Face Pull", 3, 12, 15)
            ]
        ],
        .biceps: [
            .basic: [
                item("Biceps Curl", 3, 10, 12),
                item("Barbell Curl", 3, 10, 12)
            ],
            .advanced: [
                item("Chin-Up", 3, 6, 10),
                item("Barbell Curl", 4, 8, 10),
                item("Biceps Curl", 3, 10, 12)
            ]
        ],
        .triceps: [
            .basic: [
                item("Triceps Pushdown", 3, 10, 12),
                item("Rope Pushdown", 3, 12, 15),
                item("Assisted Dip", 3, 8, 12)
            ],
            .advanced: [
                item("Skull Crusher", 3, 8, 12),
                item("Overhead Cable Triceps Extension", 3, 10, 12),
                item("Bench Dip", 3, 10, 15),
                item("Single-Arm Cable Pushdown", 3, 12, 15)
            ]
        ],
        .quads: [
            .basic: [
                item("Leg Press", 3, 10, 12),
                item("Goblet Squat", 3, 10, 12),
                item("Leg Extension", 3, 12, 15)
            ],
            .advanced: [
                item("Back Squat", 4, 6, 10),
                item("Front Squat", 3, 6, 8),
                item("Bulgarian Split Squat", 3, 8, 12),
                item("Hack Squat", 3, 10, 12)
            ]
        ],
        .hamstrings: [
            .basic: [
                item("Seated Leg Curl", 3, 10, 12),
                item("Lying Leg Curl", 3, 10, 12),
                item("Dumbbell Romanian Deadlift", 3, 10, 12)
            ],
            .advanced: [
                item("Romanian Deadlift", 4, 6, 10),
                item("Stiff-Leg Deadlift", 3, 8, 10),
                item("Single-Leg Curl", 3, 10, 12),
                item("Seated Leg Curl", 3, 10, 12)
            ]
        ],
        .glutes: [
            .basic: [
                item("Glute Bridge", 3, 12, 15),
                item("Hip Abduction Machine", 3, 12, 15),
                item("Cable Glute Kickback", 3, 12, 15)
            ],
            .advanced: [
                item("Bulgarian Split Squat (Lean)", 3, 8, 12),
                item("Single-Leg Glute Bridge", 3, 10, 12),
                item("Cable Hip Abduction", 3, 12, 15),
                item("Walking Lunge", 3, 10, 12)
            ]
        ],
        .abs: [
            .basic: [
                item("Crunch", 3, 15, 20),
                item("Reverse Crunch", 3, 12, 15),
                item("Captain's Chair Leg Raise", 3, 10, 12),
                item("Plank", 3, 30, 45)
            ],
            .advanced: [
                item("Cable Crunch", 3, 10, 15),
                item("Hanging Leg Raise", 3, 8, 12),
                item("Ab Wheel Rollout", 3, 8, 10),
                item("Cable Wood Chop", 3, 10, 12),
                item("Side Plank", 3, 30, 45)
            ]
        ]
    ]
}
