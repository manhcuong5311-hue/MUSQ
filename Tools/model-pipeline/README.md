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

Chest batch 101-131 (2026-09-25): the 28 exports on the HIKSEMI drive's
`100-131` folder were copied to `SourceExports/Chest3` (100, 127, 129 and 130
were never exported) and converted with `convert_all.py Chest3`. Framing was
solved at the trainer's real aspect with `ASPECT=0.5832 solve_all.py`
(`ASPECT` defaults to the old 0.74), then checked on simulator stills.

Batch 133-160 (2026-09-25): the drive's `131-160` folder (27 exports; 131
came with the chest batch, 132 and 136 were not exported) was copied to
`SourceExports/131-160` and converted with `convert_all.py 131-160`. The
Meadows row's export faces +x instead of +z, so its yaw is 2.71 for the same
rear three-quarter view the other rows get at -2; the rack pull is turned to
-2.5 so the rack's near upright clears the lifter, and the seal row is seen
side-on (-1.4).

Batch 161-190 (2026-09-25): the drive's `160-190` folder (30 exports, all
back lifts; 160 came with the previous batch) was copied to
`SourceExports/160-190` and converted with `convert_all.py 160-190`. Pull-ups
and pulldowns are seen from behind-left (-2.6) like the Pull-Up, cable rows
at -2.2 like the Seated Cable Row, machine rows at -2.4; the machine pullover
is turned three-quarter from the front (-0.9) because from its left side the
lever's plate hides the lifter.
