# Xuất USD cho app (MUSQ) từ BẢN SAO file deadlift cơ mờ (21/10/2026), dựng trên 316B — không sửa file đã đăng.
#  1. Cột sống: shape key 'FF_CotSongThang' (1 lúc đứng → 0 khi lưng cong, khung 16–36 → 1 khi gồng core, 112–132) → 24 xương đốt
#     sống 'XRV_*' có key theo đúng giá trị shape key từng khung (app không chạy shape key). Cách dựng xương như export_usd_xray_backbar.py.
#  2. Vật liệu đóng băng: cơ mờ, highlight cố định (xô, cẳng tay, bụng, dựng sống sáng; lưng giữa, tròn lớn, chéo bụng, mông, đùi sau mờ),
#     bàn tay mờ, xương màu ngà.
#  3. Không có rack (đã ẩn trong file); chi tiết thanh + bánh tạ phía +X (bên trái người) đổi tên tiền tố 'XRSIDE_' để app ẩn ở góc ngang.
# Blender -b dl.blend -P export_usd_xray_deadlift.py -- out=<raw.usdc> [prep=<blend lưu bản đã chuẩn bị>]
# Sau đó (python của Blender): usd_for_app.py <raw.usdc> <raw_materials.json> <out.usdc> → zsh pad_one.sh <out.usdc> → Resources/Models/Back/XRayDeadliftSetup.usdc.
# Nguồn: SSD BLENDER/300-400 🔴/quads_series🟢/DL_nam_thanh_deadlift_co_mo/ (README_VI.md), công cụ dựng ở BLENDER/_deadlift_xray_20261021/.
import bpy, sys, json, math
import numpy as np
from mathutils import Vector as V, Matrix, Quaternion
A = dict(a.split('=', 1) for a in sys.argv[sys.argv.index('--') + 1:] if '=' in a)
OUT = A['out']; sc = bpy.context.scene; OB = bpy.data.objects; r = OB['Anatomy_MasterRig']; RW = r.matrix_world
SEG = {'LumbarSpine': 'spine', 'ThoracicSpine': 'chest', 'CervicalSpine': 'neck'}
SK = 'FF_CotSongThang'; FCHK, FMID = 150, (26, 122)
# giá trị shape key từng khung, đọc thẳng từ action của shape key (giống nhau trên 4 lưới cột sống + sườn)
_ska = OB['LumbarSpine'].data.shape_keys.animation_data.action
_fc = next(fc for l in _ska.layers for st in l.strips for cb in st.channelbags for fc in cb.fcurves if SK in fc.data_path)
SKV = {f: max(0.0, min(1.0, _fc.evaluate(f))) for f in range(sc.frame_start, sc.frame_end + 1)}
LOG = {}
def upd(): bpy.context.view_layer.update()
def comps(me):
    E = np.empty(len(me.edges) * 2, dtype=np.int64); me.edges.foreach_get('vertices', E); E = E.reshape(-1, 2)
    par = np.arange(len(me.vertices))
    def find(a):
        while par[a] != a: par[a] = par[par[a]]; a = par[a]
        return a
    for a, b in E:
        ra, rb = find(a), find(b)
        if ra != rb: par[ra] = rb
    return np.array([find(i) for i in range(len(me.vertices))])
def kb_co(kb):
    X = np.empty(len(kb.data) * 3); kb.data.foreach_get('co', X); return X.reshape(-1, 3)
def kabsch(P, Q):
    cp, cq = P.mean(0), Q.mean(0); H = (P - cp).T @ (Q - cq); U, S, Vt = np.linalg.svd(H); d = np.sign(np.linalg.det(Vt.T @ U.T))
    Rm = Vt.T @ np.diag([1, 1, d]) @ U.T; M = np.eye(4); M[:3, :3] = Rm; M[:3, 3] = cq - Rm @ cp; return M
def eval_world(o):
    dg = bpy.context.evaluated_depsgraph_get(); ev = o.evaluated_get(dg); me = ev.to_mesh()
    X = np.empty(len(me.vertices) * 3); me.vertices.foreach_get('co', X); ev.to_mesh_clear(); M = np.array(o.matrix_world); return X.reshape(-1, 3) @ M[:3, :3].T + M[:3, 3]
# ------------------------------------------------------------------ 1. shape key → xương đốt sống
sc.frame_set(FCHK); upd()
REF = {n: eval_world(OB[n]) for n in list(SEG) + ['RibCage']}          # hình chuẩn (shape key = 1) để so sau khi đổi
REFMID = {}
for f in FMID:
    sc.frame_set(f); upd(); REFMID[f] = {n: eval_world(OB[n]) for n in list(SEG) + ['RibCage']}
VERT = []                                       # (tên xương, đoạn, mesh, chỉ số đỉnh, G_obj 4x4, tâm nghỉ obj)
for n, seg in SEG.items():
    o = OB[n]; me = o.data; kbs = me.shape_keys.key_blocks; B = kb_co(kbs['Basis']); K = kb_co(kbs[SK]); lab = comps(me)
    order = sorted(np.unique(lab), key=lambda c: B[lab == c][:, 2].mean())
    for i, c in enumerate(order):
        idx = np.where(lab == c)[0]; G = kabsch(B[idx], K[idx])
        res = np.abs((B[idx] @ G[:3, :3].T + G[:3, 3]) - K[idx]).max()
        VERT.append(dict(name='XRV_%s_%02d' % (seg, i + 1), seg=seg, obj=n, idx=idx, G=G, c=B[idx].mean(0), fit=float(res)))
LOG['kabsch_fit_mm_max'] = round(max(v['fit'] for v in VERT) * 1000, 4)
# xương sườn: đỉnh có dời → trọng số w theo đốt ngực gần nhất (đúng độ dời của shape key)
rc = OB['RibCage']; RB = kb_co(rc.data.shape_keys.key_blocks['Basis']); RK = kb_co(rc.data.shape_keys.key_blocks[SK]); disp = RK - RB
TV = [v for v in VERT if v['seg'] == 'chest']; TC = np.array([v['c'] for v in TV]); labr = comps(rc.data)
RIBW = []                                       # (chỉ số đỉnh, xương, w)
for c in np.unique(labr):
    idx = np.where(labr == c)[0]
    if np.abs(disp[idx]).max() < 1e-7: continue
    P = RB[idx]; dist = np.linalg.norm(P[:, None, :] - TC[None, :, :], axis=2); j = np.unravel_index(dist.argmin(), dist.shape)[1]
    v = TV[j]; G = v['G']; full = (P @ G[:3, :3].T + G[:3, 3]) - P; den = (full * full).sum(1)
    w = np.where(den > 1e-12, (disp[idx] * full).sum(1) / np.maximum(den, 1e-12), 0.0); w = np.clip(w, 0, 1)
    RIBW.append((idx, v['name'], w))
# tạo xương (edit mode)
Mo = {n: OB[n].matrix_world for n in list(SEG) + ['RibCage']}
for o in bpy.context.view_layer.objects: o.select_set(False)
bpy.context.view_layer.objects.active = r; r.select_set(True); bpy.ops.object.mode_set(mode='EDIT')
eb = r.data.edit_bones; RWi = RW.inverted()
for v in VERT:
    if v['name'] in eb: eb.remove(eb[v['name']])
    sb = eb[v['seg']]; b = eb.new(v['name'])
    ca = RWi @ (Mo[v['obj']] @ V(tuple(v['c'])))
    y = (sb.tail - sb.head).normalized(); b.head = ca; b.tail = ca + y * 0.03; b.align_roll(sb.z_axis); b.parent = sb; b.use_connect = False; b.use_deform = True
bpy.ops.object.mode_set(mode='OBJECT')
# trọng số
for v in VERT:
    o = OB[v['obj']]; vg = o.vertex_groups.get(v['name']) or o.vertex_groups.new(name=v['name'])
    vg.add(v['idx'].tolist(), 1.0, 'REPLACE'); o.vertex_groups[v['seg']].remove(v['idx'].tolist())
vch = rc.vertex_groups['chest']
for idx, bn, w in RIBW:
    vg = rc.vertex_groups.get(bn) or rc.vertex_groups.new(name=bn)
    for i, wi in zip(idx.tolist(), w.tolist()):
        if wi <= 1e-4: continue
        vg.add([i], float(wi), 'REPLACE'); vch.add([i], float(1 - wi), 'REPLACE')
# bỏ shape key
for n in list(SEG) + ['RibCage']:
    o = OB[n]
    if o.data.shape_keys:
        if o.data.shape_keys.animation_data: o.data.shape_keys.animation_data_clear()
        o.shape_key_clear()
# key xương: L_b = Rb⁻¹ · G_arm · Rb, G_arm = (RW⁻¹·Mo) · G_obj · (RW⁻¹·Mo)⁻¹ ; mỗi khung k = giá trị shape key (chỉ key khung đầu, cuối
# và các khung shape key đang đổi, nội suy tuyến tính giữa chúng)
PB = r.pose.bones
F0, F1 = sc.frame_start, sc.frame_end
KF = [f for f in range(F0, F1 + 1) if f in (F0, F1) or SKV[f] != SKV.get(f - 1) or SKV[f] != SKV.get(f + 1)]
LOG['spine_key_frames'] = len(KF)
for v in VERT:
    pb = PB[v['name']]; pb.rotation_mode = 'QUATERNION'
    C = RWi @ Mo[v['obj']]; Garm = C @ Matrix(v['G'].tolist()) @ C.inverted(); Rb = r.data.bones[v['name']].matrix_local
    L = Rb.inverted() @ Garm @ Rb; loc, rot, scl = L.decompose()
    for f in KF:
        k = SKV[f]; pb.location = loc * k; pb.rotation_quaternion = Quaternion().slerp(rot, k)
        pb.keyframe_insert('location', frame=f); pb.keyframe_insert('rotation_quaternion', frame=f)
upd()
for f, ref in ((FCHK, REF),) + tuple((f, REFMID[f]) for f in FMID):
    sc.frame_set(f); upd()
    LOG['bones_vs_shapekey_mm_f%d' % f] = {n: round(float(np.linalg.norm(eval_world(OB[n]) - ref[n], axis=1).max()) * 1000, 2) for n in ref}
LOG['vertebra_bones'] = len(VERT); LOG['rib_pieces'] = len(RIBW)
# ------------------------------------------------------------------ 2. trạng thái cố định + đóng băng vật liệu
act = r.animation_data.action
for fc in [fc for l in act.layers for st in l.strips for cb in st.channelbags for fc in cb.fcurves]:
    if fc.data_path == '["FF_XRayBones"]' or fc.data_path.startswith('["MH_'): fc.mute = True
r['FF_XRay'] = 1.0; r['FF_XRayBones'] = 2
for k in [k for k in r.keys() if k.startswith('MH_') and isinstance(r[k], int) and not isinstance(r[k], bool)]: r[k] = 0
for k, v in (('MH_Lats', 2), ('MH_Forearms', 2), ('MH_Abs', 2), ('MH_LowerBack', 2), ('MH_UpperBack', 1), ('MH_TeresMajor', 1),
             ('MH_Obliques', 1), ('MH_Glutes', 1), ('MH_Hamstrings', 1), ('MH_UpperTrap', 0)):
    if k in r: r[k] = v
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
# ------------------------------------------------------------------ 3. đánh dấu phía gần (+X); rack đã ẩn trong file, giữ bước dọn của 316B cho chắc
hid = 0; side = []
for o in list(bpy.data.collections['GYM2_Rack'].all_objects):
    if o.type == 'FONT' or '_Hole_' in o.name or 'HeightMark' in o.name or 'Logo' in o.name:
        o.hide_set(True); o.hide_viewport = True; o.hide_render = True; hid += 1
upd()
for o in list(OB):
    if o.type != 'MESH' or not o.visible_get(): continue
    if not o.name.startswith(('GYM2_Rack', 'HG_Barbell', 'GYM_Barbell')): continue
    cs = [o.matrix_world @ V(c) for c in o.bound_box]; cx = sum(c.x for c in cs) / 8; w = max(c.x for c in cs) - min(c.x for c in cs)
    if cx > 0.55 and w < 1.0: o.name = 'XRSIDE_' + o.name; side.append(o.name)   # ngoài tay (tâm nắm ±0.42): cột, J-cup, tay áo, bánh — giữ đoạn khía dưới tay
LOG['rack_hidden'] = hid; LOG['side_parts'] = side
sc.frame_set(1)
if 'prep' in A:
    bpy.context.preferences.filepaths.save_version = 0; bpy.ops.wm.save_as_mainfile(filepath=A['prep'], compress=True)
bpy.ops.wm.usd_export(filepath=OUT, export_animation=True, selected_objects_only=False)
json.dump({k: {'color': v[0], 'alpha': v[1]} for k, v in FULL.items()}, open(OUT.rsplit('.', 1)[0] + '_materials.json', 'w'), indent=1)
json.dump(LOG, open(OUT.rsplit('.', 1)[0] + '_log.json', 'w'), indent=1, default=str)
print('XRAY_DEADLIFT', json.dumps(LOG, default=str)[:1500])
print('USD_EXPORTED', OUT)
