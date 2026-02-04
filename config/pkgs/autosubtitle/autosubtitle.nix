{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.python313Packages.buildPythonPackage rec {
  name = "autosubtitle";
  version = "1.0";
  src = ./.;
  pyproject = true;
  build-system = [ pkgs.python313Packages.setuptools ];

  propagatedBuildInputs = [ 
    pkgs.python313Packages.setuptools
    pkgs.python313Packages.openai-whisper
    pkgs.python313Packages.pyinstaller
    pkgs.python313Packages.ffmpeg-python
  ];

  nativeBuildInputs = [
    pkgs.ffmpeg_6-full
    pkgs.python313Packages.ffmpeg-python
  ];
}


