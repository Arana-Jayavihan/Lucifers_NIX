{ stdenv, fetchgit }:
{
  schemer = stdenv.mkDerivation rec {
    pname = "schemer";
    version = "v2";
    dontBuild = true;
    dontConfigure = true;

    src = fetchgit {
      leaveDotGit = true;
      url = "https://github.com/thefryscorer/schemer2";
    };

    buildPhase = ''
      cd $src
      go mod init schemer
      go mod tidy
      go build
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp schemer $out/bin/schemer
    '';
  };
}
