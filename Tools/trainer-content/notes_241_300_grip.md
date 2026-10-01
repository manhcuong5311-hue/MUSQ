# Batch 241-300: grip holds (2026-09-27)

Content: `spec_241_300_grip.py` (Plate Pinch Hold `platePinchHold`, Dumbbell Static Hold
`dumbbellStaticHold`, Barbell Static Hold `barbellStaticHold`, Towel Grip Hold `towelGripHold`).
Ghosts: `Tools/fault-review/faults_241_300_grip.swift.txt`.

- `python3 spec_241_300_grip.py` prints OK, and `python3 spec_241_300.py` prints OK for all 26.
- In the gen.py dry-run, no pill covers any probed joint once the rows are mapped into 0.16-0.80, and no two
  leaders cross. After the visual review (below) the pills and leaders were drawn over the app's own trainer
  screenshots and fault stills (`scratchpad/b241/vfix_grip/tr_*.png`, `st_*.png`; second round
  `scratchpad/b241/vfix2_grip/`). The closest pill is the dumbbell's "Wrists straight" (u 0.682 at v 0.587),
  0.03 right of the left thigh's outer edge.
- The eight new pieces and the table entries typecheck (`xcrun swiftc -typecheck`, exit 0). They were checked
  spliced into a scratch copy of the integrated `FaultPoses.swift` in place of its grip-hold pieces and table
  entries (`scratchpad/b241/vfix_grip/FaultPoses_vfix.swift`; second round `vfix2_grip/FaultPoses_vfix2.swift`);
  nothing in the project was edited.

All four are timed: the app logs their sets in seconds (`ExerciseCatalog.timedExercises`). Every setup ends
with a hold for the set time and a sourced starting duration.

## Shared findings

**The clips do not move.** Each model holds one position for 8 s. The elbows drift 3° at most, and the wrists
and fingers do not move at all. Every fault is therefore drawn at full strength throughout (`.always`), and
**every still can be taken at any moment**. `fault_times.py` classes them as holds and reads every still at
2.0 s.

**The framings put the lifter's left arm on the right of the frame.** Plate, dumbbell and towel are framed at
yaw -0.5, the barbell at -0.8.

**Label layout.** The loads sit at v 0.41-0.61 on both sides of the standing figures:

- plates: v 0.47-0.60
- dumbbell heads: v ~0.41-0.54
- bar plates: v 0.41-0.57

So no pill goes on the middle row. The head and shoulder pills sit at the top (0.16), as on the Farmer's
Carry. The posture pill sits at 0.32 on the left. The rest:

- The shoulder pill is "Shoulders back" (from u 0.697). The first labels ("Shoulders back and level",
  "Shoulders back, no slump", from u 0.550) covered the right side of the head in the trainer, and in the
  side-view shoulder stills they lay on the back of the neck and the upper trapezius, where the slump is drawn.
- The posture dot is on the upper abdomen (`support_PectoralisMajor_Abdominal_L`, v 0.32-0.37 in the trainer)
  in all three standing holds, not the spine: the spine leaders crossed the right arm at the elbow, and the
  barbell's spine dot sat at the waistband 19 pt from the left wrist dot. The plate and dumbbell first used the
  `chest` joint, but that is a spine bone: in their side-on posture stills it sat inside the trunk, under the
  ghost's forward-hanging elbows (see the second visual round). The labels are "Tall, braced" and "No leaning
  back", short enough to end left of the right upper arm (u 0.274 and 0.318).
- The arm pills ("Arms long") sit at 0.32 right of the near (left) elbow on the plate and dumbbell holds.
- The hand pills sit just under the load: 0.64, or 0.587 for the dumbbell, whose lower head ends at ~0.54 and
  whose left knee is at 0.64. The plate, dumbbell and barbell labels are "Wrists straight" (15 characters) so
  they start right of the left thigh (plate and dumbbell, from u 0.682) or end left of the right knee (barbell).

**Grip-muscle roles** used in the copy and the activation panels:

- The hand and forearm flexors make the grip force, and the forearm extensors steady the wrist. Sources:
  Derwin 2015, NSCA Coach 2(3):8-17; Snijders 1987, Med Sci Sports Exerc 19(5):518-523 (gripping and pinching
  always create a flexing moment at the wrist, which the extensors balance).
- FDS, FDP and FPL are the only muscles that can flex the finger and thumb interphalangeal joints; the hand's
  own muscles also flex the knuckles, and the flexor pollicis brevis the thumb's base and knuckle (Gill 2024,
  Stronger by Science). Gill rates strengthening FDS and FDP as even more important to grip than the FPL.
- The FDP is the workhorse of fist formation, and the FDS joins in tight fists (Fox 2019, Orthopedics
  42(6):e555-e558). That is why FDP ranks above FDS in the three support-grip holds.
- Mogk & Keir 2003 (Ergonomics 46(9):956-975): baseline extensor activity was greatest with the forearm
  pronated and the wrist extended, and with the forearm pronated extensor activity exceeded the flexors' at
  every target force. The barbell hold (palms back, pronated) therefore gets a higher wrist-extensor level
  (0.48) than the neutral-grip dumbbell hold (0.40), and its copy says the extensors work harder with the
  palms facing back than facing in.
- **Stabilisers are shown by the app as contributing below 20%** (`Sheets.swift`, `stabiliserNote`). So no
  muscle that does real work goes on that line: the thumb muscles were taken off it (see the plate, dumbbell
  and barbell sections).

**The wrist fault is the same in every hold.** The wrists curl toward the palms as the grip tires.

- The sources are general findings, not specific to these exercises:
  - A flexed wrist cut maximum grip force by 40-50% (Mogk & Keir 2003). The copy gives the figure.
  - Grip strength falls away from the self-chosen ~35° extension, and at least 25° of extension was needed
    for the strongest grip (O'Driscoll 1992, J Hand Surg Am 17(1):169-177).
  - With the wrist flexed, FDS, FDP and FPL are too short to produce maximal force, and the strongest grip
    comes at 20-45° of extension (Gill 2024).
  - For the pinch: every deviated wrist position cut pinch strength, by 14-43%, and palmar flexion cut it
    the most (Imrhan 1991, Appl Ergon 22(6):379-384). Halpern & Fernandez 1996 (J Hum Ergol 25(2):115-130)
    found deviated wrist postures, forearm postures and pinch type together cut peak pinch strength by as
    much as 33%; that is not a wrist-only figure, so the copy no longer uses it.
- The models' wrists are 4-11° extended, so every grip cue's correct text and the plate (WRISTS BENT) and
  dumbbell (WRISTS CURLED IN) comparisons say "straight or slightly back". They do not ask for the 20-45° of the lab studies, because the
  models do not show it, and they do not claim a straight wrist is where the flexors squeeze hardest.
- No source names wrist curling as a common error in these holds. The cue rests on the grip-strength findings
  above.
- The piece is `holdWristsCurled(axis, degrees)`, and its turn directions were checked with a Python copy of
  `FaultGhost.solve` on each rig. It draws only the forearms and hands (the barbell's first ghost also drew the
  bar; see the second visual round):
  - Palms in (dumbbell): `.forward`, -35. The palm point moves ~7 cm in toward the thigh on both sides. The
    handle is 8 cm below the wrist, so the heads move ~4.6 cm in, about their ~4 cm of clearance.
  - Palms back (barbell): `.lateral`, -45. The fingertips move ~9 cm back toward the thighs.
  - Palms forward overhead (towel): `.lateral`, -40. The fists tip ~8 cm forward.
  - **Not the plate pinch.** Its plates rest against the outer thighs (see the plate section), and the wrist's
    flexion axis runs front to back, in the plane of the plates. Curling the wrists would tip the whole plate
    pair about the wrist: -35° swings the plates' lower edges, 33-35 cm below the wrist, about 20 cm toward
    the midline, through the legs, and even 10° moves them 6 cm into the thigh. So the plate hold has no pinch
    ghost (the app draws its ring on the cue's joint, the left hand), and its copy says the wrists "bend"
    rather than "curl in toward the thighs".
- The towel hang has no load that bends the wrist: the body weight pulls straight along the nearly vertical
  forearms (168-171°) into vertical towels. Its mistake is written as a position to avoid ("Letting the wrists
  bend forward over the towels instead of holding them straight"), not as something fatigue brings on.

**Grip type in the labels.** The dumbbell and barbell holds are support grip (holding a load for time), not
crush grip (fingers closing against resistance, as with grippers): Derwin 2015; Gill 2024. Their cue intros
and corrections say to squeeze; their labels were shortened to "Wrists straight" to clear the legs (above), as
was the plate pinch's in the second visual round (its sheet title, "Pinch and Wrists", and intro still name
the pinch).

**Shoulders, posture and head** in the three standing holds follow the Farmer's Carry. Sources:

- ExRx.net Farmer's Walk: arms straight down at the sides; static scapula and clavicle elevation; "traps and
  grip".
- StrengthLog Farmers Walk: look ahead, keep the body in a straight line without leaning excessively forward,
  brace.
- PureGym Plate Pinch: brace the core and glutes.

Ghosts:

- `holdSlumped(withBar:)` is a new piece. It uses the Farmer's Carry "shoulders" moves, drawn to the grip so a
  bar rides along.
- `holdLeanedForward(10)` is a new piece for the plate and dumbbell posture faults. The first draft used
  `leanedForward(10, strength: .always)`, as the Farmer's Carry, which turns the arms rigidly with the trunk:
  the shoulders went 9.1 cm forward but the grip went 2 cm back, the arms ending 10° behind vertical and the
  load behind the shoulders. A hanging load stays under the shoulders, so the new piece counter-turns the arms
  10° about the shoulders (the `barRestedOnThighs` idiom): the grip goes 9.1 cm forward with the shoulders and
  the arms keep their angle.
- `lookingDown` is a new piece with the Farmer's Carry "head" moves (that entry is inline, so they could not be
  reused by name). On all three standing rigs it bows the head point ~12 cm forward and ~6 cm down about the
  neck, the neck-to-head length kept. `headDropped()`, used in the first draft, pushed the head ~11 cm straight
  forward and stretched that segment from 10.1 to 12.4 cm, which read as the chin poking out rather than
  looking down.

The forward-and-back faults turn to `.seen(-0.8)`, which is -1.3 in total. The plate and dumbbell posture
faults turn further, `.seen(-1.0)`, -1.5 in total: at -1.3 the forward-hanging ghost arms cross the front of
the trunk where the posture dot sits, and at -1.5 the dot on the front of the chest is 53-75 px from every
ghost joint and 19-32 px from every ghost line, and its leader crosses none. The lean reads more clearly there
(the ghost head ~70-80 px forward, the hands ~50-56 px). On the barbell (framed at -0.8) the trunk and head
faults turn by `.seen(-0.6)`, to -1.4 in total (see below).

**Durations.** Gill 2024's sample programme gives the suitcase rack pull hold and the dead hang 2 sets of
20-40 s, with the load or variation chosen so the grip nears failure in 20-40 s. That supports about 30 s for
the standing holds and about 20 s as a towel starting point. The two standing holds' setups say to use a weight
that is hard to hold by the end. The app's default timed target is 30-45 s (`SetMeasure.defaultTarget`), above
the towel's sourced start of about 20 s: a note for the lead.

## Plate Pinch Hold (277, `PlatePinchHold`, yaw -0.5)

**Model:**

- Standing, feet 0.32 m apart, knees 166°, trunk vertical.
- Each hand holds a pair of smooth 33 cm plates (the pair is 5.7 cm thick) at its side, rim level with the
  wrist.
- The palm faces the thigh. The fingers lie almost flat on the outer face (middle finger 67° in all), and the
  thumb is on the inner face, nearest the body.
- Wrists are 11° extended. Elbows are 161-164°, not locked. The hands are right under the shoulders.
- **The plates rest against the outer thighs.** On the skinned body mesh at 2.0 s (UsdSkel skinning of the
  shared AnatomyBody; `scratchpad/b241/rv_grip/mesh.py`, `inside.py`, `clear.py`), the inner plate's face is at
  |x| 0.216 m and the vastus lateralis reaches 0.257 m: on the left ~480 thigh and shorts vertices lie inside
  the plate disc, up to 4.1 cm deep, and the right side mirrors it. The first draft's "2 cm clear" came from the femur line and an assumed thigh
  radius. The copy therefore no longer asks for plates hanging clear of the legs.
- The builder's note says "two plates, smooth sides out".

**Claims and sources:**

- The pinch is finger against thumb, a grip type distinct from crush and support grip (Derwin 2015; Gill
  2024). Plates of equal weight are pinched for time, and the load goes up with more or heavier plates (Derwin
  2015).
- "Holds them by friction alone": Gill 2024 says pinch grip is "totally reliant upon how much friction force
  you generate". The chalk tip rests on Gill 2024 and on StrengthLog's plate pinch guide (chalk and plate
  design change the load you can hold). The copy does not mention chalk.
- "Thumb ... carries as much force as the fingers together" is mechanics: the thumb's push on one face
  balances the four fingers' push on the other. Most of that thumb force comes from the hand's own thumb
  muscles (below), which the copy does not name.
- "A wrist bent toward the palm cut it the most": Imrhan 1991.
- Smooth sides out:
  - StrengthLog, The 10 Best Forearm Exercises (Abelsson 2024): plates without ridges or handles are harder
    to grip.
  - Gill 2024: a pinch is easier when the fingertips wrap under a raised lip than on the flat face.
  - The builder's note.
  - PureGym: fingers on the outside, thumb closest to the body, plate hanging by your side, pinch as hard as
    you can, lower with control, go heavier once you can hold 30 s.
- Setup duration, about 30 seconds: StrengthLog (Abelsson 2024: about 20-30 s before adding weight); PureGym
  (30 s before going heavier); Derwin 2015 example circuit (plate pinches 30 s). StrengthLog's sample grip
  workout uses 3 sets of max time.
- "Keep your toes clear in case they slip": StrengthLog (Abelsson 2024), "watch your toes".
- **Plate position** (cue `sides`, replacing the first draft's "Plates hang free"). The plates hang still at
  the sides, under the shoulders: ExRx Farmer's Walk (arms straight down at the sides) and PureGym (plate
  hanging by your side). "Plates that drift forward sit in front of the shoulders, which then have to hold them
  out as well" is lever mechanics, as in the Dumbbell Static Hold. No source names the drift as a plate-pinch
  error. The cue asks for the plates "beside the legs", which the model shows.
- **Activation.** Thin evidence: no EMG study of a plate pinch exists.
  - Flexor Digitorum Superficialis P 0.64 and Flexor Digitorum Profundus P 0.60: the finger side.
  - Flexor Pollicis Longus P 0.56: the thumb's long flexor. It is kept moderate and below the finger flexors
    because most of the thumb's pinch force comes from the hand's own thumb muscles. Kozin 1999 (J Hand Surg
    Am 24(1):64-72): nerve blocks that switched off the hand's own muscles cut key pinch by 60% (median), 77%
    (ulnar) and 85% (both). Maier & Hepp-Reymond 1995 (Exp Brain Res 103(1):108-122): in a thumb-index grip
    the adductor and short flexor of the thumb tracked force closely, while the long flexor showed varying,
    on average moderate, correlations. Gill 2024 rates FDS and FDP above the FPL for grip.
  - Wrist Extensors S 0.42: Snijders 1987 (pinching makes a flexing moment the extensors balance) and Derwin
    2015.
  - The hand's own thumb muscles carry much of the pinch but are not in the panel. Adductor Pollicis would be
    filed under the leg adductors, "thenar" is dropped, and the stabiliser line is worded as below 20%, which
    would be false for them. **Option for the lead:** "Flexor Pollicis Brevis" maps to forearms through the
    "pollicis" keyword and passes `validate()`. It could replace the Wrist Extensors row (e.g. P 0.58, with
    "wrist extensors" moved to stabilisers). It is not on the approved name list and it is a hand muscle filed
    under forearms, so it was not used.
  - Stabilisers: upper trapezius, core.

**Faults (all still: best moment any):**

| Cue | Ghost | Best moment |
|---|---|---|
| pinch | none: the ring on the left hand, pill "Wrists straight". Mistake "Letting the wrists bend as the pinch tires." (the thighs block a curl in; see the wrist section) | any |
| sides | `armsSwungForward(14).seen(-0.8)`: the grip ~15 cm forward, the plates drifting in front of the thighs. The pill is on the near elbow, which stays in view at -1.3 | any |
| shoulders | `holdSlumped().seen(-0.8)` | any |
| posture | `holdLeanedForward(10).seen(-1.0)` (-1.5 in total): shoulders and plates ~9 cm forward; the upper-abdomen dot is on the front of the chest, clear of the ghost arms | any |
| head | `lookingDown.seen(-0.8)` | any |

The comparison is "WRISTS BENT" (Imrhan 1991: every deviated wrist position cut pinch strength, palmar flexion
the most; Gill 2024). The first review round's "WRISTS CURLED IN" / "Wrists curl toward the thighs" described
the move the thighs block. The first draft's "PLATES AGAINST THE LEGS" had the model on its mistake side.

## Dumbbell Static Hold (278, `DumbbellStaticHold`, yaw -0.5)

**Model:**

- Stance as above, knees 174-179°.
- A heavy dumbbell hangs at each side: heads 24 cm across, 45 cm long, handles front to back. The heads clear
  the thighs (about 4 cm at the heads' height and depth on the skinned mesh), so the "beside the legs" copy
  fits.
- The palms face the thighs, and each hand sits in the middle of its handle, fingers closed (153°).
- Arms are straight (178°), hands 1 cm ahead of the shoulders. Wrists are 5° extended.

**Claims and sources:**

- Stand holding the load with the arms straight down at the sides: ExRx Farmer's Walk. The setup (squat
  between the dumbbells, grip, stand) follows ExRx's preparation steps.
- About 30 seconds with a weight that is hard to hold by the end: Gill 2024 (suitcase rack pull hold, 2 x
  20-40 s, grip near failure in 20-40 s); Derwin 2015 (farmer's walks 30 s in the example circuit).
- "Dumbbells that drift forward ... the shoulders then have to hold them out as well" is lever mechanics, as
  in the Dumbbell Shrug grip cue.
- The comparison's correct note says wrists straight or slightly back leave the finger flexors long enough to
  squeeze hard. The first draft said straight wrists were where they squeeze hardest, which O'Driscoll 1992
  and Gill 2024 contradict.
- **Activation:**
  - Flexor Digitorum Profundus P 0.80 and Flexor Digitorum Superficialis P 0.72: Fox 2019, Gill 2024.
  - Upper Trapezius S 0.42: ExRx (static scapula elevation, "traps and grip"); StrengthLog lists the
    trapezius as a primary muscle of the farmer's walk. Kept low-moderate because the model does not shrug.
  - Wrist Extensors S 0.40: Mogk & Keir 2003; Snijders 1987.
  - Stabilisers: levator scapulae, erector spinae, core. The thumb flexors do work in the hold (Cha et al
    2014, via Gill 2024: the thumb gives ~17% of whole-hand grip force), so they are not listed as below 20%;
    they get no row because of the four-row limit.
  - No EMG study of a static dumbbell hold exists.

**Faults:**

| Cue | Ghost | Best moment |
|---|---|---|
| grip | `holdWristsCurled(.forward, -35)`, front-on | any |
| sides | `armsSwungForward(14).seen(-0.8)`: the dumbbells drift in front of the thighs (grip ~15 cm forward) | any |
| shoulders | `holdSlumped().seen(-0.8)` | any |
| posture | `holdLeanedForward(10).seen(-1.0)` (-1.5 in total): shoulders and dumbbells ~9 cm forward; the upper-abdomen dot is on the front of the chest, clear of the ghost arms | any |
| head | `lookingDown.seen(-0.8)` | any |

The comparison is "WRISTS CURLED IN", from the Mogk & Keir finding.

## Barbell Static Hold (279, `BarbellStaticHold`, yaw -0.8)

**Model:**

- Stance as above.
- An Olympic bar with 45 cm plates, held overhand: palms face back toward the thighs, thumbs round the bar.
- Hands are 0.48 m apart, about shoulder-width, just outside the thighs. Arms are straight (178°) and angled
  19° forward.
- The bar hangs 18-19 cm ahead of the shoulders, just below the hip crease (bar y 0.852, hip joint 0.909), and
  3.5-5 cm clear of the shorts and the fronts of the thighs on the skinned mesh. The first draft's "~12 cm
  clear" took the thigh surface as 8.5 cm in front of the femur line; it is 13-14 cm.
- The arms cannot hang straight down: at bar height the fronts of the thighs are 13-15 cm ahead of the
  shoulder joints, so the bar clears them only because the arms angle forward. The bar cue asks for straight
  elbows and the bar close in front of the thighs, not for vertical arms.
- Wrists are 4-5° extended. The builder's reference is ExRx's barbell shrug.

**Claims and sources:**

- Palms-down grip about shoulder-width, knees slightly bent, hips straight, back tall: ACE Exercise Library,
  Shrug (barbell).
- Rack set just above the knee: Gill 2024 (barbell holds from an above-the-knee rack or block pull).
- "With the palms facing back they work harder than with the palms facing in": Mogk & Keir 2003 (baseline
  extensor activity greatest with the forearm pronated).
- About 30 seconds with a weight that is hard to hold by the end: Gill 2024 (suitcase rack pull hold, 2 x
  20-40 s); Derwin 2015.
- **Bar position.** A bar close to the thighs keeps the load near the body; one that drifts forward sits
  further in front of the shoulders, which must work harder to hold it out. This is lever mechanics. StrengthLog
  Rack Pull: "pull the bar close to your body with a straight back".
- **Posture fault.** Leaning back with the hips forward arches the lower back and lets the bar rest on the
  thighs, which "can take some of the weight off the grip". This is mechanics set against ACE's hips straight
  and back tall. No study measures it. Thigh contact in itself is normal in a rack-pull lockout (StrengthLog
  Rack Pull), so the fault is the lean back and arched lower back. The first draft's "the spine takes the
  strain" was an unsourced safety claim and was dropped.
- **Activation:** as the dumbbell hold, with the wrist extensors at 0.48 (pronated, Mogk & Keir).
  Stabilisers: levator scapulae, erector spinae, core (the thumb flexors were taken off, as in the dumbbell
  hold). No EMG study of this hold exists.

**Views.** The trunk and head faults turn to -1.4 in total (`.seen(-0.6)`), as the Barbell Shrug (same bar,
same -0.8 framing); the grip and bar faults stay at -0.8:

- At -0.8 the forward-and-back axis and the side-to-side axis both project almost straight across the screen
  (~0.7 each). In the app's stills the looking-down head moved (-39, +20) px, which reads as a tilt to the
  lifter's right; the slumped shoulders slid 20-30 px sideways; and the lean-back ghost's bar slid 23 px along
  itself on top of the real bar, with the pelvis moving 19 px.
- At -1.4 (projected with the app's camera and fault-mode scale and lift): the head bows (-54, +25) px in
  profile; in the lean back the head goes 42 px back, the pelvis 26 px forward, and the bar, nearly end-on,
  33 px back onto the ghost's thighs.
- From about -1.0 to -1.8 the left plates (1 m out, 0.19 m ahead) stand between the camera and the lifter's
  hips and hands (at -1.4 the near plate covers display x 345-580, y 731-963 in the 920-wide stills). The
  ghost is drawn over the model, so its lines show over the plate, as in the Barbell Shrug's stills. The head,
  neck, chest, the shoulder dot and the posture dot on the upper abdomen stay above the plate.
- The grip stays at -0.8: at -1.4 both real hands and the grip dot (right hand) would be behind the plate,
  and at -0.8 the wrist kink, which is the fault, reads (~37 px off the forearm line). Its ghost draws no bar:
  from -0.8 the bar drawn between the curled fingertips lay on the real bar, moved ~29 px along its own length,
  so it read as the bar sliding toward the lifter's left rather than the hands curling in. The bar's rise reads
  at -0.8, so the bar fault keeps its bar.
- Pills at -1.4: "Eyes ahead, chin level" ends at display x 390, left of the ghost head (439, 563); "Shoulders
  back" starts at x 632, right of the head (to ~533); "No leaning back" ends at x 301, left of every ghost line
  and of the plate.

**Faults:**

| Cue | Ghost | Best moment |
|---|---|---|
| grip | `holdWristsCurled(.lateral, -45)`: the hands curl back toward the thighs (fingertips ~9 cm); no bar drawn | any |
| bar | `armsSwungForward(14, withBar: true)`: the bar drifts forward | any |
| shoulders | `holdSlumped(withBar: true).seen(-0.6)` | any |
| posture | `barRestedOnThighs.seen(-0.6)` (new piece): hips 0.1 torso lengths ahead, trunk 8° back about the pelvis, the arms turned -8° about the shoulders so they keep hanging, knees re-seated. Checked on the rig: trunk ~14° behind vertical, bar 7 cm back and 1.5 cm lower, so the ghost bar is drawn on the lifter's own thighs (it passes the real thigh surface by ~3.5 cm) | any |
| head | `lookingDown.seen(-0.6)` | any |

Why a new piece rather than the Trap Bar Shrug's posture moves (hips forward, trunk back with the arms turned
with it): on the skinned mesh those moves do bring the ghost body's thighs up to the bar (0.5 cm gap). But the
bar itself rises 3 cm and moves 1.6 cm forward, so over the real lifter the ghost bar floats in front of the
thighs rather than coming back onto them. The ghost is drawn as lines through the joints, so the bar has to
come back toward the thigh lines to read as resting on them. The first draft's reason ("left the bar 7 cm in
front of the thighs") was measured against the underestimated thigh surface.

The comparison is "LEANING BACK ON THE BAR".

## Towel Grip Hold (280, `TowelGripHold`, yaw -0.5)

**Model:**

- Hanging in a power rack from two towels folded over the bar, one per hand, 0.53 m apart: a little wider
  than the 0.39 m between the shoulder joints.
- Each hand grips both ends of its towel at the bottom, palm forward, fingers and thumb wrapped round (153°).
  Wrists are 8-9° extended.
- Arms are nearly straight (168-171°), upper arms beside the head.
- Knees are bent 90°, the thighs almost vertical (hips 170°) and the shins pointing back. The feet are 24 cm
  up and 0.2 m apart. The shoes' lowest point is ~6 cm above the floor (the ghost's toe-tip point sits 10 cm
  above it).
- The trunk leans 3-4° back. The head is level.
- The shoulders ride up with the arms: 4.3 cm closer to the ears than when standing, and 1.6 cm higher than
  the Pull-Up model's bottom. The builder's note says "shoulders raised".
- **Not written to.** The copy has no "pull the shoulders down" cue, because the model does not show a packed
  shoulder and no reputable source for towel-hang shoulder position was found. If the lead wants an active
  hang, the model's shoulders would need re-posing, and `hangingLoose` could then be its ghost.

**Claims and sources:**

- Towels hung from a bar give an unstable, thicker gripping surface. They work the finger and forearm flexors
  and bring in the forearm extensors to steady the wrist (Derwin 2015). Derwin's towel pull-up photos show the
  knees bent with the feet off the floor.
- "Simply grip and hang" instead of lifting yourself; 2 x 20 s in the sample workout; uneven holds and
  single-arm holds with light ground touching are listed as variations (BarBend, Boly, published 19 Sep 2018,
  updated 25 Jul 2023, an op-ed; used only as a practitioner source). DeadHangs.com is the builder's reference
  (practitioner, updated 3 Mar 2026): hands shoulder-width, arms straight, 10-20 s sets.
- Setup "sturdy towel" and "let them take some weight to check they do not slide": DeadHangs (bend the knees
  and let the towel take some bodyweight, confirm it does not slide on the bar before committing full weight;
  avoid thin hand towels). The last step ends "put the feet down", since the lifter hangs with bent knees.
- Setup "about 20 seconds to start": BarBend 2 x 20 s, DeadHangs 10-20 s, Gill 2024 (dead hang 2 x 20-40 s).
- The hand spacing ("a little wider than your shoulders") follows the model. Snarr 2017 (J Hum Kinet 58:5-13,
  doi:10.1515/hukin-2017-0068) used 1.5 times shoulder width for towel pull-ups; it is not cited in the copy.
- **Long arms.** Exel 2026 (Eur J Sport Sci 26(6):e70197): its lab dead hangs were held with fully extended
  elbows and a horizontal gaze, and elbow flexion ended the trial. BarBend: "simply grip and hang". The body
  weight hangs from the hands whatever the elbow angle, so the copy does not say bending the elbows lightens
  the grip. It says a half pull-up makes the arm and back muscles hold as well, and they can tire before the
  grip, which is what the set is meant to exhaust. It is a fingerboard hang study, not a towel hang.
- The claim that a swing adds to the pull on the hands at the bottom of each swing is pendulum mechanics:
  tension exceeds body weight while moving through the bottom. The first draft's "twists the towels ... for no
  gain" was dropped.
- The claim that toes on the floor take weight off the hands is mechanics. The legs cue now says to touch
  down only to make the hold easier, since BarBend lists light ground touching as a variation.
- **Activation:**
  - Flexor Digitorum Profundus P 0.84 and Flexor Digitorum Superficialis P 0.76: body weight on a thick,
    unstable grip (Derwin 2015; Fox 2019).
  - Wrist Extensors S 0.48: Derwin 2015; Mogk & Keir 2003.
  - Flexor Pollicis Longus S 0.44: the thumb wraps the towel. Gill 2024 cites Cha et al 2014, putting the
    thumb at ~17% of whole-hand grip force.
  - The stabilisers are the four muscles Exel 2026 recorded and called postural in dead hangs: brachioradialis,
    biceps brachii, trapezius, pectoralis major. Exel reports rising beta coherence in the
    brachioradialis-biceps, trapezius-biceps and trapezius-brachioradialis pairs with fatigue, but no
    activation amplitudes, so "below 20%" for them is an assumption.
  - No EMG study of a towel hang exists. Snarr 2017 measured towel pull-ups, but no forearm muscles.

**Views.** Side views stop at -1.0 in total (`.seen(-0.5)`). The rack's front-left upright stands 0.69 m out,
level with the lifter (z -0.10 to 0.00 against the pelvis at +0.035). From about -1.3 to -2.0 it would stand
between the camera and the body. The feet hang behind the lifter, so the upright covers the left toe from
-1.0, and its base block stands in front of the ghost's toes there; the legs fault is seen at -0.8
(`.seen(-0.3)`), where a triangle test against the rack meshes finds no rack face in front of or behind any
real or ghost foot point.

**Framing.** Re-framed after the first visual round to zoom 0.75, offset [-0.023, -0.04, 0.013], yaw -0.5
unchanged (was zoom 0.807, offset y -0.017), so the fists sit below the COMMON MISTAKE banner in the fault
stills. joints.json was re-probed: wrists at v 0.197 (left) and 0.212 (right), elbows 0.29, head 0.35, pelvis
0.59, feet 0.75. The forearm glows follow the new joints ((0.633, 0.242) and (0.358, 0.254)).

**Labels.** "Wrists straight" at the top left ends left of the right hand (its leader reaches the wrist past the
outer edge of the right fist; see the second visual round); "Eyes ahead" and "Arms long" at
0.32; "Hang still" at 0.64 on the left (the first "Body still, no swing" covered the outer right thigh in the
trainer and both ghost knees in the swing still; "Hang still" ends at u 0.244, ~0.05 left of the ghost knees);
"Feet clear" at 0.48 on the right, over the rack upright (at 0.64, "Feet off the floor" lay over the real feet
in the lifted fault view of the legs still). Its leader runs down outside the left thigh to the ankle. The
head leader crosses the right upper arm mid-shaft; the raised arms frame the head, so any head pill crosses
an arm. These rows hold with the lowered framing (hands at v ~0.20, feet at 0.75).

**Faults:**

| Cue | Ghost | Best moment |
|---|---|---|
| grip | `holdWristsCurled(.lateral, -40).seen(-0.5)`: the fists tip ~8 cm forward. Mistake worded as a position ("Letting the wrists bend forward over the towels instead of holding them straight"), since no load drives it | any |
| arms | `hangPulledUp` (new piece): body up 0.12 torso lengths (7 cm), hands fixed, elbows re-seated from 168° to ~119°, flaring out 10 cm the way they already point; front-on | any |
| legs | `hangToesDown(11).seen(-0.3)` (new piece; -0.8 in total, clear of the rack): shins swing 11° down about the knees, the ankles ~7 cm lower, the toe-tip point at the floor plane (12° put it 1 cm under) | any |
| body | `hangSwung(10).seen(-0.5)` (new piece): the whole body swings 10° forward about the hands: knees ~27 cm forward, hips ~19 cm, head ~7 cm, elbows unchanged, toe tips ~5 cm off the floor | any |
| head | `chinCraned.seen(-0.5)` | any |

The first draft used `kipping` for the swing. On this model the shins point back, so turning the thighs 38°
forward took the ankles 11 cm down and the toe tips 7.8 cm through the floor (3.5 cm even at 20°), and the feet
coming down blurred it with the legs ghost. The mistake copy now reads "Swinging forward and back under the
towels."

The comparison is "HALF PULL-UP".

## New pieces

- **`holdWristsCurled(_:_:)`**: grip holds, the wrists curling toward the palms (forearms and hands only; the
  `withBar:` option was dropped with the barbell grip's bar). Documented with the axis and sign for each hand
  orientation.
- **`holdSlumped(withBar:)`**: the Farmer's Carry slump, drawn to the grip, with an optional bar.
- **`holdLeanedForward(_:)`**: standing holds, the trunk leaning forward with the arms still hanging straight
  down, so the load comes forward under the shoulders.
- **`barRestedOnThighs`**: the barbell hold's lean back with the hips forward.
- **`hangPulledUp`**: a towel hang turned into a half pull-up.
- **`hangToesDown(_:)`**: bent-knee hang, the toes lowered to the floor.
- **`hangSwung(_:)`**: a hang, the whole body swinging forward about the hands.
- **`lookingDown`**: standing holds, the head bowed toward the load (the Farmer's Carry head moves).

Reused: `armsSwungForward`, `chinCraned`. (`leanedForward` is no longer used here; the Farmer's Carry
"posture" still uses it and has the same rigid-arm problem.)

## Sources

Each source was opened on 2026-09-27. Where only the abstract was read, that is stated.

**NSCA and Stronger by Science:**

- Derwin J 2015, NSCA Coach 2(3):8-17. PDF read in full. The year is inferred from the volume numbering; the
  PDF shows no date.
- Gill C, 26 Feb 2024, Stronger by Science, "The Evidence-Based Guide to Grip Strength Training & Forearm
  Muscle Development" (strongerbyscience.com/grip). Read on the page, including the anatomy section (the
  interphalangeal-flexor statement, flexor pollicis brevis, FDS and FDP rated above FPL, Cha 2014), wrist angle
  (20-45° extension) and the sample programme (suitcase rack pull hold and dead hang, 2 x 20-40 s).

**Peer-reviewed** (abstracts only, except Exel 2026, whose methods and results were read in the full text on
Europe PMC):

- Mogk JP, Keir PJ 2003, doi:10.1080/0014013031000107595
- O'Driscoll SW et al 1992, doi:10.1016/0363-5023(92)90136-d
- Imrhan SN 1991, Appl Ergon 22(6):379-384, doi:10.1016/0003-6870(91)90079-w
- Halpern CA, Fernandez JE 1996, PMID 9735592
- Maier MA, Hepp-Reymond MC 1995, Exp Brain Res 103(1):108-122, doi:10.1007/bf00241969
- Snijders CJ et al 1987, doi:10.1249/00005768-198710000-00016
- Kozin SH et al 1999, doi:10.1053/jhsu.1999.jhsu24a0064
- Fox PM et al 2019, doi:10.3928/01477447-20190812-06
- Exel J et al 2026, doi:10.1002/ejsc.70197
- Snarr RL et al 2017, doi:10.1515/hukin-2017-0068. Notes only, not cited in the copy.

**StrengthLog:**

- Plate Pinch
- How to Train Your Forearm Flexors and Grip (Richter D)
- Farmers Walk
- The 10 Best Forearm Exercises for Muscle & Strength (Abelsson A, updated 20 May 2024): plate pinch, hold
  about 20-30 s before adding weight; plates without ridges or handles are harder to grip; watch your toes.
- Rack Pull: step up close to the bar, brace, pull the bar close to your body with a straight back until
  standing straight.

**Other technique references:**

- ExRx.net Farmer's Walk (web.archive.org copy, 2024)
- ACE Exercise Library, Shrug

**Practitioner guides:**

- PureGym, Plate Pinch (no author or date)
- BarBend, Boly J (CSCS), The Benefits of Towel Pull-Ups, Rows, and Much More, published 19 Sep 2018, updated
  25 Jul 2023 (marked as an op-ed). BarBend's statement that towel pull-ups raised latissimus dorsi activity
  contradicts Snarr 2017's abstract (no difference), so it is not used.
- DeadHangs.com, Towel Hang (updated 3 Mar 2026; the builder's reference)

## Library entries (report only; SampleData not edited)

- Plate Pinch Hold: intermediate. Towel Grip Hold: advanced. Both fit the sources: bodyweight on towels is a
  hard grip load (DeadHangs: expect towel hang time to drop to 30-50% of standard dead hang time).
- Dumbbell and Barbell Static Hold: beginner. Both fit.
- **Towel Grip Hold equipment.** "TOWEL" is not in `ExerciseCatalog.isBodyweight` (`["BODYWEIGHT", "BENCH"]`),
  so its set rows show the placeholder "–" instead of "BW" (`ExerciseDetailView`), although the load is body
  weight. Recommended: keep "TOWEL", which names what sets the lift apart (library equipment strings are
  single items), and add it to `isBodyweight`: `["BODYWEIGHT", "BENCH", "TOWEL"]`. The alternative is equipment
  "BODYWEIGHT", as the Pull-Up. The first draft's "TOWEL + BAR" suggestion is withdrawn.

## Review round (2026-09-27)

Applied from the two reviews: the plate model's thigh contact (free cue replaced by a plate-position cue, new
comparison, setup and ghost); FPL ranked below the finger flexors in the pinch; thumb muscles taken off the
stabiliser lines; Imrhan 1991 for the pinch wrist claim; "straight or slightly back" in every grip cue and
the dumbbell comparison; 40-50% in the shared wrist line; the barbell bar and posture copy (arms angled, no
unsourced spine claim); the towel arms, legs and body copy and a safer setup; support-grip labels; the towel
swing and toes-down ghosts; `lookingDown` for the standing heads; the barbell geometry numbers; the source
wording (Gill, Mogk & Keir, Exel, Halpern, BarBend dates) and new sources (Imrhan, Maier & Hepp-Reymond,
StrengthLog 10 Best Forearm Exercises and Rack Pull, Gill's programme).

Not applied: Flexor Pollicis Brevis as a plate row (not on the approved name list; left as an option above).
For the lead, from the model review: `wrist.py`'s `facing()` reads the Y-up, +z-forward joint space as Z-up, so
its "up"/"down" labels are the room's forward/back and its "forward"/"back" the room's down/up. The barbell's
"down" palms are really facing back and the towel's "up" palms forward; this spec reads both correctly, but
other families relying on those labels for hands that are not horizontal should check.

## Visual review round (2026-09-27, app screenshots)

Two reviewers read the trainer screenshots (start and two peaks) and all 20 fault stills from the simulator.
Each finding was checked against the screenshots and, for ghosts and turned views, with a Python copy of
`FaultGhost.solve` plus the app's camera and fault-mode scale and lift (`scratchpad/b241/vfix_grip/sim.py`;
it reproduces the stills to a few px, and the -0.8 barbell plate outline to within a few px).

Applied:

- Plate and dumbbell: "Shoulders back" (was "Shoulders back and level" / "... no slump"); "Tall, braced" on
  the chest (was "Stand tall, brace" on the spine); `holdLeanedForward(10)` for the posture ghosts.
- Plate: the plate-position cue moved to the near elbow as "Arms long" at 0.32 on the right (it was on the right
  hand, hidden behind the near plate in its -1.3 still, the leader ending on the plate rim); no pinch ghost,
  and the pinch mistake and comparison say the wrists "bend" (the plates rest on the thighs, so a curl in is
  blocked).
- Dumbbell: "Arms long" (was "At your sides", which touched the forearm glow); "Wrists straight" (was
  "Squeeze, wrists straight", over the left thigh).
- Barbell: "Shoulders back"; "No leaning back" on the upper abdomen (was "Tall, no leaning back" on the spine,
  over the right deltoid and beside the left wrist dot); "Wrists straight" (was over the right knee and, in the
  grip still, the right shoe); head, shoulders and posture ghosts turned to -1.4.
- Towel: "Hang still"; "Feet clear" at 0.48; the grip mistake worded as a position.

Not applied:

- Plate pinch: swapping the hand pills (pinch on the right hand as "Wrists straight", sides on the left hand)
  was the second option; the near-elbow pill matches the dumbbell hold and keeps "Pinch" in the label. The
  pinch pill's left end touches the outer edge of the left knee in the trainer (reviewer: acceptable).
- Barbell grip `.seen(-0.6)` (offered as optional): at -1.4 both real hands and the grip dot are behind the near
  plate.
- Towel head leader crossing the right upper arm: kept (mid-shaft; any head pill crosses an arm).

For the lead (outside these files):

- **Towel Grip Hold framing** (both reviewers, high; applied with the first option below, see the second
  visual round). In mistake mode (scale 0.935, lift ~0.09 of the view) the
  fists rise to v ~0.03-0.07, under the COMMON MISTAKE banner, which in the grip still hides the left hand and
  its curled ghost; the arms, legs and body stills also have the fists under it. Lower the model in
  `SampleData.modelByExercise` and `probe.py` JOBS: `ModelFraming(yaw: -0.5, zoom: 0.75, offset: [-0.023,
  -0.04, 0.013])` (projected: hand tips v 0.154/0.172, wrists 0.197/0.212, toe tips 0.794; in the grip still
  the left real and ghost tips move to display y ~383-398, below the banner) or keep zoom 0.807 with offset y
  -0.076 (hands 0.202/0.218, feet 0.797, toe tips 0.84). The yaw is unchanged, so every towel `.seen()` stays;
  re-probe joints.json, re-run gen.py (the rows above still hold), redo the thumbnail and re-shoot the stills.
- The crown of the head sits under the banner in the standing-hold stills (the head ghosts are below it). If
  wanted, lower the plate and dumbbell offset y by ~0.012 and re-probe.
- The towel model's own activation tint covers most of the front of each upper arm, while the panel lists only
  forearm muscles and the biceps as a below-20% stabiliser: a material fix for the next export.
- The one-line legend cuts every primary line ("FLEXOR DIGITORUM SUPERFICIALIS · FLEXOR DI..."), so the plate's
  thumb flexor never shows on the trainer screen: an app legend layout issue.

## Second visual review round (2026-09-27, app screenshots after the re-frame)

Two reviewers read the round-two trainer shots (start and two peaks) and all 20 fault stills, with the towel
re-framed (zoom 0.75, offset [-0.023, -0.04, 0.013]). Each finding was checked against the screenshots and
re-measured with `vfix_grip/sim.py` (ghost solve plus the app's camera and fault-mode scale and lift),
`vl2g/cand.py` and `leader.py`, a leader-crossing check (`vfix2_grip/cross.py`) and the rack triangle test
(`vg2grip/towel_occ.py`).

Applied:

- **Plate and dumbbell posture dot.** `chest` is a spine bone, so in the side-on posture stills it sat inside
  the trunk: on the plate 1 px from the ghost's left elbow (hidden under it), on the dumbbell 20 px from it,
  with the leader through the ghost's right elbow (3 px). Both now use `support_PectoralisMajor_Abdominal_L`,
  as the barbell (trainer dot (0.486, 0.324) and (0.487, 0.322) on the lower chest; the level leader crosses the
  right upper arm ~0.045 above the elbow), and both posture faults turn to `.seen(-1.0)`, -1.5 in total. At
  -1.3 the new dot would sit on the plate ghost's right upper-arm line (1 px), and the dumbbell leader would
  cross that line 17 px before the dot. At -1.5 the dot is on the front of the chest: plate (427, 636), 75 px
  from the nearest ghost joint and 32 px from the nearest line; dumbbell (429, 633), 53 px and 19 px; neither
  leader crosses a ghost line. Changing only the view kept `chest` 27 px from the ghost chest with the leader
  7-9 px from it. Re-shoot both posture stills.
- **Plate pinch pill** "Wrists straight" (was "Pinch, wrists straight"), row 0.68, from u 0.682. In the
  shrunk pinch still the old pill's left end covered the outer left calf by ~18 pt; the new one starts ~38 px
  right of it, and its leader runs straight up the plate to the hand. In the trainer it starts ~22 px right of
  the left knee (the old one touched it). The sheet title "Pinch and Wrists" and the intro still name the pinch.
- **Barbell grip ghost** draws no bar (`holdWristsCurled(.lateral, -45)`): see the barbell Views. No view that
  keeps the near plate off the hands separates the bar's move from its own length (at -1.0 the tips still move
  33-35 px along it).
- **Towel legs view** `.seen(-0.3)` (-0.8 in total): at -1.0 two rack faces lay in front of each ghost toe tip
  (the ghost toes read as resting on the upright's base block) and the real left toe tip was behind the
  upright. At -0.8 the drop is the same (~50 px at the toes), no rack face covers any real or ghost foot point,
  and the "Feet clear" leader to the left ankle stays above the ghost shin and ankle. Re-shoot the legs still.
- **Towel comments** updated for the re-frame (wrists at v 0.20-0.21).

Accepted without a change:

- **Towel grip leader** from "Wrists straight" (row 0.16, ends u 0.318) to the right wrist (0.355, 0.212)
  passes the outer third of the right fist. The dot is on the wrist band and reads. A pill level with the wrist
  (rows 0.18-0.20) ends 2-6 px from the fist or wrist; a lower row (0.24-0.26) sends the leader over the red
  forearm and crowds "Eyes ahead" at 0.32; the right side is taken by the left fist, the rack upright and the
  top-right buttons.

For the lead (outside these files):

- **Re-integrate the grip family** against the current joints.json. The integrated towel content was
  generated before the re-probe: SampleData's towel glows are still (0.65, 0.20) and (0.35, 0.21); this spec
  now gives (0.633, 0.242) and (0.358, 0.254). layout.txt also lists the old towel joints. Pill labelPoints do
  not depend on the joints.
- Copy the grip pieces and table from `faults_241_300_grip.swift.txt` into `FaultPoses.swift` (the
  `holdWristsCurled` signature lost `withBar:`; no other family uses it), then re-shoot the plate and dumbbell
  posture stills, the plate pinch still, the barbell grip still and the towel legs still. No best moment
  changed (all `any`).
- The towel model's own material tints the front of each upper arm red while the panel lists forearm muscles
  only: limit the tint to the forearm at the next export (as in the first round).
- App-level, as before: the one-line legend truncates every primary line (the plate's thumb flexor never
  shows), and the COMMON MISTAKE banner touches the crown of the standing heads in the plate, dumbbell and
  barbell stills (the towel fists now clear it by ~14 px).
