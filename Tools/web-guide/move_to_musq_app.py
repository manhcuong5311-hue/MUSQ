"""Turns the old MUSQ pages on manhcuong5311-hue.github.io/musq/ into redirects to musq.app.

    python3 move_to_musq_app.py [--site ../../../manhcuong5311-hue.github.io]

Run once, after musq.app serves the musq-site repo over HTTPS. Every old page
becomes a stub (canonical + instant refresh + location.replace) pointing at the
same path on musq.app (the old support page at /support/, the old hub at the
home page), so App Store links, the app's Purchases.swift links and Google's
index all follow. Models, pictures and videos under musq/ are deleted
(musq.app has them). The root sitemap keeps only the root page and the root
index links to musq.app; app-ads.txt and the Search Console file stay.
"""
import html, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
SITE = Path(sys.argv[sys.argv.index('--site') + 1]) if '--site' in sys.argv else HERE.parent.parent.parent / 'manhcuong5311-hue.github.io'
OLD = 'https://manhcuong5311-hue.github.io'
NEW = 'https://musq.app'
# Old paths whose page sits elsewhere on musq.app: the guide hub is the home page.
MOVED = {'/': '/support/', '/exercises/': '/'}


def stub(path):
    url = NEW + path
    u = html.escape(url, quote=True)
    return f'''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>MUSQ has moved to musq.app</title>
<link rel="canonical" href="{u}">
<meta http-equiv="refresh" content="0; url={u}">
<script>location.replace({url!r} + location.search + location.hash)</script>
</head>
<body><p>MUSQ has moved to <a href="{u}">{html.escape(url[8:])}</a>.</p></body>
</html>
'''


def main():
    old = SITE / 'musq'
    pages = [p for p in old.rglob('*.html')]
    for p in old.rglob('*'):
        if p.is_file() and p.suffix != '.html':
            p.unlink()
    for p in pages:
        rel = p.relative_to(old).as_posix()
        path = '/' + (rel[:-len('index.html')] if rel.endswith('index.html') else rel)
        p.write_text(stub(MOVED.get(path, path)))
    for d in sorted((d for d in old.rglob('*') if d.is_dir()), key=lambda d: -len(d.parts)):
        if not any(d.iterdir()):
            d.rmdir()
    (SITE / 'sitemap.xml').write_text('<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
                                      f'  <url><loc>{OLD}/</loc></url>\n</urlset>\n')
    index = SITE / 'index.html'
    index.write_text(re.sub(re.escape(OLD) + r'/musq(/[^"]*)', lambda m: NEW + MOVED.get(m[1], m[1]), index.read_text()))
    print(len(pages), 'pages now redirect to', NEW)


if __name__ == '__main__':
    main()
