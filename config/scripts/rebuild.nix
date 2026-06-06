{ pkgs, flakeDir, ... }:

pkgs.writeShellScriptBin "rebuild" ''
  set -euo pipefail

  case "''${1:-}" in
    -h|--help)
      echo "Usage: rebuild"
      echo "Stage changes and run 'nixos-rebuild switch' for this host's flake config."
      exit 0 ;;
  esac

  # Drop stale Firefox search-backup files (ignore if absent).
  rm -f "$HOME"/.mozilla/firefox/lucifer/search.json.mozlz4.backup 2>/dev/null || true
  rm -f "$HOME"/.mozilla/firefox/Guest/search.json.mozlz4.backup 2>/dev/null || true
  rm -f "$HOME"/.mozilla/firefox/lucifer-work/search.json.mozlz4.backup 2>/dev/null || true

  cd "${flakeDir}"

  # Flakes ignore untracked files, so stage everything first.
  ${pkgs.git}/bin/git add -A

  # Host-based flake: pick the config matching this machine's hostname.
  sudo nixos-rebuild switch --flake ".#$(< /etc/hostname)"
''
