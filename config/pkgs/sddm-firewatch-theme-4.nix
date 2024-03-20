{ stdenv, fetchzip }:
{
  sddm-firewatch-theme-4 = stdenv.mkDerivation rec {
    pname = "firewatch-sddm-theme-4";
    version = "initial";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/firewatch4
    '';
    src = fetchzip {
      url = "https://github.com/Arana-Jayavihan/firewatch-sddm-theme/archive/refs/tags/V3.zip";
      hash = "sha256-A3c0rBr+XEtqvyF/Jp1LU69wPd0/ZyoBj5+NqmX6HVs=";
    };
  };
}
