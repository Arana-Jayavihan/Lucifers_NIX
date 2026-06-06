{ config, lib, pkgs, opt, ... }:

lib.mkIf (opt.theKernel == "latest") {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
