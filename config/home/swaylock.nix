{ pkgs, config, ... }:

let
  palette = config.colorScheme.palette;
  inherit (import ../../options.nix) curWallPaper;
in {
  home.file.".config/swaylock/config".text = ''
    daemonize
    clock
    indicator
    datestr=%a, %B %e
    timestr=%I:%M %p
    effect-blur=5x5
    indicator-caps-lock
    show-failed-attempts
    ignore-empty-password
    indicator-thickness=10
    indicator-radius=120
    hide-keyboard-layout
    image=${curWallPaper}
    ring-color=${palette.base0D}
    key-hl-color=${palette.base00}
    line-color=00000000
    inside-color=00000088
    inside-clear-color=00000088
    separator-color=00000000
    ring-ver-color=${palette.base04}
    inside-ver-color=00000000
    text-color=${palette.base05}
    text-ver-color=${palette.base05}
    text-clear-color=${palette.base05}
    bs-hl-color=${palette.base0F}
    ring-clear-color=${palette.base0F}
    font=Ubuntu
  '';
}
