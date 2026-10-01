# Motion briefs for arm and upper-body lifts (1-50 redo, 2026-09-29): joint
# angles, hand positions and palm directions every 0.5 s, plus the moving
# equipment, so trainer copy can be written for what each model shows.
# Frame: the app's Y-up space, the lifter facing +z, their left +x, metres.
# The palm faces the hand joint's +Z axis (checked on the Dumbbell Curl's
# supinated start, palms forward, and the Reverse Curl's pronated one).
#   python3 brief_arms.py <out dir> "<Exercise>=<Group/Resource>" ...
import os as _os
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
import sys, math
import numpy as np
from pxr import Usd, UsdSkel, UsdGeom
M = _os.environ.get("MODELS", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/")  # MODELS=<dir>/ reads another copy

def ang(a, b, c):
    u, v = a - b, c - b
    return math.degrees(math.acos(np.clip(np.dot(u, v) / (np.linalg.norm(u) * np.linalg.norm(v)), -1, 1)))

def words(v):
    names = [("left", np.array([1, 0, 0])), ("right", np.array([-1, 0, 0])), ("up", np.array([0, 1, 0])),
             ("down", np.array([0, -1, 0])), ("forward", np.array([0, 0, 1])), ("back", np.array([0, 0, -1]))]
    parts = sorted(((float(np.dot(v, d)), n) for n, d in names), reverse=True)
    return " ".join(f"{n}" for s, n in parts[:2] if s > 0.35) or "mixed"

def brief(name, res, out):
    st = Usd.Stage.Open(M + res + ".usdc")
    t0, t1, fps = st.GetStartTimeCode(), st.GetEndTimeCode(), st.GetTimeCodesPerSecond()
    sk = next(p for p in sorted(st.Traverse(), key=lambda q: "Anatomy_MasterRig" not in q.GetPath().pathString) if p.GetTypeName() == "Skeleton")
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk))
    names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    ix = {n: i for i, n in enumerate(names)}
    moving = {}
    root = st.GetPrimAtPath("/root")
    equip = [c for c in root.GetChildren() if c.IsActive() and c.GetName() not in ("Anatomy_MasterRig", "_materials", "DARK_Floor")
             and any(p.GetTypeName() == "Mesh" for p in Usd.PrimRange(c))]
    def ecentre(c, t):
        cache = UsdGeom.BBoxCache(Usd.TimeCode(t), [UsdGeom.Tokens.default_, UsdGeom.Tokens.render])
        r = cache.ComputeWorldBound(c).ComputeAlignedRange()
        return np.array(r.GetMidpoint()), np.array(r.GetSize())
    for c in equip:
        a, _ = ecentre(c, t0); b, _ = ecentre(c, t0 + (t1 - t0) * 0.37)
        cs = [ecentre(c, t0 + (t1 - t0) * k / 8)[0] for k in range(9)]
        if max(np.linalg.norm(x - cs[0]) for x in cs) > 0.02: moving[c.GetName()] = c
    lines = [f"# {name}", f"Model: {res}; clip {(t1 - t0) / fps:.2f} s at {fps:.0f} fps.",
             "Frame: Y up, the lifter faces +z, their left is +x; metres. Angles: elbow = upper arm-forearm inner angle (180 straight);"
             " shoulder flex = upper arm forward of the trunk's down line in the sagittal plane (+ forward/up, 180 overhead), abd = out to the side;"
             " wrist = hand bent toward the palm (+ flexion) or the back of the hand (- extension); palm = the way the palm faces;"
             " trunk lean = neck-over-pelvis from vertical (+ forward); knee/hip = inner angles (180 straight).",
             "Equipment (active): " + ", ".join(c.GetName() for c in equip) + "; moving: " + (", ".join(moving) or "none")]
    rows, el = [], []
    times = np.arange(0, (t1 - t0) / fps + 1e-6, 0.5)
    fine = np.arange(0, (t1 - t0) / fps + 1e-6, 1 / 12)
    def pose(ts):
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t0 + ts * fps))
        P = lambda j: np.array(w[ix[j]].ExtractTranslation())
        R = lambda j: np.array(w[ix[j]].ExtractRotationMatrix())
        return P, R
    for ts in fine:
        P, R = pose(ts)
        el.append((ts, (ang(P("upper_arm_L"), P("forearm_L"), P("hand_L")) + ang(P("upper_arm_R"), P("forearm_R"), P("hand_R"))) / 2,
                   ang(P("upper_arm_L"), P("forearm_L"), P("hand_L")), ang(P("upper_arm_R"), P("forearm_R"), P("hand_R"))))
    e = np.array([x[1] for x in el])
    lines.append(f"Elbows (mean of both): most bent {e.min():.0f}° at {fine[e.argmin()]:.2f} s, straightest {e.max():.0f}° at {fine[e.argmax()]:.2f} s."
                 f" Left {min(x[2] for x in el):.0f}-{max(x[2] for x in el):.0f}°, right {min(x[3] for x in el):.0f}-{max(x[3] for x in el):.0f}°.")
    thr = (e.min() + e.max()) / 2
    phases, cur, start = [], None, 0.0
    for (ts, m, _, _) in el:
        s = "bent" if m < thr else "straight"
        if s != cur:
            if cur: phases.append(f"{cur} {start:.2f}-{ts:.2f}s")
            cur, start = s, ts
    phases.append(f"{cur} {start:.2f}-{fine[-1]:.2f}s")
    lines.append("Elbow phases (split at the mid angle): " + ", ".join(phases))
    for ts in times:
        P, R = pose(ts)
        down = P("pelvis") - P("neck"); down /= np.linalg.norm(down)
        up = -down
        trunk = P("neck") - P("pelvis")
        lean = math.degrees(math.atan2(trunk[2], trunk[1]))
        side = math.degrees(math.atan2(trunk[0], trunk[1]))
        lines.append(f"t={ts:.2f}s pelvis {np.round(P('pelvis'), 2).tolist()} trunk lean {lean:+.0f}° (sideways {side:+.0f}°, + to the left)")
        across = P("thigh_L") - P("thigh_R"); across -= np.dot(across, up) * up; across /= np.linalg.norm(across)
        fwd = np.cross(across, up)
        for s in "LR":
            sh, elb, wr = P(f"upper_arm_{s}"), P(f"forearm_{s}"), P(f"hand_{s}")
            ua = (elb - sh) / np.linalg.norm(elb - sh)
            flex = math.degrees(math.atan2(np.dot(ua, fwd), np.dot(ua, down)))
            abd = math.degrees(math.asin(np.clip(np.dot(ua, across) * (1 if s == "L" else -1), -1, 1)))
            Rf, Rh = R(f"forearm_{s}"), R(f"hand_{s}")
            wrist = math.degrees(math.atan2(np.dot(Rh[1], Rf[2]), np.dot(Rh[1], Rf[1])))
            palm = Rh[2] / np.linalg.norm(Rh[2])
            lines.append(f"  {s}: elbow {ang(sh, elb, wr):.0f}° shoulder flex {flex:+.0f}° abd {abd:+.0f}° wrist {wrist:+.0f}° palm {words(palm)} {np.round(palm, 2).tolist()}"
                         f" | hand {np.round(wr, 2).tolist()} (vs shoulder {np.round(wr - sh, 2).tolist()}) elbow {np.round(elb, 2).tolist()}")
        lines.append(f"  legs: knee L {ang(P('thigh_L'), P('shin_L'), P('foot_L')):.0f}° R {ang(P('thigh_R'), P('shin_R'), P('foot_R')):.0f}°,"
                     f" hip L {ang(P('neck'), P('thigh_L'), P('shin_L')):.0f}° R {ang(P('neck'), P('thigh_R'), P('shin_R')):.0f}°,"
                     f" ankles L {np.round(P('foot_L'), 2).tolist()} R {np.round(P('foot_R'), 2).tolist()}")
        for n, c in moving.items():
            ctr, size = ecentre(c, t0 + ts * fps)
            lines.append(f"  {n} centre {np.round(ctr, 2).tolist()} size {np.round(size, 2).tolist()}")
    slug = res.split("/")[-1]
    open(os.path.join(out, slug + ".md"), "w").write("\n".join(lines) + "\n")
    print("wrote", slug)

import os
out = sys.argv[1]
for arg in sys.argv[2:]:
    n, r = arg.split("=")
    brief(n, r, out)
