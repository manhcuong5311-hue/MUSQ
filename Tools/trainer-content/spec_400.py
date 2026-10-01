# Trainer content for the 27 new exercises of the HIKSEMI drive's "351-400"
# folder (2026-09-30): hamstring, glute and hip work from the builder's
# 356-400 set. Written by family in spec_400_<family>.py on top of
# common_1_50.py (same helpers and entry format); each family file's header
# lists what its models show and its sources, and notes_400_<family>.md maps
# the copy's claims to them.
#   python3 spec_400.py [family]   validates everything, or one family.
import importlib, os, sys
from common_1_50 import SPEC, SETUP, validate, validate_library

FAMILIES = {
    "rdl": ["Single-Leg Romanian Deadlift", "Barbell Single-Leg Romanian Deadlift", "Dumbbell Single-Leg Romanian Deadlift",
            "B-Stance Romanian Deadlift", "Smith Machine Romanian Deadlift", "Cable Romanian Deadlift",
            "Kettlebell Romanian Deadlift", "Dumbbell Deadlift"],
    "hinge": ["Good Morning", "Seated Good Morning", "Smith Machine Good Morning",
              "Nordic Hamstring Curl", "Assisted Nordic Curl", "Glute-Ham Raise"],
    "legcurl": ["Standing Leg Curl", "Kneeling Leg Curl", "Cable Standing Leg Curl",
                "Swiss Ball Leg Curl", "Sliding Leg Curl", "Single-Leg Sliding Curl"],
    "hip": ["Frog Pump", "Weighted Frog Pump", "Cable Hip Adduction", "Standing Hip Abduction",
            "Side-Lying Hip Abduction", "Banded Hip Abduction", "Clamshell"],
}
ORDER = [n for names in FAMILIES.values() for n in names]
HERE = os.path.dirname(os.path.abspath(__file__))
for family in FAMILIES:
    if os.path.exists(os.path.join(HERE, f"spec_400_{family}.py")):
        importlib.import_module(f"spec_400_{family}")
SPEC.sort(key=lambda e: ORDER.index(e["name"]))

def row(y):
    """Label rows span 0.16-0.80, as in spec_1_50.py."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "ex400"
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
