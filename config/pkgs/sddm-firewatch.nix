{ stdenv, fetchzip }:
{
  sddm-firewatch = stdenv.mkDerivation rec {
    pname = "firewatch-sddm";
    version = "V1";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sddm-firewatch
    '';
    src = fetchzip {
      url = "https://github.com/Arana-Jayavihan/firewatch-sddm-theme/archive/refs/tags/V6.zip";
      hash = "sha256-SGnQ2yL2yMe4tMrW6mVcYRLLzZS9Oayi4Zk/cPYSbxk=";
    };
  };
}
