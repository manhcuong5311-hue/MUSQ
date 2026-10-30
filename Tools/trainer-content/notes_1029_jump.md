# Model-only batch (2026-10-29): jump family

Content: `spec_1029_jump.py`. Four exercises that were in the library with a
model but no `ExerciseContent`:

| Exercise | Model | Framing |
|---|---|---|
| Box Jump | `Legs/BoxJump` | yaw -1.3, zoom 0.664, offset [0.054, -0.045, -0.194] |
| Step-Up Jump | `Legs/StepUpJump` | yaw -1.3, zoom 0.743, offset [0.062, -0.065, -0.225] |
| Squat Jump | `Legs/SquatJump` | yaw -0.8, zoom 0.670, offset [0.020, -0.077, -0.021] |
| Jump Rope | `Legs/JumpRope` | yaw -0.8, zoom 0.575, offset [0.049, -0.040, -0.050] |

No ghosts yet, as for every family of this round: each mistake view falls back
to the red ring.

## What the four clips actually hold

Three things that would be got wrong by anyone writing from the exercise names:

- **Box Jump and Step-Up Jump run 384 frames, 15.958 s — twice the length of
  every other clip in the round.** Each is two identical reps of 192 frames
  (circular lag 192 agrees to 0.000679 mm and 0.000854 mm respectively), so
  every tempo claim has to be rep-local and no share of the clip can be
  computed against 192.
- **Squat Jump carries no equipment at all.** `eq_names` is empty and `eqc`,
  `eqbox` and `eqpts` are empty on every frame, so there is no load geometry to
  clear and all ten label slots are available to the silhouette test alone.
- **Jump Rope's rope never passes under the feet.** Its circle sits 14.1 cm in
  front of them and stops at shin height, so it never reaches the floor. It is
  a rig artefact; the public copy now states the real mechanic (the rope passes
  under the feet while you are off the floor) instead of coaching around it.

Rep structure: Box Jump and Step-Up Jump are **two reps** of 8.000 s; Squat
Jump is **three reps** of 64 frames each (lag 64 agrees to 0.000524 mm, next
nearest lag 276.5 mm); Jump Rope is **sixteen bounces** of 12 frames, 120 a
minute, with no set-up frame and no finish frame. All four loop exactly.

Freeze: Box Jump holds 160 of its 384 frames (41.7%) in a frozen pose, 156
frame intervals = 6.500 s of the 15.958; Step-Up Jump holds 89 frames of each
192-frame cycle. Frame COUNTS are used for shares of a clip and frame INTERVALS
for durations in seconds — the module now says so, because the draft mixed the
two conventions between those two entries.

## How the models were read

Same method as the jerk family, and the same two traps:

- **The rigs are skinned.** `UsdGeom.Mesh.GetPointsAttr().Get(t)` returns the
  REST pose at every time code, so every silhouette here is UsdSkel LBS
  evaluated per frame and binned at 655 rows, one per screen pixel
  (`<Name>_SIL.npz`). Mesh points would have put every pill in the wrong place.
- **A leader is tested against the HEAD'S OWN silhouette** (`<Name>_HEAD.npz`),
  not a box round the head joint — the drawn crown sits 36.8 to 39.3 px above
  that joint on Box Jump — and not the whole body at head height.

Tools, all spec-free so a draft can be tested before the module exists:
`room.py <lift> <lengths>` (every slot's clearance from the skinned lifter and
from the load, and how many frames the load is inside the pill), `lead.py <lift>
<joint> <row> <side> <len>` (how many frames a leader lies inside the head), and
`chk.py` (the installed layout, every pill and every leader). `val.py` runs the
repo's own `validate()` against a candidate module.

## Claim by claim

### Evidence behind the coaching

| Claim | Where it comes from |
|---|---|
| No box height is prescribed | Dos Santos 2024, 14 men / 17 women at five box heights: peak force higher at 80% of max than at zero in the WOMEN only, no significant difference on any other variable. The 12-18 inch beginner range in Box Jump step 1 is NASM's, named as coaching, not as a finding |
| Soft landing lowers peak force | Myers 2011, 16 adults from 40 cm: 1.63 against 2.60 body weights, 55.4 against 36.8 degrees of knee travel. Guy-Cherry 2018, 30 participants, same height: 1.34 against 1.81 |
| Landing on a box is cheaper than landing on the floor | Janikov 2023, 20 trained men: about 51% less peak impact force in the box jump than the hurdle jump, no difference in peak velocity or total impulsion time. That study recorded no muscle activity |
| Knees caving in | No study here tested a knee cue on a jump. Carried as the library's own badge, which it uses SIX times (`SampleData.swift` :6534, :12347, :16842, :31165, :32592, :47476 — five with `Knees collapse inward`, :32592 with `Knees cave in toward each other`) |
| Nothing claims a muscle level | There is no %MVIC or %MVC-normalised EMG study of a box jump, a step-up jump, a squat jump or skipping anywhere in the library's citations. The only jump-adjacent sourced claims sit on `plyometricPushUpContent` and are about push-ups |

### Activation rows

21 rows over the four lifts, 17 of them carried from shipped blocks and 4
estimates — only two distinct new numbers (`Hamstrings 0.25` on three lifts,
`Hip Flexors 0.40` on one). Row parent for the family is `squatContent`, the
bodyweight two-legged squat: the library has no plyometric lower-body entry.

| Lift | rows | notes |
|---|---|---|
| Box Jump | Quadriceps P 0.84, Gluteus Maximus P 0.56, Gastrocnemius S 0.30, Soleus S 0.30, Hamstrings S 0.25, Hip Flexors S 0.24 | 2 primary; Hamstrings is an estimate |
| Step-Up Jump | Quadriceps P 0.82, Gluteus Maximus P 0.64, Hip Flexors P 0.40, Gastrocnemius S 0.30, Soleus S 0.30, Hamstrings S 0.25 | 3 primary; Hip Flexors and Hamstrings are estimates. The parent's `Gluteus Medius .primary 0.44` is dropped under the one-glute-row rule and nothing replaces it |
| Squat Jump | Quadriceps P 0.84, Gastrocnemius P 0.78, Soleus P 0.60, Gluteus Maximus P 0.56, Hamstrings S 0.25 | 4 primary |
| Jump Rope | Gastrocnemius P 0.78, Soleus P 0.60, Quadriceps S 0.25, Hamstrings S 0.20 | no estimate in it at all |

Every fraction follows the paint in `tiers_jump.json`; every name resolves
through `part_of()` (`Hip Flexors` via `LEGEND_ONLY`); every level word was
checked through `common_1_50.level()`.

## Labels

Twenty pills, five per lift. Every figure below was measured at the pill the
app DRAWS — half-height 0.025 in v, width `(24 + 5.6*len)/382`, pinned 0.035
from the leading or trailing frame edge — against the skinned silhouette over
EVERY frame, and every leader against the head's own silhouette.

| Lift | pill | slot | len | lifter | load | leader on the head |
|---|---|---|---|---|---|---|
| Box Jump | Chest up | 0.80 leading | 8 | +158.4 px, 0 frames | box 1.9 px, 0 inside | 0/384, never spans the head rows |
| | Dip and swing | 0.64 leading | 13 | +26.6 px, 0 frames | box 23.1 px, 0 inside | 0/384, closest 70.3 px |
| | Heels lift | 0.32 leading | 10 | **-87.2 px, 6 frames** | box 232.7 px, 0 inside | 0/384, closest 97.2 px |
| | Soft knees | 0.16 leading | 10 | **-57.5 px, 10 frames** | box 337.5 px, 0 inside | 0/384, closest 13.4 px |
| | Step down | 0.48 leading | 9 | **-54.7 px, 14 frames** | box 127.9 px, 0 inside | 0/384, never spans the head rows |
| Step-Up Jump | Flat on the box | 0.64 leading | 15 | +11.6 px, 0 frames | box 46.5 px, 0 inside | 0/384, never spans |
| | Slight lean | 0.32 trailing | 11 | +14.3 px, 0 frames | box 263.0 px, 0 inside | 0/384, closest 17.1 px |
| | Legs up | 0.48 trailing | 7 | +3.1 px, 0 frames | box 177.1 px, 0 inside | 0/384, never spans |
| | Both feet off | 0.16 trailing | 13 | +19.9 px, 0 frames | box 362.2 px, 0 inside | 0/384, closest 11.3 px |
| | Soft knee | 0.80 leading | 9 | +178.7 px, 0 frames | box 16.8 px, 0 inside | 0/384, never spans |
| Squat Jump | Hips back | 0.48 trailing | 9 | +18.1 px, 0 frames | no load | 0/192, closest 99.2 px |
| | Swing the arms | 0.16 trailing | 14 | +6.8 px, 0 frames | no load | 0/192, closest 15.8 px |
| | Heels lift | 0.80 trailing | 10 | +27.6 px, 0 frames | no load | 0/192, never spans |
| | Straight up | 0.32 trailing | 11 | +15.8 px, 0 frames | no load | 0/192, closest 44.7 px |
| | Soft knees | 0.80 leading | 10 | +59.7 px, 0 frames | no load | 0/192, never spans |
| Jump Rope | Quiet hands | 0.16 trailing | 11 | no lifter in the band | rope 37.6 px, 0 inside | 0/192, closest 16.6 px |
| | Feet close | 0.80 leading | 10 | +104.5 px, 0 frames | rope 18.5 px, 0 inside | 0/192, never spans |
| | Heels lift | 0.80 trailing | 10 | +29.0 px, 0 frames | rope 20.9 px, 0 inside | 0/192, never spans |
| | Low bounce | 0.64 leading | 10 | +102.0 px, 0 frames | **rope inside 16 frames** | 0/192, never spans |
| | Steady rhythm | 0.16 leading | 13 | no lifter in the band | rope 21.2 px, 0 inside | 0/192, closest 76.5 px |

**Every leader is clear of the head on every frame of all four clips.** Two
things are not clean, both declared:

- **Box Jump breaches the round's hard pill rule.** Three of its five pills sit
  on the lifter for 6, 10 and 14 frames — 30 of 1,920 pill-frames, 1.56%, all
  inside one 0.63 s window of each rep (the landing and the stand-up). No
  compliant layout exists on the five-row grid: at four characters exactly
  three of the ten slots are clean of the lifter, and one of those three
  (0.16 trailing) puts all 27 probed joints on the face, so only two usable
  slots exist for five pills. Open point 6 in the module carries three measured
  options and hands the choice to the owner. `shots/trainer/box-jump_t2.208.png`
  is the worst frame: the Heels lift pill passes over the left forearm.
- **Jump Rope's Low bounce pill takes the rope on 16 of 192 frames** (0.667 s).
  The rope spans u 0.058-0.946 and is in the 0.48 band for the whole clip, so
  every middle slot takes it; 16 frames is the cheapest crossing that exists,
  and it is bought by the 10-character label.

Legend truncation (`legendRow` is `.lineLimit(1)` on both name lines, budget
about 40-44 characters): Box Jump's secondary line is 49 characters and loses
`HIP FLEXORS` at every phone width; Squat Jump's primary line is 53 and loses
`GLUTEUS MAXIMUS` at every phone width; Step-Up Jump's primary line is 42 and
fits at 393 pt but is cut at 375. The stills confirm all three.

## What this session changed in the draft

Two attack stages raised 41 findings against the drafted module. **I
re-measured every disputed figure myself from the data files rather than taking
the reports** — `verify.py` in the round folder — and every substantive finding
reproduced. 42 fact fixes and 21 coaching / open-point fixes were applied.

Fact fixes that mattered most:

1. **Box Jump open point 6(c) rested on a false claim.** The draft said the
   trailing gutter "cannot help". It can: a second clean band runs drawn
   v 0.87-0.92, where the lifter never enters the band at all, and from a
   trailing pill at v 0.90 at 8 characters **26 of the 27 probed joints give a
   clear leader** (only `head`, which anchors nothing). So the readable
   alternative is four pills left and one lower-right, not five stacked in one
   gutter. The low trailing band is also 0.07-0.23, not 0.08-0.22.
2. **Step-Up Jump's flight rises mixed two reference frames in one sentence** —
   the toe and ankle measured from f40 (last contact), the pelvis and centroid
   from f41 (first airborne), under one qualifier. Corrected to f40 throughout:
   toe 0.208 m, ankle 0.217, pelvis 0.216, centroid 0.210. The "about 55%" of
   the hang-time rise followed from the wrong frame and is **82%**.
3. **Step-Up Jump's catch quoted the take-off height as a catch endpoint.**
   1.404 m is the pelvis at f41; the catch runs 1.212 m to 1.163 m (4.9 cm) at
   the end of a 38.7 cm fall from the 1.551 m apex.
4. **Squat Jump's ankle figure did not follow from its own endpoint.** 146.578
   minus 76.101 is **70.48**, not 68.8; 68.79 is measured from f28. Both are now
   stated with their endpoints.
5. **Squat Jump's landing is 38 degrees shallower than the dip**, not 45 —
   122.093 against 84.098. The 45 is flexion from the standing 166.832.
6. **Squat Jump's "next nearest lag is 1283.5 mm" was the half-period**, i.e.
   the most distant lag. The next nearest is 276.5 mm (lags 1, 63, 65).
7. **Box Jump's "the pelvis finishes the flight 8.7 cm above standing"** — it
   PEAKS 8.7 cm above; at the last airborne frame it is 5.1 cm BELOW, and the
   fall from apex to settled is 27.7 cm. The derived "8.7 cm drop onto a box"
   was reworded in both places it appeared.
8. **Two library counts were short.** KNEES CAVING IN is badged six times, not
   four; the library has six leg presses, not five, and `legPress45Content`
   belongs with the two that carry no Hamstrings row.
9. **Jump Rope is not time-symmetric in the arms.** Legs and trunk agree to
   under 0.2 mm between frame i and frame 12-i; the forearms differ by 48.6 mm
   and the hands by 40.0 mm — which is the 18.34 degrees the elbow opens.
10. Plus: the Box Jump silhouette width range (88-231 px, not 96-226), the
    "250 of 384 standing frames" that reproduces from nothing (234 frames have
    at least one foot on the floor), the toe clearing the box's front face by
    11.1 cm rather than 11.5, 22 frozen joints rather than 24, the knee maximum
    at f34 rather than f36, the knee range 15.93 rather than 16.00, the shins
    spanning u 0.547-0.637, the stance at 46.8-48.5% of shoulder width (47.9% is
    the clip mean), hip_R's 110.8 minimum belonging to the catch and not the
    apex, the hands finishing 0.154 m above the head joint, a 12-frame drive
    window counted as 11, four slot-geometry figures attributed to the wrong
    slot, and the two frame-to-second conventions.

Coaching fixes, all on strings the ungated reader sees (`instructions()` shows
the SETUP steps and each cue's `title` + `correct`; `intro`, `why` and `mistake`
are gated, and `mistake` is behind the paywall as well):

1. **Box Jump said nothing about a jump that comes up short** — the one lift of
   the four where the failed rep meets a hard edge. Step 5 now carries the bail.
2. **Box Jump's landing cue contradicted the animation.** It asked for "whole
   foot down" while the model lands toe-first with the heel 0.167 s behind.
   Rewritten on Squat Jump's own pattern: toes down first and the heels
   following, well back from the front edge (the ankle settles 31% of the way
   back on a 64 cm box, not in the middle).
3. **Step-Up Jump's defining instruction was paywalled.** That the back foot
   does nothing lived only in `drive.mistake`, while step 2 told the reader to
   leave that foot flat on the floor. `drive.correct` now says the back foot
   goes light and the jump is straight up, and the title reads **Drive Up Off
   the Box** — the old "Drive Off the Box" read as jumping down off it.
4. **Jump Rope's only public rope-timing sentence was shaped by the broken
   rope** and told the reader to ignore the rope's sound, which for a beginner
   whose rope does hit the floor is the most reliable rhythm cue there is. It
   now states the mechanic instead.
5. **Jump Rope asked for a heel position its own measurement contradicts.** The
   module rejected a HEELS DROPPING badge because the model puts the heel down
   on the bottom frame of every bounce (the foot joint reaches its minimum on
   exactly 16 of 192 frames), then told the reader to keep the weight on the
   balls of the feet for the whole set. Both strings now say the heels settle.
6. **The setup steps were the longest the app has ever carried.** Against a
   library median of 61 characters and a p99 of 132, the draft had 11 of 19
   steps over p99 and a 242-character step that would have been the longest
   ever shipped (record 214). Cutting only clauses that the cue strings on the
   same screen already carry brings it to 18 steps, 9 over p99, longest 198.
   Jump Rope's step 4 was dropped outright — `hands.correct` restated all of it.

## Open points for the owner

Recorded in the module, not decided here:

1. **The calf tier runs opposite to measured ankle travel.** Step-Up Jump moves
   the ankle 80.5 degrees and Box Jump 63.9 and both are painted DIM (LOW 0.30);
   Jump Rope moves it 25.9 and is painted BRIGHT (HIGH 0.78). The rows follow
   the paint, so the table says a box jump works the calves at LOW and skipping
   at HIGH.
2. **The dim soleus: row or stabiliser, for the whole round.** This family gives
   it a row; Power Snatch, Dumbbell Snatch and Dumbbell Clean and Press, shipped
   in this same round, put it in the stabilisers. `spec_1029_jerk.py` 10.14
   already flags its own side of this.
3. **Two calf rows tied at 0.30** on Box Jump and Step-Up Jump, which breaks the
   house gastrocnemius-above-soleus gap.
4. **Gluteus Medius dropped from Step-Up Jump against its parent** —
   `stepUpContent` carries it primary at 0.44. Under the one-glute-row rule the
   family's one one-legged lift names no frontal-plane muscle at all.
5. **Hip Flexors is invisible to the reader on both surfaces.** `part_of()` and
   `MusclePart(muscleName:)` both return nothing for it, so the app drops it
   before TARGET MUSCLES is built and the legend cuts it. Box Jump and Step-Up
   Jump therefore show the reader identical TARGET MUSCLES. Three options in the
   module: leave it, reorder it first, or drop the Box Jump row.
6. **Box Jump's pill rule breach** (above), with three measured options.
7. **Squat Jump's flight cue spends a fifth of the public coaching on drift**
   while the badged fault is the knees — and the clip rules drift out (the feet
   land where they left to 0.000 mm). Moving the slot would re-measure five
   pills.
8. **Squat Jump's glutes are painted bright, cut from the legend and invisible
   in the render** (the shorts hem covers them; no painted pixel above v 0.437).
9. **The nine setup steps still over the library p99**, which cannot be split
   under the 3-5 step rule without dropping content.
10. **No fault ghosts**, as for every family of this round.

## Checks run

- `FAM=jump val.py spec_1029_jump.py` → `OK (4 exercises)`
- `python3 spec_1029.py jump` → `OK (4 exercises)`; `python3 spec_1029.py` →
  `OK (29 exercises)`, 7 not written (the cond family)
- `FAM=jump chk.py` on the installed layout → **20/20 leaders clear of the head
  on every frame**; 17/20 pills clear of the lifter on every frame, the three
  Box Jump exceptions listed above with their frame counts
- `verify.py` — my own re-measurement of all 41 disputed figures from
  `*_A.json`, `*_SIL.npz`, `*_HEAD.npz` and `SampleData.swift`
- `integrate_1029.py` → 29 exercises, 0 fault families
- `Tools/lab/build.sh` → BUILD SUCCEEDED; `shoot_ex.sh` at t 0, 2, 4 for all
  four and t 2.208, 2.5 for Box Jump → `shots/trainer/`
