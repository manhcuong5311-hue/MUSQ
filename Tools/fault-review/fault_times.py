# Still times for batch 191-240's, the legs 300-350, batch 241-300 and the 30-leg set's faults: the moment each fault
# is best seen at, from the families' notes (fault_moments: bottom / top /
# lockout / any), read off each clip by the kind of lift. Merges into
# bottoms.json as "Exercise" (the default still) and "Exercise|cue".
#   python3 fault_times.py <fault_moments.json>
import os as _os  # slim models reference Shared/AnatomyBody.usdc (share_body.py)
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
import sys, json, glob, re, math
from pxr import Usd, UsdSkel, UsdGeom, Gf

S = open("/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Models/SampleData.swift").read()
block = S[S.index("modelByExercise: [String: ExerciseModel] = ["):S.index("static func model(for")]
RES = dict(re.findall(r'"([^"]+)":\s*ExerciseModel\(resource: "([^"]+)"', block))
M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"


def kind(name):
    n = name.lower()
    # The 351-400 set (2026-09-30): hip hinges, knee-flexion curls and hip
    # abduction/adduction, tested before the words they share with others
    # ("curl", "raise", "pump").
    if "romanian" in n or "deadlift" in n or "good morning" in n: return "hinge"   # bottom / top = trunk most / least tipped forward
    if "leg curl" in n or "nordic" in n or "sliding curl" in n or "glute-ham" in n: return "legcurl"   # top / bottom = knee most / least bent
    if "abduction" in n or "clamshell" in n: return "abduction"   # top / bottom = knees furthest / closest apart
    if "adduction" in n: return "adduction"       # top / bottom = knees closest / furthest apart
    if "frog pump" in n: return "legs"             # a bridge: top / bottom = pelvis highest / lowest
    if "calf raise" in n or "calf press" in n or "plantar flexion" in n: return "calf"   # top / bottom = heels highest / lowest (ankle angle)
    if "tibialis raise" in n or "dorsiflexion" in n: return "tibialis"   # top / bottom = toes highest / lowest (ankle angle)
    # 401-500 core work (2026-10-04): trunk-to-thigh angle for the crunches,
    # sit-ups and V-ups; the dead bug, bird dog and hollow body give seconds.
    if "crunch" in n or "sit-up" in n or "v-up" in n: return "curlup"   # top / bottom = trunk and thighs closest / furthest
    if "dead bug" in n or "bird dog" in n or "hollow body" in n: return "hold"
    # 445-474 (2026-10-05): leg and knee raises fold like the crunches; the
    # kicks, planks, climbers, side bends, twists, chops, rotations and
    # rollouts give their moments in seconds; thrusters and the clean and
    # press read off the pelvis like the squats (top = lockout).
    if "toe-to-bar" in n or "leg raise" in n or "knee raise" in n: return "curlup"
    if any(w in n for w in ("kick", "plank", "mountain climber", "side bend", "twist", "wood chop",
                            "cable rotation", "landmine", "rollout", "body saw")): return "hold"
    if "thruster" in n or "clean and press" in n: return "legs"
    if "bear crawl" in n or "march" in n: return "carry"
    if "leg press" in n: return "legpress"        # bottom / top = knees most bent / straightest (the pelvis stays put)
    if "lunge" in n or "squat" in n or "thrust" in n: return "legs"   # bottom / top = pelvis lowest / highest
    # Desktop "1-100" folder (2026-10-10): step-ups bottom out with the pelvis
    # lowest (one foot on the box) and top out standing on it.
    if "step-up" in n: return "legs"
    if "carry" in n or "walk on toes" in n: return "carry"
    if "hold" in n: return "hold"                 # static grip holds: every moment is the same
    if "wrist roller" in n: return "hold"         # 401-500 (2026-10-04): the roller winds all clip; moments are given in seconds
    if "wrist curl" in n: return "wrist"          # top = the wrist at the end of its working range
    if "finger curl" in n: return "finger"        # top = fingers closed, wrist curled; bottom = bar on the fingertips
    if "shrug" in n: return "shrug"
    if "rotation" in n: return "rotation"
    if "raise" in n: return "raise"
    if "curl" in n or "row" in n or "21s" in n: return "pull"   # top = elbows most bent
    return "press"                                # top = elbows straightest


def ang(a, b, c):
    u = (a - b).GetNormalized(); v = (c - b).GetNormalized()
    return math.degrees(math.acos(max(-1, min(1, Gf.Dot(u, v)))))


def times(name):
    st = Usd.Stage.Open(glob.glob(M + "*/" + RES[name] + ".usdc")[0])
    t0, t1, fps = st.GetStartTimeCode(), st.GetEndTimeCode(), st.GetTimeCodesPerSecond()
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(next(p for p in sorted(st.Traverse(), key=lambda q: "Anatomy_MasterRig" not in q.GetPath().pathString) if p.GetTypeName() == "Skeleton")))
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
        flex = 0.0
        if kind(name) in ("wrist", "finger"):
            # Wrist bend, + toward the palm: the hand's +z is the palm on both sides (batch 241-300 rigs).
            fd = (P("hand_L") - P("forearm_L")).GetNormalized(); hd = (P("MCH_finger_middle_01_L") - P("hand_L")).GetNormalized()
            palm = Gf.Vec3d(*[w[J.index("hand_L")][2][i] for i in range(3)])
            flex = math.degrees(math.acos(max(-1, min(1, Gf.Dot(fd, hd))))) * (-1 if Gf.Dot(fd, palm) > 0 else 1)
        kneeL, kneeR = (ang(P("thigh_" + s), P("shin_" + s), P("foot_" + s)) for s in "LR")
        # Shin-to-foot angle of the left (working) leg: larger as the heel rises.
        fy = Gf.Vec3d(*[w[J.index("foot_L")][1][i] for i in range(3)])
        ankle = math.degrees(math.acos(max(-1, min(1, Gf.Dot((P("shin_L") - P("foot_L")).GetNormalized(), fy.GetNormalized())))))
        # Trunk tip (0 upright, 90 level) and the knees' spread, for the 351-400 kinds.
        trunk = P("neck") - P("pelvis")
        tip = math.degrees(math.acos(max(-1, min(1, trunk[1] / trunk.GetLength()))))
        spread = (P("shin_L") - P("shin_R")).GetLength()
        # Trunk-to-thigh angle (both thighs' mean), small when curled up.
        thighs = (P("shin_L") + P("shin_R")) / 2 - P("pelvis")
        fold = math.degrees(math.acos(max(-1, min(1, Gf.Dot(trunk.GetNormalized(), thighs.GetNormalized())))))
        rows.append(dict(t=round((t - t0) / fps, 2), elbow=elbow, hands=hands, shoulders=shoulders, turn=turn, feet=feet,
                         pelvis=P("pelvis")[1], flex=flex, kneeL=kneeL, kneeR=kneeR, ankle=ankle, tip=tip, spread=spread,
                         fold=fold))
        t += 2
    # The working knee: the one that bends and straightens (the Single-Leg
    # Press rests its other foot with the knee held at ~82 degrees).
    side = "kneeL" if max(r["kneeL"] for r in rows) - min(r["kneeL"] for r in rows) >= max(r["kneeR"] for r in rows) - min(r["kneeR"] for r in rows) else "kneeR"
    for r in rows: r["knee"] = r[side]
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
        "legpress": dict(top=pick("knee", 1), bottom=pick("knee", -1)),
        "calf": dict(top=pick("ankle", 1), bottom=pick("ankle", -1)),
        "tibialis": dict(top=pick("ankle", -1), bottom=pick("ankle", 1)),
        "curlup": dict(top=pick("fold", -1), bottom=pick("fold", 1)),
        "wrist": dict(top=pick("flex", -1 if "reverse" in name.lower() else 1), bottom=pick("flex", 1 if "reverse" in name.lower() else -1)),
        "finger": dict(top=pick("flex", 1), bottom=pick("flex", -1)),
        "hold": dict(top=2.0, bottom=2.0),
        "hinge": dict(top=pick("tip", -1), bottom=pick("tip", 1)),
        "legcurl": dict(top=pick("knee", -1), bottom=pick("knee", 1)),
        "abduction": dict(top=pick("spread", 1), bottom=pick("spread", -1)),
        "adduction": dict(top=pick("spread", -1), bottom=pick("spread", 1)),
    }[k]
    # A leg lift's lockout is its top (knees and hips straight), not the elbows.
    named["lockout"] = named["top"] if k in ("legs", "legpress", "calf", "tibialis", "curlup", "hinge", "legcurl", "abduction", "adduction") else pick("elbow", 1)
    named["any"] = named["bottom"] if k in ("press", "legs", "legpress", "finger", "hinge") else named["top"]
    return named


moments = json.load(open(sys.argv[1]))
out = json.load(open("bottoms.json")) if _os.path.exists("bottoms.json") else {}
for name, cues in moments.items():
    t = times(name)
    out[name] = t["any"]
    for cue, when in cues.items():
        # A moment may also be given in seconds ("12.5" or "t=12.5"), for
        # clips whose first rep is not the one to show (the 21s' top-half
        # and full reps, the wrist roller) (401-500, 2026-10-04).
        num = re.fullmatch(r"(?:t\s*=\s*)?(\d+(?:\.\d+)?)\s*s?", when.lower().strip())
        if num:
            out[f"{name}|{cue}"] = float(num.group(1)); continue
        word = re.split(r"[^a-z]", when.lower().strip())[0] or "any"
        out[f"{name}|{cue}"] = t.get(word, t["any"])
    print(f"{name:38s} {kind(name):8s} any {t['any']:.2f}  top {t['top']:.2f}  bottom {t['bottom']:.2f}  lockout {t['lockout']:.2f}")
json.dump(out, open("bottoms.json", "w"), indent=1)
