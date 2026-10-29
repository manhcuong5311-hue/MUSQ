# Shared helpers for the shorts-fit track (pxr + numpy; BVH helpers need Blender's mathutils).
# All geometry is handled in SKELETON space: rest = points x geomBindTransform, posed = LBS with
# UsdSkel skinning transforms (exactly what RealityKit plays: linear blend skinning, no blend shapes).
import numpy as np
from pxr import Usd, UsdSkel, UsdGeom, UsdShade

SHORTS = 'Anatomy_Shorts_Surface'
NON_MUSCLE = ('Shorts', 'Shoes', 'FacelessHead', 'FleshedHand')
ARM_GROUPS = ('Biceps', 'Triceps', 'Brachialis', 'Forearms', 'FrontDelt', 'SideDelt', 'RearDelt',
              'RotatorCuff', 'Neck')


def triangulate(fvc, fvi):
    """fan triangulation -> (T,3) vertex ids and (T,) face ids"""
    fvc = np.asarray(fvc); fvi = np.asarray(fvi)
    starts = np.concatenate([[0], np.cumsum(fvc)[:-1]])
    tris = []; tface = []
    for c in np.unique(fvc):
        sel = np.where(fvc == c)[0]
        s = starts[sel]
        for k in range(1, c - 1):
            tris.append(np.stack([fvi[s], fvi[s + k], fvi[s + k + 1]], 1)); tface.append(sel)
    tris = np.concatenate(tris); tface = np.concatenate(tface)
    o = np.argsort(tface, kind='stable')
    return tris[o], tface[o]


def group_of(mat):
    # FF_Highlight_Glutes_L -> Glutes ; DARK_Clothing_Matte -> DARK_Clothing_Matte
    if mat.startswith('FF_Highlight_'):
        g = mat[len('FF_Highlight_'):]
        return g.rsplit('_', 1)[0] if g.endswith(('_L', '_R')) else g
    if mat.startswith('DARK_Muscle_'):
        g = mat[len('DARK_Muscle_'):]
        return g.rsplit('_', 1)[0] if g.endswith(('_L', '_R')) else g
    return mat


class Body:
    """Every skinned mesh of a composed stage (a body file or a slim model referencing one)."""

    def __init__(self, stage):
        self.stage = stage
        sk = [p for p in stage.Traverse() if p.IsA(UsdSkel.Skeleton)]
        self.skel_prim = sk[0]
        self.joint_paths = [str(j) for j in UsdSkel.Skeleton(sk[0]).GetJointsAttr().Get()]
        self.joints = [j.split('/')[-1] for j in self.joint_paths]
        self.jidx = {n: i for i, n in enumerate(self.joints)}
        roots = [p for p in stage.Traverse() if p.IsA(UsdSkel.Root)]
        self.root_prim = roots[0]
        self.meshes = []
        for pr in stage.Traverse():
            if not pr.IsA(UsdGeom.Mesh):
                continue
            m = UsdGeom.Mesh(pr); b = UsdSkel.BindingAPI(pr)
            jip = b.GetJointIndicesPrimvar()
            if not (jip and jip.IsDefined()):
                continue
            # only meshes under the SkelRoot
            if not str(pr.GetPath()).startswith(str(self.root_prim.GetPath()) + '/'):
                continue
            P = np.array(m.GetPointsAttr().Get(), np.float64)
            es = jip.GetElementSize()
            J = np.array(jip.Get(), np.int64).reshape(-1, es)
            W = np.array(b.GetJointWeightsPrimvar().Get(), np.float64).reshape(-1, es)
            ga = b.GetGeomBindTransformAttr()
            G = np.array(ga.Get(), np.float64) if ga and ga.HasAuthoredValue() else np.eye(4)
            fvc = np.array(m.GetFaceVertexCountsAttr().Get()); fvi = np.array(m.GetFaceVertexIndicesAttr().Get())
            tris, tface = triangulate(fvc, fvi)
            mp = UsdShade.MaterialBindingAPI(pr).GetDirectBinding().GetMaterialPath()
            mat = mp.name if mp else ''
            name = pr.GetName()
            Pb = P @ G[:3, :3] + G[3, :3]
            na = m.GetNormalsAttr()
            NA = np.array(na.Get(), np.float64) if na and na.HasAuthoredValue() else None
            ninterp = m.GetNormalsInterpolation() if NA is not None else None
            self.meshes.append(dict(name=name, path=str(pr.GetPath()), mat=mat, group=group_of(mat), P=P, Pb=Pb,
                                    J=J, W=W, G=G, fvc=fvc, fvi=fvi, tris=tris, tface=tface, es=es,
                                    NA=NA, ninterp=ninterp))
        self.by_name = {m['name']: i for i, m in enumerate(self.meshes)}

    def mesh(self, name):
        return self.meshes[self.by_name[name]]

    # ---------- animation ----------
    def time_range(self):
        return int(round(self.stage.GetStartTimeCode())), int(round(self.stage.GetEndTimeCode()))

    def skel_query(self):
        if not hasattr(self, '_skq'):
            cache = UsdSkel.Cache()
            cache.Populate(UsdSkel.Root(self.root_prim), Usd.PrimDefaultPredicate)
            self._cache = cache
            self._skq = cache.GetSkelQuery(UsdSkel.Skeleton(self.skel_prim))
        return self._skq

    def skin_xforms(self, t):
        X = self.skel_query().ComputeSkinningTransforms(Usd.TimeCode(t))
        return np.array(X, np.float64).reshape(-1, 4, 4)

    def joint_xforms(self, t):
        X = self.skel_query().ComputeJointSkelTransforms(Usd.TimeCode(t))
        return np.array(X, np.float64).reshape(-1, 4, 4)


def lbs(Pb, J, W, X):
    """linear blend skinning of bind-space points (row-vector convention like USD)"""
    out = np.zeros((Pb.shape[0], 3))
    for k in range(J.shape[1]):
        w = W[:, k]
        nz = w > 0
        if not nz.any():
            continue
        M = X[J[nz, k]]                                         # (n,4,4)
        p = np.einsum('ni,nij->nj', Pb[nz], M[:, :3, :3]) + M[:, 3, :3]
        out[nz] += w[nz, None] * p
    return out


def lbs_mesh(m, X, Pb=None, J=None, W=None):
    return lbs(m['Pb'] if Pb is None else Pb, m['J'] if J is None else J, m['W'] if W is None else W, X)


def vertex_normals(P, tris):
    fn = np.cross(P[tris[:, 1]] - P[tris[:, 0]], P[tris[:, 2]] - P[tris[:, 0]])  # area weighted
    N = np.zeros_like(P)
    for k in range(3):
        np.add.at(N, tris[:, k], fn)
    l = np.linalg.norm(N, axis=1); l[l == 0] = 1
    return N / l[:, None]


def edges_of(fvc, fvi):
    starts = np.concatenate([[0], np.cumsum(fvc)[:-1]])
    E = []
    for s, c in zip(starts, fvc):
        f = fvi[s:s + c]
        for k in range(c):
            a, b = f[k], f[(k + 1) % c]
            E.append((min(a, b), max(a, b)))
    E = np.array(E)
    u, cnt = np.unique(E, axis=0, return_counts=True)
    return u, cnt  # unique edges + how many faces use each


def adjacency(n, edges):
    nb = [[] for _ in range(n)]
    for a, b in edges:
        nb[a].append(b); nb[b].append(a)
    return nb


def laplacian_matrix(n, edges):
    """row-normalised umbrella operator as a scipy-free sparse (index arrays)"""
    a = np.concatenate([edges[:, 0], edges[:, 1]]); b = np.concatenate([edges[:, 1], edges[:, 0]])
    deg = np.bincount(a, minlength=n).astype(np.float64)
    return a, b, deg


def umbrella(F, lap, lam=0.5, iters=1, fixed=None):
    a, b, deg = lap
    F = F.copy()
    for _ in range(iters):
        S = np.zeros_like(F)
        np.add.at(S, a, F[b])
        d = deg.copy(); d[d == 0] = 1
        avg = S / (d[:, None] if F.ndim == 2 else d)
        Fn = F + lam * (avg - F)
        if fixed is not None:
            Fn[fixed] = F[fixed]
        F = Fn
    return F


def hip_angles(body, t):
    """signed hip flexion (deg) for L and R from joint positions: + flexion, - extension"""
    Xj = body.joint_xforms(t)
    pos = lambda n: Xj[body.jidx[n], 3, :3]
    up = pos('spine') - pos('pelvis'); up /= np.linalg.norm(up)
    lat = pos('thigh_L') - pos('thigh_R'); lat /= np.linalg.norm(lat)
    fwd = np.cross(lat, up); fwd /= np.linalg.norm(fwd)
    out = {}
    for s in ('L', 'R'):
        th = pos('shin_' + s) - pos('thigh_' + s); th /= np.linalg.norm(th)
        ang = np.degrees(np.arccos(np.clip(np.dot(-up, th), -1, 1)))
        sign = 1.0 if np.dot(th, fwd) >= 0 else -1.0
        out[s] = sign * ang
    return out, pos('pelvis'), fwd, up


def winding_sign(m):
    """+1 if the triangle winding agrees with the authored normals (outward), -1 if opposite, 0 unknown"""
    if m.get('NA') is None:
        return 0
    Ng = vertex_normals(m['Pb'], m['tris'])
    G3 = m['G'][:3, :3]
    NA = m['NA'] @ G3
    if m['ninterp'] == 'faceVarying':
        d = np.sum(NA * Ng[m['fvi']], 1)
    elif len(NA) == len(Ng):
        d = np.sum(NA * Ng, 1)
    else:
        return 0
    return 1 if d.mean() >= 0 else -1


def tri_winding_signs(m):
    """per-triangle sign: geometric face normal vs the face's authored normals"""
    if m.get('NA') is None:
        return np.ones(len(m['tris']))
    P = m['Pb']; tr = m['tris']
    fn = np.cross(P[tr[:, 1]] - P[tr[:, 0]], P[tr[:, 2]] - P[tr[:, 0]])
    G3 = m['G'][:3, :3]
    if m['ninterp'] == 'faceVarying':
        starts = np.concatenate([[0], np.cumsum(m['fvc'])[:-1]])
        NA = m['NA'] @ G3
        fsum = np.add.reduceat(NA, starts)            # sum of a face's corner normals
        an = fsum[m['tface']]
    else:
        NA = m['NA'] @ G3
        an = NA[tr].sum(1)
    d = np.sum(fn * an, 1)
    return np.where(d >= 0, 1.0, -1.0)
