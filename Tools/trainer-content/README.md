# Trainer content generator (2026-09-24)

Authored the Shoulder, Arm and remaining Leg `ExerciseContent` entries in
`GymWorkout/Models/SampleData.swift`.

- `spec.py` — all copy: cue annotations (cueID, label, tracked joint), technique
  cues, activation, stabilisers, comparison copy, glows, optional `overrides`
  (hand-set label rows). Sources are cited in the SampleData section comments.
- `probe.py` — projects rig joints through each exercise's framing at 8 points
  across the clip with the REAL viewport aspect. Since the setup drawer (2026-09-24) the
  trainer viewport is 382×655 (≈0.58); the labels here were laid out at
  382/705, before the drawer. The `model-pipeline` solver assumed 0.74. Run with Blender's Python from
  `Tools/model-pipeline` (it imports `framer`); writes `joints.json`.
- `setup.py` — setup steps for all 60 trainer exercises (the swipe-up drawer).
- `gen.py` — lays labels out (rows 0.14/0.32/0.50/0.68/0.86 by joint height,
  same side as the joint, flip if the pill would cover any tracked dot) and
  writes Swift into `generated.json` per group; paste/replace the block
  between `// MARK: - Shoulder content` and `// MARK: - Home`.
- `framer_rootfix.py` — framer copy that falls back to the default prim when a
  model has no `/root` (the legacy Lunge).

Paths inside the scripts point at a session scratchpad; adjust before reuse.
Always verify label placement with simulator screenshots afterwards.

Legs2 batch (2026-09-24): `spec_legs2.py` holds the 15 exercises added from
`SourceExports/Legs2` (curls, hinges, bridges, kickbacks, abduction, plus the
re-exported Step-Up, Push-Up, Plank). Generate with `spec` swapped for it, e.g.
`python3 -c 'import sys,spec_legs2; sys.modules["spec"]=spec_legs2; exec(open("gen.py").read())'`.
An entry may pass `slots=[...]` to override the label rows — lying/prone
bodies use `FLAT` (0.15–0.87, skipping 0.50) so labels sit above and below
the body. Top rows under ~0.12 collide with the eye button on the right, and
rows past ~0.88 with the muscle legend on the left.

Abs batch (2026-09-24): `spec_abs.py` holds the 11 core exercises from
`SourceExports/Abdoment` (088-099; 095 Plank keeps the existing Plank content).
Its header lists the sources (Escamilla 2006/2010, ACE/SDSU, Youdas 2008/2014,
McGill 1996/2010). "Hip Flexors" and "Quadratus Lumborum" are shown in the
legend but have no `MusclePart`, so recovery ignores them.

Gated batch (2026-09-24): `spec_gated.py` holds Biceps Curl, Squat and Lunge
(re-exported from `SourceExports/3 bai thieu`, which replaced a missing or
mismatched model) plus the new Lunge (Lean). Its header lists what each model
shows and the sources. `probe.py` now takes names after the output path and
merges into that file, e.g. `probe.py joints.json "Squat" "Lunge"`. The lunges
are seen nearly side-on (yaw -1.3); labels are pinned with `overrides`, and
some cues track the far-side joint (`hand_R`, `patella_R`) so leaders don't
cross the body. The generated Swift lives under
`// MARK: - Gated exercises and lean lunge` in SampleData.

Chest batch 101-131 (2026-09-25): `spec_chest3.py` holds the 28 exercises from
`SourceExports/Chest3` (floor, Smith, single-arm, alternating, neutral-grip and
squeeze presses, pullovers, plate-loaded and selectorised machines, cable
presses and flies, landmine press, incline push-up). Its header lists what each
model shows and the sources; glows are placed from the probed pec, delt and
triceps joints. `probe.py` now also projects the pec and lat anchors. Seated
machines and the head-on standing flies pin their labels with `overrides` and
point the shoulder/elbow cues at the far-side joints, which sit in the open
part of the frame. The generated Swift lives under
`// MARK: - Chest batch 101-131` at the end of SampleData.

Batch 133-160 (2026-09-25): `spec_131_160.py` holds the 27 exercises from
`SourceExports/131-160` (push-up and bench variants, pulls from pins, blocks
and the floor, barbell, landmine, one-arm, kettlebell and inverted rows). Its
header lists what each model shows and the sources; glows are placed on the
pecs, lats or hips by the kind of lift. The generated Swift lives under
`// MARK: - Batch 133-160` at the end of SampleData. Dumbbell Bent-Over Row
is a separate model from the older Dumbbell Row (wider hands, straighter
knees, deeper hinge) and is listed as its own exercise.

Batch 161-190 (2026-09-25): `spec_161_190.py` holds the 30 back exercises from
`SourceExports/160-190` (pull-up and chin-up variants, pulldowns, cable and
machine rows, a reverse-grip T-bar row and two pullovers), with the same cue
sets as the Pull-Up, Lat Pulldown and Seated Cable Row. Some sit close to
older entries with different models: Wide-Grip Pull-Up (Pull-Up), Wide-Grip
Lat Pulldown (Lat Pulldown), Close-Grip Seated Cable Row (Seated Cable Row),
Machine Seated Row (Chest-Supported Row Machine). The Dumbbell Pullover Row
model keeps the arms nearly straight, so it is written as a lat pullover.

Batch 191-240 (2026-09-26): 46 exercises from `SourceExports/190-240` —
shoulder presses and raises, rotator-cuff work, rear-delt and upright rows,
shrugs, loaded carries and biceps curls. Written by family on top of
`common_191_240.py` (helpers, `validate()`), one module per family
(`spec_191_240_{bbpress,dbpress,lateral,frontrear,shrugcarry,curls}.py`),
each with a header listing what its models show and the sources, and
`notes_191_240_*.md` mapping the copy's claims to them. `spec_191_240.py`
collects them in library order; `python3 spec_191_240.py` validates all 46.
Each family was drafted by one agent, checked by two independent reviewers
(sources and claims; model fidelity, labels and ghosts) and revised twice.
`gen.py` now writes `MuscleActivation(name:rank:fraction:)`: the HIGH /
MODERATE / LOW word is read off the fraction in the app (>= 0.70 high,
0.40-0.69 moderate). The setup steps were appended to `setup.py`, the Swift
lives under `// MARK: - Batch 191-240 (2026-09-26)` at the end of SampleData,
and `probe.py` gained deltoid, upper-trap and collarbone anchors. The three
carries are logged in seconds (`ExerciseCatalog.timedExercises`).

Legs 300-350 (2026-09-26): 11 exercises from `SourceExports/300-350` — flat,
front-foot-elevated and rear-foot-elevated split squats (barbell, dumbbell,
Smith) and the forward, barbell, Smith reverse and curtsy lunges. Written by
family on top of `common_300_350.py` (`spec_300_350_{splitsquat,lunge}.py`,
headers listing what each model shows and the sources, `notes_300_350_*.md`
mapping claims to sources); `spec_300_350.py` collects them and squeezes the
label rows into 0.16-0.80 like the 191-240 batch. Each family was drafted,
checked by two independent reviewers and revised twice. The split squats keep
the left leg in front; the four lunges switch legs between reps, so their
one-leg cues name `<stem>_front` / `<stem>_back`, which the app resolves every
frame (`Exercise3DView.trackedPoint`) and `probe.py` now writes for the lifts
in its `ALTERNATING` set. `probe.py` also probes `toe_L/R` (skipped on rigs
without them). The model briefs came from a leg-motion summary (knee and hip
angles per leg, foot positions and heights, trunk lean, pelvis height every
0.5 s). The Swift lives under `// MARK: - Legs 300-350 (2026-09-26)` at the
end of SampleData; the setup steps were appended to `setup.py`.

Late additions (2026-09-27): Seated Dumbbell Lateral Raise, Cable Rear Delt
Row, Dumbbell Upright Row and Barbell Hip Thrust, written the same way
(`common_0927.py`, `spec_0927_{shoulders,hipthrust}.py`, `notes_0927_*.md`;
`python3 spec_0927.py` validates the four). The Swift lives under
`// MARK: - Late additions (2026-09-27)`; the integration script cuts after the
Legs 300-350 block, so the late block is always pasted after it.
