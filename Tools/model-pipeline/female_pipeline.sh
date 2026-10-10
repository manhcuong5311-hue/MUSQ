#!/bin/zsh
# The female-model jobs end to end (2026-10-10): convert (studio floors off),
# texture paths to bare names (retex.py), pad, rename the hack-squat rig
# (rename_rig.py), slim against the female body each set was built from.
#   female_pipeline.sh            all twelve
set -e
PY=/Applications/Blender.app/Contents/Resources/5.1/python/bin/python3.13; HERE=${0:A:h}
M=/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models
export PXR_AR_DEFAULT_SEARCH_PATH=$M/Shared
cd $HERE && $PY convert_all.py female-1010/ 2>&1 | grep -v Warning | grep -v "^       "
FILES=($M/Legs/FemalePendulumSquat{Standard,High,Low,Wide,Narrow}.usdc $M/Legs/FemaleHackSquat{Standard,High,Low,Wide,Narrow}.usdc $M/Abs/AbWheelRollout.usdc $M/Legs/CableStepDown.usdc)
$PY retex.py $FILES 2>&1 | grep -v Warning | sed 's#.*/##'
for f in $FILES; do zsh pad_one.sh $f 2>&1 | grep -v Warning | cut -c1-60; done
$PY rename_rig.py $M/Legs/FemaleHackSquat*.usdc 2>&1 | grep -v Warning | sed 's#.*/##'
slim() {  # model body
  local f=$1 body=$2 tmp=${1:r}.slim.tmp.usdc
  $PY share_body.py slim $f $body $tmp >/dev/null 2>&1
  local res=$($PY equiv.py $f $tmp 2>&1 | grep -v Warning | head -1)
  if [[ "$res" == *"missing 0 extra 0 different 0"* ]]; then mv $tmp $f; echo "slim ok ${f:t}"; else rm -f $tmp; echo "KEPT ORIGINAL ${f:t}: $res"; fi
}
for f in $M/Legs/FemalePendulumSquat*.usdc $M/Abs/AbWheelRollout.usdc $M/Legs/CableStepDown.usdc; do slim $f $M/Shared/AnatomyBodyFemale.usdc & done; wait
for f in $M/Legs/FemaleHackSquat*.usdc; do slim $f $M/Shared/AnatomyBodyFemaleHack.usdc & done; wait
