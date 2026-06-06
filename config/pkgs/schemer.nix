{ pkgs, fetchgit, ... }:
let
  libvirt = pkgs.libvirt;
  libxml2 = pkgs.libxml2;
in
{
  schemer = pkgs.buildGoModule rec {
    pname = "schemer2";
    version = "2";
    vendorHash = null;
    env.CGO_ENABLED = 1;

    src = fetchgit {
      url = "https://github.com/Arana-Jayavihan/schemer2";
      hash = "sha256-Zo/bjBTHYAsGtJAi20ywwCYdqTPzBQ6ypK4w3uV00aE=";
    };
    buildInputs = [
      libvirt
      libxml2
    ];
  };
}
