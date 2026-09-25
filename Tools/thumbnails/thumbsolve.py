import sys, re, json, glob, os
sys.path.insert(0, "/Users/sammanhcuong/Desktop/GymWorkout/Tools/model-pipeline")
sys.path.insert(0, ".")
from framer_still import gather, solve
PT = json.load(open("posetimes.json")); PT["Walking Lunge"]["time"] = 1.0
import numpy as np
SRC = open("/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Models/SampleData.swift").read()
M = "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/"
PRESET = {"standing": 0.0, "bench": -1.0, "chestPress": -0.7, "pecDeck": 0.0, "cableStation": 0.0}
HELD = ("Barbell", "Dumbbell", "Lat_Bar", "Handle", "TGrip", "TBar_Plate", "LandmineBar", "Rope", "Mat", "AnkleCuff", "CuffAttachment", "Step")
BODY_ONLY = {"Wide-Grip Lat Pulldown", "Reverse-Grip Lat Pulldown", "Neutral-Grip Lat Pulldown",
             "V-Bar Lat Pulldown", "Single-Arm Lat Pulldown", "Rope Lat Pulldown"}
block = SRC[SRC.index("modelByExercise: [String: ExerciseModel] = ["):SRC.index("static func model(for")]
jobs = {}
for m in re.finditer(r'"([^"]+)":\s*ExerciseModel\(resource: "([^"]+)",\s*framing: (?:\.(\w+)|ModelFraming\(yaw: ([-\d.]+))', block):
    name, res, preset, yaw = m.groups()
    yaw = PRESET[preset] if preset else float(yaw)
    path = glob.glob(M + "*/" + res + ".usdc")[0]
    jobs[name] = (path, yaw)
only = sys.argv[2:]
out = json.load(open(sys.argv[1])) if os.path.exists(sys.argv[1]) else {}
for name, (path, yaw) in jobs.items():
    if only and name not in only: continue
    body, equip = gather(path, PT[name]["time"])
    held = [v for k, v in equip.items() if any(h in k for h in HELD)]
    big = [v for k, v in equip.items() if not any(h in k for h in HELD)]
    core = np.vstack([body] + held)
    zb, offb = solve(core, yaw, 1.0, mx=0.84, my_top=0.84, my_bot=0.84)
    allp = np.vstack([core] + big) if big else core
    za, offa = solve(allp, yaw, 1.0, mx=0.92, my_top=0.92, my_bot=0.92) or (0, None)
    # Cable pulldowns (2026-09-25): the 2.3 m tower shrinks the lifter to a
    # sliver, so frame the lifter and let the tower crop.
    if name in BODY_ONLY: z, off = zb, offb
    elif za >= zb: z, off = zb, offb
    elif za >= 0.6 * zb or name in ("Leg Press", "Cable Crunch"): z, off = za, offa
    else: z, off = zb, offb
    out[name] = dict(yaw=yaw, zoom=round(z, 3), off=[round(float(v), 3) for v in off])
    print(f"{name:36s} yaw={yaw:+.2f} zoom={z:.3f} body={zb:.3f} all={za:.3f}", flush=True)
    json.dump(out, open(sys.argv[1], "w"), indent=1)
