{ pkgs, ... }:
let
  inherit (import ../../home/files/autopalette/custom.nix) customPalette;
  inherit (import ../../../options.nix) username curWallPaper;
  palette = customPalette.palette; 
in  
pkgs.stdenv.mkDerivation {
  pname = "sddm-adaptive-theme";
  version = "V1";
  dontBuild = true;
  src = ./theme;

  installPhase = ''
    user=${username}
    mkdir -p $out/share/sddm/themes
    cp -R $src $out/share/sddm/themes/sddm-adaptive-theme
    chmod -R u+w $out/share/sddm/themes/sddm-adaptive-theme
    sed -i "s@^HeaderText=.*@HeaderText=\"Hello ''${user^} 🍃\"@g" $out/share/sddm/themes/sddm-adaptive-theme/theme.conf
    sed -i "s@^Background=.*@Background=\"${curWallPaper}\"@g" $out/share/sddm/themes/sddm-adaptive-theme/theme.conf
    sed -i "s@^MainColor=.*@MainColor=\"${palette.base08}\"@g" $out/share/sddm/themes/sddm-adaptive-theme/theme.conf
    sed -i "s@^AccentColor=.*@AccentColor=\"${palette.base0B}\"@g" $out/share/sddm/themes/sddm-adaptive-theme/theme.conf
    sed -i "s@^BackgroundColor=.*@BackgroundColor=\"${palette.base02}\"@g" $out/share/sddm/themes/sddm-adaptive-theme/theme.conf
    chmod -R u-w $out/share/sddm/themes/sddm-adaptive-theme
  '';
}

