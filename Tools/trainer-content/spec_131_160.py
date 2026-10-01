# Trainer content for batch 133-160 (2026-09-25), exported to the HIKSEMI
# drive's "131-160" folder (131 came with the chest batch; 132 and 136 were
# not exported) and converted from SourceExports/131-160. Same format as
# spec.py; generate with `spec` swapped for this module (see README).
#
# What each model shows, from the rig (joint angles sampled across the clip):
# - Push-ups: Diamond — hands together under the chest; Wide-Grip — hands
#   ~0.9 m apart; Archer — wide hands, the body shifting over one hand while
#   the other arm straightens, side to side; Medicine Ball — both hands on
#   one ball.
# - Pause Bench Press: the bar held still on the chest for about a second
#   before each press. Larsen Press: legs straight out, feet off the floor.
#   Reverse-Grip Bench Press: underhand, just over shoulder-width.
# - Rack Pull (pins) and Block Pull (blocks): the bar starts just below the
#   knee. Sumo: feet ~0.7 m apart, hands inside the knees. Trap Bar: hands on
#   the side handles. Snatch-Grip: hands ~1 m apart. Deficit: standing on a
#   ~10 cm platform.
# - Rows: Yates — underhand, torso ~35° off upright; Reverse-Grip — underhand,
#   ~55°; Wide-Grip — torso nearly level, elbows flared to the chest; Seal —
#   lying face down on a high bench; Meadows, Single-Arm Landmine and
#   Kettlebell — the LEFT arm rows while the right braces on the knee or
#   thigh; Landmine — both hands on a close handle; Dumbbell Bent-Over — two
#   dumbbells, knees soft; Renegade — plank on two dumbbells, rowing one side
#   at a time; Gorilla — wide stance, deep hinge, kettlebells on the floor,
#   alternating; Inverted (flat, feet-elevated, underhand) — hanging under a
#   bar at hip height, body straight.
#
# Every framing has a negative yaw except the Meadows row (its lifter faces
# sideways in the export; 2.71 gives the same rear three-quarter view as the
# other rows). Back lifts are seen from behind-left, so the lifter's LEFT
# side is on the left of the frame.
#
# Sources:
# - Cogley RM et al. 2005, J Strength Cond Res 19(3):628-633 — a narrow
#   (diamond) hand base raises pectoralis and triceps activity over a wide one.
# - Ebben WP et al. 2011, J Strength Cond Res 25(10):2891-2894 — load of
#   push-up variations as a share of body mass.
# - Lehman GJ 2005, J Strength Cond Res 19(3):587-591 — a supinated grip
#   raises clavicular pectoralis activity in the bench press.
# - Escamilla RF et al. 2002, Med Sci Sports Exerc 34(4):682-688 — sumo vs
#   conventional deadlift: sumo is more upright with more knee and quadriceps
#   work and less lumbar load.
# - Swinton PA et al. 2011, J Strength Cond Res 25(7):2000-2009; Camara KD et
#   al. 2016, J Strength Cond Res 30(5):1183-1188 — the hexagonal (trap) bar
#   shifts load from the hips and lower back toward the knees; more vastus
#   lateralis, less hamstring than a straight bar.
# - Fenwick CMJ, Brown SHM, McGill SM 2009, J Strength Cond Res 23(5):1408-1417 (PMID 19620925)
#   — bent-over, inverted and one-arm rows: lumbar load is highest in the
#   bent-over row, lowest in the inverted row; latissimus and mid-back
#   activity are similar across rows.
# - Lehman GJ et al. 2004, Dyn Med 3:4 — grip width and forearm position
#   change latissimus, trapezius and biceps activity in the row.
# - Youdas JW et al. 2010, J Strength Cond Res 24(12):3404-3414 and Snarr RL
#   2014 — inverted row activity of the latissimus, trapezius and biceps.
# - ExRx.net, ACE and NASM technique guidance (neutral spine, bar path close
#   to the body, elbows 30-60° in rows, full stretch at the bottom).

import json, os

P, S = "primary", "secondary"
HI, MOD, LOW = "HIGH ACTIVATION", "MODERATE ACTIVATION", "LOW ACTIVATION"
A, SOFT = "activation", "activationSoft"
FLAT = [0.15, 0.28, 0.63, 0.75, 0.87]

J = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "joints.json")))

def mean(name, joints):
    pts = [p for j in joints for p in J[name][j]]
    return sum(u for u, _ in pts) / len(pts), sum(v for _, v in pts) / len(pts)

def glows(name, kind):
    """Activation signature from the probed joints: the pecs for pushes, the
    lats for rows, the hips and lower back for pulls from the floor."""
    if kind == "push":
        main = ["support_PectoralisMajor_Sternal_L", "support_PectoralisMajor_Sternal_R"]
        a, b = ["upper_arm_L"], ["upper_arm_L", "forearm_L"]
    elif kind == "row":
        main = ["support_LatissimusDorsi_L", "support_LatissimusDorsi_R"]
        a, b = ["scapula_L", "scapula_R"], ["upper_arm_L", "forearm_L"]
    else:
        main = ["pelvis"]
        a, b = ["spine"], ["patella_L", "patella_R"]
    cx, cy = mean(name, main); dx, dy = mean(name, a); tx, ty = mean(name, b)
    return [(A, 0.58, 0.14, 0.09, cx, cy), (SOFT, 0.32, 0.09, 0.07, dx, dy), (SOFT, 0.28, 0.07, 0.06, tx, ty)]

SPEC = []

def ex(**kw):
    kw["glows"] = glows(kw["name"], kw.pop("kind"))
    SPEC.append(kw)

# ---------------------------------------------------------------- shared cues

BODY = ("Body Line",
        "Head to heels stays one straight plank.",
        "A braced trunk lets the chest and arms do the pushing and keeps the lower back out of it.",
        "Hips sagging toward the floor or piking up as the reps get hard.",
        "Squeeze the glutes and brace the core so the head, hips and heels stay in one line from the bottom to the top.")
FEET_PU = ("Base",
           "The feet are the other end of the plank.",
           "Feet together on the toes fix the body line; spreading them makes the push-up easier and looser.",
           "Feet sliding back or drifting wide as the set goes on.",
           "Tuck the toes, keep the feet together and hold them still for the whole set.")
SCAP_BENCH = ("Scapular Position",
              "The shoulder blades are the platform the press pushes from.",
              "Pulling the scapulae back and down shortens the distance the shoulder has to travel and keeps the humeral head centred under load.",
              "Letting the shoulders roll forward off the bench as the bar comes up.",
              "Pull the shoulder blades back and down into the bench before the first rep and keep them there.")
FEET_BENCH = ("Leg Drive",
              "The feet are the lifter's contact with the floor.",
              "Planted feet keep the hips on the bench and the upper back tight, so the press has a solid base.",
              "Feet drifting, up on the toes or the hips lifting off the bench to finish a rep.",
              "Plant both feet flat and a little wider than the hips, and keep the glutes on the bench for every rep.")
WRIST_BAR = ("Wrist Stacking",
             "The bar sits over the forearm, not behind it.",
             "A stacked wrist transmits force straight down the forearm into the bar with no leak at the joint.",
             "The bar rolling back into the fingers, which bends the wrist back under load.",
             "Hold the bar low in the palm against the heel of the hand, wrist neutral.")
SPINE_DL = ("Spine Position",
            "The back stays flat from the first pull to lockout.",
            "A neutral spine lets the hips and legs move the bar while the back holds it; a rounding back takes the load onto the spinal discs and ligaments.",
            "The lower or upper back rounding as the bar leaves the floor or the pins.",
            "Brace hard before each rep, pull the slack out of the bar, and keep the chest up and the back flat as you stand.")
BARPATH_DL = ("Bar Path",
              "The bar travels in a straight line, close to the body.",
              "A bar kept against the legs stays over the mid-foot, the balance point, so the back does not have to fight it out in front.",
              "The bar drifting forward, away from the legs, as it rises.",
              "Keep the bar in contact with the legs the whole way up and down, as if dragging it up the thighs.")
LOCKOUT = ("Lockout",
           "The rep finishes standing tall, not leaning back.",
           "Hips and knees fully straight is the end of the lift; leaning back past it compresses the lower back without working anything more.",
           "Leaning back and shrugging at the top to show the rep is finished.",
           "Drive the hips through until you stand straight, squeeze the glutes, then lower the bar the same way it came up.")
SCAP_ROW = ("Scapular Position",
            "Each rep starts with a reach and ends with a squeeze.",
            "Letting the shoulder blades travel forward at the bottom and pulling them together at the top works the mid-back through its full range.",
            "Shoulders staying rounded forward, so only the arms move the weight.",
            "Let the shoulders reach toward the weight at the bottom, then pull the shoulder blades back and together as you row.")
ELBOW_ROW = ("Elbow Path",
             "The elbows lead the row; the hands just hold on.",
             "Driving the elbows back at about 30-45° from the torso lines the pull up with the lats and mid-back instead of the biceps.",
             "Winging the elbows straight out to the sides, which shifts the pull to the rear delts and upper traps.",
             "Pull the elbows back past the torso at about 30-45° out, thinking of the hands as hooks.")
ROW_HINGE = ("Torso Position",
             "The torso holds its angle for the whole set.",
             "A fixed, braced hinge keeps the load on the back muscles; standing up with each rep turns it into a shrug with momentum.",
             "The torso rising toward upright to heave the weight up.",
             "Hinge from the hips with soft knees and a flat back, brace, and keep that angle from the first rep to the last.")

def pushup(name, var, hands, elbow, depth, comp, activation, stabilisers):
    ex(name=name, var=var, group="chest", kind="push", slots=FLAT,
       annotations=[
           ("body", "Body in one straight line", "pelvis"),
           ("hands", hands[0], "hand_L"),
           ("elbow", elbow[0], "forearm_L"),
           ("depth", depth[0], "support_PectoralisMajor_Sternal_L"),
           ("feet", "Feet together, toes tucked", "foot_L"),
       ],
       cues={"body": BODY, "hands": hands[1], "elbow": elbow[1], "depth": depth[1], "feet": FEET_PU},
       activation=activation, stabilisers=stabilisers, comparison=comp)

# ---------------------------------------------------------------- push-ups

pushup("Diamond Push-Up", "diamondPushUp",
       ("Hands together under chest", ("Hand Position",
                                       "The hands meet under the chest, thumbs and index fingers touching.",
                                       "A narrow base makes the elbows bend further and keeps the arms close, which raises triceps and inner-chest work.",
                                       "Placing the diamond under the face instead of the chest, which loads the shoulders and wrists.",
                                       "Make a diamond with the thumbs and index fingers and set it directly under the breastbone.")),
       ("Elbows brush the ribs", ("Elbow Path",
                                  "The elbows travel back along the sides.",
                                  "Tucked elbows keep the triceps working and the shoulders out of wide abduction on a narrow base.",
                                  "Flaring the elbows out to the sides as the chest drops.",
                                  "Lower with the elbows pointing back, brushing the ribs, forearms close to the body.")),
       ("Chest to the hands", ("Depth",
                               "Every rep reaches the hands.",
                               "The last part of the descent is where the narrow push-up works the triceps and chest hardest.",
                               "Stopping halfway, elbows barely bent.",
                               "Lower until the chest nearly touches the backs of the hands, then press back to straight arms.")),
       ("ELBOWS FLARED", "Elbows back along the ribs", "Elbows flared wide",
        "Elbows brushing the ribs keep a diamond push-up on the triceps and inner chest with the shoulders protected.",
        "Flared elbows on a narrow base twist the shoulders and wrists and take the triceps out of the lift."),
       [("Triceps Brachii", P, HI, 0.86), ("Pectoralis Major", P, HI, 0.80), ("Anterior Deltoid", S, MOD, 0.50)],
       ["serratus anterior", "core", "glutes"])

pushup("Wide-Grip Push-Up", "wideGripPushUp",
       ("Hands wide of the shoulders", ("Hand Position",
                                        "The hands sit well outside the shoulders.",
                                        "A wider base shortens the range for the triceps and puts the chest on a longer stretch at the bottom.",
                                        "Hands so wide the chest can barely leave the floor, or placed forward by the head.",
                                        "Set the hands about one and a half shoulder-widths apart, level with the chest, fingers forward or slightly out.")),
       ("Elbows over the wrists", ("Elbow Path",
                                   "The forearms stay vertical at the bottom.",
                                   "Elbows stacked over the wrists keep the load on the chest; elbows drifting behind the hands pry the shoulder open.",
                                   "Elbows flaring up toward the ears as the chest drops.",
                                   "Lower with the elbows directly above the wrists, pointing out and slightly back.")),
       ("Chest to just above the floor", ("Depth",
                                          "The chest goes all the way down.",
                                          "The deep stretch is where the wide push-up loads the pecs most.",
                                          "Short reps that stop with the elbows barely bent.",
                                          "Lower until the chest is a fist's height from the floor, then press back up.")),
       ("HIPS SAGGING", "Straight line, head to heels", "Hips drop toward the floor",
        "A braced, straight body lets the chest lift it and keeps the lower back out of the rep.",
        "Sagging hips load the lower back and shorten the chest's share of every rep."),
       [("Pectoralis Major", P, HI, 0.84), ("Anterior Deltoid", S, MOD, 0.50), ("Triceps Brachii", S, MOD, 0.44)],
       ["serratus anterior", "core", "glutes"])

pushup("Archer Push-Up", "archerPushUp",
       ("Hands wide, fingers out", ("Hand Position",
                                    "A wide base, so the body can travel over one hand.",
                                    "Wide hands turned slightly out let one arm do most of the pressing while the other straightens as a guide.",
                                    "Hands too close to shift over, so it becomes an ordinary push-up.",
                                    "Place the hands about twice shoulder-width, fingers turned slightly out.")),
       ("Working elbow ~45°", ("Elbow Path",
                               "One arm bends; the other stays long.",
                               "The bending arm takes most of the body's weight, which is what makes the archer a step toward one-arm push-ups.",
                               "Bending both elbows evenly, or flaring the working elbow straight out.",
                               "Shift toward one hand, bending that elbow about 45° from the body while the other arm straightens out to the side.")),
       ("Chest over the working hand", ("Depth",
                                        "The chest lowers over the bending arm.",
                                        "Lowering over one hand loads that side's chest and triceps through a full range.",
                                        "Shifting sideways without going down, or dropping the hips instead of the chest.",
                                        "Lower the chest toward the working hand until it is a fist's height from the floor, press back to the middle, then switch.")),
       ("HIPS SAGGING", "Straight line, head to heels", "Hips drop toward the floor",
        "A braced, straight body lets the working arm move the whole body as one piece.",
        "Sagging or twisting hips spill the load into the lower back and take it off the working side."),
       [("Pectoralis Major", P, HI, 0.86), ("Triceps Brachii", S, HI, 0.66), ("Anterior Deltoid", S, MOD, 0.52)],
       ["serratus anterior", "obliques", "glutes"])

pushup("Medicine Ball Push-Up", "medicineBallPushUp",
       ("Both hands on the ball", ("Hand Position",
                                   "Both hands press on top of one ball.",
                                   "The ball narrows the base and makes it unstable, so the triceps, chest and shoulder stabilisers all work harder.",
                                   "Placing the ball forward under the face, or gripping its sides instead of pressing down on top.",
                                   "Set the ball under the chest and press both palms flat on top of it, fingers spread.")),
       ("Elbows close to the ribs", ("Elbow Path",
                                     "The elbows track back along the body.",
                                     "Tucked elbows keep a narrow push-up on the triceps and inner chest without straining the shoulders.",
                                     "Flaring the elbows out to balance on the ball.",
                                     "Lower with the elbows pointing back and close to the ribs.")),
       ("Chest to the ball", ("Depth",
                              "The chest comes down to the ball.",
                              "A full descent works the chest and triceps through their whole range even with the raised hands.",
                              "Short, shaky reps that never reach the ball.",
                              "Lower under control until the chest touches the top of the ball, then press to straight arms.")),
       ("ELBOWS FLARED", "Elbows tucked, chest to the ball", "Elbows flared for balance",
        "Tucked elbows and a steady descent keep the triceps and chest doing the work on an unstable base.",
        "Flared elbows on a narrow, rolling base load the shoulders and make the ball harder to control."),
       [("Pectoralis Major", P, HI, 0.82), ("Triceps Brachii", P, HI, 0.80), ("Anterior Deltoid", S, MOD, 0.48)],
       ["rotator cuff", "serratus anterior", "core"])

# ---------------------------------------------------------------- bench variants

ex(name="Pause Bench Press", var="pauseBenchPress", group="chest", kind="push",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45°", "forearm_R"),
       ("pause", "Still pause on the chest", "support_PectoralisMajor_Abdominal_L"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": WRIST_BAR,
       "elbow": ("Elbow Position",
                 "The pause makes a flared elbow easy to feel.",
                 "Around 45° keeps the pecs in their strongest line and the shoulder supported while the bar sits on the chest.",
                 "Letting the elbows drift out to 90° during the pause.",
                 "Tuck the upper arms to about 45° on the way down and hold them there through the pause."),
       "pause": ("The Pause",
                 "The bar stops dead on the chest before every press.",
                 "A full stop removes the stretch reflex and bounce, so the press has to start from the chest itself, building strength off the bottom.",
                 "Touch-and-go reps, or letting the bar sink into the chest and go soft during the pause.",
                 "Lower under control to the lower chest, hold it still and tight for about a second, then press without heaving."),
       "feet": FEET_BENCH,
       "scapula": SCAP_BENCH,
   },
   activation=[("Pectoralis Major", P, HI, 0.92), ("Triceps Brachii", S, MOD, 0.60), ("Anterior Deltoid", S, MOD, 0.52)],
   stabilisers=["serratus anterior", "rotator cuff", "core"],
   comparison=("BOUNCING THE BAR", "Dead stop, then press", "Bounced off the chest",
               "A still pause makes the chest and triceps start the press from zero, where most lifters fail.",
               "Bouncing turns the bottom into momentum, skips the point the pause is there to train and jars the sternum."))

ex(name="Larsen Press", var="larsenPress", group="chest", kind="push",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45°", "forearm_R"),
       ("barpath", "Bar to lower chest", "support_PectoralisMajor_Abdominal_L"),
       ("legs", "Legs straight, no leg drive", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": WRIST_BAR,
       "elbow": ("Elbow Position",
                 "Without leg drive, a flared elbow shows up straight away.",
                 "Around 45° keeps the pecs in their strongest line and the shoulders supported.",
                 "Flaring the elbows to 90° as the bar comes down.",
                 "Tuck the upper arms to about 45° and keep the forearms vertical under the bar."),
       "barpath": ("Bar Path",
                   "The same touch point as the bench press.",
                   "Touching the lower chest and finishing over the shoulders keeps the forearms vertical and the elbows tucked.",
                   "Letting the bar wander toward the neck while balancing.",
                   "Lower to the bottom of the breastbone, then press up and slightly back to finish over the shoulders."),
       "legs": ("Leg Position",
                "The legs are straight out and take no part.",
                "With no leg drive and no arch to lean on, the chest, shoulders and triceps have to hold the body steady as well as press, which is the point of the variation.",
                "Dropping the feet to the floor or arching the lower back to find something to push against.",
                "Hold the legs straight out in line with the bench, feet off the floor, glutes and upper back flat on the pad."),
       "scapula": SCAP_BENCH,
   },
   activation=[("Pectoralis Major", P, HI, 0.90), ("Triceps Brachii", S, MOD, 0.58), ("Anterior Deltoid", S, MOD, 0.52)],
   stabilisers=["core", "rotator cuff", "serratus anterior"],
   comparison=("ARCHING FOR LEG DRIVE", "Legs straight, back flat", "Feet drop, back arches",
               "With the legs out of it, the upper body presses from a flat, stable position and does all the work.",
               "Reaching for the floor or arching brings back the leg drive the Larsen press is meant to take away."))

ex(name="Reverse-Grip Bench Press", var="reverseGripBenchPress", group="chest", kind="push",
   annotations=[
       ("wrist", "Palms toward you, wrists straight", "hand_L"),
       ("elbow", "Elbows tucked to the sides", "forearm_R"),
       ("barpath", "Bar to lower chest", "support_PectoralisMajor_Abdominal_L"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": ("Grip and Wrists",
                 "An underhand grip, palms facing you.",
                 "A supinated grip turns the upper arms out, which puts more of the press on the upper (clavicular) chest; the wrists must stay straight to hold it safely.",
                 "Letting the wrists bend back under the bar, or gripping so wide the wrists twist.",
                 "Grip underhand just over shoulder-width, thumbs wrapped around the bar, wrists straight over the forearms. Use a spotter to unrack."),
       "elbow": ("Elbow Position",
                 "The grip brings the elbows in close.",
                 "Elbows tucked near the sides let the supinated grip do its work and keep the shoulders comfortable.",
                 "Flaring the elbows out, which fights the grip and strains the wrists.",
                 "Keep the elbows close to the sides as the bar lowers."),
       "barpath": ("Bar Path",
                   "The bar touches a little lower than a normal bench.",
                   "With tucked elbows the forearms are vertical at the lower chest, so that is where the bar touches.",
                   "Lowering toward the upper chest, which flares the elbows and bends the wrists.",
                   "Lower to the bottom of the breastbone, then press up and slightly back over the shoulders."),
       "feet": FEET_BENCH,
       "scapula": SCAP_BENCH,
   },
   activation=[("Upper Pectoralis", P, HI, 0.84), ("Triceps Brachii", S, MOD, 0.60), ("Anterior Deltoid", S, MOD, 0.44), ("Biceps Brachii", S, LOW, 0.24)],
   stabilisers=["rotator cuff", "forearm flexors", "core"],
   comparison=("ELBOWS FLARED", "Elbows tucked, wrists straight", "Elbows flared, wrists bent",
               "Tucked elbows under an underhand grip keep the bar over the forearms and the upper chest in charge.",
               "Flaring fights the grip, bends the wrists back and makes the bar harder to control."))

# ---------------------------------------------------------------- pulls from pins, blocks and the floor

def partial(name, var, where, comp):
    ex(name=name, var=var, group="back", kind="pull",
       annotations=[
           ("spine", "Flat back, chest up", "spine"),
           ("hips", "Hips drive through", "pelvis"),
           ("grip", "Hands just outside legs", "hand_L"),
           ("barpath", "Bar stays on the thighs", "hand_R"),
           ("lockout", "Stand tall, no lean back", "head"),
       ],
       cues={
           "spine": ("Spine Position",
                     f"The bar starts on the {where}, just below the knees; the back is set before it moves.",
                     "A shorter pull lets you handle more than a full deadlift, so the back has to be braced flat before the bar leaves its support.",
                     f"Yanking the bar off the {where} with the upper back rounding.",
                     "Hinge to the bar with a flat back, pull the slack out until the bar just lifts against the supports, then stand."),
           "hips": ("Hip Drive",
                    "From below the knee, the lift is all hips.",
                    "The top half of the deadlift is hip extension: the glutes and hamstrings drive the hips forward to the bar.",
                    "Knees locking straight early, so the back finishes the pull with the hips left behind.",
                    "Push the hips forward into the bar as the shoulders rise, until the hips and knees lock out together."),
           "grip": ("Grip",
                    "Hands just outside the legs, arms straight.",
                    "A narrow grip keeps the arms vertical, the bar close and the distance short; the heavier loads also test the grip itself.",
                    "Gripping wide or bending the elbows to help pull.",
                    "Grip just outside the thighs, double overhand as long as you can hold it, arms long like hooks."),
           "barpath": BARPATH_DL,
           "lockout": LOCKOUT,
       },
       activation=[("Erector Spinae", P, HI, 0.84), ("Gluteus Maximus", P, HI, 0.82), ("Upper Trapezius", S, MOD, 0.60), ("Hamstrings", S, MOD, 0.52)],
       stabilisers=["latissimus dorsi", "forearms", "core"],
       comparison=comp)

partial("Rack Pull", "rackPull", "pins",
        ("LEANING BACK AT LOCKOUT", "Stand tall, hips through", "Leaning back past upright",
         "Finishing with the hips and knees straight and the body upright completes the pull with the glutes.",
         "Leaning back at the top compresses the lower back under a load heavier than most lifters can deadlift."))
partial("Block Pull", "blockPull", "blocks",
        ("LEANING BACK AT LOCKOUT", "Stand tall, hips through", "Leaning back past upright",
         "Finishing upright with the hips through completes the pull with the glutes.",
         "Leaning back at the top compresses the lower back under a heavy load and adds nothing to the lift."))

ex(name="Sumo Deadlift", var="sumoDeadlift", group="back", kind="pull",
   annotations=[
       ("feet", "Wide stance, toes out", "foot_R"),
       ("knees", "Knees out over the toes", "patella_L"),
       ("grip", "Hands inside the knees", "hand_L"),
       ("spine", "Chest up, back flat", "spine"),
       ("hips", "Hips and chest rise together", "pelvis"),
   ],
   cues={
       "feet": ("Stance",
                "A wide stance with the toes turned out.",
                "Wide feet let the torso stay upright and shorten the distance the bar travels, which moves work from the lower back to the hips and quads.",
                "Standing only slightly wider than a conventional deadlift, toes forward, so the knees have nowhere to go.",
                "Set the feet about twice shoulder-width, toes turned out 30-45°, shins close to the bar."),
       "knees": ("Knee Tracking",
                 "The knees push out over the toes.",
                 "Knees in line with the feet open the hips so the adductors and glutes can drive, and keep the knee joints lined up.",
                 "Knees caving inward as the bar leaves the floor.",
                 "Push the knees out over the toes from the setup to lockout."),
       "grip": ("Grip",
                "The hands sit inside the knees, arms straight down.",
                "A narrow grip keeps the arms vertical and the bar path short.",
                "Gripping wide, outside the knees, which lengthens the pull.",
                "Grip about shoulder-width, inside the knees, arms hanging straight from the shoulders."),
       "spine": SPINE_DL,
       "hips": ("Hip Drive",
                "The hips and chest rise at the same speed.",
                "Rising together keeps the torso upright, which is the sumo's advantage; hips shooting up first turns it into a stiff-legged pull.",
                "The hips rising before the bar moves, chest dropping toward the floor.",
                "Wedge the hips down to the bar, then push the floor apart with the feet so hips and shoulders rise together."),
   },
   activation=[("Gluteus Maximus", P, HI, 0.84), ("Quadriceps", P, HI, 0.72), ("Adductors", S, MOD, 0.60), ("Erector Spinae", S, MOD, 0.58)],
   stabilisers=["hamstrings", "trapezius", "forearms", "core"],
   comparison=("KNEES CAVING IN", "Knees out over the toes", "Knees collapse inward",
               "Knees pushed out keep the hips open, so the glutes and adductors drive the bar up with the torso upright.",
               "Caving knees stall the hips, twist the knee joints and let the chest fall forward."))

ex(name="Trap Bar Deadlift", var="trapBarDeadlift", group="back", kind="pull",
   annotations=[
       ("feet", "Stand centred in the bar", "foot_R"),
       ("knees", "Knees over the toes", "patella_L"),
       ("spine", "Chest up, back flat", "spine"),
       ("hips", "Push the floor away", "pelvis"),
       ("lockout", "Stand tall, no lean back", "head"),
   ],
   cues={
       "feet": ("Foot Position",
                "The feet sit in the middle of the frame.",
                "Standing centred puts the handles in line with the body's balance point, so the load sits over the mid-foot instead of in front of it.",
                "Rocking forward onto the toes as the bar leaves the floor.",
                "Stand in the centre of the bar, feet hip-width, handles beside the middle of the feet, weight through the whole foot."),
       "knees": ("Knee Tracking",
                 "The knees bend more than in a straight-bar deadlift.",
                 "The trap bar lets the knees travel forward, so the quads share the lift and the lower back is loaded less.",
                 "Knees caving inward as the pull starts.",
                 "Push the knees out in line with the toes as you stand."),
       "spine": SPINE_DL,
       "hips": ("Leg Drive",
                "It starts like a squat stand, not a hinge.",
                "Driving through the legs with hips and shoulders rising together uses the trap bar's upright position to share the load between the hips and knees.",
                "Hips shooting up first, knees locking, back doing the lifting.",
                "Grip the handles, sit the hips down until the arms are straight, then push the floor away so hips and chest rise together."),
       "lockout": LOCKOUT,
   },
   activation=[("Quadriceps", P, HI, 0.78), ("Gluteus Maximus", P, HI, 0.80), ("Erector Spinae", S, MOD, 0.56), ("Hamstrings", S, MOD, 0.44)],
   stabilisers=["trapezius", "forearms", "core"],
   comparison=("HIPS SHOOTING UP", "Hips and chest rise together", "Hips rise first",
               "Rising together lets the legs and hips share the lift in the trap bar's upright position.",
               "Hips shooting up leaves the back to lift the load with straight legs, wasting what the trap bar is for."))

ex(name="Snatch-Grip Deadlift", var="snatchGripDeadlift", group="back", kind="pull",
   annotations=[
       ("grip", "Wide snatch grip", "hand_L"),
       ("spine", "Upper back tight, flat", "spine"),
       ("hips", "Hips lower than a deadlift", "pelvis"),
       ("barpath", "Bar close to the shins", "hand_R"),
       ("feet", "Feet hip-width, bar over mid-foot", "foot_R"),
   ],
   cues={
       "grip": ("Grip",
                "Hands wide, near the collars.",
                "A wide grip lowers the hands, so the hips have to sit lower and the bar travels further, working the upper back and legs harder than a normal deadlift.",
                "Gripping only a little wider than a normal deadlift, which loses the extra range.",
                "Grip wide enough that the bar would sit in the hip crease when standing, about twice shoulder-width."),
       "spine": ("Upper Back",
                 "The wide grip pulls the shoulders forward; the upper back resists.",
                 "Keeping the shoulder blades set and the upper back flat is what builds the traps and rhomboids in this variation.",
                 "The upper back rounding as the wide grip drags the shoulders forward.",
                 "Pull the shoulders back and down, lats tight, and keep the chest up from the floor to lockout."),
       "hips": ("Hip Position",
                "The start is deeper than a deadlift.",
                "Lower hips keep the shins close to vertical and the torso steep enough to hold the wide grip without rounding.",
                "Starting with the hips high, as in a conventional deadlift, then rounding to reach the bar.",
                "Sit the hips down until the arms are straight and the chest is up, then push the floor away."),
       "barpath": BARPATH_DL,
       "feet": ("Foot Position",
                "The bar sits over the middle of the foot.",
                "Starting over the mid-foot keeps the bar over the balance point for the longer pull.",
                "Starting with the bar out over the toes.",
                "Stand with the feet hip-width, the bar over the mid-foot and about an inch from the shins."),
   },
   activation=[("Erector Spinae", P, HI, 0.84), ("Gluteus Maximus", P, HI, 0.80), ("Upper Trapezius", S, HI, 0.68), ("Quadriceps", S, MOD, 0.50)],
   stabilisers=["rhomboids", "latissimus dorsi", "forearms", "core"],
   comparison=("UPPER BACK ROUNDING", "Shoulders set, chest up", "Upper back rounds forward",
               "Holding the upper back flat against the wide grip is what makes the snatch-grip deadlift work the traps and rhomboids.",
               "Letting the shoulders round hands the load to the spine and loses the upper-back work."))

ex(name="Deficit Deadlift", var="deficitDeadlift", group="back", kind="pull",
   annotations=[
       ("feet", "Stand on the platform", "foot_R"),
       ("spine", "Flat back from the floor", "spine"),
       ("hips", "Hips and chest rise together", "pelvis"),
       ("grip", "Hands just outside legs", "hand_L"),
       ("barpath", "Bar close to the shins", "hand_R"),
   ],
   cues={
       "feet": ("Foot Position",
                "Standing on a low platform lengthens the pull.",
                "A 3-10 cm deficit makes the bar start lower, so the legs and back work through more range off the floor, the weak point it is used to fix.",
                "Using a platform so high the back cannot stay flat at the bottom.",
                "Stand on a stable 3-10 cm platform, feet hip-width, the bar over the mid-foot."),
       "spine": ("Spine Position",
                 "The deeper start makes a flat back harder to hold.",
                 "Keeping a neutral spine at the extra depth keeps the load on the legs and hips instead of the lower back.",
                 "Rounding the lower back to reach the bar at the bottom.",
                 "Sit the hips down, chest up, brace hard and pull the slack out before the bar leaves the floor."),
       "hips": ("Hip Drive",
                "The hips and chest leave the bottom together.",
                "Rising together keeps the bar over the mid-foot and the legs in the lift through the extra range.",
                "Hips shooting up first, turning the start into a stiff-legged pull.",
                "Push the floor away with the legs, letting the hips and shoulders rise at the same speed."),
       "grip": ("Grip",
                "Hands just outside the legs.",
                "A narrow grip keeps the arms vertical and the pull as short as the deficit allows.",
                "Gripping wide, which adds even more range and rounds the upper back.",
                "Grip just outside the shins, arms long and straight."),
       "barpath": BARPATH_DL,
   },
   activation=[("Gluteus Maximus", P, HI, 0.84), ("Erector Spinae", P, HI, 0.82), ("Quadriceps", S, MOD, 0.58), ("Hamstrings", S, MOD, 0.56)],
   stabilisers=["latissimus dorsi", "trapezius", "forearms", "core"],
   comparison=("ROUNDED LOWER BACK", "Flat back at the bottom", "Back rounds to reach the bar",
               "A flat back at the extra depth lets the legs and hips break the bar from the floor.",
               "Rounding to reach the lower start puts the extra range on the lower back instead of the legs."))

# ---------------------------------------------------------------- barbell and seal rows

def barbell_row(name, var, grip, path, hinge, comp, activation, elbow=None):
    ex(name=name, var=var, group="back", kind="row",
       annotations=[
           ("elbow", (elbow or ("Elbows back ~30–45°", ELBOW_ROW))[0], "forearm_L"),
           ("barpath", path[0], "hand_R"),
           ("grip", grip[0], "hand_L"),
           ("feet", hinge[0], "pelvis"),
           ("scapula", "Squeeze shoulder blades", "scapula_R"),
       ],
       cues={"elbow": (elbow or ("", ELBOW_ROW))[1], "barpath": path[1], "grip": grip[1], "feet": hinge[1], "scapula": SCAP_ROW},
       activation=activation, stabilisers=["erector spinae", "hamstrings", "forearms", "core"], comparison=comp)

barbell_row("Barbell Yates Row", "barbellYatesRow",
            ("Underhand, shoulder-width", ("Grip",
                                           "An underhand grip, hands about shoulder-width.",
                                           "Palms up keep the elbows close and the upper arms moving along the lats' line of pull, with the biceps helping more.",
                                           "Gripping wide underhand, which strains the wrists and biceps tendons.",
                                           "Take an underhand grip at shoulder-width, wrists straight, and let the bar hang at the knees.")),
            ("Row to the belly button", ("Bar Path",
                                         "The bar travels up the thighs to the lower stomach.",
                                         "With the more upright torso, pulling to the navel keeps the elbows driving back along the lats.",
                                         "Pulling the bar up to the chest, which flares the elbows and shrugs the shoulders.",
                                         "Row the bar along the thighs to just below the belly button, pause, then lower under control.")),
            ("Torso ~35° off upright", ("Torso Position",
                                        "More upright than a standard row, but still hinged.",
                                        "About 30-45° of lean lets you handle heavier loads while the lats still pull the bar back rather than up.",
                                        "Standing up with each rep to swing the bar.",
                                        "Hinge until the torso is about 35° from upright, soft knees, and hold that angle for the set.")),
            ("TORSO SWINGING UP", "Fixed lean, row to the navel", "Body swings the bar up",
             "Holding the lean keeps the lats and mid-back rowing the bar to the belly.",
             "Swinging upright turns the row into a shrug with momentum and loads the lower back."),
            [("Latissimus Dorsi", P, HI, 0.82), ("Middle Trapezius", S, MOD, 0.62), ("Biceps Brachii", S, MOD, 0.58)])

barbell_row("Reverse-Grip Barbell Row", "reverseGripBarbellRow",
            ("Underhand, shoulder-width", ("Grip",
                                           "Palms facing forward-up, hands at shoulder-width.",
                                           "An underhand grip tucks the elbows, which biases the lower lats and brings the biceps in more than an overhand row.",
                                           "Gripping wider than the shoulders underhand, which twists the wrists.",
                                           "Grip underhand at shoulder-width, wrists straight, thumbs around the bar.")),
            ("Row to the lower ribs", ("Bar Path",
                                       "The bar travels to the bottom of the rib cage.",
                                       "Rowing low keeps the elbows close and the pull on the lats.",
                                       "Pulling to the chest with the elbows flaring.",
                                       "Row the bar to the lower ribs, elbows brushing the sides, then lower to straight arms.")),
            ("Torso ~55° off upright", ("Torso Position",
                                        "A deep hinge, held still.",
                                        "A steady hinge keeps the back muscles doing the rowing.",
                                        "The torso rising toward upright as the bar comes up.",
                                        "Hinge until the torso is well past 45° toward level, soft knees, flat back, and hold it.")),
            ("TORSO SWINGING UP", "Fixed hinge, row to the ribs", "Body swings the bar up",
             "Holding the hinge keeps the lats pulling the bar in to the lower ribs.",
             "Rising with each rep swaps back work for momentum and loads the lower back."),
            [("Latissimus Dorsi", P, HI, 0.84), ("Biceps Brachii", S, MOD, 0.62), ("Middle Trapezius", S, MOD, 0.58)])

barbell_row("Wide-Grip Barbell Row", "wideGripBarbellRow",
            ("Overhand, wide grip", ("Grip",
                                     "An overhand grip about one and a half shoulder-widths.",
                                     "A wide grip flares the elbows, which moves the work to the upper back, rear delts and traps.",
                                     "Letting the grip creep in toward shoulder-width, turning it into a normal row.",
                                     "Grip overhand well outside the shoulders, wrists straight.")),
            ("Row to the lower chest", ("Bar Path",
                                        "The bar travels to the bottom of the chest.",
                                        "With the elbows out, pulling to the lower chest lines the row up with the upper back.",
                                        "Rowing to the belly with the elbows tucked in.",
                                        "Row the bar to the lower chest, elbows out and level with the bar, then lower to a full stretch.")),
            ("Torso nearly level", ("Torso Position",
                                    "The torso hinges almost parallel to the floor.",
                                    "A near-level torso makes the bar travel straight up into the upper back's line of pull.",
                                    "The torso rising toward upright to heave the bar.",
                                    "Hinge until the torso is close to level with the floor, knees soft, back flat, and hold it.")),
            ("ELBOWS TUCKED IN", "Elbows out, bar to the chest", "Elbows tuck, bar to the belly",
             "Flared elbows and a chest-high bar keep the wide-grip row on the upper back and rear delts.",
             "Tucking the elbows turns it back into a lat row and loses the upper-back emphasis."),
            [("Middle Trapezius", P, HI, 0.84), ("Latissimus Dorsi", S, MOD, 0.62), ("Posterior Deltoid", S, MOD, 0.60), ("Rhomboids", S, MOD, 0.56)],
            elbow=("Elbows out ~60°", ("Elbow Path",
                                       "The elbows flare out to the sides.",
                                       "Elbows about 60° from the torso put the rear delts, traps and rhomboids in charge of the row.",
                                       "Tucking the elbows in to the sides.",
                                       "Pull the elbows up and out, level with the bar at the top.")))

ex(name="Seal Row", var="sealRow", group="back", kind="row", slots=FLAT,
   annotations=[
       ("elbow", "Elbows back ~45°", "forearm_L"),
       ("barpath", "Full hang, then to the bench", "hand_L"),
       ("grip", "Overhand, shoulder-width", "hand_R"),
       ("pad", "Chest stays on the bench", "spine"),
       ("scapula", "No shrugging", "scapula_L"),
   ],
   cues={
       "elbow": ELBOW_ROW,
       "barpath": ("Range of Motion",
                   "The arms hang straight at the bottom and the bar touches the bench at the top.",
                   "The bench takes the lower back and legs out of the row entirely, so a full range is all back and arms.",
                   "Cutting the stretch short at the bottom.",
                   "Let the bar hang to straight arms, shoulders reaching down, then row until it touches the underside of the bench."),
       "grip": ("Grip",
                "Overhand, about shoulder-width.",
                "A shoulder-width grip lines the arms up with the lats and mid-back.",
                "Gripping wide, which flares the elbows and shortens the row.",
                "Grip the bar overhand at shoulder-width, wrists straight."),
       "pad": ("Chest Contact",
               "The chest stays on the bench.",
               "Staying flat on the bench is what makes the seal row strict: no hip drive, no lower back.",
               "Lifting the chest and head off the bench to heave the bar.",
               "Lie flat with the chest on the end of the bench, chin just past it, and keep the chest down for every rep."),
       "scapula": ("Scapular Position",
                   "The shoulder blades squeeze together, not up.",
                   "Retracting without shrugging keeps the rhomboids and mid-traps doing the work.",
                   "Shrugging the shoulders up toward the ears at the top.",
                   "At the top, pull the shoulder blades back and together, keeping them down away from the ears."),
   },
   activation=[("Latissimus Dorsi", P, HI, 0.82), ("Middle Trapezius", P, HI, 0.80), ("Rhomboids", S, MOD, 0.64), ("Biceps Brachii", S, MOD, 0.54)],
   stabilisers=["posterior deltoid", "rotator cuff", "forearms"],
   comparison=("CHEST OFF THE BENCH", "Chest down, strict row", "Chest lifts to heave",
               "With the chest on the bench, only the back and arms can move the bar.",
               "Lifting the chest brings the lower back and momentum back into a row designed to remove them."))

# ---------------------------------------------------------------- one-arm and landmine rows

BRACE_ONE = ("Anti-Rotation",
             "The free arm braces; the trunk stays square.",
             "Bracing the free hand and holding the shoulders level makes the lats row the weight instead of a twist of the trunk.",
             "Twisting the torso open to heave the weight up.",
             "Press the free hand or forearm into the knee, brace the core and keep both shoulders level as you row.")
SCAP_ONE = ("Scapular Position",
            "Reach at the bottom, squeeze at the top.",
            "Letting the shoulder blade move forward and back works the lat and mid-back through its whole range.",
            "The working shoulder staying rounded forward, so only the arm moves.",
            "Let the shoulder reach toward the weight at the bottom, then pull the shoulder blade back as you row.")

def one_arm(name, var, grip, elbow, brace_label, hinge, comp, activation, overrides=None):
    kw = dict(name=name, var=var, group="back", kind="row",
              annotations=[
                  ("grip", grip[0], "hand_L"),
                  ("elbow", elbow[0], "forearm_L"),
                  ("brace", brace_label, "hand_R"),
                  ("feet", hinge[0], "pelvis"),
                  ("scapula", "Reach, then squeeze", "scapula_L"),
              ],
              cues={"grip": grip[1], "elbow": elbow[1], "brace": BRACE_ONE, "feet": hinge[1], "scapula": SCAP_ONE},
              activation=activation, stabilisers=["obliques", "erector spinae", "forearms", "rotator cuff"], comparison=comp)
    if overrides: kw["overrides"] = overrides
    ex(**kw)

one_arm("Meadows Row", "meadowsRow",
        ("Overhand on the bar end", ("Grip",
                                     "Overhand on the thick end of the bar, just behind the plates.",
                                     "Gripping the sleeve overhand, side-on to the bar, lets the elbow travel up and back in an arc that loads the upper lat and rear delt.",
                                     "Gripping the bar's shaft far from the plates, which shortens the pull and swings the bar.",
                                     "Stand side-on to the end of the bar and grip the sleeve overhand, just behind the collar.")),
        ("Elbow up and back", ("Elbow Path",
                               "The elbow drives up and slightly out.",
                               "The Meadows row's angle pulls the elbow higher than a dumbbell row, working the upper lat and rear delt.",
                               "Winging the elbow straight out to the side and curling the bar.",
                               "Pull the elbow up and back toward the hip, forearm vertical under the bar.")),
        "Forearm braced on knee",
        ("Staggered, hips hinged", ("Stance and Hinge",
                                    "A staggered stance with the front knee bent and the hips back.",
                                    "The split stance lets the torso hinge low beside the bar and stay there.",
                                    "Standing too upright, or rising with each rep.",
                                    "Put the foot nearest the bar behind, the other forward, bend the front knee, hinge to about 30° from level and hold it.")),
        ("TORSO TWISTING", "Square torso, elbow drives", "Torso twists open",
         "With the torso square, the lat and upper back row the bar through a long arc.",
         "Twisting open to heave the bar shortens the pull and puts the lower back under a rotating load."),
        [("Latissimus Dorsi", P, HI, 0.84), ("Posterior Deltoid", S, MOD, 0.60), ("Middle Trapezius", S, MOD, 0.58), ("Biceps Brachii", S, MOD, 0.48)])

one_arm("Single-Arm Landmine Row", "singleArmLandmineRow",
        ("Grip below the plates", ("Grip",
                                   "The hand wraps the bar just below the plates.",
                                   "Gripping close to the load keeps the bar's arc short and lets the elbow track straight back.",
                                   "Gripping far down the shaft, which makes the bar swing across the body.",
                                   "Grip the bar just below the collar, thumb around it, wrist straight.")),
        ("Elbow to the hip", ("Elbow Path",
                              "The elbow drives back toward the hip.",
                              "Pulling toward the hip lines the row up with the lower lat.",
                              "Pulling the hand up toward the chest with the elbow flaring.",
                              "Row the elbow back past the torso toward the hip, keeping it close to the ribs.")),
        "Free hand on the thigh",
        ("Hips hinged, back flat", ("Torso Position",
                                    "A hinge of about 35° from level, held still.",
                                    "A fixed, braced hinge keeps the lat doing the work and protects the lower back from the one-sided load.",
                                    "The torso rising and twisting to lift the bar.",
                                    "Hinge from the hips with soft knees and a flat back, brace against the thigh, and hold that angle.")),
        ("TORSO TWISTING", "Square torso, elbow to hip", "Torso twists open",
         "With the torso square and braced, the lat rows the bar straight back to the hip.",
         "Twisting open to heave the bar shortens the row and loads the lower back unevenly."),
        [("Latissimus Dorsi", P, HI, 0.86), ("Middle Trapezius", S, MOD, 0.56), ("Biceps Brachii", S, MOD, 0.52)])

one_arm("Kettlebell Row", "kettlebellRow",
        ("Neutral grip on the handle", ("Grip",
                                        "The handle sits across the palm, thumb facing forward.",
                                        "A neutral grip keeps the wrist straight and the elbow close, so the lat pulls in its strongest line.",
                                        "Letting the bell hang from the fingertips, which bends the wrist and tires the grip first.",
                                        "Hold the handle deep in the palm, wrist straight, bell hanging under the shoulder.")),
        ("Elbow to the hip", ("Elbow Path",
                              "The elbow drives back toward the hip.",
                              "Pulling toward the hip lines the row up with the lower lat.",
                              "Winging the elbow out to the side.",
                              "Row the elbow back past the torso toward the hip, bell close to the body.")),
        "Free hand on the thigh",
        ("Hips hinged, back flat", ("Torso Position",
                                    "The torso hinges forward and stays there.",
                                    "A braced hinge with the free hand on the thigh keeps the lower back safe under a one-sided load.",
                                    "Standing up or twisting with each rep.",
                                    "Hinge to about 30° from level with soft knees, free hand on the thigh, and hold the angle.")),
        ("TORSO TWISTING", "Square torso, elbow to hip", "Torso twists open",
         "Holding the torso square makes the lat row the bell.",
         "Twisting open swings the bell up with the trunk and loads the lower back unevenly."),
        [("Latissimus Dorsi", P, HI, 0.84), ("Middle Trapezius", S, MOD, 0.56), ("Biceps Brachii", S, MOD, 0.50)])

ex(name="Landmine Row", var="landmineRow", group="back", kind="row",
   annotations=[
       ("elbow", "Elbows close to the ribs", "forearm_L"),
       ("barpath", "Handle to the lower chest", "hand_R"),
       ("grip", "Close neutral grip", "hand_L"),
       ("feet", "Hips hinged, back flat", "pelvis"),
       ("scapula", "Squeeze shoulder blades", "scapula_R"),
   ],
   cues={
       "elbow": ("Elbow Path",
                 "A close grip keeps the elbows tight.",
                 "Elbows brushing the ribs line the row up with the lats.",
                 "Flaring the elbows out wide.",
                 "Pull the elbows back past the torso, close to the ribs."),
       "barpath": ("Row Path",
                   "The handle travels up to the bottom of the chest.",
                   "The landmine's arc brings the handle to the lower chest, where the mid-back finishes the squeeze.",
                   "Short reps that stop well below the chest.",
                   "Row until the plates nearly touch the chest, pause, then lower to straight arms."),
       "grip": ("Grip",
                "Both hands on a close, neutral handle.",
                "A neutral grip keeps the wrists straight and the elbows close.",
                "Reaching for the handle with the shoulders rounded.",
                "Set a close-grip handle under the bar's end and hold it with palms facing each other."),
       "feet": ROW_HINGE,
       "scapula": SCAP_ROW,
   },
   activation=[("Latissimus Dorsi", P, HI, 0.84), ("Middle Trapezius", P, HI, 0.76), ("Biceps Brachii", S, MOD, 0.54)],
   stabilisers=["erector spinae", "hamstrings", "forearms", "core"],
   comparison=("ROUNDED LOWER BACK", "Flat back, fixed hinge", "Back rounds over the bar",
               "A flat, braced hinge lets the back muscles row the handle to the chest.",
               "Rounding over the bar puts the load on the spine instead of the lats and mid-back."))

ex(name="Dumbbell Bent-Over Row", var="dumbbellBentOverRow", group="back", kind="row",
   annotations=[
       ("elbow", "Elbows back ~30–45°", "forearm_L"),
       ("barpath", "Dumbbells to the hips", "hand_R"),
       ("grip", "Palms facing each other", "hand_L"),
       ("feet", "Soft knees, fixed hinge", "pelvis"),
       ("scapula", "Squeeze shoulder blades", "scapula_R"),
   ],
   cues={
       "elbow": ELBOW_ROW,
       "barpath": ("Row Path",
                   "The dumbbells travel back toward the hips.",
                   "An arc toward the hips, rather than straight up to the chest, keeps the pull on the lats.",
                   "Pulling the dumbbells up to the chest with the elbows flaring.",
                   "Row the dumbbells back along the sides toward the hip bones, then lower to a full stretch."),
       "grip": ("Grip",
                "A neutral grip, palms facing each other.",
                "Neutral wrists keep the forearms in line with the pull and the elbows close.",
                "Letting the dumbbells drift out to the sides.",
                "Hold the dumbbells with palms facing in, wrists straight, hanging under the shoulders."),
       "feet": ("Torso Position",
                "Knees soft, hips back, torso about 30° from level.",
                "A deep, fixed hinge with nearly straight legs keeps the back muscles rowing and the legs out of it.",
                "The torso rising toward upright to swing the dumbbells.",
                "Soften the knees, push the hips back until the torso is well below 45°, brace, and hold that angle."),
       "scapula": SCAP_ROW,
   },
   activation=[("Latissimus Dorsi", P, HI, 0.84), ("Middle Trapezius", P, HI, 0.74), ("Biceps Brachii", S, MOD, 0.52)],
   stabilisers=["erector spinae", "hamstrings", "forearms", "core"],
   comparison=("USING MOMENTUM", "Fixed hinge, elbows drive", "Torso swings the weight",
               "Holding the hinge keeps the lats and mid-back rowing the dumbbells.",
               "Swinging the torso up turns the row into a heave and loads the lower back."))

ex(name="Renegade Row", var="renegadeRow", group="back", kind="row", slots=FLAT,
   annotations=[
       ("body", "Body in one straight line", "pelvis"),
       ("hands", "Hands under the shoulders", "hand_R"),
       ("elbow", "Row the elbow to the hip", "forearm_L"),
       ("hips", "Hips stay level", "spine"),
       ("feet", "Feet wide for balance", "foot_L"),
   ],
   cues={
       "body": BODY,
       "hands": ("Hand Position",
                 "Each hand grips a dumbbell under its shoulder.",
                 "Dumbbells directly under the shoulders keep the supporting arm stacked while the other rows.",
                 "Dumbbells placed forward or wide, which makes the plank unstable.",
                 "Set the dumbbells shoulder-width apart, handles parallel, directly under the shoulders."),
       "elbow": ("Elbow Path",
                 "The rowing elbow drives back to the hip.",
                 "Pulling toward the hip works the lat while the supporting arm and trunk hold the plank.",
                 "Winging the elbow out to the side.",
                 "Row the dumbbell to the hip bone, elbow close to the ribs, then set it down under control."),
       "hips": ("Anti-Rotation",
                "The hips stay square to the floor.",
                "Resisting rotation as one hand lifts is the core half of the exercise.",
                "The hips twisting open toward the rowing side.",
                "Brace hard, squeeze the glutes and keep both hip bones pointing at the floor as each arm rows."),
       "feet": ("Base",
                "A wider stance than a push-up.",
                "Feet wider than the hips make a steadier three-point base when one hand leaves the floor.",
                "Feet together, which makes the body tip toward the rowing side.",
                "Set the feet about shoulder-width or wider, toes tucked."),
   },
   activation=[("Latissimus Dorsi", P, HI, 0.76), ("Middle Trapezius", S, MOD, 0.58), ("Obliques", S, MOD, 0.56), ("Rectus Abdominis", S, MOD, 0.50)],
   stabilisers=["serratus anterior", "triceps brachii", "glutes", "shoulders"],
   comparison=("HIPS TWISTING", "Hips square, body still", "Hips rotate with the row",
               "Holding the hips square makes the core resist rotation while the lat rows the dumbbell.",
               "Letting the hips twist turns the row into a rocking motion and loses the anti-rotation work."))

ex(name="Gorilla Row", var="gorillaRow", group="back", kind="row",
   annotations=[
       ("feet", "Wide stance, hips low", "foot_R"),
       ("spine", "Flat back", "spine"),
       ("elbow", "Row the elbow to the hip", "forearm_L"),
       ("alternate", "Press the other bell down", "hand_R"),
       ("scapula", "Squeeze shoulder blades", "scapula_L"),
   ],
   cues={
       "feet": ("Stance",
                "A wide, deep stance, the bells between the feet.",
                "A wide stance with the hips low lets the torso sit nearly level without rounding the back.",
                "Standing narrow with straight legs, which forces the back to round to reach the bells.",
                "Stand wider than the shoulders, toes slightly out, bells between the feet; bend the knees and push the hips back."),
       "spine": ("Spine Position",
                 "The back stays flat and level.",
                 "A braced, flat back keeps the load on the lats while the torso stays still for both arms.",
                 "Rounding the back as the bells get heavy.",
                 "Brace, chest slightly up, back flat, and keep the torso still as the arms take turns."),
       "elbow": ("Elbow Path",
                 "Each row drives the elbow to the hip.",
                 "Pulling toward the hip lines the row up with the lower lat.",
                 "Winging the elbow out to the side.",
                 "Row one bell back toward the hip, elbow close to the ribs, then set it down."),
       "alternate": ("Alternating Rhythm",
                     "The other bell stays on the floor, pushed down.",
                     "Pressing the planted bell into the floor braces the body so the rowing side cannot twist it.",
                     "Rotating the torso to swing each bell up.",
                     "Push the planted bell into the floor as the other rows, keep the shoulders level, then switch."),
       "scapula": SCAP_ROW,
   },
   activation=[("Latissimus Dorsi", P, HI, 0.84), ("Middle Trapezius", S, MOD, 0.60), ("Biceps Brachii", S, MOD, 0.48)],
   stabilisers=["erector spinae", "glutes", "obliques", "forearms"],
   comparison=("TORSO TWISTING", "Level torso, planted bell pressed", "Torso twists to swing",
               "With the torso level and braced against the planted bell, each lat rows its own bell.",
               "Twisting to swing the bell up uses momentum and loads the lower back."))

# ---------------------------------------------------------------- inverted rows

def inverted(name, var, grip, elbow, comp, activation, extra=""):
    ex(name=name, var=var, group="back", kind="row", slots=FLAT,
       annotations=[
           ("body", "Heels to head in one line", "pelvis"),
           ("grip", grip[0], "hand_L"),
           ("elbow", elbow[0], "forearm_L"),
           ("barpath", "Chest to the bar", "support_PectoralisMajor_Sternal_L"),
           ("scapula", "Squeeze shoulder blades", "scapula_L"),
       ],
       cues={
           "body": ("Body Line",
                    "The body is a rigid plank hanging from the bar.",
                    "Holding the hips up and the glutes tight means the back and arms lift the whole body as one piece" + extra + ".",
                    "Hips sagging toward the floor, so the chest never reaches the bar.",
                    "Squeeze the glutes and brace so the heels, hips and shoulders stay in one line from the bottom to the top."),
           "grip": grip[1],
           "elbow": elbow[1],
           "barpath": ("Range of Motion",
                       "The chest comes up to the bar every rep.",
                       "Rowing all the way up works the mid-back through the squeeze; the bottom hang stretches it.",
                       "Short reps that stop with the chest well below the bar.",
                       "Pull until the chest touches or nearly touches the bar, pause, then lower to straight arms."),
           "scapula": ("Scapular Position",
                       "The shoulder blades pull back and down, not up.",
                       "Retracting without shrugging keeps the mid-traps and rhomboids in the row.",
                       "Shrugging the shoulders up toward the ears to reach the bar.",
                       "Start each rep by pulling the shoulder blades together and down, then bend the arms."),
       },
       activation=activation, stabilisers=["glutes", "core", "rear deltoid", "forearms"], comparison=comp)

inverted("Inverted Row", "invertedRow",
         ("Overhand, a bit wider than shoulders", ("Grip",
                                                   "Overhand, hands a little wider than the shoulders.",
                                                   "A slightly wide overhand grip lets the elbows travel out and back, working the mid-back and rear delts.",
                                                   "Gripping so wide the chest cannot reach the bar.",
                                                   "Grip the bar overhand just outside shoulder-width, wrists straight.")),
         ("Elbows ~45° from the body", ("Elbow Path",
                                        "The elbows travel back at about 45°.",
                                        "Around 45° shares the pull between the lats and the mid-back.",
                                        "Flaring the elbows out to 90°, which loads the shoulders.",
                                        "Pull the elbows back and down at about 45° from the body.")),
         ("HIPS SAGGING", "Rigid plank, chest to the bar", "Hips sag, short reps",
          "A rigid body lets the back and arms lift it all the way to the bar.",
          "Sagging hips shorten every rep and swap back work for a hip thrust."),
         [("Middle Trapezius", P, HI, 0.80), ("Latissimus Dorsi", P, HI, 0.74), ("Biceps Brachii", S, MOD, 0.56), ("Posterior Deltoid", S, MOD, 0.52)])

inverted("Feet-Elevated Inverted Row", "feetElevatedInvertedRow",
         ("Overhand, a bit wider than shoulders", ("Grip",
                                                   "Overhand, hands a little wider than the shoulders.",
                                                   "A slightly wide overhand grip lets the elbows travel out and back, working the mid-back and rear delts.",
                                                   "Gripping so wide the chest cannot reach the bar.",
                                                   "Grip the bar overhand just outside shoulder-width, wrists straight.")),
         ("Elbows ~45° from the body", ("Elbow Path",
                                        "The elbows travel back at about 45°.",
                                        "Around 45° shares the pull between the lats and the mid-back.",
                                        "Flaring the elbows out to 90°, which loads the shoulders.",
                                        "Pull the elbows back and down at about 45° from the body.")),
         ("HIPS SAGGING", "Rigid plank, chest to the bar", "Hips sag, short reps",
          "With the feet raised the body is nearly level, so a rigid plank puts almost all of its weight on the back.",
          "Sagging hips shorten every rep and waste the harder angle the bench provides."),
         [("Middle Trapezius", P, HI, 0.84), ("Latissimus Dorsi", P, HI, 0.78), ("Biceps Brachii", S, MOD, 0.58), ("Posterior Deltoid", S, MOD, 0.54)],
         extra=", and raising the feet makes that body nearly level and heavier to pull")

inverted("Underhand Inverted Row", "underhandInvertedRow",
         ("Underhand, shoulder-width", ("Grip",
                                        "Underhand, hands about shoulder-width.",
                                        "Palms facing you tuck the elbows and bring the biceps and lower lats in more.",
                                        "Gripping wide underhand, which strains the wrists and elbows.",
                                        "Grip the bar underhand at shoulder-width, thumbs around it, wrists straight.")),
         ("Elbows close to the ribs", ("Elbow Path",
                                       "The elbows brush the sides.",
                                       "Tucked elbows line the pull up with the lats.",
                                       "Letting the elbows flare out to the sides.",
                                       "Pull the elbows back along the ribs as the chest rises to the bar.")),
         ("HIPS SAGGING", "Rigid plank, chest to the bar", "Hips sag, short reps",
          "A rigid body lets the lats and biceps lift it all the way to the bar.",
          "Sagging hips shorten every rep and swap back work for a hip thrust."),
         [("Latissimus Dorsi", P, HI, 0.80), ("Biceps Brachii", S, HI, 0.66), ("Middle Trapezius", S, MOD, 0.62)])
