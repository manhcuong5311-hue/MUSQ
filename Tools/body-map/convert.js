// Converts react-native-body-highlighter's male body paths (MIT, see LICENSE)
// into GymWorkout/Components/BodyMapPaths.swift.
//
// Every path is normalised to absolute M / L / C / Z only (quadratics and arcs
// become cubics), so the app's parser stays a few lines long. The back view is
// shifted left by 724 so both views share one 724 x 1448 box.
//
//   node convert.js            -> writes ../../GymWorkout/Components/BodyMapPaths.swift
//   node convert.js --json X   -> also writes the normalised data as JSON (preview)

const fs = require("fs");
const path = require("path");

function loadParts(file) {
  let src = fs.readFileSync(path.join(__dirname, file), "utf8");
  src = src.replace(/^import .*$/m, "").replace(/export const \w+: BodyPart\[\] =/, "module.exports =");
  const m = { exports: null };
  new Function("module", src)(m);
  return m.exports;
}

function loadOutlines() {
  const src = fs.readFileSync(path.join(__dirname, "SvgMaleWrapper.tsx"), "utf8");
  const ds = [...src.matchAll(/\bd="([^"]+)"/g)].map((m) => m[1]);
  if (ds.length !== 2) throw new Error("expected front + back outline");
  return { front: ds[0], back: ds[1] };
}

// ---- SVG path normalisation ------------------------------------------------

function normalise(d, dx) {
  let i = 0;
  const ws = () => { while (i < d.length && /[\s,]/.test(d[i])) i++; };
  const num = () => {
    ws();
    const m = /^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?/.exec(d.slice(i));
    if (!m) throw new Error("number expected at " + i + ": " + d.slice(i, i + 20));
    i += m[0].length;
    return parseFloat(m[0]);
  };
  const flag = () => { ws(); const c = d[i++]; if (c !== "0" && c !== "1") throw new Error("flag"); return c === "1"; };
  const more = () => { ws(); return i < d.length && /[-+.\d]/.test(d[i]); };

  const out = [];
  let cx = 0, cy = 0, sx = 0, sy = 0, lastC = null, lastQ = null, cmd = null;
  const P = (x, y) => [x + dx, y];
  const moveTo = (x, y) => { out.push(["M", ...P(x, y)]); cx = sx = x; cy = sy = y; };
  const lineTo = (x, y) => { out.push(["L", ...P(x, y)]); cx = x; cy = y; };
  const curveTo = (x1, y1, x2, y2, x, y) => {
    out.push(["C", ...P(x1, y1), ...P(x2, y2), ...P(x, y)]); cx = x; cy = y;
  };

  while (true) {
    ws();
    if (i >= d.length) break;
    if (/[a-zA-Z]/.test(d[i])) cmd = d[i++];
    else if (cmd === null) throw new Error("path must start with a command");
    const rel = cmd === cmd.toLowerCase();
    const ox = rel ? cx : 0, oy = rel ? cy : 0;
    let nextC = null, nextQ = null;
    switch (cmd.toUpperCase()) {
      case "M": { const x = num() + ox, y = num() + oy; moveTo(x, y); cmd = rel ? "l" : "L"; break; }
      case "L": lineTo(num() + ox, num() + oy); break;
      case "H": lineTo(num() + ox, cy); break;
      case "V": lineTo(cx, num() + oy); break;
      case "C": {
        const x1 = num() + ox, y1 = num() + oy, x2 = num() + ox, y2 = num() + oy, x = num() + ox, y = num() + oy;
        curveTo(x1, y1, x2, y2, x, y); nextC = [x2, y2]; break;
      }
      case "S": {
        const [x1, y1] = lastC ? [2 * cx - lastC[0], 2 * cy - lastC[1]] : [cx, cy];
        const x2 = num() + ox, y2 = num() + oy, x = num() + ox, y = num() + oy;
        curveTo(x1, y1, x2, y2, x, y); nextC = [x2, y2]; break;
      }
      case "Q": case "T": {
        let qx, qy;
        if (cmd.toUpperCase() === "Q") { qx = num() + ox; qy = num() + oy; }
        else [qx, qy] = lastQ ? [2 * cx - lastQ[0], 2 * cy - lastQ[1]] : [cx, cy];
        const x = num() + ox, y = num() + oy;
        curveTo(cx + (2 / 3) * (qx - cx), cy + (2 / 3) * (qy - cy),
                x + (2 / 3) * (qx - x), y + (2 / 3) * (qy - y), x, y);
        nextQ = [qx, qy]; break;
      }
      case "A": {
        const rx = num(), ry = num(), rot = num(), large = flag(), sweep = flag();
        const x = num() + ox, y = num() + oy;
        for (const c of arcToCubics(cx, cy, rx, ry, rot, large, sweep, x, y)) curveTo(...c);
        cx = x; cy = y; break;
      }
      case "Z": out.push(["Z"]); cx = sx; cy = sy; break;
      default: throw new Error("unsupported command " + cmd);
    }
    lastC = nextC; lastQ = nextQ;
    if (cmd.toUpperCase() === "Z") continue;
    if (!more()) continue;
  }
  const f = (v) => { const r = Math.round(v * 10) / 10; return (Object.is(r, -0) ? 0 : r).toString(); };
  return out.map(([c, ...a]) => c + a.map(f).join(" ")).join("");
}

function arcToCubics(x1, y1, rx, ry, phiDeg, large, sweep, x2, y2) {
  if (rx === 0 || ry === 0 || (x1 === x2 && y1 === y2)) return [[x1, y1, x2, y2, x2, y2]];
  const phi = (phiDeg * Math.PI) / 180, cos = Math.cos(phi), sin = Math.sin(phi);
  const dx = (x1 - x2) / 2, dy = (y1 - y2) / 2;
  const x1p = cos * dx + sin * dy, y1p = -sin * dx + cos * dy;
  rx = Math.abs(rx); ry = Math.abs(ry);
  const lam = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry);
  if (lam > 1) { rx *= Math.sqrt(lam); ry *= Math.sqrt(lam); }
  const num = rx * rx * ry * ry - rx * rx * y1p * y1p - ry * ry * x1p * x1p;
  const den = rx * rx * y1p * y1p + ry * ry * x1p * x1p;
  let co = Math.sqrt(Math.max(0, num / den));
  if (large === sweep) co = -co;
  const cxp = (co * rx * y1p) / ry, cyp = (-co * ry * x1p) / rx;
  const ccx = cos * cxp - sin * cyp + (x1 + x2) / 2, ccy = sin * cxp + cos * cyp + (y1 + y2) / 2;
  const ang = (ux, uy, vx, vy) => {
    const a = Math.atan2(ux * vy - uy * vx, ux * vx + uy * vy);
    return a;
  };
  const t1 = ang(1, 0, (x1p - cxp) / rx, (y1p - cyp) / ry);
  let dt = ang((x1p - cxp) / rx, (y1p - cyp) / ry, (-x1p - cxp) / rx, (-y1p - cyp) / ry);
  if (!sweep && dt > 0) dt -= 2 * Math.PI;
  if (sweep && dt < 0) dt += 2 * Math.PI;
  const segs = Math.ceil(Math.abs(dt) / (Math.PI / 2));
  const step = dt / segs, k = (4 / 3) * Math.tan(step / 4);
  const pt = (t) => [ccx + rx * Math.cos(t) * cos - ry * Math.sin(t) * sin, ccy + rx * Math.cos(t) * sin + ry * Math.sin(t) * cos];
  const der = (t) => [-rx * Math.sin(t) * cos - ry * Math.cos(t) * sin, -rx * Math.sin(t) * sin + ry * Math.cos(t) * cos];
  const res = [];
  for (let s = 0; s < segs; s++) {
    const a = t1 + s * step, b = a + step;
    const [ax, ay] = pt(a), [bx, by] = pt(b), [dax, day] = der(a), [dbx, dby] = der(b);
    res.push([ax + k * dax, ay + k * day, bx - k * dbx, by - k * dby, bx, by]);
  }
  return res;
}

// ---- Build -----------------------------------------------------------------

const views = {
  front: { parts: loadParts("bodyFront.ts"), dx: 0 },
  back: { parts: loadParts("bodyBack.ts"), dx: -724 },
};
const outlines = loadOutlines();

const data = {};
for (const [view, { parts, dx }] of Object.entries(views)) {
  data[view] = {
    outline: normalise(outlines[view], dx),
    parts: parts.map((p) => ({
      slug: p.slug,
      paths: [...(p.path.common || []), ...(p.path.left || []), ...(p.path.right || [])].map((d) => normalise(d, dx)),
    })),
  };
}

const jsonAt = process.argv.indexOf("--json");
if (jsonAt > 0) fs.writeFileSync(process.argv[jsonAt + 1], JSON.stringify(data));

// The box every figure is fitted by: the union of both views, so front and
// back draw at the same scale, with a little air round the outline.
const nums = Object.values(data).flatMap((v) => [v.outline, ...v.parts.flatMap((p) => p.paths)])
  .join(" ").replace(/[MLCZ]/g, " ").trim().split(/\s+/).map(Number);
const xs = nums.filter((_, i) => i % 2 === 0), ys = nums.filter((_, i) => i % 2 === 1);
const pad = 4;
const box = [Math.floor(Math.min(...xs)) - pad, Math.floor(Math.min(...ys)) - pad];
box.push(Math.ceil(Math.max(...xs)) + pad - box[0], Math.ceil(Math.max(...ys)) + pad - box[1]);

const caseName = (slug) => slug.replace(/-(\w)/g, (_, c) => c.toUpperCase());
let swift = `//
//  BodyMapPaths.swift
//  GymWorkout
//
//  GENERATED by Tools/body-map/convert.js — do not edit by hand.
//
//  Male front/back muscle outlines from react-native-body-highlighter
//  (https://github.com/HichamELBSI/react-native-body-highlighter),
//  normalised to absolute M/L/C/Z in a shared 724 x 1448 box.
//
//  MIT License — Copyright (c) 2022 ELABBASSI Hicham
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import CoreGraphics

enum BodyMapPaths {
    /// Where the body sits in the 724 x 1448 box, for both views.
    static let contentBox = CGRect(x: ${box[0]}, y: ${box[1]}, width: ${box[2]}, height: ${box[3]})
`;
for (const view of ["front", "back"]) {
  swift += `\n    static let ${view}Outline = "${data[view].outline}"\n`;
  swift += `\n    static let ${view}: [(BodyRegion, [String])] = [\n`;
  for (const p of data[view].parts) {
    swift += `        (.${caseName(p.slug)}, [\n${p.paths.map((d) => `            "${d}"`).join(",\n")}\n        ]),\n`;
  }
  swift += `    ]\n`;
}
swift += `}\n`;
const target = path.join(__dirname, "../../GymWorkout/Components/BodyMapPaths.swift");
fs.writeFileSync(target, swift);
console.log("wrote", target, swift.length, "bytes");
console.log("slugs:", [...new Set([...data.front.parts, ...data.back.parts].map((p) => p.slug))].join(" "));
