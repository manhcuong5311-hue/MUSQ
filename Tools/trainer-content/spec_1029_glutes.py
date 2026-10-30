# Trainer content for the model-only exercises of 2026-10-29, family
# "glutes": the two single-leg glute machines and the banded bridge that
# shipped with a model but no coaching - Machine Glute Press
# (Legs/MachineGlutePress), Machine Glute Kickback
# (Legs/MachineGluteKickback) and Banded Glute Bridge
# (Legs/BandedGluteBridge). Same format as spec.py on top of common_1_50.py;
# spec_1029.py imports this module and gen.py reads SPEC / SETUP.
# notes_1029_glutes.md maps every claim in the copy to the sources below or
# to a model measurement.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (the round folder's brief.py, summ.py, props.py, gaps.py and nearest.py;
# trainer_shot.py renders the app's own trainer camera, 382x655). Frame: Y up,
# the lifter faces +z, their left is +x, metres. Knee = thigh-shin inner
# angle (180 straight), hip = chest-thigh-shin angle at the hip joint, trunk
# = the neck-over-pelvis line from vertical. All three clips run 7.96 s at
# 24 fps and hold two identical reps, one every 4.0 s.
# - Machine Glute Press (yaw -1.35, side-on from the lifter's left). A
#   plate-loaded glute press: the lifter leans forward at 40 degrees with the
#   chest and forearms on the machine's pads and both hands on handles 0.68 m
#   apart at 1.23 m; the pelvis stays at 1.01 m and the trunk angle never
#   changes. The right leg stands (knee 163 degrees, ankle on the floor at
#   0.18 m) and the left foot sits on a swinging foot plate
#   (GP_FootPlate_Tread, the toe joint 6 cm from its centre all clip).
#   Bottom (0, 4 s): left knee 75 degrees, hip 107, the plate at z -0.10 and
#   0.39 m up, the working ankle 0.40 m from the standing one. Top (1.5-2.0,
#   5.5-6.0 s): knee 161 degrees, hip 158 - the leg straightens as it goes
#   back - the plate 0.62 m further back and 0.06 m higher, the ankles 0.86 m
#   apart. Nothing above the hips moves: the press is the only motion.
#   Paint: gluteus maximus, medius and minimus bright on the working (left)
#   side; biceps femoris, semitendinosus and semimembranosus dim on that side.
#   The quadriceps are not painted even though the knee opens 86 degrees
#   under load, so they are named among the stabilisers instead of given a
#   row (house rule: the rows follow the paint).
# - Machine Glute Kickback (yaw -1.35, side-on from the lifter's left). A
#   selectorised kickback: the same leaning position (trunk 42 degrees, chest
#   on the pad, hands 0.49 m apart at 1.17 m, pelvis fixed at 1.005 m), the
#   right leg standing (knee 156 degrees), and a padded roller (GK_KneeRoller)
#   riding the working leg 0.16 m from the knee joint, which the left leg
#   drives back and up. Bottom (0, 4 s): knee 118 degrees, hip 112, the
#   roller at z -0.05 and 0.66 m up. Top (1.5-2.0 s): knee 168 degrees, hip
#   161, the roller 0.40 m further back and 0.23 m higher (a 0.46 m arc) and
#   the stack lifted 0.11 m; the ankles finish 0.87 m apart against 0.22 m
#   at the bottom. The pelvis height and trunk angle are identical frame to
#   frame, so the hip joint is doing all of it.
#   Paint: the three glutes bright on the working side, the three hamstrings
#   dim on that side, nothing else.
# - Banded Glute Bridge (yaw -0.8, three-quarter from the lifter's left).
#   Face up on an exercise mat with a mini band above the knees
#   (HG_MiniBandAboveKnees, a 0.33 m loop), both arms flat on the mat at the
#   sides (hands 0.34 m out, 0.06 m up), the head down. The feet stay planted
#   0.40 m apart. Bottom (0, 4 s): pelvis 0.171 m up, hips 149 degrees, knees
#   72, the knees 0.351 m apart. Top (1.5-2.0, 5.5-6.0 s, held): pelvis
#   0.313 m - it rises 0.142 m - hips 172 degrees, knees 86, and the knees
#   0.375 m apart: they push 0.024 m out into the band as the hips come up.
#   Paint: the three glutes bright on both sides, the three hamstrings dim;
#   unlike the library's unbanded Glute Bridge model, the quadriceps are not
#   painted here, so this entry has no quadriceps row.
# How they differ from the library: the Cable Glute Kickback is done standing
# with a cuff on the ankle and the trunk hinged over, the Standing Cable Hip
# Extension upright; the two machines here hold the trunk still on a pad, so
# the hip extends against a lever instead of a cable. The Glute Bridge is the
# same bridge without a band (and its model paints the quadriceps), the Frog
# Pump turns the feet out and lets the knees fall wide, the Hip Thrust
# family works from a bench with the shoulders raised, and the Banded Hip
# Abduction is seated with no hip extension at all.
#
# Sources (what each is used for is in notes_1029_glutes.md):
# - Stien N, Saeterbakken AH, Andersen V 2021, J Sports Sci Med 20:56-61,
#   doi 10.52082/jssm.2021.56 (abstract read 2026-10-29): fifteen
#   resistance-trained men, three reps at a unilateral 6RM on the leg press,
#   knee extension and kickback, EMG of five muscles. Gluteus maximus did not
#   differ between the exercises (ES 0.08, p = 0.898); biceps femoris was
#   higher in the kickback than in the leg press (ES 2.27, p < 0.001).
# - Kennedy D, Casebolt J, Farren G, Bartlett M 2023, Int J Strength Cond
#   3(1), DOAJ record 752aa37f7f6f434e8922307910179f60 (abstract read
#   2026-10-29): ten men at a 5RM, banded and unbanded barbell hip thrusts
#   and barbell glute bridges. Both banded conditions drew more upper gluteus
#   maximus activity than the unbanded ones; the unbanded glute bridge drew
#   more gluteus medius than the banded one, which the authors call
#   unexpected and explain through reciprocal inhibition. So the copy says
#   the band gives the glutes something to press against, and never claims it
#   raises gluteus medius activity.
# - Contreras B, Cronin J, Schoenfeld B 2011, Strength Cond J 33(5):58-61
#   (the barbell hip thrust article), as quoted in notes_0927_hipthrust.md
#   (2026-09-27): ribs down and the spine neutral through the lift, the chin
#   tucked, the hips finishing level rather than hyperextended, and the knees
#   tracking over the toes.
# - The library's own entries for the nearest lifts, written in earlier
#   rounds from the sources in their notes: Cable Glute Kickback (Gluteus
#   Maximus 0.84, Gluteus Medius 0.40, Hamstrings 0.50) and Glute Bridge
#   (Gluteus Maximus 0.82, Hamstrings 0.36). This family keeps those
#   fractions, because no EMG study measures either machine.

from common_1_50 import *

NAMES = ["Machine Glute Press", "Machine Glute Kickback", "Banded Glute Bridge"]


def glute_glows(name, rx=0.09, ry=0.07, dx=0.0, dy=0.0):
    """One glow over the hips, where the three glutes are painted."""
    return [glow(name, ["pelvis", "thigh_L"], A, 0.55, rx=rx, ry=ry, dx=dx, dy=dy),
            glow(name, ["pelvis", "thigh_R"], SOFT, 0.30, rx=rx * 0.8, ry=ry * 0.8, dx=dx, dy=dy)]


# ------------------------------------------------------------ glute press

ex(name="Machine Glute Press", var="machineGlutePress",
   # Side-on: the head and hands are top left (u 0.17-0.25, v 0.27-0.36), the
   # hips middle (u 0.46, v 0.45) and the working leg sweeps down to the
   # right (knee u 0.32-0.64 at v 0.55-0.59, foot u 0.53-0.84 at v 0.60-0.62,
   # toe to v 0.67). So: the chest pill top left over empty space, the hips
   # and knee pills on the right where the frame is open above the leg, the
   # support pill bottom left beside the standing foot (u 0.42, v 0.72), and
   # the press pill on the bottom row, under the working foot's arc.
   overrides={"trunk": (0.14, "leading"), "hips": (0.32, "trailing"),
              "start": (0.50, "trailing"), "support": (0.68, "leading"), "drive": (0.86, "trailing")},
   annotations=[
       ("drive", "Press the plate back", "foot_L"),
       ("start", "Let the knee come in", "patella_L"),
       ("hips", "Hips square to the pad", "pelvis"),
       ("trunk", "Chest down, ribs down", "chest"),
       ("support", "Standing knee soft", "foot_R"),
   ],
   cues={
       "drive": ("Hip Drive",
                 "The working foot presses the plate back and up until the leg is straight behind you.",
                 "This is a hip extension with a long lever: in the model the plate travels 0.62 m back and 0.06 m up while the hip opens from 107 degrees to 158. Driving through the whole foot keeps the push behind you, which is where the glute works, rather than down, which only shortens the stroke.",
                 "Short, fast half-presses that never straighten the hip.",
                 "Push the plate away until your working leg is straight behind you, pause, and let it come back under control."),
       "start": ("Bottom Position",
                 "At the bottom the working knee folds up to about 75 degrees under your hip.",
                 "The deep knee and hip at the start are what stretch the glute before each press, and the model returns to the same spot on every rep. Cutting the return short keeps the lift in the easy half of the range.",
                 "Stopping the return halfway, so the plate never comes back under your hip.",
                 "Let the plate come all the way back until your knee is well bent under you before pressing again."),
       "hips": ("Hips and Pelvis",
                "The hips stay square against the pad: only the working leg moves.",
                "The pelvis in the model sits at one height for both reps, so every degree of the 51-degree hip swing comes from the hip joint. Twisting or hitching that side up adds range the glute is not producing and loads the lower back instead.",
                "Rolling the working hip up and open at the top to get more range.",
                "Keep both hip bones facing the pad and square to each other for the whole set."),
       "trunk": ("Trunk",
                 "Chest and forearms stay on the pads, ribs down, the back flat.",
                 "The pads are what let the hip work alone: the model holds its trunk at 40 degrees and never changes it. Pushing the chest up or arching the lower back turns the press into a swing from the spine.",
                 "Arching the back and pushing the chest off the pad on the last reps.",
                 "Rest your chest and forearms on the pads, keep your ribs down and your neck in line with your back."),
       "support": ("Standing Leg",
                   "The standing foot stays flat with the knee soft.",
                   "The other leg holds the whole body against the press. In the model it stays at about 163 degrees - nearly straight but not locked - with the foot flat on the floor the whole set.",
                   "Locking the standing knee or rising onto that toe each rep.",
                   "Keep a small bend in the standing knee and the foot flat, with your weight through the middle of it."),
   },
   # Rows follow the paint: the three glutes bright, the hamstrings dim, on
   # the working side. Fractions are the library's Cable Glute Kickback, the
   # closest lift with content (the same one-leg hip extension): Gluteus
   # Maximus 0.84, Gluteus Medius 0.40, Hamstrings 0.50. Stien 2021 supports
   # the hamstring row for a kickback (biceps femoris higher than in the leg
   # press) and found gluteus maximus no different from the leg press. The
   # quadriceps are not painted, so they stay a stabiliser although the knee
   # opens from 75 to 161 degrees against the plate - the one place the model
   # and anatomy disagree in this family.
   activation=[("Gluteus Maximus", P, HI, 0.84), ("Hamstrings", S, MOD, 0.50),
               ("Gluteus Medius", P, MOD, 0.40)],
   stabilisers=["quadriceps", "core", "erector spinae", "standing-leg glutes"],
   comparison=("ARCHING TO GO FURTHER", "Hips square, spine still", "Lower back arches at the top",
               "With the trunk on the pads the hip joint makes the whole range, and the glute holds the end of it.",
               "Arching the back borrows range from the spine and takes the load off the glute just as it should be working hardest."),
   glows=glute_glows("Machine Glute Press"))

SETUP["Machine Glute Press"] = [
    "Set the foot plate so your working knee starts bent well under your hip, and load the machine.",
    "Lean into the machine with your chest and forearms on the pads and both hands on the handles.",
    "Place the working foot flat on the plate and stand on the other foot with a soft knee.",
    "Square your hips to the pad and brace before the first press.",
]

# --------------------------------------------------------- glute kickback

ex(name="Machine Glute Kickback", var="machineGluteKickback",
   # Side-on: head and hands top left (u 0.23-0.40, v 0.31-0.40), hips at
   # (0.58, 0.45), the working knee sweeping u 0.48-0.74 at v 0.52-0.57 and
   # the foot u 0.58-0.89 at v 0.57-0.64, the standing foot at (0.54, 0.67).
   # So the chest pill top left, the pelvis pill top right clear of the head,
   # the pad pill on the left at mid height, the support pill bottom left and
   # the finish pill on the bottom row under the foot's arc.
   overrides={"trunk": (0.14, "leading"), "hips": (0.32, "trailing"),
              "pad": (0.50, "leading"), "support": (0.68, "leading"), "finish": (0.86, "trailing")},
   annotations=[
       ("pad", "Drive the pad back", "shin_L"),
       ("finish", "Straight line, then stop", "foot_L"),
       ("hips", "Hips level, no twist", "pelvis"),
       ("trunk", "Chest down, ribs down", "chest"),
       ("support", "Standing knee soft", "foot_R"),
   ],
   cues={
       "pad": ("Pad and Drive",
               "The pad rides the back of your leg just above the knee; push it back and up in one arc.",
               "In the model the roller sits 0.16 m from the knee joint and travels a 0.46 m arc - 0.40 m back and 0.23 m up - while the hip opens from 112 degrees to 161. Pressing against the same spot the whole way keeps the lever consistent and the drive coming from the hip.",
               "Kicking with the foot and letting the pad slide down the leg.",
               "Set the pad just above the knee and push it back and up with the whole leg, not the foot."),
       "finish": ("Finish Position",
                  "The rep ends with the thigh in line with your trunk, not past it.",
                  "The model stops at 161 degrees of hip extension - the leg straight behind, no further. Past that point the hip has run out of range and the extra movement comes from the lower back.",
                  "Swinging the leg as high as it will go and letting the back arch to allow it.",
                  "Drive until your working thigh lines up with your body, hold for a beat, then lower it under control."),
       "hips": ("Hips and Pelvis",
                "Both hips stay level and square against the pad.",
                "The pelvis in the model never changes height or angle: it is the fixed point the leg swings from. Letting the working hip ride up turns a glute exercise into a side bend.",
                "The working hip lifting and rotating open as the leg goes back.",
                "Keep your hip bones level and pressed to the pad, and stop the rep where they start to move."),
       "trunk": ("Trunk",
                 "Chest and forearms rest on the pads with the ribs down and the spine long.",
                 "The machine holds your trunk so the hip can work alone - the model keeps its trunk at 42 degrees for the whole clip. A spine that arches or rounds under the pull adds range the glute did not make.",
                 "Rounding the upper back or arching the lower back to help the leg through.",
                 "Settle your chest on the pad, keep your ribs down and your neck in line with your spine."),
       "support": ("Standing Leg",
                   "The standing foot stays flat on the floor with the knee soft.",
                   "It carries the body while the other hip works: in the model it holds about 156 degrees, nearly straight but not locked, and never leaves the floor.",
                   "Pushing up onto that toe to help the working leg finish.",
                   "Keep the standing knee slightly bent and the whole foot down for every rep."),
   },
   # Same paint as the glute press (the three glutes bright, the hamstrings
   # dim, on the working side) and the same fractions, from the library's
   # Cable Glute Kickback: this is that movement with the trunk on a pad.
   # Stien 2021 measured a kickback at 6RM: gluteus maximus no different from
   # the leg press, biceps femoris higher than in it.
   activation=[("Gluteus Maximus", P, HI, 0.84), ("Hamstrings", S, MOD, 0.50),
               ("Gluteus Medius", P, MOD, 0.40)],
   stabilisers=["core", "erector spinae", "standing-leg glutes"],
   comparison=("KICKING PAST THE HIP", "Thigh stops in line with the trunk", "Leg swings up, back arches",
               "Stopping where the hip runs out of range keeps the work in the glute and the spine still.",
               "Swinging higher only arches the lower back; the hip has already finished extending."),
   glows=glute_glows("Machine Glute Kickback"))

SETUP["Machine Glute Kickback"] = [
    "Set the pad so it meets the back of your leg just above the knee, and pick the weight.",
    "Lean into the machine with your chest and forearms on the pads and hold the handles.",
    "Stand on the other foot with a soft knee and square your hips to the pad.",
    "Brace your trunk and take the first rep from a dead stop, without rocking into it.",
]

# -------------------------------------------------------- banded bridge

ex(name="Banded Glute Bridge", var="bandedGluteBridge",
   # Three-quarter view of a body lying across the frame in a band at
   # v 0.41-0.59: head right at u 0.80, knees left at u 0.46-0.47, feet at
   # u 0.23-0.40, hips in the middle (u 0.54, v 0.48-0.53). The middle row is
   # unusable, so two short pills share the top row, the ribs pill sits on
   # the right at 0.32, and the feet and head pills go below, where the mat
   # and the floor leave the frame empty.
   overrides={"band": (0.14, "leading"), "drive": (0.14, "trailing"),
              "ribs": (0.32, "trailing"), "feet": (0.68, "leading"), "head": (0.86, "trailing")},
   annotations=[
       ("drive", "Drive the hips up", "pelvis"),
       ("band", "Press the knees out", "patella_L"),
       ("ribs", "Ribs down, no arch", "spine"),
       ("feet", "Heels close, feet flat", "foot_L"),
       ("head", "Head and arms down", "head"),
   ],
   cues={
       "drive": ("Hip Drive",
                 "The hips lift until your thighs and trunk make one line, then hold for a beat.",
                 "In the model the pelvis rises 0.142 m and the hips open from 149 degrees to 172, with a short hold at the top of each rep. Finishing the hip - rather than stopping halfway or bouncing - is what makes the glute do the work.",
                 "Bouncing the hips off the floor and never reaching a straight line.",
                 "Squeeze your glutes to lift the hips until your body is straight from knees to shoulders, hold, then lower under control."),
       "band": ("Band and Knees",
                "The band sits above your knees, and you press the knees out against it the whole set.",
                "Pushing out gives the glutes something to work against as well as the lift: in a study of ten men, adding a band raised upper gluteus maximus activity in both the barbell glute bridge and the hip thrust. In the model the knees press 0.024 m further apart as the hips come up.",
                "Letting the band pull the knees together as the hips rise.",
                "Press your knees out into the band from the first rep and hold that pressure at the top."),
       "ribs": ("Trunk",
                "The ribs stay down and the lower back keeps its normal shape at the top.",
                "The lift should look like hip extension, not a back arch. The model's trunk tips with the pelvis and nothing else; bridging higher by arching only puts the range into the lumbar spine.",
                "Arching the lower back to push the hips higher than the hips can go.",
                "Tuck your ribs down, brace lightly, and stop the lift where your hips stop moving."),
       "feet": ("Foot Position",
                "The feet stay flat and about 0.40 m apart, close enough that the shins come up near vertical at the top.",
                "Where the feet sit decides how much of the lift the glutes get: the model keeps them planted and never shifts them. Feet too far away hand the work to the hamstrings.",
                "Feet drifting away from the hips, or the heels lifting as the hips rise.",
                "Set your heels about a hand's length from your glutes, press through them, and keep both feet flat."),
       "head": ("Head and Arms",
                "The head stays on the mat and the arms rest flat at your sides.",
                "There is nothing to push with: the arms only balance you. Keeping the head down and the neck long stops the lift turning into a neck brace at the top, as the hip thrust coaching also asks.",
                "Pushing the head back into the mat or the hands into the floor to lever the hips up.",
                "Rest your arms flat at your sides, look at the ceiling, and let the hips do the lifting."),
   },
   # The three glutes are bright on both sides and the hamstrings dim; the
   # quadriceps, which the library's unbanded Glute Bridge model paints, are
   # unlit here, so there is no quadriceps row. Gluteus Maximus 0.82 and
   # Hamstrings 0.36 are that entry's fractions. Gluteus Medius 0.45 is a
   # primary row because the paint is bright and the knees press out against
   # the band, but the number is an estimate anchored between the Frog Pump's
   # 0.40 and the seated Banded Hip Abduction's 0.78: Kennedy 2023 found the
   # band did NOT raise gluteus medius activity in a barbell glute bridge, so
   # the copy claims nothing about it.
   activation=[("Gluteus Maximus", P, HI, 0.82), ("Gluteus Medius", P, MOD, 0.45),
               ("Hamstrings", S, LOW, 0.36)],
   stabilisers=["adductors", "erector spinae", "core"],
   comparison=("ARCHING THE BACK UP", "Hips to a straight line, ribs down", "Lower back arches past the hips",
               "A bridge finished with the glutes stops where the hips stop, with the ribs down and the spine long.",
               "Arching adds height from the lower back instead of the hip, and takes the squeeze off the glutes."),
   glows=glute_glows("Banded Glute Bridge", rx=0.10, ry=0.06))

SETUP["Banded Glute Bridge"] = [
    "Put a mini band around your legs just above the knees and lie face up on a mat.",
    "Bend your knees and set both feet flat, about hip-width apart and a hand's length from your glutes.",
    "Rest your arms flat at your sides and let your head settle on the mat.",
    "Press your knees out into the band and brace your trunk before the first rep.",
]
