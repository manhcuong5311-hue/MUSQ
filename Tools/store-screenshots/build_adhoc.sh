#!/bin/zsh
# Like Tools/lab/build.sh, but ad-hoc signed so the simulator app keeps its
# entitlements (HealthKit, Sign in with Apple, keychain). Holds the lab lock.
# Builds for the first simulator's architecture only (a generic build leaves
# x86_64 .stringsdata in $LAB/dd that Tools/localization/ui.py then reads).
#   build_adhoc.sh [SIM_UDID ...]   build, then install on each simulator (default: the harness)
source ${0:A:h}/../lab/env.sh
source ${0:A:h}/../lab/lock.sh
rsync -a --delete --exclude 'SourceExports' --exclude '.git' --exclude '*.slim.tmp.usdc' $REPO/ $LAB/src/
cp $REPO/Tools/lab/ContentView.harness.swift.txt $LAB/src/GymWorkout/ContentView.swift
cd $LAB/src
xcodebuild -project GymWorkout.xcodeproj -scheme GymWorkout -sdk iphonesimulator -destination "platform=iOS Simulator,id=${1:-$SIM}" \
  -derivedDataPath $LAB/dd build CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- DEVELOPMENT_TEAM= PROVISIONING_PROFILE_SPECIFIER= > $LAB/build_adhoc.log 2>&1
if ! grep -q "BUILD SUCCEEDED" $LAB/build_adhoc.log; then
  grep -E " error: " $LAB/build_adhoc.log | sort -u | sed "s|$LAB/src/||" | head -40; echo "BUILD FAILED ($LAB/build_adhoc.log)"; exit 1
fi
echo "BUILD SUCCEEDED"
APP=$LAB/dd/Build/Products/Debug-iphonesimulator/GymWorkout.app
for s in ${@:-$SIM}; do xcrun simctl install $s $APP && echo "installed on $s"; done
