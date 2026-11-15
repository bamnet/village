; Hotend PID autotune for PETG, Ender 3 Pro (Marlin 2.0.x).
; Print this file once from the SD card, before the PETG prints, with the
; nozzle clean and nothing on the bed. It takes about 5 minutes.
;
; Marlin's stock PID values are tuned near PLA temperatures. At 235 - 240 C,
; with the part fan blowing, the hotend can lag far enough behind its target
; to trip thermal runaway. This tunes at 235 C with the fan at 40%, the
; middle of the prints' 30 - 50%, then saves the result to EEPROM.
M117 PID tune 235C...
M106 S102         ; part fan 40%
M303 E0 S235 C8 U1 ; tune hotend 0 at 235 C over 8 cycles, use the result
M500              ; save to EEPROM
M107              ; fan off
M104 S0           ; heater off
M117 PID tune saved
