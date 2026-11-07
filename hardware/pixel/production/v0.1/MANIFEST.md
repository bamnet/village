# Pixel PCB v0.1 — JLCPCB package

Status: **exported, not yet ordered.** When the order is placed, fill in the
order section and tag the commit `pixel-v0.1`. Do not change these files after
ordering. A design change gets a new silkscreen version and a new folder.

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

- Date:
- JLCPCB order number:
- Quantity / options (finish, color, order-number location):
- Placement preview notes (any rotations changed by hand):
- Cost:

## Results

(Notes from bring-up: R2 tests, brightness, plug fit.)
