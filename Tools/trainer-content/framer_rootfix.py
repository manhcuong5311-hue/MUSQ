# Offline replica of USDZViewport's framing: model scaled by zoom/1.7923 about
# the rig's bind-pose centre, offset, turned by yaw; camera at z=2.05, 32deg vFOV.
import os as _os  # slim models reference Shared/AnatomyBody.usdc (share_body.py)
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/Shared")
import math, sys, json
import numpy as np
from pxr import Usd, UsdGeom, UsdSkel, Gf

LONGEST = 1.7923362
CENTER = Gf.Vec3d(0.00017413497, 0.89716804, 0.10351651)
D, TAN = 2.05, math.tan(math.radians(16))

def rotY(v, a):
    c, s = math.cos(a), math.sin(a)
    return Gf.Vec3d(v[0]*c + v[2]*s, v[1], -v[0]*s + v[2]*c)

def gather(path, nt=12):
    st = Usd.Stage.Open(path)
    t0, t1 = st.GetStartTimeCode(), st.GetEndTimeCode()
    times = [t0 + (t1 - t0) * i / (nt - 1) for i in range(nt)]
    # The rig sits directly under /root, except when a machine's own follow
    # transform (e.g. an assisted-dip platform) parents the whole body, so find
    # it by type instead of assuming a fixed path.
    skel_path = next(p.GetPath() for p in st.Traverse() if p.GetTypeName() == "Skeleton")
    skel = UsdSkel.Skeleton(st.GetPrimAtPath(skel_path))
    q = UsdSkel.Cache().GetSkelQuery(skel)
    names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    keep = [i for i, n in enumerate(names) if not n.startswith(("MCH", "CTRL", "DEF_", "ORG", "attachment", "support", "guide", "deltoid_arc"))]
    body, equip = [], {}
    for t in times:
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t))
        P = {names[i]: w[i].ExtractTranslation() for i in keep}
        for n, p in P.items():
            r = 0.10
            for dx in (-r, r):
                for dy in (-r, r):
                    for dz in (-r, r):
                        body.append(p + Gf.Vec3d(dx, dy, dz))
        # skull above the head joint
        up = (P["head"] - P["neck"]).GetNormalized()
        top = P["head"] + up * 0.16
        for dx in (-0.1, 0.1):
            for dz in (-0.1, 0.1):
                body.append(top + Gf.Vec3d(dx, 0, dz))
        xc = UsdGeom.XformCache(t)
        root = st.GetPrimAtPath("/root")
        root = root if root.IsValid() else st.GetDefaultPrim()
        for c in root.GetChildren():
            if c.GetName() in ("Anatomy_MasterRig", "DARK_Floor") or not c.IsActive() or not c.IsA(UsdGeom.Imageable):
                continue
            for m in Usd.PrimRange(c):
                if m.GetTypeName() != "Mesh": continue
                if UsdGeom.Imageable(m).ComputeVisibility(t) == "invisible": continue
                pts = np.array(UsdGeom.Mesh(m).GetPointsAttr().Get(t), dtype=float)
                if len(pts) == 0: continue
                if len(pts) > 400: pts = pts[:: max(1, len(pts) // 400)]
                M = np.array(xc.GetLocalToWorldTransform(m), dtype=float)
                hom = np.c_[pts, np.ones(len(pts))] @ M
                equip.setdefault(c.GetName(), []).append(hom[:, :3])
    equip = {k: np.vstack(v) for k, v in equip.items()}
    return np.array([[p[0], p[1], p[2]] for p in body]), equip

def project(pts, yaw, zoom, off, aspect):
    s = zoom / LONGEST
    w = (np.asarray(pts) - np.array(CENTER)) * s + np.array(off)
    c, sn = math.cos(yaw), math.sin(yaw)
    x = w[:, 0] * c + w[:, 2] * sn; y = w[:, 1]; z = -w[:, 0] * sn + w[:, 2] * c
    dz = D - z
    xs = x / (dz * TAN * aspect); ys = y / (dz * TAN)
    return xs.min(), xs.max(), ys.min(), ys.max()

def solve(pts, yaw, aspect, mx=0.90, my_top=0.84, my_bot=0.84):
    """Largest zoom (and screen-space shift) that fits pts in the margins."""
    lo, hi = 0.2, 2.5
    best = None
    for _ in range(40):
        z = (lo + hi) / 2
        # centre by iterating the shift a few times (perspective makes it non-linear)
        t = Gf.Vec3d(0, 0, 0)
        for _ in range(6):
            off = rotY(t, -yaw)
            x0, x1, y0, y1 = project(pts, yaw, z, off, aspect)
            s_to_world = (D) * TAN
            t = t + Gf.Vec3d(-(x0 + x1) / 2 * s_to_world * aspect, -((y0 + y1) / 2 - (my_top - my_bot) / 2) * s_to_world, 0)
        off = rotY(t, -yaw)
        x0, x1, y0, y1 = project(pts, yaw, z, off, aspect)
        ok = x0 >= -mx and x1 <= mx and y0 >= -my_bot and y1 <= my_top
        if ok: lo, best = z, (z, off)
        else: hi = z
    return best

if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "measure":   # file yaw zoom ox oy oz aspect
        f, yaw, zoom, ox, oy, oz, aspect = sys.argv[2], *map(float, sys.argv[3:9])
        body, equip = gather(f)
        print("body ", ["%.2f" % v for v in project(body, yaw, zoom, (ox, oy, oz), aspect)])
        for k, v in equip.items():
            print("equip", k, ["%.2f" % x for x in project(v, yaw, zoom, (ox, oy, oz), aspect)])
