# The female hack-squat exports (2026-10-10) name their rig
# /root/Anatomy_MasterRig_001 (its skeleton _001 too), where every other model
# and the tools (share_body.py, tiers.py, the app's joint tracking) expect
# /root/Anatomy_MasterRig. This renames the rig prim in a converted model and
# re-points every relationship target and attribute connection under it.
#   rename_rig.py <model.usdc> ...
import sys
from pxr import Sdf
OLD, NEW = Sdf.Path("/root/Anatomy_MasterRig_001"), Sdf.Path("/root/Anatomy_MasterRig")
for path in sys.argv[1:]:
    layer = Sdf.Layer.FindOrOpen(path)
    # The user's exports also carry the old rig as an empty, inactive over at
    # the new path; it goes first.
    stale = layer.GetPrimAtPath(NEW)
    if stale and layer.GetPrimAtPath(OLD) and stale.specifier == Sdf.SpecifierOver and not stale.nameChildren:
        del stale.nameParent.nameChildren[stale.name]
    if not layer.GetPrimAtPath(OLD) or layer.GetPrimAtPath(NEW):
        print(f"{path}: nothing to rename"); continue
    edit = Sdf.BatchNamespaceEdit(); edit.Add(OLD, NEW)
    assert layer.Apply(edit), path
    fixed = 0
    def fix(p):
        global fixed
        if not p.IsPropertyPath(): return
        spec = layer.GetPropertyAtPath(p)
        lists = []
        if isinstance(spec, Sdf.RelationshipSpec): lists.append(spec.targetPathList)
        elif isinstance(spec, Sdf.AttributeSpec): lists.append(spec.connectionPathList)
        for lst in lists:
            items = list(lst.explicitItems) if lst.isExplicit else list(lst.prependedItems) + list(lst.appendedItems) + list(lst.addedItems)
            if not any(i.HasPrefix(OLD) for i in items): continue
            new = [i.ReplacePrefix(OLD, NEW) for i in items]
            lst.ClearEditsAndMakeExplicit(); 
            for i in new: lst.explicitItems.append(i)
            fixed += 1
    layer.Traverse("/", fix)
    layer.Save()
    print(f"{path}: rig renamed, {fixed} target lists re-pointed")
