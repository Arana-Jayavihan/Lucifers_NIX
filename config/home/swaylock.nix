{ pkgs, config, ... }:

let
  palette = config.colorScheme.palette;
in {
  home.file.".config/swaylock/config".text = ''
    daemonize
    indicator-caps-lock
    show-failed-attempts
    ignore-empty-password
    indicator-thickness=10
    indicator-radius=120
    hide-keyboard-layout
    image=~/.config/swaylock-bg.jpg
    ring-color=${palette.base0D}
    key-hl-color=06292FFF
    line-color=00000000
    inside-color=00000088
    inside-clear-color=00000088
    separator-color=00000000
    text-color=${palette.base05}
    text-clear-color=${palette.base05}
    ring-clear-color=${palette.base0D}
    font=Ubuntu
  '';
}
