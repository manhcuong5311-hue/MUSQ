# Web exercise guide (2026-10-22)

The public 3D exercise guide at <https://musq.app/>, built into the GitHub
Pages repo `musq-site` (a sibling of this repo; `CNAME` is musq.app). The hub
is the home page (the owner wants musq.app to open on the 3D lifter); guides,
the library, models and pictures sit under `/exercises/`, which itself
redirects home; the hand-written support page is `/support/`, next to
`privacy.html` and `terms.html`. It moved there from
`manhcuong5311-hue.github.io/musq/` on 2026-10-29, where `move_to_musq_app.py`
turned the old pages into redirects (run once, done). The app repo is named
`MUSQ`, so the site repo can't be `musq` (GitHub names ignore case). It shows
app models in 3D on the web, collects a launch waitlist and links back to the
app. The first round has 20 pages: 5 chest, 10 legs (the app files the
Deadlift under legs) and 5 back.

## Adding exercises

1. Add a row to `exercises.tsv`: slug, the app's exercise name, the model's
   path under `Resources/Models` (no extension), the shared body file it
   references (`AnatomyBody` or `AnatomyBodyV2`) and the app's framing yaw.
2. Add its copy to `page_copy.py` (search snippet, intro, steps, sets/rest,
   FAQ). The form cues, mistakes and muscle rows come from `SampleData.swift`.
   Match the steps to the model the page shows (the app's "Dumbbell Row" is the
   two-dumbbell bent-over row, for example).
3. `./build_models.sh <slug> ...` — Blender 5.1 imports the slim usdc with
   its body, then `web_export.py` brands it and gltfpack packs it into
   `exercises/<slug>/musq-<slug>.glb` (~2.3 MB):
   - the app's 80 m floor plane is replaced by a platform with a silver ring
     and the MUSQ wordmark facing the default camera (and a smaller one
     behind);
   - MUSQ is printed into the shorts mesh itself (back of the waistband and
     both outer thighs): skinned with the shorts' weights, coloured through a
     vertex colour on the shorts' single material and stapled to the shorts'
     faces, so it is not a separate object, material or island;
   - the sneakers are thinned (80k triangles), every animation is merged into
     one clip with the muscles' flex shape keys, and `stamp.py` writes the
     MUSQ copyright into the glTF asset block (gltfpack drops it).
4. Pictures: `python3 capture/jobs.py`, start `capture/server.py <site> 4174`
   (the `musq-capture` preview config), open
   `http://localhost:4174/__capture/` and wait for ALLDONE. It shoots each
   model in model-viewer at the page's own camera: `-poster` at t=0 (the
   viewer's first frame) and `-pose` at the thumbnails' pose time. Then
   `python3 images.py` writes `poster.webp`, `card.webp` and the 1200×630
   `og.jpg`.
5. `python3 build_site.py` writes every page, `sitemap.xml` and `robots.txt`.

`wordmark.py` (Blender) made `assets/musq-wordmark.svg` and `wordmark.json`
from the same text as the models' print; rerun only to change the logo.

## The app's studio light (2026-10-22)

The owner liked the web's black lifter more than the app's, so the app now
lights models the web's way (`USDZViewport`): `GymWorkout/Resources/
NeutralStudio.hdr` is model-viewer's own "neutral" environment, built by
`capture/env.html` (its `EnvironmentScene`, captured into a cube map and
unwrapped to a lat-long Radiance file) and halved by `capture/studio_hdr.py`.
The body's specular is turned down to 0.1 (matte, the owner's pick of four
glosses; `lab/model-gloss-options.jpg`) and the model ground is the web's
grey studio (`DS.modelGroundInner`/`Outer`/`Spot`). Stills in `lab/`.

## Pieces

- Viewer: `<model-viewer>` 4.1.0 from jsDelivr with the meshopt decoder
  self-hosted (`assets/meshopt_decoder.js`, meshoptimizer 1.3.0, MIT;
  jsDelivr serves the .cjs as application/node, which browsers refuse).
  Camera theta is `-yaw` in degrees, phi 75°. `gpu_gate()` in the page head
  loads model-viewer only where WebGL runs on a graphics chip; headless
  renderers (PageSpeed, crawlers) and GPU-less devices get the poster with
  a "View in 3D" button instead (`.flat` in style.css, `data-act="3d"` in
  app.js). Before the gate (2026-10-29) PageSpeed timed out on every 3D
  page; after it, lat pulldown scored 99/100/100/100 and the home page
  93/100/100/100 on mobile.
- App videos ("Inside the app", `DEMOS` in `build_site.py`): screen
  recordings from the harness simulator, shown in a phone frame.
  - `musq-app-cues-low-to-high-cable-fly.mp4` (2026-10-23, re-shot after
    the cable handle fix): the trainer
    (`HARNESS_EXERCISE="Low-to-High Cable Fly"`, `DEBUG_PREMIUM=1` so the
    mistake shows instead of the paywall) with its five cues riding on the
    joints. The simulator tool's `touch_path` turns the lifter (a drag the
    viewport's width is one turn: +95 pt to the side, −143 pt to the other
    three-quarter, +48 pt back to the front, eased). Then it taps the "Hands
    meet at chin height" label, "Show Common Mistake" and "Done". The loop
    is three reps (23.88 s; one rep is 7.96 s), so its two ends are the same
    pose. Pick the start so the front-view holds before the first drag and
    after Done add up to three reps minus the action between them.
    Recorded with the studio-light look.
  - `musq-app-xray-shoulder-blades.mp4` (2026-10-22): the full
    `XRayDemoView` for the bench press, the 16 s loop. The harness has no
    branch for it; add one to a mirror's ContentView:
    `else if let res = env["HARNESS_XRAY_SCREEN"], let demo = [XRayDemos.benchScapula, XRayDemos.backBarSetup, XRayDemos.deadliftSetup].first(where: { $0.resource == res }) { XRayDemoView(demo: demo, exerciseName: "Barbell Bench Press") }`
    (with the same environment objects as the `HARNESS_EXERCISE` branch).
  - Steps: `LAB=<scratch> Tools/lab/build.sh`; dark appearance and
    `simctl status_bar … --time 9:41`; `simctl io <sim> recordVideo` around
    the launch; find the loop with `swift vid.swift frames`; then
    `swift vid.swift encode <mov> <mp4> <start> <seconds> 720 1600000` and
    save the first frame as the `.webp` poster.
- Waitlist: the Google Sheet "MUSQ Waitlist" in manhcuong531@gmail.com with
  the bound Apps Script in `waitlist/Code.gs`, deployed as a web app (execute
  as me, anyone can call). GET returns only the count; POST adds a valid,
  new email (honeypot field, formula-safe). The endpoint and the sheet link
  are at the top of `build_site.py`. `/waitlist/` (noindex) opens the
  sheet and can turn on a "View emails" link next to the count on the
  owner's own device.
- Launch: set `APP_STORE` in `build_site.py` and rebuild: the forms turn into
  a download button and Safari shows the smart app banner.
- Search engines: Google Search Console has the Domain property
  `sc-domain:musq.app` (verified by a DNS TXT record at Namecheap; the
  sitemap is submitted). Bing and the other IndexNow engines read the key
  file `ebb0140d03154f7d807e47e6b9133f88.txt` at the site root: after
  pushing a rebuild, POST `{"host": "musq.app", "key": …, "keyLocation":
  "https://musq.app/<key>.txt", "urlList": [the sitemap URLs]}` to
  `https://api.indexnow.org/indexnow` (202 = accepted). Google has no such
  API for normal pages; use URL inspection → Request indexing (about 10 a
  day) for new or changed pages.
