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
      theme = "firewatch2";
    };
  };

  environment.systemPackages =
let
    sugar = pkgs.callPackage ../pkgs/sddm-sugar-dark.nix {};
    tokyo-night = pkgs.libsForQt5.callPackage ../pkgs/sddm-tokyo-night.nix {};
    #firewatch = pkgs.callPackage ../pkgs/sddm-firewatch-theme.nix {};
    firewatch2 = pkgs.callPackage ../pkgs/sddm-firewatch-theme-2.nix {};

in [ 
    sugar.sddm-sugar-dark # Name: sugar-dark
    tokyo-night # Name: tokyo-night-sddm
    #firewatch.sddm-firewatch-theme # Name firewatch
    firewatch2.sddm-firewatch-theme-2
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];
}
