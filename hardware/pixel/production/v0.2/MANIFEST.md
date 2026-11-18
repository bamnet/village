# Pixel PCB v0.2: JLCPCB panel package

Status: **ready to order, not ordered yet.** The holder team reviewed it in
PR #17 (2026-11-18), and the holder itself is iterated separately (PR #18). If
the design changes before ordering, regenerate everything here and update the
hashes. Once it's ordered, these files never change.

## Source

- Design: the commit that adds this revision of the package. It includes the
  holder team's PR #17 review fixes (v0.1 leftover silkscreen removed, signal-pin
  triangles added on the bottom silkscreen).
  - `pixel.kicad_pcb` sha256 `32c55fa0c45a00e81fef021961ed34ca552d872291fb59903b475a8d09b2398a`
  - `pixel.kicad_sch` sha256 `5aafa648ebd98915af7918252c6ea0374acad2ee27dcfe8907253da45c313525`
- Tools: KiCad 10.0.8, KiKit 1.8.1, Konnect 0.13.0.
- Rebuild everything with `../../panel/build_production.sh <konnect-export-dir> .`.
  The script:
  - panelizes with `../../panel/panel.json`
  - plots the gerbers and drills with `kikit fab jlcpcb --no-assembly`, leaving
    out KiKit's drill maps and comment layer
  - expands the BOM and CPL
  - runs the checks below
- The panel board isn't committed. The one built for these files had sha256
  `d166334f53fb50cf1a35a378f628e0c8975c824ac8d18e028e5d4f8defe28c4c`.
- Re-zipping changes the zip's hash, because file timestamps go into the zip.
  The zip's contents are the files in `gerbers/`.
- BOM and CPL:
  1. Konnect `export_manufacturing_package` on the single board: `fab_house`
     jlcpcb, BOM fields `Value,Reference,Footprint,LCSC`, and
     `jlcpcb_cpl_corrections_path` `../../jlcpcb_cpl_corrections.json`
     (policy v2: U1 +270 and D1 +180 as on v0.1, plus +90 for both vertical
     headers, added after JLCPCB's bottom-side preview showed them turned 90°).
  2. `../../panel/panel_assembly.py` expands that to the 16 panel copies
     (designators `<ref>_<n>`, n = 0 - 15) and shifts the coordinates to the
     panel's aux origin, which is the gerbers' origin.
  - Why not KiKit's own assembly output: its `--correctionpatterns` scrambled
    coordinates, and on the panel it wrote an empty position file.

## Panel

- 4 x 4 boards, 100.0 x 115.0 mm (gerber profile), inside JLCPCB's 70 - 250 mm
  limits.
- 5 mm frame. 3 mm crossbars between rows. 2 mm milled gaps. 1 mm mill radius.
- Tabs: one 3 mm mouse-bite tab at north and one at south per board. Holes are
  Ø0.5 mm at 0.8 mm pitch, centered on the board edge. Nothing else touches the
  edge, because the holder's jaws grip everywhere except north and south.
  **Cut the tabs with flush cutters; don't snap them.** D4's body is 0.5 mm from
  the south holes.
- 4 tooling holes, Ø1.152 mm, 2.5 mm in from the corners. 3 fiducials: 1 mm
  copper, 2 mm mask opening.
- No order-number text. Use "Remove Mark" (JLCPCB doesn't print one anyway).

## Checks at export (2026-11-18)

- **Single board:**
  - ERC: 0.
  - DRC: 0 errors, 0 warnings, 0 unconnected.
- **Panel:**
  - DRC: 0 errors, 0 unconnected. The warnings are footprint-library notices only,
    because it was built outside the project folder.
- **CPL** (208 rows, 13 parts x 16):
  - Every row matches its footprint's pad-box center in the panel board
    (worst difference 0.0000 mm), and every part's side is correct.
  - Every 2-pad part is centered on its two paste openings in
    `panel-PasteTop.gtp` (worst 0.0000 mm).
  - Coordinates span X 9.3 - 89.4, Y −105.6 to −10.6, inside the 0 - 100 /
    −115 - 0 profile.
- **BOM:** 11 lines, all with LCSC numbers. R2 is now 4.7k (C25900).
- **Silkscreen:**
  - Top: "v0.2" and the south arrow.
  - Bottom: a triangle at each header's signal pin (J1 west, J2 east); 32
    regions across the panel.
  - No v0.1 leftovers.
- **Gerbers:**
  - Top paste has 752 openings (47 per board, the same as v0.1). Bottom paste
    is empty of SMD.
  - PTH: 304 hits (16 x 13 vias + 6 header pins), drills 0.3 and 1.0 mm.
  - NPTH: mouse bites (0.5 mm) and tooling holes (1.152 mm).

## Files

| File | Upload to | sha256 |
|---|---|---|
| `pixel-panel-gerbers.zip` (contents of `gerbers/`) | PCB order | `a486e723d9e60a509c145769d369a04c8cb5c612afdb2acf230cf7c76c73b44c` |
| `BOM-pixel-panel.csv` | Assembly: BOM | `bbf5931823b1533d5a3b967859ccac7c07e3f83913aa8aa059999e2e15c7a5c5` |
| `CPL-pixel-panel.csv` | Assembly: CPL | `235c61ea1fb8f0f733d1cd878185f84b42e3e377bb02417bc7a5d5516bfd305b` |

## Order settings to use

- **PCB:**
  - FR-4, 2 layers, 1.6 mm, 1 oz.
  - **White solder mask** (black silkscreen).
  - LeadFree HASL, tented vias.
  - Panel by customer: 1 design, 4 x 4.
  - Mark on PCB: Remove Mark.
  - Quantity: 2 panels (32 boards, for 22 houses plus spares).
- **Assembly:**
  - **Standard PCBA, both sides.** The J1/J2 bodies are on the bottom, and their
    joints are hand- or selective-soldered on top. JLCPCB quoted $0.0164 per
    joint plus $3.58 per order.
  - Confirm Parts Placement: Yes.
- **Placement preview:** check U1 (pin 1), D1, and the LED corner marks
  (pin 2 = white cathode, as on v0.1), plus J1/J2 on the bottom. Watch JLCPCB's
  DFM notes on how close the SMT parts are to the header pins:
  - U1 0.64 mm
  - R1 about 0.73 mm
  - R3 about 0.81 mm
  - D1 about 0.92 mm

## Order

Not ordered yet.
