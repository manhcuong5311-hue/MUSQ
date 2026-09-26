# Late additions 2026-09-27 — shoulders: seated lateral raise, cable rear delt row, dumbbell upright row

Files: `spec_0927_shoulders.py` (copy, activation, setup, glows, label
overrides), `../fault-review/faults_0927_shoulders.swift.txt` (ghosts: five
new pieces and three table entries). `python3 spec_0927_shoulders.py`
prints OK and the `gen.py` dry run renders all three entries. The pieces and
table entries were spliced into a scratch copy of `FaultPoses.swift`
(pieces above `// MARK: Back pieces`, entries at the end of the table):
`swiftc -typecheck` passes, and a small `@main` built from it finds all five
cues of each exercise in the table (no duplicate keys). Nothing in the repo
other than the three files above was touched.

Revision (2026-09-27, after two independent reviews: sources and claims;
model fidelity, labels and ghosts): seated raise activation re-ranked
(posterior deltoid in, upper trapezius to the stabilisers), plane why and
the Coratella/Durall summaries corrected, elbow bend and setup written to the
model's straight arms at the bottom; cable row activation gains the upper
trapezius (rhomboids to the stabilisers, lateral deltoid 0.66), blade-motion
wording and the straight-wrist instruction removed (the model contradicts
both), mistake note softened, Padovan now vol 91 (2026), range ghost gated to
the finish and torso ghost kept on the cable line; upright row height copy
now asks for shoulder height at most, height/elbow/width whys matched to the
sources, width cue about the hands (the two dumbbells' rods overlap and read
as one bar), torso label on the spine, path and width ghosts re-seat the
elbows. The spliced `FaultPoses.swift` (with the hip thrust family) builds
with `swiftc` and finds all 15 cues.

How the models were read: the briefs and framing shots, then passes over
each USD (joint angles in the lifter's own axes, hand positions relative to
the shoulders and neck, the dumbbells' handle axes, the thumb direction from
the index and little finger joints, the bench and cable parts). Torso length
(neck to pelvis) is 0.59 m in all three. Every ghost was solved with the
Python port of `FaultGhost.solve` (`rv_frmodel/ghost.py`) at the bottom and
top of the first rep and drawn from its framing plus its `view`.

Labels: each entry pins its rows with `overrides` on the usual scale
(squeezed to 0.16-0.80 by `spec_0927.py`); the check drew the pills
(29 pt tall, `gen.width`) and leaders to all eight probed joint positions
with the squeeze applied. No leaders cross, no leader runs through another
pill, no leader passes within 8 pt of another cue's dot, and every dot stays
at least 28 pt from every pill edge (seated raise 72 pt, cable row 55 pt,
upright row 28 pt). Closest leader to another pill: 26 pt (seated raise
torso leader past the elbow pill); the upright row's torso leader, now to the
spine, passes 30 pt from the width pill (14 pt when it ran to the pelvis,
whose dot sat on the dumbbell plates at the bottom). The upright row's width pill uses
row 0.53 (squeezed 0.507, written as 0.51) rather than 0.50, so the hand dot
at the bottom of the rep sits 29 pt above it instead of 11.

## Sources

| # | Source | Used for |
|---|---|---|
| 1 | Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2020. *Int J Environ Res Public Health* 17(17):6015. doi:10.3390/ijerph17176015 (PMC7503819, read 2026-09-27) | 10 competitive bodybuilders; every exercise performed **seated**, 8-RM, "to avoid any possible involvement" of muscles such as the lumbar muscles. On the way up, the lateral raise to 90° with the humerus neutral (thumbs forward) gave medial deltoid similar to thumbs down (not significantly different) and more than the thumbs-up, 90° bent-elbow and front raises. In the thumbs-forward raise, medial and posterior deltoid were about equal (~55 and ~52% MVIC, abstract) and the anterior lower (~36%). The thumbs-down (internally rotated) raise gave the most posterior deltoid and upper trapezius in both phases and the most medial deltoid while lowering. Every raise except the bent-elbow one had the elbow almost straight. |
| 2 | Campos YAC, Vianna JM, Guimarães MP et al. 2020. *J Hum Kinet* 75:5-14. doi:10.2478/hukin-2020-0033 (PMC7706677, read) | Seated lateral raise to 90° (back on a 90° bench, feet flat, 60% 1RM, 12 reps): medial 30.3, posterior 24.0, anterior 21.2% MVIC; medial similar to the seated shoulder press, posterior higher. |
| 3 | Wickham J, Pizzari T, Stansfeld K, Burnside A, Watson L 2010. *J Electromyogr Kinesiol* 20(2):212-222. doi:10.1016/j.jelekin.2009.06.004 | Coronal-plane abduction 0-166° with a light dumbbell, 24 subjects, 15 muscles: supraspinatus and middle deltoid lead abduction (as used by the 191-240 lateral family). |
| 4 | Escamilla RF, Yamashiro K, Paulos L, Andrews JR 2009. *Sports Med* 39(8):663-685. doi:10.2165/00007256-200939080-00004 | The scapula rotates up during arm elevation, driven by the serratus anterior and trapezius. |
| 5 | Durall CJ, Manske RC, Davies GJ 2001. Avoiding shoulder injury from resistance training. *Strength Cond J* 23(5):10-18 (full text read from the earlier session's copy) | Expert guidance: elevate with the arm turned out (thumbs toward the ceiling) to limit compression, for all clients; illustrated as scaption, a lateral raise ~30° in front of the frontal plane (Fig. 6); the scapular plane is otherwise advised for behind-the-neck presses and pulldowns and the pec fly. Limit the upright row to ~80° with the elbows below the shoulders, or avoid it. |
| 6 | Schoenfeld B, Kolber MJ, Haimes JE 2011. The upright row: implications for preventing subacromial impingement. *Strength Cond J* 33(5):25-28 (full text read) | Impingement peaks ~70-120° of elevation; MRI and surgical studies found it greatest at 70-90° without external rotation. Pull as close to the body as possible and through the elbows, not the wrists. Just below shoulder height if free of symptoms, lower (or not at all) if it hurts. "Can be a safe and effective exercise, provided proper precautions are followed." The evidence is anatomical, imaging, surgical and clinical opinion, not injury rates. |
| 7 | Andersen LL, Kjær M, Andersen CH, Hansen PB, Zebis MK, Hansen K, Sjøgaard G 2008. Muscle activation during selected strength exercises in women with chronic neck muscle pain. *Phys Ther* 88(6):703-711 (abstract read) | 12 women with trapezius myalgia: upper trapezius 85 ±5% MVC in the upright row and 97 ±6% in the lateral raise (3-10 kg), 102 ±11% in the shrug (20-30 kg). |
| 8 | McAllister MJ, Schilling BK, Hammond KG, Weiss LW, Farney TM 2013. *J Strength Cond Res* 27(1):181-187. doi:10.1519/JSC.0b013e31824f23ad (full text read) | Barbell upright row at 50/100/200% of biacromial breadth, 16 men, 85% 1RM: deltoid and trapezius activity rose and biceps fell as the grip widened (significant mainly 100 vs 200%; lowering, lateral deltoid and upper trapezius were also significantly higher at 100 than 50%, ES 1.3 and 1.6; biceps only eccentric, 50 vs 200%; 50 vs 100% biceps not significant). Bar kept below the xiphoid "to keep the humerus from going above horizontal". The authors note that the dumbbell upright row, whose arms travel in an arc, has not been studied. |
| 9 | Sweeney S, Porcari JP, Camic C, Kovacs A, Foster C. ACE ProSource, September 2014 (ACE-sponsored, **not peer reviewed**; PDF text read) | Barbell upright row anterior/medial/posterior deltoid 33/73/31% MVC; 45° incline row medial 84, posterior 69. |
| 10 | Vasconcelos CMWA, Lopes CR, Almeida VM, Krause Neto W, Soares EG 2023. *Int J Strength Cond* 3(1). doi:10.47206/ijsc.v3i1.190 (full text read) | Seated cable row, 21 trained adults, bar pulled to the torso: upper and middle trapezius and posterior deltoid activity rose with shoulder abduction (highest at 60 and 90°; for 90° the hands were set at biacromial width plus an upper-arm length each side, i.e. elbow width); latissimus activity and peak force were higher with the elbows near the sides. Table 1, concentric peak %MVIC at 60°/90°: upper trapezius 130.9/138.0, middle trapezius 109.8/116.0, posterior deltoid 98.6/105.4 (60° and 90° not significantly different for any of the three); upper latissimus 42.3/29.6. With the elbows at the sides the posterior deltoid was still 67.0-72.3 and the latissimus 53.7-67.8. Values over 100% show normalisation differs between muscles. |
| 11 | Padovan R, Cè E, Longo S, Tornatore G, Trentin C, Esposito F, Coratella G 2026. High-density surface electromyography excitation of prime movers in the narrow vs. wide grip seated row exercise. *J Hum Kinet* 91 (online 2025-09-23; print 2026-07-19, pages not yet assigned). doi:10.5114/jhk/209550 (proof PDF read) | 14 trained men, 8-RM. Wide bar pulled to the lower chest vs a triangle handle to the belly: wide gave more upper (+19%), middle (+19%) and lower trapezius and lateral deltoid (+20%) in the concentric phase; narrow gave more latissimus (+24%); posterior deltoid, biceps and triceps did not differ. |
| 12 | Lehman GJ, Buchan DD, Lundy A, Myers N, Nalborczyk A 2004. *Dyn Med* 3:4. doi:10.1186/1476-5918-3-4 (PMC449729) | Of the pulldowns and seated rows tested, the seated row gave the highest middle trapezius/rhomboid activity; actively retracting did not change it. |
| 13 | Reinold MM, Wilk KE, Fleisig GS et al. 2004. *J Orthop Sports Phys Ther* 34(7):385-394. doi:10.2519/jospt.2004.34.7.385 | Prone horizontal abduction at 100° with external rotation: posterior deltoid 88%, middle deltoid 87% MVIC. |
| 14 | ExRx.net: Dumbbell Seated Lateral Raise (https://exrx.net/WeightExercises/DeltoidLateral/DBSeatedLateralRaise), Cable Rear Delt Row (…/DeltoidPosterior/CBRearDeltRow), Dumbbell Upright Row (…/DeltoidLateral/DBUprightRow). exrx.net returns Cloudflare 403 to WebFetch and curl, so the wording was checked through search-result text. | Seated raise: raise until the slightly bent elbows are at shoulder height, elbows at or above the wrists, fixed 10-30° elbow bend; at the top the elbow directly out to the side of the shoulder; as the elbow drops below the wrist the front deltoid takes over; target lateral deltoid, synergists anterior deltoid, supraspinatus, middle/lower trapezius, serratus anterior; stabilisers upper trapezius, levator scapulae, wrist extensors. Cable rear delt row: sit upright with the knees slightly bent, pull toward the upper chest just below the neck with the elbows out to the sides at shoulder height until they pass slightly behind the back, return until the shoulders are stretched forward; if the elbows drop the lats join and it becomes a wide-grip row; target posterior deltoid, synergists lateral deltoid, infraspinatus, teres minor, middle/lower trapezius, rhomboids, brachialis, brachioradialis. Dumbbell upright row: palms toward the thighs, elbows lead, wrists flex, the elbows to the sides rather than pointing forward. |

## Seated Dumbbell Lateral Raise (207)

**The model:** sits upright (trunk 0°) on the end of a flat bench (seat top
0.47 m), knees ~112°, feet flat ~0.38 m apart. A dumbbell in each hand; at
the bottom the handles run front to back (palms in) and the arms hang ~18°
out from the sides beside the thighs, the dumbbells about level with the seat.
Both arms rise together to upper arms ~89° (level), the hands at shoulder
height and the elbows level with the wrists (elbow and hand within 0.5 cm of
shoulder height at the top), then lower. The elbows hold ~166° through the
rep and straighten to ~178° in the pause between reps (0-0.45 s and
3.45-4.45 s of each 4 s rep), setting the bend only as the dumbbells leave
the sides. The upper arms travel
~20° in front of the line of the shoulders (the hands ~27°, since the bent
elbow carries them forward); at the top the palms face down with the handles
level, thumbs forward (the thumb side ~0.2 up). The shoulders do not rise
(shoulder to neck constant) and the trunk does not move. Framed at yaw -0.6:
the left arm is on the right of the screen, seen foreshortened. First top at
1.79 s.

**Claims:**
- Activation: lateral deltoid primary HIGH 0.86 (1 and 2, both seated;
  ExRx target). Supraspinatus MODERATE 0.50 (3; ExRx synergist). Posterior
  deltoid MODERATE 0.48 (1: about equal to the medial deltoid in the
  thumbs-forward seated raise, ~52 vs ~55% MVIC; 2: 24 vs medial 30%
  MVIC). Anterior deltoid MODERATE 0.42 (1: ~36% MVIC; 2: 21%; ExRx
  synergist; both studies put it below the posterior deltoid, so it is
  ranked last; no study measures the model's ~20° forward path). The upper
  trapezius is a stabiliser, as ExRx lists it (7 found it very high in
  lateral raises, in women with neck pain using light loads; in 1 it was
  lower with the thumbs forward than thumbs down, ~30% MVIC in the open
  dataset per the evidence reviewer, not rechecked); the traps cue covers
  it. Numbers across muscles in %MVIC are not directly comparable; the
  fractions are rank estimates.
- Traps cue: technique convention, the same wording as the other lateral
  raises.
- Height cue: the dumbbells' moment on the shoulder is greatest with the arms
  level (mechanics); above that the scapula rotates up further and the
  trapezius and serratus take a bigger share (4). ExRx: elbows to shoulder
  height.
- Elbow cue: 1 (medial deltoid higher with straight than 90°-bent elbows in
  seated raises; the bent version also had the forearm pointing forward and
  the thumbs toward each other, so it is not a pure elbow comparison) and ExRx (fixed 10-30° bend;
  elbows at or above the wrists, or the front deltoid takes over). The
  correct text says to set the bend "as the dumbbells leave your sides",
  since the model's arms are straight in the pause at the bottom.
- Plane cue: 5 illustrates the lateral raise as scaption (~30° forward) and
  advises the scapular plane for other lifts; this is expert opinion, and
  the copy says "often advised for comfort", not that it is safer or
  stronger. ExRx's seated raise has the elbow directly out to the side at
  the top; the model's ~20° forward path follows the scaption advice, not
  ExRx. On the way up, thumbs forward worked the medial deltoid about as
  hard as thumbs down in 1 (not significantly different), and thumbs down
  raised rear-delt and upper-trap activity (1); the why says exactly that.
  "Turn the thumbs slightly up if the shoulder pinches" follows 5.
- Torso cue: mechanics, and 1 seated every raise to keep the trunk and lumbar
  muscles out of the lift. No study compares seated and standing lateral
  raises directly; 1 and 2 were seated, which is why they are the main
  sources here.
- Comparison (ROCKING BACK): the seated-specific cheat, drawn by the torso
  ghost.

**Uncertain:** 2 had a backrest, this model has none. Whether the model's
~20° forward path shifts work from the posterior to the anterior deltoid is
untested; both seated studies raised the arms out to the side, so the
posterior deltoid is ranked above the anterior. The 178° elbow between reps
and 166° during them is the model's; the copy asks for a slight bend set as
the dumbbells leave the sides and then held (SETUP: palms in, arms long).

**Ghosts** (checked on the rig at the top, 1.83 s):
- `traps`: `shrugged` (shoulders and arms 7 cm up), always, no turn.
- `elbow`: `elbowsFolded(.forward, -60)` gated by the new
  `seatedRaiseRising` (hand to pelvis 1.0 → 1.4 torso lengths; 0.64 hanging,
  1.49 level): the hands drop ~18 cm below the elbows (elbow ~127°). None at
  the bottom, where the fold would swing the hanging forearms into the
  thighs.
- `height`: `armsTurned(.forward, 30)`, same gate: upper arms ~118°, hands
  ~24 cm higher.
- `plane`: `armsTurned(.up, -30)`, same gate, `.seen(-0.7)` (total -1.3,
  nearly side-on): the hands move ~27 cm back, from 24 cm in front of the
  shoulders to 3 cm behind them, so the sweep runs across the screen.
- `torso`: `leanedBack(12)`, always, `.seen(-0.9)` (total -1.5): trunk and
  arms 12° back about the hips on the bench, the head ~14 cm back.

**Fault stills:** all at the TOP (hands highest): traps, height, elbow,
plane, torso.

## Cable Rear Delt Row (222)

**The model:** sits tall (trunk ~3° back) on a cable row bench (seat top
0.46 m), knees ~144°, feet flat on the floor with the toes against the base
of the foot rest. The pulley is at shoulder height and the cable level (hand
height constant, 1.09-1.13 m). Straight bar, overhand, hands 0.66-0.67 m
apart (about 1.6 times the rig's shoulder-joint width), thumbs toward each
other. Start: arms reaching forward, elbows ~157°, upper arms ~8° below level
and ~65° in from the sides. The elbows travel out and back to ~14 cm behind
the shoulder joints (the upper arms ~30° behind the line of the shoulders)
and ~22 cm out, finishing ~12 cm below shoulder height (upper arms ~24° below
level), elbows ~31°. The bar finishes level with the shoulder joints, ~10 cm
in front of and 7 cm below the base of the neck: the top of the chest. Seen
from behind-left (yaw -2.6); the left arm is on the left. First finish at
1.92 s. The forearms slope up ~30° from the low elbows to the level bar, so
the wrists flex ~45-70° (toward the palm) through the pull. Rig artefact
(checked on the rig, neck-relative, lifter axes): from the reach to the
finish the shoulder joints move ~7 cm forward (3 cm behind the neck joint to
4 cm in front) and the scapula joints ~5 cm forward and ~4 cm out (12 to
16 cm from the midline), so the blades read as together at the reach and
spread at the finish, the reverse of the technique. The Machine Rear Delt
Row (already shipped) does the same (~7.6 cm forward); the Wide-Grip Seated
Cable Row moves the right way. The copy therefore says nothing about the
shoulder blades moving.

**Claims:**
- Activation: posterior deltoid primary HIGH 0.80 (ExRx target; 10:
  posterior deltoid rose with abduction in the seated cable row). Lateral
  deltoid MODERATE 0.66 (11: higher with the wide bar, ES 1.03; 13: middle
  87 vs posterior 88% MVIC in prone horizontal abduction; 9: incline row
  medial 84, posterior 69; ExRx synergist); kept a little below the Machine
  Rear Delt Row's 0.70 because this model's elbows finish ~24° below level.
  Middle trapezius MODERATE 0.62 (10, 11, 12). Upper trapezius MODERATE 0.50
  (10: highest of all at 60-90°, 131-138% MVIC; 11: the wide bar raised it
  most, ES 1.35 concentric, 2.79 eccentric); kept moderate and below the
  posterior deltoid because %MVIC is not comparable across muscles and the
  traps cue asks for no shrug. Rhomboids are listed with the stabilisers:
  never measured on their own (12 recorded them with the middle trapezius
  as one site; ExRx synergist).
- Grip cue: 11 (wide bar vs close handle: more trapezius and lateral
  deltoid, less latissimus, rear deltoid similar). The copy says exactly
  that, including "similar rear-delt activity", and does not claim a wide
  grip works the rear delts harder. The model's grip is well outside the
  shoulders but narrower than ExRx's "elbow width", so the copy says "well
  outside shoulder-width". The correct text no longer says "wrists
  straight": the model's wrists flex hard through the pull.
- Elbow cue: 10 (rear delt and traps up with abduction, lats up with the
  elbows near the sides) and ExRx (dropping the elbows brings in the lats).
- Range cue: ExRx (elbows slightly behind the back; return until the arms
  are extended) and the model. The why speaks of the arms reaching and the
  elbows drawing back, not the shoulders, because the model's shoulder
  girdle moves the wrong way (above).
- Traps cue: technique convention; the why says shrugging shifts the finish
  toward the upper trapezius and away from the rear delts and mid-back; the
  correct text asks for the shoulders to stay down, not for the blades to be
  drawn back, which the model does not show.
- Torso cue: ExRx (torso upright) and mechanics.
- Comparison (ELBOWS DROPPING): ExRx (the latissimus becomes involved, a
  standard wide-grip row) and 10 (with the elbows at the sides the lats rise
  and the posterior deltoid falls but stays at 67-72% MVIC), so the mistake
  note says the lats join in and the rear delts and mid-back do less, not
  that the lats take over.

**Uncertain:** no study of this exact lift. The model's elbows finish ~24°
below level where ExRx keeps the upper arms horizontal; the copy says "close
to shoulder height". A re-export raising the elbows ~10 cm at the finish
would match ExRx exactly (for the lead). 10: posterior deltoid at 60°
abduction did not differ significantly from 90° (98.6 vs 105.4% MVIC), so
the model's ~66° finish still sits in the high-activation range. The elbows
end very bent (~31°) with the bar close to the throat, which matches ExRx's
"just below the neck".

**Ghosts** (checked at the finish, 1.83 s, and the start, 0 s):
- `grip`: inline. Hands 0.2 torso lengths in on each side, elbows re-seated:
  ~42 cm apart instead of 66, the elbows ~141° instead of 157°. Gated by
  hand-to-shoulder distance (0.6 → 0.8 torso lengths; 0.89 at full reach,
  0.25 at the finish), so it shows while the arms reach and is gone by the
  time the elbows reach 90°; re-seating the short span at the finish folds
  the elbows (11°), so it is not drawn there. No turn: from behind the
  narrower hands read across the screen.
- `traps`: `shruggedBack` (shoulders and arms 7 cm up and 4 cm back),
  always, no turn; the shoulder line rises toward the head from behind.
- `elbow`: inline. Bar 0.2 down, elbows 0.3 down and 0.12 in, re-seated, with
  elbow bend: at the finish the elbows sit ~22 cm below the shoulders and
  ~9 cm out (upper arms ~39° from the sides), the bar ~12 cm lower at the
  lower chest. No turn: the drop runs down the screen from behind.
- `range`: inline. Upper arms turned 55° forward about the trunk axis, bar
  0.45 forward, elbows re-seated, shown only near the finish (hand to
  shoulder 0.5 → 0.25 torso lengths; 0.89 at full reach, 0.25 at the
  finish; from ~1.0 s, all of it by ~1.5 s). Gated by elbow bend, as first
  written, the constant forward shift pushed the ghost's hands past reach
  for half the clip (arms dead straight at 110-119% bone length, poking past
  the bar); with the new gate the bones stay at 100% throughout (checked
  0-3.5 s with the solver port). At the finish the elbows
  stay ~13 cm in front of the shoulders at the same height, elbows ~83°, the
  bar ~27 cm further forward. `view: 0.6` (total -2.0, behind-left
  three-quarter), where forward shows across the screen and the cable tower
  in front of the lifter's left stays clear of the trunk and arms (from a
  true side view, -1.57, the tower's frame may sit between the camera and
  the bar at full reach).
- `torso`: inline, as the Machine Rear Delt Row's `chest` fault: trunk and
  shoulders turned 15° back about the hips, the hands 0.23 back along the
  level line, elbows re-seated; always, `view: 0.6` (total -2.0). The head
  ~18 cm back, the bar ~14 cm back with no rise (the cable pays out level)
  and the elbow angle as the lifter's at every phase. `leanedBack(15,
  withBar: true)`, as first written, swung the bar ~10 cm up off the cable
  line at the reach.

**Fault stills:** TOP (elbows most bent) for traps, elbow, range, torso;
BOTTOM (arms reaching forward) for grip.

## Dumbbell Upright Row (224)

**The model:** stands tall, feet ~0.3 m apart, knees ~174°. A dumbbell in
each hand, overhand, the handles across (side to side), hands 0.40-0.47 m
apart, starting in front of the thighs (elbows ~153°). The elbows lead up
and out until the upper arms are level (90°; the top was lowered from 110°
on 2026-09-26), ~40° in front of the line of the shoulders; elbows 72° at
the top. The hands finish ~14 cm below and ~25 cm in front of the shoulder
joints (in front of the chest), the wrists flexed so the inner end of each
dumbbell tips up ~21°. No shrug, no trunk movement. Framed at yaw -0.5: the
left arm is on the right. First top at 1.92 s. Each dumbbell's grip rod
(0.45 m) runs ~7 cm past its end caps; with the hands 0.40-0.47 m apart the
two rods overlap across the midline (~5 cm at the bottom, ~2.6 cm at the
top), so on screen the pair reads as one bar through four plates. The hands
themselves sit in front of the shoulder joints (0-4 cm out from them), about
shoulder-joint width (0.39 m).

**Claims:**
- Activation: as the barbell, cable and Smith upright rows (lateral deltoid
  and upper trapezius primary HIGH 0.80 each, anterior deltoid LOW 0.36,
  biceps LOW 0.30), from 9 (medial 73, anterior 33% MVC), 6 and 7 (upper
  trapezius 85%, middle deltoid 78%) and 8 (biceps involvement falling with
  grip width). 8 states the dumbbell version is unstudied; the numbers are
  carried over, not measured.
- Height cue, comparison: 6 and 5, the same balanced wording as the three
  upright rows already in the app (narrowing of the space under the acromion
  when the arms rise high while turned in; can irritate sensitive shoulders;
  stop around shoulder level; stop lower if it pinches). The copy does not
  say the lift is dangerous or that stopping at shoulder level removes the
  risk; 6 calls it safe and effective with these precautions, and its
  evidence is imaging, surgical and clinical, not injury rates. The why now
  says the space narrows as the elbows come up toward shoulder height and
  beyond (6: impingement peaks ~70-120°, greatest at 70-90° without external
  rotation), not only "well above" it. The copy asks for shoulder height at
  most ("Pull until the elbows reach shoulder height at most"; comparison
  "Elbows no higher than the shoulders", "at or just below shoulder
  height"), as 6 (just below 90°) and 5 (~80°, elbows below the shoulders)
  advise and as 8 did (bar below the xiphoid); the model's 90° is the upper
  limit of that guidance. The same height why is in `HEIGHT_UR`
  (spec_191_240_frontrear.py) for the barbell, cable and Smith upright rows
  (for the lead: change all four together).
- Elbow cue: 6 (pull through the elbows, not the wrists, "so as to maximize
  muscle activity at the shoulder") and ExRx (elbows lead, wrists flex). The
  why no longer says the load goes to the forearms and biceps, which no
  cited study measured against elbow-led pulls; it says the hands leading
  turns the start into a curl (mechanics). The correct text says "up and out, higher than the
  hands", not "to the sides": the model's elbows finish ~40° in front of the
  line of the shoulders, where ExRx asks for the elbows to the sides and not
  pointing forward (for the lead: a re-export with the elbows ~20° further
  back would match ExRx; the barbell rows sit ~30° forward).
- Path cue: 6 (as close to the body as possible) plus mechanics (a load
  further forward adds shoulder-flexion and trunk-extension moment). The
  model's dumbbells are a hand's width or so in front of the chest, so the
  copy says "just in front of the body" rather than "brushing" it.
- Width cue: 8, for the barbell only; applying it to dumbbells held together
  is an extrapolation, and the why names the barbell study and says dumbbells
  have not been tested. It cites the result that fits this cue (lowering,
  lateral deltoid and upper trapezius higher at 100 than 50% of shoulder
  width) and no longer says close hands give the pull to the arms (biceps
  differed only 50 vs 200%). The label, intro, mistake, correct and SETUP
  speak of the hands being shoulder-width, not the dumbbells, since the two
  grip rods overlap on screen (above).
- Torso cue: mechanics, the same as the barbell row. The label tracks the
  spine (0.547, 0.417): at the bottom the pelvis dot sat on the dumbbell
  plates.

**Ghosts** (checked at the top, 1.92 s, and the bottom, 0 s):
- `height`: new `dumbbellUprightRowHigh` (the barbell `uprightRowHigh` moves
  without the bar line) gated by the new `dumbbellUprightRowTop` (hand to
  pelvis 0.7 → 0.88; 0.51 at the thighs, 0.89 at the top) instead of
  `.withBend`, because this model's elbow is already ~153° at the thighs
  (a third of the fault would show there). At the top the hands rise ~27 cm
  to ~12 cm above the shoulder joints (chin height) and the elbows to ~14 cm
  above the shoulders (upper arms ~120°). No turn.
- `elbow`: new `dumbbellUprightRowElbowsLow` (`uprightRowElbowsLow` without
  the bar line), with elbow bend: at the top the elbows sit ~27 cm below the
  shoulders and ~7 cm out (upper arms ~20° from the sides), the hands still
  at the chest. No turn.
- `path`: inline, hands 0.25 ahead with the elbows re-seated, with elbow
  bend, `view: -0.6` (total -1.1): the dumbbells ~15 cm further out in front
  at the top (~4 cm at the thighs), both bones at 100%.
  `barDrifting(0.25, 0.12, withBar: false)`, as first written, had no
  re-seat and stretched the ghost's arms to 111-118% through the rep.
- `width`: new `dumbbellsTogether` (hands 0.12 in, elbows 0.05 in, elbows
  re-seated; always), `.seen(0.3)` (total -0.2, nearly face-on): the hands
  ~26 cm apart at the thighs and ~32 cm at the top instead of 40-47, both
  bones at 100% (without the re-seat the upper arm was 92% and the forearm
  113% at the top).
- `torso`: `bodySwung(withBar: false)`, with elbow bend, `.seen(-0.6)`
  (total -1.1): hips ~4 cm forward, trunk 15° back, head ~18 cm back.

**Fault stills:** TOP (elbows most bent) for height, elbow, path, torso;
BOTTOM (arms hanging, the V of the hands clearest) for width.

## New fault pieces
- `seatedRaiseRising`: `between("hand_L", "pelvis", 1.0 → 1.4)`.
- `dumbbellUprightRowTop`: `between("hand_L", "pelvis", 0.7 → 0.88)`.
- `dumbbellUprightRowHigh`, `dumbbellUprightRowElbowsLow`: the barbell
  pieces' moves without the `bar` chain, which would draw a line between two
  separate dumbbells.
- `dumbbellsTogether`: hands 0.12 and elbows 0.05 torso lengths in, elbows
  re-seated; the barbell `gripBunched` (0.22 in) would push the dumbbells
  through each other.
- The cable rear delt row's grip, elbow, range and torso faults and the
  dumbbell upright row's path fault are inline, each with a comment, since
  each is used once.

Every cue has a ghost; none of the mistakes is about speed or force alone.

## For the lead
- Library entries (category, primary muscle, equipment, difficulty) match
  the models and the copy; no change recommended.
- Model fidelity, recommended: re-export the Cable Rear Delt Row (222) so
  the shoulder blades protract at the reach and retract at the finish (the
  shoulder joint ending a few cm behind its reach position, not 7 cm in
  front); check the Machine Rear Delt Row, which has the same rig
  behaviour under "squeeze the shoulder blades together". Once fixed, the
  range why and traps correct can speak of the blades again.
- Model fidelity, optional: the Cable Rear Delt Row finishes with the
  elbows ~24° below level (ExRx: horizontal); raising them ~10 cm would also
  level the forearms and straighten the wrists. Its hands sit at the very
  ends of the 0.75 m bar (little fingers on the end caps); a longer bar or
  hands ~3 cm in would put the fists on the sleeves. The Dumbbell Upright
  Row's elbows finish ~40° in front of the line of the shoulders (ExRx: to
  the sides; after a re-export ~20° further back the elbow cue could say
  "out to the sides"), and its dumbbells' grip rods overlap (trim the
  GripBar to the end caps, ~0.32 m, or widen the hands ~6 cm; the rod shows
  past the end caps in every dumbbell model). The copy is written to be true
  of all three models as they are.
- Copy elsewhere, optional: `HEIGHT_UR` in spec_191_240_frontrear.py (barbell,
  cable and Smith upright rows) still says the squeeze starts "well above
  shoulder height"; the Dumbbell Upright Row's revised why is the better
  reading of Schoenfeld 2011.
