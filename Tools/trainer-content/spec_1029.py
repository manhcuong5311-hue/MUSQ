# Trainer content for the 36 exercises that shipped with a model but no
# coaching (2026-10-29): the trainer gate showed them as MODEL ONLY, so the
# owner asked for their cues. They are the Olympic lifts, jumps and
# conditioning work of the 401-500 swap, three cable arm lifts, three glute
# machines, two more legs, two core lifts and the three female lifts of the
# Desktop "Women exsercise" folder.
#
# Written as families in spec_1029_<family>.py on top of common_1_50.py
# (same helpers and entry format as spec_1012.py); each family file's header
# lists what its models show and its sources, and notes_1029_<family>.md
# maps the copy's claims to them.
#   python3 spec_1029.py [family]   validates everything, or one family.
import importlib, os, sys
from common_1_50 import SPEC, SETUP, validate, validate_library

FAMILIES = {
    "arms": ["Lying Cable Curl", "Cable Reverse Curl",
             "Bent-Over Cable Overhead Triceps Extension"],
    "glutes": ["Machine Glute Press", "Machine Glute Kickback", "Banded Glute Bridge"],
    "legs": ["Barbell Standing Calf Raise", "Dumbbell Lying Leg Curl"],
    "core": ["Pallof Press", "Kettlebell Windmill"],
    "female": ["Vertical Hack Squat", "Standing Hinge Kickback", "Incline Bench Cable Kickback"],
    "clean": ["Barbell Power Clean", "Hang Clean", "Dumbbell Hang Clean", "Kettlebell Clean"],
    "snatch": ["Power Snatch", "Dumbbell Snatch", "Kettlebell Snatch"],
    "jerk": ["Dumbbell Clean and Press", "Kettlebell Clean and Press", "Barbell Clean and Jerk",
             "Split Jerk", "Push Jerk"],
    "jump": ["Box Jump", "Step-Up Jump", "Squat Jump", "Jump Rope"],
    "cond": ["Sled Push", "Sled Drag", "Rowing Machine", "Battle Rope Alternating Waves",
             "Battle Rope Slams", "Medicine Ball Chest Pass", "Medicine Ball Slam"],
}
ORDER = [n for names in FAMILIES.values() for n in names]
HERE = os.path.dirname(os.path.abspath(__file__))
for family in FAMILIES:
    if os.path.exists(os.path.join(HERE, f"spec_1029_{family}.py")):
        importlib.import_module(f"spec_1029_{family}")
SPEC.sort(key=lambda e: ORDER.index(e["name"]) if e["name"] in ORDER else len(ORDER))


def row(y):
    """Label rows span 0.16-0.80, as in spec_500.py and spec_1012.py."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "ex1029"
    e["slots"] = [row(y) for y in (e.get("slots") or [0.14, 0.32, 0.50, 0.68, 0.86])]
    if "overrides" in e:
        e["overrides"] = {cue: (row(y), side) for cue, (y, side) in e["overrides"].items()}

if __name__ == "__main__":
    written = {e["name"] for e in SPEC}
    only = FAMILIES[sys.argv[1]] if sys.argv[1:] else [n for n in ORDER if n in written]
    problems = validate(only) + validate_library(only) + [f"missing: {n}" for n in only if n not in written]
    stray = [e["name"] for e in SPEC if e["name"] not in ORDER]
    problems += [f"not in FAMILIES: {n}" for n in stray]
    todo = [n for n in ORDER if n not in written]
    print("\n".join(problems) or f"OK ({len([n for n in only if n in written])} exercises)")
    if todo and not sys.argv[1:]:
        print(f"not written yet ({len(todo)}): " + ", ".join(todo))
