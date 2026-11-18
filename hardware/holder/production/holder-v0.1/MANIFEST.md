# House holder v0.1: production print package

Status: **ready to print** (rendered and sliced 2026-11-18). Do not change the
STL once printed. Any design change bumps the engraved flange version (`"v0.2"`)
and gets a new folder.

Purpose: production house holders matching the ordered **Pixel PCB v0.2**
(`hardware/pixel/production/v0.2/`). Six `4x` batch runs (`24` holders, ~`125 g`
PETG total) cover the 22-house system plus 2 spares; print `1x` first to
spot-check the shortened south tab and shifted plug guide cheeks.

## Summary of settled geometry

- **Clip ring:** universal `Ø29.0 mm` cylindrical bore-contact crown (`Z = 2.25
  .. 4.4 mm`, `34°` insertion ramp, `arm_top = 9.23 mm`) on three `0.84 mm` x
  `66°` XY-flexing arms (`40°` gap centered at `250 .. 290°` south). Proven
  across `Ø25 - 28 mm` Department 56 houses in `coupon-v0.2` and `coupon-v0.3`.
- **Upper PCB cradle:** two wide `88°` curved `C`-jaws (`~2.35 mm` / 5-perimeter
  radial wall, `hook_r = 9.52 mm`) rising smoothly from `37°` solid pillars. The
  soldered Pixel PCB v0.2 slides horizontally into the `-Y` south mouth at `Z =
  16.0 mm` (LED tops at `19.2 mm`), flexing the jaws `~0.15 mm/side` in the XY
  plane (`0%` Z-layer bending strain).
- **Blind-mate `J1`/`J2` guide cheeks:** shifted `(-1.20, -0.45 mm)` in holder
  coordinates (`J1` at `(-1.20, +1.650)`, `J2` at `(-1.20, -1.975)`, `pm_dx_sign
  = +1` with `J2` `DATA_OUT` east) to match the ordered Pixel PCB v0.2 layout,
  stopping at `Z = 7.1 mm` (`0.4 mm` below bare soldered headers) so the board
  slides in horizontally and mating either servo plug pins PCB + holder
  together.
- **South (`-Y`) serpentine cable cleats:** shortened `2.7 mm` from
  `coupon-v0.3` (`tab_y_end = -21.5 mm`, `tab_x_spread = 4.8 mm`) so the outer
  tab clears Yankee Candle's bottom recess edge cleanly while retaining `1.30`
  full `S`-waves (`y = -12.0 .. -21.9 mm`, `1.68 mm` slot width) with a flared
  bore entry horn (`y = -11.0 mm`).
- **Version mark:** `"v0.1"` engraved on the wall-facing (`+Y`) flange face.

## Source

- Design commit: `e8e7b86` (branch `holder-pixel-v0.2-offset`)
- Rendered 2026-11-18 with OpenSCAD 2021.01 from `hardware/holder/`:
  - `openscad -o production/holder-v0.1/holder.stl holder.scad`
- Sliced 2026-11-18 with PrusaSlicer 2.9.2 (`slicer/slice.sh`).

## Files

| File | Contents | sha256 |
|---|---|---|
| `holder.stl` | Single production holder (`"v0.1"` engraved on `+Y` flange face) | `f5ec0543c227fc2fc3a2e55278af89d949b9d94b08e31edc96e2a5817307ca10` |
| `holder_1x_PETG_0.2mm_E3PRO.gcode` | `1x` centered holder for Ender 3 Pro, PETG. About 55 min, 5.3 g | `6c9da69da20bbb60cf98295075082d7e72f9e8ac4dbf7becfd9208142225513f` |
| `holder_4x_PETG_0.2mm_E3PRO.gcode` | `4x` (`2 x 2`, `73 x 82 mm` centered) batch plate for Ender 3 Pro, PETG. About 3 h 21 min, 20.8 g | `c18fd30ea29fb627d5b0902621ff9ef1a529b7b848bf0be0041b6961d770526e` |
| `slicer/` | Flattened Creality presets, overrides, and `slice.sh` | |

Compare re-sliced G-code ignoring line 1's timestamp (`tail -n +2 FILE | sha256sum`):

- `1x`: `f828cb858cf8cafac3425719b4ed80b7cb4f8ce77c8e95bbda54a63709aee022`
- `4x`: `e91de7257a824abf5e9bb897657be5088dd4bdcf30bc734bc624e89249b9066e`

## Print settings & checks

- Same proven Ender 3 Pro + BLTouch PETG setup (`235 / 70 °C`, `G29` bilinear
  probing at `160 °C` nozzle, `0.42 mm` Arachne lines, glue stick release on
  bed, no supports, no brim).
- OpenSCAD 2021.01 `assembly.scad` checks against Pixel PCB v0.2 (`holder_mock`,
  `sweep_mock`, `plugs`): all `Current top level object is empty.` (`0 mm³`).
- PrusaSlicer 2.9.2: zero warnings, `Overhang = 0`, `Gap fill = 0` on flexing
  arms, `gcode_flavor = marlin`, `bed_shape = 3x3,228x3,228x228,3x228`.

## Print log

*(Record spot-check and batch print notes here.)*
