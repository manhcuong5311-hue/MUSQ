# Model pipeline (raw Blender USD -> app-ready usdc)

Run with Blender's Python, which ships `pxr` and numpy:
`/Applications/Blender.app/Contents/Resources/5.1/python/bin/python3.13`

1. `survey2.py`, `survey3.py`, `pose2.py` — up axis, frame range, lights, parked
   props, equipment prims, which way the lifter faces.
2. `convert_all.py` (+ `curves2mesh.py`) — Z-up -> Y-up wrapper, lights and
   off-stage props deactivated, BasisCurves rebuilt as meshes, flattened into
   `GymWorkout/Resources/Models/<Group>/<Name>.usdc`. Edit `JOBS` per batch.
   Raw exports are read from `SourceExports/`, never from `Resources/`.
3. `framer.py` / `solve_all.py` / `solve_yaws.py` — fit yaw/zoom/offset for
   `ModelFraming` by projecting joints + equipment through the viewport camera.
4. `shot2.sh` + `montage.swift` — simulator screenshots (needs the harness in
   the two `*.harness.swift.txt` files swapped into a build; never commit it).
   `sync_build.sh` builds a scratch mirror of the project without raw exports.

5. `graft_bar.py <target.usdc> <donor.usdc>` — when an export keeps an
   animated `GYM_Barbell_ROOT` but loses the meshes under it (Back Squat,
   2026-09-24), copies a donor model's bar geometry and GYM materials into the
   target's bar root. Both roots must share rotation and scale; the script
   checks. Re-solve the framing afterwards: a 2.2 m bar needs more room.

Paths inside the scripts point at the session scratchpad; adjust before reuse.
