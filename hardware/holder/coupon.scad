// Test coupon v0.2: clip-ring sizing + full connector/cable-cleat verification
// in one compact 2x2 cluster (~80 x 85 mm, centered in the flat middle of the
// Ender 3 Pro bed). Print flange down in PETG, no supports.
//
//   S (front-left):  Clip ring only, Ø27.3 crown, for Ø25.0 - 26.5 mm holes
//   L (front-right): Clip ring only, Ø29.2 crown, for Ø26.5 - 28.3 mm holes
//   M (back-left):   Full v0.2 holder (Ø28.7 universal-candidate crown +
//                    2-fixed/1-latch PCB seat + blind-mate J1/J2 guide cheeks +
//                    dual south serpentine cable cleats)
//   Mock PCB (back-right): Ø20.0 x 1.6 mm gauge disk with "stacked" J1/J2
//                    through-holes (Ø1.20 nominal for ~Ø1.0 printed slip fit
//                    on loose sample headers) to test snap-in, blind mating,
//                    finger unplugging, and cable tug relief right off the bed.

use <clip.scad>
use <holder.scad>
include <params.scad>

pitch_x = flange_od + 8;   // 42 mm
pitch_y = flange_od + 11;  // 45 mm (clears south pull-tabs)

// Mock PCB disk seated on Z = -flange_t so all coupon parts share one bed plane.
module mock_pcb_disk() {
    translate([0, 0, -flange_t]) {
        difference() {
            cylinder(d = pcb_d - 0.05, h = pcb_t);
            // "stacked" J1 and J2 1x3 pin holes (Ø1.22 nominal -> ~Ø0.95-1.05
            // as-printed for press-fitting sample 0.64 mm square pins).
            for (ry = [j1_y, j2_y], dx = [-2.54, 0, 2.54])
                translate([dx, ry, -0.5])
                    cylinder(d = 1.22, h = pcb_t + 1);
            // South (-Y) orientation notch + "S" tick on top face.
            translate([0, -pcb_d / 2, -0.5])
                cylinder(d = 2.0, h = pcb_t + 1);
            translate([0, -6.6, pcb_t - 0.4])
                linear_extrude(1)
                    text("v0.2", size = 2.4, font = "Liberation Sans:style=Bold",
                         halign = "center", valign = "center");
        }
    }
}

// Front row: clip-only rings S (with cleats too, to compare) and L.
clip_ring(w = arm_w, rc = crown_r_s, label = "S", with_tab = true, with_cleats = false);
translate([pitch_x, 0, 0])
    clip_ring(w = arm_w, rc = crown_r_l, label = "L", with_tab = true, with_cleats = false);

// Back row: full holder M + mock PCB disk.
translate([0, pitch_y, 0])
    holder(w = arm_w, rc = crown_r_m, label = "M");
translate([pitch_x, pitch_y - 2, 0])
    mock_pcb_disk();
