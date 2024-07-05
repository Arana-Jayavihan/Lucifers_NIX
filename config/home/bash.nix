{ config, lib, pkgs, ... }:

let inherit (import ../../options.nix) flakeDir flakePrev 
	     hostname flakeBackup theShell; in
lib.mkIf (theShell == "bash") {
  # Configure Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    profileExtra = ''
      #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      #  exec Hyprland
      #fi
    '';
    initExtra = ''
      fastfetch
      if [ -f $HOME/.bashrc-personal ]; then
        source $HOME/.bashrc-personal
      fi
    '';
    sessionVariables = {
      FLAKEBACKUP = "${flakeBackup}";
      FLAKEPREV = "${flakePrev}";
    };
    shellAliases = {
      sv="sudo nvim";
      flake-rebuild="nh os switch --nom --hostname ${hostname}";
      flake-update="nh os switch --nom --hostname ${hostname} --update";
      gcCleanup="nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      v="nvim";
      ls="lsd";
      ll="lsd -l";
      la="lsd -a";
      lal="lsd -al";
      ".."="cd ..";
      hell="ssh lucifer@165.22.52.204 -i /home/lucifer/Projects/cloudNix/sshPrivKey.pem";
      tunnel="~/Projects/sni-injector/start.sh";
      pyserver="python -m http.server";
      neofetch="neofetch --ascii ~/.config/ascii-neofetch";
      fastfetch="fastfetch -c ~/.config/fastfetch/config.jsonc";
      fuff="./usr/share/ffuf/ffuf";
      burp="cd /home/lucifer/Projects/burpsuite_pro_v2022.9; java -jar burploader.jar";
      jdgui="java -jar /usr/share/jdgui/jd-gui-1.6.6.jar";	
      ciao="killall5 -9 && shutdown -h now";
      wshow="waydroid show-full-ui";
      mitvpn="sudo openfortivpn --config /etc/openfortivpn/config";
      code="flatpak run com.visualstudio.code";
      reboot="killall5 -9 && shutdown -r now";
      config="cd ~/Lucifers_NIX/";	
      lock="swaylock --config ~/.config/swaylock/config"; 
      try="nix-shell -p ";
    };
  };
}
