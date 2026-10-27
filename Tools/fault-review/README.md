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

Desktop "100-200" folder, part 1 (2026-10-11): the 26 models re-exported in
new equipment with unchanged motion had their trainer (1.5 s) and every
ghost shot at its stored still with `Tools/lab/shoot_ex.sh`; every ghost
still reads over the new benches, racks and cable stations, so the ghosts
and `bottoms.json` were kept. The twenty other models kept motion and
equipment, so their ghosts stand.

Desktop "100-200" folder, part 2 (2026-10-11): the 27 models whose motion
changed and the Inverted Row (Smith low bar) had their trainer and every
ghost shot at the final framings before and after the family revisions
(`Tools/lab/shoot_ex.sh`). New pieces are prefixed `r1011`
(`r1011HandlesHigh` for the chest machines' seat-too-low mistakes,
`r1011DipShruggedRise`, and others the families wrote); stills moved in
bottoms.json where the rep timing changed; the Decline Chest Press
Machine's press-path and arched-back ghosts turn the model (-0.6, -1.0)
since it is now seen from the front. The Concentration Curl's ghosts are
in `faults_1011_curl.swift.txt` (existing curl pieces, nothing new), its
moments in `fault_moments_1011_curl.json` (1.6 s for all four).
A final inspection of those shots (two inspectors, 32 findings, then a
re-check) fixed ghosts that ran along the line of sight from these
behind-the-lifter and front three-quarter framings: the Machine Pull-Up's
short rep is now `hangingShort` (the craned chin lay on the spine); the
wrist ghosts of the V-Bar, Rope and Neutral-Grip pulldowns turn side-on;
the machine rows' chest-off-pad ghosts use a stronger, turned piece; the
seated chest presses' arched-back ghosts are larger and turned a little
(-0.35, -0.2: further round the feet left the frame or the plate hid the
trunk); the Machine Pullover's arch is deeper (0.18) and unturned (turned,
the cam disc hid the lifter); the Iso-Lateral Lat Pulldown shrugs the
working side only; the Decline press-path ghost draws the far arm only (the
near one lay on the yellow lever); both cable shoulder presses' brace ghosts
are drawn without the arms (the overhead hands ran into the banner); the
Wide-Grip Seated Cable Row's elbow ghost is `elbowsFlared(35)`.

Desktop "300-400" folder (2026-10-12): the 26 replaced legs had their
trainer (0, 1.5 and 3 s) and every ghost shot at their stills before and
after the revisions (`Tools/lab/shoot_ex.sh`). The re-framed Smith split
squat, Bulgarian split squat and good morning dropped their `.seen(-0.4)`
turns (on the new framings the turn put the M30's near upright across the
trunk, or looked from almost straight behind, where the moves barely show);
the Cable RDL's stance ghost is the new `r1012revACloserToPulley` (18 cm
nearer the M29's pulley), kept in `faults_1012_revA.swift.txt` and pasted by
`integrate_1012.py` with the families' pieces; the Cable Hip Adduction's
torso and leg ghosts are seen from -1.4 (the station's columns hid them from
the front three-quarters); the Banded Hip Abduction lost its grip ghost (its
new hands mistake is a force); the three lunges' stills moved to 2.08 s,
where their new clips bottom out. The Glute-Ham Raise's pad ghost
(`hingeGHRKneesOnPad`, the lifter ~9 cm forward) now shows the pad slipping
under the shins: the owner's new GHD rests the kneecaps on the pad.
The twelve new exercises' ghosts are in `faults_1012_{thrust,hipext,kb}.swift.txt`
(new pieces prefixed `r1012<family>`), their moments in
`fault_moments_1012_*.json` (merged into bottoms.json by `fault_times.py`;
the hip extensions and the swing are given in seconds, since their kinds
fall through to the press rule). The library's Back Extension arms ghost and
the Dumbbell and Barbell Hip Thrusts' `hipsShortOfLockout` distort the arms
on their own rigs (the hipext and thrust families use corrected copies);
left for a later pass.

SSD 1-100 ghosts on the 2026-10-17 models (2026-10-22): the owner's call was
to redraw as few as possible ("a ghost shows the wrong form anyway; I only
tweaked many models a little, so a mistake is still a mistake; redraw only
where it is too far off"). Every ghost of the 87 exercises with content was
shot on the new models (`Tools/lab/shoot_ex.sh`, 440 mistake views, 261
trainer stills), one reviewer per exercise judged each against four defects
(the ghost vanished or matches the model; limbs detached, swapped or bent
backwards; it shows something other than the mistake text; it goes deep
through the floor or equipment), and two skeptics had to agree before any
redraw. 405 ghosts were kept, 31 cues are ring-only by design, one proposal
(Push-Up feet) was voted down, and three were redrawn:
- Front Squat "rack": the re-tuned model racks with the elbows high, so the
  old drop along the shoulder-to-wrist line left the elbows in place; the
  arms now swing 40° down about the shoulders, seen side-on.
- Rope Pushdown "split": the model now holds the hands about 0.67 torso
  apart at the top and the bottom alike, so the hand-spread gate (0.65-0.82)
  never fired; it is gated on the straight elbow instead, the hands lifted
  0.1 instead of 0.08.
- Cable Glute Kickback "grip" (unchanged model, an old defect): the twist
  about the spine drew one line along the spine from the side; it is now
  the pulled-on-support pattern seen face-on.
The reviewers also noted callout pills that cover a face or hands on some
of these lifts after the re-tune (Reverse Lunge, Sissy Squat, Front Squat at
3 s, Low-to-High Cable Fly, Hip Abduction Machine (Lean), Biceps Curl, the
Overhead Cable Triceps Extension at 1.5 s, Pistol Squat at 3 s, Leg
Extension); those pills, and the ones on the hands of five more lifts, were
moved on 2026-10-23 (`Tools/lab/label_space_1023/`).

Exercises 101-200 ghosts on the re-tuned models (2026-10-23/24): the same
review for the Desktop 101-200 swap (c9dc620) and the 191-200 shoulder
presses (fdb0a36), 97 exercises, 491 cues: every mistake view shot with
`Tools/lab/shoot_ex.sh`, contact sheets from `Tools/lab/gsheets.py`, cues
listed against the table by `ghost_keys.py`. 471 were kept, 8 are ring-only
by design, and of 12 redraw proposals 4 were voted down (Single-Arm Cable
Chest Press feet, Single-Arm Cable Fly scapula, Larsen Press legs, Wide-Grip
Barbell Row grip). The eight confirmed all lay on the model's own limbs, most
of them from the start (the move ran along the line of sight of their
framing), not because of the re-tune. Each redraw then had to pass two
skeptics on fresh shots; four needed a second try:
- Reverse-Grip T-Bar Row "elbow", Single-Arm Landmine Row "elbow": the wider
  flare pieces (`r1011ElbowsFlaredWide`, `leftElbowWingedWide`) turned -0.5.
- Single-Arm Cable Fly "wrist": a finish fault now; the straight arm swings
  40° on across the chest and the trunk 15°, gated on the wrist's distance to
  the far shoulder (review still 1.48 s in `bottoms.json`).
- Wide-Grip Barbell Row "elbow": the same tuck, seen from behind (view -1.0;
  turned toward the front the plates hid the arms).
- Wide-Grip Pull-Up "barpath": `hangingShort` slid only ~16 px down the
  spine; a local piece drops the whole body, legs included, 0.3 torso lengths
  and re-seats the elbows, from the plain rear view.
- Underhand Inverted Row "elbow": the Inverted Row's flare, turned -1.1 (at
  -0.6 the near forearm ran at the camera and the arms read as a zigzag).
- Kneeling Lat Pulldown "feet": the whole trunk 0.28 back and 0.12 down over
  the planted knees, seen side-on (0.16/0.14 hugged the model's back).
- Neutral-Grip Chin-Up "elbow": re-seating the pushed elbows undid the push
  (the shoulder-to-hand line already points forward at the top) and hanging
  the body back drew them behind the model's; the third try, the shared
  drift seen side-on and a little higher, puts the elbows ~14 pt ahead of
  the model's (one skeptic accepted it, the other found it only a little
  better than the old one, which showed nothing; the frame upright hides the
  model's own arms at that angle).

Exercises 201-280 ghosts on the re-tuned models (2026-10-24): the same
review for the Desktop "From 191" swap (fdb0a36) without its 191-200
presses, 77 exercises with content, 385 cues, shot with
`Tools/lab/shoot_ex.sh` and reviewed one reviewer per exercise (two
skeptics per proposed redraw) in four batches as the shots came in. 376
were kept and 8 are ring-only by design; one redraw was proposed and both
skeptics confirmed it:
- Farmer's Carry "steps": the yellow stride lay on the model's own legs.
  All three carries share the re-tuned walk, whose ankles open to 0.67
  torso lengths at most (0.71 before), so the Farmer's Carry's own
  `longStride(from: 0.6, to: 0.76)` gate left the stride at ~40% at its
  2.0 s review still (70% on the old walk). Five tries, each judged by two
  skeptics on fresh shots at 1.7-2.4 s: the other carries' gate (~90%) and
  then 1.6 times the stride still left the yellow feet on the shoes from
  this angle; a stride of its own (leading ankle 0.38 torso lengths ahead,
  trailing 0.4 behind, hips 0.14 lower, gate full at the widest stride)
  read clearly but bent the leading knee backwards at 2.2 s, because the
  knee stayed behind the new hip-to-ankle line when `.resolve` re-seated
  it; moving that knee half as far ahead first (and lifting the leading
  toe a little, a heel strike) passed both: ankles ~2.3 times as far apart
  as the model's, both knees bent forward at every shot, an offline solve
  over the whole walk finding no backward knee. The Suitcase and Overhead
  Carries keep `longStride` (their reviewers kept them).
The large motion changes of the swap (the Smith Machine and Viking Presses'
new bars, the Machine Rear Delt Row's new machine, the Cable Rear Delt Row's
moved station, the walking carries) all left readable ghosts.

Exercises 300-400 ghosts on the re-tuned models (2026-10-25): the same
review for the Desktop "From 316" swap (e79db48), 49 exercises with content
(the four new model-only ones have none; the Barbell Single-Leg Romanian
Deadlift, on its older model, was looked at too), 254 cues, shot with
`Tools/lab/shoot_ex.sh` and reviewed one reviewer per exercise in two
batches. 230 were kept and 23 are ring-only by design. One redraw was
proposed, Cable Standing Leg Curl "hips" (seen from behind, the forward
shift runs along the line of sight), and the two skeptics split, so it was
kept, as the rule asks. No ghost changed: the Reverse Hyperextension's legs
(84 cm), the single-leg RDLs' head (15 cm) and the Single-Leg Hip Thrust's
arms (28 cm) all moved without leaving their ghosts unreadable.

Exercises 401-500 ghosts on the 2026-10-21 models (2026-10-27): the same
review for the Desktop 401-500 swap (2ec0b28), 73 exercises with content
(its 25 new model-only exercises have none), 365 cues, shot with
`Tools/lab/shoot_ex.sh`; 13 of the models had moved (Donkey, Hack Squat
and Horizontal Leg Press Calf Raises, both Decline Sit-Ups, Bird Dog, the
V-Ups, Toe-to-Bar, Cable Rotation, Stability Ball Rollout, the thrusters),
the rest kept their motion exactly. One reviewer per group: 303 kept, 61
ring-only by design, and one redraw proposed and confirmed by both
skeptics: Hack Squat Calf Raise "top", whose 20° heel drop with the body 5
cm down the sled bent the knees to ~152° on the new machine and read as
the "knees" fault. No replacement passed both skeptics in five gated
tries, each on fresh shots from its own build (the third picked from five
candidates judged blind by three judges with different lenses):
- 30° with the body carried back with the ankle: knees straight, but the
  body went into the back pad and the yellow foot lay along the shoe's
  sole, so the heel drop did not show (0 of 2).
- 45° with the body slid down the sled along the pad: the foot still along
  the sole, and the knees at ~168° hinted at the knees fault (0 of 2).
- Only the legs drawn, 55°, the hips ~10 cm down the sled: all three judges
  ranked it first of five; its skeptics split (the turned toe tip rises off
  the platform, and the leg reads a little shifted). It is in the app now.
- The same with the foot drawn to a planted toe tip, or to the ball of the
  foot: the yellow foot back along the sole (0 of 2 each).
The skeptics' remaining point is that the stick foot has no heel: the
corner of the yellow L lands at the white shoe's heel, so the drop reads
small. A heel point (ankle, heel, ball) would need a new ghost point
type; the options, side by side, are in
`hack_squat_calf_raise_top_options.png`, for the owner. The older models
outside the swap had their ghosts reviewed when they were made and did not
change. Mistake-view pills on a face or fist, noted for later (outside the
trainer-card check): Horizontal Leg Press Calf Raise "seat", Plank
Shoulder Tap "tempo", Barbell Seated Calf Raise "tempo", Oblique Cable
Crunch "rope", Cable Side Bend "plane" and "arm".
