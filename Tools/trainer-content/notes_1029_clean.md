# Model-only batch (2026-10-29): clean family

Content: `spec_1029_clean.py`. Four exercises that were in the library with a
model but no `ExerciseContent`:

| Exercise | Model | Framing |
|---|---|---|
| Barbell Power Clean | `Legs/BarbellPowerClean` | yaw -0.8, zoom 0.639, offset [-0.006, 0.023, 0.006] |
| Hang Clean | `Legs/HangClean` | yaw -0.8, zoom 0.629, offset [0.001, 0.024, -0.001] |
| Dumbbell Hang Clean | `Legs/DumbbellHangClean` | yaw -0.8, zoom 0.862, offset [0.018, 0.032, -0.019] |
| Kettlebell Clean | `Legs/KettlebellClean` | yaw -0.8, zoom 0.870, offset [0.018, 0.043, -0.019] |

No ghosts yet, as for the other families of this round: each mistake view
falls back to the red ring.

## How the models were read

The round folder's scripts, rebuilt after the machine restart wiped
`/private/tmp` (`summ.py`, `trace.py`, `props.py`, `nearest.py`,
`trainer_shot.py`, `overlay.py`). `trace.py` is new this family: it prints
pelvis height, trunk angle, both knees, hips and elbows, hand height and
depth and the heel height every half second, which is what the phase
breakdowns below are read from. Paint from `Tools/model-pipeline/tiers.py`.

## Claim by claim

### What the four clips hold

| Claim in the copy | Source |
|---|---|
| Power clean: one rep from the floor and back, not a set | Model (`trace.py`): setup 0-0.5 s, pull to 2.0 s, catch 2.5 s, stand 3.0 s, rack held 3.0-5.0 s, lowered to the floor by 7.5 s |
| Power clean setup: knees 98, hips 57, trunk 62 degrees, pelvis 0.58 m, hands 0.32 m | Model (`summ.py`, `trace.py`) |
| Power clean first pull: pelvis 0.58 to 0.72 m, trunk 62 to 27 degrees, knees 98 to 111 | Model, t 0-1.5 s |
| Power clean second pull: knees 151, hips 169, trunk 8 degrees behind vertical, heels 6 cm up (0.07 to 0.13 m), hands 1.03 m, elbows 142 | Model, t 2.0 s |
| Power clean catch: knees fold to 101, elbows 142 to 52, bar at 1.16 m | Model, t 2.5 s |
| Power clean rack: knees 174, elbows 43, hands 1.39 m, held two seconds | Model, t 3.0-5.0 s |
| Bar travel 1.24 m; 0.19 m forward between pull and catch, back to 0.16 m at the rack | Model (`props.py`: the 2.04 m bar with 0.45 m plates moves 123.8 cm; hand z 0.10 to 0.29 to 0.16) |
| Grip 0.61 m against shoulders 0.39 m; feet 0.22-0.30 m apart | Model (`summ.py`) |
| Hang clean: two reps, one every 4.0 s, starting standing with the bar at 0.92 m | Model (`trace.py`), knees 175 and trunk 10 degrees at the start |
| Hang clean dip: trunk 37 degrees, knees 150, bar 0.79 m (just above the knee), knees bending only 25 degrees | Model, t 0.5 s |
| Hang clean extension: trunk back to 15 degrees, heels 5 cm up | Model, t 1.0 s |
| Hang clean catch and rack: elbows 62 then 43, knees 110 then 165-175, bar 1.20 then 1.39 m | Model, t 1.5-2.5 s |
| Hang clean bar travel 0.60 m against the power clean's 1.24 m | Model (hand y 0.79 to 1.39 against 0.32 to 1.39 with the bar's own 1.24 m travel) |
| Dumbbell hang clean: bells 0.33 m long with 0.17 m heads, hands 0.69 m apart at 0.92 m, elbows 173 degrees at the start | Model (`props.py`, `summ.py`) |
| Dumbbell dip: trunk 26 degrees, knees 175 to 137, bells down to 0.83 m | Model, t 0.5 s |
| Dumbbell catch and rack: elbows 68 then 31 and 35 degrees, knees 118, hands 1.37 then 1.47 m | Model, t 1.5-3.0 s |
| The hands part to 0.93 m and close to 0.42 m at the rack; the feet never move (0.24-0.26 m) | Model (`summ.py`: handgap min 0.42 max 0.93, anklegap 0.24-0.26) |
| Kettlebell clean: one bell (0.26 x 0.32 x 0.31 m) in the left hand, three cycles, the right arm still all clip (elbow 168 degrees, hand 0.92 m) | Model (`props.py`, `summ.py`: elbow_R min = max = 167.93) |
| Kettlebell rack: elbow 41 degrees, hand 1.40 m, knees 176 | Model, t 0, 2.0-3.0, 4.5-5.5, 7.0-7.5 s |
| Kettlebell swing down: arm straight to 180 degrees, hand 0.74 m, trunk 37 and knees 133; deepest cycle trunk 52, knees 122, hand 0.65 m | Model, t 0.5-1.0 s and t 3.5 s |
| The bell travels 0.85 m | Model (`props.py`: the bell mesh moves 85.3 cm) |
| Feet 0.37-0.39 m apart and the heels stay down - no heel lift, unlike the barbell cleans | Model (`summ.py`: anklegap 0.37-0.39, ankleY 0.07-0.09 against 0.07-0.13 on the barbell cleans) |

### Evidence behind the coaching

| Claim in the copy | Source |
|---|---|
| Nothing is claimed about how hard any muscle works relative to another | Geisler 2023 (J Sports Sci Med 22(4):778-789, doi 10.52082/jssm.2023.778, abstract read 2026-10-29) is the closest EMG study - 27 weightlifters, hang power clean and hang power snatch against the matching pulls at 50, 70 and 90% 1RM, EMG of vastus lateralis, gluteus maximus, erector spinae, rectus abdominis and trapezius normalised to MVIC - but the abstract publishes no percentage of MVIC and measures no hamstring, so it is cited for what it compared, not for a number |
| The one-arm kettlebell clean asks more of the obliques than a swing does | Lyons 2017 (J Strength Cond Res 31(9):2363-2370, doi 10.1519/JSC.0000000000001771, PMID 28394829): 14 resistance-trained men at a self-selected 8-10RM; the external oblique was more active in the snatch and the clean than in the swing, the erector spinae higher in the swing than the snatch, and the vastus lateralis higher in the swing than the clean. It found no difference between the three in the gluteus maximus, biceps femoris, the deltoids or the biceps, so none of those is re-ranked on it |
| Everything else in the cues (bar path, catch depth, elbow position, rack mechanics, the bell rolling round the hand) | Mechanical reasoning from the measured model, marked as such here: no study is cited for any of it, and no cue claims an outcome a study has not measured |

### Activation rows

All four models paint the same thing: the three hamstrings and the three
glutes bright; the quadriceps, erector spinae, the three trapezius parts,
the rhomboid major and the anterior deltoid dim; plus the biceps on the
three that hold a bar or a bell in both hands (the dumbbell version does not
paint them, so it has no Biceps Brachii row). The Kettlebell Clean adds
bright external and internal obliques on the side away from the bell and a
dim rectus abdominis.

The rig lights the three glutes as one group and the owner confirmed on
2026-10-30 that the paint has not been split, so they stay one Gluteus
Maximus row and the copy says glutes rather than naming the medius.

Fractions are the library's Clean and Press - the same pull with a press on
the end - with the ranks moved to follow each model's paint, which is the
README's rank-change rule: Gluteus Maximus 0.70, Quadriceps 0.62,
Trapezius 0.70, Erector Spinae 0.55, Hamstrings 0.50, Biceps Brachii 0.30.
Anterior Deltoid 0.30 is an estimate for a catch that only guides the bar
onto the shoulders. The Kettlebell Clean swaps the two-handed Trapezius 0.70
for the Suitcase Carry's one-arm 0.44 and takes its Obliques 0.60 and
Rectus Abdominis 0.30.

**Open point for the owner.** Quadriceps 0.62 sits above Hamstrings 0.50
while ranking below it, because the fraction is carried from Clean and Press
and the rank follows this model's paint. That is the same pattern the
library already carries on the Reverse Curl, but it reads oddly in the
legend. Either re-paint the quadriceps bright on these four, or re-estimate
the fraction.

## Labels

Rows are the batch's squeezed set (0.16, 0.32, 0.48, 0.64, 0.80), all five
pinned with `overrides` on every lift, checked by drawing them over the
trainer stills at 0, 1, 2 and 3 s (`overlay.py`) and then on the harness
simulator at 0, 2 and 3 s.

The moving equipment is what drives the layout here, not the lifter:

- **Barbell Power Clean.** The 2.04 m bar crosses the whole frame, plates
  included, and sweeps from v 0.66 at the floor to v 0.30 in the rack, so
  every row between is covered at some moment of the clip. Round 1 put the
  catch pill on the right of row 0.32 and it sat on the racked bar. Both arm
  pills now share the top row (the head never rises above v 0.27) and the
  trunk and foot pills the bottom row (below the bar's lowest point), with
  only the bar pill in the sweep - shortened to the library's own nine
  characters, `Bar close`, at the far left edge, exactly as the Clean and
  Press entry places the same cue.
- **Hang Clean.** The bar never drops below v 0.48 here, so rows 0.64 and
  0.80 are clear: the hang and dip pills share row 0.64 and the drive pill
  sits at 0.80, with the two arm pills above everything at 0.16.
- **Dumbbell Hang Clean.** The bells work between v 0.23 and 0.47, so the
  lower rows are the clear ones; the dip pill is 16 characters so its left
  edge stops at u 0.668, clear of the lead shoe at u 0.65.
- **Kettlebell Clean.** The bell sweeps u 0.40-0.68 between v 0.25 and 0.53
  and the free hand sits at u 0.30-0.42 around v 0.50, so the bell pill
  joined the top row and the hinge pill shortened to `Hips back` (nine
  characters, ending at u 0.23) to clear the free hand.

## Checks run

- `python3 spec_1029.py clean` prints OK (4 exercises), and
  `preview_1029.py clean` prints the layout.
- `python3 integrate_1029.py <scratch>` wrote the setup steps, the four
  content-map entries and the content block; FaultPoses untouched.
- `Tools/lab/build.sh --no-install` with `LAB` in the session scratchpad:
  BUILD SUCCEEDED.
- `Tools/lab/shoot_ex.sh` on the harness simulator at 0, 2 and 3 s: all four
  screens show their five pills, the legend and the setup drawer, and no
  pill sits on the lifter.
