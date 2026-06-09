{ pkgs, lib, opt, ... }:
{
  environment.systemPackages =
    let
      schemer = pkgs.callPackage ../pkgs/schemer.nix { };
      autosubtitle = pkgs.callPackage ../pkgs/autosubtitle/autosubtitle.nix { };
      # Resolve a (possibly dotted) nixpkgs attribute path to a package.
      resolvePkg = name: lib.getAttrFromPath (lib.splitString "." name) pkgs;
    in
    [
      schemer.schemer 
      pkgs.btledctl
      autosubtitle
    ]
    # Host-specific system packages from hosts/<host>/options.nix.
    ++ map resolvePkg (opt.systemPackages or [ ]);
}
