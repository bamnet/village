// Mock-up of a Pixel PCB v0.1 fitted with vertical headers and both servo
// plugs mated, for clearance checks only (not printed). Part outlines are the
// KiCad courtyards from hardware/pixel/pixel.kicad_pcb, flipped into model
// coordinates (Y = -KiCad Y). Header, plug and cable sizes are partly
// SPECULATIVE (see params.scad).

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

module hanging_box(x, w, t, z_top, h) {
    translate([x - w / 2, row_y - t / 2, z_top - h]) cube([w, t, h]);
}

module pixel_mock() {
    // Board.
    color("darkgreen") translate([0, 0, pcb_bot]) cylinder(d = pcb_d, h = pcb_t);
    // Top-side parts.
    color("white") for (b = top_parts) kicad_box(b, pcb_top);
    // Header pin tails poking through on the LED side (~1.5 mm).
    color("gold") for (x = [j1_x - 2.54, j1_x, j1_x + 2.54, j2_x - 2.54, j2_x, j2_x + 2.54])
        translate([x - 0.32, row_y - 0.32, pcb_top]) cube([0.64, 0.64, 1.5]);
    // Header bodies.
    color("black") {
        hanging_box(j1_x, j1_body_w, hdr_t, pcb_bot, j1_body_h);
        hanging_box(j2_x, j2_body_w, hdr_t, pcb_bot, j2_body_h);
    }
    // Plugs: female onto J1's pins, male into J2's socket.
    color("dimgray") {
        hanging_box(j1_x, plug_w, plug_t, pcb_bot - j1_body_h, plug_l);
        hanging_box(j2_x, plug_w, plug_t, pcb_bot - j2_body_h, plug_l);
    }
    // Cables: straight down out of each plug, then bent outward under the
    // flange toward 270 degrees.
    color("red") for (p = [[j1_x, j1_stack], [j2_x, j2_stack]]) {
        z_end = pcb_bot - p[1];
        hanging_box(p[0], cable_w, cable_t, z_end, z_end + flange_t + 2 + cable_t);
        translate([p[0] - cable_w / 2, -40, -flange_t - 2 - cable_t])
            cube([cable_w, 40 + row_y, cable_t]);
    }
}

pixel_mock();
