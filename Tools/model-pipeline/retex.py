# Female-model textures (2026-10-10): the female rig's skin, bra and shorts
# use three JPEG base colours. convert_all.py's Flatten() anchors their asset
# paths to the source folder, which the app does not have; this rewrites them
# to bare file names, which resolve next to the model in the app bundle (every
# resource sits side by side there, like Shared/AnatomyBody.usdc), and
# copies the JPEGs into Resources/Models/Shared under those names.
#   retex.py <model.usdc> ...
import os, sys, shutil
from pxr import Sdf
NAMES = {
    "athletic+shorts+3d+model_basecolor.jpg": "FemaleShorts_basecolor.jpg",
    "head+bust+3d+model_basecolor.jpg": "FemaleHead_basecolor.jpg",
    "head+bust+3d+model_basecolor.jpg.001.jpg": "FemaleHead_basecolor.jpg",
    "sports+bra+3d+model_basecolor.jpg": "FemaleBra_basecolor.jpg",
}
SHARED = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared"
for path in sys.argv[1:]:
    layer = Sdf.Layer.FindOrOpen(path); changed = 0
    def visit(p):
        global changed
        if not p.IsPropertyPath(): return
        spec = layer.GetAttributeAtPath(p)
        if spec is None or spec.typeName != Sdf.ValueTypeNames.Asset: return
        v = spec.default
        if not isinstance(v, Sdf.AssetPath) or not v.path: return
        base = os.path.basename(v.path)
        if base not in NAMES: return
        src = v.path
        dst = os.path.join(SHARED, NAMES[base])
        if os.path.isabs(src) and os.path.exists(src) and not os.path.exists(dst):
            shutil.copyfile(src, dst)
        spec.default = Sdf.AssetPath(NAMES[base]); changed += 1
    layer.Traverse("/", visit)
    layer.Save()
    print(f"{os.path.basename(path)}: {changed} texture paths")
