{ config, lib, pkgs, ... }:

let inherit (import ../../options.nix) flakeDir theShell hostname; in
lib.mkIf (theShell == "zsh") {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    profileExtra = ''
      #if [ -z "$DISPLAY" ] && [ "$XDG_VNTR" = 1 ]; then
      #  exec Hyprland
      #fi
    '';
    initExtra = ''
      zstyle ":completion:*" menu select
      zstyle ":completion:*" matcher-list "" "m:{a-z0A-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"
      if type nproc &>/dev/null; then
        export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)-1))"
      fi
      bindkey '^[[3~' delete-char                     # Key Del
      bindkey '^[[5~' beginning-of-buffer-or-history  # Key Page Up
      bindkey '^[[6~' end-of-buffer-or-history        # Key Page Down
      bindkey '^[[1;3D' backward-word                 # Key Alt + Left
      bindkey '^[[1;3C' forward-word                  # Key Alt + Right
      bindkey '^[[H' beginning-of-line                # Key Home
      bindkey '^[[F' end-of-line                      # Key End
      fastfetch
      if [ -f $HOME/.zshrc-personal ]; then
        source $HOME/.zshrc-personal
      fi
      eval "$(starship init zsh)"
    '';
    initExtraFirst = ''
      HISTFILE=~/.histfile
      HISTSIZE=1000
      SAVEHIST=1000
      setopt autocd nomatch
      unsetopt beep extendedglob notify
      autoload -Uz compinit
      compinit
    '';
    sessionVariables = {

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
      neofetch="neofetch --ascii ~/.config/ascii-neofetch";
      fastfetch="fastfetch -c ~/.config/fastfetch/config.jsonc";
      tunnel="~/Projects/sni-injector/start.sh";
      pyserver="python -m http.server";
      pyvenv="~/Projects/Scripts/pyvenv.sh";
      fuff="./usr/share/ffuf/ffuf";
      burp="cd /home/lucifer/Projects/burpsuite_pro_v2022.9; java -jar burploader.jar";
      jdgui="java -jar /usr/share/jdgui/jd-gui-1.6.6.jar";	
      ciao="killall5 -9 && shutdown -h now";
      wshow="waydroid show-full-ui";
      mitvpn="sudo openfortivpn --config /etc/openfortivpn/config";
      code="flatpak run com.visualstudio.code";
      reboot="killall5 -9 && shutdown -r now";
      config="cd ~/Lucifers_NIX/";	
      nixsearch="brave https://search.nixos.org/";
      lock="swaylock --config ~/.config/swaylock/config";
      rebuild="config && sudo nixos-rebuild switch --flake .";
      try="nix-shell -p ";
    };
  };
}
