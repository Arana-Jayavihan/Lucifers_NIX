{ pkgs, ... }:

{  
  home.file.".config/neovide/config.toml".text = ''
[font]
  normal = ["JetBrainsMono Nerd Font"] # Will use the bundled Fira Code Nerd Font by default
  size = 10

fork = true
frame = "full"
idle = true
maximized = false
neovim-bin = "${pkgs.neovim}/bin/nvim"
no-multigrid = false
srgb = false
tabs = true
theme = "auto"
title-hidden = false
vsync = true
wsl = false
'';
}
