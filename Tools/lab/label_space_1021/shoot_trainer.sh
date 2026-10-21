#!/bin/zsh
# Trainer stills (labels on) for the 11 deadlift-set-up lifts at t=0 and at each lift's bottom (bottoms.json).
export LAB=${LAB:?set LAB to a scratch folder}
source ~/Developer/GymWorkout/Tools/lab/env.sh
source ~/Developer/GymWorkout/Tools/lab/lock.sh
OUT=$1; mkdir -p $OUT
xcrun simctl boot $SIM 2>/dev/null
names=("Deadlift" "Sumo Deadlift" "Deficit Deadlift" "Snatch-Grip Deadlift" "Rack Pull" "Block Pull" "Trap Bar Deadlift" "Romanian Deadlift" "Stiff-Leg Deadlift" "Smith Machine Romanian Deadlift" "Barbell Single-Leg Romanian Deadlift")
for n in "${names[@]}"; do
  slug=$(echo $n | tr 'A-Z' 'a-z' | sed 's/[^a-z0-9]\{1,\}/-/g')
  bt=$(python3 -c "import json;B=json.load(open('$REPO/Tools/fault-review/bottoms.json'));print(round(B.get('$n',1.0),2))")
  for t in 0 $bt; do
    SIMCTL_CHILD_HARNESS_EXERCISE="$n" SIMCTL_CHILD_HARNESS_STILL="$t" xcrun simctl launch --terminate-running-process $SIM com.SamCorp.GymWorkout >/dev/null
    sleep ${WAIT:-6}; xcrun simctl io $SIM screenshot --type=png "$OUT/${slug}_t$t.png" >/dev/null 2>&1
  done
done
xcrun simctl terminate $SIM com.SamCorp.GymWorkout 2>/dev/null
echo done
