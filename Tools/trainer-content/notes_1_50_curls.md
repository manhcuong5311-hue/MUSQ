# 1-50 redo: curls (2026-09-29)

Five new exercises from the drive's "1-100 🟢" folder: 42 Dumbbell Curl, 44 Incline Dumbbell
Curl, 45 Preacher Curl, 46 Cable Curl, 47 Bayesian Cable Curl (models `Biceps/<Name>.usdc`).
`spec_1_50_curls.py` holds the copy and setup steps (its header lists what each model shows and
the full citations), `Tools/fault-review/faults_1_50_curls.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_1_50_curls.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The briefs (`briefs_1_50/<Resource>.md`, every 0.5 s), the trainer stills at 0/1/2/3/5 s
  (`SCRATCH/shots/view/<slug>_t*.png`), the highlight tiers and `joints.json`.
- The rig and equipment straight from the USD with Blender's Python + pxr: elbow angle and
  shoulder-to-wrist distance every 1/6 s, the equipment prims' bounds (pads, pulleys, stacks)
  and the pads' slopes from the meshes' principal axes.
- "Load" = the turning effect of the weight or cable on the elbow: the lever arm from the elbow
  to the handle prim's centre, across the line of pull (gravity for the free weights; handle to
  pulley exit for the cables), as a share of its peak in that clip.
- Label layout: the pills (12 pt semibold, ~24 + 6.4 pt per character), leaders and dots drawn
  over the stills at 0/1/2/3/5 s with the rows squeezed as `spec_1_50.py` does, the app's
  edge clamp included.
- Ghosts: a Python port of `FaultGhost.solve` (same body axes, shift/turn/resolve, strengths)
  run on the real joint transforms at the fault's moment, projected with each framing plus the
  fault's `view`, drawn over the stills (no turn) or as stick figures (turned).

## Shared facts about the models

- Same clip timing in all five: two identical 4 s reps; up ~1.1-1.25 s (from ~0.1-0.25 s),
  the top held ~0.6 s (1.25-1.9 s), down ~1.9 s, a short rest at the bottom. The Dumbbell
  Curl's torso cue ("curl in about a second, pause briefly at the top and take about two
  seconds to lower") describes exactly that.
- One body (torso, neck to pelvis, 0.592 m). Shoulder-to-wrist at the bottom: 0.908 torso
  lengths (Dumbbell Curl, 180°), 0.906 (incline, cable, Bayesian, 172°), 0.899 (preacher,
  164°); ~0.78 at 120°; 0.64 at 90°; at the top 0.510 (dumbbell), 0.457 (incline, cable),
  0.495 (preacher), 0.353 (Bayesian).
- Load along the rep (share of each clip's own peak):

  | model | bottom | peak at | top |
  |---|---|---|---|
  | Dumbbell Curl | 0.25 (180°) | ~105°, forearms level | 0.81 (68°) |
  | Incline Dumbbell Curl | 0.19 (172°) | ~95°, forearms level | 0.84 (60°) |
  | Preacher Curl | 0.90 (164°) | ~135°, forearms level | 0.17 (66°) |
  | Cable Curl | -0.47 (172°; resists from ~150°) | ~100° to the top | 0.98 (60°) |
  | Bayesian Cable Curl | 0.45 (172°) | ~110-130° | 0.45 (45°) |

  Peak lever arms are all ~0.33 m, so the shares compare across models (the Bayesian's 0.45
  at the bottom is 0.149 m against the dumbbell curl's 0.080 m).
- Highlight tiers (`highlight_tiers.json`, identical in all five): bright (1.0, 0.06, 0.01) =
  BicepsBrachii_LongHead and _ShortHead -> PRIMARY "Biceps Brachii". Dim (0.26, 0.02, 0.01) =
  Brachialis, Brachioradialis, ExtensorCarpiRadialisBrevis/Longus, ExtensorCarpiUlnaris,
  ExtensorDigitorum, FlexorCarpiRadialis, FlexorDigitorumProfundus/Superficialis,
  PalmarisLongus -> SECONDARY "Brachialis", "Brachioradialis" and "Forearms". The wrist and
  finger flexors and extensors share one "Forearms" row (part_of -> forearms): the legend
  prints every secondary on one line (SF Mono 9.5 pt, ~6.4 pt per character, 354 pt wide), and
  "BRACHIALIS · BRACHIORADIALIS · FOREARM FLEXORS" (46 characters) plus "SECONDARY" would run
  past it; with "FOREARMS" it is 39 and fits. Both groups are painted, so one row naming the
  forearm muscles as a whole matches the paint better than "Forearm Flexors" alone.
- All grips are supinated or (preacher) semi-supinated; wrists 0-4° all rep.

## Activation (all five)

- Biceps Brachii PRIMARY HIGH (0.80-0.86): the bright tier. Oliveira 2009: the standing
  (DBC) and incline (IDC) dumbbell curls drew up to 95% of max RMS in the final third and
  "a considerable neuromuscular effort throughout the whole elbow range of motion"; the
  preacher curl 80% at the start. Coratella 2023 (Sports): supinated grips drew more biceps
  excitation than neutral (+12%) or pronated (+19%). Bayesian set lowest (0.80): Parpa 2025,
  dumbbell curl 111% vs Bayesian 93% MVC at 80% of each lift's 1RM.
- Brachialis SECONDARY MODERATE 0.66 in all five: dim tier; the brachialis flexes the elbow in
  every forearm position (Basmajian & Latif 1957, JBJS 39-A(5):1106-1118, PMID 13475410, via
  the 241-300 notes; Date 2021, Front Physiol 12:809422, PMID 35002781: "The BR has different
  EMG pattern from the BBLH and the BBSH", BR = brachialis; both now in the header's
  sources). Its surface EMG is rarely measured in curl studies and no source here separates
  these five (Attarieh 2025 even found similar brachialis growth for preacher, 10%, and
  Bayesian, 8%, cable curls), so one house value within the earlier curls' range (0.62-0.68)
  is used for all five.
- Brachioradialis SECONDARY: MODERATE 0.44 for the dumbbell, incline, cable and Bayesian curls,
  LOW 0.38 for the preacher curl. Boland 2008: active in elbow flexion whatever the forearm
  position; Kleiber 2015: its share rises only with the hand pronated; Coratella 2023 (Sports):
  slightly higher supinated than neutral or pronated. No study here compares these curls with
  each other for the brachioradialis, so the four share one value. The preacher's lower value
  follows the app's existing preacher entries (Barbell and Dumbbell Preacher 0.36, Cable
  Preacher 0.38); it is house convention, not a measured ranking. Young et al. 2014 (ACE, not
  peer-reviewed) found the incline and preacher curls drew significantly less brachioradialis
  than the narrow-grip EZ curl, but compared them with nothing else (it tested no standing
  dumbbell curl and reports no brachioradialis comparison with its cable or barbell curl), and
  Marcolin 2018 found EZ-bar curls drew more brachioradialis than dumbbell curls, so ACE does
  not rank the preacher below the dumbbell curl either. (Revised 2026-09-30: the incline was
  LOW 0.38 on ACE alone; the brachialis values 0.64/0.66/0.68 varied with no source.)
- Forearms SECONDARY LOW 0.30: dim tier; they hold the grip and the wrist straight. Mogk &
  Keir 2003: gripping works both the forearm flexors and the extensors (extensor activity
  generally larger at low to mid grip forces). StrengthLog lists the forearm flexors as the
  secondary muscles of the dumbbell, incline, preacher, cable and Bayesian curls.
- Stabilisers: anterior deltoid in all five (Coratella 2023, both papers: its excitation changes
  with the grip and with arm flexion during curls, "stabilizing the humeral head"; ExRx lists
  it for the Dumbbell Curl and the Dumbbell Incline Curl). Upper trapezius for the Dumbbell Curl
  only: ExRx Dumbbell Curl (exrx.net/WeightExercises/Biceps/DBCurl; the live site returns 403,
  read from the Wayback Machine snapshot of 2022-05-18, same in 2018-11-16) lists "Deltoid,
  Anterior; Trapezius, Upper; Trapezius, Middle; Levator Scapulae; Wrist Flexors". ExRx
  Dumbbell Incline Curl (DBInclineCurl, snapshots 2018-08-16, 2021-01-26 and 2022-08-15) lists
  only "Deltoid, Anterior; Wrist Flexors", so the incline has the anterior deltoid alone
  (revised 2026-09-30; it had the upper trapezius from a second-hand reading of ExRx's Cable
  One Arm Curl). Pectoralis major for the cable curl (Signorile 2017: more pectoralis major and
  anterior deltoid activity on a cable curl than on a selectorised machine). Core for the
  standing lifts and the preacher (bracing; no EMG source; house convention). The Bayesian no
  longer lists the obliques (revised 2026-09-30): there is no source, and Signorile 2017, the
  one study here that measured the external obliques in a cable curl, found a cable
  difference for them only in the chest and overhead presses, not the curl.

## Dumbbell Curl

Model: standing, feet parallel ~0.28 m apart (hip-width), knees 179°, trunk 4° back and
still; two plate-loaded dumbbells, handles side to side; palms forward hanging, turned up
toward the shoulders at the top, no forearm turn; both arms together; elbows 180° -> 68°,
elbows fixed within 1 cm, upper arms 7° forward, 15° out; top: forearms ~30° above level,
dumbbells in front of the chest (~8 cm below and ~0.33 m in front of the shoulders).

Against the library: the gated Biceps Curl model (Biceps/BicepsCurl, brief regenerated with
brief_arms.py) is the same motion (same timing, grip and elbow path) stopping at 172° / 60°
with the trunk upright; its copy (palms up, elbows by the ribs, no swing, lower over two to
three seconds) is not contradicted here. The difference is written into the copy: palms forward
from the start (the grip intro and setup), arms lowered all the way straight (range cue), a
brief pause at the top (torso correct). Its elbow cue says "stop when the forearms are about
vertical"; this copy says "finish with the dumbbells in front of the chest ... the elbows still
at your sides", which is what this model does and does not conflict. The Alternating
Dumbbell Curl starts palm-in, turns the palm up on the way and works one arm at a time.

- shoulder: "Shrugging brings the upper traps into the lift, and rolling the shoulders forward
  carries the upper arms off their fixed place, so the curl stops being an elbow-only
  movement" — shrugging is the upper trapezius's action (anatomy); NSCA 2012 p. 46 ("Avoid
  rolling shoulders forward during any part of the lift"; no muscle named); the upper arms'
  fixed place is the model (elbows within 1 cm). Revised 2026-09-30: it no longer says the
  front deltoids come in, which no source ties to shrugging or rolling the shoulders forward
  (Coratella JFMK measured ~30° of arm flexion, which the elbow cue covers).
- elbow: "Letting the elbows drift forward brings the front deltoids in and turns the top of the
  curl into a front raise" — Coratella 2023 JFMK full text (PMC9944112): "The anterior deltoid
  was more excited when flexing vs. not flexing the arms"; the flexed variations used ~30° of
  arm flexion, and biceps excitation also rose (+17.7% straight bar, +20.3% EZ bar, lifting
  phase), so the copy says the front deltoids come in, never that the biceps drop out (the
  abstract alone only says the anterior deltoid "showed distinct excitation based on the arm
  flexion/no-flexion", with no direction). StrengthLog Dumbbell Curl ("forward movement shifts
  load to front deltoids"); NSCA ("Keep elbows positioned at the sides").
- grip (GRIP_WHY, shared by four entries): "In trained lifters, curls with the palms turned up
  have worked the biceps harder than palm-in or palm-down curls" — Coratella 2023 Sports (ten
  competitive bodybuilders, +12% / +19%). "a bent wrist grips far more weakly" — Mogk & Keir
  2003 ("A flexed wrist reduced maximum grip force by 40-50%"). "moves the weight with the
  wrists instead of the elbows" — mechanics; StrengthLog: keep the wrists straight.
- torso: momentum from the hips and lower back skips "the heaviest part of the rep, with the
  forearms near level" — load peak with the forearms level (rig); NSCA ("Avoid using momentum");
  StrengthLog ("If you start to swing ... remove some weight"). Tempo = the model's timing.
- range: "The first part of the curl is the lightest" — rig (0.25 of peak at the bottom);
  Oliveira 2009 (low EMG at the start of the DBC's concentric phase). FULL_RANGE, "in new
  lifters, full-range curl training has built more strength than mid-range partial reps" —
  Pinto 2012: 40 young men with no resistance training experience, bilateral barbell preacher
  curl, FULL 0-130° vs PART 50-100°, 10 weeks, 1RM tested over the full range (25.7% vs 16.0%);
  muscle thickness not different, so no muscle claim, and "in new lifters" for the population
  (added 2026-09-30). Used on the dumbbell, incline and Bayesian curls, whose bottom range is
  loaded (0.25, 0.19 and 0.45 of peak), not on the Cable Curl (see there). NSCA: elbows
  completely extended at the start.
- Setup: NSCA (supinated grip, stand erect, feet hip-width), the model (palms forward, both
  together).

## Incline Dumbbell Curl

Model: back pad 65° from the floor (0.59 m long, 0.38 m wide, top edge at the shoulders, no
head rest), trunk 25° back, feet flat in front (knees ~114°); arms hang vertical beside the pad
= 25° of shoulder extension relative to the trunk, fixed; elbows 172° -> 60°; palms forward
hanging, up at the top.

- back: intro "An incline bench, the back flat on the pad" (revised 2026-09-30 from "A steep
  incline": the point of the lift is shoulder extension, which grows as the pad reclines, so
  "steep" pointed the wrong way; 65° is only the model's angle and stays in the setup and the
  correct text). "Leaning back with the arms hanging extends the shoulders, which stretches the
  biceps' long head, the head that starts above the shoulder joint" — Oliveira 2009 full text
  (PMC3737788; 22 men in strength training for at least a year): "The shoulder
  hyperextension, elicited by the IDC protocol, stretches the long head of biceps brachii
  muscle beyond its optimal length, leading to an inefficient actin-myosin coupling". The same
  paper found the IDC and the standing DBC "resulted in similar patterns of biceps brachii
  activation for the whole range of motion", so no activation advantage may be claimed for the
  incline;
  StrengthLog Incline Dumbbell Curl (the biceps start on the shoulder blade and lengthen with
  the arms behind the body). "That is what sets the incline curl apart" — definitional (the
  IDC is defined by the shoulder position). The copy makes no growth claim: Attarieh 2025 and
  Larsen 2026 found similar growth with the shoulder extended or flexed/neutral when the
  resistance profiles were matched. "about 65°" = the model's pad.
- arms: elbows swinging forward "gives that position up and brings the front deltoids into the
  lift" — Coratella 2023 JFMK; StrengthLog ("Let your arms hang straight down").
- shoulder: rolling forward "carries the upper arms forward with them, so they stop hanging
  behind the body and the long head loses its stretch" — mechanics + Oliveira; NSCA (no rolling
  the shoulders forward).
- grip: GRIP_WHY as above.
- range: "the long head is longest and the dumbbells pull least on the elbows" at the bottom —
  rig (0.19 of peak) and Oliveira (IDC EMG low at the start of the concentric, high at the end);
  FULL_RANGE = Pinto 2012 (new lifters, see the Dumbbell Curl).
- Brachioradialis MODERATE 0.44 like the dumbbell curl (see Activation); stabilisers: the
  anterior deltoid only (ExRx Dumbbell Incline Curl).

## Preacher Curl (EZ bar)

Model: two separate arm pads (35° slope, 0.15 m wide each) on a post and cross brace, seated
upright (0°), no chest pad; upper arms 45° below horizontal over the pads, touching them near
the elbows (the elbow joints ~7 cm above the pad surface), the armpits just above the top edges
(shoulder joints 14 cm above them); hands on the bar's inner angled grips, ~0.52 m apart (the
shoulder joints 0.40 m), palms turned ~40° in from fully up; elbows 164° -> 66°.

- pad: "The pads hold the upper arms at about 45° in front of the body, so bending the elbows is
  the only motion" — the model; StrengthLog Barbell Preacher Curl (upper arms against the pad).
- range: the bar "pulls hardest on the elbows from almost straight to level forearms and hardly
  at all once they are near upright" — rig (0.90 at 164°, peak at ~135°, 0.17 at the top);
  Oliveira 2009 (preacher EMG high only near extension). "in new lifters on preacher curls,
  training the lower range has built more strength, and at least as much muscle, as training
  the upper range" — Pedrosa 2023 (19 untrained young women, "Nineteen young women" / "in
  untrained young women"; seated dumbbell preacher curl, one arm 0-68°, the other 68-135°: more
  1RM and distal CSA, similar CSA at 50% and summed) and Sato 2021 ("Thirty-two non-resistance
  trained young adults"; one-arm dumbbell curls on a preacher bench, 45° shoulder flexion,
  supinated — methods read on frontiersin.org: 0-50° built more strength and muscle thickness
  than 80-130°). "in new lifters" added 2026-09-30: both studies trained beginners.
- grip: "The angled grips turn the palms partly in from fully up" — the model (~40°). "Next to a
  straight bar the difference in biceps activity has been small, so the choice of bar is
  largely a matter of comfort" — Coratella 2023 JFMK (straight bar +1.8% over EZ, arms still,
  lifting phase: small but significant, hence "small" and "largely", not "no difference") and
  Marcolin 2018 ("The small difference between BC and EZ variants ... makes the choice between
  these two exercises a matter of subjective comfort"); both standing curls, so the copy does
  not say "on the preacher bench". Revised 2026-09-30: it said "a matter of comfort for the
  wrists", and neither source names the wrists. Bent wrist: Mogk & Keir 2003. "Take the inner angled
  grips ... about shoulder-width" — the model (hands on the first bend); NSCA (EZ-bar curl,
  supinated grip at approximately shoulder-width).
- torso: rocking back "skips the hardest part of the rep at the bottom" — rig (the bottom half
  is the heavy half); StrengthLog (no swinging). The model sits upright with no chest pad, so
  the copy says "sit tall", not "chest on the pad".
- seat: StrengthLog ("The top of the pad should sit comfortably under your armpits when your
  arms are fully extended. Keep your feet flat on the ground"); the shoulders hunching when the
  seat is low is mechanics, as in the earlier preacher entries.
- Brachioradialis LOW 0.38: the app's preacher value (house convention, see Activation; ACE
  2014 does not rank it below the dumbbell curl); the semi-supinated grip is not claimed to
  change it (Kleiber 2015: only pronation changed its share).
- Comparison follows the Barbell Preacher Curl's (stopping short at the bottom).

## Cable Curl (two low pulleys in front)

Model: two columns, low pulleys ~0.94 m in front of the ankles, 0.62 m either side, ~13 cm off
the floor; a D-handle in each hand, both arms together; trunk 10° back all rep; cables ~36°
below horizontal at the start, ~53° at the top; stacks 4-5 cm off their rests at the bottom.

- top: "the cables pull hardest from the middle of the curl all the way to the top" — rig (peak
  from ~100° to the top, 0.98 at 60°). No claim that this builds more muscle: Nunes 2020 (cable
  vs barbell preacher curls, torque peaking at opposite ends: similar growth, 7% vs 8%).
- grip: GRIP_WHY (Coratella 2023 Sports, full text PMC10054060: "a Cable Tower ... connected to
  a bar (42.5 cm length ...) for the supinated and pronated handgrip, and with a rope ... for
  the neutral handgrip"; "Each exercise was performed in a standing position. The arms were
  maintained parallel to the trunk").
- elbow: "At the bottom the cables pull the arms toward the pulleys" — rig (the cables' moment
  about the shoulders is forward at the bottom, down and back at the top); front deltoid —
  Coratella JFMK; StrengthLog Cable Curl (keep the upper arm still or slightly forward).
- torso: the lean back as a counterbalance — the model (10° all rep, still); momentum — NSCA.
- range (revised 2026-09-30): intro "Each rep starts with the arms almost straight", label
  "Almost straight", correct "until the arms are almost straight by your sides" and setup
  "arms almost straight" — the model's straightest elbow is 172°, as on the incline and
  Bayesian models (only the Dumbbell Curl reaches 180°). Why: "the cables run forward from the
  hands, above the line of the forearms, so they pull the hands forward instead of resisting
  the first part of the curl" — rig (torque.py, left handle, pulley exit ~(0.62, 0.13, 1.18):
  load moment -0.160 m at 172° = -0.47 of peak, -0.086 at 161°, +0.007 at 149°, peak from ~100°
  to the top; the negative sign is a flexion moment, so the cable helps the curl there, not
  just "barely resists" it as the first draft said). "Lowering until the arms are almost
  straight still takes the elbows through nearly their whole range" — the model (172° -> 60°).
  FULL_RANGE (Pinto 2012) was dropped here: Pinto's curl was heaviest near the bottom, while
  this one is not resisted below ~150°, so its strength result is a weak fit. "the stacks still
  just off their rests" — the model.
- Stabilisers: Signorile 2017 (pectoralis major and anterior deltoid higher on a cable curl).
- Setup: "Step back about a metre" — the model (0.94 m); StrengthLog (take a step back).

## Bayesian Cable Curl

Model: back to one column behind and to the left (low pulley ~0.8 m behind the heels, 0.62 m
left, ~13 cm up); LEFT arm works, upper arm 23° behind the trunk all rep, elbow 172° -> 45°,
hand finishing in front of the left chest; right arm hangs empty; feet parallel, knees
straight, trunk upright; stack ~2 cm off its rest at the bottom.

- elbow: "Holding the elbow behind the body keeps the shoulder extended, the position that makes
  this a Bayesian curl" — Attarieh 2025 (Bayesian = unilateral cable curl with the shoulder
  extended); StrengthLog Bayesian Curl ("Keep your upper arm stationary"); front deltoid —
  Coratella JFMK. No growth claim (Attarieh 2025, Larsen 2026: similar growth). The correct
  text ends "curl until the hand is in front of the chest" (final check 2026-09-30; it said
  "in front of the shoulder"): at the top (45°) the hand is 0.17 m below the shoulder joint and
  0.12 m in front of it, level with the chest in the 2.0 s still.
- range: "the pull on the elbow is already about half its peak with the arm almost straight,
  where a dumbbell curl is at its lightest" — rig (0.45 vs the Dumbbell Curl's 0.25); FULL_RANGE
  = Pinto 2012.
- grip: Coratella 2023 Sports; Mogk & Keir 2003.
- shoulder: "Shrugging brings the upper traps into the lift, and rolling the working shoulder
  forward carries the upper arm off its fixed place behind the body" — shrugging is the upper
  trapezius's action (anatomy); mechanics (the upper arm's fixed place behind the body, 23°
  back in the model); NSCA (no rolling the shoulders forward). Revised 2026-09-30: it no longer
  says the front deltoid comes in (no source ties that to shrugging or rolling forward).
- torso: "rocking the body forward drags the handle forward without bending the elbow" —
  mechanics (the pulley is behind). Mistake revised 2026-09-30 to "Rocking forward from the
  hips as the handle comes up, the trunk tipping toward the hand", to match the ghost
  (cableBehindRockedForward grows with the elbow's bend, 0.09 at the bottom, full from 90°,
  stilled at the top, where the hand is in front of the chest); it said "as the curl starts",
  where the ghost barely shows. StrengthLog has the torso leaning slightly forward as a set
  position; the model stands tall, so the copy asks to stand tall and keep the trunk still and
  calls only rocking during the rep a fault.
- comparison (revised 2026-09-30): "When the elbow swings forward, the arm leaves the position
  behind the body, the front deltoid joins in and the top of the curl turns into a front
  raise" — the Single-Arm Cable Curl's wording; Coratella 2023 JFMK (anterior deltoid more
  excited with ~30° of arm flexion, biceps also higher). It said "the front deltoid finishes
  the rep", which went beyond the source and hinted the biceps drop out.
- range label "Almost straight" (was "Arm straight", against its own intro and correct text:
  the elbow stops at 172°).
- Stabilisers: anterior deltoid and core (obliques removed, see Activation).
- Biceps 0.80 (Parpa 2025: eleven volunteers, dumbbell curl 111% vs Bayesian 93% MVC at 80% of
  each lift's 1RM; biceps only, so it sets nothing else).

## Labels (checked on the stills; rows are the squeezed values)

- Dumbbell Curl: top row both sides (short pills clear of the head: "Shoulders down" -> far
  shoulder, left 0.124; "Elbows at sides" -> near elbow, right 0.16), 0.60 both sides beside the
  thighs ("Wrists straight" -> far hand, "Straight arms" -> near hand), 0.76 right ("No body
  swing" -> near hip). The dumbbells span the screen at rows ~0.44-0.54 at the bottom and
  ~0.21-0.33 at the top, and the hanging arms fill both sides at 0.25-0.47, so no pill sits
  there. Simulator QA 2026-09-30: with "Straight arms" at 0.76 below "No body swing" at 0.60,
  the hand's leader ran through the hip pill's text; swapped, the hip's leader passes ~26 pt
  left of the hand's pill. "Shoulders down" went from 0.16 to 0.124: in the shoulder fault's
  view (mistake sheet up, model raised) the far plate and the ghost's far hand tip reached into
  it; at 0.124 they clear it by ~10 and ~18 pt, and the mistake banner ends ~23 pt above it.
- Incline: left 0.16 / 0.24 above the dumbbells' top position, left 0.45 at the thighs' height
  ("Flat wrists" -> far hand, visible at the top where its fault shows; at the bottom that
  hand hangs behind the trunk and its dot sits on the hip; shortened from "Wrists straight" on
  2026-09-30 so the pill ends at x 0.268 instead of 0.335: over the far plate at 3.0 s it now
  covers ~120 px of the still instead of ~600), right 0.66 / 0.80 below the hanging
  dumbbell. "Almost straight" and "Elbows point to the floor" both -> the near elbow
  (forearm_L), where their leaders meet. Simulator QA 2026-09-30: "Almost straight" pointed at
  the near hand, and from ~0.5 s to ~3.2 s its leader crossed the one to the elbow (the hand
  rises left of the elbow); the range cue is about the elbow's bend, so it now shares the dot.
- Preacher: left 0.16 above the far plate's top position ("Almost straight" -> far hand), left
  0.59 beside the far knee ("Wrists straight" -> far hand; grip and range share that dot), left
  0.75 above the far shoe ("Arms on pads" -> far elbow), right 0.68 / 0.80 below the seat ("Seat
  set": the pill starts right of the post and its leader runs level across the post's foot to
  the near foot). Simulator QA 2026-09-30: "Arms on pads" sat at 0.36, in the far plate's
  sweep (over ~55% of the pill at 0.5-0.6 s and 2.8-3.2 s), and its leader to the far elbow
  crossed both leaders to the far hand; at 0.75 the three left leaders fan out without crossing
  at 0, 1, 2 and 3 s. Grip and range swapped rows: with the mistake sheet up the model rises,
  and at the top of the rep the far plate went under the pill at 0.16, where the range fault
  (shown at the bottom, the plate low) now sits.
- Cable Curl (revised 2026-09-30): left 0.16 / 0.24 above the cables and in front of the face
  ("Curl all the way up" and "Flat wrists", both -> the near hand, whose wrist the grip ghost
  folds; the grip pointed at the far hand before); right 0.32 / 0.52 / 0.60 behind the back.
  "Arms at sides" and "Almost straight" both -> the near elbow (forearm_L), which is what
  drifts in the elbow fault (the elbow cue pointed at the shoulder, the ghost's fixed pivot,
  before). "Almost straight" (120 pt) moved from 0.46 to 0.52: at 0.46 it would start 2 pt from
  the buttocks (the back's edge reaches x 0.659 there); at 0.52 the edge is at most 0.634 and
  the pill clears it by ~10 pt; its leader runs over the static buttocks to the elbow.
  "Arms almost straight" (152 pt) would cover the buttocks at any row from 0.44 to 0.52.
- Bayesian: left 0.124 ("Shoulder down" -> the working side's collarbone, in view at the front;
  0.16 until the simulator QA of 2026-09-30, where the shoulder ghost's hand tip, in front of
  the upper chest with the mistake sheet up, sat on the pill's right end; now ~20 pt clear),
  right 0.16 ("Upper arm still" -> near shoulder), right 0.30 ("Almost straight" -> near elbow,
  fixed behind the body; the 120 pt pill starts at x 0.665, ~21 pt clear of the drawn-back
  arm), left 0.30 ("Flat wrist" -> the working hand, short enough to end in
  front of the chest; at the top its leader is short, at the bottom it crosses the trunk to the
  hand behind the hip), left 0.50 ("Stand tall" -> pelvis). The hand travels from behind the hip
  to in front of the chest, so any hand dot's leader crosses the body at one end; the grip's
  crosses at the bottom, away from where its fault shows.

## Ghosts

All position cues have a ghost; none is about tempo alone. Pieces reused from FaultPoses.swift:
hunched, elbowsForward, curlWristsCurled, curlBottomCut, bodySwung, bodySwungOneArm,
shouldersForward, curlArmsOffPad, curlStoppedShortOfTop, preacherRockedBack, preacherSatLow. Two
new pieces: `inclineSatUpright` (trunk -25° about the hips, arms +25° about the shoulders: the
trunk upright and the arms hanging in line with it; ~30 cm at the hands, ~23 cm at the
shoulders) and `cableBehindRockedForward` (bodySwungOneArm mirrored: hips 0.06 back, trunk 15°
forward, left arm carried). Views: Dumbbell Curl as the Biceps Curl (shoulder -0.6, the rest
-0.9); incline -0.6 (true left side); preacher as the Reverse/Barbell Preacher Curls (pad and
grip as framed, range and torso -0.4, seat +0.5); cable and Bayesian as framed (near side-on).
The Python port confirmed each ghost's direction and size (elbow faults 17-22 cm at the hands,
range folds 27-28 cm, torso 18 cm, shoulders 7 cm, wrists 10 cm).

## Checks run

- 2026-09-30 revision (two reviews: sources and model fidelity): see the "Revised 2026-09-30"
  notes above. Pill placement was re-checked with the app's geometry (24 + 6.4 pt per
  character, 28 pt tall, 8 pt edge clamp) against the body pixels of the stills at 0/1/2/3/5 s,
  and the Cable Curl, Incline (3 s) and Bayesian layouts were drawn over the stills.

- Final check 2026-09-30: every cited paper re-read on Europe PMC (abstracts; the Coratella
  JFMK "more excited when flexing" sentence and ~30° of arm flexion in the PMC9944112 full
  text), the NSCA p. 46 coaching points in the PDF, and ExRx's DBCurl (2022-05-18) and
  DBInclineCurl (2022-08-15) stabiliser lists on the Wayback Machine: all as cited. Labels
  drawn over all 25 stills (SCRATCH/../final_curls/*_grid.png); the only pills over moving
  parts are the Preacher's "Arms on pads", crossed by the far plate mid-rep, and the Incline's
  "Flat wrists", touched by the far plate at 3.0 s (~120 px); both known, see Labels ("Arms
  on pads" has since moved to 0.75, see the simulator QA below).
- Simulator QA 2026-09-30 (the first in-app shots): trainer stills at 0/1/3 s and every fault
  ghost at its moment (bottoms.json), then re-shot from a private build (the repo mirrored,
  integrate_1_50.py run on the mirror, iPhone 17 simulator) at 0/1/2/3 s and every fault after
  the fixes. Every ghost draws its sheet's mistake in the right direction and reads at its
  moment; fixes: see Labels (Dumbbell Curl swap and shoulder row, Incline range dot, Preacher
  pad row and grip/range swap, Bayesian shoulder row). The Incline's "Flat wrists" is still
  touched by the far plate at ~3 s (known).
- `python3 preview_1_50.py curls` and `python3 spec_1_50.py curls`: OK (5 exercises).
- `python3 Tools/fault-review/check_faults_1_50.py`: BUILD SUCCEEDED with the compound, curls and
  forearm families pasted.

## Open points

- The preacher curl's faults of the top (pad and grip as framed, torso at -0.4): with the
  mistake view's lift the near plate runs under the mistake banner and partly behind the eye
  button at the top of the rep. No view avoids it (further left the plate covers the head,
  toward the front the bar spans the viewport); the ghosts themselves stay clear of both.
- Cable Curl elbow fault: the ghost's far hand tip ends ~5 pt below the mistake banner at the
  top of the rep (no overlap).
- "Forearms" is a new activation name in the app (files under forearms); rename to "Forearm
  Flexors" if the legend width is not a concern.
- The incline bench at 65° is the model's; the copy states the model's angle and makes no claim
  about the best angle.
