# House holder coupon v0.3: print package

Status: **ready to print** (rendered and sliced 2026-11-16). Do not change the
STLs once printed. If this passes, the holder STL becomes the production
design (`holder-v0.1`).

Purpose: verify the strengthened upper curved `C`-cradle jaws, horizontal XY
PCB slide-in, and unobstructed full-wave south serpentine cable cleats on a
single universal (`Ø29.0 mm`) holder (`1 h 02 min`, `6.2 g`).

## Changes from coupon v0.2

1. **Wide, thick XY-flexing curved `C`-jaws instead of 3 narrow Z-posts:**
   - Coupon v0.2's three `2.2 x 1.0 - 1.2 mm` posts above `Z = 9 mm` starved
     under `5 mm` Bowden PETG retractions (`~0.3 s` island loops) and snapped at
     the `Z = 9 mm` step.
   - v0.3 replaces them with two wide `88°` curved `C`-jaws (`-12 .. +76°` and
     `+104 .. +192°`, `~2.35 mm` radial wall = 5 continuous perimeters) rising
     smoothly from `37°` solid pillars (`26.5 .. 63.5°` and `146.5 .. 183.5°`)
     fused directly into the flange and `C`-cheeks.
   - Because both jaws wrap `12°` past the X equator (`19.76 mm` mouth chord
     for the `Ø20.05 mm` PCB), sliding the PCB horizontally into the wide-open
     south (`-Y`) mouth flexes the jaws `~0.15 mm/side` **in the XY plane along
     continuous filament loops** (`0%` Z-layer bending strain) until it clicks
     into the `Ø20.20 mm` seat.
   - `guide_top_z` lowers from `8.2` to `7.1 mm` (`0.4 mm` below the bare
     soldered `Z = 7.5 mm` headers) so a soldered PCB slides horizontally in
     from `-Y`; mating either servo plug then pins the PCB across `Z = 7.1 ..
     16.0 mm`.
2. **Unobstructed full-wave south `S`-cleats:**
   - `arm_rot` shifts from `22°` to `50°` (`arm_ang = 66°`, `gap = 40°`),
     centering the `250 .. 290°` open gap directly on `-Y` south so no root or
     arm sits behind the cleats.
   - Both channels now start at `y = -11.0 mm` (breaking cleanly through into
     the central bore via a flared entry horn, subtracted at the top level of
     `holder.scad`) and run to `y = -24.6 mm` (`tab_y_end = -24.2 mm`), so the
     cable enters horizontally with zero blocking wall and engages both curves
     fully.
3. **Single universal `Ø29.0 mm` bore crown (`crown_r_u = 14.50`):**
   - Coupon v0.2 showed both `M` (`Ø28.7`) and `L` (`Ø29.2`) fit all tested
     houses from `Ø25` to `Ø28`; `Ø29.0 mm` splits the difference for confident
     `Ø28` grip and easy `Ø25` insertion (`S` and `L` remain in `params.scad`
     for outliers).

## Source

- Design commit: `eba1cdc` (branch `holder-v0.3`)
- Rendered 2026-11-16 with OpenSCAD 2021.01 from `hardware/holder/`:
  - `openscad -o production/coupon-v0.3/coupon.stl coupon.scad`
- Sliced 2026-11-16 with PrusaSlicer 2.9.2 (`slicer/slice.sh`).

## Files

| File | Contents | sha256 |
|---|---|---|
| `coupon.stl` | Universal holder `U` (`Ø29.0` crown) + `v0.3` Mock PCB disk (`Ø20.0 x 1.6 mm`) | `c1db587993d2ff63c7324cddb6fb8b1f035eefc33c28b9d27689e0d5a758e004` |
| `coupon_PETG_0.2mm_E3PRO.gcode` | `coupon.stl` for the Ender 3 Pro, PETG (`235 / 70 °C`, `G29` BLTouch). About 1 h 02 min, 6.2 g | `5c4f85353c25bea40c3f639fc1452ca0db9ff37a78568c72d5bb29ca8c0ea9ce` |
| `slicer/` | Flattened Creality presets, overrides, and `slice.sh` | |

Compare re-sliced G-code ignoring line 1's timestamp (`tail -n +2 FILE | sha256sum`):

- coupon: `7657d07fbc381eaaba236c7379e0257f6e380165d6948fa9e5cddfa953e9404b`

## Checks

- OpenSCAD 2021.01 `assembly.scad`: `holder_mock` (`pm_dx_sign = ±1`),
  `sweep_mock` (including guide cheeks and `37°` cradle pillars at `Ø24.5 mm`),
  and `plugs` all report `Current top level object is empty.` (`0 mm³`).
- PrusaSlicer 2.9.2: zero warnings, `Overhang = 0`, `Gap fill = 0`, 2 connected
  mesh components (`558.6 mm²` and `305.4 mm²` bed contact), `gcode_flavor =
  marlin`, `bed_shape = 3x3,228x3,228x228,3x228`, `G29` BLTouch bed probing at
  `160 °C`, `235 °C` print nozzle.

## Test checklist

1. Confirm the upper `C`-jaws print cleanly with no retraction starvation and
   feel rigid in hand.
2. Press-fit sample `1x3` vertical headers (`C492411`, `C2897385`) into the
   `v0.3` Mock PCB disk and slide it horizontally into Holder `U`'s open south
   (`-Y`) mouth until it clicks past the jaw tips.
3. Plug both servo cables in from underneath through the `C`-cheeks (confirming
   blind alignment and that the mated plugs pin the Mock PCB in place).
4. Press both `4.0 x 1.4 mm` flat cables edgewise into the south `S`-cleats from
   the bore all the way out the south tip (confirming both curves engage cleanly
   with no inner wall blocking them) and tug-test.
5. Seat the loaded holder + cables into **Yankee Candle** (`12 mm` recess) and
   **Partridge & Pear** (`Ø28 x 3 mm`), checking table flatness and two-finger
   unplugging (`J2` first from underneath, then `J1` through the open front/back
   windows).

## Results

*(Record bench and house results here after printing.)*
