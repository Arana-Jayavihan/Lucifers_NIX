{ pkgs, ... }:

pkgs.writeShellScriptBin "batteryNotify" ''
  set -euo pipefail

  # Warn when discharging below 15%. No-op on machines without BAT0.
  bat=/sys/class/power_supply/BAT0
  [ -d "$bat" ] || exit 0

  capacity=$(${pkgs.coreutils}/bin/cat "$bat/capacity")
  state=$(${pkgs.coreutils}/bin/cat "$bat/status")

  # Guard against a non-numeric capacity reading.
  case "$capacity" in
    "" | *[!0-9]* ) exit 0 ;;
  esac

  if [ "$state" = "Discharging" ] && [ "$capacity" -lt 15 ]; then
    XDG_RUNTIME_DIR="/run/user/$(${pkgs.coreutils}/bin/id -u)"
    export XDG_RUNTIME_DIR
    export DISPLAY=:0
    ${pkgs.libnotify}/bin/notify-send -u critical "Low Battery 🪫" \
      "$capacity% remaining, please plug in the charger."
  fi
''
