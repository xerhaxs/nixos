{ config, libs, pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme = "kde";
    style.package = pkgs.catppuccin-kde.override {
      accents = [ "blue" ];
      flavour = [ "latte" ];
      winDecStyles = [ "modern" ];
    };
    #style.name = "catppuccin-latte-kde";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Latte-Standard-Blue-Light";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "rimless" "normal" ];
        variant = "latte";
      };
    };

    iconTheme = {
      name = "papirus-icon-theme";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Catppuccin-Latte-Light-Cursors";
      package = pkgs.catppuccin-cursors.latteLight;
      size = 24;
    };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };
}
