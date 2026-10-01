# Trainer content for batch 241-300 (2026-09-27): 15 curls and 11 wrist, finger
# and grip exercises from the HIKSEMI drive's "241-300" exports. Written by
# family in spec_241_300_<family>.py on top of common_241_300.py; each family
# file's header lists what its models show and its sources, and
# notes_241_300_<family>.md maps the copy's claims to them.
from common_241_300 import SPEC, SETUP, validate
import spec_241_300_preacher, spec_241_300_cable, spec_241_300_dragspider, spec_241_300_wrist, spec_241_300_grip  # noqa: F401

ORDER = ["Single-Arm Machine Curl", "Cable Preacher Curl", "Single-Arm Cable Curl", "High Cable Curl",
         "Overhead Cable Curl", "Cable Hammer Curl", "Preacher Hammer Curl", "Drag Curl", "EZ Bar Drag Curl",
         "Cable Drag Curl", "Reverse Preacher Curl", "Barbell Preacher Curl", "Dumbbell Spider Curl",
         "EZ Bar Spider Curl", "Alternating Hammer Curl",
         "Dumbbell Wrist Curl", "Barbell Reverse Wrist Curl", "Dumbbell Reverse Wrist Curl", "Cable Wrist Curl",
         "Cable Reverse Wrist Curl", "Behind-the-Back Wrist Curl", "Finger Curl", "Plate Pinch Hold",
         "Dumbbell Static Hold", "Barbell Static Hold", "Towel Grip Hold"]
SPEC.sort(key=lambda e: ORDER.index(e["name"]))


def row(y):
    """Label rows span 0.16-0.80 (as in spec_191_240.py and spec_300_350.py)."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "batch241300"
    e["slots"] = [row(y) for y in (e.get("slots") or [0.14, 0.32, 0.50, 0.68, 0.86])]
    if "overrides" in e:
        e["overrides"] = {cue: (row(y), side) for cue, (y, side) in e["overrides"].items()}

if __name__ == "__main__":
    problems = validate()
    missing = [n for n in ORDER if n not in {e["name"] for e in SPEC}]
    print("\n".join(problems + [f"missing: {n}" for n in missing]) or f"OK ({len(SPEC)} exercises)")
