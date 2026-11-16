// House holder (v0.2), vertical-header layout. One printed piece, no supports.
//
// - The clip ring (clip.scad) grips the lighting hole bore gently with short
//   XY-flexing arms (no overhang hook).
// - Three posts rise from the arm roots to hold the Pixel PCB at Z = 16 mm:
//   two fixed capture slots (angled 45 deg roofs, zero flat overhang) and one
//   longer south snap-latch (~8.6 mm flex beam, <1% Z-layer strain).
// - Two stepped C-shaped guide cheeks (anchored to Roots 0 and 1) funnel both
//   servo plugs blind onto J1 and J2 and mechanically block 1-pin-offset
//   plugging, while keeping Z = 8.2..16 mm open on the sides so fingers can
//   pinch J1's housing and J2's protruding tail directly to unplug.
// - Dual serpentine (S-bend) channels in the south (-Y) flange pull-tab lock
//   both flat servo cables tool-lessly against tugs (no zip ties).

use <clip.scad>
include <params.scad>

// Fixed capture post (Posts 0 and 1): PCB edge slides in at a slight angle
// under a 45 deg self-supporting roof (no flat overhang in PETG).
module fixed_post(top) {
    slot_clear = 0.20; // vertical slip clearance above pcb_top at r = pcb_d/2
    r_pcb = pcb_d / 2;
    // 45 deg roof passes through (r_pcb, pcb_top + slot_clear).
    z_roof_outer = (pcb_top + slot_clear) - (arm_r_in - r_pcb);
    z_roof_inner = (pcb_top + slot_clear) + (r_pcb - hook_r);
    rotate_extrude(angle = arm_root_ang) {
        // Stiff inward root buttress below the arm tops.
        translate([root_r_in, -flange_t])
            square([arm_r_in - root_r_in + 0.02, top + flange_t]);
        // Post wall up past the PCB.
        translate([arm_r_in, top - 0.02])
            square([post_w, z_roof_inner + 0.6 - top + 0.02]);
        // 45 deg ledge under the board's edge.
        polygon([
            [arm_r_in + 0.02, pcb_bot - (arm_r_in - ledge_r)],
            [arm_r_in + 0.02, pcb_bot],
            [ledge_r, pcb_bot],
        ]);
        // 45 deg upper capture lip (zero flat overhang).
        polygon([
            [arm_r_in + 0.02, z_roof_outer],
            [hook_r, z_roof_inner],
            [hook_r, z_roof_inner + 0.5],
            [arm_r_in + 0.02, z_roof_inner + 0.6],
        ]);
    }
}

// Flexible snap-latch post (Post 2, south): thinner 8.6 mm tall beam flexes
// outward (<1% Z-layer strain) as the PCB clicks down flat onto the ledge.
module latch_post(top) {
    r_pcb = pcb_d / 2;
    slot_clear = 0.08; // light snug fit on the snap latch
    z_bevel_outer = (pcb_top + slot_clear) - (arm_r_in + 0.02 - r_pcb);
    z_bevel_inner = (pcb_top + slot_clear) + (r_pcb - (hook_r + 0.05));
    rotate_extrude(angle = arm_root_ang) {
        translate([root_r_in, -flange_t])
            square([arm_r_in - root_r_in + 0.02, top + flange_t]);
        translate([arm_r_in, top - 0.02])
            square([latch_post_w, pcb_top + hook_t - top + 0.02]);
        // 45 deg ledge under the board's edge.
        polygon([
            [arm_r_in + 0.02, pcb_bot - (arm_r_in - ledge_r)],
            [arm_r_in + 0.02, pcb_bot],
            [ledge_r, pcb_bot],
        ]);
        // Snap hook with 45 deg underside bevel (printable) and top lead-in ramp.
        polygon([
            [arm_r_in + 0.02, z_bevel_outer],
            [hook_r + 0.05, z_bevel_inner],
            [hook_r + 0.05, z_bevel_inner + 0.20],
            [arm_r_in + 0.02, pcb_top + hook_t],
        ]);
    }
}

// 2D cross-section of the stepped J1/J2 inner plug pocket, expanded by `extra`
// (used for the bottom 45 deg entry funnel).
module plug_pocket_2d(extra = 0) {
    // J1 (+Y) pocket.
    translate([-(guide_j1_hw + extra), 0])
        square([2 * (guide_j1_hw + extra), guide_y_n + extra]);
    // J2 (-Y) pocket.
    translate([-(guide_j2_hw + extra), guide_y_s - extra])
        square([2 * (guide_j2_hw + extra), -guide_y_s + extra + 0.9]);
}

// Stepped C-shaped guide cheeks on +/-X, anchored into Roots 0 and 1.
module plug_guide_cheeks() {
    h_tot = guide_top_z + flange_t;
    wall_t = 1.50;   // thick enough that 0.65 mm bottom funnel leaves >=0.85 mm on Layer 1
    funnel_h = 0.65; // 45 deg bottom lead-in chamfer height

    difference() {
        translate([0, 0, -flange_t])
            linear_extrude(h_tot) {
                union() {
                    // Constant-thickness wall around plug_pocket_2d, clipped to
                    // r <= 8.15 mm so outer SW/SE corners stay clear of arm sweep.
                    intersection() {
                        circle(r = 8.15);
                        difference() {
                            offset(r = wall_t) plug_pocket_2d(0);
                            // Open +Y and -Y center windows for sightlines & cables.
                            translate([-guide_open_n, 0])
                                square([2 * guide_open_n, guide_y_n + 3]);
                            translate([-guide_open_s, guide_y_s - 3])
                                square([2 * guide_open_s, -guide_y_s + 3]);
                        }
                    }
                    // Anchor webs from the NE and NW corners into Roots 0 and 1.
                    for (ang = [arm_rot + arm_root_ang / 2,
                                arm_rot + 120 + arm_root_ang / 2])
                        hull() {
                            rotate(ang) translate([root_r_in + 0.4, 0]) circle(d = 2.4);
                            translate([sign(cos(ang)) * (guide_j1_hw + 0.70),
                                       guide_y_n + 0.50])
                                circle(d = 1.5);
                        }
                }
            }
        // Inner plug clearance pocket.
        translate([0, 0, -flange_t - 0.1])
            linear_extrude(h_tot + 0.2)
                plug_pocket_2d(0);
        // 45 deg bottom lead-in funnel so plugs self-center from underneath.
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
    assert(top + 1.0 <= pcb_bot, "PCB sits too close to the arm tops");
    assert(pcb_top + led_h <= inside_max, "LEDs reach too far into the house");

    union() {
        clip_ring(w = w, rc = rc, label = label, with_tab = true, with_cleats = true);
        for (i = [0 : arm_n - 1])
            rotate(arm_rot + i * 360 / arm_n)
                if (i == 2) latch_post(top);
                else fixed_post(top);
        if (layout == "stacked")
            plug_guide_cheeks();
    }

    echo(str("holder ", label, ": PCB bot z=", pcb_bot, ", LED tops z=", pcb_top + led_h,
             ", J1 plug end z=", pcb_bot - j1_stack,
             ", J2 plug end z=", pcb_bot - j2_stack));
}

holder();
