{ pkgs, config, inputs, ... }:

{
  imports = [
    # Enable &/ Configure Programs
    ./alacritty.nix
    ./bash.nix
    ./gtk-qt.nix
    ./hyprland.nix
    ./kdenlive.nix
    ./kitty.nix
    ./neofetch.nix
    ./neovim.nix
    ./packages.nix
    ./rofi.nix
    ./starship.nix
    ./waybar.nix
    ./wlogout.nix
    ./swappy.nix
    ./swaylock.nix
    ./swaync.nix
    ./wezterm.nix
    ./zsh.nix
    ./fastfetch.nix
    ./spicetify.nix
    ./files.nix
    ./cava.nix
    ./vesktop.nix
    ./hypridle.nix
  ];
}
