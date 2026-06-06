{ pkgs, config, lib, opt, ... }:

lib.mkIf (opt.gpuType == "intel-amd") {
  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
      amdvlk
    ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
}
