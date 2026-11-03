"""Blender (headless): an app model -> a branded GLB for the web guide.

    Blender -b --factory-startup --python web_export.py -- <model.usdc> <out.glb> <yaw>

The model's shared body file must sit beside it. `yaw` is the app's
ModelFraming yaw; the MUSQ wordmark is laid on the platform facing the camera
that yaw implies.
"""
import bpy, sys, math
from mathutils import Vector

args = sys.argv[sys.argv.index('--') + 1:]
src, out, yaw = args[0], args[1], float(args[2])
COPYRIGHT = "(c) 2026 MUSQ. All rights reserved."

bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.wm.usd_import(filepath=src, import_lights=False, import_cameras=False)
sc = bpy.context.scene

# The app's 80 m studio floor plane: replaced by the branded platform.
for o in list(sc.objects):
    if o.type == 'MESH' and any(m and m.name.startswith('DARK_Floor') for m in o.data.materials):
        bpy.data.objects.remove(o, do_unlink=True)

# The sneakers carry ~80k triangles and no shape keys: thin them for the web.
for o in sc.objects:
    if o.type == 'MESH' and 'Shoes' in o.name and not o.data.shape_keys:
        m = o.modifiers.new('web_decimate', 'DECIMATE')
        m.ratio = 0.15
        o.modifiers.move(len(o.modifiers) - 1, 0)
        with bpy.context.temp_override(object=o, active_object=o):
            bpy.ops.object.modifier_apply(modifier='web_decimate')

font = bpy.data.fonts.load('/Applications/Blender.app/Contents/Resources/5.1/datafiles/fonts/Inter.woff2')
EXTRUDE = 0.0015


def text_mesh(body, size, extrude=EXTRUDE):
    """`body` as a mesh in its own object space: left edge at x 0, baseline at y 0."""
    curve = bpy.data.curves.new('MUSQ_text', 'FONT')
    curve.body = body
    curve.font = font
    curve.size = size
    curve.space_character = 1.18
    curve.offset = size * 0.045          # embolden the regular cut
    curve.extrude = extrude
    curve.align_x = 'LEFT'
    curve.align_y = 'BOTTOM_BASELINE'
    ob = bpy.data.objects.new('MUSQ_text', curve)
    sc.collection.objects.link(ob)
    with bpy.context.temp_override(object=ob, active_object=ob, selected_objects=[ob],
                                   selected_editable_objects=[ob]):
        bpy.ops.object.convert(target='MESH')
    mesh = ob.data
    bpy.data.objects.remove(ob, do_unlink=True)
    return mesh


def wordmark_bmesh(size, extrude=EXTRUDE):
    """MUSQ with the logo's long slash through the Q's tail, centred on the origin."""
    import bmesh
    mus_right = max(v.co.x for v in text_mesh('MUS', size, extrude).vertices)
    mesh = text_mesh('MUSQ', size, extrude)
    xs = [v.co.x for v in mesh.vertices]
    cap = max(v.co.y for v in mesh.vertices)
    q0 = min(x for x in xs if x > mus_right + 1e-5)
    q1 = max(xs)
    r = (q1 - q0) / 2
    c = Vector((q0 + r, cap / 2, 0))
    u = Vector((1, -1.15, 0)).normalized()
    n = Vector((-u.y, u.x, 0))
    a, b, t = c + u * (r * 0.30), c + u * (r * 1.50), r * 0.34
    bm = bmesh.new()
    bm.from_mesh(mesh)
    ring = [a + n * t / 2, b + n * t / 2, b - n * t / 2, a - n * t / 2]
    if extrude:
        lo = [bm.verts.new(p + Vector((0, 0, -extrude))) for p in ring]
        hi = [bm.verts.new(p + Vector((0, 0, extrude))) for p in ring]
        bm.faces.new(hi)
        bm.faces.new(list(reversed(lo)))
        for i in range(4):
            j = (i + 1) % 4
            bm.faces.new([lo[i], lo[j], hi[j], hi[i]])
    else:
        bm.faces.new([bm.verts.new(p) for p in ring])
    xs = [v.co.x for v in bm.verts]; ys = [v.co.y for v in bm.verts]
    shift = Vector(((min(xs) + max(xs)) / -2, (min(ys) + max(ys)) / -2, 0))
    for v in bm.verts:
        v.co += shift
    return bm


def print_on_shorts():
    """MUSQ printed into the shorts mesh itself: on the back below the waistband
    and on each outer thigh. The print is skinned with the shorts' own weights,
    coloured through a vertex colour on the shorts' single material, and stapled
    to the shorts' faces, so it is not a separate object, material or island."""
    import bmesh
    from mathutils.bvhtree import BVHTree
    shorts = next((o for o in sc.objects if o.type == 'MESH' and 'Shorts' in o.name), None)
    arm = next((o for o in sc.objects if o.type == 'ARMATURE'), None)
    if not shorts or not arm or len(shorts.data.materials) != 1:
        print("PRINT skipped")
        return
    to_local = shorts.matrix_world.inverted() @ arm.matrix_world
    rot = to_local.to_3x3()

    def bone(name, tail=False):
        b = arm.data.bones[name]
        return to_local @ (b.tail_local if tail else b.head_local)

    up = (rot @ Vector((0, 0, 1))).normalized()
    fwd = bone('foot_L', True) - bone('foot_L')
    fwd = (fwd - up * fwd.dot(up)).normalized()

    bm = bmesh.new()
    bm.from_mesh(shorts.data)
    bm.verts.ensure_lookup_table(); bm.faces.ensure_lookup_table()
    bvh = BVHTree.FromBMesh(bm)
    cloth_faces = list(bm.faces)
    deform = bm.verts.layers.deform.verify()
    col = bm.verts.layers.float_color.new('MUSQ_Col')
    cloth = (0.014, 0.014, 0.014, 1.0)
    ink = (0.62, 0.64, 0.68, 1.0)
    for v in bm.verts:
        v[col] = cloth

    def stamp(aim, inward, size):
        hit, nrm, _, _ = bvh.ray_cast(aim - inward * 0.5, inward)
        if hit is None:
            print("PRINT miss")
            return
        if nrm.dot(inward) > 0:
            nrm = -nrm
        u = (up - nrm * up.dot(nrm)).normalized()
        r = u.cross(nrm)
        flat = wordmark_bmesh(size, extrude=0)
        bmesh.ops.triangulate(flat, faces=flat.faces[:])
        for _ in range(6):            # fine enough to follow the cloth's curve
            long = [e for e in flat.edges if e.calc_length() > 0.004]
            if not long:
                break
            bmesh.ops.subdivide_edges(flat, edges=long, cuts=1)
            bmesh.ops.triangulate(flat, faces=flat.faces[:])
        made = {}
        for fv in flat.verts:
            p = hit + r * fv.co.x + u * fv.co.y
            loc, n2, fi, _ = bvh.find_nearest(p)
            if n2.dot(nrm) < 0:
                n2 = -n2
            v = bm.verts.new(loc + n2 * 0.0016)
            face = cloth_faces[fi]
            weights, total = {}, 0.0
            for sv in face.verts:
                w = 1.0 / max((sv.co - loc).length, 1e-5)
                total += w
                for g, val in sv[deform].items():
                    weights[g] = weights.get(g, 0.0) + val * w
            for g, val in weights.items():
                v[deform][g] = val / total
            v[col] = ink
            made[fv.index] = (v, face)
        for f in flat.faces:
            bm.faces.new([made[fv.index][0] for fv in f.verts])
        # Staples: slivers from a print vertex to an edge of the cloth face under
        # it, hidden between the print and the cloth, joining the two into one piece.
        for i, (v, face) in list(made.items())[::max(1, len(made) // 12)]:
            a, b = face.verts[0], face.verts[1]
            try:
                bm.faces.new([v, a, b])
            except ValueError:
                pass
        flat.free()

    pelvis = bone('pelvis')
    stamp(pelvis + up * 0.015, fwd, 0.040)                    # back, below the waistband
    for side in ('L', 'R'):
        h, t = bone('thigh_' + side), bone('thigh_' + side, True)
        aim = h + (t - h) * 0.30
        lateral = h - pelvis
        lateral = (lateral - up * lateral.dot(up)).normalized()
        stamp(aim, -lateral, 0.032)
    bm.to_mesh(shorts.data)
    bm.free()

    mat = bpy.data.materials.new('MUSQ_Shorts')
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    bsdf = nodes['Principled BSDF']
    bsdf.inputs['Roughness'].default_value = 0.8
    attr = nodes.new('ShaderNodeVertexColor')
    attr.layer_name = 'MUSQ_Col'
    mat.node_tree.links.new(attr.outputs['Color'], bsdf.inputs['Base Color'])
    shorts.data.materials[0] = mat
    print("PRINT done", len(shorts.data.vertices), "verts")


print_on_shorts()

# Footprint over the whole clip, from the evaluated (posed) bounds.
lo, hi = Vector((1e9, 1e9, 1e9)), Vector((-1e9, -1e9, -1e9))
f0, f1 = sc.frame_start, sc.frame_end
for f in sorted({f0, f1, *range(f0, f1 + 1, max(1, (f1 - f0) // 8))}):
    sc.frame_set(f)
    dg = bpy.context.evaluated_depsgraph_get()
    for o in sc.objects:
        if o.type != 'MESH':
            continue
        ev = o.evaluated_get(dg)
        for c in ev.bound_box:
            p = ev.matrix_world @ Vector(c)
            lo = Vector(map(min, lo, p)); hi = Vector(map(max, hi, p))
sc.frame_set(f0)
cx, cy = (lo.x + hi.x) / 2, (lo.y + hi.y) / 2
radius = max(math.hypot(x - cx, y - cy) for x in (lo.x, hi.x) for y in (lo.y, hi.y)) * 0.86 + 0.12
radius = max(radius, 0.85)
top = min(lo.z, 0.0) - 0.004


def material(name, rgb, metallic, roughness):
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    bsdf = m.node_tree.nodes['Principled BSDF']
    bsdf.inputs['Base Color'].default_value = (*rgb, 1)
    bsdf.inputs['Metallic'].default_value = metallic
    bsdf.inputs['Roughness'].default_value = roughness
    return m


plate_mat = material('MUSQ_Platform', (0.018, 0.02, 0.024), 0.0, 0.62)
silver = material('MUSQ_Silver', (0.80, 0.82, 0.86), 1.0, 0.28)

# Platform: a bevelled disc under the lifter and the equipment.
bpy.ops.mesh.primitive_cylinder_add(vertices=128, radius=radius, depth=0.05,
                                    location=(cx, cy, top - 0.025))
plate = bpy.context.active_object
plate.name = 'MUSQ_Platform'
plate.data.materials.append(plate_mat)
bev = plate.modifiers.new('bevel', 'BEVEL'); bev.width = 0.012; bev.segments = 3
with bpy.context.temp_override(object=plate, active_object=plate):
    bpy.ops.object.modifier_apply(modifier='bevel')
bpy.ops.object.shade_smooth_by_angle()

# Silver ring inset on the top face, echoing the ring on the app icon.
bpy.ops.mesh.primitive_torus_add(major_radius=radius - 0.05, minor_radius=0.006,
                                 major_segments=160, minor_segments=8,
                                 location=(cx, cy, top))
ring = bpy.context.active_object
ring.name = 'MUSQ_Ring'
ring.scale.z = 0.35
ring.data.materials.append(silver)

# Wordmark: flat on the platform between the lifter and the default camera,
# reading left to right from there. Camera direction in Blender's Z-up frame
# for the app's yaw: glTF (-sin yaw, 0, cos yaw) -> Blender (-sin yaw, -cos yaw).
d = Vector((-math.sin(yaw), -math.cos(yaw), 0))
right = (-d).cross(Vector((0, 0, 1)))
def wordmark_mesh(size):
    bm = wordmark_bmesh(size)
    mesh = bpy.data.meshes.new('MUSQ_Wordmark')
    bm.to_mesh(mesh)
    bm.free()
    mesh.materials.append(silver)
    return mesh


def place(mesh, name, dist, direction, rgt, scale=1.0):
    ob = bpy.data.objects.new(name, mesh)
    sc.collection.objects.link(ob)
    ob.location = Vector((cx, cy, top + 0.0012)) + direction * dist
    ob.rotation_euler = (0, 0, math.atan2(rgt.y, rgt.x))
    ob.scale = (scale, scale, 1)
    return ob


size = min(max(radius * 0.17, 0.11), 0.26)
mark = wordmark_mesh(size)
place(mark, 'MUSQ_Wordmark', radius - 0.05 - size * 0.95, d, right)
# A smaller one on the far side, reading from behind.
place(mark, 'MUSQ_Wordmark_Back', radius - 0.05 - size * 0.75, -d, -right, 0.7)

sc.frame_set(f0)
bpy.ops.export_scene.gltf(
    filepath=out, export_format='GLB',
    export_animations=True, export_animation_mode='SCENE', export_anim_scene_split_object=False,
    export_apply=False, export_copyright=COPYRIGHT,
    export_lights=False, export_cameras=False)
print("WEB_EXPORT", out, "radius", round(radius, 3), "center", round(cx, 3), round(cy, 3), "top", round(top, 4))
