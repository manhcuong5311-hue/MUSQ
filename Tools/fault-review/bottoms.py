# Seconds into each clip where the rep bottoms out, so fault stills show the
# moment most faults are about. Run with Blender's Python:
#   python3 bottoms.py "Barbell Bench Press" "Push-Up" ...   -> bottoms.json
import os as _os  # slim models reference Shared/AnatomyBody.usdc (share_body.py)
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/Shared")
import json, math, glob, re
from pxr import Usd, UsdSkel, UsdGeom, Gf
S = open("/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Models/SampleData.swift").read()
block = S[S.index("modelByExercise: [String: ExerciseModel] = ["):S.index("static func model(for")]
res = dict(re.findall(r'"([^"]+)":\s*ExerciseModel\(resource: "([^"]+)"', block))
M = "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/"
# Flys hold the elbows nearly fixed, so their bottom is where the hands are
# furthest apart; everything else bottoms out where the elbow bends most.
# Extend with a knee rule when lower-body faults are authored.
FLY = {"Dumbbell Fly", "Incline Dumbbell Fly", "Pec Deck Fly", "Cable Fly", "Low-to-High Cable Fly",
       "Reverse Dumbbell Fly", "Reverse Pec Deck", "Cable Rear Delt Fly",
       "High-to-Low Cable Fly", "Single-Arm Cable Fly", "Incline Cable Fly", "Decline Cable Fly",
       "Cable Crossover"}
# Pullovers hold the elbows fixed too; their bottom is the overhead stretch,
# with the hands furthest from the pelvis.
PULLOVER = {"Dumbbell Pullover", "Barbell Pullover", "Dumbbell Pullover Row", "Machine Pullover"}
# Pulls from the floor bottom out with the knees most bent, the straight-arm
# pulldown starts with the hands highest, and the back extension's faults
# read at the top, with the trunk most upright.
KNEE = {"Deadlift", "Sumo Deadlift", "Trap Bar Deadlift", "Snatch-Grip Deadlift", "Deficit Deadlift",
        "Rack Pull", "Block Pull"}
HANDS_HIGH = {"Straight-Arm Pulldown", "Dumbbell Lateral Raise", "Cable Lateral Raise", "Machine Lateral Raise",
              "Dumbbell Front Raise",
              # Batch 191-240 raises (2026-09-26).
              "Leaning Lateral Raise", "Incline Lateral Raise", "Chest-Supported Lateral Raise", "Y-Raise",
              "Cable Y-Raise", "Lu Raise", "Plate Front Raise", "Barbell Front Raise", "Cable Front Raise",
              "Alternating Dumbbell Front Raise", "Powell Raise"}
# Shrugs read at the top, with the shoulders highest over the hips; the cable
# rotations at the end of the turn, the forearm furthest out (external) or
# across the body (internal); carries mid-stride (FEET_APART).
SHRUG = {"Dumbbell Shrug", "Barbell Shrug", "Smith Machine Shrug", "Cable Shrug", "Trap Bar Shrug",
         "Behind-the-Back Barbell Shrug"}
TURN_OUT = {"Cable External Rotation"}
TURN_IN = {"Cable Internal Rotation"}
UPRIGHT = {"Back Extension"}
# Legs: squats, lunges, step-ups and curls at the most bent knee (either
# side); the leg extension at the straightest; hinges with the trunk most
# level; bridges with the hips highest; kicks and abductions with the feet,
# or on the machines the knees, furthest apart.
LEG_KNEE = {"Squat", "Back Squat", "Front Squat", "Goblet Squat", "Hack Squat",
            "Smith Machine Squat", "Sissy Squat", "Leg Press",
            "Lying Leg Curl", "Seated Leg Curl", "Single-Leg Curl"}
# Scans the first four seconds, the first rep of every clip.
# Split stances bend the rear knee furthest, so they bottom out with the
# hips lowest instead; the step-up with the hips lowest is its start.
HIPS_LOW = {"Lunge", "Lunge (Lean)", "Bulgarian Split Squat", "Bulgarian Split Squat (Lean)",
            "Walking Lunge", "Reverse Lunge", "Step-Up"}
LEG_STRAIGHT = {"Leg Extension"}
HINGE = {"Romanian Deadlift", "Dumbbell Romanian Deadlift", "Stiff-Leg Deadlift"}
HIPS_HIGH = {"Glute Bridge", "Single-Leg Glute Bridge"}
FEET_APART = {"Cable Glute Kickback", "Cable Side Kick", "Cable Hip Abduction",
              "Farmer's Carry", "Suitcase Carry", "Overhead Carry"}
KNEES_APART = {"Hip Abduction Machine", "Hip Abduction Machine (Lean)"}
# Faults of the other end of the rep, stored as "Exercise|cue".
AT_TOP = {("Leg Press", "lockout"), ("Hack Squat", "lockout"), ("Step-Up", "hips"),
          ("Seated Leg Curl", "curl"),
          ("Rack Pull", "lockout"), ("Block Pull", "lockout"), ("Trap Bar Deadlift", "lockout")}
# Faults of a press's lockout, with the elbows straightest.
AT_LOCKOUT = {("Barbell Overhead Press", "barpath"), ("Barbell Overhead Press", "head"),
              ("Arnold Press", "finish"), ("Dumbbell Shoulder Press", "path"),
              ("Triceps Pushdown", "lockout"), ("Rope Pushdown", "split"), ("Single-Arm Cable Pushdown", "lockout"),
              ("Skull Crusher", "upperarm"), ("Assisted Dip", "lockout"), ("Barbell Curl", "range"),
              ("Single-Arm Landmine Press", "barpath")}
def ang(a, b, c):
    u = (a - b).GetNormalized(); v = (c - b).GetNormalized()
    return math.degrees(math.acos(max(-1, min(1, Gf.Dot(u, v)))))
import sys
names = sys.argv[1:]
out = {}
for n in names:
    st = Usd.Stage.Open(glob.glob(M + "*/" + res[n] + ".usdc")[0])
    t0, t1, fps = st.GetStartTimeCode(), st.GetEndTimeCode(), st.GetTimeCodesPerSecond()
    sk = next(p for p in st.Traverse() if p.GetTypeName() == "Skeleton")
    q = UsdSkel.Cache().GetSkelQuery(UsdSkel.Skeleton(sk))
    J = [str(j).split("/")[-1] for j in q.GetJointOrder()]
    best = None
    tops = None
    locks = None
    t = t0
    while t <= min(t1, t0 + 4 * fps):
        w = q.ComputeJointWorldTransforms(UsdGeom.XformCache(t))
        P = lambda j: w[J.index(j)].ExtractTranslation()
        def knee(side):
            return ang(P("thigh_" + side), P("shin_" + side), P("foot_" + side))
        if n in FLY:
            score = (P("hand_L") - P("hand_R")).GetLength()
        elif n in PULLOVER:
            score = (P("hand_L") - P("pelvis")).GetLength()
        elif n in KNEE:
            score = -knee("L")
        elif n in LEG_KNEE:
            score = -min(knee("L"), knee("R"))
        elif n in HIPS_LOW:
            score = -P("pelvis")[1]
        elif n in LEG_STRAIGHT:
            score = max(knee("L"), knee("R"))
        elif n in HINGE:
            score = -(P("neck") - P("pelvis")).GetNormalized()[1]
        elif n in HIPS_HIGH:
            score = P("pelvis")[1]
        elif n in FEET_APART:
            score = (P("foot_L") - P("foot_R")).GetLength()
        elif n in KNEES_APART:
            score = (P("shin_L") - P("shin_R")).GetLength()
        elif n in HANDS_HIGH:
            score = P("hand_L")[1] + P("hand_R")[1]
        elif n in SHRUG:
            score = P("upper_arm_L")[1] + P("upper_arm_R")[1] - 2 * P("pelvis")[1]
        elif n in TURN_OUT:
            score = P("hand_L")[0] - P("forearm_L")[0]
        elif n in TURN_IN:
            score = P("forearm_L")[0] - P("hand_L")[0]
        elif n in UPRIGHT:
            score = (P("neck") - P("pelvis")).GetNormalized()[1]
        else:
            score = -ang(P("upper_arm_L"), P("forearm_L"), P("hand_L"))
        top = max(knee("L"), knee("R"))
        if best is None or score > best[0]: best = (score, t)
        if tops is None or top > tops[0]: tops = (top, t)
        lock = ang(P("upper_arm_L"), P("forearm_L"), P("hand_L"))
        if locks is None or lock > locks[0]: locks = (lock, t)
        t += 2
    out[n] = round((best[1] - t0) / fps, 2)
    print(f"{n:30s} bottom at {out[n]}s", flush=True)
    for name, cue in AT_TOP:
        if name == n:
            out[f"{n}|{cue}"] = round((tops[1] - t0) / fps, 2)
            print(f"{n + '|' + cue:30s} top at {out[n + '|' + cue]}s", flush=True)
    for name, cue in AT_LOCKOUT:
        if name == n:
            out[f"{n}|{cue}"] = round((locks[1] - t0) / fps, 2)
            print(f"{n + '|' + cue:30s} lockout at {out[n + '|' + cue]}s", flush=True)
import os
old = json.load(open("bottoms.json")) if os.path.exists("bottoms.json") else {}
old.update(out)
json.dump(old, open("bottoms.json", "w"), indent=1)
