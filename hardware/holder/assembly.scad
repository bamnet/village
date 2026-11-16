// Assembly view: holder + Pixel PCB mock, installed in a wall section. Set
// `hole` and `wall` to try the corners of the range.
//
// `check` renders the overlap between two things instead. Each overlap should
// come out empty (OpenSCAD reports "Current top level object is empty."):
//   openscad -o /dev/null -D 'check="holder_mock"' assembly.scad
// Values:
//   "holder_mock"  - holder at rest against board, headers, plugs, cables
//   "sweep_mock"   - space arms sweep through at hole_sweep against mock +
//                    guide cheeks
//   "plugs"        - the two mated plugs against each other

use <holder.scad>
use <clip.scad>
use <pixel_mock.scad>
include <params.scad>

hole    = 26.5;
wall    = 5;
rc_test = crown_r_def;
check   = "";
cutaway = true;   // slice away the +X half to see inside

module wall_section() {
    difference() {
        translate([-30, -30, 0]) cube([60, 60, wall]);
        translate([0, 0, -1]) cylinder(d = hole, h = wall + 2);
    }
}

// Mock above the flange's underside (leaves out the schematic cable bends
// drawn below the flange; shrink pcb_d by 0.02 mm so exact resting contact at
// pcb_bot / latch tip does not register as boolean volume).
module mock_in_holder() {
    intersection() {
        union() {
            color("darkgreen")
                translate([0, 0, pcb_bot + 0.01])
                    cylinder(d = pcb_d - 0.02, h = pcb_t - 0.02);
            // Top-side parts, pin tails, headers and plugs from pixel_mock.
            difference() {
                pixel_mock();
                translate([0, 0, pcb_bot - 0.05])
                    cylinder(d = pcb_d + 1, h = pcb_t + 0.1);
            }
        }
        translate([-50, -50, -flange_t]) cube([100, 100, 60]);
    }
}

module scene() {
    color("teal") holder(rc = rc_test);
    pixel_mock();
    %wall_section();
}

if (check == "holder_mock")
    intersection() { holder(rc = rc_test); mock_in_holder(); }
else if (check == "plugs")
    intersection() { j1_plug(); j2_plug(); }
else if (check == "sweep_mock")
    intersection() {
        arm_sweep(rc = rc_test);
        union() {
            mock_in_holder();
            if (layout == "stacked") plug_guide_cheeks();
            curved_cradle_jaw(26.5, 63.5, -12, 76, arm_top(arm_w, rc_test));
            curved_cradle_jaw(146.5, 183.5, 104, 192, arm_top(arm_w, rc_test));
        }
    }
else if (cutaway)
    difference() { scene(); translate([0, -60, -40]) cube([60, 120, 80]); }
else
    scene();
