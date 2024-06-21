{ pkgs, ... }:
{
  environment.systemPackages = let 
    schemer = pkgs.callPackage ../pkgs/schemer.nix {};
    autopalette = pkgs.callPackage ../pkgs/autopalette.nix {};
  in [
    schemer.schemer
    autopalette.autopalette
  ];
}
