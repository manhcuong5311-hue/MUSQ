#!/bin/zsh
# Mirrors the project into the scratchpad minus the raw exports, builds, installs.
S=/private/tmp/claude-501/-Users-sammanhcuong-Desktop-GymWorkout-GymWorkout/a7d4e791-7a6a-4555-9cc9-57da89b306a3/scratchpad; U=0F481AB7-B858-4275-8617-00068EBADA75
rsync -a --delete \
  --exclude 'GymWorkout/Resources/Models/*/[0-9][0-9]_*.usdc' \
  --exclude 'GymWorkout/Resources/Models/*/textures' \
  --exclude 'GymWorkout/Resources/Models/*/1-10' \
  --exclude 'SourceExports' \
  /Users/sammanhcuong/Desktop/GymWorkout/ $S/build_src/
cd $S/build_src
xcodebuild -project GymWorkout.xcodeproj -scheme GymWorkout -sdk iphonesimulator -destination "platform=iOS Simulator,id=$U" -derivedDataPath $S/dd2 build 2>&1 | grep -E "error:|BUILD" | head -8
xcrun simctl install $U $S/dd2/Build/Products/Debug-iphonesimulator/GymWorkout.app && echo installed
