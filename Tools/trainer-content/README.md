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
