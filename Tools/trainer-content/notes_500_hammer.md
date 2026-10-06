# 401-500 folder: hammer, Zottman and reverse curls, wrist roller (2026-10-04)

Six exercises from the builder's 246-275 set: 246 Rope Hammer Curl, 248 Cross-Body Hammer Curl,
249 Incline Hammer Curl, 251 Zottman Curl, 262 Dumbbell Reverse Curl and 275 Wrist Roller
(models `Biceps/<Name>.usdc`, `Forearms/WristRoller.usdc`). `spec_500_hammer.py` holds the copy
and setup steps (its header lists what each model shows and the full citations),
`Tools/fault-review/faults_500_hammer.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_500_hammer.json` the moment each ghost is stilled. This file
maps the copy's claims to their sources and records the model facts the copy relies on.

## How the models were read

- The motion briefs (`SCRATCH/briefs/<Resource>.md`: elbow, shoulder, wrist, palm every 0.5 s),
  the trainer stills at 0/1/2/3/5 s, `tiers30.json` and `joints.json`.
- The rigs and equipment straight from the USD with Blender's Python + pxr
  (`SCRATCH/hammer/rig.py` helpers): `sample.py` (elbow angle, forearm turn and palm normal every
  1/8 s; the palm is the hand joint's +z, which matches the brief's palm words), `arm.py`
  (upper-arm angle forward/out, elbow and hand positions, trunk lean), `dist.py` (shoulder-wrist
  distances for the range ghosts), `rope.py` / `rope2.py` / `rope3.py` (pulley, cable exit,
  rope swivel and grip sleeves, the stack plates; the rope's moment about the elbow), `incl.py`
  (bench pad slope, trunk and arm angles, dumbbell bounds), `roller.py` (the roller's
  animated rotateX, spool size, the cord's top end against the spool, the plate's height).
- Labels: `preview_500.py hammer` plus `SCRATCH/hammer/overlay.py`, which draws the pills
  (~24 + 6.4 pt per character, 28 pt tall, the app's 8 pt edge clamp), leaders and dots over the
  stills, with the eye button and legend boxed.
- Ghosts: a Python port of `FaultGhost.solve` and `BodyFrame` (`SCRATCH/hammer/ghost.py`,
  pieces in `pieces.py` / `plan.py`), run on the real joint transforms at each fault's moment
  and projected with the framing, the fault's `view` and the mistake view's scale (0.935) and
  lift (`gdraw.py`, `sheet.py` draw them as stick figures). The sizes in the table comments come
  from it.

## Shared facts

- One body (torso, neck to pelvis, 0.592 m). Every clip is 7.96 s. The four curls with a
  rep of 4 s are still to ~0.25-0.4 s, up ~0.9-1.1 s, held ~0.6 s at the top, down ~1.25-1.5 s,
  still at the bottom.
- Highlight tiers (`tiers30.json`): on the rope, cross-body, incline, Zottman and dumbbell
  reverse curls the biceps (both heads), brachialis, brachioradialis, FCR, palmaris longus, FDS,
  FDP, ECRL, ECRB, ECU and extensor digitorum are all bright, nothing dim -> every row PRIMARY.
  The wrist and finger flexors and extensors share one "Forearms" row, as the library's Dumbbell
  Curl, Incline Dumbbell Curl and the 1-50 curls group them (the legend is one line;
  `part_of("Forearms")` = forearms). Wrist Roller: brachioradialis and the same eight forearm
  muscles bright -> "Wrist Flexors", "Wrist Extensors", "Brachioradialis" PRIMARY (the target
  gets its own rows, as on the library's wrist curls); biceps (both heads) and DeltoidAnterior
  dim -> "Anterior Deltoid", "Biceps Brachii" SECONDARY. All names pass `part_of()`.
- Legend length: four primary rows run to 52-56 characters ("BRACHIALIS · BICEPS BRACHII ·
  BRACHIORADIALIS · FOREARMS"), longer than the ~45 that fit beside "PRIMARY" at 9.5 pt mono;
  the line truncates at its end, which is why Forearms (the lowest share) is listed last on the
  hammer curls. The library has longer lines (Pendlay Row 56, Plate Pinch Hold 84).
- No EMG study of any of the six lifts was found (Europe PMC, 2026-10-04: "hammer curl" 54 hits,
  none an EMG of these variants (one exoskeleton study of a standard hammer curl); "zottman" 4,
  none about the curl; "wrist roller" 12, none measuring it). The two small standard-hammer-curl
  EMG papers noted for the library's hammer curls (Jahizi 2023, AIP Conf Proc; Bagchi and Raizada
  2019) are not indexed there and are not used. Every fraction is
  a judgement call anchored to the library's nearest lift and to the grip comparisons below; the
  reasoning is in a code comment at each activation list.
- Grip comparisons used throughout: Coratella 2023 Sports (cable curls at 8RM, the neutral grip
  done with a rope: lifting-phase biceps +12% supinated vs neutral, +19% vs pronated, neutral +7%
  vs pronated; brachioradialis +5-6% supinated vs both; anterior deltoid +6% pronated, +9%
  neutral vs supinated; lowering phase: no grip difference for biceps or brachioradialis,
  anterior deltoid +5% pronated; full text read). Kohn 2018 (isometric MVC 213.6 N supinated,
  243.6 N neutral, 113.6 N pronated, so pronated is about half; abstract). Kleiber 2015
  (brachioradialis share larger only pronated; biceps unchanged; abstract). Boland 2008
  (brachioradialis activation the same across forearm positions; abstract). The copy's "the
  brachialis bends the elbow whatever the grip" rests on Coratella 2023's discussion (the
  brachialis does not insert on the radius and takes no part in supination), as in the
  library's hammer curls.
- Range: "full-range curl training has built more strength than mid-range partial reps" = Pinto
  2012 (10 weeks, 40 young men new to training, bilateral preacher curls 0-130° vs 50-100°: 1RM
  +25.7% vs +16.0%; thickness rose in both, so no muscle claim; "mid-range" because the partial
  group trained 50-100°, as the library words it). StrengthLog Hammer Curl lists half reps among
  the mistakes. On the rope curl the start of the rep is barely loaded (below), the case where
  the 1-50 Cable Curl dropped Pinto; it is kept here as on the library's Cable Hammer Curl,
  whose geometry is the same, because the half rep it warns against turns round at ~107°, inside
  the loaded part, and Pinto's partial group also stopped short of the bottom.
- Elbows forward bring in the front deltoids: StrengthLog Hammer Curl ("If your elbows move
  forward ... additional load on your front delts"), Coratella 2023 JFMK (flexing the arms raised
  anterior deltoid excitation), ExRx (the elbows may travel forward only slightly at full
  flexion).
- Swinging: StrengthLog Hammer Curl (brace the core so the body does not swing; swinging means
  too much weight); Coratella 2023 Sports' protocol (no sagittal trunk oscillation).
- Wrists: "a bent wrist grips far more weakly" = Mogk & Keir 2003 (a flexed wrist cut maximum
  grip force by 40-50%). "Curling the wrists in moves the weight with the wrists instead of the
  elbows" is the library's wording for the same fault (StrengthLog Dumbbell Curl: keep the
  wrists straight). Palms down, the muscles on the back of the forearm hold the wrist: StrengthLog
  forearm extensors (reverse curls "recruit your wrist extensors ... to stabilize"), Coratella
  2023 Sports' discussion (the pronated grip needs wrist stabilisation toward extension),
  Snijders 1987 and Mogk & Keir 2003 (extensors balance every grip, more so pronated).

## Rope Hammer Curl

Model facts: one low pulley (exit ~12 cm up) on the midline ~0.6 m in front of the pelvis, ~0.4 m
ahead of the toes; the lifter faces it, feet ~0.30 m apart, knees 167°, trunk 8° back (the neck
8 cm behind the pelvis) and still. A rope: each end gripped just under its knob, palms facing
each other (palm normals within ~30° of ±x, tipped back toward the body), wrists straight. Both elbows 152° -> 54°; the upper
arms ~5° forward of the trunk line (12° in the room, the trunk leaning back), moving under 2 cm.
The hands stay ~0.3 m apart. Stack plates 12-14 sit 6 cm above plate 11 at the bottom and rise
~0.48 m. The rope's swivel hangs 0.44 m up at the bottom, 0.92 m at the top; the cable runs from
it to the pulley 13-21° off vertical. The share of the rope's pull that turns the elbow (its
moment about the elbow per unit pull and forearm length, from the grip sleeve toward the swivel):
0.10 at 152°, 0.21 at 147°, 0.66 at 125°, 0.90 at 105°, 0.96 at 92° and 79°, 0.89 at 64°, 0.82
at the top; a weight hanging from the hands in the same poses: 0.60, 0.66, 0.90, 0.99, 0.98,
0.91, 0.76, 0.64.

| Claim | Source |
|---|---|
| Upper arms by the sides, only the forearms move; elbows forward bring in the front deltoids, a front raise | StrengthLog Hammer Curl and Cable Curl With Rope (upper arm still or slightly forward); ExRx Cable Hammer Curl (elbows to the sides); Coratella 2023 JFMK; the model |
| Curl until the knobs come up toward the chin | The model (grip stops at 1.44-1.52 m at the top, the shoulder joints 1.42 m) |
| Each rep starts with the elbows only slightly bent | The model (152°). ExRx returns to fully extended arms; the copy follows the model |
| The rope runs almost along the forearms at the bottom, barely resisting the start; hardest from halfway up to the top | The model's geometry above (0.10 vs 0.60 at the bottom; 0.9-0.96 from ~105° to ~80°) |
| Lowering to a slight bend still takes the elbows through most of their range | The model (152° -> 54°, 98° of travel); Pinto 2012 for the full-range strength claim |
| The stack still just off its rest at the bottom | The model (6 cm gap) |
| Palms face each other, thumbs up under the knobs | ExRx (grasp the rope with the palms facing inward); StrengthLog Cable Curl With Rope (neutral grip); the model |
| In a cable study with this rope grip the biceps worked a little less than palms up | Coratella 2023 Sports (rope for the neutral grip, -12% vs supinated lifting) |
| Each rope end pulls its hand down toward the cable; letting it tip the hands down toward the little fingers is the mistake | The model (grip-to-swivel direction ~(-0.28, -0.83, +0.45) for the left hand at the bottom, ~(-0.33, -0.86, +0.40) at the top: mostly down); the library's Preacher Hammer Curl grip fault (the hand tipping toward the little finger) |
| A slight lean back, held still; a steady base against the cable's pull toward the stack | The model (8° back all clip; the pull at the hands runs down and forward toward the pulley); StrengthLog Hammer Curl (brace, no swing). The lean as a counter to the forward pull is reasoning from the geometry, not a source |
| Rocking back borrows momentum from the hips and lower back | StrengthLog Hammer Curl (swinging = momentum, too much weight) |
| With a neutral grip the front deltoids already work a little harder, most likely to steady the shoulders | Coratella 2023 Sports (anterior deltoid +9% neutral vs supinated; "different anterior deltoid interventions for stabilizing the humeral head") |
| Rolling the shoulders forward and up adds a shrug | The library's Reverse Curl shoulder cue (NSCA manual: no rolling the shoulders forward) |
| Setup: clip a rope to the low pulley, face the stack, step back until taut, hip-width | ExRx; StrengthLog Cable Curl With Rope (a step back); the model (feet 0.30 m apart, the cable taut) |

Activation: Brachialis 0.76, Biceps 0.74, Brachioradialis 0.42 as the Cable Hammer Curl
(Coratella's rope grip: biceps -12%, brachioradialis -6% vs palms up); Forearms 0.30 as the
library's curls. Stabilisers from ExRx: anterior deltoid, upper trapezius, levator scapulae;
core (StrengthLog: brace).

## Cross-Body Hammer Curl

Model facts: standing tall, feet ~0.30 m apart, knees 174°, trunk upright (lean 0.4°) and
still. Dumbbells palms in, handles front to back; the arms hang ~14° out, elbows 170°. LEFT arm
0-4 s (still to 0.38 s, up to 1.38 s, held to 2.0 s, down to 3.5 s), the right 4-8 s; the
resting arm never moves. The working elbow 170° -> 72°; its upper arm from 2° to 32° forward and
from 14° to 6° out (the elbow 14 cm forward, 4.5 cm in, 3.5 cm up), most of it by 1.0 s. At the
top the hand is 15 cm in from its own shoulder (x 0.044 vs 0.196), 10 cm below it and 26 cm in
front; the dumbbell's centre at x -0.01, 1.37 m up (shoulders 1.43 m), 0.29 m in front. Palm
facing the chest at the top (normal right-back for the left hand), thumb up; wrists straight.

| Claim | Source |
|---|---|
| Up and across toward the other shoulder; one arm then the other | Bodybuilding.com Cross-body hammer curl (Wayback 2024-01-19: palms in, without twisting, curl toward the opposite shoulder, lower along the same path, alternate); Jefit and Fitbod say the same; the model |
| Finishing in front of the middle of the chest, a little below shoulder height | The model (dumbbell centre on the midline, 6 cm below shoulder height). Bodybuilding.com and Jefit touch the dumbbell to the opposite shoulder; the copy follows the model |
| The elbow comes forward and in as the forearm crosses; lifting it higher makes a front raise | The model (30° forward, 14 cm); StrengthLog Hammer Curl (elbows forward load the front delts); Coratella 2023 JFMK. StrengthLog's hammer curl keeps the upper arms at the sides or slightly forward and ExRx lets the elbows travel forward slightly at the top (Jefit and Bodybuilding.com say nothing about the elbow); the model's comes ~30° forward with the crossing, so the copy asks only that it stay low |
| Neutral grip: brachialis any grip, biceps a little less than palm up | Coratella 2023 Sports; see Shared |
| At the top the palm faces the chest; curling the wrist in moves the weight with the wrist | The model; the library's wrist wording (StrengthLog Dumbbell Curl) |
| Lower to an almost straight arm before the other arm starts | The model (170°); ExRx Dumbbell Hammer Curl (lower to the original position, alternate); Pinto 2012 |
| Shoulders square; twisting, the working shoulder swinging forward, throws the dumbbell across with momentum | StrengthLog Hammer Curl (only the arms move; swinging = momentum). The twist as this lift's form of the swing is a judgement: reaching across the body is what invites it. The working (left) shoulder comes forward as the left dumbbell crosses, as the ghost shows (the first draft said the trunk turns toward the working side, the wrong way) |

Activation: as the Alternating Hammer Curl (0.76 / 0.74 / 0.44) plus Forearms 0.30. Stabilisers
from ExRx Dumbbell Hammer Curl: anterior deltoid, upper and middle trapezius; core.

## Incline Hammer Curl

Model facts: back pad sloping ~52° from the floor (its long axis), seat level; trunk 42° back
from vertical, hip 162°, knees 137°, feet flat in front. Dumbbells palms in throughout (normals
within ~20° of ±x). The upper arms hang vertical, 8° out, so they sit 42° behind the trunk line;
they move ~3 cm (6° forward at the top). Elbows 170° -> 55°, both together; at the top the hands
are ~11 cm below and ~21 cm in front of the shoulders. Still to 0.4 s, up to 1.5 s, held to
2.1 s, down to ~3.6 s.

| Claim | Source |
|---|---|
| Bench at about 50°, back on the pad | The model (~52°); ExRx Dumbbell Incline Curl (45-60 degree incline bench) |
| The arms behind the body stretch the long head, which starts above the shoulder joint | StrengthLog Incline Dumbbell Curl; Oliveira 2009 ("The shoulder hyperextension, elicited by the IDC protocol, stretches the long head of biceps brachii"; their incline had the trunk 50° back, close to this model's 42°) |
| Sitting up turns it into a seated hammer curl | The library's incline wording; the geometry (arms in line with the trunk) |
| Upper arms hang straight down; elbows forward give up the position and bring in the front deltoids | ExRx (arms hanging down straight; elbows back to the sides); StrengthLog (arms hang straight down); Coratella 2023 JFMK; the model |
| Palms in all the way makes it the hammer version; ExRx's incline curl turns the palm up | ExRx Dumbbell Incline Curl (starts palms in, rotates up); the model (never turns) |
| The bottom is where the long head is longest and the dumbbells pull least, easy to cut short | Oliveira 2009 (shoulder hyperextension stretches the long head); the dumbbell's lever about the elbow is shortest with the forearm hanging (geometry, as the library's incline curl) |
| Shoulders back on the pad; rolling them forward carries the arms forward | The library's incline cue; the model |

Kassiano 2025 (incline curls grew the proximal elbow flexors more than preacher curls) was read
but is not used in the copy: it trained a palms-up incline curl.

Activation: as the library's hammer curls; Oliveira 2009 found incline and standing dumbbell
curls alike for biceps activation, so the incline is not scored higher. Stabiliser from ExRx:
anterior deltoid.

## Zottman Curl

Model facts: standing tall, trunk upright, feet ~0.30 m apart. Dumbbells handles side to side;
arms hang ~17° out, elbows 170°, palms forward (forearm turn ~11° from fully palm up). Curl
0.25-1.12 s palms up (turn 0-12°), elbows 170° -> 52°, the upper arms coming in to ~5° out and
ending ~12° forward. 1.25-1.75 s at the top: the forearms turn to palms down (turn 169-172°)
while the elbows open to ~59-60°. 2.0-3.25 s lowered palms down (turn 172-178°) to 167-170°.
3.5-3.9 s at the bottom: turned back to palms forward. Wrists straight throughout.

| Claim | Source |
|---|---|
| Palms up on the way up, turned down at the top, lowered palms down, turned forward at the bottom | StrengthLog Zottman Curl; Catalyst Athletics Zottman Curl; the model (timings above) |
| In one study the biceps worked hardest lifting with the palms up | Coratella 2023 Sports (biceps +12% / +19% supinated in the lifting phase) |
| The elbow flexors are much weaker with the palms down | Kohn 2018 (isometric MVC 113.6 N pronated vs 213.6 N supinated, 243.6 N neutral: about half, in one isometric test of 11 men, so worded "much weaker" as on the library's Reverse Curl) |
| Curling palms up and lowering palms down lets you lower more weight in the reverse-curl grip than you could lift in it, which is where the extra forearm work comes from | Catalyst Athletics (reverse curls tend to be weaker than supinated, so by lifting supinated and lowering pronated heavier weights can be used; the Zottman trains more aspects of the biceps and forearm); StrengthLog Zottman (lower slowly with the reverse grip; combines a biceps curl with a reverse curl, strengthening both the biceps and forearms). The first draft said the lowering was a slow, hard lowering for the forearms; reworded to Catalyst's claim |
| Lower slowly | The model (down ~1.25 s vs up ~0.9 s); StrengthLog; Catalyst (under control) |
| Elbows by your sides through the curl, the turn and the lowering | The model (upper arms within ~12° of the trunk); see Shared |
| Palms down the dumbbells pull the hands toward the floor; the back of the forearm holds the wrist | See Shared (wrists) |
| Lower until almost straight, then turn the palms | The model (the turn happens at 167-170°); Pinto 2012 |
| No body swing | See Shared |

Activation: Biceps 0.86 and Brachialis 0.66 as the library's Dumbbell Curl (the lifting phase is
the same grip; Coratella found no grip difference lowering); Brachioradialis 0.50 between the
Dumbbell Curl (0.44) and Reverse Curl (0.56) (Kleiber 2015: larger share pronated); Forearms
0.40, above the curls' 0.30 for the palms-down lowering (Coratella's discussion; Mogk & Keir
2003). Stabilisers: anterior deltoid, upper trapezius (ExRx's curl stabilisers); pronator teres
and supinator turn the forearm over and back (StrengthLog, The 10 Best Forearm Exercises: the
pronator teres and quadratus turn the palm down, the supinator up); they are listed because the turn is the lift's defining
move and they are not painted.

## Dumbbell Reverse Curl

Model facts: standing tall, trunk upright, feet ~0.30 m apart. Dumbbells overhand, handles side
to side, hands 0.44 m apart (shoulder joints 0.39 m): palms back with the dumbbells at the thighs,
down at the top; wrists straight. Upper arms 14° forward of vertical, 3-4° out, 16° at the top;
elbows 166° -> 56°; the dumbbells finish ~9 cm below and ~24 cm in front of the shoulders. Up
0.4-1.4 s, held to 2.0 s, down 2.0-3.5 s.

| Claim | Source |
|---|---|
| Palms down, wrists straight; the dumbbells pull the knuckles down, the back of the forearm holds them | See Shared (wrists); ExRx Barbell Reverse Curl (wrist extensors among the stabilisers) |
| Overhand, handles level, hands about shoulder-width | ExRx (shoulder width overhand grip); StrengthLog Reverse Dumbbell Curl (overhand); the model |
| Elbows by the sides; only the forearms move; elbows forward bring in the front deltoids | ExRx (elbows to the sides); StrengthLog Reverse Dumbbell Curl (upper arms at the sides or slightly forward); Coratella 2023 JFMK |
| Lower until almost straight, over about a second and a half | The model (166°; down 2.0-3.5 s); ExRx (lower until fully extended); Pinto 2012 |
| Palms down the elbow flexors are much weaker, so heavy dumbbells get swung | Kohn 2018 (about half in one isometric test, worded as the library's Reverse Curl); StrengthLog forearm extensors (expect to use less weight than a regular curl; the pronated grip puts the biceps at a mechanical disadvantage) |
| With the palms down the front deltoids work a little harder, most likely to steady the shoulders | Coratella 2023 Sports (+6% lifting, +5% lowering pronated vs supinated) |

Activation: as the library's (EZ-bar) Reverse Curl, its Wrist Extensors 0.50 and Forearm
Flexors 0.45 merged into Forearms 0.48. Stabilisers from ExRx: anterior deltoid, upper
trapezius, levator scapulae.

## Wrist Roller

Model facts: standing tall, feet ~0.32 m apart, knees 174-176°, trunk upright and still. The
roller (`Q191_WristRoller`) is a 0.50 m tube with two grips (x 0.07-0.24 either side) and a
central spool 5.2 cm across; the cord (`Q191_WristRoller_Cord`) leaves the spool's near side
(the cord's top at z 0.539, the spool's centre at z 0.569) and carries a 0.26 m plate
(`Q191_RollerPlate`). Overhand, hands 0.30 m apart; arms out in front (shoulder flexion 62-78°,
hands at 1.28-1.38 m, the shoulders at 1.43 m, ~0.5 m in front), elbows 154-164°. The roller's
rotateX runs 0 -> +465° from 0 to 3.5 s (top turning away from the lifter, forward and down),
holds to 3.75 s and runs back to 0 by 7.75 s. In each turn one wrist goes from ~44° bent back to
~26-28° bent forward (flexion) in step with the roller (~76°), the other the opposite way; the
right hand turns first (0-0.5 s, 0 -> 76°). Turns: 0-0.5, 0.62-1.12, 1.25-1.75, 1.75-2.38,
2.38-3.0, 3.0-3.5 s up; 3.75-4.38, 4.5-5.12, 5.12-5.75, 5.88-6.38, 6.5-7.12, 7.12-7.75 s down,
the gripping wrist then going from bent forward to bent back. The plate's bottom rises from
2 cm to 26 cm off the floor (24 cm, the spool radius plus cord times 465°) and returns to 2 cm.
The plate hangs ~0.54 m in front of the body; the thighs' front is at z ~0.12-0.15.

Winding direction: with the cord on the spool's near side, the roller winds the plate up when its
near side moves up, i.e. its top turns away from the lifter (positive rotateX here). With the
palms down, turning the top away is the gripping hand bending forward and down (wrist flexion),
which the rig shows. The plate's weight pulls the near side down, so both on the way up
(concentric) and the way down (eccentric) the gripping wrist works in flexion. This is ExRx's
Cable Roller Wrist Flexion (one hand holds while the other slides behind the handle by bending
back and regrips, then flexes; target wrist flexors), not its Cable Roller Wrist Extension (the
regrip in front by flexing, the turn by bending back; target wrist extensors). StrengthLog's
wrist roller page lists the forearm extensors as primary and says only "rolling the bar forward";
the model is the flexion version, so the copy, the rows and the library row follow ExRx's
flexion page (see Requested changes).

| Claim | Source |
|---|---|
| Arms out in front, a little below shoulder height, elbows almost straight | StrengthLog Wrist Roller (arms fully extended in front); the model (hands 5-15 cm below the shoulders, elbows 154-164°) |
| The cord hangs clear of the legs and the plate rises straight up | The model (the plate 0.54 m in front of the body) |
| The front of the shoulders holds the arms there | ExRx (anterior deltoid a stabiliser); the paint (anterior deltoid dim) |
| Sinking arms bring the roller down and back toward the body | The ghost's geometry (30° lower: ~27 cm lower, the hands ~8 cm nearer) |
| Turn the top away, one hand at a time; each turn bends the gripping wrist forward and down, so the flexors wind it up; the other hand bends back and regrips | ExRx Cable Roller Wrist Flexion; the model |
| Rolling the top toward you works the back of the forearms instead | ExRx Cable Roller Wrist Extension |
| Lower with the same turns, slowly; the gripping wrist resists the unwinding plate, the flexors working as they lengthen; letting it spin skips that half of the work | ExRx (lower weight steadily with the opposite movement); StrengthLog forearm extensors (control the weight as you unroll it); the model (six turns down, the wrist going from flexed to extended under load) |
| Until the plate is just off the floor | The model (2 cm at the bottom) |
| Stand tall and still; winding is the forearms' job, and leaning back does nothing to turn the roller | ExRx (the roller is turned by flexing and extending the wrists); StrengthLog (stand with the feet apart); the model (trunk upright, only the wrists and a little arm movement). Plain mechanics, no source needed beyond the description of the lift. The first draft said a lean lifts the roller with the trunk instead of the arms; that was reasoning, not sourced, and was dropped in review |
| Shoulders down; the front of the shoulders holds the arms out, and a shrug does nothing to turn the roller | ExRx (anterior deltoid, upper trapezius, levator scapulae among the stabilisers); the model. The first draft said a shrug only adds the upper traps to the hold; ExRx already lists the upper trapezius as a stabiliser, so that clause was dropped in review |
| Setup: a light plate | StrengthLog forearm extensors (the load will probably be lighter than you think) |

The clip shows 24 cm of travel in a loop; ExRx rolls until the plate is up near the hands. The
copy does not say how far to wind it.

Activation: Wrist Flexors 0.80 HIGH (the working muscles both ways in this direction; a little
under the library's wrist curls' 0.86), Wrist Extensors 0.45 (the regripping hand bends back
unloaded; the extensors steady every grip: Snijders 1987, Mogk & Keir 2003), Brachioradialis 0.36
and Biceps 0.20 holding the soft elbows (ExRx stabilisers; Kleiber 2015: the brachioradialis
takes a larger share with the hand pronated), Anterior Deltoid 0.36 holding the arms out (ExRx
stabiliser, dim paint). Stabilisers from ExRx: brachialis, upper and middle trapezius, levator
scapulae.

## Labels

All six pin their rows with `overrides` (final rows given to `ov()`), laid out with
`overlay.py` and then checked on the app's own trainer and mistake shots (round 1, then fixed):
- Rope (side-on from the right, the column at the right with the stack moving at the right
  edge): the body cues at the left, short enough to end before the back ("No shrug" 0.24 -
  "No shrugging" touched the back of the near shoulder on the simulator - "Elbows still" 0.36,
  "Body still" 0.48); the grip pill at the top right above the knobs' highest point (0.16) and
  the range pill over the static pulley housing (0.72), leaders down and up to the hands.
- Cross-body (near face-on, alternating): the path and grip cues track the RIGHT hand from the
  left (0.16 and 0.36, short pills outside the hanging right arm), the trunk and elbow cues the
  left shoulder and elbow from the right (0.16, 0.36), the range cue the left elbow from below
  the left dumbbell (0.64, a short pill clear of the left knee). Leaders to a crossing hand cross
  the chest when that arm is up; tracking each hand from its own side keeps that to its own
  curl. Round 1: "Across the chest" became "Up and across" and "Shoulders square" became "No
  twisting" so neither pill meets its ghost or the raised shoulder in the mistake view.
- Incline (small, reclined): above the body ("Shoulders back" 0.16 to the far shoulder, "Back on
  the pad" 0.24 to the spine; in that order the two leaders do not cross), a short pill right of
  the near arm ("Arms hang" 0.36, where the upper arm is narrower than at the elbow; "Elbows
  down" at 0.40 covered the arm on the simulator), and below the
  bench (range 0.72, grip 0.80, to the near hand). Round 1 had the shoulder pill top right at
  0.24, where the mistake view's lifted, side-on model put the head under it.
- Zottman and Dumbbell Reverse Curl (face-on): above the dumbbells' sweep (0.16) and below it
  (0.59, 0.80), pills short enough to end before the thighs ("Elbows in" at the right). The
  Zottman's turn pill reads "Turn palms down" (shorter than "Palms down at the top", which
  reached the face); the reverse curl's shoulder pill "No shrugging" (shorter than "Shoulders
  back", which met its ghost's raised shoulder).
- Wrist Roller: in every mistake view the lifted roller sits at about row 0.19, so nothing goes
  top left; three short pills at the left below the roller and left of the cord (turn 0.40 to the
  right hand, arms 0.48 to the right elbow, lower 0.56 to the left hand), the trunk cue at the
  right beside the waist (0.40), the shoulder cue top right (0.16) as a short "No shrug", which
  clears the lifted, side-on back in its mistake view ("Shoulders down" sat on it).

## Ghosts

See the table comments for sizes. Cues without a ghost: Zottman "turn" (a forearm turning over
spins the hand about its own length; the joint lines cannot show it), Wrist Roller "turn"
(both directions pass through the same wrist angles) and "lower" (speed). Views: the rope's
faults all read side-on as framed (face-on, the stack straight ahead of the lifter would hide
the hands, so its wrist fault is the hands tipping down, in the side plane); the cross-body's elbow and
range turn to the left side (-0.9), its right-wrist fold to the right side (+1.6), its twist
to a front-left three-quarter view (-0.5, total -0.9), drawn with the working arm and the
unmoved hip line only (reviewer change, see below); the incline's
sagittal faults to a true left side (-0.6), its wrists face-on (+0.9); the Zottman's and reverse
curl's as the library's Dumbbell and Reverse Curls (-0.9, -0.5); the roller's arms, lean and shrug to
the left side (-0.8).

## Library rows

- Wrist Roller: FOREARM FLEXORS (changed from FOREARM EXTENSORS at the author's request; the model
  winds with palms-down wrist flexion, ExRx's Cable Roller Wrist Flexion; target wrist flexors).
  The copy agrees: the turn and lowering cues name the forearm flexors, Wrist Flexors is the top
  row (0.80), and the other direction is described as moving the work to the back of the
  forearms (ExRx Cable Roller Wrist Extension).
- The other five stand: Rope / Cross-Body / Incline Hammer Curl BRACHIALIS, Zottman BICEPS
  BRACHII, Dumbbell Reverse Curl BRACHIORADIALIS.

## Independent review (2026-10-04)

Two passes after the author finished: sources and claims, then model fidelity on the app's own
shots (`lab500.sh shoot hammer "0,1.6,3,5.6"`).

Sources reopened: every PubMed / Europe PMC record cited (Coratella 2023 Sports and JFMK full
texts, Kohn 2018, Kleiber 2015, Boland 2008, Mogk & Keir 2003, Snijders 1987, Oliveira 2009 full
text, Pinto 2012 abstract plus a full-text summary for the protocol, Kassiano 2025); the six ExRx
pages at the cited Wayback snapshots; the StrengthLog pages (Hammer Curl, Cable Curl With Rope,
Incline Dumbbell Curl, Zottman Curl, Reverse Dumbbell Curl, Wrist Roller, How to Train Your
Forearm Extensors, The 10 Best Forearm Exercises); Catalyst Athletics' Zottman Curl;
Bodybuilding.com's Cross-body hammer curl (Wayback 2024-01-19), Jefit and Fitbod. All exist,
the citation details are right and they say what the header says. Changes:
- "full-range curl training has built more strength than partial reps" -> "than mid-range
  partial reps" in all five range cues (Pinto's partial group trained 50-100°; the library's
  wording).
- Zottman turn cue and comparison: "only about half as strong ... makes the way down a slow,
  hard lowering for the forearms" -> the elbow flexors are much weaker palms down, so curling
  palms up and lowering palms down lets you lower more weight in the reverse-curl grip than you
  could lift in it (Catalyst's claim), which is where the extra forearm work comes from
  (Catalyst, StrengthLog). Dumbbell Reverse Curl swing cue: "only about half as strong" -> "much
  weaker" (one isometric test; the library's Reverse Curl wording).
- Wrist Roller: the two reasoning clauses the author flagged were dropped. The trunk cue now says
  only that winding is the forearms' job and a lean does nothing to turn the roller; the shoulder
  cue that the front of the shoulders holds the arms out and a shrug does nothing to turn the
  roller (the old "only adds the upper traps to that hold" also clashed with ExRx, which already
  lists the upper trapezius as a stabiliser). "throws that half of the set away" -> "skips that
  half of the work".
- Cross-Body: the twist cue said the trunk turns toward the working side; it turns the other way
  (the working shoulder swings forward, as the ghost shows) and now says so. "the front of the
  shoulder takes over" -> "lifts part of the weight". The notes no longer say Jefit keeps the
  upper arm still (it says nothing about the elbow).
- Incline: "where the long head is longest" (upper arms behind the body) -> "is stretched"
  (Oliveira's word); the range cue keeps "longest", which is true within the rep.
- Rope setup: the grip step now comes before stepping back until the cable is taut.

Model fidelity: every trainer still (0, 1.6, 3, 5.6 s) and ghost was checked against the briefs;
the Cross-Body left/right claims, label joints, ghost sides and moments all match the clip (left
arm 0-4 s, right 4-8 s). One ghost changed: the Cross-Body twist, which as framed barely moved
the girdle (~12 pt) and read as the arm reaching further, is now seen from the front-left
three-quarter (-0.5) and drawn with the working arm and the unmoved hip line, so the narrowed,
turned shoulders read against the hips. The Cross-Body wrist fold stays small (~24 pt): the
reviewer's sweep of views -0.4 to +2.0 and 4.8-5.6 s found at most ~27 pt, the limit of a ~10 cm
hand bent 60°. Activation rows and levels were checked against the fractions and the library's
values; each list is marked as a judgement call in its code comment and in Shared above.
