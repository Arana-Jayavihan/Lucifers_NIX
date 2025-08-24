{ pkgs ? import <nixpkgs> {}, lib, ...}:

{
  androcontrol = pkgs.buildGoModule rec {
    pname = "androcontrol";
    version = "1.0";
  
    src = pkgs.fetchFromGitHub {
      owner = "Arana-Jayavihan";
      repo = "AndroControl"; 
      rev = "293932673e157dcfb1a65779cde10d1eff26a535";
      sha256 = "urgsjs8/aErlJmOk7di5e8OURSPmk1HLcrFlgHMBGx0=";
    };

    vendorHash = null;

    sourceRoot = "source/Backend-GO/";
 
    env.CGO_ENABLED = 1;

    meta = with lib; {
      description = "An android based linux HID device written in GO";
      homepage = "https://github.com/Arana-Jayavihan/AndroControl";
      maintainers = with maintainers; [ Arana-Jayavihan ];
    };
  };
}
