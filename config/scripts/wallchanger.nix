{ pkgs, wallpaperDir }:

pkgs.writeShellScriptBin "wallchanger" ''
  wall=$(ls ${wallpaperDir} | grep "wall$1.jp")
  ${pkgs.swww}/bin/swww img ${wallpaperDir}/$wall 
''
