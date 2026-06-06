{ config, lib, pkgs, opt, ... }:

lib.mkIf (opt.theKernel == "lqx") {
  boot.kernelPackages = pkgs.linuxPackages_lqx;
}
