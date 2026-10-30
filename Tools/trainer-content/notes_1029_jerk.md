# Model-only batch (2026-10-29): jerk family

Content: `spec_1029_jerk.py`. Five exercises that were in the library with a
model but no `ExerciseContent`:

| Exercise | Model | Framing |
|---|---|---|
| Dumbbell Clean and Press | `Shoulder/DumbbellCleanAndPress` | yaw -0.8, zoom 0.724, offset [0.006, -0.051, -0.006] |
| Kettlebell Clean and Press | `Shoulder/KettlebellCleanAndPress` | yaw -0.8, zoom 0.740, offset [-0.001, -0.026, 0.001] |
| Barbell Clean and Jerk | `Shoulder/BarbellCleanAndJerk` | yaw -0.8, zoom 0.640, offset [-0.023, -0.075, 0.024] |
| Split Jerk | `Shoulder/SplitJerk` | yaw -0.8, zoom 0.650, offset [-0.030, -0.077, 0.031] |
| Push Jerk | `Shoulder/PushJerk` | yaw -0.8, zoom 0.659, offset [-0.027, -0.084, 0.028] |

No ghosts yet, as for every family of this round: each mistake view falls back
to the red ring.

## What the five clips actually hold

The two things a writer going by the exercise names alone would get wrong:

- **Both clean-and-presses are TWO-implement and bilateral** — two dumbbells,
  two kettlebells. The hands stay within 12 mm and 2 mm of each other at the
  set-up and each implement's handle sits a constant 0.104 m / 0.109 m from its
  own hand for all 192 frames. Neither is a one-arm lift.
- **The Barbell Clean and Jerk receives in a split**, the left foot 0.608 m
  forward — the same split as the Split Jerk (0.610 m) to within 2 mm — while
  the **Push Jerk never splits at all** (`foot_L.Z - foot_R.Z` never exceeds
  0.123 mm in 192 frames). So the app ships a split receive twice, and the copy
  has to say what separates the three jerks.

Rep structure: the two presses and the clean and jerk are **one rep** over
7.958 s; Split Jerk and Push Jerk are **exactly two reps**, period 4.000 s
(96 frames, loop error 0.00 mm). All five loop exactly.

**Split Jerk and Push Jerk are the same animation up to frame 20**: all 26
joints agree to 0.000 mm on frames 0-20 and first differ at f21. That is why
the two entries now report the same dip with the same numbers.

## How the models were read

The round folder's scripts, rebuilt after the restart wiped `/private/tmp`
(`meas.py`, `sil.py`, `headsil.py`, `room.py`, `lead.py`, `anchor.py`,
`near.py`, `trainer_shot.py`, `draw.py`, `chk.py`, `val.py`), plus two written
for this family:

- `room.py` — **spec-free** slot room: for all ten slots at any label length it
  prints lifter clearance, lifter-overlap frames, load distance, load-inside
  frames and load-seconds per row. It is what the layout below was chosen from
  rather than drawn and eyeballed.
- `lead.py` — **spec-free** leader test: for a given lift, anchor joint, row,
  side and label length it reports how many of the 192 frames the leader lies
  on the head's own silhouette, and the closest approach in pixels.

Paint from `Tools/model-pipeline/tiers.py`.

## Claim by claim

### Evidence behind the coaching

| Claim in the copy | Source |
|---|---|
| **No cue claims an EMG outcome for any jerk** | There is no peer-reviewed EMG study of any jerk: the NSCA 2023 position statement's 323 references cite none, and the one recording that exists (Liu 2021) is an unreviewed preprint with no stated normalisation. The boundary is written into the module header and into all three jerk entries |
| Standing dumbbell presses drew about 15% more anterior deltoid than a standing barbell press (p < 0.001), and standing dumbbell 1RM was about 7% lower (p = 0.002) | Saeterbakken & Fimland 2013, J Strength Cond Res 27(7):1824-1831, 15 healthy men at 80% of each exercise's own 1RM. Written as a between-condition difference, never as a %MVIC. The study pressed from a rack, so nothing about the clean rests on it |
| Rectus abdominis about 81% lower and external oblique about 58% lower seated than standing (both p < 0.001) | Saeterbakken & Fimland 2012, same lab, used only for why the brace matters standing |
| Anterior deltoid 33.3% against the posterior head's 11.4% MVIC | Campos 2020, J Hum Kinet 75:5-14, 13 trained men, **seated** barbell press, 12 reps at 60% 1RM, a partial range 180 to 135 degrees. Cited for the DIRECTION of the Dumbbell Clean and Press's new Posterior Deltoid row only, with the population stated; no fraction is taken from it |
| No difference between a one-arm kettlebell swing, snatch and clean in the gluteus maximus | Lyons 2017, J Strength Cond Res 31(9):2363-2370, 14 resistance-trained subjects at a self-selected 8-10RM. Used as a null result only; it measures a one-arm lift, not this two-bell one |
| Dip depth for scale: 58 +/- 9 degrees of knee flexion; a centre-of-mass dip of 0.19-0.20 m | Lake 2006 (seven recreational weightlifters) and Soriano 2024 (sixteen resistance-trained participants). Both are used for scale and are labelled as such: this model dips about half as deep and nobody has shown an optimum |
| 259 +/- 24 ms propulsion phase | NSCA 2023 position statement, for scale beside the model's 0.250 s drive |
| Everything else (bar path, rack shape, receiving depth, recovery order, the back knee) | Coaching: Catalyst Athletics, Greg Everett's The Jerk Part 1 and 2, Bob Takano via SportsEdTV, CrossFit, StrengthLog. Each is named in the copy as coaching, not measurement. CrossFit's unsourced 30% push-jerk-over-push-press figure is deliberately NOT used |

### Activation rows

Fractions are **carries**, not new estimates. The two presses take the
library's **Clean and Press** whole (Anterior Deltoid 0.84, Gluteus Maximus
0.70, Quadriceps 0.62, Erector Spinae 0.55, Triceps Brachii 0.55, Lateral
Deltoid 0.50, Hamstrings 0.50, Trapezius 0.70, Biceps Brachii 0.30), with
ranks moved to follow each model's paint under the README's rank-change rule.

The three jerks **do not press**: across their drive and receive the bar rises
14.40 cm (0.250-0.792 s) while the elbow moves 3.798 degrees. Their Anterior
Deltoid therefore takes **0.40**, the snatch round's value for a load the legs
throw and the arm only locks, anchored on the Overhead Carry — **the owner's
call on 2026-10-30, recorded in `rep/owner_decisions.md`**, against the
alternative of the Push Press's 0.80. Their Trapezius takes the Push Press's
0.36, their Lateral Deltoid the Overhead Carry's 0.45, their Gluteus Maximus
the Overhead Squat's 0.50.

Only **two** fractions in the whole family are new: Triceps Brachii 0.50 on the
three jerks and Gluteus Maximus 0.50 on the Push Jerk. No library row changes.

The rig lights the three glutes as one group, so every entry carries a single
`Gluteus Maximus` row, the copy says "glutes" and **no entry names the medius
anywhere** — the owner's standing decision from the clean round.

**Open points for the owner**, all written into the module's own comments:

1. **The legend truncates.** `legendRow` is `lineLimit(1)` on both name lines,
   so about 35-40 characters render. The Dumbbell Clean and Press's secondary
   line is **139 characters** over nine rows — for scale, the longest secondary
   line shipped anywhere in the app today is 111. Its Forearms 0.35, Posterior
   Deltoid 0.30 and Gastrocnemius 0.30 rows will appear only in the Muscles
   Worked sheet, never in the legend. Confirmed on the simulator shots.
2. The triceps are only DIM on the one lift of the five that takes the elbow
   through a full strict press with the legs still.
3. The Posterior Deltoid row is new to the family and rests on the paint alone.
4. The soleus is painted dim on the Dumbbell Clean and Press **only**, yet is
   named among the stabilisers while the gastrocnemius pair gets a row.
5. The card's meta line reads `ANTERIOR DELTOID - BARBELL` on all three barbell
   lifts while their legends lead with `QUADRICEPS` or `GLUTEUS MAXIMUS`.

## Labels

Rows are the batch's squeezed set (0.16, 0.32, 0.48, 0.64, 0.80), all five
pinned with `overrides` on every lift. **Every figure below was measured, not
eyeballed**, and then re-measured by this session against the drawn pill
geometry (half-height 0.025 in v, width `(24 + 5.6*len)/382`, pinned 0.035 from
the frame edge) before integration:

- **25 of 25 pills clear the SKINNED lifter at every one of the 192 frames**
  (the rigs return the rest pose from `GetPointsAttr`, so LBS is evaluated per
  frame and binned at 655 rows, one per screen pixel).
- **25 of 25 leaders are clear of the head's own silhouette at every frame.**

This is the tightest family of the round, because the load is what drives the
layout:

- **Dumbbell Clean and Press.** The bells travel 0.0007 m to 2.1723 m, so they
  enter all five rows and there is no free row — but they are narrow, so a
  short pill on the far side clears them, and all five pills clear both the
  lifter and the load at every frame. Four of the five are trailing because the
  leading side below row 0.16 is hostile and leading-side leaders cross the
  face. The binding constraint is the `catch` LEADER, not its pill: at row 0.16
  leading, every one of the 26 probed joints except `hand_R` puts the leader on
  the face, and `hand_R` itself fails at thirteen characters, so `Drop under`
  stops at ten with 4.1 px to spare — the layout's tightest figure, deliberately.
  `Heels lift` deliberately inverts the library's `Heels down`, because this
  model lifts both heels 5.81 cm for 1.208 s.
- **Kettlebell Clean and Press.** All five clear both at every frame as well.
  `No dip` is six characters, the family's shortest label and its only
  prohibition; a positive eight-character string is placeable at row 0.32
  trailing but would make 8.5 px the layout's tightest pill instead of the
  present 10.7 px. **Left as `No dip`; the owner can take the trade.**
- **Barbell Clean and Jerk — the one lift with no clean answer.** The 2.04 m
  bar sweeps from the floor (v 0.875) to overhead (v 0.106), so it is inside
  **all ten slots** at some frame and no pill can avoid it. The layout takes the
  five cheapest slots the labels fit: the bar is inside `Bar close` for 18 of
  192 frames, `Catch it high` 24, `Dip straight down` 36, `Flat back` 41 and
  `Punch and split` 50 — 169 pill-frames of 960, against a theoretical best of
  165. Nothing is lost on the lifter: all five clear the body at every frame.
  This is the same trade the owner accepted on the Power Snatch.
- **Split Jerk / Push Jerk.** Rows 0.64 and 0.80 are load-free on both sides
  (four free slots) while row 0.32 holds the bar in 186 and 184 of 192 frames
  and must stay empty. The fifth pill therefore takes row 0.16 leading, the
  cheapest remaining: the bar is inside it for 40 frames on the Split Jerk and
  68 on the Push Jerk.

## What this session changed in the draft

The draft came out of a twelve-agent workflow (draft x5, assemble, three
review lenses, revise, two skeptics). This session re-measured every disputed
figure from the `*_A.json` files before accepting it, and fixed:

- **Barbell Clean and Jerk, the drive window.** It was written 3.375-3.625 s,
  one frame late at both ends, and all three figures beside it belonged to
  3.333-3.583 s. At the stated window the bar rises 33.3 cm and the elbow is at
  55.2 degrees, not 24 cm and 43. Corrected to **3.333-3.583 s**, which also
  removes the contradiction with the next cue (which put the elbow at 55.2
  degrees at the same instant), and the split's pelvis drop to **16.6 cm,
  0.946 to 0.780 m**, over its own 3.625-3.875 s.
- **Dumbbell Clean and Press, "averaging 0.560 m/s"** in the first pull. Its
  own endpoints over its own 1.000 s window give **0.496 m/s**; no reading of
  the data gives 0.560.
- **Split Jerk, the dip.** One sentence mixed two windows, and reported the
  Push Jerk's frame-identical dip with different numbers. Now the family's
  single reading: **0.250-0.583 s, pelvis 3.94 cm, trunk 0.99 degrees, hip
  opening 162.7 to 166.0, knees 8.72 cm forward**.
- **The 14.40 cm** behind the owner's 0.40 decision is the rise to **0.792 s**,
  not to 0.833 s (where it is 18.82 cm). The window is now stated. The decision
  does not move: both readings are a 14-19 cm load rise against 3.8 degrees of
  elbow.
- Barbell Clean and Jerk: the bar follows the pelvis down **4.10 cm**, not 4.2;
  the 6.1 cm second-pull heel lift is **not** the clip's biggest (9.44 cm on the
  back foot in the recovery is).
- Dumbbell Clean and Press: the elbows fold in **0.92 s**, not "a little over
  half a second".
- Sources: the parallel-squat receiving rule belongs to **Catalyst Athletics**,
  not Everett; Lyons 2017 and CrossFit's full-extension cue were used in the
  copy but missing from the module's source list.
- Two miscounts in the rows comments: the Kettlebell Clean and Press has
  **three** rank-downs (Quadriceps is the third), and the Split Jerk paints
  **three** trapezius parts, not four.

And six coaching defects, all on strings a lifter actually reads — `correct`
and the setup steps are the only coaching outside the gated trainer:

- The **Split Jerk told the reader to press "until your arms stop"**, turning
  the rig's 173-degree elbow limit into an instruction, and the **Push Jerk
  never mentioned the elbows at all**. Both now name the lock, as both presses
  and the library's sixteen lockout strings do.
- Neither split cue mentioned the **back knee**, although the Split Jerk's own
  `why` quotes Everett that it must stay bent. Both now say so.
- **Barbell Clean and Jerk setup step 5** told the reader to lower a loaded
  jerk from overhead to the shoulders and then to the floor. Now: light bar
  down, loaded bar dropped.
- The **Push Jerk's comparison badge called splitting the feet a fault** — it is
  a different, legitimate lift the app ships separately. It now names the fault
  this entry owns: receiving on straight legs, i.e. turning it into a push press.
- The Push Jerk's setup put the weight **toward the heels**, contradicting its
  own dip and drive cues; the Split Jerk's setup had the reader **duck under**
  a bar to rack it on the front of the shoulders (the Behind-the-Neck Press's
  walkout). Both corrected; the Split Jerk's dip depth is now checkable.
- Neither jerk said how the bar gets back to the shoulders between reps. The
  Push Jerk gained a fifth setup step; the Kettlebell Clean and Press's descent
  now goes through the rack instead of starting at the lockout.

## Checks run

- `python3 spec_1029.py jerk` prints **OK (5 exercises)**; `python3 spec_1029.py`
  prints **OK (25 exercises)**, with the eleven jump and conditioning lifts
  listed as not written yet.
- `chk.py` against the installed spec: **0 lifter-overlap frames and 0
  leader-on-face frames on all 25 pills**; load-inside frames as tabulated
  above.
- `python3 integrate_1029.py <scratch>` wrote the setup steps, the five
  content-map entries and the content blocks; FaultPoses untouched.
- `Tools/lab/build.sh`: **BUILD SUCCEEDED**, installed on the harness simulator.
- `Tools/lab/shoot_ex.sh` at 0, 2 and 3.5 s: all five screens show their five
  pills, the legend and the setup drawer, no pill sits on the lifter, and the
  Push Jerk's drawer shows its new fifth step.
