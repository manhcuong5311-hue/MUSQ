# Puts bake_rest.py's rest-pose garment shapes into a converted female model
# (2026-10-12): the skinned bra and shorts keep their joints and weights, only
# their points change (normals dropped so RealityKit recomputes them), and the
# fabric is made matte (roughness 0.9, specular 0.2).
#   merge_rest.py <model.usdc> <rest.npz>
import sys, numpy as np
from pxr import Usd, UsdGeom, UsdShade, Vt
model, rest = sys.argv[1], np.load(sys.argv[2])
st = Usd.Stage.Open(model); done = []
for p in st.Traverse():
    if not p.IsA(UsdGeom.Mesh): continue
    owner = next((a.GetName() for a in [p, p.GetParent()] if a.GetName().startswith(("MUSQ_SportsBra", "MUSQ_Shorts"))), None)
    if not owner: continue
    key = owner.split("_0")[0] if owner.endswith("_001") else owner
    co = rest[key]; m = UsdGeom.Mesh(p)
    assert len(m.GetPointsAttr().Get()) == len(co), (p.GetPath(), len(co))
    m.GetPointsAttr().Set(Vt.Vec3fArray.FromNumpy(np.ascontiguousarray(co, np.float32)))
    if p.HasAttribute("normals"): p.RemoveProperty("normals")
    mat = UsdShade.MaterialBindingAPI(p).ComputeBoundMaterial()[0]
    sh = mat.GetPrim().GetChild("Principled_BSDF") if mat else None
    for k, v in (("inputs:roughness", 0.9), ("inputs:specular", 0.2)):
        if sh and sh.HasAttribute(k): sh.GetAttribute(k).Set(v)
    done.append(key)
assert sorted(done) == ["MUSQ_Shorts", "MUSQ_SportsBra"], done
st.Save(); print("rest merged", model.split("/")[-1])
