{ stdenv, fetchzip }:
{
  sddm-firewatch-theme-2 = stdenv.mkDerivation rec {
    pname = "firewatch-sddm-theme-2";
    version = "initial";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/firewatch2
    '';
    src = fetchzip {
      url = "https://github.com/Arana-Jayavihan/firewatch-sddm-theme/archive/refs/tags/V2.zip";
      hash = "sha256-x2cNcDIGjgQ7DXvsQAWFoPZ+oVMTvanvH3pjcsyjSOk=";
    };
  };
}
