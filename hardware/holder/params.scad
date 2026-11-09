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
arm_rot      = -9;    // turns the ring so the barbs sit at 92/212/332 deg,
                      // clear of the plugs when the arms bend inward
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
// Pixel PCB v0.1 (from hardware/pixel/pixel.kicad_pcb), fitted with VERTICAL
// headers instead of the right-angle ones. They share the same 3-hole pattern,
// so v0.1 boards can try this layout with hand-soldered headers.
// ---------------------------------------------------------------------------
pcb_d = 20.05;     // measured outline; ordered at +/-0.2 mm
pcb_t = 1.6;
led_h = 1.6;       // TBD: HL-5050 package height (typical 5050)

// Pin rows (bottom side), in model coordinates.
j1_x = -4.35;      // J1 male, 3 pins at x -6.89 / -4.35 / -1.81
j2_x =  4.54;      // J2 female, 3 pins at x 2.00 / 4.54 / 7.08
row_y = 4.0;       // both pin rows are 4 mm north of center

// Vertical header bodies below the board.
j1_body_w = 7.62;  // male header: plastic body, pins continue below it
j1_body_h = 2.5;
j2_body_w = 8.09;  // female socket
j2_body_h = 5.0;   // TBD: a low-profile 1x3 socket; a standard one is 8.5
hdr_t     = 2.54;  // header thickness across the row

// ---------------------------------------------------------------------------
// Servo plugs: SPECULATIVE until the cables arrive (bought 2026-11-07).
// ---------------------------------------------------------------------------
plug_w  = 7.8;     // TBD: across the 3 pins
plug_t  = 2.54;    // TBD: across the row
plug_l  = 14.5;    // TBD: housing length, both genders
cable_w = 3.8;     // TBD: flat 3-wire 26 AWG
cable_t = 1.3;     // TBD

j1_stack = j1_body_h + plug_l;   // board bottom to J1 plug end
j2_stack = j2_body_h + plug_l;   // board bottom to J2 plug end

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
