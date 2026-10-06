# One-off (2026-10-05): library rows and provisional model-map entries for the
# third round of the 401-500 folder (445-474). Framings are replaced after the
# stills are compared (see the model-pipeline README).
import json, re, sys
REPO = "/Users/sammanhcuong/Developer/GymWorkout"
SD = REPO + "/GymWorkout/Models/SampleData.swift"
t = open(SD).read()

ROWS = {  # name: (category, primary, equipment, difficulty, resource)
    "Toe-to-Bar": ("core", "RECTUS ABDOMINIS", "BODYWEIGHT", "advanced", "ToeToBar"),
    "Hanging Oblique Knee Raise": ("core", "OBLIQUES", "BODYWEIGHT", "intermediate", "HangingObliqueKneeRaise"),
    "Lying Leg Raise": ("core", "RECTUS ABDOMINIS", "BODYWEIGHT", "beginner", "LyingLegRaise"),
    "Flutter Kick": ("core", "RECTUS ABDOMINIS", "BODYWEIGHT", "beginner", "FlutterKick"),
    "Scissor Kick": ("core", "RECTUS ABDOMINIS", "BODYWEIGHT", "beginner", "ScissorKick"),
    "Mountain Climber": ("core", "RECTUS ABDOMINIS", "BODYWEIGHT", "beginner", "MountainClimber"),
    "Plank Shoulder Tap": ("core", "RECTUS ABDOMINIS", "BODYWEIGHT", "intermediate", "PlankShoulderTap"),
    "Plank Hip Dip": ("core", "OBLIQUES", "BODYWEIGHT", "intermediate", "PlankHipDip"),
    "Plank Knee to Elbow": ("core", "RECTUS ABDOMINIS", "BODYWEIGHT", "intermediate", "PlankKneeToElbow"),
    "RKC Plank": ("core", "RECTUS ABDOMINIS", "BODYWEIGHT", "intermediate", "RKCPlank"),
    "Weighted Plank": ("core", "RECTUS ABDOMINIS", "PLATE", "intermediate", "WeightedPlank"),
    "Side Plank Hip Lift": ("core", "OBLIQUES", "BODYWEIGHT", "intermediate", "SidePlankHipLift"),
    "Copenhagen Plank": ("core", "ADDUCTORS", "BENCH", "advanced", "CopenhagenPlank"),
    "Cable Side Bend": ("core", "OBLIQUES", "CABLE", "beginner", "CableSideBend"),
    "Dumbbell Side Bend": ("core", "OBLIQUES", "DUMBBELL", "beginner", "DumbbellSideBend"),
    "Reverse Cable Wood Chop": ("core", "OBLIQUES", "CABLE", "intermediate", "ReverseCableWoodChop"),
    "Cable Rotation": ("core", "OBLIQUES", "CABLE", "beginner", "CableRotation"),
    "Landmine Rotation": ("core", "OBLIQUES", "LANDMINE", "intermediate", "LandmineRotation"),
    "Landmine 180": ("core", "OBLIQUES", "LANDMINE", "intermediate", "Landmine180"),
    "Medicine Ball Russian Twist": ("core", "OBLIQUES", "MEDICINE BALL", "beginner", "MedicineBallRussianTwist"),
    "Weighted Russian Twist": ("core", "OBLIQUES", "PLATE", "intermediate", "WeightedRussianTwist"),
    "Stability Ball Rollout": ("core", "RECTUS ABDOMINIS", "SWISS BALL", "intermediate", "StabilityBallRollout"),
    "Body Saw": ("core", "RECTUS ABDOMINIS", "SLIDERS", "advanced", "BodySaw"),
    "Bear Crawl": ("core", "SHOULDERS + CORE", "BODYWEIGHT", "beginner", "BearCrawl"),
    "Farmer Carry March": ("core", "GRIP + CORE", "DUMBBELL", "beginner", "FarmerCarryMarch"),
    "Suitcase Carry March": ("core", "OBLIQUES", "DUMBBELL", "beginner", "SuitcaseCarryMarch"),
    "Barbell Thruster": ("legs", "QUADS + SHOULDERS", "BARBELL", "intermediate", "BarbellThruster"),
    "Dumbbell Thruster": ("legs", "QUADS + SHOULDERS", "DUMBBELL", "intermediate", "DumbbellThruster"),
    "Kettlebell Thruster": ("legs", "QUADS + SHOULDERS", "KETTLEBELL", "intermediate", "KettlebellThruster"),
    "Clean and Press": ("shoulders", "ANTERIOR DELTOID", "BARBELL", "advanced", "CleanAndPress"),
}


def rows_for(names):
    return "".join(f'        Exercise(name: "{n}", category: .{ROWS[n][0]},\n                 primaryMuscle: "{ROWS[n][1]}", '
                   f'equipment: "{ROWS[n][2]}",\n                 difficulty: .{ROWS[n][3]}),\n' for n in names)


def after_row(name, block):
    global t
    m = re.search(r'        Exercise\(name: "' + re.escape(name) + r'", category: \.\w+,\n.*\n.*\n', t)
    assert m, name
    t = t[:m.end()] + block + t[m.end():]


if '"Toe-to-Bar"' not in t:
    tag = "        // From the drive's \"401-500\" folder, 445-474 (2026-10-05).\n"
    after_row("Hanging Leg Raise", tag + rows_for(["Toe-to-Bar", "Hanging Oblique Knee Raise", "Lying Leg Raise",
                                                   "Flutter Kick", "Scissor Kick"]))
    after_row("Side Plank", tag + rows_for(["Mountain Climber", "Plank Shoulder Tap", "Plank Hip Dip", "Plank Knee to Elbow",
                                            "RKC Plank", "Weighted Plank", "Side Plank Hip Lift", "Copenhagen Plank"]))
    after_row("Cable Wood Chop", tag + rows_for(["Cable Side Bend", "Dumbbell Side Bend", "Reverse Cable Wood Chop",
                                                 "Cable Rotation", "Landmine Rotation", "Landmine 180",
                                                 "Medicine Ball Russian Twist", "Weighted Russian Twist",
                                                 "Stability Ball Rollout", "Body Saw", "Bear Crawl"]))
    after_row("Overhead Carry", "")  # the list's last row has no trailing comma
    t = t.replace('''        Exercise(name: "Overhead Carry", category: .core,
                 primaryMuscle: "SHOULDERS + CORE", equipment: "DUMBBELL",
                 difficulty: .intermediate)
    ]''', '''        Exercise(name: "Overhead Carry", category: .core,
                 primaryMuscle: "SHOULDERS + CORE", equipment: "DUMBBELL",
                 difficulty: .intermediate),
''' + tag + rows_for(["Farmer Carry March", "Suitcase Carry March"]).rstrip(",\n") + "\n    ]")
    after_row("Assisted Pistol Squat", tag + rows_for(["Barbell Thruster", "Dumbbell Thruster", "Kettlebell Thruster"]))
    after_row("Push Press", tag + rows_for(["Clean and Press"]))

frames = json.load(open(sys.argv[1]))  # name -> [yaw, zoom, [x, y, z]]
lines = []
for n, (y, z, o) in frames.items():
    key = f'"{n}":'
    lines.append(f'        {key:38s}ExerciseModel(resource: "{ROWS[n][4]}",\n'
                 f'                                        framing: ModelFraming(yaw: {y}, zoom: {z}, offset: [{o[0]}, {o[1]}, {o[2]}])),')
begin = "        // Third round from the same folder (2026-10-05): 445-474.\n"
if begin in t:
    a = t.index(begin); b = t.index("        // END third round\n", a)
    t = t[:a] + begin + "\n".join(lines) + "\n" + t[b:]
else:
    anchor = '        // Second round from the same folder (2026-10-04): 415-444, calf, tibialis\n'
    assert t.count(anchor) == 1
    t = t.replace(anchor, begin + "\n".join(lines) + "\n        // END third round\n" + anchor)
open(SD, "w").write(t)
print(len(re.findall(r"Exercise\(name:", t)), "library rows")
