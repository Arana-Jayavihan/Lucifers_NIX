{ pkgs, config, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = { "vm.max_map_count" = 2147483642; };
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "25%";

  # This is for OBS Virtual Cam Support - v4l2loopback setup
  boot.kernelModules = [ "v4l2loopback" "uinput" "i2c-dev" "i2c-piix4" "i2c_algo_bit" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
}
