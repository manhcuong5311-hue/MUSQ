# The female garments' full modifier stack, evaluated once at the rig's rest
# pose (2026-10-12). RealityKit plays only linear skinning and ignores
# time-sampled points, so bake_clothes.py's per-frame garments froze at frame 1;
# instead the skinned garments keep their weights and get these rest-pose
# points (shrinkwrap, hug and keep-out nodes applied) via merge_clothes.py.
#   blender -b <file.blend> --python bake_rest.py -- <out.npz>
import bpy, sys, numpy as np
out = sys.argv[sys.argv.index("--") + 1]
res = {}
for o in [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(("MUSQ_SportsBra", "MUSQ_Shorts"))]:
    arm = o.find_armature()
    if arm: arm.data.pose_position = 'REST'
    for m in o.modifiers:
        if m.type == 'SUBSURF': m.show_render = m.show_viewport = False
    dg = bpy.context.evaluated_depsgraph_get(); e = o.evaluated_get(dg); me = e.to_mesh()
    co = np.empty(len(me.vertices) * 3, np.float32); me.vertices.foreach_get("co", co)
    res[o.name.split(".")[0]] = co.reshape(-1, 3); e.to_mesh_clear()
np.savez(out, **res); print("REST", out, {k: len(v) for k, v in res.items()})
