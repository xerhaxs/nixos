{ config, lib, osConfig, pkgs, ... }:

let
  catppuccin-base16 = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "base16";
    rev = "master"; # commit hash or tag
    sha256 = ""; #sha256 = lib.fakeSha256;
  };
  frappe = "base16/frappe.yaml";
  latte = "base16/frappe.yaml";
  macchiato = "base16/macchiato.yaml";
  mocha = "base16/mocha.yaml";

  #vscode-theme = lib.strings.toUpper "(builtins.substring 0 1 ${osConfig.nixos.theme.catppuccin.flavor})" + "(lib.strings.substring 0 (builtins.stringLength ${osConfig.nixos.theme.catppuccin.flavor}) ${osConfig.nixos.theme.catppuccin.flavor})";
in

{
  options.homeManager = {
    theme.catppuccin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable catppuccin theme.";
      };
    };
  };

  config = lib.mkIf (osConfig.nixos.theme.catppuccin.enable && osConfig.nixos.theme.theme.colorscheme == "catppuccin") {
    #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-frappe" (catppuccin-base16/frappe);
    #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-latte" latte;
    #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-macchiato" macchiato;
    #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-mocha" mocha;

    #qt = {
      #enable = true;
      #platformTheme.name = "kde";
      #style.package = pkgs.catppuccin-kde.override {
      #  accents = [ "${osConfig.nixos.theme.catppuccin.accent}" ];
      #  flavour = [ "${osConfig.nixos.theme.catppuccin.flavor}" ];
      #  winDecStyles = [ "${osConfig.nixos.theme.catppuccin.winDecStyles}" ];
      #};
      #style.name = "catppuccin-mocha-kde";
    #};

    gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-${osConfig.nixos.theme.catppuccin.flavor}-${osConfig.nixos.theme.catppuccin.tweaks}-${osConfig.nixos.theme.catppuccin.accent}-${osConfig.nixos.theme.catppuccin.prefer}";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "${osConfig.nixos.theme.catppuccin.accent}" ];
          size = "${osConfig.nixos.theme.catppuccin.size}";
          tweaks = [ "${osConfig.nixos.theme.catppuccin.tweaks}" ];
          variant = "${osConfig.nixos.theme.catppuccin.flavor}";
        };
      };

      iconTheme = {
        name = "papirus-icon-theme";
        package = pkgs.papirus-icon-theme;
      };

      cursorTheme = {
        name = "Catppuccin-${osConfig.nixos.theme.catppuccin.flavor}-${osConfig.nixos.theme.catppuccin.prefer}-Cursors";
        package = pkgs.catppuccin-cursors."${osConfig.nixos.theme.catppuccin.flavor}${osConfig.nixos.theme.catppuccin.prefer}";
        size = 24;
      };

      gtk3.extraConfig = {
        Settings = lib.strings.toLower ''
          gtk-application-prefer-${osConfig.nixos.theme.catppuccin.prefer}-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = lib.strings.toLower ''
          gtk-application-prefer-${osConfig.nixos.theme.catppuccin.prefer}-theme=1
        '';
      };
    };

    #programs.vscode = {
    #  userSettings = {
    #    "workbench.colorTheme" = "Catppuccin";
    #  };
    #};

    programs.thunderbird = lib.mkIf config.homeManager.applications.communication.thunderbird.enable {
      settings = {
        "messenger.options.messagesStyle.variant" = "${osConfig.nixos.theme.catppuccin.prefer}";
      };
    };

    xdg.configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}