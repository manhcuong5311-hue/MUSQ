# Wraps raw Blender exports (Z-up, lights, props parked off-stage) into Y-up,
# light-free stages and flattens each to one usdc.
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from curves2mesh import replace_curves
from pxr import Usd, UsdGeom, UsdLux, Sdf, Gf

SRC = "/Users/sammanhcuong/Developer/GymWorkout/SourceExports"
OUT = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models"
JOBS = {
    # Chest redo (2026-09-23) — overwrites the earlier conversion of the same six.
    "USDForapp/01_barbell_bench_press": "Chest/BarbellBenchPress",
    "USDForapp/02_incline_barbell_bench_press": "Chest/InclineBarbellBenchPress",
    "USDForapp/03_decline_barbell_bench_press": "Chest/DeclineBarbellBenchPress",
    "USDForapp/04_dumbbell_bench_press": "Chest/DumbbellBenchPress",
    "USDForapp/05_incline_dumbbell_press": "Chest/InclineDumbbellPress",
    "USDForapp/07_incline_dumbbell_fly": "Chest/InclineDumbbellFly",
    # Triceps + biceps, new (2026-09-23).
    "USDForapp/Tay/051_skull_crusher": "Triceps/SkullCrusher",
    "USDForapp/Tay/052_dumbbell_overhead_triceps_extension": "Triceps/DumbbellOverheadTricepsExtension",
    "USDForapp/Tay/053_cable_triceps_pushdown": "Triceps/CableTricepsPushdown",
    "USDForapp/Tay/054_rope_pushdown": "Triceps/RopePushdown",
    "USDForapp/Tay/055_overhead_cable_triceps_extension": "Triceps/OverheadCableTricepsExtension",
    "USDForapp/Tay/056_single_arm_cable_pushdown": "Triceps/SingleArmCablePushdown",
    "USDForapp/Tay/057_assisted_dip": "Triceps/AssistedDip",
    "USDForapp/Tay/058_bench_dip": "Triceps/BenchDip",
    "USDForapp/Tay/40_barbell_curl": "Biceps/BarbellCurl",
    # Legs, new (2026-09-23). 062/069 overwrite the earlier ad-hoc Bulgarian
    # Split Squat (upright) / Step-Up conversions with this batch's version.
    "Legs/059_back_squat": "Legs/BackSquat",
    "Legs/060_front_squat": "Legs/FrontSquat",
    "Legs/061_goblet_squat": "Legs/GobletSquat",
    "Legs/062_bulgarian_split_squat": "Legs/BulgarianSplitSquatUpright",
    "Legs/063_walking_lunge": "Legs/WalkingLunge",
    "Legs/064_reverse_lunge": "Legs/ReverseLunge",
    "Legs/065_leg_press": "Legs/LegPress",
    "Legs/066_hack_squat": "Legs/HackSquat",
    "Legs/067_leg_extension": "Legs/LegExtension",
    "Legs/068_smith_machine_squat": "Legs/SmithMachineSquat",
    "Legs/069_step_up": "Legs/StepUp",
    "Legs/070_sissy_squat": "Legs/SissySquat",
    "Legs/071_romanian_deadlift": "Legs/RomanianDeadlift",
    # Back redo (2026-09-23) — overwrites the 2026-09-22 conversion of 16-27.
    "Legs/16_one_arm_dumbbell_row": "Back/OneArmDumbbellRow",
    "Legs/17_chest_supported_dumbbell_row": "Back/ChestSupportedDumbbellRow",
    "Legs/18_pull_up": "Back/PullUp",
    "Legs/19_chin_up": "Back/ChinUp",
    "Legs/20_lat_pulldown": "Back/LatPulldown",
    "Legs/21_close_grip_lat_pulldown": "Back/CloseGripLatPulldown",
    "Legs/22_seated_cable_row": "Back/SeatedCableRow",
    "Legs/23_straight_arm_pulldown": "Back/StraightArmPulldown",
    "Legs/24_t_bar_row": "Back/TBarRow",
    "Legs/25_chest_supported_row_machine": "Back/ChestSupportedRowMachine",
    "Legs/26_high_row_machine": "Back/HighRowMachine",
    "Legs/27_back_extension": "Back/BackExtension",
    # Legs2 batch (2026-09-24): hamstrings/glutes/abductors 072-082, plus the
    # re-exports of the four legacy models that were cropped out of frame.
    # 079 is identical to Single-Leg_Glute_Bridge, so only one is converted.
    "Legs2/072_dumbbell_romanian_deadlift": "Legs/DumbbellRomanianDeadlift",
    "Legs2/073_stiff_leg_deadlift": "Legs/StiffLegDeadlift",
    "Legs2/074_lying_leg_curl": "Legs/LyingLegCurl",
    "Legs2/075_seated_leg_curl": "Legs/SeatedLegCurl",
    "Legs2/076_single_leg_curl": "Legs/SingleLegCurl",
    "Legs2/078_glute_bridge": "Legs/GluteBridge",
    "Legs2/Single-Leg_Glute_Bridge": "Legs/SingleLegGluteBridge",
    "Legs2/080_cable_glute_kickback": "Legs/CableGluteKickback",
    "Legs2/080b_cable_side_kick": "Legs/CableSideKick",
    "Legs2/081_hip_abduction_machine": "Legs/HipAbductionMachine",
    "Legs2/081_hip_abduction_machine(Lean)": "Legs/HipAbductionMachineLean",
    "Legs2/082_cable_hip_abduction": "Legs/CableHipAbduction",
    "Legs2/Step-Up": "Legs/StepUp",
    "Legs2/Push-Up": "Chest/pushup",
    "Legs2/Plank": "Abs/Plank",
    # Abs batch (2026-09-24), 088-099. 095 has the same pose as the Legs2
    # Plank and replaces it as the numbered source.
    "Abdoment/088_crunch": "Abs/Crunch",
    "Abdoment/089_cable_crunch": "Abs/CableCrunch",
    "Abdoment/090_decline_crunch": "Abs/DeclineCrunch",
    "Abdoment/091_hanging_knee_raise": "Abs/HangingKneeRaise",
    "Abdoment/092_hanging_leg_raise": "Abs/HangingLegRaise",
    "Abdoment/093_captain_s_chair_leg_raise": "Abs/CaptainsChairLegRaise",
    "Abdoment/094_reverse_crunch": "Abs/ReverseCrunch",
    "Abdoment/095_plank": "Abs/Plank",
    "Abdoment/096_side_plank": "Abs/SidePlank",
    "Abdoment/097_ab_wheel_rollout": "Abs/AbWheelRollout",
    "Abdoment/098_russian_twist": "Abs/RussianTwist",
    "Abdoment/099_cable_wood_chop": "Abs/CableWoodChop",
    # The three gated exercises plus a lean variant (2026-09-24). Squat and
    # Lunge overwrite the legacy models: this Squat is the arms-forward
    # bodyweight squat, the Lunge a stationary split-stance lunge, left leg
    # forward, and Lunge_Lean the same with a ~30° forward torso lean.
    "3 bai thieu/Biceps_Curl": "Biceps/BicepsCurl",
    "3 bai thieu/Squat": "Legs/Squat",
    "3 bai thieu/Lunge": "Legs/Lunge",
    "3 bai thieu/Lunge_Lean": "Legs/LungeLean",
    # Chest batch 101-131 (2026-09-25), copied from the HIKSEMI drive's
    # "100-131" folder; 100, 127, 129 and 130 were not exported.
    "Chest3/101_dumbbell_floor_press": "Chest/DumbbellFloorPress",
    "Chest3/102_barbell_floor_press": "Chest/BarbellFloorPress",
    "Chest3/103_smith_machine_bench_press": "Chest/SmithMachineBenchPress",
    "Chest3/104_smith_machine_incline_press": "Chest/SmithMachineInclinePress",
    "Chest3/105_smith_machine_decline_press": "Chest/SmithMachineDeclinePress",
    "Chest3/106_single_arm_dumbbell_bench_press": "Chest/SingleArmDumbbellBenchPress",
    "Chest3/107_alternating_dumbbell_bench_press": "Chest/AlternatingDumbbellBenchPress",
    "Chest3/108_neutral_grip_dumbbell_press": "Chest/NeutralGripDumbbellPress",
    "Chest3/109_dumbbell_squeeze_press": "Chest/DumbbellSqueezePress",
    "Chest3/110_incline_dumbbell_squeeze_press": "Chest/InclineDumbbellSqueezePress",
    "Chest3/111_dumbbell_pullover": "Chest/DumbbellPullover",
    "Chest3/112_barbell_pullover": "Chest/BarbellPullover",
    "Chest3/113_cable_chest_press": "Chest/CableChestPress",
    "Chest3/114_single_arm_cable_chest_press": "Chest/SingleArmCableChestPress",
    "Chest3/115_incline_cable_press": "Chest/InclineCablePress",
    "Chest3/116_decline_cable_press": "Chest/DeclineCablePress",
    "Chest3/117_high_to_low_cable_fly": "Chest/HighToLowCableFly",
    "Chest3/118_single_arm_cable_fly": "Chest/SingleArmCableFly",
    "Chest3/119_incline_cable_fly": "Chest/InclineCableFly",
    "Chest3/120_decline_cable_fly": "Chest/DeclineCableFly",
    "Chest3/121_cable_crossover": "Chest/CableCrossover",
    "Chest3/122_iso_lateral_chest_press": "Chest/IsoLateralChestPress",
    "Chest3/123_incline_chest_press_machine": "Chest/InclineChestPressMachine",
    "Chest3/124_decline_chest_press_machine": "Chest/DeclineChestPressMachine",
    "Chest3/125_plate_loaded_chest_press": "Chest/PlateLoadedChestPress",
    "Chest3/126_wide_grip_chest_press_machine": "Chest/WideGripChestPressMachine",
    "Chest3/128_single_arm_landmine_press": "Chest/SingleArmLandminePress",
    "Chest3/131_incline_push_up": "Chest/InclinePushUp",
    # Batch 133-160 (2026-09-25), from the HIKSEMI drive's "131-160" folder
    # (131 came with the chest batch; 132 and 136 were not exported).
    "131-160/133_diamond_push_up": "Chest/DiamondPushUp",
    "131-160/134_wide_grip_push_up": "Chest/WideGripPushUp",
    "131-160/135_archer_push_up": "Chest/ArcherPushUp",
    "131-160/137_medicine_ball_push_up": "Chest/MedicineBallPushUp",
    "131-160/138_pause_bench_press": "Chest/PauseBenchPress",
    "131-160/139_larsen_press": "Chest/LarsenPress",
    "131-160/140_reverse_grip_bench_press": "Chest/ReverseGripBenchPress",
    "131-160/141_rack_pull": "Back/RackPull",
    "131-160/142_block_pull": "Back/BlockPull",
    "131-160/143_sumo_deadlift": "Back/SumoDeadlift",
    "131-160/144_trap_bar_deadlift": "Back/TrapBarDeadlift",
    "131-160/145_snatch_grip_deadlift": "Back/SnatchGripDeadlift",
    "131-160/146_deficit_deadlift": "Back/DeficitDeadlift",
    "131-160/147_barbell_yates_row": "Back/BarbellYatesRow",
    "131-160/148_reverse_grip_barbell_row": "Back/ReverseGripBarbellRow",
    "131-160/149_wide_grip_barbell_row": "Back/WideGripBarbellRow",
    "131-160/150_seal_row": "Back/SealRow",
    "131-160/151_meadows_row": "Back/MeadowsRow",
    "131-160/152_landmine_row": "Back/LandmineRow",
    "131-160/153_single_arm_landmine_row": "Back/SingleArmLandmineRow",
    "131-160/154_dumbbell_bent_over_row": "Back/DumbbellBentOverRow",
    "131-160/155_renegade_row": "Back/RenegadeRow",
    "131-160/156_kettlebell_row": "Back/KettlebellRow",
    "131-160/157_gorilla_row": "Back/GorillaRow",
    "131-160/158_inverted_row": "Back/InvertedRow",
    "131-160/159_feet_elevated_inverted_row": "Back/FeetElevatedInvertedRow",
    "131-160/160_underhand_inverted_row": "Back/UnderhandInvertedRow",
    # Batch 161-190 (2026-09-25), from the HIKSEMI drive's "160-190" folder
    # (160 came with the previous batch). All back lifts.
    "160-190/161_wide_grip_pull_up": "Back/WideGripPullUp",
    "160-190/162_neutral_grip_pull_up": "Back/NeutralGripPullUp",
    "160-190/163_archer_pull_up": "Back/ArcherPullUp",
    "160-190/164_weighted_pull_up": "Back/WeightedPullUp",
    "160-190/165_assisted_pull_up": "Back/AssistedPullUp",
    "160-190/166_neutral_grip_chin_up": "Back/NeutralGripChinUp",
    "160-190/167_weighted_chin_up": "Back/WeightedChinUp",
    "160-190/168_machine_pull_up": "Back/MachinePullUp",
    "160-190/169_wide_grip_lat_pulldown": "Back/WideGripLatPulldown",
    "160-190/170_reverse_grip_lat_pulldown": "Back/ReverseGripLatPulldown",
    "160-190/171_neutral_grip_lat_pulldown": "Back/NeutralGripLatPulldown",
    "160-190/172_v_bar_lat_pulldown": "Back/VBarLatPulldown",
    "160-190/173_single_arm_lat_pulldown": "Back/SingleArmLatPulldown",
    "160-190/174_kneeling_lat_pulldown": "Back/KneelingLatPulldown",
    "160-190/175_rope_lat_pulldown": "Back/RopeLatPulldown",
    "160-190/176_machine_lat_pulldown": "Back/MachineLatPulldown",
    "160-190/177_iso_lateral_lat_pulldown": "Back/IsoLateralLatPulldown",
    "160-190/178_wide_grip_seated_cable_row": "Back/WideGripSeatedCableRow",
    "160-190/179_close_grip_seated_cable_row": "Back/CloseGripSeatedCableRow",
    "160-190/180_single_arm_cable_row": "Back/SingleArmCableRow",
    "160-190/181_standing_cable_row": "Back/StandingCableRow",
    "160-190/182_half_kneeling_cable_row": "Back/HalfKneelingCableRow",
    "160-190/183_high_cable_row": "Back/HighCableRow",
    "160-190/184_low_cable_row": "Back/LowCableRow",
    "160-190/185_machine_seated_row": "Back/MachineSeatedRow",
    "160-190/186_iso_lateral_row_machine": "Back/IsoLateralRowMachine",
    "160-190/187_single_arm_machine_row": "Back/SingleArmMachineRow",
    "160-190/188_reverse_grip_t_bar_row": "Back/ReverseGripTBarRow",
    "160-190/189_dumbbell_pullover_row": "Back/DumbbellPulloverRow",
    "160-190/190_machine_pullover": "Back/MachinePullover",
    # Batch 191-240 (2026-09-26), from the HIKSEMI drive's "190-240" folder
    # (207, 222, 224 and 237 were not exported). Shoulders, shrugs, carries
    # and biceps curls.
    "190-240/191_seated_barbell_overhead_press": "Shoulder/SeatedBarbellOverheadPress",
    "190-240/192_behind_the_neck_press": "Shoulder/BehindTheNeckPress",
    "190-240/193_push_press": "Shoulder/PushPress",
    "190-240/194_dumbbell_push_press": "Shoulder/DumbbellPushPress",
    "190-240/195_standing_dumbbell_press": "Shoulder/StandingDumbbellPress",
    "190-240/196_seated_dumbbell_press": "Shoulder/SeatedDumbbellPress",
    "190-240/197_neutral_grip_dumbbell_shoulder_press": "Shoulder/NeutralGripDumbbellShoulderPress",
    "190-240/198_single_arm_dumbbell_shoulder_press": "Shoulder/SingleArmDumbbellShoulderPress",
    "190-240/199_z_press": "Shoulder/ZPress",
    "190-240/200_landmine_shoulder_press": "Shoulder/LandmineShoulderPress",
    "190-240/201_kneeling_landmine_press": "Shoulder/KneelingLandminePress",
    "190-240/202_cable_shoulder_press": "Shoulder/CableShoulderPress",
    "190-240/203_single_arm_cable_shoulder_press": "Shoulder/SingleArmCableShoulderPress",
    "190-240/204_smith_machine_shoulder_press": "Shoulder/SmithMachineShoulderPress",
    "190-240/205_viking_press": "Shoulder/VikingPress",
    "190-240/206_dumbbell_leaning_lateral_raise": "Shoulder/LeaningLateralRaise",
    "190-240/208_incline_lateral_raise": "Shoulder/InclineLateralRaise",
    "190-240/209_chest_supported_lateral_raise": "Shoulder/ChestSupportedLateralRaise",
    "190-240/210_y_raise": "Shoulder/YRaise",
    "190-240/211_cable_y_raise": "Shoulder/CableYRaise",
    "190-240/212_lu_raise": "Shoulder/LuRaise",
    "190-240/213_plate_front_raise": "Shoulder/PlateFrontRaise",
    "190-240/214_barbell_front_raise": "Shoulder/BarbellFrontRaise",
    "190-240/215_cable_front_raise": "Shoulder/CableFrontRaise",
    "190-240/216_alternating_dumbbell_front_raise": "Shoulder/AlternatingDumbbellFrontRaise",
    "190-240/217_cable_external_rotation": "Shoulder/CableExternalRotation",
    "190-240/218_cable_internal_rotation": "Shoulder/CableInternalRotation",
    "190-240/219_powell_raise": "Shoulder/PowellRaise",
    "190-240/220_rear_delt_row": "Shoulder/RearDeltRow",
    "190-240/221_machine_rear_delt_row": "Shoulder/MachineRearDeltRow",
    "190-240/223_barbell_upright_row": "Shoulder/BarbellUprightRow",
    "190-240/225_cable_upright_row": "Shoulder/CableUprightRow",
    "190-240/226_smith_machine_upright_row": "Shoulder/SmithMachineUprightRow",
    "190-240/227_dumbbell_shrug": "Back/DumbbellShrug",
    "190-240/228_barbell_shrug": "Back/BarbellShrug",
    "190-240/229_smith_machine_shrug": "Back/SmithMachineShrug",
    "190-240/230_cable_shrug": "Back/CableShrug",
    "190-240/231_trap_bar_shrug": "Back/TrapBarShrug",
    "190-240/232_behind_the_back_barbell_shrug": "Back/BehindTheBackBarbellShrug",
    "190-240/233_farmer_s_carry": "Abs/FarmersCarry",
    "190-240/234_suitcase_carry": "Abs/SuitcaseCarry",
    "190-240/235_overhead_carry": "Abs/OverheadCarry",
    "190-240/236_alternating_dumbbell_curl": "Biceps/AlternatingDumbbellCurl",
    "190-240/238_spider_curl": "Biceps/SpiderCurl",
    "190-240/239_dumbbell_preacher_curl": "Biceps/DumbbellPreacherCurl",
    "190-240/240_machine_biceps_curl": "Biceps/MachineBicepsCurl",
    # Legs 300-350 (2026-09-26), from the HIKSEMI drive's "300-350" folder:
    # the quads series 316-325 plus the Curtsy Lunge from the 30-leg set.
    # 325 is built as a reverse lunge in the Smith machine.
    "300-350/01_curtsy_lunge": "Legs/CurtsyLunge",
    "300-350/316_barbell_split_squat": "Legs/BarbellSplitSquat",
    "300-350/317_dumbbell_split_squat": "Legs/DumbbellSplitSquat",
    "300-350/318_smith_machine_split_squat": "Legs/SmithMachineSplitSquat",
    "300-350/319_barbell_bulgarian_split_squat": "Legs/BarbellBulgarianSplitSquat",
    "300-350/320_smith_machine_bulgarian_split_squat": "Legs/SmithMachineBulgarianSplitSquat",
    "300-350/321_front_foot_elevated_split_squat": "Legs/FrontFootElevatedSplitSquat",
    "300-350/322_rear_foot_elevated_split_squat": "Legs/RearFootElevatedSplitSquat",
    "300-350/323_forward_lunge": "Legs/ForwardLunge",
    "300-350/324_barbell_lunge": "Legs/BarbellLunge",
    "300-350/325_smith_machine_lunge": "Legs/SmithMachineReverseLunge",
    # Late additions (2026-09-27): 207 and 222 as the user exported them, 224
    # re-exported after its top was lowered to 90° (see the drive's
    # _backup_truoc_sua_goc_20260926), and 077 from the fixed 03 leg folder.
    "190-240/207_seated_dumbbell_lateral_raise": "Shoulder/SeatedDumbbellLateralRaise",
    "190-240/222_cable_rear_delt_row": "Shoulder/CableRearDeltRow",
    "190-240/224_dumbbell_upright_row": "Shoulder/DumbbellUprightRow",
    "Legs2/077_barbell_hip_thrust": "Legs/BarbellHipThrust",
    # Batch 241-300 (2026-09-27), from the HIKSEMI drive's "241-300" folder (26
    # exports, 241-280; 245, 268 and 272 re-exported from their newer .blend):
    # biceps curls into Biceps/, wrist curls and grip holds into Forearms/.
    "241-300/241_single_arm_machine_curl": "Biceps/SingleArmMachineCurl",
    "241-300/242_cable_preacher_curl": "Biceps/CablePreacherCurl",
    "241-300/243_single_arm_cable_curl": "Biceps/SingleArmCableCurl",
    "241-300/244_high_cable_curl": "Biceps/HighCableCurl",
    "241-300/245_overhead_cable_curl": "Biceps/OverheadCableCurl",
    "241-300/247_cable_hammer_curl": "Biceps/CableHammerCurl",
    "241-300/250_preacher_hammer_curl": "Biceps/PreacherHammerCurl",
    "241-300/252_drag_curl": "Biceps/DragCurl",
    "241-300/253_ez_bar_drag_curl": "Biceps/EZBarDragCurl",
    "241-300/254_cable_drag_curl": "Biceps/CableDragCurl",
    "241-300/260_reverse_preacher_curl": "Biceps/ReversePreacherCurl",
    "241-300/263_barbell_preacher_curl": "Biceps/BarbellPreacherCurl",
    "241-300/265_dumbbell_spider_curl": "Biceps/DumbbellSpiderCurl",
    "241-300/266_ez_bar_spider_curl": "Biceps/EZBarSpiderCurl",
    "241-300/268_alternating_hammer_curl": "Biceps/AlternatingHammerCurl",
    "241-300/269_dumbbell_wrist_curl": "Forearms/DumbbellWristCurl",
    "241-300/270_barbell_reverse_wrist_curl": "Forearms/BarbellReverseWristCurl",
    "241-300/271_dumbbell_reverse_wrist_curl": "Forearms/DumbbellReverseWristCurl",
    "241-300/272_cable_wrist_curl": "Forearms/CableWristCurl",
    "241-300/273_cable_reverse_wrist_curl": "Forearms/CableReverseWristCurl",
    "241-300/274_behind_the_back_wrist_curl": "Forearms/BehindTheBackWristCurl",
    "241-300/276_finger_curl": "Forearms/FingerCurl",
    # 277-280 redone (2026-09-28) from the drive's "241-300/27:09" folder: the
    # user's static exports of the re-saved .blend files (no animation; the
    # pose is the skeleton's rest). hold_static.py makes them 8 s clips.
    "241-300/277_plate_pinch_hold": "Forearms/PlatePinchHold",
    "241-300/278_dumbbell_static_hold": "Forearms/DumbbellStaticHold",
    "241-300/279_barbell_static_hold": "Forearms/BarbellStaticHold",
    "241-300/280_towel_grip_hold": "Forearms/TowelGripHold",
    # Arnold Press redo (2026-09-28): the user's BLENDER/exercises_13_49/
    # BLENDER/02_Vai/30_arnold_press.blend with the palms re-keyed to pronate
    # (they turned the wrong way, twisting the forearms a half turn), exported
    # headless.
    "Shoulder/30_arnold_press": "Shoulder/ArnoldPress",
    # 30-leg set, 02-27 (2026-09-28), from the HIKSEMI drive's "300-350/27_9"
    # folder (24 exports; 16, 22 and 23 were not exported). Squats, lunges and
    # leg presses into Legs/.
    "300-350/02_lateral_lunge": "Legs/LateralLunge",
    "300-350/03_cossack_squat": "Legs/CossackSquat",
    "300-350/04_dumbbell_sumo_squat": "Legs/DumbbellSumoSquat",
    "300-350/05_barbell_sumo_squat": "Legs/BarbellSumoSquat",
    "300-350/06_kettlebell_goblet_squat": "Legs/KettlebellGobletSquat",
    "300-350/07_box_squat": "Legs/BoxSquat",
    "300-350/08_pause_squat": "Legs/PauseSquat",
    "300-350/09_safety_bar_squat": "Legs/SafetyBarSquat",
    "300-350/10_zercher_squat": "Legs/ZercherSquat",
    "300-350/11_overhead_squat": "Legs/OverheadSquat",
    "300-350/12_landmine_squat": "Legs/LandmineSquat",
    "300-350/13_belt_squat": "Legs/BeltSquat",
    "300-350/14_pendulum_squat": "Legs/PendulumSquat",
    "300-350/15_v_squat": "Legs/VSquat",
    "300-350/17_vertical_leg_press": "Legs/VerticalLegPress",
    "300-350/18_45_degree_leg_press": "Legs/LegPress45",
    "300-350/19_single_leg_press": "Legs/SingleLegPress",
    "300-350/20_narrow_stance_leg_press": "Legs/NarrowStanceLegPress",
    "300-350/21_wide_stance_leg_press": "Legs/WideStanceLegPress",
    "300-350/24_heel_elevated_squat": "Legs/HeelElevatedSquat",
    "300-350/25_cyclist_squat": "Legs/CyclistSquat",
    "300-350/26_pistol_squat": "Legs/PistolSquat",
    "300-350/27_assisted_pistol_squat": "Legs/AssistedPistolSquat",
    # Calves 083-087 (2026-09-28), from the HIKSEMI drive's "Calf 83-" folder.
    "Calf/083_standing_calf_raise": "Legs/StandingCalfRaise",
    "Calf/084_seated_calf_raise": "Legs/SeatedCalfRaise",
    "Calf/085_leg_press_calf_raise": "Legs/LegPressCalfRaise",
    "Calf/086_single_leg_calf_raise": "Legs/SingleLegCalfRaise",
    "Calf/087_smith_machine_calf_raise": "Legs/SmithMachineCalfRaise",
    # Exercises 1-50 redone (2026-09-29), from the HIKSEMI drive's "1-100 🟢"
    # folder (the 🟢 copy where a number has two). 26 replace the app's
    # models; 15, 42, 44-49 and 050 are new. 01 was re-exported headless with
    # its RIG collection's render toggle back on: the user's export had lost
    # the armature (120 one-joint skeletons, no motion).
    "1-50/01_barbell_bench_press": "Chest/BarbellBenchPress",
    "1-50/02_incline_barbell_bench_press": "Chest/InclineBarbellBenchPress",
    "1-50/03_decline_barbell_bench_press": "Chest/DeclineBarbellBenchPress",
    "1-50/04_dumbbell_bench_press": "Chest/DumbbellBenchPress",
    "1-50/05_incline_dumbbell_press": "Chest/InclineDumbbellPress",
    "1-50/06_dumbbell_fly": "Chest/DumbbellFly",
    "1-50/07_incline_dumbbell_fly": "Chest/InclineDumbbellFly",
    "1-50/08_chest_press_machine": "Chest/ChestPressMachine",
    "1-50/09_pec_deck_fly": "Chest/PecDeckFly",
    "1-50/10_cable_fly": "Chest/CableFly",
    "1-50/11_low_to_high_cable_fly": "Chest/LowToHighCableFly",
    "1-50/13_conventional_deadlift": "Back/ConventionalDeadlift",
    "1-50/14_barbell_bent_over_row": "Back/BarbellBentOverRow",
    "1-50/15_pendlay_row": "Back/PendlayRow",
    "1-50/16_one_arm_dumbbell_row": "Back/OneArmDumbbellRow",
    "1-50/17_chest_supported_dumbbell_row": "Back/ChestSupportedDumbbellRow",
    "1-50/23_straight_arm_pulldown": "Back/StraightArmPulldown",
    "1-50/24_t_bar_row": "Back/TBarRow",
    "1-50/25_chest_supported_row_machine": "Back/ChestSupportedRowMachine",
    "1-50/27_back_extension": "Back/BackExtension",
    "1-50/28_barbell_overhead_press": "Shoulder/BarbellOverheadPress",
    "1-50/29_dumbbell_shoulder_press": "Shoulder/DumbbellShoulderPress",
    "1-50/33_cable_lateral_raise": "Shoulder/CableLateralRaise",
    "1-50/35_dumbbell_front_raise": "Shoulder/DumbbellFrontRaise",
    "1-50/36_reverse_dumbbell_fly": "Shoulder/ReverseDumbbellFly",
    "1-50/37_reverse_pec_deck": "Shoulder/ReversePecDeck",
    "1-50/39_cable_rear_delt_fly": "Shoulder/CableRearDeltFly",
    "1-50/42_dumbbell_curl": "Biceps/DumbbellCurl",
    "1-50/44_incline_dumbbell_curl": "Biceps/InclineDumbbellCurl",
    "1-50/45_preacher_curl": "Biceps/PreacherCurl",
    "1-50/46_cable_curl": "Biceps/CableCurl",
    "1-50/47_bayesian_cable_curl": "Biceps/BayesianCableCurl",
    "1-50/48_reverse_curl": "Biceps/ReverseCurl",
    "1-50/49_wrist_curl": "Forearms/WristCurl",
    "1-50/050_close_grip_bench_press": "Triceps/CloseGripBenchPress",
    # Exercises 51-150 redone (2026-09-30), from the same "1-100 🟢" folder (the
    # 🟢 copy of 062 and 091; Step-Up and Single-Leg Glute Bridge are 069 and
    # 079). All 49 replace existing models; 51-60, 66-70, 74, 77, 79 (the
    # numbered bridge), 81, 83-85, 88, 89, 93, 95-110, 113-116, 127, 129, 130,
    # 132, 136, 138, 141, 142 were not redone.
    "51-150/061_goblet_squat": "Legs/GobletSquat",
    "51-150/062_bulgarian_split_squat": "Legs/BulgarianSplitSquatUpright",
    "51-150/063_walking_lunge": "Legs/WalkingLunge",
    "51-150/064_reverse_lunge": "Legs/ReverseLunge",
    "51-150/065_leg_press": "Legs/LegPress",
    "51-150/071_romanian_deadlift": "Legs/RomanianDeadlift",
    "51-150/072_dumbbell_romanian_deadlift": "Legs/DumbbellRomanianDeadlift",
    "51-150/073_stiff_leg_deadlift": "Legs/StiffLegDeadlift",
    "51-150/075_seated_leg_curl": "Legs/SeatedLegCurl",
    "51-150/076_single_leg_curl": "Legs/SingleLegCurl",
    "51-150/078_glute_bridge": "Legs/GluteBridge",
    "51-150/080b_cable_side_kick": "Legs/CableSideKick",
    "51-150/082_cable_hip_abduction": "Legs/CableHipAbduction",
    "51-150/086_single_leg_calf_raise": "Legs/SingleLegCalfRaise",
    "51-150/087_smith_machine_calf_raise": "Legs/SmithMachineCalfRaise",
    "51-150/090_decline_crunch": "Abs/DeclineCrunch",
    "51-150/091_hanging_knee_raise": "Abs/HangingKneeRaise",
    "51-150/092_hanging_leg_raise": "Abs/HangingLegRaise",
    "51-150/094_reverse_crunch": "Abs/ReverseCrunch",
    "51-150/111_dumbbell_pullover": "Chest/DumbbellPullover",
    "51-150/112_barbell_pullover": "Chest/BarbellPullover",
    "51-150/117_high_to_low_cable_fly": "Chest/HighToLowCableFly",
    "51-150/118_single_arm_cable_fly": "Chest/SingleArmCableFly",
    "51-150/119_incline_cable_fly": "Chest/InclineCableFly",
    "51-150/120_decline_cable_fly": "Chest/DeclineCableFly",
    "51-150/121_cable_crossover": "Chest/CableCrossover",
    "51-150/122_iso_lateral_chest_press": "Chest/IsoLateralChestPress",
    "51-150/123_incline_chest_press_machine": "Chest/InclineChestPressMachine",
    "51-150/124_decline_chest_press_machine": "Chest/DeclineChestPressMachine",
    "51-150/125_plate_loaded_chest_press": "Chest/PlateLoadedChestPress",
    "51-150/126_wide_grip_chest_press_machine": "Chest/WideGripChestPressMachine",
    "51-150/128_single_arm_landmine_press": "Chest/SingleArmLandminePress",
    "51-150/131_incline_push_up": "Chest/InclinePushUp",
    "51-150/133_diamond_push_up": "Chest/DiamondPushUp",
    "51-150/134_wide_grip_push_up": "Chest/WideGripPushUp",
    "51-150/135_archer_push_up": "Chest/ArcherPushUp",
    "51-150/137_medicine_ball_push_up": "Chest/MedicineBallPushUp",
    "51-150/139_larsen_press": "Chest/LarsenPress",
    "51-150/140_reverse_grip_bench_press": "Chest/ReverseGripBenchPress",
    "51-150/143_sumo_deadlift": "Back/SumoDeadlift",
    "51-150/144_trap_bar_deadlift": "Back/TrapBarDeadlift",
    "51-150/145_snatch_grip_deadlift": "Back/SnatchGripDeadlift",
    "51-150/146_deficit_deadlift": "Back/DeficitDeadlift",
    "51-150/147_barbell_yates_row": "Back/BarbellYatesRow",
    "51-150/148_reverse_grip_barbell_row": "Back/ReverseGripBarbellRow",
    "51-150/149_wide_grip_barbell_row": "Back/WideGripBarbellRow",
    "51-150/150_seal_row": "Back/SealRow",
    "51-150/Single-Leg_Glute_Bridge": "Legs/SingleLegGluteBridge",
    "51-150/Step-Up": "Legs/StepUp",
    # Exercises 151-190 and the gated models redone (2026-09-30), from the same
    # "1-100 🟢" folder (the 🟢 copy of Lunge_Lean). All 37 replace existing
    # models; 153, 158-160, 166, 175 were not redone.
    "151-190/151_meadows_row": "Back/MeadowsRow",
    "151-190/152_landmine_row": "Back/LandmineRow",
    "151-190/154_dumbbell_bent_over_row": "Back/DumbbellBentOverRow",
    "151-190/155_renegade_row": "Back/RenegadeRow",
    "151-190/156_kettlebell_row": "Back/KettlebellRow",
    "151-190/157_gorilla_row": "Back/GorillaRow",
    "151-190/161_wide_grip_pull_up": "Back/WideGripPullUp",
    "151-190/162_neutral_grip_pull_up": "Back/NeutralGripPullUp",
    "151-190/163_archer_pull_up": "Back/ArcherPullUp",
    "151-190/164_weighted_pull_up": "Back/WeightedPullUp",
    "151-190/165_assisted_pull_up": "Back/AssistedPullUp",
    "151-190/167_weighted_chin_up": "Back/WeightedChinUp",
    "151-190/168_machine_pull_up": "Back/MachinePullUp",
    "151-190/169_wide_grip_lat_pulldown": "Back/WideGripLatPulldown",
    "151-190/170_reverse_grip_lat_pulldown": "Back/ReverseGripLatPulldown",
    "151-190/171_neutral_grip_lat_pulldown": "Back/NeutralGripLatPulldown",
    "151-190/172_v_bar_lat_pulldown": "Back/VBarLatPulldown",
    "151-190/173_single_arm_lat_pulldown": "Back/SingleArmLatPulldown",
    "151-190/174_kneeling_lat_pulldown": "Back/KneelingLatPulldown",
    "151-190/176_machine_lat_pulldown": "Back/MachineLatPulldown",
    "151-190/177_iso_lateral_lat_pulldown": "Back/IsoLateralLatPulldown",
    "151-190/178_wide_grip_seated_cable_row": "Back/WideGripSeatedCableRow",
    "151-190/179_close_grip_seated_cable_row": "Back/CloseGripSeatedCableRow",
    "151-190/180_single_arm_cable_row": "Back/SingleArmCableRow",
    "151-190/181_standing_cable_row": "Back/StandingCableRow",
    "151-190/182_half_kneeling_cable_row": "Back/HalfKneelingCableRow",
    "151-190/183_high_cable_row": "Back/HighCableRow",
    "151-190/184_low_cable_row": "Back/LowCableRow",
    "151-190/185_machine_seated_row": "Back/MachineSeatedRow",
    "151-190/186_iso_lateral_row_machine": "Back/IsoLateralRowMachine",
    "151-190/187_single_arm_machine_row": "Back/SingleArmMachineRow",
    "151-190/188_reverse_grip_t_bar_row": "Back/ReverseGripTBarRow",
    "151-190/189_dumbbell_pullover_row": "Back/DumbbellPulloverRow",
    "151-190/190_machine_pullover": "Back/MachinePullover",
    "151-190/Biceps_Curl": "Biceps/BicepsCurl",
    "151-190/Lunge": "Legs/Lunge",
    "151-190/Lunge_Lean": "Legs/LungeLean",
    # The drive's "190-280 🟢" folder (2026-09-30): the user's redone exports of
    # 21 shoulder, carry, curl and grip models already in the app, plus 264
    # Machine Preacher Curl, new. The grip holds 277-280 come animated this time.
    "190-280/191_seated_barbell_overhead_press": "Shoulder/SeatedBarbellOverheadPress",
    "190-280/195_standing_dumbbell_press": "Shoulder/StandingDumbbellPress",
    "190-280/197_neutral_grip_dumbbell_shoulder_press": "Shoulder/NeutralGripDumbbellShoulderPress",
    "190-280/198_single_arm_dumbbell_shoulder_press": "Shoulder/SingleArmDumbbellShoulderPress",
    "190-280/200_landmine_shoulder_press": "Shoulder/LandmineShoulderPress",
    "190-280/201_kneeling_landmine_press": "Shoulder/KneelingLandminePress",
    "190-280/208_incline_lateral_raise": "Shoulder/InclineLateralRaise",
    "190-280/211_cable_y_raise": "Shoulder/CableYRaise",
    "190-280/220_rear_delt_row": "Shoulder/RearDeltRow",
    "190-280/221_machine_rear_delt_row": "Shoulder/MachineRearDeltRow",
    "190-280/225_cable_upright_row": "Shoulder/CableUprightRow",
    "190-280/234_suitcase_carry": "Abs/SuitcaseCarry",
    "190-280/236_alternating_dumbbell_curl": "Biceps/AlternatingDumbbellCurl",
    "190-280/241_single_arm_machine_curl": "Biceps/SingleArmMachineCurl",
    "190-280/250_preacher_hammer_curl": "Biceps/PreacherHammerCurl",
    "190-280/264_machine_preacher_curl": "Biceps/MachinePreacherCurl",
    "190-280/265_dumbbell_spider_curl": "Biceps/DumbbellSpiderCurl",
    "190-280/266_ez_bar_spider_curl": "Biceps/EZBarSpiderCurl",
    "190-280/277_plate_pinch_hold": "Forearms/PlatePinchHold",
    "190-280/278_dumbbell_static_hold": "Forearms/DumbbellStaticHold",
    "190-280/279_barbell_static_hold": "Forearms/BarbellStaticHold",
    "190-280/280_towel_grip_hold": "Forearms/TowelGripHold",
    # The drive's "351-400" folder (2026-09-30): 27 new hamstring, glute and hip
    # exercises (the 🟢-approved ones of the builder's 356-400 set; 372, 376-380,
    # 383-392, 394 and 399 were not exported).
    "351-400/356_single_leg_romanian_deadlift": "Legs/SingleLegRomanianDeadlift",
    "351-400/357_barbell_single_leg_romanian_deadlift": "Legs/BarbellSingleLegRomanianDeadlift",
    "351-400/358_dumbbell_single_leg_romanian_deadlift": "Legs/DumbbellSingleLegRomanianDeadlift",
    "351-400/359_b_stance_romanian_deadlift": "Legs/BStanceRomanianDeadlift",
    "351-400/360_smith_machine_romanian_deadlift": "Legs/SmithMachineRomanianDeadlift",
    "351-400/361_cable_romanian_deadlift": "Legs/CableRomanianDeadlift",
    "351-400/362_kettlebell_romanian_deadlift": "Legs/KettlebellRomanianDeadlift",
    "351-400/363_good_morning": "Legs/GoodMorning",
    "351-400/364_seated_good_morning": "Legs/SeatedGoodMorning",
    "351-400/365_smith_machine_good_morning": "Legs/SmithMachineGoodMorning",
    "351-400/366_nordic_hamstring_curl": "Legs/NordicHamstringCurl",
    "351-400/367_assisted_nordic_curl": "Legs/AssistedNordicCurl",
    "351-400/368_glute_ham_raise": "Legs/GluteHamRaise",
    "351-400/369_standing_leg_curl_machine": "Legs/StandingLegCurl",
    "351-400/370_kneeling_leg_curl": "Legs/KneelingLegCurl",
    "351-400/371_cable_standing_leg_curl": "Legs/CableStandingLegCurl",
    "351-400/373_swiss_ball_leg_curl": "Legs/SwissBallLegCurl",
    "351-400/374_sliding_leg_curl": "Legs/SlidingLegCurl",
    "351-400/375_single_leg_sliding_curl": "Legs/SingleLegSlidingCurl",
    "351-400/381_frog_pump": "Legs/FrogPump",
    "351-400/382_weighted_frog_pump": "Legs/WeightedFrogPump",
    "351-400/393_dumbbell_deadlift": "Legs/DumbbellDeadlift",
    "351-400/395_hip_adduction_cable": "Legs/CableHipAdduction",
    "351-400/396_standing_hip_abduction": "Legs/StandingHipAbduction",
    "351-400/397_side_lying_hip_abduction": "Legs/SideLyingHipAbduction",
    "351-400/398_banded_hip_abduction": "Legs/BandedHipAbduction",
    "351-400/400_clamshell": "Legs/Clamshell",
}

# Parts a job switches off by hand. 225 Cable Upright Row (2026-09-30) runs
# one centre cable; its unused left cable is shrunk to nothing (see
# `collapsed` below) except these three pieces, which drew a stray line
# between the feet.
OFF = {
    "190-280/225_cable_upright_row": ["GYM_Cable_Root/GYM_Cable_L_CableToHandle",
                                      "GYM_Cable_Root/GYM_Cable_L_PullOffset",
                                      "GYM_Cable_Root/GYM_Cable_L_CableToStack"],
}

ONLY = sys.argv[1:]
for raw, name in JOBS.items():
    if ONLY and not any(o in raw for o in ONLY): continue
    src = os.path.join(SRC, raw + ".usdc")
    rawStage = Usd.Stage.Open(src)
    start, end = rawStage.GetStartTimeCode(), rawStage.GetEndTimeCode()
    # Static exports (no animation) have no frame range: start == end == 0.
    assert start == 1 or start == end, (raw, start)

    lights = [p.GetPath() for p in rawStage.Traverse() if p.HasAPI(UsdLux.LightAPI)]
    # Cameras too (2026-09-29): the redone 04 Dumbbell Bench Press carried two,
    # and RealityKit sometimes rendered through them instead of the viewport's.
    cameras = [p.GetPath() for p in rawStage.Traverse() if p.IsA(UsdGeom.Camera)]
    # Parts collapsed to a zero scale (2026-09-30: the redone 225 Cable Upright
    # Row runs one centre cable and shrinks the unused left one to nothing)
    # draw nothing but break the bounds (a singular matrix gives ±1e38), which
    # parked the whole cable station. They are switched off, and the parking
    # test only reads the meshes outside them.
    def zero_scaled(p):
        a = p.GetAttribute("xformOp:scale")
        if not a or not a.HasAuthoredValue():
            return False
        vals = [a.Get(t) for t in a.GetTimeSamples()] or [a.Get()]
        return all(v is not None and min(abs(x) for x in v) < 1e-9 for v in vals)
    collapsed = [p.GetPath() for p in rawStage.Traverse() if zero_scaled(p)]
    cache = UsdGeom.BBoxCache(Usd.TimeCode(1), [UsdGeom.Tokens.default_, UsdGeom.Tokens.render])
    parked = []
    for c in rawStage.GetPrimAtPath("/root").GetChildren():
        if c.GetName() in ("Anatomy_MasterRig", "DARK_Floor") or not c.IsA(UsdGeom.Imageable):
            continue
        meshes = [p for p in Usd.PrimRange(c) if p.GetTypeName() == "Mesh"
                  and not any(p.GetPath().HasPrefix(z) for z in collapsed)]
        if not meshes:
            continue
        box = Gf.Range3d()
        for p in meshes:
            box.UnionWith(cache.ComputeWorldBound(p).ComputeAlignedRange())
        mid = box.GetMidpoint()
        if abs(mid[0]) > 5 or abs(mid[1]) > 5:
            parked.append(c.GetPath())

    stage = Usd.Stage.Open(Sdf.Layer.CreateAnonymous(".usda"))
    UsdGeom.SetStageUpAxis(stage, UsdGeom.Tokens.y)
    UsdGeom.SetStageMetersPerUnit(stage, 1)
    stage.SetStartTimeCode(start); stage.SetEndTimeCode(end)
    stage.SetTimeCodesPerSecond(rawStage.GetTimeCodesPerSecond())
    root = UsdGeom.Xform.Define(stage, "/root")
    stage.SetDefaultPrim(root.GetPrim())
    root.GetPrim().GetReferences().AddReference(src, "/root")
    root.AddRotateXOp().Set(-90)
    off = [Sdf.Path("/root/" + p) for p in OFF.get(raw, [])]
    assert all(rawStage.GetPrimAtPath(p) for p in off), (raw, off)
    for path in lights + cameras + parked + collapsed + off:
        stage.OverridePrim(path).SetActive(False)

    def radius_for(prim):
        n = prim.GetPath().pathString
        if "Rope" in n: return 0.011          # braided face-pull rope
        if "LoopHandle" in n: return 0.012    # chrome loop grip
        return 0.004                          # steel cable, as the scene's cable meshes (8mm)
    for line in replace_curves(stage, radius_for):
        print("      ", line)

    out = os.path.join(OUT, name + ".usdc")
    stage.Flatten().Export(out)
    print(f"{name:34s} lights off: {len(lights)}  cameras off: {len(cameras)}  parked off: {[p.name for p in parked]}"
          + (f"  collapsed off: {len(collapsed)}" if collapsed else "") + (f"  by hand off: {len(off)}" if off else ""))
