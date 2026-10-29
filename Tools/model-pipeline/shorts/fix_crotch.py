# Crotch / inner-thigh pass on top of fix_shorts.py (2026-10-28).
# fix_shorts.py left the shorts' gusset as the master does (CLOTH_Contact ~0 there), so at rest it
# sits up to ~16 mm inside the adductors, gracilis and hamstring tops; the navy shorts made the grey
# muscle show between the legs. This moves only that region, mostly DOWN (a pushed-sideways gusset
# runs into the other leg), to a small clearance, and keeps phase 1's weights.
# Runs inside Blender:
#   Blender -b --factory-startup --python fix_crotch.py -- --v2 ORIG/AnatomyBodyV2.usdc --v1 ORIG/AnatomyBody.usdc
#           --phase1 PHASE1/shorts_fix.npz --outdir OUT [--clear 0.004] [--cmax 0.025] [--down 1.5]
import sys, os, json, shutil, argparse
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from slib import *
from mathutils import Vector
from mathutils.bvhtree import BVHTree
from pxr import Usd, Sdf, Vt, Gf, UsdSkel, UsdGeom

argv = sys.argv[sys.argv.index('--') + 1:]
ap = argparse.ArgumentParser()
ap.add_argument('--v2', required=True); ap.add_argument('--v1', default=None)
ap.add_argument('--phase1', required=True); ap.add_argument('--outdir', required=True)
ap.add_argument('--clear', type=float, default=0.004)
ap.add_argument('--cmax', type=float, default=0.025)
ap.add_argument('--down', type=float, default=1.5)       # weight of straight-down in the push direction
a = ap.parse_args(argv)
os.makedirs(a.outdir, exist_ok=True)
log = {'args': vars(a)}

body = Body(Usd.Stage.Open(a.v2))
S = body.mesh(SHORTS); n = S['Pb'].shape[0]
P0 = S['Pb'].copy(); tris = S['tris']
ph1 = np.load(a.phase1)
P1 = ph1['P'].astype(np.float64); cc = ph1['cc'].astype(np.float64)
edges, ecnt = edges_of(S['fvc'], S['fvi']); lap = laplacian_matrix(n, edges)

# region: what fix_shorts.py left alone, softened, below the waist
cw = np.clip((0.5 - cc) / 0.3, 0, 1)
cw = np.clip(umbrella(cw, lap, 0.5, 6), 0, 1) * np.clip((0.90 - P1[:, 2]) / 0.03, 0, 1)
reg = np.where(cw > 0.02)[0]
log['region'] = dict(verts=int(len(reg)), full=int((cw > 0.98).sum()))

lo = P1.min(0) - 0.1; hi = P1.max(0) + 0.1
trees = []
for m in body.meshes:
    if any(k in m['name'] for k in NON_MUSCLE) or m['group'] in ARM_GROUPS:
        continue
    Pb = m['Pb']; tr = m['tris']; inbox = np.all((Pb >= lo) & (Pb <= hi), 1)
    if inbox[tr].any():
        trees.append((m['name'], BVHTree.FromPolygons(Pb.tolist(), tr.tolist(), all_triangles=True)))
log['muscles'] = len(trees)
DIRS = [Vector((0.0, 0.0, 1.0)), Vector((0.31, 0.2, -0.93)).normalized()]


def parity(t, p, d):
    o = Vector(p); c = 0
    for _ in range(80):
        loc, nor, idx, dist = t.ray_cast(o, d, 2.0)
        if loc is None:
            break
        c += 1; o = loc + d * 1e-5
    return c % 2


def need_of(P):
    """per region vertex: depth inside the deepest containing muscle + clearance, or clearance - gap"""
    need = np.zeros(n); depth = np.zeros(n); inside = np.zeros(n, bool)
    for i in reg:
        p = Vector(P[i]); gap = 1.0; dep = 0.0; ins = False
        for nm, t in trees:
            loc, nor, idx, dist = t.find_nearest(p, 0.06)
            if loc is None:
                continue
            if parity(t, P[i], DIRS[0]) and parity(t, P[i], DIRS[1]):
                ins = True; dep = max(dep, dist)
            else:
                gap = min(gap, dist)
        inside[i] = ins; depth[i] = dep
        need[i] = (dep + a.clear) if ins else max(0.0, a.clear - gap)
    return need, depth, inside


def dirs(P):
    N = vertex_normals(P, tris)
    Ns = umbrella(N, lap, 0.5, 8); Ns /= np.linalg.norm(Ns, axis=1)[:, None]
    U = Ns + a.down * np.array([0.0, 0.0, -1.0])
    return U / np.linalg.norm(U, axis=1)[:, None]


P = P1.copy(); total = np.zeros(n); hist = []
for it in range(10):
    need, depth, inside = need_of(P)
    need = np.minimum(need * cw, np.maximum(0.0, a.cmax - total))
    hist.append(dict(it=it, inside=int(inside.sum()), viol=int((need > 0.0005).sum()),
                     max_need_mm=round(1000 * float(need.max()), 2), max_depth_mm=round(1000 * float(depth.max()), 2)))
    if need.max() < 0.0005:
        break
    D = need.copy()
    for k in range(40):                       # spread each bump so the fabric stays smooth
        D = np.maximum(need, umbrella(D, lap, 0.5, 1) * np.minimum(1.0, cw * 4))
    P = P + D[:, None] * dirs(P)
    total += D
# light fairing of the crotch displacement only
Dv = umbrella(P - P1, lap, 0.5, 3) * cw[:, None] + (P - P1) * (1 - cw[:, None])
P = P1 + Dv
need, depth, inside = need_of(P)
log['iters'] = hist
log['final'] = dict(inside=int(inside.sum()), max_depth_mm=round(1000 * float(depth.max()), 2),
                    move_max_mm=round(1000 * float(np.linalg.norm(P - P1, axis=1).max()), 2),
                    sag_max_mm=round(-1000 * float((P - P1)[:, 2].min()), 2),
                    moved_gt1mm=int((np.linalg.norm(P - P1, axis=1) > 0.001).sum()),
                    outside_region_max_mm=round(1000 * float(np.linalg.norm((P - P1)[cw < 0.02], axis=1).max() if (cw < 0.02).any() else 0), 3))

# normals: rotate the authored normals by the change of the smooth vertex normal (original -> final)
pr = body.stage.GetPrimAtPath(S['path']); nattr = pr.GetAttribute('normals')
NA = np.array(nattr.Get(), np.float64); interp = nattr.GetMetadata('interpolation')
N0v = vertex_normals(P0, tris); N1v = vertex_normals(P, tris)
def rotate(vecs, a_, b_):
    v = np.cross(a_, b_); c = np.sum(a_ * b_, 1); s = np.linalg.norm(v, axis=1)
    k = np.where(s[:, None] > 1e-9, v / np.maximum(s, 1e-12)[:, None], 0)
    ang = np.arctan2(s, c); cos, sin = np.cos(ang)[:, None], np.sin(ang)[:, None]
    return vecs * cos + np.cross(k, vecs) * sin + k * np.sum(k * vecs, 1)[:, None] * (1 - cos)
NB = rotate(NA, N0v[S['fvi']], N1v[S['fvi']]) if interp == 'faceVarying' else rotate(NA, N0v, N1v)
NB /= np.linalg.norm(NB, axis=1)[:, None]

Wt = ph1['W_top'].astype(np.float64); top = ph1['top']; J_names = [str(x) for x in ph1['J_names']]


def write_body(src, dst):
    """copy the ORIGINAL body and rewrite only the shorts' points / normals / jointWeights / extent
    (jointIndices byte-identical: each weight goes into the slot that already holds its joint)"""
    shutil.copyfile(src, dst)
    lay = Sdf.Layer.FindOrOpen(dst)
    stg = Usd.Stage.Open(dst)
    bd_joints = [str(j).split('/')[-1] for j in UsdSkel.Skeleton([p for p in stg.Traverse() if p.IsA(UsdSkel.Skeleton)][0]).GetJointsAttr().Get()]
    del stg
    spec = lay.GetPrimAtPath(S['path'])
    ji = spec.attributes['primvars:skel:jointIndices']
    es = int(ji.GetInfo('elementSize')) if ji.HasInfo('elementSize') else 1
    Jor = np.array(ji.default, np.int64).reshape(-1, es)
    Wo = np.zeros((n, es), np.float64)
    for i in range(n):
        names = [bd_joints[j] for j in Jor[i]]; used = set()
        for k in range(4):
            w = Wt[i, k]
            if w <= 0:
                continue
            nm = J_names[top[i, k]]
            slot = next((q for q in range(es) if names[q] == nm and q not in used), None)
            if slot is None:
                continue
            Wo[i, slot] = w; used.add(slot)
        Wo[i] /= Wo[i].sum()
    spec.attributes['points'].default = Vt.Vec3fArray.FromNumpy(P.astype(np.float32))
    spec.attributes['normals'].default = Vt.Vec3fArray.FromNumpy(NB.astype(np.float32))
    spec.attributes['primvars:skel:jointWeights'].default = Vt.FloatArray.FromNumpy(Wo.ravel().astype(np.float32))
    spec.attributes['extent'].default = Vt.Vec3fArray([Gf.Vec3f(*P.min(0).astype(float)), Gf.Vec3f(*P.max(0).astype(float))])
    lay.Save()
    tmp = dst + '.compact.usdc'
    Sdf.Layer.FindOrOpen(dst).Export(tmp)
    os.replace(tmp, dst)
    return dst

log['written'] = [write_body(a.v2, os.path.join(a.outdir, 'AnatomyBodyV2.usdc'))]
if a.v1:
    log['written'].append(write_body(a.v1, os.path.join(a.outdir, 'AnatomyBody.usdc')))
np.savez(os.path.join(a.outdir, 'crotch_fix.npz'), P1=P1, P=P, cw=cw)
json.dump(log, open(os.path.join(a.outdir, 'crotch_log.json'), 'w'), indent=1, default=str)
print('CROTCHDONE', json.dumps({k: log[k] for k in ('region', 'iters', 'final')}))
