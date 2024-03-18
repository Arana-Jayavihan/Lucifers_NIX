{ config, lib, pkgs, ... }:

let inherit (import ../../../options.nix) theKernel; in
lib.mkIf (theKernel == "lqx") {
  boot.kernelPackages = pkgs.linuxPackages_lqx;
}
