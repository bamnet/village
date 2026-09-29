**Request:** Create circuit schematic and PCB design & layout.

**Project Goal**: Independently control 6 x RGBW LED boards using an ESP32 microcontroller.

# Module Diagram

# Modules

## LED Driver

For my prototyping, I’ve been using this TLC5947 breakout board from Adafruit and it works great: [https://www.adafruit.com/product/1429](https://www.adafruit.com/product/1429).

I’m open to other LED drivers as long as they allow me to control 24 channels (6 RGBW LEDs) @ \~12V. 

My code currently assumes the TLC5947 is connected as follows:

ESP IO5 \-\> TLC XLAT  
ESP IO18 \-\> TLC SCLK  
ESP IO19 \-\> TLC SIN

*Feel free to suggest alternative suitable pins if it makes the routing easier.*

## LED1 \- LED6

LEDS1-6 will be connected via [Molex 105310-2106](https://www.molex.com/molex/products/part-detail/pcb_headers/1053102106) with the following pinouts

| MOLEX Pin | LED1 | LED2 | LED3 | LED4 | LED5 | LED6 |
| :---: | ----- | ----- | ----- | ----- | ----- | ----- |
| **1** | \- | \- | \- | \- | \- | \- |
| **2** | OUT0 | OUT4 | OUT8 | OUT12 | OUT16 | OUT20 |
| **3** | OUT1 | OUT5 | OUT9 | OUT13 | OUT17 | OUT21 |
| **4** | **\+12V** | **\+12V** | **\+12V** | **\+12V** | **\+12V** | **\+12V** |
| **5** | OUT2 | OUT6 | OUT10 | OUT14 | OUT18 | OUT22 |
| **6** | OUT3 | OUT7 | OUT11 | OUT15 | OUT19 | OUT23 |

## ESP32

To avoid having to design an antenna and deal with certification, a module like **ESP32-WROOM-32E** can be used.

## Power

Each LED requires \~12V.  The ESP32 requires 3.3V \- 5V.

*Open Question: Could this be powered by a USB C charger or does it have to use a regular DC Power connector?*

# Prototype

