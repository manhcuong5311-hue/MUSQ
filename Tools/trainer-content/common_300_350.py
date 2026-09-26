# Shared helpers for the legs batch 300-350 (2026-09-26). Each family module
# (spec_300_350_*.py) does `from common_300_350 import *`, appends entries
# with ex() and setup steps to SETUP; spec_300_350.py imports the families in
# library order and gen.py reads its SPEC / SETUP.
#
# Entry format (same as spec.py): annotations are (cueID, label, joint) in
# the order the cues are listed; cues map cueID -> (title, intro, why,
# mistake, correct); activation is (muscle, P|S, level, fraction) — the app
# reads the HIGH / MODERATE / LOW word off the fraction (>= 0.70 high,
# 0.40-0.69 moderate, below that low), so keep the level consistent with it.
import json, os

P, S = "primary", "secondary"
HI, MOD, LOW = "HIGH ACTIVATION", "MODERATE ACTIVATION", "LOW ACTIVATION"
A, SOFT = "activation", "activationSoft"

J = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "joints.json")))

SPEC = []
SETUP = {}


def mean(name, joints):
    """Mean projected (u, v) of some joints over the eight probed moments."""
    pts = [p for j in joints for p in J[name][j]]
    return sum(u for u, _ in pts) / len(pts), sum(v for _, v in pts) / len(pts)


def glow(name, joints, kind=A, opacity=0.55, rx=0.12, ry=0.08, dx=0.0, dy=0.0):
    """One activation glow centred on the mean of `joints` (plus a nudge)."""
    cx, cy = mean(name, joints)
    return (kind, opacity, rx, ry, round(min(max(cx + dx, 0.05), 0.95), 3), round(min(max(cy + dy, 0.05), 0.95), 3))


def level(fraction):
    return HI if fraction >= 0.70 else MOD if fraction >= 0.40 else LOW


def ex(**kw):
    kw.setdefault("group", "legs300")
    SPEC.append(kw)


def validate(names=None):
    """Checks every entry (or those named) the way gen.py and the app need."""
    problems = []
    for e in SPEC:
        if names and e["name"] not in names:
            continue
        n = e["name"]
        for key in ("name", "var", "annotations", "cues", "activation", "stabilisers", "comparison", "glows"):
            if key not in e:
                problems.append(f"{n}: missing {key}")
        if n not in J:
            problems.append(f"{n}: not probed in joints.json")
            continue
        ids = [a[0] for a in e["annotations"]]
        if len(ids) != 5 or len(set(ids)) != 5:
            problems.append(f"{n}: needs 5 distinct annotations, has {ids}")
        if set(ids) != set(e["cues"]):
            problems.append(f"{n}: annotation ids {sorted(ids)} != cue ids {sorted(e['cues'])}")
        for cue, label, joint in e["annotations"]:
            if joint not in J[n]:
                problems.append(f"{n}: joint {joint} not probed (add it to probe.py JOINTS)")
            if len(label) > 28:
                problems.append(f"{n}: label too long ({len(label)}): {label}")
        texts = [a[1] for a in e["annotations"]] + [t for c in e["cues"].values() for t in c] + list(e["comparison"]) + e["stabilisers"]
        texts += SETUP.get(n, [])
        for t in texts:
            if '"' in t or "\\" in t:
                problems.append(f"{n}: double quote or backslash in: {t}")
        for cid, c in e["cues"].items():
            if len(c) != 5:
                problems.append(f"{n}: cue {cid} needs (title, intro, why, mistake, correct)")
        if len(e["comparison"]) != 5 or e["comparison"][0] != e["comparison"][0].upper():
            problems.append(f"{n}: comparison needs (BADGE, correctCue, mistakeCue, correctNote, mistakeNote)")
        for m in e["activation"]:
            name, rank, lvl, frac = m
            if rank not in (P, S) or not 0 < frac <= 1:
                problems.append(f"{n}: bad activation row {m}")
            if lvl != level(frac):
                problems.append(f"{n}: {name} level {lvl} disagrees with fraction {frac} ({level(frac)})")
        if not any(m[1] == P for m in e["activation"]):
            problems.append(f"{n}: no primary muscle")
        if not 3 <= len(SETUP.get(n, [])) <= 5:
            problems.append(f"{n}: needs 3-5 setup steps in SETUP")
        for s in e["stabilisers"]:
            if s != s.lower():
                problems.append(f"{n}: stabiliser not lower case: {s}")
        if "overrides" in e:
            for cid, (y, side) in e["overrides"].items():
                if cid not in ids or side not in ("leading", "trailing"):
                    problems.append(f"{n}: bad override {cid}")
    return problems
