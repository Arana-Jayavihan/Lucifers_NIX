{ pkgs, username, wallpaperDir, wallpaperGit }:

pkgs.writeShellScriptBin "wallsetter" ''
  # Wallpaper rotation daemon. Resilient by design (no `set -e`).
  set -uo pipefail

  NOTIFY="${pkgs.libnotify}/bin/notify-send"
  wallpaperDir="${wallpaperDir}"

  TIMEOUT=1200
  TRANSITION1="--transition-type wave --transition-angle 120 --transition-step 30"
  TRANSITION2="--transition-type wipe --transition-angle 30 --transition-step 30"
  TRANSITION3="--transition-type center --transition-step 30"
  TRANSITION4="--transition-type outer --transition-pos 0.3,0.8 --transition-step 30"
  TRANSITION5="--transition-type wipe --transition-angle 270 --transition-step 30"

  pick_wallpaper() {
    ${pkgs.findutils}/bin/find "$wallpaperDir" -type f \
      | ${pkgs.gawk}/bin/awk '!/\/\.git\//' \
      | ${pkgs.coreutils}/bin/shuf -n 1
  }

  # Ensure the wallpaper directory exists and is a git checkout.
  if [ -d "$wallpaperDir" ]; then
    num_files=$(${pkgs.findutils}/bin/find "$wallpaperDir" -type f | ${pkgs.coreutils}/bin/wc -l)
    if [ "$num_files" -lt 1 ]; then
      "$NOTIFY" -t 9000 "wallsetter" "The wallpaper folder is empty. Exiting." || true
      exit 1
    fi
    if [ -d "$wallpaperDir/.git" ]; then
      ${pkgs.git}/bin/git -C "$wallpaperDir" pull || true
    else
      "$NOTIFY" -t 9000 "wallsetter" "Wallpaper dir is not a git repository. Exiting." || true
      exit 1
    fi
  else
    ${pkgs.git}/bin/git clone "${wallpaperGit}" "$wallpaperDir" || {
      "$NOTIFY" -t 9000 "wallsetter" "Failed to clone wallpaper repo. Exiting." || true
      exit 1
    }
    ${pkgs.coreutils}/bin/chown -R "${username}:users" "$wallpaperDir" 2>/dev/null || true
  fi

  WALLPAPER=$(pick_wallpaper)
  PREVIOUS="$WALLPAPER"

  while true; do
    if [ "$WALLPAPER" = "$PREVIOUS" ]; then
      WALLPAPER=$(pick_wallpaper)
    else
      PREVIOUS="$WALLPAPER"
      case "$(${pkgs.coreutils}/bin/shuf -e 1 2 3 4 5 -n 1)" in
        1) TRANSITION="$TRANSITION1" ;;
        2) TRANSITION="$TRANSITION2" ;;
        3) TRANSITION="$TRANSITION3" ;;
        4) TRANSITION="$TRANSITION4" ;;
        5) TRANSITION="$TRANSITION5" ;;
        *) TRANSITION="$TRANSITION1" ;;
      esac
      # TRANSITION is intentionally unquoted (multiple awww flags).
      [ -n "$WALLPAPER" ] && ${pkgs.awww}/bin/awww img "$WALLPAPER" $TRANSITION || true
      sleep "$TIMEOUT"
    fi
  done
''
