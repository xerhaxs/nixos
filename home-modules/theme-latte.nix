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
}
