{ config, lib, pkgs, ... }:

let inherit (import ../../../options.nix) theKernel; in
lib.mkIf (theKernel == "default") {
  boot.kernelPackages = pkgs.linuxPackages;
}
