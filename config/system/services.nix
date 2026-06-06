{ pkgs, config, lib, username, opt, ... }:

let inherit (opt) laptop; in
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
  services.logind.settings.Login.HandleLidSwitchExternalPower = lib.mkIf laptop "ignore";
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
    enable = false;
    package = pkgs.twingate;
  };
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;
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
  };
  services.resolved = {
    enable = false;
    settings.Resolve = {
      Domains = [ "~." ];
      DNS = "1.1.1.1";
      DNSSEC = "true";
      DNSOverTLS = "true";
      FallbackDNS = [ "165.22.52.204" ];
    };
  };
  services.udev = {
    enable = true;
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0495", ATTR{idProduct}=="3042", RUN+="/bin/sh -c '/etc/profiles/per-user/${username}/bin/usbDAC'"
    '';
  };

  services.pulseaudio.enable = false;

  services.cloudflare-warp = {
    enable = true;
  };
  
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.input = {
    General = {
      IdleTimeout = 3600;
      ClassicBondedOnly = false;
    };
  };
  
  security.rtkit.enable = true;
  security.pam.services.hyprlock = {};
  security.pam.services.swaylock = {};

  # Systemd Timers (laptop-only: battery monitoring)
  systemd.timers."batteryNotify" = lib.mkIf laptop {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "3m";
      OnUnitActiveSec = "3m";
      Unit = "batteryNotify.service";
    };
  };

  # Battery Notify Service (laptop-only)
  systemd.services."batteryNotify" = lib.mkIf laptop {
    script = ''
      set -eu
      /etc/profiles/per-user/${username}/bin/batteryNotify
    '';
    serviceConfig = {
      Type = "oneshot";
      User = username;
    };
  };

}

