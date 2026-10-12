# Trainer content for the twelve new exercises of the Desktop "300-400"
# folder (2026-10-12): the builder's 377-380 hip thrusts, 383-390 hip
# extensions and 391-394 kettlebell lifts, the exports there with no model in
# the app yet. Written as three families in spec_1012_<family>.py on top of
# common_1_50.py (same helpers and entry format as spec_1011.py); each family
# file's header lists what its models show and its sources, and
# notes_1012_<family>.md maps the copy's claims to them.
#   python3 spec_1012.py [family]   validates everything, or one family.
import importlib, os, sys
from common_1_50 import SPEC, SETUP, validate, validate_library

FAMILIES = {
    "thrust": ["Smith Machine Hip Thrust", "Machine Hip Thrust", "Single-Leg Hip Thrust", "B-Stance Hip Thrust"],
    "hipext": ["Cable Pull-Through", "Standing Cable Hip Extension", "Reverse Hyperextension",
               "Single-Leg Back Extension", "45-Degree Hip Extension"],
    "kb": ["Kettlebell Swing", "Sumo Kettlebell Deadlift", "Kettlebell Deadlift"],
}
ORDER = [n for names in FAMILIES.values() for n in names]
HERE = os.path.dirname(os.path.abspath(__file__))
for family in FAMILIES:
    if os.path.exists(os.path.join(HERE, f"spec_1012_{family}.py")):
        importlib.import_module(f"spec_1012_{family}")
SPEC.sort(key=lambda e: ORDER.index(e["name"]) if e["name"] in ORDER else len(ORDER))


def row(y):
    """Label rows span 0.16-0.80, as in spec_500.py."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "ex1012"
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
