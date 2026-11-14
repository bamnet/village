// Test coupon: four clip-ring variants on one plate, to pick the arm
// thickness and barb shape before designing the rest of the holder.
//
//   A: 1.0 mm arms, slope 0.25, 0.5 mm preload  - the baseline
//   B: 1.2 mm arms                              - stiffer, stronger grip
//   C: 1.0 mm arms, slope 0.4                   - more pull-in at thick walls
//   D: 1.0 mm arms, 1.0 mm preload (r3 15.5)    - firmer in the loosest hole
//
// "Preload" is how far the arm stays bent in the loosest hole
// (Ø29 x 3 mm wall). Print flange down in PETG, no supports. Test in the four
// rings from test_rings.scad, then in real houses (README test plan).

use <clip.scad>
include <params.scad>

pitch = flange_od + 6;

clip_ring(w = 1.0, k = 0.25, r3 = 15.0, label = "A");
translate([pitch, 0, 0]) clip_ring(w = 1.2, k = 0.25, r3 = 15.0, label = "B");
translate([2 * pitch, 0, 0]) clip_ring(w = 1.0, k = 0.40, r3 = 15.0, label = "C");
translate([3 * pitch, 0, 0]) clip_ring(w = 1.0, k = 0.25, r3 = 15.5, label = "D");
