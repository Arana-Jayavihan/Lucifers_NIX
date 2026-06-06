{ lib, pkgs-unstable, opt, ... }:

lib.mkIf (opt.gpuType == "nvidia") {
  boot.kernelModules = [ "nvidia_uvm" "nvidia_modeset" "nvidia_drm" "nvidia" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    forceFullCompositionPipeline = false;
    package = pkgs-unstable.linuxPackages_latest.nvidiaPackages.latest;

    #prime = {
    #  offload.enable = false;
    #  sync.enable = true;
    #
    #  # Make sure to use the correct Bus ID values for your system!
    #  amdgpuBusId = "${opt.amd-bus-id}";
    #  nvidiaBusId = "${opt.nvidia-bus-id}";
    #};
  };
}
