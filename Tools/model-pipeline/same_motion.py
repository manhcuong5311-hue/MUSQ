# Two models pose the same at every frame (2026-09-26): every animated
# attribute of the first, read through composition at each whole frame of
# the stage, must equal the second's. For checking pad_clips.py.
#   python3 same_motion.py <before.usdc> <after.usdc>
import os as _os  # slim models reference Shared/AnatomyBody.usdc (share_body.py)
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/Shared")
import sys
import numpy as np
from pxr import Usd

# Half-precision attributes (the skeleton's scales) round to about 5e-4
# near 1.0 when interpolated; everything else must agree to 1e-5.
TOLERANCE, HALF_TOLERANCE = 1e-5, 1e-3


def gap(x, y):
    """Largest difference between two values; exact for non-numeric ones."""
    if x is None or y is None:
        return 0.0 if x is y else float("inf")
    try:
        ax, ay = np.asarray(x, dtype=float), np.asarray(y, dtype=float)
    except (TypeError, ValueError):
        try:
            ax = np.array([[q.GetReal(), *q.GetImaginary()] for q in x], dtype=float)
            ay = np.array([[q.GetReal(), *q.GetImaginary()] for q in y], dtype=float)
            # q and -q are the same turn.
            return float(np.max(np.minimum(np.abs(ax - ay).max(axis=1), np.abs(ax + ay).max(axis=1)))) if len(ax) else 0.0
        except Exception:
            return 0.0 if x == y else float("inf")
    if ax.shape != ay.shape:
        return float("inf")
    # Relative to the value's size: a 180° Euler angle rounds at ~1.5e-5.
    return float(np.max(np.abs(ax - ay) / (1 + 1e-2 * np.abs(ax)))) if ax.size else 0.0

a, b = (Usd.Stage.Open(p) for p in sys.argv[1:3])
start, end = int(a.GetStartTimeCode()), int(a.GetEndTimeCode())
frames = list(range(start, end + 1, 1))
checked = mismatched = 0
for prim in a.Traverse():
    other = b.GetPrimAtPath(prim.GetPath())
    for attr in prim.GetAttributes():
        if attr.GetNumTimeSamples() < 2:
            continue
        twin = other.GetAttribute(attr.GetName()) if other else None
        for t in frames:
            checked += 1
            limit = HALF_TOLERANCE if "half" in str(attr.GetTypeName()) else TOLERANCE
            if twin is None or gap(attr.Get(t), twin.Get(t)) > limit:
                mismatched += 1
                if mismatched <= 3:
                    print("  differs:", attr.GetPath(), t)
                break
print(f"{_os.path.basename(sys.argv[2])}: {checked} values over frames {start}-{end}, {mismatched} attributes differ")
sys.exit(1 if mismatched else 0)
