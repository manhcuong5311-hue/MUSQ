# Trainer content for the Desktop "1-100" folder (2026-10-10), family: legs.
# The rest of the builder's 30-leg set: 22 Single-Leg Extension
# (Legs/SingleLegExtension), 23 Smith Machine Front Squat
# (Legs/SmithMachineFrontSquat), 28 Dumbbell Lateral Step-Up
# (Legs/DumbbellLateralStepUp), 29 Barbell Step-Up (Legs/BarbellStepUp) and
# 30 Hip Adduction Machine (Legs/HipAdductionMachine). Same format as spec.py
# on top of common_1_50.py; spec_1010.py imports this module and gen.py reads
# SPEC / SETUP. notes_1010_legs.md maps the copy's claims to the sources below
# and records the model facts.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (the lab's $LAB/1010/legs/dump.py, in the session scratchpad: every joint every frame and the equipment's
# boxes; an.py; ghost.py, a port of FaultGhost.solve), the motion briefs
# (Tools/trainer-content/briefs_1010), tiers.txt, joints.json and the trainer
# stills at 0/1/2/3/5 s. The app's frame: Y up, the lifter faces +z, their
# left is +x. Every clip is 7.96 s at 24 fps, two identical 4 s reps; one
# body (neck to pelvis 0.592 m, thigh 0.444 m, shin 0.398 m, shoulder joints
# ~39 cm apart).
# - Single-Leg Extension: seated, the back on a pad reclined ~10° (trunk-thigh
#   104°), hands on the seat handles, the pelvis still all clip. Only the LEFT
#   leg works: knee 93° at rest (0-0.5 s), extended to 168° by 1.5 s, held to
#   2.25 s, lowered by 3.5 s, rested to 4.5 s (top again 5.5-6.25 s). The
#   right knee stays at 87° the whole clip, its foot behind the roller. The
#   left knee joint sits on the machine's pivot (the pivot housing's centre
#   within 1 cm of it), and the roller (one long pad across both shins) rests
#   on the front of the left shin ~10 cm above the ankle joint all the way up.
#   Paint: the four quadriceps bright (the glutes, lit in the first export,
#   were turned off in the owner's re-export).
# - Smith Machine Front Squat: the bar across the front of the shoulders (8 cm
#   in front of and 8 cm above the shoulder joints), arms crossed: each hand
#   on top of the bar just past the middle (the left knuckles 3.5 cm right of
#   centre), the elbows forward and out, the upper arms 12° above level
#   standing and 8° at the bottom. Feet 46 cm apart at the ankles (the
#   shoulder joints 39-40), toes out 15°, the bar straight over the ankle
#   joints. Down 0.5-1.5 s, held at the bottom 1.5-2.25 s, up by 3.5 s. Bottom:
#   knees 69°, hip joints 2.4 cm above the knee joints (thighs about level),
#   trunk 18° forward, knees 16 cm ahead of the ankles and 4 cm outside them;
#   heels flat throughout. Top: knees 163° (a soft knee). Paint as above.
# - Dumbbell Lateral Step-Up: a 31 cm box (55 cm square) at the lifter's LEFT
#   side; the left foot stays on it (ankle joints 61 cm apart at the start),
#   a dumbbell hanging in each hand (elbows 160°). Start (0-0.12 s): left knee
#   88°, right leg on the floor at 145°, trunk 18° forward, the left shin 53°
#   forward, its knee pointing straight ahead like the foot (the hip-knee-
#   ankle plane faces 4° out, as the foot does) and 3 cm outside the hip-ankle
#   line, though 12.6 cm inside the ankle seen face-on, since the hip is
#   inside the box foot. The right foot leaves the floor
#   at ~0.25 s; the pelvis travels 33 cm sideways and 32 cm up over the box by
#   1.2 s, held to 1.96 s (left knee 147°, right 137°: never locked out; trunk
#   6°). The right foot comes up beside the left but stays ~2.6 cm above the
#   box top, never taking weight, and goes back to the floor by 3.75 s (down
#   ~1.75 s, up ~1.2 s). The pelvis stays level (hip joints within 1°) and
#   the trunk upright side to side all clip. Paint as above.
# - Barbell Step-Up: the bar on the upper back (5 cm behind and 2 cm above the
#   neck joint), hands ~78 cm apart; a 31 cm box in front, the left foot on
#   it (its ankle 61 cm ahead of the right). Start: left knee 92°, hip 75°,
#   trunk 27° forward, the left knee over the foot (6 cm ahead of the ankle,
#   behind the toes). The right foot leaves the floor at ~0.2 s; the hips
#   travel 37 cm forward and 33 cm up; top 1.21-1.96 s (left knee 150°, right
#   145°, trunk 3°). The right foot comes up beside the left, again ~2.6 cm
#   above the box top, and back to the floor behind by ~4 s. Paint as above.
# - Hip Adduction Machine: seated, back on a pad reclined ~8°, hands on the
#   seat handles, feet on footrests that swing with the legs, knees 91° all
#   clip. Pads on the inside of the knees. The knee joints close from 0.78 m
#   apart (each thigh 42° out from straight ahead) to 0.25 m (4° out) over
#   ~1.25 s (0.05-1.29 s), the pads closing to ~1.2 cm apart (they never
#   touch); held to ~1.88 s (~0.6 s); opened over ~2 s (1.88-3.95 s).
#   Paint: adductor longus, adductor magnus, gracilis bright.
#
# How they differ from the library: the Leg Extension works both legs; the
# Front Squat is free with a clean grip (fingers under the bar), the Smith
# Machine Squat has the bar on the back; the Step-Up faces a box and carries
# dumbbells; the Cable Hip Adduction stands and sweeps one leg. Activation
# follows the paint (bright = primary).
#
# Sources (abstracts read on Europe PMC 2026-10-10; ExRx through the Wayback
# Machine, the live site returns 403; StrengthLog read live; details and what
# each supports in the notes):
# - ExRx.net: Lever Leg Extension (WeightExercises/Quadriceps/LVLegExtension,
#   snapshot 2026-02-02): sit with the back against the pad, the front of the
#   lower legs under the padded lever, the knee lined up with the lever's
#   pivot, hold the side handles; target quadriceps, no synergists; under heavy
#   loads the arm and shoulder stabilisers (holding the handles) or a seat
#   belt keep the body from rising off the seat. Smith Front Squat (Quadriceps/SMFrontSquat, 2021-05-01): bar
#   on the front of the shoulders, feet under the bar, down until the thighs
#   are just past parallel, back straight, knees pointing the same direction
#   as the feet; target quadriceps, synergists gluteus maximus, adductor
#   magnus, soleus. Barbell Front Squat (BBFrontSquat, 2026-02-06): cross the
#   arms with the hands on top of the bar and the upper arms parallel to the
#   floor. Barbell Step-up (BBStepUp, 2026-03-04) and Dumbbell Step-up
#   (DBStepUp, 2025-07-02): target quadriceps; synergists gluteus maximus,
#   adductor magnus, soleus, the second leg's gastrocnemius; stabilisers
#   erector spinae, gluteus medius and minimus; torso upright (fairly
#   upright, angled slightly forward with heavier barbell loads); the knee
#   tracks the foot; standing further from the bench emphasises the gluteus
#   maximus. Dumbbell Lateral Step-up (DBLateralStepUp, 2020-11-12): the foot
#   on the bench to the side, stand by straightening that leg, torso upright,
#   the stepping knee pointing the same direction as the foot; synergists
#   include the following leg's gastrocnemius. Lever Seated Hip Adduction
#   (HipAdductors/LVSeatedHipAdduction, 2026-05-20): target hip adductors,
#   synergists pectineus and gracilis; set the legs apart until a slight
#   stretch is felt, lie back, hold the side bars, move the legs together and
#   return.
# - StrengthLog, Leg Extension (strengthlog.com/leg-extension): line the
#   machine's joint up with the knee, back against the pad without arching,
#   extend fully but do not overextend, no momentum. Front Squat
#   (strengthlog.com/front-squat): the crossed-forearm grip is one option.
#   Hip Adduction Machine (strengthlog.com/hip-adduction-machine): push the
#   pads toward each other by bringing the legs together, return with control.
# - Escamilla RF, Fleisig GS, Zheng N et al. 1998, Med Sci Sports Exerc
#   30(4):556-569, doi:10.1097/00005768-199804000-00014, PMID 9565938 - 10 men
#   at 12RM: knee extension drew more rectus femoris and the squat and leg
#   press more vasti activity; in knee extension quadriceps activity peaked
#   near full extension.
# - Botton CE, Radaelli R, Wilhelm EN et al. 2016, J Strength Cond Res
#   30(7):1924-1932, doi:10.1519/JSC.0000000000001125, PMID 26348920 - 12 weeks
#   of knee-extension training in women: one-leg isometric strength rose more
#   after one-leg training (+21% vs +10%); 1RM and muscle thickness gains
#   were similar.
# - Schwanbeck S, Chilibeck PD, Binsted G 2009, J Strength Cond Res
#   23(9):2588-2591, doi:10.1519/JSC.0b013e3181b1b181, PMID 19855308 - 6
#   subjects at 8RM: the free-weight squat drew more EMG than the Smith
#   machine squat (averaged over the muscles, 43% higher; only the
#   gastrocnemius, biceps femoris and vastus medialis differed significantly).
# - Yavuz HU, Erdag D, Amca AM, Aritan S 2015, J Sports Sci 33(10):1058-1066,
#   doi:10.1080/02640414.2014.984240, PMID 25630691 - 12 subjects at maximal
#   loads: more trunk lean in the back squat than the front squat, more
#   vastus medialis activity in the front squat.
# - Abelbeck KG 2002, J Strength Cond Res 16(4):516-524, PMID 12423179 - a
#   model of a squat on a fixed linear bar path: as the feet move forward the
#   knee moment falls and the hip moment rises; foot position is critical.
# - Simenz CJ, Garceau LR, Lutsch BN, Suchomel TJ, Ebben WP 2012, J Strength
#   Cond Res 26(12):3398-3405, doi:10.1519/JSC.0b013e3182472fad, PMID 22237139
#   - 15 trained women at 6RM, step-up, crossover, diagonal and lateral
#   step-ups: the standard step-up drew the most gluteus maximus activity.
# - Muyor JM, Martin-Fuentes I, Rodriguez-Ridao D, Antequera-Vique JA 2020,
#   PLoS One 15(4):e0230841, doi:10.1371/journal.pone.0230841, PMID 32236133
#   (PMC7112217, full text) - 20 participants, barbell lateral step-up onto a
#   40 cm box: the vasti most active, then the gluteus medius, then the
#   gluteus maximus (its lateral step-up table also has the rectus femoris
#   level with the vasti, so the gluteus medius was the most active hip
#   muscle, not the most active after the whole quadriceps); every muscle
#   more active stepping up than down.
# - Wang MY, Flanagan S, Song JE, Greendale GA, Salem GJ 2003, Clin Biomech
#   18(3):214-221, PMID 12620784 - 21 older adults: the forward step-up drew
#   more hip power and work, the lateral step-up more knee and ankle work.
# - Khan IA, Bordoni B, Varacallo MA, StatPearls, Thigh Gracilis Muscle (PMID
#   30855817, NBK538229): gracilis assists hip adduction, knee flexion and
#   internal knee rotation. Jeno SH, Launico MV, Schindler GS, StatPearls,
#   Thigh Adductor Magnus Muscle (PMID 30521263, NBK534842): the medial
#   compartment (pectineus, adductor longus, brevis, gracilis, adductor
#   magnus) adducts the thigh.
# No EMG study of these five as the models do them was found (a seated
# adduction-machine EMG value exists only in a secondary summary of Serner et
# al. 2014, not cited), so every fraction below is a judgement call anchored
# on the library's nearest lift and the order the studies give; the notes say
# which.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_1010.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# ---------------------------------------------------------------- Single-Leg Extension

N = "Single-Leg Extension"
ex(name=N, var="singleLegExtension",
   # Front three-quarter from the lifter's left (yaw -1.0): the lifter sits
   # on the right half (u 0.53-0.85), the left leg and roller sweep the
   # lower left (u 0.17-0.47, v 0.53-0.73). Labels sit at the top left, clear
   # of the overhead pulley arm on the right, and two below the roller.
   overrides={"top": (ov(0.30), "leading"), "pivot": (ov(0.40), "leading"),
              "seat": (ov(0.66), "trailing"), "pad": (ov(0.80), "leading"),
              "rest": (ov(0.80), "trailing")},
   annotations=[
       ("pivot", "Knee on the pivot", "shin_L"),
       ("pad", "Pad above the ankle", "foot_L"),
       ("top", "Straighten, pause", "toe_L"),
       ("seat", "Back on the pad", "pelvis"),
       ("rest", "Right leg rests", "foot_R"),
   ],
   cues={
       "pivot": ("Knee Alignment",
                 "The working knee sits on the machine's pivot, the axis the lever turns on.",
                 "ExRx and StrengthLog both line the knee joint up with the lever's pivot. When the knee and the lever turn about the same line, the pad stays on one spot of the shin through the whole arc; here the knee sits on the pivot and the pad stays about 10 cm above the ankle from bottom to top.",
                 "Sitting too far forward on the seat, so the knee sits in front of the pivot and the pad slides along the shin as the leg rises.",
                 "Set the back pad so the middle of your left knee lines up with the machine's pivot, then sit all the way back against it."),
       "pad": ("Pad Position",
               "The roller rests on the front of the lower shin, just above the ankle.",
               "ExRx sets the front of the lower legs under the padded lever. Here the roller sits on the front of the shin about 10 cm above the ankle joint and stays there as the knee straightens, so the shin, not the foot or the top of the ankle, pushes it up.",
               "Setting the roller high up the shin near the knee, or down on the top of the foot.",
               "Adjust the roller before the set so it rests on the front of your shin just above the ankle, with your knee on the pivot."),
       "top": ("Top of the Rep",
               "Straighten the left knee almost fully, then hold for a moment.",
               "StrengthLog extends the knee fully without overextending it, and in Escamilla and colleagues' study quadriceps activity in the knee extension peaked near full extension, so stopping short skips the range where the quadriceps worked hardest. Here the knee reaches about 168 degrees and holds there for about three-quarters of a second.",
               "Kicking the leg halfway up and dropping it straight back down, the knee never close to straight.",
               "Lift the roller until your left knee is almost straight, pause there, then lower it under control to where you started."),
       "seat": ("Seat Position",
                "The back stays on the pad and the hips stay on the seat.",
                "ExRx sits with the back against the pad, grasps the side handles and notes that under heavy loads the arms holding on, or a seat belt, keep the body from rising off the seat. StrengthLog keeps the back on the pad without arching. Lifting the hips moves the knee off the pivot and lets the trunk swing in to help.",
                "Arching away from the back pad and lifting the hips off the seat as the leg nears the top.",
                "Sit back against the pad, hold the side handles and keep your hips down on the seat from the first rep to the last."),
       "rest": ("Resting Leg",
                "Only the left leg lifts; the right knee stays bent behind the roller.",
                "Here the right knee stays at about 87 degrees for the whole set while the left leg does the work. The roller spans both shins, so a push from the right leg would take load off the left. In a 12-week study of women, one-leg knee extensions raised one-leg isometric strength more than two-leg ones did, though gains in the one-rep max and muscle thickness were similar.",
                "Pushing the roller up with both legs as the set gets hard.",
                "Tuck your right foot behind the roller, let that leg relax, and lift with the left only. Switch sides for the next set."),
   },
   # Paint: the four quadriceps and all three glutes bright. Quadriceps 0.91
   # as the library's Leg Extension (ExRx: quadriceps the target, no
   # synergists; Escamilla 1998: knee extension drew more rectus femoris than
   # the squat and leg press). The first export also painted the glutes
   # bright, though a seated knee extension barely uses them (no synergist on
   # ExRx, none in StrengthLog's list); the owner re-exported it with the
   # glutes unlit (2026-10-10), so only the quadriceps are listed. Stabilisers
   # from ExRx's list (gripping the handles).
   activation=[("Quadriceps", P, HI, 0.91)],
   stabilisers=["forearms", "biceps", "trapezius"],
   comparison=("RIGHT LEG HELPING", "Left leg lifts alone", "Both legs push the roller",
               "With the right leg at rest, the left quadriceps lift the whole load from a bent knee to nearly straight.",
               "Pushing with the right leg too shares the load out, so the working leg lifts less than the stack shows."),
   glows=[glow(N, ["thigh_L", "patella_L"], A, 0.55, 0.06, 0.05, 0.03, -0.01),
          glow(N, ["thigh_R", "patella_R"], SOFT, 0.28, 0.05, 0.04, 0.02, 0.0)])

SETUP[N] = [
    "Set the back pad so your left knee lines up with the machine's pivot.",
    "Set the roller so it rests on the front of your shin just above the ankle.",
    "Sit back against the pad and hold the handles beside the seat.",
    "Tuck your right foot behind the roller and let that leg relax; the left leg works.",
]

# ---------------------------------------------------------------- Smith Machine Front Squat

N = "Smith Machine Front Squat"
ex(name=N, var="smithMachineFrontSquat",
   # Front three-quarter from the lifter's left (yaw -1.0): the Smith frame
   # fills the background, the plates swing u ~0.1-0.35 and 0.8-1.0 from v
   # ~0.15 (top) to ~0.45 (bottom). Labels sit on the left below the plates
   # and on the right below the right-hand plate, never over the lifter.
   overrides={"rack": (ov(0.16), "leading"), "torso": (ov(0.52), "trailing"),
              "depth": (ov(0.68), "trailing"), "knees": (ov(0.73), "leading"),
              "stance": (ov(0.80), "leading")},
   annotations=[
       ("rack", "Arms crossed, elbows up", "forearm_R"),
       ("torso", "Chest up", "chest"),
       ("depth", "Thighs level", "thigh_L"),
       ("knees", "Knees over toes", "patella_R"),
       ("stance", "Feet under the bar", "foot_R"),
   ],
   cues={
       "rack": ("Cross-Arm Rack",
                "The bar rests across the front of the shoulders, arms crossed, upper arms about level.",
                "ExRx's barbell front squat crosses the arms with the hands on top of the bar and the upper arms parallel to the floor, and StrengthLog lists the crossed-forearm grip as one way to hold it. With the elbows up the shoulders form a shelf under the bar; with them down, the shelf tips and the bar rolls toward the hands. Here the upper arms stay within about 12 degrees of level all the way down.",
                "The elbows sinking as you squat, the bar rolling off the shoulders onto the hands.",
                "Set the bar on the front of your shoulders by the collarbones, cross your arms with each hand on top of the bar, and keep your elbows up at shoulder height through the whole rep."),
       "torso": ("Torso Angle",
                 "The chest stays up and the trunk stays close to upright.",
                 "With the load in front, the front squat keeps the trunk more upright than the back squat: in Yavuz and colleagues' study the back squat had more trunk lean. ExRx keeps the back straight. The bar's track is fixed, so folding forward can only push the hips back behind it. Here the trunk leans about 18 degrees at the bottom.",
                 "Folding forward at the bottom, the hips shooting back behind the bar.",
                 "Brace before each rep, keep your chest up and your elbows high, and sit straight down between your heels."),
       "depth": ("Squat Depth",
                 "Sit down until the thighs are about level with the floor.",
                 "ExRx takes the Smith front squat down until the thighs are just past parallel. Here the hip joints stop about 2 cm above the knees, thighs about level, and hold there for a moment before standing. Stopping well above that cuts the range the quadriceps work through.",
                 "Stopping high, the knees bent only to about a right angle and the thighs still sloping down.",
                 "Sit down until your thighs are about level with the floor, pause, then drive straight back up."),
       "knees": ("Knee Track",
                 "The knees travel forward and slightly out, over the toes.",
                 "ExRx keeps the knees pointing the same way as the feet. Here the toes turn out about 15 degrees and at the bottom the knees sit about 4 cm outside the ankles, in line with the feet, and about 16 cm ahead of the ankles.",
                 "The knees caving in toward each other at the bottom or as you stand up.",
                 "Turn your toes slightly out and keep your knees pointing over them all the way down and back up."),
       "stance": ("Foot Position",
                  "The feet sit under the bar, a little wider than the shoulders.",
                  "ExRx sets the feet under the bar for the Smith front squat. Because the bar can only move straight up and down, where the feet sit decides the load: in Abelbeck's model of a fixed-path squat, moving the feet forward lowered the load at the knee and raised it at the hip. Here the bar runs straight over the ankles.",
                  "Walking the feet well out in front of the bar, so you lean back against it and more of the work shifts to the hips.",
                  "Before you unrack, set your feet under the bar about shoulder-width apart, toes turned slightly out, the bar over your ankles."),
   },
   # Paint: the quadriceps and the three glutes bright. Quadriceps 0.86 as
   # the library's Smith Machine Squat (its Front Squat is 0.94; Schwanbeck
   # 2009: the free-weight squat drew 43% more EMG than the Smith squat,
   # averaged over the muscles;
   # Yavuz 2015 found more vastus medialis in the front squat than the back).
   # Gluteus Maximus 0.55: bright, so primary; ExRx lists it as a synergist;
   # between the library's Smith Machine Squat (0.50) and the thrusters'
   # front-squat value (0.62), a judgement call. The bright gluteus medius
   # and minimus are covered by that row and named in the stabilisers with
   # ExRx's (erector spinae, anterior deltoid holding the rack).
   activation=[("Quadriceps", P, HI, 0.86), ("Gluteus Maximus", P, MOD, 0.55)],
   stabilisers=["erector spinae", "adductors", "gluteus medius", "anterior deltoid", "core"],
   comparison=("ELBOWS DROPPING", "Elbows up, bar on the shoulders", "Elbows sink, bar rolls forward",
               "Upper arms about level keep the bar on the shelf of the shoulders while you sit straight down.",
               "Dropped elbows tip the shelf, the bar rolls onto the hands and the chest is pulled forward."),
   glows=[glow(N, ["thigh_L", "patella_L"], A, 0.55, 0.05, 0.06, 0.0, 0.0),
          glow(N, ["thigh_R", "patella_R"], SOFT, 0.30, 0.045, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Set the Smith bar at shoulder height and step under it.",
    "Rest the bar on the front of your shoulders and cross your arms, each hand on top of the bar.",
    "Lift your elbows to shoulder height and set your feet under the bar, a little wider than your shoulders, toes slightly out.",
    "Brace, turn the bar to unhook it and stand tall.",
]

# ---------------------------------------------------------------- Dumbbell Lateral Step-Up

N = "Dumbbell Lateral Step-Up"
ex(name=N, var="dumbbellLateralStepUp",
   # Face-on (yaw 0): the box sits on the right of the frame (the lifter's
   # left), the lifter moves from u ~0.4 to ~0.6 and the dumbbells sweep u
   # ~0.1-0.9 between v ~0.4 and 0.64. Labels sit above the shoulders and
   # below the dumbbells: hips at 0.70 on the left, outside the right leg
   # (at 0.60 the pill sat on the right dumbbell at the start). Both left
   # pills are short (ending by u 0.24) to stay clear of the right foot on the
   # floor (u 0.26-0.33 at the start).
   overrides={"torso": (ov(0.16), "trailing"), "hips": (ov(0.70), "leading"),
              "knee": (ov(0.64), "trailing"), "drive": (ov(0.80), "leading"),
              "foot": (ov(0.80), "trailing")},
   annotations=[
       ("foot", "Whole foot on the box", "foot_L"),
       ("drive", "No bounce", "foot_R"),
       ("knee", "Knee in line", "patella_L"),
       ("hips", "Hips level", "thigh_R"),
       ("torso", "Torso upright", "chest"),
   ],
   cues={
       "foot": ("Box Foot",
                "The whole left foot sits flat on the box, beside you.",
                "ExRx places the working foot on a bench to the side and stands up by straightening that leg. Flat on the box, the heel shares the push and the knee can travel forward over the foot without the heel peeling up; here the left heel stays down from the bottom, with the shin tipped well forward, to the top.",
                "Only the front of the foot on the box, the heel hanging off or lifting as you drive up.",
                "Stand beside a low box and place your whole left foot flat on it, toes pointing ahead."),
       "drive": ("Working Leg",
                 "The left leg lifts you; the right foot only follows.",
                 "ExRx stands up by straightening the leg on the box. Here the right foot leaves the floor early and comes up beside the left without ever taking weight on the box, so the left leg does all the lifting and lowering. A bounce off the floor foot would hand part of the work to the leg that is not training.",
                 "Pushing off the right foot, rising onto its toes to spring yourself onto the box.",
                 "Shift your weight onto the box foot first, then straighten that leg to lift you; let the right foot hang and simply follow."),
       "knee": ("Knee Tracking",
                "The left knee points the same way as the left foot.",
                "ExRx has the stepping knee point the same way as the foot in the lateral step-up. Here the left knee points straight ahead like the foot and travels well forward, past the toes, at the bottom, with the shin tipped about 53 degrees; it stays on the line from the hip to the foot, never bowing in toward the other leg.",
                "The left knee caving in toward the midline as you push up.",
                "Keep your left knee pointing the same way as your toes from the bottom to the top."),
       "hips": ("Pelvis",
                "The hips stay level as the right foot leaves the floor.",
                "Here the pelvis stays level for the whole rep while it travels about 33 cm sideways over the box. ExRx lists the gluteus medius among the step-up's stabilisers, and in a barbell lateral step-up study it was the most active of the hip muscles measured.",
                "The right hip dropping as the right foot lifts off the floor.",
                "Keep both hip bones level as you rise and lower, and step the right foot up and down slowly."),
       "torso": ("Torso Position",
                 "Stay nearly upright, leaning a little forward at the bottom.",
                 "ExRx keeps the torso upright in the lateral step-up. Here the trunk leans about 18 degrees at the bottom and straightens to about 6 at the top, with the dumbbells hanging at the sides; folding further forward turns the step into a hip hinge.",
                 "Folding the chest down toward the box knee to heave yourself up.",
                 "Keep your chest up and the dumbbells hanging straight down by your sides as you rise and lower."),
   },
   # Paint: the quadriceps and the three glutes bright. Muyor 2020 (barbell
   # lateral step-up): the vasti most active, then the gluteus medius, then
   # the gluteus maximus; Wang 2003: the lateral step-up loads the knee more
   # and the hip less than the forward step-up. So three primary rows, the
   # gluteus medius ahead of the maximus: Quadriceps 0.82 (the library's
   # Step-Up), Gluteus Medius 0.55, Gluteus Maximus 0.48 (below the library's
   # Step-Up 0.64, Wang 2003). The gluteus minimus is covered by the medius
   # row. Judgement calls.
   activation=[("Quadriceps", P, HI, 0.82), ("Gluteus Medius", P, MOD, 0.55), ("Gluteus Maximus", P, MOD, 0.48)],
   stabilisers=["forearms", "trapezius", "erector spinae", "obliques"],
   comparison=("PUSHING OFF THE FLOOR", "Box leg lifts you", "Floor foot springs you up",
               "Letting the right foot just follow keeps the whole lift, and the slow lowering, in the left leg.",
               "A bounce off the floor foot hands part of the lift to the leg that is not training."),
   glows=[glow(N, ["thigh_L", "patella_L"], A, 0.55, 0.05, 0.06, 0.0, 0.0),
          glow(N, ["thigh_R", "patella_R"], SOFT, 0.28, 0.045, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Stand with a low box at your left side, a dumbbell in each hand at arm's length.",
    "Place your whole left foot flat on the box, toes pointing ahead.",
    "Keep your right foot on the floor and lean your chest slightly forward.",
    "Brace and keep your hips level before the first rep.",
]

# ---------------------------------------------------------------- Barbell Step-Up

N = "Barbell Step-Up"
ex(name=N, var="barbellStepUp",
   # Front three-quarter from the lifter's left (yaw -0.9): the plates sweep
   # the top of the frame (v ~0.15-0.45) on both sides and the box sits low
   # in the middle. Labels sit below the plates on both sides and at the
   # bottom beside the box.
   overrides={"bar": (ov(0.50), "trailing"), "torso": (ov(0.50), "leading"),
              "knee": (ov(0.62), "leading"), "drive": (ov(0.80), "trailing"),
              "foot": (ov(0.80), "leading")},
   annotations=[
       ("bar", "Bar on upper back", "upper_arm_L"),
       ("foot", "Whole foot on the box", "foot_L"),
       ("drive", "Back foot follows", "foot_R"),
       ("knee", "Knee in line", "patella_L"),
       ("torso", "Back flat", "chest"),
   ],
   cues={
       "bar": ("Bar Position",
               "The bar sits across the upper back, hands wide, elbows bent.",
               "Here the bar rests across the upper back at the base of the neck, with the hands about 78 cm apart, well outside the shoulders. Held there, it stays over the body as the trunk tips forward at the start; a bar slipping down the back pulls the chest forward to balance it.",
               "The bar sliding down the back during the set, the chest tipping forward under it.",
               "Set the bar across your upper back at the base of your neck, take a wide grip well outside your shoulders and pull it into place."),
       "foot": ("Box Foot",
                "The whole front foot sits flat on the box.",
                "With the whole foot down the heel takes part of the push and the knee can stay over the foot. Here the left heel stays flat on the box from the bottom, where the knee is bent about 92 degrees, to the top.",
                "Only the ball of the foot on the box, the heel lifting as you drive up.",
                "Place your whole left foot flat on the box, toes pointing ahead, far enough in that the heel is well on."),
       "drive": ("Working Leg",
                 "The front leg lifts you; the back foot only follows.",
                 "ExRx lists the calf of the second leg, the one that follows, among the helpers, so the back foot gives a little push, but the front leg is the one straightening to lift you. Here the back foot leaves the floor early and comes up beside the front one without taking weight on the box.",
                 "Bouncing off the back foot onto its toes to spring yourself up.",
                 "Lean onto your front foot, then straighten that leg to stand up; let the back foot trail and land softly beside it."),
       "knee": ("Knee Tracking",
                "The front knee stays over the front foot.",
                "ExRx has the leading knee point the same way as the foot. Here the left knee stays over the foot from the start to the top, about 6 cm ahead of the ankle and behind the toes at the bottom.",
                "The front knee caving in toward the other leg as you push up.",
                "Keep your left knee pointing over your middle toes all the way up and down."),
       "torso": ("Torso Angle",
                 "Lean forward from the hips at the start, then stand tall on the box.",
                 "ExRx keeps the torso fairly upright, angled slightly forward with heavier loads, and notes that a stance further from the box works the gluteus maximus more. Here the trunk starts about 27 degrees forward and is upright at the top.",
                 "Rounding the back and dropping the chest over the knee to heave the bar up.",
                 "Hinge forward from the hips with your back flat and chest up, then drive up until you stand tall over the box."),
   },
   # Paint: the quadriceps and the three glutes bright. Quadriceps 0.80 and
   # Gluteus Maximus 0.62: the library's Step-Up (0.82, 0.64), the glutes
   # kept there because Simenz 2012 found the standard step-up drew the most
   # gluteus maximus activity of four step-up variations and this model
   # starts with a 27° forward lean. The bright gluteus medius and minimus
   # are covered by that row and named in the stabilisers (ExRx lists them as
   # stabilisers), with ExRx's erector spinae and the adductor magnus.
   # Judgement calls.
   activation=[("Quadriceps", P, HI, 0.80), ("Gluteus Maximus", P, MOD, 0.62)],
   stabilisers=["gluteus medius", "erector spinae", "adductors", "core"],
   comparison=("CHEST DROPPING", "Lean, then stand tall", "Back rounds over the knee",
               "Leaning from the hips with a flat back keeps the bar over the front foot while the leg drives you up.",
               "Rounding the back to heave the bar puts the effort into the spine instead of the leg on the box."),
   glows=[glow(N, ["thigh_L", "patella_L"], A, 0.55, 0.05, 0.06, 0.0, 0.0),
          glow(N, ["pelvis", "thigh_L"], SOFT, 0.30, 0.05, 0.05, 0.0, 0.0)])

SETUP[N] = [
    "Set a bar across your upper back and stand facing a knee-high or lower box.",
    "Place your whole left foot flat on the box, the right foot on the floor behind.",
    "Lean forward from your hips with your back flat and your weight over the front foot.",
    "Brace your trunk before each rep.",
]

# ---------------------------------------------------------------- Hip Adduction Machine

N = "Hip Adduction Machine"
ex(name=N, var="hipAdductionMachine",
   # Nearly face-on (yaw -0.3): the lifter sits in the middle (u 0.37-0.80
   # above the knees), the knees and footrests sweep u 0.17-0.84 at v
   # 0.52-0.74. Labels sit above the shoulders and below the footrests.
   overrides={"back": (ov(0.16), "leading"), "grip": (ov(0.16), "trailing"),
              "squeeze": (ov(0.80), "leading"), "stretch": (ov(0.80), "trailing"),
              "open": (ov(0.40), "leading")},
   annotations=[
       ("squeeze", "Knees together", "patella_R"),
       ("open", "Open slowly", "shin_R"),
       ("stretch", "Slight stretch only", "foot_L"),
       ("back", "Back on the pad", "chest"),
       ("grip", "Hold the handles", "hand_L"),
   ],
   cues={
       "squeeze": ("Knee Squeeze",
                   "Bring the knees together until the pads meet.",
                   "ExRx and StrengthLog both bring the legs together, pushing the pads toward each other; the adductor longus, adductor magnus and gracilis all pull the thigh in toward the midline. Here the knees close from about 78 cm apart to 25 cm, the pads meeting, and pause there for about half a second.",
                   "Stopping with the knees still well apart, the pads never meeting.",
                   "Squeeze your knees in until the pads touch, hold for a moment, then let them open."),
       "open": ("Controlled Return",
                "Let the knees open slowly against the weight.",
                "StrengthLog returns the legs under control. Here the knees take a little over a second to close and about two seconds to open, so the adductors keep working as the weight lowers instead of letting the stack drop.",
                "Letting the pads fly apart the moment the knees have met.",
                "Take about two seconds to let your knees open back to the start, then squeeze again."),
       "stretch": ("Start Width",
                   "Set the start where you feel a slight stretch, no wider.",
                   "ExRx sets the legs apart only until a slight stretch is felt before the first rep. Here each thigh starts about 42 degrees out from straight ahead. Forcing the knees wider than that puts the inner thigh at the end of its range under load.",
                   "Setting the levers so wide, or letting the knees open so far, that the inner thighs are pulled hard at the start of each rep.",
                   "Set the lever so your knees start comfortably apart with a slight stretch, and stop each opening there."),
       "back": ("Back Position",
                "Sit back against the pad.",
                "ExRx lies back in the machine before the first rep. Here the back rests on the pad, reclined about 8 degrees, the whole set, so the legs move and the trunk stays still.",
                "Slumping forward off the back pad, the lower back rounding as the knees close.",
                "Sit all the way back with your back flat on the pad and keep it there through every rep."),
       "grip": ("Handles",
                "Hold the handles beside the seat lightly.",
                "ExRx grasps the side bars. The handles keep you seated; hauling on them rocks the trunk and turns the squeeze into a pull with the arms.",
                "Pulling hard on the handles and rocking the chest forward to force the knees in.",
                "Hold the handles to stay in the seat, arms relaxed, and let the legs do the squeezing."),
   },
   # Paint: adductor longus, adductor magnus and gracilis bright. One
   # primary row, Adductors 0.85, as the library's Cable Hip Adduction
   # (adductor longus 0.85) and below its Copenhagen Plank (0.90); ExRx's
   # target. The app has no part for "Gracilis" (part_of() drops it), so the
   # Adductors row stands for it and it is named in the stabilisers with ExRx's
   # other synergist, the pectineus, as the thrusters name their bright
   # gluteus medius. Judgement call.
   activation=[("Adductors", P, HI, 0.85)],
   stabilisers=["gracilis", "pectineus"],
   comparison=("SHORT SQUEEZE", "Knees close until the pads meet", "Knees stop well apart",
               "Closing until the pads meet takes the adductors through the whole range the machine allows.",
               "Stopping short leaves out the end of the squeeze, where the knees come together."),
   glows=[glow(N, ["thigh_L", "patella_L"], A, 0.50, 0.05, 0.03, -0.01, 0.01),
          glow(N, ["thigh_R", "patella_R"], A, 0.50, 0.05, 0.03, 0.01, 0.01)])

SETUP[N] = [
    "Set the levers so your knees start comfortably apart with a slight stretch.",
    "Sit back against the pad with your feet on the footrests.",
    "Place the pads against the insides of your knees and hold the handles beside the seat.",
]
