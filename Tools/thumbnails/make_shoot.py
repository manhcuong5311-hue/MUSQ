# Writes shoot.sh: one simctl launch per exercise with the temp harness's
# HARNESS_PHOTO / HARNESS_FRAMING / HARNESS_STILL, then crops the centred
# 380pt box (1140px at 3x) and downsizes to 400px.
import json, re
T = json.load(open("thumbs.json")); P = json.load(open("posetimes.json"))
P["Walking Lunge"]["time"] = 1.0   # the clip travels; 7.8s is off in the distance
print("#!/bin/zsh\nU=0F481AB7-B858-4275-8617-00068EBADA75; D=$PWD/out; mkdir -p $D")
for n, t in T.items():
    slug = "lib-" + re.sub("[^a-z]+", "-", n.lower())
    fr = ",".join(str(v) for v in [t["yaw"], t["zoom"], *t["off"]])
    print(f'SIMCTL_CHILD_HARNESS_PHOTO="{n}" SIMCTL_CHILD_HARNESS_FRAMING="{fr}" SIMCTL_CHILD_HARNESS_STILL="{P[n]["time"]}" '
          f'xcrun simctl launch --terminate-running-process $U com.SamCorp.GymWorkout >/dev/null; sleep 4; '
          f'xcrun simctl io $U screenshot --type=png "$D/{slug}.png" >/dev/null 2>&1; '
          f'sips -c 1140 1140 "$D/{slug}.png" >/dev/null; sips -Z 400 "$D/{slug}.png" >/dev/null')
