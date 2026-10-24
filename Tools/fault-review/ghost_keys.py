# Lists each exercise's cues against the fault-ghost table (2026-10-23): the
# cue ids from its CueAnnotation rows in SampleData.swift, whether
# FaultPoses.table draws a GHOST for it or the mistake view falls back to the
# red ring, the review still (bottoms.json) and the piece expression. Reads
# inline entries, shared sets ("Push-Up": pushUpFaults) and their merges.
#   python3 ghost_keys.py "<Exercise>" ...      (or --file names.txt)
import sys, re, json

REPO = '/Users/sammanhcuong/Developer/GymWorkout'
FP = open(REPO + '/GymWorkout/Models/FaultPoses.swift').read()
SD = open(REPO + '/GymWorkout/Models/SampleData.swift').read()
B = json.load(open(REPO + '/Tools/fault-review/bottoms.json'))


def close(s, i):
    """Index of the bracket closing the one at s[i], skipping strings and // comments."""
    o = s[i]
    c = {'[': ']', '(': ')', '{': '}'}[o]
    d, j = 0, i
    while True:
        ch = s[j]
        if ch == '"':
            j += 1
            while s[j] != '"':
                j += 2 if s[j] == '\\' else 1
        elif s.startswith('//', j):
            j = s.index('\n', j)
            continue
        elif ch == o:
            d += 1
        elif ch == c:
            d -= 1
            if d == 0:
                return j
        j += 1


def entries(body):
    """{cue: expression} from the inside of a [String: FaultPose] literal."""
    out, depth, i, key, start = {}, 0, 0, None, 0
    toks = list(re.finditer(r'"(\w+)":\s*', body))
    for k, m in enumerate(toks):
        # a key only at the literal's own level
        prefix = body[:m.start()]
        lvl = sum(prefix.count(a) for a in '([{') - sum(prefix.count(b) for b in ')]}')
        if lvl != 0:
            continue
        end = len(body)
        for n in toks[k + 1:]:
            pre = body[:n.start()]
            if sum(pre.count(a) for a in '([{') - sum(pre.count(b) for b in ')]}') == 0:
                end = n.start()
                break
        out[m.group(1)] = ' '.join(body[m.end():end].split()).rstrip(',')
    return out


def shared(var):
    i = FP.index('static let %s: [String: FaultPose] = [' % var)
    j = FP.index('[', FP.index('=', i))
    return entries(FP[j + 1:close(FP, j)])


t0 = FP.index('private static let table')
t1 = close(FP, FP.index('[', FP.index('=', t0)))
TABLE = FP[t0:t1]


def ghosts(name):
    m = re.search(r'^        "%s": ' % re.escape(name), TABLE, re.M)
    if not m:
        return {}
    rest = TABLE[m.end():]
    if rest.startswith('['):
        return entries(rest[1:close(rest, 0)])
    var = re.match(r'(\w+)', rest).group(1)
    out = shared(var)
    mm = re.match(r'\w+\.merging\(\[', rest)
    if mm:
        k = rest.index('[')
        out.update(entries(rest[k + 1:close(rest, k)]))
    return out


def cues(name):
    var = re.search(r'^\s+"%s":\s+(\w+Content),' % re.escape(name), SD, re.M).group(1)
    a = SD.index('static let %s = ExerciseContent(' % var)
    b = close(SD, SD.index('(', a))
    return list(dict.fromkeys(re.findall(r'(?:CueAnnotation\(cueID: |Annotation\()"(\w+)"', SD[a:b])))


names = [l.strip() for l in open(sys.argv[2]) if l.strip()] if sys.argv[1:2] == ['--file'] else sys.argv[1:]
for n in names:
    g = ghosts(n)
    for c in cues(n):
        st = round(B.get(n + '|' + c, B.get(n, 0)) + 0.02, 2)
        print('%-40s %-10s %-5s %-5s %s' % (n, c, 'GHOST' if c in g else 'ring', st, g.get(c, '')[:300]))
