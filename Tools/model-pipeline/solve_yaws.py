import sys, json
sys.path.insert(0, sys.argv[1])
from framer import gather, solve
import numpy as np
M = "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/"
HELD = ("Barbell", "Dumbbell", "Lat_Bar", "Handle", "TGrip", "TBar_Plate", "LandmineBar", "Rope")
for spec in sys.argv[2:]:
    res, yaws = spec.split("=")
    body, equip = gather(M + res + ".usdc")
    held = [v for k, v in equip.items() if any(h in k for h in HELD)]
    core = np.vstack([body] + held)
    for y in map(float, yaws.split(",")):
        z, off = solve(core, y, 0.74, mx=0.86, my_top=0.80, my_bot=0.80)
        print(f"{res}|{y}|H_YAW={y} H_ZOOM={z:.3f} H_OFFX={off[0]:.3f} H_OFFY={off[1]:.3f} H_OFFZ={off[2]:.3f}")
