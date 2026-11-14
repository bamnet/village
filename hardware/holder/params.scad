// Shared dimensions for the Pixel PCB house holder. Units: mm.
//
// Coordinates: Z = 0 is the house wall's outer face (the face the flange
// presses against). +Z points into the house. +Y is "north" on the Pixel PCB
// (KiCad -Y).
//
// Layout (vertical headers): the PCB sits on posts above the arms, inside the
// house, LEDs up. Both plugs hang straight down through the middle of the
// hole, and the cables are tied to the flange's underside.
//
// See the "House holder" section of the top-level README for the spec.

$fn = 96;

// ---------------------------------------------------------------------------
// House envelope: one size MUST fit every house.
// ---------------------------------------------------------------------------
hole_min   = 24;   // smallest hole diameter to support (25 measured, minus margin)
hole_max   = 29;   // largest hole diameter to support (28 measured, plus margin)
wall_min   = 3;    // thinnest wall at the hole (3 measured)
wall_max   = 9;    // thickest wall at the hole (8 measured, plus margin)
inlet_min  = 12;   // shallowest bottom recess measured (12-13 on 3 houses)
inside_max = 25;   // how far the holder may reach into the house (README)

// ---------------------------------------------------------------------------
// Clip ring: flange + flexing arms. Printed flange down, no supports.
// ---------------------------------------------------------------------------
flange_t  = 2.4;   // flange thickness
flange_od = 34;    // flange outer diameter; must clear hole_max with a contact ring
flange_id = 26.4;  // flange inner diameter; clears the barbs' undersides

arm_n        = 3;     // number of arms
arm_r_in     = 10.4;  // arm inner radius at rest (PCB is r 10.03)
arm_w        = 1.0;   // arm radial thickness (the main tuning knob)
arm_root_ang = 12;    // angular width of each arm's root block (and post)
arm_rot      = 22;    // turns the ring so the roots and bent arms clear the
                      // stacked plug block (barbs at 123/243/3 deg). v0.1's
                      // side-by-side plugs used -9 (barbs at 92/212/332).
root_r_in    = 7.5;   // root blocks thicken inward below the PCB, for stiffness
arm_ang      = 102;   // angular length of each flexing arm (about 19 mm of arc)
barb_ang     = 26;    // angular width of the barb at each arm's free end

// Barb profile, in (radius, Z). The retention face is the barb's lower face.
// The hole's inner edge (radius hole/2, height wall) rests on it, and the arm's
// spring presses outward, which pulls the flange against the wall. A sloped
// face (barb_k > 0) also gives a firm pull-out, so the holder can be removed.
barb_r_at_wall_min = 15.0;           // face radius at Z = wall_min; minus hole_max/2
                                     // is the preload in the loosest hole
barb_k             = 0.25;           // face slope, dr/dZ
barb_tip_z         = wall_max + 0.5; // widest point; must be above wall_max
lead_in_deg        = 40;             // insertion ramp, degrees from vertical

// ---------------------------------------------------------------------------
// Pixel PCB with VERTICAL headers. The outline and top side are v0.1's (from
// hardware/pixel/pixel.kicad_pcb). v0.1 boards can take hand-soldered vertical
// headers in the right-angle holes, but `layout` below defaults to the
// proposed v0.2 header positions.
// ---------------------------------------------------------------------------
pcb_d = 20.05;     // measured outline; ordered at +/-0.2 mm
pcb_t = 1.6;
led_h = 1.6;       // TBD: HL-5050 package height (typical 5050)

// Header layout (override on the command line, e.g. -D 'layout="v0.1"'):
// - "v0.1": the ordered board. Rows side by side, 8.89 mm apart, 4 mm north.
//   The real plugs need 9.2 mm, so both cannot be plugged in at once.
// - "side": v0.2 candidate, rows side by side (pin_gap apart), the plug block
//   centered on the board. Its 18.6 mm long block reaches the arm roots and
//   the bent arms at any arm_rot, so it does not fit this clip ring.
// - "stacked": v0.2 proposal. Two parallel rows, J1 north of J2, both centered
//   on x = 0. The plugs then form a 10.25 x 6.5 mm block (corner r 6.1), which
//   clears the arms with arm_rot = 22.
layout    = "stacked";
pin_gap   = 9.4;   // "side": J1-to-J2 pin distance (plugs need >= 9.2)
v02_row_y = 0;     // "side": pin rows' distance north of center
plug_gap  = 0.2;   // "stacked": clearance between the two plugs

// Vertical header bodies below the board.
j1_body_w = 7.62;  // male header: plastic body, pins continue below it
j1_body_h = 2.5;
j2_body_w = 8.09;  // female socket (C2897385 sample measured 8.09)
j2_body_h = 8.5;   // standard socket. The male plug's sleeve slides over it
                   // until the sleeve's mouth meets the board, so a lower
                   // socket only shortens the pin mate (see pm_pin_recess).
hdr_t     = 2.54;  // header thickness across the row

// ---------------------------------------------------------------------------
// Servo plugs: measured on the purchased cables, 2026-11-14.
// ---------------------------------------------------------------------------
// Female plug (mates J1's pins). Assumed centered on its pins.
pf_w = 8.15;       // across the 3 pins
pf_t = 2.85;       // across the row
pf_l = 14.1;       // housing length
// Male plug (mates J2's socket): a sleeve that swallows a female housing.
pm_w        = 10.25; // across the 3 pins
pm_t        = 4.0;   // across the row, over the sleeve
pm_sleeve_l = 17;    // length of the 4 mm thick sleeve, from its mouth
pm_neck_t   = 2.85;  // the last part toward the cable is thinner
pm_l        = 22.7;  // overall housing length
pm_engage   = 9.3;   // how far a female housing goes into the sleeve
pm_pin_recess = 3.1; // sleeve mouth to pin tips (3.0 - 3.2 measured)
// Walls are 0.85 mm, except at the signal-wire end: a 1.4 x 2.2 mm key block
// fills one corner of the cavity there (for a tab our female plugs don't
// have). The pins are centered across the thickness. Along the width, the
// thicker end shifts the sleeve about 0.3 mm toward the signal pin. Which way
// that is on the board depends on J2's pin order; pm_dx_sign picks it.
pm_dx      = (1.4 - 0.85) / 2;  // sleeve center offset from the center pin
pm_dx_sign = 1;

cable_w = 4.0;     // flat 3-wire cable
cable_t = 1.4;
cable_bend_d = 4;  // wraps a 4 mm rod comfortably

// Pin rows (bottom side), in model coordinates: each row's center pin.
// v0.1: J1 pins at x -6.89 / -4.35 / -1.81, J2 at 2.00 / 4.54 / 7.08, 4 mm north.
// "stacked": the rows are spaced for plug_gap between the plugs, and the
// block is centered on y = 0.
stack_sep = pf_t / 2 + plug_gap + pm_t / 2;   // 3.625
j1_x = layout == "v0.1" ? -4.35
     : layout == "side" ? -(pin_gap + pm_w / 2 - pf_w / 2) / 2 : 0;
j2_x = layout == "v0.1" ?  4.54
     : layout == "side" ? j1_x + pin_gap : 0;
// Stacked block spans from J2_y - pm_t/2 to J1_y + pf_t/2, with
// J1_y = J2_y + stack_sep. Centering it gives J2_y below.
stack_j2_y = -(stack_sep + pf_t / 2 - pm_t / 2) / 2;
j1_y = layout == "v0.1" ? 4.0 : layout == "side" ? v02_row_y : stack_j2_y + stack_sep;
j2_y = layout == "v0.1" ? 4.0 : layout == "side" ? v02_row_y : stack_j2_y;

// Board bottom to each plug's end.
j1_stack = j1_body_h + pf_l;
j2_stack = pm_l + max(0, j2_body_h - pm_engage);
// How far J2's socket takes the male pins.
j2_pin_mate = min(j2_body_h, pm_engage) - pm_pin_recess;

// ---------------------------------------------------------------------------
// Holder: PCB seat on the posts, plug ends flush with the flange underside.
// ---------------------------------------------------------------------------
pcb_bot = -flange_t + max(j1_stack, j2_stack);
pcb_top = pcb_bot + pcb_t;
post_w  = 1.2;     // post radial thickness above the arms (flexes for the snap)
ledge_r = 9.4;     // ledge under the board's edge at each post
hook_r  = 9.5;     // hook lip over the board's top edge (parts reach r 9.62
                   // only at D3, away from the posts)
hook_t  = 0.9;

tie_dirs   = [0, 90, 180, 270];  // cable exit directions with tie slots
tie_r      = 15.2;  // slot center radius in the flange
tie_slot   = [3.0, 1.6];  // radial x tangential
tie_offset = 5.5;   // slot center distance either side of the cable path
tie_groove = 1.1;   // depth of the groove that keeps the tie flush on the wall side
