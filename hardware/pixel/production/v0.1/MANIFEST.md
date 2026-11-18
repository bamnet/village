# Pixel PCB v0.1 — JLCPCB package

Status: **ordered 2026-11-07** (tag `pixel-v0.1`). Do not change these files.
A design change gets a new silkscreen version and a new folder.

## Source

- Design commit: `6c50502` (design files unchanged since then)
- `pixel.kicad_pcb` sha256 `990ad7e6a336a6a367b935dd27d177a6b77589a8c8bd5e12325c9acc50b7d195`
- `pixel.kicad_sch` sha256 `d1a92fbe0fe950afcc0ada40763c400027faf594202c1801a2f1884aec7bc9a7`
- Exported 2026-11-07 with KiCad 10.0.7 and Konnect 0.13.0
  (`export_manufacturing_package`, see the README for settings), using
  `../../jlcpcb_cpl_corrections.json` (U1 +270, D1 +180)

## Checks at export

- ERC 0. DRC 0 errors, 0 unconnected, 21 known warnings. Konnect
  `validate_for_manufacturing`: READY.
- BOM: 13 parts, 11 lines, all with LCSC numbers. CPL: 13 designators,
  J1/J2 bottom.
- F.Paste has 47 openings (all top SMD pads), and B.Paste is empty. 10 plated
  holes (4 vias, 6 header pins), no unplated holes. Board 20.05 mm across.

## Files

| File | Upload to | sha256 |
|---|---|---|
| `pixel-gerbers.zip` (contents of `gerbers/`) | PCB order | `e67999fe7ae5c5f48e412ce53392cb825c0240a6392519c25da7ecde340dcf7b` |
| `BOM-pixel.csv` | Assembly: BOM | `329fb71eb900b93ca07f0aa84125ac1d348f65f8ce248c8d7514a068fe367766` |
| `CPL-pixel.csv` | Assembly: CPL | `b570591aff24918e6c3cae0d36068e3800e1cd7b92f8f48418a611c4d79d4650` |

## Order

- Date: 2026-11-07
- JLCPCB order numbers: PCB `Y12-3347415A`, assembly `SMT026110860016`
- PCB: 5 pcs, FR-4, 2 layers, 1.6 mm, green with white silkscreen, FR4 TG135,
  LeadFree HASL, 1 oz, tented vias, 0.3 mm min via, ±0.2 mm outline, flying
  probe test, single PCB (no panel), no deburring. Mark on PCB: Remove Mark,
  so no order number is printed and the "JLCJLCJLCJLC" text is just silkscreen.
- Assembly: Economic, top side only, 5 pcs, tooling holes by JLCPCB, Confirm
  Parts Placement: Yes, parts by customer, high-temp paste.
- **J1/J2 are not assembled.** Economic assembly is single-sided and drops the
  bottom-side headers, and Standard (two sides) requires a board of at least
  70 mm. J1 (C492411) and J2 (C2897385) are hand-soldered from parts on hand.
  The uploaded BOM/CPL still list them; JLCPCB ignored the bottom-side lines.
- Placement preview: all 9 top-side lines matched their LCSC parts with no
  stock warnings. U1, D1 and D2–D4 orientations checked against the footprints
  and correct, so no rotations were changed by hand. D1 bought 10 and the LEDs
  15 (JLCPCB minimums/attrition).
- Cost: PCB $5.10, assembly $22.50, shipping $29.09, duties/taxes and fees
  $15.37, discount −$6.00. Total $66.06.

## Results

Bring-up began 2026-11-17, following `../../bringup/README.md` and driven by an
Arduino running `bringup/pixel_bringup`. Power came from a bench supply at 12.0 V.
"Bench" readings are from the supply's own display. "Meter" readings are from a
multimeter in series. The supply is a cheap unit, so the meter is the reference.
The display reads about 0.5 mA lower than the meter at these currents. Treat bench
numbers as relative, good for comparing one channel with another, not as
absolute values.

### Function (2 boards)

- Both boards light and respond to data. Each channel lights all 3 LEDs, so the
  FSOP-8 (U1) and HL-5050RGBW (D2-D4) footprints work as drawn.
- The data byte order is **W, R, G, B**, as the datasheet says. In Adafruit
  NeoPixel it is `NEO_WRGB`. In WLED, select SK6812 RGBW and work out the
  matching color-order setting when the controller arrives.
- Chaining works, with each board addressed separately. With `n1` + `w`, only the
  first board lit. With `n2` + `c`, each board cycled in turn while the other
  stayed dark. This proves DOUT -> R3 -> J2 -> the next board's DIN.

### Current and VDD (one board, 12.0 V)

| State | Bench mA | Meter mA |
|---|---|---|
| Idle (`0`) | 2.47 | |
| `w` | 17.35 | 17.90 (after cooling) |
| `r` | 17.50 | |
| `g` | 17.26 | |
| `b` | 17.40 | |
| `a` (all four) | 58, slowly dropping | |
| `a`, 2 boards | 114 | |

- Per-channel LED current (reading minus idle): bench 14.8-15.0 mA, meter
  15.4 mA. The datasheet says 15.5 / 16.5 / 17.5 mA (min/typ/max) at 25 °C. The
  four channels agree to within 0.25 mA.
- With all four channels on, the current per channel is lower (about 13.9 mA
  bench) and drifts down as the chip warms.
- VDD = **5.235 V** at idle, measured at D1 pin 2 (the lower-left leg). It comes
  from the WS2814F's built-in regulator (datasheet p. 1). That is inside the
  4.5 - 5.5 V test range but only 65 mV below the 5.3 V absolute maximum.

### Heat (one board, `a` for 10 minutes)

- U1 was barely warm to the touch.
- `w` taken hot right afterward: 17.13 mA (meter, assumed). Against 17.90 mA
  after cooling, the LED current dropped from 15.4 to about 14.7 mA (about 5%)
  while hot.

### Headroom (one board, `w`, meter)

The LED current is the reading minus the idle current. The idle current is
taken as 2.47 mA at 12 V, falling 0.37 mA per volt as R1's current drops; that
part is calculated, not measured.

| Supply V | Meter mA | White LED mA | vs 12 V |
|---|---|---|---|
| 12.0 | 17.90 | 15.43 | — |
| 11.5 | 17.57 | 15.28 | -1% |
| 11.0 | 17.21 | 15.11 | -2% |
| 10.5 | 16.77 | 14.86 | -4% |
| 10.0 | 16.05 | 14.32 | -7% |
| 9.8 | 15.53 | 13.87 | -10% |
| 9.6 | 14.77 | 13.19 | -15% |
| 9.4 | 13.75 | 12.24 | -21% |
| 9.2 | 12.49 | 11.06 | -28% |
| 9.0 | 11.07 | 9.71 | -37% |

- There is no sharp cutoff. From 12 to about 10.5 V the current falls about
  0.3 mA per volt (2%/V). The knee is at about 10 V. Below it, the LEDs limit the
  current at about 6 mA per volt, which puts 3 white LEDs at roughly 9.5 - 10 V
  (about 3.2 - 3.3 V each).
- Rule: keep each house at **10.5 V or more** (white at most 4% dimmer). That
  allows 1.5 V of cable drop from 12 V.
- Blue was not swept, because blue is not a primary color for this project.

### Brightness (inside a real house, by eye, 2026-11-18)

- `w` at v255: definitely bright enough.
- v128: still bright enough, but less vibrant.
- v64: noticeably dimmer.
- The step from v255 to v128 looked much smaller than the step from v128 to v64,
  which is expected, since the eye responds roughly logarithmically.
- The sketch sends raw PWM duty (no gamma), so v128 is about 50% of full output.
- v170 (about what 2 LEDs would give at full) looked dimmer than v255. Decision: keep
  3 LEDs unless that becomes a blocker later.

### Protection: offset plug, 12 V on DATA_IN (2026-11-18)

Supply 12.0 V, OCP 100 mA (the supply won't go lower). No Arduino. DATA_IN was
jumpered to +12 V for about 1 minute.

| | Supply current | VDD at R1 (meter) |
|---|---|---|
| Baseline | 2.48 mA | 2.35 V (*suspect, see below*) |
| DATA_IN on +12 V | 7.70 mA | **6.12 V** |

- **Fail: VDD of 6.12 V is above the 5.3 V absolute maximum.** The board survived:
  nothing got hot, and `w` still worked afterward.
- The first baseline reading (2.35 V at R1) was a probe error. Re-measured at C1:
  **baseline 5.239 V; with DATA_IN on +12 V, VDD 6.132 V** and DIN 6.139 V.
  - DIN reading only 7 mV above VDD is unexplained. A BAT54S at about 5 mA should
    drop about 0.3 V, so the DIN probe may have landed on the VDD net.
- Datasheet (WS2814F V1.1, LCSC C5446694):
  - p.2 "maximum ratings" lists VDD +3.7 to +5.3 V.
  - p.3 specifies the electrical characteristics at VDD 4.5 - 5.5 V.
  - p.1: VDD has a built-in zener, fed through a series resistor.
  - p.5 application circuits: 2.7k at 12 V and 8.2k at 24 V, which is about
    2.3 - 2.5 mA of zener current *(est.)*. This fault pushed about 7.7 mA into
    the VDD node.
  - p.3: DIN input capacitance is at most 15 pF.
- R2 sizing: an external resistor in series with the on-board 1k R2, 12 V on
  DATA_IN, VDD at C1:

  | Total R in front of DIN | VDD | Current into the VDD node *(est.)* |
  |---|---|---|
  | none, DATA_IN open (baseline) | 5.239 V | 2.5 mA |
  | 1k (R2 only) | 6.126 V | 7.7 mA |
  | 2k (+1k) | 5.343 V | 5.7 mA |
  | 11k (+10k) | 5.243 V | 3.1 mA |

  VDD stays fairly flat up to about 5.7 mA, then climbs steeply. Interpolating
  between the 2k and 11k points gives about 5.27 V for **R2 = 4.7k** *(est.)*,
  which is inside the 5.3 V limit.
- Data check: with a 10k in series at DATA_IN (11k in front of DIN, the worst
  case), `w`, `r`, `g`, `b`, `a` and `c` all displayed correctly with no glitches.
  So 4.7k leaves plenty of timing margin.
- The 6.12 V reading does match the current *(est.)*. R1 carries about
  (12 − 6.12) / 2.7k = 2.2 mA, so R2 carries about 5.5 mA. That puts DIN at about
  6.5 V, one Schottky drop (about 0.36 V) above VDD. So the reading is believable.

### Protection: reversed plug (2026-11-18)

Board A powered normally from a 12.0 V supply (100 mA OCP) and driven by the
Arduino. Board B connected to A's J2 with its J1 reversed: B's GND to A's
DATA_OUT, B's DATA_IN to A's GND, +12 V straight. Meter in series between A's J2
pin 1 and B's J1 pin 3.

- Current into A's DATA_OUT: **1.74 mA** (README estimate about 2.6 mA, against
  DOUT's 10 mA minimum sink rating). **Pass.**
- The rest of B's roughly 2.5 mA supply current *(est.)* returns through B's D1
  and R2 into A's GND. The README predicted that split.
- Afterward, A and B both worked normally, alone and chained correctly.
- With R2 at 4.7k, less current takes the R2 path, so the DOUT current should rise
  toward about 2.5 mA *(est.)*. That's still well under 10 mA.
- Only one reversed board was tested. The README's worst case (one reversed house
  carrying 5 more downstream, about 16 mA) is still untested.

### Not yet tested

- Brightness side by side with the 2018 segment. It's no longer needed, since the
  in-house test passed.
- A 5-board chain, and a run of about 2 m to the first board.
- Boards 3 - 5: not yet inspected or powered.
