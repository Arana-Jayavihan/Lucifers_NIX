{ inputs, username, pkgs, opt, ... }:
let
  inherit (opt)
    gitUsername gitEmail theme useWallColors;

  inherit (import ./config/home/files/autopalette/custom.nix) customPalette;
in
{
  #wayland.windowManager.hyprland.systemd.variables = ["--all"];
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  colorScheme =
    if useWallColors == false
    then inputs.nix-colors.colorSchemes."${theme}"
    else customPalette;

  # Import Program Configurations
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.nix-colors.homeManagerModules.default
    inputs.nixvim.homeModules.nixvim
    inputs.hyprland.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.spicetify
    ./config/home
  ];

  # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  programs.ags = {
    enable = true;
    configDir = ./config/home/files/ags;
    extraPackages = with pkgs; [
      bun
      gtksourceview
      webkitgtk_6_0
      accountsservice
    ];
  };

  # Install & Configure Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "${gitUsername}";
        email = "${gitEmail}";
      };
    };
  };
  # Create XDG Dirs
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox-nightly.desktop";
        "application/xhtml+xml" = "firefox-nightly.desktop";
        "x-scheme-handler/http" = "firefox-nightly.desktop";
        "x-scheme-handler/https" = "firefox-nightly.desktop";
        "x-scheme-handler/about" = "firefox-nightly.desktop";
        "x-scheme-handler/unknown" = "firefox-nightly.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  programs.home-manager.enable = true;
}
