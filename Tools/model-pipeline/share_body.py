# Shared anatomy body (2026-09-26). Every converted model carries the same
# 125-mesh anatomy rig (~18 MB of its ~19 MB); only the animation, the skeleton's
# rest pose, the muscle-highlight colours and the equipment differ. This splits
# a model into
#   AnatomyBody.usdc  — the rig and its materials, no animation, no equipment
#                       (written once, shipped once), and
#   <Model>.usdc      — a small layer that references AnatomyBody.usdc's /root
#                       and keeps only what differs from it (~1-1.5 MB).
# Composition does the rest: the app loads <Model>.usdc exactly as before.
#
#   python3 share_body.py body <any converted model.usdc> <out/AnatomyBody.usdc>
#   python3 share_body.py slim <model.usdc> <AnatomyBody.usdc> [<out.usdc>]
#
# The reference is written as the bare file name "AnatomyBody.usdc": in the app
# bundle every resource sits side by side, so it resolves next to the model.
# Blender-Python tools reading slim models from the repo need the body's folder
# on the search path: PXR_AR_DEFAULT_SEARCH_PATH=<repo>/GymWorkout/Resources/Models/Shared
import sys, os
# Before pxr loads: slim models in the repo find the body through this.
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH",
                      "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
from pxr import Sdf, Usd

BODY = "AnatomyBody.usdc"
RIG = Sdf.Path("/root/Anatomy_MasterRig")
MATERIALS = Sdf.Path("/root/_materials")


def load(path):
    layer = Sdf.Layer.FindOrOpen(path)
    if layer is None:
        raise SystemExit(f"cannot open {path}")
    copy = Sdf.Layer.CreateAnonymous(".usdc")
    copy.TransferContent(layer)
    return copy


def walk(spec):
    yield spec
    for child in spec.nameChildren:
        yield from walk(child)


def body(src, out):
    layer = load(src)
    root = layer.GetPrimAtPath("/root")
    # Materials the rig's meshes are bound to.
    used = set()
    for spec in walk(layer.GetPrimAtPath(RIG)):
        rel = spec.relationships.get("material:binding")
        if rel:
            used.update(p for p in rel.targetPathList.GetAddedOrExplicitItems())
    for child in list(root.nameChildren):
        if child.path not in (RIG, MATERIALS):
            del root.nameChildren[child.name]
    mats = layer.GetPrimAtPath(MATERIALS)
    for m in list(mats.nameChildren):
        if not any(u.HasPrefix(m.path) for u in used):
            del mats.nameChildren[m.name]
    for spec in list(walk(layer.GetPrimAtPath(RIG))):
        if spec.typeName == "SkelAnimation":
            del spec.nameParent.nameChildren[spec.name]
        elif spec.typeName == "Skeleton" and "skel:animationSource" in spec.relationships:
            spec.RemoveProperty(spec.relationships["skel:animationSource"])
    # No animation of its own: drop the clip range; up axis and units stay.
    if layer.HasStartTimeCode(): layer.ClearStartTimeCode()
    if layer.HasEndTimeCode(): layer.ClearEndTimeCode()
    layer.Export(out)
    print(f"{out}: {os.path.getsize(out) / 1e6:.1f} MB")


def same_property(a, b, layer_a, layer_b):
    if isinstance(a, Sdf.AttributeSpec) != isinstance(b, Sdf.AttributeSpec):
        return False
    if isinstance(a, Sdf.AttributeSpec):
        if a.typeName != b.typeName or a.variability != b.variability:
            return False
        if a.HasDefaultValue() != b.HasDefaultValue():
            return False
        if a.HasDefaultValue() and a.default != b.default:
            return False
        ta = layer_a.ListTimeSamplesForPath(a.path)
        tb = layer_b.ListTimeSamplesForPath(b.path)
        if list(ta) != list(tb):
            return False
        for t in ta:
            if layer_a.QueryTimeSample(a.path, t) != layer_b.QueryTimeSample(b.path, t):
                return False
        for key in ("interpolation", "elementSize"):
            if (a.HasInfo(key) or b.HasInfo(key)) and a.GetInfo(key) != b.GetInfo(key):
                return False
        if list(a.connectionPathList.GetAddedOrExplicitItems()) != list(b.connectionPathList.GetAddedOrExplicitItems()):
            return False
        return True
    return list(a.targetPathList.GetAddedOrExplicitItems()) == list(b.targetPathList.GetAddedOrExplicitItems())


def slim(src, body_path, out):
    layer = load(src)
    base = Sdf.Layer.FindOrOpen(body_path)
    before = os.path.getsize(src)
    specs = list(walk(layer.GetPrimAtPath("/root")))
    had = {spec.path for spec in specs}
    props = {spec.path: {p.name for p in spec.properties} for spec in specs}
    for spec in specs:
        other = base.GetPrimAtPath(spec.path)
        if other is None:
            continue
        for prop in list(spec.properties):
            theirs = other.properties.get(prop.name)
            if theirs is not None and same_property(prop, theirs, layer, base):
                spec.RemoveProperty(prop)
        if spec.path == Sdf.Path("/root"):
            continue
        spec.specifier = Sdf.SpecifierOver
        if spec.typeName == other.typeName:
            spec.typeName = ""
        for key in ("apiSchemas", "kind", "active", "instanceable"):
            if spec.HasInfo(key) and other.HasInfo(key) and spec.GetInfo(key) == other.GetInfo(key):
                spec.ClearInfo(key)
    # Drop overs that no longer say anything, deepest first.
    for spec in reversed(specs):
        if spec.path == Sdf.Path("/root") or spec.specifier != Sdf.SpecifierOver:
            continue
        if spec.properties or spec.nameChildren or spec.typeName:
            continue
        if any(spec.HasInfo(k) for k in ("apiSchemas", "kind", "active", "instanceable", "references", "payload")):
            continue
        del spec.nameParent.nameChildren[spec.name]
    # Attributes the body has on a prim this model has, but the model does
    # not: block them so they read as unauthored, as in the original.
    for path in had:
        other = base.GetPrimAtPath(path)
        if other is None:
            continue
        for prop in other.properties:
            if prop.name in props[path] or not isinstance(prop, Sdf.AttributeSpec):
                continue
            owner = layer.GetPrimAtPath(path) or Sdf.CreatePrimInLayer(layer, path)
            if owner.specifier != Sdf.SpecifierDef and not owner.typeName:
                owner.specifier = Sdf.SpecifierOver
            attr = Sdf.AttributeSpec(owner, prop.name, prop.typeName, prop.variability)
            attr.default = Sdf.ValueBlock()
    # Prims the body has and this model never had (older exports carry a
    # slightly different material set): switch them off, topmost only.
    for spec in walk(base.GetPrimAtPath("/root")):
        if spec.path not in had and spec.path.GetParentPath() in had:
            off = Sdf.CreatePrimInLayer(layer, spec.path)
            off.specifier = Sdf.SpecifierOver
            off.active = False
    root = layer.GetPrimAtPath("/root")
    root.referenceList.Prepend(Sdf.Reference(BODY, "/root"))
    layer.Export(out)
    # Sanity: the composed stage must have the full rig back.
    st = Usd.Stage.Open(out)
    meshes = sum(1 for p in st.Traverse() if p.GetTypeName() == "Mesh" and RIG.pathString in p.GetPath().pathString)
    anims = sum(1 for p in st.Traverse() if p.GetTypeName() == "SkelAnimation")
    print(f"{os.path.basename(out):32s} {before / 1e6:5.1f} MB -> {os.path.getsize(out) / 1e6:4.2f} MB  (rig meshes {meshes}, animations {anims})")
    return meshes, anims


if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "body":
        body(sys.argv[2], sys.argv[3])
    elif cmd == "slim":
        slim(sys.argv[2], sys.argv[3], sys.argv[4] if len(sys.argv) > 4 else sys.argv[2])
    else:
        raise SystemExit(__doc__)
