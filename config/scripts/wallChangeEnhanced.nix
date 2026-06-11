{ pkgs, wallpaperDir, flakeDir, username, terminal, ... }:

pkgs.writeShellScriptBin "wallchange" ''
    # Wallpaper / theme switcher. Resilient (no `set -e`) so a flaky LED or
    # notification call never aborts a rebuild mid-way.
    #
    # Run with no arguments for the interactive rofi flow: a thumbnail grid to
    # pick a wallpaper, then a second menu to choose between just setting it or
    # also regenerating the colour theme. Pass a filename (and optional flags)
    # to drive it non-interactively from the terminal.
    set -uo pipefail

    usage() {
      cat <<'EOF'
  Usage: wallchange [<wallpaper-file>] [-t|--theme] [--off]

    wallchange                 interactive: rofi picker, then pick an action
    wallchange wall95.jpg      set wallpaper live + persist (no rebuild)
    wallchange wall95.jpg -t   set wallpaper, regenerate the colour theme, rebuild
    wallchange wall95.jpg -p   preview the wallpaper's base16 palette in rofi
    wallchange --off           disable wallpaper colours and rebuild
  EOF
    }

    wallpaperDir="${wallpaperDir}"
    flakeDir="${flakeDir}"
    NOTIFY="${pkgs.libnotify}/bin/notify-send"
    cacheDir="''${XDG_CACHE_HOME:-$HOME/.cache}/wall-selector"

    # Resolve a wallpaper argument to an absolute path. Accepts an exact
    # filename in the wallpaper dir (what the rofi picker hands us), or a prefix
    # such as "wall95" for terminal convenience.
    resolve_wall() {
      local arg="$1" w
      if [ -f "$wallpaperDir/$arg" ]; then
        ${pkgs.coreutils}/bin/realpath "$wallpaperDir/$arg"
        return 0
      fi
      w=$(${pkgs.coreutils}/bin/ls "$wallpaperDir" \
        | ${pkgs.gnugrep}/bin/grep -E "^$arg(\..*)?$" \
        | ${pkgs.coreutils}/bin/head -n1)
      [ -n "$w" ] || return 1
      ${pkgs.coreutils}/bin/realpath "$wallpaperDir/$w"
    }

    # Persist the choice in options.nix and apply it live. No rebuild.
    set_wallpaper_only() {
      ${pkgs.gnused}/bin/sed -i "s#curWallPaper = .*;#curWallPaper = \"$1\";#g" "$flakeDir/options.nix"
      ${pkgs.awww}/bin/awww img "$1"
    }

    changeTheme() {
      ${pkgs.gnused}/bin/sed -i "s#curWallPaper = .*;#curWallPaper = \"$1\";#g" "$flakeDir/options.nix"
      ${pkgs.gnused}/bin/sed -i "s/useWallColors = false;/useWallColors = true;/g" "$flakeDir/options.nix"
      autopalette-apply "$1"
      # Also write an HTML swatch preview next to the generated palette so the
      # scheme can be eyeballed after a theme change. Uses the same extractor
      # (schemer2) and default mode (auto) as autopalette-apply, so it matches
      # custom.nix.
      autopalette generate --wallpaper "$1" --extractor schemer2 --format html \
        --out "$flakeDir/config/home/files/autopalette/palette.html" || true
      rm -f "$HOME"/.mozilla/firefox/lucifer/search.json.mozlz4.backup 2>/dev/null || true
      rm -f "$HOME"/.mozilla/firefox/Guest/search.json.mozlz4.backup 2>/dev/null || true
      rm -f "$HOME"/.mozilla/firefox/lucifer-work/search.json.mozlz4.backup 2>/dev/null || true
      sudo nixos-rebuild switch --flake "$flakeDir#$(< /etc/hostname)"
      ${pkgs.swaynotificationcenter}/bin/swaync-client -rs || true
      ags -q || true
      ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.exec_cmd("ags")' || true
      # Re-apply the wallpaper after the rebuild: the switch (and ags restart)
      # can reset what's on screen, so set it again to make it stick.
      ${pkgs.awww}/bin/awww img "$1" || true
      ledColor=$(${pkgs.coreutils}/bin/cat "$flakeDir/config/home/files/autopalette/custom.nix" \
        | ${pkgs.gnugrep}/bin/grep -i "base08" \
        | ${pkgs.coreutils}/bin/cut -d '"' -f 2 \
        | ${pkgs.findutils}/bin/xargs \
        | ${pkgs.coreutils}/bin/cut -d '#' -f 2 \
        | ${pkgs.findutils}/bin/xargs) || true
      # Drive the strip with base08 through the monitor-accurate sRGB -> PWM
      # transform (gamma decode + white balance), matching the BTLEDController
      # colour wheel. The `color` action applies this by default; `--gamma srgb`
      # states it explicitly (and no `--raw`, which would bypass it).
      [ -n "$ledColor" ] && btledctl 01:33:FF:FF:FF:FF color --color "#$ledColor" --gamma srgb || true
    }

    disable_colors() {
      ${pkgs.gnused}/bin/sed -i "s/useWallColors = true;/useWallColors = false;/g" "$flakeDir/options.nix"
      sudo nixos-rebuild switch --flake "$flakeDir#$(< /etc/hostname)"
      ${pkgs.swaynotificationcenter}/bin/swaync-client -rs || true
    }

    # Emit the rofi menu using the dmenu icon protocol: each row is
    # "<name>\0icon\x1f<thumbnail-path>", rendered as an icon with -show-icons.
    # Downscaled thumbnails are cached (regenerated only when missing or older
    # than the source) so rofi need not decode the full-res wallpapers each run.
    # The loop prints straight into rofi's stdin because the NUL separators the
    # protocol requires cannot survive a bash variable or command substitution.
    emit_menu() {
      local src name thumb
      for src in "$wallpaperDir"/wall*; do
        [ -f "$src" ] || continue
        name=$(${pkgs.coreutils}/bin/basename "$src")
        thumb="$cacheDir/$name.png"
        if [ ! -f "$thumb" ] || [ "$src" -nt "$thumb" ]; then
          # Read only the first frame ([0]). Without it, multi-frame sources
          # (animated GIFs etc.) make magick emit one PNG per frame -- never the
          # expected "$thumb" name -- so it would re-decode every frame on each
          # launch and stall the menu. Harmless for single-frame images.
          ${pkgs.imagemagick}/bin/magick "''${src}[0]" -thumbnail 500x300 "$thumb" 2>/dev/null || continue
        fi
        ${pkgs.coreutils}/bin/printf '%s\0icon\x1f%s\n' "$name" "$thumb"
      done
    }

    # Grid of large previews with the filename underneath. Inline -theme-str
    # overrides keep the shared config.rasi (the app launcher) untouched.
    pick_wallpaper() {
      ${pkgs.coreutils}/bin/mkdir -p "$cacheDir"
      emit_menu \
        | ${pkgs.rofi}/bin/rofi -dmenu -show-icons -p "Wallpaper" \
            -theme-str 'window { width: 70%; }' \
            -theme-str 'listview { columns: 4; lines: 3; }' \
            -theme-str 'element { orientation: vertical; }' \
            -theme-str 'element-icon { size: 8em; horizontal-align: 0.5; }' \
            -theme-str 'element-text { horizontal-align: 0.5; }'
    }

    pick_action() {
      ${pkgs.coreutils}/bin/printf '%s\n' "Set wallpaper" "Set wallpaper + theme" "Preview palette" \
        | ${pkgs.rofi}/bin/rofi -dmenu -p "Action" \
            -theme-str 'window { width: 30%; }' \
            -theme-str 'listview { columns: 1; lines: 3; }'
    }

    # Generate the base16 palette for a wallpaper (without applying it) and show
    # the 16 colours as a 2x8 grid of swatches with their hex codes. Solid
    # colour swatches are rendered with magick and fed to rofi via the same icon
    # protocol as the wallpaper picker.
    preview_palette() {
      local wallPath="$1" tmp key hex
      "$NOTIFY" -t 2000 "wallchange" "Generating palette preview..." || true
      tmp=$(${pkgs.coreutils}/bin/mktemp -d) || return 1
      if ! autopalette generate --wallpaper "$wallPath" --extractor schemer2 \
             --format json > "$tmp/palette.json" 2>/dev/null; then
        "$NOTIFY" "wallchange" "Failed to generate palette." || true
        ${pkgs.coreutils}/bin/rm -rf "$tmp"
        return 1
      fi
      {
        while read -r key hex; do
          ${pkgs.imagemagick}/bin/magick -size 240x120 "xc:$hex" "$tmp/$key.png" 2>/dev/null || continue
          ${pkgs.coreutils}/bin/printf '%s\0icon\x1f%s\n' "$key  $hex" "$tmp/$key.png"
        done < <(${pkgs.jq}/bin/jq -r '.palette | to_entries[] | "\(.key) \(.value)"' "$tmp/palette.json")
      } | ${pkgs.rofi}/bin/rofi -dmenu -show-icons -p "Palette" \
            -theme-str 'window { width: 45%; }' \
            -theme-str 'listview { columns: 2; lines: 8; }' \
            -theme-str 'element-icon { size: 3em; }' >/dev/null || true
      ${pkgs.coreutils}/bin/rm -rf "$tmp"
    }

    THEME=false
    OFF=false
    PREVIEW=false
    WALLPAPER=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        -h|--help) usage; exit 0 ;;
        -t|--theme) THEME=true; shift ;;
        -p|--preview) PREVIEW=true; shift ;;
        --off) OFF=true; shift ;;
        -*) echo "Error: unknown option '$1'." >&2; usage; exit 1 ;;
        *) WALLPAPER="$1"; shift ;;
      esac
    done

    if [ "$OFF" = true ]; then
      disable_colors
      exit 0
    fi

    # Interactive flow: pick a wallpaper, then pick what to do with it.
    if [ -z "$WALLPAPER" ]; then
      if [ ! -d "$wallpaperDir" ]; then
        "$NOTIFY" "wallchange" "Wallpaper directory not found: $wallpaperDir" || true
        exit 1
      fi
      chosen=$(pick_wallpaper) || true
      [ -n "$chosen" ] || exit 0
      chosenPath=$(resolve_wall "$chosen") || {
        "$NOTIFY" "wallchange" "No wallpaper matching '$chosen'." || true
        exit 1
      }

      # Loop the action menu so previewing the palette returns here afterwards.
      while true; do
        action=$(pick_action) || true
        case "$action" in
          *Preview*) preview_palette "$chosenPath"; continue ;;
          # The theme path runs `sudo nixos-rebuild`, which needs a tty for the
          # password prompt and shows progress, so hand off to the CLI in a
          # terminal rather than running it under the (terminal-less) keybind.
          *theme*)   exec ${terminal} wallchange "$chosen" -t ;;
          "")        exit 0 ;;
          *)         WALLPAPER="$chosen"; break ;;
        esac
      done
    fi

    wallPath=$(resolve_wall "$WALLPAPER") || {
      "$NOTIFY" "wallchange" "No wallpaper matching '$WALLPAPER'." || true
      echo "Error: no wallpaper matching '$WALLPAPER'." >&2
      exit 1
    }

    if [ "$PREVIEW" = true ]; then
      preview_palette "$wallPath"
      exit 0
    fi

    if [ "$THEME" = true ]; then
      changeTheme "$wallPath"
    else
      set_wallpaper_only "$wallPath"
    fi
''
