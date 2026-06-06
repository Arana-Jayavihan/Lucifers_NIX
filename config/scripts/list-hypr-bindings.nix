{ pkgs, ... }:

pkgs.writeShellScriptBin "list-hypr-bindings" ''
  set -euo pipefail

  # Parse the live, generated Hyprland Lua config so the list always reflects
  # whatever is currently active (interpolations and conditionals resolved).
  hyprConf="$HOME/.config/hypr/hyprland.lua"
  [ -f "$hyprConf" ] || { echo "hyprland config not found: $hyprConf" >&2; exit 1; }

  {
    # Static legend row explaining the modifier key.
    printf 'SUPER\nModifier key (Windows/Super) used for keybindings\n'

    ${pkgs.gawk}/bin/awk '
      /hl\.bind\(/ {
        line = $0

        # Description: text after the trailing "-- " comment, if present.
        # Greedy ".*" anchors to the LAST "-- " so command flags such as
        # "--startvm" or "--scaled" inside the action are not mistaken for it.
        desc = ""
        if (match(line, /.*-- +/)) {
          desc = substr(line, RSTART + RLENGTH)
          gsub(/[ \t]+$/, "", desc)
        }

        # Key combo: first argument to hl.bind(, up to the first ", ".
        sub(/.*hl\.bind\(/, "", line)
        sub(/, .*/, "", line)

        # Turn the Lua key expression into something human readable.
        gsub(/mod/, "SUPER", line)        # the local "mod" variable
        gsub(/\.\./, " ", line)           # drop Lua concatenation operators
        gsub(/"/, "", line)               # drop string quotes
        gsub(/\<key\>/, "[1-0]", line)    # workspace loop variable
        gsub(/  +/, " ", line)            # collapse repeated spaces
        gsub(/^ +| +$/, "", line)         # trim ends
        gsub(/ +\+ +/, " + ", line)       # tidy spacing around "+"

        print line
        print desc
      }
    ' "$hyprConf"
  } | ${pkgs.yad}/bin/yad \
    --width=800 --height=650 --center --fixed \
    --title="Hyprland Keybindings" \
    --list --column="Key:" --column="Description:" \
    --timeout=120 --timeout-indicator=right
''
