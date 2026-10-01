# Trainer content for the 351-400 folder (2026-09-30), family "hip": the
# frog pumps (soles together, knees out, hips pumped up; one with a dumbbell
# across the hips), a standing cable hip adduction, a standing bodyweight hip
# abduction holding two rails, a side-lying hip abduction and a clamshell
# (both framed from behind), and a seated hip abduction against a mini band
# above the knees. Same format as spec.py, on top of common_1_50.py;
# spec_400.py collects it with the other families.
#
# What each model shows, from the briefs (briefs/ and briefs_legs/<Resource>.md),
# the rig itself (joint positions every 0.25-0.5 s read from the converted
# USD; torso, neck to pelvis, 0.592 m; hip joints 0.18 m apart; thigh
# 0.44 m, shin 0.40 m), the highlight tiers (tiers27.json) and the
# simulator stills (shots/view/<slug>_t*.png). Every clip is 8 s: two reps
# of 4 s, the top (hips highest, knees furthest apart or closest) at 2.0 s
# and 6.0 s.
# - Frog Pump (yaw -1.57, side-on from the lifter's left, feet screen-left,
#   head screen-right): lying on the back on a mat. Soles pressed together:
#   the ankles 0.16 m apart with each foot turned in 24 deg so the soles
#   meet, the feet on their outer edges, the ankle joints ~0.38 m from the
#   hip joints along the body (knees 55 deg at the bottom, 73 deg at the
#   top). The knees fall wide: 0.87 m apart at the bottom, 0.78 m at the
#   top, the thighs close to flat out to the sides. The hips lift from
#   0.18 m to 0.36 m (pelvis joint height); at the top the trunk slopes
#   ~20 deg down to the shoulders and the hips sit ~10 cm above the line
#   from the shoulders to the knees (the splayed knees sit low), i.e. the
#   hips are as high as they go. Rep: ~1.2 s up, ~0.7 s hold at the top
#   (1.58-2.25 s), ~1.3 s down, ~0.8 s resting at the bottom. The spine
#   keeps one shape all clip (pelvis-spine-chest 172 deg, spine-chest-neck
#   174 deg): no arch at the top. The head stays on the mat in line with
#   the trunk. Arms flat on the floor out to the sides, palms down, elbows
#   ~97-101 deg, hands beside the waist ~35 cm out. Paint: gluteus maximus,
#   medius and minimus bright; biceps femoris, semitendinosus,
#   semimembranosus and erector spinae dim.
# - Weighted Frog Pump (same framing, same legs and timing to the frame):
#   a dumbbell (0.34 m long, handle side to side) rests across the hips,
#   centred over the hip joints; both hands hold it ~0.22 m apart, elbows
#   134 deg, and it rises and falls with the hips (0.36 -> 0.54 m). Same
#   paint.
# - Cable Hip Adduction (yaw -0.3, near face-on, the lifter's left on
#   screen right): standing on the RIGHT leg (knee 174 deg), side-on to a
#   cable stack ~1.1 m to the lifter's LEFT. A low pulley at ankle height;
#   an ankle cuff on the LEFT ankle. The left hand holds an upright support
#   post between the lifter and the stack at waist height (hand 0.20 m above
#   the hip joints, elbow 103 deg); the right arm hangs. The LEFT leg works,
#   knee straight all clip, held ~11 deg forward: it starts out to the side
#   (~28 deg, the foot ~11 cm off the floor, pulled there by the cable) and
#   sweeps in and across to ~16 deg past the midline (2.0 s), the foot
#   ~14 cm past the body's midline and ~17 cm in front of the standing foot,
#   then returns under control (2 s in, 2 s out). Trunk upright and pelvis
#   level all clip. Paint: adductor longus, adductor magnus and gracilis
#   bright, nothing dim.
# - Standing Hip Abduction (yaw -0.3): bodyweight, facing two upright rails
#   with handles at lower-chest height, one hand on each (elbows ~100 deg).
#   Stands on the RIGHT leg (knee 174 deg); the LEFT leg, knee straight, no
#   forward or backward swing and no turn of the foot, lifts straight out to
#   the side to 30 deg (the foot ~11 cm off the floor, 0.42 m out) at
#   2.0 s and lowers by 4.0 s. Trunk upright, pelvis level all clip. Paint:
#   gluteus maximus, medius and minimus bright.
# - Side-Lying Hip Abduction (yaw 3.14, from behind; feet screen-left, head
#   screen-right): lying on the RIGHT side on a mat, hips and shoulders
#   stacked, both legs straight in line with the body. The top (LEFT) leg,
#   knee straight, lifts in the frontal plane only (no forward drift, no
#   turn of the foot) to 32 deg (ankle from 0.34 m to 0.78 m high) at 2.0 s
#   and lowers by 4.0 s. The pelvis never rolls or tips; the head stays in
#   line with the spine, held ~10 cm off the mat (nothing under it); the
#   lower arm lies bent on the floor, its hand in front of the face, and the
#   top hand is on the floor in front of the chest. Paint: gluteus maximus,
#   medius and minimus bright.
# - Banded Hip Abduction (yaw -0.3, face-on): seated upright on a flat bench
#   (top 0.52 m), hips ~72 deg flexed, knees 108 deg, both feet flat on the
#   floor 0.38 m apart (about shoulder width) and never moving. A mini band
#   around the lower thighs just above the knees. Both knees push out
#   together, from 0.36 m apart to 0.68 m (1.5-2.5 s at the top), and come
#   back in by 4.0 s. Arms straight down, hands resting on the bench beside
#   the hips. Trunk still and upright. Paint: gluteus maximus, medius and
#   minimus bright.
# - Clamshell (yaw 3.14, from behind): lying on the RIGHT side, hips flexed
#   ~51 deg, knees ~80 deg (inner angle), feet stacked together in line with
#   the hips. The top (LEFT) knee opens from 0.16 m to 0.36 m above the bottom
#   one (2.0 s) while the ankles stay together; the pelvis and trunk never
#   roll. The lower arm is folded with the hand under the head; the top hand
#   rests on the floor in front of the chest. Paint: gluteus maximus, medius
#   and minimus bright.
#
# Sources (each checked; notes_400_hip.md maps the claims to them):
# - Contreras B 2016, Frog Pumps and Frog Thrusts (bretcontreras.com, 18 Mar
#   2016): floor frog pumps with the soles together and the feet close to
#   the buttocks, lumbar spine flattened, chin tucked; weighted with a
#   dumbbell in the lap; high reps. He notes there is no EMG data for them.
# - Kang SY, Choung SD, Jeon HS 2016, Man Ther 22:211-215, doi
#   10.1016/j.math.2015.12.010 - bridging at 0, 15 and 30 deg hip abduction
#   (each thigh's angle out from the midline, patella to ASIS): gluteus
#   maximus EMG and the GM/ES ratio highest at 30 deg (16.6 -> 20.3% MVIC);
#   erector spinae EMG and anterior pelvic tilt lower at 30 deg, the
#   erectors only a little (50.7 -> 46.8% MVIC).
# - Choi SA, Cynn HS, Yi CH, Kwon OY, Yoon TL, Choi WJ, Lee JH 2015, J
#   Electromyogr Kinesiol 25(2):310-315, doi 10.1016/j.jelekin.2014.09.005 -
#   bridging with isometric hip abduction against a Thera-Band: more gluteus
#   maximus, less anterior pelvic tilt; hamstring and erector spinae
#   activity unchanged.
# - Kim CM, Kong YS, Hwang YT, Park JW 2018, J Phys Ther Sci 30(7):943-947,
#   doi 10.1589/jpts.30.943 - bridging with the hips turned out 25 deg:
#   higher gluteus maximus activity than neutral or turned in.
# - Kennedy, Casebolt, Farren, Bartlett 2023, Int J Strength Cond 3(1), doi
#   10.47206/ijsc.v3i1.223 - 10 men, 5RM barbell hip thrust and glute bridge
#   with and without a band around the knees: more upper gluteus maximus
#   with the band; the plain glute bridge drew more gluteus medius than the
#   banded one (abstract only).
# - Selkowitz DM, Beneck GJ, Powers CM 2016, J Orthop Sports Phys Ther
#   46(9):794-799, doi 10.2519/jospt.2016.6493 - fine-wire: the superior
#   gluteus maximus more active than the inferior in exercises with hip
#   abduction and/or external rotation (no seated abduction among them).
# - Lehecka BJ et al. 2017, Int J Sports Phys Ther 12(4):543-549 (PMC5534144)
#   - single-leg bridge with the knee bent to 135 deg instead of 90 deg:
#   biceps femoris 23% vs 75% MVIC, gluteus maximus (47 vs 51%) and medius
#   (57 vs 58%) similar; standard single-leg bridges had caused hamstring
#   cramping.
# - Moore D, Semciw AI, Pizzari T 2020, Int J Sports Phys Ther 15(6):856-881,
#   doi 10.26603/ijspt20200856 - systematic review: pooled double-leg bridge
#   low middle-gluteus-medius activity (18.8% MVIC); side-lying abduction
#   moderate (40% pooled), very high with added resistance; standing
#   abduction of the moving leg high with resistance (43% pooled) and 64%
#   unloaded in one study; gluteus minimus measured in standing only in an
#   isometric (held) abduction, not a leg lift; the clam low to moderate
#   in the middle gluteus medius across studies (17-28%), and on fine wire
#   low in the anterior (3%) and middle (13%) medius and in both gluteus
#   minimus segments, moderate in the posterior medius (23%); its data
#   table gives Willcox 2013's clam values (below).
# - Moore D, Semciw AI, McClelland J, Wajswelner H, Pizzari T 2019, J Sport
#   Rehabil 28(6):544-551, doi 10.1123/jsr.2017-0262 - fine-wire gluteus
#   minimus: side-lying abduction 43% MVIC posterior segment (38% anterior,
#   per Moore 2020); clam low.
# - Ganderton C, Pizzari T, Cook J, Semciw A 2017, J Orthop Sports Phys Ther
#   47(12):914-922, doi 10.2519/jospt.2017.7229 - fine wire in 10
#   postmenopausal women: an isometric (held) outward push standing on both
#   feet, feet flat, not a leg lift, high in both gluteus minimus segments
#   (55%, 49%) and the middle medius only 30%; the clam low in the minimus
#   (7%, 20%) and in the anterior/middle medius (3%, 13%). Used only for
#   the clam; no row rests on its standing push.
# - DiStefano LJ, Blackburn JT, Marshall SW, Padua DA 2009, J Orthop Sports
#   Phys Ther 39(7):532-540, doi 10.2519/jospt.2009.2796 - side-lying
#   abduction gluteus medius 81% MVIC, gluteus maximus 39%; clam (30 and 60
#   deg) medius 40% and 38%, maximus 34% and 39%.
# - Boren K et al. 2011, Int J Sports Phys Ther 6(3):206-223 (PMC3201064) -
#   side-lying abduction (leg to ~30 deg, neutral or slight hip extension,
#   toes forward) medius 63%, maximus 51%; clam (hips ~45 deg, feet
#   together) medius 47%, maximus 53%; poor side-lying technique, with the
#   hip flexing, lets the tensor fasciae latae substitute. (Its clam
#   progression 2, the knees kept together while the top foot lifts, a turn
#   of the hip inward, drew medius 62% and maximus 12%: a different movement
#   from the model's fault, and not used in the copy.)
# - McBeth JM, Earl-Boehm JE, Cobb SC, Huddleston WE 2012, J Athl Train
#   47(1):15-23, doi 10.4085/1062-6050-47.1.15 - side-lying abduction:
#   medius 70% (abstract; 79% in its results text), TFL 54%, maximus 25%; with the hip turned out: TFL 71%,
#   medius 53%; clam: medius 33%, maximus 34%, anterior hip flexors 54%.
# - Lee JH, Cynn HS, Choi SA, Yoon TL, Jeong HJ 2013, J Sport Rehabil
#   22(4):301-307, doi 10.1123/jsr.22.4.301 - isometric side-lying
#   abduction: more gluteus medius with the hip turned in, more TFL with it
#   turned out.
# - Cynn HS, Oh JS, Kwon OY, Yi CH 2006, Arch Phys Med Rehabil
#   87(11):1454-1458, doi 10.1016/j.apmr.2006.08.327 - side-lying abduction
#   with the lumbar spine stabilised: quadratus lumborum 60% -> 28% MVIC,
#   gluteus medius 25% -> 46%, lateral pelvic tilt 13.9 -> 5.6 deg.
# - ACE Exercise Library, Side-Lying Hip Abduction (acefitness.org): hips
#   and shoulders stacked vertical, head in line with the spine, knee
#   straight, foot neutral, no flexion or extension, lift until the hips
#   begin to tilt; a common mistake is raising the leg too high, since the
#   thigh abducts to only about 45 deg and past that the whole hip moves.
# - Willcox EL, Burden AM 2013, J Orthop Sports Phys Ther 43(5):325-331, doi
#   10.2519/jospt.2013.4004 - clam: gluteus maximus and medius greater with
#   the pelvis neutral than reclined; medius greatest at 60 deg hip
#   flexion; TFL low and unchanged (abstract). The 35 deg recline and the
#   medius values (neutral ~22.5 / 21 / 17% MVIC at 60 / 30 / 0 deg) are
#   from Moore 2020's data table; Moore calls the hip-angle effect minimal.
# - Selkowitz DM, Beneck GJ, Powers CM 2013, J Orthop Sports Phys Ther
#   43(2):54-64, doi 10.2519/jospt.2013.4116 - fine wire: both gluteals
#   more active than the TFL in the clam; the clam had the highest
#   gluteal-to-TFL index (115) of 11 exercises.
# - Sidorkewicz N, Cambridge ED, McGill SM 2014, Clin Biomech 29(9):971-976,
#   doi 10.1016/j.clinbiomech.2014.09.002 - clam at 30, 45, 60 deg and
#   side-lying abduction turned in, neutral or out: all gluteus medius
#   dominant; the clam's medius-to-TFL ratio far greater.
# - Cambridge University Hospitals NHS, Exercises after a pelvic fracture
#   (cuh.nhs.uk): clam in side-lying with a neutral spine and the deep
#   abdominals engaged, knees open with the ankles together, without letting
#   the pelvis roll back at all.
# - Bolgla LA, Uhl TL 2005, J Orthop Sports Phys Ther 35(8):487-494, doi
#   10.2519/jospt.2005.35.8.487 - gluteus medius: standing hip abduction of
#   the moving leg 33% MVIC, of the standing leg 42%; side-lying 42%.
# - Sinsurin K et al. 2015, J Med Assoc Thai 98 Suppl 5:S42-47 (PMID
#   26387410) - 9 people, standing hip abduction at 0-90 deg in the
#   transverse plane: moving-leg gluteus medius highest (64.7% MVIC) with
#   the leg moved 30 deg off the straight side-on line; the standing leg's
#   highest in pure side abduction (0 deg).
# - NHS OPAL, Standing hip abduction (opalreturntowork.nhs.uk): hold a
#   support, hip, knee and foot pointing straight forward, body straight,
#   whole leg straight out to the side, hold 2 s, lower slowly.
# - de Almeida Paz I, Frigotto MF, Cardoso CA, Rabello R, Rodrigues R 2022,
#   J Bodyw Mov Ther 30:160-167, doi 10.1016/j.jbmt.2022.01.001 - gluteus
#   medius no different between side-lying abduction, the clam and the
#   seated hip abductor machine; TFL higher in side-lying; the machine's
#   medius-to-TFL ratio the best (11 men; only the medius and TFL were
#   recorded, not the gluteus maximus).
# - Cambridge ED, Sidorkewicz N, Ikeda DM, McGill SM 2012, Clin Biomech
#   27(7):719-724, doi 10.1016/j.clinbiomech.2012.03.002 - band walks:
#   gluteus medius activation rose as the band moved from the knees to the
#   ankles to the feet; the gluteus maximus rose only with it at the feet.
# - The Prehab Guys, Seated hip abduction with band (library): band just
#   above the knees, sit upright, push out against the band, no motion in
#   the upper body or back.
# - Serner A, Jakobsen MD, Andersen LL, Holmich P, Sundstrup E, Thorborg K
#   2014, Br J Sports Med 48(14):1108-1114, doi 10.1136/bjsports-2012-091746
#   - adductor longus EMG across eight adduction exercises: standing hip
#   adduction against an elastic band one of two dynamic high-intensity
#   exercises (abstract; exact values not read).
# - Lovell GA, Blanch PD, Barnes CJ 2012, Phys Ther Sport 13(3):134-140, doi
#   10.1016/j.ptsp.2011.08.004 - adductor squeeze tests: adductor magnus,
#   adductor longus and gracilis most active with the hips at 0 or 45 deg.
# - Collings TJ et al. 2026, Med Sci Sports Exerc 58(8):1751-1763, doi
#   10.1249/mss.0000000000004002 - EMG-driven model: an open-chain
#   adduction (lying leg lift) loaded the adductor longus and brevis more
#   (tier 2) than the adductor magnus and gracilis (tier 3, the lowest).
# - Hides JA et al. 2016, Phys Ther Sport 17:19-23, doi
#   10.1016/j.ptsp.2015.06.001 - in a weight-bearing task the adductor
#   magnus was recruited more than the longus; closed-chain work favours
#   the magnus (used only for the rank's direction: open chain, as here,
#   favours the longus).
# - StrengthLog, Cable machine hip adduction (strengthlog.com): cuff on the
#   leg nearest the low pulley, stand sideways, slight bend in the standing
#   leg, pull the leg in across the body, upper body still, return with
#   control.
# - Jensen J et al. 2014, Br J Sports Med 48(4):332-338, doi
#   10.1136/bjsports-2012-091095 - eight weeks of elastic-band hip
#   adduction raised eccentric adduction strength 30% (control 17%).
# No EMG study of the frog pump itself exists (Contreras says so); its rows
# are ranked from bridge studies with the thighs apart or turned out.

from common_1_50 import *

NAMES = ["Frog Pump", "Weighted Frog Pump", "Cable Hip Adduction", "Standing Hip Abduction",
         "Side-Lying Hip Abduction", "Banded Hip Abduction", "Clamshell"]


def frog_glows(name):
    """Seen side-on: the glutes under and behind the hip joints, the
    hamstrings along the underside of the thigh, the erectors along the
    lower back."""
    return [glow(name, ["pelvis", "thigh_L"], A, 0.55, rx=0.075, ry=0.045, dx=0.025, dy=0.015),
            glow(name, ["thigh_L", "patella_L"], SOFT, 0.26, rx=0.07, ry=0.025, dy=0.03),
            glow(name, ["spine", "chest"], SOFT, 0.24, rx=0.06, ry=0.025, dy=0.025)]


# ---------------------------------------------------------------- frog pumps

FROG_FEET = ("Foot Position",
             "The soles press together, heels drawn in toward the hips.",
             "Pressing the soles together lets the knees fall wide and turns the hips out, the frog position. Keeping the heels close keeps the knees well bent, which leaves the hamstrings short: in single-leg bridges, bending the knee further cut biceps femoris (hamstring) activity by about two thirds while glute activity stayed about the same.",
             "Sliding the feet away from the hips, so the hamstrings take over more of the lift and can cramp.",
             "Press the soles together on their outer edges, draw the heels in close to the hips and keep them planted there for the whole set.")
FROG_KNEES = ("Knee Position",
              "The knees fall open to the sides and stay there.",
              "Wide knees keep the hips turned out and apart for the whole rep. The upper part of the gluteus maximus is favoured in exercises that add hip abduction or outward rotation, and bridging with the thighs apart or pushed out against a band raised gluteus maximus activity.",
              "Letting the knees drift up and together as the hips rise, turning it back into an ordinary bridge.",
              "Let the knees drop as wide as your hips comfortably allow and keep them there from the bottom of each rep to the top.")

ex(name="Frog Pump", var="frogPump",
   # Side-on, the body a flat band across the middle (screen 0.39-0.58),
   # feet and knees on the left, head on the right. Labels sit above and
   # below it: hip and knee labels top-left, the back label top-right,
   # the foot label under the feet and the head label under the head. The
   # knee label sits at 0.24, above where the knees-together ghost's knees
   # rise to (0.30) in its turned view.
   overrides={"hips": (0.14, "leading"), "knees": (0.231, "leading"), "ribs": (0.24, "trailing"),
              "feet": (0.72, "leading"), "head": (0.78, "trailing")},
   annotations=[
       ("hips", "Squeeze the hips up", "pelvis"),
       ("ribs", "Ribs down, back flat", "spine"),
       ("feet", "Soles together, heels in", "foot_L"),
       ("knees", "Knees fall wide", "patella_L"),
       ("head", "Head down on the mat", "head"),
   ],
   cues={
       "hips": ("Hip Drive",
                "The glutes drive the hips up and squeeze at the top.",
                "The gluteus maximus is the biggest muscle lifting the hips in a bridge, and it also turns the thighs out, the position the frog stance holds. At the top the hips are fully extended and the glutes at their shortest, so pause and squeeze there.",
                "Stopping short, the hips sinking back down before they finish rising.",
                "Push the outer edges of the feet into the floor, drive the hips up as high as they go without arching, squeeze the glutes for a moment, then lower under control."),
       "ribs": ("Lower Back",
                "The lower back stays flat; the height comes from the hips.",
                "Frog pumps are coached with the lower back flattened and the chin tucked, so the hips finish the rep, not the spine. In one bridging study, angling each thigh about 30 degrees out from the midline also lowered erector spinae activity and anterior pelvic tilt a little compared with keeping the thighs parallel.",
                "Arching the lower back and flaring the ribs at the top.",
                "Brace before each rep, keep the ribs down and the lower back flat, and stop when the hips can go no higher without arching."),
       "feet": FROG_FEET,
       "knees": FROG_KNEES,
       "head": ("Head and Neck",
                "The head stays down on the mat and still.",
                "Keeping the head down and still leaves the neck out of the movement, so each pump comes from the hips. Lifting it to watch curls the neck up and down on every rep.",
                "Lifting the head off the floor to watch the hips on every rep.",
                "Rest the back of the head on the mat, tuck the chin slightly and keep your eyes on the ceiling."),
   },
   # No EMG study of the frog pump (Contreras 2016). Ranked from bridges:
   # the library Glute Bridge's gluteus maximus is 0.82; thighs apart or
   # turned out raised it (Kang 2016, Choi 2015, Kim 2018), so a touch
   # higher. Gluteus medius bright in the paint but low in two-leg bridges
   # (Moore 2020 pooled 18.8% MVIC), and band-resisted abduction did not
   # raise it in a bridge (Kennedy 2023), so the lowest
   # moderate. Hamstrings low, under the Glute Bridge's 0.36: the knees stay
   # bent past 100 deg of flexion (Lehecka 2017). Erector spinae a touch
   # under the Glute Bridge's 0.36: with the thighs angled out it was only
   # slightly lower than in a plain bridge (Kang 2016: 50.7 -> 46.8% MVIC,
   # still above the gluteus maximus); Contreras credits the flattened lower
   # back for keeping the erectors out, which is coaching, not measured.
   activation=[("Gluteus Maximus", P, HI, 0.85), ("Gluteus Medius", P, MOD, 0.40),
               ("Erector Spinae", S, LOW, 0.32), ("Hamstrings", S, LOW, 0.30)],
   stabilisers=["deep hip rotators", "core"],
   comparison=("KNEES CLOSING IN", "Soles together, knees wide", "Knees drift up and together",
               "With the soles pressed together and the knees wide, the hips stay turned out and the glutes do the lifting.",
               "When the knees drift together it becomes an ordinary bridge, and with the thighs parallel the lower back tends to work a little harder."),
   glows=frog_glows("Frog Pump"))

SETUP["Frog Pump"] = [
    "Lie on your back on a mat, arms resting on the floor out to your sides, palms down.",
    "Press the soles of your feet together and let your knees fall open to the sides.",
    "Draw your heels in toward your hips, the feet resting on their outer edges.",
    "Flatten your lower back into the mat and tuck your chin slightly before the first rep.",
]

ex(name="Weighted Frog Pump", var="weightedFrogPump",
   # As the Frog Pump, with the dumbbell rising to screen 0.39 at the top:
   # its label rides the top row on the right, the back label moves below
   # the body on the right. Hip and knee labels as the Frog Pump's.
   overrides={"hips": (0.14, "leading"), "knees": (0.231, "leading"), "dumbbell": (0.20, "trailing"),
              "feet": (0.72, "leading"), "ribs": (0.78, "trailing")},
   annotations=[
       ("hips", "Drive the hips up", "pelvis"),
       ("dumbbell", "Dumbbell steady on hips", "hand_L"),
       ("ribs", "Ribs down, no arch", "spine"),
       ("feet", "Soles together, heels in", "foot_L"),
       ("knees", "Knees stay wide", "patella_L"),
   ],
   cues={
       "hips": ("Hip Drive",
                "The glutes drive the hips and the dumbbell up together.",
                "The dumbbell loads the same frog-stance bridge, so the glutes work harder on every rep while the movement stays the same. Rising until the hips can go no higher takes the glutes to full hip extension, their shortest position, under load.",
                "Stopping short under the weight, the hips hanging below the top on every rep.",
                "Drive through the outer edges of the feet until the hips can rise no further, squeeze for a moment, then lower the dumbbell under control."),
       "dumbbell": ("Dumbbell",
                    "The dumbbell rests across the hips, steadied by both hands.",
                    "Resting across the hip crease, the dumbbell loads the hips directly and rises and falls with them. The hands only keep it from rolling; they do not lift it.",
                    "The dumbbell rolling up onto the stomach as the hips rise, the hands chasing it.",
                    "Set the dumbbell across the hips, hold it at both ends and keep it in the same spot from the bottom of each rep to the top."),
       "ribs": ("Lower Back",
                "Brace so the lower back stays flat under the dumbbell.",
                "With extra load it gets easier to finish by arching the lower back instead of extending the hips. Keeping the ribs down leaves the lift at the hips; in one bridging study, angling the thighs out rather than keeping them parallel also lowered erector spinae activity and anterior pelvic tilt a little.",
                "Arching the lower back at the top instead of finishing with the hips.",
                "Brace before each rep, keep the ribs pulled down and stop where the hips top out."),
       "feet": FROG_FEET,
       "knees": FROG_KNEES,
   },
   # Estimated: no study loads a frog pump. A load across the hips raises
   # the hip-extension demand, so every Frog Pump row goes a little higher,
   # the gluteus maximus to 0.87, between the Frog Pump (0.85) and the
   # library Barbell Hip Thrust (0.90), beside the Single-Leg Glute Bridge
   # (0.86); the erectors and hamstrings stay under the Glute Bridge's 0.36.
   activation=[("Gluteus Maximus", P, HI, 0.87), ("Gluteus Medius", P, MOD, 0.42),
               ("Erector Spinae", S, LOW, 0.34), ("Hamstrings", S, LOW, 0.32)],
   stabilisers=["deep hip rotators", "forearms", "core"],
   comparison=("LOWER BACK ARCHING", "Ribs down, hips finish the lift", "Back arches under the weight",
               "Bracing with the ribs down keeps the finish at the hips, so the glutes lift the dumbbell.",
               "Arching finishes the rep with the lower back instead of the hips, so the glutes stop short of full hip extension."),
   glows=frog_glows("Weighted Frog Pump"))

SETUP["Weighted Frog Pump"] = [
    "Lie on your back on a mat and set a dumbbell across your hips, holding it at both ends.",
    "Press the soles of your feet together and let your knees fall open to the sides.",
    "Draw your heels in toward your hips, the feet resting on their outer edges.",
    "Brace with your ribs down and your lower back flat before the first rep.",
]

# ---------------------------------------------------------------- cable adduction

ex(name="Cable Hip Adduction", var="cableHipAdduction",
   # Near face-on: the post and the working leg fill the right half below
   # the shoulders, the hanging right arm the left edge down to screen 0.52.
   # The trunk and post labels ride the top rows right, clear of the head
   # (and of the right shoulder, which the twist ghost swings back into the
   # top-left in its view from the right). The pelvis label and the short
   # range label sit left below the right hand, clear of the standing leg
   # (from u 0.30 there); the range label at 0.65, above where the lifted
   # model's working shoe crosses (0.69-0.76) in its own mistake view. The
   # knee label sits right at 0.65, over the post, clear of the working
   # knee (at most u 0.66); on the left its leader would cross the range
   # label's.
   overrides={"torso": (0.14, "trailing"), "grip": (0.25, "trailing"), "hips": (0.591, "leading"),
              "leg": (0.686, "trailing"), "sweep": (0.686, "leading")},
   annotations=[
       ("torso", "Upper body still", "chest"),
       ("grip", "Hand on the post", "hand_L"),
       ("hips", "Hips level", "pelvis"),
       ("leg", "Leg straight", "patella_L"),
       ("sweep", "Full sweep", "foot_L"),
   ],
   cues={
       "torso": ("Torso Position",
                 "The upper body stays square and still while the leg sweeps.",
                 "The adductors pull the leg in toward and across the midline. Twisting or leaning the upper body helps swing the foot across without the hip doing more of the work.",
                 "Twisting the upper body toward the standing leg as the foot crosses.",
                 "Stand tall with the shoulders square to the front and keep the upper body still while the leg sweeps in and back out."),
       "grip": ("Support",
                "The post is there for balance.",
                "A light hand on the post steadies you on one leg, so the inner thigh can pull at an even pace. Hauling on it lets the body tip toward the stack instead.",
                "Pulling on the post so the trunk tips over toward the stack.",
                "Rest the hand nearest the stack on the post, arm relaxed, and keep your weight over the standing foot."),
       "hips": ("Pelvis",
                "The pelvis stays level while the leg crosses in front.",
                "A level pelvis keeps the movement at the hip joint. Letting the working side drop tilts the whole leg across with it, so the foot travels further while the adductors do less.",
                "Letting the working hip drop to swing the foot further across.",
                "Hold the pelvis level and facing forward for every rep, and swing only the leg, from the hip joint."),
       "leg": ("Leg Position",
               "The working leg stays long, knee straight, toes forward.",
               "The cuff sits at the ankle, so a straight leg gives the cable its full lever against the adductors. Bending the knee brings the ankle closer to the hip, which shortens that lever and makes the sweep easier.",
               "Bending the knee so the lower leg trails back and the cable works on a shorter lever.",
               "Keep the knee straight and the toes pointing forward, and move the whole leg as one piece from the hip."),
       "sweep": ("Range of Motion",
                 "The leg sweeps from out wide to across the front of the standing leg.",
                 "Letting the cable draw the leg out wide stretches the adductors, and crossing in front of the standing foot finishes the movement; a slow return keeps them working on the way out as well.",
                 "Short swings that stop at the midline, then letting the cable yank the leg back out.",
                 "Sweep the leg in and across in front of the standing foot, pause, then let it travel back out under control."),
   },
   # Open-chain adduction: the adductor longus first (Serner 2014: standing
   # adduction against a band among the two dynamic high-intensity
   # exercises for it; Collings 2026: open-chain adduction loaded the longus
   # and brevis more than the magnus and gracilis), the adductor magnus
   # moderate: open-chain adduction loads it less than the longus (Collings
   # 2026 tier 3, the lowest, against tier 2 for the longus; Hides 2016:
   # weight-bearing, closed-chain work is what favours the magnus). Still P
   # for the paint. Gracilis is painted bright too but has no row name the
   # app keeps; the copy names it.
   activation=[("Adductor Longus", P, HI, 0.85), ("Adductor Magnus", P, MOD, 0.62)],
   stabilisers=["standing-leg gluteus medius", "obliques", "core"],
   comparison=("HIP DROPPING", "Hips level, leg sweeps across", "Working hip drops to swing the foot",
               "With the pelvis level the adductors carry the leg across on their own, the gracilis and the adductor longus and magnus together.",
               "Dropping the working hip tilts the leg across with the pelvis, so the foot travels further while the inner thigh does less."),
   glows=[glow("Cable Hip Adduction", ["thigh_L", "patella_L"], A, 0.55, rx=0.05, ry=0.08, dx=-0.03),
          glow("Cable Hip Adduction", ["thigh_R", "patella_R"], SOFT, 0.30, rx=0.04, ry=0.07, dx=0.03)])

SETUP["Cable Hip Adduction"] = [
    "Attach an ankle cuff to a low pulley and strap it around the ankle nearest the stack.",
    "Stand side-on to the stack, far enough away that the cable draws the cuffed leg out to the side.",
    "Hold the support post or the machine frame with the hand nearest the stack.",
    "Stand tall on your right leg, knee slightly soft; the left leg, nearest the stack, works in this demo.",
]

# ---------------------------------------------------------------- standing abduction

ex(name="Standing Hip Abduction", var="standingHipAbduction",
   # Near face-on between two rails whose uprights run down the screen at
   # u 0.18-0.22 and 0.54-0.58. Two short labels on the left above the
   # rails' handles (the left one ends by u 0.25, before the right
   # shoulder), the pelvis label on the top row right, and the lift and
   # foot labels on the right beside the hip, where the lifted thigh stays
   # left of u 0.70 at those heights.
   overrides={"torso": (0.14, "leading"), "grip": (0.225, "leading"), "hips": (0.14, "trailing"),
              "lift": (0.36, "trailing"), "foot": (0.47, "trailing")},
   annotations=[
       ("torso", "Stand tall", "chest"),
       ("grip", "Light grip", "hand_R"),
       ("hips", "Hips stay level", "pelvis"),
       ("lift", "Out to the side", "patella_L"),
       ("foot", "Toes forward", "foot_L"),
   ],
   cues={
       "torso": ("Torso Position",
                 "Stand tall; only the leg moves.",
                 "The side glutes, the gluteus medius above all, lift the leg out to the side. Tipping the trunk away from the lifting leg carries the pelvis with it, so the foot rises higher while the hip does less.",
                 "Leaning the upper body away from the working leg to get the foot higher.",
                 "Stand tall with the shoulders stacked over the hips and keep the trunk still while the leg moves."),
       "grip": ("Support",
                "The rails are for balance, not for leaning on.",
                "Holding on takes the balance out of standing on one leg, so the effort goes into the side of the hip. Both hips still work: the standing leg's gluteus medius holds the pelvis level, and in one EMG study it worked harder than the lifting leg's.",
                "Leaning the chest forward onto the rails and hanging on them.",
                "Rest one hand on each rail with the arms relaxed and keep your weight over the standing foot."),
       "hips": ("Pelvis",
                "Both hip bones stay level as the leg lifts.",
                "Hitching the lifting side up lets the muscles at the side of the waist raise the leg instead of the glutes. With the pelvis level, the side glutes of both hips do the work: the lifting leg's to raise it, the standing leg's to hold the pelvis steady.",
                "Hiking the hip of the lifting leg up toward the ribs.",
                "Keep both hip bones level and square to the front, and lift the leg from the hip joint."),
       "lift": ("Range of Motion",
                "The straight leg lifts out to the side and lowers slowly.",
                "The thigh abducts only about 45 degrees before the pelvis starts to tip, so a lift of around 30 degrees, as here, keeps the height at the hip; any higher and the waist takes over. A short hold at the top and a slow return keep the side glutes working on the way down as well as up.",
                "Swinging the leg out as high as it will go and letting it drop back.",
                "Keep the knee straight, lift the leg out to the side until the pelvis wants to move, hold for a moment, then lower slowly."),
       "foot": ("Foot Position",
                "The toes point forward as the leg lifts.",
                "With the toes forward the leg moves straight out to the side, in line with the gluteus medius. Turning the foot out rotates the hip outward, and in side-lying tests that raised tensor fasciae latae activity, a hip flexor that also lifts the leg sideways.",
                "Turning the toes out and up as the leg rises.",
                "Keep the kneecap and toes pointing forward and lead the lift with the outside of the heel."),
   },
   # Gluteus medius first: the main abductor (Moore 2020; Bolgla 2005 33%
   # MVIC on the moving leg, 42% on the standing leg; Sinsurin 2015, n=9:
   # the moving leg's gluteus medius peaked at 64.7% MVIC with the leg
   # moved 30 deg off the side-on line, the standing leg's in pure side
   # abduction), beside the library Cable Hip Abduction (0.80). Gluteus
   # maximus moderate: its upper fibres join in abduction (Selkowitz 2016),
   # about half the medius in side-lying (DiStefano 2009), as the library
   # Cable Hip Abduction's 0.42. The gluteus minimus is painted but no
   # study measured it in a standing leg lift (Ganderton 2017's standing
   # data are an isometric push on both feet); no row.
   activation=[("Gluteus Medius", P, HI, 0.78), ("Gluteus Maximus", P, MOD, 0.42)],
   stabilisers=["obliques", "calves", "core"],
   comparison=("LEANING AWAY", "Tall, leg lifts from the hip", "Trunk tips away to lift the leg",
               "Standing tall makes the side glutes lift the leg through the range the hip really has.",
               "Tipping the trunk away lifts the foot higher, but the extra height comes from the waist and pelvis, not the hip."),
   glows=[glow("Standing Hip Abduction", ["thigh_L"], A, 0.55, rx=0.05, ry=0.06, dx=0.06, dy=-0.04),
          glow("Standing Hip Abduction", ["thigh_R"], SOFT, 0.30, rx=0.04, ry=0.05, dx=-0.06, dy=-0.04)])

SETUP["Standing Hip Abduction"] = [
    "Stand facing two support rails and rest a hand on each handle at lower-chest height.",
    "Stand tall with your feet under your hips, knees and toes pointing forward.",
    "Shift your weight onto your right leg, knee slightly soft; the left leg lifts in this demo.",
    "Level your hips and brace your trunk before the first lift.",
]

# ---------------------------------------------------------------- side-lying abduction

ex(name="Side-Lying Hip Abduction", var="sideLyingHipAbduction",
   # From behind, a small figure in a flat band across the middle (screen
   # 0.47-0.58, the lifted foot up to 0.39 on the left). The range label
   # sits top-left; the leg-path and waist labels top-right, so no leader
   # runs under another label; the pelvis and head labels below the mat,
   # the pelvis one on the left: the pelvis dot is left of the spine dot,
   # so its leader comes from the left and the waist leader from the right,
   # never crossing.
   overrides={"lift": (0.14, "leading"), "line": (0.14, "trailing"), "hips": (0.74, "leading"),
              "waist": (0.30, "trailing"), "head": (0.74, "trailing")},
   annotations=[
       ("lift", "Stop before hips tip", "foot_L"),
       ("line", "Leg in line with body", "patella_L"),
       ("hips", "Hips stacked", "pelvis"),
       ("waist", "No hip hitch", "spine"),
       ("head", "Head in line", "head"),
   ],
   cues={
       "lift": ("Range of Motion",
                "Lift the top leg until the pelvis wants to tip, then lower slowly.",
                "Raising the leg too high is a frequent error in this exercise: past the hip's own range the pelvis tilts and the waist lifts the leg instead of the glutes. A slow lowering keeps the side glutes working on the way down.",
                "Swinging the leg up as high as it will go.",
                "Lift the straight top leg until you feel the pelvis start to tip or the lower back tighten, pause, then lower it slowly."),
       "line": ("Leg Path",
                "The top leg lifts in line with the body, toes forward.",
                "Lifting straight up in line with the trunk keeps the work on the gluteus medius. Letting the leg drift forward or turning the toes up brings in the tensor fasciae latae and hip flexors: with the hip turned out, the tensor fasciae latae was more active than the gluteus medius.",
                "Letting the leg drift forward of the body as it rises.",
                "Keep the top leg in line with the trunk or a touch behind it, knee straight and toes pointing forward, and lead with the heel."),
       "hips": ("Hip Position",
                "The hips stay stacked, one directly above the other.",
                "Rolling the top hip back turns the lift into a forward swing of the leg, which hands work to the hip flexors. Keeping the hips and shoulders stacked makes the side glutes do the lifting.",
                "Rolling the pelvis back as the leg rises.",
                "Stack the top hip over the bottom one and the shoulders over each other, and keep them there for the whole set."),
       "waist": ("Trunk",
                 "The waist stays still; the leg moves from the hip.",
                 "Hitching the top hip toward the ribs lets the quadratus lumborum at the side of the lower back lift the leg. Holding the lower back still halved its activity, nearly doubled gluteus medius activity and cut the pelvic tilt by more than half in one study.",
                 "Hitching the top hip up toward the ribs to lift the leg higher.",
                 "Brace the trunk before each rep, keep the waist long on the top side and let only the leg move."),
       "head": ("Head and Arms",
                "The head stays in line with the spine.",
                "Exercise guides set this lift up with the head in line with the spine and the hips and shoulders stacked. Keeping the head in line and still leaves the neck out of it, and the hands on the floor in front of the chest steady you.",
                "Lifting the head to watch the leg, bending the neck sideways.",
                "Hold the head in line with the spine, rest the hands on the floor in front of you, and keep both still through the set."),
   },
   # One scale with the Clamshell: both are ranked on the %MVIC the same
   # studies measured in the two lifts. Gluteus medius first (DiStefano
   # 2009 81% MVIC, the best of 12; Boren 2011 63%; McBeth 2012 70%).
   # Gluteus minimus moderate (Moore 2019 fine wire 38-43%). Gluteus
   # maximus moderate, about half the medius and about what it is in the
   # clam (DiStefano 39%, Boren 51%, McBeth 25%).
   activation=[("Gluteus Medius", P, HI, 0.86), ("Gluteus Minimus", P, MOD, 0.58),
               ("Gluteus Maximus", P, MOD, 0.50)],
   stabilisers=["obliques", "quadratus lumborum", "core"],
   comparison=("PELVIS ROLLING BACK", "Hips stacked, leg lifts sideways", "Pelvis rolls back, leg swings forward",
               "With the hips stacked, the top leg lifts straight out to the side and the gluteus medius does the work.",
               "Rolling back turns the lift into a forward swing, which shifts work to the hip flexors and tensor fasciae latae."),
   glows=[glow("Side-Lying Hip Abduction", ["pelvis", "thigh_L"], A, 0.55, rx=0.06, ry=0.035, dy=-0.005)])

SETUP["Side-Lying Hip Abduction"] = [
    "Lie on your right side on a mat, legs straight and stacked in line with your body.",
    "Stack your hips and shoulders one above the other and keep your head in line with your spine.",
    "Rest your hands on the floor in front of your chest for balance.",
    "Point the toes of the top leg forward; the top leg lifts in this demo.",
]

# ---------------------------------------------------------------- banded seated abduction

ex(name="Banded Hip Abduction", var="bandedHipAbduction",
   # Face-on and large: the body, arms and bench fill the frame below the
   # shoulders. The trunk label rides the top row left of the head, the
   # band label the top row right; the hand label sits left above the
   # right hand (ends by u 0.25, before the shoulder), the knee label left
   # above the right knee, and the foot label on the bottom row left of the
   # right ankle.
   overrides={"torso": (0.14, "leading"), "band": (0.14, "trailing"), "grip": (0.225, "leading"),
              "knees": (0.47, "leading"), "feet": (0.86, "leading")},
   annotations=[
       ("torso", "Sit tall, trunk still", "chest"),
       ("band", "Band above knees", "patella_L"),
       ("grip", "Hands rest", "hand_R"),
       ("knees", "Knees out", "patella_R"),
       ("feet", "Feet flat", "foot_R"),
   ],
   cues={
       "torso": ("Torso Position",
                 "Sit tall with the trunk still; only the knees move.",
                 "With the hips bent, pushing the knees apart works the side glutes, and the upper fibres of the gluteus maximus pull the same way. Rocking the trunk adds momentum, so the hips do less of the opening.",
                 "Rocking the trunk back to lever the knees apart.",
                 "Sit tall on the bench, brace, and keep the chest and shoulders still for the whole set."),
       "band": ("Band Position",
                "The band sits around the thighs, just above the knees.",
                "Just above the knees the band sits where the thighs spread furthest. In band walks, moving it down to the ankles and feet raised gluteal activity, but seated with the feet planted a band at the ankles would barely stretch, so progress with a heavier band instead.",
                "Letting the band roll down onto the kneecaps partway through the set.",
                "Loop a mini band around both thighs just above the knees, lay it flat and check it has not moved between sets."),
       "grip": ("Hands",
                "The hands rest on the bench beside the hips.",
                "Resting hands steady the trunk without doing any of the work. Pushing down through them lifts the hips off the bench and turns the rep into a shove.",
                "Pressing down through the hands so the hips lift off the bench.",
                "Rest the hands on the bench beside the hips, arms relaxed, and keep the hips down on the bench."),
       "knees": ("Knee Drive",
                 "Both knees push out against the band as far as they go.",
                 "Driving the knees apart abducts the bent hips, the main job of the gluteus medius here; a seated abductor machine drew as much gluteus medius activity as side-lying abduction and the clam, with less tensor fasciae latae than side-lying abduction. Pause at the widest point and let the knees come back slowly.",
                 "Short pulses that stop well before the band is fully stretched.",
                 "Push both knees out as far as the hips allow, hold for a moment, then let them come back in under control."),
       "feet": ("Foot Position",
                "The feet stay flat about shoulder-width apart.",
                "Planted feet give a fixed base, so the knees move only because the hips open them. The whole foot stays down from the first rep to the last.",
                "The heels lifting as the knees push out.",
                "Set the feet flat under the knees, about shoulder-width apart, and keep the whole foot down for every rep."),
   },
   # Gluteus medius first (seated abductor machine as active as side-lying
   # abduction and the clam: de Almeida Paz 2022; the library Hip Abduction
   # Machine 0.82). Gluteus maximus moderate, as the library machine's
   # 0.52: not measured in any seated abduction, ranked from anatomy (its
   # upper fibres abduct the hip; Selkowitz 2016 found them favoured in
   # lifts with abduction). The gluteus minimus is painted but not measured
   # in any seated abduction; no row.
   activation=[("Gluteus Medius", P, HI, 0.78), ("Gluteus Maximus", P, MOD, 0.54)],
   stabilisers=["hip flexors", "core"],
   comparison=("TRUNK ROCKING", "Tall trunk, only knees move", "Trunk rocks back to open the knees",
               "A still, upright trunk leaves the side glutes to push the knees out against the band.",
               "Rocking back throws the knees apart with momentum, so the glutes do less of the work against the band."),
   glows=[glow("Banded Hip Abduction", ["thigh_L"], A, 0.55, rx=0.05, ry=0.05, dx=0.05, dy=-0.05),
          glow("Banded Hip Abduction", ["thigh_R"], A, 0.50, rx=0.05, ry=0.05, dx=-0.05, dy=-0.05)])

SETUP["Banded Hip Abduction"] = [
    "Loop a mini band around both thighs just above the knees.",
    "Sit tall on a flat bench with your feet flat under your knees, about shoulder-width apart.",
    "Rest your hands on the bench beside your hips.",
    "Let the knees come in until the band is just taut before the first rep.",
]

# ---------------------------------------------------------------- clamshell

ex(name="Clamshell", var="clamshell",
   # From behind, a flat band across the middle (screen 0.42-0.57), feet at
   # the far left, head at the right. Hip-angle and knee labels top-left,
   # the hip-angle one on top so its leader (down to the top hip) passes
   # right of the knee label; the knee label at 0.28, above where the
   # lifted model's open knee reaches (0.33) in its own mistake view. The
   # top hip sits straight above the pelvis, so the pelvis label hangs
   # below the mat (0.80, under the heel label) and its leader comes up
   # from below; the spine label bottom-right.
   overrides={"angle": (0.14, "leading"), "open": (0.275, "leading"), "pelvis": (0.86, "leading"),
              "heels": (0.74, "leading"), "brace": (0.74, "trailing")},
   annotations=[
       ("open", "Open the top knee", "patella_L"),
       ("angle", "Hips and knees bent", "thigh_L"),
       ("pelvis", "Pelvis still, no roll", "pelvis"),
       ("heels", "Heels together", "foot_L"),
       ("brace", "Spine neutral", "spine"),
   ],
   cues={
       "open": ("Knee Opening",
                "The top knee opens like a clamshell and closes slowly.",
                "Opening the knee with the feet together turns the top hip out, work for the gluteus maximus, the back of the gluteus medius and the deep hip rotators beneath them. In EMG studies the gluteus maximus and medius were about equally active in the clam, and in most studies more active than the tensor fasciae latae.",
                "Short, quick flicks that barely part the knees.",
                "Open the top knee as far as you can without the pelvis moving, pause, then close it slowly."),
       "angle": ("Hip Angle",
                 "Hips bent to about 45 to 60 degrees, knees bent, feet in line with the hips.",
                 "The hip angle makes a small difference: in one study gluteus medius activity was highest with the hips bent to about 60 degrees and lowest with them straight. Bent knees keep the feet together as the top knee opens.",
                 "Lying with the hips almost straight, the knees drifting back.",
                 "Bend the hips to about 45 to 60 degrees and the knees to about a right angle, feet stacked in line with your hips."),
       "pelvis": ("Pelvis",
                  "The pelvis stays still; it never rolls back.",
                  "Rolling the top hip back makes the knee look more open without the hip turning further. With the pelvis rolled back, gluteus maximus and medius activity both dropped compared with a neutral pelvis.",
                  "Rolling the pelvis back as the knee opens.",
                  "Stack the top hip over the bottom one and keep it there, as if balancing a glass of water on it."),
       "heels": ("Heels",
                 "The heels stay together while the knee opens.",
                 "Keeping the feet together makes the knee opening a turn of the hip outward, the movement the clam trains. Letting the top foot rise with the knee lifts the whole leg instead, so less of each rep is that outward turn.",
                 "The top foot lifting off the bottom one as the knee opens.",
                 "Press the heels together and keep the feet touching from the start of each rep to the end."),
       "brace": ("Trunk",
                 "The spine stays neutral with the trunk braced.",
                 "A braced trunk keeps the pelvis still, so the movement stays at the hip. Clinical clam instructions start in a neutral spine with the deep abdominals engaged.",
                 "Letting the lower back arch as the knee opens.",
                 "Breathe out, brace the deep abdominals, keep the back neutral and hold that position while the knee moves."),
   },
   # One scale with the Side-Lying Hip Abduction: both are ranked on the
   # %MVIC the same studies measured in the two lifts. The gluteus medius
   # and maximus about equal (DiStefano 2009 40/34% and 38/39% MVIC; Boren
   # 2011 47/53%; McBeth 2012 33/34%), both moderate (Moore 2020: low to
   # moderate across studies) and far above the TFL (Selkowitz 2013). The
   # medius well under side-lying's (81/63/70% there); the maximus about
   # side-lying's (39/51/25% there), a touch above for McBeth. The gluteus
   # minimus is painted but barely works in the clam on fine wire (Moore
   # 2019: 3% / 8%; Ganderton 2017: 7% / 20%); no row.
   activation=[("Gluteus Medius", P, MOD, 0.62), ("Gluteus Maximus", P, MOD, 0.58)],
   stabilisers=["obliques", "quadratus lumborum", "core"],
   comparison=("PELVIS ROLLING BACK", "Pelvis still, knee opens", "Pelvis rolls back with the knee",
               "With the pelvis held still, the top hip turns outward and the glutes open the knee.",
               "Rolling back opens the knees without the hip turning further, and both glutes work less."),
   glows=[glow("Clamshell", ["pelvis", "thigh_L"], A, 0.55, rx=0.06, ry=0.04, dy=-0.005)])

SETUP["Clamshell"] = [
    "Lie on your right side on a mat with your hips bent to about 45 to 60 degrees and your knees bent.",
    "Stack your feet, knees and hips, the feet in line with your hips.",
    "Fold your lower arm under your head and rest your top hand on the floor in front of you.",
    "Brace your trunk before the first rep; the top knee opens in this demo.",
]

if __name__ == "__main__":
    print("\n".join(validate(NAMES) + validate_library(NAMES)) or "OK")
