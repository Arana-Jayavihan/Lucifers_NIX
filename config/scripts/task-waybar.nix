{ pkgs }:

pkgs.writeShellScriptBin "task-waybar" ''
  set -euo pipefail

  # Briefly wait, then toggle the notification center panel.
  sleep 0.1
  ${pkgs.swaynotificationcenter}/bin/swaync-client -t &
''
