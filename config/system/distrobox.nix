{ config, lib, pkgs, opt, ... }:

let inherit (opt) distrobox; in
lib.mkIf (distrobox == true) {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  environment.systemPackages = [pkgs.distrobox];
}
