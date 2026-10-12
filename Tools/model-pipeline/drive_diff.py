# Compare raw drive exports with the app models they would replace (read-only,
# 2026-10-12): key joints every 4 frames, muscle tiers, equipment groups.
#   drive_diff.py out.jsonl <raw.usdc>=<Group/Resource>|NEW ...
# Raw is wrapped like convert_all.py (reference /root, rotateX -90) so world
# space matches the app model's.
import os, sys, json, re
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
import numpy as np
from pxr import Usd, UsdGeom, UsdSkel, UsdShade, UsdLux, Sdf, Gf

M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"
JOINTS = ["hand_L", "hand_R", "forearm_L", "forearm_R", "foot_L", "foot_R", "toe_L", "toe_R",
          "shin_L", "shin_R", "thigh_L", "thigh_R", "head", "pelvis", "chest"]


def wrap(src):
    raw = Usd.Stage.Open(src)
    st = Usd.Stage.Open(Sdf.Layer.CreateAnonymous(".usda"))
    UsdGeom.SetStageUpAxis(st, UsdGeom.Tokens.y)
    st.SetStartTimeCode(raw.GetStartTimeCode()); st.SetEndTimeCode(raw.GetEndTimeCode())
    root = (UsdSkel.Root if raw.GetPrimAtPath("/root").IsA(UsdSkel.Root) else UsdGeom.Xform).Define(st, "/root")
    root.GetPrim().GetReferences().AddReference(src, "/root")
    root.AddRotateXOp().Set(-90)
    return raw, st


def skel_query(st):
    sk = sorted((p for p in st.Traverse() if p.GetTypeName() == "Skeleton"),
                key=lambda q: "Anatomy_MasterRig" not in q.GetPath().pathString)
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk[0]))
    return q, [str(j).split("/")[-1] for j in q.GetJointOrder()], len(sk)


def joint_track(st, frames):
    q, names, nskel = skel_query(st)
    idx = [names.index(j) for j in JOINTS]
    out = []
    for f in frames:
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(f))
        out.append([list(w[i].ExtractTranslation()) for i in idx])
    return np.array(out) * 100.0, len(names), nskel  # cm


def tiers(st):
    rig = next(p for p in st.Traverse() if p.GetName() == "Anatomy_MasterRig")
    seen = {}
    for p in Usd.PrimRange(rig):
        if p.GetTypeName() != "Mesh": continue
        m, _ = UsdShade.MaterialBindingAPI(p).ComputeBoundMaterial()
        if not m: continue
        sh = m.GetPrim().GetChild("Principled_BSDF")
        a = sh.GetAttribute("inputs:diffuseColor") if sh else None
        e = sh.GetAttribute("inputs:emissiveColor") if sh else None
        c = a.Get() if a else None
        g = e.Get() if e else None
        if c is None: continue
        r = 0.0 if abs(c[0] - c[1]) < 0.05 and abs(c[1] - c[2]) < 0.05 else c[0]
        if g is not None and g[0] > 0.01 and g[0] > 2 * g[2]:
            r = max(r, min(1.0, g[0] / 0.153))
        if r < 0.05: continue
        tier = "bright" if r >= 0.6 else "dim" if r >= 0.2 else "faint"
        name = re.sub(r"_Mesh(_\d{3})?$", "", p.GetName())
        seen[name] = max(seen.get(name, ""), tier, key=["", "faint", "dim", "bright"].index)
    return seen


def props(st, t):
    cache = UsdGeom.BBoxCache(Usd.TimeCode(t), [UsdGeom.Tokens.default_, UsdGeom.Tokens.render])
    out = {}
    for c in st.GetPrimAtPath("/root").GetChildren():
        if c.GetName() in ("Anatomy_MasterRig", "DARK_Floor", "_materials") or not c.IsA(UsdGeom.Imageable):
            continue
        box = Gf.Range3d(); n = 0
        for p in Usd.PrimRange(c):
            if p.GetTypeName() not in ("Mesh", "BasisCurves"): continue
            if UsdGeom.Imageable(p).ComputeVisibility(Usd.TimeCode(t)) == UsdGeom.Tokens.invisible: continue
            r = cache.ComputeWorldBound(p).ComputeAlignedRange()
            if r.IsEmpty() or max(abs(v) for v in list(r.GetMin()) + list(r.GetMax())) > 1e3: continue
            box.UnionWith(r); n += 1
        if not n: continue
        mid = box.GetMidpoint()
        if abs(mid[0]) > 5 or abs(mid[2]) > 5: continue  # parked off-stage (Y-up)
        out[c.GetName()] = [list(box.GetMin()), list(box.GetMax())]
    return out


def info(raw):
    cams = sum(1 for p in raw.Traverse() if p.IsA(UsdGeom.Camera))
    anims = sum(1 for p in raw.Traverse() if p.GetTypeName() == "SkelAnimation")
    return dict(start=raw.GetStartTimeCode(), end=raw.GetEndTimeCode(), cams=cams, anims=anims,
                skelroot_on_root=raw.GetPrimAtPath("/root").IsA(UsdSkel.Root))


if __name__ == "__main__":
    with open(sys.argv[1], "a") as fo:
        for arg in sys.argv[2:]:
            src, res = arg.split("=")
            rec = dict(src=os.path.basename(src), res=res)
            try:
                raw, new = wrap(src)
                rec.update(info(raw))
                s, e = int(new.GetStartTimeCode()), int(new.GetEndTimeCode())
                frames = list(range(s, e + 1, 4))
                nt, nj, ns = joint_track(new, frames)
                rec.update(joints=nj, skels=ns)
                rec["move"] = round(float((nt.max(axis=0) - nt.min(axis=0)).max()), 1)  # cm, largest joint travel
                rec["tiers_new"] = tiers(new)
                pn = props(new, s)
                rec["props_new"] = sorted(pn)
                if res != "NEW":
                    old = Usd.Stage.Open(M + res + ".usdc")
                    os_, oe = int(old.GetStartTimeCode()), int(old.GetEndTimeCode())
                    rec.update(old_range=[os_, oe])
                    fr = [f for f in frames if os_ <= f <= oe]
                    ot, _, _ = joint_track(old, fr)
                    nt2 = nt[[frames.index(f) for f in fr]]
                    d = np.linalg.norm(nt2 - ot, axis=2)  # frames x joints
                    per = d.max(axis=0)
                    rec["dmax"] = round(float(per.max()), 2)
                    rec["djoint"] = JOINTS[int(per.argmax())]
                    rec["dper"] = {j: round(float(v), 1) for j, v in zip(JOINTS, per) if v >= 1.0}
                    # constant offset? (whole lifter shifted)
                    off = (nt2 - ot).reshape(-1, 3)
                    rec["dspread"] = round(float(np.linalg.norm(off - off.mean(axis=0), axis=1).max()), 2)
                    rec["dmean"] = [round(float(v), 1) for v in off.mean(axis=0)]
                    to = tiers(old)
                    rec["paint"] = {k: [to.get(k, "-"), rec["tiers_new"].get(k, "-")]
                                    for k in sorted(set(to) | set(rec["tiers_new"])) if to.get(k) != rec["tiers_new"].get(k)}
                    po = props(old, os_)
                    rec["props_old"] = sorted(po)
                    mv = {}
                    for k in set(po) & set(pn):
                        a, b = np.array(po[k]) * 100, np.array(pn[k]) * 100
                        dd = float(np.abs(a - b).max())
                        if dd >= 2: mv[k] = round(dd, 1)
                    rec["props_moved"] = mv
                    rec["props_added"] = sorted(set(pn) - set(po))
                    rec["props_removed"] = sorted(set(po) - set(pn))
            except Exception as ex:
                rec["error"] = repr(ex)
            fo.write(json.dumps(rec) + "\n"); fo.flush()
            print(rec["src"], rec.get("dmax"), rec.get("error", ""), flush=True)
