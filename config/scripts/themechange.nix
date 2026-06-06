{ pkgs, flakeDir, ... }:

pkgs.writeShellScriptBin "themechange" ''
  set -euo pipefail

  case "''${1:-}" in
    -h|--help)
      echo "Usage: themechange <theme-name>"
      echo "Apply a base16 theme (disables wallpaper colors) and rebuild."
      exit 0 ;;
  esac

  if [ "$#" -eq 0 ] || [ -z "''${1:-}" ]; then
    echo "Error: no theme given." >&2
    echo "Usage: themechange <theme-name>" >&2
    exit 1
  fi

  replacement="$1"
  # Restrict to safe characters (also prevents sed-replacement injection).
  if ! [[ "$replacement" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Error: invalid theme name '$replacement' (allowed: letters, digits, . _ -)." >&2
    exit 1
  fi

  flakeDir="${flakeDir}"
  ${pkgs.gnused}/bin/sed -i "s/useWallColors = .*;/useWallColors = false;/g" "$flakeDir/options.nix"
  ${pkgs.gnused}/bin/sed -i "/^\s*theme[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$replacement\"/" "$flakeDir/options.nix"

  export SHELL=/run/current-system/sw/bin/bash
  ${pkgs.kitty}/bin/kitty -e pkexec nixos-rebuild switch --flake "$flakeDir#$(< /etc/hostname)"
  ${pkgs.swaynotificationcenter}/bin/swaync-client -rs || true
''
