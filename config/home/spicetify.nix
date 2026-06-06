{ pkgs, inputs, config, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  palette = config.colorScheme.palette;
in
{
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      playlistIcons
      historyShortcut
      adblock
      hidePodcasts
      shuffle
      fullAppDisplay
      volumePercentage
      history
    ];

    enabledCustomApps = with spicePkgs.apps; [
      newReleases
      lyricsPlus
      ncsVisualizer
    ];

    theme = spicePkgs.themes.catppuccin // {
      extraPkgs = [ pkgs.nerd-fonts.jetbrains-mono ];
      additionalCss = ''
        *:not([class*="icon"]):not([class*="Icon"]):not(.Svg):not(svg) {
          font-family: "JetBrainsMono Nerd Font", sans-serif !important;
        }
      '';
    };
    colorScheme = "custom";
    customColorScheme = {
      text = "${palette.base0D}";
      subtext = "${palette.base0B}";
      main = "${palette.base00}";
      main-elevated = "${palette.base00}";
      main-transition = "${palette.base01}";
      highlight = "${palette.base01}";
      highlight-elevated = "${palette.base00}";
      sidebar = "${palette.base00}";
      player = "${palette.base00}";
      card = "${palette.base02}";
      shadow = "${palette.base01}";
      selected-row = "${palette.base0B}";
      button = "${palette.base04}";
      button-active = "${palette.base07}";
      button-disabled = "${palette.base03}";
      tab-active = "${palette.base07}";
      notification = "${palette.base0B}";
      notification-error = "${palette.base06}";
      misc = "${palette.base02}";
      progress-fg = "${palette.base07}";
      progress-bg = "${palette.base00}";
      heart = "${palette.base07}";
      pagelink-active = "${palette.base04}";
      radio-btn-active = "${palette.base04}";
    };
  };
}
