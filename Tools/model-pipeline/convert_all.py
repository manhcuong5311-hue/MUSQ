# Wraps raw Blender exports (Z-up, lights, props parked off-stage) into Y-up,
# light-free stages and flattens each to one usdc.
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from curves2mesh import replace_curves
from pxr import Usd, UsdGeom, UsdLux, Sdf

SRC = "/Users/sammanhcuong/Desktop/GymWorkout/SourceExports"
OUT = "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models"
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
    "241-300/277_plate_pinch_hold": "Forearms/PlatePinchHold",
    "241-300/278_dumbbell_static_hold": "Forearms/DumbbellStaticHold",
    "241-300/279_barbell_static_hold": "Forearms/BarbellStaticHold",
    "241-300/280_towel_grip_hold": "Forearms/TowelGripHold",
}

ONLY = sys.argv[1:]
for raw, name in JOBS.items():
    if ONLY and not any(o in raw for o in ONLY): continue
    src = os.path.join(SRC, raw + ".usdc")
    rawStage = Usd.Stage.Open(src)
    start, end = rawStage.GetStartTimeCode(), rawStage.GetEndTimeCode()
    assert start == 1, (raw, start)

    lights = [p.GetPath() for p in rawStage.Traverse() if p.HasAPI(UsdLux.LightAPI)]
    cache = UsdGeom.BBoxCache(Usd.TimeCode(1), [UsdGeom.Tokens.default_, UsdGeom.Tokens.render])
    parked = []
    for c in rawStage.GetPrimAtPath("/root").GetChildren():
        if c.GetName() in ("Anatomy_MasterRig", "DARK_Floor") or not c.IsA(UsdGeom.Imageable):
            continue
        if not any(p.GetTypeName() == "Mesh" for p in Usd.PrimRange(c)):
            continue
        mid = cache.ComputeWorldBound(c).ComputeAlignedRange().GetMidpoint()
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
    for path in lights + parked:
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
    print(f"{name:34s} lights off: {len(lights)}  parked off: {[p.name for p in parked]}")
