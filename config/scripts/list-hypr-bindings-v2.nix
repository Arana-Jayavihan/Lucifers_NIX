{ pkgs, flakeDir, ... }:

let
  inherit ( import ../../options.nix ) terminal browser;
in
pkgs.writeShellScriptBin "list-hypr-bindings" ''
  bindings=$(cat "${flakeDir}"/config/home/hyprland.nix | grep "bind*")
  IFS=$'\n'
  flag="false"
  newBindings=""
  for line in $bindings; do
    mod=$(echo "$line" | cut -d "," -f 1 | cut -d "=" -f 2 | xargs)
    if [ "$mod" = "$\{modifier\}" ] || [ "$mod" = "$\{modifier\}SHIFT" ]; then
	key=$(echo "$line" | cut -d "," -f 2 )
	if [ "$mod" = '$\{modifier\}' ] && [ "$key" = "W" ]; then
	  if [ "$flag" = "false" ]; then
	    newBindings+="\"  + W\" \"Launch Browser\" ";
	    flag="true";
	  fi
	fi
	desc=$(echo "$line" | cut -d "#" -f 2 )
	chk=$(echo "$desc" | cut -d "=" -f 1 | xargs)
	if [ "$chk" != "bind" ]; then
	  if [ "$mod" = '$\{modifier\}' ]; then
	    newBindings+="\"  + $key\" \"$desc\" "
	  else
	    newBindings+="\"  + SHIFT + $key\" \"$desc\" "
	  fi;
	fi;
    else
        continue
    fi
  done
  echo "$newBindings";
''
