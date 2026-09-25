# Setup steps for every trainer exercise, keyed by library name. Written to
# match what each shipped model actually shows (bench angle, seated/standing,
# grip, attachment), so keep them in sync when a model is re-exported.
# gen.py emits these as `ExerciseContent.setup`.

SETUP = {
    # Chest
    "Barbell Bench Press": [
        "Lie on the flat bench with your eyes under the bar.",
        "Grip the bar slightly wider than shoulder-width.",
        "Plant your feet and pull your shoulder blades together.",
        "Unrack to straight arms, bar over your shoulders.",
    ],
    "Incline Barbell Bench Press": [
        "Set the bench to about 30° and lie back, eyes under the bar.",
        "Grip the bar slightly wider than shoulder-width.",
        "Plant your feet and pull your shoulder blades back and down.",
        "Unrack to straight arms, bar over your collarbones.",
    ],
    "Decline Barbell Bench Press": [
        "Hook your legs under the foot rollers of the decline bench.",
        "Lie back with your eyes under the bar.",
        "Grip the bar slightly wider than shoulder-width.",
        "Unrack to straight arms, bar over your shoulders.",
    ],
    "Dumbbell Bench Press": [
        "Sit on the end of a flat bench, dumbbells on your thighs.",
        "Lie back and bring the dumbbells beside your chest.",
        "Plant your feet and pull your shoulder blades together.",
        "Press to straight arms, palms facing forward.",
    ],
    "Incline Dumbbell Press": [
        "Set the bench to about 30° and sit with the dumbbells on your thighs.",
        "Lie back and bring the dumbbells beside your upper chest.",
        "Plant your feet and pull your shoulder blades together.",
        "Press to straight arms, palms facing forward.",
    ],
    "Dumbbell Fly": [
        "Lie on a flat bench with your feet flat on the floor.",
        "Press the dumbbells over your chest, palms facing each other.",
        "Unlock the elbows slightly and keep that bend throughout.",
    ],
    "Incline Dumbbell Fly": [
        "Set the bench to about 30° and lie back.",
        "Press the dumbbells over your upper chest, palms facing each other.",
        "Unlock the elbows slightly and keep that bend throughout.",
    ],
    "Chest Press Machine": [
        "Set the seat so the handles line up with your mid-chest.",
        "Sit with your back flat against the pad, feet on the floor.",
        "Grip the handles with your elbows just below shoulder height.",
    ],
    "Pec Deck Fly": [
        "Set the seat so the handles sit at chest height.",
        "Sit tall with your back against the pad.",
        "Take the handles out wide with a slight bend in the elbows.",
    ],
    "Cable Fly": [
        "Set both pulleys at about shoulder height.",
        "Take a handle in each hand and step forward between the stacks.",
        "Stand in a split stance, leaning slightly forward, elbows soft.",
    ],
    "Low-to-High Cable Fly": [
        "Set both pulleys at their lowest position.",
        "Take a handle in each hand and step forward to the centre.",
        "Start with the hands low beside your hips, elbows soft.",
    ],
    # Back
    "Deadlift": [
        "Stand with feet hip-width, the bar over mid-foot.",
        "Hinge down and grip the bar just outside your knees.",
        "Drop your hips until your shins touch the bar.",
        "Chest up, back flat, pull the slack out of the bar.",
    ],
    "Barbell Bent-Over Row": [
        "Hold the bar with an overhand, shoulder-width grip.",
        "Soften your knees and hinge forward to about 45°.",
        "Brace with a flat back, the bar hanging below your shoulders.",
    ],
    "Dumbbell Row": [
        "Hold a dumbbell in each hand, palms facing in.",
        "Soften your knees and hinge forward to about 45°.",
        "Brace with a flat back, the dumbbells hanging below your shoulders.",
    ],
    "One-Arm Dumbbell Row": [
        "Put one knee and the same-side hand on a flat bench.",
        "Plant the other foot out to the side on the floor.",
        "Hold the dumbbell at arm's length, back flat and level.",
    ],
    "Chest-Supported Dumbbell Row": [
        "Set an incline bench to about 30–45°.",
        "Lie chest-down on it with your feet on the floor.",
        "Let the dumbbells hang straight down, palms facing in.",
    ],
    "Pull-Up": [
        "Grip the bar overhand, slightly wider than shoulder-width.",
        "Hang with straight arms and your shoulders pulled down.",
        "Cross your ankles and brace your core.",
    ],
    "Chin-Up": [
        "Grip the bar underhand, about shoulder-width apart.",
        "Hang with straight arms and your shoulders pulled down.",
        "Cross your ankles and brace your core.",
    ],
    "Lat Pulldown": [
        "Adjust the thigh pad so your legs are locked in.",
        "Take a wide overhand grip on the bar.",
        "Sit down tall with your arms straight overhead.",
    ],
    "Close-Grip Lat Pulldown": [
        "Adjust the thigh pad so your legs are locked in.",
        "Take a close grip, hands about shoulder-width apart.",
        "Sit down tall with your arms straight overhead.",
    ],
    "Seated Cable Row": [
        "Sit on the bench with your feet braced on the foot plate.",
        "Bend your knees slightly and grab the handle.",
        "Sit tall with your arms extended and your chest up.",
    ],
    "Straight-Arm Pulldown": [
        "Set the pulley high and grip the bar with both hands.",
        "Step back and hinge slightly at the hips.",
        "Start with straight arms at shoulder height, elbows soft.",
    ],
    "T-Bar Row": [
        "Straddle the bar with feet about shoulder-width apart.",
        "Hinge to about 45° and grip the handle just below the plates.",
        "Brace with a flat back and your arms extended.",
    ],
    "Chest-Supported Row Machine": [
        "Set the seat so the handles line up with your lower chest.",
        "Sit with your chest against the pad, feet planted.",
        "Reach forward and grab the handles with straight arms.",
    ],
    "High Row Machine": [
        "Adjust the seat and thigh pad so your legs are locked in.",
        "Reach up and grab the handles with straight arms.",
        "Sit tall, chest up and shoulders down.",
    ],
    "Back Extension": [
        "Set the hip pad just below your hip bones.",
        "Lock your heels under the ankle roller.",
        "Cross your arms over your chest, body in a straight line.",
    ],
    # Legs
    "Back Squat": [
        "Set the bar on your upper traps, hands just outside the shoulders.",
        "Step back and set your feet shoulder-width, toes slightly out.",
        "Take a deep breath and brace, chest tall.",
    ],
    "Front Squat": [
        "Rest the bar on the front of your shoulders, close to the throat.",
        "Fingertips under the bar, elbows pointing forward and high.",
        "Feet shoulder-width, toes slightly out.",
    ],
    "Goblet Squat": [
        "Hold one dumbbell upright against your chest.",
        "Tuck your elbows under the dumbbell.",
        "Feet shoulder-width, toes slightly out, chest tall.",
    ],
    "Walking Lunge": [
        "Hold a dumbbell in each hand at your sides.",
        "Stand tall with your feet hip-width apart.",
        "Clear space ahead to walk forward in long steps.",
    ],
    "Reverse Lunge": [
        "Hold a dumbbell in each hand at your sides.",
        "Stand tall with your feet hip-width apart.",
        "Brace your core before each step back.",
    ],
    "Leg Press": [
        "Sit with your back and hips flat against the pad.",
        "Place your feet shoulder-width in the middle of the platform.",
        "Press the platform up and release the safety handles.",
    ],
    "Hack Squat": [
        "Stand on the platform with your back against the pad.",
        "Set your shoulders under the pads, feet shoulder-width.",
        "Hold the handles and release the safety.",
    ],
    "Leg Extension": [
        "Set the back pad so your knees line up with the machine's pivot.",
        "Set the ankle pad just above your feet.",
        "Sit tall and hold the side handles.",
    ],
    "Smith Machine Squat": [
        "Set the bar at shoulder height and step under it.",
        "Bar on your upper traps, feet slightly in front of the bar.",
        "Turn the bar to unhook it and brace your core.",
    ],
    "Sissy Squat": [
        "Lock your heels under the foot pad, shins against the front pad.",
        "Stand tall with your hips fully extended.",
        "Hold your hands in front of your chest for balance.",
    ],
    "Romanian Deadlift": [
        "Hold the bar at hip height with an overhand, shoulder-width grip.",
        "Feet hip-width, knees slightly bent.",
        "Shoulders back and back flat, bar against your thighs.",
    ],
    # Shoulders
    "Barbell Overhead Press": [
        "Hold the bar at your collarbones, hands just outside the shoulders.",
        "Stand with your feet hip-width and knees locked.",
        "Squeeze your glutes and brace your core.",
    ],
    "Dumbbell Shoulder Press": [
        "Set the bench upright and sit with your back against the pad.",
        "Kick the dumbbells up to shoulder height.",
        "Palms forward, forearms vertical, feet flat and wide.",
    ],
    "Arnold Press": [
        "Set the bench upright and sit with your back against the pad.",
        "Hold the dumbbells in front of your chin, palms facing you.",
        "Plant your feet flat and wide.",
    ],
    "Machine Shoulder Press": [
        "Set the seat so the handles are at shoulder height.",
        "Sit with your back flat against the pad, feet on the floor.",
        "Grip the handles with your elbows under your wrists.",
    ],
    "Dumbbell Lateral Raise": [
        "Stand tall with a dumbbell in each hand at your sides.",
        "Feet hip-width, knees soft.",
        "Palms facing in, a slight bend in the elbows.",
    ],
    "Cable Lateral Raise": [
        "Set the pulley at its lowest position.",
        "Stand side-on and take the handle in the far hand.",
        "Hold the frame with your free hand, handle in front of your hips.",
    ],
    "Machine Lateral Raise": [
        "Set the seat so your shoulders line up with the pivots.",
        "Sit tall with the pads against the outsides of your arms.",
        "Hold the handles lightly.",
    ],
    "Dumbbell Front Raise": [
        "Stand with a dumbbell in each hand in front of your thighs.",
        "Palms facing your body, elbows softly bent.",
        "Feet hip-width, core braced.",
    ],
    "Reverse Dumbbell Fly": [
        "Hold a dumbbell in each hand, palms facing in.",
        "Hinge forward until your torso is nearly parallel to the floor.",
        "Let the dumbbells hang under your chest, elbows soft.",
    ],
    "Reverse Pec Deck": [
        "Set the handles to the rear position, at shoulder height.",
        "Sit facing the machine with your chest against the pad.",
        "Grip the handles with straight arms.",
    ],
    "Face Pull": [
        "Set the pulley at upper-chest to face height with a rope.",
        "Hold the rope ends with your palms facing each other.",
        "Step back until your arms are straight, feet staggered.",
    ],
    "Cable Rear Delt Fly": [
        "Set both pulleys at shoulder height.",
        "Cross the cables: left handle in your right hand, right in your left.",
        "Step back to the middle with your arms straight in front.",
    ],
    # Arms
    "Barbell Curl": [
        "Hold the bar underhand, hands shoulder-width apart.",
        "Stand tall with straight arms, the bar against your thighs.",
        "Elbows by your sides, knees soft.",
    ],
    "Triceps Pushdown": [
        "Attach a straight bar to a high pulley.",
        "Grip it overhand with your hands shoulder-width apart.",
        "Elbows at your sides, lean slightly forward.",
    ],
    "Rope Pushdown": [
        "Attach a rope to a high pulley.",
        "Grip the rope ends with your palms facing each other.",
        "Elbows at your sides, lean slightly forward.",
    ],
    "Single-Arm Cable Pushdown": [
        "Attach a single handle to a high pulley.",
        "Grip it with one hand, palm down.",
        "Elbow at your side, free hand on your hip.",
    ],
    "Overhead Cable Triceps Extension": [
        "Attach a rope to a low pulley.",
        "Face away from the stack with the rope behind your head.",
        "Staggered stance, elbows pointing forward.",
    ],
    "Dumbbell Overhead Triceps Extension": [
        "Hold one dumbbell with both hands under its top plate.",
        "Press it overhead to straight arms.",
        "Feet hip-width, ribs down, core braced.",
    ],
    "Skull Crusher": [
        "Lie on a flat bench with your feet flat on the floor.",
        "Hold an EZ bar with a narrow overhand grip.",
        "Press it up, arms tilted slightly back toward your head.",
    ],
    "Bench Dip": [
        "Sit on the edge of a bench, hands beside your hips.",
        "Fingers forward, slide your hips off the bench.",
        "Legs out with heels on the floor, arms straight.",
    ],
    "Assisted Dip": [
        "Select an assistance weight on the stack.",
        "Grip the dip handles and kneel on the pad.",
        "Start with straight arms, shoulders down.",
    ],
    "Bulgarian Split Squat": [
        "Stand about a stride in front of a knee-height bench.",
        "Rest the laces of your rear foot on the bench.",
        "Hold a dumbbell in each hand at your sides.",
    ],
    "Bulgarian Split Squat (Lean)": [
        "Stand about a stride in front of a knee-height bench.",
        "Rest the laces of your rear foot on the bench.",
        "Hands on your hips, lean forward about 40° from the hips.",
    ],
    # Legs2 batch and re-exports (2026-09-24)
    "Dumbbell Romanian Deadlift": [
        "Stand hip-width with a dumbbell in each hand in front of your thighs.",
        "Unlock your knees slightly and brace your trunk.",
        "Pull your shoulders back and keep the dumbbells against your legs.",
    ],
    "Stiff-Leg Deadlift": [
        "Stand hip-width holding the barbell at arm's length, overhand grip.",
        "Keep your knees almost straight, with just a slight bend.",
        "Brace your trunk and pull your shoulders back.",
    ],
    "Lying Leg Curl": [
        "Lie face down on the bench, knees just off the end of the pad.",
        "Set the roller on your lower legs, just above the heels.",
        "Hold the handles and press your hips into the pad.",
    ],
    "Seated Leg Curl": [
        "Sit with your back against the pad, knees in line with the pivot.",
        "Rest your lower legs on the roller, just above the heels.",
        "Lock the thigh pad down above your knees and hold the handles.",
    ],
    "Single-Leg Curl": [
        "Lie face down on the bench, knees just off the end of the pad.",
        "Set the roller above the heel of the working leg.",
        "Hold the handles and keep both hips pressed into the pad.",
    ],
    "Glute Bridge": [
        "Lie on your back on a mat, knees bent.",
        "Set your heels about a hand's length from your glutes, hip-width apart.",
        "Rest your arms flat beside you, palms down.",
    ],
    "Single-Leg Glute Bridge": [
        "Lie on your back on a mat, knees bent.",
        "Plant the working foot close to your glutes.",
        "Lift the other foot off the floor and rest your arms flat beside you.",
    ],
    "Cable Glute Kickback": [
        "Attach an ankle cuff to the low pulley and strap it to your working ankle.",
        "Face the stack and hold the frame with both hands.",
        "Step back until the cable is tight and hinge forward slightly.",
    ],
    "Cable Side Kick": [
        "Attach an ankle cuff to the low pulley and strap it to the far ankle.",
        "Stand side-on to the stack and hold the rail with your near hand.",
        "Let the working leg cross slightly in front, toes forward.",
    ],
    "Cable Hip Abduction": [
        "Attach an ankle cuff to the low pulley and strap it to the far ankle.",
        "Stand side-on to the stack, one hand on the balance post.",
        "Stand tall with the hips level and the standing knee soft.",
    ],
    "Hip Abduction Machine": [
        "Set the pads so your knees start close together.",
        "Sit back against the pad with your feet on the footrests.",
        "Place the pads on the outsides of your knees and hold the handles.",
    ],
    "Hip Abduction Machine (Lean)": [
        "Set the pads so your knees start close together.",
        "Sit with your feet on the footrests and the pads outside your knees.",
        "Hold the handles and lean forward from the hips.",
    ],
    "Step-Up": [
        "Stand facing a knee-height box, a dumbbell in each hand.",
        "Place your whole working foot flat on the box.",
        "Lean slightly forward over the top foot.",
    ],
    "Push-Up": [
        "Kneel on a mat with your hands slightly wider than your shoulders.",
        "Step your feet back, toes tucked, body in one straight line.",
        "Brace your abs and squeeze your glutes.",
    ],
    "Plank": [
        "Kneel on a mat and set your elbows under your shoulders.",
        "Step your feet back, toes tucked, hip-width apart.",
        "Lift your knees and hold a straight line from head to heels.",
    ],
    # Abs batch (2026-09-24)
    "Crunch": [
        "Lie on your back on a mat, knees bent, feet flat.",
        "Rest your fingertips behind your ears, elbows wide.",
        "Press your lower back gently into the mat.",
    ],
    "Reverse Crunch": [
        "Lie on your back on a mat, arms flat beside you.",
        "Lift your legs so your knees are bent about 90° over your hips.",
        "Keep your head and shoulders resting on the mat.",
    ],
    "Decline Crunch": [
        "Set the bench to a slight decline.",
        "Hook your ankles under the foot pads and lie back.",
        "Rest your fingertips behind your ears, or cross your arms on your chest.",
    ],
    "Cable Crunch": [
        "Attach a rope to the high pulley.",
        "Kneel on a mat about an arm's length from the stack.",
        "Hold the rope ends beside your head, hips over your knees.",
    ],
    "Hanging Knee Raise": [
        "Grip the bar just outside shoulder-width.",
        "Hang with straight arms, shoulders pulled slightly down.",
        "Let your legs hang still before the first rep.",
    ],
    "Hanging Leg Raise": [
        "Grip the bar just outside shoulder-width.",
        "Hang with straight arms, shoulders pulled slightly down.",
        "Keep your legs straight and together, and stop any swing.",
    ],
    "Captain's Chair Leg Raise": [
        "Step up and rest your forearms on the arm pads.",
        "Grip the handles and press your back against the pad.",
        "Let your legs hang straight below you.",
    ],
    "Ab Wheel Rollout": [
        "Kneel on a mat, knees hip-width apart.",
        "Hold the wheel handles under your shoulders, arms straight.",
        "Brace your abs and tuck your pelvis slightly.",
    ],
    "Side Plank": [
        "Lie on your side on a mat, legs straight and stacked.",
        "Place your elbow directly under your shoulder.",
        "Rest your top hand on your hip, then lift your hips.",
    ],
    "Russian Twist": [
        "Sit on a mat with your knees bent and heels on the floor.",
        "Hold a medicine ball at chest height.",
        "Lean back about 45° with a straight spine.",
    ],
    "Cable Wood Chop": [
        "Set a handle on the high pulley and stand side-on to the stack.",
        "Take a wide stance and hold the handle with both hands.",
        "Start with straight arms reaching up toward the pulley.",
    ],
    # Gated exercises re-exported, plus the lean lunge (2026-09-24)
    "Biceps Curl": [
        "Hold a dumbbell in each hand, palms facing forward.",
        "Stand tall, feet hip-width, arms straight by your sides.",
        "Draw your shoulders back and keep your elbows by your ribs.",
    ],
    "Squat": [
        "Stand with your feet a little wider than hip-width.",
        "Turn your toes slightly out.",
        "Raise your arms straight in front to shoulder height.",
        "Brace your core and lift your chest.",
    ],
    "Lunge": [
        "Stand tall with your hands on your hips.",
        "Step one foot forward about a stride's length.",
        "Lift your back heel and square your hips to the front.",
    ],
    "Lunge (Lean)": [
        "Stand tall with your hands on your hips.",
        "Step one foot forward about a stride's length and lift your back heel.",
        "Tilt your torso about 30° forward from the hips, back flat.",
    ],
    # Chest batch 101-131 (2026-09-25)
    "Barbell Floor Press": [
        "Set the bar low in a rack and lie on the floor under it, eyes below the bar.",
        "Bend your knees and set your feet flat, hip-width apart.",
        "Grip the bar slightly wider than shoulder-width.",
        "Pull your shoulder blades into the floor and unrack to straight arms.",
    ],
    "Smith Machine Bench Press": [
        "Set a flat bench under the bar so it lowers to your lower chest.",
        "Lie back with your feet planted and your eyes just below the bar.",
        "Grip slightly wider than shoulder-width and pull your shoulder blades together.",
        "Unhook the bar by turning it back off the hooks.",
    ],
    "Smith Machine Incline Press": [
        "Set the bench to about 30° under the bar.",
        "Sit back so the bar lowers to your upper chest.",
        "Grip slightly wider than shoulder-width and plant your feet.",
        "Pull your shoulder blades back and down, then unhook the bar.",
    ],
    "Smith Machine Decline Press": [
        "Set a decline bench under the bar, about 15° head-down.",
        "Hook your legs under the ankle roller and lie back.",
        "Line up so the bar lowers to your lower chest.",
        "Grip slightly wider than shoulder-width and unhook the bar.",
    ],
    "Dumbbell Floor Press": [
        "Sit on the floor with a dumbbell on each thigh.",
        "Lie back with your knees bent and feet flat, dumbbells beside your chest.",
        "Rest your upper arms on the floor at about 45° from your body.",
        "Press to straight arms over your chest.",
    ],
    "Single-Arm Dumbbell Bench Press": [
        "Lie on a flat bench with one dumbbell beside your chest.",
        "Plant your feet wider than your hips.",
        "Rest your free arm at your side and pull both shoulder blades back.",
        "Press the dumbbell to a straight arm over your shoulder.",
    ],
    "Alternating Dumbbell Bench Press": [
        "Lie on a flat bench with a dumbbell in each hand beside your chest.",
        "Plant your feet and pull your shoulder blades together.",
        "Press one dumbbell up while the other waits at your chest.",
        "Lower it back down, then press the other side.",
    ],
    "Neutral-Grip Dumbbell Press": [
        "Lie on a flat bench with a dumbbell in each hand.",
        "Turn your palms to face each other.",
        "Plant your feet and pull your shoulder blades together.",
        "Press to straight arms over your chest, elbows close to your sides.",
    ],
    "Dumbbell Squeeze Press": [
        "Lie on a flat bench with a dumbbell in each hand.",
        "Press the dumbbells together over your chest, palms facing in.",
        "Plant your feet and pull your shoulder blades together.",
        "Keep squeezing them together as you lower and press.",
    ],
    "Incline Dumbbell Squeeze Press": [
        "Set the bench to about 30° and lie back with a dumbbell in each hand.",
        "Press the dumbbells together over your upper chest, palms facing in.",
        "Plant your feet and pull your shoulder blades back and down.",
        "Keep squeezing them together as you lower and press.",
    ],
    "Dumbbell Pullover": [
        "Lie along a flat bench with your head at the end.",
        "Hold one dumbbell over your chest, both palms under the top plate.",
        "Plant your feet and keep a slight bend in your elbows.",
    ],
    "Barbell Pullover": [
        "Lie along a flat bench with your head near the end.",
        "Hold the bar over your chest, hands about shoulder-width apart.",
        "Plant your feet and keep a slight bend in your elbows.",
    ],
    "Iso-Lateral Chest Press": [
        "Set the seat so the handles line up with your mid-chest.",
        "Sit tall with your back on the pad and your feet flat.",
        "Grip both handles; press with one arm at a time.",
    ],
    "Incline Chest Press Machine": [
        "Set the seat so the handles line up with your upper chest.",
        "Sit back against the angled pad with your feet flat.",
        "Grip the handles with your wrists straight.",
    ],
    "Decline Chest Press Machine": [
        "Set the seat so the handles line up with your lower chest.",
        "Sit tall with your back on the pad and your feet flat.",
        "Grip the handles with your wrists straight.",
    ],
    "Plate-Loaded Chest Press": [
        "Load the same plates on both sides.",
        "Set the seat so the handles line up with your mid-chest.",
        "Sit tall with your back on the pad and your feet flat.",
        "Grip the handles with your wrists straight.",
    ],
    "Wide-Grip Chest Press Machine": [
        "Set the seat so the handles line up with your mid-chest.",
        "Sit tall with your back on the pad and your feet flat.",
        "Take the outer handles, wider than your shoulders.",
    ],
    "Cable Chest Press": [
        "Set both pulleys at chest height and take a handle in each hand.",
        "Face away from the stacks and step forward until the cables are tight.",
        "Stand in a staggered stance, handles beside your chest.",
    ],
    "Single-Arm Cable Chest Press": [
        "Set one pulley at chest height and take the handle in one hand.",
        "Face away from the stack and step forward into a staggered stance.",
        "Hold the handle beside your chest, elbow about 45° from your body.",
        "Keep your free arm by your side.",
    ],
    "Incline Cable Press": [
        "Set a bench to about 30° between two low pulleys.",
        "Take a handle in each hand and lie back.",
        "Plant your feet and pull your shoulder blades back and down.",
        "Start with the handles beside your upper chest.",
    ],
    "Decline Cable Press": [
        "Set a decline bench between two low pulleys.",
        "Take a handle in each hand and hook your legs under the roller.",
        "Lie back and pull your shoulder blades together.",
        "Start with the handles beside your lower chest.",
    ],
    "High-to-Low Cable Fly": [
        "Set both pulleys high and take a handle in each hand.",
        "Step forward into a staggered stance until the cables are tight.",
        "Open your arms wide and high, elbows slightly bent.",
    ],
    "Single-Arm Cable Fly": [
        "Set one pulley at shoulder height and stand side-on to the stack.",
        "Take the handle in the near hand and step away until the cable is tight.",
        "Open that arm out toward the stack, elbow slightly bent.",
        "Keep your free arm by your side.",
    ],
    "Incline Cable Fly": [
        "Set a bench to about 30° between two low pulleys.",
        "Take a handle in each hand and lie back.",
        "Open your arms wide, elbows slightly bent.",
    ],
    "Decline Cable Fly": [
        "Set a decline bench between two low pulleys.",
        "Take a handle in each hand and hook your legs under the roller.",
        "Lie back and open your arms wide, elbows slightly bent.",
    ],
    "Cable Crossover": [
        "Set both pulleys at shoulder height and take a handle in each hand.",
        "Step forward into a staggered stance until the cables are tight.",
        "Open your arms wide, elbows slightly bent, chest up.",
    ],
    "Single-Arm Landmine Press": [
        "Wedge one end of a bar in a landmine and load the other end.",
        "Stand facing the loaded end in a staggered stance.",
        "Hold the end of the bar at the front of your shoulder in one hand.",
        "Brace your core and squeeze your glutes.",
    ],
    "Incline Push-Up": [
        "Place your hands on the edge of a bench, a bit wider than your shoulders.",
        "Walk your feet back until your body forms a straight line.",
        "Tuck your toes, feet together, and brace your core.",
    ],
    # Batch 133-160 (2026-09-25)
    "Diamond Push-Up": [
        "Kneel and place your hands under your chest, thumbs and index fingers touching.",
        "Walk your feet back until your body forms a straight line.",
        "Tuck your toes, feet together, and brace your core.",
    ],
    "Wide-Grip Push-Up": [
        "Place your hands about one and a half shoulder-widths apart, level with your chest.",
        "Walk your feet back until your body forms a straight line.",
        "Tuck your toes, feet together, and brace your core.",
    ],
    "Archer Push-Up": [
        "Place your hands about twice shoulder-width apart, fingers turned slightly out.",
        "Walk your feet back until your body forms a straight line.",
        "Brace your core; you will shift toward one hand at a time.",
    ],
    "Medicine Ball Push-Up": [
        "Set a medicine ball under your chest.",
        "Press both hands flat on top of the ball, fingers spread.",
        "Walk your feet back until your body forms a straight line, feet together.",
    ],
    "Pause Bench Press": [
        "Lie on the flat bench with your eyes under the bar.",
        "Grip the bar slightly wider than shoulder-width.",
        "Plant your feet and pull your shoulder blades together.",
        "Unrack to straight arms; each rep stops still on your chest before the press.",
    ],
    "Larsen Press": [
        "Lie on the flat bench with your eyes under the bar.",
        "Grip the bar slightly wider than shoulder-width and unrack.",
        "Straighten your legs out in line with the bench, feet off the floor.",
        "Keep your glutes and upper back flat on the bench.",
    ],
    "Reverse-Grip Bench Press": [
        "Lie on the flat bench with your eyes under the bar.",
        "Grip underhand, just over shoulder-width, thumbs around the bar.",
        "Plant your feet and pull your shoulder blades together.",
        "Unrack with a spotter's help, bar over your shoulders.",
    ],
    "Rack Pull": [
        "Set the rack pins just below knee height and rest the bar on them.",
        "Stand close with your feet hip-width, the bar against your legs.",
        "Hinge down and grip just outside your legs, back flat.",
        "Brace and pull the slack out of the bar.",
    ],
    "Block Pull": [
        "Rest the loaded bar on blocks so it sits just below your knees.",
        "Stand close with your feet hip-width, the bar against your legs.",
        "Hinge down and grip just outside your legs, back flat.",
        "Brace and pull the slack out of the bar.",
    ],
    "Sumo Deadlift": [
        "Stand with your feet about twice shoulder-width, toes turned out.",
        "Bring your shins close to the bar, which sits over your mid-foot.",
        "Grip the bar at shoulder-width, hands inside your knees.",
        "Push your knees out, chest up, and pull the slack out of the bar.",
    ],
    "Trap Bar Deadlift": [
        "Stand in the centre of the trap bar, feet hip-width.",
        "Sit your hips down and grip the side handles.",
        "Chest up, back flat, arms straight.",
        "Brace and pull the slack out of the bar.",
    ],
    "Snatch-Grip Deadlift": [
        "Stand with your feet hip-width, the bar over your mid-foot.",
        "Grip the bar wide, about twice shoulder-width.",
        "Sit your hips down until your arms are straight and your chest is up.",
        "Set your shoulders back and pull the slack out of the bar.",
    ],
    "Deficit Deadlift": [
        "Stand on a stable 3–10 cm platform, feet hip-width.",
        "Line the bar up over your mid-foot.",
        "Hinge and grip just outside your shins.",
        "Drop your hips, chest up, and pull the slack out of the bar.",
    ],
    "Barbell Yates Row": [
        "Hold the bar underhand at shoulder-width.",
        "Soften your knees and lean forward to about 35° from upright.",
        "Brace with a flat back, the bar hanging at your knees.",
    ],
    "Reverse-Grip Barbell Row": [
        "Hold the bar underhand at shoulder-width.",
        "Soften your knees and hinge forward well past 45°.",
        "Brace with a flat back, the bar hanging below your shoulders.",
    ],
    "Wide-Grip Barbell Row": [
        "Hold the bar overhand, well outside shoulder-width.",
        "Soften your knees and hinge until your torso is nearly level.",
        "Brace with a flat back, the bar hanging under your shoulders.",
    ],
    "Seal Row": [
        "Set a flat bench high enough that your arms hang without the bar touching the floor.",
        "Lie face down with your chest on the end of the bench.",
        "Grip the bar overhand at shoulder-width, arms hanging straight.",
    ],
    "Meadows Row": [
        "Wedge one end of a bar in a landmine and load the other end.",
        "Stand side-on to the loaded end in a staggered stance.",
        "Hinge forward and rest your free forearm on your front knee.",
        "Grip the sleeve overhand just behind the collar.",
    ],
    "Landmine Row": [
        "Wedge one end of a bar in a landmine and load the other end.",
        "Straddle the bar facing the plates and set a close-grip handle under it.",
        "Hinge forward with a flat back and grip the handle, arms straight.",
    ],
    "Single-Arm Landmine Row": [
        "Wedge one end of a bar in a landmine and load the other end.",
        "Stand beside the bar's end, feet hip-width, and hinge forward.",
        "Grip the bar just below the plates with one hand.",
        "Rest your free hand on your thigh.",
    ],
    "Dumbbell Bent-Over Row": [
        "Hold a dumbbell in each hand, palms facing in.",
        "Soften your knees and push your hips back until your torso is well below 45°.",
        "Brace with a flat back, the dumbbells hanging under your shoulders.",
    ],
    "Renegade Row": [
        "Set two dumbbells shoulder-width apart on the floor.",
        "Grip them and walk into a high plank, hands under your shoulders.",
        "Set your feet wider than your hips and brace your core.",
    ],
    "Kettlebell Row": [
        "Hold a kettlebell in one hand, feet hip-width.",
        "Soften your knees and hinge forward with a flat back.",
        "Rest your free hand on your thigh, the bell hanging under your shoulder.",
    ],
    "Gorilla Row": [
        "Stand wide with two kettlebells on the floor between your feet.",
        "Bend your knees and push your hips back until your torso is nearly level.",
        "Grip both handles, back flat, arms straight.",
    ],
    "Inverted Row": [
        "Set a bar at about hip height in a rack or Smith machine.",
        "Lie under it and grip overhand, a little wider than your shoulders.",
        "Straighten your body from heels to head, heels on the floor.",
    ],
    "Feet-Elevated Inverted Row": [
        "Set a bar at about hip height and a bench in front of it.",
        "Grip the bar overhand, a little wider than your shoulders.",
        "Rest your heels on the bench and straighten your body into a plank.",
    ],
    "Underhand Inverted Row": [
        "Set a bar at about hip height in a rack or Smith machine.",
        "Lie under it and grip underhand at shoulder-width.",
        "Straighten your body from heels to head, heels on the floor.",
    ],
    # Batch 161-190 (2026-09-25)
    "Wide-Grip Pull-Up": [
        "Grip the bar overhand, about one and a half shoulder-widths apart.",
        "Hang with straight arms, legs together, knees slightly bent.",
        "Brace your core and pull your shoulders down.",
    ],
    "Neutral-Grip Pull-Up": [
        "Grip the parallel handles, palms facing each other.",
        "Hang with straight arms, legs together, knees slightly bent.",
        "Brace your core and pull your shoulders down.",
    ],
    "Archer Pull-Up": [
        "Grip the bar overhand, about twice shoulder-width.",
        "Hang with straight arms, legs together.",
        "Brace your core; you will pull toward one hand at a time.",
    ],
    "Weighted Pull-Up": [
        "Put on a dip belt with a plate hanging from the chain.",
        "Grip the bar overhand, a little wider than your shoulders.",
        "Hang with straight arms, legs together, the plate still.",
    ],
    "Assisted Pull-Up": [
        "Set the counterweight: more weight gives more help.",
        "Grip the bar overhand, a little wider than your shoulders.",
        "Kneel on the pad and hang with straight arms.",
    ],
    "Neutral-Grip Chin-Up": [
        "Grip the close parallel handles, palms facing each other.",
        "Hang with straight arms, legs together, knees slightly bent.",
        "Brace your core and pull your shoulders down.",
    ],
    "Weighted Chin-Up": [
        "Put on a dip belt with a plate hanging from the chain.",
        "Grip the bar underhand at shoulder-width.",
        "Hang with straight arms, legs together, the plate still.",
    ],
    "Machine Pull-Up": [
        "Set the counterweight: more weight gives more help.",
        "Grip the bar overhand, a little wider than your shoulders.",
        "Stand on the platform and hang with straight arms.",
    ],
    "Wide-Grip Lat Pulldown": [
        "Adjust the thigh pads so your legs are locked in.",
        "Grip the bar overhand where it starts to bend.",
        "Sit down tall with your arms straight overhead.",
    ],
    "Reverse-Grip Lat Pulldown": [
        "Adjust the thigh pads so your legs are locked in.",
        "Grip the bar underhand at shoulder-width.",
        "Sit down tall with your arms straight overhead.",
    ],
    "Neutral-Grip Lat Pulldown": [
        "Attach a neutral-grip bar and adjust the thigh pads.",
        "Take the handles with your palms facing each other.",
        "Sit down tall with your arms straight overhead.",
    ],
    "V-Bar Lat Pulldown": [
        "Attach a V-handle to the high pulley and adjust the thigh pads.",
        "Hold the handle with both hands, palms facing.",
        "Sit down tall with your arms straight overhead.",
    ],
    "Single-Arm Lat Pulldown": [
        "Attach a single D-handle to the high pulley.",
        "Adjust the thigh pads and take the handle in one hand.",
        "Sit tall, arm straight overhead, free hand on your thigh.",
    ],
    "Kneeling Lat Pulldown": [
        "Set a bar on the high pulley and a mat in front of the stack.",
        "Kneel upright, hips over your knees, and grip the bar at shoulder-width.",
        "Squeeze your glutes and brace, arms straight overhead.",
    ],
    "Rope Lat Pulldown": [
        "Attach a rope to the high pulley and adjust the thigh pads.",
        "Hold each end of the rope, palms facing.",
        "Sit down tall with your arms straight overhead.",
    ],
    "Machine Lat Pulldown": [
        "Set the seat and thigh pad so the handles are just within reach.",
        "Sit tall and grip both handles.",
        "Start with your arms straight overhead, shoulders down.",
    ],
    "Iso-Lateral Lat Pulldown": [
        "Set the seat and thigh pad so the handles are just within reach.",
        "Sit tall and grip both handles.",
        "Pull one handle at a time, the other held overhead.",
    ],
    "Wide-Grip Seated Cable Row": [
        "Attach a straight bar to the low pulley.",
        "Sit with your feet on the footplate, knees soft.",
        "Grip the bar overhand, wide, and sit tall with your arms straight.",
    ],
    "Close-Grip Seated Cable Row": [
        "Attach a V-handle to the low pulley.",
        "Sit with your feet on the footplate, knees soft.",
        "Hold the handle, palms facing, and sit tall with your arms straight.",
    ],
    "Single-Arm Cable Row": [
        "Attach a single handle to the low pulley.",
        "Sit with your feet on the footplate, knees soft.",
        "Take the handle in one hand and sit tall, arm straight.",
    ],
    "Standing Cable Row": [
        "Set both pulleys at about chest height and take a handle in each hand.",
        "Step back into a staggered stance until the cables are tight.",
        "Stand tall with soft knees, arms straight in front.",
    ],
    "Half-Kneeling Cable Row": [
        "Set a single handle at about hip height.",
        "Kneel on one knee, the other foot forward, facing the stack.",
        "Take the handle in one hand, arm straight, glutes squeezed.",
    ],
    "High Cable Row": [
        "Set both pulleys high and sit facing them on the bench.",
        "Take a handle in each hand, overhand.",
        "Sit tall with your arms reaching up and forward.",
    ],
    "Low Cable Row": [
        "Set both pulleys at the floor and sit facing them.",
        "Put your feet on the footplate, knees soft.",
        "Take a handle in each hand and sit tall, arms reaching down.",
    ],
    "Machine Seated Row": [
        "Set the seat so the handles are at mid-chest height.",
        "Sit with your chest against the pad, feet flat.",
        "Reach forward and take the handles with straight arms.",
    ],
    "Iso-Lateral Row Machine": [
        "Set the seat so the handles are at mid-chest height.",
        "Sit with your chest against the pad, feet flat.",
        "Take both handles; row one side at a time.",
    ],
    "Single-Arm Machine Row": [
        "Set the seat so the handle is at mid-chest height.",
        "Sit with your chest against the pad, feet flat.",
        "Take the handle in one hand and hold the support with the other.",
    ],
    "Reverse-Grip T-Bar Row": [
        "Wedge one end of a bar in a landmine and load the other end.",
        "Straddle the bar and set an underhand handle under it.",
        "Hinge forward with a flat back and grip the handle, arms straight.",
    ],
    "Dumbbell Pullover Row": [
        "Lie along a flat bench with a dumbbell in each hand.",
        "Hold them over your chest, palms facing, arms nearly straight.",
        "Plant your feet and keep a slight bend in your elbows.",
    ],
    "Machine Pullover": [
        "Set the seat so your shoulders line up with the machine's pivot.",
        "Sit with your back on the pad and fasten the belt if there is one.",
        "Place your upper arms on the pads and rest your hands on the bar.",
    ],
}
