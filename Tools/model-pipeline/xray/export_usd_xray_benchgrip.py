# Xuất USD cho app (MUSQ) từ BẢN SAO file 01B cách nắm thanh bench cơ mờ (bản 4, 25/10/2026) — không sửa file gốc.
#  1. Vật liệu đóng băng: cơ mờ, highlight cố định theo file (chỉ cẳng tay sáng; MH_Fade = 1 cả clip, file cho sáng dần ở
#     khung 146–164), bàn tay mờ, xương màu ngà. Không có shape key cột sống như bản deadlift.
#  2. File thu nhỏ + ẩn bánh tạ phía gần ở khung 246–297 cho camera nhìn bên; app không làm được thế ở mọi góc, nên bỏ các key
#     đó và đổi tên chi tiết phía +X (bên trái người) ngoài tay — cột, J-cup, tay áo, vòng chặn, bánh — tiền tố 'XRSIDE_' để app
#     ẩn khi nhìn từ phía đó. Giữ đoạn khía dưới tay và thân thanh.
# Blender -b bench.blend -P export_usd_xray_benchgrip.py -- out=<raw.usdc> [prep=<blend lưu bản đã chuẩn bị>]
# Sau đó (python của Blender): usd_for_app.py <raw.usdc> <raw_materials.json> <out.usdc> → zsh pad_one.sh <out.usdc> → Resources/Models/Chest/XRayBenchGrip.usdc.
# Nguồn: SSD BLENDER/chest_series 🟢/01B_cach_nam_thanh_bench_co_mo/ (README_VI.md), công cụ dựng ở BLENDER/_cam_thanh_bench_xray_20261024/.
import bpy, sys, json
from mathutils import Vector as V
A = dict(a.split('=', 1) for a in sys.argv[sys.argv.index('--') + 1:] if '=' in a)
OUT = A['out']; sc = bpy.context.scene; OB = bpy.data.objects; r = OB['Anatomy_MasterRig']
LOG = {}
def upd(): bpy.context.view_layer.update()
def fcurves(action):
    return [(cb, fc) for l in action.layers for st in l.strips for cb in st.channelbags for fc in cb.fcurves]
# ------------------------------------------------------------------ 1. trạng thái cố định + đóng băng vật liệu
for cb, fc in fcurves(r.animation_data.action):
    if fc.data_path == '["FF_XRayBones"]' or fc.data_path.startswith('["MH_'): fc.mute = True
r['FF_XRay'] = 1.0; r['FF_XRayBones'] = 2
for k in [k for k in r.keys() if k.startswith('MH_') and isinstance(r[k], int) and not isinstance(r[k], bool)]: r[k] = 0
r['MH_Forearms'] = 2
r['MH_Fade'] = 1.0; r.update_tag()
for m in bpy.data.materials: m.update_tag()
sc.frame_set(2); sc.frame_set(1); dg = bpy.context.evaluated_depsgraph_get(); dg.update()
FULL = {}
def freeze(m, alpha_override=None):
    me = m.evaluated_get(dg); nt = me.node_tree
    bs = next(n for n in nt.nodes if n.type == 'BSDF_PRINCIPLED'); side = nt.nodes.get('Fitness side color')
    if side:
        f = side.inputs[0].default_value; c1 = side.inputs[1].default_value; c2 = side.inputs[2].default_value
        col = [c1[i] + (c2[i] - c1[i]) * f for i in range(3)]; a_ = nt.nodes['MH_Activation'].outputs[0].default_value
        alpha = r['FF_XRayAlpha'] + (r['FF_XRayAlphaHi'] - r['FF_XRayAlpha']) * a_
    else:
        col = list(bs.inputs['Base Color'].default_value)[:3]; alpha = 1.0
    if alpha_override is not None: alpha = alpha_override
    emis = bs.inputs['Emission Strength'].default_value; rough = bs.inputs['Roughness'].default_value
    for h in (m, m.node_tree):
        if h.animation_data: h.animation_data_clear()
    N = m.node_tree.nodes; Lk = m.node_tree.links
    for n in list(N): N.remove(n)
    out = N.new('ShaderNodeOutputMaterial'); p = N.new('ShaderNodeBsdfPrincipled'); Lk.new(p.outputs[0], out.inputs[0])
    p.inputs['Base Color'].default_value = (*col, 1.0); p.inputs['Alpha'].default_value = alpha; p.inputs['Roughness'].default_value = rough
    if emis > 0: p.inputs['Emission Color'].default_value = (*col, 1.0); p.inputs['Emission Strength'].default_value = emis
    m.diffuse_color = (*col, alpha); FULL[m.name] = ([round(c, 5) for c in col], round(alpha, 4))
for m in list(bpy.data.materials):
    if not m.users: continue
    if m.name.startswith('FF_Highlight_') or m.name in ('FF_XRay_Bone_Vai', 'FF_XRay_Bone_Tay', 'DARK_Anatomy_Bone', 'DARK_FacelessHead'):
        freeze(m)
    elif m.name == 'DARK_FleshedHands':
        freeze(m, alpha_override=float(r.get('FF_XRayHandAlpha', 0.12)))
for o in bpy.data.collections['SKELETON'].objects:
    vis = not o.hide_render
    if o.animation_data:
        for d in list(o.animation_data.drivers): o.animation_data.drivers.remove(d)
    o.hide_render = o.hide_viewport = not vis
bpy.data.collections['RIG'].hide_render = False
LOG['bones_shown'] = [o.name for o in bpy.data.collections['SKELETON'].objects if not o.hide_render]
LOG['lit'] = sorted(k for k, v in FULL.items() if k.startswith('FF_Highlight_') and v[1] > r['FF_XRayAlpha'] + 1e-3)
# ------------------------------------------------------------------ 2. bánh tạ phía gần: bỏ key thu nhỏ/ẩn, đánh dấu phía +X
unkeyed = []
for o in OB:
    if not (o.animation_data and o.animation_data.action and o.name.startswith('GYM_Barbell') and o.name != 'GYM_Barbell_ROOT'): continue
    for cb, fc in fcurves(o.animation_data.action):
        if fc.data_path in ('scale', 'hide_render', 'hide_viewport'): cb.fcurves.remove(fc)
    o.scale = (1, 1, 1); o.hide_render = o.hide_viewport = False; o.hide_set(False); unkeyed.append(o.name)
LOG['near_plates_unkeyed'] = unkeyed
sc.frame_set(1); upd(); side = []
for o in list(OB):
    if o.type != 'MESH' or not o.visible_get(): continue
    if not o.name.startswith(('GYM_Barbell', 'GYM_BarbellRack')): continue
    cs = [o.matrix_world @ V(c) for c in o.bound_box]; cx = sum(c.x for c in cs) / 8; w = max(c.x for c in cs) - min(c.x for c in cs)
    if cx > 0.5 and w < 1.0: o.name = 'XRSIDE_' + o.name; side.append(o.name)   # ngoài tay trái (tâm nắm +0.32): giữ đoạn khía (+0.35) và thân thanh
LOG['side_parts'] = side
sc.frame_set(1)
if 'prep' in A:
    bpy.context.preferences.filepaths.save_version = 0; bpy.ops.wm.save_as_mainfile(filepath=A['prep'], compress=True)
bpy.ops.wm.usd_export(filepath=OUT, export_animation=True, selected_objects_only=False)
json.dump({k: {'color': v[0], 'alpha': v[1]} for k, v in FULL.items()}, open(OUT.rsplit('.', 1)[0] + '_materials.json', 'w'), indent=1)
json.dump(LOG, open(OUT.rsplit('.', 1)[0] + '_log.json', 'w'), indent=1, default=str)
print('XRAY_BENCHGRIP', json.dumps(LOG, default=str)[:1500])
print('USD_EXPORTED', OUT)
