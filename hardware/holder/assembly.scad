// Assembly view: holder + Pixel PCB mock, installed in a wall section. Set
// `hole` and `wall` to try the corners of the range.
//
// `check` renders the overlap between two things instead. Each overlap should
// come out empty (OpenSCAD reports "Current top level object is empty."):
//   openscad -o /dev/null -D 'check="holder_mock"' assembly.scad
// Values:
//   "holder_mock" - the holder at rest against the board, headers, plugs, cables
//   "sweep_mock"  - the space the arms sweep through when squeezed through
//                   hole_min, against the same
//
// Note: the cables are drawn bent at a fixed spot under the flange, so cable
// overlaps there are a drawing artifact; the check below leaves them out.

use <holder.scad>
use <clip.scad>
use <pixel_mock.scad>
include <params.scad>

hole = 26;
wall = 5;
check = "";
cutaway = true;   // slice away the +X half to see inside

module wall_section() {
    difference() {
        translate([-30, -30, 0]) cube([60, 60, wall]);
        translate([0, 0, -1]) cylinder(d = hole, h = wall + 2);
    }
}

// The mock above the flange's underside (leaves out the drawn cable bends).
module mock_in_holder() {
    intersection() {
        pixel_mock();
        translate([-50, -50, -flange_t]) cube([100, 100, 60]);
    }
}

module scene() {
    color("teal") holder();
    pixel_mock();
    %wall_section();
}

if (check == "holder_mock") intersection() { holder(); mock_in_holder(); }
else if (check == "sweep_mock") intersection() { arm_sweep(); mock_in_holder(); }
else if (cutaway) difference() { scene(); translate([0, -60, -40]) cube([60, 120, 80]); }
else scene();
