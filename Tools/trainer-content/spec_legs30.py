# Trainer content for the 30-leg set 02-27 (2026-09-28): the HIKSEMI drive's
# "300-350/27_9" folder — lateral lunge, Cossack and sumo squats, squat
# variations with a bar, the belt, pendulum and V-squat machines, leg presses
# and single-leg and heel-elevated squats — converted from
# SourceExports/300-350, plus the five calf raises (083-087) from the drive's
# "Calf 83-" folder (SourceExports/Calf).
#
# Written by family in spec_legs30_<family>.py on top of common_legs30.py;
# each family file's header lists what its models show and its sources, and
# notes_legs30_<family>.md maps the copy's claims to those sources. The model
# briefs (joint angles every 0.5 s) are in briefs_legs30/. This module
# collects the families that exist in library order. Generate with `spec`
# swapped for it (see README); the setup steps go to setup.py.
#   python3 spec_legs30.py [family]   validates everything, or one family.
import importlib, os, sys
from common_legs30 import SPEC, SETUP, validate, validate_library

FAMILIES = {
    "wide": ["Lateral Lunge", "Cossack Squat", "Dumbbell Sumo Squat", "Barbell Sumo Squat", "Kettlebell Goblet Squat"],
    "barbell": ["Box Squat", "Pause Squat", "Safety Bar Squat", "Zercher Squat", "Overhead Squat", "Landmine Squat"],
    "machine": ["Belt Squat", "Pendulum Squat", "V-Squat"],
    "press": ["Vertical Leg Press", "45-Degree Leg Press", "Single-Leg Press", "Narrow-Stance Leg Press", "Wide-Stance Leg Press"],
    "single": ["Heel-Elevated Squat", "Cyclist Squat", "Pistol Squat", "Assisted Pistol Squat"],
    # Calves 083-087 from the drive's "Calf 83-" folder (2026-09-28).
    "calf": ["Standing Calf Raise", "Seated Calf Raise", "Leg Press Calf Raise", "Single-Leg Calf Raise", "Smith Machine Calf Raise"],
}
ORDER = [n for names in FAMILIES.values() for n in names]
HERE = os.path.dirname(os.path.abspath(__file__))
for family in FAMILIES:
    if os.path.exists(os.path.join(HERE, f"spec_legs30_{family}.py")):
        importlib.import_module(f"spec_legs30_{family}")
SPEC.sort(key=lambda e: ORDER.index(e["name"]))


def row(y):
    """Label rows span 0.16-0.80 (as in spec_191_240.py): the top trailing row
    ran under the eye button and the bottom row under the mistake sheet."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "legs30"
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
