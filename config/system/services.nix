{ pkgs, config, lib, ... }:

{
  # List services that you want to enable:
  services.openssh.enable = true;
  services.fstrim.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [ pkgs.xdg-desktop-portal-gtk
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
#    socketActivation = true;
    jack.enable = true;
#    wireplumber.enable = true;
#    extraConfig.pipewire = {
#	"92-low-latency" = {
#		context.properties = {
#    		default.clock.rate = 96000;
#		default.clock.allowed-rates = [ 44100 48000 88200 96000 192000 ];
#	    	default.clock.quantum = 1024;
#    		default.clock.min-quantum = 1024;
#  		default.clock.max-quantum = 1024;
#  		};
#	};
#    };
#    extraConfig.pipewire = {
#	"10-clock-rate" = {
#    		"context.properties" = {
#      			"default.clock.rate" = 96000;
#    			};
#  		};	
#  	};
#    extraConfig.pipewire-pulse."92-low-latency" = {
#  	context.modules = [
#    		{
#      			name = "libpipewire-module-protocol-pulse";
#      			args = {
#        			pulse.min.req = "1024/96000";
#			        pulse.default.req = "1024/96000";
#			        pulse.max.req = "1024/96000";
#			        pulse.min.quantum = "1024/96000";
#			        pulse.max.quantum = "1024/96000";
#				audio.channels = 2;
#				audio.position = "[ FL FR ]";
#		       };
#    		}
#  	];
#  	stream.properties = {
#	    node.latency = "1024/96000";
#	    resample.quality = 10;
#	    resample-method = "speex-float-10";
# 	};
#     };
  };
#  hardware.pulseaudio.enable = false;
  sound.enable = true;
  security.rtkit.enable = true;
  programs.thunar.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.gnome.gnome-keyring.enable=true;
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
}
