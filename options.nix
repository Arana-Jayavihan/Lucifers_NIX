let
  # THINGS YOU NEED TO CHANGE
  username = "lucifer";
  hostname = "nixos";
  userHome = "/home/${username}";
  flakeDir = "${userHome}/Lucifers_NIX";
  waybarStyle = "slickbar"; # simplebar, slickbar, or default
  proxy = true;
  socks = "1080";
  http = "1090";
in {
  # User Variables
  username = "lucifer";
  hostname = "nixos";
  gitUsername = "Arana Jayavihan";
  gitEmail = "aranajayavihan@gmail.com";
  theme = "ashes";
  slickbar = if waybarStyle == "slickbar" then true else false;
  simplebar = if waybarStyle == "simplebar" then true else false;
  bar-number = true; # Enable / Disable Workspace Numbers In Waybar
  borderAnim = true;
  browser = "brave";
  wallpaperGit = "https://github.com/Arana-Jayavihan/nix-wallpapers.git";
  # ^ (use as is or replace with your own repo - removing will break the wallsetter script) 
  wallpaperDir = "${userHome}/Projects/nix-wallpapers";
  screenshotDir = "${userHome}/Pictures/Screenshots";
  flakeDir = "${flakeDir}";
  flakePrev = "${userHome}/.LuciNix-previous";
  flakeBackup = "${userHome}/.LuciNix-backup";
  terminal = "kitty"; # This sets the terminal that is used by the hyprland terminal keybinding

  # System Settings
  clock24h = false;
  theLocale = "en_US.UTF-8";
  theKBDLayout = "us";
  theSecondKBDLayout = "de";
  theKBDVariant = "";
  theLCVariables = "en_US.UTF-8";
  theTimezone = "Asia/Colombo";
  theShell = "zsh"; # Possible options: bash, zsh
  theKernel = "zen"; # Possible options: default, latest, lqx, xanmod, zen
  sdl-videodriver = "x11"; # Either x11 or wayland ONLY. Games might require x11 set here
  # For Hybrid Systems intel-nvidia
  # Should Be Used As gpuType
  cpuType = "intel";
  gpuType = "intel";

  #Proxy Settings
  useProxy = proxy;
  socksProxy = if proxy == true then "socks5://127.0.0.1:${socks}" else "";
  httpProxy = if proxy == true then "http://127.0.0.1:${http}" else "";

  #Firewall Allowed TCP Ports
  useFirewall = true;
  firewallPorts = [ 1090 5000 9000 ];

  # Nvidia Hybrid Devices
  # ONLY NEEDED FOR HYBRID
  # SYSTEMS! 
  # intel-bus-id = "PCI:0:2:0";
  # nvidia-bus-id = "PCI:14:0:0";

  # Enable / Setup NFS
  nfs = false;
  nfsMountPoint = "/mnt/nas";
  nfsDevice = "nas:/volume1/nas";

  # NTP & HWClock Settings
  ntp = true;
  localHWClock = false;

  # Enable Printer & Scanner Support
  printer = true;

  # Enable Flatpak & Larger Programs
  distrobox = false;
  flatpak = true;
  kdenlive = true;
  blender = true;

  # Enable Support For
  # Logitech Devices
  logitech = true;

  # Enable Terminals
  # If You Disable All You Get Kitty
  wezterm = false;
  alacritty = false;
  kitty = true;

  # Enable Python & PyCharm
  python = true;
  
  # Enable SyncThing
  syncthing = false;

}
