# Pixel PCB v0.1 bring-up

A step-by-step checklist for the 5 boards from order `Y12-3347415A`. Each stage
goes from lowest to highest risk, so a fault shows up before it can damage
anything. Record results in `../production/v0.1/MANIFEST.md` → Results.

Expected values marked *(est.)* are calculations from the README, not
measurements. The bring-up exists to replace them with real numbers.

**Equipment:** bench supply (12 V, with current limit and display), multimeter,
a 5 V Arduino (Uno/Nano/Mega) with `pixel_bringup/pixel_bringup.ino`, Dupont
jumpers, servo cables.

Number the boards 1 - 5 with a marker on the bottom so results can be tracked.

## Header pins

| Pin | J1 (male, in) | J2 (female, out) |
|---|---|---|
| 1 (triangle) | DATA_IN | DATA_OUT |
| 2 (middle) | +12V | +12V |
| 3 | GND | GND |

## Stage 0: Look (all boards)

- [ ] Take close-up photos of the top and bottom of each board.
- [ ] U1: the chip's pin-1 mark is at the silkscreen dot. No bridges between its
      0.8 mm-pitch pins.
- [ ] D1 (SOT-23) sits square on its pads.
- [ ] D2 - D4: each LED's corner mark is at its silkscreen tick (the white cathode).
- [ ] No parts standing on end (tombstoned), missing, or shifted.

## Stage 1: Multimeter, no power (all boards)

Measure at the header holes.

- [ ] +12V to GND: no short. The reading may climb slowly as C2 charges.
- [ ] DATA_IN to GND: no short.
- [ ] DATA_OUT to GND: no short.
- [ ] R1 about 2.7k, R2 about 1k, R3 about 100 ohm. In-circuit readings may be a
      little low.

A board that fails any check sits out Stages 3 - 7 until it's understood.

## Stage 2: Headers

- [ ] Solder J1 (male) on at least 2 boards. Boards for chaining (Stage 6) also need
      J2. Only 3 joints per header.
- v0.1 can't take both servo plugs at once (rows 8.9 mm apart; plugs need 9.2 mm).
  Use a servo cable on one header and Dupont jumpers on the other.

## Stage 3: First power, no data (one board at a time)

Bench supply: 12.0 V, current limit **20 mA**, output off while wiring. Data pin
left unconnected.

- [ ] Supply current: about **2.6 - 3 mA** *(est.: (12 - VDD) / 2.7k)*.
      Anything above ~10 mA: turn off and investigate.
- [ ] VDD (C1, or the U1 end of R1) to GND: expected about 4.5 - 5 V. It **must not
      exceed 5.3 V** (datasheet absolute max).
- [ ] LEDs stay off.
- [ ] Nothing gets warm (touch U1, R1, D1 after 1 minute).

## Stage 4: Data and channel tests (one board)

Wiring: Arduino on USB only. Arduino pin 6 → J1 pin 1, Arduino GND → J1 pin 3
**and** bench supply negative (common ground). Bench +12 V → J1 pin 2. **Never
connect 12 V to the Arduino.** Raise the current limit to **100 mA**. Serial
Monitor 115200 baud, line ending "Newline".

| Command | Expected | Supply mA | All 3 LEDs same color? |
|---|---|---|---|
| `0` | off | ~3 *(est.)* | |
| `w` | warm white | ~19.5 (+16.5) *(est.)* | |
| `r` | red | ~19.5 | |
| `g` | green | ~19.5 | |
| `b` | blue | ~19.5 | |
| `a` | all four | ~69 *(est.)* | |

- [ ] Each channel lights the color you sent. If not, write down which color lit
      for each command; that gives the real byte order (sketch assumes W,R,G,B).
- [ ] Each channel adds about 16.5 mA (the WS2814's fixed output current).
- [ ] All 3 LEDs light in each channel. This proves the LED footprint and
      orientation. A dark channel on all 3 LEDs points at U1 or the order; a single
      dark LED points at that LED's solder or orientation.
- [ ] U1 lit and responding proves the FSOP-8 footprint (needed before
      contributing it upstream to KiCad).

**Headroom** (white and blue, the highest-voltage LEDs):

- [ ] With `w`, measure D4's white cathode (the pad at its corner mark) to GND at
      12.0 V: V = ____. This is the voltage left across U1's output.
- [ ] Same for `b` (D4 blue cathode): V = ____.
- [ ] With `a`, lower the supply in 0.25 V steps until the supply current drops
      below ~69 mA or a channel visibly dims. Dropout supply voltage = ____ V.
      This replaces the README's estimated ~1.5 V headroom with a real number.

**Heat:**

- [ ] `a` for 10 minutes. U1, R4 and the LEDs warm but comfortable to touch.

## Stage 5: Brightness

- [ ] `w` next to the 2018 LED-strip segment, by eye in a dim room.
- [ ] `w` inside a real house. Bright enough? (Settles the README open item on
      16.5 mA.)
- [ ] Try `v` levels (e.g. `v128`, `v64`) to see how much dimming range is useful.

## Stage 6: Chaining

- [ ] Board A J2 → board B J1 with a 1 m servo cable (Dupont for the power/ground
      to A if A's J1 plug can't fit). `n2`, then `c`: each board cycles in turn.
- [ ] Add boards up to 5, `n5`, `c`. Current limit 400 mA for `a` on 5 boards
      (~350 mA *(est.)*).
- [ ] Arduino → first board with about 2 m of cable (two 1 m cables joined).
      `c` still runs cleanly.
- [ ] Supply voltage at the last board's J2 with `a` on all 5: ____ V (cable drop).

## Stage 7: Protection tests (last; on one board you're willing to lose)

Pick the board that did worst in earlier stages, or board 5.

**Offset plug (12 V on the data pin):**

- [ ] Normal +12V/GND power, current limit 30 mA. Connect DATA_IN to +12V (no
      Arduino attached).
- [ ] VDD = ____ V. Pass: **≤ 5.3 V**.
- [ ] Extra supply current ≈ ____ mA (~7 mA *(est.)* through R2).
- [ ] After removing it, the board still works (repeat Stage 4 `w`).

**Reversed plug (downstream board plugged in backwards):**

- [ ] Board A (known good) powered and driven normally. Connect the test board B
      with its J1 reversed: B's GND pin to A's DATA_OUT, B's DATA_IN pin to A's GND,
      +12V in the middle as usual. Use an upstream Pixel board, **not** the Arduino.
- [ ] Measure the current into A's DATA_OUT (meter in series): ____ mA. The README
      estimates ~2.6 mA for one downstream board, and the datasheet rates DOUT
      sink at 10 mA minimum.
- [ ] Leave it 1 minute. Remove B and check A still drives a normal board.
- [ ] Plug B in correctly and check it still works.

## Afterwards

- Write the numbers into `MANIFEST.md` → Results, and update the README open
  items they settle (R2 value, brightness, headroom, footprints proven).
- Anything that should change goes into the Pixel PCB v0.2 feedback.
