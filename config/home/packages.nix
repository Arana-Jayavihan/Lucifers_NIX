{ pkgs, config, username, pkgs-unstable, opt, ... }:

let
  inherit (opt) wallpaperDir wallpaperGit flakeDir userHome;
in
{
  # Install Packages For The User
  home.packages = with pkgs; [
    #pkgs."${browser}"
    brave
    vesktop
    libvirt
    awww
    grim
    slurp
    swaynotificationcenter
    rofi
    imv
    mpv
    obs-studio
    rustup
    pavucontrol
    tree
    swaylock-effects

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
      inherit wallpaperGit;
    })
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
      inherit wallpaperGit;
      inherit username;
    })
    (import ./../scripts/list-hypr-bindings.nix {
      inherit pkgs;
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
    (import ./../scripts/rebuild.nix {
      inherit pkgs;
      inherit flakeDir;
      inherit userHome;
    })
    (import ./../scripts/mordor.nix {
      inherit pkgs;
      inherit flakeDir;
    })
    (import ./../scripts/gameMode.nix {
      inherit pkgs;
    })
    (import ./../scripts/reloadShell.nix {
      inherit pkgs;
    })
    (import ./../scripts/usbDAC.nix {
      inherit pkgs;
    })
    (import ./../scripts/idle-inhibitor.nix {
      inherit pkgs;
    })
    (import ./../scripts/claude.nix {
      inherit pkgs;
      inherit pkgs-unstable;
    })
    (import ./../scripts/androcontrol-qr.nix {
      inherit pkgs;
    })

  ];

  programs.gh.enable = true;
}
