{ pkgs, config, lib, pkgs-unstable, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      #pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-wlr 
    ];
    configPackages = [ 
      pkgs.xdg-desktop-portal-wlr 
      #pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };
 
  # List services that you want to enable:
  services.openssh.enable = true;
  services.fstrim.enable = true;
  services.vnstat.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.upower.enable = true;
  services.thermald.enable = false;
  services.hypridle.enable = true;
  services.mysql = {
    enable = false;
    package = pkgs.mysql84;
  };
  services.twingate = {
    enable = true;
    package = pkgs.twingate;
  };
  services.power-profiles-daemon.enable = true; 
  services.gnome.gnome-remote-desktop.enable = false;
  services.blueman.enable = true; 
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    pulse.enable = true;
    socketActivation = true;
    jack.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire = {
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = 44100;
          "default.clock.allowed-rates" = [ 24000 48000 96000 ];
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 8192;
          "default.clock.quantum" = 1024;
          "default.clock.quantum-limit" = 8192;
          "default.clock.quantum-floor" = 32;
        };
      };
    };
  };
  #services.pulseaudio = {
  #  enable = false;
  #  support32Bit = true;
  #  package = pkgs.pulseaudioFull;
  #  tcp = {
  #    enable = true;
  #  };
  #};
  services.resolved = {
    enable = false;
    dnssec = "true";
    dnsovertls = "true";
    fallbackDns = [ "165.22.52.204" ];
    extraConfig = ''
      Domains=~.
      DNS=1.1.1.1
    '';
  };
  services.udev = {
    enable = true;
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0495", ATTR{idProduct}=="3042", RUN+="/bin/sh -c '/etc/profiles/per-user/lucifer/bin/usbDAC'"
      SUBSYSTEMS=="usb|hidraw", ATTRS{idVendor}=="0db0", ATTRS{idProduct}=="0076", TAG+="uaccess", TAG+="MSI MYSTIC LIGHT"
    '';
  };

  services.pulseaudio.enable = false;

  services.cloudflare-warp = {
    enable = true;
  };

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = pkgs-unstable.openrgb-with-all-plugins;
  };

  hardware.enableAllFirmware = true;
  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.input = {
    General = {
      IdleTimeout = 3600;
      ClassicBondedOnly = false;
      ControllerMode = "bredr"; 
      Experimental = true;
      FastConnectable = true;
    };
    Policy = {
      AutoEnable = true;
    };
  };
  
  security.rtkit.enable = true;
  security.pam.services.hyprlock = {};
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Systemd Timers
  systemd.timers."batteryNotify" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "3m";
      OnUnitActiveSec = "3m";
      Unit = "batteryNotify.service";
    };
  };

  # Battery Notify Service
  systemd.services."batteryNotify" = {
    script = ''
      set -eu
      /etc/profiles/per-user/lucifer/bin/batteryNotify     
    '';   
    serviceConfig = {
      Type = "oneshot";
      User = "lucifer";
    };
  };

  # Idle Inhibitor Service
  systemd.user.services.idle-inhibit = {
    enable = true;
    unitConfig = {
      Description = "Idle Inhibitor (prevents suspend, idle, lid switch etc)";
    };

    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.systemd}/bin/systemd-inhibit \
          --what=idle:sleep:handle-power-key:handle-suspend-key:handle-hibernate-key:handle-lid-switch \
          --mode=block \
          --why="IdleInhibitorToggle" \
          sleep infinity
      '';
      Restart = "no";
    };

    wantedBy = [ "default.target" ];
  };
}
