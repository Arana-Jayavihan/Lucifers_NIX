# Host-specific options for `gondor` (PC: amd CPU + nvidia GPU).
# Merged on top of the shared ../../options.nix by the flake.
{
  hostname = "gondor";

  # Hardware / drivers
  cpuType = "amd";
  gpuType = "nvidia";

  # Only needed for hybrid (intel-nvidia) systems; harmless otherwise.
  nvidia-bus-id = "PCI:1:0:0";
  amd-bus-id = "PCI:14:0:0";

  # Kernel: default, latest, lqx, xanmod, zen
  theKernel = "latest";

  # Per-host feature flags
  laptop = false;
  ollama = true;
  browser = "firefox-nightly";
  localHWClock = false;

  # Monitors (consumed by config/home/hyprland.nix). Each attrset maps directly
  # to a hl.monitor({...}) call; any keys you add (e.g. cm, transform) are passed
  # through. The entry with output = "" is the catch-all for unlisted outputs.
  monitors = [
    { output = "DP-4"; mode = "1920x1080@144"; position = "0x0"; scale = 1; }
    { output = ""; mode = "preferred"; position = "auto"; scale = 1; }
  ];

  # Which workspaces are bound to which monitor (hl.workspace_rule).
  # Single-monitor host: nothing to route, everything lands on DP-4.
  workspaceMonitors = { };

  # Host-specific packages: lists of nixpkgs attribute paths (dotted paths such
  # as "jetbrains.idea-community" are allowed). Resolved against the system pkgs.
  systemPackages = [ ];
  userPackages = [ ];

  # Host-specific modules to enable: dotted NixOS option paths, each gets
  # `.enable = true` (e.g. "services.tailscale", "programs.steam").
  enableModules = [ "services.hardware.openrgb" ];
}
