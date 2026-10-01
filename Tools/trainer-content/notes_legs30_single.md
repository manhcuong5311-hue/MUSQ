# 30-leg set: heel-elevated, cyclist and pistol squats (2026-09-28)

Four exercises from the 30-leg set (family "single"):
`spec_legs30_single.py` holds the copy,
`Tools/fault-review/faults_legs30_single.swift.txt` the ghosts and
`Tools/fault-review/fault_moments_legs30_single.json` their still moments. The
spec header lists the full citations; this file maps each claim in the copy to
them and records what the models show.

## Shared facts about the models

- Briefs: `briefs_legs30/{HeelElevatedSquat,CyclistSquat,PistolSquat,AssistedPistolSquat}.md`;
  stills `<Slug>_{a_start,b_mid,c_bottom,d_rep2}.png`; wedge geometry read
  from the USD meshes; foot pitch from the foot bones.
- Timing (all four): two reps in 8 s, ~1.0 s down, a ~0.75 s hold at the
  bottom (deepest at 1.38 s and 5.38 s), ~1.75 s up, ~0.35 s at the top.
- Rig: torso (neck to pelvis) 0.59 m, thigh 0.44 m, shin 0.40 m, hip joints
  0.18 m apart, shoulder joints 0.39 m apart.
- Framing (probe.py JOBS): heel-elevated and cyclist yaw -1.0 (three-quarter
  from the left), pistol -1.2, assisted pistol -1.6 (side-on from the left).
- The pistols stand on the LEFT leg for both reps; the right leg is the free
  leg. Their cue dots use `_L` for the standing leg and `foot_R` for the free
  foot. No leg switch, so no `_front`/`_back` or `_bent`/`_straight` roles.
- These rigs have no toe joints (`toe_L/R` probe as empty lists), so no cue
  or glow uses them.

## Heel-Elevated Squat

Model: high bar (bar centre level with the neck joint, ~6 cm behind it),
hands ~0.78 m apart. Two wedges, each ~20 x 36 cm, tilted ~12 deg (top ~9 cm
at the heel end, ~2 cm at the toe end); the whole foot on the wedge, pitched
~12 deg toe-down, the ankle ~4 cm above its flat-floor height. Ankles 0.42 m
apart (shoulder width), toes out ~14 deg. Bottom: knees 51 deg, hips 73 deg,
thighs about parallel, shins 48 deg forward, knees ~30 cm ahead of the ankles
and straight forward over them (0.40 m apart over ankles 0.42 m apart), i.e.
~8 cm inside the line of the turned-out toes (see Model notes). Bar over
mid-foot at the bottom (z 0.14). Trunk 5 deg at the top, 25 deg at the
bottom. Heels never leave the wedges.

Claims and sources:
- Bar high on the traps keeps the torso upright over the raised heels:
  mechanics of a high bar (the bar sits closer over the hips) and the
  variation's purpose. Review 1 removed the sentence citing Larsen 2021's
  high-bar narrow-stance result here: Larsen's narrow stance was 0.7x
  acromion width (narrower than shoulders), this model stands at shoulder
  width, and the old wording ("the largest share of the work on the knees")
  misread a relative result (see the Cyclist Squat section).
- Wedge: "tilting the foot lets the shin lean further forward before the
  ankle runs out of bend": mechanics (the wedge plantar-flexes the foot, so
  the same ankle range allows more forward shin angle; the model's foot is
  pitched ~12 deg). "So the knees can travel forward and the trunk stay more
  upright": Legg 2017 (weightlifting shoes: more knee flexion; more upright
  trunk and greater knee moment unloaded), Sato 2012 (trunk lean 22 mm less),
  Charlton 2017 (2.5 cm block: less forward trunk flexion at peak knee
  flexion), Cai 2026 (0-5 cm: less trunk inclination, more knee flexion and
  tibial progression), Ghasemi 2026 (cited for more knee range; its pooled
  hip and trunk range did not change, and only a meta-regression linked
  higher heels with less hip and trunk range; its ankle result, more range,
  is not used for this sentence). "Higher heels put more demand on the knee
  extensors": Cai 2026 (knee moment rose with elevation; the authors' own
  caution about excessive elevation).
- Torso cue: hips sink more straight down and the trunk stays more upright
  than flat-footed: same sources (Charlton, Sato, Legg, Cai). "Keeps the bar
  over the middle of the foot": mechanics of a more upright trunk; not
  measured as such.
- Knee tracking: knees caving often reflect poor hip control (Powers 2010,
  "often", not always); "in one study, limiting how far the ankle could bend
  made it cave more": Macrum 2012 (a 12 deg forefoot wedge increased knee
  valgus and medial knee displacement in the double-leg squat); "a wedge lets
  the shin lean further before the ankle runs out of bend": mechanics, as
  the wedge cue. Intro "the knees travel forward over the feet, never caving
  inward" (review 1 dropped "and out in line with the toes", which the
  heel-elevated model does not show). No study
  showed heel elevation reducing valgus directly, so the copy does not claim
  it.
- Depth: Caterisano 2002 (gluteus maximus share rose with depth), Kubo 2019
  (full squats grew the gluteus maximus and adductors more than half squats;
  knee extensors similar). "The wedge lets the hips sink between the heels
  while the chest stays up": Cai 2026 (more knee and hip flexion, less trunk
  inclination).
- Activation (Quadriceps HI 0.90, Gluteus Maximus MOD 0.60, Erector Spinae
  MOD 0.43; review 1 raised them from 0.58 / 0.36): no EMG study of a barbell
  squat on a 12 deg wedge at this depth. Ranked from the library's Back Squat
  (0.90 / 0.62 / 0.45) and kept close to it, because the EMG that exists
  shows no clear change: Charlton 2017 found no peak or RMS difference in
  muscle activity with the heel block; Bozkurt 2026 (5 cm blocks, 70% 1RM)
  found vastus lateralis and medialis higher flat and heel-elevated than
  forefoot-elevated, not a gain from the heel block; Cai 2026 (loaded, n=30)
  reports that "selected muscle activities" and co-contraction increased with
  elevation (which muscles could not be read from the abstract). Gluteus
  maximus only a touch lower: Charlton's lower peak hip moment is offset by
  Cai's unchanged hip moments and by full depth (Caterisano). Erector spinae
  only a touch lower for the more upright trunk (Charlton, Sato, Legg) and
  Cai's lower modelled L3-L5 stress; the library's upright Front Squat sits
  at 0.50, so an upright trunk is not treated as much less erector work.
- Stabilisers adductors, hamstrings, calves, core: as the Back Squat entry.
- Comparison TORSO TIPS FORWARD: the wedge's main measured effect is the
  more upright trunk (Charlton, Sato, Legg, Cai). "The bar over mid-foot":
  the model's bar ends at z 0.14, mid-foot ~0.15.
- Label "No knee cave" (review 2; review 1 had "Knees track toes", before
  that "Knees over toes"). With the toes turned out 14 deg, a knee can only
  track its toes by moving out, and this model's knees go straight forward
  over the ankles, so the label now says only what the model shows: the
  knees never cave. The correct text keeps the textbook instruction (each
  knee over the middle toes); see Model notes.
- Setup: two wedges or a slant board (the model uses two), feet about
  shoulder width, toes slightly out (model: 0.42 m, 14 deg).

## Cyclist Squat

Model: the same bar, grip and wedges, the wedges almost touching. Ankles
0.21 m apart (about hip width), toes out ~7 deg. Bottom: knees 49 deg, hips
85 deg, thighs about parallel (10 deg below horizontal toward the knee, the
hip joint ~8 cm above the knee joint; not below parallel), shins 50 deg
forward, knees ~3 cm outside the ankles. Bar over the heels at the bottom
(z 0.04; see Model notes). Trunk 5 deg at the top, 15 deg at the bottom (vs 25 deg on the
heel-elevated squat at the same depth).

- No study of the "cyclist squat" by name was found (Europe PMC search for the
  term: none). Popular articles make strong claims (for example that it
  targets the vastus medialis); none is cited or repeated.
- Narrow stance lets the knees bend further: Lahti 2019 (narrow 1x vs wide
  1.5x trochanter width: more knee flexion narrow; higher hip-to-knee moment
  ratios wide), Lee 2026 (narrow: 3.7 deg more peak knee flexion). "A high
  bar with a narrow stance gave the knees a bigger share of the work out of
  the bottom, with more vastus lateralis and less gluteus maximus activity,
  than the other bar and stance combinations": Larsen 2021. The full text
  (PMC8440835) shows the high-bar narrow stance's knee contribution above all
  three other conditions only at v0, the lowest bar position at the start of
  the ascent; contributions were similar at vmax1 and dmax1, and at vmin and
  vmax2 both high-bar stances exceeded the low-bar ones. Hence "out of the
  bottom" (review 2); the abstract states the result without the event. Larsen's stances were 0.7x
  (narrow) and 1.7x (wide) acromion width; the model's 0.21 m ankles are
  close to its narrow stance. The hip still gave over 50% of the total moment
  at the sticking-region events in every condition, so the copy says "a
  bigger share", not most of the work (review 1). The extra vastus lateralis
  was post-sticking only, the lower gluteus maximus pre-sticking only.
  Wider stances brought the glutes in more: Paoli 2009 (only the gluteus
  maximus changed, higher at the widest stance), McCaw 1999 (stance changed
  the adductor longus and gluteus maximus; quadriceps activity changed with
  load only, so stance does not isolate the quadriceps). Lee 2026 found no
  combination consistently favoured any muscle, and a WIDE stance raised
  peak and cumulative vastus medialis activation, the opposite of the
  popular cyclist-squat claim; the copy speaks of the share of the work
  (moments) and never promises a bigger quadriceps stimulus.
- Knee travel: blocking the knees behind the toes moved load to the hips and
  lower back (Fry 2003); the raised heels let the shins lean forward (Legg,
  Cai). "The knees take a larger share of the work": Larsen 2021, Cai 2026.
  Comparison note "more of the work on the quadriceps" (review 1; was "the
  work on the quadriceps").
- Knee tracking, heels on the wedge: as the heel-elevated squat. Label
  "Knees track toes" (review 1; was "Knees over feet"), kept in review 2:
  the cyclist model's knees do follow its 7 deg toe-out (~3 cm outside the
  ankles at the bottom).
- Depth: Kubo 2019, said honestly: full squats grew the glutes and adductors
  more, the quadriceps about the same. The correct text asks for "at least
  parallel, the backs of the thighs close to the calves" (review 1; was
  "below parallel", which the model does not reach). "If your knees are sensitive, build up
  the depth gradually": general caution; deep knee flexion with a forward
  knee raises the knee moment (Cai 2026), not presented as harmful.
- Activation (Quadriceps HI 0.90, Gluteus Maximus MOD 0.48, Erector Spinae
  MOD 0.41; review 1 changed them from 0.92 / 0.48 / 0.30): the quadriceps
  level with the heel-elevated squat, since no stance study found more
  quadriceps activity with a narrow stance (McCaw 1999: quadriceps changed
  with load only; Paoli 2009: only the gluteus maximus changed; Lee 2026:
  more vastus medialis WIDE; Larsen's extra vastus lateralis post-sticking
  only). Gluteus maximus lower (Paoli, McCaw, Larsen pre-sticking). Erector
  spinae only a touch below the heel-elevated squat for the 15 deg trunk, as
  argued there. Uncertain in size.
- Comparison HIPS SIT BACK: Fry 2003 (restricting knee travel shifts some of
  the load to the hips and lower back) and the variation's purpose. The
  mistake note says it "shifts more of the work" there (review 2; was "hands
  the work", which overstated Fry).

## Pistol Squat

Model: LEFT leg standing (foot flat all clip, toes out ~5 deg), pelvis ~4 cm
inside the standing ankle, no sideways lean. RIGHT leg free: knee 174 deg
all clip, toes pulled up, at the top resting forward with the heel just off
the floor (ankle ~27 cm ahead), rising to about hip level at the bottom
(ankle ~0.43 m high, ~0.78 m ahead). Arms straight out in front, hands
~12 cm below the shoulders at the top and ~30 cm below them (44 cm ahead,
~34 deg below horizontal) at the bottom, pointing toward the free foot.
Standing knee 156 deg at the top, 45 deg at the bottom, hip 79 deg, the back
of the thigh on the calf; the shin 65 deg forward, the knee ~36 cm ahead of
the ankle and ~3 cm outside it. Trunk 8 deg at the top, 30 deg at the bottom;
at the bottom the neck is ~13 cm behind the knee. Pelvis drops 51 cm and
ends ~6 cm behind the ankle joint, over the heel.

- No EMG study of the pistol squat as such was found (Europe PMC "pistol
  squat": no EMG study; one academia.edu upload on hamstrings and "decline
  angle" whose peer review could not be confirmed, not cited). Closest:
  - Khuu 2022: single-leg squats as low as possible with the free leg in
    front ("similar to a pistol squat"), middle or behind; gluteal activity on
    the descent greater with the leg in front (and middle) than behind; tensor
    fasciae latae greatest in front. Raw EMG, no %MVIC. Arms at or out to the
    sides, unlike the model.
  - Mausehund 2019: barbell single-leg squat vs split squats at 6-8RM: vastus
    lateralis and gluteus maximus peaks no different; gluteus medius highest
    (81.9% vs 54.9% RFESS, 46.2% split squat); H:Q 0.63. Only the abstract
    could be read (the PDF text was not extractable), so its set-up (box, free
    leg) is not claimed.
  - Boudreau 2009: rectus femoris, gluteus maximus and stance-side gluteus
    medius rose from step-up-and-over to lunge to single-leg squat.
  - DiStefano 2009: single-limb squat and single-limb deadlift drew the most
    gluteus maximus of 12 exercises.
  - Monajati 2019: single-leg squat on a 30 cm bench to ~60 deg knee flexion
    drew more hamstring and vastus medialis activity than the double-leg
    squat (far shallower than a pistol).
  - StrengthLog Pistol Squat guide: quadriceps and glutes primary,
    hamstrings secondary; free leg straight and off the ground; arms forward
    for balance; chest up; lower as far as you can with control; press
    through the heel.
- Activation (Quadriceps HI 0.90, Gluteus Maximus MOD 0.64, Gluteus Medius
  MOD 0.62, Hamstrings MOD 0.40): quadriceps first (Mausehund H:Q 0.63,
  Boudreau, StrengthLog); gluteus maximus close behind, a little above the
  split squats' 0.62 for the deeper hip bend and the free leg in front
  (DiStefano, Khuu, Mausehund); gluteus medius well above the split squats'
  0.40 and about level with the maximus (review 1; was 0.58): both cited
  single-leg squat studies put it at or above the maximus (Mausehund: medius
  81.9% MVIC, maximus 71-79% as read for the split squat notes; DiStefano:
  single-limb squat medius 64%, maximus 59% MVIC). It sits a hair below the
  maximus only because a full pistol bends the hip further than those
  squats, and depth raises the maximus share (Caterisano 2002); cross-muscle
  %MVIC comparisons are rough. Hamstrings moderate (Mausehund H:Q,
  Monajati). Hip flexors (holding a straight leg up in front with the hip
  bent: mechanics and coaching convention; StrengthLog does not list them),
  adductors, calves and core as
  stabilisers ("hip flexors" is free text in the stabiliser list; an
  iliopsoas activation row would be dropped by the app's MusclePart
  mapping, and a rectus femoris row would be filed under the quadriceps).
- Standing foot: heel down, weight over mid-foot (StrengthLog: press through
  the heel). "How far the ankle can bend is one of the things that limits
  squat depth": Kim 2015 (dorsiflexion with the knee bent and hip flexion
  range predicted squat depth in men; double-leg squats). The thin plate
  under the heel and working shallower are coaching conventions, backed only
  indirectly by the heel-elevation studies above.
- Knee tracking: hip muscles hold the thigh on one leg (Powers 2010,
  Mausehund gluteus medius). "Knee travel well past the toes is expected
  here": mechanics of a full single-leg squat (the model: knee ~36 cm ahead
  of the ankle). Fry 2003 shows only that restricting knee travel in the
  squat shifts load to the hips, in a double-leg squat with the knees
  slightly past the toes; it is not evidence for travel well past them.
  Label "Knee tracks toes" (review 1; was "Knee over toes").
- Free leg: hip flexor strength to hold it and hamstring flexibility to
  keep a straight leg raised with the hip bent (mechanics and coaching
  convention, not a study; StrengthLog says only that the free leg stays
  straight and off the ground); more glute work on the descent with the leg
  in front than behind (Khuu 2022).
- Counterbalance: arms, chest and free leg reach forward to keep the weight
  over the foot while the hips sit back over the heel (mechanics: the
  model's pelvis sits ~6 cm behind the standing ankle joint at the bottom,
  the hands ~0.64 m ahead of it); StrengthLog (arms forward for balance).
  Correct text (review 1): arms "a little below shoulder height and lower
  toward the free foot as you sink", the chest leaning "toward the knee"
  (the model's shoulders stay ~13 cm behind it). "A forward trunk lean is
  part of the lift here": the model leans 30 deg. StrengthLog's "chest up"
  is set aside for this reason: at full pistol depth the counterbalance
  needs the lean, and the mistake is now worded as the arms dropping and the
  trunk rocking back (the weight falling behind the heel), not as an upright
  chest.
- Depth: full range on one leg; the pause mirrors the model's ~0.75 s hold.
  Progressing with a support or a box is coaching convention (StrengthLog
  does not mention supports, boxes, heel plates or ankle mobility).
- Comparison KNEE CAVING IN: Mausehund (gluteus medius demand on one leg),
  Powers 2010.
- Difficulty advanced: the full bodyweight pistol needs strength, balance
  and ankle range on one leg.

## Assisted Pistol Squat

Model: the pistol's legs, trunk and timing exactly (the same numbers every
0.5 s). Hands on a crossbar at ~1.2 m, ~0.44 m apart, 0.48-0.53 m ahead of the
standing ankle. The crossbar runs across in front of the lifter (x -0.42 to
0.42 m) and is fixed at its left end to an upright off to the lifter's left
(x 0.34-0.41, z 0.61-0.68), cantilevered from it. Elbows bent all clip (122-127 deg at the top, 90-98 deg on
the way down, 106-113 deg at the bottom).

- No study of a hand-assisted single-leg squat was found (Europe PMC
  searches for assisted, supported, suspension single-leg squats: none).
- Activation (Quadriceps HI 0.84, Gluteus Maximus MOD 0.58, Gluteus Medius
  MOD 0.47, Hamstrings LOW 0.36): the pistol's ranks a step lower because
  the hands take some of the weight and most of the side-to-side balance.
  The gluteus medius drops most; this is an analogy, not a measurement:
  McCurdy 2017 (Strength Cond J 39(6):93-97, a technique column, not an EMG
  study) notes the Smith machine reduces frontal-plane muscle activation.
  Scaled with the pistol's medius (0.44 -> 0.47, review 1). Uncertain in
  size; with the model's pose unchanged from the free pistol, how much help
  the hands give is not shown.
- Support cue ("hold"), rewritten in review 1 as over-reliance, not arm
  position. The common way to teach an assisted pistol (pole, door frame,
  suspension trainer) is to hold on with straight arms and sit back against
  the support as a counterweight; with a bar in front at chest height the
  arms then mostly pull horizontally and the leg still carries nearly all
  the weight, so a straight-arm hold is not a fault. The fault is pulling
  up with the arms out of the bottom, so the leg does less of the lifting.
  Coaching convention, no study. The intro no longer says "elbows bent" as
  a rule; the model happens to keep them clearly bent (90-127 deg), and the
  setup step describes that set-up (a little less than arm's length from
  the bar, elbows bent) as one way to stand, not the only one.
- Depth: the support makes full depth reachable before it can be balanced
  alone (convention).
- Foot, knee and free-leg cues shared with the pistol (same sources).
- Difficulty intermediate: the regression of the pistol.
- Comparison PULLING ON THE BAR / "Leg drives, hands steady" / "Arms pull
  the body up" (review 1; was HANGING OFF THE BAR, straight arms).
- Setup: the model's bar sits at about chest height at the top; "a little
  less than arm's length from it, elbows bent" matches its elbows (122-127
  deg at the top, 90-98 deg on the way down, 106-113 deg at the bottom).
  Review 2 dropped "close enough that the elbows stay a little bent": the
  model's elbows are clearly bent, not a little, and the step made a bent
  elbow a rule although the support cue accepts a straight-arm hold.

## Model notes (where the models differ from textbook technique)

- None of the four stands fully up between reps: the knees stop at 139 deg
  (heel-elevated), 135 deg (cyclist) and 156 deg (both pistols), the hips at
  153-161 deg. Coaches usually finish each rep standing tall; the copy
  neither asks for a lockout nor calls the model's top a technique, and no
  fault ghost is set at the top.
- Both pistols tip the standing shin 65 deg forward with the heel flat, the
  knee ~36 cm ahead of the ankle. That is more ankle bend than most lifters
  have; many pistol squatters reach depth with less shin angle and more
  trunk lean, or with the heel slightly raised. The copy keeps the heel down
  and offers a thin plate or a shallower range when it will not stay down.
- The assisted pistol moves exactly like the free pistol, so the arms appear
  to steady rather than lift; the copy says to use the bar only as much as
  needed.
- The heel-elevated model's wedges are single slabs per foot tilted ~12 deg,
  steeper than the 2.5 cm block in Charlton 2017 and comparable to the 5 cm
  blocks in Bozkurt 2026 and the top of Cai 2026's range; the copy speaks of
  raised heels generally.
- The cyclist squat's narrow stance still has the knees ~3 cm outside the
  ankles at the bottom (knees 0.27 m apart), in line with the feet.
- The heel-elevated model's knees track straight ahead while its feet turn
  ~14 deg out: at the bottom the knees are 0.40 m apart over ankles 0.42 m
  apart (each within 1 cm of its ankle side to side) and ~30 cm ahead of
  them, where a knee following its foot would sit ~7.5 cm outside the
  ankle, so each knee is ~8 cm inside its toe line. It never caves further.
  The correct text still coaches each knee over the middle toes (the textbook
  cue), which the model does not show. The intro says only that the knees
  travel forward over the feet and never cave, and the label (review 2) says
  "No knee cave". Review 1 argued that "Knees track toes" did not imply the
  knees moving out; with the toes turned out it does, so that label was
  replaced. The `kneesIn` ghost caves each knee another 10 cm from the
  model's already-inside position. A re-pose (each knee ~7 cm outside its
  ankle at the bottom, or the toe-out cut to ~5 deg) would let the label say
  "track toes" again; it is reported as a possible shared model change.
- The cyclist model's bar ends over the heels (z 0.04 at the bottom vs the
  ankle joint at 0.08 and mid-foot ~0.15), further back than a balanced
  squat; with the knees ~31 cm forward a real lifter there would tip
  backward. The copy says "under the bar" and makes no mid-foot claim for
  this exercise.
- The cyclist model's bottom is about parallel (hip joint ~8 cm above the
  knee joint), not below; the copy asks for at least parallel.

## Ghosts and when to still them

Framings -1.0 (heel-elevated, cyclist): sagittal faults `.seen(-0.4)` (total
-1.4), knee and stance faults `.seen(0.8)` (total -0.2). Pistol -1.2:
sagittal `.seen(-0.2)` (total -1.4), knee `faceOn` (total -0.1). Assisted
pistol -1.6: sagittal needs no turn, knee `.seen(1.4)` (total -0.2); face-on,
the upright stands at the lifter's left (x 0.34-0.41 m) clear of the standing
knee (x ~0.19 m, 0.09 m when caved) and the crossbar at ~1.2 m runs above
the knees.

Reused pieces: `barSlidLow` (split squat batch), `leanedForward(15,
withBar:)`, `kneesIn()`, `kneesIn("L")`, `heelsUp()`, `heelsUp("L")`. New
pieces (documented in the swift text): `singleSquatShallow(_:)`,
`singleSatBack`, `singleStanceWide`, `singlePistolDepth` (a strength),
`singleFreeLeg`, `singleBodyOffBar` (joint lists), `singleFreeLegDropped`,
`singleArmsDropped`, `singlePistolShallow(_:)`, `singleAssistedShallow(_:)`,
`singlePulledToBar`.

Checked with a Python port of `FaultGhost.solve` on the rigs at the bottom
(1.38 s) and the top (0.0 s):
- Heel-elevated / cyclist: `barSlidLow` takes the neck ~10 cm forward and
  the bar ~9 cm down; `singleSquatShallow(0.3)` lifts the pelvis 18 cm at
  the bottom, knees 51 -> 77 deg (cyclist 49 -> 77). Review 1 replaced
  `shallow(0.3, withBar:)` with it: `shallow()`'s knee-bend strength is
  already 46-50% at these models' tops (knees 139 / 135 deg), where it lifted
  the hips another ~8-9 cm, past the reach of thigh plus shin, so the ghost's
  legs were drawn locked and too long through the top of every rep. The new
  piece fades by the pelvis-to-left-ankle distance, 1.2 -> 0.8 torso
  lengths (top 1.37 heel-elevated / 1.33 cyclist: none; 0.5 s about 16% /
  26%; bottom 0.68 / 0.62: all), the hip-to-ankle span staying 0.52-0.69 m
  against 0.84 m of leg at every checked moment; `heelsUp` lifts the ankles ~6 cm off the wedges; `kneesIn` brings the
  knees 10 cm in each (the cyclist's to ~7 cm apart); `singleSatBack` takes
  the pelvis 9.5 cm back and the knees ~9 cm back (knee 49 -> 56 deg on the
  cyclist); `singleStanceWide` sets the ankles 0.38 m apart.
- Pistols: `singlePistolDepth` is 0 at the top (pelvis 1.39 torso lengths
  above the standing ankle), 1 at the bottom (0.54) and ~0.43 at knee 93 deg,
  so no depth, free-leg, arm or hanging ghost shows at the top, where the
  model's knee never straightens (`shallow`'s knee-bend strength would show
  27% there and push the hips past a straight leg). `singleFreeLegDropped`
  puts the free ankle at 7 cm (on the floor) at the bottom;
  `singleArmsDropped` hangs the hands by the knee with the trunk 12 deg more
  upright; `singlePistolShallow(0.4)` lifts the pelvis 24 cm, standing knee
  45 -> 82 deg; `heelsUp("L")` lifts the standing ankle ~8 cm; `kneesIn("L")`
  10 cm in.
- Assisted: `singlePulledToBar` (review 1, replacing `singleHungBack`,
  which drew the straight-arm sit-back that is a normal way to use a
  support) hauls the pelvis ~7 cm up and ~7 cm forward and the shoulders
  ~12 cm toward the bar, the trunk 6 deg further into it, the hands kept on
  the bar: elbows 109 -> 75 deg (left) and 113 -> 79 (right) at the bottom,
  shoulder-to-hand span 0.33-0.34 m against 0.54 m of arm, standing knee
  45 -> 54 deg; on the way up (2.5 s) the elbows fold 91 -> 58 deg. Checked
  with ahead/rise 0.10-0.12 and 0 or -6 deg; the -6 deg lean reads most
  clearly as pulling in. `singleAssistedShallow(0.4)` lifts the body 24 cm
  with the hands kept on the bar, the elbows re-seated.

Every cue has a ghost; none of the mistakes is about speed or force alone.

Still moments (`fault_moments_legs30_single.json`): every fault at the
bottom, except the cyclist's stance (`any`, which a leg lift reads as its
bottom; the stance fault is constant).

## Labels

Rows are written on the 0.14-0.86 scale and squeezed to 0.16-0.80 by
`spec_legs30.py`. Checked by drawing the pills and leaders over the start and
bottom stills (pill width (24 + 5.6 x characters) / 382, as gen.py lays
them out):
- Heel-elevated and cyclist: the plates sweep the upper half through the
  rep, so only the heel-elevated bar label sits above them (top row, left,
  17 characters ending at u 0.35, left of the head at 0.38-0.43); every
  other label sits at 0.56 on screen or lower, below the plates' lowest
  point (0.53-0.55). Short labels (Chest up, Full depth, Knees forward) end
  before the knees and glutes at the bottom.
- Pistols: the body fills the right half from the head down; the arm/grip
  label and the depth label ride the top rows (Full depth starts at u 0.755,
  right of the head), the knee label sits on the left between the arms at
  the top and the hands at the bottom, the free-leg and heel labels on the
  lowest row. On the assisted pistol the upright runs at u 0.29-0.343 from
  v 0.125 to 0.89, so its three left labels are 13 characters or fewer
  ("Light grip", "Knee in line", "Free leg up"; review 2): each pill ends by
  u 0.285, clear of it. The leaders still cross it to reach the hand, knee
  and free foot.
Verify in the simulator.

## Uncertain

- Cyclist squat, pistol squat and assisted pistol squat have no direct EMG
  data; their rows are extrapolated as described above.
- Heel elevation's effect on quadriceps EMG is unsettled (Charlton: no peak
  or RMS difference; Bozkurt: vasti not higher than flat; Cai: "selected
  muscle activities" rose, which ones not readable); the copy rests on
  kinematics and knee moments instead.
- Hip range with heel elevation is mixed: Cai 2026 more peak hip flexion;
  Ghasemi 2026 pooled no change, meta-regression less with higher heels. The
  copy makes no claim about hip range; "the hips sink" rests on Cai and on
  the model.
- Heel elevation's effect on the hip moment is mixed: Charlton 2017 (2.5 cm,
  minimal load) lower peak hip moment; Cai 2026 (0-5 cm, loaded) hip
  moments unchanged.
- Ankle results are mixed: Legg 2017 and Cai 2026 report less peak ankle
  dorsiflexion with raised heels; Ghasemi 2026 (meta-analysis, MD 4.33 deg,
  only above 2.5 cm or 5 deg) and Bozkurt 2026 report more ankle range. It
  likely comes down to how the ankle angle is measured (shank to foot vs
  shank to floor) and to the wedge plantar-flexing the foot, which lets the
  shin lean further before the joint runs out of range. The copy states
  only that mechanical point.
- Mausehund 2019's single-leg squat protocol could not be read.
- Cai 2026 is ahead of print (no volume or pages yet).
- ExRx was not cited: the Internet Archive was offline during this work and
  exrx.net blocks automated fetches.

## Change log

- 2026-09-28: first version. Copy, activation rows, setup, ghosts and still
  moments for the four exercises; labels laid out over the stills; claims
  tightened after the first pass (knee-caving and ankle wording, the
  high-bar narrow-stance comparison, "a larger share of the work" instead of
  "most of the work").

## Change log (review 1)

- Larsen 2021: the heel-elevated bar cue no longer cites the high-bar
  narrow-stance result (the model stands at shoulder width; Larsen's narrow
  stance was 0.7x acromion width). The cyclist stance cue now says a high
  bar with a narrow stance "gave the knees a bigger share of the work ...
  than the other bar and stance combinations"; notes record the 0.7x / 1.7x
  stances and that the hip gave over 50% of the moment in every condition.
- Assisted pistol support cue rewritten as over-reliance (pulling on the bar
  out of the bottom), not arm position; comparison PULLING ON THE BAR; label
  "Light grip on the bar"; ghost `singleHungBack` replaced by
  `singlePulledToBar`; setup step softened.
- Wedge and knee-tracking why: the "less ankle bend" wording replaced with
  the exact mechanical point (a tilted foot lets the shin lean further before
  the ankle runs out of bend); Ghasemi cited only for knee, hip and trunk;
  the mixed ankle results added to Uncertain.
- Heel-elevated activation: gluteus maximus 0.58 -> 0.60, erector spinae
  0.36 LOW -> 0.43 MOD, with Charlton's null EMG, Cai's unchanged hip moment
  and increased "selected muscle activities" recorded.
- Cyclist activation: quadriceps 0.92 -> 0.90, erector spinae 0.30 LOW ->
  0.41 MOD (same reasoning as the heel-elevated squat); Lee 2026's
  wide-stance vastus medialis increase and McCaw's load-only quadriceps
  result added.
- Pistol gluteus medius 0.58 -> 0.62 (assisted 0.44 -> 0.47), with the
  reason it sits just below the maximus.
- Hip-flexor point re-labelled as mechanics and convention, not StrengthLog.
- Pistol counterbalance: mistake now the arms dropping and trunk rocking
  back; why says the hips sit back over the heel and a forward lean is part
  of the lift; correct and setup put the arms a little below shoulder height
  and the chest leaning toward (not over) the knee.
- Knee travel "well past the toes": notes now call it mechanics, Fry 2003
  cited only for its double-leg result.
- McCurdy 2017 added to the spec header, described as a technique column;
  the gluteus medius drop called an analogy.
- Cyclist depth correct: "at least parallel, the backs of the thighs close
  to the calves" (was "below parallel").
- Depth ghosts for the heel-elevated and cyclist squats: `shallow()` replaced
  by `singleSquatShallow(0.3)` with a hip-height strength, so nothing shows
  at the models' bent-knee tops.
- Heel-elevated knee tracking: intro now "forward over the feet, never
  caving inward"; Model notes record the knees ~8 cm inside the toe line.
- Labels: "Knees track toes" (heel-elevated, cyclist), "Knee tracks toes"
  (both pistols).
- Assisted pistol crossbar described as fixed at its left end to the
  upright, not held at its middle (spec header, notes, swift comment).
- Model notes: the cyclist bar ends over the heels; the cyclist bottom is
  about parallel.

## Change log (review 2)

- Larsen 2021 checked in full text (PMC8440835): the high-bar narrow
  stance's larger knee contribution over all three other conditions holds at
  v0 (the bottom), not "the lowest bar velocity"; at vmin both high-bar
  stances exceeded the low-bar ones; similar at vmax1/dmax1. Spec header and
  notes corrected; the cyclist stance why now says "out of the bottom".
- Ghasemi 2026 (PubMed abstract re-read): pooled hip and trunk range did not
  change; only a meta-regression linked higher heels with less hip (beta
  -0.028) and trunk (beta -0.067) range. Header and notes corrected; the
  Cai-vs-Ghasemi hip range disagreement added to Uncertain.
- Bozkurt et al. dated 2026 (Crossref: Front Physiol 16:1727141, issued
  2026-01-07) in the header and every notes mention.
- DOIs added for Fry 2003 (10.1519/1533-4287(2003)017<0629:EOKPOH>2.0.CO;2)
  and Caterisano 2002 (10.1519/1533-4287(2002)016<0428:TEOBSD>2.0.CO;2),
  both confirmed on Crossref.
- Heel-elevated knee label "Knees track toes" -> "No knee cave": the model's
  knees go straight forward, ~8 cm inside its 14 deg toe line, so they do
  not track the toes. Correct text kept as the textbook instruction; Model
  notes corrected (the old label did imply the knees moving out). A re-pose
  is reported as an optional shared change. The cyclist label is unchanged
  (its knees follow its toes).
- Assisted pistol left labels shortened to 13 characters or fewer so no pill
  covers the upright: "Light grip", "Knee in line", "Free leg up". The
  "cannot be avoided" sentence removed.
- Assisted pistol setup step 2: "Hold it with both hands and stand on one
  foot a little less than arm's length from it, elbows bent." (was "close
  enough that the elbows stay a little bent"); notes line matched to the
  model's 90-127 deg elbows.
- Cyclist comparison mistake note: "shifts more of the work to the hips and
  lower back" (was "hands the work"), in line with Fry 2003 and the
  correct note.
