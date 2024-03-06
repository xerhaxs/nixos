{ config, libs, pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme = "kde";
    style.package = pkgs.catppuccin-kde.override {
      accents = [ "mauve" ];
      flavour = [ "mocha" ];
      winDecStyles = [ "modern" ];
    };
    #style.name = "catppuccin-mocha-kde";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        tweaks = [ "rimless" "normal" ];
        variant = "mocha";
      };
    };

    iconTheme = {
      name = "papirus-icon-theme";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
  };
}
