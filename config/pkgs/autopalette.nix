{ pkgs, fetchgit, ... }:
{
  autopalette = pkgs.buildPythonPackage rec {
    pname = "autopalette";
    version = "v1";

    src = fetchgit {
      url = "https://macoy.me/code/macoy/auto-base16-theme.git";
    };
  };
}
