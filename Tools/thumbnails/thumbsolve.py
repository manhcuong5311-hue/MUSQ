import sys, re, json, glob, os
sys.path.insert(0, "/Users/sammanhcuong/Developer/GymWorkout/Tools/model-pipeline")
sys.path.insert(0, ".")
from framer_still import gather, solve
PT = json.load(open("posetimes.json")); PT["Walking Lunge"]["time"] = 1.0
import numpy as np
SRC = open("/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Models/SampleData.swift").read()
M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"
PRESET = {"standing": 0.0, "bench": -1.0, "chestPress": -0.7, "pecDeck": 0.0, "cableStation": 0.0}
HELD = ("Barbell", "Dumbbell", "Lat_Bar", "Handle", "TGrip", "TBar_Plate", "LandmineBar", "Rope", "Mat", "AnkleCuff", "CuffAttachment", "Step",
        # Batch 191-240 (2026-09-26): the plate, straight cable bar and trap bar are
        # held; the landmine presses' 1.8 m bar is left to crop.
        "FrontPlate", "CableStraightBar", "TrapBar",
        # Batch 241-300 (2026-09-27): the EZ bar, pinch plates and towels are held.
        "EZBar", "PinchPlates", "Towel",
        # 1-50 redo (2026-09-29): the preacher and reverse curls' EZ bars.
        "EZ_Bar")
BODY_ONLY = {"Wide-Grip Lat Pulldown", "Reverse-Grip Lat Pulldown", "Neutral-Grip Lat Pulldown",
             "V-Bar Lat Pulldown", "Single-Arm Lat Pulldown", "Rope Lat Pulldown",
             # Batch 191-240 (2026-09-26): cable towers and the rear-delt machine
             # left these lifters a corner of the tile.
             "Cable Upright Row", "Cable Y-Raise", "Cable Front Raise", "Cable Shrug",
             "Cable External Rotation", "Machine Rear Delt Row",
             # Batch 241-300 (2026-09-27): the cable curls seen from the front-right.
             "Cable Preacher Curl", "Single-Arm Cable Curl", "Cable Hammer Curl", "Cable Drag Curl",
             # 401-500 (2026-10-04): the rope hammer curl's tower, like the Cable Hammer Curl;
             # the landmine chest press's bar and the Smith seated raise's frame left
             # those lifters a third of the tile.
             "Rope Hammer Curl", "Landmine Chest Press", "Smith Machine Seated Calf Raise",
             # Desktop "1-100" folder (2026-10-10): the Smith rack left the front
             # squat's lifter a third of the tile, as for the seated raise, and
             # the Smith Machine Squat's new rack did the same.
             "Smith Machine Front Squat", "Smith Machine Squat"}
# Held parts a lift lets crop (401-500, 2026-10-04): the landmine chest press's
# 1.9 m bar, as in its trainer framing.
CROP = {"Landmine Chest Press": ("LandmineBar",)}
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
    isheld = lambda k: any(h in k for h in HELD) and not any(c in k for c in CROP.get(name, ()))
    held = [v for k, v in equip.items() if isheld(k)]
    big = [v for k, v in equip.items() if not isheld(k)]
    core = np.vstack([body] + held)
    zb, offb = solve(core, yaw, 1.0, mx=0.84, my_top=0.84, my_bot=0.84)
    allp = np.vstack([core] + big) if big else core
    za, offa = solve(allp, yaw, 1.0, mx=0.92, my_top=0.92, my_bot=0.92) or (0, None)
    # Cable pulldowns (2026-09-25): the 2.3 m tower shrinks the lifter to a
    # sliver, so frame the lifter and let the tower crop.
    if name in BODY_ONLY: z, off = zb, offb
    elif za >= zb: z, off = zb, offb
    # The 1-50 redo's row machine (2026-09-29) raised the knees, which
    # tipped it into cropping the machine; it keeps showing all of it.
    elif za >= 0.6 * zb or name in ("Leg Press", "Cable Crunch", "Chest-Supported Row Machine"): z, off = za, offa
    else: z, off = zb, offb
    out[name] = dict(yaw=yaw, zoom=round(z, 3), off=[round(float(v), 3) for v in off])
    print(f"{name:36s} yaw={yaw:+.2f} zoom={z:.3f} body={zb:.3f} all={za:.3f}", flush=True)
    json.dump(out, open(sys.argv[1], "w"), indent=1)
