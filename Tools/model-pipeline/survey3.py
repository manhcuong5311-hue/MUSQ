import sys, os
from pxr import Usd, UsdGeom, UsdLux
SKIP = ("_materials",)
for f in sys.argv[1:]:
    st = Usd.Stage.Open(f)
    cache = UsdGeom.BBoxCache(Usd.TimeCode(1), [UsdGeom.Tokens.default_, UsdGeom.Tokens.render])
    out = []
    for c in st.GetPrimAtPath("/root").GetChildren():
        n = sum(1 for p in Usd.PrimRange(c) if p.GetTypeName() == "Mesh")
        if n == 0 or c.GetName() in ("Anatomy_MasterRig", "DARK_Floor"): continue
        r = cache.ComputeWorldBound(c).ComputeAlignedRange()
        mn, mx = r.GetMin(), r.GetMax()
        far = max(abs(r.GetMidpoint()[0]), abs(r.GetMidpoint()[1])) > 5
        out.append(f"{c.GetName()}[{n}]{'PARKED' if far else ''} z{mn[2]:.2f}..{mx[2]:.2f}")
    print(os.path.basename(f)[:34].ljust(34), " | ".join(out))
