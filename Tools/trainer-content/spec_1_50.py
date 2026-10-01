# Trainer content for exercises 1-50 redone (2026-09-29): the nine new
# exercises in the HIKSEMI drive's "1-100 🟢" folder, converted from
# SourceExports/1-50 (the other 26 files there replaced existing models).
#
# Written by family in spec_1_50_<family>.py on top of common_1_50.py; each
# family file's header lists what its models show and its sources, and
# notes_1_50_<family>.md maps the copy's claims to those sources. The model
# briefs (joint angles every 0.5 s) are in briefs_1_50/. This module collects
# the families that exist in library order. Generate with `spec` swapped for
# it (see README); the setup steps go to setup.py.
#   python3 spec_1_50.py [family]   validates everything, or one family.
import importlib, os, sys
from common_1_50 import SPEC, SETUP, validate, validate_library

FAMILIES = {
    "curls": ["Dumbbell Curl", "Incline Dumbbell Curl", "Preacher Curl", "Cable Curl", "Bayesian Cable Curl"],
    "forearm": ["Reverse Curl", "Wrist Curl"],
    "compound": ["Pendlay Row", "Close-Grip Bench Press"],
}
ORDER = [n for names in FAMILIES.values() for n in names]
HERE = os.path.dirname(os.path.abspath(__file__))
for family in FAMILIES:
    if os.path.exists(os.path.join(HERE, f"spec_1_50_{family}.py")):
        importlib.import_module(f"spec_1_50_{family}")
SPEC.sort(key=lambda e: ORDER.index(e["name"]))

def row(y):
    """Label rows span 0.16-0.80 (as in spec_191_240.py): the top trailing row
    ran under the eye button and the bottom row under the mistake sheet."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "ex150"
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
