# Host "hardware" for `mordor` (DigitalOcean droplet, morph target `hell`).
# Unlike the desktop hosts this is not a generated nixos-hardware file; the
# DigitalOcean module supplies the bootloader/disk/network plumbing, and
# do-userdata.nix (written into the droplet from DO user-data) is imported
# when present.
{ modulesPath, lib, ... }:

{
  imports =
    lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix
    ++ [ (modulesPath + "/virtualisation/digital-ocean-config.nix") ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
