{ config, pkgs, username, hostname, pkgs-unstable, opt, ... }:

let
  inherit (opt)
    theLocale theTimezone gitUsername
    theShell theLCVariables theKBDLayout flakeDir
    httpProxy socksProxy firewallPorts useFirewall;
    gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]);
in {
  imports =
    [
      # Per-host hardware is injected by the flake (hosts/<host>/hardware.nix)
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

  networking.nameservers = ["165.22.52.204"];

  #systemd.globalEnvironment = {
  #  HTTP_PROXY="${httpProxy}";
  #  HTTPS_PROXY="${httpProxy}";
  #  ALL_PROXY="${socksProxy}";
  #  RSYNC_PROXY="${socksProxy}";
  #  FTP_PROXY="${socksProxy}";
  #};

  networking.extraHosts = ''
    165.22.52.204  simple-web.me
  '';

  #Firewall
  networking.firewall.enable = useFirewall;
  networking.firewall.allowedTCPPorts = if useFirewall == true 
  then firewallPorts
  else [];

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
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "audio" "pulse-access" "qemu-libvirtd" "kvm" "wireshark" "video" ];
      shell = pkgs.${theShell};
      ignoreShellProgramCheck = true;
      packages = (with pkgs; [ 
	bun
	gcc
	openssl
	netcat
	gnupg
	railway
	ghidra
	jdk
	nmap
	gobuster
	metasploit
	dex2jar
	android-tools
	tshark
	inetutils
	netdiscover
	exiftool
	hexedit
	binwalk
	dig
	stunnel
	enum4linux-ng
	openvpn
	zip
	mangohud
	lutris
	protonup-qt
	wine64
	wineWow64Packages.waylandFull
	winetricks
	wineWow64Packages.stable
	tcptraceroute
	hyprpicker
        dbgate
        android-studio
	zed-editor
        gdk
        litemdview
	burpsuite
	awscli
	#STABLE_USER
      ])

      ++

      (with pkgs-unstable; [
        qbittorrent
        xz
        sysstat
        dmidecode
	textsnatcher
	hdparm
	pwninit
	gef
	patchelf
	scrcpy
	sqlmap
	exploitdb
	apktool
	frida-tools
	virtiofsd
	spice-gtk
	cbonsai
	peaclock
        anydesk
	nixpkgs-fmt
	csvlens
	postman
	marktext
	cava	
	jadx
	libguestfs
	wev
	postgresql_17
	vscode
	prisma
	screen
	jq
	tmux
        ungoogled-chromium
        ngrok
	#USER_PKG	
      ]);
    };
  };

  environment.variables = {
    FLAKE = "${flakeDir}";
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  environment.systemPackages = (with pkgs; [
        curl
        git
        pciutils
        wget
        file
        nasm
        inetutils
        tcpdump
        parted
        pulseaudioFull
        pavucontrol
        pulseeffects-legacy
        alsa-utils
        htop
        btop
        libvirt
        polkit_gnome
        lm_sensors
        unzip
        unrar
        libnotify
        v4l-utils
        ydotool
        wl-clipboard
        socat
        lsd
        lshw
        pkg-config
        meson
        gnumake
        ninja
        go
        nodejs_latest
        brightnessctl
        toybox
        virt-viewer
        swappy
        ripgrep
        appimage-run 
        networkmanagerapplet
        yad
        playerctl
        nh
        fastfetch
        libcec
        zoxide
	gparted
        aircrack-ng
        ntfs3g
        proxychains-ng
	#STABLE_SYSTEM 
      ])
    
      ++

      (with pkgs-unstable; [
        #SYSTEM_PKG
      ]);

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu-classic
      nerd-fonts.jetbrains-mono
      font-awesome
      noto-fonts-color-emoji
      material-icons
    ];
    fontDir = {
      enable = true;
    };
  };

  environment.shells = with pkgs; [ zsh ];
  environment.etc."ppp/options".text = "ipcp-accept-remote";

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.vmware.host.enable = false; 
  virtualisation.waydroid = {
    enable = true;
    package = pkgs-unstable.waydroid-nftables;
  };

 
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

  system.stateVersion = "23.11";
}
