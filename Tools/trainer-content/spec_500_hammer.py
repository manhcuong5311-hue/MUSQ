# Trainer content for the 401-500 folder (2026-10-04), family: hammer. Five
# curls and a wrist roller from the builder's 246-275 set: 246 Rope Hammer
# Curl (Biceps/RopeHammerCurl), 248 Cross-Body Hammer Curl
# (Biceps/CrossBodyHammerCurl), 249 Incline Hammer Curl
# (Biceps/InclineHammerCurl), 251 Zottman Curl (Biceps/ZottmanCurl), 262
# Dumbbell Reverse Curl (Biceps/DumbbellReverseCurl) and 275 Wrist Roller
# (Forearms/WristRoller). Same format as spec.py on top of common_1_50.py;
# spec_500.py imports this module and gen.py reads SPEC / SETUP.
# notes_500_hammer.md maps the copy's claims to the sources below and
# records the model facts.
#
# What the models show, from the briefs (SCRATCH/briefs/<Resource>.md), the
# trainer stills at 0/1/2/3/5 s (SCRATCH/stills), tiers30.json, joints.json
# and the rigs and equipment read from the USD with Blender's Python + pxr
# (SCRATCH/hammer/rig.py, sample.py, arm.py, rope*.py, roller.py, incl.py; the
# app's Y-up space, the lifter facing +z, their left +x; torso, neck to
# pelvis, 0.592 m). Every clip is 7.96 s. The palm direction is the hand
# joint's +z (the brief's "palm" words agree with it).
# - Rope Hammer Curl: standing ~0.6 m behind one low pulley (12 cm up, on the
#   midline, ~0.4 m ahead of the toes), feet ~0.3 m apart, knees soft
#   (167°), the trunk leaning ~8° back and still all clip. A rope on the
#   cable, one end in each hand just under its knob (the knobs above the
#   thumbs), palms facing each other the whole rep, wrists straight. Both
#   arms curl together: elbows 152° -> 54°, so every rep starts ~28° short of
#   straight; the upper arms stay ~5° forward of the trunk (the elbows move
#   under 2 cm). The rope ends stay ~0.3 m apart (not pulled apart at the
#   top). Two 4 s reps: still to ~0.4 s, up ~1.1 s, the top held ~0.6 s
#   (1.5-2.1 s), down ~1.5 s, a short pause. The stack rises ~0.48 m and
#   stays ~6 cm off its rest at the bottom. From the rope's swivel the cable
#   runs to the pulley 13-21° off vertical (down and a little forward); each
#   rope end pulls its hand down, in and forward toward the swivel. The share
#   of that pull turning the elbow (the rope's moment about the elbow per unit
#   pull and forearm length) is 0.10 at the bottom (a free weight held the
#   same way: 0.60), 0.66 at 125°, 0.90-0.96 from ~105° to ~80°, 0.82 at the
#   top (free weight 0.64): light at the start, hardest from halfway up to the
#   top. Framed from the right side (yaw +1.4), like the library's Cable
#   Hammer Curl, the lifter facing the column at the right of the frame.
# - Cross-Body Hammer Curl: standing tall, feet ~0.3 m apart, knees 174°,
#   trunk upright and still. A dumbbell in each hand, handles front to back,
#   palms facing in; the arms hang ~14° out from the sides, elbows ~170°. The
#   arms alternate: the LEFT curls 0-4 s (up 0.4-1.4 s, held to 2.0 s, down
#   2.0-3.5 s), the right 4-8 s; the resting arm hangs still. The working
#   dumbbell travels up and across: the elbow 170° -> 72°, the upper arm
#   coming ~30° forward and a little in (the elbow ~14 cm forward and ~4.5 cm
#   in, most of it in the first half of the curl), the forearm turning in
#   across the chest. It finishes in front of the middle of the chest: the
#   dumbbell's centre on the midline, ~6 cm below shoulder height and ~26 cm
#   in front, the hand ~15 cm in from its own shoulder and ~10 cm below it,
#   the palm facing the chest, thumb up. Wrists straight. Framed at yaw -0.4,
#   nearly face-on (the left arm on the right of the screen).
# - Incline Hammer Curl: seated on an incline bench whose back pad slopes
#   ~52° from the floor, the trunk ~42° back from vertical against it, feet
#   flat in front (knees 137°). A dumbbell in each hand, palms facing in
#   (thumbs up) the whole rep. The upper arms hang straight down (vertical,
#   ~8° out), 42° behind the line of the trunk, and stay there (the elbows
#   move ~3 cm, ~6° forward at the top); both arms curl together, elbows
#   170° -> 55°, the dumbbells finishing ~11 cm below and ~21 cm in front of
#   the shoulders. Timing as the rope curl (up 0.4-1.5 s, held to 2.1 s, down
#   to ~3.6 s). Framed from the front-left at yaw -0.9, small (zoom 0.692),
#   the head at the right, the feet at the left; the near (left) arm hangs
#   beside the pad.
# - Zottman Curl: standing tall, feet ~0.3 m apart, trunk upright and still;
#   a dumbbell in each hand, handles side to side; at the bottom the arms hang
#   ~17° out from the sides (elbows 170°), palms facing forward. Both arms
#   together: curled palms up (0.25-1.1 s), elbows 170° -> 52°, the upper
#   arms coming in to the sides (17° -> ~5° out) and ending ~12° forward;
#   at the top the forearms turn the palms down (1.25-1.75 s) while the
#   elbows open a little (52° -> 60°); lowered palms down over ~1.25 s
#   (2.0-3.25 s) to 170°; at the bottom the forearms turn the palms forward
#   again (3.5-3.9 s). Wrists straight throughout. Yaw -0.4.
# - Dumbbell Reverse Curl: standing tall, feet ~0.3 m apart, knees 174°,
#   trunk upright and still. Dumbbells overhand, handles side to side, hands
#   ~0.44 m apart (the shoulder joints are 0.39 m apart): palms facing back
#   with the dumbbells in front of the thighs, down at the top; wrists
#   straight. The upper arms stay ~14° forward of vertical (the elbows a few
#   cm in front of the trunk; 16° at the top); elbows 166° -> 56°, the
#   dumbbells finishing in front of the shoulders (~9 cm below them, ~24 cm
#   in front). Up 0.4-1.4 s, held to 2.0 s, down 2.0-3.5 s. Yaw -0.4.
# - Wrist Roller: standing tall, feet ~0.32 m apart, knees ~175°, trunk
#   upright and still. A wrist roller: a 0.5 m handle with a grip either side
#   of a central spool, the cord tied to the spool and a plate on its end.
#   Overhand grip, hands ~0.30 m apart; the arms held out in front, a little
#   below shoulder height (shoulders flexed 62-78°, hands 5-15 cm below the
#   shoulder joints and ~0.5 m in front), elbows soft (154-164°). The cord
#   hangs from the side of the spool nearer the lifter. Winding: the
#   roller's top turns away from the lifter (forward and down), so the cord
#   winds up its near side; each turn is one hand bending its wrist forward
#   and down (from ~44° bent back to ~26-28° bent forward) to turn the roller
#   ~76°, while the other hand bends back to regrip; the RIGHT hand turns
#   first. Six turns of ~0.4-0.6 s, with short pauses, wind the plate up
#   ~24 cm (its bottom from 2 cm to 26 cm off the floor; 465° of roller) in
#   3.5 s; it is held to 3.75 s; six turns the other way lower it back to
#   2 cm by 7.75 s, the gripping wrist going from bent forward to bent back
#   as the plate unwinds. The arms rise and fall a little with each turn
#   (elbow 154-164°, shoulder 62-78°). Framed from the front-left at yaw
#   -0.7: the roller across the upper left, the cord and plate down the left
#   of the legs.
# - Highlight tiers (tiers30.json): on the four curls with hand turns or a
#   neutral grip (rope, cross-body, incline, Zottman) and the reverse curl,
#   the biceps (both heads), brachialis, brachioradialis, the wrist and finger
#   flexors (FCR, PL, FDS, FDP) and extensors (ECRL, ECRB, ECU, ED) are all
#   bright, nothing dim. On the Wrist Roller the brachioradialis and the same
#   forearm flexors and extensors are bright, the biceps (both heads) and the
#   anterior deltoid dim. All bright groups are primary rows; the forearm
#   flexors and extensors share one "Forearms" row on the curls, as on the
#   library's Dumbbell Curl (one legend line), and get a row each on the
#   roller, where they are the target.
#
# How they differ from the library: the Cable Hammer Curl uses two wide low
# pulleys and D-handles and starts from straight arms; the rope curl is one
# pulley in front, a rope, a slight lean back and a 152° start. The
# Alternating Hammer Curl curls each dumbbell straight up beside its own
# shoulder with the elbow nearly still; the cross-body curl carries it
# across to the middle of the chest and lets the elbow come ~30° forward. The
# Incline Dumbbell Curl sits on a 65° pad (trunk 25° back) and turns the
# palms up; the incline hammer curl sits on a ~52° pad (trunk 42° back) and
# keeps the palms in. The Reverse Curl uses an EZ bar; the dumbbell reverse
# curl turns the palms fully down. No library lift turns the palms over
# mid-rep (Zottman) or winds a roller.
#
# Sources (abstracts or full texts read on Europe PMC / PubMed / PMC
# 2026-10-04 unless noted; details and quotes in notes_500_hammer.md):
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Cè E 2023, Sports 11(3):64, doi:10.3390/sports11030064, PMID 36976950
#   (full text PMC10054060) — ten competitive bodybuilders, standing
#   bilateral cable curls at 8RM (a 42.5 cm bar for the supinated and
#   pronated grips, a rope for the neutral grip, arms parallel to the trunk,
#   1-2-1-2 s): lifting phase, biceps +19% supinated vs pronated, +12% vs
#   neutral, neutral +7% vs pronated; brachioradialis +5-6% supinated vs both;
#   anterior deltoid +6% pronated and +9% neutral vs supinated; lowering
#   phase, no grip difference for the biceps or brachioradialis, the anterior
#   deltoid +5% pronated vs supinated; every muscle lower lowering than
#   lifting. Discussion: the brachialis, the most powerful elbow flexor, does
#   not insert on the radius and takes no part in supination; the pronated
#   grip is expected to need more wrist stabilisation toward extension.
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2023, J Funct
#   Morphol Kinesiol 8(1):13, doi:10.3390/jfmk8010013, PMID 36810497 (as
#   read for the 1-50 curls) — flexing the arms forward during barbell curls
#   raised anterior deltoid excitation.
# - Kohn S, Smart RR, Jakobi JM 2018, Physiol Rep 6(1):e13560,
#   doi:10.14814/phy2.13560, PMID 29333724 (PMC5789656) — eleven men,
#   isometric elbow-flexion MVC: supinated 213.6 N, neutral 243.6 N,
#   pronated 113.6 N; lower voluntary activation and a mechanical
#   disadvantage when pronated.
# - Kleiber T, Kunz L, Disselhorst-Klug C 2015, Front Physiol 6:215,
#   doi:10.3389/fphys.2015.00215, PMID 26300781 — 16 subjects, slow elbow
#   flexions: the brachioradialis contributed more only with the hand
#   pronated; biceps activity unchanged with hand position.
# - Boland MR, Spigelman T, Uhl TL 2008, J Hand Surg Am 33(10):1853-1859,
#   doi:10.1016/j.jhsa.2008.07.019, PMID 19084189 — fine-wire EMG: no
#   difference in brachioradialis activation in elbow flexion across the
#   three forearm positions; more activity lifting (23% MVIC) than lowering
#   (11%).
# - Mogk JP, Keir PJ 2003, Ergonomics 46(9):956-975,
#   doi:10.1080/0014013031000107595, PMID 12775491 — gripping: extensor
#   activity larger than flexor at low to mid grip forces and always greater
#   with the forearm pronated; a flexed wrist cut maximum grip force by
#   40-50%.
# - Snijders CJ, Volkers AC, Mechelse K, Vleeming A 1987, Med Sci Sports
#   Exerc 19(5):518-523, doi:10.1249/00005768-198710000-00016, PMID 3683157 —
#   grasping always makes a flexing moment at the wrist, balanced by extensor
#   activity.
# - Oliveira LF, Matta TT, Alves DS, Garcia MA, Vieira TM 2009, J Sports Sci
#   Med 8(1):24-29, PMID 24150552 (full text PMC3737788) — 22 subjects at 40%
#   of an isometric MVC: the incline dumbbell curl (50° of trunk
#   hyperextension, the arm hanging) and the standing dumbbell curl gave
#   similar biceps long-head activation over the whole range; "The shoulder
#   hyperextension, elicited by the IDC protocol, stretches the long head of
#   biceps brachii".
# - Kassiano W, Costa B, Kunevaliki G et al. 2025, Int J Sports Med
#   46(5):334-343, doi:10.1055/a-2517-0509, PMID 39809454 — 63 young women,
#   8 weeks: the incline biceps curl grew proximal elbow-flexor thickness
#   more than the preacher curl (the preacher curl more distally). Read,
#   not used in the copy: it trained a palms-up incline curl.
# - Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE, Bottaro M 2012,
#   J Strength Cond Res 26(8):2140-2145, doi:10.1519/JSC.0b013e31823a3b15,
#   PMID 22027847 — 10 weeks, untrained young men: full-range elbow-flexor
#   training raised the 1RM more than partial range (25.7% vs 16.0%);
#   thickness rose in both.
# - ExRx.net (Wayback Machine; the live site returns 403): Cable Hammer Curl
#   (snapshot 2023-01-13, WeightExercises/Brachioradialis/CBHammerCurl: grasp a
#   cable rope palms in, arms straight down to the sides; elbows to the
#   sides, raise until the forearms are vertical, lower until the arms are
#   fully extended; the elbows can travel forward slightly at full flexion;
#   target brachioradialis, synergists brachialis and biceps, stabilisers
#   anterior deltoid, upper and middle trapezius, levator scapulae, flexor and
#   extensor carpi radialis); Dumbbell Hammer Curl (2023-05-28: palms in,
#   elbows to the sides, one arm then the other, thumb toward the shoulder;
#   the same muscles); Dumbbell Incline Curl (2023-05-31: sit back on a 45-60
#   degree incline bench, arms hanging straight, palms in at the start, the
#   forearm turned up as it rises; target biceps, synergists brachialis and
#   brachioradialis, stabilisers anterior deltoid and wrist flexors); Barbell
#   Reverse Curl (2024-01-05: shoulder-width overhand grip, elbows to the
#   sides, lower until the arms are fully extended; target brachioradialis,
#   stabilisers include the wrist extensors); Cable Roller Wrist Flexion
#   (2021-04-10: stand behind the plate on the floor, overhand on the wrist
#   roller handle; one hand holds while the other slides behind the handle by
#   bending back and regrips, then flexes; alternate until the plate is up
#   near the hands; lower steadily with the opposite movement; target wrist
#   flexors, stabilisers brachioradialis, biceps, brachialis, anterior
#   deltoid, upper and middle trapezius, levator scapulae, wrist extensors);
#   Cable Roller Wrist Extension (2021-04-22: the same with the regrip in
#   front of the handle by flexing and the turn by bending back; target wrist
#   extensors).
# - StrengthLog (strengthlog.com, fetched 2026-10-04): Hammer Curl (feet
#   hip-width, core braced so the body does not swing; elbows close to the
#   body, forward movement loads the front delts; keep the grip neutral, it
#   is easy to start twisting the wrists; half reps a sign of too much
#   weight); Cable Curl With Rope (rope on the low pulley, neutral grip, a
#   step back; the upper arm still or slightly forward; the neutral grip
#   slightly unloads the biceps); Incline Dumbbell Curl (arms hang straight
#   down; the biceps start on the shoulder blade, so they work at a longer
#   length with the arm behind the body); Zottman Curl (curl palms up, turn
#   the palms down at the top, lower slowly with the reverse grip, turn back
#   at the bottom; biceps primary, forearm flexors secondary); Reverse
#   Dumbbell Curl (overhand, arms hanging; upper arms at the sides or slightly
#   forward); Wrist Roller (arms fully extended in front; roll the bar to wind
#   the rope and lift the weight, then slowly reverse; primary forearm
#   extensors); How to Train Your Forearm Extensors (reverse curls shift work
#   onto the brachioradialis and recruit the wrist extensors to stabilise;
#   use less weight than a regular curl; the wrist roller winds the rope to
#   lift the weight, then controls it as it unrolls); The 10 Best Forearm
#   Exercises (the pronator teres and quadratus turn the palm down, the
#   supinator up; listed with the Zottman curl's stabilisers).
# - Catalyst Athletics, Zottman Curl (exercise library, Greg Everett,
#   fetched 2026-10-04): curl supinated, rotate at the top, lower under
#   control pronated, supinate at the bottom; reverse curls tend to be weaker
#   than supinated, so lifting supinated and lowering pronated allows heavier
#   weights.
# - Bodybuilding.com, Cross-body hammer curl (Wayback snapshot 2024-01-19;
#   the live page is gone): palms in, without twisting, curl one dumbbell up
#   toward the opposite shoulder, touch it to the shoulder and hold a second,
#   lower along the same path, then the other arm, alternating; main muscle
#   biceps, level beginner. Jefit, Dumbbell Hammer Curl (Cross Body) and
#   Fitbod, Cross Body Hammer Curls (fetched 2026-10-04) describe the same
#   path.
# Evidence is thin: no EMG study of a rope, cross-body or incline hammer
# curl, a Zottman curl, a dumbbell reverse curl or a wrist roller was found
# (Europe PMC searches "hammer curl", "zottman", "wrist roller", 2026-10-04).
# The fractions are judgement calls anchored to the library's values for the
# nearest lift (Cable / Alternating Hammer Curl, Dumbbell Curl, Reverse
# Curl, the wrist curls) and to the grip comparisons above; each is noted
# at its row and in the notes.
from common_1_50 import *


def ov(final):
    """Pre-squeeze override row for an on-screen row (spec_500.row() maps
    0.14-0.86 to 0.16-0.80)."""
    return round(0.14 + (final - 0.16) * (0.86 - 0.14) / (0.80 - 0.16), 4)


# ---------------------------------------------------------------- Rope Hammer Curl

N = "Rope Hammer Curl"
ex(name=N, var="ropeHammerCurl",
   # Side-on from the right (yaw +1.4): the lifter at the left-middle facing
   # right, the hands and rope sweeping u 0.5-0.62, the column (static posts
   # and cables, the stack moving at the right edge) from u ~0.75. The body
   # cues sit at the left, short enough to end before the back; the grip
   # and range cues sit at the right above the stack and over the pulley
   # base, their leaders running to the hands.
   overrides={"grip": (ov(0.16), "trailing"), "shoulder": (ov(0.24), "leading"), "elbow": (ov(0.36), "leading"),
              "torso": (ov(0.48), "leading"), "range": (ov(0.72), "trailing")},
   annotations=[
       ("elbow", "Elbows still", "forearm_R"),
       ("range", "Lower to a slight bend", "hand_L"),
       ("grip", "Thumbs up, wrists straight", "hand_R"),
       ("torso", "Body still", "pelvis"),
       ("shoulder", "No shrug", "upper_arm_R"),
   ],
   cues={
       "elbow": ("Upper Arm Position",
                 "The upper arms stay by your sides; only the forearms move.",
                 "With the upper arms still, bending the elbows is the only motion, so the elbow flexors lift the rope. Elbows that drift forward bring the front deltoids in and turn the top of the curl into a front raise.",
                 "Elbows drifting forward as the rope comes up.",
                 "Keep your elbows close to your ribs and curl until the knobs come up toward your chin, without letting the elbows travel forward."),
       "range": ("Range of Motion",
                 "Each rep starts with the elbows only slightly bent.",
                 "From a pulley low in front, the rope runs down almost along your forearms while they hang, so it barely resists the first part of the curl and pulls hardest from halfway up to the top. Lowering to a slight bend still takes the elbows through most of their range, and full-range curl training has built more strength than mid-range partial reps.",
                 "Half reps that turn round with the forearms still near level.",
                 "Lower under control until your elbows are only slightly bent and the stack is still just off its rest, then curl again."),
       "grip": ("Grip and Wrists",
                "Palms face each other, thumbs up under the knobs.",
                "The neutral grip is what makes this a hammer curl: in a cable study using this rope grip the biceps worked a little less than with the palms up, while the brachialis bends the elbow whatever the grip. Each rope end pulls its hand down toward the cable, so the wrists have to hold the hands straight.",
                "Letting the rope tip the hands down at the wrists, toward the little fingers.",
                "Hold each rope end just under its knob, palms facing each other and knuckles in line with the forearms, from the bottom to the top."),
       "torso": ("Body Position",
                 "A slight lean back, held still.",
                 "Leaning back a little and bracing gives a steady base against the cable's pull toward the stack. Rocking further back to start each rep borrows momentum from the hips and lower back, so the elbow flexors skip the hardest part of the curl.",
                 "Rocking back and pushing the hips forward to swing the rope up.",
                 "Stand tall with a slight lean back, knees soft and core braced, and keep your hips and shoulders still from the first rep to the last."),
       "shoulder": ("Shoulder Position",
                    "The shoulders stay down and back.",
                    "With a neutral grip the front deltoids already work a little harder than with the palms up, most likely to steady the shoulders. Rolling the shoulders forward and up at the top adds a shrug, so the shoulders rather than the elbow flexors finish the lift.",
                    "Shoulders rolling forward and shrugging up as the rope reaches the top.",
                    "Set your shoulders down and back before the first rep and finish every curl without moving them."),
   },
   # All bright: one primary row each for the elbow flexors and one
   # Forearms row for the wrist and finger flexors and extensors. Values as
   # the library's Cable Hammer Curl (Brachialis 0.76, Biceps 0.74,
   # Brachioradialis 0.42; Coratella 2023 Sports measured this rope grip:
   # biceps 12% and brachioradialis 6% under the palms-up bar in the
   # lifting phase). Forearms 0.30 as the library's curls (they grip and
   # steady the wrists; Mogk & Keir 2003, Snijders 1987). No EMG of this
   # lift: judgement calls.
   activation=[("Brachialis", P, HI, 0.76), ("Biceps Brachii", P, HI, 0.74),
               ("Brachioradialis", P, MOD, 0.42), ("Forearms", P, LOW, 0.30)],
   stabilisers=["anterior deltoid", "upper trapezius", "levator scapulae", "core"],
   comparison=("ELBOWS DRIFTING FORWARD", "Elbows fixed at your sides", "Elbows swing forward and up",
               "With the elbows at your sides, the elbow flexors curl the rope from a slight bend to the top.",
               "When the elbows travel forward, the front deltoids join in and the top of the curl turns into a front raise."),
   glows=[glow(N, ["upper_arm_R", "forearm_R"], A, 0.55, 0.05, 0.06),
          glow(N, ["forearm_R", "hand_R"], SOFT, 0.30, 0.05, 0.04)])

SETUP[N] = [
    "Clip a rope to the low pulley and face the stack.",
    "Hold each rope end under its knob, palms facing each other.",
    "Step back until the cable is taut, feet about hip-width apart.",
    "Let the arms hang, elbows slightly bent, with a slight lean back.",
]

# ---------------------------------------------------------------- Cross-Body Hammer Curl

N = "Cross-Body Hammer Curl"
ex(name=N, var="crossBodyHammerCurl",
   overrides={"path": (ov(0.16), "leading"), "torso": (ov(0.16), "trailing"), "elbow": (ov(0.36), "trailing"),
              "grip": (ov(0.36), "leading"), "range": (ov(0.64), "trailing")},
   annotations=[
       ("path", "Up and across", "hand_R"),
       ("elbow", "Elbow low", "forearm_L"),
       ("grip", "Wrist flat", "hand_R"),
       ("range", "Straight arm", "forearm_L"),
       ("torso", "No twisting", "upper_arm_L"),
   ],
   cues={
       "path": ("Curl Path",
                "Each dumbbell travels up and across toward the other shoulder.",
                "Crossing the body is what sets this curl apart from a standard hammer curl: the forearm turns in across the chest as the elbow bends, and the dumbbell finishes in front of the middle of your chest instead of beside its own shoulder.",
                "Curling the dumbbell straight up beside the same shoulder, as in a standard hammer curl.",
                "Curl up and across toward the opposite shoulder, stopping with the dumbbell in front of the middle of your chest, a little below shoulder height."),
       "elbow": ("Elbow Position",
                 "The elbow comes forward only as far as the crossing needs.",
                 "Bending the elbow is what lifts the dumbbell. As the forearm crosses, the elbow comes forward and in with it, but lifting it higher turns the end of the curl into a front raise, so the front of the shoulder lifts part of the weight.",
                 "Raising the elbow up toward shoulder height as the dumbbell crosses.",
                 "Keep the elbow low, well below the shoulder, and let it come forward and in only as the forearm swings across."),
       "grip": ("Grip and Wrist",
                "Thumb up, palm facing in, wrist straight the whole way.",
                "The neutral grip keeps it a hammer curl: the brachialis bends the elbow whatever the grip, while the biceps works a little less than with the palm up. At the top the palm faces your chest, and curling the wrist in toward it moves the weight with the wrist instead of the elbow.",
                "Curling the wrist in toward the chest as the dumbbell crosses.",
                "Hold each dumbbell like a hammer, knuckles in line with the forearm, and keep the palm facing in without twisting it up."),
       "range": ("Range of Motion",
                 "Each curl starts from an almost straight arm.",
                 "Lowering all the way works the elbow flexors through nearly their whole range, and full-range curl training has built more strength than mid-range partial reps.",
                 "Stopping each dumbbell partway down, the elbow still well bent before the next curl.",
                 "Lower each dumbbell until the arm hangs almost straight by your side, palm facing in, before the other arm starts."),
       "torso": ("Body Position",
                 "Both shoulders face forward; only the working arm moves.",
                 "Reaching across the body invites the trunk to twist, the working shoulder swinging forward to throw the dumbbell over, and then momentum lifts part of it instead of the elbow flexors.",
                 "Twisting the shoulders to swing the dumbbell across.",
                 "Stand tall with your core braced and both shoulders square to the front, and lift and lower each dumbbell with the arm alone."),
   },
   # All bright. Values as the library's Alternating Hammer Curl (the same
   # neutral grip, one arm at a time): Brachialis 0.76, Biceps 0.74,
   # Brachioradialis 0.44; Forearms 0.30 as the library's curls. No EMG of
   # a cross-body curl: judgement calls.
   activation=[("Brachialis", P, HI, 0.76), ("Biceps Brachii", P, HI, 0.74),
               ("Brachioradialis", P, MOD, 0.44), ("Forearms", P, LOW, 0.30)],
   stabilisers=["anterior deltoid", "upper trapezius", "middle trapezius", "core"],
   comparison=("ELBOW LIFTING", "Elbow low, forearm crosses", "Elbow rises toward the shoulder",
               "With the elbow kept low, bending it carries the dumbbell up and across to the chest, so the elbow flexors do the lifting.",
               "When the elbow rises toward shoulder height, the front of the shoulder lifts part of the dumbbell and the curl turns into a raise."),
   glows=[glow(N, ["upper_arm_L", "forearm_L"], A, 0.55, 0.05, 0.06),
          glow(N, ["upper_arm_R", "forearm_R"], SOFT, 0.30, 0.05, 0.06)])

SETUP[N] = [
    "Hold a dumbbell in each hand, palms facing in.",
    "Stand tall, feet about hip-width, arms hanging by your sides.",
    "Curl one dumbbell up and across toward the other shoulder.",
    "Lower it all the way, then curl the other arm.",
]

# ---------------------------------------------------------------- Incline Hammer Curl

N = "Incline Hammer Curl"
ex(name=N, var="inclineHammerCurl",
   overrides={"shoulder": (ov(0.16), "leading"), "back": (ov(0.24), "leading"), "arms": (ov(0.36), "trailing"),
              "range": (ov(0.72), "trailing"), "grip": (ov(0.80), "trailing")},
   annotations=[
       ("back", "Back on the pad", "spine"),
       ("arms", "Arms hang", "forearm_L"),
       ("grip", "Thumbs up, wrists straight", "hand_L"),
       ("range", "Almost straight", "hand_L"),
       ("shoulder", "Shoulders back", "upper_arm_R"),
   ],
   cues={
       "back": ("Bench and Back",
                "A bench set to about 50°, the back flat on the pad.",
                "Leaning well back with the arms hanging puts them behind the body, which stretches the biceps' long head, the head that starts above the shoulder joint. Sitting up off the pad gives that position up and turns the lift into a seated hammer curl.",
                "Sitting up off the pad, so the arms hang in line with the body instead of behind it.",
                "Set the back pad to about 50°, sit back with your hips at the back of the seat and keep your back on the pad from the first rep to the last."),
       "arms": ("Upper Arm Position",
                "The upper arms hang straight down and stay there.",
                "Hanging from a trunk leaned this far back, the upper arms sit well behind the body, where the long head is stretched. Letting the elbows swing forward as the dumbbells rise gives that position up and brings the front deltoids into the lift.",
                "Elbows swinging forward as the dumbbells rise, the upper arms ending in front of the body.",
                "Let your arms hang straight down from the shoulders, elbows pointing at the floor, and move only the forearms."),
       "grip": ("Grip and Wrists",
                "Palms face in, thumbs up, from bottom to top.",
                "Keeping the palms in all the way is what makes this the hammer version of the incline curl: the brachialis bends the elbow whatever the grip, while the biceps works a little less than with the palms turned up. Curling the wrists in moves the weight with the wrists instead of the elbows.",
                "Wrists curling in toward the palms as the dumbbells come up.",
                "Hold the dumbbells like hammers, thumbs up, and keep the knuckles in line with the forearms without turning the palms up."),
       "range": ("Range of Motion",
                 "Each rep starts with the arms almost straight.",
                 "The bottom of the incline curl is where the long head is longest and the dumbbells pull least on the elbows, so it is easy to cut short. Lowering until the arms are almost straight works the elbow flexors through nearly their whole range, and full-range curl training has built more strength than mid-range partial reps.",
                 "Turning each rep round halfway down, the elbows still well bent.",
                 "Lower under control until your arms are almost straight below the shoulders, then curl again without bouncing."),
       "shoulder": ("Shoulder Position",
                    "The shoulders stay back against the pad.",
                    "Rolling the shoulders forward off the pad carries the upper arms forward with them, so they stop hanging behind the body and the long head loses its stretch.",
                    "Shoulders rolling forward off the pad as the dumbbells reach the top.",
                    "Keep your shoulder blades against the pad, chest up, and let only the forearms move."),
   },
   # All bright. Values as the library's hammer curls (Brachialis 0.76,
   # Biceps 0.74, Brachioradialis 0.44); Oliveira 2009 found the incline and
   # standing dumbbell curls alike for biceps activation, so the incline is
   # not scored higher. Forearms 0.30 as the library's curls. Judgement
   # calls; no EMG of an incline hammer curl.
   activation=[("Brachialis", P, HI, 0.76), ("Biceps Brachii", P, HI, 0.74),
               ("Brachioradialis", P, MOD, 0.44), ("Forearms", P, LOW, 0.30)],
   stabilisers=["anterior deltoid"],
   comparison=("ELBOWS SWINGING FORWARD", "Arms hang behind the body", "Elbows swing forward",
               "With the upper arms hanging straight down from a trunk leaned well back, the elbow flexors curl the dumbbells from their stretched position behind the body.",
               "When the elbows swing forward, the arms leave the stretched position behind the body and the front deltoids help lift."),
   glows=[glow(N, ["upper_arm_L", "forearm_L"], A, 0.55, 0.035, 0.05),
          glow(N, ["forearm_L", "hand_L"], SOFT, 0.30, 0.03, 0.035)])

SETUP[N] = [
    "Set an incline bench's back pad to about 50°.",
    "Sit back with your back and shoulders on the pad, feet flat.",
    "Hold a dumbbell in each hand, palms facing in.",
    "Let your arms hang straight down, behind your body.",
]

# ---------------------------------------------------------------- Zottman Curl

N = "Zottman Curl"
ex(name=N, var="zottmanCurl",
   overrides={"torso": (ov(0.16), "leading"), "turn": (ov(0.16), "trailing"), "range": (ov(0.59), "leading"),
              "elbow": (ov(0.59), "trailing"), "wrist": (ov(0.80), "trailing")},
   annotations=[
       ("turn", "Turn palms down", "forearm_L"),
       ("elbow", "Elbows in", "forearm_L"),
       ("wrist", "Wrists straight", "hand_L"),
       ("range", "Lower all the way", "hand_R"),
       ("torso", "No body swing", "upper_arm_R"),
   ],
   cues={
       "turn": ("Forearm Turns",
                "Palms up on the way up, palms down on the way down.",
                "In one study the biceps worked hardest lifting with the palms up, and the elbow flexors are much weaker with the palms down. Curling palms up and lowering palms down lets you lower more weight in the reverse-curl grip than you could lift in it, which is where the extra forearm work comes from.",
                "Turning the palms over partway down, or lowering with them still facing up.",
                "Curl with your palms up, turn them to face down at the top, lower slowly with them down, and turn them forward again once your arms are straight."),
       "elbow": ("Elbow Position",
                 "The elbows stay by your sides; only the forearms move and turn.",
                 "With the upper arms still, bending the elbows is the only motion, so the elbow flexors lift and lower the dumbbells. Elbows that drift forward bring the front deltoids in and turn the top of the curl into a front raise.",
                 "Elbows drifting forward as the dumbbells rise.",
                 "Keep your elbows close to your ribs through the curl, the turn at the top and the whole way down."),
       "wrist": ("Wrist Position",
                 "Knuckles in line with the forearms, palms up or down.",
                 "Palms down, the dumbbells pull the hands toward the floor, so the muscles on the back of the forearm work all the way down to hold the wrists straight, and a wrist bent under the weight grips far more weakly.",
                 "The wrists sagging, the hands tipping down under the dumbbells as you lower palms down.",
                 "Hold the handles firmly and keep your knuckles in line with your forearms on the way up, through the turn and on the way down."),
       "range": ("Range of Motion",
                 "Lower until the arms are almost straight, then turn the palms.",
                 "Each rep starts with the arms almost straight, so the elbow flexors work through nearly their whole range, and full-range curl training has built more strength than mid-range partial reps.",
                 "Turning the palms back up and starting the next curl with the elbows still bent.",
                 "Lower until your arms are almost straight, turn your palms forward, then curl again without bouncing."),
       "torso": ("Body Swing",
                 "The legs and back stay out of it.",
                 "Leaning back or pushing the hips forward borrows momentum from the hips and lower back to get the dumbbells moving, so the elbow flexors skip the heaviest part of the curl.",
                 "Leaning back and pushing the hips forward to swing the dumbbells up.",
                 "Stand tall with a braced core and soft knees, and start each curl from a still body."),
   },
   # All bright. Lifting palms up: Biceps 0.86 and Brachialis 0.66 as the
   # library's Dumbbell Curl (Coratella 2023 Sports: biceps highest lifting
   # palms up; lowering showed no grip difference). Brachioradialis 0.50,
   # between the Dumbbell Curl's 0.44 and the Reverse Curl's 0.56 (Kleiber
   # 2015: a larger share palms down). Forearms 0.40, above the curls'
   # 0.30: palms down on the way down the wrist extensors hold the wrists
   # (Coratella 2023, Mogk & Keir 2003). Judgement calls; no Zottman EMG.
   activation=[("Biceps Brachii", P, HI, 0.86), ("Brachialis", P, MOD, 0.66),
               ("Brachioradialis", P, MOD, 0.50), ("Forearms", P, MOD, 0.40)],
   stabilisers=["anterior deltoid", "upper trapezius", "pronator teres", "supinator"],
   comparison=("PALMS NOT TURNED", "Palms up to lift, down to lower", "Palms stay up all the way",
               "Curling palms up works the biceps hardest on the way up, and lowering palms down gives the forearms more weight than a reverse curl would let you lift.",
               "Lowering with the palms still up makes it an ordinary curl, and the slow palms-down lowering that sets the Zottman curl apart is lost."),
   glows=[glow(N, ["upper_arm_L", "forearm_L"], A, 0.55, 0.05, 0.06),
          glow(N, ["upper_arm_R", "forearm_R"], A, 0.55, 0.05, 0.06),
          glow(N, ["forearm_L", "hand_L"], SOFT, 0.28, 0.04, 0.05)])

SETUP[N] = [
    "Hold a dumbbell in each hand, palms facing forward.",
    "Stand tall, feet about hip-width, arms hanging at your sides.",
    "Curl palms up, turn them down at the top, lower palms down.",
    "Turn your palms forward again at the bottom.",
]

# ---------------------------------------------------------------- Dumbbell Reverse Curl

N = "Dumbbell Reverse Curl"
ex(name=N, var="dumbbellReverseCurl",
   overrides={"range": (ov(0.16), "leading"), "shoulder": (ov(0.16), "trailing"), "grip": (ov(0.59), "leading"),
              "elbow": (ov(0.59), "trailing"), "torso": (ov(0.80), "leading")},
   annotations=[
       ("grip", "Wrists straight", "hand_R"),
       ("elbow", "Elbows in", "forearm_L"),
       ("range", "Lower all the way", "hand_R"),
       ("torso", "No hip swing", "thigh_R"),
       ("shoulder", "No shrugging", "upper_arm_L"),
   ],
   cues={
       "grip": ("Grip and Wrists",
                "Palms down, the wrists straight from bottom to top.",
                "With the palms down, each dumbbell pulls the knuckles toward the floor once the forearms tip forward, so the muscles on the back of the forearm work through the curl to hold the wrists straight. A wrist bent down under the weight also grips far more weakly.",
                "The wrists bending down under the dumbbells as they rise, the knuckles dropping toward the floor.",
                "Hold the dumbbells overhand with the handles level, hands about shoulder-width apart, and keep the knuckles in line with the forearms from bottom to top."),
       "elbow": ("Elbow Position",
                 "The elbows stay by your sides; only the forearms move.",
                 "With the upper arms still, bending the elbows is the only way to raise the dumbbells, so the brachioradialis and the other elbow flexors do the lifting. When the elbows drift forward, the front deltoids join in.",
                 "The elbows swinging forward as the dumbbells rise, the upper arms lifting away from the sides.",
                 "Keep your upper arms by your sides and still, and let only the forearms move."),
       "range": ("Range of Motion",
                 "Lower until the arms are almost straight.",
                 "Each rep starts with the dumbbells at the thighs and the arms almost straight, so the elbow flexors work over nearly their whole range. Full-range curl training has built more strength than mid-range partial reps.",
                 "Half reps that stop with the elbows still well bent at the bottom.",
                 "Lower over about a second and a half until your arms are almost straight, then curl again without bouncing."),
       "torso": ("Body Swing",
                 "The body stays still; only the arms move.",
                 "With the palms down the elbow flexors are much weaker than with the palms up or in, so dumbbells that are too heavy tend to get swung up with the hips and back, and momentum does part of the work.",
                 "Rocking the hips forward and the trunk back to heave the dumbbells up.",
                 "Pick dumbbells you can curl with the body still, stand tall, brace and keep your hips and trunk still for every rep."),
       "shoulder": ("Shoulder Position",
                    "The shoulders stay down and back.",
                    "With the palms down, the front deltoids already work a little harder than in a palms-up curl, most likely to steady the shoulders. Rolling the shoulders forward and up at the top adds a shrug, so the shoulders rather than the elbow flexors raise the last part of the lift.",
                    "The shoulders rolling forward and up toward the ears as the dumbbells reach the top.",
                    "Stand tall with your chest up and shoulders down and back, and finish each curl without moving them."),
   },
   # All bright. Values as the library's (EZ-bar) Reverse Curl:
   # Brachioradialis 0.56, Brachialis 0.66, Biceps 0.68 (the Barbell Curl's
   # 0.90 less Coratella 2023's 19% palms-down drop, kept under HIGH);
   # its Wrist Extensors 0.50 and Forearm Flexors 0.45 share one Forearms
   # row at 0.48. Judgement calls; no EMG of a dumbbell reverse curl.
   activation=[("Brachioradialis", P, MOD, 0.56), ("Forearms", P, MOD, 0.48),
               ("Brachialis", P, MOD, 0.66), ("Biceps Brachii", P, MOD, 0.68)],
   stabilisers=["anterior deltoid", "upper trapezius", "levator scapulae"],
   comparison=("WRISTS BENDING DOWN", "Knuckles in line with forearms", "Wrists bend down under the weight",
               "With the wrists held straight, the muscles on the back of the forearm keep each dumbbell in line while the brachioradialis and the other elbow flexors curl it.",
               "When the wrists bend down under the dumbbells, the grip weakens and the weight sags away from the line of the forearms."),
   glows=[glow(N, ["forearm_L", "hand_L"], A, 0.55, 0.05, 0.07),
          glow(N, ["forearm_R", "hand_R"], A, 0.55, 0.05, 0.07)])

SETUP[N] = [
    "Hold a dumbbell in each hand overhand, palms facing back.",
    "Stand tall, feet about hip-width, the dumbbells at your thighs.",
    "Arms almost straight, elbows by your sides, wrists straight.",
]

# ---------------------------------------------------------------- Wrist Roller

N = "Wrist Roller"
ex(name=N, var="wristRoller",
   overrides={"shoulder": (ov(0.16), "trailing"), "turn": (ov(0.40), "leading"), "torso": (ov(0.40), "trailing"),
              "arms": (ov(0.48), "leading"), "lower": (ov(0.56), "leading")},
   annotations=[
       ("arms", "Arms out front", "forearm_R"),
       ("turn", "Top rolls away", "hand_R"),
       ("lower", "Lower slowly", "hand_L"),
       ("torso", "Stand tall", "spine"),
       ("shoulder", "No shrug", "upper_arm_L"),
   ],
   cues={
       "arms": ("Arm Position",
                "Arms out in front, a little below shoulder height.",
                "With the roller held out in front, the cord hangs clear of your legs and the plate rises straight up, and the front of the shoulders holds the arms there while the wrists do the turning.",
                "Letting the arms sink toward the hips as the shoulders tire, the roller coming down and back toward the body.",
                "Hold the roller out in front at about chest height, elbows almost straight, and keep it there for the whole set."),
       "turn": ("Rolling Direction",
                "Turn the top of the roller away from you, one hand at a time.",
                "Rolled this way, each turn bends the gripping wrist forward and down against the plate, so the forearm flexors wind it up. While one hand turns, the other bends back and regrips, ready for its turn. Rolling the top toward you works the back of the forearms instead.",
                "Rolling the top of the handle toward you, which moves the work to the back of the forearms.",
                "Grip with one hand and turn the roller by bending that wrist forward and down, then hold while the other hand bends back, regrips and takes the next turn."),
       "lower": ("Lowering",
                 "Lower the plate with the same turns, slowly.",
                 "On the way down the gripping wrist resists the plate as the cord unwinds, so the forearm flexors keep working as they lengthen. Letting the roller spin skips that half of the work.",
                 "Letting go so the roller spins and the plate drops to the floor.",
                 "Unwind with the reverse turns, one hand at a time, until the plate is just off the floor, then wind it up again."),
       "torso": ("Body Position",
                 "Stand tall and still; only the wrists turn the roller.",
                 "Winding the roller is the forearms' job, so a still, upright body keeps the work there. Leaning back as they tire does nothing to turn the roller.",
                 "Leaning back from the hips to hold the roller up as the forearms tire.",
                 "Stand tall with your feet about hip-width apart, knees soft and core braced, and keep your trunk upright for the whole set."),
       "shoulder": ("Shoulder Position",
                    "The shoulders stay down, away from the ears.",
                    "The wrists turn the roller while the front of your shoulders holds your arms out. Shrugging toward the ears does nothing to turn the roller, so keep the shoulders down and let the wrists do the work.",
                    "Shoulders creeping up toward the ears as the set goes on.",
                    "Set your shoulders down before you lift the roller and keep them there while the wrists turn it."),
   },
   # Bright: brachioradialis and the forearm flexors and extensors (PRIMARY);
   # dim: biceps and anterior deltoid (SECONDARY). Wrist Flexors 0.80: the
   # model's turns are palms-down wrist flexion against the plate both ways
   # (ExRx Cable Roller Wrist Flexion targets the wrist flexors), a little
   # under the library's wrist curls (0.86). Wrist Extensors 0.45: the
   # regripping hand bends back unloaded, and the extensors steady every
   # grip (Snijders 1987, Mogk & Keir 2003). Brachioradialis 0.36 and
   # Biceps 0.20 hold the soft elbows (ExRx stabilisers); Anterior Deltoid
   # 0.36 holds the arms out (ExRx stabiliser). No EMG of the wrist roller:
   # judgement calls.
   activation=[("Wrist Flexors", P, HI, 0.80), ("Wrist Extensors", P, MOD, 0.45),
               ("Brachioradialis", P, LOW, 0.36), ("Anterior Deltoid", S, LOW, 0.36),
               ("Biceps Brachii", S, LOW, 0.20)],
   stabilisers=["brachialis", "upper trapezius", "middle trapezius", "levator scapulae"],
   comparison=("ARMS SINKING", "Arms out in front, wrists turning", "Arms drop toward the hips",
               "With the arms held out in front, the plate hangs clear of the legs and only the wrists turn the roller.",
               "As the arms sink, the roller drops down and back toward the body and the plate hangs closer to the legs."),
   glows=[glow(N, ["forearm_L", "hand_L"], A, 0.55, 0.06, 0.035),
          glow(N, ["forearm_R", "hand_R"], A, 0.55, 0.06, 0.035),
          glow(N, ["upper_arm_L"], SOFT, 0.28, 0.035, 0.03)])

SETUP[N] = [
    "Hang a light plate from the wrist roller's cord.",
    "Stand tall, feet about hip-width, the plate on the floor in front.",
    "Hold the roller overhand, one hand either side of the cord.",
    "Raise your arms out in front, elbows almost straight.",
]
