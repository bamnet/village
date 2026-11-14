#!/bin/sh
# Re-slice the coupon package for the Ender 3 Pro in PETG.
# Needs PrusaSlicer (Debian package `prusa-slicer`, 2.9.2 used) and python3.
# Run from anywhere; writes the flattened presets here and the G-code one
# folder up. Check the result against MANIFEST.md's checksums.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
pkg=$(dirname "$here")
vendor=${VENDOR_INI:-/usr/share/PrusaSlicer/profiles/Creality.ini}

python3 "$here/flatten_preset.py" "$vendor" printer "Creality Ender-3 Pro (0.4 mm nozzle)" > "$here/printer_ender3pro.ini"
python3 "$here/flatten_preset.py" "$vendor" print "0.20 mm NORMAL (0.4 mm nozzle) @CREALITY" > "$here/print_0.20mm_normal.ini"
python3 "$here/flatten_preset.py" "$vendor" filament "Generic PETG @CREALITY" > "$here/filament_generic_petg.ini"

base="--load $here/printer_ender3pro.ini --load $here/print_0.20mm_normal.ini --load $here/filament_generic_petg.ini --load $here/coupon_overrides.ini"
# shellcheck disable=SC2086
prusa-slicer $base --export-gcode -o "$pkg/coupon_PETG_0.2mm_E3PRO.gcode" "$pkg/coupon.stl"
# shellcheck disable=SC2086
prusa-slicer $base --load "$here/test_rings_overrides.ini" --export-gcode -o "$pkg/test_rings_PETG_0.3mm_E3PRO.gcode" "$pkg/test_rings.stl"
