{ pkgs, config, lib, inputs, ... }: 

let
  theme = config.colorScheme.palette;
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};
  inherit (import ../../options.nix) 
    browser cpuType gpuType
    wallpaperDir borderAnim
    theKBDLayout terminal curWallPaper
    theSecondKBDLayout gitUsername
    theKBDVariant sdl-videodriver autoWallChange;
in with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      #hyprplugins.hyprtrails
    ];
    extraConfig = let
      modifier = "SUPER";
    in concatStrings [ ''
      monitor=eDP-1,1920x1080,0x0,1,bitdepth,10
      monitor=HDMI-A-1,1920x1080@144,auto,1,bitdepth,10

      windowrule = fullscreen, ^(wlogout)$
      windowrule = animation fade,^(wlogout)$

      windowrulev2 = opacity 0.8 override 0.8 override,initialClass:^(.*)$

      windowrulev2 = opacity 0.75 override 0.75 override,initialClass:^(pulseeffects.*)$
      windowrulev2 = opacity 0.75 override 0.75 override,initialClass:^(pavucontrol.*)$
      windowrulev2 = opacity 0.75 override 0.75 override,initialClass:^(thunar.*)$
      windowrulev2 = opacity 0.75 override 0.75 override,initialClass:^(kitty.*)$

      windowrulev2 = opacity 1.0 override 1.0 override,title:^(.*YouTube.*)$
      windowrulev2 = opacity 1.0 override 1.0 override,title:^(.*HiAnime.*)$
      windowrulev2 = opacity 1.0 override 1.0 override,title:^(.*HollyMovieHD.*)$
      windowrulev2 = opacity 1.0 override 1.0 override,initialClass:^(.*VirtualBox.*)$ 
      windowrulev2 = opacity 1.0 override 1.0 override,initialClass:^(.*imv.*)$
      windowrulev2 = opacity 1.0 override 1.0 override,initialClass:^(.*org.kde.kdenlive.*)$ 
      windowrulev2 = opacity 1.0 override 1.0 override,initialClass:^(.*Waydroid.*)$ 

      general {
        gaps_in = 6
        gaps_out = 8
        border_size = 2
        col.active_border = rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg
        col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
        layout = dwindle
        resize_on_border = true
      }

      input {
        kb_layout = ${theKBDLayout}, ${theSecondKBDLayout}
	kb_options = grp:alt_shift_toggle
        #kb_options=caps:super
        follow_mouse = 1
        touchpad {
          natural_scroll = true
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        accel_profile = flat
      }
      env = NIXOS_OZONE_WL, 1
      env = NIXPKGS_ALLOW_UNFREE, 1
      env = XDG_CURRENT_DESKTOP, Hyprland
      env = XDG_SESSION_TYPE, wayland
      env = XDG_SESSION_DESKTOP, Hyprland
      env = GDK_BACKEND, wayland
      env = CLUTTER_BACKEND, wayland
      env = SDL_VIDEODRIVER, ${sdl-videodriver}
      env = QT_QPA_PLATFORM, wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
      env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
      env = MOZ_ENABLE_WAYLAND, 1
      ${if cpuType == "vm" then ''
        env = WLR_NO_HARDWARE_CURSORS,1
        env = WLR_RENDERER_ALLOW_SOFTWARE,1
      '' else ''
      ''}
      ${if gpuType == "nvidia" then ''
        env = WLR_NO_HARDWARE_CURSORS,1
      '' else ''
      ''}
      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 3
      }
      misc {
        mouse_move_enables_dpms = true
        key_press_enables_dpms = false
      }
      animations {
        enabled = yes
        bezier = wind, 0.05, 0.9, 0.1, 1.05
        bezier = winIn, 0.1, 1.1, 0.1, 1.1
        bezier = winOut, 0.3, -0.3, 0, 1
        bezier = liner, 1, 1, 1, 1
        animation = windows, 1, 6, wind, slide
        animation = windowsIn, 1, 6, winIn, slide
        animation = windowsOut, 1, 5, winOut, slide
        animation = windowsMove, 1, 5, wind, slide
        animation = border, 1, 1, liner
        ${if borderAnim == true then ''
          animation = borderangle, 1, 30, liner, loop
        '' else ''
        ''}
        animation = fade, 1, 10, default
        animation = workspaces, 1, 5, wind
      }
      decoration {
        rounding = 10
        drop_shadow = true
        fullscreen_opacity = 0.8
        blur {
            enabled = true
            size = 5
            passes = 3
            new_optimizations = on
            ignore_opacity = on
        }
      }
      plugin {
        hyprtrails {
          color = rgba(${theme.base0A}ff)
        }
      }
#      lock = swaylock -f
      exec-once = $POLKIT_BIN
      exec-once = dbus-update-activation-environment --systemd --all
      exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = swww init
      exec-once = waybar
      exec-once = swaync
      exec-once = swww img "${curWallPaper}"
      ${if autoWallChange == true then ''
      exec-once = wallsetter
      '' else ''
      ''}    
      exec-once = nm-applet --indicator
      exec-once = swayidle -w timeout 86400 'swaylock --image ~/.config/swaylock-bg.jpg --text-color FFCC33 --indicator-radius 100 --indicator-thickness 10 -e --show-failed-attempts --indicator-caps-lock --ring-color 161131 --key-hl-color c2303a --font UBUNTU --config ""' timeout 86000 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock --image ~/.config/swaylock-bg.jpg --text-color FFCC33 --indicator-radius 100 --indicator-thickness 10 -e --show-failed-attempts --indicator-caps-lock --ring-color 161131 --key-hl-color c2303a --font UBUNTU --config ""'
      dwindle {
        pseudotile = true
        preserve_split = true
      }
      master {
        new_status = master
      }
      bind = ${modifier},Return,exec,${terminal}          #Launch Terminal
      bind = ${modifier}SHIFT,Return,exec,rofi-launcher   #Rofi App Launcher
      bind = ${modifier}SHIFT,W,exec,wallSelector         #Simple Wallpaper Selector
      ${if browser == "google-chrome" then ''
	bind = ${modifier},W,exec,google-chrome-stable
      '' else ''
	bind = ${modifier},W,exec,${browser}
      ''}
      bind = ${modifier},E,exec,emopicker9000       #Emoji Picker
      bindl = ${modifier},S,exec,screenshootin       #Take Screenshot
      bind = ${modifier},D,exec,noproxyrun vesktop             #Discord
      bind = ${modifier},O,exec,obs                 #OBS
      bind = ${modifier},T,exec,thunar              #Thunar
      bind = ${modifier},M,exec, spotify             #Spotify
      bind = ${modifier}SHIFT,K,exec,scrcpy -m720 -b2M #Launch scrcpy cast
      bind = ${modifier}SHIFT,L,exec,swaylock --config ~/.config/swaylock/config     #Lock Screen
      bind = ${modifier}SHIFT,O,exec,hyprpicker -a -f hex     #Launch Color Picker
      bind = ${modifier}SHIFT,A,exec,waydroid show-full-ui    #Launch Waydroid
      bind = ${modifier}SHIFT,E,exec,VirtualBoxVM --startvm Windows10 --scaled    #Launch Windows
      bind = ${modifier}SHIFT,N,exec,${browser} https://search.nixos.org/    #Open NixOS Search
      bind = ${modifier}SHIFT,X,exec,wlogout    #Show Power Menu
      bind = ${modifier}SHIFT,T,exec,noproxyrun "flatpak run com.github.IsmaelMartinez.teams_for_linux" #Launch Teams
      bind = ${modifier}SHIFT,G,exec,${browser} https://github.com/${gitUsername}/  #Open GitHub
      bind = ${modifier}SHIFT,S,exec,com.github.rajsolai.textsnatcher #Launch OCR Clipboard
      bind = ${modifier},G,exec,${browser} https://chat.openai.com/    #Open ChatGPT
      bind = ${modifier},Q,killactive,    #Kill Active Window
      bind = ${modifier},P,pseudo,        #Pseudo Tiling
      bind = ${modifier}SHIFT,I,togglesplit,      #Toggle Split Direction
      bind = ${modifier},F,fullscreen,            #Toggle Fullscreen
      bind = ${modifier}SHIFT,F,togglefloating,   #Toggle Floating Window
      bind = ${modifier}SHIFT,left,movewindow,l   #Move Window Left
      bind = ${modifier}SHIFT,right,movewindow,r  #Move Window Right
      bind = ${modifier}SHIFT,up,movewindow,u     #Move Window Up
      bind = ${modifier}SHIFT,down,movewindow,d   #Move Window Down
      bind = ${modifier},left,movefocus,l         #Move Focus To Window On The Left
      bind = ${modifier},right,movefocus,r        #Move Focus To Window On The Right
      bind = ${modifier},up,movefocus,u           #Move Focus To Window On The Above
      bind = ${modifier},down,movefocus,d         #Move Focus To Window On The Below
      bind = ${modifier},1,workspace,1            #Move To Workspace 1
      bind = ${modifier},2,workspace,2            #Move To Workspace 2
      bind = ${modifier},3,workspace,3            #Move To Workspace 3
      bind = ${modifier},4,workspace,4            #Move To Workspace 4
      bind = ${modifier},5,workspace,5            #Move To Workspace 5
      bind = ${modifier},6,workspace,6            #Move To Workspace 6
      bind = ${modifier},7,workspace,7            #Move To Workspace 7
      bind = ${modifier},8,workspace,8            #Move To Workspace 8
      bind = ${modifier},9,workspace,9            #Move To Workspace 9
      bind = ${modifier},0,workspace,10           #Move To Workspace 10
      bind = ${modifier}SHIFT,SPACE,movetoworkspace,special     #Move To Special Workspace
      bind = ${modifier},SPACE,togglespecialworkspace           #Toggle Special Workspace
      bind = ${modifier}SHIFT,1,movetoworkspace,1       #Move Focus Window To Workspace 1
      bind = ${modifier}SHIFT,2,movetoworkspace,2       #Move Focus Window To Workspace 2
      bind = ${modifier}SHIFT,3,movetoworkspace,3       #Move Focus Window To Workspace 3
      bind = ${modifier}SHIFT,4,movetoworkspace,4       #Move Focus Window To Workspace 4
      bind = ${modifier}SHIFT,5,movetoworkspace,5       #Move Focus Window To Workspace 5
      bind = ${modifier}SHIFT,6,movetoworkspace,6       #Move Focus Window To Workspace 6
      bind = ${modifier}SHIFT,7,movetoworkspace,7       #Move Focus Window To Workspace 7
      bind = ${modifier}SHIFT,8,movetoworkspace,8       #Move Focus Window To Workspace 8
      bind = ${modifier}SHIFT,9,movetoworkspace,9       #Move Focus Window To Workspace 9
      bind = ${modifier}SHIFT,0,movetoworkspace,10      #Move Focus Window To Workspace 10
      bind = ${modifier}CONTROL,right,workspace,e+1     #Move To Next Workspace
      bind = ${modifier}CONTROL,left,workspace,e-1      #Move To Previous Woekspace
      bind = ${modifier},mouse_down,workspace, e+1      #Move To Next Workspace
      bind = ${modifier},mouse_up,workspace, e-1        #Move To Previous Workspace
      bindm = ${modifier},mouse:272,movewindow          #Move Window
      bindm = ${modifier},mouse:273,resizewindow        #Resize Window
      bind = ${modifier}SHIFT,R,exec,swaync-client -rs  #Reload SwayNC Styling 
      bind = ALT,Tab,cyclenext                          #Cycle Windows
      bind = ALT,Tab,bringactivetotop                   #Bring Active Window To Front
      bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = ,XF86AudioPlay, exec, playerctl play-pause
      bind = ,XF86AudioPause, exec, playerctl play-pause
      bind = ,XF86AudioNext, exec, playerctl next
      bind = ,XF86AudioPrev, exec, playerctl previous
      bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
      bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5% 
    '' ];
  };
}
