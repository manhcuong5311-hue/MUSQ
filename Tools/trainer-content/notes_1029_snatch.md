# Model-only batch (2026-10-29): snatch family

Content: `spec_1029_snatch.py`. Three exercises that were in the library with
a model but no `ExerciseContent`:

| Exercise | Model | Framing |
|---|---|---|
| Power Snatch | `Legs/PowerSnatch` | yaw -0.8, zoom 0.598, offset [0.002, -0.055, -0.002] |
| Dumbbell Snatch | `Legs/DumbbellSnatch` | yaw -0.8, zoom 0.721, offset [0.011, -0.048, -0.012] |
| Kettlebell Snatch | `Legs/KettlebellSnatch` | yaw -0.8, zoom 0.727, offset [0.007, -0.041, -0.007] |

No ghosts yet, as for the other families of this round: each mistake view
falls back to the red ring.

## How the models were read

Written through the README's agent process under ultracode: three measuring
agents (one per lift), a sources sweep, a family drafter, two reviewers, a
reviser and a final skeptic, then this session's own re-measurement of every
label figure. The measuring scripts are in the round folder's `snatch2/`
(`m.py` reads every joint's world transform and every equipment mesh's points
at all 192 integer frames and projects both through each lift's own trainer
framing; `ph.py`, `ph2.py`, `det.py` and `size.py` read the phases, the
per-mesh geometry and the equipment sizes off that; `skin.py` evaluates
UsdSkel linear-blend skinning for the lifter's silhouette), and the final
checks in `final/` (`chk.py` for pill and leader geometry, `headsil.py` and
`face.py` for the head, `slots.py` and `slots2.py` for the slot sweeps).

Two things matter about the measurement and are easy to get wrong:

- **These rigs are skinned**, so `UsdGeom.Mesh.GetPointsAttr().Get(t)` on a
  body mesh returns the REST pose at every time code and projecting it gives
  a standing silhouette that never moves. Every lifter clearance here is from
  the skinned silhouette, evaluated per frame, at 655 rows - one row per
  rendered pixel. An earlier pass used 160 rows and its clearances are
  2-4 px out, which is why the published numbers were re-measured.
- **joints.json is not a substitute.** It holds 8 samples per joint, at
  t 0, 0.99, 1.99, 2.98, 3.98, 4.97, 5.97 and 6.96 s (`probe.py`'s fractions
  0 to 0.875 of a 191-frame clip), and `gen.py` uses them to choose a row
  while the app tracks the live joint every frame (`Exercise3DView.dotPoint`).
  On the Dumbbell Snatch hand_L sweeps u 0.357-0.774 over the clip against
  only 0.390-0.679 at those eight moments.

Paint from `Tools/model-pipeline/tiers.py`, re-read 2026-10-30. Three
independent reads (two drafting agents and the final skeptic) agree muscle
for muscle on all three models.

Frame: Y up, the lifter faces +z, their left is +x, metres. Knee and hip are
inner angles (180 straight), trunk is the neck-over-pelvis line from vertical
(+ forward). All three clips run 7.96 s at 24 fps (192 frames), the shoulders
are 0.392 m apart in all three, and all three are seen from behind and a
little to the lifter's left (yaw -0.8), so the back, the glutes and the
hamstrings face the camera and the working arm reads on the viewer's right.

## Claim by claim

### Power Snatch

| Claim in the copy | Source |
|---|---|
| One rep from the floor to overhead and back, not a set; the clip loops | Model (`snatch2/ph2.py`: the pose is identical over 0-0.375 s and 7.625-7.958 s and the last frame matches the first to 0.2 mm) |
| Both sides driven identically; the only asymmetry is the order the feet step back in | Model (`snatch2/ph.py`: elbow_L and elbow_R agree to 0.02 degrees at every frame - round 1 said 0.01; foot_L is out from 2.29 to 3.42 s, foot_R to 3.92 s) |
| Set-up: trunk 69 degrees forward, knees 83, hips 46, pelvis 0.520 m, bar 0.225 m, hands 0.323 m, feet 0.220 m apart | Model (`snatch2/m.py`, `ph.py`), t 0-0.375 s |
| The shoulder joint sits 3.5 cm in front of the bar at the set-up | Model (`det.py` at t=0: upper_arm_L Z 0.1592 against bar Z 0.1243). Round 1 said shoulders OVER the bar, which traced to nothing; the library's Barbell Power Clean coaches shoulders just in front of the bar, which is what this model shows |
| Grip 1.09 m against 0.392 m at the shoulders | Model (`m.py` handgap / shouldergap). Recorded as a ratio in the notes only, never prescribed: 2.8x a joint-to-joint shoulder span becomes 1.1-1.5 m if a reader measures across the deltoids, which runs off the usable span of a 2.04 m bar |
| In the frame the pelvis sits a little above the knee at the set-up | Model (`m.py` projection at t=0: pelvis v 0.647 against patella_L v 0.671) |
| Nothing moves for the first ten frames; the bar does not leave the floor until 0.50 s | Model (`ph2.py` identical-pose runs; `ph.py`: the bar first rises more than 0.5 cm at 0.500 s, the pelvis at 0.542 s) |
| The bar rises 171.3 cm, 0.225 to 1.938 m, and all five meshes move together, so the bar is rigid | Model (`ph2.py`: each mesh rises 171.34 cm). Round 1's 171.7 cm is props.py's maximum DISPLACEMENT from the start pose, not the rise; the path length is 4.33 m |
| A 2.04 m shaft 0.028 m thick, two 0.45 m plates 0.08 m thick and two 0.105 m collars, all under /root/HG_Barbell | Model (`snatch2/size.py`: local extents times the prim's own scale) |
| Bar about over the middle of the foot; wide overhand grip close to the plates; catch the bar on straight arms over your head | StrengthLog snatch page (practice source, read 2026-10-30) - used for position only, never for a number |
| THE MODEL SETS THE BAR FURTHER FORWARD than that mid-foot position: 12.4 cm in front of the ankle joint and 1 cm behind the toe joint, about over the ball of the foot | Model (`det.py` at t=0: bar Z 0.1243, foot_L Z 0.0000, toe_L Z 0.1347). The setup step keeps the sourced mid-foot position and no cue claims the model holds it there; open point |
| First pull: bar 0.225 to 1.019 m, elbows 152 to 149 degrees, pelvis 0.520 to 0.939 m, trunk 69 degrees to 1 | Model, t 0.5-1.958 s. The hand runs 0.098 m above the bar throughout (the wrist sits above an overhand grip), which is where round 1's 0.33-1.106 m came from |
| Cutting horizontal bar travel by about 40 mm did not significantly change peak power, so the cue is control and not kilos | Petrizzo 2016, JEPonline 19(3):24-34 (full text read 2026-10-30): ten subjects, about 40.3 mm, P<0.05, peak power difference about 2.2%, not significant |
| Second pull: knees 150 degrees, hips 168, the trunk through vertical to 7 degrees past it, heels 0.069 to 0.130 m at 1.92 s, arms still 149 | Model, t 1.958-2.000 s (trunk 1.18 degrees at 1.958 s, -6.78 at 2.000 s; hip_L max 171.0 at 3.417 s) |
| The heels lift TWICE - 0.79 s at the second pull (1.67-2.42 s) and 0.25 s again as each foot re-sets in the hold - 1.04 s of the clip in all | Model (`ph.py`, foot_L and foot_R Y against the 0.0686 m floor value at every frame: peak 0.1299 m = 6.1 cm at the pull, 0.0983 m = 3.0 cm at the re-set). Round 1's single 0.84 s window was both short and incomplete |
| The feet jump from 0.220 m to 0.300 m apart to receive the bar and step back in one at a time | Model (`ph.py`, `det.py`: ankle gap above 0.25 m from 2.25 to 3.875 s; foot_L X 0.110 to 0.150 and foot_R -0.110 to -0.150, so each foot moves 4 cm sideways while its heel lifts 3 cm) |
| Catch: elbow 149 to 91 degrees then out to 177 inside a third of a second, pelvis 0.939 to 0.760 m, knees 111 - a partial squat, well above parallel | Model, t 1.958-2.583 s (elbow minimum 91.12 at 2.250 s, maximum 176.74 at 2.583 s; exactly two frames exceed 174, at 2.542 and 2.583). Round 1's one frame and 176.64 at 2.54 s came from summ.py, which steps 1.0008 frames and drifts off the exact frame |
| The elbow is held at nearly full extension from the catch onward and the triceps contract after the turnover, to keep the arm straightened | Wu 2008, 26th ISBS p. 461 (whole one-page paper read 2026-10-30): four weightlifters, TWO FEMALE AND TWO MALE, aged 15-20, a 50 kg barbell, no percentage of maximum, and its phase list includes rising from the squat, so a full snatch rather than a power snatch |
| Lockout: held 1.75 s with the elbow flat at 173 degrees, the bar at its peak 1.938 m - 0.504 m above the shoulder joint, 0.336 m above the head, 1.5 cm in front of the ankle - and the hands 0.098 m lower at 1.840 m | Model (`ph.py` per-frame window scan: elbow at or above 170 from 2.500 to 4.208 s, bar at or above 1.90 m from 2.958 to 4.250 s; geometry read at 3.0 / 3.5 / 4.0 s). Round 1's 1.840 m, 0.406 m, 0.238 m and 1.3 cm are all hand_L, not the bar |
| Stacked over the ANKLES, not over the middle of the feet | Model: at the lockout the bar is 1.5 cm in front of the ankle joint and roughly 5 cm behind the mid-foot, so StrengthLog's mid-foot sentence, which is about the start, is not carried to the finish |
| Return: the elbow folds to 93 degrees at 4.54 s and the bar swings 0.54 m forward of where it locked out before settling on the floor by 7.50 s | Model, t 4.208-7.958 s (elbow minimum 93.16 after 4.208 s; bar Z 0.0149 at the lockout to 0.5530 at 4.458 s) |
| The rotator cuff is most active at the turnover and the catch rather than the pull | Ernst and Jensen 2015, 33rd ISBS p. 200 (abstract read 2026-10-30): nine male Olympic weightlifters, two lifts each at 40, 60 and 80% of maximum snatch; no percentage available, so the cuff is a stabiliser and not a row |
| No cue tells the reader what the literature does not say | Round 1 put an absence-of-evidence claim in the user's face (no source describes a press in a snatch). The copy now argues from measurement - the elbows are 149 degrees at the top of the pull and locked before the bar arrives - and from Ernst and Jensen's phase result; the absence stays here, in the notes |
| Gluteus Maximus 0.70, Quadriceps 0.62, Trapezius 0.70, Erector Spinae 0.55, Hamstrings 0.50, Biceps Brachii 0.30 | Carried from the library's Clean and Press through spec_1029_clean.py's PULL_ROWS - the same pull from the floor. All six are live rows in Clean and Press (SampleData.swift 45610-45618, read 2026-10-30); only the quadriceps changes rank here |
| Erector Spinae 0.55, and the catch rather than the pull loading the low back | Geisler 2023 (doi 10.52082/jssm.2023.778, PMC Results and Table 4 read 2026-10-30): significantly greater in the hang power snatch than the hang snatch pull in all three groups (p<0.05, g=0.27-0.98) - at all three loads only in the elite group, at 50% 1RM only in the advanced and at 90% only in the beginners, so round 1's blanket 50-90% was too strong. Its hang-power-snatch means run about 143-372% MVIC with deviations up to about 322 and the authors call them highly variable, so no percentage is quoted |
| Trapezius 0.70 is carried, not sourced | Geisler 2023's only trapezius finding runs the other way - greater in the PULL, at 50% 1RM only |
| Lateral Deltoid 0.45 | The library's Overhead Carry, its only loaded overhead hold (SampleData.swift 26787). The Clean and Press, the nearest barbell lift that finishes overhead, sits beside it at 0.50; the presses were deliberately not used (Barbell Overhead Press 0.74) |
| Anterior Deltoid 0.40 is a RE-ESTIMATE, not a carry | PULL_ROWS and the four cleans hold 0.30 and the presses 0.84-0.86 (Dumbbell Shoulder Press 0.84, Barbell Overhead Press 0.86). Wu 2008 for the deltoid's phase - after the half way point of the shoulder's full flexion, a range-of-motion milestone and not a point in the lift's duration - and Lyons 2017 for no deltoid difference between swing, snatch and clean |
| Gastrocnemius 0.30 | The paint earns the row; 0.30 is the floor of the library's dim calf rows, which run 0.30-0.50 across spec_400_legcurl.py (0.40, 0.40, 0.36, 0.36, 0.34, 0.30), spec_400_hinge.py (0.50, 0.40, 0.32), spec_legs2.py and spec_1029_legs.py. No snatch study read here measured a calf, but the heel lifts 6.1 cm for 1.04 s and StrengthLog lists the calves as a secondary muscle worked |
| The soleus is painted dim and gets no row of its own | Judgement call: the one Gastrocnemius row carries both painted calf muscles and the soleus is named among the stabilisers. The library splits them only where it has separate evidence (spec_1029_legs.py: Gastrocnemius 0.46, Soleus 0.30, the gastrocnemius higher because it crosses the loaded knee, which is not what loads either here). Open point |
| Both deltoid rows rank PRIMARY on paint alone while the copy says the arms only lock | `tiers.py`: DeltoidAnterior and DeltoidLateral bright on both sides. Neither fraction is sourced for a snatch, so the legend and the cues pull against each other and the Dumbbell Snatch ranks the same two secondary - open point |
| Paint: 12 bright, 10 dim, nothing faint, nothing one-sided | `tiers.py` re-run 2026-10-30 (snatch2/mytiers_PowerSnatch.json, identical to round 1's tiers_powersnatch.json) |
| The bar sweeps u -0.002-0.942 and v 0.157-0.835, so only the leading pill at row 0.16 is free of it | Model (`snatch2/pill.py`: all five bar meshes, 720 projected points a frame, every frame, this lift's own framing) |

### Dumbbell Snatch

| Claim in the copy | Source |
|---|---|
| One rep, 7.96 s at 24 fps, 192 frames | Model (`snatch2/m.py`: frames 1-192; hand_L crosses its midpoint only on the way up at 1.88 s and down at 5.75 s) |
| One dumbbell, a 0.34 m handle 0.032 m thick and two 0.16 m heads 0.07 m thick, in the left hand for the whole clip | Model (`snatch2/size.py`, local extents times the prim's scale - round 1's 0.33 m long with 0.22 m heads came off an axis-aligned world box of a tilted bell; `det.py`: the handle is a constant 0.104 m from hand_L at every frame, the heads 0.152 and 0.158 m) |
| The right arm never works: elbow_R only drifts 146 to 170 degrees and that hand never gets above 0.965 m | Model (`m.py`: elbow_R 145.88-169.72, hand_R Y 0.185-0.965) |
| The legs are symmetrical anyway: knee_L 66.6-175.3 against knee_R 66.6-175.4, both heels lifting together | Model (`m.py`, foot_L and foot_R Y identical at 0.069-0.127 m) |
| Set-up: trunk 72 degrees forward, hips 56, knees 67 - 113 degrees of knee flexion - pelvis 0.500 m, hand 0.163 m at depth +0.43 m, feet 0.30-0.32 m against 0.392 m at the shoulders | Model (`m.py`, `ph.py`), t 0-0.375 s. The knee is 46 degrees MORE flexed than the Power Snatch's 83, so the start is a low squat and the round-1 copy that coached a hinge here (label, intro, instruction and setup step) was wrong against the model's own number |
| The first ten frames are identical, so it is a set position and not a swing | Model (`ph2.py`: frames 0.000-0.375 s agree to better than 1e-5 m; the first change is at 0.417 s) |
| Pull: elbow locked at 174 degrees throughout, knees 67 to 165, hips 56 to 168, trunk 72 forward to 5 behind vertical, heels 0.069 to 0.127 m (5.8 cm) | Model, t 0.375-1.875 s |
| Turnover: elbow 174 to 76 and back to 134 in a little over half a second, hand 1.065 to 1.84 m, hand depth +0.28 to -0.08 m (0.35 m in) | Model, t 1.875-2.50 s (elbow_L minimum 76.14 at 2.292 s; 80.79 is the frame before, which is where round 2's 81 came from) |
| The deltoid takes over once the shoulder is more than halfway to full flexion, and the triceps contract after the turnover to keep the arm straight | Wu 2008, 26th ISBS p. 461 (whole paper read 2026-10-30) - its own wording is a shoulder range-of-motion milestone, not a point in time, which round 1 rendered as the second half of the lift. A BARBELL snatch, four lifters (two female, two male, 15-20), no percentage of maximum, which the copy says |
| Lockout: 1.46 s, elbow 174 degrees, knee 175, trunk upright, hand 1.967 m, bell 0.469 m above the head and 0.233 m to the working side | Model (`ph.py` every-frame scan: elbow at or above 170 and hand at or above 1.95 m from 3.167 to 4.583 s). The pose holds to within a MILLIMETRE from 3.333 to 4.500 s and is bit-identical only over 3.625-4.208 s, so round 1's identical 3.25-4.50 s is restated as within a millimetre |
| Coming down the bell is racked to the shoulder before the hips move: elbow to 31 degrees while both knees hold 174-175 | Model, t 4.583-6.1 s (elbow minimum 30.81 at 5.292 s, hand still at 1.47 m) |
| The dumbbell rises 198.3 cm | Model (`ph2.py`, per-mesh centres: 198.18-198.40 cm) |
| Catch: knee 113 degrees and pelvis 0.770 m at 2.88 s, then 175 and 0.908 m | Model (`det.py`: knee_L minimum 113.49 over 2.4-3.1 s, pelvis minimum 0.7698 m) |
| Obliques and rectus abdominis bright on the RIGHT, the side away from the working arm | `tiers.py` re-run 2026-10-30 (snatch2/mytiers_DumbbellSnatch.json): ExternalOblique (R), InternalOblique (R), RectusAbdominis (R) bright; 13 bright, 10 dim, nothing faint |
| Obliques 0.60 and Rectus Abdominis 0.30 | The library's Suitcase Carry, its one-arm anchor: both are live rows there (SampleData.swift 26685 and 26692, read 2026-10-30) after the 2026-10-18 re-paint removed its forearm, lower-back and glute rows, and the Kettlebell Clean already reuses them. Rectus Abdominis stays an estimate - no EMG of it in a dumbbell snatch exists |
| A 0.30 LOW primary is already library practice | SampleData.swift: Middle Trapezius 0.30 primary on six shrugs (25644, 25739, 25833, 25929, 26023, 26120), Forearms 0.30 primary on three hammer curls (37724, 37814, 37904) and Gastrocnemius 0.30 primary on the Seated Calf Raise (33150). Round 1 called it a new lowest primary, which is false; the Pallof Press's Rectus Abdominis 0.44 primary (48372) is the nearer analogue for the same muscle. Both entries this row is carried from rank it SECONDARY, which is the real open point |
| The contralateral external oblique is more active in a one-arm snatch than in a swing | Lyons 2017 (doi 10.1519/JSC.0000000000001771, PMID 28394829), abstract re-read 2026-10-30: direction only, no percentage, 14 resistance-trained subjects, five reps each at a self-selected 8-10RM, a swing-style kettlebell snatch, and the authors note the participants were not experienced kettlebell lifters |
| The pull phase was significantly longer on the lifting side, while peak force and catch loading rate tended to be higher on the free side WITHOUT reaching significance, which the authors put down to pull and catch symmetry | Lake, Lauder and Dyson 2006, Kinetic Analysis of a Unilateral Snatch Movement, 24th ISBS (abstract read 2026-10-30): seven weightlifters, one-handed DUMBBELL power snatches at 80-100% 1RM, two Kistler platforms at 500 Hz, no EMG. No significant load or side effects for pull-phase peak VGRF or catch loading rate (P>0.05); the longer pull phase is P<0.001. Round 1 reported the tendency without the non-significance. The PDF IS reachable, at ojs.ub.uni-konstanz.de/cpa/article/view/277/236, contrary to round 1's note |
| Gluteus Maximus 0.70, Quadriceps 0.62, Trapezius 0.70, Erector Spinae 0.55, Hamstrings 0.50 | Carried from Clean and Press through spec_1029_clean.py's PULL_ROWS; the two-handed 0.70 trapezius is kept because this bell is pulled from the floor, where the Kettlebell Snatch's is swung and takes the one-arm 0.44 |
| No Biceps Brachii row | The rig paints no biceps on this model, as on the Dumbbell Hang Clean (`tiers.py`) |
| Lateral Deltoid 0.45, Anterior Deltoid 0.40, Gastrocnemius 0.30 | The Overhead Carry, the Power Snatch's re-estimate, and the dim-calf judgement call described there, with the dim soleus named among the stabilisers; the deltoid rows rank secondary here because the paint is dim, and the fractions do not move with the rank |
| The turnover pill's dot is the ELBOW, not the hand | Round 1 pointed `Turn it over` at forearm_L from row 0.32 trailing, where that joint lands INSIDE its own pill on 8 frames because forearm_L spans u 0.436-0.794 over the clip against only 0.451-0.689 at the eight probed moments. At row 0.48 trailing the same dot is 10.7 px clear of the pill at every frame |

### Kettlebell Snatch

| Claim in the copy | Source |
|---|---|
| Three identical reps on a 2.67 s loop, the clip opening and closing in the lockout | Model (`snatch2/ph.py`, `ph2.py`: 192 frames / 64 = exactly 3; the frames at 0.833, 3.500 and 6.167 s differ by 0.000000 m on every joint) |
| The right arm is frozen: elbow_R reads 167.931 degrees in all 192 frames, spread 0.0000 | Model (`m.py` per-frame elbow angles) |
| One bell in the left hand: a 0.21 m bell, a 0.033 x 0.15 m handle, two 0.033 x 0.115 m uprights and two 0.033 m beads | Model (`snatch2/size.py`, local extents times the prim's scale; one equipment group, /root/HG_WeightL, 6 meshes) |
| The handle stays 0.104 m from hand_L at every frame | Model (`det.py`, all 192 frames, not a sample) |
| Hinge: trunk to 55 degrees, hips to 93, knees never past 107, pelvis 0.875 to 0.720 m | Model (`ph.py`: trunk maximum 54.71 at 0.833 s, hip_L minimum 93.34, knee_L minimum 107.43 at 1.000 s; pelvis 0.8747 m at 0.625 s where the hinge starts, 0.7198 m at 0.833 s). Round 1's 0.20 m paired the clip maximum, 0.9178 m at 1.375 s - which is at the TOP of the pull, after the hinge - with the hinge bottom; the real drop is 0.155 m and the smaller number makes the point better |
| Then it opens again inside half a second: hips to 169 degrees, knees to 174, trunk to 1 degree | Model, t 0.833-1.292 s (hip_L maximum 169.10 at 1.292 s) |
| Low-back compression was under 3,200 N in every style at every point, which the authors call quite conservative and probably not of clinical significance | McGill and Marshall 2012 (doi 10.1519/JSC.0b013e31823b005f), full text read 2026-10-30: end-of-swing L4/L5 compression 1,903 N (SD 618) for the swing, 2,960 N (SD 1,153) with Kime and 1,589 N (SD 601) for the swing to snatch, but the only significant pairwise contrast there is Kime against snatch (p=0.032) while swing against Kime is p=0.07 and swing against snatch was never reported significant - so round 1's 1,589-against-1,903 framing is dropped and only the ceiling is quoted. Every style in that study was a coached hinge, so it cannot compare hinging with squatting; the hinge-against-squat argument now rests on the measured knee and hip angles |
| The bell covers 4.94 m of path a rep, through 1.709 m up and down, 0.693 m front to back and 0.464 m across the body | Model (`ph2.py`, the bell mesh Sphere_002 per frame; 14.824 m over the clip) |
| At the bottom of the backswing the bell hangs between the legs at 0.323 m, 0.27 m from the hand, touching nothing - the nearest other joint is the far foot at 0.30 m | Model (`ph2.py` at t=0.833 s: hand_L 0.265 m, foot_R 0.299, shin_R 0.302) |
| The bell swings 0.23 m in front of the hand at the drop, reaching Z +0.583 m | Model (`det.py`: bell Z minus hand Z peaks at 0.2301 m at 0.625 s; bell Z maximum 0.5825 m at 0.542 s). Round 1's 0.37 m is not reproducible on any frame |
| A one-handed kettlebell snatch puts about 14% of its impulse into horizontal work against 23% for a TWO-handed swing | Lake, Hetzler and Lauder 2014 (doi 10.1519/JSC.0000000000000538): 22 men, 24 kg, horizontal impulse 18 +/- 7 against 29 +/- 7 N.s, both p<0.0001. The two-handed wording is now in the comparison field as well as the cue, and the figure is used only as a contrast with the swing, never as the cost of letting the bell loop out - it is a between-exercise number and the authors conclude the two are otherwise mechanically similar |
| The bell turns over around the hand: 0.27 m away at the drop, 0.115 m at the turnover, 0.12 m through the lockout; the elbow folds to 55 degrees past the head | Model (`ph2.py` bell-to-hand distance, elbow_L minimum 54.91 at 1.542 s) |
| Hand insertion is one of the named phases of a competition rep | Ross 2017 (doi 10.7717/peerj.3111, PMCID PMC5374970), full text: the rep starts at fixation and has six named phases - drop, re-gripping, back swing, forward swing, acceleration pull and hand insertion - so round 1's seven is corrected to no count at all |
| The hand that worked the last three minutes of a six-minute set WITH A HAND CHANGE AT HALFWAY lost about 10 kg of grip strength | Ross 2017: 9.8 +/- 4.4 kg, p=0.001, twelve male lifters with at least three years of kettlebell training, 24 kg bell, 972 reps. The set changed hands at the 3-minute mark, so it is three minutes of work, not six; and the study ranks grip against nothing else, so round 1's what fails first is gone |
| Lockout: 0.88 s a rep and a third of the clip, elbow 175 degrees, hand 1.965 m and 0.368 m above the head, 1.5 cm to the side of the shoulder and 2.1 cm to the side of the ankle | Model (`ph.py`: 63 of 192 frames meet elbow at or above 170 and hand at or above 1.90 m, in windows 1.917-2.75, 4.583-5.417 and 7.25-0.083 s; geometry read at 2.0 and 4.583 s) |
| A rep only counts once the bell is locked out motionless overhead, and the overhead fixation is one of the two points of relative relaxation in the repetition | Ross 2017, which attributes the relaxation point to McGill and Marshall 2012. Round 1 also claimed low ground force at fixation, which Ross reports for the END OF THE BACK SWING (121 +/- 45 N, about half the bell's weight force), so that half is dropped |
| The heels barely move: both ankles stay inside 0.0686-0.0829 m for all 192 frames, so the heel rises 1.4 cm at the top of each pull against 6.1 cm in the barbell snatch, and each foot holds its place in the frame to within 3 px | Model (`ph.py`, foot_L and foot_R Y at every frame: above base + 2 mm on ten frames a rep, at 1.125-1.50, 3.79-4.17 and 6.46-6.83 s; `m.py` projection: foot_L u range 0.001 = 0.4 px, v range 0.005 = 3.3 px). Round 1's never lifts a heel and no heel ever leaves the floor are false; the 1.4 cm figure still supports leaving the calf row off and matches the unpainted calves |
| The two legs carry different front-to-back loads inside every rep | Ross 2017: anterior-posterior ground force higher in the ipsilateral leg, 165 against 154 N downwards (6.9%) and 164 against 146 N upwards (11.6%), F(1,11)=885.15, p<0.0001 |
| Gluteus Maximus 0.80, Hamstrings 0.76, Erector Spinae 0.50 carried unchanged from the Kettlebell Swing, on the carry and the paint and NOT on a swing-against-snatch contrast | SampleData.swift 47347-47350 (read 2026-10-30): Gluteus Maximus 0.80, Erector Spinae 0.50, Hamstrings 0.76, Adductors 0.38. McGill 2012's exercise effect was significant for only three muscles - right external oblique F=4.27, right rectus femoris F=4.16, left internal oblique F=5.45, all p<0.05 - and the post hoc tests found NO significant external-oblique difference and put the rectus femoris and left internal oblique differences on the swing WITH KIME against the plain swing. Its own text says the swing to snatch appears to increase the activation of almost all muscles. Lyons 2017 found no glute or biceps femoris difference and the erector spinae greater in the SWING. So round 1's the evidence says they must not be raised is withdrawn |
| Quadriceps 0.53 is a new row and an estimate | The row exists because this rig paints the four quadriceps dim where the Kettlebell Swing's model does not paint them at all (its quadriceps row was removed when they went unlit, per that entry's own comment). 0.53 is anchored to McGill 2012's rectus femoris mean of 53.4% MVC in the swing-to-snatch against 33.5 in the plain swing - a NON-significant table difference in n=7 with SDs of 22.1 and 22.2 - and Lyons 2017's only vastus lateralis finding is Swing > CLEAN, with no snatch-against-swing difference, so the number may be too high. Open point |
| Trapezius 0.44 | The library's Suitcase Carry (SampleData.swift 26691, a live row after its 2026-10-18 re-paint, sourced there to Bordelon 2021), already carried by this round's Kettlebell Clean. Not the cleans' 0.70: nothing shrugs a bell that is being swung, and the Kettlebell Swing keeps the trapezius a stabiliser |
| Triceps Brachii 0.40 | Estimate from Wu 2008 (the triceps contract after the turnover to hold the arm straight; no percentage). A row here only because this is the one model of the three that paints the triceps, so there is no sibling row to sit below; 0.40 is set under the library's loaded-triceps numbers for lifts that PRESS a bar - Clean and Press 0.55, Barbell Overhead Press 0.58 - because this bell is held, not pressed |
| Anterior Deltoid 0.30, the lowest of the three snatches | Lyons 2017 found no anterior-deltoid difference between swing, snatch and clean; Ross 2017 calls the overhead fixation a point of relative relaxation |
| No Obliques or Rectus Abdominis row although the literature supports them | The rig paints no oblique and no abdominal on this model (`tiers.py` re-run 2026-10-30, snatch2/mytiers_KettlebellSnatch.json: 6 bright, 16 dim, nothing faint); both are named among the stabilisers and the disagreement is an open point, as the Deadlift's removed Erector Spinae row already is in the library |
| No Adductors row, and the Kettlebell Swing has one | SampleData.swift 47351: Adductors S 0.38 is a live row on the Kettlebell Swing. This rig does not paint the adductors, so there is no row - a real difference between the two models, not a non-issue, and StrengthLog lists the adductors as PRIMARY for the snatch. Open point |
| No Forearms row, although the grip is the measured failure point | The Kettlebell Swing has no forearm row either - it was removed when the forearms went unlit and they are not even among its stabilisers (SampleData.swift 47352: gluteus medius, trapezius, core) - and the Suitcase Carry's comment records the owner confirming the unlit forearms on the carries are meant. So this follows the anchor rather than departing from it |
| Row 0.80 is the only label row the bell never reaches | Model (`snatch2/pill.py`, all 192 frames: bell sweep u 0.244-0.794, v 0.089-0.759; closest approach 27 px to the row's centre line and 13 px to a drawn pill's top edge) |

## Sources

What each is used for is in the tables above.

- Geisler S, Havers T, Isenmann E, Schulze J, Lourens LK, Nowak J, Held S,
  Haff GG 2023, J Sports Sci Med 22(4):778-789, doi 10.52082/jssm.2023.778,
  PMID 38045750, PMCID PMC10690512 (abstract, Key Points, Results and PMC
  Table 4 read 2026-10-30): 27 weightlifters at three levels (beginner 11,
  advanced 10, elite 6), all with at least a year of barbell training, two
  reps each of the hang power clean, hang power snatch, hang clean pull and
  hang snatch pull at 50, 70 and 90% 1RM, EMG of the vastus lateralis,
  gluteus maximus, erector spinae, rectus abdominis and trapezius
  normalised to each muscle's MVIC. Erector spinae activity was
  significantly greater in the hang power SNATCH than in the hang snatch
  pull in all three groups (p < 0.05, g = 0.27-0.98) - though at all three
  loads only in the elite group, at 50% 1RM only in the advanced and at
  90% only in the beginners - which is the one published finding that puts
  the low-back work in the catch rather than the pull. The trapezius
  differed only at 50% 1RM and favoured the PULL. Its hang-power-snatch
  erector spinae means run from about 143 to 372% MVIC with standard
  deviations up to about 322, and the authors call the advanced and elite
  groups' normalised values highly variable, so no percentage is quoted
  and no row is ranked on it; it also measured the HANG power snatch, not
  a snatch from the floor.
- Wu W-L, Ting Y-T, Huang C-J, Huang C-H, Wang H-J, Chen S-K 2008,
  26th International Conference on Biomechanics in Sports p. 461 (whole
  one-page paper read 2026-10-30; no DOI, open access at
  ojs.ub.uni-konstanz.de/cpa/article/view/1888, PDF at /1888/1757):
  four weightlifters, two female and two male, 15 to 20 years old, a 50 kg
  barbell, EMG at 1500 Hz synchronised with motion capture at 100 Hz.
  Recruitment order latissimus dorsi, then pectoralis major and biceps
  brachii, then deltoid, then triceps brachii. Its own wording is a
  shoulder range-of-motion milestone, not a point in time: before the half
  way point of the shoulder full flexion the contracting muscles are the
  biceps brachii and pectoralis major, after it the deltoid; after the
  turnover phase the triceps contract to keep the arm straightened; and
  after the catch phase the elbow is held at nearly full extension. It
  publishes no percentage of maximum and n = 4, half of them female and
  all adolescent, so it is cited for which muscle acts when, never for how
  much, and its phase list includes rising from the squat, so it measured
  the full snatch rather than a power snatch.
- Ernst AT, Jensen RL 2015, 33rd International Conference of Biomechanics
  in Sports p. 200 (abstract read 2026-10-30; no DOI, open access at
  ojs.ub.uni-konstanz.de/cpa/article/view/6360): nine male Olympic
  weightlifters training for competition, two lifts each at 40, 60 and 80%
  of their maximum snatch, surface EMG of the supraspinatus, infraspinatus
  and teres minor. The supraspinatus and infraspinatus were most active
  during the TURNOVER and CATCH and the teres minor during the first pull
  and transition; shoulder abduction angle at the catch did not differ
  between loads. No percentage of maximum is published, so the cuff is
  named among the stabilisers rather than given a row.
- McGill SM, Marshall LW 2012, J Strength Cond Res 26(1):16-27,
  doi 10.1519/JSC.0b013e31823b005f (full text with Tables 1 and 2 and the
  Results statistics read 2026-10-30 from the authors' own PDF; already
  cited in the library's Kettlebell Swing): seven healthy male
  participants, mean age 25.6, a convenience sample from the University
  population, found to be fit and most with kettlebell experience; a 16 kg
  bell in the right hand; peaks as %MVC. Swing / swing with Kime / swing
  to snatch: gluteus maximus 76.1, 82.8, 58.1; gluteus medius 70.1, 70.7,
  42.7; biceps femoris 32.6, 39.7, 29.8; rectus femoris 33.5, 49.4, 53.4;
  right internal oblique 42.4, 49.3, 53.6 and left 30.2, 80.8, 53.2;
  loaded-side latissimus dorsi 17.3, 20.3, 25.4 against the free side's
  56.2, 65.8, 72.4. CRUCIALLY, swing exercise had a significant effect on
  only three muscles - right external oblique (F = 4.27), right rectus
  femoris (F = 4.16) and left internal oblique (F = 5.45), all p < 0.05 -
  and the post hoc tests found NO significant difference in the external
  oblique between the three exercises and put the rectus femoris and left
  internal oblique differences on the swing WITH KIME against the plain
  swing, not on the snatch. The paper's own narrative runs the other way
  from its glute column: the swing to snatch appears to increase the
  activation of almost all muscles. L4/L5 compression at the end of the
  swing was 1,903 N (SD 618), 2,960 N (SD 1,153) and 1,589 N (SD 601);
  the significant contrast there was Kime against snatch (p = 0.032) while
  swing against Kime was p = 0.07, compression was under 3,200 N in all
  styles, which the authors call quite conservative, and they add that
  these loads are probably not of clinical significance for the spine. So
  the paper supports no swing-against-snatch ranking of any muscle, and
  nothing here is ranked on it.
- Lyons BC, Mayo JJ, Tucker WS, Wax B, Hendrix RC 2017, J Strength Cond
  Res 31(9):2363-2370, doi 10.1519/JSC.0000000000001771, PMID 28394829
  (abstract re-read 2026-10-30): 14 resistance-trained subjects, one-arm
  kettlebell swing, swing-style snatch and clean at a self-selected
  8-10RM, five reps each, EMG of eight muscles normalised to MVC. Only
  three differed: erector spinae Swing > Snatch, contralateral external
  oblique Snatch and Clean > Swing, and vastus lateralis Swing > CLEAN -
  with no snatch-against-swing difference in the quadriceps. There was no
  difference between the three in the anterior or posterior deltoid, the
  biceps brachii, the biceps femoris or the gluteus maximus. No percentage
  is published, the lift is a swing-style snatch, and the authors note the
  participants were not experienced kettlebell lifters.
- Ross JA, Keogh JWL, Wilson CJ, Lorenzen C 2017, PeerJ 5:e3111,
  doi 10.7717/peerj.3111, PMID 28367368, PMCID PMC5374970 (full text read
  2026-10-30 via PMC): twelve male amateur kettlebell-sport lifters with
  at least three years of kettlebell training, one 6-minute set WITH A
  HAND CHANGE AT THE 3-MINUTE MARK, 24 kg bell, 972 reps on bilateral
  force plates. It names the rep from fixation through six phases - drop,
  re-gripping, back swing, forward swing, acceleration pull and hand
  insertion - and says a valid repetition needs the bell locked out
  motionless overhead at its conclusion; citing McGill and Marshall it
  calls the overhead fixation one of two points of relative relaxation in
  the rep. Anterior-posterior ground force was higher in the ipsilateral
  leg (165 against 154 N downwards, 6.9%, and 164 against 146 N upwards,
  11.6%; F(1,11) = 885.15, p < 0.0001). Grip strength OF THE HAND THAT
  PERFORMED THE LAST 3 MINUTES fell 9.8 +/- 4.4 kg (p = 0.001) - so it is
  three minutes of work, not six, and the study ranks grip against
  nothing else. Its peak-force fatigue result does not match its own
  Table 1, so nothing is claimed from that.
- Lake JP, Hetzler BS, Lauder MA 2014, J Strength Cond Res 28(11):3063-3072,
  doi 10.1519/JSC.0000000000000538 (accepted manuscript read 2026-10-30):
  22 men, 3 sets of 8 kettlebell snatches and 3 sets of 8 TWO-HANDED
  swings with a 24 kg bell on a force platform. Horizontal impulse was
  18 +/- 7 N.s in the snatch against 29 +/- 7 in the two-handed swing, an
  impulse ratio of 14% against 23% (both p < 0.0001), while the authors
  conclude the mechanical output of the two is otherwise similar and that
  coaches could use them interchangeably. It is a one-handed snatch
  against a TWO-handed swing, which the copy says, and it is a
  between-exercise comparison, so it is never used to price a technique
  fault inside one lift; its 22 against 18 cm figure is lifter-plus-bell
  centre-of-mass travel, not bell travel, so neither is used that way.
- Lake J, Lauder M, Dyson R 2006, Kinetic Analysis of a Unilateral Snatch
  Movement, 24th International Symposium on Biomechanics in Sports
  (abstract read 2026-10-30; the PDF IS reachable, at
  ojs.ub.uni-konstanz.de/cpa/article/view/277/236): seven weightlifters,
  one-handed DUMBBELL power snatches at 80, 90 and 100% of 1RM, vertical
  ground reaction force from two Kistler platforms at 500 Hz. There were
  NO significant load or side effects for pull-phase peak VGRF or catch
  loading rate (P > 0.05), though non-lifting-side values tended to be
  larger except for the catch loading rate at the heaviest loads; the
  lifting side's pull phase was significantly longer (P < 0.001); and the
  authors conclude the uneven dumbbell load affected pull and catch
  symmetry. The only source found on the dumbbell snatch itself; a
  conference abstract, n = 7, no EMG.
- Petrizzo J, DiMenna FJ, Page R, Smith G, Martins K, Lester J, Kang S,
  Chandler L, Wygand JW, Otto RM 2016, J Exerc Physiol online 19(3):24-34
  (full text read 2026-10-30; no DOI): ten subjects, snatches and cleans
  from a traditional and an experimental start alignment. The experimental
  alignment cut horizontal bar displacement by about 40.3 mm in the snatch
  (P < 0.05) with no significant difference in peak power (about 2.2%),
  which is why the bar-path cue is written as control rather than as more
  weight.
- StrengthLog, How to Do Snatch: Muscles Worked and Proper Form,
  strengthlog.com/snatch/ (practice source, not peer-reviewed; read
  2026-10-30): step up close to the bar so that it is about over the
  middle of your foot, grip the bar with a wide overhand grip close to the
  weight plates, and catch the bar on straight arms over your head. Its
  muscle list is worth recording against the library's instincts: primary
  glutes, lower back, ADDUCTORS and quads; secondary hamstrings,
  trapezius, forearm flexors and CALVES - so it backs the dim calf row the
  rigs earn, lists no deltoid and no triceps at all, and makes the
  adductors primary where none of these rigs paints them. Used for the
  mid-foot bar position, the grip and the straight-arm catch only, never
  for a number.
- The library's own entries, read in SampleData.swift on 2026-10-30 for
  the fractions: Clean and Press (Anterior Deltoid 0.84, Trapezius 0.70,
  Gluteus Maximus 0.70, Quadriceps 0.62, Triceps Brachii 0.55, Erector
  Spinae 0.55, Hamstrings 0.50, Lateral Deltoid 0.50, Biceps Brachii
  0.30), whose pull rows are carried here through spec_1029_clean.py's
  PULL_ROWS because the pull from the floor is the same; Overhead Carry
  (Upper Trapezius 0.60, Lateral Deltoid 0.45, Obliques 0.36, Rectus
  Abdominis 0.30, with the anterior deltoid, rotator cuff and triceps
  among its stabilisers), the only loaded overhead hold in the library;
  Suitcase Carry (Obliques 0.60, Trapezius 0.44, Rectus Abdominis 0.30
  after the 2026-10-18 re-paint removed its forearm, lower-back and glute
  rows), its one-arm anchor, already reused by the Kettlebell Clean;
  Kettlebell Swing (Gluteus Maximus 0.80, Erector Spinae 0.50, Hamstrings
  0.76, Adductors 0.38, with the trapezius among its stabilisers and no
  quadriceps or forearm row, both removed when they went unlit) for the
  hinge; Barbell Overhead Press (Anterior Deltoid 0.86, Lateral Deltoid
  0.74) and Dumbbell Shoulder Press (0.84, 0.72) for the presses this
  family is NOT following; Pallof Press (Rectus Abdominis 0.44 primary),
  the Dumbbell Shrug and its five siblings (Middle Trapezius 0.30
  primary), the Rope Hammer Curl and its two siblings (Forearms 0.30
  primary) and the Seated Calf Raise (Gastrocnemius 0.30 primary) for the
  precedent of a LOW primary row; the Deadlift, whose Erector Spinae row
  was removed when the paint went out and whose comment leaves the
  paint-against-literature disagreement as a question for the owner; and
  spec_400_legcurl.py (0.40, 0.40, 0.36, 0.36, 0.34, 0.30),
  spec_400_hinge.py (0.50, 0.40, 0.32), spec_legs2.py (0.46, 0.46, 0.40)
  and spec_1029_legs.py (Gastrocnemius 0.46 with Soleus 0.30) for the
  library's dim calf rows, which run 0.30-0.50.
- ExRx was NOT read this round: exrx.net returns HTTP 403 from here and
  web.archive.org is unreachable, so no Target or Synergist list was
  checked for any of the three snatches. The Clean and Press copy already
  in the library cites ExRx and CrossFit for its start position and bar
  path; those citations belong to that entry and are not carried across.

## Labels

Rows are the batch's squeezed set (0.16, 0.32, 0.48, 0.64, 0.80), all five
pinned with `overrides` on every lift. Every figure below is measured at the
pill the app DRAWS: `CalloutPill` is `.font(.ui(12, .semibold))` with
`.padding(.vertical, 7)`, `TrackedCallout` centres it on `labelPoint.y` and
the annotation layer scales by `stageHeight/567`, so its half-height is
0.0218-0.0250 in v and the numbers use 0.025, the worst case (`gen.py`'s
`covered()` band is the looser +/-0.035). Pill width is
`(24 + 5.6 * len(label)) / 382` from edge 0.035, as elsewhere in this round.

**Two tests, not one.** A pill must never sit on the lifter or on the load;
a leader must not run across the face. The second one is easy to measure
badly. A box around the head JOINT is too small - the joint sits at the base
of the skull, and in the Dumbbell Snatch's folded-over set-up the drawn skull
reaches 35 px to the left of it - while the whole body's silhouette at head
height is too big, because at a lockout most of what is up there is the
raised arm. So the head is measured on its own: `headsil.py` skins only the
vertices the rig weights to the head joint (`Faceless_HeadNeck_Surface` plus
the neck muscles, 2,399 vertices) and projects them per frame, and a leader
is on the head only if it falls inside that.

| Lift | Pill | Row, side | Lifter | Load | Leader on the head |
|---|---|---|---|---|---|
| Power Snatch | `Flat back` (9) -> spine | 0.80 trailing | 57.5 px | plates on the floor, 0-1.04 s and 6.92-7.96 s | never (78.2 px clear) |
| | `Bar close` (9) -> hand_L | 0.16 trailing | no lifter in the row at any frame | bar overhead, 2.88-4.29 s | never (28.7 px) |
| | `Finish the drive` (16) -> foot_R | 0.80 leading | 18.8 px | plates on the floor, 0-0.50 s and 7.50-7.96 s | never (127.5 px) |
| | `Drop under` (10) -> forearm_L | 0.48 trailing | 15.7 px | bar in flight, 1.79-2.25 s and 4.54-5.46 s | never (31.0 px) |
| | `Bar overhead` (12) -> hand_R | 0.16 leading | no lifter in the row at any frame | never (19.6 px) | never (17.0 px) |
| Dumbbell Snatch | `Flat back` (9) -> spine | 0.64 trailing | 13.4 px | 104.4 px | never (96.3 px) |
| | `Legs up` (7) -> patella_R | 0.64 leading | 7.2 px | 11.8 px | never (54.7 px) |
| | `Turn it over` (12) -> forearm_L | 0.48 trailing | 11.4 px | 18.5 px | never (18.5 px) |
| | `Lock it out` (11) -> hand_L | 0.80 trailing | 25.5 px | 109.5 px | never (12.0 px) |
| | `Stay level` (10) -> hand_R | 0.16 leading | 150.9 px | 112.9 px | never (1.4 px at t 0.71) |
| Kettlebell Snatch | `Hips back` (9) -> pelvis | 0.48 trailing | 34.9 px | 103.0 px | never (126.5 px) |
| | `Bell close` (10) -> patella_L | 0.80 trailing | 27.1 px | 56.1 px | never (180.8 px) |
| | `Let it roll` (11) -> forearm_L | 0.32 trailing | 10.8 px | 60.3 px | never (7.8 px) |
| | `Stack it overhead` (17) -> hand_L | 0.16 leading | 52.2 px | 23.3 px | **24 of 192 frames** |
| | `Heels stay down` (15) -> foot_R | 0.80 leading | 12.6 px | 61.5 px | never (231.7 px) |

What drove each layout:

- **Power Snatch.** The 2.04 m bar crosses the whole frame, plates included,
  and sweeps u -0.002-0.942, v 0.157-0.835, so every row is entered at some
  moment. Exactly one slot is free of it, leading at row 0.16, and the
  lockout pill takes it. Six of the ten slots clear the lifter at every frame
  at twelve characters; the layout then takes the most lifter clearance among
  the slots that are also cheap in bar-seconds (row 0.80 leading 1.04 s,
  rows 0.16 and 0.48 trailing 1.46 s, row 0.80 trailing 2.17 s). Row 0.32
  trailing is marginally cheaper in bar-seconds at nine characters (2.08 s)
  but leaves 7.9 px of lifter clearance, so it is empty; row 0.64 leading is
  the worst slot in the frame for the bar (4.42 s). `Flat back` and
  `Bar close` are the library's own nine-character labels from the Clean and
  Press, which places the same two cues.
- **Dumbbell Snatch.** The load never touches a pill here - the three prop
  meshes sweep only u 0.229-0.881 - so the lifter and the leaders decide it.
  The working arm is on the viewer's right and the left gutter is narrow
  below row 0.32 (the silhouette reaches u 0.278 at row 0.48, 0.219 at 0.64,
  0.189 at 0.80), so the two left pills point at left-side joints, the free
  hand and the far knee, and the three right pills at the working arm and the
  spine. **This is the layout the final audit changed.** The draft had the
  pull pill at row 0.50 leading, where its leader lay on the drawn head for
  38 of 192 frames - the whole static set-up (0-0.71 s) and the whole return
  (7.17-7.96 s). Row 0.32 leading is worse at 51 frames. Row 0.68 leading is
  the one slot whose leader never touches the head, and its gutter is narrow,
  so the label came down to seven characters: seven clears the lifter by
  7.2 px, eight by 1.6 and nine lands on it.
- **Kettlebell Snatch.** The bell is the smallest load of the three and the
  only one that leaves a whole row alone: it sweeps u 0.244-0.794,
  v 0.089-0.759, so row 0.80 is never reached - 27 px above the row's centre
  line and 10.5 px above a drawn pill's top edge at the 0.025 half-height -
  and the foot and knee pills share it. Row 0.32 trailing is the best
  remaining slot even though the head is in that row on 168 of 192 frames,
  because the head keeps to u 0.361-0.634 while a trailing pill starts at
  0.741. Row 0.64 is empty instead: at eleven characters a pill there leaves
  3.9 px of lifter clearance on the trailing side and lands on the lifter on
  the leading side.

The one leader that touches the head anywhere in the family is the Kettlebell
Snatch's lockout, which has to follow a hand that goes from the thigh to
overhead three times; it is on the head for 24 of 192 frames in twelve short
runs. The slot sweep is in the open points.

## Open points for the owner

### Power Snatch

1. **The bar's start position differs from the coaching.** StrengthLog, and the setup step, put the bar about over the middle of the foot; this model starts it 12.4 cm in front of the ankle joint and 1 cm behind the toe joint, about over the ball of the foot. No cue claims the model holds the mid-foot position, but the shoot will show the difference. Either accept it, or the model is worth re-exporting with the bar back about 5 cm.

2. **Both deltoid rows rank primary on paint alone, and the copy says the opposite.** The legend will present the shoulders as prime movers of a lift whose cues read Legs throw it, arms just lock. Neither fraction is sourced for a snatch (Lyons 2017 found no deltoid difference between swing, snatch and clean; Wu 2008 gives phase only). The sibling Dumbbell Snatch ranks the same two secondary on dim paint, so the family is inconsistent on the reader's side of the app. Rank them secondary here, or re-paint, or accept.

3. **The soleus is painted dim and has no row.** One Gastrocnemius row at 0.30 carries both painted calf muscles and the soleus is a stabiliser. spec_1029_legs.py gives a leg curl both (0.46 and 0.30) where it has separate evidence; here the heel lift loads them together and there is no evidence either way. Add a Soleus row, or accept the one.

4. **Quadriceps 0.62 above Hamstrings 0.50 while both rank primary** - carried from Clean and Press, as the cleans round already flagged. On this model both groups are bright, so it is now a fraction question only: re-estimate the quadriceps, or accept it.

5. **Gastrocnemius 0.30 is a judgement call.** The rig paints the calves dim on this model and the Dumbbell Snatch and not on the Kettlebell Snatch, which matches the measured heel lift exactly; StrengthLog lists the calves as a secondary muscle worked, but no snatch study measured one. Drop the row, or set the number.

6. **StrengthLog lists the ADDUCTORS as a primary muscle for the snatch** and none of these three rigs paints them. The library's Kettlebell Swing carries Adductors 0.38. Worth a look if the paint and that list are meant to agree.

7. **Three pills sit on the bar for 1.0-2.2 s each, and that is the best this frame allows.** Only the leading slot at row 0.16 is ever free of the load. The owner may prefer fewer pills on this lift, or a tighter zoom.

8. **No ghosts yet**, as for the other families of this round: each mistake view falls back to the red ring.

### Dumbbell Snatch

1. **Rectus Abdominis is a 0.30 LOW primary, and both entries it is carried from rank it secondary.** The paint is bright on the far side and the rank-change rule keeps the carried fraction. Round 1 called this a new lowest primary in the library's standing set, which is false - the six shrugs carry Middle Trapezius 0.30 primary, the three hammer curls Forearms 0.30 and the Seated Calf Raise Gastrocnemius 0.30 - so the precedent exists. The real question is the departure from the Suitcase Carry and the Kettlebell Clean, which both rank this muscle secondary at the same 0.30. Accept the LOW primary, or re-estimate upward with a source.

2. **The two one-arm rigs disagree about the trunk.** This model paints the contralateral obliques and rectus abdominis BRIGHT; the Kettlebell Snatch paints no oblique and no abdominal at all, although the kettlebell literature is where the oblique evidence comes from (Lyons 2017, McGill 2012). If that is a painting oversight on the kettlebell rather than a judgement, the kettlebell entry should gain Obliques 0.60 and Rectus Abdominis 0.30 and this family would read consistently.

3. **Trapezius 0.70 against the Kettlebell Snatch's 0.44** rests on a line I drew and should be checked: a bell pulled from the floor keeps the two-handed clean fraction, a bell that is swung takes the one-arm value. The paint here is one-sided (left only), which could be read as arguing for 0.44 instead.

4. **The soleus is painted dim and has no row of its own**, as on the Power Snatch - one Gastrocnemius row at 0.30 carries both. Same question, same answer either way.

5. **The arm-only lowering is in the copy but has no cue of its own.** The model racks the bell to the shoulder with the knees still straight and only then re-hinges, which is distinctive enough to be a sixth cue if the format ever allows one; for now it sits in the lockout cue.

6. **The pull pill moved after the final audit, and its gutter is tight.** At row 0.50 leading, where the draft put it, the `Leg drive` leader lay on the drawn head for 38 of the 192 frames - the whole static set-up and the whole return, which are the first and last stills anyone sees. Row 0.68 leading is the only slot whose leader never touches the head, and it is narrow: the label had to come down to seven characters (`Legs up`) for 7.2 px of clearance, where eight leaves 1.6 px and nine lands on the lifter. It reads fine in the shoot; if the owner wants a fuller label there instead, the alternative is to accept the leader over the face at the set-up.

7. **No ghosts yet**; each mistake view falls back to the red ring.

### Kettlebell Snatch

1. **The paint and the evidence disagree about the trunk, and this is the one to put to the owner.** This rig paints no oblique and no rectus abdominis, so the Suitcase Carry's Obliques 0.60 and Rectus Abdominis 0.30 are not carried - yet the one-arm kettlebell snatch is exactly where the oblique evidence lives (Lyons 2017: contralateral external oblique higher in the snatch than the swing; McGill 2012: internal oblique 53.6 and 53.2% MVC against 42.4 and 30.2). The sibling Dumbbell Snatch rig paints those same muscles BRIGHT. A re-paint here would add Obliques 0.60 and Rectus Abdominis 0.30 and make the family consistent. Until then both are stabilisers and the comment says why, as the Deadlift's removed Erector Spinae row already does.

2. **Quadriceps 0.53 is the row I am least sure of.** The paint earns it - this rig lights the four quadriceps dim where the Kettlebell Swing's model lights none - but the number is anchored to a McGill table difference that his own statistics do not make significant, and Lyons 2017, the only study to measure a quadriceps in an actual one-arm kettlebell snatch, found no snatch-against-swing difference at all (its only vastus lateralis result is Swing > Clean). 0.53 may be too high; the Kettlebell Swing's removed quadriceps row was 0.30 before it went unlit.

3. **Triceps Brachii 0.40 exists only on this lift.** The rig paints the triceps on the kettlebell snatch and not on the barbell or dumbbell ones, although all three finish with a locked elbow overhead and Wu 2008's triceps fire after the turnover in a barbell snatch. Either the two other rigs are missing that paint, or this one is generous; the rows follow the paint for now.

4. **Adductors.** The Kettlebell Swing carries Adductors 0.38 and this rig does not paint them, so there is no row - and StrengthLog lists the adductors as a PRIMARY muscle for the snatch. Worth a look if the swing's paint and this one are meant to match.

5. **The lockout pill's leader.** It lies on the lifter's head on 24 of 192 frames (1.00 s), in short bursts as the hand passes the head on the way up and down - the one leader in the family that touches the head at all. Shortening the label does not help (24 frames at seventeen characters and at fifteen, 39 at eleven, because a longer pill starts nearer the hand). One slot does better, row 0.64 trailing at eleven characters with 12 frames, but it leaves 3.5 px of lifter clearance against 52.2 px where the pill is now, so it was not taken.

6. **The loop seam.** The clip starts and ends in a lockout, so the first and last stills show the finish rather than the start - the t=0 and t=2.0 shots of this round are the same pose. The hinge is at about 0.83 s and again at 3.5 s, which is the third still.

7. **No ghosts yet**; each mistake view falls back to the red ring.

## Checks run

- `python3 spec_1029.py snatch` prints OK (3 exercises) and
  `python3 spec_1029.py` OK (20), and `preview_1029.py snatch` prints the
  layout above.
- `python3 integrate_1029.py <scratch>` wrote the setup steps, the three
  content-map entries and the content block; FaultPoses untouched.
- `Tools/lab/build.sh` with `LAB` in the session scratchpad: BUILD SUCCEEDED,
  installed on the harness simulator.
- `Tools/lab/shoot_ex.sh` at 0, 2 and 3.5 s: all three screens show their
  five pills, the legend and the setup drawer, no pill sits on the lifter,
  and the Dumbbell Snatch's set-up still has its pull leader clear of the
  face. The Power Snatch's catch pill sits on the bar's right plate at t=2,
  which is the documented compromise - 0.48 trailing is the slot with the
  least bar time of any that clears the lifter.
