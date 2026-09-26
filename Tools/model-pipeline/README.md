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

Batch 191-240 (2026-09-26): the drive's `190-240` folder (46 exports; 207,
222, 224 and 237 were not exported) was copied to `SourceExports/190-240` and
converted with `convert_all.py 190-240/`: shoulders into `Shoulder/`, shrugs
into `Back/`, carries into `Abs/`, curls into `Biceps/`. The three carries walk
forward 1.4-2.8 m over the clip, straight at the camera, so `inplace.py` holds
the pelvis on its first-frame floor position and moves the dumbbells back by
the same drift (a treadmill walk; the dumbbells stay 0.081 m from the hand).
Re-run it after any re-conversion of those three. Framing was solved at
`ASPECT=0.5832` and checked on stills from a `HARNESS_VIEW` harness (the
viewport alone at 382x655, with an optional `HARNESS_FRAMING` override), since
the trainer shows no model until content exists: barbell lifts at -0.8 (-1.0
for the front raise) so the bar stops shrinking the lifter, landmine presses
at -1.0, the Z press at -1.3, chest-supported raises at -2.8, the side-lying
raises from the chest side (+0.8/+1.0), and the cable upright row (+0.6) and
rear-delt machine (+2.4) from the side away from their stacks, which hid the
lifter at the usual angles.

Shared anatomy body (2026-09-26, trial on the 12 core models): every model
carried the same 125-mesh anatomy rig, ~18 MB of its ~19 MB, which put the
app at the 4 GB bundle limit. `share_body.py body` writes the rig and its
materials once to `Resources/Models/Shared/AnatomyBody.usdc`, and
`share_body.py slim` rewrites a model as a small layer that references
`AnatomyBody.usdc`'s `/root` and keeps only what differs: the animation, the
skeleton's rest pose, the muscle-highlight colours and the equipment
(0.03-1.2 MB each). RealityKit resolves the reference next to the model in the
bundle, so nothing in the app changed; composed stages matched the originals
attribute for attribute and the stills matched pixel for pixel. Order for a
new model: `convert_all.py` -> (`inplace.py`) -> framing/probe -> `share_body.py
slim`. Scripts that read models set `PXR_AR_DEFAULT_SEARCH_PATH` to the Shared
folder so slim models open with the body; Blender itself needs the body file
beside the model to import one.

Clip lengths (2026-09-26): the 190-240 exports sample the skeleton over
frames 7-187 (1-181 for the push presses) while the props run 1-192.
RealityKit loops each clip over its own samples, so in live playback the
dumbbells drifted off the hands a little more every loop (stills were
fine). `pad_clips.py` adds a held sample at the stage's first and last
frame to every animated attribute — the value USD already holds there — so
all clips share one length; `pad_one.sh` runs it on one model and keeps the
result only if `same_motion.py` finds the pose unchanged at every frame
(half-precision scales round by ~5e-4). All 221 models were padded; run it
on every new model before slimming. Pipeline order: `convert_all.py` ->
(`inplace.py`) -> framing/probe -> `pad_one.sh` -> `slim_one.sh`.

Legs 300-350 (2026-09-26): the drive's `300-350` folder (11 exports: the
builder's quads series 316-325 and `01_curtsy_lunge` from their 30-leg set)
was copied to `SourceExports/300-350` and converted with `convert_all.py
300-350/` into `Legs/`. 325 was built as a reverse lunge in the Smith machine,
so its resource and library name say Reverse. Split squats and lunges are seen
nearly side-on (-1.3) like the Lunge; barbell and Smith lifts at -1.0 so the
plates and rails stay off the lifter; the curtsy lunge at -0.5 so the crossing
step reads; the Barbell Lunge three-quarter from the front (-0.6, bar ends may
crop) because side-on the near plate hid the head and the long step shrank the
lifter to 0.57. Every model was padded (`pad_one.sh`) and slimmed
(`slim_one.sh`); all 11 matched attribute for attribute.

Re-exports without the user (2026-09-27): a headless
`bpy.ops.wm.usd_export(filepath=…, export_animation=True, selected_objects_only=False)`
on the saved .blend reproduced the user's own export of 316 attribute for
attribute (`equiv.py`: only the env light's texture path differed), so the
fixed sources were exported that way into `SourceExports/`: the eleven
`BLENDER/02_Dui_truoc` legs (toe-out 15° for the squats and presses, 10° for
the lunges, Bulgarian front foot and step-up; toe bones and a ball-of-foot
rear foot on the walking and reverse lunges) into `SourceExports/Legs/`, and
193, 223, 225, 226, 233 into `SourceExports/190-240/`. Then `convert_all.py`,
`graft_bar.py` for the Back Squat (its export still loses the bar meshes; the
previous app model was the donor), `inplace.py` for the Farmer's Carry,
`pad_one.sh` and `slim_one.sh`.
The thirteen `BLENDER/03_Dui_sau_Mong` hamstring/glute files got the same
treatment (toe-out 10° at frame 1, the same turn kept for the whole clip so
moving legs keep their motion; the leg curls and bridges follow a fixed child
empty `REVIEW_ToeOut10_*`, so the turn is keyed on its parent). Their exports
went to `SourceExports/Legs2/` (071 to `Legs/`); 081 in that folder is the
leaning abduction variant (`HipAbductionMachineLean`, now slimmed too), and
077 Barbell Hip Thrust is not in the app yet.

Knees and late additions (2026-09-27): turning the legs for toe-out left the
knees pointing inside the toes on the lunges, step-up, hinges, bridges, hip
thrust, kickbacks and abductions, so those 13 files had each leg turned about
its hip-to-ankle line until the knee points along the toe (hip, ankle and foot
untouched; scratch `feet/knee_fix.py`, noted in both `GHI_CHU.md`) and were
re-exported into `SourceExports/Legs/` and `Legs2/`. The upright Hip
Abduction Machine (`BLENDER/exercises_50_100/081_hip_abduction_machine`, IK
feet on the machine's foot empties) got the same 10° toe-out and replaced
`Legs2/081_hip_abduction_machine.usdc`. 191 Seated Barbell Overhead Press and
199 Z Press were rebuilt through `_v2_build` with the rack fix (`cloud_fix`,
`mid_fwd`, `step`) and re-exported into `190-240/`. New jobs: 207 Seated
Dumbbell Lateral Raise, 222 Cable Rear Delt Row, 224 Dumbbell Upright Row and
077 Barbell Hip Thrust.
