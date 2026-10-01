# Trainer content for the chest batch 101-131 (2026-09-25), exported to the
# HIKSEMI drive's "100-131" folder (100, 127, 129 and 130 were not exported)
# and converted from SourceExports/Chest3. Same format as spec.py; generate
# with `spec` swapped for this module (see README).
#
# What each model shows, from the rig (joint angles sampled across the clip):
# - Floor presses: lying on a mat, knees bent ~70°, feet flat; the upper arms
#   come down to the floor at the bottom.
# - Smith presses: flat bench, 30° incline, or ~15° decline with the shins
#   hooked under an ankle roller; shoulder-width-plus grip.
# - Single-Arm Dumbbell Bench Press: only the LEFT arm presses; the right arm
#   rests by the side. Alternating: each arm presses in turn while the other
#   dumbbell waits at the chest.
# - Neutral-grip: hands narrower (~0.55 m apart), elbows tucked. Squeeze
#   presses: the two dumbbells stay pressed together the whole rep.
# - Pullovers: lying along a flat bench, elbows held soft (~150-155°); the
#   arms sweep from over the chest to in line with the torso overhead.
# - Cable chest press, high-to-low fly, single-arm fly, crossover, landmine:
#   standing, left foot ahead of the right, torso tilted ~6° forward. Single-
#   arm cable press/fly and the landmine press work the LEFT arm only. The
#   crossover's hands cross at the finish, left over right.
# - Incline/decline cable press and fly: 30° and ~15° decline benches between
#   two low pulleys.
# - Machines: seated, back on the pad; the iso-lateral press alternates arms;
#   the incline machine presses up and forward from a seat back ~25° off
#   vertical; the wide-grip machine stops short of lockout (~145°).
# - Incline Push-Up: hands on a bench, body at ~30° to the floor.
#
# Every framing has a negative yaw, so the lifter's LEFT side faces the camera
# (the head-on cable flies show the left arm on the right of the frame).
#
# Sources:
# - Saeterbakken AH, van den Tillaar R, Fimland MS 2011, J Sports Sci
#   29(5):533-538 — barbell, Smith machine and dumbbell chest press: similar
#   pectoralis activity; the less stable the press, the more the stabilisers
#   (biceps, deltoids) work and the less load can be moved.
# - Schick EE et al. 2010, J Strength Cond Res 24(3):779-784 — Smith machine
#   vs free-weight bench press: similar pectoralis and anterior deltoid
#   activity, less medial deltoid on the Smith machine.
# - Lauver JD, Cayot TE, Scheuermann BW 2016, Eur J Sport Sci 16(3):309-316 —
#   a ~30° incline raises clavicular pectoralis activity; steeper benches hand
#   the lift to the anterior deltoid; a -15° decline favours the lower fibres.
# - Rodriguez-Ridao D et al. 2020, Int J Environ Res Public Health
#   17(19):7339 — pectoralis, anterior deltoid and triceps activity across
#   five bench angles.
# - Lehman GJ 2005, J Strength Cond Res 19(3):587-591 — grip width and
#   forearm rotation change clavicular pectoralis and triceps activity.
# - Marchetti PH, Uchida MC 2011, J Appl Biomech 27(4):380-384 — the pullover
#   works the pectoralis major more than the latissimus dorsi.
# - Solstad TEJ et al. 2020, J Sports Sci Med 19(4):645-651 — dumbbell fly vs
#   bench press: pectoralis, anterior deltoid and triceps all more active in
#   the bench press (by 8-81%), the triceps by far the most; the biceps more
#   active in the fly. (Corrected 2026-09-29; this line used to say the
#   pectoralis activity was similar.)
# - Santana JC, Vera-Garcia FJ, McGill SM 2007, J Strength Cond Res
#   21(4):1271-1277 — the standing one-arm cable press is limited by balance
#   and the trunk's rotational stiffness, not by the chest.
# - Ebben WP et al. 2011, J Strength Cond Res 25(10):2891-2894 — hands
#   elevated on a ~60 cm box, a push-up lifts ~41% of body mass against ~64%
#   for a standard push-up.
# - ExRx.net, ACE and NASM technique guidance for grip, elbow angle (45-60°),
#   bench angle and a fly's fixed slight elbow bend.

import json, os

P, S = "primary", "secondary"
HI, MOD, LOW = "HIGH ACTIVATION", "MODERATE ACTIVATION", "LOW ACTIVATION"
A, SOFT = "activation", "activationSoft"
FLAT = [0.15, 0.28, 0.63, 0.75, 0.87]

J = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "joints.json")))

def mean(name, joints):
    pts = [p for j in joints for p in J[name][j]]
    return sum(u for u, _ in pts) / len(pts), sum(v for _, v in pts) / len(pts)

def glows(name, head="Sternal"):
    """Activation signature: the pecs on the named head, the near front delt
    and the near triceps, placed from the probed joints."""
    cx, cy = mean(name, [f"support_PectoralisMajor_{head}_L", f"support_PectoralisMajor_{head}_R"])
    dx, dy = mean(name, ["upper_arm_L"])
    tx, ty = mean(name, ["upper_arm_L", "forearm_L"])
    return [(A, 0.58, 0.16, 0.09, cx, cy), (SOFT, 0.32, 0.08, 0.06, dx, dy), (SOFT, 0.28, 0.07, 0.05, tx, ty)]

SPEC = []

def ex(**kw):
    kw.setdefault("group", "chest")
    kw["glows"] = glows(kw["name"], kw.pop("head", "Sternal"))
    SPEC.append(kw)

# ---------------------------------------------------------------- shared cues

SCAP_BENCH = ("Scapular Position",
              "The shoulder blades are the platform the press pushes from.",
              "Pulling the scapulae back and down shortens the distance the shoulder has to travel and keeps the humeral head centred under load.",
              "Letting the shoulders roll forward off the bench as the weight comes up.",
              "Pull the shoulder blades back and down into the bench before the first rep and keep them there.")
FEET_BENCH = ("Leg Drive",
              "The feet are the lifter's contact with the floor.",
              "Planted feet keep the hips on the bench and the upper back tight, so the press has a solid base.",
              "Feet drifting, up on the toes or the hips lifting off the bench to finish a rep.",
              "Plant both feet flat and a little wider than the hips, and keep the glutes on the bench for every rep.")
FEET_DECLINE = ("Foot Position",
                "A decline bench swaps the floor for an ankle roller.",
                "Locking the shins under the roller replaces the leg drive a flat bench gets from the floor and stops you sliding toward the head.",
                "Feet slipping out from under the roller mid-set, so the hips slide up the bench.",
                "Hook both legs firmly under the roller and brace before the first rep.")
WRIST_DB = ("Wrist Stacking",
            "Each dumbbell needs its own stacked wrist.",
            "A neutral wrist sends the weight straight down the forearm instead of bending the joint back.",
            "Wrists bending back under the dumbbell as the set gets hard.",
            "Keep each wrist straight and firm, the dumbbell over the middle of the forearm.")
WRIST_BAR = ("Wrist Stacking",
             "The bar sits over the forearm, not behind it.",
             "A stacked wrist transmits force straight down the forearm into the bar with no leak at the joint.",
             "The bar rolling back into the fingers, which bends the wrist back under load.",
             "Hold the bar low in the palm against the heel of the hand, knuckles up, wrist neutral.")
SCAP_SEATED = ("Scapular Position",
               "A machine fixes the path, not the shoulders.",
               "Shoulder blades set down and back against the pad keep the chest leading the press instead of the front delts and upper traps.",
               "Shrugging the shoulders up toward the ears or rolling them forward off the pad at the end of each press.",
               "Sit tall, set the shoulder blades back and down against the pad, and keep them there as the handles move.")
FEET_SEATED = ("Base Position",
               "Seated pressing still needs a base.",
               "Feet flat and the back on the pad let you push hard without the torso sliding or arching.",
               "Arching the lower back off the pad or lifting the heels to force the last reps.",
               "Keep both feet flat on the floor and the whole back against the pad for every rep.")
FEET_STAND = ("Stance",
              "Standing cable work is only as steady as the feet.",
              "A staggered stance with soft knees braces the body against the cables' pull, so the chest moves the load rather than the legs and back.",
              "Standing square with locked knees, so the cables pull the body back and forth.",
              "Stand with one foot a step ahead of the other, knees soft, torso tilted slightly forward and braced.")
SCAP_STAND = ("Scapular Position",
              "Chest up, shoulders back, before the handles move.",
              "Set shoulder blades keep the pecs, not the front delts, doing the work and protect the front of the shoulder at the stretch.",
              "Shoulders rolling forward and in as the hands come together.",
              "Lift the chest, draw the shoulders gently back and down, and hold that position through every rep.")
ELBOW_FLY = ("Elbow Bend",
             "A fly is a hug, not a press.",
             "A fixed, slight elbow bend keeps the load on the pecs through a long arc and off the elbow joint.",
             "Bending the elbows more as the hands come in, which turns the fly into a press.",
             "Lock in a soft bend at the elbows, about 15-20°, and keep that exact angle from the stretch to the squeeze.")

def machine(name, var, grip, elbow, path, comp, activation, stabilisers=("rotator cuff", "serratus anterior")):
    # Seated three-quarter: the lifter fills the middle and right of the
    # frame, so the shoulder and elbow cues track the far (right) side, which
    # sits in the open space on the left.
    ex(name=name, var=var,
       overrides={"wrist": (0.14, "trailing"), "scapula": (0.14, "leading"), "elbow": (0.50, "leading"),
                  "barpath": (0.68, "trailing"), "feet": (0.86, "trailing")},
       annotations=[
           ("wrist", grip[0], "hand_L"),
           ("elbow", elbow[0], "forearm_R"),
           ("barpath", path[0], "support_PectoralisMajor_Sternal_L"),
           ("feet", "Feet flat, back on pad", "foot_L"),
           ("scapula", "No shrugging", "scapula_R"),
       ],
       cues={"wrist": grip[1], "elbow": elbow[1], "barpath": path[1],
             "feet": FEET_SEATED, "scapula": SCAP_SEATED},
       activation=activation, stabilisers=list(stabilisers), comparison=comp,
       head={"Incline": "Clavicular", "Decline": "Abdominal"}.get(name.split()[0], "Sternal"))

# ---------------------------------------------------------------- barbell and Smith

ex(name="Barbell Floor Press", var="barbellFloorPress",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45°, touch lightly", "forearm_R"),
       ("barpath", "Bar over lower chest", "support_PectoralisMajor_Abdominal_L"),
       ("feet", "Knees bent, feet flat", "foot_L"),
       ("scapula", "Shoulders pinned down", "scapula_L"),
   ],
   cues={
       "wrist": WRIST_BAR,
       "elbow": ("Elbow Position",
                 "The floor sets the depth: the rep ends when the upper arms touch it.",
                 "Around 45° from the torso keeps the pecs in their strongest line and lets the triceps rest on the floor instead of the shoulder hanging past it.",
                 "Flaring the elbows to 90°, or dropping them onto the floor so hard they bounce the bar back up.",
                 "Tuck the upper arms to about 45°, let them touch the floor softly, pause for a beat, then press."),
       "barpath": ("Bar Path",
                   "The bar travels over the lower chest, as in the bench press.",
                   "With the shoulders on the floor, a bar over the lower chest keeps the forearms vertical and the load on the pecs and triceps.",
                   "Letting the bar drift toward the neck, which flares the elbows and loads the front of the shoulder.",
                   "Keep the bar over the bottom of the breastbone at the bottom and finish with it over the shoulders."),
       "feet": ("Base Position",
                "The legs don't drive a floor press; they only steady it.",
                "Bent knees and flat feet keep the lower back quiet, so the whole press comes from the chest and triceps.",
                "Bridging the hips up off the floor to push the bar through a hard rep.",
                "Bend the knees, set both feet flat about hip-width apart, and keep the hips on the floor."),
       "scapula": ("Scapular Position",
                   "The floor gives the shoulder blades a firm base.",
                   "Pinning the scapulae back and down keeps the shoulders centred as the arms reach the floor.",
                   "Shoulders rolling up off the floor as the bar goes up.",
                   "Pull the shoulder blades back and down into the floor and keep them there through every rep."),
   },
   activation=[("Pectoralis Major", P, HI, 0.86), ("Triceps Brachii", S, HI, 0.66), ("Anterior Deltoid", S, MOD, 0.44)],
   stabilisers=["rotator cuff", "serratus anterior", "core"],
   comparison=("BOUNCING OFF THE FLOOR", "Soft touch, brief pause", "Elbows slam the floor",
               "Touching the floor softly and pausing takes the stretch reflex away, so the chest and triceps press from a dead stop.",
               "Dropping the elbows into the floor bounces the bar up with momentum and jars the elbow and shoulder joints."),
   head="Abdominal")

ex(name="Smith Machine Bench Press", var="smithMachineBenchPress",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45°", "forearm_L"),
       ("barpath", "Bar lands on lower chest", "support_PectoralisMajor_Abdominal_L"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": WRIST_BAR,
       "elbow": ("Elbow Position",
                 "The rails steady the bar, not the elbows.",
                 "At roughly 45° from the torso the pectoralis major stays in its strongest line of pull and the shoulder keeps clearance in the socket.",
                 "Flaring the elbows to 90°, which the fixed bar path makes easy to do without noticing.",
                 "Tuck the upper arms to about 45° as the bar descends, forearms vertical under the wrists."),
       "barpath": ("Bench Position",
                   "On a Smith machine the bar can only go straight up and down, so the bench sets where it lands.",
                   "With the bench placed so the bar meets the lower chest, the forearms stay vertical at the bottom; placed too far back, the bar comes down on the neck and the elbows flare.",
                   "Setting the bench so the bar lowers toward the upper chest or neck.",
                   "Before loading, lower the empty bar and slide the bench until it touches the bottom of the breastbone."),
       "feet": FEET_BENCH,
       "scapula": ("Scapular Position",
                   "The machine balances the bar; the shoulder blades still have to be set.",
                   "Retracted, depressed scapulae keep the shoulders centred and the chest high under a bar that cannot drift.",
                   "Pressing with the shoulders rolled forward because the machine feels stable.",
                   "Pull the shoulder blades back and down before unhooking the bar and hold them there for the set."),
   },
   activation=[("Pectoralis Major", P, HI, 0.90), ("Anterior Deltoid", S, MOD, 0.52), ("Triceps Brachii", S, MOD, 0.50)],
   stabilisers=["rotator cuff", "serratus anterior"],
   comparison=("BAR TO THE NECK", "Bench set, bar to lower chest", "Bench too far back",
               "With the bench under the bar's fixed path, it touches the lower chest with the forearms vertical and the elbows tucked.",
               "The fixed rails bring the bar down wherever the bench puts you; too far back and it lands high on the chest, flaring the elbows and loading the shoulder."),
   head="Abdominal")

ex(name="Smith Machine Incline Press", var="smithMachineInclinePress",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45–60°", "forearm_L"),
       ("barpath", "Bar to upper chest", "support_PectoralisMajor_Clavicular_L"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": WRIST_BAR,
       "elbow": ("Elbow Angle",
                 "Elbow angle decides how much reaches the upper chest.",
                 "Around 45-60° from the torso keeps the clavicular head of the pec in its strongest line without over-rotating the shoulder.",
                 "Flaring the elbows straight out, which shifts the press onto the front delts.",
                 "Keep the upper arms around 45-60° from the torso as the bar comes down."),
       "barpath": ("Bench Angle and Bar Path",
                   "On an incline Smith press, the bench angle and its position under the rails set the whole lift.",
                   "A bench around 30° biases the upper chest; much steeper and the anterior deltoid takes over. The bench's position decides where the vertical bar touches.",
                   "Setting the bench past 45°, or so far under the bar that it lands on the neck.",
                   "Set the bench to about 30° and position it so the bar touches just below the collarbones."),
       "feet": FEET_BENCH,
       "scapula": SCAP_BENCH,
   },
   activation=[("Upper Pectoralis", P, HI, 0.86), ("Anterior Deltoid", S, MOD, 0.62), ("Triceps Brachii", S, MOD, 0.46)],
   stabilisers=["rotator cuff", "serratus anterior"],
   comparison=("BENCH TOO STEEP", "30° incline, bar to upper chest", "Past 45°, delts take over",
               "At about 30° the vertical bar path lines up with the upper chest and the clavicular pec does most of the pressing.",
               "Past about 45° the lift behaves like a shoulder press: the anterior deltoid takes the load and the upper chest does less."),
   head="Clavicular")

ex(name="Smith Machine Decline Press", var="smithMachineDeclinePress",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45°", "forearm_L"),
       ("barpath", "Bar to lower chest", "support_PectoralisMajor_Abdominal_L"),
       ("feet", "Legs hooked in", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": WRIST_BAR,
       "elbow": ("Elbow Angle",
                 "Same elbow rule as any bench press, head-down.",
                 "Roughly 45° keeps the lower pec fibres loaded without stacking stress on the front of the shoulder.",
                 "Flaring the elbows to 90° under the bar.",
                 "Tuck the upper arms to about 45° as the bar lowers toward the lower chest."),
       "barpath": ("Bar Path",
                   "The decline moves the touch point down the chest.",
                   "Touching the lower chest keeps the lower (sternocostal) fibres in their strongest line, and a controlled touch protects the sternum.",
                   "Bouncing the bar off the chest to get it moving, which the rails make tempting.",
                   "Lower under control to the bottom of the chest, pause briefly, then press without bouncing."),
       "feet": FEET_DECLINE,
       "scapula": ("Scapular Position",
                   "Head-down, the upper back tends to lift off the pad.",
                   "Pinned shoulder blades keep the shoulders stable while the bar travels toward the face.",
                   "Shoulders lifting off the bench as the bar comes down.",
                   "Pin the shoulder blades back and down before unhooking the bar, and keep them there for the set."),
   },
   activation=[("Lower Pectoralis", P, HI, 0.92), ("Triceps Brachii", S, MOD, 0.54), ("Anterior Deltoid", S, LOW, 0.34)],
   stabilisers=["latissimus dorsi", "rotator cuff", "core"],
   comparison=("BOUNCING OFF CHEST", "Controlled touch, lower chest", "Bar bounced off the chest",
               "A brief pause at the lower chest keeps tension on the pec and spares the sternum.",
               "Bouncing uses momentum instead of muscle, and repeated impact on the sternum is a common cause of pressing injuries."),
   head="Abdominal")

# ---------------------------------------------------------------- dumbbells

ex(name="Dumbbell Floor Press", var="dumbbellFloorPress",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45°, touch lightly", "forearm_L"),
       ("barpath", "Dumbbells over chest", "support_PectoralisMajor_Sternal_L"),
       ("feet", "Knees bent, feet flat", "foot_L"),
       ("scapula", "Shoulders pinned down", "scapula_L"),
   ],
   cues={
       "wrist": WRIST_DB,
       "elbow": ("Elbow Position",
                 "The floor stops the elbows, so the bottom of every rep is the same.",
                 "Upper arms around 45° from the torso land on the floor with the shoulders protected; the short range suits sore shoulders.",
                 "Flaring the elbows out to 90°, or letting them crash into the floor.",
                 "Tuck the elbows to about 45°, touch the floor lightly with the upper arms, pause, then press."),
       "barpath": ("Press Path",
                   "The dumbbells rise over the chest and come slightly together.",
                   "Pressing up and a little in finishes each dumbbell over its shoulder joint, where it is easiest to hold.",
                   "Letting the dumbbells drift out wide, away from the chest, as they go up.",
                   "Press from the sides of the chest up and slightly in, finishing with the dumbbells over the shoulders."),
       "feet": ("Base Position",
                "The legs only steady a floor press.",
                "Bent knees and flat feet keep the lower back quiet, so the chest and triceps do all the pressing.",
                "Bridging the hips off the floor to finish a hard rep.",
                "Bend the knees, set the feet flat about hip-width apart, and keep the hips down."),
       "scapula": ("Scapular Position",
                   "The floor gives the shoulder blades a firm base.",
                   "Pinning the scapulae back and down keeps the shoulders centred as the arms reach the floor.",
                   "Shoulders rolling up off the floor as the dumbbells go up.",
                   "Pull the shoulder blades back and down into the floor and keep them there."),
   },
   activation=[("Pectoralis Major", P, HI, 0.86), ("Triceps Brachii", S, MOD, 0.58), ("Anterior Deltoid", S, MOD, 0.44)],
   stabilisers=["rotator cuff", "biceps brachii", "serratus anterior"],
   comparison=("ELBOWS FLARED 90°", "Elbows ~45°, soft touch", "Elbows flared, crashing down",
               "At about 45° the upper arms reach the floor with the shoulder in a supported position and the pecs in their strongest line.",
               "Flared to 90°, the upper arms land out wide and the front of the shoulder takes the load at the bottom of every rep."))

ex(name="Single-Arm Dumbbell Bench Press", var="singleArmDumbbellBenchPress",
   annotations=[
       ("wrist", "Keep the wrist stacked", "hand_L"),
       ("elbow", "Elbow ~45°", "forearm_L"),
       ("core", "Hips and shoulders level", "chest"),
       ("feet", "Feet wide and planted", "foot_L"),
       ("scapula", "Both shoulder blades down", "scapula_L"),
   ],
   cues={
       "wrist": ("Wrist Stacking",
                 "One dumbbell, one wrist to keep straight.",
                 "A neutral wrist sends the weight straight down the forearm into the chest press.",
                 "The wrist bending back as the dumbbell gets heavy.",
                 "Keep the wrist firm and the dumbbell over the middle of the forearm."),
       "elbow": ("Elbow Angle",
                 "The pressing arm follows the same line as a two-dumbbell press.",
                 "About 45° from the torso keeps the pec in its strongest line and the shoulder supported.",
                 "Letting the working elbow flare straight out to the side.",
                 "Lower until the upper arm is level with the torso, elbow about 45° out."),
       "core": ("Anti-Rotation",
                "A weight on one side tries to roll you off the bench.",
                "Holding the hips and shoulders square makes the trunk resist rotation, which is why one-arm pressing works the core as well as the chest.",
                "The body twisting toward the free side, the working shoulder lifting off the bench to push.",
                "Brace the core and keep both hips and both shoulders flat on the bench from the bottom to the top."),
       "feet": ("Base Position",
                "A wide base stops the roll before it starts.",
                "Feet planted wider than the hips give the trunk something to brace against.",
                "Feet close together or drifting, so the body tips toward the weight.",
                "Plant both feet flat, wider than hip-width, and push them into the floor."),
       "scapula": ("Scapular Position",
                   "Both shoulder blades stay set, not just the working one.",
                   "A retracted scapula on each side keeps the pressing shoulder stable and the body level.",
                   "The working shoulder rolling forward off the bench at the top of each press.",
                   "Pull both shoulder blades back and down before the set and keep them pinned."),
   },
   activation=[("Pectoralis Major", P, HI, 0.84), ("Triceps Brachii", S, MOD, 0.52), ("Anterior Deltoid", S, MOD, 0.46), ("Obliques", S, LOW, 0.30)],
   stabilisers=["rotator cuff", "quadratus lumborum", "serratus anterior"],
   comparison=("TORSO TWISTING", "Hips and shoulders square", "Working shoulder lifts to press",
               "Keeping the body flat makes the trunk resist the one-sided load while the chest presses the dumbbell.",
               "Twisting to push shortens the range, shifts load to the front delt and loses the anti-rotation work that makes the one-arm press worth doing."))

ex(name="Alternating Dumbbell Bench Press", var="alternatingDumbbellBenchPress",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45°", "forearm_R"),
       ("alternate", "Other dumbbell waits at chest", "hand_R"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": WRIST_DB,
       "elbow": ("Elbow Angle",
                 "Each arm follows the same line as a two-dumbbell press.",
                 "Keeping the upper arms around 45° protects the shoulder on both the pressing and the waiting side.",
                 "The waiting elbow sagging below the bench while the other arm presses.",
                 "Hold the waiting upper arm level with the torso, elbow about 45° out, while the other arm works."),
       "alternate": ("Alternating Rhythm",
                     "One dumbbell moves while the other holds.",
                     "Holding one dumbbell still at the chest keeps that side under tension and makes the trunk resist rotation as the other side presses.",
                     "Rocking the body side to side as the arms switch.",
                     "Keep the waiting dumbbell still beside the chest, press the other up and back down, then switch sides."),
       "feet": FEET_BENCH,
       "scapula": ("Scapular Position",
                   "Both shoulder blades stay pinned while the arms take turns.",
                   "A retracted scapula on each side keeps the body level as the load swaps from one arm to the other.",
                   "The pressing shoulder rolling forward off the bench at the top.",
                   "Pull the shoulder blades back and down and keep both of them flat on the bench."),
   },
   activation=[("Pectoralis Major", P, HI, 0.86), ("Triceps Brachii", S, MOD, 0.50), ("Anterior Deltoid", S, MOD, 0.46)],
   stabilisers=["rotator cuff", "obliques", "biceps brachii"],
   comparison=("BODY ROCKING", "Waiting side still, body flat", "Torso rolls with each press",
               "With the waiting dumbbell held still at the chest, each press is one arm's work and the trunk stays square.",
               "Rocking from side to side hands part of each rep to momentum and lets the waiting side rest."))

ex(name="Neutral-Grip Dumbbell Press", var="neutralGripDumbbellPress",
   annotations=[
       ("wrist", "Palms face each other", "hand_L"),
       ("elbow", "Elbows tucked ~30°", "forearm_R"),
       ("barpath", "Press over mid-chest", "support_PectoralisMajor_Sternal_L"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": ("Grip",
                 "The palms face each other for the whole rep.",
                 "A neutral grip lets the elbows tuck naturally, which many lifters find easier on the shoulders than a pronated grip.",
                 "The dumbbells twisting toward a palms-forward grip as the press gets hard.",
                 "Hold the handles parallel, palms facing in, wrists straight, from the bottom to the top."),
       "elbow": ("Elbow Position",
                 "A neutral grip brings the elbows in close.",
                 "With the upper arms around 30° from the torso the triceps take a larger share, and the shoulder stays out of full abduction.",
                 "Flaring the elbows out wide, as if the palms faced forward.",
                 "Keep the elbows close to the sides, about 30° out, as the dumbbells lower to the chest."),
       "barpath": ("Press Path",
                   "The dumbbells travel straight up over the middle of the chest.",
                   "Pressing over the mid-chest keeps the forearms vertical and the load balanced between the pecs and triceps.",
                   "The dumbbells drifting apart and out over the shoulders.",
                   "Lower the dumbbells beside the mid-chest and press them straight up, keeping them parallel."),
       "feet": FEET_BENCH,
       "scapula": SCAP_BENCH,
   },
   activation=[("Pectoralis Major", P, HI, 0.82), ("Triceps Brachii", S, MOD, 0.62), ("Anterior Deltoid", S, MOD, 0.48)],
   stabilisers=["rotator cuff", "serratus anterior", "biceps brachii"],
   comparison=("ELBOWS FLARED", "Palms in, elbows tucked", "Elbows flared out wide",
               "Tucked elbows under a neutral grip keep the shoulder in a strong, supported position and share the load with the triceps.",
               "Flared elbows undo what the neutral grip is for, putting the shoulder back into wide abduction under load."))

ex(name="Dumbbell Squeeze Press", var="dumbbellSqueezePress",
   annotations=[
       ("wrist", "Dumbbells pressed together", "hand_L"),
       ("elbow", "Elbows tucked to the ribs", "forearm_R"),
       ("barpath", "Squeeze all the way up", "support_PectoralisMajor_Sternal_L"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": ("The Squeeze",
                 "The two dumbbells stay pressed together from bottom to top.",
                 "Pushing the dumbbells into each other adds an inward (adduction) effort, so the pecs work to hold them together as well as to press them up.",
                 "Letting the dumbbells drift apart as they go up, which turns it into an ordinary close press.",
                 "Press the dumbbells firmly together, palms facing in, and keep squeezing through the whole rep."),
       "elbow": ("Elbow Position",
                 "With the dumbbells together, the elbows tuck close.",
                 "Elbows near the ribs let you squeeze hard without straining the shoulders.",
                 "Flaring the elbows to the sides, which pries the dumbbells apart.",
                 "Keep the elbows tucked close to the ribs as the dumbbells lower to the chest."),
       "barpath": ("Press Path",
                   "The pair travels as one, straight over the chest.",
                   "Lowering to the middle of the chest keeps the forearms vertical and the squeeze in the pecs.",
                   "Lowering the dumbbells toward the neck or upper chest.",
                   "Lower the pair to the middle of the chest, then press straight up while squeezing."),
       "feet": FEET_BENCH,
       "scapula": SCAP_BENCH,
   },
   activation=[("Pectoralis Major", P, HI, 0.84), ("Triceps Brachii", S, MOD, 0.62), ("Anterior Deltoid", S, MOD, 0.40)],
   stabilisers=["rotator cuff", "serratus anterior"],
   comparison=("DUMBBELLS DRIFTING APART", "Pressed together all the way", "Dumbbells separate on the press",
               "Squeezing the dumbbells together keeps the pecs working inward as well as upward for the whole rep.",
               "Once the dumbbells part, the squeeze is gone and the lift is just a close-grip press with the triceps doing more of it."))

ex(name="Incline Dumbbell Squeeze Press", var="inclineDumbbellSqueezePress",
   annotations=[
       ("wrist", "Dumbbells pressed together", "hand_L"),
       ("elbow", "Elbows tucked to the ribs", "forearm_R"),
       ("barpath", "Press over upper chest", "support_PectoralisMajor_Clavicular_L"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": ("The Squeeze",
                 "The dumbbells stay pressed together all the way up.",
                 "Squeezing them into each other adds an inward effort to the press, and on an incline that effort lands on the upper chest.",
                 "The dumbbells drifting apart as they rise.",
                 "Press the dumbbells firmly together, palms facing in, and keep squeezing through every rep."),
       "elbow": ("Elbow Position",
                 "Tucked elbows let you squeeze without straining the shoulders.",
                 "Elbows near the ribs keep the shoulder out of wide abduction on the incline.",
                 "Flaring the elbows out, which pulls the dumbbells apart.",
                 "Keep the elbows tucked close to the ribs from the bottom to the top."),
       "barpath": ("Bench Angle and Path",
                   "A 30° bench aims the press at the upper chest.",
                   "Around 30° biases the clavicular head of the pec; steeper benches hand the work to the front delts.",
                   "Setting the bench past 45°, or lowering the pair to the neck.",
                   "Set the bench to about 30°, lower the pair to the upper chest and press straight up."),
       "feet": FEET_BENCH,
       "scapula": SCAP_BENCH,
   },
   activation=[("Upper Pectoralis", P, HI, 0.84), ("Anterior Deltoid", S, MOD, 0.58), ("Triceps Brachii", S, MOD, 0.56)],
   stabilisers=["rotator cuff", "serratus anterior"],
   comparison=("DUMBBELLS DRIFTING APART", "Pressed together, 30° bench", "Dumbbells separate on the press",
               "Squeezing the dumbbells together on a 30° incline keeps the upper chest working inward and upward for the whole rep.",
               "Once the dumbbells part, the squeeze is gone and more of the press falls to the triceps and front delts."),
   head="Clavicular")

# ---------------------------------------------------------------- pullovers

ex(name="Dumbbell Pullover", var="dumbbellPullover",
   annotations=[
       ("grip", "Palms under the top plate", "hand_L"),
       ("elbow", "Elbows soft and fixed", "forearm_L"),
       ("arc", "Stop with arms by your ears", "upper_arm_L"),
       ("ribs", "Ribs down, no arch", "spine"),
       ("feet", "Feet planted", "foot_L"),
   ],
   cues={
       "grip": ("Grip",
                "One dumbbell, held from underneath with both hands.",
                "Cupping the top plate with both palms, thumbs around the handle, keeps the dumbbell secure as it passes over the face.",
                "Holding the handle loosely with the wrists bent back.",
                "Hold the dumbbell vertically, both palms flat against the underside of the top plate, thumbs wrapped round the handle."),
       "elbow": ("Elbow Bend",
                 "The elbows set a slight bend and keep it.",
                 "A fixed bend keeps the motion at the shoulder, where the pecs and lats move it; bending and straightening the elbows turns it into a triceps extension.",
                 "Bending the elbows as the dumbbell goes back and straightening them to bring it up.",
                 "Set a slight bend at the elbows over the chest and hold that angle through the whole arc."),
       "arc": ("Range of Motion",
               "The arms sweep back until they line up with the torso.",
               "The stretch overhead is where the pullover loads the pecs and lats most; going past the line of the torso loads the shoulder capsule instead.",
               "Lowering the dumbbell far below the bench, the arms dropping past the head.",
               "Lower until the upper arms are beside the ears, in line with the torso, then pull the dumbbell back over the chest."),
       "ribs": ("Rib Position",
                "The ribs stay down as the arms go back.",
                "Keeping the ribs down and the lower back flat makes the shoulder do the moving, instead of the spine arching to fake more range.",
                "Arching the lower back and flaring the ribs as the dumbbell reaches overhead.",
                "Brace the core, keep the ribs pulled down toward the hips, and stop the arc where the back starts to arch."),
       "feet": FEET_BENCH,
   },
   activation=[("Pectoralis Major", P, HI, 0.82), ("Latissimus Dorsi", S, MOD, 0.55), ("Triceps Brachii", S, MOD, 0.42)],
   stabilisers=["serratus anterior", "teres major", "core"],
   comparison=("RIBS FLARED, BACK ARCHED", "Ribs down, arms to the ears", "Back arches to reach further",
               "With the ribs down and the arc stopped at the ears, the stretch and the pull back over the chest come from the pecs and lats.",
               "Arching the back fakes range with the spine and stretches the shoulder capsule while the chest does less."))

ex(name="Barbell Pullover", var="barbellPullover",
   annotations=[
       ("grip", "Grip about shoulder-width", "hand_L"),
       ("elbow", "Elbows soft and fixed", "forearm_L"),
       ("arc", "Stop with arms by your ears", "upper_arm_L"),
       ("ribs", "Ribs down, no arch", "spine"),
       ("feet", "Feet planted", "foot_L"),
   ],
   cues={
       "grip": ("Grip",
                "A shoulder-width, overhand grip on the bar.",
                "A grip about shoulder-width keeps the elbows from flaring as the bar goes back over the face.",
                "Gripping too wide, which pulls the elbows out and loads the shoulders.",
                "Hold the bar overhand, hands about shoulder-width apart, wrists straight."),
       "elbow": ("Elbow Bend",
                 "The elbows set a slight bend and keep it.",
                 "A fixed bend keeps the work at the shoulder, where the pecs and lats move the bar; bending the elbows turns it into a skull crusher.",
                 "Bending the elbows as the bar goes back and straightening them to bring it up.",
                 "Set a slight bend in the elbows with the bar over the chest and keep that angle through the arc."),
       "arc": ("Range of Motion",
               "The bar sweeps back until the arms line up with the torso.",
               "The overhead stretch is where the pullover loads the pecs and lats most; past the line of the torso the shoulder capsule takes over.",
               "Letting the bar drop far below the bench behind the head.",
               "Lower until the upper arms are beside the ears, then pull the bar back over the chest."),
       "ribs": ("Rib Position",
                "The ribs stay down as the arms go back.",
                "A flat lower back makes the shoulder do the moving instead of the spine arching for extra range.",
                "Arching the lower back and flaring the ribs as the bar goes overhead.",
                "Brace the core, keep the ribs down and stop the arc before the back arches."),
       "feet": FEET_BENCH,
   },
   activation=[("Pectoralis Major", P, HI, 0.80), ("Latissimus Dorsi", S, MOD, 0.58), ("Triceps Brachii", S, MOD, 0.46)],
   stabilisers=["serratus anterior", "teres major", "core"],
   comparison=("RIBS FLARED, BACK ARCHED", "Ribs down, arms to the ears", "Back arches to reach further",
               "With the ribs down and the arc stopped at the ears, the pecs and lats do the stretching and the pulling.",
               "Arching the back fakes range with the spine and stretches the shoulder capsule while the chest does less."))

# ---------------------------------------------------------------- machines

machine("Iso-Lateral Chest Press", "isoLateralChestPress",
        ("Handles at mid-chest", ("Grip and Seat Height",
                                  "The seat sets where the handles meet the chest.",
                                  "Handles level with the mid-chest line the press up with the pecs; too high and the shoulders lift, too low and the elbows drop.",
                                  "Sitting so low that the handles start at the shoulders.",
                                  "Adjust the seat so the handles sit level with the middle of the chest, then grip with the wrists straight.")),
        ("Elbows ~45°", ("Elbow Position",
                         "The elbows travel under the handles, not out to the sides.",
                         "Around 45° from the torso keeps the pecs in their strongest line and the shoulder supported.",
                         "Flaring the elbows up and out to the sides as the handle comes back.",
                         "Keep the elbows about 45° from the torso, in line with the wrists, through the whole press.")),
        ("One arm at a time", ("Press Path",
                                           "Each lever arm moves on its own, so each side has to do its own work.",
                                           "Pressing one arm at a time stops the stronger side from carrying the weaker one and keeps the body still against a one-sided load.",
                                           "Cutting each press short, or twisting the torso toward the working arm.",
                                           "Press one handle out to straight, soft elbows and bring it back under control, holding the other still at the chest, then switch.")),
        ("SHORT, TWISTING REPS", "Full reach, body still", "Half reps, torso turns",
         "A full press with the torso still makes each side of the chest work through its whole range.",
         "Stopping short and twisting toward the pressing arm hands the work to the front delt and the trunk."),
        [("Pectoralis Major", P, HI, 0.88), ("Triceps Brachii", S, MOD, 0.54), ("Anterior Deltoid", S, MOD, 0.48)],
        ("rotator cuff", "obliques"))

machine("Incline Chest Press Machine", "inclineChestPressMachine",
        ("Handles at upper chest", ("Grip and Seat Height",
                                    "The seat sets where the handles meet the chest.",
                                    "Handles level with the upper chest aim the press up and forward along the fibres of the clavicular pec.",
                                    "Sitting so low that the handles start above the shoulders, turning it into a shoulder press.",
                                    "Adjust the seat so the handles line up with the upper chest, just below the collarbones.")),
        ("Elbows ~45–60°", ("Elbow Position",
                            "The elbows stay under the handles.",
                            "Around 45-60° from the torso keeps the upper pecs in line with the press without over-rotating the shoulder.",
                            "Flaring the elbows straight out to the sides.",
                            "Keep the upper arms 45-60° from the torso as the handles come back.")),
        ("Press up and forward", ("Press Path",
                                  "The handles travel up and away on the machine's incline.",
                                  "Pressing all the way to soft elbows works the upper chest through its full range.",
                                  "Short reps that stop halfway, never reaching straight arms.",
                                  "Press up and forward until the arms are straight with soft elbows, then return until the handles are just short of the chest.")),
        ("SEAT TOO LOW", "Handles at the upper chest", "Handles start above the shoulders",
         "With the handles level with the upper chest, the press runs along the clavicular pec fibres.",
         "Too low a seat puts the handles above the shoulders and turns the lift into a shoulder press."),
        [("Upper Pectoralis", P, HI, 0.84), ("Anterior Deltoid", S, MOD, 0.62), ("Triceps Brachii", S, MOD, 0.50)])

machine("Decline Chest Press Machine", "declineChestPressMachine",
        ("Handles at lower chest", ("Grip and Seat Height",
                                    "The handles start in line with the lower chest.",
                                    "Low handles line the press up with the lower (sternocostal) fibres of the pec.",
                                    "Setting the seat so the handles start at the shoulders.",
                                    "Adjust the seat so the handles line up with the lower chest, then grip with the wrists straight.")),
        ("Elbows ~45°", ("Elbow Position",
                         "The elbows track below the shoulders.",
                         "Around 45° keeps the lower pec loaded and the shoulder supported.",
                         "Flaring the elbows up and out as the handles come back.",
                         "Keep the elbows about 45° from the torso and below shoulder height.")),
        ("Press level with lower chest", ("Press Path",
                                          "The handles travel out in line with the lower chest.",
                                          "Pressing to soft elbows along the lower-chest line works the lower fibres through their full range.",
                                          "Short reps that never reach straight arms.",
                                          "Press out until the arms are straight with soft elbows, then return until the handles are just short of the chest.")),
        ("SHORT REPS", "Full press to soft elbows", "Stopping halfway",
         "A full press along the lower-chest line works the lower pec through its whole range.",
         "Half reps keep the load where the lift is easiest and skip the part that builds the most."),
        [("Lower Pectoralis", P, HI, 0.88), ("Triceps Brachii", S, MOD, 0.56), ("Anterior Deltoid", S, LOW, 0.36)])

machine("Plate-Loaded Chest Press", "plateLoadedChestPress",
        ("Handles at mid-chest", ("Grip and Seat Height",
                                  "The seat sets where the handles meet the chest.",
                                  "Handles level with the mid-chest line the press up with the pecs.",
                                  "Sitting too low, so the handles start at the shoulders.",
                                  "Adjust the seat so the handles sit level with the middle of the chest, wrists straight.")),
        ("Elbows ~45°", ("Elbow Position",
                         "The elbows travel under the handles.",
                         "Around 45° from the torso keeps the pecs in their strongest line and the shoulder supported.",
                         "Flaring the elbows up and out to the sides.",
                         "Keep the elbows about 45° from the torso, in line with the wrists.")),
        ("Press to soft elbows", ("Press Path",
                                  "Both lever arms move together along a fixed arc.",
                                  "Pressing to straight arms and returning under control works the pecs through their whole range; plates reward control, not momentum.",
                                  "Letting the plates crash back down between reps, or cutting the press short.",
                                  "Press until the arms are straight with soft elbows, then lower for about two seconds until the handles are just short of the chest.")),
        ("SHORT REPS", "Full press, controlled return", "Stopping halfway",
         "A full press and a controlled return work the pecs through their whole range.",
         "Half reps and dropped plates keep the load where the lift is easiest and skip the stretch."),
        [("Pectoralis Major", P, HI, 0.90), ("Triceps Brachii", S, MOD, 0.56), ("Anterior Deltoid", S, MOD, 0.48)])

machine("Wide-Grip Chest Press Machine", "wideGripChestPressMachine",
        ("Wide grip, wrists straight", ("Grip",
                                        "The outer handles, wider than the shoulders.",
                                        "A wide grip puts the pecs on a longer stretch and shifts some work away from the triceps.",
                                        "Bending the wrists back to hold the wide handles.",
                                        "Take the outer handles with the wrists straight and the knuckles in line with the forearms.")),
        ("Elbows below the shoulders", ("Elbow Position",
                                        "A wide grip still needs the elbows below the shoulders.",
                                        "Keeping the elbows a little below shoulder height protects the front of the shoulder at the stretch.",
                                        "Elbows riding up level with or above the shoulders at the back of the rep.",
                                        "Keep the elbows slightly below the shoulders, and stop the return when the upper arms are level with the torso.")),
        ("Press to soft elbows", ("Press Path",
                                  "The press stops just short of lockout.",
                                  "Stopping with a soft bend keeps tension on the pecs, which a wide grip works hardest in the middle of the range.",
                                  "Short reps that never leave the stretch, or slamming the elbows straight.",
                                  "Press out until the elbows are almost straight, then return under control until the upper arms are level with the torso.")),
        ("ELBOWS ABOVE SHOULDERS", "Elbows below the shoulders", "Elbows ride up at the stretch",
         "With the elbows below shoulder height, the wide grip stretches the pecs without cramming the front of the shoulder.",
         "Elbows level with or above the shoulders at the back of the rep load the shoulder joint instead of the chest."),
        [("Pectoralis Major", P, HI, 0.90), ("Anterior Deltoid", S, MOD, 0.50), ("Triceps Brachii", S, MOD, 0.40)])

# ---------------------------------------------------------------- cables

ex(name="Cable Chest Press", var="cableChestPress",
   annotations=[
       ("wrist", "Handles at chest height", "hand_R"),
       ("elbow", "Elbows ~45°", "forearm_L"),
       ("barpath", "Press forward, hands meet", "hand_L"),
       ("feet", "Staggered stance, knees soft", "foot_L"),
       ("scapula", "No shrugging", "scapula_L"),
   ],
   cues={
       "wrist": ("Handle Height",
                 "The pulleys and hands work at chest height.",
                 "With the cables pulling straight back at chest height, the press lines up with the middle fibres of the pec.",
                 "Pressing with the hands high by the shoulders, which hands the work to the front delts.",
                 "Set the pulleys at chest height and hold the handles beside the chest, wrists straight."),
       "elbow": ("Elbow Position",
                 "The elbows sit about 45° from the torso.",
                 "Around 45° keeps the pecs in their strongest line and the shoulder supported at the start of the press.",
                 "Flaring the elbows up and out to the sides.",
                 "Keep the elbows 45° from the torso and just below the hands as you press."),
       "barpath": ("Press Path",
                   "The hands press forward and come together in front of the chest.",
                   "Cables keep tension on the pecs all the way to the finish, where the hands meet and the chest squeezes.",
                   "Short presses that stop halfway, never reaching straight arms.",
                   "Press forward until the arms are straight and the hands meet in front of the sternum, then return under control."),
       "feet": FEET_STAND,
       "scapula": SCAP_STAND,
   },
   activation=[("Pectoralis Major", P, HI, 0.82), ("Anterior Deltoid", S, MOD, 0.54), ("Triceps Brachii", S, MOD, 0.48)],
   stabilisers=["core", "serratus anterior", "rotator cuff"],
   comparison=("SHORT REPS", "Hands meet, arms straight", "Stopping halfway",
               "Pressing until the hands meet keeps the cables loading the pecs to the very end of the rep.",
               "Half reps skip the finish, where cables load the chest better than free weights can."))

ex(name="Single-Arm Cable Chest Press", var="singleArmCableChestPress",
   annotations=[
       ("wrist", "Handle at chest height", "hand_L"),
       ("elbow", "Elbow ~45°", "forearm_L"),
       ("core", "Hips and shoulders square", "chest"),
       ("feet", "Staggered stance", "foot_L"),
       ("scapula", "Shoulder down and back", "scapula_L"),
   ],
   cues={
       "wrist": ("Handle Height",
                 "The cable pulls straight back at chest height.",
                 "A handle level with the chest lines the press up with the middle fibres of the pec.",
                 "Pressing from up by the shoulder, which makes the front delt do the work.",
                 "Set the pulley at chest height and hold the handle beside the chest, wrist straight."),
       "elbow": ("Elbow Position",
                 "One elbow, the same line as a two-handed press.",
                 "About 45° from the torso keeps the pec in its strongest line and the shoulder supported.",
                 "Letting the elbow flare out to the side.",
                 "Keep the working elbow 45° from the torso and just below the hand."),
       "core": ("Anti-Rotation",
                "The cable pulls one side of the body back; the trunk refuses to turn.",
                "In a standing one-arm press, balance and the trunk's resistance to rotation limit the load more than the chest does, so holding square is half the exercise.",
                "Twisting the torso to push, the working shoulder reaching forward past the other.",
                "Brace the core and keep both hips and both shoulders facing forward as you press and return."),
       "feet": ("Stance",
                "A staggered stance braces the body against the cable.",
                "One foot ahead of the other gives the trunk a base to resist the pull and rotation.",
                "Standing square with locked knees, so the cable pulls the body back and round.",
                "Stand with one foot a step ahead of the other, knees soft, torso tilted slightly forward."),
       "scapula": ("Scapular Position",
                   "The working shoulder stays set.",
                   "Keeping the shoulder blade down and back stops the front delt and upper trap from taking over at the end of the press.",
                   "The working shoulder shrugging up or rolling forward at full reach.",
                   "Draw the shoulder down and back before the rep and keep it there as the arm straightens."),
   },
   activation=[("Pectoralis Major", P, HI, 0.78), ("Anterior Deltoid", S, MOD, 0.52), ("Triceps Brachii", S, MOD, 0.46), ("Obliques", S, MOD, 0.40)],
   stabilisers=["transversus abdominis", "rotator cuff", "serratus anterior"],
   comparison=("TORSO TWISTING", "Hips and shoulders square", "Torso turns to push",
               "Holding the torso square makes the chest press the cable while the trunk resists the twist.",
               "Rotating to push shortens the press and swaps chest work for momentum from the trunk."))

ex(name="Incline Cable Press", var="inclineCablePress",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45–60°", "forearm_R"),
       ("barpath", "Hands meet over upper chest", "support_PectoralisMajor_Clavicular_L"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": ("Wrist Stacking",
                 "Each handle sits over its forearm.",
                 "A straight wrist sends the cable's pull straight down the arm.",
                 "The wrists bending back as the cables pull the handles down.",
                 "Keep the wrists straight, knuckles up, handle in the heel of the palm."),
       "elbow": ("Elbow Angle",
                 "The elbows sit about 45-60° from the torso.",
                 "That angle keeps the clavicular pec in its strongest line on the incline without over-rotating the shoulder.",
                 "Flaring the elbows out to 90°, handing the press to the front delts.",
                 "Keep the upper arms 45-60° from the torso as the handles come down beside the chest."),
       "barpath": ("Press Path",
                   "The hands press up and meet over the upper chest.",
                   "Low pulleys pull down and out, so bringing the hands together at the top keeps the upper pecs loaded right to the finish.",
                   "Pressing toward the face instead of over the upper chest.",
                   "Press up from the sides of the upper chest until the hands meet above the collarbones."),
       "feet": FEET_BENCH,
       "scapula": SCAP_BENCH,
   },
   activation=[("Upper Pectoralis", P, HI, 0.82), ("Anterior Deltoid", S, MOD, 0.58), ("Triceps Brachii", S, MOD, 0.46)],
   stabilisers=["rotator cuff", "serratus anterior"],
   comparison=("PRESSING TOWARD THE FACE", "Hands meet over the upper chest", "Handles drift toward the face",
               "Pressing up over the upper chest keeps the clavicular pec working in line with the cables.",
               "Drifting toward the face turns the press into a shoulder press and loads the front delts."),
   head="Clavicular")

ex(name="Decline Cable Press", var="declineCablePress",
   annotations=[
       ("wrist", "Keep wrists stacked", "hand_L"),
       ("elbow", "Elbows ~45°", "forearm_L"),
       ("barpath", "Hands meet over lower chest", "support_PectoralisMajor_Abdominal_L"),
       ("feet", "Legs hooked in", "foot_L"),
       ("scapula", "Retract scapula", "scapula_L"),
   ],
   cues={
       "wrist": ("Wrist Stacking",
                 "Each handle sits over its forearm.",
                 "A straight wrist sends the cable's pull straight down the arm.",
                 "The wrists bending back under the cables.",
                 "Keep the wrists straight, knuckles up, handle in the heel of the palm."),
       "elbow": ("Elbow Angle",
                 "The elbows stay about 45° from the torso.",
                 "That angle keeps the lower pec loaded and the shoulder out of wide abduction.",
                 "Flaring the elbows out to 90°.",
                 "Keep the upper arms about 45° from the torso as the handles come back."),
       "barpath": ("Press Path",
                   "The hands press up and meet over the lower chest.",
                   "On a decline the press runs along the lower pec fibres; meeting the hands at the top keeps them working to the finish.",
                   "Pressing toward the face, which loses the decline's angle.",
                   "Press up from the sides of the lower chest until the hands meet over the bottom of the breastbone."),
       "feet": FEET_DECLINE,
       "scapula": ("Scapular Position",
                   "Head-down, the upper back tends to lift.",
                   "Pinned shoulder blades keep the shoulders stable as the cables pull the arms toward the floor.",
                   "Shoulders rolling up off the bench at the bottom.",
                   "Pull the shoulder blades back and down before the first rep and keep them there."),
   },
   activation=[("Lower Pectoralis", P, HI, 0.86), ("Triceps Brachii", S, MOD, 0.52), ("Anterior Deltoid", S, LOW, 0.34)],
   stabilisers=["latissimus dorsi", "rotator cuff", "core"],
   comparison=("LEGS SLIPPING OUT", "Legs hooked, body still", "Feet slip, hips slide up",
               "With the legs hooked under the roller, the body stays put and the lower pec does the pressing.",
               "When the feet slip, the hips slide up the bench and the decline angle and the lower-chest bias go with them."),
   head="Abdominal")

ex(name="High-to-Low Cable Fly", var="highToLowCableFly",
   # Head-on: the arms sweep across the chest row, so the labels sit above
   # the head and beside the legs.
   overrides={"wrist": (0.14, "trailing"), "scapula": (0.14, "leading"), "barpath": (0.50, "leading"),
              "elbow": (0.50, "trailing"), "feet": (0.86, "trailing")},
   annotations=[
       ("wrist", "Hands meet at lower chest", "hand_L"),
       ("elbow", "Soft, fixed elbows", "forearm_L"),
       ("barpath", "Sweep down and in", "hand_R"),
       ("feet", "Staggered stance", "foot_L"),
       ("scapula", "Chest up, shoulders back", "scapula_R"),
   ],
   cues={
       "wrist": ("Hand Path",
                 "The hands finish together in front of the lower chest.",
                 "High pulleys pull up and out, so bringing the hands down and in lines the fly up with the lower (sternocostal) fibres of the pec.",
                 "Pulling the hands right down to the hips, which hands the finish to the lats and triceps.",
                 "Sweep the hands down and together until they meet in front of the lower chest, about navel-to-sternum height."),
       "elbow": ELBOW_FLY,
       "barpath": ("Fly Arc",
                   "A wide arc, from high and wide to low and together.",
                   "Keeping the arms long through a wide arc keeps the load on the pecs; bringing the elbows in turns it into a press.",
                   "Tucking the elbows into the sides and pushing the handles down.",
                   "Open the arms wide at the top, then sweep them down and in on a wide arc, arms long."),
       "feet": FEET_STAND,
       "scapula": SCAP_STAND,
   },
   activation=[("Lower Pectoralis", P, HI, 0.84), ("Anterior Deltoid", S, LOW, 0.34), ("Latissimus Dorsi", S, LOW, 0.28)],
   stabilisers=["core", "serratus anterior", "biceps brachii"],
   comparison=("PRESSING, NOT FLYING", "Wide arc, fixed elbows", "Elbows tuck and push",
               "A wide arc with a fixed elbow bend keeps the whole rep on the lower pecs.",
               "Tucking the elbows and pushing down turns the fly into a press and hands much of it to the triceps."),
   head="Abdominal")

ex(name="Single-Arm Cable Fly", var="singleArmCableFly",
   # The lifter stands left of centre with the stack on the right; the
   # labels use the open space above the head and on the stack's side.
   overrides={"scapula": (0.14, "leading"), "elbow": (0.14, "trailing"), "wrist": (0.32, "trailing"),
              "core": (0.55, "trailing"), "feet": (0.86, "trailing")},
   annotations=[
       ("wrist", "Hand to mid-chest", "hand_L"),
       ("elbow", "Elbow fixed, slight bend", "forearm_L"),
       ("core", "Hips and shoulders square", "chest"),
       ("feet", "Staggered stance", "foot_L"),
       ("scapula", "Shoulder down and back", "scapula_R"),
   ],
   cues={
       "wrist": ("Hand Path",
                 "The hand finishes in front of the middle of the chest.",
                 "Bringing the hand to the midline shortens the pec fully, which is where one-arm cable work outdoes dumbbells.",
                 "Pulling the hand far across the body, past the other shoulder, with the torso turning.",
                 "Sweep the hand in at chest height until it is in front of the sternum, then open back out under control."),
       "elbow": ("Elbow Bend",
                 "A fly is a hug, not a press.",
                 "A fixed, slight elbow bend keeps the load on the pec through the whole arc and off the elbow.",
                 "Bending the elbow as the hand comes in, which turns the fly into a press.",
                 "Set a soft bend at the elbow, about 15-20°, and keep that exact angle for the whole rep."),
       "core": ("Anti-Rotation",
                "The cable pulls the working side open; the trunk stays square.",
                "Keeping the hips and shoulders facing forward makes the pec, not a twist of the torso, bring the hand in.",
                "Rotating the torso to swing the hand across.",
                "Brace the core and keep both shoulders square to the front as the arm sweeps in and out."),
       "feet": ("Stance",
                "A staggered stance keeps the body still.",
                "One foot ahead of the other braces against the cable's sideways pull.",
                "Standing square with locked knees, so the cable pulls the body toward the stack.",
                "Stand side-on to the stack, one foot a step ahead of the other, knees soft."),
       "scapula": ("Scapular Position",
                   "The working shoulder stays back and down.",
                   "A set shoulder blade keeps the front delt from taking over at the stretch.",
                   "The shoulder rolling forward as the hand crosses in front.",
                   "Draw the working shoulder back and down before the rep and hold it there."),
   },
   activation=[("Pectoralis Major", P, HI, 0.80), ("Anterior Deltoid", S, MOD, 0.40), ("Obliques", S, LOW, 0.28)],
   stabilisers=["core", "biceps brachii", "rotator cuff"],
   comparison=("TORSO TWISTING", "Square torso, hand to midline", "Torso turns to pull across",
               "With the torso square, the pec alone brings the hand to the middle of the chest.",
               "Turning the torso swings the hand across with momentum and takes the squeeze away from the pec."))

ex(name="Incline Cable Fly", var="inclineCableFly",
   annotations=[
       ("wrist", "Hands meet over upper chest", "hand_L"),
       ("elbow", "Fixed ~15–20° bend", "forearm_R"),
       ("barpath", "Arc stops at chest level", "support_PectoralisMajor_Clavicular_L"),
       ("feet", "Feet planted", "foot_L"),
       ("scapula", "Shoulder blades set", "scapula_L"),
   ],
   cues={
       "wrist": ("Hand Path",
                 "The hands meet over the upper chest.",
                 "Low pulleys pull down and out, so on a 30° bench the hands meeting over the collarbones line up with the upper pec fibres.",
                 "Stopping with the hands still well apart.",
                 "Bring the handles together until they touch over the upper chest, palms facing in."),
       "elbow": ELBOW_FLY,
       "barpath": ("Fly Arc",
                   "The arc opens wide and stops level with the chest.",
                   "Stopping at chest level stretches the upper pecs without cranking the shoulder past its safe range.",
                   "Letting the cables pull the arms down past the bench at the bottom.",
                   "Open the arms until the hands are about level with the chest, then sweep them back up and together."),
       "feet": FEET_BENCH,
       "scapula": ("Scapular Position",
                   "The shoulder blades stay pinned to the bench.",
                   "Retracted scapulae keep the stretch in the pecs rather than the front of the shoulder.",
                   "Shoulders lifting off the bench as the hands come together.",
                   "Pull the shoulder blades back and down and keep them on the bench through the arc."),
   },
   activation=[("Upper Pectoralis", P, HI, 0.82), ("Anterior Deltoid", S, MOD, 0.46), ("Biceps Brachii", S, LOW, 0.24)],
   stabilisers=["rotator cuff", "serratus anterior"],
   comparison=("ARMS PAST CHEST LEVEL", "Arc stops level with the chest", "Arms dropped past the bench",
               "Stopping the arc at chest level stretches the upper pecs and keeps the shoulder in a safe range.",
               "Letting the cables drag the arms past the bench overstretches the front of the shoulder while the pec slackens."),
   head="Clavicular")

ex(name="Decline Cable Fly", var="declineCableFly",
   annotations=[
       ("wrist", "Hands meet over lower chest", "hand_L"),
       ("elbow", "Fixed ~15–20° bend", "forearm_L"),
       ("barpath", "Arc stops at chest level", "support_PectoralisMajor_Abdominal_L"),
       ("feet", "Legs hooked in", "foot_L"),
       ("scapula", "Shoulder blades set", "scapula_L"),
   ],
   cues={
       "wrist": ("Hand Path",
                 "The hands meet over the lower chest.",
                 "On a decline, bringing the handles together over the bottom of the breastbone lines the fly up with the lower pec fibres.",
                 "Stopping with the hands still well apart.",
                 "Bring the handles together until they touch over the lower chest, palms facing in."),
       "elbow": ELBOW_FLY,
       "barpath": ("Fly Arc",
                   "The arc opens wide and stops level with the chest.",
                   "Stopping at chest level stretches the lower pecs without forcing the shoulder past its safe range.",
                   "Letting the cables pull the arms down past the bench.",
                   "Open the arms until the hands are level with the chest, then sweep them back up and together."),
       "feet": FEET_DECLINE,
       "scapula": ("Scapular Position",
                   "Head-down, the shoulders tend to lift.",
                   "Pinned shoulder blades keep the stretch in the pecs rather than the front of the shoulder.",
                   "Shoulders rolling up off the bench as the hands come together.",
                   "Pull the shoulder blades back and down and keep them on the bench through the arc."),
   },
   activation=[("Lower Pectoralis", P, HI, 0.84), ("Anterior Deltoid", S, LOW, 0.34), ("Biceps Brachii", S, LOW, 0.24)],
   stabilisers=["rotator cuff", "latissimus dorsi", "core"],
   comparison=("ARMS PAST CHEST LEVEL", "Arc stops level with the chest", "Arms dropped past the bench",
               "Stopping at chest level stretches the lower pecs and keeps the shoulder in a safe range.",
               "Letting the cables drag the arms past the bench overstretches the shoulder while the pec slackens."),
   head="Abdominal")

ex(name="Cable Crossover", var="cableCrossover",
   # Laid out like the high-to-low fly: above the head and beside the legs.
   overrides={"wrist": (0.14, "trailing"), "scapula": (0.14, "leading"), "barpath": (0.50, "leading"),
              "elbow": (0.50, "trailing"), "feet": (0.86, "trailing")},
   annotations=[
       ("wrist", "Hands cross at the finish", "hand_L"),
       ("elbow", "Soft, fixed elbows", "forearm_L"),
       ("barpath", "Wide arc, arms long", "hand_R"),
       ("feet", "Staggered stance", "foot_L"),
       ("scapula", "Chest up, shoulders back", "scapula_R"),
   ],
   cues={
       "wrist": ("The Crossover",
                 "The hands pass each other at the finish.",
                 "Crossing the hands past the midline shortens the pecs further than a fly that stops with the hands touching, adding a harder squeeze at the end.",
                 "Stopping short with the hands apart, or crossing them high in front of the face.",
                 "Bring the hands together at chest height and let one pass over the other by a hand's width; switch which hand goes on top each set."),
       "elbow": ELBOW_FLY,
       "barpath": ("Fly Arc",
                   "A wide arc from the stacks to the midline.",
                   "Arms kept long on a wide arc keep the load on the pecs; bending the elbows in turns it into a press.",
                   "Pulling the handles in close to the body and pressing them forward.",
                   "Open the arms wide toward the stacks, then sweep them in on a wide arc at chest height."),
       "feet": FEET_STAND,
       "scapula": SCAP_STAND,
   },
   activation=[("Pectoralis Major", P, HI, 0.86), ("Anterior Deltoid", S, MOD, 0.40), ("Biceps Brachii", S, LOW, 0.24)],
   stabilisers=["core", "serratus anterior", "rotator cuff"],
   comparison=("HANDS MEET TOO HIGH", "Hands cross at chest height", "Hands meet at the face",
               "Crossing at chest height keeps the pecs pulling in line with their fibres to the end of the rep.",
               "Finishing high in front of the face hands the finish to the front delts."))

# ---------------------------------------------------------------- landmine and push-up

ex(name="Single-Arm Landmine Press", var="singleArmLandminePress",
   overrides={"grip": (0.14, "trailing"), "barpath": (0.14, "leading"), "elbow": (0.32, "leading"),
              "core": (0.50, "leading"), "feet": (0.86, "leading")},
   annotations=[
       ("grip", "Bar end in the palm", "hand_L"),
       ("elbow", "Elbow starts tucked", "forearm_L"),
       ("barpath", "Press up and forward", "support_PectoralisMajor_Clavicular_L"),
       ("core", "Ribs down, no lean back", "spine"),
       ("feet", "Staggered stance", "foot_R"),
   ],
   cues={
       "grip": ("Grip",
                "The end of the bar sits in the palm.",
                "Holding the sleeve in the heel of the hand with the wrist straight sends the press straight up the forearm.",
                "Holding the bar in the fingers with the wrist bent back.",
                "Wrap the hand around the end of the bar, wrist straight, and start it at the front of the shoulder."),
       "elbow": ("Elbow Position",
                 "The elbow starts in front of the body, not out to the side.",
                 "A tucked elbow sets up the upward-and-forward angle that makes the landmine easy on the shoulder and puts the upper chest to work.",
                 "Starting with the elbow flared out to the side.",
                 "Start with the elbow in front of the ribs, about 45° from the torso, forearm under the bar."),
       "barpath": ("Press Path",
                   "The bar travels up and forward along its arc.",
                   "The landmine's angled path sits between a bench press and an overhead press, working the upper chest and front delt with the shoulder in a comfortable range.",
                   "Stopping short with the arm still bent, or pushing the bar across the body.",
                   "Press up and forward until the arm is straight and the hand is in front of the shoulder, then lower back under control."),
       "core": ("Trunk Position",
                "The body stays tall; only the arm moves.",
                "A braced trunk stops the one-sided load from bending you back or twisting you round.",
                "Leaning back to push the bar up, which turns it into a standing incline press off the lower back.",
                "Brace the core, keep the ribs down over the hips and squeeze the glutes before each press."),
       "feet": ("Stance",
                "A staggered stance under a one-sided load.",
                "One foot ahead of the other gives the trunk a stable base to press against.",
                "Standing square with locked knees, so the body sways with every press.",
                "Stand with one foot a step ahead of the other, knees soft, weight through both feet."),
   },
   activation=[("Upper Pectoralis", P, HI, 0.78), ("Anterior Deltoid", S, HI, 0.68), ("Triceps Brachii", S, MOD, 0.50), ("Obliques", S, LOW, 0.30)],
   stabilisers=["serratus anterior", "rotator cuff", "glutes"],
   comparison=("LEANING BACK", "Tall and braced", "Leaning back to press",
               "Standing tall keeps the press up and forward along the bar's arc, where the upper chest and front delt drive it.",
               "Leaning back turns the lift into a lower-back-assisted press and takes the upper chest out of it."),
   head="Clavicular")

ex(name="Incline Push-Up", var="inclinePushUp", slots=FLAT,
   annotations=[
       ("body", "Body in one straight line", "pelvis"),
       ("hands", "Hands under the shoulders", "hand_L"),
       ("elbow", "Elbows ~45° from the body", "forearm_L"),
       ("depth", "Chest to the bench edge", "support_PectoralisMajor_Sternal_L"),
       ("feet", "Feet together, toes tucked", "foot_L"),
   ],
   cues={
       "body": ("Body Line",
                "Head to heels stays one straight plank.",
                "A braced trunk lets the chest and arms do the pressing; the raised hands make this easier, not looser.",
                "Hips sagging toward the floor or piking up as the reps get hard.",
                "Squeeze the glutes and brace the core so the head, hips and heels stay in one line from the bottom to the top."),
       "hands": ("Hand Position",
                 "The hands sit on the bench edge under the shoulders.",
                 "Hands under or just outside the shoulders keep the forearms vertical at the bottom, where the push starts.",
                 "Hands placed forward, level with the head, which loads the shoulders.",
                 "Place the hands on the edge of the bench a little wider than the shoulders, directly under them at the bottom."),
       "elbow": ("Elbow Angle",
                 "The elbows point back, not out.",
                 "About 45° from the body keeps the pecs in their strongest line and the shoulder supported.",
                 "Flaring the elbows straight out to the sides, making a T with the body.",
                 "Lower with the elbows about 45° from the ribs, forearms vertical."),
       "depth": ("Depth",
                 "Every rep goes all the way down.",
                 "Lowering until the chest nearly touches the bench works the pecs through their full stretch; with the hands raised, a full rep is within reach from the first set.",
                 "Short reps that stop with the elbows barely bent.",
                 "Lower until the chest is a fist's height from the bench edge, then press back to straight arms."),
       "feet": ("Base",
                "The feet are the other end of the plank.",
                "Feet together on the toes keep the body line fixed; the higher the bench, the lighter the push (about 41% of body mass with the hands on a 60 cm box, against about 64% on the floor).",
                "Feet sliding back or wide, so the body line and the angle keep changing.",
                "Tuck the toes, keep the feet together, and move the feet back or the hands lower as the exercise gets easy."),
   },
   activation=[("Pectoralis Major", P, HI, 0.76), ("Triceps Brachii", S, MOD, 0.54), ("Anterior Deltoid", S, MOD, 0.42)],
   stabilisers=["serratus anterior", "core", "glutes"],
   comparison=("HIPS SAGGING", "Straight line, head to heels", "Hips drop toward the floor",
               "A straight, braced body lets the chest and triceps lift it, and makes the step to floor push-ups a short one.",
               "Sagging hips load the lower back and shorten the chest's share of every rep."))
