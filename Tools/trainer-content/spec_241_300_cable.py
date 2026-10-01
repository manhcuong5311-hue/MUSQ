# Trainer content for batch 241-300 (2026-09-27), family: standing cable curls.
# Source exports 243, 244, 245 and 247 from the HIKSEMI drive's "241-300"
# folder (SourceExports/241-300). Same format as spec.py; spec_241_300.py
# imports this module and gen.py reads SPEC / SETUP.
#
# What each model shows, from the briefs, the framing shots and the rig (joints
# sampled over the clip; pulley, handle and bar transforms read from the USD;
# torso length, neck to pelvis, is 0.59 m). Every clip is two identical reps of
# 4 s, the top of the first at ~1.6 s. The palm directions below were read from
# the finger joints (the curled fingertips point to the palm): these files are
# Y-up, so the brief's Z-up palm words are rotated (its up = forward, its
# backward = up).
# - Single-Arm Cable Curl (243): standing tall, feet ~0.3 m apart and square,
#   knees ~174°, trunk upright and still. The LEFT arm works; the right hand
#   rests on the right hip (elbow ~78°). A D-handle on a pulley at the bottom
#   of one column (exit ~8 cm off the floor) that sits straight ahead of the
#   working hand, ~0.55 m in front of it, so the cable runs mostly down and a
#   little forward: ~56° below horizontal at the start, 76-78° from mid-rep
#   to the top. Underhand grip: palm forward with the
#   arm hanging, turned up toward the shoulder at the top; wrist ~10° back
#   (straight to the eye). Elbow 172° -> 56°; the upper arm stays 2-10° off
#   the trunk; the forearm finishes ~45° short of vertical, hand ~11 cm below
#   the shoulder and ~23 cm ahead of it. The stack stays 2-5 cm off its rest
#   at the bottom (it dips as the hand first moves toward the pulley). Framed
#   from the working left side (yaw -1.5, re-framed from +1.1): the lifter
#   faces screen-left toward the column at the left edge, the working arm
#   nearest the camera, the free elbow sticking out behind the back on the
#   right.
# - High Cable Curl (244): standing tall between the two columns of a cable
#   crossover, feet ~0.3 m apart, knees ~174°. Pulleys at ~1.38 m, just below
#   shoulder height (1.43 m) and ~5 cm behind the shoulder line, so the cables
#   run out to the sides and a little down. A D-handle in each hand,
#   underhand: palms up with the arms out, turned toward the head at the top.
#   Upper arms held level (elevation ~91°, 7-18° forward of straight out to
#   the side) and still; elbows 168° -> 68° together, the hands coming in and
#   up to ~26 cm above the shoulders, beside the head (0.45 m -> 0.18 m out
#   from each shoulder). No shrug, no lean. Both stacks stay ~5 cm off their
#   rests with the arms out. The cables' moment about each shoulder is
#   adduction all through the rep (they pull the arms down), so sinking
#   elbows give way to the cables. Framed nearly head-on (yaw -0.3).
# - Overhead Cable Curl (245): seated at a lat-pulldown station, thighs under
#   the knee rollers (knees ~92°, hips ~97°, feet flat), trunk upright. Lat
#   bar (ends angled down) on the high pulley, underhand on its straight
#   middle, hands ~0.48 m apart (shoulder-width):
#   palms facing back toward the head with the arms up, facing down at the
#   top. Upper arms held up at ~160° elevation (~20° in front of vertical) and
#   still; elbows 164° -> 73°. At the start the bar is ~0.5 m above the
#   shoulders, just in front of the head; at the top the forearms point back,
#   about level, and the bar sits ~27 cm above and ~16 cm behind the
#   shoulders, just behind the head. The pulley is ~1.07 m above the shoulders
#   and ~0.24 m in front of them. The cable runs almost along the arms at the
#   start; from ~150° of elbow bend to the top its moment about the shoulders
#   is extension (it pulls the raised arms down in front), so the front of
#   the shoulders holds them up and elbows that drop forward give way to it.
#   The stack sits on its rest until the bar is ~0.7 m from the pulley
#   (elbows ~105-110°) and sets down again at the same point on the way
#   back, so in the model the cable is slack for the first half of each
#   curl; the copy does not ask the lifter to keep the stack off its rest
#   (see the notes). Framed from the left (yaw -1.3), facing left:
#   the far (right) arm is the one nearer the open left of the frame.
# - Cable Hammer Curl (247): standing tall, feet ~0.3 m apart, knees ~174°,
#   centred between two low pulleys set ~0.7 m either side of the midline and
#   ~0.6 m ahead, so each cable runs down, forward and out (~44° below
#   horizontal at the start, ~65-69° from mid-rep to the top). A D-handle in
#   each hand, neutral grip (palms facing each other, thumbs up) for the whole
#   rep; wrists 4-9° back. Both arms curl together with the same path as the
#   single-arm model: elbows 172° -> 56°, upper arms 2-10° off the trunk.
#   Both stacks stay 2-5 cm off their rests at the bottom. Framed from the
#   right side (yaw +1.4): the right arm is nearest the
#   camera; the left hand is hidden behind the right at the bottom.
#
# Where each curl is hardest, read off the rig: the share of the cable's pull
# that turns the elbow (the sine of the angle between the forearm and the
# cable, from the grip to the pulley) against a weight hanging in the same pose.
#   Single-arm / hammer (low pulley ahead): start about -0.4 (-0.39
#   single-arm, -0.45 hammer: the cable runs down and forward from the
#   hanging hand, ~25° (single-arm) to ~40° (hammer, also outward) off the
#   forearm's line, so its pull tips the hand forward and does not resist the
#   curl there, down to ~150°; a free weight 0.17), 136° 0.38
#   (0.72), 103° 0.91 (0.99), 73° 0.98 (0.90), top 0.88 (0.71). Light at the
#   bottom, heaviest from the middle to the top.
#   High cable: start 0.47, 137° 0.89, 108° 0.92, 83° 0.78, top 0.66.
#   Overhead: start 0.18, 138° 0.82, 111° 1.00, 86° 0.94, top 0.85.
# The cable's moment about the shoulder, per unit tension at the hands:
# single-arm / hammer extension at the top (~0.19), high cable adduction all
# rep (0.18-0.37), overhead ~0 at the start and extension from ~150° to the
# top (0.16-0.29). In each model the upper-arm fault moves the arm the way
# the cable pulls it, so the copy says the front of the shoulder holds the
# arm (or joins in when the elbow swings forward), never that the lats or
# shoulders help lift the weight.
# The copy only says where the curl is light and where it is heavy for the set
# up shown; it does not claim the cable builds more muscle (see Nunes 2020,
# Attarieh 2025, Larsen 2026 below) or that it keeps constant tension.
#
# Sources:
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Cè E 2023, Sports 11(3):64, doi:10.3390/sports11030064 — ten competitive
#   bodybuilders, bilateral curls at 8RM: in the lifting phase biceps
#   excitation greater supinated than neutral (+12%) or pronated (+19%);
#   brachioradialis also greater supinated than neutral (+6%) and pronated
#   (+5%); anterior deltoid greater with neutral (+9%) and pronated (+6%)
#   grips.
# - Kleiber T, Kunz L, Disselhorst-Klug C 2015, Front Physiol 6:215,
#   doi:10.3389/fphys.2015.00215 — slow single elbow flexions: brachioradialis
#   contribution differed only with the hand pronated; biceps activity did not
#   change significantly with hand position.
# - Boland MR, Spigelman T, Uhl TL 2008, J Hand Surg Am 33(10):1853-1859,
#   doi:10.1016/j.jhsa.2008.07.019 — fine-wire EMG: no difference in
#   brachioradialis activation during elbow flexion across neutral, pronated
#   and supinated forearms; it acts as an elbow flexor in every position.
# - Basmajian JV, Latif A 1957, J Bone Joint Surg Am 39(5):1106-1118 — needle
#   EMG of the elbow flexors: the biceps flexes the supinated forearm under
#   all conditions and the semiprone (neutral) forearm when a load is lifted;
#   the brachialis flexes in every forearm position (read through secondary
#   summaries; the full text was not reachable).
# - Signorile JF, Rendos NK, Heredia Vargas HH et al. 2017, J Strength Cond
#   Res 31(2):313-322, doi:10.1519/JSC.0000000000001493 — biceps curl on a
#   cable machine against a selectorised machine: more pectoralis major and
#   anterior deltoid activity on the cable (biceps not different).
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2023, J Funct Morphol
#   Kinesiol 8(1):13, doi:10.3390/jfmk8010013 — flexing the arms forward
#   during barbell curls raised anterior deltoid excitation.
# - Nunes JP, Jacinto JL, Ribeiro AS et al. 2020, Int J Environ Res Public
#   Health 17(16):5859, doi:10.3390/ijerph17165859 — cable preacher curl
#   (torque highest with the elbows bent) against barbell preacher curl
#   (torque highest near straight), 10 weeks: similar biceps growth (7% vs
#   8%); the barbell group gained more strength only at the long muscle
#   length.
# - Attarieh P, Nunes JP, Khani S et al. 2025, Eur J Sport Sci 25(4):e12279,
#   doi:10.1002/ejsc.12279 — one-arm cable curls with the shoulder flexed
#   (preacher) or extended (Bayesian), resistance profiles matched: similar
#   growth of biceps and brachialis and similar strength gains.
# - Larsen S, Sandvik Kristiansen B, Østerås Sandberg N et al. 2026, Front
#   Physiol 17:1750722, doi:10.3389/fphys.2026.1750722 — one-arm cable curls
#   with the shoulder neutral or fully extended, profiles and range matched:
#   no meaningful difference in elbow-flexor growth in untrained men.
# - Parpa K, Vasiliou A, Michaelides M et al. 2025, Muscles 4(4):45,
#   doi:10.3390/muscles4040045 — at 80% of each lift's 1RM the dumbbell curl
#   drew more biceps EMG than the Bayesian cable curl: a cable does not by
#   itself make the biceps work harder (the Bayesian curl also differs in
#   shoulder position, so this is balance only).
# - Pinto RS, Gomes N, Radaelli R et al. 2012, J Strength Cond Res
#   26(8):2140-2145, doi:10.1519/JSC.0b013e31823a3b15 — preacher curls in
#   untrained men: full-range (0-130°) elbow-flexor training raised the 1RM
#   more than mid-range partials (50-100°), +25.7% vs +16.0%; muscle
#   thickness not different (the copy says "mid-range partial reps" and
#   only "more strength").
# - Young S, Porcari JP, Camic C, Kovacs A, Foster C 2014, ACE ProSource
#   (August), ACE-sponsored EMG study, not peer-reviewed — eight curls
#   including a standing cable curl at 70% 1RM; only the braced concentration
#   curl drew significantly more biceps activity than the rest. (The per-
#   exercise %MVC values are in a figure that could not be read, so no number
#   is taken from it.)
# - Sands WA, Wurth JJ, Hewit JK 2012, NSCA Basics of Strength and
#   Conditioning Manual — EZ-bar curl: stand erect with the feet hip-width
#   apart; coaching points: elbows at the sides, no rolling the shoulders
#   forward, no momentum, slow controlled return.
# - ExRx.net (web.archive.org captures; exrx.net blocks direct fetches):
#   Cable One Arm Curl, 2023-11-22 (face the low pulley, stirrup attachment,
#   underhand; with the elbow to the side raise until the forearm is
#   vertical, lower until the arm is fully extended; when the elbow is fully
#   flexed it can travel forward slightly; stabilisers include the anterior
#   deltoid and upper trapezius); Cable Hammer Curl, 2023-01-13 (a rope on
#   one low pulley, palms facing in; elbows to the sides, raise forward and
#   upward until the forearms are vertical, lower to full extension; target
#   brachioradialis, synergists brachialis and biceps; the model's two wide
#   low pulleys with a D-handle each are a common variant, not the ExRx
#   set-up); Cable Curl, 2024-01-05 (stand close to the pulley; the model
#   stands a step back, as StrengthLog allows); Cable Underhand Pulldown,
#   2020-08-04 (grasp the bar underhand and sit with the thighs under the
#   supports — the source for the pad set-up only).
# - Muscle & Strength, Standing High Pulley Cable Curl (web.archive.org
#   capture 2023-09-30; the live page blocks fetches): two high pulleys, an
#   underhand grip on each, stand in the centre with the arms outstretched,
#   keep the upper arms and body fixed, curl the handles in as far as
#   possible, pause, lower slowly; do not move the elbows. Target biceps,
#   experience level intermediate.
# - StrengthLog: Overhead Cable Curl (sit facing a high pulley, underhand,
#   arms extended with the handle above or slightly in front of the head;
#   keep the upper arms stable and bend the elbows to bring the handle toward
#   the back of the head); Hammer Curl (feet about hip-width apart in a
#   stable position, brace the core so the body does not swing; elbows close
#   to the body, at the sides or slightly forward; if they move forward the
#   front delts take extra load; keep the grip neutral, it is easy to start
#   twisting the wrists; hammer curls emphasise the brachialis and
#   brachioradialis more than regular curls); Cable Curl (take a step back;
#   keep the upper arm still or move it slightly forward; cites constant
#   tension — the copy does not repeat that claim); Dumbbell Curl (keep the
#   wrists straight).
#
# Evidence is thin for the high cable curl and the overhead cable curl as
# such: no EMG or training study of either was found. Their activation
# follows the standing cable curl, lowered a little, and their cues follow the
# technique references and the mechanics read off the rig.
#
# The stance cues (single-arm, high and hammer curls) rest on the NSCA
# manual (stand erect, feet hip-width apart) and StrengthLog Hammer Curl
# (feet about hip-width in a stable position, core braced so the body does
# not swing); "so the body does not rock toward the stack" is mechanics. The
# stack and pad set-up points rest on the technique references (ExRx
# pulldown: thighs under the supports) and on stability, not on a study.
#
# Labels: every entry pins its rows with `overrides`, checked by drawing the
# pills and leaders over the framing shots at 0.2 s and 1.6 s with the rows
# squeezed as spec_241_300.py does: no leader crosses the head or another
# cue's pill, no pill covers a moving hand or handle, and each dot sits on the
# named part. The working or near arm moves through the middle of the frame
# in every model, so its cues are split between the top row and a short pill
# clear of the hand's path; the body cues sit on the open side. One dot sits
# on a part hidden at times: the hammer curl's spine joint lies behind the
# hanging right forearm at the bottom and is in view at the top, where its
# fault is shown. The hammer grip dot is on the near (right) hand, in view all
# clip. The single-arm curl, re-framed to its working side (yaw -1.5), was
# re-laid on the re-probed joints and redrawn over the new 0.2 s and 1.58 s
# shots and, with the mistake view's scale and lift, its fault stills: its
# shoulder and torso dots sit on the back of the near shoulder and on the
# near lat (the pelvis and spine joints sit on the hanging hand and forearm
# at the bottom), and the top-left row stays empty, where the working hand
# rises. At the bottom even the lat dot touches the back edge of the hanging
# forearm; like the hammer curl's spine dot it is clear at the top, where its
# fault is shown, and a clear dot all rep needs a lower-back joint in the rig.
# The second in-app review (round-two shots and fault stills) moved the
# single-arm shoulder pill to row 0.30 and relabelled the hammer grip and
# stance (see the entries and the notes).

from common_241_300 import *

# ---------------------------------------------------------------- shared cues

FULL_RANGE = "full-range curl training has built more strength than mid-range partial reps"


def arm_glows(name, side, other=None, rx=0.06, ry=0.07, dx=0.0):
    """The working biceps (mid upper arm, shoulder to elbow) at full strength;
    softer, the brachialis and brachioradialis at that elbow and, when both
    arms work, the other biceps. `dx` nudges the working-arm glows toward the
    side of the arm that shows."""
    g = [glow(name, [f"upper_arm_{side}", f"forearm_{side}"], A, 0.55, rx, ry, dx=dx)]
    if other:
        g.append(glow(name, [f"upper_arm_{other}", f"forearm_{other}"], SOFT, 0.30, rx * 0.85, ry * 0.85))
    g.append(glow(name, [f"forearm_{side}"], SOFT, 0.28, rx * 0.75, ry * 0.75, dx=dx))
    return g


# ---------------------------------------------------------------- single-arm cable curl

ex(name="Single-Arm Cable Curl", var="singleArmCableCurl",
   # Left-side view (yaw -1.5): the lifter faces the column on the left, the
   # working arm nearest the camera; the hand rises over u 0.35-0.52, rows
   # 0.28-0.47, in front of the body, and the face is at the top left. The
   # right half is the open back, the free elbow sticking out to u ~0.67 at
   # rows 0.29-0.35, the glutes to u ~0.64. So the top-left row stays empty
   # (the hand reaches it in the mistake view, which lifts the model); the
   # upper-arm, shoulder and torso pills are short, on the right, clear of
   # the head, the free elbow and the glutes, with leaders over the back to
   # the near shoulder, the back of the near shoulder (scapula) and the near
   # lat; the range pill sits on the left at the hand's lowest height, a
   # level leader at the bottom and a near-vertical one beside the cable at
   # the top. The pelvis and spine joints sit on the hanging hand and forearm
   # at the bottom, so the torso dot is on the lat. The stance dot is on the
   # near ankle, which is also the one on the pill's side when the stance
   # fault turns to the back-left. The shoulder pill sits at 0.30 (squeezed
   # 0.302), not 0.32: there its left cap touched the tip of the free elbow;
   # at 0.30 the cap clears it by ~7 pt and still sits right of the back.
   overrides={"elbow": (0.14, "trailing"), "shoulder": (0.30, "trailing"), "torso": (0.50, "trailing"),
              "range": (0.50, "leading"), "stance": (0.86, "leading")},
   annotations=[
       ("elbow", "Upper arm still", "upper_arm_L"),
       ("range", "Lower all the way", "hand_L"),
       ("shoulder", "Shoulders down", "scapula_L"),
       ("torso", "Stand tall", "support_LatissimusDorsi_L"),
       ("stance", "Feet hip-width apart", "foot_L"),
   ],
   cues={
       "elbow": ("Upper Arm Position",
                 "The upper arm stays by your side; only the forearm moves.",
                 "With the upper arm still, bending the elbow is the only motion, so the elbow flexors move the handle. Letting the elbow drift forward brings the front deltoid in and turns the top of the curl into a front raise.",
                 "The elbow drifting forward and up as the handle rises.",
                 "Keep the elbow close to the ribs and curl until the handle is in front of the shoulder, palm facing it, without swinging the elbow forward."),
       "range": ("Range of Motion",
                 "Each rep starts from a straight arm.",
                 "Facing a low pulley from a step away, the cable runs down and a little forward from the hanging hand, so it barely resists the first part of the curl, which is light and easy to cut short. Lowering until the arm is straight still takes the elbow through its whole range, and " + FULL_RANGE + ".",
                 "Stopping each rep with the elbow still bent, the handle never getting back to the thigh.",
                 "Lower under control until the arm hangs straight with the handle by the thigh, the stack still just off its rest, then curl again."),
       "shoulder": ("Shoulder Position",
                    "The shoulders stay down and back.",
                    "Rounding the shoulders forward or shrugging them up as the handle rises brings the front deltoid and upper traps into the lift and takes work away from the elbow flexors.",
                    "Shoulders rolling forward and shrugging up as the handle rises.",
                    "Set the shoulders down and back before the first rep and keep them level and still as the handle rises."),
       "torso": ("Body Position",
                 "Stand tall and keep the body out of the lift.",
                 "Leaning back or pushing the hips forward borrows momentum from the hips and lower back to get the handle moving, so the elbow flexors skip the heaviest part of the rep.",
                 "Leaning back and pushing the hips forward to swing the handle up.",
                 "Stand tall with a braced core and lower the handle over two to three seconds so each rep starts from a still body."),
       "stance": ("Stance",
                  "Feet hip-width, knees soft.",
                  "The cable pulls down and a little forward on one side only. A hip-width stance with soft knees gives a still base, so the body does not rock toward the stack as the handle rises.",
                  "Feet drawn together and knees locked, so each rep rocks the body toward the stack.",
                  "Stand facing the pulley with the feet hip-width apart, the knees slightly bent and the free hand on the hip."),
   },
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.64), ("Brachioradialis", S, MOD, 0.44)],
   stabilisers=["anterior deltoid", "forearm flexors", "obliques"],
   comparison=("ELBOW DRIFTING FORWARD", "Upper arm still at your side", "Elbow swings forward and up",
               "With the upper arm still, the elbow flexors move the handle from a straight arm to the top.",
               "When the elbow travels forward, the front deltoid joins in and the top of the curl turns into a front raise."),
   # The working arm is nearest the camera from this side (u 0.50-0.56), so
   # the glows sit on it without a nudge.
   glows=arm_glows("Single-Arm Cable Curl", "L", rx=0.05, ry=0.06))

SETUP["Single-Arm Cable Curl"] = [
    "Attach a D-handle to a pulley at the bottom of the column.",
    "Take it underhand in one hand and step back until the stack lifts.",
    "Stand tall, feet hip-width, the working arm straight by your side.",
    "Rest your free hand on your hip.",
]

# ---------------------------------------------------------------- high cable curl

ex(name="High Cable Curl", var="highCableCurl",
   # Nearly head-on: the arms span the frame at rows 0.24-0.33, so the pills
   # sit above them at the top and just below them at the hips, short enough
   # to stay clear of the trunk; each leader runs to the arm on its own side.
   # The stance cue sits by the right foot. The wrist pill is the shortest
   # (u ~0.75-0.98): the mistake view lifts the model, which brings the left
   # hand at the top of the curl, and the wrist ghost with it, up to row
   # 0.16 at u ~0.62-0.68; the palm directions stay in the cue text.
   overrides={"shoulder": (0.14, "leading"), "wrist": (0.14, "trailing"), "range": (0.50, "leading"),
              "upperarm": (0.50, "trailing"), "stance": (0.86, "leading")},
   annotations=[
       ("upperarm", "Elbows stay level", "forearm_L"),
       ("shoulder", "Shoulders down", "attachment_TrapeziusUpper_R"),
       ("wrist", "Wrists flat", "hand_L"),
       ("range", "Almost straight", "forearm_R"),
       ("stance", "Feet hip-width apart", "foot_R"),
   ],
   cues={
       "upperarm": ("Upper Arm Position",
                    "The upper arms stay level with the shoulders; only the forearms move.",
                    "Holding the upper arms still makes bending the elbows the only motion, so the elbow flexors bring the handles in. The cables pull the hands out to the sides, which tips the upper arms down; if the elbows sink as the hands come in, the handles drift back toward the pulleys and each curl gets shorter.",
                    "The elbows sinking below shoulder height as the hands curl in toward the head.",
                    "Keep the elbows at shoulder height, in line with the pulleys, and bring the hands in beside the head without the elbows moving."),
       "shoulder": ("Shoulder Position",
                    "The shoulders stay down while the arms are held up.",
                    "Holding the arms out at shoulder height makes it easy to hike the shoulders toward the ears, which lets the upper traps move the handles instead of the elbow flexors.",
                    "Shoulders shrugging up toward the ears as the handles come in.",
                    "Set the shoulders down before the first rep and keep the neck long while the arms stay up."),
       "wrist": ("Grip and Wrists",
                 "Palms up at the start, facing the head at the top, wrists straight.",
                 "With the palms turned up the biceps works in its strongest position. Curling the wrists in moves the handles with the wrists instead of the elbows and puts needless load on them.",
                 "Curling the wrists in toward the forearms as the handles come in.",
                 "Hold the handles underhand and keep the knuckles in line with the forearms from the start of each rep to the finish."),
       "range": ("Range of Motion",
                 "Each rep starts from almost straight arms.",
                 "With the pulleys about level with the shoulders, the cables pull more nearly along straight arms, so the start of the curl is lighter than the middle and easy to cut short. Straightening the arms still takes the elbows through their whole range, and " + FULL_RANGE + ".",
                 "Short reps that turn back with the elbows still well bent.",
                 "Let the handles draw the arms out until they are almost straight at shoulder height, then curl again without letting the weights touch down."),
       "stance": ("Stance",
                  "Stand centred between the pulleys, feet hip-width.",
                  "Standing in the middle keeps both cables pulling at the same angle, so neither arm is drawn further out than the other, and a hip-width stance with soft knees keeps the body fixed while only the forearms move.",
                  "Feet drawn together and knees locked, the body swaying as the handles come in.",
                  "Stand centred and in line with the pulleys, feet hip-width apart and knees slightly bent, and keep the body still for every rep."),
   },
   activation=[("Biceps Brachii", P, HI, 0.82), ("Brachialis", S, MOD, 0.62), ("Brachioradialis", S, MOD, 0.42)],
   stabilisers=["deltoids", "rotator cuff", "forearm flexors", "core"],
   comparison=("ELBOWS DROPPING", "Elbows held at shoulder height", "Elbows sink as the hands come in",
               "With the upper arms level and still, the elbow flexors bring the handles in toward the head.",
               "When the elbows sink, the handles drift back toward the pulleys and each curl gets shorter."),
   glows=arm_glows("High Cable Curl", "L", "R", rx=0.07, ry=0.045))

SETUP["High Cable Curl"] = [
    "Set both pulleys at about shoulder height, a D-handle on each.",
    "Stand centred between them, feet hip-width apart.",
    "Take a handle in each hand, palms up.",
    "Raise the arms out to the sides, level with the shoulders.",
]

# ---------------------------------------------------------------- overhead cable curl

ex(name="Overhead Cable Curl", var="overheadCableCurl",
   # Seen from the left, facing left: the far (right) arm is the one nearer
   # the open left of the frame, so the arm cues point at its hand, elbow and
   # shoulder from the left; the pad cue sits left of the shins and a short
   # torso pill sits right of the back. The grip, range and pad labels are
   # short so their pills end clear of the bar's angled left grip at the
   # start (u ~0.46), of the far elbow, and of the far shin below the knee.
   # The pad label names the thighs, as the cue and set-up do: the roller
   # sits on the lower thighs; patella_L is the probed point nearest it.
   overrides={"grip": (0.14, "leading"), "range": (0.32, "leading"), "upperarm": (0.50, "leading"),
              "pad": (0.68, "leading"), "torso": (0.50, "trailing")},
   annotations=[
       ("upperarm", "Upper arms stay still", "upper_arm_R"),
       ("range", "Arms almost straight", "forearm_R"),
       ("grip", "Underhand, flat wrists", "hand_R"),
       ("torso", "Sit tall", "spine"),
       ("pad", "Pads on thighs", "patella_L"),
   ],
   cues={
       "upperarm": ("Upper Arm Position",
                    "The upper arms stay raised and still; only the forearms move.",
                    "With the upper arms fixed overhead, bending the elbows is the only motion, so the elbow flexors curl the bar. As the bar comes in, the cable pulls the raised arms down in front, so the front of the shoulders has to hold them up. If the elbows give way and drop forward, the bar moves toward the pulley without the elbows bending and each curl gets shorter.",
                    "The elbows dropping forward and down as the bar comes toward the head.",
                    "Keep the upper arms raised just in front of the head for the whole set and bend only at the elbows, bringing the bar toward the back of the head."),
       "range": ("Range of Motion",
                 "Each rep starts with the arms almost straight overhead.",
                 "At the start the cable pulls almost along the straight arms, so the first part of the curl is light and easy to skip. Straightening the arms each rep keeps the full range at the elbow, and " + FULL_RANGE + ".",
                 "Short reps that turn back with the elbows still well bent, the arms never straightening overhead.",
                 "Let the bar rise until the arms are almost straight above the head, then curl again."),
       "grip": ("Grip and Wrists",
                "An underhand grip, hands about shoulder-width, wrists straight.",
                "With the palms turned toward you the biceps works in its strongest position. Curling the wrists in moves the bar with the wrists instead of the elbows and puts needless load on them.",
                "Curling the wrists in toward the forearms as the bar comes toward the head.",
                "Hold the bar underhand, hands about shoulder-width apart, and keep the knuckles in line with the forearms from start to finish."),
       "torso": ("Body Position",
                 "Sit tall and keep the trunk still.",
                 "Rocking the trunk back uses the body to drag the bar down, as in a swung pulldown, so the elbow flexors skip the heaviest part of the rep.",
                 "Leaning back from the hips to drag the bar down with the body.",
                 "Sit tall with the chest up and the core braced, and let only the forearms move."),
       "pad": ("Seat and Pads",
               "The thighs sit snug under the pads.",
               "Pads snug over the thighs fix the hips on the seat, so the body cannot rise to follow the bar or rock back to help it down, and only the forearms move.",
               "Sitting loose under the pads and rising off the seat to follow the bar as the arms straighten.",
               "Set the pads so the thighs fit snugly under them with the feet flat, and keep the hips on the seat for every rep."),
   },
   activation=[("Biceps Brachii", P, HI, 0.80), ("Brachialis", S, MOD, 0.62), ("Brachioradialis", S, MOD, 0.42)],
   stabilisers=["anterior deltoid", "rotator cuff", "forearm flexors", "core"],
   comparison=("ELBOWS DROPPING", "Upper arms stay up", "Elbows drop forward",
               "With the upper arms fixed overhead, the elbow flexors curl the bar toward the back of the head.",
               "When the elbows drop forward, the bar drifts toward the pulley and stops over the head instead of behind it, so each curl gets shorter."),
   glows=arm_glows("Overhead Cable Curl", "R", "L", rx=0.05, ry=0.06))

SETUP["Overhead Cable Curl"] = [
    "Attach a lat bar to the high pulley of a pulldown station.",
    "Take the bar underhand, hands about shoulder-width apart.",
    "Sit with your thighs under the pads, feet flat.",
    "Hold the bar with the arms almost straight, just in front of your head.",
]

# ---------------------------------------------------------------- cable hammer curl

ex(name="Cable Hammer Curl", var="cableHammerCurl",
   # Side-on from the right, facing right: the near (right) arm in front of the
   # body, the back of the lifter close to the left-hand pills, so those labels
   # are short. The hands sweep the middle right, so the grip cue comes from
   # the top right to the near (right) hand, in view all clip (the left hand
   # is hidden behind the near hip at the bottom). The grip label is short
   # ("Firm wrists"): turned face-on for its fault, the lone pill keeps its
   # top-right row and the ghost's left-hand tip sat on the left cap of the
   # longer "Wrists straight"; "Wrists flat" could read as palms down on a
   # thumbs-up grip. The torso cue's spine dot is in view
   # on the side of the trunk at the top, where the swing is shown, and lies
   # behind the hanging right forearm at the bottom (no lower-back joint is
   # probed). The stance pill names the feet, what the face-on stance ghost
   # shows (locked knees do not show face-on); short, on the bottom row, it
   # ends ~20 pt left of the near heel, above the base, with a short leader
   # to the near ankle.
   overrides={"elbow": (0.14, "leading"), "range": (0.32, "leading"), "torso": (0.50, "leading"),
              "stance": (0.86, "leading"), "grip": (0.14, "trailing")},
   annotations=[
       ("elbow", "Upper arms still", "upper_arm_R"),
       ("range", "Straighten fully", "forearm_R"),
       ("grip", "Firm wrists", "hand_R"),
       ("torso", "Torso still", "spine"),
       ("stance", "Feet hip-width", "foot_R"),
   ],
   cues={
       "elbow": ("Upper Arm Position",
                 "The upper arms stay by your sides; only the forearms move.",
                 "With the upper arms still, bending the elbows is the only motion, so the elbow flexors lift the handles. Elbows that drift forward bring the front deltoids in and turn the top of the curl into a front raise.",
                 "Elbows drifting forward as the handles rise.",
                 "Keep the elbows close to the ribs and curl until the handles are in front of the shoulders, without swinging the elbows forward."),
       "range": ("Range of Motion",
                 "Each rep starts from straight arms.",
                 "Facing low pulleys from a step away, the cables run down, forward and out from the hanging hands, so they barely resist the first part of the curl, which is light and easy to cut short. Lowering until the arms are straight still takes the elbows through their whole range, and " + FULL_RANGE + ".",
                 "Short reps that stop with the elbows still bent at the bottom.",
                 "Lower under control until the arms hang straight by your sides, the stacks still just off their rests, then curl again."),
       "grip": ("Grip and Wrists",
                "Palms face each other, thumbs up, wrists straight.",
                "The neutral grip is what makes this a hammer curl: the brachialis and brachioradialis flex the elbow in any grip, while the biceps works a little less than with the palms up. The wide pulleys pull the hands down and outward, so the wrists have to hold the handles straight.",
                "Letting the cables bend the wrists back, the knuckles tipping out toward the pulleys.",
                "Keep the palms facing each other from bottom to top, without twisting them up, and the knuckles in line with the forearms."),
       "torso": ("Body Swing",
                 "The legs and back stay out of it.",
                 "Leaning back or pushing the hips forward borrows momentum from the hips and lower back to get the handles moving, so the elbow flexors skip the heaviest part of the rep.",
                 "Leaning back and pushing the hips forward to swing the handles up.",
                 "Stand tall with a braced core and lower the handles over two to three seconds so each rep starts from a still body."),
       "stance": ("Stance",
                  "Centred between the pulleys, feet hip-width, knees soft.",
                  "Standing in the middle keeps both cables pulling at the same angle, and a hip-width stance with soft knees gives a still base, so the body does not rock toward the stacks as the handles rise.",
                  "Feet drawn together and knees locked, so each rep rocks the body toward the stacks.",
                  "Stand centred a short step back from the pulleys, feet hip-width apart and knees slightly bent."),
   },
   activation=[("Brachialis", P, HI, 0.76), ("Biceps Brachii", P, HI, 0.74), ("Brachioradialis", S, MOD, 0.42)],
   stabilisers=["anterior deltoid", "forearm flexors", "core"],
   comparison=("ELBOWS DRIFTING FORWARD", "Elbows fixed at your sides", "Elbows swing forward and up",
               "With the elbows fixed at the sides, the elbow flexors lift the handles through the whole range.",
               "When the elbows travel forward, the front deltoids join in and the top of the curl turns into a front raise."),
   glows=arm_glows("Cable Hammer Curl", "R", rx=0.05, ry=0.06))

SETUP["Cable Hammer Curl"] = [
    "Attach a D-handle to each pulley at the bottom of the columns.",
    "Stand centred between them, a short step back, feet hip-width.",
    "Hold the handles with the palms facing in, arms by your sides.",
    "Stand tall with soft knees and the shoulders down.",
]

if __name__ == "__main__":
    probs = validate(["Single-Arm Cable Curl", "High Cable Curl", "Overhead Cable Curl", "Cable Hammer Curl"]); print("\n".join(probs) or "OK")
