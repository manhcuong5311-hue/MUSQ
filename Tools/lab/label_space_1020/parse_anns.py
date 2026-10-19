import re, json, sys
src = open(sys.argv[1]).read()
names = ["Back Squat","Box Squat","Pause Squat","Barbell Sumo Squat","Heel-Elevated Squat","Barbell Split Squat","Smith Machine Split Squat","Barbell Bulgarian Split Squat","Smith Machine Bulgarian Split Squat","Good Morning","Seated Good Morning","Smith Machine Good Morning","Barbell Step-Up"]
def calls(blk, head):
    i = 0
    while True:
        i = blk.find(head + '(', i)
        if i < 0: return
        j = i + len(head) + 1; d = 1
        while d:
            d += {'(': 1, ')': -1}.get(blk[j], 0); j += 1
        yield blk[i + len(head) + 1: j - 1]; i = j
out = {}
for n in names:
    var = re.search(r'^\s+"%s":\s+(\w+Content),' % re.escape(n), src, re.M).group(1)
    a = src.index("static let %s = ExerciseContent(" % var); b = src.find("\n    static let ", a + 10)
    rows = []
    for s in calls(src[a:b], 'CueAnnotation'):
        g = lambda pat: (re.search(pat, s) or [None, None])[1]
        pt = re.search(r'labelPoint: CGPoint\(x: ([\d.]+), y: ([\d.]+)\)', s)
        rows.append(dict(cue=g(r'cueID: "(\w+)"'), label=g(r'label: "([^"]*)"'), x=float(pt[1]), y=float(pt[2]), side=g(r'labelSide: \.(\w+)') or 'leading', joint=g(r'joint: "(\w+)"')))
    out[n] = dict(var=var, anns=rows)
json.dump(out, open(sys.argv[2], 'w'), indent=1)
print(len(out), 'lifts;', sum(len(e['anns']) for e in out.values()), 'callouts')
