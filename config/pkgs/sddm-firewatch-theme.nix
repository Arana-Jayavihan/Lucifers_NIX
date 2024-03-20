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
      url = "https://github.com/Arana-Jayavihan/firewatch-sddm-theme/archive/refs/tags/V2.zip";
      hash = "sha256-x2cNcDIGjgQ7DXvsQAWFoPZ+oVMTvanvH3pjcsyjSOk=";
    };
  };
}