// Shared dimensions for the Pixel PCB house holder. Units: mm.
//
// Coordinates: Z = 0 is the house wall's outer face (the face the flange
// presses against). +Z points into the house. +Y is "north" on the Pixel PCB
// (KiCad -Y). The plugs and cables leave toward -Y ("south").
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

groove_d  = 0.6;   // depth of the V groove in the flange rim (carrier hooks)

arm_n        = 3;     // number of arms
arm_r_in     = 10.4;  // arm inner radius at rest (PCB is r 10.03)
arm_w        = 1.0;   // arm radial thickness (the main tuning knob)
arm_root_ang = 12;    // angular width of each arm's root block
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
lead_in_deg        = 30;             // insertion ramp, degrees from vertical

// ---------------------------------------------------------------------------
// Pixel PCB v0.1 (from hardware/pixel/pixel.kicad_pcb)
// ---------------------------------------------------------------------------
pcb_d = 20.05;     // measured outline; ordered at +/-0.2 mm
pcb_t = 1.6;
led_h = 1.6;       // TBD: HL-5050 package height (typical 5050)

// Pin rows of the right-angle headers (bottom side), in model coordinates.
j1_x = -4.35;      // J1 male, 3 pins at x -6.89 / -4.35 / -1.81
j2_x =  4.54;      // J2 female, 3 pins at x 2.00 / 4.54 / 7.08
row_y = 4.0;       // both pin rows are 4 mm north of center

// Header bodies under the board (from the LCSC drawings, see README).
hdr_t      = 2.54; // body thickness below the board
j1_body_w  = 7.62;
j1_face    = 4.4;  // J1 body front face, measured from the pin row
j1_tip     = 10.4; // J1 pin tips, measured from the pin row
j2_body_w  = 8.09; // measured sample
j2_face    = 10.2; // J2 body front face, measured from the pin row
hdr_back   = 1.27; // body extends this far behind the pin row

// ---------------------------------------------------------------------------
// Servo plugs: SPECULATIVE until the cables arrive (bought 2026-11-07).
// The plugs mate on pins that sit 1.27 mm below the board, so a plug body
// thicker than 2.54 mm hits the board. Measure this first.
// ---------------------------------------------------------------------------
plug_w = 7.8;      // TBD
plug_t = 2.54;     // TBD: critical, see above
plug_l = 14.5;     // TBD: housing length
cable_w = 3.8;     // TBD: flat 3-wire 26 AWG
cable_t = 1.3;     // TBD

// ---------------------------------------------------------------------------
// Carrier (draft): holds the PCB and plugs under the clip ring.
// ---------------------------------------------------------------------------
led_clear  = 0.3;
pcb_top    = -flange_t - (led_h + led_clear);  // LED tops stay below the arms
pcb_bot    = pcb_top - pcb_t;
pocket_r   = 10.35;  // Ø20.7 for a 20.05 +/-0.2 board
lip_r      = 9.75;   // top-side parts reach r 9.62 (D3)
ring_or    = 16.6;   // carrier ring outer radius (under the flange)
plug_gap   = 0.4;    // between plug bottom and cradle floor
floor_t    = 1.2;
floor_top  = pcb_bot - plug_t - plug_gap;
floor_bot  = floor_top - floor_t;
window_hw  = 10.6;   // half width of the opening for headers and plugs
rail_w     = 1.2;
cradle_end = -27;    // how far south the cradle runs
hook_r_in  = flange_od / 2 + 0.05;
hook_w     = 1.0;
hook_ang   = 14;
