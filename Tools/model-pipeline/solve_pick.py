# solve_all.py with per-job overrides, for picking framings on stills
# (401-500 batch, 2026-10-04). Jobs: {"label": [res, yaw, mode?, notheld?]},
# mode auto | body | all (body lets equipment such as a mat or a machine
# crop), notheld = equipment name fragments to treat as big rather than held.
# Prints a HARNESS_FRAMING string per job. Check compact poses on a still: for
# the Toe Touch Crunch the bisection returned zooms of 1.0-1.4 with large
# offsets that overflowed the viewport.
#   solve_pick.py '<jobs json>' [out.json]
import sys, json, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from framer import gather, solve
import numpy as np
M = "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/"
HELD = ("Barbell", "Dumbbell", "Lat_Bar", "Handle", "TGrip", "TBar_Plate", "LandmineBar", "Rope")
ASPECT = 0.5832
JOBS = json.loads(sys.argv[1]); out = {}; cache = {}
for name, job in JOBS.items():
    res, yaw = job[0], job[1]; mode = job[2] if len(job) > 2 else "auto"; notheld = job[3] if len(job) > 3 else []
    if res not in cache: cache[res] = gather(M + res + ".usdc")
    body, equip = cache[res]
    isheld = lambda k: any(h in k for h in HELD) and not any(n in k for n in notheld)
    held = [v for k, v in equip.items() if isheld(k)]
    big = [v for k, v in equip.items() if not isheld(k)]
    core = np.vstack([body] + held)
    zb, offb = solve(core, yaw, ASPECT, mx=0.86, my_top=0.80, my_bot=0.80)
    allp = np.vstack([core] + big) if big else core
    za, offa = solve(allp, yaw, ASPECT, mx=0.92, my_top=0.86, my_bot=0.84)
    if mode == "body" or (mode == "auto" and not (za >= zb or za >= 0.82 * zb)):
        z, off, m = zb, offb, "body/crop"
    else:
        z, off, m = (za, offa, "all") if za < zb else (zb, offb, "body")
    out[name] = dict(res=res, yaw=yaw, zoom=round(float(z), 3), off=[round(float(v), 3) for v in off])
    o = out[name]["off"]
    print(f"{name:34s} yaw={yaw:+.2f} zoom={z:.3f} body={zb:.3f} all={za:.3f} {m:9s} framing \"{yaw},{z:.3f},{o[0]},{o[1]},{o[2]}\"")
if len(sys.argv) > 2: json.dump(out, open(sys.argv[2], "w"), indent=1)
