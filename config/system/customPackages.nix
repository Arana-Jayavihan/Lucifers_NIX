{ pkgs, ... }:
{
  environment.systemPackages = let 
    schemer = pkgs.callPackage ../pkgs/schemer.nix {};
    btledctl = pkgs.callPackage ../pkgs/btledctl/btledctl.nix {};
    autosubtitle = pkgs.callPackage ../pkgs/autosubtitle/autosubtitle.nix {};
    androcontrol = pkgs.callPackage ../pkgs/androcontrol/andro-control.nix {};
  in [
    schemer.schemer
    btledctl.btledctl
    autosubtitle
    androcontrol.androcontrol
  ];
}
