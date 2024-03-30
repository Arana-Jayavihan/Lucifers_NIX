{ pkgs, flakeDir, ... }:

let
  inherit ( import ../../options.nix ) terminal browser;
  modifier = "\\$" + "\{" + "modifier" + "\}";
in
pkgs.writeShellScriptBin "list-hypr-bindings" ''
  bindings=$(cat "${flakeDir}"/config/home/hyprland.nix | grep "bind*")
  IFS=$'\n'
  newBindings=""
  for line in $bindings; do
    mod=$(echo "$line" | cut -d "," -f 1 | cut -d "=" -f 2 | xargs)
    if [ "$mod" = "${modifier}" ] || [ "$mod" = "${modifier}SHIFT" ] || [ "$mod" = "${modifier}CONTROL" ] ; then
	key=$(echo "$line" | cut -d "," -f 2 )       
	desc=$(echo "$line" | cut -d "#" -f 2 )
	chk=$(echo "$desc" | cut -d "=" -f 1 | xargs)
	if [ "$chk" != "bind" ]; then
          if [ "$mod" = "${modifier}" ]; then
            if [ "$key" = "W" ]; then
              newBindings+="\"  + W\" \"Launch ${browser}\" ";
            elif [ "$key" = "Return" ]; then
              newBindings+="\"  + Return\" \"Launch ${terminal}\" ";
            elif [ "$key" = "mouse:272" ]; then
              newBindings+="\"  + Left Click\" \"Move Window\" ";
            elif [ "$key" = "mouse:273" ]; then
              newBindings+="\"  + Right Click\" \"Resize Window\" ";
            else
              newBindings+="\"  + $key\" \"$desc\" ";
            fi
	  elif [ "$mod" = "${modifier}SHIFT" ]; then
	    newBindings+="\"  + SHIFT + $key\" \"$desc\" ";
          elif [ "$mod" = "${modifier}CONTROL" ]; then
            newBindings+="\"  + CONTROL + $key\" \"$desc\" ";
	  fi;
	fi;
    else
      continue
    fi
  done

  eval "${pkgs.yad}/bin/yad --width=800 --height=650 --center --fixed --title=\"Hyprland Keybindings\" --list --column=Key: --column=Description: --timeout=120 --timeout-indicator=right \" = Windows/Super \" \"Modifier Key, used for keybindings\" $newBindings \"ALT + TAB\" \"Cycle Window Focus + Bring To Front\" \"\" ";
''
