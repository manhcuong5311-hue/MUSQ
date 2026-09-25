# Trainer content for batch 161-190 (2026-09-25): the HIKSEMI drive's
# "160-190" folder (160 came with the previous batch), converted from
# SourceExports/160-190. All back lifts. Same format as spec.py; generate
# with `spec` swapped for this module (see README).
#
# What each model shows, from the rig (joint angles sampled across the clip):
# - Pull-ups and chin-ups hang from a bar on two stands, knees slightly bent,
#   ankles together. Wide-Grip ~0.8 m between the hands; Neutral-Grip and
#   Neutral-Grip Chin-Up on parallel handles (~0.57 m and ~0.45 m); Archer
#   ~1.15 m, pulling toward one hand at a time; Weighted Pull-Up and Chin-Up
#   with a plate on a dip belt; Assisted Pull-Up kneeling on the machine's
#   pad; Machine Pull-Up standing on its platform.
# - Pulldowns are seated with the thighs under pads, torso ~8-10° back from
#   upright: wide overhand bar (~0.8 m), underhand bar (~0.4 m), neutral bar
#   (~0.58 m), V-bar, a single D-handle in the LEFT hand, a rope; the
#   kneeling pulldown kneels upright on a mat; the machine and iso-lateral
#   pulldowns use lever arms, the iso-lateral one arm at a time.
# - Seated cable rows sit on a bench with the feet on a footplate, knees soft:
#   wide bar, close V-handle, single handle (LEFT), a high pulley pulled to
#   the face and a floor pulley pulled to the stomach. Standing: staggered
#   stance, both hands. Half-kneeling: right knee down, LEFT arm rows.
# - Machine rows sit with the chest on a pad; the iso-lateral machine
#   alternates arms; the single-arm machine rows with the LEFT hand while the
#   right holds a support handle.
# - Reverse-Grip T-Bar Row: landmine with an underhand handle, torso ~35°.
# - Dumbbell Pullover Row: lying along a bench, a dumbbell in each hand, arms
#   nearly straight, sweeping from overhead to over the chest.
# - Machine Pullover: seated, upper arms on the lever's pads, elbows at 90°,
#   sweeping from overhead down to the sides.
#
# Every framing has a negative yaw and most are from behind-left, so the
# lifter's LEFT side is on the left of the frame.
#
# Sources:
# - Youdas JW et al. 2010, J Strength Cond Res 24(12):3404-3414 — pull-up,
#   chin-up and rotational pull-up: latissimus similar across grips; the
#   chin-up raises biceps and pectoralis activity.
# - Andersen V et al. 2014, J Strength Cond Res 28(4):1135-1142 — lat
#   pulldown grip widths: similar latissimus activity, narrow grips allowing
#   slightly more load.
# - Lusk SJ et al. 2010, J Strength Cond Res 24(7):1895-1900 — pulldown grip
#   width and forearm orientation: wide pronated grip favours the latissimus
#   over a supinated grip.
# - Snyder BJ, Leech JR 2009, J Strength Cond Res 23(8):2204-2209 — voluntary
#   scapular depression and retraction before the pull raises latissimus
#   activity in the pulldown.
# - Lehman GJ et al. 2004, Dyn Med 3:4 — row variations: mid-back and lat
#   activity with grip and elbow path.
# - Fenwick CMJ, Brown SHM, McGill SM 2009, J Strength Cond Res 23(2):350-358
#   — standing one-arm cable rows load the trunk rotators; supported rows
#   spare the lower back.
# - Marchetti PH, Uchida MC 2011, J Appl Biomech 27(4):380-384 — pullovers
#   work the pectoralis and latissimus.
# - ExRx.net, ACE and NASM technique guidance (full hang, scapular
#   depression first, elbows to the ribs, no kipping, torso still in rows).

import json, os

P, S = "primary", "secondary"
HI, MOD, LOW = "HIGH ACTIVATION", "MODERATE ACTIVATION", "LOW ACTIVATION"
A, SOFT = "activation", "activationSoft"

J = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "joints.json")))

def mean(name, joints):
    pts = [p for j in joints for p in J[name][j]]
    return sum(u for u, _ in pts) / len(pts), sum(v for _, v in pts) / len(pts)

def glows(name):
    cx, cy = mean(name, ["support_LatissimusDorsi_L", "support_LatissimusDorsi_R"])
    dx, dy = mean(name, ["scapula_L", "scapula_R"])
    tx, ty = mean(name, ["upper_arm_L", "forearm_L"])
    return [(A, 0.58, 0.14, 0.09, cx, cy), (SOFT, 0.32, 0.09, 0.07, dx, dy), (SOFT, 0.28, 0.07, 0.06, tx, ty)]

SPEC = []

def ex(**kw):
    kw.setdefault("group", "back")
    kw["glows"] = glows(kw["name"])
    SPEC.append(kw)

# ---------------------------------------------------------------- shared cues

SCAP_HANG = ("Scapular Position",
             "Each rep starts by pulling the shoulders down, not by bending the arms.",
             "Depressing and retracting the shoulder blades first sets the lats to pull and keeps the shoulders out of a passive, hanging position.",
             "Shrugging the shoulders up toward the ears as the pull starts.",
             "From a dead hang, draw the shoulder blades down and back, then pull.")
ELBOW_HANG = ("Elbow Path",
              "The elbows drive down toward the ribs.",
              "Pulling the elbows down and back lines the pull up with the lats instead of the biceps.",
              "Letting the elbows drift forward in front of the body and curling up.",
              "Think of pulling the elbows into the back pockets, down and slightly back.")
RANGE_HANG = ("Range of Motion",
              "Every rep goes from a full hang to the chin over the bar.",
              "The full range stretches the lats at the bottom and finishes them at the top; half reps skip both.",
              "Short reps, or craning the neck to get the chin over.",
              "Lower to straight arms each rep, then pull until the chin clears the bar with the neck neutral.")
BODY_HANG = ("Body Control",
             "The legs stay quiet; the back does the lifting.",
             "A still, braced body means every centimetre is pulled by the lats, not thrown by the hips.",
             "Kipping or swinging the legs to get over the bar.",
             "Keep the legs together, knees slightly bent, glutes and core tight, and control the swing between reps.")
SPINE_PD = ("Torso Position",
            "A small, fixed lean back.",
            "About 10-15° of lean lets the bar clear the face and come to the upper chest, with the lats pulling straight down.",
            "Rocking back further on every rep to swing the weight down.",
            "Sit tall, lean back slightly from the hips, and hold that angle for the set.")
ELBOW_PD = ("Elbow Path",
            "The elbows drive down to the ribs.",
            "Pulling the elbows down toward the sides keeps the lats doing the work.",
            "Flaring the elbows out and forward so the biceps and rear delts take over.",
            "Pull the elbows down and slightly back, finishing beside the ribs.")
BARPATH_PD = ("Bar Path",
              "The bar comes down in front of the face to the upper chest.",
              "Pulling to the front of the body keeps the shoulders in a safe position and the lats in their line of pull.",
              "Pulling the bar down behind the neck.",
              "Pull the bar to the top of the chest, then let it rise under control to straight arms.")
FEET_PD = ("Base Position",
           "The thigh pads hold you on the seat.",
           "Snug pads stop the body lifting off the seat, so the lats can pull heavier weight all the way down.",
           "Thighs lifting off the seat as the weight gets heavy.",
           "Set the pads snug on the thighs, feet flat, and stay seated for every rep.")
SCAP_ROW = ("Scapular Position",
            "Each rep starts with a reach and ends with a squeeze.",
            "Letting the shoulder blades move forward at the stretch and pulling them together at the finish works the mid-back through its range.",
            "Shoulders staying rounded forward, so only the arms move the handle.",
            "Let the shoulders reach toward the stack, then pull the shoulder blades back and together as you row.")
ELBOW_ROW = ("Elbow Path",
             "The elbows lead the row.",
             "Driving the elbows back past the torso lines the pull up with the lats and mid-back.",
             "Winging the elbows out to the sides, or curling the handle in with the elbows staying forward.",
             "Pull the elbows back past the torso, close to the sides, and pause.")
TORSO_ROW = ("Torso Position",
             "The torso stays still and upright.",
             "A still torso keeps the back muscles moving the weight; rocking turns the row into a swing that loads the lower back.",
             "Leaning far back at the finish to swing the handle in.",
             "Sit or stand tall with a slight forward lean at the stretch, and keep the torso still as the arms pull.")
BRACE = ("Anti-Rotation",
         "The trunk stays square while one arm works.",
         "Holding the shoulders level and the hips square makes the lat pull the handle instead of a twist of the trunk.",
         "Twisting the torso open to heave the handle back.",
         "Brace the core and keep both shoulders facing forward as the arm pulls and returns.")

# ---------------------------------------------------------------- pull-ups and chin-ups

def pullup(name, var, grip, comp, activation, body=None, diff_cue=None, overrides=None):
    kw = dict(name=name, var=var,
              annotations=[
                  ("scapula", "Shoulders down first", "scapula_R"),
                  ("elbow", "Elbows to the ribs", "forearm_L"),
                  ("grip", grip[0], "hand_L"),
                  ("barpath", "Chin over the bar", "head"),
                  ("feet", (body or ("Legs still, no swing", BODY_HANG))[0], "foot_L"),
              ],
              cues={"scapula": SCAP_HANG, "elbow": ELBOW_HANG, "grip": grip[1],
                    "barpath": diff_cue or RANGE_HANG, "feet": (body or ("", BODY_HANG))[1]},
              activation=activation, stabilisers=["lower trapezius", "forearms", "core"], comparison=comp)
    if overrides: kw["overrides"] = overrides
    ex(**kw)

KIP = ("KIPPING SWING", "Dead hang, strict pull", "Legs swing to get up",
       "A still body makes the lats lift the whole body from a full hang.",
       "Swinging the legs throws the body up with the hips and skips the part of the rep that builds the back.")

pullup("Wide-Grip Pull-Up", "wideGripPullUp",
       ("Wide overhand grip", ("Grip",
                               "Overhand, about one and a half shoulder-widths.",
                               "A wide grip shortens the pull and puts more of it on the upper lats and teres major.",
                               "Gripping so wide the elbows can barely bend, which strains the shoulders.",
                               "Grip overhand, hands about one and a half shoulder-widths apart, thumbs around the bar.")),
       KIP, [("Latissimus Dorsi", P, HI, 0.90), ("Teres Major", S, MOD, 0.60), ("Biceps Brachii", S, MOD, 0.48)])

pullup("Neutral-Grip Pull-Up", "neutralGripPullUp",
       ("Palms facing each other", ("Grip",
                                    "Palms face each other on the parallel handles.",
                                    "A neutral grip is easy on the shoulders and elbows and brings in the brachialis and brachioradialis.",
                                    "Hanging from the fingers with the wrists bent back.",
                                    "Grip the parallel handles deep in the palms, thumbs around, wrists straight.")),
       KIP, [("Latissimus Dorsi", P, HI, 0.86), ("Biceps Brachii", S, MOD, 0.60), ("Brachialis", S, MOD, 0.52)])

pullup("Archer Pull-Up", "archerPullUp",
       ("Very wide grip", ("Grip",
                           "A very wide overhand grip.",
                           "The width lets the body travel toward one hand while the other arm straightens along the bar.",
                           "A grip too narrow to shift over, so it becomes a normal pull-up.",
                           "Grip overhand about twice shoulder-width, thumbs around the bar.")),
       ("SWINGING TO ONE SIDE", "Strict pull to one hand", "Body swings across",
        "Pulling straight up toward one hand makes that side's lat lift most of the body.",
        "Swinging across uses momentum and hands the work back to both arms equally."),
       [("Latissimus Dorsi", P, HI, 0.92), ("Biceps Brachii", S, MOD, 0.58), ("Teres Major", S, MOD, 0.56)],
       diff_cue=("Range of Motion",
                 "Pull toward one hand, the other arm straightening.",
                 "Moving the chin to one hand puts most of the load on that side, a step toward one-arm pull-ups.",
                 "Stopping short, the chin well below the working hand.",
                 "Pull the chin toward one hand while the other arm slides out straight, lower to the middle, then switch."))

pullup("Weighted Pull-Up", "weightedPullUp",
       ("Overhand, shoulder-width", ("Grip",
                                     "Overhand, a little wider than the shoulders.",
                                     "A moderate grip lets you pull the most weight through a full range.",
                                     "Gripping too wide to handle the added load.",
                                     "Grip overhand just outside shoulder-width, thumbs around the bar.")),
       ("WEIGHT SWINGING", "Still body, strict pull", "Plate swings the body",
        "Keeping the plate still makes the lats pull the added load.",
        "A swinging plate turns each rep into a kip and loads the lower back through the belt."),
       [("Latissimus Dorsi", P, HI, 0.92), ("Biceps Brachii", S, MOD, 0.60), ("Middle Trapezius", S, MOD, 0.52)],
       body=("Plate hangs still", ("Body Control",
                                   "The added weight hangs still between the legs.",
                                   "A still plate means the load goes straight to the lats; a swinging one tugs the hips and back.",
                                   "Letting the plate swing forward and back between reps.",
                                   "Set the belt low on the hips, keep the legs together and control the plate at the bottom of every rep.")))

pullup("Assisted Pull-Up", "assistedPullUp",
       ("Overhand, shoulder-width", ("Grip",
                                     "Overhand, a little wider than the shoulders.",
                                     "The same grip as the unassisted pull-up, so the strength carries over.",
                                     "Gripping narrow and curling the body up with the arms.",
                                     "Grip overhand just outside shoulder-width, thumbs around the bar.")),
       ("PUSHING OFF THE PAD", "Knees resting, back pulling", "Legs push the body up",
        "With the knees resting on the pad, the counterweight helps evenly and the back does the pulling.",
        "Pushing down through the knees turns the assisted pull-up into a leg press."),
       [("Latissimus Dorsi", P, HI, 0.84), ("Biceps Brachii", S, MOD, 0.54), ("Middle Trapezius", S, MOD, 0.46)],
       body=("Knees on the pad", ("Body Control",
                                  "The knees rest on the pad; they do not push.",
                                  "The counterweight takes part of the body's weight, so the back still pulls through the whole range.",
                                  "Driving the knees into the pad to push the body up.",
                                  "Kneel on the pad with the knees together and let it carry you; pull with the back.")))

pullup("Neutral-Grip Chin-Up", "neutralGripChinUp",
       ("Close, palms facing", ("Grip",
                                "Close parallel handles, palms facing each other.",
                                "A close neutral grip keeps the elbows tight to the body and shares the pull between the lats and elbow flexors.",
                                "Hanging from the fingers with the wrists bent.",
                                "Grip the close handles deep in the palms, thumbs around, wrists straight.")),
       ("PARTIAL RANGE", "Full hang to chin over", "Half reps at the top",
        "A full hang to a chin over the handles works the lats through their whole range.",
        "Half reps skip the stretch at the bottom, where the lats work hardest to start the pull."),
       [("Latissimus Dorsi", P, HI, 0.86), ("Biceps Brachii", S, HI, 0.66), ("Brachialis", S, MOD, 0.56)])

pullup("Weighted Chin-Up", "weightedChinUp",
       ("Underhand, shoulder-width", ("Grip",
                                      "Underhand, about shoulder-width.",
                                      "An underhand grip brings the biceps in and lets you move the most weight.",
                                      "Gripping wide underhand, which strains the elbows and wrists.",
                                      "Grip underhand at shoulder-width, thumbs around the bar.")),
       ("WEIGHT SWINGING", "Still body, strict pull", "Plate swings the body",
        "Keeping the plate still makes the lats and biceps pull the added load.",
        "A swinging plate turns each rep into a kip and yanks at the lower back through the belt."),
       [("Latissimus Dorsi", P, HI, 0.90), ("Biceps Brachii", S, HI, 0.70), ("Pectoralis Major", S, LOW, 0.34)],
       body=("Plate hangs still", ("Body Control",
                                   "The added weight hangs still between the legs.",
                                   "A still plate means the load goes straight to the back and arms.",
                                   "Letting the plate swing between reps.",
                                   "Set the belt low on the hips, keep the legs together and pause at the bottom of every rep.")))

pullup("Machine Pull-Up", "machinePullUp",
       ("Overhand, shoulder-width", ("Grip",
                                     "Overhand, a little wider than the shoulders.",
                                     "The same grip as the free pull-up, so the strength carries over.",
                                     "Gripping narrow and curling the body up with the arms.",
                                     "Grip overhand just outside shoulder-width, thumbs around the bar.")),
       ("PUSHING WITH THE LEGS", "Legs straight, back pulling", "Knees bend and push",
        "Standing still on the platform lets the counterweight help while the back pulls.",
        "Bending and driving the knees turns the assist into a leg push."),
       [("Latissimus Dorsi", P, HI, 0.84), ("Biceps Brachii", S, MOD, 0.54), ("Middle Trapezius", S, MOD, 0.46)],
       body=("Feet on the platform", ("Body Control",
                                      "The feet rest on the platform; the legs stay straight.",
                                      "The counterweight takes part of the body's weight, so the back still pulls through the whole range.",
                                      "Bending the knees and pushing off the platform.",
                                      "Stand on the platform with the legs straight and together; pull with the back.")))

# ---------------------------------------------------------------- pulldowns

def pulldown(name, var, grip, path, comp, activation, spine=None, feet=None, elbow=None, extra=None):
    ann = [
        ("spine", (spine or ("Lean back ~10–15°", SPINE_PD))[0], "spine"),
        ("elbow", (elbow or ("Elbows to the ribs", ELBOW_PD))[0], "forearm_L"),
        ("grip", grip[0], "hand_L"),
        ("barpath", path[0], "hand_R"),
        ("feet", (feet or ("Thighs locked under pads", FEET_PD))[0], "patella_L"),
    ]
    cues = {"spine": (spine or ("", SPINE_PD))[1], "elbow": (elbow or ("", ELBOW_PD))[1], "grip": grip[1],
            "barpath": path[1], "feet": (feet or ("", FEET_PD))[1]}
    if extra:
        cid, label, joint, cue, replaces = extra
        ann = [(cid, label, joint) if a[0] == replaces else a for a in ann]
        cues.pop(replaces); cues[cid] = cue
    ex(name=name, var=var, annotations=ann, cues=cues, activation=activation,
       stabilisers=["lower trapezius", "rotator cuff", "forearms"], comparison=comp)

BEHIND = ("PULLING BEHIND THE NECK", "Bar to the upper chest", "Bar behind the neck",
          "Pulling to the front keeps the shoulders safe and the lats in their line of pull.",
          "Pulling behind the neck forces the shoulders into extreme rotation and the head forward, with no extra lat work.")

pulldown("Wide-Grip Lat Pulldown", "wideGripLatPulldown",
         ("Wide overhand grip", ("Grip",
                                 "Overhand, about one and a half shoulder-widths.",
                                 "A wide overhand grip keeps the pull on the upper lats and teres major.",
                                 "Gripping at the very ends of the bar, which cuts the range short.",
                                 "Grip overhand where the bar starts to bend, thumbs around it.")),
         ("Bar to upper chest", BARPATH_PD), BEHIND,
         [("Latissimus Dorsi", P, HI, 0.88), ("Teres Major", S, MOD, 0.58), ("Biceps Brachii", S, MOD, 0.44)])

pulldown("Reverse-Grip Lat Pulldown", "reverseGripLatPulldown",
         ("Underhand, shoulder-width", ("Grip",
                                        "Underhand, about shoulder-width.",
                                        "An underhand grip tucks the elbows, pulling on the lower lats and bringing the biceps in.",
                                        "Gripping wide underhand, which strains the wrists and elbows.",
                                        "Grip underhand at shoulder-width, thumbs around the bar.")),
         ("Bar to lower chest", ("Bar Path",
                                 "The bar comes down to the bottom of the chest.",
                                 "With tucked elbows the bar naturally finishes lower, where the lats are fully shortened.",
                                 "Stopping at the chin, well short of the chest.",
                                 "Pull the bar to the lower chest, elbows by the ribs, then return to straight arms.")),
         ("PARTIAL RANGE", "Bar to the lower chest", "Stopping at the chin",
          "A full pull to the lower chest shortens the lats all the way.",
          "Stopping at the chin leaves the hardest part of the rep undone."),
         [("Latissimus Dorsi", P, HI, 0.84), ("Biceps Brachii", S, HI, 0.66), ("Middle Trapezius", S, MOD, 0.50)])

pulldown("Neutral-Grip Lat Pulldown", "neutralGripLatPulldown",
         ("Palms facing, shoulder-width", ("Grip",
                                           "Palms face each other on the bar's handles.",
                                           "A neutral grip lets the elbows come straight down beside the body and is easy on the shoulders.",
                                           "Hanging from the fingers with the wrists bent back.",
                                           "Hold the neutral handles deep in the palms, wrists straight.")),
         ("Handles to upper chest", BARPATH_PD),
         ("SWINGING BACK", "Small, fixed lean", "Rocking back each rep",
          "A small, fixed lean keeps the lats pulling the handles straight down.",
          "Rocking back each rep turns the pulldown into a row with momentum."),
         [("Latissimus Dorsi", P, HI, 0.86), ("Biceps Brachii", S, MOD, 0.56), ("Brachialis", S, MOD, 0.48)])

pulldown("V-Bar Lat Pulldown", "vBarLatPulldown",
         ("Close V-handle, palms in", ("Grip",
                                       "Both hands on a V-handle, palms facing.",
                                       "A close neutral grip keeps the elbows tight and lets you pull the handle to the chest.",
                                       "Gripping loosely with the wrists bent.",
                                       "Hold the V-handle deep in the palms, wrists straight.")),
         ("Handle to the chest", ("Bar Path",
                                  "The handle comes down to the middle of the chest.",
                                  "Pulling the handle to the sternum with the chest up finishes the lats and mid-back.",
                                  "Pulling the handle past the chest to the stomach by leaning back.",
                                  "Pull the handle to the breastbone, chest lifted, then return to straight arms.")),
         ("PULLED PAST THE CHEST", "Handle to the chest", "Leaning back to the stomach",
          "Finishing at the chest keeps the pulldown a vertical pull for the lats.",
          "Leaning back to reach the stomach turns it into a row and loads the lower back."),
         [("Latissimus Dorsi", P, HI, 0.86), ("Biceps Brachii", S, MOD, 0.56), ("Middle Trapezius", S, MOD, 0.50)])

pulldown("Kneeling Lat Pulldown", "kneelingLatPulldown",
         ("Overhand, shoulder-width", ("Grip",
                                       "Overhand, about shoulder-width.",
                                       "A shoulder-width grip lines the arms up with the lats.",
                                       "Gripping too wide to pull through a full range.",
                                       "Grip overhand at shoulder-width, thumbs around the bar.")),
         ("Bar to upper chest", BARPATH_PD),
         ("SITTING BACK", "Kneel tall, hips forward", "Hips sink back to the heels",
          "Kneeling tall makes the core hold the body still while the lats pull.",
          "Sitting back onto the heels turns the pull into a lean with the body's weight."),
         [("Latissimus Dorsi", P, HI, 0.84), ("Biceps Brachii", S, MOD, 0.50), ("Rectus Abdominis", S, MOD, 0.40)],
         spine=("Kneel tall, ribs down", ("Torso Position",
                                          "Upright from the knees to the head.",
                                          "With no thigh pads, the core has to hold the body still, which is the point of kneeling.",
                                          "Arching the lower back and leaning back to pull.",
                                          "Kneel tall, squeeze the glutes, keep the ribs down and stay upright.")),
         feet=("Hips forward, glutes tight", ("Base Position",
                                              "The hips stay over the knees.",
                                              "Hips over the knees keep the body stacked so the lats, not the body's weight, move the bar.",
                                              "Sitting back toward the heels as the bar comes down.",
                                              "Kneel on the mat hip-width, hips over the knees, glutes tight.")))

pulldown("Rope Lat Pulldown", "ropeLatPulldown",
         ("Hands on the rope ends", ("Grip",
                                     "One hand on each end of the rope, palms in.",
                                     "The rope lets the hands travel apart at the bottom, so the elbows can finish behind the body.",
                                     "Gripping the rope in the middle, which limits the range.",
                                     "Hold each end just above the stoppers, palms facing each other.")),
         ("Rope apart to the shoulders", ("Bar Path",
                                          "The hands pull down and apart to the shoulders.",
                                          "Splitting the rope at the bottom lets the elbows drive past the torso for a harder lat squeeze.",
                                          "Keeping the hands together, as with a bar.",
                                          "Pull down and spread the rope so the hands finish beside the shoulders, then return.")),
         ("HANDS STAY TOGETHER", "Rope split at the bottom", "Hands kept together",
          "Spreading the rope lets the elbows pass the torso and fully shorten the lats.",
          "Pulling with the hands together stops the elbows short, like a bar with half the range."),
         [("Latissimus Dorsi", P, HI, 0.86), ("Teres Major", S, MOD, 0.56), ("Biceps Brachii", S, MOD, 0.46)])

pulldown("Machine Lat Pulldown", "machineLatPulldown",
         ("Handles at shoulder-width", ("Grip",
                                        "Hold the lever handles at about shoulder-width.",
                                        "The handles' angle sets the arms in the lats' line of pull.",
                                        "Gripping the far ends of the handles and reaching with the shoulders.",
                                        "Hold the handles firmly, wrists straight, shoulders down.")),
         ("Handles to the shoulders", ("Bar Path",
                                       "The handles come down beside the shoulders.",
                                       "The lever's arc brings the elbows down to the sides for a full lat squeeze.",
                                       "Short reps that stop with the elbows above the shoulders.",
                                       "Pull until the hands are level with the shoulders and the elbows by the ribs, then return.")),
         ("PARTIAL RANGE", "Handles to the shoulders", "Stopping short",
          "A full pull brings the elbows to the ribs and finishes the lats.",
          "Stopping short keeps the lats in their easiest range."),
         [("Latissimus Dorsi", P, HI, 0.86), ("Biceps Brachii", S, MOD, 0.48), ("Middle Trapezius", S, MOD, 0.46)])

pulldown("Iso-Lateral Lat Pulldown", "isoLateralLatPulldown",
         ("Handles at shoulder-width", ("Grip",
                                        "Hold each lever handle at about shoulder-width.",
                                        "Independent handles let each arm follow its own path.",
                                        "Reaching up with the shoulders to take the handles.",
                                        "Hold the handles firmly, wrists straight, shoulders down.")),
         ("One side at a time", ("Bar Path",
                                 "Each arm pulls on its own.",
                                 "Working one side at a time stops the stronger lat from doing the weaker one's work.",
                                 "Leaning toward the working side to finish the pull.",
                                 "Pull one handle down to the shoulder, return it under control, then pull the other, torso still.")),
         ("LEANING INTO THE PULL", "Torso square, one arm pulls", "Body tilts to the working side",
          "With the torso square, each lat pulls its own handle.",
          "Leaning toward the working arm borrows the body's weight and loses the one-sided work."),
         [("Latissimus Dorsi", P, HI, 0.86), ("Biceps Brachii", S, MOD, 0.48), ("Obliques", S, LOW, 0.30)])

ex(name="Single-Arm Lat Pulldown", var="singleArmLatPulldown",
   annotations=[
       ("core", "Torso square", "spine"),
       ("elbow", "Elbow to the ribs", "forearm_L"),
       ("grip", "D-handle, palm in", "hand_L"),
       ("barpath", "Handle to the shoulder", "upper_arm_L"),
       ("feet", "Thighs locked under pads", "patella_L"),
   ],
   cues={
       "core": BRACE,
       "elbow": ("Elbow Path",
                 "The working elbow drives down to the side.",
                 "Pulling the elbow to the ribs lets one lat work through its full range.",
                 "Letting the elbow flare out and forward.",
                 "Pull the elbow down and slightly back, finishing beside the ribs."),
       "grip": ("Grip",
                "A single D-handle, palm facing in.",
                "A neutral grip lets the elbow come straight down beside the body.",
                "Hanging from the fingers with the wrist bent.",
                "Hold the handle deep in the palm, wrist straight, the free hand on the thigh."),
       "barpath": ("Range of Motion",
                   "From a full reach overhead to the shoulder.",
                   "One arm can reach further than a bar allows, so the lat gets a longer stretch and a harder squeeze.",
                   "Stopping short with the hand above the head.",
                   "Let the arm reach up fully, then pull the handle down to the shoulder."),
       "feet": FEET_PD,
   },
   activation=[("Latissimus Dorsi", P, HI, 0.88), ("Teres Major", S, MOD, 0.56), ("Biceps Brachii", S, MOD, 0.46), ("Obliques", S, LOW, 0.30)],
   stabilisers=["lower trapezius", "rotator cuff", "core"],
   comparison=("TORSO TWISTING", "Square torso, elbow to ribs", "Torso twists to pull",
               "With the torso square, one lat pulls the handle through its full range.",
               "Twisting toward the handle swaps lat work for a rotation of the trunk."))

# ---------------------------------------------------------------- cable rows

def cable_row(name, var, grip, path, comp, activation, torso=None, stabilisers=("erector spinae", "forearms", "core")):
    ex(name=name, var=var,
       annotations=[
           ("scapula", "Reach, then squeeze", "scapula_R"),
           ("elbow", "Elbows back past the torso", "forearm_L"),
           ("grip", grip[0], "hand_L"),
           ("barpath", path[0], "hand_R"),
           ("torso", (torso or ("Torso still, sit tall", TORSO_ROW))[0], "spine"),
       ],
       cues={"scapula": SCAP_ROW, "elbow": ELBOW_ROW, "grip": grip[1], "barpath": path[1],
             "torso": (torso or ("", TORSO_ROW))[1]},
       activation=activation, stabilisers=list(stabilisers), comparison=comp)

LEAN = ("EXCESSIVE BACK LEAN", "Torso still, arms pull", "Leaning back to swing",
        "Keeping the torso still makes the back muscles pull the handle.",
        "Leaning far back swings the weight with the hips and lower back.")

cable_row("Wide-Grip Seated Cable Row", "wideGripSeatedCableRow",
          ("Wide overhand bar", ("Grip",
                                 "A straight bar, overhand, wider than the shoulders.",
                                 "A wide grip flares the elbows, moving the work to the upper back and rear delts.",
                                 "Letting the grip creep in toward shoulder-width.",
                                 "Grip the bar overhand about one and a half shoulder-widths apart, wrists straight.")),
          ("Bar to the lower chest", ("Row Path",
                                      "The bar comes to the bottom of the chest, elbows out.",
                                      "With the elbows flared, pulling to the lower chest lines the row up with the upper back.",
                                      "Rowing to the stomach with the elbows tucked.",
                                      "Row the bar to the lower chest with the elbows out, pause, then extend fully.")),
          LEAN, [("Middle Trapezius", P, HI, 0.84), ("Posterior Deltoid", S, MOD, 0.60), ("Latissimus Dorsi", S, MOD, 0.58), ("Rhomboids", S, MOD, 0.54)])

cable_row("Close-Grip Seated Cable Row", "closeGripSeatedCableRow",
          ("Close V-handle, palms in", ("Grip",
                                       "A V-handle, palms facing each other.",
                                       "A close neutral grip keeps the elbows by the sides, bringing the lats in with the mid-back.",
                                       "Gripping loosely with the wrists bent.",
                                       "Hold the V-handle deep in the palms, wrists straight.")),
          ("Handle to the navel", ("Row Path",
                                   "The handle comes to the upper stomach.",
                                   "Pulling low with the elbows tight finishes the lats and mid-back together.",
                                   "Pulling the handle up to the chest with the shoulders shrugging.",
                                   "Row the handle to just above the navel, elbows brushing the ribs, then extend fully.")),
          LEAN, [("Latissimus Dorsi", P, HI, 0.84), ("Middle Trapezius", P, HI, 0.76), ("Biceps Brachii", S, MOD, 0.50)])

cable_row("High Cable Row", "highCableRow",
          ("Overhand, shoulder-width", ("Grip",
                                        "Overhand handles from a high pulley.",
                                        "Pulling from above with the elbows high works the upper back and rear delts.",
                                        "Gripping so the wrists bend under the cable's pull.",
                                        "Hold the handles overhand at shoulder-width, wrists straight, arms reaching up and forward.")),
          ("Handles to the face", ("Row Path",
                                   "The handles travel down and back toward the face.",
                                   "The high angle and high elbows put the rear delts, traps and rhomboids in charge.",
                                   "Pulling the handles down to the stomach, which turns it into a pulldown.",
                                   "Row the handles toward the eyes with the elbows high and out, then extend fully.")),
          ("ELBOWS DROPPING", "Elbows high, handles to the face", "Handles pulled low",
           "High elbows and a finish at the face keep the upper back doing the work.",
           "Pulling low turns the high row into a pulldown and loses the upper-back emphasis."),
          [("Middle Trapezius", P, HI, 0.82), ("Posterior Deltoid", S, HI, 0.66), ("Rhomboids", S, MOD, 0.58), ("Latissimus Dorsi", S, MOD, 0.48)])

cable_row("Low Cable Row", "lowCableRow",
          ("Overhand, shoulder-width", ("Grip",
                                        "Handles from a floor pulley, overhand.",
                                        "Pulling up and back from low down brings the lower lats in.",
                                        "Reaching for the handles with the back rounded.",
                                        "Hold the handles at shoulder-width, wrists straight, arms long toward the floor pulley.")),
          ("Handles to the hips", ("Row Path",
                                   "The handles travel up and back to the hips.",
                                   "An upward-backward path toward the hips lines the pull up with the lower lats.",
                                   "Pulling the handles up to the chest.",
                                   "Row the handles back to the hip bones, elbows close, then extend fully.")),
          LEAN, [("Latissimus Dorsi", P, HI, 0.86), ("Middle Trapezius", S, MOD, 0.60), ("Biceps Brachii", S, MOD, 0.48)])

cable_row("Standing Cable Row", "standingCableRow",
          ("Handles at chest height", ("Grip",
                                       "A handle in each hand, pulleys around chest height.",
                                       "Standing makes the legs and trunk brace against the pull as well as the back pulling it.",
                                       "Gripping so the wrists bend under the cables.",
                                       "Hold the handles with the wrists straight, arms reaching forward.")),
          ("Handles to the ribs", ("Row Path",
                                   "The handles come to the lower ribs.",
                                   "Pulling to the ribs with the elbows close finishes the lats and mid-back.",
                                   "Short pulls that stop in front of the chest.",
                                   "Row until the hands reach the lower ribs, pause, then return to straight arms.")),
          ("LEANING BACK", "Braced stance, arms pull", "Body leans back to heave",
           "A braced staggered stance lets the back row without the body swinging.",
           "Leaning back uses the body's weight to move the stack and loads the lower back."),
          [("Latissimus Dorsi", P, HI, 0.80), ("Middle Trapezius", P, HI, 0.74), ("Biceps Brachii", S, MOD, 0.48)],
          torso=("Staggered stance, knees soft", ("Stance",
                                                  "A staggered stance braces against the cables.",
                                                  "One foot ahead of the other with soft knees lets the body resist the pull without rocking.",
                                                  "Standing square with locked knees and leaning back to pull.",
                                                  "Stand with one foot a step ahead, knees soft, torso tall and braced.")),
          stabilisers=("glutes", "core", "erector spinae"))

ex(name="Single-Arm Cable Row", var="singleArmCableRow",
   annotations=[
       ("scapula", "Reach, then squeeze", "scapula_L"),
       ("elbow", "Elbow to the hip", "forearm_L"),
       ("grip", "Handle, palm in", "hand_L"),
       ("core", "Torso square", "spine"),
       ("torso", "Sit tall, chest up", "chest"),
   ],
   cues={
       "scapula": ("Scapular Position",
                   "The working shoulder reaches, then squeezes.",
                   "Letting the shoulder blade move forward and back works the lat and mid-back through the full range.",
                   "The working shoulder staying rounded forward.",
                   "Let the shoulder reach toward the stack, then pull the shoulder blade back as you row."),
       "elbow": ("Elbow Path",
                 "The elbow drives back to the hip.",
                 "Pulling toward the hip lines the row up with the lower lat.",
                 "Winging the elbow out to the side.",
                 "Row the elbow back past the torso toward the hip, close to the ribs."),
       "grip": ("Grip",
                "A single handle, palm facing in.",
                "A neutral grip keeps the wrist straight and the elbow close.",
                "Hanging from the fingers with the wrist bent.",
                "Hold the handle deep in the palm, wrist straight."),
       "core": BRACE,
       "torso": TORSO_ROW,
   },
   activation=[("Latissimus Dorsi", P, HI, 0.86), ("Middle Trapezius", S, MOD, 0.56), ("Biceps Brachii", S, MOD, 0.46), ("Obliques", S, LOW, 0.30)],
   stabilisers=["erector spinae", "forearms", "core"],
   comparison=("TORSO TWISTING", "Square torso, elbow to hip", "Torso twists open",
               "With the torso square, one lat rows the handle through its full range.",
               "Twisting open to heave the handle swaps back work for a rotation of the trunk."))

ex(name="Half-Kneeling Cable Row", var="halfKneelingCableRow",
   annotations=[
       ("scapula", "Reach, then squeeze", "scapula_L"),
       ("elbow", "Elbow to the hip", "forearm_L"),
       ("grip", "Handle, palm in", "hand_L"),
       ("core", "Hips and shoulders square", "spine"),
       ("stance", "Back knee down, glutes tight", "patella_R"),
   ],
   cues={
       "scapula": ("Scapular Position",
                   "The working shoulder reaches, then squeezes.",
                   "Letting the shoulder blade move forward and back works the lat and mid-back through the full range.",
                   "The working shoulder staying rounded forward.",
                   "Let the shoulder reach toward the pulley, then pull the shoulder blade back as you row."),
       "elbow": ("Elbow Path",
                 "The elbow drives back to the hip.",
                 "Pulling toward the hip lines the row up with the lower lat.",
                 "Winging the elbow out to the side.",
                 "Row the elbow back past the torso toward the hip, close to the ribs."),
       "grip": ("Grip",
                "A single handle, palm facing in.",
                "A neutral grip keeps the wrist straight and the elbow close.",
                "Hanging from the fingers with the wrist bent.",
                "Hold the handle deep in the palm, wrist straight."),
       "core": BRACE,
       "stance": ("Half-Kneeling Base",
                  "One knee down, the other foot forward.",
                  "Squeezing the glute of the down leg locks the pelvis, so the trunk has to resist the one-sided pull.",
                  "Sitting back onto the back heel or arching the lower back.",
                  "Kneel with the back knee under the hip, front foot flat ahead, glutes squeezed and torso tall."),
   },
   activation=[("Latissimus Dorsi", P, HI, 0.82), ("Obliques", S, MOD, 0.50), ("Middle Trapezius", S, MOD, 0.50), ("Biceps Brachii", S, MOD, 0.44)],
   stabilisers=["glutes", "transversus abdominis", "forearms"],
   comparison=("TORSO TWISTING", "Square torso, elbow to hip", "Torso twists open",
               "With the hips and shoulders square, the lat rows while the trunk resists the pull.",
               "Twisting open to heave the handle loses the anti-rotation work the half-kneeling stance is for."))

# ---------------------------------------------------------------- machine rows

def machine_row(name, var, path, comp, activation, extra=None):
    ann = [
        ("pad", "Chest on the pad", "chest"),
        ("elbow", "Elbows back past the torso", "forearm_L"),
        ("grip", "Neutral handles, wrists straight", "hand_L"),
        ("barpath", path[0], "hand_R"),
        ("scapula", "Squeeze, don't shrug", "scapula_R"),
    ]
    cues = {
        "pad": ("Chest Contact",
                "The chest stays on the pad.",
                "The pad takes the lower back and legs out of the row, so only the back and arms move the handles.",
                "Lifting the chest off the pad to lean into the pull.",
                "Set the seat so the handles are at mid-chest, rest the chest on the pad and keep it there."),
        "elbow": ELBOW_ROW,
        "grip": ("Grip",
                 "Palms facing each other on the handles.",
                 "A neutral grip keeps the elbows close and the wrists straight.",
                 "Reaching for the handles with the shoulders rounded.",
                 "Hold the handles deep in the palms, wrists straight, shoulders back."),
        "barpath": path[1],
        "scapula": ("Scapular Position",
                    "The shoulder blades squeeze together, not up.",
                    "Retracting without shrugging keeps the mid-traps and rhomboids doing the work.",
                    "Shrugging the shoulders up at the end of the row.",
                    "At the finish, pull the shoulder blades back and together, keeping them down."),
    }
    if extra:
        cid, label, joint, cue, replaces = extra
        ann = [(cid, label, joint) if a[0] == replaces else a for a in ann]
        cues.pop(replaces); cues[cid] = cue
    ex(name=name, var=var, annotations=ann, cues=cues, activation=activation,
       stabilisers=["rotator cuff", "forearms"], comparison=comp)

machine_row("Machine Seated Row", "machineSeatedRow",
            ("Handles to the ribs", ("Handle Path",
                                     "The handles come back to the lower ribs.",
                                     "A full pull with the chest on the pad finishes the lats and mid-back.",
                                     "Short reps that stop well in front of the body.",
                                     "Row until the hands reach the ribs, pause, then return to straight arms.")),
            ("CHEST OFF THE PAD", "Chest down, full row", "Chest lifts to heave",
             "With the chest on the pad, the back and arms do the rowing.",
             "Lifting off the pad brings the lower back and momentum into a supported row."),
            [("Middle Trapezius", P, HI, 0.82), ("Latissimus Dorsi", P, HI, 0.76), ("Biceps Brachii", S, MOD, 0.46)])

machine_row("Iso-Lateral Row Machine", "isoLateralRowMachine",
            ("One side at a time", ("Handle Path",
                                    "Each handle moves on its own.",
                                    "Rowing one side at a time stops the stronger side from carrying the weaker one.",
                                    "Twisting toward the working arm to finish the row.",
                                    "Row one handle to the ribs, return it under control, then row the other, chest still on the pad.")),
            ("TORSO TWISTING", "Chest square on the pad", "Torso twists to the working side",
             "With the chest square on the pad, each side of the back rows its own handle.",
             "Twisting toward the working arm hands part of the row to the trunk."),
            [("Middle Trapezius", P, HI, 0.80), ("Latissimus Dorsi", P, HI, 0.78), ("Biceps Brachii", S, MOD, 0.46)])

machine_row("Single-Arm Machine Row", "singleArmMachineRow",
            ("Handle to the ribs", ("Handle Path",
                                    "The working handle comes back to the lower ribs.",
                                    "A full pull on one side works that lat and mid-back through the whole range.",
                                    "Short reps that stop well in front of the body.",
                                    "Row until the hand reaches the ribs, pause, then return to a straight arm.")),
            ("TORSO TWISTING", "Chest square, free hand braced", "Torso twists open",
             "Bracing with the free hand keeps the chest square so one side of the back rows the handle.",
             "Twisting open to heave the handle loses the one-sided work."),
            [("Latissimus Dorsi", P, HI, 0.84), ("Middle Trapezius", S, MOD, 0.62), ("Biceps Brachii", S, MOD, 0.46)],
            extra=("brace", "Free hand on the support", "hand_R", BRACE, "barpath"))

ex(name="Reverse-Grip T-Bar Row", var="reverseGripTBarRow",
   annotations=[
       ("elbow", "Elbows close to the ribs", "forearm_L"),
       ("barpath", "Handle to the stomach", "hand_R"),
       ("grip", "Underhand handle", "hand_L"),
       ("feet", "Hips hinged, back flat", "pelvis"),
       ("scapula", "Squeeze shoulder blades", "scapula_R"),
   ],
   cues={
       "elbow": ("Elbow Path",
                 "An underhand grip keeps the elbows tight.",
                 "Elbows brushing the ribs line the row up with the lower lats.",
                 "Flaring the elbows out wide.",
                 "Pull the elbows back past the torso, close to the ribs."),
       "barpath": ("Row Path",
                   "The handle travels up to the stomach.",
                   "With the elbows tucked, the handle finishes lower than an overhand T-bar row.",
                   "Short reps that stop well below the body.",
                   "Row until the plates nearly touch the stomach, pause, then lower to straight arms."),
       "grip": ("Grip",
                "Underhand on the handle, about shoulder-width.",
                "Palms up bring the biceps in and tuck the elbows toward the lats.",
                "Reaching for the handle with the shoulders rounded.",
                "Grip the handle underhand, wrists straight, and brace before the first pull."),
       "feet": ("Torso Position",
                "The torso holds its hinge for the whole set.",
                "A fixed, braced hinge keeps the load on the back muscles.",
                "The back rounding over the bar as it gets heavy.",
                "Hinge from the hips with soft knees and a flat back, brace, and hold that angle."),
       "scapula": SCAP_ROW,
   },
   activation=[("Latissimus Dorsi", P, HI, 0.86), ("Middle Trapezius", S, MOD, 0.62), ("Biceps Brachii", S, MOD, 0.58)],
   stabilisers=["erector spinae", "hamstrings", "forearms", "core"],
   comparison=("ROUNDED LOWER BACK", "Flat back, fixed hinge", "Back rounds over the bar",
               "A flat, braced hinge lets the lats row the handle to the stomach.",
               "Rounding over the bar puts the load on the spine instead of the back muscles."))

# ---------------------------------------------------------------- pullovers

ex(name="Dumbbell Pullover Row", var="dumbbellPulloverRow",
   annotations=[
       ("grip", "Palms facing each other", "hand_L"),
       ("elbow", "Arms long, elbows soft", "forearm_L"),
       ("arc", "Stop with arms by your ears", "upper_arm_L"),
       ("ribs", "Ribs down, no arch", "spine"),
       ("feet", "Feet planted", "foot_L"),
   ],
   cues={
       "grip": ("Grip",
                "A dumbbell in each hand, palms facing each other.",
                "Two dumbbells let each arm travel its own path and keep the wrists neutral.",
                "Holding the dumbbells loosely with the wrists bent back.",
                "Grip each handle firmly, palms in, wrists straight over the forearms."),
       "elbow": ("Elbow Bend",
                 "The arms stay long, with only a soft bend.",
                 "Nearly straight arms keep the motion at the shoulder, where the lats pull the weight back over the chest.",
                 "Bending the elbows as the dumbbells go back, turning it into a triceps extension.",
                 "Keep a slight bend at the elbows and hold it through the whole arc."),
       "arc": ("Range of Motion",
               "The arms sweep back until they line up with the torso.",
               "The overhead stretch is where the lats work hardest; past the line of the torso the shoulder capsule takes over.",
               "Lowering the dumbbells far below the bench behind the head.",
               "Lower until the upper arms are beside the ears, then pull the dumbbells back over the chest by driving the arms down."),
       "ribs": ("Rib Position",
                "The ribs stay down as the arms go back.",
                "A flat lower back makes the shoulders do the moving instead of the spine arching for extra range.",
                "Arching the lower back and flaring the ribs at the stretch.",
                "Brace, keep the ribs pulled toward the hips and stop the arc before the back arches."),
       "feet": ("Leg Drive",
                "The feet keep the body still on the bench.",
                "Planted feet keep the hips down so the arc comes from the shoulders.",
                "Feet drifting or the hips lifting off the bench.",
                "Plant both feet flat, a little wider than the hips."),
   },
   activation=[("Latissimus Dorsi", P, HI, 0.80), ("Pectoralis Major", P, HI, 0.74), ("Teres Major", S, MOD, 0.54), ("Triceps Brachii", S, MOD, 0.42)],
   stabilisers=["serratus anterior", "core", "rotator cuff"],
   comparison=("RIBS FLARED, BACK ARCHED", "Ribs down, arms to the ears", "Back arches to reach further",
               "With the ribs down and the arc stopped at the ears, the lats do the stretching and pulling.",
               "Arching the back fakes range with the spine and stretches the shoulder capsule instead of the lats."))

ex(name="Machine Pullover", var="machinePullover",
   annotations=[
       ("elbow", "Drive with the elbows", "forearm_L"),
       ("grip", "Hands loose on the bar", "hand_L"),
       ("arc", "Full stretch overhead", "upper_arm_L"),
       ("spine", "Back on the pad", "spine"),
       ("scapula", "Shoulders down", "scapula_R"),
   ],
   cues={
       "elbow": ("Elbow Drive",
                 "The upper arms push the pads; the hands just rest.",
                 "Driving through the elbows keeps the pull on the lats and takes the biceps and forearms out of it, the machine pullover's advantage.",
                 "Pulling the bar down with the hands and bending the arms.",
                 "Press the backs of the upper arms into the pads and sweep them down to the sides."),
       "grip": ("Grip",
                "A light hold on the bar.",
                "A loose grip keeps the forearms out of the lift so the lats do the work.",
                "Squeezing the bar hard and bending the wrists.",
                "Rest the hands on the bar, wrists straight, and let the elbows lead."),
       "arc": ("Range of Motion",
               "The arms start high overhead.",
               "The overhead stretch is where the pullover loads the lats most.",
               "Starting with the arms only halfway up, cutting the stretch.",
               "Let the lever take the arms up until you feel the lats stretch, then drive down until the arms reach the sides."),
       "spine": ("Back Position",
                 "The back stays against the pad.",
                 "A flat back and down ribs keep the arc at the shoulders rather than the spine.",
                 "Arching away from the pad at the top.",
                 "Sit with the back flat on the pad, belt or seat set so the shoulders line up with the machine's pivot."),
       "scapula": ("Scapular Position",
                   "The shoulders stay down, away from the ears.",
                   "Keeping the shoulders depressed through the stretch lets the lats, not the upper traps, start the pull.",
                   "Shrugging up into the stretch at the top.",
                   "Draw the shoulders down before each rep and keep them there as the arms sweep."),
   },
   activation=[("Latissimus Dorsi", P, HI, 0.88), ("Teres Major", S, MOD, 0.60), ("Pectoralis Major", S, MOD, 0.48)],
   stabilisers=["serratus anterior", "core", "rotator cuff"],
   comparison=("PULLING WITH THE HANDS", "Elbows drive the pads", "Hands pull, arms bend",
               "Driving through the upper arms keeps the pullover a pure lat exercise.",
               "Pulling with the hands brings in the biceps and forearms and shortens the lats' range."))
