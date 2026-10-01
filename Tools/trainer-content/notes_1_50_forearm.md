# Exercises 1-50 redo (2026-09-29): forearm family (Reverse Curl, Wrist Curl)

Two exercises new to the app, written to what each model shows. Copy lives in
`spec_1_50_forearm.py`, ghosts in
`Tools/fault-review/faults_1_50_forearm.swift.txt`, still moments in
`Tools/fault-review/fault_moments_1_50_forearm.json`. Model numbers come from
`briefs_1_50/ReverseCurl.md` and `briefs_1_50/WristCurl.md`, the trainer
stills (`shots/view/reverse-curl_t*.png`, `wrist-curl_t*.png`), the highlight
tiers and the USD itself (joints, finger joints and the equipment's mesh over
the clip, read with Blender's Python). Torso length (neck to pelvis) is
0.592 m.

## Sources (short names used below)

- **Coratella 2023 Sports** — Coratella G, Tornatore G, Longo S, Toninelli N,
  Padovan R, Esposito F, Cè E, Sports 11(3):64, doi 10.3390/sports11030064
  (PMC10054060, full text read). Ten male competitive bodybuilders, standing
  bilateral curls on a cable tower at 8-RM, a 42.5 cm bar for the supinated
  and pronated grips, a rope for neutral, arms kept parallel to the trunk.
  nRMS is normalised to each muscle's maximum voluntary isometric
  excitation; the paper reports differences between grips, not absolute
  levels. Lifting phase: biceps nRMS supinated > pronated by +19(7)% (ES
  2.60) and > neutral by +12(9)%; brachioradialis supinated > pronated by
  +5(4)% (ES 1.01) and > neutral by +6(5)%, pronated and neutral alike;
  anterior deltoid pronated > supinated by +6(3)% and neutral > supinated
  by +9(2)% (pronated vs neutral not reported as different). Lowering: no
  grip differences for biceps or brachioradialis; anterior deltoid pronated
  > supinated by +5(4)%. The authors describe the brachioradialis as
  inserting on the radial styloid, flexing the elbow and keeping the forearm
  toward neutral, and the brachialis as "the most powerful flexor of the
  forearm", not inserting on the radius. They suggest (not measured) that
  the pronated grip needs more wrist stabilisation toward extension from the
  wrist extensors, and explain the anterior deltoid's rise as stabilisation
  (the abstract: changing the grip "requires different anterior deltoid
  interventions for stabilizing the humeral head"; the discussion: possibly
  "compensation for the lower excitation of the biceps brachii").
- **Coratella 2023 JFMK** — Coratella G, Tornatore G, Longo S, Esposito F, Cè
  E, J Funct Morphol Kinesiol 8(1):13, doi 10.3390/jfmk8010013, PMID 36810497
  (abstract and full text via PMC9944112). Bilateral palm-up straight and EZ
  barbell curls at 8-RM with and without flexing the arms (~30°): "The arm
  flexion induced a greater excitation of the anterior deltoid"; flexing the
  arms "greatly engages the anterior deltoid as the prime mover". Arm
  flexion also raised biceps excitation in the lifting phase (+17.7%
  straight bar, +20.3% EZ bar). The authors treat flexing as a variation to
  include, not a fault; the elbow cue's fault framing rests on ExRx and
  StrengthLog.
- **Boland 2008** — Boland MR, Spigelman T, Uhl TL, J Hand Surg Am
  33(10):1853-1859, doi 10.1016/j.jhsa.2008.07.019, PMID 19084189 (abstract
  via Europe PMC). Ten adults, fine-wire EMG of the brachioradialis, elbow
  flexion with the forearm neutral, pronated or supinated at 0, 22, 45 and
  67 N: "No difference in muscular activation was found during elbow
  flexion tasks in the 3 forearm positions"; the authors read its primary
  function as "a consistent elbow stabilizer during flexion tasks".
- **Kleiber 2015** — Kleiber T, Kunz L, Disselhorst-Klug C, Front Physiol
  6:215, doi 10.3389/fphys.2015.00215, PMID 26300781 (abstract via PMC).
  Sixteen subjects, slow (20°/s) unloaded elbow flexions: the
  brachioradialis's contribution was significantly greater with the hand
  pronated than supinated or neutral; biceps activity did not change.
- **Kohn 2018** — Kohn S, Smart RR, Jakobi JM, Physiol Rep 6(1):e13560, doi
  10.14814/phy2.13560, PMID 29333724 (abstract and methods via PMC5789656).
  Eleven men (23 ± 3 years), excluded if they took part in high levels of
  upper-body strength training; isometric elbow-flexion MVC with the elbow at
  110° (full extension 180°): 213.6 N supinated, 243.6 N neutral, 113.6 N pronated (pronated about
  53% of supinated); voluntary activation 93.0% supinated, 70.9% pronated. A
  mechanical disadvantage in pronation as well as lower drive, so part of
  the gap is unpractised drive and it may be smaller in trained lifters; the
  copy says only "much weaker", as the Reverse Preacher Curl does.
- **Date 2021** — Date S, Kurumadani H, Nakashima Y, Ishii Y, Ueda A,
  Kurauchi K, Sunagawa T, Front Physiol 12:809422, doi
  10.3389/fphys.2021.809422 (full text via PMC8733609). Six men, unloaded
  isotonic elbow flexion in supination, neutral and pronation: the
  brachialis's EMG pattern was similar in all three forearm positions, the
  biceps heads' was not (the brachialis inserts on the ulna). Their "BR" is
  the brachialis.
- **Pinto 2012** — Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE,
  Bottaro M, J Strength Cond Res 26(8):2140-2145, doi
  10.1519/JSC.0b013e31823a3b15, PMID 22027847 (abstract; protocol as
  reported from the full text). Ten weeks of preacher-curl training in
  untrained young men, n = 15 a group: full range 0-130° of elbow flexion
  against mid-range partials 50-100°. Elbow-flexion 1RM rose 25.7% full and
  16.0% partial (full > partial after training); elbow flexor thickness rose
  in both (9.65% and 7.83%).
- **Mogk & Keir 2003** — Mogk JP, Keir PJ, Ergonomics 46(9):956-975, doi
  10.1080/0014013031000107595, PMID 12775491 (abstract). Extensor activity
  was always greater with the forearm pronated; a flexed wrist reduced
  maximum grip force by 40-50%.
- **Snijders 1987** — Snijders CJ, Volkers AC, Mechelse K, Vleeming A, Med Sci
  Sports Exerc 19(5):518-523, PMID 3683157 (abstract). Grasping and pinching
  always cause a flexing moment at the wrist, balanced by extensor activity
  (force and EMG).
- **Ikeda 2025** — Ikeda K, Kaneoka K, Matsunaga N, Ikumi A, Yamazaki M,
  Yoshii Y, J Orthop Surg Res 20(1):53, doi 10.1186/s13018-024-05363-x (full
  text on PMC11740565, re-checked for this family). 20 men, 40 limbs.
  Maximum isometric wrist flexion 13.6 ± 2.8 N m, extension 8.2 ± 1.4 N m.
  Wrist flexion held at 75% of the maximum torque measured in neutral: FCR
  93.1 %MVE supinated, 79.7 neutral, 57.8
  pronated; FCU 73.1, 72.2, 62.4. Extensor co-activation during that flexion:
  ECRB 14.0 supinated, 15.6 neutral, 16.1 pronated %MVE; ECU 16.1, 24.4,
  45.8. Set-up (methods): "Participants were seated with their forearms
  resting on the hand support ... The chair height was adjusted to ensure
  that the shoulder were not elevated. The elbow was maintained at a
  90-degree flexion position" (a lab protocol, not a training outcome).
- **Neumann** — Neumann DA, *Kinesiology of the Musculoskeletal System*, 3rd
  ed. (2017), ch. 7, as used in `notes_241_300_wrist.md`: FCR, FCU and
  palmaris longus are the primary wrist flexors, the extrinsic finger flexors
  secondary ones; ECRL, ECRB and ECU the primary wrist extensors.
- **ACE #30** — ACE Exercise Library, Wrist Curl - Flexion, fetched: kneel
  and rest the elbows on a bench "with approximately a 90 degree bend at the
  elbows and the dumbbells hanging freely off the edge of the pad", palms
  up; lower slowly into extension "without releasing your grip, extending
  your arms or leaning forward / backward"; releasing the grip to let the
  dumbbells roll to the fingertips may add load but raises the risk of wrist
  injury and of dropping them; squeeze the weights as hard as possible in
  both phases.
- **ExRx** — ExRx.net Barbell Reverse Curl (Wayback copy, 2024, read):
  "Grasp bar with shoulder width overhand grip. With elbows to side, raise
  bar until forearms are vertical. Lower until arms are fully extended."
  Target brachioradialis; synergists brachialis, biceps brachii; stabilisers
  anterior deltoid, coracobrachialis, upper and middle trapezius, levator
  scapulae, wrist extensors. ExRx Dumbbell Wrist Curl (as in the 241-300
  wrist notes): target wrist flexors.
- **StrengthLog extensors** — How to Train Your Forearm Extensors, fetched:
  reverse curls use a pronated grip, "shifting some of the work away from
  your biceps and onto the brachioradialis", and "recruit your wrist
  extensors, especially the extensor carpi radialis longus/brevis, to
  stabilize things"; use less weight than a regular curl; the extensors
  "stabilize your wrist and give you a much stronger and more controlled
  grip". The page lists the reverse curl among its forearm-extensor
  exercises (the first in its extensor workout).
- **StrengthLog reverse curl** — Reverse Barbell Curl, fetched: overhand,
  hands about shoulder-width; keep the upper arm at the side (or slightly
  forward), not back. Lists the biceps as primary and the forearm flexors as
  secondary (see Uncertainties).
- **Model** — geometry measured on the USD (joint positions and angles, the
  EZ bar's grip sections, the pad and seat bounds, the dumbbells' centres).

**Where evidence is thin.** No EMG study of a standing EZ-bar reverse curl
measured the wrist extensors or the grip muscles, and none of a padded
dumbbell wrist curl was found. The activation fractions are estimates,
ranked to the model's highlight tiers where no source clearly contradicts
them (see each lift). Where each lift is heaviest comes from the models'
geometry, not from studies.

## Reverse Curl (reverseCurl)

**Model.**

- Standing tall: trunk upright (0° lean) and still, shoulders, neck and head
  still, knees 179°, ankles 0.28 m apart (about hip-width).
- An EZ bar (EX_48_EZ_Bar, 1.3 m, two plates a side) overhand. At the bottom
  the palms face back and the bar hangs in front of the thighs; at the top
  the palms face down and forward.
- Wrist joints 0.48 m apart, shoulder joints 0.39 m: about shoulder-width.
  The hands hold the bar's inner angled sections, which slant ~33° from the
  bar's line with the little-finger end forward (mesh slices: the bar runs
  from z 0.195 at x ±0.2 to z 0.26 at x ±0.3), so the palms are turned ~30°
  past fully palm-down (palm normal 0.61 outward in the brief). The copy says
  only "overhand on the EZ bar" and makes no claim that the angled grips ease
  the wrists (the Reverse Preacher Curl's model turns the palms the other
  way).
- Upper arms still for the whole clip: ~10° forward of the trunk, ~9° out,
  the elbows by the sides.
- Elbows 167° (arms almost straight) to 65°: the forearms go from hanging to
  ~35° above level, the bar from the thighs to lower-chest height ~33 cm in
  front, the wrists ending ~14 cm below the shoulders. ExRx's version goes
  to vertical forearms; the model stops ~55° short of that, so the copy
  never says how high to curl.
- Wrists straight (0°) all the way, knuckles in line with the forearms.
- Fingers closed round the bar, thumbs wrapped, never opening.
- A rep: ~1.3 s up, ~0.5 s near the top (65-68°), ~2 s down, no pause at
  the bottom; two reps in the 7.96 s clip.
- Tiers: bright brachioradialis, ECRL, ECRB, ECU, extensor digitorum, FCR,
  palmaris longus, FDS, FDP; dim biceps (both heads) and brachialis.

**Claims:**

- *Grip and Wrists: overhand, hands about shoulder-width, knuckles in line
  with the forearms.* Model; ExRx (shoulder-width overhand); StrengthLog
  reverse curl (about shoulder-width).
- *With the palms down, the bar tends to pull the knuckles toward the floor
  once the forearms tip forward, so the muscles on the back of the forearm
  work through the curl to hold the wrists straight.* Mechanics (the bar
  hangs from the palm side of a palm-down hand, so its weight tends to flex
  the wrist whenever the forearm is off vertical); StrengthLog extensors
  (reverse curls recruit the wrist extensors, especially ECRL/ECRB, to
  stabilise); ExRx (wrist extensors among the stabilisers); Snijders 1987
  (the grip's own flexing moment is balanced by the extensors); Mogk & Keir
  2003 (extensor activity greater with the forearm pronated); Coratella 2023
  Sports (the authors' suggestion, not measured).
- *A wrist bent down under the bar also weakens the grip.* Mogk & Keir 2003
  (flexed wrist, maximum grip force 40-50% lower).
- *Elbows by the sides; with the upper arms still, bending the elbows is the
  only way to raise the bar, so the brachioradialis and the other elbow
  flexors lift it; when the elbows drift forward the front deltoids join in.*
  Model (upper arms still); ExRx (elbows to side); StrengthLog reverse curl
  (keep the upper arm at the side); Coratella 2023 JFMK (arm flexion raised
  anterior deltoid excitation, a prime mover then; measured in palm-up
  curls, where it also raised biceps excitation and is offered as a
  variation, so the "mistake" framing is ExRx's and StrengthLog's). ExRx and
  StrengthLog allow a slight forward drift at the top, so the mistake is the
  elbows swinging forward, drawn as 35°.
- *Range: lower until the arms are almost straight; each rep starts with the
  bar at the thighs, so the elbow flexors work over nearly their whole range;
  full-range curl training has built more strength than mid-range partial
  reps.* Model (167° at the bottom); ExRx (lower until fully extended); Pinto
  2012 (preacher curls, untrained young men, 0-130° vs 50-100°: 1RM +25.7%
  vs +16.0%; thickness gains similar, so the copy claims strength only). The
  wording is the house one used on the other curls.
- *Lower over about two seconds, no bouncing.* Model (~2 s down, no pause).
- *Body Swing: an overhand grip is much weaker than an underhand one for
  bending the elbows, so a bar that is too heavy tends to get swung up with
  the hips and back.* Kohn 2018 (isometric, elbow at 110°, men without
  high-level upper-body strength training: 113.6 N vs 213.6 N, 53%, with
  voluntary activation 70.9% vs 93.0%, so no fixed ratio is claimed);
  StrengthLog extensors (use less
  weight than a regular curl). "Momentum does part of the work the arms
  should do" is mechanics.
- *Shoulder Position: with the palms down the front deltoids already work a
  little harder than in a palm-up curl, most likely to steady the shoulders.*
  Coratella 2023 Sports (anterior deltoid +6(3)% lifting, +5(4)% lowering,
  pronated vs supinated, on a 42.5 cm cable bar, not an EZ bar). "Most
  likely to steady the shoulders" is the authors' explanation, not a
  measurement ("requires different anterior deltoid interventions for
  stabilizing the humeral head").
- *Rolling the shoulders forward and up at the top adds a shrug, so the
  shoulders rather than the elbow flexors raise the last part of the lift.*
  Mechanics from the ghost's geometry (`reverseCurlShouldersRolled`: the
  shoulders, arms and bar 0.06 forward and 0.1 torso lengths up, ~4 and
  ~6 cm, at an unchanged elbow angle, so the extra height comes from the
  shoulder girdle, not the elbows). No muscle is named for the shrug, and
  the copy no longer says the front deltoids take over (rolling the
  shoulders up is scapular elevation, not the front deltoid's action). The
  model's shoulders never move.
- *Comparison, WRISTS BENDING DOWN.* The grip claims above.
- *Setup.* Model (overhand EZ bar, hip-width feet, arms almost straight at
  the thighs, elbows by the sides, wrists straight).

**Activation** (all estimates; ranks from the model's tiers, fractions from
the loaded EMG and the app's own curls):

| Row | Rank | Fraction | Basis |
| --- | --- | --- | --- |
| Brachioradialis | P | 0.56 MOD | Tier bright; library primary; ExRx target. Kleiber 2015 (unloaded): its share rises pronated; loaded EMG does not show its activation rising (Coratella 2023 Sports: 5% lower pronated than supinated; Boland 2008, J Hand Surg Am 33(10):1853-9, PMID 19084189: no difference across forearm positions); set as the Reverse Preacher Curl (0.56; the Barbell Curl has 0.52). |
| Wrist Extensors | P | 0.50 MOD | Tier bright (ECRL, ECRB, ECU, extensor digitorum). They hold the palm-down wrist straight through the curl (StrengthLog extensors; ExRx stabiliser; Mogk & Keir 2003). Primary follows the bright tier; ExRx and StrengthLog call them stabilisers in this lift, though StrengthLog lists the reverse curl among forearm-extensor exercises; no EMG of this lift, fraction is judgement (below the brachioradialis). |
| Forearm Flexors | P | 0.45 MOD | Tier bright (FCR, palmaris longus, FDS, FDP). The grip on the bar, isometric for the whole set (Snijders 1987). Kept moderate: a curl weight needs only part of the grip's strength. |
| Brachialis | S | 0.66 MOD | Tier dim; ExRx synergist. Date 2021: its activity pattern does not change with forearm position; Coratella 2023 Sports calls it the most powerful elbow flexor. Set as on the Barbell Curl (0.66). |
| Biceps Brachii | S | 0.68 MOD | Tier dim; ExRx synergist. Coratella 2023 Sports: supinated nRMS +19(7)% over pronated at 8-RM; Kohn 2018: a mechanical disadvantage in pronation. The Barbell Curl's 0.90 less that 19, held just under the HIGH cut-off because the row is secondary. |

The legend's primary line (BRACHIORADIALIS · WRIST EXTENSORS · FOREARM
FLEXORS, 51 characters) is cut to "... FOREARM…" by the one-line legend, as
52 existing three-name rows in the app are.

**Stabilisers.** Anterior deltoid (Coratella 2023 Sports; ExRx), upper
trapezius and levator scapulae (ExRx), which hold the shoulders under the
bar.

**Uncertainties.**

- The biceps and brachialis are secondary only because the model's tiers and
  ExRx's target/synergist split say so. StrengthLog's reverse-curl guide lists
  the biceps as primary, Coratella 2023 Sports still found biceps excitation
  with the pronated grip (supinated +19(7)% over it, no absolute level
  given), and the brachialis is the strongest elbow flexor whatever the grip.
  Neither measures the brachialis in a loaded reverse curl. See the open
  point below.
- The model grips the EZ bar's inner angled sections overhand, which turns
  the palms ~30° past fully palm-down; the Reverse Preacher Curl's model
  holds the sections that turn them ~23° in. The copy avoids any claim about
  the angled grips and the wrists.

**Labels** (from `preview_1_50.py` and overlays drawn on the stills). The
plates sweep both sides from y ~0.55 at the bottom to ~0.26 at the top, so
the labels sit above and below that band:

- Lower all the way (top-left, 0.16, pill x 0.035-0.347) on the far (right)
  wrist; its leader drops past the outside of the right deltoid and arm to
  the fist (the near wrist would need a top-right pill across the head).
- Shoulders back (top-right, 0.16) on the near (left) shoulder; the short
  label starts the pill at x 0.697, clear of the head (x ≤ 0.61) and of the
  near shoulder, which rises to (0.634, 0.176) in its own mistake view (the
  longer "Shoulders stay back" started at 0.624 and hid it).
- Elbows by your sides (left, 0.59, pill to x 0.391) on the far elbow and
  Wrists straight (right, 0.59, from x 0.682) on the near wrist: short
  leaders straight up. The row is ~0.02 below the plates' lowest point; the
  left pill's top corner meets the far thigh's edge (x 0.39) and the right
  pill's top-left corner overlaps the near thigh's outer edge (to x 0.70) by
  a few points, both static.
- No hip swing (left, 0.80) on the far hip (thigh_R); its leader crosses the
  right shin and thigh (static), like the Barbell Curl's torso leader.
- Checked against the ghosts: every fault was replayed with
  `FaultGhost.solve`'s maths on the rig and projected through the mistake
  view (the extra turn, the room scale and lift of `roomBelow` 0.26), over
  the whole clip at 1/16 s. The ghost is drawn above the callouts and only
  the mistake's own pill is shown, so each ghost was tested against its own
  pill. With the elbow pill at the top-left (the first layout) the
  `elbowsForward` ghost's hands and bar swept through it from ~0.75 s to
  ~2.4 s (34 samples); with the elbow and range rows swapped and the
  shoulder label shortened, no ghost segment and no joint of the lifter
  enters its own pill.

**Glows.** One activation glow on each forearm, centred between the elbow
and the wrist's mean position (both arms work and both are in view).

**Fault stills** (moments in `fault_moments_1_50_forearm.json`; kind `pull`,
top = elbows most bent, ~1.3-1.75 s):

| Cue | Moment | Ghost |
| --- | --- | --- |
| grip | top | hands turned 45° below the forearm line with the left elbow's bend (`curlWristsCurled(withBar: true, degrees: -45)`): at the top the palm point ends ~10° below level against the lifter's 35° above, ~9 cm lower; the bar with it. Seen from -0.9 (`.seen(-0.5)`), like the other four: in the framing's own view the hands point at the camera and drew as short stubs, the lowered bar along the real one (simulator QA below) |
| elbow | top | upper arms swung 35° forward (`elbowsForward(35, withBar: true)`), seen from -0.9 |
| range | bottom | elbows held ~45° bent at the bottom: the ghost at ~113-124° while the lifter reaches 167° (`curlBottomCut(from: 0.8, to: 0.89)`, shoulder to wrist 0.902 torso lengths at the bottom, 0.81 at 126°), seen from -0.9 |
| torso | top | hips 0.06 forward, trunk 15° back (`bodySwung(withBar: true)`), seen from -0.9 |
| shoulder | top | shoulders, arms and bar 0.06 forward and 0.1 up with the elbow bend (`reverseCurlShouldersRolled`), seen from -0.9 |

## Wrist Curl (wristCurl)

**Model.**

- Sitting on a stool (EX_49_Seat, top 0.49 m) in front of a padded forearm
  support (EX_49_ForearmSupport: top 0.775 m, 0.70 m wide, 0.27 m deep, on a
  post). Knees ~116° under the pad, hips ~87°, feet flat 0.44 m apart,
  trunk ~25° forward and still (a clear lean in over the pad in the
  stills, not "sitting tall"); shoulders, neck and head still.
- The stool and pad are fixed pieces: EX_49_Seat on EX_49_SeatPost with two
  floor bars (EX_49_SeatBase, EX_49_SeatBase_001), EX_49_SupportPost under
  EX_49_ForearmSupport; no pin, knob or collar among the equipment prims.
  So the copy says to choose a seat height, not to raise or lower one.
- A dumbbell in each hand, palms up, a full grip (fingers ~61° and ~66° at
  the first two joints, thumb wrapped) that never opens.
- Upper arms ~9° forward of vertical, elbows 95°, forearms lying level along
  the pad (rising ~4° toward the wrist). The elbow joints sit 4 cm in from the
  pad's back edge, the wrists 2 cm past its front edge, so the hands hang
  free. The forearms never move.
- Only the wrists move. Wrist-to-middle-knuckle line: ~35° below level
  (wrist ~39° extended) to ~30° above (~26° flexed); the palm point the
  ghosts use (0.2 torso lengths along the hand bone) runs from ~26° below
  level to ~39° above; the brief's bone-axis measure reads -30° to +35°. At
  the top the palms face up and back, toward the lifter.
- A rep: ~1.2 s up, ~0.5 s held at the top, ~2.1 s down, ~0.2 s at the
  bottom; two reps in the clip.
- The dumbbells' pull about the wrist (their centre's horizontal distance
  from the wrist joint; brief, hand z 0.49 throughout): dumbbell centre z
  0.58 at 0.0 s (wrist -30°), 0.58 at 0.5 s (-7°) and 3.0 s (-3°), 0.57 at
  2.5 s (+19°), 0.56 at 1.0 s (+28°), 0.55 at 1.5 s (+35°). So ~9 cm, flat,
  from the bottom until the hands pass level, easing to ~6 cm at the top.
- Tiers: all nine forearm muscles bright (brachioradialis, ECRL, ECRB, ECU,
  extensor digitorum, FCR, palmaris longus, FDS, FDP); nothing dim.

This is a different set-up from the library's Dumbbell Wrist Curl (forearms
on the thighs sloping 23° down, elbows ~64°, trunk 55° forward, hands
hanging to ~72° below level), so the copy is written for the pad.

**Claims:**

- *Forearms flat along the pad, elbows near its back edge; with them held
  there the wrists are the only joints free to move, so the forearm flexors
  lift the dumbbells; when the forearms lift, the elbows bend, the arms help
  and the wrists do less.* Model; ACE #30 (elbows on the bench, no extending
  the arms); ExRx (target wrist flexors, no synergists). The rest is
  mechanics; the copy says the wrists do less, not nothing.
- *Wrists just past the front edge of the pad so the hands hang free; with
  the wrists back on the pad, the backs of the hands come down on its edge
  at the bottom, and it stops them tipping any lower.* Model (2 cm past the
  edge); ACE #30 (dumbbells hanging freely off the edge of the pad). The
  rest is geometry, no study, and it is worded to what the ghost shows:
  `wristPadForearmsBack` slides the forearms back ~10 cm (wrists ~8 cm in
  from the edge) and keeps the lifter's hand angle, so at the bottom the
  hand line passes only ~1.5 cm over the pad's front corner, less than the
  depth of the back of the hand: the hands land on the edge at full depth.
  The copy no longer says the bottom of the rep is lost.
- *Range: lower until the hands tip well below the forearms, then curl up
  until the palms turn toward you.* Model (hands ~35° below level; palms
  facing up and back at the top). The copy avoids "as far as they go": the
  model's top is only ~26-35° of flexion.
- *In this set-up the dumbbells pull hardest over the lower half of the
  rep, from the bottom until the hands pass level, and ease off near the
  top, so reps that stop with the hands about level leave out much of that
  hardest stretch.* Model (lever ~9 cm, flat, from the bottom, -30°, to
  level; ~8 cm at +19°, ~7 cm at +28°, ~6 cm at the top, +35°). A rep that
  stops at level still meets the same peak pull there; it leaves out the
  part of the arc under it (bottom to level), not a heavier one, so the copy
  no longer says it skips "the heaviest part". Unlike the thigh-supported
  wrist curls, whose hands hang steeply and are lightest at the bottom, this
  model's hands tip only ~35° below level.
- *Lower slowly, over about two seconds, the fingers still wrapped round the
  handles, then curl up and hold a moment.* Model (~2.1 s down, ~0.5 s
  hold); ACE #30 (lower slowly, do not release the grip: rolling the
  dumbbells to the fingertips raises the risk of wrist injury and of
  dropping them).
- *Body Position: lean in over the pad, body still; rocking the shoulders
  back swings the dumbbells up with the body and pulls the forearms off the
  pad.* ACE #30 (no leaning forward or backward during the rep); model (25°
  forward lean held still, hips 87°; "slightly" and "sit tall" were dropped
  because the lean is clear in the stills).
- *Seat Height: sit at a height where the forearms lie level on the pad,
  the upper arms hanging almost straight down and the elbows bent about
  90°, the shoulders relaxed; choose a seat height that gives that.* Model
  (upper arms ~9° from vertical, elbows 95°, forearms level; a fixed stool,
  so "choose", not "raise or lower"); ACE #30 (about 90° at the elbows);
  Ikeda 2025 set-up (seated, forearms resting on the support, chair height
  adjusted so the shoulders were not elevated, elbow at 90°: a lab protocol,
  not a training outcome, but the same set-up).
- *With the seat too low, the pad sits high and the shoulders tend to hunch
  up to get the forearms onto it.* Reasoning from the geometry, worded as a
  tendency; the preacher benches' seat cue makes the same argument (ExRx
  preacher curls: seat set so the armpit rests near the top of the pad). No
  source names it for this station; Ikeda's chair adjustment only shows that
  shoulder elevation is what the height is set against.
- *Comparison, FOREARMS OFF THE PAD.* The Forearm Support claims.
- *Setup.* Model (a seat that puts the elbows at ~90° with the forearms
  level, feet flat, knees under the pad, the 25° lean in over it, palms up,
  wrists just past the edge); ACE #30.

**Activation** (estimates):

| Row | Rank | Fraction | Basis |
| --- | --- | --- | --- |
| Wrist Flexors | P | 0.86 HIGH | Tier bright (FCR, palmaris longus); Neumann; ExRx target. Ikeda 2025: FCR is most active in wrist flexion with the forearm supinated, as here (93.1 %MVE at 75% effort, against 57.8 pronated). Same value as the Dumbbell Wrist Curl. |
| Finger Flexors | P | 0.55 MOD | Tier bright (FDS, FDP): they hold the closed grip and also flex the wrist (Neumann). Primary to match the tier (the Dumbbell Wrist Curl has them secondary at the same level). |

**Tier disagreements (flagged, not followed):**

- The model paints the wrist extensors (ECRL, ECRB, ECU, extensor digitorum)
  bright. They are listed as a stabiliser instead: in palms-up wrist flexion
  Ikeda 2025 measured extensor co-activation at ~14% (ECRB) and ~16% (ECU)
  MVE against FCR 93.1 and FCU 73.1 (Table 3, 75% of maximum flexion
  torque), in a set-up that closely matches this model's (seated, forearm on
  a support, elbow at 90°, supinated); ACE and ExRx give the wrist flexors as
  the target. They steady the grip (Snijders 1987; StrengthLog extensors).
- The model paints the brachioradialis bright. It is left out: it inserts on
  the radial styloid and flexes the elbow (Coratella 2023 Sports), does not
  cross the wrist, and the elbows rest still on the pad; Boland 2008 (J Hand
  Surg Am 33(10):1853-9, PMID 19084189) describes its primary function as an
  elbow stabiliser in flexion tasks. This rests on anatomy and that role; no
  EMG of the brachioradialis in a wrist curl was found.
- So the legend (WRIST FLEXORS · FINGER FLEXORS) does not name all of the
  bright paint. This is a decision for the user (see the open points), not
  settled here.

**Stabilisers.** Wrist extensors (above); thumb flexors (the thumbs wrap the
handles).

**Labels** (overlays on the stills). The dumbbells span the middle of the
frame (x 0.05-0.63, y 0.35-0.47) and the head sits at x 0.38-0.51, y
0.15-0.26, so:

- Wrists off the pad (top-left, 0.16, override 0.14 like every other row,
  pill x 0.035-0.362) on the far wrist. The head's left edge on the stills
  is at x 0.404 at y 0.16, 0.389 at 0.17 and 0.379 at 0.18, so the pill's
  foot (y 0.182) clears it by ~0.016; the earlier "Wrists clear the pad"
  (20 characters, to x 0.391) needed the out-of-contract row 0.11. Its
  leader passes left of the head and ends on the far dumbbell's inner plate,
  where the far wrist sits.
- Let wrists bend back (top-right, 0.16) on the near wrist; the pill starts
  at x 0.609, and the leader runs right of the head (~0.04 clear) down the
  near shoulder to the near wrist, just left of the near dumbbell's outer
  plate. The long form started at 0.55 and grazed the head.
- No rocking (right, 0.32) on the near shoulder blade, right of the back.
- Forearms on pad (right, 0.43) on the near elbow, at the pad's back end; a
  ~27 px leader.
- Sit high enough (right, 0.69) on the near hip, below the stool and right
  of its post (x 0.58-0.64), above the floor bar; same length as the
  earlier "Seat height set", which suggested an adjustable seat.
- The far wrist dot sits on the far dumbbell's inner plate (u 0.218 against
  the plate's 0.206-0.262); the near one beside the near dumbbell's outer
  plate (u 0.490 against 0.500-0.564; its inner plates are at 0.345-0.405).
  The fists show between the plates. No other probed joint marks the
  hands.
- Checked against the ghosts in each mistake view (as for the Reverse
  Curl): no ghost segment and no joint of the lifter enters its own pill.

**Glows.** The near forearm (full) and the far forearm (soft), centred
between elbow and wrist, flat ellipses along the pad.

**Fault stills** (kind `wrist`: top = most flexed, ~1.25-1.75 s; bottom =
most extended, 0.0 s):

| Cue | Moment | Ghost |
| --- | --- | --- |
| forearm | top | forearms turned up 20° about the elbows, wrists ~8 cm higher, on `wristPadTop` (fades in once the knuckles pass level, full from the palm point ~30° above) |
| position | bottom | elbows, wrists and hands slid ~10 cm back along the pad (`wristPadForearmsBack`), the wrists ~8 cm in from the edge; seen from -1.0 |
| range | bottom | hands turned 35° up on `wristPadBottomShort`: held with the knuckles about level (palm point 8-8.4° above) until the lifter's hands reach level |
| torso | top | trunk rocked back 12° from the hips (25° to 13° forward), the arms carried off the pad, on `wristPadTop`; seen from -1.0 |
| seat | any | `preacherSatLow`: the body sinks 0.2 torso lengths (~12 cm) while the arms stay on the pad, the neck dropping below the shoulder line; always shown |

The ramps were checked by replaying `FaultGhost.solve`'s maths on the rig
(palm point to left knee over the rep: 0.630 at the bottom, 0.717 with the
palm point level, 0.742 with the knuckles level, 0.805 at the top).

## Open points (for the integrator to put to the user)

- **Reverse Curl: tiers against the loaded EMG.** The ranks follow the
  model's tiers (brachioradialis, wrist extensors and forearm flexors
  bright, so primary; biceps and brachialis dim, so secondary). With the
  fractions set from the loaded EMG, the secondary biceps (0.68) and
  brachialis (0.66) sit above every primary row (brachioradialis 0.56, wrist
  extensors 0.50, forearm flexors 0.45). The tiers disagree with the loaded
  EMG: a palm-down grip does not raise brachioradialis activation
  (Coratella 2023 Sports; Boland 2008), the biceps still works hard, and
  StrengthLog lists the biceps as primary. The user chose the tiers; ask
  whether to re-tier the model (biceps and brachialis bright) or keep the
  legend as it is.
- **Reverse Curl: wrist extensors primary.** It follows the bright tier;
  ExRx and StrengthLog call them stabilisers in this lift, though
  StrengthLog lists the reverse curl among forearm-extensor exercises; no
  EMG of this lift, so the fraction (0.50) is judgement.
- **Wrist Curl: legend against the bright paint.** All nine forearm muscles
  are bright; the rows name only the wrist and finger flexors, the wrist
  extensors are a stabiliser and the brachioradialis is left out (Ikeda
  2025, in a matching set-up; anatomy and Boland 2008 for the
  brachioradialis). Ask the user whether to re-tier the model (extensors
  and brachioradialis dim or unlit) or follow the tiers: a primary Wrist
  Extensors row at a LOW fraction (~0.15-0.25, from Ikeda's co-activation)
  and, for the brachioradialis, either a row with a stated basis or the
  user's agreement to leave it out.

## Review changes (2026-09-30)

Two reviews were checked against the sources, the briefs, the stills, the
rig and a replay of every ghost; all their findings held and were applied,
one in a different form:

- Reverse Curl fractions reset from the loaded EMG (above); the shoulder
  cue's why no longer says the front deltoids take the lift (a shrug, from
  the ghost's geometry, and the stabilising reason marked as the authors');
  Kohn 2018 worded as "much weaker"; Pinto 2012 as mid-range partials; the
  Coratella figures corrected (neutral > supinated by 9%, biceps +19%
  supinated over pronated, no absolute level); the JFMK framing noted.
- Reverse Curl labels: the elbow and range rows swapped so the
  `elbowsForward` ghost no longer sweeps through its own pill. For the
  shoulder pill the review proposed moving it to the top-left on the far
  shoulder (with range top-right, grip and elbow swapped sides); the
  replay showed that layout still let the shoulder ghost's bar touch its
  pill's corner (10 samples), while keeping the pill top-right with the
  shorter "Shoulders back" clears both the ghost and the rising near
  shoulder (0 samples), so the shorter label was used instead.
- Wrist Curl: range why matched to the flat ~9 cm lever; the seat worded
  for a fixed stool, with the too-low consequence as a tendency and the
  Ikeda set-up added; the position copy matched to the ghost (the hands
  come down on the pad's edge); the 25° lean named in the setup and the
  torso cue; the position label moved into the row contract (0.16) with a
  shorter label; the wrist-dot note corrected.
- Final check: every source re-checked against its abstract or full text
  (Coratella 2023 Sports and JFMK, Boland 2008, Kleiber 2015, Kohn 2018,
  Date 2021, Pinto 2012, Mogk & Keir 2003, Snijders 1987, Ikeda 2025, ACE
  #30, both StrengthLog pages). Kohn's elbow angle now reads 110° with 180°
  straight (70° of flexion, not 110°), and Ikeda's flexion is held at 75% of
  the maximum torque measured in neutral. The range ghost's comment now gives
  the rig's 0.90 torso lengths shoulder to wrist at the bottom (0.902).

## Simulator QA (2026-09-30)

The integrated content was shot on the simulator (trainer at 0, 1 and 3 s;
each ghost held at its fault moment) and every still was checked for pills,
leaders, cropping, ghost legibility and copy.

- Reverse Curl grip ghost: in the framing's own view (yaw -0.4) the
  forearms and hands point at the camera at the top, so the ghost hands
  were drawn ~11-13 pt long and the lowered bar lay along the middle of the
  real EZ bar, reading as a highlight on it rather than a bar dropped under
  the hands. Now seen from -0.9 (`.seen(-0.5)`, as the other four Reverse
  Curl faults; the Dumbbell Curl's grip and the Biceps Curl's wrist ghosts
  are turned off their face-on framing too):
  replaying `FaultGhost.solve`'s maths on the rig (checked against the
  simulator's elbow and grip stills, where the replay lies on the drawn
  ghost), each hand is ~24 pt long, bent ~50° below its forearm on screen,
  and the bar ~22 pt under the real one; over the whole clip at 1/16 s no
  ghost segment and no joint of the lifter enters the Wrists straight pill.
- Wrist Curl seat: in the mistake view (the model shrunk and lifted for the
  sheet) the Sit high enough pill's top-left corner overlaps the underside
  of the near floor bar by a few points; static equipment, and no row
  inside the 0.16-0.80 contract clears both the floor bar in the trainer
  view and in the mistake view by more than a point or two, so it stays.
- Everything else read as intended: no dot on a pill's text, no pill under
  the eye button or off-screen, nothing cropped, and each ghost draws its
  sheet's mistake at a moment where it is fully shown (strength 1.0 at every
  still).
- Second look at the same stills (2026-09-30): the findings above stand.
  The stills predate the grip ghost's `.seen(-0.5)`, and the repo's
  FaultPoses.swift still held the grip ghost without it until
  integrate_1_50.py is re-run, so `reverse-curl--grip` wants a re-shoot
  after that run. In the trainer view the Forearms on pad pill's rounded
  lower-left corner meets the pad's top-right corner (a pixel or two, static
  equipment), so it stays. The Wrist Curl position and range ghosts are
  small on screen (the hand tips ~25 and ~20 pt from the lifter's) but read
  through the dashed guides, each in the direction its sheet describes.
