#!/usr/bin/env python3
"""Expand a verified single-board JLCPCB BOM/CPL to the KiKit panel.

The single-board files come from Konnect's export_manufacturing_package, which
applies ../jlcpcb_cpl_corrections.json and uses pad-midpoint positions. KiKit
only translates each board copy, so every part keeps its rotation and moves by
that board's offset. Panel designators are `<ref>_<n>`, set by `renameref` in
panel.json.

Usage: panel_assembly.py BOARD.kicad_pcb PANEL.kicad_pcb BOM.csv CPL.csv OUTDIR
"""
import csv
import os
import re
import sys
from collections import defaultdict

import pcbnew


def positions(path):
    b = pcbnew.LoadBoard(path)
    return {f.GetReference(): (pcbnew.ToMM(f.GetPosition().x), pcbnew.ToMM(f.GetPosition().y),
                               f.GetOrientationDegrees())
            for f in b.GetFootprints()}


def main(board, panel, bom_in, cpl_in, outdir):
    single = positions(board)
    copies = defaultdict(list)  # ref -> [(panel_ref, dx, dy)]
    for pref, (x, y, rot) in positions(panel).items():
        m = re.fullmatch(r"(.+)_(\d+)", pref)
        if not m or m.group(1) not in single:
            continue
        ref = m.group(1)
        sx, sy, srot = single[ref]
        if abs((rot - srot + 180) % 360 - 180) > 1e-6:
            sys.exit(f"{pref}: rotated in panel ({srot} -> {rot}); script assumes translation only")
        copies[ref].append((pref, x - sx, y - sy))

    # KiKit's gerbers are plotted relative to the panel's aux origin, so the CPL
    # must be too. The single-board CPL is absolute (no aux origin set).
    aux = pcbnew.LoadBoard(panel).GetDesignSettings().GetAuxOrigin()
    ox, oy = pcbnew.ToMM(aux.x), pcbnew.ToMM(aux.y)

    with open(cpl_in, newline="") as f:
        rows = list(csv.DictReader(f))
    n = {len(v) for v in copies.values()}
    if len(n) != 1:
        sys.exit(f"uneven copy counts: { {k: len(v) for k, v in copies.items()} }")
    os.makedirs(outdir, exist_ok=True)
    with open(os.path.join(outdir, "CPL-pixel-panel.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["Designator", "Mid X", "Mid Y", "Layer", "Rotation"])
        for r in rows:
            for pref, dx, dy in sorted(copies[r["Designator"]], key=lambda c: int(c[0].rsplit("_", 1)[1])):
                # CPL Y is KiCad Y negated, so a +dy panel shift is -dy here,
                # and the aux origin's Y is added back.
                w.writerow([pref, f"{float(r['Mid X']) + dx - ox:.6f}", f"{float(r['Mid Y']) - dy + oy:.6f}",
                            r["Layer"], r["Rotation"]])

    with open(bom_in, newline="") as f:
        bom = list(csv.DictReader(f))
    lines = defaultdict(list)
    for r in bom:
        lines[(r["Value"], r["Footprint"], r["LCSC"])].append(r["Reference"])
    with open(os.path.join(outdir, "BOM-pixel-panel.csv"), "w", newline="") as f:
        w = csv.writer(f, quoting=csv.QUOTE_ALL)
        w.writerow(["Comment", "Designator", "Footprint", "LCSC"])
        for (val, fp, lcsc), refs in lines.items():
            prefs = [p for ref in refs for p, _, _ in sorted(copies[ref], key=lambda c: int(c[0].rsplit("_", 1)[1]))]
            w.writerow([val, ",".join(prefs), fp, lcsc])
    print(f"{len(rows)} parts x {n.pop()} boards; {len(lines)} BOM lines")


if __name__ == "__main__":
    main(*sys.argv[1:])
