{ pkgs, ... }:

pkgs.writeShellScriptBin "idle-inhibitor" ''
PIDFILE="/tmp/idle-block.pid"

if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    ${pkgs.libnotify}/bin/notify-send "Idle Control 🍃" "Turning off idle blocker 😴"
    kill $(cat "$PIDFILE")
    rm -f "$PIDFILE"
else
    ${pkgs.libnotify}/bin/notify-send "Idle Control 🍃" "Turning on idle blocker ☕"
    systemd-inhibit --what=idle:sleep:handle-power-key:handle-suspend-key:handle-hibernate-key:handle-lid-switch --mode=block --why="Toggle idle block" bash -c '
        while true; do sleep 60; done
    ' &
    echo $! > "$PIDFILE"
fi  
''
