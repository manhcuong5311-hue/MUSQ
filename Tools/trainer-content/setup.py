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
}
