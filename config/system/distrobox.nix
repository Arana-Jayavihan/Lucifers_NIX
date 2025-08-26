{ config, lib, pkgs, ... }:

let inherit (import ../../options.nix) distrobox; in
lib.mkIf (distrobox == true) {
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };
  environment.systemPackages = [pkgs.distrobox];
}
