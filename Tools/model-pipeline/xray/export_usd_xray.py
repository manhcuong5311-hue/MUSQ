# Xuất USD cho app (MUSQ) từ BẢN SAO file demo: "đóng băng" vật liệu (alpha hằng số, màu highlight cố định), hiện xương, bỏ driver.
# Không lưu .blend. Chạy: Blender -b Male_CoMo_XuongBaVai_BenchSetup_20261017.blend --python tools/export_usd_xray.py -- <out.usdc>
import bpy, sys
OUT = sys.argv[sys.argv.index('--') + 1]
sc = bpy.data.scenes['Scene']; r = bpy.data.objects['Anatomy_MasterRig']
# 1. trạng thái cố định: cơ mờ, xương mức 2 (bả vai, đòn, cánh tay, lồng ngực, ức, cột sống), nhấn thang giữa/dưới + trám
a = r.animation_data.action
fcs = [fc for l in a.layers for st in l.strips for cb in st.channelbags for fc in cb.fcurves]
for fc in list(fcs):
    if fc.data_path == '["FF_XRayBones"]' or fc.data_path.startswith('["MH_'):
        fc.mute = True
r['FF_XRay'] = 1.0; r['FF_XRayBones'] = 2
for k in [k for k in r.keys() if k.startswith('MH_') and isinstance(r[k], int) and not isinstance(r[k], bool)]: r[k] = 0
r['MH_UpperBack'] = 2; r['MH_UpperTrap'] = 0; r['MH_Fade'] = 1.0
r.update_tag()
for m in bpy.data.materials: m.update_tag()
sc.frame_set(2); sc.frame_set(1); dg = bpy.context.evaluated_depsgraph_get(); dg.update()
# 2. đóng băng vật liệu theo giá trị đang tính → Principled hằng số
def freeze(m):
    me = m.evaluated_get(dg); nt = me.node_tree
    bs = next(n for n in nt.nodes if n.type == 'BSDF_PRINCIPLED')
    side = nt.nodes.get('Fitness side color')
    if side:
        f = side.inputs[0].default_value; c1 = side.inputs[1].default_value; c2 = side.inputs[2].default_value
        col = [c1[i] + (c2[i] - c1[i]) * f for i in range(3)]
        act = nt.nodes['MH_Activation'].outputs[0].default_value
        alpha = r['FF_XRayAlpha'] + (r['FF_XRayAlphaHi'] - r['FF_XRayAlpha']) * act
        emis = bs.inputs['Emission Strength'].default_value
    else:
        col = list(bs.inputs['Base Color'].default_value)[:3]; alpha = 1.0; emis = bs.inputs['Emission Strength'].default_value
    rough = bs.inputs['Roughness'].default_value
    for h in (m, m.node_tree):
        if h.animation_data: h.animation_data_clear()
    N = m.node_tree.nodes; L = m.node_tree.links
    for n in list(N): N.remove(n)
    out = N.new('ShaderNodeOutputMaterial'); p = N.new('ShaderNodeBsdfPrincipled'); L.new(p.outputs[0], out.inputs[0])
    p.inputs['Base Color'].default_value = (*col, 1.0); p.inputs['Alpha'].default_value = alpha; p.inputs['Roughness'].default_value = rough
    if emis > 0: p.inputs['Emission Color'].default_value = (*col, 1.0); p.inputs['Emission Strength'].default_value = emis
    m.diffuse_color = (*col, alpha)
    FULL[m.name] = ([round(c, 5) for c in col], round(alpha, 4))
    return (round(col[0], 3), round(alpha, 2))
log = {}; FULL = {}
for m in list(bpy.data.materials):
    if m.name.startswith('FF_Highlight_') or m.name in ('FF_XRay_Bone_Vai', 'DARK_Anatomy_Bone', 'DARK_FacelessHead', 'DARK_FleshedHands'):
        if m.users: log[m.name] = freeze(m)
# 3. bỏ driver ẩn/hiện xương: giữ đúng trạng thái hiện tại
for o in bpy.data.collections['SKELETON'].objects:
    vis = not o.hide_render
    if o.animation_data: o.animation_data.drivers.clear() if False else [o.animation_data.drivers.remove(d) for d in list(o.animation_data.drivers)]
    o.hide_render = o.hide_viewport = not vis
bpy.data.collections['RIG'].hide_render = False
print('FROZEN', {k: v for k, v in list(log.items())[:8]}, 'bones', [o.name for o in bpy.data.collections['SKELETON'].objects if not o.hide_render])
sc.frame_set(1)
bpy.ops.wm.usd_export(filepath=OUT, export_animation=True, selected_objects_only=False)
import json
json.dump({k: {'color': v[0], 'alpha': v[1]} for k, v in FULL.items()}, open(OUT.rsplit('.', 1)[0] + '_materials.json', 'w'), indent=1)
print('USD_EXPORTED', OUT)
