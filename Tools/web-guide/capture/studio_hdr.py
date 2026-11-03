"""Halves capture/shots/neutral-env.hdr (from env.html) into the app's
GymWorkout/Resources/NeutralStudio.hdr, keeping the light's energy.

    /Applications/Blender.app/Contents/Resources/5.1/python/bin/python3.13 studio_hdr.py
"""
from pathlib import Path
import numpy as np

HERE = Path(__file__).resolve().parent
SRC = HERE / 'shots/neutral-env.hdr'
OUT = HERE.parent.parent.parent / 'GymWorkout/Resources/NeutralStudio.hdr'

raw = SRC.read_bytes()
start = raw.index(b'\n-Y ')
body = raw.index(b'\n', start + 1) + 1
h, w = (int(v) for v in raw[start + 4:body - 1].split(b' +X '))
d = np.frombuffer(raw[body:], dtype=np.uint8).reshape(h, w, 4).astype(np.float64)
e = d[..., 3:4]
rgb = np.where(e > 0, (d[..., :3] + 0.5) * np.power(2.0, e - 128 - 8), 0)
small = rgb.reshape(h // 2, 2, w // 2, 2, 3).mean(axis=(1, 3))
H, W = small.shape[:2]
m = small.max(axis=2, keepdims=True)
ex = np.where(m > 1e-32, np.ceil(np.log2(np.maximum(m, 1e-32)) + 1e-9), -128)
mant = np.where(m > 1e-32, np.floor(small * 256 / np.power(2.0, ex)), 0).clip(0, 255)
rgbe = np.concatenate([mant, np.where(m > 1e-32, ex + 128, 0)], axis=2).astype(np.uint8)
OUT.write_bytes(b'#?RADIANCE\nFORMAT=32-bit_rle_rgbe\n\n-Y %d +X %d\n' % (H, W) + rgbe.tobytes())
print('wrote', OUT, W, H)
