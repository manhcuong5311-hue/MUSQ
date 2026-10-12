# Desktop "300-400" folder: hip thrusts (2026-10-12)

Four hip thrusts from the builder's 377-380: Smith Machine Hip Thrust (`Legs/SmithMachineHipThrust`),
Machine Hip Thrust (`Legs/MachineHipThrust`), Single-Leg Hip Thrust (`Legs/SingleLegHipThrust`) and
B-Stance Hip Thrust (`Legs/BStanceHipThrust`). `spec_1012_thrust.py` holds the copy and setup steps
(its header lists what the models show and the full citations),
`Tools/fault-review/faults_1012_thrust.swift.txt` the ghosts (new pieces prefixed `r1012thrust`) and
`Tools/fault-review/fault_moments_1012_thrust.json` the moment each ghost is stilled. This file maps
the copy's claims to their sources and to the model measurements.

## How the models were read

Scripts in `$LAB/r1012/thrust/` (the session scratchpad), run with Blender's Python + pxr:

- `measure.py`: every frame, every joint: knee and hip (trunk-thigh) angles per side, shin angle,
  elbow, trunk angle to the floor (shoulder line), spine and head shape, pelvis height and side
  tilt, rep phases from pelvis height.
- `skin.py` (UsdSkel skinning of the 125 rig meshes), `mesh.py` (seat height, shoe soles per foot,
  the back on the bench pad), `load.py` / `gap.py` (the Smith pad, the machine roller and seat, the
  dumbbell against the skinned body), `edge.py` (the bench edge in the chest joint's frame, against
  the shoulder-blade muscles), `lockout.py` (`thrustLockout`'s reading per rig), `plate.py` (the
  machine's footplate and pads).
- `proj.py` (equipment on screen with the trainer framing), `pills.py` (label layout: leaders,
  crossings, pills over dots or moving equipment, a mock on the stills), `ghost.py` (a port of
  `FaultGhost.solve`: sizes, bone lengths, knee bends; `render.py` draws a ghost over a still).
- The motion briefs (`briefs_1012/`), `tiers.txt`, `joints.json`, the stills at 0/1/2/3/5 s and two
  lab rounds of trainer and ghost shots.

## Model facts

Common to the four (one body: neck to pelvis 0.592 m, thigh 0.444 m, shin 0.398 m, shoulder
joints 0.40 m apart). The four share one trunk motion, as does the re-exported Dumbbell Hip Thrust
(its pelvis now 0.20 -> 0.52 m and knees 75 -> 100, no longer the 0.205 -> 0.462 m and 69 -> 90 that
`notes_500_hip.md` describes):

- The trunk slopes up 44 degrees to the bench at the bottom and lies level at the top (shoulder
  line -0.6 degrees). The spine keeps one shape (spine-chest-neck 172/174 degrees all clip); the
  chin tucks ~16 degrees at the top (chest-neck-head 176 -> 160), eyes along the body. No head cue.
- Bench: the B-stance, single-leg and Smith lifts use a flat bench whose pad top is 0.41 m (ExRx
  asks for 40-46 cm), its long side across the back; the machine its own back pad, top 0.50 m.
  The pad's front edge meets the back 11-12.5 cm up the spine from the chest joint, in that
  joint's frame; the teres major and infraspinatus meshes (the shoulder blades' lower ends)
  start 12-14 cm up, the shoulder joints sit 25.7 cm up. So the edge sits under the lower tips of
  the shoulder blades. It moves 1.9 cm along the back from the bottom to the top while the
  shoulder joints swing 12.6 cm toward the head: the back rocks on the edge, a pivot, not a slide.
  The back stays on the pad (0.2-0.7 cm into it).
- At the top, seen side-on (left knee, hip and shoulder joints), knees, hips and shoulders are close
  to one line: 173.5 degrees on the Smith and B-stance, 175 on the single-leg, 169.5 on the machine,
  the hip joints 2-4 cm above the knee-shoulder line; the shins within 4 degrees of vertical (the
  knees 2-3 cm toward the head from the ankles).
- Two reps in 7.96 s.

Smith Machine Hip Thrust:
- An M30 Smith rack. The bar (GYM_M30_Bar: a 50 cm pad 13 cm thick round its middle, two plates a
  side, hooks on the carriages) runs on fixed guide rods: its z never changes; it rises 23 cm
  (centre 0.49 -> 0.72 m). The pad touches the body all rep (gaps -3 to +2 mm): at the bottom on
  the top of the thighs (rectus femoris, 8-10 cm toward the knees from the hip joints), from 1 s on
  across the hip crease (the shorts over the hips; the pad's axis 2-4 cm toward the knees from the
  hip joints at the top).
- Hands on the bar 62 cm apart, 6 cm outside the pad each side, 9.2 cm from the bar's axis all rep
  (a fixed grip), elbows 97 -> 155 degrees.
- Safety stops 7 cm below the carriages' lowest point; never touched.
- Feet flat all clip (soles at 1 mm), ankles 40 cm apart, toes out 8 degrees. Knees 75 -> 100,
  2.9 cm (top) to 5.6 cm (bottom) inside the ankles each side. Hips (trunk-thigh) 101 -> 168
  (170 at 1.5 s), pelvis 0.20 -> 0.52 m; the seat 8 cm off the floor at the bottom.
- Timing: still at the bottom to 0.42 s, up 0.46-1.54 s, held 1.58-2.25 s (~0.7 s), down
  2.29-3.54 s, at the bottom 3.58-4.42 s (~0.8 s).

Machine Hip Thrust:
- A plate-loaded lever machine (HTP_*): a fixed back pad (top 0.50 m, front edge z -0.30, as the
  bench's), a low seat pad under the hips (top 16 cm), a footplate tilted up ~12.5 degrees toward
  the toes (the foot mat's slope; the soles' heels 6 cm up, toes 11-12 cm), and a lever (HTP_LeverPivot) pivoting behind the
  back pad, its arms carrying a padded roller (60 cm long, 13 cm thick) across the hips, two handles
  beside them and a horn with one 20 kg plate at the lifter's right.
- The Smith's body motion lifted 9 cm: pelvis 0.29 -> 0.61 m, trunk-thigh 104 -> 165 (170 at
  1.5 s), knees 76 -> 105, shins within 4.3 degrees of vertical at the top. Feet 40 cm apart, toes
  out 8 degrees.
- The roller stays on the hip crease all rep (its axis 2.5-4.5 cm toward the knees from the hip
  joints, gaps under 3 mm) and rises 26 cm on its arc.
- Hands on the handles (72 cm apart), elbows 58 -> 100.
- At the bottom the seat touches the seat pad (the shorts 0-4 mm above it) for ~0.8 s between reps.
- Timing as the Smith's.

Single-Leg Hip Thrust:
- No load. Arms spread along the bench top, hands resting on the pads 1.08 m apart, still all clip
  (elbows 95 -> 81 as the trunk turns).
- Only the LEFT leg works: foot flat (soles at 1 mm), the ankle 15 cm left of centre (the hip joint
  9 cm), toes out 3 degrees; knee 73 -> 97.5, within 2 cm of over the ankle side to side; hip
  99 -> 172 (173 at 2.25 s).
- The RIGHT leg is held off the floor, unchanged all clip: knee bent 75 degrees, the thigh drawn up
  to 75 degrees from the trunk line (hip flexed ~105 degrees from straight). At the top the thigh
  points straight up (15 degrees past vertical toward the head) with the shin level, the foot 86 cm
  off the floor; at the bottom the foot is 22 cm up.
- The pelvis stays level (the two hip joints at equal height to the millimetre) and square all clip.
- Pelvis 0.20 -> 0.52 m; seat 8 cm off the floor at the bottom. Timing: still to 0.29 s, up
  0.33-1.33 s, held 1.38-2.17 s (~0.8 s), down 2.21-3.54 s, at the bottom 3.58-4.29 s (~0.7 s).

B-Stance Hip Thrust:
- A dumbbell (HG_LapDumbbell: 34 cm, 16 cm heads) across the hips, centred, held by both heads
  (hands 29 cm apart, elbows 71 -> 149); its heads rest on the hips and upper thighs (vertex gaps
  under 1 cm), the handle 3-5 cm toward the knees from the hip joints; it rises 21.5 cm.
- The LEFT foot flat (soles at 1 mm), ankle 20 cm left of centre, toes out 8 degrees: knee 75 -> 100,
  shin within 4 degrees of vertical at the top.
- The RIGHT foot 18 cm further forward (ankle z 0.72 vs 0.54; its heel at z 0.67, beside the ball
  of the left foot, whose toe end is at 0.77), on its heel with the toes up all clip: the heel end
  at 1 mm, the toe end 7 cm up; foot bone pitch +2 degrees against the flat left foot's +24. Toes
  out 7 degrees. Knee 109 -> 137, hip 112 -> 164.
- Hips 101 -> 168 (left), pelvis 0.20 -> 0.52 m, level and square all clip. Timing as the
  single-leg's.

Paint (`$LAB/r1012/tiers.txt`): GluteusMaximus, GluteusMedius, GluteusMinimus, RectusFemoris and
the three vasti bright on all four; the single-leg's Sartorius (the rig's hip flexors) bright too,
on both sides; BicepsFemoris, Semimembranosus, Semitendinosus and ErectorSpinae dim.

## Sources opened (2026-10-12)

- ExRx, Barbell Hip Thrust: Wayback id_ snapshot 2026-04-03 of
  exrx.net/WeightExercises/GluteusMaximus/BBHipThrust (read in full). ExRx, Gluteus Medius: Wayback
  id_ snapshot 2026-06-24 of exrx.net/Muscles/GluteusMedius ("Steadies pelvis so it does not sag
  when opposite side is not supported with leg"). ExRx's hips exercise list (snapshot 2026-07-17)
  has no Smith, lever, single-leg or B-stance hip thrust.
- StrengthLog, Hip Thrust and One-Legged Hip Thrust (live pages).
- REP Fitness, Smith Machine Hip Thrust (R Borchert, 30 Jul 2025); Fitness Volt, B Stance Hip
  Thrusts (P Dale, 2022/2024) and Dumbbell Hip Thrust (V Vukas, 2023/2024); Physitrack, single leg
  hip thrust (live pages).
- Europe PMC abstracts: Contreras 2015, Collazo Garcia 2020, Delgado 2019, Andersen 2018, Kennedy
  2024, Collings 2023, Brazil 2021, Ekstrom 2007 (not cited in the copy). Full texts: Neto 2019
  (PMC6544005, through PMC), Lehecka 2017 (PMC5534144) and Sorensen 2021 (PMC8168984).
- No study of a Smith, machine, single-leg (bench) or B-stance hip thrust's muscle activity except
  Sorensen 2021 (hamstrings only) and Collings 2023 (modelled forces) for the single-leg; Europe PMC
  searches for "hip thrust machine", "Smith machine hip thrust", "B-stance" and "kickstand" found
  nothing.
- Not used: Bells of Steel's machine guide (a strap machine, not this lever and roller); the
  MasterClass, Muscle and Strength and Mirafit pages (403).

## Claims and sources

Shared copy (all four or several):

| Claim | Source |
|---|---|
| The hips rise until the torso is level; a rep ends when the hips are straight; the gluteus maximus is the main hip extensor in the lift; the glutes are shortest at the end of the range | ExRx ("Raise bar upward by extending hips until straight"; target gluteus maximus); Brazil 2021 (extensor demand far greater at the hip than the knee or pelvis-trunk); the glutes shortest at full hip extension is anatomy; the model (trunk level at the top) |
| Knees, hips and shoulders line up at the top; pause for a moment | Fitness Volt (Vukas: "from the knees to the head, should be in a straight line at the top"; "Pause at the isometric contraction point at the top"); Physitrack ("a straight line from your shoulders to hip and knees"); the models (169.5-175 degrees side-on; holds of 0.7-0.8 s, so "a moment", not "a second") |
| Drive through the whole foot | REP Fitness ("your entire foot drilled into the floor throughout your rep", against rising onto the toes); the models' feet stay flat all clip |
| Ribs down, trunk braced and rigid; arching the lower back or tipping the pelvis forward adds height through the spine | ExRx ("Movement should occur through hip with torso rigid. Avoid chest arching upward and anterior pelvic tilt, both producing spinal hyperextension"); the model's spine keeps one shape |
| Shins vertical at the top; knees bent close to a right angle there, so the hamstrings, shortened at the knee, help less and the glutes do more | Neto 2019 (full text: "knee flexion (about 90 degree angle) during the hip-raising phase induces a hamstrings insufficiency ... requiring a greater effort of the gluteus maximus", citing Kwon and Lee 2013); StrengthLog and REP Fitness (knees ~90 degrees at the top); the models (shins within 4 degrees of vertical; knees 97-105, hence "close to a right angle", never "90 degrees") |
| Feet set further out hand more of the work to the hamstrings | Neto 2019 on Collazo Garcia 2020 (feet forward: more hamstring, less quadriceps activity, gluteus maximus unchanged, 51 vs 55% MVIC in Neto's Table 2; 7 trainers at 40% 1RM); REP Fitness (feet too far away and the hamstrings take more of the work). Neto's other line, that a greater distance between the feet raised gluteus maximus activity, is about the feet's spacing and turn-out (Collazo's rotation variant), not their distance from the hips (reviewer's reading; the draft called it inconsistent). The copy claims nothing about the glutes here |
| Feet about shoulder-width, toes turned out a little | ExRx and StrengthLog (about shoulder width); Fitness Volt (Vukas: toes outward slightly); the models (ankles 40 cm apart, shoulder joints 40 cm; toes out 8 degrees) |
| The upper back pivots on the bench edge; sliding moves the hips away from the feet and changes the knee angle | ExRx ("Find comfortable contact hinge position on bench and avoid sliding"); the model (the edge moves 1.9 cm along the back); the knee-angle consequence is geometry (feet planted) |
| The edge under the lower tips of the shoulder blades | The models (edge.py, above). REP Fitness ("Align the bottom of your shoulders on the edge of the bench") is close but ambiguous, so it is not cited for this |
| A flat bench about 40 cm high | ExRx (16-18 in, 40-46 cm); the model's pad top 41 cm |
| Lower until the seat is just off the floor (Smith) / just touches the seat (machine) | The models (glutes 8 cm off the floor; the machine's seat touched for ~0.8 s) |

Smith Machine Hip Thrust:

| Claim | Source |
|---|---|
| The padded bar runs straight up and down its track and sits across the hip crease at the top; a Smith bar cannot roll along your body, so where it meets you is set by where you sit | REP Fitness ("a barbell fixed to a vertical path"; it "moves along this set track"); the model (bar z fixed; the pad on the shorts over the hip crease from ~1 s to the top); the consequence is geometry |
| Correct: the pad starts on the tops of the thighs just below the hip crease and settles onto the crease as you rise (review) | REP Fitness ("Have the bar line up over your upper thighs, just below your hips"); the model (at the bottom the pad rests on the rectus femoris, its axis 6.4 cm toward the feet from the hip joints, the shorts 2.4 cm or more from it; from ~1 s on the shorts at the crease) |
| Over the hip crease the bar loads hip extension directly; the thick pad spreads the pressure on the pelvis; the hands only steady it | ExRx (bar across the upper hip flexors and lower abdomen; thick padding if the pelvis and hip flexors do not pad it); StrengthLog (something between the bar and the pelvis "to soften the pressure"; hands on the bar "to stabilize it"); REP Fitness (hands on the bar "for guidance"); "loads hip extension directly" is mechanical reasoning, as on the library's barbell lift |
| Mistake: a bench set too close to the bar puts the pad on the stomach at the top | Geometry of a fixed vertical track (the bench edge sits 42 cm from the track in the model); ExRx places the bar across the hips and lower abdomen, not higher |
| Setup: bench lengthwise behind the bar; pad round the bar; safety stops just below the bar's lowest point; slide under the bar until the pad rests on the tops of the thighs just below the hip crease; turn it off its hooks | REP Fitness (a bench parallel to the bar; a pad round the bar; adjustable safety stops "keep the bar from dropping too low"; "simply twist the bar back" to unlock); the model (stops 7 cm under the carriages' lowest point, hooks on the carriages) |

Machine Hip Thrust:

| Claim | Source |
|---|---|
| The roller sits across the hip crease and rides up with the hips; the lever carries it on a fixed arc | The model (roller on the crease all rep, lever pivot behind the back pad) |
| The lever carries the roller on a fixed arc, so it stays where you set it; across the hip crease it loads hip extension directly, as the bar does in a barbell hip thrust | The model (the roller 2.5-4.5 cm from the hip joints all rep); mechanical reasoning by analogy with the barbell lift's bar placement (ExRx). No machine-specific source found |
| Feet flat on the footplate; the plate tilts toward the toes | The model (the foot mat slopes ~12.5 degrees; the draft said ~15) |
| Setup: load the horn, sit on the low seat, back pad under the shoulder blades, roller onto the hip crease, handles, feet | The model |

Single-Leg Hip Thrust:

| Claim | Source |
|---|---|
| One leg's glutes lift the hips with no help from the other | StrengthLog One-Legged Hip Thrust ("using your glute muscle in the leg that touches the floor"; the other leg lifted); the model (right foot never touches the floor) |
| With one foot down the pelvis tends to sag on the free side; the working side's gluteus medius steadies it, so the lift stays square over the working leg | ExRx Gluteus Medius ("Steadies pelvis so it does not sag when opposite side is not supported with leg"); Sorensen 2021 (in the unilateral hip thrust "stability around the hip and core is essential for ensuring a stable (i.e. non-tilting) pelvis"); Physitrack ("keeping your pelvis level"); Lehecka 2017 (gluteus medius 55-58% MVIC in single-leg bridges). "Square over the working leg" is the model's (pelvis level and square all clip) |
| A still free leg keeps momentum out of the lift, so the planted leg does the work | Coaching logic, as on the library's Single-Leg Glute Bridge; the model (the free leg's angles never change). Not "all the work": Lehecka 2017 notes that arms resting beside the body can press down and help, and the model's arms rest on the bench |
| In a study of single-leg bridges, holding the free thigh upright with the knee bent instead of the leg straight cut the free leg's front-thigh activity by about two-thirds, with glute activity about the same | Lehecka 2017 Table 3: free-leg rectus femoris 20.49 -> 7.00 %MVIC (position A -> C), gluteus maximus 51.0 -> 47.2 and gluteus medius 57.8 -> 55.1 (not significant). Their bridges had the shoulders on the floor; the model's free thigh is near upright (vertical at the top, 29 degrees off toward the feet at the bottom) |
| The free knee stays bent and drawn up toward the chest | The model (knee 75, thigh 75 degrees from the trunk line, all clip) |
| The working foot under the knee, toes ahead, shin vertical at the top | StrengthLog (~90 degrees at the working knee at the top); the model (shin within 3 degrees of vertical, toes out 3 degrees) |
| Setup: arms spread along the bench; the left leg works in the demo, switch sides | The model |

B-Stance Hip Thrust:

| Claim | Source |
|---|---|
| The front foot rests on its heel with the toes up; it is a helper that steadies you and assists a little (review: was steadies rather than drives); the back leg does most of the work; keep most of the push in the left foot | Fitness Volt (Dale: "Move one leg forward and pull your toes up, so you're resting on your heel. This is your kickstand or helper leg and not the main focus of the exercise"; "Drive your supporting foot into the floor"; under Benefits, B stance thrusts emphasize one leg "but you can still use your other leg for assistance"); the model (right heel down, toes 7-8 cm up) |
| The further ahead the kickstand sits, the harder the lift becomes | Fitness Volt (Dale: "The further you move away from your supporting leg, the harder the exercise becomes") |
| Right heel about level with the ball of the left foot | The model (right heel z 0.67; left foot 0.47-0.77) |
| Pressing through the whole back foot keeps the load on the working leg; its shin vertical, the knee close to a right angle at the top, so the hamstrings help less and the glutes do more (review: was the glutes rather than the hamstrings finish) | Fitness Volt (Dale: "Drive your supporting foot into the floor", through the heel); REP Fitness (the entire foot on the floor); Neto 2019 as above; the model (left foot flat, knee 100, shin within 4 degrees) |
| With most of the load on one leg, the load can shift and tip the pelvis toward the lighter side; keeping the hips level and square keeps the lift on the working leg's glutes | Fitness Volt (Dale, under Drawbacks: "putting more weight on one leg will cause the load to shift, destabilizing your knees, hips, or core"); "toward the lighter side" is mechanical reasoning (ExRx Gluteus Medius as above). The model's pelvis stays level and square |
| The dumbbell across the hip crease, held at both ends so it stays put; it can roll toward the stomach as the hips rise | Fitness Volt (Vukas: "Place the dumbbell horizontally in your hip crease and hold onto each end to ensure it stays in place"); ExRx (keep the bar from rolling back near the top with the hands); the model |
| Comparison: pushing through a flat front foot shares the load between the legs | The kickstand logic above (Fitness Volt); no measurement |
| Single-leg comparison: a sagging free side tips the pelvis off level, the drop the gluteus medius is there to stop | ExRx Gluteus Medius as above (the FormComparisonCopy is not shown in the app at present) |

## Activation

All four follow the paint (bright = primary, dim = secondary) and the library's glute-group
convention: the three glutes are lit as one group, so the Gluteus Maximus row stands for them and
the gluteus medius and minimus are named with the stabilisers (as on the Dumbbell Hip Thrust).

- Gluteus Maximus PRIMARY 0.90 (Smith, machine, B-stance): the target in every source (ExRx,
  StrengthLog); Contreras 2015 (69.5 / 86.8 %MVIC upper / lower, well above the squat), Andersen
  2018 (the highest of the three lifts at 1RM), Delgado 2019 (more than the squat at 1RM); the
  library's barbell and dumbbell value. Single-leg 0.88, a judgement call: no load but one leg (the
  library's Single-Leg Glute Bridge 0.86, the loaded thrusts 0.90); Collings 2023 put the
  single-leg hip thrust with a 12RM load in the top tier of eight hip exercises for modelled
  gluteus maximus force (the bodyweight version was not ranked there).
- Quadriceps PRIMARY 0.55 (painted bright), as the Dumbbell Hip Thrust: a judgement call between
  Contreras 2015 (vastus lateralis 99.5 vs 110 %MVIC in the squat, no difference, at 10RM), Delgado
  2019 (below the squat at 1RM), Neto 2019 (35-100% MVIC across studies) and Kennedy 2024 (more in
  the hip thrust than the glute bridge); ExRx lists them as synergists, StrengthLog secondary. For
  the single-leg, Lehecka 2017 measured the working leg's rectus femoris at only 5-8% MVIC in
  single-leg bridges (shoulders down, a shorter arc); the paint sets the rank and the value stays
  the family's.
- Hip Flexors PRIMARY 0.40 (single-leg only; the rig's Sartorius, painted bright on both sides; a
  legend-only name): they hold the free knee up. 0.40 is the lowest moderate value, as the seated
  calf raises' painted gastrocnemius: EMG would rank them lower (Lehecka 2017: the free leg's rectus
  femoris 7% MVIC with the thigh upright and the knee bent, 20% with the leg straight). The copy
  never says they work hard. The one-line legend fits the three primaries (checked on the
  simulator: GLUTEUS MAXIMUS · QUADRICEPS · HIP FLEXORS PRIMARY).
- Hamstrings SECONDARY 0.45 (painted dim): Contreras 2015 (biceps femoris 40.8% MVIC); ExRx dynamic
  stabilisers; the library's value. Single-leg 0.50: Sorensen 2021 measured more hamstring activity
  in the single-leg barbell thrust than in the two-leg one with the knees at 90 degrees (67 vs 50%
  of max EMG).
- Erector Spinae SECONDARY 0.45 (painted dim): the library's value and the paint's, not the EMG's
  (Neto 2019 ~85% MVIC, from Andersen 2018's 93/83%), as on the Dumbbell Hip Thrust; ExRx a
  stabiliser. No copy claims anything about the lower back's share.
- Stabilisers: gluteus medius and gluteus minimus (painted bright with the group; Neto 2019 ~45%
  MVIC in the hip thrust; on the single-leg they hold the pelvis level, ExRx Gluteus Medius,
  Lehecka 2017 55-58% MVIC), adductors (StrengthLog secondary), core; obliques on the single-leg in
  place of core (the pelvis held square on one leg).

## Labels

All four are framed three-quarter from the feet on the lifter's left (yaw -0.7): the body lies in a
band across the middle (v ~0.35-0.67), feet on the left, head on the right. Labels sit above the
body and below the feet. Checked with `pills.py` against the eight probed samples (no leader
crosses another or runs through a pill, no pill over a tracked dot) and on two lab rounds.

The mistake view lifts the model 0.091 of the view and shrinks it to 0.935 (`roomBelow` 0.26)
while the labels stay put, so plates and levers that clear a pill in the trainer view can reach it
there: the first round showed the Smith's hips pill (0.24) over its left plate and the machine's
left pills over its plate. Round 2 moved them:

- Smith: ribs 0.12 left, hips 0.18 left ("Hips up, torso level", shorter so the ribs leader clears
  its end by ~25 pt), bar 0.16 right (in the mistake view its right end touches the right plate's
  edge by ~6 pt), feet and bench 0.74 (closer to the body than the barbell's 0.80). The plates sweep
  v 0.29-0.52 (left) and 0.23-0.53 (right) over the rep; the hips pill clears the left plate's top
  in both views. The bar cue tracks the left hand (on the bar at the pad's end), as on the barbell.
- Machine: hips 0.12 left (above the lever's plate, which reaches v 0.24, 0.17 in the mistake
  view), ribs 0.16 right, roller 0.21 right ("Roller on hip crease", short so the ribs leader passes
  ~12 pt left of it), feet and pad 0.74. The roller cue tracks the left hand, on its handle at the
  roller's end.
- Single-leg: free 0.16 left (above the free leg's swing, which reaches v ~0.31 at the top), ribs
  0.16 right; below the foot, foot 0.72 left ("Shin vertical at top"), level 0.80 left ("Pelvis
  level, no hip drop", long so its leader starts right of the foot pill), hips 0.80 right. The two
  hip cues track the two hip joints (the working left for lockout, the free right for the level
  pelvis), 0.07 apart, so their leaders come from below without crossing.
- B-stance: hips (left hip joint) and dumbbell (left hand) on the top row, level (right hip joint)
  0.27 left, kickstand (right ankle) and foot (left ankle) 0.74.

## Ghosts

Every ghost is a fault of the top, stilled at the top ("top": the pelvis highest, 1.75-2.0 s).
Sizes from `ghost.py` at the shot moment on each rig; limb lengths and the hip line kept, and no knee
or elbow folds the wrong way (both after the review, below; the library's `hipsShortOfLockout` and
`thrustArched` stretch the trunk's joint-to-joint lines 1-1.3 cm, as on the barbell thrusts).
No fault turns the model (as on the barbell and dumbbell thrusts): the hips and spine move up and
down the screen, and moves along the trunk's line show at about two-thirds of their length.

- `thrustLockout` (pelvis-to-left-ankle 0.9 -> 1.04 torso lengths) reads 0-0.06 at the bottom and 1
  at the top on the Smith, single-leg and B-stance rigs. The machine's raised feet give 0.92 at the
  bottom (16% of a fault there), so its faults read `r1012thrustMachineLockout` (0.93 -> 1.06).
- Smith (the barbell pieces; hips short as `r1012thrustHipsShort`): hips ~15 cm (~37 pt) below the
  line, knees 100 -> ~82, elbows 155 -> ~131; lumbar spine ~7 cm (~17 pt) up; feet ~13 cm (~24 pt)
  out, knees ~124; back ~12 cm up the bench, knees ~121; the bar ~17 cm toward the head onto the
  stomach with the hands (elbows 155 -> ~90). A Smith bar cannot roll along the body, so the bar
  ghost is drawn for a bench set too close to the track (the copy's mistake).
- Machine: the same four with its lockout (hips ~35 pt, knees 105 -> ~85, elbows 100 -> ~87, as
  `r1012thrustHipsShort`; lumbar ~17 pt; feet up the plate, knees ~130; back up the pad, knees
  ~127). The roller cue has no ghost (where a pad sits):
  the app shows the red ring on its dot.
- Single-leg: hips short ~15 cm (~30 pt) with the held right leg carried down and the arms left on
  the bench (`r1012thrustOneLegShort`); the free side's hip sagging ~11 cm (~22 pt), the pelvis
  rolling 36 degrees about the left hip and the free leg carried down with it
  (`r1012thrustRightHipSags`, exaggerated to read on the small figure); the free leg swung
  30 degrees away from the chest, the foot ~38 cm (~72 pt) toward the feet
  (`r1012thrustFreeLegSwing`; a first version kicked the leg up straight, which in the mistake view
  ran into its own pill); the working foot ~13 cm (~20 pt) out, knee ~121; `thrustArched`.
- B-stance: `r1012thrustHipsShort` (both feet planted, knees 100 -> ~82 and 137 -> ~115, elbows
  149 -> ~115); the front foot flattened, its toes turned 24 degrees down onto the floor (~22 pt;
  `r1012thrustKickstandFlat`); the working foot ~13 cm out, knee ~124; the kickstand side's hip
  sagging ~11 cm with its foot planted (the pelvis rolling 36 degrees about the left hip), the right
  knee re-seating 137 -> ~121; the dumbbell rolled
  ~17 cm onto the stomach with the hands (elbows 149 -> ~93), as on the Dumbbell Hip Thrust.

## Lab rounds

- Round 1 (`family_1012.sh shoot thrust "0,1.5,3"`): compiled first time; trainer stills fine on all
  four (legend fits the single-leg's three primaries). Mistake views: the Smith's hips pill (0.24)
  and the machine's two left pills (0.16, 0.21) sat over the left plate, because the mistake view
  lifts and shrinks the model; the single-leg's first free-leg ghost (the knee kicked straight up,
  ~80 pt) ran up into its own pill; the two pelvis-level ghosts (~8 cm) read faintly.
- Round 2: Smith left pills to 0.12 / 0.18 (shorter hips label), machine pills re-stacked (hips
  0.12 left; ribs 0.16 and roller 0.21 right, shorter roller label), bottom pills of the Smith,
  machine and B-stance up from 0.80 to 0.74 (shorter leaders); free-leg ghost changed to a 30 degree
  swing away from the chest; level ghosts 0.14 -> 0.18 torso lengths. All five ghosts per lift (four
  on the machine) checked on the shots; pills clear of plates and ghosts in both views (the Smith
  bar pill's right end still touches the right plate's rim in the mistake view, as on the barbell
  lift).
- After round 2 only copy strings changed (no layout or ghost change); a final `check` compiled
  them.

## Self-review (author, 2026-10-12)

- Sources: every source in the tables was opened this session (URLs and snapshot dates above); the
  quotes are copied from the fetched text. Claims the sources do not make are marked as the
  model's, geometry or mechanical reasoning. Dropped or softened while drafting: "the hips drop and
  turn" (only the sag is sourced: ExRx Gluteus Medius), "the planted side does all the work" (arms
  on the bench can help; Lehecka 2017's discussion), "the handles only keep you steady" (no source
  for this machine), "no gain in glute activity" with the feet further out (Neto 2019 contradicts
  itself), "knees at 90 degrees" (the models stop at 97-105).
- Model fidelity: copy, labels and ghosts re-read against the measurements above: the left leg works
  in the single-leg and B-stance demos and the copy says so; holds are "a moment" (0.7-0.8 s); the
  Smith seat stays off the floor and the machine's touches the seat; the free knee stays drawn up;
  the kickstand rests on its heel, toes up; the bench edge under the lower tips of the shoulder
  blades.

## Uncertain and open points

- No muscle-activity study exists for a Smith, machine or B-stance hip thrust, and none for a
  bodyweight single-leg hip thrust on a bench beyond Sorensen 2021 (hamstrings) and Collings 2023
  (modelled forces, loaded): every fraction but the paint's ranks is a judgement call anchored on
  the library's Dumbbell and Barbell Hip Thrusts.
- The machine's copy rests on the model and on barbell-thrust sources; no source describing this
  lever-and-roller machine was found.
- The B-stance's level-pelvis "why" is mechanical reasoning; Fitness Volt's warning about shifting
  weight is about stability in general, not a measured tilt.
- REP Fitness and Fitness Volt are commercial coaching pages; what they describe matches the
  models.
- The erector spinae's 0.45 understates the EMG (Neto 2019 ~85% MVIC), as on the Dumbbell Hip
  Thrust (the library's value, kept for the family).
- In the Smith's mistake view the bar pill's right end touches the right plate's rim (~6 pt), as on
  the library's barbell lift: any right-side pill there would.
- Owner (model choices the copy follows): the two-foot thrusts' knees sit 3-6 cm inside the ankles
  each side (no knee cue, as on the barbell and dumbbell models); the machine carries one plate on a
  single horn at the lifter's right and lets the seat rest on its pad ~0.8 s between reps; the
  B-stance's dumbbell sits centred rather than over the working hip; the re-exported Dumbbell Hip
  Thrust now has this family's motion, so `notes_500_hip.md` and `spec_500_hip.py` quote its old
  numbers (pelvis 0.205 -> 0.462 m, knees 69 -> 90).

## Review (independent reviewer, 2026-10-12)

Scripts and evidence in `$LAB/r1012/thrust_review/` (`src/`: the sources as fetched; `rig.py`,
`m1.py`, `contact.py`, `feet.py`, `edge.py`, `roller.py`: my own rig reader and measurements,
UsdSkel joints with the skeleton's world transform and skinned meshes; `gcheck*.py`: every ghost
solved with the author's port of `FaultGhost.solve`, which I re-read line by line against
FaultGhost.swift, then each drawn segment's length, each knee's and elbow's bend plane and the
moved points in cm and viewport points; `mock.py`: label layouts drawn over the stills).

Sources, re-opened 2026-10-12 (Europe PMC REST records for the ten studies; full texts of Neto
2019 and Lehecka 2017 from PMC's article pages, Sorensen 2021 from Europe PMC's XML; ExRx through
Wayback id_ snapshots; the commercial pages live). Claim -> verdict:
- ExRx Barbell Hip Thrust (snapshot 2026-04-03): set-up, execution, 16-18 in bench (it adds a torso
  angled ~45 degrees, which the model's 44 matches), bar across the upper hip flexors and lower
  abdomen, thick padding, contact hinge and no sliding, keep the bar from rolling back near the top,
  torso rigid, no chest arching or anterior pelvic tilt; target gluteus maximus, synergists
  quadriceps, dynamic stabilisers hamstrings, stabilisers erector spinae (antagonist stabilisers
  rectus abdominis and obliques, which back the core / obliques stabiliser entries) -> supported.
  ExRx Gluteus Medius (2026-06-24): the quoted sentence is there -> supported. ExRx's hip list has no
  Smith, lever, single-leg or B-stance thrust -> confirmed.
- StrengthLog Hip Thrust and One-Legged Hip Thrust -> supported as quoted (back on a sturdy bench,
  feet about shoulder-width, knees ~90 degrees at the top, hands on the bar to stabilise it,
  padding to soften the pressure; glutes primary, adductors and quads secondary; one-legged: the
  glute of the leg on the floor, ~90 degrees at the working knee).
- REP Fitness (Borchert; the page now says updated 3 Aug 2026, added to the citation) -> supported
  as quoted; it also says to line the bar up over your upper thighs, just below your hips, which is
  where the model's pad sits at the bottom (used below).
- Fitness Volt, Dale (published 19 Oct 2022, updated 11 Aug 2024) -> the quotes are there, but the
  copy's front foot that steadies rather than drives and lets that foot only steady you went past
  it: Dale calls it a kickstand or helper leg and says you can still use your other leg for
  assistance -> softened (below). Vukas (17 Oct 2023, updated 11 Aug 2024) -> supported; it also
  says to lower until your butt is just above the ground (the Smith's lower-until line).
- Physitrack -> supported; its FAQ also names the hip flexors among the muscles the single-leg hip
  thrust mainly works, an extra prop for the painted Hip Flexors primary row (added to the spec).
- Contreras 2015 (13 trained women, estimated 10RM; 69.5 vs 29.4, 86.8 vs 45.4, 40.8 vs 14.9,
  vastus lateralis 99.5 vs 110 n.s.), Delgado 2019 (8 men; more gluteus maximus than the squat at
  1RM, more vastus lateralis in the squat), Andersen 2018 (13 trained men at 1RM; the authors'
  conclusion that the hip thrust gave the highest gluteus maximus activation, significant against
  the hex bar deadlift; erector spinae no different), Kennedy 2024 (10 men; more vastus lateralis,
  less gluteus maximus than the glute bridge), Collazo Garcia 2020 (7 trainers, 40% 1RM; all
  muscles but the gluteus medius differed), Brazil 2021 (19 trained men, 70% 1RM), Collings 2023 (14
  female footballers; loaded single-leg hip thrust in gluteus maximus tier 1) -> all as cited.
- Neto 2019 (full text) -> supported: knee flexion ~90 degrees and hamstring insufficiency (citing
  Kwon and Lee 2013, printed Know and Lee); feet forward raise biceps femoris and semitendinosus,
  lower the three quadriceps, gluteus maximus unchanged (Table 2: 51 vs 55% MVIC); vastus
  lateralis 35-100%, gluteus medius 45%, erector spinae ~85% MVIC; Andersen's 93/83%. The draft's
  note that Neto contradicts itself was wrong: its line on a greater distance between the feet is
  about spacing and turn-out (the rotation variant), not feet further out -> notes corrected.
- Lehecka 2017 (full text) -> supported: 28 tested, 26 analysed, arms folded; Table 3 position A
  51.02 / 57.81 / free-leg rectus femoris 20.49, position C (free knee relaxed in flexion, femur
  vertical) 47.16 / 55.05 / 7.00, so about two-thirds less and glutes about the same; the working
  leg's rectus femoris 5.1-5.8% at 90 degrees (8.4 at 135).
- Sorensen 2021 (full text) -> supported: 23 recruited, 21 analysed; single-leg thrust at half the
  two-leg 8RM load, 90-degree end position only; 67.4 vs 50.4% hamstring activity; the
  non-tilting pelvis line is in the discussion.

Copy changed (all in `spec_1012_thrust.py`):
- Smith bar: the correct line (pad lands on the crease before the first rep) and setup step 3
  (slide under until the pad sits on the crease) did not match the model: at the bottom the pad
  rests on the rectus femoris (axis 6.4 cm toward the feet from the hip joints, the shorts 2.4 cm
  or more from it) and reaches the shorts over the crease only from ~1 s. Now the pad starts on the
  tops of the thighs just below the hip crease and settles onto it as you rise (REP's set-up), the
  intro says it sits across the crease at the top, and the why says a Smith bar cannot roll along
  your body (it does turn on its axis: that is how it comes off its hooks).
- B-stance kickstand: why and correct softened to Dale's helper leg (steadies you and assists a
  little; keep most of the push in your left foot).
- B-stance working foot: the glutes rather than the hamstrings finish the hip extension overstated
  Neto (greater effort of the gluteus maximus; the hamstrings still work, 40.8% MVIC in Contreras,
  50% in Sorensen's 90-degree thrust) -> the hamstrings help less and the glutes do more.
- B-stance hips: your knees, hips and shoulders line up -> your left knee: the front knee sits
  lower (right knee-hip-shoulder 165.7 degrees with the hips 5.9 cm above that line, the left
  173.5 and 2.7 cm); the mistake line says the back knee.
- Kept, checked: every other cue, comparison and setup line (each traced to the sources or the
  model as the tables above say), labels <= 28 characters, five cues each, no double quotes or
  backslashes, levels matching fractions.

Model fidelity (re-measured; joints and skinned meshes, all frames): pelvis 0.201 -> 0.519 m
(machine 0.291 -> 0.609); knees 74.6 -> 100.2 (machine 76.0 -> 104.7, single-leg 72.8 -> 97.5,
B-stance left 74.6 -> 100.2, right 108.5 -> 136.7); trunk 44.4 -> -0.6 degrees; spine 171.9 and
174.1 all clip; head 176.3 -> 159.7; top lines 173.5 / 169.5 / 175.0 / 173.5 with the hips 2.1-4.3
cm above; shins 3.0-4.3 degrees off vertical at the top; toe-out 8 (single-leg 2.8, kickstand 7.3);
pelvis level to the millimetre; elbows Smith 97 -> 155, machine 58 -> 100, B-stance 71 -> 149,
single-leg 95 -> 81; phases as stated (the still top, under 0.5 mm per frame, is 1.75-2.12 s on the
Smith and machine and 1.50-2.04 s on the other two, so a moment, not a second, holds). Bench edge
10.6-12.5 cm up the spine from the chest joint, the teres major's lowest point at 12.2, the
rhomboid major's 12.0, the infraspinatus's 13.9 (under the lower tips of the shoulder blades); the
shoulders swing 12.6 cm. Seat 7.2 cm off the floor at the bottom (single-leg 7.3, B-stance 6.7);
the machine's 1 mm above its seat pad. Smith: bar z fixed, rise 22.9 cm, pad 50 x 13 cm, hands 62 cm
apart and 9.2 cm from its axis, stops 7.1 cm under the carriages. Machine: roller 60 x 13 cm, on
the thighs and shorts at the crease at the bottom and on the shorts from ~1 s, rises 26 cm; one
HTP_R_Plate20kg on the right horn; the foot mat slopes ~12.5 degrees (the draft said ~15:
corrected). Single-leg: free knee 75.2 and trunk-thigh 75.4 degrees all clip, thigh 14.9 degrees
past vertical toward the head at the top, 29.9 toward the feet at the bottom, sole 22 -> 86 cm.
B-stance: right heel at z 0.671 on the floor, the left foot's ball at 0.674, toe end 8 cm up;
dumbbell 34 cm, heads 16 cm, rises 21.5 cm, its heads on the thighs at the bottom and the hips at
the top.

Activation -> kept. Bright glutes and quadriceps are the primaries, the dim hamstrings and erector
spinae the secondaries, the single-leg's bright Sartorius the Hip Flexors primary; the rows equal
the library's Dumbbell Hip Thrust (the older Barbell Hip Thrust row set, quadriceps secondary 0.40
plus abdominals, differs; the brief asks for the dumbbell's); every fraction is marked a judgement
call where no EMG exists.

Ghosts (each solved at its shot moment):
- Smith hips: `hipsShortOfLockout` carries the hands down 14.8 cm and re-seats the near-straight
  elbows (155 degrees) from where they stand, which put them across the new shoulder-to-hand line:
  the bend plane turned 159 degrees, the elbows folding the wrong way. The B-stance's turned 81, the
  machine's 11-23. New piece `r1012thrustHipsShort` (the elbows ride half as far down before they
  re-seat): Smith 155 -> 131 (2 degrees), B-stance 149 -> 115 (11), machine 100 -> 87 (4-8); the
  rest unchanged (hips ~15 cm, 32-37 pt).
- Pelvis-level ghosts (single-leg, B-stance): the straight 10.7 cm drop of the right hip stretched
  the drawn hip line 18.2 -> 21.1 cm. `r1012thrustRightHipSags` now rolls the pelvis 36 degrees
  about the left hip (the same 10.7 cm drop, the hip 3.5 cm in, the width kept), the free leg
  carried down by the hip's own move, the kickstand knee re-seating 137 -> 121; 22-24 pt as before.
- Machine pad: the slide carried the hands and the handle line with the trunk, as a bar on the
  hips would be; the hands hold the lever's handles, so `r1012thrustSlidUpPad` now leaves them
  there and opens the elbows behind the sliding shoulders (100 -> ~143, bend planes 9-11 degrees),
  without the handle line.
- Comments corrected: the Smith bar ghost's elbows go 155 -> ~90 (not ~131), its bench ghost's knees
  to ~121 (not ~124).
- Checked and kept: the other ghosts (lengths kept, knees bending the right way, sizes as stated);
  the moments (all top: Smith 2.02 s, the others 1.77 s); the library's `hipsShortOfLockout` and
  `thrustArched` stretch the trunk's joint lines 1-1.3 cm, as on the barbell and dumbbell thrusts.

Labels -> kept. Pills clear of the lifter at every still; the leaders to the hips cross the pad,
the roller or the dumbbell from the top rows (as on the library's barbell and dumbbell thrusts) and
the single-leg's two hip leaders cross the near thigh from below, as they must to reach the hip
joints. The Smith's bar pill still touches the right plate's rim in the mistake view: trailing
pills end at the right margin whatever the label's length, the row above clashes with the eye
button, so it stays. The Smith's back-on-the-bench dot (scapula_L) sits on the rack's left upright,
which hides the back's contact with the bench from this camera; the far scapula_R would put the dot
on the moving pad, so it stays (owner, below).

Lab: review round 1 (`family_1012.sh shoot thrust "0,1.5,3"`): BUILD SUCCEEDED, all 12 trainer
stills and 19 ghosts shot; the new hips and level ghosts read as before (hips below the line with
the elbows bending the right way; the far hip and leg lower), the B-stance's new mistake line shows
on its sheet. Round 2 (`family_1012.sh shoot thrust "1.5" "Machine Hip Thrust"`, after the pad
ghost change): BUILD SUCCEEDED; the back-pad ghost now shows the trunk and hips slid toward the head
with the knees open and the arms reaching back to the hands on the handles, without the moving
handle line; the machine's other three ghosts as in round 1.

Open points for the owner:
- The library's Dumbbell and Barbell Hip Thrusts use `hipsShortOfLockout` too: on their rigs the
  hips ghost swings the elbows' bend plane 74 and 50 degrees (`gcheck5.py`); the half-way elbow
  move in `r1012thrustHipsShort` would fix them if the shared piece took it.
- Single-Leg Hip Thrust: the gluteus medius stays a stabiliser by the glute-group convention,
  though Lehecka 2017 puts it as high as the gluteus maximus in single-leg bridges (55-58 vs 47-51%
  MVIC) and the library's Single-Leg Glute Bridge lists it as a secondary 0.50 row; a row would
  need the legend to fit a sixth name.
- Smith framing: the rack's left upright stands between the camera and the back on the bench at
  every still, so the bench cue's dot lands on the post.
- Every activation fraction remains a judgement call (no EMG for a Smith, lever, B-stance or
  bodyweight bench single-leg thrust), as the author says.
