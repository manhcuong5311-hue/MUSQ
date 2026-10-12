# Female clothing bake (2026-10-12). The bra and shorts follow the rig through
# post-armature modifiers (shrinkwrap, geometry nodes, smoothing) that a
# skinned USD export drops, so RealityKit drew them bunched and sticking out.
# Run inside Blender on the approved .blend: exports the two garments as plain
# meshes (subdivision off) with their evaluated points sampled every 2nd frame
# plus the last, so they play exactly as in Blender.
#   Blender -b <file.blend> --python bake_clothes.py -- <out.usdc>
import bpy, sys, numpy as np
from pxr import Usd, UsdGeom, Vt
out = sys.argv[sys.argv.index("--") + 1]
objs = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(("MUSQ_SportsBra", "MUSQ_Shorts"))]
for o in objs:
    for m in o.modifiers:
        if m.type == 'SUBSURF': m.show_render = m.show_viewport = False
for o in bpy.context.view_layer.objects: o.select_set(False)
for o in objs: o.select_set(True)
bpy.context.view_layer.objects.active = objs[0]
bpy.ops.wm.usd_export(filepath=out, export_animation=False, selected_objects_only=True, export_armatures=False,
                      export_shapekeys=False, evaluation_mode='RENDER', export_materials=True)
st = Usd.Stage.Open(out)
meshes = {}
for p in st.Traverse():
    if p.IsA(UsdGeom.Mesh):
        for o in objs:
            if p.GetPath().pathString.split("/")[-2] == o.name.replace(".", "_"): meshes[o.name] = UsdGeom.Mesh(p)
for m in meshes.values():
    for q in (m.GetPrim(), m.GetPrim().GetParent()): UsdGeom.Xformable(q).ClearXformOpOrder()
    if m.GetPrim().HasAttribute("normals"): m.GetPrim().RemoveProperty("normals")
sc = bpy.context.scene
frames = list(range(sc.frame_start, sc.frame_end + 1, 2))
if frames[-1] != sc.frame_end: frames.append(sc.frame_end)
for f in frames:
    sc.frame_set(f); dg = bpy.context.evaluated_depsgraph_get()
    for name, m in meshes.items():
        o = bpy.data.objects[name].evaluated_get(dg); me = o.to_mesh()
        co = np.empty(len(me.vertices) * 3, np.float32); me.vertices.foreach_get("co", co)
        # into the rig's space: the baked garment sits under the rig with no transform of its own
        src = bpy.data.objects[name]; arm = src.find_armature() or src.parent
        mw = np.array((arm.matrix_world.inverted() if arm else np.eye(4)) @ o.matrix_world, np.float32)
        co = co.reshape(-1, 3) @ mw[:3, :3].T + mw[:3, 3]
        m.GetPointsAttr().Set(Vt.Vec3fArray.FromNumpy(np.ascontiguousarray(co, np.float32)), f)
        o.to_mesh_clear()
st.SetStartTimeCode(sc.frame_start); st.SetEndTimeCode(sc.frame_end)
st.Flatten().Export(out)
print("BAKED", out, {n: len(frames) for n in meshes})
