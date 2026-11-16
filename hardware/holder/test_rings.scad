// Test rings (v0.2): wall stand-ins covering the measured house bore range
// (Ø25.0, Ø26.5, Ø28.0 mm) at thin (4.5 mm) and thick (8.1 mm) walls.
// Both heights are exact multiples of 0.3 mm layers.
//
// Coupon v0.1 showed PETG bores printing 0 - 0.75 mm small (~0.4 mm typical on
// Ø28-29). `bore_comp` enlarges the STL hole by +0.4 mm so printed bores land
// close to target; still measure every printed bore with calipers before use.

include <params.scad>

ring_od   = 40;
bore_comp = 0.4; // +0.4 mm diameter compensation for inward PETG bore shrinkage

module test_ring(d_nom, t) {
    d_cut = d_nom + bore_comp;
    difference() {
        cylinder(d = ring_od, h = t);
        translate([0, 0, -1]) cylinder(d = d_cut, h = t + 2);
        // Label on top face: nominal "<hole>/<wall>".
        translate([0, (ring_od + d_cut) / 4, t - 0.45])
            linear_extrude(1)
                text(str(d_nom, "/", t), size = 2.8,
                     font = "Liberation Sans:style=Bold",
                     halign = "center", valign = "center");
    }
}

pitch = ring_od + 4;
test_ring(hole_min, 4.5);                        // 25 / 4.5
translate([pitch, 0]) test_ring(hole_mid, 4.5);  // 26.5 / 4.5
translate([0, pitch]) test_ring(hole_max, 4.5);  // 28 / 4.5
translate([pitch, pitch]) test_ring(hole_mid, 8.1); // 26.5 / 8.1
