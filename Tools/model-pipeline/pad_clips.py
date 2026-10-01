# Pads every animated attribute to the stage's frame range (2026-09-26).
# Some exports sample the skeleton over 7-187 (or 1-181) while the props run
# 1-192; RealityKit loops each clip over its own samples, so the dumbbells
# drift off the hands a little more on every loop. Adding a held sample at
# the stage start and end — the value USD already holds there — makes every
# clip the same length without changing the pose at any frame.
#   python3 pad_clips.py <model.usdc>...   (edits in place; slim models too)
import os as _os  # slim models reference Shared/AnatomyBody.usdc (share_body.py)
_os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Developer/GymWorkout/GymWorkout/Resources/Models/Shared")
import sys
from pxr import Sdf


def walk(spec):
    yield spec
    for child in spec.nameChildren:
        yield from walk(child)


def pad(path):
    layer = Sdf.Layer.FindOrOpen(path)
    start, end = layer.startTimeCode, layer.endTimeCode
    padded = 0
    for prim in walk(layer.pseudoRoot):
        for attr in prim.attributes:
            times = layer.ListTimeSamplesForPath(attr.path)
            if len(times) < 2:
                continue
            if times[0] > start:
                layer.SetTimeSample(attr.path, start, layer.QueryTimeSample(attr.path, times[0]))
                padded += 1
            if times[-1] < end:
                layer.SetTimeSample(attr.path, end, layer.QueryTimeSample(attr.path, times[-1]))
                padded += 1
    if padded:
        layer.Save()
    return padded


if __name__ == "__main__":
    for path in sys.argv[1:]:
        n = pad(path)
        print(f"{_os.path.basename(path):40s} {'padded ' + str(n) + ' ends' if n else 'already full length'}")
