# Trainer content for the 401-500 folder, third round (2026-10-05), family:
# thruster. Four barbell, dumbbell and kettlebell lifts from the builder's
# 471-474 exports: 471 Barbell Thruster (Legs/BarbellThruster), 472 Dumbbell
# Thruster (Legs/DumbbellThruster), 473 Kettlebell Thruster
# (Legs/KettlebellThruster) and 474 Clean and Press (Shoulder/CleanAndPress).
# Same format as spec.py on top of common_1_50.py; spec_500.py imports this
# module and gen.py reads SPEC / SETUP. notes_500_thruster.md maps the copy's
# claims to the sources below and records the model facts.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (SCRATCH/thruster/dump.py: every joint, the equipment's boxes and the
# skinned shoes every frame; an.py, measure snippets in the notes), the
# briefs (SCRATCH/briefs, briefs_legs), tiers.json, joints.json and the
# trainer stills at 0/1/2/3/5 s. The app's frame: Y up, the lifter faces +z,
# their left is +x. Every clip is 7.96 s at 24 fps; one body (shoulder joints
# 39 cm apart, hip joints 18 cm, neck to pelvis ~0.59 m standing). The
# spine's shape never changes in any of the four (its two bends read 8° and
# 5-6° every frame), so the back stays flat throughout.
# - The three thrusters share one leg motion, two identical 4 s reps: standing
#   with the weight racked 0-0.33 s; squatting 0.33-1.50 s (~1.2 s); a short
#   stop at the bottom (1.50-1.67 s); standing up fast, 1.67-2.17 s; the
#   weight leaves the shoulders as the knees pass ~130° (2.0 s) and the arms
#   finish the press at 2.5 s (barbell) or 2.58 s (dumbbells, kettlebells);
#   held locked out to ~3.3 s; back to the shoulders by 3.83 s with a small
#   knee bend to soak it up (knees 145-148°); standing again at 4.0 s.
#   Feet about shoulder-width (ankle joints 39 cm apart, as the shoulder
#   joints), toes out ~20°, heels down the whole clip (the skinned heel
#   stays 0.2 cm off the floor). Bottom: knees 62°, hips 87-89°, trunk 24°
#   forward, the knees 25-30 cm ahead of the ankles, the hip joints above
#   the knee joints, so the thighs stop 15° (barbell) or 20° (dumbbells,
#   kettlebells) above level, short of parallel. The barbell model's knees
#   track out over the toes (knee joints 63 cm apart over ankles 39 cm apart,
#   each knee 26° out from straight ahead, the feet 20°); the dumbbell and
#   kettlebell models' knees cave in at the bottom (knee joints 23 cm apart,
#   each pointing 15° inward while the feet point 20° out), a fault, so
#   those two have no knee cue (reported as an open point). Lockout: elbows
#   174-175°, the hands over the ankles (within 3 cm), the trunk 2° back,
#   the head under the hands.
# - Barbell Thruster: overhand grip, wrist joints 58 cm apart (~10 cm outside
#   each shoulder joint). The bar is held in the palms at the front of the
#   shoulders, just above the collarbones (its centre 1 cm below and 8 cm in
#   front of the neck joint; its surface ~3 cm in front of the front
#   deltoids and clavicular pectorals, ~5 cm from the neck), the forearms
#   vertical under it, the elbows pointing down and ~8 cm ahead of the bar
#   (upper arms 53° below level standing, 67° at the bottom).
#   Paint: anterior deltoid, glutes (maximus, medius, minimus), quadriceps
#   bright; adductors, lateral deltoid, trapezius, rhomboid major, triceps dim.
# - Dumbbell Thruster: a dumbbell in each hand at the shoulders, palms facing
#   in, the handles running front to back, the back end of each resting on
#   top of the shoulder (its underside ~5 cm above the shoulder joint), elbows
#   bent ~31-35° and pointing down and forward. Locked out with the palms
#   still facing in. Paint as the barbell's.
# - Kettlebell Thruster: a kettlebell in each hand in the rack: the hands
#   together in front of the chin (wrist joints 19 cm apart), palms facing in,
#   wrists straight, the elbows tucked against the ribs (inside the shoulder
#   line, upper arms 66° below level standing, 82° at the bottom), each bell
#   resting on the outside of the forearm. The press turns the palms forward;
#   locked out, each bell hangs behind the wrist (its centre ~11 cm behind the
#   hand). Paint as the barbell's.
# - Clean and Press: one rep. Barbell on the floor (plates 45 cm), feet
#   hip-width (ankle joints 22 cm apart), toes out ~15°, grip ~61 cm. Start
#   (0-0.42 s): bar over the middle of the foot (1.8 cm ahead of the shoe's
#   midpoint), shoulders straight over the bar, hips above the knees (hips
#   48°, knees 98°), trunk 62° from vertical, arms long (elbows ~156°). First
#   pull 0.42-1.08 s: the bar rises past the knees within 1-2 cm of the shins
#   and thighs, the knees open to ~119° and the trunk rises to 36° (the
#   back angle steepens; the shoulders rise ~26 cm while the hips rise ~11).
#   The knees re-bend to 109° as the bar passes them (1.08-1.25 s). Second
#   pull 1.25-1.67 s: hips open to 167°, knees to 150-154°, the heels rise
#   8 cm onto the toes, the trunk leans 3° back, the bar ~1 cm off the
#   thighs up to the hips; the elbows stay long (156-162°) until 1.6 s, then
#   bend high and out (upper arms near level at 1.92 s) to pull under. Catch 1.9-2.25 s: the feet land
#   8 cm wider (ankle joints 30 cm apart), the bar on the front of the
#   shoulders, lowest at 2.25 s with knees 99°, hips 127°, trunk 12° forward,
#   21 cm below standing: a power clean, above a parallel squat. Standing by
#   2.67 s, then the feet step back in one at a time (left 2.9-3.1 s, right
#   3.3-3.5 s). Rack 3.5-3.7 s: elbows down and ~5 cm in front of the
#   shoulders, wrists bent back under the bar. Press 3.67-4.75 s with the
#   knees straight (175°) all the way: a strict press. Lockout 4.75-5.0 s,
#   elbows 173°, the bar over the ankles and the middle of the head. Back to
#   the shoulders by 5.6 s (knees soften to 161°), down to the thighs with
#   the elbows high and out (6.0-7.1 s), and hinged back to the floor by
#   7.8 s. Paint: anterior deltoid, glutes, quadriceps, trapezius (upper,
#   middle, lower), rhomboid major bright; biceps, hamstrings, forearm
#   flexors and extensors, brachioradialis, lateral deltoid, erector spinae,
#   gastrocnemius, soleus, triceps dim.
#
# How they differ from the library: the Front Squat, Goblet Squat and
# Kettlebell Goblet Squat stand back up and stop; the Push Press, Barbell
# Overhead Press and Dumbbell Push Press start standing. The thrusters run a
# front squat straight into the press, the legs launching the weight. The
# Clean and Press lifts the bar from the floor (a power clean) before a
# strict press. Each cue set is its own: rack, depth, knees, leg drive,
# lockout (barbell); dumbbell rack, depth, heels, leg drive, lockout
# (dumbbells); kettlebell rack, wrists, depth, leg drive, lockout
# (kettlebells); start, first pull, arms, catch, strict press (clean and
# press).
#
# Sources (ExRx through the Wayback Machine, the live site returns 403;
# CrossFit's pages fetched 2026-10-05; abstracts read on Europe PMC; details
# and what each supports in the notes):
# - ExRx.net: Barbell Thruster (WeightExercises/Power/BBThruster, snapshot
#   2020-09-18) and Dumbbell Thruster (Power/DBThruster, 2021-01-23): the
#   bar or dumbbells on the front of the shoulders with the elbows pointing
#   slightly forward and the torso tight, feet slightly wider than the
#   shoulders and turned out; down until the thighs are just past level,
#   knees out toward the toes; accelerate near the top of the squat and
#   drive the weight off the shoulders; pull the head forward at lockout;
#   catch the weight back on the shoulders with the legs bending; hip, knee
#   and elbow extension, ankle plantar flexion, shoulder flexion and
#   abduction, scapular upward rotation, the spine held. Power Clean
#   (OlympicLifts/PowerClean, 2026-05-30) and Clean (2025-03-08): feet
#   hip-width, grip slightly wider than the shoulders, shoulders over the
#   bar, back arched tightly, arms straight; bar close to the thighs; jump,
#   shrug, pull with the elbows out, pull under; catch before the knees bend
#   past 90°; complete with the feet in line; do not jerk the bar from the
#   floor. Barbell Military Press (DeltoidAnterior/BBMilitaryPress,
#   2025-12-26): its muscles (target anterior deltoid; synergists
#   clavicular pectoralis, triceps, lateral deltoid, middle and lower
#   trapezius, serratus anterior; stabilisers upper trapezius, levator
#   scapulae). Push Press (OlympicLifts/PushPress, 2026-03-16): the dip and
#   leg drive the strict press leaves out. Barbell Front Squat
#   (Quadriceps/BBFrontSquat, 2026-02-06): target quadriceps; synergists
#   gluteus maximus, adductor magnus, soleus. Kettlebell Front Squat
#   (Kettlebell/KBFrontSquat, 2025-08-19) and Kettlebell Press
#   (Kettlebell/KBPress, 2025-08-24): each arm close to the body, the bell
#   against the outside of the arm, the supporting wrist straight, knees
#   pointing the same way as the feet.
# - CrossFit, The Thruster (crossfit.com/essentials/the-thruster): a front
#   squat into a press; roughly shoulder-width stance, toes out slightly, bar
#   racked high on the shoulders, hands just outside the shoulders; hip
#   crease below the top of the knees; heels down until the hips and knees
#   extend; the legs elevate the bar off the shoulders before the arms press,
#   the bar staying connected to the body until they do;
#   pressing early (before full hip and leg extension) is a common
#   core-to-extremity fault (less weight lifted, inefficient, more fatigue);
#   finish overhead roughly in line with the ankles; the front squat and
#   press faults (heels lifting, knees caving in, lumbar curve lost, poor bar
#   path, short range) also show here; dumbbells or kettlebells may give a
#   better rack. CrossFit, The Thruster: A Potent Tool (S. Rochet): at the
#   bottom the weight pulls the athlete forward; at the top it tends to
#   finish out in front. CrossFit, The Front Squat: a bar held in the hands
#   off the torso lets the arms soak up the leg drive like shock absorbers
#   and stresses the shoulders, elbows and wrists; knees track the toes;
#   weight toward the balls of the feet takes work off the glutes and
#   hamstrings. CrossFit, The Shoulder Press: pressed without help from the
#   legs; elbows down and out and slightly in front of the bar in the rack;
#   the chin pulled back and the
#   bar kept close to the face; finished with the arms locked and the bar
#   over the ankles; a bar held forward of the ankles lacks support.
#   CrossFit, The Power Clean: received in a partial squat, hip crease above
#   the knees; feet under the hips; hips above the knees and the shoulders
#   above the hips at the start, low back flat; the bar drifting from the
#   body, cutting the extension short, a weak receiving position (chest and
#   shoulders rolling forward, back rounding) and bending the arms before
#   full hip and knee extension as common faults; elbows high and outside
#   in the pull under; the feet move out from hip-width as you land.
# - Gullett JC, Tillman MD, Gutierrez GM, Chow JW 2009, J Strength Cond Res
#   23(1):284-292, doi:10.1519/JSC.0b013e31818546bb, PMID 19002072 - 15
#   healthy trained individuals: the front squat was as effective as the back
#   squat in overall muscle recruitment with less compressive force at the
#   knee; activity was greater standing up than going down.
# - Contreras B, Vigotsky AD, Schoenfeld BJ, Beardsley C, Cronin J 2016,
#   J Appl Biomech 32(1):16-22, doi:10.1123/jab.2015-0113, PMID 26252837 -
#   13 trained women: no difference in gluteus maximus, biceps femoris or
#   vastus lateralis EMG between front, full and parallel squats.
# - Saeterbakken AH, Fimland MS 2013, J Strength Cond Res 27(7):1824-1831,
#   doi:10.1519/JSC.0b013e318276b873, PMID 23096062 - 15 men, standing and
#   seated barbell and dumbbell shoulder presses at 80% 1RM: standing,
#   anterior deltoid ~15% lower and medial deltoid ~7% lower with the
#   barbell than with dumbbells, triceps ~39% higher with the barbell.
# - Blazkiewicz M, Hadamus A 2022, Sensors 22(24):9762,
#   doi:10.3390/s22249762, PMID 36560129 (PMC9781216) - 20 adults, seated
#   kettlebell vs dumbbell overhead press at the same loads: no significant
#   difference in any muscle measured.
# - Nagao H, Ishii Y 2021, J Strength Cond Res 35(12):3288-3295,
#   doi:10.1519/JSC.0000000000003355, PMID 31453932 - 20 trained men, power
#   clean: the upper trapezius appeared to hold the shoulder blades in place in
#   the first pull and transition and contracted hard to lift them in the
#   second pull.
# No EMG study of these four lifts as the models do them was found, so every
# fraction below is a judgement call anchored on the library's nearest lifts
# (Front Squat, Back Squat, Goblet Squat, Push Press, Dumbbell Push Press,
# Barbell Overhead Press, Deadlift, Barbell Shrug) and the order the studies
# give; the notes say which.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def thruster_glows(name):
    """The near (left) quadriceps full, the far one soft, and the near front
    deltoid; the glutes face away from these front three-quarter framings."""
    return [glow(name, ["thigh_L", "patella_L"], A, 0.55, 0.05, 0.07, 0.0, 0.0),
            glow(name, ["thigh_R", "patella_R"], SOFT, 0.30, 0.045, 0.06, 0.0, 0.0),
            glow(name, ["deltoid_arc_clavicle_2_L"], A, 0.45, 0.035, 0.035, 0.0, 0.0)]


# Shared rows. Paint (all three thrusters): anterior deltoid, glutes and
# quadriceps bright -> PRIMARY; adductors, lateral deltoid, trapezius,
# rhomboid, triceps dim -> SECONDARY. Quadriceps 0.86: the library's Goblet
# Squat (0.85) and Kettlebell Goblet Squat (0.86), under its Front Squat
# (0.94), whose copy asks for the hip crease below the knee (these models stop
# with the thighs 15-20° above level); Gullett 2009 found the front squat
# matched the back squat's overall muscle recruitment. Gluteus Maximus 0.62:
# the library's Back Squat; Contreras 2016 found no significant difference in
# gluteus maximus EMG between front, full and parallel squats; bright, so
# primary at a moderate value. The rhomboids, lit with the trapezius, are
# named in the stabilisers: the Trapezius row files the same muscle group
# (upper back) and a fifth secondary name would run the one-line legend far
# past its width. The bright gluteus
# medius and minimus are covered by the Gluteus Maximus row's group and named
# in the stabilisers too. Adductors 0.38: ExRx lists the adductor magnus as a
# front-squat synergist; the library's Squat has it at 0.40. Trapezius 0.36:
# the library's Standing Dumbbell Press; ExRx lists the middle and lower
# trapezius as press synergists and CrossFit names the traps among the
# muscles that drive the bar overhead. All judgement calls.
QUADS = ("Quadriceps", P, HI, 0.86)
FRONT = ("Anterior Deltoid", P, HI, 0.80)
GLUTES = ("Gluteus Maximus", P, MOD, 0.62)
STAB = ["core", "gluteus medius", "rhomboids", "serratus anterior"]

# ---------------------------------------------------------------- Barbell Thruster

N = "Barbell Thruster"
ex(name=N, var="barbellThruster",
   # Front three-quarter from the lifter's left (yaw -0.8). The plates sweep
   # both sides of the frame from v ~0.09 (locked out) to ~0.63 (bottom), so
   # four labels sit below them (rows 0.64-0.80) and one above them at the
   # top left (0.09), where the left-hand plate never rises past v ~0.17; at
   # 0.12 the lab shot showed the lockout fault's lifted plate under the pill
   # in the mistake view, and at 0.07 the pill covered the COMMON MISTAKE
   # chip (its lockout ghost is now turned so the plate moves inward). Short
   # pills on the left so they stay clear of the right knee, which swings
   # out to u ~0.31 at the bottom; the leg-drive label points at the right
   # foot, the floor the drive pushes against, so its leader stays off the
   # right calf.
   overrides={"lockout": (ov(0.09), "leading"), "rack": (ov(0.64), "leading"),
              "drive": (ov(0.80), "leading"), "depth": (ov(0.66), "trailing"),
              "knees": (ov(0.73), "trailing")},
   annotations=[
       ("rack", "Elbows in front", "forearm_R"),
       ("depth", "Thighs to level", "thigh_L"),
       ("knees", "Knees over toes", "patella_L"),
       ("drive", "Legs, then arms", "foot_R"),
       ("lockout", "Lock out overhead", "hand_R"),
   ],
   cues={
       "rack": ("Front Rack",
                "The bar is held at the front of the shoulders, just above the collarbones, the elbows pointing down and a little in front of it.",
                "ExRx sets the thruster up with the bar on the front of the shoulders and the elbows pointing slightly forward, and CrossFit's thruster guide keeps the bar against the body until the legs lift it off the shoulders. Its front squat guide warns that a bar held up in the hands, off the body, lets the arms soak up the drive from the legs like shock absorbers and loads the shoulders, elbows and wrists.",
                "The bar rolling forward off the shoulders into the hands as you sink, the chest tipping after it.",
                "Grip just outside your shoulders, hold the bar at the front of your shoulders by the collarbones, and keep the elbows a little in front of it all the way down and up."),
       "depth": ("Squat Depth",
                 "Sit down until the thighs are close to level with the floor.",
                 "ExRx takes the thruster's squat to the thighs just past level, and CrossFit's standard to the hip crease below the top of the knees. The lifter here stops about 15 degrees above level. Stopping much higher turns the squat into a short dip, so the legs drive the bar through less of their range.",
                 "Stopping well short of level and driving up from a shallow squat.",
                 "Sit down between your heels until your thighs are about level with the floor, deeper if your heels stay down and your back stays flat, then drive straight back up."),
       "knees": ("Knee Track",
                 "The knees push out over the toes on the way down and the way up.",
                 "ExRx moves the knees slightly outward in the direction of the toes. CrossFit counts knees caving in among the front squat faults that also show in the thruster, and its front squat guide gives the reasons: the force no longer goes efficiently into the floor and back up into the bar, and the caved position may lead to knee pain over time.",
                 "The knees caving in toward each other as you drive out of the bottom.",
                 "Turn your toes slightly out and push your knees out over them all the way down and back up."),
       "drive": ("Leg Drive",
                 "Stand up fast and let the legs pop the bar off the shoulders before the arms press.",
                 "CrossFit's guide makes the legs lift the bar off the shoulders first and the arms finish it. Pressing before the hips and knees have straightened is a common thruster fault it names: less weight lifted, wasted effort and more fatigue. Here the bar leaves the shoulders as the knees straighten and the arms finish the press once the legs are straight.",
                 "Pressing with the arms while you are still rising out of the squat.",
                 "Drive up hard through the whole foot, keep the bar on your shoulders until the snap of your hips and knees pops it off, then press it the rest of the way."),
       "lockout": ("Lockout",
                   "Finish with the arms straight and the bar over the head and ankles.",
                   "CrossFit finishes the thruster with the bar overhead, roughly in line with the ankles, and its shoulder press guide explains that a bar held forward of the ankles lacks the support of the body under it. ExRx pulls the head forward at lockout. The weight tends to finish out in front, so the straight line takes a deliberate push.",
                   "Finishing with the bar out in front of the face, arms angled forward.",
                   "Press straight up past your face, then push your head through so the bar ends over the middle of your head and your ankles, elbows locked, before you bring it back to your shoulders."),
   },
   # QUADS, FRONT, GLUTES; Anterior Deltoid 0.80 is the library's Push Press
   # (in both the legs launch the bar and the arms finish it). Dim rows:
   # Triceps Brachii 0.58 and Lateral Deltoid 0.56 (the Push Press's values),
   # Adductors 0.38, Trapezius 0.36 (see above). Judgement calls.
   activation=[QUADS, FRONT, GLUTES,
               ("Triceps Brachii", S, MOD, 0.58), ("Lateral Deltoid", S, MOD, 0.56),
               ("Adductors", S, LOW, 0.38), ("Trapezius", S, LOW, 0.36)],
   stabilisers=STAB,
   comparison=("PRESSING EARLY", "Legs first, then arms", "Arms press out of the squat",
               "Letting the legs pop the bar off the shoulders puts their drive into the bar, so the arms only have to finish it overhead.",
               "Pressing while you are still rising starts the arms before the legs have finished, a common fault CrossFit says costs load and adds fatigue."),
   glows=thruster_glows(N))

SETUP[N] = [
    "Take the bar from a rack with an overhand grip just outside your shoulders.",
    "Bring it to the front of your shoulders, by the collarbones, elbows pointing down and a little forward.",
    "Step back and set your feet about shoulder-width apart, toes turned slightly out.",
    "Brace your trunk and stand tall with your weight over the whole foot.",
]

# ---------------------------------------------------------------- Dumbbell Thruster

N = "Dumbbell Thruster"
ex(name=N, var="dumbbellThruster",
   # More face-on (yaw -0.6) and larger: the dumbbells sweep u ~0.26-0.79
   # from the top of the frame to v ~0.53, so the labels are short and sit
   # outside them: two at the top left, clear of the right dumbbell overhead
   # (u >= 0.38), two on the right below the left dumbbell and elbow, one on
   # the left below the right dumbbell.
   overrides={"lockout": (ov(0.12), "leading"), "hold": (ov(0.19), "leading"),
              "depth": (ov(0.58), "trailing"), "drive": (ov(0.64), "leading"),
              "heels": (ov(0.80), "trailing")},
   annotations=[
       ("hold", "On shoulders", "hand_R"),
       ("depth", "Thighs level", "thigh_L"),
       ("heels", "Heels down", "foot_L"),
       ("drive", "Legs first", "patella_R"),
       ("lockout", "Arms locked out", "forearm_R"),
   ],
   cues={
       "hold": ("Dumbbell Rack",
                "The dumbbells sit on the front of the shoulders, palms facing in, elbows pointing down and forward.",
                "ExRx starts the dumbbell thruster with the dumbbells in front of the shoulders and the elbows pointing slightly forward. Resting on the shoulders, they travel with the body and the legs drive them up. Held out in front, the arms carry them through the squat and they pull the chest forward at the bottom, where CrossFit notes the weight already tries to pull you forward.",
                "The dumbbells drifting forward off the shoulders as you squat, the arms holding them out in front.",
                "Rest the back end of each dumbbell on the front of each shoulder, palms facing in, and keep them there from the top of the squat to the bottom."),
       "depth": ("Squat Depth",
                 "Squat until the tops of the thighs are nearly level with the floor.",
                 "ExRx takes the dumbbell thruster down until the thighs are just past level, and CrossFit's thruster standard takes the hip crease below the top of the knees; the lifter here stops about 20 degrees above level. A much shallower squat leaves the legs only a short dip to drive the dumbbells from.",
                 "Cutting the squat short and standing up from well above level.",
                 "Sit between your heels until your thighs are close to level, lower if your heels stay down and your chest stays up, then drive straight back up."),
       "heels": ("Foot Pressure",
                 "The heels stay down until the legs are straight.",
                 "CrossFit keeps the heels down until the hips and knees have fully straightened and lists heels lifting early among the thruster's faults. Its front squat guide adds that shifting onto the balls of the feet takes work away from the glutes and hamstrings.",
                 "Rocking onto the toes at the bottom or as you start to stand.",
                 "Keep your weight over the middle of the foot and drive the floor away through your heels until your legs are straight."),
       "drive": ("Leg Drive",
                 "Stand up fast and let the legs drive the dumbbells up before the arms press.",
                 "In CrossFit's thruster the legs move the load off the shoulders and the arms only take over once the hips and knees are straight; engaging the arms earlier is a fault it calls common, one that costs load and adds fatigue. Here the dumbbells leave the shoulders as the knees straighten and the arms finish with the legs straight.",
                 "Pressing the dumbbells with the arms while you are still rising out of the squat.",
                 "Drive up hard, keep the dumbbells on your shoulders until the snap of your hips and knees lifts them off, then press them the rest of the way."),
       "lockout": ("Lockout",
                   "Finish with straight arms and the dumbbells over the shoulders, palms still facing in.",
                   "CrossFit finishes the thruster overhead roughly in line with the ankles, the line the body can support from below. With two dumbbells each arm finds that line on its own, and in a shoulder-press study the standing dumbbell press, the version with the most to steady, drew the most deltoid activity.",
                   "Finishing with the dumbbells in front of the face, the arms angled forward.",
                   "Press straight up beside your head until both elbows lock, the dumbbells over your shoulders and ankles, then bring them back to your shoulders."),
   },
   # QUADS, FRONT, GLUTES + the library's Dumbbell Push Press arm values
   # (Lateral Deltoid 0.60, Triceps Brachii 0.55; its Anterior Deltoid is
   # 0.80 too): Saeterbakken 2013 found standing dumbbell presses higher in
   # anterior and medial deltoid and lower in triceps activity than the
   # barbell, the direction those values already lean. Adductors 0.38,
   # Trapezius 0.36 as the barbell's. Judgement calls.
   activation=[QUADS, FRONT, GLUTES,
               ("Lateral Deltoid", S, MOD, 0.60), ("Triceps Brachii", S, MOD, 0.55),
               ("Adductors", S, LOW, 0.38), ("Trapezius", S, LOW, 0.36)],
   stabilisers=STAB,
   comparison=("DUMBBELLS DRIFTING", "Dumbbells on the shoulders", "Dumbbells drift out in front",
               "Resting on the shoulders, the dumbbells ride the leg drive up and the chest stays tall at the bottom.",
               "Held out in front, the arms carry them through the squat and they pull the chest forward where the weight already tries to tip you."),
   glows=thruster_glows(N))

SETUP[N] = [
    "Stand with your feet about shoulder-width apart, toes turned slightly out, a dumbbell in each hand.",
    "Bring the dumbbells to your shoulders, palms facing in, one end of each resting on the front of the shoulder.",
    "Point your elbows down and a little forward.",
    "Set your trunk tight and keep your weight spread over both feet.",
]

# ---------------------------------------------------------------- Kettlebell Thruster

N = "Kettlebell Thruster"
ex(name=N, var="kettlebellThruster",
   # As the dumbbell thruster's framing (yaw -0.6). The bells sweep u
   # ~0.22-0.69 down to v ~0.61 and, locked out, u ~0.34-0.93 at the top, so
   # two short labels sit at the top left, two on the right outside the left
   # bell's reach, one on the left below the right bell. No knee cue: this
   # model's knees cave in at the bottom (see the header).
   overrides={"lockout": (ov(0.12), "leading"), "wrists": (ov(0.19), "leading"),
              "rack": (ov(0.52), "trailing"), "depth": (ov(0.64), "trailing"),
              "drive": (ov(0.64), "leading")},
   annotations=[
       ("rack", "Elbows tucked", "forearm_L"),
       ("wrists", "Wrists straight", "hand_R"),
       ("depth", "Thighs level", "thigh_L"),
       ("drive", "Legs first", "patella_R"),
       ("lockout", "Arms locked", "forearm_R"),
   ],
   cues={
       "rack": ("Kettlebell Rack",
                "The elbows stay tucked against the ribs, the hands in front of the chin and the bells resting on the outsides of the forearms.",
                "ExRx holds the bells for a kettlebell front squat with each arm close to the body, and sets the bell for a kettlebell press against the outside of the arm, the arm close to the body at the bottom. Tucked in, the arms rest on the trunk and the bells ride the leg drive up; flared out, the arms hold the bells away from the body through the whole squat.",
                "The elbows flaring out to the sides and the bells drifting away from the chest.",
                "Keep each elbow against your ribs and each bell resting on the outside of the forearm, the hands close together in front of your chin."),
       "wrists": ("Wrist Position",
                  "The wrists stay straight under the bells.",
                  "ExRx keeps the wrist that supports the kettlebell straight, in both the kettlebell front squat and the kettlebell press. A straight wrist lets the bell sit on the forearm; bent back, the bell's weight hangs on the bent wrist instead.",
                  "The wrists bending back under the weight of the bells.",
                  "Grip the handles with straight wrists, in line with your forearms, and let the bells rest on the outsides of the forearms."),
       "depth": ("Squat Depth",
                 "Lower until the thighs are close to level, the bells still in the rack.",
                 "ExRx takes a kettlebell front squat down until the thighs are just past level, and CrossFit's thruster standard puts the hip crease below the top of the knees. The lifter here stops about 20 degrees short of level; a much shallower squat gives the legs only a short dip to launch the bells from.",
                 "Bobbing only part of the way down and standing straight back up.",
                 "Sit down between your feet until your thighs are close to level, deeper if your heels stay flat and the bells stay in the rack, then drive straight back up."),
       "drive": ("Leg Drive",
                 "Stand up fast and let the legs drive the bells up before the arms press.",
                 "CrossFit wants the legs to lift the load off the shoulders before the arms direct it overhead; using the arms first is the timing fault its thruster guide flags, with less weight lifted and more fatigue. Here the bells leave the rack as the knees straighten and the arms finish the press with the legs straight.",
                 "Pressing the bells with the arms while you are still rising out of the squat.",
                 "Drive up hard, keep the bells in the rack until the snap of your hips and knees lifts them off, then press them the rest of the way."),
       "lockout": ("Lockout",
                   "Finish with straight arms beside the ears, palms forward and the bells resting behind the wrists.",
                   "CrossFit ends the thruster with the load overhead and the arms locked, roughly over the ankles, where the body is under it. Here the hands finish over the shoulders and ankles, each bell hanging behind its wrist, and the palms have turned from facing in to facing forward on the way up.",
                   "Finishing with the bells out in front of the face, the arms angled forward.",
                   "Press up and turn the palms forward as the bells pass your face, lock the elbows with your arms beside your ears, then bring the bells back to the rack."),
   },
   # As the dumbbell thruster: Blazkiewicz 2022 found no significant
   # difference between kettlebell and dumbbell presses at the same load.
   # Judgement calls.
   activation=[QUADS, FRONT, GLUTES,
               ("Lateral Deltoid", S, MOD, 0.60), ("Triceps Brachii", S, MOD, 0.55),
               ("Adductors", S, LOW, 0.38), ("Trapezius", S, LOW, 0.36)],
   stabilisers=STAB,
   comparison=("ELBOWS FLARED", "Elbows tucked to the ribs", "Elbows flare, bells drift out",
               "With the elbows tucked the bells rest on the forearms against the body and ride the leg drive up.",
               "Flared out, the arms hold the bells away from the body through the squat, unlike ExRx's set-up with each arm close to the body."),
   glows=thruster_glows(N))

SETUP[N] = [
    "Stand with your feet about shoulder-width apart, toes turned slightly out.",
    "Clean a kettlebell to each shoulder, the bells resting on the outsides of your forearms.",
    "Tuck your elbows against your ribs, hands close together in front of your chin, wrists straight.",
    "Brace your abs and stand tall, weight over the middle of each foot.",
]

# ---------------------------------------------------------------- Clean and Press

N = "Clean and Press"
ex(name=N, var="cleanAndPress",
   # Front three-quarter from the lifter's left (yaw -0.8). The plates rise
   # from the floor (v ~0.67-0.88) to overhead (v ~0.10-0.31) and back down
   # both sides of the frame, so every row but the top left is crossed by a
   # plate for part of the rep. Two labels sit at the top left (0.09 and
   # 0.14), which no plate reaches (0.07 covered the COMMON MISTAKE chip in
   # the mistake views); the others where a plate only passes
   # briefly: the right top row during the lockout (~1 s), rows 0.58 as the
   # bar rises past them in the pull and falls in the lowering. The first lab
   # shots had the catch label at 0.19 under the left-hand plate at lockout
   # and the start label at 0.50 under the right-hand plate at the catch.
   overrides={"press": (ov(0.09), "leading"), "catch": (ov(0.14), "leading"),
              "extend": (ov(0.16), "trailing"), "start": (ov(0.58), "trailing"),
              "pull": (ov(0.58), "leading")},
   annotations=[
       ("start", "Flat back", "pelvis"),
       ("pull", "Bar close", "hand_R"),
       ("extend", "Arms long", "forearm_L"),
       ("catch", "Catch, chest up", "clavicle_R"),
       ("press", "Strict press", "forearm_R"),
   ],
   cues={
       "start": ("Start Position",
                 "Bar over the middle of the feet, shoulders over the bar, back flat and hips above the knees.",
                 "ExRx starts the clean with the shoulders over the bar, the back arched tightly and the arms straight, and CrossFit keeps the hips above the knees and the lower back flat. A flat back holds the trunk rigid, so the push of the legs reaches the bar instead of bending the spine; CrossFit has the back and trunk muscles brace to pass that force from the floor into the bar.",
                 "Starting with the lower back rounded and the head dropped over the bar.",
                 "Stand with the bar over the middle of your feet, grip it a little wider than your shoulders, then flatten your back and lift your chest until your shoulders are over the bar before it leaves the floor."),
       "pull": ("First Pull",
                "Push the floor away and keep the bar close to the shins and thighs.",
                "CrossFit names a bar that drifts away from the body in the first pull as a common fault: it can pull you forward and blunt the hips in the next pull. ExRx keeps the bar close to the thighs and asks you to lift it steadily rather than jerk it off the floor. Here the bar stays within about two centimetres of the shins and thighs all the way up.",
                "The bar drifting out in front of the shins and knees on its way up from the floor.",
                "Lift the bar off the floor smoothly with the legs and keep it close to your shins as it rises and to your thighs once it passes your knees."),
       "extend": ("Second Pull",
                  "The arms stay long until the hips and knees have driven the bar up.",
                  "CrossFit keeps the arms straight through the first and second pulls and starts pulling with them only after the hips and knees extend; bending them early cuts power and can let the bar drift or the hips stop short. Here the elbows stay long until the hips open and the heels rise, then bend high and out to pull you under.",
                  "Bending the elbows to haul the bar up while the hips are still bent.",
                  "Let the arms hang long while you drive the hips forward and rise onto the toes, then pull the elbows high and out and drop under the bar."),
       "catch": ("Receiving Position",
                 "Meet the bar on the front of the shoulders in a partial squat, chest up, then stand.",
                 "A power clean is caught in a partial squat with the hip crease above the knees, and ExRx catches it before the knees bend past 90 degrees. CrossFit lists a weak receiving position, the chest and shoulders rolling forward and the back rounding, as a common fault that makes the bar hard to stand up with. Here the knees bend to about 100 degrees and the feet land a little wider, then step back in before the press.",
                 "Catching with the chest and shoulders rolling forward and the upper back rounding under the bar.",
                 "Pull yourself under, land with the feet a little wider, the knees out and the chest up, stand tall, then step the feet back under the hips."),
       "press": ("Strict Press",
                 "Press the bar overhead with the legs straight; no dip, no drive.",
                 "CrossFit's shoulder press is done without help from the legs, the bar pressed in a straight line close to the face and finished over the ankles with the arms locked. The push press adds a dip and a leg drive, which here would hand part of the press to the legs. The knees stay straight from the rack to lockout.",
                 "Dipping the knees and driving the bar up with the legs, turning it into a push press.",
                 "Squeeze your glutes and thighs, pull your chin back, press the bar straight up past your face and lock out with it over the middle of your head and your ankles."),
   },
   # Paint: anterior deltoid, glutes, quadriceps, trapezius and rhomboid
   # bright -> PRIMARY. Anterior Deltoid 0.84 (the strict press; the
   # library's Barbell Overhead Press is 0.86). Trapezius 0.70: Nagao 2021,
   # the upper trapezius appeared to hold the shoulder blades in the first pull
   # and lifted them hard in the second (the library's Barbell Shrug, an
   # isolation lift, is 0.88; ExRx lists the middle and lower trapezius as
   # press synergists).
   # Gluteus Maximus 0.70 and Quadriceps 0.62: CrossFit names the hips,
   # quads, glutes and hamstrings the prime movers of the power clean;
   # anchored on the library's Deadlift (0.76 and 0.50), with the quadriceps
   # higher for the catch and the stand from a partial squat. The rhomboids
   # are named in the stabilisers (the Trapezius row files the same group; a
   # fifth primary name would run the legend further past its width), as are
   # the gluteus medius and minimus. Dim -> SECONDARY: Erector Spinae 0.55
   # (ExRx: the spine held through the clean; the Deadlift's 0.85 is for
   # heavier loads), Triceps Brachii 0.55 and Lateral Deltoid 0.50 (the press;
   # the Overhead Press's 0.58 and ExRx's synergist), Hamstrings 0.50 (the
   # Deadlift's 0.66, lighter here), Forearms 0.35 (gripping the bar through
   # the clean). The dim biceps (bending the elbows in the pull under, ExRx's
   # elbow flexion) and calves (rising onto the toes at the top of the pull)
   # work briefly and are named in the stabilisers. Judgement calls.
   activation=[("Anterior Deltoid", P, HI, 0.84), ("Trapezius", P, HI, 0.70),
               ("Gluteus Maximus", P, HI, 0.70), ("Quadriceps", P, MOD, 0.62),
               ("Erector Spinae", S, MOD, 0.55), ("Triceps Brachii", S, MOD, 0.55),
               ("Hamstrings", S, MOD, 0.50), ("Lateral Deltoid", S, MOD, 0.50),
               ("Forearms", S, LOW, 0.35)],
   stabilisers=["core", "rhomboids", "gluteus medius", "biceps", "calves"],
   comparison=("ARMS PULL EARLY", "Arms long until the jump", "Elbows bend before the hips open",
               "Keeping the arms long lets the hips and legs drive the bar, then the arms pull you under it.",
               "Bending the arms early cuts the power of the pull and can let the bar drift or the hips stop short, as CrossFit warns."),
   glows=[glow(N, ["deltoid_arc_clavicle_2_L"], A, 0.45, 0.035, 0.035, 0.0, 0.0),
          glow(N, ["support_TrapeziusUpper_L"], A, 0.40, 0.035, 0.03, 0.0, 0.0),
          glow(N, ["thigh_L", "patella_L"], A, 0.50, 0.05, 0.07, 0.0, 0.0),
          glow(N, ["thigh_R", "patella_R"], SOFT, 0.28, 0.045, 0.06, 0.0, 0.0)])

SETUP[N] = [
    "Stand with your feet about hip-width apart, the bar over the middle of your feet.",
    "Bend down and grip the bar overhand, a little wider than your shoulders.",
    "Flatten your back, lift your chest and set your shoulders over the bar, hips above your knees.",
    "Brace your trunk before the bar leaves the floor.",
]
