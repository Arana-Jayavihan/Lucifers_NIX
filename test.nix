{ pkgs, ... }:

let
  inherit ( import ../../options.nix ) terminal browser;
in
pkgs.writeShellScriptBin "list-hypr-bindings" ''
  yad --width=800 --height=650 \
  --center \
  --fixed \
  --title="Hyprland Keybindings" \
  --no-buttons \
  --list \
  --column=Key: \
  --column=Description: \
  --timeout=60 \
  --timeout-indicator=right \
  "  + Return" "Launch Terminal" \
  "  + SHIFT + Return" "Rofi App Launcher" \
  "  + SHIFT + W" "Simple Wallpaper Selector" \
  "  + W" "Launch Browser" \
  "  + E" "Emoji Picker" \
  "  + S" "Take Screenshot" \
  "  + D" "Discord" \
  "  + O" "OBS" \
  "  + T" "Thunar" \
  "  + M" "Spotify" \
  "  + SHIFT + L" "Lock Screen" \
  "  + SHIFT + O" "Launch Color Picker" \
  "  + SHIFT + A" "Launch Waydroid" \
  "  + SHIFT + N" "Open NixOS Search" \
  "  + SHIFT + X" "Show Power Menu" \
  "  + SHIFT + T" "Launch Teams" \
  "  + SHIFT + G" "Open GitHub" \
  "  + G" "Open ChatGPT" \
  "  + Q" "Kill Active Window" \
  "  + P" "Pseudo Tiling" \
  "  + SHIFT + I" "Toggle Split Direction" \
  "  + F" "Toggle Fullscreen" \
  "  + SHIFT + F" "Toggle Floating Window" \
  "  + SHIFT + left" "Move Window Left" \
  "  + SHIFT + right" "Move Window Right" \
  "  + SHIFT + up" "Move Window Up" \
  "  + SHIFT + down" "Move Window Down" \
  "  + left" "Move Focus To Window On The Left" \
  "  + right" "Move Focus To Window On The Right" \
  "  + up" "Move Focus To Window On The Above" \
  "  + down" "Move Focus To Window On The Below" \
  "  + 1" "Move To Workspace 1" \
  "  + 2" "Move To Workspace 2" \
  "  + 3" "Move To Workspace 3" \
  "  + 4" "Move To Workspace 4" \
  "  + 5" "Move To Workspace 5" \
  "  + 6" "Move To Workspace 6" \
  "  + 7" "Move To Workspace 7" \
  "  + 8" "Move To Workspace 8" \
  "  + 9" "Move To Workspace 9" \
  "  + 0" "Move To Workspace 10" \
  "  + SHIFT + SPACE" "Move To Special Workspace" \
  "  + SPACE" "Toggle Special Workspace" \
  "  + SHIFT + 1" "Move Focus Window To Workspace 1" \
  "  + SHIFT + 2" "Move Focus Window To Workspace 2" \
  "  + SHIFT + 3" "Move Focus Window To Workspace 3" \
  "  + SHIFT + 4" "Move Focus Window To Workspace 4" \
  "  + SHIFT + 5" "Move Focus Window To Workspace 5" \
  "  + SHIFT + 6" "Move Focus Window To Workspace 6" \
  "  + SHIFT + 7" "Move Focus Window To Workspace 7" \
  "  + SHIFT + 8" "Move Focus Window To Workspace 8" \
  "  + SHIFT + 9" "Move Focus Window To Workspace 9" \
  "  + SHIFT + 0" "Move Focus Window To Workspace 10" \
  "  + mouse_down" "Move To Next Workspace" \
  "  + mouse_up" "Move To Previous Workspace" \
  "  + mouse:272" "Move Window" \
  "  + mouse:273" "Resize Window" \
  "  + SHIFT + R" "Reload SwayNC Styling" \
  "ALT + TAB" "Cycle Window Focus + Bring To Front" \
""
''
