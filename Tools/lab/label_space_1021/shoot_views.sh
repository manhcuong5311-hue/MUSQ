#!/bin/zsh
# Viewport-only stills (no labels) of the 11 deadlift-set-up lifts across the rep, for the free-space search.
export LAB=${LAB:?set LAB to a scratch folder}
source ~/Developer/GymWorkout/Tools/lab/env.sh
source ~/Developer/GymWorkout/Tools/lab/lock.sh
OUT=$LAB/occ; mkdir -p $OUT
xcrun simctl boot $SIM 2>/dev/null
names=("Deadlift" "Sumo Deadlift" "Deficit Deadlift" "Snatch-Grip Deadlift" "Rack Pull" "Block Pull" "Trap Bar Deadlift" "Romanian Deadlift" "Stiff-Leg Deadlift" "Smith Machine Romanian Deadlift" "Barbell Single-Leg Romanian Deadlift")
for n in "${names[@]}"; do
  slug=$(echo $n | tr 'A-Z' 'a-z' | sed 's/[^a-z0-9]\{1,\}/-/g')
  for t in 0 0.5 1.0 1.5 2.0 2.5 3.0; do
    SIMCTL_CHILD_HARNESS_VIEW="$n" SIMCTL_CHILD_HARNESS_STILL="$t" xcrun simctl launch --terminate-running-process $SIM com.SamCorp.GymWorkout >/dev/null
    sleep ${WAIT:-6}; xcrun simctl io $SIM screenshot --type=png "$OUT/${slug}_v$t.png" >/dev/null 2>&1
  done
done
xcrun simctl terminate $SIM com.SamCorp.GymWorkout 2>/dev/null
echo done
