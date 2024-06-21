{ stdenv, fetchgit, ... }:
{
  autopalette = stdenv.mkDerivation rec {
    pname = "autopalette";
    version = "v1";
    installPhase = ''
      mkdir -p $out/bin
      cp -aR $src $out/bin/autopalette
      echo $out
    '';
    src = fetchgit {
      url = "https://macoy.me/code/macoy/auto-base16-theme.git";
      hash = "sha256-jhfdB1eL25VRYh25qaSmT4jfEVztFld4CHwbM+xzKwg=";
    };
  };
}
