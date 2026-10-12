# One-sided highlights (2026-10-12). The FF_Highlight_<Group>_<side> materials
# take their colour in Blender from a side-aware "Fitness side color" mix, but
# the Principled BSDF's Base Color socket still carries an older side-blind
# driver; the USD exporter cannot follow a mix node, so it writes that stale
# default and the resting side comes out as red as the working one (only the
# emissive keeps the side). A group lit in the diffuse with no emissive while
# its other side glows is the resting side: Blender draws it with the mix's
# Color1, the unlit 0.0075 grey, and so does the app after this. Idempotent.
#   one_side_tiers.py <model.usdc> ...
import os, sys
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
from pxr import Usd, Gf
UNLIT = Gf.Vec3f(0.007499032, 0.007499032, 0.007499032)
for path in sys.argv[1:]:
    st = Usd.Stage.Open(path)
    mats = {}
    for p in st.Traverse():
        n = p.GetName()
        if p.GetTypeName() != "Material" or not n.startswith("FF_Highlight_") or n[-2:] not in ("_L", "_R"): continue
        sh = p.GetChild("Principled_BSDF")
        d = sh.GetAttribute("inputs:diffuseColor") if sh else None
        if not d or d.Get() is None: continue
        e = sh.GetAttribute("inputs:emissiveColor").Get() if sh.HasAttribute("inputs:emissiveColor") else None
        mats[n] = (d, max(e) if e is not None else 0.0)
    fixed = []
    for n, (d, e) in sorted(mats.items()):
        other = mats.get(n[:-1] + ("R" if n.endswith("L") else "L"))
        if max(d.Get()) > 0.05 and e == 0 and other and other[1] > 0:
            d.Set(UNLIT); fixed.append(n[len("FF_Highlight_"):])
    if fixed: st.Save()
    print(os.path.basename(path), "unlit:", ", ".join(fixed) if fixed else "-")
