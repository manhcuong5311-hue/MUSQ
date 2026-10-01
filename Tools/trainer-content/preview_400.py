# Validates a family of the 351-400 folder (2026-09-30) and prints where gen.py
# will put each label (unit coords in the 382x655 trainer viewport; y is the
# row, x the pill's inner end) next to the joint its leader points at.
#   python3 preview_400.py [family]
import sys
import spec_400 as S
sys.modules["spec"] = S
import gen  # noqa: E402
only = S.FAMILIES[sys.argv[1]] if sys.argv[1:] else S.ORDER
problems = S.validate(only) + S.validate_library(only)
print("\n".join(problems) or f"OK ({len(only)} exercises)")
for e in S.SPEC:
    if e["name"] not in only: continue
    print(e["name"])
    for (cue, label, joint), (x, y, side, jx, jy) in gen.layout(e["name"], e["annotations"], e.get("overrides"), e.get("slots")):
        print(f"   {cue:10s} {label:30s} {side:8s} x={x:.3f} y={y:.2f}  joint {joint:26s} at ({jx:.2f},{jy:.2f})")
