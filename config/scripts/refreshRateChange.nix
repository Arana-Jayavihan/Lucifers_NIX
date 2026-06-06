{ pkgs, flakeDir, ... }:

pkgs.writeShellScriptBin "rateChanger" ''
  set -euo pipefail

  case "''${1:-}" in
    -h|--help)
      echo "Usage: rateChanger <refresh-rate>"
      echo "Set the monitor refresh rate (60-240 Hz) in hyprland.nix and rebuild."
      exit 0 ;;
  esac

  if [ "$#" -eq 0 ]; then
    echo "Error: please provide a refresh rate (60-240)." >&2
    exit 1
  fi

  rate="$1"
  if ! [[ "$rate" =~ ^[0-9]+$ ]]; then
    echo "Error: '$rate' is not an integer." >&2
    exit 1
  fi
  if [ "$rate" -lt 60 ] || [ "$rate" -gt 240 ]; then
    echo "Error: refresh rate must be within 60-240 Hz." >&2
    exit 1
  fi

  flakeDir="${flakeDir}"

  rm -f "$HOME"/.mozilla/firefox/lucifer/search.json.mozlz4.backup 2>/dev/null || true
  rm -f "$HOME"/.mozilla/firefox/Guest/search.json.mozlz4.backup 2>/dev/null || true
  rm -f "$HOME"/.mozilla/firefox/lucifer-work/search.json.mozlz4.backup 2>/dev/null || true

  # Lua config stores the mode as `mode = "1920x1080@144"`, so the rate is
  # bounded by a closing quote, not a comma as in the old hyprlang format.
  ${pkgs.gnused}/bin/sed -i "s/@[0-9]\+\"/@$rate\"/" "$flakeDir/config/home/hyprland.nix"
  sudo nixos-rebuild switch --flake "$flakeDir#$(< /etc/hostname)"
''
