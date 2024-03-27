{ pkgs, ... }:

pkgs.writeShellScriptBin "batteryNotify" ''
  capacity=$(cat /sys/class/power_supply/BAT0/capacity)
  state=$(cat /sys/class/power_supply/BAT0/status)
  if [[ $state = "Discharging" ]];
  then
    if [[ $capacity -lt 15 ]];
    then
      notify-send -u critical "Low Battery 🪫" "$capacity% remaining, please plugin to the charger.";
    fi
  fi
''
