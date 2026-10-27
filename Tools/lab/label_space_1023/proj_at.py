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
def _presets():
    import re as _re
    am = open("/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Models/AnatomyModels.swift").read()
    out = {}
    for m in _re.finditer(r'static let (\w+) = ModelFraming\(\s*yaw: ([^,]+), zoom: ([\d.]+), offset: \[([-\d., ]+)\]', am):
        yaw = m[2].strip().replace('.pi', str(math.pi))
        out[m[1]] = (float(eval(yaw)), float(m[3]), tuple(float(v) for v in m[4].split(",")))
    return out
PRESETS = _presets()
def _jobs():
    import re as _re, glob as _glob
    src = open("/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Models/SampleData.swift").read()
    names = [l.strip() for l in open(os.environ.get("LIFTS") or os.path.join(os.path.dirname(os.path.abspath(__file__)), "lifts.txt")) if l.strip()]
    out = {}
    for n in names:
        m = _re.search(r'"%s":\s*ExerciseModel\(resource: "(\w+)",\s*framing: ModelFraming\(yaw: ([-\d.]+), zoom: ([\d.]+), offset: \[([-\d., ]+)\]\)' % _re.escape(n), src)
        if m:
            res, fr = m[1], (float(m[2]), float(m[3]), tuple(float(v) for v in m[4].split(",")))
        else:   # a named preset (.standing, .bench, ... in AnatomyModels.swift)
            m = _re.search(r'"%s":\s*ExerciseModel\(resource: "(\w+)",\s*framing: \.(\w+)\)' % _re.escape(n), src)
            res, fr = m[1], PRESETS[m[2]]
        out[n] = (_glob.glob(M + "*/" + res + ".usdc")[0][len(M):-5],) + fr
    return out
JOBS = _jobs()
JOINTS = ["support_TrapeziusUpper_L", "head", "neck", "chest", "spine", "pelvis", "scapula_L", "scapula_R",
          "upper_arm_L", "upper_arm_R", "forearm_L", "forearm_R", "hand_L", "hand_R",
          "patella_L", "patella_R", "foot_L", "foot_R", "thigh_R", "thigh_L", "shin_L", "shin_R", "CTRL_finger_middle_01_L", "CTRL_finger_middle_01_R", "support_TrapeziusUpper_R", "toe_L"]
# plus every joint the lifts' callouts track (parse_anns.py output, if made)
if os.path.exists(os.path.join(LAB, "anns.json")):
    JOINTS += sorted({a["joint"] for e in json.load(open(os.path.join(LAB, "anns.json"))).values() for a in e["anns"]} - set(JOINTS))
# EXTRA_JOINTS="a,b": more joints to project, for re-targeting a dot (2026-10-27)
JOINTS += [j for j in os.environ.get("EXTRA_JOINTS", "").split(",") if j and j not in JOINTS]
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
