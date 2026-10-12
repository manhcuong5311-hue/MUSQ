# Puts bake_clothes.py's garments into a converted female model (2026-10-12):
# the skinned bra and shorts are switched off, the baked ones added under the
# rig and bound to the model's own materials, and the fabric made matte
# (roughness 0.9, specular 0.2; RealityKit drew 0.5/1.0 as glossy plastic).
#   merge_clothes.py <model.usdc> <clothes.usdc>
import sys
from pxr import Usd, Sdf, UsdGeom
model, clothes = sys.argv[1], sys.argv[2]
src = Sdf.Layer.FindOrOpen(clothes); dst = Sdf.Layer.FindOrOpen(model)
rig = "/root/Anatomy_MasterRig"
def find(layer, prefix):
    out = {}
    def walk(spec):
        for c in spec.nameChildren:
            if c.name.startswith(prefix) and not c.name.endswith("_Baked"): out[c.name] = c.path
            walk(c)
    walk(layer.GetPrimAtPath("/root")); return out
mats = [c.name for c in dst.GetPrimAtPath("/root/_materials").nameChildren]
for prefix in ("MUSQ_SportsBra", "MUSQ_Shorts"):
    s = find(src, prefix); d = find(dst, prefix)
    assert len(s) == 1 and len(d) == 1, (prefix, s, d)
    (sname, spath), (dname, dpath) = next(iter(s.items())), next(iter(d.items()))
    dst.GetPrimAtPath(dpath).active = False
    newp = Sdf.Path(rig + "/" + dname + "_Baked")
    if dst.GetPrimAtPath(newp): del dst.GetPrimAtPath(rig).nameChildren[newp.name]
    assert Sdf.CopySpec(src, spath, dst, newp)
    def rebind(spec):
        r = spec.relationships.get("material:binding")
        if r:
            t = r.targetPathList.GetAddedOrExplicitItems()[0].name
            base = t[:-4] if t.endswith("_001") and t[:-4] in mats else t
            mat = base if base in mats else next(m for m in mats if m.startswith(base.split("_0")[0]))
            r.targetPathList.ClearEditsAndMakeExplicit(); r.targetPathList.explicitItems.append(Sdf.Path("/root/_materials/" + mat))
            sh = dst.GetPrimAtPath("/root/_materials/" + mat + "/Principled_BSDF")
            for k, v in (("inputs:roughness", 0.9), ("inputs:specular", 0.2)):
                if sh and sh.attributes.get(k): sh.attributes[k].default = v
        for c in spec.nameChildren: rebind(c)
    rebind(dst.GetPrimAtPath(newp))
dst.Save()
st = Usd.Stage.Open(model); st.Flatten().Export(model)
print("merged", model)
