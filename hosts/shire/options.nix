# Host-specific options for `shire` (laptop: intel CPU + intel GPU).
# Merged on top of the shared ../../options.nix by the flake.
{
  hostname = "shire";

  # Hardware / drivers
  cpuType = "intel";
  gpuType = "intel";

  # Kernel: default, latest, lqx, xanmod, zen
  theKernel = "zen";

  # Per-host feature flags
  laptop = true;
  ollama = false;
  browser = "firefox-nightly";
  localHWClock = true;

  # Monitors (consumed by config/home/hyprland.nix). Each attrset maps directly
  # to a hl.monitor({...}) call; any keys you add (e.g. cm, transform) are passed
  # through. The entry with output = "" is the catch-all for unlisted outputs.
  monitors = [
    { output = "eDP-1"; mode = "1920x1080@60"; position = "0x0"; scale = 1; cm = "hdr"; }
    { output = "HDMI-A-1"; mode = "1920x1080@144"; position = "auto"; scale = 1; }
    { output = ""; mode = "preferred"; position = "auto"; scale = 1; }
  ];

  # Which workspaces are bound to which monitor (hl.workspace_rule).
  workspaceMonitors = {
    "eDP-1" = [ 1 3 5 7 9 ];
    "HDMI-A-1" = [ 2 4 6 8 10 ];
  };

  # Host-specific packages: lists of nixpkgs attribute paths (dotted paths such
  # as "jetbrains.idea-community" are allowed). Resolved against the system pkgs.
  systemPackages = [ ];
  userPackages = [ ];
}
