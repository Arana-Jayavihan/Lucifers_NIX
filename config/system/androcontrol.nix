{ inputs, ... }:
{
  # AndroControl is provided by its own flake (inputs.androcontrol). The flake
  # ships a NixOS module that defines the `services.androcontrol` options, the
  # systemd unit, a dedicated user, and the uinput udev rule.
  imports = [ inputs.androcontrol.nixosModules.default ];

  services.androcontrol = {
    enable = true;
    # Default port 5050 is already opened via `firewallPorts` in options.nix,
    # so we leave `openFirewall` at its default (false) to avoid duplication.
  };
}
