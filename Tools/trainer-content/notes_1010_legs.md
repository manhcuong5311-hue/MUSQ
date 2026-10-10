# Notes: family legs (Desktop "1-100" folder, 2026-10-10)

Five exercises: Single-Leg Extension, Smith Machine Front Squat, Dumbbell
Lateral Step-Up, Barbell Step-Up, Hip Adduction Machine. Spec:
`spec_1010_legs.py`; ghosts: `Tools/fault-review/faults_1010_legs.swift.txt`;
moments: `fault_moments_1010_legs.json` (all given in seconds).

## How the models were read

- `$LAB/1010/legs/dump.py` (in the session scratchpad) (Blender's Python + pxr) wrote every joint's
  world position and Y axis every frame, plus the equipment's bounding boxes at
  0/1/1.5/2/3 s, for the five rigs. `an.py` measured angles (knee = thigh-shin
  inner angle, hip = neck-hip-knee, trunk lean = neck over pelvis from
  vertical). `ghost.py` is a Python port of `FaultGhost.solve` used to size
  every ghost (bone lengths and knee bend direction checked).
- The motion briefs (`briefs_1010/`), tiers.txt, joints.json and the trainer
  stills were read first; the numbers below are my own re-measurements, which
  agree with the briefs.
- One body: neck to pelvis 0.592 m, thigh 0.444 m, shin 0.398 m.

## Model facts used in the copy

Single-Leg Extension
- Left knee 93° (0-0.5 s) -> 168° (1.5 s), held to 2.25 s, back to 93° by
  3.5 s; second rep 4.5-7.5 s. "almost straight", "about 168 degrees", "about
  three-quarters of a second" (1.5-2.25 s).
- Right knee 87.4° every frame; right ankle behind the roller (roller front at
  z 0.45-0.57, right ankle z 0.38). "Right leg rests", "about 87 degrees".
- Left knee joint (0, 0.606, 0.423) vs the pivot housing's centre (0.405,
  0.606, 0.423): same axis within 1 cm. "the knee sits on the pivot".
- Roller axle 9.5 cm above the left ankle joint along the shin at 0 s and at
  2 s (same spot through the arc). "about 10 cm above the ankle".
- The roller spans x -0.19 to 0.29, in front of both shins. "The roller spans
  both shins".
- Trunk reclined 10° on the back pad, trunk-thigh 104°, pelvis still; hands
  on the seat handles.

Smith Machine Front Squat
- Bar shaft centre 8 cm in front of and 8 cm above the shoulder joints at the
  top. Cross-arm grip: hand_L's wrist at x +0.05, its knuckles at x -0.035
  (past the midline), and the mirror on the right; elbows forward and out
  (x ±0.25); upper arm 12° above level standing, 8° at the bottom.
  "arms crossed", "within about 12 degrees of level".
- Ankles 46 cm apart (shoulder joints 39-40 cm), toes out 15°, bar shaft
  directly over the ankle joints (z 0.25 both). "bar over your ankles",
  "a little wider than the shoulders".
- Bottom 1.5-2.25 s: knees 69°, hip joints 2.4 cm above the knee joints, trunk
  17.6° forward, knees 16 cm ahead of and 4 cm outside the ankles; heels flat
  (ankle and toe heights constant). Top knees 163°.

Dumbbell Lateral Step-Up
- Box 31 cm high, 55 cm square, at x 0.20-0.76 (the lifter's left). Left
  ankle on it at x 0.45 all clip; right ankle on the floor at x -0.16.
- Start: left knee 88°, left shin 53° forward (knee 30 cm ahead of the ankle),
  right knee 145°, trunk 18° forward. Left knee 3.5 cm outside the hip-ankle
  line: no caving. "shin tipped about 53 degrees". (Review: the knee is
  12.6 cm inside the ankle seen face-on, because the hip sits inside the box
  foot; the hip-knee-ankle plane faces 4° out, as the foot does, so the knee
  points the same way as the foot, ExRx's wording, but is not over the toes.
  The copy now says "points the same way" and "on the line from the hip to
  the foot".)
- Right foot off the floor ~0.25 s; pelvis 33 cm sideways, 32 cm up; top
  1.2-1.96 s, left knee 147°, right 137°, trunk 6°. "about 6 at the top".
- Right ankle at the top 0.418 m vs left 0.392 (toes 0.355 vs 0.329): the
  right foot hovers ~2.6 cm above the box and never takes weight. "without ever
  taking weight on the box". (Builder: if the foot is meant to land, lower it
  2.6 cm; the copy would still hold.)
- Hip joints level within 1° every frame; no sideways trunk lean.
- Up ~1.2 s (0.17-1.17), down ~1.75 s (2.0-3.75).

Barbell Step-Up
- Bar centre 5 cm behind and 2 cm above the neck joint; hands 78 cm apart
  (shoulder joints 39 cm, so a wide grip, not "a little wider than the
  shoulders"), elbows 45°. Box 31 cm, in front (z 0.21-0.77); left ankle on it 61 cm ahead
  of the right.
- Start: left knee 92°, hip 75°, trunk 27°, left knee 6 cm ahead of the ankle
  and 7 cm behind the toe joint. Top 1.21-1.96 s: left knee 150°, right 145°,
  trunk 3°. Pelvis 37 cm forward, 33 cm up. Right foot again ~2.6 cm above the
  box at the top.

Hip Adduction Machine
- Knee joints 0.776 m apart at 0 s (each thigh 42° out from straight ahead) ->
  0.245 m at 1.33-1.83 s (4° out); the inner pads (on the inside of the knees)
  close to ~1.2 cm apart at 1.33-1.75 s and never overlap, so they look
  closed but do not touch (second check, 2026-10-10: the inner faces are
  12 cm apart at 0.92 s). (Review re-measure: the knee joints reach 25 cm at ~1.3 s, stay there to
  ~1.85 s (about half a second) and are open again by ~3.9 s: "a little over
  a second to close and about two seconds to open", "pause there for about
  half a second".)
- Knees 91° all clip, feet on footrests that swing with the legs, trunk
  reclined 8° on the back pad, hands on the seat handles.

## Sources and what each supports

All opened by the research pass (ExRx via Wayback, Europe PMC abstracts,
StrengthLog live); "Abs" = abstract only.
- ExRx Lever Leg Extension (snapshot 2026-02-02): back against the pad, lower
  legs under the lever, knee lined up with the pivot, hold the handles; target
  quadriceps, no synergists; gripping the handles or a seat belt keeps the
  body from rising. -> SLE pivot, pad, seat; the glute exception.
- StrengthLog Leg Extension: line up the knee with the machine's joint, back
  on the pad without arching, extend fully but not overextend, no momentum;
  quadriceps only. -> SLE pivot, top, seat.
- Escamilla et al. 1998 (Abs): knee extension more rectus femoris, squat/leg
  press more vasti; quadriceps activity peaked near full extension. -> SLE top,
  activation note.
- Botton et al. 2016 (Abs): unilateral isometric strength +21% (unilateral
  training) vs +10% (bilateral); similar 1RM and thickness gains. -> SLE rest.
- ExRx Smith Front Squat (2021-05-01): bar on the front of the shoulders, feet
  under the bar, thighs just past parallel, back straight, knees the same
  direction as the feet; synergists gluteus maximus, adductor magnus, soleus;
  stabilisers incl. erector spinae, anterior deltoid. ExRx Barbell Front Squat
  (2026-02-06): cross arms, hands on top of the bar, upper arms parallel to the
  floor. -> Smith rack, torso, depth, knees, stance, stabilisers.
- StrengthLog Front Squat: crossed-forearm grip is an option. -> Smith rack.
- Yavuz et al. 2015 (Abs): more trunk lean in the back squat; more vastus
  medialis in the front squat. -> Smith torso, quadriceps note.
- Schwanbeck et al. 2009 (Abs): free-weight squat drew more EMG than the
  Smith squat (43% higher averaged over the muscles; only gastrocnemius,
  biceps femoris and vastus medialis differed significantly). -> Smith quadriceps value below the free Front
  Squat's.
- Abelbeck 2002 (Abs): fixed-path squat model, feet forward lowers the knee
  moment and raises the hip moment. -> Smith stance.
- ExRx Barbell Step-up (2026-03-04), Dumbbell Step-up (2025-07-02), Dumbbell
  Lateral Step-up (2020-11-12): target quadriceps; synergists gluteus maximus,
  adductor magnus, soleus, the gastrocnemius of the "second leg" (step-up
  pages; "following leg" on the lateral page); stabilisers erector
  spinae, gluteus medius/minimus; torso upright (fairly upright, slightly
  forward with heavier barbell loads); knee in line with the foot; further
  from the bench emphasises the gluteus maximus; lateral: foot on the bench to
  the side, stand by straightening that leg. -> both step-ups.
- Simenz et al. 2012 (Abs): of four loaded step-ups the standard one drew the
  most gluteus maximus activity. -> BSU glute value.
- Muyor et al. 2020 (PLoS One, full text): barbell lateral step-up, 40 cm box:
  vasti > gluteus medius > gluteus maximus > biceps femoris; concentric >
  eccentric. Its table labels the values mV while the abstract says %MVC, so
  only the order is used. (Review: rectus femoris was measured too and in the
  lateral step-up table sits level with the vasti, above the gluteus medius;
  the text ranks it last overall. So the gluteus medius is "the most active
  hip muscle measured", not "the most active after the quadriceps".) -> DLSU hips cue, glute order.
- Wang et al. 2003 (Abs): forward step-up more hip work, lateral more knee
  and ankle work. -> DLSU gluteus maximus below the library's Step-Up.
- ExRx Lever Seated Hip Adduction (2026-05-20): target hip adductors,
  synergists pectineus and gracilis, no significant stabilisers; legs apart
  until a slight stretch, lie back, grasp the side bars, legs together and
  return. StrengthLog Hip Adduction Machine: push the pads toward each other
  by bringing the legs together, return with control (it does not say
  "squeeze"). StatPearls (gracilis, PMID 30855817, NBK538229; adductor
  magnus, PMID 30521263, NBK534842): the medial compartment (pectineus,
  adductor longus, brevis, gracilis, adductor magnus) adducts the thigh;
  gracilis assists adduction, knee flexion and internal knee rotation.
  -> every adduction cue, stabilisers.
- Not used: Ekstrom 2007's per-muscle %MVIC (full text not reachable), the
  Serner 2014 machine value (only in a secondary summary), Farrokhi 2008 (a
  lunge, not a step-up).

## Mechanical reasoning (no source; marked as such)

- SLE: knee on the pivot keeps the pad on one spot of the shin; lifting the
  hips moves the knee off the pivot; a push from the right leg takes load off
  the left (the roller spans both shins).
- Smith: elbows up keep the shoulder shelf level; folding forward under a
  fixed track pushes the hips back; a shallow squat shortens the range.
- Step-ups: a flat foot lets the heel share the push; a bounce off the floor
  foot hands work to the other leg; a sliding bar pulls the chest forward.
- Adduction: a slow opening keeps the adductors working as the weight lowers;
  forcing the start wider puts the inner thigh at the end of its range.

## Activation decisions

- Activation follows the paint (bright = primary). The Single-Leg
  Extension's first export painted all three glutes bright, though a seated
  knee extension barely uses them (ExRx: no synergists; StrengthLog:
  quadriceps only); it was a LOW secondary row at 0.10 until the owner
  re-exported the model with the glutes unlit (2026-10-10). Now only the
  quadriceps are listed, and the copy makes no glute claim.
- Fractions are judgement calls anchored on the library: Leg Extension 0.91;
  Smith Machine Squat 0.86 / 0.50 (glutes 0.55 here, bright); Step-Up 0.82 /
  0.64 (Barbell Step-Up 0.80 / 0.62; Lateral 0.82 with Gluteus Medius 0.55
  ahead of Maximus 0.48 after Muyor 2020 and Wang 2003); Cable Hip Adduction
  0.85 (Adductors).
- "Gracilis" has no MusclePart (part_of() returns None), so the Adductors row
  stands for it; it is named in the stabilisers with the pectineus, as the
  thrusters name their bright gluteus medius.
- Bright gluteus medius and minimus on the squat and barbell step-up are
  covered by the Gluteus Maximus row and named in the stabilisers. Nothing is
  painted dim on any of the five, so there are no other secondary rows.

## Labels

- Single-Leg Extension (yaw -1.0): two labels top left over open floor
  (straighten, pivot), "seat" right over the static seat frame, "pad" and
  "rest" at the bottom over the base rail.
- Smith (yaw -1.0): rack top left above the plate, torso right below the
  left-hand plate, knees and stance left below the right-hand plate. Review:
  "Thighs to level" at 0.60 sat on the left glute at the bottom (t1.8); now
  "Thighs level" at 0.68, right, clear of the left shin at both stills.
- Dumbbell Lateral Step-Up (face-on; review: knee label now "Knee in line"): torso top right, hips (tracking the
  right hip joint) and drive ("No bounce", to the floor foot) on the left at
  0.70 and 0.80, short so they end left of the right foot at the start (the
  first lab round had "Lift with the box leg" over that foot and "Hips level"
  at 0.60 over the right dumbbell); knee right above the box, foot at the
  bottom right over the box.
- Barbell Step-Up (yaw -0.9): rows 0.50-0.80 below the plates; "bar" uses a
  short label so it stays clear of the hips. Review: at the top (t1.8) the
  left pills "Lean, then stand tall" (0.50) and "Knee over the foot" (0.62)
  sat on the trailing right thigh and knee (body edge ~u 0.29-0.34); now
  "Back flat" (ends u 0.23) and "Knee in line" (ends u 0.27; "Knee over
  foot" still touched the trailing knee in the second lab round).
- Hip Adduction (yaw -0.3): back and grip above the shoulders; open on the
  left at mid-height (to the right knee joint); squeeze and stretch at the
  bottom.

## Ghosts

One per position cue; no ghost (red ring) for SLE "pad" (where a pad sits)
and adduction "open" (tempo). Sizes in the faults file comments. All moments
in seconds: the SLE has no fault_times rule (it would fall to `press`), and
the step-ups and squat read best at chosen moments (start of the step 0.1 s,
right foot leaving the floor 0.6 s, bottom of the squat 1.8 s, top 1.9 s).

## Review (independent reviewer, 2026-10-10)

Every cited source re-opened fresh (Europe PMC REST abstracts, PMC7112217
full text, ExRx via Wayback id_ snapshots 2026-07/09 for the leg extension,
front squat, step-ups and adduction, 2021-05-01 SMFrontSquat and 2020-11-12
DBLateralStepUp, the newest that exist; StrengthLog live). The research
folder's StatPearls copies (NBK539827/551612/553209.html) are reCAPTCHA pages
with no article, and NBK539827 is not the gracilis article (NBK538229 is);
the StatPearls claims were re-checked on the Europe PMC abstracts and
Wayback copies. Models re-measured from the dumps (spot-checked: knee
angles, leans, bar, roller, pads, grips, timing).

Claim -> verdict -> action:
- SLE pivot (ExRx "knee articulation at same axis as lever fulcrum";
  StrengthLog knees in line with the machine's joint) -> supported -> kept.
- SLE pad (ExRx front of lower legs under the padded lever) -> supported.
- SLE top (StrengthLog extend fully, not overextend; Escamilla: quadriceps
  activity greatest in knee extension near full extension) -> supported;
  "skips the hardest part" reworded to "skips the range where they worked
  hardest" (EMG activity, not difficulty).
- SLE seat (ExRx stabilisers or a seat belt keep the body from rising under
  heavy loads; StrengthLog back pressed to the pad, no arching) -> supported,
  but "gripping the handles" is ExRx's stabiliser list (traps, biceps,
  brachialis, brachioradialis) plus "grasp handles", not a sentence ->
  reworded to "the arms holding on, or a seat belt".
- SLE rest (Botton 2016) -> partly: unilateral isometric strength +21.4% vs
  +10.3% in women, but 1RM and muscle thickness gains similar; the copy's
  "builds that leg on its own" overstated -> rewritten with "in women" and the
  similar 1RM and thickness gains.
- SLE ExRx no synergists, StrengthLog quads only -> supported (glute
  exception kept).
- Smith rack (ExRx barbell front squat: cross arms, hands on top, upper arms
  parallel; StrengthLog crossed-forearm grip an option) -> supported; the
  Smith page itself uses an overhand grip -> copy now says "ExRx's barbell
  front squat". Model: upper arms 11.7° standing, 7.8° at the bottom ->
  "within about 12 degrees" holds.
- Smith torso (Yavuz 2015: more trunk lean in the back squat; ExRx back
  straight) -> supported.
- Smith depth (ExRx thighs just past parallel; model hips 2.4 cm above the
  knees) -> supported; mistake "knees bent only a little past a right angle"
  misdescribed the ghost (~97° inside angle) -> "bent only to about a right
  angle and the thighs still sloping down".
- Smith knees (ExRx knees same direction as feet; model 15° toe-out, knees
  4 cm outside, 16 cm ahead of the ankles) -> supported.
- Smith stance (ExRx "Place feet under bar"; Abelbeck 2002 model: feet
  forward, knee moment down, hip moment up) -> supported; mistake "the hips
  take over" overstated -> "more of the work shifts to the hips".
- Smith activation comment: Schwanbeck's 43% is EMG averaged over the
  muscles (free weight higher), not summed -> fixed in spec and notes.
- DLSU foot/drive/torso (ExRx foot on the bench to the side, stand by
  straightening the leg, torso upright) -> supported.
- DLSU knee (ExRx "stepping knee should point same direction as foot") ->
  supported as a source, but the copy's "travels well forward over the toes"
  and "Keep your knee pointing over your middle toes" did not match the model:
  the knee is 12.6 cm inside the ankle face-on (hip inside the box foot)
  though it points 4° out like the foot and sits 3 cm outside the hip-ankle
  line -> intro, why, correct and label ("Knee in line") rewritten to "points
  the same way as the foot ... on the line from the hip to the foot".
- DLSU hips (ExRx gluteus medius a stabiliser -> supported; Muyor 2020 "most
  active muscle after the quadriceps" -> not supported: the rectus femoris was
  measured and in the lateral step-up table equals the vasti, above the
  gluteus medius) -> "the most active of the hip muscles measured" (table:
  gluteus medius > maximus > biceps femoris).
- DLSU activation (Muyor order vasti > gluteus medius > maximus; Wang 2003
  lateral step-up more knee and ankle, forward more hip power) -> supported
  as an order; fractions remain judgement calls.
- BSU drive (ExRx synergist "Gastrocnemius (second leg)") -> wording ->
  "the calf of the second leg, the one that follows".
- BSU knee (ExRx "Lead knee should point same direction as foot") ->
  supported; model knee 6.5 cm ahead of the ankle, 7 cm behind the toe joint,
  4 cm inside -> kept.
- BSU torso (ExRx relatively upright, slightly forward with heavier loads;
  stepping distance emphasises the gluteus maximus; model 27° -> 3°) ->
  supported.
- BSU bar: "just below the neck, across the top of the shoulder blades" and
  "grip a little wider than your shoulders" -> not the model (bar 2 cm above
  and 5 cm behind the neck joint; hands 78 cm apart vs shoulder joints 39 cm)
  -> "across the upper back at the base of the neck ... well outside the
  shoulders", correct cue "take a wide grip well outside your shoulders".
- BSU Simenz 2012 (standard step-up the most gluteus maximus of four) ->
  supported (activation comment only).
- Adduction squeeze: "StrengthLog squeezes them" -> StrengthLog says push the
  pads together by bringing the legs together -> reworded; StatPearls
  medial-compartment list includes adductor longus, magnus and gracilis and
  "These muscles adduct the thigh" -> supported. "hold there for nearly a
  second" -> model holds ~0.5 s -> "pause there for about half a second".
- Adduction open (StrengthLog return with control) -> supported; timing
  "about a second ... nearly twice that" -> "a little over a second ... about
  two seconds" (1.2 s close, 2.0 s open).
- Adduction stretch (ExRx legs apart until a slight stretch) -> supported.
- Adduction back (ExRx "Lie back") -> supported as worded.
- Adduction grip: "ExRx holds the side bars to stay in place" -> ExRx only
  says "grasp bars to sides" -> "ExRx grasps the side bars".
- Adduction stabilisers: ExRx lists no significant stabilisers -> dropped
  "core" (gracilis and pectineus, ExRx's synergists, kept as before).
- Library anchors re-read in SampleData.swift: Leg Extension 0.91, Front
  Squat 0.94, Smith Machine Squat 0.86 / 0.50, Step-Up 0.82 / 0.64 (medius
  0.44), Cable Hip Adduction adductor longus 0.85 -> as stated.
- Activation levels all match their fractions; bright = primary everywhere
  except the documented SLE gluteus maximus LOW secondary (0.10).

Ghosts:
- SLE "seat": the trunk tipped 12° back about the pelvis put the spine
  through the back pad -> now the hips and trunk rise ~7 cm (up a reclined
  pad, so away from it) and the mid-spine bows ~3.5 cm off the pad.
- SLE "pivot": a 7 cm slide of the whole body was hard to see, and moving the
  feet with it drew the shins into the roller -> hips and trunk ~10 cm
  forward, feet left behind the roller, knees re-seated (bones kept; knee
  93° -> ~80°), the knee ~10 cm ahead of the pivot.
- All other ghosts checked on the sheet: mistakes readable, no knee or elbow
  bent backward, no limb through equipment (the Smith rack ghost is drawn over
  the near plate at that view, still readable).
