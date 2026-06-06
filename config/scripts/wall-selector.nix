{ pkgs, wallpaperDir, ... }:

pkgs.writeShellScriptBin "wallSelector" ''
  set -euo pipefail

  wallpaperDir="${wallpaperDir}"
  if [ ! -d "$wallpaperDir" ]; then
    ${pkgs.libnotify}/bin/notify-send "wallSelector" "Wallpaper directory not found: $wallpaperDir" || true
    exit 1
  fi

  chosen=$(${pkgs.coreutils}/bin/ls "$wallpaperDir" \
    | ${pkgs.gnugrep}/bin/grep -E '^wall' \
    | ${pkgs.rofi}/bin/rofi -dmenu -p "Select a wallpaper") || true
  [ -n "$chosen" ] || exit 0

  if [ ! -f "$wallpaperDir/$chosen" ]; then
    ${pkgs.libnotify}/bin/notify-send "wallSelector" "No such wallpaper: $chosen" || true
    exit 1
  fi

  exec ${pkgs.awww}/bin/awww img "$wallpaperDir/$chosen"
''
