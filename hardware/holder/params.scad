// Shared dimensions for the Pixel PCB house holder (v0.2). Units: mm.
//
// Coordinates: Z = 0 is the house wall's outer face (the face the flange
// presses against). +Z points into the house. +Y is "north" on the Pixel PCB
// (KiCad -Y), and -Y ("south") points toward the cord notch.
//
// Layout (vertical headers):
// - The clip ring uses short XY-flexing arms with a gentle bore-friction pad
//   (no tall overhang hook), sized in S / L (plus M universal candidate).
// - The PCB sits at Z = 16 mm inside the house, LEDs up, well above 3-8 mm
//   walls while leaving J2's plug extending ~3 mm below the flange and J1's
//   upper body exposed in the side windows for finger unplugging.
// - Two C-shaped guide cheeks align both plugs blind onto J1/J2 and block
//   1-pin-offset mis-plugging.
// - A south pull-tab on the flange holds two serpentine (S-bend) cable cleats
//   for tool-less strain relief (no zip ties).
//
// See the "House holder" section of the top-level README for the spec.

$fn = 96;

// ---------------------------------------------------------------------------
// House envelope (measured houses: hole Ø25-28 mm, wall 3-8 mm, inlet 12-13).
// ---------------------------------------------------------------------------
hole_min   = 25.0; // smallest measured house hole (24.5 used for sweep margin)
hole_sweep = 24.5; // bore used for worst-case arm-sweep clearance checks
hole_mid   = 26.5; // split between S and L clip rings
hole_max   = 28.0; // largest measured house hole (28.3 on printed v0.1 rings)
wall_min   = 3.0;  // thinnest wall at the hole (3 measured)
wall_max   = 8.5;  // thickest wall at the hole (8 measured, plus margin)
inlet_min  = 12.0; // shallowest bottom recess measured (12-13 on 3 houses)
inside_max = 25.0; // how far the holder may reach into the house (README)

// ---------------------------------------------------------------------------
// Clip ring: flange + short bore-friction arms. Printed flange down, no supports.
// ---------------------------------------------------------------------------
flange_t  = 3.8;   // flange thickness (houses 3.0 mm deep serpentine cable slots)
flange_od = 34.0;  // flange outer diameter
flange_id = 25.4;  // flange inner diameter (clears arm undersides with >=0.45 gap)

arm_n        = 3;     // number of arms
arm_r_in     = 10.4;  // arm inner radius at rest (PCB is r 10.025)
arm_w        = 0.84;  // arm radial thickness: two 0.42 mm Arachne outlines
arm_root_ang = 12;    // angular width of each arm's root block (and post)
arm_rot      = 22;    // turns the ring so posts clear top-side PCB parts and
                      // arm tips clear the stepped plug guide cheeks
root_r_in    = 8.8;   // root inward buttress radius where not joined to guide
arm_ang      = 72;    // flexing arc (~13.6 mm); leaves a 36 deg gap to next root
crown_ang    = 18;    // angular width of the bore-contact pad near the arm tip

// Bore-pad profile in (radius, Z). Instead of hooking over wall_max, a smooth
// cylindrical land inside Z = [z_crown_bot .. crown_top_z] grips the hole bore
// lightly across any 3-9 mm wall. Its 45 deg print underside finishes below
// wall_min so it never hooks behind a thin ceramic rim on removal.
crown_r_s     = 13.65; // Size S (Ø27.3 pad): for Ø25.0 - 26.5 mm holes
crown_r_m     = 14.35; // Size M (Ø28.7 pad): 1-size candidate across Ø25 - 28.3
crown_r_l     = 14.60; // Size L (Ø29.2 pad): for Ø26.5 - 28.3 mm holes
crown_r_def   = crown_r_m;
crown_z0_r    = 12.25; // max radius at Z <= 0 (0.45 mm inside flange_id/2 = 12.70)
crown_top_z   = 4.4;   // top of the flat bore-contact land
lead_in_deg   = 34;    // insertion ramp above crown_top_z, degrees from vertical

// ---------------------------------------------------------------------------
// Pixel PCB with VERTICAL headers. The outline and top side are v0.1's (from
// hardware/pixel/pixel.kicad_pcb). `layout` defaults to the v0.2 "stacked"
// header positions.
// ---------------------------------------------------------------------------
pcb_d = 20.05;     // measured outline; ordered at +/-0.2 mm
pcb_t = 1.6;
led_h = 1.6;       // HL-5050 package height (typical 5050)

layout    = "stacked";
pin_gap   = 9.4;   // "side": J1-to-J2 pin distance (plugs need >= 9.2)
v02_row_y = 0;     // "side": pin rows' distance north of center
plug_gap  = 0.2;   // "stacked": clearance between the two plugs

// Vertical header bodies below the board.
j1_body_w = 7.62;  // male header: plastic body, pins continue below it
j1_body_h = 2.5;
j2_body_w = 8.09;  // female socket (C2897385 sample measured 8.09)
j2_body_h = 8.5;   // standard socket (5.4 mm pin mate with male sleeve)
hdr_t     = 2.54;  // header thickness across the row

// ---------------------------------------------------------------------------
// Servo plugs: measured on the purchased cables, 2026-11-14.
// ---------------------------------------------------------------------------
pf_w = 8.15;       // female plug (mates J1): across the 3 pins
pf_t = 2.85;       // across the row
pf_l = 14.1;       // housing length

pm_w          = 10.25; // male plug (mates J2): across the 3 pins
pm_t          = 4.0;   // across the row, over the sleeve
pm_sleeve_l   = 17;    // length of the 4 mm thick sleeve, from its mouth
pm_neck_t     = 2.85;  // thinner neck toward the cable
pm_l          = 22.7;  // overall housing length
pm_engage     = 9.3;   // how far a female housing goes into the sleeve
pm_pin_recess = 3.1;   // sleeve mouth to pin tips (3.0 - 3.2 measured)
pm_dx         = (1.4 - 0.85) / 2; // 0.275 mm sleeve shift toward signal pin
pm_dx_sign    = 1;

cable_w      = 4.0;    // flat 3-wire cable
cable_t      = 1.4;
cable_bend_d = 4;      // wraps a 4 mm rod comfortably

// Pin rows (bottom side), in model coordinates: each row's center pin.
stack_sep  = pf_t / 2 + plug_gap + pm_t / 2;   // 3.625
j1_x = layout == "v0.1" ? -4.35
     : layout == "side" ? -(pin_gap + pm_w / 2 - pf_w / 2) / 2 : 0;
j2_x = layout == "v0.1" ?  4.54
     : layout == "side" ? j1_x + pin_gap : 0;
stack_j2_y = -(stack_sep + pf_t / 2 - pm_t / 2) / 2; // -1.525
j1_y = layout == "v0.1" ? 4.0 : layout == "side" ? v02_row_y : stack_j2_y + stack_sep; // +2.100
j2_y = layout == "v0.1" ? 4.0 : layout == "side" ? v02_row_y : stack_j2_y;             // -1.525

// Board bottom to each plug's end, and J2 pin mate depth.
j1_stack    = j1_body_h + pf_l;                      // 16.6
j2_stack    = pm_l + max(0, j2_body_h - pm_engage);  // 22.7
j2_pin_mate = min(j2_body_h, pm_engage) - pm_pin_recess; // 5.4

// ---------------------------------------------------------------------------
// Holder upper structure: PCB seat, blind-mate plug guide, south cable cleat.
// ---------------------------------------------------------------------------
pcb_bot = 16.0;    // LEDs at 19.2 mm; J2 extends to Z = -6.7 (2.9 mm below flange)
pcb_top = pcb_bot + pcb_t;

post_w       = 1.2;   // radial thickness of the 2 fixed-slot posts
latch_post_w = 1.0;   // thinner south post (~8.6 mm tall) flexes cleanly for snap
ledge_r      = 9.35;  // ledge under the board's edge at each post
hook_r       = 9.50;  // capture lip radius over the board's top edge
hook_t       = 1.1;   // lip height above pcb_top

// Stepped C-shaped plug guide cheeks (Z = -flange_t .. guide_top_z).
// Sized with ~0.4 mm per-side clearance around J1 and J2 (symmetric for +/-pm_dx)
// so plugs glide in blind while 1-pin-offset mis-plugging (2.54 mm) is blocked.
guide_top_z  = 8.2;   // 0.7 mm above the Z = 7.5 pin/socket mating plane
guide_wall   = 1.3;   // cheek wall thickness (x_outer = 7.10, clears squeezed arms)
guide_j1_hw  = pf_w / 2 + 0.425;                 // 4.50 mm half-width
guide_j2_hw  = pm_w / 2 + pm_dx + 0.40;          // 5.80 mm half-width
guide_y_n    = j1_y + pf_t / 2 + 0.425;          // +3.95 mm
guide_y_s    = j2_y - pm_t / 2 - 0.425;          // -3.95 mm
guide_open_n = 2.8;   // half-width of +Y window (leaves 1.7 mm corner wraps)
guide_open_s = 3.4;   // half-width of -Y window (leaves 2.4 mm corner wraps)

// South (-Y) pull-tab and dual edgewise serpentine cable cleats.
tab_y_end    = -21.5; // south tip of pull-tab (4.5 mm proud of Ø34 flange)
tab_x_spread = 5.5;   // centers of the two Ø7 corner fillets (+/-5.5 -> 18 mm wide)
tab_corner_d = 7.0;
cleat_x      = 3.6;   // +/-X centerline of the two S-curve cable channels
cleat_amp    = 1.00;  // S-wave lateral amplitude (min bend diameter ~4 mm)
cleat_wave_l = 8.6;   // S-wave wavelength along Y (y = -12.6 .. -21.5)
cleat_w      = 1.70;  // slot width for 1.4 mm flat servo ribbon (+0.30 clearance)
cleat_h_wall = 2.45;  // vertical slot wall before 45 deg peaked roof (total 3.30)
