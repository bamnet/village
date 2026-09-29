# VIllage Electric Light Department

_(vilage, for short)_

## Background

I have a collection of 1-2 dozen Department 56 lighted Christmas houses. The default
lighting solution has a big problem though: a house is either lit or not. Further,
thhe default technique of daisey-chaining all of the plugs together means the entire
village is typically on or off.

This is not very realistic, our winter Dickens Village is not North Korea.

## Goal

The Village Electic Light Department provides the ability for each house to be
individually dimmed and to have that brightness vary throughout the night. This
enables much more custom and realistic displays, with each house following it's
own lighting pattern throughout the night and across different nights.

### Details

#### Lighting

As a winter village, each house MUST be lit using warm white light. Each house MAY
support RGB to fine tune the colors and do neat patterns.

The light should be bright, historically using a 5 - 6 watt C7 bulb @ 120 volts.
We obviously want to modernize this with an LED.

## Approach

### 2018?

In 2018 we built our first prototype. To do this, we bought an RGB LED strip and cut
it into individual segments. We soldered wires onto each segment, and wired them all
back into a TLC5947 controlled by an ESP32.

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
