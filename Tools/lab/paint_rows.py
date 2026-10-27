# Paint vs muscle rows (2026-10-24): for each model, the groups its paint
# lights (bright / dim / faint, (L)/(R) when one side only) now and at an
# older revision, against the exercise's `activation` rows in
# SampleData.swift (and a stance's own rows), with FLAGS where a rank does
# not follow the paint (bright = primary, dim = secondary, faint = LOW
# secondary), a lit group has no row, or a row's group is unlit. A group is
# read off each anatomy mesh's bound material: FF_Highlight_<Group>_<side>
# on the current rig, DARK_Muscle_<Group> on the 2026-09 one; the level is
# the larger of the red diffuse (grey = unlit) and the emissive red / 0.153,
# as Tools/model-pipeline/tiers.py reads it. Row names map to groups by
# GROUP_ROWS (the rig paints the trapezius and rhomboids as one UpperBack
# group, the forearm as one Forearms group, the supraspinatus and the other
# cuff muscles as RotatorCuff). Blender's python (pxr):
#   python3.13 paint_rows.py <out.txt> <old rev> <Group/Resource> ...
# e.g. old rev fdb0a36^ for the "From 191" swap's models. Models missing
# at the old revision print "(new model)".
import os, sys, re, json, subprocess, tempfile
REPO = "/Users/sammanhcuong/Developer/GymWorkout"
os.environ.setdefault("PXR_AR_DEFAULT_SEARCH_PATH", REPO + "/GymWorkout/Resources/Models/Shared")
from pxr import Usd, UsdShade

M = REPO + "/GymWorkout/Resources/Models/"
GROUP_ROWS = {
    "Abs": ["Rectus Abdominis", "Transverse Abdominis", "Core"],
    "Obliques": ["Obliques", "External Obliques", "Internal Obliques"],
    "Chest": ["Pectoralis Major"], "UpperChest": ["Upper Pectoralis"], "MidChest": ["Middle Pectoralis"],
    "LowerChest": ["Lower Pectoralis"], "ChestDeep": ["Pectoralis Minor"],
    "FrontDelt": ["Anterior Deltoid"], "SideDelt": ["Lateral Deltoid"], "RearDelt": ["Posterior Deltoid"],
    "RotatorCuff": ["Rotator Cuff", "Supraspinatus", "Infraspinatus", "Teres Minor", "Subscapularis"],
    "Lats": ["Latissimus Dorsi"], "TeresMajor": ["Teres Major"],
    "UpperBack": ["Upper Trapezius", "Middle Trapezius", "Lower Trapezius", "Trapezius", "Rhomboids"],
    "LowerBack": ["Erector Spinae", "Lower Back"],
    "Glutes": ["Gluteus Maximus", "Gluteus Medius", "Gluteus Minimus", "Glutes"],
    "Quads": ["Quadriceps", "Rectus Femoris", "Vastus Lateralis", "Vastus Medialis"],
    "OuterThigh": ["Quadriceps", "Tensor Fasciae Latae"],
    "Hamstrings": ["Hamstrings", "Biceps Femoris", "Semitendinosus"],
    "Adductors": ["Adductors", "Adductor Magnus", "Adductor Longus"],
    "HipFlexors": ["Hip Flexors", "Iliopsoas"], "Calves": ["Gastrocnemius", "Soleus", "Calves"],
    "LowerLeg": ["Tibialis Anterior"], "Biceps": ["Biceps Brachii"], "Brachialis": ["Brachialis"],
    "Triceps": ["Triceps Brachii"],
    "Forearms": ["Forearms", "Brachioradialis", "Forearm Flexors", "Forearm Extensors", "Wrist Flexors",
                 "Wrist Extensors", "Finger Flexors", "Extensor Digitorum", "Flexor Digitorum Profundus",
                 "Flexor Digitorum Superficialis", "Flexor Pollicis Longus"],
    "Serratus": ["Serratus Anterior"], "Neck": ["Neck", "Sternocleidomastoid", "Levator Scapulae", "Splenius"],
}


MESH_GROUP = {}


def mesh_groups():
    """Mesh -> group, read off a model on the current rig (2026-10-27): some
    older and female models light single muscles with their own materials
    (S50_Focus_GluteusMedius, HS_04_wide_stance_VastusMedialis_L_0, ...)."""
    if not MESH_GROUP:
        st = Usd.Stage.Open(M + "Legs/GluteBridge.usdc")
        for p in st.Traverse():
            m, _ = UsdShade.MaterialBindingAPI(p).ComputeBoundMaterial() if p.GetTypeName() == "Mesh" else (None, None)
            mm = m and re.match(r"FF_Highlight_(.+?)(?:_[LR])?(?:_\d+)?$", m.GetPrim().GetName())
            if mm:
                MESH_GROUP[re.sub(r"_Mesh(_\d{3})?$", "", p.GetName())] = mm.group(1)
    return MESH_GROUP


def groups(path):
    """{group: {side: level}} of one model file."""
    st = Usd.Stage.Open(path)
    rig = next(p for p in st.Traverse() if p.GetName() == "Anatomy_MasterRig")
    out = {}
    for p in Usd.PrimRange(rig):
        if p.GetTypeName() != "Mesh":
            continue
        m, _ = UsdShade.MaterialBindingAPI(p).ComputeBoundMaterial()
        if not m:
            continue
        mm = re.match(r"(?:FF_Highlight|DARK_Muscle)_(.+?)(?:_([LR]))?(?:_\d+)?$", m.GetPrim().GetName())
        sh = m.GetPrim().GetChild("Principled_BSDF")
        if not mm and sh:
            g = mesh_groups().get(re.sub(r"_Mesh(_\d{3})?$", "", p.GetName()))
            mm = g and re.match(r"(.+)()$", g)
        if not mm or not sh:
            continue
        a, e = sh.GetAttribute("inputs:diffuseColor"), sh.GetAttribute("inputs:emissiveColor")
        c, g = (a.Get() if a else None), (e.Get() if e else None)
        if c is None:
            continue
        r = 0.0 if abs(c[0] - c[1]) < 0.05 and abs(c[1] - c[2]) < 0.05 else c[0]
        if g is not None and g[0] > 0.01 and g[0] > 2 * g[2]:
            r = max(r, min(1.0, g[0] / 0.153))
        mesh = re.sub(r"_Mesh(_\d{3})?$", "", p.GetName())
        side = mm.group(2) or ("L" if mesh.endswith("_L") else "R" if mesh.endswith("_R") else "C")
        k = out.setdefault(mm.group(1), {})
        k[side] = max(k.get(side, 0.0), r)
    return out


def tier(x):
    return "bright" if x >= 0.6 else "dim" if x >= 0.2 else "faint" if x >= 0.05 else None


def tiers(gs):
    out, lv = {"bright": [], "dim": [], "faint": []}, {}
    for g, sides in sorted(gs.items()):
        T = tier(max(sides.values()))
        if not T:
            continue
        lit = [s for s, x in sides.items() if tier(x) == T]
        out[T].append(g if len(sides) == 1 or len(lit) == len(sides) else "%s (%s)" % (g, "".join(sorted(lit))))
        lv[g] = T
    return out, lv


def fmt(o):
    return "  ".join("%s: %s" % (k, ", ".join(v) or "-") for k, v in o.items())


SD = open(REPO + "/GymWorkout/Models/SampleData.swift").read()


def lineno(i):
    return SD.count("\n", 0, i) + 1


def close(s, i):
    o = s[i]; c = {"[": "]", "(": ")"}[o]; d = 0; j = i
    while True:
        ch = s[j]
        if ch == '"':
            j += 1
            while s[j] != '"':
                j += 2 if s[j] == "\\" else 1
        elif s.startswith("//", j):
            j = s.index("\n", j); continue
        elif ch == o:
            d += 1
        elif ch == c:
            d -= 1
            if d == 0:
                return j
        j += 1


def rows_at(i):
    k = SD.index("[", i); e = close(SD, k)
    return [(m[1], m[2], float(m[3]), lineno(k + m.start()))
            for m in re.finditer(r'MuscleActivation\(name: "([^"]+)", rank: \.(\w+), fraction: ([\d.]+)\)', SD[k:e])]


model_ex = {}
for m in re.finditer(r'^\s*"([^"]+)":\s*ExerciseModel\(resource: "(\w+)"', SD, re.M):
    model_ex.setdefault(m[2], []).append(m[1])
si = SD.index("private static let stancesByExercise")
stances, cur = {}, None
for m in re.finditer(r'^\s{8}"([^"]+)": \[|ExerciseStance\(label: "([^"]+)", model: ExerciseModel\(resource: "(\w+)"', SD[si:], re.M):
    if m[1]:
        cur = m[1]
    else:
        stances.setdefault(m[3], []).append((cur, m[2], si + m.start()))
content_of = dict(re.findall(r'^\s*"([^"]+)": (\w+Content),', SD, re.M))

out_path, rev, res = sys.argv[1], sys.argv[2], sys.argv[3:]
blocks, flagged = [], 0
tmp = tempfile.mkdtemp()
for r in res:
    n = r.split("/")[-1]
    nw, lv = tiers(groups(M + r + ".usdc"))
    old = os.path.join(tmp, n + ".usdc")
    got = subprocess.run(["git", "-C", REPO, "show", "%s:GymWorkout/Resources/Models/%s.usdc" % (rev, r)],
                         stdout=open(old, "wb"), stderr=subprocess.DEVNULL).returncode == 0
    od = fmt(tiers(groups(old))[0]) if got else "(new model)"
    targets = [(ex, None, None) for ex in model_ex.get(n, [])] + stances.get(n, [])
    if not targets:
        blocks.append("### %s  ->  (no exercise)\n" % r)
    for ex, lab, pos in targets:
        b = ["### %s  ->  %s%s" % (r, ex, " [stance %s]" % lab if lab else ""), "  paint NEW  " + fmt(nw), "  paint OLD  " + od]
        stab = None
        if lab:
            seg = SD[pos:pos + 3000]
            nxt = seg.find("ExerciseStance(", 20)
            m = re.search(r"activation: \[", seg[:nxt if nxt > 0 else 3000])
            rows = rows_at(pos + m.start()) if m else []
            b.append("  stance rows (%s)" % ("own" if m else "none: uses the exercise list"))
        elif ex not in content_of:
            blocks.append("\n".join(b + ["  NO CONTENT"]) + "\n")
            continue
        else:
            var = content_of[ex]
            a = SD.index("static let %s = ExerciseContent(" % var)
            blk = SD[a:close(SD, SD.index("(", a))]
            rows = rows_at(a + blk.index("activation: ["))
            st = re.search(r"stabilisers: \[([^\]]*)\]", blk)
            stab = st[1].strip() if st else None
            b.append("  content %s (line %d)" % (var, lineno(a)))
        b += ["    L%d: %s  %s  %s" % (l, nm, rk, fr) for nm, rk, fr, l in rows]
        if stab is not None:
            b.append("    stabilisers: [%s]" % stab)
        flags, names, used = [], {nm: rk for nm, rk, _, _ in rows}, set()
        for g, T in lv.items():
            hits = [nm for nm in names if nm in GROUP_ROWS.get(g, [g])]
            used |= set(hits)
            if not hits:
                flags.append("%s %s but no row" % (g, T))
            for h in hits:
                if names[h] != ("primary" if T == "bright" else "secondary"):
                    flags.append("%s is %s but %s is %s" % (h, names[h], g, T))
                if T == "faint":
                    flags.append("%s: %s faint (LOW?)" % (h, g))
        for nm in names:
            if nm in used:
                continue
            gs = [g for g, ns in GROUP_ROWS.items() if nm in ns]
            flags.append("%s row but %s unlit" % (nm, "/".join(gs)) if gs else "%s: unknown group" % nm)
        flagged += bool(flags)
        blocks.append("\n".join(b + ["  FLAGS: " + ("; ".join(flags) if flags else "none")]) + "\n")
open(out_path, "w").write("\n".join(blocks))
print("%d models, %d blocks flagged -> %s" % (len(res), flagged, out_path))
