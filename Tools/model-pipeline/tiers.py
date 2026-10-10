# Muscle highlight tiers per model (401-500 batch, 2026-10-04), read off each
# anatomy mesh's bound material in the composed stage: bright (red >= 0.6, the
# PRIMARY paint), dim (0.2-0.6, SECONDARY), faint (0.05-0.2). Mesh names lose
# _L/_R/_Mesh; a muscle lit on one side only is marked (L) / (R). The rig
# paints the hip flexors on its Sartorius mesh.
# The 2026-10-10 exports' FF_Highlight_* materials (one per muscle group and
# side) mostly carry the level in the diffuse (1.0 bright, 0.256 dim) with a
# matching emissive (0.153 / 0.038), but some cap the diffuse at 0.15 and show
# the level only in the emissive, so a muscle's level is the larger of its red
# diffuse and its emissive red / 0.153.
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
        e = sh.GetAttribute("inputs:emissiveColor") if sh else None
        c = a.Get() if a else None
        g = e.Get() if e else None
        if c is None: continue
        r = 0.0 if abs(c[0] - c[1]) < 0.05 and abs(c[1] - c[2]) < 0.05 else c[0]  # grey is unlit
        if g is not None and g[0] > 0.01 and g[0] > 2 * g[2]:
            r = max(r, min(1.0, g[0] / 0.153))
        if r < 0.05: continue
        tier = "bright" if r >= 0.6 else "dim" if r >= 0.2 else "faint"
        name = re.sub(r"_Mesh(_\d{3})?$", "", p.GetName())  # the hack-squat rig adds _001
        side = "L" if name.endswith("_L") else "R" if name.endswith("_R") else ""
        seen.setdefault((tier, re.sub(r"_[LR]$", "", name)), set()).add(side)
    tiers = {"bright": [], "dim": [], "faint": []}
    for (tier, base), sides in sorted(seen.items()):
        tiers[tier].append(base if sides >= {"L", "R"} or sides == {""} else f"{base} ({''.join(sorted(sides))})")
    out[res] = tiers
    print(f"{res}\n  bright: {', '.join(tiers['bright'])}\n  dim:    {', '.join(tiers['dim'])}\n  faint:  {', '.join(tiers['faint'])}")
json.dump(out, open(sys.argv[1], "w"), indent=1)
