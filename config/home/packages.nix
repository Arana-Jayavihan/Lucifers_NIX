{ pkgs, config, username, ... }:

let 
  inherit (import ../../options.nix) 
    browser wallpaperDir wallpaperGit flakeDir useWallColors curWallPaper;
in {
  # Install Packages For The User
  home.packages = with pkgs; [
    pkgs."${browser}" discord libvirt swww grim slurp gnome.file-roller
    swaynotificationcenter rofi-wayland imv transmission-gtk mpv
    gimp obs-studio rustup audacity pavucontrol tree
    font-awesome swayidle neovide element-desktop swaylock-effects
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # Import Scripts
    (import ./../scripts/emopicker9000.nix { 
      inherit pkgs;
    })
    (import ./../scripts/task-waybar.nix { 
      inherit pkgs;
    })
    (import ./../scripts/squirtle.nix { 
      inherit pkgs;
    })
    (import ./../scripts/wallsetter.nix { 
      inherit pkgs; 
      inherit wallpaperDir;
      inherit username; 
      inherit wallpaperGit; })
    (import ./../scripts/themechange.nix { 
      inherit pkgs; 
      inherit flakeDir;
    })
    (import ./../scripts/theme-selector.nix { 
      inherit pkgs; 
    })
    (import ./../scripts/nvidia-offload.nix { 
      inherit pkgs;
    })
    (import ./../scripts/web-search.nix { 
      inherit pkgs;
    })
    (import ./../scripts/rofi-launcher.nix { 
      inherit pkgs;
    })
    (import ./../scripts/screenshootin.nix { 
      inherit pkgs;
    })
    (import ./../scripts/noproxyrun.nix { 
      inherit pkgs; 
    })
    (import ./../scripts/nixInstaller.nix { 
      inherit pkgs; 
      inherit flakeDir; 
    })
    (import ./../scripts/gituplink.nix { 
      inherit pkgs; 
      inherit flakeDir; 
    }) 
    (import ./../scripts/batteryNotify.nix { 
      inherit pkgs; 
    }) 
    (import ./../scripts/wall-selector.nix { 
      inherit pkgs; 
      inherit wallpaperDir; 
    })
    (import ./../scripts/wallChangeEnhanced.nix { 
      inherit pkgs; 
      inherit wallpaperDir; 
      inherit flakeDir;  
    })
    (import ./../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit flakeDir;
    })
    (import ./../scripts/refreshRateChange.nix {
      inherit pkgs;
      inherit flakeDir;
    })
    (import ./../scripts/autopalette.nix {
      inherit pkgs;
      inherit flakeDir;
    })
    (import ./../scripts/pyvenv.nix {
      inherit pkgs;
    })
  ];

  programs.gh.enable = true;
}
