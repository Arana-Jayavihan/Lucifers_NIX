{ pkgs, flakeDir, ... }:

pkgs.writeShellScriptBin "rebuild" ''
cd ${flakeDir}

# Git Add
git add .

# NixOS Rebuild
sudo nixos-rebuild switch --flake .
''
