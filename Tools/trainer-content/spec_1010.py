# Trainer content for the five new exercises of the Desktop "1-100" folder
# (2026-10-10), the rest of the builder's 30-leg set: 22 single-leg extension,
# 23 Smith machine front squat, 28 dumbbell lateral step-up, 29 barbell
# step-up and 30 hip adduction machine. Written as one family in
# spec_1010_legs.py on top of common_1_50.py (same helpers and entry format
# as spec_500.py); the family file's header lists what the models show and
# its sources, and notes_1010_legs.md maps the copy's claims to them.
#   python3 spec_1010.py [family]   validates everything, or one family.
import importlib, os, sys
from common_1_50 import SPEC, SETUP, validate, validate_library

FAMILIES = {
    "legs": ["Single-Leg Extension", "Smith Machine Front Squat", "Dumbbell Lateral Step-Up", "Barbell Step-Up",
             "Hip Adduction Machine"],
    # The female model's new lifts (2026-10-10): two stance sets and a cable
    # step-down.
    "female": ["Hack Squat (Stances)", "Pendulum Squat (Stances)", "Cable Knee-Drive Kickback"],
}
ORDER = [n for names in FAMILIES.values() for n in names]
HERE = os.path.dirname(os.path.abspath(__file__))
for family in FAMILIES:
    if os.path.exists(os.path.join(HERE, f"spec_1010_{family}.py")):
        importlib.import_module(f"spec_1010_{family}")
SPEC.sort(key=lambda e: ORDER.index(e["name"]) if e["name"] in ORDER else len(ORDER))


def row(y):
    """Label rows span 0.16-0.80, as in spec_500.py."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "ex1010"
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
