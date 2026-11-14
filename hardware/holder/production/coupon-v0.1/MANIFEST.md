# House holder coupon v0.1: print package

Status: **ready to print, not yet printed.** Do not change these files. A design
change gets a new folder (`coupon-v0.2`, or `holder-v0.1` for the full holder).

Purpose: pick the clip ring's arm design before printing a full holder. See the
README's "House holder" section for the test plan (steps 1 - 6).

## Source

- Design commit: `665ba7d` (branch `holder-vertical`)
- Rendered 2026-11-08 with OpenSCAD 2021.01:
  - `openscad -o coupon.stl coupon.scad`
  - `openscad -o test_rings.stl test_rings.scad`

  Both commands run from `hardware/holder/`.

## Files

| File | Contents | sha256 |
|---|---|---|
| `coupon.stl` | 4 clip rings, A - D, letter engraved on the flange | `514ae1f62a1c7f41345d59bb8e7817952fee0330cfda0e46c774867da6945960` |
| `test_rings.stl` | 4 test walls: Ø24/Ø29 hole x 3/9 mm thick, size engraved on top | `e6d1da87c179845b0b4b247fb5f523e8931247cfb691c4f5c854a57609e5cd7e` |

## Variants

All four have 3 arms and a Ø34 x 2.4 mm flange. Values are from OpenSCAD's echo
output.

- **Arm** is the arm thickness.
- **Slope** is the barb face slope.
- **Preload** is how far the arm stays bent in the loosest hole (Ø29, 3 mm wall).
- **Strain** is the arm root strain when squeezed through a 24 mm hole.

| Variant | Arm | Slope | Preload | Barb tip Ø | Arm top | Strain |
|---|---|---|---|---|---|---|
| A (baseline) | 1.0 mm | 0.25 | 0.5 mm | 33.3 mm | 15.7 mm | 1.8% |
| B (stiffer) | 1.2 mm | 0.25 | 0.5 mm | 33.3 mm | 15.5 mm | 2.2% |
| C (steeper) | 1.0 mm | 0.40 | 0.5 mm | 35.2 mm | 16.9 mm | 2.2% |
| D (firmer) | 1.0 mm | 0.25 | 1.0 mm | 34.3 mm | 16.3 mm | 2.0% |

C's arms are too tall for the current full-holder board height. It is here only
to test the steeper barb.

## Print settings

Ender 3 Pro, 0.4 mm nozzle. Flange or flat side down, no supports.

- **Filament:** PETG, dried.
- **Nozzle:** 230 - 240 °C, not above 240 (the stock hotend has a PTFE liner).
- **Bed:** 70 - 80 °C, with glue stick as a release on PEI or glass.
- **Layer height:** 0.16 - 0.2 mm.
- **Line width:** 0.5 mm, so A/C/D's 1.0 mm arms print as exactly 2 solid
  outlines. 0.4 mm suits B's 1.2 mm arms. Check the layer preview: there should
  be no zig-zag gap fill inside the arms.
- **Walls and infill:** 3 - 4 walls, infill 40% or more.
- **Seam position:** back or aligned, not random.
- **Fan:** 30 - 50%.
- **Adhesion:** skirt, or an outside-only brim. A brim inside the ring can fuse
  the arms to the flange.
- **Elephant's foot compensation:** about 0.2 mm, if available.

## Results

(Filament, slicer and settings used; measured test ring bores; for each variant:
insertion, flange seating, grip in Ø29 x 3, creep after a day in Ø24 x 9, 20
insert/remove cycles, real houses tried. Which variant won.)
