{ config, pkgs, ... }:

{
  imports = [
    ./amd-gpu.nix
    ./androcontrol.nix
    ./appimages.nix
    ./boot.nix
    ./displaymanager.nix
    ./distrobox.nix
    ./flatpak.nix
    ./hwclock.nix
    ./intel-amd.nix
    ./intel-gpu.nix
    ./intel-nvidia.nix
    ./kernel.nix
    ./logitech.nix
    ./nfs.nix
    ./ntp.nix
    ./nvidia.nix
    ./ollama.nix
    ./packages.nix
    ./polkit.nix
    ./python.nix
    ./printer.nix
    ./services.nix
    ./steam.nix
    ./vm.nix
    ./customPackages.nix
  ];
}
