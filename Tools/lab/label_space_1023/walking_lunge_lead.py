# walking_lunge_lead.py <lab> <outjson>: per sample of Walking Lunge, the app's BodyFrame.leadingSide (Blender python, pxr)
import os, sys, json, math
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
from pxr import Usd, UsdSkel, UsdGeom
import numpy as np, glob
LAB, OUT = sys.argv[1], sys.argv[2]
NAME = "Walking Lunge"
M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"
res = glob.glob(M + "*/WalkingLunge.usdc")[0]
times = json.load(open(os.path.join(LAB, 'proj_at.json')))[NAME]['times']
st = Usd.Stage.Open(res)
t0 = st.GetStartTimeCode(); fps = st.GetTimeCodesPerSecond()
sk = next(p for p in sorted(st.Traverse(), key=lambda q: "Anatomy_MasterRig" not in q.GetPath().pathString) if p.GetTypeName() == "Skeleton")
q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk))
idx = {str(j).split("/")[-1]: i for i, j in enumerate(q.GetJointOrder())}
rise = np.array([0, 1, 0.])
out = []
for t in times:
    w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t0 + t * fps))
    P = lambda n: np.array(w[idx[n]].ExtractTranslation())
    pelvis, neck, hipL, hipR, fL, fR = P('pelvis'), P('neck'), P('thigh_L'), P('thigh_R'), P('foot_L'), P('foot_R')
    spine = neck - pelvis; up = spine / np.linalg.norm(spine)
    across = (hipL - hipR) - np.dot(hipL - hipR, up) * up
    left = across / np.linalg.norm(across)
    fwd = np.cross(left, up)
    level = fwd - np.dot(fwd, rise) * rise
    ahead = level / np.linalg.norm(level)
    d = float(np.dot(fL - fR, ahead))
    out.append(('L' if d >= 0 else 'R', round(d, 4)))
json.dump(dict(times=times, lead=out), open(OUT, 'w'))
for t, (s, d) in zip(times, out): print('%5.2f %s %+.4f' % (t, s, d))
