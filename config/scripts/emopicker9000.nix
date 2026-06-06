{ pkgs }:

pkgs.writeShellScriptBin "emopicker9000" ''
  set -euo pipefail

  # Pick an emoji from ~/.emoji via rofi.
  #   emopicker9000           copy the emoji to the clipboard
  #   emopicker9000 --type    type the emoji into the focused window
  case "''${1:-}" in
    -h|--help)
      echo "Usage: emopicker9000 [--type]"
      echo "  (no args)  copy the chosen emoji to the clipboard"
      echo "  --type     type the chosen emoji via ydotool"
      exit 0 ;;
  esac

  emoji_file="$HOME/.emoji"
  if [ ! -f "$emoji_file" ]; then
    ${pkgs.libnotify}/bin/notify-send "emopicker9000" "Emoji file not found: $emoji_file" || true
    exit 1
  fi

  chosen=$(${pkgs.rofi}/bin/rofi -dmenu < "$emoji_file" | ${pkgs.gawk}/bin/awk '{print $1}') || true
  [ -n "$chosen" ] || exit 0

  if [ "$#" -ge 1 ]; then
    ${pkgs.ydotool}/bin/ydotool type "$chosen"
  else
    printf '%s' "$chosen" | ${pkgs.wl-clipboard}/bin/wl-copy
    ${pkgs.libnotify}/bin/notify-send "'$chosen' copied to clipboard." &
  fi
''
