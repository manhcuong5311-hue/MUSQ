# Trainer content for batch 241-300 (2026-09-27), family: wrist curls,
# reverse wrist curls and the finger curl. Source exports 269-274 and 276
# from the HIKSEMI drive's "241-300" folder (SourceExports/241-300).
# Same format as spec.py; spec_241_300.py imports this module and gen.py
# reads SPEC / SETUP.
#
# What each model shows, from the briefs, the framing shots and the rig
# (joints sampled over the clip; the dumbbells', bars' and cable's own
# bounds read from the USD; torso length, neck to pelvis, is 0.59 m).
# Every clip is 8 s, two identical 4 s reps; only the wrists (and, in the
# finger curl, the fingers) move.
# - The six seated models share one body: sitting on the end of a flat
#   bench, feet flat ~0.38 m apart (about shoulder-width: shoulder joints
#   0.39 m, hip joints 0.18 m), knees ~112°, trunk leaning ~55° forward
#   over the thighs, head down. The forearms lie along the thighs, sloping
#   ~23° down toward the knees (elbows bent to ~64°, ~10 cm higher than the
#   wrists), and do not move; the wrists sit ~3 cm ahead of the knee joints,
#   over the kneecaps, so the hands hang free beyond the knees; hands 0.33 m
#   apart. The torso, shoulders and forearms are still for the whole clip.
#   A rep: ~1.3 s up, a ~0.3 s hold, ~1.7 s down, ~0.7 s still at the bottom.
# - Dumbbell Wrist Curl (269): a dumbbell in each hand, palms up, a full
#   grip (fingers ~141° closed, the thumb wrapped over to meet them) that
#   never opens. Wrists from ~58° extension (hands hanging steeply, ~72°
#   below level) to ~47° flexion (palms turned toward the lifter). The
#   dumbbells' pull on the wrists (lever, handle to wrist 8 cm): 2.6 cm
#   hanging at the bottom, 8 cm as the hands pass level, 6.7 cm at the top.
# - Barbell Reverse Wrist Curl (270) and Dumbbell Reverse Wrist Curl (271):
#   an Olympic barbell / a dumbbell in each hand, overhand, palms down, full
#   grip; wrists from ~31° flexion (hands hanging) to ~55° extension
#   (knuckles up). Lever 3.9 cm at the bottom, 8 cm mid-way, 7.4 cm at the
#   top. The two are the same motion (the builder's note: "as 270 with
#   dumbbells").
# - Cable Wrist Curl (272) and Cable Reverse Wrist Curl (273): a straight
#   cable bar from a low pulley ~0.85 m in front of the bar, centred on the
#   lifter; underhand (the wrist curl's arc) or overhand (the reverse
#   curl's arc). The cable runs ~23° below level at the bottom, ~30° at the
#   top, so it pulls the bar forward toward the pulley more than down: it
#   resists from about the point where the hands line up with the forearms
#   and hardest at the top (lever ~7 cm and ~6.4 cm); in the lowest part it
#   pulls the hands forward, so it gives no resistance there. The copy says
#   the load builds toward the top and is greatest there, with the pulley
#   out in front as here; sitting close to the pulley would make the cable
#   near vertical and the profile like a dumbbell's, so the set-up says to
#   sit about a stride back.
# - Behind-the-Back Wrist Curl (274): standing tall, feet ~0.32 m apart,
#   knees ~175°, trunk upright and still, shoulders level. The arms hang
#   straight (elbows 178°), angled ~20° back, hands 0.49 m apart; an
#   Olympic barbell behind the thighs at the level of the lower glutes,
#   palms facing back, full grip. Wrists from ~45° extension (bar hanging
#   almost straight below the wrists, lever ~2 cm) to ~41° flexion (bar
#   curled back and up, lever 7.3 cm). As the wrists curl the arms swing
#   ~6° forward, toward the legs (20° to 13.5° behind vertical; the wrists
#   ~6 cm forward and ~2 cm lower at the top), so the bar itself moves only
#   ~4 cm back and ~2.5 cm up.
# - Finger Curl (276): the seated body, an Olympic barbell underhand, palms
#   up. The clip starts at the top (fingers closed ~147°, wrist flexed
#   ~27°, the bar in the palm); the fingers open to ~46° and the bar rolls
#   down to the fingertips (the thumb comes off it; the bar axis ~3.5 cm
#   from the fingertip joints and ~6.7 cm from the knuckles, hooked by the
#   last finger bones) as the wrist extends to ~43° (bottom at
#   ~1.3-1.7 s); then the fingers close, roll it back into the palm and the
#   wrist curls up, the fingers and the wrist moving together both ways
#   (each about halfway at 2.3 s; top again by ~3.3 s). The top is only
#   ~27° of flexion, against the wrist curls' 47°. The bar moves
#   from 8.5 cm to 14 cm from the wrist, so its lever grows from ~7 cm at
#   the top to ~11 cm with it out in the fingers.
#
# Framing: the barbell reverse and finger curls are framed at yaw -1.0 and
# the two dumbbell curls at yaw -0.7 (zoom 1.009, offset (0.142, 0.23,
# -0.119), so the near plates clear the fists at the top), left side toward
# the camera, the lifter facing left, left arm on the right of the frame,
# nearer; the two cable models at +1.0 (offset y 0.195; facing right, right
# arm nearer, on the left), the behind-the-back curl at -2.4 (from behind on
# the left, left arm on the left). Labels are pinned with `overrides` into
# the open space above and below the lifter. On the two dumbbell curls the
# near dumbbell covers the near elbow at the top, so the forearm dot
# (forearm_L) sits on its plate there; there is no joint to swap to
# (forearm_R lands on the near fist, spine and the near lat on the plate or
# the trunk), and framing at yaw -0.9 or wider would show it but would cover
# the near fist again.
#
# Sources:
# - Neumann DA, Kinesiology of the Musculoskeletal System, 3rd ed. (Elsevier
#   2017), ch. 7 (wrist): flexor carpi radialis, flexor carpi ulnaris and
#   palmaris longus are the primary wrist flexors; the extrinsic finger
#   flexors (flexor digitorum superficialis and profundus, flexor pollicis
#   longus) are secondary wrist flexors; the flexor digitorum superficialis
#   flexes the knuckle and middle joints, the profundus also the fingertip
#   joints and the wrist. Primary wrist extensors: extensor carpi radialis
#   longus and brevis and extensor carpi ulnaris; the finger extensors
#   assist, extensor digitorum among them (also Kenhub, Extensor carpi
#   radialis longus; StrengthLog, forearm extensors article, which counts
#   the wrist extensors and the finger and thumb extensors as the forearm
#   extensors, so the reverse curls' secondary row names extensor
#   digitorum rather than the whole group).
# - Gonzalez RV, Buchanan TS, Delp SL 1997, J Biomech 30(7):705-712 (doi
#   10.1016/s0021-9290(97)00015-8) — model of 15 wrist muscles: peak
#   flexion moment exceeds peak extension moment mainly because the flexors'
#   summed cross-sectional area is ~110% larger; flexion moment varies more
#   with wrist angle and peaks with the wrist flexed.
# - Delp SL, Grierson AE, Buchanan TS 1996, J Biomech 29(10):1371-1375 (doi
#   10.1016/0021-9290(96)00029-2) — ten men: peak isometric wrist flexion
#   moment 12.2 N m, extension 7.1 N m (extension ~58% of flexion); flexion
#   moment peaked at ~40° flexion, extension moment about constant from 30°
#   flexion to 70° extension; passive moments near zero in the central 150°
#   of motion, rising at the ends.
# - Snijders CJ, Volkers AC, Mechelse K, Vleeming A 1987, Med Sci Sports
#   Exerc 19(5):518-523 — grasping and pinching always produce a flexing
#   moment at the wrist, balanced by extensor activity (force and EMG).
# - Mogk JP, Keir PJ 2003, Ergonomics 46(9):956-975 (doi
#   10.1080/0014013031000107595) — baseline extensor activity (holding the
#   dynamometer without exerting grip force) greatest with the forearm
#   pronated and the wrist extended, flexor activity largest supinated with
#   the wrist flexed; extensor activity always greater pronated; a flexed
#   wrist cut maximum grip force by 40-50%.
# - Ikeda K, Kaneoka K, Matsunaga N, Ikumi A, Yamazaki M, Yoshii Y 2025, J
#   Orthop Surg Res 20(1):53 (doi 10.1186/s13018-024-05363-x; full text,
#   PMC11740565) — 20 men, 40 limbs: maximum isometric wrist extension
#   torque 8.2 N m against flexion 13.6 N m (neutral forearm, about 60%);
#   at 75% effort ECRB %MVE in extension 72% pronated against 55%
#   supinated, FCR %MVE in flexion 93% supinated against 58% pronated;
#   extensor co-activation during flexion ECRB 14-16%, ECU 16% supinated
#   and 46% pronated.
# - Kaufmann RA, Kozin SH, Mirarchi A, Holland B, Porter S 2007, Am J
#   Orthop 36(9):E128-E132 (PMID 17948164) — 11 cadaver forearms, tendons
#   pulled in isolation: FDP gave the most grip force with the handle on
#   the distal phalanx, FDS with it on the middle phalanx, falling off
#   over the distal phalanx.
# - Navsaria R, Ryder DM, Lewis JS, Alexander CM 2015, Br J Sports Med
#   49(5):318-322 (doi 10.1136/bjsports-2013-092563) — surface EMG of
#   extensor carpi radialis brevis rose with progressively loaded eccentric
#   wrist extensor exercises (supports naming the radial extensors as the
#   working muscles of the reverse curls).
# - ExRx.net (the site blocks direct fetches; text read on archived copies
#   in the Wayback Machine): Dumbbell, Barbell and Cable Wrist Curl (sit,
#   underhand grip, forearms on thighs with the wrists just beyond the knees;
#   let the bar roll out of the palms down to the fingers, then raise it by
#   gripping and pointing the knuckles up as high as possible; target wrist
#   flexors); Barbell, Dumbbell and Cable Reverse Wrist Curl (narrow to
#   shoulder-width overhand grip, forearms on thighs with the wrists just
#   beyond the knees, knuckles up as high as possible, then down as far as
#   possible; target wrist extensors; comment on the barbell and dumbbell
#   pages: keep the elbows at about wrist height to keep resistance through
#   the whole range; on the cable page: do not allow the elbows to rise).
#   The dumbbell pages work one arm at a time; the models use a dumbbell in
#   each hand. The wrist curl models keep the grip closed, so the copy names
#   ExRx's roll to the fingers as a common variation and teaches it under
#   the Finger Curl; the models' elbows sit ~10 cm above the wrists, so the
#   copy does not repeat the elbow-height comment.
# - ACE Exercise Library, Wrist Curl - Flexion (#30) and Wrist Curl -
#   Extension (#29), both fetched: kneeling, elbows and forearms on a bench,
#   the dumbbells hanging free past the edge; lower slowly into extension
#   (#30) or flexion (#29) without releasing the grip, extending the arms or
#   leaning forward or backward, and hold that lowered position briefly.
#   #30 only: releasing the grip while lowering, letting the dumbbells roll
#   to the fingertips, may add load to the forearm muscles but increases
#   the risk of wrist injury and of dropping the dumbbells; squeeze the
#   weights as hard as possible in both phases.
# - StrengthLog: Barbell and Dumbbell Wrist Curl (forearms on the thighs or
#   a bench; let the bar or dumbbell roll out into the fingers, then close
#   the grip and bend the wrists up; trains the wrist flexors and the
#   muscles that close the hand), Barbell Wrist Curl Behind the Back (grab a
#   barbell behind the back and let it hang in the arms; roll it into the
#   fingers and curl it back up), How to Train Your Forearm Flexors and
#   Grip (kneel at a bench if the thighs feel wobbly) and How to Train Your
#   Forearm Extensors (the wrist extensors plus the finger and thumb
#   extensors; the extensors stabilise the wrist for a strong grip; on the
#   wrist extension, most people go too heavy, curl the fingers to cheat or
#   bounce at the bottom, take 2-3 s on the way down; with a bar, do not
#   bounce at the bottom or over-crank into end range at the top).
# - GymStreak, Seated Barbell Finger Curls (the model builder's reference):
#   hands less than shoulder-width, underhand, forearms supported with the
#   wrists at the edge; let the bar roll down the fingers, curl it up as far
#   as possible, hold the top for a full second, slow controlled reps;
#   listed as Beginner.
# Evidence is thin: no EMG study of any wrist curl variation was found, so
# the activation fractions are estimates from the anatomy above (the prime
# movers high, the finger flexors that also flex the wrist moderate and
# listed as one row, since no study ranks the two in a closed grip), and
# the notes say so. The finger curl ranks FDP above FDS only from where the
# bar sits (Kaufmann 2007, cadaver). Where the load is heaviest comes from
# the models' geometry, not from a study.
from common_241_300 import *

# ---------------------------------------------------------------- shared cues (seated, forearms on the thighs)


def _come(load):
    return "comes" if load == "bar" else "come"


def _meet(load):
    return "meets" if load == "bar" else "meet"


def forearm_cue(load, movers, palms, joints="the wrists are the only joints"):
    return ("Forearm Support",
            f"The forearms rest along the thighs, {palms}, and stay there.",
            f"With the forearms held on the thighs, {joints} free to move, so the {movers} lift the {load} on their own. When the forearms lift, the elbows bend and the arms help, and the wrists do less.",
            f"The forearms lifting off the thighs as the {load} {_come(load)} up, the elbows bending to help.",
            "Lay the forearms along the thighs, press them down lightly and move only the hands.")


def position_cue(load, blocked, verb="bend back"):
    return ("Wrist Position",
            "The wrists sit just beyond the knees so the hands hang free.",
            f"With the hands clear of the knees they can drop fully at the bottom and curl all the way up. With the wrists back on the thighs, the legs {blocked} and the bottom of each rep is lost.",
            f"Sitting with the forearms too far back, the wrists on the thighs, so the {load} {_meet(load)} the legs before the wrists {verb}.",
            "Slide the forearms forward until the wrists just clear the knees, and keep them there for the whole set.")


def torso_cue(load, extra=""):
    return ("Body Position",
            "Lean forward over the thighs and keep the body still.",
            f"Rocking the shoulders back throws the {load} up with the body instead of the wrists, and it pulls the forearms off the thighs.{extra}",
            f"Rocking the shoulders back as the {load} {_come(load)} up, the forearms lifting off the thighs with them.",
            "Sit with the feet flat, lean forward over the thighs and move only the hands, lowering each rep under control.")


def grip_cue(load, hands, grip_intro, grip_how, extra):
    slide = "slides" if load == "bar" else "slide"
    return ("Grip",
            grip_intro,
            f"A closed grip keeps the {load} under control while the wrists are bent at the bottom, where a loose grip lets {'it' if load == 'bar' else 'them'} slip toward the fingertips. {extra}",
            f"The grip loosening at the bottom so the {load} {slide} toward the fingertips.",
            grip_how)


# The label rows (0.14-0.86 scale, squeezed into 0.16-0.80 by
# spec_241_300.py). Seated, framed at yaw -1.0 (barbell) or -0.7
# (dumbbells): the lifter faces left, the hands and the dumbbells or bar sit
# left of centre at mid-height, the bench runs off to the right. Two labels
# go above the lifter, two below and one to the right over the bench. The
# hand cues are crossed: the top-left label tracks the near (left) hand, so
# its leader passes behind the head rather than down through it, and the
# bottom-left label the far (right) hand, so its leader stays clear of the
# knee dot. The torso cue tracks the near shoulder blade (spine projects
# onto the near elbow here).
SEATED_LEFT = {"grip": (0.14, "leading"), "torso": (0.14, "trailing"), "forearm": (0.68, "trailing"),
               "position": (0.86, "trailing")}
# The dumbbell models are framed at yaw -0.7, zoom 1.01, and the head rises
# to the top row, so their top-left label sits higher (0.10 on screen),
# ~10 px clear of the crown and ~6 px under the COMMON MISTAKE banner in
# mistake mode. The right side cannot, since the eye button sits there.
GRIP_ABOVE_HEAD = (0.07, "leading")


def seated_glows(name, near="L", far="R", rx=0.065, ry=0.035):
    """The forearm muscles of both arms, mid-forearm between elbow and wrist:
    the nearer arm at full strength, the farther one soft."""
    return [glow(name, [f"forearm_{near}", f"hand_{near}"], A, 0.55, rx, ry),
            glow(name, [f"forearm_{far}", f"hand_{far}"], SOFT, 0.30, rx, ry)]


# The finger flexors (flexor digitorum superficialis and profundus) as one
# row: no study ranks the two in a closed-grip wrist curl, so they had the
# same estimate, and the trainer's one-line legend cut the second name off.
# The Finger Curl, where the two lead and the bar's place ranks them, keeps
# them apart.
FLEXORS = [("Wrist Flexors", P, HI, 0.86), ("Finger Flexors", S, MOD, 0.55)]
# Extensor digitorum, not "Forearm Extensors": that group name includes the
# wrist extensors already listed as the prime movers.
EXTENSORS = [("Wrist Extensors", P, HI, 0.86), ("Extensor Digitorum", S, MOD, 0.45)]

EXTENSORS_WEAKER = ("The wrist extensors are only about 60% as strong as the wrist flexors, "
                    "so a weight that suits a wrist curl is too heavy here and the rep stops short.")

SETUP_SEATED_START = "Sit on the end of a flat bench, feet flat and about shoulder-width apart."
SETUP_SEATED_END = "Slide your forearms forward until your wrists just clear your knees."

# ---------------------------------------------------------------- dumbbell wrist curl

ex(name="Dumbbell Wrist Curl", var="dumbbellWristCurl",
   overrides=dict(SEATED_LEFT, range=(0.86, "leading"), grip=GRIP_ABOVE_HEAD),
   # Crossed hands (see SEATED_LEFT): the bottom-row range cue tracks the far
   # wrist, the top-row grip cue the near one; both wrists show at the
   # bottom, where the two cues read. The knee dot is on shin_L, the knee
   # joint: with the hands hanging at the bottom, patella_L sits on the near
   # dumbbell's inner plate edge, right under the near fist.
   annotations=[
       ("forearm", "Forearms on thighs", "forearm_L"),
       ("position", "Wrists just past the knees", "shin_L"),
       ("range", "Let the wrists bend back", "hand_R"),
       ("grip", "Keep the grip closed", "hand_L"),
       ("torso", "Body still, no rocking", "scapula_L"),
   ],
   cues={
       "forearm": forearm_cue("dumbbells", "forearm flexors", "palms up"),
       "position": position_cue("dumbbells", "block the hands"),
       "range": ("Range of Motion",
                 "Lower until the wrists bend well back, then curl as high as they go.",
                 "The wrist curl works the forearm flexors over the whole arc, from the wrists bent back as far as they go to the knuckles curled up as high as they go. Short reps leave out the lowered end, where the muscles start from a stretch.",
                 "Short reps that stop with the wrists barely bent back at the bottom.",
                 "Lower slowly until the dumbbells hang well below the forearms, pause, then curl the hands up as far as they go and hold for a moment."),
       "grip": grip_cue("dumbbells", "hands",
                        "The fingers and thumbs stay wrapped round the handles.",
                        "Squeeze the handles with the fingers and thumbs wrapped round them from the first rep to the last.",
                        "Loosening it there without meaning to also makes it easier to strain a wrist or drop the weight. Many guides let the handle roll into the fingers on purpose to work the grip too; this version keeps the hand closed, and the finger curl trains the roll."),
       "torso": torso_cue("dumbbells"),
   },
   activation=FLEXORS,
   stabilisers=["wrist extensors", "thumb flexors"],
   comparison=("FOREARMS OFF THE THIGHS", "Forearms stay on the thighs", "Forearms lift as the weights rise",
               "With the forearms resting on the thighs, only the wrists move and the forearm flexors lift the dumbbells through the whole arc.",
               "When the forearms lift, the elbows bend and the arms raise part of the load, so the wrists do less of the work."),
   glows=seated_glows("Dumbbell Wrist Curl"))

SETUP["Dumbbell Wrist Curl"] = [
    SETUP_SEATED_START,
    "Hold a dumbbell in each hand, palms up.",
    "Lean forward and rest your forearms along your thighs.",
    SETUP_SEATED_END,
]

# ---------------------------------------------------------------- reverse wrist curls (barbell, dumbbell)

TOP_REVERSE = ("Top of the Rep",
               "Lift the knuckles well above the forearms.",
               EXTENSORS_WEAKER + " A lighter weight lets the knuckles rise well above the forearms, so the extensors work through a long range.",
               "Stopping with the hands about level, the knuckles barely rising above the forearms.",
               "Choose a weight light enough to lift the knuckles well above the forearms without forcing the last few degrees, hold a moment, then lower slowly until the hands hang below the forearms.")

GRIP_REVERSE_EXTRA = ("The grip is weakest with the wrist bent down, as it is here at the bottom. "
                      "Squeezing hard also makes the wrist extensors work harder, since a firm grip tends to bend the wrist down.")

ex(name="Barbell Reverse Wrist Curl", var="barbellReverseWristCurl",
   overrides=dict(SEATED_LEFT, top=(0.86, "leading")),
   # The near plate covers spine and forearm_L in this framing, so the torso
   # and forearm cues track the near shoulder blade and the far forearm.
   # Crossed hands (see SEATED_LEFT): both fists show at the top, so the
   # top cue takes the far one and the grip cue the near one.
   annotations=[
       ("forearm", "Forearms on thighs", "forearm_R"),
       ("position", "Wrists just past the knees", "patella_L"),
       ("top", "Knuckles up high", "hand_R"),
       ("grip", "Overhand, grip closed", "hand_L"),
       ("torso", "Body still, no rocking", "scapula_L"),
   ],
   cues={
       "forearm": forearm_cue("bar", "wrist extensors", "palms down"),
       "position": position_cue("bar", "get in the way of the bar", "bend down"),
       "top": TOP_REVERSE,
       "grip": grip_cue("bar", "hands",
                        "Overhand, the hands shoulder-width or a little narrower, thumbs wrapped round.",
                        "Take the bar overhand with the hands shoulder-width or a little narrower, wrap the thumbs round and keep the grip firm for the whole set.",
                        GRIP_REVERSE_EXTRA),
       "torso": torso_cue("bar"),
   },
   activation=EXTENSORS,
   stabilisers=["finger flexors", "thumb flexors"],
   comparison=("STOPPING SHORT AT THE TOP", "Knuckles lifted high", "Hands stop level",
               "With a bar light enough to lift the knuckles well above the forearms, the wrist extensors work through a long range.",
               "With too heavy a bar the hands stop about level, the knuckles barely above the forearms, and the top of the lift is never trained."),
   glows=seated_glows("Barbell Reverse Wrist Curl", rx=0.055, ry=0.03))

SETUP["Barbell Reverse Wrist Curl"] = [
    SETUP_SEATED_START,
    "Take a light barbell overhand, hands shoulder-width or a little narrower.",
    "Lean forward and rest your forearms along your thighs, palms down.",
    SETUP_SEATED_END,
]

ex(name="Dumbbell Reverse Wrist Curl", var="dumbbellReverseWristCurl",
   overrides=dict(SEATED_LEFT, grip=(0.86, "leading"), top=GRIP_ABOVE_HEAD),
   # The top cue must stay on the near fist, the only one visible at the top
   # (yaw -0.7; the far one is behind the far dumbbell). Its pill goes
   # top-left and the far-hand grip pill bottom-left, so neither leader
   # crosses the head: from the top-left, a leader to the far wrist (almost
   # straight below the pill) ran through the back of the skull. The long
   # label pushes the pill's edge right, so its leader passes ~20 px behind
   # the ear ('Knuckles up high' there would cross the head), and ~30 px in
   # mistake mode. The knee dot is on shin_L, as the wrist curl's.
   annotations=[
       ("forearm", "Forearms on thighs", "forearm_L"),
       ("position", "Wrists just past the knees", "shin_L"),
       ("top", "Lift the knuckles up high", "hand_L"),
       ("grip", "Palms down, grip closed", "hand_R"),
       ("torso", "Body still, no rocking", "scapula_L"),
   ],
   cues={
       "forearm": forearm_cue("dumbbells", "wrist extensors", "palms down"),
       "position": position_cue("dumbbells", "get in the way of the dumbbells", "bend down"),
       "top": TOP_REVERSE,
       "grip": grip_cue("dumbbells", "hands",
                        "Palms down, the fingers and thumbs wrapped round the handles.",
                        "Hold the dumbbells overhand, palms facing the floor, thumbs wrapped round, and keep the grip firm for the whole set.",
                        GRIP_REVERSE_EXTRA),
       "torso": torso_cue("dumbbells"),
   },
   activation=EXTENSORS,
   stabilisers=["finger flexors", "thumb flexors"],
   comparison=("FOREARMS OFF THE THIGHS", "Forearms stay on the thighs", "Forearms lift as the weights rise",
               "With the forearms resting on the thighs, only the wrists move and the wrist extensors lift the dumbbells.",
               "When the forearms lift, the elbows bend and the arms raise part of the load, so the wrists do less of the work."),
   glows=seated_glows("Dumbbell Reverse Wrist Curl"))

SETUP["Dumbbell Reverse Wrist Curl"] = [
    SETUP_SEATED_START,
    "Hold a light dumbbell in each hand, palms down.",
    "Lean forward and rest your forearms along your thighs.",
    SETUP_SEATED_END,
]

# ---------------------------------------------------------------- cable wrist curls

# Framed at yaw +1.0: the lifter faces right, the hands and the bar sit right
# of centre at mid-height, the cable runs down to the pulley on the right,
# the bench off to the left. The mirror of SEATED_LEFT, hand cues crossed the
# same way (the top-right label on the near, right hand; the bottom-right on
# the far fist, which shows at the top) and the torso cue on scapula_R.
SEATED_RIGHT = {"grip": (0.14, "trailing"), "torso": (0.14, "leading"), "forearm": (0.68, "leading"),
                "position": (0.86, "leading"), "top": (0.86, "trailing")}

CABLE_LINE = ("In this set-up the cable pulls forward toward the low pulley rather than straight down, "
              "so the resistance builds as the hands curl up and is greatest at the top.")

ex(name="Cable Wrist Curl", var="cableWristCurl",
   overrides=SEATED_RIGHT,
   annotations=[
       ("forearm", "Forearms on thighs", "forearm_R"),
       ("position", "Wrists just past the knees", "patella_R"),
       ("top", "Curl all the way up", "hand_L"),
       ("grip", "Keep the grip closed", "hand_R"),
       ("torso", "Body still, no rocking", "scapula_R"),
   ],
   cues={
       "forearm": forearm_cue("bar", "forearm flexors", "palms up"),
       "position": position_cue("bar", "block the hands"),
       "top": ("Top of the Rep",
               "Curl the bar all the way up and hold it there a moment.",
               CABLE_LINE + " Stopping short cuts off the part of the rep the cable loads most.",
               "Stopping with the hands about level, the bar never curled up toward the body.",
               "Curl until the palms turn toward you, hold a moment, then lower until the wrists bend well back."),
       "grip": grip_cue("bar", "hands",
                        "Underhand, the hands shoulder-width or a little narrower, fingers and thumbs wrapped round.",
                        "Take the bar underhand with the hands shoulder-width or a little narrower, wrap the thumbs round and keep the grip firm for the whole set.",
                        "Many guides let the bar roll into the fingers on purpose to work the grip too; this version keeps the hand closed, and the finger curl trains the roll."),
       "torso": torso_cue("bar", " Leaning back also pulls the cable with the body."),
   },
   activation=FLEXORS,
   stabilisers=["wrist extensors", "thumb flexors"],
   comparison=("STOPPING SHORT AT THE TOP", "Bar curled all the way up", "Hands stop level",
               "With the pulley out in front, as here, the cable pulls hardest at the top, so curling all the way up trains the part of the rep it loads most.",
               "Stopping with the hands about level skips the part of the rep the cable loads most."),
   glows=seated_glows("Cable Wrist Curl", near="R", far="L"))

SETUP["Cable Wrist Curl"] = [
    "Attach a straight bar to a low pulley and sit on the end of a bench facing it, about a stride back.",
    "Take the bar underhand, hands shoulder-width or a little narrower.",
    "Lean forward and rest your forearms along your thighs, palms up.",
    SETUP_SEATED_END,
]

ex(name="Cable Reverse Wrist Curl", var="cableReverseWristCurl",
   overrides=SEATED_RIGHT,
   annotations=[
       ("forearm", "Forearms on thighs", "forearm_R"),
       ("position", "Wrists just past the knees", "patella_R"),
       ("top", "Knuckles up high", "hand_L"),
       ("grip", "Overhand, grip closed", "hand_R"),
       ("torso", "Body still, no rocking", "scapula_R"),
   ],
   cues={
       "forearm": forearm_cue("bar", "wrist extensors", "palms down"),
       "position": position_cue("bar", "get in the way of the bar", "bend down"),
       "top": ("Top of the Rep",
               "Lift the knuckles well above the forearms.",
               CABLE_LINE + " " + EXTENSORS_WEAKER,
               "Stopping with the hands about level, the knuckles barely rising above the forearms.",
               "Choose a light weight, lift the knuckles well above the forearms without forcing the last few degrees, hold a moment, then lower slowly until the wrists bend down."),
       "grip": grip_cue("bar", "hands",
                        "Overhand, the hands shoulder-width or a little narrower, thumbs wrapped round.",
                        "Take the bar overhand with the hands shoulder-width or a little narrower, wrap the thumbs round and keep the grip firm for the whole set.",
                        GRIP_REVERSE_EXTRA),
       "torso": torso_cue("bar", " Leaning back also pulls the cable with the body."),
   },
   activation=EXTENSORS,
   stabilisers=["finger flexors", "thumb flexors"],
   comparison=("FOREARMS OFF THE THIGHS", "Forearms stay on the thighs", "Forearms lift as the bar rises",
               "With the forearms resting on the thighs, only the wrists move and the wrist extensors raise the bar against the cable.",
               "When the forearms lift, the elbows bend and the arms raise part of the load, so the wrists do less of the work."),
   glows=seated_glows("Cable Reverse Wrist Curl", near="R", far="L"))

SETUP["Cable Reverse Wrist Curl"] = [
    "Attach a straight bar to a low pulley and sit on the end of a bench facing it, about a stride back.",
    "Take the bar overhand, hands shoulder-width or a little narrower.",
    "Lean forward and rest your forearms along your thighs, palms down.",
    SETUP_SEATED_END,
]

# ---------------------------------------------------------------- behind-the-back wrist curl

ex(name="Behind-the-Back Wrist Curl", var="behindTheBackWristCurl",
   # From behind on the left: the shoulder and arm cues above the lifter,
   # the hand, bar and stance cues below, each on its own side. The short
   # shoulder label keeps its pill right of the head: 'Shoulders down, no
   # shrug' renders wider than gen's estimate, was pushed left by the right
   # margin and ran its leader down the side of the skull.
   overrides={"shoulders": (0.14, "trailing"), "arms": (0.14, "leading"), "range": (0.86, "leading"),
              "swing": (0.68, "trailing"), "stance": (0.86, "trailing")},
   annotations=[
       ("arms", "Arms straight", "forearm_L"),
       ("shoulders", "Shoulders down", "attachment_TrapeziusUpper_R"),
       ("swing", "Arms still, bar close", "hand_R"),
       ("range", "Curl the bar up and back", "hand_L"),
       ("stance", "Stand tall, knees soft", "patella_R"),
   ],
   cues={
       "arms": ("Arm Position",
                "The arms hang straight behind you; only the wrists bend.",
                "With the elbows straight, curling the wrists is the only way to raise the bar, so the forearm flexors do the lifting. Bending the elbows turns the lift into a pull with the arms.",
                "The elbows bending and driving back to pull the bar up behind the hips.",
                "Straighten the arms before the first rep and keep them straight; let the wrists alone lift the bar."),
       "shoulders": ("Shoulder Position",
                     "The shoulders stay down and level.",
                     "Shrugging lifts the bar with the upper trapezius, so the shoulders raise it instead of the wrists.",
                     "Shrugging the shoulders up toward the ears as the bar rises.",
                     "Stand tall with the shoulders down and keep them level while the wrists curl."),
       "swing": ("Bar Path",
                 "The arms barely move and the bar stays close behind the thighs.",
                 "Swinging the arms back lifts the bar from the shoulders and takes the load off the wrists; with the arms still, the bar can only rise as the wrists curl.",
                 "Swinging the arms back away from the legs to lift the bar.",
                 "Let the bar hang just behind the thighs and keep the arms still, so it rises only by the curl of the wrists."),
       "range": ("Range of Motion",
                 "Let the hands tip toward the legs at the bottom, then curl the bar up and back as far as it goes.",
                 "At the bottom the bar hangs almost straight below the wrists and pulls little against them; it swings out behind them as they curl, so the load builds toward the top. Stopping short skips the part of the rep that is loaded most.",
                 "Stopping with the wrists only half curled, the bar barely rising.",
                 "Curl the bar up and back as far as the wrists bend, hold a moment, then lower until the hands tip back toward the legs."),
       "stance": ("Stance",
                  "Stand tall and still, the knees soft.",
                  "Dipping at the knees and driving up throws the bar up with the legs, so the wrists do less of the work.",
                  "Dipping at the knees to bounce the bar up with the legs.",
                  "Stand with the feet hip-width apart, knees soft and torso upright, and keep the legs still for the whole set."),
   },
   activation=FLEXORS,
   stabilisers=["upper trapezius", "rear deltoids", "latissimus dorsi", "wrist extensors"],
   comparison=("ELBOWS BENDING", "Arms straight, wrists curl", "Elbows bend to pull the bar",
               "With the arms straight, the bar rises only as the wrists curl, so the forearm flexors do the lifting.",
               "Bending the elbows pulls the bar up partly with the arms, so the wrists do less of the work."),
   glows=[glow("Behind-the-Back Wrist Curl", ["forearm_L", "hand_L"], A, 0.55, 0.035, 0.05),
          glow("Behind-the-Back Wrist Curl", ["forearm_R", "hand_R"], SOFT, 0.30, 0.035, 0.05)])

SETUP["Behind-the-Back Wrist Curl"] = [
    "Set a barbell in a rack just below hip height.",
    "Stand with your back to it and grip it at shoulder-width, palms facing back.",
    "Lift it off and step forward, the bar behind your thighs.",
    "Stand tall, arms straight, shoulders down.",
]

# ---------------------------------------------------------------- finger curl

ex(name="Finger Curl", var="fingerCurl",
   overrides={"top": (0.14, "leading"), "torso": (0.14, "trailing"), "forearm": (0.68, "trailing"),
              "roll": (0.86, "leading"), "position": (0.86, "trailing")},
   # The near plate covers spine and forearm_L in this framing, so the torso
   # and forearm cues track the near shoulder blade and the far forearm.
   # Crossed hands (see SEATED_LEFT): the far hand's open fingers show at
   # the bottom, the near fist at the top. The knee dot is on shin_L, just
   # below patella_L, which sits on the bar's edge at the bottom.
   annotations=[
       ("forearm", "Forearms on thighs", "forearm_R"),
       ("position", "Wrists just past the knees", "shin_L"),
       ("roll", "Roll bar to the fingertips", "hand_R"),
       ("top", "Close the fist as you curl", "hand_L"),
       ("torso", "Body still, no rocking", "scapula_L"),
   ],
   cues={
       "forearm": forearm_cue("bar", "finger and wrist flexors", "palms up", "the wrists and fingers are the only joints"),
       "position": ("Wrist Position",
                    "The wrists sit just beyond the knees so the hands hang free.",
                    "The bar needs room to roll down the fingers as the wrists bend back; with the wrists back on the thighs, the legs stop the hands and the bar before it reaches the fingertips.",
                    "Sitting with the forearms too far back, the wrists on the thighs, so the bar meets the legs before it reaches the fingertips.",
                    "Slide the forearms forward until the wrists just clear the knees, and keep them there for the whole set."),
       "roll": ("Finger Range",
                "Open the hands until the bar rests in the fingertips.",
                "Letting the bar roll out of the palms and down the fingers makes the finger flexors, the muscles that close the hand, work over a long range; kept in the palms, the bar turns the lift into a plain wrist curl.",
                "Keeping the bar in the palms, the fingers never opening and the wrists barely bending back.",
                "Lower slowly, open the fingers and let the bar roll down until it rests in the fingertips, the wrists bent back, without letting it roll off."),
       "top": ("Top of the Rep",
               "Roll the bar back into the palms as the wrists curl up.",
               "Closing the fingers rolls the bar back into the palms and works the finger flexors, and curling the wrists with them adds the wrist flexors, so each rep trains the grip and the wrist together.",
               "Stopping once the fingers close, the wrists never curling up.",
               "Close the fingers round the bar and curl the wrists up with them until the bar is back in the palms, then hold a moment."),
       "torso": torso_cue("bar"),
   },
   # At the bottom the bar hangs in the fingertips, where the profundus (the
   # only fingertip flexor) is most effective (Kaufmann 2007, cadaver).
   activation=[("Flexor Digitorum Profundus", P, HI, 0.84), ("Flexor Digitorum Superficialis", P, HI, 0.80),
               ("Wrist Flexors", S, MOD, 0.60)],
   stabilisers=["wrist extensors", "thumb flexors"],
   comparison=("BAR KEPT IN THE PALMS", "Bar rolls to the fingertips", "Fingers never open",
               "Letting the bar roll down to the fingertips and curling it back works the finger flexors through a long range.",
               "Keeping the bar in the palms leaves the fingers closed, so the lift becomes a short wrist curl."),
   glows=seated_glows("Finger Curl", rx=0.055, ry=0.03))

SETUP["Finger Curl"] = [
    SETUP_SEATED_START,
    "Take a light barbell underhand, hands shoulder-width or a little narrower.",
    "Rest your forearms along your thighs, wrists just past your knees.",
    "Start with the bar curled up in your palms.",
]

if __name__ == "__main__":
    probs = validate(["Dumbbell Wrist Curl", "Barbell Reverse Wrist Curl", "Dumbbell Reverse Wrist Curl", "Cable Wrist Curl", "Cable Reverse Wrist Curl", "Behind-the-Back Wrist Curl", "Finger Curl"]); print("\n".join(probs) or "OK")
