// Test coupon v0.3: single universal Ø29.0 mm holder with the sturdy XY-flexing
// curved PCB cradle jaws + unobstructed 2-curve south serpentine cleats, paired
// with the Mock PCB disk (~42 min / ~5.5 g print).
//
// Print flange down in PETG, no supports.

use <holder.scad>
include <params.scad>

// Mock PCB disk seated on Z = -flange_t so both parts share one bed plane.
module mock_pcb_disk() {
    translate([0, 0, -flange_t]) {
        difference() {
            cylinder(d = pcb_d - 0.05, h = pcb_t);
            // "stacked" J1 and J2 1x3 pin holes (Ø1.22 nominal -> press-fit for
            // sample 0.64 mm square pins).
            for (ry = [j1_y, j2_y], dx = [-2.54, 0, 2.54])
                translate([dx, ry, -0.5])
                    cylinder(d = 1.22, h = pcb_t + 1);
            // South (-Y) orientation notch + "v0.3" label on top face.
            translate([0, -pcb_d / 2, -0.5])
                cylinder(d = 2.0, h = pcb_t + 1);
            translate([0, -6.6, pcb_t - 0.4])
                linear_extrude(1)
                    text("v0.3", size = 2.4, font = "Liberation Sans:style=Bold",
                         halign = "center", valign = "center");
        }
    }
}

holder(w = arm_w, rc = crown_r_def, label = "U");
translate([34, -2, 0])
    mock_pcb_disk();
