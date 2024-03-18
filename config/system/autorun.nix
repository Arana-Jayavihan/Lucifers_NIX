{ pkgs, config, username, ... }:

let inherit (import ../../options.nix) wallpaperDir wallpaperGit; in
{
  # system.userActivationScripts = {
  #   gitwallpapers.text = ''
  #   '';
  # };
}
