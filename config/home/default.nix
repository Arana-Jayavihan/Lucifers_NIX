{ pkgs, config, inputs, ... }:

{
  imports = [
    # Enable &/ Configure Programs
    ./alacritty.nix
    ./bash.nix
    ./gtk-qt.nix
    ./hyprland.nix   
    ./kitty.nix
    ./neofetch.nix
    ./neovim.nix
    ./packages.nix
    ./rofi.nix
    ./starship.nix
    ./wlogout.nix
    ./swappy.nix
    ./swaylock.nix
    ./swaync.nix
    ./wezterm.nix
    ./zsh.nix
    ./fastfetch.nix
    ./files.nix
    ./cava.nix
    ./vesktop.nix
    ./hypridle.nix
    ./firefox.nix
    ./spicetify.nix
  ];
}
