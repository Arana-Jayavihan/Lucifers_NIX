{ pkgs, config, lib, opt, ... }:

let inherit (opt) logitech; in
lib.mkIf (logitech == true) {
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
}
