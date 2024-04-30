{ pkgs, flakeDir, ... }:

pkgs.writeShellScriptBin "rateChanger" ''
flakeDir=${flakeDir}
rate=$1
regex='^[0-9]+$'
if [ $# -eq 0 ]; then
  echo "please provide a refresh rate to apply"
  exit 1
fi
if [[ $rate =~ $regex ]]; then
  if [[ $rate -ge 60 && $rate -le 180 ]]; then
    sed -i "s/@[0-9]\+,/@$rate,/" $flakeDir/config/home/hyprland.nix
    rebuild
  else
    echo "Refresh Rate Not Within Limits (60Hz - 180Hz)";
  fi
else
  echo "Not an integer";
fi  
''
