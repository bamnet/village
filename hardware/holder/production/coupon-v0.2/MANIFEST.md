# House holder coupon v0.2: print package

Status: **ready to print** (rendered and sliced 2026-11-16). Do not change the
STLs once printed. A design change gets a new folder (`coupon-v0.3`, or
`holder-v0.1` for production holders).

Purpose: verify both (1) the gentle bore-friction clip sizing (`S`, `M`, `L`)
across the measured Ø25 - 28 mm house range and (2) the full v0.2 upper
connector/cable structure (2-fixed/1-latch PCB seat, blind-mate J1/J2 guide
cheeks, finger unplugging access, and tool-less south serpentine cable cleats)
in a single ~1.6 h print.

## Changes from coupon v0.1

1. **Bore-friction crown instead of a tall sloped overhang barb:** v0.1 coupled
   wall thickness (`3 - 9 mm`) to hole diameter (`Ø24 - 29 mm`) on a `0.25`
   ramp, pushing the barb tip out to `Ø33.3 - 35.2 mm` (`4.6 mm` deflection per
   side). v0.2 places a cylindrical bore-contact land inside `Z = 1.4 .. 4.4 mm`
   at `Ø27.3 - 29.2 mm` (`<= 1.85 mm` deflection). Its `45°` print underside
   finishes below `wall_min` (`3.0 mm`), so it never hooks behind a thin ceramic
   rim on removal.
2. **No arm-to-arm jamming:** `arm_ang` drops from `102°` to `72°`, opening the
   circumferential gap between each arm's tip and the next root from `6°` to
   `36°` (tip advance at Ø25 is `8.6 - 17.3°`).
3. **No arm twisting + softer arms:** arm tops drop from `15.7 - 16.9 mm` to
   `8.0 - 9.4 mm` so the `Z = 1.4 .. 4.4 mm` bore crown loads near the vertical
   center of the strip, and `arm_w` drops from `1.0 mm` to `0.84 mm` (two
   `0.42 mm` Arachne outlines, ~45% softer).
4. **Full connector, PCB latch, & tool-less cable cleat verification (`M` + Mock
   PCB):**
   - `pcb_bot` lowers from `20.3` to `16.0 mm` (LEDs at `19.2 mm`), leaving J2's
     plug protruding `2.9 mm` below the flange (`4.2 mm` with bore chamfer) and
     J1's housing open through the `Z = 8.2 .. 16.0 mm` side windows for easy
     two-finger annual unplugging.
   - Stepped C-shaped guide cheeks (`Z = -3.8 .. 8.2 mm`) funnel both plugs
     blind onto J1/J2 and mechanically block `1`-pin-offset (`2.54 mm`)
     mis-plugging.
   - Dual parallel serpentine (`S`-bend) channels in the south (`-Y`) pull-tab
     replace zip ties for 1-second tool-less strain relief.
   - Two fixed `45°`-roofed north posts + one `8.6 mm` tall south snap-latch
     cut PCB snap Z-layer strain from `4.5%` down to `< 1%`.

## Source

- Design commit: `26963ea` (branch `holder-v0.2`)
- Rendered 2026-11-16 with OpenSCAD 2021.01 from `hardware/holder/`:
  - `openscad -o production/coupon-v0.2/coupon.stl coupon.scad`
  - `openscad -o production/coupon-v0.2/test_rings.stl test_rings.scad`
- Sliced 2026-11-16 with PrusaSlicer 2.9.2 (Debian `prusa-slicer`):
  `slicer/slice.sh`.

## Files

| File | Contents | sha256 |
|---|---|---|
| `coupon.stl` | `2 x 2` cluster: clip rings `S` & `L`, full holder `M`, and `v0.2` Mock PCB disk | `0e1a01a7ecdacbb6ea51159fa1a038097c1e2fdd918acba252d0d596cb802022` |
| `test_rings.stl` | 4 compensated wall gauges (`+0.4 mm` bore comp): `25/4.5`, `26.5/4.5`, `28/4.5`, `26.5/8.1` | `e4281aad3508b33a15c845a1cc13fd825c1c7eb5bd6bd12819edde3bb3cb4e4f` |
| `coupon_PETG_0.2mm_E3PRO.gcode` | `coupon.stl` for the Ender 3 Pro, PETG. About 1 h 37 min, 11.1 g | `c38a2defcd80fb348c6935d99b20130d0d5f4d83a38085b209ce8bc3631192d3` |
| `test_rings_PETG_0.3mm_E3PRO.gcode` | `test_rings.stl` for the Ender 3 Pro, PETG. About 59 min, 12.4 g | `17b0c63921f6418adb3f90d2c52f98618e98a98694c7b3e65f4bcb1d4b593ec9` |
| `slicer/` | Flattened Creality presets, overrides, and `slice.sh` | |

Compare re-sliced G-code ignoring line 1's timestamp (`tail -n +2 FILE | sha256sum`):

- coupon: `e9703d99c4fac5a154bdc2d34011564718191640f9054b53f07edc8b68aba2a3`
- test rings: `9cda28ca8cc128debf10954902699464503f53927e555f831367eeb85b6f1271`

## Variants on `coupon.stl`

All three rings have 3 arms (`0.84 mm` thick, `72°` arc, `36°` tip-to-root gap)
and a `Ø34 x 3.8 mm` flange with a south (`-Y`) pull-tab reaching `y = -21.5 mm`.
Values are from OpenSCAD's echo output:

| Part | Type | Target holes | Crown OD | Crown Z band | Arm top | Tip adv @ Ø25 | Strain @ Ø25 |
|---|---|---|---|---|---|---|---|
| `S` (front-left) | Clip ring | Ø25.0 - 26.5 mm | 27.3 mm | 1.4 - 4.4 mm | 8.0 mm | 8.6° | 0.8% |
| `M` (back-left) | Full holder + cleats + chute | Ø25.0 - 28.3 mm (1-size test) | 28.7 mm | 2.1 - 4.4 mm | 9.0 mm | 14.8° | 1.3% |
| `L` (front-right) | Clip ring | Ø26.5 - 28.3 mm | 29.2 mm | 2.35 - 4.4 mm | 9.4 mm | 17.3° | 1.4% |
| `v0.2` disk (back-right) | Mock PCB (`Ø20.0 x 1.6 mm`) | `"stacked"` J1/J2 sample headers | — | — | — | — | — |

## Print settings

Same proven PETG setup as `coupon-v0.1` (Ender 3 Pro + BLTouch, `235 / 70 °C`,
`G29` bilinear bed probing with nozzle held at `160 °C`, glue stick release on
bed, no supports, no brim; run `../coupon-v0.1/pid_tune_hotend_235.gcode` first
only if hotend PID was reset), with two updates:

- **Line width `0.42 mm` (`Arachne`):** prints every `0.84 mm` flexing arm as
  two continuous outlines (`~0.44 mm`), verified in the G-code with zero gap
  fill and zero overhang perimeters (`Overhang = 0`).
- **Compact `2 x 2` bed layout (`80 x 85 mm`):** keeps all four parts in the
  flat center of the `228 x 228 mm` bed rather than a `154 mm` row.

## Test checklist

1. Measure the new printed `test_rings` bores (`25/4.5`, `26.5/4.5`, `28/4.5`,
   `26.5/8.1`) with calipers, and grab the existing `coupon-v0.1` `24x3`
   (`Ø24.0`) and `29x3` / `29x9` (`Ø28.3`) rings.
2. Push `S`, `M`, and `L` straight into the test rings and real houses:
   - check whether `M` pushes straight into `Ø25` comfortably while still
     holding `Ø28` (1-size solution), or whether `S` + `L` feels better.
3. Press-fit loose `1x3` male (`C492411` or straight `1x3`) and `8.5 mm` female
   (`C2897385` / vertical `1x3`) headers into the printed `v0.2` Mock PCB disk.
   Slide its north edge under Holder `M`'s two fixed slots (`south` notch
   toward the pull-tab) and click down past the south latch.
4. Plug both servo extension cables in from underneath without looking (testing
   the stepped C-cheek funnel and 1-pin-offset block), press both flat ribbons
   edgewise into the south serpentine cleats, tug-test the cables, check fit in
   a bottom-lit house's `12 mm` recess, and practice two-finger unplugging.

## Results

*(Record measured bores, fit, and connector/cleat notes here after printing.)*
