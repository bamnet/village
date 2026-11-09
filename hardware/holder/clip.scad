// Clip ring: the part that pushes into the house's lighting hole.
//
// A flange sits against the outside of the wall. Arms rise through the hole,
// and a barb on each arm's free end catches the hole's inner edge. The arms
// curve around the axis and flex in the XY plane, so printing them upright
// never loads the layer lines in bending. Print flange down, no supports.
//
// Render this file on its own to see a single clip ring.

include <params.scad>

function arm_r_out(w) = arm_r_in + w;
function barb_tip_r(k, r3 = barb_r_at_wall_min) = r3 + k * (barb_tip_z - wall_min);
function arm_top(w, k, r3 = barb_r_at_wall_min) =
    barb_tip_z + (barb_tip_r(k, r3) - arm_r_out(w)) / tan(lead_in_deg);

// Bending strain at the arm root when the barb is squeezed through hole_min.
// Cantilever estimate: 1.5 * thickness * deflection / length^2.
function arm_len() = (arm_r_in + 0.5) * arm_ang * PI / 180;
function arm_strain(w, k, r3 = barb_r_at_wall_min) =
    1.5 * w * (barb_tip_r(k, r3) - hole_min / 2) / pow(arm_len(), 2);

module barb_profile(w, k, r3) {
    r_out = arm_r_out(w);
    // 45 degree underside up to the retention face (printable overhang).
    z0 = wall_min - (r3 - r_out);
    polygon([
        [arm_r_in, z0],
        [r_out, z0],
        [r3, wall_min],
        [barb_tip_r(k, r3), barb_tip_z],
        [r_out, arm_top(w, k, r3)],
        [arm_r_in, arm_top(w, k, r3)],
    ]);
}

module flange() {
    g_z = -flange_t / 2;
    r = flange_od / 2;
    rotate_extrude()
        difference() {
            translate([flange_id / 2, -flange_t]) square([r - flange_id / 2, flange_t]);
            // V groove in the rim for the carrier's hooks.
            polygon([[r + 0.01, g_z - groove_d], [r - groove_d, g_z],
                     [r + 0.01, g_z + groove_d]]);
        }
}

module clip_ring(w = arm_w, k = barb_k, r3 = barb_r_at_wall_min, label = "") {
    top = arm_top(w, k, r3);
    r_out = arm_r_out(w);
    assert(r3 > hole_max / 2, "no preload in the loosest hole (hole_max, wall_min)");
    assert(top <= inside_max, "arms reach too far into the house");
    // The barb's 45 degree underside must stay clear of the flange.
    z0 = wall_min - (r3 - r_out);
    assert(r_out - z0 < flange_id / 2 - 0.3, "barb underside hits the flange");

    difference() {
        union() {
            flange();
            for (i = [0 : arm_n - 1]) rotate(i * 360 / arm_n) {
                // Root block: ties the arm to the flange.
                rotate_extrude(angle = arm_root_ang) {
                    translate([arm_r_in, -flange_t]) square([w, top + flange_t]);
                    translate([arm_r_in, -flange_t])
                        square([flange_id / 2 - arm_r_in + 0.01, flange_t]);
                }
                // Flexing arm (free of the flange; a gap separates them).
                rotate(arm_root_ang)
                    rotate_extrude(angle = arm_ang)
                        translate([arm_r_in, -flange_t]) square([w, top + flange_t]);
                // Barb at the free end.
                rotate(arm_root_ang + arm_ang - barb_ang)
                    rotate_extrude(angle = barb_ang) barb_profile(w, k, r3);
            }
        }
        // Variant label, engraved in the flange's wall-side face.
        if (label != "")
            rotate(-60) translate([0, (flange_id + flange_od) / 4, -0.4])
                linear_extrude(1)
                    text(label, size = 2.6, font = "Liberation Sans:style=Bold",
                         halign = "center", valign = "center");
    }
    echo(str("clip ", label, ": arm w=", w, " k=", k, " r3=", r3,
             " tip r=", barb_tip_r(k, r3), " top z=", top,
             " preload at hole_max/wall_min=", r3 - hole_max / 2,
             " root strain at hole_min=", round(arm_strain(w, k, r3) * 1000) / 10, "%"));
}

clip_ring();
