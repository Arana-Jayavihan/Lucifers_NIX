{ pkgs, ... }:

pkgs.writeShellScriptBin "idle-inhibitor" ''
  set -euo pipefail

  # Toggle hypridle on/off.
  NOTIFY="${pkgs.libnotify}/bin/notify-send"

  if ${pkgs.procps}/bin/pgrep -x hypridle >/dev/null; then
    "$NOTIFY" "Idle Control 🍃" "Turning off hypridle 😴" || true
    ${pkgs.procps}/bin/pkill -x hypridle
  else
    "$NOTIFY" "Idle Control 🍃" "Turning on hypridle ☕" || true
    ${pkgs.coreutils}/bin/nohup ${pkgs.hypridle}/bin/hypridle >/dev/null 2>&1 &
    disown
  fi
''
