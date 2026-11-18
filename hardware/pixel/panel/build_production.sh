#!/usr/bin/env bash
# Rebuild the Pixel panel package for JLCPCB.
#
# Usage: build_production.sh REF_DIR OUT_DIR [WORK_DIR]
#   REF_DIR: Konnect export_manufacturing_package output for the single board
#            (BOM-pixel.csv, CPL-pixel.csv), made with fab_house jlcpcb,
#            bom_fields Value,Reference,Footprint,LCSC and
#            jlcpcb_cpl_corrections_path ../jlcpcb_cpl_corrections.json.
#   OUT_DIR: release folder, e.g. ../production/v0.2
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
ref="$(realpath "$1")"; out="$(realpath -m "$2")"
work="$(realpath -m "${3:-$(mktemp -d)}")"
mkdir -p "$work" "$out/gerbers"

kikit panelize -p "$here/panel.json" "$here/../pixel.kicad_pcb" "$work/panel.kicad_pcb"
kicad-cli pcb drc --format json --severity-error -o "$work/drc.json" "$work/panel.kicad_pcb" >/dev/null
rm -rf "$work/fab"
kikit fab jlcpcb --no-drc --no-assembly "$work/panel.kicad_pcb" "$work/fab"

rm -f "$out"/gerbers/* "$out"/*.zip
for f in CuTop.gtl CuBottom.gbl MaskTop.gts MaskBottom.gbs PasteTop.gtp PasteBottom.gbp \
         SilkTop.gto SilkBottom.gbo EdgeCuts.gm1 PTH.drl NPTH.drl; do
  cp "$work/fab/gerber/panel-$f" "$out/gerbers/"
done
cp "$work/fab/gerber/panel.gbrjob" "$out/gerbers/"
(cd "$out/gerbers" && zip -q -X "../pixel-panel-gerbers.zip" ./*)

python3 "$here/panel_assembly.py" "$here/../pixel.kicad_pcb" "$work/panel.kicad_pcb" \
    "$ref/BOM-pixel.csv" "$ref/CPL-pixel.csv" "$out" 2>&1 | grep -v 'Debug:'

python3 - "$work/panel.kicad_pcb" "$out" "$work/drc.json" <<'EOF' 2>&1 | grep -v 'Debug:'
import csv, json, re, sys, pcbnew
panel, out, drc = sys.argv[1:]
d = json.load(open(drc))
print(f"panel DRC errors {len(d['violations'])}, unconnected {len(d['unconnected_items'])}")
b = pcbnew.LoadBoard(panel)
aux = b.GetDesignSettings().GetAuxOrigin()
ox, oy = pcbnew.ToMM(aux.x), pcbnew.ToMM(aux.y)
rows = {r['Designator']: r for r in csv.DictReader(open(f"{out}/CPL-pixel-panel.csv"))}
worst, sides = 0.0, []
for f in b.GetFootprints():
    r = rows.get(f.GetReference())
    if not r:
        continue
    bx = [p.GetBoundingBox() for p in f.Pads()]
    x = pcbnew.ToMM((min(q.GetLeft() for q in bx) + max(q.GetRight() for q in bx)) / 2) - ox
    y = -pcbnew.ToMM((min(q.GetTop() for q in bx) + max(q.GetBottom() for q in bx)) / 2) + oy
    worst = max(worst, abs(x - float(r['Mid X'])), abs(y - float(r['Mid Y'])))
    if ('bottom' if f.IsFlipped() else 'top') != r['Layer']:
        sides.append(r['Designator'])
print(f"CPL rows {len(rows)}; worst offset vs panel pad centres {worst:.4f} mm; side mismatches {sides}")
g = open(f"{out}/gerbers/panel-PasteTop.gtp").read()
fl = [(int(a) / 1e6, int(c) / 1e6) for a, c in re.findall(r'X(-?\d+)Y(-?\d+)D03', g)]
w2 = 0.0
for r in rows.values():
    if r['Designator'].split('_')[0] not in ('R1', 'R2', 'R3', 'R4', 'C1', 'C2'):
        continue
    x, y = float(r['Mid X']), float(r['Mid Y'])
    near = [p for p in fl if abs(p[0] - x) < 0.9 and abs(p[1] - y) < 0.9]
    assert len(near) == 2, r['Designator']
    w2 = max(w2, abs((near[0][0] + near[1][0]) / 2 - x), abs((near[0][1] + near[1][1]) / 2 - y))
print(f"top paste openings {len(fl)}; 2-pad parts worst offset vs paste {w2:.4f} mm")
EOF
(cd "$out" && sha256sum pixel-panel-gerbers.zip BOM-pixel-panel.csv CPL-pixel-panel.csv)
sha256sum "$work/panel.kicad_pcb"
