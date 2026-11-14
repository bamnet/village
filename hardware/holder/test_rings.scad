// Test rings: stand-ins for a house wall at the four corners of the range
// the holder must fit (hole_min/hole_max x wall_min/wall_max).
//
// Printed holes usually come out a little small, so measure each bore with
// calipers and write the real size on the ring before testing.

include <params.scad>

ring_od = 44;

module test_ring(d, t) {
    difference() {
        cylinder(d = ring_od, h = t);
        translate([0, 0, -1]) cylinder(d = d, h = t + 2);
        // Label on the top face: "<hole> / <wall>".
        translate([0, (ring_od + d) / 4, t - 0.4])
            linear_extrude(1)
                text(str(d, "/", t), size = 3.2, font = "Liberation Sans:style=Bold",
                     halign = "center", valign = "center");
    }
}

pitch = ring_od + 4;
test_ring(hole_min, wall_min);
translate([pitch, 0]) test_ring(hole_min, wall_max);
translate([0, pitch]) test_ring(hole_max, wall_min);
translate([pitch, pitch]) test_ring(hole_max, wall_max);
