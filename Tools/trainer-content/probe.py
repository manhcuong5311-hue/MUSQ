# Projects rig joints through each exercise's framing with the app's camera
# (vertical FOV 32deg at z=2.05, viewport aspect 382/705) — unit coords.
import sys, math, json
sys.path.insert(0, "/Users/sammanhcuong/Desktop/GymWorkout/Tools/model-pipeline")
from framer import LONGEST, CENTER, D, TAN
from pxr import Usd, UsdSkel, UsdGeom
import numpy as np
ASPECT = 382 / 705
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
}
JOINTS = ["support_TrapeziusUpper_L","support_TrapeziusUpper_R","head","neck","chest","spine","pelvis","scapula_L","upper_arm_L","forearm_L","hand_L",
          "scapula_R","upper_arm_R","forearm_R","hand_R","thigh_L","patella_L","shin_L","foot_L","thigh_R","patella_R","shin_R","foot_R"]

def proj(p, yaw, zoom, off):
    s = zoom / LONGEST
    w = (np.array(p) - np.array(CENTER)) * s + np.array(off)
    c, sn = math.cos(yaw), math.sin(yaw)
    x = w[0]*c + w[2]*sn; y = w[1]; z = -w[0]*sn + w[2]*c
    dz = D - z
    return ((x/(dz*TAN*ASPECT))+1)/2, (1-(y/(dz*TAN)))/2, dz

only = [n for n in JOBS if n not in ("Squat","Step-Up","Single-Leg Glute Bridge","Push-Up","Plank")]
fr = [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875]
out = {}
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
