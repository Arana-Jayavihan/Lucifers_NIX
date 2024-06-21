{ pkgs, ... }:
{
  environment.systemPackages = let 
    schemer = pkgs.callPackage ../pkgs/schemer.nix {};
  in [
    schemer.schemer
  ];
}
