{ pkgs, ... }:
{
  environment.systemPackages = let 
    schemer = pkgs.callPackage ../pkgs/schemer.nix {};
    btledctl = pkgs.callPackage ../pkgs/btledctl/btledctl.nix {};
    autosubtitle = pkgs.callPackage ../pkgs/autosubtitle/autosubtitle.nix {};
  in [
    schemer.schemer
    btledctl.btledctl
    autosubtitle
  ];
}
