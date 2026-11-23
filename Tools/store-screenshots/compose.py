#!/usr/bin/env python3
"""App Store mockups in the style of the 1.0-1.3 set (measured from
/Volumes/HIKSEMI/Mockup Iphone ipad): an off-white ground, a heavy headline
in black with the accent words in orange (253,71,2), a dark grey subtitle,
and the screen in a black titanium-rimmed device that glows orange at its
sides.

  compose.py SPEC.json OUTDIR

SPEC: [{"shot": "raw/x.png", "device": "iphone" | "ipad",
        "line1": "See Every", "line2": "Angle",     # iPad: one line, line2 in orange
        "sub": ["Rotate 360°.", "Understand every move."],
        "out": "01-today"}]
"""
import json, os, sys
from PIL import Image, ImageDraw, ImageFilter, ImageFont

BLACK_FONT = '/Library/Fonts/SF-Pro-Display-Heavy.otf'
SUB_FONT = '/Library/Fonts/SF-Pro-Display-Medium.otf'
INK = (0, 0, 0)
ORANGE = (253, 71, 2)
SUB = (52, 52, 55)
GROUND = (253, 252, 250)

# Metrics measured on the old 1290x2796 iPhone and 2732x2048 iPad mockups.
LAYOUT = {
    'iphone': dict(W=1290, H=2796, head=156, track=-0.021, cap_top=146, pitch=149,
                   sub=62, sub_gap=46, sub_pitch=69, max_text=1150,
                   dev_top=654, dev_w=1034, bezel=46, bottom_margin=40),
    'ipad': dict(W=2732, H=2048, head=186, track=-0.02, cap_top=111, pitch=0,
                 sub=84, sub_gap=40, sub_pitch=92, max_text=2500,
                 dev_top=430, dev_w=None, bezel=40, bottom_margin=56),
    # Portrait iPad 13" (2064x2752), laid out like the iPhone set (2026-11-23).
    'ipadp': dict(W=2064, H=2752, head=220, track=-0.021, cap_top=150, pitch=211,
                  sub=88, sub_gap=60, sub_pitch=100, max_text=1860,
                  dev_top=640, dev_w=None, bezel=40, bottom_margin=64, dev_gap=70),
}


def tracked_width(text, font, track):
    return font.getlength(text) + track * font.size * max(0, len(text) - 1)


def draw_tracked(d, x, y, text, font, fill, track):
    """Draws `text` with letter spacing `track` (em), keeping kerning."""
    for i, ch in enumerate(text):
        cx = x + font.getlength(text[:i]) + track * font.size * i
        d.text((cx, y), ch, font=font, fill=fill)


def fit(texts, path, size, track, max_w):
    """The largest size up to `size` at which every text fits `max_w`."""
    while size > 40:
        f = ImageFont.truetype(path, size)
        if all(tracked_width(t, f, track) <= max_w for t in texts):
            return f
        size -= 2
    return ImageFont.truetype(path, size)


def rounded(size, radius, fill=255):
    m = Image.new('L', size, 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius=radius, fill=fill)
    return m


def device(shot, kind, screen_w):
    """The screenshot in the device: returns (RGBA image, its silhouette)."""
    shot = shot.convert('RGB')
    screen_h = round(shot.height * screen_w / shot.width)
    shot = shot.resize((screen_w, screen_h), Image.LANCZOS)
    L = LAYOUT[kind]
    b = L['bezel'] if kind == 'iphone' else round(L['bezel'] * screen_w / 2000)
    band = round(b * 0.40)          # titanium band
    dark = round(b * 0.13)          # dark line inside the band
    W, H = screen_w + 2 * b, screen_h + 2 * b
    pad = 14                        # room for the side buttons
    img = Image.new('RGBA', (W + 2 * pad, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    r_screen = round(screen_w * {'iphone': 0.137, 'ipad': 0.026}.get(kind, 0.022))
    r_out = r_screen + b
    if kind == 'iphone':
        # side buttons: action + volume on the left, power on the right
        def button(x0, y0, y1):
            d.rounded_rectangle([x0, y0, x0 + 22, y1], radius=6, fill=(38, 38, 40, 255))
            d.rounded_rectangle([x0 + 2, y0 + 3, x0 + 20, y1 - 3], radius=5, fill=(118, 116, 112, 255))
        for f0, f1 in ((0.170, 0.205), (0.245, 0.315), (0.335, 0.405)):
            button(pad - 10, round(H * f0), round(H * f1))
        button(pad + W - 12, round(H * 0.270), round(H * 0.385))
    else:
        # top buttons of an iPad Pro in landscape: volume at the top left
        def topbutton(x0, x1):
            d.rounded_rectangle([x0, -4, x1, 12], radius=5, fill=(38, 38, 40, 255))
            d.rounded_rectangle([x0 + 3, -2, x1 - 3, 9], radius=4, fill=(118, 116, 112, 255))
    ox = pad
    # outer dark line, a light edge, the graphite titanium band, an inner
    # light line, a dark line, then the black bezel
    def rr(inset, fill):
        d.rounded_rectangle([ox + inset, inset, ox + W - 1 - inset, H - 1 - inset],
                            radius=max(4, r_out - inset), fill=fill)
    rr(0, (10, 10, 10, 255))
    rr(2, (150, 148, 143, 255))
    rr(4, (92, 90, 87, 255))
    rr(4 + band - 4, (128, 126, 122, 255))
    rr(4 + band - 1, (46, 45, 44, 255))
    rr(4 + band + dark, (4, 4, 5, 255))
    img.paste(shot, (ox + b, b), rounded((screen_w, screen_h), r_screen))
    if kind == 'iphone':
        # the Dynamic Island (126x37 pt at 11 pt on a 402 pt screen)
        iw, ih = round(screen_w * 0.313), round(screen_w * 0.092)
        ix, iy = ox + b + (screen_w - iw) // 2, b + round(screen_w * 0.027)
        d.rounded_rectangle([ix, iy, ix + iw, iy + ih], radius=ih // 2, fill=(0, 0, 0, 255))
    elif kind == 'ipad':
        # the front camera in the middle of the long top bezel
        cx, cy, cr = ox + W // 2, b // 2 + 1, max(5, b // 6)
        d.ellipse([cx - cr, cy - cr, cx + cr, cy + cr], fill=(28, 30, 36, 255))
    return img


def glow(canvas_size, silhouette, pos):
    """Orange light beside the device, strongest along its middle and
    fading toward its top and bottom, like the old set."""
    W, H = canvas_size
    layer = Image.new('L', (W, H), 0)
    sil = silhouette.split()[-1].point(lambda a: 255 if a > 8 else 0)
    layer.paste(sil, pos, sil)
    soft = layer.filter(ImageFilter.GaussianBlur(85))
    # a vertical profile over the device: 0.35 at its top, 1 from 25% to 70%, 0.5 at its bottom
    top, h = pos[1], silhouette.height
    prof = Image.new('L', (1, H), 0)
    for y in range(H):
        t = (y - top) / h
        if t < 0: v = max(0.0, 0.35 + t * 2.5)
        elif t < 0.25: v = 0.35 + 0.65 * t / 0.25
        elif t < 0.70: v = 1.0
        elif t <= 1.0: v = 1.0 - 0.5 * (t - 0.70) / 0.30
        else: v = max(0.0, 0.5 - (t - 1.0) * 4)
        prof.putpixel((0, y), int(255 * v))
    prof = prof.resize((W, H))
    from PIL import ImageChops
    soft = ImageChops.multiply(soft, prof)
    color = Image.new('RGBA', (W, H), (255, 128, 44, 255))
    color.putalpha(soft.point(lambda a: int(min(255, a * 1.2) * 0.58)))
    return color


def compose(item, base):
    kind = item['device']
    L = LAYOUT[kind]
    W, H = L['W'], L['H']
    canvas = Image.new('RGBA', (W, H), GROUND + (255,))
    d = ImageDraw.Draw(canvas)
    track = L['track']
    # headline
    if item.get('upper'):
        item = dict(item, line1=item['line1'].upper(), line2=item['line2'].upper())
        track = item.get('track', -0.03)
    head_font = BLACK_FONT if not item.get('upper') else '/Library/Fonts/SF-Pro-Display-Black.otf'
    if kind in ('iphone', 'ipadp'):
        lines = [(item['line1'], INK), (item['line2'], ORANGE)]
        f = fit([t for t, _ in lines], head_font, L['head'], track, L['max_text'])
        cap = f.getbbox('H')[1]                     # top of the caps below the draw origin
        y = L['cap_top'] - cap
        pitch = round(L['pitch'] * f.size / L['head'])
        if item.get('upper'):   # room for Vietnamese marks above and below the capitals
            pitch = round(f.size * 1.16)
        for text, color in lines:
            w = tracked_width(text, f, track)
            draw_tracked(d, (W - w) / 2, y, text, f, color, track)
            y += pitch
        base_y = L['cap_top'] + pitch + round(f.size * 0.73)   # under line 2
    else:
        a, b = item['line1'], item['line2']
        full = a + ' ' + b
        f = fit([full], head_font, L['head'], track, L['max_text'])
        cap = f.getbbox('H')[1]
        y = L['cap_top'] - cap
        wa = tracked_width(a + ' ', f, track)
        w = tracked_width(full, f, track)
        x = (W - w) / 2
        draw_tracked(d, x, y, a + ' ', f, INK, track)
        draw_tracked(d, x + wa + track * f.size, y, b, f, ORANGE, track)
        base_y = L['cap_top'] + round(f.size * 0.73)
    # subtitle: the given lines, each centred
    subs = item['sub'] if isinstance(item['sub'], list) else [item['sub']]
    fs = fit(subs, SUB_FONT, L['sub'], -0.005, L['max_text'])
    sy = base_y + L['sub_gap']
    for line in subs:
        w = tracked_width(line, fs, -0.005)
        draw_tracked(d, (W - w) / 2, sy - fs.getbbox('H')[1], line, fs, SUB, -0.005)
        sy += L['sub_pitch']
    # device, below the subtitle when the layout asks for a gap
    top = L['dev_top']
    if 'dev_gap' in L:
        top = max(top, int(sy - L['sub_pitch'] + L['sub'] * 1.1 + L['dev_gap']))
    shot = Image.open(os.path.join(base, item['shot'])).convert('RGB')
    # status bar clean-up: boxes painted with the colour just right of them
    for box in item.get('erase', []):
        x0, y0, x1, y1 = box
        color = shot.getpixel((min(shot.width - 1, x1 + 12), (y0 + y1) // 2))
        ImageDraw.Draw(shot).rectangle(box, fill=color)
    avail_h = H - top - L['bottom_margin']
    if kind == 'iphone':
        screen_w = L['dev_w'] - 2 * L['bezel']
        if round(shot.height * screen_w / shot.width) + 2 * L['bezel'] > avail_h:
            screen_w = int((avail_h - 2 * L['bezel']) * shot.width / shot.height)
    else:
        bz = L['bezel']
        screen_h = avail_h - 2 * bz
        screen_w = int(screen_h * shot.width / shot.height)
        screen_w = min(screen_w, W - 2 * (200 if kind == 'ipadp' else 260))
    dev = device(shot, kind, screen_w)
    pos = ((W - dev.width) // 2, top)
    canvas = Image.alpha_composite(canvas, glow((W, H), dev, pos))
    canvas.alpha_composite(dev, pos)
    return canvas.convert('RGB')


def main():
    spec, out = sys.argv[1], sys.argv[2]
    base = os.path.dirname(os.path.abspath(spec))
    os.makedirs(out, exist_ok=True)
    only = sys.argv[3:]  # optional: names to render
    for item in json.load(open(spec, encoding='utf-8')):
        if only and item['out'] not in only:
            continue
        img = compose(item, base)
        path = os.path.join(out, item['out'] + '.png')
        img.save(path, optimize=True)
        print(path, img.size)


if __name__ == '__main__':
    main()
