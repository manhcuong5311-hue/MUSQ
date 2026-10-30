# Trainer content for the model-only exercises of 2026-10-29, family
# "legs": the two leg lifts that shipped with a model but no coaching -
# Barbell Standing Calf Raise (Legs/BarbellStandingCalfRaise) and Dumbbell
# Lying Leg Curl (Legs/DumbbellLyingLegCurl). Same format as spec.py on top
# of common_1_50.py; spec_1029.py imports this module and gen.py reads
# SPEC / SETUP. notes_1029_legs.md maps every claim in the copy to the
# sources below or to a model measurement.
#
# Written the way the README asks for a family: drafted from the rig and
# the literature, reviewed by two independent agents (evidence; model
# fidelity and labels), revised, audited by a third, and closed out - the
# per-exercise logs are in notes_1029_legs.md.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (the round folder's brief.py, summ.py, props.py, nearest.py, gaps.py and
# palm.py; trainer_shot.py renders the app's own trainer camera at
# 382x655). Frame: Y up, the lifter faces +z, their left is +x, metres.
# Both clips run 7.96 s at 24 fps (192 frames) and hold two identical reps.
# - Barbell Standing Calf Raise (yaw -0.8, from the front and a little to
#   the lifter's left: the chest, clavicles and abdominals face the camera,
#   the bar passes behind the neck and is hidden by the shoulders where they
#   cross, and the joints the rig names _L project to the right of the
#   frame, hand_L at u 0.64). Standing on flat floor with a barbell racked
#   on the upper back - its axis 0.088 m from both scapulae, 0.098 m from
#   both upper-trap supports, 0.109 m from the neck and 0.105 m behind the
#   neck joint in z, unchanged across all 192 frames (largest spread
#   0.15 mm, 0.8 mm on the z offset), so the bar never shifts there - and
#   both hands overhand on the shaft 0.79 m apart against shoulders 0.39 m
#   apart, the wrists 0.095 m below and 0.019 m behind the bar axis
#   (0.097 m away) and fixed there all clip (palm.py puts hand_L local X at
#   +x, the sign of the pronated Biceps/ReverseCurl reference; its Y axis
#   matches neither reference, and at this yaw the far hand is mostly behind
#   the torso, so the call rests on that sign and the near hand). Equipment
#   is the barbell and nothing else: five meshes, a 2.04 m shaft 0.028 m
#   thick, two 0.37 m plates 0.08 m thick and two collars at x +/-0.79, and
#   no platform, block or step in the scene - toe_L and toe_R never leave
#   y 0.015 m while the heel rises, so the pivot is the ball of the foot on
#   the floor.
#   Bottom (0-0.08, 3.38-4.08 and 7.38-7.96 s): ankle 103.5 (L) / 104.2 (R)
#   degrees, the heel 0.071 m up, both feet flat. Top (0.92-2.12 and
#   4.92-6.12 s, held 1.20 s): ankle 140.2 / 140.8 degrees - a 36.6 degree
#   range on both sides - the heel 0.139 m up and 0.067 m further forward,
#   and the barbell 0.13 m along its path (0.068 m up, 0.107 m forward).
#   The ankle is the only joint that moves: the knees are constant at 174.7
#   / 176.0 degrees (zero range over the clip), the hips within 0.3 degrees,
#   the elbows within 0.01, the trunk within 1.5 degrees of vertical, and
#   the pelvis and head ride up 0.065 m with the heels. Two reps, one every
#   4.0 s: rise 0.92 s, top 1.20 s, lower 1.26 s, bottom 0.58-0.70 s. Both
#   sides move in lockstep, with heel heights identical to the millimetre;
#   the constant 0.6 degree ankle and 1.3 degree knee difference between
#   them is a rig offset, not asymmetric movement.
#   Paint: both gastrocnemius heads and the soleus bright on both legs;
#   biceps femoris, semimembranosus and semitendinosus dim; nothing else
#   lit, so neither the tibialis posterior nor the peroneals get a row here
#   - the same three rows and the same two lower-leg stabilisers as the
#   library's Dumbbell Standing Calf Raise.
# - Dumbbell Lying Leg Curl (yaw -1.35, side-on from the lifter's left; the
#   body lies across the frame in a band at v 0.48-0.67, head left at
#   u 0.185, knees at 0.656, the feet and the dumbbell right at 0.66-0.88).
#   Prone along a flat bench's back pad: trunk +84 degrees (face down and
#   level), the pelvis joint 14.5 cm and the chest 20.0 cm above the pad,
#   the hips 157.6 degrees, the knees 4.8 cm past the rear end of the pad
#   (patella_L z -0.438 against the pad box's -0.390) and 9.7 cm above its
#   top (0.523 against 0.426), the head just past the head end, and both
#   hands down at the seat pad's edges (2.2 cm from its box, 0.34 m apart,
#   3 cm below pad height) with the elbows at 58.8 degrees. One dumbbell
#   hangs between the feet and is carried by them alone: the toes 0.4 cm off
#   the upper head at the bottom and 1.4 cm at the top, the ankle joints
#   5.7 to 6.0 cm off the lower head throughout, the ankles a constant
#   0.141 m apart and the knees 0.150 m. Over all 228 rig joints at nine
#   moments, toe_L/toe_R and foot_L/foot_R are the closest BODY joints to
#   the three dumbbell meshes (0.093, 0.094 and 0.153 m to their centres),
#   and over all 192 frames neither hand ever comes within 1.20 m of the
#   weight's surface or 1.29 m of its mesh centres; the prop is parented to
#   the foot, so the foot-to-dumbbell-axis angle holds at 65.73 degrees and
#   those centre distances do not change by a millimetre. Both legs curl
#   together in exact mirror (knee_L and knee_R equal at every sample).
#   Bottom (0, 4 s, held ~0.7 s): knees 166.7 degrees, ankles 165.2, the
#   shaft centre at [0.00, 0.57, -0.95] and 29.0 degrees off vertical, the
#   dumbbell's lower end at y 0.425 - level with the bench's own pad top at
#   0.426. Top (1.25-2.0, 5.25-6.0 s, held ~0.75 s): knees 86.6 degrees - an
#   80.1 degree arc - ankles 111.7, the shaft 54.1 cm away at
#   [0.00, 0.95, -0.56], 0.38 m up and 0.39 m toward the head end, and 2.5
#   degrees off vertical; the curl takes ~1.0 s and the lowering ~1.5 s.
#   The weight's horizontal lever on the ankle barely moves across the rep
#   (12.5 cm at the bottom, 13.1 cm at the top, its maximum), while the
#   knee's collapses from 50.1 cm at the bottom to 13.4 cm at the top.
#   The knee and the ankle are the only joints that move in the whole clip:
#   the knee through 80.1 degrees and the ankle through 53.4 (165.2 nearly
#   in line with the shin at the bottom, 111.7 at the top), both sides
#   identical to 0.000. Everything else is constant - pelvis height 0.571 m,
#   trunk, hip, elbow, upper-arm pitch and the hand, shoulder and ankle
#   separations - and the knee joint itself never translates. The bench
#   never moves either (19 static meshes, 0.0 cm). Two reps on a 4.00 s
#   cycle, 7.96 s at 24 fps (192 frames).
#   Paint: the three hamstrings bright, the two gastrocnemius heads and the
#   soleus dim, nothing faint.
# How they differ from the library: the Standing, Smith Machine, Dumbbell
# Standing, Single-Leg and Leg Press Calf Raises are the same straight-knee
# ankle work with another load or machine, and the Seated Calf Raise bends
# the knee; the Lying Leg Curl and Seated Leg Curl are machine curls with a
# pad on the ankles, the Nordic and Assisted Nordic Curls lower the whole
# body, and the Cable Standing Leg Curl works one leg upright. This curl is
# the only one in the library that holds a dumbbell between the feet.
#
# Sources (what each is used for is in notes_1029_legs.md):
# - Kinoshita M et al. 2023, Front Physiol 14:1272106, PMID 38156065 (full
#   text read 2026-10-29): 14 untrained adults, 12 weeks, 70% 1RM, 5 sets of
#   10 twice a week, one leg standing with the knee straight and the other
#   seated with the knee bent; lateral gastrocnemius +12.4% against +1.7%,
#   medial +9.2% against +0.6%, soleus +2.1% against +2.9% (p = 0.410).
# - Kassiano W et al. 2023, J Strength Cond Res 37(9):1746-1753, PMID
#   37015016 (abstract read 2026-10-29): 42 young women, 8 weeks, 3 days a
#   week on a horizontal leg press, 0 degrees defined as the foot square to
#   the tibia; the stretched range (-25 to 0 degrees, entirely below a flat
#   foot) grew the medial gastrocnemius 15.2%, the full range 6.7% and the
#   shortened range 3.4%.
# - Cresswell AG, Loscher WN, Thorstensson A 1995, Exp Brain Res
#   105(2):283-290, PMID 7498381 (abstract read 2026-10-29): 10 men; as the
#   knee bent, plantar flexor torque fell and gastrocnemius EMG fell while
#   soleus activity held - the gastrocnemius is only at length with the knee
#   straight.
# - Kawakami Y et al. 2002, J Physiol 540(2):635-646, PMID 11956349
#   (abstract read 2026-10-29): 6 men, maximal plantar flexion with and
#   without a countermovement; with the dip the fascicles stayed nearly the
#   same length while the tendon stretched and recoiled, raising force and
#   work at the tendon.
# - Gentil P et al. 2020, Int J Environ Res Public Health 17:9487,
#   PMC7765981 (full text read 2026-10-29): a straight-knee standing raise
#   drives the soleus as hard as a leg press does. Each muscle was
#   normalised to its own maximum in the test with no MVC taken, so it is
#   not evidence for ranking one plantar flexor above another.
# - Kulig K et al. 2004, Med Sci Sports Exerc 36(5):862-867, and Akuzawa H
#   et al. 2017, Phys Ther Sport 28:23-28: the peroneus longus and tibialis
#   posterior work in a heel raise (MRI signal up 57% and 27%; fine-wire
#   EMG). Neither gives a normalised figure, so they justify the
#   stabilisers, not a row.
# - Kellis E, Blazevich AJ 2022, BMC Sports Sci Med Rehabil 14(1):166,
#   PMC9446565 (Discussion read 2026-10-29): knee flexion torque peaks
#   around 30 degrees of knee flexion whatever the hip angle.
# - Li L, Landin D, Grodesky J, Myers J 2002, J Electromyogr Kinesiol
#   12(5):385-390, PMID 12223171: the gastrocnemius knee-flexion moment is
#   greatest with the knee straight at every ankle angle and small at 90 and
#   75 degrees.
# - Maeo S et al. 2021, Med Sci Sports Exerc 53(4):825-837, PMID 33009197,
#   PMC7969179: 20 adults, 12 weeks, one leg on a seated leg curl machine
#   (hip about 90 degrees) and the other prone (hip about 30); the whole
#   hamstrings grew about 14% seated against 9% prone.
# - Pedrosa G, Pereira R, Kassiano W 2026, Sports Med Int Open
#   10:a27337605, PMC12951042: a long range is necessary but not sufficient,
#   particularly where there is real external torque in the lengthened
#   position.
# - Carmona G et al. 2018, Front Physiol 9:54, PMC5807877 (full text read
#   2026-10-29): thirteen healthy male students, six months clear of
#   systematic heavy-resistance training, six sets of ten unilateral
#   lowering-only hamstring reps at 120% of their concentric maximum.

from common_1_50 import *

NAMES = ['Barbell Standing Calf Raise', 'Dumbbell Lying Leg Curl']

ex(name="Barbell Standing Calf Raise", var="barbellStandingCalfRaise",
   # Rows below are the screen rows spec_1029.row() squeezes the overrides
   # onto (0.14/0.50/0.68/0.86 -> 0.16/0.48/0.64/0.80). From the front, the
   # lifter is a narrow column up the middle and the plates are thrown wide
   # at bar height: between v 0.23 and 0.38 the ink runs u 0.07-0.93, so the
   # 0.32 row has no gutter on either side and nothing is put there. The bar
   # pill goes on the left of row 0.16, which is clear across the whole
   # frame at the bottom of the rep (the topmost ink is v 0.20); at the top
   # the body rises 6.5 cm and ink enters that row from u 0.332, so the
   # 15-character pill, ending at u 0.318, is what makes it fit. Below the
   # hips the right column is free from u 0.55 outward, so the knee pill
   # sits at 0.64 (ink to u 0.55, 170 px of clear column) and the tempo pill
   # at 0.48 (ink to u 0.53), just above the floor line at v 0.505. The two
   # heel pills share the bottom row at 0.80 either side of the shoes (ink
   # u 0.31-0.54), the short one to their left, the long one to their right.
   overrides={"bar": (0.14, "leading"), "tempo": (0.50, "trailing"),
              "knees": (0.68, "trailing"), "top": (0.86, "leading"),
              "bottom": (0.86, "trailing")},
   annotations=[
       ("bar", "Bar on the back", "neck"),
       ("knees", "Knees straight, soft", "patella_L"),
       ("top", "Heels up high", "foot_R"),
       ("bottom", "Heels down to the floor", "foot_L"),
       ("tempo", "Pause, lower slowly", "chest"),
   ],
   cues={
       "bar": ("Bar Position",
               "The bar rides across the top of your back, below the neck, with both hands the same width out on it.",
               "That shelf of muscle across the top of the back is what carries the load: in the model the bar axis sits 9 cm from each shoulder blade, equal on the two sides, and 11 cm from the neck joint, and it holds there in every one of the 192 frames. The hands hold it overhand 0.79 m apart against shoulders 0.39 m apart, wide enough to pin the bar while the ankles work. Set there, the whole body rises straight up - the trunk stays within 1.5 degrees of vertical and the head and hips rise 6.5 cm with the heels.",
               "Resting the bar up on the neck, or taking hold of it off centre so one side carries more.",
               "Set the bar on the muscle across the top of your back, take an even grip about twice shoulder width, and stand tall before the first rep."),
       "knees": ("Straight Knees",
                 "The knees stay straight but soft, so that only the ankles move.",
                 "The gastrocnemius crosses the knee as well as the ankle, so it is only at full length with the knee straight. In a 12-week study of untrained adults, the leg trained standing with the knee straight grew its lateral gastrocnemius 12.4% against 1.7% for the leg trained seated with the knee bent, and its medial head 9.2% against 0.6%, while the soleus grew about the same either way. The model holds both knees at about 175 degrees, with no change at all across the two reps.",
                 "Dipping at the knees to bounce the bar up.",
                 "Keep a small fixed bend in your knees, move at the ankles alone, and pick a load you can lift that way."),
       "top": ("Top of the Rep",
               "Push up until your heels are as high as your ankles will take them, and hold there for a moment.",
               "This lift is one joint and a short range: in the model the ankle opens 36.6 degrees, the same on both sides, and the heels come about 7 cm up while the toes stay where they are. Stopping short throws away part of a range that is already small. The model holds the top for about 1.2 seconds on each of its two reps.",
               "Turning back halfway, with the ankles never fully pointed.",
               "Push through the balls of both feet until your heels are as high as they go, hold for a beat, then lower."),
       "bottom": ("Bottom of the Rep",
                  "The heels come all the way back down to the floor before the next rep.",
                  "Low in the rep the calves are at their longest, but on the floor the heels can only come down to level, so touching down every rep is the least to aim for - the model returns to exactly the ankle angle it started from on each rep and waits there over half a second. Standing with the balls of the feet on a block lets the heels drop below level, and in an eight-week study of young women, training only that stretched range below a flat foot grew the medial gastrocnemius 15.2%, against 6.7% for the full range and 3.4% for the range above flat that this version works in.",
                  "Stopping the heels above the floor, so every rep works the top half only.",
                  "Lower under control until your heels are down and both feet flat, pause for a beat, then push back up."),
       "tempo": ("Tempo",
                 "Rise under control, hold the top, lower more slowly, and pause at the bottom.",
                 "Dropping and bouncing gives part of the job to the Achilles tendon: in a maximal ankle push started with a quick dip, the calf fibres stayed nearly the same length while the tendon stretched and sprang back. That made the push stronger, but it was the tendon storing and returning the energy, so a slow lowering and a pause at the bottom are what keep the work on the muscle. Standard calf coaching asks for the same thing - do not bounce, control the lowering. In the model the rise takes about 0.9 seconds and the lowering about 1.3.",
                 "Dropping into the bottom and bouncing straight back up.",
                 "Take about a second to rise, hold the top, take longer to lower than you took to rise, and start every rep from a dead stop."),
   },
   # The paint lights the two gastrocnemius heads and the soleus bright on
   # both legs and the three hamstrings dim, and nothing else, so no
   # lower-leg row here. Gastrocnemius 0.86 and Soleus 0.66, both primary,
   # are exactly what the library's Dumbbell Standing Calf Raise carries,
   # down to the same Hamstrings 0.15 and the same tibialis posterior and
   # peroneals among its stabilisers; the Standing, Leg Press, Single-Leg
   # and Smith Machine raises carry the same two fractions and ranks on top
   # of a lower-leg row of their own (Fibularis Longus 0.30 on the Standing,
   # Tibialis Posterior 0.30 on the Leg Press, both at 0.30 on the
   # Single-Leg, both at 0.25 on the Smith). So there is nothing unusual to
   # settle here: the rows follow the paint and land where the nearest
   # neighbour already is. Gentil 2020 is not evidence for the soleus rank -
   # it normalised each muscle to its own test maximum with no MVC taken and
   # never compared muscles with each other, so its 51.3% soleus and 52.2%
   # medial gastrocnemius are not comparable; what it does show is that a
   # straight-knee standing raise drives the soleus as hard as a leg press
   # does. Kinoshita 2023 (soleus grew the same standing as seated, 2.1%
   # against 2.9%, p = 0.410) is why a straight knee is not treated as a
   # gastrocnemius-only position. Hamstrings 0.15 is the standing
   # neighbours number and a pure estimate: no EMG study measures a
   # hamstring in any calf raise. Tibialis posterior and the peroneals are
   # stabilisers because this model does not paint them - Kulig 2004 (MRI
   # signal up 57% in the peroneus longus and 27% in the tibialis posterior
   # after a heel raise) and Akuzawa 2017 (fine-wire EMG, both active) say
   # they work, but the rows follow the paint.
   activation=[("Gastrocnemius", P, HI, 0.86), ("Soleus", P, MOD, 0.66),
               ("Hamstrings", S, LOW, 0.15)],
   stabilisers=["tibialis posterior", "peroneals", "toe flexors", "upper back", "core"],
   comparison=("HEELS STOPPING SHORT", "Heels to the floor, then up", "Heels never reach the floor",
               "Flat feet to the top of the ankle is the whole 36 degrees this lift has, so every rep has to start with both heels down on the floor.",
               "Heels that stop above the floor cut off the end where the calves are at their longest, so each rep covers less of an already short range than it looks like it does."),
   # Both calves read at this yaw. A flat-colour id render, which credits
   # every painted pixel to the mesh it belongs to, gives the R calf 956 px
   # (u 0.393-0.463) and the L calf 726 px (u 0.458-0.552) at the bottom of
   # the rep, 986/723 at the top and 971/732 in the lowering, and all of
   # them come through red in the shaded still. What differs is their shape:
   # at the glow row v 0.665 the R calf is one 19 px run (u 0.406-0.453)
   # while the L calf is a 4 px strip at u 0.458-0.466 and an 8 px strip at
   # u 0.531-0.550, split by its own unpainted shin, and the mean of shin_L
   # and foot_L that glow() centres on (u 0.4737) lands in that gap. So the
   # pair is spec_500_calfstand.calves(dy=-0.02) with the full glow on R:
   # the R ellipse (0.414, 0.660) has its centre on paint at t0, t1 and t3
   # and runs 43-57% red, while the L one (0.489, 0.665) runs 29-40% with
   # its centre on no paint at any of them, and a sweep of dx 0-0.040
   # against dy -0.03 to +0.01 finds no offset in that family that centres
   # it at all three - so it stays the soft 0.32 far-side shape rather than
   # a second bright glow. The paint spans v 0.618-0.747 with its centroid
   # at v 0.678, against shin-to-ankle midpoints of 0.685 (L) and 0.680 (R),
   # so the dy lift keeps each ellipse over the belly of the paint rather
   # than the shoe. The dim hamstring paint gets no glow: it is never wider
   # than 8 px on a row (near thigh u 0.453-0.518, far thigh u 0.390-0.435),
   # and the draft's third ellipse measured 16/27/22% red with its centre
   # off paint and most of that red the calf paint its lower edge dipped
   # into - the Dumbbell Standing raise carries the same Hamstrings 0.15 row
   # with no hamstring glow.
   glows=[glow("Barbell Standing Calf Raise", ["shin_R", "foot_R"], A, 0.55,
               rx=0.045, ry=0.07, dx=0.015, dy=-0.02),
          glow("Barbell Standing Calf Raise", ["shin_L", "foot_L"], SOFT, 0.32,
               rx=0.0405, ry=0.063, dx=0.015, dy=-0.02)])

SETUP["Barbell Standing Calf Raise"] = [
    "Set the bar in a rack at upper-chest height.",
    "Step under the bar and rest it high across your upper back, below the neck, where the muscle makes a shelf for it.",
    "Take an even overhand grip about twice shoulder width, with your wrists just under the bar.",
    "Stand the bar up and step back onto flat floor, feet about hip-width apart, toes pointing forward.",
    "Straighten your knees without locking them, brace your trunk, and let both heels settle on the floor before the first rep.",
]


ex(name="Dumbbell Lying Leg Curl", var="dumbbellLyingLegCurl",
   # Side-on and prone, head left: the lifter and the bench fill one band
   # (v 0.48-0.67) right across the frame at every moment, and nothing at
   # all reaches above v 0.400 (the raised dumbbell's highest corner, at
   # t 1.38 s), so the two middle rows are unusable and the top strip and
   # the bottom corner are free. Only the feet, the toes and the dumbbell
   # move (toe u 0.717-0.876 at v 0.420-0.517); the head (0.185), chest
   # (0.364), pelvis (0.474) and knee (0.656) never move a pixel. So two
   # pills share the top row - the dumbbell pill on the left, 0.13 clear of
   # the chest pill on the right - two more share row 0.32, and the curl
   # pill sits bottom right at 0.86, in a part of the frame that carries no
   # subject pixel at all below v 0.70 in any of the four stills, with its
   # leader running up to the knee clear of the bench silhouette, whose
   # right edge below the lifter stops at u 0.626. The knee cannot be
   # labelled from the top: a leader dropping to it crosses the raised shin
   # and the dumbbell at the top of the rep.
   # The hips label is held to 13 characters because the dumbbell pill's own
   # leader sweeps right through row 0.32 as the toes rise, reaching u 0.690
   # at the band's lower edge (checked on every one of the 192 frames, worst
   # at t 2.83 s): at 22 characters the trailing pill starts at u 0.580 and
   # the leader cuts 42 px into it, at 14 it starts at 0.697 with under 3 px
   # of air, and at 13 it starts at 0.712 with 8.4 px. The two feet pills
   # have to lead from the left edge and the two trunk pills to trail from
   # the right, so their leaders cross above the lifter, over empty backdrop.
   overrides={"bell": (0.14, "leading"), "upper": (0.14, "trailing"),
              "lower": (0.32, "leading"), "hips": (0.32, "trailing"), "curl": (0.86, "trailing")},
   annotations=[
       ("bell", "Feet squeeze the dumbbell", "toe_L"),
       ("curl", "Straighten at the bottom", "patella_L"),
       ("hips", "Hips stay put", "pelvis"),
       ("lower", "Slow on the way down", "foot_L"),
       ("upper", "Chest down, neck long", "chest"),
   ],
   cues={
       "bell": ("Holding the Dumbbell",
                "One dumbbell hangs between your feet, with its top end on your toes and the handle trapped between them.",
                "Your feet are the only thing holding it. Across the whole clip the model keeps the toes within 1.4 cm of the top end and the ankles a steady 14 cm apart, about the width of the dumbbell heads themselves, and neither hand ever comes closer than 1.2 m to the weight. The feet do not only squeeze, they roll: the ankle travels about 53 degrees as the shin comes up, from fully pointed at the bottom to flat under the shin at the top, and the dumbbell turns upright with the foot as it goes, from 29 degrees off vertical to 2.5. So the squeeze has to hold while the angle under it keeps changing.",
                "Letting the feet soften at the top, so the dumbbell tips or slides out of them.",
                "Trap the handle between your feet with the top end on your toes, keep your ankles about as far apart as the dumbbell is wide, and hold that squeeze until the weight is back down."),
       "curl": ("Range of Motion",
                "Each rep opens the knees to almost straight and bends them to about a right angle, both legs together.",
                "The model runs 167 degrees down to 87, an 80-degree arc, with the left and right knees equal in every frame. With the weight out at your feet, the load on the knee is heaviest while the shin is level, near the straight end, and fades as the shin comes up toward vertical - that is the lever, not a study. Tests of knee-flexion strength put the most torque at about 30 degrees of bend in general, and with the hip straight, as it is here, right at that straight end; the calves pull on the knee hardest with the leg straight and barely at all past 90 degrees. The same review is clear that a prone curl is not where the hamstrings make their best torque, so the case for the long end here is the load on it: a review of range and muscle length found that a longer range pays off where there is real load in the stretched position.",
                "Short pumps at the top, with the knees never coming back near straight.",
                "Let the knees open until your legs are almost straight and the dumbbell is still under control, then curl to about a right angle."),
       "hips": ("Hip Position",
                "The hips and the fronts of your thighs stay down on the bench for the whole set.",
                "This is a curl with the hip held still: the pelvis sits at one height and the hip at one angle from the first frame to the last, barely short of straight at 158 degrees, so the hip never moves and the knee and the ankle do all of it. Coaching for the prone curl treats the hips or the lower back starting to move as the sign you have reached the end of your range, and a light brace through the middle is what stops the hips hiking and the back arching. The flat hip is simply what this lift is, not the stronger position for growth: over twelve weeks the machine version of this curl done seated, with the hips bent, grew the hamstrings about 14% against 9% for the prone one.",
                "The hips lifting off the bench to drag the last rep up.",
                "Press your hips and thighs into the pad, brace lightly, and end the rep where they start to move."),
       "lower": ("Lowering Control",
                 "The weight comes down slower than it goes up: about a second and a half down against about a second up.",
                 "That is the model timing rather than a rule, but it matches where the work is, because the resistance builds again as the shin comes back toward level. Hard eccentric leg curls also bite harder than they look: in one study thirteen men six months clear of heavy resistance training did six sets of ten lowering-only reps at 120% of what they could lift, with the weight raised back up for them after every rep, and ten of the thirteen ended with severe damage through the whole semitendinosus, though how much varied enormously from person to person. Lifters who had already trained a leg curl twice a week for twelve weeks barely showed it. Soreness in the first few sessions is normal, so ease into the slow lowering rather than pushing it from the first workout.",
                 "Letting the knees fall open and the dumbbell drop at the end of a set.",
                 "Take about half again as long coming down as going up, and keep squeezing your feet until the dumbbell is back at the bottom."),
       "upper": ("Upper Body",
                 "Your chest rests on the pad, your head sits just past the end of the bench and your hands only hold its edges.",
                 "There is nothing up here to lift with: the feet carry the weight and the hands touch none of it. In the model the elbows hold 59 degrees, the head and neck stay level with the chest rather than craned up, and the hands never move - they sit 2.2 cm from the pad at the head end, 0.34 m apart, for the whole clip. Hauling on the bench or pushing the chest up only rocks the hips, which is the one thing this lift needs you not to do.",
                 "Pulling on the bench and lifting the chest and head to help the knees through the last reps.",
                 "Rest your chest on the pad with your neck in line with your back, take a light hold of the bench edges, and let your legs do all of it."),
   },
   # Rows follow the paint: the three hamstrings bright, so one primary
   # Hamstrings row; the two gastrocnemius heads and the soleus dim, so two
   # secondary calf rows (README: bright group = primary row, dim =
   # secondary). The hamstring and gastrocnemius fractions are CARRIED from
   # the library's Lying Leg Curl (0.90 / 0.46), the machine version of this
   # lift - the same prone, hip-extended, single-joint curl - which also
   # puts it below the Seated Leg Curl (0.92, the hip-flexed and better
   # growth arm in Maeo 2021) and above the Cable Standing Leg Curl (0.86).
   # The 0.46 ties the top of the leg-curl rows (the Lying and Single-Leg
   # Curls, both 0.46, under the Glute-Ham Raise's 0.50) and belongs here:
   # Li 2002 found the gastrocnemius knee-flexion moment greatest with the
   # knee straight and negligible past 90 degrees, which is where a hanging
   # dumbbell is hardest, and the feet carry the weight for the whole set.
   # No study has ever measured a dumbbell prone curl, so none of these
   # fractions is an independent estimate. The soleus does not cross the
   # knee and adds nothing to the 80-degree arc, but it is painted dim and
   # it is the muscle holding the ankle that carries the weight: with the
   # lifter prone, a weight hanging from the toes pulls the forefoot toward
   # the front of the shin, which the plantar flexors resist, and the rig
   # agrees - the weight hangs the same distance from the ankle all the way
   # through (12.5 cm at the bottom, 13.1 cm at the top), so the ankle holds
   # against it for the whole rep, while the knee's own lever collapses from
   # 50 cm to 13 cm. The ankle sits fully pointed (165 degrees) at the
   # bottom and only reaches 112 at the top. So the soleus takes a LOW
   # secondary row rather than leaving the rows, the way round 2's bright
   # tibialis posterior and fibularis kept rows that run 0.15-0.30; 0.30 is
   # an estimate at the top of that range, pitched under the gastrocnemius
   # 0.46 because the gastrocnemius does both jobs. The glutes are
   # unpainted, so they stay a stabiliser as on the Lying Leg Curl, holding
   # the hips flat.
   activation=[("Hamstrings", P, HI, 0.90), ("Gastrocnemius", S, MOD, 0.46), ("Soleus", S, LOW, 0.30)],
   stabilisers=["gluteus maximus", "core"],
   comparison=("HIPS LIFTING", "Hips down, knees do the curl", "Hips lift off to finish the rep",
               "With the hips and thighs flat the hip stays out of it, so the knees carry the whole 80-degree arc.",
               "Lifting the hips lets the hip joint help the knee, so part of the rep comes from the lower back, and it is the sign you have run out of range."),
   # The hamstrings, bright, on the knee half of the thigh where the paint
   # sits (the nudge moves the hip-to-knee mean onto it); softer, the calf,
   # which swings from behind the knee up to vertical. The shorts cover the
   # upper thigh, so the visible hamstring paint centres at (0.630, 0.507)
   # and this glow lands at (0.607, 0.517); left as drafted for the owner to
   # compare side by side against dx=0.058, dy=-0.020, which lands exactly
   # on that centroid (notes, open point 5).
   glows=[glow("Dumbbell Lying Leg Curl", ["thigh_L", "shin_L"], A, 0.55, 0.08, 0.05, dx=0.035, dy=-0.01),
          glow("Dumbbell Lying Leg Curl", ["shin_L", "foot_L"], SOFT, 0.30, 0.07, 0.07)])

SETUP["Dumbbell Lying Leg Curl"] = [
    "Set a bench flat and stand a dumbbell on one end behind it, on a box or a second flat bench at about the height of the pad you will lie on, where your feet will be, or have someone pass it to you once you are down.",
    "Lie face down along the bench with your hips on the pad and your knees just past the end of it, so your lower legs clear the pad and can swing freely.",
    "Reach down and take the sides of the pad at the head end, chest down and neck in line with your back.",
    "With your legs straight out behind you, trap the handle between your feet with the top end on your toes, then let the weight settle and squeeze before the first rep.",
]
