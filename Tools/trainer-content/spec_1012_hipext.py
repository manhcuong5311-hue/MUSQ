# Trainer content for the Desktop "300-400" folder (2026-10-12), family:
# hipext. Five new exercises from the builder's 383-390: 383 Cable
# Pull-Through (Legs/CablePullThrough), 387 Standing Cable Hip Extension
# (Legs/StandingCableHipExtension), 388 Reverse Hyperextension
# (Legs/ReverseHyperextension), 389 Single-Leg Back Extension
# (Legs/SingleLegBackExtension) and 390 45-Degree Hip Extension
# (Legs/HipExtension45). Same format as spec.py on top of common_1_50.py;
# spec_1012.py imports this module and gen.py reads SPEC / SETUP.
# notes_1012_hipext.md maps every claim in the copy to the sources below or
# to a model measurement.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# ($LAB/r1012/hipext/ in the session scratchpad: dump.py writes every
# joint's world position and a few bone axes every frame, an.py / m1-m9.py
# measure angles, phases.py finds the still and moving stretches, eq.py /
# near.py / stack.py / eqproj.py read the equipment, skin.py skins the body
# meshes for contacts, be_pad.py measures the bench pad against the hips,
# ghost.py ports FaultGhost.solve), the briefs in briefs_1012/, tiers.txt,
# joints.json and the trainer stills. The app's frame: Y up, the lifter
# faces +z, their left is +x. One body: neck to pelvis 0.592 m, hip joints
# 0.18 m apart, shoulder joints 0.39 m apart. Every clip is 7.96 s at 24 fps
# with two identical 4 s reps. Angles: knee = thigh-shin inner angle (180
# straight); hip = the thigh against the pelvis-neck line in the body's own
# side view (0 in line, + flexed); trunk = pelvis-neck line from vertical.
# - Cable Pull-Through (yaw -1.3, from the lifter's left, a little behind;
#   facing screen-left). Back to a cable column, a rope on the low pulley
#   (axle 0.20 m up, 0.96 m behind the ankles, on the midline), the cable
#   running forward between the legs; the rope ends held in front of the
#   hips with the palms facing each other. Ankles 0.40 m apart (shoulder
#   joints 0.39), toes out ~12 deg. Standing: trunk 0-3 deg, knees 164 deg,
#   shins 5 deg forward, hips ~11 deg short of the trunk line (the thighs 11
#   deg forward of vertical with soft knees). Bottom: trunk 75 deg forward
#   (15 deg above level), hips flexed 100 deg, knees 155 deg, shins
#   vertical; the pelvis 14 cm back and 3 cm down. The spine keeps one shape
#   (pelvis-spine-chest 171, spine-chest-neck 174, chest-neck-head 176 deg
#   all clip): all the bend is at the hips. Elbows 156 deg standing, 142 at
#   the bottom; the hands from 4 cm above hip height in front of the hips
#   to between the thighs ~17 cm above the knees. Timing: standing to 0.17
#   s, down 0.17-1.58 s, held 1.58-2.04 s, up 2.04-3.17 s, standing to 4.17
#   s. The pinned plates rise 19 cm between the bottom and the top and stay
#   3.3 cm above the rest of the stack even at the bottom.
# - Standing Cable Hip Extension (yaw -1.8, from behind the lifter's left;
#   facing screen-left). Facing a cable column, both hands holding its
#   upright at about waist height (hand meshes 1.04-1.14 m up: mid rectus
#   abdominis, 6-17 cm under the lowest point of the pectorals; palms facing
#   each other, elbows 117 deg). An
#   ankle cuff just above the LEFT ankle, clipped to the low pulley (0.20 m
#   up, ~0.35 m in front of the hips). The right leg stands almost straight
#   (knee 175 deg); the trunk leans 9 deg forward and the pelvis never
#   moves. The left thigh swings from 18 deg in front of vertical (knee 160,
#   the foot ~2-3 cm off the floor in front) to 28 deg behind it (knee 174),
#   the knee bending to 149 deg as the foot passes under the body: forward
#   rest to 0.33 s, back 0.33-1.67 s, held 1.67-2.17 s, forward 2.17-3.67 s,
#   rest to 4.33 s. The hip goes from 27 deg flexed to 19 deg extended
#   against the trunk line (a 46 deg arc).
# - Reverse Hyperextension (yaw -1.4, side-on from the left; head on the
#   left). A plate-loaded reverse hyper: lying face down, the chest on a
#   short pad (0.94 m up, ending 18 cm before the hip joints, about the
#   upper belly; the belly hovers ~3 cm above its end and the hips are well
#   past it), hands on the front grips with straight arms (elbows 167),
#   both lower legs in a strap on the pendulum 6-11 cm above the ankles,
#   plates on the pendulum's horns. Trunk level and still, spine still.
#   Both legs together, knees 176 deg all clip, from hanging (thighs 4 deg
#   toward the head of straight down, hip flexed 94 deg) to 3 deg above
#   level (hip 3 deg past the trunk line): a 97 deg arc. Hanging to 0.29 s,
#   up 0.29-1.71 s, held 1.71-2.12 s, down 2.12-3.71 s, hanging to 4.29 s.
# - 45-Degree Hip Extension (yaw -1.9, from behind the lifter's left; head
#   on the left). A 45-degree back extension bench: thighs on the two hip
#   pads, whose top edge sits 9 cm below the hip joints along the body (the
#   pad carries the thighs from 9 to 39 cm below them); feet flat on the
#   plate, 18 cm apart, the ankle roller behind the lower calves 6 cm above
#   the ankle joints; knees 178 deg; arms crossed on the chest (elbows
#   79-90 deg). From a straight line (trunk 45 deg above level, hip 0) the
#   whole trunk turns about the hips with the spine's shape unchanged (every
#   spine segment and the pelvis bone turn the same 65 deg): a hip hinge to
#   20 deg below level, hips flexed 65 deg. Top to 0.29 s, down 0.29-1.71 s,
#   held 1.71-2.12 s, up 2.12-3.71 s, top to 4.29 s.
# - Single-Leg Back Extension (yaw -1.9): the same bench, motion and timing
#   on the LEFT leg: the left foot on the plate under the roller, the right
#   thigh on the pad with the knee bent 115 deg and the right foot lifted
#   behind, its ankle ~22 cm above the roller's top, all clip. Arms crossed.
#   Deeper: to 27 deg below level, hips flexed 72 deg.
# - Paint (tiers.txt): the three glutes bright on all five; the hamstrings
#   (biceps femoris, semitendinosus, semimembranosus) and erector spinae dim
#   on the pull-through, reverse hyper and 45-degree; on the standing cable
#   hip extension the hamstrings and erector spinae only faint; on the
#   single-leg back extension the hamstrings bright with the glutes and the
#   erector spinae dim.
#
# How they differ from the library: the Back Extension is the lower-back
# version (the pad at the hip bones, the spine curling over its edge); the
# two bench lifts here keep the back still and fold at the hips over a pad
# set below the hip crease. The Cable Romanian Deadlift faces the column and
# lifts a bar in front; the pull-through faces away, the rope between the
# legs. The Cable Glute Kickback and Cable Knee-Drive Kickback hinge forward
# or drive the knee up first; this hip extension stands nearly upright.
#
# Sources (each opened 2026-10-12; notes_1012_hipext.md maps the claims):
# - Dicus JR, Ellestad SH, Sheaffer JE, Weber CA, Novak NC, Holmstrup ME
#   2023, Int J Exerc Sci 16(4):12-22, doi 10.70252/zaoj6139, PMID 37113509
#   (PMC10124728, full text): 12 college men who had taken a course in safe
#   resistance-training technique (not described as trained lifters), 5
#   reps at 50% of a 1RM predicted from a 3-5RM, 2-0-2 tempo (2 s down, 2 s
#   up, 60 bpm metronome); Romanian deadlift (barbell), reverse
#   hyperextension (plate-loaded pendulum machine) and cable pull-through
#   (selectorised cable). %MVIC (break tests per muscle, mean +/- SEM),
#   total CP / RDL / RH: longissimus 45.7 / 56.7 / 66.6, multifidus 47.1 /
#   61.2 / 72.8, gluteus maximus 28.6 / 29.6 / 49.1, biceps femoris 21.4 /
#   34.5 / 62.4, semitendinosus 24.4 / 31.2 / 49.4. CP below the RDL in LT,
#   MF, BF and ST (p .001-.005), not in GM; RH above the RDL in GM (p .044),
#   BF (.002) and ST (.017), not in LT or MF; RH eccentric GM 36.3, BF 55.6.
# - Andersen V, Pedersen H, Fimland MS, Shaw M, Solstad TEJ, Stien N,
#   Cumming KT, Saeterbakken AH 2021, J Sports Sci Med 20(2):181-187, doi
#   10.52082/jssm.2021.181, PMID 33948095 (PMC8057707): 15 trained women,
#   6RM; a 45-degree Roman chair back extension with the back kept straight
#   (weighted vest and plates at the chest, hip angle ~90 deg range) vs the
#   Romanian deadlift and a seated machine: biceps femoris +71% over the
#   RDL for the whole movement, +124% in the upper half; gluteus maximus not
#   different over the whole movement (ES 0.62), +74% in the upper half;
#   erector spinae no different among the three.
# - Schellenberg F, Schmid N, Haeberle R, Hoerterer N, Taylor WR, Lorenzetti S
#   2017, BMC Sports Sci Med Rehabil 9:10, doi 10.1186/s13102-017-0074-0,
#   PMID 28451436 (PMC5404334, full text): 16 adults (8 men, 8 women) with
#   strength-training experience, unloaded back extensions on
#   a 45-degree bench with the hip joint centre just above the bench edge,
#   hip-led (spine held neutral, the bottom "right before your spine starts
#   to bend", the top when the upper body is in line with the legs) vs
#   spine-led, two legs and one leg. Hip-led: larger maximal back and hip
#   moments; one leg vs two: peak hip moment 1.1 vs 0.8 Nm/kg, gluteus
#   maximus concentric 22.7 vs 16.5 %MVC (eccentric 17.4 vs 12.7), gluteus
#   medius 13.5 vs 9.3, lumbar erectors 22.8 vs 18.9; the heels set on the
#   platform and the knees straight.
# - Stevens BM, Nichols BR, Doty HI, Korak JA 2022, Int J Exerc Sci
#   15(1):1179-1189, doi 10.70252/dwmb8342, PMID 35989703 (PMC9362892, full
#   text): 15 trained women, 3 reps at 75% of an estimated 1RM; the
#   45-degree hip extension and the cable kickback drew more mean gluteus
#   maximus activity than the Nordic and the leg curl, and more mean biceps
#   femoris activity at the middle and distal sites than the RDL and the
#   step-up. No set-up details are given for either.
# - Oh JS, Cynn HS, Won JH, Kwon OY, Yi CH 2007, J Orthop Sports Phys Ther
#   37(6):320-324, doi 10.2519/jospt.2007.2435, PMID 17612358: prone hip
#   extension, 20 adults; with an abdominal drawing-in manoeuvre the
#   anterior pelvic tilt fell from 10 to 3 deg, the erector spinae from 49
#   to 17 %MVIC, while the gluteus maximus rose from 24 to 52 and the medial
#   hamstrings from 47 to 58 %MVIC.
# - Liu J, Teng HL, Selkowitz DM, Asavasopon S, Powers CM 2022, Physiother
#   Theory Pract 38(13):2650-2657, doi 10.1080/09593985.2021.1975338, PMID
#   34496710: maximal isometric hip extension in four hip and knee positions;
#   the hamstrings' torque share highest with the knee fully extended.
# - ExRx.net via the Wayback Machine: Cable Standing Hip Extension
#   (GluteusMaximus/CBStandingHipExtension, snapshot 2025-04-20): ankle cuff
#   on a low pulley, both hands on a bar, the attached leg straight and the
#   foot slightly off the floor, pull back by extending the hip; target
#   gluteus maximus, synergist hamstrings, stabilisers erector spinae,
#   obliques, quadratus lumborum, gluteus medius and minimus. Lever Reverse
#   Hyper-extension (GluteusMaximus/LVReverseHyperextension, 2025-10-25):
#   the strap above the ankles, torso and waist on the bench, grasp the
#   handles, legs hanging straight down; raise by extending the hips as
#   high as possible with the legs nearly straight; some lifters also move
#   through the lower back, which makes the erector spinae a synergist;
#   target gluteus maximus, synergist hamstrings, stabiliser erector spinae,
#   antagonist stabilisers rectus abdominis and obliques. 45 deg
#   Hyperextension, hands behind hips (Hamstrings/BW45HyperextensionHips,
#   2026-06-24): thighs prone on the padding, heels hooked under the brace;
#   the pad high enough to spread the weight along the thighs but not so
#   high that it limits the range, the abdomen not pressing on its top when
#   lowered; arm position sets the difficulty (low easier, on the chest
#   harder). Single Leg 45 deg Hyperextension (BWSingleLeg45Hyperextension,
#   2026-01-08): one heel under the brace, the other leg just above it;
#   easier with both legs. Both list the hamstrings as target, the erector
#   spinae, gluteus maximus and adductor magnus as synergists.
# - StrengthLog (strengthlog.com, read 2026-10-12): Cable Pull-Through
#   (rope on the low pulley, back to it, the cable between the thighs, a few
#   steps forward, hinge at the hips letting the rope travel back between
#   the thighs, extend the hips to stand; with the resistance from behind
#   there is no rest at the top; primary glutes, secondary lower back,
#   hamstrings, adductors). Reverse Hyperextension (hips at the edge of the
#   pad, hold the handles, legs straight, back neutral and core braced,
#   raise until in line with the body or slightly above, squeeze and hold
#   briefly, lower slowly). Back Extension (the top pad against the top of
#   the thighs so it does not limit leaning forward, arms crossed, up to a
#   straight line, hold about a second, lower slowly). Cable Glute Kickback
#   (brace and keep the body still, press the leg back and up, as far up as
#   you can without rotating in the hips).
# - Dewar M, BarBend, Learn the Cable Pull-Through (updated 27 Nov 2024):
#   stand far enough out that there is no slack; arms straight so the cable
#   does not rub the groin, do not pull with the arms; knees slightly
#   unlocked, hips pulled back, back flat, shoulders back and down; pause
#   briefly at the furthest point of the hinge; squeeze as you rise and end
#   where you started; widen the stance if the thighs crowd the rope.
# - McLean S (CPT), Garage Gym Reviews, Pull-Through Exercise (updated 20
#   Sep 2023): rope on the lowest setting, face away, step forward until the
#   stack separates; A. Bacon: not stepping forward enough is the biggest
#   mistake; feet wide enough to pull the rope through; flex from the hips,
#   not the knees (leading with the knees makes it a squat); neutral spine;
#   squeeze the glutes at lockout.
# - Everett G, Catalyst Athletics, Reverse Hyper (exercise 529, snapshot
#   2025-12-07): the trunk supported, legs hanging, abs and glutes tight to
#   prevent excessive lumbar hyperextension; this coach lets the legs swing
#   under and uses the rebound (the model does not).
# No EMG study of the standing cable hip extension or the single-leg back
# extension by name was found; their rows are ranked from the closest
# studied lifts and the library (see the notes).

from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_1012.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


CPT, SCHE, RH = "Cable Pull-Through", "Standing Cable Hip Extension", "Reverse Hyperextension"
SLBE, HE45 = "Single-Leg Back Extension", "45-Degree Hip Extension"

# ---------------------------------------------------------------- shared bench cues

BENCH_TOP = ("Top Position",
             "Each rep ends with the body in one straight line, the trunk back in line with the legs.",
             "The rep is complete once the trunk lines up with the legs, where a lab study of this lift set the top. Lifting further mostly arches the lower back, so the extra height comes from the spine rather than the hips.",
             "Arching up past the straight line at the top, the chest lifting and the lower back bending backward.",
             "Rise until your body is straight, squeeze the glutes, hold for a moment and lower again.")

BENCH_PAD = ("Pad Height",
             "The pad carries the upper thighs, its top edge a little below the hip crease.",
             "With the hips clear of the pad they can fold over its edge, so the bend comes at the hips. Set too high, the pad presses into the belly and blocks the fold, and the back curls over it instead. Here its top edge sits about 9 cm below the hip joints.",
             "Setting the pad up at the hip bones or the belly, so the hips cannot fold and the back curls over the pad.",
             "Adjust the pad so its top edge sits just below your hip crease, your thighs resting along it.")

BENCH_ARMS = ("Arm Position",
              "The arms stay crossed on the chest for the whole set.",
              "The higher the arms sit on the body, the harder each rep: hands low by the hips make it easiest, crossed on the chest harder, at the head harder still. Kept still, they leave the lifting to the hips; flung forward, they throw the trunk up with momentum.",
              "Uncrossing the arms and flinging them forward to throw the body up.",
              "Cross your arms over your chest and keep them still from the first rep to the last; move them up only once the reps get easy.")


def bench_hinge(extra, depth):
    return ("Hip Hinge",
            f"The trunk folds forward at the hips while the back keeps its shape, from a straight line to about {depth} degrees below level.",
            "Bending at the hips with a still spine puts the work on the hip extensors: in a lab study on a 45-degree bench, the hip-led version loaded the hips and lower back more than curling down through the spine. " + extra,
            "Rounding the back over the pad at the bottom to go lower, the head dropping toward the floor.",
            "Fold at the hips with your chest open and your head in line, and stop just before the back would start to round.")


def bench_glows(name, hams=A, hams_opacity=0.45):
    """The glutes over the hips (dx toward the lifter's back), the
    hamstrings along the thighs, the lower back soft."""
    return [glow(name, ["pelvis", "thigh_L", "thigh_R"], A, 0.55, rx=0.08, ry=0.05, dx=0.03, dy=-0.01),
            glow(name, ["thigh_L", "patella_L"], hams, hams_opacity, rx=0.07, ry=0.04, dx=0.01, dy=0.01),
            glow(name, ["spine"], SOFT, 0.25, rx=0.05, ry=0.04, dy=-0.01)]


# ---------------------------------------------------------------- cable pull-through

# From the lifter's left, a little behind, facing screen-left: the head
# sweeps from the top centre (0.61, 0.18) to the left (0.26, 0.39), the
# hands and rope run between the thighs (u 0.39-0.66, v 0.43-0.63), the
# cable from there back to the low pulley at the lower right, and the
# column fills the right edge (u > 0.86, static). The hip and back labels
# are short, on the right of the top two rows over the column, their
# leaders falling onto the back; the lockout label top left, clear of the
# head at the top and pointing at the head (to the chest, lab round 1's
# leader cut across the chin while standing), short enough to end at u
# 0.41 (review: the longer Stand tall, squeeze glutes ended at 0.48, where
# its own mistake view's leaning ghost put the neck on the pill's end); the
# arms label left on the third row, short so it ends
# before the hands; the set-up label bottom right, short so it starts past
# the near heel, under the moving cable.
ex(name=CPT, var="cablePullThrough",
   overrides={"top": (ov(0.16), "leading"), "hinge": (ov(0.16), "trailing"), "back": (ov(0.32), "trailing"),
              "arms": (ov(0.48), "leading"), "stance": (ov(0.80), "trailing")},
   annotations=[
       ("hinge", "Hips back", "pelvis"),
       ("back", "Back flat", "spine"),
       ("top", "Stand tall at the top", "head"),
       ("arms", "Arms stay long", "hand_L"),
       ("stance", "Cable tight", "foot_L"),
   ],
   cues={
       "hinge": ("Hip Hinge",
                 "The hips push back and the chest tips forward while the rope travels back between the thighs.",
                 "The pull-through is a hip hinge: the bend comes at the hips, which stretches the glutes and hamstrings against the cable. Here the trunk tips about 75 degrees forward while the knees go only from about 16 to 25 degrees of bend and the shins stay upright. Leading with the knees instead turns the rep into a squat.",
                 "Bending the knees and sinking the hips straight down as the rope goes back, so the rep becomes a squat.",
                 "Push the hips straight back with soft knees until you feel the hamstrings stretch, pause briefly, then drive the hips forward to stand."),
       "back": ("Back Position",
                "The back stays flat from the hips to the head, the shoulders set back and down.",
                "A flat back keeps the bending at the hips, so the glutes and hamstrings move the load while the back only holds its shape. In a study of three hinges at half of each lift's estimated maximum, the pull-through worked the lower-back muscles less than a Romanian deadlift did.",
                "Rounding the back at the bottom to reach the hands further back between the legs.",
                "Brace before each rep, keep the chest open and the shoulders pulled back and down, and hinge only as far as the back stays flat."),
       "top": ("Lockout",
               "Each rep ends standing tall, the trunk upright and the glutes squeezed.",
               "Stopping short of standing leaves out the end of the hip's range, where the glutes are at their shortest. Because the cable pulls from behind, the hips are still loaded at the top, where a free weight would hang straight under the shoulders; here the stand between reps lasts about a second.",
               "Stopping each rep with the trunk still tipped forward, the hips never coming all the way through.",
               "Drive the hips forward until you stand straight with the knees still soft, squeeze the glutes for a moment, then start the next rep."),
       "arms": ("Arm Position",
                "The arms stay long and only hold the rope; the hips move it.",
                "The arms just connect the rope to the body, so the glutes and hamstrings should do the pulling. Nearly straight arms also let the rope run back between the legs without rubbing. Here the elbows stay close to straight all rep, about 156 degrees standing and 142 at the bottom.",
                "Bending the elbows to row the rope up toward the stomach as you stand, the arms finishing the rep.",
                "Hold the rope ends with the palms facing each other and the elbows almost straight, and let the hips, not the arms, bring the rope forward."),
       "stance": ("Set-Up",
                  "Stand facing away from a low pulley, feet about shoulder-width, far enough out that the stack stays lifted.",
                  "Walking out until the stack lifts keeps the load on for the whole rep; one coach calls not stepping far enough forward the biggest set-up mistake. Here the lifter stands about a metre in front of the pulley, so even at the bottom of the hinge the lifted plates stay about 3 cm above the rest of the stack. The feet need room for the rope to pass between them.",
                  "Standing so close to the pulley that the weight settles back onto the stack at the bottom of each hinge.",
                  "Hold the rope between your legs, walk forward until the stack lifts, and set your feet about shoulder-width with the toes turned out a little."),
   },
   # Painted: the glutes bright, the hamstrings and erector spinae dim. The
   # one study of this lift (Dicus 2023, 50% of an estimated 1RM, %MVIC from
   # break tests per muscle, so the numbers rank exercises, not muscles):
   # gluteus maximus no different from the barbell RDL (28.6 vs 29.6 total,
   # concentric 39.5 vs 44.3), so 0.70, at the library's RDL 0.72 and
   # Dumbbell RDL 0.70; biceps femoris 38% and semitendinosus 22% under the
   # RDL, so 0.60 against the RDL's 0.88; longissimus and multifidus about a
   # fifth under the RDL, so 0.34 against its 0.42. Fractions scaled from the
   # library are judgement calls. StrengthLog lists the adductors as
   # secondary (not painted) and the rope works the grip (Garage Gym
   # Reviews): stabilisers, with the gluteus medius as the glute-group
   # convention names it.
   activation=[("Gluteus Maximus", P, HI, 0.70), ("Hamstrings", S, MOD, 0.60),
               ("Erector Spinae", S, LOW, 0.34)],
   stabilisers=["adductors", "gluteus medius", "core", "forearms"],
   comparison=("SQUATTING THE ROPE", "Hips back, shins upright", "Knees bend, hips sink",
               "Pushing the hips back on soft knees keeps the rep a hinge, so the glutes and hamstrings stretch against the cable and drive you back up.",
               "Bending the knees and sinking straight down turns the rep into a squat: the hips barely travel back and the glutes and hamstrings lose their stretch."),
   # The glutes behind the hip joints (the lifter faces screen-left, so
   # behind is to the right), the hamstrings soft down the backs of the
   # thighs, the lower back soft.
   glows=[glow(CPT, ["pelvis", "thigh_L", "thigh_R"], A, 0.55, rx=0.07, ry=0.05, dx=0.025, dy=-0.025),
          glow(CPT, ["pelvis", "patella_L"], SOFT, 0.30, rx=0.05, ry=0.08, dx=0.035),
          glow(CPT, ["spine"], SOFT, 0.22, rx=0.05, ry=0.04, dx=0.015, dy=-0.01)])

SETUP[CPT] = [
    "Attach a rope to a low pulley and stand facing away from the stack.",
    "Reach down and take the rope ends between your legs, palms facing each other.",
    "Walk forward until the weight lifts off the stack, then set your feet about shoulder-width, toes turned out a little.",
    "Stand tall with your arms long and your knees soft, and brace before the first rep.",
]

# ---------------------------------------------------------------- standing cable hip extension

# From behind the lifter's left, facing screen-left toward the column (u
# 0.02-0.25, static, with the moving cable along its foot, v 0.76-0.80).
# The right half above the hips is empty and the working leg sweeps the
# lower half from u 0.36 (forward) to 0.79 (back). The grip label sits top
# left over the column, pointing down to the near hand; the trunk, hip,
# kick and knee labels stack on the right (0.16, 0.30, 0.40, 0.49), each
# short enough to start past the back and the glutes (leaders from the
# right are clean at the back of the kick, the cue's moment; with the foot
# forward they cross the standing leg). In the
# mistake view (1.9 s) the shrunk, lifted model's back foot fills the right
# at v 0.65-0.73 and the knee ghost's curled foot v 0.53-0.62, so the knee
# label sits above both at 0.49 and the kick label above it at 0.40 (lab
# round 2's knee label at 0.64 met the ghost's toes, round 3's at 0.67 sat
# on the model's shoe).
ex(name=SCHE, var="standingCableHipExtension",
   overrides={"grip": (ov(0.16), "leading"), "torso": (ov(0.16), "trailing"), "hips": (ov(0.30), "trailing"),
              "kick": (ov(0.40), "trailing"), "knee": (ov(0.49), "trailing")},
   annotations=[
       ("kick", "Drive the leg back", "patella_L"),
       ("torso", "Trunk still, slight lean", "chest"),
       ("hips", "Hips square", "pelvis"),
       ("knee", "Leg long", "shin_L"),
       ("grip", "Hold the upright", "hand_L"),
   ],
   cues={
       "kick": ("Hip Extension",
                "The left leg swings back from the hip, from about 18 degrees in front of vertical to about 28 behind it, and pauses there.",
                "Driving the thigh back is hip extension, with the gluteus maximus as the target muscle and the hamstrings helping. The pause at the back holds the glute at its shortest; here the leg stays there for about half a second before it swings forward.",
                "Stopping the kick with the foot under the hips, so the thigh never gets behind the body.",
                "Push the heel back until the thigh is well behind you, hold for a moment, then let the leg swing forward under control."),
       "torso": ("Torso Position",
                 "The trunk keeps a slight forward lean, about 9 degrees, and stays still while the leg moves.",
                 "Keeping the body still keeps the movement at the hip; when the lower back arches, the leg rises higher but the extra range comes from the spine. In a study of face-down leg lifts, drawing the belly in cut the pelvis's forward tip from about 10 degrees to 3 and more than doubled the glute's activity, while the lower-back muscles worked far less.",
                 "Arching the lower back and tipping the pelvis forward to swing the leg higher behind.",
                 "Brace before each rep, keep the ribs down and the chest still, and let the leg stop where the hip stops."),
       "hips": ("Hip Position",
                "Both hip bones keep facing the column as the left leg goes back.",
                "Square hips keep the leg moving straight back, so the glute extends the hip instead of the pelvis turning open to let the leg travel further. One guide's cue for cable kickbacks is to push the leg only as far as it goes without the hips rotating.",
                "Letting the left hip roll open as the leg goes back, the foot drifting out to the side.",
                "Keep both hip bones pointing at the column and move the left leg straight back in line with the hip."),
       "knee": ("Leg Position",
                "The knee softens as the foot passes under you and straightens as the leg reaches back.",
                "Here the knee goes from about 160 degrees at the start to 149 as the foot swings under the body, then to about 174, nearly straight, at the back. Reaching long through the heel keeps the cuff low and far from the hip; bending the knee to flick the heel up lifts the cuff and shortens the cable's leverage on the hip, so the end of the rep gets easier without the hip going further.",
                "Bending the knee at the back of the kick and lifting the heel toward the glutes.",
                "Let the knee soften as the foot passes under you, then reach long through the heel as the thigh goes back."),
       "grip": ("Support",
                "Both hands hold the column's upright at about waist height while you stand tall on the right leg.",
                "Holding on takes balance out of the lift so the left glute can do the work, while the right leg stays almost straight and still under you. The hands only steady you: pulling on the upright twists the body into the kick.",
                "Pulling on the upright to twist the shoulders and trunk round as the leg goes back.",
                "Hold the upright lightly with both hands, elbows bent, stand tall on the right leg and keep the shoulders square to the column."),
   },
   # Painted: the glutes bright, the hamstrings and erector spinae only
   # faint. Gluteus maximus 0.84 as the library's Cable Glute Kickback and
   # Cable Knee-Drive Kickback, the nearest cable hip extensions (ExRx's
   # target muscle; no EMG of this standing version was found, so it is a
   # judgement call). Hamstrings a LOW secondary for the faint paint (the
   # calfstand family's rule), though a cable kickback drew more mean biceps
   # femoris activity than the RDL at two of three sites (Stevens 2022), so
   # 0.36 may understate them; flagged for the owner. The erector spinae,
   # faint and an ExRx stabiliser, joins the stabilisers with ExRx's
   # obliques, quadratus lumborum and gluteus medius (the standing hip).
   activation=[("Gluteus Maximus", P, HI, 0.84), ("Hamstrings", S, LOW, 0.36)],
   stabilisers=["gluteus medius", "erector spinae", "obliques", "quadratus lumborum"],
   comparison=("ARCHING THE BACK", "Leg moves, back stays still", "Lower back arches to lift the leg",
               "With the trunk braced and still, the leg stops where the hip stops, so the glute does the extending.",
               "Arching the lower back lifts the leg higher, but the extra height comes from the spine, not the glute."),
   # The glutes behind the hips (to the right on screen), the faint
   # hamstrings soft down the back of the thigh.
   glows=[glow(SCHE, ["pelvis", "thigh_L", "thigh_R"], A, 0.55, rx=0.07, ry=0.05, dx=0.075, dy=-0.01),
          glow(SCHE, ["thigh_L", "patella_L"], SOFT, 0.22, rx=0.05, ry=0.07, dx=0.07, dy=0.01)])

SETUP[SCHE] = [
    "Fasten an ankle cuff just above your left ankle and clip it to the low pulley.",
    "Face the column and hold its upright with both hands at about waist height.",
    "Step back until the cable is tight, standing tall on your right leg with the left foot just off the floor in front of you.",
    "Lean forward slightly and brace before the first rep.",
]

# ---------------------------------------------------------------- reverse hyperextension

# Side-on from the left, small (zoom 0.501): the machine and lifter fill the
# middle band (u 0.03-0.88, v 0.33-0.70), the head on the left at v 0.39,
# the legs sweeping from hanging (feet at 0.48, 0.59) to level on the right
# (0.83, 0.38), the pendulum's plates rising to v 0.33. The labels sit above
# and below that band: the back label top left with a straight leader down
# to the lower back, the knee label top right; the grip label bottom left,
# short, its leader up through the front frame to the hand, and the range
# and lowering labels bottom right (0.72, just under the base rails, and
# 0.80), to the foot and the knee. In the mistake view the shrunk, lifted
# model puts the pendulum's plates and the lifted feet at v 0.24-0.34 on
# the right, so no label sits there: lab round 1's knee label on the second
# row met its ghost's raised toes, round 2's range label there sat on the
# plates.
ex(name=RH, var="reverseHyperextension",
   overrides={"back": (ov(0.16), "leading"), "knees": (ov(0.16), "trailing"), "lift": (ov(0.72), "trailing"),
              "grip": (ov(0.80), "leading"), "lower": (ov(0.80), "trailing")},
   annotations=[
       ("lift", "Legs up to level", "foot_L"),
       ("back", "Belly braced, back still", "spine"),
       ("knees", "Legs long, knees soft", "patella_L"),
       ("lower", "Lower slowly, no swing", "shin_L"),
       ("grip", "Hold the grips", "hand_L"),
   ],
   cues={
       "lift": ("Range of Motion",
                "The legs rise from hanging straight down until they are level with the body or a little above.",
                "Raising the legs against the strap is hip extension, the glutes' main job, and the rep is complete once the legs reach the line of the body. Here they travel about 97 degrees, from hanging straight down to about 3 degrees above level, and pause there for just under half a second.",
                "Stopping halfway, the legs swinging up only to about 45 degrees below level.",
                "Raise the legs until they line up with your body or a touch higher, squeeze the glutes for a moment, then lower."),
       "back": ("Back Position",
                "The trunk stays still on the pad while the legs move from the hips.",
                "Some lifters also bend through the lower back, which hands part of the lift to the back muscles; guides ask for a braced belly and tight glutes so the lower back does not overarch as the legs come up. In a study of face-down leg lifts, drawing the belly in cut the pelvis's forward tip from about 10 degrees to 3 and more than doubled the glute's activity.",
                "Arching the lower back to fling the legs higher than the body, the belly sagging past the end of the pad.",
                "Brace the belly and squeeze the glutes before each lift, and stop the legs at the line of your body."),
       "knees": ("Leg Position",
                 "The legs stay long, the knees almost straight, and move together as one.",
                 "Straight legs keep the hamstrings pulling alongside the glutes: in maximal hip-extension tests, the hamstrings' share was highest with the knee fully straight. Here the knees hold about 176 degrees all rep.",
                 "Bending the knees as the legs come up, the heels curling toward the glutes.",
                 "Keep the knees soft but long and the feet level with each other, and lift through the heels."),
       "lower": ("Lowering Control",
                 "The legs come back down under control and hang still before the next lift.",
                 "The glutes and hamstrings keep working as they lower the legs: in a study of a pendulum reverse hyper like this one, worked at two seconds up and two seconds down, both stayed active on the way down. Here the lowering takes about 1.6 seconds against 1.4 up, and the legs hang for about half a second. Some coaches let the legs swing under the bench and use the rebound; this version does not.",
                 "Dropping the legs and letting the pendulum swing them forward under the bench to bounce into the next rep.",
                 "Lower the legs under control until they hang straight down, pause, then start the next lift without a swing."),
       "grip": ("Upper Body",
                "The chest stays down on the pad and the hands hold the grips at the front, arms long.",
                "The pad and the grips hold the trunk still, so the hips have a fixed base to lift the legs from. Here the chest rests on the pad, the hips are well past its end so the legs hang free, and the arms stay nearly straight on the grips.",
                "Pushing up on the grips and lifting the chest off the pad as the legs come up.",
                "Lie with your chest on the pad and your hips off its end, hold the grips with long arms, and keep your chest down for every rep."),
   },
   # Painted: the glutes bright, the hamstrings and erector spinae dim. The
   # one study of this machine (Dicus 2023, a plate-loaded pendulum, 50% of
   # an estimated 1RM; the numbers rank exercises, not muscles): gluteus
   # maximus above the barbell RDL (49.1 vs 29.6 %MVIC, p .044), so 0.86
   # against the RDL's 0.72; biceps femoris (62.4 vs 34.5) and
   # semitendinosus (49.4 vs 31.2) both above it, so 0.90 against its 0.88,
   # kept SECONDARY as painted (the Deadlift's 0.85 erector spinae secondary
   # is the house precedent for a secondary above a primary); longissimus and
   # multifidus not different from the RDL (66.6 and 72.8 vs 56.7 and 61.2),
   # so 0.50, in the library RDLs' 0.36-0.52. ExRx's antagonist stabilisers.
   activation=[("Gluteus Maximus", P, HI, 0.86), ("Hamstrings", S, HI, 0.90),
               ("Erector Spinae", S, MOD, 0.50)],
   stabilisers=["rectus abdominis", "obliques"],
   comparison=("ARCHING THE LOWER BACK", "Legs stop at the body's line", "Back arches to throw the legs higher",
               "Stopping the legs at the line of the body with the belly braced keeps the lift at the hips, where the glutes and hamstrings do it.",
               "Arching the lower back sends the legs higher, but the extra height comes from the spine and the back muscles take over part of the lift."),
   # The glutes on top of the hips, the hamstrings soft just behind them
   # (the legs sweep a quarter circle, so no glow follows the thighs), the
   # lower back soft.
   glows=[glow(RH, ["pelvis", "thigh_L", "thigh_R"], A, 0.55, rx=0.05, ry=0.035, dy=-0.012),
          glow(RH, ["pelvis"], SOFT, 0.30, rx=0.04, ry=0.03, dx=0.045, dy=0.01),
          glow(RH, ["spine"], SOFT, 0.25, rx=0.04, ry=0.025, dx=-0.01, dy=-0.008)])

SETUP[RH] = [
    "Fasten the strap around your lower legs, just above the ankles.",
    "Lie face down with your chest on the pad and your hips off its end, legs hanging straight down.",
    "Hold the grips at the front of the machine with your arms long.",
    "Brace your belly and squeeze your glutes before the first lift.",
]

# ---------------------------------------------------------------- the two bench lifts

# Both from behind the lifter's left (yaw -1.9), head on the left: the body
# and bench fill u 0.05-0.97, v 0.27-0.73; the head swings from (0.20, 0.30)
# to (0.15, 0.51). Above v 0.26 and below v 0.74 the frame is empty, so the
# labels sit there: the top-position label top left, one step up at 0.12
# (no button on that side; review: at 0.16 the arched-top ghost's head
# touched the pill's lower edge in its own mistake view), its leader down
# to the neck right of the head; the hinge label top right to the mid-back; the
# pad label on the second row, right, clear of the lifted right shoe (top at
# v 0.43); arms bottom left, up through the bench's front legs to the near
# hand; the free-leg or depth label bottom right, up to the lifted foot or
# the chest (its leader crossing the bench, static).
BENCH_OVERRIDES = {"top": (ov(0.12), "leading"), "hinge": (ov(0.16), "trailing"), "pad": (ov(0.32), "trailing"),
                   "arms": (ov(0.80), "leading")}

ex(name=SLBE, var="singleLegBackExtension",
   overrides=dict(BENCH_OVERRIDES, free=(ov(0.80), "trailing")),
   annotations=[
       ("hinge", "Fold at the hips, back flat", "spine"),
       ("top", "Stop in a straight line", "neck"),
       ("pad", "Pad below the hip crease", "thigh_R"),
       ("free", "Right leg off the plate", "foot_R"),
       ("arms", "Arms crossed on chest", "hand_L"),
   ],
   cues={
       "hinge": bench_hinge("That study set the bottom of each rep just before the spine started to bend; here the hips fold about 72 degrees.", 27),
       "top": BENCH_TOP,
       "pad": BENCH_PAD,
       "free": ("Free Leg",
                "Only the left leg works: its foot sits under the roller while the right leg stays off the plate, knee bent and foot lifted behind.",
                "With one leg anchored, that hip lifts the whole upper body. In a lab study, doing these back extensions on one leg raised the peak load on the working hip by more than a third and its glute activity with it; with both legs the same lift is easier.",
                "Setting the right foot back down on the plate to help push you up.",
                "Keep the right knee bent and the foot lifted behind you for the whole set, then switch legs."),
       "arms": BENCH_ARMS,
   },
   # Painted: the hamstrings and glutes bright, the erector spinae dim. No
   # EMG of a loaded single-leg version was found: each row sits a step
   # above the two-leg 45-Degree Hip Extension's, since in unloaded hip-led
   # back extensions on a 45-degree bench one leg raised the peak hip moment
   # (1.1 vs 0.8 Nm/kg), gluteus maximus (22.7 vs 16.5 %MVC concentric) and
   # medius and the lumbar erectors (22.8 vs 18.9), and the medial
   # hamstrings eccentrically (12.8 vs 9.6), the lateral not (Schellenberg
   # 2017). Hamstrings 0.92 (ExRx's target; 0.90 on two legs), gluteus
   # maximus 0.84 (0.76), erector spinae 0.46 (0.42): judgement calls. The
   # gluteus medius, higher on one leg in that study, and ExRx's adductor
   # magnus are stabilisers (the glute-group convention).
   activation=[("Hamstrings", P, HI, 0.92), ("Gluteus Maximus", P, HI, 0.84),
               ("Erector Spinae", S, MOD, 0.46)],
   stabilisers=["gluteus medius", "adductor magnus"],
   comparison=("BACK ROUNDING", "Flat back, fold at the hips", "Back curls over the pad",
               "Keeping the back flat and folding at the hips loads the working hip, so its glute and hamstrings lower and lift the trunk.",
               "Curling the back over the pad to get lower moves the bend into the spine, so the hip does less and the back more."),
   glows=bench_glows(SLBE, hams=A, hams_opacity=0.50))

SETUP[SLBE] = [
    "Set the pad so its top edge sits just below your hip crease.",
    "Step in with your thighs on the pad and your left foot flat on the plate, the roller behind your lower calf.",
    "Lift your right foot off the plate, knee bent, and keep it up behind you.",
    "Cross your arms over your chest and start with your body in a straight line.",
]

ex(name=HE45, var="hipExtension45",
   overrides=dict(BENCH_OVERRIDES, depth=(ov(0.80), "trailing")),
   annotations=[
       ("hinge", "Fold at the hips, back flat", "spine"),
       ("top", "Stop in a straight line", "neck"),
       ("pad", "Pad below the hip crease", "thigh_R"),
       ("depth", "Lower to a stretch", "chest"),
       ("arms", "Arms crossed on chest", "hand_L"),
   ],
   cues={
       "hinge": bench_hinge("In another study, heavy 45-degree extensions done with a straight back drew more activity from the biceps femoris, one of the hamstrings, than Romanian deadlifts did, and more glute activity in the top half of the rep. Here the hips fold about 65 degrees.", 20),
       "top": BENCH_TOP,
       "pad": BENCH_PAD,
       "depth": ("Range of Motion",
                 "Each rep lowers until the trunk is about 20 degrees below level, a fold of about 65 degrees at the hips.",
                 "The hips work hardest around where the trunk passes level and sticks out furthest from them, which on this bench comes in the lower part of the rep, so a short dip skips it. The lab version lowered until just before the spine began to bend; another guide stops at a mild stretch or with the trunk about square to the legs.",
                 "Stopping after a short dip, the trunk still well above level, so the hips barely fold.",
                 "Lower slowly until you feel the hamstrings stretch or your back is about to round, pause, then rise to the straight line."),
       "arms": BENCH_ARMS,
   },
   # Painted: the glutes bright, the hamstrings and erector spinae dim. A
   # 45-degree Roman chair done with a straight back at 6RM (Andersen 2021):
   # biceps femoris +71% over the RDL for the whole movement, gluteus
   # maximus not different over the whole movement (+74% in the upper half),
   # erector spinae no different; the 45-degree hip extension drew more mean
   # biceps femoris than the RDL at two sites (Stevens 2022). So gluteus
   # maximus 0.76, a step over the library RDL's 0.72; hamstrings 0.90,
   # above its 0.88 and kept SECONDARY as painted (ExRx makes them the
   # target); erector spinae 0.42 as the RDL. ExRx's adductor magnus, and
   # the gluteus medius under the glute-group convention, are stabilisers.
   activation=[("Gluteus Maximus", P, HI, 0.76), ("Hamstrings", S, HI, 0.90),
               ("Erector Spinae", S, MOD, 0.42)],
   stabilisers=["adductor magnus", "gluteus medius"],
   comparison=("BACK ROUNDING", "Flat back, fold at the hips", "Back curls over the pad",
               "Keeping the back flat and folding at the hips loads the hips, so the glutes and hamstrings lower and lift the trunk.",
               "Curling the back over the pad to get lower moves the bend into the spine, so the hips do less and the back more."),
   glows=bench_glows(HE45, hams=SOFT, hams_opacity=0.30))

SETUP[HE45] = [
    "Set the pad so its top edge sits just below your hip crease.",
    "Step in with your thighs on the pad and both feet flat on the plate, the roller behind your lower calves.",
    "Cross your arms over your chest.",
    "Start with your body in a straight line from head to heels, braced.",
]
