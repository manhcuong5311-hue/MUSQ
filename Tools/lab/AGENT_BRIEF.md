# Brief: trainer content for a family of the 401-500 batch

You are writing one *family* of exercises for MUSQ / GymWorkout, an iOS app
(SwiftUI + RealityKit) at `/Users/sammanhcuong/Developer/GymWorkout` (REPO).
Each exercise has an animated 3D model of an anatomy lifter; the "trainer"
screen plays it with five labelled cue pills (leaders to tracked joints), five
technique cues, an activation legend, stabilisers, setup steps, a form
comparison, and a yellow "ghost" for each common mistake. The models are
converted, framed and in the library already; your job is the content for
your family, to the standard of the batch's earlier families (rounds 1 and 2:
`spec_500_{chest,hammer,curls,calfstand,calfseat,hip,calfmore,tibialis,situp,
crunch,cablecrunch,stability}.py`), each drafted, independently reviewed and
then checked claim by claim by a skeptic. Read their notes' Review and
Verification sections to see what was caught, and avoid those mistakes.

LAB = the lab scratch folder (`source Tools/lab/env.sh` sets it; per-round
inputs live in `$LAB/<round>/`, given in your task).

## Read first (in this order)

1. `Tools/trainer-content/README.md` (whole file; the 401-500 sections last).
2. `Tools/trainer-content/common_1_50.py` — entry format, `ex()`, `glow()`,
   `validate()`, `part_of()` (how the app files muscle names; names it drops
   or misfiles fail validation; `LEGEND_ONLY` names are allowed).
3. `Tools/trainer-content/spec_500.py` (your family list), `preview_500.py`,
   `integrate_500.py`, `gen.py` (label layout).
4. Template families (reviewed and verified): pick the closest ones from the
   list above, e.g. `spec_500_stability.py`, `spec_500_crunch.py`,
   `spec_500_situp.py` for core work, `spec_500_calfstand.py` for standing
   lifts, with their `notes_500_*.md`, `Tools/fault-review/faults_500_*.swift.txt`
   (PIECES / TABLE format) and `fault_moments_500_*.json`. Also the library's
   existing content for your closest lifts in `GymWorkout/Models/SampleData.swift`
   (search `<camelName>Content`) and `spec_abs.py` for core work.
5. `Tools/fault-review/README.md` (its 401-500 sections last),
   `GymWorkout/Models/FaultPoses.swift` top (the ghost DSL: BodyAxis,
   FaultMove, FaultStrength, FaultPose, chains, views) and
   `GymWorkout/Components/FaultGhost.swift` (how moves are solved). Existing
   pieces in FaultPoses.swift are `private static` in the same enum, so your
   table may call them (grep for plank, core, carry, squat, press pieces).

## Inputs for your models

- Motion briefs: `$LAB/<round>/briefs/<Resource>.md` (arms: elbow, shoulder,
  wrist, palm every 0.5 s, moving equipment) and `$LAB/<round>/briefs_legs/<Resource>.md`
  (knee, hip, ankle, foot pitch, trunk lean, pelvis, rep phases). Frame: Y up,
  the lifter faces +z, their left is +x, metres. Floor lifts may lie with the
  head toward -z. The briefs were written for upright lifts: for lying,
  kneeling, plank and side-lying work measure what you need (trunk-to-floor
  angle, hip angle, pelvis height and tilt, limb heights, which side moves,
  rotation of the shoulders against the hips) from the rig yourself.
- Highlight paint: `$LAB/<round>/tiers.txt` / `tiers.json` — per model the
  anatomy meshes lit bright (PRIMARY paint) and dim (SECONDARY). Activation
  follows the paint: bright muscles are primary rows, dim ones secondary
  (house rule). Where anatomy says a bright-painted muscle cannot do the
  job (round 2: tibialis posterior on toe raises), keep it a LOW secondary
  row and say why in the code and notes. Fractions must be defensible: cite
  EMG where it exists for this or a close variant, otherwise follow the
  library's values for the nearest lift and say it is a judgement call.
- Stills of the trainer framing (382x655 pt viewport, no labels):
  `$LAB/<round>/stills/<slug>_t{0,1,2,3,5}.png` (slug = lower-case name, non
  letters/digits -> '-').
- Projected joints: `Tools/trainer-content/joints.json` (already probed with
  the final framings, 8 samples across the clip).
- The models: `GymWorkout/Resources/Models/<Group>/<Resource>.usdc`. Read them
  with Blender's Python, which has pxr + numpy:
  `/Applications/Blender.app/Contents/Resources/5.1/python/bin/python3.13`,
  with `PXR_AR_DEFAULT_SEARCH_PATH=REPO/GymWorkout/Resources/Models/Shared`
  (slim models reference the shared body). Joint names: `upper_arm_L`
  (shoulder), `forearm_L` (elbow), `hand_L` (wrist), `thigh_L` (hip),
  `shin_L` (knee), `foot_L` (ankle), `toe_L`, `pelvis`, `spine`, `chest`,
  `neck`, `head`. System `python3` has PIL. Put scratch scripts under
  `$LAB/<round>/<family>/`.

## Muscle names

- Use names `part_of()` files correctly: "Rectus Abdominis", "Transverse
  Abdominis", "External Oblique"/"Obliques" (abs); "Erector Spinae",
  "Quadratus Lumborum" (lower back); "Gluteus Maximus/Medius" (glutes);
  "Quadriceps", "Hamstrings", "Adductors", "Gastrocnemius", "Soleus",
  "Tibialis Anterior" (calves); "Latissimus Dorsi", "Trapezius",
  "Anterior/Lateral/Posterior Deltoid", "Triceps Brachii", "Forearms".
- Legend-only names (shown, not counted for recovery): "Hip Flexors" (the rig
  paints them on its Sartorius mesh) and "Serratus Anterior".
- validate() rejects names the app would drop or misfile.

## What to write (only these files; nothing else in the repo)

- `Tools/trainer-content/spec_500_<family>.py` — `from common_1_50 import *`,
  one `ex(...)` per exercise and `SETUP[N] = [...]` (3-5 steps). Header: the
  models (builder numbers, resources), what each model shows (measured: which
  side works, ranges in degrees, timing, holds, equipment, paint), how they
  differ from the library's existing lifts, and full sources (authors, year,
  journal, DOI, PMID, what you used from each). Use an `ov()` helper for
  override rows (spec_500 squeezes rows 0.14-0.86 into 0.16-0.80).
- `Tools/trainer-content/notes_500_<family>.md` — maps every claim and number
  in the copy to its source or to a model measurement; how you read the
  models; label and ghost decisions.
- `Tools/fault-review/faults_500_<family>.swift.txt` — `// MARK: PIECES` (new
  `private static func`s with doc comments, every new name prefixed with your
  family prefix) and `// MARK: TABLE` (`"Exercise": [ "cueID": piece(...), ... ],`
  with a short comment per ghost: what it shows and its measured size). One
  ghost per position cue; tempo, speed, breathing, force or where a pad sits
  get no ghost (the app falls back to a red ring) — say so in a comment.
  Moves are in the lifter's own axes; use view turns where the framing hides
  a move along the line of sight.
- `Tools/fault-review/fault_moments_500_<family>.json` — per exercise, cue ->
  "bottom" | "top" | "lockout" | "any" | seconds (e.g. "2.5"), read by
  `fault_times.py`. Its kinds: crunches, sit-ups, V-ups, leg and knee raises
  and toe-to-bar = curlup (top = trunk and thighs closest); kicks, planks,
  climbers, side bends, twists, chops, cable/landmine rotations, rollouts,
  the body saw, dead bug, bird dog and hollow body = hold (always give
  seconds); thrusters and the clean and press = legs (bottom = pelvis
  lowest, top = highest); carries, marches and the bear crawl = carry. Give
  seconds wherever the default picks the wrong moment (alternating sides,
  right-side reps) — the scan covers only the first 4 s.

Do NOT edit shared files in the real repo (SampleData.swift, FaultPoses.swift,
setup.py, bottoms.json, joints.json, probe.py, gen.py, common_1_50.py,
spec_500.py, ExerciseCatalog.swift, ...). The lab script integrates your
family into a mirror. Put any needed shared change (a probed joint, a library
row, a fault_times rule, a timed/bodyweight flag, a movement pattern) in your
final report. Do not use the `library=` key.

## Copy rules (house style)

- Five annotations (cueID, label <= 28 chars, tracked joint) and five cues
  (title, intro, why, mistake, correct), same five ids. Comparison:
  (BADGE IN CAPS, correctCue, mistakeCue, correctNote, mistakeNote).
  Stabilisers lower case. No double quotes or backslashes anywhere.
- The copy describes what the model actually does (side, range, holds,
  alternation, where hands and feet are); where coaching differs from the
  model, follow the model and say so in the notes. Second person, plain,
  specific, no hype. Every factual or numeric claim is traceable to a real
  source you read (Europe PMC / PubMed, ExRx via the Wayback Machine since
  the live site 403s, StrengthLog, ACE, NSCA...). Never invent a study, a
  number or a quote; mark mechanical reasoning as such in the notes.
- Activation rows: (muscle, P|S, level, fraction), level matching the
  fraction (>= 0.70 HIGH, 0.40-0.69 MODERATE, else LOW).
- Glows: `glow(N, [joints], A|SOFT, opacity, rx, ry, dx, dy)`.
- Labels: `python3 preview_500.py <family>`; pills must not sit on the lifter
  or moving equipment, leaders must not cross the body badly, rows above
  ~0.12 clash with the eye button (top right), rows past ~0.88 with the
  legend (bottom left). Pin rows with `overrides`; track far-side joints when
  that keeps leaders off the body.

## Tools

- `cd Tools/trainer-content && python3 spec_500.py <family>` — validates.
- `python3 preview_500.py <family>` — validates and prints the layout.
- `zsh Tools/lab/family.sh check <family>` — mirrors the repo into $LAB,
  integrates your family only, compiles (prints Swift errors).
- `zsh Tools/lab/family.sh shoot <family> "0,1.5,3" [names...]` — the same,
  then installs on the harness simulator and shoots the trainer (labels on)
  at those stills and every ghost at its moment, into `$LAB/<family>/`
  (`trainer.png`, `faults*.png` sheets and single PNGs, 402x874 pt). One run
  at a time across all agents (a lock; it waits): batch your fixes; a full
  family takes ~10-15 min. Never run xcodebuild or simctl yourself.
- Python ports of `FaultGhost.solve` written in earlier rounds may be gone
  with old scratch folders; write your own if you need one (port
  FaultGhost.swift), and use it to size ghosts and to check bone lengths and
  that no knee or elbow bends backwards.

## Process

1. Measure each model first (numbers) before any copy.
2. Research real sources; draft spec + setup + notes + faults + moments.
3. Validate, preview, `family.sh check` until it compiles.
4. `family.sh shoot`; inspect every trainer still and every ghost; fix and
   shoot again (at least two rounds).
5. Self-review: sources (every claim traceable, nothing overstated) and model
   fidelity (copy, labels, ghosts match the model).
6. Return the structured report.
