# Trainer content for the three exercises that were gated — Biceps Curl
# (no model), Squat and Lunge (legacy models) — re-exported from
# SourceExports/3 bai thieu, plus the new forward-lean lunge (2026-09-24).
# Same format as spec.py; generate with `spec` swapped for this module (see
# README). Every framing has a negative yaw, so the lifter's LEFT side faces
# the camera; both lunges put the LEFT leg forward and are seen nearly
# side-on (yaw -1.3), so front-leg cues track the _L joints and the rear knee
# tracks patella_R. Where the near-side joint would pull a leader across the
# body, the cue tracks the matching joint on the side its label sits
# (`overrides` pins those labels).
#
# What each model shows, from the rig (Tools/model-pipeline/pose2.py-style
# probe): Biceps Curl — standing, a dumbbell in each hand, both arms curling
# together, palms up. Squat — bodyweight, arms held straight out in front,
# feet a little wider than the hips, down to about parallel with the torso
# tilting ~30°. Lunge — stationary split stance, hands on hips, torso upright,
# back heel up, back knee to just above the floor. Lunge (Lean) — the same
# stance with the torso tilted ~30° forward from the hips.
#
# Sources:
# - Oliveira LF et al. 2009, J Sports Sci Med 8(1):24-29 — biceps brachii EMG
#   across dumbbell curl variations; the standing curl loads the biceps
#   through the full range with the upper arm by the side.
# - Kleiber T et al. 2015, Front Physiol 6:215 — biceps brachii activity is
#   highest with the forearm supinated; brachioradialis takes over more as the
#   hand turns toward neutral.
# - Escamilla RF 2001, Med Sci Sports Exerc 33(1):127-141 — quadriceps are the
#   prime movers in the squat, with gluteus maximus and hamstring activity
#   rising with depth; knees in line with the feet.
# - Schoenfeld BJ 2010, J Strength Cond Res 24(12):3497-3506 — squat
#   kinematics: forward trunk lean and hip travel shift load toward the hip
#   extensors; knee valgus to avoid.
# - Farrokhi S et al. 2008, J Orthop Sports Phys Ther 38(7):403-409 — a
#   forward trunk lean in the lunge increased hip extensor impulse and
#   gluteus maximus and biceps femoris activity of the lead leg compared with
#   an upright trunk.

P, S = "primary", "secondary"
HI, MOD = "HIGH ACTIVATION", "MODERATE ACTIVATION"
A, SOFT = "activation", "activationSoft"

SPEC = []

def ex(**kw):
    SPEC.append(kw)

# ---------------------------------------------------------------- Arms

ex(name="Biceps Curl", var="bicepsCurl", group="arms",
   overrides={"shoulder": (0.14, "trailing"), "wrist": (0.14, "leading"),
              "elbow": (0.55, "leading"), "core": (0.55, "trailing")},
   annotations=[
       ("shoulder", "Shoulders down and back", "upper_arm_L"),
       ("elbow", "Elbows by your ribs", "forearm_R"),
       ("wrist", "Palms up, wrists flat", "hand_R"),
       ("core", "No body swing", "spine"),
   ],
   cues={
       "shoulder": ("Shoulder Position",
                    "The upper arms hang from set, quiet shoulders.",
                    "When the shoulders shrug or roll forward, the upper traps and front deltoids start lifting the dumbbells and the biceps do less of the work.",
                    "Shrugging the shoulders up or letting them roll forward at the top of each curl.",
                    "Draw the shoulders gently down and back before the first rep and keep them there as the dumbbells rise."),
       "elbow": ("Elbow Position",
                 "Only the forearms move; the elbows stay put.",
                 "With the elbows fixed by the sides, bending the elbow is the only motion, so the biceps brachii and brachialis lift the weight through the whole range.",
                 "Elbows drifting forward and up as the dumbbells rise, which turns the top of the rep into a front raise.",
                 "Keep the elbows close to the ribs and slightly in front of the hips, and stop the curl when the forearms are about vertical."),
       "wrist": ("Grip and Wrists",
                 "The palms face up for the whole curl.",
                 "The biceps both bends the elbow and turns the palm up, so it works hardest with the forearm fully supinated; a straight wrist keeps the forearm muscles from taking over.",
                 "Letting the wrists curl in toward the forearms, or the palms turn inward as the weight comes up.",
                 "Hold the dumbbells palms-up with a firm grip and keep the knuckles in line with the forearms from bottom to top."),
       "core": ("Body Swing",
                "The legs and back stay out of it.",
                "Rocking the torso borrows momentum from the hips and lower back, which skips the hardest part of the curl and loads the spine.",
                "Leaning back and pushing the hips forward to get the dumbbells moving.",
                "Stand tall with soft knees, brace the core and lower the dumbbells over two to three seconds so each rep starts from straight arms."),
   },
   activation=[("Biceps Brachii", P, HI, 0.88), ("Brachialis", S, MOD, 0.68), ("Brachioradialis", S, MOD, 0.46)],
   stabilisers=["anterior deltoid", "forearm flexors", "core"],
   comparison=("ELBOWS DRIFTING FORWARD", "Elbows fixed at the sides", "Elbows swing forward and up",
               "With the elbows fixed at the sides, the biceps and brachialis lift the dumbbells through the whole range.",
               "When the elbows travel forward, the front deltoids finish the rep and the biceps lose tension exactly where the curl is hardest."),
   glows=[(A, 0.55, 0.08, 0.07, 0.70, 0.30), (A, 0.55, 0.08, 0.07, 0.39, 0.31)])

# ---------------------------------------------------------------- Legs

ex(name="Squat", var="squat", group="legs",
   # The four cues the model's own TIP_Squat_* markers call out. The hip
   # movement lives in the torso cue: at the bottom of the rep the right side
   # of the frame is all shoulder and thigh, with no room for a fifth label.
   overrides={"arms": (0.14, "leading"), "torso": (0.32, "trailing"),
              "knee": (0.68, "leading"), "foot": (0.86, "leading")},
   annotations=[
       ("arms", "Arms reach forward", "hand_R"),
       ("torso", "Chest up", "chest"),
       ("knee", "Knees over toes", "patella_R"),
       ("foot", "Heels stay down", "foot_R"),
   ],
   cues={
       "arms": ("Arm Position",
                "The arms are a counterweight, not part of the lift.",
                "Reaching the arms forward moves the centre of mass ahead as the hips go back, so you can sit deeper with the chest up and the heels down.",
                "Letting the arms drop at the bottom, with the chest falling after them.",
                "Hold the arms straight out at shoulder height, palms down, and keep them there from the first rep to the last."),
       "torso": ("Torso and Hips",
                 "Chest up, spine long, hips back and down.",
                 "A braced trunk with a neutral spine lets the hips and knees share the work, and sitting the hips back brings the glutes in to help the quadriceps.",
                 "Rounding the lower back or dropping the chest toward the knees as you reach depth.",
                 "Brace the core, bend the hips and knees together and lower until the thighs are about parallel, letting the torso tilt only as far as the hips travel back."),
       "knee": ("Knee Tracking",
                "The knees point where the toes point.",
                "Knees that follow the line of the feet spread the load evenly through the joint; knees caving inward twist it.",
                "Knees collapsing inward, most often on the way up.",
                "Push the knees gently out so they stay over the second and third toes, going down and standing up."),
       "foot": ("Foot Pressure",
                "The whole foot stays on the floor.",
                "Pressure through the heel and mid-foot keeps you balanced and lets the glutes and quadriceps drive you up.",
                "Rising onto the toes at the bottom as the weight shifts forward.",
                "Stand a little wider than hip-width with the toes turned slightly out, and push the floor away through the whole foot."),
   },
   activation=[("Quadriceps", P, HI, 0.84), ("Gluteus Maximus", S, MOD, 0.56), ("Adductor Magnus", S, MOD, 0.40)],
   stabilisers=["hamstrings", "erector spinae", "core", "anterior deltoid"],
   comparison=("KNEES CAVING IN", "Knees over toes, heels down", "Knees collapse inward",
               "With the knees following the toes and the heels down, the quadriceps and glutes of both legs share the load evenly.",
               "When the knees cave in, the load twists through the knee joint and the glutes stop helping drive you up."),
   glows=[(A, 0.55, 0.09, 0.07, 0.71, 0.62), (A, 0.50, 0.09, 0.07, 0.50, 0.63)])

ex(name="Lunge", var="lunge", group="legs",
   overrides={"posture": (0.36, "trailing"), "hips": (0.52, "trailing"), "front": (0.52, "leading"),
              "rear": (0.84, "trailing"), "foot": (0.86, "leading")},
   annotations=[
       ("posture", "Torso upright", "chest"),
       ("hips", "Hips level and square", "pelvis"),
       ("front", "Knee tracks toes", "patella_L"),
       ("rear", "Back knee drops down", "patella_R"),
       ("foot", "Front foot flat", "foot_L"),
   ],
   cues={
       "posture": ("Torso Position",
                   "Stand tall over the hips.",
                   "An upright torso keeps the load on the front leg's quadriceps, which is what the standard lunge trains most.",
                   "Leaning forward over the front thigh, or arching the lower back.",
                   "Keep the chest up, the shoulders over the hips and the eyes forward for every rep."),
       "hips": ("Hip Position",
                "The pelvis stays level and faces forward.",
                "Level, square hips keep the load even through the front leg and stop the lower back twisting under it.",
                "Letting the back hip drop or the pelvis turn toward the front leg.",
                "Brace the core, rest the hands on the hips as a guide and keep both hip bones pointing straight ahead."),
       "front": ("Front Knee",
                 "The front knee travels forward in line with the toes.",
                 "Some forward knee travel is normal in a lunge and is what loads the quadriceps; keeping the knee in line with the toes stops it twisting under that load.",
                 "The front knee caving inward, or the front heel lifting as the knee drives forward.",
                 "Keep the front knee pointing the same way as the foot and the whole front foot on the floor as you lower."),
       "rear": ("Back Knee",
                "The rep goes down, not forward.",
                "Dropping the back knee straight down lets both knees reach about 90° and keeps the depth coming from the legs.",
                "Stopping halfway, or pushing the hips forward instead of down.",
                "Keep the back heel up and lower until the back knee is just above the floor, then press back up."),
       "foot": ("Front Foot",
                "Drive through the heel and mid-foot.",
                "Pushing through the whole front foot keeps you balanced and uses the glutes as well as the quadriceps to stand up.",
                "Rising onto the ball of the front foot, which shifts the load onto the knee.",
                "Keep the front foot flat, push the floor away through the heel as you rise, and do the same reps on the other leg."),
   },
   activation=[("Quadriceps", P, HI, 0.84), ("Gluteus Maximus", S, MOD, 0.58), ("Gluteus Medius", S, MOD, 0.42)],
   stabilisers=["adductors", "hamstrings", "calves", "core"],
   comparison=("FRONT KNEE CAVING IN", "Front knee in line with the toes", "Front knee collapses inward",
               "With the front knee in line with the toes and the foot flat, the quadriceps and glutes of the front leg drive the rep.",
               "When the front knee caves in, the hip stops controlling the leg and the knee takes a twisting load."),
   glows=[(A, 0.55, 0.12, 0.06, 0.36, 0.59), (SOFT, 0.30, 0.07, 0.07, 0.49, 0.55)])

ex(name="Lunge (Lean)", var="lungeLean", group="legs",
   overrides={"lean": (0.36, "trailing"), "core": (0.48, "trailing"), "front": (0.52, "leading"),
              "rear": (0.84, "trailing"), "foot": (0.86, "leading")},
   annotations=[
       ("lean", "Lean ~30° from the hips", "chest"),
       ("core", "Back flat, core braced", "spine"),
       ("front", "Knee tracks toes", "patella_L"),
       ("rear", "Back knee drops down", "patella_R"),
       ("foot", "Drive through the heel", "foot_L"),
   ],
   cues={
       "lean": ("Torso Lean",
                "The lean is what moves this lunge toward the glutes.",
                "Tilting the trunk forward shifts the load toward the hip, so the front leg's gluteus maximus and hamstrings work harder than in an upright lunge.",
                "Rounding the back or dropping the head to get the chest lower.",
                "Keep the spine long, tilt the torso about 30° forward from the hips and hold that angle for the whole rep."),
       "core": ("Trunk Brace",
                "The lean comes from the hips and is held by a braced trunk.",
                "Bracing keeps the spine neutral while the torso tilts, so the extra load goes to the glutes and hamstrings rather than the lower back.",
                "Letting the lower back round or sag as you go down and come back up.",
                "Breathe in, brace as if about to be pushed, and hold the same flat-back angle for the whole rep."),
       "front": ("Front Knee",
                 "The front knee follows the line of the toes.",
                 "With the torso leaning, the hip takes more of the work; a knee that tracks over the toes keeps the joint aligned while it does.",
                 "The front knee caving inward as you push back up.",
                 "Keep the front knee pointing the same way as the foot and the front heel down as you lower."),
       "rear": ("Back Leg",
                "The back leg is there for balance.",
                "Dropping the back knee straight down keeps nearly all the load on the front leg.",
                "Pushing off the back toes to help the front leg stand up.",
                "Keep the back heel up, lower the back knee to just above the floor and let the front leg do the lifting."),
       "foot": ("Front Foot",
                "Drive through the heel.",
                "Pushing through the heel and mid-foot keeps the load on the glutes and hamstrings the lean is meant to target.",
                "Rising onto the ball of the front foot, which shifts the work back to the quadriceps and the knee.",
                "Keep the whole front foot planted, push the floor away through the heel, and do the same reps on the other leg."),
   },
   activation=[("Gluteus Maximus", P, HI, 0.80), ("Quadriceps", P, HI, 0.76), ("Hamstrings", S, MOD, 0.50)],
   stabilisers=["gluteus medius", "adductors", "erector spinae", "core"],
   comparison=("ROUNDED BACK", "Lean from the hips, spine long", "Back rounds instead of hinging",
               "Leaning from the hips with a long spine lets the front leg's glutes and hamstrings take more of the load.",
               "Rounding the back to fake the lean loads the lower back and leaves the glutes working no harder than in an upright lunge."),
   glows=[(A, 0.55, 0.09, 0.08, 0.50, 0.52), (A, 0.50, 0.12, 0.06, 0.36, 0.58)])
