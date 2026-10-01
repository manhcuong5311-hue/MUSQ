# Trainer content for batch 241-300 (2026-09-27), family: drag curls, spider
# curls and the alternating hammer curl. Source exports 252 Drag Curl, 253 EZ
# Bar Drag Curl, 254 Cable Drag Curl, 265 Dumbbell Spider Curl, 266 EZ Bar
# Spider Curl and 268 Alternating Hammer Curl from the HIKSEMI drive's
# "241-300" folder (SourceExports/241-300). Same format as spec.py, on top of
# common_241_300.py; spec_241_300.py collects the families in library order
# and squeezes the label rows (written here on the usual 0.14-0.86 scale)
# into 0.16-0.80.
#
# What each model shows, from the briefs, the framing shots and the rig (joints
# sampled every 1/3 s with Blender's pxr; the bar, cable and dumbbell prims'
# own bounds; the hand joint's frame for the palm, its +Z being the palm
# normal; torso, neck to pelvis, is 0.59 m in all six):
# - Drag Curl (252): standing tall, feet ~0.3 m apart, knees ~174°, trunk
#   upright (0°) and still, shoulders level (no shrug). Olympic barbell,
#   underhand, forearms fully turned palm-up, hands ~0.42 m apart
#   (shoulder-width). Bottom: the bar sits 3-5 cm in front of the hips at the
#   tops of the thighs (shaft 0.89 m up, pelvis 0.91 m), upper arms
#   vertical, elbows ~138°, so every rep starts ~42° short of a straight arm.
#   The bar then rises straight up the front of the body, 3-5 cm off its
#   surface the whole way (18-23 cm ahead of the pelvis joint), while the
#   elbows travel back: the upper arms reach 28° behind vertical by mid-rep
#   (elbows 13 cm behind the shoulders), then ease forward to 15° behind as
#   the forearms pass horizontal. Top: bar at the lower chest (1.27 m, ~23 cm
#   below the base of the neck), elbows ~55°, forearms still ~19° above
#   horizontal, so the bar stays ~25 cm in front of the elbows. Wrists ~12°
#   extended, steady. Two reps of 4 s: up ~1.3 s (0.25-1.5 s), ~0.7 s at the
#   top, down ~1.5 s (2.25-3.75 s), ~0.5 s still at the bottom. Framed at yaw
#   -0.8, zoom 0.653 (front-left, facing screen left, left arm on the right;
#   re-framed from -1.1, where the near plate hid the left elbow and hand for
#   most of each rep): no label joint is behind a plate (the near elbow dot
#   touches the plate's rim mid-rep). Palms face forward with the bar at the
#   thighs and up at the top.
# - EZ Bar Drag Curl (253): the Drag Curl's body and arm motion to within a
#   degree. EZ bar, hands on the outer angled grips ~0.41-0.43 m apart,
#   forearms ~18-23° short of fully palm-up (palms turned partly in), wrists
#   9-17° extended. Framed near front-on at yaw -0.3, zoom 0.891 (re-framed
#   from -1.1, where the plate hub hid the left hand): no label joint is
#   behind a plate at any moment.
# - Cable Drag Curl (254): the same body and arm motion again, with a straight
#   cable bar (hands ~0.47 m apart, fully palm-up) on the low pulley of a
#   dual cable column straight in front (pulley 0.65 m ahead of the pelvis,
#   0.12 m up; the other column stands 1.4 m to the left). The cable runs
#   forward and down from the bar, ~31° off vertical at the bottom and ~20°
#   at the top, so it pulls the bar away from the body as well as down.
#   Framed at yaw +1.1: right side toward the camera, facing screen right
#   toward the stack; the near arm is the right one.
# - Dumbbell Spider Curl (265): the Spider Curl's (238) body and arm motion
#   exactly: kneeling on the seat of an incline bench, chest and stomach on
#   the ~42° pad, trunk 48° forward, knees ~132°, feet off the floor; the
#   upper arms hang vertical and never move (0° off vertical, the elbows
#   under the shoulders to within 1 cm); elbows 170° to 52°, two reps. At the
#   bottom the hands are ~4 cm ahead of the elbows, at the top the forearms
#   are ~38° above horizontal. A dumbbell in each hand, palms facing forward
#   (fully palm-up), handles across the body end to end, hands ~0.40-0.42 m
#   apart; wrists ~9° extended. Yaw -2.0 (from behind on the left, left arm
#   on the left of the frame), framed larger than the Spider Curl.
# - EZ Bar Spider Curl (266): the same, with an EZ bar on the outer angled
#   grips, hands ~0.39 m apart, forearms ~23° short of fully palm-up.
# - Alternating Hammer Curl (268): standing tall, feet ~0.3 m apart, knees
#   ~174°, trunk upright and still, no shrug. A dumbbell in each hand,
#   handles front to back, palms facing in; the forearms stay neutral (within
#   3°) and the wrists within 9° of straight for the whole clip. The arms hang
#   straight (178°), the upper arms ~13° out from the sides so the dumbbells
#   clear the thighs. The LEFT arm curls 0-4 s, the right 4-8 s, the resting
#   arm hanging straight. The working arm comes in to the side as it rises
#   and finishes at ~56° with the dumbbell in front of the shoulder (hand
#   23 cm ahead of and 11 cm below it), the forearm ~45° short of vertical;
#   the elbow drifts forward ~5 cm (upper arm up to 11° forward). Yaw -0.4.
#
# Sources:
# - ExRx.net exercise pages (exrx.net blocks direct fetches; read from
#   web.archive.org 2024 snapshots): Barbell Drag Curl (shoulder-width
#   underhand grip; raise the bar straight up so the elbows travel back,
#   following the contour of the hips and waist; begin bringing the elbows
#   forward as the forearms rise past horizontal; continue over the chest
#   until the forearms are perpendicular; lower until the arms are fully
#   extended; comment: bringing the elbows forward so the forearms reach no
#   more than vertical permits a relative release of tension between reps;
#   can be done with an EZ bar; target biceps brachii, synergists
#   brachialis, brachioradialis, posterior and anterior deltoid, stabilisers
#   upper and middle trapezius, levator scapulae, wrist flexors); Barbell
#   and Dumbbell Prone Incline Curl, also known as the
#   barbell and dumbbell spider curl (prone on an incline bench, shoulders
#   near the top, knees can rest on the seat, shoulder-width underhand grip
#   or palms forward, lower until the arms are fully extended; target
#   brachialis, synergists biceps and brachioradialis, stabilisers wrist
#   flexors, middle trapezius, rhomboids); Dumbbell Hammer Curl (dumbbells at
#   the sides, palms in, elbows to the sides, raise one dumbbell until the
#   forearm is vertical and the thumb faces the shoulder, alternate; comment:
#   at full flexion the elbows can travel forward slightly, forearms no more
#   than vertical; target brachioradialis, synergists brachialis and biceps,
#   stabilisers anterior deltoid, coracobrachialis, upper and middle
#   trapezius, levator scapulae, flexor and extensor carpi radialis); Cable
#   Curl (stand close to the pulley); Barbell Curl (at full flexion the
#   elbows can travel forward slightly, forearms no more than vertical, for
#   a relative release of tension).
# - StrengthLog exercise guides (strengthlog.com): Drag Curl (pull the bar up
#   along the body by driving the elbows back, keep the bar close, shoulders
#   down, stop at upper-chest height with the forearms parallel to the floor,
#   lower slowly along the same path; primary biceps, secondary forearm
#   flexors); Spider Curl (dumbbells, 45° bench, underhand grip, upper arms
#   vertical, do not let them travel back or forwards); Hammer Curl (primary
#   biceps, secondary forearm flexors; neutral grip, which targets more of the
#   brachialis and brachioradialis; keep the elbows at the sides or move them
#   slightly forward; elbows forward load the front delts; avoid twisting
#   the wrists, swinging and half reps with too much weight);
#   EZ Curl (the angled grip can be kinder to the wrists and elbows; no study
#   cited, so the copy says many lifters find it so); Dumbbell Curl (bent
#   wrists take needless load).
# - Marcolin G et al. 2018, PeerJ 6:e5165 (doi 10.7717/peerj.5165) — the EZ
#   bar puts the forearms near semi-prone; biceps and brachioradialis EMG
#   differed only a little between the EZ and straight bar, so the choice
#   between them is a matter of subjective comfort.
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2023, J Funct Morphol
#   Kinesiol 8(1):13 (doi 10.3390/jfmk8010013) — ten bodybuilders at 8RM:
#   the straight bar gave slightly more biceps excitation than the EZ bar in
#   two conditions (+1.8% lifting, arms still; +3.8% lowering, arms flexed)
#   and none in the others; flexing the arms forward raised anterior deltoid
#   excitation (and biceps excitation in the lifting phase).
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F, Cè
#   E 2023, Sports 11(3):64 (doi 10.3390/sports11030064) — lifting phase at
#   8RM: supinated grip +12% biceps against a neutral (rope) grip and +19%
#   against pronated; brachioradialis also highest supinated (+6% against
#   neutral); anterior deltoid +9% neutral against supinated. Discussion:
#   the brachialis, the most powerful elbow flexor, does not insert on the
#   radius and takes no part in supination.
# - Kohn S, Smart RR, Jakobi JM 2018, Physiol Rep 6(1):e13560 (doi
#   10.14814/phy2.13560) — isometric elbow-flexion MVC was as high or higher
#   with the forearm neutral (243.6 N) as supinated (213.6 N), both above
#   pronated; so the copy says palms-up gives the biceps its best leverage,
#   not that it is the strongest curl grip.
# - Boland MR, Spigelman T, Uhl TL 2008, J Hand Surg Am 33(10):1853-1859 (doi
#   10.1016/j.jhsa.2008.07.019) — fine-wire EMG: no difference in
#   brachioradialis activation between neutral, pronated and supinated
#   forearms during loaded elbow flexion.
# - Kleiber T, Kunz L, Disselhorst-Klug C 2015, Front Physiol 6:215 (doi
#   10.3389/fphys.2015.00215) — slow single flexions: the brachioradialis
#   contributed more only with the forearm pronated (neutral and supinated
#   alike); biceps activity did not differ between hand positions.
# - Murray WM, Delp SL, Buchanan TS 1995, J Biomech 28(5):513-525 (doi
#   10.1016/0021-9290(94)00114-j) — the biceps' flexion moment arm has a
#   larger peak with the forearm supinated.
# - Plantz MA, Bordoni B, StatPearls (NBK551630), Anatomy, Shoulder and Upper
#   Limb, Brachialis Muscle — a pure elbow flexor at every forearm position,
#   inserting on the ulna, with no part in turning the forearm.
# - Pinto RS et al. 2012, J Strength Cond Res 26(8):2140-2145 (doi
#   10.1519/JSC.0b013e31823a3b15) — full-range (0-130°) elbow-flexor training
#   raised the 1RM more than partial range (50-100°); thickness similar.
# - Young S, Porcari JP, Camic C, Kovacs A, Foster C 2014, ACE ProSource
#   (August), ACE-sponsored EMG study, not peer-reviewed — a braced upper arm
#   (concentration curl) gave the most biceps and less anterior deltoid;
#   swaying arms let the anterior deltoid and brachioradialis take load off
#   the biceps.
# - Sands WA, Wurth JJ, Hewit JK 2012, NSCA Basics of Strength and
#   Conditioning Manual — curl coaching: elbows at the sides, no rolling the
#   shoulders forward, no momentum, slow controlled return.
#
# No EMG study of the drag curl or the spider (prone incline) curl as such
# was found (PubMed / Europe PMC searches, 2026-09-27). For the hammer curl
# there are two small, lower-tier studies: Jahizi AAM, Malek NFA, Tan K,
# Marsal MZ, Janep M, Chinnasee C, Nadzalan AM 2023, AIP Conf Proc 3013:050008
# (i-MACE 2022; doi 10.1063/5.0148594), traditional, hammer and reverse
# dumbbell curls in trained men (abstract not readable here, so no result of
# it is used), and Bagchi A, Raizada S 2019, Indian J Public Health Res Dev
# 10(5):730-735 (doi 10.5958/0976-5506.2019.01098.2), eight curls, which
# Coratella 2023 Sports cites as finding no biceps or brachioradialis
# difference between supinated and neutral dumbbell curls. Neither is used
# for a number. The activation shares below are judgement anchored to the
# studied curls and to the older entries (Barbell Curl, Spider Curl,
# Alternating Dumbbell Curl).
#
# Framing and labels: the drag curls and the hammer curl are standing lifts
# seen from the front-left (the EZ bar near front-on; the cable drag curl
# three-quarter from the right, so its near arm is the right); the spider
# curls from behind on the left like the Spider Curl. Labels are pinned with
# `overrides` so no leader crosses the head or another leader, no pill covers
# a tracked dot or key joint, no leader passes within 6 px of another dot or
# lies along a working arm's bone, checked on the app's shots at the production
# rows every 1/6 s over the 8 s loop with measured SF pill widths (+5%), and in
# each fault view the cue's own pill clears the lifted, turned model's head
# and the ghost.
from common_241_300 import *

# ---------------------------------------------------------------- helpers


def arm_glows(name, near="L", rx=0.07, ry=0.07):
    """The working biceps (mid upper arm of the near arm) at full strength and
    the brachialis at its elbow softer. The far arm is left out: in these
    three-quarter and rear views it is mostly hidden behind the torso or pad,
    and a glow at its mean position would sit on the torso."""
    return [glow(name, [f"upper_arm_{near}", f"forearm_{near}"], A, 0.55, rx, ry),
            glow(name, [f"forearm_{near}"], SOFT, 0.30, rx * 0.75, ry * 0.75)]


# ---------------------------------------------------------------- drag curls

DRAG_ELBOW = ("Elbows and Bar Path",
              "The bar slides straight up the body while the elbows travel back.",
              "Drawing the elbows back is what keeps the bar against the body. Stopping at the chest with the forearms about level leaves the bar out in front of the elbows, so the biceps is still loaded at the top; carrying on until the forearms are upright lets the load rest over the elbows.",
              "Letting the elbows swing forward so the bar arcs away from the body, as in an ordinary curl.",
              "Keep the bar brushing the hips, stomach and lower chest, and let the elbows go back behind the body to make room for it; they can ease forward a little at the top.")

DRAG_SHOULDER = ("Shoulder Position",
                 "The shoulders stay down while the bar rises.",
                 "With the bar travelling close to the body it is easy to shrug it the last few centimetres, like an upright row; the upper traps then lift part of the load and the elbow flexors do less.",
                 "Shrugging the shoulders up toward the ears as the bar reaches the chest.",
                 "Set the shoulders down and back before the first rep and keep them there; the bar rises only as far as the elbows bend.")

DRAG_GRIP = ("Grip and Wrists",
             "An underhand grip at shoulder-width, wrists straight.",
             "With the forearms turned palm-up the biceps has its best leverage and works hardest. Curling the wrists in moves the bar with the wrists instead of the elbows and puts needless load on them.",
             "Curling the wrists in toward the forearms as the bar reaches the chest.",
             "Take the bar underhand, hands about shoulder-width apart and palms facing forward with the bar at the thighs, and keep the knuckles in line with the forearms from bottom to top.")

DRAG_GRIP_EZ = ("Grip and Wrists",
                "Hands on the angled grips, wrists straight.",
                "The angled grips turn the palms partly in, which many lifters find easier on the wrists. A straight bar has worked the biceps slightly harder at most, so the choice comes down to comfort. Curling the wrists in moves the bar with the wrists instead of the elbows.",
                "Curling the wrists in toward the forearms as the bar reaches the chest.",
                "Take the bar underhand on the outer angled grips, about shoulder-width apart, and keep the knuckles in line with the forearms from bottom to top.")

DRAG_RANGE = ("Range of Motion",
              "Each rep starts with the bar back at the thighs.",
              "Lowering the bar all the way back down the body keeps each rep long, and curl training through a long range has built more strength than training through a short one.",
              "Short reps that turn around with the bar still at the stomach.",
              "Lower slowly along the same path until the bar rests against the tops of the thighs, then drag it up again.")

DRAG_TORSO = ("Torso Position",
              "The body stays tall and still.",
              "Leaning back to make room for the bar, or rocking the hips forward, borrows momentum from the hips and lower back, so the elbow flexors skip part of the lift.",
              "Leaning back and pushing the hips forward to get the bar up to the chest.",
              "Stand tall with soft knees, brace the core and keep the torso upright for every rep; if the bar only moves when you lean, lighten it.")

DRAG_COMPARISON = ("BAR SWINGING OUT", "Elbows back, bar on the body", "Elbows forward, bar swings out",
                   "With the elbows travelling back, the bar slides up against the body and stays in front of the elbows, so the biceps is loaded all the way to the top.",
                   "Once the elbows swing forward the bar arcs away from the body and the rep turns into an ordinary curl, with the front deltoids helping to lift.")

DRAG_STABILISERS = ["posterior deltoid", "anterior deltoid", "upper trapezius", "wrist flexors"]

ex(name="Drag Curl", var="dragCurl",
   # Front-left at -0.8, facing screen left, left arm on the right. The torso
   # cue marks the base of the neck from the upper left, a short stub beside
   # the head: at the bottom the pelvis sits behind the bar, where its dot lay
   # ~11 px from the near-hand dot, both leaders coming up from the lower
   # right, so the cue read as marking the bar (the neck is never nearer than
   # ~38 px to it). Row 0.22 so that in the torso fault view (side-on) its
   # leader passes above the ghost's hands. The shoulder cue points at the
   # near (left) shoulder from the upper right (with the far shoulder the
   # two leaders would cross); the elbow cue sits level with the near elbow
   # below it, a short stub, with the range (near hand) cue lower still. The
   # grip cue points at the far hand from the left, short so the pill clears
   # the far thigh (the wrists are in the cue sheet).
   overrides={"torso": (0.22, "leading"), "shoulder": (0.24, "trailing"), "grip": (0.56, "leading"),
              "elbow": (0.44, "trailing"), "range": (0.62, "trailing")},
   annotations=[
       ("elbow", "Elbows back", "forearm_L"),
       ("shoulder", "Shoulders down", "upper_arm_L"),
       ("grip", "Underhand grip", "hand_R"),
       ("range", "Lower to the thighs", "hand_L"),
       ("torso", "Stand tall, no leaning", "neck"),
   ],
   cues={"elbow": DRAG_ELBOW, "shoulder": DRAG_SHOULDER, "grip": DRAG_GRIP, "range": DRAG_RANGE, "torso": DRAG_TORSO},
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.62), ("Brachioradialis", S, MOD, 0.44)],
   stabilisers=DRAG_STABILISERS,
   comparison=DRAG_COMPARISON,
   glows=arm_glows("Drag Curl", "L", rx=0.06, ry=0.07))

SETUP["Drag Curl"] = [
    "Take a barbell underhand, hands shoulder-width apart.",
    "Stand tall, feet hip-width, the bar resting against the tops of the thighs.",
    "Set the shoulders down and back, elbows by your sides.",
    "Drag the bar up the body to the lower chest as the elbows travel back.",
]

ex(name="EZ Bar Drag Curl", var="ezBarDragCurl",
   # Near front-on at -0.3, left arm on the right. The shoulder cue points
   # at the top of the near (left) trap beside the neck, from the top right
   # (the support joint projects onto the throat here). The elbow cue sits
   # level with the near elbow, a short stub to it; only ~88 px is free
   # beside the elbow, hence "Elbows back". The near-hand (range) cue comes
   # from low on the right, its leader rising up the side of the waist; the
   # far-hand (grip) cue sits level with the far hand at the bottom, short so
   # its leader leaves left of the far forearm (from a longer pill it ran
   # along it at the top). The torso cue marks the base of the neck from the
   # upper left, a short stub ending ~12 px left of the head and neck: the
   # pelvis dot sat on the bar's middle hump at the bottom (0.14 crosses the
   # head, 0.22-0.26 cover the far upper arm).
   overrides={"shoulder": (0.14, "trailing"), "elbow": (0.36, "trailing"), "range": (0.62, "trailing"),
              "grip": (0.44, "leading"), "torso": (0.18, "leading")},
   annotations=[
       ("elbow", "Elbows back", "forearm_L"),
       ("shoulder", "Shoulders down", "attachment_TrapeziusUpper_L"),
       ("grip", "Angled grip", "hand_R"),
       ("range", "Lower to the thighs", "hand_L"),
       ("torso", "Stand tall, no leaning", "neck"),
   ],
   cues={"elbow": DRAG_ELBOW, "shoulder": DRAG_SHOULDER, "grip": DRAG_GRIP_EZ, "range": DRAG_RANGE, "torso": DRAG_TORSO},
   activation=[("Biceps Brachii", P, HI, 0.82), ("Brachialis", S, MOD, 0.62), ("Brachioradialis", S, MOD, 0.46)],
   stabilisers=DRAG_STABILISERS,
   comparison=DRAG_COMPARISON,
   glows=arm_glows("EZ Bar Drag Curl", "L", rx=0.06, ry=0.07))

SETUP["EZ Bar Drag Curl"] = [
    "Take an EZ bar underhand on the outer angled grips.",
    "Stand tall, feet hip-width, the bar resting against the tops of the thighs.",
    "Set the shoulders down and back, elbows by your sides.",
    "Drag the bar up the body to the lower chest as the elbows travel back.",
]

ex(name="Cable Drag Curl", var="cableDragCurl",
   # Seen from the right, facing screen right toward the stack: the near
   # (right) arm is on the left of the frame, so the shoulder, elbow and
   # range (near hand) cues sit on the left, top to bottom. The elbow cue is
   # level with the near elbow, a short stub to it, and the range cue below
   # it, its leader rising to the near hand (from above it lay along the near
   # arm). The torso cue marks the base of the neck from the upper right,
   # its leader running level across the front of the neck: the pelvis dot
   # sat on the handle's near end cap at the bottom, just under the
   # near-hand dot. It is short because the full label runs onto the chest
   # front there, and from the left its leader would cross the shoulder dot.
   # The grip cue points at the far hand from the right, over the tower,
   # level with the far fist so its leader is a short stub (from lower down
   # it ran down beside the cable at the top, like a second strand).
   overrides={"shoulder": (0.14, "leading"), "elbow": (0.36, "leading"), "range": (0.50, "leading"),
              "torso": (0.22, "trailing"), "grip": (0.40, "trailing")},
   annotations=[
       ("elbow", "Elbows back", "forearm_R"),
       ("shoulder", "Shoulders down", "upper_arm_R"),
       ("grip", "Underhand grip", "hand_L"),
       ("range", "Lower to the thighs", "hand_R"),
       ("torso", "Stand tall", "neck"),
   ],
   cues={
       "elbow": ("Elbows and Bar Path",
                 "The bar slides straight up the body while the elbows travel back.",
                 "The low pulley sits in front, so the cable pulls the bar forward as well as down; drawing the elbows back holds it against the body. Stopping at the chest with the forearms about level leaves the bar out in front of the elbows, so the biceps is still loaded at the top.",
                 "Letting the cable draw the bar out in front, the elbows swinging forward into an ordinary curl.",
                 "Keep the bar brushing the hips, stomach and lower chest, let the elbows go back behind the body, and stand close to the pulley so the cable runs steeply down to it."),
       "shoulder": DRAG_SHOULDER,
       "grip": DRAG_GRIP,
       "range": DRAG_RANGE,
       "torso": DRAG_TORSO[:3] + ("Leaning back against the cable and pushing the hips forward to get the bar up to the chest.",
                                  DRAG_TORSO[4]),
   },
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.62), ("Brachioradialis", S, MOD, 0.44)],
   stabilisers=DRAG_STABILISERS,
   comparison=("BAR PULLED OUT IN FRONT", "Elbows back, bar on the body", "Cable draws the bar out",
               "With the elbows travelling back, the bar slides up against the body and stays in front of the elbows, so the biceps is loaded all the way to the top.",
               "When the cable draws the bar out and the elbows swing forward, the rep turns into an ordinary cable curl, with the front deltoids helping to lift."),
   glows=arm_glows("Cable Drag Curl", "R", rx=0.06, ry=0.07))

SETUP["Cable Drag Curl"] = [
    "Set the pulley at its lowest point and attach a straight bar.",
    "Face the stack close to the pulley and take the bar underhand, hands shoulder-width.",
    "Stand tall, feet hip-width, the bar against the tops of the thighs.",
    "Drag the bar up the body to the lower chest as the elbows travel back.",
]

# ---------------------------------------------------------------- spider curls

SPIDER_PAD = ("Chest Support",
              "The incline pad holds the body still.",
              "With the chest pressed into the pad the torso cannot rock, so the elbow flexors have to lift the whole load; that bracing is what makes the spider curl strict.",
              "Lifting the chest and shoulders off the pad to heave the weight up.",
              "Kneel on the seat, keep the chest and stomach on the pad for every rep, and drop the weight if it only moves when the chest lifts.")

SPIDER_SHOULDER = ("Shoulder Position",
                   "The shoulders stay down, away from the ears.",
                   "Shrugging brings the upper traps into the lift and moves the shoulders off their fixed place over the pad, so the curl stops being an elbow-only movement.",
                   "Shoulders shrugging up toward the ears as the weight rises.",
                   "Let the shoulder blades settle down over the top of the pad and keep the neck long as you curl.")


def spider_elbow(load, hangs, swings, comes):
    """The upper-arm cue with the load named ('the dumbbells' / 'the bar')
    and its verbs agreeing with it."""
    return ("Upper Arm Position",
            "The upper arms hang straight down and stay there.",
            f"With the upper arms vertical, {load} {hangs} almost straight under the elbows at the bottom and {swings} out in front of them on the way up, so the curl gets harder as it rises, is heaviest with the forearms level and stays heavy to the top. Letting the elbows swing toward the head brings the front deltoids in and, near the top, tips {load} back over the elbows, which takes the load off the elbow flexors there.",
            f"The elbows drifting forward toward the head as {load} {comes} up.",
            "Keep the elbows under the shoulders, move only the forearms, and curl until the elbows are fully bent.")


SPIDER_RANGE = ("Range of Motion",
                "Every rep starts from straight arms.",
                "Lowering until the arms hang straight works the elbow flexors through their whole length, and full-range curl training has built more strength than partial reps.",
                "Short reps that stop with the elbows still bent at the bottom.",
                "Lower under control until the arms hang straight below the shoulders, then curl again without bouncing.")

SPIDER_STABILISERS = ["anterior deltoid", "forearm flexors", "middle trapezius", "rhomboids"]

# Seen from behind on the left, the figure lying across the upper-middle of
# the frame, head on the left: the upper-arm, shoulder and back cues stacked
# above it on the right, their leaders fanning down to the near shoulder,
# the far shoulder blade and the upper back without crossing (the upper-arm
# leader passes over the back of the neck, clear of the head). Not above the
# head on the left: in the fault view the model is lifted and turned side-on,
# which puts the head and the ghost's raised hands under any pill there. The
# grip and range cues sit below the weights on the left, range lower, its
# leader climbing steeply to the near elbow and crossing the pad's front edge
# (from the lower right it lay along that edge for its whole length and read
# as the pad's lit rim). The two leaders never cross, the range leader
# staying 15 px or more from the grip dot; mid-rep (about 0.7 s and 3.2 s)
# it passes over the far fist for a moment.
SPIDER_OVERRIDES = {"elbow": (0.14, "trailing"), "shoulder": (0.22, "trailing"), "pad": (0.30, "trailing"),
                    "grip": (0.60, "leading"), "range": (0.70, "leading")}

ex(name="Dumbbell Spider Curl", var="dumbbellSpiderCurl",
   # The pad cue marks the chest joint, on the upper back over the part of
   # the chest pressed into the pad (the spine joint lands at the waist from
   # behind). The grip label is short so its leader leaves left of the near
   # forearm and the range dot on the elbow and runs near-vertical, clear of
   # the range leader (the palms face forward at the bottom, as the label
   # says; the wrists are in the cue sheet).
   overrides=SPIDER_OVERRIDES,
   annotations=[
       ("pad", "Chest stays on the pad", "chest"),
       ("shoulder", "Shoulders down", "scapula_R"),
       ("elbow", "Upper arms hang still", "upper_arm_L"),
       ("grip", "Palms forward", "hand_L"),
       ("range", "Lower to straight arms", "forearm_L"),
   ],
   cues={
       "pad": SPIDER_PAD,
       "shoulder": SPIDER_SHOULDER,
       "elbow": spider_elbow("the dumbbells", "hang", "swing", "come"),
       "grip": ("Grip and Wrists",
                "Palms facing forward, wrists straight.",
                "Holding the dumbbells palms-forward keeps the forearms turned palm-up through the curl, the position in which the biceps works hardest. Curling the wrists in pulls the dumbbells back toward the elbows, which eases the top of the rep and puts needless load on the wrists.",
                "Curling the wrists in toward the forearms at the top of each rep.",
                "Hold the dumbbells with the palms facing forward and the handles across, and keep the knuckles in line with the forearms from bottom to top."),
       "range": SPIDER_RANGE,
   },
   activation=[("Biceps Brachii", P, HI, 0.86), ("Brachialis", S, MOD, 0.66), ("Brachioradialis", S, MOD, 0.46)],
   stabilisers=SPIDER_STABILISERS,
   comparison=("ELBOWS DRIFTING FORWARD", "Upper arms hang straight down", "Elbows swing toward the head",
               "With the upper arms hanging still, the dumbbells swing out in front of the elbows as they rise and stay there, so the biceps is loaded all the way to the top.",
               "When the elbows swing forward, the front deltoids help lift and the dumbbells tip back over the elbows, taking the load off the elbow flexors at the top."),
   # Only the near (left) arm is visible from behind.
   glows=arm_glows("Dumbbell Spider Curl", "L", rx=0.06, ry=0.06))

SETUP["Dumbbell Spider Curl"] = [
    "Set an incline bench to about 45°.",
    "Kneel on the seat, chest on the pad, shoulders just over the top.",
    "Take a dumbbell in each hand, palms facing forward.",
    "Let your arms hang straight down.",
]

ex(name="EZ Bar Spider Curl", var="ezBarSpiderCurl",
   # As the Dumbbell Spider Curl. The grip label is short, as on the EZ Bar
   # Drag Curl: from the longer pill's right end the leader left the arm
   # ~7° from the range leader at the top and passed 11-13 px from the range
   # dot, and with the range cue on the left the two leaders crossed.
   overrides=SPIDER_OVERRIDES,
   annotations=[
       ("pad", "Chest stays on the pad", "chest"),
       ("shoulder", "Shoulders down", "scapula_R"),
       ("elbow", "Upper arms hang still", "upper_arm_L"),
       ("grip", "Angled grip", "hand_L"),
       ("range", "Lower to straight arms", "forearm_L"),
   ],
   cues={
       "pad": SPIDER_PAD,
       "shoulder": SPIDER_SHOULDER,
       "elbow": spider_elbow("the bar", "hangs", "swings", "comes"),
       "grip": ("Grip and Wrists",
                "Hands on the angled grips, wrists straight.",
                "The angled grips turn the palms partly in, which many lifters find easier on the wrists; a straight bar has worked the biceps slightly harder at most, so the choice comes down to comfort. Curling the wrists in pulls the bar back toward the elbows, which eases the top of the rep.",
                "Curling the wrists in toward the forearms at the top of each rep.",
                "Take the bar underhand on the outer angled grips, about shoulder-width apart, and keep the knuckles in line with the forearms from bottom to top."),
       "range": SPIDER_RANGE,
   },
   activation=[("Biceps Brachii", P, HI, 0.84), ("Brachialis", S, MOD, 0.66), ("Brachioradialis", S, MOD, 0.48)],
   stabilisers=SPIDER_STABILISERS,
   comparison=("ELBOWS DRIFTING FORWARD", "Upper arms hang straight down", "Elbows swing toward the head",
               "With the upper arms hanging still, the bar swings out in front of the elbows as it rises and stays there, so the biceps is loaded all the way to the top.",
               "When the elbows swing forward, the front deltoids help lift and the bar tips back over the elbows, taking the load off the elbow flexors at the top."),
   glows=arm_glows("EZ Bar Spider Curl", "L", rx=0.06, ry=0.06))

SETUP["EZ Bar Spider Curl"] = [
    "Set an incline bench to about 45°.",
    "Kneel on the seat, chest on the pad, shoulders just over the top.",
    "Take an EZ bar underhand on the outer angled grips.",
    "Let your arms hang straight down.",
]

# ---------------------------------------------------------------- alternating hammer curl

ex(name="Alternating Hammer Curl", var="alternatingHammerCurl",
   # Front-left like the Alternating Dumbbell Curl: the left elbow and hand
   # on the right, the right shoulder, resting hand and hips on the left. The
   # shoulder cue marks the top of the right trap, clear of the right
   # dumbbell when it is raised. "Keep shoulders down" is just wide enough
   # that its leader leaves near the neck and drops steeply past the raised
   # right dumbbell (from "Shoulders down" it crossed the dumbbell's upper
   # head at the top of the right curl); "Shoulders down and back" is clamped
   # onto the jaw. The elbow cue sits level with the left elbow, a short stub to it
   # (from the top row its leader lay along the whole upper arm); the grip
   # cue is below the resting left dumbbell and the torso cue on the left,
   # off the left calf.
   overrides={"shoulder": (0.14, "leading"), "elbow": (0.36, "trailing"), "grip": (0.62, "trailing"),
              "range": (0.60, "leading"), "torso": (0.74, "leading")},
   annotations=[
       ("shoulder", "Keep shoulders down", "attachment_TrapeziusUpper_R"),
       ("elbow", "Elbow in", "forearm_L"),
       ("grip", "Thumb up, wrist flat", "hand_L"),
       ("range", "Lower to a straight arm", "hand_R"),
       ("torso", "Torso still, no swing", "pelvis"),
   ],
   cues={
       "shoulder": ("Shoulder Position",
                    "The shoulders stay set while the arms take turns.",
                    "Shrugging or rolling the shoulders forward lets the upper traps and front deltoids help lift the dumbbell, taking work away from the elbow flexors.",
                    "Shoulders shrugging up and rolling forward as each dumbbell comes up.",
                    "Draw the shoulders down and back before the first rep and keep them level and still for the whole set."),
       "elbow": ("Elbow Position",
                 "The working elbow stays by your side.",
                 "With the elbow fixed, bending it is the only motion, so the elbow flexors lift the weight. If the elbow drifts forward, the front deltoid joins in and the forearm reaches upright early, where the dumbbell stops loading the elbow.",
                 "The working elbow drifting forward and up as the dumbbell rises, turning the top of the curl into a front raise.",
                 "Keep the elbow close to the ribs and curl until the dumbbell is in front of the shoulder, thumb up, letting the elbow come forward only slightly at the top."),
       "grip": ("Grip and Wrist",
                "The palm faces in, thumb up, for the whole rep.",
                "The neutral grip is what makes this a hammer curl: the biceps, which also turns the palm up, has less leverage and does a little less, while the brachialis and brachioradialis keep lifting. Twisting the palm up turns it back into an ordinary curl, and a bent wrist takes needless load.",
                "Bending the wrist in toward the body as the dumbbell nears the shoulder.",
                "Hold each dumbbell like a hammer, palm facing in and knuckles in line with the forearm, and keep it that way from bottom to top without twisting."),
       "range": ("Range of Motion",
                 "Each curl starts from a straight arm.",
                 "Lowering all the way works the elbow flexors through their whole length, and full-range curl training has built more strength than partial reps.",
                 "Leaving the resting arm half-bent at the bottom and starting its next curl from there.",
                 "Lower each dumbbell until the arm hangs straight by your side, palm facing in, before the other arm starts."),
       "torso": ("Body Swing",
                 "The legs and back stay out of it.",
                 "Rocking the torso or pushing the hips forward borrows momentum from the hips and lower back, so the elbow flexors skip the hardest part of each curl.",
                 "Leaning back and pushing the hips forward to swing each dumbbell up.",
                 "Stand tall with soft knees, brace the core and lower each dumbbell under control so the next rep starts from a still body."),
   },
   activation=[("Brachialis", P, HI, 0.76), ("Biceps Brachii", P, HI, 0.74), ("Brachioradialis", S, MOD, 0.44)],
   stabilisers=["anterior deltoid", "upper trapezius", "flexor carpi radialis", "extensor carpi radialis"],
   comparison=("ELBOW DRIFTING FORWARD", "Elbow stays by your side", "Elbow swings forward and up",
               "With the elbow by the side, the elbow flexors lift the dumbbell through the whole curl.",
               "When the elbow drifts forward, the front deltoid lifts part of the weight and the forearm reaches upright early, where the dumbbell stops loading the elbow."),
   # The left (first) arm's upper arm and forearm, the right upper arm softer.
   glows=[glow("Alternating Hammer Curl", ["upper_arm_L", "forearm_L", "forearm_L"], A, 0.55, 0.06, 0.07),
          glow("Alternating Hammer Curl", ["upper_arm_R", "forearm_R", "forearm_R"], SOFT, 0.30, 0.06, 0.07),
          glow("Alternating Hammer Curl", ["forearm_L", "forearm_L", "hand_L"], SOFT, 0.28, 0.045, 0.05)])

SETUP["Alternating Hammer Curl"] = [
    "Hold a dumbbell in each hand, palms facing in.",
    "Stand tall, feet hip-width, arms straight by your sides.",
    "Shoulders down and back, elbows by your ribs.",
    "Curl one arm at a time, thumb up, without twisting the wrist.",
]

if __name__ == "__main__":
    probs = validate(["Drag Curl", "EZ Bar Drag Curl", "Cable Drag Curl", "Dumbbell Spider Curl", "EZ Bar Spider Curl", "Alternating Hammer Curl"]); print("\n".join(probs) or "OK")
