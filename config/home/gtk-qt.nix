{ pkgs, config, inputs, ... }:

let
  # Built from the system pkgs (which carries the dart-sass overlay).
  nixColorsContrib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
{
  # Configure Cursor Theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # Theme GTK
  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    theme = {
      name = "${config.colorScheme.slug}";
      package = nixColorsContrib.gtkThemeFromScheme {scheme = config.colorScheme;};
    };
    # Keep applying the generated theme to GTK4 apps (legacy default;
    # silences the gtk.gtk4.theme deprecation warning on stateVersion < 26.05).
    gtk4.theme = config.gtk.theme;
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };
  };

  # Theme QT -> GTK
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt6;
    };
  };
}
