{ config, pkgs, inputs, username, nixColors, ... }:
let 
  inherit (import ./options.nix)
    gitUsername gitEmail theme browser 
    wallpaperDir wallpaperGit flakeDir 
    curWallPaper waybarStyle useWallColors;
in {
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Set The Colorscheme
  colorScheme = if useWallColors == false 
  then inputs.nix-colors.colorSchemes."${theme}"
  else nixColors.colorSchemeFromPicture {
    path = "${curWallPaper}";
    variant = "dark";
  };

  #colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  #colorScheme = nixColors.colorSchemeFromPicture {
  #  path = "${curWallPaper}";
  #  variant = "dark";
  #};

  # Import Program Configurations
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
    inputs.hyprland.homeManagerModules.default
    ./config/home
  ];

  # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };
  # Create XDG Dirs
  xdg = {
    userDirs = {
        enable = true;
        createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  programs.home-manager.enable = true;
}
