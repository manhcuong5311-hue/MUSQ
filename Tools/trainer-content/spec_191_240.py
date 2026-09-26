# Trainer content for batch 191-240 (2026-09-26): the HIKSEMI drive's
# "190-240" folder (207, 222, 224 and 237 were not exported), converted from
# SourceExports/190-240. Shoulder presses and raises, rotator-cuff work,
# rear-delt and upright rows, shrugs, loaded carries and biceps curls.
#
# Written by family in spec_191_240_<family>.py on top of common_191_240.py;
# each family file's header lists what its models show and its sources, and
# notes_191_240_<family>.md maps the copy's claims to those sources. This
# module collects them in library order. Generate with `spec` swapped for it
# (see README); the setup steps are in setup.py.
from common_191_240 import SPEC, SETUP, validate
import spec_191_240_bbpress, spec_191_240_dbpress, spec_191_240_lateral  # noqa: F401
import spec_191_240_frontrear, spec_191_240_shrugcarry, spec_191_240_curls  # noqa: F401

ORDER = [
    "Seated Barbell Overhead Press", "Behind-the-Neck Press", "Push Press", "Dumbbell Push Press",
    "Standing Dumbbell Press", "Seated Dumbbell Press", "Neutral-Grip Dumbbell Shoulder Press",
    "Single-Arm Dumbbell Shoulder Press", "Z Press", "Landmine Shoulder Press", "Half-Kneeling Landmine Press",
    "Cable Shoulder Press", "Single-Arm Cable Shoulder Press", "Smith Machine Shoulder Press", "Viking Press",
    "Leaning Lateral Raise", "Incline Lateral Raise", "Chest-Supported Lateral Raise", "Y-Raise", "Cable Y-Raise",
    "Lu Raise", "Plate Front Raise", "Barbell Front Raise", "Cable Front Raise", "Alternating Dumbbell Front Raise",
    "Cable External Rotation", "Cable Internal Rotation", "Powell Raise", "Rear Delt Row", "Machine Rear Delt Row",
    "Barbell Upright Row", "Cable Upright Row", "Smith Machine Upright Row",
    "Dumbbell Shrug", "Barbell Shrug", "Smith Machine Shrug", "Cable Shrug", "Trap Bar Shrug",
    "Behind-the-Back Barbell Shrug",
    "Alternating Dumbbell Curl", "Spider Curl", "Dumbbell Preacher Curl", "Machine Biceps Curl",
    "Farmer's Carry", "Suitcase Carry", "Overhead Carry",
]
SPEC.sort(key=lambda e: ORDER.index(e["name"]))


def row(y):
    """The label rows span 0.16-0.80 instead of 0.14-0.86: on the simulator
    the top trailing row ran under the eye button, and the bottom row hid
    under the mistake sheet whenever a mistake wrapped to two lines."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "batch191"
    e["slots"] = [row(y) for y in (e.get("slots") or [0.14, 0.32, 0.50, 0.68, 0.86])]
    if "overrides" in e:
        e["overrides"] = {cue: (row(y), side) for cue, (y, side) in e["overrides"].items()}

if __name__ == "__main__":
    problems = validate()
    missing = [n for n in ORDER if n not in {e["name"] for e in SPEC}]
    print("\n".join(problems + [f"missing: {n}" for n in missing]) or f"OK ({len(SPEC)} exercises)")
