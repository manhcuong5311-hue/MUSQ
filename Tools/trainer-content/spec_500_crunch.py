# Trainer content for the 401-500 folder, second round (2026-10-04/05),
# family: crunch. Five floor and ball crunches from the builder's 415-444
# exports: 430 Bicycle Crunch (Abs/BicycleCrunch), 431 Oblique Crunch
# (Abs/ObliqueCrunch), 437 Toe Touch Crunch (Abs/ToeTouchCrunch), 438
# Cross-Body Crunch (Abs/CrossBodyCrunch) and 436 Stability Ball Crunch
# (Abs/StabilityBallCrunch). Same format as spec.py on top of common_1_50.py;
# spec_500.py imports this module and gen.py reads SPEC / SETUP.
# notes_500_crunch.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the models show, measured on the rigs with Blender's Python + pxr
# (SCRATCH/crunch/measure.py, extra.py, ball.py, ballcontact.py; the app's
# Y-up space, the lifter facing +z, their left +x, lying with the head toward
# -z), the briefs (SCRATCH/briefs2*, written for upright lifts, so the trunk
# angles below are measured instead: the neck-to-pelvis line's angle above
# the floor), tiers2.txt and the trainer stills. One body; neck to pelvis
# 0.59 m lying flat, ~0.52 m curled. Every clip is 7.96 s. All five keep the
# hands behind the head (elbows ~40 degrees, wide) except the toe touch.
# - Bicycle Crunch: on a mat, the head and shoulder blades held off the mat
#   the whole clip (neck-pelvis line ~22 degrees above the floor, the upper
#   back ~45; the lumbar segment and pelvis never move), both feet off the
#   floor. The legs alternate: one knee draws in (hip 42, knee 71 degrees)
#   while the other leg pushes out long (knee 170, the hip-to-ankle line ~30
#   degrees above the mat, the shoe ~49 cm up), and the trunk turns ~42
#   degrees (shoulder line against hip line) so the opposite elbow reaches
#   the knee (elbow joint to kneecap 9 cm). Right elbow to left knee at
#   0.33-1.0 s, left elbow to right knee 1.67-2.33 s, and so on: six touches
#   in 7.96 s, ~1.33 s per side, each held ~0.6 s. Between touches (0, 1.33,
#   2.67 s and so on) it passes through a level middle (both knees 120,
#   thighs ~75 degrees, no turn).
#   Paint: external and internal obliques and rectus abdominis bright,
#   sartorius (the hip flexors) dim.
# - Cross-Body Crunch: on a mat, knees bent 85 degrees, feet flat ~30 cm
#   apart. Each rep starts flat (shoulders down) and one knee draws up toward
#   the chest (hip 150 -> 42 degrees) as the trunk curls (neck-pelvis line
#   -5 -> 22 degrees) and turns ~42 degrees; the opposite elbow meets the
#   knee (9 cm) over the upper abdomen; the other foot stays flat. Up
#   0.42-1.0 s, held 1.0-2.4 s, down by ~3.3 s, flat until 4.25 s. Rep 1
#   left knee and right elbow, rep 2 right knee and left elbow (4-8 s). The
#   top pose is the bicycle's touch exactly. Paint as the bicycle crunch.
# - Oblique Crunch: the crossover crunch. The left ankle rests across the
#   right thigh just above the knee (figure 4: left knee 67 degrees, open to
#   the left), the right foot flat (knee 85). The trunk curls (neck-pelvis
#   line -5 -> 19 degrees) and turns ~31 degrees to the left with almost no
#   side bend (~1 degree): the right shoulder and elbow come up and across
#   toward the left knee and stop over the midline, the elbow ~54 cm short
#   of the knee. Both reps on the same side (right elbow toward left knee),
#   timed as the cross-body crunch: up 0.5-1.0 s, held 1.0-2.4 s, down by
#   ~3.3 s. Paint: obliques bright, rectus abdominis dim.
# - Toe Touch Crunch: legs about straight up over the hips the whole clip
#   (hip 86 degrees, knees 172, ankles ~99 cm up; the thighs lean ~10
#   degrees past vertical toward the head, the hip-to-ankle line ~6, the
#   ankles ~9 cm on the head side of the hips), arms straight (166 degrees)
#   reaching up. The trunk curls from flat to ~35 degrees (neck-pelvis line;
#   the upper back ~64), the shoulder blades well clear of the mat (scapula
#   joints 6 -> 33 cm up), the lumbar segment staying on the mat; the hands
#   reach up between the feet until the fingertips are ~4 cm from the shoes
#   (the highest finger point 7 cm above the ankle joints). Up 0.25-1.0 s,
#   held 1.0-2.4 s, down by 3.25 s, flat to 4.25 s; two reps. Framed from
#   behind the head, left (yaw -2.3). Paint: rectus abdominis and sartorius
#   (hip flexors) bright, obliques dim.
# - Stability Ball Crunch: a 65 cm ball (HG_StabilityBall) behind the hips.
#   At the bottom the back lies along it from the buttocks to the lower
#   shoulder blades (skin within 2 cm of the ball), head and shoulders off it,
#   the hip joints at 55 cm, ~10 cm below the ball's top, in front of it
#   (about 2 o'clock); feet flat ~34 cm apart, knees 96-99 degrees, thighs
#   about level. The upper back curls up (neck-pelvis line 26 -> 51 degrees
#   above level, chest-to-neck 22 -> 64) while the lower back and hips stay
#   on the ball (at the top only the buttocks and lower back touch it), the
#   hips sinking ~2 cm. The back never extends over the ball at the bottom.
#   Up 0.25-1.0 s, held 1.0-2.5 s, down by 3.25 s, resting to 4.25 s; two
#   reps. Paint: rectus abdominis bright; obliques and the four quadriceps
#   dim.
#
# How they differ from the library: the Crunch (feet flat, a straight curl),
# Reverse Crunch (the pelvis curls up), Russian Twist (seated, rotation with
# a ball) and Side Plank (a hold). The bicycle and cross-body crunches add a
# turn and a knee drive to the crunch (the bicycle with the shoulders and feet
# up all set, the cross-body back to the mat each rep); the oblique crunch is
# a one-side turn from a crossed-leg position; the toe touch is a crunch with
# the legs up and the arms reaching; the ball crunch moves the crunch onto a
# ball. None repeats the library's cue sets word for word.
#
# Sources (read 2026-10-05; abstracts on Europe PMC, ACE and ExRx on the
# Wayback Machine since ExRx's live site 403s; details in the notes):
# - ACE press release, American Council on Exercise (ACE)-sponsored Study
#   Reveals Best and Worst Abdominal Exercises, 14 May 2001 (Peter Francis,
#   San Diego State University biomechanics lab; 30 healthy adults, 13
#   exercises, EMG; Wayback snapshot 20210101101606): rectus abdominis
#   ranking bicycle maneuver 1, crunch on exercise ball 3, vertical leg
#   crunch 4, traditional crunch 11; obliques bicycle 2, vertical leg crunch
#   5, ball crunch 6, traditional crunch 11; the ball crunch drew
#   significantly less thigh (rectus femoris) activity. Not peer reviewed;
#   used for rankings only. ACE's How to do the Top Ab Exercises Correctly
#   (Wayback 20060823064320): the vertical leg crunch has the legs straight
#   up, crossed at the ankles with a slight bend in the knee, hands behind
#   the head; the traditional crunch keeps a fist's distance between chin
#   and chest.
# - ACE Exercise Library (acefitness.org/resources/everyone/exercise-library,
#   Wayback): Supine Bicycle Crunches (241, snapshot 20250102094111): knee to
#   chest in a straight line, the other leg extended and kept off the floor,
#   trunk curls and turns, elbow touches or nearly touches the knee, hold
#   1-2 s, slow and controlled, do not pull on the head, head in line with
#   the upper back, low back pressed to the mat, rotation from the trunk not
#   the hips. Vertical Toe Touches (243, 20250130075440): thighs vertical,
#   not past vertical (shifts weight from the buttocks into the low back),
#   curl until the shoulder blades lift completely, head in line with the
#   upper back, avoid flexing it too far forward, hold briefly for 5-10 s,
#   control speed, roll up and down. Crunch (52, 20250125022517): feet,
#   tailbone and low back stay on the mat, rib cage toward pelvis, chin slightly tucked,
#   rushing recruits the hip flexors. Stability Ball Sit-ups / Crunches (68,
#   20241205045253): mid back on top of the ball (12 o'clock), hips at
#   2 o'clock, knees 90, thighs parallel, hip-width; bottom of the chest
#   toward the top of the pelvis; tailbone and low back stay on the ball;
#   curl until the upper back lifts off; widen the feet for balance.
# - ExRx.net (Wayback): Crunch (BWCrunch, 20230523091650), Twisting Crunch
#   (BWTwistingCrunch, 20240105212512; target obliques, synergists rectus
#   abdominis and psoas major; done with the lower legs resting on a bench,
#   where the leg elevation keeps the pelvis tilted back and the low back on
#   the mat, so not used for the bicycle's unsupported legs; space between
#   chin and sternum, particularly with the hands behind the head), Ball
#   Crunch (BWBallCrunch,
#   20221118014201; shoulders and head off the ball; low-back discomfort if
#   the hips are not bent, then lower the hips on the ball; ball lower on the
#   back and hips higher is harder).
# - StrengthLog: Bicycle Crunch (strengthlog.com/?p=31656; primary obliques,
#   secondary abs and hip flexor; extend the right leg while the right elbow
#   turns toward the left knee) and Oblique Crunch
#   (strengthlog.com/oblique-crunch/; primary obliques, secondary abs; the
#   elbow and shoulder of one side move toward the opposite knee; bend as
#   far as possible), both read 2026-10-05.
# - Hutchings N, How To Do The Crossover Crunch, Coach (coachweb.com,
#   updated 4 July 2022): one foot on the opposite knee, shoulders lifted
#   without pulling on the neck, torso twists so the elbow moves to meet the
#   knee, reversed slowly.
# - Magnante M, Cross-Body Crunch, FitnessVolt (published 23 Nov 2020,
#   updated 11 Aug 2024): feet flat, fingers behind the ears, elbows out;
#   left elbow and right knee meet above the belly button, then the other
#   side, alternating; never pull on the head; bring elbow and knee together
#   at the same time; moderate tempo, slow return.
# - Crommert ME, Bjerkefors A, Tarassova O, Ekblom MM 2021, J Strength Cond
#   Res 35(2):428-435, doi:10.1519/JSC.0000000000002439, PMID 29319600 - ten
#   women, fine-wire EMG on the right side: in twisting curl-ups the
#   internal oblique (and transversus) worked harder twisting right, the
#   external oblique twisting left, in keeping with fibre direction; the
#   rectus abdominis did not change with direction; changing the arm
#   position to raise the load raised the EMG of all four abdominal muscles.
# - Oliva-Lozano JM, Muyor JM 2020, Int J Environ Res Public Health
#   17(12):4306, doi:10.3390/ijerph17124306, PMID 32560185, PMC7345922 (full
#   text) - a systematic review whose table gives Crommert's static values
#   (% MVIC; rectus abdominis, internal, external oblique): straight arms in
#   front 61, 44, 31; arms crossed on the chest 68, 47, 40; hands behind the
#   neck 81, 62, 59; twisting 52, 57, 49. Used for the toe touch's and the
#   oblique crunch's fractions only.
# - Sternlicht E, Rugg S, Fujii LL, Tomomitsu KF, Seki MM 2007, J Strength
#   Cond Res 21(2):506-509, doi:10.1519/R-20436.1, PMID 17530978 - 41 adults:
#   ball crunches with the ball under the lower lumbar back drew more upper
#   and lower rectus abdominis and external oblique activity than a floor
#   crunch, with the ball under the scapulae less; moving the ball from the
#   upper to the lower back about doubled the activity.
# - Vera-Garcia FJ, Grenier SG, McGill SM 2000, Phys Ther 80(6):564-569,
#   doi:10.1093/ptj/80.6.564, PMID 10842409 - eight men: curl-ups with the
#   upper torso on a ball raised rectus abdominis activity from 21% to 35%
#   MVC and external oblique from 5% to 10% MVC.
# - Monfort-Panego M, Vera-Garcia FJ, Sanchez-Zuriaga D, Sarti-Martinez MA
#   2009, J Manipulative Physiol Ther 32(3):232-244,
#   doi:10.1016/j.jmpt.2009.02.007, PMID 19362234 - a synthesis of 87 EMG
#   studies; safety points include not pulling with the hands behind the
#   head and avoiding active hip flexion and fixed feet.
# - Juker D, McGill S, Kropf P, Steffen T 1998, Med Sci Sports Exerc
#   30(2):301-310, doi:10.1097/00005768-199802000-00020, PMID 9502361 -
#   intramuscular EMG: every sit-up drew more psoas activity (15-35% MVC)
#   than the curl-up (<10%).
# - Andersson EA, Nilsson J, Ma Z, Thorstensson A 1997, Eur J Appl Physiol
#   75(2):115-123, doi:10.1007/s004210050135, PMID 9118976 - the hip flexors
#   (iliacus, rectus femoris, sartorius) were highly active only when hip
#   flexion lifted the upper body or the legs (used for the hip flexor
#   fractions only).
# No EMG study of these five exact lifts as the models do them was found
# (the ACE study's bicycle, ball and vertical-leg crunches are the closest);
# every fraction below is a judgement call anchored on the library's Crunch
# (rectus abdominis 0.80, obliques 0.45), Russian Twist (obliques 0.76,
# rectus abdominis 0.52, hip flexors 0.38) and Reverse Crunch (hip flexors
# 0.42), moved up or down by the ACE rankings and the paint (bright =
# primary, dim = secondary).
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


def abs_glows(name, dx=0.0, dy=0.0, rx=0.09, ry=0.05, hips=None):
    """The abdominals between the lumbar and chest joints; optionally a soft
    glow over the hip flexors (front of the hips)."""
    out = [glow(name, ["spine", "chest"], A, 0.55, rx, ry, dx, dy)]
    if hips:
        out.append(glow(name, ["thigh_L", "thigh_R"], SOFT, 0.28, *hips))
    return out


# ---------------------------------------------------------------- Bicycle Crunch

N = "Bicycle Crunch"
ex(name=N, var="bicycleCrunch",
   # Three-quarter from the feet on the lifter's left (yaw -0.8): the body
   # lies in a band across the middle (u 0.15-0.86, v 0.39-0.61), the legs
   # up on the left, the head on the right. Labels sit above it (the leg and
   # tempo pills left and right of the top, the head pill top right) and below
   # it on the mat (lower back left, rotation right). See the notes' Labels.
   overrides={"legs": (ov(0.24), "leading"), "tempo": (ov(0.16), "trailing"), "neck": (ov(0.27), "trailing"),
              "low": (ov(0.76), "leading"), "twist": (ov(0.76), "trailing")},
   # The head pill's label is short (Hands never pull) so its inner end sits
   # right of the tempo leader, which runs straight down to the left knee
   # whenever that knee is drawn in (review: with Hands cradle the head the
   # leader ran onto the head pill's anchor at 5.5 s).
   annotations=[
       ("twist", "Shoulder to the knee", "chest"),
       ("legs", "Push one leg out long", "foot_L"),
       ("low", "Lower back down", "pelvis"),
       ("neck", "Hands never pull", "head"),
       ("tempo", "Slow, pause each side", "patella_L"),
   ],
   cues={
       "twist": ("Rotation",
                 "Turn the rib cage until the elbow meets the opposite knee.",
                 "The obliques turn the trunk: in a study of twisting curl-ups, the external oblique worked harder when the trunk turned away from its side and the internal oblique when it turned toward it. In an ACE-sponsored study of 13 ab exercises, the bicycle ranked first for the rectus abdominis and second for the obliques.",
                 "Barely turning, the chest still facing the ceiling and the elbow short of the knee.",
                 "Lead with the shoulder: turn until your right elbow reaches your left knee, then turn the other way to meet the right knee."),
       "legs": ("Leg Drive",
                "One knee draws in as the other leg pushes out long, both feet off the floor.",
                "ACE has the knee drive toward the chest while the other leg straightens and stays off the floor, the legs moving in and out along a straight line as the trunk curls and turns. StrengthLog lists the abs and the hip flexors as its secondary muscles.",
                "Paddling with both knees bent, the free leg never straightening.",
                "Push the free leg out until the knee is nearly straight and the foot is well clear of the mat, while the other knee comes in to meet the elbow."),
       "low": ("Lower Back",
               "The lower back stays pressed into the mat as the legs switch.",
               "ACE stresses keeping the low back pressed into the floor as the trunk curls and turns, wants the rotation to come from the trunk, not the hips, and asks you to monitor your lower back carefully.",
               "Letting the lower back arch off the mat as the free leg pushes out.",
               "Brace before the first rep and keep your lower back heavy on the mat; if it starts to lift, slow down."),
       "neck": ("Hand Position",
                "The hands support the head; they never pull it.",
                "A review of abdominal exercise studies lists not pulling with the hands behind the head as a safety point, and ACE asks you to keep the head in line with the upper back rather than pull it forward. The turn has to come from the trunk, not a tug on the neck.",
                "Yanking the head forward with the hands, the chin jammed into the chest.",
                "Rest your fingertips behind your head, elbows wide, and keep a gap between chin and chest as you turn."),
       "tempo": ("Tempo",
                 "Slow and controlled, with a short pause at each side.",
                 "ACE describes the bicycle crunch as slow and controlled, holding each side briefly before switching, and ties the controlled speed to getting the most from the exercise and lowering the risk of injury.",
                 "Pedalling fast, the elbows flapping from side to side.",
                 "Turn to one side, pause for a moment with the elbow at the knee, then switch; take a little over a second for each side."),
   },
   # Paint: obliques and rectus abdominis bright (PRIMARY), sartorius dim
   # (Hip Flexors, SECONDARY, legend-only). Judgement calls: both primaries
   # just above the library's Crunch (rectus 0.80) and Russian Twist
   # (obliques 0.76), since the ACE-sponsored study ranked the bicycle first
   # for the rectus abdominis and second for the obliques, the traditional
   # crunch eleventh for both; obliques first as the library row (OBLIQUES)
   # and StrengthLog (primary obliques). Hip flexors 0.40 as the library's
   # Decline Crunch and a little under the Reverse Crunch's 0.42: they draw
   # the knees in and hold the legs up (Andersson 1997: highly active only
   # when hip flexion lifts the legs or the trunk).
   activation=[("Obliques", P, HI, 0.84), ("Rectus Abdominis", P, HI, 0.82), ("Hip Flexors", S, MOD, 0.40)],
   stabilisers=["transverse abdominis", "neck flexors", "quadriceps"],
   comparison=("CHEST STAYS SQUARE", "Shoulder turns to the knee", "Elbow stops short of the knee",
               "Turning the rib cage brings the elbow to the opposite knee, so the obliques do the rotating.",
               "With the chest left facing the ceiling the elbow stops short and the turn the obliques should make never happens."),
   glows=abs_glows(N, dx=0.03, hips=(0.07, 0.04, -0.02, -0.02)))

SETUP[N] = [
    "Lie on your back on a mat and rest your fingertips behind your head, elbows wide.",
    "Lift both feet off the floor, knees bent and thighs about upright over your hips.",
    "Curl your head and shoulder blades off the mat and keep them up for the whole set.",
    "Press your lower back into the mat and brace your abs.",
]

# ---------------------------------------------------------------- Oblique Crunch

N = "Oblique Crunch"
ex(name=N, var="obliqueCrunch",
   # Framed as the bicycle crunch (yaw -0.8); the crossed left knee stands
   # up in the middle (u 0.53, v 0.43), the planted right foot low left.
   overrides={"twist": (ov(0.16), "trailing"), "neck": (ov(0.24), "trailing"), "lift": (ov(0.72), "trailing"),
              "low": (ov(0.76), "leading"), "tempo": (ov(0.24), "leading")},
   annotations=[
       ("twist", "Right shoulder to left knee", "upper_arm_R"),
       ("lift", "Shoulder blade clears", "scapula_R"),
       ("low", "Lower back down", "pelvis"),
       ("neck", "Hands don't pull", "head"),
       ("tempo", "Hold, lower slowly", "patella_L"),
   ],
   cues={
       "twist": ("Rotation",
                 "Lead with the right shoulder toward the crossed left knee.",
                 "StrengthLog's oblique crunch lifts the upper body diagonally, the shoulder and elbow of one side moving toward the opposite knee. In a twisting curl-up study, the external oblique worked harder when the trunk turned away from its side and the internal oblique when it turned toward it.",
                 "Lifting straight up without turning, the elbows staying level.",
                 "Curl up and turn the right side of your chest toward your left knee as far as you can; the elbow heads for the knee without needing to reach it."),
       "lift": ("Curl Height",
                "The right shoulder blade lifts clear of the mat as you turn.",
                "Coach's crossover crunch lifts the shoulders off the mat with the abs and twists the torso so the elbow moves to meet the knee. Here the lift and the turn happen together, and the right shoulder blade stays up through the turn.",
                "Turning with the head and shoulders kept low, the upper back only half curled.",
                "Curl your head and shoulders up as you turn, and keep the right shoulder blade off the mat until you lower."),
       "low": ("Lower Back",
               "The hips stay square and the lower back stays on the mat.",
               "ACE's crunch keeps the tailbone and lower back on the mat at all times and focuses on drawing the rib cage toward the pelvis. Here only the upper back lifts and turns.",
               "Arching the lower back off the mat to help the turn.",
               "Keep both hips level and your lower back resting on the mat while your upper back lifts and turns."),
       "neck": ("Hand Position",
                "The hands cradle the head; the trunk does the turning.",
                "Coach's crossover crunch lifts without pulling on the neck, and ExRx notes that some people need to keep space between chin and breastbone, particularly with the hands behind the head.",
                "Tugging the head forward with the hands to help the turn.",
                "Keep your fingertips light behind your head and a gap under your chin as you curl and turn."),
       "tempo": ("Tempo",
                 "Turn, hold the turn, then lower slowly.",
                 "Coach's crossover crunch reverses slowly to the start, and FitnessVolt's cross-body crunch lowers slowly to keep tension on the core.",
                 "Bouncing off the mat into quick, short twists.",
                 "Turn in about half a second, hold for a second or so, lower over about a second and rest your shoulders down. Do all your reps on this side, then switch legs."),
   },
   # Paint: obliques bright (PRIMARY), rectus abdominis dim (SECONDARY).
   # Judgement calls: obliques 0.78, the library's Side Plank / Wood Chop
   # value and a little above the Russian Twist's 0.76 (StrengthLog: primary
   # obliques); rectus abdominis 0.52 as the Russian Twist (StrengthLog:
   # secondary abs; Crommert 2021 found it active in twisting curl-ups,
   # unchanged by direction, and Oliva-Lozano 2020's table of that study has
   # the static twisting curl-up at 52% MVIC for it against 81% for the
   # straight curl-up with the hands behind the neck).
   activation=[("Obliques", P, HI, 0.78), ("Rectus Abdominis", S, MOD, 0.52)],
   stabilisers=["transverse abdominis", "neck flexors"],
   comparison=("NO TURN", "Right shoulder turns to the left knee", "Elbows stay level",
               "Turning the right side of the chest toward the crossed knee puts the obliques to work on top of the curl.",
               "Lifting straight up without the turn makes it a plain crunch: the elbow never heads for the knee and the turn the exercise is for never happens."),
   glows=abs_glows(N, dx=0.03))

SETUP[N] = [
    "Lie on your back on a mat, knees bent and feet flat.",
    "Cross your left ankle over your right thigh, just above the knee, and let the left knee fall open.",
    "Rest your fingertips behind your head, elbows wide.",
    "Do all your reps on this side, then cross your right ankle over your left thigh for the other side.",
]

# ---------------------------------------------------------------- Toe Touch Crunch

N = "Toe Touch Crunch"
ex(name=N, var="toeTouchCrunch",
   # From behind the head on the lifter's left (yaw -2.3): the legs stand up
   # on the left (u 0.23-0.46), the trunk and head lie toward the bottom
   # right and rise to the middle at the top (head 0.65,0.71 -> 0.49,0.51).
   overrides={"legs": (ov(0.20), "leading"), "knees": (ov(0.16), "trailing"), "reach": (ov(0.30), "trailing"),
              "neck": (ov(0.42), "trailing"), "tempo": (ov(0.80), "trailing")},
   annotations=[
       ("reach", "Reach by curling up", "hand_R"),
       ("legs", "Feet over the hips", "foot_L"),
       ("knees", "Legs long and still", "toe_R"),
       ("neck", "Head in line", "head"),
       ("tempo", "Pause, roll down slowly", "chest"),
   ],
   cues={
       "reach": ("Curl and Reach",
                 "Reach toward the shoes by curling the shoulder blades off the mat.",
                 "ACE's version keeps curling until the shoulder blades lift completely off the floor; reaching with the arms alone moves the hands, not the trunk. With the legs held straight up and the hands behind the head, a similar crunch ranked fourth of 13 for the rectus abdominis in an ACE-sponsored study, the traditional crunch eleventh.",
                 "Reaching with the arms while the shoulder blades rise only halfway.",
                 "Curl your head and shoulder blades up and reach both hands between your feet until your fingertips are a few centimetres from your shoes."),
       "legs": ("Leg Position",
                "The legs point about straight up over the hips.",
                "ACE keeps the thighs vertical and warns against letting them come past vertical toward you, which shifts your weight from your seat into your lower back.",
                "Letting the legs tip back toward the face to bring the feet closer.",
                "Keep your feet stacked over your hips from the first rep to the last; only the upper body moves."),
       "knees": ("Knees",
                 "The knees stay nearly straight and the legs stay still.",
                 "ACE extends the knees as the legs rise before the first rep and keeps the thighs vertical throughout. Bent knees drop the feet away from the hands.",
                 "Bending the knees so the feet drop away as you curl up.",
                 "Keep your knees long but not locked, toes pointing up, and leave the legs where they are."),
       "neck": ("Head Position",
                "The head rises with the upper back.",
                "ACE asks you to keep the head in line with the upper back and to avoid flexing it too far forward. Craning the chin toward the feet moves the head, not the trunk.",
                "Jutting the chin toward the feet to get the hands closer.",
                "Keep a gap between chin and chest and let your head rise with your shoulders, not ahead of them."),
       "tempo": ("Tempo",
                 "Pause at the top, then roll back down slowly.",
                 "ACE holds the top position, controls the movement speed and rolls the trunk up and down.",
                 "Swinging the arms to throw the shoulders up and dropping straight back.",
                 "Curl up over about a second, hold for a second or so with your hands at your feet, lower over about a second and rest your shoulders on the mat before the next rep."),
   },
   # Paint: rectus abdominis and sartorius bright (PRIMARY: Rectus
   # Abdominis, Hip Flexors), obliques dim (SECONDARY). Judgement calls (no
   # EMG of this lift): rectus abdominis 0.80, the library's Crunch value.
   # The ACE study ranked its vertical leg crunch fourth for it (the crunch
   # eleventh), but that version kept the hands behind the head, and here the
   # arms reach forward, the lightest arm position in Crommert 2021 (static
   # rectus abdominis 61% MVIC with straight arms in front against 81% with
   # the hands behind the neck, per Oliva-Lozano 2020's table); the two pull
   # opposite ways. Hip flexors primary for the paint but only 0.42 (the
   # Reverse Crunch's value): they hold the legs up over the hips without
   # moving them (Andersson 1997: highly active only when hip flexion lifts
   # the legs or the trunk), as the calfseat family kept a bright
   # gastrocnemius at 0.40. Obliques 0.38, under the Crunch's 0.45 and under
   # the bright hip flexors (review: 0.48 put a dim row above a bright one):
   # the arms-forward curl-up drew much less oblique EMG than the
   # hands-behind-the-neck one (internal 44 against 62, external 31 against
   # 59% MVIC), and there is no turn; the ACE study's fifth place for the
   # vertical leg crunch was with the hands behind the head.
   activation=[("Rectus Abdominis", P, HI, 0.80), ("Hip Flexors", P, MOD, 0.42), ("Obliques", S, LOW, 0.38)],
   stabilisers=["transverse abdominis", "quadriceps", "neck flexors"],
   comparison=("ARMS ONLY", "Shoulder blades curl off the mat", "Arms reach, trunk stays low",
               "Curling the shoulder blades up is what brings the hands to the feet, so the rectus abdominis does the reaching.",
               "Reaching with the arms while the back stays low moves the hands without curling the trunk."),
   glows=abs_glows(N, rx=0.07, ry=0.06, hips=(0.06, 0.05, 0.0, -0.02)))

SETUP[N] = [
    "Lie on your back on a mat and press your lower back gently into it.",
    "Raise your legs until they point about straight up over your hips, knees nearly straight.",
    "Reach both arms up toward your feet.",
    "Brace your abs before the first rep.",
]

# ---------------------------------------------------------------- Cross-Body Crunch

N = "Cross-Body Crunch"
ex(name=N, var="crossBodyCrunch",
   # Framed as the bicycle crunch (yaw -0.8): the planted feet low left, the
   # raised knee in the middle (left knee in rep 1, right in rep 2).
   overrides={"knee": (ov(0.24), "leading"), "twist": (ov(0.16), "trailing"), "neck": (ov(0.24), "trailing"),
              "low": (ov(0.76), "leading"), "tempo": (ov(0.76), "trailing")},
   annotations=[
       ("twist", "Elbow to opposite knee", "chest"),
       ("knee", "Knees take turns rising", "patella_L"),
       ("low", "Lower back down", "pelvis"),
       ("neck", "Don't pull the head", "head"),
       ("tempo", "Lower slowly, switch", "chest"),
   ],
   cues={
       "twist": ("Rotation",
                 "Turn the rib cage so the elbow and the opposite knee meet over your middle.",
                 "The obliques help curl the trunk and also turn it: in a study of twisting curl-ups, the external oblique worked harder when the trunk turned away from its side and the internal oblique when it turned toward it.",
                 "Curling straight up without turning, so the elbow passes wide of the knee.",
                 "Curl up and turn your right shoulder toward your left knee until the elbow touches or nearly touches it; on the next rep turn the left elbow to the right knee."),
       "knee": ("Knee Drive",
                "The knee rises to meet the elbow as the trunk curls.",
                "FitnessVolt's cross-body crunch brings the elbow and knee together at the same time, meeting above the belly button. With the knee rising, the two meet over the middle of the body instead of the elbow chasing a knee that stays near the floor.",
                "Leaving the knee low, so it never comes up to meet the elbow.",
                "Draw your knee up toward your chest as you curl and turn, so knee and elbow arrive together."),
       "low": ("Lower Back",
               "The lower back and the other foot stay down.",
               "ACE's crunch keeps the tailbone and lower back on the mat throughout and draws the rib cage toward the pelvis. Here only one knee rises; the other foot stays planted.",
               "Arching the lower back off the mat as the knee comes up.",
               "Keep the other foot flat and your lower back resting on the mat while one knee rises."),
       "neck": ("Hand Position",
                "Fingertips behind the ears, elbows out; the hands never pull.",
                "FitnessVolt warns never to pull on the head in any crunch, and a review of abdominal exercise studies lists not pulling with the hands behind the head among its safety points. A pulled head bends the neck instead of the trunk.",
                "Hauling the head forward with the hands to bring the elbow to the knee.",
                "Rest your fingertips lightly behind your ears, elbows pointing out, and keep your chin a fist's width from your chest."),
       "tempo": ("Tempo",
                 "Hold the touch, then lower slowly all the way down.",
                 "FitnessVolt advises a moderate tempo and a slow return to keep tension on the core. Settling back each rep means the next side starts from the mat instead of bouncing off it.",
                 "Dropping back to the mat and bouncing straight into the other side.",
                 "Hold the elbow at the knee for a second or so, lower over about a second, rest your shoulders and foot down, then turn the other way."),
   },
   # Paint as the bicycle crunch: obliques and rectus abdominis bright
   # (PRIMARY), sartorius dim (Hip Flexors, SECONDARY). Judgement calls: a
   # little under the bicycle (one leg moves, the trunk rests between reps):
   # obliques 0.80, rectus abdominis 0.78, hip flexors 0.38 as the Russian
   # Twist.
   activation=[("Obliques", P, HI, 0.80), ("Rectus Abdominis", P, HI, 0.78), ("Hip Flexors", S, LOW, 0.38)],
   stabilisers=["transverse abdominis", "neck flexors"],
   comparison=("NO TURN", "Elbow meets the opposite knee", "Elbow passes wide of the knee",
               "Turning the chest as the knee rises brings elbow and knee together over the middle, and the obliques make the turn.",
               "Curling straight up leaves the elbow wide of the knee, a plain crunch with a leg lift."),
   glows=abs_glows(N, dx=0.03, hips=(0.07, 0.04, -0.02, -0.02)))

SETUP[N] = [
    "Lie on your back on a mat, knees bent and feet flat about hip-width apart.",
    "Rest your fingertips behind your ears, elbows pointing out to the sides.",
    "Let your lower back settle into the mat and brace your abs.",
]

# ---------------------------------------------------------------- Stability Ball Crunch

N = "Stability Ball Crunch"
ex(name=N, var="stabilityBallCrunch",
   # Side-on from the lifter's left (yaw -1.35): the feet low left, the ball
   # under the back right of centre (u ~0.51-0.85, v ~0.50-0.70), the head
   # top right. Labels above the body and below the thighs, clear of the
   # ball.
   overrides={"ball": (ov(0.24), "leading"), "curl": (ov(0.16), "leading"), "neck": (ov(0.20), "trailing"),
              "feet": (ov(0.80), "leading"), "hips": (ov(0.32), "leading")},
   annotations=[
       ("ball", "Ball under low back", "spine"),
       ("curl", "Ribs toward the hips", "chest"),
       ("feet", "Feet flat, hip-width", "foot_L"),
       ("hips", "Hips low and still", "pelvis"),
       ("neck", "Hands cradle the head", "head"),
   ],
   cues={
       "ball": ("Ball Position",
                "The ball sits under your lower and middle back.",
                "In a study of ball crunches, moving the ball from under the shoulder blades to under the lower back roughly doubled rectus abdominis and external oblique activity, and with the ball low the crunch drew more than one on the floor. ACE sets the mid back on top of the ball with the hips lower on its front.",
                "Lying with the ball high under the shoulder blades, the hips sitting up off its front.",
                "Walk your feet out until the ball supports your lower and middle back, with your hips just in front of it and your head and shoulders free."),
       "curl": ("Spinal Curl",
                "Curl the ribs toward the pelvis while the lower back stays on the ball.",
                "ACE's ball crunch pulls the bottom of the chest toward the top of the pelvis until the upper back leaves the ball, the tailbone and lower back staying on it. Sitting up from the hips brings the hip flexors in: in one study every sit-up drew more psoas activity than the curl-up.",
                "Sitting up off the ball by hinging at the hips, the lower back lifting with the shoulders.",
                "Curl until your upper back is off the ball, hold, then uncurl back onto it; your lower back never leaves the ball."),
       "feet": ("Base of Support",
                "Feet flat and about hip-width apart.",
                "ACE widens the feet when balance is a challenge and moves them closer together as balance improves, to make it harder. The ball already adds work for the trunk: in one study, curl-ups with the upper torso on a ball raised rectus abdominis activity from 21% to 35% of maximum.",
                "Feet drawn close together, leaving a narrow base on the ball.",
                "Plant both feet flat about hip-width apart, knees bent about 90 degrees, and press evenly through them."),
       "hips": ("Hip Height",
                "The hips stay low and bent, in front of the ball.",
                "ExRx notes that some people feel low-back discomfort on a ball crunch when the hips are not bent, and suggests a lower hip position on the ball or a smaller ball; ACE keeps the tailbone and lower back on the ball throughout.",
                "Pushing the hips up into a bridge as you crunch, so the hips straighten.",
                "Keep your hips a little below the top of the ball and let them stay put while your upper body curls."),
       "neck": ("Hand Position",
                "The hands rest behind the head without pulling.",
                "ACE's ball crunch keeps the head in line with the spine with only a slight chin tuck as you curl, and a review of abdominal exercise studies lists not pulling with the hands behind the head among its safety points.",
                "Pulling the head forward with the hands to get up off the ball.",
                "Keep your elbows wide and your neck relaxed, with a slight tuck of the chin as you curl."),
   },
   # Paint: rectus abdominis bright (PRIMARY); obliques and the four
   # quadriceps dim (SECONDARY). Judgement calls: rectus abdominis 0.84,
   # above the Crunch's 0.80 (ACE study: ball crunch third for the rectus
   # abdominis, the crunch eleventh; Sternlicht 2007: more than a floor
   # crunch with the ball under the lower back; Vera-Garcia 2000: 21% ->
   # 35% MVC on a ball). Obliques 0.50, a little above the Crunch's 0.45
   # (Vera-Garcia 2000: external oblique 5% -> 10% MVC; ACE: sixth for the
   # obliques). Quadriceps 0.25, the lowest row: they hold the knees bent
   # with the feet planted; no source measures them here and ACE reported
   # significantly less thigh (rectus femoris) activity in the ball crunch
   # without saying against which exercises; a paint-led value.
   activation=[("Rectus Abdominis", P, HI, 0.84), ("Obliques", S, MOD, 0.50), ("Quadriceps", S, LOW, 0.25)],
   stabilisers=["transverse abdominis", "neck flexors"],
   comparison=("SITTING UP", "Ribs curl toward the hips", "Whole back hinges off the ball",
               "Curling the upper back off the ball while the lower back stays on it keeps the rectus abdominis doing the work.",
               "Hinging up from the hips lifts the whole back off the ball and brings the hip flexors into the lift."),
   glows=abs_glows(N, dx=0.02, rx=0.08, ry=0.05))

SETUP[N] = [
    "Sit on a stability ball, then walk your feet forward and lean back until it supports your lower and middle back.",
    "Set your feet flat about hip-width apart, knees bent about 90 degrees and thighs about level.",
    "Rest your fingertips lightly behind your head, elbows out to the sides.",
    "Let your head and shoulders stay clear of the ball.",
]
