import sys, os
from pxr import Usd, UsdGeom, UsdLux
for f in sys.argv[1:]:
    st = Usd.Stage.Open(f)
    up = UsdGeom.GetStageUpAxis(st)
    lights = [p.GetName() for p in st.Traverse() if p.HasAPI(UsdLux.LightAPI)]
    cams = [p.GetName() for p in st.Traverse() if p.GetTypeName() == "Camera"]
    anims = [p for p in st.Traverse() if p.GetTypeName() == "SkelAnimation"]
    rng = None
    if anims:
        from pxr import UsdSkel
        ts = UsdSkel.Animation(anims[0]).GetRotationsAttr().GetTimeSamples()
        rng = (ts[0], ts[-1], len(ts), anims[0].GetName())
    cache = UsdGeom.BBoxCache(Usd.TimeCode(st.GetStartTimeCode()), [UsdGeom.Tokens.default_, UsdGeom.Tokens.render])
    props = []
    for c in st.GetPrimAtPath("/root").GetChildren():
        if not c.GetName().startswith("GYM"): continue
        r = cache.ComputeWorldBound(c).ComputeAlignedRange()
        m = r.GetMidpoint()
        parked = abs(m[0]) > 5 or abs(m[1]) > 5
        props.append(f"{c.GetName()}{'(P)' if parked else ''}")
    tex = set()
    for p in st.Traverse():
        for a in p.GetAttributes():
            if a.GetTypeName() == "asset":
                v = a.Get()
                if v: tex.add(str(v.path))
    print(f"== {os.path.basename(f)} up={up} fps={st.GetTimeCodesPerSecond()} stage=({st.GetStartTimeCode():.0f},{st.GetEndTimeCode():.0f}) anim={rng}")
    print(f"   lights={lights} cams={cams} tex={tex}")
    print(f"   props={props}")
