import re, glob, json
from pxr import Usd, UsdSkel, UsdGeom
SRC = open("/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Models/SampleData.swift").read()
M = "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/"
block = SRC[SRC.index("modelByExercise: [String: ExerciseModel] = ["):SRC.index("static func model(for")]
import sys
ONLY = sys.argv[1:]
out = json.load(open("posetimes.json"))
for name, res in re.findall(r'"([^"]+)":\s*ExerciseModel\(resource: "([^"]+)"', block):
    if ONLY and name not in ONLY: continue
    st = Usd.Stage.Open(glob.glob(M + "*/" + res + ".usdc")[0])
    t0, t1, fps = st.GetStartTimeCode(), st.GetEndTimeCode(), st.GetTimeCodesPerSecond()
    sk = next(p for p in st.Traverse() if p.GetTypeName() == "Skeleton")
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk))
    names = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    js = [names.index(j) for j in ("hand_L","hand_R","foot_L","foot_R","head","pelvis","patella_L","patella_R","forearm_L","forearm_R")]
    def pose(t):
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t)); return [w[i].ExtractTranslation() for i in js]
    base = pose(t0); best = (0, t0)
    t = t0
    while t <= t1:
        d = sum((a - b).GetLength() for a, b in zip(pose(t), base))
        if d > best[0] + 1e-6: best = (d, t)
        t += 4
    out[name] = dict(time=round((best[1] - t0) / fps, 2), disp=round(best[0], 2), length=round((t1 - t0) / fps, 2))
    print(f"{name:36s} t={out[name]['time']:5.2f}s of {out[name]['length']}s  disp={best[0]:.2f}", flush=True)
json.dump(out, open("posetimes.json", "w"), indent=1)
