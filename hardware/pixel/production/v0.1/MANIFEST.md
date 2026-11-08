# Pixel PCB v0.1 — JLCPCB package

Status: **ordered 2026-11-07** (tag `pixel-v0.1`). Do not change these files.
A design change gets a new silkscreen version and a new folder.

## Source

- Design commit: `6c50502` (design files unchanged since then)
- `pixel.kicad_pcb` sha256 `990ad7e6a336a6a367b935dd27d177a6b77589a8c8bd5e12325c9acc50b7d195`
- `pixel.kicad_sch` sha256 `d1a92fbe0fe950afcc0ada40763c400027faf594202c1801a2f1884aec7bc9a7`
- Exported 2026-11-07 with KiCad 10.0.7 and Konnect 0.13.0
  (`export_manufacturing_package`, see the README for settings), using
  `../../jlcpcb_cpl_corrections.json` (U1 +270, D1 +180)

## Checks at export

- ERC 0. DRC 0 errors, 0 unconnected, 21 known warnings. Konnect
  `validate_for_manufacturing`: READY.
- BOM: 13 parts, 11 lines, all with LCSC numbers. CPL: 13 designators,
  J1/J2 bottom.
- F.Paste has 47 openings (all top SMD pads), and B.Paste is empty. 10 plated
  holes (4 vias, 6 header pins), no unplated holes. Board 20.05 mm across.

## Files

| File | Upload to | sha256 |
|---|---|---|
| `pixel-gerbers.zip` (contents of `gerbers/`) | PCB order | `e67999fe7ae5c5f48e412ce53392cb825c0240a6392519c25da7ecde340dcf7b` |
| `BOM-pixel.csv` | Assembly: BOM | `329fb71eb900b93ca07f0aa84125ac1d348f65f8ce248c8d7514a068fe367766` |
| `CPL-pixel.csv` | Assembly: CPL | `b570591aff24918e6c3cae0d36068e3800e1cd7b92f8f48418a611c4d79d4650` |

## Order

- Date: 2026-11-07
- JLCPCB order numbers: PCB `Y12-3347415A`, assembly `SMT026110860016`
- PCB: 5 pcs, FR-4, 2 layers, 1.6 mm, green with white silkscreen, FR4 TG135,
  LeadFree HASL, 1 oz, tented vias, 0.3 mm min via, ±0.2 mm outline, flying
  probe test, single PCB (no panel), no deburring. Mark on PCB: Remove Mark,
  so no order number is printed and the "JLCJLCJLCJLC" text is just silkscreen.
- Assembly: Economic, top side only, 5 pcs, tooling holes by JLCPCB, Confirm
  Parts Placement: Yes, parts by customer, high-temp paste.
- **J1/J2 are not assembled.** Economic assembly is single-sided and drops the
  bottom-side headers, and Standard (two sides) requires a board of at least
  70 mm. J1 (C492411) and J2 (C2897385) are hand-soldered from parts on hand.
  The uploaded BOM/CPL still list them; JLCPCB ignored the bottom-side lines.
- Placement preview: all 9 top-side lines matched their LCSC parts with no
  stock warnings. U1, D1 and D2–D4 orientations checked against the footprints
  and correct, so no rotations were changed by hand. D1 bought 10 and the LEDs
  15 (JLCPCB minimums/attrition).
- Cost: PCB $5.10, assembly $22.50, shipping $29.09, duties/taxes and fees
  $15.37, discount −$6.00. Total $66.06.

## Results

(Notes from bring-up: R2 tests, brightness, plug fit.)
