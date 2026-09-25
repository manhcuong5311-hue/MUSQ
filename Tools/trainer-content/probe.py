# Projects rig joints through each exercise's framing with the app's camera
# (vertical FOV 32deg at z=2.05, viewport aspect 382/705) — unit coords.
import sys, math, json
sys.path.insert(0, "/Users/sammanhcuong/Desktop/GymWorkout/Tools/model-pipeline")
from framer import LONGEST, CENTER, D, TAN
from pxr import Usd, UsdSkel, UsdGeom
import numpy as np
ASPECT = 382 / 655   # trainer viewport since the setup drawer (was 382/705)
M = "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/"
PI = math.pi
JOBS = {
 "Barbell Overhead Press": ("Shoulder/BarbellOverheadPress", -0.5, 0.654, (-0.009,-0.083,0.005)),
 "Dumbbell Shoulder Press": ("Shoulder/DumbbellShoulderPress", -0.5, 0.838, (-0.016,0.016,0.009)),
 "Arnold Press": ("Shoulder/ArnoldPress", -0.5, 0.839, (-0.005,0.016,0.003)),
 "Machine Shoulder Press": ("Shoulder/MachineShoulderPress", -0.6, 0.894, (0.002,0.033,-0.001)),
 "Dumbbell Lateral Raise": ("Shoulder/DumbbellLateralRaise", -0.25, 0.736, (-0.01,0.028,0.003)),
 "Cable Lateral Raise": ("Shoulder/CableLateralRaise", -0.25, 0.842, (-0.019,-0.023,0.005)),
 "Machine Lateral Raise": ("Shoulder/MachineLateralRaise", -0.25, 0.931, (0.008,0.045,-0.002)),
 "Dumbbell Front Raise": ("Shoulder/DumbbellFrontRaise", -0.55, 0.882, (0.073,0.026,-0.045)),
 "Reverse Dumbbell Fly": ("Shoulder/ReverseDumbbellFly", -2.3, 0.987, (-0.115,0.228,-0.129)),
 "Reverse Pec Deck": ("Shoulder/ReversePecDeck", 0.4, 0.846, (0.032,0.112,0.013)),
 "Face Pull": ("Shoulder/FacePull", -2.7, 0.874, (-0.061,0.019,-0.029)),
 "Cable Rear Delt Fly": ("Shoulder/CableRearDeltFly", -2.8, 0.689, (-0.104,-0.005,-0.037)),
 "Barbell Curl": ("Biceps/BarbellCurl", -0.4, 0.615, (0.004,0.019,-0.002)),
 "Triceps Pushdown": ("Triceps/CableTricepsPushdown", -0.6, 0.884, (0.031,0.028,-0.021)),
 "Rope Pushdown": ("Triceps/RopePushdown", -0.6, 0.883, (0.039,0.027,-0.026)),
 "Single-Arm Cable Pushdown": ("Triceps/SingleArmCablePushdown", -0.6, 0.88, (0.016,0.025,-0.011)),
 "Overhead Cable Triceps Extension": ("Triceps/OverheadCableTricepsExtension", -0.6, 0.802, (-0.027,-0.05,0.018)),
 "Dumbbell Overhead Triceps Extension": ("Triceps/DumbbellOverheadTricepsExtension", -0.6, 0.766, (-0.016,-0.039,0.011)),
 "Skull Crusher": ("Triceps/SkullCrusher", -1.0, 0.781, (-0.046,0.124,0.072)),
 "Bench Dip": ("Triceps/BenchDip", -1.0, 0.893, (0.009,0.135,-0.014)),
 "Assisted Dip": ("Triceps/AssistedDip", -0.6, 0.658, (-0.005,-0.042,0.004)),
 "Squat": ("Legs/Squat", 0, 1.0, (0,0.10,0)),
 "Lunge": ("Legs/Lunge", 0, 1.0, (0,0.10,0)),
 "Bulgarian Split Squat": ("Legs/BulgarianSplitSquatUpright", 0, 1.0, (0,0.10,0)),
 "Bulgarian Split Squat (Lean)": ("Legs/BulgarianSplitSquatLean", 0, 1.0, (0,0.10,0)),
 "Step-Up": ("Legs/StepUp", 0, 1.0, (0,0.10,0)),
 "Single-Leg Glute Bridge": ("Legs/SingleLegGluteBridge", PI/2, 0.62, (0,0.52,0)),
 "Push-Up": ("Chest/pushup", PI/2, 0.62, (0,0.30,0)),
 "Plank": ("Abs/Plank", PI/2, 0.62, (0,0.52,0)),
 # The three gated exercises re-exported, plus the lean lunge (2026-09-24).
 # "Squat" and "Lunge" above were the legacy models; these replace them.
 "Biceps Curl": ("Biceps/BicepsCurl", -0.4, 0.885, (0.023,0.026,-0.010)),
 "Squat": ("Legs/Squat", -0.5, 0.883, (0.070,0.026,-0.038)),
 "Lunge": ("Legs/Lunge", -1.3, 0.824, (0.051,0.054,-0.183)),
 "Lunge (Lean)": ("Legs/LungeLean", -1.3, 0.823, (0.051,0.074,-0.183)),
 # Back Squat after its barbell was grafted back on (graft_bar.py): framed
 # three-quarter so the 2.2 m bar stops cropping and depth reads.
 "Back Squat": ("Legs/BackSquat", -1.0, 0.828, (-0.021,0.019,0.033)),
 # Chest batch 101-131 (2026-09-25), solved at 382x655 (solve_all.py with ASPECT).
 "Dumbbell Floor Press": ("Chest/DumbbellFloorPress", -1.0, 0.722, (-0.009,0.207,0.014)),
 "Barbell Floor Press": ("Chest/BarbellFloorPress", -1.0, 0.582, (-0.038,0.14,0.059)),
 "Smith Machine Bench Press": ("Chest/SmithMachineBenchPress", -1.0, 0.537, (-0.054,-0.03,0.084)),
 "Smith Machine Incline Press": ("Chest/SmithMachineInclinePress", -1.0, 0.671, (-0.035,0.025,0.054)),
 "Smith Machine Decline Press": ("Chest/SmithMachineDeclinePress", -1.0, 0.51, (-0.04,-0.029,0.063)),
 "Single-Arm Dumbbell Bench Press": ("Chest/SingleArmDumbbellBenchPress", -1.0, 0.732, (-0.034,0.124,0.053)),
 "Alternating Dumbbell Bench Press": ("Chest/AlternatingDumbbellBenchPress", -1.0, 0.76, (-0.018,0.122,0.028)),
 "Neutral-Grip Dumbbell Press": ("Chest/NeutralGripDumbbellPress", -1.0, 0.76, (-0.018,0.124,0.028)),
 "Dumbbell Squeeze Press": ("Chest/DumbbellSqueezePress", -1.0, 0.76, (-0.018,0.129,0.028)),
 "Incline Dumbbell Squeeze Press": ("Chest/InclineDumbbellSqueezePress", -1.0, 0.761, (-0.029,0.08,0.045)),
 "Dumbbell Pullover": ("Chest/DumbbellPullover", -1.3, 0.625, (-0.027,0.113,0.096)),
 "Barbell Pullover": ("Chest/BarbellPullover", -1.3, 0.504, (-0.037,0.054,0.132)),
 "Cable Chest Press": ("Chest/CableChestPress", -0.7, 0.896, (0.05,0.036,-0.042)),
 "Single-Arm Cable Chest Press": ("Chest/SingleArmCableChestPress", -0.7, 0.896, (-0.017,0.036,0.015)),
 "Incline Cable Press": ("Chest/InclineCablePress", -1.0, 0.81, (-0.009,0.102,0.013)),
 "Decline Cable Press": ("Chest/DeclineCablePress", -1.0, 0.692, (0.003,0.154,-0.004)),
 "High-to-Low Cable Fly": ("Chest/HighToLowCableFly", 0, 0.629, (0.0,0.025,0.0)),
 "Single-Arm Cable Fly": ("Chest/SingleArmCableFly", 0, 0.698, (-0.158,-0.01,0.0)),
 "Incline Cable Fly": ("Chest/InclineCableFly", -1.0, 0.722, (-0.025,0.09,0.039)),
 "Decline Cable Fly": ("Chest/DeclineCableFly", -1.0, 0.516, (-0.047,-0.027,0.074)),
 "Cable Crossover": ("Chest/CableCrossover", 0, 0.629, (0.0,0.025,0.0)),
 "Iso-Lateral Chest Press": ("Chest/IsoLateralChestPress", -0.7, 0.82, (-0.002,-0.003,0.002)),
 "Incline Chest Press Machine": ("Chest/InclineChestPressMachine", -0.7, 0.952, (-0.002,0.082,0.002)),
 "Decline Chest Press Machine": ("Chest/DeclineChestPressMachine", -0.7, 0.91, (0.062,0.106,-0.052)),
 "Plate-Loaded Chest Press": ("Chest/PlateLoadedChestPress", -0.7, 0.95, (0.041,0.107,-0.035)),
 "Wide-Grip Chest Press Machine": ("Chest/WideGripChestPressMachine", -0.7, 0.885, (0.037,0.105,-0.031)),
 "Single-Arm Landmine Press": ("Chest/SingleArmLandminePress", -0.6, 0.543, (0.145,0.042,-0.099)),
 "Incline Push-Up": ("Chest/InclinePushUp", -1.35, 0.595, (0.007,0.094,-0.032)),
 # Batch 133-160 (2026-09-25), solved at 382x655 (solve_all.py with ASPECT).
 "Diamond Push-Up": ("Chest/DiamondPushUp", -1.2, 0.557, (-0.001,0.185,0.003)),
 "Wide-Grip Push-Up": ("Chest/WideGripPushUp", -0.8, 0.659, (0.005,0.231,-0.005)),
 "Archer Push-Up": ("Chest/ArcherPushUp", -0.8, 0.642, (0.019,0.225,-0.019)),
 "Medicine Ball Push-Up": ("Chest/MedicineBallPushUp", -1.2, 0.564, (-0.003,0.143,0.007)),
 "Pause Bench Press": ("Chest/PauseBenchPress", -1.0, 0.607, (-0.046,0.069,0.072)),
 "Larsen Press": ("Chest/LarsenPress", -1.0, 0.502, (-0.011,0.058,0.017)),
 "Reverse-Grip Bench Press": ("Chest/ReverseGripBenchPress", -1.0, 0.607, (-0.046,0.069,0.072)),
 "Rack Pull": ("Back/RackPull", -2.5, 0.586, (-0.015,0.028,-0.011)),
 "Block Pull": ("Back/BlockPull", -2.0, 0.856, (-0.027,0.057,-0.059)),
 "Sumo Deadlift": ("Back/SumoDeadlift", -2.0, 0.877, (-0.018,0.045,-0.039)),
 "Trap Bar Deadlift": ("Back/TrapBarDeadlift", -2.0, 0.868, (0.029,0.032,0.062)),
 "Snatch-Grip Deadlift": ("Back/SnatchGripDeadlift", -2.0, 0.843, (-0.009,0.034,-0.02)),
 "Deficit Deadlift": ("Back/DeficitDeadlift", -2.0, 0.812, (-0.008,0.006,-0.018)),
 "Barbell Yates Row": ("Back/BarbellYatesRow", -2.0, 0.995, (-0.032,0.113,-0.07)),
 "Reverse-Grip Barbell Row": ("Back/ReverseGripBarbellRow", -2.0, 0.908, (-0.042,0.153,-0.092)),
 "Wide-Grip Barbell Row": ("Back/WideGripBarbellRow", -2.0, 0.867, (-0.046,0.165,-0.1)),
 "Seal Row": ("Back/SealRow", -1.4, 0.55, (-0.009,0.091,0.055)),
 "Meadows Row": ("Back/MeadowsRow", 2.71, 1.035, (0.165,0.231,-0.076)),
 "Landmine Row": ("Back/LandmineRow", -2.0, 1.098, (-0.025,0.177,-0.056)),
 "Single-Arm Landmine Row": ("Back/SingleArmLandmineRow", -2.0, 0.993, (-0.03,0.157,-0.066)),
 "Dumbbell Bent-Over Row": ("Back/DumbbellBentOverRow", -2.0, 1.11, (-0.023,0.174,-0.05)),
 "Renegade Row": ("Back/RenegadeRow", -1.3, 0.566, (-0.009,0.148,0.032)),
 "Kettlebell Row": ("Back/KettlebellRow", -2.0, 1.099, (-0.02,0.166,-0.044)),
 "Gorilla Row": ("Back/GorillaRow", -2.0, 1.089, (-0.025,0.271,-0.054)),
 "Inverted Row": ("Back/InvertedRow", -1.35, 0.582, (0.01,0.131,-0.043)),
 "Feet-Elevated Inverted Row": ("Back/FeetElevatedInvertedRow", -1.35, 0.558, (0.009,0.096,-0.038)),
 "Underhand Inverted Row": ("Back/UnderhandInvertedRow", -1.35, 0.578, (0.009,0.131,-0.041)),
 # Batch 161-190 (2026-09-25), solved at 382x655 (solve_all.py with ASPECT).
 "Wide-Grip Pull-Up": ("Back/WideGripPullUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Neutral-Grip Pull-Up": ("Back/NeutralGripPullUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Archer Pull-Up": ("Back/ArcherPullUp", -2.6, 0.516, (0.005,-0.078,0.003)),
 "Weighted Pull-Up": ("Back/WeightedPullUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Assisted Pull-Up": ("Back/AssistedPullUp", -2.6, 0.58, (0.009,-0.073,0.005)),
 "Neutral-Grip Chin-Up": ("Back/NeutralGripChinUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Weighted Chin-Up": ("Back/WeightedChinUp", -2.6, 0.58, (0.009,-0.083,0.005)),
 "Machine Pull-Up": ("Back/MachinePullUp", -2.6, 0.58, (0.009,-0.077,0.005)),
 "Wide-Grip Lat Pulldown": ("Back/WideGripLatPulldown", -2.6, 0.916, (0.017,0.066,0.01)),
 "Reverse-Grip Lat Pulldown": ("Back/ReverseGripLatPulldown", -2.6, 0.909, (0.015,0.062,0.009)),
 "Neutral-Grip Lat Pulldown": ("Back/NeutralGripLatPulldown", -2.6, 0.901, (0.019,0.057,0.011)),
 "V-Bar Lat Pulldown": ("Back/VBarLatPulldown", -2.6, 0.91, (0.012,0.062,0.007)),
 "Single-Arm Lat Pulldown": ("Back/SingleArmLatPulldown", -2.6, 0.899, (0.022,0.056,0.013)),
 "Kneeling Lat Pulldown": ("Back/KneelingLatPulldown", -2.6, 0.894, (0.025,0.053,0.015)),
 "Rope Lat Pulldown": ("Back/RopeLatPulldown", -2.6, 0.801, (0.011,-0.002,0.006)),
 "Machine Lat Pulldown": ("Back/MachineLatPulldown", -2.6, 0.881, (0.006,0.045,0.004)),
 "Iso-Lateral Lat Pulldown": ("Back/IsoLateralLatPulldown", -2.6, 0.886, (0.004,0.048,0.002)),
 "Wide-Grip Seated Cable Row": ("Back/WideGripSeatedCableRow", -2.2, 0.851, (-0.01,0.109,-0.013)),
 "Close-Grip Seated Cable Row": ("Back/CloseGripSeatedCableRow", -2.2, 0.936, (-0.028,0.12,-0.039)),
 "Single-Arm Cable Row": ("Back/SingleArmCableRow", -2.2, 0.902, (-0.021,0.116,-0.029)),
 "Standing Cable Row": ("Back/StandingCableRow", -2.2, 0.88, (-0.022,0.042,-0.03)),
 "Half-Kneeling Cable Row": ("Back/HalfKneelingCableRow", -2.2, 0.807, (0.025,0.117,0.035)),
 "High Cable Row": ("Back/HighCableRow", -2.2, 0.916, (-0.024,0.117,-0.033)),
 "Low Cable Row": ("Back/LowCableRow", -2.2, 0.902, (-0.021,0.116,-0.029)),
 "Machine Seated Row": ("Back/MachineSeatedRow", -2.4, 0.978, (-0.029,0.119,-0.027)),
 "Iso-Lateral Row Machine": ("Back/IsoLateralRowMachine", -2.4, 0.979, (-0.029,0.119,-0.027)),
 "Single-Arm Machine Row": ("Back/SingleArmMachineRow", -2.4, 1.017, (-0.053,0.124,-0.049)),
 "Reverse-Grip T-Bar Row": ("Back/ReverseGripTBarRow", -2.0, 1.051, (-0.03,0.169,-0.065)),
 "Dumbbell Pullover Row": ("Back/DumbbellPulloverRow", -1.3, 0.58, (-0.029,0.087,0.106)),
 "Machine Pullover": ("Back/MachinePullover", -0.9, 0.947, (-0.017,0.069,0.021)),
}
JOINTS = ["support_TrapeziusUpper_L","support_TrapeziusUpper_R","head","neck","chest","spine","pelvis","scapula_L","upper_arm_L","forearm_L","hand_L",
          "scapula_R","upper_arm_R","forearm_R","hand_R","thigh_L","patella_L","shin_L","foot_L","thigh_R","patella_R","shin_R","foot_R",
          # Chest and lat anchors for the pressing and pullover cues (2026-09-25).
          "support_PectoralisMajor_Clavicular_L","support_PectoralisMajor_Sternal_L","support_PectoralisMajor_Abdominal_L",
          "support_PectoralisMajor_Clavicular_R","support_PectoralisMajor_Sternal_R","support_PectoralisMajor_Abdominal_R",
          "support_LatissimusDorsi_L","support_LatissimusDorsi_R"]

def proj(p, yaw, zoom, off):
    s = zoom / LONGEST
    w = (np.array(p) - np.array(CENTER)) * s + np.array(off)
    c, sn = math.cos(yaw), math.sin(yaw)
    x = w[0]*c + w[2]*sn; y = w[1]; z = -w[0]*sn + w[2]*c
    dz = D - z
    return ((x/(dz*TAN*ASPECT))+1)/2, (1-(y/(dz*TAN)))/2, dz

# Names after the output path limit the run; the output then merges into an
# existing file instead of replacing it.
only = sys.argv[2:] or [n for n in JOBS if n not in ("Squat","Step-Up","Single-Leg Glute Bridge","Push-Up","Plank")]
fr = [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875]
import os
out = json.load(open(sys.argv[1])) if sys.argv[2:] and os.path.exists(sys.argv[1]) else {}
for name in only:
    res, yaw, zoom, off = JOBS[name]
    st = Usd.Stage.Open(M + res + ".usdc")
    t0, t1 = st.GetStartTimeCode(), st.GetEndTimeCode()
    sk = next(p for p in st.Traverse() if p.GetTypeName() == "Skeleton")
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk))
    names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    idx = {n: i for i, n in enumerate(names)}
    out[name] = {j: [] for j in JOINTS}
    for f in fr:
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t0 + (t1 - t0) * f))
        for j in JOINTS:
            p = w[idx[j]].ExtractTranslation()
            u, v, _ = proj((p[0], p[1], p[2]), yaw, zoom, off)
            out[name][j].append((round(u, 3), round(v, 3)))
json.dump(out, open(sys.argv[1], "w"))
print(len(out), "exercises")
