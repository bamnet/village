#!/bin/sh
# Re-slice the coupon-v0.3 package for the Ender 3 Pro (with BLTouch) in PETG.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
pkg=$(dirname "$here")
vendor=${VENDOR_INI:-/usr/share/PrusaSlicer/profiles/Creality.ini}

python3 "$here/flatten_preset.py" "$vendor" printer "Creality Ender-3 Pro (0.4 mm nozzle)" > "$here/printer_ender3pro.ini"
python3 "$here/flatten_preset.py" "$vendor" print "0.20 mm NORMAL (0.4 mm nozzle) @CREALITY" > "$here/print_0.20mm_normal.ini"
python3 "$here/flatten_preset.py" "$vendor" filament "Generic PETG @CREALITY" > "$here/filament_generic_petg.ini"
python3 "$here/flatten_preset.py" "$vendor" printer "*slowabl*" > "$here/printer_bltouch_start.ini"

base="--load $here/printer_ender3pro.ini --load $here/printer_bltouch_start.ini --load $here/print_0.20mm_normal.ini --load $here/filament_generic_petg.ini --load $here/coupon_overrides.ini"
# shellcheck disable=SC2086
prusa-slicer $base --export-gcode -o "$pkg/coupon_PETG_0.2mm_E3PRO.gcode" "$pkg/coupon.stl"
