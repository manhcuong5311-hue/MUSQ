# Writes shoot.sh: one simctl launch per authored fault, opening the trainer
# straight onto that cue's mistake with the clip held at the rep's bottom
# (bottoms.json), then a screenshot into faults/<exercise>--<cue>.png.
#   python3 make_shoot.py [exercise ...] > shoot.sh && zsh shoot.sh
import json, re, sys
B = json.load(open("bottoms.json"))
S = open("../../GymWorkout/Models/FaultPoses.swift").read()
table = S[S.index("private static let table"):]
only = sys.argv[1:]
print("#!/bin/zsh\nU=0F481AB7-B858-4275-8617-00068EBADA75; D=$PWD/faults; mkdir -p $D")
for block in re.split(r'\n        "', table)[1:]:
    name = block.split('"')[0]
    if only and name not in only: continue
    for cue in re.findall(r'\n            "(\w+)":', block):
        slug = re.sub("[^a-z]+", "-", name.lower()) + "--" + cue
        # The mistake view is Premium (2026-10-01); debug builds unlock it.
        print(f'SIMCTL_CHILD_DEBUG_PREMIUM=1 SIMCTL_CHILD_HARNESS_FAULT="{name}" SIMCTL_CHILD_HARNESS_CUE="{cue}" '
              f'SIMCTL_CHILD_HARNESS_STILL="{B.get(name + "|" + cue, B.get(name, 0)) + 0.02}" '
              f'xcrun simctl launch --terminate-running-process $U com.SamCorp.GymWorkout >/dev/null; sleep 4; '
              f'xcrun simctl io $U screenshot --type=png "$D/{slug}.png" >/dev/null 2>&1')
