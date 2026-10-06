# Muscle highlight tiers per model (401-500 batch, 2026-10-04), read off each
# anatomy mesh's bound material in the composed stage: bright (red >= 0.6, the
# PRIMARY paint), dim (0.2-0.6, SECONDARY), faint (0.05-0.2). Mesh names lose
# _L/_R/_Mesh; a muscle lit on one side only is marked (L) / (R). The rig
# paints the hip flexors on its Sartorius mesh.
#   tiers.py out.json <Group/Resource> ...
import os, sys, json, re
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
from pxr import Usd, UsdShade
M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"
out = {}
for res in sys.argv[2:]:
    st = Usd.Stage.Open(M + res + ".usdc")
    rig = next(p for p in st.Traverse() if p.GetName() == "Anatomy_MasterRig")
    seen = {}
    for p in Usd.PrimRange(rig):
        if p.GetTypeName() != "Mesh": continue
        m, _ = UsdShade.MaterialBindingAPI(p).ComputeBoundMaterial()
        if not m: continue
        sh = m.GetPrim().GetChild("Principled_BSDF")
        a = sh.GetAttribute("inputs:diffuseColor") if sh else None
        c = a.Get() if a else None
        if c is None: continue
        r = c[0]
        if r < 0.05 or (abs(c[0] - c[1]) < 0.05 and abs(c[1] - c[2]) < 0.05): continue  # unlit / grey
        tier = "bright" if r >= 0.6 else "dim" if r >= 0.2 else "faint"
        name = re.sub(r"_Mesh$", "", p.GetName())
        side = "L" if name.endswith("_L") else "R" if name.endswith("_R") else ""
        seen.setdefault((tier, re.sub(r"_[LR]$", "", name)), set()).add(side)
    tiers = {"bright": [], "dim": [], "faint": []}
    for (tier, base), sides in sorted(seen.items()):
        tiers[tier].append(base if sides >= {"L", "R"} or sides == {""} else f"{base} ({''.join(sorted(sides))})")
    out[res] = tiers
    print(f"{res}\n  bright: {', '.join(tiers['bright'])}\n  dim:    {', '.join(tiers['dim'])}\n  faint:  {', '.join(tiers['faint'])}")
json.dump(out, open(sys.argv[1], "w"), indent=1)
