# Still times for batch 191-240's and the legs 300-350 faults (2026-09-26): the moment each fault
# is best seen at, from the families' notes (fault_moments: bottom / top /
# lockout / any), read off each clip by the kind of lift. Merges into
# bottoms.json as "Exercise" (the default still) and "Exercise|cue".
#   python3 fault_times.py <fault_moments.json>
import os as _os  # slim models reference Shared/AnatomyBody.usdc (share_body.py)
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/Shared")
import sys, json, glob, re, math
from pxr import Usd, UsdSkel, UsdGeom, Gf

S = open("/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Models/SampleData.swift").read()
block = S[S.index("modelByExercise: [String: ExerciseModel] = ["):S.index("static func model(for")]
RES = dict(re.findall(r'"([^"]+)":\s*ExerciseModel\(resource: "([^"]+)"', block))
M = "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/"


def kind(name):
    n = name.lower()
    if "lunge" in n or "split squat" in n or "thrust" in n: return "legs"   # bottom / top = pelvis lowest / highest
    if "carry" in n: return "carry"
    if "shrug" in n: return "shrug"
    if "rotation" in n: return "rotation"
    if "raise" in n: return "raise"
    if "curl" in n or "row" in n: return "pull"   # top = elbows most bent
    return "press"                                # top = elbows straightest


def ang(a, b, c):
    u = (a - b).GetNormalized(); v = (c - b).GetNormalized()
    return math.degrees(math.acos(max(-1, min(1, Gf.Dot(u, v)))))


def times(name):
    st = Usd.Stage.Open(glob.glob(M + "*/" + RES[name] + ".usdc")[0])
    t0, t1, fps = st.GetStartTimeCode(), st.GetEndTimeCode(), st.GetTimeCodesPerSecond()
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(next(p for p in st.Traverse() if p.GetTypeName() == "Skeleton")))
    J = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    rows = []
    t = t0
    while t <= min(t1, t0 + 4 * fps):   # the first rep, as bottoms.py does
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t))
        P = lambda j: w[J.index(j)].ExtractTranslation()
        elbow = min(ang(P("upper_arm_" + s), P("forearm_" + s), P("hand_" + s)) for s in "LR")
        hands = max(P("hand_L")[1], P("hand_R")[1])
        shoulders = P("upper_arm_L")[1] + P("upper_arm_R")[1] - 2 * P("pelvis")[1]
        turn = P("hand_L")[0] - P("forearm_L")[0]
        feet = (P("foot_L") - P("foot_R")).GetLength()
        rows.append(dict(t=round((t - t0) / fps, 2), elbow=elbow, hands=hands, shoulders=shoulders, turn=turn, feet=feet,
                         pelvis=P("pelvis")[1]))
        t += 2
    pick = lambda key, sign: max(rows, key=lambda r: sign * r[key])["t"]
    k = kind(name)
    named = {
        "press": dict(top=pick("elbow", 1), bottom=pick("elbow", -1)),
        "pull": dict(top=pick("elbow", -1), bottom=pick("elbow", 1)),
        "raise": dict(top=pick("hands", 1), bottom=pick("hands", -1)),
        "shrug": dict(top=pick("shoulders", 1), bottom=pick("shoulders", -1)),
        "rotation": dict(top=pick("turn", 1 if "external" in name.lower() else -1), bottom=pick("turn", -1 if "external" in name.lower() else 1)),
        "carry": dict(top=pick("feet", 1), bottom=pick("feet", 1)),
        "legs": dict(top=pick("pelvis", 1), bottom=pick("pelvis", -1)),
    }[k]
    named["lockout"] = pick("elbow", 1)
    named["any"] = named["bottom"] if k in ("press", "legs") else named["top"]
    return named


moments = json.load(open(sys.argv[1]))
out = json.load(open("bottoms.json")) if _os.path.exists("bottoms.json") else {}
for name, cues in moments.items():
    t = times(name)
    out[name] = t["any"]
    for cue, when in cues.items():
        word = re.split(r"[^a-z]", when.lower().strip())[0] or "any"
        out[f"{name}|{cue}"] = t.get(word, t["any"])
    print(f"{name:38s} {kind(name):8s} any {t['any']:.2f}  top {t['top']:.2f}  bottom {t['bottom']:.2f}  lockout {t['lockout']:.2f}")
json.dump(out, open("bottoms.json", "w"), indent=1)
