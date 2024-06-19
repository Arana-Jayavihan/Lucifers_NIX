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
    172.25.161.30  esp-vcenter.mitesp.local
    172.25.161.34  esp-psc.mitesp.local
    165.22.52.204  simple-web.me
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
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "audio" "pulse-access" "qemu-libvirtd" "kvm" ];
      shell = pkgs.${theShell};
      ignoreShellProgramCheck = true;
      packages = (with pkgs; [
	#USER_PKG
      ])

      ++

      (with pkgs-stable; [
	textsnatcher
	hdparm
	nasm
	pwninit
	steam-run
	gef
	patchelf
	qbittorrent-qt5
	scrcpy
	sqlmap
	exploitdb
	apktool
	frida-tools
	virtiofsd
	spice-gtk
	#STABLE_USER
      ]);
    };
  };

  environment.variables = {
    FLAKE = "${flakeDir}";
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  environment.systemPackages = (with pkgs; [
        networkmanager-fortisslvpn
	bun
	go-ethereum
	gcc
	openssl
	netcat
	pavucontrol
	pciutils
	pulseeffects-legacy
	plocate
	gnupg
	railway
	ghidra
	jdk
	nmap
	gobuster
	metasploit
	dex2jar
	android-tools
	file
	tshark
	sshpass
	motrix
	inetutils
	netdiscover
	exiftool
	hexedit
	binwalk
	thc-hydra
	openfortivpn
	dig
	stunnel
	tcpdump
	samba4Full
	enum4linux-ng
	openvpn
	wireshark
	zip
	steghide
	mangohud
	lutris
	protonup-qt
	wine64
	wineWowPackages.waylandFull
	winetricks
	wineWowPackages.stable
	tcptraceroute
	hyprpicker
	libxcrypt
	john
        cava
        firefox
        dbeaver-bin
	#SYSTEM_PKG
      ])
    
      ++

      (with pkgs-stable; [
        android-studio
        xz 
	#STABLE_SYSTEM
      ]);
 
  environment.etc."ppp/options".text = "ipcp-accept-remote";

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.waydroid.enable = true;
#  virtualisation.vmware.host.enable = true;

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
    "python-2.7.18.7"
    "python"
  ];
  system.stateVersion = "23.11";
}
