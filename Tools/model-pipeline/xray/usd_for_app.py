# Raw Blender USD export of the x-ray scapula demo -> app-ready usdc (same wrapper as Tools/model-pipeline/convert_all.py:
# Y-up via rotateX -90 on /root, metersPerUnit 1, lights + cameras switched off, flattened), then writes the frozen
# see-through opacity into each UsdPreviewSurface (Blender 5.1's USD exporter always writes opacity 1).
# Run with Blender's Python (pxr): python3.13 usd_for_app.py <raw.usdc> <materials.json> <out.usdc>
import sys, json
from pxr import Usd, UsdGeom, UsdLux, UsdSkel, UsdShade, Sdf, Gf
src, mj, out = sys.argv[1:4]
raw = Usd.Stage.Open(src)
start, end = raw.GetStartTimeCode(), raw.GetEndTimeCode()
lights = [p.GetPath() for p in raw.Traverse() if p.HasAPI(UsdLux.LightAPI)]
cameras = [p.GetPath() for p in raw.Traverse() if p.IsA(UsdGeom.Camera)]
stage = Usd.Stage.Open(Sdf.Layer.CreateAnonymous('.usda'))
UsdGeom.SetStageUpAxis(stage, UsdGeom.Tokens.y); UsdGeom.SetStageMetersPerUnit(stage, 1)
stage.SetStartTimeCode(start); stage.SetEndTimeCode(end); stage.SetTimeCodesPerSecond(raw.GetTimeCodesPerSecond())
root = UsdSkel.Root.Define(stage, '/root') if raw.GetPrimAtPath('/root').IsA(UsdSkel.Root) else UsdGeom.Xform.Define(stage, '/root')
stage.SetDefaultPrim(root.GetPrim())
root.GetPrim().GetReferences().AddReference(src, '/root')
root.AddRotateXOp().Set(-90)
# animated helper empties (camera orbit, light follow) would each become a clip of their own in RealityKit
helpers = [Sdf.Path(x) for x in ('/root/VIDEO_CameraOrbit', '/root/DARK_FollowPelvis') if raw.GetPrimAtPath(x)]
for path in lights + cameras + helpers:
    stage.OverridePrim(path).SetActive(False)
flat = stage.Flatten()
flat.Export(out)
st = Usd.Stage.Open(out); M = json.load(open(mj)); n = 0
for p in st.Traverse():
    if not p.IsA(UsdShade.Material) or p.GetName() not in M: continue
    v = M[p.GetName()]
    for c in p.GetChildren():
        sh = UsdShade.Shader(c)
        if sh and sh.GetIdAttr().Get() == 'UsdPreviewSurface':
            sh.CreateInput('opacity', Sdf.ValueTypeNames.Float).Set(float(v['alpha']))
            sh.CreateInput('diffuseColor', Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(*v['color']))
            n += 1
st.GetRootLayer().Save()
print('APP_USD', out, 'lights off', len(lights), 'cameras off', len(cameras), 'materials', n, 'time', start, end, raw.GetTimeCodesPerSecond())
