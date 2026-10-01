# Batch 241-300 (2026-09-27): wrist curls, reverse wrist curls and the finger curl

Seven exercises, written to what each model shows. Copy lives in
`spec_241_300_wrist.py`, ghosts in
`Tools/fault-review/faults_241_300_wrist.swift.txt`. Model numbers come from
the briefs and from the USD itself (joints and the equipment's bounds over the
clip, read with Blender's Python); torso length (neck to pelvis) is 0.59 m.

## Sources (short names used below)

- **Neumann** — Neumann DA, *Kinesiology of the Musculoskeletal System*, 3rd
  ed., Elsevier 2017, ch. 7 (wrist). Primary wrist flexors: flexor carpi
  radialis, flexor carpi ulnaris, palmaris longus. The extrinsic finger
  flexors (flexor digitorum superficialis and profundus, flexor pollicis
  longus) are secondary wrist flexors. Superficialis flexes the knuckle and
  middle finger joints; profundus also the fingertip joints and the wrist.
  Primary wrist extensors: extensor carpi radialis longus and brevis, extensor
  carpi ulnaris; the finger extensors, extensor digitorum among them, assist.
  Checked through search excerpts, not the book's pages; Kenhub (Extensor
  carpi radialis longus) and StrengthLog's forearm extensor article give the
  same extensor list.
- **Gonzalez 1997** — Gonzalez RV, Buchanan TS, Delp SL, J Biomech
  30(7):705-712, doi 10.1016/s0021-9290(97)00015-8. The peak flexion moment is
  larger than the peak extension moment mainly because the flexors' summed
  cross-sectional area is about 110% larger. Flexion moment changes more with
  wrist angle and peaks with the wrist flexed. (Abstract read via PubMed
  E-utilities.)
- **Delp 1996** — Delp SL, Grierson AE, Buchanan TS, J Biomech
  29(10):1371-1375, doi 10.1016/0021-9290(96)00029-2. In ten men, peak
  isometric flexion moment was 12.2 N m and extension 7.1 N m, so extension
  was about 58% of flexion. Flexion moment peaked at about 40° of flexion.
  Extension moment was about constant from 30° flexion to 70° extension.
  Passive moments were near zero in the central 150° of motion and rose at
  the ends.
- **Ikeda 2025** — Ikeda K, Kaneoka K, Matsunaga N, Ikumi A, Yamazaki M,
  Yoshii Y, J Orthop Surg Res 20(1):53, doi 10.1186/s13018-024-05363-x (full
  text read on PMC11740565). 20 men, 40 limbs. Maximum isometric wrist
  extension torque 8.2 ± 1.4 N m, flexion 13.6 ± 2.8 N m (neutral forearm;
  extension about 60% of flexion). At 75% effort: ECRB %MVE in extension
  72% pronated against 55% supinated; FCR %MVE in flexion 93% supinated
  against 58% pronated; extensor co-activation during flexion ECRB 14-16%,
  ECU 16% supinated, 24% neutral and 46% pronated.
- **Kaufmann 2007** — Kaufmann RA, Kozin SH, Mirarchi A, Holland B, Porter S,
  Am J Orthop 36(9):E128-E132, PMID 17948164 (abstract read via PubMed
  E-utilities). 11 cadaver forearms, the flexor tendons pulled in isolation
  against a Jamar handle: FDP gave the most grip force with the handle on the
  distal phalanx; FDS was best on the middle phalanx and its force fell off as
  the contact moved over the distal phalanx.
- **Snijders 1987** — Snijders CJ, Volkers AC, Mechelse K, Vleeming A, Med
  Sci Sports Exerc 19(5):518-523. Grasping and pinching always produce a
  flexing moment at the wrist, which extensor activity balances (force and
  EMG).
- **Mogk & Keir 2003** — Mogk JP, Keir PJ, Ergonomics 46(9):956-975, doi
  10.1080/0014013031000107595 (abstract read via PubMed E-utilities).
  Baseline extensor activity (holding the dynamometer without exerting grip
  force) was greatest with the forearm pronated and the wrist extended, and
  flexor activity largest with the forearm supinated and the wrist flexed.
  Extensor activity was always greater with the forearm pronated. A flexed
  wrist cut maximum grip force by 40-50%.
- **Navsaria 2015** — Navsaria R, Ryder DM, Lewis JS, Alexander CM, Br J
  Sports Med 49(5):318-322, doi 10.1136/bjsports-2013-092563. Surface EMG of
  extensor carpi radialis brevis rose as eccentric wrist-extensor exercises
  were loaded more heavily.
- **ExRx** — ExRx.net Dumbbell, Barbell and Cable Wrist Curl, and Barbell,
  Dumbbell and Cable Reverse Wrist Curl. The site blocks direct fetches; the
  text was read on archived copies of the pages (Wayback Machine,
  web.archive.org/web/2024id_/https://exrx.net/WeightExercises/WristFlexors/…
  and …/WristExtensors/…). Wrist curls: sit with an underhand grip, forearms
  on the thighs, wrists just beyond the knees. Let the bar roll out of the
  palms down to the fingers, then raise it by gripping and pointing the
  knuckles up as high as possible. Target: wrist flexors; synergists: none.
  Reverse wrist curls: narrow to shoulder-width overhand grip, the same
  forearm and wrist position. Raise by pointing the knuckles up as high as
  possible, and return until they point down as far as possible. Target:
  wrist extensors. Comment on the barbell and dumbbell pages: keep the elbows
  at about wrist height to keep resistance through the whole range of motion.
  Comment on the Cable Reverse Wrist Curl: do not allow the elbows to rise.
  The dumbbell pages describe one arm at a time (rest the forearm on the
  thigh); the models hold a dumbbell in each hand.
- **ACE** — ACE Exercise Library, Wrist Curl - Flexion (#30) and Wrist Curl -
  Extension (#29), both fetched. Both: kneel and rest the elbows (bent about
  90°) and forearms on a bench, the dumbbells hanging free past the edge of
  the pad. Lower slowly into extension (#30) or flexion (#29) "without
  releasing your grip, extending your arms or leaning forward / backward",
  and hold that lowered position briefly. #30 only: some people release the
  grip while lowering and let the dumbbells roll to the fingertips, which may
  add load to the forearm muscles but increases the risk of wrist injury and
  of dropping the dumbbells; squeeze the weights as hard as possible in both
  phases.
- **StrengthLog** — Barbell Wrist Curl and Dumbbell Wrist Curl (forearm on
  the thigh or a bench; let the bar or dumbbell roll out into the fingers,
  then close the grip and bend the wrist up; it trains the muscles that flex
  the wrist and close the hand). Barbell Wrist Curl Behind the Back (let the
  bar hang in the arms behind the back, roll it into the fingers, curl it
  back up; primary: forearm flexors). How to Train Your Forearm Flexors and
  Grip (kneel at a bench if the thighs feel wobbly). How to Train Your
  Forearm Extensors (2025): the forearm extensors are the wrist extensors
  plus the finger and thumb extensors, and they stabilise the wrist for a
  strong grip; on the dumbbell wrist extension, most people go too heavy,
  curl the fingers to cheat or bounce at the bottom, and should take 2-3 s
  on the way down; on the barbell version, do not bounce at the bottom or
  over-crank into end range at the top, and a straight bar can feel
  uncomfortable on irritated wrists, where dumbbells allow a more natural
  path.
- **GymStreak** — Seated Barbell Finger Curls (the model builder's
  reference), fetched: underhand, hands less than shoulder-width, forearms on
  the bench pad with the wrists at the edge; let the bar roll down the
  fingers, catch it with the fingertips, curl it up as far as possible, hold
  the top for a full second, slow controlled reps. Listed as Beginner.
- **Model** — geometry measured on the USD. This includes the lever of the
  load about the wrist, from the handle's or bar's centre and, for the
  cables, the line from the bar's swivel eye to the low pulley's groove.

**Where evidence is thin.** No EMG study of any wrist curl, reverse wrist
curl, behind-the-back curl or finger curl was found (PubMed searches: wrist
curl EMG, forearm EMG in wrist exercise, reverse wrist curl, finger flexor
training). The activation rows are therefore ranked from anatomy (Neumann,
ExRx's target lists) and kept conservative:

- The prime movers are HIGH (0.84-0.86).
- The two finger flexors (flexor digitorum superficialis and profundus) are
  one MODERATE row, Finger Flexors (0.55), in the closed-grip curls, since
  they hold the load and also flex the wrist; no study ranks them in a
  closed-grip wrist curl. They were two rows with the same estimate, and the
  trainer's one-line legend cut the second name off.
- Extensor digitorum is MODERATE (0.45) in the reverse curls.
- In the finger curl, profundus is ranked just above superficialis only from
  where the bar sits at the bottom (Kaufmann 2007, a cadaver study of grip,
  not of this lift).

These are estimates, not measurements. The copy's statements about where each
lift is heaviest come from the models' own geometry, not from studies.

## Shared seated body (Dumbbell, Barbell Reverse, Dumbbell Reverse, Cable, Cable Reverse, Finger Curl)

The lifter sits on the end of a flat bench:

- Feet flat, about 0.38 m apart (about shoulder-width: the shoulder joints
  are 0.39 m apart, the hip joints 0.18 m); knees about 112°.
- Trunk about 55° forward over the thighs, head down.
- Forearms along the thighs, sloping about 22-23° down to the knees; elbows
  bent to about 64° and about 10 cm higher than the wrists.
- Wrists about 3 cm ahead of the knee joints (over the kneecaps), so the hands
  hang free beyond the knees. Hands 0.33 m apart.
- Torso, shoulders and forearms do not move at all.

Each rep takes 4 s: about 1.3 s up, a 0.3 s hold, about 1.7 s down, and about
0.7 s still at the bottom.

Claims shared by the seated copy:

- **Forearms on the thighs, wrists just past the knees** (Forearm Support and
  Wrist Position cues; setup steps). Model; ExRx; ACE (weights hanging
  freely off the edge).
- **Setup: sit with the feet about shoulder-width apart; slide the forearms
  forward until the wrists just clear the knees.** Model (the forearms, not
  the seat, set where the wrists sit).
- **Only the wrists move, so the forearm muscles do the work; lifting the
  forearms lets the elbows and arms help, and the wrists do less.** ExRx
  (target only, no synergists; Cable Reverse Wrist Curl: do not allow the
  elbows to rise); ACE (no extending the arms or leaning). The rest is plain
  mechanics. The copy says the wrists do less of the work, not none of it.
- **With the wrists back on the thighs, the legs block the hands at the
  bottom.** Model geometry: the hanging hands would reach the thighs. This is
  mechanics, with no study behind it.
- **Body still, no rocking; lower under control** (Body Position). ACE
  (without leaning forward or backward; slowly; hold briefly). The copy names
  rocking the shoulders back, the fault the ghost draws; it no longer names a
  knee bounce, which no source describes for the seated lifts.
- **The copy does not repeat ExRx's "elbows at wrist height" comment.** The
  models' elbows sit about 10 cm above the wrists.

Labels shared by the seated models (checked on the trainer shots and
joints.json after the visual review):

- **Body Position tracks the near shoulder blade** (scapula_L, or scapula_R
  on the cable curls), never `spine`: in these framings the spine joint
  projects onto the near elbow, 15 px from the Forearm Support dot, so the
  two cues read as pointing at the same elbow.
- **The two hand cues are crossed.** The top-row hand label tracks the near
  hand, so its leader passes behind the head instead of down through it (it
  went straight through the skull on the barbell reverse curl); the
  bottom-row one tracks the far hand, which keeps its leader clear of the
  knee dot. Each hand is visible when its cue reads: both wrists at the
  bottom, both fists at the top on the barbell, cable and finger curls, the
  near fist at the top on the dumbbell curls. On the Dumbbell Reverse Wrist
  Curl the top cue (near fist) is the top-row one (below).
- **Framing of the dumbbell curls.** After the first review the two
  dumbbell models were re-framed from yaw -1.0 to -0.7 (zoom 1.009, offset
  0.142, 0.23, -0.119), so the near fist is clear of the near plate at the
  top; the cable curls were moved down (offset y 0.215 to 0.195), so the
  crown clears the top-right label by ~11 px. joints.json was re-probed and
  the labels re-laid on it.
- **The dumbbell models' top-left label sits higher** (0.10 on screen
  instead of 0.16): at zoom 1.01 the crown reaches the top row, and at 0.12
  the label sat on it. At 0.10 it clears the crown by ~10 px and stays ~6 px
  under the COMMON MISTAKE banner in mistake mode. The cable curls cannot
  follow, since their top-row label is on the right, under the eye button.
- **Knee dot on the dumbbell curls: shin_L** (the knee joint), as on the
  Finger Curl. With the hands hanging at the bottom, patella_L sits on the
  near dumbbell's inner plate edge, right under the near fist (behind the
  plate on the reverse curl, by the ray test); shin_L is clear at the bottom
  and at the top, and on the knee at the top.
- Not fixable from the content: at the top the near dumbbell covers the near
  elbow on the two dumbbell curls, so the Forearm Support dot (forearm_L)
  sits on its plate there. No joint swaps in (forearm_R lands on the near
  fist, spine and the near lat on the plate or the trunk), and framing at
  yaw -0.9 or wider would show it but cover the near fist again.

Ghosts shared by the seated models:

- `wristCurlHigh` ramps from 0.29 to 0.37 (palm to knee, torso lengths): the
  ghosts of the top fade in once the hands are ~3° above the forearm line,
  about 60% shown as they pass level and in full from ~14° above level. At
  0.28-0.36 the 35° "short at the top" ghosts dipped up to ~4° below the
  forearm line mid-rep, which reads as the wrist bending the wrong way.
- The forearm ghost is drawn from the elbows (forearm, wrist, palm point):
  the upper arms do not move, and from the side the far one crossed the near
  hand and bar.
- The grip ghost moves the palm point ~6 cm on down the hand (to ~17.7 cm
  from the wrist, at the finger joints; the open fingers reach ~19 cm) and
  draws it as a dot, or the bar, of its own, so it reads as the handle
  slipping rather than as a longer hand. It moved ~8 cm and was joined to
  the wrist before.
- The trunk ghost (`wristCurlTrunkLifted`) draws the arms out to the palm
  points, and the bar where there is one: the turn moves the palm points
  too, and undrawn they left two stray guides. It fades in on
  `wristCurlHigh`, as the copy's "as the dumbbells (the bar) come up" says:
  shown throughout, it stayed rocked back at the bottom and read as sitting
  too upright rather than rocking. The stills are at the top, all of it
  shown (the Finger Curl's at 0.0 s, 99%). The ramp reads the lifter's own
  palm point, so the moved one does not feed back.
- The dumbbell curls, framed at yaw -0.7, turn three faults. The trunk rock
  is seen from -1.0 (`.seen(-0.3)`): at -0.7 the ghost's rocked-back near
  shoulder landed on the top-right pill's text ('B●dy still') and the rock
  was foreshortened; from -1.0 the ghost is ~47 px (of the 920 px still)
  clear of the pill and the head moves 64 px back. The plates cover the
  fists there, which this fault does not need. The forearm lift is turned
  0.15 to the front (-0.55): unturned, the far elbow's ghost dot sat on the
  near palm's ring (6-18 px) and the two arms read as one zig-zag; turned,
  they are ~60 px apart, the lift is unchanged (vertical) and the near fist
  stays clear of the plate (it is covered from about -0.75 round).

## Dumbbell Wrist Curl (dumbbellWristCurl)

**Model.** A dumbbell in each hand, palms up. The grip is full: the fingers
are closed to about 141° and the thumb wraps over to meet them, and it never
opens. The wrists move from about 58° extension to about 47° flexion. At the
bottom the hands hang about 72° below level; at the top the palms turn toward
the lifter. The dumbbells' lever about the wrist (handle 8 cm from the wrist)
is 2.6 cm at the bottom, 8 cm as the hands pass level and 6.7 cm at the top.

**Claims:**

- *Range: lower until the wrists bend well back, pause, curl as high as they
  go, hold a moment.* ExRx (knuckles as high as possible); ACE (into
  extension, hold the lowered position briefly); model (0.7 s still at the
  bottom, 0.3 s hold at the top).
- *The flexors start from a stretch at the bottom.* Anatomy: the wrist
  flexors cross the palm side of the wrist (Neumann).
- *The grip stays closed; a loose grip lets the dumbbells slip and makes it
  easier to strain a wrist or drop the weight.* ACE #30, model.
- *Some guides roll the handle into the fingers; this version keeps the grip
  closed.* ExRx (dumbbell, barbell and cable wrist curls) and StrengthLog
  (dumbbell and barbell wrist curls) teach the roll. ACE #30 warns that
  releasing the grip while lowering increases the risk of wrist injury and of
  dropping the dumbbells, though it may add load to the forearm muscles. The
  model never opens the hand, so the copy teaches the closed grip, names the
  roll as a common variation, and teaches the roll under the Finger Curl.
- *Activation.* Wrist Flexors P HIGH 0.86; Finger Flexors S MOD 0.55 (flexor
  digitorum superficialis and profundus as one row; Neumann, ExRx; no study
  ranks the two finger flexors in a closed-grip wrist curl, so they share
  one estimate).
- *Stabilisers.* Wrist extensors: Snijders 1987 (extensors balance the grip's
  flexing moment); Ikeda 2025 (during supinated wrist flexion the extensors
  co-activate at about 14-16% MVE); StrengthLog (the extensors stabilise the
  wrist for a strong grip). Mogk & Keir 2003 found baseline extensor activity
  highest pronated with the wrist extended, the opposite of this lift, so
  they are listed as stabilisers only. Thumb flexors: the thumb wraps the
  handle.

**Uncertainties.** No EMG for this lift. The load profile (lightest at the
bottom) is from the model's geometry.

**Labels.** Framed at yaw -0.7. Keep the grip closed (top-left, 0.10 on
screen) tracks the near wrist, its leader passing just behind the head; Let
the wrists bend back (bottom-left) the far wrist; Wrists just past the knees
the knee joint (shin_L); Body Position the near shoulder blade.

**Fault stills:**

| Cue | Moment | Ghost |
| --- | --- | --- |
| forearm | top | forearms lift to level, drawn from the elbows, fading in from ~3° above the forearm line (about 60% shown as the hands pass level); turned 0.15 to the front |
| position | bottom | forearms and hands slid about 8 cm back up the thighs; the hanging hands reach into the legs |
| range | bottom | hands 40° short of the lifter's, wrists barely bent back: the ghost holds at ~31° below level until the lifter's hands pass it (`wristCurlBottomShort`, 0.257 to 0.124; `wristCurlLow` made it rise with them and fall back) |
| grip | bottom | palm point about 6 cm further down the hand, drawn as a dot of its own: the handle slipping toward the fingertips |
| torso | top | trunk rocks up 12° from the hips, arms and grip carried off the thighs, fading in as the hands curl up (`wristCurlHigh`); seen from -1.0 |

## Barbell Reverse Wrist Curl (barbellReverseWristCurl)

**Model.** An Olympic barbell, overhand and palms down, hands 0.33 m apart,
full grip. The wrists move from about 31° flexion (hands hanging about 61°
below level, about 39° below the forearms) to about 55° extension (knuckles
up, the hands about 24° above level). The lever is 3.9 cm at the bottom, 8 cm
mid-way and 7.4 cm at the top.

**Labels.** In this framing the near plate covers the spine and the near
elbow, so Body Position tracks the near shoulder blade (scapula_L) and
Forearm Support the far forearm (forearm_R), both clear of the plate in the
start and peak shots. The hand cues are crossed (see the shared labels):
Knuckles up high on the far fist, which shows at the top, and the grip on
the near hand, whose leader no longer runs through the head.

**Claims:**

- *Overhand, hands shoulder-width or a little narrower.* ExRx (narrow to
  shoulder width); model (0.33 m, shoulder joints 0.39 m).
- *Knuckles well above the forearms, without forcing the last few degrees;
  then lower slowly until the hands hang below the forearms.* ExRx (as high
  as possible, then down as far as possible), StrengthLog extensor article
  (do not over-crank into end range at the top; 2-3 s down), model (the top
  is about 55° of extension, short of end range; the bottom about 31° of
  flexion, short of full flexion).
- *The wrist extensors are only about 60% as strong as the flexors, so a
  wrist-curl weight is too heavy and the rep stops short; choose a light
  weight.* Delp 1996 (7.1 against 12.2 N m, about 58%); Ikeda 2025 (8.2
  against 13.6 N m, about 60%); Gonzalez 1997 (flexors' larger
  cross-section); StrengthLog extensor article (most people go too heavy).
  The "stops short" part is the plain consequence, not a measured finding.
- *The grip is weakest with the wrist bent down, as at the bottom; squeezing
  hard makes the wrist extensors work harder, since a firm grip tends to bend
  the wrist down.* Mogk & Keir 2003 (a flexed wrist cut maximum grip force by
  40-50%; extensor activity was always greater with the forearm pronated);
  Snijders 1987 (gripping always makes a flexing moment at the wrist, which
  extensor activity balances).
- *Activation.* Wrist Extensors P HIGH 0.86 (ECRL, ECRB, ECU; Neumann, ExRx
  target, Navsaria 2015 and Ikeda 2025 for ECRB's activity in loaded
  extension, highest pronated). Extensor Digitorum S MOD 0.45: the main
  finger extensor, which Neumann lists as a secondary wrist extensor. The
  level is an estimate. It replaces "Forearm Extensors", a group name that
  includes the wrist extensors already listed as the prime movers
  (StrengthLog extensor article), so the panel no longer shows the same
  muscles twice.
- *Stabilisers.* Finger flexors and thumb flexors hold the bar.

**Uncertainties.** No EMG for the lift.

**Fault stills:**

| Cue | Moment | Ghost |
| --- | --- | --- |
| forearm | top | forearms lift to level, drawn from the elbows, the bar with them |
| position | bottom | forearms slid back; the hanging hands and bar reach the legs |
| top | top | knuckles 35° lower, about level: 11° below level, still 11° above the forearms (the lifter's 24° above level). `wristCurlHigh` ramps over ~33° of the arc (~19° below level to ~14° above), which keeps the 35° ghost level with the forearm line at worst mid-rep; a bigger turn would dip it below |
| grip | bottom | the bar slipping about 6 cm toward the fingertips, drawn apart from the hands |
| torso | top | trunk rocks up 12°, the arms and bar with it, fading in as the hands curl up |

## Dumbbell Reverse Wrist Curl (dumbbellReverseWristCurl)

**Model.** The same motion as the barbell version with a dumbbell in each
hand (the builder's note: "as 270 with dumbbells"). The wrist timeline is
identical: 31° flexion to 55° extension, palms down, full grip.

**Labels.** Framed at yaw -0.7. Body Position tracks the near shoulder blade
(the spine joint projects onto the near elbow here) and Forearm Support the
near forearm (on the near plate at the top; see the shared labels). The top
cue must stay on the near fist, the only one visible at the top (the far one
is behind the far dumbbell), and the grip keeps the far wrist, visible at
the bottom where the grip is weakest. The pills are placed so neither leader
crosses the head: Lift the knuckles up high goes top-left (0.10 on screen)
and Palms down, grip closed bottom-left. With the grip pill top-left, its
leader to the far wrist, almost straight below the pill, ran through the
back of the skull. The top label is the long form so the pill's edge sits
further right: its leader passes ~20 px behind the ear in the trainer view
and ~30 px (of the 920 px still) in the top fault still; 'Knuckles up high'
there would cross the head. Wrists just past the knees tracks the knee joint
(shin_L), as on the wrist curl.

**Claims.** As the barbell version. Grip copy: palms facing the floor, thumbs
wrapped round (model). The comparison is about the forearms leaving the
thighs, the elbows bending so the arms raise part of the load: ACE (without
extending your arms), ExRx Cable Reverse Wrist Curl (do not allow the elbows
to rise). The ghost turns the forearms up about the elbows, which stay on the
thighs, so the copy says the forearms lift, not the elbows.

**Fault stills.** As the barbell version, with no bar drawn: forearm top,
position bottom, top top, grip bottom (the slipped handles as two dots),
torso top. As on the wrist curl, the torso ghost is seen from -1.0 and the
forearm ghost turned 0.15 to the front. The top ghost is not turned, since
its pill is top-left and 0.15 to the front would run the leader through the
head; instead the far hand is drawn from the wrist (wrist to palm point)
rather than from the elbow. At -0.7 the far elbow lies on the near palm
point, and drawn it hid that palm's ring and joined the hands into one
zig-zag; without it each ring is ~55 px from its ghost palm, with nothing
over it. The near hand keeps its forearm line for reference.

## Cable Wrist Curl (cableWristCurl)

**Model.** The seated body with a straight cable bar, underhand, palms up.
The wrist timeline is the dumbbell wrist curl's (58° extension to 47°
flexion) and the grip is full.

- The cable runs from the bar's swivel eye to a low pulley (about 0.12 m off
  the floor) about 0.85 m in front of the bar, centred on the lifter. It
  runs about 23° below level at the bottom and about 30° at the top.
- Worked from those lines, the cable's lever about the wrist is about -7 cm
  (resisting) at the top. It is zero where the hands point along the cable
  (about 25-30° below level, near the forearm line). It is about +6 cm at the
  bottom, where the cable pulls the hands forward and up rather than
  resisting.
- The copy therefore says: "In this set-up the cable pulls forward toward
  the low pulley rather than straight down, so the resistance builds as the
  hands curl up and is greatest at the top", and the comparison opens "With
  the pulley out in front, as here". Source: model geometry only.
- Framed at yaw +1.0: the lifter faces right and the right arm is nearer, so
  the labels and the full glow sit on the right arm. Body Position tracks
  the near shoulder blade (scapula_R), and the hand cues are crossed: Curl
  all the way up on the far (left) fist, the grip on the near hand.

**Claims:**

- *Top of the rep: curl until the palms turn toward you, hold a moment.*
  Model (palms face the lifter at the top), ExRx.
- *Stopping short cuts off the part the cable loads most.* Model.
- *Leaning back pulls the cable with the body.* Mechanics.
- *Setup: straight bar on a low pulley, sit on the end of a bench facing it,
  about a stride back.* Model (the bar about 0.85 m from the pulley).
- *Grip: many guides roll the bar into the fingers; this version keeps the
  hand closed.* ExRx Cable Wrist Curl teaches the roll; model; as the
  dumbbell wrist curl.
- Activation and stabilisers as the dumbbell wrist curl.

**Uncertainties.** Whether the cable resists at the bottom depends on how far
the bench sits from the pulley. In this model it does not. Sitting close to
the pulley would make the cable near vertical and the profile like a
dumbbell's, so the set-up says to sit about a stride back.

**Fault stills:**

| Cue | Moment | Ghost |
| --- | --- | --- |
| forearm | top | forearms lift to level, drawn from the elbows, the bar with them |
| position | bottom | forearms slid back; the hanging hands and bar reach the legs |
| top | top | palms stop about level (about 1° below), 35° short of the lifter's 34° above level |
| grip | bottom | the bar slipping about 6 cm toward the fingertips, drawn apart from the hands |
| torso | top | trunk rocks up 12°, the arms and bar with it, fading in as the hands curl up |

## Cable Reverse Wrist Curl (cableReverseWristCurl)

**Model.** The cable set-up with an overhand grip, palms down; the reverse
curl's wrist timeline (31° flexion to 55° extension). The lever is about
-6.4 cm (resisting) at the top and about +5 cm at the bottom (pulling the
hands up).

**Claims.** The cable-line claim as the cable wrist curl (model), plus the
extensor-strength claim (Delp 1996, Ikeda 2025) and the top caution
(StrengthLog: no over-cranking into end range). Grip and squeeze as the
barbell reverse curl (ExRx, Snijders 1987, Mogk & Keir 2003). The comparison
(forearms off the thighs) matches ExRx's comment on this exact lift: do not
allow the elbows to rise. Activation and stabilisers as the reverse curls.
Labels as the cable wrist curl (scapula_R, crossed hand cues).

**Fault stills.** forearm top, position bottom, top top, grip bottom, torso
top; the ghosts as the cable wrist curl's.

## Behind-the-Back Wrist Curl (behindTheBackWristCurl)

**Model:**

- Standing tall: feet about 0.32 m apart, knees about 175°, trunk upright and
  still, shoulders level (no shrug).
- Arms straight (elbows 178°), angled about 14-20° back from the trunk.
- An Olympic barbell behind the thighs at the level of the lower glutes,
  hands 0.49 m apart (shoulder-width), palms facing back, full grip (fingers
  141°) that never opens.
- The wrists move from about 45° extension (hands tipped toward the legs,
  palms facing down; the bar hangs almost straight below the wrists, lever
  about 2 cm) to about 41° flexion (the bar curled up and back, palms facing
  back, lever 7.3 cm).
- As the wrists curl, the arms swing about 6° forward, toward the legs
  (19.8° to 13.5° behind vertical; the wrists about 6 cm forward and 2 cm
  lower at the top), so the bar itself moves only about 4 cm back and 2.5 cm
  up.
- Framed at yaw -2.4, from behind on the left.

**Labels.** The shoulder label is 'Shoulders down' (the cue's title, Shoulder
Position, and its copy still name the shrug). 'Shoulders down, no shrug'
rendered ~13 px wider than gen's estimate, was pushed left by the right
margin to x≈167 and ran its leader down the right edge of the head; the
short pill sits right of the head, its leader running diagonally over the
right trapezius, and in the shoulders fault still it no longer covers the
head.

**Claims:**

- *Arms hang straight; only the wrists bend.* StrengthLog (the bar hangs on
  the arms), model, ACE (no extending the arms, in the kneeling version).
- *Bending the elbows turns it into a pull with the arms, so the wrists do
  less of the work.* Mechanics.
- *Shrugging lifts the bar with the upper trapezius.* Mechanics; the model
  keeps the shoulders level. The trapezius's role in shrugging is covered
  in the batch 191-240 shrug notes (Ekstrom 2003).
- *Swinging the arms back lifts the bar from the shoulders.* Mechanics; the
  model's arms move only about 6°, and forward, not back.
- *The bar hangs almost straight below the wrists at the bottom and pulls
  little; it swings out behind them as they curl, so the load builds toward
  the top.* Model geometry (lever about 2 cm to 7.3 cm).
- *Stand tall, knees soft, no knee dip; dipping throws the bar up with the
  legs, so the wrists do less of the work.* The model stands still, knees
  about 175°. The knee-dip fault is a common cheat inferred from the lift's
  mechanics; no source was found that names it for this exercise.
- *Setup: bar racked just below hip height, grip behind at shoulder-width,
  palms back, step forward.* As the batch 191-240 Behind-the-Back Barbell
  Shrug set-up.
- *Activation* as the wrist curls: Wrist Flexors and one Finger Flexors row
  (Neumann, StrengthLog: forearm flexors).
- *Stabilisers*: upper trapezius (holds the shoulders under the hanging
  bar); rear deltoids and latissimus dorsi (hold the straight arms about
  14-20° behind the trunk against the bar's pull toward vertical; reasoning);
  wrist extensors (the grip is palms back, a pronated forearm, where Ikeda
  2025 measured about 46% MVE ECU co-activation during wrist flexion).

**Uncertainties.** StrengthLog's version rolls the bar into the fingers; this
model keeps the grip closed, so the copy does not teach the roll. No EMG. The
library entry's "BARBELL" and "intermediate" look right.

**Fault stills.** The sagittal ghosts turn +0.2, to -2.2 in total: the arms
and hands moving back show at about 81% of their length (68% unturned), and
the near plate stays about 4 cm clear of the left wrist at the top (13 cm at
the bottom). Measured by projecting the plate mesh and the wrist joint over
the rep (orthographic): at -2.1 the plate already covers the left wrist by
about 1 cm at the top, at -1.9 by about 12 cm, and at a true side view the
whole hand. The ghost is drawn over the plate either way; what the turn must
not hide is the real left hand to compare it against.

| Cue | Moment | Ghost |
| --- | --- | --- |
| arms | top | elbows driven back 30° and bent 50°; the wrists about 7 cm higher, the grip about 25 cm behind the pelvis |
| shoulders | top | shoulders shrugged about 7 cm, the arms, grip and bar lifted with them, fading in with the curl (`behindWristCurlTop`, as the copy's "as the bar rises"); unturned, the shrug is vertical. It was `shrugged`, always shown, with the wrists floating above a bar that stayed put |
| swing | top | arms swung back 15°; the grip about 14 cm further back and 8 cm higher |
| range | top | hands 35° less curled: 62° below straight back against the lifter's 27° |
| stance | bottom | hips and everything they carry sink about 6 cm, knees 174° to about 136°; always shown, read with the bar hanging before the lift |

## Finger Curl (fingerCurl)

**Model:**

- The seated body, an Olympic barbell underhand, palms up.
- The clip starts at the top: fingers closed about 147°, wrist flexed about
  27° (the hands about 14° above level, against the wrist curls' 47° of
  flexion), the bar in the palm, the thumb wrapped.
- The fingers open to about 46° and the bar rolls down to the fingertips; the
  thumb comes off it, and the bar moves from 8.5 cm to 14 cm from the wrist.
  At the bottom the bar axis is about 3.5 cm from the fingertip (DIP) joints
  and 6.7 cm from the knuckles, hooked by the last finger bones. Meanwhile
  the wrist extends to about 43°. The bottom is at about 1.2-1.6 s.
- The fingers and the wrist move together both ways (measured every 1/3 s:
  on the way up each is about 18%, 45%, 75% and 94% of its travel at 2.0,
  2.3, 2.7 and 3.0 s); the top is reached again by about 3.3 s and held to
  4 s.
- The bar's lever about the wrist grows from about 7 cm at the top to about
  11 cm with it out in the fingers.

**Labels.** As in the barbell reverse curl, the near plate covers the spine
and the near elbow, so Body Position tracks scapula_L and Forearm Support
forearm_R. The hand cues are crossed: Roll bar to the fingertips on the far
hand, whose open fingers show at the bottom, and Close the fist as you curl
on the near fist, shown at the top. Wrist Position tracks the knee joint
(shin_L) rather than the kneecap, which sits on the bar's lower edge at the
bottom; the knee joint is ~5 px lower, below the bar.

**Claims:**

- *Let the bar roll out of the palms to the fingertips, then roll it back
  and curl the wrists; this works the finger flexors, the muscles that close
  the hand, over a long range.* ExRx (roll out of the palms to the fingers),
  StrengthLog (roll into the fingers, close the grip, bend the wrists up;
  trains the muscles that close the hand), GymStreak (roll down the fingers,
  catch it with the fingertips, curl up), Neumann. "A long range", not the
  whole range: the model's fingers open only to about 46°, still hooked
  round the bar.
- *Kept in the palms, it becomes a plain wrist curl.* Follows from the above.
- *Roll the bar back into the palms as the wrists curl up; hold a moment.*
  Model (the fingers and the wrist close together; 0.7 s hold at the top),
  GymStreak (hold the top for a full second). The copy no longer says to
  close the fist first and curl after, which the model does not show, nor to
  curl the wrists as far as they go: the model's top is only 27° of flexion.
- *Don't let it roll off the fingertips.* Safety, ACE #30's grip caution.
  The model keeps the fingertips hooked round the bar, the fingers still
  bent about 46°.
- *The bar needs room to roll down, so the wrists sit past the knees; with
  the wrists on the thighs the legs stop the bar before it reaches the
  fingertips.* Model, ExRx.
- *Activation.* Flexor Digitorum Profundus P HIGH 0.84 and Flexor Digitorum
  Superficialis P HIGH 0.80. At the bottom the bar hangs on the fingertips,
  where FDP, the only flexor of the fingertip joint, is most effective and
  FDS least (Kaufmann 2007, cadaver; Neumann for the joints each crosses).
  Wrist Flexors S MOD 0.60, since the wrist still curls about 70°. All
  estimates; no EMG.
- *Stabilisers.* Wrist extensors (Snijders 1987; Ikeda 2025), thumb flexors.

**Uncertainties:**

- No EMG. Kaufmann 2007 measured grip on a dynamometer in cadavers, not this
  lift; the two finger flexors are kept close (0.84 and 0.80).
- The primary legend line joins two long names and is cut off with an
  ellipsis in the app's one-line legend ("FLEXOR DIGITORUM PROFUNDUS · FLEXOR
  DIGITO…"); the two are kept apart here because they lead and the bar's
  place ranks them, so the fix is the legend's line limit (for the
  integrator). The wrist curls' secondary line now reads FINGER FLEXORS.
- Library: the entry says intermediate; GymStreak, the builder's reference,
  lists it as Beginner, and it is a light, seated, supported single-joint
  lift. Recommended: `.beginner` (for the integrator; not changed here).

**Fault stills.** The clip's top is at 0.0 s (also 3.3-4.0 s); the bottom is
at about 1.25 s.

| Cue | Moment | Ghost |
| --- | --- | --- |
| forearm | top | forearms lift to level, drawn from the elbows, the bar with them |
| position | bottom | forearms slid back; the hanging hands and bar reach the legs |
| roll | bottom | fingers closed and wrists about straight: hands 26° below level against the lifter's 56°, the palm point and bar drawn ~3.3 cm back along the hand, 8.5 cm from the wrist, where the model holds the bar in the palm (the lifter's bar sits 14 cm out, in the fingertips) |
| top | top | wrists 30° less curled: hands 16° below level against the lifter's 14° above |
| torso | top | trunk rocks up 12°, the arms and bar with it, fading in as the hands curl up (99% at 0.0 s) |

## Still times for `fault_times.py`

`fault_times.py` reads these lifts by the left wrist's bend. Kind `wrist`
(the wrist and reverse wrist curls, including Behind-the-Back) takes top =
most flexed (most extended for a reverse curl) and bottom = the other end;
kind `finger` takes top = most flexed, bottom = most extended. The palm point's
distance to the left knee, which the ghosts' strengths use, gives the same
moments:

| Exercise | Bottom | Top |
| --- | --- | --- |
| seated wrist, reverse and cable curls | 0.0-0.3 s (and 3.7-4.0 s) | about 1.5-2.0 s, mid 1.75 s |
| Behind-the-Back Wrist Curl | 0.0-0.3 s | about 1.5-2.0 s |
| Finger Curl | about 1.2-1.6 s, mid 1.4 s | 0.0 s or 3.4-4.0 s |

Every cue in this family has an explicit moment, so "any" is not used.
