#!/bin/zsh
# Mirrors the repo into $LAB/src (no raw exports, no .git), swaps in the
# harness ContentView, builds for the harness simulator and installs.
#   build.sh            build + install
#   build.sh --no-install
source ${0:A:h}/env.sh
rsync -a --delete --exclude 'SourceExports' --exclude '.git' --exclude '*.slim.tmp.usdc' $REPO/ $LAB/src/
cp ${0:A:h}/ContentView.harness.swift.txt $LAB/src/GymWorkout/ContentView.swift
cd $LAB/src
xcodebuild -project GymWorkout.xcodeproj -scheme GymWorkout -sdk iphonesimulator -destination "platform=iOS Simulator,id=$SIM" \
  -derivedDataPath $LAB/dd build CODE_SIGNING_ALLOWED=NO > $LAB/build.log 2>&1
if ! grep -q "BUILD SUCCEEDED" $LAB/build.log; then
  grep -E " error: " $LAB/build.log | sort -u | sed "s|$LAB/src/||" | head -40; echo "BUILD FAILED ($LAB/build.log)"; exit 1
fi
echo "BUILD SUCCEEDED"
[[ "$1" == --no-install ]] && exit 0
xcrun simctl boot $SIM 2>/dev/null
xcrun simctl install $SIM $LAB/dd/Build/Products/Debug-iphonesimulator/GymWorkout.app && echo installed
