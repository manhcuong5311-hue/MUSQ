# Trainer content for the model-only exercises of 2026-10-29, family
# "clean": the four cleans that shipped with a model but no coaching -
# Barbell Power Clean (Legs/BarbellPowerClean), Hang Clean (Legs/HangClean),
# Dumbbell Hang Clean (Legs/DumbbellHangClean) and Kettlebell Clean
# (Legs/KettlebellClean). Same format as spec.py on top of common_1_50.py;
# spec_1029.py imports this module and gen.py reads SPEC / SETUP.
# notes_1029_clean.md maps every claim in the copy to the sources below or
# to a model measurement.
#
# What the models show, measured from the rigs with Blender's Python + pxr
# (the round folder's summ.py, trace.py, props.py and nearest.py;
# trainer_shot.py renders the app's own trainer camera at 382x655). Frame:
# Y up, the lifter faces +z, their left is +x, metres. Knee and hip are
# inner angles (180 straight), trunk is the neck-over-pelvis line from
# vertical (+ forward). All four clips run 7.96 s at 24 fps (191 frames);
# the shoulder joints are 0.39 m apart in all four, and all four are seen
# from behind and a little to the lifter's left (yaw -0.8), so the back,
# the glutes and the hamstrings face the camera and the bar or bells read
# across the shoulders at the catch.
# - Barbell Power Clean (zoom 0.639). One rep from the floor and back, not a
#   set. A 2.04 m bar with 0.45 m plates rests at 0.22 m; the hands take it
#   0.61 m apart, well outside the shoulders, and the feet stay 0.22-0.30 m
#   apart. Setup (0-0.5 s): knees 98 degrees, hips 57, trunk 62 forward,
#   pelvis 0.58 m, the hands at 0.32 m. First pull (to 1.5 s): the pelvis
#   rises to 0.72 m and the trunk comes up to 27 degrees while the knees
#   open only to 111 - the hips and shoulders rise together. Second pull
#   (2.0 s): knees 151, hips 169, trunk 8 degrees behind vertical, the heels
#   6 cm off the floor (0.07 to 0.13 m) and the hands at 1.03 m, the elbows
#   still 142 degrees. Catch (2.5 s): the knees fold back to 101 degrees as
#   the elbows whip to 52 and the bar arrives at 1.16 m. Stand (3.0 s):
#   knees 174, elbows 43, the hands at 1.39 m, and the rack is held from
#   3.0 to 5.0 s. The bar is then lowered to the floor over 2.5 s. Total bar
#   travel 1.24 m; it swings 0.19 m forward between the pull and the catch
#   and comes back in to 0.16 m at the rack.
# - Hang Clean (zoom 0.629). Two identical reps, one every 4.0 s, from the
#   hang. The same bar and the same 0.61 m grip; the lifter starts standing
#   (knees 175, trunk 10 degrees, the bar at 0.92 m, about hip height).
#   Dip (0.5 s): trunk 37 degrees forward, knees 150, the bar at 0.79 m,
#   just above the knee. Extension (1.0 s): trunk back to 15 degrees, the
#   heels 5 cm up, the bar at 0.92 m. Catch (1.5 s): elbows 62 degrees,
#   knees 110 - she drops under it - the bar at 1.20 m. Rack (2.0-2.5 s):
#   elbows 43, knees 165 to 175, the bar at 1.39 m, held to 3.5 s before the
#   next rep. The whole lift happens between 0.79 m and 1.39 m: 0.60 m of
#   bar travel against the power clean's 1.24.
# - Dumbbell Hang Clean (zoom 0.862). Two reps from the hang with a dumbbell
#   in each hand (0.33 m long, 0.17 m heads). Start standing, the bells at
#   the thighs (hands 0.92 m, elbows 173 degrees - the arms hang straight),
#   0.69 m apart. Dip (0.5 s): trunk 26 degrees, knees 137. Extension
#   (1.0 s): the heels 5 cm up. Catch (1.5 s): elbows 68 degrees, knees 118,
#   the hands at 1.37 m. Rack (2.0-3.0 s): elbows 31 and 35 degrees, the
#   hands at 1.47 m with the bells at the shoulders. The hands part to
#   0.93 m at the widest and close to 0.42 m at the rack, so each bell
#   travels its own arc out and back in; the feet never move (0.24-0.26 m
#   apart).
# - Kettlebell Clean (zoom 0.870). One arm, the left: a single bell (0.26 x
#   0.32 x 0.31 m) that the left hand cleans while the right arm hangs still
#   all clip (elbow 168 degrees, hand at 0.92 m, never moving). Three cycles
#   in 7.96 s, each starting and ending in the rack. Rack: elbow 41 degrees,
#   hand 1.40 m, trunk upright, knees 176. Drop and swing (0.5-1.0 s): the
#   arm straightens to 180 degrees, the hand falls to 0.74 m, the trunk
#   hinges to 37 degrees and the knees bend to 133; the deepest of the three
#   goes to trunk 52 degrees, knees 122 and the hand at 0.65 m. Up (1.5 s):
#   elbow 87 degrees, hand 1.19 m, and back to the rack by 2.0 s. The bell
#   travels 0.85 m. The feet stay 0.37-0.39 m apart and the heels stay down
#   throughout - this is a hinge and a pull, with no heel lift.
# How they differ from the library: the Clean and Press, Kettlebell Clean
# and Press and the two jerks add an overhead press or a dip under the bar
# after the rack, which none of these four do - they finish at the
# shoulders. The Kettlebell Swing throws the bell out to chest height on
# straight arms and never racks it; the Deadlift and its kin end standing
# with the bar at the hips. The power clean is the only one of the four that
# starts and finishes on the floor.
#
# Sources (what each is used for is in notes_1029_clean.md):
# - Geisler S, Havers T, Isenmann E, Schulze J, Lourens LK, Nowak J, Held S,
#   Haff GG 2023, J Sports Sci Med 22(4):778-789, doi 10.52082/jssm.2023.778
#   (abstract read 2026-10-29): 27 weightlifters at three levels, two reps
#   each of the hang power clean, hang power snatch, hang clean pull and
#   hang snatch pull at 50, 70 and 90% 1RM, with EMG of the vastus
#   lateralis, gluteus maximus, erector spinae, rectus abdominis and
#   trapezius normalised to each muscle's MVIC. In beginners the rectus
#   abdominis and erector spinae differed between the hang power clean and
#   the hang clean pull at 70 and 90% 1RM; the trapezius was greater in the
#   pull for the elite group at the lighter loads; and the authors found no
#   differences between expertise levels at all. No hamstring was measured,
#   and the abstract publishes no percentage of MVIC, so no number from it
#   is quoted and no muscle is ranked against another on it.
# - Lyons BC, Mayo JJ, Tucker WS, Wax B, Hendrix RC 2017, J Strength Cond
#   Res 31(9):2363-2370, doi 10.1519/JSC.0000000000001771, PMID 28394829
#   (abstract as cited in notes_1012_kb.md, 2026-10-12, and re-checked
#   2026-10-29): 14 resistance-trained men, one-arm kettlebell swing, snatch
#   and clean at a self-selected 8-10RM. The external oblique was more
#   active in the snatch and the clean than in the swing; the erector spinae
#   was higher in the swing than the snatch; the vastus lateralis higher in
#   the swing than the clean; and the anterior and posterior deltoids,
#   biceps brachii, biceps femoris and gluteus maximus did not differ
#   between the three. The participants were not experienced kettlebell
#   lifters, which the authors note themselves.
# - The library's own Clean and Press entry, written in an earlier round:
#   Gluteus Maximus 0.70, Quadriceps 0.62, Hamstrings 0.50, Trapezius 0.70,
#   Erector Spinae 0.55 and Biceps Brachii 0.30. These four keep those
#   fractions, because they are the same pull, and move the ranks to follow
#   each model's paint (the README's rule: a rank change keeps the
#   fraction). The Suitcase Carry's Obliques 0.60, Trapezius 0.44 and
#   Rectus Abdominis 0.30 are the one-arm anchors the Kettlebell Clean uses.

from common_1_50 import *

NAMES = ["Barbell Power Clean", "Hang Clean", "Dumbbell Hang Clean", "Kettlebell Clean"]

# Every model paints the same thing: the three hamstrings and the three
# glutes bright, the quadriceps, erector spinae, the three trapezius parts,
# the rhomboid major and the anterior deltoid dim (plus the biceps on the
# three that hold a bar or a bell in both hands). The rig lights the three
# glutes as one group and the owner has not split that paint (2026-10-30),
# so they are one Gluteus Maximus row and the copy says glutes, not medius.
PULL_ROWS = [("Gluteus Maximus", P, HI, 0.70), ("Quadriceps", S, MOD, 0.62),
             ("Trapezius", S, HI, 0.70), ("Erector Spinae", S, MOD, 0.55),
             ("Hamstrings", P, MOD, 0.50), ("Anterior Deltoid", S, LOW, 0.30),
             ("Biceps Brachii", S, LOW, 0.30)]


def pull_glows(name, dx=0.0, dy=0.0):
    """The bright paint: glutes and hamstrings, seen from behind."""
    return [glow(name, ["pelvis", "thigh_L"], A, 0.55, rx=0.11, ry=0.07, dx=dx, dy=dy),
            glow(name, ["patella_L", "thigh_L"], A, 0.50, rx=0.08, ry=0.08, dx=dx, dy=dy),
            glow(name, ["spine", "chest"], SOFT, 0.28, rx=0.08, ry=0.06)]


# --------------------------------------------------------- power clean

ex(name="Barbell Power Clean", var="barbellPowerClean",
   # Rear three-quarter. The lifter is a column up the middle (u 0.35-0.69)
   # from the head at v 0.27 to the feet at v 0.73, with the bar sweeping
   # up through it, so both gutters are only usable where the body is
   # narrow: left of u 0.35 and right of u 0.69. Row 0.16 is above
   # everything, row 0.80 below the feet, and the three middle rows take a
   # pill only on the side the body leaves open at that height. Round 1 put
   # the catch pill on the right of row 0.32: the 2.04 m bar crosses the
   # whole frame at v 0.30-0.33 once it is racked, plates included, so that
   # row is unusable and both arm pills share the top row instead, above
   # everything (the head never rises past v 0.27). The bar pill sits left
   # at 0.48, kept to 15 characters so it stops at u 0.318, clear of the far
   # hand at 0.35; the thighs reach u 0.69, which closes the right side of
   # that row.
   overrides={"rack": (0.14, "trailing"), "catch": (0.14, "leading"),
              "pull": (0.50, "leading"), "setup": (0.86, "leading"),
              "extend": (0.86, "trailing")},
   annotations=[
       ("setup", "Flat back at the floor", "spine"),
       ("pull", "Bar close", "hand_L"),
       ("extend", "Push the floor away", "foot_L"),
       ("catch", "Elbows whip through", "forearm_L"),
       ("rack", "Elbows up in the rack", "chest"),
   ],
   cues={
       "setup": ("Start Position",
                 "You set up over the bar with a flat back, hips higher than the knees and the shoulders just in front of it.",
                 "In the model the trunk starts 62 degrees forward with the knees at 98 and the hips at 57, and the back holds that shape while the bar leaves the floor. A back that rounds here loses the pull before it starts, because the hips can no longer drive against a long spine.",
                 "Rounding the lower back over the bar, or starting with the hips already high and the chest down.",
                 "Set your feet about hip-width, take the bar a bit wider than your shoulders, drop your hips until your back is flat, and brace before you pull."),
       "pull": ("First Pull",
                "Off the floor the bar comes up slowly and stays close to your legs; the hips and shoulders rise together.",
                "The model takes a full second over the first half: the pelvis rises from 0.58 m to 0.72 while the trunk comes up from 62 degrees to 27, and the knees open only from 98 to 111. Keeping the bar close keeps the load over your feet, where you can push against it.",
                "Snatching the bar off the floor with the hips, so the chest drops and the bar swings away.",
                "Push the floor away steadily, let the bar brush up your shins and thighs, and keep your shoulders over it until it passes your knees."),
       "extend": ("Second Pull",
                  "When the bar reaches your hips you drive hard: knees and hips open together and the heels come off the floor.",
                  "This is the part that actually throws the bar. In the model the knees go to 151 degrees, the hips to 169 and the trunk ends 8 degrees behind vertical, with the heels 6 cm up, all inside half a second, and the arms are still almost straight at 142 degrees while it happens.",
                  "Pulling early with the arms, so the legs never finish and the bar stalls at the hips.",
                  "Drive through the whole foot until your body is one long line, let the heels leave the floor, and keep the arms long until then."),
       "catch": ("The Catch",
                 "Only once the legs have finished do the elbows whip through and the knees re-bend to meet the bar.",
                 "The model catches in a quarter-squat: the knees fold back from 151 degrees to 101 as the elbows go from 142 to 52 and the bar arrives at 1.16 m. Dropping under is what lets you catch a bar you could never curl up - the legs put it there and the body goes to meet it.",
                 "Standing straight up and trying to pull the bar the last part of the way with the arms.",
                 "As the bar peaks, pull yourself under it: spin the elbows around fast and bend the knees to receive it."),
       "rack": ("Rack Position",
                "You finish standing tall with the bar on the front of your shoulders and the elbows up.",
                "The model stands out of the catch to 174 degrees at the knees with the elbows at 43 and holds the rack for two seconds. Elbows that stay up give the bar a shelf on the shoulders; elbows that drop leave it hanging on the hands and wrists.",
                "Finishing with the elbows pointing down, so the bar rolls onto the wrists.",
                "Stand all the way up, keep the elbows high in front of you and let the bar rest on your shoulders, not in your hands."),
   },
   # Rows follow the paint (see PULL_ROWS above); the fractions are the
   # library's Clean and Press, the same pull with a press on the end.
   # Quadriceps 0.62 sits above Hamstrings 0.50 while ranking below it: the
   # fraction is kept from that entry and the rank follows this model's
   # paint, as the README's rank-change rule asks. Anterior Deltoid 0.30 is
   # an estimate for a catch that only guides the bar onto the shoulders;
   # Geisler 2023 measured the hang power clean but published no percentage
   # of MVIC, so nothing here is ranked on it.
   activation=PULL_ROWS,
   stabilisers=["forearms", "core", "calves", "rhomboids"],
   comparison=("ARMS PULLING EARLY", "Legs finish, then the elbows go", "Arms bend before the hips open",
               "The legs and hips throw the bar; the arms only turn over once it is already rising.",
               "Bending the arms early caps the pull at what they can lift and leaves the legs with nothing to finish."),
   glows=pull_glows("Barbell Power Clean"))

SETUP["Barbell Power Clean"] = [
    "Load a bar on the floor and stand with your feet about hip-width, the bar over the middle of your feet.",
    "Take an overhand grip a little wider than your shoulders and drop your hips until your back is flat and your shoulders are just in front of the bar.",
    "Brace your trunk and take the slack out of the bar before the first pull.",
    "Between reps, lower the bar under control to the floor and reset your back rather than bouncing it.",
]

# ----------------------------------------------------------- hang clean

ex(name="Hang Clean", var="hangClean",
   # The same rear three-quarter column (u 0.36-0.64, head v 0.27, feet
   # v 0.73) but narrower, because nothing happens on the floor: the bar
   # works between v 0.32 and 0.48. Rows 0.16 and 0.80 are clear across the
   # frame; in the middle the head ends at u 0.55 and the thighs at u 0.59,
   # so the right gutter opens from u 0.64 and the left one up to u 0.36.
   # As in the power clean, the racked bar fills v 0.30-0.33 right across
   # the frame, so nothing goes on row 0.32 and both arm pills take the top
   # row.
   overrides={"rack": (0.14, "trailing"), "catch": (0.14, "leading"),
              "hang": (0.68, "leading"), "dip": (0.68, "trailing"),
              "extend": (0.86, "leading")},
   annotations=[
       ("hang", "Start at the hips", "hand_L"),
       ("dip", "Short dip, long back", "patella_L"),
       ("extend", "Drive through the floor", "foot_L"),
       ("catch", "Elbows whip through", "forearm_L"),
       ("rack", "Elbows up in the rack", "chest"),
   ],
   cues={
       "hang": ("The Hang",
                "Each rep starts standing with the bar hanging at your hips, arms long.",
                "The model begins at 0.92 m with the knees at 175 degrees and the trunk 10 degrees forward, and every rep returns to exactly that. Starting from the hang takes the floor out of the lift, so the whole rep is the hip drive and the catch - 0.60 m of bar travel against 1.24 m in the power clean.",
                "Letting the bar hang off the shoulders with a rounded upper back between reps.",
                "Stand tall with the bar against your thighs, shoulders back, arms long, and set your back before each rep."),
       "dip": ("The Dip",
               "You push the hips back and let the bar slide down to just above the knee, then change direction.",
               "The model dips to a 37-degree trunk angle with the knees at 150 and the bar at 0.79 m - just past the knee, not to the floor. The point is to stretch the hips, not to do a squat: the knees bend only 25 degrees while the trunk does the travelling.",
               "Squatting the bar down to the shins, so the hips have nothing left to open.",
               "Hinge at the hips, let the bar brush down your thighs to just above the knee, and keep your back flat as you change direction."),
       "extend": ("Hip Drive",
                  "From there you snap the hips open and drive through the floor.",
                  "In the model the trunk comes from 37 degrees back to 15 in half a second and the heels lift 5 cm as the bar passes the hips. That is the whole engine of the lift: the bar only rises because the hips threw it.",
                  "Pulling the bar up the body with the arms and shoulders while the hips stay folded.",
                  "Drive your hips through to standing and let the bar ride up close to you; the arms stay long until the hips have finished."),
       "catch": ("The Catch",
                 "The elbows whip under the bar while the knees bend to meet it.",
                 "The model receives it with the elbows at 62 degrees and the knees back at 110, then stands up to 175. Catching in a small dip is what makes the bar feel light; waiting for it with straight legs means curling the last part of the way.",
                 "Trying to muscle the bar to the shoulders with straight legs.",
                 "As the bar peaks, drop into a quarter-squat and spin your elbows through fast to receive it."),
       "rack": ("Rack Position",
                "The rep ends standing with the bar on the shoulders and the elbows high.",
                "The model holds the rack for a second and a half with the elbows at 43 degrees before the next rep. The shelf is the shoulders, not the hands - the bar should sit against the front of them with the fingers only holding it in place.",
                "Catching with low elbows so the bar lands on the wrists.",
                "Finish tall, elbows up and forward, bar resting on the front of your shoulders."),
   },
   activation=PULL_ROWS,
   stabilisers=["forearms", "core", "calves", "rhomboids"],
   comparison=("SQUATTING THE DIP", "Hips back, bar above the knee", "Knees bend, bar drops to the shins",
               "A short hinge keeps the hips loaded and leaves them something to open against.",
               "Squatting the bar down turns the dip into a half squat and the pull into an arm pull."),
   glows=pull_glows("Hang Clean"))

SETUP["Hang Clean"] = [
    "Take a loaded bar from a rack or deadlift it up, hands a little wider than your shoulders, overhand.",
    "Stand with your feet about hip-width, the bar resting against your thighs and your arms long.",
    "Set your shoulders back and brace your trunk before the first dip.",
    "Between reps, let the bar come back down to your thighs under control and reset there.",
]

# -------------------------------------------------- dumbbell hang clean

ex(name="Dumbbell Hang Clean", var="dumbbellHangClean",
   # Closer framing (zoom 0.862): the body runs u 0.40-0.78 with the head at
   # v 0.18 and the feet at v 0.81, and the bells swing wide - the working
   # hand sweeps u 0.62-0.78. So the left gutter (clear to u 0.40) carries
   # three pills and the top row, above the head, carries the other two.
   overrides={"rack": (0.14, "leading"), "catch": (0.14, "trailing"),
              "hang": (0.68, "leading"), "extend": (0.86, "leading"),
              "dip": (0.86, "trailing")},
   annotations=[
       ("hang", "Bells at the thighs", "hand_R"),
       ("dip", "Hinge, not squat", "patella_L"),
       ("extend", "Drive the hips through", "foot_L"),
       ("catch", "Elbows under fast", "forearm_L"),
       ("rack", "Bells on the shoulders", "chest"),
   ],
   cues={
       "hang": ("The Hang",
                "You start standing with a dumbbell in each hand at your thighs, arms hanging straight.",
                "The model starts with the elbows at 173 degrees and the hands 0.69 m apart at 0.92 m, and comes back to that between reps. Two bells let each arm find its own path, which is what makes this version easier on the wrists than a bar.",
                "Starting with the bells already bent up, so the arms are doing the first part of the lift.",
                "Stand tall with a bell beside each thigh, arms long, shoulders set, and brace before the dip."),
       "dip": ("The Dip",
               "Push the hips back into a short hinge; the knees only soften.",
               "In the model the trunk tips to 26 degrees and the knees bend from 175 to 137 - a hinge, not a squat. The bells drop barely 10 cm, to 0.83 m, because the dip is there to load the hips rather than to lower the weight.",
               "Dropping into a squat with the chest upright, so the hips cannot drive.",
               "Hinge back at the hips with a flat back, let the bells travel down your thighs a little, and keep your weight through the middle of your feet."),
       "extend": ("Hip Drive",
                  "Snap the hips open and drive through the floor until you are standing tall.",
                  "The heels lift 5 cm as the hips open in the model, and the bells rise past the hips on that drive alone, with the elbows still 172 degrees. Everything above the hips is just along for the ride at this point.",
                  "Shrugging and curling the bells up instead of driving with the legs and hips.",
                  "Drive your hips forward hard and stand tall, keeping the arms long until the bells are already moving."),
       "catch": ("The Catch",
                 "The elbows drop under the bells fast and the knees bend a little to receive them.",
                 "The model catches with the elbows at about 68 degrees and the knees at 118, then stands up and finishes with the elbows at 31 and 35. Each bell swings out to 0.93 m apart at the widest and comes back in to 0.42 m at the shoulders, so the catch is also where you bring them back to you.",
                 "Letting the bells swing out wide and catching them away from the body with straight arms.",
                 "Turn the elbows under quickly, bend the knees to meet the bells, and bring them in against your shoulders as you stand."),
       "rack": ("Rack Position",
                "Each rep finishes standing with the bells resting on the front of your shoulders.",
                "The model holds that for a full second with the hands at 1.47 m before lowering. Resting them on the shoulders rather than holding them above means the set can go on long after the arms would have given out.",
                "Holding the bells in the air in front of the shoulders instead of letting them rest on them.",
                "Stand tall, elbows forward and under, and let the bells sit against the front of your shoulders between reps."),
   },
   # This model does not paint the biceps, so there is no Biceps Brachii row
   # here, unlike the other three cleans; everything else is painted the
   # same, so the rest of the rows and their fractions are unchanged.
   activation=[r for r in PULL_ROWS if r[0] != "Biceps Brachii"],
   stabilisers=["forearms", "core", "calves", "rhomboids", "biceps brachii"],
   comparison=("CURLING THE BELLS", "Hips drive, elbows turn under", "Arms curl the bells to the shoulders",
               "With the hips doing the work the bells are already rising when the elbows turn under them.",
               "Curling them up limits the lift to what your arms can carry and takes the legs out of it."),
   glows=pull_glows("Dumbbell Hang Clean"))

SETUP["Dumbbell Hang Clean"] = [
    "Pick up a dumbbell in each hand and stand with your feet about hip-width apart.",
    "Let the bells hang beside your thighs with your arms long and your shoulders set back.",
    "Brace your trunk, then hinge back a little to start the first rep.",
    "Between reps, lower the bells back to your thighs under control rather than dropping them.",
]

# ---------------------------------------------------- kettlebell clean

ex(name="Kettlebell Clean", var="kettlebellClean",
   # One-arm, seen from behind: the body runs u 0.30-0.70, the head at
   # v 0.18 and the feet at v 0.81, with the working (left) hand sweeping
   # u 0.48-0.60 between v 0.25 and 0.53 and the free hand parked at
   # u 0.30-0.42. The left gutter is only clear to u 0.30, so the two upper
   # pills go right of the head (which ends at u 0.61) and the lower three
   # left, where the frame is empty below the free hand. The bell pill is
   # on the left of row 0.32: on the right it sat on the racked bell, which
   # reaches u 0.72 there.
   overrides={"rack": (0.14, "trailing"), "swing": (0.14, "leading"),
              "hinge": (0.50, "leading"), "free": (0.68, "leading"),
              "feet": (0.86, "leading")},
   annotations=[
       ("swing", "Bell close to the body", "hand_L"),
       ("rack", "Bell rests on the arm", "chest"),
       ("hinge", "Hips back", "pelvis"),
       ("free", "Free arm stays quiet", "hand_R"),
       ("feet", "Heels stay down", "foot_L"),
   ],
   cues={
       "swing": ("Bell Path",
                 "The bell drops between your legs and comes back up close to your body, not out in an arc.",
                 "In the model the hand falls to 0.74 m with the arm straight and returns to the rack at 1.40 m, a travel of 0.85 m, and the bell stays in tight all the way. A bell that swings out flips over and bangs down on the wrist; keeping it close lets it roll around the hand instead.",
                 "Letting the bell swing out in front and flip over onto the back of the wrist.",
                 "Guide the bell back between your thighs and keep it brushing close to you as it comes up, so it rolls around your hand at the top."),
       "rack": ("Rack Position",
                "The bell finishes resting on the forearm and against the shoulder, elbow tucked in.",
                "The model racks at 41 degrees of elbow bend with the hand at 1.40 m and holds it there between reps. In the rack the bell sits on you rather than in your grip, so you can keep going long after your forearm would have given out.",
                "Holding the bell off the body with a bent arm, so the grip and the shoulder carry it.",
                "Bring your elbow in against your ribs and let the bell settle on your forearm and shoulder before the next rep."),
       "hinge": ("Hip Hinge",
                 "Every rep is a hinge: the hips go back, the knees stay fairly straight, then the hips snap through.",
                 "The model folds the trunk to 37 degrees on the first cycle and 52 on the deepest, with the knees at 133 and 122, then stands tall again at 176 degrees of knee and 168 of hip. The lift is the hip snap, not an arm pull.",
                 "Squatting the bell down and up, or pulling it to the shoulder with the arm.",
                 "Push the hips back with a flat back, let the bell swing between your thighs, then drive the hips through and let the bell float up."),
       "free": ("Free Arm",
                "The arm that is not working hangs still at your side.",
                "In the model it never moves: the right elbow holds 168 degrees and the hand stays at 0.92 m across the whole clip. Swinging it for momentum is where one-arm lifts start to twist, and the twist is what the trunk then has to fight.",
                "Throwing the free arm to help the bell up, so the shoulders turn with it.",
                "Let the free arm hang, or keep it tucked, and keep both shoulders facing the same way for the whole set."),
       "feet": ("Base",
                "The feet stay planted about hip-width apart and the heels stay down.",
                "The model keeps its ankles 0.37 to 0.39 m apart and the heels on the floor for every rep - unlike the barbell cleans here, there is no heel lift in this one. Pressing the floor away is what the hips snap against.",
                "Coming up onto the toes or letting the feet shuffle as the bell swings.",
                "Plant both feet about hip-width apart, grip the floor with your toes, and keep your heels down through the swing."),
   },
   # Same paint as the other three on the legs and back, plus the obliques
   # bright on the side away from the bell and the rectus abdominis dim:
   # the one-arm load is what the trunk has to resist. Obliques 0.60,
   # Trapezius 0.44 and Rectus Abdominis 0.30 are the library's Suitcase
   # Carry, its nearest one-arm neighbour, rather than the Clean and
   # Press's two-handed 0.70 trapezius. Lyons 2017 found the external
   # oblique more active in the one-arm kettlebell clean than in the swing,
   # which is why the oblique row leads the dim ones; it found no
   # difference between those lifts in the gluteus maximus, biceps femoris,
   # deltoids or biceps, so none of them is re-ranked on it.
   activation=[("Gluteus Maximus", P, HI, 0.70), ("Obliques", P, MOD, 0.60),
               ("Quadriceps", S, MOD, 0.62), ("Erector Spinae", S, MOD, 0.55),
               ("Hamstrings", P, MOD, 0.50), ("Trapezius", S, MOD, 0.44),
               ("Anterior Deltoid", S, LOW, 0.30), ("Rectus Abdominis", S, LOW, 0.30)],
   stabilisers=["forearms", "biceps brachii", "calves", "rhomboids"],
   comparison=("BELL FLIPS OVER", "Bell stays close, rolls round", "Bell swings out and bangs down",
               "Kept close, the bell rolls around the hand and lands softly on the forearm.",
               "Let out in an arc, it flips over the hand and hits the wrist on the way into the rack."),
   glows=pull_glows("Kettlebell Clean"))

SETUP["Kettlebell Clean"] = [
    "Stand a kettlebell on the floor just in front of you and set your feet about hip-width apart.",
    "Hinge at the hips with a flat back, take the handle in one hand and tilt the bell toward you.",
    "Hike it back between your thighs to start the first rep, with the free arm hanging at your side.",
    "Work one side for the whole set, then set the bell down and swap hands.",
]
