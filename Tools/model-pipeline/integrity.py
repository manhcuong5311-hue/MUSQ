# Checks raw Blender exports before conversion (401-500 batch, 2026-10-04):
# up axis, frame range, skeletons and joint counts, animations, camera and
# light prims, and the top-level prims.
#   integrity.py <export.usdc> ...
import sys, os
from pxr import Usd, UsdGeom, UsdLux, UsdSkel
for f in sys.argv[1:]:
    st = Usd.Stage.Open(f)
    skels = [p for p in st.Traverse() if p.IsA(UsdSkel.Skeleton)]
    anims = [p for p in st.Traverse() if p.IsA(UsdSkel.Animation)]
    cams = [p for p in st.Traverse() if p.IsA(UsdGeom.Camera)]
    lights = [p for p in st.Traverse() if p.HasAPI(UsdLux.LightAPI)]
    sk = [f"{s.GetName()}:{len(UsdSkel.Skeleton(s).GetJointsAttr().Get() or [])}" for s in skels]
    rng = (st.GetStartTimeCode(), st.GetEndTimeCode(), st.GetTimeCodesPerSecond())
    print(os.path.basename(f)[:44].ljust(44), UsdGeom.GetStageUpAxis(st), rng, "skels", sk,
          "anims", len(anims), "cams", len(cams), "lights", len(lights))
