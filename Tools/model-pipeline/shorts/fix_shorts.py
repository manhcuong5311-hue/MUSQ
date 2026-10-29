# Build a fixed shorts mesh (rest points + skin weights + normals) for the shared male bodies.
# Runs inside Blender (needs mathutils BVH):
#   Blender -b --factory-startup --python fix_shorts.py -- --v2 ORIG/AnatomyBodyV2.usdc --v1 ORIG/AnatomyBody.usdc
#           --outdir FIXED [--clear 0.006] [--g0 0.02] [--g1 0.05] [--wsmooth 3] [--tag name]
# Only the shorts prim's points / normals / jointIndices / jointWeights / extent are rewritten.
import sys, os, json, shutil, argparse, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from slib import *
from mathutils import Vector
from mathutils.bvhtree import BVHTree
from pxr import Usd, Sdf, Vt, Gf, UsdSkel

argv = sys.argv[sys.argv.index('--') + 1:] if '--' in sys.argv else []
ap = argparse.ArgumentParser()
ap.add_argument('--v2', required=True); ap.add_argument('--v1', default=None)
ap.add_argument('--outdir', required=True)
ap.add_argument('--clear', type=float, default=0.006)      # min rest clearance shorts -> outermost muscle (m)
ap.add_argument('--tout', type=float, default=0.04)        # how far outside the shorts a muscle may poke (search)
ap.add_argument('--tin', type=float, default=0.06)         # how deep below the shorts we look for "the muscle beneath"
ap.add_argument('--g0', type=float, default=0.02)          # gap <= g0 : weights 100% from the muscle beneath
ap.add_argument('--g1', type=float, default=0.05)          # gap >= g1 : keep the original weights
ap.add_argument('--wsmooth', type=int, default=3)          # umbrella iterations on the weights
ap.add_argument('--extra', default=None)                   # optional npz with per-vertex extra clearance (pose pass)
ap.add_argument('--maxpush', type=float, default=0.035)
a = ap.parse_args(argv)
os.makedirs(a.outdir, exist_ok=True)
t0 = time.time()
log = {'args': vars(a)}

body = Body(Usd.Stage.Open(a.v2))
S = body.mesh(SHORTS)
n = S['Pb'].shape[0]
assert np.allclose(S['G'], np.eye(4)), 'shorts geomBind is not identity'
P0 = S['Pb'].copy()
tris = S['tris']
edges, ecnt = edges_of(S['fvc'], S['fvi'])
bnd = np.zeros(n, bool); bnd[edges[ecnt == 1].ravel()] = True
lap = laplacian_matrix(n, edges)
log['shorts'] = dict(n=n, faces=len(S['fvc']), boundary_verts=int(bnd.sum()))

# side of each muscle by name; side of each shorts vertex by x (thigh_L side)
bind = np.array(UsdSkel.Skeleton(body.skel_prim).GetBindTransformsAttr().Get()).reshape(-1, 4, 4)
xL = bind[body.jidx['thigh_L'], 3, 0]; sgnL = 1.0 if xL > 0 else -1.0
log['thigh_L_x'] = float(xL)

env = [m for m in body.meshes if not any(k in m['name'] for k in NON_MUSCLE) and m['group'] not in ARM_GROUPS]
lo = P0.min(0) - 0.12; hi = P0.max(0) + 0.12
V = []; T = []; owner = []; vbase = []; off = 0
for mi, m in enumerate(env):
    Pb = m['Pb']; tr = m['tris']
    inbox = np.all((Pb >= lo) & (Pb <= hi), 1)
    keep = inbox[tr].any(1)
    if not keep.any():
        vbase.append(None); continue
    V.append(Pb); T.append(tr[keep] + off); owner.append(np.full(keep.sum(), mi)); vbase.append(off); off += len(Pb)
V = np.concatenate(V); T = np.concatenate(T); owner = np.concatenate(owner)
side_of_mesh = np.array([1 if m['name'].endswith('_L_Mesh') else (-1 if m['name'].endswith('_R_Mesh') else 0) for m in env])
tri_side = side_of_mesh[owner]
log['env'] = dict(meshes=len(env), tris=int(len(T)))

# winding: geometric normals agree with the authored (outward) normals on every muscle (checked: tri_winding_signs)
FRONT = 1.0

def make_bvh(mask):
    return BVHTree.FromPolygons(V.tolist(), T[mask].tolist(), all_triangles=True), np.where(mask)[0]
# side codes: name suffix _L -> +1, _R -> -1.  'L' BVH = left muscles + unsided, 'R' = right + unsided.
bvhs = {'L': make_bvh(tri_side != -1), 'R': make_bvh(tri_side != 1), 'A': make_bvh(np.ones(len(T), bool))}
vside = np.where(np.abs(P0[:, 0]) < 0.03, 'A', np.where(P0[:, 0] * sgnL > 0, 'L', 'R'))
bvh_all, tmap_all = bvhs['A']


def cast_front(bvh, o, d, maxd):
    """first front-facing hit along the ray (skips backfaces = exits from a muscle we started inside)"""
    o = Vector(o); d = Vector(d); trav = 0.0
    for _ in range(12):
        loc, nor, idx, dist = bvh.ray_cast(o, d, maxd - trav)
        if loc is None:
            return None
        if FRONT * nor.dot(d) < 0:
            return np.array(loc), int(idx), trav + dist
        o = loc + d * 1e-5; trav += dist + 1e-5
        if trav >= maxd:
            return None
    return None


def ray_hits(o, d, maxd=1.5):
    hits = []; o = Vector(o); d = Vector(d); trav = 0.0
    for _ in range(300):
        loc, nor, idx, dist = bvh_all.ray_cast(o, d, maxd - trav)
        if loc is None:
            break
        trav += dist
        hits.append((trav, int(owner[tmap_all[idx]])))
        o = loc + d * 1e-6; trav += 1e-6
    return hits


def union_exit(p, d):
    """None if p is outside every muscle (parity along d), else distance along d to leave the muscle union"""
    hits = ray_hits(p, d)
    cnt = {}
    for _, m in hits:
        cnt[m] = cnt.get(m, 0) + 1
    inside = {m for m, c in cnt.items() if c % 2 == 1}
    if not inside:
        return None
    for t, m in hits:
        if m in inside:
            inside.discard(m)
        else:
            inside.add(m)
        if not inside:
            return t
    return hits[-1][0] if hits else None


def perturb(d):
    a_ = np.cross(d, [0.0, 0.0, 1.0])
    if np.linalg.norm(a_) < 1e-3:
        a_ = np.cross(d, [1.0, 0.0, 0.0])
    a_ /= np.linalg.norm(a_)
    v = d + 0.15 * a_
    return v / np.linalg.norm(v)


def outward_normals(P):
    return vertex_normals(P, tris)


def heights(P, Ns):
    """signed poke height: >0 = vertex is inside the muscle union by about that much, <0 = clear gap.
    also returns the outward normal of the nearest muscle surface (best direction to clear it)"""
    h = np.zeros(n); inside = np.zeros(n, bool); nq = Ns.copy()
    for i in range(n):
        e1 = union_exit(P[i], Ns[i])
        bvh, tmap = bvhs[vside[i]]
        loc, nor, idx, dist = bvh.find_nearest(Vector(P[i]), 0.08)
        if loc is not None:
            nq[i] = np.array(nor)
        if e1 is not None:
            e2 = union_exit(P[i], perturb(Ns[i]))       # second ray must agree (guards parity glitches)
            if e2 is not None:
                # grazing normals (hem) make the exit along the normal much longer than the true depth:
                # never push more than 1.6x the distance to the nearest muscle surface
                h[i] = min(e1, 1.6 * dist) if loc is not None else e1; inside[i] = True
                continue
        h[i] = -dist if loc is not None else -0.08
    return h, inside, nq

# orientation of the shorts normals (outward = away from the muscles): front hits along -N should be common
N = outward_normals(P0)
def front_frac(Nv):
    k = 0
    for i in range(0, n, 7):
        bvh, tmap = bvhs[vside[i]]
        if cast_front(bvh, P0[i] + 0.002 * Nv[i], -Nv[i], 0.06) is not None:
            k += 1
    return k / len(range(0, n, 7))
ok1 = front_frac(N); ok2 = front_frac(-N)
FLIP = -1.0 if ok2 > ok1 * 1.3 else 1.0
log['normal_flip'] = FLIP; log['hit_frac'] = [float(ok1), float(ok2)]

cc = None
try:
    from pxr import UsdGeom
    cc = np.array(UsdGeom.PrimvarsAPI(body.stage.GetPrimAtPath(S['path'])).GetPrimvar('CLOTH_Contact').Get(), float)
except Exception:
    cc = np.ones(n)
# CLOTH_Contact = the master's shrinkwrap mask (~0 on the crotch gusset): only push/re-weight where it is set
cc_s = np.clip(umbrella(cc, lap, 0.5, 3), 0, 1)
ccw = np.clip((cc_s - 0.2) / 0.6, 0, 1)
opp = {'L': make_bvh(tri_side == -1), 'R': make_bvh(tri_side == 1)}


def room_to_other_leg(P, Ns):
    """distance along the normal to the OTHER leg's muscles (inner thigh panels must not be pushed into it)"""
    r = np.full(n, np.inf)
    for i in range(n):
        if vside[i] == 'A':
            continue
        bvh, tmap = opp[vside[i]]
        hit = cast_front(bvh, P[i] + 0.0005 * Ns[i], Ns[i], 0.15)
        if hit is not None:
            r[i] = hit[2]
    return r
extra = np.zeros(n)
if a.extra:
    extra = np.load(a.extra)['extra']
clear = a.clear + extra

leg = np.clip((0.90 - P0[:, 2]) / 0.06, 0, 1)        # 1 on the leg tubes (below ~0.84 m), 0 above 0.90 m


def push_dir(Ns):
    U = Ns.copy(); U[:, 2] *= (1 - 0.7 * leg)
    return U / np.linalg.norm(U, axis=1)[:, None]

# ---------- A) rest push ----------
P = P0.copy(); hist = []; total = np.zeros(n)
for it in range(8):
    N = FLIP * outward_normals(P)
    Ns = umbrella(N, lap, 0.5, 8); Ns /= np.linalg.norm(Ns, axis=1)[:, None]
    h, ins, nq = heights(P, Ns)
    if it == 0:
        h_rest0, ins0 = h.copy(), ins.copy()
    need = np.maximum(0.0, h + clear) * ccw
    room = room_to_other_leg(P, Ns)
    need = np.minimum(need, np.maximum(0.0, 0.5 * room - 0.003))
    need = np.minimum(need, np.maximum(0.0, a.maxpush - total))
    hist.append(dict(it=it, inside=int(ins.sum()), viol=int((need > 0.0005).sum()), max_need_mm=round(1000 * float(need.max()), 2),
                     max_inside_mm=round(1000 * float(h.max()), 2)))
    if need.max() < 0.0005:
        break
    D = need.copy()
    for k in range(80):
        D = np.maximum(need, umbrella(D, lap, 0.5, 1))
    U = push_dir(Ns)
    P = P + D[:, None] * U
    total += D
log['push_iters'] = hist
push = np.linalg.norm(P - P0, axis=1)
log['push'] = dict(max_mm=round(1000 * float(push.max()), 2), mean_mm=round(1000 * float(push.mean()), 2),
                   moved_gt1mm=int((push > 0.001).sum()))
# light fairing of the displacement field (keeps hem/waistband lines clean), then a last tiny re-push
Dv = umbrella(P - P0, lap, 0.5, 4)
P = P0 + Dv
N = FLIP * outward_normals(P); Ns = umbrella(N, lap, 0.5, 8); Ns /= np.linalg.norm(Ns, axis=1)[:, None]
h, ins, nq = heights(P, Ns)
need = np.minimum(np.maximum(0.0, h + clear * 0.85), 0.01) * ccw
need = np.minimum(need, np.maximum(0.0, 0.5 * room_to_other_leg(P, Ns) - 0.003))
D = need.copy()
for k in range(30):
    D = np.maximum(need, umbrella(D, lap, 0.5, 1))
P = P + D[:, None] * push_dir(Ns)
log['final_repush_max_mm'] = round(1000 * float(need.max()), 2)
h_fin, ins_fin, _ = heights(P, FLIP * outward_normals(P))
log['final_state'] = dict(inside=int(ins_fin.sum()), inside_ccw=int((ins_fin & (ccw > 0.5)).sum()), min_gap_mm=round(-1000 * float(h_fin.max()), 2),
                          gap_lt_3mm=int((h_fin > -0.003).sum()))
log['rest0'] = dict(inside=int(ins0.sum()), max_inside_mm=round(1000 * float(h_rest0.max()), 2),
                    inside_by_cc={'cc<0.5': int((ins0 & (cc < 0.5)).sum()), 'cc>=0.5': int((ins0 & (cc >= 0.5)).sum())})
# ---------- B) weights from the muscle beneath ----------
N = FLIP * outward_normals(P); Ns = umbrella(N, lap, 0.5, 8); Ns /= np.linalg.norm(Ns, axis=1)[:, None]
ht = np.full(n, -1); hp = np.zeros((n, 3))
for i in range(n):
    bvh, tmap = bvhs[vside[i]]
    r = cast_front(bvh, P[i] + 0.002 * Ns[i], -Ns[i], a.tin)
    if r is not None:
        hp[i] = r[0]; ht[i] = tmap[r[1]]
# dense joint basis = union of joints used by shorts + envelope region
J_names = sorted(set(body.joints[j] for j in np.unique(S['J'][S['W'] > 0])) |
                 set(body.joints[j] for m in env for j in np.unique(m['J'][m['W'] > 0])))
jcol = {nm: i for i, nm in enumerate(J_names)}
def dense_w(J, W):
    D = np.zeros((J.shape[0], len(J_names)))
    for k in range(J.shape[1]):
        cols = np.array([jcol.get(body.joints[j], -1) for j in J[:, k]])
        ok = (W[:, k] > 0) & (cols >= 0)
        np.add.at(D, (np.where(ok)[0], cols[ok]), W[ok, k])
    return D
Wsh = dense_w(S['J'], S['W'])
# per-env-mesh dense weights on demand
dw_cache = {}
def env_dense(mi):
    if mi not in dw_cache:
        dw_cache[mi] = dense_w(env[mi]['J'], env[mi]['W'])
    return dw_cache[mi]

Wm = np.zeros_like(Wsh); gap = np.full(n, np.inf); beneath = np.full(n, -1)
for i in range(n):
    if ht[i] < 0:
        # fallback: nearest muscle point within tin
        bvh, tmap = bvhs[vside[i]]
        loc, nor, idx, dist = bvh.find_nearest(Vector(P[i]), a.tin)
        if loc is None:
            continue
        ti = tmap[idx]; q = np.array(loc)
    else:
        ti = ht[i]; q = hp[i]
    mi = owner[ti]; tv = T[ti] - vbase[mi]
    A, B, C = env[mi]['Pb'][tv]
    # barycentric of q in (A,B,C)
    v0, v1, v2 = B - A, C - A, q - A
    d00, d01, d11, d20, d21 = v0 @ v0, v0 @ v1, v1 @ v1, v2 @ v0, v2 @ v1
    den = d00 * d11 - d01 * d01
    if abs(den) < 1e-18:
        bc = np.array([1 / 3, 1 / 3, 1 / 3])
    else:
        vv = (d11 * d20 - d01 * d21) / den; ww = (d00 * d21 - d01 * d20) / den
        bc = np.clip(np.array([1 - vv - ww, vv, ww]), 0, 1); bc /= bc.sum()
    Wm[i] = bc @ env_dense(mi)[tv]
    gap[i] = np.linalg.norm(P[i] - q); beneath[i] = mi
alpha = np.clip((a.g1 - gap) / (a.g1 - a.g0), 0, 1)
alpha[~np.isfinite(gap)] = 0
alpha *= ccw                       # the gusset keeps its original weights
Wn = alpha[:, None] * Wm + (1 - alpha[:, None]) * Wsh
Wn = umbrella(Wn, lap, 0.5, a.wsmooth)
# prune to 4, renormalise
order = np.argsort(-Wn, axis=1)
top = order[:, :4]
Wt = np.take_along_axis(Wn, top, 1); Wt[Wt < 0.01] = 0
Wt /= Wt.sum(1)[:, None]
log['weights'] = dict(alpha_mean=round(float(alpha.mean()), 3), alpha_full=int((alpha > 0.999).sum()),
                      alpha_zero=int((alpha < 1e-3).sum()),
                      beneath_counts={env[k]['name']: int(c) for k, c in zip(*np.unique(beneath[beneath >= 0], return_counts=True))},
                      joint_totals={J_names[j]: round(float(Wn[:, j].sum()), 1) for j in range(len(J_names)) if Wn[:, j].sum() > 0.5})

# ---------- normals (faceVarying, rotate authored normals by the change of the smooth vertex normal) ----------
st = body.stage
pr = st.GetPrimAtPath(S['path'])
nattr = pr.GetAttribute('normals')
NA = np.array(nattr.Get(), np.float64)
interp = nattr.GetMetadata('interpolation')
N0v = vertex_normals(P0, tris); N1v = vertex_normals(P, tris)
def rotate(vecs, a_, b_):
    # rotate vecs by the rotation taking unit a_ to unit b_ (row-wise)
    v = np.cross(a_, b_); c = np.sum(a_ * b_, 1); s = np.linalg.norm(v, axis=1)
    k = np.where(s[:, None] > 1e-9, v / np.maximum(s, 1e-12)[:, None], 0)
    ang = np.arctan2(s, c)
    cos, sin = np.cos(ang)[:, None], np.sin(ang)[:, None]
    return vecs * cos + np.cross(k, vecs) * sin + k * np.sum(k * vecs, 1)[:, None] * (1 - cos)
if interp == 'faceVarying':
    vid = S['fvi']
    NB = rotate(NA, N0v[vid], N1v[vid])
else:
    NB = rotate(NA, N0v, N1v)
NB /= np.linalg.norm(NB, axis=1)[:, None]
log['normals'] = dict(interp=interp, authored_vs_geom_dot=round(float(np.mean(np.sum(NA * (N0v[S['fvi']] if interp == 'faceVarying' else N0v), 1))), 3))

np.savez(os.path.join(a.outdir, 'shorts_fix.npz'), P0=P0, P=P, h_rest0=h_rest0, ins0=ins0, cc=cc, W_dense=Wn, W_top=Wt, top=top, J_names=np.array(J_names),
         alpha=alpha, gap=gap, beneath=beneath, push=np.linalg.norm(P - P0, axis=1), NB=NB)

# ---------- write both body files ----------
def write_body(src, dst):
    """copy the body file and rewrite ONLY the shorts' points / normals / jointWeights / extent.
    jointIndices stay byte-identical: each new weight goes into the slot that already holds that joint."""
    shutil.copyfile(src, dst)
    lay = Sdf.Layer.FindOrOpen(dst)
    stg = Usd.Stage.Open(dst)
    bd_joints = [str(j).split('/')[-1] for j in UsdSkel.Skeleton([p for p in stg.Traverse() if p.IsA(UsdSkel.Skeleton)][0]).GetJointsAttr().Get()]
    del stg
    spec = lay.GetPrimAtPath(S['path'])
    assert spec is not None, 'shorts prim spec not in root layer'
    ji = spec.attributes['primvars:skel:jointIndices']
    es = int(ji.GetInfo('elementSize')) if ji.HasInfo('elementSize') else 1
    Jor = np.array(ji.default, np.int64).reshape(-1, es)
    Wo = np.zeros((n, es), np.float64); dropped = []
    for i in range(n):
        names = [bd_joints[j] for j in Jor[i]]
        used = set(); lost = 0.0
        for k in range(4):
            w = Wt[i, k]
            if w <= 0:
                continue
            nm = J_names[top[i, k]]
            slot = next((q for q in range(es) if names[q] == nm and q not in used), None)
            if slot is None:
                lost += w; continue
            Wo[i, slot] = w; used.add(slot)
        if lost > 0:
            dropped.append(lost)
        Wo[i] /= Wo[i].sum()
    assert ((Wo > 0).sum(1) <= 4).all()
    def setv(name, val):
        spec.attributes[name].default = val
    setv('points', Vt.Vec3fArray.FromNumpy(P.astype(np.float32)))
    setv('normals', Vt.Vec3fArray.FromNumpy(NB.astype(np.float32)))
    setv('primvars:skel:jointWeights', Vt.FloatArray.FromNumpy(Wo.ravel().astype(np.float32)))
    setv('extent', Vt.Vec3fArray([Gf.Vec3f(*P.min(0).astype(float)), Gf.Vec3f(*P.max(0).astype(float))]))
    lay.Save()
    # re-export so the crate file is compact (an in-place save appends ~0.5 MB of dead data)
    tmp = dst + '.compact.usdc'
    Sdf.Layer.FindOrOpen(dst).Export(tmp)
    os.replace(tmp, dst)
    return dict(dst=dst, elementSize=es, verts_with_dropped_joint=len(dropped), max_dropped=round(max(dropped), 4) if dropped else 0)

out = {}
out['V2'] = write_body(a.v2, os.path.join(a.outdir, 'AnatomyBodyV2.usdc'))
if a.v1:
    out['V1'] = write_body(a.v1, os.path.join(a.outdir, 'AnatomyBody.usdc'))
log['written'] = out
log['secs'] = round(time.time() - t0, 1)
json.dump(log, open(os.path.join(a.outdir, 'fix_log.json'), 'w'), indent=1, default=str)
print('FIXDONE', json.dumps({k: log[k] for k in ('push_iters', 'push', 'final_repush_max_mm', 'final_state', 'rest0', 'normal_flip', 'hit_frac', 'secs')}, default=str))
print('WEIGHTS', json.dumps(log['weights'], default=str)[:1500])

