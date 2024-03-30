{ pkgs, flakeDir, ... }:

pkgs.writeShellScriptBin "generateListBindings" ''
flakeDir=${flakeDir}
bindings=$(cat "$flakeDir"/config/home/hyprland.nix | grep "bind*")
modifier='${modifier}'

IFS=$'\n'
flag="false"
newBindings=()
for line in $bindings; do
    mod=$(echo "$line" | cut -d "," -f 1 | cut -d "=" -f 2 | xargs)
    if [ "$mod" = "${modifier}" ] || [ "$mod" = "${modifier}SHIFT" ]; then
	key=$(echo "$line" | cut -d "," -f 2 )
	if [ "$mod" = '${modifier}' ] && [ "$key" = "W" ]; then
	  if [ "$flag" = "false" ]; then
	    newBindings+=("\"  + W\" \"Launch Browser\" \\");
	    flag="true";
	  fi
	fi
	desc=$(echo "$line" | cut -d "#" -f 2 )
	chk=$(echo "$desc" | cut -d "=" -f 1 | xargs)
	if [ "$chk" != "bind" ]; then
	  if [ "$mod" = '${modifier}' ]; then
	    newBindings+=("\"  + $key\" \"$desc\" \\")
	  else
	    newBindings+=("\"  + SHIFT + $key\" \"$desc\" \\")
	  fi;
	fi;
    else
        continue
    fi
done

cat <<EOF > "$flakeDir"/home/scripts/test.nix
{ pkgs, ... }:

let
  inherit ( import ../../options.nix ) terminal browser;
in
pkgs.writeShellScriptBin "list-hypr-bindings" ''
  yad --width=800 --height=650 \\
  --center \\
  --fixed \\
  --title="Hyprland Keybindings" \\
  --no-buttons \\
  --list \\
  --column=Key: \\
  --column=Description: \\
  --timeout=60 \\
  --timeout-indicator=right \\
EOF

for bind in "${newBindings[@]}"; do
  echo "  $bind" >> "$flakeDir"/home/scripts/test.nix
done

echo "  \"ALT + TAB\" \"Cycle Window Focus + Bring To Front\" \\" >> "$flakeDir"/home/scripts/test.nix
echo "\"\"" >> "$flakeDir"/home/scripts/test.nix
echo "''" >> "$flakeDir"/home/scripts/test.nix
''
