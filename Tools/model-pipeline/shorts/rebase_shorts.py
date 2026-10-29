# Puts the shared body's refit shorts into converted male models (2026-10-28), so a slim keeps
# none of the export's own: points, normals, extent and skin weights come from the body, and the
# joint indices are renumbered by joint name into the model's own skeleton (models carry 219-228
# joints in their own order). An export from a .blend that already has the refit has the same
# points and weights, but Blender writes them 4 to a vertex where the body has 5 and recomputes
# the normals, which a slim cannot drop. Run on every male model after convert_all.py and
# one_side_tiers.py, before pad_one.sh and slim_one.sh.
#   python3 rebase_shorts.py <Shared/AnatomyBody*.usdc> <model.usdc>...   (edits in place)
import os, sys
from pxr import Sdf, Usd, UsdSkel, Vt

SHORTS = Sdf.Path("/root/Anatomy_MasterRig/Anatomy_Shorts/Anatomy_Shorts_Surface")
GEOMETRY = ("points", "normals", "extent")
SKIN = ("primvars:skel:jointIndices", "primvars:skel:jointWeights")


def joint_names(stage):
    skels = sorted((p for p in stage.Traverse() if p.IsA(UsdSkel.Skeleton)),
                   key=lambda p: "Anatomy_MasterRig" not in p.GetPath().pathString)
    return [str(j).split("/")[-1] for j in UsdSkel.Skeleton(skels[0]).GetJointsAttr().Get()]


def rebase(body_path, model_path):
    body_layer = Sdf.Layer.FindOrOpen(body_path)    # held: a spec dies with its layer
    body = body_layer.GetPrimAtPath(SHORTS)
    body_joints = joint_names(Usd.Stage.Open(body_path))
    layer = Sdf.Layer.FindOrOpen(model_path)
    spec = layer.GetPrimAtPath(SHORTS)
    if spec is None:
        return "no male shorts"
    own = {name: i for i, name in enumerate(joint_names(Usd.Stage.Open(model_path)))}
    missing = sorted({body_joints[j] for j in body.attributes["primvars:skel:jointIndices"].default} - set(own))
    if missing:
        raise SystemExit(f"{model_path}: the skeleton lacks {missing}")
    for name in GEOMETRY + SKIN:
        src = body.attributes[name]
        dst = spec.attributes.get(name) or Sdf.AttributeSpec(spec, name, src.typeName, src.variability)
        value = src.default
        if name == "primvars:skel:jointIndices":
            value = Vt.IntArray([own[body_joints[j]] for j in value])
        dst.default = value
        for key in ("interpolation", "elementSize"):
            if src.HasInfo(key):
                dst.SetInfo(key, src.GetInfo(key))
            elif dst.HasInfo(key):
                dst.ClearInfo(key)
    # Save compact: an in-place save appends the old values as dead data.
    tmp = model_path + ".rebase.tmp.usdc"
    layer.Export(tmp)
    os.replace(tmp, model_path)
    return "rebased"


if __name__ == "__main__":
    body_path = sys.argv[1]
    for path in sys.argv[2:]:
        print(f"{os.path.basename(path):40s} {rebase(body_path, path)}")
