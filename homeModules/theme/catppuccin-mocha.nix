{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    theme.theme-mocha = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable theme mocha.";
      };
    };
  };

  config = lib.mkIf config.homeManager.theme.theme-mocha.enable {
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

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };

    programs.vscode = {
      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
      };
    };

    xdg.configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}
