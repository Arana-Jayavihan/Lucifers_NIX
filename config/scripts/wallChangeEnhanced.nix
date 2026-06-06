{ pkgs, wallpaperDir, flakeDir, username, ... }:

pkgs.writeShellScriptBin "wallchange" ''
    # Wallpaper / theme switcher. Resilient (no `set -e`) so a flaky LED or
    # notification call never aborts a rebuild mid-way.
    set -uo pipefail

    usage() {
      cat <<'EOF'
  Usage: wallchange [-t|--theme true|false] [wallpaper-id]

    wallchange 95              set wallpaper "wall95" live (no rebuild)
    wallchange -t true 95      set wallpaper and regenerate the color theme
    wallchange -t false        disable wallpaper colors and rebuild
  EOF
    }

    THEME="false"
    WALLPAPER=""
    wallpaperDir="${wallpaperDir}"
    flakeDir="${flakeDir}"

    resolve_wall() {
      local w
      w=$(${pkgs.coreutils}/bin/ls "$wallpaperDir" \
        | ${pkgs.gnugrep}/bin/grep -E "^wall$WALLPAPER(\..*)?$" \
        | ${pkgs.coreutils}/bin/head -n1)
      [ -n "$w" ] || return 1
      ${pkgs.coreutils}/bin/realpath "$wallpaperDir/$w"
    }

    changeTheme() {
      ${pkgs.gnused}/bin/sed -i "s#curWallPaper = .*;#curWallPaper = \"$1\";#g" "$flakeDir/options.nix"
      ${pkgs.gnused}/bin/sed -i "s/useWallColors = false;/useWallColors = $THEME;/g" "$flakeDir/options.nix"
      autopalette
      rm -f "$HOME"/.mozilla/firefox/lucifer/search.json.mozlz4.backup 2>/dev/null || true
      rm -f "$HOME"/.mozilla/firefox/Guest/search.json.mozlz4.backup 2>/dev/null || true
      rm -f "$HOME"/.mozilla/firefox/lucifer-work/search.json.mozlz4.backup 2>/dev/null || true
      sudo nixos-rebuild switch --flake "$flakeDir#$(< /etc/hostname)"
      ${pkgs.swaynotificationcenter}/bin/swaync-client -rs || true
      ags -q || true
      ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.exec_cmd("ags")' || true
      ledColor=$(${pkgs.coreutils}/bin/cat "$flakeDir/config/home/files/autopalette/custom.nix" \
        | ${pkgs.gnugrep}/bin/grep -i "base08" \
        | ${pkgs.coreutils}/bin/cut -d '"' -f 2 \
        | ${pkgs.findutils}/bin/xargs \
        | ${pkgs.coreutils}/bin/cut -d '#' -f 2 \
        | ${pkgs.findutils}/bin/xargs) || true
      [ -n "$ledColor" ] && btledctl 01:33:FF:FF:FF:FF color --color "$ledColor" || true
    }

    while [ "$#" -gt 0 ]; do
      case "$1" in
        -h|--help) usage; exit 0 ;;
        -t|--theme) THEME="''${2:-}"; shift 2 ;;
        *) WALLPAPER="$1"; shift ;;
      esac
    done

    if [ "$THEME" != "true" ] && [ "$THEME" != "false" ]; then
      echo "Error: --theme must be 'true' or 'false'." >&2
      exit 1
    fi

    if [ -n "$WALLPAPER" ] && ! [[ "$WALLPAPER" =~ ^[a-zA-Z0-9]+$ ]]; then
      echo "Error: invalid wallpaper id '$WALLPAPER' (letters/digits only)." >&2
      exit 1
    fi

    if [ "$THEME" = "true" ] && [ -z "$WALLPAPER" ]; then
      echo "Error: --theme true requires a wallpaper id." >&2
      exit 1
    fi

    if [ "$THEME" = "true" ] && [ -n "$WALLPAPER" ]; then
      wallPath=$(resolve_wall) || { echo "Error: no wallpaper matching '$WALLPAPER'." >&2; exit 1; }
      changeTheme "$wallPath"
    fi

    if [ "$THEME" = "false" ] && [ -z "$WALLPAPER" ]; then
      ${pkgs.gnused}/bin/sed -i "s/useWallColors = true;/useWallColors = $THEME;/g" "$flakeDir/options.nix"
      sudo nixos-rebuild switch --flake "$flakeDir#$(< /etc/hostname)"
      ${pkgs.swaynotificationcenter}/bin/swaync-client -rs || true
    fi

    if [ -n "$WALLPAPER" ]; then
      wallPath=$(resolve_wall) || { echo "Error: no wallpaper matching '$WALLPAPER'." >&2; exit 1; }
      ${pkgs.gnused}/bin/sed -i "s#curWallPaper = .*;#curWallPaper = \"$wallPath\";#g" "$flakeDir/options.nix"
      ${pkgs.awww}/bin/awww img "$wallPath"
    else
      echo "Use wallpaper theme set to false; no wallpaper specified."
    fi
''
