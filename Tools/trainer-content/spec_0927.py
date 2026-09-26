# Trainer content for the late additions (2026-09-27): Seated Dumbbell Lateral
# Raise (207), Cable Rear Delt Row (222) and Dumbbell Upright Row (224) from the
# HIKSEMI drive's "190-240" exports, and Barbell Hip Thrust (077) from the fixed
# 03_Dui_sau_Mong legs. Written by family in spec_0927_<family>.py on top of
# common_0927.py; each family file's header lists what its models show and its
# sources, and notes_0927_<family>.md maps the copy's claims to them.
from common_0927 import SPEC, SETUP, validate
import spec_0927_shoulders, spec_0927_hipthrust  # noqa: F401

ORDER = ["Seated Dumbbell Lateral Raise", "Cable Rear Delt Row", "Dumbbell Upright Row", "Barbell Hip Thrust"]
SPEC.sort(key=lambda e: ORDER.index(e["name"]))


def row(y):
    """Label rows span 0.16-0.80 (as in spec_191_240.py and spec_300_350.py)."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "late0927"
    e["slots"] = [row(y) for y in (e.get("slots") or [0.14, 0.32, 0.50, 0.68, 0.86])]
    if "overrides" in e:
        e["overrides"] = {cue: (row(y), side) for cue, (y, side) in e["overrides"].items()}

if __name__ == "__main__":
    problems = validate()
    missing = [n for n in ORDER if n not in {e["name"] for e in SPEC}]
    print("\n".join(problems + [f"missing: {n}" for n in missing]) or f"OK ({len(SPEC)} exercises)")
