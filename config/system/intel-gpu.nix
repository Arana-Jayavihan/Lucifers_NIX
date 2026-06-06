{ pkgs, config, lib, opt, ... }:

lib.mkIf (opt.gpuType == "intel") {
  # OpenGL
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
