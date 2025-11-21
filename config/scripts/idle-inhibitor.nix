{ pkgs, ... }:

pkgs.writeShellScriptBin "idle-inhibitor" ''
SERVICE="idle-inhibit.service"

if systemctl --user is-active --quiet "$SERVICE"; then
  ${pkgs.libnotify}/bin/notify-send "Idle Control 🍃" "Turning off idle blocker 😴"
  systemctl --user stop "$SERVICE"
else
  ${pkgs.libnotify}/bin/notify-send "Idle Control 🍃" "Turning on idle blocker ☕"
  systemctl --user start "$SERVICE"
fi
''
