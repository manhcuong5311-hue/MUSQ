# Replaces BasisCurves (which RealityKit does not draw) with meshes.
#  - static curves  -> one swept tube mesh
#  - curves whose points are time-sampled -> a chain of rigid cylinder
#    segments, each with time-sampled translate/rotateXYZ/scale, because
#    RealityKit plays transform animation but not point-cache animation.
import math
from pxr import Usd, UsdGeom, UsdShade, Sdf, Gf, Vt

SIDES = 10

def bezier_polyline(cvs, steps=8):
    out = [Gf.Vec3d(cvs[0])]
    for s in range(0, len(cvs) - 3, 3):
        p0, p1, p2, p3 = [Gf.Vec3d(c) for c in cvs[s:s + 4]]
        for i in range(1, steps + 1):
            t = i / steps; u = 1 - t
            out.append(p0*u*u*u + p1*3*u*u*t + p2*3*u*t*t + p3*t*t*t)
    return out

def polyline(curve, t):
    pts = [Gf.Vec3d(p) for p in curve.GetPointsAttr().Get(t)]
    if curve.GetTypeAttr().Get() == "cubic" and curve.GetBasisAttr().Get() == "bezier":
        return bezier_polyline(pts)
    return pts

def any_perp(v):
    a = Gf.Vec3d(1, 0, 0) if abs(v[0]) < 0.9 else Gf.Vec3d(0, 1, 0)
    return Gf.Cross(v, a).GetNormalized()

def tube_mesh(stage, path, pts, r):
    """Swept tube along a static polyline, parallel-transport frames."""
    n = len(pts)
    tans = []
    for i in range(n):
        a = pts[max(i - 1, 0)]; b = pts[min(i + 1, n - 1)]
        tans.append((b - a).GetNormalized())
    nrm = any_perp(tans[0])
    verts, norms = [], []
    for i in range(n):
        if i:
            # transport the frame: remove the component along the new tangent
            nrm = (nrm - tans[i] * Gf.Dot(nrm, tans[i])).GetNormalized()
        bin_ = Gf.Cross(tans[i], nrm)
        for k in range(SIDES):
            a = 2 * math.pi * k / SIDES
            d = nrm * math.cos(a) + bin_ * math.sin(a)
            verts.append(Gf.Vec3f(pts[i] + d * r)); norms.append(Gf.Vec3f(d))
    counts, idx = [], []
    for i in range(n - 1):
        for k in range(SIDES):
            k2 = (k + 1) % SIDES
            idx += [i*SIDES + k, i*SIDES + k2, (i+1)*SIDES + k2, (i+1)*SIDES + k]
            counts.append(4)
    m = UsdGeom.Mesh.Define(stage, path)
    m.CreatePointsAttr(Vt.Vec3fArray(verts))
    m.CreateFaceVertexCountsAttr(counts); m.CreateFaceVertexIndicesAttr(idx)
    m.CreateNormalsAttr(Vt.Vec3fArray(norms)); m.SetNormalsInterpolation(UsdGeom.Tokens.vertex)
    m.CreateSubdivisionSchemeAttr("none")
    ext = Vt.Vec3fArray(verts); m.CreateExtentAttr(UsdGeom.PointBased.ComputeExtent(ext))
    return m

def unit_cylinder(stage, path, r):
    """Open cylinder, radius r, height 1 along +Y, centred on the origin."""
    verts, norms, counts, idx = [], [], [], []
    for y in (-0.5, 0.5):
        for k in range(SIDES):
            a = 2 * math.pi * k / SIDES
            verts.append(Gf.Vec3f(r * math.cos(a), y, r * math.sin(a)))
            norms.append(Gf.Vec3f(math.cos(a), 0, math.sin(a)))
    for k in range(SIDES):
        k2 = (k + 1) % SIDES
        idx += [k, SIDES + k, SIDES + k2, k2]; counts.append(4)
    m = UsdGeom.Mesh.Define(stage, path)
    m.CreatePointsAttr(Vt.Vec3fArray(verts))
    m.CreateFaceVertexCountsAttr(counts); m.CreateFaceVertexIndicesAttr(idx)
    m.CreateNormalsAttr(Vt.Vec3fArray(norms)); m.SetNormalsInterpolation(UsdGeom.Tokens.vertex)
    m.CreateSubdivisionSchemeAttr("none")
    m.CreateExtentAttr([Gf.Vec3f(-r, -0.5, -r), Gf.Vec3f(r, 0.5, r)])
    return m

def euler_xyz(rot):
    """Angles (deg) for xformOp:rotateXYZ reproducing `rot` (X applied first)."""
    # USD rotateXYZ composes as Rx * Ry * Rz with row vectors; Decompose's axis
    # order is the inverse of the application order.
    z, y, x = rot.Decompose(Gf.Vec3d.ZAxis(), Gf.Vec3d.YAxis(), Gf.Vec3d.XAxis())
    return Gf.Vec3f(x, y, z)

def segment_chain(stage, path, curve, r, times):
    root = UsdGeom.Xform.Define(stage, path)
    n = len(polyline(curve, times[0]))
    cyl_paths = []
    ops = []
    for s in range(n - 1):
        seg = UsdGeom.Xform.Define(stage, f"{path}/Seg_{s:02d}")
        ops.append((seg.AddTranslateOp(), seg.AddRotateXYZOp(), seg.AddScaleOp()))
        cyl_paths.append(unit_cylinder(stage, f"{path}/Seg_{s:02d}/Cyl", r))
    worst = 0.0
    for t in times:
        pts = polyline(curve, t)
        for s in range(n - 1):
            a, b = pts[s], pts[s + 1]
            d = b - a; L = d.GetLength()
            if L < 1e-6: d, L = Gf.Vec3d(0, 1, 0), 1e-6
            rot = Gf.Rotation(Gf.Vec3d(0, 1, 0), d / L)
            e = euler_xyz(rot)
            tr, ro, sc = ops[s]
            tr.Set(Gf.Vec3d((a + b) * 0.5), t)
            ro.Set(e, t)
            # overlap neighbours by one radius each end so bends read as solid
            sc.Set(Gf.Vec3f(1, L + 2 * r, 1), t)
    # self-check against USD's own op-stack evaluation: the segment's local
    # +Y end points must land on the curve points they were built from
    for t in times[::15]:
        pts = polyline(curve, t)
        for s in range(n - 1):
            seg = UsdGeom.Xformable(stage.GetPrimAtPath(f"{path}/Seg_{s:02d}"))
            m = seg.GetLocalTransformation(t)
            L = (pts[s + 1] - pts[s]).GetLength()
            if L < 1e-5: continue
            h = 0.5 * L / (L + 2 * r)
            got_b = m.Transform(Gf.Vec3d(0, h, 0)); got_a = m.Transform(Gf.Vec3d(0, -h, 0))
            worst = max(worst, (got_b - pts[s + 1]).GetLength(), (got_a - pts[s]).GetLength())
    return cyl_paths, worst

def replace_curves(stage, radius_for):
    """radius_for(prim) -> tube radius in metres. Returns a report list."""
    report = []
    curves = [p for p in stage.Traverse() if p.GetTypeName() == "BasisCurves"]
    seen = set()
    for p in curves:
        c = UsdGeom.BasisCurves(p)
        pa = c.GetPointsAttr()
        times = pa.GetTimeSamples()
        t0 = times[0] if times else Usd.TimeCode.Default()
        xf = UsdGeom.Xformable(p).ComputeLocalToWorldTransform(1)
        pts = pa.Get(t0)
        sig = (p.GetName(), tuple(round(v, 4) for v in xf.Transform(Gf.Vec3d(pts[0]))), len(pts))
        p.SetActive(False)
        if sig in seen:
            report.append(f"{p.GetPath()} duplicate -> dropped"); continue
        seen.add(sig)
        assert not UsdGeom.Xformable(p).GetOrderedXformOps(), "curve has its own xform"
        r = radius_for(p)
        mat = UsdShade.MaterialBindingAPI(p).GetDirectBinding().GetMaterialPath()
        parent = p.GetParent().GetPath()
        if len(times) > 1:
            path = parent.AppendChild(p.GetName() + "_Segments")
            cyls, worst = segment_chain(stage, path, c, r, times)
            geoms = cyls
            report.append(f"{p.GetPath()} animated ({len(times)} samples) -> {len(cyls)} segments r={r} maxDirErr={worst:.2e}")
        else:
            path = parent.AppendChild(p.GetName() + "_Tube")
            geoms = [tube_mesh(stage, path, polyline(c, t0), r).GetPath()]
            report.append(f"{p.GetPath()} static -> tube r={r}")
        if mat:
            material = UsdShade.Material(stage.GetPrimAtPath(mat))
            for g in geoms:
                prim = stage.GetPrimAtPath(g if isinstance(g, Sdf.Path) else g.GetPath())
                UsdShade.MaterialBindingAPI.Apply(prim).Bind(material)
    return report
