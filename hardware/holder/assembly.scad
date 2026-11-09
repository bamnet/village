// Assembly view: clip ring + carrier + Pixel PCB mock, installed in a wall
// section. Set `hole` and `wall` to try the corners of the range.
//
// `check` renders the overlap between two parts instead. Each overlap should
// come out empty (OpenSCAD reports "Current top level object is empty."):
//   openscad -o /dev/null -D 'check="clip_carrier"' assembly.scad
// Values: "clip_carrier", "clip_mock", "carrier_mock".

use <clip.scad>
use <carrier.scad>
use <pixel_mock.scad>
include <params.scad>

hole = 26;
wall = 5;
check = "";
cutaway = true;   // slice away the +X half to see inside

module wall_section() {
    difference() {
        translate([-30, -35, 0]) cube([60, 60, wall]);
        translate([0, 0, -1]) cylinder(d = hole, h = wall + 2);
    }
}

module scene() {
    color("teal") clip_ring();
    color("orange") carrier();
    pixel_mock();
    %wall_section();
}

if (check == "clip_carrier") intersection() { clip_ring(); carrier(); }
else if (check == "clip_mock") intersection() { clip_ring(); pixel_mock(); }
else if (check == "carrier_mock") intersection() { carrier(); pixel_mock(); }
else if (cutaway) difference() { scene(); translate([0, -60, -40]) cube([60, 120, 80]); }
else scene();
