{ pkgs, ... }:

let 
  inherit (import ../../options.nix) flakeDir;
in
pkgs.writeShellScriptBin "themechange" ''
  if [[ ! $@ ]];then
    echo "No Theme Given"
  else
    replacement="$1"
    sed -i "s/useWallColors = .*;/useWallColors = false;/g" ${flakeDir}/options.nix
    sed -i "/^\s*theme[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$replacement\"/" ${flakeDir}/options.nix
    export SHELL=/run/current-system/sw/bin/bash && kitty -e pkexec nixos-rebuild switch --flake ${flakeDir}
    ${pkgs.swaynotificationcenter}/bin/swaync-client -rs
  fi
''
