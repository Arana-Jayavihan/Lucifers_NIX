{ lib, opt, ... }:
{
  # Host-specific modules to enable, listed in hosts/<host>/options.nix as
  # `enableModules`. Each entry is a dotted NixOS option path whose `.enable`
  # is set to true, e.g. "services.tailscale", "programs.steam",
  # "hardware.bluetooth". This is the services analogue of `systemPackages`.
  config = lib.mkMerge (map
    (path: lib.setAttrByPath (lib.splitString "." path ++ [ "enable" ]) true)
    (opt.enableModules or [ ]));
}
