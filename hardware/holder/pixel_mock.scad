// Mock-up of a Pixel PCB v0.1 with both servo plugs mated, for clearance
// checks only (not printed). Part outlines are the KiCad courtyards from
// hardware/pixel/pixel.kicad_pcb, flipped into model coordinates (Y = -KiCad Y).
// Plug and cable sizes are SPECULATIVE (see params.scad).

include <params.scad>

// [x0, y0, x1, y1, height] in KiCad coordinates relative to board center.
top_parts = [
    [-2.65, 3.55, 3.25, 9.05, led_h],   // D3
    [-8.15, -1.15, -2.65, 4.75, led_h], // D4
    [2.85, -2.35, 8.35, 3.55, led_h],   // D2
    [-2.15, -3.30, 1.85, 0.50, 1.2],    // U1
    [-1.93, -8.50, 1.93, -5.10, 1.1],   // D1
    [-6.17, -7.03, -5.23, -5.17, 0.5],  // R2
    [1.89, -3.19, 2.81, -1.37, 0.5],    // C1
    [2.12, -6.93, 5.08, -5.47, 0.8],    // C2
    [-5.08, -6.93, -2.12, -5.47, 0.6],  // R1
    [1.43, 0.57, 2.37, 2.43, 0.5],      // R3
    [-4.03, -3.07, -2.17, -2.13, 0.5],  // R4
];

module kicad_box(b, z0) {
    translate([b[0], -b[3], z0]) cube([b[2] - b[0], b[3] - b[1], b[4]]);
}

module pixel_mock() {
    // Board.
    color("darkgreen") translate([0, 0, pcb_bot]) cylinder(d = pcb_d, h = pcb_t);
    // Top-side parts.
    color("white") for (b = top_parts) kicad_box(b, pcb_top);
    // Header pin tails poking through on the LED side (~1.5 mm).
    color("gold") for (x = [j1_x - 2.54, j1_x, j1_x + 2.54, j2_x - 2.54, j2_x, j2_x + 2.54])
        translate([x - 0.32, row_y - 0.32, pcb_top]) cube([0.64, 0.64, 1.5]);

    z_hdr = pcb_bot - hdr_t;
    // J1 (male) body, then its pins running south.
    color("black") translate([j1_x - j1_body_w / 2, row_y - j1_face, z_hdr])
        cube([j1_body_w, j1_face + hdr_back, hdr_t]);
    // J2 (female) body.
    color("black") translate([j2_x - j2_body_w / 2, row_y - j2_face, z_hdr])
        cube([j2_body_w, j2_face + hdr_back, hdr_t]);

    // Plugs (speculative): female plug onto J1, male plug into J2.
    z_plug = pcb_bot - plug_t;
    color("dimgray") {
        translate([j1_x - plug_w / 2, row_y - j1_face - plug_l, z_plug])
            cube([plug_w, plug_l, plug_t]);
        translate([j2_x - plug_w / 2, row_y - j2_face - plug_l, z_plug])
            cube([plug_w, plug_l, plug_t]);
    }
    // Cable stubs.
    color("red") for (p = [[j1_x, row_y - j1_face - plug_l], [j2_x, row_y - j2_face - plug_l]])
        translate([p[0] - cable_w / 2, -45, pcb_bot - plug_t / 2 - cable_t / 2])
            cube([cable_w, p[1] + 45, cable_t]);
}

pixel_mock();
