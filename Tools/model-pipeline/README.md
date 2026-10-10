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
