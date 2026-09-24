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
