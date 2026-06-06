{ config, lib, pkgs, opt, ... }:

lib.mkIf (opt.theKernel == "xanmod") {
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
