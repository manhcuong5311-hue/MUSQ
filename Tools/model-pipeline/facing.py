# Which way a converted (Y-up) model's lifter faces, and their posture, at the
# start, a quarter and the middle of the clip (401-500 batch, 2026-10-04).
# Facing comes from the hips (thigh_L - thigh_R) x up; 0 deg = +z.
#   facing.py <Group/Resource> ...
import os, sys, math
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
import numpy as np
from pxr import Usd, UsdSkel, UsdGeom
M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"
for res in sys.argv[1:]:
    st = Usd.Stage.Open(M + res + ".usdc")
    sk = next(p for p in sorted(st.Traverse(), key=lambda q: "Anatomy_MasterRig" not in q.GetPath().pathString) if p.IsA(UsdSkel.Skeleton))
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk)); names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    idx = {n: i for i, n in enumerate(names)}
    t0, t1 = st.GetStartTimeCode(), st.GetEndTimeCode()
    rows = []
    for t in (t0, t0 + (t1 - t0) * 0.25, t0 + (t1 - t0) * 0.5):
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t))
        P = lambda n: np.array(w[idx[n]].ExtractTranslation())
        lr = P("thigh_L") - P("thigh_R")
        yaw = math.degrees(math.atan2(-lr[2], lr[0]))
        trunk = P("neck") - P("pelvis")
        tilt = math.degrees(math.acos(trunk[1] / np.linalg.norm(trunk)))
        rows.append(f"t{t:.0f} facing {yaw:+4.0f} deg, trunk {tilt:3.0f} deg from vertical, pelvis {np.round(P('pelvis'), 2)} head {np.round(P('head'), 2)}")
    print(res, "\n   " + "\n   ".join(rows))
