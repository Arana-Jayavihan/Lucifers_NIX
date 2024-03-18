{ config, lib, pkgs, ... }:

let inherit (import ../../../options.nix) theKernel; in
lib.mkIf (theKernel == "zen") {
  boot.kernelPackages = pkgs.linuxPackages_zen;
}
