# Trainer content for exercises 1-50 redone (2026-09-29), family: forearm.
# 48 Reverse Curl (Biceps/ReverseCurl) and 49 Wrist Curl (Forearms/WristCurl),
# new to the app, from the HIKSEMI drive's "1-100 🟢" folder. Same format as
# spec.py; spec_1_50.py imports this module and gen.py reads SPEC / SETUP.
#
# What each model shows, from briefs_1_50/<Resource>.md, the trainer stills
# (shots/view/<slug>_t{0,1,2,3,5}.png), the highlight tiers and the rig
# (joints, finger joints and the equipment's own mesh read with Blender's
# Python; torso length, neck to pelvis, is 0.592 m). Both clips are 7.96 s,
# two identical ~4 s reps; the fingers stay closed round the handle or bar
# the whole time (middle finger ~61° at the knuckle, ~66° at the middle
# joint, thumb wrapped), and the shoulders, neck and head never move.
#
# - Reverse Curl (48): standing tall, trunk upright (0° lean) and still,
#   knees straight (179°), ankles 0.28 m apart (about hip-width). An EZ bar
#   (EX_48_EZ_Bar, 1.3 m, two plates a side) held overhand: palms facing
#   back with the bar against the front of the thighs at the bottom, down
#   and forward at the top. Wrists 0.48 m apart (shoulder joints 0.39 m),
#   about shoulder-width, on the bar's inner angled sections, which slant
#   ~33° from the bar's line with the little-finger end forward, so the
#   palms are turned ~30° past fully palm-down (thumbs back). The upper arms
#   never move: ~10° forward of the trunk and ~9° out, elbows by the sides.
#   Elbows from 167° (arms almost straight, bar at the thighs) to 65°
#   (forearms ~35° above level, the bar at lower-chest height ~33 cm in
#   front, wrists ~14 cm below the shoulders). Wrists straight (0°) the whole
#   way, knuckles in line with the forearms. A rep: ~1.3 s up, ~0.5 s near
#   the top (65-68°), ~2 s down, no pause at the bottom.
#   Tiers: bright (primary) brachioradialis, the wrist extensors (ECRL, ECRB,
#   ECU, extensor digitorum) and the forearm flexors (FCR, palmaris longus,
#   FDS, FDP); dim (secondary) biceps (both heads) and brachialis. Library
#   row: BRACHIORADIALIS, EZ BAR, beginner.
#   Framing yaw -0.4, zoom 0.823: nearly face-on from the front-left, the
#   left arm on the right of the frame (elbow at x 0.70, y 0.37), the right
#   arm on the left (0.40, 0.37); the wrists travel from y 0.46 at the bottom
#   to 0.30-0.31 at the top. The plates sweep both sides from y ~0.55 at the
#   bottom to ~0.26 at the top (x 0.05-0.24 left, 0.74-0.90 right), and at
#   the top the bar crosses the frame at y ~0.3; the head sits at x
#   0.50-0.61, y 0.13-0.25; the legs fill x ~0.40-0.70 below the hips. So the
#   labels go above the plates (0.16) and below them (0.59 and 0.80), with
#   short pills on the right, where the near leg reaches x ~0.70.
# - Wrist Curl (49): sitting on a stool (EX_49_Seat, top 0.49 m) in front of
#   a padded forearm support (EX_49_ForearmSupport, top 0.775 m, 0.70 m wide,
#   0.27 m deep, on a post), knees ~116° under the pad, hips ~87°, feet flat
#   0.44 m apart, trunk ~25° forward and still. A dumbbell in each hand, palms
#   up, full grip. Upper arms hang ~9° forward of vertical, elbows 95°, the
#   forearms lying level along the pad (rising ~4° to the wrist), elbow
#   joints 4 cm in from the pad's back edge, wrists 2 cm past its front edge,
#   so the hands hang free. Only the wrists move: the hand line (wrist to
#   middle knuckle) from ~35° below level (wrist ~39° extended) to ~30° above
#   level (~26° flexed); the brief's bone-axis measure reads -30° to +35°.
#   A rep: ~1.2 s up, ~0.5 s held at the top, ~2.1 s down, ~0.2 s at the
#   bottom. The dumbbells' pull on the wrists (their centre's horizontal
#   distance from the wrist joint): ~9 cm from the bottom until the hands
#   pass level, easing to ~6 cm at the top, so the lift is heaviest in its
#   lower half. Tiers: all nine forearm muscles bright (brachioradialis, the
#   wrist extensors and extensor digitorum, FCR, palmaris longus, FDS, FDP);
#   nothing dim. Library row: FOREARM FLEXORS, DUMBBELL, beginner.
#   Framing yaw -0.7, zoom 0.918: from the front-left, the lifter facing
#   left, the near (left) forearm at x 0.49-0.61, the far one at 0.22-0.36,
#   both at y ~0.42; the dumbbells span x 0.05-0.63, y 0.35-0.47 and the near
#   one lies over the chest; the head at x 0.38-0.51, y 0.15-0.26; the back's
#   edge at x ~0.68-0.73; the pad at y 0.44-0.49, the stool to x 0.81 at y
#   0.57-0.62, its post at x 0.58-0.64 below that, the floor bars at y
#   0.73-0.81. The far wrist dot sits on the far dumbbell's inner plate, the
#   near one beside the near dumbbell's outer plate (u 0.49 against the
#   plate's 0.50-0.56), with the fists showing between the plates. The
#   stool and the pad are fixed: seat, seat post, two floor bars, support
#   post and pad, with no pin, knob or collar, so the copy says to choose a
#   seat height rather than adjust one.
#
# Sources (checked; see notes_1_50_forearm.md for the figures used):
# - Coratella G, Tornatore G, Longo S, Toninelli N, Padovan R, Esposito F,
#   Cè E 2023, Sports 11(3):64 (doi 10.3390/sports11030064, PMC10054060,
#   full text read) — ten competitive bodybuilders, standing cable-bar curls
#   at 8-RM, 42.5 cm bar, arms by the trunk: in the lifting phase biceps
#   nRMS +19(7)% supinated vs pronated (+12% vs neutral); brachioradialis
#   +5(4)% supinated vs pronated, pronated and neutral alike; anterior
#   deltoid +6(3)% pronated and +9(2)% neutral vs supinated (lifting), +5%
#   pronated vs supinated (lowering), which the authors put down to
#   stabilising the humeral head. They describe the brachioradialis as
#   inserting on the radial styloid, flexing the elbow and holding the
#   forearm toward neutral; call the brachialis the most powerful elbow
#   flexor, taking no part in supination; and suggest (not measured) that the
#   pronated grip needs more wrist stabilisation toward extension from the
#   wrist extensors.
# - Coratella G, Tornatore G, Longo S, Esposito F, Cè E 2023, J Funct Morphol
#   Kinesiol 8(1):13 (doi 10.3390/jfmk8010013, PMID 36810497) — bilateral
#   palm-up straight/EZ barbell curls at 8-RM: flexing the arms (~30°, the
#   elbows travelling forward) raised anterior deltoid excitation, which the
#   authors call a prime mover there, and also biceps excitation (+17.7%
#   and +20.3% lifting); they treat it as a variation, so the elbow cue's
#   fault framing rests on ExRx and StrengthLog.
# - Boland MR, Spigelman T, Uhl TL 2008, J Hand Surg Am 33(10):1853-1859
#   (doi 10.1016/j.jhsa.2008.07.019, PMID 19084189) — ten adults, fine-wire
#   EMG, elbow flexion at loads of 0-67 N: no difference in brachioradialis
#   activation across the three forearm positions; the authors call it a
#   consistent elbow stabiliser in flexion tasks.
# - Kleiber T, Kunz L, Disselhorst-Klug C 2015, Front Physiol 6:215 (doi
#   10.3389/fphys.2015.00215, PMID 26300781) — 16 subjects, slow unloaded
#   elbow flexions: brachioradialis contribution significantly greater with
#   the hand pronated than neutral or supinated; biceps unchanged.
# - Kohn S, Smart RR, Jakobi JM 2018, Physiol Rep 6(1):e13560 (doi
#   10.14814/phy2.13560, PMID 29333724) — eleven men without high-level
#   upper-body training, isometric elbow-flexion MVC with the elbow at 110°
#   (180° straight): 213.6 N supinated, 243.6 N neutral, 113.6 N pronated; voluntary
#   activation 93.0% supinated, 70.9% pronated (so part of the gap is
#   unpractised drive; the copy says only much weaker).
# - Date S, Kurumadani H, Nakashima Y, Ishii Y, Ueda A, Kurauchi K, Sunagawa T
#   2021, Front Physiol 12:809422 (doi 10.3389/fphys.2021.809422, full text
#   via PMC8733609) — six men, unloaded elbow flexion in three forearm
#   positions: the brachialis's EMG pattern was similar in supination,
#   neutral and pronation, the biceps heads' was not (used for the
#   brachialis row).
# - Pinto RS, Gomes N, Radaelli R, Botton CE, Brown LE, Bottaro M 2012, J
#   Strength Cond Res 26(8):2140-2145 (doi 10.1519/JSC.0b013e31823a3b15,
#   PMID 22027847) — 10 weeks of preacher curls in untrained young men (15
#   a group), full range 0-130° vs mid-range partials 50-100°: 1RM +25.7%
#   full vs +16.0% partial; muscle thickness up in both (9.65% vs 7.83%).
# - Mogk JP, Keir PJ 2003, Ergonomics 46(9):956-975 (doi
#   10.1080/0014013031000107595, PMID 12775491) — extensor activity always
#   greater with the forearm pronated; a flexed wrist cut maximum grip force
#   by 40-50%.
# - Snijders CJ, Volkers AC, Mechelse K, Vleeming A 1987, Med Sci Sports
#   Exerc 19(5):518-523 (PMID 3683157) — grasping always makes a flexing
#   moment at the wrist, balanced by extensor activity (force and EMG).
# - Ikeda K, Kaneoka K, Matsunaga N, Ikumi A, Yamazaki M, Yoshii Y 2025, J
#   Orthop Surg Res 20(1):53 (doi 10.1186/s13018-024-05363-x, PMC11740565) —
#   20 men, 40 limbs, wrist flexion held at 75% of the maximum torque
#   (measured in neutral): FCR 93.1 %MVE supinated,
#   79.7 neutral, 57.8 pronated; extensor co-activation ECRB 14.0-16.1 %MVE,
#   ECU 16.1 supinated to 45.8 pronated. Set-up (a lab protocol, not a
#   training finding): seated, forearms resting on the support, chair height
#   adjusted so the shoulders were not elevated, elbow at 90°, much as this
#   model sits.
# - Neumann DA, Kinesiology of the Musculoskeletal System, 3rd ed. (2017),
#   ch. 7, as cited in notes_241_300_wrist.md: FCR, FCU and palmaris longus
#   the primary wrist flexors, the finger flexors secondary ones.
# - ACE Exercise Library, Wrist Curl - Flexion (#30), fetched: kneel, elbows
#   on a bench at about 90°, dumbbells hanging freely off the edge of the pad,
#   palms up; slowly lower into extension without releasing the grip,
#   extending the arms or leaning forward or backward; releasing the grip to
#   roll the weights to the fingertips raises the risk of wrist injury and of
#   dropping them; squeeze the weights hard in both phases.
# - ExRx.net Barbell Reverse Curl (archived copy, 2024): shoulder-width
#   overhand grip, elbows to the sides, raise until the forearms are
#   vertical, lower until the arms are fully extended; target brachioradialis,
#   synergists brachialis and biceps, stabilisers include the anterior
#   deltoid, upper and middle trapezius, levator scapulae and the wrist
#   extensors. ExRx Dumbbell Wrist Curl: target wrist flexors.
# - StrengthLog, How to Train Your Forearm Extensors (fetched): reverse curls
#   shift some work from the biceps onto the brachioradialis and recruit the
#   wrist extensors, especially ECRL/ECRB, to stabilise; use less weight than
#   a regular curl; the extensors stabilise the wrist for a strong grip;
#   the reverse curl is listed among its forearm-extensor exercises.
#   StrengthLog, Reverse Barbell Curl (fetched): overhand, about
#   shoulder-width; keep the upper arm at the side; lists the biceps as
#   primary and the forearm flexors as secondary (a disagreement with the
#   model's tiers, noted in the notes).
# Evidence is thin: no EMG study of a standing EZ-bar reverse curl or of a
# padded dumbbell wrist curl measured the forearm muscles, so the fractions
# are estimates (see the notes); the Reverse Curl's elbow-flexor rows are
# scaled from the loaded palm-down vs palm-up EMG and the app's Barbell and
# Reverse Preacher Curls. Where each lift is heaviest comes from the
# models' geometry.
from common_1_50 import *

# ---------------------------------------------------------------- reverse curl

ex(name="Reverse Curl", var="reverseCurl",
   # Nearly face-on (yaw -0.4). Two labels above the plates' sweep, two just
   # below its lowest point (the plates reach y ~0.55 at the bottom) and one
   # at the foot of the frame. The range and shoulder cues take the far
   # wrist and the near shoulder so neither top leader crosses the head; the
   # elbow and grip cues sit below the plates, each a short leader straight
   # up to the elbow or wrist on its own side; the torso cue the far hip,
   # its leader crossing the (still) right shin and knee into the thigh.
   # Checked against the ghosts in the mistake view (turned to -0.9 and
   # lifted): the elbow ghost's hands and bar sweep up through the top-left
   # row, so the elbow pill sits low; the shoulder pill is short so it starts
   # right of the near shoulder, which rises to x ~0.63 in its own mistake.
   # No ghost touches its own pill.
   overrides={"range": (0.14, "leading"), "shoulder": (0.14, "trailing"), "elbow": (0.62, "leading"),
              "grip": (0.62, "trailing"), "torso": (0.86, "leading")},
   annotations=[
       ("grip", "Wrists straight", "hand_L"),
       ("elbow", "Elbows by your sides", "forearm_R"),
       ("range", "Lower all the way", "hand_R"),
       ("torso", "No hip swing", "thigh_R"),
       ("shoulder", "Shoulders back", "upper_arm_L"),
   ],
   cues={
       "grip": ("Grip and Wrists",
                "An overhand grip, the wrists straight from bottom to top.",
                "With the palms down, the bar tends to pull the knuckles toward the floor once the forearms tip forward, so the muscles on the back of the forearm work through the curl to hold the wrists straight. A wrist bent down under the bar also weakens the grip.",
                "The wrists bending down under the bar as it rises, the knuckles dropping toward the floor.",
                "Hold the bar overhand with the hands about shoulder-width apart, and keep the knuckles in line with the forearms from bottom to top."),
       "elbow": ("Elbow Position",
                 "The elbows stay by the sides; only the forearms move.",
                 "With the upper arms still, bending the elbows is the only way to raise the bar, so the brachioradialis and the other elbow flexors do the lifting. When the elbows drift forward, the front deltoids join in to lift the bar.",
                 "The elbows swinging forward as the bar rises, the upper arms lifting away from the sides.",
                 "Keep the upper arms by your sides and still, and let only the forearms move."),
       "range": ("Range of Motion",
                 "Lower until the arms are almost straight.",
                 "Each rep starts with the bar at the thighs and the arms almost straight, so the elbow flexors work over nearly their whole range. Full-range curl training has built more strength than mid-range partial reps.",
                 "Half reps that stop with the elbows still well bent at the bottom.",
                 "Lower over about two seconds until the arms are almost straight, then curl again without bouncing."),
       "torso": ("Body Swing",
                 "The body stays still; only the arms move.",
                 "An overhand grip is much weaker than an underhand one for bending the elbows, so a bar that is too heavy tends to get swung up with the hips and back, and momentum does part of the work the arms should do.",
                 "Rocking the hips forward and the torso back to heave the bar up.",
                 "Pick a bar you can curl with the body still, stand tall, brace and keep the hips and torso still for every rep."),
       "shoulder": ("Shoulder Position",
                    "The shoulders stay down and back.",
                    "With the palms down, the front deltoids already work a little harder than in a palm-up curl, most likely to steady the shoulders. Rolling the shoulders forward and up at the top adds a shrug, so the shoulders rather than the elbow flexors raise the last part of the lift.",
                    "The shoulders rolling forward and up toward the ears as the bar reaches the top.",
                    "Stand tall with the chest up and the shoulders down and back, and finish each curl without moving them."),
   },
   # Ranks follow the model's tiers (brachioradialis, the wrist extensors
   # and the forearm flexors bright; biceps and brachialis dim) and ExRx's
   # target and synergists. Fractions follow the loaded EMG, not the ranks:
   # a palm-down grip does not raise brachioradialis activation (Coratella
   # 2023 Sports, Boland 2008), so it is set as on the Reverse Preacher
   # Curl; the biceps is the Barbell Curl's 0.90 less Coratella's 19%, kept
   # under HIGH; the brachialis as on the Barbell Curl; the wrist extensors
   # are judgement. So the secondary rows sit above the primary ones, a
   # tier conflict flagged in the notes for the user.
   activation=[("Brachioradialis", P, MOD, 0.56), ("Wrist Extensors", P, MOD, 0.50), ("Forearm Flexors", P, MOD, 0.45),
               ("Brachialis", S, MOD, 0.66), ("Biceps Brachii", S, MOD, 0.68)],
   stabilisers=["anterior deltoid", "upper trapezius", "levator scapulae"],
   comparison=("WRISTS BENDING DOWN", "Knuckles in line with forearms", "Wrists bend down under the bar",
               "With the wrists held straight, the muscles on the back of the forearm keep the bar in line while the brachioradialis and the other elbow flexors curl it.",
               "When the wrists bend down under the bar, the grip weakens and the bar sags away from the line of the forearms."),
   glows=[glow("Reverse Curl", ["forearm_L", "hand_L"], A, 0.55, 0.05, 0.07),
          glow("Reverse Curl", ["forearm_R", "hand_R"], A, 0.55, 0.05, 0.07)])

SETUP["Reverse Curl"] = [
    "Take an EZ bar overhand, hands about shoulder-width apart.",
    "Stand tall, feet about hip-width apart, the bar at your thighs.",
    "Arms almost straight, elbows by your sides, wrists straight.",
]

# ---------------------------------------------------------------- wrist curl

ex(name="Wrist Curl", var="wristCurl",
   # From the front-left (yaw -0.7), the dumbbells across the middle of the
   # frame. Labels sit in the open space: top-left (a short pill, ending
   # left of the head, whose edge reaches x ~0.38 at the pill's foot),
   # top-right, right of the back, and right under the stool. The two hand
   # cues split the wrists: the far one from the top-left (its leader passes
   # left of the head), the near one from the top-right (its leader passes
   # right of the head, down the near shoulder).
   overrides={"position": (0.14, "leading"), "range": (0.14, "trailing"), "torso": (0.32, "trailing"),
              "forearm": (0.44, "trailing"), "seat": (0.74, "trailing")},
   annotations=[
       ("forearm", "Forearms on pad", "forearm_L"),
       ("position", "Wrists off the pad", "hand_R"),
       ("range", "Let wrists bend back", "hand_L"),
       ("torso", "No rocking", "scapula_L"),
       ("seat", "Sit high enough", "thigh_L"),
   ],
   cues={
       "forearm": ("Forearm Support",
                   "The forearms lie flat along the pad and stay there.",
                   "With the forearms held on the pad, the wrists are the only joints free to move, so the forearm flexors lift the dumbbells on their own. When the forearms lift, the elbows bend and the arms help, and the wrists do less.",
                   "The forearms lifting off the pad as the dumbbells come up, the elbows bending to help.",
                   "Lay the forearms flat along the pad, elbows near its back edge, and move only the hands."),
       "position": ("Wrist Position",
                    "The wrists sit just past the front edge of the pad so the hands hang free.",
                    "With the hands clear of the pad they can tip well below it at the bottom and curl all the way up. With the wrists back on the pad, the backs of the hands come down on its edge at the bottom, and it stops them tipping any lower.",
                    "Sitting with the forearms too far back, the wrists on the pad, so the backs of the hands come down on its edge at the bottom.",
                    "Slide the forearms forward until the wrists just clear the edge of the pad, and keep them there for the whole set."),
       "range": ("Range of Motion",
                 "Lower until the hands tip well below the forearms, then curl up until the palms turn toward you.",
                 "In this set-up the dumbbells pull hardest over the lower half of the rep, from the bottom until the hands pass level, and ease off near the top, so reps that stop with the hands about level leave out much of that hardest stretch.",
                 "Short reps that stop with the hands about level, the wrists barely bent back.",
                 "Lower slowly, over about two seconds, until the hands tip well below the forearms, the fingers still wrapped round the handles, then curl up and hold a moment."),
       "torso": ("Body Position",
                 "Lean in over the pad and keep the body still.",
                 "Rocking the shoulders back swings the dumbbells up with the body instead of the wrists, and it pulls the forearms off the pad.",
                 "Rocking the shoulders back as the dumbbells come up, the forearms lifting off the pad with them.",
                 "Sit with the feet flat, lean in over the pad and move only the hands."),
       "seat": ("Seat Height",
                "Sit at a height where the forearms lie level on the pad.",
                "At the right height the upper arms hang almost straight down, the elbows bend to about 90° and the forearms rest level on the pad with the shoulders relaxed. With the seat too low, the pad sits high and the shoulders tend to hunch up to get the forearms onto it.",
                "Sitting too low, the shoulders riding up toward the ears to reach the pad.",
                "Choose a seat height where the elbows bend about 90° with the forearms flat on the pad and the shoulders down, then plant both feet."),
   },
   # All nine forearm muscles are painted bright on this model. The wrist
   # and finger flexors are the rows; the wrist extensors are a stabiliser
   # (low co-activation in palms-up wrist flexion, Ikeda 2025) and the
   # brachioradialis, which does not cross the wrist, is left out. Flagged
   # in the notes as a decision for the user (re-tier the model, or follow
   # the tiers with a LOW primary Wrist Extensors row).
   activation=[("Wrist Flexors", P, HI, 0.86), ("Finger Flexors", P, MOD, 0.55)],
   stabilisers=["wrist extensors", "thumb flexors"],
   comparison=("FOREARMS OFF THE PAD", "Forearms stay on the pad", "Forearms lift as the weights rise",
               "With the forearms resting on the pad, only the wrists move and the forearm flexors lift the dumbbells through the whole arc.",
               "When the forearms lift, the elbows bend and the arms raise part of the load, so the wrists do less of the work."),
   glows=[glow("Wrist Curl", ["forearm_L", "hand_L"], A, 0.55, 0.065, 0.03),
          glow("Wrist Curl", ["forearm_R", "hand_R"], SOFT, 0.30, 0.065, 0.03)])

SETUP["Wrist Curl"] = [
    "Choose a seat that lets your forearms lie level on the pad, elbows at about 90°.",
    "Sit with your feet flat and knees under the pad, and lean in over it.",
    "Hold a dumbbell in each hand, palms up.",
    "Rest your forearms along the pad, wrists just past its front edge.",
]

if __name__ == "__main__":
    probs = validate(["Reverse Curl", "Wrist Curl"]); print("\n".join(probs) or "OK")
