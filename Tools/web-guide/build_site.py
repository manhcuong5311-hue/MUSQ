"""Builds the MUSQ 3D exercise guide into the musq-site repo (musq.app).

    python3 build_site.py [--site ../../../musq-site]

Reads exercises.tsv (one row per guide page), the app's SampleData.swift
(the whole library, plus each guide's form cues and muscle rows) and
page_copy.py (the web-only copy), and writes the hub as the home page
(index.html), exercises/ (the guides and library/, which lists every exercise
in the app by muscle), waitlist/, sitemap.xml and robots.txt. support/,
privacy.html and terms.html are hand-written. Models (build_models.sh) and
pictures (capture/) must be made first; a page without its pictures still
builds, just without a poster.
"""
import html, json, math, os, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
SITE = Path(sys.argv[sys.argv.index('--site') + 1]) if '--site' in sys.argv else REPO.parent / 'musq-site'
sys.path.insert(0, str(HERE))
from page_copy import COPY  # noqa: E402

ORIGIN = 'https://musq.app'
# The hub is the site's home page; the guides, the library, the models and the
# pictures live under GUIDE (/exercises/ itself sends visitors on to the hub).
HUB = '/'
GUIDE = '/exercises/'
ENDPOINT = 'https://script.google.com/macros/s/AKfycbyBlaC0d3lZBCrWGRqNr60mdpj3lB5HF3xjQ7RoS1whKj_kXI0Xlr9IVss2msV1fTK71g/exec'
SHEET = 'https://docs.google.com/spreadsheets/d/1iWA8FGSIdB87abxytSHKNgFU_w1bwuaccqBhQC_vzK8/edit'
# Set to the App Store URL on launch: the waitlist forms turn into a download
# button and Safari shows its smart app banner.
APP_STORE = 'https://apps.apple.com/app/musq/id6816021196'
APP_ID = '6816021196'
MODEL_VIEWER = 'https://cdn.jsdelivr.net/npm/@google/model-viewer@4.1.0/dist/model-viewer.min.js'
PUBLISHED = '2026-10-22'
MODIFIED = '2026-10-30'
GROUPS = {'chest': 'Chest', 'legs': 'Legs', 'back': 'Back'}
VERSION = '4'
# Also pasted into the hand-written support/, privacy.html and terms.html.
ICON_LINKS = ['<link rel="icon" href="/favicon.ico" sizes="16x16 32x32 48x48">',
              f'<link rel="icon" href="{GUIDE}assets/icon-192.png" sizes="192x192" type="image/png">',
              f'<link rel="apple-touch-icon" href="{GUIDE}assets/icon-180.png">']
LIBRARY = GUIDE + 'library/'

# The library's sections: (id, heading, app category, primary muscles or None
# for the whole category). Every exercise must land in exactly one.
SECTIONS = [
    ('chest', 'Chest exercises', 'chest', None),
    ('back', 'Back exercises', 'back', None),
    ('shoulders', 'Shoulder exercises', 'shoulders', None),
    ('biceps', 'Biceps exercises', 'arms', {'BICEPS BRACHII', 'BRACHIALIS', 'BRACHIORADIALIS'}),
    ('triceps', 'Triceps exercises', 'arms', {'TRICEPS BRACHII'}),
    ('forearms', 'Forearm exercises', 'arms', {'FOREARM FLEXORS', 'FOREARM EXTENSORS'}),
    ('abs', 'Ab exercises', 'core', {'RECTUS ABDOMINIS', 'SHOULDERS + CORE', 'GRIP + CORE', 'ERECTOR SPINAE', 'ADDUCTORS'}),
    ('obliques', 'Oblique exercises', 'core', {'OBLIQUES'}),
    ('quads', 'Quad exercises', 'legs', {'QUADRICEPS', 'QUADS + GLUTES', 'GLUTES + QUADS', 'QUADS + SHOULDERS'}),
    ('glutes', 'Glute and hip exercises', 'legs', {'GLUTEUS MAXIMUS', 'GLUTEUS MEDIUS', 'ADDUCTORS'}),
    ('hamstrings', 'Hamstring exercises', 'legs', {'HAMSTRINGS', 'GLUTES + HAMSTRINGS', 'POSTERIOR CHAIN'}),
    ('calves', 'Calf and shin exercises', 'legs', {'GASTROCNEMIUS', 'SOLEUS', 'TIBIALIS ANTERIOR'}),
]
EQUIP_FAMILY = {'BARBELL': 'barbell', 'EZ BAR': 'barbell', 'TRAP BAR': 'barbell', 'SAFETY BAR': 'barbell',
                'DUMBBELL': 'dumbbell', 'CABLE': 'cable', 'MACHINE': 'machine', 'BODYWEIGHT': 'bodyweight',
                'KETTLEBELL': 'kettlebell'}

e = lambda s: html.escape(str(s), quote=True)


# ---------------------------------------------------------------- app data

def app_data():
    src = (REPO / 'GymWorkout/Models/SampleData.swift').read_text()
    lib = src[src.index('static let exercises: [Exercise] = ['):]
    lib = lib[:lib.index('\n    ]\n')]
    app_count = len(re.findall(r'Exercise\(name: "', lib))
    STR = r'"((?:[^"\\]|\\.)*)"'

    def block(start):
        depth, i, instr = 0, start, False
        while i < len(src):
            ch = src[i]
            if instr:
                if ch == '\\':
                    i += 2
                    continue
                if ch == '"':
                    instr = False
            elif ch == '"':
                instr = True
            elif ch in '([':
                depth += 1
            elif ch in ')]':
                depth -= 1
                if depth == 0:
                    return src[start:i + 1]
            i += 1

    def field(text, name):
        m = re.search(name + r':\s*((?:' + STR + r'\s*\+?\s*)+)', text)
        return ''.join(s.encode().decode('unicode_escape').encode('latin-1').decode() if '\\' in s else s
                       for s in re.findall(STR, m.group(1))) if m else ''

    contents = dict(re.findall(r'^\s*"([^"]+)":\s*(\w+Content),?\s*$', src, re.M))
    rows = []
    for line in (HERE / 'exercises.tsv').read_text().splitlines():
        if not line.strip():
            continue
        slug, name, model, body, yaw = line.split('\t')
        ex = re.search(r'Exercise\(name: "' + re.escape(name) + r'", category: \.(\w+),\s*primaryMuscle: "([^"]+)", '
                       r'equipment: "([^"]+)",\s*difficulty: \.(\w+)', src)
        m = re.search(r'static let ' + contents[name] + r'\s*=\s*', src)
        text = block(src.index('(', m.end() - 1))
        cues = []
        for cm in re.finditer(r'TechniqueCue\(', text):
            seg = block_from(text, cm.end() - 1)
            cues.append({k: field(seg, k) for k in ('title', 'intro', 'why', 'mistake', 'correct')})
        act = [dict(name=n, rank=r, fraction=float(f)) for n, r, f in
               re.findall(r'MuscleActivation\(name: "([^"]+)", rank: \.(\w+), fraction: ([0-9.]+)\)', text)]
        act.sort(key=lambda a: (a['rank'] != 'primary', -a['fraction']))
        rows.append(dict(slug=slug, name=name, yaw=float(yaw), group=ex.group(1), primary=ex.group(2),
                         equipment=ex.group(3), level=ex.group(4), cues=cues, muscles=act, **COPY[name]))
    return rows, app_count


def library(rows):
    """Every exercise in the app's library, sorted into SECTIONS."""
    src = (REPO / 'GymWorkout/Models/SampleData.swift').read_text()
    lib = src[src.index('static let exercises: [Exercise] = ['):]
    lib = lib[:lib.index('\n    ]\n')]
    guides = {r['name']: r['slug'] for r in rows}
    found = re.findall(r'Exercise\(name: "([^"]+)", category: \.(\w+),\s*primaryMuscle: "([^"]+)", '
                       r'equipment: "([^"]+)",\s*difficulty: \.(\w+)', lib)
    assert len(found) == len(re.findall(r'Exercise\(name: "', lib)), 'an exercise row did not parse'
    sections = {s[0]: [] for s in SECTIONS}
    for name, cat, primary, equip, level in found:
        sid = next(s[0] for s in SECTIONS if s[2] == cat and (s[3] is None or primary in s[3]))
        sections[sid].append(dict(name=name, equipment=equip, level=level, slug=guides.get(name)))
    for items in sections.values():
        items.sort(key=lambda x: x['name'].lower())
    return sections, len(found)


def equip_label(s):
    return 'EZ bar' if s == 'EZ BAR' else nice(s)


def block_from(text, start):
    depth = 0
    for i in range(start, len(text)):
        if text[i] == '(':
            depth += 1
        elif text[i] == ')':
            depth -= 1
            if depth == 0:
                return text[start:i + 1]
    return text[start:]


def nice(s):
    s = s.lower()
    return s[0].upper() + s[1:]


# ---------------------------------------------------------------- pieces

ICON = {
    'play': '<svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><rect x="3" y="2" width="3.5" height="12" rx="1"/><rect x="9.5" y="2" width="3.5" height="12" rx="1"/></svg>',
    'slow': '<svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.6" aria-hidden="true"><circle cx="8" cy="8" r="6"/><path d="M8 4.5V8l2.5 1.5" stroke-linecap="round"/></svg>',
    'reset': '<svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" aria-hidden="true"><path d="M3 8a5 5 0 1 0 1.6-3.7"/><path d="M3 2.5v3h3"/></svg>',
    'why': '<svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="1.6" aria-hidden="true"><circle cx="10" cy="10" r="8"/><path d="M10 9v5M10 6.2v.1" stroke-linecap="round"/></svg>',
    'bad': '<svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" aria-hidden="true"><path d="M10 2.5 18 17H2z" stroke-linejoin="round"/><path d="M10 8v4M10 14.4v.1"/></svg>',
    'good': '<svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="10" cy="10" r="8"/><path d="m6.5 10.2 2.4 2.4 4.6-5"/></svg>',
    'cube': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round" aria-hidden="true"><path d="M12 2.8 20 7v10l-8 4.2L4 17V7z"/><path d="M4 7l8 4.2L20 7M12 11.2V21"/></svg>',
    'bone': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" aria-hidden="true"><path d="M8.5 6.5a2.5 2.5 0 1 0-3.6 3.4 2.5 2.5 0 1 0 3.4 3.6l7.2-7.2a2.5 2.5 0 1 0 3.6-3.4 2.5 2.5 0 1 0-3.4-3.6z" transform="translate(0 3)"/></svg>',
    'ghost': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 3.5 21 19H3z"/><path d="M12 10v4M12 16.6v.1"/></svg>',
    'stretch': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="13" cy="4.5" r="1.8"/><path d="M4 9.5 10 8l3 .5 4.5 5M13 8.5l-1.5 6 4 6.5M11.5 14.5 7 20"/></svg>',
    'plan': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" aria-hidden="true"><rect x="3.5" y="5" width="17" height="15" rx="3"/><path d="M3.5 10h17M8 3v4M16 3v4M8 14h3"/></svg>',
    'lock': '<svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true"><rect x="3" y="7" width="10" height="7" rx="2"/><path d="M5.5 7V5a2.5 2.5 0 0 1 5 0v2"/></svg>',
    'search': '<svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" aria-hidden="true"><circle cx="9" cy="9" r="5.5"/><path d="m13.2 13.2 3.8 3.8"/></svg>',
}


def gpu_gate():
    """Loads the 3D viewer only where WebGL runs on a real graphics chip.

    Crawlers and speed tests (Lighthouse, PageSpeed) draw WebGL in software
    (SwiftShader), where the animated lifter stalls the page until the test
    gives up. Without the `gpu` class the viewers show their poster and a
    "View in 3D" button that loads the viewer on demand (app.js)."""
    return f'''<script>(function () {{
  var d = document.documentElement, gpu = false;
  try {{
    var gl = document.createElement('canvas').getContext('webgl', {{ failIfMajorPerformanceCaveat: true }});
    if (gl) {{
      var info = gl.getExtension('WEBGL_debug_renderer_info');
      gpu = !/swiftshader|llvmpipe|softpipe|software/i.test(info ? gl.getParameter(info.UNMASKED_RENDERER_WEBGL) : '');
      var lose = gl.getExtension('WEBGL_lose_context');
      if (lose) lose.loseContext();
    }}
  }} catch (err) {{}}
  self.musq3d = function () {{
    if (d.classList.contains('gpu')) return;
    d.classList.add('gpu');
    var s = document.createElement('script');
    s.type = 'module';
    s.src = '{MODEL_VIEWER}';
    document.head.appendChild(s);
  }};
  if (gpu) self.musq3d();
}})();</script>'''


def head(title, description, path, image, jsonld, noindex=False, model=False):
    url = ORIGIN + path
    tags = [
        '<!doctype html>',
        f'<html lang="en" data-waitlist="{e(ENDPOINT)}" data-sheet="{e(SHEET)}">',
        '<head>',
        '<meta charset="utf-8">',
        '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">',
        f'<title>{e(title)}</title>',
        f'<meta name="description" content="{e(description)}">',
        f'<link rel="canonical" href="{e(url)}">',
        '<meta name="theme-color" content="#08090a">',
        '<meta name="robots" content="noindex">' if noindex else '<meta name="robots" content="index, follow, max-image-preview:large">',
        '<meta property="og:site_name" content="MUSQ">',
        f'<meta property="og:title" content="{e(title)}">',
        f'<meta property="og:description" content="{e(description)}">',
        f'<meta property="og:url" content="{e(url)}">',
        '<meta property="og:type" content="article">',
        f'<meta property="og:image" content="{e(ORIGIN + image)}">' if image else '',
        '<meta property="og:image:width" content="1200"><meta property="og:image:height" content="630">' if image else '',
        '<meta name="twitter:card" content="summary_large_image">',
        f'<meta name="apple-itunes-app" content="app-id={APP_ID}">' if APP_STORE else '',
        *ICON_LINKS,
        '<link rel="preconnect" href="https://script.google.com">',
        '<link rel="preconnect" href="https://script.googleusercontent.com" crossorigin>',
        f'<link rel="stylesheet" href="{GUIDE}assets/style.css?v={VERSION}">',
    ]
    if model:
        tags += [
            '<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>',
            f"<script>self.ModelViewerElement = {{ meshoptDecoderLocation: '{GUIDE}assets/meshopt_decoder.js' }};</script>",
            gpu_gate(),
        ]
    tags += [f'<script type="application/ld+json">{json.dumps(j, ensure_ascii=False)}</script>' for j in jsonld]
    tags += [f'<script defer src="{GUIDE}assets/app.js?v={VERSION}"></script>', '</head>', '<body>']
    return '\n'.join(t for t in tags if t)


def header():
    cta = (f'<a class="btn small" href="{e(APP_STORE)}">Get the app</a>' if APP_STORE
           else '<a class="btn small" href="#waitlist">Join waitlist</a>')
    return f'''<header class="site-head"><div class="wrap">
  <a class="brand" href="{HUB}" aria-label="MUSQ exercise guide home"><img src="{GUIDE}assets/icon-64.png" alt="" width="30" height="30"><span class="wordmark" aria-hidden="true"></span></a>
  <nav class="site-nav" aria-label="Main"><a class="hide-sm" href="{HUB}">3D guides</a><a href="{LIBRARY}">All exercises</a><a class="hide-sm" href="{HUB}#demos">App demos</a>{cta}</nav>
</div></header>'''


def footer():
    return f'''<footer class="site-foot"><div class="wrap">
  <span class="wordmark" aria-hidden="true"></span>
  <nav aria-label="Footer"><a href="{HUB}">3D exercise guide</a><a href="{LIBRARY}">All exercises</a><a href="/support/">Support</a><a href="/privacy.html">Privacy</a><a href="/terms.html">Terms</a></nav>
  <p>© 2026 MUSQ by Cuong Sam Manh. 3D models, animations and form content are the property of MUSQ and may not be reused or redistributed.</p>
</div></footer>
</body>
</html>
'''


def orbit(yaw):
    return f'{round(-math.degrees(yaw))}deg 75deg auto'


def viewer(x, eager=False):
    poster = f'{GUIDE}{x["slug"]}/poster.webp'
    has_poster = (SITE / poster.lstrip('/')).exists()
    alt = f'3D model of the {e(x["name"].lower())} with the worked muscles highlighted in orange'
    attrs = [
        f'src="{GUIDE}{x["slug"]}/musq-{x["slug"]}.glb"',
        f'poster="{poster}"' if has_poster else '',
        f'alt="{alt}"',
        'camera-controls', 'touch-action="pan-y"', 'disable-zoom', 'autoplay',
        f'camera-orbit="{orbit(x["yaw"])}"', 'max-camera-orbit="auto 98deg auto"',
        'interaction-prompt="none"', 'shadow-intensity="1"', 'shadow-softness="0.9"',
        'exposure="1.05"', 'environment-image="neutral"', 'tone-mapping="neutral"',
        'loading="eager"' if eager else 'loading="auto"',
    ]
    # Shown instead of the viewer where gpu_gate() holds it back (posters are 960 px squares).
    lazy = '' if eager else ' loading="lazy"'
    still = f'<img src="{poster}" alt="{alt}" width="960" height="960"{lazy}>' if has_poster else ''
    return f'''<div class="viewer">
  <model-viewer {" ".join(a for a in attrs if a)}></model-viewer>
  <div class="flat">{still}<button class="ctl" type="button" data-act="3d">{ICON["cube"]}View in 3D</button></div>
  <span class="chip">3D · drag to turn</span>
  <span class="wordmark mark" aria-hidden="true"></span>
  <div class="ctls">
    <button class="ctl" type="button" data-act="play" aria-pressed="false">{ICON["play"]}<span>Pause</span></button>
    <button class="ctl" type="button" data-act="slow" aria-pressed="false">{ICON["slow"]}0.5×</button>
    <button class="ctl" type="button" data-act="reset" aria-label="Reset view">{ICON["reset"]}</button>
    <span class="ctl legend">Worked</span>
  </div>
  <div class="loading" aria-hidden="true"></div>
</div>'''


def join(uid):
    """The waitlist form, or the App Store button once the app is out."""
    if APP_STORE:
        return f'<a class="btn" href="{e(APP_STORE)}">Download on the App Store</a>'
    return f'''<form class="wl-form" data-waitlist novalidate>
    <div class="wl-field">
      <label class="visually-hidden" for="{uid}-email">Email address</label>
      <input id="{uid}-email" type="email" name="email" placeholder="you@email.com" autocomplete="email" inputmode="email" required>
      <button class="btn" type="submit">Join the waitlist</button>
    </div>
    <input class="hp" type="text" name="website" tabindex="-1" autocomplete="off" aria-hidden="true">
    <p class="wl-count" data-count hidden></p>
    <p class="wl-msg" role="status" aria-live="polite"></p>
    <p class="wl-fine">One email when MUSQ launches. No spam, unsubscribe any time. <a href="/privacy.html#waitlist">Privacy</a></p>
  </form>'''


def sheet():
    """The dialog an exercise without a web guide opens: it's in the app."""
    return f'''<dialog class="sheet" id="app-sheet" aria-labelledby="sheet-title">
  <form method="dialog"><button class="sheet-close" aria-label="Close">×</button></form>
  <p class="eyebrow"><span class="dot">●</span> In the MUSQ app</p>
  <h2 id="sheet-title" data-sheet-name>This exercise</h2>
  <p class="lead">See it on the 3D lifter with the muscles it works, the form cues and the common mistakes. {
      'Get MUSQ on the App Store.' if APP_STORE else "MUSQ is coming soon to iPhone: join the waitlist and we'll email you on launch day."}</p>
  {join('sheet')}
</dialog>'''


def waitlist(app_count, heading=None, wide=False):
    heading = heading or 'Train every lift in 3D with MUSQ'
    body = ('Nearly 500 exercises in 3D, x-ray set-up demos, stretching and a plan built around the days you '
            'train. ' + ('MUSQ is free on iPhone.' if APP_STORE else 'MUSQ is coming soon to iPhone.'))
    action = join('wl')
    return f'''<section class="waitlist{' wide' if wide else ''}" id="waitlist" aria-labelledby="wl-title">
  <div>
    <p class="eyebrow"><span class="dot">●</span> {'Free on the App Store' if APP_STORE else 'Coming soon to iPhone'}</p>
    <h2 id="wl-title" style="margin:10px 0 12px">{e(heading)}</h2>
    <p class="lead">{e(body)}</p>
  </div>
  {action}
</section>'''


# Screen recordings from the app on the harness simulator (README: Pieces):
# (file stem, id, title, caption, what the recording shows, seconds).
DEMOS = [
    ('musq-app-cues-low-to-high-cable-fly', 'cues', 'Form cues pinned to the lifter',
     "Each coaching cue rides on the joint it's about, so “Elbows lead the sweep” stays on the elbow "
     'through the whole rep, whichever way you turn the lifter. Tap a cue for why it matters, then see '
     'its common mistake drawn in yellow on the lifter. Shown: the Low-to-High Cable Fly.',
     'the Low-to-High Cable Fly trainer turned to the side and back with its form cues following the '
     'lifter, then a cue card and its common mistake in yellow', 24),
    ('musq-app-xray-shoulder-blades', 'xray', 'X-ray set-up demos',
     'The muscles fade to glass to show what makes the set-up: the shoulder blades locking on the bench '
     '(shown), the grip and lats before a deadlift, and a bar settling onto your back for a squat.',
     'the shoulder blades x-ray demo for the bench press', 16),
]


def demos_block():
    figures = ''.join(f'''
    <figure class="demo" id="{did}">
      <div class="phone"><video src="{GUIDE}assets/{stem}.mp4" poster="{GUIDE}assets/{stem}.webp" muted loop playsinline preload="none" data-inview aria-label="MUSQ app screen recording: {e(shows)}"></video></div>
      <figcaption><b>{e(title)}</b>{e(caption)}</figcaption>
    </figure>''' for stem, did, title, caption, shows, _ in DEMOS)
    return f'''<section class="demos" id="demos" aria-labelledby="demos-title">
  <div class="demos-head">
    <p class="eyebrow">Inside the app</p>
    <h2 id="demos-title" style="margin:10px 0 12px">See it the way MUSQ shows it</h2>
    <p class="lead">Screen recordings from the MUSQ app on iPhone.</p>
  </div>
  <div class="demo-grid">{figures}
  </div>
</section>'''


def card(x):
    pic = f'{GUIDE}{x["slug"]}/card.webp'
    img = (f'<img src="{pic}" alt="{e(x["name"])} 3D model" width="480" height="480" loading="lazy" decoding="async">'
           if (SITE / pic.lstrip('/')).exists() else '')
    return (f'<a class="card" href="{GUIDE}{x["slug"]}/"><div class="pic">{img}</div>'
            f'<div class="meta"><strong>{e(x["name"])}</strong><span>{e(nice(x["equipment"]))} · {e(nice(x["level"]))}</span></div></a>')


# ---------------------------------------------------------------- pages

def exercise_page(x, rows, app_count):
    path = f'{GUIDE}{x["slug"]}/'
    group = GROUPS[x['group']]
    title = f'{x["name"]}: Form Guide & Muscles Worked in 3D | MUSQ'
    og = f'{GUIDE}{x["slug"]}/og.jpg'
    jsonld = [
        {'@context': 'https://schema.org', '@type': 'BreadcrumbList', 'itemListElement': [
            {'@type': 'ListItem', 'position': 1, 'name': '3D Exercise Guide', 'item': ORIGIN + HUB},
            {'@type': 'ListItem', 'position': 2, 'name': f'{group} exercises', 'item': ORIGIN + HUB + '#' + x['group']},
            {'@type': 'ListItem', 'position': 3, 'name': x['name'], 'item': ORIGIN + path}]},
        {'@context': 'https://schema.org', '@type': 'Article', 'headline': f'How to do the {x["name"].lower()}',
         'description': x['description'], 'image': [ORIGIN + og], 'datePublished': PUBLISHED, 'dateModified': MODIFIED,
         'author': {'@type': 'Organization', 'name': 'MUSQ', 'url': ORIGIN + HUB},
         'publisher': {'@type': 'Organization', 'name': 'MUSQ', 'logo': {'@type': 'ImageObject', 'url': ORIGIN + GUIDE + 'assets/icon-512.png'}},
         'mainEntityOfPage': ORIGIN + path},
        {'@context': 'https://schema.org', '@type': 'FAQPage', 'mainEntity': [
            {'@type': 'Question', 'name': q, 'acceptedAnswer': {'@type': 'Answer', 'text': a}} for q, a in x['faqs']]},
    ]
    muscles = '\n'.join(
        f'<li class="{m["rank"]}"><span class="name">{e(m["name"])}</span><span class="rank {m["rank"]}">{e(m["rank"])}</span>'
        f'<span class="bar" role="img" aria-label="{e(m["name"])}: {m["rank"]}, about {round(m["fraction"] * 100)}% activation"><i style="width:{round(m["fraction"] * 100)}%"></i></span></li>'
        for m in x['muscles'])
    steps = '\n'.join(f'<li>{e(s)}</li>' for s in x['steps'])
    cues = '\n'.join(f'''<article class="cue">
  <h3>{e(c["title"])}</h3>
  <p>{e(c["intro"])}</p>
  <div class="rows">
    <div class="row why">{ICON["why"]}<p><b>Why it matters</b>{e(c["why"])}</p></div>
    <div class="row bad">{ICON["bad"]}<p><b>Common mistake</b>{e(c["mistake"])}</p></div>
    <div class="row good">{ICON["good"]}<p><b>Do this instead</b>{e(c["correct"])}</p></div>
  </div>
</article>''' for c in x['cues'])
    faqs = '\n'.join(f'<details><summary>{e(q)}</summary><p>{e(a)}</p></details>' for q, a in x['faqs'])
    related = [r for r in rows if r['group'] == x['group'] and r['slug'] != x['slug']][:4]
    prim = ', '.join(m['name'] for m in x['muscles'] if m['rank'] == 'primary') or nice(x['primary'])
    body = f'''{header()}
<main class="wrap">
  <nav class="crumbs" aria-label="Breadcrumb"><a href="{HUB}">3D exercise guide</a><span aria-hidden="true">/</span><a href="{HUB}#{x["group"]}">{group}</a><span aria-hidden="true">/</span><span aria-current="page">{e(x["name"])}</span></nav>
  <div class="ex-grid">
    <div class="ex-stage">
      {viewer(x, eager=True)}
      <p class="viewer-note">Orange = the muscles this lift works. The same 3D lifter you train with in the MUSQ app.</p>
    </div>
    <article>
      <div class="ex-head">
        <p class="eyebrow">{group} · {e(nice(x["equipment"]))} · {e(nice(x["level"]))}</p>
        <h1>{e(x["name"])}</h1>
        <p class="lead">{e(x["intro"])}</p>
      </div>
      <dl class="facts">
        <div class="wide"><dt>Primary muscles</dt><dd>{e(prim)}</dd></div>
        <div><dt>Equipment</dt><dd>{e(nice(x["equipment"]))}</dd></div>
        <div><dt>Level</dt><dd>{e(nice(x["level"]))}</dd></div>
        <div><dt>Sets × reps</dt><dd>{e(x["sets"])}</dd></div>
        <div><dt>Rest</dt><dd>{e(x["rest"])}</dd></div>
      </dl>
      <section class="section" aria-labelledby="muscles">
        <h2 id="muscles">Muscles worked</h2>
        <p class="sub">Estimated activation, matching the orange paint on the 3D model.</p>
        <ul class="muscles">{muscles}</ul>
      </section>
      <section class="section" aria-labelledby="how">
        <h2 id="how">How to do the {e(x["name"].lower())}</h2>
        <ol class="steps">{steps}</ol>
      </section>
      <section class="section" aria-labelledby="form">
        <h2 id="form">Form cues and common mistakes</h2>
        <p class="sub">The same coaching points MUSQ shows on the lifter in the app.</p>
        <div class="cues">{cues}</div>
      </section>
      {waitlist(app_count)}
      <section class="section faq" aria-labelledby="faq">
        <h2 id="faq">{e(x["name"])} FAQ</h2>
        {faqs}
      </section>
    </article>
  </div>
  {demos_block()}
  <section class="section" aria-labelledby="more">
    <div class="group-head"><h2 id="more">More {group.lower()} exercises</h2><a href="{HUB}#{x["group"]}" class="btn small ghost">All {group.lower()}</a></div>
    <div class="cards">{"".join(card(r) for r in related)}</div>
    <p class="lib-more"><a href="{LIBRARY}">Browse all {app_count} exercises in the app →</a></p>
  </section>
</main>
{footer()}'''
    return head(title, x['description'], path, og, jsonld, model=True) + '\n' + body


SHORT = {'chest': 'Chest', 'back': 'Back', 'shoulders': 'Shoulders', 'biceps': 'Biceps', 'triceps': 'Triceps',
         'forearms': 'Forearms', 'abs': 'Abs', 'obliques': 'Obliques', 'quads': 'Quads', 'glutes': 'Glutes & hips',
         'hamstrings': 'Hamstrings', 'calves': 'Calves & shins'}


def section_links(sections, base=''):
    return ''.join(f'<a href="{base}#{sid}">{SHORT[sid]} <span>{len(sections[sid])}</span></a>' for sid, *_ in SECTIONS)


def library_page(sections, app_count):
    path = LIBRARY
    title = f'Gym Exercise List by Muscle Group: {app_count} Exercises | MUSQ'
    desc = (f'All {app_count} exercises in the MUSQ app by muscle and equipment: chest, back, shoulders, arms, '
            'abs and legs, each on a 3D lifter. Free 3D guides for 20 lifts.')
    jsonld = [
        {'@context': 'https://schema.org', '@type': 'CollectionPage', 'name': 'MUSQ exercise library',
         'description': desc, 'url': ORIGIN + path, 'publisher': {'@type': 'Organization', 'name': 'MUSQ'}},
        {'@context': 'https://schema.org', '@type': 'BreadcrumbList', 'itemListElement': [
            {'@type': 'ListItem', 'position': 1, 'name': '3D Exercise Guide', 'item': ORIGIN + HUB},
            {'@type': 'ListItem', 'position': 2, 'name': 'Exercise library', 'item': ORIGIN + path}]},
    ]
    groups = ''
    for sid, heading, *_ in SECTIONS:
        items = ''
        for it in sections[sid]:
            meta = f'{equip_label(it["equipment"])} · {nice(it["level"])}'
            data = (f'data-search="{e((it["name"] + " " + it["equipment"]).lower())}" '
                    f'data-equip="{EQUIP_FAMILY.get(it["equipment"], "other")}"')
            inner = f'<span class="nm">{e(it["name"])}</span><span class="mt">{e(meta)}</span>'
            if it['slug']:
                items += (f'<li class="lib-row guide" {data}><a href="{GUIDE}{it["slug"]}/">{inner}'
                          f'<span class="tag guide">3D guide</span></a></li>\n')
            else:
                items += (f'<li class="lib-row" {data}><button type="button" data-in-app="{e(it["name"])}">{inner}'
                          f'<span class="tag">{ICON["lock"]}In app</span></button></li>\n')
        groups += f'''<section class="lib-group" id="{sid}" aria-labelledby="h-{sid}">
  <div class="group-head"><h2 id="h-{sid}">{heading}</h2><span><b data-n>{len(sections[sid])}</b> exercises</span></div>
  <ul class="lib-list">
{items}  </ul>
</section>
'''
    equip = [('all', 'All'), ('barbell', 'Barbell'), ('dumbbell', 'Dumbbell'), ('cable', 'Cable'), ('machine', 'Machine'),
             ('bodyweight', 'Bodyweight'), ('kettlebell', 'Kettlebell'), ('other', 'Other')]
    chips = ''.join(f'<button type="button" data-equip="{k}" aria-pressed="{str(k == "all").lower()}">{v}</button>' for k, v in equip)
    guides = sum(1 for items in sections.values() for it in items if it['slug'])
    body = f'''{header()}
<main class="wrap">
  <nav class="crumbs" aria-label="Breadcrumb"><a href="{HUB}">3D exercise guide</a><span aria-hidden="true">/</span><span aria-current="page">Exercise library</span></nav>
  <div class="ex-head" style="max-width:760px">
    <p class="eyebrow"><span class="dot">●</span> MUSQ · {app_count} exercises in 3D</p>
    <h1>Gym exercise list by muscle group</h1>
    <p class="lead">Every exercise in the MUSQ app, sorted by the muscle it trains. {guides} have free 3D form guides on this site; the rest are in the app with their 3D lifter, the muscles they work and their form cues.</p>
  </div>
  <nav class="chips jump wrapchips" aria-label="Muscle groups">{section_links(sections)}</nav>
  <div class="lib-tools" data-library>
    <label class="lib-search">{ICON["search"]}<span class="visually-hidden">Search exercises</span><input type="search" placeholder="Search {app_count} exercises" autocomplete="off" enterkeyhint="search"></label>
    <div class="chips" role="group" aria-label="Equipment">{chips}</div>
  </div>
  {groups}
  <p class="lib-empty" hidden>No exercise matches. Try another name or equipment.</p>
  {waitlist(app_count, heading=f'All {app_count} exercises, in 3D, in your pocket', wide=True)}
</main>
{sheet()}
{footer()}'''
    return head(title, desc, path, GUIDE + 'assets/og-guide.jpg', jsonld) + '\n' + body


def hub_page(rows, app_count, sections):
    path = HUB
    feat = rows[0]
    title = '3D Exercise Guide: Proper Form for Chest, Leg and Back Lifts | MUSQ'
    desc = ('Free 3D form guides for 20 key chest, leg and back exercises: watch each lift from any angle, '
            'see the muscles it works and avoid the common mistakes. From MUSQ, '
            + ('free on iPhone.' if APP_STORE else 'coming soon to iPhone.'))
    jsonld = [
        {'@context': 'https://schema.org', '@type': 'CollectionPage', 'name': '3D Exercise Guide', 'description': desc,
         'url': ORIGIN + path, 'publisher': {'@type': 'Organization', 'name': 'MUSQ'},
         'mainEntity': {'@type': 'ItemList', 'itemListElement': [
             {'@type': 'ListItem', 'position': i + 1, 'url': ORIGIN + GUIDE + r['slug'] + '/', 'name': r['name']}
             for i, r in enumerate(rows)]}},
    ] + [{'@context': 'https://schema.org', '@type': 'VideoObject', 'name': f'MUSQ app: {title}',
          'description': f'Screen recording of the MUSQ app: {shows}.',
          'thumbnailUrl': [ORIGIN + GUIDE + f'assets/{stem}.webp'],
          'contentUrl': ORIGIN + GUIDE + f'assets/{stem}.mp4', 'uploadDate': MODIFIED, 'duration': f'PT{secs}S'}
         for stem, _, title, _, shows, secs in DEMOS]
    groups = ''
    for key, label in GROUPS.items():
        items = [r for r in rows if r['group'] == key]
        groups += f'''<section class="section" id="{key}" aria-labelledby="g-{key}">
  <div class="group-head"><h2 id="g-{key}">{label}</h2><span>{len(items)} exercises</span></div>
  <div class="cards">{"".join(card(r) for r in items)}</div>
</section>'''
    features = [
        ('cube', 'Nearly 500 exercises in 3D', 'Every lift on a moving 3D lifter you can turn to any angle, with the worked muscles lit up.'),
        ('bone', 'X-ray set-up demos', 'See the shoulder blades, grip and spine through glass-clear muscles before you load the bar.'),
        ('ghost', 'Mistakes drawn on the lifter', 'Yellow ghost limbs show the classic errors right next to the correct form.'),
        ('stretch', 'Stretching in 3D', 'Guided stretches for every muscle group on the same 3D lifter.'),
        ('plan', 'Recovery and a weekly plan', 'Log your sets, see which muscles have recovered and get a plan built around the days you train.'),
    ]
    feats = ''.join(f'<div class="feature"><span class="ico">{ICON[i]}</span><h3>{e(t)}</h3><p>{e(d)}</p></div>' for i, t, d in features)
    hero_cta = (f'<a class="btn" href="{e(APP_STORE)}">Download on the App Store</a>' if APP_STORE
                else '<a class="btn" href="#waitlist">Join the waitlist</a>')
    body = f'''{header()}
<main class="wrap">
  <section class="hero">
    <div>
      <p class="eyebrow"><span class="dot">●</span> MUSQ · 3D exercise guide</p>
      <h1 style="margin-top:14px">Learn every lift <em>in 3D.</em></h1>
      <p class="lead">Turn the lifter, slow the rep down and see exactly which muscles do the work. Free 3D form guides for {len(rows)} key chest, leg and back exercises, from the MUSQ app.</p>
      {hero_cta} <a class="btn ghost" href="#chest">Browse exercises</a>
      <div class="stats"><a href="{LIBRARY}" style="text-decoration:none"><strong>{app_count}</strong><span>exercises in the app →</span></a><div><strong>3D</strong><span>every rep, any angle</span></div><div><strong>X-ray</strong><span>set-up demos</span></div></div>
    </div>
    <div>{viewer(feat, eager=True)}<p class="viewer-note"><a href="{GUIDE}{feat["slug"]}/">{e(feat["name"])} form guide →</a></p></div>
  </section>
  <section class="section" aria-labelledby="features"><h2 id="features" class="visually-hidden">What MUSQ does</h2><div class="features">{feats}</div></section>
  {groups}
  <section class="section" aria-labelledby="lib-title">
    <div class="group-head"><h2 id="lib-title">The full library: {app_count} exercises</h2><a class="btn small ghost" href="{LIBRARY}">Browse all</a></div>
    <p class="sub">Every exercise in the MUSQ app, by the muscle it trains. {len(rows)} have free 3D guides here; the rest are in the app.</p>
    <nav class="chips wrapchips" aria-label="Exercise library by muscle">{section_links(sections, LIBRARY)}</nav>
  </section>
  {demos_block()}
  {waitlist(app_count, heading=None if APP_STORE else 'Be first to train with MUSQ', wide=True)}
</main>
{footer()}'''
    return head(title, desc, path, GUIDE + 'assets/og-guide.jpg', jsonld, model=True) + '\n' + body


def owner_page():
    body = f'''{header()}
<main class="wrap" style="padding-top:48px;max-width:640px">
  <p class="eyebrow">Owner</p>
  <h1 style="font-size:40px;margin:10px 0 18px">MUSQ waitlist</h1>
  <p class="wl-count" data-count hidden></p>
  <p class="lead" style="margin:18px 0 22px">The public pages show only the number. The emails are in the Google Sheet, which only the owner's Google account (manhcuong531@gmail.com) can open.</p>
  <a class="btn" href="{e(SHEET)}" target="_blank" rel="noopener">Open the email list</a>
  <label style="display:flex;gap:10px;align-items:center;margin-top:28px;color:var(--text-2)"><input type="checkbox" data-owner-switch> Show a “View emails” link next to the count on this device</label>
</main>
{footer()}'''
    return head('MUSQ waitlist (owner)', 'Owner view of the MUSQ waitlist.', '/waitlist/', '', [], noindex=True) + '\n' + body


def icons():
    """Favicons and the header logo from the app icon.

    Google Search shows the home page's favicon and wants it larger than
    48 px, so the pages offer /favicon.ico (16-48 px) and a 192 px PNG."""
    from PIL import Image
    src = Image.open(REPO / 'GymWorkout/Assets.xcassets/AppIcon.appiconset/1024.png').convert('RGB')
    for size in (32, 64, 180, 192, 512):
        out = SITE / f'exercises/assets/icon-{size}.png'
        if not out.exists():
            src.resize((size, size), Image.LANCZOS).save(out, optimize=True)
    ico = SITE / 'favicon.ico'
    if not ico.exists():
        src.resize((256, 256), Image.LANCZOS).save(ico, sizes=[(16, 16), (32, 32), (48, 48)])


def moved(path):
    """A page that sends visitors and search engines on to path."""
    return f'''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>MUSQ 3D exercise guide</title>
<link rel="canonical" href="{e(ORIGIN + path)}">
<meta http-equiv="refresh" content="0; url={e(path)}">
<script>location.replace({json.dumps(path)} + location.hash)</script>
</head>
<body><p>The MUSQ 3D exercise guide is at <a href="{e(path)}">{e((ORIGIN + path)[8:])}</a>.</p></body>
</html>
'''


def write(rel, text):
    p = SITE / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text)


def main():
    rows, app_count = app_data()
    sections, listed = library(rows)
    assert listed == app_count
    icons()
    for x in rows:
        write(f'exercises/{x["slug"]}/index.html', exercise_page(x, rows, app_count))
    write('index.html', hub_page(rows, app_count, sections))
    write('exercises/index.html', moved(HUB))
    write('exercises/library/index.html', library_page(sections, app_count))
    write('waitlist/index.html', owner_page())
    print('library', {sid: len(items) for sid, items in sections.items()})
    urls = ([HUB, '/support/', '/privacy.html', '/terms.html', LIBRARY]
            + [f'{GUIDE}{r["slug"]}/' for r in rows])
    write('sitemap.xml', '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
          + ''.join(f'  <url><loc>{ORIGIN}{u}</loc><lastmod>{MODIFIED}</lastmod></url>\n' for u in urls) + '</urlset>\n')
    write('robots.txt', f'User-agent: *\nAllow: /\n\nSitemap: {ORIGIN}/sitemap.xml\n')
    print('built', len(rows), 'exercise pages,', app_count, 'exercises in the app')


if __name__ == '__main__':
    main()
