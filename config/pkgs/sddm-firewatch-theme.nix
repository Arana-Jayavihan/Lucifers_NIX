{ stdenv, fetchzip }:
{
  sddm-firewatch-theme = stdenv.mkDerivation rec {
    pname = "firewatch-sddm-theme";
    version = "initial";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/firewatch
    '';
    src = fetchzip {
      url = "https://github.com/Arana-Jayavihan/firewatch-sddm-theme/archive/refs/tags/initial.zip";
      hash = "sha256-2d385492476211c23a792a41aa6cffccc24fc4f41c639dff4df5ec5f0e7a7b35";
    };
  };
}
