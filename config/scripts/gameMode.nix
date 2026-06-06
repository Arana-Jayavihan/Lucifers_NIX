{ pkgs, ... }:

pkgs.writeShellScriptBin "gamemode" ''
  set -euo pipefail

  # Toggle Hyprland eye-candy off (game mode) / restore via config reload.
  # Under the Lua config the legacy `keyword` IPC is rejected ("keyword can't
  # work with non-legacy parsers. Use eval."), so apply the overrides through a
  # single Lua `hl.config(...)` eval. getoption now prints the typed value
  # ("bool: true"), so match the boolean string rather than the legacy "1".
  HYPRGAMEMODE=$(${pkgs.hyprland}/bin/hyprctl getoption animations:enabled | ${pkgs.gawk}/bin/awk 'NR==1{print $2}')

  if [ "$HYPRGAMEMODE" = "true" ]; then
    ${pkgs.hyprland}/bin/hyprctl eval 'hl.config({ animations = { enabled = false }, decoration = { rounding = 0, blur = { enabled = false } }, general = { gaps_in = 0, gaps_out = 0, border_size = 1 } })'
    exit 0
  fi

  ${pkgs.hyprland}/bin/hyprctl reload
''
