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
- Each house MUST use one WS2814 as its driver (Worldsemi, SOP-12, JLCPCB/LCSC
  C965562). It is a 4-channel RGBW constant-current driver that WLED supports
  (configured as SK6812 RGBW type). Its outputs are fixed at 16.5 mA per channel,
  about 80% of the 2018 current. **TBD:** confirm this is bright enough.
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
  **TBD:** choose between them. The Honglitronic part is preferred.
- Heat is not expected to be a concern. The cut-up LED strip prototype ran without
  heat problems.

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
