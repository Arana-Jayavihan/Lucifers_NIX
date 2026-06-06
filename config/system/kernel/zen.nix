{ config, lib, pkgs, opt, ... }:

lib.mkIf (opt.theKernel == "zen") {
  boot.kernelPackages = pkgs.linuxPackages_zen;
}
