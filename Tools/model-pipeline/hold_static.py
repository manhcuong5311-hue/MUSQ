# Holds a static export's pose as an 8 s clip (2026-09-28).
# An export without animation carries the pose only as the skeleton's
# restTransforms and binds no SkelAnimation, while every other model plays a
# clip (the fault ghosts, thumbnail stills and cue times assume one). This
# writes the rest pose into the export's SkelAnimation as the same held sample
# at the first and last frame and binds it, so the model plays like the other
# holds did: 192 frames of stillness at 24 fps.
#   python3 hold_static.py <converted.usdc>...   (edits in place, before slimming)
import os, sys
from pxr import Usd, UsdSkel

END = 192.0


def hold(path):
    stage = Usd.Stage.Open(path)
    assert stage.GetStartTimeCode() == stage.GetEndTimeCode(), "already has a frame range"
    for prim in list(stage.Traverse()):
        if not prim.IsA(UsdSkel.Skeleton):
            continue
        skel = UsdSkel.Skeleton(prim)
        joints = skel.GetJointsAttr().Get()
        t, r, s = UsdSkel.DecomposeTransforms(skel.GetRestTransformsAttr().Get())
        anims = [c for c in prim.GetChildren() if c.IsA(UsdSkel.Animation)]
        anim = UsdSkel.Animation(anims[0]) if anims else UsdSkel.Animation.Define(stage, prim.GetPath().AppendChild("Anim"))
        anim.GetJointsAttr().Set(joints)
        anim.GetScalesAttr().Set(s)
        for frame in (1.0, END):
            anim.GetTranslationsAttr().Set(t, frame)
            anim.GetRotationsAttr().Set(r, frame)
        UsdSkel.BindingAPI.Apply(prim).CreateAnimationSourceRel().SetTargets([anim.GetPath()])
        print(f"{os.path.basename(path):32s} {prim.GetName()}: {len(joints)} joints held on {anim.GetPath().name}")
    stage.SetStartTimeCode(1.0)
    stage.SetEndTimeCode(END)
    stage.SetTimeCodesPerSecond(24.0)
    stage.GetRootLayer().Save()


if __name__ == "__main__":
    for path in sys.argv[1:]:
        hold(path)
