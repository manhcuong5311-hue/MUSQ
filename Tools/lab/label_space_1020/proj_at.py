# Joint positions in viewport fractions at given seconds of each lift's clip (same camera math as
# Tools/trainer-content/probe.py). Blender's python (pxr, numpy). Usage: python3.13 proj_at.py <lab>
import os, sys, json, math
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
sys.path.insert(0, "/Users/sammanhcuong/Developer/GymWorkout/Tools/model-pipeline")
from framer import LONGEST, CENTER, D, TAN
from pxr import Usd, UsdSkel, UsdGeom
import numpy as np

LAB = sys.argv[1]
ASPECT = 382 / 655
M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"
JOBS = {
 "Back Squat": ("Legs/BackSquat", -1.0, 0.828, (-0.021,0.019,0.033)),
 "Box Squat": ("Legs/BoxSquat", -1.0, 0.847, (-0.025,0.019,0.039)),
 "Pause Squat": ("Legs/PauseSquat", -1.0, 0.85, (-0.026,0.017,0.04)),
 "Barbell Sumo Squat": ("Legs/BarbellSumoSquat", -0.8, 0.7, (-0.028,0.032,0.029)),
 "Heel-Elevated Squat": ("Legs/HeelElevatedSquat", -1.0, 0.832, (-0.02,0.019,0.031)),
 "Barbell Split Squat": ("Legs/BarbellSplitSquat", -1.3, 0.861, (-0.014,0.050,0.051)),
 "Smith Machine Split Squat": ("Legs/SmithMachineSplitSquat", -0.7, 0.885, (-0.041,0.082,0.035)),
 "Barbell Bulgarian Split Squat": ("Legs/BarbellBulgarianSplitSquat", -1.0, 0.793, (-0.032,0.057,0.051)),
 "Smith Machine Bulgarian Split Squat": ("Legs/SmithMachineBulgarianSplitSquat", -0.7, 0.873, (-0.015,0.081,0.012)),
 "Good Morning": ("Legs/GoodMorning", -2.3, 0.644, (-0.032,0.012,-0.035)),
 "Seated Good Morning": ("Legs/SeatedGoodMorning", -2.3, 0.593, (-0.026,0.057,-0.029)),
 "Smith Machine Good Morning": ("Legs/SmithMachineGoodMorning", -2.5, 0.874, (0.035,0.051,0.026)),
 "Barbell Step-Up": ("Legs/BarbellStepUp", -0.9, 0.682, (0.033,-0.056,-0.042)),
}
JOINTS = ["support_TrapeziusUpper_L", "head", "neck", "chest", "spine", "pelvis", "scapula_L", "scapula_R",
          "upper_arm_L", "upper_arm_R", "forearm_L", "forearm_R", "hand_L", "hand_R",
          "patella_L", "patella_R", "foot_L", "foot_R", "thigh_R", "CTRL_finger_middle_01_L", "CTRL_finger_middle_01_R", "support_TrapeziusUpper_R", "toe_L"]
B = json.load(open("/Users/sammanhcuong/Developer/GymWorkout/Tools/fault-review/bottoms.json"))


def proj(p, yaw, zoom, off):
    s = zoom / LONGEST
    w = (np.array(p) - np.array(CENTER)) * s + np.array(off)
    c, sn = math.cos(yaw), math.sin(yaw)
    x = w[0] * c + w[2] * sn; y = w[1]; z = -w[0] * sn + w[2] * c
    dz = D - z
    return ((x / (dz * TAN * ASPECT)) + 1) / 2, (1 - (y / (dz * TAN))) / 2


out = {}
for name, (res, yaw, zoom, off) in JOBS.items():
    st = Usd.Stage.Open(M + res + ".usdc")
    t0, t1 = st.GetStartTimeCode(), st.GetEndTimeCode()
    fps = st.GetTimeCodesPerSecond()
    sk = next(p for p in sorted(st.Traverse(), key=lambda q: "Anatomy_MasterRig" not in q.GetPath().pathString) if p.GetTypeName() == "Skeleton")
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk))
    names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    idx = {n: i for i, n in enumerate(names)}
    dur = (t1 - t0) / fps
    times = sorted(set([0.0, round(B.get(name, 1.0), 2)] + [round(k * 0.25, 2) for k in range(int(dur / 0.25) + 1)]))
    e = dict(duration=dur, times=times, joints={j: [] for j in JOINTS if j in idx})
    for t in times:
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t0 + t * fps))
        for j in e['joints']:
            p = w[idx[j]].ExtractTranslation()
            u, v = proj((p[0], p[1], p[2]), yaw, zoom, off)
            e['joints'][j].append((round(u, 4), round(v, 4)))
    out[name] = e
    print('%-36s %.2f s, %d samples' % (name, dur, len(times)))
json.dump(out, open(os.path.join(LAB, 'proj_at.json'), 'w'))
