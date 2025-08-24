{ pkgs, wallpaperDir, flakeDir, ... }:

pkgs.writeShellScriptBin "wallchange" ''
THEME="false"

wallpaperDir=${wallpaperDir}
flakeDir=${flakeDir}

function changeTheme {
  sed -i "s#curWallPaper = .*;#curWallPaper = \"$1\";#g" $flakeDir/options.nix
  sed -i "s/useWallColors = false;/useWallColors = $THEME;/g" $flakeDir/options.nix
  autopalette
  rm /home/lucifer/.mozilla/firefox/lucifer/search.json.mozlz4.backup
  rm /home/lucifer/.mozilla/firefox/Guest/search.json.mozlz4.backup
  rm /home/lucifer/.mozilla/firefox/lucifer-work/search.json.mozlz4.backup
  sudo nixos-rebuild switch --flake "$flakeDir"
  ${pkgs.swaynotificationcenter}/bin/swaync-client -rs
  ags -q
  ${pkgs.hyprland}/bin/hyprctl dispatch exec ags
  ledColor=$(cat $flakeDir/config/home/files/autopalette/custom.nix | grep -i "base08" | cut -d '"' -f 2 | xargs | cut -d '#' -f 2 | xargs)
  btledctl 01:33:FF:FF:FF:FF color --color $ledColor
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -t|--theme)
            THEME="$2"
            shift
            shift
            ;;
        *)
            WALLPAPER="$1"
            shift
            ;;
    esac
done

if [ "$THEME" != "true" ] && [ "$THEME" != "false" ]; then
    echo "Error: Invalid value for theme flag. Please use 'true' or 'false'."
    exit 1
fi

if [ "$THEME" = "true" ] && [ -z "$WALLPAPER" ]; then
    echo "Error: When theme is set to 'true', a wallpaper must be provided."
    exit 1
fi

if [ "$THEME" = "true" ] && [ -n "$WALLPAPER" ]; then
    wall=$(ls "$wallpaperDir" | grep -E "^wall$WALLPAPER(\..*)?$")
    wallPath=$(realpath "$wallpaperDir/$wall")
    changeTheme "$wallPath"
fi

if [ "$THEME" = "false" ] && [ -z "$WALLPAPER" ] ; then
    sed -i "s/useWallColors = true;/useWallColors = $THEME;/g" $flakeDir/options.nix;
    sudo nixos-rebuild switch --flake "$flakeDir";
    ${pkgs.swaynotificationcenter}/bin/swaync-client -rs
fi

if [ "$WALLPAPER" ]; then
    wall=$(ls "$wallpaperDir" | grep -E "^wall$WALLPAPER(\..*)?$")
    wallPath=$(realpath "$wallpaperDir/$wall")
    sed -i "s#curWallPaper = .*;#curWallPaper = \"$wallPath\";#g" $flakeDir/options.nix
    ${pkgs.swww}/bin/swww img "$wallpaperDir/$wall"
else
    echo "Use Wallpaper theme set to false"
    echo "No wallpaper specified."
fi

''
