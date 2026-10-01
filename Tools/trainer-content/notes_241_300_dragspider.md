# Batch 241-300: drag curls, spider curls and the alternating hammer curl (2026-09-27)

Content: `spec_241_300_dragspider.py`. Ghosts: `Tools/fault-review/faults_241_300_dragspider.swift.txt`.
Six exercises from SourceExports/241-300: 252 Drag Curl, 253 EZ Bar Drag Curl, 254 Cable Drag
Curl, 265 Dumbbell Spider Curl, 266 EZ Bar Spider Curl, 268 Alternating Hammer Curl.

How the models were read: the briefs and the three framing shots each, then the rig straight
from the converted USD with Blender's pxr: elbow angles, upper-arm angle to vertical in the
sagittal plane, elbow and wrist positions against the shoulder, pelvis and chest, forearm angle
to horizontal, shoulder-to-wrist and hand-to-hand distances in torso lengths (every 1/3 s), the
hand joint's frame for the palm (its +Z is the palm normal; forearm roll measured from the
palm-in position), and the bar, cable and dumbbell prims' own bounds (EZ bar bends located
against the hands; the cable pulley's position). Joint screen positions from `joints.json`
were overlaid on the framing shots to see what each label dot sits on.

## Checks run

- `python3 spec_241_300_dragspider.py` prints OK.
- gen.py dry run (the command in the brief) lays out all six with 5 annotations each; the
  labels were also drawn at the production rows (squeezed to 0.16-0.80 as `spec_241_300.py`
  does) over the start and top framing shots, with leaders to each dot at that moment and the
  glows, and checked at all eight probed moments: no leader crosses the head or another
  leader, no leader runs through a pill, no pill covers a tracked dot or another pill, and on
  the three drag curls no leader passes within 0.02 of another label's dot. (Revision: the
  first layout had the EZ Bar Drag Curl's range and torso leaders crossing at the bottom, and
  on all three drag curls the range leader ran through or grazed the pelvis dot there; the
  range rows were re-pinned.) `emit()` runs on every entry.
- Visual review revision (after integration, on the app's own trainer shots and fault stills,
  and after the Drag Curl and EZ Bar Drag Curl were re-framed): every layout was re-checked on
  the shots' pixel grid at the production rows every 1/6 s over the 8 s loop, with the pills'
  measured SF 12 pt widths plus 5% and `TrackedCallout`'s edge clamping (gen.py's `width()`
  under-reads the real pills by 8-14 pt, so a leading pill near the margin is pushed inward):
  no leader crosses the head or another leader or runs under a pill, no pill covers a dot or
  key joint, no leader passes within 6 px of another dot. In each fault view the cue's pill
  was checked against the lifted, scaled (0.935) and turned model and its ghost (a port of
  `FaultGhost.solve` over the skinned USD). Plate and cable-column occlusion was re-scanned
  at every fault view.
- Second visual review revision (on the rebuilt app's trainer shots and fault stills; none of
  these six was re-framed, so `joints.json` and the round-one projections still hold, dots
  within 1-2 px): the three drag curls' torso cue moved from the pelvis, whose dot sat on the
  bar or handle at the bottom of each rep (on the Drag Curl and Cable Drag Curl ~11-13 px from
  the near-hand dot), to the base of the neck, which never comes nearer than ~38 px to the bar;
  the Drag Curl's shoulder cue moved to the near shoulder so the two top leaders do not cross;
  the Drag Curl and EZ Bar Spider Curl grip labels were shortened; the Cable Drag Curl grip
  pill moved level with the far fist; the spider curls' range pill moved to the lower left
  (its leader lay along the pad's front edge); the hammer curl's shoulder label was widened
  so its leader clears the raised right dumbbell. Each layout was re-run through the pixel
  checker over 51 samples (0-8 s) and each moved pill through the fault-view check at the
  real `.seen()` totals, then painted over the shots and stills. Four ghosts were redrawn with
  fewer chains (drag curls' torso, the hammer curl's shoulder and torso; the cable drag
  curl's shrug without its bar line); their moves and strengths, and so every still moment,
  are unchanged.
- Equipment occlusion: the plate, bar, dumbbell and bench meshes were projected through
  `probe.py`'s camera with per-triangle depth against each label joint, at the default
  framings and at the ghost views.
- Ghosts: a Python port of `FaultGhost.solve` (BodyFrame, turns about -left/-up/forward with
  the `_R` mirroring, `.between` / `.withBend` strengths, tips along the bone's +Y) was run on
  each model's own joint transforms at 0.5 s steps, and every ghost drawn at its still from its
  view, side-on and head-on to check direction and size.
- Swift: the PIECES were inserted into a scratch copy of FaultPoses.swift (before
  `// MARK: Back pieces`) and the TABLE entries at the end of the table; `xcrun swiftc
  -typecheck` passed, and a small harness built with it found all 30 ghosts through
  `FaultPoses.fault(exercise:cue:)` (13 tracked joints per exercise). No xcodebuild, no
  simulator.

## Tool note (affects other families)

The first `b241/wrist.py` read skeleton space as Z-up while the converted rigs are Y-up, so the
first briefs' palm labels were shifted (`up` meant forward). The tool and the briefs are now
fixed, and every palm statement here was re-checked against the app's shots: drag curls palms
forward with the bar at the thighs and up at the top (EZ bar partly in), spider curls palms
forward at the bottom, hammer curl palm in. The one copy that did not match, the drag curls'
"Hold the bar palms-up" (the bar starts at the thighs, palms forward), now reads "Take the bar
underhand, hands about shoulder-width apart and palms facing forward with the bar at the
thighs", and its why says "with the forearms turned palm-up".

---

## Drag Curl (252, yaw -0.8, zoom 0.653)

**Model.** Standing tall, feet ~0.3 m apart, knees ~174°, trunk upright (0°) and still, no
shrug (shoulder height fixed). Olympic barbell, underhand, forearms fully palm-up (90° from
palm-in), hands ~0.42 m apart. Bottom: the bar sits 3-5 cm in front of the hips at the tops of
the thighs (shaft 0.89 m up, pelvis 0.91 m; shaft centre 5.1 cm from the skinned shorts, bar
radius ~1.4 cm), upper arms vertical, elbows ~138°; every rep starts ~42° short of a straight
arm. The bar rises straight up the front of the body, 3-5 cm off its surface the whole way
(4.6 cm from the obliques mid-rep, 5.2 cm from the pecs at the top; 18-23 cm ahead of the
pelvis joint), while the elbows travel back: upper arms 28°
behind vertical by mid-rep (elbows 13 cm behind the shoulders), easing to 15° behind at the top
as the forearms pass horizontal. Top: bar at the lower chest (1.27 m, ~23 cm below the base of
the neck), elbows ~55°, forearms ~19° above horizontal, so the bar stays ~25 cm in front of the
elbows. Wrists ~12° extended throughout. Two reps of 4 s: up ~1.3 s (0.25-1.5 s), ~0.7 s at
the top, down ~1.5 s (2.25-3.75 s; elbows 56° at 2.25 s, 138° at 3.75 s), ~0.5 s still at the
bottom. Framed from the front-left, facing screen left (re-framed from -1.1 / 0.916, where the
near plate hid the left elbow and hand for three quarters of each rep): no label joint is
behind a plate at any moment (the near elbow dot touches the plate's rim mid-rep); the pelvis
joint sits behind the shaft at the bottom.

**Claims and sources**
- Shoulder-width underhand grip; raise the bar straight up so the elbows travel back,
  following the hips and waist; the elbows come forward a little once the forearms pass
  horizontal: ExRx Barbell Drag Curl (the model does exactly this: 28° back at mid-rep, 15° at
  the top). StrengthLog Drag Curl: pull the bar up along the body by driving the elbows back,
  keep it close, stop at upper-chest height with the forearms parallel to the floor, lower
  slowly along the same path.
- "Stopping at the chest with the forearms about level leaves the bar out in front of the
  elbows, so the biceps is still loaded at the top; carrying on until the forearms are upright
  lets the load rest over the elbows": the load's lever arm at the elbow is the horizontal distance from the
  elbow to the bar (~25 cm here, ~0.95 of its maximum); ExRx's comments on the drag and barbell
  curls (bringing the elbows forward so the forearms reach no more than vertical permits a
  relative release of tension between repetitions); StrengthLog's end point (forearms
  parallel). ExRx's own drag curl continues until the forearms are perpendicular, so
  the copy describes stopping level as this model (and StrengthLog) does, not as the only way.
- Mistake "elbows swing forward, the bar arcs away, an ordinary curl ... with the front
  deltoids helping": StrengthLog (the drag curl is defined by the elbows going back and the bar
  travelling along the torso rather than forward); Coratella et al. 2023 JFMK (flexing the arms
  forward during barbell curls raised anterior deltoid excitation); StrengthLog Hammer and
  Dumbbell Curl (elbows forward put load on the front delts).
- Shoulders down; shrugging the bar the last few centimetres like an upright row lets the
  upper traps lift part of the load: StrengthLog Drag Curl (keep the shoulders down); a shrug
  raises the bar with the shoulder girdle (mechanics); ExRx lists the upper trapezius and
  levator scapulae as stabilisers.
- Palms up gives the biceps its best leverage and the most activity: Coratella et al. 2023
  Sports (supinated +12% biceps against neutral, +19% against pronated, ten bodybuilders at
  8RM); Murray et al. 1995 (the biceps' flexion moment arm peaks higher with the forearm
  supinated). Revision: the first copy called palms-up the biceps' "strongest position"; it is
  not the strongest curl grip (Kohn et al. 2018: isometric elbow-flexion MVC 243.6 N neutral
  against 213.6 N supinated, both above pronated), so the copy now says best leverage. Curling the wrists
  in moves the bar with the wrists and loads them: StrengthLog Dumbbell Curl (bent wrists take
  needless load).
- Range: "each rep starts with the bar back at the thighs", lower slowly along the same path;
  curl training through a long range built more strength than through a short one: Pinto et
  al. 2012 (0-130° against 50-100°: 1RM +25.7% against +16.0%; thickness up in both);
  StrengthLog (lower slowly along the same path). The copy says a long range rather than full
  range: the models' reps bottom out at ~138° (about 42-125° of flexion), while ExRx ("lower
  until arms are fully extended") and the NSCA start with straight arms; the cue compares
  lowering to the thighs with turning round at the stomach (~30° of flexion), which is what
  Pinto's comparison supports. It stops at "the tops of the thighs", where this model's bar
  returns. The first copy said "over two to three seconds"; the models lower in ~1.5 s, so it
  now says "slowly".
- Torso still, no leaning back or hip rocking: NSCA Basics manual (no momentum), StrengthLog
  (stable torso), ACE/Young 2014 (swaying lets other muscles take load off the biceps). The
  first copy added that it "loads the spine instead of the elbow flexors"; no cited source
  says so, and momentum does not move load from one to the other, so the why now says only
  that the elbow flexors skip part of the lift.
- Activation: Biceps Brachii 0.84 HI > Brachialis 0.62 MOD > Brachioradialis 0.44 MOD. ExRx:
  target biceps; synergists brachialis, brachioradialis, posterior and anterior deltoid;
  StrengthLog: primary biceps. No EMG study of the drag curl was found (PubMed / Europe PMC
  search, 2026-09-27), so the shares sit just under the Barbell Curl (0.90 / 0.66 / 0.52),
  since the rep starts ~42° short of straight in this model. Judgement.
- Stabilisers: posterior deltoid, anterior deltoid, upper trapezius, wrist flexors (ExRx's
  synergist and stabiliser lists). Note: with the bar in front of the shoulder the external
  moment tends to extend the shoulder, so the posterior deltoid's share is not obvious
  mechanically; it is listed because ExRx lists it.
- Comparison: BAR SWINGING OUT (the drag curl's defining error).

**Uncertain.** No EMG data for the drag curl; the popular claim that it emphasises the biceps
long head is not in the copy. (Drawing the elbows behind the body extends the shoulder, which
lengthens the long head at the shoulder rather than shortening it; no study shows what that
does to its activity or growth in this lift.) The model's bottom is ~42° short of straight, so
the copy says a long range rather than full range (see Library notes for re-keying the models).

**Labels and glows.** Re-laid for the -0.8 framing. Torso, "Stand tall, no leaning" (0.22,
left), marks the base of the neck (`neck`), a ~31 px stub beside the head. It first marked the
pelvis, which sits behind the bar at the bottom: its dot lay ~11 px from the near-hand dot, both
leaders coming up from the lower right ~10° apart, so the two labels seemed to mark the same
spot on the bar. Every front-of-trunk joint is swept by the bar; the neck never comes nearer
than ~38 px to it. Row 0.22 rather than 0.28: in the torso fault view (side-on) the leader from
0.28 ran through the ghost's hands, from 0.22 it passes above them (0.20 and higher cross the
head in the trainer). Shoulder, "Shoulders down" (0.24, right), now marks the near (left)
shoulder: with the far shoulder from the left the two top leaders would cross. The elbow cue,
"Elbows back" (0.44, right), sits level with the near elbow, a 25-35 px stub to it; from the
top row its leader lay along the near upper arm for most of the loop. Range (near hand, 0.62)
below it on the right. Grip, now "Underhand grip" (far hand, 0.56, left): the longer pill
reached ~20 px over the far thigh and hip, and its leader passed 17 px from the far elbow at
the top (the wrists are in the cue sheet). Glows: the near biceps (full), its elbow (soft); no
nudges, so they follow the re-probed joints.

**Ghosts and stills** (top = elbows most bent, ~1.6-2.0 s; bottom = 0 s / 4 s):
- elbow: `armsTurned(.lateral, 35, withBar: true, strength: dragTop)`: both arms swung 35°
  forward about the shoulders (upper arms from 15° behind to 20° in front at the top), the bar
  arcing out in front; shown from ~112° up (`dragTop`); **top**; `.seen(-0.7)` (total -1.5,
  true left side). After the re-frame the old `.seen(-0.4)` gave -1.2, where the two arms'
  V's sit ~8% of the view width apart and join into a W over the plate. At -1.5 they fold into
  one clean V (the elbow ~9% of the view width ahead of the real one); the near plate stands in front of the real arms
  and chest there (as it did at the first framing's -1.5), and the ghost is drawn over it.
  Front-on (-0.8, no plate in the way) the two V's and the bar line form a W across the chest.
- shoulder: `dragShrugged(withBar: true)`: shoulders, arms and bar 0.12 torso lengths (~7 cm)
  up, with `dragTop`; **top**; `.seen(0.7)` (total -0.1, near front-on, both shoulders in view,
  nothing behind a plate).
- grip: `dragWristsCurled(65)`: both hands folded 65° toward the palm, with `dragTop`; **top**;
  no turn (-0.8: the fold ~72% in the picture plane, both hands clear of the plates). 65°, not
  the family's 50°, because the re-frame shrank the model (zoom 0.916 to 0.653) and a 50° fold
  moved the finger tips only ~3% of the view width; the Spider Curl uses 65° for the same reason.
- range: `dragCurlShort(from: 0.78, to: 0.84)`: upper arms 18° further back and elbows 43°
  more bent at the bottom (138° to ~95°, the model's own pose a third of the way up), the bar
  held at the stomach, still on the body; full at the model's bottom (0.848), none by ~120°;
  **bottom**; no turn (-0.8, both hands clear at the bottom).
- torso: `dragSwung(near: "L")` (new: bodySwung's moves, hips 0.06 forward, trunk and arms 15°
  back about the pelvis, with a shoulder-to-wrist strength: none at 0.84, the models' bottom,
  all of it by 0.6, ~83°). `bodySwung` reads the elbow bend and would already show ~0.47 of the
  lean with the bar still at the thighs (neck ~7 cm behind the lifter's), since these models
  never straighten the elbows; **top**; `.seen(-0.7)` (total -1.5: the spine and head lean
  clearly back behind the real head; at -1.2 the arm chains tangled over the plate). Drawn as
  the spine, the hips and the near (left) arm: side-on the far arm lay beside the near one, its
  upper arm running down next to the chest-to-neck spine segment (a narrow "N") and its forearm
  doubling the near one, and the bar line was an end-on stub. The far arm's points keep their
  dashed guides (app).

## EZ Bar Drag Curl (253, yaw -0.3, zoom 0.891)

**Model.** The Drag Curl's body and arm motion to within a degree (elbows 139° to 55°, upper
arms to 28° behind vertical, bar 0.90-1.28 m, trunk still). EZ bar, hands on the outer angled
grips (the grip sockets sit at ±0.195 m, on the outer angled segment between the third and
fourth bends from the middle), ~0.41-0.43 m apart; forearms 67-72° from palm-in, i.e. ~18-23° short of fully palm-up;
wrists 9-17° extended. Framed near front-on (re-framed from -1.1, where the plate hub hid the
left hand for the whole clip): no label joint is behind a plate at any moment. The shorter bar
keeps its plates ~0.4 rad of yaw from the arms: from -0.6 to -1.0 the near plate hides the
left upper arm or elbow at the top, while at -1.5 only the hands are behind it.

**Claims and sources** (as the Drag Curl, plus the grip)
- The drag curl can be done with an EZ bar: ExRx Barbell Drag Curl (comment).
- Hands on the angled grips turn the palms partly in: Marcolin et al. 2018 (EZ bar puts the
  forearms near semi-prone); measured on the model (~20° less supination than the straight bar).
- "Which many lifters find easier on the wrists": StrengthLog EZ Curl (the angled grip can be
  kinder to the wrists and elbows; no study cited, hence the hedge).
- "A straight bar has worked the biceps slightly harder at most, so the choice comes down to
  comfort": Coratella et al. 2023 JFMK (straight bar +1.8% biceps in the lifting phase with
  the arms still, +3.8% lowering with the arms flexed, no difference in the other two
  conditions); Marcolin et al. 2018 (no significant straight-vs-EZ difference; the choice is a
  matter of subjective comfort). "At most" replaces the first copy's "only slightly", which
  gave only the half of the evidence that found a difference.
- Activation: Biceps Brachii 0.82 HI > Brachialis 0.62 MOD > Brachioradialis 0.46 MOD: the
  biceps a touch under the straight bar (Coratella 2023 JFMK), the brachioradialis a touch
  over (Marcolin 2018: EZ brachioradialis at least as high as the straight bar's). Differences
  this small are not backed by any study; judgement.

**Labels and glows.** Re-laid for the -0.3 framing. The shoulder cue points at the top of the
near trap beside the neck (`attachment_TrapeziusUpper_L`, from the top right; the support joint
projects onto the throat when front-on). The elbow cue, "Elbows back" (0.36, right), sits level
with the near elbow, a 15-25 px stub; only ~88 px is free beside it, and from below or above
the leader lay along the forearm or upper arm. The range cue (near hand) comes from low on the
right (0.62), its leader rising up the side of the waist; from 0.22 its pill sat on the near
shoulder and, in the range fault, on the ghost's upper arm. Grip, now "Angled grip" (0.44,
left), sits level with the far hand at the bottom: from the longer pill's right end the leader
ran along the far forearm at the top (the wrists are in the cue sheet). Torso, "Stand tall, no
leaning" (0.18, left), marks the base of the neck, a ~29 px stub ending ~12 px left of the head
and neck: from the pelvis (0.72) its dot sat on the bar's middle hump at the bottom of each
rep, the first frame the viewer sees (0.14 crosses the head, 0.22-0.26 cover the far upper
arm). Glows as the Drag Curl.

**Ghosts and stills**: the Drag Curl's pieces and moments (elbow top, shoulder top, grip top,
range bottom, torso top, the torso ghost `dragSwung(near: "L")` with the near arm only, as on
the Drag Curl: the far arm doubled the near one over the plate), with the views re-set for
-0.3. Elbow and torso `.seen(-1.2)` (total
-1.5, true left side: one V and a clear backward lean; the old `.seen(-0.4)` gave -0.7, where
the two V's sit across the chest and the lean runs toward the camera). Shoulder `.seen(0.3)`
(total 0, square-on: the shrug rises evenly and the ghost's near shoulder stays ~13 px off the
top-right pill; the old `.seen(0.7)` swung the lifter to +0.4 for no gain). Grip
`dragWristsCurled().seen(-0.5)` (total -0.8, as the Drag Curl: front-on only ~30% of the fold is
in view and it reads as the bar held higher; at -0.8 each hand shows a hook, the far hand clear
of the plate, the near one at its rim). Range no turn (front-on shows the bar held at the
stomach, both hands clear).

## Cable Drag Curl (254, yaw +1.1)

**Model.** The same body and arm motion (elbows 139° to 55°, upper arms to 28° back, bar
0.89-1.27 m up the front of the body). A straight cable bar, fully palm-up, hands ~0.47 m apart,
on the low pulley of a dual cable column straight in front: pulley 0.65 m ahead of the pelvis,
0.12 m up (~0.45 m ahead of the toes). The cable runs forward and down from the bar, ~31° off
vertical at the bottom and ~20° at the top. Framed from the front-right, facing screen right
toward the stack; the near arm is the right.

**Claims and sources** (as the Drag Curl, plus)
- The cable pulls the bar forward as well as down, and drawing the elbows back holds it against
  the body: the cable's line measured on the model (mechanics).
- Stand close to the pulley: ExRx Cable Curl (stand close to the pulley); a closer stance makes
  the cable run more steeply (geometry). No reputable technique page for the cable drag curl
  itself was found (only gym-app and magazine pages), so the rest follows the barbell version.
- Leaning back against the cable as the torso mistake: NSCA (no momentum), StrengthLog.
- Activation as the Drag Curl (0.84 / 0.62 / 0.44): no study of cable drag curls. The
  cable's lever arm at the elbow, measured on the model: at the bottom its line runs back up
  close to the elbow (~4 cm, against ~21 cm for a free bar's vertical load), mid-rep ~26 cm
  (free bar ~32 cm), at the top ~32 cm (free bar ~31 cm). So the cable version is light at the
  very bottom and matches the bar from the middle to the top, where most of the work is; the
  shares are kept, and the copy makes no claim about the cable's resistance profile.
- Comparison: BAR PULLED OUT IN FRONT.

**Labels and glows.** Near (right) arm on the left: shoulder (0.14), elbow ("Elbows back",
0.36, level with the elbow, a short stub) and range (near hand, 0.50), top to bottom. From
0.24 the range leader lay along the near upper arm and forearm at the bottom, 12 px from the
elbow dot; from 0.50 it rises to the near hand clear of both. Torso, "Stand tall" (0.22,
right), marks the base of the neck (never nearer than ~52 px to the handle), its ~76 px leader
running level across the front of the neck: from the pelvis (0.72, left) its dot sat on the
handle's near end cap at the bottom, 12-13 px under the near-hand dot. The full label runs onto
the chest front at 0.22 and covers both hands in the torso fault view at 0.20; from the left
the leader would cross the shoulder dot. Grip, "Underhand grip" (0.40, right), level with the
far fist over the tower, a stub of 32 px or less (up to the hand at the top, down to it at the
bottom, above the bar while the cable runs below it): at 0.56 its leader dropped ~104 px
from the far hand, which sits on the cable's V-bracket at the top, and ran beside the cable
like a second strand. The pill clears the far fist and bar end at the top and the far forearm
by 5 px at the bottom. The longer grip pill reached ~23 px over the front of the thighs. Glows
on the near (right) biceps and elbow.

**Ghosts and stills**: the Drag Curl's pieces turned to the right side: sagittal faults
`.seen(0.4)` (total +1.5; no plates here, and every label joint is clear side-on; grip
`dragWristsCurled().seen(0.4)`), the shrug `dragShrugged(withBar: false).seen(-0.5)` (total
+0.6, front-right: at +0.4 the right column's back panel hid the far hand and cut off the
ghost's far shoulder; from +0.5 to +1.5 no joint is behind the upright or panel; at +0.6 the
bar line ran from the near tip across the chest and crossed the far upper arm, a bow-tie under
the girdle, so it is left out and the hands and tips show the handle's rise), the torso
`dragSwung(near: "R").seen(0.4)` (the right arm is the near one; the far arm ran down beside
the spine and doubled the near forearm). Elbow top, shoulder top, grip top, range bottom, torso
top.

## Dumbbell Spider Curl (265, yaw -2.0)

**Model.** The Spider Curl's (238) body and arm motion exactly (same numbers to the
millimetre): kneeling on the seat of an incline bench, chest and stomach on the ~42° pad,
trunk 48° forward, knees ~132°, feet off the floor. Upper arms hang vertical and never move
(0° off vertical, elbows under the shoulders within 1 cm); elbows 170° to 52°, two reps. Bottom:
hands ~4 cm ahead of the elbows; top: forearms ~38° above horizontal (torque ~0.8 of its peak).
A dumbbell in each hand, palms facing forward (fully palm-up), handles across the body end to
end, hands ~0.40-0.42 m apart; wrists ~9° extended. Framed from behind on the left, larger than
the Spider Curl (zoom 0.599 vs 0.499).

**Claims and sources**
- Set-up (prone on an incline bench, knees on the seat, shoulders near the top, palms forward,
  lower until the arms are fully extended): ExRx Dumbbell Prone Incline Curl ("also known as
  Dumbbell Spider Curl"); StrengthLog Spider Curl (dumbbells, 45° bench, underhand grip, upper
  arms vertical, do not let them travel back or forwards).
- The pad stops the torso rocking, so the elbow flexors lift the whole load: ExRx; ACE/Young
  2014 (a braced upper arm gave the most biceps and less anterior deltoid).
- Load profile and the elbow fault: lever-arm mechanics on the model's geometry (hands almost
  under the elbows at the bottom, forearms level mid-rep, ~38° up at the top); elbows swinging
  toward the head bring the front deltoids in (StrengthLog; ACE 2014; Coratella 2023 JFMK) and,
  near the top, tip the dumbbells back over the elbows, which takes the load off the elbow
  flexors there (mechanics). The why limits the unloading to the top: Coratella 2023 JFMK found
  that flexing the arms forward raised biceps excitation in the lifting phase (+17.7% straight
  bar, +20.3% EZ bar), so no claim that biceps activity drops overall.
- Palms forward keeps the forearms palm-up, the position in which the biceps works hardest:
  ExRx; Coratella 2023 Sports; Murray 1995. Wrists straight: StrengthLog.
- Full range: ExRx; Pinto 2012.
- Activation: Biceps Brachii 0.86 HI > Brachialis 0.66 MOD > Brachioradialis 0.46 MOD, the
  Spider Curl's shares (same arm path, same palm-up grip). No EMG study of the spider curl;
  ExRx lists the brachialis as target with no data (see notes_191_240_curls.md, Spider Curl).
- Stabilisers: anterior deltoid, forearm flexors, middle trapezius, rhomboids (ExRx).

**Uncertain.** Activation shares (no direct study). The bench is ~42°; the setup says about
45°, as StrengthLog.

**Labels and glows.** The upper-arm (0.14), shoulder (0.22) and back (0.30) cues stacked
above the figure on the right, their leaders fanning down to the near shoulder, the far
shoulder blade and the upper back without crossing (the upper-arm leader passes over the back
of the neck, clear of the head). The upper-arm cue first sat above the head on the left (0.20);
in its fault view the model is lifted ~0.09 of the view and turned side-on, which put the head
and the ghost's raised hands inside the pill (the ghost's dot on its text). No left-hand row
works for both views. The back cue ("Chest stays on the pad") marks the `chest` joint, on the
upper back over the part of the chest pressed into the pad; the spine joint lands at the waist
from behind. The grip cue, "Palms forward" (0.60, left; the palms face forward at the bottom),
is short so its leader leaves left of the near forearm and the range dot. The range cue sits
below it on the left (0.70): its leader climbs at ~72° to the near elbow and crosses the pad's
front edge (at most ~46 px of it near the edge line, where it crosses). From the lower right
(0.62, and 0.66 before it) the leader ran at ~47° beside the pad edge, 6-12 px inside the
outline for its whole length, over the pad's lit rim, and read as the bench's edge highlight
with no visible line to the elbow. From the left the two leaders never cross (the range leader
stays 15-17 px or more from the grip dot, the grip leader 20 px or more from the range dot);
mid-rep (about 0.7 s and 3.2 s) the range leader passes over the far fist for a moment. A
trailing row higher up (0.36, level across the back) would run ~7 px under the pad dot. Glows
on the visible left arm only.

**Ghosts and stills** (top = 1.6-2.0 s; bottom = 0 s / 4 s):
- pad: `spiderPadLifted` (new: `trunkLifted(18)`'s turn, trunk 48° to 30° forward, a wedge
  opening under the ghost back, drawn as the spine and the near arm only; with both arms the
  two curled arm chains crossed each other and the spine in an M at the shoulders); **any**;
  `.seen(0.45)` (total -1.55, true left side).
- shoulder: `spiderShrugged` (the Spider Curl's inline shrug pulled out as a piece: girdle and
  upper arms 0.18 torso lengths up the pad); **any**; no turn (the back view shows it best).
- elbow: `elbowsForward(30)` (no bar line between the two dumbbells), with the elbow bend;
  **top**; `.seen(0.45)`.
- grip: `curlWristsCurled(degrees: 65)`, with the elbow bend; **top**; `.seen(0.45)`.
- range: `curlBottomCut(from: 0.8, to: 0.89)` (shoulder-to-wrist 0.904 at 170°, 0.81 at
  ~126°); **bottom**; `.seen(0.45)`.

## EZ Bar Spider Curl (266, yaw -2.0)

**Model.** As the Dumbbell Spider Curl (identical body and arm motion), with an EZ bar on the
outer angled grips, hands ~0.39 m apart, forearms 67° from palm-in (~23° short of fully
palm-up), wrists ~8° extended.

**Claims and sources.** As the Dumbbell Spider Curl; ExRx Barbell Prone Incline Curl ("grasp
curl bar", also known as barbell spider curl). Grip claims as the EZ Bar Drag Curl (Marcolin
2018, Coratella 2023 JFMK, StrengthLog EZ Curl).
- Activation: Biceps Brachii 0.84 HI > Brachialis 0.66 MOD > Brachioradialis 0.48 MOD (the
  Spider Curl's, biceps a touch lower and brachioradialis a touch higher for the EZ grip, as
  for the EZ drag curl; judgement).

**Labels**: as the Dumbbell Spider Curl (shared overrides; pad on `chest`, range from the lower
left), with the grip label "Angled grip", as on the EZ Bar Drag Curl (the wrists are in the cue
sheet). From "Angled grip, wrists flat" the leader left the arm toward the lower right at the
top, ~7° from the range leader and 11-13 px from the range dot, so the two pills could not be
told apart, and with the range cue on the left the two leaders crossed at every sample. The
short pill's leader runs near-vertical to the hand and stays 24 px or more from the range dot.

**Ghosts and stills**: as the Dumbbell Spider Curl (pad `spiderPadLifted`), with the bar drawn
on the elbow and grip faults (`elbowsForward(30, withBar: true)`, `curlWristsCurled(withBar: true, degrees: 65)`).
The grip fault has no turn: side-on (-1.55) the near EZ plate covers both hands at every
moment, while from behind (-2.0) the near hand is clear from 0.5 s on and the fold still lies
~91% in the picture plane. (The Dumbbell Spider Curl keeps its turn: its left hand is clear
side-on from 1.0 s.) Pad any, shoulder any, elbow top, grip top, range bottom.

## Alternating Hammer Curl (268, yaw -0.4)

**Model.** Standing tall, feet ~0.3 m apart, knees ~174°, trunk upright and still, no shrug. A
dumbbell in each hand, handles front to back, palms facing in; the forearms stay neutral
(within 3°) and the wrists within 9° of straight for the whole clip. The arms hang straight
(178°), the upper arms ~13° out from the sides so the dumbbells clear the thighs (hands 12 cm
outside the shoulders). The LEFT arm curls 0-4 s, the right 4-8 s; the resting arm hangs
straight. The working arm comes in to the side as it rises and finishes at ~56° with the
dumbbell in front of the shoulder (hand 23 cm ahead of and 11 cm below it), the forearm ~45°
short of vertical; the elbow drifts forward ~5 cm (upper arm up to 11° forward). The top
matches the Alternating Dumbbell Curl's to the millimetre; only the grip differs.

**Claims and sources**
- Dumbbells at the sides, palms in, elbows to the sides, curl one at a time, thumb toward the
  shoulder: ExRx Dumbbell Hammer Curl; StrengthLog Hammer Curl. ExRx raises the dumbbell until
  the forearm is vertical; the model (like the Alternating Dumbbell Curl) keeps the elbow at the
  side and stops ~45° short, so the copy says "until the dumbbell is in front of the shoulder,
  thumb up".
- Elbow by the side; drifting forward brings the front deltoid in and lets the forearm reach
  upright early, where the load leaves the elbow: StrengthLog Hammer Curl (elbows forward shift
  load to the front delts; keep the elbows close), ExRx comment (at full flexion the elbows can
  travel forward slightly, forearms no more than vertical, for a relative release of tension),
  Coratella 2023 JFMK. The correct text allows the elbow to "come forward only slightly at the
  top", as ExRx ("they can travel forward slightly") and StrengthLog ("keep them at your sides,
  or move them slightly forward") do and as the model does (~5 cm, upper arm up to 11°); the
  first copy's "without bringing the elbow forward" was stricter than both. The fault is the
  big drift that turns the top into a front raise (ghost 35°).
- Grip: "the biceps, which also turns the palm up, has less leverage and does a little less,
  while the brachialis and brachioradialis keep lifting": Murray et al. 1995 (the biceps'
  flexion moment arm peaks higher with the forearm supinated); Coratella et al. 2023 Sports
  (biceps -12% with a neutral grip against supinated, lifting phase); Plantz and Bordoni,
  StatPearls, Brachialis (a pure elbow flexor in every forearm position); Boland et al. 2008
  (fine-wire EMG: brachioradialis activation the same in neutral, pronated and supinated
  flexion) and Kleiber et al. 2015 (brachioradialis contribution the same neutral and
  supinated, higher only pronated). The copy does not say the hammer curl works the
  brachioradialis harder: ExRx (target brachioradialis) and StrengthLog (neutral grip
  emphasises the brachialis and brachioradialis) say so, but the EMG above does not show it
  (Coratella even found it 6% lower than palm-up).
- "Twisting the palm up turns it back into an ordinary curl" and wrists straight: StrengthLog
  Hammer Curl (avoid twisting the wrists or changing the grip); StrengthLog Dumbbell Curl (bent
  wrists take needless load).
- Shoulders set, no swing, full range, controlled lowering: as the Alternating Dumbbell Curl
  (NSCA Basics manual, NASM, StrengthLog; Pinto 2012). The first copy said "lower each
  dumbbell over two to three seconds"; the model lowers each in ~1.25 s (left elbow 57° at
  2.0 s, 178° by 3.25 s), so it now says "under control". The torso why no longer says the
  swing "loads the spine" (not in any cited source; see the Drag Curl).
- Activation: Brachialis 0.76 HI (primary) > Biceps Brachii 0.74 HI (primary) >
  Brachioradialis 0.44 MOD (secondary). The library lists BRACHIALIS as the primary muscle and
  the order follows it and anatomy: StatPearls (Plantz and Bordoni, NBK551630: a pure flexor in
  every forearm position) and Coratella et al. 2023 Sports, discussion (the brachialis is the
  most powerful elbow flexor and, unlike the biceps and brachioradialis, does not insert on the
  radius, so it takes no part in supination). Neither technique reference puts it first:
  StrengthLog lists the biceps as primary (and says the neutral grip targets more of the
  brachialis and brachioradialis), ExRx the brachioradialis as target. Surface EMG cannot
  isolate the brachialis, so its share is inference while the biceps' falls (Coratella -12%;
  Murray 1995). The brachioradialis is 0.44, just under the Alternating Dumbbell Curl's 0.46
  (revised from 0.48): every study points flat or down for a neutral grip (Coratella 2023
  Sports -6% against supinated; Boland 2008 and Bagchi 2019 no difference). Kleiber 2015 found
  biceps activity unchanged by hand position in slow unloaded flexions, so the biceps is kept
  close to the brachialis rather than demoted.
- Stabilisers: anterior deltoid, upper trapezius, flexor carpi radialis, extensor carpi
  radialis (ExRx Dumbbell Hammer Curl's stabiliser list, which also names the coracobrachialis,
  middle trapezius and levator scapulae; the two radial wrist muscles hold the neutral-grip
  dumbbell level against its tip toward the little finger). The first list had "wrist flexors"
  (missing the extensor) and "core" (not in ExRx).
- Comparison: ELBOW DRIFTING FORWARD (StrengthLog lists elbow position first among the hammer
  curl's mistakes).

**Uncertain.** The brachialis-over-biceps order is inference; ExRx would put the
brachioradialis first and StrengthLog the biceps. The fold ghost for the grip shows a bent
wrist, not the twisting that StrengthLog warns about (a turn of the forearm about its own axis
barely moves the palm point the ghost draws), so the label now reads "Thumb up, wrist flat"
(was "Thumb up, no twisting", which named a fault the ghost does not show; "Thumb up, wrist
straight" is 24 characters, too wide for the right-hand rows beside the left arm); the twist is
named in the why and correct text.

**Labels and glows.** Shoulder, "Keep shoulders down" (0.14, left), on the top of the right
trap (`attachment_TrapeziusUpper_R`): "Shoulders down and back" is ~167 pt wide, so the pill was
clamped inward onto the jaw and its leader ran down the neck, and the right shoulder joint sits
on the raised right dumbbell's rim during the right curl. From "Shoulders down" (pill end at
x ~106 of the 322 px shot) the leader crossed the raised right dumbbell's upper head at the top
of the right curl (~22 of its 55 px over the plate at 5.58 s); from the wider pill (end at
~130) it drops steeply to the trap and stays ≥ 6 px right of the plate, the pill 18 px from the
head at its closest. (0.14 on the right crosses the throat and the raised left dumbbell; 0.22
on the left sits on the raised right plate; the neck and support joints land on the throat.)
Elbow, "Elbow in" (0.36, right),
level with the left elbow, a 26-41 px stub; from the top row "Elbow by your side" lay along the
whole upper arm and passed the "Thumb up" dot at the top. Grip (0.62, right) below the resting
left dumbbell; range (resting right hand, 0.60) and torso (0.74) on the left, the torso pill
off the left calf. The range dot rides up with the right hand during the right curl (4-8 s);
the label explains the resting arm, and marking whichever arm rests would need a
working/resting-arm alias in the app's tracked points. Glows: the left upper arm weighted to its lower half (biceps over the brachialis, full),
the right upper arm (soft), the left forearm below the elbow (brachioradialis, soft).

**Ghosts and stills** (top of the left curl = 1.6-2.0 s):
- shoulder: `hammerHunched` (new: `hunched()`'s shift, both shoulders and arms 0.07 forward,
  0.1 up, drawn as the girdle and upper arms only, like `spiderShrugged`); **any**;
  `.seen(-0.6)`. Drawn to the hands, at the 1.6 s still the working left forearm ran up across
  the chest to ~18 px from the ghost's right shoulder and its tip poked past the right trap, so
  the ghost read as a big "N" of arm lines rather than the raised, rolled girdle.
- elbow: `elbowsForward(35, side: "L")`, with the left elbow bend; **top**; `.seen(-0.9)`.
- grip: `hammerWristBent` (new): the left hand turned 55° about the lifter's vertical at the
  wrist, which with the palm facing in folds it toward the palm and the midline (~47° with the
  forearm level, 39° at the top); with the left elbow bend; **top**; `.seen(0.4)` (total 0,
  facing the lifter, so the fold reads across the frame). Left only, like the Alternating
  Dumbbell Curl's arm faults (a two-sided version with no strength was suggested in review and
  would also work, but the family follows the Alternating Dumbbell Curl and the label is on the
  left hand).
- range: `elbowsFolded(.lateral, 60, side: "R", strength: .withBend("forearm_L"))`: the resting
  right arm half-bent (178° to ~118°) while the left curls; **top** (of the left curl);
  `.seen(1.5)` (total +1.1, right side).
- torso: `hammerSwung` (new: bodySwung's moves with a hands-apart strength, `.between("hand_L",
  "hand_R", from: 1.09, to: 1.15)`: 1.075 torso lengths with both arms down, 0.97 mid-curl,
  1.155 at the top of either curl, so the swing shows at the top of both curls; drawn as the
  spine, girdle, upper arms and hips); **top**; `.seen(-0.9)`. Drawn inline to the hands, the
  working forearm crossed the resting upper arm in an X over the chest and three long lines ran
  side by side down the back, hiding the forward hips; without the forearms the lean (ghost
  head well behind the real one) and the hips forward read at a glance. The undrawn hands keep
  their dashed guides (app).

## New pieces

`dragTop` (a `.between` strength on the left shoulder-to-wrist distance, 0.75 → 0.5),
`dragShrugged(withBar:)` (`shouldersLowered(-0.12, ...)` with `dragTop`; without the bar line on
the Cable Drag Curl), `dragWristsCurled(_:)` (`curlWristsCurled`'s fold with `dragTop`, 50° by
default, 65° on the small Drag Curl), `dragCurlShort(from:to:)` (upper arms 18° back, elbows
43° more bent), `dragSwung(near:)` (bodySwung's moves with a shoulder-to-wrist strength, none
at the models' ~138° bottom, drawn as the spine, the hips and the near arm; it replaces the
round-one `dragSwung`, which drew both arms and the bar and was used only here),
`spiderShrugged` (the Spider Curl's inline shrug, unchanged; the lead may point the Spider
Curl's "shoulder" at it), `spiderPadLifted` (`trunkLifted(18)`'s turn drawn as the spine and
near arm), `hammerWristBent` (55° about `.up` at the left wrist), `hammerHunched` (`hunched()`'s
shift drawn as the girdle and upper arms), `hammerSwung` (bodySwung's moves with the
hands-apart strength, drawn as the spine, girdle, upper arms and hips). Reused: `armsTurned`,
`elbowsForward`, `curlWristsCurled`, `curlBottomCut`, `elbowsFolded`. No fault here is tempo or
force only, so every cue has a ghost.

## Library notes

- Alternating Hammer Curl: primaryMuscle "BRACHIALIS" kept (anatomy; ExRx names the
  brachioradialis as target and StrengthLog the biceps; the EMG singles out neither). The
  Cable Hammer Curl and Preacher Hammer Curl (other families) carry the same library primary,
  but at this revision the Cable Hammer Curl ranks Biceps Brachii P 0.74 over Brachialis P
  0.66, against 0.76 / 0.74 here and 0.76 / 0.72 on the Preacher Hammer Curl; no study
  separates standing cable from dumbbell hammer curls, so the lead should pick one order for
  the standing hammer curls (this entry: Brachialis 0.76, Biceps 0.74, Brachioradialis S 0.44).
- Alternating Dumbbell Curl (191-240 curls, not in this family): its "shoulder" is the same
  `hunched().seen(-0.6)` and its "torso" the same inline bodySwung ghost drawn to the hands, at
  the same yaw and with the same arm motion, so its stills likely show the same "N" and X of arm
  lines. The lead may point its shoulder at `hammerHunched` (no strength, so it fits as is); its
  torso needs its own hands-apart numbers (0.85 → 1.0), so it would take `hammerSwung`'s chains
  inline rather than the piece.
- Drag Curl and EZ Bar Drag Curl framing: done. Re-framed to -0.8 / 0.653 and -0.3 / 0.891 as
  suggested at the first review; `joints.json` re-probed, labels re-pinned and every ghost view
  re-set for the new yaws (see each entry).
- gen.py: `width()` = (24 + 5.6 × characters) / 382 reads the real pills (SF 12 pt semibold
  plus 24 pt padding) 8-14 pt narrow, so a leading pill near the left margin is clamped inward
  by `TrackedCallout` and its inner end (where the leader leaves) sits further in than
  `layout.txt` shows; this is what put the hammer curl's first shoulder pill on the jaw.
  Measuring the label with the system font would fix `layout.txt` (not changed here).
- Drag curls 252-254, model: every rep bottoms out at ~138°, ~42° short of straight, with the
  bar at hip-crease height, while ExRx ("lower until arms are fully extended"), the NSCA and
  StrengthLog start from straight arms with the bar at the thighs, so the models show a partial
  rep. At the next export, key the bottom at ~170-175° with the bar against mid-thigh, lowered
  along the body; then re-probe, re-derive `dragTop` (0.75 → 0.5), `dragSwung(near:)` (0.84 → 0.6) and
  `dragCurlShort(from: 0.78, to: 0.84)` from the new shoulder-to-wrist distances, and restore
  straight-arm copy in the range cue.

## Sources

- ExRx.net: Barbell Drag Curl (/WeightExercises/Biceps/BBDragCurl), Barbell Prone Incline Curl
  (/Brachialis/BBProneInclineCurl), Dumbbell Prone Incline Curl (/Brachialis/DBProneInclineCurl),
  Dumbbell Hammer Curl (/Brachioradialis/DBHammerCurl), Cable Curl (/Biceps/CBCurl), Barbell Curl
  (/Biceps/BBCurl). ExRx returns 403 to direct fetches; read in full from web.archive.org
  snapshots (2024 captures, footers ©2023-2024; the Drag Curl, Hammer Curl and Barbell Curl
  pages re-read in revision).
- StrengthLog exercise guides (strengthlog.com): Drag Curl (/drag-curl/), Spider Curl
  (/spider-curl/), Hammer Curl (/hammer-curl/), EZ Curl (/ez-curl/), Dumbbell Curl.
- Marcolin G, Panizzolo FA, Petrone N, Moro T, Grigoletto D, Piccolo D, Paoli A. 2018.
  Differences in electromyographic activity of biceps brachii and brachioradialis while
  performing three variants of curl. PeerJ 6:e5165. doi:10.7717/peerj.5165
- Coratella G, Tornatore G, Longo S, Esposito F, Cè E. 2023. Bilateral biceps curl shows
  distinct biceps brachii and anterior deltoid excitation comparing straight vs. EZ barbell
  coupled with arms flexion/no-flexion. J Funct Morphol Kinesiol 8(1):13.
  doi:10.3390/jfmk8010013
- Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F, Cè E. 2023. Biceps
  brachii and brachioradialis excitation in biceps curl exercise: different handgrips,
  different synergy. Sports 11(3):64. doi:10.3390/sports11030064 (neutral grip = rope on a
  cable tower)
- Kohn S, Smart RR, Jakobi JM. 2018. Voluntary activation and twitch potentiation of the elbow
  flexors across supinated, neutral, and pronated forearm orientations. Physiol Rep
  6(1):e13560. doi:10.14814/phy2.13560 (MVC neutral 243.6 N, supinated 213.6 N, pronated
  113.6 N; used only to keep the copy from calling palms-up the strongest grip)
- Boland MR, Spigelman T, Uhl TL. 2008. The function of brachioradialis. J Hand Surg Am
  33(10):1853-1859. doi:10.1016/j.jhsa.2008.07.019
- Kleiber T, Kunz L, Disselhorst-Klug C. 2015. Muscular coordination of biceps brachii and
  brachioradialis in elbow flexion with respect to hand position. Front Physiol 6:215.
  doi:10.3389/fphys.2015.00215
- Murray WM, Delp SL, Buchanan TS. 1995. Variation of muscle moment arms with elbow and forearm
  position. J Biomech 28(5):513-525. doi:10.1016/0021-9290(94)00114-j
- Plantz MA, Bordoni B. Anatomy, Shoulder and Upper Limb, Brachialis Muscle. StatPearls
  (NCBI Bookshelf NBK551630; PMID 31869094), StatPearls Publishing.
- Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE, Bottaro M. 2012. Effect of range of motion
  on muscle strength and thickness. J Strength Cond Res 26(8):2140-2145.
  doi:10.1519/JSC.0b013e31823a3b15
- Young S, Porcari JP, Camic C, Kovacs A, Foster C. 2014. ACE study reveals best biceps
  exercises. ACE ProSource, August 2014 (ACE-sponsored EMG study, not peer-reviewed).
- Sands WA, Wurth JJ, Hewit JK. 2012. NSCA's Basics of Strength and Conditioning Manual (curl
  coaching points), as used for the 191-240 curls.
- Bagchi A, Raizada S. 2019. A comparative electromyographical analysis of biceps brachii and
  brachioradialis during eight different types of biceps curl. Indian J Public Health Res Dev
  10(5):730-735. doi:10.5958/0976-5506.2019.01098.2 (metadata checked through Crossref; its
  result as reported by Coratella et al. 2023 Sports: no biceps or brachioradialis difference
  between supinated and neutral dumbbell curls; not used for a number)
- Jahizi AAM, Malek NFA, Tan K, Marsal MZ, Janep M, Chinnasee C, Nadzalan AM. 2023. Comparison
  of electromyographic activation and number of repetitions completed between traditional,
  hammer and reverse dumbbell bicep curl among trained men. AIP Conf Proc 3013:050008 (i-MACE
  2022). doi:10.1063/5.0148594 (metadata checked through Crossref; the abstract could not be
  read in this revision, the publisher page being behind a bot check, so no result of it is
  used)
- Searched without a hit (Europe PMC / PubMed, 2026-09-27): EMG or training studies of the drag
  curl and the spider (prone incline) curl as such. For the hammer curl only the two small,
  lower-tier studies above (Bagchi 2019, Jahizi 2023). Uysal et al. 2026 (BMC
  Sports Sci Med Rehabil, doi:10.1186/s13102-026-01867-7) compared supinated, semi-supinated
  and neutral barbell-curl grips but reports phase effects rather than a grip ranking, so it is
  not used.
