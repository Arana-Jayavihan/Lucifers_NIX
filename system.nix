{ inputs, config, pkgs,
  username, hostname, ... }:

let 
  inherit (import ./options.nix) 
    theLocale theTimezone gitUsername
    theShell wallpaperDir wallpaperGit
    theLCVariables theKBDLayout flakeDir
    theme;
in {
  imports =
    [
      ./hardware.nix
      ./config/system
    ];

  # Enable networking
  networking.hostName = "${hostname}"; # Define your hostname
  networking.networkmanager.enable = true;
  networking.proxy.allProxy = "socks5://127.0.0.1:1080";
  networking.proxy.httpProxy = "http://127.0.0.1:1090";
  networking.proxy.httpsProxy = "http://127.0.0.1:1090";
  networking.proxy.rsyncProxy = "socks5://127.0.0.1:1080";
  
  networking.firewall.allowedTCPPorts = [ 1090 5000 9000 ];

  # Set your time zone
  time.timeZone = "${theTimezone}";

  # Select internationalisation properties
  i18n.defaultLocale = "${theLocale}";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${theLCVariables}";
    LC_IDENTIFICATION = "${theLCVariables}";
    LC_MEASUREMENT = "${theLCVariables}";
    LC_MONETARY = "${theLCVariables}";
    LC_NAME = "${theLCVariables}";
    LC_NUMERIC = "${theLCVariables}";
    LC_PAPER = "${theLCVariables}";
    LC_TELEPHONE = "${theLCVariables}";
    LC_TIME = "${theLCVariables}";
  };
  console.keyMap = "${theKBDLayout}";

  # Define a user account.
  users = {
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      hashedPassword = "$6$YdPBODxytqUWXCYL$AHW1U9C6Qqkf6PZJI54jxFcPVm2sm/XWq3Z1qa94PFYz0FF.za9gl5WZL/z/g4nFLQ94SSEzMg5GMzMjJ6Vd7.";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "audio" "pulse-access" ];
      shell = pkgs.${theShell};
      ignoreShellProgramCheck = true;
      packages = with pkgs; [];
    };
  };

  environment.variables = {
    FLAKE = "${flakeDir}";
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	pkgs.networkmanager-fortisslvpn
	pkgs.wl-clipboard
	pkgs.bun
	pkgs.go-ethereum
	pkgs.nodejs_20
	pkgs.git
	pkgs.wget
	pkgs.gcc
	pkgs.unrar
	pkgs.openssl
	pkgs.netcat
	pkgs.pavucontrol
	pkgs.pciutils
	pkgs.pulseeffects-legacy
	pkgs.plocate
	pkgs.gnupg
	pkgs.unzip
	pkgs.railway
	pkgs.ghidra
	pkgs.jdk
	pkgs.nmap
	pkgs.go
	pkgs.gobuster
	pkgs.metasploit
	pkgs.dex2jar
	pkgs.android-tools
	pkgs.file
	pkgs.xz
	pkgs.tshark
	pkgs.sshpass
	pkgs.motrix
	pkgs.inetutils
	pkgs.netdiscover
	pkgs.exiftool
	pkgs.hexedit
	pkgs.binwalk
	pkgs.thc-hydra
	pkgs.openfortivpn
	pkgs.socat
	pkgs.dig
	pkgs.stunnel
	pkgs.tcpdump
	pkgs.samba4Full
	pkgs.enum4linux-ng
	pkgs.openvpn
	pkgs.wireshark
	pkgs.zip
	pkgs.steghide
	pkgs.appimage-run
	pkgs.mangohud
	pkgs.lutris
	pkgs.protonup-qt
	pkgs.wine64
	pkgs.wineWowPackages.waylandFull
	pkgs.winetricks
	pkgs.wineWowPackages.stable
	pkgs.tcptraceroute
	pkgs.hyprpicker
	pkgs.libxcrypt
	pkgs.john
        pkgs.cava
        pkgs.firefox
  ];

  environment.etc."ppp/options".text = "ipcp-accept-remote";

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.vmware.host.enable = true;

  services.openssh.enable = true;

  networking.firewall.enable = false;

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.permittedInsecurePackages = [
	"nix-2.16.2"
  ];
  system.stateVersion = "23.11";
}
