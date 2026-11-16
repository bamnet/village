// Clip ring (v0.3): the part that fits into the house's lighting hole.
//
// A flange sits against the outside of the wall, with a south (-Y) pull-tab
// pointing toward the cord notch. Three short XY-flexing arms rise into the
// hole, each carrying a smooth cylindrical bore-contact crown inside Z = 1.4..4.4
// mm. `arm_rot = 50` aligns the 40 deg open gap across 250..290 deg (-Y south)
// so both serpentine cable channels open straight into the central bore with
// zero inner wall blocking the cables. Print flange down in PETG, no supports.

include <params.scad>

function arm_r_out(w) = arm_r_in + w;
function crown_bot_z(rc) = rc - crown_z0_r;  // 45 deg ramp above Z = 0
function arm_top(w, rc = crown_r_def) =
    crown_top_z + (rc - arm_r_out(w)) / tan(lead_in_deg);

// Bending strain and tip advance estimates when squeezed into `hole_d`.
function arm_len(w = arm_w) = (arm_r_in + w / 2) * arm_ang * PI / 180;
function crown_bend(rc = crown_r_def, hole_d = hole_min) = max(0, rc - hole_d / 2);
function arm_strain(w = arm_w, rc = crown_r_def, hole_d = hole_min) =
    1.5 * w * crown_bend(rc, hole_d) / pow(arm_len(w), 2);
function tip_advance_deg(w = arm_w, rc = crown_r_def, hole_d = hole_min) =
    let(r0 = arm_r_in + w / 2, r1 = r0 - crown_bend(rc, hole_d))
    arm_ang * (r0 / r1 - 1);

module crown_profile(w, rc) {
    r_out = arm_r_out(w);
    z_bot = crown_bot_z(rc);
    z_start = -(crown_z0_r - r_out);
    top = arm_top(w, rc);
    polygon([
        [arm_r_in, z_start],
        [r_out, z_start],
        [crown_z0_r, 0],
        [rc, z_bot],
        [rc, crown_top_z],
        [r_out, top],
        [arm_r_in, top],
    ]);
}

// 2D footprint of the flange + south (-Y) pull-tab, minus the central opening.
module flange_2d(with_tab = true) {
    difference() {
        hull() {
            circle(d = flange_od);
            if (with_tab)
                for (sx = [-1, 1])
                    translate([sx * tab_x_spread, tab_y_end + tab_corner_d / 2])
                        circle(d = tab_corner_d);
        }
        circle(d = flange_id);
    }
}

module flange(with_tab = true) {
    difference() {
        translate([0, 0, -flange_t])
            linear_extrude(flange_t)
                flange_2d(with_tab);
        // 45 deg bottom finger-pinch chamfer around the central bore.
        translate([0, 0, -flange_t - 0.01])
            cylinder(d1 = flange_id + 2.6, d2 = flange_id, h = 1.31);
    }
}

// Cross-section of one edgewise serpentine cable slot. Flat on the bed with a
// 45 deg entry chamfer, vertical side walls, and a 45 deg peaked roof.
module cleat_slice_3d(x, y, w = cleat_w) {
    hw = w / 2;
    ch = 0.45;
    z_bed = -flange_t - 0.02;
    z_wall_top = -flange_t + cleat_h_wall;
    z_peak = min(-0.55, z_wall_top + hw);
    translate([x, y, 0])
        rotate([90, 0, 0])
            linear_extrude(0.35, center = true)
                polygon([
                    [-hw - ch, z_bed],
                    [ hw + ch, z_bed],
                    [ hw, -flange_t + ch],
                    [ hw, z_wall_top],
                    [  0, z_peak],
                    [-hw, z_wall_top],
                    [-hw, -flange_t + ch],
                ]);
}

// Dual parallel serpentine (S-bend) cable channels in the south (-Y) pull-tab.
// Starts at y = -11.2 (well inside the Ø25.4 central bore, right through the
// 250..290 deg open gap) with a flared entry horn so zero inner wall blocks the
// cables and both S-curves engage along their full height.
module south_cable_cleats(slot_w = cleat_w, steps = 28) {
    y_horn = -11.0;        // inside the bore (`r = 12.7` chord at x=3.7 is y=-12.15)
    y0     = -12.6;        // start of the sinusoidal S-wave
    y1     = tab_y_end - 0.4; // -24.6: exits cleanly out the south tip
    for (side = [-1, 1]) {
        // Flared straight lead-in horn breaking cleanly through the inner bore wall.
        hull() {
            cleat_slice_3d(side * cleat_x, y_horn, slot_w + 0.55);
            cleat_slice_3d(side * cleat_x, y0, slot_w);
        }
        // Full 1.33-wave S-channel out the south tip (engages both curves fully).
        for (i = [0 : steps - 1]) {
            ya = y0 + (y1 - y0) * i / steps;
            yb = y0 + (y1 - y0) * (i + 1) / steps;
            xa = side * cleat_x + cleat_amp * sin(360 * (ya - y0) / cleat_wave_l);
            xb = side * cleat_x + cleat_amp * sin(360 * (yb - y0) / cleat_wave_l);
            hull() {
                cleat_slice_3d(xa, ya, slot_w);
                cleat_slice_3d(xb, yb, slot_w);
            }
        }
    }
}

module clip_ring(w = arm_w, rc = crown_r_def, label = "", rot = arm_rot,
                 with_tab = true, with_cleats = false) {
    top = arm_top(w, rc);
    r_out = arm_r_out(w);
    z_bot = crown_bot_z(rc);
    z_start = -(crown_z0_r - r_out);
    gap_deg = 360 / arm_n - arm_root_ang - arm_ang;

    assert(z_start >= -flange_t + 0.3, "crown underside reaches print bed");
    assert(crown_z0_r <= flange_id / 2 - 0.35, "crown underside too close to flange");
    assert(z_bot <= wall_min - 0.5, "crown 45 deg underside could hook thin walls");
    assert(top <= inside_max, "arms reach too far into the house");
    assert(tip_advance_deg(w, rc, hole_sweep) < gap_deg - 10,
           "curved arm tip advances too close to next root");

    difference() {
        union() {
            flange(with_tab = with_tab);
            for (i = [0 : arm_n - 1]) rotate(rot + i * 360 / arm_n) {
                // Root block: ties the arm solidly into the flange right from Layer 1.
                rotate_extrude(angle = arm_root_ang) {
                    translate([arm_r_in, -flange_t]) square([w, top + flange_t]);
                    translate([arm_r_in, -flange_t])
                        square([flange_id / 2 + 2.0 - arm_r_in, flange_t]);
                }
                // Flexing arm (overlaps root by 0.2 deg so CGAL never splits the seam).
                rotate(arm_root_ang - 0.2)
                    rotate_extrude(angle = arm_ang + 0.2)
                        translate([arm_r_in, -flange_t]) square([w, top + flange_t]);
                // Bore-contact crown near the free end.
                rotate(arm_root_ang + arm_ang - crown_ang)
                    rotate_extrude(angle = crown_ang) crown_profile(w, rc);
            }
        }
        if (with_cleats) south_cable_cleats();
        // Variant label, engraved in the flange's wall-side face (+Y north side).
        if (label != "")
            translate([0, (flange_id + flange_od) / 4, -0.45])
                linear_extrude(1)
                    text(label, size = 3.0, font = "Liberation Sans:style=Bold",
                         halign = "center", valign = "center");
    }
    echo(str("clip ", label, ": arm w=", w, " crown OD=", 2 * rc,
             " z=[", z_bot, "..", crown_top_z, "] top=", round(top * 100) / 100,
             " gap=", gap_deg, " deg (adv@", hole_min, "=",
             round(tip_advance_deg(w, rc, hole_min) * 10) / 10, " deg)",
             " strain@", hole_min, "=",
             round(arm_strain(w, rc, hole_min) * 1000) / 10, "%"));
}

// Space the arms sweep through when squeezed through `hole_d`.
module arm_sweep(w = arm_w, rc = crown_r_def, rot = arm_rot,
                 hole_d = hole_sweep, steps = 20) {
    d = crown_bend(rc, hole_d);
    top = arm_top(w, rc);
    function defl(x) = d * x * x * (3 - x) / 2;
    for (i = [0 : arm_n - 1]) rotate(rot + i * 360 / arm_n + arm_root_ang) {
        for (s = [0 : steps - 1]) {
            a0 = arm_ang * s / steps;
            a1 = arm_ang * (s + 1) / steps;
            am = (a0 + a1) / 2;
            hull() {
                rotate(a0) rotate_extrude(angle = a1 - a0)
                    translate([arm_r_in, -flange_t]) square([w, top + flange_t]);
                translate(-defl((s + 1) / steps) * [cos(am), sin(am), 0])
                    rotate(a0) rotate_extrude(angle = a1 - a0)
                        translate([arm_r_in, -flange_t]) square([w, top + flange_t]);
            }
        }
        am = arm_ang - crown_ang / 2;
        hull() {
            rotate(arm_ang - crown_ang) rotate_extrude(angle = crown_ang) crown_profile(w, rc);
            translate(-d * [cos(am), sin(am), 0])
                rotate(arm_ang - crown_ang) rotate_extrude(angle = crown_ang)
                    crown_profile(w, rc);
        }
    }
}

clip_ring();
