# walking_lunge_lab.py <shared lab> <lead.json> <out dir>: copy of the lab whose joints.json / proj_at.json also hold
# Walking Lunge's <bone>_front / <bone>_back (patella, foot, toe, thigh, shin), resolved per sample with the
# app's BodyFrame.leadingSide rule (lead.json from walking_lunge_lead.py). occ/ is linked, never written.
import json, sys, os, shutil
LAB, LEAD, OUT = sys.argv[1:4]
os.makedirs(OUT, exist_ok=True)
for f in ('anns.json', 'cards.json', 'dot_offsets.json', 'widths.json'):
    shutil.copyfile(os.path.join(LAB, f), os.path.join(OUT, f))
if not os.path.lexists(os.path.join(OUT, 'occ')):
    os.symlink(os.path.join(LAB, 'occ'), os.path.join(OUT, 'occ'))
lead = json.load(open(LEAD))['lead']
J = json.load(open(os.path.join(LAB, 'joints.json'))); P = json.load(open(os.path.join(LAB, 'proj_at.json')))
N = 'Walking Lunge'
for base in ('patella', 'foot', 'toe', 'thigh', 'shin'):
    for role, isside in (('front', True), ('back', False)):
        pts = [J[N][base + '_' + (s if isside else ('R' if s == 'L' else 'L'))][k] for k, (s, d) in enumerate(lead)]
        J[N][base + '_' + role] = pts; P[N]['joints'][base + '_' + role] = pts
json.dump(J, open(os.path.join(OUT, 'joints.json'), 'w')); json.dump(P, open(os.path.join(OUT, 'proj_at.json'), 'w'))
print(OUT)
