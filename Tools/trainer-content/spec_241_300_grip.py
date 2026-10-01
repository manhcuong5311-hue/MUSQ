# Trainer content for batch 241-300 (2026-09-27), family: grip holds.
# Exports 277-280 of the HIKSEMI drive's 241-300 folder (Forearms/*.usdc).
# Same format as spec.py; spec_241_300.py imports this module and gen.py
# reads SPEC / SETUP. All four are timed: the app logs their sets in seconds
# (ExerciseCatalog.timedExercises), so the setup and cues talk about holding
# for time.
#
# What each model shows, from the briefs, the framing shots and the rig
# (joints sampled over the clip, in the app's Y-up space; torso length, neck
# to pelvis, is 0.59 m). Every clip is 8 s of stillness: nothing moves by
# more than a few degrees, so every fault is read at any moment.
# - Plate Pinch Hold (277): standing tall, feet 0.32 m apart, knees 166°,
#   trunk vertical, shoulders level and relaxed. In each hand a pair of
#   smooth 33 cm plates pinched together (the pair is 5.7 cm thick), hanging
#   at the side with the top rim level with the wrist. Palms face the thighs;
#   the fingers lie almost flat on the outer face (middle finger bent 67° in
#   all) and the thumb is on the inner face, nearest the body. Wrists 11°
#   back (extended), elbows soft (161-164°), the hands right under the
#   shoulders. The plates rest against the outer thighs: on the skinned mesh
#   at 2.0 s the vastus lateralis and shorts reach up to 4.1 cm into the
#   inner plate (inner face at |x| 0.216 m, thigh surface out to 0.257 m), so
#   the copy does not ask for plates hanging clear of the legs.
# - Dumbbell Static Hold (278): the same stance (knees 174-179°). A heavy
#   dumbbell in each hand (heads 24 cm across, 45 cm long), handles running
#   front to back, palms facing the thighs, the hand in the middle of the
#   handle, fingers closed round it (153°). Arms straight (178°) and hanging
#   at the sides, 1 cm ahead of the shoulders; wrists 5° back.
# - Barbell Static Hold (279): the same stance. An Olympic bar with 45 cm
#   plates, held overhand (palms facing back toward the thighs), hands 0.48 m
#   apart (about shoulder-width, just outside the thighs), thumbs round the
#   bar. Arms straight (178°), angled 19° forward so the bar hangs 18-19 cm
#   ahead of the shoulders, just below the hip crease and 3.5-5 cm clear of
#   the shorts and thighs (skinned mesh); wrists 4-5° back. The arms cannot
#   hang straight down: the fronts of the thighs are 13-15 cm ahead of the
#   shoulder joints at bar height. Framed at yaw -0.8.
# - Towel Grip Hold (280): hanging in a power rack from two towels folded
#   over the bar, one per hand, 0.53 m apart (a little wider than the
#   shoulders); each hand grips both ends of its towel at the bottom, palm
#   facing forward, fingers and thumb wrapped round (153°), wrists 8-9° back.
#   Arms nearly straight (168-171°), upper arms beside the head (165-167°
#   elevation). The towels hang the grip too low to hang with straight legs,
#   so the knees are bent 90° with the thighs almost vertical (hips 170°)
#   and the shins pointing back; the feet hang 24 cm above the floor, 0.2 m
#   apart, the shoes about 6 cm clear of the floor. Trunk 3-4° back of
#   vertical, head level.
#   The shoulders ride up with the arms (4.3 cm closer to the ears than when
#   standing, about 1.6 cm higher than the Pull-Up model at its bottom), so
#   the copy does not ask for a packed shoulder the model does not show.
#
# Framing: yaw -0.5 (the barbell -0.8), so the lifter's LEFT arm is on the
# RIGHT of the frame. Labels are pinned with `overrides`; the plates,
# dumbbell heads and bar plates sit at about v 0.41-0.61, so no pill is
# placed on the middle row, and the bottom pills sit just under the load.
# Visual review (2026-09-27, app screenshots): the top-right pills are short
# ("Shoulders back", from u 0.697) so they clear the head in the trainer and
# the upper back in the side-view stills; the posture dots moved off the
# spine (the leader ran through the right elbow, and on the barbell the
# spine dot sat beside the left wrist); the plate's arm cue moved to the near
# elbow, which stays in view when the fault turns the model (-1.3).
# Second round: all three posture dots are on the upper abdomen
# (support_PectoralisMajor_Abdominal_L). The chest joint is a spine bone, so
# in the plate and dumbbell posture stills (turned side-on) it sat inside the
# trunk under the ghost's forward-hanging elbow; on the front of the chest it
# stays clear of the ghost. The plate's hand pill is "Wrists straight", as on
# the dumbbell hold, so it starts right of the left calf in the pinch still.
#
# Sources (every one opened and checked on 2026-09-27):
# - Derwin J 2015, Effective methods of grip strength development, NSCA Coach
#   2(3):8-17 (National Strength and Conditioning Association). Three grips:
#   crushing (finger to palm), pinching (finger to thumb), supporting
#   (carrying a load for distance or time). The flexors of the hand and
#   forearm create gripping force while the forearm extensors stabilise the
#   wrist. Plate pinching: two plates of equal weight pinched for an
#   established time; progress by more plates, heavier plates or harder
#   positions; forceful pinching stresses the forearm tendons more than a
#   crushing grip. Towels hung from a pull-up bar add an unstable gripping
#   surface that works the finger and forearm flexors and recruits the
#   extensors to steady the wrist (its towel pull-up photos show the knees
#   bent, feet off the floor). Example circuit: farmer's walks 30 s, plate
#   pinches 30 s. Grip work late in the session.
# - Gill C 2024 (26 Feb), The evidence-based guide to grip strength training
#   and forearm muscle development, Stronger by Science. Support grip
#   (deadlifts, pull-ups, farmer's walks), pinch grip (plate pinches, pinch
#   blocks), crush grip. FDS, FDP and FPL are the only muscles that can flex
#   the finger and thumb interphalangeal joints; the hand's own muscles also
#   flex the knuckles, and the flexor pollicis brevis the thumb's base and
#   knuckle. He rates strengthening FDS and FDP as even more important to
#   grip than the FPL; Cha et al 2014 put the thumb at 17% of total grip
#   strength. With the wrist flexed the long flexors are shortened and cannot
#   produce maximal force; maximal grip force is usually produced with the
#   wrist 20-45° extended. A plate pinch is easier if the fingertips can wrap
#   under a plate's raised lip than on the flat face; pinch grip relies
#   entirely on friction, so chalk and dry hands matter. Barbell holds from
#   an above-the-knee rack pull or block pull; dead hangs build support grip
#   without loading the spine. Sample programme: suitcase rack pull hold and
#   dead hang, 2 x 20-40 s, the load or variation chosen so the grip nears
#   failure in 20-40 s.
# - Mogk JP, Keir PJ 2003, Ergonomics 46(9):956-975,
#   doi:10.1080/0014013031000107595 — 10 adults gripping at 5-100% of
#   maximum in three wrist and three forearm postures: a flexed wrist cut
#   maximum grip force by 40-50%; baseline extensor activity was greatest
#   with the forearm pronated and the wrist extended; extensor activity was
#   generally larger than the flexors' at low to mid forces, and with the
#   forearm pronated it exceeded the flexors' at every target force; the
#   flexors exceeded the extensors only at 70 and 100% in some postures.
# - O'Driscoll SW, Horii E, Ness R, Cahalan TD, Richards RR, An KN 1992,
#   J Hand Surg Am 17(1):169-177, doi:10.1016/0363-5023(92)90136-d — the
#   self-selected wrist position in maximal grip was 35° extension and 7°
#   ulnar deviation; grip strength fell in any other position; at least 25°
#   of extension was needed for optimum grip strength.
# - Halpern CA, Fernandez JE 1996, J Hum Ergol 25(2):115-130, PMID 9735592 —
#   20 men: deviated wrist postures, forearm postures and pinch type together
#   cut peak pinch strength by as much as 33% (not a wrist-only figure).
# - Imrhan SN 1991, Appl Ergon 22(6):379-384,
#   doi:10.1016/0003-6870(91)90079-w — 30 men, lateral, chuck and pulp
#   pinches in five wrist positions: every deviated position cut pinch
#   strength (14-43%), palmar flexion the most.
# - Maier MA, Hepp-Reymond MC 1995, Exp Brain Res 103(1):108-122,
#   doi:10.1007/bf00241969 — 6 subjects, thumb-index grip at 0.5-3 N: the
#   adductor and short flexor of the thumb tracked force closely; the long
#   flexor of the thumb showed varying, on average moderate, correlations.
# - Snijders CJ, Volkers AC, Mechelse K, Vleeming A 1987, Med Sci Sports
#   Exerc 19(5):518-523, doi:10.1249/00005768-198710000-00016 — grasping and
#   pinching always create a flexing moment at the wrist, balanced by the
#   wrist and finger extensors (model and EMG).
# - Kozin SH, Porter S, Clark P, Thoder JJ 1999, J Hand Surg Am 24(1):64-72,
#   doi:10.1053/jhsu.1999.jhsu24a0064 — median and ulnar nerve blocks at the
#   wrist (the hand's own small muscles switched off) cut key pinch by 77%
#   (ulnar), 60% (median) and 85% (both), grip by 32-49%.
# - Fox PM, Oliver JD, Nguyen V, Hentz VR, Curtin CM 2019, Orthopedics
#   42(6):e555-e558, doi:10.3928/01477447-20190812-06 — video EMG: the FDP
#   is the workhorse of fist formation; the FDS and intrinsics joined in
#   every tight fist.
# - Exel J, Kaufmann P, Froschauer O, Baca A, Kainz H, Mochizuki L 2026,
#   Eur J Sport Sci 26(6):e70197, doi:10.1002/ejsc.70197 — 11 climbers, dead
#   hang to failure on a 20 mm edge with elbows fully extended and a
#   horizontal gaze; elbow flexion ended the trial; FDS, extensor digitorum,
#   brachioradialis, biceps, trapezius and pectoralis major recorded (the
#   last four called postural muscles); with fatigue, beta coherence rose in
#   the brachioradialis-biceps, trapezius-biceps and trapezius-brachioradialis
#   pairs. No activation amplitudes are reported.
# - StrengthLog (Richter D): Plate Pinch (grip plates in a pinch, hold as
#   long as you can, lower under control; primary forearm flexors; plate
#   design and chalk change the load you can hold); How to Train Your
#   Forearm Flexors and Grip (sample: hang for time and plate pinch, 3 sets
#   x max time; hanging in a rack trains grip endurance); Farmers Walk (look
#   ahead, keep the body in a straight line without leaning excessively
#   forward, brace; primary forearm flexors and trapezius).
# - StrengthLog, The 10 Best Forearm Exercises for Muscle & Strength
#   (Abelsson A, updated 20 May 2024): plate pinch, hold about 20-30 s
#   before adding weight; plates without ridges or handles are harder to
#   grip; watch your toes.
# - StrengthLog, Rack Pull: step up close to the bar, brace, pull the bar
#   close to your body with a straight back until standing straight.
# - ExRx.net, Farmer's Walk (read on web.archive.org, 2024): stand holding
#   the bars with the arms straight down at the sides; strength and
#   endurance "particularly of traps and grip"; static scapula and clavicle
#   elevation, finger flexion, thumb opposition and flexion.
# - ACE Exercise Library, Shrug (barbell): palms-down grip about
#   shoulder-width, knees slightly bent, hips straight, back tall.
# - PureGym, Plate Pinch (practitioner guide, no author or date): fingers on
#   the outside, thumb closest to the body, plate hanging by your side,
#   brace the core and glutes, pinch as hard as you can, lower with control;
#   go heavier once you can hold 30 s.
# - BarBend, Boly J (CSCS), The Benefits of Towel Pull-Ups, Rows, and Much
#   More, published 19 Sep 2018, updated 25 Jul 2023 (an op-ed): towel
#   hangs, "instead of physically lifting yourself - simply grip and hang";
#   2 x 20 s in the sample; uneven holds and single-arm holds with light
#   ground touching are listed as variations.
# - DeadHangs.com, Towel Hang (updated 3 Mar 2026; the model builder's
#   reference; practitioner): hands shoulder-width, arms straight, 10-20 s
#   sets; let the towel take some bodyweight and check it does not slide on
#   the bar before committing full weight; avoid thin hand towels.
#
# Evidence is thin for: every activation level (no EMG study of a plate
# pinch, a dumbbell or barbell static hold or a towel hang; levels are ranked
# from function and the studies above, conservatively), the thumb in the
# pinch (it opposes all four fingers, but most of its force comes from the
# hand's own thumb muscles, adductor pollicis and flexor pollicis brevis;
# Kozin 1999; Maier & Hepp-Reymond 1995; the app cannot name them, so the
# long thumb flexor is kept moderate, below the finger flexors, after Gill
# 2024), the plate and dumbbell drift and the barbell lean-back faults (lever
# mechanics set against ExRx, PureGym, ACE and StrengthLog positions; no
# study measures them), and the towel body swing (pendulum mechanics). The
# wrist fault is the general finding that a flexed wrist weakens grip and
# pinch; no source names it for these holds.

from common_241_300 import *

# ---------------------------------------------------------------- shared cues

WHY_WRIST = ("A wrist curled toward the palm leaves the finger flexors too short to squeeze hard: "
             "in one study a flexed wrist cut maximum grip force by 40-50%.")

SHOULDERS_HOLD = ("Shoulder Position",
                  "The shoulders stay back and level under the load.",
                  "Holding the shoulders set makes the traps and upper back resist the weight pulling down and forward, instead of letting the upper back round.",
                  "Shoulders dragged forward and down, the upper back rounding.",
                  "Draw the shoulders gently back, chest up, and hold them level without shrugging.")

POSTURE_SIDES = ("Posture",
                 "Stand tall with the core and glutes braced.",
                 "A braced, upright trunk keeps the body still and stacked under the load; leaning forward over the weights hands part of the job to the lower back.",
                 "Leaning forward over the weights as the set goes on.",
                 "Brace the abs and glutes, stand tall with the ribs over the hips, and keep that height for the whole set.")


def head_hold(what):
    return ("Head Position",
            "Eyes ahead, chin level.",
            f"Looking ahead keeps the neck and upper back in line with the braced trunk; looking down at the {what} pulls the head and shoulders forward.",
            f"Looking down at the {what}, the head and upper back dropping.",
            "Fix the eyes on a point ahead at head height and keep the chin level while you hold.")


def forearm_glows(name, rx=0.05, ry=0.07):
    """The finger and thumb flexors: the front of each forearm, between the
    elbow and the wrist, the left (right of the frame) at full strength."""
    return [glow(name, ["forearm_L", "hand_L"], A, 0.55, rx, ry),
            glow(name, ["forearm_R", "hand_R"], SOFT, 0.30, rx, ry)]


# ---------------------------------------------------------------- plate pinch hold

ex(name="Plate Pinch Hold", var="platePinchHold",
   # Top: head on the left, shoulders on the right (row 0.16, as the
   # Farmer's Carry). The plates fill v 0.47-0.61, so the pinch pill sits
   # just under them; "Wrists straight" starts at u 0.682, right of the left
   # knee (and, in the shrunk pinch still, of the left calf), and its leader
   # runs almost straight up the plate to the hand. The plate-position pill
   # is on the near (left) elbow, right of the arm at row 0.32, as on the
   # dumbbell hold: its fault turns the model to -1.3, where the right hand
   # is hidden behind the near plate. The posture dot is on the upper
   # abdomen (v 0.324), so its leader runs almost level and crosses the right
   # upper arm well above the elbow; its fault is seen at -1.5, where the dot
   # is on the front of the chest, clear of the ghost's arms.
   overrides={"head": (0.14, "leading"), "shoulders": (0.14, "trailing"), "posture": (0.32, "leading"),
              "sides": (0.32, "trailing"), "pinch": (0.68, "trailing")},
   annotations=[
       ("head", "Eyes ahead, chin level", "head"),
       ("shoulders", "Shoulders back", "attachment_TrapeziusUpper_L"),
       ("posture", "Tall, braced", "support_PectoralisMajor_Abdominal_L"),
       ("pinch", "Wrists straight", "hand_L"),
       ("sides", "Arms long", "forearm_L"),
   ],
   cues={
       "pinch": ("Pinch and Wrists",
                 "Thumb on one face, flat fingers on the other, wrists straight.",
                 "A pinch squeezes the plates between the thumb and the fingers and holds them by friction alone, so the thumb, pushing back against all four fingers at once, carries as much force as the fingers together. A bent wrist weakens the squeeze: in one study every bent wrist position cut pinch strength, and a wrist bent toward the palm cut it the most.",
                 "Letting the wrists bend as the pinch tires.",
                 "Keep the knuckles in line with the forearms, wrists straight or slightly back, and squeeze the plates together as hard as you can for the whole set."),
       "sides": ("Plate Position",
                 "The plates hang still at your sides.",
                 "With the arms hanging long the plates stay under the shoulders, so the thumb and fingers only have to hold them up; plates that drift forward sit in front of the shoulders, which then have to hold them out as well.",
                 "The plates drifting forward in front of the thighs.",
                 "Let the arms hang long at your sides with the elbows soft and keep the plates beside the legs for the whole set."),
       "shoulders": SHOULDERS_HOLD,
       "posture": POSTURE_SIDES,
       "head": head_hold("plates"),
   },
   activation=[("Flexor Digitorum Superficialis", P, MOD, 0.64), ("Flexor Digitorum Profundus", P, MOD, 0.60),
               ("Flexor Pollicis Longus", P, MOD, 0.56), ("Wrist Extensors", S, MOD, 0.42)],
   stabilisers=["upper trapezius", "core"],
   # The plates rest against the outer thighs, so a wrist curling toward the
   # palm would tip their lower edges into the legs: the pinch fault and this
   # comparison say "bent", which Imrhan 1991 covers (every deviated wrist
   # position cut pinch strength), not "curled in".
   comparison=("WRISTS BENT", "Wrists straight, pinch hard", "Wrists bent, pinch weaker",
               "Wrists straight or slightly back leave the thumb and finger flexors long enough to squeeze hard, so the pinch lasts the whole set.",
               "Bending the wrists weakens the pinch, so the plates slip out of the fingers sooner."),
   glows=forearm_glows("Plate Pinch Hold"))

SETUP["Plate Pinch Hold"] = [
    "Stand a pair of equal plates on edge beside each foot, smooth sides out.",
    "Squat and pinch each pair at the top, fingers outside, thumb inside.",
    "Stand tall with the arms long, the plates at your sides.",
    "Pinch for the set time, about 30 seconds, then squat to set them down; keep your toes clear in case they slip.",
]

# ---------------------------------------------------------------- dumbbell static hold

ex(name="Dumbbell Static Hold", var="dumbbellStaticHold",
   # As the plate pinch; the grip pill sits between the dumbbell's lower
   # head (v ~0.54) and the left knee (0.64), short enough to start right of
   # the left thigh (outer edge u ~0.65), so its leader runs almost straight
   # up to the hand. The posture dot is on the upper abdomen, as on the plate
   # pinch (on the chest joint its leader ran through the ghost's right
   # elbow in the posture still).
   overrides={"head": (0.14, "leading"), "shoulders": (0.14, "trailing"), "posture": (0.32, "leading"),
              "sides": (0.32, "trailing"), "grip": (0.62, "trailing")},
   annotations=[
       ("head", "Eyes ahead, chin level", "head"),
       ("shoulders", "Shoulders back", "attachment_TrapeziusUpper_L"),
       ("posture", "Tall, braced", "support_PectoralisMajor_Abdominal_L"),
       ("sides", "Arms long", "forearm_L"),
       ("grip", "Wrists straight", "hand_L"),
   ],
   cues={
       "grip": ("Grip and Wrists",
                "Grip each handle in the middle and squeeze, wrists straight.",
                "The whole weight hangs from the hands, so the finger flexors hold it while the wrist extensors keep the wrist steady. " + WHY_WRIST,
                "The wrists curling in toward the thighs as the grip tires.",
                "Grip the middle of each handle, squeeze hard for the whole set and keep the wrists straight or slightly back, never curled in."),
       "sides": ("Dumbbell Position",
                 "The dumbbells hang still at your sides.",
                 "With the arms hanging straight the dumbbells sit under the shoulders and the hands only have to hold them up; dumbbells that drift forward sit in front of the shoulders, which then have to hold them out as well.",
                 "The dumbbells drifting forward in front of the thighs.",
                 "Let the arms hang straight down, palms facing the thighs, the dumbbells beside the legs for the whole set."),
       "shoulders": SHOULDERS_HOLD,
       "posture": POSTURE_SIDES,
       "head": head_hold("dumbbells"),
   },
   activation=[("Flexor Digitorum Profundus", P, HI, 0.80), ("Flexor Digitorum Superficialis", P, HI, 0.72),
               ("Upper Trapezius", S, MOD, 0.42), ("Wrist Extensors", S, MOD, 0.40)],
   stabilisers=["levator scapulae", "erector spinae", "core"],
   comparison=("WRISTS CURLED IN", "Wrists straight, grip hard", "Wrists curl toward the thighs",
               "Wrists straight or slightly back leave the finger flexors long enough to squeeze hard, so the grip lasts the whole set.",
               "Curling the wrists shortens the finger flexors and weakens the grip, so the dumbbells slip sooner."),
   glows=forearm_glows("Dumbbell Static Hold"))

SETUP["Dumbbell Static Hold"] = [
    "Stand between two heavy dumbbells, feet hip-width apart.",
    "Squat down with a flat back and grip each handle in the middle.",
    "Stand tall, arms straight at your sides, palms facing in.",
    "Hold for the set time, about 30 seconds with a weight that is hard to hold by the end, then squat to set them down.",
]

# ---------------------------------------------------------------- barbell static hold

ex(name="Barbell Static Hold", var="barbellStaticHold",
   # Framed smaller (zoom 0.668), the bar's plates at v 0.41-0.57 on both
   # sides: head and shoulders above the figure, the grip and bar pills
   # under the plates, clear of the knees. The posture dot is on the upper
   # abdomen (the spine joint sat at the waistband beside the left wrist dot)
   # and stays in view above the near plate when the posture fault turns the
   # model to -1.4.
   overrides={"head": (0.14, "leading"), "shoulders": (0.14, "trailing"), "posture": (0.32, "leading"),
              "grip": (0.68, "leading"), "bar": (0.68, "trailing")},
   annotations=[
       ("head", "Eyes ahead, chin level", "head"),
       ("shoulders", "Shoulders back", "attachment_TrapeziusUpper_L"),
       ("posture", "No leaning back", "support_PectoralisMajor_Abdominal_L"),
       ("grip", "Wrists straight", "hand_R"),
       ("bar", "Bar near the thighs", "hand_L"),
   ],
   cues={
       "grip": ("Grip and Wrists",
                "Overhand, hands just outside the thighs, wrists straight.",
                "The bar hangs from the fingers, so the finger flexors hold it while the wrist extensors keep the wrist steady; with the palms facing back they work harder than with the palms facing in. " + WHY_WRIST,
                "The wrists curling in toward the thighs as the grip tires.",
                "Hold the bar overhand with the thumbs wrapped round it, squeeze hard for the whole set and keep the wrists straight or slightly back, never curled in."),
       "bar": ("Bar Position",
               "The bar hangs just in front of the thighs.",
               "With the elbows straight and the bar close to the thighs, the load hangs near the body; a bar that drifts forward sits further in front of the shoulders, which then have to work harder to hold it out.",
               "The bar drifting forward, away from the thighs.",
               "Keep the elbows straight and the bar close in front of the thighs, not resting on them, for the whole set."),
       "posture": ("Posture",
                   "Knees soft, hips straight, back tall.",
                   "Leaning back with the hips pushed forward arches the lower back and lets the bar rest on the thighs, which can take some of the weight off the grip. Standing tall with the hips straight keeps the whole load in the hands.",
                   "Leaning back and pushing the hips forward to rest the bar on the thighs.",
                   "Keep the knees slightly bent, the hips straight and the ribs stacked over the hips, the bar hanging just clear of the thighs."),
       "shoulders": SHOULDERS_HOLD,
       "head": head_hold("bar"),
   },
   activation=[("Flexor Digitorum Profundus", P, HI, 0.80), ("Flexor Digitorum Superficialis", P, HI, 0.72),
               ("Wrist Extensors", S, MOD, 0.48), ("Upper Trapezius", S, MOD, 0.42)],
   stabilisers=["levator scapulae", "erector spinae", "core"],
   comparison=("LEANING BACK ON THE BAR", "Tall, bar hanging free", "Hips forward, bar on the thighs",
               "Standing tall with the hips straight and the bar hanging just clear of the thighs leaves the whole weight to the grip.",
               "Leaning back arches the lower back and rests the bar on the thighs, which can take some of the weight off the grip."),
   glows=forearm_glows("Barbell Static Hold", rx=0.04, ry=0.06))

SETUP["Barbell Static Hold"] = [
    "Set the bar in a rack just above knee height.",
    "Grip it overhand, hands about shoulder-width, just outside the thighs.",
    "Stand up with it: knees soft, hips straight, back tall.",
    "Hold for the set time, about 30 seconds with a weight that is hard to hold by the end, then set it back in the rack.",
]

# ---------------------------------------------------------------- towel grip hold

ex(name="Towel Grip Hold", var="towelGripHold",
   # Re-framed (zoom 0.75, offset [-0.023, -0.04, 0.013]) so the fists sit
   # below the COMMON MISTAKE banner in the fault stills: the wrists are at
   # v 0.20-0.21, the feet at 0.75. The grip pill is short so it ends left of
   # the right hand; its leader reaches the wrist past the outer edge of the
   # right fist (a pill level with the wrist ends 2-6 px from the fist, and a
   # lower one crosses the red forearm and crowds the head pill). The arms
   # pill sits right of the left elbow; the body pill at row 0.64, short
   # enough to end left of the right thigh (and of the swing ghost's knees);
   # the legs pill at row 0.48 right of the trunk, so in the lifted fault
   # view it stays above the feet it points to (at 0.64 it covered them).
   overrides={"grip": (0.14, "leading"), "head": (0.32, "leading"), "arms": (0.32, "trailing"),
              "body": (0.68, "leading"), "legs": (0.50, "trailing")},
   annotations=[
       ("grip", "Wrists straight", "hand_R"),
       ("head", "Eyes ahead", "head"),
       ("arms", "Arms long", "forearm_L"),
       ("body", "Hang still", "pelvis"),
       ("legs", "Feet clear", "foot_L"),
   ],
   cues={
       "grip": ("Grip and Wrists",
                "Wrap each hand round both ends of its towel and squeeze.",
                "A towel is thicker and less steady than a bar, so the finger flexors must squeeze harder and the forearm extensors work to hold the wrist steady. " + WHY_WRIST,
                "Letting the wrists bend forward over the towels instead of holding them straight.",
                "Grip both ends of each towel with the whole hand, thumb wrapped round, squeeze hard and keep the wrists straight or slightly back."),
       "arms": ("Arm Position",
                "Hang from long arms; the hands hold, the arms do not pull.",
                "The towel hang trains the grip, so the set should end when the grip gives out. Bending the elbows turns it into a half pull-up that the arm and back muscles must hold as well, and they can tire before the grip does.",
                "Bending the elbows and pulling the body up toward the bar.",
                "Keep the elbows almost straight and let the body hang below the towels for the whole set."),
       "legs": ("Legs",
                "Knees bent, feet clear of the floor.",
                "The towels hang the grip too low to hang with straight legs, so the knees bend to lift the feet. Any weight the toes take from the floor is weight the hands no longer hold, so touch down only if you mean to make the hold easier.",
                "Letting the toes rest on the floor behind you.",
                "Bend the knees until the feet are clear of the floor and keep them up behind you for the whole set."),
       "body": ("Body Control",
                "Hang still under the towels.",
                "Swinging adds to the pull on the hands at the bottom of each swing, so the grip has to hold jolts on top of the body weight and can let go sooner.",
                "Swinging forward and back under the towels.",
                "Brace the trunk, keep the hips and knees still and let the body settle before you start the clock."),
       "head": ("Head Position",
                "Head level between the arms, eyes ahead.",
                "A level gaze holds the neck in line with the trunk for the whole hang; craning up at the bar pushes the chin forward and bends the neck back.",
                "Craning the chin up and forward to look at the bar.",
                "Look straight ahead with the head between the arms and the chin level."),
   },
   activation=[("Flexor Digitorum Profundus", P, HI, 0.84), ("Flexor Digitorum Superficialis", P, HI, 0.76),
               ("Wrist Extensors", S, MOD, 0.48), ("Flexor Pollicis Longus", S, MOD, 0.44)],
   stabilisers=["brachioradialis", "biceps brachii", "trapezius", "pectoralis major"],
   comparison=("HALF PULL-UP", "Long arms, the grip holds", "Elbows bent, body pulled up",
               "With long arms the hold lasts until the grip gives out, which is what the exercise trains.",
               "Pulling up bends the elbows, so the arms and back must hold the body up too and can give out before the grip does."),
   glows=forearm_glows("Towel Grip Hold", rx=0.04, ry=0.06))

SETUP["Towel Grip Hold"] = [
    "Hang a sturdy towel over the bar on each side, a little wider than your shoulders.",
    "Grip both ends of each towel in one hand, hands level, and let them take some weight to check they do not slide.",
    "Bend the knees to lift the feet and hang with the arms long.",
    "Hold for the set time, about 20 seconds to start, then put the feet down.",
]

NAMES = ["Plate Pinch Hold", "Dumbbell Static Hold", "Barbell Static Hold", "Towel Grip Hold"]

if __name__ == "__main__":
    probs = validate(["Plate Pinch Hold", "Dumbbell Static Hold", "Barbell Static Hold", "Towel Grip Hold"]); print("\n".join(probs) or "OK")
