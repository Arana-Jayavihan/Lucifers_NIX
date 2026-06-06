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
  browser = "firefox";
  localHWClock = false;
}
