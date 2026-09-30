# Village Electric Light Department

_(village, for short)_

## Background

I have a collection of 1-2 dozen Department 56 lighted Christmas houses. The default
lighting solution has a big problem though: a house is either lit or not. Further,
the default technique of daisy-chaining all of the plugs together means the entire
village is typically on or off.

This is not very realistic, our winter Dickens Village is not North Korea.

## Goal

The Village Electric Light Department provides the ability for each house to be
individually dimmed and to have that brightness vary throughout the night. This
enables much more custom and realistic displays, with each house following its
own lighting pattern throughout the night and across different nights.

## Approach

### 2018?

In 2018 we built our first prototype. To do this, we bought an RGB LED strip and cut
it into individual segments. We soldered wires onto each segment, and wired them all
back into a TLC5947 controlled by an ESP32.

Each house got one cut segment of a 12 V analog (not individually addressable) RGBW
strip (Shiji Lighting SJ-10060-RGBW, 60 LEDs/m). A segment has 3 warm-white 5050 RGBW
LEDs. Each color channel runs its 3 LEDs in series with a current-limiting resistor
(150 ohm on G/B/W), roughly 20 mA per channel. The TLC5947 sank each channel's
current. See `archive/2018_led_segment.jpg`.

This was a good proof of concept, but the construction was quite messy with flexible
LED strip segments haphazardly positioned in the back / bottom lighting holes of the
houses, a messy breadboard wiring this all together, and standalone power supply.

### 2020?

We started cleaning up this design by introducing a circular PCB with LEDs that we
could fit into a 3D printer holder for each house. These could, in theory, be wired
back to a base station for control.

Ultimately, we never finished a working end-to-end design here, largely driven by
the manual work to solder connectors onto each of the PCBs and, more importantly,
the manual work to build custom cables to connect the PCBs back to the base station.

### 2025

We specified a two-board design (ESP32-S3 base station running WLED, plus a
daisy-chained 20 mm Pixel PCB with SK6812 RGBW LEDs) and started a controller
layout. Nothing was fabricated because we ran out of time.

## Specifications

Requirement keywords (MUST, SHOULD, MAY) follow RFC 2119. Items marked **TBD** are
open decisions.

### System

- The system MUST support 22 houses.
- Each house MUST be independently addressable, so its brightness can be set on
  its own. Addressing each LED within a house MAY be supported, but is not required.
- Houses SHOULD be daisy-chained, with the base station driving about 4 chains
  (roughly 6 houses per chain). This keeps cables short and the base station tidy.
  It is a preference, not a hard requirement: another topology is acceptable if
  it is clearly better.

### Physical layout

- Tentatively, the base station sits in the middle, between two shelves, with chains
  running outward on both sides.
- Houses are spaced about 1 ft (0.3 m) apart. A house-to-house cable of about 1 m
  gives enough slack.
- The farthest house is no more than 8 ft (2.4 m) from the base station.

### Light

As a winter village, each house MUST be lit using warm white light. Each house MAY
support RGB to fine tune the colors and do neat patterns.

The light should be bright, historically using a 5 - 6 watt C7 bulb @ 120 volts.
We obviously want to modernize this with an LED.

- Research (2026-09) shows small incandescent C7 bulbs are dim. Retail listings give
  a 4 W clear C7 as 16 - 19 lm, and a 5 W, 130 V-rated C7 as about 10 lm. LED
  "5 W equivalent" C7 bulbs claim 50 - 75 lm, but those figures are marketing, not
  measurements. The 2025 spec's "~60 lm" target is probably 3x too high.
- The 2018 prototype segment was bright enough, even with its poor LED placement on
  a flexible strip. It had 3 warm-white RGBW 5050 LEDs per house, each channel's LEDs
  in series at about 20 mA.
- Brightness target: warm-white output per house SHOULD match the 2018 segment,
  meaning 3 warm-white RGBW 5050 LEDs driven at about 16 - 20 mA.
- Each house MUST use one WS2814 as its driver. It is a 4-channel RGBW
  constant-current driver that WLED supports (configured as SK6812 RGBW type). Its
  outputs are fixed at 16.5 mA per channel, about 80% of the 2018 current.
  **TBD:** confirm this is bright enough.
- As of 2026-09-30, the original SOP-12 WS2814 (C965562) shows 0 stock at LCSC.
  The draft schematic uses the WS2814F (FSOP-8, C5446694, about 107,000 in stock).
  It has the same 16.5 mA outputs, the same 9 V DIN rating, and the same 12 V
  application circuit (2.7k to VDD, 0.1 uF). It has no backup data input (DIN2),
  so there is nothing to tie off. Its data order is W, R, G, B (datasheet p. 4).
  The WS2814A (SOP-8, C2920044, about 7,800 in stock) is the same die in a larger
  package. It is the fallback, with a standard SOIC-8 footprint.
- Decided (2026-09-30): the Pixel PCB uses the WS2814F. Its smaller body leaves
  more room for the LEDs on the 20 mm board.
- The WS2814F's FSOP-8 footprint (1.65 x 3.25 mm body, 2.85 mm lead span, 0.8 mm
  pitch) is not in KiCad's stock libraries, so we drew it. Once it's proven on a fabricated
  board, consider contributing it (and a WS2814 symbol) upstream to the KiCad
  libraries.
- Each channel drives 3 LEDs in series, and all 3 LEDs show the same color, with one
  address per house. The white channel MUST be warm white (2700 - 3000 K).
- LEDs SHOULD be 3 RGBW 5050 4-in-1 packages with a warm-white die, matching 2018.
  Fallback: 3 RGB LEDs plus 3 separate warm-white LEDs, which also allows a free
  choice of warm-white LED.
- As of 2026-09, LCSC has two warm-white 4-in-1 RGBW 5050 parts (SMD5050-8P, with
  a separate anode and cathode pin per color). Both are JLCPCB extended parts.
  Figures are from the datasheets, at 20 mA:
  - Honglitronic HL-5050RGBW-S1-A27 (C22470444): about 11,000 in JLCPCB stock.
    The "-A27" suffix is the datasheet's white bin A27, which is 2580 - 2870 K.
    That is slightly warmer than 2700 - 3000 K at the low end. White gives 7 - 9 lm,
    CRI 80 or better. Forward voltage is 2.8 - 3.4 V (W/G/B) and 1.8 - 2.4 V (R).
  - TCWIN TC5050RGBW3D06-4CSAR3-AFW324A (C784543): 2800 - 3200 K. White gives
    6 - 7 lm, CRI 80 - 85, with a forward voltage of 2.8 - 3.2 V. Stock is low
    (about 240 at JLCPCB, 860 at LCSC).
  - Cool-white variants that do not meet the spec: XINGLIGHT XL-5050RGBW
    (C7371891), TCWIN C784545 (6000 - 6500 K), and C784544 (3800 - 4200 K).
  **TBD:** choose between them. The Honglitronic part is preferred. One caution:
  its spec sheet (B-18-A-1651 rev A/2, 2019) has "Under Development" checked on
  its cover, not "Mass production". JLCPCB stocks it, so this is probably stale
  paperwork, but weigh it against TCWIN once the samples arrive.
- Heat is not expected to be a concern. The cut-up LED strip prototype ran without
  heat problems.
- Driver heat (estimated): 3 red LEDs drop only 5.4 - 7.2 V, which leaves up to
  about 6.6 V across the WS2814's red output (about 110 mW at 16.5 mA). The draft
  adds a 120 ohm ballast resistor (R4) on red to take about 2 V (33 mW) of that off
  the chip. With all four channels at full, the WS2814 then dissipates about
  0.2 W worst case. Warm-white-only use is well below this.
- The two LED candidates have different pinouts. Honglitronic has anodes on pins
  1/3/5/7 (W/B/G/R) and cathodes on 2/4/6/8. TCWIN has anodes on 1-4 (R/G/B/W)
  and cathodes on 8-5. The draft schematic follows the Honglitronic part.

### Interconnect

The lack of a practical cable solution is what stalled the 2020 attempt, so it is a
first-class requirement here.

- Cables MUST be off-the-shelf or easily purchasable. We MUST NOT need to crimp,
  solder, or otherwise build our own cables (the system needs about 24 of them).
- House-to-house links need cables of about 1 m. **TBD:** the length from the base
  station to the first house in each chain.
- The WS2814 datasheet specifies data runs of up to 2 m between two points without
  extra circuitry. The base-station-to-first-house run SHOULD stay within about 2 m.
  Otherwise the base station needs a stronger line driver.
- Cables MUST be standard 3-wire RC servo extension cables (JR/Futaba style, 2.54 mm
  pitch), bought ready-made. 1 m male-to-female cables are widely sold. 22 AWG is
  preferred over 26 AWG for lower voltage drop.
- Boards MUST use 2.54 mm pitch 1x3 headers: male pins for the incoming cable and a
  female socket for the outgoing cable. JLCPCB solders these through-hole parts.
- Pinout MUST put power on the middle pin, following the servo convention. Then a
  reversed plug swaps ground and data rather than shorting the supply. The design
  SHOULD tolerate a reversed plug without damage, using series resistors on data
  lines and similar measures. This is to be verified during design: in a reversal,
  a house's ground rides on the upstream data line, and the WS2814 data input is
  rated to only 9 V.
- Draft protection (Pixel PCB schematic v0.1, estimated rather than tested):
  - Reversed plug: this house's GND pin lands on the upstream data line. The
    return current of this house and every house downstream is about 2.6 mA per
    house through its 2.7k VDD resistor, so about 16 mA for 6 houses, since the
    LEDs stay dark with no valid data. Most of it flows through the upstream
    house's R3 (100 ohm) into the upstream WS2814's DOUT. For the first house in
    a chain, it flows into the Dig-Quad's output buffer instead. Only about
    1 - 2 mA goes through this house's R2 (1k) and D1. The part at risk is
    therefore the upstream driver. The datasheet rates DOUT sink current at 10 mA
    minimum at 0.4 V (p. 3), which is less than 16 mA. While the upstream DOUT is
    high, this house's ground rises to about 5 V. The current then splits between
    R2/D1 (about 5 mA) and the upstream chip's VDD. D1's job is to clamp DIN so it
    can't go below this house's lifted GND.
  - Offset plug (a socket shifted one pin over on the header): 12 V can land on the
    data pin. R2 limits this to about 7 mA into VDD through D1, so R2 dissipates
    about 45 mW (the 0402 is rated 62.5 mW). The pass/fail limit is the datasheet's
    VDD absolute maximum of 3.7 - 5.3 V (p. 2), so VDD must stay at or below 5.3 V.
  - Why keep D1: the datasheet limits logic input voltage to "VDD-0.7 ~ VDD+0.7"
    (p. 2). The lower bound is almost certainly a typo for -0.7 V. Either way, DIN
    may go only about 0.7 V beyond the rails. The BAT54S (Vf about 0.3 V) keeps
    DIN inside that window in both the reversed and offset cases. A series
    resistor alone would not.
  - DOUT keeps the datasheet's 100 ohm series resistor.
  - **TBD:** the R2 value. Test on the first fabricated Pixel boards (the LED
    samples on order don't include a WS2814F):
    - Reversed plug: check that the upstream DOUT and the Dig-Quad output survive
      and still work afterward.
    - Offset plug: measure VDD with 12 V on DATA_IN. It must stay at or below 5.3 V.
    No circuit change is planned until those results are in.
- Flat servo cable fits the original cord channel. It is thinner than the classic
  120 V lamp cord that already uses it.

### Power

- The system MUST use a 12 V supply. We chose 12 V over 5 V because of voltage drop.
  5 V SK6812 LEDs need at least 4.5 V at the last house, which leaves only about
  0.5 V for losses across a chain of servo cables. At 12 V, 3 white/blue/green LEDs
  in series need about 9 - 9.6 V (3.0 - 3.2 V each). Allowing for the driver output,
  that leaves roughly 1.5 V of headroom. These are estimates: the WS2814 datasheet
  does not specify the minimum output voltage it needs to regulate.
- Estimated load: about 66 mA per house with all four channels at full, so about 1.5 A
  (18 W) for 22 houses. With warm white only, it is about 16.5 mA per house, so about
  0.4 A.
- Estimated voltage drop: about 0.6 V at full RGBW for a 6-house chain on 26 AWG
  cable (about 2 m to the first house, then 1 m hops). This is within the headroom.
- For the prototype, power enters through the Dig-Quad's input screw terminals.
  **TBD:** a supply sized with margin (for example 12 V, 3 A or more).

### Pixel PCB

- The project targets KiCad 10. Files saved in KiCad 10 cannot be opened in
  KiCad 9.
- Draft schematic: `hardware/pixel/pixel.kicad_sch` (v0.1). It was authored in
  KiCad 9 format and is ERC clean in KiCad 9.0.2 and 10.0.6.
- Custom footprints live in the project library `hardware/pixel/village.pretty`
  (nickname `village`), since neither part is in KiCad's stock libraries:
  - `FSOP-8_1.65x3.25mm_P0.8mm` (U1, WS2814F). From the datasheet package drawing
    (V1.1, p. 6): 0.35 mm leads with 0.4 mm feet. The land pattern is 0.9 x 0.45 mm
    pads centered 2.6 mm apart (0.3 mm toe, 0.2 mm heel).
  - `LED_Honglitronic_HL-5050RGBW_5.0x5.0mm_P1.2mm` (D2-D4). This is the
    manufacturer's recommended land pattern (spec B-18-A-1651 rev A/2, p. 3):
    1.1 x 0.54 mm pads, 2.83 mm inner gap, 1.2 mm pitch. Pads are numbered as in the
    datasheet's top view: anodes 1/3/5/7 on the right, cathodes 2/4/6/8 on the
    left, pin 1 at the top right. The part's corner mark sits at pin 2.
  - **TBD:** the LED datasheet's "bottom view" labels the pins the same as its top
    view, not mirrored, so one of the two views is wrong. A mirrored footprint
    would put every LED in backwards. Before ordering boards, check a sample with
    a multimeter in diode mode: with the corner mark at the top left, looking at
    the lens, the top-right lead should be the white anode (+).
  - **TBD:** both are unproven until a fabricated board is assembled and works.
    The TCWIN LED would need its own footprint, because its pad numbering differs.
- In order to fit the 3D-printed holder that sits in each house's lighting hole,
  the per-house PCB ("Pixel PCB") MUST be a circle no bigger than 20 mm in diameter.
  This is small, but large enough to fit several LEDs as needed.
- The lighting hole in the house itself is slightly larger than the holder hole. The
  hole size is broadly consistent across houses (the original lights are
  interchangeable). **TBD:** the measured house hole size.
- Some houses have the lighting hole in the back and some in the bottom. For bottom
  holes, the original clip-in lamp sits in the hole and its cord leaves sideways,
  flush with the base, through a notch and cord channel in the house base.
- For bottom holes, the assembly can extend up to about 1 in (25 mm) into the house.
- A daisy-chained house has two cables (in and out). Both MUST fit through the notch
  and cord channel. Two flat servo cables fit, since a classic 120 V lamp cord does.
- LEDs MUST be on the top side, clustered near the center. Headers (through-hole)
  go on the bottom side.
- All surface-mount parts, the WS2814 included, SHOULD also go on the top side. That
  keeps assembly to one surface-mount side, which is simpler and cheaper. Moving the
  WS2814 to the bottom is allowed if the LEDs don't fit otherwise, but it requires
  JLCPCB two-sided (Standard) assembly. **TBD:** settle this during layout, once the
  LED part is chosen.
- Through-hole header pins and solder joints come out on the LED side. Headers
  MUST sit near the rim, with a centered keep-out for the LEDs.
- Headers SHOULD be right-angle, mounted side by side on the bottom, with both
  pointing the same way (toward the cord notch). The plugs then lie flat under the
  board. This gives a much lower profile than vertical headers, and both cables
  already point where they need to go. JLCPCB-assemblable candidates: male C492411
  and female C2897385. If two plugs don't fit side by side on the 20 mm board, fall
  back to vertical headers. **TBD:** confirm the fit with real servo plugs (the
  width is estimated at about 8 mm each).
- Provisional layout (placed and routed, pending real plug dimensions):
  `hardware/pixel/pixel.kicad_pcb`.
  - The board is a 20 mm circle. The cord notch is taken to be at the south
    (+Y) edge.
  - J1 and J2 are on the bottom side, with pin rows side by side about 4 mm north
    of center. Their bodies point south and run under the board, so the plugs
    mate near the south rim and lie flat. This works because the headers and
    plugs are on the bottom while every other part is on the top, so the header
    bodies can sit under the top-side parts.
  - This relaxes "headers near the rim". The pin rows sit just north of the
    LEDs, and the LED cluster sits about 2.5 mm south of center.
  - The header rows are 8.9 mm apart, center to center. KiCad's stock
    footprints need at least 8.62 mm, which is slightly more than the estimated
    8 mm plug width.
  - J1 and J2 use KiCad's stock right-angle footprints. Checked against the LCSC
    drawings on 2026-09-30, and the copper matches:
    - J1, male (XFCN PZ254R-11-03P, C492411): Ø1.02 mm holes and 0.64 mm square
      pins (0.91 mm across the corners, so they fit the 1.0 mm drill). The
      body's front face is 4.4 mm from the pin row, and the pin tips are at
      10.4 mm (KiCad draws 4.04 mm and 10.04 mm).
    - J2, female (HCTL PM254-1-03-W-8.5, C2897385): Ø1.02 mm holes. The 8.5 mm
      body ends 10.2 mm from the pin row (KiCad draws 10.03 mm), and the body is
      8.02 mm wide (KiCad draws 7.62 mm).
    - KiCad's courtyards still cover both real bodies. With the rows 8.9 mm apart,
      the bodies are about 1.1 mm apart.
    - The pin tails are 3.0 and 3.2 mm long, so on a 1.6 mm board they stick up
      about 1.4 - 1.6 mm on the LED side.
  - Pin order: the stock footprints put J1's pin 1 at the west end and J2's pin 1
    at the east end, so the two GND pins are adjacent. Neither part is polarized,
    so this only decides which way up each cable plugs in.
    **TBD:** consider a bottom silkscreen mark at each pin 1 (data) so plugs go in
    the right way.
  - On the top side, the LEDs follow the chain +12V -> D2 (east, rot 90) -> D3
    (south, rot 0) -> D4 (west, rot 270) -> U1. Each LED faces the side that
    connects to the next LED toward it, so each group of four color nets between
    LEDs fans diagonally with no crossings. D4's R/G/B cathodes sit just below
    U1's matching outputs. U1 is between D4 and D2, with R4 on the red output and
    C1 beside the VDD pin. D1, R1, C2 and R2 sit above the header pin rows.
  - Routed with Freerouting 2.4.1: 4 vias. +12V and GND are 0.4 mm (a Power
    netclass), because up to ~0.4 A passes through to the rest of the chain.
    Signals are 0.2 mm. VDD narrows to 0.15 mm around U1, and the board minimum
    is set to 0.15 mm to allow it.
  - DRC: 0 errors, 0 unconnected. JLCPCB's limits are enforced by
    `pixel.kicad_dru` and the board setup.
  - Routing workflow: export the DSN with KiCad's Python module
    (`pcbnew.ExportSpecctraDSN`). Route with Freerouting's bundled launcher,
    because the standalone jar needs Java 25. Import the session in KiCad with
    File -> Import -> Specctra Session. Konnect's own DSN export refuses this
    board (round outline, back-side headers, custom rules).
  - **TBD:** revisit the header positions once real plugs are measured.
- The connector, the holder, or both SHOULD let the cables make the turn into the
  channel without stressing the connectors or their solder joints.

### Base station

- For prototyping, we will buy an off-the-shelf WLED controller instead of designing
  one, so the effort goes into the Pixel PCB. A custom base station is deferred. The
  requirements below still apply to whatever we use. The prototype controller is the
  QuinLED Dig-Quad (pre-assembled): 4 level-shifted outputs, 12 V capable, and a
  plug-in fuse per pair of outputs, which should be sized to protect the servo cables.
- For the prototype, each chain connects to the Dig-Quad's screw terminals using a
  servo extension cable cut in half, with the ends stripped. This is an accepted
  exception to the no-built-cables rule, since it needs no soldering or crimping.
- The base station does not have any sizing constraints.
- It MUST be compatible with [WLED](https://kno.wled.ge/) (ESP32-based), so we can get
  started quickly. Custom firmware is a future goal and is out of scope for now.
- Because of that, the LED or driver IC on the Pixel PCB MUST be one of the LED
  types WLED supports.
- The WS2814 data input needs a logic-high of at least 0.7 x VDD (about 3.5 V), which
  is above the ESP32's 3.3 V. Each chain output MUST go through a 5 V level shifter
  (for example 74AHCT125) and a series resistor.
- It MUST have enough chain outputs for the chosen topology (about 4).
- No extra features, such as sensors or current monitoring, are required.

### Manufacturing

- Both boards SHOULD be assembled by JLCPCB, as completely as possible, including the
  connectors. Hand soldering MUST be kept to a minimum.
- Minimize cost per house, but pay for factory assembly rather than hand work where
  there is a trade-off.
