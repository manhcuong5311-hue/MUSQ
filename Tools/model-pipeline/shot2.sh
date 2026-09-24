#!/bin/zsh
# usage: shot2.sh "<Exercise Name>" outname [KEY=VAL ...] — screenshot + report whether a drag moved the model
U=0F481AB7-B858-4275-8617-00068EBADA75; S=/private/tmp/claude-501/-Users-sammanhcuong-Desktop-GymWorkout-GymWorkout/a7d4e791-7a6a-4555-9cc9-57da89b306a3/scratchpad
name="$1"; out="$2"; shift 2
envs=(SIMCTL_CHILD_HARNESS_EXERCISE="$name")
for kv in "$@"; do envs+=("SIMCTL_CHILD_$kv"); done
env "${envs[@]}" xcrun simctl launch --console-pty --terminate-running-process $U com.SamCorp.GymWorkout > $S/log_$out.txt 2>&1 &
LP=$!
sleep ${WAIT:-8}
xcrun simctl io $U screenshot --type=png "$S/shots/$out.png" >/dev/null 2>&1
sips -Z 700 "$S/shots/$out.png" >/dev/null
sleep 1.2
kill $LP 2>/dev/null; wait $LP 2>/dev/null
y=$(grep -o "yawState [-0-9.e]*" $S/log_$out.txt | awk '{print $2}' | sort -u | tr '\n' ' ')
echo "$out: yawState=[$y]"
