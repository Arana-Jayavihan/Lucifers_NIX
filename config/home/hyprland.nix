{ pkgs, config, lib, inputs, opt, ... }:

let
  theme = config.colorScheme.palette;
  inherit (opt)
    browser cpuType gpuType borderAnim username userHome
    theKBDLayout terminal curWallPaper laptop
    theSecondKBDLayout gitUsername sdl-videodriver autoWallChange;

  # Monitor + workspace layout are defined per host in hosts/<host>/options.nix
  # so this file stays host-agnostic. We turn those attrsets into Lua calls here.
  monitors = opt.monitors or [ ];
  workspaceMonitors = opt.workspaceMonitors or { };

  renderLuaVal = v:
    if builtins.isString v then ''"${v}"''
    else if builtins.isBool v then (if v then "true" else "false")
    else toString v;

  mkMonitor = m:
    let
      pairs = lib.mapAttrsToList (k: v: "${k} = ${renderLuaVal v}")
        (lib.filterAttrs (_: v: v != null) m);
    in
    "hl.monitor({ ${lib.concatStringsSep ", " pairs} })";

  monitorLines = lib.concatMapStringsSep "\n" mkMonitor monitors;

  mkWorkspaceRules = monitor: ids:
    lib.concatMapStringsSep "\n"
      (id: ''hl.workspace_rule({ workspace = "${toString id}", monitor = "${monitor}" })'')
      ids;

  workspaceLines =
    lib.concatStringsSep "\n" (lib.mapAttrsToList mkWorkspaceRules workspaceMonitors);
in
with lib; {
  wayland.windowManager.hyprland = {
    # Hyprland 0.55+ uses Lua for its config (hyprlang is deprecated).
    # This writes ~/.config/hypr/hyprland.lua. See:
    # https://wiki.hypr.land/Configuring/Start/
    configType = "lua";
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      #pkgs.hyprlandPlugins.hyprtrails
    ];
    extraConfig =
      let
        modifier = "SUPER";
      in
      concatStrings [
        ''
          ------------------
          ---- MONITORS ----
          ------------------
          ${monitorLines}

          ----------------------
          ---- WINDOW RULES ----
          ----------------------
          hl.window_rule({ match = { title = "^(wlogout)$" }, fullscreen = true })
          hl.window_rule({ match = { title = "^(wlogout)$" }, animation = "fade" })

          hl.window_rule({ match = { initial_class = "^(.*)$" }, opacity = "0.8 override 0.8 override" })

          hl.window_rule({ match = { initial_class = "^(pulseeffects.*)$" }, opacity = "0.75 override 0.75 override" })
          hl.window_rule({ match = { initial_class = "^(pavucontrol.*)$" }, opacity = "0.75 override 0.75 override" })
          hl.window_rule({ match = { initial_class = "^(thunar.*)$" }, opacity = "0.75 override 0.75 override" })
          hl.window_rule({ match = { initial_class = "^(kitty.*)$" }, opacity = "0.75 override 0.75 override" })

          hl.window_rule({ match = { title = "^(.*YouTube.*)$" }, opacity = "1.0 override 1.0 override" })
          hl.window_rule({ match = { title = "^(.*YouTube.*)$" }, idle_inhibit = "focus" })
          hl.window_rule({ match = { title = "^(.*HiAnime.*)$" }, opacity = "1.0 override 1.0 override" })
          hl.window_rule({ match = { title = "^(.*HollyMovieHD.*)$" }, opacity = "1.0 override 1.0 override" })
          hl.window_rule({ match = { initial_class = "^(.*VirtualBox.*)$" }, opacity = "1.0 override 1.0 override" })
          hl.window_rule({ match = { initial_class = "^(.*imv.*)$" }, opacity = "1.0 override 1.0 override" })
          hl.window_rule({ match = { initial_class = "^(.*org.kde.kdenlive.*)$" }, opacity = "1.0 override 1.0 override" })
          hl.window_rule({ match = { initial_class = "^(.*Waydroid.*)$" }, opacity = "1.0 override 1.0 override" })

          -------------------------
          ---- WORKSPACE RULES ----
          -------------------------
          ${workspaceLines}

          -----------------------
          ---- LOOK AND FEEL ----
          -----------------------
          hl.config({
            general = {
              gaps_in = 4,
              gaps_out = 4,
              border_size = 2,
              col = {
                active_border = {
                  colors = { "rgba(${theme.base0C}ff)", "rgba(${theme.base0D}ff)", "rgba(${theme.base0B}ff)", "rgba(${theme.base0E}ff)" },
                  angle = 45,
                },
                inactive_border = {
                  colors = { "rgba(${theme.base00}cc)", "rgba(${theme.base01}cc)" },
                  angle = 45,
                },
              },
              layout = "dwindle",
              resize_on_border = true,
            },
          })

          hl.config({
            decoration = {
              rounding = 10,
              fullscreen_opacity = 1,
              blur = {
                enabled = true,
                size = 3,
                passes = 3,
                new_optimizations = true,
                ignore_opacity = true,
              },
              shadow = {
                enabled = false,
                render_power = 4,
                range = 4,
              },
            },
          })

          hl.config({
            misc = {
              mouse_move_enables_dpms = true,
              key_press_enables_dpms = false,
            },
          })

          ----------------
          ---- INPUT ----
          ----------------
          hl.config({
            input = {
              kb_layout = "${theKBDLayout}, ${theSecondKBDLayout}",
              kb_options = "grp:alt_shift_toggle",
              --kb_options = "caps:super",
              follow_mouse = 1,
              sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
              accel_profile = "flat",
              touchpad = {
                natural_scroll = true,
              },
            },
          })

          hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

          -------------------------------
          ---- ENVIRONMENT VARIABLES ----
          -------------------------------
          hl.env("NIXOS_OZONE_WL", "1")
          hl.env("NIXPKGS_ALLOW_UNFREE", "1")
          hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
          hl.env("XDG_SESSION_TYPE", "wayland")
          hl.env("XDG_SESSION_DESKTOP", "Hyprland")
          hl.env("GDK_BACKEND", "wayland")
          hl.env("CLUTTER_BACKEND", "wayland")
          hl.env("SDL_VIDEODRIVER", "${sdl-videodriver}")
          hl.env("QT_QPA_PLATFORM", "wayland")
          hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
          hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
          hl.env("MOZ_ENABLE_WAYLAND", "1")
          ${if cpuType == "vm" then ''
            hl.env("WLR_NO_HARDWARE_CURSORS", "1")
            hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")
          '' else ''
          ''}
          ${if gpuType == "nvidia" then ''
            hl.env("WLR_NO_HARDWARE_CURSORS", "1")
          '' else ''
          ''}

          --------------------
          ---- ANIMATIONS ----
          --------------------
          hl.config({ animations = { enabled = true } })

          hl.curve("wind", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
          hl.curve("winIn", { type = "bezier", points = { {0.1, 1.1}, {0.1, 1.1} } })
          hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1} } })
          hl.curve("liner", { type = "bezier", points = { {1, 1}, {1, 1} } })

          hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
          hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" })
          hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
          hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
          hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
          ${if borderAnim == true then ''
            hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", style = "loop" })
          '' else ''
          ''}
          hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
          hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })

          ------------------
          ---- LAYOUTS ----
          ------------------
          hl.config({ dwindle = { preserve_split = true } })
          hl.config({ master = { new_status = "master" } })

          -----------------
          ---- PLUGINS ----
          -----------------
          -- Applies once the hyprtrails plugin is enabled in `plugins` above.
          -- hl.config({ plugin = { hyprtrails = { color = "rgba(${theme.base0A}ff)" } } })

          -------------------
          ---- AUTOSTART ----
          -------------------
          hl.on("hyprland.start", function()
            hl.exec_cmd("$POLKIT_BIN")
            hl.exec_cmd("dbus-update-activation-environment --systemd --all")
            hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
            hl.exec_cmd("awww-daemon -q")
            hl.exec_cmd("hypridle")
            hl.exec_cmd("swaync")
            hl.exec_cmd("ags")
            hl.exec_cmd("amixer -c 0 set PCM 100% unmute")
            hl.exec_cmd("amixer -c 1 set PCM 100% unmute")
            hl.exec_cmd('notify-send "Hi ${username} 🍃" "Welcome Back  ʕっ•ᴥ•ʔっ"')
          ${if laptop == false then ''
            hl.exec_cmd("openrgb -p lucifer")
            hl.exec_cmd("spotify", { workspace = "8 silent" })
            hl.exec_cmd("kitty cava", { workspace = "8 silent" })
            hl.exec_cmd("${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver")
          '' else ''
            hl.exec_cmd("${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance")
          ''}
          ${if autoWallChange == true then ''
            hl.exec_cmd("wallsetter")
          '' else ''''}
            hl.exec_cmd("nm-applet --indicator")

            -- Custom Startup Apps
            hl.exec_cmd("kitty python ${userHome}/Projects/TCP-Over-SSL-Tunnel/main.py -c ${userHome}/Projects/TCP-Over-SSL-Tunnel/settings.ini", { workspace = "9 silent" })
            hl.exec_cmd("blueman-manager", { workspace = "9 silent" })    
          end)

          ---------------------
          ---- KEYBINDINGS ----
          ---------------------
          local mod = "${modifier}"

          hl.bind(mod .. " + Return", hl.dsp.exec_cmd("${terminal}"))          -- Launch Terminal
          hl.bind(mod .. " + F1", hl.dsp.exec_cmd("gamemode"))                 -- Toggle Game Mode
          ${if browser == "google-chrome" then ''
            hl.bind(mod .. " + W", hl.dsp.exec_cmd("google-chrome-stable")) -- Launch Browser
          '' else ''
            hl.bind(mod .. " + W", hl.dsp.exec_cmd("${browser}")) -- Launch Browser
          ''}
          hl.bind(mod .. " + E", hl.dsp.exec_cmd("emopicker9000"))             -- Emoji Picker
          hl.bind(mod .. " + S", hl.dsp.exec_cmd("screenshootin"), { locked = true }) -- Take Screenshot
          hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("noproxyrun vesktop")) -- Discord
          hl.bind(mod .. " + O", hl.dsp.exec_cmd("obs"))                       -- OBS
          hl.bind(mod .. " + T", hl.dsp.exec_cmd("kitty yazi"))               -- Yazi File Manager
          hl.bind(mod .. " + M", hl.dsp.exec_cmd("spotify"))                  -- Spotify
          hl.bind(mod .. " + B", hl.dsp.exec_cmd("noproxyrun brave"))         -- Brave - NOPROXY
          hl.bind(mod .. " + C", hl.dsp.exec_cmd("noproxyrun chromium-browser")) -- Chromium - NOPROXY
          hl.bind(mod .. " + G", hl.dsp.exec_cmd("${browser} https://chat.openai.com/")) -- Open ChatGPT
          hl.bind(mod .. " + P", hl.dsp.window.pseudo())                       -- Pseudo Tiling
          hl.bind(mod .. " + F", hl.dsp.window.fullscreen())                   -- Toggle Fullscreen
          hl.bind(mod .. " + Q", hl.dsp.window.close())                        -- Kill Active Window
          hl.bind(mod .. " + I", hl.dsp.exec_cmd("idle-inhibitor"))            -- Toggle Idle Inhibitor
          hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("reloadShell"))       -- Reload Shell
          hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("wallchange"))        -- Wallpaper Selector + Theme
          hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("list-hypr-bindings")) -- List Hyprland Binds
          hl.bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd("rofi-launcher")) -- Rofi App Launcher
          hl.bind(mod .. " + SHIFT + K", hl.dsp.exec_cmd("scrcpy -m720 -b2M")) -- Launch scrcpy cast
          hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("swaylock"))          -- Lock Screen
          hl.bind(mod .. " + SHIFT + O", hl.dsp.exec_cmd("hyprpicker -a -f hex")) -- Launch Color Picker
          hl.bind(mod .. " + SHIFT + A", hl.dsp.exec_cmd("waydroid show-full-ui")) -- Launch Waydroid
          hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("VirtualBoxVM --startvm Windows11 --scaled")) -- Launch Windows
          hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("${browser} https://search.nixos.org/")) -- Open NixOS Search
          hl.bind(mod .. " + SHIFT + X", hl.dsp.exec_cmd("wlogout"))           -- Show Power Menu
          hl.bind(mod .. " + SHIFT + T", hl.dsp.exec_cmd("thunar"))            -- Launch Thunar File Manager
          hl.bind(mod .. " + SHIFT + G", hl.dsp.exec_cmd("${browser} https://github.com/${gitUsername}/")) -- Open GitHub
          hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("com.github.rajsolai.textsnatcher")) -- Launch OCR Clipboard
          hl.bind(mod .. " + SHIFT + H", hl.dsp.exec_cmd("ptenv")) -- Launch Pentest Env (Firefox Nightly + Burp)
          hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("btledctl 01:33:FF:FF:FF:FF wheel")) -- Launch LED Wheel
          hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd([[kill -9 $(ps -eaf | grep firefox-nightly | head -1 | cut -d "r" -f 2 | xargs | cut -d " " -f 1 | xargs)]])) -- Kill Firefox
          hl.bind(mod .. " + SHIFT + I", hl.dsp.layout("togglesplit"))         -- Toggle Split Direction
          hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" })) -- Toggle Floating Window

          hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))  -- Move Window Left
          hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" })) -- Move Window Right
          hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))    -- Move Window Up
          hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))  -- Move Window Down

          hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))   -- Move Focus To Window On The Left
          hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))  -- Move Focus To Window On The Right
          hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))     -- Move Focus To Window On The Above
          hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))   -- Move Focus To Window On The Below

          -- Switch to workspace 1-10 with mod + [0-9], and move the active window with mod + SHIFT + [0-9]
          for i = 1, 10 do
            local key = i % 10 -- workspace 10 maps to key 0
            hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))         -- Switch To Workspace [1-0]
            hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i })) -- Move Window To Workspace [1-0]
          end

          hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.move({ workspace = "special" })) -- Move To Special Workspace
          hl.bind(mod .. " + SPACE", hl.dsp.workspace.toggle_special(""))      -- Toggle Special Workspace

          hl.bind(mod .. " + CONTROL + right", hl.dsp.focus({ workspace = "e+1" })) -- Move To Next Workspace
          hl.bind(mod .. " + CONTROL + left", hl.dsp.focus({ workspace = "e-1" }))  -- Move To Previous Workspace
          hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))      -- Scroll To Next Workspace
          hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))        -- Scroll To Previous Workspace

          hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })    -- Move Window
          hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })  -- Resize Window

          -- Cycle windows and bring the focused one to the front
          hl.bind("ALT + Tab", function() -- Cycle Window Focus + Bring To Front
            hl.dispatch(hl.dsp.window.cycle_next())
            hl.dispatch(hl.dsp.window.bring_to_top())
          end)

          -- Media and brightness keys
          hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")) -- Raise Volume
          hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")) -- Lower Volume
          hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { repeating = true }) -- Toggle Mute
          hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause")) -- Play/Pause Media
          hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause")) -- Play/Pause Media
          hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next")) -- Next Track
          hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous")) -- Previous Track
          hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-")) -- Decrease Brightness
          hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%")) -- Increase Brightness
        ''
      ];
  };
}
