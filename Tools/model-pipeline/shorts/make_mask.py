# Bakes where the shorts cover the glutes into two textures over the shorts' own UVs (2026-10-28):
# <out>.png covers gluteus maximus, <out>Medius.png gluteus medius + minimus; in both red = left
# side, green = right, soft-edged. The app tints the shorts with each muscle's own paint through
# them. The maximus zone runs down the back of the shorts to the hem: in a deep hinge the hem rides
# up over the lower buttock, and a zone that stopped at the gluteal fold left navy patches there.
# Rest pose from the shared body itself (points x geomBindTransform; that space is Z up, +Y back,
# +X the left side), so it fits every model that references the body.
#   blender -b --factory-startup --python make_mask.py -- <AnatomyBody*.usdc> <out.png> [size] [dmax_m]
import bpy, sys
import numpy as np
import mathutils
from mathutils.bvhtree import BVHTree
from pxr import Usd, UsdGeom
argv = sys.argv[sys.argv.index('--') + 1:]
body, out = argv[0], argv[1]
SIZE = int(argv[2]) if len(argv) > 2 else 512
DMAX = float(argv[3]) if len(argv) > 3 else 0.045
st = Usd.Stage.Open(body)
rig = '/root/Anatomy_MasterRig'


def mesh_rest(path):
    p = st.GetPrimAtPath(path); m = UsdGeom.Mesh(p)
    pts = np.array(m.GetPointsAttr().Get(), dtype=np.float64)
    G = np.array(UsdGeom.PrimvarsAPI(p).GetPrimvar('skel:geomBindTransform').Get(), dtype=np.float64)
    pts = (np.c_[pts, np.ones(len(pts))] @ G)[:, :3]
    fvc = np.array(m.GetFaceVertexCountsAttr().Get()); fvi = np.array(m.GetFaceVertexIndicesAttr().Get())
    faces, k = [], 0
    for c in fvc:
        faces.append(tuple(fvi[k:k + c])); k += c
    return p, pts, faces, fvc, fvi


sp, S, SF, sfvc, sfvi = mesh_rest(f'{rig}/Anatomy_Shorts/Anatomy_Shorts_Surface')
cc = np.array(UsdGeom.PrimvarsAPI(sp).GetPrimvar('CLOTH_Contact').Get(), dtype=np.float64)
trees = []                                   # (side, group, tree)
for side in ('L', 'R'):
    for g, grp in (('GluteusMaximus', 'max'), ('GluteusMedius', 'med'), ('GluteusMinimus', 'med')):
        name = f'{g}_{side}'
        _, V, F, _, _ = mesh_rest(f'{rig}/{name}/{name}_Mesh')
        trees.append((side, grp, BVHTree.FromPolygons([mathutils.Vector(v) for v in V], F)))
SV = [mathutils.Vector(v) for v in S]
hit_of = [None] * len(SF)                    # (side, group) of the first glute under each face
for i, f in enumerate(SF):
    pts = [SV[k] for k in f]
    c = sum(pts, mathutils.Vector()) / len(pts)
    n = (pts[1] - pts[0]).cross(pts[2] - pts[0])
    if n.length < 1e-12:
        continue
    n.normalize(); best = None
    for d in (-n, n):
        for side, grp, t in trees:
            hit = t.ray_cast(c + d * 0.001, d, DMAX)
            if hit[0] is not None and (best is None or hit[3] < best[0]):
                best = (hit[3], side, grp)
    if best:
        hit_of[i] = (best[1], best[2])

# the back of the shorts below the waistband, outside the crotch gusset: maximus, down to the hem
cy = S[:, 1].mean()
fc = np.array([S[list(f)].mean(0) for f in SF]); fcc = np.array([cc[list(f)].mean() for f in SF])
back = (fc[:, 1] > cy + 0.05) & (fc[:, 2] < 0.95) & (fcc >= 0.5)
for i in np.where(back)[0]:
    if hit_of[i] is None or hit_of[i][1] == 'max':
        hit_of[i] = ('L' if fc[i, 0] > 0 else 'R', 'max')

nv = len(SV)
vf = [[] for _ in range(nv)]
for i, f in enumerate(SF):
    for k in f:
        vf[k].append(i)
nbr = [set() for _ in range(nv)]
for f in SF:
    for a in range(len(f)):
        u, v = f[a], f[(a + 1) % len(f)]; nbr[u].add(v); nbr[v].add(u)


def smooth(m, it):
    for _ in range(it):
        m = [0.5 * m[k] + 0.5 * (sum(m[j] for j in nbr[k]) / max(1, len(nbr[k]))) for k in range(nv)]
    return m


def ss(e0, e1, x):
    t = min(1.0, max(0.0, (x - e0) / (e1 - e0))); return t * t * (3 - 2 * t)


masks = {}
for key in (('L', 'max'), ('R', 'max'), ('L', 'med'), ('R', 'med')):
    m = smooth([sum(1 for i in vf[k] if hit_of[i] == key) / max(1, len(vf[k])) for k in range(nv)], 4)
    zone = {i for i, f in enumerate(SF) if sum(m[k] for k in f) / len(f) > 0.5}
    ef = {}
    for i in zone:
        f = SF[i]
        for a in range(len(f)):
            ef.setdefault(tuple(sorted((f[a], f[(a + 1) % len(f)]))), []).append(i)
    adj = {i: set() for i in zone}
    for fl in ef.values():
        for a in fl:
            for b in fl:
                if a != b:
                    adj[a].add(b)
    seen, keep = set(), set()
    for i in zone:
        if i in seen:
            continue
        comp, stack = [], [i]; seen.add(i)
        while stack:
            x = stack.pop(); comp.append(x)
            for y in adj[x]:
                if y not in seen:
                    seen.add(y); stack.append(y)
        if len(comp) >= 15:
            keep.update(comp)
    m = smooth([sum(1 for i in vf[k] if i in keep) / max(1, len(vf[k])) for k in range(nv)], 10)
    masks[key] = np.array([ss(0.25, 0.85, x) for x in m])
    print('zone', key, 'faces', len(keep), 'verts >0.5', int((masks[key] > 0.5).sum()))

pv = UsdGeom.PrimvarsAPI(sp).GetPrimvar('st')
ia = pv.GetIndicesAttr(); ii = ia.Get() if ia.Get() is not None else ia.Get(ia.GetTimeSamples()[0])
uvs = np.array(pv.Get())[np.array(ii, dtype=np.int64)]


def bake(chans):
    img = np.zeros((SIZE, SIZE, 2)); cov = np.zeros((SIZE, SIZE), bool)
    k = 0
    for c in sfvc:
        corners = list(range(k, k + c)); k += c
        for t in range(1, c - 1):
            tri = [corners[0], corners[t], corners[t + 1]]
            P = np.array([[uvs[j][0] * SIZE, uvs[j][1] * SIZE] for j in tri])     # x, y from the bottom
            val = np.array([[chans[0][sfvi[j]], chans[1][sfvi[j]]] for j in tri])
            x0, y0 = np.floor(P.min(0)).astype(int); x1, y1 = np.ceil(P.max(0)).astype(int)
            x0, y0 = max(x0, 0), max(y0, 0); x1, y1 = min(x1, SIZE - 1), min(y1, SIZE - 1)
            if x1 < x0 or y1 < y0:
                continue
            xs, ys = np.meshgrid(np.arange(x0, x1 + 1) + 0.5, np.arange(y0, y1 + 1) + 0.5)
            (ax, ay), (bx, by), (cx2, cy2) = P
            den = (by - cy2) * (ax - cx2) + (cx2 - bx) * (ay - cy2)
            if abs(den) < 1e-12:
                continue
            w0 = ((by - cy2) * (xs - cx2) + (cx2 - bx) * (ys - cy2)) / den
            w1 = ((cy2 - ay) * (xs - cx2) + (ax - cx2) * (ys - cy2)) / den
            w2 = 1 - w0 - w1
            inside = (w0 >= -1e-3) & (w1 >= -1e-3) & (w2 >= -1e-3)
            if not inside.any():
                continue
            vv = w0[..., None] * val[0] + w1[..., None] * val[1] + w2[..., None] * val[2]
            sub = img[y0:y1 + 1, x0:x1 + 1]; sub[inside] = vv[inside]
            cov[y0:y1 + 1, x0:x1 + 1] |= inside
    # grow each UV island a few pixels so filtering at seams never reads the empty background
    for _ in range(6):
        acc = np.zeros_like(img); n = np.zeros(cov.shape)
        for dy in (-1, 0, 1):
            for dx in (-1, 0, 1):
                if dx == dy == 0:
                    continue
                sh_c = np.roll(np.roll(cov, dy, 0), dx, 1); sh_i = np.roll(np.roll(img, dy, 0), dx, 1)
                acc += sh_i * sh_c[..., None]; n += sh_c
        grow = (~cov) & (n > 0)
        img[grow] = acc[grow] / n[grow][:, None]; cov |= grow
    return img


for suffix, grp in (('', 'max'), ('Medius', 'med')):
    img = bake((masks[('L', grp)], masks[('R', grp)]))
    im = bpy.data.images.new('mask' + suffix, SIZE, SIZE, alpha=False)
    im.colorspace_settings.name = 'Non-Color'
    px = np.zeros((SIZE, SIZE, 4)); px[..., 0] = img[..., 0]; px[..., 1] = img[..., 1]; px[..., 3] = 1
    im.pixels.foreach_set(px.astype(np.float32).ravel())     # Blender rows run bottom-up, like v
    path = out[:-4] + suffix + '.png'
    im.filepath_raw = path; im.file_format = 'PNG'; im.save()
    print('MASK', path, SIZE)
