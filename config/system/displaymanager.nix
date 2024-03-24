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
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages =
let
    sugar = pkgs.callPackage ../pkgs/sddm-sugar-dark.nix {};
    tokyo-night = pkgs.libsForQt5.callPackage ../pkgs/sddm-tokyo-night.nix {};
    firewatch-dark = pkgs.callPackage ../pkgs/sddm-firewatch.nix {};
in [ 
    sugar.sddm-sugar-dark # Name: sugar-dark
    tokyo-night # Name: tokyo-night-sddm
    firewatch-dark.sddm-firewatch # Name sddm-firewatch
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];
}
