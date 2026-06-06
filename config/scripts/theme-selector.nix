{ pkgs }:

pkgs.writeShellScriptBin "theme-selector" ''
  set -euo pipefail

  # Pick a base16 theme from ~/.base16-themes via rofi and apply it.
  #   theme-selector            apply with desktop notifications
  #   theme-selector --quiet    apply without notifications
  case "''${1:-}" in
    -h|--help)
      echo "Usage: theme-selector [--quiet]"
      exit 0 ;;
  esac

  themes_file="$HOME/.base16-themes"
  if [ ! -f "$themes_file" ]; then
    ${pkgs.libnotify}/bin/notify-send "theme-selector" "Themes file not found: $themes_file" || true
    exit 1
  fi

  chosen=$(${pkgs.rofi}/bin/rofi -dmenu -p "Select a theme:" < "$themes_file") || true
  [ -n "$chosen" ] || exit 0

  if [ "$#" -ge 1 ]; then
    themechange "$chosen"
  else
    ${pkgs.libnotify}/bin/notify-send "$chosen is building, please wait" &
    themechange "$chosen"
    ${pkgs.libnotify}/bin/notify-send "Theme: $chosen has been applied." &
  fi
''
