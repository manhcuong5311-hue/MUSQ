#!/bin/zsh
# Lab for a content family of the 401-500 batch: mirrors the repo, integrates
# ONE family (spec + faults) into the mirror with integrate_500.py --only,
# sets its fault stills with fault_times.py, builds the harness app and,
# unless `check`, installs it and shoots
#   trainer/<slug>_t<T>.png   the trainer screen (labels on) at each still T
#   faults/<slug>--<cue>.png  every authored fault ghost at its still
# with contact sheets trainer.png / faults*.png, into $LAB/<family>/.
# Holds the lab lock for the whole run (one run at a time across agents).
#   family.sh check <family>
#   family.sh shoot <family> [stills, default "0,1.5,3"] [exercise names...]
source ${0:A:h}/env.sh
source ${0:A:h}/lock.sh
mode=$1; fam=$2; stills=${3:-0,1.5,3}; shift 3 2>/dev/null; only=("$@")
echo "lock taken $(date +%T)"
OUT=$LAB/$fam; rm -rf $OUT; mkdir -p $OUT/trainer $OUT/faults
rsync -a --delete --exclude 'SourceExports' --exclude '.git' --exclude '*.slim.tmp.usdc' $REPO/ $LAB/src/
cp ${0:A:h}/ContentView.harness.swift.txt $LAB/src/GymWorkout/ContentView.swift
cd $LAB/src/Tools/trainer-content
python3 integrate_500.py $OUT --only $fam || { echo "INTEGRATE FAILED"; exit 1; }
cd $LAB/src/Tools/fault-review
[[ -f fault_moments_500_$fam.json ]] && $PY fault_times.py fault_moments_500_$fam.json 2>&1 | grep -v Warning > $OUT/fault_times.txt
cd $LAB/src
xcodebuild -project GymWorkout.xcodeproj -scheme GymWorkout -sdk iphonesimulator -destination "platform=iOS Simulator,id=$SIM" \
  -derivedDataPath $LAB/dd build CODE_SIGNING_ALLOWED=NO > $OUT/build.log 2>&1
if ! grep -q "BUILD SUCCEEDED" $OUT/build.log; then
  grep -E " error: " $OUT/build.log | sort -u | sed "s|$LAB/src/||" | head -40
  echo "BUILD FAILED (log: $OUT/build.log)"; exit 1
fi
echo "BUILD SUCCEEDED"
[[ $mode == check ]] && exit 0
xcrun simctl boot $SIM 2>/dev/null
xcrun simctl install $SIM $LAB/dd/Build/Products/Debug-iphonesimulator/GymWorkout.app || exit 1
names=$(python3 -c "
import sys; sys.path.insert(0, '$LAB/src/Tools/trainer-content')
import spec_500 as S
only = sys.argv[1:]
print('\n'.join(n for n in S.FAMILIES['$fam'] if not only or n in only))" "${only[@]}")
small() { python3 -c "
from PIL import Image
im = Image.open('$1').convert('RGB'); im.resize((im.size[0] // 3, im.size[1] // 3)).save('$1')"; }
echo "$names" | while read -r n; do
  [[ -z "$n" ]] && continue
  slug=$(echo $n | tr 'A-Z' 'a-z' | sed 's/[^a-z0-9]\{1,\}/-/g')
  for t in ${(s:,:)stills}; do
    SIMCTL_CHILD_HARNESS_EXERCISE="$n" SIMCTL_CHILD_HARNESS_STILL="$t" xcrun simctl launch --terminate-running-process $SIM com.SamCorp.GymWorkout >/dev/null
    sleep 5; xcrun simctl io $SIM screenshot --type=png "$OUT/trainer/${slug}_t$t.png" >/dev/null 2>&1; small "$OUT/trainer/${slug}_t$t.png"
  done
  python3 - "$n" > $OUT/cues_$slug.txt <<'PYEOF'
import re, sys, json
name = sys.argv[1]
S = open("GymWorkout/Models/FaultPoses.swift").read()
B = json.load(open("Tools/fault-review/bottoms.json"))
table = S[S.index("private static let table"):]
for block in re.split(r'\n        "', table)[1:]:
    if block.split('"')[0] != name: continue
    for cue in re.findall(r'\n            "(\w+)":', block):
        print(cue, B.get(name + "|" + cue, B.get(name, 0)) + 0.02)
PYEOF
  while read -r cue st; do
    SIMCTL_CHILD_DEBUG_PREMIUM=1 SIMCTL_CHILD_HARNESS_FAULT="$n" SIMCTL_CHILD_HARNESS_CUE="$cue" SIMCTL_CHILD_HARNESS_STILL="$st" \
      xcrun simctl launch --terminate-running-process $SIM com.SamCorp.GymWorkout >/dev/null
    sleep 5; xcrun simctl io $SIM screenshot --type=png "$OUT/faults/${slug}--$cue.png" >/dev/null 2>&1; small "$OUT/faults/${slug}--$cue.png"
  done < $OUT/cues_$slug.txt
done
xcrun simctl terminate $SIM com.SamCorp.GymWorkout 2>/dev/null
for kind in trainer faults; do
  files=($OUT/$kind/*.png(N)); (( ${#files} )) || continue
  i=1; while (( i <= ${#files} )); do
    python3 ${0:A:h}/sheet.py $OUT/$kind$( (( i > 1 )) && echo $(( (i - 1) / 24 + 1 )) ).png 6 --size 268x583 ${files[i,i+23]} >/dev/null; i=$(( i + 24 ))
  done
done
echo "shots in $OUT (trainer/, faults/, trainer.png, faults*.png)"
