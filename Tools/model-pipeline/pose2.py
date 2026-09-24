import sys, os, math
from pxr import Usd, UsdSkel, UsdGeom, Gf
def load(f):
    st = Usd.Stage.Open(f)
    skel = UsdSkel.Skeleton(st.GetPrimAtPath("/root/Anatomy_MasterRig/Anatomy_MasterRig_Skeleton"))
    q = UsdSkel.Cache().GetSkelQuery(skel)
    names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    return st, q, names
def Y(v):  # raw Z-up -> app Y-up
    return Gf.Vec3d(v[0], v[2], -v[1])
if sys.argv[1] == "--joints":
    st, q, names = load(sys.argv[2]); print([n for n in names if not n.startswith(("MCH","CTRL","DEF_","ORG"))]); sys.exit()
for f in sys.argv[1:]:
    st, q, names = load(f)
    idx = {n: i for i, n in enumerate(names)}
    rows = []
    for t in (1, 48, 96):
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t))
        P = lambda n: Y(w[idx[n]].ExtractTranslation())
        L = P("thigh_L")
        R = P("thigh_R")
        lr = L - R
        fwd = Gf.Vec3d(-lr[2], 0, lr[0])  # (L-R) x up, with up=(0,1,0): (lrx,lry,lrz)x(0,1,0) = (-lrz, 0, lrx)
        yawf = math.degrees(math.atan2(fwd[0], fwd[2]))
        h, p = P("head"), P("pelvis")
        rows.append(f"t{t}: facing {yawf:+4.0f}° head({h[0]:+.2f},{h[1]:+.2f},{h[2]:+.2f}) pelvis({p[0]:+.2f},{p[1]:+.2f},{p[2]:+.2f}) hL({P('hand_L')[0]:+.2f},{P('hand_L')[1]:+.2f},{P('hand_L')[2]:+.2f})")
    print(os.path.basename(f)[:30].ljust(30), "\n   " + "\n   ".join(rows))
