{ pkgs, flakeDir }:

pkgs.writeShellScriptBin "nixInstall" ''
    set -euo pipefail

    flakeDir="${flakeDir}"

    printHelp () {
      cat <<'EOF'
  nixInstall - add packages to the NixOS flake and rebuild.

  Usage:
    nixInstall <mode> <package> [package...]   Install one or more packages
    nixInstall restore                         Restore system.nix from the last backup
    nixInstall -h | --help                     Show this help

  Modes:
    user           ->  #USER_PKG       (home, unstable)
    system         ->  #SYSTEM_PKG     (system, unstable)
    user-stable    ->  #STABLE_USER    (home, stable)
    system-stable  ->  #STABLE_SYSTEM  (system, stable)

  Notes:
    * Verify package names on https://search.nixos.org first.
    * 'restore' only reverts the single most recent change.
  EOF
    }

    # Allow only safe package-name characters (prevents sed-replacement injection).
    valid_pkg () { [[ "$1" =~ ^[a-zA-Z0-9._-]+$ ]]; }

    addPkg () {
      # $1 = marker comment, $2 = package name
      ${pkgs.gnused}/bin/sed -i "s/$1/$2\\n\\t$1/" "$flakeDir/system.nix"
    }

    rm -f "$HOME"/.mozilla/firefox/lucifer/search.json.mozlz4.backup 2>/dev/null || true
    rm -f "$HOME"/.mozilla/firefox/Guest/search.json.mozlz4.backup 2>/dev/null || true
    rm -f "$HOME"/.mozilla/firefox/lucifer-work/search.json.mozlz4.backup 2>/dev/null || true

    if [ "$#" -eq 0 ]; then
      echo "Error: no mode/packages specified." >&2
      printHelp
      exit 1
    fi

    case "$1" in
      -h|--help)
        printHelp; exit 0 ;;
      restore)
        if [ ! -f "$flakeDir/system.nix.bak" ]; then
          echo "Error: no backup (system.nix.bak) to restore." >&2
          exit 1
        fi
        cp "$flakeDir/system.nix.bak" "$flakeDir/system.nix"
        sudo nixos-rebuild switch --flake "$flakeDir#$(< /etc/hostname)"
        exit 0 ;;
    esac

    case "$1" in
      user)          marker="#USER_PKG" ;;
      system)        marker="#SYSTEM_PKG" ;;
      user-stable)   marker="#STABLE_USER" ;;
      system-stable) marker="#STABLE_SYSTEM" ;;
      *)
        echo "Error: invalid mode '$1'." >&2
        printHelp
        exit 1 ;;
    esac
    shift

    if [ "$#" -eq 0 ]; then
      echo "Error: no packages specified." >&2
      printHelp
      exit 1
    fi

    # Validate all package names before modifying system.nix.
    for pkg in "$@"; do
      if ! valid_pkg "$pkg"; then
        echo "Error: invalid package name '$pkg'." >&2
        exit 1
      fi
    done

    cp "$flakeDir/system.nix" "$flakeDir/system.nix.bak"
    for pkg in "$@"; do
      addPkg "$marker" "$pkg"
    done

    sudo nixos-rebuild switch --flake "$flakeDir#$(< /etc/hostname)"
''
