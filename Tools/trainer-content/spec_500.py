# Trainer content for the new exercises of the HIKSEMI drive's
# "1-500/401-500" folder (2026-10-04/05): the 30 exports from 106 on that were
# not in the app yet, then the next 30 by number (415-444), then 445-474.
# Written by family in spec_500_<family>.py on top of common_1_50.py (same
# helpers and entry format); each family file's header lists what its models
# show and its sources, and notes_500_<family>.md maps the copy's claims to
# them.
#   python3 spec_500.py [family]   validates everything, or one family.
import importlib, os, sys
from common_1_50 import SPEC, SETUP, validate, validate_library

FAMILIES = {
    "chest": ["Decline Push-Up", "Plyometric Push-Up", "Chest Dip", "Weighted Chest Dip", "Landmine Chest Press"],
    "hammer": ["Rope Hammer Curl", "Cross-Body Hammer Curl", "Incline Hammer Curl", "Zottman Curl",
               "Dumbbell Reverse Curl", "Wrist Roller"],
    "curls": ["Strict Curl", "21s Curl", "EZ-Bar 21s", "Waiter Curl", "Seated Dumbbell Curl"],
    "calfstand": ["Bodyweight Standing Calf Raise", "Dumbbell Standing Calf Raise", "Single-Leg Dumbbell Calf Raise",
                  "Single-Leg Machine Calf Raise", "Donkey Calf Raise", "Machine Donkey Calf Raise",
                  "Hack Squat Calf Raise"],
    "calfseat": ["Calf Press Machine", "Horizontal Leg Press Calf Raise", "Barbell Seated Calf Raise",
                 "Dumbbell Seated Calf Raise", "Single-Leg Seated Calf Raise", "Smith Machine Seated Calf Raise"],
    "hip": ["Dumbbell Hip Thrust"],
    # Second round from the same folder (2026-10-04): 415-444.
    "calfmore": ["Elevated Calf Raise", "Bent-Knee Calf Raise", "Calf Raise Hold", "Calf Raise Pulse",
                 "Farmer's Walk on Toes", "Banded Plantar Flexion"],
    "tibialis": ["Tibialis Raise", "Single-Leg Tibialis Raise", "Wall Tibialis Raise", "Machine Tibialis Raise",
                 "Banded Dorsiflexion"],
    "situp": ["Sit-Up", "Weighted Sit-Up", "Decline Sit-Up", "Weighted Decline Sit-Up", "V-Up", "Alternating V-Up"],
    "crunch": ["Bicycle Crunch", "Oblique Crunch", "Toe Touch Crunch", "Cross-Body Crunch", "Stability Ball Crunch"],
    "cablecrunch": ["Standing Cable Crunch", "Oblique Cable Crunch", "Machine Crunch", "Ab Coaster Crunch"],
    "stability": ["Hollow Body Hold", "Hollow Body Rock", "Dead Bug", "Bird Dog"],
    # Third round (2026-10-05): 445-474.
    "legraise": ["Toe-to-Bar", "Hanging Oblique Knee Raise", "Lying Leg Raise", "Flutter Kick", "Scissor Kick"],
    "plankdyn": ["Mountain Climber", "Plank Shoulder Tap", "Plank Hip Dip", "Plank Knee to Elbow"],
    "plankhold": ["RKC Plank", "Weighted Plank", "Side Plank Hip Lift", "Copenhagen Plank"],
    "sidebend": ["Cable Side Bend", "Dumbbell Side Bend", "Reverse Cable Wood Chop", "Cable Rotation"],
    "twist": ["Landmine Rotation", "Landmine 180", "Medicine Ball Russian Twist", "Weighted Russian Twist"],
    "antiext": ["Stability Ball Rollout", "Body Saw", "Bear Crawl"],
    "carrymarch": ["Farmer Carry March", "Suitcase Carry March"],
    "thruster": ["Barbell Thruster", "Dumbbell Thruster", "Kettlebell Thruster", "Clean and Press"],
}
ORDER = [n for names in FAMILIES.values() for n in names]
HERE = os.path.dirname(os.path.abspath(__file__))
for family in FAMILIES:
    if os.path.exists(os.path.join(HERE, f"spec_500_{family}.py")):
        importlib.import_module(f"spec_500_{family}")
SPEC.sort(key=lambda e: ORDER.index(e["name"]) if e["name"] in ORDER else len(ORDER))


def row(y):
    """Label rows span 0.16-0.80, as in spec_400.py."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "ex500"
    e["slots"] = [row(y) for y in (e.get("slots") or [0.14, 0.32, 0.50, 0.68, 0.86])]
    if "overrides" in e:
        e["overrides"] = {cue: (row(y), side) for cue, (y, side) in e["overrides"].items()}

if __name__ == "__main__":
    only = FAMILIES[sys.argv[1]] if sys.argv[1:] else ORDER
    have = {e["name"] for e in SPEC}
    problems = validate(only) + validate_library(only) + [f"missing: {n}" for n in only if n not in have]
    stray = [e["name"] for e in SPEC if e["name"] not in ORDER]
    problems += [f"not in FAMILIES: {n}" for n in stray]
    print("\n".join(problems) or f"OK ({len([n for n in only if n in have])} exercises)")
