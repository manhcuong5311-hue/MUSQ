#!/bin/zsh
# Trainer stills and every cue's mistake ghost for exercises already in the
# library, from the installed harness app (family.sh without the integration
# step; 2026-10-11, for replaced models). Holds the lab lock.
#   shoot_ex.sh <out dir> <stills e.g. 0,1.5,3> "<Exercise>" ...
# Writes <out>/trainer/<slug>_t<T>.png and <out>/faults/<slug>--<cue>.png
# (a third of full size), the ghost held at its bottoms.json still; cue ids
# come from the exercise's CueAnnotation rows in SampleData.swift.
source ${0:A:h}/env.sh
source ${0:A:h}/lock.sh
OUT=$1; stills=$2; shift 2; mkdir -p $OUT/trainer $OUT/faults
small() { python3 -c "
from PIL import Image
im = Image.open('$1').convert('RGB'); im.resize((im.size[0] // 3, im.size[1] // 3)).save('$1')"; }
xcrun simctl boot $SIM 2>/dev/null
for n in "$@"; do
  slug=$(echo $n | tr 'A-Z' 'a-z' | sed 's/[^a-z0-9]\{1,\}/-/g')
  for t in ${(s:,:)stills}; do
    SIMCTL_CHILD_HARNESS_EXERCISE="$n" SIMCTL_CHILD_HARNESS_STILL="$t" xcrun simctl launch --terminate-running-process $SIM com.SamCorp.GymWorkout >/dev/null
    sleep ${WAIT:-5}; xcrun simctl io $SIM screenshot --type=png "$OUT/trainer/${slug}_t$t.png" >/dev/null 2>&1; small "$OUT/trainer/${slug}_t$t.png"
  done
  python3 - "$n" "$REPO" > $OUT/cues_$slug.txt <<'PYEOF'
import re, sys, json
name, repo = sys.argv[1], sys.argv[2]
src = open(repo + "/GymWorkout/Models/SampleData.swift").read()
B = json.load(open(repo + "/Tools/fault-review/bottoms.json"))
var = re.search(r'^\s+"%s":\s+(\w+Content),' % re.escape(name), src, re.M).group(1)
a = src.index("static let %s = ExerciseContent(" % var); b = src.find("\n    static let ", a + 10)
for cue in dict.fromkeys(re.findall(r'CueAnnotation\(cueID: "(\w+)"', src[a:b])):
    print(cue, round(B.get(name + "|" + cue, B.get(name, 0)) + 0.02, 2))
PYEOF
  while read -r cue st; do
    SIMCTL_CHILD_DEBUG_PREMIUM=1 SIMCTL_CHILD_HARNESS_FAULT="$n" SIMCTL_CHILD_HARNESS_CUE="$cue" SIMCTL_CHILD_HARNESS_STILL="$st" \
      xcrun simctl launch --terminate-running-process $SIM com.SamCorp.GymWorkout >/dev/null
    sleep ${WAIT:-5}; xcrun simctl io $SIM screenshot --type=png "$OUT/faults/${slug}--$cue.png" >/dev/null 2>&1; small "$OUT/faults/${slug}--$cue.png"
  done < $OUT/cues_$slug.txt
done
xcrun simctl terminate $SIM com.SamCorp.GymWorkout 2>/dev/null
echo "shots in $OUT (trainer/, faults/)"
