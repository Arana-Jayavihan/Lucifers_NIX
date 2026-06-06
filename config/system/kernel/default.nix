{ config, lib, pkgs, opt, ... }:

lib.mkIf (opt.theKernel == "default") {
  boot.kernelPackages = pkgs.linuxPackages;
}
