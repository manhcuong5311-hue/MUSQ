# Composed slim model vs the original (2026-09-26): every prim, attribute value
# and time sample, and relationship must match.  equiv.py <original> <slim>
import os, sys, hashlib
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", "/Users/sammanhcuong/Desktop/GymWorkout/GymWorkout/Resources/Models/Shared")
from pxr import Usd
def sig(path):
    st = Usd.Stage.Open(path)
    out = {}
    for p in st.Traverse():
        ps = p.GetPath().pathString
        out[(ps, "type")] = (p.GetTypeName(), p.IsActive())
        for a in p.GetAttributes():
            if not a.HasAuthoredValue(): continue
            ts = a.GetTimeSamples()
            vals = [(t, a.Get(t)) for t in ts] if ts else [a.Get()]
            out[(ps, a.GetName())] = hashlib.md5(repr(vals).encode()).hexdigest()
        for r in p.GetRelationships():
            out[(ps, "rel:" + r.GetName())] = repr(r.GetTargets())
    return out, (st.GetStartTimeCode(), st.GetEndTimeCode(), st.GetTimeCodesPerSecond())
a, ra = sig(sys.argv[1]); b, rb = sig(sys.argv[2])
miss = [k for k in a if k not in b]; extra = [k for k in b if k not in a]; diff = [k for k in a if k in b and a[k] != b[k]]
print(os.path.basename(sys.argv[2]), "range", ra, rb, "| missing", len(miss), "extra", len(extra), "different", len(diff))
for k in (miss + extra + diff)[:10]: print("   ", k)
