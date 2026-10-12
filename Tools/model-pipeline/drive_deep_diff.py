# Deep diff of a raw export (wrapped like convert_all.py) against its app model.
#   drive_deep_diff.py <raw.usdc>=<Group/Resource> ...
import os, sys, re
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import numpy as np
from pxr import Usd, UsdGeom, UsdSkel, UsdShade
from drive_diff import wrap, skel_query, M

FR = [1, 25, 49, 73, 97, 121, 145, 169, 192]


def all_joints(st, frames):
    q, names, _ = skel_query(st)
    return names, np.array([[list(m.ExtractTranslation()) for m in q.ComputeJointWorldTransforms(UsdGeom.XformCache(f))] for f in frames]) * 100


def meshes(st):
    out = {}
    for p in st.Traverse():
        if p.GetTypeName() not in ("Mesh", "BasisCurves"): continue
        path = p.GetPath().pathString
        if "/Anatomy_MasterRig/" in path or "/DARK_Floor" in path: continue
        out[path] = p
    return out


def boxes(st, prims, frames):
    res = {}
    for f in frames:
        c = UsdGeom.BBoxCache(Usd.TimeCode(f), [UsdGeom.Tokens.default_, UsdGeom.Tokens.render])
        for k, p in prims.items():
            vis = UsdGeom.Imageable(p).ComputeVisibility(Usd.TimeCode(f)) != UsdGeom.Tokens.invisible
            r = c.ComputeWorldBound(p).ComputeAlignedRange()
            res.setdefault(k, []).append((vis, None if r.IsEmpty() else np.array(list(r.GetMin()) + list(r.GetMax())) * 100))
    return res


def mats(st):
    out = {}
    for p in st.Traverse():
        if p.GetTypeName() != "Shader": continue
        for a in p.GetAttributes():
            if a.GetName().startswith("inputs:") and a.HasAuthoredValue():
                v = a.Get()
                if isinstance(v, (int, float)) or hasattr(v, "__len__") and not isinstance(v, str):
                    try: out[p.GetPath().pathString.split("/_materials/")[-1] + "." + a.GetName()[7:]] = np.atleast_1d(np.array(v, dtype=float))
                    except Exception: pass
                elif v is not None:
                    out[p.GetPath().pathString.split("/_materials/")[-1] + "." + a.GetName()[7:]] = str(v)
    return out


def binds(st):
    out = {}
    for p in st.Traverse():
        if p.GetTypeName() != "Mesh": continue
        m, _ = UsdShade.MaterialBindingAPI(p).ComputeBoundMaterial()
        out[p.GetPath().pathString] = m.GetPath().name if m else None
    return out


for arg in sys.argv[1:]:
    src, res = arg.split("=")
    raw, new = wrap(src)
    old = Usd.Stage.Open(M + res + ".usdc")
    print(f"\n#### {os.path.basename(src)} vs {res}")
    nn, nj = all_joints(new, FR); on, oj = all_joints(old, FR)
    common = [n for n in nn if n in on]
    d = np.linalg.norm(nj[:, [nn.index(n) for n in common]] - oj[:, [on.index(n) for n in common]], axis=2).max(axis=0)
    top = sorted(zip(d, common), reverse=True)[:4]
    print("  joints: all-211 max %.2f cm  top: %s" % (d.max(), ", ".join(f"{n} {v:.1f}" for v, n in top)))
    mn, mo = meshes(new), meshes(old)
    print(f"  meshes: raw {len(mn)}  app {len(mo)}  only-raw {len(set(mn)-set(mo))}  only-app {len(set(mo)-set(mn))}")
    for k in sorted(set(mn) - set(mo))[:12]: print("    only-raw", k.replace('/root/', ''))
    for k in sorted(set(mo) - set(mn))[:12]: print("    only-app", k.replace('/root/', ''))
    bn, bo = boxes(new, {k: mn[k] for k in set(mn) & set(mo)}, FR), boxes(old, {k: mo[k] for k in set(mn) & set(mo)}, FR)
    moved = []
    for k in bn:
        worst = 0; visd = False
        for (va, a), (vb, b) in zip(bn[k], bo[k]):
            if va != vb: visd = True
            if a is not None and b is not None and np.abs(a).max() < 1e5 and np.abs(b).max() < 1e5:
                worst = max(worst, float(np.abs(a - b).max()))
        if worst >= 1 or visd: moved.append((worst, k, visd))
    for w, k, v in sorted(moved, reverse=True)[:12]: print(f"    moved {w:7.1f} cm {'VIS-DIFF ' if v else ''}{k.replace('/root/', '')}")
    print(f"  meshes moved >=1cm or visibility differs: {len(moved)}")
    an, ao = mats(new), mats(old)
    md = []
    for k in sorted(set(an) | set(ao)):
        a, b = an.get(k), ao.get(k)
        if a is None or b is None: md.append((k, "only-" + ("raw" if b is None else "app"))); continue
        if isinstance(a, str) or isinstance(b, str):
            if str(a) != str(b) and not k.endswith(".file"): md.append((k, f"{b} -> {a}"))
            continue
        if a.shape != b.shape or np.abs(a - b).max() > 1e-3: md.append((k, f"{np.round(b,3).tolist()} -> {np.round(a,3).tolist()}"))
    print(f"  material inputs differing: {len(md)}")
    for k, v in md[:15]: print("    ", k, v)
    bnn, bno = binds(new), binds(old)
    bd = [(k, bno[k], bnn[k]) for k in set(bnn) & set(bno) if bnn[k] != bno[k]]
    print(f"  material binding changes: {len(bd)}", bd[:8])
