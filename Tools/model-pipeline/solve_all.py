import sys, math, json
sys.path.insert(0, sys.argv[1])
from framer import gather, solve, project
import numpy as np
M = "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/"
HELD = ("Barbell", "Dumbbell", "Lat_Bar", "Handle", "TGrip", "TBar_Plate", "LandmineBar", "Rope")
ASPECT = 0.74
JOBS = json.loads(sys.argv[2])
out = {}
for name, (res, yaw) in JOBS.items():
    body, equip = gather(M + res + ".usdc")
    held = [v for k, v in equip.items() if any(h in k for h in HELD)]
    big = [v for k, v in equip.items() if not any(h in k for h in HELD)]
    core = np.vstack([body] + held)
    zb, offb = solve(core, yaw, ASPECT, mx=0.86, my_top=0.80, my_bot=0.80)
    allp = np.vstack([core] + big) if big else core
    za, offa = solve(allp, yaw, ASPECT, mx=0.92, my_top=0.86, my_bot=0.84)
    # The lifter always fits (zb). Keep the whole setup in frame when that
    # costs at most ~18% of the lifter's size; otherwise let the machine crop.
    if za >= zb:
        z, off, mode = zb, offb, "body"
    elif za >= 0.82 * zb:
        z, off, mode = za, offa, "all"
    else:
        z, off, mode = zb, offb, "crop"
    out[name] = dict(res=res, yaw=yaw, zoom=round(z, 3), off=[round(float(v), 3) for v in off], zb=round(zb, 3), za=round(za, 3), mode=mode)
    print(f"{name:30s} yaw={yaw:+.2f} zoom={z:.3f} off=({off[0]:+.3f},{off[1]:+.3f},{off[2]:+.3f}) body={zb:.3f} all={za:.3f} {mode}")
json.dump(out, open(sys.argv[3], "w"), indent=1)
