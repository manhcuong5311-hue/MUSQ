"""Turns the capture shots into the site's pictures.

    python3 images.py [--site <site root>]

capture/shots/<slug>-poster.png (t=0, the viewer's own framing) -> poster.webp
capture/shots/<slug>-pose.png  (the clip's most telling pose)   -> card.webp, og.jpg
plus assets/og-guide.jpg for the guide's front page.
"""
import json, math, re, sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageFont

HERE = Path(__file__).resolve().parent
SITE = Path(sys.argv[sys.argv.index('--site') + 1]) if '--site' in sys.argv else HERE.parent.parent.parent / 'musq-site'
SHOTS = HERE / 'capture/shots'
OUT = SITE / 'exercises'
WORD = json.loads((HERE / 'wordmark.json').read_text())
GROUPS = {'chest': 'CHEST', 'legs': 'LEGS', 'back': 'BACK', 'shoulders': 'SHOULDERS', 'arms': 'ARMS', 'core': 'ABS'}


def font(bold, size):
    for path in ('/System/Library/Fonts/HelveticaNeue.ttc', '/System/Library/Fonts/Helvetica.ttc'):
        for i in range(12):
            try:
                f = ImageFont.truetype(path, size, index=i)
            except OSError:
                break
            style = f.getname()[1].lower()
            if (bold and style == 'bold') or (not bold and style in ('regular', 'roman')):
                return f
    return ImageFont.load_default(size)


def studio(size, center=(0.5, 0.36)):
    """The viewer's grey studio ground (style.css --studio) as an image."""
    w, h = size
    small = Image.new('RGB', (w // 4, h // 4))
    px = small.load()
    stops = [(0, (163, 168, 176)), (.42, (117, 122, 130)), (.82, (63, 67, 73)), (1, (44, 47, 51))]
    cx, cy = center[0] * small.width, center[1] * small.height
    rx, ry = small.width * 1.2 / 2, small.height * .95 / 2
    for y in range(small.height):
        for x in range(small.width):
            t = min(1, math.hypot((x - cx) / rx, (y - cy) / ry))
            for (t0, c0), (t1, c1) in zip(stops, stops[1:]):
                if t <= t1:
                    k = (t - t0) / (t1 - t0)
                    px[x, y] = tuple(round(a + (b - a) * k) for a, b in zip(c0, c1))
                    break
    return small.resize(size, Image.BICUBIC)


def wordmark(width, fill=(232, 235, 239)):
    """The MUSQ wordmark (the models' own outline) as an RGBA image."""
    k = width / WORD['width']
    h = math.ceil(WORD['height'] * k)
    big = 4
    mask = Image.new('L', (width * big, h * big), 0)
    d = ImageDraw.Draw(mask)
    loops = sorted(WORD['loops'], key=lambda l: -abs(area(l)))
    for loop in loops:
        d.polygon([(x * k * big, y * k * big) for x, y in loop], fill=255 if area(loop) < 0 else 0)
    mask = mask.resize((width, h), Image.LANCZOS)
    img = Image.new('RGBA', (width, h), fill + (0,))
    img.putalpha(mask)
    return img


def area(loop):
    # Shoelace in the flipped (y-down) frame: outer contours come out negative.
    return sum(x0 * y1 - x1 * y0 for (x0, y0), (x1, y1) in zip(loop, loop[1:] + loop[:1])) / 2


def crop_square(im, pad=1.10):
    box = im.getchannel('A').point(lambda a: 255 if a > 40 else 0).getbbox()
    cx, cy = (box[0] + box[2]) / 2, (box[1] + box[3]) / 2
    side = max(box[2] - box[0], box[3] - box[1]) * pad
    side = min(side, im.width)
    x0 = min(max(0, cx - side / 2), im.width - side)
    y0 = min(max(0, cy - side / 2), im.height - side)
    return im.crop((round(x0), round(y0), round(x0 + side), round(y0 + side)))


def og(name, eyebrow, pose, out, title_size=74):
    W, H = 1200, 630
    img = Image.new('RGB', (W, H), (8, 9, 10))
    panel = studio((560, 560))
    pmask = Image.new('L', panel.size, 0)
    ImageDraw.Draw(pmask).rounded_rectangle((0, 0, *panel.size), 36, fill=255)
    img.paste(panel, (W - 595, 35), pmask)
    lifter = crop_square(pose, 1.04).resize((540, 540), Image.LANCZOS)
    img.paste(lifter, (W - 585, 45), lifter)
    d = ImageDraw.Draw(img)
    mark = wordmark(150)
    img.paste(mark, (64, 64), mark)
    d.text((64, 190), eyebrow, font=font(False, 22), fill=(142, 148, 156))
    def wrap(size):
        f = font(True, size)
        lines, line = [], ''
        for word in name.split():
            test = (line + ' ' + word).strip()
            if d.textlength(test, font=f) > 520 and line:
                lines.append(line)
                line = word
            else:
                line = test
        return f, lines + [line]

    f, lines = wrap(title_size)
    if len(lines) > 2:
        title_size = 60
        f, lines = wrap(title_size)
    y = 232
    for l in lines:
        d.text((62, y), l, font=f, fill=(245, 246, 247))
        y += round(title_size * 1.08)
    d.text((64, y + 20), 'Form guide · muscles worked · in 3D', font=font(False, 26), fill=(201, 205, 210))
    ly = max(H - 108, y + 74)
    d.rounded_rectangle((64, ly, 64 + 14, ly + 14), 7, fill=(255, 86, 34))
    d.text((90, ly - 5), 'Worked muscles in orange', font=font(False, 21), fill=(142, 148, 156))
    img.save(out, quality=86, optimize=True, progressive=True)


def main():
    rows = [l.split('\t') for l in (HERE / 'exercises.tsv').read_text().splitlines() if l.strip()]
    src = (HERE.parent.parent / 'GymWorkout/Models/SampleData.swift').read_text()
    for slug, name, model, body, yaw in rows:
        m = re.search(r'Exercise\(name: "' + re.escape(name) + r'", category: \.(\w+),\s*primaryMuscle: "[^"]+", equipment: "([^"]+)",', src)
        poster = Image.open(SHOTS / f'{slug}-poster.png').convert('RGBA')
        poster.resize((960, 960), Image.LANCZOS).save(OUT / slug / 'poster.webp', quality=80, method=6)
        pose = Image.open(SHOTS / f'{slug}-pose.png').convert('RGBA')
        crop_square(pose).resize((480, 480), Image.LANCZOS).save(OUT / slug / 'card.webp', quality=80, method=6)
        og(name, f'{GROUPS[m.group(1)]} · {m.group(2)}', pose, OUT / slug / 'og.jpg')
        print('pictures', slug)
    # Front page: three lifts side by side.
    W, H = 1200, 630
    img = Image.new('RGB', (W, H), (8, 9, 10))
    for i, slug in enumerate(('barbell-bench-press', 'back-squat', 'pull-up')):
        panel = studio((360, 360))
        pm = Image.new('L', panel.size, 0)
        ImageDraw.Draw(pm).rounded_rectangle((0, 0, *panel.size), 28, fill=255)
        x = 30 + i * 385
        img.paste(panel, (x + 12, 240), pm)
        pose = crop_square(Image.open(SHOTS / f'{slug}-pose.png').convert('RGBA'), 1.02).resize((350, 350), Image.LANCZOS)
        img.paste(pose, (x + 17, 245), pose)
    d = ImageDraw.Draw(img)
    mark = wordmark(150)
    img.paste(mark, (44, 50), mark)
    d.text((42, 110), '3D Exercise Guide', font=font(True, 72), fill=(245, 246, 247))
    d.text((44, 196), 'Proper form for 30 key gym lifts, in 3D', font=font(False, 26), fill=(201, 205, 210))
    img.save(OUT / 'assets/og-guide.jpg', quality=86, optimize=True, progressive=True)
    print('pictures og-guide')


if __name__ == '__main__':
    main()
