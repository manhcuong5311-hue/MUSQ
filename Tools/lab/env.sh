# Shared settings for the lab scripts (401-500 batch, 2026-10-05).
# LAB: a scratch folder for mirrors, builds and shots (set it per session; it
# is rebuilt from the repo whenever it is missing). SIM: the harness
# simulator, kept apart from the user's own iPhone simulator.
REPO=/Users/sammanhcuong/Developer/GymWorkout
LAB=${LAB:-/private/tmp/claude-501/-Users-sammanhcuong-Developer/09849807-be7a-4693-9465-1497f3409a39/scratchpad/lab}
SIM=${SIM:-70FBC593-A9B8-4350-96A8-B23BB0B44A57}
PY=/Applications/Blender.app/Contents/Resources/5.1/python/bin/python3.13
export PXR_AR_DEFAULT_SEARCH_PATH=$REPO/GymWorkout/Resources/Models/Shared
mkdir -p $LAB
