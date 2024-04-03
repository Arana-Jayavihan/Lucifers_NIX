{ pkgs, flakeDir }:

pkgs.writeShellScriptBin "nixInstall" ''
printHelp () {
  printf "
This is a simple package installer script for my NixOS flake.
Since I'm lazy to edit the system.nix file every time, I created
this simple script to automate the package installation.

Please make sure that the package name is correct by searching it in the NixOS Search.

****IMPORTANT****
Restore option can only restore to the previous version, 
so if you ended up installing multiple faulty packages,
you might want to manually edit the system.nix to remove 
the faulty packages and rebuild the system manually.

Usage:
[+] Install Packages\t\tnixInstaller system||user||system-stable||user-stable <package1> <package2>
[+] Restore to previous\tnixInstaller restore
"
}

addPkgs () {
  if [ "$2" != "user" ] && [ "$2" != "system" ] && [ "$2" != "system-stable" ] && [ "$2" != "user-stable" ];
  then
    sed -i "s/$1/$2\\n\\t$1/" "${flakeDir}/system.nix"
  else
    return 1
  fi
}

if [ "$#" -eq 0 ]; then
  echo "Please specify the package installation mode and packages."
  printHelp
  exit 1
elif [ "$1" == "restore" ]; then
  cp "${flakeDir}/system.nix.bak" "${flakeDir}/system.nix"
  sudo nixos-rebuild switch --flake "${flakeDir}"
  exit 0
elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  printHelp
  exit 0
else
  cp "${flakeDir}/system.nix" "${flakeDir}/system.nix.bak"
  case "$1" in
    user)
      mode="#USER_PKG"
      ;;
    system)
      mode="#SYSTEM_PKG"
      ;;
    user-stable)
      mode="#STABLE_USER"
      ;;
    system-stable)
      mode="#STABLE_SYSTEM"
      ;;
    *)
      echo "Invalid package installation mode."
      printHelp
      exit 1
      ;;
  esac

  shift
  if [ "$#" -eq 0 ]; then
    echo "No packages specified."
    printHelp
    exit 1
  else
    for pkg in "$@"; do
      addPkgs "$mode" "$pkg" || {
        echo "Invalid package installation mode: $2"
        printHelp
        exit 1
      } 
    done 
    sudo nixos-rebuild switch --flake "${flakeDir}";
  fi
fi
''
