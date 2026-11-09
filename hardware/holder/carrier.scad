// Carrier (DRAFT): holds the Pixel PCB and both plugs, and snaps onto the
// clip ring from outside the house.
//
// - The PCB goes in from below, LED side up, past a small bump on the north
//   wall. A lip (r >= lip_r) above its edge stops it. One bump probably won't
//   hold the board in its 0.65 mm of clearance; this is a first guess.
// - The plugs then slide onto the headers and lie in a cradle running south.
//   A cable tie through the floor slots clamps both cables, so a tug loads the
//   carrier rather than the headers' solder joints.
// - Three hooks catch the V groove in the clip ring's flange rim. The groove is
//   a full circle, so the carrier swivels and the cables can point at the
//   cord notch (bottom-lit) or straight down (back-lit).
//
// Plug sizes are speculative, so this part is for checking the layout, not
// for printing yet. Print floor down; the bridge over the plug window is
// about 21 mm.

include <params.scad>

skirt_r   = 12.6;   // outer radius of the PCB pocket wall
cone_drop = ring_or - skirt_r;  // 45 degree support under the ring
foot_top  = -7.3;   // hooks rise from feet that stand on the bed
hook_angles = [90, 210, 330];

module plug_window() {
    // Room for the header bodies and plugs below the PCB.
    translate([-window_hw, cradle_end - 1, floor_top])
        cube([2 * window_hw, -cradle_end + 1 + 5.5, pcb_bot - floor_top]);
}

module carrier() {
    difference() {
        union() {
            // Top ring under the flange; its inner edge is the PCB lip.
            translate([0, 0, pcb_top])
                cylinder(r = ring_or, h = -flange_t - pcb_top);
            // 45 degree cone under the ring, down to the pocket wall.
            translate([0, 0, pcb_top - cone_drop])
                cylinder(r1 = skirt_r, r2 = ring_or, h = cone_drop);
            // Pocket wall, down to the floor.
            translate([0, 0, floor_bot])
                cylinder(r = skirt_r, h = pcb_top - floor_bot);
            // Cradle floor south of the board.
            translate([-window_hw - rail_w, cradle_end, floor_bot])
                cube([2 * (window_hw + rail_w), -cradle_end - pcb_d / 2 - 0.5, floor_t]);
            // Side rails.
            for (s = [-1, 1])
                translate([s > 0 ? window_hw : -window_hw - rail_w, cradle_end, floor_bot])
                    cube([rail_w, -cradle_end, -flange_t - floor_bot]);
            // Feet and hooks.
            for (a = hook_angles) rotate(a - hook_ang / 2) {
                rotate_extrude(angle = hook_ang)
                    translate([skirt_r - 0.5, floor_bot])
                        square([hook_r_in + hook_w - skirt_r + 0.5, foot_top - floor_bot]);
                rotate_extrude(angle = hook_ang)
                    polygon([
                        [hook_r_in, foot_top],
                        [hook_r_in + hook_w, foot_top],
                        [hook_r_in + hook_w, -0.3],
                        [hook_r_in, -0.3],
                        [hook_r_in, -flange_t / 2 + groove_d * 0.8],
                        [hook_r_in - groove_d * 0.8, -flange_t / 2],
                        [hook_r_in, -flange_t / 2 - groove_d * 0.8],
                    ]);
            }
        }
        // Light opening and PCB lip.
        translate([0, 0, pcb_top - 1]) cylinder(r = lip_r, h = 10);
        // PCB pocket, open to the bottom so the board goes in from below.
        translate([0, 0, floor_bot - 1]) cylinder(r = pocket_r, h = pcb_top - floor_bot + 1);
        plug_window();
        // Cable-tie slots.
        for (s = [-1, 1])
            translate([s * 9 - 1, cradle_end + 1.5, floor_bot - 1]) cube([2, 3, floor_t + 2]);
    }
    // PCB retention bumps on the north wall (clear of the header bodies).
    // Flat top holds the board; the sloped underside is the lead-in.
    intersection() {
        difference() {
            translate([0, 0, pcb_bot - 0.6]) cylinder(r = pocket_r + 0.1, h = 0.6);
            translate([0, 0, pcb_bot - 0.6 - 0.001])
                cylinder(r1 = pocket_r, r2 = pocket_r - 0.3, h = 0.602);
        }
        translate([-4, 6, pcb_bot - 1]) cube([8, 6, 2]);
    }
    echo(str("carrier: stack below wall = ", -floor_bot, " mm (inlet_min ", inlet_min, ")"));
}

carrier();
