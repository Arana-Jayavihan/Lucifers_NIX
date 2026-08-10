{ lib, config, opt, ... }:

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
    # Installs nvidia-suspend/hibernate/resume services that save & restore VRAM
    # across sleep. Required or the GUI (Hyprland/swaylock) comes back corrupted
    # after hibernate. finegrained is Optimus-only, leave off on this desktop.
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    forceFullCompositionPipeline = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
