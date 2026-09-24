# Trainer content generator (2026-09-24)

Authored the Shoulder, Arm and remaining Leg `ExerciseContent` entries in
`GymWorkout/Models/SampleData.swift`.

- `spec.py` — all copy: cue annotations (cueID, label, tracked joint), technique
  cues, activation, stabilisers, comparison copy, glows, optional `overrides`
  (hand-set label rows). Sources are cited in the SampleData section comments.
- `probe.py` — projects rig joints through each exercise's framing at 8 points
  across the clip with the REAL viewport aspect (382/705 ≈ 0.54; the framing
  solver in `model-pipeline` assumed 0.74). Run with Blender's Python from
  `Tools/model-pipeline` (it imports `framer`); writes `joints.json`.
- `gen.py` — lays labels out (rows 0.14/0.32/0.50/0.68/0.86 by joint height,
  same side as the joint, flip if the pill would cover any tracked dot) and
  writes Swift into `generated.json` per group; paste/replace the block
  between `// MARK: - Shoulder content` and `// MARK: - Home`.
- `framer_rootfix.py` — framer copy that falls back to the default prim when a
  model has no `/root` (the legacy Lunge).

Paths inside the scripts point at a session scratchpad; adjust before reuse.
Always verify label placement with simulator screenshots afterwards.
