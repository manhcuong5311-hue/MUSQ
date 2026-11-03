"""Writes capture/jobs.json from exercises.tsv and the thumbnails' pose times."""
import json, math
from pathlib import Path

HERE = Path(__file__).resolve().parent
poses = json.loads((HERE.parent.parent / 'thumbnails/posetimes.json').read_text())
jobs = []
for line in (HERE.parent / 'exercises.tsv').read_text().splitlines():
    if line.strip():
        slug, name, model, body, yaw = line.split('\t')
        jobs.append(dict(slug=slug, orbit=f'{round(-math.degrees(float(yaw)))}deg 75deg auto',
                         pose=poses.get(name, {}).get('time', 1.33)))
(HERE / 'jobs.json').write_text(json.dumps(jobs, indent=1))
print(len(jobs), 'jobs')
