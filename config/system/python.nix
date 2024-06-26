{ pkgs, lib, ... }:

let
  inherit (import ../../options.nix) python;
  my-python-packages = ps: with ps; [
    pandas
    numpy
    requests
    pip 
  ];
in lib.mkIf (python == true) {
  environment.systemPackages = with pkgs; [
    (pkgs.python3.withPackages my-python-packages)
  ];

}
