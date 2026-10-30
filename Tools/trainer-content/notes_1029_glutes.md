# Model-only batch (2026-10-29): glutes family

Content: `spec_1029_glutes.py`. Three exercises that were in the library with
a model but no `ExerciseContent`:

| Exercise | Model | Framing |
|---|---|---|
| Machine Glute Press | `Legs/MachineGlutePress` | yaw -1.35, zoom 0.691, offset [-0.012, 0.018, 0.052] |
| Machine Glute Kickback | `Legs/MachineGluteKickback` | yaw -1.35, zoom 0.566, offset [-0.003, 0.025, 0.012] |
| Banded Glute Bridge | `Legs/BandedGluteBridge` | yaw -0.8, zoom 0.745, offset [-0.004, 0.268, 0.004] |

No ghosts yet, as for the arms family: each mistake view falls back to the
red ring.

## How the models were read

The same scratch scripts as the arms family (`brief.py`, `summ.py`,
`props.py`, `trainer_shot.py`, `overlay.py`), plus two written for this one:

- `gaps.py` — knee and foot separation, pelvis height and a named prop's
  world centre per 0.5 s. It is what showed the band work: the knees move
  0.351 m to 0.375 m apart as the hips rise, with the feet fixed at 0.400 m.
- `nearest.py` — which joint a prop stays closest to across the clip, which
  is how the machines' contact points were identified: the glute press's
  foot plate sits 0.06 m from the toe joint all clip (the foot is on it),
  and the kickback's roller 0.16 m from the knee joint all clip (it rides
  the leg just above the knee and swings with it).

Paint from `Tools/model-pipeline/tiers.py`: both machines light the three
glutes bright and the three hamstrings dim **on the working (left) side
only**; the bridge lights them on both sides. Nothing else is painted on any
of the three.

## Claim by claim

### Machine Glute Press

| Claim in the copy | Source |
|---|---|
| Leans forward at 40 degrees, chest and forearms on pads, hands 0.68 m apart at 1.23 m | Model (`brief.py`, `summ.py`): trunk +40 degrees and pelvis 1.01 m, both constant; hand separation 0.68 m, hand height 1.23 m |
| The working foot is on a swinging plate | Model (`nearest.py`): `GP_FootPlate_Tread` stays 0.06 m from toe_L, 0.11 m from foot_L |
| Knee 75 to 161 degrees, hip 107 to 158 | Model (`summ.py`): knee_L min 75.1, max 160.8; hip_L min 106.6, max 161.3 |
| The plate travels 0.62 m back and 0.06 m up; ankles 0.40 m to 0.86 m apart | Model: plate centre z -0.10 to -0.73, y 0.39 to 0.45; ankle separation 0.40 to 0.86 |
| The pelvis sits at one height for both reps | Model: pelvis y 1.005 at every sample |
| Standing knee about 163 degrees, foot flat | Model: knee_R 163.0 constant, ankle_R y 0.18 |
| Rows (Gluteus Maximus 0.84, Gluteus Medius 0.40, Hamstrings 0.50) | Paint for the ranks; fractions from the library's Cable Glute Kickback, the nearest lift with content. Stien 2021 (JSSM 20:56-61) measured a kickback at 6RM: gluteus maximus no different from the leg press (ES 0.08, p = 0.898), biceps femoris higher than in the leg press (ES 2.27, p < 0.001), which is why the hamstring row stays moderate rather than low |
| Ribs down, spine neutral, hips not hyperextended | Contreras 2011 (Strength Cond J 33(5):58-61), as quoted in `notes_0927_hipthrust.md` |

**Open point for the owner.** The knee opens 86 degrees against the plate,
so the quadriceps must be working, but the model paints them unlit. Following
the house rule (rows follow the paint) they are listed among the stabilisers
instead of given a row. Either re-paint the model's quadriceps dim, or keep
the legend as it is.

### Machine Glute Kickback

| Claim in the copy | Source |
|---|---|
| Trunk 42 degrees, chest and forearms on pads, hands 0.49 m apart at 1.17 m, pelvis 1.005 m, both constant | Model (`brief.py`, `summ.py`) |
| The pad rides the leg 0.16 m from the knee | Model (`nearest.py`): `GK_KneeRoller` 0.16 m from shin_L (the knee joint) at every sample |
| Knee 118 to 168 degrees, hip 112 to 161 | Model (`summ.py`) |
| The pad travels 0.40 m back and 0.23 m up (a 0.46 m arc); the stack lifts 0.11 m; the ankles finish 0.87 m apart | Model (`gaps.py`, `props.py`): roller centre z -0.05 to -0.45 and y 0.66 to 0.89; `GK_StackTopPlate` moves 0.11 m; foot separation 0.22 to 0.87 m |
| Standing knee about 156 degrees | Model: knee_R 155.6 constant |
| The rep ends with the thigh in line with the trunk, not past it | Model: hip_L stops at 161 degrees. The "no further" reasoning is mechanical (the pelvis cannot move, so extra height would come from the spine) and is marked as such here, not attributed to a study |
| Rows | As the glute press above, same paint and same library fractions |

### Banded Glute Bridge

| Claim in the copy | Source |
|---|---|
| Face up on a mat, mini band above the knees, arms flat at the sides, head down | Model (`props.py`): `HG_MiniBandAboveKnees` (a 0.33 m loop) and `HG_ExerciseMat`; hands 0.34 m out at 0.06 m |
| Feet flat 0.40 m apart, never shifting | Model (`gaps.py`): foot separation 0.400 at every sample |
| Pelvis rises 0.142 m; hips 149 to 172 degrees; knees 72 to 86 | Model (`summ.py`): pelvis y 0.171 to 0.313; hip_L 149.3 to 173.7; knee_L 71.7 to 86.2 |
| A short hold at the top | Model: pelvis y 0.313 from 1.5 s to 2.0 s, the same in the second rep |
| The knees press 0.024 m further apart as the hips come up | Model (`gaps.py`): knee separation 0.351 at the bottom, 0.375 at the top |
| Adding a band raised upper gluteus maximus activity in both the barbell glute bridge and the hip thrust (ten men, 5RM) | Kennedy, Casebolt, Farren, Bartlett 2023, Int J Strength Cond (abstract read 2026-10-29) |
| Rows (Gluteus Maximus 0.82, Gluteus Medius 0.45, Hamstrings 0.36) | Paint for the ranks; the maximus and hamstring fractions are the library's Glute Bridge. The medius 0.45 is an estimate, anchored between the Frog Pump's 0.40 and the seated Banded Hip Abduction's 0.78, and said to be an estimate in the code comment |
| Ribs down, no arch; head down | Contreras 2011 via `notes_0927_hipthrust.md` |

**What the copy deliberately does not say.** Kennedy 2023 found the *unbanded*
glute bridge drew **more** gluteus medius than the banded one, which the
authors themselves call unexpected. So the band cue claims only what the
study supports (more upper gluteus maximus activity, something to press
against) and makes no gluteus medius claim. The entry also has no quadriceps
row, unlike the library's unbanded Glute Bridge, because this model does not
paint them.

## Labels

Rows are the batch's squeezed set (0.16, 0.32, 0.48, 0.64, 0.80), all five
pinned with `overrides` on every exercise, checked by drawing them over the
trainer stills at 0, 1, 2 and 3 s (`overlay.py`) and then on the harness
simulator at 0, 1.75 and 3 s.

- **Machine Glute Press / Machine Glute Kickback.** Both are side-on with
  the head and hands top left, the hips in the middle and the working leg
  sweeping down to the right. The chest pill goes top left over empty space,
  the pelvis pill top right (clear of the head at u 0.22 and 0.37), the
  knee or pad pill at mid height on the open side, the standing-leg pill
  bottom left and the drive pill on the bottom row, under the foot's arc:
  the foot runs to v 0.62-0.64, so a pill at 0.64 would touch it, and 0.80
  is the lowest row that stays clear of the legend.
- **Banded Glute Bridge.** The body lies in a band at v 0.41-0.59 (head
  right at u 0.80, feet left at u 0.23-0.40), so the middle row is unusable.
  Two short pills share the top row (0.035-0.376 and 0.653-0.965), the ribs
  pill sits on the right at 0.32, and the feet and head pills go below the
  body, where the mat leaves the frame empty.

## Checks run

- `python3 spec_1029.py glutes` prints OK, `preview_1029.py glutes` the
  layout above.
- `python3 integrate_1029.py <scratch>` wrote the setup steps, the three
  content-map entries and the content block; FaultPoses untouched.
- `Tools/lab/build.sh --no-install` with `LAB` in the session scratchpad:
  BUILD SUCCEEDED.
- `Tools/lab/shoot_ex.sh` on the harness simulator at 0, 1.75 and 3 s: all
  three screens show their five pills, the legend and the setup drawer, and
  no pill sits on the lifter or on a moving part.
