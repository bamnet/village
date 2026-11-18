// Mock-up of a Pixel PCB v0.2 fitted with vertical headers and both servo
// plugs mated, for clearance checks only (not printed). Part outlines come
// from `hardware/pixel/pixel.kicad_pcb` (PR #17), flipped into holder model
// coordinates (`Y = -KiCad_Y`). For the three 5x5 mm LEDs (D2-D4), both the
// 5.0 x 5.0 x 1.6 mm package body and the low-profile pad/lead courtyard
// (~0.35 mm) are modeled so 3D lip clearances match physical reality.

include <params.scad>

// [x0, y0, x1, y1, height] in KiCad coordinates relative to board center (100, 100).
top_parts = [
    // 5.0 x 5.0 x 1.6 mm LED bodies (F.Fab) + 0.35 mm pad/lead envelopes (F.CrtYd)
    [-2.50, -8.90,  2.50, -3.90, led_h], // D2 (north) body, r_max 9.24
    [-2.95, -9.15,  2.95, -3.65, 0.35],  // D2 pads/leads
    [ 3.90, -2.50,  8.90,  2.50, led_h], // D3 (east) body, r_max 9.24
    [ 3.65, -2.95,  9.15,  2.95, 0.35],  // D3 pads/leads
    [-2.50,  4.25,  2.50,  9.25, led_h], // D4 (south) body, r_max 9.58 (in open mouth)
    [-2.95,  4.00,  2.95,  9.50, 0.35],  // D4 pads/leads
    // Remaining SMT parts (full KiCad F.CrtYd courtyards)
    [-9.03, -2.00, -5.23,  2.00, 1.2],   // U1 (WS2814F)
    [-6.40, -7.03, -3.00, -3.17, 1.1],   // D1 (BAT54S)
    [-7.28,  3.32, -4.32,  4.78, 0.6],   // R1 (2.7k)
    [-7.37, -5.93, -6.43, -4.07, 0.5],   // R2 (4.7k)
    [-7.13, -2.97, -5.27, -2.03, 0.5],   // R3 (100)
    [-4.88,  7.13, -3.02,  8.07, 0.5],   // R4 (120)
    [-8.16, -4.01, -7.24, -2.19, 0.5],   // C1 (100n)
    [-6.48,  5.17, -3.52,  6.63, 0.8],   // C2 (1u 50V)
];

module kicad_box(b, z0) {
    translate([b[0], -b[3], z0]) cube([b[2] - b[0], b[3] - b[1], b[4]]);
}

module hanging_box(x, y, w, t, z_top, h) {
    translate([x - w / 2, y - t / 2, z_top - h]) cube([w, t, h]);
}

// Board, top-side parts and the pin tails on the LED side (~1.5 mm).
module mock_board() {
    color("darkgreen") translate([0, 0, pcb_bot]) cylinder(d = pcb_d, h = pcb_t);
    color("white") for (b = top_parts) kicad_box(b, pcb_top);
    color("gold") for (p = [[j1_x, j1_y], [j2_x, j2_y]], dx = [-2.54, 0, 2.54])
        translate([p[0] + dx - 0.32, p[1] - 0.32, pcb_top]) cube([0.64, 0.64, 1.5]);
}

module mock_headers() {
    color("black") {
        hanging_box(j1_x, j1_y, j1_body_w, hdr_t, pcb_bot, j1_body_h);
        hanging_box(j2_x, j2_y, j2_body_w, hdr_t, pcb_bot, j2_body_h);
    }
}

// Female plug on J1's pins.
module j1_plug() {
    color("dimgray") hanging_box(j1_x, j1_y, pf_w, pf_t, pcb_bot - j1_body_h, pf_l);
}

// Male plug's sleeve over J2's socket.
module j2_plug() {
    j2_mouth = pcb_bot - max(0, j2_body_h - pm_engage);
    color("dimgray") {
        hanging_box(j2_x + pm_dx_sign * pm_dx, j2_y, pm_w, pm_t, j2_mouth, pm_sleeve_l);
        hanging_box(j2_x + pm_dx_sign * pm_dx, j2_y, pm_w, pm_neck_t, j2_mouth - pm_sleeve_l, pm_l - pm_sleeve_l);
    }
}

// Cables: straight down out of each plug, then bent outward under the flange
// toward 270 degrees (-Y).
module mock_cables() {
    color("red") for (p = [[j1_x, j1_y, j1_stack], [j2_x, j2_y, j2_stack]]) {
        z_end = pcb_bot - p[2];
        hanging_box(p[0], p[1], cable_w, cable_t, z_end, z_end + flange_t + 2 + cable_t);
        translate([p[0] - cable_w / 2, -40, -flange_t - 2 - cable_t])
            cube([cable_w, 40 + p[1], cable_t]);
    }
}

module pixel_mock() {
    mock_board();
    mock_headers();
    j1_plug();
    j2_plug();
    mock_cables();
}

pixel_mock();
