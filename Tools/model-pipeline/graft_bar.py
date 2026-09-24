# Grafts barbell geometry from one converted model onto another whose barbell
# rig came through the export without its meshes (2026-09-24: Back Squat had
# an animated GYM_Barbell_ROOT but only empty Xforms under it, so the hands
# held nothing). The donor's bar children and GYM materials are copied in the
# bar root's local space; the target keeps its own animated root transform.
# Only valid when both roots share rotation and scale — checked below.
#   python graft_bar.py <target.usdc> <donor.usdc>
import sys
from pxr import Sdf, Usd, UsdGeom

target, donor = sys.argv[1], sys.argv[2]
ROOT = "/root/GYM_Barbell_ROOT"
MATS = "/root/_materials"

def static_ops(path):
    stage = Usd.Stage.Open(path)   # keep the stage alive while its prim is read
    x = UsdGeom.Xformable(stage.GetPrimAtPath(ROOT))
    return [(op.GetOpName(), op.Get(1)) for op in x.GetOrderedXformOps() if op.GetOpName() != "xformOp:translate"]
assert static_ops(target) == static_ops(donor), "bar roots differ in rotation/scale"

src, dst = Sdf.Layer.FindOrOpen(donor), Sdf.Layer.FindOrOpen(target)
moved = 0
for child in src.GetPrimAtPath(ROOT).nameChildren:
    path = child.path
    if dst.GetPrimAtPath(path):
        del dst.GetPrimAtPath(ROOT).nameChildren[child.name]
    assert Sdf.CopySpec(src, path, dst, path), path
    moved += 1
for mat in src.GetPrimAtPath(MATS).nameChildren:
    if "GYM" in mat.name and not dst.GetPrimAtPath(mat.path):
        assert Sdf.CopySpec(src, mat.path, dst, mat.path), mat.path
dst.Save()
st = Usd.Stage.Open(target)
meshes = [p for p in Usd.PrimRange(st.GetPrimAtPath(ROOT)) if p.GetTypeName() == "Mesh"]
print(f"copied {moved} bar children; target bar now has {len(meshes)} meshes")
