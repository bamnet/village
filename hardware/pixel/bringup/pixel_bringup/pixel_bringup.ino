// Pixel PCB v0.1 bring-up driver for a 5 V Arduino (Uno, Nano, Mega, Leonardo).
//
// Needs the "Adafruit NeoPixel" library (Library Manager).
// Wiring (see ../README.md):
//   Arduino pin 6 -> Pixel J1 pin 1 (DATA_IN, the triangle-marked pin)
//   Arduino GND   -> Pixel J1 pin 3 (GND) AND bench supply negative
//   Bench supply +12 V -> Pixel J1 pin 2 (middle). Never connect 12 V to the Arduino.
//
// Serial Monitor at 115200 baud, line ending "Newline". Commands:
//   r g b w   one channel at full (all pixels), others off
//   a         all four channels at full
//   0         all off
//   n<k>      set pixel count, e.g. n5 (default 5)
//   v<k>      set level 0-255 for later r/g/b/w/a commands, e.g. v64 (default 255)
//   c         cycle W, R, G, B, off on each pixel in turn (chain test); any key stops
//
// The WS2814F sends its bytes as W, R, G, B (datasheet p. 4), which is
// Adafruit's NEO_WRGB order. If a channel lights the wrong color, the datasheet
// order is wrong: note which color lit and change PIXEL_ORDER.

#include <Adafruit_NeoPixel.h>

const uint8_t DATA_PIN = 6;
const uint16_t MAX_PIXELS = 30;
#define PIXEL_ORDER NEO_WRGB

Adafruit_NeoPixel strip(MAX_PIXELS, DATA_PIN, PIXEL_ORDER + NEO_KHZ800);
uint16_t count = 5;
uint8_t level = 255;

void fill(uint8_t r, uint8_t g, uint8_t b, uint8_t w) {
  strip.clear();
  for (uint16_t i = 0; i < count; i++) strip.setPixelColor(i, r, g, b, w);
  strip.show();
}

void report(const char *what) {
  Serial.print(what);
  Serial.print(" (pixels=");
  Serial.print(count);
  Serial.print(", level=");
  Serial.print(level);
  Serial.println(")");
}

void cycle() {
  Serial.println("cycling; send any key to stop");
  while (true) {
    for (uint16_t i = 0; i < count; i++) {
      const uint8_t steps[5][4] = {
          {0, 0, 0, level}, {level, 0, 0, 0}, {0, level, 0, 0}, {0, 0, level, 0}, {0, 0, 0, 0}};
      for (uint8_t s = 0; s < 5; s++) {
        strip.clear();
        strip.setPixelColor(i, steps[s][0], steps[s][1], steps[s][2], steps[s][3]);
        strip.show();
        delay(400);
        if (Serial.available()) {
          while (Serial.available()) Serial.read();
          fill(0, 0, 0, 0);
          Serial.println("stopped, all off");
          return;
        }
      }
    }
  }
}

void setup() {
  Serial.begin(115200);
  strip.begin();
  strip.show();  // all off
  Serial.println("Pixel v0.1 bring-up. Commands: r g b w a 0 n<k> v<k> c");
}

void loop() {
  if (!Serial.available()) return;
  String line = Serial.readStringUntil('\n');
  line.trim();
  if (line.length() == 0) return;
  char cmd = line.charAt(0);
  long arg = line.substring(1).toInt();
  switch (cmd) {
    case 'r': fill(level, 0, 0, 0); report("red"); break;
    case 'g': fill(0, level, 0, 0); report("green"); break;
    case 'b': fill(0, 0, level, 0); report("blue"); break;
    case 'w': fill(0, 0, 0, level); report("white"); break;
    case 'a': fill(level, level, level, level); report("all four"); break;
    case '0': fill(0, 0, 0, 0); report("off"); break;
    case 'n':
      if (arg >= 1 && arg <= MAX_PIXELS) { fill(0, 0, 0, 0); count = arg; report("count set, all off"); }
      else Serial.println("n must be 1-30");
      break;
    case 'v':
      if (arg >= 0 && arg <= 255) { level = arg; report("level set"); }
      else Serial.println("v must be 0-255");
      break;
    case 'c': cycle(); break;
    default: Serial.println("? commands: r g b w a 0 n<k> v<k> c");
  }
}
