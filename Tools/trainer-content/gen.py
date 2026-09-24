import json, sys
sys.path.insert(0, ".")
from spec import SPEC
J = json.load(open("joints.json"))
SLOTS = [0.14, 0.32, 0.50, 0.68, 0.86]
EDGE = 0.035

def width(text):
    return (24 + 5.6 * len(text)) / 382

def covered(x0, x1, y, dots):
    return sum(1 for u, v in dots if x0 - 0.01 <= u <= x1 + 0.01 and abs(v - y) <= 0.035)

def layout(name, anns, overrides=None):
    overrides = overrides or {}
    pts, dots = [], []
    for cue, label, joint in anns:
        samples = [(min(max(u, 0.04), 0.96), min(max(v, 0.04), 0.96)) for u, v in J[name][joint]]
        dots += samples
        ux = sum(u for u, _ in samples) / len(samples)
        uy = sum(v for _, v in samples) / len(samples)
        pts.append((cue, label, joint, ux, uy))
    placed = {}
    for i, (cue, label, joint, ux, uy) in enumerate(pts):
        if cue in overrides:
            y, side = overrides[cue]
            w = width(label)
            x = EDGE + w if side == "leading" else 1 - EDGE - w
            placed[i] = (round(x, 3), y, side, ux, uy)
    free = [y for y in SLOTS if y not in {v[1] for v in placed.values()}]
    order = sorted((i for i in range(len(pts)) if i not in placed), key=lambda i: pts[i][4])
    for slot, i in zip(free, order):
        cue, label, joint, ux, uy = pts[i]
        w = width(label)
        left = (round(EDGE + w, 3), slot, "leading", ux, uy)
        right = (round(1 - EDGE - w, 3), slot, "trailing", ux, uy)
        cl = covered(EDGE, EDGE + w, slot, dots)
        cr = covered(1 - EDGE - w, 1 - EDGE, slot, dots)
        prefer_left = ux < 0.5
        if prefer_left:
            placed[i] = left if cl <= cr else right
        else:
            placed[i] = right if cr <= cl else left
    return [(pts[i][:3], placed[i]) for i in range(len(pts))]

def s(text):
    assert '"' not in text and "\\" not in text, text
    return '"' + text + '"'

def emit(e):
    out = []
    out.append(f"    static let {e['var']}Content = ExerciseContent(")
    out.append("        annotations: [")
    rows = []
    for (cue, label, joint), (x, y, side, jx, jy) in layout(e["name"], e["annotations"], e.get("overrides")):
        side_arg = "" if side == "leading" else "\n                          labelSide: .trailing,"
        rows.append(f"            CueAnnotation(cueID: {s(cue)}, label: {s(label)},\n"
                    f"                          labelPoint: CGPoint(x: {x:.3f}, y: {y:.2f}),{side_arg}"
                    f"{'' if side_arg else ''}\n                          leaderLength: 40, joint: {s(joint)})"
                    .replace(",\n                          leaderLength", ",\n                          leaderLength") )
    out.append(",\n".join(rows))
    out.append("        ],")
    out.append("        cues: [")
    cues = []
    for cue, _, _ in e["annotations"]:
        t, intro, why, mistake, correct = e["cues"][cue]
        cues.append("            TechniqueCue(\n"
                    f"                id: {s(cue)},\n"
                    f"                title: {s(t)},\n"
                    f"                intro: {s(intro)},\n"
                    f"                why: {s(why)},\n"
                    f"                mistake: {s(mistake)},\n"
                    f"                correct: {s(correct)}\n"
                    "            )")
    out.append(",\n".join(cues))
    out.append("        ],")
    out.append("        activation: [")
    acts = []
    for n, rank, level, frac in e["activation"]:
        acts.append(f"            MuscleActivation(name: {s(n)}, rank: .{rank},\n"
                    f"                             activation: {s(level)}, fraction: {frac:.2f})")
    out.append(",\n".join(acts))
    out.append("        ],")
    out.append("        stabilisers: [" + ", ".join(s(x) for x in e["stabilisers"]) + "],")
    badge, ccue, mcue, cnote, mnote = e["comparison"]
    out.append("        comparison: FormComparisonCopy(")
    out.append('            correctBadge: "CORRECT FORM",')
    out.append(f"            mistakeBadge: {s(badge)},")
    out.append(f"            correctCue: {s(ccue)},")
    out.append(f"            mistakeCue: {s(mcue)},")
    out.append(f"            correctNote: {s(cnote)},")
    out.append(f"            mistakeNote: {s(mnote)}")
    out.append("        ),")
    out.append("        glows: [")
    gl = []
    for color, op, rx, ry, cx, cy in e["glows"]:
        gl.append(f"            .init(DS.{color}.opacity({op:.2f}), rx: {rx:.2f}, ry: {ry:.2f}, cx: {cx:.2f}, cy: {cy:.2f})")
    out.append(",\n".join(gl))
    out.append("        ]")
    out.append("    )")
    return "\n".join(out)

if __name__ == "__main__":
    groups = {}
    for e in SPEC:
        groups.setdefault(e["group"], []).append(emit(e))
    json.dump({g: "\n\n".join(v) for g, v in groups.items()}, open("generated.json", "w"))
    for e in SPEC:
        print(e["name"])
        for (cue, label, joint), (x, y, side, jx, jy) in layout(e["name"], e["annotations"], e.get("overrides")):
            print(f"   {label:32s} {side:8s} x={x:.3f} y={y:.2f}  joint {joint:26s} at ({jx:.2f},{jy:.2f})")
