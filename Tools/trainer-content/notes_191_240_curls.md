# Batch 191-240: biceps curls (2026-09-26)

Content: `spec_191_240_curls.py`. Ghosts: `Tools/fault-review/faults_191_240_curls.swift.txt`.
Four exercises from SourceExports/190-240: 236 Alternating Dumbbell Curl, 238 Spider Curl,
239 Dumbbell Preacher Curl, 240 Machine Biceps Curl.

How the models were read: the briefs and framing shots, then the rig and the equipment
prims straight from the USD (Blender's Python + pxr): joint angles over the clip, world
angles of the upper arm, forearm and trunk, the dumbbell/bar/lever/stack transforms and
bounds, and the hand joint's frame (its local Z is the palm normal: checked against the
alternating curl, where the dumbbell handle turns from front-to-back to side-to-side as the
hand supinates). Every ghost was then run through a Python port of `FaultGhost.solve` on
the real joint transforms and drawn side-on and front-on to check its direction.

## Checks run

- `python3 spec_191_240_curls.py` prints OK; `python3 spec_191_240.py` prints OK (46 exercises).
- gen.py dry run: every entry emits 5 annotations and 5 cues; all labels pinned with
  `overrides` (composited over renders from the app camera: no leader crosses the head or
  body, no pill covers a tracked dot or a biceps glow, and every dot sits on a visible body
  part).
- Swift: the pieces and table entries were swapped into a scratch copy of FaultPoses.swift
  and `xcrun swiftc -typecheck` passed (pass 2, after the ghost changes below; no project
  build).

## Model re-export (Alternating Dumbbell Curl)

The left dumbbell's keys used to stop at frame 91, so in the first framing shot it floated
at shoulder height during the right arm's rep. The 2026-09-26 14:21 re-export keys all
equipment to frame 192 (both dumbbells stay 8.1 cm from their wrist joints at every sampled
frame; checked again in pass 2). Re-shoot the framing to confirm in the app.

---

## Alternating Dumbbell Curl (yaw -0.4)

**Model.** Standing tall, feet ~0.3 m apart, knees ~174°, trunk upright (0°) and still.
A dumbbell in each hand, hanging with the palms facing the thighs (handles front to back).
The LEFT arm curls 0-4 s, the right 4-8 s; the resting arm hangs straight (~172°). The
working forearm turns palm-up as it rises (handle across the body by ~90° of elbow bend)
and finishes at ~56° of elbow bend, palm turned up toward the shoulder, the forearm still
~45° short of vertical (wrist ~18 cm ahead of the elbow, 11 cm below the shoulder). The
upper arm drifts only 2-10° off the trunk; no shrug (shoulder height fixed), no lean. Left
arm on the right of the frame.

**Claims and sources**
- Start palm-in, turn palm-up as the dumbbell rises, alternate: ExRx Dumbbell Curl;
  Marcolin 2018 describes exactly this alternate curl (semiprone start, supine by ~90° of
  flexion). ExRx raises the dumbbell until the forearm is vertical and the palm faces the
  shoulder; with the elbow kept at the side (as in the model and in the NSCA coaching
  points) the forearm cannot reach vertical, so the copy says to curl until the dumbbell is
  in front of the shoulder, palm turned up toward it, without bringing the elbow forward.
- The biceps supinates as well as flexes: Marcolin 2018 (citing Gray's Anatomy);
  Basmajian and Latif 1957 is the classic EMG source.
- Palm-up curls work the biceps harder: Coratella et al. 2023, Sports 11(3):64 (+12% vs
  neutral, +19% vs pronated, ten competitive bodybuilders at 8RM). Palm-up vs palm-in is
  mixed: Kleiber 2015 found biceps activity similar across hand positions in slow, unloaded
  single flexions, and Marcolin 2018 found more biceps activity in the near-semiprone EZ-bar
  curl than in this supinating dumbbell curl. The copy is hedged to "in trained lifters".
- Elbow by the side; drifting forward brings the front deltoid in and lets the forearm
  reach vertical early, where the dumbbell no longer loads the elbow: NSCA Basics manual
  (elbows at the sides), StrengthLog Dumbbell Curl (elbows moving forward puts extra load on
  the front delts), ACE/Young 2014 (swinging the arm forward calls in the anterior deltoid),
  Coratella 2023 JFMK (arm flexion raised anterior deltoid excitation). The unloading at
  vertical is the lever arm (weight × horizontal distance from the elbow). Coratella found
  biceps excitation *higher* in the lifting phase when the arms flexed (+17.7 to +20.3%), so
  the copy says the dumbbell stops loading the elbow, not that the biceps works less.
- Wrist: the turn mistake is the wrist curling in instead of the palm turning up (a visible
  position). No claim that the forearm flexors take over (no study found).
- Shoulders down and back: NSCA Basics manual (no rolling the shoulders forward).
- Lower to a straight arm; full range builds more strength: Pinto et al. 2012 (full
  0-130° vs 50-100° elbow-flexor training: 1RM +25.7% vs +16.0%, thickness similar);
  NASM (partial range listed as a common mistake).
- No swing, lower over 2-3 s: NSCA Basics manual, NASM, StrengthLog.
- Activation: Biceps Brachii 0.84 HI > Brachialis 0.62 MOD > Brachioradialis 0.46 MOD.
  Marcolin 2018 measured this curl's biceps a little below the EZ-bar curl (and below the
  straight bar when lowering) and its brachioradialis below both, so the biceps sits just
  under the Barbell Curl's 0.90 and Biceps Curl's 0.88. Brachialis is from anatomy
  (surface EMG can't isolate it; Marcolin notes the limitation).
- Comparison: SWINGING THE DUMBBELL (NASM and StrengthLog list momentum first).

**Uncertain.** Relative fractions below the biceps are judgement, anchored to the
existing curl entries.

**Ghosts and stills** (default = left elbow most bent, 1.58 s; all five are shot there):
- shoulder: `hunched()`, both shoulders and arms 0.07 torso lengths forward and 0.1 up,
  any moment (label points at the right shoulder); `.seen(-0.6)` (total -1.0).
- elbow: `elbowsForward(35, side: "L")`, the left arm swung 35° forward about the
  shoulder, with the left elbow bend; top of the left curl; `.seen(-0.9)` (total -1.3).
- turn: `curlWristsCurled("L")`, the left hand folded 50° about the wrist toward the palm,
  with the left elbow bend; top of the left curl; `.seen(-0.9)`.
- range: the right (resting) arm folded 60° about the elbow (to ~112°),
  `.withBend("forearm_L")`, so it shows while the left arm is at the top (1.58 s); turned
  to the right side (`.seen(1.5)`, total +1.1) so the forearm shows swinging forward, not
  folding across the hips.
- torso: bodySwung's moves inline (hips 0.06 ahead, trunk and arms 15° back about the
  pelvis) with a hands-apart strength (`.between("hand_L", "hand_R", from: 0.85, to:
  1.0)`; 0.79 torso lengths with both arms down, 1.07 at the top of either curl), so the
  swing shows at the top of both curls, not only the left; read at the top of the left
  curl; `.seen(-0.9)` (total -1.3).

## Spider Curl (yaw -2.0)

**Model.** Kneeling on the seat of an adjustable bench whose back pad sits at ~42°
(trunk 48° forward of vertical), chest and stomach on the pad, shoulders just behind its
top edge; knees ~132°, feet off the floor behind the seat. Olympic barbell, underhand,
hands ~0.42 m apart. Upper arms hang straight down (~89° below horizontal) and stay
still; elbows 170° to 53°, two reps. At the bottom the bar hangs almost straight under the
elbows (hands ~4 cm ahead); at the top the forearms are still ~38° above horizontal, the
bar ~20 cm in front of the elbows. Seen from behind on the left; only the near (left) arm
is visible, the far arm is hidden behind the torso and pad.

**Claims and sources**
- Set-up (prone on an incline bench, knees on the seat, shoulders near the top,
  shoulder-width underhand grip, lower to straight arms): ExRx Barbell Prone Incline Curl
  (also known as the barbell spider curl); StrengthLog Spider Curl (45° bench, upper arms
  vertical, do not let them travel back or forwards).
- The pad stops the torso rocking, so the elbow flexors lift the whole load: ExRx, and
  ACE/Young 2014 (the braced concentration curl isolated the biceps best in their study).
- Load profile and the elbow fault: with the upper arms vertical the bar hangs almost under
  the elbows at the bottom and swings out in front as it rises, so elbow torque rises with
  the sine of flexion, peaks with the forearms level and is still ~0.8 of peak at the
  model's top. Elbows swinging toward the head bring the front deltoids in (StrengthLog;
  ACE; Coratella 2023 JFMK) and tip the bar back over the elbows, which takes load off the
  elbow flexors (lever-arm mechanics, as Oliveira 2009 explains for the preacher curl). The
  copy does not claim that biceps activity drops (Coratella 2023 JFMK found it rises in the
  lifting phase with arm flexion).
- Wrists straight, shoulder-width underhand grip: StrengthLog (bent wrists take needless
  load); Coratella 2023 Sports (supinated grip highest biceps excitation). Curling the
  wrists in pulls the bar back toward the elbows at the top: mechanics.
- Full range: Pinto 2012; ExRx (lower until the arms are fully extended); StrengthLog (keep
  tension at the bottom).
- Activation: Biceps Brachii 0.86 HI > Brachialis 0.66 MOD > Brachioradialis 0.46 MOD.
  No EMG study of the spider curl was found. Ranked by the closest studied curls: a
  supinated straight-bar curl (Marcolin 2018, Coratella 2023) with the upper arm fixed
  (ACE: concentration curl highest biceps). ExRx lists the brachialis as target and the
  biceps and brachioradialis as synergists for the prone incline curl and both preacher
  curls, with no EMG data; its only comment is that the biceps long head works more than
  the short head, because the short head enters active insufficiency. So the brachialis is
  given a solid secondary share, while the ACE data argue against demoting the biceps. The
  brachioradialis was raised from 0.42 to 0.46 in pass 2 so a supinated straight-bar curl
  is not ranked below the alternate dumbbell curl (Marcolin 2018 found more brachioradialis
  in the straight-bar curl's lifting phase); it stays below the Barbell Curl's 0.52. Small
  differences between these fractions are not backed by any study.
- Stabilisers: anterior deltoid (the bar in front of the shoulders pulls the arms back, so
  the shoulder flexors hold them vertical), forearm flexors, middle trapezius and rhomboids
  (ExRx lists wrist flexors, middle trapezius and rhomboids).
- The popular claim that the spider curl targets the short head is not in the copy: no
  study supports it, and ExRx says the opposite.
- Comparison: ELBOWS DRIFTING FORWARD (the fault the exercise exists to prevent).

**Uncertain.** Activation shares (no direct study). The bench angle is ~42° in the model;
the setup says "about 45°", matching StrengthLog.

**Labels and glows.** The upper-arm cue sits above the plate (row 0.22, left) with its
leader to the near shoulder (`upper_arm_L`); the range cue points at the near elbow
(`forearm_L`), since the far elbow is hidden. The glows sit on the visible left arm only.

**Ghosts and stills** (default 1.58 s = most bent, except range):
- pad: `trunkLifted(18)`, the trunk and arms rocking up 18° about the pelvis (48° to 30°
  forward of vertical), opening a wedge between the ghost back and the pad; any moment;
  side view (`.seen(0.45)`, total -1.55).
- shoulder: inline shrug, the shoulders and arms 0.18 torso lengths up the pad toward the
  ears (10.6 cm, ending above the neck), drawn as the girdle and upper arms only; any
  moment; no turn, the framing's back view shows it best.
- elbow: `elbowsForward(30, withBar: true)`, the upper arms swung 30° toward the head, with
  the elbow bend; top; `.seen(0.45)`.
- grip: `curlWristsCurled(withBar: true, degrees: 65)`, a deeper 65° fold (the lifter is
  framed small), with the elbow bend; top; `.seen(0.45)`.
- range: `curlBottomCut(from: 0.8, to: 0.89)`, the hands folded 45° about the elbows,
  none at 0.8 torso lengths shoulder-to-wrist (120°), all of it at 0.89 (near 170°);
  `.seen(0.45)`; at the bottom (straightest elbow), 3.83 s.

## Dumbbell Preacher Curl (yaw -1.1)

**Model.** Seated on a preacher bench (knees ~124°, hips ~110°, feet flat ~0.38 m apart),
trunk 12° forward, chest against the back of the pad. The pad slopes ~45°; the LEFT upper
arm lies on it (45° below horizontal), armpit at the top edge. One dumbbell in the left
hand, palm up. Elbow 162° to 62°: the rep stops ~18° short of straight and finishes with
the forearm nearly upright (~72° above horizontal). The right arm rests on the pad,
empty-handed (elbow ~103°).

**Claims and sources**
- Armpit near the top of the pad, back of the arm on it the whole set, seat set for
  that; lower until the arm is (almost) extended: ExRx Dumbbell Preacher Curl; StrengthLog
  (stop short of full extension if it is uncomfortable, which is what the model does).
- The pad holds the upper arm at ~45°: measured on the model (upper arm 45° below
  horizontal) and matches Sato 2021's preacher set-up (45° shoulder flexion).
- The bottom half loads the biceps most and the top hardly at all: Oliveira 2009 (preacher
  curl biceps activity high only for a short range near extension; load torque falls as the
  hand crosses the elbow line). On this 45° pad the forearm is level at ~135° of elbow
  angle (peak torque) and ~72° up at the model's top (~0.3 of peak).
- Training the bottom half built more strength and at least as much muscle as the top half:
  Pedrosa et al. 2023 (untrained women, dumbbell preacher curl, 0-68° vs 68-135°: larger
  1RM gain; more CSA at 70% of humerus length, similar at 50% and summed) and Sato et al.
  2021 (untrained adults, dumbbell preacher curl, 0-50° vs 80-130°: more strength and more
  combined biceps and brachialis thickness). Nunes 2020 found similar growth whichever part
  of the preacher curl carried the torque peak. Hence "more strength, and at least as much
  muscle", not "more size".
- Comparison mistake note: stopping halfway keeps the reps in the top half, where the
  dumbbell moves in over the elbow and the load falls away (near the very top, not across
  the whole top half: at 68° of flexion torque is still ~0.9 of peak).
- Wrist: StrengthLog (bent wrists take needless load); curling the wrist in pulls the
  dumbbell back toward the elbow at the top (mechanics).
- Rocking back / seat too low: general curl guidance (NSCA, NASM momentum) and ExRx seat
  height rule.
- Activation: Biceps Brachii 0.84 HI > Brachialis 0.68 MOD > Brachioradialis 0.36 LOW.
  ACE/Young 2014 is the only direct support for a lower preacher brachioradialis (lower
  than the narrow-grip EZ curl; not shown below the barbell curl). Note that Coratella 2023
  found brachioradialis excitation higher, not lower, with a supinated grip in loaded
  curls, so the supinated grip is not given as a reason. ACE also had the preacher curl
  lowest in biceps activity of its eight curls (about 68% MVC vs about 77% for the barbell
  curl), and Oliveira 2009 shows the biceps working hard only in the bottom part, so its
  share is kept at 0.84, below the Barbell Curl's 0.90. Brachialis share is judgement (ExRx
  lists preacher curls under the brachialis, with no EMG data).
- Comparison: STOPPING SHORT AT THE BOTTOM (the part with the strongest evidence).

**Uncertain.** The "seat too low" ghost shows the trunk sinking under shoulders held on
the pad; a seat set too high (lifter draped over the pad) is the other way to get it wrong
and is not drawn.

**Ghosts and stills** (default 1.58 s = most bent, except range and seat):
- pad: `curlArmsOffPad(25, side: "L")` (the left upper arm turned 25° off the pad about the
  shoulder, drawn to the wrist), with the elbow bend; top.
- range: `curlBottomCut("L", from: 0.8, to: 0.885)`, the left hand folded 45°; bottom
  (straightest), 3.83 s.
- wrist: `curlWristsCurled("L")`, the hand folded 50°, with the elbow bend; top.
- torso: `curlSeatedSwungBack(22, side: "L")`, the trunk turned 22° back about the pelvis
  (from the model's 12° forward to ~10° behind vertical), with the elbow bend; top (it
  fades with the elbow straightening); only the spine and the working left arm, to the
  wrist, are drawn, as for other one-arm lifts.
- seat: `preacherSatLow`, any moment. The body sinks 0.2 torso lengths while the arms stay
  hooked over the pad, so the neck ends ~5 cm below the shoulder line and the head ~12 cm
  lower; the knees re-seat from 124° to ~101°; the legs are drawn to the ankles only.
  Turned toward the front (`.seen(0.5)`, total -0.6) so the shoulder line spreads and the
  neck shows sinking between the shoulders; read at the bottom, 3.83 s, with the dumbbell
  away from the head.
Pad, range, wrist and torso turn to a true left side view (`.seen(-0.4)`, total -1.5).

## Machine Biceps Curl (yaw -1.0)

**Model.** A plate-stack, preacher-style curl machine. Seated (knees ~111°, hips ~101°,
feet flat), trunk 12° forward, chest to the pad. The arm pad holds the upper arms ~35°
off vertical (55° below horizontal); the elbows sit level with the lever's side pivots
(elbow and pivot hub both ~0.91 m up, within 1 cm fore-aft). A straight handle bar with
two grips, hands ~0.4 m apart, underhand. Both arms curl together, elbows 162° to 62°, two
reps. The whole stack (StackTop and ten plates) is one prim that rises and falls as a
block; at the bottom of every rep it hangs ~7 cm above the tower base, so it never touches
down and no plates stay behind.

**Claims and sources**
- Elbows in line with the machine's pivot, upper arms on the pad, underhand grip about
  shoulder-width, stop before the weights touch down: StrengthLog Machine Biceps Curl
  (stop just before the weights hit the stack); ExRx Lever Preacher Curl (elbows aligned
  with the lever's fulcrum, armpit near the top of the pad, back of the arm on it).
- With the elbows on the lever's axis the handle moves on the same arc as the forearms:
  geometry of a lever turning about the elbow's axis.
- Bottom-range training built more strength, and at least as much muscle, on
  preacher-style curls: Pedrosa 2023, Sato 2021 (both dumbbell preacher curls; the machine
  puts the arm in the same position). Neither used a machine.
- Elbows off the pad / rocking back let the shoulders and body help: ACE/Young 2014
  (upper arm braced = least deltoid involvement), NSCA Basics manual. The machine's torso
  cue (`TORSO_MACHINE`) says the body, not the elbow flexors, gets the handle moving; it
  makes no claim about which part of the rep is hardest.
- Wrists: StrengthLog (bent wrists take needless load); with the handle on a lever turning
  about the elbows, curling the wrists moves the handle with the wrists instead of the
  elbows (geometry).
- Activation: Biceps Brachii 0.84 HI > Brachialis 0.66 MOD > Brachioradialis 0.38 LOW.
  No EMG study of a selectorised curl machine was found; ranked like the preacher curl
  (closest studied variation: Oliveira 2009, ACE 2014).
- Comparison: ELBOWS LIFTING OFF THE PAD.

**Uncertain.** How this machine's lever/cam loads the top of the rep is not known, so the
copy makes no claim about where the machine is hardest. The ghosts draw the hands off the
handle when the arms lift (the real handle would follow the hands).

**Ghosts and stills** (default 1.58 s = most bent, except range and pivot):
- pivot: `curlMachineSatLow` (body and shoulders 0.1 torso lengths lower, hands on the
  handle, elbows and knees re-seated, the elbows below the pivot), any moment, read at the
  bottom, 3.83 s: there the ghost elbows sit ~8 cm below the hub (3.9 cm behind it); at
  the top they are only ~1.7 cm below and 4.7 cm in front, which reads as elbows ahead of
  the pivot rather than under it.
- pad: `curlArmsOffPad(25)`, both upper arms turned 25° off the pad, drawn to the wrists,
  with the elbow bend; top.
- grip: `curlWristsCurled()`, both hands folded 50°, with the elbow bend; top.
- range: `curlBottomCut(from: 0.8, to: 0.885)`, the hands folded 45°; bottom, 3.83 s.
- torso: `curlSeatedSwungBack(22)`, the trunk and both arms (to the wrists) turned 22°
  back about the pelvis, with the elbow bend; top.
All with `.seen(-0.5)` (total -1.5, true left side, where the pivot hub shows).

## New pieces

`curlWristsCurled(side, withBar:, degrees:)` (50° by default), `curlArmsOffPad(degrees,
side:)`, `curlBottomCut(side, from:, to:)` (a 45° fold), `curlSeatedSwungBack(degrees,
side:)`, `preacherSatLow` (0.2 sink), `curlMachineSatLow` (0.1 sink) — documented in the
PIECES section. Reused: `hunched`, `elbowsForward`, `elbowsFolded`, `trunkLifted`, and
bodySwung's moves (inline, with a hands-apart strength); the Spider Curl shrug is inline. The
`curlBottomCut` ranges come from each model's shoulder-to-wrist distance: 0.90 torso
lengths at 170° (standing and spider), 0.896 at 162° (preacher and machine), 0.78 at 120°.

Pass 2 changes for the lead to carry into FaultPoses.swift: `curlSeatedSwungBack` gained
`side:` (chains `[spine, arm(side)]`, strength `.withBend(elbow(side))`; the machine's call
is unchanged, since `arm("*")` is `armsToGrip` and `elbow("*")` is `forearm_L`),
`preacherSatLow` sinks by 0.14 instead of 0.1, the preacher's torso ghost passes
`side: "L"`, and the alternating curl's torso ghost is the inline hands-apart version.

## Sources

- Marcolin G, Panizzolo FA, Petrone N, Moro T, Grigoletto D, Piccolo D, Paoli A. 2018.
  Differences in electromyographic activity of biceps brachii and brachioradialis while
  performing three variants of curl. PeerJ 6:e5165. doi:10.7717/peerj.5165
- Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F, Cè E. 2023. Biceps
  brachii and brachioradialis excitation in biceps curl exercise: different handgrips,
  different synergy. Sports 11(3):64. doi:10.3390/sports11030064
- Coratella G, Tornatore G, Longo S, Esposito F, Cè E. 2023. Bilateral biceps curl shows
  distinct biceps brachii and anterior deltoid excitation comparing straight vs. EZ
  barbell coupled with arms flexion/no-flexion. J Funct Morphol Kinesiol 8(1):13.
  doi:10.3390/jfmk8010013
- Kleiber T, Kunz L, Disselhorst-Klug C. 2015. Muscular coordination of biceps brachii and
  brachioradialis in elbow flexion with respect to hand position. Front Physiol 6:215.
  doi:10.3389/fphys.2015.00215
- Basmajian JV, Latif A. 1957. Integrated actions and functions of the chief flexors of the
  elbow. J Bone Joint Surg Am 39-A(5):1106-1118.
- Oliveira LF, Matta TT, Alves DS, Garcia MAC, Vieira TMM. 2009. Effect of the shoulder
  position on the biceps brachii EMG in different dumbbell curls. J Sports Sci Med
  8(1):24-29.
- Pedrosa GF, Simões MG, Figueiredo MOC, Lacerda LT, Schoenfeld BJ, Lima FV, Chagas MH,
  Diniz RCR. 2023. Training in the initial range of motion promotes greater muscle
  adaptations than at final in the arm curl. Sports 11(2):39. doi:10.3390/sports11020039
- Sato S, Yoshida R, Kiyono R, Yahata K, Yasaka K, Nunes JP, Nosaka K, Nakamura M. 2021.
  Elbow joint angles in elbow flexor unilateral resistance exercise training determine its
  effects on muscle strength and thickness of trained and non-trained arms. Front Physiol
  12:734509. doi:10.3389/fphys.2021.734509
- Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE, Bottaro M. 2012. Effect of range of
  motion on muscle strength and thickness. J Strength Cond Res 26(8):2140-2145.
  doi:10.1519/JSC.0b013e31823a3b15
- Nunes JP, Jacinto JL, Ribeiro AS, et al. 2020. Placing greater torque at shorter or
  longer muscle lengths? Effects of cable vs. barbell preacher curl training on muscular
  strength and hypertrophy in young adults. Int J Environ Res Public Health 17(16):5859.
  doi:10.3390/ijerph17165859
- Young S, Porcari JP, Camic C, Kovacs A, Foster C. 2014. ACE study reveals best biceps
  exercises. ACE ProSource, August 2014 (ACE-sponsored EMG study, not peer-reviewed; PDF
  read in full: concentration curl ~97% MVC, barbell curl ~77%, preacher curl ~68%, the
  lowest of the eight; incline and preacher curls less brachioradialis than the narrow EZ
  curl; incline, concentration and chin-up less anterior deltoid than the barbell curl).
- Sands WA, Wurth JJ, Hewit JK. 2012. NSCA's Basics of Strength and Conditioning Manual
  (EZ-bar curl, p. 46: elbows at the sides, no rolling the shoulders forward, no momentum,
  slow controlled return).
- ExRx.net: Dumbbell Curl, Barbell Prone Incline Curl, Dumbbell Preacher Curl, Lever
  Preacher Curl. ExRx blocks direct fetches (Cloudflare); the instructions, muscle lists and
  comments were read from the pages' search-index text and confirmed by the evidence review
  on web.archive.org snapshots (2023-2026).
- StrengthLog exercise guides (strengthlog.com): Dumbbell Curl, Spider Curl, Dumbbell
  Preacher Curl, Machine Biceps Curl (/machine-bicep-curl/).
- NASM Exercise Library: Barbell Biceps Curl (common mistakes).
