{ config, lib, pkgs, ... }:

let inherit (import ../../../options.nix) theKernel; in
lib.mkIf (theKernel == "latest") {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
