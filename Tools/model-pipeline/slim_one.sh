#!/bin/zsh
# Slims one converted model in place, keeping it only if the composed result
# matches the original attribute for attribute (share_body.py + equiv.py).
#   slim_one.sh <path/to/Model.usdc>
set -e
PY=/Applications/Blender.app/Contents/Resources/5.1/python/bin/python3.13
HERE=${0:A:h}
BODY=/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/Shared/AnatomyBody.usdc
f=$1; tmp=${f:r}.slim.tmp.usdc
if [ $(stat -f %z "$f") -lt 5000000 ]; then echo "already slim: ${f:t}"; exit 0; fi
$PY $HERE/share_body.py slim "$f" $BODY "$tmp" >/dev/null
res=$($PY $HERE/equiv.py "$f" "$tmp")
if [[ "$res" == *"missing 0 extra 0 different 0"* ]]; then
  mv "$tmp" "$f"; echo "ok  $res"
else
  rm -f "$tmp"; echo "KEPT ORIGINAL  $res"
fi
