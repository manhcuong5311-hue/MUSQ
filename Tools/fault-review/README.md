# Fault review (2026-09-24)

Stills of every authored common-mistake ghost (`GymWorkout/Models/FaultPoses.swift`),
held at the bottom of the rep, for checking them side by side.

1. `bottoms.py <exercise…>` (Blender's Python) — the second each clip bottoms
   out: where the elbow bends most, or for flys where the hands are furthest
   apart; legs, raises, hinges, bridges and abductions have rules of their
   own (see the sets at the top) → `bottoms.json`. Faults of the other end of
   the rep are stored as `"Exercise|cue"` (`AT_TOP`, `AT_LOCKOUT`); holds and
   the core lifts were set by hand from joint timelines.
2. Swap `ContentView.swift` for the harness below, build, install.
3. `python3 make_shoot.py [exercise…] > shoot.sh && zsh shoot.sh` — one still
   per fault into `faults/`.
4. `python3 sheet.py faults sheet.png [slug…]` — one row per exercise, cropped
   to the viewport. Restore ContentView.

Harness branch (never commit):

    let env = ProcessInfo.processInfo.environment
    if let name = env["HARNESS_FAULT"],
       let ex = SampleData.exercises.first(where: { $0.name == name }) {
        NavigationStack {
            Exercise3DView(exercise: ex, cue: env["HARNESS_CUE"], showingMistake: true,
                           still: env["HARNESS_STILL"].flatMap { TimeInterval($0) })
        }
        .environment(WorkoutStore())
        .environment(RestTimer())
    }

Moves are in the lifter's own axes, so a move straight along the camera's line
of sight disappears in the default framing. A fault can carry a `view` (a turn
of the model, in radians, eased in while the mistake shows) to bring it round
to a side that shows it: negative brings the lifter's left side to the camera.
Work out the turn from the model rather than by eye — the facing of each clip
(including the prims above its skeleton) and the turn to a true left-side view
come from a quick pass over the USD, as in the 2026-09-24 session. While a
mistake shows, the viewport also shrinks and lifts the model (`roomBelow`) so
the feet clear the mistake bar; the stills include both.

Faults that are about speed or force rather than a position (tempo, bouncing,
pulling on pads) have no ghost and fall back to the red ring.

Chest batch 101-131 (2026-09-25): every new chest exercise has a ghost for
each cue. `bottoms.py` treats the new cable flies as flys and the pullovers
by the overhead stretch (hands furthest from the pelvis); the landmine
press's short-lockout fault is read at lockout. Pieces shared with the
original chest lifts (decline feet, bounced bar, seated arch, cable-fly
folds) were pulled out of their entries unchanged. The single-arm lifts work
the left arm, so their ghosts move only `_L` joints; Incline Push-Up reuses
the push-up's faults.

Batch 133-160 (2026-09-25): every new exercise has a ghost for each cue. The
new pulls from the floor, pins and blocks bottom out by the knee rule, and
their lockout faults (`Rack Pull|lockout`, `Block Pull|lockout`,
`Trap Bar Deadlift|lockout`) are read at the top. The push-up variants reuse
the push-up's faults and the three inverted rows share one set, so
`make_shoot.py` (which reads inline entries) skips them; shoot them by hand.

Batch 161-190 (2026-09-25): every new exercise has a ghost for each cue. The
pull-up, chin-up and pulldown pieces (`elbowsForward`, `chinCraned`,
`hangingShort`, `pulledBehindNeck`, `pulledPastChest`) and `rowedLow` were
pulled out of the Pull-Up, Chin-Up, Lat Pulldown and Wide-Grip Barbell Row
entries unchanged; `bottoms.py` treats the two new pullovers by the overhead
stretch.

Batch 191-240 (2026-09-26): every new exercise has a ghost for each cue,
written per family in `faults_191_240_<family>.swift.txt` (a PIECES and a
TABLE section) and pasted under `// MARK: Batch 191-240 pieces` and at the
end of the table. `fault_times.py <fault_moments.json>` sets each fault's
still from the families' notes (bottom / top / lockout / any), read by the
kind of lift: the top of a press is lockout, of a raise the hands highest,
of a curl or row the elbows most bent, of a shrug the shoulders highest.
`bottoms.py` also gained rules for the new raises, shrugs, cable rotations
and carries.

Legs 300-350 (2026-09-26): `fault_times.py` classes lunges and split squats as
`legs`: bottom = lowest pelvis, top = highest. The ghosts are in
`faults_300_350_{splitsquat,lunge}.swift.txt` (integrated under
`// MARK: Legs 300-350` in FaultPoses.swift); the alternating lunges use the
`_front` / `_back` leg tokens like the Walking Lunge.

Late additions (2026-09-27): `fault_times.py` classes hip thrusts as `legs`
too (top = highest pelvis, which is lockout). Ghosts in
`faults_0927_{shoulders,hipthrust}.swift.txt`, integrated under
`// MARK: Late additions` in FaultPoses.swift.

Batch 241-300 (2026-09-27): `fault_times.py` has three more kinds: `wrist`
(top = the wrist at the end of its working range, flexed for wrist curls,
extended for reverse ones), `finger` (top = fingers closed, bottom = the bar on
the fingertips) and `hold` (static, 2 s). Ghosts in
`faults_241_300_<family>.swift.txt`, integrated under `// MARK: Batch 241-300`.

Exercises 1-150 redone (2026-09-29/30): the nine new 1-50 exercises have a
ghost per position cue in `faults_1_50_{curls,forearm,compound}.swift.txt`
(`check_faults_1_50.py` compile-checks them; `fault_moments_1_50_*.json`
feed `fault_times.py`), integrated under `// MARK: Exercises 1-50 redo`.
Every replaced exercise's ghosts were shot on the simulator and fixed where
the new motion or a reframe broke them (e.g. Barbell Bench Press
`elbowsFlared(46)`, per-exercise `.seen` views on the Leg Press after its
reframe, stronger Walking/Reverse Lunge knee faults, `rangeCutShort` stills
on the chest machines); shared pieces were left unchanged for other
exercises (new parameters or pieces instead).

Exercises 151-190, gated and the redone 190-280 folder (2026-09-30): motion
was unchanged for most, so the existing ghosts stand; the five dumbbell and
landmine presses changed their rep timing (bottom at 0/4 s, lockout at
1.5-1.58 s), and their bottoms.json stills were moved to match. The new
Machine Preacher Curl's ghosts are in `faults_280_machinecurl.swift.txt`
(`check_faults_280.py` compile-checks them; `fault_moments_280_machinecurl.json`
feeds `fault_times.py`), integrated between the `Redone 190-280` markers.

Back Extension (2026-10-01): with the copy now teaching the lower-back
(spine-curling) variant, the "hips" ghost undoes the curl and folds the
straight trunk at the hips instead, "thigh" tips the curled trunk further at
the hips (pad set too low), both faded in only near the bottom hold
(`bottoms.json` stills at 1.5 s); "spine" arches the lower and upper back at
the top, "grip" swings the arms forward, "feet" slide down the foot plate.

351-400 folder (2026-10-01): every new exercise has a ghost per position cue
in `faults_400_{rdl,hinge,legcurl,hip}.swift.txt` (`check_faults_400.py`
compile-checks them; `fault_moments_400_*.json` feed `fault_times.py`),
integrated between the `351-400` markers. `fault_times.py` gained four kinds:
`hinge` (RDLs, deadlifts, good mornings: bottom = trunk tipped furthest),
`legcurl` (leg curls, Nordics, sliding curls, glute-ham raise: top = knee
most bent), `abduction` / `adduction` (knees furthest apart / closest), and
frog pumps count as `legs`.

401-500 folder (2026-10-04): every new exercise has a ghost per position cue
in `faults_500_{chest,hammer,curls,calfstand,calfseat,hip}.swift.txt` (new
pieces prefixed by family, e.g. `calfStand500Heels`; `check_faults_500.py`
compile-checks them; `fault_moments_500_*.json` feed `fault_times.py`),
integrated between the `401-500` markers. `fault_times.py` now also takes a
moment in seconds ("16.9"), used for the 21s' later blocks, the cross-body
curl's right arm and the wrist roller; the calf press counts as `calf`, the
21s as `pull` and the wrist roller as a `hold`. The standing calf pieces turn
the foot about the ball of the foot (`toe_*`) and nudge the knees forward
before re-seating them, so no ghost bends a knee backwards. The reviewers
re-measured the ghosts with Python ports of `FaultGhost.solve` (bone lengths,
bend direction, on-screen size). The Dumbbell Hip Thrust reuses the Barbell
Hip Thrust's pieces, sized on its own rig.

Second round, 415-444 (2026-10-04/05): ghosts in
`faults_500_{calfmore,tibialis,situp,crunch,cablecrunch,stability}.swift.txt`
(prefixed pieces), moments in `fault_moments_500_*.json`. `fault_times.py`
gained the kinds `tibialis` (top = toes highest by the left ankle) and
`curlup` (top = trunk and thighs closest, for crunches, sit-ups and V-ups);
the dead bug, bird dog and hollow body are holds whose moments are given in
seconds, as are the alternating and right-side reps. Each family's ghosts
were sized with a Python port of `FaultGhost.solve` (bone lengths kept, no
knee or elbow bent backwards) and checked on lab shots by the author and the
reviewer.

Third round, 445-474 (2026-10-05): ghosts in
`faults_500_{legraise,plankdyn,plankhold,sidebend,twist,antiext,carrymarch,
thruster}.swift.txt`. `fault_times.py` reads leg and knee raises and the
toe-to-bar as `curlup`; kicks, planks, climbers, side bends, twists, chops,
rotations and rollouts as holds; the bear crawl and marches as carries;
thrusters and the clean and press as `legs`, whose top by pelvis height is
ambiguous for a thruster (the pelvis is as high racked as locked out), so
those families give every moment in seconds. The kick ghosts name legs by
role (`_front` = the higher leg when lying face up) and fade where the legs
pass, so a ghost never jumps between legs.

Desktop "1-100" folder (2026-10-10): the fourteen re-exported models whose
motion changed most (Cable Wood Chop, Step-Up, Curtsy Lunge, Barbell Hip
Thrust, Heel-Elevated Squat, Decline Crunch, Dumbbell Overhead Triceps
Extension, Single-Arm Cable Pushdown, Pistol and Assisted Pistol Squat,
Close-Grip Bench Press, Single-Leg Glute Bridge, Bench Dip, Landmine Squat)
had every ghost shot at its stored still; all still read, so the ghosts and
`bottoms.json` were kept. (The Hip Abduction Machine (Lean), which took the
folder's 081 export, kept its body motion and so its ghosts.) Re-running `bottoms.py` on them is
not a check: its generic rules disagree with most of the hand-set times
(e.g. the Curtsy Lunge's bottom at 0.08 s instead of 1.58 s).

The five new legs of that folder have their ghosts in
`faults_1010_legs.swift.txt` (pieces prefixed `legs1010`; the Smith front
squat's torso fault reuses `hipsBehindFixedBar`) and their moments, all in
seconds, in `fault_moments_1010_legs.json`; `fault_times.py` now files
step-ups with the squats (`legs`: bottom = pelvis lowest). The leg
extension's pad and the adduction machine's tempo cue have no ghost.

The formerly red-named replacements (2026-10-10): the Romanian Deadlift's
knee ghost now draws locked knees (the shared `rdl4KneesLocked`, as on the
351-400 RDLs), since the model itself now bends the knees to 42° and
`hingeKneesBending` only drew more of that; the Assisted Dip's elbow ghost
flares further (outward 0.25, turned to -0.3), since the model now keeps
its elbows where the old ghost drew the mistake.
The female model's lifts (2026-10-10): ghosts in `faults_1010_female.swift.txt`
(pieces prefixed `fem1010`), moments in seconds in
`fault_moments_1010_female.json`; the stance sets' ghosts are posed on the
standard stance. The Ab Wheel Rollout's hips and ribs ghosts were resized for
the female torso (0.44-0.49 m against 0.58 m) and its return ghost moved to
the return phase.
