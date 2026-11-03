"""Rewrite a GLB's asset block: MUSQ copyright and app extras (gltfpack drops them)."""
import json, struct, sys
COPYRIGHT = "(c) 2026 MUSQ. All rights reserved. 3D model from the MUSQ app - https://musq.app/"
def stamp(path, title):
    b = open(path, 'rb').read()
    magic, ver, _ = struct.unpack('<III', b[:12])
    jlen, jtype = struct.unpack('<II', b[12:20])
    j = json.loads(b[20:20 + jlen])
    rest = b[20 + jlen:]
    j['asset']['copyright'] = COPYRIGHT
    j['asset']['extras'] = {"app": "MUSQ", "title": title, "license": "All rights reserved. Not for reuse or redistribution."}
    if j.get('scenes'):
        j['scenes'][0]['name'] = 'MUSQ - ' + title
    if j.get('animations'):
        j['animations'][0]['name'] = 'MUSQ - ' + title
    raw = json.dumps(j, separators=(',', ':')).encode()
    raw += b' ' * (-len(raw) % 4)
    body = struct.pack('<II', len(raw), jtype) + raw + rest
    open(path, 'wb').write(struct.pack('<III', magic, ver, 12 + len(body)) + body)
if __name__ == '__main__':
    stamp(sys.argv[1], sys.argv[2])
