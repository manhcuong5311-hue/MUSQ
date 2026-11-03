"""Local capture server: serves the site repo, plus /__capture/ from this folder,
and saves POST /__save?name=<file> bodies into ./shots/.

    python3 server.py <site-root> [port]
"""
import http.server, os, re, sys, urllib.parse

HERE = os.path.dirname(os.path.abspath(__file__))
SITE = os.path.abspath(sys.argv[1])
PORT = int(sys.argv[2]) if len(sys.argv) > 2 else 4174
SHOTS = os.path.join(HERE, 'shots')
os.makedirs(SHOTS, exist_ok=True)


class Handler(http.server.SimpleHTTPRequestHandler):
    def translate_path(self, path):
        p = urllib.parse.urlparse(path).path
        if p.startswith('/__capture/'):
            return os.path.join(HERE, p[len('/__capture/'):] or 'index.html')
        return os.path.join(SITE, p.lstrip('/'))

    def do_POST(self):
        q = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
        name = q.get('name', [''])[0]
        if not re.fullmatch(r'[a-z0-9-]+\.(png|json|hdr)', name):
            self.send_error(400)
            return
        data = self.rfile.read(int(self.headers['Content-Length']))
        with open(os.path.join(SHOTS, name), 'wb') as f:
            f.write(data)
        self.send_response(204)
        self.end_headers()

    def log_message(self, *a):
        pass


http.server.ThreadingHTTPServer(('127.0.0.1', PORT), Handler).serve_forever()
