# Projects named joints to normalised screen space (matching USDZViewport's
# own camera) for a given exercise + framing, at a chosen fraction of the
# clip's timeline. Used to place CueAnnotation labelPoints without guessing.
import os as _os  # slim models reference Shared/AnatomyBody.usdc (share_body.py)
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/Shared")
import sys
sys.path.insert(0, sys.argv[1])
from framer import project
from pxr import Usd, UsdSkel, UsdGeom
import numpy as np

M = "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/"
ASPECT = 0.74

def probe(res, yaw, zoom, off, t_fracs, joints):
    st = Usd.Stage.Open(M + res + ".usdc")
    t0, t1 = st.GetStartTimeCode(), st.GetEndTimeCode()
    skel_path = next(p.GetPath() for p in st.Traverse() if p.GetTypeName() == "Skeleton")
    skel = UsdSkel.Skeleton(st.GetPrimAtPath(skel_path))
    q = UsdSkel.Cache().GetSkelQuery(skel)
    names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    idx = {n: i for i, n in enumerate(names)}
    for tf in t_fracs:
        t = t0 + (t1 - t0) * tf
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t))
        print(f"-- t={tf:.2f} --")
        for j in joints:
            if j not in idx:
                print(f"  {j:14s} MISSING"); continue
            p = w[idx[j]].ExtractTranslation()
            x0, x1, y0, y1 = project(np.array([[p[0], p[1], p[2]]]), yaw, zoom, off, ASPECT)
            ux, uy = (x0 + 1) / 2, (1 - y0) / 2
            print(f"  {j:14s} ux={ux:.3f} uy={uy:.3f}")

if __name__ == "__main__":
    import json
    res, yaw, zoom, off, t_fracs, joints = json.loads(sys.argv[2])
    probe(res, yaw, zoom, tuple(off), t_fracs, joints)
