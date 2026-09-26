# Legs 300-350: lunges (2026-09-26)

Forward Lunge (323), Barbell Lunge (324), Smith Machine Reverse Lunge (325) and
Curtsy Lunge (01, from the 30-leg set). The copy is in `spec_300_350_lunge.py`
and the ghosts are in `../fault-review/faults_300_350_lunge.swift.txt`. The
source list is at the end.

## Shared points

- **All four clips alternate legs.** Each rep takes 4 s and there are two
  reps in 8 s. The bottoms are at ~1.9 s and ~5.9 s (the curtsy at ~1.6 s
  and ~5.6 s, held until 2.0 s and 6.0 s).
- **Every ghost follows whichever leg is in front.** Each ghost names the
  `front` and `back` leg, so it appears in both reps.
- **Label dots follow the front and back legs too.** Cues about one leg name
  `patella_front`, `foot_back`, `toe_front` and so on. The app resolves these
  every frame, as it does for the Walking Lunge (`Exercise3DView.trackedPoint`),
  so in rep 2 the knee dot stays on the front knee and the heel dot on the
  planted foot.
  - `probe.py` writes these `_front`/`_back` points into `joints.json` for
    the lifts in its `ALTERNATING` set, choosing the leading leg per sample
    the way `BodyFrame.leadingSide` does, so `gen.py` and `validate()` place
    them like any other joint. The leading foot per probe second (0-7 s) is
    Forward and Barbell `LLLLLRRR`, Smith `LRRRRLLL`, Curtsy `RLLLLRRR`. The
    0 s and 4 s samples stand with the feet together, so the choice there
    does not matter.
  - The simulator screenshots (start and both bottoms, dots live) confirm
    that every dot sits on the part its label names in both reps.
- **How the layouts were checked.** They were scored at all 8 probed moments
  and drawn over the start and both bottom screenshots, for:
  - a pill covering a body segment, a dot, the head or a plate;
  - a leader running through the head or crossing a limb;
  - two leaders crossing each other.
  - **Forward Lunge, changed in the second pass.** In the screenshots the
    step leader ran from the bottom-right pill into the depth pill, and in
    rep 1 the front-toe dot sat half under that pill's top edge. The step
    pill now sits bottom left with its dot on the front ankle (the toe, at
    v 0.78, would sit on the pill), and the depth pill bottom right under
    the back knee. Both leaders are short whenever a foot is out. They cross
    only at the feet in the standing moments (0 s and 4 s), where the feet
    are together.
  - The Barbell, Smith and Curtsy layouts were clean in the screenshots and
    are unchanged. The Curtsy cross and heel leaders cross only in the 4 s
    standing moment.
- **The mistake view moves the model.** With the mistake sheet open the
  model sits ~0.09 higher on screen (and ~0.01 left) than in the trainer,
  measured on the Curtsy and Smith ghost screenshots, and only the cue's own
  label shows. Two ghosts had their moved joints under that label: the
  Curtsy cross (the swung foot under "Cross behind") and the Smith drive
  (the straightened back knee at the edge of "Front leg drives"). Both are
  now turned a little (see their tables).
- **The forward and barbell lunges travel 0.61 m and back.** The lifter
  stands at the edge of the frame for ~0.6 s at each end of every rep, so
  most pills sit where they clear both the standing body and the bottom
  position.
- **The glows are only drawn when an exercise has no live model**
  (`Exercise3DView` passes `glows` only when `SampleData.model == nil`).
  Here they are placed on the working thigh, averaged over both reps with
  the standing moments left out, as data for any flat use.
- **Knee travel is described in a balanced way.**
  - Forward knee travel is called normal (Fry 2003; Hofmann 2017).
  - The faults are the knee caving (Boyd & Milton 2017; Powers 2010) and
    the heel lifting. The caving is put down to the hip or the foot
    ("often shows the hip or foot losing control"): Powers 2010 argues for
    the hip, Boyd & Milton file the same error under over-pronation of the
    foot.
  - The knee-load claims are Escamilla 2008's short-step versus long-step
    patellofemoral result, balanced by Hofmann 2017: a fully upright front
    shin moves patellofemoral stress to the back knee, so the step copy
    asks for ~90° at both knees rather than the longest step.
- **The back foot's toes in the ghosts.** The ghost draws a foot's `.tip` a
  fixed 0.38 torso lengths (~0.22 m) along the foot bone. With the back heel
  up, that point runs ~5 cm under the floor (7 cm below the toe joint at
  the bottom, probed). Ghosts that draw the back leg of the forward,
  barbell and Smith lunges therefore stop it at the ankle (`lungeBackLeg`).
  The Curtsy's back foot tip lands at floor level, so its ghosts keep it.

## Forward Lunge

**What the model shows.**
- **Stance.** Bodyweight, hands on the hips, feet hip-width.
- **Step.** Rep 1 the left foot steps forward, rep 2 the right. The front
  ankle lands 0.98 m ahead of the start, 0.84 m ahead of the back ankle. It
  lands heel first, then the whole foot.
- **Bottom.**
  - Both knees ~89°.
  - Back kneecap 0.11 m above the floor, back heel up.
  - Front shin ~9° off vertical, front kneecap ~9 cm behind the toes.
  - Front heel flat.
- **Trunk and hips.** Trunk lean 2° at the top and 8° at the bottom; pelvis
  level and square; no knee caving. The pelvis drops 0.38 m (0.91 to
  0.53 m).
- **Return.** Pushes back to feet together.
- **Compared with the older Lunge model** (stationary, left leg forward,
  ankles 0.71 m apart, knees 80°/72°, front shin 18°, trunk vertical): this
  model steps out and back, alternates legs, uses a longer stance with a more
  upright shin, and stops at ~90°.

**Claims and the sources behind them.**
- Step length (a short step raises the front-knee load near the bottom):
  Escamilla 2008, where patellofemoral force and stress were greater with a
  short step between 70° and 90° of knee flexion. The "longer than a walking
  stride" wording comes from Boyd & Milton 2017, and StrengthLog Lunges asks
  for a step long enough for both knees to reach ~90°. "Land heel first"
  follows the model and ExRx Barbell Lunge ("land on heel, then forefoot").
  - The trade-off ("a fully upright shin shifts some of that load to the
    back knee, so aim for 90° at both knees, not the longest step"):
    Hofmann 2017. With a vertical shank the trail knee's peak
    patellofemoral stress exceeded the lead knee's, and the authors say
    restricting the lead shank's forward travel may cut lead-knee stress at
    the trail knee's expense.
  - The mistake now reads "the front knee has to travel well past the
    toes", not "drives far forward over the toes", which matches the ghost
    and keeps knee travel neutral.
- Torso upright (folding forward shifts the load to the hips and lower back):
  Farrokhi 2008 (a trunk-forward lunge raised hip extensor impulse and
  gluteus maximus and biceps femoris EMG), Bezerra 2021 (an inclined trunk
  doubled lower-back erector spinae activity) and Boyd & Milton 2017
  (forward torso lean listed as an error). The mistake says "as you lower",
  since the ghost grows with the front knee's bend and peaks at the bottom.
- Knee alignment (some forward travel is normal; caving is the fault):
  - Knee caving is listed as an error, with the torque stress it adds, in
    Boyd & Milton 2017, under "Over-Pronation of the Foot/Knee Caves
    Inward".
  - Hip control of knee mechanics: Powers 2010. So the copy says the caving
    "often shows the hip or foot losing control of the leg", not the hip
    alone.
  - Forward travel as a trade-off rather than a fault: Fry 2003 (restricting
    it moves load to the hip and increases trunk lean) and Hofmann 2017
    (trunk and shank position shift patellofemoral stress between the
    knees).
- Depth (both knees ~90°, back knee just above the floor): Boyd & Milton
  2017, ACE Forward Lunge, and Farrokhi 2008's protocol (trail knee 2-3 cm
  short of the floor).
- Push back (the hip extensors supplied the largest share of the effort,
  though the knee bends most): Riemann 2012. In the unloaded anterior lunge
  (step out, lower, push back to standing), the hip supplied 62%, the ankle
  21% and the knee 17% of the total net joint extensor moment impulse. The
  authors call it knee-dominant in motion but hip-extensor dominant in
  kinetics. The copy says "largest share of the effort", not "most of the
  work": the study measured moment impulse, and the activation panel below
  still ranks the quadriceps first by EMG. Boyd & Milton 2017 also gives
  "push through the front heel".

**Activation.**

| Muscle | Rank | Level (fraction) |
|---|---|---|
| Quadriceps | Primary | High (0.82) |
| Gluteus maximus | Secondary | Moderate (0.46) |
| Gluteus medius | Secondary | Moderate (0.40) |
| Hamstrings | Secondary | Low (0.24) |

- **Order.** Follows Muyor 2020 (vasti highest, then gluteus medius ≈
  maximus, then rectus femoris, biceps femoris lowest).
- **Size.** Follows Farrokhi 2008's bodyweight forward lunge (upright: VL
  45.6%, gluteus maximus 18.5%, biceps femoris 11.9% MVIC) and DiStefano
  2009 (forward lunge gluteus medius 42% and maximus 44% MVIC).
- **Why gluteus maximus is moderate rather than low.** The kinetic data
  (Riemann 2012: hip-extensor dominant) keep it there despite the modest
  %MVIC.
- Stabilisers: adductors, calves, core.

**Comparison.** SHORT STEP (Escamilla 2008). It matches the step cue.

**Fault moments.** Every ghost reads best at the bottom, 1.92 s (rep 1) and
5.92 s (rep 2).

| Cue | Moment | Ghost |
|---|---|---|
| step | bottom | Front foot 21 cm nearer (`lungeStepShort(0.35)`): shin 39° forward instead of 9°, kneecap ~10 cm past the toes instead of 9 cm behind |
| torso | bottom | Trunk +22° from the hips |
| knee | bottom | Turned near face-on, total yaw -0.2 |
| depth | bottom | Hips held 18 cm up and 6 cm ahead (`lungeShallow(0.3, ahead: 0.1)`), about half the 0.38 m descent; the back leg drawn to the ankle |
| drive | bottom | Front heel up 24° |

The step ghost was 0.28 (17 cm) in the first pass. In the screenshot its
knee stood only just over the toes (simulated: 6 cm past), which did not
show the knee travelling well past them; 0.35 shows it clearly.

## Barbell Lunge

**What the model shows.**
- **Legs.** The Forward Lunge's legs, with the same timeline.
- **Bar.** A 2.2 m bar sits high on the upper traps. The hands are 0.78 m
  apart against shoulder joints 0.39 m apart, so each wrist is ~0.2 m
  outside its shoulder joint (about a hand's width outside the shoulder),
  ~12 cm behind and 3 cm below it. The Smith model's grip is the same.
- **Trunk.** Lean 2° at the top, 8° at the bottom.
- **Framing.** Yaw -0.6 (three-quarter front), because side-on the near
  plate hid the head.

**Claims and the sources behind them.**
- Bar on the upper back, grip wider than the shoulders, feet hip-width,
  alternate legs: ACE Forward Lunge (barbell version, grip slightly wider
  than the shoulders), ExRx Barbell Lunge and Muyor 2020 (bar on the upper
  trapezius, grip wider than the shoulders). The setup step says "about a
  hand's width outside your shoulders", which is where the model's hands
  are (the first draft's "just outside" understated it).
- Torso mistake "as you lower": the ghost (`chestDropped`) grows with the
  front knee's bend, so it shows most at the bottom, not at landing.
- Step length: as the Forward Lunge (Escamilla 2008).
- Torso tall under the bar: Boyd & Milton 2017 (forward torso lean) and
  ExRx ("keep torso upright"). Chest-drop mechanics are stated plainly, with
  no numbers.
- Feet hip-width, not in line: Boyd & Milton 2017 (feet about hip-width)
  and StrengthLog Lunges ("railroad tracks, not a tightrope").
  - **Why it matters:** Marchetti 2018 (high-bar barbell split-stance lunge
    at 10RM). Feet at 50% of hip-width swayed 19.4 cm side to side under the
    front foot against 14.8 cm at hip-width, about a quarter more (+24%).
    Vastus lateralis, biceps femoris and both glutes did not differ. The copy
    says "sway about a quarter more", "harder to balance".
  - Marchetti's lunge was a stationary split stance with the back knee
    straight and the front knee to 45°, not a stepping lunge. The copy only
    calls it "a barbell lunge study".
  - The copy no longer says a narrow base makes the knee harder to keep in
    line, because no study was found for that. Shin 2026 (a bodyweight
    forward lunge held at the bottom) found a narrow stance raised gluteus
    medius and lowered vasti activity. That is a change in emphasis, not a
    knee-alignment result, so it stays in these notes.
- Knee: as the Forward Lunge.
- Push back: Riemann 2012, worded as for the Forward Lunge, and ACE ("push
  the front foot into the floor").

**Activation.**

| Muscle | Rank | Level (fraction) |
|---|---|---|
| Quadriceps | Primary | High (0.84) |
| Gluteus maximus | Secondary | Moderate (0.50) |
| Gluteus medius | Secondary | Moderate (0.48) |
| Hamstrings | Secondary | Low (0.28) |

- **Direct match.** Muyor 2020 studied this exact exercise: barbell on the
  upper traps, step forward to 90° at the knee and return, 60% of 5RM.
  - Vastus lateralis and medialis were significantly higher than the rest.
  - Gluteus medius and maximus were similar to each other.
  - Rectus femoris came next and biceps femoris was lowest.
  - **Units.** Table 3 prints the amplitudes in mV (concentric: VL 208,
    VM 207, RF 148, GMed 106, GMax 106, BF 89; every muscle higher
    concentric than eccentric). The methods and Fig 3 normalise to MVIC and
    the text gives the same order (vasti, then the glutes, then rectus
    femoris). The first draft's "%MVIC" label on these numbers was wrong;
    only the ranks are used.
- **Gluteus medius near maximus.** Following Muyor.
- **ExRx lists the gluteus maximus as the target.** That is a
  classification, not EMG. The row order follows Muyor's EMG.
- **Adductors.** Listed as a stabiliser: StrengthLog names them and ExRx
  lists the adductor magnus as a synergist, but no lunge EMG was found.

**Comparison.** FEET IN LINE, matching the track cue. Its notes claim more
side-to-side sway and a harder balance (Marchetti 2018), not a knee effect.

**Fault moments.** Every ghost reads best at the bottom, 1.92 s and 5.92 s.

| Cue | Moment | Ghost |
|---|---|---|
| step | bottom | Front foot 21 cm nearer (`lungeStepShort(0.35)`), knee ~10 cm past the toes, turned to total yaw -1.05 |
| torso | bottom | chestDropped with the bar, total yaw -1.05 |
| track | bottom | Front foot 24 cm in, face-on (`lungeStepInLine(0.4)`), landing ~2 cm off the back foot's line in both reps |
| knee | bottom | Face-on |
| drive | bottom | Heel up, total yaw -1.05 |

The sagittal faults stop at -1.05 rather than side-on so the near plate stays
off the head.

## Smith Machine Reverse Lunge

**What the model shows.**
- **Setup.** A reverse lunge inside the Smith machine. The feet are
  hip-width. The ankles are ~20 cm in front of the bar line (heels ~15 cm,
  toes ~35 cm). The bar sits high on the upper back (as in the barbell
  lunge), 0.11 m behind the start pelvis.
- **Steps.** Rep 1 the left foot steps back and the right leg works; rep 2
  the other way. The back ankle lands 0.78 m behind the front one, on the
  ball of the foot.
- **Trunk.** The hips travel 0.22 m back and the trunk tips ~20° by 1 s,
  22° at the bottom.
- **Bottom.**
  - Front knee 83°, front hip 80°, front shin ~17° off vertical.
  - Front kneecap 3 cm behind the toes, front heel flat.
  - Back knee 88°, 0.11 m above the floor.
- **Bar.** It moves straight up and down (under 2 cm front to back).
  - At the bottom the shaft is ~11 cm ahead of the pelvis (the hands
    ~7 cm).
  - It is ~20 cm behind the front ankle and ~58 cm ahead of the back one:
    between the feet, but a quarter of the stance behind the front foot,
    not over the middle of the stance. Probed with pxr on the bar sleeve.

**Claims and the sources behind them.**
- **Feet a little ahead of the bar.** The bar only moves vertically, so foot
  placement decides where the body ends up. This is mechanical reasoning
  from the fixed path, and the copy describes the bar where the model has
  it: just behind the front foot.
  - ExRx Smith Rear Lunge supports it: "Place feet under bar or slightly
    forward". A long lunge with the feet slightly forward emphasises the
    gluteus maximus; a short one with the feet under the bar, the quadriceps.
  - **Divergent reference:** StrengthLog's Smith Machine Lunges starts with
    "both feet directly under the bar". So the why says feet under the bar
    "suits some lifters but tips others onto their toes".
  - The mistake names a visible fault that follows from the setup: the
    front heel peeling up or the chest folding over the knee. It is not the
    forward knee travel itself, which the Knee cue calls normal.
  - The setup step gives the model's distance: heels about half a foot's
    length (~13-15 cm) in front of the bar.
- **Step straight back, far enough for ~90° knees:** Boyd & Milton 2017
  (stride longer than walking, both knees ~90°) and StrengthLog (step back,
  back knee nearly touching).
- **Hinge ~20° with a flat back.** The model leans 22°, so the cue stays, but
  it is framed as this version's style, with balanced evidence.
  - Farrokhi 2008 (bodyweight forward lunge): a forward trunk raised hip
    extensor impulse (3.9 to 5.2 N·m·s/kg), with small absolute EMG rises
    (gluteus maximus 18.5 to 22.3%, biceps femoris 11.9 to 17.9% MVIC). The
    authors say the rise may not be meaningful for a strong lifter.
  - Bezerra 2021 (lunges with dumbbells at 30% of body weight): the inclined
    trunk doubled lower-back erector spinae activity (20 to 40% MVIC) and did
    not change gluteus maximus or biceps femoris.
  - **Divergent references:** StrengthLog ("keep your back upright") and ExRx
    ("keep torso upright"). So the copy adds "a more upright torso is also
    fine".
- **Both legs work; drive mainly through the front foot:** Hoogenboom 2024
  (bodyweight reverse lunge, peak %MVIC, descriptive, Table 4).
  - Front (stationary) leg: gluteus medius 49, gluteus maximus 37, rectus
    femoris 36, biceps femoris 17.
  - Stepping leg: rectus femoris 106, biceps femoris 37, gluteus maximus 35,
    gluteus medius 34. Its rectus femoris peak came in the rising phase in
    95% of trials.
  - So the copy says only the planted leg's gluteus medius "was the more
    active" (49 vs 34; the gluteus maximus gap, 37 vs 35, is too small to
    claim), and that the stepping leg's front thigh "worked hard as the
    lifter rose". The why opens "Both legs work" and frames the cue as
    keeping the front leg doing its share. The second pass rewrote it
    because the first revision still implied the front leg does the
    lifting on its own.

**Activation.**

| Muscle | Rank | Level (fraction) |
|---|---|---|
| Quadriceps | Primary | High (0.78) |
| Gluteus maximus | Secondary | Moderate (0.50) |
| Gluteus medius | Secondary | Moderate (0.42) |
| Hamstrings | Secondary | Low (0.30) |

- **Quadriceps first.** Farrokhi 2008's lean condition still had VL (50.9%)
  well above gluteus maximus (22.3%) and biceps femoris (17.9% MVIC). The
  library entry is also QUADRICEPS.
- **Gluteus maximus secondary, a little above the upright lunges** (0.50 vs
  0.46) because of the 22° lean and 80° front-hip angle. Farrokhi 2008 found
  a modest rise; Riemann 2012 found hip-extensor-dominant kinetics.
  - It is not primary. Bezerra 2021 found no gluteus maximus change with
    trunk lean under load, and no study puts it near the quadriceps.
  - ExRx classifies the Smith Rear Lunge's target as the gluteus maximus
    "with feet slightly forward". That is a classification, not EMG, so it
    only supports leaning the row up a little.
- **Gluteus medius is a row, not a stabiliser.** It was the most active
  front-leg muscle measured in a reverse lunge (Hoogenboom 2024: 49% peak;
  the vasti were not recorded). It is set a little below the barbell
  lunge's 0.48 on the assumption that the rails take over some side-to-side
  balancing. No Smith lunge EMG exists, so this is labelled an assumption.
- **Rows a little under the barbell lunge's.** Schwanbeck 2009 (a squat
  study) found higher EMG with free weights than on the Smith machine.
- **Hamstrings low (0.30).** Farrokhi's lean raised biceps femoris a little
  (to 17.9%). Bezerra found no change, and Hoogenboom's front-leg biceps
  femoris was 17%.
- **Stabilisers:** adductors, erector spinae (Bezerra: the lean raises
  them), core.

**Comparison.** FRONT FOOT UNDER THE BAR, matching the stance cue. The
correct note puts the bar where the model has it (between the feet, just
behind the front foot). The mistake note names the heel lifting or the chest
folding.

**Fault moments.** Every ghost reads best at the bottom, 1.92 s (rep 1, right
leg in front) and 5.92 s (rep 2).

| Cue | Moment | Ghost |
|---|---|---|
| stance | bottom | Front foot 21 cm back onto the bar line and its heel up 20° (`lungeStepShort(0.35, heelUp: 20)`): ankle 7 cm up, knee ~10 cm past the toes |
| step | bottom | Back foot 15 cm nearer, the back knee re-seated near the floor; the back leg drawn to the ankle (`lungeBackLeg`) |
| lean | bottom | `backRounded`; the bar stays on its rails, so only the spine moves |
| knee | bottom | Turned face-on, +1.0 |
| drive | bottom | Back knee straightened (`lungeBackLegPushing`), turned +0.3 to total yaw -0.7 |

The sagittal faults are otherwise left unturned: yaw -1.0 already shows the
side, and turning further toward side-on would bring the rails and plates
across the lifter. The drive ghost turns the other way, toward the front,
by 0.3. At -1.0 its straightened back knee landed at the left edge of the
"Front leg drives" pill in the mistake view (screenshot), and the shin ran
under the pill's corner. At -0.7 the knee sits ~0.06 left of the pill and
the shin passes ~0.02 below it (simulated, rep 1; rep 2 is clearer). The
knee still rises ~0.11 of the screen height.

## Curtsy Lunge

**What the model shows.**
- **Setup.** Bodyweight, hands clasped in front of the chest, elbows out.
  The feet are a little wider than hip-width (ankles 0.32 m apart) and the
  knees soft (157°).
- **Cross.** Rep 1 the right foot steps 0.46 m back and across to ~8 cm past
  the left foot's line, landing high on the ball of the foot, and the left
  leg works. Rep 2 mirrors it.
- **Bottom.**
  - Front knee 70°, front hip 108°.
  - Front shin ~47° forward (the knee well past the toes), front heel flat.
  - Back knee 81°, trunk lean ~10°.
- **Hips.** The pelvis stays square and level and shifts 0.10 m back and
  0.10 m over the front foot. No knee caving.
- **Brief.** The rig has no toe joints. The corrected motion brief (facing
  0) agrees with the values above: the stepping foot 0.46 m back and
  0.24 m across, lean +10°, front shin +47°. The first draft's note that
  the brief's axes were flipped referred to an earlier version of the brief
  and has been removed; no copy or ghost relied on the flipped numbers
  (the ghosts were checked on the rig, and the leading-leg probe puts the
  left foot 0.46 m ahead in rep 1).

**Claims and the sources behind them.**
- **The step.** Step back and diagonally behind the front leg: StrengthLog
  Curtsy Lunges. The "just past the line of the front foot" wording
  describes the model.
  - Why a far cross is a fault: it "twists the pelvis toward the back leg
    and makes the rep harder to balance and the front knee harder to hold
    in line". The first draft said it "narrows the base", which is wrong
    geometrically: past the in-line point a bigger cross widens the feet's
    side-to-side spread again, on the other side (the ghost puts the foot
    ~26 cm past the front foot's line). The balance point is coaching
    logic, in line with Marchetti 2018 (an in-line stance swayed more), not
    a curtsy result.
- **Hips square.** This is coaching logic: the standing hip holds the
  pelvis level and facing forward while the other leg crosses. No study
  compares square with rotated curtsy lunges, so the why says only that
  this "asks more of the muscles on the side of that hip", and the
  comparison's correct note says the standing hip "has to hold the pelvis
  steady". The first draft stated a load on the side and back of the hip
  as fact.
- **Knee in line; forward travel is normal.** Powers 2010 covers hip
  control of the knee, and Boyd & Milton 2017 covers knee caving (filed
  with over-pronation of the foot), so the copy says "the hip or foot".
  - "Both feet on the same side of the body" is from the model: both feet
    end up left of the start midline in rep 1.
- **Chest up with a slight lean.** Boyd & Milton 2017 (forward torso lean
  as an error) and Bezerra 2021 (a forward trunk raises lower-back
  activity). The model leans ~10°.
- **Front heel down.** StrengthLog ("push through your front heel"). The
  why describes the model (front foot flat, back foot "rests high on its
  toes"); it no longer says the back leg only balances, in line with the
  Smith drive cue.

**Activation.**

| Muscle | Rank | Level (fraction) |
|---|---|---|
| Quadriceps | Primary | High (0.78) |
| Gluteus maximus | Secondary | Moderate (0.48) |
| Gluteus medius | Secondary | Moderate (0.48) |
| Adductor magnus | Secondary | Low (0.30) |

**Uncertain.** No EMG or biomechanics study of the curtsy lunge was found
(searched: curtsy, cross-behind and crossover lunge). The rows are ranked
from the closest studied lunges.
- **Quadriceps first.** Every lunge measured has the vasti highest (Muyor
  2020; Farrokhi 2008), and this model's front knee bends to 70° with the
  shin 47° forward, a knee-dominant position.
- **Both glutes a little above the forward lunge** (gluteus maximus 0.48 vs
  0.46, medius 0.48 vs 0.40).
  - DiStefano 2009's transverse lunge, the closest studied lunge off the
    straight-ahead line, drew slightly more gluteal activity than its
    forward lunge: gluteus maximus 49 vs 44% and medius 48 vs 42% MVIC
    (Boren 2011, Table 1). The abstract's "lunges 48%" gluteus medius
    figure is this transverse lunge.
  - A narrow or crossed base asks more of the side of the hip: Shin 2026
    (a narrow stance raised gluteus medius in a held forward lunge) and
    Marchetti 2018 (a narrow base increased side-to-side sway).
  - Simenz 2012's crossover step-up (the greatest concentric gluteus medius
    of four step-up variations) is a further, looser analogy.
  - The first draft set gluteus maximus at 0.52 on the grounds that the
    front hip flexes further here. It does not: the front hip (trunk-thigh
    angle) is 108° at the bottom against the Forward Lunge's 93°, i.e. less
    flexed, because the shin tips 47° forward. So the row now follows only
    the transverse-lunge ratio (49/44 on the forward lunge's 0.46).
- **Adductors listed low.** StrengthLog names the adductors for the curtsy
  lunge, but no EMG exists.
- **Library change recommended.** The entry's primaryMuscle "GLUTEUS
  MEDIUS" is not supported as the most active muscle; "QUADRICEPS" is.
  Equipment BODYWEIGHT and difficulty beginner are fine.
- **Stabilisers:** gluteus minimus, calves, core.

**Comparison.** HIPS TURNING OPEN, matching the hips cue.

**Fault moments.** Every ghost reads best at the bottom, 1.58-2.0 s (rep 1,
left leg in front) and 5.58-6.0 s (rep 2).

| Cue | Moment | Ghost |
|---|---|---|
| hips | bottom | Pelvis and trunk turned 30° about the front hip toward the crossing leg (`curtsyHipsOpened(30)`), turned to total yaw -1.3: back hip 9 cm and that shoulder 14 cm back |
| cross | bottom | Back foot 18 cm further across (`curtsyCrossedFar(0.3)`), turned to total yaw +0.3, just past face-on |
| knee | bottom | Face-on |
| torso | bottom | +20°, total yaw -1.3 |
| drive | bottom | Front heel up, total yaw -1.3 |

The hips ghost is a turn about the vertical, so its joints swing backward.
At the framing's three-quarter view (-0.5) that swing points mostly into the
screen: at 22° the back hip moved 12 px in rep 1 and 7 px in rep 2, the back
shoulder 19 and 9 px. At total yaw -1.3 and 30° they move 26 and 22 px (hip)
and 40 and 35 px (shoulder), and the back elbow 65 and 76 px. That is the
same side view as the torso and drive ghosts.

The cross ghost was face-on (total 0) in the first pass. In the mistake
view the model sits ~0.09 higher, and the rep-1 screenshot showed the
swung ankle (~u 0.76, v 0.64) under the "Cross behind" pill (u 0.73-0.97,
v 0.62-0.66). At +0.3 the move is the same size (~0.11 of the screen width,
cos 0.3 = 0.96 of it across the screen) but the swung ankle lands at
~u 0.66, left of the pill, tucked behind the front shin; in rep 2 it swings
out to the left, away from every pill.

## Ghost pieces added

| Piece | What it draws |
|---|---|
| `lungeStepShort(by, heelUp:)` | Front foot planted `by` torso lengths nearer the back one, the knee re-seated. `heelUp` degrees also rock the foot onto its toes. Used for the short step (0.35) and the Smith front foot under the bar (0.35, heel up 20°). |
| `lungeStepInLine(by)` | Front foot moved in toward the midline (tightrope). |
| `lungeBackLeg` | The back leg's hip, knee and ankle, without the foot's `.tip`, which runs under the floor while the back heel is up. Used by the three pieces below it and the Smith step ghost. |
| `lungeShallow(rise, ahead:)` | `shallow` with the back leg drawn by `lungeBackLeg`. Forward Lunge depth. |
| `lungeBackLegPushing(strength:)` | `rearLegPushing("back")` with the back leg drawn by `lungeBackLeg`. Smith drive. |
| `curtsyHipsOpened(degrees)` | Pelvis and trunk turned about the front hip toward the crossing leg, the back knee re-seated. |
| `curtsyCrossedFar(by)` | Back foot moved further across. |

**Checks.**
- The Swift was typechecked with `xcrun swiftc -typecheck` against a
  scratch copy of today's `FaultPoses.swift` with this file's pieces and
  table entries swapped in for the integrated ones (exit 0; a deliberate
  error in the same copy was caught).
- The directions and sizes were simulated on the rigs in both reps, with a
  Python port of `FaultGhost.solve` and the leading-side switch:
  - Curtsy hips: the back hip goes back 9 cm and that shoulder 14 cm.
  - Curtsy cross: the crossing foot moves a further 18 cm across.
  - Knee caving: the knees move 10 cm inward.
  - Barbell track: the in-line front foot moves 24 cm toward the midline.
  - Forward and Barbell step: the front foot moves 21 cm nearer, the shin
    tips 39° forward and the kneecap ends ~10 cm past the toes.
  - Forward depth: the pelvis is held 18 cm up, and both knees re-seat.
  - Smith step: the back ankle moves 15 cm forward and the back knee
    re-seats near the floor.
  - Smith drive: the back knee straightens; at total yaw -0.7 it rises
    ~0.11 of the screen height and clears the drive label.
  - Smith stance: the front foot moves 21 cm back and the ankle rises
    7 cm, and no joint of that ghost goes below the floor. With the back
    foot's toes left out, the back-leg ghosts no longer poke through the
    floor either (the first-pass screenshots of the Forward depth, Smith
    step and Smith drive ghosts showed the back foot's line running under
    the shoe).
- The ghost screenshots were checked cue by cue. Each shows its mistake
  from its view. The short step now shows the knee well past the toes, and
  the cross and Smith drive ghosts no longer sit under their own labels.

## Sources

**Studies**
- **Muyor JM, Martín-Fuentes I, Rodríguez-Ridao D, Antequera-Vique JA.**
  2020, *PLoS One* 15(4):e0230841, doi 10.1371/journal.pone.0230841. Tables
  and method were read in the full text (Tables 2-4 are in mV; Figs 2-3
  are normalised to MVIC).
- **Farrokhi S, Pollard CD, Souza RB, Chen YJ, Reischl S, Powers CM.**
  2008, *J Orthop Sports Phys Ther* 38(7):403-409, doi
  10.2519/jospt.2008.2634. The full-text table and discussion were read.
- **Bezerra ES, Diefenthaeler F, Nunes JP, Sakugawa RL, Heberle I, Moura
  BM, Moro ARP, Marcolin G, Paoli A.** 2021, *Int J Exerc Sci*
  14(1):202-210, doi 10.70252/IGJM9937, PMC8136561. The abstract and PMC
  results were read: gluteus maximus 45 vs 50% (p = 0.36) and biceps
  femoris 23 vs 24% between straight and inclined trunks; erector spinae 20
  vs 40% MVIC.
- **Riemann BL, Lapinski S, Smith L, Davies G.** 2012, *J Athl Train*
  47(4):372-378, doi 10.4085/1062-6050-47.4.16. The PMC full text was read:
  relative contributions to the total net joint extensor moment impulse,
  hip 62%, knee 17%, ankle 21% (0% load).
- **Escamilla RF et al.** 2008, *J Orthop Sports Phys Ther*
  38(11):681-690, doi 10.2519/jospt.2008.2694. Abstract.
- **Hofmann CL, Holyoak DT, Juris PM.** 2017, *J Orthop Sports Phys Ther*
  47(1):31-40, doi 10.2519/jospt.2017.6336. Abstract (PubMed) read: the
  trail knee took more total stress in every variation, a vertical shank
  gave the trail knee the higher peak, and restricting the lead shank's
  forward travel "may reduce patellofemoral joint stress at the expense of
  increased stress in the trail limb".
- **Fry AC, Smith JC, Schilling BK.** 2003, *J Strength Cond Res*
  17(4):629-633. Abstract.
- **Hoogenboom BJ, Ferguson M, Krauss Z, Tran S.** 2024, *Appl Sci*
  14(24):11480, doi 10.3390/app142411480. Full text read (Table 4 and
  section 3.2, including the phase of each peak).
- **Marchetti PH, Guiselini MA, da Silva JJ, Tucker R, Behm DG, Brown LE.**
  2018, *J Hum Kinet* 62:15-22, doi 10.1515/hukin-2017-0174, PMC6006536.
  Full text read: 50% versus 100% hip-width feet, side-to-side sway 19.4 vs
  14.8 cm, no activation differences.
- **Shin HJ, Kim HM, Cho HY, Kim SH.** 2026, *J Clin Med* 15(14):5567, doi
  10.3390/jcm15145567, PMC13413211. Abstract read: a narrow stance raised
  gluteus medius and lowered vasti activity in the holding phase of a
  bodyweight forward lunge. Notes only (Barbell track, Curtsy rows).
- **DiStefano LJ, Blackburn JT, Marshall SW, Padua DA.** 2009, *J Orthop
  Sports Phys Ther* 39(7):532-540, doi 10.2519/jospt.2009.2796. Abstract
  (PubMed) read.
  - The lunge values come from Boren K et al. 2011, *Int J Sports Phys
    Ther* 6(3):206-223, PMC3201064, Table 1 ("Findings of Distefano et
    al."), read on PMC in the second pass: forward lunge gluteus maximus
    44% and medius 42% MVIC, transverse lunge 49% and 48%, sideways lunge
    41% and 39%. The DiStefano full text could not be opened, so the
    transverse lunge's exact step is not described here. The values are
    used only in these notes, to size rows, not in the copy.
- **Simenz CJ, Garceau LR, Lutsch BN, Suchomel TJ, Ebben WP.** 2012,
  *J Strength Cond Res* 26(12):3398-3405, doi 10.1519/JSC.0b013e3182472fad.
  Abstract (PubMed) read.
- **Schwanbeck S, Chilibeck PD, Binsted G.** 2009, *J Strength Cond Res*
  23(9):2588-2591, doi 10.1519/JSC.0b013e3181b1b181. Abstract.
- **Powers CM.** 2010, *J Orthop Sports Phys Ther* 40(2):42-51, doi
  10.2519/jospt.2010.3337. Abstract.

**Practitioner references**
- **Boyd J, Milton K.** 2017, "The Undervalued Lunge", NSCA *Personal
  Training Quarterly* 4(4):44-48. Full text read.
- **ACE Exercise Library, Forward Lunge** (barbell). Page read.
- **StrengthLog: Lunges, Smith Machine Lunges, Curtsy Lunges.** Pages read.
  The Smith page's "both feet directly under the bar" and "keep your back
  upright" are recorded above as divergent from this model. The curtsy page
  cites no studies.
- **ExRx.net Smith Rear Lunge and Barbell Lunge.** The live pages block
  scripted access. The Wayback copies (2023-12-27 and 2024-01-05) were
  read: preparation, execution, comments ("keep torso upright"; long lunge
  with feet slightly forward emphasises the gluteus maximus, short lunge
  with feet under the bar the quadriceps; "land on heel, then forefoot")
  and the muscle lists (target gluteus maximus; synergists quadriceps,
  adductor magnus, soleus; stabilisers include the gluteus medius).
