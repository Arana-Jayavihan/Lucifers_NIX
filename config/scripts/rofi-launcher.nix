{ pkgs }:

pkgs.writeShellScriptBin "rofi-launcher" ''
  set -euo pipefail

  # Toggle: if rofi is already open, close it; otherwise launch the app menu.
  if ${pkgs.procps}/bin/pgrep -x rofi >/dev/null; then
    ${pkgs.procps}/bin/pkill -x rofi
    exit 0
  fi

  exec ${pkgs.rofi}/bin/rofi -show drun
''
