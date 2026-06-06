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
}
