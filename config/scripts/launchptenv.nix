{ pkgs, ... }:

pkgs.writeShellScriptBin "ptenv" ''
  firefox-nightly -P Guest &
  burpsuite &
''
