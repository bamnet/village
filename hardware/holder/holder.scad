// House holder (DRAFT), vertical-header layout. One printed piece.
//
// - The clip ring (clip.scad) grips the lighting hole.
// - Three posts continue up from the arm roots. Each has a ledge under the
//   PCB's edge and a hook lip over it, so the board snaps in from above, LED
//   side up, and sits inside the house above the arms.
// - The plugs hang from the board straight down through the middle, ending
//   flush with the flange's underside.
// - A cable tie through a pair of flange slots straps both cables to the
//   flange's underside. That keeps the plugs from sliding off, takes any tug
//   off the headers' solder joints, and gives a handle to pull the holder
//   out. Four slot pairs let the cables leave toward the cord notch.
//
// Print flange down in PETG. The hook lips are small flat overhangs.

use <clip.scad>
include <params.scad>

module post(top) {
    rotate_extrude(angle = arm_root_ang) {
        // Thick root below the arm tops (stiffer anchor for the arms).
        translate([root_r_in, -flange_t]) square([arm_r_in - root_r_in + 0.01, top + flange_t]);
        // Post up to the board, then the hook lip.
        translate([arm_r_in, top - 0.01]) square([post_w, pcb_top + hook_t - top + 0.01]);
        // Ledge under the board, 45 degree underside.
        polygon([[arm_r_in + 0.01, pcb_bot - (arm_r_in - ledge_r)], [arm_r_in + 0.01, pcb_bot],
                 [ledge_r, pcb_bot]]);
        // Hook lip over the board, with a lead-in on top.
        polygon([[arm_r_in + 0.01, pcb_top], [hook_r, pcb_top], [hook_r, pcb_top + 0.2],
                 [arm_r_in + 0.01, pcb_top + hook_t]]);
    }
}

module tie_slots() {
    for (a = tie_dirs) rotate(a) {
        for (s = [-1, 1])
            translate([tie_r - tie_slot[0] / 2, s * tie_offset - tie_slot[1] / 2, -flange_t - 1])
                cube([tie_slot[0], tie_slot[1], flange_t + 2]);
        // Groove on the wall side so the tie lies flush.
        translate([tie_r - tie_slot[0] / 2, -tie_offset, -tie_groove])
            cube([tie_slot[0], 2 * tie_offset, tie_groove + 1]);
    }
}

module holder(w = arm_w, k = barb_k, r3 = barb_r_at_wall_min) {
    top = arm_top(w, k, r3);
    assert(top + 0.5 <= pcb_bot, "PCB sits too close to the arm tops");
    assert(pcb_top + led_h <= inside_max, "LEDs reach too far into the house");
    difference() {
        union() {
            clip_ring(w, k, r3);
            for (i = [0 : arm_n - 1]) rotate(arm_rot + i * 360 / arm_n) post(top);
        }
        tie_slots();
    }
    echo(str("holder: PCB bottom z=", pcb_bot, ", LED tops z=", pcb_top + led_h,
             ", plug ends z=", pcb_bot - max(j1_stack, j2_stack)));
}

holder();
