# Trainer content for the 401-500 folder, third round (445-474, 2026-10-05),
# family: plankdyn. Four moving planks from the builder's exports: 450
# Mountain Climber (Abs/MountainClimber), 451 Plank Shoulder Tap
# (Abs/PlankShoulderTap), 452 Plank Hip Dip (Abs/PlankHipDip) and 453 Plank
# Knee to Elbow (Abs/PlankKneeToElbow). Same format as spec.py on top of
# common_1_50.py; spec_500.py imports this module and gen.py reads SPEC /
# SETUP. notes_500_plankdyn.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (SCRATCH/plankdyn/rig.py dumps every joint every frame, skin.py and
# mesh1.py skin the muscle, hand and shoe meshes for heights and gaps, an.py,
# mc.py, twist.py and bend.py give the angles; the app's Y-up space, the
# lifter facing +z, their left +x, the mat's top at y 0), the trainer stills
# at 0/1/2/3/5 s, joints.json and tiers.json. Every clip is 7.96 s on one
# body (torso, neck to pelvis, 0.59 m) on a mat, no other equipment. All four
# are framed three-quarter from the front-left (yaw -0.8, the hip dip -0.6),
# head on the screen's left.
# - Mountain Climber: high plank, hands flat under the shoulders (wrist
#   joints 37 cm apart, shoulder joints 39 cm; the hands 0-1.4 cm ahead of
#   the shoulders), elbows 174-177 deg all clip, ankles about hip-width (22 cm).
#   The hips ride 4-9 cm above the straight line from the shoulders to the
#   back heel (hip angle on the back leg 158-167 deg), the trunk 6-12 deg
#   above level. The legs swap together in ~0.6 s (0.12-0.75 s), both feet
#   briefly off the mat (4.5 cm), then the front knee is drawn a little
#   further in (knee 66 -> 54 deg, hip 82 -> 58 deg) while the hips sink 5 cm
#   (pelvis 0.505 -> 0.451 m at 1.4 s) and come back up by 2.0 s; a swap every
#   2 s. The right knee is in at 0 s, the left 0.75-2.0 s, the right 2.75-
#   4.0 s and so on. The driving knee ends under the chest (knee joint 23-31
#   cm ahead of the hip joints, level with the chest joint, 20-30 cm behind
#   the hands, 12-13.5 cm up), its foot hovering ~2.5 cm off the mat (it
#   never lands); the back leg goes straight (knee 171 deg), toes on the mat.
# - Plank Shoulder Tap: high plank, hands directly under the shoulders,
#   elbows ~175 deg, the body in a straight line (hips on the shoulder-to-
#   ankle line, hip ~172 deg, trunk 16 deg above level), ankles 22 cm apart.
#   The right hand leaves the mat at 0.08 s, its fingers touch the outside of
#   the left shoulder 0.6-1.1 s (skin gap 4 mm, elbow ~98 deg) and it is back
#   down by 1.75 s; the left hand taps the right shoulder 2.08-3.75 s; then
#   again (one tap every 2 s). As a hand lifts, the whole body shifts ~2.5 cm
#   toward the supporting hand; hips and shoulders stay square (0 deg of roll
#   or twist).
# - Plank Hip Dip: forearm plank, elbows directly under the shoulders,
#   forearms parallel (hands 34 cm apart, in fists, palms in), elbows ~93 deg,
#   the body straight (hips within 1.3 cm of the shoulder-to-ankle line),
#   ankles 18 cm apart on the toes. The hips turn about the body's long axis
#   while the shoulders stay square: the right hip down at 1.0 s (hip line
#   tilted 37.5 deg; that side's skin ~8 cm above the mat by the hip joint
#   and ~4 cm at mid-thigh, against ~13 and ~10 cm level), level at 2.0 s,
#   the left hip down at 3.0 s, level at 4.0 s, and again; ~1 s each way, no
#   pause. The knees soften a little (171 -> 164 deg) and the feet pivot on
#   the toes.
# - Plank Knee to Elbow: the shoulder tap's high plank and body line. The
#   left knee comes out to the side and forward 0.08-0.75 s, held to ~1.1 s,
#   back by 1.85 s; the right 2.08-3.88 s; and again. At the hold the knee is
#   bent 79 deg and the hip 62 deg; the knee comes up outside the left arm,
#   behind and below the elbow, the thigh ~9.5 cm from the arm (it never
#   touches; knee joint to elbow joint 20 cm); the foot is off the mat, out to
#   the side. The same side, not across: ACE's Vargo 2017 crosses to the
#   opposite elbow, ACE's Kovar 2014 and the spiderman planks go to the same
#   side, as here. The trunk side-bends ~6 deg toward the knee and the pelvis
#   shifts 3 cm toward it; the hip line stays within ~3 deg of level, the
#   shoulders square.
# Paint (tiers.json): mountain climber, rectus abdominis and sartorius bright,
# anterior deltoid, the obliques and the three triceps heads dim; shoulder
# tap, rectus abdominis bright, anterior deltoid, obliques and triceps dim;
# hip dip, external and internal oblique and rectus abdominis bright, nothing
# dim; knee to elbow, obliques and rectus abdominis bright, anterior deltoid,
# sartorius and triceps dim. The rig paints the hip flexors on the sartorius,
# so that row is "Hip Flexors" (legend-only, as in spec_abs.py).
#
# How they differ from the library: the Plank holds still on the forearms,
# the Side Plank on one forearm, the Push-Up bends the elbows, the Bird Dog
# kneels. None drives the knees in turn from a high plank, takes a hand off
# the floor, turns the hips from a forearm plank or brings a knee out to the
# elbow.
#
# Sources (Europe PMC records read 2026-10-05, full text where noted; web
# pages fetched 2026-10-05, ExRx through the Wayback Machine; details and what
# each supports in the notes):
# - Cugliari G, Boccia G 2017, J Hum Kinet 56:61-71,
#   doi:10.1515/hukin-2017-0023, PMID 28469744 (PMC5384053, full text) - 17
#   active men, four suspension exercises; the knee-tuck (both knees drawn in
#   from a plank with the feet in straps): lower rectus abdominis 54%, upper
#   44%, external oblique 42%, internal oblique 18%, lower and upper erector
#   spinae 8% and 6% MVC (medians), below the roll-out and body saw; its
#   discussion quotes Escamilla's Swiss-ball knee-up (upper and lower rectus
#   32% and 35%) and Power Wheel knee-up (41% and 45%).
# - Escamilla RF, Babb E, DeWitt R, et al. 2006, Phys Ther 86(5):656-671,
#   doi:10.1093/ptj/86.5.656, PMID 16649890 - 21 adults: the Power Wheel
#   pike, knee-up and roll-out were among the exercises with the highest
#   rectus abdominis, oblique and latissimus activity; the pike and knee-up
#   also drew high rectus femoris activity (abstract).
# - Can EN, Harput G, Turgut E 2024, J Strength Cond Res 38(2):245-252,
#   doi:10.1519/JSC.0000000000004622, PMID 37815235 - 21 men, ten low (forearm)
#   and high (hands) plank variations including shoulder taps: the high
#   planks drew more triceps brachii and lower trapezius activity (abstract
#   only; no trunk muscles were measured).
# - Heredia CE, Dawes JJ, Dulla JM, Orr RM, Lockie RG 2024, Int J Exerc Sci
#   17(4):702-719, doi:10.70252/DFRS6310, PMID 38863599 (PMC11166136, full
#   text) - 202 law enforcement recruits; the shoulder-taps screen (after
#   Balfany et al. 2019, not read): a plank with the hands directly beneath the
#   shoulders and the feet shoulder-width, a dowel along the back, the right
#   hand taps the left shoulder and returns, then the left the right, in a
#   controlled manner; feet spread to one and a half shoulder-widths if the
#   recruit cannot; the top score needs the hips not to rotate.
# - NASM, The Plank: Coaching Progressions and Variations for Every Client
#   (Heather Cherry; published 2021, updated 25 July 2026; nasm.org): elbows
#   directly under the shoulders, forearms parallel, feet hip-width; the set
#   ends once the hips sag, pike or rotate; shoulder taps as an anti-rotation
#   challenge, cue keep the hips quiet, success measured by stability rather
#   than fast reps; removing a point of contact increases stabilisation
#   demands; sagging hips as lost anterior core engagement (squeeze the
#   glutes, pull the ribs down); piked hips raised to reduce the challenge.
# - ACE Exercise Library, Mountain Climbers (acefitness.org, no. 258): hands
#   slightly in front of the shoulders, the front foot on the floor, brace,
#   switch legs simultaneously with both feet leaving the ground, the back leg
#   fully extended.
# - ACE articles: Kovar E 2014-11-21, How to Use Gliders for Dynamic Planks
#   (plank with knee to elbow, the feet on gliders in a high plank: the right
#   knee toward the right elbow, then the left to the left); Rohmann R
#   2014-05-28, Strengthen Your Core with this Ab Circuit Workout (BOSU
#   spiderman planks, forearms on the dome: the knee to the outside of the
#   same elbow, foot off the floor, obliques contracted, hips low and facing
#   the floor, lift slowly with minimal movement, hold for a moment);
#   Vargo K 2017-03-08, Plank Variations (alternating hip touches / rainbow
#   planks: rotate the hips to one side aiming to touch the floor, then the
#   other; its knee to elbow crosses to the opposite elbow).
# - StrengthLog, Mountain Climbers (strengthlog.com): plank with the hands
#   about shoulder-width, pull the knee into the chest as far as you can,
#   switch, keep your hips down, as far and as fast as you can; abs primary,
#   obliques secondary.
# - ExRx.net (Wayback Machine): Suspended Mountain Climber (HipFlexors/
#   STMountainClimber, snapshot 2021-04-23: target iliopsoas; with no waist
#   flexion the rectus abdominis and external oblique only stabilise the
#   pelvis and waist during hip flexion; straighten the hip each stroke while
#   keeping the hips at about the same height; stabilisers include the rectus
#   abdominis, obliques, quadriceps, pectoralis major, serratus anterior and
#   triceps); muscle pages Obliques (2026-02-02: lumbar rotation and lateral
#   flexion), Rectus Abdominis (2026-05-28: controls the tilt of the pelvis),
#   Iliopsoas (2024-01-05: hip flexion), Deltoid Anterior (2026-06-23:
#   shoulder flexion), Triceps Brachii (2026-06-22: elbow extension).
# - Motra, Plank Twist (motra.com/exercises/plankTwist, one coaching guide):
#   twist the hips to one side while keeping the shoulders stable, hips rotate
#   only, shoulders over elbows; common mistakes sagging hips, arched lower
#   back, jerky rotations; tempo 2-0-2.
# No EMG study of any of the four as the models do them was found (Europe PMC
# searches for mountain climber, shoulder taps, hip dips, rainbow or rotating
# planks, spiderman and knee-to-elbow planks with EMG terms). Every fraction
# below is a judgement call anchored on the library's nearest lifts (Plank,
# Hanging Knee Raise, Side Plank, Russian Twist, Bicycle Crunch, Dead Bug) and
# the order the closest studies give.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# ---------------------------------------------------------------- Mountain Climber

N = "Mountain Climber"
ex(name=N, var="mountainClimber",
   # Three-quarter from the front-left (yaw -0.8), head on the left: the
   # back runs across v ~0.40-0.45, the hands and the mat at v ~0.60, the
   # feet out to the right at v ~0.54-0.58. The legs swap sides every two
   # seconds, so the left knee and right foot change places under the body;
   # round 1 tracked the left knee from below, and its leader crossed the
   # back-leg leader whenever the right knee was in (0 and 3 s). The knee
   # pill now points at the chest, where the knee is driving, from the top
   # left, with the pace pill under it to the head (its leader stays left of
   # the knee leader); hips top right; hands bottom left; the back-leg pill
   # bottom right to the right foot.
   overrides={"knee": (ov(0.20), "leading"), "pace": (ov(0.30), "leading"),
              "hips": (ov(0.24), "trailing"),
              "hands": (ov(0.72), "leading"), "leg": (ov(0.74), "trailing")},
   annotations=[
       ("knee", "Knee drives toward the chest", "chest"),
       ("hips", "Hips stay low", "pelvis"),
       ("hands", "Hands under shoulders", "hand_L"),
       ("leg", "Push each leg straight back", "foot_R"),
       ("pace", "Swap, then pull in", "head"),
   ],
   cues={
       "knee": ("Knee Drive",
                "Each knee drives in under your chest in turn, its foot just off the mat.",
                "Drawing the knee in is hip flexion, the hip flexors' job. ExRx's suspended version of this drill names the iliopsoas as the target; as long as the waist does not bend, the abs only steady the pelvis and waist while the hip flexes. StrengthLog's guide pulls the knee into the chest as far as you can.",
                "Short strokes that stop with the knee well short of the chest.",
                "Drive the knee forward until it is under your chest, keep the foot just off the mat, then swap."),
       "hips": ("Hip Height",
                "Your hips stay low, just above a straight line from shoulders to heels.",
                "Lifting the hips makes the drill easier: NASM's plank coaching says clients may raise them to reduce the challenge, and StrengthLog's mountain climber guide asks you to keep your hips down.",
                "Lifting the hips to shoulder height while the knees drive in.",
                "Keep the hips just above the line from shoulders to heels; here they sink a little each time the knee comes in, then rise back."),
       "hands": ("Hand Position",
                 "Hands flat under your shoulders, about shoulder-width apart, arms straight.",
                 "With the shoulders stacked over the hands, the straight arms hold the upper body still while the legs move. StrengthLog sets the hands about shoulder-width apart, and ACE's steps place them slightly in front of the shoulders.",
                 "Walking the hands out well in front of the shoulders.",
                 "Set your hands under or just in front of your shoulders and keep them planted, arms straight."),
       "leg": ("Back Leg",
               "The leg going back straightens fully, toes on the mat.",
               "ACE's steps extend the back leg fully behind you, and ExRx's version asks you to straighten the hip on every stroke, so each leg makes a full stroke.",
               "Shuffling with the back knee still bent and low.",
               "Push the heel back until the knee is straight, then bring that leg in as the other goes back."),
       "pace": ("Rhythm",
                "Swap both legs in one quick move, then draw the front knee in a little further.",
                "ACE's steps switch the legs at the same moment, both feet leaving the floor, and StrengthLog runs the knees in and out as far and as fast as you can. Here each swap takes just over half a second and comes every two seconds, a controlled pace rather than a sprint.",
                "Moving one leg after the other, or rushing until the hips bounce.",
                "Swap both legs together, pull the front knee in a touch further, then swap again; go faster only while your hips keep about the same height."),
   },
   # Rectus abdominis and sartorius (Hip Flexors) bright (PRIMARY); obliques,
   # anterior deltoid and triceps dim. No EMG of the floor mountain climber;
   # the closest measured drill, the suspended knee-tuck (Cugliari 2017), drew
   # more rectus abdominis (lower 54%, upper 44% MVC) than external (42%) or
   # internal (18%) oblique, and Escamilla 2006 found the Power Wheel knee-up
   # among the most demanding for the abdominals. So the rectus sits at 0.76,
   # just under the library Plank's 0.78 (a judgement: one moving leg, the
   # feet on the floor rather than strapped). The hip flexors drive each knee
   # in (ExRx: iliopsoas the target), one leg at a time and mostly forward
   # rather than up against gravity, so 0.66, under the Hanging Knee Raise's
   # 0.76. Obliques 0.48, below the rectus as in the knee-tuck and under the
   # Plank's 0.56. Triceps 0.30: they hold the elbows straight, and high
   # planks drew more triceps activity than forearm planks (Can 2024's
   # abstract). The anterior deltoid, also dim, is named with the
   # stabilisers: a third secondary row (OBLIQUES . TRICEPS BRACHII .
   # ANTERIOR DELTOID, 45 characters) overruns the one-line legend (~38).
   # All judgement calls.
   activation=[("Rectus Abdominis", P, HI, 0.76), ("Hip Flexors", P, MOD, 0.66),
               ("Obliques", S, MOD, 0.48), ("Triceps Brachii", S, LOW, 0.30)],
   stabilisers=["transverse abdominis", "anterior deltoid", "serratus anterior", "quadriceps"],
   comparison=("HIPS PIKED", "Hips low, knee to chest", "Hips lifted, knees short",
               "With the hips low and the hands under the shoulders, the abs keep the trunk braced while each knee drives in under the chest.",
               "Lifting the hips makes the drill easier; NASM's plank coaching notes that clients may raise them to reduce the challenge. Keep them down, as StrengthLog asks."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.09, 0.035, 0.0, 0.02),
          glow(N, ["pelvis", "thigh_L"], A, 0.40, 0.05, 0.035, 0.0, 0.03)])

SETUP[N] = [
    "Start on a mat on your hands and toes, hands under your shoulders and about shoulder-width apart.",
    "Straighten your arms and legs, feet about hip-width, hips just above a line from shoulders to heels.",
    "Brace your abs, then drive one knee in under your chest with its foot just off the mat.",
    "Swap legs in one move: that leg goes straight back as the other knee comes in.",
]

# ---------------------------------------------------------------- Plank Shoulder Tap

N = "Plank Shoulder Tap"
ex(name=N, var="plankShoulderTap",
   # As the mountain climber; the right hand rises to the near (left)
   # shoulder at 0.6-1.1 s. The tap pill points at that shoulder from the
   # top left (a leader to the moving hand crossed the near arm or the head
   # in one phase or the other), the tempo pill below it to the head; hips
   # top right; below the mat the line pill bottom left to the near knee and
   # the feet pill bottom right to the right foot. A hands cue was dropped
   # for the feet: a leader to either hand crossed the body while that hand
   # was up. Round 1 had the line pill top right beside the tap pill, its
   # leader running down beside the tap leader.
   overrides={"tap": (ov(0.18), "leading"), "tempo": (ov(0.28), "leading"),
              "hips": (ov(0.24), "trailing"),
              "line": (ov(0.70), "leading"), "feet": (ov(0.76), "trailing")},
   annotations=[
       ("hips", "Hips stay square", "pelvis"),
       ("tap", "Hand to opposite shoulder", "upper_arm_L"),
       ("line", "Straight line, head to heels", "patella_L"),
       ("feet", "Feet about hip-width", "foot_R"),
       ("tempo", "Slow, controlled taps", "head"),
   ],
   cues={
       "hips": ("Square Hips",
                "Your hips stay level and facing the mat while a hand is off the floor.",
                "With one hand up, the body rests on three points and tends to roll toward the free side; NASM uses shoulder taps as an anti-rotation drill with the cue keep the hips quiet. In a published shoulder-tap screen, the top score needs the hips not to rotate. Here the body shifts about 2.5 cm over the supporting hand and the hips stay square.",
                "The hip on the tapping side dropping toward the mat as the hand lifts.",
                "Brace before each tap and shift only slightly over the supporting hand, keeping both hip bones level and pointing at the mat."),
       "tap": ("The Tap",
               "The right hand taps the left shoulder, then the left hand taps the right, each going back to the floor between taps.",
               "Every tap leaves the body on three points, and NASM notes that removing a point of contact increases the stabilising demand. The screen taps the opposite shoulder and returns to the plank each time.",
               "Lifting the hand only partway, well short of the shoulder.",
               "Reach across until your fingers touch the outside of the opposite shoulder, then place the hand back under its own shoulder."),
       "line": ("Body Line",
                "Your body stays in one straight line from head to heels.",
                "NASM's plank coaching ends the set once the hips sag, pike or rotate, and reads sagging hips as the front of the core letting go.",
                "The hips sagging toward the floor between taps.",
                "Squeeze your glutes and pull your ribs down so your hips stay in line with your shoulders and heels."),
       "feet": ("Foot Width",
                "Feet about hip-width apart, toes on the mat.",
                "The feet are two of the three points you stand on while a hand is up, and the further apart they are, the wider that base. The shoulder-tap screen starts with the feet shoulder-width apart and lets you spread them to one and a half shoulder-widths if the taps cannot be done from that first position.",
                "Pressing the feet together, so the hips rock with every tap.",
                "Set your feet about hip-width apart as here, and move them wider if your hips start to turn."),
       "tempo": ("Tempo",
                 "Each tap takes under two seconds, with a brief touch at the shoulder.",
                 "NASM measures success by staying stable rather than finishing reps quickly, and the screen has the taps done in a controlled manner. Here each hand is up for about a second and a half and rests on the shoulder for about half a second.",
                 "Slapping the shoulders quickly while the hips rock side to side.",
                 "Tap slowly enough that your hips stay still, about one tap every two seconds as here."),
   },
   # Rectus abdominis bright (PRIMARY); obliques, anterior deltoid and
   # triceps dim. No trunk EMG of shoulder taps was found (Can 2024 measured
   # only shoulder and scapular muscles). The body holds the Plank's straight
   # line, so the rectus sits at the library Plank's 0.78. A hand off the
   # floor adds a turning load (NASM: anti-rotation), and turning the trunk
   # is the obliques' movement (ExRx), so they sit above the Plank's 0.56 at
   # 0.60, still secondary as painted dim. The anterior deltoid raises the
   # tapping arm (ExRx: shoulder flexion) and steadies the supporting one,
   # 0.36. The triceps hold the supporting elbow straight (high planks drew
   # more triceps activity, Can 2024's abstract); as a third secondary row it
   # would overrun the one-line legend, so it is named with the stabilisers.
   # All judgement calls.
   activation=[("Rectus Abdominis", P, HI, 0.78), ("Obliques", S, MOD, 0.60),
               ("Anterior Deltoid", S, LOW, 0.36)],
   stabilisers=["transverse abdominis", "triceps brachii", "serratus anterior", "gluteus maximus"],
   comparison=("HIPS ROTATING", "Hips square, hand to shoulder", "Hips roll as the hand lifts",
               "With the hips square and the weight shifting only a little over the supporting hand, the trunk holds still against the turn.",
               "When the hips roll toward the lifted hand, the trunk gives in to the rotation the drill trains it to resist; NASM's cue is to keep the hips quiet."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.09, 0.035, 0.0, 0.02),
          glow(N, ["pelvis", "spine"], SOFT, 0.28, 0.06, 0.03, 0.0, 0.02)])

SETUP[N] = [
    "Start in a high plank on a mat, hands directly under your shoulders, arms straight.",
    "Set your feet about hip-width apart; a wider stance makes it easier.",
    "Brace so your body runs in a straight line from head to heels.",
    "Lift one hand to tap the opposite shoulder, put it back down, then tap with the other hand.",
]

# ---------------------------------------------------------------- Plank Hip Dip

N = "Plank Hip Dip"
ex(name=N, var="plankHipDip",
   # Yaw -0.6, head on the left, the body a band across v ~0.43-0.57. Tempo
   # top left to the head; shoulders and line stacked top right, the
   # shoulders pill higher so the two leaders do not cross; the hip pill
   # bottom right, rising to the near hip from below; elbows bottom left.
   overrides={"tempo": (ov(0.24), "leading"), "shoulders": (ov(0.18), "trailing"),
              "line": (ov(0.28), "trailing"),
              "hips": (ov(0.70), "trailing"), "elbows": (ov(0.76), "leading")},
   annotations=[
       ("hips", "Hip turns down, no touch", "thigh_L"),
       ("shoulders", "Shoulders stay square", "upper_arm_L"),
       ("line", "Hips up, body long", "spine"),
       ("elbows", "Elbows under shoulders", "forearm_L"),
       ("tempo", "Slow, even turns", "head"),
   ],
   cues={
       "hips": ("Hip Turn",
                "Your hips turn so one hip lowers toward the mat, then the other, each stopping just above it.",
                "Turning the hips while the rib cage stays put twists the trunk, and rotating and side-bending the lower spine is the obliques' job (ExRx). ACE's version, the rainbow plank, turns the hips to one side aiming to touch the floor; here the lower hip and thigh stop a few centimetres above the mat.",
                "Turning the hips only a little, the lower hip staying well above the mat.",
                "Roll the hips until the lower hip is just above the mat, then roll back through the middle to the other side."),
       "shoulders": ("Square Shoulders",
                     "Only the hips turn; your shoulders stay level over the elbows.",
                     "If the shoulders roll with the hips, the body turns in one piece and the twist between the rib cage and the pelvis is lost. One coaching guide for this plank twist keeps the shoulders stable and lets only the hips rotate.",
                     "The shoulders rolling with the hips, one shoulder dropping toward the mat.",
                     "Press both forearms evenly into the mat and keep your shoulders level while the hips turn under them."),
       "line": ("Body Line",
                "Between turns your body is straight from head to heels, hips in line with your shoulders.",
                "One coaching guide lists sagging hips and an arched lower back among this exercise's common mistakes, and NASM's plank coaching reads sagging hips as the front of the core letting go.",
                "The hips sinking toward the mat as they pass through the middle.",
                "Squeeze your glutes and keep your hips up in line with your shoulders each time they pass through the middle."),
       "elbows": ("Elbow Position",
                  "Elbows directly under your shoulders, forearms parallel, fists resting on the mat.",
                  "NASM sets the forearm plank with the elbows directly under the shoulders and the forearms parallel. Stacked like this, the upper arms hold the body up while the hips turn.",
                  "Placing the elbows out in front of the shoulders.",
                  "Set the elbows under the shoulders and the forearms parallel, and keep them still for the whole set."),
       "tempo": ("Tempo",
                 "Each turn takes about a second down and a second back, with no pause in the middle.",
                 "One coaching guide lists jerky rotations as a common mistake and gives a tempo of two seconds each way. Here the hips take about a second each way.",
                 "Swinging the hips quickly from side to side.",
                 "Turn slowly to one side, come back through the middle and turn to the other, breathing steadily."),
   },
   # External and internal oblique and rectus abdominis bright (PRIMARY),
   # nothing dim, so no secondary rows. Turning the hips against still
   # shoulders twists the lumbar spine, the obliques' movement (ExRx), so they
   # lead at 0.80, beside the library's Side Plank (0.78) and Russian Twist
   # (0.76), under the Bicycle Crunch (0.84); the library row's muscle is
   # OBLIQUES. The rectus abdominis holds the forearm plank's line (the
   # library Plank's 0.78) and is lower here at 0.70, since the hips turn
   # through it rather than hold it still. No EMG of the hip dip or the
   # rainbow plank was found. All judgement calls.
   activation=[("Obliques", P, HI, 0.80), ("Rectus Abdominis", P, HI, 0.70)],
   stabilisers=["transverse abdominis", "anterior deltoid", "serratus anterior", "gluteus maximus"],
   comparison=("SHOULDERS ROLLING", "Hips turn, shoulders square", "Whole body rolls with the hips",
               "With the shoulders square over the elbows, the hips turn against the rib cage and the obliques do the twisting.",
               "When the shoulders roll along, the body turns in one piece and the twist the obliques should make is lost."),
   glows=[glow(N, ["spine", "pelvis"], A, 0.55, 0.08, 0.035, 0.0, 0.02),
          glow(N, ["chest", "spine"], SOFT, 0.28, 0.06, 0.03, 0.0, 0.02)])

SETUP[N] = [
    "Start on a mat on your forearms and toes, elbows directly under your shoulders, forearms parallel.",
    "Rest your fists on the mat and set your feet about hip-width apart.",
    "Lift your hips so your body is straight from head to heels, and brace.",
    "Turn your hips so one hip lowers toward the mat, then turn back through the middle to the other side.",
]

# ---------------------------------------------------------------- Plank Knee to Elbow

N = "Plank Knee to Elbow"
ex(name=N, var="plankKneeToElbow",
   # As the shoulder tap, framed smaller (zoom 0.603). Tempo top left to the
   # head; line and hips stacked top right (line higher, so the leaders do
   # not cross); the knee pill bottom right reaches the near knee in both
   # phases from below; hands bottom left.
   overrides={"tempo": (ov(0.24), "leading"), "line": (ov(0.20), "trailing"),
              "hips": (ov(0.30), "trailing"),
              "knee": (ov(0.72), "trailing"), "hands": (ov(0.76), "leading")},
   annotations=[
       ("knee", "Knee out to the same elbow", "patella_L"),
       ("hips", "Hips facing the mat", "pelvis"),
       ("line", "Hips down, body straight", "spine"),
       ("hands", "Hands under shoulders", "hand_L"),
       ("tempo", "Slow, pause at the elbow", "head"),
   ],
   cues={
       "knee": ("Knee Path",
                "The knee comes out to the side and forward toward the elbow on the same side, its foot off the mat.",
                "The hip flexes and opens to bring the knee out and forward, and the trunk bends a little toward it, a side bend the obliques make (ExRx). ACE's glider plank with knee to elbow draws the right knee toward the right elbow, then the left toward the left; here the knee stops about 10 cm short of the arm.",
                "Stopping with the knee out to the side, well back from the elbow.",
                "Draw the knee outside your arm toward the elbow, keep the foot off the mat, then take it back."),
       "hips": ("Hips Square",
                "Your hips stay level and facing the mat while the knee comes in.",
                "With a foot off the floor the pelvis rests on one leg, and the trunk has to stop it rolling open. ACE's BOSU spiderman plank keeps the hips low and facing the floor as the knee comes to the elbow; here they stay within a few degrees of level.",
                "The working hip rolling up toward the ceiling as the knee comes in.",
                "Keep both hip bones pointing at the mat and bring the knee only as far as you can without that hip turning up."),
       "line": ("Body Line",
                "Your hips stay down, in line with your shoulders and the foot still on the floor.",
                "Lifting the hips makes room for the knee but makes the plank easier; NASM's plank coaching says clients may raise them to reduce the challenge, and ACE's BOSU spiderman plank keeps them low.",
                "Piking the hips up to make room for the knee.",
                "Keep your hips in line with your shoulders while the knee travels, and bring it only as high as that allows."),
       "hands": ("Hand Position",
                 "Hands under your shoulders, arms straight, both hands down the whole time.",
                 "With the hands stacked under the shoulders, the straight arms hold the upper body still while a leg moves; a published high-plank screen starts with the hands directly beneath the shoulders.",
                 "Setting the hands out in front of the shoulders.",
                 "Place the hands under your shoulders and press the floor away, keeping the arms straight as each knee moves."),
       "tempo": ("Tempo",
                 "The knee travels out in under a second, pauses briefly by the elbow, and goes back as smoothly.",
                 "ACE's BOSU spiderman plank lifts the leg slowly with minimal movement, holds for a moment and returns to the plank before the other side. Here each knee takes about two seconds there and back.",
                 "Swinging the knee up and kicking it back.",
                 "Bring the knee in under control, hold it by the elbow for a moment, put the foot back down, then switch legs."),
   },
   # Obliques and rectus abdominis bright (PRIMARY); sartorius (Hip
   # Flexors), anterior deltoid and triceps dim. No EMG of this drill; the
   # body holds the Plank's line while one knee drives out and the trunk
   # side-bends toward it (the obliques' movement, ExRx). The rectus, the
   # library row's muscle, is listed first at 0.74 and the obliques at 0.72,
   # both a touch under the Plank's 0.78 on the rectus since one leg moves
   # through the hold. Hip flexors 0.50: they drive one knee out and forward
   # (as the mountain climber's 0.66, less since the knee travels out to the
   # side; dim, so secondary). Triceps 0.30 (high plank; Can 2024's
   # abstract). The anterior deltoid, also dim, is named with the
   # stabilisers for the one-line legend. All judgement calls.
   activation=[("Rectus Abdominis", P, HI, 0.74), ("Obliques", P, HI, 0.72),
               ("Hip Flexors", S, MOD, 0.50), ("Triceps Brachii", S, LOW, 0.30)],
   stabilisers=["transverse abdominis", "anterior deltoid", "serratus anterior", "quadriceps"],
   comparison=("HIP ROLLING OPEN", "Knee to elbow, hips square", "Hip rolls up with the knee",
               "With the hips facing the mat, the trunk holds the pelvis while the hip brings the knee out to the elbow.",
               "When the hip rolls up, the pelvis turns to make room for the leg and the trunk stops holding it square."),
   glows=[glow(N, ["spine", "chest"], A, 0.55, 0.08, 0.035, 0.0, 0.02),
          glow(N, ["pelvis", "spine"], A, 0.40, 0.05, 0.03, 0.0, 0.02)])

SETUP[N] = [
    "Start in a high plank on a mat, hands under your shoulders and arms straight.",
    "Set your feet about hip-width apart and brace so your body is straight from head to heels.",
    "Lift one foot and draw that knee out to the side toward the elbow on the same side.",
    "Put the foot back down, then do the same with the other leg.",
]
