#!/bin/zsh
# Viewport stills from the installed harness app (holds the lab lock).
#   shots.sh view  <out dir> <still> "<Exercise>[|yaw,zoom,x,y,z]" ...   one 382x655 crop per exercise
#   shots.sh stills <out dir> "<Exercise>" ...                           crops at 0/1/2/3/5 s as <slug>_t<T>.png
#   shots.sh photo <out dir> "<Exercise>" ...                            400px thumbnails as lib-<slug>.png
#     (framing and pose time from Tools/thumbnails/thumbs.json and posetimes.json)
source ${0:A:h}/env.sh
source ${0:A:h}/lock.sh
mode=$1; out=$2; shift 2; mkdir -p $out
slug() { echo "$1" | tr 'A-Z' 'a-z' | sed 's/[^a-z0-9]\{1,\}/-/g'; }
crop() { python3 - "$1" <<'PY'
import sys
from PIL import Image
p = sys.argv[1]; im = Image.open(p).convert("RGB"); w, h = im.size; s = w / 402.0
vw, vh = 382 * s, 655 * s
im.crop((int((w - vw) / 2), int((h - vh) / 2), int((w + vw) / 2), int((h + vh) / 2))).resize((382, 655)).save(p)
PY
}
shoot() {  # env assignments..., file
  local f=${@[-1]}; env "${@[1,-2]}" xcrun simctl launch --terminate-running-process $SIM com.SamCorp.GymWorkout >/dev/null
  sleep ${WAIT:-4}; xcrun simctl io $SIM screenshot --type=png "$f" >/dev/null 2>&1
}
case $mode in
view)
  still=$1; shift
  for arg in "$@"; do
    n=${arg%%|*}; fr=""; [[ "$arg" == *"|"* ]] && fr=${arg#*|}
    tag=$(slug "$n")$([[ -n $fr ]] && echo "_${fr//,/_}")
    envs=(SIMCTL_CHILD_HARNESS_VIEW="$n" SIMCTL_CHILD_HARNESS_STILL="$still")
    [[ -n $fr ]] && envs+=(SIMCTL_CHILD_HARNESS_FRAMING="$fr")
    shoot $envs "$out/$tag.png"; crop "$out/$tag.png"
  done;;
stills)
  for n in "$@"; do for t in 0 1 2 3 5; do
    f="$out/$(slug "$n")_t$t.png"; shoot SIMCTL_CHILD_HARNESS_VIEW="$n" SIMCTL_CHILD_HARNESS_STILL="$t.02" "$f"; crop "$f"
  done; done;;
photo)
  for n in "$@"; do
    read fr t <<<$(python3 -c "
import json, sys
T = json.load(open('$REPO/Tools/thumbnails/thumbs.json'))['$n']; P = json.load(open('$REPO/Tools/thumbnails/posetimes.json'))['$n']
print(','.join(str(v) for v in [T['yaw'], T['zoom'], *T['off']]), P['time'])")
    f="$out/lib-$(echo "$n" | tr 'A-Z' 'a-z' | sed 's/[^a-z]\{1,\}/-/g').png"
    shoot SIMCTL_CHILD_HARNESS_PHOTO="$n" SIMCTL_CHILD_HARNESS_FRAMING="$fr" SIMCTL_CHILD_HARNESS_STILL="$t" "$f"
    sips -c 1140 1140 "$f" >/dev/null; sips -Z 400 "$f" >/dev/null
  done;;
esac
xcrun simctl terminate $SIM com.SamCorp.GymWorkout 2>/dev/null
echo "$mode shots in $out"
