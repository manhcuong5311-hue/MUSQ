# Model-only batch (2026-10-29): cable arms family

Content: `spec_1029_arms.py`. Three exercises that were in the library with a
model but no `ExerciseContent`, so the trainer showed them as MODEL ONLY:

| Exercise | Model | Framing |
|---|---|---|
| Lying Cable Curl | `Biceps/LyingCableCurl` | yaw -1.3, zoom 0.613, offset [-0.035, 0.23, 0.127] |
| Cable Reverse Curl | `Biceps/CableReverseCurl` | yaw -1.4, zoom 0.866, offset [0, 0.042, 0] |
| Bent-Over Cable Overhead Triceps Extension | `Triceps/BentOverCableOverheadTricepsExtension` | yaw -0.6, zoom 0.798, offset [0.114, 0.104, -0.078] |

No ghosts were written for this family yet, so each mistake view falls back
to the red ring (the README's "no fault ghost" case). That is the one piece
of the house format still open for these three.

## How the models were read

Everything numeric in the copy comes from the rigs themselves, read with
Blender's Python + pxr (scratch scripts in the round folder):

- `brief.py <Group/Resource> <step>` — per sample: pelvis, trunk angle,
  elbow and knee angles, hand positions against the shoulder, and the props
  that move more than 2 cm across the clip.
- `summ.py` — min / max / start of every series above with the time of each
  extreme, plus hand, shoulder and ankle separations and the times the first
  elbow crosses its mid-range (the rep count).
- `props.py` — every non-body mesh with its world centre, size and how far it
  moves, which is how the handles, stacks, pulleys and cables were named.
- `nearhand.py` — the meshes within 30 cm of either hand, to see what is
  being held.
- `palm.py` — the hand bone's local axes, compared against two lifts whose
  grip the library already states: `Biceps/CableCurl` (supinated) and
  `Biceps/ReverseCurl` (pronated).
- `trainer_shot.py` — renders the app's own trainer camera (framer.py's
  projection: scale `zoom / LONGEST` about CENTER, offset, yaw about Y,
  vertical FOV 32 degrees at z 2.05, 382x655), so a still can be compared
  with `joints.json` directly. Blender imports USD Y-up as Z-up, so the
  script converts (x, y, z) to (x, -z, y) before placing the rig and camera.
- `overlay.py` — draws gen.py's pills, leaders and joint dots over those
  stills (the label check below).
- Paint: `Tools/model-pipeline/tiers.py`.

## Claim by claim

### Lying Cable Curl

| Claim in the copy | Source |
|---|---|
| Lies face up on the floor, knees about 82 degrees, feet flat, ankles 0.30 m apart | Model: knee 82.2 degrees and ankle separation 0.30 m, constant across the clip (`summ.py`) |
| Low pulley beyond the feet, cable along the floor | Model: stack at z 1.54, exit pulley at z 1.33 and 0.12 m up, the cable mesh spanning z -0.12 to 1.32; the lifter's ankles at z 0.30, the shoulders at z -0.78 (`props.py`, `brief.py`) |
| A straight bar in both hands, wrists 0.42-0.47 m apart, a little wider than the shoulders | Model: `GYM_Cable_Handle_*` grip 0.17 m with stirrup ends; hand separation 0.42-0.47 m against 0.39 m at the shoulders (`props.py`, `summ.py`) |
| Underhand grip | Model: hand_L local x axis -1.00 on this rig, matching `Biceps/CableCurl` (-0.97) and opposite to `Biceps/ReverseCurl` (+0.79) (`palm.py`) |
| Elbows 133 degrees at the bottom, 62 at the top | Model: elbow_L max 132.9 at 0.04 s, min 62.4 at 5.67 s (`summ.py`) |
| Upper arms change by less than four degrees | Model: upper-arm pitch -3.7 to +0.2 degrees across the clip (`summ.py`) |
| The bar travels about 30 cm along the body and rises about 9 cm | Model: hand z -0.31 to -0.61 (0.30 m), hand y 0.28 to 0.37 (0.09 m) |
| The pelvis and trunk hold one position | Model: pelvis y and trunk angle identical at every sample |
| Full range beat a partial range: 1RM +25.7% vs +16.0%, thickness +9.65% vs +7.83% | Pinto 2012 (PMID 22027847), abstract read 2026-10-29 |
| Activation rows | Paint (biceps heads + brachialis bright, brachioradialis and the nine forearm muscles dim) for the ranks; fractions carried from the library's Cable Curl entry, written in the 2026-09-29 curl family from Oliveira 2009 and the sources in `notes_1_50_curls.md`. The brachialis row is primary here only because this model paints it bright. |

Nothing in the copy claims an activation advantage for lying down; the two
reps per clip are described as the model's timing, not a prescribed tempo.

### Cable Reverse Curl

| Claim in the copy | Source |
|---|---|
| Stands upright and still, knees 174-176 degrees, ankles 0.30 m apart | Model (`summ.py`): trunk -0.4 degrees, knee_L 173.9, knee_R 176.0, ankle separation 0.30 m, all constant |
| Faces a low pulley ahead | Model: stack at z 0.85 with the hands at z 0.16-0.28 (`props.py`) |
| Overhand grip, hands a little wider than the shoulders | `palm.py` (hand_L local x +1.00, as the library's Reverse Curl); hand separation 0.44-0.48 m against 0.39 m at the shoulders |
| Elbows 150 degrees at the bottom, 49 at the top | Model: elbow_L max 149.9, min 48.6 |
| The bar rises about 39 cm, thighs to about navel height | Model: hand y 0.94 to 1.33 m |
| Upper arms within two degrees of straight down all clip | Model: upper-arm pitch -85.3 to -82.7 degrees |
| The supinated grip drew 19% more biceps excitation than pronated and 12% more than neutral; brachioradialis 5-6% more | Coratella 2023, Sports 11(3):64 (PMID 36976950), abstract read 2026-10-29 |
| Full range vs partial (1RM +25.7% vs +16.0%) | Pinto 2012, as above |
| Expect less weight than an underhand curl | Coratella 2023 above, plus StrengthLog's forearm-extensor page as quoted in `notes_1_50_forearm.md` ("use less weight than a regular curl") |
| Activation rows | Every arm muscle the rig can light is bright here, so every row is primary (the forearm-lift rule, README 2026-10-24). Fractions are the library's Reverse Curl entry (Brachioradialis 0.56, Wrist Extensors 0.50, Forearm Flexors 0.45, Brachialis 0.66, Biceps Brachii 0.68), kept exactly; only the ranks of the biceps and brachialis rows change, because that model paints them dim and this one bright. Coratella 2023 supports the biceps still working with the palms down. |

Open point for the owner, the same one `notes_1_50_forearm.md` raised for the
barbell Reverse Curl: with the fractions kept, the biceps (0.68) and
brachialis (0.66) sit above the brachioradialis (0.56) in a lift named for
the brachioradialis. Here the paint and the rows agree (everything is bright,
so everything is primary), but the ordering still reads oddly in the legend.
Re-tiering the model or re-estimating the fractions is a call for the owner.

### Bent-Over Cable Overhead Triceps Extension

| Claim in the copy | Source |
|---|---|
| Trunk 82 degrees from vertical, pelvis 0.84 m up, both constant | Model (`summ.py`) |
| Split stance: lead knee 136, rear leg 166 degrees, ankles 0.71 m apart | Model (`brief.py`, `summ.py`) |
| Both hands on a straight bar, wrists 0.35-0.38 m apart, cable up to a high pulley | Model (`nearhand.py`, trainer stills; the cable is a 24-segment chain rising forward from the hands) |
| Elbows 65 degrees at the bottom, 172 at lockout, held about half a second | Model: elbow_L min 65.0, max 172.0 at 1.71 s, within 2 degrees of the maximum from 1.33 to 2.00 s |
| The hands travel 0.39 m forward and about 0.09 m down | Model: hand z 0.74 to 1.13, hand y 1.23 to 1.08 |
| Upper arms hold +15 degrees and do not change by a degree | Model: upper-arm pitch 14.99-15.00 across the clip |
| Overhead training grew the triceps more than by-the-side training: long head +28.5% vs +19.6%, lateral and medial +14.6% vs +10.5%, whole muscle +19.9% vs +13.9%, with loads 34-39% lower | Maeo 2023, Eur J Sport Sci 23(7):1240-1250 (PMID 35819335), abstract read 2026-10-29 |
| Triceps Brachii 0.88 | The library's Overhead Cable Triceps Extension, the same cable extension with the arms overhead relative to the shoulder. Maeo 2023 measured growth, not activation, so it is not used for the number, and the copy does not say this version builds more muscle than any other. |

The copy says the hinge is what puts the arms overhead; it never claims the
bent-over version beats the standing one, which no source compares.

## Labels

Rows are the batch's squeezed set (0.16, 0.32, 0.48, 0.64, 0.80, as
`spec_1029.py` maps 0.14-0.86), all five pinned with `overrides` on every
exercise, and checked by drawing them over the trainer stills at 0, 1, 2 and
3 s (`overlay.py`).

- **Lying Cable Curl.** The body lies in a band at v 0.44-0.54 across the
  whole width (head right at u 0.80, feet left at u 0.20), so the middle row
  is unusable and the rest are free. Two short pills share the top row
  (left 0.035-0.435, right 0.609-0.965, a 0.17 gap), the curl pill sits on
  the right at 0.32 clear of the hands (u 0.48-0.68, v 0.46-0.49), and the
  trunk and base pills sit low on the left over empty floor.
- **Cable Reverse Curl.** The body is a narrow column (u 0.36-0.60). The
  elbow pill is top right, clear of the head at u 0.57; the rest are on the
  left. Round 1 put the grip pill on the right at row 0.32: its leader ran
  across the chest and the near arm to reach the hands at u 0.36-0.49, so it
  moved to the left, where it is 0.10 clear of them.
- **Bent-Over Cable Overhead Triceps Extension.** The arms reach across the
  top (hands u 0.18-0.58 at v 0.24-0.31), the trunk runs down to the right
  and the legs to the bottom right. Two pills sit top right above and beside
  the arms, two on the left where the frame is empty, and the stance pill
  bottom left: round 1 had it bottom right, where its top edge touched the
  lead shoe (the shoe runs to v 0.81, the pill sits at 0.80 plus or minus
  0.018).

## Checks run

- `python3 spec_1029.py arms` prints OK (validate + validate_library).
- `python3 preview_1029.py arms` prints the layout above.
- `python3 integrate_1029.py <scratch>` wrote the setup steps, the three
  content-map entries and the content block into SampleData.swift between
  the `Model-only exercises (2026-10-29)` markers, and touched FaultPoses
  not at all (no ghost files for this family).
- Build: `Tools/lab/build.sh --no-install` with `LAB` in the session
  scratchpad (the repo's own ContentView is never swapped).
