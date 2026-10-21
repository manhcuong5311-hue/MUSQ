# Model pipeline (raw Blender USD -> app-ready usdc)

Run with Blender's Python, which ships `pxr` and numpy:
`/Applications/Blender.app/Contents/Resources/5.1/python/bin/python3.13`

1. `survey2.py`, `survey3.py`, `pose2.py` — up axis, frame range, lights, parked
   props, equipment prims, which way the lifter faces.
2. `convert_all.py` (+ `curves2mesh.py`) — Z-up -> Y-up wrapper, lights and
   off-stage props deactivated, BasisCurves rebuilt as meshes, flattened into
   `GymWorkout/Resources/Models/<Group>/<Name>.usdc`. Edit `JOBS` per batch.
   Raw exports are read from `SourceExports/`, never from `Resources/`.
   Then `one_side_tiers.py <model.usdc> ...` on every converted model (see
   "One-sided highlights" below); it leaves two-sided lifts alone.
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

Batch 241-300 (2026-09-27): the drive's `241-300` folder had 26 exports
(241-280; the other sources in `BLENDER/exercises_191_280` were not exported).
They were copied into `SourceExports/241-300/`, converted into `Biceps/` and a
new `Forearms/` folder, padded and slimmed as usual, and framed with
`solve_all.py` (ASPECT=0.5832). The cable curls are framed from the side away
from the tower (the one-arm cable curl from its working side), and the barbell
preacher and drag curls nearer front-on so the plates clear the trunk and arms.

Grip holds redone (2026-09-28): the user re-saved 277-280 (Plate Pinch,
Dumbbell Static, Barbell Static, Towel Grip Hold) with only the forearms
highlighted (the triceps were red too) and exported them *without animation*
into the drive's `241-300/27:09` folder, on purpose: the holds are still. Such
an export carries the pose as the skeleton's `restTransforms` and binds no
SkelAnimation (Blender writes the evaluated pose there, so it matches what the
.blend shows). `convert_all.py` now accepts a static stage, and
`hold_static.py` writes that rest pose into the SkelAnimation as a held sample
at frames 1 and 192 and binds it, so the models play an 8 s still clip like
before (the fault ghosts and thumbnail stills assume a clip). Order:
`convert_all.py` -> `hold_static.py` -> `slim_one.sh` (no padding needed).
Against the previous models the body moved at most 2.3 cm (left leg on the
two static holds, hands on the towel hang) and the props not at all, so the
framing was kept.

Arnold Press redo (2026-09-28): the palms turned the wrong way. From
palms-to-face they supinated further (palms out, thumbs forward at frames
13-17) before reaching palms-forward, twisting the forearms ~230° with a flip
at 15→17 (60→80 on the way down): `exercises_13_49/build.py` (idx 30) swept
the palm axis through the forearm's own direction. The app's model came from
the user's edited `BLENDER/exercises_13_49/BLENDER/02_Vai/30_arnold_press.blend`
(elbow poles and seat moved), matched joint for joint. Only the
`CTRL_hand_ik_L/R` rotation keys (49 frames) were re-keyed there so the palms
pronate — to the face, facing each other, forward — with straight wrists, and
the dumbbells re-keyed from the new palms (script, notes and the original
.blend in `02_Vai/_backup_truoc_sua_xoay_tay_20260928/`). Forearm twist now
runs -25° → +93° with no flip; contact 0.5 mm. Exported headless into
`SourceExports/Shoulder/`, converted, padded and slimmed; against the old model
only the hands, forearm muscles and dumbbells moved (up to 12 cm mid-turn, none
at the top), so framing, thumbnail and fault ghosts were kept. The build copy
in `exercises_13_49/30_arnold_press/` and build.py still carry the old bug.

30-leg set 02-27 (2026-09-28): the drive's `300-350/27_9` folder (23
exports of the builder's 30-leg set: lateral lunge, Cossack and sumo squats,
kettlebell goblet, box, pause, safety-bar, Zercher, overhead and landmine
squats, belt, pendulum and V-squat machines, vertical, 45°, single-leg,
narrow- and wide-stance leg presses, heel-elevated, cyclist and pistol
squats; 16, 22 and 23 were not exported) was copied to
`SourceExports/300-350/` and converted with `convert_all.py <stems>` (pass the
stems: a bare `300-350/` also matches the older 300-350 jobs, whose sources
are no longer in SourceExports) into `Legs/`, padded and slimmed. The box,
safety-bar and Zercher clips run 10 s and the pause squat 12 s. Framing was
solved at `ASPECT=0.5832` and checked on viewport stills: free squats from
the front-left (-0.5 to -1.0), the side-shifting lateral lunge and Cossack
squat near front-on (-0.3; the lateral lunge's 1.1 m of travel keeps its
lifter small at 0.60), the landmine squat at -0.9 with its 1.5 m bar left to
crop, the pendulum and V-squat side-on (-1.3), the belt squat side-on too (-1.5;
from the front-left its weight trolley and plates hid the knees and feet),
and the leg presses from the rear three-quarter (-2.0; -2.2 for the vertical press) — from the front the
sled and frame hid the lifter, side-on the near upright crossed the legs, and
from behind the back pad hid the trunk. The assisted pistol is turned to -1.6
so its upright stands behind the head. `Tools/trainer-content/briefs_legs30/`
holds a motion brief per model (`brief.py`: knee, hip, thigh and shin angles,
trunk lean, ankle and hand positions and moving equipment every 0.5 s, rep
phases from pelvis height or, for the presses, knee angle).

Calves 083-087 (2026-09-28): the drive's `Calf 83-` folder (standing machine,
seated, leg-press, single-leg and Smith machine calf raises) was copied to
`SourceExports/Calf/`, converted into `Legs/` with `convert_all.py Calf/`,
padded and slimmed. Framed at -1.3 (standing, seated, single-leg: the heel
rise reads from the side), -2.4 for the leg-press calf raise (rear
three-quarter, as the leg presses) and -0.8 for the Smith calf raise (from
further round, the stored plates and the rails cover the lifter). `brief.py`
now also writes the ankle angle and foot pitch and reads calf raises' rep
phases from the ankle angle. The standing models lower the heels only to about
flat (ankle ~99°), not below the step.

Exercises 1-50 redone (2026-09-29): the user re-did 1-50 in Blender and
exported them to the drive's `1-100 🟢` folder (with 061-190 and the named
gated/extra models, which were left for later). The 35 numbered files 01-050
(the 🟢 copy of 33; 12, 18-22, 26, 30-32, 34, 38, 40, 41 and 43 were not
redone) were copied to `SourceExports/1-50/` without the 🟢 marks and
converted with `convert_all.py 1-50/`, padded (`pad_one.sh`) and slimmed
(`slim_one.sh`, all attribute-for-attribute). 26 replace existing models; 15
Pendlay Row, 42 Dumbbell Curl, 44 Incline Dumbbell Curl, 45 Preacher Curl (EZ
bar), 46 Cable Curl, 47 Bayesian Cable Curl, 48 Reverse Curl, 49 Wrist Curl
(`Forearms/`) and 050 Close-Grip Bench Press (`Triceps/`) are new. The user's
`01_barbell_bench_press.usdc` had lost its armature — 120 one-joint
skeletons, no motion — because the .blend's `RIG` collection had its render
toggle off (the exporter evaluates in render mode); it was re-exported
headless from `BLENDER/chest_series 🟢/01🟢_barbell_bench_press/` with
`bpy.data.collections['RIG'].hide_render = False` (not saved). A headless
export of 02 matched the user's except the camera. Old models are kept in the
session scratchpad (`old/`) for comparison. What changed: mostly the muscle
highlight tiers (rows now light the rear delts, cuff, rhomboids and traps
bright and the lats dim; the deadlift the quads bright; the flies the biceps
dim; the front raise the side delt; the rear-delt lifts the cuff), plus arm
paths on the bench press (continuous reps, elbows tucked ~5 cm), chest press
machine, bent-over row, one-arm row, straight-arm pulldown and the presses,
and moved equipment (incline/decline racks, row bench and pads, back
extension rail). The Chest-Supported Row Machine's skeleton root bone now
sits 0.51 m under the floor; it is not drawn, so `framer.py` (and the
thumbnails' `framer_still.py`) now leave the `root` joint out.
The new exercises were framed with `solve_all.py` at `ASPECT=0.5832`:
curls and the reverse curl at -0.4 like the Biceps Curl, the incline curl
-0.9, the preacher curl -0.8, the cable curl from the side (-1.4, its two
low columns crop), the Bayesian curl -1.2 (its column behind on the left),
the wrist curl -0.7 like the Dumbbell Wrist Curl, the Pendlay row -2 like the
bent-over row, and the close-grip bench on the shared `.bench` preset.

Exercises 51-150 redone (2026-09-30): the same `1-100 🟢` folder's 49 files
numbered 51-150 (the 🟢 copies of 062 and 091; `Step-Up` = 069 and
`Single 🟢-Leg_Glute_Bridge` = 079) went to `SourceExports/51-150/` and were
converted with `convert_all.py 51-150/`, padded and slimmed; all 49 replace
existing models (resources unchanged). To save disk the raw copies of both
batches were removed from `SourceExports/` afterwards (the drive keeps them;
only the headless 01 re-export is kept in `SourceExports/1-50/`). Every export was intact (one 205/207
joint skeleton, no cameras). The changes are again mostly the highlight tiers
(the rows as in 1-50; push-up variants now light the triceps bright; the
glute bridges the quads; the RDLs, deadlifts, lunges and hangs the forearms
dim), a few hand/handle moves (Leg Press arms onto side handles, Cable Hip
Abduction, Single-Arm Landmine Press, Single-Arm Cable Fly) and small
machine-part moves. The Leg Press is now framed from the rear three-quarter
(-2.0) like the 45-Degree Leg Press: at -0.6 the footplate hid the lifter and
the new arms left the frame. `convert_all.py` now also deactivates Camera
prims (the redone 04 Dumbbell Bench Press carried two, and RealityKit could
render through them).

Exercises 151-190 and the gated models redone (2026-09-30): the last 37 files
of the `1-100 🟢` folder — 151-157 (not 153), 161-165, 167-174, 176-190 and
the gated `Biceps_Curl`, `Lunge` and `Lunge_Lean 🟢` (the 🟢 copy) — went to
`SourceExports/151-190/` and were converted with `convert_all.py 151-190/`,
padded and slimmed; all 37 replace existing models (resources unchanged).
Every export was intact (one 205/206-joint skeleton, one animation, no
cameras). Biceps Curl came back attribute-for-attribute identical to the app
model. The rest changed almost only in their highlight tiers: the rows as in
1-150 (rear delts and rotator cuff bright beside the upper back, lats dim;
Gorilla Row also the biceps bright), and the pull-ups and pulldowns the other
way (lats alone bright, trapezius and rhomboids down to dim; the Machine Lat
Pulldown kept its tiers). Motion is unchanged on 29 models; the Lunge and
Lunge (Lean) hold the elbows ~17 cm further back, and the Meadows Row,
Wide-Grip Lat Pulldown (top elbow 149° instead of 165°), Dumbbell Pullover Row
and V-Bar Lat Pulldown moved the elbows 3-16 cm. A few machine parts were
removed (thigh-roll supports, pull-up assist guides, a base tie) and the
Neutral-Grip Pull-Up's parallel handles rebuilt. Framings were kept.
To save disk, `SourceExports/151-190/` was removed afterwards (the drive
keeps the files).

Redone 190-280 folder (2026-09-30): the drive's `190-280 🟢` folder held 22
exports — 21 shoulder, carry, curl and grip models already in the app, and
264 Machine Preacher Curl, new (`Biceps/MachinePreacherCurl`, the Q191 curl
machine with both arms). Copied to `SourceExports/190-280/`, converted with
`convert_all.py 190-280/`, `inplace.py` for the Suitcase Carry (it walks
2.8 m), padded and slimmed. The grip holds 277-280 came as animated clips
this time (pose within 2 cm of the static ones), so `hold_static.py` was not
needed. The dumbbell and landmine presses changed their arm paths (hands up
to 32 cm), so the Neutral-Grip, Standing and Single-Arm Dumbbell Presses and
the Half-Kneeling Landmine Press were re-solved (ASPECT=0.5832); the Machine
Preacher Curl is framed like the Single-Arm Machine Curl (-1.0).
The 225 Cable Upright Row now runs one centre cable: the user shrank the
unused left cable's pieces to a zero scale, which made `ComputeWorldBound`
return ±1e38 and parked the whole cable station. `convert_all.py` now
switches off zero-scaled parts (`collapsed`), reads the parking test from
the remaining meshes only, and takes an `OFF` list of parts to switch off by
hand (the three left-cable pieces that still drew a line between the feet).
The raw copies in `SourceExports/190-280/` were removed afterwards to save
disk (the drive keeps them); re-copy them before re-converting.

351-400 folder (2026-09-30): the drive's `351-400` folder held the 27
🟢-approved exports of the builder's 356-400 hamstring/glute set (372,
376-380, 383-392, 394 and 399 were not exported). All are new: copied to
`SourceExports/351-400/`, converted with `convert_all.py 351-400/` into
`Legs/`, padded and slimmed. The Assisted Nordic Curl's elastic band is a
skinned mesh with a one-joint skeleton of its own, exported ahead of the rig:
the app's joint tracking (`USDZViewport.track`) now looks under
`Anatomy_MasterRig` first, and the Tools scripts that took the first
skeleton they met now sort the rig's to the front. Framings were solved at
`ASPECT=0.5832` and checked on stills: single-leg and B-stance RDLs and the
leg curls side-on (-1.3), Smith and cable lifts -1.0, kettlebell RDL and
dumbbell deadlift -0.8, the standing and seated good mornings from
behind-left (-2.3; side-on the near plate hid the head), Nordic and GHR -1.4
(the Nordic framed on the lifter, its floor rail left to crop), floor curls
-1.35, frog pumps side-on (-1.57), adduction/abduction -0.3, and the
side-lying abduction and clamshell from behind (3.14) so the lit glutes show.
The raw copies in `SourceExports/351-400/` were removed afterwards to save
disk (the drive keeps them).

401-500 folder (2026-10-04): the drive's `1-500/401-500` folder held 141
exports: re-exports of models already in the app (056-376, several marked
🟢/🔴) and the builder's new 401-500 set. Asked for "30 new from 106", the 30
exports from 106 on whose exercise was not in the app were copied to
`SourceExports/401-500/` and converted with `convert_all.py 401-500/`: 127
Landmine Chest Press, 129/130 Chest Dip and Weighted Chest Dip, 132 Decline
and 136 Plyometric Push-Up into `Chest/`; 246 Rope, 248 Cross-Body and 249
Incline Hammer Curls, 251 Zottman, 255 Strict, 256 21s (`Curl21s`), 257 EZ-Bar
21s, 258 Waiter, 262 Dumbbell Reverse and 267 Seated Dumbbell Curls into
`Biceps/`; 275 Wrist Roller into `Forearms/`; 376 Dumbbell Hip Thrust and
thirteen calf raises (401, 403-414; 411 is `SingleLegMachineCalfRaise`, 414
`BodyweightCalfRaise`) into `Legs/`. The re-exports were left alone. Every
export was intact: one 211-joint skeleton, one animation, no camera prims
(the `*_Camera`/`REVIEW_Direct_*` prims are empty xforms); 256 and 257 run
1-1056 (44 s, 3 x 7 reps). All 30 were padded (`pad_one.sh`) and slimmed
(`slim_one.sh`, attribute for attribute, 0.6-3.2 MB). Framings were solved at
`ASPECT=0.5832` and picked on viewport stills: curls at -0.4/-0.5 like the
Dumbbell Curl, the incline and seated curls at -0.9/-0.6, the rope hammer curl
from the side away from the tower (+1.4, like the Cable Hammer Curl); the two
barbell curls side-on enough that the 2.2 m bar stops shrinking the lifter
(-0.9 for the 21s, -1.0 for the Strict Curl, its wall behind); the landmine
press at -0.8 framed on the lifter with the bar left to crop; push-ups -1.2,
dips -1.0, the hip thrust -0.7 like the Barbell Hip Thrust; standing, donkey
and dumbbell-seated calf raises side-on (-1.3); the barbell seated raise -0.8
(side-on its near plate hid the knees), the Smith seated raise -0.4 (from the
side the plate and uprights hid the lifter), the hack squat raise -0.6 like
the Hack Squat, and the calf press and horizontal leg press raise -1.3 with
their machines left to crop (from behind the seat backs hid the lifter).
The raw copies are in `SourceExports/401-500/` (about 550 MB; the drive keeps
them too, so they can be removed).

Second round from the same folder (2026-10-04, "thêm tiếp 30 bài"): the next
30 new exports by number, 415-444, copied to `SourceExports/401-500/` and
converted by passing their number prefixes (`convert_all.py 401-500/415_ …`;
the first round's raw copies had been removed to free disk): six more calf
lifts and five tibialis raises into `Legs/`, nineteen sit-ups, crunches,
cable/machine crunches, V-ups, the dead bug, bird dog and hollow body work
into `Abs/`. All intact (one 211-joint skeleton, one animation, no cameras),
padded and slimmed (0.5-1.6 MB). The floor lifts lie on a mat, which
`solve_all.py` counts as equipment and which halved their zoom; they were
solved with the mat left to crop (`body`), at -1.35 (side-on, like the
Reverse Crunch) or -0.8 where a twist, an alternating limb or the band reads
better from the front-left. Standing calf and tibialis lifts are side-on
(-1.3), the walk on toes -1.0, the banded seated ones -0.8, the cable
crunches -1.35 (the oblique one -0.4, so the side bend reads), the machine
and Ab Coaster crunches -1.35. The Toe Touch Crunch is seen from behind the
head (-2.3, zoom 0.85, set by hand): side-on, its curled trunk hides behind
the vertical legs, and the solver's own answers for this pose came out far
too close (zoom 1.0-1.4 with large offsets), so check a compact pose's solve
on a still before trusting it. Nine new exports numbered 380-399 appeared in
the folder that evening (and re-exports of 19 and 320); they were left for a
later round.

Third round, 445-474 (2026-10-05, "30 bài tiếp theo"): the session
scratchpad holding the round-1/2 helper scripts was wiped (a reboot clears
/private/tmp), so the helpers were rewritten into the repo: `integrity.py`,
`facing.py`, `tiers.py`, `solve_pick.py` here and the shooting/lab scripts in
`Tools/lab/`. The round-2 raw copies were removed and 445-474 copied in;
all intact (211-joint skeleton, one animation, no cameras), converted into
`Abs/` (leg raises and kicks, planks, side bends, chops, rotations, twists,
rollouts, the bear crawl, carry marches), `Legs/` (three thrusters) and
`Shoulder/` (Clean and Press), padded and slimmed (0.5-1.3 MB). The RKC,
weighted and Copenhagen planks hold still; the carry marches march in place;
the bear crawl rocks ~14 cm. Framings were picked on stills of two
candidates each: floor and plank work side-on (-1.35) or front-left (-0.8)
with the mat left to crop, the hanging oblique knee raise -0.5 so the twist
reads, side bends, chops and rotations near front-on (-0.3 to +0.5, the cable
station kept out of the lifter's way), thrusters and the clean and press
-0.6/-0.8. The Side Plank Hip Lift and Copenhagen Plank are seen side-on
(+1.5, like the Side Plank): front-on, the solver again returned an
over-zoomed framing (as for the Toe Touch Crunch).

Desktop "1-100" folder (2026-10-10): 55 exports on `~/Desktop/1-100` (plus
a `textures/` folder for the female model). 34 re-export models already in
the app — the 22 male exports marked 🟢 (050-099, the 🟢 copy of 052) and
twelve of the 30-leg set (01, 04-09, 12, 24-27, unmarked) — and were copied
to `SourceExports/1-100-1010/` without the marks, converted with
`convert_all.py 1-100-1010/`, padded and slimmed (all attribute for
attribute). 081 is the leaning abduction variant's .blend (as in `Legs2/`
since 2026-09-27): its body matches `HipAbductionMachineLean` joint for joint,
so it replaced that model; the upright Hip Abduction Machine keeps its
2026-09-27 model. Left out at first: the exports still named 🔴 (052's older
copy, 057, 062, 068, 071, 072; see below), five new leg exercises (below)
and ten exports of the female model (a 235-joint rig with its own textures:
the 01-05 leg-press stances, three of them also marked 🟢, the 097 ab wheel
rollout and cable step downs), which the app has no body for. All 34 are
intact: one 211-joint skeleton (the 205 of the old models plus `toe_L/R` and
four `FF_` foot helpers), one animation, no cameras. The old models are kept
in the session scratchpad (`old/`). Sixteen came back with the same body
motion (Cable Glute Kickback also with the same paint and equipment, only its
materials restructured; the Lean abduction with a tidied machine), six moved
by 2-7 cm (the hands on four, the elbows on the Bench Dip, the knees on the
Landmine Squat), and twelve changed: the Cable Wood Chop is now a long-armed
high-to-low chop (the hands up to 91 cm from where the old clip had them, the
whole body also shifted), the Step-Up leans further forward at the start, and
the Curtsy Lunge, Barbell Hip Thrust, Close-Grip Bench Press, Dumbbell
Overhead Triceps Extension, Single-Arm Cable Pushdown, Decline Crunch,
Heel-Elevated Squat (the bar), the two pistols and the Single-Leg Glute
Bridge moved the arms, the bar or the free leg 11-28 cm. Several got new
equipment: the GYM bench under the Skull Crusher, Bench Dip, Close-Grip Bench
Press and Barbell Hip Thrust, an ABB decline bench under the Decline Crunch,
a slant board in place of the heel wedges, and recoloured mats and pads. The
twelve, the Bench Dip and the Landmine Squat were checked on old/new trainer
stills at their framings; all framings were kept.
The new highlight materials are `FF_Highlight_<Group>_<side>`, one per
muscle group, so a group lights together (all three glutes on the abduction
machine, the soleus with the gastrocnemius on the calf raises). Blender
drives their colour. Most exports carry the level in the diffuse (1.0
bright, 0.256 dim) with a matching emissive (0.153 / 0.038), the emissive on
the working side only in one-sided lifts; on the Lean abduction's glutes and
the Seated Calf Raise's calves the diffuse is capped at 0.15 and only the
emissive shows the level, which RealityKit still shows as the same hot red.
`tiers.py` now takes the larger of the diffuse and the emissive / 0.153.
The same folder's five new exercises (22 single-leg extension, 23 Smith
machine front squat, 28 dumbbell lateral step-up, 29 barbell step-up, 30 hip
adduction machine) went in the same evening: copied to
`SourceExports/1-100-1010/`, converted (`convert_all.py 1-100-1010/22_ …`),
padded and slimmed (0.8-1.2 MB). The single-leg extension works the left
leg only (knee 93°->168°, two reps); the lateral step-up's box sits at the
lifter's left; the barbell step-up plants the left foot on a box in front;
the adduction machine closes the knees from 0.78 m apart to 0.24 m. Framings
were picked on stills: the leg extension and Smith front squat at -1.0, the
lateral step-up front-on (0) so the sideways step reads, the barbell step-up
at -0.9 like the Step-Up, the adduction machine at -0.3 like the abduction
machine. The single-leg extension lights the glutes bright with the quads,
though a seated knee extension barely uses them; the content keeps them a
low secondary row until the paint is settled.
The folder's five exports still named 🔴 (057 Assisted Dip, 062 Bulgarian
Split Squat, 068 Smith Machine Squat, 071/072 Romanian and Dumbbell Romanian
Deadlift) are the approved versions: their .blend files on the drive are
renamed 🟢 and were exported right after their last save; only the export
names kept the old notes (the owner confirmed). They replaced the app's
models the same way (`SourceExports/1-100-1010/`, converted, padded, slimmed;
old copies in the scratchpad's `old/`). The two RDLs now bend the knees from
20° standing to 42° at the bottom of the hinge (18-30° before) and send the
pelvis 29 cm back (22 cm); the Smith Machine Squat stands in a new Smith rack
(`GYM_M30_Root`) with a new bar; the Bulgarian Split Squat's rear foot rests
on a new GYM bench; the Assisted Dip's chest and front delts are now painted
bright. Framings were kept (checked on old/new stills).

Female model (2026-10-10): the folder's ten female exports are a separate
235-joint rig (the male rig's joint names plus the same toe/`FF_` foot
joints) with three JPEG base colours (skin/head, sports bra, shorts). The
owner asked for them in the main library, with no female mode: the two
stance sets became one exercise each with a stance picker in the trainer
(see below), 097 replaced the male Ab Wheel Rollout, and the cable step-down
is new. The sets are two machines: the Pendulum Squat (`Pendulum Varian🟢`,
exports 01/02/03/05 at 192 frames; 04 wide had no export and was exported
headless from its approved .blend) and the Hack Squat (`Done 🟢 HackSquat
Varians`, exports 02/04/05 🟢 at 144 frames; 01 and 03 exported headless; a
headless export of 02 matched the owner's attribute for attribute except the
texture paths). The older 04_wide_stance (01:51) was superseded. All twelve
go through `female_pipeline.sh`: `convert_all.py female-1010/` (the jobs
switch off each export's studio floor, which the app does not hide),
`retex.py` (Flatten() anchors the texture paths to the source folder; they
are rewritten to bare names, `FemaleShorts/FemaleBra/FemaleHead_basecolor.jpg`,
copied into `Resources/Models/Shared` so they sit next to every model in the
bundle; RealityKit shows them), `pad_one.sh`, `rename_rig.py` (the hack-squat
exports name their rig `Anatomy_MasterRig_001` beside an empty inactive
`Anatomy_MasterRig`; the rename re-points 293 target lists, joints unchanged)
and a slim against a female body. The pendulum set, the ab wheel and the
step-down share `Shared/AnatomyBodyFemale.usdc` (63.5 MB, built from the
standard pendulum); the hack squat's rig is pressed against its back pad, so
its meshes differ and it has its own `Shared/AnatomyBodyFemaleHack.usdc`.
Every model slims to 0.8-1.9 MB, attribute for attribute. `share_body.py`
now writes the reference to whichever body it slims against.
Framings: the hack squat from the front-left three-quarter (0.6), so the
stance width reads; the pendulum side-on (0): from either three-quarter its
pivot column or its pad hides the lifter; the step-down at -1.0. The
pendulum's stances light different muscles (high: glutes; low and standard:
quads; wide: adductors and sartorius; narrow: vastus lateralis), and so do
the hack squat's.

Re-exports the same evening (owner): 22 Single-Leg Extension with the glutes
unlit and 05 Barbell Sumo Squat with the erectors dim, like the Back Squat.
Both came back with the same motion (0.0 cm) and equipment; converted,
padded, slimmed, and their tiles re-shot.

Desktop "100-200" folder, part 1 (2026-10-11): `~/Desktop/100-200` holds 77
exports, 103-200 and a few of 201-272, all re-tuned by the owner in Blender
(machines swapped for the `Gym_CacMayMoi` library ones, red notes fixed,
muscles re-painted); the owner asked for every file to replace its model,
the unchanged ones too, since their paint changed. The 46 whose body motion
matches the app model went first: copied to `SourceExports/100-200-1011/`
without the spaces in their names, converted with
`convert_all.py 100-200-1011/`, padded and slimmed (all attribute for
attribute, 68 MB for the 46). All intact: one 211-joint skeleton, one
animation over 1-192, no cameras. The old models are kept in the session
scratchpad (`old/`). Against the app models (world-space hands, feet,
forearms, shins, head and pelvis every 4 frames): 40 within 0.9 cm; 241-243
within 2-7.5 cm; 105, 116 and 120 lift the whole lifter 25 cm onto the N11
decline bench (the drive's `Fix_101_120` round) with the joint motion
otherwise unchanged. Equipment: Smith M30 on 103-105, the GYM bench under
106-112, 115, 119, 138, 139 and under the hands or feet of 131/132, the
M29 dual pulley on 113-120, 174, 181 and 182 (3.1 m wide and 2.34 m tall
where the old towers were 2.5 m and 2.05 m; the single-arm lifts now stand
in the whole station, and the pulldown and rows have it in front of the
lifter), the N11 decline bench on 105/116/120, and M04 with the shared lat
pad set on 173. The twenty shoulder, curl and wrist models (198-272) kept
their equipment. Paint: 34 kept their tiers; twelve changed (triceps and
front delts bright on the one-arm and decline presses, the side delt on the
landmine presses, the front delt on the one-arm cable fly, the side delt and
triceps on the Single-Arm Dumbbell Shoulder Press with the front delt dim,
the trapezius and rhomboids down to dim on the Cable Y-Raise and Lu Raise,
the brachialis down to dim on three curls). Every trainer framing was kept:
old/new viewport stills at 0 and 2 s show each lifter clear of the new
machines and nothing cropped (`solve_pick.py`, which counts the new
`toe_`/`FF_` joints as body, would have zoomed the bench lifts out 5-10%).
Part 2 is the other 31 files: 27 whose motion changed (122-126, 129, 130,
168-172, 175-180, 183-187, 190, 196, 202, 203), the 158 Smith high/low and
173 side-lean variants (to join their exercises as pickers, owner's call)
and 237 Concentration Curl (new).

Desktop "100-200" folder, part 2 (2026-10-11): the other 31 files went to
`SourceExports/100-200-1011/` and were converted, padded and slimmed the
same way (all attribute for attribute, 81 MB): 27 re-exports whose motion
changed with their new machines and the owner's red-note fixes, the two 158
Smith inverted rows (`Back/InvertedRowSmithLow`, bar 0.75 m;
`Back/InvertedRowSmithHigh`, bar 1.08 m), the 173 side-lean pulldown
(`Back/SingleArmLatPulldownSideLean`) and 237 (`Biceps/ConcentrationCurl`,
new). All intact (211 joints, one animation over 1-192, no cameras). The 27
moved hands, feet or head 12-70 cm against the app models (world space):
the chest machines now sit the lifter on N29 (iso-lateral, plate-loaded),
the rebuilt incline press, N28 (decline) and the rebuilt wide press with
the torso leaned onto the back pad; the dips round the upper back (torso
40->57°); 168 kneels on N32; 169-175 share the black rounded seat and thigh
rollers (169/170 lean back to ~30° and pull the bar to the upper chest);
176/177 pull N24's shortened levers; 178-180/184 sit on the seated-row
station, 183 on M29; 185-187 row the plate-loaded iso-lateral machine; 190
uses a new pullover machine; 196, 202 and 203 were re-made by the owner on
2026-10-10. Paint changed on eight: the dips' triceps down to dim, the Rope
Lat Pulldown's trapezius and rhomboids down to dim, the biceps bright on
the two one-arm rows, the trapezius and rhomboids newly dim on the Seated
Dumbbell Press, and the triceps bright on the Single-Arm Cable Shoulder
Press. Both cable shoulder presses and part 1's Single-Arm Dumbbell
Shoulder Press had come with the front delt dim, a paint slip (owner,
2026-10-11): `MH_FrontDelt` was set back to 2 in the three .blend files
headless, saved in place and re-exported with the owner's settings
(`usd_export(export_animation=True, selected_objects_only=False)`; a test
export of an untouched file matched his own except UV noise of 6e-8 and the
environment texture path), the new exports differing from his only in the
front delt colours; they replaced his files in `~/Desktop/100-200` and the
app models (drive folder `Fix_FrontDelt_20261011`, with backups).
Framings: old/new viewport stills at 0-5 s and solver candidates. Nineteen
kept theirs; the dips (head at the top edge with the deeper lean), the
Machine Pull-Up (hands above the frame), the Machine and Iso-Lateral Lat
Pulldowns (hands above the frame), the Seated Dumbbell Press (dumbbells at
the top edge) and the Cable Shoulder Press (a small lifter in the M29) took
`solve_pick.py`'s; the Decline Chest Press Machine is now seen from the
front (yaw 0), since N28's yellow lever arms hid the lifter from -0.7, 0.7
and ±1.3. The Inverted Row now shows the Smith low bar, from behind the
head (-2.2; side-on the near plate hid the lifter), with the low and high
bars as stances; the old bar-stand model (`Back/InvertedRow`) is no longer
used. The side lean joins the Single-Arm Lat Pulldown as a second stance at
its framing (-2.6). The Concentration Curl is framed at -1.2, the working
left arm toward the camera. `probe.py` carries the new framings.

Desktop "300-400" folder (2026-10-12): `~/Desktop/300-400` holds 38 exports
(318-400): 26 re-exports of legs in the app, re-tuned by the owner (machines
swapped for the `Gym_CacMayMoi` ones, red notes fixed, muscles re-painted),
and twelve new: 377 Smith Machine, 378 Machine, 379 Single-Leg and 380
B-Stance Hip Thrusts, 383 Cable Pull-Through, 387 Standing Cable Hip
Extension, 388 Reverse Hyperextension, 389 Single-Leg Back Extension, 390
45-Degree Hip Extension (`Legs/HipExtension45`), 391 Kettlebell Swing, 392
Sumo Kettlebell Deadlift and 394 Kettlebell Deadlift, all into `Legs/`.
`SourceExports/300-400-1012/` holds them as hard links to the Desktop files
(byte-identical; the disk was full), converted with
`convert_all.py 300-400-1012/`, padded and slimmed (all attribute for
attribute, 0.7-2.4 MB each). All intact: one 211-joint skeleton, one
animation over 1-192; 320 carried a camera, switched off. The old models are
kept in the session scratchpad (`old/`). Against the app models (world-space
hands, elbows, feet, knees, head, pelvis, hips and chest every 4 frames): 13
within 1 cm (318-320, 322, 356, 358, 365, 368, 370, 393, 396, 397, 400); 364
and 360 shift the whole lifter 6-7 cm in their new bench and rack; 362, 361
and 359 hinge with the hands and head 10-16 cm off; 325, 323 and 324 change
the step (knees and feet 12-19 cm); 376 moves the head and elbows 14-15 cm on its new
bench; 371 and 395 hold the new station elsewhere (the hands and the left
elbow 12-27 cm); 398 rests the hands elsewhere (26-30 cm); 369's working foot
runs up to 31 cm from the old clip's. Equipment: the M30 Smith rack on
318, 320, 325, 360 and 365; the M29 dual station on 361 (with a new straight
bar), 371 and 395; the GYM bench under 364, 376 and 398, and moved on 319; a
new GHD on 368; 369's chest pad moved. Paint changed on five: the glutes now
bright on 319, 320 and 322 (adductors unlit; 320 also lights the hamstrings
dim), the quadriceps dim on 356, and the quadriceps bright with the forearms
dim on 393. Framings: the M30's near upright crossed the lifter at -1.0, so
318, 320 and 325 are now -0.7, 360 -0.6 and 365 -2.5 (behind-left, like the
other good mornings); the M29 tower hid 371's lifter at -1.3, so it is -2.1.
The others kept theirs (old/new viewport stills at 0-3 s). The new twelve
were solved with `solve_pick.py` and picked on stills: the hip thrusts at
-0.7 like the Dumbbell Hip Thrust (the Smith rack's plate hid the lifter
further round), the pull-through and swing side-on (-1.3), the standing cable
hip extension -1.8 (the M29 tower is in front of the lifter, and from -1.0 to
-1.35 it covered them), the reverse hyper -1.4, both back-extension benches
-1.9 like the Back Extension, the sumo kettlebell deadlift -0.5 and the
kettlebell deadlift -0.8 like the dumbbell deadlifts.
Disk (2026-10-12): the volume ran full during this round. The raw copies in
`SourceExports/` were first hard-linked to their byte-identical Desktop
originals, then (owner's call, after the round) the `1-100-1010`,
`100-200-1011`, `300-400-1012`, `151-190`, `241-300`, `300-350`, `401-500`
and `Calf` folders were moved to the Trash; re-copy the exports (or
re-export from the drive's .blend files) before re-converting any of them.
`1-50/` and `Shoulder/` (headless re-exports kept nowhere else) and
`female-1010/` stay.
398's export put the SkelRoot on /root rather than on the rig (its mini band
is now skinned to the rig's skeleton, outside `Anatomy_MasterRig`), and the
wrapper's `/root` Xform overrode it, so nothing was under a SkelRoot and the
app drew the body in its standing rest pose. `convert_all.py` now keeps a
SkelRoot type on the wrapper when the export's /root has one; 398 was
re-converted, padded and slimmed (the other 37 exports keep their SkelRoot
on the rig, as before).

One-sided highlights (2026-10-12): the owner paints one-sided lifts on the
working side only, but the app lit both sides. In the .blend the
`FF_Highlight_<Group>_<side>` materials take their Base Color from a
side-aware "Fitness side color" mix (the resting side's factor is 0, so it is
the mix's Color1, the unlit 0.0075 grey), while the Principled BSDF's Base
Color socket still carries an older side-blind driver. The USD exporter cannot
follow the mix, so it writes that stale socket value: the resting side came
out as red as the working one (1.0 bright, 0.206-0.256 dim), and only the
emissive (0.18 x the side factor) kept the side. Re-exporting does not help (a
fresh Cable_Step_Downs export the same evening had it too).
`one_side_tiers.py` sets a group's diffuse to the unlit grey when it is lit
with no emissive while its other side glows; 58 models changed (every
one-sided lift: single-arm rows, curls and presses, split squats, step-ups,
single-leg hinges and curls, kickbacks, abductions, side planks and bends),
each differing from before only in those diffuse values (`equiv.py`). Their
57 library tiles were re-shot. Run it after `convert_all.py` on every batch.

SSD "1-500/1-100" folder (2026-10-17): the owner re-saved all 99 exports
on 2026-10-14..16. They went in as plain swaps, to be re-tuned again
later; trainer content (cues, muscle rows, labels), fault ghosts and
library tiles were left as they were (owner's call). Copied to
`SourceExports/1-100-1017/` without the emoji and spaces in their names
(`_names.tsv` maps them back); the older non-🟢 `068_smith_machine_squat_narrow`
duplicate was left out. Against the app models (`drive_diff.py`, joints
both rigs have): 14 unchanged, 22 paint only, 14 equipment only, 38 with
new motion (5-70 cm), and 097 (the female ab wheel). 081 is still the leaning
abduction variant; 18 narrow/wide replace the Narrow-/Wide-Stance Leg Press
models. New: the Belt Squat (13 high/low/narrow/wide), 45-Degree Leg Press
(18 high/low) and Smith Machine Squat (068 narrow/wide) stances, joined to
their exercises as stance pickers with the base framing (Low leg press
zoomed out 4%), and two exercises with a model only: 055B Bent-Over Cable
Overhead Triceps Extension and 100 Pallof Press (framings from
`solve_pick.py`). The drive's `Single 🟢-Leg_Glute_Bridge` now differs from
079 (11 cm) and was left out; 079 still feeds the Single-Leg Glute Bridge.
The exports carry a bigger rig (219-225 joints with toe/`FF_` foot joints),
so their skin joint indices no longer match `Shared/AnatomyBody.usdc` and a
slim kept ~3 MB of body per model. `Shared/AnatomyBodyV2.usdc` (built with
`share_body.py body` from the new Back Squat) brings them back to 0.1-2.1
MB, attribute for attribute (the Assisted Dip stays ~20 MB, as before); `slim_one.sh` takes `BODY=` for it. Older
models keep `AnatomyBody.usdc`. 097 was retextured and slimmed against
`AnatomyBodyFemale.usdc` (3.3 MB; the female rig changed too). Framings were
kept: `solve_pick.py` at each current yaw, old vs new clip, moved by the
toe joints' ~5% (zoom) and ~3 cm (offset) everywhere; more only on the Leg
Extension (zoom 0.972 -> 0.911), the Cable Crunch (the lifter kneels 20 cm
from the old spot; offset shifted by that). The Russian Twist (8 cm by the
solver) kept its framing: on a still the old one was still centred.

Desktop "101-200" folder (2026-10-17): `~/Desktop/101-200` holds
95 exports (101-190, re-saved by the owner that day; no 159 or 165, 158 only
as the Smith high bar). The chest half, 101-140, went in first as plain swaps
like the SSD 1-100 round (cues, muscle rows, fault ghosts and library tiles
left for later): 46 files cloned (`cp -c`) to `SourceExports/101-200-1017/`
(103's name had a space; `_names.tsv`), converted, `one_side_tiers.py`
(106, 114, 118, 128 changed), padded and slimmed against
`AnatomyBodyV2.usdc` (all attribute for attribute, 0.9-5.3 MB, 85 MB). All
intact: one 224-228-joint skeleton, one animation over 1-192, no cameras.
Against the app models (`drive_diff.py`; the nine older models without toe
joints, 101, 102, 121, 128, 133-135, 137 and 140, were diffed without them):
paint changed on every one (mostly the secondary pectoral heads bright to
dim); 127, 128, 131 and 132 kept their motion; most others moved 3-9 cm;
more on 113/114/117/118 (head 25 cm, the M29), 121 (34 cm, a new cable
station), 129/130 (the AC32 dip station, the lifter 12 cm higher), 105/116
(the new decline bench) and 140 (a GYM bench, hands 42 cm). Six variants
are new stances (models only, the exercise's muscle list):
`InclineCablePressStraightUp`, `DeclineCablePressStraightUp`,
`HighToLowCableFlyToThighs` (hands down to the thighs),
`PlateLoadedChestPressHighHandles`, `ChestDipStraightLegs` and
`WeightedChestDipStraightLegs` (straight legs on a rack's dip handles).
Framings: solve at each current yaw, old vs new clip, then viewport stills
(new 40 at 0/2 s, old vs new for the eight largest changes). All kept except
the dips (body solve: offset y -0.17 -> -0.218 and -0.179 -> -0.225) and the
Decline Cable Press (hands ran off the right edge: zoom 0.692 -> 0.633). The
variants keep their base framing except the Decline Cable Press (solver's
own), the Plate-Loaded high handles (zoom 0.88, the head touched the top)
and the straight-leg dips (body solve).
The back half, 141-190 (49 files, the last saved at 22:27; nothing newer by
23:10), went in the same way the same evening, all 49 replacing their models
(173 with its side-lean stance, 158 the Smith high bar; the low bar is not in
the folder): `one_side_tiers.py` changed 151, 153, 156, 173 (both), 180, 182
and 187; slimmed 0.8-6.9 MB (93 MB). Against the app models: 143-146 and
187 kept their motion and changed paint (the quadriceps bright on 143-145,
the forearms unlit); the rows and pulldowns moved 1-7 cm on the
new rig; more on 141/142 (head 17-20 cm), 151-153 (the landmine rows, a
new pivot on 151), 155 (hands 47 cm), the five pull-ups and chin-ups
161-167 (legs hang straighter, feet 26-49 cm; new chains on the weighted
ones) and 176 (hands 63 cm on the Panatta pulldown). Every framing was kept:
old/new stills at 0/2 s for the fifteen largest changes matched (the
solver's 20% on the pull-ups was the old clip's bent legs).

Desktop "From 191" folder (2026-10-18): `~/Desktop/From 191` holds 90
exports (191-280, re-saved by the owner on 2026-10-18 00:54-14:06; no 238
Spider Curl). All went in as plain swaps like the 101-200 round (cues, muscle
rows, fault ghosts and library tiles left for later): cloned (`cp -c`) to
`SourceExports/191-280-1018/`, converted, `one_side_tiers.py` (15 changed:
the one-arm presses, raises, rotations and curls, the landmine presses and
the Suitcase Carry), `inplace.py` for the three carries (they walk 2.74 m
again), padded and slimmed against `AnatomyBodyV2.usdc` (all attribute for
attribute, 0.6-3.4 MB, 118 MB). All intact: one 223/227-joint skeleton, one
animation over 1-192 (1-1056 for the two 21s), no cameras. 225's export
still carries the three stray left-cable pieces on the floor, so `OFF`
switches them off for this folder too. Against the app models
(`drive_diff.py`; 194 without the toe joints): 44 kept their motion (under
1 cm), 20 moved 1-5 cm, 14 moved 5-15 cm, and nine more: 194 (hands 22 cm),
204 (35 cm), 205 (30 cm, the landmine bar moved), 221 (a new machine,
`RM_CTRL_RowMG3000`, the lifter 17 cm higher), 222 (39 cm, the cable
station moved), 245 (head 22 cm) and the three carries (walking). Equipment
moved on most (dumbbells and bars 2-12 cm, cable stations up to 65 cm); 280
has new towels. Paint changed on 23 (on the converted models): the front
delt down to dim, only the side delt bright, on eight overhead presses (191,
192, 194-196, 198, 202, 203; on 2026-10-11 this pattern was a slip, but
this time the owner confirmed it is intended, as is every other paint change
here); the side delt down to dim
on the landmine presses; the front delt unlit on the lateral raises; the
trapezius and rhomboids down to dim on 210 and 220; the triceps bright on
204; the rotator cuff bright on 222; the forearms unlit on 230, 232 and the
Farmer's and Suitcase Carries; the upper back unlit on 280. New: 215B
(`Shoulder/CableFrontRaiseRope`) joins the Cable Front Raise as a "Rope"
stance, and 259 Lying Cable Curl (`Biceps/LyingCableCurl`, on a floor mat)
and 261 Cable Reverse Curl (`Biceps/CableReverseCurl`) are new exercises
with a model only. Framings: solve at each current yaw, old vs new clip, then
viewport stills (all 87 at 2 s; 0-5 s for the six largest changes). Every
framing was kept. The solver's 40-56% on the carries was spurious: the new
rig's `FF_` foot pivots sit under `CTRL_foot_ik_*`, keep walking after
`inplace.py` (it holds only the pelvis), and `framer.py` filters joints by
their own name, not their parents', so it counted them; without joints under
`CTRL`/`MCH` the carries solve within 3 cm of their framings. The Machine Rear
Delt Row's new machine seats the lifter 17 cm higher (the body solve wants
zoom 0.828), but on stills the head stays clear of the top. The new ones were
solved at the related exercises' yaws and picked on stills: the rope stance
at the Cable Front Raise's -0.55, the Lying Cable Curl side-on at -1.3 like
the floor lifts (at -1.0 the stack covered the feet), the Cable Reverse Curl
at -1.4 like the Cable Curl.

Desktop "Women exsercise" folder (2026-10-18): eight female-model exports
saved 2026-10-12/13. Cable Step Downs was already in the app (the Cable
Knee-Drive Kickback, converted three minutes after this export; same motion,
the paint and M29 differences are `one_side_tiers.py` and the cable tubes).
The other seven are new, each from a .blend in `~/Desktop/Model and Female
Exsercise/Blender Model WOmen/` saved just before its export: the vertical
hack squat in five stances (`Vertical Hack Squat/`, not marked 🟢; a
different machine, `VHS_*`, from the app's female Hack Squat, and 192
frames) and two 🟢 glute kickbacks, the Standing Hinge Kickback (90°, left
leg, the step-down's M29 and ankle cuff) and the Incline Bench Cable Kickback
(kneeling on the BRTW DZ83 bench, right leg). Cloned to
`SourceExports/women-1018/` with plain names, converted (each export's studio
floor off: `VHS_StudioFloor`, `CSD_Floor`, `IBK_Floor`), `retex.py`,
`one_side_tiers.py` (the resting leg on both kickbacks), padded, the garments
given their rest shapes (`bake_rest.py` headless on each .blend, then
`merge_rest.py`) and slimmed against `AnatomyBodyFemale.usdc` (1.2 MB for the
stances, 2.2 and 3.3 MB for the kickbacks, attribute for attribute; against
`AnatomyBodyFemaleHack.usdc` they stayed 62-65 MB). Paint: the stances light
the quads and glutes (standard), the glutes (high), the quads (low), the
inner quad (wide) and the outer quad (narrow), like the Hack Squat set; the
kickbacks light the working side's glutes and hamstrings. New exercises with
a model only: Vertical Hack Squat (its five stances in `stancesByExercise`,
shown in the trainer once it has content), Standing Hinge Kickback, Incline
Bench Cable Kickback. Framings picked on stills (the female body takes ~10 s
to load on the simulator, so shoot with `WAIT=11`): the vertical hack squat
from the front-left three-quarter (-1.0; the lifter faces +x), so the stance
width reads; the hinge kickback at -1.0 like the step-down; the bench
kickback side-on at -1.3.

Dropped male kickbacks (2026-10-19): the owner took 386 (single-leg cable
kickback) and 387 (standing cable hip extension) out of the app because the
female model's kickbacks already cover them. 387 was the Standing Cable Hip
Extension (catalog entry, trainer content, model framing, fault poses,
`Legs/StandingCableHipExtension.usdc` and its library thumbnail all removed);
386 had never been added. Their folders are gone from the drive's
`🟢hamstrings_glutes_356_400`; skip both in any later 300-400 swap. The tool
data (`probe.py`, `thumbs.json`, `posetimes.json`, `bottoms.json`, the 1012
specs and notes, `convert_all.py`'s `300-400-1012/387_…` entry) still lists
387 as a record of that round.

Desktop "From 316" folder (2026-10-19): `~/Desktop/From 316` holds 52
exports (316-325 and 356-400, re-saved by the owner 2026-10-18/19; no 357,
which keeps its model, and 386/387 are dropped: the female model's
kickbacks cover them). Plain swaps like the "From 191" round (cues, muscle rows, fault
ghosts and library tiles left for later): cloned to
`SourceExports/316-400-1019/`, converted (320's camera off),
`one_side_tiers.py` (18 changed; on every one the lit side is the moving left
leg), padded and slimmed against `AnatomyBodyV2.usdc` (all attribute for
attribute, 0.6-3.0 MB, 62 MB). All intact: one 227/228-joint skeleton (367
also carries its partner's), one animation over 1-192, 398/399 with the
SkelRoot on /root. Against the app models (`drive_diff.py`; the old-rig 363,
366, 367, 373-375, 381 and 382 without toe joints): 26 kept their motion, 7
moved 1-5 cm, 11 moved 8-13 cm (the barbell and Smith split squats and
lunges, the good mornings, 382, 395, 396), and 356/358 (head 15 cm), 379
(arms 28 cm) and 388 (the legs, 84 cm) more. The M29's 97-115 cm on 361,
371, 383 and 395 is the cable-tube conversion, not a move. Paint changed on
36: the split squats and lunges light the glutes bright with the adductors
unlit; the RDLs light the erectors bright and the adductors dim; the good
mornings the glutes bright; the hip thrusts and frog pumps drop the quads
and erectors; the kettlebell and dumbbell deadlifts drop the forearms; the
swing's hamstrings go dim; the nordics drop the glutes; the 45-degree hip
extension lights the hamstrings bright and the reverse hyper the erectors;
the Single-Leg Sliding Curl now lights its working left leg (the right
before). New exercises with a model only: 372 Dumbbell Lying Leg Curl
(`Legs/DumbbellLyingLegCurl`, a dumbbell between the feet on a bench), 384
Machine Glute Press and 385 Machine Glute Kickback (`Legs/MachineGlutePress`,
`Legs/MachineGluteKickback`, the left leg) and 399 Banded Glute Bridge
(`Legs/BandedGluteBridge`). Framings: solve at each current yaw, old vs new
(with `framer.py` taking no joints under CTRL/MCH), then viewport stills of
all 48 at 2 s and 0-5 s for the largest changes; every framing was kept (the
solver's 5-9% on 356/358, 373, 379, 381 and 382 is mostly the new rig's toe
joints; on stills the lifters stay clear; the Swiss Ball Leg Curl's ball
touched the left edge before too). The new ones were picked on stills: the
lying curl side-on at -1.35 like the Lying Leg Curl, the two machines side-on
at -1.35 so the leg drives back in profile, the banded bridge at -0.8 so the
band at the knees reads.

Desktop "401-500" folder (2026-10-21): `~/Desktop/401-500` holds 98
exports (401-500 without 487 and 497, re-saved by the owner 2026-10-19..21).
Plain swaps like the "From 316" round (cues, muscle rows, fault ghosts and
library tiles left for later): cloned to `SourceExports/401-500-1021/`,
converted, `one_side_tiers.py` (13 changed: the single-leg calf and tibialis
raises, the side and Copenhagen planks, both side bends, the one-arm
kettlebell and dumbbell lifts, the windmill and the Step-Up Jump), padded and
slimmed against `AnatomyBodyV2.usdc` (all attribute for attribute,
0.3-2.1 MB). All intact: one 227/228-joint skeleton, one animation over 1-192
(1-384 for 495/496), no cameras. 73 replace their app models. Against them
(`drive_diff.py` without the toe joints, which the old 211-joint models
lack): 61 kept their motion exactly; 404 (the new M32, the lifter 18 cm
higher and 13 cm forward), 406 (the LS hack squat, hands 46 cm), 413 (the
HP34, 11 cm), 428/429 (the ABB decline bench, the lifter 22 cm higher), 440
(arms 17 cm), 443/444 (head 13 cm), 445 (feet 14 cm), 461 (hands 8 cm, the
rope re-rigged), 466 (10 cm) and 472/473 (knees 9-21 cm) moved. Equipment:
the seats became the GYM bench on 407-410 and 418 (and 457's bench), the
calf press the LP33, new bands on 424/425 (425's anchored to a kettlebell
1.7 m ahead, off the frame). Paint changed on 44 (on the converted models):
mostly the secondary forearms, upper back, quads, delts and triceps unlit;
the abs bright to dim where the hip flexors or obliques lead (leg raises,
kicks, twists, landmine rotations, the dead bug); the hip flexors bright to
dim on the V-ups, toe touch, toe-to-bar and rollout; 456's glutes unlit; 474
Clean and Press now lights the hamstrings, side delts and triceps bright with
the upper back dim. 458/459 (the side bends) export the right abs and
obliques lit with no glow while the left glows, so `one_side_tiers.py`
unlights the right, as Blender draws it (asked about as a possible slip on
2026-10-12; the owner has re-saved both since with it unchanged).
New exercises with a model only: 402 Barbell Standing Calf Raise, 475/476
Dumbbell and Kettlebell Clean and Press, 477 Barbell Power Clean, 478 Hang
Clean, 479 Dumbbell Hang Clean, 480 Kettlebell Clean, 481 Barbell Clean and
Jerk, 482 Split Jerk, 483 Push Jerk, 484 Power Snatch, 485 Dumbbell Snatch,
486 Kettlebell Snatch, 488 Kettlebell Windmill, 489 Sled Push, 490 Sled Drag,
491 Battle Rope Alternating Waves, 492 Battle Rope Slams, 493 Medicine Ball
Slam, 494 Medicine Ball Chest Pass, 495 Box Jump, 496 Step-Up Jump, 498
Squat Jump, 499 Jump Rope and 500 Rowing Machine (into `Legs/`, `Shoulder/`,
`Abs/`, `Chest/` and `Back/`). The battle ropes and the jump rope are animated
NurbsCurves (each written twice, the copy under a `<name>_0` Xform);
`curves2mesh.py` now evaluates them as B-splines at their Greville points and
builds the same rigid segment chains as the animated cables (a 38 mm battle
rope, the jump rope at the cables' 8 mm); the battle ropes' anchor 6 m ahead
is parked off by the converter. `MovementPattern` files the rower, the jumps,
the sled, battle ropes, slam and chest pass as `.other` (not rows, squats or
step-ups to swap in) and the jerks and kettlebell clean as Olympic lifts; the
sled, battle rope, jump rope and rower work is timed, and the box, ropes and
rower log no load.
Framings: the clips that kept their motion keep theirs (viewport stills of
all 73 at 2 s); for the moved ones, stills at 0-5 s of the current framing
against it shifted by the body solve's change: the Donkey Calf Raise (zoom
0.957 -> 0.826; the M32's pad cut the head off), the Hack Squat Calf Raise
(0.966 -> 0.865) and both decline sit-ups (offset y down 7.8 cm for the
higher bench) take the shifted one, the others keep theirs. The new ones
were solved (`framer.py` taking no joints under CTRL/MCH; `HG_Weight`,
`Kettlebell` and `MedicineBall` held) and picked on stills: the cleans,
clean and presses, jerks and snatches at -0.8 like the Clean and Press, the
windmill -0.3, the sled, battle ropes, chest pass and box and step-up jumps
side-on (-1.3; the ropes and the thrown ball leave the frame), the rower
-1.35, the slam, squat jump and jump rope -0.8; the barbell calf raise -0.8
too (side-on its plate hid the head) and the Sled Drag zoomed out to 0.68 so
the sled shows.

X-ray scapula demo (2026-10-17): `Chest/XRayScapulaBenchSetup.usdc`, opened from
the "Retract scapula" cue of the bench-type presses (`XRayDemos.swift`,
`XRayDemoView.swift`, `XRayViewport.swift`). Built in Blender on a copy of the
male master: sit on the end of a flat bench, squeeze the shoulder blades back
and down, release, lie back (the chest_series 01 lying pose), lock them and
arch, press three empty-handed reps, sit up — 384 frames at 24 fps, looping.
The muscles are see-through and the master's own bone meshes (SKELETON
collection, skinned to the rig) are drawn: scapulae, clavicles, humeri, rib
cage, sternum and spine. Source, notes and QA live on the SSD in
`BLENDER/_co_mo_xuong_ba_vai_20261017/` (README_VI.md). Steps:
`xray/export_usd_xray.py` (in Blender, on the demo .blend: freezes the
driver-based see-through materials to constants, shows the bones, exports USD;
Blender 5.1 always writes `opacity = 1`, so it also writes a material ->
colour/alpha JSON), then `xray/usd_for_app.py raw.usdc materials.json out.usdc`
(convert_all's wrapper — Y-up, lights, cameras and the animated helper empties
off — then the opacities written into the UsdPreviewSurfaces), then
`pad_one.sh`. It is **not** slimmed: its materials and bone meshes differ
from the shared body, so it carries the whole body (25 MB). The app hides the
rib cage and sternum while the camera is overhead, where they would cover the
shoulder blades.

X-ray deadlift set-up (2026-10-21): `Back/XRayDeadliftSetup.usdc`, opened
from the grip-and-lats and spine cues of the barbell deadlifts and Romanian
deadlifts (`XRayDemos.deadliftSetup`). The owner built it in Blender on the
back-bar set-up's file (316B, 2026-10-19): the same see-through muscle,
ivory bones and five-finger grip, no rack, the bar on the floor with 45 cm
plates; 230 frames at 24 fps. Stand over the bar, hinge down with the back
rounding (the wrong way), grip, pull the shoulders down, brace until the
spine stacks straight, pull, lock out. Source and QA on the SSD in
`BLENDER/300-400 🔴/quads_series🟢/DL_nam_thanh_deadlift_co_mo/`
(README_VI.md). Steps: `xray/export_usd_xray_deadlift.py` (in Blender, on a
copy of the .blend; like the back-bar export, but the 24 vertebra bones
follow the straightening shape key frame by frame, 1 → 0 over frames 16-36
and back to 1 over 112-132, within 0.7 mm; the highlight is frozen with the
lats, forearms, abs and lower back bright and the upper back, teres major,
obliques, glutes and hamstrings dim; the bar's near sleeve and plate are
`XRSIDE_`), then `xray/usd_for_app.py` and `pad_one.sh` (the bar is
animated as an object, keyed 1-190, and padding makes its clip as long as
the skeleton's). `usd_for_app.py` now also turns off the `XRAY_LightRig`
empty and any top-level prop parked more than 5 m off stage: both demo
files carried the dumbbells 12.5 m to the side, which drew two specks in
the side view. The back-bar file had them turned off in place.
