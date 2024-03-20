{ stdenv, fetchzip }:
{
  sddm-firewatch-theme-6 = stdenv.mkDerivation rec {
    pname = "firewatch-sddm-theme-6";
    version = "V6";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/firewatch6
    '';
    src = fetchzip {
      url = "https://github.com/Arana-Jayavihan/firewatch-sddm-theme/archive/refs/tags/V6.zip";
      hash = "sha256-A3c0rBr+XEtqvyF/Jp1LU69wPd0/ZyoBj5+NqmX6HVs=";
    };
  };
}
