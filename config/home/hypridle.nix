{ pkgs, ... }:
let
  inherit (import ../../options.nix) username;
in
{
home.file.".config/hypr/hypridle.conf".text = ''
general {
  ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
  ignore_systemd_inhibit = false          # whether to ignore systemd-inhibit --what=idle inhibitors
}

listener {
  timeout = 300                            # 5min
  on-timeout = ${pkgs.swaylock-effects}/bin/swaylock  && ${pkgs.brightnessctl}/bin/brightnessctl -sd asus::kbd_backlight set 0
  on-resume = ${pkgs.libnotify}/bin/notify-send "Hi ${username} 🍃" "Welcome Back  ʕっ•ᴥ•ʔっ"  && ${pkgs.brightnessctl}/bin/brightnessctl -sd asus::kbd_backlight set 1
}

listener {
  timeout = 900                           # 15min
  on-timeout = ${pkgs.hyprland}/bin/hyprctl dispatch dpms off
  on-resume = ${pkgs.hyprland}/bin/hyprctl dispatch dpms on
}

listener {
  timeout = 1800
  on-timeout = systemctl suspend
}
'';
}
