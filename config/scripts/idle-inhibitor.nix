{ pkgs, ... }:

pkgs.writeShellScriptBin "idle-inhibitor" ''
HYPRIDLE_BIN="hypridle"
NOTIFY="${pkgs.libnotify}/bin/notify-send"

if pgrep -x "$HYPRIDLE_BIN" >/dev/null; then
  $NOTIFY "Idle Control 🍃" "Turning off hypridle 😴"
  pkill -x "$HYPRIDLE_BIN"
else
  $NOTIFY "Idle Control 🍃" "Turning on hypridle ☕"
  nohup "$HYPRIDLE_BIN" >/dev/null 2>&1 &
fi
''
