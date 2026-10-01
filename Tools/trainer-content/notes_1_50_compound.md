# Exercises 1-50 redo: family "compound" (2026-09-29, revised 2026-09-30)

Pendlay Row (015, Back/PendlayRow) and Close-Grip Bench Press (050,
Triceps/CloseGripBenchPress), both new to the app. `spec_1_50_compound.py`
holds the copy and setup steps (its header lists the full citations and what
each model shows), `Tools/fault-review/faults_1_50_compound.swift.txt` the
ghosts and `Tools/fault-review/fault_moments_1_50_compound.json` the moment
each ghost is stilled. This file maps each claim in the copy to its source
and records the model facts the copy relies on.

Model facts came from `briefs_1_50/PendlayRow.md` and
`briefs_1_50/CloseGripBenchPress.md`, from extra probes with Blender's
Python (bar bounds every 2 frames, joint positions, and the distance from
the bar's axis to the skinned body meshes), and from the trainer stills
`shots/view/<slug>_t{0,1,2,3,5}.png`. Both clips are two identical reps in
8 s; the neck-to-pelvis torso length is 0.59 m in both (the unit of the
ghost moves).

## Open issues for the user

- **Pendlay Row plates never touch the floor.** At their lowest (0 s, 4 s)
  the plates are 3.6 cm above the floor and the bar is within 1 cm of its
  lowest point for only ~0.3 s, so the model shows no rest on the floor and
  its lower back holds the bar the whole set. The app draws no floor, so it
  is not visible there, but a re-export with the plates resting on the floor
  and a short pause would match the floor cue exactly. Until then the floor
  cue's benefit is written conditionally ("When it rests there, ...").
- **Barbell Bent-Over Row lats (checked, no action now).** The review saw
  its SampleData.swift content listing Latissimus Dorsi as PRIMARY 0.80,
  against its own paint (identical to Pendlay Row's: lats dim; trapezius,
  rhomboids, rear delt and rotator cuff bright). Re-checked 2026-09-30 in
  the working copy, which another pass is editing: `barbellBentOverRowContent`
  now has Middle Trapezius, Posterior Deltoid and Rhomboids PRIMARY and
  Latissimus Dorsi SECONDARY 0.60, so the two sibling rows agree. Worth a
  look only if that change is reverted.
- **Close-Grip Bench Press far toe clipped on the trainer screen.** In the
  shared `.bench` framing (SampleData's model map, not this family's files)
  the far shoe's toe touches the viewport's left edge and its tip is cut
  off on the simulator at every moment (the feet are set wide and ahead of
  the knees). The feet ghost turns side-on so it stays in frame; the
  trainer view itself would need its own framing (the bench lifts' preset
  shifted right, or zoomed out slightly) in `modelByExercise`.

## Pendlay Row

### What the model does

- Framing yaw -2.0, zoom 0.803: from behind on the lifter's left, about 25°
  past a side view, like the Barbell Bent-Over Row. The lifter faces
  screen-left; the near (left) plate is on the left of the frame.
- Only the arms and the bar move. Every other joint (pelvis, spine, chest,
  neck, head, legs, and the clavicle, scapula and shoulder joints) holds its
  position to the millimetre across the clip. So the model shows **no
  shoulder-blade squeeze or reach**: the shoulders are simply held set. The
  shoulder cue is written that way ("the shoulders stay set, held back"),
  not as a squeeze at the top.
- Stance and hinge: ankles 0.28 m apart (about hip width), toes forward;
  knees 84°, hips 50°, pelvis 0.61 m up, trunk 70° from vertical, about 20°
  above level. The copy says "close to level" / "near level", never
  "parallel" or plain "level" (the comparison's correct cue now reads "Back
  near level, only arms move").
- Grip: overhand, palms facing back and down; wrists 0.62 m apart, each
  ~12 cm outside its shoulder joint ("a little wider than your shoulders"):
  ExRx's "wide overhand grip", not its shoulder-width option. Wrists 2-13°
  flexed.
- Bar: 2.2 m bar, 45 cm plates. Lowest at 0 s and 4 s with the plates
  3.6 cm above the floor (the shoe soles are at 0.001 m), the bar ~23 cm in
  front of the toes and about under the shoulders (wrists 6 cm ahead of the
  shoulder joints); elbows 127° there, so the arms never straighten.
  Rising: 24 cm up and 20 cm back toward the body. Top (1.25-1.9 s): bar
  axis 6 cm from the sternal pec surface (just under the lower chest) and
  2 cm from the thigh muscles just above the knees; elbows 64-66°, the upper
  arms 14° behind the trunk line ("elbows driving back past the torso") and
  12-21° out from the sides.
- Because the correct top already sits beside the knees, the pull fault is
  written as the bar stopping "out in front of the knees" (the ghost's bar
  is ~7 cm in front of them), not "near the knees".
- Timing: pull 0-1.25 s, held 1.25-1.9 s, lowered 1.9-4.0 s. **No pause on
  the floor**: the bar is within 1 cm of its lowest point for only ~0.3 s
  (3.83-4.17 s) and rises again at once. The pull is quicker than the
  lowering but not explosive.
- Highlight tiers: bright (primary) rear deltoid, infraspinatus, teres
  minor, supraspinatus, subscapularis, rhomboid major, upper/middle/lower
  trapezius; dim (secondary) biceps (both heads), brachioradialis, forearm
  flexors and extensors, palmaris longus, latissimus dorsi.

### What the copy therefore does not claim

The Pendlay row is usually described as a dead-stop row pulled explosively
from the floor with the torso parallel to it. The model shows the bar
coming back to (just above) the floor every rep with a still, near-level
torso, but no dead stop, no explosive pull and a torso ~20° above level.
The copy says the bar "comes back down to the floor at the end of every
rep" and asks the lifter to "lower the bar with control until the plates
reach the floor, then pull the next rep from there"; it does not mention a
pause, a dead stop or pulling explosively, and it does not describe the
bar path as vertical or over the mid-foot (the model's bar starts ~23 cm
ahead of the toes and travels on a diagonal). The benefit of resting the
bar is stated conditionally (see the open issue above). Neither the torso
cue nor the floor cue claims to be the one defining feature: StrengthLog
gives both together.

### Claims and sources

- TORSO cue. "Keeping the upper body still is part of what sets the Pendlay
  row apart: the arms and the bar are the only things that move":
  StrengthLog Pendlay Row ("The pendlay row is a variant of the barbell row
  where you keep your upper body fixated throughout the movement. Only the
  bar and your arms are moving, and you put the bar back on the floor
  between each repetition": two features, so "part of"). "A torso held
  close to level is the strict way to row a barbell": ExRx Barbell
  Bent-over Row, "Torso may be kept horizontal for strict execution" (the
  page adds "Also known as Pendlay Row"). "Lifting the chest to start each
  pull can let the hips and lower back swing the bar up instead of the upper
  back rowing it": coaching inference from those two (strict = still
  torso); no study measured it, hence "can". Model: trunk fixed at 70° from
  vertical. Comparison TORSO HEAVING UP: same sources; its mistake note uses
  the same hedged "can let".
- SPINE cue. "Of three rows compared in one study, the standing bent-over
  row worked the muscles across the back hard on both sides but put the
  largest load on the lower spine": Fenwick, Brown & McGill 2009 (7 healthy
  men; inverted, standing bent-over and one-arm cable rows; "The standing
  bent-over row produced large activation symmetrically across the back but
  produced the largest lumbar spine load"). The copy no longer draws a "so
  the back has to hold a flat position" conclusion from it: the study
  measured activation, spine load and stiffness, not rounding. "Bending the
  knees lets the hips hinge low without the lower back rounding; if it still
  rounds, bend the knees more or do not take the torso as low": ExRx
  ("Knees are bent in effort to keep low back straight ... If low back
  becomes rounded due to tight hamstrings, either try bending knees more or
  don't position torso as low"). Model: knees 84°, back flat and still.
  Note: spec_131_160.py's header cites Fenwick 2009 as J Strength Cond Res
  23(2):350-358; the paper is 23(5):1408-1417 (PMID 19620925, doi
  10.1519/JSC.0b013e3181b07334).
- FLOOR cue. "Setting the bar back on the floor between reps is the other
  thing that sets the Pendlay row apart from a regular bent-over row":
  StrengthLog (as above: "you put the bar back on the floor between each
  repetition"). "When it rests there, the lower back is not holding it out
  in front for the whole set, and each rep starts by building tension
  again": StrengthLog ("you will avoid some of the static work for your
  core and lower back that you otherwise get from doing barbell rows.
  Instead, you will get to practice how to build up tension in those
  muscles in each rep"); conditional because the model's plates stop
  3.6 cm short (open issue). Correct text "Lower the bar with control":
  StrengthLog ("With control, lower the bar back to the floor").
- PULL cue. "Pendlay row guides teach a pull as high as you can, until the
  bar touches the upper stomach or chest if possible": StrengthLog ("Pull
  the bar as high as you can, so that it touches your abs or chest if
  possible"); ExRx ("Pull bar to upper waist"). "Stopping the bar half-way,
  well short of the chest, makes every rep a partial": definitional. Model:
  the bar stops just under the lower chest (6 cm from the pec surface), so
  the intro says "just under the chest" and the correct text "until the bar
  is just under your lower chest". The mistake says "out in front of the
  knees" (see the model facts: the correct top is beside the knees).
- SHOULDERS cue. "The middle and lower trapezius and the rhomboids pull the
  shoulder blades back": anatomy (scapular retraction; the upper trapezius
  mainly elevates, so it is left out); ExRx lists the middle and lower
  trapezius and rhomboids as synergists of the row. "An EMG study of the
  shoulder-blade muscles named rowing as one of four core exercises for
  strengthening them": Moseley et al. 1992 (indwelling EMG, 9 healthy
  subjects, eight scapular muscles including the three trapezius parts and
  the rhomboids, 16 shoulder rehabilitation exercises: "a group of 4
  exercises was shown to make up the core of a scapular muscle
  strengthening program. Those 4 exercises include scaption ..., rowing,
  push-up with a plus, and press-up"). It backs rowing as a scapular
  exercise, not the set-shoulder technique point, and the copy says only
  that. "Keeping the shoulders set gives the pull a fixed base": coaching
  reasoning. "Rounding them toward the floor lets the shoulder blades slide
  forward around the ribs": anatomy (protraction). Model: shoulders fixed.
- Activation (Trapezius P 0.82, Rhomboids P 0.78, Posterior Deltoid P 0.74,
  Rotator Cuff P 0.60, Latissimus Dorsi S 0.58, Biceps Brachii S 0.46,
  Forearms S 0.30). Ranks follow the model's tiers: the rotator cuff is
  painted bright, so it is a PRIMARY row (the app files it under rear
  delts, as the Face Pull's, Reverse Pec Deck's and rear-delt flies'
  "Rotator Cuff" rows); the forearm muscles are painted dim, so a
  "Forearms" SECONDARY row, as the curls family does. Support: StrengthLog
  (primary lats, trapezius, rear deltoids; secondary biceps, lower back,
  forearm flexors, rotator cuff); ExRx (target "Back, General"; synergists
  middle and lower trapezius, rhomboids, latissimus dorsi, teres major,
  posterior deltoid, infraspinatus, teres minor, brachialis,
  brachioradialis; dynamic stabiliser biceps; stabilisers erector spinae,
  hamstrings, gluteus maximus; and "A wide overhand grip involves overall
  back musculature while slightly emphasizing Rear Delt, Infraspinatus and
  Teres Minor involvement", the model's grip, which backs the bright rear
  delt and rotator cuff); Fenwick 2009 (large, symmetrical back activation
  in the bent-over row). **Flag (lats):** ExRx ties extra lat work to a
  shoulder-width or underhand grip ("A shoulder width or underhand grip can
  increase lat involvement by emphasizing shoulder extension over
  transverse extension"). The model uses ExRx's wide overhand grip, which
  ExRx says slightly emphasises the rear delt, infraspinatus and teres
  minor, matching the model's bright tier. StrengthLog still lists the lats
  as primary. The lats are secondary here because the model paints them
  dim, at 0.58 so no secondary row outranks a primary one. No study
  measured the trapezius, rhomboids, rear delts, rotator cuff and lats
  together in a Pendlay row; the fractions are a judgement, the order is
  the model's.
- Stabilisers: "erector spinae", "hamstrings", "glutes" (ExRx stabilisers).
  The rotator cuff and forearms moved from here to the activation rows.
- Setup steps: all from the model (feet about hip-width, the bar in front of
  the toes, knees bent well and back close to level, overhand grip a little
  wider than the shoulders, flat back and shoulders set, arms reaching down).

### Ghosts (`faults_1_50_compound.swift.txt`)

- torso: `pendlayChestHeave`: the trunk swings 25° up about the pelvis as
  in `trunkLifted` (the Barbell Bent-Over Row's piece, 26° there), then
  each arm turns back 25° about its shoulder, so the arms keep hanging as
  the real ones do and the bar comes up with the chest (chains: spine, arms
  to the grip, bar). Stilled at the **bottom**: the ghost bar rises ~19 cm
  off the floor, to knee height and ~12 cm in front of the knees, the trunk
  ~45° above level. (Simulator QA: `trunkLifted` turned the arms with the
  trunk, so at the top of the pull they drew a zigzag over the back with
  no bar, and at the bottom they swung forward to point level in the air.)
- spine: `pendlayBackRounded`, a deeper `backRounded` in the Z Press's
  idiom: spine 0.10 and chest 0.10 torso lengths away from the floor (chest
  also 0.02 down the spine), neck 0.04 and head 0.13 toward the floor and
  0.04 / 0.07 down the spine; strength `pendlayAtFloor`, full with the
  plates at their lowest and gone once the bar is ~11 cm up
  (`pendlayAtFloor` reads the left wrist to pelvis distance: 1.19 torso
  lengths at the floor, 1.03 at 0.5 s, 0.80 at the top). Stilled at the
  bottom. (Simulator QA: the shared piece's ~4 cm hump (5 pt) read as a
  flat line along the back with only the head dropping; the deeper one
  arches visibly over the real back.)
- floor: `pendlayBarHovering`: hands and bar 0.15 torso lengths (~9 cm)
  higher, the plates ~12 cm off the floor, elbows re-seated under the fixed
  shoulders; strength `pendlayAtFloor`. Checked offline: wrist 0.326 ->
  0.415 m up at 0 s. Stilled at the bottom.
- pull: `pendlayPulledShort`: hands 0.14 torso lengths ahead and 0.17 lower,
  back along the bar's own path; at full strength the ghost wrist sits at
  (0.31, 0.46, 0.34), where the real wrist is at ~0.75 s, the ghost bar
  ~7 cm in front of the knees. Strength by the wrist-pelvis distance, full
  within 0.85, none beyond 1.05, so the ghost never goes below the real bar
  at the floor. Stilled at the top.
- shoulders: `shouldersForward`, the bent-over rows' piece (arms and
  shoulders 0.11 torso lengths along the lifter's forward axis, here mostly
  toward the floor). Stilled at the **bottom**: drawn there it reads as the
  mistake text says, the shoulders dropped and the arms hanging from them
  to the bar, hunched over it; at the top, with the elbows drawn back past
  the torso, the same shift is an unclear zigzag over the upper back.
- No turn: all five faults are in the lifter's sagittal plane, which the
  rear three-quarter framing shows (the Barbell Bent-Over Row's faults
  don't turn either). None is about tempo.

## Close-Grip Bench Press

### What the model does

- Framing `.bench` (yaw -1.0, zoom 0.66, offset -0.05/0.04/0.08), as the
  Barbell Bench Press: feet on the left of the frame, head on the right.
- Flat bench, pad 0.36 m wide and 0.53 m high, no rack. Head, upper back
  and hips on the pad; feet flat on the floor (shoe soles at 0.001 m), set
  wide: ankles 0.54 m apart, wider than the shoulder joints (0.39 m) and
  three times the hip-joint spacing (0.18 m), ahead of the knees (knees
  129°). Hence "set wider than your shoulders" in the setup and the feet
  cue.
- Grip: overhand, thumbs wrapped round the bar; the wrists 0.38 m apart,
  directly above the shoulder joints (0.39-0.40 m apart): about shoulder
  width, ~95-100% of the shoulder breadth, the width Lockie 2017 (95%) and
  Larsen 2020 (100%, 0.40 m) used for the narrow grip.
- Elbows 33° at the bottom (0 s, 4 s) and 142° at the top (1.33-1.5 s). The
  upper arms stay 2-10° out from the sides; at the bottom the elbows point
  toward the hips, 26 cm down the body from the shoulders, just below the
  bench top beside it ("elbows pointing toward your hips"). The near elbow
  stays in view at the bench edge all rep; the far elbow is below the pad
  top and hidden behind the torso at the bottom (so the elbow label tracks
  the near one, `forearm_L`).
- Bar: touches the lower chest (bar axis 0.2 cm from the sternal pec
  surface, ~13 cm toward the feet from the shoulder joints, 4-5 cm above
  the pec's lower edge; the skinned chest surface drops away at z -0.21 to
  -0.22), pressed 42 cm up and 13 cm back to finish directly over the
  shoulder joints (hand vs shoulder offset 0.0 m at the top): the J path the
  copy describes. The copy says "lower chest" throughout (the earlier
  "bottom of your breastbone" named a point lower than the model's touch,
  toward the fault).
- Timing: up 0-1.33 s, held to 2.0 s, lowered over ~2 s, touch and go.
- **Not shown, so not claimed:** full lockout (the model stops ~40° short
  of straight arms; ExRx says to press "until arms are straight", so no
  cue asks for or against a lockout); straight wrists (the model's wrists
  are bent back 20-51°: -33° at the bottom, -51° mid-descent, -20° at the
  top; the Barbell Bench Press model's are -12 to -27°), so the Barbell
  Bench Press's wrist cue and ghost are not reused; a rack (none in the
  model, so the setup does not unrack).
- Highlight tiers: bright the three triceps heads; dim the clavicular,
  sternal and abdominal pec and the anterior deltoid.

### Claims and sources

- GRIP cue. "A grip about as wide as the shoulders is the usual way to shift
  the bench press toward the triceps": ExRx Close Grip Bench Press (target
  triceps, "shoulder width grip"); Lockie 2017 (introduction: "The CGBP is
  typically performed to place greater emphasis on the triceps brachii
  versus other prime movers such as pectoralis major or deltoids ..., as
  there is less shoulder abduction during this exercise"). "In EMG studies,
  triceps activity was higher than with a wide grip, though not clearly
  higher than with a medium one, while the chest changed little":
  Saeterbakken 2021 (all subjects: triceps lower with the wide grip than
  the medium, p = 0.004, and narrow, p = 0.008, grips, "no difference ...
  between narrow and medium grips (p = 0.897)"; in trained men the wide grip
  was 10.6% below the medium; "Similar muscle activity was observed in
  pectoralis major ... between the three grip widths"); Larsen 2020 (medial
  triceps higher with medium and narrow than wide; pec and front delt no
  different); Mausehund 2022 ("up to 15% larger EMG activity of the lateral
  head of the triceps brachii for the narrow and medium grip widths compared
  with the wide grip width", a difference the authors call "relatively
  small"; sternal pec no different across conditions); Lehman 2005 (wide to
  narrower raised triceps and lowered the sternal pec, "small changes";
  Mausehund notes Lehman even found narrow above medium, hence "not clearly"
  rather than "not"); Tanimoto 2023 (40 vs 81 cm: "the EMG PM/TB was almost
  unchanged by hand width"). "Much closer than that can bend the wrists
  sideways and make the bar harder to balance": ExRx ("may tend to
  hyper-adduct wrist joint, and unnecessarily decrease stability of bar"),
  expert opinion, hence "can". **Dropped:** "shorten the press" (ExRx's
  "decrease range of motion"): measured data point the other way (Lockie
  2017 close-grip bar travel 0.43 vs 0.41 m for the preferred grip;
  Mausehund 2022 narrower grips gave larger elbow flexion and range of
  motion). Model: hands right above the shoulders.
- ELBOW cue. "Tucked upper arms keep the shoulders in the low-abduction
  position the close grip gives: in one study, a grip at shoulder width
  kept the shoulders less abducted than medium and wide grips": Larsen 2020
  ("the narrow grip width had a significantly lower shoulder abduction angle
  than the medium and wide grip widths in all events"; narrow = the
  shoulder (biacromial) width, 0.40 m). "In another, flaring the elbows at
  the same close grip opened the shoulders out about as far as a medium grip
  and put more load through the elbows, without shifting the work to the
  chest": Mausehund et al. 2022 (35 strength-trained adults, 6-8RM, narrow
  grip ~112% of biacromial width with the elbows close to the body, BPNI, or
  away from it at ~45° abduction, BPNO; shoulder abduction at the bottom
  BPNI 37.9°, BPNO 56.5°, medium grip 59.3°, BPNO vs medium the only pair
  not different; "the 7-11% larger elbow NJMs elicited when keeping the
  elbows away from the body"; Table 3 BPNI vs BPNO mean %MVIC, sternal pec
  51.5 vs 50.3, clavicular pec 59.6 vs 56.3, abdominal pec 54.6 vs 53.7,
  lateral triceps 76.0 vs 77.9, long-head triceps 58.6 vs 61.1, none
  significantly different). The earlier "the chest tends to take more of
  the press" (from ExRx Bench Press Analysis's "may" / "is thought to") is
  withdrawn: Mausehund measured it and found no shift. Mausehund's authors
  also suggest the elbows out for "targeting the elbow extensors even
  more", so the copy no longer claims tucking gives the triceps a bigger
  share; the tuck rests on the close grip's low shoulder abduction and the
  lower elbow load. Correct text: ExRx close grip ("Lower weight to chest
  with elbows close to body"). Comparison ELBOWS FLARED: correct note from
  Larsen (low abduction; "the low-abduction position the close grip gives",
  as in the why, rather than "is for": the grip's stated purpose is the
  triceps emphasis, the low abduction is what it produces) and the model
  (bar to the lower chest); mistake
  note from Mausehund ("opens the shoulders out toward a regular bench
  press": BPNO abduction no different from the medium grip; "put more load
  through the elbow joints without moving work to the chest").
- BARPATH cue. "The lower chest is where the bar meets the body" with the
  elbows tucked: ExRx close grip (lower to the chest, elbows close to the
  body) and the model's touch point. "Pressing up and slightly back ends
  each rep with the bar balanced over the shoulder joints": ExRx Bench Press
  Analysis ("As the barbell is raise[d], it is positioned over the shoulders
  in the path of a J"); the model finishes directly over the shoulders. "In
  a film study of expert and novice benchers, the experts kept the bar's
  path closer to the shoulders": Madsen & McLaughlin 1984 ("the expert group
  used a bar path closer to the shoulders"). "Letting it drift down onto the
  stomach takes it further away": geometry. Correct text "Lower the bar to
  your lower chest": the model's touch point (see above).
- SCAPULA cue. "Shoulder blades held back and down against the bench are
  thought to give the press a stable base and to ease the forward push on
  the front of the shoulder at the bottom of the rep": ExRx Bench Press
  Analysis ("Retracting the scapula during the bench press (1) forms a more
  stable base of support against the bench, (2) decreases anterior forces
  through the shoulder in the lower position"), which cites no study for
  it, hence "are thought to". Model: shoulders held still on the pad.
- FEET cue. "Feet planted apart on the floor give the press a stable base":
  ExRx Bench Press Analysis ("Placing the feet apart on the floor creates a
  more stable base of support"). "In one study, pressing with the feet held
  up off the floor made every measured muscle work harder, the abdominals
  included, which the authors put down to the body being less stable
  without the feet's support": Muyor 2019 (60% 1RM, a 150% biacromial grip,
  a regular rather than close-grip press; feet on the ground vs hips and
  knees flexed at 90° with the feet off the ground: "significantly greater
  muscle activation of all evaluated muscles"; discussion: "These results
  may be due to the greater instability generated in the exercise to be
  executed without the support of the feet on the ground"; the abdominal
  rise "due to the need to stabilize the core"; the authors'
  interpretation, not measured). Final check 2026-09-30: the earlier
  wording, "steadying the trunk", fitted only the abdominal part of that
  explanation, so it now follows the discussion's instability sentence. "Feet flat with the hips, shoulders and head on
  the bench is the standard set-up, the one used in studies of this lift":
  Lockie 2017 ("feet flat on the floor, and their head, shoulders, and
  buttocks flat to the bench", written for the traditional press, then "The
  body position and parameters that determined a successful lift were the
  same" for the close-grip press); Mausehund 2022 (narrow-grip trials: "The
  buttocks were to be kept in constant contact to the bench and the feet
  placed against the floor"); Saeterbakken 2021 ("The head, shoulders, and
  buttocks had to be in contact with the bench during the entire lift", feet
  width self-selected). Model: feet flat, ankles 0.54 m apart (correct text
  "set wider than your shoulders").
- Activation (Triceps Brachii P 0.86, Pectoralis Major S 0.68, Anterior
  Deltoid S 0.60). Ranks follow the model's tiers and ExRx (target triceps;
  synergists anterior deltoid, sternal and clavicular pec,
  coracobrachialis). **Flag (triceps primary, pec secondary):** EMG does not
  show the pecs dropping to a clearly lesser role: in the standard-grip
  bench press the triceps and pecs are similarly active (Stastny 2017); a
  close grip shifts that only a little (Lehman 2005: triceps up, sternal pec
  down, "small changes"; Saeterbakken 2021 and Larsen 2020: pec unchanged
  across widths; Tanimoto 2023: the pec-to-triceps ratio "almost unchanged
  by hand width"). The close-grip figures themselves: Saeterbakken 2021
  narrow grip, all subjects, triceps 70.3, anterior deltoid 90.0,
  clavicular pec 88.0, sternal pec 100 %MVIC; Mausehund 2022 narrow grip
  with the elbows in, lateral triceps 76.0, long-head triceps 58.6,
  anterior deltoid 61.4, pec 51.5-59.6 %MVIC. %MVIC is not comparable
  between muscles, so these fix no rank, but none shows the triceps clearly
  above the pec. So the pec's "secondary" reflects the lift's usual
  emphasis and the model's paint; its fraction sits at the top of the
  moderate band and the grip cue says the chest "changed little". **Front
  delt:** the close-grip studies do not rank it below the pec (Saeterbakken
  narrow grip AD 90% vs pec 88-100% vs triceps 70% MVIC; Mausehund:
  narrowing the grip raised anterior-deltoid EMG; Larsen: no grip effect on
  the front delt), so it sits mid-band at 0.60 (raised from 0.48). The
  fractions are estimates.
- Stabilisers: "rotator cuff", "serratus anterior", "core" (as the Barbell
  Bench Press), "biceps brachii" (ExRx dynamic stabiliser).
- Setup steps: from the model (flat bench, head, upper back and hips on the
  pad; feet flat, set wider than the shoulders; overhand grip about
  shoulder-width; shoulder blades set; bar held over the shoulders). No rack
  step.

### Ghosts

- grip: `closeGripHandsTogether.seen(0.6)`: each hand 0.2 torso lengths
  (~12 cm) in, ~14 cm between them (checked offline: wrists at x ±0.072 m),
  the elbows left, so the forearms slant in. The same all rep. Stilled at
  the **top** and **turned 0.6 rad** toward the foot end like the elbow
  fault (simulator QA: at the bottom in the `.bench` view the ghost elbows
  splayed beside the chest and the hands' 10 pt moves ran partly along the
  line of sight, a tangle over the torso). At the top, turned, the bar runs
  across the screen and the ghost forearms converge on its middle in open
  space, each wrist ~20 pt in from the real one (real grip 65 pt wide,
  ghost 24 pt).
- elbow: `elbowsFlared(45).seen(0.6)`, the bench presses' piece with a
  larger turn: the upper arms swing 45° further out from 2-10°, the hands
  staying put. **Turned 0.6 rad** (to yaw -0.4, toward the foot end) while
  it shows: in the `.bench` view (yaw -1.0) the lifter's side-to-side and
  head-to-feet axes both run across the screen, so the far elbow's flare
  cancelled on screen (1.8 pt) and the near elbow's 39 pt move looked like
  sliding toward the head. Re-solved offline at 0.6: the near ghost elbow
  moves +40 pt and the far one -19 pt at 0 s (+42/-23 pt at 3 s), so the
  two visibly spread apart; the plates stay in frame, the bar's sleeve ends
  just reach the edges. Stilled at the bottom, where it shows most (it
  vanishes as the arms straighten).
- barpath: `closeGripBarLow.seen(-0.5)`: hands and elbows 0.30 torso lengths
  toward the feet and 0.075 down at full strength, then the elbows re-seated
  (moving the elbows first keeps them bending toward the feet: see the
  second simulator pass below); strength grows
  with the left wrist to pelvis distance (`.between("hand_L", "pelvis",
  from: 0.17, to: 1.27)`): 0.53 at the bottom (0.75 torso lengths), so the
  ghost bar sits ~9.4 cm toward the feet and ~2.4 cm down, over the upper
  stomach (wrist z -0.265 -> -0.171 m), and 1.0 at the top. Re-solved
  offline: the ghost wrist goes from z -0.171 to -0.217 m over ~40 cm of
  rise, only ~4.6 cm toward the head, so it is pressed straight up and ends
  over the upper stomach while the real bar comes 13 cm back over the
  shoulders (the earlier fixed offset followed the model's own J path).
  Ghost elbows 51° at the bottom, 136° at the top, within reach. **Turned
  -0.5 rad** (to yaw -1.5, nearly side-on from the left): in the `.bench`
  view the 16 pt shift ran along the 41 pt bar segment and could read as
  the hands sliding along the bar; at -0.5 the bar is end-on (7 pt) and the
  19.5 pt shift reads as down the body. Stilled at the **top** (simulator
  QA: at the bottom, at half strength, the ghost stood on the real arms
  ~15 pt away; at the top, at full strength, the ghost upper arms lean
  ~42° toward the feet and its forearms stand upright under a bar over
  the upper stomach, while the real forearms lean back over the
  shoulders, the wrists ~33 pt apart).
- scapula: `benchShoulders` and feet: `benchFeet.seen(-0.5)`, the Barbell
  Bench Press's pieces. The scapula ghost is stilled at the top (the
  shoulders rolling up as the bar goes up), feet at "any". The feet ghost
  is **turned -0.5 rad** (side-on, like the bar path): in the `.bench` view
  the far foot's toes run past the viewport's left edge and the ghost's
  far toe with them (simulator QA); side-on both feet sit inside the frame
  (the ghost toe ~9 pt in from the edge on the simulator) and the heels
  (~18 pt) and hips (~14 pt) lift straight up the screen.

## Label layout

`python3 preview_1_50.py compound` output checked against the stills with
the pills drawn on them (widths from gen.py, 24 pt high):

- Pendlay Row: "Back near level, still" top left and "Flat back, knees
  bent" top right (row 0.16): the torso leader passes right of the head to
  the chest joint (0.68, 0.38), the flat-back leader drops onto the lower
  back (0.77, 0.40) from above instead of crossing the legs. "Shoulders
  back" left at row 0.24, clear of the head and of the torso leader, leader
  to the near shoulder blade (0.52, 0.34); it was "Shoulders held back"
  until the simulator showed that pill covering the back of the head in
  the mistake view, where the lifter shrinks and rises (the shorter pill
  ends ~11 pt short of the head there; its leader still crosses the top of
  the head in that view, since the head rises to the pill's row, and no
  other free row avoids a crossing with the torso or flat-back leader).
  "Bar back to the floor" (0.70, override 0.75) and "Row to the lower
  chest" (0.80, override 0.86) bottom left, below the near plate's lowest
  point (v 0.66): floor to the near wrist, on the bar; pull to the near
  elbow, which drives up past the back at the top of the rep. The floor
  leader rises almost straight up from its pill's end to the near fist,
  grazing the near plate's inner rim; the pull leader passes ~14 pt right
  of the floor pill's end (bottom of the rep) and crosses no other leader
  (checked at all eight joint samples and painted on the simulator
  stills). (Simulator QA: the floor label used to track the far wrist and
  the pull label the near one; the far wrist is hidden behind the near leg
  all rep, so the floor dot sat on the near knee at the bottom and
  mid-thigh at the top, never on the bar.)
- Close-Grip Bench Press: "Elbows tucked to the sides" top left and "Hands
  shoulder-width" top right (0.16), above the plates' highest point
  (v 0.29); the elbow leader drops to the near elbow at the bench edge
  (0.57, 0.51 on average), staying left of the grip leader, which goes down
  to the near wrist; neither crosses a plate. "Shoulders pinned" (0.72) and
  "Bar to lower chest" (0.80) right, under the bench top, the lower label's
  leader passing left of the upper label's inner end; "Feet planted" bottom
  left under the shoes (soles at v ~0.78).

## Review changes (2026-09-30)

Applied after a citation review and a model-fidelity review, each finding
checked first (Mausehund 2022 read in full; Saeterbakken, Lockie, Muyor,
Moseley, Fenwick, StrengthLog and ExRx re-read; ghosts re-solved offline;
labels redrawn on the stills). All findings were applied; the rotator cuff
went in as a PRIMARY activation row (the reviewer's first option) rather
than staying a stabiliser, and the Pendlay lats fraction came down to 0.58
so no secondary row outranks the new primary one. Green & Comfort 2007 was
removed from the spec header: it backed no claim in the copy.

## Final check (2026-09-30)

The eleven journal citations re-checked against PubMed (and the Larsen,
Mausehund and Muyor full texts for the shoulder-abduction, elbows-in/out
and feet-up figures), and the StrengthLog and ExRx quotes against the saved
pages: each exists as cited and supports its claim. Activation ranks
match the highlight tiers of both models; ghosts re-solved offline at their
moments and drawn over the stills (all read as the mistake text says).
Small edits: the feet cue's why now gives Muyor's own explanation (less
stability without the feet's support) instead of "steadying the trunk";
the comparison's correct note says the close grip "gives" the low
abduction rather than "is for" it; the layout notes now describe where the
far-wrist floor dot really lands.

## Simulator QA, second pass (2026-09-30)

Built with the current family files integrated and shot on the iPhone 17
Pro simulator: the trainer at 0, 1 and 3 s, each ghost at its moment, and
every ghost again at two or three other moments of the rep.

- Fixed: the bar-path ghost's elbows bent the wrong way at the top, its
  still. `.resolve` re-seats an elbow on the side where it already is; with
  only the hands moved 18 cm toward the feet, the shoulder-to-wrist line
  swung past the real elbow, so the ghost elbow was seated toward the head
  (~44° past straight) and the hand stood up off the forearm like a hook.
  The elbows now move with the hands before re-seating: they bend toward
  the feet at every moment (checked offline at eight moments and on the
  simulator at four), the wrists are nearly straight (176°), the bar
  positions and elbow angles are unchanged.
- Checked, no change: every pill clear of the lifter's moving parts, the
  eye button and the mistake sheet; no dot on a pill, no leader crossing
  another; each ghost reads as its sheet says at its moment. The Pendlay
  shoulders leader still crosses the top of the head in the mistake view
  (see Label layout). The Close-Grip far toe is still clipped in the
  trainer view (open issue above; framing lives in SampleData.swift).
- Seen, left as is: `elbowsFlared(45)` keeps the hands put, so its ghost
  forearms are ~22% long at the bottom (the grip ghost's ~13% at the top);
  on screen they read as normal arms. `shouldersForward` carries the wrists
  ~6 cm down with the shoulders, so at the bottom they sit on the real bar,
  where a real bar could not go (the plates are 3.6 cm off the floor); the
  ghost draws no bar or plates, so it only reads as the arms hanging lower.
