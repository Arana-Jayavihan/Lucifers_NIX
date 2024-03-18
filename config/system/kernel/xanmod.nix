{ config, lib, pkgs, ... }:

let inherit (import ../../../options.nix) theKernel; in
lib.mkIf (theKernel == "xanmod") {
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
