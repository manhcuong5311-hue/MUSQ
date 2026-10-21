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
 "Deadlift": ("Back/ConventionalDeadlift", -2, 0.866, (-0.048, 0.031, -0.104)),
 "Sumo Deadlift": ("Back/SumoDeadlift", -2.0, 0.877, (-0.018, 0.045, -0.039)),
 "Deficit Deadlift": ("Back/DeficitDeadlift", -2.0, 0.812, (-0.008, 0.006, -0.018)),
 "Snatch-Grip Deadlift": ("Back/SnatchGripDeadlift", -2.0, 0.843, (-0.009, 0.034, -0.020)),
 "Rack Pull": ("Back/RackPull", -2.5, 0.586, (-0.015, 0.028, -0.011)),
 "Block Pull": ("Back/BlockPull", -2.0, 0.856, (-0.027, 0.057, -0.059)),
 "Trap Bar Deadlift": ("Back/TrapBarDeadlift", -2.0, 0.868, (0.029, 0.032, 0.062)),
 "Romanian Deadlift": ("Legs/RomanianDeadlift", 0, 0.597, (0, 0.019, 0)),
 "Stiff-Leg Deadlift": ("Legs/StiffLegDeadlift", -0.8, 0.666, (-0.007, 0.021, 0.007)),
 "Smith Machine Romanian Deadlift": ("Legs/SmithMachineRomanianDeadlift", -0.6, 0.878, (-0.001, 0.049, 0.001)),
 "Barbell Single-Leg Romanian Deadlift": ("Legs/BarbellSingleLegRomanianDeadlift", -1.3, 0.599, (-0.024, 0.011, 0.087)),
}
JOINTS = ["support_TrapeziusUpper_L", "head", "neck", "chest", "spine", "pelvis", "scapula_L", "scapula_R",
          "upper_arm_L", "upper_arm_R", "forearm_L", "forearm_R", "hand_L", "hand_R",
          "patella_L", "patella_R", "foot_L", "foot_R", "thigh_R", "thigh_L", "shin_L", "shin_R", "CTRL_finger_middle_01_L", "CTRL_finger_middle_01_R", "support_TrapeziusUpper_R", "toe_L"]
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
