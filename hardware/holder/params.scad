// Shared dimensions for the Pixel PCB house holder (v0.3). Units: mm.
//
// Coordinates: Z = 0 is the house wall's outer face (the face the flange
// presses against). +Z points into the house. +Y is "north" on the Pixel PCB
// (KiCad -Y), and -Y ("south") points toward the cord notch.
//
// Layout (vertical headers):
// - Clip ring: 3 short XY-flexing arms with a gentle bore-friction crown
//   (Ø29.0 mm universal fit across Ø25-28 mm houses; S/L kept as options).
//   `arm_rot = 50` centers the 40 deg open arm gap directly on 270 deg (-Y) so
//   both south cable channels open straight into the central bore with no wall.
// - Upper PCB cradle: two wide, thick curved C-jaws (supported on 37 deg wide
//   solid pillars, flexing ~0.2 mm in XY rather than across Z-layers) receive
//   the PCB horizontally from the open south (-Y) mouth at Z = 16 mm.
// - Blind-mate C-cheeks (Z = -3.8 .. +7.1 mm) guide J1/J2 plugs from below
//   while staying 0.4 mm below the bare headers so a soldered PCB slides in.
// - Extended south pull-tab (-24.2 mm) houses two unobstructed full-wave
//   serpentine (S-bend) cable cleats.

$fn = 96;

// ---------------------------------------------------------------------------
// House envelope (measured houses: hole Ø25-28 mm, wall 3-8 mm, inlet 12-13).
// ---------------------------------------------------------------------------
hole_min   = 25.0; // smallest measured house hole
hole_sweep = 24.5; // bore used for worst-case arm-sweep clearance checks
hole_mid   = 26.5;
hole_max   = 28.0; // largest measured house hole (28.3 on printed v0.1 rings)
wall_min   = 3.0;  // thinnest wall at the hole (3 measured)
wall_max   = 8.5;  // thickest wall at the hole (8 measured, plus margin)
inlet_min  = 12.0; // shallowest bottom recess measured (12-13 on 3 houses)
inside_max = 25.0; // how far the holder may reach into the house (README)

// ---------------------------------------------------------------------------
// Clip ring: flange + short bore-friction arms. Printed flange down, no supports.
// ---------------------------------------------------------------------------
flange_t  = 3.8;   // flange thickness (houses 3.25 mm deep serpentine cable slots)
flange_od = 34.0;  // flange outer diameter
flange_id = 25.4;  // flange inner diameter (clears arm undersides with >=0.45 gap)

arm_n        = 3;     // number of arms
arm_r_in     = 10.4;  // arm inner radius at rest (PCB is r 10.025)
arm_w        = 0.84;  // arm radial thickness: two 0.42 mm Arachne outlines
arm_root_ang = 14;    // angular width of each arm's root block
arm_ang      = 66;    // flexing arc (~12.5 mm); leaves a 40 deg open gap
arm_rot      = 50;    // puts Gap 1 across 250..290 deg (dead center on -Y south
                      // cable exit: x = +/-4.34 mm completely clear of roots/arms)
crown_ang    = 18;    // angular width of the bore-contact pad near the arm tip

// Bore-pad profile in (radius, Z). Coupon v0.2 proved Ø28.7 (M) and Ø29.2 (L)
// both fit every tested house from Ø25 to Ø28; Ø29.0 (`crown_r_u = 14.50`) is
// the single universal default, with S and L retained for outliers.
crown_r_s     = 13.65; // Size S (Ø27.3): outlier holes < Ø25 mm
crown_r_m     = 14.35; // Coupon v0.2 M (Ø28.7)
crown_r_u     = 14.50; // Universal v0.3 default (Ø29.0)
crown_r_l     = 14.60; // Coupon v0.2 L (Ø29.2)
crown_r_def   = crown_r_u;
crown_z0_r    = 12.25; // max radius at Z <= 0 (0.45 mm inside flange_id/2 = 12.70)
crown_top_z   = 4.4;   // top of the flat bore-contact land
lead_in_deg   = 34;    // insertion ramp above crown_top_z, degrees from vertical

// ---------------------------------------------------------------------------
// Pixel PCB with VERTICAL headers ("stacked" v0.2 header layout).
// ---------------------------------------------------------------------------
pcb_d = 20.05;     // measured outline; ordered at +/-0.2 mm
pcb_t = 1.6;
led_h = 1.6;       // HL-5050 package height (typical 5050)

layout    = "stacked";
stack_dx  = -1.20; // Pixel v0.2 header stack X offset (west) in holder coords
stack_dy  = -0.45; // Pixel v0.2 header stack Y offset (south, toward cord notch)
pin_gap   = 9.4;
v02_row_y = 0;
plug_gap  = 0.2;

// Vertical header bodies below the board (XFCN C2937625 male, C541850 female).
j1_body_w = 7.62;
j1_body_h = 2.5;
j2_body_w = 8.12;
j2_body_h = 8.5;
hdr_t     = 2.54;

// ---------------------------------------------------------------------------
// Servo plugs: measured on the purchased cables, 2026-11-14.
// ---------------------------------------------------------------------------
pf_w = 8.15;
pf_t = 2.85;
pf_l = 14.1;

pm_w          = 10.25;
pm_t          = 4.0;
pm_sleeve_l   = 17;
pm_neck_t     = 2.85;
pm_l          = 22.7;
pm_engage     = 9.3;
pm_pin_recess = 3.1;
pm_dx         = (1.4 - 0.85) / 2;
pm_dx_sign    = 1;   // settled in Pixel v0.2: J2 has DATA_OUT on the east (+X) pin

cable_w      = 4.0;
cable_t      = 1.4;
cable_bend_d = 4;

// Pin rows (bottom side), in model coordinates (KiCad Y is flipped: Y_kicad = -Y).
// Settled Pixel v0.2 ("stacked"): J1 = (-1.20, +1.650), J2 = (-1.20, -1.975).
stack_sep  = pf_t / 2 + plug_gap + pm_t / 2;   // 3.625
j1_x = layout == "v0.1" ? -4.35
     : layout == "side" ? -(pin_gap + pm_w / 2 - pf_w / 2) / 2 : stack_dx;
j2_x = layout == "v0.1" ?  4.54
     : layout == "side" ? j1_x + pin_gap : stack_dx;
stack_j2_y = -(stack_sep + pf_t / 2 - pm_t / 2) / 2; // -1.525 before stack_dy
j1_y = layout == "v0.1" ? 4.0 : layout == "side" ? v02_row_y : stack_j2_y + stack_sep + stack_dy; // +1.650
j2_y = layout == "v0.1" ? 4.0 : layout == "side" ? v02_row_y : stack_j2_y + stack_dy;             // -1.975

j1_stack    = j1_body_h + pf_l;                      // 16.6
j2_stack    = pm_l + max(0, j2_body_h - pm_engage);  // 22.7
j2_pin_mate = min(j2_body_h, pm_engage) - pm_pin_recess; // 5.4

// ---------------------------------------------------------------------------
// Holder upper structure: sturdy XY-flexing C-jaws, C-cheeks, south S-cleat.
// ---------------------------------------------------------------------------
pcb_bot = 16.0;    // LEDs at 19.2 mm; J2 extends to Z = -6.7 (2.9 mm below flange)
pcb_top = pcb_bot + pcb_t;

// Curved PCB cradle jaws: two wide thick arcs (`-11..+76` East-North and
// `+104..+191` West-North) supported on 37 deg solid pillars (`27..64` and
// `147..184`). PCB slides horizontally into the -Y mouth (`~0.18 mm/side` XY
// snap past the detent tips; zero Z-layer bending).
pillar_r_in  = 8.95;  // inner radius of the two wide structural pillars
jaw_r_pocket = 10.10; // PCB pocket inner radius (ID 20.20; -12/+192 mouth chord = 19.76)
jaw_r_out    = 12.45; // outer radius of the upper C-jaw wall (~2.35 mm thick)
ledge_r      = 9.35;  // bottom ledge supporting the PCB edge
hook_r       = 9.52;  // 45 deg upper capture lip radius (clears all v0.2 courtyards)

// Stepped C-shaped plug guide cheeks (Z = -flange_t .. guide_top_z).
// Validated smooth fit in coupon v0.2. `guide_top_z = 7.1` stays 0.4 mm below
// the bare soldered headers (Z = 7.5) so a soldered PCB slides straight in from
// -Y, then mating the plugs locks PCB + holder together across Z = 7.1..16.0.
guide_top_z   = 7.1;
guide_trim_r  = 9.45;  // outer cheek trim radius around (0, 0); clears squeezed Arm 1
guide_j1_hw   = pf_w / 2 + 0.425;                 // 4.50 mm half-width around j1_x
guide_j2_hw   = pm_w / 2 + pm_dx + 0.40;          // 5.80 mm half-width around j2_x
guide_y_n     = j1_y + pf_t / 2 + 0.425;          // +3.50 mm (with stack_dy = -0.45)
guide_y_s     = j2_y - pm_t / 2 - 0.425;          // -4.40 mm (with stack_dy = -0.45)
guide_open_n  = 2.8;
guide_open_s  = 3.4;

// Shortened south (-Y) pull-tab (`-21.5 mm`, 2.7 mm shorter than coupon v0.3
// so it clears Yankee Candle's bottom recess edge) with full-2-curve S-cleats.
tab_y_end    = -21.5; // 4.5 mm south tab (proven recess fit in coupon v0.2)
tab_x_spread = 4.8;   // tighter corner fillets for extra recess wall clearance
tab_corner_d = 7.0;
cleat_x      = 2.85;  // +/-X centerline (fits cleanly inside 250..290 deg south gap)
cleat_amp    = 0.85;  // lateral S-wave amplitude (~3.8 mm min bend diameter)
cleat_wave_l = 7.6;   // wavelength -> 1.30 full waves inside y = -12.0 .. -21.9
cleat_w      = 1.68;  // slot width for 1.4 mm flat servo ribbon
cleat_h_wall = 2.45;  // vertical wall before 45 deg peaked roof
