{ pkgs, config, ... }:

let inherit (import ../../options.nix) theKBDVariant
theKBDLayout theSecondKBDLayout; in
{
  services.xserver = {
    enable = true;
    xkb = {
      variant = "${theKBDVariant}";
      layout = "${theKBDLayout}, ${theSecondKBDLayout}";
    };
    libinput.enable = true;
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
      theme = "sddm-firewatch";
    };
  };

  environment.systemPackages =
let
    sugar = pkgs.callPackage ../pkgs/sddm-sugar-dark.nix {};
    tokyo-night = pkgs.libsForQt5.callPackage ../pkgs/sddm-tokyo-night.nix {};
    firewatch = pkgs.callPackage ../pkgs/sddm-firewatch-theme.nix {};
    firewatch-dark = pkgs.callPackage ../pkgs/sddm-firewatch.nix {};
in [ 
    sugar.sddm-sugar-dark # Name: sugar-dark
    tokyo-night # Name: tokyo-night-sddm
    firewatch.sddm-firewatch-theme # Name firewatch
    firewatch-dark.sddm-firewatch
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];
}
