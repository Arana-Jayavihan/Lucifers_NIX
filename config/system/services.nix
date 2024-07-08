{ pkgs, config, lib, ... }:

{
  # List services that you want to enable:
  services.openssh.enable = true;
  services.fstrim.enable = true;
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

  hardware.pulseaudio.enable = false;
  sound.enable = true;
  security.rtkit.enable = true;
  programs.thunar.enable = true;
  services.vnstat.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.settings = {
  	General = {
		Enable = "Source,Sink,Media,Socket";
	};
  };
  services.blueman.enable = true;
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
}
