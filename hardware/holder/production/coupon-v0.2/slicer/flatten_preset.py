"""Print one PrusaSlicer vendor preset as a plain config ini.

PrusaSlicer's CLI does not apply vendor presets reliably (--printer-profile
silently falls back to "- default FFF -"), so slice.sh resolves each preset's
`inherits` chain here and passes the result with --load instead.

Usage: python3 flatten_preset.py VENDOR.ini KIND "PRESET NAME"
  KIND is printer, print or filament.
"""
import sys

path, kind, name = sys.argv[1:4]
sections, cur = {}, None
for line in open(path, encoding="utf-8"):
    line = line.rstrip("\n")
    if line.startswith("[") and line.endswith("]"):
        cur = line[1:-1]
        sections[cur] = {}
    elif cur and "=" in line and not line.lstrip().startswith("#"):
        k, v = line.split("=", 1)
        sections[cur][k.strip()] = v.strip()


def resolve(n):
    s = sections[f"{kind}:{n}"]
    out = {}
    # Later parents override earlier ones; the preset's own keys win.
    for parent in (p.strip() for p in s.get("inherits", "").split(";")):
        if parent:
            out.update(resolve(parent))
    out.update(s)
    return out


cfg = resolve(name)
# Preset-system keys that mean nothing in a plain config.
for k in ("inherits", "renamed_from", "printer_model", "printer_variant", "alias",
          "compatible_printers_condition", "compatible_prints_condition"):
    cfg.pop(k, None)
print(f"# Flattened from {path}, [{kind}:{name}]")
for k, v in cfg.items():
    print(f"{k} = {v}")
