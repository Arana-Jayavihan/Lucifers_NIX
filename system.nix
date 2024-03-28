{ inputs, config, pkgs, username, hostname, pkgs-stable, ... }:

let 
  inherit (import ./options.nix) 
    theLocale theTimezone gitUsername
    theShell wallpaperDir wallpaperGit
    theLCVariables theKBDLayout flakeDir
    theme httpProxy socksProxy firewallPorts useFirewall;
in {
  imports =
    [
      ./hardware.nix
      ./config/system
    ];

  # Enable networking
  networking.hostName = "${hostname}"; # Define your hostname
  networking.networkmanager.enable = true;
  networking.proxy.default = "${socksProxy}";
  networking.proxy.allProxy = "${socksProxy}";
  networking.proxy.rsyncProxy = "${socksProxy}";
  networking.proxy.httpProxy = "${httpProxy}";
  networking.proxy.httpsProxy = "${httpProxy}";
  networking.proxy.ftpProxy = "${httpProxy}";

  networking.extraHosts = ''
  172.25.161.30 esp-psc.mitesp.local
  '';

  #Firewall
  networking.firewall.enable = useFirewall;
  networking.firewall.allowedTCPPorts = firewallPorts;

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
      packages = (with pkgs; [
        #USER_PKG
      ])
      ++
      (with pkgs-stable; [
        #USER_PKG_STABLE
      ]);
    };
  };

  environment.variables = {
    FLAKE = "${flakeDir}";
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  environment.systemPackages = (with pkgs; [
	pkgs.networkmanager-fortisslvpn
	pkgs.bun
	pkgs.go-ethereum
	pkgs.gcc
	pkgs.openssl
	pkgs.netcat
	pkgs.pavucontrol
	pkgs.pciutils
	pkgs.pulseeffects-legacy
	pkgs.plocate
	pkgs.gnupg
	pkgs.railway
	pkgs.ghidra
	pkgs.jdk
	pkgs.nmap
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
	pkgs.dig
	pkgs.stunnel
	pkgs.tcpdump
	pkgs.samba4Full
	pkgs.enum4linux-ng
	pkgs.openvpn
	pkgs.wireshark
	pkgs.zip
	pkgs.steghide
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
        pkgs.dbeaver
        #SYSTEM_PKG
      ])
      ++
      (with pkgs-stable; [
        anydesk
        #SYSTEM_PKG_STABLE
      ]);
 
  environment.etc."ppp/options".text = "ipcp-accept-remote";

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.vmware.host.enable = true;

  services.openssh.enable = true;

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
