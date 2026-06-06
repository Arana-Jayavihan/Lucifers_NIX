let
  # THINGS YOU NEED TO CHANGE
  username = "lucifer";
  userHome = "/home/${username}";
  flakeDir = "${userHome}/Lucifers_NIX";
  proxy = true;
  socks = "1080";
  http = "1090";
in {
  # NOTE: Host-specific options (hostname, cpuType, gpuType, bus-ids, theKernel,
  # gnome, ollama, browser, localHWClock) live in hosts/<host>/options.nix and
  # are merged on top of these shared defaults by the flake (delivered as `opt`).

  # User Variables
  username = username;
  gitUsername = "Arana-Jayavihan";
  gitEmail = "aranajayavihan@gmail.com";
  theme = "3024";
  borderAnim = false;
  autoWallChange = false;
  wallpaperGit = "https://github.com/Arana-Jayavihan/nix-wallpapers.git";
  # ^ (use as is or replace with your own repo - removing will break the wallsetter script)
  wallpaperDir = "${userHome}/Projects/nix-wallpapers";
  useWallColors = true;
  curWallPaper = "/home/lucifer/Projects/nix-wallpapers/wall95.jpg";
  screenshotDir = "${userHome}/Pictures/Screenshots";
  userHome = "${userHome}";
  flakeDir = "${flakeDir}";
  flakePrev = "${userHome}/.LuciNix-previous";
  flakeBackup = "${userHome}/.LuciNix-backup";
  terminal = "kitty"; # This sets the terminal that is used by the hyprland terminal keybinding

  # System Settings
  theLocale = "en_US.UTF-8";
  theKBDLayout = "us";
  theSecondKBDLayout = "de";
  theKBDVariant = "";
  theLCVariables = "en_US.UTF-8";
  theTimezone = "Asia/Colombo";
  theShell = "zsh"; # Possible options: bash, zsh
  sdl-videodriver = "x11"; # Either x11 or wayland ONLY. Games might require x11 set here

  #Proxy Settings
  useProxy = proxy;
  socksProxy = if proxy == true then "socks5://127.0.0.1:${socks}" else "";
  httpProxy = if proxy == true then "http://127.0.0.1:${http}" else "";

  #Firewall Allowed TCP Ports
  useFirewall = true;
  firewallPorts = [ 1090 5000 5050 5900 9000 ];

  # Enable / Setup NFS
  nfs = false;
  nfsMountPoint = "/mnt/nas";
  nfsDevice = "nas:/volume1/nas";

  # NTP Settings
  ntp = true;

  # Enable Printer & Scanner Support
  printer = true;

  # Enable GNOME desktop (shared: currently enabled on both hosts)
  gnome = true;

  # Enable Flatpak & Larger Programs
  distrobox = false;
  flatpak = true;

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
}
