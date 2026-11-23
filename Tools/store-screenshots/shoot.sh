#!/bin/zsh
# shoot.sh SIM LANG OUT.png WAIT [launch args...]
# Relaunches MUSQ (Pro, no ads) in LANG (en|vi) and screenshots after WAIT seconds.
SIM=$1; LANG_=$2; OUT=$3; WAIT=$4; shift 4
if [[ $LANG_ == vi ]]; then L=(-AppleLanguages "(vi)" -AppleLocale vi_VN); else L=(-AppleLanguages "(en)" -AppleLocale en_US); fi
xcrun simctl terminate $SIM com.SamCorp.GymWorkout 2>/dev/null
SIMCTL_CHILD_DEBUG_PRO=1 xcrun simctl launch $SIM com.SamCorp.GymWorkout "${L[@]}" "$@" >/dev/null || exit 1
sleep $WAIT
[[ -n $OUT && $OUT != - ]] && xcrun simctl io $SIM screenshot "$OUT" >/dev/null 2>&1 && echo "$OUT"
