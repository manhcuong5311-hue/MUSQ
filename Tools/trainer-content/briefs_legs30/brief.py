# Leg-motion summary for the 30-leg set (2026-09-28): what each converted model
# actually does, in the app's Y-up frame (lifter faces +z, left = +x).
import os, sys, json, math, numpy as np
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
from pxr import Usd, UsdSkel, UsdGeom
M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"
F = json.load(open(sys.argv[1])); OUT = sys.argv[2]
def ang(a, b):
    a, b = np.asarray(a, float), np.asarray(b, float)
    return math.degrees(math.acos(max(-1, min(1, a.dot(b) / (np.linalg.norm(a) * np.linalg.norm(b) + 1e-12)))))
def r(v, n=2): return [round(float(x), n) for x in v]
for name, fr in F.items():
    st = Usd.Stage.Open(M + fr["res"] + ".usdc"); tps = st.GetTimeCodesPerSecond()
    t0, t1 = int(st.GetStartTimeCode()), int(st.GetEndTimeCode())
    sk = next(p for p in sorted(st.Traverse(), key=lambda q: "Anatomy_MasterRig" not in q.GetPath().pathString) if p.IsA(UsdSkel.Skeleton))
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk)); names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    idx = {n: i for i, n in enumerate(names)}
    root = st.GetPrimAtPath("/root")
    equip = [c for c in root.GetChildren() if c.IsActive() and c.GetName() not in ("Anatomy_MasterRig", "DARK_Floor", "_materials")
             and any(p.GetTypeName() == "Mesh" for p in Usd.PrimRange(c))]
    moving = [c for c in equip if any(a.GetNumTimeSamples() > 1 for p in Usd.PrimRange(c) for a in p.GetAttributes() if a.GetName().startswith("xformOp"))]
    def pose(f):
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(f))
        P = {j: np.array(w[i].ExtractTranslation()) for j, i in idx.items()}
        R = {j: np.array(w[i].ExtractRotationMatrix()) for j, i in idx.items()}
        return P, R
    series = []
    for f in range(t0, t1 + 1):
        P, _ = pose(f); series.append((f, P["pelvis"].copy()))
    py = np.array([p[1] for _, p in series])
    # rep phases from pelvis height (or knee angle for seated presses)
    seated = np.ptp(py) < 0.02
    calf = "Calf" in name
    def ankle_angle(P, R, sd="L"):
        shin_up = P[f"shin_{sd}"] - P[f"foot_{sd}"]
        return ang(shin_up, R[f"foot_{sd}"][1])
    if calf:
        aa = []
        for f in range(t0, t1 + 1):
            P, R = pose(f); aa.append(ankle_angle(P, R))
        sig = np.array(aa)  # smallest = heels lowest (the stretch) = bottom
    elif seated:
        ks = []
        for f in range(t0, t1 + 1):
            P, _ = pose(f); ks.append(ang(P["thigh_L"] - P["shin_L"], P["foot_L"] - P["shin_L"]))
        sig = np.array(ks)  # knee most bent = bottom of the press
    else:
        sig = py
    lo, hi = sig.min(), sig.max(); band = 0.03 * (hi - lo)
    lab = np.where(sig <= lo + band, "B", np.where(sig >= hi - band, "T", "m"))
    runs = []; cur = lab[0]; start = 0
    for i, c in enumerate(lab):
        if c != cur: runs.append((cur, start, i - 1)); cur, start = c, i
    runs.append((cur, start, len(lab) - 1))
    phases = ", ".join(f"{'top' if c=='T' else 'bottom' if c=='B' else 'moving'} {s/tps:.2f}-{e/tps:.2f}s" for c, s, e in runs)
    lines = [f"# {name}", f"Model: {fr['res']} (framing yaw {fr['yaw']}, zoom {fr['zoom']}, offset {fr['off']}); clip {(t1-t0)/tps:.2f} s at {tps:.0f} fps.",
             "Frame: Y up, the lifter faces +z, their left is +x; metres. Angles: knee = thigh-shin inner angle (180 straight); hip = trunk-thigh inner angle (180 standing); trunk lean = neck-over-pelvis line from vertical (+ forward); thigh = below horizontal (+) at the knee; shin = forward of vertical (+).",
             f"Rep phases ({'ankle angle' if calf else 'knee angle' if seated else 'pelvis height'}): {phases}. Deepest point at {float(np.argmin(sig))/tps:.2f} s" + (f"; heels highest at {float(np.argmax(sig))/tps:.2f} s." if calf else "."),
             "Ankle = shin-to-foot angle (about 90-100 standing flat; larger = heel raised / plantar flexed); foot pitch = the foot bone (ankle joint to the ball of the foot) below horizontal: it already points down some 15-25 degrees with the foot flat, and grows as the heel rises.",
             "Equipment (active): " + (", ".join(c.GetName() for c in equip[:12]) + (f" (+{len(equip)-12} more)" if len(equip) > 12 else "") if equip else "none") + "; moving: " + (", ".join(c.GetName() for c in moving) or "none")]
    times = sorted(set([round(x, 2) for x in np.arange(0, (t1 - t0) / tps + 1e-6, 0.5)] + [round(float(np.argmin(sig)) / tps, 2)]))
    for t in times:
        f = t0 + int(round(t * tps)); P, R = pose(f)
        trunk = P["neck"] - P["pelvis"]
        lean = math.degrees(math.atan2(trunk[2], trunk[1]))
        side_lean = math.degrees(math.atan2(trunk[0], trunk[1]))
        row = [f"t={t:.2f}s pelvis {r(P['pelvis'])} trunk lean {lean:+.0f}° (sideways {side_lean:+.0f}°, + to the left)"]
        for s in "LR":
            hip, knee, ank = P[f"thigh_{s}"], P[f"shin_{s}"], P[f"foot_{s}"]
            th = knee - hip; sh = ank - knee
            kn = ang(hip - knee, ank - knee); hp = ang(trunk, th)
            thigh_dn = math.degrees(math.atan2(-th[1], math.hypot(th[0], th[2])))
            shin_fw = math.degrees(math.atan2(-sh[2], -sh[1])) if not seated else float("nan")
            fdir = R[f"foot_{s}"][1][[0, 2]] if R[f"foot_{s}"].shape == (3, 3) else None
            toe = math.degrees(math.atan2(fdir[0], fdir[1])) if fdir is not None else float("nan")
            fy = R[f"foot_{s}"][1]
            pitch = math.degrees(math.atan2(-fy[1], math.hypot(fy[0], fy[2])))
            tail = f" | ankle {ankle_angle(P, R, s):.0f}° foot pitch {pitch:+.0f}°"
            tail += f" | foot dir {toe:+.0f}° from +z (toe-out + = outward for L)" if not seated else ""
            row.append(f"  {s}: knee {kn:.0f}° hip {hp:.0f}° thigh {thigh_dn:+.0f}° shin {shin_fw:+.0f}° | ankle {r(ank)} | knee-over-ankle dx {knee[0]-ank[0]:+.2f} dz {knee[2]-ank[2]:+.2f}{tail}")
        for s in "LR":
            row.append(f"  hand_{s} {r(P[f'hand_{s}'])} (vs shoulder {r(P[f'hand_{s}']-P[f'upper_arm_{s}'])}), elbow {ang(P[f'upper_arm_{s}']-P[f'forearm_{s}'], P[f'hand_{s}']-P[f'forearm_{s}']):.0f}°")
        for c in moving[:3]:
            rg = UsdGeom.BBoxCache(Usd.TimeCode(f), ["default", "render"]).ComputeWorldBound(c).ComputeAlignedRange()
            if not rg.IsEmpty():
                mid = np.array(rg.GetMidpoint()); row.append(f"  {c.GetName()} centre {r(mid)} (vs neck {r(mid - P['neck'])}), size {r(rg.GetSize())}")
        lines += row
    static = []
    for c in equip:
        if c in moving: continue
        rg = UsdGeom.BBoxCache(Usd.TimeCode(t0), ["default", "render"]).ComputeWorldBound(c).ComputeAlignedRange()
        if not rg.IsEmpty() and max(rg.GetSize()) > 0.15:
            static.append(f"{c.GetName()} min {r(rg.GetMin())} max {r(rg.GetMax())}")
    if static: lines += ["Static equipment bounds (largest parts):"] + ["  " + s for s in static[:14]]
    slug = fr["res"].split("/")[-1]
    open(os.path.join(OUT, slug + ".md"), "w").write("\n".join(lines) + "\n")
    print(name, "->", slug, len(lines), "lines")
