{ catppuccin, config, lib, osConfig, pkgs, ... }:

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
in

{
  imports = [
    catppuccin.homeManagerModules.catppuccin
  ];

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
    catppuccin.flavor = lib.strings.toLower "${osConfig.nixos.theme.catppuccin.flavor}";

    #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-frappe" (catppuccin-base16/frappe);
    #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-latte" latte;
    #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-macchiato" macchiato;
    #colorScheme = nix-colors.lib.schemeFromYAML "catppuccin-mocha" mocha;

    programs.plasma = lib.mkIf config.homeManager.desktop.desktopEnvironment.plasma6.plasma6.enable {
      workspace = {
        theme = "default"; # plasma-apply-desktoptheme --list-themes
        colorScheme = "Catppuccin${osConfig.nixos.theme.catppuccin.flavor}${osConfig.nixos.theme.catppuccin.accent}"; # plasma-apply-colorscheme --list-schemes
        cursor.theme = "Catppuccin-${osConfig.nixos.theme.catppuccin.flavor}-${osConfig.nixos.theme.catppuccin.prefer}-Cursors"; # plasma-apply-cursortheme --list-themes
        lookAndFeel = "Catppuccin-${osConfig.nixos.theme.catppuccin.flavor}-${osConfig.nixos.theme.catppuccin.accent}"; # plasma-apply-lookandfeel --list
        iconTheme = "Papirus-${osConfig.nixos.theme.catppuccin.prefer}";
      };
      
      configFile = {
        "kdeglobals"."General"."ColorScheme" = "Catppuccin${osConfig.nixos.theme.catppuccin.flavor}${osConfig.nixos.theme.catppuccin.accent}";
        "katerc"."KTextEditor Renderer"."Color Theme" = "Catppuccin ${osConfig.nixos.theme.catppuccin.flavor}";
      };
    };

    qt = {
      enable = true;
      #platformTheme.name = "kde";
      style.package = pkgs.catppuccin-kde.override {
        accents = map (str: lib.strings.toLower str) [ "${osConfig.nixos.theme.catppuccin.accent}" ];
        flavour = map (str: lib.strings.toLower str) [ "${osConfig.nixos.theme.catppuccin.flavor}" ];
        winDecStyles = map (str: lib.strings.toLower str) [ "${osConfig.nixos.theme.catppuccin.winDecStyles}" ];
      };
      #style.name = "catppuccin-${osConfig.nixos.theme.catppuccin.flavor}-kde";
    };

    gtk = {
      enable = true;
      theme = {
        name = lib.strings.toLower "Catppuccin-${osConfig.nixos.theme.catppuccin.flavor}-${osConfig.nixos.theme.catppuccin.accent}-${osConfig.nixos.theme.catppuccin.prefer}+normal";
        package = pkgs.catppuccin-gtk.override {
          accents = map (str: lib.strings.toLower str) [ "${osConfig.nixos.theme.catppuccin.accent}" ];
          size = lib.strings.toLower "${osConfig.nixos.theme.catppuccin.size}";
          tweaks = map (str: lib.strings.toLower str) [ "${osConfig.nixos.theme.catppuccin.tweaks}" ];
          variant = lib.strings.toLower "${osConfig.nixos.theme.catppuccin.flavor}";
        };
      };

      iconTheme = {
        name = "Papirus-${osConfig.nixos.theme.catppuccin.prefer}";
        package = pkgs.papirus-icon-theme;
      };

      cursorTheme = {
        name = lib.strings.toLower "Catppuccin-${osConfig.nixos.theme.catppuccin.flavor}-${osConfig.nixos.theme.catppuccin.prefer}-Cursors";
        package = pkgs.catppuccin-cursors.${lib.strings.toLower "${osConfig.nixos.theme.catppuccin.flavor}" + "${osConfig.nixos.theme.catppuccin.prefer}"};
        size = 24;
      };

      gtk2 = {
        configLocation = "${config.home.homeDirectory}/.config/gtk-2.0/gtkrc";
        extraConfig = ''
          gtk-enable-animations = 1
          gtk-primary-button-warps-slider = 1
          gtk-toolbar-style = 3
          gtk-menu-images = 1
          gtk-button-images = 1
          gtk-sound-theme-name = "ocean"
        '';
      };

      gtk3.extraConfig = {
        Settings = lib.strings.toLower ''
          gtk-application-prefer-${osConfig.nixos.theme.catppuccin.prefer}-theme = 1
        '';
      };

      gtk4.extraConfig = {
        Settings = lib.strings.toLower ''
          gtk-application-prefer-${osConfig.nixos.theme.catppuccin.prefer}-theme = 1
        '';
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      name = lib.strings.toLower "Catppuccin-${osConfig.nixos.theme.catppuccin.flavor}-${osConfig.nixos.theme.catppuccin.prefer}-Cursors";
      package = pkgs.catppuccin-cursors.${lib.strings.toLower "${osConfig.nixos.theme.catppuccin.flavor}" + "${osConfig.nixos.theme.catppuccin.prefer}"};
      size = 24;
    };

    programs.vscode = {
      userSettings = {
        "workbench.colorTheme" = "Catppuccin ${osConfig.nixos.theme.catppuccin.flavor}";
      };
    };

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