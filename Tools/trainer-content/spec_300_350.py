# Trainer content for the legs batch 300-350 (2026-09-26): the HIKSEMI drive's
# "300-350" folder — the quads series 316-325 (split squats, Bulgarian split
# squats, lunges) plus the Curtsy Lunge from the 30-leg set — converted from
# SourceExports/300-350.
#
# Written by family in spec_300_350_<family>.py on top of common_300_350.py;
# each family file's header lists what its models show and its sources, and
# notes_300_350_<family>.md maps the copy's claims to those sources. This
# module collects them in library order. Generate with `spec` swapped for it
# (see README); the setup steps are in setup.py.
from common_300_350 import SPEC, SETUP, validate
import spec_300_350_splitsquat, spec_300_350_lunge  # noqa: F401

ORDER = [
    "Forward Lunge", "Barbell Lunge", "Smith Machine Reverse Lunge", "Curtsy Lunge",
    "Barbell Split Squat", "Dumbbell Split Squat", "Smith Machine Split Squat", "Front-Foot-Elevated Split Squat",
    "Rear-Foot-Elevated Split Squat", "Barbell Bulgarian Split Squat", "Smith Machine Bulgarian Split Squat",
]
SPEC.sort(key=lambda e: ORDER.index(e["name"]))


def row(y):
    """Label rows span 0.16-0.80 (as in spec_191_240.py): the top trailing row
    ran under the eye button and the bottom row under the mistake sheet."""
    return round(0.16 + (y - 0.14) * (0.80 - 0.16) / (0.86 - 0.14), 3)


for e in SPEC:
    e["group"] = "legs300"
    e["slots"] = [row(y) for y in (e.get("slots") or [0.14, 0.32, 0.50, 0.68, 0.86])]
    if "overrides" in e:
        e["overrides"] = {cue: (row(y), side) for cue, (y, side) in e["overrides"].items()}

if __name__ == "__main__":
    problems = validate()
    missing = [n for n in ORDER if n not in {e["name"] for e in SPEC}]
    print("\n".join(problems + [f"missing: {n}" for n in missing]) or f"OK ({len(SPEC)} exercises)")
