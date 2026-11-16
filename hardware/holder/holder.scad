// House holder (v0.3), vertical-header layout. One printed piece, no supports.
//
// Replaces coupon v0.2's three fragile 2.2 x 1.0 mm posts (which starved under
// Bowden PETG retractions and snapped across Z-layer lines) with two wide,
// thick curved C-cradle jaws (`-12..+76` East-North and `+104..+192` West-North,
// ~2.35 mm radial wall) rising continuously from wide solid pillars (`26.5..63.5`
// and `146.5..183.5`) fused directly into the C-guide cheeks.
//
// - The PCB (with soldered vertical headers) slides horizontally into the open
//   south (-Y) mouth at Z = 16.0 mm. Because the jaws wrap 12 deg past the X
//   equator (`mouth chord = 19.76 mm` for the Ø20.05 mm PCB), the jaws flex
//   ~0.15 mm/side purely in the XY plane along continuous filament loops (0%
//   Z-layer strain) to click around the PCB's equator into the Ø20.20 mm seat
//   with zero resting interference. Mating the plugs across Z = 7.1..16.0 pins
//   the PCB in place.
// - Both south serpentine cable cleats open directly into the 250..290 deg arm
//   gap with zero inner wall blocking the cables.

use <clip.scad>
include <params.scad>

// Radial cross-section of a curved C-jaw wall from `z_base` up past the PCB,
// including the 45 deg bottom PCB ledge (`ledge_r`) and 45 deg self-supporting
// upper capture lip (`hook_r`, zero flat overhang).
module jaw_profile_2d(z_base) {
    r_pcb = pcb_d / 2;
    slot_clear = 0.20;
    z_ledge_bot  = pcb_bot - (jaw_r_pocket - ledge_r);
    zb           = min(z_base, z_ledge_bot - 0.15);
    z_roof_outer = (pcb_top + slot_clear) - (jaw_r_pocket - r_pcb);
    z_roof_inner = (pcb_top + slot_clear) + (r_pcb - hook_r);
    z_top        = z_roof_inner + 0.55;

    polygon([
        [jaw_r_pocket, zb],
        [jaw_r_out,    zb],
        [jaw_r_out,    z_top],
        [hook_r,       z_top],
        [hook_r,       z_roof_inner],
        [jaw_r_pocket, z_roof_outer],
        [jaw_r_pocket, pcb_bot],
        [ledge_r,      pcb_bot],
        [jaw_r_pocket, z_ledge_bot],
    ]);
}

// One wide structural pillar (`ang_p0 .. ang_p1`, running all the way from the
// print bed `Z = -flange_t`) that corbels smoothly outward above `z_corbel`
// into the wide C-jaw (`ang_j0 .. ang_j1`).
module curved_cradle_jaw(ang_p0, ang_p1, ang_j0, ang_j1, top) {
    z_corbel = top + 0.75; // >= 0.75 mm clean air gap above flexing clip arms
    z_ledge_bot = pcb_bot - (jaw_r_pocket - ledge_r);
    max_span = max(ang_p0 - ang_j0, ang_j1 - ang_p1);
    deg_per_mm = max_span / (z_ledge_bot - 0.20 - z_corbel);
    slices = 32;

    union() {
        // 1. Solid base pillar from bed (`-flange_t`) up to `pcb_bot`, fused
        //    into the flange at Z <= 0 and thickened inward to `pillar_r_in`.
        rotate(ang_p0)
            rotate_extrude(angle = ang_p1 - ang_p0) {
                translate([pillar_r_in, -flange_t])
                    square([flange_id / 2 + 2.0 - pillar_r_in, flange_t]);
                polygon([
                    [pillar_r_in, -0.02],
                    [arm_r_out(arm_w), -0.02],
                    [arm_r_out(arm_w), z_corbel + 0.05],
                    [jaw_r_out, z_corbel + (jaw_r_out - arm_r_out(arm_w))],
                    [jaw_r_out, pcb_bot],
                    [ledge_r, pcb_bot],
                    [pillar_r_in, pcb_bot - (ledge_r - pillar_r_in)],
                ]);
            }

        // 2. Crisp concave PCB groove from `z_ledge_bot - 0.15` up past the PCB
        //    (single `rotate_extrude`, never `hull()`ed so the slot stays open).
        rotate(ang_j0)
            rotate_extrude(angle = ang_j1 - ang_j0)
                jaw_profile_2d(z_ledge_bot - 0.15);

        // 3. Smoothly hulled solid corbel arch underneath `z_ledge_bot` (pure
        //    rectangle `[jaw_r_pocket .. jaw_r_out]`, convex so `hull()` is exact!).
        for (s = [0 : slices - 1]) {
            a0 = ang_j0 + (ang_j1 - ang_j0) * s / slices;
            a1 = ang_j0 + (ang_j1 - ang_j0) * (s + 1) / slices;
            d0 = a0 < ang_p0 ? (ang_p0 - a0) : a0 > ang_p1 ? (a0 - ang_p1) : 0;
            d1 = a1 < ang_p0 ? (ang_p0 - a1) : a1 > ang_p1 ? (a1 - ang_p1) : 0;
            zb0 = min(z_ledge_bot - 0.15, z_corbel + d0 / deg_per_mm);
            zb1 = min(z_ledge_bot - 0.15, z_corbel + d1 / deg_per_mm);
            hull() {
                rotate(a0)
                    rotate_extrude(angle = 0.12)
                        translate([jaw_r_pocket, zb0])
                            square([jaw_r_out - jaw_r_pocket, z_ledge_bot - zb0]);
                rotate(a1 - 0.12)
                    rotate_extrude(angle = 0.12)
                        translate([jaw_r_pocket, zb1])
                            square([jaw_r_out - jaw_r_pocket, z_ledge_bot - zb1]);
            }
        }
    }
}

// 2D cross-section of the stepped J1/J2 inner plug pocket (validated smooth fit).
module plug_pocket_2d(extra = 0) {
    translate([-(guide_j1_hw + extra), 0])
        square([2 * (guide_j1_hw + extra), guide_y_n + extra]);
    translate([-(guide_j2_hw + extra), guide_y_s - extra])
        square([2 * (guide_j2_hw + extra), -guide_y_s + extra + 0.9]);
}

// Stepped C-shaped guide cheeks on +/-X, anchored broadly into the two wide
// pillars (`26.5..63.5` East-North-East and `146.5..183.5` West).
module plug_guide_cheeks() {
    h_tot = guide_top_z + flange_t;
    wall_t = 1.50;
    funnel_h = 0.65;

    difference() {
        translate([0, 0, -flange_t])
            linear_extrude(h_tot) {
                union() {
                    intersection() {
                        circle(r = 8.15);
                        difference() {
                            offset(r = wall_t) plug_pocket_2d(0);
                            translate([-guide_open_n, 0])
                                square([2 * guide_open_n, guide_y_n + 3]);
                            translate([-guide_open_s, guide_y_s - 3])
                                square([2 * guide_open_s, -guide_y_s + 3]);
                        }
                    }
                    // Thick anchor webs tying East cheek into Pillar E (`44 deg`)
                    // and West cheek into Pillar W (`172 deg`).
                    hull() {
                        rotate(44) translate([pillar_r_in + 0.5, 0]) circle(d = 3.2);
                        translate([guide_j1_hw + 0.70, guide_y_n + 0.45]) circle(d = 2.0);
                    }
                    hull() {
                        rotate(172) translate([pillar_r_in + 0.5, 0]) circle(d = 3.2);
                        translate([-(guide_j1_hw + 0.70), 1.2]) circle(d = 2.2);
                    }
                }
            }
        translate([0, 0, -flange_t - 0.1])
            linear_extrude(h_tot + 0.2)
                plug_pocket_2d(0);
        hull() {
            translate([0, 0, -flange_t - 0.05])
                linear_extrude(0.05) plug_pocket_2d(funnel_h);
            translate([0, 0, -flange_t + funnel_h])
                linear_extrude(0.05) plug_pocket_2d(0);
        }
    }
}

module holder(w = arm_w, rc = crown_r_def, label = "") {
    top = arm_top(w, rc);
    assert(top + 1.5 <= pcb_bot, "PCB sits too close to the arm tops");
    assert(pcb_top + led_h <= inside_max, "LEDs reach too far into the house");

    difference() {
        union() {
            clip_ring(w = w, rc = rc, label = label, with_tab = true, with_cleats = false);
            // East-North C-jaw: 37 deg solid pillar (`26.5..63.5`) fanning to `-12..+76`.
            curved_cradle_jaw(26.5, 63.5, -12, 76, top);
            // West-North C-jaw: 37 deg solid pillar (`146.5..183.5`) fanning to `+104..+192`.
            curved_cradle_jaw(146.5, 183.5, 104, 192, top);
            if (layout == "stacked")
                plug_guide_cheeks();
        }
        // Subtract south cable cleats at top level so nothing ever blocks them!
        south_cable_cleats();
    }

    echo(str("holder ", label, ": PCB bot z=", pcb_bot, ", LED tops z=", pcb_top + led_h,
             ", J1 plug end z=", pcb_bot - j1_stack,
             ", J2 plug end z=", pcb_bot - j2_stack));
}

holder();
