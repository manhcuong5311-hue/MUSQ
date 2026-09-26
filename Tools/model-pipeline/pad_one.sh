#!/bin/zsh
# pad_clips.py on one model, kept only if the pose matches at every frame.
PY=/Applications/Blender.app/Contents/Resources/5.1/python/bin/python3.13; HERE=${0:A:h}
f=$1; before=$(mktemp -t padbefore).usdc
cp "$f" "$before"
out=$($PY $HERE/pad_clips.py "$f")
if [[ "$out" == *"already full length"* ]]; then echo "same  ${f:t}"; rm -f "$before"; exit 0; fi
if res=$($PY $HERE/same_motion.py "$before" "$f"); then echo "ok    $out | $res"; else cp "$before" "$f"; echo "RESTORED ${f:t}: $res"; fi
rm -f "$before"
