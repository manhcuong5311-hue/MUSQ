# Walks a converted clip in place (2026-09-26, the loaded carries): the pelvis
# keeps its first-frame position across the floor, and every prop that travels
# with the lifter (the dumbbells under /root) is moved back by the same amount,
# so the carry plays like a treadmill walk instead of leaving the viewport.
# Height changes (the bob of each step) are kept. Edits the usdc in place.
#   python3 inplace.py <converted.usdc> [prop prim names...]
import os as _os  # slim models reference Shared/AnatomyBody.usdc (share_body.py)
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
import sys
import numpy as np
from pxr import Usd, UsdSkel, UsdGeom, Gf

path, props = sys.argv[1], sys.argv[2:] or ["GYM_Dumbbell_L_ROOT", "GYM_Dumbbell_R_ROOT"]
st = Usd.Stage.Open(path)
sk = next(p for p in sorted(st.Traverse(), key=lambda q: "Anatomy_MasterRig" not in q.GetPath().pathString) if p.GetTypeName() == "Skeleton")
anim = UsdSkel.Animation(next(p for p in st.Traverse() if p.GetTypeName() == "SkelAnimation"))
q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk))
order = [str(j) for j in q.GetJointOrder()]
pelvis_world = order.index("root/pelvis")

def pelvis_at(t):
    return np.array(q.ComputeJointWorldTransforms(UsdGeom.XformCache(t))[pelvis_world].ExtractTranslation())

tr = anim.GetTranslationsAttr()
times = tr.GetTimeSamples()
t0 = times[0]
p0 = pelvis_at(t0)
# World drift per time, floor plane only (app space is Y-up).
drift = {}
for t in times:
    d = pelvis_at(t) - p0
    drift[t] = np.array([d[0], 0.0, d[2]])

# Props: move each translate sample back by the drift, in its parent's space.
for name in props:
    prim = next((p for p in st.GetPrimAtPath("/root").GetChildren() if p.GetName() == name and p.IsActive()), None)
    if prim is None:
        continue
    xf = UsdGeom.Xformable(prim)
    op = next(o for o in xf.GetOrderedXformOps() if o.GetOpType() == UsdGeom.XformOp.TypeTranslate)
    parent = np.array(UsdGeom.Xformable(prim.GetParent()).ComputeLocalToWorldTransform(t0), dtype=float)
    inv = np.linalg.inv(parent[:3, :3])  # row-vector convention: world = local @ M
    for t in op.GetAttr().GetTimeSamples():
        d = drift.get(t)
        if d is None:
            d = pelvis_at(t) - p0
            d = np.array([d[0], 0.0, d[2]])
        local = d @ inv
        v = op.GetAttr().Get(t)
        op.GetAttr().Set(Gf.Vec3d(v[0] - local[0], v[1] - local[1], v[2] - local[2]) if isinstance(v, Gf.Vec3d)
                         else type(v)(v[0] - local[0], v[1] - local[1], v[2] - local[2]), t)

# Pelvis: hold its first-frame floor position in skeleton space.
i = [str(j) for j in anim.GetJointsAttr().Get()].index("root/pelvis")
first = tr.Get(t0)[i]
for t in times:
    v = tr.Get(t)
    v[i] = Gf.Vec3f(first[0], v[i][1], first[2])
    tr.Set(v, t)

st.GetRootLayer().Save()
after = pelvis_at(times[-1]) - pelvis_at(t0)
print(f"{path.split('/')[-1]}: drift {np.linalg.norm(list(drift.values())[-1]):.2f} m -> {np.hypot(after[0], after[2]):.3f} m")
