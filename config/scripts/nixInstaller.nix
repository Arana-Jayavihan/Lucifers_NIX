{ pkgs, flakeDir }:

pkgs.writeShellScriptBin "nixInstall" ''
printHelp () {
  printf "
This is a simple package installer script for my NixOS flake
Since I'm lazy to edit the system.nix file everytime, I created
This simple script to automate the package installation.

Please make sure that the package name is correct by serching it in the NixOS Search.

****IMPORTANT****
Restore option can only restore to the previous version, 
so if you ended up installing multiple faulty packages
you might want to manually edit the system.nix to remove 
the faulty packages and rebuild the system manually.

Usage
[+] Install Packages\tnixInstaller system||user <package1> <package2>
[+] Restore to previous\tnixInstaller restore
"
}

addPkgs () {
  if [ "$2" != "user" ] && [ "$2" != "system" ];
  then
    sed -i "s/"$1"/"pkgs.$pkg\\n\\t$1"/" test.nix 
  else
    return
  fi
}

if [ "$1" == 0 ];
then
  echo "Please chose the package to installed is a system package or user package";
  printHelp
  exit 1
elif [ "$1" == "restore" ]
then
  cp ${flakeDir}/system.nix.bak ${flakeDir}/system.nix
  exit 0
else
  if [ "$2" == 0 ];
  then
    echo "No packages specified"
    printHelp;
    exit 1
  else
    cp ${flakeDir}/system.nix ${flakeDir}/system.nix.bak ;
    if [ "$1" == "user" ];
    then
      for pkg in "$@";
      do
	addPkgs "#USER_PKG" "$pkg"
      done
      #sudo nixos-rebuild switch --flake ${flakeDir}
    elif [ "$1" == "system" ];
    then
      for pkg in "$@";
      do
	addPkgs "#SYSTEM_PKG" "$pkg"
      done 
      #sudo nixos-rebuild switch --flake ${flakeDir}
    elif [ "$1" == "--help" ] || [ "$1" == "-h" ];
    then
      printHelp
    else
      echo "Package installation mode not found..."
      printHelp
      exit 1
    fi
  fi
fi
''
