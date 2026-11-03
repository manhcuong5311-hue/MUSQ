"""Blender (headless): the MUSQ wordmark as SVG path data and JSON polygons.

    Blender -b --factory-startup --python wordmark.py -- <out.svg> <out.json>

The same text as the 3D models' platform and shorts print (Inter, emboldened,
the logo's long slash through the Q), so the site's logo matches the models.
"""
import bpy, bmesh, sys, json
from mathutils import Vector

out_svg, out_json = sys.argv[sys.argv.index('--') + 1:][:2]
bpy.ops.wm.read_factory_settings(use_empty=True)
font = bpy.data.fonts.load('/Applications/Blender.app/Contents/Resources/5.1/datafiles/fonts/Inter.woff2')
SIZE = 100.0


def text_mesh(body):
    curve = bpy.data.curves.new('t', 'FONT')
    curve.body = body
    curve.font = font
    curve.size = SIZE
    curve.space_character = 1.18
    curve.offset = SIZE * 0.045
    curve.resolution_u = 7
    curve.align_x = 'LEFT'
    curve.align_y = 'BOTTOM_BASELINE'
    ob = bpy.data.objects.new('t', curve)
    bpy.context.scene.collection.objects.link(ob)
    with bpy.context.temp_override(object=ob, active_object=ob, selected_objects=[ob],
                                   selected_editable_objects=[ob]):
        bpy.ops.object.convert(target='MESH')
    return ob.data


mus_right = max(v.co.x for v in text_mesh('MUS').vertices)
mesh = text_mesh('MUSQ')
xs = [v.co.x for v in mesh.vertices]
cap = max(v.co.y for v in mesh.vertices)
q0 = min(x for x in xs if x > mus_right + 1e-5)
q1 = max(xs)
r = (q1 - q0) / 2
c = Vector((q0 + r, cap / 2, 0))
u = Vector((1, -1.15, 0)).normalized()
n = Vector((-u.y, u.x, 0))
a, b, t = c + u * (r * 0.30), c + u * (r * 1.50), r * 0.34
tail = [a - n * t / 2, b - n * t / 2, b + n * t / 2, a + n * t / 2]   # counter-clockwise, like outer contours

bm = bmesh.new()
bm.from_mesh(mesh)
# Boundary edges in the direction their face walks them: outer contours come
# out counter-clockwise and the Q's counter clockwise-reversed, so a nonzero
# fill keeps the counter open and unions the slash with the Q's ring.
nxt = {}
for f in bm.faces:
    for loop in f.loops:
        if len(loop.edge.link_faces) == 1:
            nxt[loop.vert.index] = loop.link_loop_next.vert.index
co = {v.index: (v.co.x, v.co.y) for v in bm.verts}
loops, seen = [], set()
for start in nxt:
    if start in seen:
        continue
    ring, v = [], start
    while v not in seen:
        seen.add(v)
        ring.append(co[v])
        v = nxt[v]
    loops.append(ring)
loops.append([(p.x, p.y) for p in tail])

allx = [p[0] for l in loops for p in l]; ally = [p[1] for l in loops for p in l]
x0, x1, y0, y1 = min(allx), max(allx), min(ally), max(ally)
W, H = x1 - x0, y1 - y0
flip = [[(round(x - x0, 1), round(y1 - y, 1)) for x, y in l] for l in loops]
d = ' '.join('M' + ' L'.join(f'{x} {y}' for x, y in l) + 'Z' for l in flip)
open(out_svg, 'w').write(
    f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W:.2f} {H:.2f}" role="img" aria-label="MUSQ">'
    f'<path fill="currentColor" fill-rule="nonzero" d="{d}"/></svg>\n')
json.dump({'width': W, 'height': H, 'loops': flip}, open(out_json, 'w'))
print('WORDMARK', round(W, 1), round(H, 1), len(loops), 'loops')
