{ pkgs, lib, config, ... }:

let inherit (import ../../options.nix) 
  theKBDVariant 
  theKBDLayout 
  theSecondKBDLayout
  gnome
  ; in
{
  services.xserver = lib.mkMerge [
    {
      enable = true;
      xkb = {
        variant = "${theKBDVariant}";
        layout = "${theKBDLayout}, ${theSecondKBDLayout}";
      };
    }
    
    (lib.mkIf gnome {
      desktopManager.gnome.enable = true;
      desktopManager.gnome.extraGSettingsOverrides = ''
      [org.gnome.mutter]
      check-alive-timeout=60000
      '';
    })
  ];
  services.gnome.gnome-keyring.enable = gnome;
  services.displayManager = {
    enable = true;
    sddm = {
      enable = true;
      wayland = {
        enable = true;
      };
      #theme = "sddm-adaptive-theme";
      autoNumlock = true;
      theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";
      extraPackages = with pkgs.kdePackages; [
        qtsvg
        qtmultimedia
        qtvirtualkeyboard
      ];
    };
  };

  services.libinput.enable = true;

  environment.systemPackages =
let
    sugar = pkgs.callPackage ../pkgs/sddm-sugar-dark.nix {};
    tokyo-night = pkgs.libsForQt5.callPackage ../pkgs/sddm-tokyo-night.nix {};
    sddm-adaptive-theme = pkgs.callPackage ../pkgs/sddm-theme/default.nix { inherit pkgs; };
in [ 
    sugar.sddm-sugar-dark # Name: sugar-dark
    tokyo-night # Name: tokyo-night-sddm
    sddm-adaptive-theme # Name sddm-adaptive-theme
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];
}
